const std = @import("std");
const net = std.net;
const print = std.debug.print;

// Client is output by the zig build command with the name of client
pub fn main() !void {
    var args = std.process.args();
    // The first (0 index) Argument is the path to the program.
    _ = args.skip();
    const port_value = args.next() orelse {
        print("expect port as command line argument\n", .{});
        return error.NoPort;
    };
    const port = try std.fmt.parseInt(u16, port_value, 10);

    const peer = try net.Address.parseIp4("127.0.0.1", port);
    const stream = try net.tcpConnectToAddress(peer);
    defer stream.close();
    print("Connecting to {}\n", .{peer});

    var writer = stream.writer();

    var threads: [1]std.Thread = undefined;
    threads[0] = try std.Thread.spawn(.{}, readResp, .{stream});

    _ = try writer.write("hello zig");
    _ = try writer.writeByte(0xFF);

    // Await all threads
    for (threads) |thread| {
        thread.join();
    }
}

fn readResp(stream: net.Stream) !void {
    while (true) {
        var buf: [1024]u8 = undefined;
        const bytes_read = try stream.reader().read(&buf);
        if (bytes_read == 0) break;
        print("data - {s}", .{buf});

        break;
    }
}
