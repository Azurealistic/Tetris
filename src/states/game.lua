local ecs = require("libs.evolved")
local shapes = require("src.utils.shapes")
local config = require("src.utils.config")
local groups = require("src.utils.groups")
local piece = require("src.entities.piece")
local rot = require("src.fragments.rot")

require("src.systems.draw") -- registers the draw system into groups.draw

local game = {}

-- TEMPORARY: debug helpers so you can eyeball every kind/rotation.
local current, kind_index = nil, 1

function game:enter()
	kind_index = 1
	current = piece.spawn(shapes.kinds[kind_index])
end

function game:update(dt)
	ecs.process(groups.update)
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
	if key == "space" then
		ecs.destroy(current)
		kind_index = kind_index % #shapes.kinds + 1
		current = piece.spawn(shapes.kinds[kind_index])
	elseif key == "up" then
		ecs.set(current, rot, shapes.rotate_cw(ecs.get(current, rot)))
	end
end

function game:leave() end

return game
