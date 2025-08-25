const std = @import("std");

pub const c = @cImport({
    @cInclude("clang-c/Index.h");
});

// -- Helpers -- //

// Spelling

pub const getCursorSpelling = getSafeCXStringFn(c.CXCursor, c.clang_getCursorSpelling);
pub const getCursorKindSpelling = getSafeCXStringFn(c.CXCursorKind, c.clang_getCursorKindSpelling);

pub const getTypeSpelling = getSafeCXStringFn(c.CXType, c.clang_getTypeSpelling);
pub const getTypeKindSpelling = getSafeCXStringFn(c.CXTypeKind, c.clang_getTypeKindSpelling);

pub fn getSafeCXStringFn(
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

// Location

pub const SourceLocation = struct {
    line: usize,
    column: usize,
    offset: usize,

    pub fn fromCursor(cursor: c.CXCursor) SourceLocation {
        var line: c_uint = 0;
        var column: c_uint = 0;
        var offset: c_uint = 0;
        c.clang_getExpansionLocation(c.clang_getCursorLocation(cursor), null, &line, &column, &offset);

        return .{
            .line = @intCast(line),
            .column = @intCast(column),
            .offset = @intCast(offset),
        };
    }
};