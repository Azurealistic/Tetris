local ecs = require("libs.evolved")
local shapes = require("src.utils.shapes")
local config = require("src.utils.config")
local groups = require("src.utils.groups")
local input = require("src.utils.input")
local collision = require("src.utils.collision")

local col = require("src.fragments.col")
local row = require("src.fragments.row")
local kind = require("src.fragments.kind")
local rot = require("src.fragments.rot")
local fall_acc = require("src.fragments.fall_acc")
local lock_timer = require("src.fragments.lock_timer")
local controlled = require("src.fragments.controlled")

local fits = collision.fits

local function try_rotate(k, c, rw, new_rot)
	for _, kick in ipairs(config.ROTATION_KICKS) do
		local nc, nr = c + kick[1], rw + kick[2]
		if fits(k, new_rot, nc, nr) then
			return nc, nr, new_rot
		end
	end
	return nil
end

return ecs.builder()
	:name("systems.input")
	:group(groups.update)
	:include(controlled, col, row, kind, rot, fall_acc, lock_timer)
	:execute(function(chunk, entity_list, entity_count)
		local cols = chunk:components(col)
		local rows = chunk:components(row)
		local kinds = chunk:components(kind)
		local rots = chunk:components(rot)
		local accs = chunk:components(fall_acc)
		local timers = chunk:components(lock_timer)

		for i = 1, entity_count do
			-- Actions are applied in the order they were pressed.
			for a = 1, input.count do
				local action = input.queue[a]
				local k, c, rw, r = kinds[i], cols[i], rows[i], rots[i]

				if action == "left" then
					if fits(k, r, c - 1, rw) then
						cols[i] = c - 1
					end
				elseif action == "right" then
					if fits(k, r, c + 1, rw) then
						cols[i] = c + 1
					end
				elseif action == "hard_drop" then
					rows[i] = collision.drop_row(k, r, c, rw)
					accs[i] = 0
					timers[i] = config.LOCK_DELAY
				elseif action == "rotate_cw" or action == "rotate_ccw" then
					local new_rot = action == "rotate_cw" and shapes.rotate_cw(r) or shapes.rotate_ccw(r)
					local nc, nr, nrot = try_rotate(k, c, rw, new_rot)
					if nc then
						cols[i], rows[i], rots[i] = nc, nr, nrot
					end -- else: refused, piece stays as it was
				end
			end
		end
	end)
	:epilogue(function()
		input.clear()
	end)
	:build()
