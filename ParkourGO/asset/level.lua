function self:onOpen()
  PackageHandlers.sendClientHandler("LevelUIOpened")
end

PackageHandlers.registerClientHandler("UpdateLevelUI",function(player,packet)
    if packet then
      --PROGRESS
      local progress = self:child("Progress")
      if packet.level < packet.maxlevel then
        progress:setProgress(0)
        progress:setStepSize(1/packet.expneed)
        if packet.expnow > 0 then
          local i
          for i = 1,packet.expnow do
            progress:step()
          end
        end
      else
        progress:setProgress(1)
      end
      
      --EXPTXT
      local exptxt = self:child("ExpTxt")
      if packet.level < packet.maxlevel then
        exptxt:setProperty("Text","EXP: "..packet.expnow.."/"..packet.expneed)
      else
        exptxt:setProperty("Text","MAX")
      end
      
      --LEVELTXT
      local leveltxt = self:child("LevelTxt")
      leveltxt:setProperty("Text","Level: "..packet.level)
    end
end)