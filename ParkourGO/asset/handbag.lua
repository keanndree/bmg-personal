--DATA AREA
local numSlots = 9
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
function self:onOpen()
  PackageHandlers.sendClientHandler("HandBagOpen")
end

PackageHandlers.registerClientHandler("UpdateHandBag",function(player)
    local playertray = player:tray()
    local traylist = playertray:query_trays(function(tray)
        if tray:type() == 20 then
          return true
        end
    end)
    local itemlist = traylist[1].tray:query_items(function()
        return true
    end)
    local slot,item
    for slot,item in pairs(itemlist) do
      local hbslot = self:child("Slot"..slot)
      --Item Frame
      if itemFramePath[item:full_name()] ~= nil then
        hbslot.Frame:setImage(itemFramePath[item:full_name()])
      end
      
      --Item Icon
      local iconPath = item:icon()
      hbslot.Frame.Image:setVisible(true)
      hbslot.Frame.Image:setImage("gameres|"..iconPath)
      
      --Item Num Txt
      local itemNum = item:stack_count()
      hbslot.Frame.ItemNumTxt:setVisible(true)
      hbslot.Frame.ItemNumTxt:setProperty("Text",itemNum)
      
      --Select Button
      hbslot.SelectBtn:setVisible(false)
      
      --Remove Button
      hbslot.RemoveBtn:setVisible(true)
    end
end)

local slot
for slot=1,numSlots do
  local hbslot = self:child("Slot"..slot)
  
  --Select Button
  local selectbtn = hbslot.SelectBtn
  selectbtn.onMouseClick = function()
    PackageHandlers.sendClientHandler("SaveCurHbSlot",{slot=slot})
    UI:closeWindow("handbag")
    PackageHandlers.sendClientHandler("WithdrawItem")
  end
  
  --Remove Button
  local removebtn = hbslot.RemoveBtn
  removebtn.onMouseClick = function()
    PackageHandlers.sendClientHandler("RemoveItemFromHandBag",{slot=slot})
  end
end

local closebtn = self:child("CloseBtn")
closebtn.onMouseClick = function()
  UI:closeWindow("handbag")
end