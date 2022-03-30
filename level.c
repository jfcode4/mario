#include <stdio.h>

#include <game.h>
#include <vec.h>

#include "config.h"

struct {
	game_Sprite *sprites;
	int tileset_texture_id;
	int *collisions;
	game_Rect textures[10];
} level;

int level_init() {
	char buffer[1024];

	level.sprites = vec(game_Sprite);
	level.collisions = vec(int);

	sprintf(buffer, "%s%s", data_dir, "/tileset.png");
	if ((level.tileset_texture_id = game_add_texture(buffer)) < 0) {
		return 0;
	}
	level.textures[1] = (game_Rect){  0,   0, 16, 16}; /* Ground block */
	level.textures[2] = (game_Rect){384,   0, 16, 16}; /* Question block */
	level.textures[3] = (game_Rect){ 16,   0, 16, 16}; /* Brick block */
	level.textures[4] = (game_Rect){  0, 128, 32, 16}; /* Green pipe head */
	level.textures[5] = (game_Rect){  0, 144, 32, 16}; /* Green pipe tail */

	return 1;
}

void level_free() {
	vec_free(level.sprites);
	vec_free(level.collisions);
}

static void level_add_sprite(game_Rect a, int type) {
	game_Sprite sprite;
	sprite.area = a;
	sprite.texture_id = level.tileset_texture_id;
	sprite.texture_area = level.textures[type];
	vec_push(level.sprites, &sprite);
}

static void level_add_collision(game_Rect a) {
	int collision = game_collision_add(a);
	/*vec_push(level.collisions, &collision);*/
}

static void level_add(game_Rect a, int type) {
	level_add_sprite(a, type);
	level_add_collision(a);
}

void level_1_1() {
	int i;
	/* Ground */
	for (i = 0; i < 69; i++) {
		level_add_sprite((game_Rect){i*16, 208, 16, 16}, 1);
		level_add_sprite((game_Rect){i*16, 224, 16, 16}, 1);
	}
	for (i = 71; i < 86; i++) {
		level_add_sprite((game_Rect){i*16, 208, 16, 16}, 1);
		level_add_sprite((game_Rect){i*16, 224, 16, 16}, 1);
	}
	for (i = 89; i < 164; i++) {
		level_add_sprite((game_Rect){i*16, 208, 16, 16}, 1);
		level_add_sprite((game_Rect){i*16, 224, 16, 16}, 1);
	}

	/* Ground collision */
	level_add_collision((game_Rect){0, 208, 69*16, 32});
	level_add_collision((game_Rect){71*16, 208, 15*16, 32});
	level_add_collision((game_Rect){89*16, 208, 75*16, 32});

	/* First question block */
	level_add((game_Rect){16*16, 9*16, 16, 16}, 2);

	/* 5 block series: brick - question - brick - question - brick */
	level_add_sprite((game_Rect){20*16, 9*16, 16, 16}, 3);
	level_add_sprite((game_Rect){21*16, 9*16, 16, 16}, 2);
	level_add_sprite((game_Rect){22*16, 9*16, 16, 16}, 3);
	level_add_sprite((game_Rect){23*16, 9*16, 16, 16}, 2);
	level_add_sprite((game_Rect){24*16, 9*16, 16, 16}, 3);
	level_add_collision((game_Rect){20*16, 9*16, 5*16, 16});

	/* Question on top */
	level_add((game_Rect){22*16, 5*16, 16, 16}, 2);

	/* Green pipe 1 */
	level_add_sprite((game_Rect){28*16, 11*16, 32, 16}, 4);
	level_add_sprite((game_Rect){28*16, 12*16, 32, 16}, 5);
	level_add_collision((game_Rect){28*16, 11*16, 32, 32});

	/* Green pipe 2 */
	level_add_sprite((game_Rect){38*16, 10*16, 32, 16}, 4);
	level_add_sprite((game_Rect){38*16, 11*16, 32, 16}, 5);
	level_add_sprite((game_Rect){38*16, 12*16, 32, 16}, 5);
	level_add_collision((game_Rect){38*16, 10*16, 32, 48});

	/* Green pipe 3 */
	level_add_sprite((game_Rect){46*16,  9*16, 32, 16}, 4);
	level_add_sprite((game_Rect){46*16, 10*16, 32, 16}, 5);
	level_add_sprite((game_Rect){46*16, 11*16, 32, 16}, 5);
	level_add_sprite((game_Rect){46*16, 12*16, 32, 16}, 5);
	level_add_collision((game_Rect){46*16, 9*16, 32, 64});

	/* Green pipe 4 */
	level_add_sprite((game_Rect){57*16,  9*16, 32, 16}, 4);
	level_add_sprite((game_Rect){57*16, 10*16, 32, 16}, 5);
	level_add_sprite((game_Rect){57*16, 11*16, 32, 16}, 5);
	level_add_sprite((game_Rect){57*16, 12*16, 32, 16}, 5);
	level_add_collision((game_Rect){57*16, 9*16, 32, 64});

	/* brick - question - brick */
	level_add_sprite((game_Rect){77*16, 9*16, 16, 16}, 3);
	level_add_sprite((game_Rect){78*16, 9*16, 16, 16}, 2);
	level_add_sprite((game_Rect){79*16, 9*16, 16, 16}, 3);
	level_add_collision((game_Rect){77*16, 9*16, 3*16, 16});

	for (i = 80; i < 88; i++) {
		level_add_sprite((game_Rect){i*16, 5*16, 16, 16}, 3);
	}
	level_add_collision((game_Rect){80*16, 5*16, 8*16, 16});
}

void level_render() {
	size_t i;
	for (i = 0; i < vec_size(level.sprites); i++) {
		game_render_sprite(level.sprites[i]);
	}
}
