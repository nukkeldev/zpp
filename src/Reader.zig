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

const ENABLE_TU_DIAGNOSTICS = true;

const REQUIRED_ARGUMENTS: []const [:0]const u8 = &.{"-xc++"};

const TU_FLAGS: c.CXTranslationUnit_Flags =
    c.CXTranslationUnit_SkipFunctionBodies;

// -- State -- //

arena: *std.heap.ArenaAllocator,
ast: AST,
opts: ParsingOptions,
err: ?anyerror = null,

current_ns_idx: usize = 0,

// -- (De)initialization -- //

fn init(allocator: Allocator, opts: ParsingOptions) !Reader {
    // This seems so cursed but it's necessary...
    const arena = try allocator.create(std.heap.ArenaAllocator);
    arena.* = .init(allocator);

    return .{
        .arena = arena,
        .ast = .{
            .namespaces = .init(arena.allocator()),
            .symbols = .init(arena.allocator()),
        },
        .opts = opts,
    };
}

pub fn deinit(reader: *const Reader) void {
    reader.arena.deinit();
}

// -- Functions -- //

fn addSymbol(reader: *Reader, symbol: CppSymbol) !void {
    try reader.ast.symbols.append(symbol);
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
) !AST {
    try std.fs.cwd().access(file_path, .{});
    std.log.info("Parsing '{s}'...", .{file_path});

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

    std.log.info("Successfully parsed '{s}'!", .{file_path});

    const cursor = c.clang_getTranslationUnitCursor(tu_opt);

    // ---

    var reader: Reader = try .init(allocator, opts);

    _ = c.clang_visitChildren(cursor, outerVisitor, @ptrCast(&reader));
    if (reader.err) |err| return err;

    return reader.ast;
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

fn visitor(allocator: std.mem.Allocator, cursor: CXCursor, reader: *Reader) !void {
    const inner = switch (cursor.kind) {
        c.CXCursor_StructDecl => try visitStructDecl(allocator, cursor, reader),
        c.CXCursor_FunctionDecl => try visitFunctionDecl(allocator, cursor, reader),
        c.CXCursor_EnumDecl => try visitEnumDecl(allocator, cursor, reader),
        c.CXCursor_TypedefDecl => try visitTypedefDecl(allocator, cursor, reader),
        c.CXCursor_Namespace => return try visitNamespace(allocator, cursor, reader),
        else => return,
    };

    const name = try getCursorSpelling(allocator, cursor);
    const location = getCursorLocation(cursor);

    if (reader.opts.verbose) {
        const kind = try getCursorKindSpelling(allocator, cursor.kind);
        defer allocator.free(kind);

        std.log.debug("visiting {s}: {s} [{}:{}]", .{
            name,
            kind,
            location.line,
            location.column,
        });
    }

    const symbol = CppSymbol{
        .loc = location,
        .name = name,
        .ns_idx = reader.current_ns_idx,
        .inner = inner,
    };

    try reader.addSymbol(symbol);
}

fn visitStructDecl(allocator: std.mem.Allocator, cursor: CXCursor, reader: *Reader) !CppSymbol.Inner {
    std.debug.assert(cursor.kind == c.CXCursor_StructDecl);

    _ = allocator;
    _ = reader;

    return undefined;
}

fn visitFunctionDecl(allocator: std.mem.Allocator, cursor: CXCursor, reader: *Reader) !CppSymbol.Inner {
    std.debug.assert(cursor.kind == c.CXCursor_FunctionDecl);

    _ = allocator;
    _ = reader;

    return undefined;
}

fn visitEnumDecl(allocator: std.mem.Allocator, cursor: CXCursor, reader: *Reader) !CppSymbol.Inner {
    std.debug.assert(cursor.kind == c.CXCursor_EnumDecl);

    _ = allocator;
    _ = reader;

    return .{
        .en_decl = .{
            .int = undefined, // TODO
            .decls = undefined,
        },
    };
}

fn visitTypedefDecl(allocator: std.mem.Allocator, cursor: CXCursor, reader: *Reader) !CppSymbol.Inner {
    std.debug.assert(cursor.kind == c.CXCursor_TypedefDecl);

    _ = allocator;
    _ = reader;

    return undefined;
}

fn visitNamespace(allocator: std.mem.Allocator, cursor: CXCursor, reader: *Reader) !void {
    std.debug.assert(cursor.kind == c.CXCursor_Namespace);

    _ = allocator;
    _ = reader;
}

// -- Helpers -- //

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

fn getSafeCXStringFn(
    comptime T: type,
    comptime func: *const fn (T) callconv(.c) c.CXString,
) fn (Allocator, T) anyerror![]const u8 {
    return struct {
        fn f(allocator: Allocator, thing: T) ![]const u8 {
            const str = func(thing);
            defer c.clang_disposeString(str);

            const cstr = c.clang_getCString(str);
            if (cstr == null) return error.InvalidCString;

            return allocator.dupe(u8, std.mem.span(cstr));
        }
    }.f;
}

// -- Result -- //

pub const Location = struct {
    line: usize,
    column: usize,
    offset: usize,
};

// NOTE: Contains a subset of those in CXTypeKind along with better structured information
// NOTE: about each one.
pub const CppType = union(enum) {
    void,
    int,
};

pub const CppTypeNamePair = struct { []const u8, CppType };

pub const CppFunctionDeclaration = struct {
    params: std.ArrayList(CppTypeNamePair),
    ret: CppType,
};

pub const CppStructDeclaration = struct {
    fields: std.ArrayList(CppTypeNamePair),
};

pub const CppEnumDeclaration = struct {
    int: CppType,
    decls: std.ArrayList(Decl),

    pub const Decl = struct { []const u8, usize };
};

pub const TypedefDeclaration = struct {
    ref: CppType,
};

pub const CppSymbol = struct {
    loc: Location,
    name: []const u8,
    ns_idx: usize,
    inner: Inner,

    pub const Inner = union(enum) {
        fn_decl: CppFunctionDeclaration,
        st_decl: CppStructDeclaration,
        en_decl: CppEnumDeclaration,
        td_decl: TypedefDeclaration,
    };
};

pub const CppNamespace = struct {
    name: []const u8,
    parent_idx: usize,
};

/// Frankly, AST is not a proper name for this in a conventional sense but I don't really care.
/// This struct does not respect a symbol's location in the source file.
pub const AST = struct {
    /// NOTE: The first index is _always_ empty.
    namespaces: std.ArrayList(CppNamespace),
    symbols: std.ArrayList(CppSymbol),
};
