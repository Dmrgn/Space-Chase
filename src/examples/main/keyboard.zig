const raylib = @import("../../raylib/raylib.zig");

const Player = @import("player.zig");
const Bullet = @import("bullet.zig");

pub fn handleKeyboard() !void {
    if (raylib.IsKeyDown(raylib.KeyboardKey.KEY_A))
        Player.player.vel.x = Player.player.vel.x - 1;
    if (raylib.IsKeyDown(raylib.KeyboardKey.KEY_W))
        Player.player.vel.y = Player.player.vel.y - 1;
    if (raylib.IsKeyDown(raylib.KeyboardKey.KEY_D))
        Player.player.vel.x = Player.player.vel.x + 1;
    if (raylib.IsKeyDown(raylib.KeyboardKey.KEY_S))
        Player.player.vel.y = Player.player.vel.y + 1;
    if (raylib.IsKeyDown(raylib.KeyboardKey.KEY_SPACE) and Bullet.untilFire == 0) {
        try Bullet.bullets.append(Bullet.Bullet.new());
        Bullet.untilFire = Bullet.fireRate;
    }
    if (Bullet.untilFire > 0) {
        Bullet.untilFire-=1;
    }
}