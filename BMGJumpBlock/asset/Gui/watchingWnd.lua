print("startup ui")
local Btn_last = self:child('Btn_last')
local Btn_next = self:child('Btn_next')
local Btn_return = self:child('Btn_return')
local watchingTb
local watchingIndex = 1

local function getNextPlayer()
    watchingIndex = (watchingIndex % #watchingTb) + 1
    local obj =  World.CurWorld:getObject(watchingTb[watchingIndex])
    if not obj or not obj:getValue('isValid') then
        return getNextPlayer()
    end
    return obj
end

local function getLastPlayer()
    watchingIndex = watchingIndex == 1 and #watchingTb or watchingIndex - 1
    local obj =  World.CurWorld:getObject(watchingTb[watchingIndex])
    if not obj or not obj:getValue('isValid') then
        return getLastPlayer()
    end
    return obj
end

local function setWatchingObj(obj)
    Blockman.Instance():setViewEntity(obj)
end

function self:onOpen(packet)
    self:setWatchingTb(packet)
    setWatchingObj(getNextPlayer())
end

function self:setWatchingTb(tb)
    watchingTb = tb
end

Btn_last.onMouseClick = function()
    setWatchingObj(getLastPlayer())
end

Btn_next.onMouseClick = function()
    setWatchingObj(getNextPlayer())
end

Btn_return.onMouseClick = function()
    PackageHandlers.sendClientHandler("PlayerExitRoom", {}, function(...)
        UI:closeWindow('Gui/watchingWnd')
        UI:closeWindow('Gui/playingWnd')
    end)
end