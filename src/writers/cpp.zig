const std = @import("std");
const ffi = @import("../ffi.zig");

const c = ffi.c;
const IR = @import("../ir/IR.zig");

const log = std.log.scoped(.cpp_wrapper);

// -- Formatting -- //

pub fn formatFile(ir: IR, writer: *std.Io.Writer) std.Io.Writer.Error!void {
    const allocator = ir.arena.allocator();

    // Write the preamble of the file.
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
    for (ir.paths) |path| if (!std.mem.eql(u8, path, IR.ROOT_FILE)) try writer.print("#include \"{s}\"\n", .{std.fs.path.basename(path)});
    try writer.writeByte('\n');

    // Initialize context.
    var overload_map: std.StringHashMap(usize) = .init(allocator);
    var ns_stack: std.array_list.Managed([]const u8) = .init(allocator);
    var fn_params: std.array_list.Managed(usize) = .init(allocator);
    var ctx_stack: std.array_list.Managed(union(enum) { struct_like: c.CXType, ignore_members, function, root }) = .init(allocator);
    ctx_stack.append(.root) catch @panic("OOM");

    // Write instructions.
    var i: usize = 0;
    while (i < ir.instrs.items.len) : (i += 1) {
        const instr = ir.instrs.items[i];
        const unique_name = instr.getUniqueName(allocator, ns_stack.items) catch @panic("OOM");

        if (instr.state == .open) {
            switch (instr.inner) {
                .Namespace => ns_stack.append(instr.name) catch @panic("OOM"),
                .Function => |f| {
                    try writer.writeAll("extern \"C\" ");
                    switch (f.return_type.cx_type.kind) {
                        c.CXType_Record => try writer.writeAll("void"),
                        else => try formatMemberOrType(f.return_type.cx_type, allocator, writer, .{}),
                    }
                    try writer.print(" {s}", .{unique_name});

                    {
                        const overload_ptr = (overload_map.getOrPutValue(unique_name, 0) catch @panic("OOM")).value_ptr;
                        defer overload_ptr.* += 1;
                        if (overload_ptr.* > 0) try writer.print("_{}", .{overload_ptr.*});
                    }
                    try writer.writeByte('(');

                    if (ctx_stack.getLast() == .struct_like) {
                        try formatMemberOrType(ctx_stack.getLast().struct_like, allocator, writer, .{
                            .name_opt = "obj",
                            .fake_pointer = true,
                        });
                        if (ir.instrs.items[i + 1].inner == .Member or f.return_type.inner == .record) try writer.writeAll(", ");
                    }

                    ctx_stack.append(.function) catch @panic("OOM");
                },
                .Member => |m| if (ctx_stack.getLast() == .function) {
                    try formatMemberOrType(
                        m.cx_type,
                        allocator,
                        writer,
                        .{ .name_opt = instr.name },
                    );
                    if (ir.instrs.items[i + 1].inner == .Member) try writer.writeAll(", ");

                    fn_params.append(i) catch @panic("OOM");
                },
                .Struct, .Enum, .Union => {
                    ns_stack.append(instr.name) catch @panic("OOM");
                    ctx_stack.append(.{ .struct_like = c.clang_getCursorType(instr.__cursor) }) catch @panic("OOM");
                },
                .Value, .Typedef => ctx_stack.append(.ignore_members) catch @panic("OOM"),
            }
        } else {
            switch (instr.inner) {
                .Namespace => _ = ns_stack.pop(),
                .Function => |f| {
                    const use_out_param = f.return_type.inner == .record;
                    const needs_to_return = f.return_type.inner != .void;

                    if (use_out_param) {
                        if (fn_params.items.len > 0) try writer.writeAll(", ");

                        // TODO: Avoid name collisions.
                        try formatMemberOrType(f.return_type.cx_type, allocator, writer, .{
                            .name_opt = "zpp_out",
                            .fake_pointer = true,
                        });
                    }

                    if (f.variadic) {
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
                        } else if (f.variadic) {
                            try writer.writeAll("auto __ZPP_result = ");
                        } else {
                            try writer.writeAll("return ");
                        }
                    }

                    switch (f.return_type.inner) {
                        .reference => try writer.writeAll("&"),
                        else => {},
                    }

                    if (ctx_stack.items.len > 1 and ctx_stack.items[ctx_stack.items.len - 2] == .struct_like) {
                        try writer.writeAll("obj->");
                    } else {
                        for (ns_stack.items) |n| try writer.print("{s}::", .{n});
                    }
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
                    if (needs_to_return and f.variadic and !use_out_param) try writer.writeAll("\treturn __ZPP_result;\n");
                    try writer.writeAll("}\n");

                    _ = ctx_stack.pop();
                },
                .Struct, .Enum, .Union => {
                    fn_params.clearAndFree();
                    _ = ns_stack.pop();
                    _ = ctx_stack.pop();
                },
                .Typedef => {
                    fn_params.clearAndFree();
                    _ = ctx_stack.pop();
                },
                .Member, .Value => unreachable,
            }
        }
    }

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

fn __formatMemberOrType(
    @"type": c.CXType,
    allocator: std.mem.Allocator,
    writer: *std.Io.Writer,
    args: FormatTypeArgs,
) !void {
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

        var kind = @as(c_int, @intCast(@"type".kind));
        if (args.fake_pointer) kind = c.CXType_Pointer;

        const out = inner: switch (kind) {
            c.CXType_Elaborated => return __formatMemberOrType(c.clang_getCanonicalType(@"type"), allocator, writer, args),

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
                try __formatMemberOrType(pointee, allocator, writer, pointee_args);

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

                try __formatMemberOrType(c.clang_getArrayElementType(@"type"), allocator, writer, elm_args);
                break :outer;
            },

            c.CXType_FunctionProto => {
                // TODO: handle pointer return types
                try __formatMemberOrType(c.clang_getResultType(@"type"), allocator, writer, .{});
                try writer.writeAll(" (");

                for (0..args.pointee_depth) |_| try writer.writeByte('*');
                args.have_pointers_been_written.?.* = true;

                if (args.name_opt) |name| try writer.print("{s})(", .{name});

                const n_params = c.clang_getNumArgTypes(@"type");
                const variadic = c.clang_isFunctionTypeVariadic(@"type") != 0;
                for (0..@intCast(n_params)) |i| {
                    try __formatMemberOrType(c.clang_getArgType(@"type", @intCast(i)), allocator, writer, .{});
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

fn formatMemberOrType(
    @"type": c.CXType,
    allocator: std.mem.Allocator,
    writer: *std.Io.Writer,
    args: FormatTypeArgs,
) std.Io.Writer.Error!void {
    __formatMemberOrType(@"type", allocator, writer, args) catch |e| switch (e) {
        std.Io.Writer.Error.WriteFailed => return std.Io.Writer.Error.WriteFailed,
        else => {
            log.err("Type Formatting Error: {}", .{e});
            return std.Io.Writer.Error.WriteFailed;
        },
    };
}

// -- Other Writing Functions -- //

pub fn formatFilename(allocator: std.mem.Allocator, filename: []const u8) std.mem.Allocator.Error![:0]const u8 {
    return std.fmt.allocPrintSentinel(allocator, "{s}.cpp", .{filename}, 0);
}

pub fn checkFile(allocator: std.mem.Allocator, path: [:0]const u8, args: anytype) std.mem.Allocator.Error!bool {
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
