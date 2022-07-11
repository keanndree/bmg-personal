

local joinBtn = self:child("JoinBtn")
joinBtn.onMouseClick = function()
  
  UI:closeWindow("UI/MainMenu")
  --PackageHandlers.sendClientHandler("JoinGameHandler")
end