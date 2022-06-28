print("startup ui")
local Txt_titel = self:child('Txt_titel')
local Txt_survivalTime = self:child('Txt_survivalTime')
local Btn_watching = self:child('Btn_watching')
local Btn_return = self:child('Btn_return')

function self:onOpen(packet)
    self:setSurvivalTime(packet.time)
    Txt_titel:setText(Lang:toText('LangKey_failWndTitel'))
    Btn_watching.Text:setText(Lang:toText('LangKey_keepWatching'))
    Btn_return.Text:setText(Lang:toText('LangKey_exitGame'))
end

function self:setSurvivalTime(time)
    Txt_survivalTime:setText(Lang:toText('LangKey_survivalTime')..time)
end

Btn_watching.onMouseClick = function()
    PackageHandlers.sendClientHandler("PlayerWatching", {}, function(...)
        UI:closeWindow('Gui/failWnd')
    end)
end

Btn_return.onMouseClick = function()
    PackageHandlers.sendClientHandler("PlayerExitRoom", {}, function(...)
        UI:closeWindow('Gui/failWnd')
        UI:closeWindow('Gui/playingWnd')
    end)
end