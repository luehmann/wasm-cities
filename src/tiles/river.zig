const std = @import("std");
const main = @import("main");
const w4 = @import("wasm4");

const Demand = main.Demand;
const Vec2 = main.Vec2;

const RiverType = enum(u2) {
    canal,
};

pub const River = packed struct {
    river_type: RiverType,
    width_store: u3,
    height_store: u3,

    pub fn random(prng: *std.rand.DefaultPrng) River {
        return switch (prng.random().enumValue(RiverType)) {
            .canal => blk: {
                const is_horizontal = prng.random().boolean();
                const length = @intCast(u3, prng.random().uintLessThan(usize, std.math.maxInt(u3)) + 1);
                break :blk River{
                    .river_type = .canal,
                    .width_store = if (is_horizontal) length else 0,
                    .height_store = if (is_horizontal) 0 else length,
                };
            },
        };
    }

    pub fn render(self: River, position: Vec2(i32)) void {
        switch (self.river_type) {
            .canal => {
                w4.draw_colors.* = 0x2;
                if (self.height_store == 0) {
                    w4.rect(position.x, position.y + 1, self.width() * 8, self.height() * 8 - 2);
                } else {
                    w4.rect(position.x + 1, position.y, self.width() * 8 - 2, self.height() * 8);
                }
            },
        }
    }

    pub fn supplyingDemand(self: River) Demand {
        _ = self;
        return Demand{
            .water = true,
        };
    }

    pub fn width(self: River) i32 {
        return @as(i32, self.width_store) + 1;
    }

    pub fn height(self: River) i32 {
        return @as(i32, self.height_store) + 1;
    }
};
