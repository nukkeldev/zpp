const std = @import("std");
const util = @import("util.zig");

const IR = @import("../../ir/IR.zig");

const log = std.log.scoped(.zig_wrapper);

pub fn formatFilename(allocator: std.mem.Allocator, filename: []const u8) std.mem.Allocator.Error![:0]const u8 {
    return std.fmt.allocPrintSentinel(allocator, "{s}.zig", .{filename}, 0);
}

// TODO: This function is horrendous; please:
// TODO: - Fix the member stack horror.
pub fn formatFile(ir: IR, writer: *std.Io.Writer) std.Io.Writer.Error!void {
    try writer.writeAll(@import("../../writers.zig").PREAMBLE);
    try writer.writeAll("\n\n");

    if (ir.instrs.items.len == 0) {
        try writer.writeAll("// Why are you generating an empty file?\n");
        return;
    }

    var i: usize = 0;

    var fwd_decls: std.StringHashMap(void) = .init(ir.arena.allocator());
    var overload_map: std.StringHashMap(usize) = .init(ir.arena.allocator());
    var ns_stack: std.ArrayList([]const u8) = .init(ir.arena.allocator());
    var member_stack: std.ArrayList(*std.ArrayList(usize)) = .init(ir.arena.allocator());
    var ctx_stack: std.ArrayList(enum { func, struc, enu, uni, ns }) = .init(ir.arena.allocator());
    ctx_stack.append(.ns) catch @panic("OOM");

    while (i < ir.instrs.items.len) : (i += 1) {
        const instr = ir.instrs.items[i];
        std.debug.print("{s}\n", .{instr.name});
        const uname = instr.getUniqueName(ir.arena.allocator()) catch @panic("OOM");

        if (instr.state == .open) {
            switch (instr.inner) {
                .Namespace => {
                    try writer.print("pub const {s} = struct {{\n", .{instr.name});

                    ns_stack.append(instr.name) catch @panic("OOM");
                    ctx_stack.append(.ns) catch @panic("OOM");
                },
                .Function => {
                    const overload_ptr = (overload_map.getOrPutValue(uname, 0) catch @panic("OOM")).value_ptr;
                    defer overload_ptr.* += 1;
                    const suffix = if (overload_ptr.* == 0) "" else std.fmt.allocPrint(ir.arena.allocator(), "_{}", .{overload_ptr.*}) catch @panic("OOM");

                    try writer.print("pub const {s}{s} = {s}{s};\n", .{ instr.name, suffix, uname, suffix });
                    try writer.print("extern fn {s}{s}(", .{ uname, suffix });

                    ctx_stack.append(.func) catch @panic("OOM");

                    const new_stack = ir.arena.allocator().create(std.ArrayList(usize)) catch @panic("OOM");
                    new_stack.* = .init(ir.arena.allocator());

                    member_stack.append(new_stack) catch @panic("OOM");
                },
                .Member => |m| {
                    try writer.print("{s}: {f}{s}", .{
                        instr.name,
                        util.FormatType{ .type_ref = m },
                        if (ctx_stack.getLast() == .func) outer: {
                            break :outer if (ir.instrs.items[i + 1].inner == .Member) ", " else "";
                        } else outer: {
                            break :outer ",\n";
                        },
                    });
                    member_stack.getLast().append(i) catch @panic("OOM");
                },
                .Value => |v| {
                    try writer.print("pub const {s}: {f} = {f};\n", .{ instr.name, util.FormatType{ .type_ref = v.type }, v });
                    member_stack.getLast().append(i) catch @panic("OOM");
                },
                .Struct => {
                    const new_stack = ir.arena.allocator().create(std.ArrayList(usize)) catch @panic("OOM");
                    new_stack.* = .init(ir.arena.allocator());

                    member_stack.append(new_stack) catch @panic("OOM");

                    // Ignore forward definitions, this might hit empty structs tho.
                    if (ir.instrs.items[i + 1].state == .close) {
                        fwd_decls.put(instr.name, {}) catch @panic("OOM");
                        continue;
                    }
                    _ = fwd_decls.remove(instr.name);

                    try writer.print("pub const {s} = extern struct {{\n", .{instr.name});

                    ctx_stack.append(.struc) catch @panic("OOM");
                },
                .Enum => |e| {
                    const new_stack = ir.arena.allocator().create(std.ArrayList(usize)) catch @panic("OOM");
                    new_stack.* = .init(ir.arena.allocator());

                    member_stack.append(new_stack) catch @panic("OOM");

                    if (ir.instrs.items[i + 1].state == .close) continue; // Ignore forward definitions, this might hit empty structs tho.
                    const T = util.FormatType{
                        .type_ref = .{
                            .is_const = false,
                            .cx_type = undefined,
                            .inner = .{ .integer = e.backing },
                        },
                    };
                    try writer.print("pub const {s} = packed struct({f}) {{\n", .{ instr.name, T });
                    try writer.print("data: {f},\n", .{T});

                    ctx_stack.append(.enu) catch @panic("OOM");
                },
                .Union => {
                    const new_stack = ir.arena.allocator().create(std.ArrayList(usize)) catch @panic("OOM");
                    new_stack.* = .init(ir.arena.allocator());

                    member_stack.append(new_stack) catch @panic("OOM");

                    if (ir.instrs.items[i + 1].state == .close) continue; // Ignore forward definitions, this might hit empty structs tho.

                    switch (ctx_stack.getLast()) {
                        .struc => {
                            try writer.writeAll("anon: union(enum) {\n");
                        },
                        else => {
                            try writer.print("pub const {s} = union(enum) {{\n", .{instr.name});
                        },
                    }

                    ctx_stack.append(.uni) catch @panic("OOM");
                },
                .Typedef => |t| {
                    try writer.print("pub const {s} = {f};\n", .{
                        instr.name,
                        util.FormatType{ .type_ref = t },
                    });
                },
                // else => {
                //     log.warn("Open instruction '{s}' not yet implemented!", .{@tagName(instr.inner)});
                // },
            }
        } else {
            switch (instr.inner) {
                .Namespace => {
                    try writer.writeAll("};\n\n");
                    _ = ns_stack.pop();
                    _ = ctx_stack.pop();
                },
                .Function => |f| {
                    if (f.return_type.inner == .record) {
                        // TODO: Avoid name collisions.
                        if (member_stack.getLast().items.len > 0) try writer.writeAll(", ");
                        try writer.print("zpp_out: *{f}", .{
                            util.FormatType{ .type_ref = f.return_type },
                        });
                    }

                    try writer.print(") callconv(.c) {f};\n\n", .{
                        util.FormatType{
                            .type_ref = switch (f.return_type.inner) {
                                .record => .VOID,
                                else => f.return_type,
                            },
                        },
                    });

                    _ = ctx_stack.pop();
                    member_stack.getLast().clearAndFree();
                    _ = member_stack.pop();
                },
                .Union => {
                    if (member_stack.getLast().items.len == 0) continue;
                    member_stack.getLast().clearAndFree();
                    _ = member_stack.pop();

                    _ = ctx_stack.pop();
                    try writer.writeAll("}");
                    switch (ctx_stack.getLast()) {
                        .struc => try writer.writeAll(",\n"),
                        else => try writer.writeAll(";\n\n"),
                    }
                },
                .Struct, .Enum => {
                    if (member_stack.getLast().items.len == 0) continue;
                    member_stack.getLast().clearAndFree();
                    _ = member_stack.pop();

                    _ = ctx_stack.pop();
                    try writer.writeAll("};\n\n");
                },
                .Typedef => {},
                .Member, .Value => unreachable,
                // else => {
                //     log.warn("Close instruction '{s}' not yet implemented!", .{@tagName(instr.inner)});
                // },
            }
        }
    }

    var opaque_type_decls_iter = fwd_decls.keyIterator();
    while (opaque_type_decls_iter.next()) |t| {
        try writer.print("pub const {s} = ?*anyopaque;\n", .{t.*});
    }
}
