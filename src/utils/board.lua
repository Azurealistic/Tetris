local ecs = require("libs.evolved")

local fcol = require("src.fragments.col")
local frow = require("src.fragments.row")
local fkind = require("src.fragments.kind")
local fsettled = require("src.fragments.settled")

local board = {
	cells = {},
	game_over = false,
}

function board.occupied(c, r)
	local line = board.cells[r]
	return line ~= nil and line[c] ~= nil
end

function board.place(kind, c, r)
	local id = ecs.spawn({
		[fcol] = c,
		[frow] = r,
		[fkind] = kind,
		[fsettled] = true, -- tag: value is ignored
	})
	board.cells[r] = board.cells[r] or {}
	board.cells[r][c] = id
	return id
end

-- Destroys every settled block and resets the game-over flag.
function board.clear()
	for _, line in pairs(board.cells) do
		for _, id in pairs(line) do
			ecs.destroy(id)
		end
	end
	board.cells = {}
	board.game_over = false
end

return board
