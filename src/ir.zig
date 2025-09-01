//! An intermediate representation of a C++ header.
//! TODO: Move data members into struct as we changed the name to be lowercase.

// -- Imports -- //

const std = @import("std");
const Allocator = std.mem.Allocator;

const ffi = @import("ffi.zig");
const c = ffi.c;

const tracy = @import("util/tracy.zig");

const log = std.log.scoped(.ir);

// -- IR -- //

pub const IR = struct {
    paths: []const []const u8,
    hashed_paths: std.StringHashMap(void),

    arena: *std.heap.ArenaAllocator,
    instrs: std.array_list.Managed(Instruction),

    // --

    pub fn init(allocator: Allocator, paths: []const []const u8, hashed_paths: std.StringHashMap(void)) !IR {
        const arena = try allocator.create(std.heap.ArenaAllocator);
        arena.* = .init(allocator);
        return .{
            .paths = paths,
            .hashed_paths = hashed_paths,
            .arena = arena,
            .instrs = .init(arena.allocator()),
        };
    }

    pub fn deinit(ir: IR) void {
        ir.arena.deinit();
        ir.arena.child_allocator.destroy(ir.arena);
    }
};

// -- Instructions -- //

// TODO: A lot of the associated instruction information could be reduced with functions for c.clang_getCursorType(cursor).
// TODO: i.e. clang_Cursor_isVariadic, etc.
pub const Instruction = struct {
    name: []const u8,
    state: enum { open, close } = .open,
    inner: Inner,
    cursor: c.CXCursor,

    pub const Inner = union(enum) {
        Namespace,
        Struct,
        Union,
        Enum,
        Function,
        Member: c.CXType,
        Value: Value, // TODO: This could probs be updated to a literal tagged union
        Typedef: c.CXType,
    };

    pub fn getUniqueName(instr: *const Instruction, allocator: Allocator, ns_stack: []const []const u8) ![]const u8 {
        var out = std.array_list.Managed(u8).init(allocator);

        for (ns_stack) |ns| try out.print("{s}_", .{ns});
        try out.print("{s}__{x}", .{ instr.name, std.hash.Wyhash.hash(0xBEEF, instr.name) });

        return try out.toOwnedSlice();
    }
};

pub const Value = struct {
    type: c.CXType,
    value: ?*anyopaque,

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        switch (self.type.kind) {
            c.CXType_Char_U,
            c.CXType_UChar,
            c.CXType_UShort,
            c.CXType_UInt,
            c.CXType_ULong,
            c.CXType_ULongLong,
            c.CXType_UInt128,
            c.CXType_Char16,
            c.CXType_Char32,
            c.CXType_Char_S,
            c.CXType_SChar,
            c.CXType_WChar,
            c.CXType_Short,
            c.CXType_Int,
            c.CXType_Long,
            c.CXType_LongLong,
            c.CXType_Int128,
            c.CXType_Enum,
            => try writer.print("{}", .{@as(*i128, @ptrCast(@alignCast(self.value))).*}),

            else => {
                log.err("Value serialization for '{s}'s not yet implemented!", .{ffi.getTypeKindSpelling(std.heap.page_allocator, self.type.kind) catch @panic("OOM")});
                @panic("Value serialization error.");
            },
        }
    }
};

// -- Processing -- //

pub const ROOT_FILE = "ZPP_ROOT_FILE.hpp";

const CLANG_CRASH_ON_FATAL_ERROR = true;

pub const REQUIRED_ARGUMENTS: []const [:0]const u8 = &.{"-xc++"};
const TU_FLAGS: c.CXTranslationUnit_Flags =
    c.CXTranslationUnit_SkipFunctionBodies;

const ProcessingState = struct {
    allocator: Allocator,
    ir: *IR,
    namespaces: *std.StringHashMap(IR),

    err: ?anyerror = null,
};

pub const IRProcessingError = error{
    /// Failed to parse the translation unit.
    ParseTUFail,
};

pub fn processFiles(allocator: Allocator, paths: []const [:0]const u8, clang_args: []const [:0]const u8) !IR {
    var fz = tracy.FnZone.init(@src(), "ir.processFiles");
    defer fz.end();

    var contents = std.array_list.Managed(u8).init(allocator);
    for (paths) |path| try contents.print("#include \"{s}\"\n", .{path});
    log.debug("File Contents:\n{s}", .{contents.items});

    const actual_paths = try allocator.alloc([:0]const u8, paths.len + 1);
    actual_paths[0] = ROOT_FILE;
    @memcpy(actual_paths[1..], paths);

    return processBytes(allocator, ROOT_FILE, contents.items, actual_paths, clang_args);
}

pub fn processBytes(allocator: Allocator, root_path: [:0]const u8, contents: []const u8, paths: []const [:0]const u8, clang_args: []const [:0]const u8) !IR {
    var fz = tracy.FnZone.init(@src(), "ir.processBytes");
    defer fz.end();

    const clang_version = c.clang_getClangVersion();
    defer c.clang_disposeString(clang_version);

    log.debug("Processing IR with {s}...", .{c.clang_getCString(clang_version)});

    var hashed_paths = std.StringHashMap(void).init(allocator);
    try hashed_paths.ensureTotalCapacity(@intCast(paths.len));
    for (paths) |p| hashed_paths.putAssumeCapacity(p, {});

    {
        log.debug("Paths:", .{});
        var iter = hashed_paths.keyIterator();
        while (iter.next()) |p| log.debug("  {s}", .{p.*});
    }

    fz.push(@src(), "clang parsing");
    const index = c.clang_createIndex(0, 0);
    defer c.clang_disposeIndex(index);

    var file = c.CXUnsavedFile{ .Filename = root_path, .Contents = contents.ptr, .Length = @intCast(contents.len) };
    const args = try combineArgs(allocator, &.{ REQUIRED_ARGUMENTS, clang_args });
    defer allocator.free(args);

    const translation_unit = c.clang_parseTranslationUnit(index, root_path, @ptrCast(args), @intCast(args.len), &file, 1, TU_FLAGS);
    // NOTE: Because we store references to cursors and types, we need this for the entire lifetime of the program.
    // defer c.clang_disposeTranslationUnit(translation_unit);

    if (translation_unit == null) return IRProcessingError.ParseTUFail;

    fz.replace(@src(), "diagnostic handling");
    const diagnostic_set = c.clang_getDiagnosticSetFromTU(translation_unit);
    for (0..c.clang_getNumDiagnosticsInSet(diagnostic_set)) |i| {
        const diagnostic = c.clang_getDiagnosticInSet(diagnostic_set, @intCast(i));
        const severity = c.clang_getDiagnosticSeverity(diagnostic);

        try ffi.printDiagnostic(allocator, diagnostic);
        if (CLANG_CRASH_ON_FATAL_ERROR and severity == c.CXDiagnostic_Fatal) @panic("Fatal error while parsing TU! See above.");
    }

    fz.replace(@src(), "visiting");
    const cursor = c.clang_getTranslationUnitCursor(translation_unit);

    var ir: IR = try .init(allocator, paths, hashed_paths);
    var namespaces: std.StringHashMap(IR) = .init(ir.arena.allocator());

    var state = ProcessingState{
        .allocator = ir.arena.allocator(),
        .ir = &ir,
        .namespaces = &namespaces,
    };
    const visit_result = c.clang_visitChildren(cursor, outerVisitor, @ptrCast(&state));

    if (state.err) |err| {
        log.err("Processing Error: {}", .{err});
        if (visit_result == c.CXChildVisit_Break) std.process.exit(1);
    }

    fz.replace(@src(), "post-processing");
    // Merge namespaced instructions.
    {
        fz.push(@src(), "ns merging");
        defer fz.pop();

        var i: usize = 0;
        while (i < ir.instrs.items.len) : (i += 1) {
            if (ir.instrs.items[i].inner == .Namespace) {
                if (namespaces.fetchRemove(ir.instrs.items[i].name)) |kv| {
                    try ir.instrs.insertSlice(i + 1, kv.value.instrs.items);
                    i += 1 + kv.value.instrs.items.len;
                } else {
                    _ = ir.instrs.orderedRemove(i);
                    i -= 1;
                }
            }
        }
    }

    // Reorder methods to be after fields.
    // 1. Iterate through all of the instructions.
    // 2. If we reach a member AND our immediate parent is a struct or union:
    //  2.1 If we know the index of the previous member AND it is NOT the current index:
    //   2.1.1 Move the member there.
    //  2.2 Store the index of the the subsequent _sibling_.
    {
        fz.push(@src(), "field reordering");
        defer fz.pop();

        var i: usize = 0;
        var ctx_stack: std.array_list.Managed(?usize) = .init(allocator);
        defer ctx_stack.deinit();

        while (i < ir.instrs.items.len) : (i += 1) {
            const instr = ir.instrs.items[i];
            switch (instr.inner) {
                .Struct => if (instr.state == .open) {
                    try ctx_stack.append(i + 1);
                } else {
                    _ = ctx_stack.pop();
                },
                .Union => outer: {
                    if (c.clang_Cursor_isAnonymous(instr.cursor) != 0) {
                        if (ctx_stack.getLast()) |next| {
                            if (i != next) {
                                ir.instrs.insertAssumeCapacity(next, ir.instrs.orderedRemove(i));
                            }
                            ctx_stack.items[ctx_stack.items.len - 1] = next + 1;
                            break :outer;
                        }
                    }
                    if (instr.state == .open) {
                        try ctx_stack.append(i + 1);
                    } else {
                        _ = ctx_stack.pop();
                    }
                },
                .Member => if (ctx_stack.getLast()) |next| {
                    if (i != next) {
                        ir.instrs.insertAssumeCapacity(next, ir.instrs.orderedRemove(i));
                    }
                    ctx_stack.items[ctx_stack.items.len - 1] = next + 1;
                },
                .Value, .Typedef => {},
                else => if (instr.state == .open) try ctx_stack.append(null) else {
                    _ = ctx_stack.pop();
                },
            }
        }
    }

    return ir;
}

fn outerVisitor(current_cursor: c.CXCursor, _: c.CXCursor, client_data_opaque: c.CXClientData) callconv(.c) c.CXVisitorResult {
    var fz = tracy.FnZone.init(@src(), "outerVisitor");
    defer fz.end();

    var state: *ProcessingState = @ptrCast(@alignCast(client_data_opaque));

    const raw_location = c.clang_getCursorLocation(current_cursor);
    const location = ffi.SourceLocation.fromCXSourceLocation(state.ir.arena.allocator(), raw_location) catch @panic("OOM");
    if (!state.ir.hashed_paths.contains(location.file)) return c.CXChildVisit_Continue;

    const instr_opt = visitor(state.allocator, current_cursor) catch |e| {
        state.err = e;
        return c.CXChildVisit_Break;
    };
    if (instr_opt) |instr| outer: {
        state.ir.instrs.append(instr) catch |e| {
            state.err = e;
            return c.CXChildVisit_Break;
        };

        switch (instr.inner) {
            .Value, .Member, .Typedef => break :outer,
            .Namespace => {
                const ns = state.namespaces.getOrPut(instr.name) catch @panic("OOM");
                if (!ns.found_existing) {
                    ns.value_ptr.* = IR.init(state.allocator, state.ir.paths, state.ir.hashed_paths) catch @panic("OOM");
                }

                const prev = state.ir;
                state.ir = ns.value_ptr;
                defer state.ir = prev;

                _ = c.clang_visitChildren(instr.cursor, outerVisitor, @ptrCast(state));
            },
            else => {
                _ = c.clang_visitChildren(instr.cursor, outerVisitor, @ptrCast(state));
            },
        }

        var close_instr = instr;
        close_instr.state = .close;

        state.ir.instrs.append(close_instr) catch |e| {
            state.err = e;
            return c.CXChildVisit_Break;
        };

        if (Logging.DEBUG_TRACE) |_| Logging.DEBUG_TRACE.?.indent -= 1;
    }

    if (state.err) |_| return c.CXChildVisit_Break;
    return c.CXChildVisit_Continue;
}

fn visitor(allocator: std.mem.Allocator, cursor: c.CXCursor) !?Instruction {
    var fz = tracy.FnZone.init(@src(), "visitor");
    defer fz.end();

    const name = try ffi.getCursorSpelling(allocator, cursor);

    // This prevents falsely parsing implementations of declared functions.
    // This is not particularly robust but I do not currently know how to get, for instance, `Foo` from `Foo::bar` to
    // correctly identify such function.
    if (0 == c.clang_equalCursors(c.clang_getCursorSemanticParent(cursor), c.clang_getCursorLexicalParent(cursor))) {
        return null;
    }

    if (Logging.DEBUG_TRACE) |trace| {
        log.debug("{s} {f}", .{ trace.getIndent(), std.fmt.Alt(c.CXCursor, ffi.formatCXCursorDetailed){ .data = cursor } });
    }
    if (Logging.PANIC_ON_NAME) |panic_on| if (std.mem.eql(u8, name, panic_on)) @panic("Found name!");

    const instruction: ?Instruction = outer: {
        break :outer Instruction{
            .name = name,
            .inner = switch (cursor.kind) {
                // -- Namespaces -- //

                c.CXCursor_Namespace => .Namespace,

                // -- Members -- //

                c.CXCursor_FieldDecl,
                c.CXCursor_ParmDecl,
                => .{ .Member = c.clang_getCursorType(cursor) },

                // -- Values -- //

                c.CXCursor_IntegerLiteral,
                => inner: {
                    const value = try allocator.create(i128);
                    value.* = c.clang_EvalResult_getAsLongLong(c.clang_Cursor_Evaluate(cursor));

                    break :inner .{
                        .Value = .{
                            .type = c.clang_getCursorType(cursor),
                            .value = @ptrCast(value),
                        },
                    };
                },
                c.CXCursor_EnumConstantDecl,
                => inner: {
                    const value = try allocator.create(i128); // TODO: Allocate in accordance to parent cursor backing type?
                    value.* = c.clang_getEnumConstantDeclValue(cursor);

                    break :inner .{
                        .Value = .{
                            .type = c.clang_getCursorType(cursor),
                            .value = @ptrCast(value),
                        },
                    };
                },

                // -- Functions -- //

                c.CXCursor_CXXMethod,
                c.CXCursor_FunctionDecl,
                => inner: {
                    // TODO: Replace with an explict check for each type of operator overload so as to not mistaken functions.
                    // TODO: Then convert the operator overloads to normal methods.
                    if (std.mem.startsWith(u8, name, "operator")) break :outer null;

                    break :inner .Function;
                },

                // -- Structs & Unions -- //

                c.CXCursor_StructDecl => inner: {
                    break :inner .Struct;
                },

                c.CXCursor_UnionDecl => inner: {
                    break :inner .Union;
                },

                // -- Enums -- //

                c.CXCursor_EnumDecl => .Enum,

                // -- Type Defintions -- //

                c.CXCursor_TypedefDecl => .{ .Typedef = c.clang_getTypedefDeclUnderlyingType(cursor) },

                // -- TODO -- //

                c.CXCursor_Constructor, // CXXConstructor
                c.CXCursor_Destructor,
                c.CXCursor_ConversionFunction,
                => break :outer null,

                c.CXCursor_ClassTemplate,
                c.CXCursor_FunctionTemplate,
                => break :outer null,

                c.CXCursor_VarDecl, // i.e. static or global members
                => break :outer null,

                // -- Ignored -- //

                c.CXCursor_TypeRef, // Any time a non-primitive type is used; we get this info other ways.
                c.CXCursor_UsingDirective, // `using namespace ...`
                c.CXCursor_UnexposedAttr, // TODO: Not too sure what this is but it on some declarations in `imgui.h`...
                => break :outer null,

                // -- Fallback -- //

                else => {
                    log.warn("Cursor kind '{s}' for cursor '{s}' not yet implemented!", .{ try ffi.getCursorKindSpelling(allocator, cursor.kind), name });
                    break :outer null;
                },
            },
            .cursor = cursor,
        };
    };

    if (Logging.DEBUG_TRACE) |_| if (instruction) |instr| switch (instr.inner) {
        .Member,
        .Value,
        .Typedef,
        => {},
        else => Logging.DEBUG_TRACE.?.indent += 1,
    };

    return instruction;
}

// -- Helpers -- //

pub fn combineArgs(allocator: Allocator, args: []const []const [:0]const u8) ![]const [*c]const u8 {
    var count: usize = 0;
    for (args) |arg| count += arg.len;
    const out = try allocator.alloc([*c]const u8, count);

    var i: usize = 0;
    for (args) |arg| {
        for (arg) |arg_| {
            out[i] = arg_.ptr;
            i += 1;
        }
    }
    return out;
}

// -- Logging -- //

const Logging = struct {
    // NOTE: Do NOT leave these set.

    pub var PANIC_ON_NAME: ?[]const u8 = null;
    pub var DEBUG_TRACE: ?struct {
        indent: usize = 0,

        pub const INDENT: []const u8 = "+" ** 256;
        pub fn getIndent(self: @This()) []const u8 {
            if (self.indent >= 256) @panic("Too much indentation!");
            return INDENT[0..self.indent];
        }
    } = null;
};
