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

local function start_col(piece_kind)
	return math.floor((config.BOARD_W - shapes.size[piece_kind]) / 2) + 1
end

local bag, bag_size = {}, 0
local queue = {}

local function random(n)
	local rng = (love and love.math and love.math.random) or math.random
	return rng(n)
end

local function refill_bag()
	for i, k in ipairs(shapes.kinds) do
		bag[i] = k
	end
	bag_size = #shapes.kinds

	-- Fisher-Yates shuffle: for i = n..2, swap bag[i] with a uniformly random
	-- bag[j], j in 1..i. Each of the 7! orderings is equally likely.
	for i = bag_size, 2, -1 do
		local j = random(i)
		bag[i], bag[j] = bag[j], bag[i]
	end
end

local function deal_from_bag()
	if bag_size == 0 then
		refill_bag()
	end
	local k = bag[bag_size]
	bag[bag_size] = nil
	bag_size = bag_size - 1
	return k
end

local function fill_queue(n)
	while #queue < n do
		queue[#queue + 1] = deal_from_bag()
	end
end

function piece.reset_randomizer()
	bag_size = 0
	queue = {}
end

function piece.peek(i)
	fill_queue(i)
	return queue[i]
end

function piece.next_kind()
	fill_queue(1)
	return table.remove(queue, 1)
end

-- ---------------------------------------------------------------------------

function piece.can_spawn(piece_kind)
	return collision.fits(piece_kind, 1, start_col(piece_kind), 1)
end

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
