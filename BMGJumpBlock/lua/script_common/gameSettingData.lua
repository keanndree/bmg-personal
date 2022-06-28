local gameSettingData = {
    minPlayerSum = 2,
    maxPlayerSum = 10,

    gamePrepareTime = 5,
    gameWaitStartTime = 4,


    spawnPosOffset = Vector3.new(0, 1, 0),
    randomMapTb = {
        'map001',
        'map003'
    },
    blockEffect = { effectName = "asset/effects/square/Garena202_enter_blue_3d.effect", offect = Vector3.new(0, 0.1, 0),
                    scale = Vector3.new(2, 2, 2), time = 2 * 1000, yaw = 0 },
    disappearEffect = { effectName = "asset/effects/square/sots208_lighting_red_3d.effect", offect = Vector3.new(0, 0.1, 0),
                    scale = Vector3.new(2, 2, 2), time = 2 * 1000, yaw = 0 },

    PartDisappearSoundCount = 8,
    audioCfg = {
        disappearingBlock = { soundType = '2d', soundPath = 'asset/music/disappearing block.mp3', volume = 1, time = -1 },
        gradientSquare = { soundType = '2d', soundPath = 'asset/music/gradient square.mp3', volume = 1, time = -1 },
        waitingArea = { soundType = '2d', soundPath = 'asset/music/waiting area.mp3', volume = 1, time = -1 },

        victory = { soundType = '2d', soundPath = 'asset/music/victory.mp3', volume = 1, time = 5 },
        fail = { soundType = '2d', soundPath = 'asset/music/fail.mp3', volume = 1, time = 5 },
        countdown = { soundType = '2d', soundPath = 'asset/music/countdown.mp3', volume = 1, time = 5 },


        PartDisappear1 = { soundType = '3d', soundPath = 'asset/music/1.mp3', volume = 1, time = 5 },
        PartDisappear2 = { soundType = '3d', soundPath = 'asset/music/2.mp3', volume = 1, time = 5 },
        PartDisappear3 = { soundType = '3d', soundPath = 'asset/music/3.mp3', volume = 1, time = 5 },
        PartDisappear4 = { soundType = '3d', soundPath = 'asset/music/4.mp3', volume = 1, time = 5 },
        PartDisappear5 = { soundType = '3d', soundPath = 'asset/music/5.mp3', volume = 1, time = 5 },
        PartDisappear6 = { soundType = '3d', soundPath = 'asset/music/6.mp3', volume = 1, time = 5 },
        PartDisappear7 = { soundType = '3d', soundPath = 'asset/music/7.mp3', volume = 1, time = 5 },
        PartDisappear8 = { soundType = '3d', soundPath = 'asset/music/8.mp3', volume = 1, time = 5 }
    },

    mapAudioTb = {
        map001 = 'disappearingBlock',
        MAP_2 = 'waitingArea',
        map003 = 'gradientSquare',
    }
}

return gameSettingData