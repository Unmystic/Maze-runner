local game = {}

Gamestate = require "gamestate"
lume = require "lume"

function game:enter()
    wf = require "libraries/windfield"
    world = wf.newWorld(0,0)
    world:addCollisionClass('Reds')
    world:addCollisionClass('Blues')
    world:addCollisionClass('Greens')
    
    camera = require "libraries/camera"
    cam = camera()
    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    sti = require "sti"
    gamemap = sti("maps/testMap6.lua")
    
    player = {}
    player.collider = world:newBSGRectangleCollider(200, 450, 25, 29, 7)
    player.collider:setFixedRotation(true)
    player.x = 200
    player.y = 350
    player.speed = 250
    --player.sprite = love.graphics.newImage('sprites/parrot.png')
    player.spriteSheet = love.graphics.newImage('sprites/player-sheet1.png')
    player.grid = anim8.newGrid( 32, 36, player.spriteSheet:getWidth(), player.spriteSheet:getHeight() )

    player.animations = {}
    player.animations.down = anim8.newAnimation( player.grid('1-3', 3), 0.2 )
    player.animations.left = anim8.newAnimation( player.grid('1-3', 4), 0.2 )
    player.animations.right = anim8.newAnimation( player.grid('1-3', 2), 0.2 )
    player.animations.up = anim8.newAnimation( player.grid('1-3', 1), 0.2 )

    player.anim = player.animations.left

    cam:lookAt(player.x, player.y)
    cam:zoom(1.5)
    
    --locations = {{x = 290, y = 160},
                 --{x = 25, y = 540},
                 --{x = 25, y = 905},
                 --{x = 25, y = 540}
                --}
    --print(locations[2].x == locations[4].x)
    
    game:setSwitches()
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
    RedSW.collider:setCollisionClass('Reds')
    
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
    BlueSW.collider:setCollisionClass('Blues')
    
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
    GreenSW.collider:setCollisionClass('Greens')
    

    background = love.graphics.newImage('sprites/background.png')
    
    
    walls = {}
    gates ={}
    if gamemap.layers["Walls"] then
      for i, obj in pairs(gamemap.layers["Walls"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType("static")
            table.insert(walls, wall)
      end
    end
    if gamemap.layers["Gate"] then
      for i, obj in pairs(gamemap.layers["Gate"].objects) do
            local gate = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            gate:setType("static")
            gate["color"] = colors[i]
            table.insert(gates, gate)
            
            --gate["image"] = love.graphics.newImage('sprites/Gate' .. colors[i] .. '.png') 
            --table.insert(gates, color)
            --print(gate)
      end
    end
    
    gate1= love.graphics.newImage('sprites/GateRed.png')
    gate2= love.graphics.newImage('sprites/GateBlue.png')
    gate3= love.graphics.newImage('sprites/GateGreen.png')
    gate = {gate1, gate2, gate3}
    
    RedSwitchStatus = false
    BlueSwitchStatus = false
    GreeSwitchStatus = false
 for index, data in ipairs(gates) do
      print(index)

      for key, value in pairs(data) do
          print('\t', key, value)
      end
  end
  SwCount = 0
  countdown = 0
end
 
function game:update(dt)
    local isMoving = false
    
    local vx = 0
    local vy = 0

    if love.keyboard.isDown("right") then
        vx = player.speed
        player.anim = player.animations.right
        isMoving = true
    end

    if love.keyboard.isDown("left") then
        vx = player.speed * -1
        player.anim = player.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("down") then
        vy = player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("up") then
        vy = player.speed * -1
        player.anim = player.animations.up
        isMoving = true
    end

    if love.keyboard.isDown("lshift") then
        player.speed = 500

    end
    
    player.collider:setLinearVelocity(vx, vy)

    if isMoving == false then
        player.anim:gotoFrame(2)
    end
    
    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
    

    player.anim:update(dt)
    
    cam:lookAt(player.x, player.y)
    
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    
    if cam.x < (width/2)/ 1.5 then
      cam.x = (width/2)/ 1.5
    end
    
    if cam.y < (height/2) / 1.5 then
      cam.y = (height/2) / 1.5
    end
    
    local mapW = gamemap.width * gamemap.tilewidth
    local mapH = gamemap.height * gamemap.tileheight
    
    --Right border
    if cam.x > (mapW - (width/2)/1.5) then
      cam.x = (mapW - (width/2)/1.5)
    end
    --Bottom border
    if cam.y > (mapH - (height/2) / 1.5) then
      cam.y = (mapH - (height/2) / 1.5) 
    end
    
    
    --Setting collisions
    
    if player.collider:enter('Reds') then
      local collision_data = player.collider:getEnterCollisionData('Reds')
      local enemy = collision_data.collider:getObject()
      if RedSwitchStatus == false then
        SwCount = SwCount + 1
      end
      RedSwitchStatus = true
      RedSW.anim = RedSW.animations.on
      --self:takeDamage(10)
      for i,v in pairs(gates) do
          if gates[i]["color"] == "Red" then
              --table.remove(gates, v)
              gates[i]:destroy()
              gates[i]= nil
              --table.remove(gates, gates[i])
              
          end
      end
    end  
    
    if player.collider:enter('Blues') then
      local collision_data = player.collider:getEnterCollisionData('Blues')
      local enemy = collision_data.collider:getObject()
      if BlueSwitchStatus == false then
        SwCount = SwCount + 1
      end
      BlueSwitchStatus = true
      BlueSW.anim = BlueSW.animations.on
      --self:takeDamage(10)
      for i,v in pairs(gates) do
          if gates[i]["color"] == "Blue" then
              --table.remove(gates, v)
              gates[i]:destroy()
              gates[i]= nil
              --gates[i]["setActive"] = false
              --table.remove(gates, gates[i])
              
          end
      end
    end  
    
    if player.collider:enter('Greens') then
      local collision_data = player.collider:getEnterCollisionData('Greens')
      local enemy = collision_data.collider:getObject()
      if GreeSwitchStatus == false then
        SwCount = SwCount + 1
      end
      GreeSwitchStatus = true

      GreenSW.anim = GreenSW.animations.on
      --self:takeDamage(10)
      for i,v in pairs(gates) do
          if gates[i]["color"] == "Green" then
              --table.remove(gates, v)
              --gates[i]["setActive"] = false
              --table.remove(gates, gates[i])
              gates[i]:destroy()
              
              gates[i]= nil
              
          end
      end
    end  
    
   countdown = countdown + dt 

  if player.x > 895 and player.x < 1015 and player.y < 30  then
    if love.filesystem.getInfo("savedata.txt") then
      file = love.filesystem.read("savedata.txt")
      data = lume.deserialize(file)

      --Apply the player info
      if math.floor(countdown*100) / 100 < data.BestScore then
        data.BestScore = math.floor(countdown*100) / 100 
        data.CurrentScore = math.floor(countdown*100) / 100 
      else
        data.CurrentScore = math.floor(countdown*100) / 100 
      end

      serialized = lume.serialize(data)
      love.filesystem.write("savedata.txt", serialized)
    


    else
      data = {}
      data.BestScore = math.floor(countdown*100) / 100 
      data.CurrentScore = math.floor(countdown*100) / 100 
      serialized = lume.serialize(data)
      love.filesystem.write("savedata.txt", serialized)
    end

  Gamestate.push(States.winscreen)
  end


    --print(gates["Collider"])
    
end

function game:draw()
  cam:attach()
    --cam:zoom(2) 
    gamemap:drawLayer(gamemap.layers["Base"])
    gamemap:drawLayer(gamemap.layers["Wall-base"])
    player.anim:draw(player.spriteSheet, player.x -16, player.y - 18)
    for i, obj in pairs(gates) do
      love.graphics.draw(gate[i], obj:getX() -50, obj:getY() - 15)
    end
    --for i,v in ipairs(switch) do
        --love.graphics.circle("line", v.x, v.y, v.size)
        --love.graphics.draw(v.image, v.x, v.y,
            --0, 2, 2, v.image:getWidth()/2, v.image:getHeight()/2)
        --love.graphics.draw(v.spread, v.x, v.y,
            --0, 2, 2, v.spread:getWidth()/2, v.spread:getHeight()/2)
        --v.animationOff:draw(v.spread, 100, 100)
        --print(v.animationOff)
    --end
    RedSW.anim:draw(RedSW.spread, RedSW.x -6, RedSW.y -6 ,nil, 2, 2)
    BlueSW.anim:draw(BlueSW.spread, BlueSW.x -6, BlueSW.y -6 ,nil, 2, 2)
    GreenSW.anim:draw(GreenSW.spread, GreenSW.x -6, GreenSW.y -6 ,nil, 2, 2)
    
    --world:draw()
  cam:detach()
  if SwCount < 3 then
    love.graphics.print("Switches activated:  " .. SwCount .. "  TO GO: " .. 3 - SwCount, 10, 10)
  else
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print("You activated all the switches. Go to the END !")
    love.graphics.reset( )
  end  
  countdown = math.floor(countdown*100) / 100 
  love.graphics.print("Your time is:  " .. countdown, 10, 30)
  --love.graphics.print(#gates, 10, 40)
  
end

function game:setSwitches()
  locations = {{x = 290, y = 160},
                 {x = 25, y = 540},
                 {x = 25, y = 915},
                 {x = 1875, y = 1550},
                 {x = 1760, y = 30},
                 {x = 1040, y = 1800},
                 {x = 590, y = 990},
                 {x = 1310, y = 270},
                 {x = 1670, y = 1230},
                 {x = 210, y = 1700},
                 {x = 530, y = 1610},
                 {x = 1810, y = 715}


                 
                 
              
            }
  
  RandLoc = {}
  for i=1,3 do
      table.insert(RandLoc,
          {
              Location = locations[love.math.random(1, 12)],
              
          }
      )
  end
  
  if (RandLoc[1].Location.x == RandLoc[2].Location.x and RandLoc[1].Location.y == RandLoc[2].Location.y) or
      (RandLoc[1].Location.x == RandLoc[3].Location.x and RandLoc[1].Location.y == RandLoc[3].Location.y) or
      (RandLoc[2].Location.x == RandLoc[3].Location.x and RandLoc[2].Location.y == RandLoc[3].Location.y) then
        game:setSwitches()
  else print("All good")
      --print( RandLoc[1].Location.x)

  end

end

function game:keyreleased(key, code)
    if key == 'escape' then
        Gamestate.push(States.menu)
    end
end

function love.keyreleased(key)
  if key == "lshift" then
     player.speed = 250
  end
end

return game
