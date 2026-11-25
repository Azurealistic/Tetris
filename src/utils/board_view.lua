local config = require("src.utils.config")
local layout = require("src.utils.layout")
local panel = require("src.utils.panel")

local board_view = {}

function board_view.draw()
    local frame = layout.frame
    panel.draw(frame.x, frame.y, frame.w, frame.h)

    local left, top = layout.board_x, layout.board_y
    local right = left + config.BOARD_W * config.CELL
    local bottom = top + config.BOARD_H * config.CELL

    love.graphics.setColor(1, 1, 1, 0.07)
    for c = 1, config.BOARD_W - 1 do
        local x = left + c * config.CELL
        love.graphics.line(x, top, x, bottom)
    end
    for r = 1, config.BOARD_H - 1 do
        local y = top + r * config.CELL
        love.graphics.line(left, y, right, y)
    end
end

return board_view