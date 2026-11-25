local config = require("src.utils.config")
local fonts = require("src.utils.fonts")

local layout = {
    FRAME = 6,
    GAP = 30,
    PAD = 14,
    PANEL_GAP = 20,
    ROW_GAP = 10,
}

function layout.update()
    local window_w, window_h = love.graphics.getDimensions()
    local cell = config.CELL
    local pad = layout.PAD

    local frame_w = config.BOARD_W * cell + 2 * layout.FRAME
    local frame_h = config.BOARD_H * cell + 2 * layout.FRAME

    local side_w = 6 * cell
    local title_h = fonts.title:getHeight() + 10
    local slot_w = side_w - 2 * pad
    local slot_h = 3 * cell
    local next_h = pad + title_h + config.NEXT_COUNT * slot_h + pad

    local row_h = fonts.label:getHeight() + fonts.value:getHeight()
    local score_h = 2 * pad + 3 * row_h + 2 * layout.ROW_GAP

    local total_w = frame_w + layout.GAP + side_w
    local frame_x = math.floor((window_w - total_w) / 2)
    local frame_y = math.floor((window_h - frame_h) / 2)
    local side_x = frame_x + frame_w + layout.GAP

    layout.frame = { x = frame_x, y = frame_y, w = frame_w, h = frame_h }
    layout.board_x = frame_x + layout.FRAME
    layout.board_y = frame_y + layout.FRAME
    layout.next = {
        x = side_x, y = frame_y, w = side_w, h = next_h,
        title_h = title_h, slot_w = slot_w, slot_h = slot_h,
    }
    layout.score = {
        x = side_x, y = frame_y + next_h + layout.PANEL_GAP, w = side_w, h = score_h,
        row_h = row_h,
    }
end

layout.update()

return layout
