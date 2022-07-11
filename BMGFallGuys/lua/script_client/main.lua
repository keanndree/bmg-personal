print('script_client:hello world')

PackageHandlers.registerClientHandler("TeamInitialization", function(player)
    UI:openWindow("UI/GameScore")
    UI:openWindow("UI/TimerPanel")
end)
