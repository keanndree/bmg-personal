PackageHandlers.registerClientHandler("ReopenBackpack",function(player)
    UI:closeWindow("backpack")
    UI:openWindow("backpack")
end)

PackageHandlers.registerClientHandler("ReopenHandBag",function(player)
    UI:closeWindow("backpack")
    UI:openWindow("backpack")
    
    UI:closeWindow("handbag")
    UI:openWindow("handbag")
end)