//! Generates a Zig bindings via a C wrapper for C++ headers.
//!
//! TODO: Bring comments over.
//!
//! Element Mapping (C++ -> C -> Zig):
//! - `namespace` -> Prefixed elements -> `struct` containing `extern fn`s
//! - `struct` / `class`
//!   - C-compatible -> `struct` -> `extern struct`
//!   - Not C-compatible -> `void*` -> `?*anyopaque`
//! - `typedef` -> `typedef` -> `pub const`
//! - C/C++ types

// ---

const std = @import("std");

const c = @cImport({
    @cInclude("clang-c/Index.h");
});

// ---

var allocator: std.mem.Allocator = undefined;

pub fn main() !void {
    // Initialize the allocator and Program.
    var arena = std.heap.ArenaAllocator.init(std.heap.smp_allocator);
    defer arena.deinit();

    allocator = arena.allocator();

    // Parse the C/C++ file.
    const index = c.clang_createIndex(0, 0);
    defer c.clang_disposeIndex(index);

    const args: []const [*c]const u8 = &.{
        "-xc++", // Force it to parse C++, otherwise it hates namespaces.
        "-Iimgui/",
        "-DIMGUI_DISABLE_OBSOLETE_FUNCTIONS",
    };
    const unit = c.clang_parseTranslationUnit(
        index,
        "imgui/imgui.h",
        @ptrCast(args),
        args.len,
        null,
        0,
        c.CXTranslationUnit_None,
    ) orelse @panic("Unable to parse translation unit.");
    defer c.clang_disposeTranslationUnit(unit);

    // Get the cursor and traverse the TU.
    const cursor = c.clang_getTranslationUnitCursor(unit);

    var global_namespace = Element{
        .Namespace = .{
            .name = "<global>",
            .elements = .init(allocator),
        },
    };
    var client_data = ClientData{
        .parent_element = &global_namespace,
    };
    _ = c.clang_visitChildren(cursor, visitor, @ptrCast(&client_data));

    // Print the results.
    std.debug.print("Program:\n", .{});
    std.debug.print("{f}\n", .{global_namespace});
}

// -- AST Traversal -- //

const ClientData = struct { depth: usize = 0, parent_element: ?*Element = null };

var debug_traversal = false;
var element_format_indent: []const u8 = "";

pub const Namespace = struct {
    namespace: ?*Element = null,
    name: []const u8,
    elements: std.ArrayList(Element),

    pub fn format(ns: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
        const last_element_format_indent = element_format_indent;

        try writer.print("namespace {s} {{\n", .{ns.name});

        element_format_indent = std.fmt.allocPrint(allocator, "  {s}", .{element_format_indent}) catch @panic("OOM");
        for (ns.elements.items) |elm| try writer.print("{s}{f}\n", .{ element_format_indent, elm });
        element_format_indent = last_element_format_indent;

        try writer.print("{s}}};", .{element_format_indent});
    }
};

pub const Element = union(enum) {
    FunctionDecl: struct {
        namespace: *Element,
        name: []const u8,
        parameters: std.ArrayList(struct {
            name: []const u8,
            type: c.CXType,
        }),
        return_type: c.CXType,

        pub fn format(f: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
            try writer.print("fn {s}(", .{f.name});

            for (f.parameters.items[0..], 0..) |p, i| {
                try writer.print("{s}: {s}{s}", .{
                    p.name,
                    getTypeSpelling(p.type),
                    if (i == @max(f.parameters.items.len, 1) - 1) "" else ", ",
                });
            }

            try writer.print(") {s};", .{getTypeSpelling(f.return_type)});
        }
    },
    TypedefDecl: struct {
        namespace: *Element,
        name: []const u8,
        type: c.CXType,

        pub fn format(ty: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
            try writer.print("typedef {s} {s};", .{ getTypeSpelling(ty.type), ty.name });
        }
    },
    EnumDecl: struct {
        namespace: *Element,
        name: []const u8,
        type: c.CXType,
        integer_type: c.CXType,
        fields: std.ArrayList(struct {
            name: []const u8,
            value: c_longlong,
        }),

        pub fn format(s: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
            try writer.print("enum({s}) {s} {{\n", .{ getTypeSpelling(s.integer_type), s.name });
            for (s.fields.items[0..]) |p| {
                try writer.print("{s}  {s} = {},\n", .{
                    element_format_indent,
                    p.name,
                    p.value,
                });
            }
            try writer.print("{s}}};", .{element_format_indent});
        }
    },
    StructDecl: struct {
        namespace: *Element,
        name: []const u8,
        type: c.CXType,
        fields: std.ArrayList(struct {
            name: []const u8,
            type: c.CXType,
        }),

        pub fn format(s: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
            try writer.print("struct {s} {{\n", .{s.name});
            for (s.fields.items[0..]) |p| {
                try writer.print("{s}  {s}: {s},\n", .{
                    element_format_indent,
                    p.name,
                    getTypeSpelling(p.type),
                });
            }
            try writer.print("{s}}};", .{element_format_indent});
        }
    },
    // TODO: If multiple blocks, merge.
    Namespace: Namespace,

    pub fn format(elm: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
        switch (elm) {
            .FunctionDecl => |f| try f.format(writer),
            .TypedefDecl => |ty| try ty.format(writer),
            .EnumDecl => |e| try e.format(writer),
            .StructDecl => |s| try s.format(writer),
            .Namespace => |ns| try ns.format(writer),
            // else => {},
        }
    }
};

fn visitor(current_cursor: c.CXCursor, _: c.CXCursor, client_data_opaque: c.CXClientData) callconv(.c) c.CXVisitorResult {
    const location = c.clang_getCursorLocation(current_cursor);
    if (c.clang_Location_isFromMainFile(location) == 0) return c.CXChildVisit_Continue;

    const client_data: *ClientData = @ptrCast(@alignCast(client_data_opaque));
    var next_client_data = client_data.*;
    next_client_data.depth += 1;

    if (debug_traversal) {
        for (0..client_data.depth) |_| std.debug.print("  ", .{});
        std.debug.print("{s}\n", .{formatCursor(current_cursor)});
    }

    switch (current_cursor.kind) {
        c.CXCursor_FunctionDecl => {
            const elm = getNamespaceElements(client_data).addOne() catch @panic("OOM");
            elm.* = .{
                .FunctionDecl = .{
                    .namespace = getNamespace(client_data),
                    .name = getName(current_cursor),
                    .parameters = .init(allocator),
                    .return_type = c.clang_getCursorResultType(current_cursor),
                },
            };

            next_client_data.parent_element = elm;
            _ = c.clang_visitChildren(current_cursor, visitor, @ptrCast(&next_client_data));
        },
        c.CXCursor_ParmDecl => {
            switch ((client_data.parent_element orelse unreachable).*) {
                .FunctionDecl => |*fn_decl| {
                    fn_decl.parameters.append(.{
                        .name = getName(current_cursor),
                        .type = c.clang_getCursorType(current_cursor),
                    }) catch @panic("OOM");
                },
                else => unreachable,
            }
        },
        // TODO: Might use `c.clang_getTypedefName`
        c.CXCursor_TypedefDecl => {
            const @"type" = c.clang_getTypedefDeclUnderlyingType(current_cursor);
            getNamespaceElements(client_data).append(.{
                .TypedefDecl = .{
                    .namespace = getNamespace(client_data),
                    .name = getName(current_cursor),
                    .type = @"type",
                },
            }) catch @panic("OOM");
        },
        c.CXCursor_EnumDecl => {
            const @"type" = c.clang_getCursorType(current_cursor);

            const elm = getNamespaceElements(client_data).addOne() catch @panic("OOM");
            elm.* = .{
                .EnumDecl = .{
                    .namespace = getNamespace(client_data),
                    .name = getName(current_cursor),
                    .type = @"type",
                    .integer_type = c.clang_getEnumDeclIntegerType(current_cursor),
                    .fields = .init(allocator),
                },
            };

            next_client_data.parent_element = elm;
            _ = c.clang_visitChildren(current_cursor, visitor, @ptrCast(&next_client_data));
        },
        c.CXCursor_EnumConstantDecl => {
            switch ((client_data.parent_element orelse unreachable).*) {
                .EnumDecl => |*enum_decl| {
                    enum_decl.fields.append(.{
                        .name = getName(current_cursor),
                        .value = c.clang_getEnumConstantDeclValue(current_cursor),
                    }) catch @panic("OOM");
                },
                else => unreachable,
            }
        },
        c.CXCursor_StructDecl => {
            const @"type" = c.clang_getCursorType(current_cursor);

            const elm = getNamespaceElements(client_data).addOne() catch @panic("OOM");
            elm.* = .{
                .StructDecl = .{
                    .namespace = getNamespace(client_data),
                    .name = getName(current_cursor),
                    .type = @"type",
                    .fields = .init(allocator),
                },
            };

            next_client_data.parent_element = elm;
            _ = c.clang_visitChildren(current_cursor, visitor, @ptrCast(&next_client_data));
        },
        c.CXCursor_FieldDecl => {
            switch ((client_data.parent_element orelse unreachable).*) {
                .StructDecl => |*struct_decl| {
                    struct_decl.fields.append(.{
                        .name = getName(current_cursor),
                        .type = c.clang_getCursorType(current_cursor),
                    }) catch @panic("OOM");
                },
                else => unreachable,
            }
        },
        c.CXCursor_Namespace => {
            const elm = getNamespaceElements(client_data).addOne() catch @panic("OOM");
            elm.* = .{
                .Namespace = .{
                    .namespace = getNamespace(client_data),
                    .name = getName(current_cursor),
                    .elements = .init(allocator),
                },
            };

            next_client_data.parent_element = elm;
            _ = c.clang_visitChildren(current_cursor, visitor, @ptrCast(&next_client_data));
        },
        else => {},
    }

    return c.CXChildVisit_Continue;
}

// -- Helpers -- //

fn getName(cursor: c.CXCursor) []const u8 {
    const name = c.clang_getCursorSpelling(cursor);
    defer c.clang_disposeString(name);

    return allocator.dupe(u8, std.mem.span(c.clang_getCString(name))) catch @panic("OOM");
}

fn getTypeSpelling(@"type": c.CXType) []const u8 {
    const spelling = c.clang_getTypeSpelling(@"type");
    defer c.clang_disposeString(spelling);

    return allocator.dupe(u8, std.mem.span(c.clang_getCString(spelling))) catch @panic("OOM");
}

fn getNamespaceElements(client_data: *ClientData) *std.ArrayList(Element) {
    return switch (getNamespace(client_data).*) {
        .Namespace => |*ns| &ns.elements,
        else => unreachable,
    };
}

fn getNamespace(client_data: *ClientData) *Element {
    return switch (client_data.parent_element.?.*) {
        .FunctionDecl => |*t| t.namespace,
        .TypedefDecl => |*t| t.namespace,
        .EnumDecl => |*t| t.namespace,
        .StructDecl => |*t| t.namespace,
        .Namespace => client_data.parent_element.?,
    };
}

fn formatCursor(cursor: c.CXCursor) []const u8 {
    const spelling = c.clang_getCursorSpelling(cursor);
    defer c.clang_disposeString(spelling);

    const kind_spelling = c.clang_getCursorKindSpelling(cursor.kind);
    defer c.clang_disposeString(kind_spelling);

    return std.fmt.allocPrint(allocator, "<{s}: {s}>", .{
        c.clang_getCString(spelling),
        c.clang_getCString(kind_spelling),
    }) catch @panic("OOM");
}
