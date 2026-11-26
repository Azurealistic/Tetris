local config = require("src.utils.config")
local shaders = require("src.utils.shaders")

local data = love.image.newImageData(1, 1)
data:setPixel(0, 0, 1, 1, 1, 1)
local pixel = love.graphics.newImage(data)

local tile = {}

function tile.begin()
    local shader = shaders.tile
    love.graphics.setShader(shader)
    if shader:hasUniform("time") then
        shader:send("time", love.timer.getTime())
    end
end

function tile.draw(x, y, rgb, alpha)
    love.graphics.setColor(rgb[1], rgb[2], rgb[3], alpha or 1)
    love.graphics.draw(pixel, x, y, 0, config.CELL - 1, config.CELL - 1)
end

function tile.finish()
    love.graphics.setShader()
end

return tile