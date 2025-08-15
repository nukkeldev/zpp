const std = @import("std");

const IR = @import("../../ir/IR.zig");
const TypeReference = IR.TypeReference;

pub const FormatType = struct {
    type_ref: TypeReference,

    pub fn format(self: FormatType, writer: *std.Io.Writer) std.Io.Writer.Error!void {
        const t = self.type_ref;

        // TODO: const

        switch (t.inner) {
            .void => try writer.writeAll("void"),

            .integer => |int| try writer.print("{s}{}", .{ if (int.signedness == .signed) "i" else "u", int.bits }),
            .float => |float| try writer.print("f{}", .{float.bits}),

            .pointer => |p| {
                try writer.writeByte('*');
                try (FormatType{ .type_ref = p.* }).format(writer);
            },
            .reference => |r| {
                try writer.writeByte('*');
                try (FormatType{ .type_ref = r.* }).format(writer);
            },

            .array => |a| {
                try writer.writeByte('[');
                if (a.count >= 0) try writer.print("{}", .{a.count});
                try writer.writeByte(']');
                try (FormatType{ .type_ref = a.element_type.* }).format(writer);
            },

            .record, .enumeration => |name| try writer.writeAll(name orelse "/* TODO: Unnamed ~Record */"),

            else => try writer.print("/* TODO: Type not yet formatted: '{s}' */", .{@tagName(t.inner)}),
        }
    }
};

pub fn postProcessFile(allocator: std.mem.Allocator, path: []const u8) !void {
    _ = try std.process.Child.run(.{
        .allocator = allocator,
        .argv = &.{ "zig", "fmt", std.fs.path.dirname(path) orelse "." },
    });
}

pub fn checkFile(allocator: std.mem.Allocator, path: [:0]const u8, args: anytype) std.mem.Allocator.Error!bool {
    _ = allocator;
    _ = path;
    _ = args;

    return true;
}
