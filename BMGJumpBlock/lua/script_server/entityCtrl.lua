local gameSettingData = require "script_common.gameSettingData"

local playerCfg = Entity.GetCfg('myplugin/player1')
local defaultJumpSpeed
local defaultMoveSpeed
local defaultGravity

local function limitPlayerOper(player)
    player:setProp("moveFactor",0)
    player:setProp("jumpSpeed",0)
    player:setProp("gravity",0)
end

local function recoverPlayerOper(player)
    player:setProp("moveFactor",defaultMoveSpeed)
    player:setProp("jumpSpeed",defaultJumpSpeed)
    player:setProp("gravity",defaultGravity)
end

local function splitSpacing(name)
    local str = Lib.splitString(name, " ")
    local new = ''
    for i, v in ipairs(str) do
        new = new..v
    end
    return new
end

Trigger.RegisterHandler(playerCfg, "ENTITY_TOUCH_PART_BEGIN", function(context)
    local player = context.obj1
    local part = context.part
    local partName = splitSpacing(part.name)
    local nameData = Lib.splitString(partName, "_")
    Lib.emitEvent('PlayerTouchPartBegin', player,part, nameData)
end)

Trigger.RegisterHandler(playerCfg, "ENTITY_TOUCH_PART_END", function(context)
    local player = context.obj1
    local part = context.part
    local partName = splitSpacing(part.name)
    local nameData = Lib.splitString(partName, "_")
    Lib.emitEvent('PlayerTouchPartEnd', player,part, nameData)
end)

Trigger.RegisterHandler(playerCfg, "ENTER_MAP", function(context)
    local player = context.obj1
    PackageHandlers.sendServerHandler(player, "EnterMap", {mapName = player.map.name})
end)

Trigger.RegisterHandler(playerCfg, "ENTITY_ENTER", function(context)
    local player = context.obj1
    defaultMoveSpeed = player:prop("moveFactor")
    defaultJumpSpeed = player:prop("jumpSpeed")
    defaultGravity = player:prop("gravity")
end)

Trigger.RegisterHandler(playerCfg, "ENTITY_LEAVE", function(context)
    local player = context.obj1
    Lib.emitEvent('PlayerExitGame', player)
end)

Lib.subscribeEvent('PlayerExitRoom', function(player)
    recoverPlayerOper(player)
    player:serverRebirth()
end)

Lib.subscribeEvent('LimitPlayerOper', function(player)
    limitPlayerOper(player)
end)

Lib.subscribeEvent('EliminatePlayer', function(player)
    limitPlayerOper(player)
end)


