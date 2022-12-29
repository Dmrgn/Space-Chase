const std = @import("std");
const raylib = @import("../../raylib/raylib.zig");
const Vector2 = raylib.Vector2;

const screenWidth = @import("main.zig").screenWidth;
const screenHeight = @import("main.zig").screenHeight;

const Player = @import("player.zig");

const bulletSpeed: f32 = 20;
pub const bulletWidth: i32 = screenWidth/25;
pub const bulletHeight: i32 = screenWidth/200;
pub const fireRate: u32 = 30;

pub const Bullet = struct {
    pos: Vector2,
    vel: Vector2,

    pub fn new() Bullet {
        return Bullet {
            .pos = Vector2 {
                .x = Player.player.pos.x + Player.player.texSize.x,
                .y = Player.player.pos.y + Player.player.texSize.y/2 - @intToFloat(f32, bulletHeight/2),
            },
            .vel = Vector2 {
                .x = Player.player.vel.x + bulletSpeed,
                .y = Player.player.vel.y,
            }
        };
    }

    pub fn update(bullet: *Bullet, index: u32) void {
        bullet.pos = Vector2.add(bullet.pos, bullet.vel);
        if (bullet.pos.x > screenWidth) {
            _ = bullets.swapRemove(index);
        }
    }

    pub fn draw(bullet: Bullet) void {
        raylib.DrawRectangle(bullet.pos.int().x, bullet.pos.int().y, bulletWidth, bulletHeight, raylib.BLUE);
    }
};

pub var bullets: std.ArrayList(Bullet) = undefined;
pub var untilFire: u32 = 0;