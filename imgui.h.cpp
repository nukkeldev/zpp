#include "imgui/imgui.h"

extern "C" {
ImGuiContext * ImGui_CreateContext(ImFontAtlas * shared_font_atlas) { return ::ImGui::CreateContext(shared_font_atlas);}
void ImGui_DestroyContext(ImGuiContext * ctx) { return ::ImGui::DestroyContext(ctx);}
ImGuiContext * ImGui_GetCurrentContext() { return ::ImGui::GetCurrentContext();}
void ImGui_SetCurrentContext(ImGuiContext * ctx) { return ::ImGui::SetCurrentContext(ctx);}
ImGuiIO & ImGui_GetIO() { return ::ImGui::GetIO();}
ImGuiPlatformIO & ImGui_GetPlatformIO() { return ::ImGui::GetPlatformIO();}
ImGuiStyle & ImGui_GetStyle() { return ::ImGui::GetStyle();}
void ImGui_NewFrame() { return ::ImGui::NewFrame();}
void ImGui_EndFrame() { return ::ImGui::EndFrame();}
void ImGui_Render() { return ::ImGui::Render();}
ImDrawData * ImGui_GetDrawData() { return ::ImGui::GetDrawData();}
void ImGui_ShowDemoWindow(bool * p_open) { return ::ImGui::ShowDemoWindow(p_open);}
void ImGui_ShowMetricsWindow(bool * p_open) { return ::ImGui::ShowMetricsWindow(p_open);}
void ImGui_ShowDebugLogWindow(bool * p_open) { return ::ImGui::ShowDebugLogWindow(p_open);}
void ImGui_ShowIDStackToolWindow(bool * p_open) { return ::ImGui::ShowIDStackToolWindow(p_open);}
void ImGui_ShowAboutWindow(bool * p_open) { return ::ImGui::ShowAboutWindow(p_open);}
void ImGui_ShowStyleEditor(ImGuiStyle * ref) { return ::ImGui::ShowStyleEditor(ref);}
bool ImGui_ShowStyleSelector(const char * label) { return ::ImGui::ShowStyleSelector(label);}
void ImGui_ShowFontSelector(const char * label) { return ::ImGui::ShowFontSelector(label);}
void ImGui_ShowUserGuide() { return ::ImGui::ShowUserGuide();}
const char * ImGui_GetVersion() { return ::ImGui::GetVersion();}
void ImGui_StyleColorsDark(ImGuiStyle * dst) { return ::ImGui::StyleColorsDark(dst);}
void ImGui_StyleColorsLight(ImGuiStyle * dst) { return ::ImGui::StyleColorsLight(dst);}
void ImGui_StyleColorsClassic(ImGuiStyle * dst) { return ::ImGui::StyleColorsClassic(dst);}
bool ImGui_Begin(const char * name, bool * p_open, ImGuiWindowFlags flags) { return ::ImGui::Begin(name, p_open, flags);}
void ImGui_End() { return ::ImGui::End();}
bool ImGui_BeginChild(const char * str_id, const ImVec2 & size, ImGuiChildFlags child_flags, ImGuiWindowFlags window_flags) { return ::ImGui::BeginChild(str_id, size, child_flags, window_flags);}
bool ImGui_BeginChild1(ImGuiID id, const ImVec2 & size, ImGuiChildFlags child_flags, ImGuiWindowFlags window_flags) { return ::ImGui::BeginChild(id, size, child_flags, window_flags);}
void ImGui_EndChild() { return ::ImGui::EndChild();}
bool ImGui_IsWindowAppearing() { return ::ImGui::IsWindowAppearing();}
bool ImGui_IsWindowCollapsed() { return ::ImGui::IsWindowCollapsed();}
bool ImGui_IsWindowFocused(ImGuiFocusedFlags flags) { return ::ImGui::IsWindowFocused(flags);}
bool ImGui_IsWindowHovered(ImGuiHoveredFlags flags) { return ::ImGui::IsWindowHovered(flags);}
ImDrawList * ImGui_GetWindowDrawList() { return ::ImGui::GetWindowDrawList();}
ImVec2 ImGui_GetWindowPos() { return ::ImGui::GetWindowPos();}
ImVec2 ImGui_GetWindowSize() { return ::ImGui::GetWindowSize();}
float ImGui_GetWindowWidth() { return ::ImGui::GetWindowWidth();}
float ImGui_GetWindowHeight() { return ::ImGui::GetWindowHeight();}
void ImGui_SetNextWindowPos(const ImVec2 & pos, ImGuiCond cond, const ImVec2 & pivot) { return ::ImGui::SetNextWindowPos(pos, cond, pivot);}
void ImGui_SetNextWindowSize(const ImVec2 & size, ImGuiCond cond) { return ::ImGui::SetNextWindowSize(size, cond);}
void ImGui_SetNextWindowSizeConstraints(const ImVec2 & size_min, const ImVec2 & size_max, ImGuiSizeCallback custom_callback, void * custom_callback_data) { return ::ImGui::SetNextWindowSizeConstraints(size_min, size_max, custom_callback, custom_callback_data);}
void ImGui_SetNextWindowContentSize(const ImVec2 & size) { return ::ImGui::SetNextWindowContentSize(size);}
void ImGui_SetNextWindowCollapsed(bool collapsed, ImGuiCond cond) { return ::ImGui::SetNextWindowCollapsed(collapsed, cond);}
void ImGui_SetNextWindowFocus() { return ::ImGui::SetNextWindowFocus();}
void ImGui_SetNextWindowScroll(const ImVec2 & scroll) { return ::ImGui::SetNextWindowScroll(scroll);}
void ImGui_SetNextWindowBgAlpha(float alpha) { return ::ImGui::SetNextWindowBgAlpha(alpha);}
void ImGui_SetWindowPos(const ImVec2 & pos, ImGuiCond cond) { return ::ImGui::SetWindowPos(pos, cond);}
void ImGui_SetWindowSize(const ImVec2 & size, ImGuiCond cond) { return ::ImGui::SetWindowSize(size, cond);}
void ImGui_SetWindowCollapsed(bool collapsed, ImGuiCond cond) { return ::ImGui::SetWindowCollapsed(collapsed, cond);}
void ImGui_SetWindowFocus() { return ::ImGui::SetWindowFocus();}
void ImGui_SetWindowPos1(const char * name, const ImVec2 & pos, ImGuiCond cond) { return ::ImGui::SetWindowPos(name, pos, cond);}
void ImGui_SetWindowSize1(const char * name, const ImVec2 & size, ImGuiCond cond) { return ::ImGui::SetWindowSize(name, size, cond);}
void ImGui_SetWindowCollapsed1(const char * name, bool collapsed, ImGuiCond cond) { return ::ImGui::SetWindowCollapsed(name, collapsed, cond);}
void ImGui_SetWindowFocus1(const char * name) { return ::ImGui::SetWindowFocus(name);}
float ImGui_GetScrollX() { return ::ImGui::GetScrollX();}
float ImGui_GetScrollY() { return ::ImGui::GetScrollY();}
void ImGui_SetScrollX(float scroll_x) { return ::ImGui::SetScrollX(scroll_x);}
void ImGui_SetScrollY(float scroll_y) { return ::ImGui::SetScrollY(scroll_y);}
float ImGui_GetScrollMaxX() { return ::ImGui::GetScrollMaxX();}
float ImGui_GetScrollMaxY() { return ::ImGui::GetScrollMaxY();}
void ImGui_SetScrollHereX(float center_x_ratio) { return ::ImGui::SetScrollHereX(center_x_ratio);}
void ImGui_SetScrollHereY(float center_y_ratio) { return ::ImGui::SetScrollHereY(center_y_ratio);}
void ImGui_SetScrollFromPosX(float local_x, float center_x_ratio) { return ::ImGui::SetScrollFromPosX(local_x, center_x_ratio);}
void ImGui_SetScrollFromPosY(float local_y, float center_y_ratio) { return ::ImGui::SetScrollFromPosY(local_y, center_y_ratio);}
void ImGui_PushFont(ImFont * font, float font_size_base_unscaled) { return ::ImGui::PushFont(font, font_size_base_unscaled);}
void ImGui_PopFont() { return ::ImGui::PopFont();}
ImFont * ImGui_GetFont() { return ::ImGui::GetFont();}
float ImGui_GetFontSize() { return ::ImGui::GetFontSize();}
ImFontBaked * ImGui_GetFontBaked() { return ::ImGui::GetFontBaked();}
void ImGui_PushStyleColor(ImGuiCol idx, ImU32 col) { return ::ImGui::PushStyleColor(idx, col);}
void ImGui_PushStyleColor1(ImGuiCol idx, const ImVec4 & col) { return ::ImGui::PushStyleColor(idx, col);}
void ImGui_PopStyleColor(int count) { return ::ImGui::PopStyleColor(count);}
void ImGui_PushStyleVar(ImGuiStyleVar idx, float val) { return ::ImGui::PushStyleVar(idx, val);}
void ImGui_PushStyleVar1(ImGuiStyleVar idx, const ImVec2 & val) { return ::ImGui::PushStyleVar(idx, val);}
void ImGui_PushStyleVarX(ImGuiStyleVar idx, float val_x) { return ::ImGui::PushStyleVarX(idx, val_x);}
void ImGui_PushStyleVarY(ImGuiStyleVar idx, float val_y) { return ::ImGui::PushStyleVarY(idx, val_y);}
void ImGui_PopStyleVar(int count) { return ::ImGui::PopStyleVar(count);}
void ImGui_PushItemFlag(ImGuiItemFlags option, bool enabled) { return ::ImGui::PushItemFlag(option, enabled);}
void ImGui_PopItemFlag() { return ::ImGui::PopItemFlag();}
void ImGui_PushItemWidth(float item_width) { return ::ImGui::PushItemWidth(item_width);}
void ImGui_PopItemWidth() { return ::ImGui::PopItemWidth();}
void ImGui_SetNextItemWidth(float item_width) { return ::ImGui::SetNextItemWidth(item_width);}
float ImGui_CalcItemWidth() { return ::ImGui::CalcItemWidth();}
void ImGui_PushTextWrapPos(float wrap_local_pos_x) { return ::ImGui::PushTextWrapPos(wrap_local_pos_x);}
void ImGui_PopTextWrapPos() { return ::ImGui::PopTextWrapPos();}
ImVec2 ImGui_GetFontTexUvWhitePixel() { return ::ImGui::GetFontTexUvWhitePixel();}
ImU32 ImGui_GetColorU32(ImGuiCol idx, float alpha_mul) { return ::ImGui::GetColorU32(idx, alpha_mul);}
ImU32 ImGui_GetColorU321(const ImVec4 & col) { return ::ImGui::GetColorU32(col);}
ImU32 ImGui_GetColorU322(ImU32 col, float alpha_mul) { return ::ImGui::GetColorU32(col, alpha_mul);}
const ImVec4 & ImGui_GetStyleColorVec4(ImGuiCol idx) { return ::ImGui::GetStyleColorVec4(idx);}
ImVec2 ImGui_GetCursorScreenPos() { return ::ImGui::GetCursorScreenPos();}
void ImGui_SetCursorScreenPos(const ImVec2 & pos) { return ::ImGui::SetCursorScreenPos(pos);}
ImVec2 ImGui_GetContentRegionAvail() { return ::ImGui::GetContentRegionAvail();}
ImVec2 ImGui_GetCursorPos() { return ::ImGui::GetCursorPos();}
float ImGui_GetCursorPosX() { return ::ImGui::GetCursorPosX();}
float ImGui_GetCursorPosY() { return ::ImGui::GetCursorPosY();}
void ImGui_SetCursorPos(const ImVec2 & local_pos) { return ::ImGui::SetCursorPos(local_pos);}
void ImGui_SetCursorPosX(float local_x) { return ::ImGui::SetCursorPosX(local_x);}
void ImGui_SetCursorPosY(float local_y) { return ::ImGui::SetCursorPosY(local_y);}
ImVec2 ImGui_GetCursorStartPos() { return ::ImGui::GetCursorStartPos();}
void ImGui_Separator() { return ::ImGui::Separator();}
void ImGui_SameLine(float offset_from_start_x, float spacing) { return ::ImGui::SameLine(offset_from_start_x, spacing);}
void ImGui_NewLine() { return ::ImGui::NewLine();}
void ImGui_Spacing() { return ::ImGui::Spacing();}
void ImGui_Dummy(const ImVec2 & size) { return ::ImGui::Dummy(size);}
void ImGui_Indent(float indent_w) { return ::ImGui::Indent(indent_w);}
void ImGui_Unindent(float indent_w) { return ::ImGui::Unindent(indent_w);}
void ImGui_BeginGroup() { return ::ImGui::BeginGroup();}
void ImGui_EndGroup() { return ::ImGui::EndGroup();}
void ImGui_AlignTextToFramePadding() { return ::ImGui::AlignTextToFramePadding();}
float ImGui_GetTextLineHeight() { return ::ImGui::GetTextLineHeight();}
float ImGui_GetTextLineHeightWithSpacing() { return ::ImGui::GetTextLineHeightWithSpacing();}
float ImGui_GetFrameHeight() { return ::ImGui::GetFrameHeight();}
float ImGui_GetFrameHeightWithSpacing() { return ::ImGui::GetFrameHeightWithSpacing();}
void ImGui_PushID(const char * str_id) { return ::ImGui::PushID(str_id);}
void ImGui_PushID1(const char * str_id_begin, const char * str_id_end) { return ::ImGui::PushID(str_id_begin, str_id_end);}
void ImGui_PushID2(const void * ptr_id) { return ::ImGui::PushID(ptr_id);}
void ImGui_PushID3(int int_id) { return ::ImGui::PushID(int_id);}
void ImGui_PopID() { return ::ImGui::PopID();}
ImGuiID ImGui_GetID(const char * str_id) { return ::ImGui::GetID(str_id);}
ImGuiID ImGui_GetID1(const char * str_id_begin, const char * str_id_end) { return ::ImGui::GetID(str_id_begin, str_id_end);}
ImGuiID ImGui_GetID2(const void * ptr_id) { return ::ImGui::GetID(ptr_id);}
ImGuiID ImGui_GetID3(int int_id) { return ::ImGui::GetID(int_id);}
void ImGui_TextUnformatted(const char * text, const char * text_end) { return ::ImGui::TextUnformatted(text, text_end);}
void ImGui_Text(const char * fmt) { return ::ImGui::Text(fmt);}
void ImGui_TextV(const char * fmt, va_list args) { return ::ImGui::TextV(fmt, args);}
void ImGui_TextColored(const ImVec4 & col, const char * fmt) { return ::ImGui::TextColored(col, fmt);}
void ImGui_TextColoredV(const ImVec4 & col, const char * fmt, va_list args) { return ::ImGui::TextColoredV(col, fmt, args);}
void ImGui_TextDisabled(const char * fmt) { return ::ImGui::TextDisabled(fmt);}
void ImGui_TextDisabledV(const char * fmt, va_list args) { return ::ImGui::TextDisabledV(fmt, args);}
void ImGui_TextWrapped(const char * fmt) { return ::ImGui::TextWrapped(fmt);}
void ImGui_TextWrappedV(const char * fmt, va_list args) { return ::ImGui::TextWrappedV(fmt, args);}
void ImGui_LabelText(const char * label, const char * fmt) { return ::ImGui::LabelText(label, fmt);}
void ImGui_LabelTextV(const char * label, const char * fmt, va_list args) { return ::ImGui::LabelTextV(label, fmt, args);}
void ImGui_BulletText(const char * fmt) { return ::ImGui::BulletText(fmt);}
void ImGui_BulletTextV(const char * fmt, va_list args) { return ::ImGui::BulletTextV(fmt, args);}
void ImGui_SeparatorText(const char * label) { return ::ImGui::SeparatorText(label);}
bool ImGui_Button(const char * label, const ImVec2 & size) { return ::ImGui::Button(label, size);}
bool ImGui_SmallButton(const char * label) { return ::ImGui::SmallButton(label);}
bool ImGui_InvisibleButton(const char * str_id, const ImVec2 & size, ImGuiButtonFlags flags) { return ::ImGui::InvisibleButton(str_id, size, flags);}
bool ImGui_ArrowButton(const char * str_id, ImGuiDir dir) { return ::ImGui::ArrowButton(str_id, dir);}
bool ImGui_Checkbox(const char * label, bool * v) { return ::ImGui::Checkbox(label, v);}
bool ImGui_CheckboxFlags(const char * label, int * flags, int flags_value) { return ::ImGui::CheckboxFlags(label, flags, flags_value);}
bool ImGui_CheckboxFlags1(const char * label, unsigned int * flags, unsigned int flags_value) { return ::ImGui::CheckboxFlags(label, flags, flags_value);}
bool ImGui_RadioButton(const char * label, bool active) { return ::ImGui::RadioButton(label, active);}
bool ImGui_RadioButton1(const char * label, int * v, int v_button) { return ::ImGui::RadioButton(label, v, v_button);}
void ImGui_ProgressBar(float fraction, const ImVec2 & size_arg, const char * overlay) { return ::ImGui::ProgressBar(fraction, size_arg, overlay);}
void ImGui_Bullet() { return ::ImGui::Bullet();}
bool ImGui_TextLink(const char * label) { return ::ImGui::TextLink(label);}
bool ImGui_TextLinkOpenURL(const char * label, const char * url) { return ::ImGui::TextLinkOpenURL(label, url);}
void ImGui_Image(ImTextureRef tex_ref, const ImVec2 & image_size, const ImVec2 & uv0, const ImVec2 & uv1) { return ::ImGui::Image(tex_ref, image_size, uv0, uv1);}
void ImGui_ImageWithBg(ImTextureRef tex_ref, const ImVec2 & image_size, const ImVec2 & uv0, const ImVec2 & uv1, const ImVec4 & bg_col, const ImVec4 & tint_col) { return ::ImGui::ImageWithBg(tex_ref, image_size, uv0, uv1, bg_col, tint_col);}
bool ImGui_ImageButton(const char * str_id, ImTextureRef tex_ref, const ImVec2 & image_size, const ImVec2 & uv0, const ImVec2 & uv1, const ImVec4 & bg_col, const ImVec4 & tint_col) { return ::ImGui::ImageButton(str_id, tex_ref, image_size, uv0, uv1, bg_col, tint_col);}
bool ImGui_BeginCombo(const char * label, const char * preview_value, ImGuiComboFlags flags) { return ::ImGui::BeginCombo(label, preview_value, flags);}
void ImGui_EndCombo() { return ::ImGui::EndCombo();}
bool ImGui_Combo(const char * label, int * current_item, const char *const items[], int items_count, int popup_max_height_in_items) { return ::ImGui::Combo(label, current_item, items, items_count, popup_max_height_in_items);}
bool ImGui_Combo1(const char * label, int * current_item, const char * items_separated_by_zeros, int popup_max_height_in_items) { return ::ImGui::Combo(label, current_item, items_separated_by_zeros, popup_max_height_in_items);}
bool ImGui_Combo2(const char * label, int * current_item, const char *(*getter)(void *, int), void * user_data, int items_count, int popup_max_height_in_items) { return ::ImGui::Combo(label, current_item, getter, user_data, items_count, popup_max_height_in_items);}
bool ImGui_DragFloat(const char * label, float * v, float v_speed, float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::DragFloat(label, v, v_speed, v_min, v_max, format, flags);}
bool ImGui_DragFloat2(const char * label, float v[2], float v_speed, float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::DragFloat2(label, v, v_speed, v_min, v_max, format, flags);}
bool ImGui_DragFloat3(const char * label, float v[3], float v_speed, float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::DragFloat3(label, v, v_speed, v_min, v_max, format, flags);}
bool ImGui_DragFloat4(const char * label, float v[4], float v_speed, float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::DragFloat4(label, v, v_speed, v_min, v_max, format, flags);}
bool ImGui_DragFloatRange2(const char * label, float * v_current_min, float * v_current_max, float v_speed, float v_min, float v_max, const char * format, const char * format_max, ImGuiSliderFlags flags) { return ::ImGui::DragFloatRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, flags);}
bool ImGui_DragInt(const char * label, int * v, float v_speed, int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::DragInt(label, v, v_speed, v_min, v_max, format, flags);}
bool ImGui_DragInt2(const char * label, int v[2], float v_speed, int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::DragInt2(label, v, v_speed, v_min, v_max, format, flags);}
bool ImGui_DragInt3(const char * label, int v[3], float v_speed, int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::DragInt3(label, v, v_speed, v_min, v_max, format, flags);}
bool ImGui_DragInt4(const char * label, int v[4], float v_speed, int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::DragInt4(label, v, v_speed, v_min, v_max, format, flags);}
bool ImGui_DragIntRange2(const char * label, int * v_current_min, int * v_current_max, float v_speed, int v_min, int v_max, const char * format, const char * format_max, ImGuiSliderFlags flags) { return ::ImGui::DragIntRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, flags);}
bool ImGui_DragScalar(const char * label, ImGuiDataType data_type, void * p_data, float v_speed, const void * p_min, const void * p_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::DragScalar(label, data_type, p_data, v_speed, p_min, p_max, format, flags);}
bool ImGui_DragScalarN(const char * label, ImGuiDataType data_type, void * p_data, int components, float v_speed, const void * p_min, const void * p_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::DragScalarN(label, data_type, p_data, components, v_speed, p_min, p_max, format, flags);}
bool ImGui_SliderFloat(const char * label, float * v, float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::SliderFloat(label, v, v_min, v_max, format, flags);}
bool ImGui_SliderFloat2(const char * label, float v[2], float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::SliderFloat2(label, v, v_min, v_max, format, flags);}
bool ImGui_SliderFloat3(const char * label, float v[3], float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::SliderFloat3(label, v, v_min, v_max, format, flags);}
bool ImGui_SliderFloat4(const char * label, float v[4], float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::SliderFloat4(label, v, v_min, v_max, format, flags);}
bool ImGui_SliderAngle(const char * label, float * v_rad, float v_degrees_min, float v_degrees_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::SliderAngle(label, v_rad, v_degrees_min, v_degrees_max, format, flags);}
bool ImGui_SliderInt(const char * label, int * v, int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::SliderInt(label, v, v_min, v_max, format, flags);}
bool ImGui_SliderInt2(const char * label, int v[2], int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::SliderInt2(label, v, v_min, v_max, format, flags);}
bool ImGui_SliderInt3(const char * label, int v[3], int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::SliderInt3(label, v, v_min, v_max, format, flags);}
bool ImGui_SliderInt4(const char * label, int v[4], int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::SliderInt4(label, v, v_min, v_max, format, flags);}
bool ImGui_SliderScalar(const char * label, ImGuiDataType data_type, void * p_data, const void * p_min, const void * p_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::SliderScalar(label, data_type, p_data, p_min, p_max, format, flags);}
bool ImGui_SliderScalarN(const char * label, ImGuiDataType data_type, void * p_data, int components, const void * p_min, const void * p_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::SliderScalarN(label, data_type, p_data, components, p_min, p_max, format, flags);}
bool ImGui_VSliderFloat(const char * label, const ImVec2 & size, float * v, float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::VSliderFloat(label, size, v, v_min, v_max, format, flags);}
bool ImGui_VSliderInt(const char * label, const ImVec2 & size, int * v, int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::VSliderInt(label, size, v, v_min, v_max, format, flags);}
bool ImGui_VSliderScalar(const char * label, const ImVec2 & size, ImGuiDataType data_type, void * p_data, const void * p_min, const void * p_max, const char * format, ImGuiSliderFlags flags) { return ::ImGui::VSliderScalar(label, size, data_type, p_data, p_min, p_max, format, flags);}
bool ImGui_InputText(const char * label, char * buf, size_t buf_size, ImGuiInputTextFlags flags, ImGuiInputTextCallback callback, void * user_data) { return ::ImGui::InputText(label, buf, buf_size, flags, callback, user_data);}
bool ImGui_InputTextMultiline(const char * label, char * buf, size_t buf_size, const ImVec2 & size, ImGuiInputTextFlags flags, ImGuiInputTextCallback callback, void * user_data) { return ::ImGui::InputTextMultiline(label, buf, buf_size, size, flags, callback, user_data);}
bool ImGui_InputTextWithHint(const char * label, const char * hint, char * buf, size_t buf_size, ImGuiInputTextFlags flags, ImGuiInputTextCallback callback, void * user_data) { return ::ImGui::InputTextWithHint(label, hint, buf, buf_size, flags, callback, user_data);}
bool ImGui_InputFloat(const char * label, float * v, float step, float step_fast, const char * format, ImGuiInputTextFlags flags) { return ::ImGui::InputFloat(label, v, step, step_fast, format, flags);}
bool ImGui_InputFloat2(const char * label, float v[2], const char * format, ImGuiInputTextFlags flags) { return ::ImGui::InputFloat2(label, v, format, flags);}
bool ImGui_InputFloat3(const char * label, float v[3], const char * format, ImGuiInputTextFlags flags) { return ::ImGui::InputFloat3(label, v, format, flags);}
bool ImGui_InputFloat4(const char * label, float v[4], const char * format, ImGuiInputTextFlags flags) { return ::ImGui::InputFloat4(label, v, format, flags);}
bool ImGui_InputInt(const char * label, int * v, int step, int step_fast, ImGuiInputTextFlags flags) { return ::ImGui::InputInt(label, v, step, step_fast, flags);}
bool ImGui_InputInt2(const char * label, int v[2], ImGuiInputTextFlags flags) { return ::ImGui::InputInt2(label, v, flags);}
bool ImGui_InputInt3(const char * label, int v[3], ImGuiInputTextFlags flags) { return ::ImGui::InputInt3(label, v, flags);}
bool ImGui_InputInt4(const char * label, int v[4], ImGuiInputTextFlags flags) { return ::ImGui::InputInt4(label, v, flags);}
bool ImGui_InputDouble(const char * label, double * v, double step, double step_fast, const char * format, ImGuiInputTextFlags flags) { return ::ImGui::InputDouble(label, v, step, step_fast, format, flags);}
bool ImGui_InputScalar(const char * label, ImGuiDataType data_type, void * p_data, const void * p_step, const void * p_step_fast, const char * format, ImGuiInputTextFlags flags) { return ::ImGui::InputScalar(label, data_type, p_data, p_step, p_step_fast, format, flags);}
bool ImGui_InputScalarN(const char * label, ImGuiDataType data_type, void * p_data, int components, const void * p_step, const void * p_step_fast, const char * format, ImGuiInputTextFlags flags) { return ::ImGui::InputScalarN(label, data_type, p_data, components, p_step, p_step_fast, format, flags);}
bool ImGui_ColorEdit3(const char * label, float col[3], ImGuiColorEditFlags flags) { return ::ImGui::ColorEdit3(label, col, flags);}
bool ImGui_ColorEdit4(const char * label, float col[4], ImGuiColorEditFlags flags) { return ::ImGui::ColorEdit4(label, col, flags);}
bool ImGui_ColorPicker3(const char * label, float col[3], ImGuiColorEditFlags flags) { return ::ImGui::ColorPicker3(label, col, flags);}
bool ImGui_ColorPicker4(const char * label, float col[4], ImGuiColorEditFlags flags, const float * ref_col) { return ::ImGui::ColorPicker4(label, col, flags, ref_col);}
bool ImGui_ColorButton(const char * desc_id, const ImVec4 & col, ImGuiColorEditFlags flags, const ImVec2 & size) { return ::ImGui::ColorButton(desc_id, col, flags, size);}
void ImGui_SetColorEditOptions(ImGuiColorEditFlags flags) { return ::ImGui::SetColorEditOptions(flags);}
bool ImGui_TreeNode(const char * label) { return ::ImGui::TreeNode(label);}
bool ImGui_TreeNode1(const char * str_id, const char * fmt) { return ::ImGui::TreeNode(str_id, fmt);}
bool ImGui_TreeNode2(const void * ptr_id, const char * fmt) { return ::ImGui::TreeNode(ptr_id, fmt);}
bool ImGui_TreeNodeV(const char * str_id, const char * fmt, va_list args) { return ::ImGui::TreeNodeV(str_id, fmt, args);}
bool ImGui_TreeNodeV1(const void * ptr_id, const char * fmt, va_list args) { return ::ImGui::TreeNodeV(ptr_id, fmt, args);}
bool ImGui_TreeNodeEx(const char * label, ImGuiTreeNodeFlags flags) { return ::ImGui::TreeNodeEx(label, flags);}
bool ImGui_TreeNodeEx1(const char * str_id, ImGuiTreeNodeFlags flags, const char * fmt) { return ::ImGui::TreeNodeEx(str_id, flags, fmt);}
bool ImGui_TreeNodeEx2(const void * ptr_id, ImGuiTreeNodeFlags flags, const char * fmt) { return ::ImGui::TreeNodeEx(ptr_id, flags, fmt);}
bool ImGui_TreeNodeExV(const char * str_id, ImGuiTreeNodeFlags flags, const char * fmt, va_list args) { return ::ImGui::TreeNodeExV(str_id, flags, fmt, args);}
bool ImGui_TreeNodeExV1(const void * ptr_id, ImGuiTreeNodeFlags flags, const char * fmt, va_list args) { return ::ImGui::TreeNodeExV(ptr_id, flags, fmt, args);}
void ImGui_TreePush(const char * str_id) { return ::ImGui::TreePush(str_id);}
void ImGui_TreePush1(const void * ptr_id) { return ::ImGui::TreePush(ptr_id);}
void ImGui_TreePop() { return ::ImGui::TreePop();}
float ImGui_GetTreeNodeToLabelSpacing() { return ::ImGui::GetTreeNodeToLabelSpacing();}
bool ImGui_CollapsingHeader(const char * label, ImGuiTreeNodeFlags flags) { return ::ImGui::CollapsingHeader(label, flags);}
bool ImGui_CollapsingHeader1(const char * label, bool * p_visible, ImGuiTreeNodeFlags flags) { return ::ImGui::CollapsingHeader(label, p_visible, flags);}
void ImGui_SetNextItemOpen(bool is_open, ImGuiCond cond) { return ::ImGui::SetNextItemOpen(is_open, cond);}
void ImGui_SetNextItemStorageID(ImGuiID storage_id) { return ::ImGui::SetNextItemStorageID(storage_id);}
bool ImGui_Selectable(const char * label, bool selected, ImGuiSelectableFlags flags, const ImVec2 & size) { return ::ImGui::Selectable(label, selected, flags, size);}
bool ImGui_Selectable1(const char * label, bool * p_selected, ImGuiSelectableFlags flags, const ImVec2 & size) { return ::ImGui::Selectable(label, p_selected, flags, size);}
ImGuiMultiSelectIO * ImGui_BeginMultiSelect(ImGuiMultiSelectFlags flags, int selection_size, int items_count) { return ::ImGui::BeginMultiSelect(flags, selection_size, items_count);}
ImGuiMultiSelectIO * ImGui_EndMultiSelect() { return ::ImGui::EndMultiSelect();}
void ImGui_SetNextItemSelectionUserData(ImGuiSelectionUserData selection_user_data) { return ::ImGui::SetNextItemSelectionUserData(selection_user_data);}
bool ImGui_IsItemToggledSelection() { return ::ImGui::IsItemToggledSelection();}
bool ImGui_BeginListBox(const char * label, const ImVec2 & size) { return ::ImGui::BeginListBox(label, size);}
void ImGui_EndListBox() { return ::ImGui::EndListBox();}
bool ImGui_ListBox(const char * label, int * current_item, const char *const items[], int items_count, int height_in_items) { return ::ImGui::ListBox(label, current_item, items, items_count, height_in_items);}
bool ImGui_ListBox1(const char * label, int * current_item, const char *(*getter)(void *, int), void * user_data, int items_count, int height_in_items) { return ::ImGui::ListBox(label, current_item, getter, user_data, items_count, height_in_items);}
void ImGui_PlotLines(const char * label, const float * values, int values_count, int values_offset, const char * overlay_text, float scale_min, float scale_max, ImVec2 graph_size, int stride) { return ::ImGui::PlotLines(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride);}
void ImGui_PlotLines1(const char * label, float (*values_getter)(void *, int), void * data, int values_count, int values_offset, const char * overlay_text, float scale_min, float scale_max, ImVec2 graph_size) { return ::ImGui::PlotLines(label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size);}
void ImGui_PlotHistogram(const char * label, const float * values, int values_count, int values_offset, const char * overlay_text, float scale_min, float scale_max, ImVec2 graph_size, int stride) { return ::ImGui::PlotHistogram(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride);}
void ImGui_PlotHistogram1(const char * label, float (*values_getter)(void *, int), void * data, int values_count, int values_offset, const char * overlay_text, float scale_min, float scale_max, ImVec2 graph_size) { return ::ImGui::PlotHistogram(label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size);}
void ImGui_Value(const char * prefix, bool b) { return ::ImGui::Value(prefix, b);}
void ImGui_Value1(const char * prefix, int v) { return ::ImGui::Value(prefix, v);}
void ImGui_Value2(const char * prefix, unsigned int v) { return ::ImGui::Value(prefix, v);}
void ImGui_Value3(const char * prefix, float v, const char * float_format) { return ::ImGui::Value(prefix, v, float_format);}
bool ImGui_BeginMenuBar() { return ::ImGui::BeginMenuBar();}
void ImGui_EndMenuBar() { return ::ImGui::EndMenuBar();}
bool ImGui_BeginMainMenuBar() { return ::ImGui::BeginMainMenuBar();}
void ImGui_EndMainMenuBar() { return ::ImGui::EndMainMenuBar();}
bool ImGui_BeginMenu(const char * label, bool enabled) { return ::ImGui::BeginMenu(label, enabled);}
void ImGui_EndMenu() { return ::ImGui::EndMenu();}
bool ImGui_MenuItem(const char * label, const char * shortcut, bool selected, bool enabled) { return ::ImGui::MenuItem(label, shortcut, selected, enabled);}
bool ImGui_MenuItem1(const char * label, const char * shortcut, bool * p_selected, bool enabled) { return ::ImGui::MenuItem(label, shortcut, p_selected, enabled);}
bool ImGui_BeginTooltip() { return ::ImGui::BeginTooltip();}
void ImGui_EndTooltip() { return ::ImGui::EndTooltip();}
void ImGui_SetTooltip(const char * fmt) { return ::ImGui::SetTooltip(fmt);}
void ImGui_SetTooltipV(const char * fmt, va_list args) { return ::ImGui::SetTooltipV(fmt, args);}
bool ImGui_BeginItemTooltip() { return ::ImGui::BeginItemTooltip();}
void ImGui_SetItemTooltip(const char * fmt) { return ::ImGui::SetItemTooltip(fmt);}
void ImGui_SetItemTooltipV(const char * fmt, va_list args) { return ::ImGui::SetItemTooltipV(fmt, args);}
bool ImGui_BeginPopup(const char * str_id, ImGuiWindowFlags flags) { return ::ImGui::BeginPopup(str_id, flags);}
bool ImGui_BeginPopupModal(const char * name, bool * p_open, ImGuiWindowFlags flags) { return ::ImGui::BeginPopupModal(name, p_open, flags);}
void ImGui_EndPopup() { return ::ImGui::EndPopup();}
void ImGui_OpenPopup(const char * str_id, ImGuiPopupFlags popup_flags) { return ::ImGui::OpenPopup(str_id, popup_flags);}
void ImGui_OpenPopup1(ImGuiID id, ImGuiPopupFlags popup_flags) { return ::ImGui::OpenPopup(id, popup_flags);}
void ImGui_OpenPopupOnItemClick(const char * str_id, ImGuiPopupFlags popup_flags) { return ::ImGui::OpenPopupOnItemClick(str_id, popup_flags);}
void ImGui_CloseCurrentPopup() { return ::ImGui::CloseCurrentPopup();}
bool ImGui_BeginPopupContextItem(const char * str_id, ImGuiPopupFlags popup_flags) { return ::ImGui::BeginPopupContextItem(str_id, popup_flags);}
bool ImGui_BeginPopupContextWindow(const char * str_id, ImGuiPopupFlags popup_flags) { return ::ImGui::BeginPopupContextWindow(str_id, popup_flags);}
bool ImGui_BeginPopupContextVoid(const char * str_id, ImGuiPopupFlags popup_flags) { return ::ImGui::BeginPopupContextVoid(str_id, popup_flags);}
bool ImGui_IsPopupOpen(const char * str_id, ImGuiPopupFlags flags) { return ::ImGui::IsPopupOpen(str_id, flags);}
bool ImGui_BeginTable(const char * str_id, int columns, ImGuiTableFlags flags, const ImVec2 & outer_size, float inner_width) { return ::ImGui::BeginTable(str_id, columns, flags, outer_size, inner_width);}
void ImGui_EndTable() { return ::ImGui::EndTable();}
void ImGui_TableNextRow(ImGuiTableRowFlags row_flags, float min_row_height) { return ::ImGui::TableNextRow(row_flags, min_row_height);}
bool ImGui_TableNextColumn() { return ::ImGui::TableNextColumn();}
bool ImGui_TableSetColumnIndex(int column_n) { return ::ImGui::TableSetColumnIndex(column_n);}
void ImGui_TableSetupColumn(const char * label, ImGuiTableColumnFlags flags, float init_width_or_weight, ImGuiID user_id) { return ::ImGui::TableSetupColumn(label, flags, init_width_or_weight, user_id);}
void ImGui_TableSetupScrollFreeze(int cols, int rows) { return ::ImGui::TableSetupScrollFreeze(cols, rows);}
void ImGui_TableHeader(const char * label) { return ::ImGui::TableHeader(label);}
void ImGui_TableHeadersRow() { return ::ImGui::TableHeadersRow();}
void ImGui_TableAngledHeadersRow() { return ::ImGui::TableAngledHeadersRow();}
ImGuiTableSortSpecs * ImGui_TableGetSortSpecs() { return ::ImGui::TableGetSortSpecs();}
int ImGui_TableGetColumnCount() { return ::ImGui::TableGetColumnCount();}
int ImGui_TableGetColumnIndex() { return ::ImGui::TableGetColumnIndex();}
int ImGui_TableGetRowIndex() { return ::ImGui::TableGetRowIndex();}
const char * ImGui_TableGetColumnName(int column_n) { return ::ImGui::TableGetColumnName(column_n);}
ImGuiTableColumnFlags ImGui_TableGetColumnFlags(int column_n) { return ::ImGui::TableGetColumnFlags(column_n);}
void ImGui_TableSetColumnEnabled(int column_n, bool v) { return ::ImGui::TableSetColumnEnabled(column_n, v);}
int ImGui_TableGetHoveredColumn() { return ::ImGui::TableGetHoveredColumn();}
void ImGui_TableSetBgColor(ImGuiTableBgTarget target, ImU32 color, int column_n) { return ::ImGui::TableSetBgColor(target, color, column_n);}
void ImGui_Columns(int count, const char * id, bool borders) { return ::ImGui::Columns(count, id, borders);}
void ImGui_NextColumn() { return ::ImGui::NextColumn();}
int ImGui_GetColumnIndex() { return ::ImGui::GetColumnIndex();}
float ImGui_GetColumnWidth(int column_index) { return ::ImGui::GetColumnWidth(column_index);}
void ImGui_SetColumnWidth(int column_index, float width) { return ::ImGui::SetColumnWidth(column_index, width);}
float ImGui_GetColumnOffset(int column_index) { return ::ImGui::GetColumnOffset(column_index);}
void ImGui_SetColumnOffset(int column_index, float offset_x) { return ::ImGui::SetColumnOffset(column_index, offset_x);}
int ImGui_GetColumnsCount() { return ::ImGui::GetColumnsCount();}
bool ImGui_BeginTabBar(const char * str_id, ImGuiTabBarFlags flags) { return ::ImGui::BeginTabBar(str_id, flags);}
void ImGui_EndTabBar() { return ::ImGui::EndTabBar();}
bool ImGui_BeginTabItem(const char * label, bool * p_open, ImGuiTabItemFlags flags) { return ::ImGui::BeginTabItem(label, p_open, flags);}
void ImGui_EndTabItem() { return ::ImGui::EndTabItem();}
bool ImGui_TabItemButton(const char * label, ImGuiTabItemFlags flags) { return ::ImGui::TabItemButton(label, flags);}
void ImGui_SetTabItemClosed(const char * tab_or_docked_window_label) { return ::ImGui::SetTabItemClosed(tab_or_docked_window_label);}
void ImGui_LogToTTY(int auto_open_depth) { return ::ImGui::LogToTTY(auto_open_depth);}
void ImGui_LogToFile(int auto_open_depth, const char * filename) { return ::ImGui::LogToFile(auto_open_depth, filename);}
void ImGui_LogToClipboard(int auto_open_depth) { return ::ImGui::LogToClipboard(auto_open_depth);}
void ImGui_LogFinish() { return ::ImGui::LogFinish();}
void ImGui_LogButtons() { return ::ImGui::LogButtons();}
void ImGui_LogText(const char * fmt) { return ::ImGui::LogText(fmt);}
void ImGui_LogTextV(const char * fmt, va_list args) { return ::ImGui::LogTextV(fmt, args);}
bool ImGui_BeginDragDropSource(ImGuiDragDropFlags flags) { return ::ImGui::BeginDragDropSource(flags);}
bool ImGui_SetDragDropPayload(const char * type, const void * data, size_t sz, ImGuiCond cond) { return ::ImGui::SetDragDropPayload(type, data, sz, cond);}
void ImGui_EndDragDropSource() { return ::ImGui::EndDragDropSource();}
bool ImGui_BeginDragDropTarget() { return ::ImGui::BeginDragDropTarget();}
const ImGuiPayload * ImGui_AcceptDragDropPayload(const char * type, ImGuiDragDropFlags flags) { return ::ImGui::AcceptDragDropPayload(type, flags);}
void ImGui_EndDragDropTarget() { return ::ImGui::EndDragDropTarget();}
const ImGuiPayload * ImGui_GetDragDropPayload() { return ::ImGui::GetDragDropPayload();}
void ImGui_BeginDisabled(bool disabled) { return ::ImGui::BeginDisabled(disabled);}
void ImGui_EndDisabled() { return ::ImGui::EndDisabled();}
void ImGui_PushClipRect(const ImVec2 & clip_rect_min, const ImVec2 & clip_rect_max, bool intersect_with_current_clip_rect) { return ::ImGui::PushClipRect(clip_rect_min, clip_rect_max, intersect_with_current_clip_rect);}
void ImGui_PopClipRect() { return ::ImGui::PopClipRect();}
void ImGui_SetItemDefaultFocus() { return ::ImGui::SetItemDefaultFocus();}
void ImGui_SetKeyboardFocusHere(int offset) { return ::ImGui::SetKeyboardFocusHere(offset);}
void ImGui_SetNavCursorVisible(bool visible) { return ::ImGui::SetNavCursorVisible(visible);}
void ImGui_SetNextItemAllowOverlap() { return ::ImGui::SetNextItemAllowOverlap();}
bool ImGui_IsItemHovered(ImGuiHoveredFlags flags) { return ::ImGui::IsItemHovered(flags);}
bool ImGui_IsItemActive() { return ::ImGui::IsItemActive();}
bool ImGui_IsItemFocused() { return ::ImGui::IsItemFocused();}
bool ImGui_IsItemClicked(ImGuiMouseButton mouse_button) { return ::ImGui::IsItemClicked(mouse_button);}
bool ImGui_IsItemVisible() { return ::ImGui::IsItemVisible();}
bool ImGui_IsItemEdited() { return ::ImGui::IsItemEdited();}
bool ImGui_IsItemActivated() { return ::ImGui::IsItemActivated();}
bool ImGui_IsItemDeactivated() { return ::ImGui::IsItemDeactivated();}
bool ImGui_IsItemDeactivatedAfterEdit() { return ::ImGui::IsItemDeactivatedAfterEdit();}
bool ImGui_IsItemToggledOpen() { return ::ImGui::IsItemToggledOpen();}
bool ImGui_IsAnyItemHovered() { return ::ImGui::IsAnyItemHovered();}
bool ImGui_IsAnyItemActive() { return ::ImGui::IsAnyItemActive();}
bool ImGui_IsAnyItemFocused() { return ::ImGui::IsAnyItemFocused();}
ImGuiID ImGui_GetItemID() { return ::ImGui::GetItemID();}
ImVec2 ImGui_GetItemRectMin() { return ::ImGui::GetItemRectMin();}
ImVec2 ImGui_GetItemRectMax() { return ::ImGui::GetItemRectMax();}
ImVec2 ImGui_GetItemRectSize() { return ::ImGui::GetItemRectSize();}
ImGuiViewport * ImGui_GetMainViewport() { return ::ImGui::GetMainViewport();}
ImDrawList * ImGui_GetBackgroundDrawList() { return ::ImGui::GetBackgroundDrawList();}
ImDrawList * ImGui_GetForegroundDrawList() { return ::ImGui::GetForegroundDrawList();}
bool ImGui_IsRectVisible(const ImVec2 & size) { return ::ImGui::IsRectVisible(size);}
bool ImGui_IsRectVisible1(const ImVec2 & rect_min, const ImVec2 & rect_max) { return ::ImGui::IsRectVisible(rect_min, rect_max);}
double ImGui_GetTime() { return ::ImGui::GetTime();}
int ImGui_GetFrameCount() { return ::ImGui::GetFrameCount();}
ImDrawListSharedData * ImGui_GetDrawListSharedData() { return ::ImGui::GetDrawListSharedData();}
const char * ImGui_GetStyleColorName(ImGuiCol idx) { return ::ImGui::GetStyleColorName(idx);}
void ImGui_SetStateStorage(ImGuiStorage * storage) { return ::ImGui::SetStateStorage(storage);}
ImGuiStorage * ImGui_GetStateStorage() { return ::ImGui::GetStateStorage();}
ImVec2 ImGui_CalcTextSize(const char * text, const char * text_end, bool hide_text_after_double_hash, float wrap_width) { return ::ImGui::CalcTextSize(text, text_end, hide_text_after_double_hash, wrap_width);}
ImVec4 ImGui_ColorConvertU32ToFloat4(ImU32 in) { return ::ImGui::ColorConvertU32ToFloat4(in);}
ImU32 ImGui_ColorConvertFloat4ToU32(const ImVec4 & in) { return ::ImGui::ColorConvertFloat4ToU32(in);}
void ImGui_ColorConvertRGBtoHSV(float r, float g, float b, float & out_h, float & out_s, float & out_v) { return ::ImGui::ColorConvertRGBtoHSV(r, g, b, out_h, out_s, out_v);}
void ImGui_ColorConvertHSVtoRGB(float h, float s, float v, float & out_r, float & out_g, float & out_b) { return ::ImGui::ColorConvertHSVtoRGB(h, s, v, out_r, out_g, out_b);}
bool ImGui_IsKeyDown(ImGuiKey key) { return ::ImGui::IsKeyDown(key);}
bool ImGui_IsKeyPressed(ImGuiKey key, bool repeat) { return ::ImGui::IsKeyPressed(key, repeat);}
bool ImGui_IsKeyReleased(ImGuiKey key) { return ::ImGui::IsKeyReleased(key);}
bool ImGui_IsKeyChordPressed(ImGuiKeyChord key_chord) { return ::ImGui::IsKeyChordPressed(key_chord);}
int ImGui_GetKeyPressedAmount(ImGuiKey key, float repeat_delay, float rate) { return ::ImGui::GetKeyPressedAmount(key, repeat_delay, rate);}
const char * ImGui_GetKeyName(ImGuiKey key) { return ::ImGui::GetKeyName(key);}
void ImGui_SetNextFrameWantCaptureKeyboard(bool want_capture_keyboard) { return ::ImGui::SetNextFrameWantCaptureKeyboard(want_capture_keyboard);}
bool ImGui_Shortcut(ImGuiKeyChord key_chord, ImGuiInputFlags flags) { return ::ImGui::Shortcut(key_chord, flags);}
void ImGui_SetNextItemShortcut(ImGuiKeyChord key_chord, ImGuiInputFlags flags) { return ::ImGui::SetNextItemShortcut(key_chord, flags);}
void ImGui_SetItemKeyOwner(ImGuiKey key) { return ::ImGui::SetItemKeyOwner(key);}
bool ImGui_IsMouseDown(ImGuiMouseButton button) { return ::ImGui::IsMouseDown(button);}
bool ImGui_IsMouseClicked(ImGuiMouseButton button, bool repeat) { return ::ImGui::IsMouseClicked(button, repeat);}
bool ImGui_IsMouseReleased(ImGuiMouseButton button) { return ::ImGui::IsMouseReleased(button);}
bool ImGui_IsMouseDoubleClicked(ImGuiMouseButton button) { return ::ImGui::IsMouseDoubleClicked(button);}
bool ImGui_IsMouseReleasedWithDelay(ImGuiMouseButton button, float delay) { return ::ImGui::IsMouseReleasedWithDelay(button, delay);}
int ImGui_GetMouseClickedCount(ImGuiMouseButton button) { return ::ImGui::GetMouseClickedCount(button);}
bool ImGui_IsMouseHoveringRect(const ImVec2 & r_min, const ImVec2 & r_max, bool clip) { return ::ImGui::IsMouseHoveringRect(r_min, r_max, clip);}
bool ImGui_IsMousePosValid(const ImVec2 * mouse_pos) { return ::ImGui::IsMousePosValid(mouse_pos);}
bool ImGui_IsAnyMouseDown() { return ::ImGui::IsAnyMouseDown();}
ImVec2 ImGui_GetMousePos() { return ::ImGui::GetMousePos();}
ImVec2 ImGui_GetMousePosOnOpeningCurrentPopup() { return ::ImGui::GetMousePosOnOpeningCurrentPopup();}
bool ImGui_IsMouseDragging(ImGuiMouseButton button, float lock_threshold) { return ::ImGui::IsMouseDragging(button, lock_threshold);}
ImVec2 ImGui_GetMouseDragDelta(ImGuiMouseButton button, float lock_threshold) { return ::ImGui::GetMouseDragDelta(button, lock_threshold);}
void ImGui_ResetMouseDragDelta(ImGuiMouseButton button) { return ::ImGui::ResetMouseDragDelta(button);}
ImGuiMouseCursor ImGui_GetMouseCursor() { return ::ImGui::GetMouseCursor();}
void ImGui_SetMouseCursor(ImGuiMouseCursor cursor_type) { return ::ImGui::SetMouseCursor(cursor_type);}
void ImGui_SetNextFrameWantCaptureMouse(bool want_capture_mouse) { return ::ImGui::SetNextFrameWantCaptureMouse(want_capture_mouse);}
const char * ImGui_GetClipboardText() { return ::ImGui::GetClipboardText();}
void ImGui_SetClipboardText(const char * text) { return ::ImGui::SetClipboardText(text);}
void ImGui_LoadIniSettingsFromDisk(const char * ini_filename) { return ::ImGui::LoadIniSettingsFromDisk(ini_filename);}
void ImGui_LoadIniSettingsFromMemory(const char * ini_data, size_t ini_size) { return ::ImGui::LoadIniSettingsFromMemory(ini_data, ini_size);}
void ImGui_SaveIniSettingsToDisk(const char * ini_filename) { return ::ImGui::SaveIniSettingsToDisk(ini_filename);}
const char * ImGui_SaveIniSettingsToMemory(size_t * out_ini_size) { return ::ImGui::SaveIniSettingsToMemory(out_ini_size);}
void ImGui_DebugTextEncoding(const char * text) { return ::ImGui::DebugTextEncoding(text);}
void ImGui_DebugFlashStyleColor(ImGuiCol idx) { return ::ImGui::DebugFlashStyleColor(idx);}
void ImGui_DebugStartItemPicker() { return ::ImGui::DebugStartItemPicker();}
bool ImGui_DebugCheckVersionAndDataLayout(const char * version_str, size_t sz_io, size_t sz_style, size_t sz_vec2, size_t sz_vec4, size_t sz_drawvert, size_t sz_drawidx) { return ::ImGui::DebugCheckVersionAndDataLayout(version_str, sz_io, sz_style, sz_vec2, sz_vec4, sz_drawvert, sz_drawidx);}
void ImGui_DebugLog(const char * fmt) { return ::ImGui::DebugLog(fmt);}
void ImGui_DebugLogV(const char * fmt, va_list args) { return ::ImGui::DebugLogV(fmt, args);}
void ImGui_SetAllocatorFunctions(ImGuiMemAllocFunc alloc_func, ImGuiMemFreeFunc free_func, void * user_data) { return ::ImGui::SetAllocatorFunctions(alloc_func, free_func, user_data);}
void ImGui_GetAllocatorFunctions(ImGuiMemAllocFunc * p_alloc_func, ImGuiMemFreeFunc * p_free_func, void ** p_user_data) { return ::ImGui::GetAllocatorFunctions(p_alloc_func, p_free_func, p_user_data);}
void * ImGui_MemAlloc(size_t size) { return ::ImGui::MemAlloc(size);}
void ImGui_MemFree(void * ptr) { return ::ImGui::MemFree(ptr);}
}
