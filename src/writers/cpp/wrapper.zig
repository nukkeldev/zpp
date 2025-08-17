const std = @import("std");
const util = @import("util.zig");

const IR = @import("../../ir/IR.zig");

const log = std.log.scoped(.cpp_wrapper);

pub fn formatFilename(allocator: std.mem.Allocator, filename: []const u8) std.mem.Allocator.Error![:0]const u8 {
    return std.fmt.allocPrintSentinel(allocator, "{s}.cpp", .{filename}, 0);
}

pub fn formatFile(ir: IR, writer: *std.Io.Writer) std.Io.Writer.Error!void {
    try writer.writeAll(@import("../../writers.zig").PREAMBLE);
    try writer.writeAll(
        \\
        \\
        \\#include <cstdarg>
        \\
        \\#pragma clang diagnostic push
        \\#pragma clang diagnostic ignored "-Wformat-security"
        \\
        \\
    );
    try writer.print("#include \"{s}\"\n\n", .{std.fs.path.basename(ir.path)});

    if (ir.instrs.items.len == 0) {
        try writer.writeAll("// Why are you generating an empty file?\n");
        return;
    }

    var i: usize = 0;

    var overload_map: std.StringHashMap(usize) = .init(ir.arena.allocator());
    var ns_stack: std.array_list.Managed([]const u8) = .init(ir.arena.allocator());
    var fn_params: std.array_list.Managed(usize) = .init(ir.arena.allocator());

    var ignore_members: bool = false; // TODO: This won't hold up well...

    while (i < ir.instrs.items.len) : (i += 1) {
        const instr = ir.instrs.items[i];
        const uname = instr.getUniqueName(ir.arena.allocator()) catch @panic("OOM");

        if (instr.state == .open) {
            switch (instr.inner) {
                .Namespace => ns_stack.append(instr.name) catch @panic("OOM"),
                .Function => |f| {
                    const overload_ptr = (overload_map.getOrPutValue(uname, 0) catch @panic("OOM")).value_ptr;
                    defer overload_ptr.* += 1;

                    try writer.print("extern \"C\" {f} {s}", .{
                        util.FormatMember{
                            .type_ref = switch (f.return_type.inner) {
                                .record => .VOID,
                                else => f.return_type,
                            },
                        },
                        uname,
                    });
                    if (overload_ptr.* > 0) try writer.print("_{}", .{overload_ptr.*});
                    try writer.writeByte('(');

                    ignore_members = false;
                },
                .Member => |m| if (!ignore_members) {
                    try (util.FormatMember{ .type_ref = m, .name = instr.name }).format(writer);
                    if (ir.instrs.items[i + 1].inner == .Member) try writer.writeAll(", ");

                    fn_params.append(i) catch @panic("OOM");
                },
                .Struct, .Enum, .Union, .Value, .Typedef => ignore_members = true,
                // else => {
                //     log.warn("Open instruction '{s}' not yet implemented!", .{@tagName(instr.inner)});
                // },
            }
        } else {
            switch (instr.inner) {
                .Namespace => _ = ns_stack.pop(),
                .Function => |f| {
                    const use_out_param = f.return_type.inner == .record;
                    const needs_to_return = f.return_type.inner != .void and f.return_type.inner != .record;

                    if (use_out_param) {
                        // TODO: Avoid name collisions.
                        if (fn_params.items.len > 0) try writer.writeAll(", ");
                        try writer.print("{f} *zpp_out", .{util.FormatMember{ .type_ref = f.return_type }});
                    }

                    if (f.variadic) {
                        if (fn_params.items.len == 0) @panic("Please see a doctor.");
                        try writer.writeAll(", ...) {\n");
                        try writer.print(
                            "\tva_list __ZPP_args;\n\tva_start(__ZPP_args, {s});\n\t",
                            .{ir.instrs.items[fn_params.getLast()].name},
                        );
                    } else {
                        try writer.writeAll(") {\n\t");
                    }

                    if (needs_to_return) {
                        if (f.variadic) {
                            try writer.print(
                                "{f} __ZPP_result = ",
                                .{util.FormatMember{ .type_ref = f.return_type }},
                            );
                        } else {
                            try writer.writeAll("return ");
                        }
                    }

                    switch (f.return_type.inner) {
                        .reference => try writer.writeAll("&"),
                        else => {},
                    }

                    for (ns_stack.items) |n| try writer.print("{s}::", .{n});
                    try writer.print("{s}(", .{instr.name});

                    for (fn_params.items, 0..) |p, j| {
                        const m = ir.instrs.items[p];
                        switch (m.inner.Member.inner) {
                            .reference => try writer.writeByte('*'),
                            else => {},
                        }

                        try writer.writeAll(m.name);
                        if (j < fn_params.items.len - 1) try writer.writeAll(", ");
                    }
                    fn_params.clearAndFree();

                    try writer.writeAll(");\n");
                    if (f.variadic) try writer.writeAll("\tva_end(__ZPP_args);\n");
                    if (needs_to_return and f.variadic) try writer.writeAll("\treturn __ZPP_result;\n");
                    try writer.writeAll("}\n");
                },
                .Struct, .Enum, .Union, .Typedef => {
                    fn_params.clearAndFree();
                },
                .Member, .Value => unreachable,
                // else => {
                //     log.warn("Close instruction '{s}' not yet implemented!", .{@tagName(instr.inner)});
                // },
            }
        }
    }

    try writer.writeAll("#pragma clang diagnostic pop");
}
