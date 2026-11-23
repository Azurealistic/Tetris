local ecs = require("libs.evolved")
local config = require("src.utils.config")
local groups = require("src.utils.groups")
local collision = require("src.utils.collision")

local col = require("src.fragments.col")
local row = require("src.fragments.row")
local kind = require("src.fragments.kind")
local rot = require("src.fragments.rot")
local fall_acc = require("src.fragments.fall_acc")
local controlled = require("src.fragments.controlled")

local INTERVAL = config.FALL_INTERVAL

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

		for i = 1, entity_count do
			local acc = accs[i] + dt

			while acc >= INTERVAL do
				if collision.fits(kinds[i], rots[i], cols[i], rows[i] + 1) then
					rows[i] = rows[i] + 1
					acc = acc - INTERVAL
				else
					acc = 0
					break
				end
			end

			accs[i] = acc
		end
	end)
	:build()
