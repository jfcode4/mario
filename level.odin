package mario

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

level_init :: proc() {
	l := &game.level
	filename := fmt.ctprint(assets_dir, "/tileset.png", sep="")
	texture := game_add_texture(rl.LoadTexture(filename))
	l.ground   = game_add_sprite_type({texture, {0,   0, 16, 16}}) // Ground block
	l.question = game_add_sprite_type({texture, {384, 0, 16, 16}}) // Question block
	l.brick    = game_add_sprite_type({texture, {16,  0, 16, 16}}) // Brick block
	l.gpipe    = game_add_sprite_type({texture, {0, 128, 32, 16}}) // Green pipe block
	l.gtail    = game_add_sprite_type({texture, {0, 144, 32, 16}}) // Green pipe tail
	l.sprites_len = 0
}

level_add_sprite :: proc(s: Sprite) {
	l := &game.level
	l.sprites[l.sprites_len] = s
	l.sprites_len += 1
}

level_1_1 :: proc() {
	l := &game.level
	// Ground
	for i := 0; i < 69; i+=1 {
		level_add_sprite({{f32(i*16), 208}, l.ground})
		level_add_sprite({{f32(i*16), 224}, l.ground})
	}
	for i := 71; i < 86; i+=1 {
		level_add_sprite({{f32(i*16), 208}, l.ground})
		level_add_sprite({{f32(i*16), 224}, l.ground})
	}
	for i := 89; i < 164; i+=1 {
		level_add_sprite({{f32(i*16), 208}, l.ground})
		level_add_sprite({{f32(i*16), 224}, l.ground})
	}
	// Ground collision
	game_add_collision({0, 208, 69*16, 32})
	game_add_collision({71*16, 208, 15*16, 32})
	game_add_collision({89*16, 208, 75*16, 32})

	// First question block
	level_add_sprite({{16*16, 9*16}, l.question})
	game_add_collision({16*16, 9*16, 16, 16})

	// 5 block series
	level_add_sprite({{20*16, 9*16}, l.brick})
	level_add_sprite({{21*16, 9*16}, l.question})
	level_add_sprite({{22*16, 9*16}, l.brick})
	level_add_sprite({{23*16, 9*16}, l.question})
	level_add_sprite({{24*16, 9*16}, l.brick})
	game_add_collision({20*16, 9*16, 5*16, 16})

	// Question on top
	level_add_sprite({{22*16, 5*16}, l.question})
	game_add_collision({22*16, 5*16, 16, 16})

	// Green pipe 1
	level_add_sprite({{28*16, 11*16}, l.gpipe})
	level_add_sprite({{28*16, 12*16}, l.gtail})
	game_add_collision({28*16, 11*16, 32, 32})

	// Green pipe 2
	level_add_sprite({{38*16, 10*16}, l.gpipe})
	level_add_sprite({{38*16, 11*16}, l.gtail})
	level_add_sprite({{38*16, 12*16}, l.gtail})
	game_add_collision({38*16, 10*16, 32, 48})

	// Green pipe 3
	level_add_sprite({{46*16,  9*16}, l.gpipe})
	level_add_sprite({{46*16, 10*16}, l.gtail})
	level_add_sprite({{46*16, 11*16}, l.gtail})
	level_add_sprite({{46*16, 12*16}, l.gtail})
	game_add_collision({46*16, 9*16, 32, 64})

	// Green pipe 4
	level_add_sprite({{57*16,  9*16}, l.gpipe})
	level_add_sprite({{57*16, 10*16}, l.gtail})
	level_add_sprite({{57*16, 11*16}, l.gtail})
	level_add_sprite({{57*16, 12*16}, l.gtail})
	game_add_collision({57*16, 9*16, 32, 64})

	// Brick - question - brick
	level_add_sprite({{77*16,  9*16}, l.brick})
	level_add_sprite({{78*16,  9*16}, l.question})
	level_add_sprite({{79*16,  9*16}, l.brick})
	game_add_collision({77*16, 9*16, 3*16, 16})

	for i := 80; i < 88; i+=1 {
		level_add_sprite({{f32(i*16), 5*16}, l.brick})
	}
	game_add_collision({80*16, 5*16, 8*16, 16})
}

level_render :: proc() {
	l := &game.level
	for i := 0; i < l.sprites_len; i+=1 {
		game_render_sprite(l.sprites[i])
	}
}
