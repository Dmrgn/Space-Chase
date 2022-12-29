# Space Chase

This is my submission to [Ludum Dare 51](https://ldjam.com/events/ludum-dare/51) with the theme "Every 10 seconds".

You can play the finished product here: [https://spacechase.netlify.app/](https://spacechase.netlify.app/)

Its based on one of the first coding projects I ever made, when I was 10 years old. [You can find the original here.](https://scratch.mit.edu/projects/115379236/)

## How to play

Control a red spaceship as you navigate through ever thickening asteroid fields (WASD). *Every 10 seconds* you will travel one kilometer further into the asteroid field (and the difficult will increase by 1 asteroid). 

As a last resort you can fire a laser at an incoming asteroid in an attempt to break it apart (SPACE). Be careful though! Shooting an asteroid will create even more debris.

## What even is Zig?

I created this game with [Zig](https://ziglang.org/) and [Raylib](https://www.raylib.com/) using emscripten to compile to web assembly. 

I had no experience working with any of these technologies before the jam and so I spent the overwhelming majority of my time getting anything to compile, and the last few hours actually making a game. This is exectly what I was expecting however, and I'm really happy that I managed to get it working in the end.

This project was created based on the [zig-raylib examples repo](https://github.com/ryupold/examples-raylib.zig). I had to do major tweaking to get it to compile. Several random Raylib source files were giving errors and connecting my emscripten sdk was really finicky. Overall, I was surprised with the quality of documentation available for such niche technologies.