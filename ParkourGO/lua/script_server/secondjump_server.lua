--THIS IS SECONDJUMP SERVER SCRIPT
local secondjumpdata = {
  ["myplugin/goldenspring1"] = {delay=3},
  ["myplugin/goldenspring2"] = {delay=4},
  ["myplugin/goldenspring3"] = {delay=6},
  ["myplugin/goldenspring4"] = {delay=8},
  ["myplugin/goldenspring5"] = {delay=10},
  }

local cfg = Entity.GetCfg("myplugin/player1")
Trigger.addHandler(cfg,"ENTITY_ENTER",function(context)
    local player = context.obj1
    player:setValue("SecondJump",{valid=false,avail=false})
    player:timer(1,function()
        local data = player:getValue("SecondJump")
        --Check if player in time of Double Jump
        if data.valid then
          --Check is player used secondjump till last Jump (Can use 1 time in 1 jump)
          if data.avail then
            --Check if player is not on ground
            if not player.onGround then
              PackageHandlers.sendServerHandler(player,"CheckAndOpenSecondJump")
            else
              PackageHandlers.sendServerHandler(player,"CheckAndCloseSecondJump")
            end
          end
        else
          PackageHandlers.sendServerHandler(player,"CheckAndCloseSecondJump")
        end
        return true
    end)
end)

Trigger.addHandler(cfg,"ENTITY_USE_ITEM",function(context)
    local player = context.obj1
    local itemname = context.itemName
    if secondjumpdata[itemname] then
      local data = player:getValue("SecondJump")
      if not data.valid then
        data.valid = true
        data.avail = true
        player:setValue("SecondJump",data)
        player:sendTip(1,"Use Golden Spring Successfully!",3)
        
        local startTime = World.Now()
        local delay = secondjumpdata[itemname].delay*20
        
        player:timer(1,function()
            local nowTime = World.Now()
            local time = nowTime - startTime
            if time < delay then
              local second = math.floor((delay-time)/20)
              player:sendTip(2,"Golden Spring: "..second,1)
              return true
            else
              data.valid = false
              data.avail = false
              player:setValue("SecondJump",data)
              player:sendTip(1,"Golden Spring Out Of Time!",3)
              PackageHandlers.sendServerHandler(player,"CheckAndCloseSecondJump")
              return false
            end
        end)
      else
        player:sendTip(1,"You can't use this item right now!",3)
        player:addItem(itemname,1)
      end
    end
end)

Trigger.addHandler(cfg,"ENTITY_TOUCH_PART_BEGIN",function(context)
    local player = context.obj1
    local data = player:getValue("SecondJump")
    if data.valid then
      if not data.avail then
        data.avail = true
        player:setValue("SecondJump",data)
      end
    end
end)

PackageHandlers.registerServerHandler("SecondJumpClicked",function(player)
    local data = player:getValue("SecondJump")
    data.avail = false
    player:setValue("SecondJump",data)
    PackageHandlers.sendServerHandler(player,"CheckAndCloseSecondJump")
    PackageHandlers.sendServerHandler(player,"MakePlayerJump")
end)