const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const imgui_mod = b.createModule(.{
        .root_source_file = b.path("zpp-out/imgui.h/imgui.h.zig"),
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
    });

    imgui_mod.addCSourceFile(.{ .file = b.path("zpp-out/imgui.h/imgui.h.cpp") });

    imgui_mod.linkSystemLibrary("SDL3", .{});

    imgui_mod.addIncludePath(b.path("imgui/"));
    imgui_mod.addCSourceFiles(.{
        .root = b.path("imgui/"),
        .files = &.{
            "imgui.cpp",
            "imgui_demo.cpp",
            "imgui_draw.cpp",
            "imgui_impl_sdl3.cpp",
            "imgui_impl_sdlgpu3.cpp",
            "imgui_tables.cpp",
            "imgui_widgets.cpp",
        },
    });

    mod.addImport("imgui", imgui_mod);

    const exe = b.addExecutable(.{
        .name = "imgui_sdl3_gpu_test",
        .root_module = mod,
    });
    b.installArtifact(exe);

    const run = b.addRunArtifact(exe);
    if (b.args) |args| run.addArgs(args);

    const run_step = b.step("run", "runs the example");
    run_step.dependOn(&run.step);
}
