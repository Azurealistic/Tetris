-- Drop preview ("ghost"): shows where the controlled piece would land.
-- Drawn as vertical hatch lines in the piece's colour inside each landing cell,
-- plus an outline around the whole landing shape.
local ecs = require("libs.evolved")
local shapes = require("src.utils.shapes")
local config = require("src.utils.config")
local colors = require("src.utils.colors")
local groups = require("src.utils.groups")
local collision = require("src.utils.collision")
local outline = require("src.utils.outline")

local col = require("src.fragments.col")
local row = require("src.fragments.row")
local kind = require("src.fragments.kind")
local rot = require("src.fragments.rot")
local controlled = require("src.fragments.controlled")

local CELL, BX, BY = config.CELL, config.BOARD_X, config.BOARD_Y
local HATCH_ALPHA = 0.55
local HATCH_STEP = 6 -- pixels between vertical lines

return ecs.builder()
	:name("systems.ghost")
	:group(groups.draw)
	:include(controlled, col, row, kind, rot)
	:execute(function(chunk, entity_list, entity_count)
		local cols = chunk:components(col)
		local rows = chunk:components(row)
		local kinds = chunk:components(kind)
		local rots = chunk:components(rot)

		for i = 1, entity_count do
			local k, r, c = kinds[i], rots[i], cols[i]
			local landing = collision.drop_row(k, r, c, rows[i])

			-- Already resting: the piece itself covers the ghost, skip it.
			if landing > rows[i] then
				local rgb = colors[k]

				-- vertical lines, one set per landing cell
				love.graphics.setColor(rgb[1], rgb[2], rgb[3], HATCH_ALPHA)
				love.graphics.setLineWidth(1)

				for _, cell in ipairs(shapes.cells(k, r)) do
					local x = BX + (c + cell[1] - 1) * CELL
					local y = BY + (landing + cell[2] - 1) * CELL

					-- Restrict drawing to this cell
					love.graphics.setScissor(x, y, CELL, CELL)

					for ox = -CELL, CELL * 2, HATCH_STEP do
						love.graphics.line(x + ox, y + CELL, x + ox + CELL, y)
					end
				end

				-- Restore drawing area
				love.graphics.setScissor()

				-- outline of the whole shape
				love.graphics.setColor(rgb[1], rgb[2], rgb[3], 1)
				love.graphics.setLineWidth(2)
				for _, e in ipairs(outline.edges(k, r)) do
					love.graphics.line(
						BX + (c - 1 + e[1]) * CELL,
						BY + (landing - 1 + e[2]) * CELL,
						BX + (c - 1 + e[3]) * CELL,
						BY + (landing - 1 + e[4]) * CELL
					)
				end
				love.graphics.setLineWidth(1)
			end
		end
	end)
	:build()
