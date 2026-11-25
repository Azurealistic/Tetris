local fonts = require("src.utils.fonts")
local layout = require("src.utils.layout")
local panel = require("src.utils.panel")
local stats = require("src.utils.stats")

local score_panel = {}

function score_panel.draw()
    local area = layout.score
    panel.draw(area.x, area.y, area.w, area.h)

    local rows = {
        { "Score", tostring(stats.score) },
        { "Level", tostring(stats.level) },
        { "Lines", stats.lines_in_level .. " / " .. stats.lines_required() },
    }

    local text_x = area.x + layout.PAD
    local text_w = area.w - 2 * layout.PAD

    for i, row in ipairs(rows) do
        local y = area.y + layout.PAD + (i - 1) * (area.row_h + layout.ROW_GAP)

        love.graphics.setFont(fonts.label)
        love.graphics.setColor(panel.muted)
        love.graphics.printf(row[1], text_x, y, text_w, "center")

        love.graphics.setFont(fonts.value)
        love.graphics.setColor(panel.text)
        love.graphics.printf(row[2], text_x, y + fonts.label:getHeight(), text_w, "center")
    end
end

return score_panel
