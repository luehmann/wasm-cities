const Sprite = struct {
    width: usize,
    height: usize,
    buffer_index: usize,
};
pub const city_blocks_1x1 = [4]usize {
    0,
    8,
    16,
    24,
};
pub const city_blocks_1x1_draw_colors = 0x0040;
pub const city_blocks_2x1 = [5]usize {
    32,
    48,
    64,
    80,
    96,
};
pub const city_blocks_2x1_draw_colors = 0x0040;
pub const city_blocks_3x1 = [6]usize {
    112,
    136,
    160,
    184,
    208,
    232,
};
pub const city_blocks_3x1_draw_colors = 0x0040;
pub const city_blocks_4x1 = [7]usize {
    256,
    288,
    320,
    352,
    384,
    416,
    448,
};
pub const city_blocks_4x1_draw_colors = 0x0040;
pub const parks_3x2 = [3]usize {
    480,
    528,
    576,
};
pub const parks_3x2_draw_colors = 0x0030;
pub const parks_3x3 = [3]usize {
    624,
    696,
    768,
};
pub const parks_3x3_draw_colors = 0x0030;
pub const parks_4x3 = [3]usize {
    840,
    936,
    1032,
};
pub const parks_4x3_draw_colors = 0x0030;
pub const parks_4x4 = [3]usize {
    1128,
    1256,
    1384,
};
pub const parks_4x4_draw_colors = 0x0030;
pub const badge: Sprite = .{
    .width = 4,
    .height = 9,
    .buffer_index = 1512,
};
pub const corner: Sprite = .{
    .width = 8,
    .height = 8,
    .buffer_index = 1516,
};
pub const font: Sprite = .{
    .width = 184,
    .height = 5,
    .buffer_index = 1524,
};
pub const sprites: [*]const u8 = &sprite_buffer;
const sprite_buffer = [1639]u8 {
0x0, 0x0, 0x0, 0x0, 0x0, 0x7e, 0x7e, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7e, 0x7e, 0x7e, 0x0, 0x0, 0x0, 0x0, 0x7e, 0x7e, 0x7e, 0x66, 0x0, 0x0, 0x0, 0x0, 0x0, 0x76, 0x76, 0x76, 0x0, 0x0, 0x0, 0x0, 0x7e, 0x0, 0x7e, 0x7f, 0x7e, 0x7f, 0x7e, 0x7f, 0x7e, 0x7f, 0x7e, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x70, 0x0, 0x7f, 0xc0, 0x7f, 0xfe, 0x7f, 0xfe, 0x7f, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0xfe, 0x7f, 0xfe, 0x7f, 0xfe, 0x7f, 0xfe, 0x7f, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x78, 0xe, 0x78, 0xe, 0x7f, 0xee, 0x7f, 0xee, 0x7f, 0xee, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x70, 0x7e, 0x70, 0x7e, 0x7f, 0xfe, 0x7f, 0xfe, 0x7f, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7, 0x80, 0x7c, 0x7, 0xfe, 0x7c, 0x7, 0xfe, 0x7f, 0xf7, 0xfe, 0x7f, 0xf7, 0xfe, 0x7f, 0xf7, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x78, 0x0, 0x0, 0x7b, 0xf0, 0x0, 0x7b, 0xf0, 0x7e, 0x7b, 0xff, 0xfe, 0x7b, 0xff, 0xfe, 0x7b, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7e, 0x3, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7c, 0x0, 0x0, 0x7c, 0x7c, 0x1e, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7c, 0x1, 0xfe, 0x7c, 0x1, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0x87, 0xfc, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0xfe, 0x0, 0xf1, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0xc0, 0x30, 0x0, 0x1, 0xde, 0x30, 0x0, 0x7f, 0xde, 0x31, 0xfe, 0x7f, 0xde, 0xff, 0xfe, 0x7f, 0xde, 0xff, 0xfe, 0x7f, 0xde, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7e, 0x0, 0x3, 0xfe, 0x7e, 0x1f, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xc3, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0xe0, 0x0, 0x7, 0xf1, 0xe1, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1f, 0xe0, 0x1e, 0x0, 0x1f, 0xef, 0xfe, 0x7f, 0xff, 0xef, 0xfe, 0x7f, 0xff, 0xef, 0xfe, 0x7f, 0xe0, 0xef, 0xfe, 0x7f, 0xe0, 0xef, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0x1, 0xf0, 0xfe, 0x7f, 0xff, 0xf0, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xf, 0x0, 0x0, 0x1e, 0xf, 0x0, 0x78, 0x1f, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x3e, 0x7e, 0x3, 0xe0, 0x3e, 0x7f, 0xfb, 0xef, 0xfe, 0x7f, 0xfb, 0xef, 0xfe, 0x7f, 0xfb, 0xef, 0xfe, 0x7f, 0xfb, 0xe0, 0x7e, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xf8, 0xfe, 0x7f, 0xe0, 0x3e, 0x7f, 0xc0, 0x1e, 0x7f, 0xc0, 0xe, 0x7f, 0xc0, 0xe, 0x7f, 0xe0, 0x1e, 0x7f, 0xf0, 0x7e, 0x7f, 0xf8, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7e, 0x1f, 0xfe, 0x7c, 0xf, 0xfe, 0x78, 0xf, 0xfe, 0x7c, 0x1f, 0xfe, 0x7e, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xbe, 0x7f, 0xfe, 0x1e, 0x7f, 0xf8, 0x1e, 0x7f, 0xf0, 0xe, 0x7f, 0xf0, 0x1e, 0x7f, 0xe0, 0x1e, 0x7f, 0xc0, 0x1e, 0x7f, 0xe8, 0x3e, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xfc, 0x7e, 0x7f, 0xf8, 0x3e, 0x7f, 0xf0, 0x3e, 0x7f, 0xf0, 0x3e, 0x7f, 0xf0, 0x3e, 0x7f, 0xf0, 0x7e, 0x7f, 0xfb, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xc7, 0xfe, 0x7f, 0x83, 0xfe, 0x7f, 0x1, 0xfe, 0x7f, 0x11, 0xfe, 0x7e, 0x1, 0xfe, 0x7e, 0x3, 0xfe, 0x7f, 0x7, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xe0, 0x3e, 0x7f, 0x80, 0x1e, 0x7f, 0x0, 0x1e, 0x7e, 0x0, 0x1e, 0x7e, 0x0, 0x3e, 0x7c, 0x1, 0xfe, 0x7c, 0x7, 0xfe, 0x7c, 0x1f, 0xfe, 0x7c, 0x1f, 0xfe, 0x7c, 0x3f, 0xfe, 0x7e, 0x7f, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0x7e, 0x7f, 0xff, 0xfc, 0x3e, 0x7f, 0xff, 0xd8, 0x3e, 0x7f, 0xff, 0x80, 0x3e, 0x7f, 0xff, 0x80, 0x7e, 0x7f, 0xff, 0x0, 0xfe, 0x7f, 0xfc, 0x1, 0xfe, 0x7f, 0xf8, 0x1, 0xfe, 0x7f, 0xfc, 0xc3, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xf8, 0x7f, 0xfe, 0x7f, 0xf0, 0x1f, 0xfe, 0x7f, 0xf0, 0xf, 0xfe, 0x7f, 0xe3, 0x7, 0xfe, 0x7f, 0xc7, 0xc3, 0xfe, 0x7f, 0xc7, 0xc3, 0xfe, 0x7f, 0x81, 0x3, 0xfe, 0x7f, 0x80, 0x7, 0xfe, 0x7f, 0x80, 0x1f, 0xfe, 0x7f, 0xc0, 0x7f, 0xfe, 0x7f, 0xe3, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xfe, 0x7f, 0xfe, 0x7f, 0xf0, 0x3f, 0xfe, 0x7f, 0xe0, 0x3f, 0xfe, 0x7f, 0xc0, 0x7f, 0xfe, 0x7f, 0x80, 0x7f, 0xfe, 0x7f, 0x80, 0x7f, 0xfe, 0x7f, 0x0, 0x7f, 0xfe, 0x7f, 0x0, 0x7f, 0xfe, 0x7e, 0x0, 0xff, 0xfe, 0x7e, 0x3, 0xff, 0xfe, 0x7e, 0xf, 0xff, 0xfe, 0x7c, 0x3f, 0xff, 0xfe, 0x7e, 0x7f, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0x8f, 0xfe, 0x7f, 0xfe, 0x3, 0xfe, 0x7f, 0xfc, 0x1, 0xfe, 0x7f, 0xf0, 0x0, 0xfe, 0x7f, 0xe0, 0x1, 0xfe, 0x7f, 0xe0, 0x7, 0xfe, 0x7f, 0xc0, 0x1f, 0xfe, 0x7f, 0xc0, 0x7f, 0xfe, 0x7f, 0xc0, 0xff, 0xfe, 0x7f, 0xe3, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xfc, 0xf, 0xfe, 0x7f, 0xf8, 0x7, 0xfe, 0x7f, 0xf0, 0x3, 0xfe, 0x7f, 0xe0, 0x1, 0xfe, 0x7f, 0xe0, 0x1, 0xfe, 0x7f, 0xc0, 0x1, 0xfe, 0x7f, 0xc0, 0x1, 0xfe, 0x7f, 0xc0, 0x3, 0xfe, 0x7f, 0xc0, 0x7, 0xfe, 0x7f, 0xc0, 0x1f, 0xfe, 0x7f, 0xc0, 0xff, 0xfe, 0x7f, 0xeb, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xfe, 0xfe, 0x7f, 0xff, 0xfc, 0x7e, 0x7f, 0xff, 0xf8, 0x7e, 0x7f, 0xff, 0xf0, 0x7e, 0x7f, 0xff, 0xe0, 0x3e, 0x7f, 0xff, 0xc0, 0x3e, 0x7f, 0xff, 0x0, 0x3e, 0x7f, 0xfc, 0x0, 0x3e, 0x7f, 0xf8, 0x0, 0x3e, 0x7f, 0xf0, 0x0, 0x3e, 0x7f, 0xf8, 0x0, 0x7e, 0x7f, 0xfe, 0x0, 0x7e, 0x7f, 0xff, 0x0, 0x7e, 0x7f, 0xff, 0x80, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x7f, 0xff, 0xff, 0xfe, 0x0, 0x0, 0x0, 0x0, 0x8, 0xce, 0xfe, 0xc8, 0x0, 0xfe, 0x2, 0x1a, 0xa, 0x2, 0x2, 0x2, 0xa, 0xd7, 0x2, 0x30, 0x2, 0x1, 0xfb, 0xfb, 0xff, 0xfc, 0x2, 0x27, 0x1f, 0x7d, 0xff, 0xbc, 0xd9, 0x7f, 0xff, 0xbf, 0x6d, 0xb7, 0x80, 0xa, 0xfc, 0x42, 0x4a, 0xa4, 0x3, 0xa8, 0x9b, 0x21, 0xb5, 0x25, 0xd1, 0x16, 0xcb, 0x24, 0xa8, 0xd9, 0xed, 0xb6, 0xc5, 0x6d, 0xb4, 0x80, 0x8, 0x54, 0x80, 0x49, 0x71, 0x82, 0xab, 0xff, 0xf9, 0xfc, 0x8, 0xa, 0x1f, 0x4b, 0xb4, 0xe8, 0xe9, 0xed, 0xf7, 0x75, 0x6f, 0x5d, 0x0, 0x0, 0x77, 0x0, 0x4a, 0xa0, 0x6, 0xaa, 0x12, 0x69, 0xa5, 0x25, 0xd0, 0x16, 0xcb, 0x25, 0xaa, 0xd9, 0x6d, 0x9a, 0x95, 0x6f, 0xaa, 0x0, 0x8, 0x5c, 0x40, 0x30, 0x0, 0x14, 0xff, 0xf3, 0xf9, 0xfc, 0x22, 0x22, 0x17, 0x7d, 0xe7, 0xbf, 0xdf, 0x6f, 0x86, 0xe5, 0xf5, 0xab, 0x80, };
