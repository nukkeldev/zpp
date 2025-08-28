const std = @import("std");

const IR = @import("../../ir/IR.zig");
const TypeReference = IR.TypeReference;

const log = std.log.scoped(.cpp_util);

pub const FormatMember = struct {
    name: ?[]const u8 = null,
    dont_suffix_pointers: ?*bool = null,
    pointer_lvl: usize = 0,
    type_ref: TypeReference,

    const DEBUG = false;

    pub fn format(self: FormatMember, writer: *std.Io.Writer) std.Io.Writer.Error!void {
        const t = self.type_ref;

        if (DEBUG) try writer.print("/* kind: {s} */ ", .{@tagName(t.inner)});

        // References are implictly const which doesn't work with our pointer conversions.
        if (t.is_const and t.inner != .reference) {
            try writer.print("const ", .{});
        }

        switch (t.inner) {
            .void => try writer.writeAll("void"),

            .bool => try writer.writeAll("bool"),
            .float => |float| {
                switch (float.bits) {
                    32 => try writer.writeAll("float"),
                    64 => try writer.writeAll("double"),
                    else => log.warn("Float width '{}' not yet implemented!", .{float.bits}),
                }
            },
            .integer => |int| {
                if (int.signedness == .unsigned) {
                    try writer.writeAll("unsigned ");
                }

                switch (int.bits) {
                    8 => try writer.writeAll("char"),
                    32 => try writer.writeAll("int"),
                    64 => try writer.writeAll("long long"),
                    else => log.warn("Integer width '{}' not yet implemented!", .{int.bits}),
                }
            },

            .pointer => |p| {
                var tmp = false;
                const ptr = self.dont_suffix_pointers orelse &tmp;
                try (FormatMember{
                    .name = self.name,
                    .type_ref = p.*,
                    .pointer_lvl = self.pointer_lvl + 1,
                    .dont_suffix_pointers = ptr,
                }).format(writer);
                if (!ptr.*) {
                    try writer.writeByte('*');
                } else {
                    return;
                }
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

            .record, .included, .enumeration => |name| try writer.writeAll(name),

            .function => |f| {
                // TODO: handle pointer return types
                try writer.print("{f} (", .{FormatMember{ .type_ref = f.return_type.* }});
                for (0..self.pointer_lvl) |_| try writer.writeByte('*');
                try writer.print("{s})(", .{
                    self.name orelse "",
                });
                for (f.params, 0..) |p, i| {
                    try (FormatMember{ .type_ref = p }).format(writer);
                    if (i < f.params.len - 1 or f.variadic) try writer.writeAll(", ");
                }
                if (f.variadic) try writer.writeAll("...");
                try writer.writeByte(')');

                self.dont_suffix_pointers.?.* = true;
                return;
            },

            else => {
                log.err("Not yet formatted type: '{s}'!", .{@tagName(t.inner)});
                try writer.print("void*", .{});
            },
        }

        if (self.pointer_lvl == 0) if (self.name) |name| try writer.print(" {s}", .{name});
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

    log.debug("clang args: [", .{});
    for (clang_args) |a| log.debug("\t{s}", .{a});
    log.debug("]", .{});

    const translation_unit = c.clang_parseTranslationUnit(index, path.ptr, @ptrCast(clang_args), @intCast(clang_args.len), null, 0, 0);
    defer c.clang_disposeTranslationUnit(translation_unit);

    return translation_unit != null;
}
