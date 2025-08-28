// -- Imports & Constants -- //

const std = @import("std");
const ffi = @import("../ffi.zig");

const c = ffi.c;
const Allocator = std.mem.Allocator;

const IR = @import("IR.zig");
const TypeReference = @This();

const log = std.log.scoped(.type);

// -- Constants -- //

pub const VOID: TypeReference = .{
    .is_const = false,
    .inner = .void,
    .cx_type = undefined, // TODO: This ain't pretty
};

// -- Fields -- //

is_const: bool,
inner: Inner,
cx_type: c.CXType,

// -- Types -- //

pub const Inner = union(enum) {
    unexposed,
    included: []const u8,

    void,

    bool,
    integer: Integral,
    float: Float,

    /// NOTE: We can get if the struct is a POD with clang_isPODBlahBlahBlah
    record: []const u8,
    enumeration: []const u8,

    pointer: *TypeReference,
    reference: *TypeReference,

    array: Array,

    function: Function,

    not_yet_implemented,
};

pub const Float = std.builtin.Type.Float;
pub const Integral = std.builtin.Type.Int;

pub const Array = struct {
    element_type: *TypeReference,
    /// -1 = slice
    count: i128,
};

pub const Function = struct {
    variadic: bool,
    return_type: *TypeReference,
    params: []TypeReference,
};

// -- Error -- //

pub const TypeReferenceError = error{};

// -- Functions -- //

pub fn fromCXType(allocator: Allocator, cx_type: c.CXType, ir: *const IR) (TypeReferenceError || Allocator.Error)!@This() {
    return TypeReference{
        .is_const = c.clang_isConstQualifiedType(cx_type) != 0,
        .inner = switch (cx_type.kind) {
            // -- Elaborated -- //

            c.CXType_Elaborated => return fromCXType(allocator, c.clang_getCanonicalType(cx_type), ir),

            // -- Unexposed & Void -- //

            c.CXType_Unexposed => .unexposed,
            c.CXType_Void => .void,

            // -- Booleans -- //

            c.CXType_Bool => .bool,

            // -- Integers -- //

            c.CXType_Char_U,
            c.CXType_UChar,
            c.CXType_UShort,
            c.CXType_UInt,
            c.CXType_ULong,
            c.CXType_ULongLong,
            c.CXType_UInt128,
            => .{
                .integer = .{
                    .bits = @intCast(c.clang_Type_getSizeOf(cx_type) * 8),
                    .signedness = .unsigned,
                },
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
            => .{
                .integer = .{
                    .bits = @intCast(c.clang_Type_getSizeOf(cx_type) * 8),
                    .signedness = .signed,
                },
            },

            // -- Floats -- //

            c.CXType_Float,
            c.CXType_Double,
            c.CXType_LongDouble,
            => .{
                .float = .{
                    .bits = @intCast(c.clang_Type_getSizeOf(cx_type) * 8),
                },
            },

            // -- Arrays & Slices -- //

            c.CXType_ConstantArray, c.CXType_IncompleteArray => outer: {
                const element_type = try allocator.create(TypeReference);
                element_type.* = try fromCXType(allocator, c.clang_getArrayElementType(cx_type), ir);

                break :outer .{
                    .array = .{
                        .element_type = element_type,
                        .count = c.clang_getArraySize(cx_type),
                    },
                };
            },

            // -- Pointers & References -- //

            c.CXType_Pointer => outer: {
                const pointee = try allocator.create(TypeReference);
                pointee.* = try fromCXType(allocator, c.clang_getPointeeType(cx_type), ir);

                break :outer .{ .pointer = pointee };
            },
            c.CXType_LValueReference => outer: {
                const pointee = try allocator.create(TypeReference);
                pointee.* = try fromCXType(allocator, c.clang_getPointeeType(cx_type), ir);

                break :outer .{ .reference = pointee };
            },

            // -- Records & Enums -- //

            c.CXType_Record => outer: {
                const name = try ffi.getCursorSpelling(allocator, c.clang_getTypeDeclaration(cx_type));
                if (c.clang_Type_getNumTemplateArguments(cx_type) > 0) {
                    if (Logging.WARN_TEMPLATE_TYPE) log.warn("Templated type '{s}' not yet implemented!", .{name});
                    break :outer .unexposed;
                }

                const is_in_main_file = ffi.isTypeDeclaredInMainFile(cx_type);
                if (!is_in_main_file) break :outer .{ .included = name };

                break :outer .{ .record = name };
            },
            c.CXType_Enum => outer: {
                const name = try ffi.getCursorSpelling(allocator, c.clang_getTypeDeclaration(cx_type));

                const is_in_main_file = ffi.isTypeDeclaredInMainFile(cx_type);
                if (!is_in_main_file) break :outer .{ .included = name };

                break :outer .{ .enumeration = name };
            },

            // -- Closures -- //

            c.CXType_FunctionProto => outer: {
                const return_type = try allocator.create(TypeReference);
                return_type.* = try .fromCXType(allocator, c.clang_getResultType(cx_type), ir);

                const params = try allocator.alloc(TypeReference, @intCast(c.clang_getNumArgTypes(cx_type)));
                const is_variadic = c.clang_isFunctionTypeVariadic(cx_type) != 0;

                for (params, 0..) |*p, i| {
                    p.* = try .fromCXType(allocator, c.clang_getArgType(cx_type, @intCast(i)), ir);
                }

                break :outer .{
                    .function = .{
                        .variadic = is_variadic,
                        .return_type = return_type,
                        .params = params,
                    },
                };
            },

            // -- Fallback --//

            else => outer: {
                log.err("Unhandled type '{s}'!", .{try ffi.getTypeKindSpelling(allocator, cx_type.kind)});
                break :outer .not_yet_implemented;
            },
        },
        .cx_type = cx_type,
    };
}

pub fn intoFakePointer(self: *@This()) @This() {
    return .{
        .cx_type = self.cx_type,
        .is_const = false,
        .inner = .{ .pointer = self },
    };
}

// -- Getters -- //

pub fn getPointerDepthAndType(self: *const TypeReference) struct { usize, *const TypeReference } {
    var i: usize = 0;
    var ref = self;

    while (ref.inner == .pointer) {
        ref = ref.inner.pointer;
        i += 1;
    }

    return .{ i, ref };
}

// -- Formatting -- //

pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
    if (self.is_const) try writer.writeAll("const ");
    switch (self.inner) {
        .integer => |int| {
            if (int.signedness == .signed) try writer.writeByte('i') else try writer.writeByte('u');
            try writer.print("{}", .{int.bits});
        },
        .float => |float| try writer.print("f{}", .{float.bits}),
        .record => |name| try writer.print("record '{s}'", .{name}),
        .enumeration => |name| try writer.print("enum '{s}'", .{name}),
        .array => |arr| try writer.print("{f}[{}]", .{ arr.element_type, arr.count }),
        .pointer => |pointee| try writer.print("pointer to '{f}'", .{pointee}),
        .reference => |pointee| try writer.print("reference to '{f}'", .{pointee}),
        else => try writer.writeAll(@tagName(self.inner)),
    }
}

// -- Logging -- //

const Logging = struct {
    pub const WARN_TEMPLATE_TYPE = false;
};
