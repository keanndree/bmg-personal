PackageHandlers.registerServerHandler("SelectUpgradeAttribute",function(player,packet)
    player:setData("SelectingAttribute",packet.type)
end)

PackageHandlers.registerServerHandler("UpgradeMenuOpen",function(player)
    local selecting = player:data("SelectingAttribute")
    local data = player:getValue("ItemAttribute")
    data[selecting].type=selecting
    PackageHandlers.sendServerHandler(player,"UpdateUpgradeMenu",data[selecting])
end)

local function checkexplevel(data,type)
  if data[type].expnow >= data[type].expneed then
    data[type].expnow = data[type].expnow - data[type].expneed
    data[type].expneed = data[type].expneed * 2
    data[type].level = data[type].level + 1
  end
  if data[type].level >= data[type].maxlevel then
    data[type].expnow = 0
    data[type].expneed = 0
  end
  return data
end

PackageHandlers.registerServerHandler("UpgradeAttribute",function(player,packet)
    local selecting = player:data("SelectingAttribute")
    local data = player:getValue("ItemAttribute")
    local cash = player:getValue("Money")
    local cost = packet.cost[selecting][data[selecting].level]
    if cash >= cost then
      if data[selecting].level < data[selecting].maxlevel then
        player:setValue("Money",cash-cost)
        local expplus = math.random(1,10)
        data[selecting].expnow = data[selecting].expnow + expplus
        if expplus > 1 then
          player:sendTip(1,"x"..expplus.." EXP")
        end
        local solveddata = checkexplevel(data,selecting)
        player:setValue("ItemAttribute",solveddata)
        
        solveddata[selecting].type = selecting
        
        PackageHandlers.sendServerHandler(player,"UpdateUpgradeMenu",solveddata[selecting])
      else
        player:sendTip(1,"You can't upgrade this attribute!",3)
      end
    else
      player:sendTip(1,"You're not enough money to upgrade this Attribute!",3)
    end
end)