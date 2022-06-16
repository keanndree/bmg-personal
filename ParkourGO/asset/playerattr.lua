--DATA AREA
local currency = "$"

--SCRIPT AREA
function self:onOpen()
  PackageHandlers.sendClientHandler("PlayerAttrUIOpened")
end

PackageHandlers.registerClientHandler("UpdatePlayerAttrUI",function(player,packet)
    local levelData = packet.level
    local moneyData = packet.money
    
    --Level Txt
    local leveltxt = self:child("LevelTxt")
    leveltxt:setProperty("Text","Level: "..levelData.level)
    
    --EXP Progress
    local expprogress = self:child("ExpProgress")
    if levelData.level < levelData.maxlevel then
      expprogress:setProgress(0)
      expprogress:setStepSize(1/levelData.expneed)
      if levelData.expnow > 0 then
        local i
        for i = 1,levelData.expnow do
          expprogress:step()
        end
      end
      expprogress.ExpTxt:setProperty("Text","EXP: "..levelData.expnow.."/"..levelData.expneed)
    else
      expprogress:setProgress(1)
      expprogress.ExpTxt:setProperty("Text","MAX")
    end
    
    --Money Txt
    local moneytxt = self:child("MoneyTxt")
    moneytxt:setProperty("Text",moneyData..currency)
    
end)