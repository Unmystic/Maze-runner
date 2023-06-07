Gamestate = require "gamestate"
local Button = require "button"
local WinScreen = {} 
lume = require "lume"

function WinScreen:init()
    local sc,sh = love.graphics.getWidth(), love.graphics.getHeight()
    self.buttons = {}
    self.buttons[#self.buttons+1] = Button:new(sc / 2 - 40, sh / 2 - 20, 80, 40, "New game", function() Gamestate.switch(States.game) end)
    self.buttons[#self.buttons+1] = Button:new(sc / 2 - 40, sh / 2 + 40, 80, 40, "Quit game", function() love.event.quit() end)

    if love.filesystem.getInfo("savedata.txt") then
        file = love.filesystem.read("savedata.txt")
        data = lume.deserialize(file)
    end

    frames = {}

    for i=1,6 do
        table.insert(frames, love.graphics.newImage("sprites/Victory" .. i .. ".png"))
    end

    currentFrame = 1

end

function WinScreen:enter(previous) -- runs every time the state is entered
    self.previous = previous    
end

function WinScreen:update(dt) -- runs every frame
    currentFrame = currentFrame + 10 * dt
    if currentFrame >= 7 then
        currentFrame = 1
    end
end

local logo = love.graphics.newImage( 'sprites/Labyrinth.png' )

logo:getFilter('nearest', 'nearest')




function WinScreen:draw()
    self.previous:draw()
    love.graphics.setColor(0,0.6,0,0.6)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1,1,1,1)
    local sc,sh = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.draw(logo, sc / 2 - 180, sh / 2 - 350 , nil, 0.5, 0.5 )
    --Printing score
    love.graphics.print("Your time is:  " .. data.CurrentScore, 10, 10)
    love.graphics.print("Best time is:  " .. data.BestScore, 10, 30)
    love.graphics.draw(frames[math.floor(currentFrame)], 100, 200)
    love.graphics.draw(frames[math.floor(currentFrame)], sc - 150, 200)


    for _, b in ipairs(self.buttons) do
        b:draw()
    end
end

local function pointInRectangle(x,y,rect)
    return ((x <= rect.x + rect.w) and (x >= rect.x) and ( y <= rect.y + rect.h) and (y >= rect.y)) 
end

function WinScreen:mousereleased(x, y, button, istouch, presses)
    local x, y = love.mouse.getPosition()
    for _, b in ipairs(self.buttons) do
        if pointInRectangle(x,y,b) and b.onClick then
            b:onClick()
        end
    end    
end

--function WinScreen:keyreleased(key, code)
    --if key == 'escape' then
        --love.event.quit()
    --end
--end

return WinScreen