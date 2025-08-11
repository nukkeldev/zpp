//! An intermediate representation of a C++ header.
//!
//! Requirements:
//! - Represent as much information as necessary without _needing_ to expose underlying Index API cursors.
//! - Maintain declaration ordering as some languages require it (i.e. C++).
//!
//! Structure:
//! - The IR is flat (i.e. namespace scopes are it's own "instruction")
//! - Processing can be linear; required declarations are included in a jump table as well.

// -- Imports -- //

const std = @import("std");
const ffi = @import("../ffi.zig");

const c = ffi.c;
const Allocator = std.mem.Allocator;

const TypeReference = @import("TypeReference.zig");
const IR = @This();

const log = std.log.scoped(.ir);

// -- Fields -- //

arena: *std.heap.ArenaAllocator,
instrs: std.ArrayList(Instruction),

// -- (De)initialization -- //

pub fn init(allocator: Allocator) !IR {
    const arena = try allocator.create(std.heap.ArenaAllocator);
    arena.* = .init(allocator);
    return .{ .arena = arena, .instrs = .init(arena.allocator()) };
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

const CLANG_DISPLAY_DIAGNOSTICS = true;
const REQUIRED_ARGUMENTS: []const [:0]const u8 = &.{"-xc++"};
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
    const index = c.clang_createIndex(0, if (CLANG_DISPLAY_DIAGNOSTICS) 1 else 0);
    defer c.clang_disposeIndex(index);

    var file = c.CXUnsavedFile{ .Filename = path, .Contents = contents.ptr, .Length = @intCast(contents.len) };
    const args = try convertArguments(allocator, clang_args);
    defer allocator.free(args);

    const translation_unit = c.clang_parseTranslationUnit(index, path, @ptrCast(args), @intCast(args.len), &file, 1, TU_FLAGS);
    defer c.clang_disposeTranslationUnit(translation_unit);

    if (translation_unit == null) return IRProcessingError.ParseTUFail;
    const cursor = c.clang_getTranslationUnitCursor(translation_unit);

    var state = ProcessingState{ .ir = try .init(allocator) };
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

    const state: *ProcessingState = @alignCast(@ptrCast(client_data_opaque));

    const instr_opt = visitor(state.ir.arena.allocator(), current_cursor) catch |e| {
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

fn visitor(allocator: std.mem.Allocator, cursor: c.CXCursor) !?Instruction {
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
            => .{ .Member = try .fromCXType(allocator, c.clang_getCursorType(cursor)) },

            // -- Values -- //

            c.CXCursor_IntegerLiteral,
            => outer: {
                const value = try allocator.create(i128);
                value.* = c.clang_EvalResult_getAsLongLong(c.clang_Cursor_Evaluate(cursor));

                break :outer .{
                    .Value = .{
                        .type = try .fromCXType(allocator, c.clang_getCursorType(cursor)),
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
                        .type = try .fromCXType(allocator, c.clang_getCursorType(cursor)),
                        .value = @ptrCast(value),
                    },
                };
            },

            // -- Functions -- //

            c.CXCursor_FunctionDecl => .{ .Function = .{ .return_type = try .fromCXType(allocator, c.clang_getCursorResultType(cursor)) } },

            // -- Structs & Unions -- //

            c.CXCursor_StructDecl => .Struct,
            c.CXCursor_UnionDecl => .Union,

            // -- Enums -- //

            c.CXCursor_EnumDecl => .{
                .Enum = .{
                    .backing = switch ((try TypeReference.fromCXType(allocator, c.clang_getEnumDeclIntegerType(cursor))).inner) {
                        .integer => |int| int,
                        else => @panic("How did you back an enum with a non-integer type..."),
                    },
                },
            },

            // -- Type Defintions -- //

            c.CXCursor_TypedefDecl => .{
                .Typedef = try .fromCXType(allocator, c.clang_getTypedefDeclUnderlyingType(cursor)),
            },

            // -- Ignored -- //

            c.CXCursor_TypeRef,
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

// -- Formatting -- //

pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
    for (self.instrs.items) |instr| {
        try writer.print("[{s}] {s} '{s}'\n", .{ @tagName(instr.state), @tagName(instr.inner), instr.name });
        if (instr.state == .close) continue;

        switch (instr.inner) {
            .Function => |f| try writer.print("- Return Type: {f}\n", .{f.return_type}),
            .Value => |v| try writer.print("- Type: {f}\n- Value: {f}\n", .{ v.type, v }),
            else => {},
        }
    }
}

// -- Tests -- //

test "fromTU" {
    const file = @embedFile("../testing/supported.hpp");

    const ir = try processBytes(std.testing.allocator, "supported.hpp", file, &.{});
    defer ir.deinit();

    log.warn("IR:\n{f}", .{ir});
}
