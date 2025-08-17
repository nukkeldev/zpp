const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    });

    mod.addIncludePath(.{ .cwd_relative = CPP_SOURCE_DIR });
    mod.addCSourceFiles(.{
        .root = .{ .cwd_relative = CPP_SOURCE_DIR },
        .files = &.{
            // TODO: Add C++ sources.
        },
        .flags = CFLAGS,
    });

    mod.addIncludePath(b.path("../"));
    mod.addCSourceFile(.{ .file = b.path("../FILENAME.cpp"), .language = .cpp });

    mod.addAnonymousImport("bindings", .{
        .root_source_file = b.path("../FILENAME.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "sandbox",
        .root_module = mod,
    });
    const run = b.addRunArtifact(exe);

    const run_step = b.step("run", "");
    run_step.dependOn(&run.step);
}

const CPP_SOURCE_DIR =
    \\ABSOLUTE_SOURCE_DIR
;

const CFLAGS = &.{"CFLAGS"
};