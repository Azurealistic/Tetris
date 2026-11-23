-- Collision helpers. They take plain values and only read the board index.
local shapes = require("src.utils.shapes")
local config = require("src.utils.config")
local board = require("src.utils.board")

local collision = {}

function collision.fits(kind, rot, col, row)
	for _, cell in ipairs(shapes.cells(kind, rot)) do
		local c = col + cell[1]
		local r = row + cell[2]

		if c < 1 or c > config.BOARD_W then
			return false -- wall
		end
		if r < 1 or r > config.BOARD_H then
			return false -- ceiling / floor
		end
		if board.occupied(c, r) then
			return false -- settled block
		end
	end

	return true
end

function collision.drop_row(kind, rot, col, row)
	while collision.fits(kind, rot, col, row + 1) do
		row = row + 1
	end
	return row
end

return collision
