// -- Imports -- //

const std = @import("std");

const tracy = @import("../util/tracy.zig");

const ffi = @import("../ffi.zig");
const c = ffi.c;

const ir_mod = @import("../ir.zig");
const IR = ir_mod.IR;

const writers = @import("../writers.zig");

const log = std.log.scoped(.zig_wrapper);

// -- Configuration -- //

const ANONYMOUS_MEMBER_PREFIX = "anon";

// -- Formatting -- //

pub fn writeFilePrefix(_: *const IR, _: *writers.Context, writer: *std.Io.Writer) !void {
    var fz = tracy.FnZone.init(@src(), "zig.writeFilePrefix");
    defer fz.end();

    try writer.writeAll(writers.PREAMBLE ++
        \\
        \\
        \\fn refAllDecls(comptime T: type) void {
        \\    inline for (comptime @import("std").meta.declarations(T)) |decl| {
        \\        _ = &@field(T, decl.name);
        \\    }
        \\}
        \\
        \\
    );
}

pub fn writeInstruction(ir: *const IR, i: usize, ctx: *writers.Context, writer: *std.Io.Writer) !void {
    var fz = tracy.FnZone.init(@src(), "zig.writeInstruction");
    defer fz.end();

    const allocator = ir.arena.allocator();

    const instr = ir.instrs.items[i];
    const unique_name = try instr.getUniqueName(allocator, ctx.ns_stack.items);

    const parent = ctx.parent_stack.getLast();
    var partial_new_parent: writers.Context.Parent = .{
        .instr_idx = i,
        .writer_start = writer.end,
        .inner = undefined,
    };

    if (instr.state == .open) {
        if (ctx.unwind_to_parent) return;

        switch (instr.inner) {
            .Namespace => {
                try writer.print("pub const {s} = struct {{\n", .{instr.name});

                try ctx.ns_stack.append(instr.name);

                partial_new_parent.inner = .namespace;
                try ctx.parent_stack.append(partial_new_parent);
            },
            .Function => {
                const overload_ptr = (try ctx.overload_map.getOrPutValue(unique_name, 0)).value_ptr;
                defer overload_ptr.* += 1;
                const suffix = if (overload_ptr.* == 0) "" else try std.fmt.allocPrint(allocator, "_{}", .{overload_ptr.*});

                try writer.print("pub const {s}{s} = {s}{s};\n", .{ instr.name, suffix, unique_name, suffix });
                try writer.print("extern fn {s}{s}(", .{ unique_name, suffix });

                const return_type = c.clang_getCanonicalType(c.clang_getCursorResultType(instr.cursor));

                switch (parent.inner) {
                    .@"struct", .@"union" => {
                        try writer.writeAll("self: *@This()");
                        if (ir.instrs.items[i + 1].inner == .Member or return_type.kind == c.CXType_Record) try writer.writeAll(", ");
                    },
                    else => {},
                }

                partial_new_parent.inner = .function;
                try ctx.parent_stack.append(partial_new_parent);

                const new_stack = try allocator.create(std.array_list.Managed(usize));
                new_stack.* = .init(allocator);

                try ctx.member_stack.append(new_stack);
            },
            .Member => |m| {
                const in_bitfield = c.clang_Cursor_isBitField(instr.cursor) != 0;
                // TODO: I believe that this implictly verifies us to be "in" a struct.
                if (in_bitfield and parent.inner != .bitfield) {
                    // NOTE: We haven't precomputed the size so we can't annotate the struct decl itself.
                    try writer.print(ANONYMOUS_MEMBER_PREFIX ++ "{}: packed struct {{\n", .{
                        parent.inner.@"struct",
                    });

                    partial_new_parent.inner = .{ .bitfield = 0 };
                    try ctx.parent_stack.append(partial_new_parent);
                } else if (!in_bitfield and parent.inner == .bitfield) {
                    const container_size = try std.math.ceilPowerOfTwo(usize, parent.inner.bitfield);
                    const padding = container_size - parent.inner.bitfield;

                    if (padding > 0) {
                        try writer.print("__padding: u{}", .{padding});
                    }
                    try writer.writeAll("},");

                    _ = ctx.parent_stack.pop();
                }

                if (in_bitfield) {
                    const bits = c.clang_getFieldDeclBitWidth(instr.cursor);

                    try writer.print("{s}: u{},\n", .{ instr.name, bits });

                    ctx.parent_stack.items[ctx.parent_stack.items.len - 1].inner.bitfield += @intCast(bits);
                } else {
                    try writer.print("{s}: ", .{instr.name});
                    try formatType(m, allocator, writer, .{
                        .hashed_paths = &ir.hashed_paths,
                        .annotate_with_alignment = !in_bitfield and parent.inner != .function,
                        .erase_array_size = parent.inner == .function,
                    });
                    try writer.print("{s}", .{
                        if (parent.inner == .function)
                            (if (ir.instrs.items[i + 1].inner == .Member) ", " else "")
                        else
                            ",\n",
                    });
                }

                try ctx.member_stack.getLast().append(i);
            },
            .Value => |v| {
                try writer.print("pub const {s}: ", .{instr.name});
                try formatType(v.type, allocator, writer, .{ .hashed_paths = &ir.hashed_paths });
                try writer.print(" = .{{.data={f}}};\n", .{v});

                try ctx.member_stack.getLast().append(i);
            },
            .Struct => {
                const new_stack = try allocator.create(std.array_list.Managed(usize));
                new_stack.* = .init(allocator);

                try ctx.member_stack.append(new_stack);

                if (ir.instrs.items[i + 1].state == .close) {
                    try ctx.fwd_decls.put(instr.name, i);
                    return;
                }
                _ = ctx.fwd_decls.remove(instr.name);

                try writer.print("pub const {s} = extern struct {{\n", .{instr.name});

                try ctx.ns_stack.append(instr.name);

                partial_new_parent.inner = .{ .@"struct" = 0 };
                try ctx.parent_stack.append(partial_new_parent);
            },
            .Enum => {
                const new_stack = try allocator.create(std.array_list.Managed(usize));
                new_stack.* = .init(allocator);

                try ctx.member_stack.append(new_stack);

                if (ir.instrs.items[i + 1].state == .close) {
                    try ctx.fwd_decls.put(instr.name, i);
                    return;
                }
                _ = ctx.fwd_decls.remove(instr.name);

                const @"type" = c.clang_getEnumDeclIntegerType(instr.cursor);
                try writer.print("pub const {s} = packed struct(", .{instr.name});
                try formatType(@"type", allocator, writer, .{ .hashed_paths = &ir.hashed_paths });
                try writer.writeAll(") {\ndata: ");
                try formatType(@"type", allocator, writer, .{ .hashed_paths = &ir.hashed_paths });
                try writer.writeAll(",\n");

                partial_new_parent.inner = .@"enum";
                try ctx.parent_stack.append(partial_new_parent);
            },
            .Union => {
                const new_stack = try allocator.create(std.array_list.Managed(usize));
                new_stack.* = .init(allocator);

                try ctx.member_stack.append(new_stack);

                if (ir.instrs.items[i + 1].state == .close) {
                    try ctx.fwd_decls.put(instr.name, i);
                    return;
                }
                _ = ctx.fwd_decls.remove(instr.name);

                switch (parent.inner) {
                    .@"struct" => |n| {
                        try writer.print(ANONYMOUS_MEMBER_PREFIX ++ "{}: extern union {{\n", .{n});
                        ctx.parent_stack.items[ctx.parent_stack.items.len - 1].inner.@"struct" += 1;
                    },
                    else => {
                        try writer.print("pub const {s} = extern union {{\n", .{instr.name});
                    },
                }

                try ctx.ns_stack.append(instr.name);

                partial_new_parent.inner = .@"union";
                try ctx.parent_stack.append(partial_new_parent);
            },
            .Typedef => |t| {
                const spelling = try ffi.getCursorSpelling(allocator, c.clang_getTypeDeclaration(t));
                if (std.mem.eql(u8, spelling, instr.name)) return;

                try writer.print("pub const {s} = ", .{instr.name});
                try formatType(t, allocator, writer, .{ .hashed_paths = &ir.hashed_paths });
                try writer.writeAll(";\n\n");
            },
        }
    } else {
        const parent_start = ctx.parent_stack.getLast().writer_start;
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
                _ = ctx.ns_stack.pop();
                _ = ctx.parent_stack.pop();
            },
            .Function => {
                const return_type = c.clang_getCanonicalType(c.clang_getCursorResultType(instr.cursor));
                const variadic = c.clang_Cursor_isVariadic(instr.cursor) != 0;

                if (return_type.kind == c.CXType_Record) {
                    // TODO: Avoid name collisions.
                    if (ctx.member_stack.getLast().items.len > 0) try writer.writeAll(", ");
                    try writer.writeAll("zpp_out: *");
                    try formatType(return_type, allocator, writer, .{ .hashed_paths = &ir.hashed_paths });
                }

                if (variadic) {
                    if (ctx.member_stack.getLast().items.len > 0 or return_type.kind == c.CXType_Record) try writer.writeAll(", ");
                    try writer.writeAll("...");
                }

                try writer.writeAll(") callconv(.c) ");
                switch (return_type.kind) {
                    c.CXType_Record => try writer.writeAll("void"),
                    else => try formatType(return_type, allocator, writer, .{ .hashed_paths = &ir.hashed_paths }),
                }
                try writer.writeAll(";\n\n");

                ctx.member_stack.getLast().clearAndFree();
                _ = ctx.member_stack.pop();
            },
            .Union => {
                if (ctx.member_stack.getLast().items.len == 0) return;

                try writeSizeAndAlignmentChecks(
                    instr.name,
                    c.clang_getCursorType(instr.cursor),
                    ctx.member_stack.getLast().items,
                    ir.instrs.items,
                    writer,
                );
                try writer.writeAll("}");

                _ = ctx.parent_stack.pop();
                switch (ctx.parent_stack.getLast().inner) {
                    .@"struct" => try writer.writeAll(",\n"),
                    else => try writer.writeAll(";\n\n"),
                }

                _ = ctx.ns_stack.pop();
                ctx.member_stack.getLast().clearAndFree();
                _ = ctx.member_stack.pop();
            },
            .Struct => {
                if (ctx.member_stack.getLast().items.len == 0) return;

                try writeSizeAndAlignmentChecks(
                    instr.name,
                    c.clang_getCursorType(instr.cursor),
                    ctx.member_stack.getLast().items,
                    ir.instrs.items,
                    writer,
                );
                try writer.writeAll("};\n\n");

                _ = ctx.ns_stack.pop();
                _ = ctx.parent_stack.pop();
                ctx.member_stack.getLast().clearAndFree();
                _ = ctx.member_stack.pop();
            },
            .Enum => {
                if (ctx.member_stack.getLast().items.len == 0) return;
                ctx.member_stack.getLast().clearAndFree();
                _ = ctx.member_stack.pop();
                _ = ctx.parent_stack.pop();
                try writer.writeAll("};\n\n");
            },
            .Typedef => {},
            .Member, .Value => unreachable,
        }

        if (ctx.unwind_to_parent) {
            writer.end = parent_start;
            ctx.unwind_to_parent = false;
        }
    }
}

pub fn writeFileSuffix(ir: *const IR, ctx: *writers.Context, writer: *std.Io.Writer) !void {
    var opaque_type_decls_iter = ctx.fwd_decls.iterator();
    while (opaque_type_decls_iter.next()) |entry| {
        const instr = ir.instrs.items[entry.value_ptr.*];
        try writer.print("pub const {s} = {s};\n", .{ entry.key_ptr.*, switch (instr.inner) {
            .Struct, .Union, .Enum => outer: {
                if (ffi.isTypeComplete(c.clang_getCursorType(instr.cursor))) {
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
    instructions: []const ir_mod.Instruction,
    writer: *std.Io.Writer,
) std.Io.Writer.Error!void {
    var fz = tracy.FnZone.init(@src(), "writeSizeAndAlignmentChecks");
    defer fz.end();

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

    const check_fields = true;
    // for (members) |m| {
    //     if (instructions[m].inner.Member == .not_yet_implemented) continue;
    //     check_fields = true;
    // }

    if (check_fields) {
        try writer.writeAll(
            \\const this: @This() = undefined;
            \\
            \\
        );

        for (members) |m| {
            const m_instr = instructions[m];
            // if (m_instr.inner.Member == .not_yet_implemented) continue;

            const m_size = c.clang_Type_getSizeOf(m_instr.inner.Member);
            const m_alignment = c.clang_Type_getAlignOf(m_instr.inner.Member);

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

// -- Member & Type Formatting -- //

const FormatTypeArgs = struct {
    hashed_paths: *const std.StringHashMap(void),

    ignore_const: bool = false,
    erase_array_size: bool = false,
    annotate_with_alignment: bool = false,
};

fn formatType(
    @"type": c.CXType,
    allocator: std.mem.Allocator,
    writer: *std.Io.Writer,
    args: FormatTypeArgs,
) !void {
    var fz = tracy.FnZone.init(@src(), "formatType");
    defer fz.end();

    // Format the type itself.
    const spelling_ = try ffi.getTypeSpelling(allocator, @"type");
    defer allocator.free(spelling_);

    // Some spellings have `const` directly in them.
    const spelling = spelling_[if (std.mem.lastIndexOfScalar(u8, spelling_, ' ')) |i| i + 1 else 0..];

    if (@import("../writers.zig").untranslateable_types.has(spelling)) {
        return error.Revert;
    }

    const kind = @as(c_int, @intCast(@"type".kind));
    const out = inner: switch (kind) {
        c.CXType_Elaborated => return formatType(c.clang_getCanonicalType(@"type"), allocator, writer, args),

        c.CXType_Void => "void",

        c.CXType_Bool => "bool",

        c.CXType_Float => "f32",
        c.CXType_Double => "f64",
        c.CXType_LongDouble => "f128",

        c.CXType_Char_U,
        c.CXType_UChar,
        c.CXType_UShort,
        c.CXType_UInt,
        c.CXType_ULong,
        c.CXType_ULongLong,
        c.CXType_UInt128,
        => {
            try writer.print("u{}", .{c.clang_Type_getSizeOf(@"type") * 8});
            return;
        },

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
        => {
            try writer.print("{s}{}", .{ if (@"type".kind != c.CXType_Char_S) "i" else "u", c.clang_Type_getSizeOf(@"type") * 8 });
            return;
        },

        c.CXType_Enum,
        c.CXType_Record,
        => {
            const decl = c.clang_getTypeDeclaration(@"type");
            const location = try ffi.SourceLocation.fromCXSourceLocation(allocator, c.clang_getCursorLocation(decl));
            if (c.clang_Type_getNumTemplateArguments(@"type") > 0 or !args.hashed_paths.contains(location.file)) {
                continue :inner -2;
            } else {
                break :inner spelling;
            }
        },

        c.CXType_Pointer, c.CXType_LValueReference => {
            const pointee = c.clang_getPointeeType(@"type");
            if (pointee.kind == c.CXType_Void or kind == c.CXType_LValueReference) {
                try writer.writeAll("*"); // TODO: Maybe ?*
            } else {
                try writer.writeAll("[*c]");
            }

            var pointee_args = args;
            pointee_args.annotate_with_alignment = false;

            if (c.clang_isConstQualifiedType(pointee) != 0) {
                try writer.writeAll("const ");
            }

            try formatType(pointee, allocator, writer, pointee_args);
            return;
        },

        c.CXType_ConstantArray, c.CXType_IncompleteArray => {
            const count = c.clang_getArraySize(@"type");

            try writer.writeByte('[');
            if (count >= 0 and !args.erase_array_size) {
                try writer.print("{}", .{count});
            } else {
                try writer.writeByte('*');
            }
            try writer.writeByte(']');

            var elm_args = args;
            elm_args.annotate_with_alignment = false;

            const elm = c.clang_getArrayElementType(@"type");
            if (c.clang_isConstQualifiedType(elm) != 0) {
                try writer.writeAll("const ");
            }

            try formatType(elm, allocator, writer, elm_args);
            return;
        },

        c.CXType_FunctionProto => {
            try writer.writeAll("*const fn (");

            const n_params = c.clang_getNumArgTypes(@"type");
            const variadic = c.clang_isFunctionTypeVariadic(@"type") != 0;
            for (0..@intCast(n_params)) |i| {
                try formatType(c.clang_getArgType(@"type", @intCast(i)), allocator, writer, .{ .hashed_paths = args.hashed_paths });
                if (i < n_params - 1 or variadic) try writer.writeAll(", ");
            }
            if (variadic) try writer.writeAll("...");
            try writer.writeAll(") callconv(.c) ");

            try formatType(c.clang_getResultType(@"type"), allocator, writer, .{ .hashed_paths = args.hashed_paths });

            return;
        },

        else => continue :inner -1,
        -1 => {
            const kind_spelling = try ffi.getTypeKindSpelling(allocator, @"type".kind);
            defer allocator.free(kind_spelling);

            log.err("Not yet formatted type: '{s}' ({s})!", .{ spelling, kind_spelling });
            continue :inner -2;
        },
        -2 => {
            const size = c.clang_Type_getSizeOf(@"type");
            if (size <= 0) {
                try writer.writeAll("?*anyopaque");
            } else {
                try writer.print("[{}]u8", .{size});
                if (args.annotate_with_alignment) try writer.print(" align({})", .{c.clang_Type_getAlignOf(@"type")});
            }

            return;
        },
    };

    try writer.writeAll(out);
}

// -- Other Writer Functions -- //

pub fn formatFilename(allocator: std.mem.Allocator, filename: []const u8) std.mem.Allocator.Error![:0]const u8 {
    return std.fmt.allocPrintSentinel(allocator, "{s}.zig", .{filename}, 0);
}

pub fn postProcessFile(allocator: std.mem.Allocator, path: []const u8) !void {
    var fz = tracy.FnZone.init(@src(), "zig.postProcessFile");
    defer fz.end();

    _ = try std.process.Child.run(.{
        .allocator = allocator,
        .argv = &.{ "zig", "fmt", std.fs.path.dirname(path) orelse "." },
    });
}

pub fn checkFile(allocator: std.mem.Allocator, path: [:0]const u8, args: anytype) std.mem.Allocator.Error!bool {
    var fz = tracy.FnZone.init(@src(), "zig.checkFile");
    defer fz.end();

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
