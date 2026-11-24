local ecs = require("libs.evolved")
local shapes = require("src.utils.shapes")
local config = require("src.utils.config")
local groups = require("src.utils.groups")
local board = require("src.utils.board")
local collision = require("src.utils.collision")
local piece = require("src.entities.piece")

local col = require("src.fragments.col")
local row = require("src.fragments.row")
local kind = require("src.fragments.kind")
local rot = require("src.fragments.rot")
local lock_timer = require("src.fragments.lock_timer")
local controlled = require("src.fragments.controlled")

return ecs.builder()
	:name("systems.lock")
	:group(groups.update)
	:include(controlled, col, row, kind, rot, lock_timer)
	:execute(function(chunk, entity_list, entity_count, dt)
		local cols = chunk:components(col)
		local rows = chunk:components(row)
		local kinds = chunk:components(kind)
		local rots = chunk:components(rot)
		local timers = chunk:components(lock_timer)

		for i = 1, entity_count do
			local k, c, r = kinds[i], cols[i], rows[i]

			if collision.fits(k, rots[i], c, r + 1) then
				timers[i] = 0 -- can still fall: not grounded
			else
				timers[i] = timers[i] + dt

				if timers[i] >= config.LOCK_DELAY then
					for _, cell in ipairs(shapes.cells(k, rots[i])) do
						board.place(k, c + cell[1], r + cell[2])
					end
					ecs.destroy(entity_list[i])

					board.clear_lines()

					local next_kind = piece.next_kind()
					if piece.can_spawn(next_kind) then
						piece.spawn(next_kind)
					else
						board.game_over = true
					end
				end
			end
		end
	end)
	:build()
