const std = @import("std");

pub fn day_2() !void {
    const problem = "day_2";
    const path = "./inputs/" ++ problem ++ ".txt";

    const size = 10 << 20;
    var buf: [size]u8 = undefined;
    const content = try read_file(path, &buf);

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
                    // std.debug.print("Invalid ID: {d}\n", .{id});
                    sum += id;
                }
            }
        }
    }

    std.debug.print("result: {d}\n", .{sum});
}

pub fn day_1() !void {
    const problem = "day_1_1";
    const path = "./inputs/" ++ problem ++ ".txt";

    const size = 10 << 20;
    var buf: [size]u8 = undefined;
    const content = try read_file(path, &buf);

    var result: i32 = 0;
    var pos: i32 = 50;

    var it = std.mem.splitScalar(u8, content, '\n');
    while (it.next()) |line| {
        const trimmed = std.mem.trim(u8, line, " \r\t");
        if (trimmed.len == 0) continue;

        const dir = trimmed[0];
        const count = try std.fmt.parseInt(i32, trimmed[1..], 10);
        const mul: i32 = if (dir == 'L') -1 else 1;

        const count_usize: usize = @intCast(count);
        for (0..count_usize) |_| {
            const turn: i32 = mul;
            pos += turn;
            pos = @mod(pos, 100);
            if (pos == 0) {
                result += 1;
            }
        }
    }

    std.debug.print("result: {d}\n", .{result});
}

fn read_file(path: []const u8, buf: []u8) ![]u8 {
    return try std.fs.cwd().readFile(path, buf);
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

    // for (lps.items) |elem| {
    //     std.debug.print("{}, ", .{elem});
    // }
    // std.debug.print("\n", .{});

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
