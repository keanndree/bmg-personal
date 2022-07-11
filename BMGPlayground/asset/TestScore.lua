local redTeamScoreText = self:child("score")

PackageHandlers.registerClientHandler("UpdateScore",function(player, data)
    
    redTeamScoreText:setText(data[1].." Blue ==== Red "..data[2])
end)