--local cfg = Entity.GetCfg("myplugin/player1")
local function resetplayer() --Reset Player To Default
  local map = World.CurWorld:getMap("LobbyColl")
  local pos = {x=-1.465,y=1.04,z=-33.713}
  
  for id, player in pairs(Game.GetAllPlayers()) do
    player:setMapPos(map,Vector3.new(pos.x,pos.y,pos.z),0,0)
    player:setRebirthPos(Vector3.new(pos.x,pos.y,pos.z),map)
  end
end

local function countdownGameTime()
  local gameStartState = true
  local gameTime = 10 --seconds
  local decreaseTime = 1
  PackageHandlers.sendServerHandlerToAll("GameTimeHandler", {gameTime})
--  print("GAME TIME "..gameStartTime)

  World.Timer(20,function()
    gameTime = gameTime - decreaseTime
    PackageHandlers.sendServerHandlerToAll("GameTimeHandler", {gameTime})
    
    if gameTime <= 0 then
      PackageHandlers.sendServerHandlerToAll("GameOverEvent")
      resetplayer()
      gameStartState = false
    end
    return gameStartState
  end)
end

local function countdownStartTime()
  
  local gameStartState = true
  local gameStartTime = 10 --seconds
  local decreaseTime = 1
  PackageHandlers.sendServerHandlerToAll("StartTimerHandler", {gameStartTime})
--  print("GAME TIME "..gameStartTime)
  
  World.Timer(20,function()
    gameStartTime = gameStartTime - decreaseTime
    PackageHandlers.sendServerHandlerToAll("StartTimerHandler", {gameStartTime})
    
    if gameStartTime <= 0 then
      
      local spawnPlatformPart = Instance.getByInstanceId(8709913335976345601)
      
      spawnPlatformPart:setProperty("materialAlpha", 0)
      spawnPlatformPart:setProperty("useCollide", "false")
      
      countdownGameTime()
      
      gameStartState = false
    end
    return gameStartState
  end)

end

Trigger.RegisterHandler(World.cfg, "GAME_START", function()
  PackageHandlers.sendServerHandlerToAll("TeamInitialization")
  countdownStartTime()
end)