--SPEEDBTN
local speedbtn = self:child("SpeedBtn")
speedbtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("SelectUpgradeAttribute",{type="speed"})
  UI:openWindow("upgrademenu")
end

--SPRINGBTN
local springbtn = self:child("SpringBtn")
springbtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("SelectUpgradeAttribute",{type="spring"})
  UI:openWindow("upgrademenu")
end

--GOLDENSPRINGBTN
local goldenspringbtn = self:child("GoldenSpringBtn")
goldenspringbtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("SelectUpgradeAttribute",{type="goldenspring"})
  UI:openWindow("upgrademenu")
end

--SHIELDBTN
local shieldbtn = self:child("ShieldBtn")
shieldbtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("SelectUpgradeAttribute",{type="shield"})
  UI:openWindow("upgrademenu")
end

--SNIPERBTN
local sniperbtn = self:child("SniperBtn")
sniperbtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("SelectUpgradeAttribute",{type="sniper"})
  UI:openWindow("upgrademenu")
end

--CLOSEBTN
local closebtn = self:child("CloseBtn")
closebtn.onMouseClick = function()
  UI:closeWindow("upgradelist")
end