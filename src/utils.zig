const std = @import("std");
const main = @import("main");
const w4 = @import("wasm4");

const Input = main.Input;
const font = main.font;
const Rect = main.Rect;
const vec2 = main.vec2;
const sprites = main.sprites;

pub fn randomWeighted(
    comptime T: type,
    comptime len: usize,
    comptime weighted_values: [len]struct { value: T, weight: usize },
    random: std.rand.Random,
) T {
    comptime var total_weight: usize = 0;
    comptime var thresholds: [len]usize = undefined;
    inline for (weighted_values) |weighted_value, i| {
        total_weight += weighted_value.weight;
        thresholds[i] = total_weight;
    }
    const random_int = random.uintLessThan(usize, total_weight);
    inline for (thresholds) |threshold, i| {
        if (random_int < threshold) return weighted_values[i].value;
    }
    unreachable;
}

pub fn fmt(comptime fmt_str: []const u8, args: anytype) []const u8 {
    return std.fmt.bufPrint(&main.buffer, fmt_str, args) catch unreachable;
}

const ButtonState = enum {
    default,
    hover,
    focus,
};

pub fn renderButton(label: []const u8, x: i32, y: i32, width: i32, input: *const Input) bool {
    const rect = Rect(i32).fromPointWithDimensions(vec2(i32, x, y), width - 1, 10);

    const correct_start_and_end_pos = input.mouse_left_down_positon.isWithin(rect) and input.mouse_position.isWithin(rect);
    const state: ButtonState = if (input.mouse_buttons.left and correct_start_and_end_pos)
        ButtonState.focus
    else if (input.mouse_position.isWithin(rect))
        ButtonState.hover
    else
        ButtonState.default;

    const origin_y: i32 = switch (state) {
        .default => y + 0,
        .hover => y + 1,
        .focus => y + 2,
    };
    w4.draw_colors.* = 0x41;
    w4.rect(x, origin_y, width, 9);

    w4.draw_colors.* = 0x40;
    font.renderTextAligned(label, x + @divFloor(width, 2), origin_y + 2, .center);

    w4.draw_colors.* = 0x4;
    w4.vline(x, y + 9, 2);
    w4.vline(x + width - 1, y + 9, 2);

    return input.mouse_buttons_released.left and correct_start_and_end_pos;
}

pub fn renderBadge(label: []const u8, x: i32, y: i32, width: i32) void {
    w4.draw_colors.* = 0x3;
    w4.blit(sprites.sprites + sprites.badge.buffer_index, x, y, 4, 9, w4.BLIT_1BPP);
    w4.blit(sprites.sprites + sprites.badge.buffer_index, x + width - 4, y, 4, 9, w4.BLIT_1BPP | w4.BLIT_FLIP_X);
    w4.rect(x + 4, y, width - 8, 9);
    w4.draw_colors.* = 0x10;
    font.renderTextAligned(label, x + @divFloor(width, 2), y + 2, .center);
}

pub fn renderWindow(x: i32, y: i32, width: i32, height: i32) void {
    w4.draw_colors.* = 0x1;
    w4.rect(x, y, width, height);

    w4.draw_colors.* = 0x41;
    w4.rect(x + 1, y + 1, width - 2, height - 2);

    w4.blit(sprites.sprites + sprites.corner.buffer_index, x, y, 8, 8, w4.BLIT_1BPP | w4.BLIT_FLIP_X);
    w4.blit(sprites.sprites + sprites.corner.buffer_index, x + width - 8, y, 8, 8, w4.BLIT_1BPP);
    w4.blit(sprites.sprites + sprites.corner.buffer_index, x + width - 8, y + height - 8, 8, 8, w4.BLIT_1BPP | w4.BLIT_FLIP_Y);
    w4.blit(sprites.sprites + sprites.corner.buffer_index, x, y + height - 8, 8, 8, w4.BLIT_1BPP | w4.BLIT_FLIP_X | w4.BLIT_FLIP_Y);
}

pub const TableState = struct {
    width: i32,
    x: i32,
    y: i32,
    alternating_flag: bool,
};

pub fn renderTableRow(
    col_1: []const u8,
    col_2: []const u8,
    table_state: *TableState,
) void {
    w4.draw_colors.* = if (table_state.alternating_flag) 0x4 else 0x1;
    w4.rect(table_state.x, table_state.y, table_state.width, 9);

    w4.draw_colors.* = if (table_state.alternating_flag) 0x10 else 0x40;
    font.renderTextAligned(col_1, table_state.x + 4, table_state.y + 2, .left);
    font.renderTextAligned(col_2, table_state.x + table_state.width - 3, table_state.y + 2, .right);
    table_state.alternating_flag = !table_state.alternating_flag;
    table_state.y += 9;
}

pub fn fmtTicks(ticks: u64) []const u8 {
    const total_seconds = ticks / 60;
    const minutes = total_seconds / 60;
    const seconds = total_seconds % 60;
    return fmt("{}:{:0>2}", .{ minutes, seconds });
}

test "fmtTicks" {
    try std.testing.expectEqualStrings("0:01", fmtTicks(69));
    try std.testing.expectEqualStrings("1:00", fmtTicks(60 * 60 + 59));
}
