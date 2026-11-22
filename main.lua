-- Tetris!

love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";src/?.lua")

local fsm = require("libs.gamestate")
local ecs = require("libs.evolved")

ecs.debug_mode(true)

local game = require("states.game")

function love.load()
	fsm.registerEvents()
	fsm.switch(game)
end
