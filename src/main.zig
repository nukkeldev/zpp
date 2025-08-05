// -- Imports -- //

const std = @import("std");

const Reader = @import("Reader.zig");
const Writer = @import("Writer.zig");
const Verification = @import("Verification.zig");

// -- Main -- //

pub fn main() !void {
    const verify = true;
    const compile = true;

    const cmd_args = try std.process.argsAlloc(std.heap.smp_allocator);
    defer std.process.argsFree(std.heap.smp_allocator, cmd_args);

    const path = if (cmd_args.len < 2) @panic("requires file path") else cmd_args[1];
    const filename = std.fs.path.basename(path);
    const args: []const [:0]const u8 = if (cmd_args.len > 2) cmd_args[2..] else &.{};

    std.log.info("Generating bindings for '{s}' with args:", .{path});
    for (args, 0..) |arg, i| std.debug.print("  #{} - {s}\n", .{ i, arg });

    const reader = try Reader.parseFile(std.heap.smp_allocator, path, args, .{ .verbose = true });
    defer reader.arena.deinit();

    try std.fs.cwd().deleteTree("zpp-out");
    try std.fs.cwd().makePath("zpp-out/lib");

    const allocator = reader.arena.allocator();
    var writer = Writer{
        .allocator = allocator,
        .annotate = false,
        .ast = reader.ast,
        .source_filename = filename,
        .language = .Cpp,
        .function_overload_counts = .init(allocator),
    };

    {
        const cpp_header_path: []const u8 = try std.mem.concat(allocator, u8, &.{ "zpp-out/", filename, ".cpp" });
        var cpp_header_file = try std.fs.cwd().createFile(cpp_header_path, .{});
        defer cpp_header_file.close();

        var io_writer = cpp_header_file.writer(&.{});
        try writer.format(&io_writer.interface);

        std.log.info("Wrote C++ header!", .{});

        if (compile) {
            std.log.info("Verifying C++ header compiles...", .{});

            var comp = std.process.Child.init(try std.mem.concat(allocator, []const u8, &.{
                &.{
                    "zig",
                    "build-lib",
                    "-fclang",
                    "-lc++",
                    "-cflags",
                    "-std=c++20",
                    try std.fmt.allocPrint(allocator, "-I{s}", .{std.fs.path.dirname(path) orelse ""}),
                },
                args,
                &.{
                    "--",
                    cpp_header_path,
                    try std.fmt.allocPrint(allocator, "-femit-bin=zpp-out/lib/{s}.cpp.lib", .{filename}),
                },
            }), std.heap.smp_allocator);
            
            std.debug.print("COMMAND: ", .{});
            for (comp.argv) |arg| std.debug.print("{s} ", .{arg});
            std.debug.print("\n", .{});

            _ = try comp.spawnAndWait();
        }
    }

    writer.language = .Zig;
    writer.function_overload_counts.clearAndFree();
    writer.function_overload_counts = .init(allocator);

    {
        const zig_bindings_path: []const u8 = try std.mem.concat(allocator, u8, &.{ "zpp-out/", filename, ".zig" });
        var zig_bindings_file = try std.fs.cwd().createFile(zig_bindings_path, .{});
        defer zig_bindings_file.close();

        var io_writer = zig_bindings_file.writer(&.{});
        try writer.format(&io_writer.interface);

        std.log.info("Wrote Zig bindings!", .{});
        if (compile) {
            std.log.info("Verifying Zig bindings compile...", .{});

            var comp = std.process.Child.init(&.{
                "zig",
                "build-lib",
                zig_bindings_path,
                try std.fmt.allocPrint(allocator, "-femit-bin=zpp-out/lib/{s}.zig.lib", .{filename}),
            }, std.heap.smp_allocator);
            _ = try comp.spawnAndWait();
        }
    }

    if (!verify) return;

    var verif = Verification{
        .allocator = allocator,
        .ast = reader.ast,
        .language = .Cpp,
        .source_filename = filename,
    };

    {
        const file_path: []const u8 = try std.mem.concat(allocator, u8, &.{ "zpp-out/verify_", filename, ".cpp" });
        var file = try std.fs.cwd().createFile(file_path, .{});
        defer file.close();

        var io_writer = file.writer(&.{});
        try verif.format(&io_writer.interface);

        std.log.info("Wrote C++ verification!", .{});
        if (compile) {
            std.log.info("Verifying C++ verification compiles...", .{});

            var comp = std.process.Child.init(try std.mem.concat(allocator, []const u8, &.{
                &.{
                    "zig",
                    "build-lib",
                    "-fclang",
                    "-lc++",
                    "-cflags",
                    "-std=c++20",
                    try std.fmt.allocPrint(allocator, "-I{s}", .{std.fs.path.dirname(path) orelse ""}),
                },
                args,
                &.{
                    "--",
                    file_path,
                    try std.fmt.allocPrint(allocator, "-femit-bin=zpp-out/lib/verify_{s}.cpp.lib", .{filename}),
                },
            }), std.heap.smp_allocator);
            _ = try comp.spawnAndWait();
        }
    }

    verif.language = .Zig;

    {
        const file_path: []const u8 = try std.mem.concat(allocator, u8, &.{ "zpp-out/verify_", filename, ".zig" });
        var file = try std.fs.cwd().createFile(file_path, .{});
        defer file.close();

        var io_writer = file.writer(&.{});
        try verif.format(&io_writer.interface);

        std.log.info("Wrote Zig verification bindings!", .{});
        if (compile) {
            std.log.info("Verifying Zig bindings verification compile...", .{});

            var comp = std.process.Child.init(&.{
                "zig",
                "build-lib",
                file_path,
                try std.fmt.allocPrint(allocator, "-femit-bin=zpp-out/lib/file_path{s}.zig.lib", .{filename}),
            }, std.heap.smp_allocator);
            _ = try comp.spawnAndWait();
        }
    }
}
