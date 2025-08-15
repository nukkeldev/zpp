const std = @import("std");
const util = @import("util.zig");

const IR = @import("../../ir/IR.zig");

const log = std.log.scoped(.cpp_wrapper);

pub fn formatFilename(allocator: std.mem.Allocator, filename: []const u8) std.mem.Allocator.Error![:0]const u8 {
    return std.fmt.allocPrintSentinel(allocator, "{s}.cpp", .{filename}, 0);
}

pub fn formatFile(ir: IR, writer: *std.Io.Writer) std.Io.Writer.Error!void {
    try writer.writeAll(@import("../../writers.zig").PREAMBLE);
    try writer.print("\n\n#include \"{s}\"\n\n", .{std.fs.path.basename(ir.path)});

    if (ir.instrs.items.len == 0) {
        try writer.writeAll("// Why are you generating an empty file?\n");
        return;
    }

    var i: usize = 0;

    var ns_stack: std.ArrayList([]const u8) = .init(ir.arena.allocator());
    var fn_params: std.ArrayList(usize) = .init(ir.arena.allocator());

    var ignore_members: bool = false; // TODO: This won't hold up well...

    while (i < ir.instrs.items.len) : (i += 1) {
        const instr = ir.instrs.items[i];
        const uname = instr.getUniqueName(ir.arena.allocator()) catch @panic("OOM");

        if (instr.state == .open) {
            switch (instr.inner) {
                .Namespace => ns_stack.append(instr.name) catch @panic("OOM"),
                .Function => |f| {
                    try writer.print("extern \"C\" {f} {s}(", .{
                        util.FormatMember{ .type_ref = f.return_type },
                        uname,
                    });
                    ignore_members = false;
                },
                .Member => |m| if (!ignore_members) {
                    try (util.FormatMember{ .type_ref = m, .name = instr.name }).format(writer);
                    if (ir.instrs.items[i + 1].inner == .Member) try writer.writeAll(", ");

                    fn_params.append(i) catch @panic("OOM");
                },
                .Struct, .Enum, .Union, .Value => ignore_members = true,
                else => {
                    log.warn("Open instruction '{s}' not yet implemented!", .{@tagName(instr.inner)});
                },
            }
        } else {
            switch (instr.inner) {
                .Namespace => _ = ns_stack.pop(),
                .Function => |f| {
                    try writer.print(") {{\n", .{});
                    
                    try writer.writeAll("\treturn ");
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
                    fn_params = .init(ir.arena.allocator());

                    try writer.writeAll(");\n}\n");
                },
                .Struct, .Enum, .Union, .Value => {},
                else => {
                    log.warn("Close instruction '{s}' not yet implemented!", .{@tagName(instr.inner)});
                },
            }
        }
    }
}
