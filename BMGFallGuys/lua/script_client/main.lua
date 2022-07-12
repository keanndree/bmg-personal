print('script_client:hello world')

--local function resetplayer(player) --Reset Player To Default
--  local map = World.CurWorld:getMap("LobbyColl")
--  local pos = {x=-1.465,y=1.04,z=-33.713}
--  player:setMapPos(map,Vector3.new(pos.x,pos.y,pos.z),0,0)
--  player:setRebirthPos(Vector3.new(pos.x,pos.y,pos.z),map)
--  --player:setData("LastCheckpointName",nil)
--end



PackageHandlers.registerClientHandler("TeamInitialization", function(player)
    UI:openWindow("UI/GameScore")
    UI:openWindow("UI/TimerPanel")
end)


