PackageHandlers.registerServerHandler("ResetValue",function(player)
    player:setValue("ItemAttribute",{
    speed={level=1,maxlevel=5,expnow=0,expneed=50},
    spring={level=1,maxlevel=5,expnow=0,expneed=50},
    goldenspring={level=1,maxlevel=5,expnow=0,expneed=50},
    shield={level=1,maxlevel=5,expnow=0,expneed=50},
    sniper={level=1,maxlevel=5,expnow=0,expneed=50}
  })
  player:sendTip(1,"Reset Value Successfully!",3)
end)