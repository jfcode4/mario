package mario

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

player_get_collision :: proc() -> rl.Rectangle {
	p := &game.player
	area := game.sprite_types[p.sprite.type].texture_area
	return {
		p.sprite.pos.x,
		p.sprite.pos.y+1,
		area.width,
		area.height-2
	}
}

player_get_ground_collision :: proc() -> rl.Rectangle {
	p := &game.player
	area := game.sprite_types[p.sprite.type].texture_area
	return {p.sprite.pos.x, p.sprite.pos.y + area.height - 1, area.width, 1}
}

player_init :: proc() {
	p := &game.player
	p.sprite.pos = {40, 193}
	filename := fmt.ctprint(assets_dir, "/mario-luigi.png", sep="")
	texture := game_add_texture(rl.LoadTexture(filename))
	p.sprite.type = game_add_sprite_type({texture, {82, 34, 12, 16}})
	p.collision = player_get_collision()
	p.ground_collision = player_get_ground_collision()
}

player_update :: proc() {
	p := &game.player
	left := rl.IsKeyDown(.A)
	right := rl.IsKeyDown(.D)
	a := rl.IsKeyDown(.K)
	b := rl.IsKeyDown(.J)
	if p.velocity.x == 0 {
		if right {
			p.velocity.x += 0.018554688
		} else if left {
			p.velocity.x -= 0.018554688
		}
	}
	if b {
		// B is pressed: speed up faster
		if right {
			p.velocity.x += 0.0556640625
		}
		if left {
			p.velocity.x -= 0.0556640625
		}
		// Higher top speed
		p.velocity.x = clamp(p.velocity.x, -2.5, 2.5)
	} else {
		if right {
			p.velocity.x += 0.037109375
		}
		if left {
			p.velocity.x -= 0.037109375
		}
		// Lower top speed
		p.velocity.x = clamp(p.velocity.x, -1.5, 1.5)
	}
	// No key or both are pressed: slow down
	if left == right {
		if p.velocity.x > 0 {
			p.velocity.x -= 0.05078125
		} else {
			p.velocity.x += 0.05078125
		}
		if p.velocity.x > -0.0625 && p.velocity.x < 0.0625 {
			p.velocity.x = 0
		}
	}
	// A button
	if a {
		if game_check_collisions(player_get_ground_collision(), game.collisions[:]) != -1 && !p.is_jumping {
			p.velocity.y = -4.125
		}
		if p.velocity.y < 0.5 {
			p.velocity.y -= 0.3125
		}
		p.is_jumping = true
	} else {
		p.is_jumping = false
	}

	// Gravity
	p.velocity.y += 0.4375
	p.velocity.y = clamp(p.velocity.y, -4.125, 4.125)

	// Check collisions and update position
	p.velocity = game_move_with_collision(p.velocity, player_get_collision(), game.collisions[:])
	p.sprite.pos += p.velocity

	// Left edge
	if p.sprite.pos.x < 0 {
		p.sprite.pos.x = 0
		p.velocity.x = 0
	}

	// Losing
	if p.sprite.pos.y > 480 {
		p.sprite.pos = {40, 193}
		p.velocity = {0, 0}
	}
}

player_render :: proc() {
	game_render_sprite(game.player.sprite)
}
