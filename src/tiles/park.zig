const std = @import("std");
const main = @import("main");
const w4 = @import("wasm4");

const Demand = main.Demand;
const sprites = main.sprites;
const Vec2 = main.Vec2;
const utils = main.utils;

pub const Park = packed struct {
    width_store: u2,
    height_store: u2,
    water_index: u2,
    has_water: bool,
    flip_x: bool,
    flip_y: bool,

    pub fn random(prng: *std.rand.DefaultPrng) Park {
        const w = prng.random().uintLessThan(usize, 4);
        const h = prng.random().uintLessThan(usize, 4);
        const min = std.math.min(w, h);
        const max = std.math.max(w, h);

        const has_water = ((max == 3 and min >= 2) or (max == 2 and min >= 1)) and prng.random().boolean();
        const water_index = prng.random().uintLessThan(u2, 3);

        return Park{
            .width_store = @intCast(u2, w),
            .height_store = @intCast(u2, h),
            .water_index = water_index,
            .has_water = has_water,
            .flip_x = prng.random().boolean(),
            .flip_y = prng.random().boolean(),
        };
    }

    pub fn render(self: Park, position: Vec2(i32)) void {
        w4.draw_colors.* = 0x1;
        w4.rect(position.x, position.y, self.width() * 8, self.height() * 8);
        w4.draw_colors.* = if (self.has_water) 0x2 else 0x3;
        w4.rect(position.x + 1, position.y + 1, self.width() * 8 - 2, self.height() * 8 - 2);
        if (self.has_water) {
            const min = std.math.min(self.width(), self.height());
            const max = std.math.max(self.width(), self.height());
            var blit_flags = w4.BLIT_1BPP;
            if (self.width() == min) blit_flags |= w4.BLIT_ROTATE;
            if (self.flip_x) blit_flags |= w4.BLIT_FLIP_X;
            if (self.flip_y) blit_flags |= w4.BLIT_FLIP_Y;
            w4.draw_colors.* = 0x30;
            w4.blit(
                sprites.sprites + getSprites(min, max)[self.water_index],
                position.x,
                position.y,
                max * 8,
                min * 8,
                blit_flags,
            );
        }
    }

    fn getSprites(min: i32, max: i32) []const usize {
        if (max == 3 and min == 2) return &sprites.parks_3x2;
        if (max == 3 and min == 3) return &sprites.parks_3x3;
        if (max == 4 and min == 3) return &sprites.parks_4x3;
        if (max == 4 and min == 4) return &sprites.parks_4x4;
        unreachable;
    }

    pub fn supplyingDemand(self: Park) Demand {
        return Demand{
            .green = true,
            .water = self.has_water,
        };
    }

    pub fn width(self: Park) i32 {
        return @as(i32, self.width_store) + 1;
    }

    pub fn height(self: Park) i32 {
        return @as(i32, self.height_store) + 1;
    }
};
