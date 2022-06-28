local gameSettingData = require "script_common.gameSettingData"
local partCtrl = {}

local function getEffectData(pos,name)
    local effect = Lib.copy(gameSettingData[name])
    effect.pos = effect.offect + pos
    return effect
end

function partCtrl.Entrance_Begin(player, part, nameData)
    local mapName = nameData[1]
    if mapName == 'random' then
        local randomMapTb = gameSettingData.randomMapTb
        math.randomseed(os.time())
        local n = math.random(1, #randomMapTb)
        mapName = randomMapTb[n]
    end
    Lib.emitEvent('PlayerTouchMapEntrance', player, mapName)
end

function partCtrl.Eliminate_Begin(player, part, nameData)
    Lib.emitEvent('EliminatePlayer', player, nameData[1])
end

function partCtrl.Block_Begin(player, part, nameData)
    if part.effect then
        return
    end
    part.effect = getEffectData(part:getPosition(),'blockEffect')
    PackageHandlers.sendServerHandlerToTracking(player, "PlayEffect", part.effect, true)
    PackageHandlers.sendServerHandler(player, 'PlayPartDisappearSound', { pos = part:getPosition() })
end

function partCtrl.Disappear_Begin(player, part, nameData)
    local context = {ok = true,player = player}
    Lib.emitEvent('PreCheckDisappearPart', context)
    if part.timer or not context.ok then
        return
    end
    local time = 20
    local target = 0.2
    local detailValue = (0.9 - target) / time
    part:setProperty('materialAlpha', 0.9)
    PackageHandlers.sendServerHandler(player, 'PlayPartDisappearSound', { pos = part:getPosition() })
    PackageHandlers.sendServerHandlerToTracking(player, "PlayEffect", getEffectData(part:getPosition(),'disappearEffect'), true)
    part.timer = World.Timer(1, function()
        if not part:isValid() then
            return
        end
        time = time - 1
        if time <= 0 then
            part:destroy()
            return
        end
        part:setProperty('materialAlpha', part:getProperty('materialAlpha') - detailValue)
        for i = 1, part:getChildrenCount() do
            local decal = part:getChildAt(i - 1)
            decal:setProperty('decalAlpha', part:getProperty('materialAlpha'))
        end
        return true
    end)
end

Lib.subscribeEvent("PlayerTouchPartBegin", function(player, part, nameData)
    if #nameData > 1 then
        local eventName = nameData[#nameData] .. '_Begin'
        local useless = partCtrl[eventName] and partCtrl[eventName](player, part, nameData)
    end
end)

Lib.subscribeEvent("PlayerTouchPartEnd", function(player, part, nameData)
    if #nameData > 1 then
        local eventName = nameData[#nameData] .. '_End'
        local useless = partCtrl[eventName] and partCtrl[eventName](player, part, nameData)
    end
end)

 