const std = @import("std");
const IR = @import("../ir/IR.zig");

pub const IRWriter = struct {
    formatFilename: *const fn (std.mem.Allocator, []const u8) std.mem.Allocator.Error![]const u8,
    formatFile: *const fn (IR, *std.Io.Writer) std.Io.Writer.Error!void,
};

pub const CppWrapper: IRWriter = .{
    .formatFilename = @import("cpp_wrapper.zig").formatFilename,
    .formatFile = @import("cpp_wrapper.zig").formatFile,
};

pub fn writeToFile(allocator: std.mem.Allocator, ir: IR, ir_writer: IRWriter, filename: []const u8) !void {
    var file = try std.fs.cwd().createFile(try ir_writer.formatFilename(allocator, filename), .{});
    defer file.close();

    var io_writer = file.writer(&.{});
    try ir_writer.formatFile(ir, &io_writer.interface);
}