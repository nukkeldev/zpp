const std = @import("std");
const imgui = @import("imgui");

const ImGui = imgui.ImGui;

pub fn main() void {
    example_null();
}

pub fn example_null() void {
    _ = ImGui.CreateContext(null);
    const io = ImGui.GetIO();

    io.BackendFlags |= imgui.ImGuiBackendFlags_.ImGuiBackendFlags_RendererHasTextures.data;
    io.DisplaySize = .{ .x = 1920, .y = 1080 };
    io.DeltaTime = 1.0 / 60.0;

    var f: f32 = 0;
    for (0..20) |n| {
        std.debug.print("NewFrame() {}\n", .{n});
        
        ImGui.NewFrame();
        defer ImGui.Render();
    
        ImGui.Text(@ptrCast("Hello, world!"));
        _ = ImGui.SliderFloat(@ptrCast("float"), &f, 0, 1, @ptrCast("%.3f"), 0);
        ImGui.Text(@ptrCast("Application average %.3f ms/frame (%.1f FPS)"), 1000.0 / io.Framerate, io.Framerate);
        ImGui.ShowDemoWindow(null);
    }

    std.debug.print("DestroyContext()\n", .{});
    ImGui.DestroyContext(null);
}