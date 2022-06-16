UI:openWindow("shortcutBar")

local function makefadebackground(background,fadein,duration)--Make Fade Background
  --If This Is Fade In
  if fadein then
    --Check If Alpha > 0
    if background:getAlpha() > 0 then
      background:setAlpha(0)
    end
    local counter = 0
    World.Timer(1,function()
        if counter <= duration then
          local alpha = background:getAlpha()
          background:setAlpha(alpha+(1/duration))
          counter = counter + 1
          return true
        else
          local alpha = background:getAlpha()
          if alpha < 1 then
            background:setAlpha(1)
          end
        end
    end)
  --If This Is Fade Out
  else
    --Check If Alpha < 1
    if background:getAlpha() < 1 then
      background:setAlpha(1)
    end
    local counter = 0
    World.Timer(1,function()
        if counter <= duration then
          local alpha = background:getAlpha()
          background:setAlpha(alpha-(1/duration))
          counter = counter + 1
          return true
        else
          local alpha = background:getAlpha()
          if alpha > 0 then
            background:setAlpha(0)
          end
        end
    end)
  end
end

local function loadingscreenactions(params)
  local text = params.text
  local progress = params.progress
  local duration = params.duration - 3
  local contents = params.contents
  local counter = 0
  --Loading Text
  if contents[text:getProperty("Text")] then
    text:setProperty("Text",contents[text:getProperty("Text")])
  end
  World.Timer(20,function()
      if counter < duration then
        local content = text:getProperty("Text")
        if contents[content] then
          text:setProperty("Text",contents[content])
        end
        counter = counter + 1
        return true
      else
        text:setProperty("Text",contents.loadDone)
      end
  end)
  
  --Loading Progress
  if progress:getProgress() > 0 then
    progress:setProgress(0)
  end
  local counter2 = 0
  progress:setStepSize(1/(duration*20))
  World.Timer(1,function()
      if counter2 <= duration*20 then
        progress:step()
        counter2 = counter2 + 1
        return true
      else
        if progress:getProgress() < 1 then
          progress:setProgress(1)
        end
      end
  end)
end

PackageHandlers.registerClientHandler("CheckPointNotification",function(player)
    UI:openWindow("checkpoint")
    World.Timer(60,function()
        UI:closeWindow("checkpoint")
    end)
end)

PackageHandlers.registerClientHandler("OpenRewardMenu",function(player,packet)
    local rewardmenu = UI:openWindow("reward")
    
    --Money Num Txt
    if packet.money ~= nil and packet.money > 0 then
      local moneynumtxt = rewardmenu:child("MoneyNumTxt")
      moneynumtxt:setProperty("Text",packet.money)
    end
    
    --Exp Num Txt
    if packet.exp ~= nil and packet.exp > 0 then
      local expnumtxt = rewardmenu:child("ExpNumTxt")
      expnumtxt:setProperty("Text",packet.exp)
    end
    
    --AcceptBtn
    local acceptbtn = rewardmenu:child("AcceptBtn")
    acceptbtn.onMouseClick = function()
      PackageHandlers.sendClientHandler("EarnReward",packet)
      UI:closeWindow("reward")
    end
end)

PackageHandlers.registerClientHandler("ShowLoseNotification",function(player)
    UI:openWindow("losenotification")
end)

PackageHandlers.registerClientHandler("ShowLoadingScreen",function(player,packet)
    local ui = UI:openWindow("loadingscreen")
    local background = ui:child("Background")
    makefadebackground(background,true,20)
    World.Timer(20,function()
        local loadingtxt = ui:child("LoadingTxt")
        local loadingprogress = ui:child("LoadingProgress")
        local duration = packet.duration
        local contents = {
          ["LOADING"] = "LOADING.",
          ["LOADING."] = "LOADING..",
          ["LOADING.."] = "LOADING...",
          ["LOADING..."] = "LOADING.",
          ["loadDone"] = packet.loadDone
        }
        loadingscreenactions({text=loadingtxt,progress=loadingprogress,duration=duration,contents=contents})
        World.Timer(20*packet.duration,function()
            makefadebackground(background,false,20)
            World.Timer(20,function()
                UI:closeWindow("loadingscreen")
            end)
        end)
    end)
end)