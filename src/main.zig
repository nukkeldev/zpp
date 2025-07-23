//! Generates a Zig bindings via a C wrapper for C++ headers.
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

    program = .init(allocator);

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
    var client_data = ClientData{};
    _ = c.clang_visitChildren(cursor, visitor, @ptrCast(&client_data));

    // Print the results.
    std.debug.print("Program:\n", .{});
    std.debug.print("{f}\n", .{Element{
        .Namespace = .{
            .name = "<global>",
            .elements = program,
        },
    }});
}

// -- AST Traversal -- //

const ClientData = struct { depth: usize = 0, parent_element: ?*Element = null };

const DEBUG_TRAVERSAL = false;
var element_format_indent: []const u8 = "";

// ---

var program: std.ArrayList(Element) = undefined;

pub const Element = union(enum) {
    FunctionDecl: struct {
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
        name: []const u8,
        type: c.CXType,

        pub fn format(ty: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
            try writer.print("typedef {s} {s};", .{ getTypeSpelling(ty.type), ty.name });
        }
    },
    EnumDecl: struct {
        name: []const u8,
        fields: std.ArrayList(struct {
            name: []const u8,
            value: usize,
        }),
    },
    StructDecl: struct {},
    // TODO: If multiple blocks, merge.
    Namespace: struct {
        name: []const u8,
        elements: std.ArrayList(Element),

        pub fn format(ns: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
            const last_element_format_indent = element_format_indent;
            
            try writer.print("namespace {s} {{\n", .{ns.name});
            
            element_format_indent = std.fmt.allocPrint(allocator, "  {s}", .{element_format_indent}) catch @panic("OOM");
            for (ns.elements.items) |elm| try writer.print("{s}{f}\n", .{element_format_indent, elm});
            element_format_indent = last_element_format_indent;
            
            try writer.print("{s}}};", .{element_format_indent});
        }
    },

    pub fn format(elm: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
        switch (elm) {
            .FunctionDecl => |f| try f.format(writer),
            .TypedefDecl => |ty| try ty.format(writer),
            .Namespace => |ns| try ns.format(writer),
            else => {},
        }
    }
};

fn visitor(current_cursor: c.CXCursor, _: c.CXCursor, client_data_opaque: c.CXClientData) callconv(.c) c.CXVisitorResult {
    const location = c.clang_getCursorLocation(current_cursor);
    if (c.clang_Location_isFromMainFile(location) == 0) return c.CXChildVisit_Continue;

    const client_data: *ClientData = @ptrCast(@alignCast(client_data_opaque));
    var next_client_data = client_data.*;
    next_client_data.depth += 1;

    if (DEBUG_TRAVERSAL) {
        for (0..client_data.depth) |_| std.debug.print("  ", .{});
        std.debug.print("{s}\n", .{formatCursor(current_cursor)});
    }

    // Add relevant information to the Program.
    switch (current_cursor.kind) {
        // .FunctionDecl
        c.CXCursor_FunctionDecl => {
            // Push the function declaration to the namespace.
            const return_type = c.clang_getCursorResultType(current_cursor);

            const ns_elms = getNamespace(client_data);
            const elm = ns_elms.addOne() catch @panic("OOM");
            elm.* = .{
                .FunctionDecl = .{
                    .name = getName(current_cursor),
                    .parameters = .init(allocator),
                    .return_type = return_type,
                },
            };

            // Process the parameters.
            next_client_data.parent_element = elm;
            _ = c.clang_visitChildren(current_cursor, visitor, @ptrCast(&next_client_data));
        },
        c.CXCursor_ParmDecl => {
            // Get the name and the type of the parameter.
            const name = c.clang_getCursorSpelling(current_cursor);
            defer c.clang_disposeString(name);

            const @"type" = c.clang_getCursorType(current_cursor);

            // Append the parameter the last element of the processing stack.
            switch ((client_data.parent_element orelse unreachable).*) {
                .FunctionDecl => |*fn_decl| {
                    fn_decl.parameters.append(.{
                        .name = allocator.dupe(u8, std.mem.span(c.clang_getCString(name))) catch @panic("OOM"),
                        .type = @"type",
                    }) catch @panic("OOM");
                },
                else => @panic("Tried to process a parameter declaration but the last element of the processing stack was not a function declaration."),
            }
        },
        // .TypedefDecl
        c.CXCursor_TypedefDecl => {
            const ns_elms = getNamespace(client_data);

            const @"type" = c.clang_getTypedefDeclUnderlyingType(current_cursor);
            ns_elms.append(.{
                .TypedefDecl = .{
                    .name = getName(current_cursor),
                    .type = @"type",
                },
            }) catch @panic("OOM");
        },
        // .Namespace
        c.CXCursor_Namespace => {
            // Initialize and push the namespace onto the processing stack.
            const name = c.clang_getCursorSpelling(current_cursor);
            defer c.clang_disposeString(name);

            const elm = program.addOne() catch @panic("OOM");
            elm.* = .{
                .Namespace = .{
                    .name = allocator.dupe(u8, std.mem.span(c.clang_getCString(name))) catch @panic("OOM"),
                    .elements = .init(allocator),
                },
            };

            // Iterate through all of the elements.
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

fn getNamespace(client_data: *ClientData) *std.ArrayList(Element) {
    return if (client_data.parent_element) |elm| switch (elm.*) {
        .Namespace => |*ns| &ns.elements,
        else => outer: {
            std.log.warn("Processing function declaration not in a namespace, deferring to the global.", .{});
            break :outer &program;
        },
    } else &program;
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
