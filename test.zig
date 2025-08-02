// Compiles with `zig build-exe test.zig -limgui.h.cpp -L. imgui/*.cpp -lc++`

const std = @import("std");
const imgui = @import("imgui.h.zig");

const print = std.debug.print;

pub fn main() void {
    _ = imgui.ImGui_CreateContext(null) orelse @panic("Failed to create an ImGuiContext!");

    print("{}\n", .{@sizeOf(imgui.ImGuiIO)});

    const io = imgui.ImGui_GetIO() orelse @panic("Failed to get IO!");
    io.DisplaySize.x = 1920;
    io.DisplaySize.y = 1080;
    io.BackendFlags |= @intFromEnum(imgui.ImGuiBackendFlags_.ImGuiBackendFlags_RendererHasTextures);

    // var f: f32 = 0;
    for (0..20) |n| {
        print("NewFrame() {}\n", .{n});
        imgui.ImGui_NewFrame();

        imgui.ImGui_Text(@ptrCast(@constCast("Hello, World!")));
        // _ = Raw.ImGui_SliderFloat("float", &f, 0.0, 1.0, null, 0);
        // Raw.ImGui_Text(
        //     "Application average %.3f ms/frame (%.1f FPS)",
        //     1000.0 / io.DeltaTime,
        //     1.0 / io.DeltaTime,
        // );

        imgui.ImGui_Render();
    }

    print("DestroyContext()\n", .{});
    imgui.ImGui_DestroyContext(null);
}