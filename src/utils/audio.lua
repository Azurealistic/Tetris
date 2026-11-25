
local audio = {}

local sounds = {}

local SOUND_PATH = "assets/sounds/"

local SOUND_FILES = {
    clear = "clear.wav",
    drop = "drop.wav",
    gameover = "gameover.wav",
    lateral_move = "lateralmove.wav",
    levelup = "levelup.wav",
    rotate = "rotate.wav",
    select = "select.wav",
    start = "start.wav",
    tetris = "tetris.wav",
}

function audio.load()
    for name, file in pairs(SOUND_FILES) do
        sounds[name] = love.audio.newSource(
            SOUND_PATH .. file,
            "static"
        )
    end
end

function audio.play(name)
    local source = sounds[name]

    if not source then
        print("Unknown sound: " .. name)
        return
    end

    local instance = source:clone()
    instance:play()
end

function audio.stop(name)
    local source = sounds[name]

    if source then
        source:stop()
    end
end

function audio.setVolume(name, volume)
    local source = sounds[name]

    if source then
        source:setVolume(volume)
    end
end

function audio.setMasterVolume(volume)
    love.audio.setVolume(volume)
end

return audio
