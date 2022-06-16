--DATA AREA
local itemFullName = {
  speed = {
    "myplugin/speedboots1",
    "myplugin/speedboots2",
    "myplugin/speedboots3",
    "myplugin/speedboots4",
    "myplugin/speedboots5"
  },
  spring = {
    "myplugin/spring1",
    "myplugin/spring2",
    "myplugin/spring3",
    "myplugin/spring4",
    "myplugin/spring5"
  },
  goldenspring = {
    "myplugin/goldenspring1",
    "myplugin/goldenspring2",
    "myplugin/goldenspring3",
    "myplugin/goldenspring4",
    "myplugin/goldenspring5"
  },
  shield = {
    "myplugin/shield1",
    "myplugin/shield2",
    "myplugin/shield3",
    "myplugin/shield4",
    "myplugin/shield5"
  },
  sniper = {
    "myplugin/sniper1",
    "myplugin/sniper2",
    "myplugin/sniper3",
    "myplugin/sniper4",
    "myplugin/sniper5"
  },
}

--SCRIPTAREA
PackageHandlers.registerServerHandler("SelectBuyAttribute",function(player,packet)
    player:setData("SelectingAttribute",packet.type)
end)

PackageHandlers.registerServerHandler("ShopItemMenuWithDataOpen",function(player)
    local selecting = player:data("SelectingAttribute")
    local data = player:getValue("ItemAttribute")
    data[selecting].type = selecting
    PackageHandlers.sendServerHandler(player,"UpdateShopItemMenuWithData",data[selecting])
end)

PackageHandlers.registerServerHandler("PurchaseItemWithData",function(player,packet)
    local selecting = player:data("SelectingAttribute")
    local data = player:getValue("ItemAttribute")
    local cash = player:getValue("Money")
    local cost = packet.cost[selecting][data[selecting].level]
    if cash >= cost then
      player:setValue("Money",cash-cost)
      local count = packet.count[selecting][data[selecting].level]
      --player:addItem(itemFullName[selecting][data[selecting].level],count)
      
      --GET BACKPACK
      local playertray = player:tray()
      local traylist = playertray:query_trays(function(tray)
          if tray:type() == 0 then
            return true
          end
      end)
      local _,tray,trayBp
      for _,tray in pairs(traylist) do
        if tray.tray:type() == 0 then
          trayBp = tray
        end
      end
      
      --GET ALL ITEMS IN BACKPACK
      local itemlist = trayBp.tray:query_items(function()
          return true
      end)
      
      --ADD ITEM TO BACKPACK
      local slot,item,newitem
      local enable = true
      for slot,item in pairs(itemlist) do
        if item:full_name() == itemFullName[selecting][data[selecting].level] and item:stack_count() < item:stack_count_max() then
          enable = false
          local stackCount = item:stack_count()
          local stackCountMax = item:stack_count_max()
          if stackCount + count < stackCountMax then
            item:set_stack_count(stackCount+count)
          else
            item:set_stack_count(stackCountMax)
            if count - (stackCountMax - stackCount) > 0 then
              newitem = Item.new(itemFullName[selecting][data[selecting].level],count-(stackCountMax-stackCount))
              local freeslot = trayBp.tray:find_free()
              trayBp.tray:settle_item(freeslot,newitem)
            end
          end
        end
      end
      
      if enable then
        local item = Item.new(itemFullName[selecting][data[selecting].level],count)
        local freeslot = trayBp.tray:find_free()
        trayBp.tray:settle_item(freeslot,item)
      end
      
      player:sendTip(1,"Purchased Successfully!",3)
    else
      player:sendTip(1,"You're not enough money to buy this item!",3)
    end
  end)