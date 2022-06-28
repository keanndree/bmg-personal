local gameSettingData = require "script_common.gameSettingData"

local randomIndex = 1

local function getRandomSum(min, max)
    randomIndex = randomIndex > 100 and 1 or randomIndex + 1
    local index = os.time() + randomIndex
    math.randomseed(tostring(index):reverse():sub(1, 7))
    local n = math.random(min, max)
    return n
end

local function getSpawnPos(part)
    return part:getPosition() + gameSettingData.spawnPosOffset
end

local function getRandomSpawnPos(partArr)
    local index = getRandomSum(1, #partArr)
    local part = partArr[index]
    table.remove(partArr, index)
    return getSpawnPos(part)
end

local function spawnPlayer(map, playerList, playerCount)
    local SpawnPosFolder = map:getWorkSpace():findFirstChild("SpawnPos")
    if not SpawnPosFolder then
        World.Timer(1, function()
            spawnPlayer(map, playerList, playerCount)
        end)
        return
    end

    local childCount = SpawnPosFolder:getChildrenCount()
    if playerCount > childCount then
        local index = 0
        for i, player in pairs(playerList) do
            player:setMapPos(map, getSpawnPos(SpawnPosFolder:getChildAt(index)))
            index = (index + 1) % childCount
        end
    else
        local partArr = {}
        for i = 1, childCount do
            table.insert(partArr, SpawnPosFolder:getChildAt(i - 1))
        end
        for i, player in pairs(playerList) do
            player:setMapPos(map, getRandomSpawnPos(partArr))
        end
    end
end

Lib.subscribeEvent('GamePrepareStart', function(playerList, mapName, playerCount)
    local dynamicMap = World.CurWorld:createDynamicMap(mapName, true)
    spawnPlayer(dynamicMap, playerList, playerCount)
end)

Lib.subscribeEvent('GameStart', function(playerList)
    local map
    for i, player in pairs(playerList) do
        map = player.map
    end
    local workSpace = map:getWorkSpace()
    local Baffle = workSpace:findFirstChild('Baffle')
    Baffle:destroy()
end)