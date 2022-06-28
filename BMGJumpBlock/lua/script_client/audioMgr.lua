local gameSettingData = require "script_common.gameSettingData"
local audioCfg = gameSettingData.audioCfg
local function getSoundCfg(soundName)
    return audioCfg[soundName]
end

local Audio = {} ---@class Audio
local audioEngine = TdAudioEngine.Instance()
Lib.declare("Audio", Audio)

local soundList = {}
local soundIDTb = {}

local globalMusicID

function Audio.PlaySound(soundName, pos)
    local soundData = getSoundCfg(soundName)

    if not soundData then
        return
    end

    local soundID
    if soundData.soundType == '3d' then
        soundID = audioEngine:play3dSound(soundData.soundPath, pos)
    else
        soundID = audioEngine:play2dSound(soundData.soundPath, soundData.time == -1)
    end

    if soundID and soundID ~= 0 then
        audioEngine:setSoundsVolume(soundID, soundData.volume)
        --audioEngine:set3DRollOffMode(soundID, 0x00040000)
        audioEngine:set3DRollOffMode(soundID, 0x00100000)
        local stopTime = soundData.time
        if stopTime ~= -1 then
            soundList[soundID] = World.Timer(stopTime * 20, function()
                audioEngine:stopSound(soundID)
                soundList[soundID] = nil
            end)
        end
    end
    soundIDTb[soundName] = soundID
    return soundID
end

function Audio.GetSoundIDByName(soundName)
    return soundIDTb[soundName]
end

function Audio.StopSound(soundID)
    if soundList[soundID] then
        soundList[soundID]()
        soundList[soundID] = nil
    end
    audioEngine:stopSound(soundID)
end

function Audio.PlayGlobalSound(soundName)
    local useless = globalMusicID and Audio.StopSound(globalMusicID)
    globalMusicID = Audio.PlaySound(soundName, nil)
end

local mapAudioTb = gameSettingData.mapAudioTb

function Audio.PlayMapSound(packet)
    Audio.PlayGlobalSound(mapAudioTb[packet.mapName])
end

function Audio.PlayPartDisappearSound(packet)
    math.randomseed(os.time())
    local n = math.random(1, gameSettingData.PartDisappearSoundCount)
    Audio.PlaySound('PartDisappear'..n, packet.pos)
end

return Audio

