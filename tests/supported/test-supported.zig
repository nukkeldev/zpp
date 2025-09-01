const std = @import("std");
const bindings = @import("zpp-bindings");

pub fn main() void {
    var s: bindings.Struct = .{
        .x = 2,
        .y = 1,
    };
    bindings.ret_struct(&s);
    std.debug.print("\nS.x = {}\n", .{s.x});
}
