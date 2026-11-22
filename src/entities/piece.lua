local ecs = require("libs.evolved")
local shapes = require("src.utils.shapes")
local config = require("src.utils.config")

local col = require("src.fragments.col")
local row = require("src.fragments.row")
local kind = require("src.fragments.kind")
local rot = require("src.fragments.rot")
local fall_acc = require("src.fragments.fall_acc")
local lock_timer = require("src.fragments.lock_timer")
local controlled = require("src.fragments.controlled")

local piece = {}

-- Spawns a piece with every fragment it will ever need, so no structural
-- changes (fragment add/remove) are required later.
function piece.spawn(piece_kind)
	local n = shapes.size[piece_kind]

	-- Center the n-wide box: (W - n) empty columns split left/right, floored,
	-- +1 to convert the 0-based count into a 1-based column.
	local start_col = math.floor((config.BOARD_W - n) / 2) + 1

	return ecs.spawn({
		[col] = start_col,
		[row] = 1,
		[kind] = piece_kind,
		[rot] = 1,
		[fall_acc] = 0,
		[lock_timer] = 0,
		[controlled] = true, -- tag: value is ignored
	})
end

return piece
