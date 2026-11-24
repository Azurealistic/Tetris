local shapes = require("src.utils.shapes")
local config = require("src.utils.config")
local colors = require("src.utils.colors")
local piece = require("src.entities.piece")

local CELL = config.CELL
local SLOT_W, SLOT_H = 4, 3 -- each preview slot is 4 x 3 cells
local PAD = 10 -- space between the border and the contents
local HEADER = 24 -- height of the "NEXT" label area
local RADIUS = 8 -- corner radius of the panel (0 = square corners)

local next_preview = {}

function next_preview.draw()
	local x0 = config.BOARD_X + config.BOARD_W * CELL + 30
	local y0 = config.BOARD_Y
	local panel_x = x0 - PAD
	local panel_y = y0 - PAD
	local panel_w = SLOT_W * CELL + 2 * PAD
	local panel_h = 2 * PAD + HEADER + config.NEXT_COUNT * SLOT_H * CELL

	love.graphics.setColor(0.08, 0.08, 0.10)
	love.graphics.rectangle("fill", panel_x, panel_y, panel_w, panel_h, RADIUS, RADIUS)

	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineWidth(2)
	love.graphics.rectangle("line", panel_x, panel_y, panel_w, panel_h, RADIUS, RADIUS)
	love.graphics.setLineWidth(1)

	love.graphics.printf("NEXT", x0, y0, SLOT_W * CELL, "center")

	for i = 1, config.NEXT_COUNT do
		local k = piece.peek(i)
		local cells = shapes.cells(k, 1)

		local min_x, max_x, min_y, max_y = math.huge, -math.huge, math.huge, -math.huge
		for _, c in ipairs(cells) do
			min_x, max_x = math.min(min_x, c[1]), math.max(max_x, c[1])
			min_y, max_y = math.min(min_y, c[2]), math.max(max_y, c[2])
		end
		local shape_w = max_x - min_x + 1
		local shape_h = max_y - min_y + 1

		local ox = math.floor((SLOT_W - shape_w) / 2)
		local oy = math.floor((SLOT_H - shape_h) / 2)

		local sy = y0 + HEADER + (i - 1) * SLOT_H * CELL
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
