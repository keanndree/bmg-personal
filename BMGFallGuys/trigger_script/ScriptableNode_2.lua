--You can use 'params.parameter name' to get the parameters defined in the node. 					
--For example, if a parameter named 'entity' is defined in the node, you can use 'params.entity' to get the value of the parameter.

local redScore = params.redScore
local blueScore = params.blueScore

--print("Redscore = "..redScore)
--print("BlueScore = "..blueScore)


PackageHandlers.sendServerHandlerToAll("RefreshGameScore", {redScore,blueScore})