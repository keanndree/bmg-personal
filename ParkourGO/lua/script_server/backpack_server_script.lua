PackageHandlers.registerServerHandler("BackpackOpen",function(player)
    PackageHandlers.sendServerHandler(player,"UpdateBackpack")
end)

PackageHandlers.registerServerHandler("HandBagOpen",function(player)
    PackageHandlers.sendServerHandler(player,"UpdateHandBag")
end)

PackageHandlers.registerServerHandler("SaveCurBpSlot",function(player,packet)
    player:setData("CurBpSlot",packet.slot)
end)

PackageHandlers.registerServerHandler("SaveCurHbSlot",function(player,packet)
    player:setData("CurHbSlot",packet.slot)
end)

PackageHandlers.registerServerHandler("WithdrawItem",function(player,packet)
    local playertray = player:tray()
    local traylist = playertray:query_trays(function(tray)
        if tray:type() == 0 or tray:type() == 20 then
          return true
        end
    end)
    
    local _,tray,trayBp,trayHb
    for _,tray in pairs(traylist) do
      if tray.tray:type() == 0 then
        trayBp = tray
      else
        trayHb = tray
      end
    end
    
    --BACKPACK
    local curbpslot = player:data("CurBpSlot")
    local item = trayBp.tray:fetch_item(curbpslot)
    trayBp.tray:remove_item(curbpslot)
    
    --HANDBAG
    local curhbslot = player:data("CurHbSlot")
    trayHb.tray:settle_item(curhbslot,item)
    
    --UPDATEBACKPACK
    PackageHandlers.sendServerHandler(player,"ReopenBackpack")
end)

PackageHandlers.registerServerHandler("RemoveItemFromHandBag",function(player,packet)
    local playertray = player:tray()
    local traylist = playertray:query_trays(function(tray)
        if tray:type() == 0 or tray:type() == 20 then
          return true
        end
    end)
    
    local _,tray,trayBp,trayHb
    for _,tray in pairs(traylist) do
      if tray.tray:type() == 0 then
        trayBp = tray
      else
        trayHb = tray
      end
    end
    
    --HANDBAG
    local item = trayHb.tray:fetch_item(packet.slot)
    trayHb.tray:remove_item(packet.slot)
    
    --BACKPACK
    local freeslot = trayBp.tray:find_free()
    trayBp.tray:settle_item(freeslot,item)
    
    PackageHandlers.sendServerHandler(player,"ReopenHandBag")
end)