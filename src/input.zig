const std = @import("std");

const tracy = @import("util/tracy.zig");
const writers = @import("writers.zig");

const Timer = @import("util/timer.zig").Timer;

/// An input to `zpp`'s generation.
pub const Input = struct {
    /// An overall name for the resultant bindings.
    name: []const u8,
    /// Where to output the bindings.
    /// Sources will be output in their own folders corresponding to their names with sub-folders
    /// for files further.
    output: []const u8 = "zpp-out/",
    /// Sources for the bindings.
    sources: []const Source,

    pub const Source = struct {
        /// A name for this source. Will be used to namespace the bindings.
        name: []const u8,
        /// A url that `zig fetch` can ingest and resolve into a hash.
        url: ?[]const u8 = null,
        /// An absolute or relative path to the dependencies folder.
        path: ?[]const u8 = null,
        /// A (currently unused) hash corresponding to `zig fetch`'s output.
        hash: ?[]const u8 = null,
        /// Headers to generate bindings for.
        files: []const [:0]const u8,
        /// Configuration for the generation process.
        config: Config = .{},
        /// An optional compilation process for the source files (to a reasonable simplicity).
        compilation: ?Compilation = null,

        pub const Config = struct {
            /// Raw arguments to pass to libclang.
            clang_args: []const [:0]const u8 = &.{},
            /// A list of _additional_ directories to include headers from.
            headers: []const []const u8 = &.{},
        };

        /// A simple compilation process for the library.
        /// `config` properties apply here as well.
        pub const Compilation = struct {
            /// C++ files to compile.
            files: []const []const u8,
        };

        pub fn processFiles(source: *const Source, allocator: std.mem.Allocator, output: []const u8) !void {
            var fz = tracy.FnZone.init(@src(), "Input.Source.processFiles");
            defer fz.end();
            const logger = std.log.scoped(.@"Input.Source.processFiles");

            if ((source.path != null and source.url != null) or (source.path == null and source.url == null)) {
                logger.err("Cannot process source with both or neither of url and path set!", .{});
                return error.InvalidSource;
            }

            const source_path = if (source.path) |path| path else blk: {
                const username = try std.process.getEnvVarOwned(allocator, "USER");
                const global_cache_dir = switch (@import("builtin").os.tag) {
                    .linux => try std.fmt.allocPrint(allocator, "/home/{s}/.cache/zig", .{username}),
                    else => @panic("OS not yet supported!"),
                };

                const hash = source.hash orelse blk2: {
                    const url = source.url.?;
                    const fetch = try std.process.Child.run(.{
                        .allocator = allocator,
                        .argv = &.{ "zig", "fetch", url },
                    });

                    switch (fetch.term) {
                        .Exited => |c| if (c == 0) {
                            break :blk2 std.mem.trim(u8, fetch.stdout, &std.ascii.whitespace);
                        } else {
                            logger.err("`zig fetch` failed! stderr:\n{s}", .{fetch.stderr});
                            return error.ZigFetch;
                        },
                        else => {
                            logger.err("TODO: `zig fetch` ended with a non-exit code! stderr:\n{s}", .{fetch.stderr});
                            return error.ZigFetch;
                        },
                    }
                };

                break :blk try std.fs.path.join(allocator, &.{ global_cache_dir, "p", hash });
            };
            logger.debug("Source path: {s}", .{source_path});

            // Apparently std.fs.cwd()'s fd updates as the CWD changes.
            const root_dir = try std.fs.cwd().openDir(".", .{});
            const source_dir = try std.fs.cwd().openDir(source_path, .{});

            var t1 = Timer(logger).init();
            var t2 = Timer(logger).init();
            for (source.files) |file| {
                fz.push(@src(), "file processing");
                defer fz.pop();

                var t3 = Timer(logger).init();

                logger.debug("Started processing of file '{s}'.", .{file});

                try source_dir.setAsCwd();
                logger.debug("cd'd to source dir", .{});

                const filename = std.fs.path.basename(file);
                const dirname = try std.fs.cwd().realpathAlloc(allocator, std.fs.path.dirname(file) orelse ".");

                const ir = try @import("ir.zig").processFile(allocator, source, file, source.config.clang_args);
                t3.lap("IR processing completed", .{});

                try root_dir.setAsCwd();
                logger.debug("cd'd back to root", .{});

                fz.replace(@src(), "output setup");
                const out_path = try std.fs.path.join(allocator, &.{
                    output,
                    source.name,
                    filename,
                });

                std.fs.cwd().deleteTree(out_path) catch {};
                try std.fs.cwd().makePath(out_path);

                const out_dir = try std.fs.cwd().openDir(out_path, .{});
                try out_dir.setAsCwd();
                logger.debug("Set CWD: {s}", .{try out_dir.realpathAlloc(allocator, ".")});

                fz.replace(@src(), "c++");
                try writers.writeToFile(allocator, &ir, writers.CppWrapper, filename);
                t3.lap("C++ wrote", .{});

                try writers.checkFile(allocator, writers.CppWrapper, filename, .{
                    .clang_args = source.config.clang_args,
                    .source_dir = dirname,
                });
                t3.lap("C++ checked", .{});

                fz.replace(@src(), "zig");
                try writers.writeToFile(allocator, &ir, writers.ZigWrapper, filename);
                t3.lap("Zig wrote", .{});

                try writers.checkFile(allocator, writers.ZigWrapper, filename, {});
                t3.lap("Zig checked", .{});
            }
            t2.lap("Processed files", .{});

            try root_dir.setAsCwd();

            {
                const out_path = try std.fs.path.join(allocator, &.{
                    output,
                    source.name,
                });
                const source_out_dir = try std.fs.cwd().openDir(out_path, .{});
                const source_lib_file = try source_out_dir.createFile("root.zig", .{});

                var buffer: [8192]u8 = undefined;
                @memset(&buffer, 0);

                var writer = source_lib_file.writer(&buffer);
                for (source.files) |file| {
                    try writer.interface.print("pub const @\"{s}\" = @import(\"{s}/{s}.zig\");\n", .{
                        file, file, file,
                    });
                }
                try writer.interface.flush();
            }
            t2.lap("Source 'root.zig' generated", .{});

            t1.lap("Source '{s}' processed", .{source.name});
        }
    };

    pub fn fromSlice(
        allocator: std.mem.Allocator,
        slice: [:0]const u8,
    ) !Input {
        var diagnostics: std.zon.parse.Diagnostics = .{};
        defer diagnostics.deinit(allocator);

        const input = std.zon.parse.fromSlice(
            Input,
            allocator,
            slice,
            &diagnostics,
            .{},
        ) catch |e| switch (e) {
            error.ParseZon => {
                var err_iter = diagnostics.iterateErrors();
                while (err_iter.next()) |err| {
                    std.log.err("Input Parsing Error: {f}", .{err.fmtMessage(&diagnostics)});
                }
                return e;
            },
            error.OutOfMemory => return e,
        };

        return input;
    }

    pub fn deinit(input: Input, allocator: std.mem.Allocator) void {
        std.zon.parse.free(allocator, input);
    }

    pub fn processSources(input: *const Input, allocator: std.mem.Allocator) !void {
        const root_cwd = try std.fs.cwd().openDir(".", .{});
        const output = try std.fs.path.join(allocator, &.{ input.output, input.name });

        for (input.sources) |source| {
            try source.processFiles(allocator, output);
            try root_cwd.setAsCwd();
        }

        {
            const out_dir = try std.fs.cwd().openDir(output, .{});
            const root_file = try out_dir.createFile("root.zig", .{});

            var buffer: [8192]u8 = undefined;
            @memset(&buffer, 0);

            var writer = root_file.writer(&buffer);
            for (input.sources) |source| {
                try writer.interface.print("pub const @\"{s}\" = @import(\"{s}/root.zig\");\n", .{
                    source.name, source.name,
                });
            }
            try writer.interface.flush();
        }
    }
};

test "parse input" {
    const input = try Input.fromSlice(std.testing.allocator, @embedFile("embed/default.zpp.zon"));
    defer input.deinit(std.testing.allocator);
}
