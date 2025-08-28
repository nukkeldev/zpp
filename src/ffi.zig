const std = @import("std");

pub const c = @cImport({
    @cInclude("clang-c/Index.h");
});

// -- Types -- //

pub fn isTypeDeclaredInMainFile(cx_type: c.CXType) bool {
    const declaration = c.clang_getTypeDeclaration(cx_type);
    return c.clang_Location_isFromMainFile(c.clang_getCursorLocation(declaration)) != 0;
}

pub fn isTypeComplete(cx_type: c.CXType) bool {
    return c.clang_Type_getSizeOf(cx_type) != c.CXTypeLayoutError_Incomplete;
}

// -- Cursors -- //

pub fn isCursorCanonical(cursor: c.CXCursor) bool {
    const canonical_cursor = c.clang_getCanonicalCursor(cursor);
    return c.clang_equalCursors(cursor, canonical_cursor) != 0;
}

// -- Spelling -- //

pub fn convertStringFn(
    comptime T: type,
    comptime func: *const fn (T) callconv(.c) c.CXString,
) fn (std.mem.Allocator, T) std.mem.Allocator.Error![]const u8 {
    return struct {
        fn f(allocator: std.mem.Allocator, thing: T) std.mem.Allocator.Error![]const u8 {
            const str = func(thing);
            defer c.clang_disposeString(str);

            const cstr_opt = c.clang_getCString(str);
            return if (cstr_opt) |cstr| try allocator.dupe(u8, std.mem.span(cstr)) else "";
        }
    }.f;
}

pub const getCursorSpelling = convertStringFn(c.CXCursor, c.clang_getCursorSpelling);
pub const getCursorKindSpelling = convertStringFn(c.CXCursorKind, c.clang_getCursorKindSpelling);

pub const getTypeSpelling = convertStringFn(c.CXType, c.clang_getTypeSpelling);
pub const getTypeKindSpelling = convertStringFn(c.CXTypeKind, c.clang_getTypeKindSpelling);

pub const getDiagnosticSpelling = convertStringFn(c.CXDiagnostic, c.clang_getDiagnosticSpelling);

pub const getFileName = convertStringFn(c.CXFile, c.clang_getFileName);

// -- Location -- //

pub const SourceLocation = struct {
    line: usize,
    column: usize,
    offset: usize,
    file: ?[]const u8,

    /// TODO: Deprecate for `fromCXSourceLocation`.
    pub fn fromCursor(cursor: c.CXCursor) SourceLocation {
        var line: c_uint = 0;
        var column: c_uint = 0;
        var offset: c_uint = 0;
        c.clang_getExpansionLocation(c.clang_getCursorLocation(cursor), null, &line, &column, &offset);

        return .{
            .line = @intCast(line),
            .column = @intCast(column),
            .offset = @intCast(offset),
            .file = null, // TODO
        };
    }

    pub fn fromCXSourceLocation(allocator: std.mem.Allocator, location: c.CXSourceLocation) !SourceLocation {
        var line: c_uint = 0;
        var column: c_uint = 0;
        var offset: c_uint = 0;
        var file: c.CXFile = undefined;
        c.clang_getExpansionLocation(location, &file, &line, &column, &offset);

        return .{
            .line = @intCast(line),
            .column = @intCast(column),
            .offset = @intCast(offset),
            .file = try getFileName(allocator, file),
        };
    }

    pub fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        if (self.file) |file| allocator.free(file);
    }
};

// -- Diagnostics -- //

const MINIMUM_DIAGNOSTIC_LEVEL = c.CXDiagnostic_Warning;

pub fn printDiagnostic(allocator: std.mem.Allocator, diagnostic: c.CXDiagnostic) !void {
    const severity = c.clang_getDiagnosticSeverity(diagnostic);
    if (severity < MINIMUM_DIAGNOSTIC_LEVEL) return;

    const location = try SourceLocation.fromCXSourceLocation(allocator, c.clang_getDiagnosticLocation(diagnostic));
    defer location.deinit(allocator);
    const spelling = try getDiagnosticSpelling(allocator, diagnostic);
    defer allocator.free(spelling);

    var str = std.array_list.Managed(u8).init(allocator);
    defer str.deinit();

    if (severity == c.CXDiagnostic_Fatal) try str.appendSlice("[FATAL] ");
    try str.print("\"{s}\" on {s}:{}", .{ spelling, std.fs.path.basename(location.file.?), location.line });

    switch (severity) {
        c.CXDiagnostic_Fatal, c.CXDiagnostic_Error => std.log.scoped(.clang).err("{s}", .{str.items}),
        c.CXDiagnostic_Warning => std.log.scoped(.clang).warn("{s}", .{str.items}),
        c.CXDiagnostic_Note => std.log.scoped(.clang).info("{s}", .{str.items}),
        c.CXDiagnostic_Ignored => return,
        else => unreachable,
    }
}

// -- Formatters --

pub fn formatCXCursorDetailed(cursor: c.CXCursor, writer: *std.Io.Writer) std.Io.Writer.Error!void {
    const name = getCursorSpelling(std.heap.page_allocator, cursor) catch @panic("OOM");
    defer std.heap.page_allocator.free(name);
    const kind = getCursorKindSpelling(std.heap.page_allocator, cursor.kind) catch @panic("OOM");
    defer std.heap.page_allocator.free(kind);

    const location = SourceLocation.fromCXSourceLocation(std.heap.page_allocator, c.clang_getCursorLocation(cursor)) catch @panic("OOM");
    defer location.deinit(std.heap.page_allocator);

    try writer.print("Cursor '{s}' ({s}) is on {s}:{}.", .{ name, kind, std.fs.path.basename(location.file.?), location.line });

    const cursor_type = c.clang_getCursorType(cursor);
    if (cursor_type.kind != c.CXType_Invalid) {
        const type_name = getTypeSpelling(std.heap.page_allocator, cursor_type) catch @panic("OOM");
        defer std.heap.page_allocator.free(type_name);
        const type_kind = getTypeKindSpelling(std.heap.page_allocator, cursor_type.kind) catch @panic("OOM");
        defer std.heap.page_allocator.free(type_kind);

        try writer.print("\n  It has a type of '{s}' ({s}).\n  ", .{
            type_name,
            type_kind,
        });

        const size = c.clang_Type_getSizeOf(cursor_type);
        const alignment = c.clang_Type_getAlignOf(cursor_type);

        switch (size) {
            c.CXTypeLayoutError_Invalid => try writer.print("It's type is invalid.", .{}),
            c.CXTypeLayoutError_Incomplete => try writer.print("It's type is incomplete.", .{}),
            c.CXTypeLayoutError_Dependent => try writer.print("It's type is dependent.", .{}),
            c.CXTypeLayoutError_NotConstantSize => try writer.print("It's type is not a constant size.", .{}),
            c.CXTypeLayoutError_InvalidFieldName => unreachable,
            c.CXTypeLayoutError_Undeduced => try writer.print("It's type is undeduced.", .{}),
            else => try writer.print("It's type has a size of {} byte(s) and aligned to {} byte(s).", .{
                size,
                alignment,
            }),
        }
    }

    if (isCursorCanonical(cursor)) {
        try writer.writeAll("\n  This cursor is canonical.");
    } else {
        const canonical_cursor = c.clang_getCanonicalCursor(cursor);
        const canonical_location = SourceLocation.fromCXSourceLocation(std.heap.page_allocator, c.clang_getCursorLocation(canonical_cursor)) catch @panic("OOM");
        defer canonical_location.deinit(std.heap.page_allocator);

        try writer.print("\n  This cursor's canonical cursor is defined on {s}:{}", .{ std.fs.path.basename(location.file.?), location.line });
    }
}
