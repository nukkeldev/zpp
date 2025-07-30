//! Given the results of `read.zig`'s parsing, outputs an `extern "C"` compatible .cpp file for FFI
//! usage as well as a Zig binding.

// -- Imports -- //

const std = @import("std");

const AST = @import("Reader.zig").AST;
const Allocator = std.mem.Allocator;

// -- C++ -- //

pub fn formatASTAsCppHeader(ast: AST, writer: *std.io.Writer) std.io.Writer.Error!void {
    _ = ast;
    _ = writer;
}

// -- Zig -- //

pub fn formatASTAsZigBindings(ast: AST, writer: *std.io.Writer) std.io.Writer.Error!void {
    _ = ast;
    _ = writer;
}