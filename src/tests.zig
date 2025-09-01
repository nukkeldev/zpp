const std = @import("std");

const ir_mod = @import("ir.zig");
const writers = @import("writers.zig");

const log = std.log.scoped(.tests);

const SOURCE = "tests/";

test "integration tests" {
    std.testing.log_level = .info;

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var dir = try std.fs.cwd().openDir(SOURCE, .{ .iterate = true, .access_sub_paths = false });
    defer dir.close();

    var tests = std.array_list.Managed([]const u8).init(allocator);
    defer tests.deinit();

    var iter = dir.iterate();
    while (try iter.next()) |file| {
        if (file.kind != .directory) continue;
        try tests.append(try allocator.dupe(u8, file.name));
    }

    for (tests.items) |test_name| {
        const header_path = try std.mem.concatWithSentinel(allocator, u8, &.{ SOURCE, test_name, "/", test_name, ".hpp" }, 0);
        try compareToExpected(allocator, test_name, writers.CppWrapper, header_path);
        try compareToExpected(allocator, test_name, writers.ZigWrapper, header_path);
    }
}

fn compareToExpected(allocator: std.mem.Allocator, test_name: []const u8, writer: writers.IRWriter, header_path: []const u8) !void {
    const path_final = try writer.formatFilename(allocator, try std.mem.concatWithSentinel(allocator, u8, &.{ SOURCE, test_name, "/", test_name }, 0));
    const expected_path_temp_root = try std.mem.concatWithSentinel(allocator, u8, &.{ SOURCE, test_name, "/", test_name, ".bkp" }, 0);
    const expected_path_temp = try writer.formatFilename(allocator, expected_path_temp_root);

    const tag = path_final[std.mem.lastIndexOfScalar(u8, path_final, '.').?+1..];

    const contents = try std.fs.cwd().readFileAlloc(allocator, header_path, std.math.maxInt(usize));
    const expected_opt: ?[]const u8 = blk: {
        const expected = std.fs.cwd().readFileAlloc(allocator, path_final, std.math.maxInt(usize)) catch |e| switch (e) {
            error.FileNotFound => {
                std.debug.print("[WARN] Expected file for '{s}.{s}' not found.\n", .{test_name, tag});
                break :blk null;
            },
            else => return e,
        };

        break :blk expected;
    };

    // TODO: #includes for the original file are broken; need to resolve them to absolute paths.
    const ir = try ir_mod.processBytes(allocator, ir_mod.ROOT_FILE, contents, &.{ir_mod.ROOT_FILE}, &.{});
    try writers.writeToFile(allocator, ir, writer, expected_path_temp_root);

    const output = try std.fs.cwd().readFileAlloc(allocator, expected_path_temp, std.math.maxInt(usize));
    blk: {
        if (expected_opt) |expected| if (std.mem.eql(u8, output, expected)) {
            std.debug.print("[PASS] Test '{s}.{s}' matches.\n", .{test_name, tag});
            break :blk;
        };
        std.debug.print("[FAIL] Test '{s}.{s}' failed.\n", .{test_name, tag});

        const out = try std.process.Child.run(.{
            .allocator = allocator,
            .argv = &.{ "git", "diff", "--no-index", "--color=always", path_final, expected_path_temp },
        });
        std.debug.print("{s}       Please update '{s}' if this is correct.\n", .{ out.stdout, path_final });
    }
}
