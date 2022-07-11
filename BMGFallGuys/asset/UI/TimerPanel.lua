
local timerText = self:child("TimerText")

local gameStartTime
PackageHandlers.registerClientHandler("StartTimerHandler", function(player, gameStartTimeData)
    gameStartTime = gameStartTimeData[1]
end)