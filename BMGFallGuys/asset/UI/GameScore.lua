
local redTeamScoreText = self:child("RedScore")
local blueTeamScoreText = self:child("BlueScore")

PackageHandlers.registerClientHandler("RefreshGameScore",function(player, data)
    
    redTeamScoreText:setText(data[1])
    blueTeamScoreText:setText(data[2])
end)