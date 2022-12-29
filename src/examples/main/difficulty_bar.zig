const std = @import("std");
const raylib = @import("../../raylib/raylib.zig");
const Vector2 = raylib.Vector2;

const Meteor = @import("meteor.zig");

const screenWidth = @import("main.zig").screenWidth;
const screenHeight = @import("main.zig").screenHeight;

pub const increaseWait: i32 = 600;

pub fn update() !void {
    untilIncrease -= 1;
    if (untilIncrease <= 0) {
        difficulty+=1;
        try Meteor.meteors.append(Meteor.Meteor.new(Meteor.startingSize));
        untilIncrease = increaseWait;
    }
}

pub fn draw() !void {
    raylib.DrawRectangle(screenWidth/3, screenHeight/40, screenWidth/3, screenHeight/20, raylib.WHITE);
    raylib.DrawRectangle(screenWidth/3+10, screenHeight/40+10, screenWidth/3-20, screenHeight/20-20, raylib.BLACK);
    raylib.DrawRectangle(screenWidth/3+10, screenHeight/40+10, @floatToInt(i32, @intToFloat(f32, (screenWidth/3-20))*(@intToFloat(f32, untilIncrease)/@intToFloat(f32, increaseWait))), screenHeight/20-20, raylib.RED);
    var buf: [64]u8 = undefined;
    raylib.DrawText(try std.fmt.bufPrintZ(&buf, "Distance Traveled: {d}km", .{difficulty}), screenWidth/20, screenHeight/40+8, 30, raylib.RED);
}

pub var difficulty: i32 = 0;
pub var untilIncrease: i32 = increaseWait;