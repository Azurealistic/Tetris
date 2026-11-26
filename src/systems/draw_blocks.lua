local ecs = require("libs.evolved")
local config = require("src.utils.config")
local colors = require("src.utils.colors")
local layout = require("src.utils.layout")
local groups = require("src.utils.groups")
local tile = require("src.utils.tile")

local col = require("src.fragments.col")
local row = require("src.fragments.row")
local kind = require("src.fragments.kind")
local settled = require("src.fragments.settled")

local CELL = config.CELL

return ecs.builder()
    :name("systems.draw_blocks")
    :group(groups.draw)
    :include(settled, col, row, kind)
    :execute(function(chunk, entity_list, entity_count)
        local BX, BY = layout.board_x, layout.board_y
        local cols = chunk:components(col)
        local rows = chunk:components(row)
        local kinds = chunk:components(kind)

        tile.begin()
        for i = 1, entity_count do
            tile.draw(
                BX + (cols[i] - 1) * CELL,
                BY + (rows[i] - 1) * CELL,
                colors[kinds[i]]
            )
        end
        tile.finish()
    end)
    :build()
