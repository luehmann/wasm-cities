const std = @import("std");
const main = @import("main");

const Input = main.Input;

pub const MainMenu = @import("scenes/MainMenu.zig");
pub const Game = @import("scenes/Game.zig");

pub var active_scene: Scene = undefined;

pub const Scene = union(enum) {
    main_menu: MainMenu,
    game: Game,

    pub fn update(self: *Scene, input: *const Input) void {
        switch (self.*) {
            .main_menu => self.main_menu.update(input),
            .game => self.game.update(input),
        }
    }
};
