//! See README for details.

// -- Imports -- //

const std = @import("std");

const tracy = @import("util/tracy.zig");
const writers = @import("writers.zig");
const ir_mod = @import("ir.zig");

// -- Main -- //

const Args = struct {
    /// The path to the C++ header.
    header_paths: []const [:0]const u8,
    /// Any additional arguments to pass to `clang`.
    clang_args: []const [:0]const u8 = &.{},
    /// Whether to generate a sandbox for debugging purposes.
    generate_sandbox: bool = false,
    /// TODO: Whether to generate comptime ABI verification.
    generate_abi_verification: bool = true,

    fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        allocator.free(self.header_path);
        for (self.clang_args) |arg| allocator.free(arg);
        allocator.free(self.clang_args);
    }

    fn filename(self: *const @This()) []const u8 {
        // TODO: Actually use all of the paths.
        return std.fs.path.basename(self.header_paths[0]);
    }

    fn dirname(self: *const @This()) []const u8 {
        // TODO: Actually use all of the paths.
        return std.fs.path.dirname(self.header_paths[0]) orelse "";
    }

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        try writer.writeAll("Args {\n\theaders: [\n");
        for (self.header_paths) |path| try writer.print("\t\t\"{s}\",\n", .{path});
        try writer.writeAll("\t],\n\targs: [");

        if (self.clang_args.len > 0) {
            try writer.writeAll("\n");
            for (self.clang_args) |arg| try writer.print("\t\t\"{s}\",\n", .{arg});
            try writer.writeAll("\t");
        }
        try writer.writeAll("],\n}");
        // TODO
    }
};

fn processArgs(allocator: std.mem.Allocator) !Args {
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len < 2) printUsageAndExit();

    var out: Args = .{
        .header_paths = undefined,
    };

    var header_paths = std.array_list.Managed([:0]const u8).init(allocator);
    var clang_args = std.array_list.Managed([:0]const u8).init(allocator);

    var i: usize = 1;
    while (i < args.len) : (i += 1) {
        if (std.mem.eql(u8, args[i], "-x") or std.mem.eql(u8, args[i], "--clang-arg")) {
            i += 1;
            if (i == args.len) printUsageWithErrorAndExit("-x/--clang-arg requires a subsequent argument!", .{});
            try clang_args.append(try allocator.dupeZ(u8, args[i]));
        } else if (std.mem.eql(u8, args[i], "-s") or std.mem.eql(u8, args[i], "--sandbox")) {
            out.generate_sandbox = true;
        } else {
            const header_path = std.fs.cwd().realpathAlloc(allocator, args[i]) catch |e| switch (e) {
                error.FileNotFound => {
                    std.log.err("Could not find header path '{s}'! Are you sure you meant it to be a header path?", .{args[i]});
                    return e;
                },
                else => return e,
            };
            try header_paths.append(try allocator.dupeZ(u8, header_path));
        }
    }

    if (header_paths.items.len == 0) {
        printUsageWithErrorAndExit("At least one header path is required!", .{});
    }

    out.header_paths = try header_paths.toOwnedSlice();
    if (clang_args.items.len > 0) out.clang_args = try clang_args.toOwnedSlice();

    return out;
}

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

    const args = try processArgs(arena.allocator());
    std.log.debug("Invoking `zpp` with arguments: {f}", .{args});

    fz.replace(@src(), "ir parsing");
    const start = getNs();
    const ir = try ir_mod.processFiles(arena.allocator(), args.header_paths, args.clang_args);

    fz.replace(@src(), "output setup");
    const out_path = try std.fmt.allocPrint(arena.allocator(), "zpp-out/{s}/", .{args.filename()});

    std.fs.cwd().deleteTree(out_path) catch {};
    try std.fs.cwd().makePath(out_path);

    const out_dir = try std.fs.cwd().openDir(out_path, .{});
    try out_dir.setAsCwd();

    fz.replace(@src(), "c++");
    try writers.writeToFile(arena.allocator(), ir, writers.CppWrapper, args.filename());
    try writers.checkFile(arena.allocator(), writers.CppWrapper, args.filename(), .{
        .clang_args = args.clang_args,
        .source_dir = args.dirname(),
    });

    fz.replace(@src(), "zig");
    try writers.writeToFile(arena.allocator(), ir, writers.ZigWrapper, args.filename());
    try writers.checkFile(arena.allocator(), writers.ZigWrapper, args.filename(), {});

    if (args.generate_sandbox) {
        fz.replace(@src(), "copy sandbox");
        try std.fs.cwd().makePath("sandbox/src");

        var build = try std.mem.replaceOwned(u8, arena.allocator(), @embedFile("embed/sandbox/build.zig"), "FILENAME", args.filename());
        build = try std.mem.replaceOwned(u8, arena.allocator(), build, "ABSOLUTE_SOURCE_DIR", args.dirname());

        var cflags = std.array_list.Managed(u8).init(arena.allocator());
        for (args.clang_args) |arg| {
            try cflags.appendSlice("\n\t\"");
            try cflags.appendSlice(arg);
            try cflags.appendSlice("\",");
        }

        build = try std.mem.replaceOwned(u8, arena.allocator(), build, "\"CFLAGS\"", cflags.items);

        try std.fs.cwd().writeFile(.{ .sub_path = "sandbox/build.zig", .data = build });
        try std.fs.cwd().writeFile(.{ .sub_path = "sandbox/build.zig.zon", .data = @embedFile("embed/sandbox/build.zig.zon") });
        try std.fs.cwd().writeFile(.{ .sub_path = "sandbox/src/main.zig", .data = @embedFile("embed/sandbox/src/main.zig") });
    }

    std.log.info("Completed generation in {D}", .{getNs() - start});
    std.log.info("Outputs in '{s}'.", .{out_path});
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
    std.testing.refAllDeclsRecursive(ir_mod);
}
