local ecs = require("libs.evolved")
local config = require("src.utils.config")

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

local function row_full(r)
	local line = board.cells[r]
	if not line then
		return false
	end
	for c = 1, config.BOARD_W do
		if line[c] == nil then
			return false
		end
	end
	return true
end

function board.clear_lines()
	local full, cleared = {}, 0
	for r = 1, config.BOARD_H do
		if row_full(r) then
			full[r] = true
			cleared = cleared + 1
		end
	end
	if cleared == 0 then
		return 0
	end

	local new_cells, shift = {}, 0
	for r = config.BOARD_H, 1, -1 do
		local line = board.cells[r]
		if full[r] then
			for _, id in pairs(line) do
				ecs.destroy(id)
			end
			shift = shift + 1
		elseif line then
			local new_r = r + shift
			if shift > 0 then
				for _, id in pairs(line) do
					ecs.set(id, frow, new_r)
				end
			end
			new_cells[new_r] = line
		end
	end
	board.cells = new_cells

	return cleared
end

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
