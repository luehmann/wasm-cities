const std = @import("std");
const main = @import("main");
const w4 = @import("wasm4");

const Demand = main.Demand;
const sprites = main.sprites;
const Vec2 = main.Vec2;
const utils = main.utils;

pub const CityBlock = packed struct {
    width_store: u2,
    height_store: u2,
    north_tile: u4,
    east_tile: u4,
    south_tile: u4,
    west_tile: u4,
    north_tile_flipped: bool,
    east_tile_flipped: bool,
    south_tile_flipped: bool,
    west_tile_flipped: bool,
    demand_satisfied: Demand,

    pub fn random(prng: *std.rand.DefaultPrng) CityBlock {
        const width_store = prng.random().uintLessThan(usize, 4);
        const height_store = prng.random().uintLessThan(usize, 4);
        const width_sprite_count = getSpriteCount(width_store);
        const height_sprite_count = getSpriteCount(height_store);
        const north_tile = prng.random().uintLessThan(usize, width_sprite_count);
        const east_tile = prng.random().uintLessThan(usize, height_sprite_count);
        const south_tile = prng.random().uintLessThan(usize, width_sprite_count);
        const west_tile = prng.random().uintLessThan(usize, height_sprite_count);
        const north_tile_flipped = prng.random().boolean();
        const east_tile_flipped = prng.random().boolean();
        const south_tile_flipped = prng.random().boolean();
        const west_tile_flipped = prng.random().boolean();

        return CityBlock{
            .width_store = @intCast(u2, width_store),
            .height_store = @intCast(u2, height_store),
            .north_tile = @intCast(u4, north_tile),
            .east_tile = @intCast(u4, east_tile),
            .south_tile = @intCast(u4, south_tile),
            .west_tile = @intCast(u4, west_tile),
            .north_tile_flipped = north_tile_flipped,
            .east_tile_flipped = east_tile_flipped,
            .south_tile_flipped = south_tile_flipped,
            .west_tile_flipped = west_tile_flipped,
            .demand_satisfied = Demand{},
        };
    }

    fn getSpriteCount(size: usize) usize {
        return switch (size) {
            0 => sprites.city_blocks_1x1.len,
            1 => sprites.city_blocks_2x1.len,
            2 => sprites.city_blocks_3x1.len,
            3 => sprites.city_blocks_4x1.len,
            else => unreachable,
        };
    }

    pub fn render(self: CityBlock, position: Vec2(i32)) void {
        const pixel_width: i32 = self.width() * 8;
        const pixel_height: i32 = self.height() * 8;

        w4.draw_colors.* = 0x1;
        w4.rect(
            position.x,
            position.y,
            pixel_width,
            pixel_height,
        );
        const horizontal_sprites = getSprites(self.width_store);
        const vertical_sprites = getSprites(self.height_store);

        w4.draw_colors.* = 0x40;
        w4.blit(
            sprites.sprites + horizontal_sprites[self.north_tile],
            position.x,
            position.y,
            pixel_width,
            8,
            w4.BLIT_1BPP | w4.BLIT_FLIP_Y | if (self.north_tile_flipped) w4.BLIT_FLIP_X else 0,
        );
        w4.blit(
            sprites.sprites + vertical_sprites[self.east_tile],
            position.x + @as(i32, self.width_store) * 8,
            position.y,
            pixel_height,
            8,
            w4.BLIT_1BPP | w4.BLIT_ROTATE | if (self.east_tile_flipped) w4.BLIT_FLIP_X else 0,
        );
        w4.blit(
            sprites.sprites + horizontal_sprites[self.south_tile],
            position.x,
            position.y + @as(i32, self.height_store) * 8,
            pixel_width,
            8,
            w4.BLIT_1BPP | if (self.south_tile_flipped) w4.BLIT_FLIP_X else 0,
        );
        w4.blit(
            sprites.sprites + vertical_sprites[self.west_tile],
            position.x,
            position.y,
            pixel_height,
            8,
            w4.BLIT_1BPP | w4.BLIT_ROTATE | w4.BLIT_FLIP_Y | if (self.west_tile_flipped) w4.BLIT_FLIP_X else 0,
        );
    }

    fn getSprites(size: usize) []const usize {
        return switch (size) {
            0 => &sprites.city_blocks_1x1,
            1 => &sprites.city_blocks_2x1,
            2 => &sprites.city_blocks_3x1,
            3 => &sprites.city_blocks_4x1,
            else => unreachable,
        };
    }

    pub fn supplyingDemand(self: CityBlock) Demand {
        _ = self;
        return Demand{};
    }

    pub fn width(self: CityBlock) i32 {
        return @as(i32, self.width_store) + 1;
    }

    pub fn height(self: CityBlock) i32 {
        return @as(i32, self.height_store) + 1;
    }
};
