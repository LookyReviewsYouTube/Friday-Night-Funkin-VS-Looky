-- version 0.5
-- script by An Ammar (@AnAmmar at YT)

--[[
    INSTRUCTIONS (HOW TO USE THIS SCRIPT)

    -- METHODS
        mods(time:Dynamic, special:string ,intensity:float, tweenOption:array, notes:string)

        - time     = Time to trigger this function (in step)
        - special = Mod name (look MODS list) 
        - intensity = Intensity of mod (in percent)
        - tweenOption = For tweening 
        +- duration = Duration of the tween
        +- ease = Optional easer function
        - notes = Notes' mod to change (must write in string)

        --example : 
            mods({"5", "10", "15"}, "wiggle" , 100, {duration = 1, ease = "quadInOut"}, "01234567")
            mods("0%4 | >= 24 | < 16", "mini" , 0, {duration = crochet/1000, ease = "expoIn"}, "0246")


        targetOffset(time:Dynamic, notes:string, coordinate:array, tweenOption:array, tag:string)

        - time     = Time to trigger this function (in step)
        - notes = Notes' mod to change (must write in string)
        - coordinate = Receptors' property to change (x, y, angle)
        - tweenOption = For tweening 
        +- duration = Duration of the tween
        +- ease = Optional easer function
        - tag = Offset tag (default : "default")
    
        --example : 
            targetOffset("15", "0123", {y = -50, x = 50}, {duration = 1})
            targetOffset("0%8 | >= 100", "4567", {angle = 360}, {duration = 0.5}, "spinning")
        

        targetPos(time:Dynamic, notes:string, coordinate:array, tweenOption:array)

        - time     = Time to trigger this function (in step)
        - notes = Notes' mod to change (must write in string)
        - coordinate = Receptors' property to change (x, y, angle)
        - tweenOption = For tweening 
        +- duration = Duration of the tween
        +- ease = Optional easer function
    
        --example : 
            targetPos({"25", "0%8 | >= 100"}, "4567", {y = -100, x = -100}, {duration = 1, ease = "quadInOut"})
            targetPos("10", "01234567", {angle = 50}, {duration = crochet/1000*4, ease = "quadOut"})


        customNoteMod(modName:string, modFunc:function)

        - modName = Name of your mod
        - modFunc(value, storage) = Function of your mod
        -+ storage have 'distance', 'id', 'direction', 'noteData', 'strumTime'

        --example : 
            customNoteMod("lag", function (modValue , noteStuff)
                local distance = noteStuff.distance
                local offset = 0
                if distance > 6 then 
                    offset = 30;
                elseif distance > 4 then 
                    offset = 20;
                elseif distance > 2 then
                    offset = 10;
                end
                
                return {x = offset*10*modValue}
            end)
            mods("0", "lag" , 200, {duration = 2, ease = "quadOut"}, "01234567")

        direction(time:Dynamic, notes:string, direction:float, tweenOption:array) 

        - time     = Time to trigger this function (in step)
        - notes = Notes' mod to change (must write in string)
        - direction = Intesity
        - tweenOption = For tweening 
        +- duration = Duration of the tween
        +- ease = Optional easer function

        --example : 
            direction("10", "01234567", 180, {duration = 1, ease = "expoInOut"}) 


        setOption(variable:string, value:dynamic)

        - variable = setting to change
        - value = value

        --example :
            setOption("disableSusAngleFixer", true)
            setOption("disableSustainReduce", false)

        timer(time:Dynamic, function)

        - time     = Time to trigger this function (in step)
        - function = function to trigger
            
        --example :
            timer("20", function()
                debugPrint('DISABLING SUSTAIN REDUCE AT STEP 20')
                setOption("disableSustainReduce", true)
            end)

    --
    --VARIABLES 
        disableSusAngleFixer : disable notes' sustain angle fixer (default : false)
        disableSustainReduceFixer : disable notes' modified sustain reducer (default : true (due to lagging on some people))
        disableSustainReduce : disable notes' regular sustain reducer (defaut : false)
    --
    -- NOTES 
        leave function's time empty like '' to run the function instantly.

        in function's time 
            "|" mean 'and'
            "%" mean devision 

        To change HUD's property you have to do it manually (use doTweenX, doTweenY and etc)
    --
]]

--TODO : aDD NOTE tag 

MODS = 
    {
    --TARGET NOTES
    "centered", 
    "big",
    "mini",
    "float",
    "beat",
    "thin",
    "wide",
    "shake",
    "spin",
    "middle",
    "flip",
    "invert",
    "bounce",
    "roll", -- coming soon
    "tilt",
    --NOTES MODS
    "drift", 
    "wiggle", 
    "wiggleFreq", 
    "reverse", 
    "dizzy",
    "tornado",
    "accel",
    "speed",
    --HIDE MODS
    "hide", -- hide receptor
    "invisible", -- hide notes
    "fade_out",
    "fade_in",
    "fade_out_offset",
    "fade_in_offset",
    }

CUSTOM_MODS = {}

local module = {}

MODS_VALUE = {}
DIR_VALUE = {}
STRUM_VALUE = {}
REAL_STRUM_VALUE = {}
STRUM_VALUE_TOTAL = {}
NOTE_CUSTOM = {}

MODSARRAY = {}
NOTES_TAG = {}

local parentFolder = ""

commandsToRunMODS = ""

storedModchart = {}

noteCamsBeat = true
fadeCountdown = true
disableNewCams = true

disableSusAngleFixer = false;
disableSustainReduceFixer = true;
disableSustainReduce = false;

DEFAULT_VALUE = "default"


local defaultDown = false
local defaultMid = false
local defaultSplash = false

local oldStep = -999

local strumDataLoad = false


function onCreate()
    luaDebugMode = true
    if string.find(songName, 'menu') then 
        close()
       return;
    end

    parentFolder = getParentPath(scriptName)
    --TW = require(parentFolder..[[\ModLib\Tween]])
    --debugPrint(parentFolder..[[\ModLib\Tween]])
    
   
    importLibrary()

    runHaxeCode([[
            
            modTweens = [];
            modsTweens = [];
            boundTo = CoolUtil.boundTo;

            downscroll = ]]..(downscroll and "true" or "false")..[[;
            middlescroll = ]]..(middlescroll and "true" or "false")..[[;
            disableNewCams = ]]..(disableNewCams and "true" or "false")..[[;
            camNotesBeat = 0;

            beatX = 0; beatXTween = null;
            bounceY = 0; bounceYTween = null;
            modTweens.push(beatXTween);
            modTweens.push(bounceYTween);

           
            // // //MODS
            strumsDefault = [];
            strumsOffset = [];
            strumsYPos = [50,570]; // UP, DOWN
            strumsXCenter = [412 ,524 ,636 ,748]; // UP, DOWN
            strumsCenter = [586, 294]; // X, Y
            strumsCurPos = [];
            strumsRangeY = 520;
            strumsFlipRange = [336, 112, -112 , -336];
            strumsInvertRange = [112, -112, 112 , -112];
            strumsCenterRange = 320;
            strumsRange = 112;

            strumsDirectionTween = [null, null, null, null, null, null, null, null];
            modsTweens.push(strumsDirectionTween);
            setVar("MODS", null);
    ]])


end

function modOnCreatePost()
    importLibrary()
    importMods()
   
    local path = getParentPath(scriptName)
    TW = require([[mods\]]..getPropertyFromClass("Paths", "currentModDirectory")..[[\data\aleph-0\ModLib\Tween]])
end
function importMods()
    for i = 1, #MODS do 
        MODS_VALUE[MODS[i]] = {{0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}}; -- VALUE, TWEEN
    end
    DIR_VALUE = {{90}, {90}, {90}, {90}, {90}, {90}, {90}, {90}}
    STRUM_VALUE = {}
    STRUM_VALUE_TOTAL = {
        {x = 0, y = 0, angle = 0},
        {x = 0, y = 0, angle = 0},
        {x = 0, y = 0, angle = 0},
        {x = 0, y = 0, angle = 0},
        {x = 0, y = 0, angle = 0},
        {x = 0, y = 0, angle = 0},
        {x = 0, y = 0, angle = 0},
        {x = 0, y = 0, angle = 0}
    }
    beatVal = 0; beatValTween = nil;
    bounceVal = 0; bounceValTween = nil;
    NOTES_TAG = {}
    NOTE_CUSTOM = {}
end
function importLibrary()
    addHaxeLibrary("Type", '')
    addHaxeLibrary("Notes", '')
    addHaxeLibrary("FlxCamera", 'flixel')
    addHaxeLibrary("FlxEase", "flixel.tweens")
    addHaxeLibrary("FlxTween", "flixel.tweens")
    addHaxeLibrary("Math", "")
    addHaxeLibrary("FlxMath", "flixel.math")
    addHaxeLibrary("CoolUtil", "")
    addHaxeLibrary("FlxRect", "flixel.math")
    addHaxeLibrary("FlxSpriteUtil", "flixel.util")
    addHaxeLibrary("LineStyle", "flixel.util")
    addHaxeLibrary("FlxPath", "flixel.util")
    addHaxeLibrary("FlxPoint", "flixel.math")

end

module.strumsYPos = {50,570}-- UP, DOWN
module.strumsXCenter = {412 ,524 ,636 ,748} 
module.strumsCenter = {586, 294} -- X, Y
module.strumsRangeY = 520
module.strumsFlipRange = {336, 112, -112 , -336}
module.strumsInvertRange = {112, -112, 112 , -112}
module.strumsMiniRange = {168, 56, -56 , -168}
module.strumsCenterRange = 320
defaultPos = {}
function module.modOnCountdownStarted()
    if not disableNewCams then
        runHaxeCode([[
            for (i in 0...game.unspawnNotes.length){
                if (game.unspawnNotes[i].mustPress) {
                    game.unspawnNotes[i].camera = playerNotesCam;
                } else {
                    game.unspawnNotes[i].camera = dadNotesCam;
                }
            }
        ]])
    end
    for i = 0,7 do 
        setPropertyFromGroup("strumLineNotes", i, 'sustainReduce', disableSustainReduce== false)
    end

    REAL_STRUM_VALUE = {}
    defaultPos = {}
    for i = 0, 7 do 
        local _x = getPropertyFromGroup("strumLineNotes", i, "x")
        local _y = getPropertyFromGroup("strumLineNotes", i, "y")
        local _sx = getPropertyFromGroup("strumLineNotes", i, "scale.x")
        local _sy = getPropertyFromGroup("strumLineNotes", i, "scale.y")
        table.insert(REAL_STRUM_VALUE, {
            x = {value = _x, tween = nil},
            y = {value = _y, tween = nil},
            angle = {value = 0, tween = nil},
            scale = {x = _sx, y = _sy}
        })
       
        table.insert(defaultPos, {_x,_y,{_sx, _sy}})
    end

    runHaxeCode([[
        for (i in 0...8){
            var strum = game.strumLineNotes.members[i];
            strumsDefault[i] = [strum.x, strum.y, strum.scale.x];
            strumsCurPos[i] = [strum.x, strum.y, strum.scale.x];
            strumsOffset[i] = [0, 0, 0, 0]; // x, y, angle
        }
    ]])
  
    strumDataLoad = true
    
    
    if module.fadeCountdown then
        setMods("hide", 100, {duration = 0})

        for i = 0, 7 do 
            setMods("hide", 0, {duration = crochet/1000*2, delay = i*(crochet/1000/4)*0.85}, tostring(i))
        end
    end
       
end

function module.modSetup(disableDown, disableMiddle)
    if not disableNewCams then
        runHaxeCode([[
            playerCam = new FlxCamera();
            playerCam.bgColor = 0x0;
            playerNotesCam = new FlxCamera();
            playerNotesCam.bgColor = 0x0;

            dadCam = new FlxCamera();
            dadCam.bgColor = 0x0;
            dadNotesCam = new FlxCamera();
            dadNotesCam.bgColor = 0x0;

            FlxG.cameras.remove(game.camHUD, false);
            FlxG.cameras.remove(game.camOther, false);

            FlxG.cameras.add(dadCam, false);
            FlxG.cameras.add(dadNotesCam, false);
            FlxG.cameras.add(playerCam, false);
            FlxG.cameras.add(playerNotesCam, false);
            FlxG.cameras.add(game.camHUD, false);
            FlxG.cameras.add(game.camOther, false);

            game.remove(game.strumLineNotes);
            game.add(game.opponentStrums);
            game.add(game.playerStrums);
            game.opponentStrums.camera = dadCam;
            game.playerStrums.camera = playerCam;
        ]])
    end

    defaultDown = getPropertyFromClass("ClientPrefs", 'downScroll')
    defaultMid = getPropertyFromClass("ClientPrefs", 'middleScroll')
    defaultSplash = getPropertyFromClass("ClientPrefs", 'noteSplashes')
    if disableDown then
        setPropertyFromClass("ClientPrefs", 'downScroll', false)
    end
    if disableMiddle then
        setPropertyFromClass("ClientPrefs", 'middleScroll', false)
    end
    --setPropertyFromClass("ClientPrefs", 'noteSplashes', false)

    setupEase()
end

function module.modOnDestroy()
    setPropertyFromClass("ClientPrefs", 'downScroll', defaultDown)
    setPropertyFromClass("ClientPrefs", 'middleScroll', defaultMid)
    setPropertyFromClass("ClientPrefs", 'noteSplashes', defaultSplash)
end

function module.modOnGoodHit(id, noteData, noteType, isSus)
    if gpfg("notes", id, "ratingMod") >= 1 then 
        local scaling = getPropertyFromGroup("strumLineNotes", noteData%4 + 4, "scale.x") * 1.5
        for i = 0, getProperty("grpNoteSplashes.length")-1 do 
            setPropertyFromGroup("grpNoteSplashes", i, "scale.x", scaling)
            setPropertyFromGroup("grpNoteSplashes", i, "scale.y", scaling)
        end
        if not disableNewCams then 
            runHaxeCode([[
                for (splash in game.grpNoteSplashes){
                    if (!disableNewCams)
                        splash.camera = playerCam;
                }
            ]])
        end
    end
end

function module.modOnPause()
end

function module.modOnResume()
end

-- modchart stuff --

function module.camMove(whenTime, _isPlayer, coordinate, tweenStuff) -- never use this
    -- whenTime = time to make this run
    -- isPlayer = player cameras
    -- coordinate = {x, y, angle, type}  (type : (0 = exact), (1 = plus), (2 = minus))
    -- duration = for tweens 
    -- ease = for tweensaleph
    return;
    --[[
    table.insert(storedModchart, {
        theFunc = 
        function()
            camMoveMod(_isPlayer, coordinate, duration, _ease) 
        end,
        targetTime = whenTime,
        oldTime = -999,
        activeTime = -998
    })]]
end

function module.mods(whenTime, specialType ,intensity, tweenStuff, notes)
    -- whenTime = time to make this run
    -- specialType = mod name
    -- intensity = 0 - 100%
    -- duration = how long does it take for this to finish

    if (whenTime == "" or whenTime == " " or whenTime == nil) then 
        setMods(specialType, intensity, tweenStuff, notes) 
        return
    end

    table.insert(storedModchart, {
        theFunc = 
        function()
            setMods(specialType, intensity, tweenStuff, notes) 
        end,
        targetTime = whenTime,
        oldTime = -999,
        activeTime = -998
    })
end

function module.targetOffset(whenTime, notes, coordinate, tweenStuff, tag)
    -- whenTime = time to make this run
    -- notes = notes data (01234567)
    -- coordinate = {x, y, angle, type}  (type : (0 = exact), (1 = plus), (2 = minus))
    -- duration = for tweens 
    -- ease = for tweens

    if (whenTime == "" or whenTime == " " or whenTime == nil) then 
        targetOff(notes, coordinate, tweenStuff, tag) 
        return
    end

    
    table.insert(storedModchart, {
        theFunc = 
        function()
            targetOff(notes, coordinate, tweenStuff, tag) 
        end,
        targetTime = whenTime,
        oldTime = -999,
        activeTime = -998
    })
    
end

function module.targetPos(whenTime, notes, coordinate, tweenStuff)
    -- whenTime = time to make this run
    -- notes = notes data (01234567)
    -- coordinate = {x, y, angle, type}  (type : (0 = exact), (1 = plus), (2 = minus))
    -- duration = for tweens 
    -- ease = for tweens

    if (whenTime == "" or whenTime == " " or whenTime == nil) then 
        setTargetPos(notes, coordinate, tweenStuff) 
        return
    end
    
    table.insert(storedModchart, {
        theFunc = 
        function()
            setTargetPos(notes, coordinate, tweenStuff) 
        end,
        targetTime = whenTime,
        oldTime = -999,
        activeTime = -998
    })
    
end

function module.customNoteMod(modName, modFunc)
    table.insert(CUSTOM_MODS, {name = modName, func = modFunc})
    MODS_VALUE[modName] = {{0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}}
end

function module.direction(whenTime, notes, direction, tweenStuff)

    if (whenTime == "" or whenTime == " " or whenTime == nil) then 
        setDirection(notes, direction, tweenStuff) 
        return
    end
    
    table.insert(storedModchart, {
        theFunc = 
        function()
            setDirection(notes, direction, tweenStuff) 
        end,
        targetTime = whenTime,
        oldTime = -999,
        activeTime = -998,
    })
end

function module.timer(whenTime, functionToTrigger)

    if (whenTime == "" or whenTime == " " or whenTime == nil) then 
        functionToTrigger()
        return
    end
    
    table.insert(storedModchart, {
        theFunc = 
        function()
            functionToTrigger()
        end,
        targetTime = whenTime,
        oldTime = -999,
        activeTime = -998,
    })
end

function module.setOption(variable, value)
    if _G[variable] ~= nil then 
        _G[variable] = value 
    end
    if variable == "disableSustainReduce" then 
        for i = 0,7 do 
            setPropertyFromGroup("strumLineNotes", i, 'sustainReduce', disableSustainReduce == false)
        end
    end
end

function module.setTag(noteID, tagName)
    local tagIndex = tostring(noteID)
    if NOTES_TAG[tagIndex] == nil then
        NOTES_TAG[tagIndex] = {}
    end
    for i = 1, #NOTES_TAG[tagIndex] do 
        if NOTES_TAG[tagIndex][i] == tagName then 
            return false
        end
    end
    table.insert(NOTES_TAG[tagIndex], tagName)
end

function module.checkTag(noteID, targetTag)
    local noteIndex = tostring(noteID)
    if NOTES_TAG[noteIndex] == nil then
        return false
    end
    for i = 1, #NOTES_TAG[noteIndex] do 
        if NOTES_TAG[noteIndex][i] == targetTag then 
            return true
        end
    end
    return false
end

function module.setNoteVar(noteID, variableName, value)
    local noteIndex = tostring(noteID)
    local varIndex = tostring(variableName)
    if NOTE_CUSTOM[noteIndex] == nil then
        NOTE_CUSTOM[noteIndex] = {}
    end
    NOTE_CUSTOM[noteIndex][varIndex] = value;
end

function module.getNoteVar(noteID, variableName)
    local noteIndex = tostring(noteID)
    local varIndex = tostring(variableName)
    if NOTE_CUSTOM[noteIndex] == nil then
        return nil
    end
    return NOTE_CUSTOM[noteIndex][varIndex]
end

-- --

--


function module.modOnUpdate()
    if inGameOver then return end
    if strumDataLoad and not getProperty("startingSong") then
        for i = 1, #storedModchart do 
            local mod = storedModchart[i]
            if curStep ~= mod.oldTime then
                local checkit = checkIsTimePass(mod.targetTime)

                if checkit[1] and curStep ~= mod.oldTime then 
                    mod.oldTime = curStep
                    mod.theFunc();
                    if checkit[2] then
                        table.remove(storedModchart, 1)
                        break;
                    end
                    
                end
            end
        end
    end
    if oldStep ~= curStep then 
        oldStep = curStep
        modStep()
    end


    if strumDataLoad then
        if not disableNewCams then
            runHaxeCode([[
                var cams = [dadCam, dadNotesCam, playerCam, playerNotesCam];
                for (cam in cams){
                    cam.zoom = 1 + camNotesBeat;
                }
                camNotesBeat = FlxMath.lerp(camNotesBeat, 0, FlxG.elapsed * 5);
            ]])
        end
    end
end

function updateModValue() -- tween should use callUpdate. it can fixed bug
    for note = 1, 8 do 
        STRUM_VALUE_TOTAL[note].x = 0 
        STRUM_VALUE_TOTAL[note].y = 0 
        STRUM_VALUE_TOTAL[note].angle = 0 
    end
    for i, v in pairs(STRUM_VALUE) do -- get all functions in module and go here without "extraFunc", magic right?
        for note = 1, 8 do 
            STRUM_VALUE_TOTAL[note].x = STRUM_VALUE_TOTAL[note].x + v[note].x.value
            STRUM_VALUE_TOTAL[note].y = STRUM_VALUE_TOTAL[note].y + v[note].y.value
            STRUM_VALUE_TOTAL[note].angle = STRUM_VALUE_TOTAL[note].angle + v[note].angle.value
        end
    end
end

function module.modOnUpdatePost(elapsed)
    if (TW ~= nil) then 
        TW.Update(getPropertyFromClass("flixel.FlxG", "elapsed"))
    end
    updateModValue()

    if strumDataLoad and not inGameOver then
        strumMods()
        noteMods()
    end
end

function modStep()
    if curStep % 16 == 0 and module.noteCamsBeat and false then 
        runHaxeCode([[
            camNotesBeat = 0.03;
        ]])
    end
    if curStep % 4 == 2 then 
        local duration = crochet/1000/4/getProperty("playbackRate")
        local intensity = (curStep % 8 == 2 and 1 or -1)
        if curBpm >= 300 then
            duration = crochet/1000/4/getProperty("playbackRate")
        end
        local beatValTween = TW.Create("beatVal" , {0, intensity},duration,{EaseDirection = "linear", callupdate = function(daTween) beatVal = daTween.position end, callfunc = function()
            local beatValTween2 = TW.Create("beatVal" , {intensity, 0},duration,{EaseDirection = "linear", callupdate = function(daTween) beatVal = daTween.position end})
            beatValTween2:Play()
        end})
       beatValTween:Play()
    end
    if curStep % 4 == 0 then 
        local duration = crochet/1000/2/getProperty("playbackRate")
        local bounceValTween = TW.Create("bounceVal" , {0, 1},duration,{EaseDirection = "quadOut", callfunc = function()
            local bounceValTween2 = TW.Create("bounceVal" , {1, 0},duration, {EaseDirection = "quadIn", callUpdate = function(daTween) bounceVal = daTween.position end})
            bounceValTween2:Play()
        end, callUpdate = function(daTween) bounceVal = daTween.position end})
        bounceValTween:Play()
    end

end

function checkIsTimePass(_time)
    local timeIntoArray = {tostring(_time)}
    if type(_time) == "table" then -- is array :shock:
        timeIntoArray = _time;
    end

    for i, time in pairs(timeIntoArray) do
        local stringTime = (tostring(time):lower()):gsub(" ", "")
        if #stringTime < 1 and #time < 1 then return {false, true} end
    
        local passAllAnd = true
        for singleString in string.gmatch(stringTime, '([^%|]+)') do -- split every |
           
            local onlyTimeNumbers0 = singleString:gsub('[%p%c%s]', '')-- get numbers from target Time 
            local onlyTimeNumbers = tonumber(onlyTimeNumbers0)

            local isStep = ((singleString:find("beat") or singleString:find("b")) and false or true)
            local timeType = tonumber((isStep and curStep or curBeat))
            local valid = false;
        
            if math.floor(onlyTimeNumbers) ~= onlyTimeNumbers then 
                timeType = curDecStep
            end

            local deleteAfterPass = false
            if string.match(singleString, "%%") then -- has Remainder
                local getNumbersBeforeRe = tonumber(string.sub(singleString, 0 , string.find(singleString, "%%")-1))
                local getNumbersAfterRe = tonumber(string.match(singleString, "%%(.*)")) -- get numbers after devision
                valid = (timeType % getNumbersAfterRe) == getNumbersBeforeRe
            elseif string.find(singleString, ">") then -- has Remainder
                if string.find(singleString, "=") then 
                    valid = (timeType >= onlyTimeNumbers)
                else
                    valid = (timeType > onlyTimeNumbers)
                end
            elseif string.find(singleString, "<") then -- has Remainder
                if string.find(singleString, "=") then 
                    valid = (timeType <= onlyTimeNumbers)
                else
                    valid = (timeType < onlyTimeNumbers)
                end
            else 
                valid = (timeType == onlyTimeNumbers)
                deleteAfterPass = true
            end

            if not valid then 
                passAllAnd = false;
                break;
            end
        end
        if passAllAnd then 
            return {true, false}
        end
    end

    return {false, false}
end

function camMoveMod(isPlayer, coordinate, _tweenStuff)

    local cameraStrum = (isPlayer and "playerCam" or "dadCam")
    local cameraNotes = (isPlayer and "playerNotesCam" or "dadNotesCam")

    local cordX = (coordinate.x or 0)
    local cordY = (coordinate.y or 0)
    local cordAngle = (coordinate.angle or 0)
    local cordType = (coordinate.type or 0)
    local ease = (_tweenStuff.ease or "linear")
    local duration = (_tweenStuff.duration or 0) / getProperty("playbackRate")
    local delay = (_tweenStuff.delay or 0)

    local changeX = (coordinate.x ~= nil)
    local changeY = (coordinate.y ~= nil)
    local changeAngle = (coordinate.angle ~= nil)

    runHaxeCode([[
        var camStrum = ]]..cameraStrum..[[;
        var camNotes = ]]..cameraNotes..[[;
        var easee = getEase("]]..ease..[[");
        var duration = ]]..duration..[[;
        var delay = ]]..delay..[[;
        var specialType = ]]..cordType..[[;
        var targetX = ]]..cordX..[[ * (specialType == 2 ? -1 : 1);
        var targetY = ]]..cordY..[[ * (specialType == 2 ? -1 : 1);
        var targetAngle = ]]..cordAngle..[[ * (specialType == 2 ? -1 : 1);
        
        var changeX = ]]..(changeX and "true" or "false")..[[;
        var changeY = ]]..(changeY and "true" or "false")..[[;
        var changeAngle = ]]..(changeAngle and "true" or "false")..[[;

        var resultXs = targetX + (specialType >= 1 ? camStrum.x : 0);
        var resultXn = targetX + (specialType >= 1 ? camNotes.x : 0);

        var resultYs = targetY + (specialType >= 1 ? camStrum.y : 0);
        var resultYn = targetY + (specialType >= 1 ? camNotes.y : 0);

        var resultAngles = targetAngle + (specialType >= 1 ? camStrum.angle : 0) * (specialType == 2 ? -1 : 1);
        var resultAnglen = targetAngle + (specialType >= 1 ? camNotes.angle : 0) * (specialType == 2 ? -1 : 1);

        if (duration <= 0){
            if (changeX) {
                camStrum.x = resultXs;
                camNotes.x = resultXn;
            }
            if (changeY) {
                camStrum.y = resultYs;
                camNotes.y = resultYn;
            }
            if (changeAngle) {
                camStrum.angle = resultAngles;
                camNotes.angle = resultAnglen;
            }
        } else {
            if (changeX) {
                FlxTween.cancelTweensOf(camStrum.x);
                FlxTween.cancelTweensOf(camNotes.x);
                var tweenStrum = FlxTween.tween(camStrum, {x: resultXs}, duration, {startDelay: delay, ease: easee, onComplete: function(twn){
                    modTweens.remove(twn);
                }});
                modTweens.push(tweenStrum);

                var tweenNotes = FlxTween.tween(camNotes, {x: resultXn}, duration, {startDelay: delay, ease: easee, onComplete: function(twn){
                    modTweens.remove(twn);
                }});
                modTweens.push(tweenNotes);
            } 
            if (changeY) {
                FlxTween.cancelTweensOf(camStrum.y);
                FlxTween.cancelTweensOf(camNotes.y);
                var tweenStrum = FlxTween.tween(camStrum, {y: resultYs}, duration, {startDelay: delay, ease: easee, onComplete: function(twn){
                    modTweens.remove(twn);
                }});
                modTweens.push(tweenStrum);

                var tweenNotes = FlxTween.tween(camNotes, {y: resultYn}, duration, {startDelay: delay, ease: easee, onComplete: function(twn){
                    modTweens.remove(twn);
                }});
                modTweens.push(tweenNotes);
            }
            if (changeAngle) {
                FlxTween.cancelTweensOf(camStrum.angle);
                FlxTween.cancelTweensOf(camNotes.angle);
                var tweenStrum = FlxTween.tween(camStrum, {angle: resultAngles}, duration, {startDelay: delay, ease: easee, onComplete: function(twn){
                    modTweens.remove(twn);
                }});
                modTweens.push(tweenStrum);

                var tweenNotes = FlxTween.tween(camNotes, {angle: resultAnglen}, duration, {startDelay: delay, ease: easee, onComplete: function(twn){
                    modTweens.remove(twn);
                }});
                modTweens.push(tweenNotes);
            }
        }

    ]])
end

function targetOff(notes, coordinate, _tweenStuff, _tag)

    local notesArray = {}
    for i = 1, #notes do
        table.insert(notesArray, notes:sub(i, i))
     end
 

    local tweenStuff = (_tweenStuff or { duration = 0, ease = "linear", delay = 0})
    local cordX = (coordinate.x or 0)
    local cordY = (coordinate.y or 0)
    local cordAngle = (coordinate.angle or 0)
    local cordType = (coordinate.type or 0)
    local ease = (tweenStuff.ease or "linear")
    local duration = (tweenStuff.duration or 0) / getProperty("playbackRate")
    local delay = (tweenStuff.delay or 0)

    local changeX = (coordinate.x ~= nil)
    local changeY = (coordinate.y ~= nil)
    local changeAngle = (coordinate.angle ~= nil)
    local tag = (_tag or "default")

    createNewStrumTag(tag)

    for i = 1, #notesArray do 
        local note = notesArray[i] + 1
        if changeX then
            local bValue = (STRUM_VALUE[tag][note].x.value or 0)
            if duration <= 0 then 
                STRUM_VALUE[tag][note].x.tween = nil
                STRUM_VALUE[tag][note].x.value = cordX
            else
                local tween = TW.Create(tag.."strumx"..note,{bValue,cordX},duration,{EaseDirection = ease, callfunc = 
                function()
                    STRUM_VALUE[tag][note].x.value = cordX
                    STRUM_VALUE[tag][note].x.tween = nil
                end, callUpdate = function(daTween)
                    STRUM_VALUE[tag][note].x.value = daTween.position
                end})
                tween:Play()
                STRUM_VALUE[tag][note].x.tween = tween
            end
        end
        if changeY then
            local bValue = (STRUM_VALUE[tag][note].y.value or 0)
            if duration <= 0 then 
                STRUM_VALUE[tag][note].y.tween = nil
                STRUM_VALUE[tag][note].y.value = cordY
            else
                local tween = TW.Create(tag.."strumy"..note,{bValue,cordY},duration,{EaseDirection = ease, callfunc = 
                function()
                    STRUM_VALUE[tag][note].y.value = cordY
                    STRUM_VALUE[tag][note].y.tween = nil
                end, callUpdate = function(daTween)
                    STRUM_VALUE[tag][note].y.value = daTween.position
                end})
                tween:Play()
                STRUM_VALUE[tag][note].y.tween = tween
            end
        end
        if changeAngle then
            local bValue = (STRUM_VALUE[tag][note].angle.value or 0)
            if duration <= 0 then 
                STRUM_VALUE[tag][note].angle.tween = nil
                STRUM_VALUE[tag][note].angle.value = cordAngle
            else
                local tween = TW.Create(tag.."strumangle"..note,{bValue,cordAngle},duration,{EaseDirection = ease, callfunc = 
                function()
                    STRUM_VALUE[tag][note].angle.value = cordAngle
                    STRUM_VALUE[tag][note].angle.tween = nil
                end, callUpdate = function(daTween)
                    STRUM_VALUE[tag][note].angle.value = daTween.position
                end})
                tween:Play()
                STRUM_VALUE[tag][note].angle.tween = tween
            end
        end
    end
end

function setTargetPos(notes, coordinate, _tweenStuff)
    local notesArray = {}
    for i = 1, #notes do
        table.insert(notesArray, notes:sub(i, i))
     end

    local cordX = (coordinate.x or 0)
    local cordY = (coordinate.y or 0)
    local cordAngle = (coordinate.angle or 0)
    local cordType = (coordinate.type or 0)
    local ease = (_tweenStuff.ease or "linear")
    local duration = (_tweenStuff.duration or 0) / getProperty("playbackRate")
    local delay = (_tweenStuff.delay or 0)

    local changeX = (coordinate.x ~= nil)
    local changeY = (coordinate.y ~= nil)
    local changeAngle = (coordinate.angle ~= nil)

    
    for i = 1, #notesArray do 
        local note = notesArray[i] + 1
        if changeX then
            local intensity = cordX
            if (string.lower(cordX) == "default" or string.lower(cordX) == "") then intensity = defaultPos[note][1] end
            local bValue = (REAL_STRUM_VALUE[note].x.value or 0)
            if duration <= 0 then 
                REAL_STRUM_VALUE[note].x.tween = nil
                REAL_STRUM_VALUE[note].x.value = intensity
            else
                local tween = TW.Create("real".."strumx"..note,{bValue,intensity},duration,{EaseDirection = ease, callfunc = 
                function()
                    REAL_STRUM_VALUE[note].x.value = intensity
                    REAL_STRUM_VALUE[note].x.tween = nil
                end, callUpdate = function(daTween)
                    REAL_STRUM_VALUE[note].x.value =  daTween.position
                end})
                tween:Play()
                REAL_STRUM_VALUE[note].x.tween = tween
            end
        end
        if changeY then
            local intensity = cordY
            if (string.lower(cordY) == "default" or string.lower(cordY) == "") then intensity = defaultPos[note][2] end
            local bValue = (REAL_STRUM_VALUE[note].y.value or 0)
            if duration <= 0 then 
                REAL_STRUM_VALUE[note].y.tween = nil
                REAL_STRUM_VALUE[note].y.value = intensity
            else
                local tween = TW.Create("real".."strumy"..note,{bValue,intensity},duration,{EaseDirection = ease, callfunc = 
                function()
                    REAL_STRUM_VALUE[note].y.value = intensity
                    REAL_STRUM_VALUE[note].y.tween = nil
                end, callUpdate = function(daTween)
                    REAL_STRUM_VALUE[note].y.value =  daTween.position
                end})
                tween:Play()
                REAL_STRUM_VALUE[note].y.tween = tween
            end
        end
        if changeAngle then
            local intensity = cordAngle
            if (string.lower(cordAngle) == "default" or string.lower(cordAngle) == "") then intensity = 0 end
            local bValue = (REAL_STRUM_VALUE[note].angle.value or 0)
            if duration <= 0 then 
                REAL_STRUM_VALUE[note].angle.tween = nil
                REAL_STRUM_VALUE[note].angle.value = intensity
            else
                local tween = TW.Create("real".."strumangle"..note,{bValue,intensity},duration,{EaseDirection = ease, callfunc = 
                function()
                    REAL_STRUM_VALUE[note].angle.value = intensity
                    REAL_STRUM_VALUE[note].angle.tween = nil
                end, callUpdate = function(daTween)
                    REAL_STRUM_VALUE[note].angle.value =  daTween.position
                end})
                tween:Play()
                REAL_STRUM_VALUE[note].angle.tween = tween
            end
        end
    end
end

function createNewStrumTag(tag)
    if (STRUM_VALUE[tag] == nil) then
        STRUM_VALUE[tag] = {
            {x = {value = 0, tween = nil}, y = {value = 0, tween = nil}, angle = {value = 0, tween = nil}},
            {x = {value = 0, tween = nil}, y = {value = 0, tween = nil}, angle = {value = 0, tween = nil}},
            {x = {value = 0, tween = nil}, y = {value = 0, tween = nil}, angle = {value = 0, tween = nil}},
            {x = {value = 0, tween = nil}, y = {value = 0, tween = nil}, angle = {value = 0, tween = nil}},
            {x = {value = 0, tween = nil}, y = {value = 0, tween = nil}, angle = {value = 0, tween = nil}},
            {x = {value = 0, tween = nil}, y = {value = 0, tween = nil}, angle = {value = 0, tween = nil}},
            {x = {value = 0, tween = nil}, y = {value = 0, tween = nil}, angle = {value = 0, tween = nil}},
            {x = {value = 0, tween = nil}, y = {value = 0, tween = nil}, angle = {value = 0, tween = nil}}
        }
    end
end

function setMods(_special, _intensity, _tweenStuff, _notes)
    local notes = (_notes or "01234567")
    local intensity = (_intensity == DEFAULT_VALUE and 0 or (_intensity or 100))

    local tweenStuff = (_tweenStuff or {duration = 0, ease = "linear", delay = 0})
    local duration = (tweenStuff.duration or crochet/1000*4) / getProperty("playbackRate")
    local ease = (tweenStuff.ease or "linear")
    local delay = (tweenStuff.delay or 0)
    local special = (_special or "wiggle")

    local notesArray = {}
    for i = 1, #notes do
       table.insert(notesArray, notes:sub(i, i))
    end

    
   -- debugPrint(MODS_VALUE[special][1][1])
    for i = 1, #notesArray do 
        local note = notesArray[i] + 1
     
        local mod = MODS_VALUE[special][note]
        if duration <= 0 then
            MODS_VALUE[special][note][2] = nil
            MODS_VALUE[special][note][1] = intensity
        else
            local tween = TW.Create(special..note,{MODS_VALUE[special][note][1],intensity},duration,{EaseDirection = ease, callfunc = 
            function()
                MODS_VALUE[special][note][1] = intensity
                mod[2] = nil
            end, callUpdate = function(daTween)
                MODS_VALUE[special][note][1] = daTween.position
            end})
            tween:Play()
            MODS_VALUE[special][note][2] = tween
        end
    end
    
end

function setDirection(_notes, _direction, _tweenStuff)
    local notes = (_notes or "01234567")
    local direction = (_direction or 90)

    local tweenStuff = (_tweenStuff or {duration = 0, ease = "linear", delay = 0})
    local duration = (tweenStuff.duration or crochet/1000*4) / getProperty("playbackRate")
    local ease = (tweenStuff.ease or "linear")
    local delay = (tweenStuff.delay or 0)

    local notesInComma = "";
    local notesArray = {}
    for i = 1, #notes do
        table.insert(notesArray, notes:sub(i, i))
     end

    for i = 1, #notesArray do 
        local note = notesArray[i] + 1
        if duration <= 0 then
            DIR_VALUE[note][2] = nil
            DIR_VALUE[note][1] = direction
        else
            local modTween = TW.Create("dire"..note,{DIR_VALUE[note][1],direction},duration,{EaseDirection = ease, callfunc = 
            function()
                DIR_VALUE[note][1] = direction
                DIR_VALUE[note][2] = nil
            end, callUpdate = function(daTween)
                DIR_VALUE[note][1] = daTween.position
            end})

            modTween:Play()
            DIR_VALUE[note][2] = modTween
        end
    end

    runHaxeCode([[
        var notesArray = []]..notesInComma..[[];

        var newDirection = ]]..direction..[[;
        var duration = ]]..duration..[[;
        var delay = ]]..delay..[[;

        for (noteID in notesArray){
            var strum = game.strumLineNotes.members[noteID];
           
            if (duration <= 0){
                strum.direction = newDirection;
                continue;
            }
            if (strumsDirectionTween[noteID] != null) {
                strumsDirectionTween[noteID].cancel();
            }
            strumsDirectionTween[noteID] = FlxTween.tween(strum, {direction : newDirection}, duration, {startDelay: delay, ease: getEase("]]..ease..[[") ,onComplete: function(twn){
                strumsDirectionTween[noteID] = null;
            }});
        }
    ]])
end



function setupEase()
    runHaxeCode([[
        getEase = function(stringEase){
            var findEase = stringEase.toLowerCase();
            if (findEase == 'backin') return FlxEase.backIn;
            else if (findEase == 'backinout') return FlxEase.backInOut;
            else if (findEase == 'backout') return FlxEase.backOut;
            else if (findEase == 'bouncein') return FlxEase.bounceIn;
            else if (findEase == 'bounceinout') return FlxEase.bounceInOut;
            else if (findEase == 'bounceout') return FlxEase.bounceOut;
            else if (findEase == 'circin') return FlxEase.circIn;
            else if (findEase == 'circinout') return FlxEase.circInOut;
            else if (findEase == 'circout') return FlxEase.circOut;
            else if (findEase == 'cubein') return FlxEase.cubeIn;
            else if (findEase == 'cubeinout') return FlxEase.cubeInOut;
            else if (findEase == 'cubeout') return FlxEase.cubeOut;
            else if (findEase == 'elasticin') return FlxEase.elasticIn;
            else if (findEase == 'elasticinout') return FlxEase.elasticInOut;
            else if (findEase == 'elasticout') return FlxEase.elasticOut;
            else if (findEase == 'expoin') return FlxEase.expoIn;
            else if (findEase == 'expoinout') return FlxEase.expoInOut;
            else if (findEase == 'expoout') return FlxEase.expoOut;
            else if (findEase == 'quadin') return FlxEase.quadIn;
            else if (findEase == 'quadinout') return FlxEase.quadInOut;
            else if (findEase == 'quadout') return FlxEase.quadOut;
            else if (findEase == 'quartin') return FlxEase.quartIn;
            else if (findEase == 'quartinout') return FlxEase.quartInOut;
            else if (findEase == 'quartout') return FlxEase.quartOut;
            else if (findEase == 'quintin') return FlxEase.quintIn;
            else if (findEase == 'quintinout') return FlxEase.quintInOut;
            else if (findEase == 'quintout') return FlxEase.quintOut;
            else if (findEase == 'sinein') return FlxEase.sineIn;
            else if (findEase == 'sineinout') return FlxEase.sineInOut;
            else if (findEase == 'sineout') return FlxEase.sineOut;
            else if (findEase == 'smoothstepin') return FlxEase.smoothStepIn;
            else if (findEase == 'smoothstepinout') return FlxEase.smoothStepInOut;
            else if (findEase == 'smoothstepout') return FlxEase.smoothStepInOut;
            else if (findEase == 'smootherstepin') return FlxEase.smootherStepIn;
            else if (findEase == 'smootherstepinout') return FlxEase.smootherStepInOut;
            else if (findEase == 'smootherstepout') return FlxEase.smootherStepOut;
            else return FlxEase.linear;
        }
    ]])
end

local totalElapsed = 0
local floatID = {1, 3, 4, 2}
local tiltID = {-2, -1, 1, 2}
function strumMods()
    totalElapsed = totalElapsed + getPropertyFromClass("flixel.FlxG", "elapsed") * getProperty("playbackRate")
   
    for i = 0, 7 do 
        local strumPos = REAL_STRUM_VALUE[i+1]
        local centerX = (i < 4 and ((REAL_STRUM_VALUE[3].x.value + REAL_STRUM_VALUE[2].x.value)/2) or ((REAL_STRUM_VALUE[3+4].x.value + REAL_STRUM_VALUE[2+4].x.value)/2))

        local miniScale = -getModValue("mini", i + 1)/4
        local mini = (module.strumsMiniRange[i%4+1]/2.75) * (getModValue("mini", i + 1))
        
        local reverse = (module.strumsRangeY * getModValue("reverse", i + 1)) * (downscroll and -1 or 1)* (1 - getModValue("centered", i + 1))

        local centered = (module.strumsCenter[2] - module.strumsYPos[1]) * getModValue("centered", i + 1)
    
        local drift = math.sin(totalElapsed*1.4+((i%4)*0.38)) * (getModValue("drift", i + 1)*30)

        local float = math.sin(totalElapsed*1.45+(floatID[i%4+1])) * (getModValue("float", i + 1)*30)

        local flip = module.strumsFlipRange[i%4+1] * (getModValue("flip", i + 1))

        local invert = module.strumsInvertRange[i%4+1] * (getModValue("invert", i + 1)) * (1 - getModValue("mini", i + 1)/4) -- PROBLEM OFFSET

        local scaleXwideThin = (getModValue("wide", i + 1)/4) - (getModValue("thin", i + 1)/7)
        local scaleYwideThin = (getModValue("thin", i + 1)/4) - (getModValue("wide", i + 1)/7)

        local shakeX = getRandomFloat(getModValue("shake", i + 1)*-10, getModValue("shake", i + 1)*10)
        local shakeY = getRandomFloat(getModValue("shake", i + 1)*-10, getModValue("shake", i + 1)*10)

        local spin = ((totalElapsed) * (getModValue("spin", i + 1)*100))%360

        local middle = (i < 4 and module.strumsCenterRange or -module.strumsCenterRange) * getModValue("middle", i + 1) * (getPropertyFromClass("ClientPrefs", 'middleScroll') and 0 or 1)

        local hide = 1 - getModValue("hide", i + 1)

        local beat = beatVal * getModValue("beat", i + 1) * 30

        local bounce = bounceVal  * getModValue("bounce", i + 1) * -30

        local tilt = tiltID[i%4+1] * getModValue("tilt", i + 1) * 15

        local big = getModValue("big", i + 1)/2

        setPropertyFromGroup("strumLineNotes",i, "x", strumPos.x.value + STRUM_VALUE_TOTAL[i + 1].x + mini + drift + flip + invert + shakeX + middle + beat)
        setPropertyFromGroup("strumLineNotes",i, "y", strumPos.y.value + STRUM_VALUE_TOTAL[i + 1].y + reverse + centered + float + shakeY + bounce + tilt)
        setPropertyFromGroup("strumLineNotes",i, "angle", strumPos.angle.value + STRUM_VALUE_TOTAL[i + 1].angle + spin)
        setPropertyFromGroup("strumLineNotes",i, "alpha", hide)
        setPropertyFromGroup("strumLineNotes",i, "scale.x", strumPos.scale.x + big + miniScale + scaleXwideThin)
        setPropertyFromGroup("strumLineNotes",i, "scale.y", strumPos.scale.y + big + miniScale + scaleYwideThin)
        setPropertyFromGroup("strumLineNotes",i, "direction", DIR_VALUE[i + 1][1])
        
    end
    
end

function getModValue(specialName, id)
    if (MODS_VALUE[specialName == nil]) then return 0; end
    return MODS_VALUE[specialName][id][1]/100
end

function noteMods()
    
   for i = 0, getProperty("notes.length")-1 do 
        if checkTag(gpfg("notes", i, "ID"), "noMod") then goto continue end
        local noteData = (gpfg("notes", i, "noteData")%4) + (gpfg("notes", i, "mustPress") and 4 or 0) -- note's data (left, down, up, right)
        local noteDistance =  (getSongPosition() - gpfg("notes", i, "strumTime")) * -0.01 -- note distance to press
        local isSus = gpfg("notes", i, "isSustainNote")
        local isTail = (string.find( gpfg("notes",i,"animation.curAnim.name"), "holdend" ) )
        local direction = gpfg("strumLineNotes", noteData, "direction")
        local radians = (180 - direction) * math.pi / 180;
        local radians2 = direction * math.pi / 180;

        local susFix = (isSus and gpfg("strumLineNotes", noteData, "width")/2 - gpfg("notes", i, "width")/2 or 0)
        local susAlphaFix = (isSus and 0.6 or 1)

        local mods = modsMath(noteDistance, i, direction, noteData)
        local modX, modY, modAlpha = mods.x, mods.y, mods.alpha
        local modAngle, modSpeed = mods.angle, mods.speed

        setPropertyFromGroup("notes",i,"offsetX", (susFix) + (math.sin(radians) * modX) + (math.cos(radians) * modY))
        setPropertyFromGroup("notes",i,"offsetY", (math.cos(radians) * modX) + (math.sin(radians) * modY))
        if isTail then 
            local offsetYY = math.cos(radians2) * (susFix);
            local offsetXX = math.cos(radians2) * (susFix/-2);
            setPropertyFromGroup("notes",i,"offsetY", getPropertyFromGroup("notes",i,"offsetY") + offsetYY)
            setPropertyFromGroup("notes",i,"offsetX", getPropertyFromGroup("notes",i,"offsetX") + offsetXX)
        end
        setPropertyFromGroup("notes",i,"multSpeed", modSpeed)
        if getPropertyFromGroup("notes",i, "copyAlpha") then
            setPropertyFromGroup("notes",i,"alpha", susAlphaFix * modAlpha)
        end
        
        setPropertyFromGroup("notes",i,"scale.x", math.abs(gpfg("strumLineNotes", noteData, "scale.x")))
        if not isSus then
            setPropertyFromGroup("notes",i,"offsetAngle", modAngle)
            setPropertyFromGroup("notes",i,"scale.y", math.abs(gpfg("strumLineNotes", noteData, "scale.y")))
        end
        ::continue::
    end
    if not disableSusAngleFixer then
        fixNoteDirection()
    end
    if not disableSustainReduceFixer then 
        cliprectFix()
    end
   
end

local tornadoData = {-1, 1.2, -1.37, 1.08}; 
local beatData = {1.01, 1.11, 1.21, 1.051}
local driftData = {1, 1.1, 1.2, 0.9}
function modsMath(noteTime, _noteID, _direction, strumData)
    
    local direction = (_direction or 0)
    local noteID = (_noteID or nil)
    local noteDistance = noteTime / scrollSpeed * 2.3;

    local beatIntense = (beatVal * (MODS_VALUE.beat[strumData+1][1]/100) * 30)
    local beatWiggle = beatIntense - math.sin(noteDistance*1.87*beatData[strumData%4 + 1]) * beatIntense
    local wiggleR = (math.sin(noteDistance * (MODS_VALUE.wiggleFreq[strumData+1][1]/100 + 1)) * (MODS_VALUE.wiggle[strumData+1][1]/10 * 5))
    local driftIntense = MODS_VALUE.drift[strumData+1][1]/100
    local driftR = (math.sin(noteDistance*0.6) * (driftIntense * 40 * driftData[strumData%4 + 1] ))
    
    local tornadoR = math.sin(noteDistance * tornadoData[strumData%4 + 1] * 0.4) * (MODS_VALUE.tornado[strumData+1][1]/100 * -80)
    local accel = (math.sin(noteDistance*0.45) * (MODS_VALUE.accel[strumData+1][1]/10 * 8))
    local floatS = 1 - ((math.sin(totalElapsed*0.6) * (MODS_VALUE.float[strumData+1][1]/100) * 0.1)^2)
    local dizzyA = ((MODS_VALUE.dizzy[strumData+1][1]/100*25) * noteDistance)
    local reverseS = ((1 - (MODS_VALUE.reverse[strumData+1][1]/100*2)))
    local miniR = ((1 + MODS_VALUE.mini[strumData+1][1]/-100/2.75))
    local speed = 1 + getModValue("speed", strumData + 1)

    local fadeInIntense, fadeInOff = (MODS_VALUE.fade_in[strumData+1][1]/100), (MODS_VALUE.fade_in_offset[strumData+1][1]/100)
    local fadeIn = 1 - (boundTo(((noteDistance - (5 + fadeInOff))*2) ,0, 1) * fadeInIntense)

    local fadeOutIntense, fadeOutOff = (MODS_VALUE.fade_out[strumData+1][1]/100), (MODS_VALUE.fade_out_offset[strumData+1][1]/100)
    local fadeOut = 1 - (boundTo(((noteDistance - (3 + fadeOutOff))*-2) ,0, 1) * fadeOutIntense)
    local invisible = (1-(MODS_VALUE.invisible[strumData+1][1]/100))

    local modderX = beatWiggle + wiggleR + driftR + tornadoR-- + getCustomNotes(_noteID, "x")
    local modderY = accel-- + getCustomNotes(_noteID, "y")
    local modderAngle = dizzyA--  + getCustomNotes(_noteID, "angle")
    local modderSpeed = 1 * reverseS * floatS * miniR * speed-- * getCustomNotes(_noteID, "speed")
    local modderAlpha = invisible * fadeIn * fadeOut-- * getCustomNotes(_noteID, "alpha")
    
    if #CUSTOM_MODS > 0 then
        for i = 1, #CUSTOM_MODS do 
            local customModStuff = CUSTOM_MODS[i].func(getModValue(CUSTOM_MODS[i].name, strumData%8 + 1), {
                distance = noteDistance, 
                id = noteID, 
                direction = direction, 
                noteData = strumData, 
                strumTime = noteTime
            }) --noteTime, _noteID, _direction, strumData
            if customModStuff.x ~= nil then modderX = modderX + (customModStuff.x); end
            if customModStuff.y ~= nil then modderY = modderY + (customModStuff.y); end
            if customModStuff.angle ~= nil then modderAngle = modderAngle + (customModStuff.angle); end
            if customModStuff.speed ~= nil then modderSpeed = modderSpeed * (customModStuff.speed); end
        end
    end

    local modX = modderX
    local modY = modderY * ((direction%360 > 180 and direction%360 <= 359) and -1 or 1)
    local modAngle = modderAngle
    local modSpeed = modderSpeed
    local modAlpha = modderAlpha

    return {x = modX, y = modY, angle = modAngle, speed = modSpeed, alpha = modAlpha}
end

function fixNoteDirection()
    for note = 0, getProperty("notes.length")-1 do 
       if true then
          local data = getPropertyFromGroup("notes", note, "noteData") + (getPropertyFromGroup("notes", note, "mustPress") and 4 or 0)
          local firstSustain = gpfg("notes",note, "prevNote.isSustainNote") == false
          local isTail = (string.find( gpfg("notes",note,"animation.curAnim.name"), "end" ))
          local nextNoteExist = getProperty("notes.members["..(note-1).."]") ~= nil
          local prevNoteExist = getProperty("notes.members["..(note+1).."]") ~= nil
          local isLastNote = gpfg("notes",note,"ID") == gpfg("notes", 0 ,"ID")
          local speedBack = gpfg("notes", note, "multSpeed") <= 0 and 180 or 0
          if gpfg("notes",note,"isSustainNote") then
             if not isTail then 
                if nextNoteExist and prevNoteExist and gpfg("notes",note,"prevNote.isSustainNote") then
                    local stuff = notesTan("prevNote.", "nextNote.", note)
                    local nextNoteX, nextNoteY = stuff.next.x, stuff.next.y
                    local prevNoteX, prevNoteY = stuff.prev.x, stuff.prev.y
 
                   local rad = math.atan2(nextNoteY - prevNoteY, nextNoteX - prevNoteX)
                   local deg = rad * (180 / math.pi)
 
                   setPropertyFromGroup("notes", note, "angle", deg - 90 + speedBack)
                else 
                   if not nextNoteExist and prevNoteExist then 
                      local stuff = notesTan("prevNote.", "", note)
                      local nextNoteX, nextNoteY = stuff.next.x, stuff.next.y
                      local prevNoteX, prevNoteY = stuff.prev.x, stuff.prev.y
    
                      local rad = math.atan2(nextNoteY - prevNoteY, nextNoteX - prevNoteX)
                      local deg = rad * (180 / math.pi)
 
                      setPropertyFromGroup("notes", note, "angle", deg - 90 + speedBack) 
                   end
                   if (not prevNoteExist and nextNoteExist) or not gpfg("notes",note,"prevNote.isSustainNote")  then
                      local stuff = notesTan("", "nextNote.", note)
                      local nextNoteX, nextNoteY = stuff.next.x, stuff.next.y
                      local prevNoteX, prevNoteY = stuff.prev.x, stuff.prev.y
    
                      local rad = math.atan2(nextNoteY - prevNoteY, nextNoteX - prevNoteX)
                      local deg = rad * (180 / math.pi)
 
                      setPropertyFromGroup("notes", note, "angle", deg - 90 + speedBack) 
                   end
                end
             else -- tail
                if gpfg("notes",note,"prevNote") ~= nil then 
                   local stuff = notesTan("prevNote.", "", note)
                   local nextNoteX, nextNoteY = stuff.next.x, stuff.next.y
                   local prevNoteX, prevNoteY = stuff.prev.x, stuff.prev.y
 
                   local rad = math.atan2(nextNoteY - prevNoteY, nextNoteX - prevNoteX)
                   local deg = rad * (180 / math.pi)
 
                   setPropertyFromGroup("notes", note, "angle", deg - 90 + speedBack)--gpfg("notes", note, "prevNote.angle")
                else 
                   setPropertyFromGroup("notes", note, "angle", gpfg("strumLineNotes", data, "direction"))
                end
                setPropertyFromGroup("notes", note, "flipY", true)
                setPropertyFromGroup("notes", note, "angle", getPropertyFromGroup("notes", note, "angle") + 180 + speedBack)
             end
          else 
               setPropertyFromGroup("notes", note, "angle", gpfg("strumLineNotes", data, "angle"))
          end
       end
    end
end

function cliprectFix()
    runHaxeCode([[ 
        var PI = Math.PI;
        var songPos = ]]..getSongPosition()..[[;
        
       game.notes.forEachAlive(function(daNote){
      
        var strum = game.strumLineNotes.members[daNote.noteData%4 + (daNote.mustPress ? 4 : 0)];
        var direction = (strum.direction) - (daNote.multSpeed <= 0 ? 180 : 0) - (downscroll ? 180 : 0);

        if (!daNote.isSustainNote) return; 
        if (strum.animation.curAnim.name != "confirm") return;

        var radians = (180 - direction) * PI / 180;
        var radians2 = (direction - 180) * PI / 180;

        var noteX = (daNote.x + (daNote.width/2)); //((daNote.width/2)*FlxMath.fastCos(radians));
        var noteY = (daNote.y + (daNote.height/2)); //((daNote.height/2)*FlxMath.fastSin(radians2));
        var strumY = strum.y + (strum.height*0.5);
        var strumX = strum.x + (strum.width*0.5);

        var distanceA = (daNote.strumTime - songPos) * Math.abs(daNote.scale.y) * (game.songSpeed/7);
        
        var objectYnoDir = (FlxMath.fastSin(direction-90) * (strumX - daNote.x)) + (FlxMath.fastCos(direction-90) * (strumY - daNote.y));
       
        var clipY = (daNote.frameHeight - distanceA) / Math.abs(daNote.scale.y);
        var clipYBound = boundTo(clipY, 0, daNote.frameHeight);
        daNote.clipRect = new FlxRect(0, clipYBound , daNote.frameWidth, daNote.frameHeight);
       })
    ]])

end

function notesTan(prev, next, note)
    local nextNoteStuff = getMidPoint(gpfg("notes", note, next.."x"), gpfg("notes", note, next.."y"), gpfg("notes", note, next.."width"), gpfg("notes", note, next.."height"))
    local prevNoteStuff = getMidPoint(gpfg("notes", note, prev.."x"), gpfg("notes", note, prev.."y"), gpfg("notes", note, prev.."width"), gpfg("notes", note, prev.."height"))
    return {prev = prevNoteStuff, next = nextNoteStuff}
end
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
function boundTo(value, min, max) return math.max(min, math.min(max, value)) end
function gpfg(in1, in2, in3)return getPropertyFromGroup(in1, in2, in3) end
function getMidPoint(_x, _y ,_width, _height)
    return {
      x = _x + _width * 0.5,
      y = _y + _height * 0.5
    }
end
--function lerp(a,b,t) return a * (1-t) + b * t end
function getParentPath(_path)
    local path = _path:gsub("/", "\\")
    pathLetter = "\\"

    local _, amountSymbol = path:gsub(pathLetter, "") -- count symbol \ \
    local index = 0;
    local count = 0;
    for i = 1, path:len() do 
        if path:sub(i, i) == pathLetter then 
            count = count + 1
            if count == amountSymbol then 
                index = i
                break;
            end
        end
    end
   
    return path:sub(1, index - 1)
end

return module