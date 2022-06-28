print("startup ui")

local Btn_cancel = self:child('Btn_cancel')
local Txt_info = self:child('Txt_info')

function self:onOpen()
    Txt_info:setText(Lang:toText('LangKey_matchingInfo'))
    Btn_cancel.Text:setText(Lang:toText('LangKey_cancelMatch'))
end

Btn_cancel.onMouseClick = function()
    PackageHandlers.sendClientHandler("ExitMatching", {}, function(...)
        UI:closeWindow('Gui/matchingWnd')
    end)
end