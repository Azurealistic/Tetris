-- Default settings for game.
GAME_WIDTH = 600
GAME_HEIGHT = 700
SCALE_FACTOR = 1

function love.conf(t)
	t.window.title = "Tetris"
	t.window.width = GAME_WIDTH * SCALE_FACTOR
	t.window.height = GAME_HEIGHT * SCALE_FACTOR
	t.window.resizable = false
	t.window.vsync = false
	t.window.msaa = 0

	-- Enable modules
	t.modules.audio = true
	t.modules.event = true
	t.modules.graphics = true
	t.modules.image = true
	t.modules.joystick = false -- Disabled because not supported.
	t.modules.keyboard = true
	t.modules.math = true
	t.modules.mouse = true
	t.modules.physics = true
	t.modules.sound = true
	t.modules.system = true
	t.modules.timer = true
	t.modules.touch = false -- Disabled since game does not use touch input.
	t.modules.video = false -- Disabled since game does not use video playback.
end
