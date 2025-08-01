// Compiles with `zig build-exe test.zig -limgui.h.cpp -L. imgui/*.cpp -lc++`

extern fn ImGui_CreateContext(shared_font_atlas: ?*void) void;

pub fn main() void {
    ImGui_CreateContext(null);
}