const std = @import("std");
const main = @import("main");

const vec2 = main.vec2;
const Vec2 = main.Vec2;
const Rect = main.Rect;

pos: Vec2(i32) = vec2(i32, 0, 0),

const Self = @This();

pub fn screenToWorld(self: Self, screen_pos: Vec2(i32)) Vec2(i32) {
    return screen_pos.add(self.pos).divFloor(8);
}

pub fn worldToScreen(self: Self, world_pos: Vec2(i32)) Vec2(i32) {
    return world_pos.scale(8).subtract(self.pos);
}

pub fn getScreenRect(self: Self) Rect(i32) {
    return Rect(i32).fromPointWithDimensions(
        self.pos.divFloor(8),
        21,
        21,
    );
}
