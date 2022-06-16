print("UI 'reward': Started")
--[[local acceptbtn = self:child("AcceptBtn")
acceptbtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("EarnReward")
  UI:closeWindow("reward")
end]]