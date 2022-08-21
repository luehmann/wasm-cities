const std = @import("std");
const main = @import("main");

const Vec2 = main.Vec2;

pub fn Rect(comptime T: type) type {
    return struct {
        min: Vec2(T),
        max: Vec2(T),

        const Self = @This();

        pub fn fromPoints(a: Vec2(T), b: Vec2(T)) Self {
            return .{
                .min = .{ .x = std.math.min(a.x, b.x), .y = std.math.min(a.y, b.y) },
                .max = .{ .x = std.math.max(a.x, b.x), .y = std.math.max(a.y, b.y) },
            };
        }

        pub fn fromPointWithDimensions(point: Vec2(T), w: T, h: T) Self {
            return .{
                .min = point,
                .max = point.add(.{ .x = w, .y = h }),
            };
        }

        pub fn fromPoint(point: Vec2(T)) Self {
            return .{ .min = point, .max = point };
        }

        pub fn width(self: Self) T {
            return self.max.x - self.min.x;
        }

        pub fn height(self: Self) T {
            return self.max.y - self.min.y;
        }

        pub fn intersects(b1: Self, b2: Self) bool {
            return !(b2.min.x >= b1.max.x or b2.max.x <= b1.min.x or b2.min.y >= b1.max.y or b2.max.y <= b1.min.y);
        }
    };
}
