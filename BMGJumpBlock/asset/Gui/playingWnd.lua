print("startup ui")

local Txt_gameTimer = self:child('Txt_gameTimer')
local Txt_curPlayerSum = self:child('Txt_curPlayerSum')

function self:setGameTimer(time)
    Txt_gameTimer:setText(time)
end

function self:setCurPlayerSum(sum)
    Txt_curPlayerSum:setText(Lang:toText('LangKey_curPlayerSum')..sum)
end