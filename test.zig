const std = @import("std");
const imgui = @import("zpp-out/imgui.h/imgui.h.zig");
const verify = @import("zpp-out/imgui.h/verify_imgui.h.zig");

const print = std.debug.print;

pub fn main() void {
    if (!verify.verifyABI()) {
        print("\n", .{});
        _ = verify.verifyAll();
    }

    _ = imgui.ZPP_ImGui_CreateContext(null) orelse @panic("Failed to create an ImGuiContext!");

    const io = imgui.ZPP_ImGui_GetIO() orelse @panic("Failed to get IO!");
    io.DisplaySize.x = 1920;
    io.DisplaySize.y = 1080;
    io.BackendFlags |= imgui.ImGuiBackendFlags_.ImGuiBackendFlags_RendererHasTextures;

    // var f: f32 = 0;
    for (0..20) |n| {
        print("NewFrame() {}\n", .{n});
        imgui.ZPP_ImGui_NewFrame();

        imgui.ZPP_ImGui_Text(@ptrCast(@constCast("Hello, World!")));
        // _ = Raw.ImGui_SliderFloat("float", &f, 0.0, 1.0, null, 0);
        // Raw.ImGui_Text(
        //     "Application average %.3f ms/frame (%.1f FPS)",
        //     1000.0 / io.DeltaTime,
        //     1.0 / io.DeltaTime,
        // );

        imgui.ZPP_ImGui_Render();
    }

    print("DestroyContext()\n", .{});
    imgui.ZPP_ImGui_DestroyContext(null);
}