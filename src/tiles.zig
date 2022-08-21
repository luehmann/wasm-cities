const std = @import("std");
const main = @import("main");
const w4 = @import("wasm4");

const Demand = main.Demand;
const sprites = main.sprites;
const Vec2 = main.Vec2;
const utils = main.utils;

pub const CityBlock = @import("tiles/city_block.zig").CityBlock;
pub const River = @import("tiles/river.zig").River;
pub const Park = @import("tiles/park.zig").Park;

pub const TileTag = enum(u2) {
    city_block,
    park,
    river,
};

pub const Tile = union(TileTag) {
    city_block: CityBlock,
    park: Park,
    river: River,

    pub fn random(default_prng: *std.rand.DefaultPrng, tile_type_prng: *std.rand.DefaultPrng) Tile {
        const tile_tag = utils.randomWeighted(TileTag, 3, .{
            .{ .value = .city_block, .weight = 65 },
            .{ .value = .park, .weight = 20 },
            .{ .value = .river, .weight = 15 },
        }, tile_type_prng.random());
        return switch (tile_tag) {
            .city_block => Tile{ .city_block = CityBlock.random(default_prng) },
            .park => Tile{ .park = Park.random(default_prng) },
            .river => Tile{ .river = River.random(default_prng) },
        };
    }

    pub fn render(self: Tile, position: Vec2(i32)) void {
        switch (self) {
            .city_block => self.city_block.render(position),
            .park => self.park.render(position),
            .river => self.river.render(position),
        }
    }

    pub fn supplyingDemand(self: Tile) Demand {
        return switch (self) {
            .city_block => self.city_block.supplyingDemand(),
            .park => self.park.supplyingDemand(),
            .river => self.river.supplyingDemand(),
        };
    }

    pub fn width(self: Tile) i32 {
        return switch (self) {
            .city_block => self.city_block.width(),
            .park => self.park.width(),
            .river => self.river.width(),
        };
    }

    pub fn height(self: Tile) i32 {
        return switch (self) {
            .city_block => self.city_block.height(),
            .park => self.park.height(),
            .river => self.river.height(),
        };
    }
};
