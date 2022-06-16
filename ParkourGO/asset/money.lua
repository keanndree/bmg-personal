--DATA AREA
local currency = "$"

--SCRIPT AREA
function self:onOpen()
  PackageHandlers.sendClientHandler("MoneyUIOpen")
end

PackageHandlers.registerClientHandler("UpdateMoneyUI",function(player,packet)
    --CashTxt
    local cashtxt = self:child("CashTxt")
    cashtxt:setProperty("Text",packet.cash..currency)
end)

local generatebtn = self:child("GenerateBtn")
generatebtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("GenerateMoney")
end