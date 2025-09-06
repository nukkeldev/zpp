const std = @import("std");

const tracy = @import("../util/tracy.zig");

const ffi = @import("../ffi.zig");
const c = ffi.c;

const ir_mod = @import("../ir.zig");
const IR = ir_mod.IR;

const writers = @import("../writers.zig");

const log = std.log.scoped(.cpp_wrapper);

// -- Formatting -- //

pub fn initContext(allocator: std.mem.Allocator, ctx: *writers.Context) !void {
    const stack = try allocator.create(std.array_list.Managed(usize));
    stack.* = .init(allocator);
    try ctx.member_stack.append(stack);
}

pub fn writeFilePrefix(ir: *const IR, _: *writers.Context, writer: *std.Io.Writer) !void {
    var fz = tracy.FnZone.init(@src(), "cpp.writeFilePrefix");
    defer fz.end();

    try writer.writeAll(@import("../writers.zig").PREAMBLE ++
        \\
        \\
        \\#include <stdarg.h>
        \\
        \\#pragma clang diagnostic push
        \\#pragma clang diagnostic ignored "-Wformat-security"
        \\
        \\
    );
    for (ir.paths) |path| if (!std.mem.eql(u8, path, ir_mod.ROOT_FILE)) try writer.print("#include \"{s}\"\n", .{std.fs.path.basename(path)});
    try writer.writeByte('\n');
}

pub fn writeInstruction(ir: *const IR, i: usize, ctx: *writers.Context, writer: *std.Io.Writer) !void {
    var fz = tracy.FnZone.init(@src(), "cpp.writeInstruction");
    defer fz.end();

    const allocator = ir.arena.allocator();

    const instr = ir.instrs.items[i];
    const unique_name = instr.getUniqueName(allocator, ctx.ns_stack.items) catch @panic("OOM");

    const parent = ctx.parent_stack.getLast();
    var partial_new_parent: writers.Context.Parent = .{
        .instr_idx = i,
        .writer_start = writer.end,
        .inner = undefined,
    };

    if (instr.state == .open) {
        if (ctx.unwind_to_parent) return;

        switch (instr.inner) {
            .Namespace => ctx.ns_stack.append(instr.name) catch @panic("OOM"),
            .Function => {
                try writer.writeAll("extern \"C\" ");

                const return_type = c.clang_getCanonicalType(c.clang_getCursorResultType(instr.cursor));
                switch (return_type.kind) {
                    c.CXType_Record => try writer.writeAll("void"),
                    else => try formatMemberOrType(return_type, allocator, writer, .{}),
                }
                try writer.print(" {s}", .{unique_name});

                {
                    const overload_ptr = (try ctx.overload_map.getOrPutValue(unique_name, 0)).value_ptr;
                    defer overload_ptr.* += 1;
                    if (overload_ptr.* > 0) try writer.print("_{}", .{overload_ptr.*});
                }
                try writer.writeByte('(');

                switch (parent.inner) {
                    .@"struct", .@"union" => {
                        const cx_type = c.clang_getCursorType(ir.instrs.items[parent.instr_idx].cursor);
                        try formatMemberOrType(cx_type, allocator, writer, .{
                            .name_opt = "obj",
                            .fake_pointer = true,
                        });
                        if (ir.instrs.items[i + 1].inner == .Member or return_type.kind == c.CXType_Record) try writer.writeAll(", ");
                    },
                    else => {},
                }

                partial_new_parent.inner = .function;
                try ctx.parent_stack.append(partial_new_parent);
            },
            .Member => |m| if (parent.inner == .function) {
                try formatMemberOrType(m, allocator, writer, .{ .name_opt = instr.name });
                if (ir.instrs.items[i + 1].inner == .Member) try writer.writeAll(", ");

                try ctx.member_stack.getLast().append(i);
            },
            .Struct, .Enum, .Union => {
                try ctx.ns_stack.append(instr.name);

                partial_new_parent.inner = .{ .@"struct" = 0 };
                try ctx.parent_stack.append(partial_new_parent);
            },
            .Value, .Typedef => {
                partial_new_parent.inner = .ignore_members;
                try ctx.parent_stack.append(partial_new_parent);
            },
        }
    } else {
        const parent_start = ctx.parent_stack.getLast().writer_start;
        switch (instr.inner) {
            .Namespace => _ = ctx.ns_stack.pop(),
            .Function => {
                const return_type = c.clang_getCanonicalType(c.clang_getCursorResultType(instr.cursor));
                const variadic = c.clang_Cursor_isVariadic(instr.cursor) != 0;

                const use_out_param = return_type.kind == c.CXType_Record;
                const needs_to_return = return_type.kind != c.CXType_Void;

                const fn_params = ctx.member_stack.getLast();

                if (use_out_param) {
                    if (fn_params.items.len > 0) try writer.writeAll(", ");

                    // TODO: Avoid name collisions.
                    try formatMemberOrType(return_type, allocator, writer, .{
                        .name_opt = "zpp_out",
                        .fake_pointer = true,
                    });
                }

                if (variadic) {
                    if (fn_params.items.len == 0) @panic("Please see a doctor.");
                    try writer.writeAll(", ...) {\n");
                    try writer.print(
                        "\tva_list __ZPP_args;\n\tva_start(__ZPP_args, {s});\n\t",
                        .{if (use_out_param) "zpp_out" else ir.instrs.items[fn_params.getLast()].name},
                    );
                } else {
                    try writer.writeAll(") {\n\t");
                }

                if (needs_to_return) {
                    if (use_out_param) {
                        try writer.writeAll("*zpp_out = ");
                    } else if (variadic) {
                        try writer.writeAll("auto __ZPP_result = ");
                    } else {
                        try writer.writeAll("return ");
                    }
                }

                switch (return_type.kind) {
                    c.CXType_LValueReference => try writer.writeAll("&"),
                    else => {},
                }

                const grandparent = ctx.parent_stack.items[ctx.parent_stack.items.len - 2];
                if (ctx.parent_stack.items.len > 1 and (grandparent.inner == .@"struct" or grandparent.inner == .@"union")) {
                    try writer.writeAll("obj->");
                } else {
                    for (ctx.ns_stack.items) |n| try writer.print("{s}::", .{n});
                }
                try writer.print("{s}(", .{instr.name});

                for (fn_params.items, 0..) |p, j| {
                    const m = ir.instrs.items[p];
                    switch (m.inner.Member.kind) {
                        c.CXType_LValueReference => try writer.writeByte('*'),
                        else => {},
                    }

                    try writer.writeAll(m.name);
                    if (j < fn_params.items.len - 1) try writer.writeAll(", ");
                }
                fn_params.clearAndFree();

                try writer.writeAll(");\n");
                if (variadic) try writer.writeAll("\tva_end(__ZPP_args);\n");
                if (needs_to_return and variadic and !use_out_param) try writer.writeAll("\treturn __ZPP_result;\n");
                try writer.writeAll("}\n");

                _ = ctx.parent_stack.pop();
            },
            .Struct, .Enum, .Union => {
                ctx.member_stack.getLast().clearAndFree();
                _ = ctx.ns_stack.pop();
                _ = ctx.parent_stack.pop();
            },
            .Typedef => {
                ctx.member_stack.getLast().clearAndFree();
                _ = ctx.parent_stack.pop();
            },
            .Member, .Value => unreachable,
        }

        if (ctx.unwind_to_parent) {
            writer.end = parent_start;
            ctx.unwind_to_parent = false;
        }
    }
}

pub fn writeFileSuffix(_: *const IR, _: *writers.Context, writer: *std.Io.Writer) !void {
    try writer.writeAll("\n#pragma clang diagnostic pop");
}

// -- Member & Type Formatting -- //

const FormatTypeArgs = struct {
    name_opt: ?[]const u8 = null,

    override_const: ?bool = null,
    fake_pointer: bool = false,

    pointee_depth: usize = 0,
    have_pointers_been_written: ?*bool = null,
};

fn formatMemberOrType(
    @"type": c.CXType,
    allocator: std.mem.Allocator,
    writer: *std.Io.Writer,
    args: FormatTypeArgs,
) !void {
    var fz = tracy.FnZone.init(@src(), "formatMemberOrType");
    defer fz.end();

    // Prefix with `const`.
    if ((args.override_const == null and c.clang_isConstQualifiedType(@"type") != 0) or
        (args.override_const != null and args.override_const.?))
    {
        try writer.print("const ", .{});
    }

    // Format the type itself.
    outer: {
        const spelling = try ffi.getTypeSpelling(allocator, @"type");
        defer allocator.free(spelling);

        if (@import("../writers.zig").untranslateable_types.has(spelling)) {
            return error.Revert;
        }

        var kind = @as(c_int, @intCast(@"type".kind));
        if (args.fake_pointer) kind = c.CXType_Pointer;

        const out = inner: switch (kind) {
            c.CXType_Elaborated => return formatMemberOrType(c.clang_getCanonicalType(@"type"), allocator, writer, args),

            c.CXType_Void,
            //
            c.CXType_Bool,
            //
            c.CXType_Float,
            c.CXType_Double,
            c.CXType_LongDouble,
            //
            c.CXType_Char_U,
            c.CXType_UChar,
            c.CXType_UShort,
            c.CXType_UInt,
            c.CXType_ULong,
            c.CXType_ULongLong,
            c.CXType_UInt128,
            //
            c.CXType_Char16,
            c.CXType_Char32,
            c.CXType_Char_S,
            c.CXType_SChar,
            c.CXType_WChar,
            c.CXType_Short,
            c.CXType_Int,
            c.CXType_Long,
            c.CXType_LongLong,
            c.CXType_Int128,
            //
            c.CXType_Record,
            c.CXType_Enum,
            => spelling,

            c.CXType_Pointer, c.CXType_LValueReference => {
                var pointee_args = args;
                pointee_args.fake_pointer = false;
                pointee_args.pointee_depth += 1;

                const pointee = if (!args.fake_pointer) blk: {
                    pointee_args.override_const = false;
                    break :blk c.clang_getPointeeType(@"type");
                } else @"type";

                var have_pointers_been_written = false;
                if (pointee_args.have_pointers_been_written == null) pointee_args.have_pointers_been_written = &have_pointers_been_written;
                try formatMemberOrType(pointee, allocator, writer, pointee_args);

                if (!pointee_args.have_pointers_been_written.?.*) {
                    try writer.writeByte('*');
                } else {
                    // If the pointer has already been written, then so has the name.
                    return;
                }

                break :outer;
            },

            c.CXType_ConstantArray, c.CXType_IncompleteArray => {
                var elm_args = args;
                elm_args.name_opt = null;
                elm_args.override_const = false;

                try formatMemberOrType(c.clang_getArrayElementType(@"type"), allocator, writer, elm_args);
                break :outer;
            },

            c.CXType_FunctionProto => {
                // TODO: handle pointer return types
                try formatMemberOrType(c.clang_getResultType(@"type"), allocator, writer, .{});
                try writer.writeAll(" (");

                for (0..args.pointee_depth) |_| try writer.writeByte('*');
                args.have_pointers_been_written.?.* = true;

                if (args.name_opt) |name| try writer.print("{s})(", .{name});

                const n_params = c.clang_getNumArgTypes(@"type");
                const variadic = c.clang_isFunctionTypeVariadic(@"type") != 0;
                for (0..@intCast(n_params)) |i| {
                    try formatMemberOrType(c.clang_getArgType(@"type", @intCast(i)), allocator, writer, .{});
                    if (i < n_params - 1 or variadic) try writer.writeAll(", ");
                }
                if (variadic) try writer.writeAll("...");

                try writer.writeByte(')');
                return;
            },

            else => continue :inner -1,
            -1 => {
                const kind_spelling = try ffi.getTypeKindSpelling(allocator, @"type".kind);
                defer allocator.free(kind_spelling);

                log.err("Not yet formatted type: '{s}' ({s})!", .{ spelling, kind_spelling });
                try writer.print("/* TODO: Not yet formatted type '{s}' ({s}) */", .{ spelling, kind_spelling });

                break :outer;
            },
        };

        try writer.writeAll(out);
    }

    // Append the name if present.
    if (args.pointee_depth == 0) if (args.name_opt) |name| try writer.print(" {s}", .{name});

    // NOTE: These could be avoided if we typedef the irregularly formatted types.
    // Suffix if necessary.
    switch (@"type".kind) {
        c.CXType_ConstantArray, c.CXType_IncompleteArray => {
            try writer.writeByte('[');
            const count = c.clang_getArraySize(@"type");
            if (count >= 0) try writer.print("{}", .{count});
            try writer.writeByte(']');
        },
        else => {},
    }
}

// -- Other Writing Functions -- //

pub fn formatFilename(allocator: std.mem.Allocator, filename: []const u8) std.mem.Allocator.Error![:0]const u8 {
    return std.fmt.allocPrintSentinel(allocator, "{s}.cpp", .{filename}, 0);
}

pub fn checkFile(allocator: std.mem.Allocator, path: [:0]const u8, args: anytype) !bool {
    var fz = tracy.FnZone.init(@src(), "cpp.checkFile");
    defer fz.end();

    const index = c.clang_createIndex(0, 1);
    defer c.clang_disposeIndex(index);

    const clang_args = try ir_mod.combineArgs(
        allocator,
        &.{
            ir_mod.REQUIRED_ARGUMENTS,
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
