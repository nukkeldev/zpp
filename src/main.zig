//! See README for details.

// -- Imports -- //

const std = @import("std");

const tracy = @import("util/tracy.zig");
const writers = @import("writers.zig");
const ir_mod = @import("ir.zig");
const input_mod = @import("input.zig");

// -- Main -- //

pub fn main() !void {
    var fz = tracy.FnZone.init(@src(), "main");
    defer fz.end();

    var debug_allocator = std.heap.DebugAllocator(.{}).init;
    defer _ = debug_allocator.deinit();

    const allocator = if (@import("builtin").mode == .Debug) debug_allocator.allocator() else std.heap.smp_allocator;
    var tracing_allocator = tracy.TracyAllocator(null).init(allocator);
    var arena = std.heap.ArenaAllocator.init(if (tracy.enable) tracing_allocator.allocator() else allocator);
    defer arena.deinit();

    fz.push(@src(), "arg parsing");

    var args = std.process.args();
    _ = args.skip();

    const path = try std.fs.cwd().realpathAlloc(arena.allocator(), args.next().?);
    if (std.fs.path.dirname(path)) |dir| {
        std.log.debug("Set root CWD: {s}", .{dir});

        const d = try std.fs.cwd().openDir(dir, .{});
        try d.setAsCwd();
    }

    const zon = try std.fs.cwd().readFileAllocOptions(
        arena.allocator(),
        std.fs.path.basename(path),
        std.math.maxInt(usize),
        null,
        .@"1",
        0,
    );
    const input = try input_mod.Input.fromSlice(arena.allocator(), zon);
    args.deinit();

    const start = getNs();
    try input.processSources(arena.allocator());

    // TODO: Write per source and per generation modules.

    std.log.info("Completed generation in {D}", .{getNs() - start});
}

fn getNs() i64 {
    return @truncate(std.time.nanoTimestamp());
}

// -- Usage -- //

const USAGE =
    \\Usage: zpp <header-path>+ [OPTIONS]
    \\Generates C-compatible header files from (a subset of) C++ headers. 
    \\
    \\Required Arguments:
    \\    <header-path>+      The paths to the C++ headers
    \\
    \\Optional Arguments:
    \\    -x,  --clang-arg    Passes the subsequent argument through to clang.
    \\    -s,  --sandbox      Enables the generation of a zig project to experiment with the results
    \\
;

fn printUsageWithErrorAndExit(comptime err: []const u8, args: anytype) noreturn {
    std.debug.print("ERROR: " ++ err ++ "\n", args);
    printUsageAndExit();
}

fn printUsageAndExit() noreturn {
    std.debug.print(USAGE, .{});
    std.process.exit(0);
}

// -- Tests -- //

comptime {
    // std.testing.refAllDeclsRecursive(ir_mod);
    std.testing.refAllDecls(@import("tests.zig"));
    std.testing.refAllDecls(@import("input.zig"));
}
