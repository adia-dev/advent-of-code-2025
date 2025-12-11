const std = @import("std");
const aoc = @import("root.zig");

pub fn run() !void {
    const problem = "day_6";
    const path = "./inputs/" ++ problem ++ ".txt";

    const size = 10 << 20;
    var buf: [size]u8 = undefined;
    const content = try aoc.read_file(path, &buf);

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const Vector = std.ArrayList;
    var maths = try Vector(Vector([]const u8)).initCapacity(allocator, 0);

    var it = std.mem.splitScalar(u8, content, '\n');
    while (it.next()) |line| {
        const trimmed_line = std.mem.trim(u8, line, " \r\t");
        if (trimmed_line.len == 0) {
            continue;
        }

        var trimmed_line_it = std.mem.splitScalar(u8, trimmed_line, ' ');
        var math_line = try Vector([]const u8).initCapacity(allocator, 0);
        while (trimmed_line_it.next()) |v| {
            const math = std.mem.trim(u8, v, " \r\t\n");
            if (math.len == 0) continue;

            try math_line.append(allocator, math);
        }

        try maths.append(allocator, math_line);
    }

    var result: u128 = 0;
    for (0..maths.items[0].items.len) |i| {
        const multiply = if (maths.items[maths.items.len - 1].items[i][0] == '*') true else false;
        var res: u128 = if (multiply) 1 else 0;
        for (0..maths.items.len - 1) |j| {
            const number = try std.fmt.parseInt(u128, maths.items[j].items[i], 10);
            res = if (multiply) res * number else res + number;
        }
        result += res;
    }

    std.debug.print("result: {d}\n", .{result});
}
