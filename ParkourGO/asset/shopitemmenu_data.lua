--DATA AREA
local iconPath = {
  speed="gameres|asset/Texture/boots_brigan.png",
  spring="gameres|asset/Texture/Crafting_Item_Spring.PNG.png",
  goldenspring="gameres|asset/Texture/gold-spring.png",
  shield="gameres|asset/Texture/Dark-Shield.png",
  sniper="gameres|asset/Texture/Icon_weapon_AWM.png"
  }

local cost = {
  speed = {200,2000,4000,8000,10000},
  spring = {200,2000,4000,8000,10000},
  goldenspring = {400,4000,8000,16000,32000},
  shield = {500,5000,10000,15000,20000},
  sniper = {1000,10000,20000,30000,40000}
}

local count = {
  speed={1,1,1,1,1},
  spring={1,1,1,1,1},
  goldenspring={1,1,1,1,1},
  shield={1,1,1,1,1},
  sniper={1,1,1,1,1},
}

local names = {
  speed = "Speed Boots Lv. ",
  spring = "Spring Lv. ",
  goldenspring = "Golden Spring Lv. ",
  shield = "Shield Lv. ",
  sniper = "Sniper Lv. "
  }

local itemFramePath = {
  "gameres|asset/Texture/UI/GrayItemFrame.png",
  "gameres|asset/Texture/UI/GreenItemFrame.png",
  "gameres|asset/Texture/UI/BlueItemFrame.png",
  "gameres|asset/Texture/UI/PurpleItemFrame.png",
  "gameres|asset/Texture/UI/GoldenItemFrame.png",
  }

local description = {
  speed="Make you run faster for a short duration.",
  spring="Make you jump higher for a short duration.",
  goldenspring="Allow you to double jump.",
  shield="Protect you from getting injured for a short duration.",
  sniper="Shoot other players."
}

local currency = "$"

--SCRIPT AREA
function self:onOpen()
  PackageHandlers.sendClientHandler("ShopItemMenuWithDataOpen")
end

PackageHandlers.registerClientHandler("UpdateShopItemMenuWithData",function(player,packet)
    if packet then
      --FRAME
      if itemFramePath[packet.level] ~= nil then
        local frame = self:child("Frame")
        frame:setImage(itemFramePath[packet.level])
      end
      --NAMETXT
      local nametxt = self:child("NameTxt")
      nametxt:setProperty("Text",names[packet.type]..packet.level)
      --ICONIMG
      local iconimg = self:child("IconImg")
      iconimg:setVisible(true)
      iconimg:setImage(iconPath[packet.type])
      --COSTTXT
      local costtxt = self:child("CostTxt")
      costtxt:setProperty("Text","Cost: "..cost[packet.type][packet.level]..currency)
      --COUNTTXT
      local counttxt = self:child("CountTxt")
      counttxt:setProperty("Text","Count: "..count[packet.type][packet.level])
      --DESCRIPTIONTXT
      local descriptiontxt = self:child("DescriptionTxt")
      descriptiontxt:setProperty("Text","Description: "..description[packet.type])
    end
end)

local purchasebtn = self:child("PurchaseBtn")
purchasebtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("PurchaseItemWithData",{cost=cost,count=count})
end

local closebtn = self:child("CloseBtn")
closebtn.onMouseClick = function()
  UI:closeWindow("shopitemmenu_data")
end