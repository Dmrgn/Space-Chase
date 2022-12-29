const std = @import("std");
const Example = @import("../example.zig").Example;
const raylib = @import("../../raylib/raylib.zig");

const Player = @import("player.zig");
const Meteor = @import("meteor.zig");
const Star = @import("star.zig");
const Bullet = @import("bullet.zig");
const Keyboard = @import("keyboard.zig");
const DifficultyBar = @import("difficulty_bar.zig");

pub const example = Example{
    .initFn = init,
    .updateFn = update,
};
pub const screenWidth: i32 = 1600;
pub const screenHeight: i32 = 800;
const virtualScreenWidth: i32 = 1600;
const virtualScreenHeight: i32 = 800;
const virtualRatio = @intToFloat(f32, screenWidth) / @intToFloat(f32, virtualScreenWidth);
var origin = raylib.Vector2{ .x = 0, .y = 0 };
var target: raylib.RenderTexture2D = undefined;
var sourceRec: raylib.Rectangle = undefined;
var destRec = raylib.Rectangle{
    .x = -virtualRatio,
    .y = -virtualRatio,
    .width = @intToFloat(f32, screenWidth) + (virtualRatio * 2),
    .height = @intToFloat(f32, screenHeight) + (virtualRatio * 2),
};

pub var alloc: std.mem.Allocator = undefined;

pub fn startGame() !void {
    Meteor.meteors = std.ArrayList(Meteor.Meteor).init(alloc);
    try Meteor.meteors.append(Meteor.Meteor.new(Meteor.startingSize));

    Star.stars = std.ArrayList(Star.Star).init(alloc);
    var i: i32 = 0;
    while (i < 100) : (i += 1) {
        try Star.stars.append(Star.Star.new());
    }

    Bullet.bullets = std.ArrayList(Bullet.Bullet).init(alloc);

    DifficultyBar.difficulty = 0;
    DifficultyBar.untilIncrease = DifficultyBar.increaseWait;
}

fn init(allocator: std.mem.Allocator) !void {
    raylib.InitWindow(screenWidth, screenHeight, "Game");
    target = raylib.LoadRenderTexture(virtualScreenWidth, virtualScreenHeight);
    sourceRec = .{
        .x = 0,
        .y = 0,
        .width = @intToFloat(f32, target.texture.width),
        .height = @intToFloat(f32, -target.texture.height),
    };
    raylib.SetTargetFPS(60);

    // load textures
    Player.texPlayer = raylib.LoadTexture("assets/player.png");
    // load all fire textures
    comptime var i = 1;
    inline while (i <= 6) : (i+=1) {
        Player.texFire[i-1] = raylib.LoadTexture("assets/fire/fire"++([1]u8 {std.fmt.digitToChar(i, std.fmt.Case.upper)})++".png");
    }

    // assign the allocator
    alloc = allocator;

    try startGame();
}

fn update(_: f32) !void {

    Player.Player.update();
    for (Meteor.meteors.items) |_, i| {
        try Meteor.Meteor.update(&Meteor.meteors.items[i], i);
    }
    for (Star.stars.items) |_, i| {
        Star.Star.update(&Star.stars.items[i], i);
    }
    for (Bullet.bullets.items) |_, i| {
        Bullet.Bullet.update(&Bullet.bullets.items[i], i);
    }
    try DifficultyBar.update();

    {
        raylib.BeginTextureMode(target);
        defer raylib.EndTextureMode();
        raylib.ClearBackground(raylib.BLACK);

        for (Star.stars.items) |star| {
            Star.Star.draw(star);
        }
        for (Bullet.bullets.items) |bullet| {
            Bullet.Bullet.draw(bullet);
        }
        Player.Player.draw();
        for (Meteor.meteors.items) |meteor| {
            Meteor.Meteor.draw(meteor);
        }
    }

    {
        raylib.BeginDrawing();
        defer raylib.EndDrawing();

        raylib.ClearBackground(raylib.BLACK);
        raylib.DrawFPS(10, 10);

        raylib.DrawTexturePro(target.texture, sourceRec, destRec, origin, 0.0, raylib.WHITE);
        try DifficultyBar.draw();
    }

    try Keyboard.handleKeyboard();
}
