local ecs = require("libs.evolved")
local shapes = require("src.utils.shapes")
local config = require("src.utils.config")
local colors = require("src.utils.colors")
local layout = require("src.utils.layout")
local groups = require("src.utils.groups")
local tile = require("src.utils.tile")

local col = require("src.fragments.col")
local row = require("src.fragments.row")
local kind = require("src.fragments.kind")
local rot = require("src.fragments.rot")

local CELL = config.CELL

return ecs.builder()
    :name("systems.draw")
    :group(groups.draw)
    :include(col, row, kind, rot)
    :execute(function(chunk, entity_list, entity_count)
        local BX, BY = layout.board_x, layout.board_y
        local cols = chunk:components(col)
        local rows = chunk:components(row)
        local kinds = chunk:components(kind)
        local rots = chunk:components(rot)

        tile.begin()
        for i = 1, entity_count do
            local k = kinds[i]
            local c = colors[k]

            for _, cell in ipairs(shapes.cells(k, rots[i])) do
                local x = BX + (cols[i] + cell[1] - 1) * CELL
                local y = BY + (rows[i] + cell[2] - 1) * CELL
                tile.draw(x, y, c)
            end
        end
        tile.finish()
    end)
    :build()
