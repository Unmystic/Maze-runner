function love.load()
  anim8 = require 'libraries/anim8'
  wf = require "libraries/windfield"
  
  setSwitches()
  colors = {"Red", "Blue", "Green"}
  switch = {}
  for i=1,3 do
      table.insert(switch,
          {
              x = RandLoc[i].Location.x,
              y = RandLoc[i].Location.y,
              
              spread = love.graphics.newImage("sprites/".. colors[i] .. "Switch.png"),
              grid = anim8.newGrid(16, 16, 48, 16),
              --animations = {},
              --animations.on = anim8.newAnimation(grid("1-3"), 0.2),
              animationOff = anim8.newAnimation((anim8.newGrid(16, 16, 48, 16))("3-1", 1),0.2),
              animationOn = anim8.newAnimation(anim8.newGrid(16, 16, 48, 16),0.2),
              anim = animationOff
              
          }
      )
  end
  
  RedSW = {}
  RedSW.spread = love.graphics.newImage("sprites/RedSwitch.png")
  RedSW.grid = anim8.newGrid(16, 16, RedSW.spread:getWidth(), RedSW.spread:getHeight())
  RedSW.animations = {}
  RedSW.animations.off = anim8.newAnimation(RedSW.grid("3-1",1),0.2)
  RedSW.animations.on = anim8.newAnimation(RedSW.grid("1-3",1),0.2)
  RedSW.anim = RedSW.animations.off
  RedSW.x = RandLoc[1].Location.x
  RedSW.y = RandLoc[1].Location.y
  RedSW.collider = world:newBSGRectangleCollider(RandLoc[1].Location.x, RandLoc[1].Location.y, 25, 29, 7)
  RedSW.collider:setFixedRotation(true)
  RedSW.collider:setType("static")
  
  -- the  same stuff fore blue and green switches
  BlueSW = {}
  BlueSW.spread = love.graphics.newImage("sprites/BlueSwitch.png")
  BlueSW.grid = anim8.newGrid(16, 16, BlueSW.spread:getWidth(), BlueSW.spread:getHeight())
  BlueSW.animations = {}
  BlueSW.animations.off = anim8.newAnimation(BlueSW.grid("3-1",1),0.2)
  BlueSW.animations.on = anim8.newAnimation(BlueSW.grid("1-3",1),0.2)
  BlueSW.anim = BlueSW.animations.off
  BlueSW.x = RandLoc[2].Location.x
  BlueSW.y = RandLoc[2].Location.y
  BlueSW.collider = world:newBSGRectangleCollider(RandLoc[2].Location.x, RandLoc[2].Location.y, 25, 29, 7)
  BlueSW.collider:setFixedRotation(true)
  BlueSW.collider:setType("static")
  
  GreenSW = {}
  GreenSW.spread = love.graphics.newImage("sprites/GreenSwitch.png")
  GreenSW.grid = anim8.newGrid(16, 16, GreenSW.spread:getWidth(), GreenSW.spread:getHeight())
  GreenSW.animations = {}
  GreenSW.animations.off = anim8.newAnimation(GreenSW.grid("3-1",1),0.2)
  GreenSW.animations.on = anim8.newAnimation(GreenSW.grid("1-3",1),0.2)
  GreenSW.anim = GreenSW.animations.off
  GreenSW.x = RandLoc[3].Location.x
  GreenSW.y = RandLoc[3].Location.y
  GreenSW.collider = world:newBSGRectangleCollider(RandLoc[3].Location.x, RandLoc[3].Location.y, 25, 29, 7)
  GreenSW.collider:setFixedRotation(true)
  GreenSW.collider:setType("static")
  
end


function love.update(dt)
  
end


function love.draw()
  
  --RedSW.anim:draw(RedSW.spread, RedSW.x -6, RedSW.y -6 ,nil, 2, 2)
  --BlueSW.anim:draw(BlueSW.spread, BlueSW.x -6, BlueSW.y -6 ,nil, 2, 2)
  --GreenSW.anim:draw(GreenSW.spread, GreenSW.x -6, GreenSW.y -6 ,nil, 2, 2)
  

  
end


function setSwitches()
  locations = {{x = 290, y = 160},
                 {x = 25, y = 540},
                 {x = 25, y = 915},
                 {x = 25, y = 540}
                 
              
            }
  
  RandLoc = {}
  for i=1,3 do
      table.insert(RandLoc,
          {
              Location = locations[love.math.random(1, 4)],
              
          }
      )
  end
  
  if (RandLoc[1].Location.x == RandLoc[2].Location.x and RandLoc[1].Location.y == RandLoc[2].Location.y) or
      (RandLoc[1].Location.x == RandLoc[3].Location.x and RandLoc[1].Location.y == RandLoc[3].Location.y) or
      (RandLoc[2].Location.x == RandLoc[3].Location.x and RandLoc[2].Location.y == RandLoc[3].Location.y) then
        setSwitches()
  else print("All good")
      --print( RandLoc[1].Location.x)

  end

end