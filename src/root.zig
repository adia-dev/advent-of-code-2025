const std = @import("std");

pub const day1 = @import("day_1.zig");
pub const day2 = @import("day_2.zig");
pub const day3 = @import("day_3.zig");
pub const day4 = @import("day_4.zig");
pub const day5 = @import("day_5.zig");
pub const day6 = @import("day_6.zig");

pub fn read_file(path: []const u8, buf: []u8) ![]u8 {
    return try std.fs.cwd().readFile(path, buf);
}
