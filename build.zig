const std = @import("std");

pub fn build(b: *std.Build) void {
    // -- Options -- //

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const enable_tracy = b.option(bool, "tracy", "enables tracy") orelse false;
    const enable_tracy_callstack = b.option(bool, "tracy-callstack", "enables tracy's callstack") orelse false;

    const options = b.addOptions();
    options.addOption(bool, "enable_tracy", enable_tracy);
    options.addOption(bool, "enable_tracy_callstack", enable_tracy and enable_tracy_callstack);

    // -- Module -- //

    const mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        // TODO: I have zero clue why I originally did this.
        .link_libc = target.result.os.tag != .windows,
        .link_libcpp = target.result.os.tag == .windows,
    });

    mod.addImport("build-opts", options.createModule());

    if (target.result.os.tag == .windows) {
        const path_to_llvm = b.option([]const u8, "llvm", "Path to LLVM installation [default: $LLVM_PATH]") orelse
            (std.process.getEnvVarOwned(b.allocator, "LLVM_PATH") catch @panic("Neither -Dllvm nor $LLVM_PATH was specified!"));
        mod.addLibraryPath(.{ .cwd_relative = b.pathJoin(&.{ path_to_llvm, "lib" }) });
        mod.addIncludePath(.{ .cwd_relative = b.pathJoin(&.{ path_to_llvm, "include" }) });
        mod.linkSystemLibrary("libclang", .{});
    } else {
        mod.linkSystemLibrary("clang", .{});
    }

    if (enable_tracy) {
        const src = b.dependency("tracy", .{}).path(".");
        const tracy_mod = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libcpp = true,
        });

        tracy_mod.addCMacro("TRACY_ENABLE", "");
        tracy_mod.addIncludePath(src.path(b, "public"));
        tracy_mod.addCSourceFile(.{ .file = src.path(b, "public/TracyClient.cpp") });

        if (target.result.os.tag == .windows) {
            tracy_mod.linkSystemLibrary("dbghelp", .{ .needed = true });
            tracy_mod.linkSystemLibrary("ws2_32", .{ .needed = true });
        }

        const tracy_lib = b.addLibrary(.{
            .name = "tracy",
            .root_module = tracy_mod,
            .linkage = .static,
        });
        tracy_lib.installHeadersDirectory(src.path(b, "public"), "", .{ .include_extensions = &.{".h"} });

        mod.linkLibrary(tracy_lib);
    }

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

    const unit_tests = b.addTest(.{ .root_module = mod });
    const run_unit_tests = b.addRunArtifact(unit_tests);
    const unit_tests_step = b.step("test", "Run unit tests");
    unit_tests_step.dependOn(&run_unit_tests.step);

    // Integration Test(s)

    // const run_supported_gen = b.addRunArtifact(exe);
    // run_supported_gen.addFileArg(b.path("src/embed/testing/supported.hpp"));
    // run_supported_gen.addArg("-x");
    // run_supported_gen.addArg("-std=c++17");

    // const supported_test_mod = b.createModule(.{
    //     .root_source_file = b.path("src/embed/testing/supported.zig"),
    //     .target = target,
    //     .optimize = optimize,
    //     // .link_libcpp = true,
    //     .link_libc = true,
    // });

    // supported_test_mod.addIncludePath(b.path("src/embed/testing"));
    // supported_test_mod.addCSourceFile(.{ .file = b.path("zpp-out/supported.hpp/supported.hpp.cpp"), .language = .cpp });

    // supported_test_mod.addAnonymousImport("zpp-bindings", .{
    //     .root_source_file = b.path("zpp-out/supported.hpp/supported.hpp.zig"),
    //     .target = target,
    //     .optimize = optimize,
    // });

    // const supported_test_exe = b.addExecutable(.{
    //     .name = "supported-test",
    //     .root_module = supported_test_mod,
    // });
    // supported_test_exe.step.dependOn(&run_supported_gen.step);
    // const run_supported_test = b.addRunArtifact(supported_test_exe);

    // const run_supported_test_step = b.step("test-support", "Runs the supported features integration test");
    // run_supported_test_step.dependOn(&run_supported_test.step);
}
