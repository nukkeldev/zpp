const std = @import("std");
const IR = @import("../ir/IR.zig");

pub fn formatFilename(allocator: std.mem.Allocator, filename: []const u8) std.mem.Allocator.Error![]const u8 {
    return std.fmt.allocPrint(allocator, "{s}.cpp", .{filename});
}

pub fn formatFile(
    ir: IR,
    writer: *std.Io.Writer,
) std.Io.Writer.Error!void {
    _ = ir;
    _ = writer;
}