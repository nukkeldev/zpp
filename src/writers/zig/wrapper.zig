// -- Imports -- //

const std = @import("std");
const util = @import("util.zig");
const ffi = @import("../../ffi.zig");

const c = ffi.c;
const IR = @import("../../ir/IR.zig");

const log = std.log.scoped(.zig_wrapper);

// -- Configuration -- //

const ANONYMOUS_MEMBER_PREFIX = "anon";

// -- Writer -- //

pub fn formatFilename(allocator: std.mem.Allocator, filename: []const u8) std.mem.Allocator.Error![:0]const u8 {
    return std.fmt.allocPrintSentinel(allocator, "{s}.zig", .{filename}, 0);
}

// TODO: This function is horrendous; please:
// TODO: - Fix the member stack horror.
// TODO: - Convert this to be a stateful struct, so we can use methods and such.
pub fn formatFile(ir: IR, writer: *std.Io.Writer) std.Io.Writer.Error!void {
    try writer.writeAll(@import("../../writers.zig").PREAMBLE);
    try writer.writeAll("\n\n");

    if (ir.instrs.items.len == 0) {
        try writer.writeAll("// Why are you generating an empty file?\n");
        return;
    }

    try writer.writeAll(
        \\
        \\fn refAllDecls(comptime T: type) void {
        \\    inline for (comptime @import("std").meta.declarations(T)) |decl| {
        \\        _ = &@field(T, decl.name);
        \\    }
        \\}
        \\
        \\
    );

    var i: usize = 0;

    var fwd_decls: std.StringHashMap(usize) = .init(ir.arena.allocator());
    var overload_map: std.StringHashMap(usize) = .init(ir.arena.allocator());
    var ns_stack: std.array_list.Managed([]const u8) = .init(ir.arena.allocator());
    var member_stack: std.array_list.Managed(*std.array_list.Managed(usize)) = .init(ir.arena.allocator());
    var ctx_stack: std.array_list.Managed(union(enum) {
        func,
        /// The amount of unnamed fields
        struc: usize,
        enu,
        uni,
        ns,
        bitfield: usize,
    }) = .init(ir.arena.allocator());
    ctx_stack.append(.ns) catch @panic("OOM");

    while (i < ir.instrs.items.len) : (i += 1) {
        const instr = ir.instrs.items[i];
        const uname = instr.getUniqueName(ir.arena.allocator(), ns_stack.items) catch @panic("OOM");

        if (instr.state == .open) {
            switch (instr.inner) {
                .Namespace => {
                    try writer.print("pub const {s} = struct {{\n", .{instr.name});

                    ns_stack.append(instr.name) catch @panic("OOM");
                    ctx_stack.append(.ns) catch @panic("OOM");
                },
                .Function => |f| {
                    const overload_ptr = (overload_map.getOrPutValue(uname, 0) catch @panic("OOM")).value_ptr;
                    defer overload_ptr.* += 1;
                    const suffix = if (overload_ptr.* == 0) "" else std.fmt.allocPrint(ir.arena.allocator(), "_{}", .{overload_ptr.*}) catch @panic("OOM");

                    try writer.print("pub const {s}{s} = {s}{s};\n", .{ instr.name, suffix, uname, suffix });
                    try writer.print("extern fn {s}{s}(", .{ uname, suffix });

                    if (ctx_stack.items.len > 0) switch (ctx_stack.getLast()) {
                        .struc, .uni => {
                            try writer.writeAll("self: *@This()");
                            if (ir.instrs.items[i + 1].inner == .Member or f.return_type.inner == .record) try writer.writeAll(", ");
                        },
                        else => {},
                    };

                    ctx_stack.append(.func) catch @panic("OOM");

                    const new_stack = ir.arena.allocator().create(std.array_list.Managed(usize)) catch @panic("OOM");
                    new_stack.* = .init(ir.arena.allocator());

                    member_stack.append(new_stack) catch @panic("OOM");
                },
                .Member => |m| {
                    const in_bitfield = c.clang_Cursor_isBitField(instr.__cursor) != 0;
                    // TODO: I believe that this implictly verifies us to be "in" a struct.
                    if (in_bitfield and ctx_stack.getLast() != .bitfield) {
                        // NOTE: We haven't precomputed the size so we can't annotate the struct decl itself.
                        try writer.print(ANONYMOUS_MEMBER_PREFIX ++ "{}: packed struct {{\n", .{ctx_stack.getLast().struc});
                        ctx_stack.append(.{ .bitfield = 0 }) catch @panic("OOM");
                    } else if (!in_bitfield and ctx_stack.getLast() == .bitfield) {
                        const container_size = std.math.ceilPowerOfTwo(usize, ctx_stack.getLast().bitfield) catch @panic("Overflow");
                        const padding = container_size - ctx_stack.getLast().bitfield;

                        if (padding > 0) {
                            try writer.print("__padding: u{}", .{padding});
                        }
                        try writer.writeAll("},");

                        _ = ctx_stack.pop();
                    }

                    if (in_bitfield) {
                        const bits = c.clang_getFieldDeclBitWidth(instr.__cursor);

                        try writer.print("{s}: u{},\n", .{ instr.name, bits });

                        ctx_stack.items[ctx_stack.items.len - 1].bitfield += @intCast(bits);
                    } else {
                        try writer.print("{s}: {f}{s}", .{
                            instr.name,
                            util.FormatType{
                                .type_ref = m,
                                .annotate_with_alignment = !in_bitfield and ctx_stack.getLast() != .func,
                                .erase_array_size = ctx_stack.getLast() == .func,
                            },
                            if (ctx_stack.getLast() == .func)
                            outer: {
                                break :outer if (ir.instrs.items[i + 1].inner == .Member) ", " else "";
                            } else outer: {
                                break :outer ",\n";
                            },
                        });
                    }

                    member_stack.getLast().append(i) catch @panic("OOM");
                },
                .Value => |v| {
                    try writer.print("pub const {s}: {f} = .{{.data={f}}};\n", .{ instr.name, util.FormatType{ .type_ref = v.type }, v });
                    member_stack.getLast().append(i) catch @panic("OOM");
                },
                .Struct => {
                    const new_stack = ir.arena.allocator().create(std.array_list.Managed(usize)) catch @panic("OOM");
                    new_stack.* = .init(ir.arena.allocator());

                    member_stack.append(new_stack) catch @panic("OOM");

                    if (ir.instrs.items[i + 1].state == .close) {
                        fwd_decls.put(instr.name, i) catch @panic("OOM");
                        continue;
                    }
                    _ = fwd_decls.remove(instr.name);

                    try writer.print("pub const {s} = extern struct {{\n", .{instr.name});

                    ns_stack.append(instr.name) catch @panic("OOM");
                    ctx_stack.append(.{ .struc = 0 }) catch @panic("OOM");
                },
                .Enum => |e| {
                    const new_stack = ir.arena.allocator().create(std.array_list.Managed(usize)) catch @panic("OOM");
                    new_stack.* = .init(ir.arena.allocator());

                    member_stack.append(new_stack) catch @panic("OOM");

                    if (ir.instrs.items[i + 1].state == .close) {
                        fwd_decls.put(instr.name, i) catch @panic("OOM");
                        continue;
                    }
                    _ = fwd_decls.remove(instr.name);

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
                    const new_stack = ir.arena.allocator().create(std.array_list.Managed(usize)) catch @panic("OOM");
                    new_stack.* = .init(ir.arena.allocator());

                    member_stack.append(new_stack) catch @panic("OOM");

                    if (ir.instrs.items[i + 1].state == .close) {
                        fwd_decls.put(instr.name, i) catch @panic("OOM");
                        continue;
                    }
                    _ = fwd_decls.remove(instr.name);

                    switch (ctx_stack.getLast()) {
                        .struc => |n| {
                            try writer.print(ANONYMOUS_MEMBER_PREFIX ++ "{}: extern union {{\n", .{n});
                            ctx_stack.items[ctx_stack.items.len - 1].struc += 1;
                        },
                        else => {
                            try writer.print("pub const {s} = extern union {{\n", .{instr.name});
                        },
                    }

                    ns_stack.append(instr.name) catch @panic("OOM");
                    ctx_stack.append(.uni) catch @panic("OOM");
                },
                .Typedef => |t| {
                    switch (t.inner) {
                        .record, .enumeration, .included => |name| if (std.mem.eql(u8, name, instr.name)) {
                            continue;
                        },
                        else => {},
                    }

                    try writer.print("pub const {s} = {f};\n\n", .{
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
                    try writer.writeAll(
                        \\
                        \\
                        \\comptime {
                        \\    refAllDecls(@This());
                        \\}
                        \\};
                        \\
                        \\
                    );
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

                    if (f.variadic) {
                        if (member_stack.getLast().items.len > 0 or f.return_type.inner == .record) try writer.writeAll(", ");
                        try writer.writeAll("...");
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

                    try writeSizeAndAlignmentChecks(
                        instr.name,
                        c.clang_getCursorType(instr.__cursor),
                        member_stack.getLast().items,
                        ir.instrs.items,
                        writer,
                    );
                    try writer.writeAll("}");

                    _ = ctx_stack.pop();
                    switch (ctx_stack.getLast()) {
                        .struc => try writer.writeAll(",\n"),
                        else => try writer.writeAll(";\n\n"),
                    }

                    _ = ns_stack.pop();
                    member_stack.getLast().clearAndFree();
                    _ = member_stack.pop();
                },
                .Struct => {
                    if (member_stack.getLast().items.len == 0) continue;

                    try writeSizeAndAlignmentChecks(
                        instr.name,
                        c.clang_getCursorType(instr.__cursor),
                        member_stack.getLast().items,
                        ir.instrs.items,
                        writer,
                    );
                    try writer.writeAll("};\n\n");

                    _ = ns_stack.pop();
                    _ = ctx_stack.pop();
                    member_stack.getLast().clearAndFree();
                    _ = member_stack.pop();
                },
                .Enum => {
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

    var opaque_type_decls_iter = fwd_decls.iterator();
    while (opaque_type_decls_iter.next()) |entry| {
        const instr = ir.instrs.items[entry.value_ptr.*];
        try writer.print("pub const {s} = {s};\n", .{ entry.key_ptr.*, switch (instr.inner) {
            .Struct, .Union, .Enum => outer: {
                if (ffi.isTypeComplete(c.clang_getCursorType(instr.__cursor))) {
                    break :outer "extern struct {}";
                } else {
                    break :outer "?*anyopaque";
                }
            },
            else => unreachable,
        } });
    }

    try writer.writeAll(
        \\
        \\
        \\comptime {
        \\    refAllDecls(@This());
        \\}
        \\
    );
}

fn writeSizeAndAlignmentChecks(
    name: []const u8,
    cx_type: c.CXType,
    members: []const usize,
    instructions: []const IR.Instruction,
    writer: *std.Io.Writer,
) std.Io.Writer.Error!void {
    const expected_size = c.clang_Type_getSizeOf(cx_type);
    const expected_alignment = c.clang_Type_getAlignOf(cx_type);
    try writer.print(
        \\comptime {{
        \\if (@sizeOf(@This()) != {} or @alignOf(@This()) != {}) {{
        \\@compileLog(@import("std").fmt.comptimePrint("Expected type '{s}' to be {} bytes with {} byte alignment, but was {{}} bytes with {{}} byte alignment instead!", .{{
        \\    @sizeOf(@This()),
        \\    @alignOf(@This()),
        \\}}));
        \\
        \\
    , .{
        expected_size,
        expected_alignment,
        if (c.clang_Cursor_isAnonymous(c.clang_getTypeDeclaration(cx_type)) != 0) "Anonymous Type" else name,
        expected_size,
        expected_alignment,
    });

    var check_fields = false;
    for (members) |m| {
        if (instructions[m].inner.Member.inner == .not_yet_implemented) continue;
        check_fields = true;
    }

    if (check_fields) {
        try writer.writeAll(
            \\const this: @This() = undefined;
            \\
            \\
        );

        for (members) |m| {
            const m_instr = instructions[m];
            if (m_instr.inner.Member.inner == .not_yet_implemented) continue;

            const m_size = c.clang_Type_getSizeOf(m_instr.inner.Member.cx_type);
            const m_alignment = c.clang_Type_getAlignOf(m_instr.inner.Member.cx_type);

            try writer.print(
                \\const T_{[name]s} = @TypeOf(this.{[name]s});
                \\if (@sizeOf(T_{[name]s}) != {[size]} or @alignOf(T_{[name]s}) != {[alignment]}) {{
                \\    @compileLog(@import("std").fmt.comptimePrint("Expected field '{[name]s}' to be {[size]} bytes with {[alignment]} byte alignment, but was {{}} bytes with {{}} byte alignment instead!", .{{
                \\        @sizeOf(T_{[name]s}),
                \\        @alignOf(T_{[name]s}),
                \\    }}));
                \\}}
                \\
            , .{
                .name = if (m_instr.inner == .Union) "anon" else m_instr.name,
                .size = m_size,
                .alignment = m_alignment,
            });
        }
    }

    try writer.writeAll(
        \\}
        \\}
    );
}
