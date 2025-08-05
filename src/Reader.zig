//! Using clang-c's Index API, parses a C++ header for later conversion to extern "C" compatible
//! elements.
//!
//! Overall the process is broken into a few steps, namely:
//! - Parse the file with `clang_parseTranslationUnit`.
//! - Using `clang_visitChildren`, iterate and recurse through the elements to form an AST.
//!     - In the process, convert into Zig types so as to not needlessly expose `@cImport`.
//!       Additionally, letting us have the data in a better, more correlated, usage format.
//! - Return the AST for further analysis or output by `write.zig`.

// -- Imports -- //

const std = @import("std");

const Allocator = std.mem.Allocator;

const c = @cImport({
    @cInclude("clang-c/Index.h");
});

const CXCursor = c.CXCursor;
const CXType = c.CXType;

// -- Constants -- //

const Reader = @This();

const log = std.log.scoped(.reader);

const ENABLE_TU_DIAGNOSTICS = true;

const REQUIRED_ARGUMENTS: []const [:0]const u8 = &.{"-xc++"};

const TU_FLAGS: c.CXTranslationUnit_Flags =
    c.CXTranslationUnit_SkipFunctionBodies;

// -- State -- //

arena: *std.heap.ArenaAllocator,
ast: AST,
opts: ParsingOptions,
err: ?anyerror = null,

current_namespace: ?usize = null,

// -- (De)initialization -- //

fn init(allocator: Allocator, opts: ParsingOptions) !Reader {
    const arena = try allocator.create(std.heap.ArenaAllocator);
    arena.* = .init(allocator);

    return .{
        .arena = arena,
        .ast = .{
            .namespaces = .init(arena.allocator()),
            .functions = .init(arena.allocator()),
            .structs = .init(arena.allocator()),
            .enums = .init(arena.allocator()),
            .closures = .init(arena.allocator()),
        },
        .opts = opts,
    };
}

fn deinit(reader: *const Reader) void {
    reader.arena.deinit();
}

// -- Parsing -- //

pub const ParsingOptions = struct {
    /// Log some sometimes useful stuff.
    verbose: bool = false,
};

fn convertArguments(allocator: Allocator, args: []const [:0]const u8) ![]const [*c]const u8 {
    const out = try allocator.alloc([*c]const u8, REQUIRED_ARGUMENTS.len + args.len);
    var i: usize = 0;
    for (REQUIRED_ARGUMENTS) |arg| {
        out[i] = arg.ptr;
        i += 1;
    }
    for (args) |arg| {
        out[i] = arg.ptr;
        i += 1;
    }
    return out;
}

pub fn parseFile(
    allocator: Allocator,
    file_path: [:0]const u8,
    clang_args: []const [:0]const u8,
    opts: ParsingOptions,
) !Reader {
    try std.fs.cwd().access(file_path, .{});
    log.info("Parsing '{s}'...", .{file_path});

    const args = try convertArguments(allocator, clang_args);

    const idx = c.clang_createIndex(0, if (ENABLE_TU_DIAGNOSTICS) 1 else 0);
    defer c.clang_disposeIndex(idx);

    const tu_opt = c.clang_parseTranslationUnit(
        idx,
        file_path.ptr,
        @ptrCast(args),
        @intCast(args.len),
        null,
        0,
        TU_FLAGS,
    );
    defer c.clang_disposeTranslationUnit(tu_opt);
    if (tu_opt == null) return error.FailedToParse;

    log.info("Successfully parsed '{s}'!", .{file_path});

    const cursor = c.clang_getTranslationUnitCursor(tu_opt);

    // ---

    var reader: Reader = try .init(allocator, opts);

    _ = c.clang_visitChildren(cursor, outerVisitor, @ptrCast(&reader));
    if (reader.err) |err| return err;

    {
        log.debug("Read completed!", .{});
        log.debug("Results: {} functions, {} structs, and {} enums.", .{
            reader.ast.functions.items.len,
            reader.ast.structs.count(),
            reader.ast.enums.count(),
        });

        log.debug("Functions:", .{});
        for (reader.ast.functions.items) |func| {
            log.debug("{f}", .{func});
        }

        log.debug("Structs:", .{});
        var struct_iter = reader.ast.structs.valueIterator();
        while (struct_iter.next()) |@"struct"| {
            log.debug("{f}", .{@"struct"});
        }

        log.debug("Enums:", .{});
        var enum_iter = reader.ast.enums.valueIterator();
        while (enum_iter.next()) |@"enum"| {
            log.debug("{f}", .{@"enum"});
        }
    }

    var err_where_the_type_go = false;
    for (reader.ast.functions.items) |func| {
        for (func.parameters.items, 0..) |param, i| {
            if (!param.type.exists(&reader.ast)) {
                log.err("Unknown type for argument #{} {f} of function '{s}'!", .{ i, param, func.name });
                err_where_the_type_go = true;
            }
        }
    }

    if (err_where_the_type_go) return error.WhereTheTypeGo;

    return reader;
}

// Visiting

fn outerVisitor(current_cursor: CXCursor, _: CXCursor, client_data_opaque: c.CXClientData) callconv(.c) c.CXVisitorResult {
    const reader: *Reader = @alignCast(@ptrCast(client_data_opaque));

    visitor(reader.arena.allocator(), current_cursor, reader) catch |e| {
        reader.err = e;
        return c.CXChildVisit_Break;
    };

    return c.CXChildVisit_Continue;
}

/// Visits all of the functions in the TU and records both the function itself and the types it uses.
fn visitor(allocator: std.mem.Allocator, cursor: CXCursor, reader: *Reader) !void {
    const name = try getCursorSpelling(allocator, cursor) orelse return error.InvalidCursorSpelling;

    switch (cursor.kind) {
        c.CXCursor_Namespace => {
            const parent = reader.current_namespace;

            try reader.ast.namespaces.append(.{ .name = name, .parent = parent });
            reader.current_namespace = reader.ast.namespaces.items.len - 1;
            defer reader.current_namespace = parent;

            log.debug("In namespace: {s}", .{try getNamespacePrefix(allocator, reader.current_namespace, &reader.ast)});
            _ = c.clang_visitChildren(cursor, outerVisitor, @ptrCast(reader));
        },
        c.CXCursor_FunctionDecl => try processFnDecl(allocator, cursor, reader),
        c.CXCursor_StructDecl => try processStructDecl(allocator, cursor, reader),
        c.CXCursor_EnumDecl => try processEnumDecl(allocator, cursor, reader),
        else => return,
    }
}

// Functions

fn processFnDecl(allocator: std.mem.Allocator, cursor: CXCursor, reader: *Reader) !void {
    const name = try getCursorSpelling(allocator, cursor) orelse return error.InvalidCursorSpelling;

    if (std.mem.startsWith(u8, name, "operator")) {
        log.debug("Skipping operator overload: '{s}'!", .{name});
        return;
    }

    const location = getCursorLocation(cursor);
    const raw_return_type = c.clang_getResultType(c.clang_getCursorType(cursor));
    const return_type = try CppType.from(allocator, reader, raw_return_type);

    log.debug("visiting fn '{s}': {s} [{}:{}]", .{
        name,
        try getTypeSpelling(allocator, raw_return_type) orelse "Unknown",
        location.line,
        location.column,
    });

    const arg_n: usize = @intCast(c.clang_Cursor_getNumArguments(cursor));
    var params = try std.ArrayList(CppTypeNamePair).initCapacity(allocator, arg_n);
    for (0..arg_n) |i| {
        const arg_cursor = c.clang_Cursor_getArgument(cursor, @intCast(i));
        const arg_name = try getCursorSpelling(allocator, arg_cursor) orelse return error.InvalidCursorSpelling;
        const raw_arg_type = c.clang_getCursorType(arg_cursor);

        log.debug("visiting fn decl param '{s}': {s}", .{
            arg_name,
            try getTypeSpelling(allocator, raw_arg_type) orelse "Unknown",
        });

        const arg_type = try CppType.from(allocator, reader, raw_arg_type);
        try params.append(.{ .name = arg_name, .type = arg_type });
    }

    const variadic = c.clang_Cursor_isVariadic(cursor) != 0;
    if (variadic) log.debug("fn is variadic", .{});

    const fn_decl = CppFunctionDecl{
        .name = name,
        .namespace = reader.current_namespace,
        .resolved_namespace_prefix = try getNamespacePrefix(allocator, reader.current_namespace, &reader.ast),
        .parameters = params,
        .return_type = return_type,
        .variadic = variadic,
    };

    try reader.ast.functions.append(fn_decl);
}

// Structs

fn processStructDecl(allocator: std.mem.Allocator, cursor: CXCursor, reader: *Reader) !void {
    const name = try getCursorSpelling(allocator, cursor) orelse return error.InvalidCursorSpelling;
    const location = getCursorLocation(cursor);
    const @"type" = c.clang_getCursorType(cursor);

    log.debug("visiting struct '{s}' [{}:{}]", .{
        name,
        location.line,
        location.column,
    });

    var fields = std.ArrayList(CppStructDecl.Field).init(allocator);
    var client_data = StructFieldVisitClientData{
        .allocator = allocator,
        .reader = reader,
        .out_fields = &fields,
    };

    _ = c.clang_Type_visitFields(@"type", outerVisitStructField, @ptrCast(&client_data));
    if (reader.err) |e| return e;

    const struct_decl = CppStructDecl{
        .size = @intCast(c.clang_Type_getSizeOf(c.clang_getCursorType(cursor))),
        .name = name,
        .location = location,
        .fields = fields,
    };

    try reader.ast.structs.put(name, struct_decl);
}

const StructFieldVisitClientData = struct {
    allocator: Allocator,
    reader: *Reader,
    out_fields: *std.ArrayList(CppStructDecl.Field),
};

fn outerVisitStructField(cursor: CXCursor, client_data_opaque: c.CXClientData) callconv(.c) c.CXVisitorResult {
    const client_data: *StructFieldVisitClientData = @alignCast(@ptrCast(client_data_opaque));

    const field = visitStructField(client_data.allocator, cursor, client_data.reader) catch |e| {
        client_data.reader.err = e;
        return c.CXChildVisit_Break;
    };

    client_data.out_fields.append(field) catch |e| {
        client_data.reader.err = e;
        return c.CXChildVisit_Break;
    };

    return c.CXVisit_Continue;
}

fn visitStructField(allocator: Allocator, cursor: CXCursor, reader: *Reader) !CppStructDecl.Field {
    const name = try getCursorSpelling(allocator, cursor) orelse return error.InvalidCursorSpelling;
    const raw_type = c.clang_getCursorType(cursor);
    const @"type" = try CppType.from(allocator, reader, raw_type);

    log.debug("Visiting struct field '{s}': {s}.", .{
        name,
        try getTypeSpelling(allocator, raw_type) orelse "Unknown",
    });

    const bitfield = c.clang_Cursor_isBitField(cursor) != 0;
    const bit_width: i32 = @intCast(c.clang_getFieldDeclBitWidth(cursor));
    if (bitfield) {
        log.debug("Field is a bitfield of {} bits!", .{bit_width});
    }

    return .{
        .bitfield = bitfield,
        .bit_width = bit_width,
        .name = name,
        .type = @"type",
    };
}

// Enums

fn processEnumDecl(allocator: std.mem.Allocator, cursor: CXCursor, reader: *Reader) !void {
    const name = try getCursorSpelling(allocator, cursor) orelse return error.InvalidCursorSpelling;
    const location = getCursorLocation(cursor);

    log.debug("visiting enum '{s}' [{}:{}]", .{
        name,
        location.line,
        location.column,
    });

    var decls = std.ArrayList(CppEnumDecl.Decl).init(allocator);
    var client_data = EnumDeclVisitClientData{
        .allocator = allocator,
        .reader = reader,
        .out_decls = &decls,
    };

    _ = c.clang_visitChildren(cursor, outerVisitEnumDecl, @ptrCast(&client_data));
    if (reader.err) |e| return e;

    const raw_integer_type = c.clang_getEnumDeclIntegerType(cursor);
    const integer_type = try CppType.from(allocator, reader, raw_integer_type);

    const enum_decl = CppEnumDecl{
        .name = name,
        .location = location,
        .int = integer_type,
        .decls = decls,
    };

    try reader.ast.enums.put(name, enum_decl);
}

const EnumDeclVisitClientData = struct {
    allocator: Allocator,
    reader: *Reader,
    out_decls: *std.ArrayList(CppEnumDecl.Decl),
};

fn outerVisitEnumDecl(cursor: CXCursor, _: CXCursor, client_data_opaque: c.CXClientData) callconv(.c) c.CXVisitorResult {
    const client_data: *EnumDeclVisitClientData = @alignCast(@ptrCast(client_data_opaque));

    const decl = visitEnumDecl(client_data.allocator, cursor) catch |e| {
        client_data.reader.err = e;
        return c.CXChildVisit_Break;
    };

    client_data.out_decls.append(decl) catch |e| {
        client_data.reader.err = e;
        return c.CXChildVisit_Break;
    };

    return c.CXVisit_Continue;
}

fn visitEnumDecl(allocator: Allocator, cursor: CXCursor) !CppEnumDecl.Decl {
    const name = try getCursorSpelling(allocator, cursor) orelse return error.InvalidCursorSpelling;
    const value: i64 = @intCast(c.clang_getEnumConstantDeclValue(cursor));

    log.debug("Visiting enum decl '{s}' = {}.", .{ name, value });

    return .{ name, value };
}

// -- Helpers -- //

// Location

fn getCursorLocation(cursor: CXCursor) Location {
    const location = c.clang_getCursorLocation(cursor);

    var line: c_uint = 0;
    var column: c_uint = 0;
    var offset: c_uint = 0;
    c.clang_getExpansionLocation(location, null, &line, &column, &offset);

    return .{
        .line = @intCast(line),
        .column = @intCast(column),
        .offset = @intCast(offset),
    };
}

// Spellings

const getCursorSpelling = getSafeCXStringFn(CXCursor, c.clang_getCursorSpelling);
const getCursorKindSpelling = getSafeCXStringFn(c.CXCursorKind, c.clang_getCursorKindSpelling);

const getTypeSpelling = getSafeCXStringFn(CXType, c.clang_getTypeSpelling);
const getTypeKindSpelling = getSafeCXStringFn(c.CXTypeKind, c.clang_getTypeKindSpelling);

// TODO: Neither of these work for imgui.h's function declarations.
// const getRawCommentText = getSafeCXStringFn(CXCursor, c.clang_Cursor_getRawCommentText);
// const getBriefCommentText = getSafeCXStringFn(CXCursor, c.clang_Cursor_getBriefCommentText);

fn getSafeCXStringFn(
    comptime T: type,
    comptime func: *const fn (T) callconv(.c) c.CXString,
) fn (Allocator, T) Allocator.Error!?[]const u8 {
    return struct {
        fn f(allocator: Allocator, thing: T) Allocator.Error!?[]const u8 {
            const str = func(thing);
            defer c.clang_disposeString(str);

            const cstr = c.clang_getCString(str);
            if (cstr == null) return null;

            return try allocator.dupe(u8, std.mem.span(cstr));
        }
    }.f;
}

// Formatting

pub fn getNamespacePrefix(allocator: Allocator, namespace: ?usize, ast: *const AST) ![]const u8 {
    return getNamespacePrefixWithSeperator(allocator, namespace, ast, "_");
}

pub fn getNamespacePrefixWithSeperator(allocator: Allocator, namespace: ?usize, ast: *const AST, sep: []const u8) ![]const u8 {
    if (namespace == null) return "";

    var prefix = std.ArrayList(u8).init(allocator);
    var ns_opt = namespace;

    while (ns_opt) |ns| : (ns_opt = ast.namespaces.items[ns].parent) {
        try prefix.appendSlice(ast.namespaces.items[ns].name);
        try prefix.appendSlice(sep);
    }

    return prefix.items;
}

// Debug

fn debugType(@"type": CXType) Allocator.Error!void {
    const ty_spelling = try getTypeSpelling(std.heap.smp_allocator, @"type");
    const kind_spelling = try getTypeKindSpelling(std.heap.smp_allocator, @"type".kind);
    std.debug.print("'{s}' ({}#{s})", .{ ty_spelling orelse "Unnamed", @"type".kind, kind_spelling orelse "Unnamed" });
}

// -- Result -- //

pub const Location = struct {
    line: usize,
    column: usize,
    offset: usize,
};

/// NOTE: Each usage of the type is it's own instance.
pub const CppType = struct {
    // TODO: usage_location: Location,

    raw_type_spelling: []const u8 = "",
    inner: Inner,
    is_const: bool,
    size: i64,
    align_: i64,

    // TODO: We probably want to check the proper type sizing but for now all of these should reach the minimum requirements.
    pub const Inner = union(enum) {
        unexposed,
        anon,

        void,

        bool,

        i8,
        u8,
        i16,
        u16,
        i32,
        u32,
        i64,
        u64,
        f32,
        f64,

        pointer: *const CppType,
        reference: *const CppType,

        array: struct { i64, *const CppType },
        slice: *const CppType,

        record: struct { i64, []const u8 },
        @"enum": []const u8,

        closure: usize,
    };

    fn from(allocator: Allocator, reader: *Reader, @"type": CXType) Allocator.Error!CppType {
        const size_: i64 = @intCast(c.clang_Type_getSizeOf(@"type"));
        const align_: i64 = @intCast(c.clang_Type_getAlignOf(@"type"));

        var resolved_type = @"type";
        const inner: Inner = outer: switch (resolved_type.kind) {
            c.CXType_Unexposed => .unexposed,
            c.CXType_Void => .void,

            c.CXType_Bool => .bool,

            c.CXType_Char_S, c.CXType_SChar => .i8,
            c.CXType_UChar => .u8,
            c.CXType_Short => .i16,
            c.CXType_UShort => .u16,
            c.CXType_Int => .i32,
            c.CXType_UInt => .u32,
            c.CXType_LongLong => .i64,
            c.CXType_ULongLong => .u64,
            c.CXType_Float => .f32,
            c.CXType_Double => .f64,

            c.CXType_Pointer => {
                const raw_pointee = c.clang_getPointeeType(resolved_type);

                const pointee = try allocator.create(CppType);
                pointee.* = try CppType.from(allocator, reader, raw_pointee);

                break :outer .{ .pointer = pointee };
            },
            c.CXType_LValueReference => {
                const raw_pointee = c.clang_getPointeeType(resolved_type);

                const pointee = try allocator.create(CppType);
                pointee.* = try CppType.from(allocator, reader, raw_pointee);

                break :outer .{ .reference = pointee };
            },

            c.CXType_ConstantArray => {
                const size: i64 = c.clang_getArraySize(resolved_type);
                const raw_element_type = c.clang_getArrayElementType(resolved_type);

                const element_type = try allocator.create(CppType);
                element_type.* = try CppType.from(allocator, reader, raw_element_type);

                break :outer .{ .array = .{ size, element_type } };
            },
            c.CXType_IncompleteArray => {
                const raw_element_type = c.clang_getArrayElementType(resolved_type);

                const element_type = try allocator.create(CppType);
                element_type.* = try CppType.from(allocator, reader, raw_element_type);

                break :outer .{ .slice = element_type };
            },

            // TODO: Avoid using fatal errors.
            c.CXType_Record => {
                if (c.clang_Cursor_isAnonymousRecordDecl(c.clang_getTypeDeclaration(@"type")) != 0) {
                    break :outer .anon;
                }

                const size: i64 = @intCast(c.clang_Type_getSizeOf(@"type"));
                log.debug("Unexposed type has size {}!", .{size});
                const name = try getTypeSpelling(allocator, resolved_type) orelse @panic("Cannot have unnamed structs!");
                break :outer .{ .record = .{ size, name[if (std.mem.lastIndexOfScalar(u8, name, ' ')) |i| i + 1 else 0..] } };
            },
            // TODO: Avoid using fatal errors.
            c.CXType_Enum => {
                const name = try getTypeSpelling(allocator, resolved_type) orelse @panic("Cannot have unnamed enum!");
                break :outer .{ .@"enum" = name[if (std.mem.lastIndexOfScalar(u8, name, ' ')) |i| i + 1 else 0..] };
            },

            c.CXType_FunctionProto => {
                const raw_return_type = c.clang_getResultType(resolved_type);
                const return_type = try CppType.from(allocator, reader, raw_return_type);

                const arg_n: usize = @intCast(c.clang_getNumArgTypes(resolved_type));
                var params = try std.ArrayList(CppTypeNamePair).initCapacity(allocator, arg_n);
                for (0..arg_n) |i| {
                    const arg_name = try std.fmt.allocPrint(allocator, "arg{}", .{i});
                    const raw_arg_type = c.clang_getArgType(resolved_type, @intCast(i));

                    log.debug("visiting closure param '{s}': {s}", .{
                        arg_name,
                        try getTypeSpelling(allocator, raw_arg_type) orelse "Unknown",
                    });

                    const arg_type = try CppType.from(allocator, reader, raw_arg_type);
                    try params.append(.{ .name = arg_name, .type = arg_type });
                }

                try reader.ast.closures.append(.{
                    .name = "<closure>",
                    .namespace = null,
                    .resolved_namespace_prefix = "",
                    .return_type = return_type,
                    .parameters = params,
                    .variadic = c.clang_isFunctionTypeVariadic(resolved_type) != 0,
                });

                break :outer .{ .closure = reader.ast.closures.items.len - 1 };
            },

            c.CXType_Typedef => {
                // TODO: This seems convoluted, there has to be an easier way to do this.
                const type_cursor = c.clang_getTypeDeclaration(resolved_type);
                resolved_type = c.clang_getTypedefDeclUnderlyingType(type_cursor);

                continue :outer resolved_type.kind;
            },

            else => {
                std.debug.print("Type ", .{});
                try debugType(resolved_type);
                std.debug.print(" not yet implemented!\n", .{});

                std.process.exit(1); // Could be non-fatal.
            },
        };

        return .{
            .raw_type_spelling = try getTypeSpelling(allocator, @"type") orelse "",
            .is_const = c.clang_isConstQualifiedType(@"type") != 0,
            .inner = inner,
            .size = size_,
            .align_ = align_,
        };
    }

    pub fn exists(cpp_type: *const CppType, ast: *const AST) bool {
        switch (cpp_type.inner) {
            .record => |st| return ast.structs.contains(st.@"1"),
            .@"enum" => |name| return ast.enums.contains(name),
            else => return true,
        }
    }

    pub fn format(cpp_type: CppType, writer: *std.io.Writer) std.io.Writer.Error!void {
        if (cpp_type.is_const) try writer.print("const ", .{});
        try writer.print("{s}", .{@tagName(cpp_type.inner)});
    }
};

/// A pair of a C++ type and name, either a function parameter or struct field.
pub const CppTypeNamePair = struct {
    name: []const u8,
    type: CppType,

    pub fn format(pear: CppTypeNamePair, writer: *std.io.Writer) std.io.Writer.Error!void {
        try writer.print("{s}: {f}", .{ pear.name, pear.type });
    }
};

/// A C++ struct declaration.
pub const CppStructDecl = struct {
    size: i64,
    name: []const u8,
    location: Location,
    fields: std.ArrayList(Field),

    pub const Field = struct {
        bitfield: bool,
        bit_width: ?i32 = null,
        name: []const u8,
        type: CppType,

        pub fn format(pear: Field, writer: *std.io.Writer) std.io.Writer.Error!void {
            try writer.print("{s}: {f}", .{ pear.name, pear.type });
        }
    };

    pub fn format(struct_decl: CppStructDecl, writer: *std.io.Writer) std.io.Writer.Error!void {
        try writer.print("struct {s} {{ ", .{struct_decl.name});
        for (struct_decl.fields.items) |param| try writer.print("{f}, ", .{param});
        try writer.print("}}", .{});
    }
};

/// A C++ enum declaration.
pub const CppEnumDecl = struct {
    name: []const u8,
    location: Location,
    int: CppType,
    decls: std.ArrayList(Decl),

    pub const Decl = struct { []const u8, i64 };

    pub fn format(enum_decl: CppEnumDecl, writer: *std.io.Writer) std.io.Writer.Error!void {
        try writer.print("enum {s}({f}) {{ ", .{ enum_decl.name, enum_decl.int });
        for (enum_decl.decls.items) |decl| try writer.print("{s} = {}, ", .{ decl.@"0", decl.@"1" });
        try writer.print("}}", .{});
    }
};

/// A C++ function declaration.
pub const CppFunctionDecl = struct {
    // TODO: location,
    name: []const u8,
    namespace: ?usize,
    parameters: std.ArrayList(CppTypeNamePair),
    return_type: CppType,
    variadic: bool = false,

    resolved_namespace_prefix: []const u8,

    pub fn format(fn_decl: CppFunctionDecl, writer: *std.io.Writer) std.io.Writer.Error!void {
        try writer.print("fn {s}{s}(", .{ fn_decl.resolved_namespace_prefix, fn_decl.name });

        for (fn_decl.parameters.items, 0..) |param, i| {
            try writer.print("{f}", .{param});
            if (fn_decl.variadic or i < fn_decl.parameters.items.len - 1) try writer.print(", ", .{});
        }

        if (fn_decl.variadic) try writer.print("...", .{});

        try writer.print(") {f}", .{fn_decl.return_type});
    }
};

pub const CppNamespaceDecl = struct {
    name: []const u8,
    parent: ?usize = null,
};

/// Frankly, AST is not a proper name for this in a conventional sense but I don't really care.
/// This struct does not respect a symbol's location in the source file.
pub const AST = struct {
    namespaces: std.ArrayList(CppNamespaceDecl),
    functions: std.ArrayList(CppFunctionDecl),
    structs: std.StringHashMap(CppStructDecl),
    enums: std.StringHashMap(CppEnumDecl),
    closures: std.ArrayList(CppFunctionDecl),
};
