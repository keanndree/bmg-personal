print("startup ui")
local Txt_name = self:child('Txt_name')
local Txt_survivalTime = self:child('Txt_survivalTime')
local Txt_nameTitel = self:child('Txt_nameTitel')
local Btn_return = self:child('Btn_return')

function self:onOpen(packet)
    Txt_name:setText(packet.name)
    Txt_survivalTime:setText(Lang:toText('LangKey_winPlayerSurvivalTime')..packet.time)
    Txt_nameTitel:setText(Lang:toText('LangKey_nameTitel'))
    Btn_return.Text:setText(Lang:toText('LangKey_exitGame'))
end

Btn_return.onMouseClick = function()
    PackageHandlers.sendClientHandler("PlayerExitRoom", {}, function(...)
        UI:closeWindow('Gui/winWnd')
    end)
end