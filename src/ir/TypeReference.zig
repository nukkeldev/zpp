// -- Imports & Constants -- //

const std = @import("std");
const ffi = @import("../ffi.zig");

const c = ffi.c;
const Allocator = std.mem.Allocator;

const TypeReference = @This();

const log = std.log.scoped(.type);

// -- Fields -- //

is_const: bool,
inner: Inner,
cx_type: c.CXType,

// -- Types -- //

pub const Inner = union(enum) {
    unexposed,
    void,
    integer: Integral,
    record: ?[]const u8,
    enumeration: ?[]const u8,
    pointer: *TypeReference,
    reference: *TypeReference,

    not_yet_implemented,
};

pub const Integral = std.builtin.Type.Int;

// -- Error -- //

pub const TypeReferenceError = error{};

// -- Functions -- //

pub fn fromCXType(allocator: Allocator, cx_type: c.CXType) (TypeReferenceError || Allocator.Error)!@This() {
    return TypeReference{
        .is_const = c.clang_isConstQualifiedType(cx_type) != 0,
        .inner = switch (cx_type.kind) {
            // -- Unexposed & Void -- //

            c.CXType_Unexposed => .unexposed,
            c.CXType_Void => .void,

            // -- Integers -- //

            c.CXType_Char_U,
            c.CXType_UChar,
            c.CXType_UShort,
            c.CXType_UInt,
            c.CXType_ULong,
            c.CXType_ULongLong,
            c.CXType_UInt128,
            => .{
                .integer = .{
                    .bits = @intCast(c.clang_Type_getSizeOf(cx_type) * 8),
                    .signedness = .unsigned,
                },
            },
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
            => .{
                .integer = .{
                    .bits = @intCast(c.clang_Type_getSizeOf(cx_type) * 8),
                    .signedness = .signed,
                },
            },

            // -- Pointers & References -- //

            c.CXType_Pointer => outer: {
                const pointee = try allocator.create(TypeReference);
                pointee.* = try fromCXType(allocator, c.clang_getPointeeType(cx_type));

                break :outer .{ .pointer = pointee };
            },
            c.CXType_LValueReference => outer: {
                const pointee = try allocator.create(TypeReference);
                pointee.* = try fromCXType(allocator, c.clang_getPointeeType(cx_type));

                break :outer .{ .reference = pointee };
            },

            // -- Records & Enums -- //

            c.CXType_Record => .{ .record = try ffi.getTypeSpelling(allocator, cx_type) },
            c.CXType_Enum => .{ .enumeration = try ffi.getTypeSpelling(allocator, cx_type) },

            // -- Fallback --//

            else => outer: {
                log.warn("Unhandled type '{?s}'!", .{try ffi.getTypeKindSpelling(allocator, cx_type.kind)});
                break :outer .not_yet_implemented;
            },
        },
        .cx_type = cx_type,
    };
}

// -- Formatting -- //

pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
    if (self.is_const) try writer.writeAll("const ");
    switch (self.inner) {
        .integer => |int| {
            if (int.signedness == .signed) try writer.writeByte('i') else try writer.writeByte('u');
            try writer.print("{}", .{int.bits});
        },
        .record => |name| try writer.print("record '{?s}'", .{name}),
        .enumeration => |name| try writer.print("enum '{?s}'", .{name}),
        .pointer => |pointee| try writer.print("pointer to '{f}'", .{pointee}),
        .reference => |pointee| try writer.print("reference to '{f}'", .{pointee}),
        else => try writer.writeAll(@tagName(self.inner)),
    }
}
