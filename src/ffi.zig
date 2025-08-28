const std = @import("std");

pub const c = @cImport({
    @cInclude("clang-c/Index.h");
});

// -- Spelling -- //

pub fn convertStringFn(
    comptime T: type,
    comptime func: *const fn (T) callconv(.c) c.CXString,
) fn (std.mem.Allocator, T) std.mem.Allocator.Error![]const u8 {
    return struct {
        fn f(allocator: std.mem.Allocator, thing: T) std.mem.Allocator.Error![]const u8 {
            const str = func(thing);
            defer c.clang_disposeString(str);

            return try allocator.dupe(u8, std.mem.span(c.clang_getCString(str)));
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
