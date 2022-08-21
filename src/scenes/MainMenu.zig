const std = @import("std");
const main = @import("main");
const w4 = @import("wasm4");

const Input = main.Input;
const Camera = main.Camera;
const scenes = main.scenes;
const utils = main.utils;
const font = main.font;
const save = main.save;

camera: Camera,
time_elapsed: u64,

const Self = @This();

pub fn init() Self {
    return Self{
        .camera = Camera{},
        .time_elapsed = 0,
    };
}

pub fn update(self: *Self, input: *const Input) void {
    utils.renderWindow(30, 30, 100, 110);
    utils.renderBadge("WASM CITIES", 50, 35, 60);

    const standard_clicked = renderMode("STANDARD", save.save.highscore, 40, 45, input);
    const timed_clicked = renderMode("TIMED", save.save.highscore_timed, 40, 88, input);

    if (standard_clicked) {
        scenes.active_scene = scenes.Scene{ .game = scenes.Game.init(self.time_elapsed, false) };
    }
    if (timed_clicked) {
        scenes.active_scene = scenes.Scene{ .game = scenes.Game.init(self.time_elapsed, true) };
    }

    self.time_elapsed += 1;
}

fn renderMode(name: []const u8, highscore: u32, x: i32, y: i32, input: *const Input) bool {
    utils.renderWindow(x, y, 80, 42);
    w4.draw_colors.* = 0x40;
    font.renderTextAligned(name, x + 40, y + 5, .center);
    var table: utils.TableState = .{
        .width = 76,
        .x = x + 2,
        .y = y + 13,
        .alternating_flag = true,
    };
    utils.renderTableRow("HIGHSCORE", utils.fmt("{}", .{highscore}), &table);
    return utils.renderButton("PLAY", x + 20, y + 25, 40, input);
}
