//! See README for details.

// -- Imports -- //

const std = @import("std");

const Reader = @import("Reader.zig");
const Writer = @import("Writer.zig");
const Verification = @import("Verification.zig");
const IR = @import("ir/IR.zig");

// -- Main -- //

const Args = struct {
    /// The path to the C++ header.
    header_path: [:0]const u8,
    /// Any additional arguments to pass to `clang`.
    clang_args: []const [:0]const u8 = &.{},

    /// Whether to additionally produce ABI verification files.
    verify: bool = true,
    /// Whether to compile each file after producing them.
    compile: bool = true,

    fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        allocator.free(self.header_path);
        for (self.clang_args) |arg| allocator.free(arg);
        allocator.free(self.clang_args);
    }

    fn filename(self: *const @This()) []const u8 {
        return std.fs.path.basename(self.header_path);
    }

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        try writer.print("Args {{\n\theader: {s},\n\targs: [", .{self.header_path});
        if (self.clang_args.len > 0) {
            try writer.print("\n", .{});
            for (self.clang_args) |arg| try writer.print("\t\t\"{s}\",\n", .{arg});
            try writer.print("\t", .{});
        }
        try writer.print("],\n", .{});
        try writer.print("\tverify: {},\n\tcompile: {},\n}}", .{ self.verify, self.compile });
    }
};

fn processArgs(allocator: std.mem.Allocator) !Args {
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len < 2) printUsageAndExit();

    var out: Args = .{ .header_path = try allocator.dupeZ(u8, args[1]), };
    std.fs.cwd().access(args[1], .{}) catch |e|
        printUsageWithErrorAndExit("Accessing <header-path> '{s}' errored with {}!", .{ args[1], e });

    var clang_args = std.ArrayList([:0]const u8).init(allocator);

    var i: usize = 2;
    while (i < args.len) : (i += 1) {
        if (args[i].len < 2 or args[i][0] != '-') continue;

        if (args[i][1] == 'x' or std.mem.eql(u8, args[i], "--clang-arg")) {
            i += 1;
            if (i == args.len) printUsageWithErrorAndExit("-x/--clang-arg requires a subsequent argument!", .{});
            try clang_args.append(try allocator.dupeZ(u8, args[i]));
        } else if (std.mem.eql(u8, args[i], "-nv") or std.mem.eql(u8, args[i], "--no-verify")) {
            out.verify = false;
        } else if (std.mem.eql(u8, args[i], "-nc") or std.mem.eql(u8, args[i], "--no-compile")) {
            out.compile = false;
        } else printUsageWithErrorAndExit("Unknown argument '{s}'!", .{args[i]});
    }

    if (clang_args.items.len > 0) out.clang_args = try clang_args.toOwnedSlice();

    return out;
}

pub fn main() !void {
    const allocator = std.heap.smp_allocator;

    const args = try processArgs(allocator);
    defer args.deinit(allocator);

    std.log.info("Invoking `zpp` with arguments: {f}", .{args});
    
    const reader = try Reader.parseFile(allocator, args.header_path, args.clang_args, .{ .verbose = true });
    defer reader.arena.deinit();

    const out_path = try std.fmt.allocPrint(allocator, "zpp-out/{s}/", .{args.filename()});
    defer allocator.free(out_path);

    std.fs.cwd().deleteTree(out_path) catch {};
    try std.fs.cwd().makePath(out_path);

    var writer = try Writer.init(allocator, reader.ast, args.filename(), .Cpp);
    defer writer.deinit();

    try writer.writeToFile(out_path);
    if (args.compile) try writer.compileLastFile(std.fs.path.dirname(args.header_path) orelse "", out_path, args.clang_args);
    
    writer.resetForLanguage(.Zig);
    
    try writer.writeToFile(out_path);
    if (args.compile) try writer.compileLastFile(std.fs.path.dirname(args.header_path) orelse "", out_path, args.clang_args);

    // TODO: Update this to match Writer above; preferably integrate the two.
    if (!args.verify) return;

    var verif = Verification{
        .allocator = allocator,
        .ast = reader.ast,
        .language = .Cpp,
        .source_filename = args.filename(),
    };

    {
        const file_path: []const u8 = try std.mem.concat(allocator, u8, &.{ out_path, "verify_", args.filename(), ".cpp" });
        var file = try std.fs.cwd().createFile(file_path, .{});
        defer file.close();

        var io_writer = file.writer(&.{});
        try verif.format(&io_writer.interface);

        std.log.info("Wrote C++ verification!", .{});
    }

    verif.language = .Zig;

    {
        const file_path: []const u8 = try std.mem.concat(allocator, u8, &.{ out_path, "verify_", args.filename(), ".zig" });
        var file = try std.fs.cwd().createFile(file_path, .{});
        defer file.close();

        var io_writer = file.writer(&.{});
        try verif.format(&io_writer.interface);

        std.log.info("Wrote Zig verification bindings!", .{});
    }
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
    \\    -nv, --no-verify    Disables producing ABI verification files.
    \\    -nc, --no-compile   Disables compiling each file after producing them.  
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