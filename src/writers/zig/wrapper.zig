const std = @import("std");
const util = @import("util.zig");

const IR = @import("../../ir/IR.zig");

const log = std.log.scoped(.zig_wrapper);

pub fn formatFilename(allocator: std.mem.Allocator, filename: []const u8) std.mem.Allocator.Error![:0]const u8 {
    return std.fmt.allocPrintSentinel(allocator, "{s}.zig", .{filename}, 0);
}

pub fn formatFile(ir: IR, writer: *std.Io.Writer) std.Io.Writer.Error!void {
    try writer.writeAll(@import("../../writers.zig").PREAMBLE);
    try writer.writeAll("\n\n");

    if (ir.instrs.items.len == 0) {
        try writer.writeAll("// Why are you generating an empty file?\n");
        return;
    }

    var i: usize = 0;

    var ns_stack: std.ArrayList([]const u8) = .init(ir.arena.allocator());
    var fn_params: std.ArrayList(usize) = .init(ir.arena.allocator());

    while (i < ir.instrs.items.len) : (i += 1) {
        const instr = ir.instrs.items[i];
        const uname = instr.getUniqueName(ir.arena.allocator()) catch @panic("OOM");

        if (instr.state == .open) {
            switch (instr.inner) {
                .Namespace => {
                    try writer.print("pub const {s} = struct {{\n", .{instr.name});
                    ns_stack.append(instr.name) catch @panic("OOM");
                },
                .Function => {
                    try writer.print("pub const {s} = {s};\n", .{ instr.name, uname });
                    try writer.print("extern fn {s}(", .{uname});
                },
                .Member => |m| {
                    try writer.print("{s}: {f}{s}", .{
                        instr.name,
                        util.FormatType{ .type_ref = m },
                        if (ir.instrs.items[i + 1].inner == .Member) ", " else "",
                    });
                    fn_params.append(i) catch @panic("OOM");
                },
                .Value => |v| {
                    try writer.print("pub const {s}: {f} = {f}; ", .{ instr.name, util.FormatType{ .type_ref = v.type }, v });
                },
                .Struct => {
                    try writer.print("pub const {s} = extern struct {{ ", .{instr.name});
                },
                .Enum => |e| {
                    const T = util.FormatType{
                        .type_ref = .{
                            .is_const = false,
                            .cx_type = undefined,
                            .inner = .{ .integer = e.backing },
                        },
                    };
                    try writer.print("pub const {s} = packed struct({f}) {{ ", .{ instr.name, T });
                    try writer.print("data: {f}, ", .{T});
                },
                .Union => {
                    try writer.print("pub const {s} = union(enum) {{ ", .{instr.name});
                },
                else => {
                    log.warn("Open instruction '{s}' not yet implemented!", .{@tagName(instr.inner)});
                },
            }
        } else {
            switch (instr.inner) {
                .Namespace => {
                    try writer.writeAll("};\n\n");
                    _ = ns_stack.pop();
                },
                .Function => |f| {
                    try writer.print(") callconv(.c) {f};\n\n", .{
                        util.FormatType{ .type_ref = f.return_type },
                    });
                    fn_params.clearAndFree();
                },
                .Struct, .Enum, .Union => {
                    try writer.writeAll("};\n\n");
                },
                else => {
                    log.warn("Close instruction '{s}' not yet implemented!", .{@tagName(instr.inner)});
                },
            }
        }
    }
}
