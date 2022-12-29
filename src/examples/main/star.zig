const std = @import("std");
const raylib = @import("../../raylib/raylib.zig");
const Vector2 = raylib.Vector2;
const Vector3 = raylib.Vector3;

const screenWidth = @import("main.zig").screenWidth;
const screenHeight = @import("main.zig").screenHeight;

pub const starSpeed: f32 = 6.0;
pub const starSize: f32 = 2.0; 

pub const Star = struct {
    // the z coordinate is the depth
    pos: Vector3,

    pub fn new() Star {
        return Star {
            .pos = Vector3 {
                .x = screenWidth,
                .y = @intToFloat(f32, raylib.GetRandomValue(0, screenHeight)),
                .z = @intToFloat(f32, raylib.GetRandomValue(1, 100))/100
            }
        };
    }

    pub fn update(star: *Star, index: u32) void {
        star.pos = Vector3.add(star.pos, Vector3 {.x = -starSpeed*star.pos.z, .y = 0, .z = 0});
        if (star.pos.x < 0) {
            stars.items[index] = Star.new();
        }
    }

    pub fn draw(star: Star) void {
        raylib.DrawCircle(@floatToInt(i32, star.pos.x), @floatToInt(i32, star.pos.y), starSize*star.pos.z, raylib.WHITE);
    }
};

pub var stars: std.ArrayList(Star) = undefined;