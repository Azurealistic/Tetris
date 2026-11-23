-- Draws settled blocks: one cell each.
local ecs = require("libs.evolved")
local config = require("src.utils.config")
local colors = require("src.utils.colors")
local groups = require("src.utils.groups")

local col = require("src.fragments.col")
local row = require("src.fragments.row")
local kind = require("src.fragments.kind")
local settled = require("src.fragments.settled")

local CELL, BX, BY = config.CELL, config.BOARD_X, config.BOARD_Y

return ecs.builder()
	:name("systems.draw_blocks")
	:group(groups.draw)
	:include(settled, col, row, kind)
	:execute(function(chunk, entity_list, entity_count)
		local cols = chunk:components(col)
		local rows = chunk:components(row)
		local kinds = chunk:components(kind)

		for i = 1, entity_count do
			local c = colors[kinds[i]]
			love.graphics.setColor(c[1], c[2], c[3])
			love.graphics.rectangle("fill", BX + (cols[i] - 1) * CELL, BY + (rows[i] - 1) * CELL, CELL - 1, CELL - 1)
		end
	end)
	:build()
