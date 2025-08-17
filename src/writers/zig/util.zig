const std = @import("std");
const c = @import("../../ffi.zig").c;

const IR = @import("../../ir/IR.zig");
const TypeReference = IR.TypeReference;

const log = std.log.scoped(.zig_util);

pub const FormatType = struct {
    erase_array_size: bool = false,
    annotate_with_alignment: bool = false,
    type_ref: TypeReference,

    pub fn format(self: FormatType, writer: *std.Io.Writer) std.Io.Writer.Error!void {
        const t = self.type_ref;

        const alignment = c.clang_Type_getAlignOf(self.type_ref.cx_type);

        if (t.is_const) {
            try writer.writeAll("const ");
        }

        switch (t.inner) {
            .void => try writer.writeAll("void"),

            .bool => try writer.writeAll("bool"),
            .integer => |int| try writer.print("{s}{}", .{ if (int.signedness == .signed) "i" else "u", int.bits }),
            .float => |float| try writer.print("f{}", .{float.bits}),

            .pointer => |p| {
                if (p.inner == .void) {
                    try writer.writeAll("*");
                } else {
                    try writer.writeAll("[*c]");
                }
                try (FormatType{ .type_ref = p.* }).format(writer);
            },
            .reference => |r| {
                try writer.writeByte('*'); // TODO: I don't think these can be null?
                try (FormatType{ .type_ref = r.* }).format(writer);
            },

            .array => |a| {
                try writer.writeByte('[');
                if (a.count >= 0 and !self.erase_array_size) {
                    try writer.print("{}", .{a.count});
                } else {
                    try writer.writeByte('*');
                }
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
                log.err("Not yet formatted type '{s}'!", .{@tagName(t.inner)});
                try writer.print("[{}]u8", .{c.clang_Type_getSizeOf(t.cx_type)});
                if (self.annotate_with_alignment) try writer.print(" align({})", .{alignment});
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
    if (res.stdout.len > 0) std.debug.print("[zig build-lib {s} -fno-emit-bin stdout]:\n{s}", .{ path, res.stdout });
    if (res.stderr.len > 0) std.debug.print("[zig build-lib {s} -fno-emit-bin stderr]:\n{s}", .{ path, res.stderr });

    return success;
}
