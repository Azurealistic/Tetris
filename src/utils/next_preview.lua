-- Draws the upcoming pieces to the right of the board. Not an ECS system: the
-- upcoming pieces aren't entities, they're just kinds waiting in the queue.
local shapes = require("src.utils.shapes")
local config = require("src.utils.config")
local colors = require("src.utils.colors")
local piece = require("src.entities.piece")

local CELL = config.CELL
local SLOT_W, SLOT_H = 4, 3 -- each preview slot is 4 x 3 cells

local next_preview = {}

function next_preview.draw()
	local x0 = config.BOARD_X + config.BOARD_W * CELL + 30
	local y0 = config.BOARD_Y

	love.graphics.setColor(1, 1, 1)
	love.graphics.print("NEXT", x0, y0)

	for i = 1, config.NEXT_COUNT do
		local k = piece.peek(i)
		local cells = shapes.cells(k, 1)

		-- bounding box of the shape, so it can be centred in its slot
		local min_x, max_x, min_y, max_y = math.huge, -math.huge, math.huge, -math.huge
		for _, c in ipairs(cells) do
			min_x, max_x = math.min(min_x, c[1]), math.max(max_x, c[1])
			min_y, max_y = math.min(min_y, c[2]), math.max(max_y, c[2])
		end
		-- Free space is (slot size - shape size); half of it goes on each side.
		local ox = (SLOT_W - (max_x - min_x + 1)) / 2
		local oy = (SLOT_H - (max_y - min_y + 1)) / 2

		local sy = y0 + 24 + (i - 1) * SLOT_H * CELL
		local rgb = colors[k]
		love.graphics.setColor(rgb[1], rgb[2], rgb[3])
		for _, c in ipairs(cells) do
			love.graphics.rectangle(
				"fill",
				x0 + (ox + c[1] - min_x) * CELL,
				sy + (oy + c[2] - min_y) * CELL,
				CELL - 1,
				CELL - 1
			)
		end
	end
end

return next_preview
