const std = @import("std");
const main = @import("main");
const w4 = @import("wasm4");

const tiles = main.tiles;
const Rect = main.Rect;
const Vec2 = main.Vec2;
const vec2 = main.vec2;
const Camera = main.Camera;
const Direction = main.Direction;

tile: tiles.Tile,
position: Vec2(i32),

const Self = @This();

pub fn boundingBox(self: Self) Rect(i32) {
    return Rect(i32).fromPointWithDimensions(self.position, self.tile.width(), self.tile.height());
}

pub fn render(self: Self, camera: Camera) void {
    self.tile.render(camera.worldToScreen(self.position));
}

/// Note: No-op for tiles without demand.
pub fn renderDemand(self: Self, camera: Camera) void {
    switch (self.tile) {
        .city_block => self.tile.city_block.demand_satisfied.render(camera.worldToScreen(self.position).add(
            vec2(i32, self.tile.width() * 4 - 4, self.tile.height() * 4 - 4),
        )),
        else => {},
    }
}

pub fn canConnectRiver(self: Self, position: Vec2(i32), direction: Direction) bool {
    switch (self.tile) {
        .river => {
            if (self.tile.river.height_store == 0) {
                if (std.meta.eql(position, self.position) and direction == .east) return true;
                if (std.meta.eql(position, self.position.add(vec2(i32, self.tile.width() - 1, 0))) and direction == .west) return true;
            } else {
                if (std.meta.eql(position, self.position) and direction == .south) return true;
                if (std.meta.eql(position, self.position.add(vec2(i32, 0, self.tile.height() - 1))) and direction == .north) return true;
            }
            return false;
        },
        else => return false,
    }
}

const RiverConnection = struct { positon: Vec2(i32), direction: Direction };

pub fn riverConnections(self: Self) [2]RiverConnection {
    std.debug.assert(self.tile == .river);
    var river_connection: [2]RiverConnection = undefined;
    if (self.tile.river.height_store == 0) {
        river_connection[0] = .{
            .positon = self.position.add(vec2(i32, -1, 0)),
            .direction = .west,
        };
        river_connection[1] = .{
            .positon = self.position.add(vec2(i32, self.tile.width(), 0)),
            .direction = .east,
        };
    } else {
        river_connection[0] = .{
            .positon = self.position.add(vec2(i32, 0, -1)),
            .direction = .north,
        };
        river_connection[1] = .{
            .positon = self.position.add(vec2(i32, 0, self.tile.height())),
            .direction = .south,
        };
    }

    return river_connection;
}
