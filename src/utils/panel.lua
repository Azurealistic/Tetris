local panel = {
    fill = { 0.01, 0.01, 0.01 },
    border = { 0.78, 0.78, 0.78 },
    text = { 0.92, 0.92, 0.92 },
    muted = { 0.62, 0.62, 0.62 },
    radius = 4,
}

function panel.draw(x, y, w, h)
    love.graphics.setColor(panel.fill)
    love.graphics.rectangle("fill", x, y, w, h, panel.radius, panel.radius)
    love.graphics.setColor(panel.border)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", x, y, w, h, panel.radius, panel.radius)
    love.graphics.setLineWidth(1)
end

return panel
