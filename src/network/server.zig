const std = @import("std");
const builtin = @import("builtin");
const net = std.net;
const print = std.debug.print;
const parser = @import("../parser/parser.zig");

const server_address = net.Address.initIp4(.{ 127, 0, 0, 1 }, 9001);

pub fn start(allocator: std.mem.Allocator) !void {
    const localhost = net.Address{ .in = server_address.in };
    var server = try localhost.listen(.{
        .reuse_port = true,
    });
    defer server.deinit();

    const addr = server.listen_address;
    print("Listening on {}, access this port to write to the program\n", .{addr.getPort()});

    while (true) {
        var client = try server.accept();
        defer client.stream.close();

        print("client connected from IP {}\n", .{client.address.in});

        var buf: [1024]u8 = undefined;
        const message = try client.stream.reader().readUntilDelimiter(&buf, 0xFF);

        print("{s}\n", .{message});
        const hex = try parser.toHex(allocator, message);

        _ = try client.stream.writer().write(hex);
    }
}
