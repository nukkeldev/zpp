//! An intermediate representation of a C++ header.
//!
//! Requirements:
//! - Represent as much information as necessary without _needing_ to expose underlying Index API cursors.
//! - Maintain declaration ordering as some languages require it (i.e. C++).
//!
//! Structure:
//! - The IR is flat (i.e. namespace scopes are it's own "instruction")

// -- Imports -- //

const std = @import("std");
const ffi = @import("../ffi.zig");

const c = ffi.c;
const Allocator = std.mem.Allocator;

pub const TypeReference = @import("TypeReference.zig");
const IR = @This();

const log = std.log.scoped(.ir);

// -- Fields -- //

path: []const u8,
source: []const u8,

arena: *std.heap.ArenaAllocator,
instrs: std.array_list.Managed(Instruction),

// -- (De)initialization -- //

pub fn init(allocator: Allocator, path: []const u8, source: []const u8) !IR {
    const arena = try allocator.create(std.heap.ArenaAllocator);
    arena.* = .init(allocator);
    return .{
        .path = path,
        .source = source,
        .arena = arena,
        .instrs = .init(arena.allocator()),
    };
}

pub fn deinit(ir: IR) void {
    ir.arena.deinit();
    ir.arena.child_allocator.destroy(ir.arena);
}

// -- Instructions -- //

pub const Instruction = struct {
    name: []const u8,
    state: enum { open, close } = .open,
    inner: Inner,
    __cursor: c.CXCursor,

    pub const Inner = union(enum) {
        Namespace,
        Struct,
        Union,
        Enum: Enum,
        Function: Function,
        Member: TypeReference,
        Value: Value,
        Typedef: TypeReference,
    };

    pub fn getUniqueName(instr: *const Instruction, allocator: Allocator) ![]const u8 {
        return std.fmt.allocPrint(allocator, "{s}__{x}", .{ instr.name, std.hash.Wyhash.hash(0xBEEF, instr.name) });
    }
};

pub const Function = struct {
    return_type: TypeReference,
};

pub const Enum = struct {
    backing: TypeReference.Integral,
};

pub const Value = struct {
    type: TypeReference,
    value: ?*anyopaque,

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        switch (self.type.inner) {
            // TODO: Define i128 in a const
            .integer, .enumeration => try writer.print("{}", .{@as(*i128, @ptrCast(@alignCast(self.value))).*}),
            else => try writer.print("{?}", .{self.value}),
        }
    }
};

// -- Processing -- //

pub const REQUIRED_ARGUMENTS: []const [:0]const u8 = &.{"-xc++"};
const CLANG_DISPLAY_DIAGNOSTICS = true;
const TU_FLAGS: c.CXTranslationUnit_Flags =
    c.CXTranslationUnit_SkipFunctionBodies;

const ProcessingState = struct {
    ir: IR,
    err: ?anyerror = null,
};

pub const IRProcessingError = error{
    /// Failed to parse the translation unit.
    ParseTUFail,
};

pub fn processFile(allocator: Allocator, path: [:0]const u8, clang_args: []const [:0]const u8) !IR {
    // TODO: A cross-platform mmap implementation would go here nicely.
    const contents = try std.fs.cwd().readFileAlloc(allocator, path, std.math.maxInt(usize));
    return processBytes(allocator, path, contents, clang_args);
}

pub fn processBytes(allocator: Allocator, path: [:0]const u8, contents: []const u8, clang_args: []const [:0]const u8) !IR {
    const clang_version = c.clang_getClangVersion();
    defer c.clang_disposeString(clang_version);

    log.info("Processing IR with {s}...", .{c.clang_getCString(clang_version)});

    const index = c.clang_createIndex(0, if (CLANG_DISPLAY_DIAGNOSTICS) 1 else 0);
    defer c.clang_disposeIndex(index);

    var file = c.CXUnsavedFile{ .Filename = path, .Contents = contents.ptr, .Length = @intCast(contents.len) };
    const args = try combineArgs(allocator, &.{ REQUIRED_ARGUMENTS, clang_args });
    defer allocator.free(args);

    const translation_unit = c.clang_parseTranslationUnit(index, path, @ptrCast(args), @intCast(args.len), &file, 1, TU_FLAGS);
    // NOTE: Because we store references to cursors and types, we need this for the entire lifetime of the program.
    // defer c.clang_disposeTranslationUnit(translation_unit);

    if (translation_unit == null) return IRProcessingError.ParseTUFail;
    const cursor = c.clang_getTranslationUnitCursor(translation_unit);

    var state = ProcessingState{ .ir = try .init(allocator, path, contents) };
    const visit_result = c.clang_visitChildren(cursor, outerVisitor, @ptrCast(&state));

    if (state.err) |err| {
        log.err("Processing Error: {}", .{err});
        if (visit_result == c.CXChildVisit_Break) std.process.exit(1);
    }

    return state.ir;
}

fn outerVisitor(current_cursor: c.CXCursor, _: c.CXCursor, client_data_opaque: c.CXClientData) callconv(.c) c.CXVisitorResult {
    const location = c.clang_getCursorLocation(current_cursor);
    if (c.clang_Location_isFromMainFile(location) == 0) return c.CXChildVisit_Continue;

    var state: *ProcessingState = @alignCast(@ptrCast(client_data_opaque));

    const instr_opt = visitor(state.ir.arena.allocator(), current_cursor, &state.ir) catch |e| {
        state.err = e;
        return c.CXChildVisit_Break;
    };
    if (instr_opt) |instr| outer: {
        state.ir.instrs.append(instr) catch |e| {
            state.err = e;
            return c.CXChildVisit_Break;
        };

        switch (instr.inner) {
            .Value, .Member => break :outer,
            else => {},
        }

        _ = c.clang_visitChildren(current_cursor, outerVisitor, @ptrCast(state));

        var close_instr = instr;
        close_instr.state = .close;
        state.ir.instrs.append(close_instr) catch |e| {
            state.err = e;
            return c.CXChildVisit_Break;
        };
    }

    if (state.err) |_| return c.CXChildVisit_Break;
    return c.CXChildVisit_Continue;
}

fn visitor(allocator: std.mem.Allocator, cursor: c.CXCursor, ir: *IR) !?Instruction {
    const location = ffi.SourceLocation.fromCursor(cursor);
    const name = try ffi.getCursorSpelling(allocator, cursor) orelse {
        log.err("Unnamed declaration on line {}!", .{location.line});
        return null;
    }; // TODO: This will never return null; remove that from `getCursorSpelling`.

    return Instruction{
        .name = name,
        .inner = switch (cursor.kind) {
            // -- Namespaces -- //

            c.CXCursor_Namespace => .Namespace,

            // -- Members -- //

            c.CXCursor_FieldDecl,
            c.CXCursor_ParmDecl,
            => outer: {
                var type_ref = try TypeReference.fromCXType(allocator, c.clang_getCursorType(cursor), ir);
                if (c.clang_Cursor_isBitField(cursor) != 0) switch (type_ref.inner) {
                    .integer => {
                        type_ref.inner.integer.bits = @intCast(c.clang_getFieldDeclBitWidth(cursor));
                    },
                    // TODO: Enums?
                    else => {
                        std.log.err("Cannot have a non-integral bitfield '{s}'!", .{name});
                        return null;
                    },
                };
                break :outer .{ .Member = type_ref };
            },

            // -- Values -- //

            c.CXCursor_IntegerLiteral,
            => outer: {
                const value = try allocator.create(i128);
                value.* = c.clang_EvalResult_getAsLongLong(c.clang_Cursor_Evaluate(cursor));

                break :outer .{
                    .Value = .{
                        .type = try .fromCXType(allocator, c.clang_getCursorType(cursor), ir),
                        .value = @ptrCast(value),
                    },
                };
            },
            c.CXCursor_EnumConstantDecl,
            => outer: {
                const value = try allocator.create(i128); // TODO: Allocate in accordance to parent cursor backing type?
                value.* = c.clang_getEnumConstantDeclValue(cursor);

                break :outer .{
                    .Value = .{
                        .type = try .fromCXType(allocator, c.clang_getCursorType(cursor), ir),
                        .value = @ptrCast(value),
                    },
                };
            },

            // -- Functions -- //

            c.CXCursor_FunctionDecl => outer: {
                // TODO: Convert these into normal methods.
                if (std.mem.startsWith(u8, name, "operator ")) return null;

                break :outer .{ .Function = .{ .return_type = try .fromCXType(allocator, c.clang_getCursorResultType(cursor), ir) } };
            },

            // -- Structs & Unions -- //

            c.CXCursor_StructDecl => .Struct,
            c.CXCursor_UnionDecl => .Union,

            // -- Enums -- //

            c.CXCursor_EnumDecl => .{
                .Enum = .{
                    .backing = switch ((try TypeReference.fromCXType(allocator, c.clang_getEnumDeclIntegerType(cursor), ir)).inner) {
                        .integer => |int| int,
                        else => @panic("How did you back an enum with a non-integer type..."),
                    },
                },
            },

            // -- Type Defintions -- //

            c.CXCursor_TypedefDecl => return null,
            // TODO: While we have serialization for these in place, the usage sites are resolved to the underlying types
            // TODO: Instead of the type definition and I don't see it being useful currently to undo that.
            // .{
            //     .Typedef = try .fromCXType(allocator, c.clang_getTypedefDeclUnderlyingType(cursor), ir),
            // },

            // -- TODO -- //

            c.CXCursor_CXXMethod,
            c.CXCursor_Constructor, // CXXConstructor
            c.CXCursor_Destructor,
            c.CXCursor_ConversionFunction,
            => return null,

            c.CXCursor_ClassTemplate,
            c.CXCursor_FunctionTemplate,
            => return null,

            c.CXCursor_VarDecl, // i.e. static or global members
            => return null,

            // -- Ignored -- //

            c.CXCursor_TypeRef, // Any time a non-primitive type is used; we get this info other ways.
            c.CXCursor_UsingDirective, // `using namespace ...`
            => return null,

            // -- Fallback -- //

            else => {
                log.warn("Cursor kind '{?s}' for cursor '{s}' not yet implemented!", .{ try ffi.getCursorKindSpelling(allocator, cursor.kind), name });
                return null;
            },
        },
        .__cursor = cursor,
    };
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

// -- Formatting -- //

var DEBUG_formattingIndentLevel: usize = 0;
const DEBUG_INDENTS = "\t" ** 256;
pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
    for (self.instrs.items) |instr| {
        if (instr.state == .close and DEBUG_formattingIndentLevel > 0) {
            DEBUG_formattingIndentLevel -= 1;
        }
        const indent = DEBUG_INDENTS[0..DEBUG_formattingIndentLevel];

        try writer.print("{s}[{s}] {s} '{s}' ([{?s}]{?s})\n", .{
            indent,
            @tagName(instr.state),
            @tagName(instr.inner),
            instr.name,
            ffi.getCursorKindSpelling(self.arena.allocator(), instr.__cursor.kind) catch @panic("OOM"),
            ffi.getCursorSpelling(self.arena.allocator(), instr.__cursor) catch @panic("OOM"),
        });
        if (instr.state == .close) continue;

        switch (instr.inner) {
            .Function => |f| try writer.print("{s}- Return Type: {f} ({f})\n", .{
                indent,
                f.return_type,
                FormatRawType{ .allocator = self.arena.allocator(), .cx_type = f.return_type.cx_type },
            }),
            .Value => |v| try writer.print("{s}- Type: {f} ({f})\n- Value: {f}\n", .{
                indent,
                v.type,
                FormatRawType{ .allocator = self.arena.allocator(), .cx_type = v.type.cx_type },
                v,
            }),
            .Member => |m| try writer.print("{s}- Type: {f} ({f})\n", .{
                indent,
                m,
                FormatRawType{ .allocator = self.arena.allocator(), .cx_type = m.cx_type },
            }),
            else => {},
        }

        if (instr.state == .open and instr.inner != .Member and instr.inner != .Value) DEBUG_formattingIndentLevel += 1;
    }
}

const FormatRawType = struct {
    allocator: std.mem.Allocator,
    cx_type: c.CXType,

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        try writer.print("[{?s}]{?s}", .{
            ffi.getTypeKindSpelling(self.allocator, self.cx_type.kind) catch @panic("OOM"),
            ffi.getTypeSpelling(self.allocator, self.cx_type) catch @panic("OOM"),
        });
    }
};

/// Only for debugging.
pub fn writeToFile(self: @This()) !void {
    const file = try std.fs.cwd().createFile("ir.txt", .{});
    defer file.close();

    var writer = file.writer(&.{});
    try self.format(&writer.interface);

    log.debug("Wrote IR to ir.txt!", .{});
}

// -- Tests -- //

test "fromTU" {
    const file = @embedFile("../testing/supported.hpp");

    const ir = try processBytes(std.testing.allocator, "supported.hpp", file, &.{});
    defer ir.deinit();

    log.warn("{f}", .{ir});
}
