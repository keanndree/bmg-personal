--You can use 'params.parameter name' to get the parameters defined in the node. 					
--For example, if a parameter named 'entity' is defined in the node, you can use 'params.entity' to get the value of the parameter.
local player = params.player
PackageHandlers.sendServerHandler(player,"ShowLoadingScreen",{duration=4,loadDone="Entering Map..."})