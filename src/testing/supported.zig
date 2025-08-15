const std = @import("std");
const bindings = @import("zpp-bindings");

pub fn main() void {
    var s: bindings.Struct = undefined;
    bindings.ret_struct(&s);
    std.debug.print("\nS.x = {}\n", .{s.x});
}