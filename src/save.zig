const std = @import("std");
const main = @import("main");
const w4 = @import("wasm4");

pub var save: Save = undefined;

pub const Save = extern struct {
    identifier: u8,
    version: u8,
    highscore: u32,
    highscore_timed: u32,

    pub fn isValid(self: *Save) bool {
        return self.identifier == 'T' and self.version == 1;
    }

    pub fn init(self: *Save) void {
        self.* = .{
            .identifier = 'T',
            .version = 1,
            .highscore = 0,
            .highscore_timed = 0,
        };
    }

    pub fn read(self: *Save) void {
        const bytes = std.mem.asBytes(self);
        _ = w4.diskr(bytes, bytes.len);
    }

    pub fn write(self: *Save) void {
        const bytes = std.mem.asBytes(self);
        _ = w4.diskw(bytes, bytes.len);
    }
};
