local Button = {}
Button.__index = Button

function Button:new(x,y,w,h,text,onClick)
   local o = {}             
   setmetatable(o,Button) 
    o.x,o.y,o.w,o.h,o.text,o.onClick = x,y,w,h,text,onClick
   return o
end

function Button:draw()
    love.graphics.setColor(0.5,0.5,0.5,1)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(0.5,0.5,1,1)
    love.graphics.rectangle("line", self.x + 2, self.y + 2, self.w - 4, self.h - 4)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(self.text, self.x + self.w / 2 - love.graphics.getFont():getWidth(self.text) / 2, self.y + self.h / 2 - love.graphics.getFont():getHeight() / 2)
end

return Button