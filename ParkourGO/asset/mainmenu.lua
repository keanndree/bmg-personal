PackageHandlers.registerClientHandler("HideMainMenu",function(player)
    if self:isVisible() then
      self:setVisible(false)
    end
end)

PackageHandlers.registerClientHandler("ShowMainMenu",function(player)
    if not self:isVisible() then
      self:setVisible(true)
    end
end)

local runbtn = self:child("RunBtn")
runbtn.onMouseClick = function()
  UI:openWindow("roommenu")
end

local shopbtn = self:child("ShopBtn")
shopbtn.onMouseClick = function()
  UI:openWindow("shopmenu")
end

local upgradebtn = self:child("UpgradeBtn")
upgradebtn.onMouseClick = function()
  UI:openWindow("upgradelist")
end

local loadoutbtn = self:child("LoadOutBtn")
loadoutbtn.onMouseClick = function()
  UI:openWindow("backpack")
end