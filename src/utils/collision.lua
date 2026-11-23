local shapes = require("src.utils.shapes")
local config = require("src.utils.config")

local collision = {}

function collision.fits(kind, rot, col, row)
	for _, cell in ipairs(shapes.cells(kind, rot)) do
		local c = col + cell[1]
		local r = row + cell[2]

		if c < 1 or c > config.BOARD_W then
			return false -- wall
		end
		if r > config.BOARD_H then
			return false -- floor
		end
	end

	return true
end

return collision
