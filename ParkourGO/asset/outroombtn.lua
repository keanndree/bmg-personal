local outroombtn = self:child("OutRoomBtn")
outroombtn.onMouseClick = function()
  local notification = self:child("Notification")
  notification:setVisible(true)
end

local yesbtn = self:child("YesBtn")
yesbtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("PlayerOutRoom")
  local notification = self:child("Notification")
  notification:setVisible(false)
end

local nobtn = self:child("NoBtn")
nobtn.onMouseClick = function()
  local notification = self:child("Notification")
  notification:setVisible(false)
end