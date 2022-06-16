local backpackbtn = self:child('BackpackBtn')
backpackbtn.onMouseClick = function()
  UI:openWindow("backpack")
end

local upgradebtn = self:child('UpgradeBtn')
upgradebtn.onMouseClick = function()
  UI:openWindow("upgradelist")
end

local resetvaluebtn = self:child("ResetValueBtn")
resetvaluebtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("ResetValue")
end

local shopbtn = self:child("ShopBtn")
shopbtn.onMouseClick = function()
  UI:openWindow("shopmenu")
end