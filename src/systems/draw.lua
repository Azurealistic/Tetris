-- Draws every entity that has col/row/kind/rot.
local ecs = require("libs.evolved")
local shapes = require("src.utils.shapes")
local config = require("src.utils.config")
local groups = require("src.utils.groups")

local col = require("src.fragments.col")
local row = require("src.fragments.row")
local kind = require("src.fragments.kind")
local rot = require("src.fragments.rot")

local COLORS = {
	I = { 0.00, 0.94, 0.94 },
	O = { 0.94, 0.94, 0.00 },
	T = { 0.63, 0.00, 0.94 },
	S = { 0.00, 0.94, 0.00 },
	Z = { 0.94, 0.00, 0.00 },
	J = { 0.00, 0.00, 0.94 },
	L = { 0.94, 0.63, 0.00 },
}

local CELL, BX, BY = config.CELL, config.BOARD_X, config.BOARD_Y

return ecs.builder()
	:name("systems.draw")
	:group(groups.draw)
	:include(col, row, kind, rot)
	:execute(function(chunk, entity_list, entity_count)
		local cols = chunk:components(col)
		local rows = chunk:components(row)
		local kinds = chunk:components(kind)
		local rots = chunk:components(rot)

		for i = 1, entity_count do
			local k = kinds[i]
			local c = COLORS[k]
			love.graphics.setColor(c[1], c[2], c[3])

			for _, cell in ipairs(shapes.cells(k, rots[i])) do
				-- (col + dx - 1): board column 1 sits at pixel offset 0.
				local x = BX + (cols[i] + cell[1] - 1) * CELL
				local y = BY + (rows[i] + cell[2] - 1) * CELL
				love.graphics.rectangle("fill", x, y, CELL - 1, CELL - 1)
			end
		end
	end)
	:build()
