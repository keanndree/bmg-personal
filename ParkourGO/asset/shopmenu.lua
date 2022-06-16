--SPEEDBTN
local speedbtn = self:child("SpeedBtn")
speedbtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("SelectBuyAttribute",{type="speed"})
  UI:openWindow("shopitemmenu_data")
end

--SPRINGBTN
local springbtn = self:child("SpringBtn")
springbtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("SelectBuyAttribute",{type="spring"})
  UI:openWindow("shopitemmenu_data")
end

--GOLDENSPRINGBTN
local goldenspringbtn = self:child("GoldenSpringBtn")
goldenspringbtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("SelectBuyAttribute",{type="goldenspring"})
  UI:openWindow("shopitemmenu_data")
end

--SHIELD
local shieldbtn = self:child("ShieldBtn")
shieldbtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("SelectBuyAttribute",{type="shield"})
  UI:openWindow("shopitemmenu_data")
end

--SNIPER
local sniperbtn = self:child("SniperBtn")
sniperbtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("SelectBuyAttribute",{type="sniper"})
  UI:openWindow("shopitemmenu_data")
end

--CLOSEBTN
local closebtn = self:child("CloseBtn")
closebtn.onMouseClick = function()
  UI:closeWindow("shopmenu")
end