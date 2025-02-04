package mario

import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:os"
import rl "vendor:raylib"

// globals
scale: i32
assets_dir: string

find_assets_dir :: proc() -> string {
	home := os.get_env("HOME")
	path := strings.concatenate({home, "/.local/share/mario"})
	if os.is_dir(path) {
		return path
	}
	path = "/usr/share/mario"
	if os.is_dir(path) {
		return path
	}
	path = "assets"
	if os.is_dir(path) {
		return path
	}
	return ""
}

main :: proc() {
	if len(os.args) != 2 {
		fmt.printfln("Usage: %s SCALE", os.args[0])
		os.exit(1)
	}
	scale = i32(strconv.atoi(os.args[1]))
	if scale <= 0 {
		fmt.printfln("Invalid SCALE")
		os.exit(1)
	}
	assets_dir = find_assets_dir()
	if assets_dir == "" {
		fmt.printfln("Could not find assets directory")
		os.exit(1)
	}

	rl.InitWindow(256*scale, 240*scale, "Mario")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)
	game_init()
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground({92, 148, 252, 255})
		game_update()
		game_render()
		rl.EndDrawing()
	}
}
