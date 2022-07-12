local timerWindow = self:child("TimerWindow")
local timerText = self:child("TimerText")

PackageHandlers.registerClientHandler("StartTimerHandler", function(player, gameStartTimeData)

    timerText:setText(tostring(gameStartTimeData[1]))
    
    if gameStartTimeData[1] <= 0 then
      timerWindow:setVisible(false)
    end
end)