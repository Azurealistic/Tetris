local ecs = require("libs.evolved")
local config = require("src.utils.config")
local groups = require("src.utils.groups")
local input = require("src.utils.input")
local board = require("src.utils.board")
local piece = require("src.entities.piece")
local controlled = require("src.fragments.controlled")

-- Order matters: input -> gravity -> lock.
require("src.systems.draw") -- groups.draw
require("src.systems.draw_blocks") -- groups.draw
require("src.systems.input") -- groups.update (1st)
require("src.systems.gravity") -- groups.update (2nd)
require("src.systems.lock") -- groups.update (3rd)

local game = {}

local KEYMAP = {
	left = "left",
	right = "right",
	up = "rotate_cw",
	x = "rotate_cw",
	rctrl = "rotate_ccw",
	lctrl = "rotate_ccw",
	z = "rotate_ccw",
	space = "hard_drop",
}

local controlled_query = ecs.builder():include(controlled):build()

local function start()
	ecs.batch_destroy(controlled_query)
	board.clear()
	input.clear()
	piece.spawn(piece.random_kind())
end

function game:enter()
	start()
end

function game:update(dt)
	input.soft_drop = love.keyboard.isDown("down")

	ecs.process_with(groups.update, dt)

	if board.game_over then
		start()
	end
end

function game:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle(
		"line",
		config.BOARD_X,
		config.BOARD_Y,
		config.BOARD_W * config.CELL,
		config.BOARD_H * config.CELL
	)

	ecs.process(groups.draw)
end

function game:keypressed(key)
	local action = KEYMAP[key]
	if action then
		input.push(action)
	end
end

function game:leave() end

return game
