Gamestate = require "gamestate"
local Button = require "button"
local Menu = {} 

function Menu:init()
    local sc,sh = love.graphics.getWidth(), love.graphics.getHeight()
    self.buttons = {}
    self.buttons[#self.buttons+1] = Button:new(sc / 2 - 40, sh / 2 - 20, 80, 40, "New game", function() Gamestate.switch(States.game) end)
    self.buttons[#self.buttons+1] = Button:new(sc / 2 - 40, sh / 2 + 40, 80, 40, "Resume", function() Gamestate.pop() end)
end

function Menu:enter(previous) -- runs every time the state is entered
    self.previous = previous    
end

function Menu:update(dt) -- runs every frame
    
end

local logo = love.graphics.newImage( 'sprites/Labyrinth.png' )

logo:getFilter('nearest', 'nearest')

function Menu:draw()
    self.previous:draw()
    love.graphics.setColor(1,1,1,0.4)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1,1,1,1)
    local sc,sh = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.draw(logo, sc / 2 - 180, sh / 2 - 350 , nil, 0.5, 0.5 )
    for _, b in ipairs(self.buttons) do
        b:draw()
    end
end

local function pointInRectangle(x,y,rect)
    return ((x <= rect.x + rect.w) and (x >= rect.x) and ( y <= rect.y + rect.h) and (y >= rect.y)) 
end

function Menu:mousereleased(x, y, button, istouch, presses)
    local x, y = love.mouse.getPosition()
    for _, b in ipairs(self.buttons) do
        if pointInRectangle(x,y,b) and b.onClick then
            b:onClick()
        end
    end    
end

function Menu:keyreleased(key, code)
    if key == 'escape' then
        love.event.quit()
    end
end

return Menu