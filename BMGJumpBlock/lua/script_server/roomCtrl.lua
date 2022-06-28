local gameSettingData = require "script_common.gameSettingData"
local index = 1

local roomCtrl = {}

local STATE = {
    WAIT = 1,
    PREPARE = 2,
    START = 3,
    GAMEOVER = 4
}

local function getNextRoomIndex()
    index = index > 10000 and 1 or index + 1
    return index
end

local baseRoom = {
    playerSum = 0,
    state = STATE.WAIT
}

function baseRoom:broadcast(eventName, packet)
    for i, player in pairs(self.playerList) do
        PackageHandlers.sendServerHandler(player, eventName, packet)
    end
end

function baseRoom:validPlayerSum()
    local num = 0
    for i, player in pairs(self.playerList) do
        num = player:getValue('isValid') and num + 1 or num
    end
    return num
end

function baseRoom:calcTime()
    local startTime = self.startTime and self.startTime or 0
    local curTime = World.Now()
    return math.floor((curTime - startTime) / (20))
end

function baseRoom:EliminatedPlayer(player)
    player:setValue('isValid', false)
    local time = self:calcTime()
    self:broadcast('SetCurPlayerSum', { playerSum = self:validPlayerSum() })
    PackageHandlers.sendServerHandler(player, 'PlayerFail', { time = time })
    self:canGameOver()
end

function baseRoom:canGameOver()
    if self:validPlayerSum() <= 1 then
        self:gameOver()
        return true
    end
end

function baseRoom:playerExitRoom(player)
    self.playerList[player.objID] = nil
    player:setValue('roomIndex', 0)
    self.playerSum = self.playerSum - 1
    if self.state == STATE.PREPARE and self.playerSum < gameSettingData.minPlayerSum then
        self.prepareTimer()
        self.state = STATE.WAIT
        self:broadcast("OpenMatchingWnd")
        self:broadcast("CloseTip")
    elseif self.state == STATE.START then
        self:canGameOver()
    end

    if self.state == STATE.GAMEOVER then
        if self.playerSum == 0 then
            roomCtrl.playingRoomList[self.index] = nil
        end
    end
end

function baseRoom:playerEnterRoom(player)
    player:setValue('roomIndex', self.index)
    player:setValue('isValid', true)
    self.playerList[player.objID] = player
    self.playerSum = self.playerSum + 1
    if self.state == STATE.WAIT and self.playerSum == gameSettingData.minPlayerSum then
        self:gamePrepare()
    elseif self.state == STATE.WAIT then
        PackageHandlers.sendServerHandler(player, "OpenMatchingWnd")
    end
    return true
end

function baseRoom:gamePrepare()
    self.state = STATE.PREPARE
    local time = gameSettingData.gamePrepareTime
    self:broadcast("CloseMatchingWnd")
    self:broadcast("SetTip", { txt = "langkey_prepareEnterMap", time = time })
    self.prepareTimer = World.Timer(20, function(room)
        self:broadcast("SetTip", { txt = "langkey_prepareEnterMap", time = time })
        time = time - 1
        if time <= 0 then
            room:gamePrepareStart()
            return
        end
        return true
    end, self)
end

function baseRoom:gamePrepareStart()
    self.state = STATE.START
    roomCtrl.SwitchRoomList(self)
    Lib.emitEvent('GamePrepareStart', self.playerList, self.mapName, self.playerSum)
    self:broadcast('GamePrepareStart', { playerSum = self.playerSum })
    local time = gameSettingData.gameWaitStartTime
    self:broadcast('SetTip', { txt = "langkey_prepareStartGame"})
    World.Timer(20, function()
        if self:isGameOver() then
            return
        end
        time = time - 1
        self:broadcast('SetCountdownImg', { time = time})
        if time < 0 then
            self:gameStart()
            return
        end
        return 20
    end, self)
end

function baseRoom:gameStart()
    self.startTime = World.Now()
    Lib.emitEvent('GameStart', self.playerList)
end

function baseRoom:gameOver()
    local time = self:calcTime()
    local winner
    self.startTime = nil
    for i, player in pairs(self.playerList) do
        if player:getValue('isValid') then
            winner = player
        end
    end
    Lib.emitEvent('LimitPlayerOper', winner)
    self:broadcast('PlayerWin', { time = time, name = winner.name })
    self:broadcast('GameOver')
    self.state = STATE.GAMEOVER
end

function baseRoom:isGameOver()
    return self.state == STATE.GAMEOVER
end

function baseRoom:setMapName(mapName)
    self.mapName = mapName
end

function baseRoom:getPlayerList()
    return self.playerList
end

roomCtrl.roomList = {}
roomCtrl.playingRoomList = {}

function roomCtrl.CreateRoom(player, mapName)
    local room = Lib.derive(baseRoom)
    room.playerList = {}
    local roomIndex = getNextRoomIndex()
    room.index = roomIndex
    room.mapName = mapName
    room:playerEnterRoom(player)
    roomCtrl.roomList[roomIndex] = room
end

function roomCtrl.SwitchRoomList(room)
    local roomIndex = room.index
    roomCtrl.roomList[roomIndex] = nil
    roomCtrl.playingRoomList[roomIndex] = room
end

function roomCtrl.PlayerEnter(player, mapName)
    local result
    for i, room in pairs(roomCtrl.roomList) do
        if room.mapName == mapName and room.playerSum ~= gameSettingData.maxPlayerSum then
            result = room:playerEnterRoom(player)
            goto continue
        end
    end
    :: continue ::
    local useless = not result and roomCtrl.CreateRoom(player, mapName)
end

function roomCtrl.GetRoom(index)
    local room = roomCtrl.roomList[index] or roomCtrl.playingRoomList[index]
    return room or print("Error:The room does not exist")
end

Lib.subscribeEvent('PlayerTouchMapEntrance', function(player, mapName)
    if player:getValue('roomIndex') == 0 then
        roomCtrl.PlayerEnter(player, mapName)
    end
end)

local function playerExitRoomCheck(player)
    local roomIndex = player:getValue('roomIndex')
    if roomIndex ~= 0 then
        local room = roomCtrl.GetRoom(roomIndex)
        room:playerExitRoom(player)
    end
end

Lib.subscribeEvent('PlayerExitGame', function(player)
    playerExitRoomCheck(player)
end)

Lib.subscribeEvent('EliminatePlayer', function(player)
    local room = roomCtrl.GetRoom(player:getValue('roomIndex'))
    if room:isGameOver() then
        return
    end
    room:EliminatedPlayer(player)
end)

Lib.subscribeEvent('PreCheckDisappearPart', function(context)
    local room = roomCtrl.GetRoom(context.player:getValue('roomIndex'))
    if not room then
        return
    end
    context.ok = not room:isGameOver()
end)

PackageHandlers.registerServerHandler("ExitMatching", function(player, packet)
    playerExitRoomCheck(player)
end)

PackageHandlers.registerServerHandler("PlayerExitRoom", function(player, packet)
    playerExitRoomCheck(player)
    Lib.emitEvent('PlayerExitRoom', player)
end)

PackageHandlers.registerServerHandler("PlayerWatching", function(player, packet)
    local objTb = {}
    local room = roomCtrl.GetRoom(player:getValue('roomIndex'))
    for i, player in pairs(room.playerList) do
        table.insert(objTb, player.objID)
    end
    PackageHandlers.sendServerHandler(player, "OpenWatchingWnd", objTb)
end)

World.Timer(1, function()
    local curTime = World.Now()
    for i, room in pairs(roomCtrl.playingRoomList) do
        local startTime = room.startTime
        if startTime and (curTime - startTime) % (20) == 0 then
            local time = room:calcTime()
            room:broadcast('SetGameTimer', { time = time })
        end
    end
    return true
end)
