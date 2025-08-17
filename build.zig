const std = @import("std");

pub fn build(b: *std.Build) void {
    // -- Options -- //

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const path_to_llvm = b.option([]const u8, "llvm", "Path to LLVM installation [default: $LLVM_PATH]") orelse
        (std.process.getEnvVarOwned(b.allocator, "LLVM_PATH") catch @panic("Neither -Dllvm nor $LLVM_PATH was specified!"));

    // -- Module -- //

    const mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = target.result.os.tag != .windows,
        .link_libcpp = target.result.os.tag == .windows,
    });

    // Link LLVM

    mod.addLibraryPath(.{ .cwd_relative = b.pathJoin(&.{ path_to_llvm, "lib" }) });
    mod.addIncludePath(.{ .cwd_relative = b.pathJoin(&.{ path_to_llvm, "include" }) });
    mod.linkSystemLibrary("libclang", .{});

    // -- Executable -- //

    const exe = b.addExecutable(.{
        .name = "zpp",
        .root_module = mod,
    });
    b.installArtifact(exe);

    // Running

    const run = b.addRunArtifact(exe);
    const run_step = b.step("run", "Runs the generator, forwarding the supplied CLI arguments");
    run_step.dependOn(&run.step);

    if (b.args) |args| run.addArgs(args);

    // -- Testing -- //

    // Unit Tests

    const unit_tests = b.addTest(.{.root_module = mod});
    const run_unit_tests = b.addRunArtifact(unit_tests);
    const unit_tests_step = b.step("test", "Run unit tests");
    unit_tests_step.dependOn(&run_unit_tests.step);

    // Integration Test(s)

    const run_supported_gen = b.addRunArtifact(exe);
    run_supported_gen.addFileArg(b.path("src/embed/testing/supported.hpp"));
    run_supported_gen.addArg("-x");
    run_supported_gen.addArg("-std=c++17");

    const supported_test_mod = b.createModule(.{
        .root_source_file = b.path("src/embed/testing/supported.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = target.result.os.tag != .windows,
        .link_libcpp = target.result.os.tag == .windows,
    });

    supported_test_mod.addIncludePath(b.path("src/embed/testing"));
    supported_test_mod.addCSourceFile(.{ .file = b.path("zpp-out/supported.hpp/supported.hpp.cpp"), .language = .cpp });

    supported_test_mod.addAnonymousImport("zpp-bindings", .{
        .root_source_file = b.path("zpp-out/supported.hpp/supported.hpp.zig"),
        .target = target,
        .optimize = optimize,
    });

    const supported_test_exe = b.addExecutable(.{
        .name = "supported-test",
        .root_module = supported_test_mod,
    });
    supported_test_exe.step.dependOn(&run_supported_gen.step);
    const run_supported_test = b.addRunArtifact(supported_test_exe);

    const run_supported_test_step = b.step("test-support", "Runs the supported features integration test");
    run_supported_test_step.dependOn(&run_supported_test.step);
}
