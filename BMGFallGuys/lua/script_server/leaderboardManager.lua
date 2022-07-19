local RedisHandler = require "redishandler"


Trigger.addHandler(Entity.GetCfg("myplugin/player1"), "ENTITY_DIE", function(context)
  local player = context.obj1 
  local death = player:getValue("death") --Gets the value of the entity value that defines "score"
  if death > 0 then --If the value is greater than 1
    player:setValue("death", death + 1) -- Set the value to half the original
  else
    player:setValue("death", 1)
  end
end )