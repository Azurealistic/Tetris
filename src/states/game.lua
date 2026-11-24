local ecs = require("libs.evolved")
local config = require("src.utils.config")
local groups = require("src.utils.groups")
local input = require("src.utils.input")
local board = require("src.utils.board")
local autorepeat = require("src.utils.autorepeat")
local piece = require("src.entities.piece")
local next_preview = require("src.utils.next_preview")
local controlled = require("src.fragments.controlled")

-- Order matters: input -> gravity -> lock.
require("src.systems.draw_blocks") -- groups.draw (1st)
require("src.systems.ghost") -- groups.draw (2nd)
require("src.systems.draw") -- groups.draw (3rd)
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
	autorepeat.clear()
	piece.reset_randomizer()
	piece.spawn(piece.next_kind())
end

function game:enter()
	start()
end

function game:update(dt)
	input.soft_drop = love.keyboard.isDown("down")

	autorepeat.update(dt)

	ecs.process_with(groups.update, dt)

	if board.game_over then
		start()
	end
end

function game:draw()
	local x = config.BOARD_X
	local y = config.BOARD_Y
	local w = config.BOARD_W * config.CELL
	local h = config.BOARD_H * config.CELL

	love.graphics.setColor(0.025, 0.025, 0.030, 1)
	love.graphics.rectangle("fill", x, y, w, h, 8, 8)

	love.graphics.setColor(1, 1, 1, 0.045)
	love.graphics.setLineWidth(1)

	for col = 1, config.BOARD_W - 1 do
		local gx = x + col * config.CELL
		love.graphics.line(gx, y, gx, y + h)
	end

	for row = 1, config.BOARD_H - 1 do
		local gy = y + row * config.CELL
		love.graphics.line(x, gy, x + w, gy)
	end

	ecs.process(groups.draw)

	love.graphics.setColor(0.65, 0.65, 0.68, 0.9)
	love.graphics.setLineWidth(2)
	love.graphics.rectangle("line", x, y, w, h, 8, 8)

	love.graphics.setLineWidth(1)

	next_preview.draw()
end

function game:keypressed(key)
	local action = KEYMAP[key]
	if action then
		input.push(action)
		autorepeat.press(key)
	end
end

function game:leave() end

return game
