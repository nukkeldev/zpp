// -- Imports -- //

const std = @import("std");

const Reader = @import("Reader.zig");
const Writer = @import("Writer.zig");

// -- Main -- //

pub fn main() !void {
    const verify = true;

    const path = "imgui/imgui.h";
    const filename = std.fs.path.basename(path);
    const args: []const [:0]const u8 = &.{"-DIMGUI_DISABLE_OBSOLETE_FUNCTIONS"};

    const reader = try Reader.parseFile(std.heap.smp_allocator, path, args, .{ .verbose = true });
    defer reader.arena.deinit();

    const allocator = reader.arena.allocator();
    var writer = Writer{
        .allocator = allocator,
        .annotate = false,
        .ast = reader.ast,
        .source_filename = filename,
        .target = .Cpp,
        .written_functions = .init(allocator),
    };

    {
        const cpp_header_path: []const u8 = try std.mem.concat(allocator, u8, &.{ filename, ".cpp" });
        var cpp_header_file = try std.fs.cwd().createFile(cpp_header_path, .{});
        defer cpp_header_file.close();

        var io_writer = cpp_header_file.writer(&.{});
        try writer.format(&io_writer.interface);

        std.log.info("Wrote C++ header!", .{});

        if (verify) {
            std.log.info("Verifying C++ header compiles...", .{});

            var comp = std.process.Child.init(&.{
                "zig",
                "build-lib",
                "-fclang",
                "-lc",
                "-cflags",
                "-std=c++20",
                "--",
                cpp_header_path,
                "-femit-bin=imgui.h.cpp.lib",
                try std.fmt.allocPrint(allocator, "-I{s}", .{std.fs.path.dirname(path) orelse ""}),
            }, std.heap.smp_allocator);
            _ = try comp.spawnAndWait();
        }
    }

    writer.target = .Zig;

    {
        const zig_bindings_path: []const u8 = "imgui.h.zig";
        var zig_bindings_file = try std.fs.cwd().createFile(zig_bindings_path, .{});
        defer zig_bindings_file.close();

        var io_writer = zig_bindings_file.writer(&.{});
        try writer.format(&io_writer.interface);

        std.log.info("Wrote Zig bindings!", .{});
        if (verify) {
            std.log.info("Verifying Zig bindings compile...", .{});

            var comp = std.process.Child.init(&.{ "zig", "build-lib", "imgui.h.zig", "-femit-bin=imgui.h.zig.lib" }, std.heap.smp_allocator);
            _ = try comp.spawnAndWait();
        }
    }
}
