--You can use 'params.parameter name' to get the parameters defined in the node. 					
--For example, if a parameter named 'entity' is defined in the node, you can use 'params.entity' to get the value of the parameter.

local playerQualified = params.PlayerQualified
local numToQualify = params.NumToQualify

local packetTable = {playerQualified, numToQualify}

PackageHandlers.sendServerHandlerToAll("RefreshQualifiedPlayers", packetTable)