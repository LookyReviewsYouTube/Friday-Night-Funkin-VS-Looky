-- make sure to put the Modcharter.lua next to this script

function onCreate()
    luaDebugMode = true
    loadModchartModule()
    modSetup(false, true)
end 

function onCreatePost() 
    modOnCreatePost()

    -- CREATE YOUR SONG EVENTS HERE!!!!!!!!!!! ----

    setProperty("playbackRate", 1)

    local stepCrochet = stepCrochet/1000

    mods("48", "middle", 100, {duration = 1, ease = "quadOut"}, "4567")
    mods("48", "middle", -240, {duration = 1, ease = "quadOut"}, "0123")
    mods("47", "shake", 300, {duration = stepCrochet, ease = "expoIn"}, "4567")
    mods("48", "shake", 0, {duration = 1 , ease = "quadOut"}, "4567")
    mods("64", "hide", 100, {duration = 0}, "0123")
    
    targetOffset("48", "01234567", {angle = 360}, {duration = 1, ease = "quadOut"}, "goSpin")
    targetOffset("64", "01234567", {angle = 0}, {duration = 0}, "goSpin")

    mods("85", "flip", 40, {duration = stepCrochet*2, ease = "quadIn"}, "4567")
    mods("85", "thin", 40, {duration = stepCrochet*2, ease = "quadIn"}, "4567")
    mods("89", "flip", 0, {duration = stepCrochet*3, ease = "quadOut"}, "4567")
    mods("89", "thin", 0, {duration = stepCrochet*3, ease = "quadIn"}, "4567")

    mods("89", "shake", 200, {duration = stepCrochet*4, ease = "quadIn"}, "4567")
    mods("96", "shake", 0, {duration = stepCrochet, ease = "quadOut"}, "4567")

    targetOffset("100", "4567", {x = -100}, {duration = 0.3, ease = "quadOut"}, "moveSide")
    targetOffset("104", "4567", {x = 100}, {duration = 0.3, ease = "quadOut"}, "moveSide")
    targetOffset("104", "4567", {angle = 360}, {duration = 0.3, ease = "quadOut"}, "goSpin")
    targetOffset("108", "4567", {x = 0}, {duration = 0.3, ease = "quadOut"}, "moveSide")
    targetOffset("108", "4567", {angle = 0}, {duration = 0.3, ease = "quadOut"}, "goSpin")

    mods("110", "flip", 40, {duration = 0.2, ease = "quadIn"}, "4567")
    mods("110", "thin", 40, {duration = 0.2, ease = "quadIn"}, "4567")
    mods("112", "flip", 0, {duration = 0.4, ease = "quadOut"}, "4567")
    mods("112", "thin", 0, {duration = 0.4, ease = "quadIn"}, "4567")

    mods("116", "shake", 200, {duration = 0.4, ease = "quadIn"}, "4567")
    mods("120", "shake", 0, {duration = 0.2, ease = "quadOut"}, "4567")

    mods("120", "invert", 100, {duration = 0.2, ease = "quadIn"}, "4567")
    mods("124", "invert", 0, {duration = 0.3, ease = "quadOut"}, "4567")

    mods("128", "drift", 70, {duration = 1, ease = "quadInOut"}, "4567")

    mods({"184", "312"}, "shake", 500, {duration = 0}, "4567")
    mods({"184", "312"}, "shake", 0, {duration = 0.6, ease = "circOut"}, "4567")
    mods({"184", "312", "376"}, "big", 150, {duration = 0}, "4567")
    mods({"184", "312"}, "big", 0, {duration = 0.6, ease = "quadOut"}, "4567")

    mods(240, "shake", 300, {duration = 0}, "4567")
    mods(239, "flip", 100, {duration = 0.15, ease = "expoIn"}, "4567")
    mods(248, "shake", 0, {duration = 0}, "4567")
    mods(248, "flip", 0, {duration = 0.4, ease = "quadOut"}, "4567")
    mods(256, "drift", 150, {duration = 1, ease = "quadInOut"}, "4567")
   
    mods(368, "wiggle", 0, {duration = 1, ease = "quadIn"}, "4567")
    mods(368, "drift", 0, {duration = 1, ease = "quadIn"}, "4567")
    mods(376, "big", 0, {duration = 0.5, ease = "quadIn"}, "4567")
    mods(376, "reverse", 100, {duration = 0.5, ease = "quadIn"}, "4567")
    mods(376, "float", 100, {duration = 0.5, ease = "quadIn"}, "4567")
    mods(376, "mini", 50, {duration = 0.5, ease = "quadIn"}, "01234567")
    mods(376, "flip", -50, {duration = 0.5, ease = "quadInOut"}, "01234567")
    mods(384, "middle", 100, {duration = 0}, "0123")
    mods(384, "float", -100, {duration = 0.5, ease = "quadInOut"}, "0123")

    mods(384, "hide", 30, {duration = 0.5, ease = "quadInOut"}, "0123")
    mods(384, "invisible", 30, {duration = 0.5, ease = "quadInOut"}, "0123")

    mods(440, "reverse", 50, {duration = 0.83, ease = "quadIn"}, "01234567")
    mods(448, "reverse", 100, {duration = 0.8, ease = "quadOut"}, "0123")
    mods(448, "reverse", 0, {duration = 0.8, ease = "quadOut"}, "4567")
    mods(448, "spin", 100, {duration = 0.4, ease = "quadOut"}, "01234567")
    mods(448, "drift", 300, {duration = 1, ease = "quadOut"}, "01234567")
    mods(448, "wiggle", 25, {duration = 1, ease = "quadOut"}, "0123")
    mods(448, "wiggle", -25, {duration = 1, ease = "quadOut"}, "4567")
    mods(448, "wiggleFreq", 100, {duration = 1, ease = "quadOut"}, "01234567")

    mods(496, "mini", 250, {duration = 1.7, ease = "quadIn"}, "01234567")
    mods(496, "centered", 100, {duration = 1.7, ease = "quadIn"}, "01234567")
    mods(496, "float", 0, {duration = 1.7, ease = "quadIn"}, "01234567")
    mods(496, "hide", 100, {duration = 1.7, ease = "quadIn"}, "01234567")
    mods(496, "invisible", 100, {duration = 1.7, ease = "quadIn"}, "01234567")
    mods(496, "flip", 0, {duration = 1.7, ease = "quadIn"}, "01234567")

    mods(512, "wiggle", 0, {duration = 0}, "01234567")
    mods(512, "wiggleFreq", 0, {duration = 0}, "01234567")
    mods(512, "drift", 0, {duration = 0}, "01234567")
    mods(512, "spin", 0, {duration = 0.8, ease = "quadOut"}, "01234567")
    mods(528, "invisible", 0, {duration = 0}, "01234567")
    mods(528, "hide", 0, {duration = 0}, "01234567")
    mods(528, "centered", 0, {duration = 0}, "01234567")
    mods(528, "reverse", 0, {duration = 0}, "01234567")
    mods(528, "mini", 0, {duration = 0}, "01234567")
    mods(528, "shake", 300, {duration = 0}, "01234567")
    mods(528, "shake", 0, {duration = 1, ease = "quadOut"}, "01234567")
   

    mods(545, "middle", 70, {duration = 0.3, ease = "linear"}, "01234567")
    mods(553, "middle", 0, {duration = 0.41, ease = "linear"}, "01234567")

    mods(560, "speed", -200, {duration = 0}, "01234567")
    mods(560, "speed", 0, {duration = 3, ease = "quadOut"}, "01234567")

    mods(1136, "middle", 100, {duration = 0.4, ease = "quadOut"}, "01234567")
    mods(1136, "hide", 50, {duration = 0.2, ease = "quadInOut"}, "0123")
    mods(1136, "invisible", 50, {duration = 0.2, ease = "quadInOut"}, "0123")

    mods(1225, "flip", -1000, {duration = 0.4, ease = "expoOut"}, "01234567")

    mods(1268, "hide", 0, {duration = 0.2, ease = "quadInOut"}, "0123")
    mods(1268, "invisible", 0, {duration = 0.2, ease = "quadInOut"}, "0123")
    mods(1268, "flip", -100, {duration = 0.4, ease = "quadOut"}, "01234567")
    mods(1268, "shake", 200, {duration = 1.4, ease = "quadIn"}, "01234567")
    targetOffset(1268, "0123", {x = -90}, {duration = 0.4, ease = "quadIn"}, "moveSide")
    targetOffset(1268, "4567", {x = 90}, {duration = 0.4, ease = "quadIn"}, "moveSide")

    mods(1344, "flip", 0, {duration = 0.7, ease = "quadOut"}, "01234567")
    mods(1344, "shake", 0, {duration = 0.7, ease = "quadOut"}, "01234567")
    targetOffset(1344, "01234567", {x = 0}, {duration = 0.7, ease = "quadOut"}, "moveSide")

    targetOffset({"1375", "1439"}, "01234567", {x = 100}, {duration = 0.2, ease = "quadOut"}, "moveSide")
    targetOffset({"1381", "1445"}, "01234567", {x = 0}, {duration = 0.2, ease = "quadOut"}, "moveSide")

    targetOffset({"1407", "1471"}, "01234567", {x = -100}, {duration = 0.2, ease = "quadOut"}, "moveSide")
    targetOffset({"1413", "1477"}, "01234567", {x = 0}, {duration = 0.2, ease = "quadOut"}, "moveSide")

    targetOffset("1427", "01234567", {y = 100 * (downscroll and -1 or 1)}, {duration = 0.2, ease = "quadOut"}, "moveSide")
    targetOffset("1433", "01234567", {y = 0}, {duration = 0.2, ease = "quadOut"}, "moveSide")

    mods(1504, "flip", -100, {duration = 1.4, ease = "quadOut"}, "01234567")
    mods(1504, "hide", 100, {duration = 1.4, ease = "linear"}, "01234567")
    mods(1504, "invisible", 100, {duration = 1.4, ease = "linear"}, "01234567")

    mods(1544, "hide", 100, {duration = 0.6, ease = "quadIn"}, "0123")
    mods(1544, "invisible", 50, {duration = 0.6, ease = "quadIn"}, "0123")
    mods(1544, "hide", 0, {duration = 0.6, ease = "quadIn"}, "4567")
    mods(1544, "invisible", 0, {duration = 0.6, ease = "quadIn"}, "4567")
    mods(1544, "flip", 50, {duration = 0.96, ease = "circIn"}, "01234567")
    mods(1552, "flip", 0, {duration = 1, ease = "quadOut"}, "01234567")
    mods(1552, "drift", 600, {duration = 1, ease = "quadOut"}, "01234567")
    mods(1552, "float", 100, {duration = 1, ease = "quadOut"}, "01234567")

    mods(1600, "reverse", 100, {duration = 1.9, ease = "quadInOut"}, "01234567")

    mods(1664, "drift", 0, {duration = 1.92, ease = "quadIn"}, "01234567")
    mods(1664, "float", 0, {duration = 1.92, ease = "quadIn"}, "01234567")
    mods(1664, "reverse", 0, {duration = 1.9, ease = "quadInOut"}, "01234567")

    mods({1680, 1760, 1904, 1984}, "shake", 200, {duration = 0}, "01234567")
    mods({1744, 1888, 1968, 2112}, "shake", 0, {duration = 0.2, ease = "quadOut"}, "01234567")


    mods(1888, "reverse", 100, {duration = 0.6, ease = "quadInOut"}, "01234567")
    mods(1968, "reverse", 0, {duration = 0.6, ease = "quadInOut"}, "01234567")

    mods(2160, "hide", 100, {duration = 0}, "01234567")
    mods(2160, "invisible", 100, {duration = 0}, "01234567")
    setProperty("spawnTime", 2000)

    for i = 0, getProperty("unspawnNotes.length")-1 do 
        local strumTime = getPropertyFromGroup("unspawnNotes", i, "strumTime")
        local noteID = getPropertyFromGroup("unspawnNotes", i ,"ID")
        if getNoteBetween(strumTime/1000, 81.90, 84) then 
            setTag(noteID, "pausingNote1")
            setNoteVar(noteID, "defOffset", 1200 * (downscroll and 1 or -1))
            setPropertyFromGroup("unspawnNotes", i ,"offsetY", 1200 * (downscroll and 1 or -1))
        end
        if getNoteBetween(strumTime/1000, 82.21, 85.62) then 
            setTag(noteID, "pausingNote2")
            setNoteVar(noteID, "defOffset", 500 * (downscroll and 1 or -1))
            setPropertyFromGroup("unspawnNotes", i ,"offsetY", 500 * (downscroll and 1 or -1))
        end
        if getNoteBetween(strumTime/1000, 86.39, 87.52) then 
            setTag(noteID, "pausingNote3")
            offse = 1200
            setNoteVar(noteID, "defOffset", 1200 * (downscroll and 1 or -1))
            setPropertyFromGroup("unspawnNotes", i ,"offsetY", 1200 * (downscroll and 1 or -1))
        end
        if getNoteBetween(strumTime/1000, 88, 89) then 
            setTag(noteID, "pausingNote4")
            setNoteVar(noteID, "defOffset", 550 * (downscroll and 1 or -1))
            setPropertyFromGroup("unspawnNotes", i ,"offsetY", 550 * (downscroll and 1 or -1))
        end
        if getNoteBetween(strumTime/1000, 80, 89.2) then 
            setTag(noteID, "noMod")
            setTag(noteID, "pausingNote")
        end
        if getPropertyFromGroup("unspawnNotes", i ,"noteType") == "Hey!" then 
            setTag(noteID, "shockNote")
            setTag(noteID, "noMod")
        end
        if getPropertyFromGroup("unspawnNotes", i ,"noteType") == "GF Sing" and strumTime < 26000 then 
            setTag(noteID, "specialNote1")
            setTag(noteID, "noMod")
        end
    end
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end

function loadModchartModule() -- INSERT THE MODULE SCRIPT PATH HERE
    modchartModule = require([[mods\]]..getPropertyFromClass("Paths", "currentModDirectory")..[[\data\aleph-0\Modcharter]])
    for i, v in pairs(modchartModule) do -- get all functions in module and go here without "extraFunc", magic right?
       _G[tostring(i)] = v
    end
end

local beatSwitch = false
local changeSwitch = false
local changeMiddle = 0
function onStepHit()
    if ((curStep >= 128 and curStep < 242) or curStep >= 256 and curStep < 384) and short(curStep%64, {0,4,6,8,12, 16,22,28, 32,34,38,40,44,  48,54,56}) then 
        beatSwitch = beatSwitch == false
        if beatSwitch then 
            targetOffset("", "46", {y = -20}, {duration = 0}, "beatMove")
            targetOffset("", "57", {y = 20}, {duration = 0}, "beatMove")
            targetOffset("", "4567", {y = 0}, {duration = 0.3, ease = "quadOut"}, "beatMove")
            if curStep < 368 then
                mods("", "wiggle", 200, {duration = 0}, "4567")
                mods("", "wiggle", 0, {duration = 0.4, ease = "circOut"}, "4567")
            end
        else 
            targetOffset("", "46", {y = 20}, {duration = 0}, "beatMove")
            targetOffset("", "57", {y = -20}, {duration = 0}, "beatMove")
            targetOffset("", "4567", {y = 0}, {duration = 0.3, ease = "quadOut"}, "beatMove")
            if curStep < 368 then
                mods("", "wiggle", -200, {duration = 0}, "4567")
                mods("", "wiggle", 0, {duration = 0.4, ease = "circOut"}, "4567")
            end
        end
    end
    if curStep == 512 and curStep <= 513 then 
        doTweenAngle("camcam", "camHUD", 0, 1, "quadOut")
    end
    if curStep >= 624 and curStep < 1136 then 
        if (curStep+16)%64 == 48 then changeSwitch = changeSwitch == false end
        if short((curStep+16)%64, {48,52,56,60, 0}) and curStep > 656 then 
            changeMiddle = changeMiddle + (changeSwitch and 40 or -40)
            mods("", "shake", 200, {duration = 0}, "01234567")
            mods("", "shake", 0, {duration = crochet/1000, ease = "quadOut"}, "01234567")
            mods("", "middle", changeMiddle, {duration = crochet/1000, ease = "quadOut"}, "01234567")
        end
        if ((short((curStep+16)%64, {0,6,8, 16,22,24,28 ,32,34,38,40,44,  48,52,56,60}) or curStep == 874 or curStep == 876) and curStep < 880) or 
            short((curStep+16)%64, {0,4,8,12, 16,20,24,28, 32,34,38,40,44, 48,52,56,60}) then 
            beatSwitch = beatSwitch == false
            if beatSwitch then 
                targetOffset("", "0246", {y = -30, x = -10}, {duration = 0}, "beatMove")
                targetOffset("", "1357", {y = 30, x = -10}, {duration = 0}, "beatMove")
                targetOffset("", "01234567", {y = 0, x = 0}, {duration = 0.3, ease = "quadOut"}, "beatMove")
            else 
                targetOffset("", "0246", {y = 30, x = 10}, {duration = 0}, "beatMove")
                targetOffset("", "1357", {y = -30, x = 10}, {duration = 0}, "beatMove")
                targetOffset("", "01234567", {y = 0, x = 0}, {duration = 0.3, ease = "quadOut"}, "beatMove")
            end
        end
    end
    if curStep == 1232 then --pause
        setProperty("spawnTime", 5000)
    end
    if curStep == 1504 then --resume
        setProperty("spawnTime", 2000)
    end
end

function short(value, array)
    for i = 1, #array do 
        if array[i] == value then return true end
    end
    return false
end

function getNoteBetween(strumTime, time1, time2)
    if strumTime >= time1 and strumTime < time2 then 
        return true
    end
    return false
end

local dizzyCam = 0
function onUpdate(elapsed)
    modOnUpdate()
    setProperty("noteKillOffset", 2500)
    if curStep >= 384 and curStep < 512 then 
        dizzyCam = elapsed +dizzyCam
        setProperty('camHUD.angle', math.sin(dizzyCam)*5) 
    end
    if curStep >= 2128 and curStep < 2160 then 
        mods("", "speed", getRandomFloat(-80, 80), {duration = 0}, "4567")
    end
end
function onUpdatePost(elapsed)
    modOnUpdatePost()
    if curStep >= 64 and curStep < 512 then  -- 2128
        for i = 0 ,getProperty("notes.length")-1 do 
            local isCorrectNote = getPropertyFromGroup("notes", i, "noteType") == "GF Sing"
            if isCorrectNote then 
                local noteDistance =  (getSongPosition() - getPropertyFromGroup("notes", i, "strumTime")) * -0.01
                local multIn = getPropertyFromGroup("notes", i, "noteData")%4 <= 1 and -1 or 1
                setPropertyFromGroup("notes",i,"offsetX", math.pow(math.max(noteDistance-1, 0)*5, 2) * multIn)
                if not getPropertyFromGroup("notes", i, "isSustainNote") then
                    setPropertyFromGroup("notes",i,"angle", math.pow(math.max(noteDistance-1, 0)*4, 2) * multIn)
                end
                if getPropertyFromGroup("notes", i, "isSustainNote") then
                    setPropertyFromGroup("notes",i,"offsetX", getPropertyFromGroup("notes",i,"offsetX")+ 
                    getPropertyFromGroup("strumLineNotes", getPropertyFromGroup("notes", i, "noteData"), "width")/2 - getPropertyFromGroup("notes", i, "width")/2)  
                end
            end
        end
    end

    if curStep >= 240 and curStep < 258 then 
        for i = 0, getProperty("notes.length")-1 do
            if getPropertyFromGroup("notes", i, "noteType") == "MissNote" and getPropertyFromGroup("notes", i, "strumTime") < 18300 then
                setTag(getPropertyFromGroup("notes", i ,"ID"), "noMod")
                setPropertyFromGroup("notes", i, "copyX", false)
                setPropertyFromGroup("notes", i, "alpha", 0.3)
            end
        end
    end
    if curStep >= 296 and curStep < 312 then
        for i = 0, getProperty("notes.length")-1 do
            if getPropertyFromGroup("notes", i, "noteType") == "MissNote" and getPropertyFromGroup("notes", i, "strumTime") < 21500 then
                setTag(getPropertyFromGroup("notes", i ,"ID"), "noMod")
                setPropertyFromGroup("notes", i, "copyY", false)
                setPropertyFromGroup("notes", i, "copyX", false)
                setPropertyFromGroup("notes", i, "copyAlpha", false)
                local intensityX= 1400;
                if getPropertyFromGroup("notes", i, "noteData")%4 <= 1 then 
                    intensityX = -1400
                end
                if getRandomBool(20) then
                    setPropertyFromGroup("notes", i, "x", getPropertyFromGroup("notes", i, "x") + (intensityX*elapsed))
                    setPropertyFromGroup("notes", i, "y", getPropertyFromGroup("notes", i, "y") + ((downscroll and -1400 or 1400)*elapsed))
                end
                setPropertyFromGroup("notes", i, "alpha", getPropertyFromGroup("notes", i, "alpha") - (2*elapsed))
            end
        end
    end
    if curStep >= 1387 and curStep < 1403 then --pausealeph --1387
        local startTime = 81.858
        local endTime = 82.818
        local percent = boundTo((startTime - (getSongPosition()/1000)) / (startTime - endTime), 0, 100)
        for i = 0 ,getProperty("notes.length")-1 do 
            local isCorrectNote = checkTag(getPropertyFromGroup("notes", i, "ID"), "pausingNote1") == true
            if isCorrectNote then 
                local defau = 1200 * (downscroll and 1 or -1)
                setPropertyFromGroup("notes",i,"offsetY", ratio(defau, 0, percent))
            end
        end
    end
    if curStep >= 1419 and curStep < 1427 then --pause
        local startTime = 83.778
        local endTime = 84.258
        local percent = boundTo((startTime - (getSongPosition()/1000)) / (startTime - endTime), 0, 100)
        for i = 0 ,getProperty("notes.length")-1 do 
            local isCorrectNote = checkTag(getPropertyFromGroup("notes", i, "ID"), "pausingNote2") == true
            if isCorrectNote then 
                local defau = getNoteVar(getPropertyFromGroup("notes", i, "ID"), "defOffset")
                setPropertyFromGroup("notes",i,"offsetY", ratio(defau, 0, percent))
            end
        end
    end
    if curStep >= 1451 and curStep < 1467 then --pause
        local startTime = 85.698
        local endTime = 86.658
        local percent = boundTo((startTime - (getSongPosition()/1000)) / (startTime - endTime), 0, 100)
        for i = 0 ,getProperty("notes.length")-1 do 
            local isCorrectNote = checkTag(getPropertyFromGroup("notes", i, "ID"), "pausingNote3") == true
            if isCorrectNote then 
                local defau = getNoteVar(getPropertyFromGroup("notes", i, "ID"), "defOffset")
                setPropertyFromGroup("notes",i,"offsetY", ratio(defau, 0, percent))
            end
        end
    end
    if curStep >= 1483 and curStep < 1491 then --pause
        local startTime = 87.618
        local endTime = 88.098
        local percent = boundTo((startTime - (getSongPosition()/1000)) / (startTime - endTime), 0, 100)
        for i = 0 ,getProperty("notes.length")-1 do 
            local isCorrectNote = checkTag(getPropertyFromGroup("notes", i, "ID"), "pausingNote4") == true
            if isCorrectNote then 
                local defau = getNoteVar(getPropertyFromGroup("notes", i, "ID"), "defOffset")
                setPropertyFromGroup("notes",i,"offsetY", ratio(defau, 0, percent))
            end
        end
    end

    if curStep >= 2128 and curStep < 2160 then  -- 2128
        for i = 0 ,getProperty("notes.length")-1 do 
            local isCorrectNote = getPropertyFromGroup("notes", i, "noteType") == "MissNote"
            if isCorrectNote then 
                local distance = (getPropertyFromGroup("notes", i, "strumTime") - getSongPosition())/1000
                local multIn = getPropertyFromGroup("notes", i, "noteData")%4 <= 1 and -1 or 1
                setPropertyFromGroup("notes",i,"offsetX", math.pow(math.min(distance-0.2, 0)*50, 2)*multIn)
            end
        end
    end

    if curStep >= 608 and curStep < 1136 then  -- 2128
        for i = 0 ,getProperty("notes.length")-1 do 
            local isCorrectNote = getPropertyFromGroup("notes", i, "noteType") == "Hey!"
            if isCorrectNote then 
                local noteDistance =  (getSongPosition() - getPropertyFromGroup("notes", i, "strumTime")) * -0.01
                setPropertyFromGroup("notes",i,"offsetX", math.sin(noteDistance/2) * 250)
                setPropertyFromGroup("notes",i,"multSpeed", 0.8)
            end
        end
    end
end

function onDestroy()
    modOnDestroy()
end

function onPause()
    modOnPause()
end

function onResume()
    modOnResume()
end

function onCountdownStarted()
    modOnCountdownStarted()
end


function goodNoteHit(id, noteData, noteType, isSus)
    modOnGoodHit(id, noteData, noteType, isSus)
end

function lerp(a,b,t) return a + (b - a) * t end
function ratio(a, b, percent) return (a * (1 - percent)) + (b * percent) end
function boundTo(value, min, max) return math.max(min, math.min(max, value)) end