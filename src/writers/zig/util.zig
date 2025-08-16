const std = @import("std");

const IR = @import("../../ir/IR.zig");
const TypeReference = IR.TypeReference;

const log = std.log.scoped(.zig_util);

pub const FormatType = struct {
    type_ref: TypeReference,

    pub fn format(self: FormatType, writer: *std.Io.Writer) std.Io.Writer.Error!void {
        const t = self.type_ref;

        // TODO: const

        switch (t.inner) {
            .void => try writer.writeAll("void"),

            .bool => try writer.writeAll("bool"),
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

            .enumeration, .record => |name| try writer.writeAll(name),

            .function => |f| {
                try writer.writeAll("*const fn (");
                for (f.params, 0..) |p, i| {
                    try (FormatType{ .type_ref = p }).format(writer);
                    if (i < f.params.len - 1 or f.variadic) try writer.writeAll(", ");
                }
                if (f.variadic) try writer.writeAll("...");
                try writer.print(") callconv(.c) {f}", .{
                    FormatType{ .type_ref = f.return_type.* },
                });
            },

            else => {
                log.err("Not yet formatted type: '{s}'!", .{@tagName(t.inner)});
                try writer.print("?*anyopaque", .{});
            },
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
    _ = args;

    const res = try std.process.Child.run(.{
        .allocator = allocator,
        .argv = &.{ "zig", "build-lib", path, "-fno-emit-bin" },
    });

    const success = res.term == .Exited and res.term.Exited == 0;
    if (!success) std.debug.print("{s}", .{res.stderr});

    return success;
}
