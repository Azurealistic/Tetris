local ecs = require("libs.evolved")
local shapes = require("src.utils.shapes")
local config = require("src.utils.config")
local groups = require("src.utils.groups")
local piece = require("src.entities.piece")
local input = require("src.utils.input")

require("src.systems.draw")
require("src.systems.gravity")
require("src.systems.input")

local game = {}

-- TEMPORARY: debug helpers.
local current, kind_index = nil, 1

function game:enter()
	kind_index = 1
	current = piece.spawn(shapes.kinds[kind_index])
end

function game:update(dt)
	ecs.process_with(groups.update, dt)
end

function game:draw()
	-- board outline
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

-- TEMPORARY: space = next kind, up = rotate clockwise.
-- Needs love.keypressed forwarded to the active state.
function game:keypressed(key)
	if key == "left" then
		input.push("left")
	elseif key == "right" then
		input.push("right")
	elseif key == "down" then
		input.push("down")
	elseif key == "up" then
		input.push("rotate_cw")
	elseif key == "z" then
		input.push("rotate_ccw")
	elseif key == "space" then
		ecs.destroy(current)
		kind_index = kind_index % #shapes.kinds + 1
		current = piece.spawn(shapes.kinds[kind_index])
	end
end

function game:leave() end

return game
