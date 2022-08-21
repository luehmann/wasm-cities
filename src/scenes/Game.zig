const std = @import("std");
const main = @import("main");
const w4 = @import("wasm4");

const Camera = main.Camera;
const Input = main.Input;
const List = main.List;
const Node = main.Node;
const Rect = main.Rect;
const tiles = main.tiles;
const vec2 = main.vec2;
const Vec2 = main.Vec2;
const font = main.font;
const utils = main.utils;
const Demand = main.Demand;
const scenes = main.scenes;
const sprites = main.sprites;
const save = main.save;

const max_node_count = 256;
const max_side_length = 4;

const max_demand = 15;

default_prng: std.rand.DefaultPrng,
tile_type_prng: std.rand.DefaultPrng,
camera: Camera,
nodes: List(Node, max_node_count),
bounding_box: Rect(i32),
cursor_node: Node,
is_cursor_legal: bool,
touching_nodes: List(*Node, max_side_length * 4),
on_screen_nodes: List(*Node, 21 * 21),
score: u32,
previous_highscore: u32,
hud_shown: bool,
hud_y: i32,
dialog_x: i32,
green_demand: i32,
water_demand: i32,
phase: Phase,
time_elapsed: u64,
game_over_time: u64,
timed: bool,
timer: u64,

const Self = @This();

const Phase = enum {
    transition_in,
    playing,
    game_over,
    transition_out,
};

pub fn init(seed: u64, timed: bool) Self {
    var self: Self = undefined;
    self.default_prng = std.rand.DefaultPrng.init(seed);
    self.tile_type_prng = std.rand.DefaultPrng.init(self.default_prng.random().int(u64));
    self.camera = Camera{};
    self.nodes = .{};
    self.nodes.append(Node{
        .position = vec2(i32, 0, 0),
        .tile = tiles.Tile.random(&self.default_prng, &self.tile_type_prng),
    });
    self.bounding_box = self.nodes.itemsMut()[0].boundingBox();
    self.cursor_node.tile = tiles.Tile.random(&self.default_prng, &self.tile_type_prng);
    self.camera.pos = self.nodes.itemsMut()[0].position.scale(8).subtract(vec2(i32, 80 - self.cursor_node.tile.width() * 4, 80 - self.cursor_node.tile.height() * 4));
    self.touching_nodes = .{};
    self.on_screen_nodes = .{};
    self.score = 0;
    self.previous_highscore = if (self.timed) save.save.highscore_timed else save.save.highscore;
    self.hud_shown = true;
    self.hud_y = -11;
    self.dialog_x = -100;
    if (self.nodes.items()[0].tile == .city_block) {
        self.water_demand = 1;
        self.green_demand = 1;
    } else {
        self.water_demand = 0;
        self.green_demand = 0;
    }
    self.phase = .transition_in;
    self.time_elapsed = 0;
    self.timed = timed;
    self.timer = 5 * 60;
    return self;
}

pub fn update(self: *Self, input: *const Input) void {
    switch (self.phase) {
        .transition_in => {
            self.phase = .playing;
            self.updatePlaying(input);
        },
        .playing => {
            self.updatePlaying(input);
        },
        .game_over => {
            self.updateGameOver(input);
        },
        .transition_out => {},
    }
    self.time_elapsed += 1;
}
fn updatePlaying(self: *Self, input: *const Input) void {
    if (input.mouse_buttons.right) {
        self.camera.pos = self.camera.pos.add(
            input.previous_mouse_position.subtract(input.mouse_position),
        );
        self.camera.pos = self.camera.pos.clamp(
            vec2(
                i32,
                self.bounding_box.min.x * 8 - w4.canvas_size + 32,
                self.bounding_box.min.y * 8 - w4.canvas_size + 32,
            ),
            vec2(
                i32,
                self.bounding_box.max.x * 8 - 32,
                self.bounding_box.max.y * 8 - 32,
            ),
        );
    }
    self.cursor_node.position = self.camera.screenToWorld(input.mouse_position.subtract(
        vec2(i32, self.cursor_node.tile.width() * 4 - 4, self.cursor_node.tile.height() * 4 - 4),
    ));
    self.calculateTouchingNodes();

    self.is_cursor_legal = self.isLegal();

    if (self.is_cursor_legal and input.mouse_buttons_pressed.left) {
        var needs_reward: bool = true;
        if (self.fillsHole()) {
            self.score += 10;
            needs_reward = false;
        }
        const water_connections = self.waterConnections();
        if (water_connections > 0) {
            self.score += water_connections * 5;
            needs_reward = false;
        }
        if (needs_reward) {
            self.score += 1;
        }
        if (self.timed) {
            if (self.score > save.save.highscore_timed) {
                save.save.highscore_timed = self.score;
                save.save.write();
            }
        } else {
            if (self.score > save.save.highscore) {
                save.save.highscore = self.score;
                save.save.write();
            }
        }
        for (self.touching_nodes.items()) |touching_node| {
            if (self.cursor_node.tile == .city_block) {
                self.cursor_node.tile.city_block.demand_satisfied = self.cursor_node.tile.city_block.demand_satisfied.add(touching_node.tile.supplyingDemand());
            }
            if (touching_node.tile == .city_block) {
                const previous_demand = touching_node.tile.city_block.demand_satisfied;
                touching_node.tile.city_block.demand_satisfied = touching_node.tile.city_block.demand_satisfied.add(self.cursor_node.tile.supplyingDemand());
                if (!previous_demand.green and touching_node.tile.city_block.demand_satisfied.green) {
                    self.green_demand -= 1;
                }
                if (!previous_demand.water and touching_node.tile.city_block.demand_satisfied.water) {
                    self.water_demand -= 1;
                }
            }
        }
        if (self.cursor_node.tile == .city_block) {
            if (!self.cursor_node.tile.city_block.demand_satisfied.green) {
                self.green_demand += 1;
            }
            if (!self.cursor_node.tile.city_block.demand_satisfied.water) {
                self.water_demand += 1;
            }
        }
        self.nodes.append(self.cursor_node);
        self.calculateBoundingBox(self.cursor_node);
        self.cursor_node.tile = tiles.Tile.random(&self.default_prng, &self.tile_type_prng);
        self.calculateTouchingNodes();
        self.is_cursor_legal = false;

        if (self.water_demand == max_demand or self.green_demand == max_demand) {
            self.phase = .game_over;
            self.game_over_time = self.time_elapsed;
            self.updateGameOver(input);
            return;
        }
        self.timer = 3 * 60;
    }
    self.calculateOnScreenNodes();

    self.renderBuildings();
    self.renderCursor(input);
    const demand_delta = self.renderDemandIndicators();

    self.renderHud(demand_delta);
    if (self.timer == 0) {
        self.phase = .game_over;
        self.game_over_time = self.time_elapsed;
        self.updateGameOver(input);
        return;
    }
    if (self.timed) self.timer -= 1;
}

fn fillsHole(self: *const Self) bool {
    var x: i32 = 0;
    while (x < self.cursor_node.tile.width()) : (x += 1) {
        if (!self.isFilled(self.cursor_node.position.add(vec2(i32, x, -1)))) return false;
        if (!self.isFilled(self.cursor_node.position.add(vec2(i32, x, self.cursor_node.tile.height())))) return false;
    }
    var y: i32 = 0;
    while (y < self.cursor_node.tile.height()) : (y += 1) {
        if (!self.isFilled(self.cursor_node.position.add(vec2(i32, -1, y)))) return false;
        if (!self.isFilled(self.cursor_node.position.add(vec2(i32, self.cursor_node.tile.width(), y)))) return false;
    }
    return true;
}

fn isFilled(self: *const Self, pos: Vec2(i32)) bool {
    for (self.touching_nodes.items()) |node| {
        if (pos.isWithin(node.boundingBox())) return true;
    }
    return false;
}

fn waterConnections(self: *const Self) u32 {
    if (self.cursor_node.tile != .river) return 0;
    var count: u32 = 0;
    for (self.cursor_node.riverConnections()) |connection| {
        for (self.touching_nodes.items()) |node| {
            if (node.canConnectRiver(connection.positon, connection.direction)) {
                count += 1;
            }
        }
    }
    return count;
}

const DemandDelta = struct { delta_water: i32 = 0, delta_green: i32 = 0 };

fn updateGameOver(self: *Self, input: *const Input) void {
    self.calculateOnScreenNodes();

    self.renderBuildings();

    self.renderHud(DemandDelta{});
    self.renderGameOverDialog(input);
}

fn renderGameOverDialog(self: *Self, input: *const Input) void {
    const new_highscore = self.score > self.previous_highscore;
    const width = 92;
    const height: i32 = if (new_highscore) 89 else 78;

    const avrg_ticks_per_tile = self.game_over_time / self.nodes.len;

    const dest_x = (w4.canvas_size - width) / 2;
    if (self.dialog_x < dest_x) {
        self.dialog_x += 20;
        self.dialog_x = std.math.min(self.dialog_x, dest_x);
    } else {
        self.dialog_x = dest_x;
    }
    const dialog_origin = vec2(i32, self.dialog_x, 40);
    utils.renderWindow(dialog_origin.x, dialog_origin.y, width, height);

    w4.draw_colors.* = 0x40;
    font.renderTextAligned("GAME OVER!", dialog_origin.x + width / 2, dialog_origin.y + 5, .center);

    if (new_highscore) utils.renderBadge("NEW HIGHSCORE", dialog_origin.x + 6, dialog_origin.y + 13, width - 12);

    var table_state: utils.TableState = .{
        .width = width - 4,
        .x = dialog_origin.x + 2,
        .y = dialog_origin.y + height - 65,
        .alternating_flag = true,
    };
    utils.renderTableRow("SCORE", utils.fmt("{}", .{self.score}), &table_state);
    utils.renderTableRow(
        if (new_highscore) "OLD HIGHSCORE" else "HIGHSCORE",
        utils.fmt("{}", .{self.previous_highscore}),
        &table_state,
    );
    utils.renderTableRow("TILES PLACED", utils.fmt("{}", .{self.nodes.len}), &table_state);
    utils.renderTableRow("TIME PLAYED", utils.fmtTicks(self.game_over_time), &table_state);
    utils.renderTableRow("AVRG. PER TILE", utils.fmtTicks(avrg_ticks_per_tile), &table_state);

    const menu_clicked = utils.renderButton("MENU", dialog_origin.x + 6, dialog_origin.y + height - 17, 30, input);
    const new_game_clicked = utils.renderButton("NEW GAME", dialog_origin.x + 38, dialog_origin.y + height - 17, 48, input);

    if (menu_clicked) {
        scenes.active_scene = scenes.Scene{ .main_menu = scenes.MainMenu.init() };
    }

    if (new_game_clicked) {
        scenes.active_scene = scenes.Scene{ .game = Self.init(self.default_prng.random().int(u64), self.timed) };
    }
}

fn renderBuildings(self: *const Self) void {
    for (self.on_screen_nodes.items()) |node| {
        node.render(self.camera);
    }
}

fn renderCursor(self: *const Self, input: *const Input) void {
    self.cursor_node.tile.render(if (self.is_cursor_legal)
        self.camera.worldToScreen(self.cursor_node.position)
    else
        input.mouse_position.subtract(
            vec2(i32, self.cursor_node.tile.width() * 4, self.cursor_node.tile.height() * 4),
        ));
}

fn renderDemandIndicators(self: *const Self) DemandDelta {
    var delta_green: i32 = 0;
    var delta_water: i32 = 0;
    if (self.is_cursor_legal) for (self.touching_nodes.items()) |node| {
        if (node.tile != .city_block) continue;
        const pos = self.camera.worldToScreen(node.position).add(vec2(i32, node.tile.width() * 4 - 4, node.tile.height() * 4 - 4));
        const demand = node.tile.city_block.demand_satisfied.getNew(self.cursor_node.tile.supplyingDemand());
        if (demand.green) {
            delta_green -= 1;
        }
        if (demand.water) {
            delta_water -= 1;
        }
        demand.render(pos);
    };

    if (self.is_cursor_legal and self.cursor_node.tile == .city_block) {
        const pos = self.camera.worldToScreen(self.cursor_node.position).add(vec2(i32, self.cursor_node.tile.width() * 4 - 4, self.cursor_node.tile.height() * 4 - 4));
        var demand = Demand{};
        for (self.touching_nodes.items()) |touching_node| {
            demand = demand.add(touching_node.tile.supplyingDemand());
        }
        if (!demand.green) {
            delta_green += 1;
        }
        if (!demand.water) {
            delta_water += 1;
        }
        demand.render(pos);
    }

    return .{
        .delta_green = delta_green,
        .delta_water = delta_water,
    };
}

fn renderHud(self: *Self, demand_delta: DemandDelta) void {
    if (self.hud_shown) {
        if (self.hud_y < 0) {
            self.hud_y += 1;
        }
    } else {
        if (self.hud_y > -12) {
            self.hud_y -= 1;
        } else {
            return;
        }
    }
    const hud_origin = vec2(i32, 0, self.hud_y);

    w4.draw_colors.* = 0x1;
    w4.rect(hud_origin.x, hud_origin.y, w4.canvas_size, 11);

    w4.draw_colors.* = 0x4;
    w4.hline(hud_origin.x, hud_origin.y + 9, w4.canvas_size);

    renderProgress(hud_origin.x + 2, hud_origin.y + 2, self.water_demand + demand_delta.delta_water, max_demand, 0x2, 0x4);
    renderProgress(hud_origin.x + 2, hud_origin.y + 5, self.green_demand + demand_delta.delta_green, max_demand, 0x3, 0x4);

    w4.draw_colors.* = 0x40;
    font.renderTextAligned(utils.fmt("{}", .{self.score}), hud_origin.x + w4.canvas_size - 1, hud_origin.y + 2, .right);
    if (self.timed) font.renderTextAligned(utils.fmtTicks(self.timer + 59), hud_origin.x + w4.canvas_size / 2, hud_origin.y + 2, .center);
}

fn renderProgress(x: i32, y: i32, current: i32, max: i32, filled_color: u16, default_color: u16) void {
    var i: i32 = 0;
    while (i < max) : (i += 1) {
        w4.draw_colors.* = if (i + 1 <= current) filled_color else default_color;
        w4.rect(x + i * 3, y, 2, 2);
    }
}

fn calculateBoundingBox(self: *Self, new_node: Node) void {
    const node_box = new_node.boundingBox();
    self.bounding_box.min.x = std.math.min(self.bounding_box.min.x, node_box.min.x);
    self.bounding_box.min.y = std.math.min(self.bounding_box.min.y, node_box.min.y);
    self.bounding_box.max.x = std.math.max(self.bounding_box.max.x, node_box.max.x);
    self.bounding_box.max.y = std.math.max(self.bounding_box.max.y, node_box.max.y);
}

fn calculateOnScreenNodes(self: *Self) void {
    self.on_screen_nodes.reset();
    const screen_rect = self.camera.getScreenRect();
    for (self.nodes.itemsMut()) |*node| {
        if (node.boundingBox().intersects(screen_rect)) {
            self.on_screen_nodes.append(node);
        }
    }
}

fn calculateTouchingNodes(self: *Self) void {
    self.touching_nodes.reset();
    for (self.nodes.itemsMut()) |*node| {
        const bounding_box = node.boundingBox();
        const horizontal_box = Rect(i32).fromPointWithDimensions(
            self.cursor_node.position.subtract(vec2(i32, 1, 0)),
            self.cursor_node.tile.width() + 2,
            self.cursor_node.tile.height(),
        );
        const vertical_box = Rect(i32).fromPointWithDimensions(
            self.cursor_node.position.subtract(vec2(i32, 0, 1)),
            self.cursor_node.tile.width(),
            self.cursor_node.tile.height() + 2,
        );
        if (horizontal_box.intersects(bounding_box) or vertical_box.intersects(bounding_box)) {
            self.touching_nodes.append(node);
        }
    }
}

fn isLegal(self: *const Self) bool {
    for (self.nodes.items()) |node| {
        if (node.boundingBox().intersects(self.cursor_node.boundingBox())) return false;
    }
    return self.touching_nodes.len > 0;
}
