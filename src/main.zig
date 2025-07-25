// -- Imports -- //

const std = @import("std");

const Reader = @import("Reader.zig");
const Writer = @import("Writer.zig");

// -- Main -- //

pub fn main() !void {
    const args: []const [:0]const u8 = &.{"-DIMGUI_DISABLE_OBSOLETE_FUNCTIONS"};
    _ = try Reader.parseFile(std.heap.smp_allocator, "imgui/imgui.h", args, .{.verbose = true});

    // var arena = std.heap.ArenaAllocator.init(std.heap.smp_allocator);
    // defer arena.deinit();
    // allocator = arena.allocator();

    // const index = c.clang_createIndex(0, 0);
    // defer c.clang_disposeIndex(index);

    // const args: []const [*c]const u8 = &.{
    //     "-xc++", // Force it to parse C++.
    //     "-Iimgui/",
    //     "-DIMGUI_DISABLE_OBSOLETE_FUNCTIONS",
    // };
    // const unit = c.clang_parseTranslationUnit(
    //     index,
    //     "imgui/imgui.h",
    //     @ptrCast(args),
    //     args.len,
    //     null,
    //     0,
    //     c.CXTranslationUnit_None,
    // ) orelse @panic("Unable to parse translation unit.");
    // defer c.clang_disposeTranslationUnit(unit);

    // const cursor = c.clang_getTranslationUnitCursor(unit);

    // const ns = try allocator.create(Namespace);
    // ns.* = Namespace{ .name = "", .elements = .init(allocator) };
    // var client_data = ClientData{ .namespace = ns };
    // _ = c.clang_visitChildren(cursor, visitor, @ptrCast(&client_data));

    // {
    //     var cpp = std.fs.cwd().createFile("imgui.h.cpp", .{}) catch @panic("File error");
    //     defer cpp.close();

    //     var cpp_writer = cpp.writer(try allocator.alloc(u8, 0));
    //     written_functions = .init(allocator);
    //     try writeGlobalNamespace(ns, &cpp_writer.interface);

    //     std.log.info("Successfully wrote output!", .{});
    // }

    // var comp = std.process.Child.init(&.{ "zig", "c++", "imgui.h.cpp", "-std=c++20" }, allocator);
    // _ = try comp.spawnAndWait();
}

// // -- C-Wrapper -- //
// // TODO: Be idiomatic and use proper writergate stuff for everything.

// const ANNOTATE_OUTPUT = true;

// var linkage_prefix = "";
// var source_namespace = "NS";
// var elm_prefix = "Better_";
// // TODO: var indent = "";

// var written_functions: std.StringHashMap(usize) = undefined;

// fn writeGlobalNamespace(ns: *const Namespace, writer: *std.io.Writer) !void {
//     try writer.print("#include <bit>\n#include <cstdarg>\n\n", .{});
//     try writer.print("namespace {s} {{\n#include \"{s}\"\n}}\n\n", .{ source_namespace, "imgui/imgui.h" });
//     try writer.print("extern \"C\" {{\n", .{});
//     try writeNamespace(ns, writer);
//     try writer.print("}}\n", .{});
// }

// fn writeNamespace(ns: *const Namespace, writer: *std.io.Writer) !void {
//     for (ns.elements.items) |*elm| {
//         switch (elm.*) {
//             .Namespace => |ns_| try writeNamespace(ns_, writer),
//             .FunctionDecl => |*f| try writeFunctionDeclToCExternFunction(f, writer),
//             .StructDecl => |*s| try writeStructDecl(s, writer),
//             .TypedefDecl => |*t| try writeTypedef(t, writer),
//             .EnumDecl => |*e| try writeEnumDecl(e, writer),
//         }
//     }
// }

// fn getNamespaceQualifier(namespace: *const Namespace, separator: []const u8, include_src_ns: bool) ![]const u8 {
//     var ns_opt: ?*const Namespace = namespace;
//     var names = std.ArrayList([]const u8).init(allocator);
//     var out = std.ArrayList(u8).init(allocator);

//     while (ns_opt) |ns| : (ns_opt = ns.namespace) {
//         try names.append(ns.name);
//     }
//     for (0..names.items.len) |i| {
//         try out.appendSlice(names.items[names.items.len - i - 1]);
//         try out.appendSlice(separator);
//         if (include_src_ns and i == 0) {
//             try out.appendSlice(source_namespace);
//             try out.appendSlice(separator);
//         }
//     }
//     return out.items;
// }

// fn formatParams(params: *const std.ArrayList(Param), seperator: []const u8, trailing: bool) ![]const u8 {
//     if (params.items.len == 0) return "";

//     var out = std.ArrayList(u8).init(allocator);
//     for (params.items) |*p| {
//         if (ANNOTATE_OUTPUT) {
//             const spelling = c.clang_getTypeKindSpelling(p.type.kind);
//             defer c.clang_disposeString(spelling);
//             try out.appendSlice(try std.fmt.allocPrint(allocator, "/* {s} */ ", .{c.clang_getCString(spelling)}));
//         }

//         // TODO: Need to handle arrays and function pointers.
//         switch (p.type.kind) {
//             c.CXType_Unexposed => {
//                 try out.appendSlice("void * ");
//                 try out.appendSlice(p.name);
//                 try out.appendSlice(seperator);
//             },
//             // foo[N]
//             c.CXType_ConstantArray => {
//                 try out.appendSlice(getTypeSpelling(c.clang_getArrayElementType(p.type)));
//                 try out.appendSlice(" ");
//                 try out.appendSlice(p.name);
//                 try out.appendSlice(try std.fmt.allocPrint(allocator, "[{}]", .{c.clang_getArraySize(p.type)}));
//                 try out.appendSlice(seperator);
//             },
//             // foo[]
//             c.CXType_IncompleteArray => {
//                 try out.appendSlice(getTypeSpelling(c.clang_getArrayElementType(p.type)));
//                 try out.appendSlice(" ");
//                 try out.appendSlice(p.name);
//                 try out.appendSlice("[]");
//                 try out.appendSlice(seperator);
//             },
//             c.CXType_Pointer => {
//                 if (c.clang_getPointeeType(p.type).kind == c.CXType_Unexposed) {
//                     try out.appendSlice("void **");
//                     try out.appendSlice(p.name);
//                     try out.appendSlice(seperator);
//                 } else {
//                     try out.appendSlice(try formatPointerTypeWithName(p.type, p.name));
//                     try out.appendSlice(seperator);
//                 }
//             },
//             else => {
//                 try out.appendSlice(getTypeSpelling(p.type));
//                 try out.appendSlice(" ");
//                 try out.appendSlice(p.name);
//                 try out.appendSlice(seperator);
//             },
//         }
//     }
//     return if (trailing) out.items else out.items[0 .. out.items.len - seperator.len];
// }

// fn formatArgs(fn_decl: *const FunctionDecl) ![]const u8 {
//     if (fn_decl.parameters.items.len == 0) return "";

//     var out = std.ArrayList(u8).init(allocator);
//     for (fn_decl.parameters.items) |*p| {
//         outer: switch (p.type.kind) {
//             c.CXType_Pointer => {
//                 if (c.clang_getPointeeType(p.type).kind != c.CXType_Record) continue :outer c.CXType_Invalid;

//                 try out.appendSlice("reinterpret_cast<");
//                 try out.appendSlice(try getTypeSpellingEx(p.type, "::NS::"));
//                 try out.appendSlice(">(");
//                 try out.appendSlice(p.name);
//                 try out.appendSlice("), ");
//             },
//             c.CXType_Record, c.CXType_Enum => {
//                 try out.appendSlice("std::bit_cast<");
//                 try out.appendSlice(try getTypeSpellingEx(p.type, "::NS::"));
//                 try out.appendSlice(">(");
//                 try out.appendSlice(p.name);
//                 try out.appendSlice("), ");
//             },
//             else => {
//                 try out.appendSlice(p.name);
//                 try out.appendSlice(", ");
//             },
//         }
//     }
//     return out.items[0 .. out.items.len - 2];
// }

// fn wrapExpression(ty: c.CXType, expression: []const u8) ![]const u8 {
//     var out = std.ArrayList(u8).init(allocator);
//     if (ty.kind == c.CXType_Pointer or ty.kind == c.CXType_LValueReference) {
//         try out.appendSlice("reinterpret_cast<");
//         try out.appendSlice(try getTypeSpellingEx(ty, null));
//         try out.appendSlice(">(");
//         if (ty.kind == c.CXType_LValueReference) try out.append('&');
//         try out.appendSlice(expression);
//         try out.appendSlice(")");
//     } else if (ty.kind == c.CXType_Record or ty.kind == c.CXType_Enum) {
//         try out.appendSlice("std::bit_cast<");
//         try out.appendSlice(getTypeSpelling(ty));
//         try out.appendSlice(">(");
//         try out.appendSlice(expression);
//         try out.appendSlice(")");
//     } else {
//         try out.appendSlice(expression);
//     }
//     return out.items;
// }

// // TODO: Variadic functions.
// // TODO: Cast argument and return types (pointers with reinterp and non with bit_cast (c++20)).
// fn writeFunctionDeclToCExternFunction(fn_decl: *const FunctionDecl, writer: *std.io.Writer) !void {
//     const template =
//         \\{[linkage_prefix]s}{[return_type]s} {[extern_fn_name]s}({[params]s}) {{ return {[expr]s};}}
//         \\
//     ;

//     var function_name = try std.fmt.allocPrint(allocator, "{s}{s}", .{ (try getNamespaceQualifier(fn_decl.namespace, "_", false))[1..], fn_decl.name });
//     const wf = try written_functions.getOrPutValue(function_name, 0);
//     if (wf.value_ptr.* > 0) function_name = try std.fmt.allocPrint(allocator, "{s}{}", .{ function_name, wf.value_ptr.* });
//     wf.value_ptr.* += 1;

//     var expr: []const u8 = try std.fmt.allocPrint(allocator, "{[namespace]s}{[fn_name]s}({[args]s})", .{
//         .namespace = try getNamespaceQualifier(fn_decl.namespace, "::", true),
//         .fn_name = fn_decl.name,
//         .args = try formatArgs(fn_decl),
//     });
//     expr = try wrapExpression(fn_decl.return_type, expr);

//     try writer.print(template, .{
//         .linkage_prefix = linkage_prefix,
//         .return_type = try getTypeSpellingEx(fn_decl.return_type, null),
//         .extern_fn_name = function_name,
//         .params = try formatParams(&fn_decl.parameters, ", ", false),
//         .expr = expr,
//     });
// }

// /// Write a struct definition to the output. If no fields, assumed to be a forward refrence.
// fn writeStructDecl(struct_decl: *const StructDecl, writer: *std.io.Writer) !void {
//     const prefixed_name = try std.mem.concat(allocator, u8, &.{elm_prefix, struct_decl.name});

//     const is_forward_decl = struct_decl.fields.items.len > 0;

//     if (is_forward_decl) {
//         try writer.print(
//             "struct {[name]s} {{\n{[params]s}}};\n",
//             .{
//                 .name = prefixed_name,
//                 .params = try formatParams(&struct_decl.fields, ";\n", true),
//             },
//         );
//     } else {
//         try writer.print(
//             "typedef struct {[name]s} {[name]s};\n",
//             .{
//                 .name = prefixed_name,
//             },
//         );
//     }
// }

// fn writeEnumDecl(enum_decl: *const EnumDecl, writer: *std.io.Writer) !void {
//     try writer.print("enum {s} {{\n", .{enum_decl.name});
//     try writer.print("}};\n", .{});
// }

// fn writeTypedef(t: *const TypedefDecl, writer: *std.io.Writer) !void {
//     const prefixed_name = try std.mem.concat(allocator, u8, &.{ elm_prefix, t.name });

//     try writer.print("typedef ", .{});
//     switch (t.type.kind) {
//         c.CXType_Pointer => {
//             // TODO: Write wrappers.
//             if (c.clang_getPointeeType(t.type).kind == c.CXType_FunctionProto) {
//                 try writer.print("::NS::{s} {s}", .{ t.name, prefixed_name });
//             } else {
//                 try writer.print("{s}", .{try formatPointerTypeWithName(t.type, prefixed_name)});
//             }
//         },
//         else => {
//             try writer.print("{s} {s}", .{ getTypeSpelling(t.type), prefixed_name });
//         },
//     }
//     try writer.print(";\n", .{});
//     // const pointee = c.clang_getPointeeType(t.type);
//     // if (t.type.kind == c.CXType_Pointer and pointee.kind == c.CXType_FunctionProto) {
//     //     const args = c.clang_getNumArgTypes(pointee);
//     //     const res = c.clang_getResultType(pointee);
//     //     try writer.print(("{s} wrapper_{s}("), .{getTypeSpelling(res), t.name});
//     //     for (0..@intCast(args)) |i| {
//     //         const argt = c.clang_getArgType(pointee, @intCast(i));
//     //         try writer.print("{s} arg{}", .{getTypeSpelling(argt), i});
//     //         if (i != args-1) try writer.print(", ", .{});
//     //     }
//     //     try writer.print(") {{\n", .{});
//     // }
// }

// // -- AST Traversal -- //

// const ClientData = struct { depth: usize = 0, parent_element: ?*Element = null, namespace: *Namespace };

// var debug_traversal = false;
// var element_format_indent: []const u8 = "";

// const Namespace = struct {
//     namespace: ?*Namespace = null,
//     name: []const u8,
//     elements: std.ArrayList(Element),

//     pub fn format(ns: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
//         const last_element_format_indent = element_format_indent;

//         try writer.print("namespace {s} {{\n", .{ns.name});

//         element_format_indent = std.fmt.allocPrint(allocator, "  {s}", .{element_format_indent}) catch @panic("OOM");
//         for (ns.elements.items) |elm| try writer.print("{s}{f}\n", .{ element_format_indent, elm });
//         element_format_indent = last_element_format_indent;

//         try writer.print("{s}}};", .{element_format_indent});
//     }
// };

// const Param = struct {
//     name: []const u8,
//     type: c.CXType,
// };

// const FunctionDecl = struct {
//     namespace: *Namespace,
//     name: []const u8,
//     parameters: std.ArrayList(Param),
//     return_type: c.CXType,

//     pub fn format(f: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
//         try writer.print("fn {s}(", .{f.name});

//         for (f.parameters.items[0..], 0..) |p, i| {
//             try writer.print("{s}: {s}{s}", .{
//                 p.name,
//                 getTypeSpelling(p.type),
//                 if (i == @max(f.parameters.items.len, 1) - 1) "" else ", ",
//             });
//         }

//         try writer.print(") {s};", .{getTypeSpelling(f.return_type)});
//     }
// };

// const StructDecl = struct {
//     namespace: *Namespace,
//     name: []const u8,
//     type: c.CXType,
//     fields: std.ArrayList(Param),

//     pub fn format(s: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
//         try writer.print("struct {s}\n", .{s.name});
//         for (s.fields.items[0..]) |p| {
//             try writer.print("{s}  {s}: {s},\n", .{
//                 element_format_indent,
//                 p.name,
//                 getTypeSpelling(p.type),
//             });
//         }
//         try writer.print("{s}}};", .{element_format_indent});
//     }
// };

// const TypedefDecl = struct {
//     namespace: *Namespace,
//     name: []const u8,
//     type: c.CXType,

//     pub fn format(ty: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
//         try writer.print("typedef {s} {s};", .{ getTypeSpelling(ty.type), ty.name });
//     }
// };

// const EnumDecl = struct {
//     namespace: *Namespace,
//     name: []const u8,
//     type: c.CXType,
//     integer_type: c.CXType,
//     fields: std.ArrayList(struct {
//         name: []const u8,
//         value: c_longlong,
//     }),

//     pub fn format(s: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
//         try writer.print("enum({s}) {s} {{\n", .{ getTypeSpelling(s.integer_type), s.name });
//         for (s.fields.items[0..]) |p| {
//             try writer.print("{s}  {s} = {},\n", .{
//                 element_format_indent,
//                 p.name,
//                 p.value,
//             });
//         }
//         try writer.print("{s}}};", .{element_format_indent});
//     }
// };

// pub const Element = union(enum) {
//     FunctionDecl: FunctionDecl,
//     TypedefDecl: TypedefDecl,
//     EnumDecl: EnumDecl,
//     StructDecl: StructDecl,
//     Namespace: *Namespace,

//     pub fn format(elm: @This(), writer: *std.io.Writer) std.io.Writer.Error!void {
//         switch (elm) {
//             .FunctionDecl => |f| try f.format(writer),
//             .TypedefDecl => |ty| try ty.format(writer),
//             .EnumDecl => |e| try e.format(writer),
//             .StructDecl => |s| try s.format(writer),
//             .Namespace => |ns| try ns.format(writer),
//         }
//     }
// };

// fn visitor(current_cursor: c.CXCursor, _: c.CXCursor, client_data_opaque: c.CXClientData) callconv(.c) c.CXVisitorResult {
//     const location = c.clang_getCursorLocation(current_cursor);
//     if (c.clang_Location_isFromMainFile(location) == 0) return c.CXChildVisit_Continue;

//     const client_data: *ClientData = @ptrCast(@alignCast(client_data_opaque));
//     var next_client_data = client_data.*;
//     next_client_data.depth += 1;

//     if (debug_traversal) {
//         for (0..client_data.depth) |_| std.debug.print("  ", .{});
//         std.debug.print("{s}\n", .{formatCursor(current_cursor)});
//     }

//     outer: switch (current_cursor.kind) {
//         c.CXCursor_FunctionDecl => {
//             const name = getName(current_cursor);
//             if (std.mem.startsWith(u8, name, "operator")) break :outer;

//             const elm = getNamespaceElements(client_data).addOne() catch @panic("OOM");
//             elm.* = .{
//                 .FunctionDecl = .{
//                     .namespace = client_data.namespace,
//                     .name = name,
//                     .parameters = .init(allocator),
//                     .return_type = c.clang_getCursorResultType(current_cursor),
//                 },
//             };

//             next_client_data.parent_element = elm;
//             _ = c.clang_visitChildren(current_cursor, visitor, @ptrCast(&next_client_data));
//         },
//         c.CXCursor_ParmDecl => {
//             switch ((client_data.parent_element orelse unreachable).*) {
//                 .FunctionDecl => |*fn_decl| {
//                     fn_decl.parameters.append(.{
//                         .name = getName(current_cursor),
//                         .type = c.clang_getCursorType(current_cursor),
//                     }) catch @panic("OOM");
//                 },
//                 else => unreachable,
//             }
//         },
//         // TODO: Might use `c.clang_getTypedefName`
//         c.CXCursor_TypedefDecl => {
//             const @"type" = c.clang_getTypedefDeclUnderlyingType(current_cursor);
//             getNamespaceElements(client_data).append(.{
//                 .TypedefDecl = .{
//                     .namespace = client_data.namespace,
//                     .name = getName(current_cursor),
//                     .type = @"type",
//                 },
//             }) catch @panic("OOM");
//         },
//         c.CXCursor_EnumDecl => {
//             const @"type" = c.clang_getCursorType(current_cursor);

//             const elm = getNamespaceElements(client_data).addOne() catch @panic("OOM");
//             elm.* = .{
//                 .EnumDecl = .{
//                     .namespace = client_data.namespace,
//                     .name = getName(current_cursor),
//                     .type = @"type",
//                     .integer_type = c.clang_getEnumDeclIntegerType(current_cursor),
//                     .fields = .init(allocator),
//                 },
//             };

//             next_client_data.parent_element = elm;
//             _ = c.clang_visitChildren(current_cursor, visitor, @ptrCast(&next_client_data));
//         },
//         c.CXCursor_EnumConstantDecl => {
//             switch ((client_data.parent_element orelse unreachable).*) {
//                 .EnumDecl => |*enum_decl| {
//                     enum_decl.fields.append(.{
//                         .name = getName(current_cursor),
//                         .value = c.clang_getEnumConstantDeclValue(current_cursor),
//                     }) catch @panic("OOM");
//                 },
//                 else => unreachable,
//             }
//         },
//         c.CXCursor_StructDecl => {
//             const @"type" = c.clang_getCursorType(current_cursor);

//             const elm = getNamespaceElements(client_data).addOne() catch @panic("OOM");
//             elm.* = .{
//                 .StructDecl = .{
//                     .namespace = client_data.namespace,
//                     .name = getName(current_cursor),
//                     .type = @"type",
//                     .fields = .init(allocator),
//                 },
//             };

//             next_client_data.parent_element = elm;
//             _ = c.clang_visitChildren(current_cursor, visitor, @ptrCast(&next_client_data));
//         },
//         c.CXCursor_FieldDecl => {
//             switch ((client_data.parent_element orelse unreachable).*) {
//                 .StructDecl => |*struct_decl| {
//                     struct_decl.fields.append(.{
//                         .name = getName(current_cursor),
//                         .type = c.clang_getCursorType(current_cursor),
//                     }) catch @panic("OOM");
//                 },
//                 else => unreachable,
//             }
//         },
//         c.CXCursor_Namespace => {
//             const ns = allocator.create(Namespace) catch @panic("OOM");
//             ns.* = .{
//                 .namespace = client_data.namespace,
//                 .name = getName(current_cursor),
//                 .elements = .init(allocator),
//             };

//             getNamespaceElements(client_data).append(.{ .Namespace = ns }) catch @panic("OOM");

//             next_client_data.namespace = ns;
//             _ = c.clang_visitChildren(current_cursor, visitor, @ptrCast(&next_client_data));
//         },
//         else => {},
//     }

//     return c.CXChildVisit_Continue;
// }

// // -- Helpers -- //

// fn getName(cursor: c.CXCursor) []const u8 {
//     const name = c.clang_getCursorSpelling(cursor);
//     defer c.clang_disposeString(name);

//     return allocator.dupe(u8, std.mem.span(c.clang_getCString(name))) catch @panic("OOM");
// }

// fn getTypeSpelling(@"type": c.CXType) []const u8 {
//     const spelling = c.clang_getTypeSpelling(@"type");
//     defer c.clang_disposeString(spelling);

//     return allocator.dupe(u8, std.mem.span(c.clang_getCString(spelling))) catch @panic("OOM");
// }

// fn getTypeSpellingEx(@"type": c.CXType, namespace: ?[]const u8) ![]const u8 {
//     var out = std.ArrayList(u8).init(allocator);
//     const spelling = getTypeSpelling(@"type");
//     var toks = std.mem.tokenizeScalar(u8, spelling, ' ');

//     while (toks.next()) |t| {
//         if (std.mem.eql(u8, t, "&")) {
//             try out.appendSlice("*");
//         } else if (!(std.mem.eql(u8, t, "const") or std.mem.eql(u8, t, "*"))) {
//             if (namespace) |ns| try out.appendSlice(ns);
//             try out.appendSlice(t);
//         } else {
//             try out.appendSlice(t);
//         }
//         try out.appendSlice(" ");
//     }

//     return out.items;
// }

// fn getNamespaceElements(client_data: *ClientData) *std.ArrayList(Element) {
//     return &client_data.namespace.elements;
// }

// fn formatCursor(cursor: c.CXCursor) []const u8 {
//     const spelling = c.clang_getCursorSpelling(cursor);
//     defer c.clang_disposeString(spelling);

//     const kind_spelling = c.clang_getCursorKindSpelling(cursor.kind);
//     defer c.clang_disposeString(kind_spelling);

//     return std.fmt.allocPrint(allocator, "<{s}: {s}>", .{
//         c.clang_getCString(spelling),
//         c.clang_getCString(kind_spelling),
//     }) catch @panic("OOM");
// }

// fn formatPointerTypeWithName(p: c.CXType, name: []const u8) ![]const u8 {
//     const pointee = c.clang_getPointeeType(p);
//     var out = std.ArrayList(u8).init(allocator);

//     if (pointee.kind == c.CXType_FunctionProto) {
//         const spelling = getTypeSpelling(p);
//         const insert_here = std.mem.indexOf(u8, spelling, "(*)").?;

//         try out.appendSlice(spelling[0 .. insert_here + 2]);
//         try out.appendSlice(name);
//         try out.appendSlice(spelling[insert_here + 2 ..]);
//     } else {
//         try out.appendSlice(getTypeSpelling(p));
//         try out.appendSlice(" ");
//         try out.appendSlice(name);
//     }

//     return out.items;
// }
