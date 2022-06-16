--DATA AREA
local numRooms = 4

local roomkeys = {
  "training",
  "speedrun",
  "pvp",
  "helltower"
  }

--SCRIPT AREA

--Room
local i
for i = 1,numRooms do
  local room = self:child("Room"..i)
  --JoinBtn
  local joinbtn = room.JoinBtn
  joinbtn.onMouseClick = function()
    UI:closeWindow("roommenu")
    PackageHandlers.sendClientHandler("PlayerJoinRoom",{key=roomkeys[i]})
  end
end

--On Open
function self:onOpen()
  PackageHandlers.sendClientHandler("RoomMenuOpened")
end

--On Close
function self:onClose()
  PackageHandlers.sendClientHandler("RoomMenuClosed")
end

PackageHandlers.registerClientHandler("UpdateRoomMenu",function(player,packet)
    local i
    for i = 1,numRooms do
      if packet[roomkeys[i]].type == "pvp" then
        local room = self:child("Room"..i)
        
        --PlayerNumTxt
        room.PlayerNumTxt:setProperty("Text","Player: "..packet[roomkeys[i]].playernum)
        
        --StatusTxt
        if packet[roomkeys[i]].started then
          room.StatusTxt:setProperty("Text","Status: Playing")
          room.StatusTxt:setTextColours(Color3.fromRGB(170,0,0))
        else
          room.StatusTxt:setProperty("Text","Status: Waiting")
          room.StatusTxt:setTextColours(Color3.fromRGB(0,170,0))
        end
      end
    end
end)

--Close Btn
local closebtn = self:child("CloseBtn")
closebtn.onMouseClick = function()
  UI:closeWindow("roommenu")
end