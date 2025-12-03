const std = @import("std");

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
