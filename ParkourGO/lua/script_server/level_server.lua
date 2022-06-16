local function addexp(player,exp)
  local data = player:getValue("LevelProgress")
  if data.level < data.maxlevel then
    data.expnow = data.expnow + exp
    if data.expnow >= data.expneed then
      
      while data.expnow >= data.expneed do
        data.expnow = data.expnow - data.expneed
        data.expneed = data.expneed + 59
        if data.level < data.maxlevel then
          data.level = data.level + 1
        end
      end
      
      if data.level >= data.maxlevel then
        data.level = 100
        data.expnow = 0
        data.expneed = 0
      end
      
    end
  end
  player:setValue("LevelProgress",data)
end

local cfg = Entity.GetCfg("myplugin/player1")
Trigger.addHandler(cfg,"ENTITY_ENTER",function(context)
    local player = context.obj1
    local data = player:getValue("Level")
    if data ~= nil then
      player:setValue("Level",nil)
    end
    PackageHandlers.sendServerHandler(player,"OpenLevelUI")
end)

PackageHandlers.registerServerHandler("LevelUIOpened",function(player)
    player:timer(1,function()
        local data = player:getValue("LevelProgress")
        PackageHandlers.sendServerHandler(player,"UpdateLevelUI",data)
        return true
    end)
end)