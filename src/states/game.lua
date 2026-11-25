local ecs = require("libs.evolved")
local groups = require("src.utils.groups")
local input = require("src.utils.input")
local autorepeat = require("src.utils.autorepeat")
local board = require("src.utils.board")
local piece = require("src.entities.piece")
local stats = require("src.utils.stats")
local board_view = require("src.utils.board_view")
local next_preview = require("src.utils.next_preview")
local score_panel = require("src.utils.score_panel")
local controlled = require("src.fragments.controlled")

require("src.systems.draw_blocks")
require("src.systems.ghost")
require("src.systems.draw")
require("src.systems.input")
require("src.systems.gravity")
require("src.systems.lock")

local game = {}

local KEYMAP = {
	left = "left",
	right = "right",
	up = "rotate_cw",
	x = "rotate_cw",
	rctrl = "rotate_ccw",
	lctrl = "rotate_ccw",
	z = "rotate_ccw",
	space = "hard_drop",
}

local controlled_query = ecs.builder():include(controlled):build()

local function start()
	ecs.batch_destroy(controlled_query)
	board.clear()
	input.clear()
	autorepeat.clear()
	piece.reset_randomizer()
	piece.spawn(piece.next_kind())
end

function game:enter()
	start()
end

function game:update(dt)
	input.soft_drop = love.keyboard.isDown("down")

	autorepeat.update(dt)

	ecs.process_with(groups.update, dt)

	if board.game_over then
		start()
	end
end

function game:draw()
    board_view.draw()
    ecs.process(groups.draw)
    next_preview.draw()
    score_panel.draw()
end

function game:keypressed(key)
    local action = KEYMAP[key]
    if action then
        input.push(action)
        autorepeat.press(key)
    end
end

function game:leave() end

return game
