#include <bit>
#include <cstdarg>

namespace NS {
#include "imgui/imgui.h"
}

extern "C" {
typedef unsigned int Better_ImGuiID;
typedef signed char Better_ImS8;
typedef unsigned char Better_ImU8;
typedef short Better_ImS16;
typedef unsigned short Better_ImU16;
typedef int Better_ImS32;
typedef unsigned int Better_ImU32;
typedef long long Better_ImS64;
typedef unsigned long long Better_ImU64;
typedef struct ImDrawChannel ImDrawChannel;
typedef struct ImDrawCmd ImDrawCmd;
typedef struct ImDrawData ImDrawData;
typedef struct ImDrawList ImDrawList;
typedef struct ImDrawListSharedData ImDrawListSharedData;
typedef struct ImDrawListSplitter ImDrawListSplitter;
typedef struct ImDrawVert ImDrawVert;
typedef struct ImFont ImFont;
typedef struct ImFontAtlas ImFontAtlas;
typedef struct ImFontAtlasBuilder ImFontAtlasBuilder;
typedef struct ImFontAtlasRect ImFontAtlasRect;
typedef struct ImFontBaked ImFontBaked;
typedef struct ImFontConfig ImFontConfig;
typedef struct ImFontGlyph ImFontGlyph;
typedef struct ImFontGlyphRangesBuilder ImFontGlyphRangesBuilder;
typedef struct ImFontLoader ImFontLoader;
typedef struct ImTextureData ImTextureData;
typedef struct ImTextureRect ImTextureRect;
typedef struct ImColor ImColor;
typedef struct ImGuiContext ImGuiContext;
typedef struct ImGuiIO ImGuiIO;
typedef struct ImGuiInputTextCallbackData ImGuiInputTextCallbackData;
typedef struct ImGuiKeyData ImGuiKeyData;
typedef struct ImGuiListClipper ImGuiListClipper;
typedef struct ImGuiMultiSelectIO ImGuiMultiSelectIO;
typedef struct ImGuiOnceUponAFrame ImGuiOnceUponAFrame;
typedef struct ImGuiPayload ImGuiPayload;
typedef struct ImGuiPlatformIO ImGuiPlatformIO;
typedef struct ImGuiPlatformImeData ImGuiPlatformImeData;
typedef struct ImGuiSelectionBasicStorage ImGuiSelectionBasicStorage;
typedef struct ImGuiSelectionExternalStorage ImGuiSelectionExternalStorage;
typedef struct ImGuiSelectionRequest ImGuiSelectionRequest;
typedef struct ImGuiSizeCallbackData ImGuiSizeCallbackData;
typedef struct ImGuiStorage ImGuiStorage;
typedef struct ImGuiStoragePair ImGuiStoragePair;
typedef struct ImGuiStyle ImGuiStyle;
typedef struct ImGuiTableSortSpecs ImGuiTableSortSpecs;
typedef struct ImGuiTableColumnSortSpecs ImGuiTableColumnSortSpecs;
typedef struct ImGuiTextBuffer ImGuiTextBuffer;
typedef struct ImGuiTextFilter ImGuiTextFilter;
typedef struct ImGuiViewport ImGuiViewport;
enum ImGuiDir {
};
enum ImGuiKey {
};
enum ImGuiMouseSource {
};
enum ImGuiSortDirection {
};
typedef int Better_ImGuiCol;
typedef int Better_ImGuiCond;
typedef int Better_ImGuiDataType;
typedef int Better_ImGuiMouseButton;
typedef int Better_ImGuiMouseCursor;
typedef int Better_ImGuiStyleVar;
typedef int Better_ImGuiTableBgTarget;
typedef int Better_ImDrawFlags;
typedef int Better_ImDrawListFlags;
typedef int Better_ImFontFlags;
typedef int Better_ImFontAtlasFlags;
typedef int Better_ImGuiBackendFlags;
typedef int Better_ImGuiButtonFlags;
typedef int Better_ImGuiChildFlags;
typedef int Better_ImGuiColorEditFlags;
typedef int Better_ImGuiConfigFlags;
typedef int Better_ImGuiComboFlags;
typedef int Better_ImGuiDragDropFlags;
typedef int Better_ImGuiFocusedFlags;
typedef int Better_ImGuiHoveredFlags;
typedef int Better_ImGuiInputFlags;
typedef int Better_ImGuiInputTextFlags;
typedef int Better_ImGuiItemFlags;
typedef int Better_ImGuiKeyChord;
typedef int Better_ImGuiPopupFlags;
typedef int Better_ImGuiMultiSelectFlags;
typedef int Better_ImGuiSelectableFlags;
typedef int Better_ImGuiSliderFlags;
typedef int Better_ImGuiTabBarFlags;
typedef int Better_ImGuiTabItemFlags;
typedef int Better_ImGuiTableFlags;
typedef int Better_ImGuiTableColumnFlags;
typedef int Better_ImGuiTableRowFlags;
typedef int Better_ImGuiTreeNodeFlags;
typedef int Better_ImGuiViewportFlags;
typedef int Better_ImGuiWindowFlags;
typedef unsigned int Better_ImWchar32;
typedef unsigned short Better_ImWchar16;
typedef ImWchar16 Better_ImWchar;
typedef ImS64 Better_ImGuiSelectionUserData;
typedef ::NS::ImGuiInputTextCallback ImGuiInputTextCallback;
typedef ::NS::ImGuiSizeCallback ImGuiSizeCallback;
typedef ::NS::ImGuiMemAllocFunc ImGuiMemAllocFunc;
typedef ::NS::ImGuiMemFreeFunc ImGuiMemFreeFunc;
struct ImVec2 {
float x;
float y;
};
struct ImVec4 {
float x;
float y;
float z;
float w;
};
typedef ImU64 Better_ImTextureID;
struct ImTextureRef {
ImTextureData * _TexData;
ImTextureID _TexID;
};
ImGuiContext *  ImGui_CreateContext(ImFontAtlas * shared_font_atlas) { return reinterpret_cast<ImGuiContext * >(::NS::ImGui::CreateContext(reinterpret_cast<::NS::ImFontAtlas * >(shared_font_atlas)));}
void  ImGui_DestroyContext(ImGuiContext * ctx) { return ::NS::ImGui::DestroyContext(reinterpret_cast<::NS::ImGuiContext * >(ctx));}
ImGuiContext *  ImGui_GetCurrentContext() { return reinterpret_cast<ImGuiContext * >(::NS::ImGui::GetCurrentContext());}
void  ImGui_SetCurrentContext(ImGuiContext * ctx) { return ::NS::ImGui::SetCurrentContext(reinterpret_cast<::NS::ImGuiContext * >(ctx));}
ImGuiIO *  ImGui_GetIO() { return reinterpret_cast<ImGuiIO * >(&::NS::ImGui::GetIO());}
ImGuiPlatformIO *  ImGui_GetPlatformIO() { return reinterpret_cast<ImGuiPlatformIO * >(&::NS::ImGui::GetPlatformIO());}
ImGuiStyle *  ImGui_GetStyle() { return reinterpret_cast<ImGuiStyle * >(&::NS::ImGui::GetStyle());}
void  ImGui_NewFrame() { return ::NS::ImGui::NewFrame();}
void  ImGui_EndFrame() { return ::NS::ImGui::EndFrame();}
void  ImGui_Render() { return ::NS::ImGui::Render();}
ImDrawData *  ImGui_GetDrawData() { return reinterpret_cast<ImDrawData * >(::NS::ImGui::GetDrawData());}
void  ImGui_ShowDemoWindow(bool * p_open) { return ::NS::ImGui::ShowDemoWindow(p_open);}
void  ImGui_ShowMetricsWindow(bool * p_open) { return ::NS::ImGui::ShowMetricsWindow(p_open);}
void  ImGui_ShowDebugLogWindow(bool * p_open) { return ::NS::ImGui::ShowDebugLogWindow(p_open);}
void  ImGui_ShowIDStackToolWindow(bool * p_open) { return ::NS::ImGui::ShowIDStackToolWindow(p_open);}
void  ImGui_ShowAboutWindow(bool * p_open) { return ::NS::ImGui::ShowAboutWindow(p_open);}
void  ImGui_ShowStyleEditor(ImGuiStyle * ref) { return ::NS::ImGui::ShowStyleEditor(reinterpret_cast<::NS::ImGuiStyle * >(ref));}
bool  ImGui_ShowStyleSelector(const char * label) { return ::NS::ImGui::ShowStyleSelector(label);}
void  ImGui_ShowFontSelector(const char * label) { return ::NS::ImGui::ShowFontSelector(label);}
void  ImGui_ShowUserGuide() { return ::NS::ImGui::ShowUserGuide();}
const char *  ImGui_GetVersion() { return reinterpret_cast<const char * >(::NS::ImGui::GetVersion());}
void  ImGui_StyleColorsDark(ImGuiStyle * dst) { return ::NS::ImGui::StyleColorsDark(reinterpret_cast<::NS::ImGuiStyle * >(dst));}
void  ImGui_StyleColorsLight(ImGuiStyle * dst) { return ::NS::ImGui::StyleColorsLight(reinterpret_cast<::NS::ImGuiStyle * >(dst));}
void  ImGui_StyleColorsClassic(ImGuiStyle * dst) { return ::NS::ImGui::StyleColorsClassic(reinterpret_cast<::NS::ImGuiStyle * >(dst));}
bool  ImGui_Begin(const char * name, bool * p_open, ImGuiWindowFlags flags) { return ::NS::ImGui::Begin(name, p_open, flags);}
void  ImGui_End() { return ::NS::ImGui::End();}
bool  ImGui_BeginChild(const char * str_id, const ImVec2 & size, ImGuiChildFlags child_flags, ImGuiWindowFlags window_flags) { return ::NS::ImGui::BeginChild(str_id, size, child_flags, window_flags);}
bool  ImGui_BeginChild1(ImGuiID id, const ImVec2 & size, ImGuiChildFlags child_flags, ImGuiWindowFlags window_flags) { return ::NS::ImGui::BeginChild(id, size, child_flags, window_flags);}
void  ImGui_EndChild() { return ::NS::ImGui::EndChild();}
bool  ImGui_IsWindowAppearing() { return ::NS::ImGui::IsWindowAppearing();}
bool  ImGui_IsWindowCollapsed() { return ::NS::ImGui::IsWindowCollapsed();}
bool  ImGui_IsWindowFocused(ImGuiFocusedFlags flags) { return ::NS::ImGui::IsWindowFocused(flags);}
bool  ImGui_IsWindowHovered(ImGuiHoveredFlags flags) { return ::NS::ImGui::IsWindowHovered(flags);}
ImDrawList *  ImGui_GetWindowDrawList() { return reinterpret_cast<ImDrawList * >(::NS::ImGui::GetWindowDrawList());}
ImVec2  ImGui_GetWindowPos() { return std::bit_cast<ImVec2>(::NS::ImGui::GetWindowPos());}
ImVec2  ImGui_GetWindowSize() { return std::bit_cast<ImVec2>(::NS::ImGui::GetWindowSize());}
float  ImGui_GetWindowWidth() { return ::NS::ImGui::GetWindowWidth();}
float  ImGui_GetWindowHeight() { return ::NS::ImGui::GetWindowHeight();}
void  ImGui_SetNextWindowPos(const ImVec2 & pos, ImGuiCond cond, const ImVec2 & pivot) { return ::NS::ImGui::SetNextWindowPos(pos, cond, pivot);}
void  ImGui_SetNextWindowSize(const ImVec2 & size, ImGuiCond cond) { return ::NS::ImGui::SetNextWindowSize(size, cond);}
void  ImGui_SetNextWindowSizeConstraints(const ImVec2 & size_min, const ImVec2 & size_max, ImGuiSizeCallback custom_callback, void * custom_callback_data) { return ::NS::ImGui::SetNextWindowSizeConstraints(size_min, size_max, custom_callback, custom_callback_data);}
void  ImGui_SetNextWindowContentSize(const ImVec2 & size) { return ::NS::ImGui::SetNextWindowContentSize(size);}
void  ImGui_SetNextWindowCollapsed(bool collapsed, ImGuiCond cond) { return ::NS::ImGui::SetNextWindowCollapsed(collapsed, cond);}
void  ImGui_SetNextWindowFocus() { return ::NS::ImGui::SetNextWindowFocus();}
void  ImGui_SetNextWindowScroll(const ImVec2 & scroll) { return ::NS::ImGui::SetNextWindowScroll(scroll);}
void  ImGui_SetNextWindowBgAlpha(float alpha) { return ::NS::ImGui::SetNextWindowBgAlpha(alpha);}
void  ImGui_SetWindowPos(const ImVec2 & pos, ImGuiCond cond) { return ::NS::ImGui::SetWindowPos(pos, cond);}
void  ImGui_SetWindowSize(const ImVec2 & size, ImGuiCond cond) { return ::NS::ImGui::SetWindowSize(size, cond);}
void  ImGui_SetWindowCollapsed(bool collapsed, ImGuiCond cond) { return ::NS::ImGui::SetWindowCollapsed(collapsed, cond);}
void  ImGui_SetWindowFocus() { return ::NS::ImGui::SetWindowFocus();}
void  ImGui_SetWindowPos1(const char * name, const ImVec2 & pos, ImGuiCond cond) { return ::NS::ImGui::SetWindowPos(name, pos, cond);}
void  ImGui_SetWindowSize1(const char * name, const ImVec2 & size, ImGuiCond cond) { return ::NS::ImGui::SetWindowSize(name, size, cond);}
void  ImGui_SetWindowCollapsed1(const char * name, bool collapsed, ImGuiCond cond) { return ::NS::ImGui::SetWindowCollapsed(name, collapsed, cond);}
void  ImGui_SetWindowFocus1(const char * name) { return ::NS::ImGui::SetWindowFocus(name);}
float  ImGui_GetScrollX() { return ::NS::ImGui::GetScrollX();}
float  ImGui_GetScrollY() { return ::NS::ImGui::GetScrollY();}
void  ImGui_SetScrollX(float scroll_x) { return ::NS::ImGui::SetScrollX(scroll_x);}
void  ImGui_SetScrollY(float scroll_y) { return ::NS::ImGui::SetScrollY(scroll_y);}
float  ImGui_GetScrollMaxX() { return ::NS::ImGui::GetScrollMaxX();}
float  ImGui_GetScrollMaxY() { return ::NS::ImGui::GetScrollMaxY();}
void  ImGui_SetScrollHereX(float center_x_ratio) { return ::NS::ImGui::SetScrollHereX(center_x_ratio);}
void  ImGui_SetScrollHereY(float center_y_ratio) { return ::NS::ImGui::SetScrollHereY(center_y_ratio);}
void  ImGui_SetScrollFromPosX(float local_x, float center_x_ratio) { return ::NS::ImGui::SetScrollFromPosX(local_x, center_x_ratio);}
void  ImGui_SetScrollFromPosY(float local_y, float center_y_ratio) { return ::NS::ImGui::SetScrollFromPosY(local_y, center_y_ratio);}
void  ImGui_PushFont(ImFont * font, float font_size_base_unscaled) { return ::NS::ImGui::PushFont(reinterpret_cast<::NS::ImFont * >(font), font_size_base_unscaled);}
void  ImGui_PopFont() { return ::NS::ImGui::PopFont();}
ImFont *  ImGui_GetFont() { return reinterpret_cast<ImFont * >(::NS::ImGui::GetFont());}
float  ImGui_GetFontSize() { return ::NS::ImGui::GetFontSize();}
ImFontBaked *  ImGui_GetFontBaked() { return reinterpret_cast<ImFontBaked * >(::NS::ImGui::GetFontBaked());}
void  ImGui_PushStyleColor(ImGuiCol idx, ImU32 col) { return ::NS::ImGui::PushStyleColor(idx, col);}
void  ImGui_PushStyleColor1(ImGuiCol idx, const ImVec4 & col) { return ::NS::ImGui::PushStyleColor(idx, col);}
void  ImGui_PopStyleColor(int count) { return ::NS::ImGui::PopStyleColor(count);}
void  ImGui_PushStyleVar(ImGuiStyleVar idx, float val) { return ::NS::ImGui::PushStyleVar(idx, val);}
void  ImGui_PushStyleVar1(ImGuiStyleVar idx, const ImVec2 & val) { return ::NS::ImGui::PushStyleVar(idx, val);}
void  ImGui_PushStyleVarX(ImGuiStyleVar idx, float val_x) { return ::NS::ImGui::PushStyleVarX(idx, val_x);}
void  ImGui_PushStyleVarY(ImGuiStyleVar idx, float val_y) { return ::NS::ImGui::PushStyleVarY(idx, val_y);}
void  ImGui_PopStyleVar(int count) { return ::NS::ImGui::PopStyleVar(count);}
void  ImGui_PushItemFlag(ImGuiItemFlags option, bool enabled) { return ::NS::ImGui::PushItemFlag(option, enabled);}
void  ImGui_PopItemFlag() { return ::NS::ImGui::PopItemFlag();}
void  ImGui_PushItemWidth(float item_width) { return ::NS::ImGui::PushItemWidth(item_width);}
void  ImGui_PopItemWidth() { return ::NS::ImGui::PopItemWidth();}
void  ImGui_SetNextItemWidth(float item_width) { return ::NS::ImGui::SetNextItemWidth(item_width);}
float  ImGui_CalcItemWidth() { return ::NS::ImGui::CalcItemWidth();}
void  ImGui_PushTextWrapPos(float wrap_local_pos_x) { return ::NS::ImGui::PushTextWrapPos(wrap_local_pos_x);}
void  ImGui_PopTextWrapPos() { return ::NS::ImGui::PopTextWrapPos();}
ImVec2  ImGui_GetFontTexUvWhitePixel() { return std::bit_cast<ImVec2>(::NS::ImGui::GetFontTexUvWhitePixel());}
ImU32  ImGui_GetColorU32(ImGuiCol idx, float alpha_mul) { return ::NS::ImGui::GetColorU32(idx, alpha_mul);}
ImU32  ImGui_GetColorU321(const ImVec4 & col) { return ::NS::ImGui::GetColorU32(col);}
ImU32  ImGui_GetColorU322(ImU32 col, float alpha_mul) { return ::NS::ImGui::GetColorU32(col, alpha_mul);}
const ImVec4 *  ImGui_GetStyleColorVec4(ImGuiCol idx) { return reinterpret_cast<const ImVec4 * >(&::NS::ImGui::GetStyleColorVec4(idx));}
ImVec2  ImGui_GetCursorScreenPos() { return std::bit_cast<ImVec2>(::NS::ImGui::GetCursorScreenPos());}
void  ImGui_SetCursorScreenPos(const ImVec2 & pos) { return ::NS::ImGui::SetCursorScreenPos(pos);}
ImVec2  ImGui_GetContentRegionAvail() { return std::bit_cast<ImVec2>(::NS::ImGui::GetContentRegionAvail());}
ImVec2  ImGui_GetCursorPos() { return std::bit_cast<ImVec2>(::NS::ImGui::GetCursorPos());}
float  ImGui_GetCursorPosX() { return ::NS::ImGui::GetCursorPosX();}
float  ImGui_GetCursorPosY() { return ::NS::ImGui::GetCursorPosY();}
void  ImGui_SetCursorPos(const ImVec2 & local_pos) { return ::NS::ImGui::SetCursorPos(local_pos);}
void  ImGui_SetCursorPosX(float local_x) { return ::NS::ImGui::SetCursorPosX(local_x);}
void  ImGui_SetCursorPosY(float local_y) { return ::NS::ImGui::SetCursorPosY(local_y);}
ImVec2  ImGui_GetCursorStartPos() { return std::bit_cast<ImVec2>(::NS::ImGui::GetCursorStartPos());}
void  ImGui_Separator() { return ::NS::ImGui::Separator();}
void  ImGui_SameLine(float offset_from_start_x, float spacing) { return ::NS::ImGui::SameLine(offset_from_start_x, spacing);}
void  ImGui_NewLine() { return ::NS::ImGui::NewLine();}
void  ImGui_Spacing() { return ::NS::ImGui::Spacing();}
void  ImGui_Dummy(const ImVec2 & size) { return ::NS::ImGui::Dummy(size);}
void  ImGui_Indent(float indent_w) { return ::NS::ImGui::Indent(indent_w);}
void  ImGui_Unindent(float indent_w) { return ::NS::ImGui::Unindent(indent_w);}
void  ImGui_BeginGroup() { return ::NS::ImGui::BeginGroup();}
void  ImGui_EndGroup() { return ::NS::ImGui::EndGroup();}
void  ImGui_AlignTextToFramePadding() { return ::NS::ImGui::AlignTextToFramePadding();}
float  ImGui_GetTextLineHeight() { return ::NS::ImGui::GetTextLineHeight();}
float  ImGui_GetTextLineHeightWithSpacing() { return ::NS::ImGui::GetTextLineHeightWithSpacing();}
float  ImGui_GetFrameHeight() { return ::NS::ImGui::GetFrameHeight();}
float  ImGui_GetFrameHeightWithSpacing() { return ::NS::ImGui::GetFrameHeightWithSpacing();}
void  ImGui_PushID(const char * str_id) { return ::NS::ImGui::PushID(str_id);}
void  ImGui_PushID1(const char * str_id_begin, const char * str_id_end) { return ::NS::ImGui::PushID(str_id_begin, str_id_end);}
void  ImGui_PushID2(const void * ptr_id) { return ::NS::ImGui::PushID(ptr_id);}
void  ImGui_PushID3(int int_id) { return ::NS::ImGui::PushID(int_id);}
void  ImGui_PopID() { return ::NS::ImGui::PopID();}
ImGuiID  ImGui_GetID(const char * str_id) { return ::NS::ImGui::GetID(str_id);}
ImGuiID  ImGui_GetID1(const char * str_id_begin, const char * str_id_end) { return ::NS::ImGui::GetID(str_id_begin, str_id_end);}
ImGuiID  ImGui_GetID2(const void * ptr_id) { return ::NS::ImGui::GetID(ptr_id);}
ImGuiID  ImGui_GetID3(int int_id) { return ::NS::ImGui::GetID(int_id);}
void  ImGui_TextUnformatted(const char * text, const char * text_end) { return ::NS::ImGui::TextUnformatted(text, text_end);}
void  ImGui_Text(const char * fmt) { return ::NS::ImGui::Text(fmt);}
void  ImGui_TextV(const char * fmt, va_list args) { return ::NS::ImGui::TextV(fmt, args);}
void  ImGui_TextColored(const ImVec4 & col, const char * fmt) { return ::NS::ImGui::TextColored(col, fmt);}
void  ImGui_TextColoredV(const ImVec4 & col, const char * fmt, va_list args) { return ::NS::ImGui::TextColoredV(col, fmt, args);}
void  ImGui_TextDisabled(const char * fmt) { return ::NS::ImGui::TextDisabled(fmt);}
void  ImGui_TextDisabledV(const char * fmt, va_list args) { return ::NS::ImGui::TextDisabledV(fmt, args);}
void  ImGui_TextWrapped(const char * fmt) { return ::NS::ImGui::TextWrapped(fmt);}
void  ImGui_TextWrappedV(const char * fmt, va_list args) { return ::NS::ImGui::TextWrappedV(fmt, args);}
void  ImGui_LabelText(const char * label, const char * fmt) { return ::NS::ImGui::LabelText(label, fmt);}
void  ImGui_LabelTextV(const char * label, const char * fmt, va_list args) { return ::NS::ImGui::LabelTextV(label, fmt, args);}
void  ImGui_BulletText(const char * fmt) { return ::NS::ImGui::BulletText(fmt);}
void  ImGui_BulletTextV(const char * fmt, va_list args) { return ::NS::ImGui::BulletTextV(fmt, args);}
void  ImGui_SeparatorText(const char * label) { return ::NS::ImGui::SeparatorText(label);}
bool  ImGui_Button(const char * label, const ImVec2 & size) { return ::NS::ImGui::Button(label, size);}
bool  ImGui_SmallButton(const char * label) { return ::NS::ImGui::SmallButton(label);}
bool  ImGui_InvisibleButton(const char * str_id, const ImVec2 & size, ImGuiButtonFlags flags) { return ::NS::ImGui::InvisibleButton(str_id, size, flags);}
bool  ImGui_ArrowButton(const char * str_id, ImGuiDir dir) { return ::NS::ImGui::ArrowButton(str_id, std::bit_cast<::NS::ImGuiDir >(dir));}
bool  ImGui_Checkbox(const char * label, bool * v) { return ::NS::ImGui::Checkbox(label, v);}
bool  ImGui_CheckboxFlags(const char * label, int * flags, int flags_value) { return ::NS::ImGui::CheckboxFlags(label, flags, flags_value);}
bool  ImGui_CheckboxFlags1(const char * label, unsigned int * flags, unsigned int flags_value) { return ::NS::ImGui::CheckboxFlags(label, flags, flags_value);}
bool  ImGui_RadioButton(const char * label, bool active) { return ::NS::ImGui::RadioButton(label, active);}
bool  ImGui_RadioButton1(const char * label, int * v, int v_button) { return ::NS::ImGui::RadioButton(label, v, v_button);}
void  ImGui_ProgressBar(float fraction, const ImVec2 & size_arg, const char * overlay) { return ::NS::ImGui::ProgressBar(fraction, size_arg, overlay);}
void  ImGui_Bullet() { return ::NS::ImGui::Bullet();}
bool  ImGui_TextLink(const char * label) { return ::NS::ImGui::TextLink(label);}
bool  ImGui_TextLinkOpenURL(const char * label, const char * url) { return ::NS::ImGui::TextLinkOpenURL(label, url);}
void  ImGui_Image(ImTextureRef tex_ref, const ImVec2 & image_size, const ImVec2 & uv0, const ImVec2 & uv1) { return ::NS::ImGui::Image(std::bit_cast<::NS::ImTextureRef >(tex_ref), image_size, uv0, uv1);}
void  ImGui_ImageWithBg(ImTextureRef tex_ref, const ImVec2 & image_size, const ImVec2 & uv0, const ImVec2 & uv1, const ImVec4 & bg_col, const ImVec4 & tint_col) { return ::NS::ImGui::ImageWithBg(std::bit_cast<::NS::ImTextureRef >(tex_ref), image_size, uv0, uv1, bg_col, tint_col);}
bool  ImGui_ImageButton(const char * str_id, ImTextureRef tex_ref, const ImVec2 & image_size, const ImVec2 & uv0, const ImVec2 & uv1, const ImVec4 & bg_col, const ImVec4 & tint_col) { return ::NS::ImGui::ImageButton(str_id, std::bit_cast<::NS::ImTextureRef >(tex_ref), image_size, uv0, uv1, bg_col, tint_col);}
bool  ImGui_BeginCombo(const char * label, const char * preview_value, ImGuiComboFlags flags) { return ::NS::ImGui::BeginCombo(label, preview_value, flags);}
void  ImGui_EndCombo() { return ::NS::ImGui::EndCombo();}
bool  ImGui_Combo(const char * label, int * current_item, const char *const items[], int items_count, int popup_max_height_in_items) { return ::NS::ImGui::Combo(label, current_item, items, items_count, popup_max_height_in_items);}
bool  ImGui_Combo1(const char * label, int * current_item, const char * items_separated_by_zeros, int popup_max_height_in_items) { return ::NS::ImGui::Combo(label, current_item, items_separated_by_zeros, popup_max_height_in_items);}
bool  ImGui_Combo2(const char * label, int * current_item, const char *(*getter)(void *, int), void * user_data, int items_count, int popup_max_height_in_items) { return ::NS::ImGui::Combo(label, current_item, getter, user_data, items_count, popup_max_height_in_items);}
bool  ImGui_DragFloat(const char * label, float * v, float v_speed, float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::DragFloat(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragFloat2(const char * label, float v[2], float v_speed, float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::DragFloat2(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragFloat3(const char * label, float v[3], float v_speed, float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::DragFloat3(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragFloat4(const char * label, float v[4], float v_speed, float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::DragFloat4(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragFloatRange2(const char * label, float * v_current_min, float * v_current_max, float v_speed, float v_min, float v_max, const char * format, const char * format_max, ImGuiSliderFlags flags) { return ::NS::ImGui::DragFloatRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, flags);}
bool  ImGui_DragInt(const char * label, int * v, float v_speed, int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::DragInt(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragInt2(const char * label, int v[2], float v_speed, int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::DragInt2(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragInt3(const char * label, int v[3], float v_speed, int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::DragInt3(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragInt4(const char * label, int v[4], float v_speed, int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::DragInt4(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragIntRange2(const char * label, int * v_current_min, int * v_current_max, float v_speed, int v_min, int v_max, const char * format, const char * format_max, ImGuiSliderFlags flags) { return ::NS::ImGui::DragIntRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, flags);}
bool  ImGui_DragScalar(const char * label, ImGuiDataType data_type, void * p_data, float v_speed, const void * p_min, const void * p_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::DragScalar(label, data_type, p_data, v_speed, p_min, p_max, format, flags);}
bool  ImGui_DragScalarN(const char * label, ImGuiDataType data_type, void * p_data, int components, float v_speed, const void * p_min, const void * p_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::DragScalarN(label, data_type, p_data, components, v_speed, p_min, p_max, format, flags);}
bool  ImGui_SliderFloat(const char * label, float * v, float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::SliderFloat(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderFloat2(const char * label, float v[2], float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::SliderFloat2(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderFloat3(const char * label, float v[3], float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::SliderFloat3(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderFloat4(const char * label, float v[4], float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::SliderFloat4(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderAngle(const char * label, float * v_rad, float v_degrees_min, float v_degrees_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::SliderAngle(label, v_rad, v_degrees_min, v_degrees_max, format, flags);}
bool  ImGui_SliderInt(const char * label, int * v, int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::SliderInt(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderInt2(const char * label, int v[2], int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::SliderInt2(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderInt3(const char * label, int v[3], int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::SliderInt3(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderInt4(const char * label, int v[4], int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::SliderInt4(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderScalar(const char * label, ImGuiDataType data_type, void * p_data, const void * p_min, const void * p_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::SliderScalar(label, data_type, p_data, p_min, p_max, format, flags);}
bool  ImGui_SliderScalarN(const char * label, ImGuiDataType data_type, void * p_data, int components, const void * p_min, const void * p_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::SliderScalarN(label, data_type, p_data, components, p_min, p_max, format, flags);}
bool  ImGui_VSliderFloat(const char * label, const ImVec2 & size, float * v, float v_min, float v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::VSliderFloat(label, size, v, v_min, v_max, format, flags);}
bool  ImGui_VSliderInt(const char * label, const ImVec2 & size, int * v, int v_min, int v_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::VSliderInt(label, size, v, v_min, v_max, format, flags);}
bool  ImGui_VSliderScalar(const char * label, const ImVec2 & size, ImGuiDataType data_type, void * p_data, const void * p_min, const void * p_max, const char * format, ImGuiSliderFlags flags) { return ::NS::ImGui::VSliderScalar(label, size, data_type, p_data, p_min, p_max, format, flags);}
bool  ImGui_InputText(const char * label, char * buf, size_t buf_size, ImGuiInputTextFlags flags, ImGuiInputTextCallback callback, void * user_data) { return ::NS::ImGui::InputText(label, buf, buf_size, flags, callback, user_data);}
bool  ImGui_InputTextMultiline(const char * label, char * buf, size_t buf_size, const ImVec2 & size, ImGuiInputTextFlags flags, ImGuiInputTextCallback callback, void * user_data) { return ::NS::ImGui::InputTextMultiline(label, buf, buf_size, size, flags, callback, user_data);}
bool  ImGui_InputTextWithHint(const char * label, const char * hint, char * buf, size_t buf_size, ImGuiInputTextFlags flags, ImGuiInputTextCallback callback, void * user_data) { return ::NS::ImGui::InputTextWithHint(label, hint, buf, buf_size, flags, callback, user_data);}
bool  ImGui_InputFloat(const char * label, float * v, float step, float step_fast, const char * format, ImGuiInputTextFlags flags) { return ::NS::ImGui::InputFloat(label, v, step, step_fast, format, flags);}
bool  ImGui_InputFloat2(const char * label, float v[2], const char * format, ImGuiInputTextFlags flags) { return ::NS::ImGui::InputFloat2(label, v, format, flags);}
bool  ImGui_InputFloat3(const char * label, float v[3], const char * format, ImGuiInputTextFlags flags) { return ::NS::ImGui::InputFloat3(label, v, format, flags);}
bool  ImGui_InputFloat4(const char * label, float v[4], const char * format, ImGuiInputTextFlags flags) { return ::NS::ImGui::InputFloat4(label, v, format, flags);}
bool  ImGui_InputInt(const char * label, int * v, int step, int step_fast, ImGuiInputTextFlags flags) { return ::NS::ImGui::InputInt(label, v, step, step_fast, flags);}
bool  ImGui_InputInt2(const char * label, int v[2], ImGuiInputTextFlags flags) { return ::NS::ImGui::InputInt2(label, v, flags);}
bool  ImGui_InputInt3(const char * label, int v[3], ImGuiInputTextFlags flags) { return ::NS::ImGui::InputInt3(label, v, flags);}
bool  ImGui_InputInt4(const char * label, int v[4], ImGuiInputTextFlags flags) { return ::NS::ImGui::InputInt4(label, v, flags);}
bool  ImGui_InputDouble(const char * label, double * v, double step, double step_fast, const char * format, ImGuiInputTextFlags flags) { return ::NS::ImGui::InputDouble(label, v, step, step_fast, format, flags);}
bool  ImGui_InputScalar(const char * label, ImGuiDataType data_type, void * p_data, const void * p_step, const void * p_step_fast, const char * format, ImGuiInputTextFlags flags) { return ::NS::ImGui::InputScalar(label, data_type, p_data, p_step, p_step_fast, format, flags);}
bool  ImGui_InputScalarN(const char * label, ImGuiDataType data_type, void * p_data, int components, const void * p_step, const void * p_step_fast, const char * format, ImGuiInputTextFlags flags) { return ::NS::ImGui::InputScalarN(label, data_type, p_data, components, p_step, p_step_fast, format, flags);}
bool  ImGui_ColorEdit3(const char * label, float col[3], ImGuiColorEditFlags flags) { return ::NS::ImGui::ColorEdit3(label, col, flags);}
bool  ImGui_ColorEdit4(const char * label, float col[4], ImGuiColorEditFlags flags) { return ::NS::ImGui::ColorEdit4(label, col, flags);}
bool  ImGui_ColorPicker3(const char * label, float col[3], ImGuiColorEditFlags flags) { return ::NS::ImGui::ColorPicker3(label, col, flags);}
bool  ImGui_ColorPicker4(const char * label, float col[4], ImGuiColorEditFlags flags, const float * ref_col) { return ::NS::ImGui::ColorPicker4(label, col, flags, ref_col);}
bool  ImGui_ColorButton(const char * desc_id, const ImVec4 & col, ImGuiColorEditFlags flags, const ImVec2 & size) { return ::NS::ImGui::ColorButton(desc_id, col, flags, size);}
void  ImGui_SetColorEditOptions(ImGuiColorEditFlags flags) { return ::NS::ImGui::SetColorEditOptions(flags);}
bool  ImGui_TreeNode(const char * label) { return ::NS::ImGui::TreeNode(label);}
bool  ImGui_TreeNode1(const char * str_id, const char * fmt) { return ::NS::ImGui::TreeNode(str_id, fmt);}
bool  ImGui_TreeNode2(const void * ptr_id, const char * fmt) { return ::NS::ImGui::TreeNode(ptr_id, fmt);}
bool  ImGui_TreeNodeV(const char * str_id, const char * fmt, va_list args) { return ::NS::ImGui::TreeNodeV(str_id, fmt, args);}
bool  ImGui_TreeNodeV1(const void * ptr_id, const char * fmt, va_list args) { return ::NS::ImGui::TreeNodeV(ptr_id, fmt, args);}
bool  ImGui_TreeNodeEx(const char * label, ImGuiTreeNodeFlags flags) { return ::NS::ImGui::TreeNodeEx(label, flags);}
bool  ImGui_TreeNodeEx1(const char * str_id, ImGuiTreeNodeFlags flags, const char * fmt) { return ::NS::ImGui::TreeNodeEx(str_id, flags, fmt);}
bool  ImGui_TreeNodeEx2(const void * ptr_id, ImGuiTreeNodeFlags flags, const char * fmt) { return ::NS::ImGui::TreeNodeEx(ptr_id, flags, fmt);}
bool  ImGui_TreeNodeExV(const char * str_id, ImGuiTreeNodeFlags flags, const char * fmt, va_list args) { return ::NS::ImGui::TreeNodeExV(str_id, flags, fmt, args);}
bool  ImGui_TreeNodeExV1(const void * ptr_id, ImGuiTreeNodeFlags flags, const char * fmt, va_list args) { return ::NS::ImGui::TreeNodeExV(ptr_id, flags, fmt, args);}
void  ImGui_TreePush(const char * str_id) { return ::NS::ImGui::TreePush(str_id);}
void  ImGui_TreePush1(const void * ptr_id) { return ::NS::ImGui::TreePush(ptr_id);}
void  ImGui_TreePop() { return ::NS::ImGui::TreePop();}
float  ImGui_GetTreeNodeToLabelSpacing() { return ::NS::ImGui::GetTreeNodeToLabelSpacing();}
bool  ImGui_CollapsingHeader(const char * label, ImGuiTreeNodeFlags flags) { return ::NS::ImGui::CollapsingHeader(label, flags);}
bool  ImGui_CollapsingHeader1(const char * label, bool * p_visible, ImGuiTreeNodeFlags flags) { return ::NS::ImGui::CollapsingHeader(label, p_visible, flags);}
void  ImGui_SetNextItemOpen(bool is_open, ImGuiCond cond) { return ::NS::ImGui::SetNextItemOpen(is_open, cond);}
void  ImGui_SetNextItemStorageID(ImGuiID storage_id) { return ::NS::ImGui::SetNextItemStorageID(storage_id);}
bool  ImGui_Selectable(const char * label, bool selected, ImGuiSelectableFlags flags, const ImVec2 & size) { return ::NS::ImGui::Selectable(label, selected, flags, size);}
bool  ImGui_Selectable1(const char * label, bool * p_selected, ImGuiSelectableFlags flags, const ImVec2 & size) { return ::NS::ImGui::Selectable(label, p_selected, flags, size);}
ImGuiMultiSelectIO *  ImGui_BeginMultiSelect(ImGuiMultiSelectFlags flags, int selection_size, int items_count) { return reinterpret_cast<ImGuiMultiSelectIO * >(::NS::ImGui::BeginMultiSelect(flags, selection_size, items_count));}
ImGuiMultiSelectIO *  ImGui_EndMultiSelect() { return reinterpret_cast<ImGuiMultiSelectIO * >(::NS::ImGui::EndMultiSelect());}
void  ImGui_SetNextItemSelectionUserData(ImGuiSelectionUserData selection_user_data) { return ::NS::ImGui::SetNextItemSelectionUserData(selection_user_data);}
bool  ImGui_IsItemToggledSelection() { return ::NS::ImGui::IsItemToggledSelection();}
bool  ImGui_BeginListBox(const char * label, const ImVec2 & size) { return ::NS::ImGui::BeginListBox(label, size);}
void  ImGui_EndListBox() { return ::NS::ImGui::EndListBox();}
bool  ImGui_ListBox(const char * label, int * current_item, const char *const items[], int items_count, int height_in_items) { return ::NS::ImGui::ListBox(label, current_item, items, items_count, height_in_items);}
bool  ImGui_ListBox1(const char * label, int * current_item, const char *(*getter)(void *, int), void * user_data, int items_count, int height_in_items) { return ::NS::ImGui::ListBox(label, current_item, getter, user_data, items_count, height_in_items);}
void  ImGui_PlotLines(const char * label, const float * values, int values_count, int values_offset, const char * overlay_text, float scale_min, float scale_max, ImVec2 graph_size, int stride) { return ::NS::ImGui::PlotLines(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, std::bit_cast<::NS::ImVec2 >(graph_size), stride);}
void  ImGui_PlotLines1(const char * label, float (*values_getter)(void *, int), void * data, int values_count, int values_offset, const char * overlay_text, float scale_min, float scale_max, ImVec2 graph_size) { return ::NS::ImGui::PlotLines(label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, std::bit_cast<::NS::ImVec2 >(graph_size));}
void  ImGui_PlotHistogram(const char * label, const float * values, int values_count, int values_offset, const char * overlay_text, float scale_min, float scale_max, ImVec2 graph_size, int stride) { return ::NS::ImGui::PlotHistogram(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, std::bit_cast<::NS::ImVec2 >(graph_size), stride);}
void  ImGui_PlotHistogram1(const char * label, float (*values_getter)(void *, int), void * data, int values_count, int values_offset, const char * overlay_text, float scale_min, float scale_max, ImVec2 graph_size) { return ::NS::ImGui::PlotHistogram(label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, std::bit_cast<::NS::ImVec2 >(graph_size));}
void  ImGui_Value(const char * prefix, bool b) { return ::NS::ImGui::Value(prefix, b);}
void  ImGui_Value1(const char * prefix, int v) { return ::NS::ImGui::Value(prefix, v);}
void  ImGui_Value2(const char * prefix, unsigned int v) { return ::NS::ImGui::Value(prefix, v);}
void  ImGui_Value3(const char * prefix, float v, const char * float_format) { return ::NS::ImGui::Value(prefix, v, float_format);}
bool  ImGui_BeginMenuBar() { return ::NS::ImGui::BeginMenuBar();}
void  ImGui_EndMenuBar() { return ::NS::ImGui::EndMenuBar();}
bool  ImGui_BeginMainMenuBar() { return ::NS::ImGui::BeginMainMenuBar();}
void  ImGui_EndMainMenuBar() { return ::NS::ImGui::EndMainMenuBar();}
bool  ImGui_BeginMenu(const char * label, bool enabled) { return ::NS::ImGui::BeginMenu(label, enabled);}
void  ImGui_EndMenu() { return ::NS::ImGui::EndMenu();}
bool  ImGui_MenuItem(const char * label, const char * shortcut, bool selected, bool enabled) { return ::NS::ImGui::MenuItem(label, shortcut, selected, enabled);}
bool  ImGui_MenuItem1(const char * label, const char * shortcut, bool * p_selected, bool enabled) { return ::NS::ImGui::MenuItem(label, shortcut, p_selected, enabled);}
bool  ImGui_BeginTooltip() { return ::NS::ImGui::BeginTooltip();}
void  ImGui_EndTooltip() { return ::NS::ImGui::EndTooltip();}
void  ImGui_SetTooltip(const char * fmt) { return ::NS::ImGui::SetTooltip(fmt);}
void  ImGui_SetTooltipV(const char * fmt, va_list args) { return ::NS::ImGui::SetTooltipV(fmt, args);}
bool  ImGui_BeginItemTooltip() { return ::NS::ImGui::BeginItemTooltip();}
void  ImGui_SetItemTooltip(const char * fmt) { return ::NS::ImGui::SetItemTooltip(fmt);}
void  ImGui_SetItemTooltipV(const char * fmt, va_list args) { return ::NS::ImGui::SetItemTooltipV(fmt, args);}
bool  ImGui_BeginPopup(const char * str_id, ImGuiWindowFlags flags) { return ::NS::ImGui::BeginPopup(str_id, flags);}
bool  ImGui_BeginPopupModal(const char * name, bool * p_open, ImGuiWindowFlags flags) { return ::NS::ImGui::BeginPopupModal(name, p_open, flags);}
void  ImGui_EndPopup() { return ::NS::ImGui::EndPopup();}
void  ImGui_OpenPopup(const char * str_id, ImGuiPopupFlags popup_flags) { return ::NS::ImGui::OpenPopup(str_id, popup_flags);}
void  ImGui_OpenPopup1(ImGuiID id, ImGuiPopupFlags popup_flags) { return ::NS::ImGui::OpenPopup(id, popup_flags);}
void  ImGui_OpenPopupOnItemClick(const char * str_id, ImGuiPopupFlags popup_flags) { return ::NS::ImGui::OpenPopupOnItemClick(str_id, popup_flags);}
void  ImGui_CloseCurrentPopup() { return ::NS::ImGui::CloseCurrentPopup();}
bool  ImGui_BeginPopupContextItem(const char * str_id, ImGuiPopupFlags popup_flags) { return ::NS::ImGui::BeginPopupContextItem(str_id, popup_flags);}
bool  ImGui_BeginPopupContextWindow(const char * str_id, ImGuiPopupFlags popup_flags) { return ::NS::ImGui::BeginPopupContextWindow(str_id, popup_flags);}
bool  ImGui_BeginPopupContextVoid(const char * str_id, ImGuiPopupFlags popup_flags) { return ::NS::ImGui::BeginPopupContextVoid(str_id, popup_flags);}
bool  ImGui_IsPopupOpen(const char * str_id, ImGuiPopupFlags flags) { return ::NS::ImGui::IsPopupOpen(str_id, flags);}
bool  ImGui_BeginTable(const char * str_id, int columns, ImGuiTableFlags flags, const ImVec2 & outer_size, float inner_width) { return ::NS::ImGui::BeginTable(str_id, columns, flags, outer_size, inner_width);}
void  ImGui_EndTable() { return ::NS::ImGui::EndTable();}
void  ImGui_TableNextRow(ImGuiTableRowFlags row_flags, float min_row_height) { return ::NS::ImGui::TableNextRow(row_flags, min_row_height);}
bool  ImGui_TableNextColumn() { return ::NS::ImGui::TableNextColumn();}
bool  ImGui_TableSetColumnIndex(int column_n) { return ::NS::ImGui::TableSetColumnIndex(column_n);}
void  ImGui_TableSetupColumn(const char * label, ImGuiTableColumnFlags flags, float init_width_or_weight, ImGuiID user_id) { return ::NS::ImGui::TableSetupColumn(label, flags, init_width_or_weight, user_id);}
void  ImGui_TableSetupScrollFreeze(int cols, int rows) { return ::NS::ImGui::TableSetupScrollFreeze(cols, rows);}
void  ImGui_TableHeader(const char * label) { return ::NS::ImGui::TableHeader(label);}
void  ImGui_TableHeadersRow() { return ::NS::ImGui::TableHeadersRow();}
void  ImGui_TableAngledHeadersRow() { return ::NS::ImGui::TableAngledHeadersRow();}
ImGuiTableSortSpecs *  ImGui_TableGetSortSpecs() { return reinterpret_cast<ImGuiTableSortSpecs * >(::NS::ImGui::TableGetSortSpecs());}
int  ImGui_TableGetColumnCount() { return ::NS::ImGui::TableGetColumnCount();}
int  ImGui_TableGetColumnIndex() { return ::NS::ImGui::TableGetColumnIndex();}
int  ImGui_TableGetRowIndex() { return ::NS::ImGui::TableGetRowIndex();}
const char *  ImGui_TableGetColumnName(int column_n) { return reinterpret_cast<const char * >(::NS::ImGui::TableGetColumnName(column_n));}
ImGuiTableColumnFlags  ImGui_TableGetColumnFlags(int column_n) { return ::NS::ImGui::TableGetColumnFlags(column_n);}
void  ImGui_TableSetColumnEnabled(int column_n, bool v) { return ::NS::ImGui::TableSetColumnEnabled(column_n, v);}
int  ImGui_TableGetHoveredColumn() { return ::NS::ImGui::TableGetHoveredColumn();}
void  ImGui_TableSetBgColor(ImGuiTableBgTarget target, ImU32 color, int column_n) { return ::NS::ImGui::TableSetBgColor(target, color, column_n);}
void  ImGui_Columns(int count, const char * id, bool borders) { return ::NS::ImGui::Columns(count, id, borders);}
void  ImGui_NextColumn() { return ::NS::ImGui::NextColumn();}
int  ImGui_GetColumnIndex() { return ::NS::ImGui::GetColumnIndex();}
float  ImGui_GetColumnWidth(int column_index) { return ::NS::ImGui::GetColumnWidth(column_index);}
void  ImGui_SetColumnWidth(int column_index, float width) { return ::NS::ImGui::SetColumnWidth(column_index, width);}
float  ImGui_GetColumnOffset(int column_index) { return ::NS::ImGui::GetColumnOffset(column_index);}
void  ImGui_SetColumnOffset(int column_index, float offset_x) { return ::NS::ImGui::SetColumnOffset(column_index, offset_x);}
int  ImGui_GetColumnsCount() { return ::NS::ImGui::GetColumnsCount();}
bool  ImGui_BeginTabBar(const char * str_id, ImGuiTabBarFlags flags) { return ::NS::ImGui::BeginTabBar(str_id, flags);}
void  ImGui_EndTabBar() { return ::NS::ImGui::EndTabBar();}
bool  ImGui_BeginTabItem(const char * label, bool * p_open, ImGuiTabItemFlags flags) { return ::NS::ImGui::BeginTabItem(label, p_open, flags);}
void  ImGui_EndTabItem() { return ::NS::ImGui::EndTabItem();}
bool  ImGui_TabItemButton(const char * label, ImGuiTabItemFlags flags) { return ::NS::ImGui::TabItemButton(label, flags);}
void  ImGui_SetTabItemClosed(const char * tab_or_docked_window_label) { return ::NS::ImGui::SetTabItemClosed(tab_or_docked_window_label);}
void  ImGui_LogToTTY(int auto_open_depth) { return ::NS::ImGui::LogToTTY(auto_open_depth);}
void  ImGui_LogToFile(int auto_open_depth, const char * filename) { return ::NS::ImGui::LogToFile(auto_open_depth, filename);}
void  ImGui_LogToClipboard(int auto_open_depth) { return ::NS::ImGui::LogToClipboard(auto_open_depth);}
void  ImGui_LogFinish() { return ::NS::ImGui::LogFinish();}
void  ImGui_LogButtons() { return ::NS::ImGui::LogButtons();}
void  ImGui_LogText(const char * fmt) { return ::NS::ImGui::LogText(fmt);}
void  ImGui_LogTextV(const char * fmt, va_list args) { return ::NS::ImGui::LogTextV(fmt, args);}
bool  ImGui_BeginDragDropSource(ImGuiDragDropFlags flags) { return ::NS::ImGui::BeginDragDropSource(flags);}
bool  ImGui_SetDragDropPayload(const char * type, const void * data, size_t sz, ImGuiCond cond) { return ::NS::ImGui::SetDragDropPayload(type, data, sz, cond);}
void  ImGui_EndDragDropSource() { return ::NS::ImGui::EndDragDropSource();}
bool  ImGui_BeginDragDropTarget() { return ::NS::ImGui::BeginDragDropTarget();}
const ImGuiPayload *  ImGui_AcceptDragDropPayload(const char * type, ImGuiDragDropFlags flags) { return reinterpret_cast<const ImGuiPayload * >(::NS::ImGui::AcceptDragDropPayload(type, flags));}
void  ImGui_EndDragDropTarget() { return ::NS::ImGui::EndDragDropTarget();}
const ImGuiPayload *  ImGui_GetDragDropPayload() { return reinterpret_cast<const ImGuiPayload * >(::NS::ImGui::GetDragDropPayload());}
void  ImGui_BeginDisabled(bool disabled) { return ::NS::ImGui::BeginDisabled(disabled);}
void  ImGui_EndDisabled() { return ::NS::ImGui::EndDisabled();}
void  ImGui_PushClipRect(const ImVec2 & clip_rect_min, const ImVec2 & clip_rect_max, bool intersect_with_current_clip_rect) { return ::NS::ImGui::PushClipRect(clip_rect_min, clip_rect_max, intersect_with_current_clip_rect);}
void  ImGui_PopClipRect() { return ::NS::ImGui::PopClipRect();}
void  ImGui_SetItemDefaultFocus() { return ::NS::ImGui::SetItemDefaultFocus();}
void  ImGui_SetKeyboardFocusHere(int offset) { return ::NS::ImGui::SetKeyboardFocusHere(offset);}
void  ImGui_SetNavCursorVisible(bool visible) { return ::NS::ImGui::SetNavCursorVisible(visible);}
void  ImGui_SetNextItemAllowOverlap() { return ::NS::ImGui::SetNextItemAllowOverlap();}
bool  ImGui_IsItemHovered(ImGuiHoveredFlags flags) { return ::NS::ImGui::IsItemHovered(flags);}
bool  ImGui_IsItemActive() { return ::NS::ImGui::IsItemActive();}
bool  ImGui_IsItemFocused() { return ::NS::ImGui::IsItemFocused();}
bool  ImGui_IsItemClicked(ImGuiMouseButton mouse_button) { return ::NS::ImGui::IsItemClicked(mouse_button);}
bool  ImGui_IsItemVisible() { return ::NS::ImGui::IsItemVisible();}
bool  ImGui_IsItemEdited() { return ::NS::ImGui::IsItemEdited();}
bool  ImGui_IsItemActivated() { return ::NS::ImGui::IsItemActivated();}
bool  ImGui_IsItemDeactivated() { return ::NS::ImGui::IsItemDeactivated();}
bool  ImGui_IsItemDeactivatedAfterEdit() { return ::NS::ImGui::IsItemDeactivatedAfterEdit();}
bool  ImGui_IsItemToggledOpen() { return ::NS::ImGui::IsItemToggledOpen();}
bool  ImGui_IsAnyItemHovered() { return ::NS::ImGui::IsAnyItemHovered();}
bool  ImGui_IsAnyItemActive() { return ::NS::ImGui::IsAnyItemActive();}
bool  ImGui_IsAnyItemFocused() { return ::NS::ImGui::IsAnyItemFocused();}
ImGuiID  ImGui_GetItemID() { return ::NS::ImGui::GetItemID();}
ImVec2  ImGui_GetItemRectMin() { return std::bit_cast<ImVec2>(::NS::ImGui::GetItemRectMin());}
ImVec2  ImGui_GetItemRectMax() { return std::bit_cast<ImVec2>(::NS::ImGui::GetItemRectMax());}
ImVec2  ImGui_GetItemRectSize() { return std::bit_cast<ImVec2>(::NS::ImGui::GetItemRectSize());}
ImGuiViewport *  ImGui_GetMainViewport() { return reinterpret_cast<ImGuiViewport * >(::NS::ImGui::GetMainViewport());}
ImDrawList *  ImGui_GetBackgroundDrawList() { return reinterpret_cast<ImDrawList * >(::NS::ImGui::GetBackgroundDrawList());}
ImDrawList *  ImGui_GetForegroundDrawList() { return reinterpret_cast<ImDrawList * >(::NS::ImGui::GetForegroundDrawList());}
bool  ImGui_IsRectVisible(const ImVec2 & size) { return ::NS::ImGui::IsRectVisible(size);}
bool  ImGui_IsRectVisible1(const ImVec2 & rect_min, const ImVec2 & rect_max) { return ::NS::ImGui::IsRectVisible(rect_min, rect_max);}
double  ImGui_GetTime() { return ::NS::ImGui::GetTime();}
int  ImGui_GetFrameCount() { return ::NS::ImGui::GetFrameCount();}
ImDrawListSharedData *  ImGui_GetDrawListSharedData() { return reinterpret_cast<ImDrawListSharedData * >(::NS::ImGui::GetDrawListSharedData());}
const char *  ImGui_GetStyleColorName(ImGuiCol idx) { return reinterpret_cast<const char * >(::NS::ImGui::GetStyleColorName(idx));}
void  ImGui_SetStateStorage(ImGuiStorage * storage) { return ::NS::ImGui::SetStateStorage(reinterpret_cast<::NS::ImGuiStorage * >(storage));}
ImGuiStorage *  ImGui_GetStateStorage() { return reinterpret_cast<ImGuiStorage * >(::NS::ImGui::GetStateStorage());}
ImVec2  ImGui_CalcTextSize(const char * text, const char * text_end, bool hide_text_after_double_hash, float wrap_width) { return std::bit_cast<ImVec2>(::NS::ImGui::CalcTextSize(text, text_end, hide_text_after_double_hash, wrap_width));}
ImVec4  ImGui_ColorConvertU32ToFloat4(ImU32 in) { return std::bit_cast<ImVec4>(::NS::ImGui::ColorConvertU32ToFloat4(in));}
ImU32  ImGui_ColorConvertFloat4ToU32(const ImVec4 & in) { return ::NS::ImGui::ColorConvertFloat4ToU32(in);}
void  ImGui_ColorConvertRGBtoHSV(float r, float g, float b, float & out_h, float & out_s, float & out_v) { return ::NS::ImGui::ColorConvertRGBtoHSV(r, g, b, out_h, out_s, out_v);}
void  ImGui_ColorConvertHSVtoRGB(float h, float s, float v, float & out_r, float & out_g, float & out_b) { return ::NS::ImGui::ColorConvertHSVtoRGB(h, s, v, out_r, out_g, out_b);}
bool  ImGui_IsKeyDown(ImGuiKey key) { return ::NS::ImGui::IsKeyDown(std::bit_cast<::NS::ImGuiKey >(key));}
bool  ImGui_IsKeyPressed(ImGuiKey key, bool repeat) { return ::NS::ImGui::IsKeyPressed(std::bit_cast<::NS::ImGuiKey >(key), repeat);}
bool  ImGui_IsKeyReleased(ImGuiKey key) { return ::NS::ImGui::IsKeyReleased(std::bit_cast<::NS::ImGuiKey >(key));}
bool  ImGui_IsKeyChordPressed(ImGuiKeyChord key_chord) { return ::NS::ImGui::IsKeyChordPressed(key_chord);}
int  ImGui_GetKeyPressedAmount(ImGuiKey key, float repeat_delay, float rate) { return ::NS::ImGui::GetKeyPressedAmount(std::bit_cast<::NS::ImGuiKey >(key), repeat_delay, rate);}
const char *  ImGui_GetKeyName(ImGuiKey key) { return reinterpret_cast<const char * >(::NS::ImGui::GetKeyName(std::bit_cast<::NS::ImGuiKey >(key)));}
void  ImGui_SetNextFrameWantCaptureKeyboard(bool want_capture_keyboard) { return ::NS::ImGui::SetNextFrameWantCaptureKeyboard(want_capture_keyboard);}
bool  ImGui_Shortcut(ImGuiKeyChord key_chord, ImGuiInputFlags flags) { return ::NS::ImGui::Shortcut(key_chord, flags);}
void  ImGui_SetNextItemShortcut(ImGuiKeyChord key_chord, ImGuiInputFlags flags) { return ::NS::ImGui::SetNextItemShortcut(key_chord, flags);}
void  ImGui_SetItemKeyOwner(ImGuiKey key) { return ::NS::ImGui::SetItemKeyOwner(std::bit_cast<::NS::ImGuiKey >(key));}
bool  ImGui_IsMouseDown(ImGuiMouseButton button) { return ::NS::ImGui::IsMouseDown(button);}
bool  ImGui_IsMouseClicked(ImGuiMouseButton button, bool repeat) { return ::NS::ImGui::IsMouseClicked(button, repeat);}
bool  ImGui_IsMouseReleased(ImGuiMouseButton button) { return ::NS::ImGui::IsMouseReleased(button);}
bool  ImGui_IsMouseDoubleClicked(ImGuiMouseButton button) { return ::NS::ImGui::IsMouseDoubleClicked(button);}
bool  ImGui_IsMouseReleasedWithDelay(ImGuiMouseButton button, float delay) { return ::NS::ImGui::IsMouseReleasedWithDelay(button, delay);}
int  ImGui_GetMouseClickedCount(ImGuiMouseButton button) { return ::NS::ImGui::GetMouseClickedCount(button);}
bool  ImGui_IsMouseHoveringRect(const ImVec2 & r_min, const ImVec2 & r_max, bool clip) { return ::NS::ImGui::IsMouseHoveringRect(r_min, r_max, clip);}
bool  ImGui_IsMousePosValid(const ImVec2 * mouse_pos) { return ::NS::ImGui::IsMousePosValid(reinterpret_cast<const ::NS::ImVec2 * >(mouse_pos));}
bool  ImGui_IsAnyMouseDown() { return ::NS::ImGui::IsAnyMouseDown();}
ImVec2  ImGui_GetMousePos() { return std::bit_cast<ImVec2>(::NS::ImGui::GetMousePos());}
ImVec2  ImGui_GetMousePosOnOpeningCurrentPopup() { return std::bit_cast<ImVec2>(::NS::ImGui::GetMousePosOnOpeningCurrentPopup());}
bool  ImGui_IsMouseDragging(ImGuiMouseButton button, float lock_threshold) { return ::NS::ImGui::IsMouseDragging(button, lock_threshold);}
ImVec2  ImGui_GetMouseDragDelta(ImGuiMouseButton button, float lock_threshold) { return std::bit_cast<ImVec2>(::NS::ImGui::GetMouseDragDelta(button, lock_threshold));}
void  ImGui_ResetMouseDragDelta(ImGuiMouseButton button) { return ::NS::ImGui::ResetMouseDragDelta(button);}
ImGuiMouseCursor  ImGui_GetMouseCursor() { return ::NS::ImGui::GetMouseCursor();}
void  ImGui_SetMouseCursor(ImGuiMouseCursor cursor_type) { return ::NS::ImGui::SetMouseCursor(cursor_type);}
void  ImGui_SetNextFrameWantCaptureMouse(bool want_capture_mouse) { return ::NS::ImGui::SetNextFrameWantCaptureMouse(want_capture_mouse);}
const char *  ImGui_GetClipboardText() { return reinterpret_cast<const char * >(::NS::ImGui::GetClipboardText());}
void  ImGui_SetClipboardText(const char * text) { return ::NS::ImGui::SetClipboardText(text);}
void  ImGui_LoadIniSettingsFromDisk(const char * ini_filename) { return ::NS::ImGui::LoadIniSettingsFromDisk(ini_filename);}
void  ImGui_LoadIniSettingsFromMemory(const char * ini_data, size_t ini_size) { return ::NS::ImGui::LoadIniSettingsFromMemory(ini_data, ini_size);}
void  ImGui_SaveIniSettingsToDisk(const char * ini_filename) { return ::NS::ImGui::SaveIniSettingsToDisk(ini_filename);}
const char *  ImGui_SaveIniSettingsToMemory(size_t * out_ini_size) { return reinterpret_cast<const char * >(::NS::ImGui::SaveIniSettingsToMemory(out_ini_size));}
void  ImGui_DebugTextEncoding(const char * text) { return ::NS::ImGui::DebugTextEncoding(text);}
void  ImGui_DebugFlashStyleColor(ImGuiCol idx) { return ::NS::ImGui::DebugFlashStyleColor(idx);}
void  ImGui_DebugStartItemPicker() { return ::NS::ImGui::DebugStartItemPicker();}
bool  ImGui_DebugCheckVersionAndDataLayout(const char * version_str, size_t sz_io, size_t sz_style, size_t sz_vec2, size_t sz_vec4, size_t sz_drawvert, size_t sz_drawidx) { return ::NS::ImGui::DebugCheckVersionAndDataLayout(version_str, sz_io, sz_style, sz_vec2, sz_vec4, sz_drawvert, sz_drawidx);}
void  ImGui_DebugLog(const char * fmt) { return ::NS::ImGui::DebugLog(fmt);}
void  ImGui_DebugLogV(const char * fmt, va_list args) { return ::NS::ImGui::DebugLogV(fmt, args);}
void  ImGui_SetAllocatorFunctions(ImGuiMemAllocFunc alloc_func, ImGuiMemFreeFunc free_func, void * user_data) { return ::NS::ImGui::SetAllocatorFunctions(alloc_func, free_func, user_data);}
void  ImGui_GetAllocatorFunctions(ImGuiMemAllocFunc * p_alloc_func, ImGuiMemFreeFunc * p_free_func, void ** p_user_data) { return ::NS::ImGui::GetAllocatorFunctions(p_alloc_func, p_free_func, p_user_data);}
void *  ImGui_MemAlloc(size_t size) { return reinterpret_cast<void * >(::NS::ImGui::MemAlloc(size));}
void  ImGui_MemFree(void * ptr) { return ::NS::ImGui::MemFree(ptr);}
enum ImGuiWindowFlags_ {
};
enum ImGuiChildFlags_ {
};
enum ImGuiItemFlags_ {
};
enum ImGuiInputTextFlags_ {
};
enum ImGuiTreeNodeFlags_ {
};
enum ImGuiPopupFlags_ {
};
enum ImGuiSelectableFlags_ {
};
enum ImGuiComboFlags_ {
};
enum ImGuiTabBarFlags_ {
};
enum ImGuiTabItemFlags_ {
};
enum ImGuiFocusedFlags_ {
};
enum ImGuiHoveredFlags_ {
};
enum ImGuiDragDropFlags_ {
};
enum ImGuiDataType_ {
};
enum ImGuiDir {
};
enum ImGuiSortDirection {
};
enum ImGuiKey {
};
enum ImGuiInputFlags_ {
};
enum ImGuiConfigFlags_ {
};
enum ImGuiBackendFlags_ {
};
enum ImGuiCol_ {
};
enum ImGuiStyleVar_ {
};
enum ImGuiButtonFlags_ {
};
enum ImGuiColorEditFlags_ {
};
enum ImGuiSliderFlags_ {
};
enum ImGuiMouseButton_ {
};
enum ImGuiMouseCursor_ {
};
enum ImGuiMouseSource {
};
enum ImGuiCond_ {
};
enum ImGuiTableFlags_ {
};
enum ImGuiTableColumnFlags_ {
};
enum ImGuiTableRowFlags_ {
};
enum ImGuiTableBgTarget_ {
};
struct ImGuiTableSortSpecs {
const ImGuiTableColumnSortSpecs * Specs;
int SpecsCount;
bool SpecsDirty;
};
struct ImGuiTableColumnSortSpecs {
ImGuiID ColumnUserID;
ImS16 ColumnIndex;
ImS16 SortOrder;
ImGuiSortDirection SortDirection;
};
typedef struct ImNewWrapper ImNewWrapper;
struct ImGuiStyle {
float FontSizeBase;
float FontScaleMain;
float FontScaleDpi;
float Alpha;
float DisabledAlpha;
ImVec2 WindowPadding;
float WindowRounding;
float WindowBorderSize;
float WindowBorderHoverPadding;
ImVec2 WindowMinSize;
ImVec2 WindowTitleAlign;
ImGuiDir WindowMenuButtonPosition;
float ChildRounding;
float ChildBorderSize;
float PopupRounding;
float PopupBorderSize;
ImVec2 FramePadding;
float FrameRounding;
float FrameBorderSize;
ImVec2 ItemSpacing;
ImVec2 ItemInnerSpacing;
ImVec2 CellPadding;
ImVec2 TouchExtraPadding;
float IndentSpacing;
float ColumnsMinSpacing;
float ScrollbarSize;
float ScrollbarRounding;
float GrabMinSize;
float GrabRounding;
float LogSliderDeadzone;
float ImageBorderSize;
float TabRounding;
float TabBorderSize;
float TabCloseButtonMinWidthSelected;
float TabCloseButtonMinWidthUnselected;
float TabBarBorderSize;
float TabBarOverlineSize;
float TableAngledHeadersAngle;
ImVec2 TableAngledHeadersTextAlign;
ImGuiTreeNodeFlags TreeLinesFlags;
float TreeLinesSize;
float TreeLinesRounding;
ImGuiDir ColorButtonPosition;
ImVec2 ButtonTextAlign;
ImVec2 SelectableTextAlign;
float SeparatorTextBorderSize;
ImVec2 SeparatorTextAlign;
ImVec2 SeparatorTextPadding;
ImVec2 DisplayWindowPadding;
ImVec2 DisplaySafeAreaPadding;
float MouseCursorScale;
bool AntiAliasedLines;
bool AntiAliasedLinesUseTex;
bool AntiAliasedFill;
float CurveTessellationTol;
float CircleTessellationMaxError;
ImVec4 Colors[58];
float HoverStationaryDelay;
float HoverDelayShort;
float HoverDelayNormal;
ImGuiHoveredFlags HoverFlagsForTooltipMouse;
ImGuiHoveredFlags HoverFlagsForTooltipNav;
float _MainScale;
float _NextFrameFontSizeBase;
};
struct ImGuiKeyData {
bool Down;
float DownDuration;
float DownDurationPrev;
float AnalogValue;
};
struct ImGuiIO {
ImGuiConfigFlags ConfigFlags;
ImGuiBackendFlags BackendFlags;
ImVec2 DisplaySize;
ImVec2 DisplayFramebufferScale;
float DeltaTime;
float IniSavingRate;
const char * IniFilename;
const char * LogFilename;
void * UserData;
ImFontAtlas * Fonts;
ImFont * FontDefault;
bool FontAllowUserScaling;
bool ConfigNavSwapGamepadButtons;
bool ConfigNavMoveSetMousePos;
bool ConfigNavCaptureKeyboard;
bool ConfigNavEscapeClearFocusItem;
bool ConfigNavEscapeClearFocusWindow;
bool ConfigNavCursorVisibleAuto;
bool ConfigNavCursorVisibleAlways;
bool MouseDrawCursor;
bool ConfigMacOSXBehaviors;
bool ConfigInputTrickleEventQueue;
bool ConfigInputTextCursorBlink;
bool ConfigInputTextEnterKeepActive;
bool ConfigDragClickToInputText;
bool ConfigWindowsResizeFromEdges;
bool ConfigWindowsMoveFromTitleBarOnly;
bool ConfigWindowsCopyContentsWithCtrlC;
bool ConfigScrollbarScrollByPage;
float ConfigMemoryCompactTimer;
float MouseDoubleClickTime;
float MouseDoubleClickMaxDist;
float MouseDragThreshold;
float KeyRepeatDelay;
float KeyRepeatRate;
bool ConfigErrorRecovery;
bool ConfigErrorRecoveryEnableAssert;
bool ConfigErrorRecoveryEnableDebugLog;
bool ConfigErrorRecoveryEnableTooltip;
bool ConfigDebugIsDebuggerPresent;
bool ConfigDebugHighlightIdConflicts;
bool ConfigDebugHighlightIdConflictsShowItemPicker;
bool ConfigDebugBeginReturnValueOnce;
bool ConfigDebugBeginReturnValueLoop;
bool ConfigDebugIgnoreFocusLoss;
bool ConfigDebugIniSettings;
const char * BackendPlatformName;
const char * BackendRendererName;
void * BackendPlatformUserData;
void * BackendRendererUserData;
void * BackendLanguageUserData;
bool WantCaptureMouse;
bool WantCaptureKeyboard;
bool WantTextInput;
bool WantSetMousePos;
bool WantSaveIniSettings;
bool NavActive;
bool NavVisible;
float Framerate;
int MetricsRenderVertices;
int MetricsRenderIndices;
int MetricsRenderWindows;
int MetricsActiveWindows;
ImVec2 MouseDelta;
ImGuiContext * Ctx;
ImVec2 MousePos;
bool MouseDown[5];
float MouseWheel;
float MouseWheelH;
ImGuiMouseSource MouseSource;
bool KeyCtrl;
bool KeyShift;
bool KeyAlt;
bool KeySuper;
ImGuiKeyChord KeyMods;
ImGuiKeyData KeysData[155];
bool WantCaptureMouseUnlessPopupClose;
ImVec2 MousePosPrev;
ImVec2 MouseClickedPos[5];
double MouseClickedTime[5];
bool MouseClicked[5];
bool MouseDoubleClicked[5];
ImU16 MouseClickedCount[5];
ImU16 MouseClickedLastCount[5];
bool MouseReleased[5];
double MouseReleasedTime[5];
bool MouseDownOwned[5];
bool MouseDownOwnedUnlessPopupClose[5];
bool MouseWheelRequestAxisSwap;
bool MouseCtrlLeftAsRightClick;
float MouseDownDuration[5];
float MouseDownDurationPrev[5];
float MouseDragMaxDistanceSqr[5];
float PenPressure;
bool AppFocusLost;
bool AppAcceptingEvents;
ImWchar16 InputQueueSurrogate;
void * InputQueueCharacters;
};
struct ImGuiInputTextCallbackData {
ImGuiContext * Ctx;
ImGuiInputTextFlags EventFlag;
ImGuiInputTextFlags Flags;
void * UserData;
ImWchar EventChar;
ImGuiKey EventKey;
char * Buf;
int BufTextLen;
int BufSize;
bool BufDirty;
int CursorPos;
int SelectionStart;
int SelectionEnd;
};
struct ImGuiSizeCallbackData {
void * UserData;
ImVec2 Pos;
ImVec2 CurrentSize;
ImVec2 DesiredSize;
};
struct ImGuiPayload {
void * Data;
int DataSize;
ImGuiID SourceId;
ImGuiID SourceParentId;
int DataFrameCount;
char DataType[33];
bool Preview;
bool Delivery;
};
struct ImGuiOnceUponAFrame {
int RefFrame;
};
struct ImGuiTextFilter {
char InputBuf[256];
void * Filters;
int CountGrep;
};
struct ImGuiTextRange {
const char * b;
const char * e;
};
struct ImGuiTextBuffer {
void * Buf;
};
struct ImGuiStoragePair {
ImGuiID key;
};
struct ImGuiStorage {
void * Data;
};
struct ImGuiListClipper {
ImGuiContext * Ctx;
int DisplayStart;
int DisplayEnd;
int ItemsCount;
float ItemsHeight;
double StartPosY;
double StartSeekOffsetY;
void * TempData;
};
struct ImColor {
ImVec4 Value;
};
enum ImGuiMultiSelectFlags_ {
};
struct ImGuiMultiSelectIO {
void * Requests;
ImGuiSelectionUserData RangeSrcItem;
ImGuiSelectionUserData NavIdItem;
bool NavIdSelected;
bool RangeSrcReset;
int ItemsCount;
};
enum ImGuiSelectionRequestType {
};
struct ImGuiSelectionRequest {
ImGuiSelectionRequestType Type;
bool Selected;
ImS8 RangeDirection;
ImGuiSelectionUserData RangeFirstItem;
ImGuiSelectionUserData RangeLastItem;
};
struct ImGuiSelectionBasicStorage {
int Size;
bool PreserveOrder;
void * UserData;
ImGuiID (*AdapterIndexToStorageId)(ImGuiSelectionBasicStorage *, int);
int _SelectionOrder;
ImGuiStorage _Storage;
};
struct ImGuiSelectionExternalStorage {
void * UserData;
void (*AdapterSetItemSelected)(ImGuiSelectionExternalStorage *, int, bool);
};
typedef unsigned short Better_ImDrawIdx;
typedef ::NS::ImDrawCallback ImDrawCallback;
struct ImDrawCmd {
ImVec4 ClipRect;
ImTextureRef TexRef;
unsigned int VtxOffset;
unsigned int IdxOffset;
unsigned int ElemCount;
ImDrawCallback UserCallback;
void * UserCallbackData;
int UserCallbackDataSize;
int UserCallbackDataOffset;
};
struct ImDrawVert {
ImVec2 pos;
ImVec2 uv;
ImU32 col;
};
struct ImDrawCmdHeader {
ImVec4 ClipRect;
ImTextureRef TexRef;
unsigned int VtxOffset;
};
struct ImDrawChannel {
void * _CmdBuffer;
void * _IdxBuffer;
};
struct ImDrawListSplitter {
int _Current;
int _Count;
void * _Channels;
};
enum ImDrawFlags_ {
};
enum ImDrawListFlags_ {
};
struct ImDrawList {
void * CmdBuffer;
void * IdxBuffer;
void * VtxBuffer;
ImDrawListFlags Flags;
unsigned int _VtxCurrentIdx;
ImDrawListSharedData * _Data;
ImDrawVert * _VtxWritePtr;
ImDrawIdx * _IdxWritePtr;
void * _Path;
ImDrawCmdHeader _CmdHeader;
ImDrawListSplitter _Splitter;
void * _ClipRectStack;
void * _TextureStack;
void * _CallbacksDataBuf;
float _FringeScale;
const char * _OwnerName;
};
struct ImDrawData {
bool Valid;
int CmdListsCount;
int TotalIdxCount;
int TotalVtxCount;
void * CmdLists;
ImVec2 DisplayPos;
ImVec2 DisplaySize;
ImVec2 FramebufferScale;
ImGuiViewport * OwnerViewport;
void **Textures;
};
enum ImTextureFormat {
};
enum ImTextureStatus {
};
struct ImTextureRect {
unsigned short x;
unsigned short y;
unsigned short w;
unsigned short h;
};
struct ImTextureData {
int UniqueID;
ImTextureStatus Status;
void * BackendUserData;
ImTextureID TexID;
ImTextureFormat Format;
int Width;
int Height;
int BytesPerPixel;
unsigned char * Pixels;
ImTextureRect UsedRect;
ImTextureRect UpdateRect;
void * Updates;
int UnusedFrames;
unsigned short RefCount;
bool UseColors;
bool WantDestroyNextFrame;
};
struct ImFontConfig {
char Name[40];
void * FontData;
int FontDataSize;
bool FontDataOwnedByAtlas;
bool MergeMode;
bool PixelSnapH;
bool PixelSnapV;
ImS8 OversampleH;
ImS8 OversampleV;
ImWchar EllipsisChar;
float SizePixels;
const ImWchar * GlyphRanges;
const ImWchar * GlyphExcludeRanges;
ImVec2 GlyphOffset;
float GlyphMinAdvanceX;
float GlyphMaxAdvanceX;
float GlyphExtraAdvanceX;
ImU32 FontNo;
unsigned int FontLoaderFlags;
float RasterizerMultiply;
float RasterizerDensity;
ImFontFlags Flags;
ImFont * DstFont;
const ImFontLoader * FontLoader;
void * FontLoaderData;
};
struct ImFontGlyph {
unsigned int Colored;
unsigned int Visible;
unsigned int SourceIdx;
unsigned int Codepoint;
float AdvanceX;
float X0;
float Y0;
float X1;
float Y1;
float U0;
float V0;
float U1;
float V1;
int PackId;
};
struct ImFontGlyphRangesBuilder {
void * UsedChars;
};
typedef int Better_ImFontAtlasRectId;
struct ImFontAtlasRect {
unsigned short x;
unsigned short y;
unsigned short w;
unsigned short h;
ImVec2 uv0;
ImVec2 uv1;
};
enum ImFontAtlasFlags_ {
};
struct ImFontAtlas {
ImFontAtlasFlags Flags;
ImTextureFormat TexDesiredFormat;
int TexGlyphPadding;
int TexMinWidth;
int TexMinHeight;
int TexMaxWidth;
int TexMaxHeight;
void * UserData;
ImTextureRef TexRef;
ImTextureData * TexData;
void * TexList;
bool Locked;
bool RendererHasTextures;
bool TexIsBuilt;
bool TexPixelsUseColors;
ImVec2 TexUvScale;
ImVec2 TexUvWhitePixel;
void * Fonts;
void * Sources;
ImVec4 TexUvLines[33];
int TexNextUniqueID;
int FontNextUniqueID;
void * DrawListSharedDatas;
ImFontAtlasBuilder * Builder;
const ImFontLoader * FontLoader;
const char * FontLoaderName;
void * FontLoaderData;
unsigned int FontLoaderFlags;
int RefCount;
ImGuiContext * OwnerContext;
};
struct ImFontBaked {
void * IndexAdvanceX;
float FallbackAdvanceX;
float Size;
float RasterizerDensity;
void * IndexLookup;
void * Glyphs;
int FallbackGlyphIndex;
float Ascent;
float Descent;
unsigned int MetricsTotalSurface;
unsigned int WantDestroy;
unsigned int LockLoadingFallback;
int LastUsedFrame;
ImGuiID BakedId;
ImFont * ContainerFont;
void * FontLoaderDatas;
};
enum ImFontFlags_ {
};
struct ImFont {
ImFontBaked * LastBaked;
ImFontAtlas * ContainerAtlas;
ImFontFlags Flags;
float CurrentRasterizerDensity;
ImGuiID FontId;
float LegacySize;
void * Sources;
ImWchar EllipsisChar;
ImWchar FallbackChar;
ImU8 Used8kPagesMap[1];
bool EllipsisAutoBake;
ImGuiStorage RemapPairs;
};
enum ImGuiViewportFlags_ {
};
struct ImGuiViewport {
ImGuiID ID;
ImGuiViewportFlags Flags;
ImVec2 Pos;
ImVec2 Size;
ImVec2 FramebufferScale;
ImVec2 WorkPos;
ImVec2 WorkSize;
void * PlatformHandle;
void * PlatformHandleRaw;
};
struct ImGuiPlatformIO {
const char *(*Platform_GetClipboardTextFn)(ImGuiContext *);
void (*Platform_SetClipboardTextFn)(ImGuiContext *, const char *);
void * Platform_ClipboardUserData;
bool (*Platform_OpenInShellFn)(ImGuiContext *, const char *);
void * Platform_OpenInShellUserData;
void (*Platform_SetImeDataFn)(ImGuiContext *, ImGuiViewport *, ImGuiPlatformImeData *);
void * Platform_ImeUserData;
ImWchar Platform_LocaleDecimalPoint;
int Renderer_TextureMaxWidth;
int Renderer_TextureMaxHeight;
void * Renderer_RenderState;
void * Textures;
};
struct ImGuiPlatformImeData {
bool WantVisible;
bool WantTextInput;
ImVec2 InputPos;
float InputLineHeight;
ImGuiID ViewportId;
};
}
