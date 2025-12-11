const std = @import("std");
const aoc = @import("root.zig");

const Interval = struct {
    start: u128,
    end: u128,

    const SortingCtx = struct {};

    fn lessThanIntervalFn(_: SortingCtx, lhs: Interval, rhs: Interval) bool {
        if (lhs.start != rhs.start) {
            return lhs.start < rhs.start;
        }
        return lhs.end < rhs.end;
    }
};

pub fn run() !void {
    const problem = "day_5";
    const path = "./inputs/" ++ problem ++ ".txt";

    const size = 10 << 20;
    var buf: [size]u8 = undefined;
    const content = try aoc.read_file(path, &buf);

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var it = std.mem.splitScalar(u8, content, '\n');
    var reading_intervals = true;
    var intervals = try std.ArrayList(Interval).initCapacity(allocator, 0);

    while (it.next()) |line| {
        const s = std.mem.trim(u8, line, " \r\t");
        if (s.len == 0) {
            reading_intervals = false;
            continue;
        }

        std.debug.print("{s}\n", .{s});
        if (reading_intervals) {
            if (std.mem.indexOfScalar(u8, s, '-')) |sep_index| {
                const from = try std.fmt.parseInt(u128, s[0..sep_index], 10);
                const to = try std.fmt.parseInt(u128, s[sep_index + 1 ..], 10);
                try intervals.append(allocator, .{ .start = from, .end = to });
            }
        } else {
            break;
        }
    }

    const ctx: Interval.SortingCtx = .{};
    std.mem.sort(Interval, intervals.items, ctx, Interval.lessThanIntervalFn);

    std.debug.print("Intervals: {any}\n", .{intervals.items});

    var merged_intervals = try std.ArrayList(Interval).initCapacity(allocator, intervals.items.len);
    var current = intervals.items[0];
    for (1..intervals.items.len) |i| {
        const next = intervals.items[i];

        if (next.start <= current.end) {
            if (next.end > current.end) {
                current.end = next.end;
            }
        } else {
            try merged_intervals.append(allocator, current);
            current = intervals.items[i];
        }
    }

    try merged_intervals.append(allocator, current);

    var result: u128 = 0;
    for (merged_intervals.items) |interval| {
        result += interval.end - interval.start + 1;
    }

    std.debug.print("Merged Intervals: {any}\n", .{merged_intervals.items});

    std.debug.print("result: {d}\n", .{result});
}
