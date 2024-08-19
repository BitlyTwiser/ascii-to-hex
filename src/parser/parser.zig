const std = @import("std");
const cli = @import("../cli/cli.zig");
const cli_error = cli.FileError;

pub fn toHex(allocator: std.mem.Allocator, data: []const u8) ![]const u8 {
    const hex_len = data.len * 3 - 1;
    var hex_data = try allocator.alloc(u8, hex_len);

    for (data, 0..) |arg, i| {
        const start = i * 3;
        _ = try std.fmt.bufPrint(hex_data[start .. start + 2], "{X:0>2}", .{arg});
        if (start + 2 < hex_data.len - 1) {
            hex_data[start + 2] = ' ';
        }
    }

    return hex_data;
}
