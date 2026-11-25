local config = require("src.utils.config")
local audio = require("src.utils.audio")

local stats = {}

function stats.reset()
    stats.score = 0
    stats.level = config.START_LEVEL
    stats.lines = 0
    stats.lines_in_level = 0
end

function stats.lines_required()
    return stats.level * config.LINES_PER_LEVEL
end

function stats.fall_interval()
    local steps = math.min(stats.level, config.MAX_SPEED_LEVEL) - 1
    return (0.8 - steps * 0.007) ^ steps
end

function stats.add_lines(count)
    if count < 1 then
        return
    end

    if count < 4 then
        audio.play("clear")
    end

    if count == 4 then
        audio.play("tetris")
    end

    count = math.min(count, #config.LINE_SCORES)
    stats.score = stats.score + config.LINE_SCORES[count] * (stats.level + 1)
    stats.lines = stats.lines + count
    stats.lines_in_level = stats.lines_in_level + count

    while stats.lines_in_level >= stats.lines_required() do
        stats.lines_in_level = stats.lines_in_level - stats.lines_required()
        stats.level = stats.level + 1
    end
end

stats.reset()

return stats
