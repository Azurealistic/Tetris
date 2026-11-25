local shapes = require("src.utils.shapes")
local config = require("src.utils.config")
local colors = require("src.utils.colors")
local fonts = require("src.utils.fonts")
local layout = require("src.utils.layout")
local panel = require("src.utils.panel")
local piece = require("src.entities.piece")

local next_preview = {}

local function bounds(cells)
    local min_x, max_x, min_y, max_y = math.huge, -math.huge, math.huge, -math.huge
    for _, c in ipairs(cells) do
        min_x, max_x = math.min(min_x, c[1]), math.max(max_x, c[1])
        min_y, max_y = math.min(min_y, c[2]), math.max(max_y, c[2])
    end
    return min_x, max_x, min_y, max_y
end

function next_preview.draw()
    local area = layout.next
    local cell = config.CELL

    panel.draw(area.x, area.y, area.w, area.h)

    love.graphics.setFont(fonts.title)
    love.graphics.setColor(panel.text)
    love.graphics.printf("Next Piece", area.x, area.y + layout.PAD, area.w, "center")

    local slots_x = area.x + layout.PAD
    local slots_y = area.y + layout.PAD + area.title_h

    for i = 1, config.NEXT_COUNT do
        local kind = piece.peek(i)
        local cells = shapes.cells(kind, 1)
        local min_x, max_x, min_y, max_y = bounds(cells)

        local width = (max_x - min_x + 1) * cell - 1
        local height = (max_y - min_y + 1) * cell - 1
        local left = slots_x + math.floor((area.slot_w - width) / 2)
        local top = slots_y + (i - 1) * area.slot_h + math.floor((area.slot_h - height) / 2)

        local rgb = colors[kind]
        love.graphics.setColor(rgb[1], rgb[2], rgb[3])
        for _, c in ipairs(cells) do
            love.graphics.rectangle("fill",
                left + (c[1] - min_x) * cell,
                top + (c[2] - min_y) * cell,
                cell - 1, cell - 1)
        end
    end
end

return next_preview
