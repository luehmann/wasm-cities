const std = @import("std");
const main = @import("main");
const w4 = @import("wasm4");

const sprites = main.sprites;

pub fn renderText(str: []const u8, x: i32, y: i32) void {
    for (str) |char, index| {
        renderChar(char, x + @intCast(i32, index) * 4, y);
    }
}

fn renderChar(char: u8, x: i32, y: i32) void {
    std.debug.assert(' ' <= char and char <= 'Z');
    w4.blitSub(sprites.sprites + sprites.font.buffer_index, x, y, 3, sprites.font.height, (char - ' ') * 3, 0, sprites.font.width, 0);
}

pub const TextAlignment = enum {
    left,
    center,
    right,
};

pub fn renderTextAligned(str: []const u8, x: i32, y: i32, comptime alignment: TextAlignment) void {
    const final_x = switch (alignment) {
        .left => x,
        .center => x - @intCast(i32, str.len * 4 / 2),
        .right => x - @intCast(i32, str.len * 4),
    };
    renderText(str, final_x, y);
}
