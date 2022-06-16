--DATA AREA
local lobby = {mapname="lobby",pos={x=0,y=1.5,z=0}}
local roomdata = {
  training = {
    type = "normal",
    --maplist={"map001"},
    startpos={mapname="map001",pos={x=0,y=1.5,z=0}},
    reward={money=10,exp=50},
    playernum=0
  },
  speedrun = {
    type = "normal",
    --maplist={},
    startpos={mapname="speed1",pos={x=0,y=3.5,z=0}},
    reward={money=50,exp=100},
    checkpointrewards={
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
      {money=50,exp=100},
    },
    playernum=0
  },
  pvp = {
    type = "pvp",
    started=false,
    operated=false,
    maplist={"pvp1","pvp2","pvp3"},
    startpos={mapname="pvp1",pos={x=0,y=1.5,z=-100}},
    playpos={mapname="pvp1",pos={x=0,y=1.5,z=0}},
    reward={money=1000,exp=5000},
    playernum=0,
    playerneed=2,
    delaystart=20
  },
  helltower = {
    type="normal",
    --maplist={},
    startpos={mapname="hell1",pos={x=0,y=1.5,z=0}},
    reward={money=590,exp=1000},
    checkpointrewards={
      {money=590,exp=1000},
      {money=590,exp=1000},
      {money=590,exp=1000},
      {money=590,exp=1000},
      {money=590,exp=1000},
      {money=590,exp=1000},
      {money=590,exp=1000},
      {money=590,exp=1000},
      {money=590,exp=1000},
      {money=590,exp=1000},
      {money=590,exp=1000},
    },
    playernum=0
  }
}

--SCRIPT AREA
local function addexp(player,exp) --Add EXP To Player Function
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

local function addmoney(player,money)
  local cash = player:getValue("Money")
  player:setValue("Money",cash+money)
end

local function resetplayer(player) --Reset Player To Default
  local map = World.CurWorld:getMap(lobby.mapname)
  local pos = lobby.pos
  player:setMapPos(map,Vector3.new(pos.x,pos.y,pos.z),0,0)
  player:setRebirthPos(Vector3.new(pos.x,pos.y,pos.z),map)
  player:setData("Checkpoints",{})
  player:setData("Joining",nil)
  --player:setData("LastCheckpointName",nil)
  PackageHandlers.sendServerHandler(player,"ShowMainMenu")
end

local function roomnotification(maplist,showmode,content,duration)
  local _,mapid
  for _,mapid in pairs(maplist) do
    
    local map = World.CurWorld:getMap(mapid)
    local players = map.players
    
    local playerid,player
    for playerid,player in pairs(players) do
      player:sendTip(showmode,content,duration)
    end
    
  end
end

local function getroomplayers(maplist)
  local playerlist = {}
  local _,mapid
  for _,mapid in pairs(maplist)  do
    
    local map = World.CurWorld:getMap(mapid)
    local players = map.players
    local playerid,player
    for playerid,player in pairs(players) do
      playerlist[playerid] = player
    end
    
  end
  return playerlist
end

local function shutdownroom(roomkey)
  local players = getroomplayers(roomdata[roomkey].maplist)
  local playerid,player
  for playerid,player in pairs(players) do
    resetplayer(player)
  end
  roomdata[roomkey].started = false
  roomdata[roomkey].operated = false
end

local function startroom(roomkey)
  --Player Action
  local map = World.CurWorld:getMap(roomdata[roomkey].playpos.mapname)
  local pos = roomdata[roomkey].playpos.pos
  local players = getroomplayers(roomdata[roomkey].maplist)
  local playerid,player
  for playerid,player in pairs(players) do
    player:setMapPos(map,Vector3.new(pos.x,pos.y,pos.z),0,0)
    player:setRebirthPos(Vector3.new(pos.x,pos.y,pos.z),map)
    player:sendTip(1,"Game Started! KILLLL!!!",3)
  end
  
  --Game Action
  World.Timer(1,function()
      if roomdata[roomkey].started then
        if roomdata[roomkey].playernum < roomdata[roomkey].playerneed then
          roomnotification(roomdata[roomkey].maplist,1,"Not Enough Player To Operate This Room. Shutting Down...",3)
          World.Timer(60,function()
              shutdownroom(roomkey)
          end)
        end
        return true
      else
        return false
      end
  end)
end

local function operateroom(roomkey)
  if not roomdata[roomkey].operated then
    roomdata[roomkey].operated = true
    
    local second = 0
    World.Timer(20,function()
        --Wait To Start
        if second < roomdata[roomkey].delaystart then
          roomnotification(roomdata[roomkey].maplist,1,"Wait To Start: "..roomdata[roomkey].delaystart-second)
          second = second + 1
          print(second)
          return true
          
        --Started
        else
          --Check again if enough playerneed to start game
          if roomdata[roomkey].playernum >= roomdata[roomkey].playerneed then
            roomdata[roomkey].started = true
            roomnotification(roomdata[roomkey].maplist,1,"Game Started!",3)
            startroom(roomkey)
            
          --If Not
          else
            roomnotification(roomdata[roomkey].maplist,1,"Not Enough Player To Start This Game! Try Again Later!",3)
            shutdownroom(roomkey)
          end
          return false
        end
    end)
  end
end

local function countplayercheckpointsnum(player)
  local counter = 0
  local checkpoints = player:data("Checkpoints")
  if checkpoints then
    local i,v
    for i,v in pairs(checkpoints) do
      counter = counter + 1
    end
  end
  return counter
end

------------------------------------------------------------------------------------------

Trigger.addHandler(World.cfg,"GAME_START",function() --ROOM OPERATING
    World.Timer(1,function()
        local roomkey,data
        for roomkey,data in pairs(roomdata) do
          
          if data.type == "pvp" then
            --PLAYERNUM
            local _,mapid
            local playernum = 0
            for _,mapid in pairs(data.maplist) do
              
              local map = World.CurWorld:getMap(mapid)
              local players = map.players
              local playerid,player
              for playerid,player in pairs(players) do
                playernum = playernum + 1
              end
              
            end
            roomdata[roomkey].playernum = playernum
            
            --OPERATING
            if not roomdata[roomkey].operated then
              if roomdata[roomkey].playernum >= roomdata[roomkey].playerneed then
                operateroom(roomkey)
              else
                roomnotification(roomdata[roomkey].maplist,1,"Need At Least "..roomdata[roomkey].playerneed.." Players To Start Game!",3)
              end
            end
            
          end
        end
        return true
    end)
end)

local cfg = Entity.GetCfg("myplugin/player1")
Trigger.addHandler(cfg,"ENTITY_ENTER",function(context)
    --Make Sure Player's Values Reset
    local player = context.obj1
    resetplayer(player)
    
    --RoomMenuUpdate
    player:timer(1,function()
        local roommenuopen = player:data("RoomMenuOpen")
        if roommenuopen == true then
          PackageHandlers.sendServerHandler(player,"UpdateRoomMenu",roomdata)
        end
        return true
    end)
end)

Trigger.addHandler(cfg,"ENTITY_TOUCH_PART_BEGIN",function(context)
    local player = context.obj1
    local part = context.part
    
    --SAVE PLAYER'S LAST CHECKPOINT
    if part.name == "checkpoint" or part.name == "endmap" then
      player:setData("LastCheckpointName",part.name)
    end
    
    --CHECKPOINT
    if part.name == "checkpoint" then
      local checkpointlist = player:data("Checkpoints")
      --Check is player passed this checkpoint ?
      if not checkpointlist[part.id] then
        --Send a notification to player
        PackageHandlers.sendServerHandler(player,"CheckPointNotification")
        
        --Set Player's Rebirth Pos
        local map = player.map
        local pos = part:getPosition()
        player:setRebirthPos(Vector3.new(pos.x,pos.y+0.25,pos.z),map)
        
        --Add this part id to player's checkpoint history
        checkpointlist[part.id] = true
        player:setData("Checkpoints",checkpointlist)
        
        --Check if playing mode have CheckpointRewards
        local roomkey = player:data("Joining")
        if roomdata[roomkey].checkpointrewards then
          local checkpointnum = countplayercheckpointsnum(player)
          if roomdata[roomkey].checkpointrewards[checkpointnum] then
            PackageHandlers.sendServerHandler(player,"OpenRewardMenu",roomdata[roomkey].checkpointrewards[checkpointnum])
          end
        end
      end
      
    --ENDMAP
    elseif part.name == "endmap" then
      --SHOW MENU REWARD
      local roomkey = player:data("Joining")
      PackageHandlers.sendServerHandler(player,"OpenRewardMenu",roomdata[roomkey].reward)
      
      --IF THIS MAP IS PVP THEN
      if roomdata[roomkey].type == "pvp" then
        --Show notification to player who lose
        local players = getroomplayers(roomdata[roomkey].maplist)
        local playerid,playernow
        for playerid,playernow in pairs(players) do
          if playernow.platformUserId ~= player.platformUserId then
            playernow:sendTip(1,player.name.." Win!!!",10)
            PackageHandlers.sendServerHandler(playernow,"ShowLoseNotification")
          end
        end
        
        --Shutdown room
        World.Timer(20,function()
          shutdownroom(roomkey)
        end)
      end
    end
    
end)

------------------------------------------------------------------------------------------

PackageHandlers.registerServerHandler("PlayerJoinRoom",function(player,packet)
    --NORMAL TYPE
    if roomdata[packet.key].type == "normal" then
      --Show Notification to player "Joining..."
      player:sendTip(2,"Joining...",3)
      --Wait 1 seconds
      player:timer(20,function()
        --Hide Main Menu For Player
        PackageHandlers.sendServerHandler(player,"HideMainMenu")
        
        --Get Map And Start Pos
        local map = World.CurWorld:getMap(roomdata[packet.key].startpos.mapname)
        local pos = roomdata[packet.key].startpos.pos
        
        --Teleport Player To Map
        player:setMapPos(map,Vector3.new(pos.x,pos.y,pos.z))
        
        --Set Rebirth Pos for player
        player:setRebirthPos(Vector3.new(pos.x,pos.y,pos.z),map)
        
        --Set Player 'Joining' data
        player:setData("Joining",packet.key)
        
        --Add A "LoadingMap" Buff To Make Sure Player Won't Drop Down.
        player:addBuff("myplugin/loadingmap",20)
      end)
    --PVP TYPE
    elseif roomdata[packet.key].type == "pvp" then
      --ROOM STARTED FALSE
      if not roomdata[packet.key].started then
        --Send a notification to player
        player:sendTip(1,"Joining...",3)
        
        --Show LoadingScreen
        PackageHandlers.sendServerHandler(player,"ShowLoadingScreen",{duration=4,loadDone="Joining..."})
        
        --Delay 1s
        player:timer(20*5,function()
            --Hide Main Menu for Player
            PackageHandlers.sendServerHandler(player,"HideMainMenu")
            
            --Get Map And Start Pos
            local map = World.CurWorld:getMap(roomdata[packet.key].startpos.mapname)
            local pos = roomdata[packet.key].startpos.pos
            
            --Teleport Player To Map
            player:setMapPos(map,Vector3.new(pos.x,pos.y,pos.z),0,0)
            
            --Set Rebirth Pos For Player
            player:setRebirthPos(Vector3.new(pos.x,pos.y,pos.z),map)
            
            --Set Player 'Joining' data
            player:setData("Joining",packet.key)
        end)
        
      --ROOM STARTED TRUE
      else
        player:sendTip(1,"This Room Is Started, you can't enter now!",3)
      end
    end
end)

PackageHandlers.registerServerHandler("EarnReward",function(player,packet)
    local lastcheckpointname = player:data("LastCheckpointName")
    
    --ENDMAP
    if lastcheckpointname == "endmap" then
      --EXP
      if packet.exp ~= nil and packet.exp > 0 then
        addexp(player,packet.exp)
      end
      --Money
      if packet.money ~= nil and packet.money > 0 then
        addmoney(player,packet.money)
      end
      --Reset Player's Client
      resetplayer(player)
      
    --CHECKPOINT
    elseif lastcheckpointname == "checkpoint" then
      --EXP
      if packet.exp then
        addexp(player,packet.exp)
      end
      --MONEY
      if packet.money then
        addmoney(player,packet.money)
      end
      
    end
end)

PackageHandlers.registerServerHandler("PlayerOutRoom",function(player)
    resetplayer(player)
end)

PackageHandlers.registerServerHandler("RoomMenuOpened",function(player)
    player:setData("RoomMenuOpen",true)
end)

PackageHandlers.registerServerHandler("RoomMenuClosed",function(player)
    player:setData("RoomMenuOpen",false)
end)