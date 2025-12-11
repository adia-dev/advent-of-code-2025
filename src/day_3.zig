const std = @import("std");
const aoc = @import("root.zig | update");

pub fn run() !void {
    const problem = "day_3";
    const path = "./inputs/" ++ problem ++ ".txt";

    const size = 10 << 20;
    var buf: [size]u8 = undefined;
    const content = try aoc.read_file(path, &buf);

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const K: usize = 12;

    var sum: u128 = 0;
    var it = std.mem.splitScalar(u8, content, '\n');
    while (it.next()) |line| {
        const bank = std.mem.trim(u8, line, " \r\t");
        if (bank.len == 0) continue;

        const best = try maxSubsequenceK(bank, K);

        var value: u64 = 0;
        for (best) |c| {
            const d: u8 = c - '0';
            value = value * 10 + @as(u64, d);
        }

        sum += value;
    }

    std.debug.print("result: {d}\n", .{sum});
}

fn maxSubsequenceK(bank: []const u8, comptime K: usize) ![K]u8 {
    const n = bank.len;
    if (n < K) {
        return error.BankTooShort;
    }

    var result: [K]u8 = undefined;

    var pos: usize = 0;
    var picked: usize = 0;

    while (picked < K) : (picked += 1) {
        const remaining = K - picked;
        const search_end = n - remaining;

        std.debug.assert(pos <= search_end);

        var best_idx: usize = pos;
        var best_digit: u8 = bank[pos];

        var i: usize = pos + 1;
        while (i <= search_end) : (i += 1) {
            const d = bank[i];
            if (d > best_digit) {
                best_digit = d;
                best_idx = i;

                if (best_digit == '9') break;
            }
        }

        result[picked] = best_digit;
        pos = best_idx + 1;
    }

    return result;
}
