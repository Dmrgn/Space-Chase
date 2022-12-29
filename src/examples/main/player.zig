const raylib = @import("../../raylib/raylib.zig");
const Vector2 = raylib.Vector2;

const drag = 0.9;

const screenWidth = @import("main.zig").screenWidth;
const screenHeight = @import("main.zig").screenHeight;

pub const Player = struct {
    pos: Vector2,
    vel: Vector2,
    texSize: Vector2,
    animationFrame: f32 = 0,

    pub fn init(x: i32, y: i32) Player {
        return Player {
            .pos = Vector2 {
                .x = @intToFloat(f32, x),
                .y = @intToFloat(f32, y)
            },
            .vel = Vector2 {
                .x = 0,
                .y = 0
            },
            .texSize = Vector2 {
                .x = 64,
                .y = 64
            }
        };
    }

    pub fn update() void {
        player.pos = Vector2.clampY(Vector2.clampX(Vector2.add(player.pos, player.vel), 0, @intToFloat(f32, screenWidth)-player.texSize.x), 0, @intToFloat(f32, screenHeight)-player.texSize.y);
        player.vel = Vector2.scale(player.vel, drag);
        player.animationFrame+=0.2;
        player.animationFrame = @rem(player.animationFrame, 6);
    }

    pub fn draw() void {
        raylib.DrawTextureV(texFire[@floatToInt(u8, player.animationFrame)], player.pos.sub(Vector2 {.x=player.texSize.x, .y=0}), raylib.WHITE);
        raylib.DrawTextureV(texPlayer, player.pos, raylib.WHITE);
    }
};

pub var texPlayer: raylib.Texture2D = undefined;
pub var texFire: [6]raylib.Texture2D = undefined;

pub var player: Player = Player.init(100, screenHeight/2-32); 