--DATA AREA
local iconPath = {
  speed="gameres|asset/Texture/boots_brigan.png",
  spring="gameres|asset/Texture/Crafting_Item_Spring.PNG.png",
  goldenspring="gameres|asset/Texture/gold-spring.png",
  shield="gameres|asset/Texture/Dark-Shield.png",
  sniper="gameres|asset/Texture/Icon_weapon_AWM.png"
  }

local description = {
  speed = {
    {"Speed: +3","Duration: 3s"},
    {"Speed: +3","Duration: 4s"},
    {"Speed: +3","Duration: 6s"},
    {"Speed: +3","Duration: 8s"},
    {"Speed: +3","Duration: 10s"}
  },
  spring = {
    {"Jump High: +6","Duration: 3s"},
    {"Jump High: +6","Duration: 4s"},
    {"Jump High: +6","Duration: 6s"},
    {"Jump High: +6","Duration: 8s"},
    {"Jump High: +6","Duration: 10s"}
  },
  goldenspring = {
    {"Double Jump: +1","Duration: 3s"},
    {"Double Jump: +1","Duration: 4s"},
    {"Double Jump: +1","Duration: 6s"},
    {"Double Jump: +1","Duration: 8s"},
    {"Double Jump: +1","Duration: 10s"}
  },
  shield = {
    {"Invincible: +1","Duration: 3s"},
    {"Invincible: +1","Duration: 4s"},
    {"Invincible: +1","Duration: 6s"},
    {"Invincible: +1","Duration: 8s"},
    {"Invincible: +1","Duration: 10s"}
  },
  sniper = {
    {"Recoil: 10","Cooldown: 7s"},
    {"Recoil: 8","Cooldown: 6s"},
    {"Recoil: 6","Cooldown: 5s"},
    {"Recoil: 5","Cooldown: 4s"},
    {"Recoil: 4","Cooldown: 3s"}
  }
}

local cost = {
  speed = {100,1000,10000,100000},
  spring = {100,1000,10000,100000},
  goldenspring = {100,1000,10000,100000},
  shield = {100,1000,10000,100000},
  sniper = {100,1000,10000,100000}
}

local itemFramePath = {
  "gameres|asset/Texture/UI/GrayItemFrame.png",
  "gameres|asset/Texture/UI/GreenItemFrame.png",
  "gameres|asset/Texture/UI/BlueItemFrame.png",
  "gameres|asset/Texture/UI/PurpleItemFrame.png",
  "gameres|asset/Texture/UI/GoldenItemFrame.png",
  }

local currency = "$"

--SCRIPT AREA
function self:onOpen()
  PackageHandlers.sendClientHandler("UpgradeMenuOpen")
end

PackageHandlers.registerClientHandler("UpdateUpgradeMenu",function(player,packet)
    --Frame
    if itemFramePath[packet.level] ~= nil then
      local frame = self:child("Frame")
      frame:setImage(itemFramePath[packet.level])
    end
    
    --Icon
    local iconimg = self:child("IconImg")
    iconimg:setVisible(true)
    iconimg:setImage(iconPath[packet.type])
    
    --Name
    local nametxt = self:child("NameTxt")
    nametxt:setProperty("Text",string.upper(packet.type))
    
    --ProgressBar
    local progress = self:child("Progress")
    if packet.level < packet.maxlevel then
      progress:setProgress(0)
      progress:setStepSize(1/packet.expneed)
      if packet.expnow > 0 then
        local i
        for i = 1,packet.expnow do
          progress:step()
        end
      end
    else
      progress:setProgress(1)
    end
    
    --ProgressBar/EXPTXT
    if packet.level < packet.maxlevel then
      progress.ExpTxt:setProperty("Text","EXP: "..packet.expnow.."/"..packet.expneed)
    else
      progress.ExpTxt:setProperty("Text","MAX")
    end
    
    --LevelTxt
    local leveltxt = self:child("LevelTxt")
    leveltxt:setProperty("Text","Level: "..packet.level.."/"..packet.maxlevel)
    
    --DescriptionTxt
    local description1txt = self:child("Description1Txt")
    description1txt:setProperty("Text",description[packet.type][packet.level][1])
    local description2txt = self:child("Description2Txt")
    description2txt:setProperty("Text",description[packet.type][packet.level][2])
    
    --CostTxt
    local costtxt = self:child("CostTxt")
    if packet.level < packet.maxlevel then
      costtxt:setProperty("Text","Cost: "..cost[packet.type][packet.level]..currency)
    else
      costtxt:setVisible(false)
    end
    
    --UpgradeBtn
    local upgradebtn = self:child("UpgradeBtn")
    if packet.level >= packet.maxlevel then
      upgradebtn:setEnabled(false)
    end
end)

local upgradebtn = self:child("UpgradeBtn")
upgradebtn.onMouseClick = function()
  PackageHandlers.sendClientHandler("UpgradeAttribute",{cost=cost})
end

local closebtn = self:child("CloseBtn")
closebtn.onMouseClick = function()
  UI:closeWindow("upgrademenu")
end