//! Debug timer to track durations of tasks with std.log.

const std = @import("std");

pub fn Timer(comptime logger: type) type {
    return struct {
        start: i64,
        lap_: i64,

        pub fn init() @This() {
            const start = getNs();
            return .{
                .start = start,
                .lap_ = start,
            };
        }

        pub fn lap(timer: *@This(), comptime fmt: []const u8, args: anytype) void {
            const t = getNs();
            logger.debug(fmt ++ " in {D}.", args ++ .{t - timer.lap_});
            timer.lap_ = t;
        }

        fn getNs() i64 {
            return @truncate(std.time.nanoTimestamp());
        }
    };
}
