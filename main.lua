-- Tetris!

love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";src/?.lua")

local fsm = require("libs.gamestate")
local ecs = require("libs.evolved")
local audio = require("src.utils.audio")

ecs.debug_mode(true)

local game = require("states.game")

function love.load()
	audio.load() -- Don't wanna load module every game over.
	audio.setMasterVolume(0.1)
	fsm.registerEvents()
	fsm.switch(game)
end
