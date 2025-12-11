const std = @import("std");
const aoc = @import("root.zig");

pub fn run() !void {
    const problem = "day_2";
    const path = "./inputs/" ++ problem ++ ".txt";

    const size = 10 << 20;
    var buf: [size]u8 = undefined;
    const content = try aoc.read_file(path, &buf);

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var sum: u128 = 0;
    var it = std.mem.splitScalar(u8, content, ',');
    while (it.next()) |line| {
        const range = std.mem.trim(u8, line, " \r\t");
        if (range.len == 0) continue;

        if (std.mem.indexOfScalar(u8, range, '-')) |index| {
            const from_str = range[0..index];
            const to_str = std.mem.trim(u8, range[index + 1 ..], "\n");

            const from = try std.fmt.parseInt(usize, from_str, 10);
            const to = try std.fmt.parseInt(usize, to_str, 10);

            for (from..to + 1) |id| {
                const id_str = try std.fmt.allocPrint(arena.allocator(), "{d}", .{id});
                const repeated_seq = is_repeated_sequence(id_str);
                if (repeated_seq) {
                    sum += id;
                }
            }
        }
    }

    std.debug.print("result: {d}\n", .{sum});
}

fn is_repeated_sequence(str: []const u8) bool {
    const n = str.len;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var lps: std.ArrayList(usize) = .empty;
    lps.resize(allocator, str.len) catch |err| {
        std.debug.print("{}\n", .{err});
        return false;
    };
    for (lps.items) |*elem| {
        elem.* = 0;
    }

    _ = build_lps(str, &lps.items) catch |err| {
        std.debug.print("{}\n", .{err});
        return false;
    };

    const L = lps.items[lps.items.len - 1];

    return n > 1 and L != 0 and @mod(n, n - L) == 0;
}

fn build_lps(str: []const u8, lps: *[]usize) !*[]usize {
    const n = str.len;
    if (lps.len != n) {
        std.debug.print("{} != {}\n", .{ lps.len, str.len });
        return error.lpsBufferLengthMismatch;
    }

    var i: usize = 1;
    var len: usize = 0;

    while (i < n) {
        if (str[i] == str[len]) {
            len += 1;
            lps.*[i] = len;
            i += 1;
        } else {
            if (len != 0) {
                len = lps.*[len - 1];
            } else {
                len = 0;
                i += 1;
            }
        }
    }

    return lps;
}
