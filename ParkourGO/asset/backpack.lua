--DATA AREA
local numSlots = 54
local itemFramePath = {
  --Level 1 Item Frame
  ["myplugin/speedboots1"]="gameres|asset/Texture/UI/GrayItemFrame.png",
  ["myplugin/spring1"]="gameres|asset/Texture/UI/GrayItemFrame.png",
  ["myplugin/goldenspring1"]="gameres|asset/Texture/UI/GrayItemFrame.png",
  ["myplugin/shield1"]="gameres|asset/Texture/UI/GrayItemFrame.png",
  ["myplugin/sniper1"]="gameres|asset/Texture/UI/GrayItemFrame.png",
  --Level 2 Item Frame
  ["myplugin/speedboots2"]="gameres|asset/Texture/UI/GreenItemFrame.png",
  ["myplugin/spring2"]="gameres|asset/Texture/UI/GreenItemFrame.png",
  ["myplugin/goldenspring2"]="gameres|asset/Texture/UI/GreenItemFrame.png",
  ["myplugin/shield2"]="gameres|asset/Texture/UI/GreenItemFrame.png",
  ["myplugin/sniper2"]="gameres|asset/Texture/UI/GreenItemFrame.png",
  --Level 3 Item Frame
  ["myplugin/speedboots3"]="gameres|asset/Texture/UI/BlueItemFrame.png",
  ["myplugin/spring3"]="gameres|asset/Texture/UI/BlueItemFrame.png",
  ["myplugin/goldenspring3"]="gameres|asset/Texture/UI/BlueItemFrame.png",
  ["myplugin/shield3"]="gameres|asset/Texture/UI/BlueItemFrame.png",
  ["myplugin/sniper3"]="gameres|asset/Texture/UI/BlueItemFrame.png",
  --Level 4 Item Frame
  ["myplugin/speedboots4"]="gameres|asset/Texture/UI/PurpleItemFrame.png",
  ["myplugin/spring4"]="gameres|asset/Texture/UI/PurpleItemFrame.png",
  ["myplugin/goldenspring4"]="gameres|asset/Texture/UI/PurpleItemFrame.png",
  ["myplugin/shield4"]="gameres|asset/Texture/UI/PurpleItemFrame.png",
  ["myplugin/sniper4"]="gameres|asset/Texture/UI/PurpleItemFrame.png",
  --Level 5 Item Frame
  ["myplugin/speedboots5"]="gameres|asset/Texture/UI/GoldenItemFrame.png",
  ["myplugin/spring5"]="gameres|asset/Texture/UI/GoldenItemFrame.png",
  ["myplugin/goldenspring5"]="gameres|asset/Texture/UI/GoldenItemFrame.png",
  ["myplugin/shield5"]="gameres|asset/Texture/UI/GoldenItemFrame.png",
  ["myplugin/sniper5"]="gameres|asset/Texture/UI/GoldenItemFrame.png",
}

--SCRIPT AREA
function self:onOpen(player)
  PackageHandlers.sendClientHandler("BackpackOpen")
end

PackageHandlers.registerClientHandler("UpdateBackpack",function(player)
    local playertray = player:tray()
    local traylist = playertray:query_trays(function(tray)
        if tray:type() == 0 then
          return true
        end
    end)
    local _,tray,itemlist
    for _,tray in pairs(traylist) do
      itemlist = tray.tray:query_items(function()
          return true
      end)
    end
    local slot,item
    for slot,item in pairs(itemlist) do
      local bpslot = self:child("Slot"..slot)
      --Item Frame
      if itemFramePath[item:full_name()] ~= nil then
        bpslot.Frame:setImage(itemFramePath[item:full_name()])
      end
      
      --Item Icon
      bpslot.Frame.Image:setVisible(true)
      local iconPath = item:icon()
      bpslot.Frame.Image:setImage("gameres|"..iconPath)
      
      --Item Num
      local itemNum = item:stack_count()
      local itemnumtxt = bpslot.Frame.ItemNumTxt
      itemnumtxt:setVisible(true)
      itemnumtxt:setProperty("Text",itemNum)
      
      --Button Setting
      bpslot.WithdrawBtn:setVisible(true)
    end
end)

--Click Button Function
local slot
for slot=1,numSlots do
  local bpslot = self:child("Slot"..slot)
  
  --Withdraw Button
  local withdrawbtn = bpslot.WithdrawBtn
  withdrawbtn.onMouseClick = function()
    PackageHandlers.sendClientHandler("SaveCurBpSlot",{slot=slot})
    UI:openWindow("handbag")
  end
end

local closebtn = self:child("CloseBtn")
closebtn.onMouseClick = function()
  UI:closeWindow("backpack")
end