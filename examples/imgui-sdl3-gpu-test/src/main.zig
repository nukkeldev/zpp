const std = @import("std");
const imgui = @import("imgui");

const c = @cImport({
    @cDefine("SDL_DISABLE_OLD_NAMES", {});
    @cInclude("SDL3/SDL.h");
});

const ImGui = imgui.ImGui;

pub fn main() void {
    // Setup SDL
    if (!c.SDL_Init(c.SDL_INIT_VIDEO | c.SDL_INIT_GAMEPAD)) {
        std.debug.print("Error: SDL_Init(): {s}\n", .{c.SDL_GetError()});
        std.process.exit(1);
    }
    defer c.SDL_Quit();

    // Create SDL window graphics context
    const main_scale = c.SDL_GetDisplayContentScale(c.SDL_GetPrimaryDisplay());
    const window_flags: u64 = c.SDL_WINDOW_RESIZABLE | c.SDL_WINDOW_HIDDEN | c.SDL_WINDOW_HIGH_PIXEL_DENSITY;
    const window = c.SDL_CreateWindow(
        "Dear ImGui SDL3+SDL_GPU example",
        @intFromFloat(1280.0 * main_scale),
        @intFromFloat(720.0 * main_scale),
        window_flags,
    ) orelse {
        std.debug.print("Error: SDL_CreateWindow(): {s}\n", .{c.SDL_GetError()});
        std.process.exit(1);
    };
    defer c.SDL_DestroyWindow(window);

    _ = c.SDL_SetWindowPosition(window, c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED);
    _ = c.SDL_ShowWindow(window);

    // Create GPU Device
    const gpu_device = c.SDL_CreateGPUDevice(
        c.SDL_GPU_SHADERFORMAT_SPIRV | c.SDL_GPU_SHADERFORMAT_DXIL | c.SDL_GPU_SHADERFORMAT_METALLIB,
        true,
        null,
    ) orelse {
        std.debug.print("Error: SDL_CreateGPUDevice(): {s}\n", .{c.SDL_GetError()});
        std.process.exit(1);
    };
    defer c.SDL_DestroyGPUDevice(gpu_device);

    // Claim window for GPU Device
    if (!c.SDL_ClaimWindowForGPUDevice(gpu_device, window)) {
        std.debug.print("Error: SDL_ClaimWindowForGPUDevice(): {s}\n", .{c.SDL_GetError()});
        std.process.exit(1);
    }
    defer c.SDL_ReleaseWindowFromGPUDevice(gpu_device, window);
    _ = c.SDL_SetGPUSwapchainParameters(gpu_device, window, c.SDL_GPU_SWAPCHAINCOMPOSITION_SDR, c.SDL_GPU_PRESENTMODE_VSYNC);

    // Setup Dear ImGui context
    _ = ImGui.CreateContext(null);
    defer ImGui.DestroyContext(null);

    const io = ImGui.GetIO();
    io.ConfigFlags |= imgui.ImGuiConfigFlags_.ImGuiConfigFlags_NavEnableKeyboard.data;
    io.ConfigFlags |= imgui.ImGuiConfigFlags_.ImGuiConfigFlags_NavEnableGamepad.data;

    // Setup Dear ImGui style
    ImGui.StyleColorsDark(null);

    // Setup scaling
    const style = ImGui.GetStyle();
    style.ScaleAllSizes(main_scale);

    // Setup Platform/Renderer backends
    _ = imgui.ImGui_ImplSDL3_InitForSDLGPU(@ptrCast(@alignCast(window)));
    defer imgui.ImGui_ImplSDL3_Shutdown();

    var init_info: imgui.ImGui_ImplSDLGPU3_InitInfo = .{
        .Device = @ptrCast(@alignCast(gpu_device)),
        .ColorTargetFormat = @bitCast(c.SDL_GetGPUSwapchainTextureFormat(gpu_device, window)),
        .MSAASamples = @bitCast(c.SDL_GPU_SAMPLECOUNT_1),
        .SwapchainComposition = @bitCast(c.SDL_GPU_SWAPCHAINCOMPOSITION_SDR),
        .PresentMode = @bitCast(c.SDL_GPU_PRESENTMODE_VSYNC),
    };
    _ = imgui.ImGui_ImplSDLGPU3_Init(&init_info);
    defer imgui.ImGui_ImplSDLGPU3_Shutdown();

    // Our state
    var show_demo_window = true;

    var show_another_window = false;
    var f: f32 = 0;
    var counter: i32 = 0;

    var clear_color: imgui.ImVec4 = .{
        .x = 0.45,
        .y = 0.55,
        .z = 0.60,
        .w = 1.00,
    };

    // Main loop
    var done = false;
    while (!done) {
        // Poll and handle events (inputs, window resize, etc.)
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event)) {
            _ = imgui.ImGui_ImplSDL3_ProcessEvent(@ptrCast(&event));
            if (event.type == c.SDL_EVENT_QUIT) done = true;
            if (event.type == c.SDL_EVENT_WINDOW_CLOSE_REQUESTED and event.window.windowID == c.SDL_GetWindowID(window))
                done = true;
        }

        if (c.SDL_GetWindowFlags(window) & c.SDL_WINDOW_MINIMIZED != 0) {
            c.SDL_Delay(10);
            continue;
        }

        // Start the Dear ImGui frame
        imgui.ImGui_ImplSDLGPU3_NewFrame();
        imgui.ImGui_ImplSDL3_NewFrame();
        ImGui.NewFrame();

        // 1. Show the big demo window (Most of the sample code is in ImGui::ShowDemoWindow()! You can browse its code to learn more about Dear ImGui!).
        if (show_demo_window)
            ImGui.ShowDemoWindow(&show_demo_window);

        // 2. Show a simple window that we create ourselves. We use a Begin/End pair to create a named window.
        {
            _ = ImGui.Begin("Hello, world!", null, 0); // Create a window called "Hello, world!" and append into it.
            defer ImGui.End();

            ImGui.Text("This is some useful text."); // Display some text (you can use a format strings too)
            _ = ImGui.Checkbox("Demo Window", &show_demo_window); // Edit bools storing our window open/close state
            _ = ImGui.Checkbox("Another Window", &show_another_window);

            _ = ImGui.SliderFloat("float", &f, 0, 1, "%.3f", 0); // Edit 1 float using a slider from 0.0f to 1.0f
            _ = ImGui.ColorEdit3("clear color", @ptrCast(&clear_color.x), 0); // Edit 3 floats representing a color

            if (ImGui.Button("Button", &.{ .x = 0, .y = 0 })) // Buttons return true when clicked (most widgets return true when edited/activated)
                counter += 1;
            ImGui.SameLine(0, -1);
            ImGui.Text("counter = %d", counter);

            ImGui.Text("Application average %.3f ms/frame (%.1f FPS)", 1000 / io.Framerate, io.Framerate);
        }

        // 3. Show another simple window.
        if (show_another_window) {
            _ = ImGui.Begin("Another Window", &show_another_window, 0); // Pass a pointer to our bool variable (the window will have a closing button that will clear the bool when clicked)
            defer ImGui.End();

            ImGui.Text("Hello from another window!");
            if (ImGui.Button("Close Me", &.{ .x = 0, .y = 0 }))
                show_another_window = false;
        }

        // Rendering
        ImGui.Render();
        const draw_data = ImGui.GetDrawData();
        const is_minimized = (draw_data[0].DisplaySize.x <= 0 or draw_data[0].DisplaySize.y <= 0);

        const command_buffer = c.SDL_AcquireGPUCommandBuffer(gpu_device);

        var swapchain_texture: ?*c.SDL_GPUTexture = undefined;
        _ = c.SDL_WaitAndAcquireGPUSwapchainTexture(command_buffer, window, &swapchain_texture, null, null);

        if (swapchain_texture != null and !is_minimized) {
            // This is mandatory: call ImGui_ImplSDLGPU3_PrepareDrawData() to upload the vertex/index buffer!
            imgui.ImGui_ImplSDLGPU3_PrepareDrawData(draw_data, @ptrCast(@alignCast(command_buffer)));

            // Setup and start a render pass
            const target_info: c.SDL_GPUColorTargetInfo = .{
                .texture = swapchain_texture,
                .clear_color = c.SDL_FColor{
                    .r = clear_color.x,
                    .g = clear_color.y,
                    .b = clear_color.z,
                    .a = clear_color.w,
                },
                .load_op = c.SDL_GPU_LOADOP_CLEAR,
                .store_op = c.SDL_GPU_STOREOP_STORE,
                .mip_level = 0,
                .layer_or_depth_plane = 0,
                .cycle = false,
            };
            const render_pass = c.SDL_BeginGPURenderPass(command_buffer, &target_info, 1, null);
            defer c.SDL_EndGPURenderPass(render_pass);

            // Render ImGui
            imgui.ImGui_ImplSDLGPU3_RenderDrawData(draw_data, @ptrCast(@alignCast(command_buffer)), @ptrCast(@alignCast(render_pass)), null);
        }

        // Submit the command buffer
        _ = c.SDL_SubmitGPUCommandBuffer(command_buffer);
    }
}
