const std = @import("std");
const Manager = @import("Manager.zig");
const log = std.log.scoped(.juicebox);

// https://github.com/ziglang/zig/issues/938
//pub const io_mode = .evented;

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    switch (std.Target.current.os.tag) {
        .openbsd => {
            _ = std.c.pledge("stdio rpath wpath cpath proc exec unix unveil", null);
        },
        else => {},
    }

    log.info("Starting juicebox...", .{});

    const manager = try Manager.init(&gpa.allocator);
    defer manager.deinit();

    log.info("Juicebox initialized", .{});

    try manager.run();
}
