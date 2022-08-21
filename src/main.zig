const std = @import("std");
const builtin = @import("builtin");
const w4 = @import("wasm4.zig");
const vec = @import("vec.zig");

pub const Camera = @import("Camera.zig");
pub const Demand = @import("demand.zig").Demand;
pub const font = @import("font.zig");
pub const Input = @import("Input.zig");
pub const List = @import("list.zig").List;
pub const Node = @import("node.zig");
pub const Rect = @import("rect.zig").Rect;
pub const scenes = @import("scenes.zig");
pub const sprites = @import("sprites.zig");
pub const tiles = @import("tiles.zig");
pub const utils = @import("utils.zig");
pub const save = @import("save.zig");
pub const Direction = @import("direction.zig").Direction;

pub const vec2 = vec.vec2;
pub const Vec2 = vec.Vec2;
pub const Save = save.Save;

pub var buffer: [1024]u8 = undefined;

pub const allow_todo_in_release = true;

const colors = struct {
    const beige = 0xF7F4ED;
    const blue = 0xA3C0F4;
    const green = 0xB3D8B8;
    const grey = 0xABB0B4;
};

var input: Input = undefined;

export fn start() void {
    if (builtin.is_test) return;
    w4.palette.* = [4]u32{
        colors.beige,
        colors.blue,
        colors.green,
        colors.grey,
    };
    input = Input.init();
    save.save.read();
    if (!save.save.isValid()) {
        save.save.init();
        save.save.write();
    }
    scenes.active_scene = scenes.Scene{ .main_menu = scenes.MainMenu.init() };
}

export fn update() void {
    if (builtin.is_test) return;
    input.startFrame();
    defer input.endFrame();

    scenes.active_scene.update(&input);
}

pub fn panic(msg: []const u8, stack_trace: ?*std.builtin.StackTrace) noreturn {
    _ = stack_trace;
    if (builtin.mode == .Debug) {
        w4.trace(msg);
    }
    unreachable;
}

test {
    _ = std.testing.refAllDecls(@This());
}
