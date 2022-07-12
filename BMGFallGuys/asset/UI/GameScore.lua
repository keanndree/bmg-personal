local isPlaying = true
local redTeamScoreText = self:child("RedScore")
local blueTeamScoreText = self:child("BlueScore")

local gameTimeText = self:child("TimeText")

PackageHandlers.registerClientHandler("RefreshGameScore",function(player, data)
    if isPlaying then
      redTeamScoreText:setText(data[1])
      blueTeamScoreText:setText(data[2])
    end
    
end)

PackageHandlers.registerClientHandler("GameTimeHandler", function(player, data)

    gameTimeText:setText("Time Left : "..tostring(data[1]))
end)

PackageHandlers.registerClientHandler("GameOverEvent",function(player)
    isPlaying = false
end)