// -- Imports -- //

const std = @import("std");

const Reader = @import("Reader.zig");
const Writer = @import("Writer.zig");

// -- Main -- //

pub fn main() !void {
    const args: []const [:0]const u8 = &.{"-DIMGUI_DISABLE_OBSOLETE_FUNCTIONS"};
    const ast = try Reader.parseFile(std.heap.smp_allocator, "imgui/imgui.h", args, .{ .verbose = true });

    {
        const cpp_header_path: []const u8 = "imgui.h.cpp";
        var cpp_header_file = try std.fs.cwd().createFile(cpp_header_path, .{});
        defer cpp_header_file.close();

        var writer = cpp_header_file.writer(&.{});
        try Writer.formatASTAsCppHeader(ast, &writer.interface);

        std.log.info("Wrote C++ header!", .{});
        std.log.info("Verifying C++ header compiles...", .{});

        var comp = std.process.Child.init(&.{ "zig", "build-lib", "-cflags", "-std=c++20", "--", "imgui.h.cpp", "-femit-bin=imgui.h.cpp.lib" }, std.heap.smp_allocator);
        _ = try comp.spawnAndWait();
    }

    {
        const zig_bindings_path: []const u8 = "imgui.h.zig";
        var zig_bindings_file = try std.fs.cwd().createFile(zig_bindings_path, .{});
        defer zig_bindings_file.close();

        var writer = zig_bindings_file.writer(&.{});
        try Writer.formatASTAsZigBindings(ast, &writer.interface);

        std.log.info("Wrote Zig bindings!", .{});
        std.log.info("Verifying Zig bindings compile...", .{});

        var comp = std.process.Child.init(&.{ "zig", "build-lib", "imgui.h.zig", "-femit-bin=imgui.h.zig.lib" }, std.heap.smp_allocator);
        _ = try comp.spawnAndWait();
    }
}
