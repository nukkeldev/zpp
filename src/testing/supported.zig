const std = @import("std");
const bindings = @import("zpp-bindings");

pub fn main() void {
    const s: bindings.Struct = bindings.ret_struct();
    std.debug.print("\nS.x = {}\n", .{s.x});
}