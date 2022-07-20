print('script_client:hello world')

local function RefreshEndCard(UIWindow, teamPacket)
  local redScores = teamPacket[1]
  local blueScores = teamPacket[2]
  local line, pname, pscore, winText
  
  for i=1, #redScores do
    line = UIWindow:child("red"..i)
    pname = redScores[i].name
    pscore = redScores[i].score
    line:setText(pname)
    line.score:setText(pscore)
  end
  
  for i=1, #blueScores do
    line = UIWindow:child("blue"..i)
    pname = blueScores[i].name
    pscore = blueScores[i].score
    line:setText(pname)
    line.score:setText(pscore)
  end
  
  winText = UIWindow:child("AnnounceText")
  if blueScores.totalDeath < redScores.totalDeath then

    winText:setText("BLUE WINS!")
  elseif blueScores.totalDeath > redScores.totalDeath then

    winText:setText("RED WINS!")
  else
    winText:setText("DRAW.")
  end
  
end

PackageHandlers.registerClientHandler("EndGameEvent", function(player, packet)
    local endWindow = UI:openWindow("UI/EndGameUI")
    print(packet)
    RefreshEndCard(endWindow, packet)
    
end)

PackageHandlers.registerClientHandler("TeamInitialization", function(player)
    UI:openWindow("UI/GameScore")
    UI:openWindow("UI/TimerPanel")
end)
