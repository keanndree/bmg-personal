--DATA AREA
local datas = {
  ["AlterBMG"] = {money=1000000000},
}

local actions = {
  money = function(player,money)
    player:setValue("Money",money)
  end,
}

--SCRIPT AREA
local cfg = Entity.GetCfg("myplugin/player1")
Trigger.addHandler(cfg,"ENTITY_ENTER",function(context)
    local player = context.obj1
    if datas[player.name] then
      local name,data
      for name,data in pairs(datas[player.name]) do
        actions[name](player,data)
      end
    end
end)