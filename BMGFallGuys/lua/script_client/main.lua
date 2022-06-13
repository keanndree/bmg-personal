print('script_client:hello world')

local GameWindow = UI:openWindow('UI/CurrentGameInfo')

PackageHandlers.registerClientHandler("RefreshQualifiedPlayers", function(player, packet)
    GameWindow:RefreshQualifiedText(packet)
end)