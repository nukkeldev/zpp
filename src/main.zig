//! See README for details.

// -- Imports -- //

const std = @import("std");
const writers = @import("writers.zig");

const IR = @import("ir/IR.zig");

// -- Main -- //

const Args = struct {
    /// The path to the C++ header.
    header_path: [:0]const u8,
    /// Any additional arguments to pass to `clang`.
    clang_args: []const [:0]const u8 = &.{},

    fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        allocator.free(self.header_path);
        for (self.clang_args) |arg| allocator.free(arg);
        allocator.free(self.clang_args);
    }

    fn filename(self: *const @This()) []const u8 {
        return std.fs.path.basename(self.header_path);
    }

    fn dirname(self: *const @This()) []const u8 {
        return std.fs.path.dirname(self.header_path) orelse "";
    }

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        try writer.print("Args {{\n\theader: {s},\n\targs: [", .{self.header_path});
        if (self.clang_args.len > 0) {
            try writer.print("\n", .{});
            for (self.clang_args) |arg| try writer.print("\t\t\"{s}\",\n", .{arg});
            try writer.print("\t", .{});
        }
        try writer.print("],\n}}", .{});
    }
};

fn processArgs(allocator: std.mem.Allocator) !Args {
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len < 2) printUsageAndExit();

    const header_path = try std.fs.cwd().realpathAlloc(allocator, args[1]);
    var out: Args = .{
        .header_path = try allocator.dupeZ(u8, header_path),
    };
    std.fs.cwd().access(header_path, .{}) catch |e|
        printUsageWithErrorAndExit("Accessing <header-path> '{s}' errored with {}!", .{ header_path, e });

    var clang_args = std.ArrayList([:0]const u8).init(allocator);

    var i: usize = 2;
    while (i < args.len) : (i += 1) {
        if (args[i].len < 2 or args[i][0] != '-') continue;

        if (args[i][1] == 'x' or std.mem.eql(u8, args[i], "--clang-arg")) {
            i += 1;
            if (i == args.len) printUsageWithErrorAndExit("-x/--clang-arg requires a subsequent argument!", .{});
            try clang_args.append(try allocator.dupeZ(u8, args[i]));
        } else printUsageWithErrorAndExit("Unknown argument '{s}'!", .{args[i]});
    }

    if (clang_args.items.len > 0) out.clang_args = try clang_args.toOwnedSlice();

    return out;
}

pub fn main() !void {
    var debug_allocator = std.heap.DebugAllocator(.{}).init;
    defer _ = debug_allocator.deinit();

    const allocator = if (@import("builtin").mode == .Debug) debug_allocator.allocator() else std.heap.smp_allocator;
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    const args = try processArgs(arena.allocator());
    std.log.info("Invoking `zpp` with arguments: {f}", .{args});

    var time: i64 = getNs();

    const ir = try IR.processFile(arena.allocator(), args.header_path, args.clang_args);

    std.log.info("IR: {D}", .{getNs() - time});
    time = getNs();

    const out_path = try std.fmt.allocPrint(arena.allocator(), "zpp-out/{s}/", .{args.filename()});

    std.fs.cwd().deleteTree(out_path) catch {};
    try std.fs.cwd().makePath(out_path);

    const out_dir = try std.fs.cwd().openDir(out_path, .{});
    try out_dir.setAsCwd();

    try ir.writeToFile();

    try writers.writeToFile(arena.allocator(), ir, writers.CppWrapper, args.filename());

    std.log.info("C++ Wrapper: {D}", .{getNs() - time});
    time = getNs();

    try writers.checkFile(arena.allocator(), writers.CppWrapper, args.filename(), .{
        .clang_args = args.clang_args,
        .source_dir = args.dirname(),
    });

    std.log.info("C++ Wrapper Check: {D}", .{getNs() - time});
    time = getNs();

    try writers.writeToFile(arena.allocator(), ir, writers.ZigWrapper, args.filename());

    std.log.info("Zig Wrapper: {D}", .{getNs() - time});
    time = getNs();

    try writers.checkFile(arena.allocator(), writers.ZigWrapper, args.filename(), {});

    std.log.info("Zig Wrapper Check: {D}", .{getNs() - time});
    time = getNs();
}

fn getNs() i64 {
    return @truncate(std.time.nanoTimestamp());
}

// -- Usage -- //

const USAGE =
    \\Usage: zpp <header-path> [OPTIONS]
    \\Generates C-compatible header files from (a subset of) C++ headers. 
    \\
    \\Required Arguments:
    \\    <header-path>       The path to the C++ header
    \\
    \\Optional Arguments:
    \\    -x,  --clang-arg    Passes the subsequent argument through to clang.
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
    std.testing.refAllDecls(IR);
}
