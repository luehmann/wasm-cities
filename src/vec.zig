const std = @import("std");
const main = @import("main");

const Rect = main.Rect;

pub fn vec2(comptime T: type, x: T, y: T) Vec2(T) {
    return Vec2(T){ .x = x, .y = y };
}

pub fn Vec2(comptime T: type) type {
    return struct {
        x: T = 0,
        y: T = 0,

        const Self = @This();

        pub fn divFloor(self: Self, denominator: T) Self {
            return Self{ .x = @divFloor(self.x, denominator), .y = @divFloor(self.y, denominator) };
        }

        pub fn add(self: Self, b: Self) Self {
            return Self{ .x = self.x + b.x, .y = self.y + b.y };
        }

        pub fn subtract(self: Self, b: Self) Self {
            return Self{ .x = self.x - b.x, .y = self.y - b.y };
        }

        pub fn scale(self: Self, factor: T) Self {
            return Self{ .x = self.x * factor, .y = self.y * factor };
        }

        pub fn intCast(self: Self, comptime DestType: type) Vec2(DestType) {
            return .{
                .x = @intCast(DestType, self.x),
                .y = @intCast(DestType, self.y),
            };
        }
        pub fn clamp(self: Self, lower: Self, upper: Self) Self {
            return .{
                .x = std.math.clamp(self.x, lower.x, upper.x),
                .y = std.math.clamp(self.y, lower.y, upper.y),
            };
        }

        pub fn as(self: Self, comptime DestType: type) Vec2(DestType) {
            return .{
                .x = @as(DestType, self.x),
                .y = @as(DestType, self.y),
            };
        }

        pub fn magnitudeSquared(self: Self) T {
            return self.x * self.x + self.y * self.y;
        }

        pub fn isWithin(self: Self, rect: Rect(T)) bool {
            return !(rect.min.x > self.x or rect.max.x < self.x or rect.min.y > self.y or rect.max.y < self.y);
        }
    };
}

test "magnitudeSquared" {
    try std.testing.expectEqual(@as(f64, 34), Vec2(f64).magnitudeSquared(.{ .x = 3.0, .y = -5.0 }));
    try std.testing.expectEqual(@as(i8, 34), Vec2(i8).magnitudeSquared(.{ .x = -3, .y = 5 }));
}
