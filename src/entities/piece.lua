local ecs = require("libs.evolved")
local shapes = require("src.utils.shapes")
local config = require("src.utils.config")
local collision = require("src.utils.collision")

local col = require("src.fragments.col")
local row = require("src.fragments.row")
local kind = require("src.fragments.kind")
local rot = require("src.fragments.rot")
local fall_acc = require("src.fragments.fall_acc")
local lock_timer = require("src.fragments.lock_timer")
local controlled = require("src.fragments.controlled")

local piece = {}

-- Center the n-wide box: (W - n) empty columns split left/right, floored,
-- +1 to convert the 0-based count into a 1-based column.
local function start_col(piece_kind)
	return math.floor((config.BOARD_W - shapes.size[piece_kind]) / 2) + 1
end

function piece.random_kind()
	local random = (love and love.math and love.math.random) or math.random
	return shapes.kinds[random(#shapes.kinds)]
end

-- False when the spawn position is already blocked (the stack reached the top).
function piece.can_spawn(piece_kind)
	return collision.fits(piece_kind, 1, start_col(piece_kind), 1)
end

-- Spawns a piece with every fragment it will ever need, so no structural
-- changes (fragment add/remove) are required later.
function piece.spawn(piece_kind)
	return ecs.spawn({
		[col] = start_col(piece_kind),
		[row] = 1,
		[kind] = piece_kind,
		[rot] = 1,
		[fall_acc] = 0,
		[lock_timer] = 0,
		[controlled] = true, -- tag: value is ignored
	})
end

return piece
