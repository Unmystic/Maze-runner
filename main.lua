Gamestate = require "gamestate"
States = {
        menu = require "menu",
        game = require "game",
        winscreen = require "winscreen",
    }

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(States.game)
end
