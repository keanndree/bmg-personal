PackageHandlers.registerClientHandler("CheckAndOpenSecondJump",function(player)
    local check = UI:isOpenWindow("secondjump")
    if not check then
      UI:openWindow("secondjump")
    end
end)

PackageHandlers.registerClientHandler("CheckAndCloseSecondJump",function(player)
    local check = UI:isOpenWindow("secondjump")
    if check then
      UI:closeWindow("secondjump")
    end
end)

PackageHandlers.registerClientHandler("MakePlayerJump",function(player)
    print("DoubleJump!!!")
    player:control():jump()
    --player:jump(0,0)
end)