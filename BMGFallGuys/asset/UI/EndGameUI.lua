
--local function RefreshEndCard(teamPacket)
--  local redScores = teamPacket[1]
--  local blueScores = teamPacket[2]
--  local line, pname, pscore
  
--  for i=1, #redScores do
--    line = self:child("red"..i)
--    pname = redScores[i].name
--    pscore = redScores[i].score
--    line:setText(pname)
--    line.Score:setText(pscore)
--  end
  
--  for i=1, #blueScores do
--    line = self:child("blue"..i)
--    pname = blueScores[i].name
--    pscore = blueScores[i].score
--    line:setText(pname)
--    line.Score:setText(pscore)
--  end
  
--end

--PackageHandlers.registerClientHandler("EndGameEvent", function(player, packet)
--    RefreshEndCard(packet)
--end)