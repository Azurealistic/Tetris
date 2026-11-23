local config = require("src.utils.config")
local input = require("src.utils.input")

local autorepeat = {
	held = {}, -- key -> { action, t, emitted }
}

-- key -> action to repeat; OPPOSITE: the key that gets cancelled when this one is pressed
local REPEATING = { left = "left", right = "right" }
local OPPOSITE = { left = "right", right = "left" }

function autorepeat.press(key)
	local action = REPEATING[key]
	if not action then
		return
	end

	autorepeat.held[OPPOSITE[key]] = nil
	autorepeat.held[key] = { action = action, t = 0, emitted = 0 }
end

function autorepeat.update(dt)
	for key, h in pairs(autorepeat.held) do
		if not love.keyboard.isDown(key) then
			autorepeat.held[key] = nil
		else
			h.t = h.t + dt

			local due = 0
			if h.t >= config.DAS then
				due = math.floor((h.t - config.DAS) / config.ARR) + 1
			end

			for _ = h.emitted + 1, due do
				input.push(h.action)
			end
			h.emitted = due
		end
	end
end

function autorepeat.clear()
	autorepeat.held = {}
end

return autorepeat
