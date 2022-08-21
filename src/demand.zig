const std = @import("std");
const main = @import("main");
const w4 = @import("wasm4");

const Vec2 = main.Vec2;

pub const Demand = packed struct {
    water: bool = false,
    green: bool = false,
    _padding: u6 = 0, // TODO: workaround for zig stage1 compiler bug

    const IntType = std.meta.Int(.unsigned, @bitSizeOf(Demand));

    pub fn add(a: Demand, b: Demand) Demand {
        return @bitCast(Demand, @bitCast(IntType, a) | @bitCast(IntType, b));
    }

    pub fn getNew(current: Demand, new: Demand) Demand {
        return @bitCast(Demand, @bitCast(IntType, current) ^ @bitCast(IntType, new) & @bitCast(IntType, new));
    }

    pub fn render(self: Demand, pos: Vec2(i32)) void {
        if (!self.water and !self.green) return;
        w4.draw_colors.* = 0x1;
        w4.rect(pos.x, pos.y, 8, 8);
        w4.draw_colors.* = 0x41;
        w4.rect(pos.x + 1, pos.y + 1, 6, 6);
        w4.draw_colors.* = 0x2;
        if (self.water) w4.hline(pos.x + 3, pos.y + 3, 2);
        w4.draw_colors.* = 0x3;
        if (self.green) w4.hline(pos.x + 3, pos.y + 4, 2);
    }
};

test "add" {
    const a = Demand{ .water = true };
    const b = Demand{ .green = true };

    const ab = Demand{ .water = true, .green = true };

    try std.testing.expectEqual(ab, a.add(b));
}

test "getNew" {
    const current = Demand{ .water = true };
    const new = Demand{ .water = true, .green = true };

    const expected = Demand{ .green = true };

    try std.testing.expectEqual(expected, current.getNew(new));
}
