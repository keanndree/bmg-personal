print('script_client:hello world')
local Audio = require "script_client.audioMgr"
local tipWnd
World.Timer(10, function()
    --local guiMgr = GUIManager:Instance()
    tipWnd = UI:openWindow("Gui/tipWnd")
end)

local function getWnd(name,packet)
    local wnd = UI:isOpenWindow(name)
    if not wnd then
        wnd = UI:openWindow(name,name,'layouts',packet)
    end
    return wnd
end

PackageHandlers.registerClientHandler("OpenMatchingWnd", function(player, packet)
    UI:openWindow('Gui/matchingWnd')
end)

PackageHandlers.registerClientHandler("CloseMatchingWnd", function(player, packet)
    UI:closeWindow('Gui/matchingWnd')
end)

PackageHandlers.registerClientHandler("SetTip", function(player, packet)
    tipWnd:setTip(packet.txt, packet.time)
end)

PackageHandlers.registerClientHandler("SetCountdownImg", function(player, packet)
    tipWnd:setCountdownImg(packet.time)
    if packet.time == 3 then
        Audio.PlaySound('countdown')
    end
end)

PackageHandlers.registerClientHandler("CloseTip", function(player, packet)
    tipWnd:closeTip()
end)

PackageHandlers.registerClientHandler("SetGameTimer", function(player, packet)
    local playeringWnd = getWnd('Gui/playingWnd',packet)
    playeringWnd:setGameTimer(packet.time)
end)

PackageHandlers.registerClientHandler("SetCurPlayerSum", function(player, packet)
    local playeringWnd = getWnd('Gui/playingWnd',packet)
    playeringWnd:setCurPlayerSum(packet.playerSum)
end)

PackageHandlers.registerClientHandler("OpenWatchingWnd", function(player, packet)
    UI:openWindow('Gui/watchingWnd','Gui/watchingWnd','layouts',packet)
end)

PackageHandlers.registerClientHandler("PlayerFail", function(player, packet)
    UI:openWindow('Gui/failWnd','Gui/failWnd','layouts',packet)
    Audio.PlaySound('fail')
end)

PackageHandlers.registerClientHandler("PlayerWin", function(player, packet)
    UI:openWindow('Gui/winWnd','Gui/winWnd','layouts',packet)
    Audio.PlaySound('victory')
end)

PackageHandlers.registerClientHandler("GamePrepareStart", function(player, packet)
    local playeringWnd = getWnd('Gui/playingWnd',packet)
    playeringWnd:setCurPlayerSum(packet.playerSum)
    playeringWnd:setGameTimer(0)
end)

PackageHandlers.registerClientHandler("GameOver", function(player, packet)
    UI:closeWindow('Gui/playingWnd')
    UI:closeWindow('Gui/watchingWnd')
    UI:closeWindow('Gui/failWnd')
end)

PackageHandlers.registerClientHandler("PlayEffect", function(player, packet)
    Blockman.Instance():playEffectByPos(packet.effectName, packet.pos, packet.yaw, packet.time,packet.scale)
end)

PackageHandlers.registerClientHandler("playSound", function(player, packet)
    Audio.PlaySound(packet.soundName, packet.pos)
end)

PackageHandlers.registerClientHandler("playGlobalSound", function(player, packet)
    Audio.PlayGlobalSound(packet.soundName, packet.pos)
end)

PackageHandlers.registerClientHandler("stopSound", function(player, packet)
    Audio.StopSound(Audio.GetSoundIDByName(packet.soundName))
end)

PackageHandlers.registerClientHandler("EnterMap", function(player, packet)
    Audio.PlayMapSound(packet)
end)

PackageHandlers.registerClientHandler("PlayPartDisappearSound", function(player, packet)
    Audio.PlayPartDisappearSound(packet)
end)

