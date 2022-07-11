--You can use 'params.parameter name' to get the parameters defined in the node. 					
--For example, if a parameter named 'entity' is defined in the node, you can use 'params.entity' to get the value of the parameter.

local player = params.getPlayerHit
local target = params.getTargetPos


local currentHookDistance = Lib.getPosDistance(player:getPosition(), target:getPosition())
local defaultHookDistance = 14.25
local defaultHookTime = 20

local calculatedHookTime
if currentHookDistance >= defaultHookDistance then
  calculatedHookTime = defaultHookDistance / currentHookDistance * defaultHookTime
else
  calculatedHookTime = currentHookDistance / defaultHookDistance * defaultHookTime
end

--print("Hook Time : "..calculatedHookTime)
player:setForceMoveToAll(target:getPosition(), math.ceil(calculatedHookTime))