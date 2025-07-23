const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const path_to_llvm = b.option([]const u8, "llvm", "Path to LLVM installation [default: $LLVM_PATH]") orelse
        (std.process.getEnvVarOwned(b.allocator, "LLVM_PATH") catch @panic("Neither -Dllvm nor $LLVM_PATH was specified!"));

    const mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = target.result.os.tag != .windows,
        .link_libcpp = target.result.os.tag == .windows,
    });

    mod.addLibraryPath(.{ .cwd_relative = b.pathJoin(&.{ path_to_llvm, "lib" }) });
    mod.addIncludePath(.{ .cwd_relative = b.pathJoin(&.{ path_to_llvm, "include" }) });

    if (target.result.os.tag == .windows) {
        mod.addObjectFile(.{ .cwd_relative = b.pathJoin(&.{ path_to_llvm, "bin/libclang.dll" }) });
    } else {
        // TODO: Why doesn't this look for `libclang.dll` or `libclang.lib` on Windows?
        mod.linkSystemLibrary("clang", .{ .preferred_link_mode = .dynamic });
    }

    const exe = b.addExecutable(.{
        .name = "generator",
        .root_module = mod,
    });
    b.installArtifact(exe);

    const run = b.addRunArtifact(exe);
    const run_step = b.step("run", "Runs");
    run_step.dependOn(&run.step);

    if (b.args) |args| run.addArgs(args);
}
