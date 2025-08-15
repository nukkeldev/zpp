const std = @import("std");

const IR = @import("../../ir/IR.zig");
const TypeReference = IR.TypeReference;

pub const FormatMember = struct {
    name: ?[]const u8 = null,
    type_ref: TypeReference,

    pub fn format(self: FormatMember, writer: *std.Io.Writer) std.Io.Writer.Error!void {
        const t = self.type_ref;

        // References are implictly const which doesn't work with our pointer conversions.
        if (t.is_const and t.inner != .reference) {
            try writer.print("const ", .{});
        }

        switch (t.inner) {
            .void => try writer.writeAll("void"),

            .integer => |int| {
                if (int.signedness == .unsigned) {
                    try writer.writeAll("unsigned ");
                }

                switch (int.bits) {
                    8 => try writer.writeAll("char"),
                    32 => try writer.writeAll("int"),
                    else => {
                        std.log.warn("Integer width '{}' not yet implemented!", .{int.bits});
                    },
                }
            },

            .pointer => |p| {
                try (FormatMember{ .type_ref = p.* }).format(writer);
                try writer.writeByte('*');
            },
            .reference => |r| {
                try (FormatMember{ .type_ref = r.* }).format(writer);
                try writer.writeByte('*');
            },

            .array => |a| {
                try (FormatMember{ .name = self.name, .type_ref = a.element_type.* }).format(writer);
                try writer.writeByte('[');
                if (a.count >= 0) try writer.print("{}", .{a.count});
                try writer.writeByte(']');
                return;
            },

            .record, .enumeration => |name| try writer.writeAll(name orelse "/* TODO: Unnamed ~Record */"),

            else => try writer.print("/* TODO: Type not yet formatted: '{s}' */", .{@tagName(t.inner)}),
        }

        if (self.name) |name| try writer.print(" {s}", .{name});
    }
};

pub fn checkFile(allocator: std.mem.Allocator, path: [:0]const u8, args: anytype) std.mem.Allocator.Error!bool {
    const c = @import("../../ffi.zig").c;

    const index = c.clang_createIndex(0, 1);
    defer c.clang_disposeIndex(index);

    const clang_args = try IR.combineArgs(
        allocator,
        &.{
            IR.REQUIRED_ARGUMENTS,
            &.{try std.fmt.allocPrintSentinel(allocator, "-I{s}", .{args.source_dir}, 0)},
            args.clang_args,
        },
    );
    defer allocator.free(clang_args);

    const translation_unit = c.clang_parseTranslationUnit(index, path.ptr, @ptrCast(clang_args), @intCast(clang_args.len), null, 0, 0);
    defer c.clang_disposeTranslationUnit(translation_unit);

    return translation_unit != null;
}
