const std = @import("std");
const server = @import("./network/server.zig");

fn runTCPServer(allocator: std.mem.Allocator) !void {
    try server.start(allocator);
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    try runTCPServer(allocator);
}
