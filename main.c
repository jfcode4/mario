#include <stdio.h>
#include <stdlib.h>

#include <game.h>

#include "config.h"
#include "level.h"
#include "player.h"

static void update() {
	player_update();
}

static void render() {
	game_render_clear(game_color_a(92, 148, 252, 255));

	level_render();
	player_render();

	game_render_present();

}

int main(int argc, char **argv) {
	int scale;
	if (argc != 2) {
		printf("Usage: %s SCALE\n", argv[0]);
		return 1;
	} else {
		scale = atoi(argv[1]);
		if (scale == 0) {
			return 1;
		}
	}
	if (!find_data_dir()) {
		fprintf(stderr, "Could not find assets directory\n");
		return -4;
	}
	if (!game_init(256, 240, "Mario", scale, 0))
		return -1;
	if (!player_init())
		return -2;
	if (!level_init())
		return -3;

	level_1_1();

	game_main_loop(60, NULL, update, render);

	game_free();
	return 0;
}
