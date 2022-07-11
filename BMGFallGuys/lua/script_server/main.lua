print('script_server:hello world')

require "script_server.fallingplatform"

local
local gameStartTime = 10 --seconds
Trigger.RegisterHandler(World.cfg, "GAME_START", function()
    PackageHandlers.sendServerHandlerToAll("TeamInitialization")
    PackageHandlers.sendServerHandlerToAll("StartTimerHandler", {gameStartTime})
end)
