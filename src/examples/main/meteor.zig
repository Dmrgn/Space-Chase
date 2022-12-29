const std = @import("std");
const raylib = @import("../../raylib/raylib.zig");
const Vector2 = raylib.Vector2;

const Main = @import("main.zig");
const Player = @import("player.zig");
const Bullet = @import("bullet.zig");

const screenWidth = @import("main.zig").screenWidth;
const screenHeight = @import("main.zig").screenHeight;

pub const startingSize: u32 = 32;

pub const Meteor = struct {
    pos: Vector2,
    vel: Vector2,
    size: u32,

    pub fn new(size: u32) Meteor {
        return Meteor {
            .pos = Vector2 {
                .x= screenWidth,
                .y= @intToFloat(f32, raylib.GetRandomValue(0, screenHeight)),
            },
            .vel = Vector2 {
                .x= @intToFloat(f32, raylib.GetRandomValue(-10, -20)),
                .y= @intToFloat(f32, raylib.GetRandomValue(-2, 2)),
            },
            .size = size,
        };
    }

    pub fn newHalf(parent: Meteor, inertia: Vector2) Meteor {
        return Meteor {
            .pos = parent.pos,
            .vel = parent.vel.add(inertia),
            .size = @maximum(@floatToInt(u32, @intToFloat(f32, parent.size)*0.5), 8),
        };
    }

    pub fn update(meteor: *Meteor, index: u32) !void {
        meteor.pos = Vector2.add(meteor.pos, meteor.vel);
        if (meteor.pos.x < 0) {
            meteors.items[index] = Meteor.new(meteor.size);
        }
        if (Player.player.pos.add(Vector2 {.x=Player.player.texSize.x/2, .y=Player.player.texSize.y/2}).distanceTo(meteor.pos) < @intToFloat(f32, meteor.size)+Player.player.texSize.x/2) {
            try Main.startGame();
        }
        for (Bullet.bullets.items) |bullet, i| {
            if (bullet.pos.add(Vector2 {.x=Bullet.bulletWidth/2, .y=Bullet.bulletHeight/2}).distanceTo(meteor.pos) < @intToFloat(f32, meteor.size)) {
                _ = Bullet.bullets.swapRemove(i);
                try meteors.append(Meteor.newHalf(meteor.*, Vector2 {.x = -1, .y = @intToFloat(f32, raylib.GetRandomValue(-30, -15))})); 
                try meteors.append(Meteor.newHalf(meteor.*, Vector2 {.x = -1, .y = @intToFloat(f32, raylib.GetRandomValue(15, 30))}));  
                _ = meteors.swapRemove(index);
                break;            
            }
        }
    }

    pub fn draw(meteor: Meteor) void {
        raylib.DrawCircle(meteor.pos.int().x, meteor.pos.int().y, @intToFloat(f32, meteor.size), raylib.WHITE);
    }
};

pub var meteors: std.ArrayList(Meteor) = undefined;