--local cfg = Entity.GetCfg("myplugin/player1")
local function gameOverHandler()

  local redTeamTable = {}
  local blueTeamTable = {}
  redTeamTable.totalDeath = 0
  blueTeamTable.totalDeath = 0
  
  --COUNT TOTAL OF DEATH OF EACH TEAM
  local blueEntities = Game.GetTeam(1, true):getEntityList()
  local redEntities = Game.GetTeam(2, true):getEntityList()
  
  for _, entity in pairs(blueEntities) do
    local death = entity:getValue("death") --/ 2
--    death = math.tointeger(math.floor(death))
    blueTeamTable.totalDeath = blueTeamTable.totalDeath + death
    print("Player name : "..entity.name.." -> Death : "..death)
  end
  for _, entity in pairs(redEntities) do
    local death = entity:getValue("death") --/ 2
--    death = math.tointeger(math.floor(death))
    redTeamTable.totalDeath = redTeamTable.totalDeath + death
    print("Player name : "..entity.name.." -> Death : "..death)
  end
--  print("BLUE DEATH :"..blueTeamTable.totalDeath)
--  print("RED DEATH :"..redTeamTable.totalDeath)
  --DECIDE BASE SCORE FOR WINNING AND LOSING TEAM
  local blueIncrement
  local redIncrement
  if blueTeamTable.totalDeath < redTeamTable.totalDeath then
    blueIncrement = 150
    redIncrement = 50
  elseif blueTeamTable.totalDeath > redTeamTable.totalDeath then
    blueIncrement = 50
    redIncrement = 150
  else
    blueIncrement = 50
    redIncrement = 50
  end
--  print("BLUE INCR :"..blueIncrement)
--  print("RED INCR :"..redIncrement)
  -- COUNT AND SEND SCORES
  for _, entity in pairs(blueEntities) do
    local plr = {}
    plr.name = entity.name
    local tmp = entity:getValue("death") --/ 2
--    tmp = math.tointeger(math.floor(tmp))
    plr.score = ((blueTeamTable.totalDeath / (tmp + 1)) + 1) * blueIncrement
    plr.score = math.tointeger(math.ceil(plr.score))
    print("Player name : "..plr.name.." -> Score : "..plr.score)
    table.insert(blueTeamTable, plr)
    
    entity:setValue("score", plr.score)
  end

  for _, entity in pairs(redEntities) do
    local plr = {}
    plr.name = entity.name
    local tmp = entity:getValue("death") --/ 2
--    tmp = math.tointeger(math.floor(tmp))
    plr.score = ((redTeamTable.totalDeath / (tmp + 1)) + 1) * redIncrement
    plr.score = math.tointeger(math.ceil(plr.score))
    print("Player name : "..plr.name.." -> Score : "..plr.score)
    table.insert(redTeamTable, plr)
    
    entity:setValue("score", plr.score)
  end

  PackageHandlers.sendServerHandlerToAll("EndGameEvent", {redTeamTable, blueTeamTable})
end

local function resetplayer() --Reset Player To Default
  local map = World.CurWorld:getMap("Lobby")
  local pos = {x=-1.465,y=1.04,z=-33.713}
  
  for id, player in pairs(Game.GetAllPlayers()) do
    player:setMapPos(map,Vector3.new(pos.x,pos.y,pos.z),0,0)
    player:setRebirthPos(Vector3.new(pos.x,pos.y,pos.z),map)
  end
end

local function addPlayerSkill()
  for id, player in pairs(Game.GetAllPlayers()) do
    player:addSkill("myplugin/31708230-1e3e-4c06-be4a-a7af3e0c5e2c")
    player:addSkill("myplugin/Invishield")
    player:addSkill("myplugin/KnockbackBomb")
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
      resetplayer()
      gameOverHandler()
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
      
      addPlayerSkill()
      
      countdownGameTime()
      
      gameStartState = false
    end
    return gameStartState
  end)

end

local cfg = Entity.GetCfg("myplugin/player1")
Trigger.addHandler(cfg, "ENTITY_DIE", function(context)
  local plr = context.obj1 
  local death = plr:getValue("death") --Gets the value of the entity value that defines "death"
  
  if death > 0 then
    plr:setValue("death", death + 1) 
  else
    plr:setValue("death", 1)
  end
end )

Trigger.RegisterHandler(World.cfg, "GAME_START", function()
  PackageHandlers.sendServerHandlerToAll("TeamInitialization")
  -- ADD A FUNCTION TO SEE IF ALL OF PLAYERS ARE READY --
  
  -- END QUERY --
  countdownStartTime()
end)