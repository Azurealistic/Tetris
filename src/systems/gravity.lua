local ecs = require("libs.evolved")
local config = require("src.utils.config")
local groups = require("src.utils.groups")
local input = require("src.utils.input")
local collision = require("src.utils.collision")

local col = require("src.fragments.col")
local row = require("src.fragments.row")
local kind = require("src.fragments.kind")
local rot = require("src.fragments.rot")
local fall_acc = require("src.fragments.fall_acc")
local controlled = require("src.fragments.controlled")

return ecs.builder()
	:name("systems.gravity")
	:group(groups.update)
	:include(controlled, col, row, kind, rot, fall_acc)
	:execute(function(chunk, entity_list, entity_count, dt)
		local cols = chunk:components(col)
		local rows = chunk:components(row)
		local kinds = chunk:components(kind)
		local rots = chunk:components(rot)
		local accs = chunk:components(fall_acc)

		local interval = config.FALL_INTERVAL
		local soft = input.soft_drop
		if soft then
			interval = interval / config.SOFT_DROP_MULT
		end

		for i = 1, entity_count do
			local acc = accs[i]
			if soft then
				acc = math.min(acc, interval)
			end
			acc = acc + dt

			while acc >= interval do
				if collision.fits(kinds[i], rots[i], cols[i], rows[i] + 1) then
					rows[i] = rows[i] + 1 -- direct write: next fits() sees the new row
					acc = acc - interval -- subtract, don't reset: keeps the remainder
				else
					acc = 0 -- blocked: don't bank "debt"; the lock system takes over
					break
				end
			end

			accs[i] = acc
		end
	end)
	:build()
