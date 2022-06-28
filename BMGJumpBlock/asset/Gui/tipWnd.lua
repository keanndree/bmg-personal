print("startup ui")

local Txt_info = self:child('Txt_info')
local Img_bg = self:child('Img_bg')
local Img_countdown = self:child('Img_countdown')
local countdownPath = 'gameres|asset/UITexture/figure/%s.png'

function self:setTip(txt,time)
    Img_bg:setVisible(true)
    Txt_info:setText(Lang:toText(txt,time))
end

function self:setCountdownImg(time)
    Img_bg:setVisible(false)
    Img_countdown:setVisible(true)
    Img_countdown:setImage(string.format(countdownPath,time))
    if time < 0 then
        Img_countdown:setVisible(false)
    end
end

function self:closeTip()
    Img_bg:setVisible(false)
end