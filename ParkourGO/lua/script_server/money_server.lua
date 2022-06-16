local cfg = Entity.GetCfg("myplugin/player1")
Trigger.addHandler(cfg,"ENTITY_ENTER",function(context)
    local player = context.obj1
    PackageHandlers.sendServerHandler(player,"OpenMoneyUI")
end)

PackageHandlers.registerServerHandler("MoneyUIOpen",function(player)
    player:timer(1,function()
        local cash = player:getValue("Money")
        PackageHandlers.sendServerHandler(player,"UpdateMoneyUI",{cash=cash})
        return true
    end)
end)

PackageHandlers.registerServerHandler("GenerateMoney",function(player)
    local cash = player:getValue("Money")
    player:setValue("Money",cash+1000000)
end)