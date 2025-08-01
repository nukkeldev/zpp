// Compiles with `zig build-exe test.zig -limgui.h.cpp -L. imgui/*.cpp -lc++`

const std = @import("std");

const print = std.debug.print;

extern fn ImGui_CreateContext(shared_font_atlas: ?*anyopaque) callconv(.c) void;
extern fn ImGui_DestroyContext(ctx: ?*anyopaque) callconv(.c) void;

extern fn ImGui_GetIO() ?*anyopaque;

extern fn ImGui_NewFrame() callconv(.c) void;
extern fn ImGui_Render() callconv(.c) void;

extern fn ImGui_Text(fmt: [*c]const u8, ...) callconv(.c) void;

const ImGuiIO = extern struct {
    __pad0: [1]c_int,
    BackendFlags: c_int,
    DisplaySize_x: f32,
    DisplaySize_y: f32,
    __pad1: [2984]u8,
};

pub fn main() void {
    ImGui_CreateContext(null);

    const io = ImGui_GetIO(); // 3000 bytes
    const io_f: *ImGuiIO = @ptrCast(@alignCast(io));
    io_f.DisplaySize_x = 1920;
    io_f.DisplaySize_y = 1080;
    io_f.BackendFlags |= 1 << 4;

    // var f: f32 = 0;
    for (0..20) |n| {
        print("NewFrame() {}\n", .{n});
        ImGui_NewFrame();

        ImGui_Text("Hello, World!");
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