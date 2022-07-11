local cfg = Entity.GetCfg("myplugin/player1")
local function FallPlatformSequence(part)
  local disappearTime = 10
  local appearTime = 75
  
  local intervalTime = disappearTime
  local interval = 1 / -intervalTime
  
  
  World.Timer(1, function()
        if part:isValid() then
            local alpha = part:getProperty("materialAlpha")
            alpha = alpha + interval
            if alpha >= 1 then
                part:setProperty("materialAlpha", 1)
                part:setProperty("useCollide", "true")
                part.isFlash = false
                return

            elseif alpha <= 0 then
                part:setProperty("materialAlpha", 0)
                interval = 1 / appearTime
                part:setProperty("useCollide", "false")
                return true
            end

            part:setProperty("materialAlpha", alpha)
            return true
        end
    end)
end

--touch event with part
Trigger.addHandler(cfg, "ENTITY_TOUCH_PART_BEGIN", function(context)
    local player = context.obj1
    local part = context.part
    local partName = part.name
    --Trigger different functions based on part name
    if partName == "FallPlat" then
        FallPlatformSequence(part)
    end
end)