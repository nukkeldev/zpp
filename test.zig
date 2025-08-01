// Compiles with `zig build-exe test.zig -limgui.h.cpp -L. imgui/*.cpp -lc++`

const std = @import("std");

const print = std.debug.print;

extern fn ImGui_CreateContext(shared_font_atlas: ?*anyopaque) void;
extern fn ImGui_DestroyContext(ctx: ?*anyopaque) void;

extern fn ImGui_NewFrame() void;
extern fn ImGui_Render() void;

pub fn main() void {
    ImGui_CreateContext(null);

    // const io = Raw.ImGui_GetIO();
    // io.BackendFlags.ImGuiBackendFlags_RendererHasTextures = true;

    // var f: f32 = 0;
    for (0..20) |n| {
        print("NewFrame() {}\n", .{n});
        // io.DisplaySize = .{ .x = 1920, .y = 1080 };
        ImGui_NewFrame();

        // Raw.ImGui_Text("Hello, world!"); // NOTE: That 'w' should be capitalized :(
        // _ = Raw.ImGui_SliderFloat("float", &f, 0.0, 1.0, null, 0);
        // Raw.ImGui_Text(
        //     "Application average %.3f ms/frame (%.1f FPS)",
        //     1000.0 / io.DeltaTime,
        //     1.0 / io.DeltaTime,
        // );

        ImGui_Render();
    }

    print("DestroyContext()\n", .{});
    ImGui_DestroyContext(null);
}