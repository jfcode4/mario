#include <stdio.h>

#include <game.h>

#include "config.h"

struct {
	Sprite sprite;
	Vector2 pos;
	Vector2 velocity;
	int player_collision;
	int ground_collision;
	int jumping;
} player;

static Rect player_collision_rect() {
	return rect(player.sprite.area.x,
	            player.sprite.area.y + 1,
	            player.sprite.area.w,
	            player.sprite.area.h - 2);
}

static Rect player_ground_rect() {
	return rect(player.sprite.area.x,
	            player.sprite.area.y + player.sprite.area.h - 1,
	            player.sprite.area.w,
	            1);

}

int player_init() {
	char buffer[1024];

	player.pos = vector2(40, 194);
	player.sprite.area = rect((int) player.pos.x, (int) player.pos.y, 12, 16);

	player.velocity = vector2(0, 0);

	sprintf(buffer, "%s%s", data_dir, "/mario/mario_luigi.png");
	if ((player.sprite.texture_id = game_add_texture(buffer)) < 0)
		return 0;
	player.sprite.texture_area = rect(82, 34, 12, 16);

	player.player_collision = game_collision_add(player_collision_rect());
	player.ground_collision = game_collision_add(player_ground_rect());

	player.jumping = 0;
	return 1;
}

void player_update() {
	Rect old;
	int collided_id;
	KeyState state = game_get_key_state();

	if (player.velocity.x == 0) {
		if (state.right) {
			player.velocity.x += 0.018554688;
		} else if (state.left) {
			player.velocity.x -= 0.018554688;
		}
	}
	if (state.b) {
		/* B is pressed: speed up faster */
		if (state.right) {
			player.velocity.x += 0.0556640625;
		}
		if (state.left) {
			player.velocity.x -= 0.0556640625;
		}
		/* Higher top speed */
		if (player.velocity.x > 2.5) {
			player.velocity.x = 2.5;
		}
		if (player.velocity.x < -2.5) {
			player.velocity.x = -2.5;
		}
	} else {
		/* B is not pressed: slower speedup */
		if (state.right) {
			player.velocity.x += .037109375;
		}
		if (state.left) {
			player.velocity.x -= .037109375;
		}
		/* Lower top speed */
		if (player.velocity.x > 1.5) {
			player.velocity.x = 1.5;
		}
		if (player.velocity.x < -1.5) {
			player.velocity.x = -1.5;
		}
	}
	/* No key or both are pressed: slow down */
	if (state.left == state.right) {
		if (player.velocity.x > 0) {
			player.velocity.x -= 0.05078125;
		} else {
			player.velocity.x += 0.05078125;
		}

		if (player.velocity.x < 0.0625 && player.velocity.x > -0.0625) {
			player.velocity.x = 0;
		}
	}
	/* A button */
	if (state.a) {
		game_collision_set(player.ground_collision, player_ground_rect());
		if (game_collision_check(player.ground_collision) >= 0 && !player.jumping) {
			player.velocity.y = -4.125;
		}
		if (player.velocity.y < 0.5) {
			player.velocity.y -= 0.3125;
		}
		player.jumping = 1;
	} else {
		player.jumping = 0;
	}

	/* Gravity */
	player.velocity.y += 0.4375;
	if (player.velocity.y > 4.125)
		player.velocity.y = 4.125;


	old = player_collision_rect();

	/* Update position */
	player.pos.x += player.velocity.x;
	player.pos.y += player.velocity.y;


	player.sprite.area.x = (int) player.pos.x;
	player.sprite.area.y = (int) player.pos.y;

	/* Collision */
	game_collision_set(player.player_collision, player_collision_rect());
	game_collision_set(player.ground_collision, player_ground_rect());
	while ((collided_id = game_collision_check(player.player_collision)) >= 0) {
		Vector2 collision_direction = game_collision_get_direction(player.player_collision, collided_id, old);
		player.pos.x += collision_direction.x;
		player.pos.y += collision_direction.y;
		player.sprite.area.x += collision_direction.x;
		player.sprite.area.y += collision_direction.y;
		if (collision_direction.x) {
			player.velocity.x = 0;
		} else if (collision_direction.y) {
			player.velocity.y = 0;
		} else {
			fprintf(stderr, "Impossible direction!\n");
		}

		game_collision_set(player.player_collision, player_collision_rect());
		game_collision_set(player.ground_collision, player_ground_rect());

	}

	/* Left edge */
	if (player.sprite.area.x < 0) {
		player.sprite.area.x = 0;
		player.pos.x = 0;
		player.velocity.x = 0;
	}

	if (player.sprite.area.x < 112) {
		game_camera_set(point(0, 0));
	} else {
		game_camera_set(point(player.sprite.area.x - 112, 0));
	}

	/* Losing */
	if (player.sprite.area.y > 480) {
		player.pos = vector2(40, 194);
		player.sprite.area.x = (int) player.pos.x;
		player.sprite.area.y = (int) player.pos.y;
		player.velocity = vector2(0, 0);
	}

}

void player_render() {
	game_render_sprite(player.sprite);
}
