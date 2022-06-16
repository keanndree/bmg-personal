local secondjumpbtn =  self:child("SecondJumpBtn")
secondjumpbtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("SecondJumpClicked")
end