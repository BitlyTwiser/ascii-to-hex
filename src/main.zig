const std = @import("std");
const cli = @import("./cli/cli.zig");
const cli_error = cli.FileError;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const args = cli.getCLIArgs(allocator) catch |err| {
        switch (err) {
            cli_error.ArgOutOfBounds => {
                std.debug.print("{s}\n", .{"Too many arguments, only 1 string allowed"});
            },
            cli_error.NotEnoughArgs => {
                std.debug.print("{s}\n", .{"No arguments passed to application. Please pass a string to convet to ascii"});
            },
        }
        return;
    };

    for (args[0]) |arg| {
        std.debug.print("{X:0>2} ", .{arg});
    }
}
