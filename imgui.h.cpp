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
typedef struct Better_ImDrawChannel Better_ImDrawChannel;
typedef struct Better_ImDrawCmd Better_ImDrawCmd;
typedef struct Better_ImDrawData Better_ImDrawData;
typedef struct Better_ImDrawList Better_ImDrawList;
typedef struct Better_ImDrawListSharedData Better_ImDrawListSharedData;
typedef struct Better_ImDrawListSplitter Better_ImDrawListSplitter;
typedef struct Better_ImDrawVert Better_ImDrawVert;
typedef struct Better_ImFont Better_ImFont;
typedef struct Better_ImFontAtlas Better_ImFontAtlas;
typedef struct Better_ImFontAtlasBuilder Better_ImFontAtlasBuilder;
typedef struct Better_ImFontAtlasRect Better_ImFontAtlasRect;
typedef struct Better_ImFontBaked Better_ImFontBaked;
typedef struct Better_ImFontConfig Better_ImFontConfig;
typedef struct Better_ImFontGlyph Better_ImFontGlyph;
typedef struct Better_ImFontGlyphRangesBuilder Better_ImFontGlyphRangesBuilder;
typedef struct Better_ImFontLoader Better_ImFontLoader;
typedef struct Better_ImTextureData Better_ImTextureData;
typedef struct Better_ImTextureRect Better_ImTextureRect;
typedef struct Better_ImColor Better_ImColor;
typedef struct Better_ImGuiContext Better_ImGuiContext;
typedef struct Better_ImGuiIO Better_ImGuiIO;
typedef struct Better_ImGuiInputTextCallbackData Better_ImGuiInputTextCallbackData;
typedef struct Better_ImGuiKeyData Better_ImGuiKeyData;
typedef struct Better_ImGuiListClipper Better_ImGuiListClipper;
typedef struct Better_ImGuiMultiSelectIO Better_ImGuiMultiSelectIO;
typedef struct Better_ImGuiOnceUponAFrame Better_ImGuiOnceUponAFrame;
typedef struct Better_ImGuiPayload Better_ImGuiPayload;
typedef struct Better_ImGuiPlatformIO Better_ImGuiPlatformIO;
typedef struct Better_ImGuiPlatformImeData Better_ImGuiPlatformImeData;
typedef struct Better_ImGuiSelectionBasicStorage Better_ImGuiSelectionBasicStorage;
typedef struct Better_ImGuiSelectionExternalStorage Better_ImGuiSelectionExternalStorage;
typedef struct Better_ImGuiSelectionRequest Better_ImGuiSelectionRequest;
typedef struct Better_ImGuiSizeCallbackData Better_ImGuiSizeCallbackData;
typedef struct Better_ImGuiStorage Better_ImGuiStorage;
typedef struct Better_ImGuiStoragePair Better_ImGuiStoragePair;
typedef struct Better_ImGuiStyle Better_ImGuiStyle;
typedef struct Better_ImGuiTableSortSpecs Better_ImGuiTableSortSpecs;
typedef struct Better_ImGuiTableColumnSortSpecs Better_ImGuiTableColumnSortSpecs;
typedef struct Better_ImGuiTextBuffer Better_ImGuiTextBuffer;
typedef struct Better_ImGuiTextFilter Better_ImGuiTextFilter;
typedef struct Better_ImGuiViewport Better_ImGuiViewport;
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
typedef ::NS::ImGuiInputTextCallback Better_ImGuiInputTextCallback;
typedef ::NS::ImGuiSizeCallback Better_ImGuiSizeCallback;
typedef ::NS::ImGuiMemAllocFunc Better_ImGuiMemAllocFunc;
typedef ::NS::ImGuiMemFreeFunc Better_ImGuiMemFreeFunc;
struct Better_ImVec2 {
/* Float */ float x;
/* Float */ float y;
};
struct Better_ImVec4 {
/* Float */ float x;
/* Float */ float y;
/* Float */ float z;
/* Float */ float w;
};
typedef ImU64 Better_ImTextureID;
struct Better_ImTextureRef {
/* Pointer */ ImTextureData * _TexData;
/* Typedef */ ImTextureID _TexID;
};
ImGuiContext *  ImGui_CreateContext(/* Pointer */ ImFontAtlas * shared_font_atlas) { return reinterpret_cast<ImGuiContext * >(::NS::ImGui::CreateContext(reinterpret_cast<::NS::ImFontAtlas * >(shared_font_atlas)));}
void  ImGui_DestroyContext(/* Pointer */ ImGuiContext * ctx) { return ::NS::ImGui::DestroyContext(reinterpret_cast<::NS::ImGuiContext * >(ctx));}
ImGuiContext *  ImGui_GetCurrentContext() { return reinterpret_cast<ImGuiContext * >(::NS::ImGui::GetCurrentContext());}
void  ImGui_SetCurrentContext(/* Pointer */ ImGuiContext * ctx) { return ::NS::ImGui::SetCurrentContext(reinterpret_cast<::NS::ImGuiContext * >(ctx));}
ImGuiIO *  ImGui_GetIO() { return reinterpret_cast<ImGuiIO * >(&::NS::ImGui::GetIO());}
ImGuiPlatformIO *  ImGui_GetPlatformIO() { return reinterpret_cast<ImGuiPlatformIO * >(&::NS::ImGui::GetPlatformIO());}
ImGuiStyle *  ImGui_GetStyle() { return reinterpret_cast<ImGuiStyle * >(&::NS::ImGui::GetStyle());}
void  ImGui_NewFrame() { return ::NS::ImGui::NewFrame();}
void  ImGui_EndFrame() { return ::NS::ImGui::EndFrame();}
void  ImGui_Render() { return ::NS::ImGui::Render();}
ImDrawData *  ImGui_GetDrawData() { return reinterpret_cast<ImDrawData * >(::NS::ImGui::GetDrawData());}
void  ImGui_ShowDemoWindow(/* Pointer */ bool * p_open) { return ::NS::ImGui::ShowDemoWindow(p_open);}
void  ImGui_ShowMetricsWindow(/* Pointer */ bool * p_open) { return ::NS::ImGui::ShowMetricsWindow(p_open);}
void  ImGui_ShowDebugLogWindow(/* Pointer */ bool * p_open) { return ::NS::ImGui::ShowDebugLogWindow(p_open);}
void  ImGui_ShowIDStackToolWindow(/* Pointer */ bool * p_open) { return ::NS::ImGui::ShowIDStackToolWindow(p_open);}
void  ImGui_ShowAboutWindow(/* Pointer */ bool * p_open) { return ::NS::ImGui::ShowAboutWindow(p_open);}
void  ImGui_ShowStyleEditor(/* Pointer */ ImGuiStyle * ref) { return ::NS::ImGui::ShowStyleEditor(reinterpret_cast<::NS::ImGuiStyle * >(ref));}
bool  ImGui_ShowStyleSelector(/* Pointer */ const char * label) { return ::NS::ImGui::ShowStyleSelector(label);}
void  ImGui_ShowFontSelector(/* Pointer */ const char * label) { return ::NS::ImGui::ShowFontSelector(label);}
void  ImGui_ShowUserGuide() { return ::NS::ImGui::ShowUserGuide();}
const char *  ImGui_GetVersion() { return reinterpret_cast<const char * >(::NS::ImGui::GetVersion());}
void  ImGui_StyleColorsDark(/* Pointer */ ImGuiStyle * dst) { return ::NS::ImGui::StyleColorsDark(reinterpret_cast<::NS::ImGuiStyle * >(dst));}
void  ImGui_StyleColorsLight(/* Pointer */ ImGuiStyle * dst) { return ::NS::ImGui::StyleColorsLight(reinterpret_cast<::NS::ImGuiStyle * >(dst));}
void  ImGui_StyleColorsClassic(/* Pointer */ ImGuiStyle * dst) { return ::NS::ImGui::StyleColorsClassic(reinterpret_cast<::NS::ImGuiStyle * >(dst));}
bool  ImGui_Begin(/* Pointer */ const char * name, /* Pointer */ bool * p_open, /* Typedef */ ImGuiWindowFlags flags) { return ::NS::ImGui::Begin(name, p_open, flags);}
void  ImGui_End() { return ::NS::ImGui::End();}
bool  ImGui_BeginChild(/* Pointer */ const char * str_id, /* LValueReference */ const ImVec2 & size, /* Typedef */ ImGuiChildFlags child_flags, /* Typedef */ ImGuiWindowFlags window_flags) { return ::NS::ImGui::BeginChild(str_id, size, child_flags, window_flags);}
bool  ImGui_BeginChild1(/* Typedef */ ImGuiID id, /* LValueReference */ const ImVec2 & size, /* Typedef */ ImGuiChildFlags child_flags, /* Typedef */ ImGuiWindowFlags window_flags) { return ::NS::ImGui::BeginChild(id, size, child_flags, window_flags);}
void  ImGui_EndChild() { return ::NS::ImGui::EndChild();}
bool  ImGui_IsWindowAppearing() { return ::NS::ImGui::IsWindowAppearing();}
bool  ImGui_IsWindowCollapsed() { return ::NS::ImGui::IsWindowCollapsed();}
bool  ImGui_IsWindowFocused(/* Typedef */ ImGuiFocusedFlags flags) { return ::NS::ImGui::IsWindowFocused(flags);}
bool  ImGui_IsWindowHovered(/* Typedef */ ImGuiHoveredFlags flags) { return ::NS::ImGui::IsWindowHovered(flags);}
ImDrawList *  ImGui_GetWindowDrawList() { return reinterpret_cast<ImDrawList * >(::NS::ImGui::GetWindowDrawList());}
ImVec2  ImGui_GetWindowPos() { return std::bit_cast<ImVec2>(::NS::ImGui::GetWindowPos());}
ImVec2  ImGui_GetWindowSize() { return std::bit_cast<ImVec2>(::NS::ImGui::GetWindowSize());}
float  ImGui_GetWindowWidth() { return ::NS::ImGui::GetWindowWidth();}
float  ImGui_GetWindowHeight() { return ::NS::ImGui::GetWindowHeight();}
void  ImGui_SetNextWindowPos(/* LValueReference */ const ImVec2 & pos, /* Typedef */ ImGuiCond cond, /* LValueReference */ const ImVec2 & pivot) { return ::NS::ImGui::SetNextWindowPos(pos, cond, pivot);}
void  ImGui_SetNextWindowSize(/* LValueReference */ const ImVec2 & size, /* Typedef */ ImGuiCond cond) { return ::NS::ImGui::SetNextWindowSize(size, cond);}
void  ImGui_SetNextWindowSizeConstraints(/* LValueReference */ const ImVec2 & size_min, /* LValueReference */ const ImVec2 & size_max, /* Typedef */ ImGuiSizeCallback custom_callback, /* Pointer */ void * custom_callback_data) { return ::NS::ImGui::SetNextWindowSizeConstraints(size_min, size_max, custom_callback, custom_callback_data);}
void  ImGui_SetNextWindowContentSize(/* LValueReference */ const ImVec2 & size) { return ::NS::ImGui::SetNextWindowContentSize(size);}
void  ImGui_SetNextWindowCollapsed(/* Bool */ bool collapsed, /* Typedef */ ImGuiCond cond) { return ::NS::ImGui::SetNextWindowCollapsed(collapsed, cond);}
void  ImGui_SetNextWindowFocus() { return ::NS::ImGui::SetNextWindowFocus();}
void  ImGui_SetNextWindowScroll(/* LValueReference */ const ImVec2 & scroll) { return ::NS::ImGui::SetNextWindowScroll(scroll);}
void  ImGui_SetNextWindowBgAlpha(/* Float */ float alpha) { return ::NS::ImGui::SetNextWindowBgAlpha(alpha);}
void  ImGui_SetWindowPos(/* LValueReference */ const ImVec2 & pos, /* Typedef */ ImGuiCond cond) { return ::NS::ImGui::SetWindowPos(pos, cond);}
void  ImGui_SetWindowSize(/* LValueReference */ const ImVec2 & size, /* Typedef */ ImGuiCond cond) { return ::NS::ImGui::SetWindowSize(size, cond);}
void  ImGui_SetWindowCollapsed(/* Bool */ bool collapsed, /* Typedef */ ImGuiCond cond) { return ::NS::ImGui::SetWindowCollapsed(collapsed, cond);}
void  ImGui_SetWindowFocus() { return ::NS::ImGui::SetWindowFocus();}
void  ImGui_SetWindowPos1(/* Pointer */ const char * name, /* LValueReference */ const ImVec2 & pos, /* Typedef */ ImGuiCond cond) { return ::NS::ImGui::SetWindowPos(name, pos, cond);}
void  ImGui_SetWindowSize1(/* Pointer */ const char * name, /* LValueReference */ const ImVec2 & size, /* Typedef */ ImGuiCond cond) { return ::NS::ImGui::SetWindowSize(name, size, cond);}
void  ImGui_SetWindowCollapsed1(/* Pointer */ const char * name, /* Bool */ bool collapsed, /* Typedef */ ImGuiCond cond) { return ::NS::ImGui::SetWindowCollapsed(name, collapsed, cond);}
void  ImGui_SetWindowFocus1(/* Pointer */ const char * name) { return ::NS::ImGui::SetWindowFocus(name);}
float  ImGui_GetScrollX() { return ::NS::ImGui::GetScrollX();}
float  ImGui_GetScrollY() { return ::NS::ImGui::GetScrollY();}
void  ImGui_SetScrollX(/* Float */ float scroll_x) { return ::NS::ImGui::SetScrollX(scroll_x);}
void  ImGui_SetScrollY(/* Float */ float scroll_y) { return ::NS::ImGui::SetScrollY(scroll_y);}
float  ImGui_GetScrollMaxX() { return ::NS::ImGui::GetScrollMaxX();}
float  ImGui_GetScrollMaxY() { return ::NS::ImGui::GetScrollMaxY();}
void  ImGui_SetScrollHereX(/* Float */ float center_x_ratio) { return ::NS::ImGui::SetScrollHereX(center_x_ratio);}
void  ImGui_SetScrollHereY(/* Float */ float center_y_ratio) { return ::NS::ImGui::SetScrollHereY(center_y_ratio);}
void  ImGui_SetScrollFromPosX(/* Float */ float local_x, /* Float */ float center_x_ratio) { return ::NS::ImGui::SetScrollFromPosX(local_x, center_x_ratio);}
void  ImGui_SetScrollFromPosY(/* Float */ float local_y, /* Float */ float center_y_ratio) { return ::NS::ImGui::SetScrollFromPosY(local_y, center_y_ratio);}
void  ImGui_PushFont(/* Pointer */ ImFont * font, /* Float */ float font_size_base_unscaled) { return ::NS::ImGui::PushFont(reinterpret_cast<::NS::ImFont * >(font), font_size_base_unscaled);}
void  ImGui_PopFont() { return ::NS::ImGui::PopFont();}
ImFont *  ImGui_GetFont() { return reinterpret_cast<ImFont * >(::NS::ImGui::GetFont());}
float  ImGui_GetFontSize() { return ::NS::ImGui::GetFontSize();}
ImFontBaked *  ImGui_GetFontBaked() { return reinterpret_cast<ImFontBaked * >(::NS::ImGui::GetFontBaked());}
void  ImGui_PushStyleColor(/* Typedef */ ImGuiCol idx, /* Typedef */ ImU32 col) { return ::NS::ImGui::PushStyleColor(idx, col);}
void  ImGui_PushStyleColor1(/* Typedef */ ImGuiCol idx, /* LValueReference */ const ImVec4 & col) { return ::NS::ImGui::PushStyleColor(idx, col);}
void  ImGui_PopStyleColor(/* Int */ int count) { return ::NS::ImGui::PopStyleColor(count);}
void  ImGui_PushStyleVar(/* Typedef */ ImGuiStyleVar idx, /* Float */ float val) { return ::NS::ImGui::PushStyleVar(idx, val);}
void  ImGui_PushStyleVar1(/* Typedef */ ImGuiStyleVar idx, /* LValueReference */ const ImVec2 & val) { return ::NS::ImGui::PushStyleVar(idx, val);}
void  ImGui_PushStyleVarX(/* Typedef */ ImGuiStyleVar idx, /* Float */ float val_x) { return ::NS::ImGui::PushStyleVarX(idx, val_x);}
void  ImGui_PushStyleVarY(/* Typedef */ ImGuiStyleVar idx, /* Float */ float val_y) { return ::NS::ImGui::PushStyleVarY(idx, val_y);}
void  ImGui_PopStyleVar(/* Int */ int count) { return ::NS::ImGui::PopStyleVar(count);}
void  ImGui_PushItemFlag(/* Typedef */ ImGuiItemFlags option, /* Bool */ bool enabled) { return ::NS::ImGui::PushItemFlag(option, enabled);}
void  ImGui_PopItemFlag() { return ::NS::ImGui::PopItemFlag();}
void  ImGui_PushItemWidth(/* Float */ float item_width) { return ::NS::ImGui::PushItemWidth(item_width);}
void  ImGui_PopItemWidth() { return ::NS::ImGui::PopItemWidth();}
void  ImGui_SetNextItemWidth(/* Float */ float item_width) { return ::NS::ImGui::SetNextItemWidth(item_width);}
float  ImGui_CalcItemWidth() { return ::NS::ImGui::CalcItemWidth();}
void  ImGui_PushTextWrapPos(/* Float */ float wrap_local_pos_x) { return ::NS::ImGui::PushTextWrapPos(wrap_local_pos_x);}
void  ImGui_PopTextWrapPos() { return ::NS::ImGui::PopTextWrapPos();}
ImVec2  ImGui_GetFontTexUvWhitePixel() { return std::bit_cast<ImVec2>(::NS::ImGui::GetFontTexUvWhitePixel());}
ImU32  ImGui_GetColorU32(/* Typedef */ ImGuiCol idx, /* Float */ float alpha_mul) { return ::NS::ImGui::GetColorU32(idx, alpha_mul);}
ImU32  ImGui_GetColorU321(/* LValueReference */ const ImVec4 & col) { return ::NS::ImGui::GetColorU32(col);}
ImU32  ImGui_GetColorU322(/* Typedef */ ImU32 col, /* Float */ float alpha_mul) { return ::NS::ImGui::GetColorU32(col, alpha_mul);}
const ImVec4 *  ImGui_GetStyleColorVec4(/* Typedef */ ImGuiCol idx) { return reinterpret_cast<const ImVec4 * >(&::NS::ImGui::GetStyleColorVec4(idx));}
ImVec2  ImGui_GetCursorScreenPos() { return std::bit_cast<ImVec2>(::NS::ImGui::GetCursorScreenPos());}
void  ImGui_SetCursorScreenPos(/* LValueReference */ const ImVec2 & pos) { return ::NS::ImGui::SetCursorScreenPos(pos);}
ImVec2  ImGui_GetContentRegionAvail() { return std::bit_cast<ImVec2>(::NS::ImGui::GetContentRegionAvail());}
ImVec2  ImGui_GetCursorPos() { return std::bit_cast<ImVec2>(::NS::ImGui::GetCursorPos());}
float  ImGui_GetCursorPosX() { return ::NS::ImGui::GetCursorPosX();}
float  ImGui_GetCursorPosY() { return ::NS::ImGui::GetCursorPosY();}
void  ImGui_SetCursorPos(/* LValueReference */ const ImVec2 & local_pos) { return ::NS::ImGui::SetCursorPos(local_pos);}
void  ImGui_SetCursorPosX(/* Float */ float local_x) { return ::NS::ImGui::SetCursorPosX(local_x);}
void  ImGui_SetCursorPosY(/* Float */ float local_y) { return ::NS::ImGui::SetCursorPosY(local_y);}
ImVec2  ImGui_GetCursorStartPos() { return std::bit_cast<ImVec2>(::NS::ImGui::GetCursorStartPos());}
void  ImGui_Separator() { return ::NS::ImGui::Separator();}
void  ImGui_SameLine(/* Float */ float offset_from_start_x, /* Float */ float spacing) { return ::NS::ImGui::SameLine(offset_from_start_x, spacing);}
void  ImGui_NewLine() { return ::NS::ImGui::NewLine();}
void  ImGui_Spacing() { return ::NS::ImGui::Spacing();}
void  ImGui_Dummy(/* LValueReference */ const ImVec2 & size) { return ::NS::ImGui::Dummy(size);}
void  ImGui_Indent(/* Float */ float indent_w) { return ::NS::ImGui::Indent(indent_w);}
void  ImGui_Unindent(/* Float */ float indent_w) { return ::NS::ImGui::Unindent(indent_w);}
void  ImGui_BeginGroup() { return ::NS::ImGui::BeginGroup();}
void  ImGui_EndGroup() { return ::NS::ImGui::EndGroup();}
void  ImGui_AlignTextToFramePadding() { return ::NS::ImGui::AlignTextToFramePadding();}
float  ImGui_GetTextLineHeight() { return ::NS::ImGui::GetTextLineHeight();}
float  ImGui_GetTextLineHeightWithSpacing() { return ::NS::ImGui::GetTextLineHeightWithSpacing();}
float  ImGui_GetFrameHeight() { return ::NS::ImGui::GetFrameHeight();}
float  ImGui_GetFrameHeightWithSpacing() { return ::NS::ImGui::GetFrameHeightWithSpacing();}
void  ImGui_PushID(/* Pointer */ const char * str_id) { return ::NS::ImGui::PushID(str_id);}
void  ImGui_PushID1(/* Pointer */ const char * str_id_begin, /* Pointer */ const char * str_id_end) { return ::NS::ImGui::PushID(str_id_begin, str_id_end);}
void  ImGui_PushID2(/* Pointer */ const void * ptr_id) { return ::NS::ImGui::PushID(ptr_id);}
void  ImGui_PushID3(/* Int */ int int_id) { return ::NS::ImGui::PushID(int_id);}
void  ImGui_PopID() { return ::NS::ImGui::PopID();}
ImGuiID  ImGui_GetID(/* Pointer */ const char * str_id) { return ::NS::ImGui::GetID(str_id);}
ImGuiID  ImGui_GetID1(/* Pointer */ const char * str_id_begin, /* Pointer */ const char * str_id_end) { return ::NS::ImGui::GetID(str_id_begin, str_id_end);}
ImGuiID  ImGui_GetID2(/* Pointer */ const void * ptr_id) { return ::NS::ImGui::GetID(ptr_id);}
ImGuiID  ImGui_GetID3(/* Int */ int int_id) { return ::NS::ImGui::GetID(int_id);}
void  ImGui_TextUnformatted(/* Pointer */ const char * text, /* Pointer */ const char * text_end) { return ::NS::ImGui::TextUnformatted(text, text_end);}
void  ImGui_Text(/* Pointer */ const char * fmt) { return ::NS::ImGui::Text(fmt);}
void  ImGui_TextV(/* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::TextV(fmt, args);}
void  ImGui_TextColored(/* LValueReference */ const ImVec4 & col, /* Pointer */ const char * fmt) { return ::NS::ImGui::TextColored(col, fmt);}
void  ImGui_TextColoredV(/* LValueReference */ const ImVec4 & col, /* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::TextColoredV(col, fmt, args);}
void  ImGui_TextDisabled(/* Pointer */ const char * fmt) { return ::NS::ImGui::TextDisabled(fmt);}
void  ImGui_TextDisabledV(/* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::TextDisabledV(fmt, args);}
void  ImGui_TextWrapped(/* Pointer */ const char * fmt) { return ::NS::ImGui::TextWrapped(fmt);}
void  ImGui_TextWrappedV(/* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::TextWrappedV(fmt, args);}
void  ImGui_LabelText(/* Pointer */ const char * label, /* Pointer */ const char * fmt) { return ::NS::ImGui::LabelText(label, fmt);}
void  ImGui_LabelTextV(/* Pointer */ const char * label, /* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::LabelTextV(label, fmt, args);}
void  ImGui_BulletText(/* Pointer */ const char * fmt) { return ::NS::ImGui::BulletText(fmt);}
void  ImGui_BulletTextV(/* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::BulletTextV(fmt, args);}
void  ImGui_SeparatorText(/* Pointer */ const char * label) { return ::NS::ImGui::SeparatorText(label);}
bool  ImGui_Button(/* Pointer */ const char * label, /* LValueReference */ const ImVec2 & size) { return ::NS::ImGui::Button(label, size);}
bool  ImGui_SmallButton(/* Pointer */ const char * label) { return ::NS::ImGui::SmallButton(label);}
bool  ImGui_InvisibleButton(/* Pointer */ const char * str_id, /* LValueReference */ const ImVec2 & size, /* Typedef */ ImGuiButtonFlags flags) { return ::NS::ImGui::InvisibleButton(str_id, size, flags);}
bool  ImGui_ArrowButton(/* Pointer */ const char * str_id, /* Enum */ ImGuiDir dir) { return ::NS::ImGui::ArrowButton(str_id, std::bit_cast<::NS::ImGuiDir >(dir));}
bool  ImGui_Checkbox(/* Pointer */ const char * label, /* Pointer */ bool * v) { return ::NS::ImGui::Checkbox(label, v);}
bool  ImGui_CheckboxFlags(/* Pointer */ const char * label, /* Pointer */ int * flags, /* Int */ int flags_value) { return ::NS::ImGui::CheckboxFlags(label, flags, flags_value);}
bool  ImGui_CheckboxFlags1(/* Pointer */ const char * label, /* Pointer */ unsigned int * flags, /* UInt */ unsigned int flags_value) { return ::NS::ImGui::CheckboxFlags(label, flags, flags_value);}
bool  ImGui_RadioButton(/* Pointer */ const char * label, /* Bool */ bool active) { return ::NS::ImGui::RadioButton(label, active);}
bool  ImGui_RadioButton1(/* Pointer */ const char * label, /* Pointer */ int * v, /* Int */ int v_button) { return ::NS::ImGui::RadioButton(label, v, v_button);}
void  ImGui_ProgressBar(/* Float */ float fraction, /* LValueReference */ const ImVec2 & size_arg, /* Pointer */ const char * overlay) { return ::NS::ImGui::ProgressBar(fraction, size_arg, overlay);}
void  ImGui_Bullet() { return ::NS::ImGui::Bullet();}
bool  ImGui_TextLink(/* Pointer */ const char * label) { return ::NS::ImGui::TextLink(label);}
bool  ImGui_TextLinkOpenURL(/* Pointer */ const char * label, /* Pointer */ const char * url) { return ::NS::ImGui::TextLinkOpenURL(label, url);}
void  ImGui_Image(/* Record */ ImTextureRef tex_ref, /* LValueReference */ const ImVec2 & image_size, /* LValueReference */ const ImVec2 & uv0, /* LValueReference */ const ImVec2 & uv1) { return ::NS::ImGui::Image(std::bit_cast<::NS::ImTextureRef >(tex_ref), image_size, uv0, uv1);}
void  ImGui_ImageWithBg(/* Record */ ImTextureRef tex_ref, /* LValueReference */ const ImVec2 & image_size, /* LValueReference */ const ImVec2 & uv0, /* LValueReference */ const ImVec2 & uv1, /* LValueReference */ const ImVec4 & bg_col, /* LValueReference */ const ImVec4 & tint_col) { return ::NS::ImGui::ImageWithBg(std::bit_cast<::NS::ImTextureRef >(tex_ref), image_size, uv0, uv1, bg_col, tint_col);}
bool  ImGui_ImageButton(/* Pointer */ const char * str_id, /* Record */ ImTextureRef tex_ref, /* LValueReference */ const ImVec2 & image_size, /* LValueReference */ const ImVec2 & uv0, /* LValueReference */ const ImVec2 & uv1, /* LValueReference */ const ImVec4 & bg_col, /* LValueReference */ const ImVec4 & tint_col) { return ::NS::ImGui::ImageButton(str_id, std::bit_cast<::NS::ImTextureRef >(tex_ref), image_size, uv0, uv1, bg_col, tint_col);}
bool  ImGui_BeginCombo(/* Pointer */ const char * label, /* Pointer */ const char * preview_value, /* Typedef */ ImGuiComboFlags flags) { return ::NS::ImGui::BeginCombo(label, preview_value, flags);}
void  ImGui_EndCombo() { return ::NS::ImGui::EndCombo();}
bool  ImGui_Combo(/* Pointer */ const char * label, /* Pointer */ int * current_item, /* IncompleteArray */ const char *const items[], /* Int */ int items_count, /* Int */ int popup_max_height_in_items) { return ::NS::ImGui::Combo(label, current_item, items, items_count, popup_max_height_in_items);}
bool  ImGui_Combo1(/* Pointer */ const char * label, /* Pointer */ int * current_item, /* Pointer */ const char * items_separated_by_zeros, /* Int */ int popup_max_height_in_items) { return ::NS::ImGui::Combo(label, current_item, items_separated_by_zeros, popup_max_height_in_items);}
bool  ImGui_Combo2(/* Pointer */ const char * label, /* Pointer */ int * current_item, /* Pointer */ const char *(*getter)(void *, int), /* Pointer */ void * user_data, /* Int */ int items_count, /* Int */ int popup_max_height_in_items) { return ::NS::ImGui::Combo(label, current_item, getter, user_data, items_count, popup_max_height_in_items);}
bool  ImGui_DragFloat(/* Pointer */ const char * label, /* Pointer */ float * v, /* Float */ float v_speed, /* Float */ float v_min, /* Float */ float v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::DragFloat(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragFloat2(/* Pointer */ const char * label, /* ConstantArray */ float v[2], /* Float */ float v_speed, /* Float */ float v_min, /* Float */ float v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::DragFloat2(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragFloat3(/* Pointer */ const char * label, /* ConstantArray */ float v[3], /* Float */ float v_speed, /* Float */ float v_min, /* Float */ float v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::DragFloat3(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragFloat4(/* Pointer */ const char * label, /* ConstantArray */ float v[4], /* Float */ float v_speed, /* Float */ float v_min, /* Float */ float v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::DragFloat4(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragFloatRange2(/* Pointer */ const char * label, /* Pointer */ float * v_current_min, /* Pointer */ float * v_current_max, /* Float */ float v_speed, /* Float */ float v_min, /* Float */ float v_max, /* Pointer */ const char * format, /* Pointer */ const char * format_max, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::DragFloatRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, flags);}
bool  ImGui_DragInt(/* Pointer */ const char * label, /* Pointer */ int * v, /* Float */ float v_speed, /* Int */ int v_min, /* Int */ int v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::DragInt(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragInt2(/* Pointer */ const char * label, /* ConstantArray */ int v[2], /* Float */ float v_speed, /* Int */ int v_min, /* Int */ int v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::DragInt2(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragInt3(/* Pointer */ const char * label, /* ConstantArray */ int v[3], /* Float */ float v_speed, /* Int */ int v_min, /* Int */ int v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::DragInt3(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragInt4(/* Pointer */ const char * label, /* ConstantArray */ int v[4], /* Float */ float v_speed, /* Int */ int v_min, /* Int */ int v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::DragInt4(label, v, v_speed, v_min, v_max, format, flags);}
bool  ImGui_DragIntRange2(/* Pointer */ const char * label, /* Pointer */ int * v_current_min, /* Pointer */ int * v_current_max, /* Float */ float v_speed, /* Int */ int v_min, /* Int */ int v_max, /* Pointer */ const char * format, /* Pointer */ const char * format_max, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::DragIntRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, flags);}
bool  ImGui_DragScalar(/* Pointer */ const char * label, /* Typedef */ ImGuiDataType data_type, /* Pointer */ void * p_data, /* Float */ float v_speed, /* Pointer */ const void * p_min, /* Pointer */ const void * p_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::DragScalar(label, data_type, p_data, v_speed, p_min, p_max, format, flags);}
bool  ImGui_DragScalarN(/* Pointer */ const char * label, /* Typedef */ ImGuiDataType data_type, /* Pointer */ void * p_data, /* Int */ int components, /* Float */ float v_speed, /* Pointer */ const void * p_min, /* Pointer */ const void * p_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::DragScalarN(label, data_type, p_data, components, v_speed, p_min, p_max, format, flags);}
bool  ImGui_SliderFloat(/* Pointer */ const char * label, /* Pointer */ float * v, /* Float */ float v_min, /* Float */ float v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::SliderFloat(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderFloat2(/* Pointer */ const char * label, /* ConstantArray */ float v[2], /* Float */ float v_min, /* Float */ float v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::SliderFloat2(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderFloat3(/* Pointer */ const char * label, /* ConstantArray */ float v[3], /* Float */ float v_min, /* Float */ float v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::SliderFloat3(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderFloat4(/* Pointer */ const char * label, /* ConstantArray */ float v[4], /* Float */ float v_min, /* Float */ float v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::SliderFloat4(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderAngle(/* Pointer */ const char * label, /* Pointer */ float * v_rad, /* Float */ float v_degrees_min, /* Float */ float v_degrees_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::SliderAngle(label, v_rad, v_degrees_min, v_degrees_max, format, flags);}
bool  ImGui_SliderInt(/* Pointer */ const char * label, /* Pointer */ int * v, /* Int */ int v_min, /* Int */ int v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::SliderInt(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderInt2(/* Pointer */ const char * label, /* ConstantArray */ int v[2], /* Int */ int v_min, /* Int */ int v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::SliderInt2(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderInt3(/* Pointer */ const char * label, /* ConstantArray */ int v[3], /* Int */ int v_min, /* Int */ int v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::SliderInt3(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderInt4(/* Pointer */ const char * label, /* ConstantArray */ int v[4], /* Int */ int v_min, /* Int */ int v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::SliderInt4(label, v, v_min, v_max, format, flags);}
bool  ImGui_SliderScalar(/* Pointer */ const char * label, /* Typedef */ ImGuiDataType data_type, /* Pointer */ void * p_data, /* Pointer */ const void * p_min, /* Pointer */ const void * p_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::SliderScalar(label, data_type, p_data, p_min, p_max, format, flags);}
bool  ImGui_SliderScalarN(/* Pointer */ const char * label, /* Typedef */ ImGuiDataType data_type, /* Pointer */ void * p_data, /* Int */ int components, /* Pointer */ const void * p_min, /* Pointer */ const void * p_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::SliderScalarN(label, data_type, p_data, components, p_min, p_max, format, flags);}
bool  ImGui_VSliderFloat(/* Pointer */ const char * label, /* LValueReference */ const ImVec2 & size, /* Pointer */ float * v, /* Float */ float v_min, /* Float */ float v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::VSliderFloat(label, size, v, v_min, v_max, format, flags);}
bool  ImGui_VSliderInt(/* Pointer */ const char * label, /* LValueReference */ const ImVec2 & size, /* Pointer */ int * v, /* Int */ int v_min, /* Int */ int v_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::VSliderInt(label, size, v, v_min, v_max, format, flags);}
bool  ImGui_VSliderScalar(/* Pointer */ const char * label, /* LValueReference */ const ImVec2 & size, /* Typedef */ ImGuiDataType data_type, /* Pointer */ void * p_data, /* Pointer */ const void * p_min, /* Pointer */ const void * p_max, /* Pointer */ const char * format, /* Typedef */ ImGuiSliderFlags flags) { return ::NS::ImGui::VSliderScalar(label, size, data_type, p_data, p_min, p_max, format, flags);}
bool  ImGui_InputText(/* Pointer */ const char * label, /* Pointer */ char * buf, /* Typedef */ size_t buf_size, /* Typedef */ ImGuiInputTextFlags flags, /* Typedef */ ImGuiInputTextCallback callback, /* Pointer */ void * user_data) { return ::NS::ImGui::InputText(label, buf, buf_size, flags, callback, user_data);}
bool  ImGui_InputTextMultiline(/* Pointer */ const char * label, /* Pointer */ char * buf, /* Typedef */ size_t buf_size, /* LValueReference */ const ImVec2 & size, /* Typedef */ ImGuiInputTextFlags flags, /* Typedef */ ImGuiInputTextCallback callback, /* Pointer */ void * user_data) { return ::NS::ImGui::InputTextMultiline(label, buf, buf_size, size, flags, callback, user_data);}
bool  ImGui_InputTextWithHint(/* Pointer */ const char * label, /* Pointer */ const char * hint, /* Pointer */ char * buf, /* Typedef */ size_t buf_size, /* Typedef */ ImGuiInputTextFlags flags, /* Typedef */ ImGuiInputTextCallback callback, /* Pointer */ void * user_data) { return ::NS::ImGui::InputTextWithHint(label, hint, buf, buf_size, flags, callback, user_data);}
bool  ImGui_InputFloat(/* Pointer */ const char * label, /* Pointer */ float * v, /* Float */ float step, /* Float */ float step_fast, /* Pointer */ const char * format, /* Typedef */ ImGuiInputTextFlags flags) { return ::NS::ImGui::InputFloat(label, v, step, step_fast, format, flags);}
bool  ImGui_InputFloat2(/* Pointer */ const char * label, /* ConstantArray */ float v[2], /* Pointer */ const char * format, /* Typedef */ ImGuiInputTextFlags flags) { return ::NS::ImGui::InputFloat2(label, v, format, flags);}
bool  ImGui_InputFloat3(/* Pointer */ const char * label, /* ConstantArray */ float v[3], /* Pointer */ const char * format, /* Typedef */ ImGuiInputTextFlags flags) { return ::NS::ImGui::InputFloat3(label, v, format, flags);}
bool  ImGui_InputFloat4(/* Pointer */ const char * label, /* ConstantArray */ float v[4], /* Pointer */ const char * format, /* Typedef */ ImGuiInputTextFlags flags) { return ::NS::ImGui::InputFloat4(label, v, format, flags);}
bool  ImGui_InputInt(/* Pointer */ const char * label, /* Pointer */ int * v, /* Int */ int step, /* Int */ int step_fast, /* Typedef */ ImGuiInputTextFlags flags) { return ::NS::ImGui::InputInt(label, v, step, step_fast, flags);}
bool  ImGui_InputInt2(/* Pointer */ const char * label, /* ConstantArray */ int v[2], /* Typedef */ ImGuiInputTextFlags flags) { return ::NS::ImGui::InputInt2(label, v, flags);}
bool  ImGui_InputInt3(/* Pointer */ const char * label, /* ConstantArray */ int v[3], /* Typedef */ ImGuiInputTextFlags flags) { return ::NS::ImGui::InputInt3(label, v, flags);}
bool  ImGui_InputInt4(/* Pointer */ const char * label, /* ConstantArray */ int v[4], /* Typedef */ ImGuiInputTextFlags flags) { return ::NS::ImGui::InputInt4(label, v, flags);}
bool  ImGui_InputDouble(/* Pointer */ const char * label, /* Pointer */ double * v, /* Double */ double step, /* Double */ double step_fast, /* Pointer */ const char * format, /* Typedef */ ImGuiInputTextFlags flags) { return ::NS::ImGui::InputDouble(label, v, step, step_fast, format, flags);}
bool  ImGui_InputScalar(/* Pointer */ const char * label, /* Typedef */ ImGuiDataType data_type, /* Pointer */ void * p_data, /* Pointer */ const void * p_step, /* Pointer */ const void * p_step_fast, /* Pointer */ const char * format, /* Typedef */ ImGuiInputTextFlags flags) { return ::NS::ImGui::InputScalar(label, data_type, p_data, p_step, p_step_fast, format, flags);}
bool  ImGui_InputScalarN(/* Pointer */ const char * label, /* Typedef */ ImGuiDataType data_type, /* Pointer */ void * p_data, /* Int */ int components, /* Pointer */ const void * p_step, /* Pointer */ const void * p_step_fast, /* Pointer */ const char * format, /* Typedef */ ImGuiInputTextFlags flags) { return ::NS::ImGui::InputScalarN(label, data_type, p_data, components, p_step, p_step_fast, format, flags);}
bool  ImGui_ColorEdit3(/* Pointer */ const char * label, /* ConstantArray */ float col[3], /* Typedef */ ImGuiColorEditFlags flags) { return ::NS::ImGui::ColorEdit3(label, col, flags);}
bool  ImGui_ColorEdit4(/* Pointer */ const char * label, /* ConstantArray */ float col[4], /* Typedef */ ImGuiColorEditFlags flags) { return ::NS::ImGui::ColorEdit4(label, col, flags);}
bool  ImGui_ColorPicker3(/* Pointer */ const char * label, /* ConstantArray */ float col[3], /* Typedef */ ImGuiColorEditFlags flags) { return ::NS::ImGui::ColorPicker3(label, col, flags);}
bool  ImGui_ColorPicker4(/* Pointer */ const char * label, /* ConstantArray */ float col[4], /* Typedef */ ImGuiColorEditFlags flags, /* Pointer */ const float * ref_col) { return ::NS::ImGui::ColorPicker4(label, col, flags, ref_col);}
bool  ImGui_ColorButton(/* Pointer */ const char * desc_id, /* LValueReference */ const ImVec4 & col, /* Typedef */ ImGuiColorEditFlags flags, /* LValueReference */ const ImVec2 & size) { return ::NS::ImGui::ColorButton(desc_id, col, flags, size);}
void  ImGui_SetColorEditOptions(/* Typedef */ ImGuiColorEditFlags flags) { return ::NS::ImGui::SetColorEditOptions(flags);}
bool  ImGui_TreeNode(/* Pointer */ const char * label) { return ::NS::ImGui::TreeNode(label);}
bool  ImGui_TreeNode1(/* Pointer */ const char * str_id, /* Pointer */ const char * fmt) { return ::NS::ImGui::TreeNode(str_id, fmt);}
bool  ImGui_TreeNode2(/* Pointer */ const void * ptr_id, /* Pointer */ const char * fmt) { return ::NS::ImGui::TreeNode(ptr_id, fmt);}
bool  ImGui_TreeNodeV(/* Pointer */ const char * str_id, /* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::TreeNodeV(str_id, fmt, args);}
bool  ImGui_TreeNodeV1(/* Pointer */ const void * ptr_id, /* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::TreeNodeV(ptr_id, fmt, args);}
bool  ImGui_TreeNodeEx(/* Pointer */ const char * label, /* Typedef */ ImGuiTreeNodeFlags flags) { return ::NS::ImGui::TreeNodeEx(label, flags);}
bool  ImGui_TreeNodeEx1(/* Pointer */ const char * str_id, /* Typedef */ ImGuiTreeNodeFlags flags, /* Pointer */ const char * fmt) { return ::NS::ImGui::TreeNodeEx(str_id, flags, fmt);}
bool  ImGui_TreeNodeEx2(/* Pointer */ const void * ptr_id, /* Typedef */ ImGuiTreeNodeFlags flags, /* Pointer */ const char * fmt) { return ::NS::ImGui::TreeNodeEx(ptr_id, flags, fmt);}
bool  ImGui_TreeNodeExV(/* Pointer */ const char * str_id, /* Typedef */ ImGuiTreeNodeFlags flags, /* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::TreeNodeExV(str_id, flags, fmt, args);}
bool  ImGui_TreeNodeExV1(/* Pointer */ const void * ptr_id, /* Typedef */ ImGuiTreeNodeFlags flags, /* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::TreeNodeExV(ptr_id, flags, fmt, args);}
void  ImGui_TreePush(/* Pointer */ const char * str_id) { return ::NS::ImGui::TreePush(str_id);}
void  ImGui_TreePush1(/* Pointer */ const void * ptr_id) { return ::NS::ImGui::TreePush(ptr_id);}
void  ImGui_TreePop() { return ::NS::ImGui::TreePop();}
float  ImGui_GetTreeNodeToLabelSpacing() { return ::NS::ImGui::GetTreeNodeToLabelSpacing();}
bool  ImGui_CollapsingHeader(/* Pointer */ const char * label, /* Typedef */ ImGuiTreeNodeFlags flags) { return ::NS::ImGui::CollapsingHeader(label, flags);}
bool  ImGui_CollapsingHeader1(/* Pointer */ const char * label, /* Pointer */ bool * p_visible, /* Typedef */ ImGuiTreeNodeFlags flags) { return ::NS::ImGui::CollapsingHeader(label, p_visible, flags);}
void  ImGui_SetNextItemOpen(/* Bool */ bool is_open, /* Typedef */ ImGuiCond cond) { return ::NS::ImGui::SetNextItemOpen(is_open, cond);}
void  ImGui_SetNextItemStorageID(/* Typedef */ ImGuiID storage_id) { return ::NS::ImGui::SetNextItemStorageID(storage_id);}
bool  ImGui_Selectable(/* Pointer */ const char * label, /* Bool */ bool selected, /* Typedef */ ImGuiSelectableFlags flags, /* LValueReference */ const ImVec2 & size) { return ::NS::ImGui::Selectable(label, selected, flags, size);}
bool  ImGui_Selectable1(/* Pointer */ const char * label, /* Pointer */ bool * p_selected, /* Typedef */ ImGuiSelectableFlags flags, /* LValueReference */ const ImVec2 & size) { return ::NS::ImGui::Selectable(label, p_selected, flags, size);}
ImGuiMultiSelectIO *  ImGui_BeginMultiSelect(/* Typedef */ ImGuiMultiSelectFlags flags, /* Int */ int selection_size, /* Int */ int items_count) { return reinterpret_cast<ImGuiMultiSelectIO * >(::NS::ImGui::BeginMultiSelect(flags, selection_size, items_count));}
ImGuiMultiSelectIO *  ImGui_EndMultiSelect() { return reinterpret_cast<ImGuiMultiSelectIO * >(::NS::ImGui::EndMultiSelect());}
void  ImGui_SetNextItemSelectionUserData(/* Typedef */ ImGuiSelectionUserData selection_user_data) { return ::NS::ImGui::SetNextItemSelectionUserData(selection_user_data);}
bool  ImGui_IsItemToggledSelection() { return ::NS::ImGui::IsItemToggledSelection();}
bool  ImGui_BeginListBox(/* Pointer */ const char * label, /* LValueReference */ const ImVec2 & size) { return ::NS::ImGui::BeginListBox(label, size);}
void  ImGui_EndListBox() { return ::NS::ImGui::EndListBox();}
bool  ImGui_ListBox(/* Pointer */ const char * label, /* Pointer */ int * current_item, /* IncompleteArray */ const char *const items[], /* Int */ int items_count, /* Int */ int height_in_items) { return ::NS::ImGui::ListBox(label, current_item, items, items_count, height_in_items);}
bool  ImGui_ListBox1(/* Pointer */ const char * label, /* Pointer */ int * current_item, /* Pointer */ const char *(*getter)(void *, int), /* Pointer */ void * user_data, /* Int */ int items_count, /* Int */ int height_in_items) { return ::NS::ImGui::ListBox(label, current_item, getter, user_data, items_count, height_in_items);}
void  ImGui_PlotLines(/* Pointer */ const char * label, /* Pointer */ const float * values, /* Int */ int values_count, /* Int */ int values_offset, /* Pointer */ const char * overlay_text, /* Float */ float scale_min, /* Float */ float scale_max, /* Record */ ImVec2 graph_size, /* Int */ int stride) { return ::NS::ImGui::PlotLines(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, std::bit_cast<::NS::ImVec2 >(graph_size), stride);}
void  ImGui_PlotLines1(/* Pointer */ const char * label, /* Pointer */ float (*values_getter)(void *, int), /* Pointer */ void * data, /* Int */ int values_count, /* Int */ int values_offset, /* Pointer */ const char * overlay_text, /* Float */ float scale_min, /* Float */ float scale_max, /* Record */ ImVec2 graph_size) { return ::NS::ImGui::PlotLines(label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, std::bit_cast<::NS::ImVec2 >(graph_size));}
void  ImGui_PlotHistogram(/* Pointer */ const char * label, /* Pointer */ const float * values, /* Int */ int values_count, /* Int */ int values_offset, /* Pointer */ const char * overlay_text, /* Float */ float scale_min, /* Float */ float scale_max, /* Record */ ImVec2 graph_size, /* Int */ int stride) { return ::NS::ImGui::PlotHistogram(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, std::bit_cast<::NS::ImVec2 >(graph_size), stride);}
void  ImGui_PlotHistogram1(/* Pointer */ const char * label, /* Pointer */ float (*values_getter)(void *, int), /* Pointer */ void * data, /* Int */ int values_count, /* Int */ int values_offset, /* Pointer */ const char * overlay_text, /* Float */ float scale_min, /* Float */ float scale_max, /* Record */ ImVec2 graph_size) { return ::NS::ImGui::PlotHistogram(label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, std::bit_cast<::NS::ImVec2 >(graph_size));}
void  ImGui_Value(/* Pointer */ const char * prefix, /* Bool */ bool b) { return ::NS::ImGui::Value(prefix, b);}
void  ImGui_Value1(/* Pointer */ const char * prefix, /* Int */ int v) { return ::NS::ImGui::Value(prefix, v);}
void  ImGui_Value2(/* Pointer */ const char * prefix, /* UInt */ unsigned int v) { return ::NS::ImGui::Value(prefix, v);}
void  ImGui_Value3(/* Pointer */ const char * prefix, /* Float */ float v, /* Pointer */ const char * float_format) { return ::NS::ImGui::Value(prefix, v, float_format);}
bool  ImGui_BeginMenuBar() { return ::NS::ImGui::BeginMenuBar();}
void  ImGui_EndMenuBar() { return ::NS::ImGui::EndMenuBar();}
bool  ImGui_BeginMainMenuBar() { return ::NS::ImGui::BeginMainMenuBar();}
void  ImGui_EndMainMenuBar() { return ::NS::ImGui::EndMainMenuBar();}
bool  ImGui_BeginMenu(/* Pointer */ const char * label, /* Bool */ bool enabled) { return ::NS::ImGui::BeginMenu(label, enabled);}
void  ImGui_EndMenu() { return ::NS::ImGui::EndMenu();}
bool  ImGui_MenuItem(/* Pointer */ const char * label, /* Pointer */ const char * shortcut, /* Bool */ bool selected, /* Bool */ bool enabled) { return ::NS::ImGui::MenuItem(label, shortcut, selected, enabled);}
bool  ImGui_MenuItem1(/* Pointer */ const char * label, /* Pointer */ const char * shortcut, /* Pointer */ bool * p_selected, /* Bool */ bool enabled) { return ::NS::ImGui::MenuItem(label, shortcut, p_selected, enabled);}
bool  ImGui_BeginTooltip() { return ::NS::ImGui::BeginTooltip();}
void  ImGui_EndTooltip() { return ::NS::ImGui::EndTooltip();}
void  ImGui_SetTooltip(/* Pointer */ const char * fmt) { return ::NS::ImGui::SetTooltip(fmt);}
void  ImGui_SetTooltipV(/* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::SetTooltipV(fmt, args);}
bool  ImGui_BeginItemTooltip() { return ::NS::ImGui::BeginItemTooltip();}
void  ImGui_SetItemTooltip(/* Pointer */ const char * fmt) { return ::NS::ImGui::SetItemTooltip(fmt);}
void  ImGui_SetItemTooltipV(/* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::SetItemTooltipV(fmt, args);}
bool  ImGui_BeginPopup(/* Pointer */ const char * str_id, /* Typedef */ ImGuiWindowFlags flags) { return ::NS::ImGui::BeginPopup(str_id, flags);}
bool  ImGui_BeginPopupModal(/* Pointer */ const char * name, /* Pointer */ bool * p_open, /* Typedef */ ImGuiWindowFlags flags) { return ::NS::ImGui::BeginPopupModal(name, p_open, flags);}
void  ImGui_EndPopup() { return ::NS::ImGui::EndPopup();}
void  ImGui_OpenPopup(/* Pointer */ const char * str_id, /* Typedef */ ImGuiPopupFlags popup_flags) { return ::NS::ImGui::OpenPopup(str_id, popup_flags);}
void  ImGui_OpenPopup1(/* Typedef */ ImGuiID id, /* Typedef */ ImGuiPopupFlags popup_flags) { return ::NS::ImGui::OpenPopup(id, popup_flags);}
void  ImGui_OpenPopupOnItemClick(/* Pointer */ const char * str_id, /* Typedef */ ImGuiPopupFlags popup_flags) { return ::NS::ImGui::OpenPopupOnItemClick(str_id, popup_flags);}
void  ImGui_CloseCurrentPopup() { return ::NS::ImGui::CloseCurrentPopup();}
bool  ImGui_BeginPopupContextItem(/* Pointer */ const char * str_id, /* Typedef */ ImGuiPopupFlags popup_flags) { return ::NS::ImGui::BeginPopupContextItem(str_id, popup_flags);}
bool  ImGui_BeginPopupContextWindow(/* Pointer */ const char * str_id, /* Typedef */ ImGuiPopupFlags popup_flags) { return ::NS::ImGui::BeginPopupContextWindow(str_id, popup_flags);}
bool  ImGui_BeginPopupContextVoid(/* Pointer */ const char * str_id, /* Typedef */ ImGuiPopupFlags popup_flags) { return ::NS::ImGui::BeginPopupContextVoid(str_id, popup_flags);}
bool  ImGui_IsPopupOpen(/* Pointer */ const char * str_id, /* Typedef */ ImGuiPopupFlags flags) { return ::NS::ImGui::IsPopupOpen(str_id, flags);}
bool  ImGui_BeginTable(/* Pointer */ const char * str_id, /* Int */ int columns, /* Typedef */ ImGuiTableFlags flags, /* LValueReference */ const ImVec2 & outer_size, /* Float */ float inner_width) { return ::NS::ImGui::BeginTable(str_id, columns, flags, outer_size, inner_width);}
void  ImGui_EndTable() { return ::NS::ImGui::EndTable();}
void  ImGui_TableNextRow(/* Typedef */ ImGuiTableRowFlags row_flags, /* Float */ float min_row_height) { return ::NS::ImGui::TableNextRow(row_flags, min_row_height);}
bool  ImGui_TableNextColumn() { return ::NS::ImGui::TableNextColumn();}
bool  ImGui_TableSetColumnIndex(/* Int */ int column_n) { return ::NS::ImGui::TableSetColumnIndex(column_n);}
void  ImGui_TableSetupColumn(/* Pointer */ const char * label, /* Typedef */ ImGuiTableColumnFlags flags, /* Float */ float init_width_or_weight, /* Typedef */ ImGuiID user_id) { return ::NS::ImGui::TableSetupColumn(label, flags, init_width_or_weight, user_id);}
void  ImGui_TableSetupScrollFreeze(/* Int */ int cols, /* Int */ int rows) { return ::NS::ImGui::TableSetupScrollFreeze(cols, rows);}
void  ImGui_TableHeader(/* Pointer */ const char * label) { return ::NS::ImGui::TableHeader(label);}
void  ImGui_TableHeadersRow() { return ::NS::ImGui::TableHeadersRow();}
void  ImGui_TableAngledHeadersRow() { return ::NS::ImGui::TableAngledHeadersRow();}
ImGuiTableSortSpecs *  ImGui_TableGetSortSpecs() { return reinterpret_cast<ImGuiTableSortSpecs * >(::NS::ImGui::TableGetSortSpecs());}
int  ImGui_TableGetColumnCount() { return ::NS::ImGui::TableGetColumnCount();}
int  ImGui_TableGetColumnIndex() { return ::NS::ImGui::TableGetColumnIndex();}
int  ImGui_TableGetRowIndex() { return ::NS::ImGui::TableGetRowIndex();}
const char *  ImGui_TableGetColumnName(/* Int */ int column_n) { return reinterpret_cast<const char * >(::NS::ImGui::TableGetColumnName(column_n));}
ImGuiTableColumnFlags  ImGui_TableGetColumnFlags(/* Int */ int column_n) { return ::NS::ImGui::TableGetColumnFlags(column_n);}
void  ImGui_TableSetColumnEnabled(/* Int */ int column_n, /* Bool */ bool v) { return ::NS::ImGui::TableSetColumnEnabled(column_n, v);}
int  ImGui_TableGetHoveredColumn() { return ::NS::ImGui::TableGetHoveredColumn();}
void  ImGui_TableSetBgColor(/* Typedef */ ImGuiTableBgTarget target, /* Typedef */ ImU32 color, /* Int */ int column_n) { return ::NS::ImGui::TableSetBgColor(target, color, column_n);}
void  ImGui_Columns(/* Int */ int count, /* Pointer */ const char * id, /* Bool */ bool borders) { return ::NS::ImGui::Columns(count, id, borders);}
void  ImGui_NextColumn() { return ::NS::ImGui::NextColumn();}
int  ImGui_GetColumnIndex() { return ::NS::ImGui::GetColumnIndex();}
float  ImGui_GetColumnWidth(/* Int */ int column_index) { return ::NS::ImGui::GetColumnWidth(column_index);}
void  ImGui_SetColumnWidth(/* Int */ int column_index, /* Float */ float width) { return ::NS::ImGui::SetColumnWidth(column_index, width);}
float  ImGui_GetColumnOffset(/* Int */ int column_index) { return ::NS::ImGui::GetColumnOffset(column_index);}
void  ImGui_SetColumnOffset(/* Int */ int column_index, /* Float */ float offset_x) { return ::NS::ImGui::SetColumnOffset(column_index, offset_x);}
int  ImGui_GetColumnsCount() { return ::NS::ImGui::GetColumnsCount();}
bool  ImGui_BeginTabBar(/* Pointer */ const char * str_id, /* Typedef */ ImGuiTabBarFlags flags) { return ::NS::ImGui::BeginTabBar(str_id, flags);}
void  ImGui_EndTabBar() { return ::NS::ImGui::EndTabBar();}
bool  ImGui_BeginTabItem(/* Pointer */ const char * label, /* Pointer */ bool * p_open, /* Typedef */ ImGuiTabItemFlags flags) { return ::NS::ImGui::BeginTabItem(label, p_open, flags);}
void  ImGui_EndTabItem() { return ::NS::ImGui::EndTabItem();}
bool  ImGui_TabItemButton(/* Pointer */ const char * label, /* Typedef */ ImGuiTabItemFlags flags) { return ::NS::ImGui::TabItemButton(label, flags);}
void  ImGui_SetTabItemClosed(/* Pointer */ const char * tab_or_docked_window_label) { return ::NS::ImGui::SetTabItemClosed(tab_or_docked_window_label);}
void  ImGui_LogToTTY(/* Int */ int auto_open_depth) { return ::NS::ImGui::LogToTTY(auto_open_depth);}
void  ImGui_LogToFile(/* Int */ int auto_open_depth, /* Pointer */ const char * filename) { return ::NS::ImGui::LogToFile(auto_open_depth, filename);}
void  ImGui_LogToClipboard(/* Int */ int auto_open_depth) { return ::NS::ImGui::LogToClipboard(auto_open_depth);}
void  ImGui_LogFinish() { return ::NS::ImGui::LogFinish();}
void  ImGui_LogButtons() { return ::NS::ImGui::LogButtons();}
void  ImGui_LogText(/* Pointer */ const char * fmt) { return ::NS::ImGui::LogText(fmt);}
void  ImGui_LogTextV(/* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::LogTextV(fmt, args);}
bool  ImGui_BeginDragDropSource(/* Typedef */ ImGuiDragDropFlags flags) { return ::NS::ImGui::BeginDragDropSource(flags);}
bool  ImGui_SetDragDropPayload(/* Pointer */ const char * type, /* Pointer */ const void * data, /* Typedef */ size_t sz, /* Typedef */ ImGuiCond cond) { return ::NS::ImGui::SetDragDropPayload(type, data, sz, cond);}
void  ImGui_EndDragDropSource() { return ::NS::ImGui::EndDragDropSource();}
bool  ImGui_BeginDragDropTarget() { return ::NS::ImGui::BeginDragDropTarget();}
const ImGuiPayload *  ImGui_AcceptDragDropPayload(/* Pointer */ const char * type, /* Typedef */ ImGuiDragDropFlags flags) { return reinterpret_cast<const ImGuiPayload * >(::NS::ImGui::AcceptDragDropPayload(type, flags));}
void  ImGui_EndDragDropTarget() { return ::NS::ImGui::EndDragDropTarget();}
const ImGuiPayload *  ImGui_GetDragDropPayload() { return reinterpret_cast<const ImGuiPayload * >(::NS::ImGui::GetDragDropPayload());}
void  ImGui_BeginDisabled(/* Bool */ bool disabled) { return ::NS::ImGui::BeginDisabled(disabled);}
void  ImGui_EndDisabled() { return ::NS::ImGui::EndDisabled();}
void  ImGui_PushClipRect(/* LValueReference */ const ImVec2 & clip_rect_min, /* LValueReference */ const ImVec2 & clip_rect_max, /* Bool */ bool intersect_with_current_clip_rect) { return ::NS::ImGui::PushClipRect(clip_rect_min, clip_rect_max, intersect_with_current_clip_rect);}
void  ImGui_PopClipRect() { return ::NS::ImGui::PopClipRect();}
void  ImGui_SetItemDefaultFocus() { return ::NS::ImGui::SetItemDefaultFocus();}
void  ImGui_SetKeyboardFocusHere(/* Int */ int offset) { return ::NS::ImGui::SetKeyboardFocusHere(offset);}
void  ImGui_SetNavCursorVisible(/* Bool */ bool visible) { return ::NS::ImGui::SetNavCursorVisible(visible);}
void  ImGui_SetNextItemAllowOverlap() { return ::NS::ImGui::SetNextItemAllowOverlap();}
bool  ImGui_IsItemHovered(/* Typedef */ ImGuiHoveredFlags flags) { return ::NS::ImGui::IsItemHovered(flags);}
bool  ImGui_IsItemActive() { return ::NS::ImGui::IsItemActive();}
bool  ImGui_IsItemFocused() { return ::NS::ImGui::IsItemFocused();}
bool  ImGui_IsItemClicked(/* Typedef */ ImGuiMouseButton mouse_button) { return ::NS::ImGui::IsItemClicked(mouse_button);}
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
bool  ImGui_IsRectVisible(/* LValueReference */ const ImVec2 & size) { return ::NS::ImGui::IsRectVisible(size);}
bool  ImGui_IsRectVisible1(/* LValueReference */ const ImVec2 & rect_min, /* LValueReference */ const ImVec2 & rect_max) { return ::NS::ImGui::IsRectVisible(rect_min, rect_max);}
double  ImGui_GetTime() { return ::NS::ImGui::GetTime();}
int  ImGui_GetFrameCount() { return ::NS::ImGui::GetFrameCount();}
ImDrawListSharedData *  ImGui_GetDrawListSharedData() { return reinterpret_cast<ImDrawListSharedData * >(::NS::ImGui::GetDrawListSharedData());}
const char *  ImGui_GetStyleColorName(/* Typedef */ ImGuiCol idx) { return reinterpret_cast<const char * >(::NS::ImGui::GetStyleColorName(idx));}
void  ImGui_SetStateStorage(/* Pointer */ ImGuiStorage * storage) { return ::NS::ImGui::SetStateStorage(reinterpret_cast<::NS::ImGuiStorage * >(storage));}
ImGuiStorage *  ImGui_GetStateStorage() { return reinterpret_cast<ImGuiStorage * >(::NS::ImGui::GetStateStorage());}
ImVec2  ImGui_CalcTextSize(/* Pointer */ const char * text, /* Pointer */ const char * text_end, /* Bool */ bool hide_text_after_double_hash, /* Float */ float wrap_width) { return std::bit_cast<ImVec2>(::NS::ImGui::CalcTextSize(text, text_end, hide_text_after_double_hash, wrap_width));}
ImVec4  ImGui_ColorConvertU32ToFloat4(/* Typedef */ ImU32 in) { return std::bit_cast<ImVec4>(::NS::ImGui::ColorConvertU32ToFloat4(in));}
ImU32  ImGui_ColorConvertFloat4ToU32(/* LValueReference */ const ImVec4 & in) { return ::NS::ImGui::ColorConvertFloat4ToU32(in);}
void  ImGui_ColorConvertRGBtoHSV(/* Float */ float r, /* Float */ float g, /* Float */ float b, /* LValueReference */ float & out_h, /* LValueReference */ float & out_s, /* LValueReference */ float & out_v) { return ::NS::ImGui::ColorConvertRGBtoHSV(r, g, b, out_h, out_s, out_v);}
void  ImGui_ColorConvertHSVtoRGB(/* Float */ float h, /* Float */ float s, /* Float */ float v, /* LValueReference */ float & out_r, /* LValueReference */ float & out_g, /* LValueReference */ float & out_b) { return ::NS::ImGui::ColorConvertHSVtoRGB(h, s, v, out_r, out_g, out_b);}
bool  ImGui_IsKeyDown(/* Enum */ ImGuiKey key) { return ::NS::ImGui::IsKeyDown(std::bit_cast<::NS::ImGuiKey >(key));}
bool  ImGui_IsKeyPressed(/* Enum */ ImGuiKey key, /* Bool */ bool repeat) { return ::NS::ImGui::IsKeyPressed(std::bit_cast<::NS::ImGuiKey >(key), repeat);}
bool  ImGui_IsKeyReleased(/* Enum */ ImGuiKey key) { return ::NS::ImGui::IsKeyReleased(std::bit_cast<::NS::ImGuiKey >(key));}
bool  ImGui_IsKeyChordPressed(/* Typedef */ ImGuiKeyChord key_chord) { return ::NS::ImGui::IsKeyChordPressed(key_chord);}
int  ImGui_GetKeyPressedAmount(/* Enum */ ImGuiKey key, /* Float */ float repeat_delay, /* Float */ float rate) { return ::NS::ImGui::GetKeyPressedAmount(std::bit_cast<::NS::ImGuiKey >(key), repeat_delay, rate);}
const char *  ImGui_GetKeyName(/* Enum */ ImGuiKey key) { return reinterpret_cast<const char * >(::NS::ImGui::GetKeyName(std::bit_cast<::NS::ImGuiKey >(key)));}
void  ImGui_SetNextFrameWantCaptureKeyboard(/* Bool */ bool want_capture_keyboard) { return ::NS::ImGui::SetNextFrameWantCaptureKeyboard(want_capture_keyboard);}
bool  ImGui_Shortcut(/* Typedef */ ImGuiKeyChord key_chord, /* Typedef */ ImGuiInputFlags flags) { return ::NS::ImGui::Shortcut(key_chord, flags);}
void  ImGui_SetNextItemShortcut(/* Typedef */ ImGuiKeyChord key_chord, /* Typedef */ ImGuiInputFlags flags) { return ::NS::ImGui::SetNextItemShortcut(key_chord, flags);}
void  ImGui_SetItemKeyOwner(/* Enum */ ImGuiKey key) { return ::NS::ImGui::SetItemKeyOwner(std::bit_cast<::NS::ImGuiKey >(key));}
bool  ImGui_IsMouseDown(/* Typedef */ ImGuiMouseButton button) { return ::NS::ImGui::IsMouseDown(button);}
bool  ImGui_IsMouseClicked(/* Typedef */ ImGuiMouseButton button, /* Bool */ bool repeat) { return ::NS::ImGui::IsMouseClicked(button, repeat);}
bool  ImGui_IsMouseReleased(/* Typedef */ ImGuiMouseButton button) { return ::NS::ImGui::IsMouseReleased(button);}
bool  ImGui_IsMouseDoubleClicked(/* Typedef */ ImGuiMouseButton button) { return ::NS::ImGui::IsMouseDoubleClicked(button);}
bool  ImGui_IsMouseReleasedWithDelay(/* Typedef */ ImGuiMouseButton button, /* Float */ float delay) { return ::NS::ImGui::IsMouseReleasedWithDelay(button, delay);}
int  ImGui_GetMouseClickedCount(/* Typedef */ ImGuiMouseButton button) { return ::NS::ImGui::GetMouseClickedCount(button);}
bool  ImGui_IsMouseHoveringRect(/* LValueReference */ const ImVec2 & r_min, /* LValueReference */ const ImVec2 & r_max, /* Bool */ bool clip) { return ::NS::ImGui::IsMouseHoveringRect(r_min, r_max, clip);}
bool  ImGui_IsMousePosValid(/* Pointer */ const ImVec2 * mouse_pos) { return ::NS::ImGui::IsMousePosValid(reinterpret_cast<const ::NS::ImVec2 * >(mouse_pos));}
bool  ImGui_IsAnyMouseDown() { return ::NS::ImGui::IsAnyMouseDown();}
ImVec2  ImGui_GetMousePos() { return std::bit_cast<ImVec2>(::NS::ImGui::GetMousePos());}
ImVec2  ImGui_GetMousePosOnOpeningCurrentPopup() { return std::bit_cast<ImVec2>(::NS::ImGui::GetMousePosOnOpeningCurrentPopup());}
bool  ImGui_IsMouseDragging(/* Typedef */ ImGuiMouseButton button, /* Float */ float lock_threshold) { return ::NS::ImGui::IsMouseDragging(button, lock_threshold);}
ImVec2  ImGui_GetMouseDragDelta(/* Typedef */ ImGuiMouseButton button, /* Float */ float lock_threshold) { return std::bit_cast<ImVec2>(::NS::ImGui::GetMouseDragDelta(button, lock_threshold));}
void  ImGui_ResetMouseDragDelta(/* Typedef */ ImGuiMouseButton button) { return ::NS::ImGui::ResetMouseDragDelta(button);}
ImGuiMouseCursor  ImGui_GetMouseCursor() { return ::NS::ImGui::GetMouseCursor();}
void  ImGui_SetMouseCursor(/* Typedef */ ImGuiMouseCursor cursor_type) { return ::NS::ImGui::SetMouseCursor(cursor_type);}
void  ImGui_SetNextFrameWantCaptureMouse(/* Bool */ bool want_capture_mouse) { return ::NS::ImGui::SetNextFrameWantCaptureMouse(want_capture_mouse);}
const char *  ImGui_GetClipboardText() { return reinterpret_cast<const char * >(::NS::ImGui::GetClipboardText());}
void  ImGui_SetClipboardText(/* Pointer */ const char * text) { return ::NS::ImGui::SetClipboardText(text);}
void  ImGui_LoadIniSettingsFromDisk(/* Pointer */ const char * ini_filename) { return ::NS::ImGui::LoadIniSettingsFromDisk(ini_filename);}
void  ImGui_LoadIniSettingsFromMemory(/* Pointer */ const char * ini_data, /* Typedef */ size_t ini_size) { return ::NS::ImGui::LoadIniSettingsFromMemory(ini_data, ini_size);}
void  ImGui_SaveIniSettingsToDisk(/* Pointer */ const char * ini_filename) { return ::NS::ImGui::SaveIniSettingsToDisk(ini_filename);}
const char *  ImGui_SaveIniSettingsToMemory(/* Pointer */ size_t * out_ini_size) { return reinterpret_cast<const char * >(::NS::ImGui::SaveIniSettingsToMemory(out_ini_size));}
void  ImGui_DebugTextEncoding(/* Pointer */ const char * text) { return ::NS::ImGui::DebugTextEncoding(text);}
void  ImGui_DebugFlashStyleColor(/* Typedef */ ImGuiCol idx) { return ::NS::ImGui::DebugFlashStyleColor(idx);}
void  ImGui_DebugStartItemPicker() { return ::NS::ImGui::DebugStartItemPicker();}
bool  ImGui_DebugCheckVersionAndDataLayout(/* Pointer */ const char * version_str, /* Typedef */ size_t sz_io, /* Typedef */ size_t sz_style, /* Typedef */ size_t sz_vec2, /* Typedef */ size_t sz_vec4, /* Typedef */ size_t sz_drawvert, /* Typedef */ size_t sz_drawidx) { return ::NS::ImGui::DebugCheckVersionAndDataLayout(version_str, sz_io, sz_style, sz_vec2, sz_vec4, sz_drawvert, sz_drawidx);}
void  ImGui_DebugLog(/* Pointer */ const char * fmt) { return ::NS::ImGui::DebugLog(fmt);}
void  ImGui_DebugLogV(/* Pointer */ const char * fmt, /* Typedef */ va_list args) { return ::NS::ImGui::DebugLogV(fmt, args);}
void  ImGui_SetAllocatorFunctions(/* Typedef */ ImGuiMemAllocFunc alloc_func, /* Typedef */ ImGuiMemFreeFunc free_func, /* Pointer */ void * user_data) { return ::NS::ImGui::SetAllocatorFunctions(alloc_func, free_func, user_data);}
void  ImGui_GetAllocatorFunctions(/* Pointer */ ImGuiMemAllocFunc * p_alloc_func, /* Pointer */ ImGuiMemFreeFunc * p_free_func, /* Pointer */ void ** p_user_data) { return ::NS::ImGui::GetAllocatorFunctions(p_alloc_func, p_free_func, p_user_data);}
void *  ImGui_MemAlloc(/* Typedef */ size_t size) { return reinterpret_cast<void * >(::NS::ImGui::MemAlloc(size));}
void  ImGui_MemFree(/* Pointer */ void * ptr) { return ::NS::ImGui::MemFree(ptr);}
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
struct Better_ImGuiTableSortSpecs {
/* Pointer */ const ImGuiTableColumnSortSpecs * Specs;
/* Int */ int SpecsCount;
/* Bool */ bool SpecsDirty;
};
struct Better_ImGuiTableColumnSortSpecs {
/* Typedef */ ImGuiID ColumnUserID;
/* Typedef */ ImS16 ColumnIndex;
/* Typedef */ ImS16 SortOrder;
/* Enum */ ImGuiSortDirection SortDirection;
};
typedef struct Better_ImNewWrapper Better_ImNewWrapper;
struct Better_ImGuiStyle {
/* Float */ float FontSizeBase;
/* Float */ float FontScaleMain;
/* Float */ float FontScaleDpi;
/* Float */ float Alpha;
/* Float */ float DisabledAlpha;
/* Record */ ImVec2 WindowPadding;
/* Float */ float WindowRounding;
/* Float */ float WindowBorderSize;
/* Float */ float WindowBorderHoverPadding;
/* Record */ ImVec2 WindowMinSize;
/* Record */ ImVec2 WindowTitleAlign;
/* Enum */ ImGuiDir WindowMenuButtonPosition;
/* Float */ float ChildRounding;
/* Float */ float ChildBorderSize;
/* Float */ float PopupRounding;
/* Float */ float PopupBorderSize;
/* Record */ ImVec2 FramePadding;
/* Float */ float FrameRounding;
/* Float */ float FrameBorderSize;
/* Record */ ImVec2 ItemSpacing;
/* Record */ ImVec2 ItemInnerSpacing;
/* Record */ ImVec2 CellPadding;
/* Record */ ImVec2 TouchExtraPadding;
/* Float */ float IndentSpacing;
/* Float */ float ColumnsMinSpacing;
/* Float */ float ScrollbarSize;
/* Float */ float ScrollbarRounding;
/* Float */ float GrabMinSize;
/* Float */ float GrabRounding;
/* Float */ float LogSliderDeadzone;
/* Float */ float ImageBorderSize;
/* Float */ float TabRounding;
/* Float */ float TabBorderSize;
/* Float */ float TabCloseButtonMinWidthSelected;
/* Float */ float TabCloseButtonMinWidthUnselected;
/* Float */ float TabBarBorderSize;
/* Float */ float TabBarOverlineSize;
/* Float */ float TableAngledHeadersAngle;
/* Record */ ImVec2 TableAngledHeadersTextAlign;
/* Typedef */ ImGuiTreeNodeFlags TreeLinesFlags;
/* Float */ float TreeLinesSize;
/* Float */ float TreeLinesRounding;
/* Enum */ ImGuiDir ColorButtonPosition;
/* Record */ ImVec2 ButtonTextAlign;
/* Record */ ImVec2 SelectableTextAlign;
/* Float */ float SeparatorTextBorderSize;
/* Record */ ImVec2 SeparatorTextAlign;
/* Record */ ImVec2 SeparatorTextPadding;
/* Record */ ImVec2 DisplayWindowPadding;
/* Record */ ImVec2 DisplaySafeAreaPadding;
/* Float */ float MouseCursorScale;
/* Bool */ bool AntiAliasedLines;
/* Bool */ bool AntiAliasedLinesUseTex;
/* Bool */ bool AntiAliasedFill;
/* Float */ float CurveTessellationTol;
/* Float */ float CircleTessellationMaxError;
/* ConstantArray */ ImVec4 Colors[58];
/* Float */ float HoverStationaryDelay;
/* Float */ float HoverDelayShort;
/* Float */ float HoverDelayNormal;
/* Typedef */ ImGuiHoveredFlags HoverFlagsForTooltipMouse;
/* Typedef */ ImGuiHoveredFlags HoverFlagsForTooltipNav;
/* Float */ float _MainScale;
/* Float */ float _NextFrameFontSizeBase;
};
struct Better_ImGuiKeyData {
/* Bool */ bool Down;
/* Float */ float DownDuration;
/* Float */ float DownDurationPrev;
/* Float */ float AnalogValue;
};
struct Better_ImGuiIO {
/* Typedef */ ImGuiConfigFlags ConfigFlags;
/* Typedef */ ImGuiBackendFlags BackendFlags;
/* Record */ ImVec2 DisplaySize;
/* Record */ ImVec2 DisplayFramebufferScale;
/* Float */ float DeltaTime;
/* Float */ float IniSavingRate;
/* Pointer */ const char * IniFilename;
/* Pointer */ const char * LogFilename;
/* Pointer */ void * UserData;
/* Pointer */ ImFontAtlas * Fonts;
/* Pointer */ ImFont * FontDefault;
/* Bool */ bool FontAllowUserScaling;
/* Bool */ bool ConfigNavSwapGamepadButtons;
/* Bool */ bool ConfigNavMoveSetMousePos;
/* Bool */ bool ConfigNavCaptureKeyboard;
/* Bool */ bool ConfigNavEscapeClearFocusItem;
/* Bool */ bool ConfigNavEscapeClearFocusWindow;
/* Bool */ bool ConfigNavCursorVisibleAuto;
/* Bool */ bool ConfigNavCursorVisibleAlways;
/* Bool */ bool MouseDrawCursor;
/* Bool */ bool ConfigMacOSXBehaviors;
/* Bool */ bool ConfigInputTrickleEventQueue;
/* Bool */ bool ConfigInputTextCursorBlink;
/* Bool */ bool ConfigInputTextEnterKeepActive;
/* Bool */ bool ConfigDragClickToInputText;
/* Bool */ bool ConfigWindowsResizeFromEdges;
/* Bool */ bool ConfigWindowsMoveFromTitleBarOnly;
/* Bool */ bool ConfigWindowsCopyContentsWithCtrlC;
/* Bool */ bool ConfigScrollbarScrollByPage;
/* Float */ float ConfigMemoryCompactTimer;
/* Float */ float MouseDoubleClickTime;
/* Float */ float MouseDoubleClickMaxDist;
/* Float */ float MouseDragThreshold;
/* Float */ float KeyRepeatDelay;
/* Float */ float KeyRepeatRate;
/* Bool */ bool ConfigErrorRecovery;
/* Bool */ bool ConfigErrorRecoveryEnableAssert;
/* Bool */ bool ConfigErrorRecoveryEnableDebugLog;
/* Bool */ bool ConfigErrorRecoveryEnableTooltip;
/* Bool */ bool ConfigDebugIsDebuggerPresent;
/* Bool */ bool ConfigDebugHighlightIdConflicts;
/* Bool */ bool ConfigDebugHighlightIdConflictsShowItemPicker;
/* Bool */ bool ConfigDebugBeginReturnValueOnce;
/* Bool */ bool ConfigDebugBeginReturnValueLoop;
/* Bool */ bool ConfigDebugIgnoreFocusLoss;
/* Bool */ bool ConfigDebugIniSettings;
/* Pointer */ const char * BackendPlatformName;
/* Pointer */ const char * BackendRendererName;
/* Pointer */ void * BackendPlatformUserData;
/* Pointer */ void * BackendRendererUserData;
/* Pointer */ void * BackendLanguageUserData;
/* Bool */ bool WantCaptureMouse;
/* Bool */ bool WantCaptureKeyboard;
/* Bool */ bool WantTextInput;
/* Bool */ bool WantSetMousePos;
/* Bool */ bool WantSaveIniSettings;
/* Bool */ bool NavActive;
/* Bool */ bool NavVisible;
/* Float */ float Framerate;
/* Int */ int MetricsRenderVertices;
/* Int */ int MetricsRenderIndices;
/* Int */ int MetricsRenderWindows;
/* Int */ int MetricsActiveWindows;
/* Record */ ImVec2 MouseDelta;
/* Pointer */ ImGuiContext * Ctx;
/* Record */ ImVec2 MousePos;
/* ConstantArray */ bool MouseDown[5];
/* Float */ float MouseWheel;
/* Float */ float MouseWheelH;
/* Enum */ ImGuiMouseSource MouseSource;
/* Bool */ bool KeyCtrl;
/* Bool */ bool KeyShift;
/* Bool */ bool KeyAlt;
/* Bool */ bool KeySuper;
/* Typedef */ ImGuiKeyChord KeyMods;
/* ConstantArray */ ImGuiKeyData KeysData[155];
/* Bool */ bool WantCaptureMouseUnlessPopupClose;
/* Record */ ImVec2 MousePosPrev;
/* ConstantArray */ ImVec2 MouseClickedPos[5];
/* ConstantArray */ double MouseClickedTime[5];
/* ConstantArray */ bool MouseClicked[5];
/* ConstantArray */ bool MouseDoubleClicked[5];
/* ConstantArray */ ImU16 MouseClickedCount[5];
/* ConstantArray */ ImU16 MouseClickedLastCount[5];
/* ConstantArray */ bool MouseReleased[5];
/* ConstantArray */ double MouseReleasedTime[5];
/* ConstantArray */ bool MouseDownOwned[5];
/* ConstantArray */ bool MouseDownOwnedUnlessPopupClose[5];
/* Bool */ bool MouseWheelRequestAxisSwap;
/* Bool */ bool MouseCtrlLeftAsRightClick;
/* ConstantArray */ float MouseDownDuration[5];
/* ConstantArray */ float MouseDownDurationPrev[5];
/* ConstantArray */ float MouseDragMaxDistanceSqr[5];
/* Float */ float PenPressure;
/* Bool */ bool AppFocusLost;
/* Bool */ bool AppAcceptingEvents;
/* Typedef */ ImWchar16 InputQueueSurrogate;
/* Unexposed */ void * InputQueueCharacters;
};
struct Better_ImGuiInputTextCallbackData {
/* Pointer */ ImGuiContext * Ctx;
/* Typedef */ ImGuiInputTextFlags EventFlag;
/* Typedef */ ImGuiInputTextFlags Flags;
/* Pointer */ void * UserData;
/* Typedef */ ImWchar EventChar;
/* Enum */ ImGuiKey EventKey;
/* Pointer */ char * Buf;
/* Int */ int BufTextLen;
/* Int */ int BufSize;
/* Bool */ bool BufDirty;
/* Int */ int CursorPos;
/* Int */ int SelectionStart;
/* Int */ int SelectionEnd;
};
struct Better_ImGuiSizeCallbackData {
/* Pointer */ void * UserData;
/* Record */ ImVec2 Pos;
/* Record */ ImVec2 CurrentSize;
/* Record */ ImVec2 DesiredSize;
};
struct Better_ImGuiPayload {
/* Pointer */ void * Data;
/* Int */ int DataSize;
/* Typedef */ ImGuiID SourceId;
/* Typedef */ ImGuiID SourceParentId;
/* Int */ int DataFrameCount;
/* ConstantArray */ char DataType[33];
/* Bool */ bool Preview;
/* Bool */ bool Delivery;
};
struct Better_ImGuiOnceUponAFrame {
/* Int */ int RefFrame;
};
struct Better_ImGuiTextFilter {
/* ConstantArray */ char InputBuf[256];
/* Unexposed */ void * Filters;
/* Int */ int CountGrep;
};
struct Better_ImGuiTextRange {
/* Pointer */ const char * b;
/* Pointer */ const char * e;
};
struct Better_ImGuiTextBuffer {
/* Unexposed */ void * Buf;
};
struct Better_ImGuiStoragePair {
/* Typedef */ ImGuiID key;
};
struct Better_ImGuiStorage {
/* Unexposed */ void * Data;
};
struct Better_ImGuiListClipper {
/* Pointer */ ImGuiContext * Ctx;
/* Int */ int DisplayStart;
/* Int */ int DisplayEnd;
/* Int */ int ItemsCount;
/* Float */ float ItemsHeight;
/* Double */ double StartPosY;
/* Double */ double StartSeekOffsetY;
/* Pointer */ void * TempData;
};
struct Better_ImColor {
/* Record */ ImVec4 Value;
};
enum ImGuiMultiSelectFlags_ {
};
struct Better_ImGuiMultiSelectIO {
/* Unexposed */ void * Requests;
/* Typedef */ ImGuiSelectionUserData RangeSrcItem;
/* Typedef */ ImGuiSelectionUserData NavIdItem;
/* Bool */ bool NavIdSelected;
/* Bool */ bool RangeSrcReset;
/* Int */ int ItemsCount;
};
enum ImGuiSelectionRequestType {
};
struct Better_ImGuiSelectionRequest {
/* Enum */ ImGuiSelectionRequestType Type;
/* Bool */ bool Selected;
/* Typedef */ ImS8 RangeDirection;
/* Typedef */ ImGuiSelectionUserData RangeFirstItem;
/* Typedef */ ImGuiSelectionUserData RangeLastItem;
};
struct Better_ImGuiSelectionBasicStorage {
/* Int */ int Size;
/* Bool */ bool PreserveOrder;
/* Pointer */ void * UserData;
/* Pointer */ ImGuiID (*AdapterIndexToStorageId)(ImGuiSelectionBasicStorage *, int);
/* Int */ int _SelectionOrder;
/* Record */ ImGuiStorage _Storage;
};
struct Better_ImGuiSelectionExternalStorage {
/* Pointer */ void * UserData;
/* Pointer */ void (*AdapterSetItemSelected)(ImGuiSelectionExternalStorage *, int, bool);
};
typedef unsigned short Better_ImDrawIdx;
typedef ::NS::ImDrawCallback Better_ImDrawCallback;
struct Better_ImDrawCmd {
/* Record */ ImVec4 ClipRect;
/* Record */ ImTextureRef TexRef;
/* UInt */ unsigned int VtxOffset;
/* UInt */ unsigned int IdxOffset;
/* UInt */ unsigned int ElemCount;
/* Typedef */ ImDrawCallback UserCallback;
/* Pointer */ void * UserCallbackData;
/* Int */ int UserCallbackDataSize;
/* Int */ int UserCallbackDataOffset;
};
struct Better_ImDrawVert {
/* Record */ ImVec2 pos;
/* Record */ ImVec2 uv;
/* Typedef */ ImU32 col;
};
struct Better_ImDrawCmdHeader {
/* Record */ ImVec4 ClipRect;
/* Record */ ImTextureRef TexRef;
/* UInt */ unsigned int VtxOffset;
};
struct Better_ImDrawChannel {
/* Unexposed */ void * _CmdBuffer;
/* Unexposed */ void * _IdxBuffer;
};
struct Better_ImDrawListSplitter {
/* Int */ int _Current;
/* Int */ int _Count;
/* Unexposed */ void * _Channels;
};
enum ImDrawFlags_ {
};
enum ImDrawListFlags_ {
};
struct Better_ImDrawList {
/* Unexposed */ void * CmdBuffer;
/* Unexposed */ void * IdxBuffer;
/* Unexposed */ void * VtxBuffer;
/* Typedef */ ImDrawListFlags Flags;
/* UInt */ unsigned int _VtxCurrentIdx;
/* Pointer */ ImDrawListSharedData * _Data;
/* Pointer */ ImDrawVert * _VtxWritePtr;
/* Pointer */ ImDrawIdx * _IdxWritePtr;
/* Unexposed */ void * _Path;
/* Record */ ImDrawCmdHeader _CmdHeader;
/* Record */ ImDrawListSplitter _Splitter;
/* Unexposed */ void * _ClipRectStack;
/* Unexposed */ void * _TextureStack;
/* Unexposed */ void * _CallbacksDataBuf;
/* Float */ float _FringeScale;
/* Pointer */ const char * _OwnerName;
};
struct Better_ImDrawData {
/* Bool */ bool Valid;
/* Int */ int CmdListsCount;
/* Int */ int TotalIdxCount;
/* Int */ int TotalVtxCount;
/* Unexposed */ void * CmdLists;
/* Record */ ImVec2 DisplayPos;
/* Record */ ImVec2 DisplaySize;
/* Record */ ImVec2 FramebufferScale;
/* Pointer */ ImGuiViewport * OwnerViewport;
/* Pointer */ void **Textures;
};
enum ImTextureFormat {
};
enum ImTextureStatus {
};
struct Better_ImTextureRect {
/* UShort */ unsigned short x;
/* UShort */ unsigned short y;
/* UShort */ unsigned short w;
/* UShort */ unsigned short h;
};
struct Better_ImTextureData {
/* Int */ int UniqueID;
/* Enum */ ImTextureStatus Status;
/* Pointer */ void * BackendUserData;
/* Typedef */ ImTextureID TexID;
/* Enum */ ImTextureFormat Format;
/* Int */ int Width;
/* Int */ int Height;
/* Int */ int BytesPerPixel;
/* Pointer */ unsigned char * Pixels;
/* Record */ ImTextureRect UsedRect;
/* Record */ ImTextureRect UpdateRect;
/* Unexposed */ void * Updates;
/* Int */ int UnusedFrames;
/* UShort */ unsigned short RefCount;
/* Bool */ bool UseColors;
/* Bool */ bool WantDestroyNextFrame;
};
struct Better_ImFontConfig {
/* ConstantArray */ char Name[40];
/* Pointer */ void * FontData;
/* Int */ int FontDataSize;
/* Bool */ bool FontDataOwnedByAtlas;
/* Bool */ bool MergeMode;
/* Bool */ bool PixelSnapH;
/* Bool */ bool PixelSnapV;
/* Typedef */ ImS8 OversampleH;
/* Typedef */ ImS8 OversampleV;
/* Typedef */ ImWchar EllipsisChar;
/* Float */ float SizePixels;
/* Pointer */ const ImWchar * GlyphRanges;
/* Pointer */ const ImWchar * GlyphExcludeRanges;
/* Record */ ImVec2 GlyphOffset;
/* Float */ float GlyphMinAdvanceX;
/* Float */ float GlyphMaxAdvanceX;
/* Float */ float GlyphExtraAdvanceX;
/* Typedef */ ImU32 FontNo;
/* UInt */ unsigned int FontLoaderFlags;
/* Float */ float RasterizerMultiply;
/* Float */ float RasterizerDensity;
/* Typedef */ ImFontFlags Flags;
/* Pointer */ ImFont * DstFont;
/* Pointer */ const ImFontLoader * FontLoader;
/* Pointer */ void * FontLoaderData;
};
struct Better_ImFontGlyph {
/* UInt */ unsigned int Colored;
/* UInt */ unsigned int Visible;
/* UInt */ unsigned int SourceIdx;
/* UInt */ unsigned int Codepoint;
/* Float */ float AdvanceX;
/* Float */ float X0;
/* Float */ float Y0;
/* Float */ float X1;
/* Float */ float Y1;
/* Float */ float U0;
/* Float */ float V0;
/* Float */ float U1;
/* Float */ float V1;
/* Int */ int PackId;
};
struct Better_ImFontGlyphRangesBuilder {
/* Unexposed */ void * UsedChars;
};
typedef int Better_ImFontAtlasRectId;
struct Better_ImFontAtlasRect {
/* UShort */ unsigned short x;
/* UShort */ unsigned short y;
/* UShort */ unsigned short w;
/* UShort */ unsigned short h;
/* Record */ ImVec2 uv0;
/* Record */ ImVec2 uv1;
};
enum ImFontAtlasFlags_ {
};
struct Better_ImFontAtlas {
/* Typedef */ ImFontAtlasFlags Flags;
/* Enum */ ImTextureFormat TexDesiredFormat;
/* Int */ int TexGlyphPadding;
/* Int */ int TexMinWidth;
/* Int */ int TexMinHeight;
/* Int */ int TexMaxWidth;
/* Int */ int TexMaxHeight;
/* Pointer */ void * UserData;
/* Record */ ImTextureRef TexRef;
/* Pointer */ ImTextureData * TexData;
/* Unexposed */ void * TexList;
/* Bool */ bool Locked;
/* Bool */ bool RendererHasTextures;
/* Bool */ bool TexIsBuilt;
/* Bool */ bool TexPixelsUseColors;
/* Record */ ImVec2 TexUvScale;
/* Record */ ImVec2 TexUvWhitePixel;
/* Unexposed */ void * Fonts;
/* Unexposed */ void * Sources;
/* ConstantArray */ ImVec4 TexUvLines[33];
/* Int */ int TexNextUniqueID;
/* Int */ int FontNextUniqueID;
/* Unexposed */ void * DrawListSharedDatas;
/* Pointer */ ImFontAtlasBuilder * Builder;
/* Pointer */ const ImFontLoader * FontLoader;
/* Pointer */ const char * FontLoaderName;
/* Pointer */ void * FontLoaderData;
/* UInt */ unsigned int FontLoaderFlags;
/* Int */ int RefCount;
/* Pointer */ ImGuiContext * OwnerContext;
};
struct Better_ImFontBaked {
/* Unexposed */ void * IndexAdvanceX;
/* Float */ float FallbackAdvanceX;
/* Float */ float Size;
/* Float */ float RasterizerDensity;
/* Unexposed */ void * IndexLookup;
/* Unexposed */ void * Glyphs;
/* Int */ int FallbackGlyphIndex;
/* Float */ float Ascent;
/* Float */ float Descent;
/* UInt */ unsigned int MetricsTotalSurface;
/* UInt */ unsigned int WantDestroy;
/* UInt */ unsigned int LockLoadingFallback;
/* Int */ int LastUsedFrame;
/* Typedef */ ImGuiID BakedId;
/* Pointer */ ImFont * ContainerFont;
/* Pointer */ void * FontLoaderDatas;
};
enum ImFontFlags_ {
};
struct Better_ImFont {
/* Pointer */ ImFontBaked * LastBaked;
/* Pointer */ ImFontAtlas * ContainerAtlas;
/* Typedef */ ImFontFlags Flags;
/* Float */ float CurrentRasterizerDensity;
/* Typedef */ ImGuiID FontId;
/* Float */ float LegacySize;
/* Unexposed */ void * Sources;
/* Typedef */ ImWchar EllipsisChar;
/* Typedef */ ImWchar FallbackChar;
/* ConstantArray */ ImU8 Used8kPagesMap[1];
/* Bool */ bool EllipsisAutoBake;
/* Record */ ImGuiStorage RemapPairs;
};
enum ImGuiViewportFlags_ {
};
struct Better_ImGuiViewport {
/* Typedef */ ImGuiID ID;
/* Typedef */ ImGuiViewportFlags Flags;
/* Record */ ImVec2 Pos;
/* Record */ ImVec2 Size;
/* Record */ ImVec2 FramebufferScale;
/* Record */ ImVec2 WorkPos;
/* Record */ ImVec2 WorkSize;
/* Pointer */ void * PlatformHandle;
/* Pointer */ void * PlatformHandleRaw;
};
struct Better_ImGuiPlatformIO {
/* Pointer */ const char *(*Platform_GetClipboardTextFn)(ImGuiContext *);
/* Pointer */ void (*Platform_SetClipboardTextFn)(ImGuiContext *, const char *);
/* Pointer */ void * Platform_ClipboardUserData;
/* Pointer */ bool (*Platform_OpenInShellFn)(ImGuiContext *, const char *);
/* Pointer */ void * Platform_OpenInShellUserData;
/* Pointer */ void (*Platform_SetImeDataFn)(ImGuiContext *, ImGuiViewport *, ImGuiPlatformImeData *);
/* Pointer */ void * Platform_ImeUserData;
/* Typedef */ ImWchar Platform_LocaleDecimalPoint;
/* Int */ int Renderer_TextureMaxWidth;
/* Int */ int Renderer_TextureMaxHeight;
/* Pointer */ void * Renderer_RenderState;
/* Unexposed */ void * Textures;
};
struct Better_ImGuiPlatformImeData {
/* Bool */ bool WantVisible;
/* Bool */ bool WantTextInput;
/* Record */ ImVec2 InputPos;
/* Float */ float InputLineHeight;
/* Typedef */ ImGuiID ViewportId;
};
}
