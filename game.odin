package mario

import "core:fmt"
import "core:strings"
import "core:math"
import rl "vendor:raylib"

Sprite :: struct {
	pos: rl.Vector2,
	type: int
}
SpriteType :: struct {
	texture: int,
	texture_area: rl.Rectangle
}

game : struct {
	player: struct {
		sprite: Sprite,
		velocity: rl.Vector2,
		is_jumping: bool,
		collision: rl.Rectangle,
		ground_collision: rl.Rectangle,
	},
	level: struct {
		sprites: [400]Sprite,
		sprites_len: int,
		ground, question, brick, gpipe, gtail: int
	},
	textures: [2]rl.Texture,
	textures_len: int,
	sprite_types: [20]SpriteType,
	sprite_types_len: int,
	collisions: [dynamic]rl.Rectangle,
	camera: rl.Vector2
}

game_init :: proc() {
	player_init()
	level_init()
	level_1_1()
}

game_update :: proc() {
	player_update()
	if game.player.sprite.pos.x < 112 {
		game.camera.x = 0
	} else {
		game.camera.x = game.player.sprite.pos.x - 112
	}
}

game_render :: proc() {
	level_render()
	player_render()
}

game_add_collision :: proc(r: rl.Rectangle) -> int {
	append(&game.collisions, r)
	return len(game.collisions)-1
}

game_check_collisions :: proc(box: rl.Rectangle, collisions: []rl.Rectangle) -> int {
	for coll, i in collisions {
		if rl.CheckCollisionRecs(box, coll) {
			return i
		}
	}
	return -1
}

game_move_with_collision :: proc(vel: rl.Vector2, box: rl.Rectangle, collisions: []rl.Rectangle) -> rl.Vector2 {
	new_vel := vel
	new_box := box
	// Update position and check collisions
	// Collisions X
	new_box.x += vel.x
	for {
		collider := game_check_collisions(new_box, collisions)
		if collider == -1 do break
		coll := collisions[collider]
		coll_rec := rl.GetCollisionRec(new_box, coll)
		if vel.x > 0 {
			new_box.x -= coll_rec.width
			new_vel.x -= coll_rec.width
		} else {
			new_box.x += coll_rec.width
			new_vel.x += coll_rec.width
		}
	}
	// Collisions Y
	new_box.y += vel.y
	for {
		collider := game_check_collisions(new_box, collisions)
		if collider == -1 do break
		coll := collisions[collider]
		coll_rec := rl.GetCollisionRec(new_box, coll)
		if vel.y > 0 {
			new_box.y -= coll_rec.height
			new_vel.y -= coll_rec.height
		} else {
			new_box.y += coll_rec.height
			new_vel.y += coll_rec.height
		}
	}
	return new_vel
}

// returns normal of the side of r2 where r1 collided
game_get_collision_normal :: proc(v: rl.Vector2, r1, r2: rl.Rectangle) -> rl.Vector2 {
	if r1.x > r2.x && r1.x + r1.width < r2.x + r2.width {
		// between left and right
		if r1.y < r2.y do return {0, -1}
		else do return {0, 1}
	}
	else if r1.y > r2.y && r1.y + r1.height < r2.y + r2.height {
		// between top and bottom
		if r1.x < r2.x do return {-1, 0}
		else do return {1, 0}
	}
	//if v.x == 0 do return 
	col_rec := rl.GetCollisionRec(r1, r2)
	cross1 := v.x*col_rec.y - v.y*col_rec.x
	cross2 := -v.x*col_rec.y - v.y*col_rec.x
	if r1.x < r2.x {
		assert(r1.x + r1.width > r2.x)
		if r1.y < r2.y {
			// top left
			return {0, -1} if col_rec.width > col_rec.height else {-1, 0}
		}
		else {
			// bottom left
			return {0, 1} if col_rec.width > col_rec.height else {-1, 0}
		}
	}
	else {
		assert(r1.x < r2.x + r2.width)
		if r1.y < r2.y {
			// top right
			return {0, -1} if col_rec.width > col_rec.height else {1, 0}
		}
		else {
			// bottom right
			return {0, 1} if col_rec.width > col_rec.height else {1, 0}
		}
	}
	panic("unreachable")
}

game_add_texture :: proc(texture: rl.Texture) -> int {
	game.textures[game.textures_len] = texture
	game.textures_len += 1
	return game.textures_len - 1
}

game_add_sprite_type :: proc(type: SpriteType) -> int {
	game.sprite_types[game.sprite_types_len] = type
	game.sprite_types_len += 1
	return game.sprite_types_len - 1
}

game_render_sprite :: proc(s: Sprite) {
	scale := f32(scale)
	type := game.sprite_types[s.type]
	area := type.texture_area
	rl.DrawTexturePro(
		game.textures[type.texture],
		type.texture_area,
		{
			scale*math.floor(s.pos.x) - scale*math.trunc(game.camera.x),
			scale*math.floor(s.pos.y) - scale*math.trunc(game.camera.y),
			scale*area.width,
			scale*area.height
		},
		{0,0}, 0, rl.WHITE)

}
