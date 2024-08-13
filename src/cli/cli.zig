const std = @import("std");

const max_cli_arg_len: u8 = 1;
const max_file_bytes = std.math.maxInt(i32);

pub const FileError = error{ ArgOutOfBounds, NotEnoughArgs };

pub fn getCLIArgs(alloc: std.mem.Allocator) FileError![max_cli_arg_len][]const u8 {
    var cli_args: [max_cli_arg_len][]const u8 = undefined;
    var args = try std.process.argsWithAllocator(alloc);
    defer args.deinit();

    var arg_count: u8 = 0;

    // Skip the first line since its only containing the scipt name
    _ = args.skip();

    // We could also memory slice past the first value, then iterave over the given args. This is without allocation
    // const args = std.mem.sliceTo(std.os.argv[1], 0);

    while (args.next()) |arg| : (arg_count += 1) {
        if (arg_count > max_cli_arg_len) {
            return FileError.ArgOutOfBounds;
        }
        cli_args[arg_count] = arg;
    }

    if (arg_count != max_cli_arg_len) {
        return FileError.NotEnoughArgs;
    }

    return cli_args;
}
