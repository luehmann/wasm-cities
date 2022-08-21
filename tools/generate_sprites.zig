const std = @import("std");
const zigimg = @import("zigimg");

const beige = 0xF7F4EDFF;
const blue = 0xA3C0F4FF;
const green = 0xB3D8B8FF;
const grey = 0xABB0B4FF;

const palette = [4]u32{
    beige,
    blue,
    green,
    grey,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!gpa.deinit());
    var allocator = gpa.allocator();

    var texture_converter = try Self.init(allocator);
    defer texture_converter.deinit();

    try texture_converter.start();

    try texture_converter.addDirAsArray("assets/tiles/city_blocks/1x1", "city_blocks_1x1", 8, 8);
    try texture_converter.addDirAsArray("assets/tiles/city_blocks/2x1", "city_blocks_2x1", 16, 8);
    try texture_converter.addDirAsArray("assets/tiles/city_blocks/3x1", "city_blocks_3x1", 24, 8);
    try texture_converter.addDirAsArray("assets/tiles/city_blocks/4x1", "city_blocks_4x1", 32, 8);
    try texture_converter.addDirAsArray("assets/tiles/parks/3x2", "parks_3x2", 24, 16);
    try texture_converter.addDirAsArray("assets/tiles/parks/3x3", "parks_3x3", 24, 24);
    try texture_converter.addDirAsArray("assets/tiles/parks/4x3", "parks_4x3", 32, 24);
    try texture_converter.addDirAsArray("assets/tiles/parks/4x4", "parks_4x4", 32, 32);
    try texture_converter.addImage("assets/badge.png", "badge");
    try texture_converter.addImage("assets/corner.png", "corner");
    try texture_converter.addImage("assets/font.png", "font");

    try texture_converter.end();
}

const Sprite = struct {
    width: usize,
    height: usize,
    buffer_index: usize,
    draw_colors: [4]usize,
};

const Self = @This();

allocator: std.mem.Allocator,
texture_buffer: std.ArrayList(u8),
file: std.fs.File,

fn init(allocator: std.mem.Allocator) !Self {
    return Self{
        .allocator = allocator,
        .texture_buffer = std.ArrayList(u8).init(allocator),
        .file = try std.fs.cwd().createFile("src/sprites.zig", .{}),
    };
}

fn deinit(self: *Self) void {
    self.texture_buffer.deinit();
    self.file.close();
}

fn convertImage(self: *Self, image: zigimg.Image) !Sprite {
    var colors = std.AutoArrayHashMap(u32, usize).init(self.allocator);
    defer colors.deinit();
    const pixels = std.mem.bytesAsSlice(u32, std.mem.sliceAsBytes(image.pixels.rgba32));
    std.debug.assert(pixels.len == image.width * image.height);
    // std.debug.assert(pixels.len % 8 == 0);
    for (pixels) |pixel| {
        if (pixel == 0) {
            try colors.put(pixel, 0);
        } else {
            for (palette) |color, i| {
                if (pixel == std.mem.nativeToBig(u32, color)) {
                    try colors.put(pixel, i + 1);
                    break;
                }
            } else return error.IllegalColor;
        }
    }

    var bit1_buffer = std.packed_int_array.PackedIntArrayEndian(u1, .Big, 160 * 160).initAllTo(0);

    const result_bytes = switch (colors.unmanaged.entries.len) {
        1 => return error.NoTextureNeeded,
        2 => blk: {
            for (pixels) |pixel, i| {
                bit1_buffer.set(i, @intCast(u1, colors.getIndex(pixel).?));
            }
            break :blk bit1_buffer.bytes[0..(pixels.len / 8)];
        },
        3...4 => std.debug.todo("2bit"),
        else => return error.TooManyColors,
    };
    std.debug.assert(result_bytes.len == pixels.len / 8);
    const buffer_index = self.texture_buffer.items.len;
    try self.texture_buffer.appendSlice(result_bytes);
    return Sprite{
        .width = image.width,
        .height = image.height,
        .buffer_index = buffer_index,
        .draw_colors = [4]usize{
            if (colors.unmanaged.entries.len >= 4) colors.unmanaged.entries.get(3).value else 0,
            if (colors.unmanaged.entries.len >= 3) colors.unmanaged.entries.get(2).value else 0,
            if (colors.unmanaged.entries.len >= 2) colors.unmanaged.entries.get(1).value else 0,
            if (colors.unmanaged.entries.len >= 1) colors.unmanaged.entries.get(0).value else 0,
        },
    };
}

fn start(self: *Self) !void {
    try self.file.writeAll(
        \\const Sprite = struct {
        \\    width: usize,
        \\    height: usize,
        \\    buffer_index: usize,
        \\};
        \\
    );
}

fn end(self: *Self) !void {
    try self.file.writeAll("pub const sprites: [*]const u8 = &sprite_buffer;\n");
    try self.file.writer().print("const sprite_buffer = [{}]u8 {{\n", .{self.texture_buffer.items.len});
    for (self.texture_buffer.items) |byte| {
        try self.file.writer().print("0x{x}, ", .{byte});
    }
    try self.file.writeAll("};\n");
}

fn addDirAsArray(self: *Self, path: []const u8, name: []const u8, width: usize, height: usize) !void {
    var buffer_indices = std.ArrayList(usize).init(self.allocator);
    defer buffer_indices.deinit();

    var draw_colors: [4]usize = undefined;

    var i: usize = 0;
    var path_buffer = try self.allocator.alloc(u8, path.len + 100);
    defer self.allocator.free(path_buffer);
    while (true) : (i += 1) {
        var file = std.fs.cwd().openFile(try std.fmt.bufPrint(path_buffer, "{s}/{}.png", .{ path, i }), .{}) catch break;
        defer file.close();
        var image = try zigimg.Image.fromFile(self.allocator, &file);
        defer image.deinit();
        const texture = try self.convertImage(image);
        std.debug.assert(texture.width == width);
        std.debug.assert(texture.height == height);
        try buffer_indices.append(texture.buffer_index);
        draw_colors = texture.draw_colors;
    }

    try self.file.writer().print("pub const {s} = [{}]usize {{\n", .{ name, buffer_indices.items.len });
    for (buffer_indices.items) |buffer_index| {
        try self.file.writer().print("    {},\n", .{buffer_index});
    }
    try self.file.writeAll("};\n");
    try self.file.writer().print("pub const {s}_draw_colors = 0x{}{}{}{};\n", .{
        name,
        draw_colors[0],
        draw_colors[1],
        draw_colors[2],
        draw_colors[3],
    });
}

fn addImage(self: *Self, path: []const u8, name: []const u8) !void {
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    var image = try zigimg.Image.fromFile(self.allocator, &file);
    defer image.deinit();
    const texture = try self.convertImage(image);
    try self.file.writer().print("pub const {s}: Sprite = .{{\n", .{name});
    try self.file.writer().print("    .width = {},\n", .{texture.width});
    try self.file.writer().print("    .height = {},\n", .{texture.height});
    try self.file.writer().print("    .buffer_index = {},\n", .{texture.buffer_index});
    try self.file.writeAll("};\n");
}
