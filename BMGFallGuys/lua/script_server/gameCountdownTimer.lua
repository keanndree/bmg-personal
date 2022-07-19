--local cfg = Entity.GetCfg("myplugin/player1")
local function gameOverHandler()
  print("GAME OVER")
  local redTeamTable = {}
  local blueTeamTable = {}
  
  local blueEntities = Game.GetTeam(1, true):getEntityList()
  for _, entity in pairs(blueEntities) do
--    print(entity.objID, entity.name)
      local player = {}
      player.name = entity.name
      player.score = entity:getValue("death")
      table.insert(blueTeamTable, player)
  end
  local redEntities = Game.GetTeam(2, true):getEntityList()
  for _, entity in pairs(redEntities) do
--    print(entity.objID, entity.name)
      local player = {}
      player.name = entity.name
      player.score = entity:getValue("death")
      table.insert(blueTeamTable, player)
  end
  
  PackageHandlers.sendServerHandlerToAll("GameOverEvent", {redTeamTable, blueTeamTable})
end

local function resetplayer() --Reset Player To Default
  local map = World.CurWorld:getMap("Lobby")
  local pos = {x=-1.465,y=1.04,z=-33.713}
  
  for id, player in pairs(Game.GetAllPlayers()) do
    player:setMapPos(map,Vector3.new(pos.x,pos.y,pos.z),0,0)
    player:setRebirthPos(Vector3.new(pos.x,pos.y,pos.z),map)
  end
end

--Game duration countdown
local function countdownGameTime()
  local gameStartState = true
  local gameTime = 10 --seconds DEFAULT = 120
  local decreaseTime = 1
  PackageHandlers.sendServerHandlerToAll("GameTimeHandler", {gameTime})
--  print("GAME TIME "..gameStartTime)

  World.Timer(20,function()
    gameTime = gameTime - decreaseTime
    PackageHandlers.sendServerHandlerToAll("GameTimeHandler", {gameTime})
    
    if gameTime <= 0 then
      gameOverHandler()
      resetplayer()
      gameStartState = false
    end
    return gameStartState
  end)
end

--Match start countdown
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