const std = @import("std");
const main = @import("main");
const w4 = @import("wasm4");

const Vec2 = main.Vec2;
const vec2 = main.vec2;

mouse_position: Vec2(i32),
buttons: w4.Gamepad,
buttons_pressed: w4.Gamepad,
buttons_released: w4.Gamepad,
mouse_buttons: w4.MouseButtons,
mouse_buttons_pressed: w4.MouseButtons,
mouse_buttons_released: w4.MouseButtons,
mouse_left_down_positon: Vec2(i32),

previous_mouse_position: Vec2(i32),
previous_buttons: w4.Gamepad,
previous_mouse_buttons: w4.MouseButtons,

const Self = @This();

pub fn init() Self {
    var self: Self = std.mem.zeroes(Self);
    self.endFrame();
    return self;
}

pub fn startFrame(self: *Self) void {
    self.mouse_position = vec2(i32, w4.mouse_x.*, w4.mouse_y.*);

    self.buttons = w4.gamepad1.*;
    const buttons_diff = @bitCast(u8, self.buttons) ^ @bitCast(u8, self.previous_buttons);
    self.buttons_pressed = @bitCast(w4.Gamepad, buttons_diff & @bitCast(u8, self.buttons));
    self.buttons_released = @bitCast(w4.Gamepad, buttons_diff & @bitCast(u8, self.previous_buttons));

    self.mouse_buttons = w4.mouse_buttons.*;
    const mouse_buttons_diff = @bitCast(u8, self.mouse_buttons) ^ @bitCast(u8, self.previous_mouse_buttons);
    self.mouse_buttons_pressed = @bitCast(w4.MouseButtons, mouse_buttons_diff & @bitCast(u8, self.mouse_buttons));
    self.mouse_buttons_released = @bitCast(w4.MouseButtons, mouse_buttons_diff & @bitCast(u8, self.previous_mouse_buttons));
    if (self.mouse_buttons_pressed.left) {
        self.mouse_left_down_positon = self.mouse_position;
    }
}

pub fn endFrame(self: *Self) void {
    self.previous_buttons = w4.gamepad1.*;
    self.previous_mouse_buttons = w4.mouse_buttons.*;
    self.previous_mouse_position = vec2(i32, w4.mouse_x.*, w4.mouse_y.*);
}
