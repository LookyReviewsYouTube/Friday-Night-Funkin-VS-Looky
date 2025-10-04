hudZoom = 1;
hudZoomBeat = 0;
lensIntensity = 0
lensIntensityBeat, lensIntensityBeatLerp = 0, 0
moveSpeedThing = 0

updateITime = {}

changeTimed = 1;
spongeColor = {"f2f2f2","c4ebb0", "d6ebb0", "f2f2f2", "faf6ac", "dff598"}
scrollBGSpeed = 1;

bpmCounter = 250;

shakeMode = false

local voidDuration = 0.6;
local voidEase = "quadInOut"

local voidCircleAmount = 0

local circleGroup = {}

local shaderEnable = true
local scoreTxtY = 676.8

local sca = {}
stepDone = {}
function onCreate()
    luaDebugMode = true
    shaderEnable = getPropertyFromClass("ClientPrefs", "shaders")
    setPropertyFromClass("ClientPrefs", "shaders", true)
    setProperty("isCameraOnForcedPos", true)
    --setGlobalFromScript("scripts/0_newUI", "hideHPbar", false)
    --setGlobalFromScript("scripts/0_newUI", "smoothHP", false)

    setProperty("skipCountdown", true)
end

function onDestroy()
    setPropertyFromClass("ClientPrefs", "shaders", shaderEnable)
    runHaxeCode([[
        Main.fpsVar.background = false;  
        Main.fpsVar.backgroundColor = 0x000000;
        Main.fpsVar.x = 10;
        Main.fpsVar.y = 3;
    ]])

end

local offset = {-200 , -200}
function onCreatePost()
    runHaxeCode([[
        var sprites = [];
        var texts = [];
        var scripts = [];

        for (spriteName in game.modchartSprites.keys()){
            sprites.push(spriteName);
        }
        for (textName in game.modchartTexts.keys()){
            texts.push(textName);
        }
        for (script in game.luaArray){
            scripts.push(script.scriptName);
        }

        setVar("hudSprites", sprites);
        setVar("hudText", texts);
        setVar("scripts", scripts);
    ]])

    local scripts = getProperty('scripts')
    for i = 1, #scripts do 
        local file = assert(io.open(scripts[i], "rb"))
        local content = file:read("*all")
        file:close()
        if not string.find(content, "aleph") then 
            table.insert(sca, scripts[i])
        end
    end
    addHaxeLibrary("Main")
    runHaxeCode([[
        Main.fpsVar.backgroundColor = 0xFF0000;
        Main.fpsVar.background = false;
        Main.fpsVar.border = false;
    ]])


    initLuaShader('split')
    initLuaShader('scroll')
    if shaderEnable then
        initLuaShader('lensDis')
        initLuaShader('chromRadial')
    end
    makeLuaSprite("lensShader", "", 0, 0)
    makeLuaSprite("camPos", "", 0, 0)
    makeLuaSprite("splitShader", "", 0, 0)
    makeLuaSprite("chromShader", "", 0, 0)
    
    makeLuaSprite("eplipsyBG", "" ,0, 0)
    makeGraphic("eplipsyBG", 2000, 1800, "8a8a8a")
    screenCenter("eplipsyBG")
    setScrollFactor("eplipsyBG", 0, 0)
    setProperty("eplipsyBG.alpha",0)
    setBlendMode("eplipsyBG", "screen")

    makeLuaSprite("whiteBG", "" ,0, 0)
    makeGraphic("whiteBG", 2000, 1800, "FFFFFF")
    screenCenter("whiteBG")
    addLuaSprite("whiteBG", true)
    setObjectCamera("whiteBG", "hud")
    setProperty("whiteBG.alpha", 0)

    createNormalStage()

    addLuaSprite("eplipsyBG", false)

    makeSprite("sponge", "aleph/sponge", 80, 0, 1, 1, true)
    makeSprite("voidBG", "aleph/voidBG", -80, -50, 0, 1.1, true)
    makeSprite("voidWGrid", "aleph/grid1", -80 + offset[1], -50 + offset[2], 0.5, 2.4, true, true)
    makeSprite("voidNum", "aleph/numbers3", -80 + offset[1], -50 + offset[2], 0.6, 1.1, true, false)
    makeSprite("voidNum2", "aleph/numbers3", -390 + offset[1], -200 + offset[2], 0.98, 1.15, true, true)
    makeSprite("voidBGrid", "aleph/grid2", -80 + offset[1], -50 + offset[2], 1, 2.4, true, true)
    makeSprite("voidNum3", "aleph/numbers3", -210 + offset[1], -400 + offset[2], 1.1, 1.2, true, true)
    makeSprite("sponges4", "aleph/mengerSponges", -2800, -2300, 0.06, 1.8, true, false)
    makeSprite("sponges3", "aleph/mengerSponges", -2300, -2200, 0.07, 1.7, true, false)
    makeSprite("sponges2", "aleph/mengerSponges", -2100, -2200, 0.09, 1.4, true, false)
    makeSprite("sponges", "aleph/mengerSponges", -2100, -2100, 0.1, 1.4, true, false)

    makeSprite("pauseNum", "aleph/numbers", -80, -50, 0, 1.4, true, true)
    makeSprite("pauseGrid", "aleph/grid1", -80, -50, 0, 2, true)

    setProperty("pauseNum.alpha", 0.4)
    table.insert(updateITime, "pauseNum")
    table.insert(updateITime, "pauseGrid")
    setSpriteShader("pauseNum", "scroll");
    setSpriteShader("pauseGrid", "scroll");
    setShaderFloat("pauseNum", "xSpeed", -0.2)
    setShaderFloat("pauseGrid", "xSpeed", -0.3)

    local numbersX, numbersY = -130, -10
    makeSprite("gridNumber", "aleph/numGrid", numbersX + offset[1], numbersY + offset[2], 0.4, 0.7, true, true)
    makeSprite("number1", "aleph/num1", numbersX + offset[1], numbersY + offset[2], 0.4, 0.7, true, true)
    makeSprite("number2", "aleph/num2", numbersX + offset[1], numbersY + offset[2], 0.4, 0.7, true, true)
    makeSprite("number3", "aleph/num3", numbersX + offset[1], numbersY + offset[2], 0.4, 0.7, true, true)
    makeSprite("number4", "aleph/num4", numbersX + offset[1], numbersY + offset[2], 0.4, 0.7, true, true)

    makeSprite("infiniteSponges3", "aleph/mengerSponges", -1000, -1000, 0.1, 0.7, true, false)
    makeSprite("infiniteSponges2", "aleph/mengerSponges", -2100, -2100, 0.1, 1, true, false)
    makeSprite("infiniteSponges", "aleph/mengerSponges", -2100, -2100, 0.1, 1.2, true, false)
    makeSprite("spongesKe4", "aleph/mengerSpongesK", 1500, -800, 0.05, 0.42, true, false)
    makeSprite("spongesKe3", "aleph/mengerSpongesK", 1500, -800, 0.1, 0.45, true, false)
    makeSprite("spongesKe2", "aleph/mengerSpongesK", 1500, -850, 0.2, 0.5, true, false)
    makeSprite("spongesKe", "aleph/mengerSpongesK", 1500, -750, 0.3, 0.6, true, false)

    setProperty("spongesKe.color", getColorFromHex("0xFF66c0d9"))
    setProperty("spongesKe2.color", getColorFromHex("0xFF66c0d9"))
    setProperty("spongesKe3.color", getColorFromHex("0xFF66c0d9"))
    setProperty("spongesKe4.color", getColorFromHex("0xFF66c0d9"))

    makeSprite("flare", "aleph/flare", 0, 0, 1, 10, true, true)
    setObjectCamera("flare", "hud")
    screenCenter("flare")

    makeSprite("clockOut", "aleph/clock_out", 0, 0, 0, 1.2, true, true)
    makeSprite("clockTime", "aleph/clock_time", 0, 0, 0, 1.2, true, true)
    makeSprite("clockIn", "aleph/clock_in", 0, 0, 0, 1.2, true, true)
    screenCenter("clockOut")
    setObjectCamera("clockOut", "hud")
    screenCenter("clockTime")
    setObjectCamera("clockTime", "hud")
    screenCenter("clockIn")
    setObjectCamera("clockIn", "hud")
    setProperty("clockOut.alpha", 0)
    setProperty("clockTime.alpha", 0)
    setProperty("clockIn.alpha", 0)

    makeText("errorT", "denumerable set", 100, 100, 120, true)
    makeText("bpmText", "250", 100, 500, 300, true)
    makeText("temptation", "T e m p t a t i o n", 100, 500, 160, true)

    makeSprite("circle", "aleph/Circle", 1500, -750, 0, 1.4, true, false)
    makeText("alephT", "A l e p h - Z e r o ", 0, 0, 140, true, true)

    screenCenter("errorT")
    screenCenter("bpmText", "XY")
    setTextColor("bpmText", "e3eeff")
    setTextBorder("bpmText", 6, "c0c7d1") 
    setProperty("bpmText.borderQuality", 0)
    screenCenter("temptation", "XY")
    setProperty("temptation.scale.x", 0.7)
    setProperty("temptation.y", getProperty("temptation.y") - 30)

    screenCenter("alephT")
    setObjectCamera("circle", "hud")
    screenCenter("circle")
    setObjectOrder("whiteBG", getObjectOrder("circle") - 5)

    setProperty("infiniteSponges.color", getColorFromHex(spongeColor[1]))
    setProperty("infiniteSponges2.color", getColorFromHex(spongeColor[1]))
    setProperty("infiniteSponges3.color", getColorFromHex(spongeColor[1]))

    makeSprite("title", "aleph/title", 0, 0, 0, 1, true, true)
    setObjectCamera('title', 'hud')
    screenCenter("title")
  
    setSpriteShader("infiniteSponges", "scroll"); setSpriteShader("infiniteSponges2", "scroll"); setSpriteShader("infiniteSponges3", "scroll")
    setProperty("infiniteSponges.angle", 5)
    setProperty("infiniteSponges2.angle", -10)
    setProperty("infiniteSponges3.angle", -40)
    table.insert(updateITime, "infiniteSponges")
    table.insert(updateITime, "infiniteSponges2")
    table.insert(updateITime, "infiniteSponges3")

    setSpriteShader("spongesKe", "scroll");
    table.insert(updateITime, "spongesKe")
    setSpriteShader("spongesKe2", "scroll");
    table.insert(updateITime, "spongesKe2")
    setSpriteShader("spongesKe3", "scroll");
    table.insert(updateITime, "spongesKe3")
    setSpriteShader("spongesKe4", "scroll");
    table.insert(updateITime, "spongesKe4")

    setProperty("infiniteSponges.alpha", 0.97)
    setProperty("infiniteSponges2.alpha", 0.4)
    setProperty("infiniteSponges3.alpha", 0.2)

    setShaderFloat("infiniteSponges", "xSpeed", 1)
    setShaderFloat("infiniteSponges", "ySpeed", 0.3)
    setShaderFloat("infiniteSponges2", "xSpeed", 0.5 )
    setShaderFloat("infiniteSponges2", "ySpeed", -0.6 )
    setShaderFloat("infiniteSponges3", "xSpeed", 0.4 )
    setShaderFloat("infiniteSponges3", "ySpeed", 0.24 )

    setShaderFloat("spongesKe", "xSpeed", 0.5)
    setShaderFloat("spongesKe", "ySpeed", 0.02)
    setShaderFloat("spongesKe2", "xSpeed", 0.3)
    setShaderFloat("spongesKe2", "ySpeed", 0.004)
    setShaderFloat("spongesKe3", "xSpeed", 0.15)
    setShaderFloat("spongesKe3", "ySpeed", 0.001)
    setShaderFloat("spongesKe4", "xSpeed", 0.12)
    setShaderFloat("spongesKe4", "ySpeed", 0.0005)

    setProperty("spongesKe.alpha", 0)
    setProperty("spongesKe2.alpha", 0)
    setProperty("spongesKe3.alpha", 0)
    setProperty("spongesKe4.alpha", 0)

   
    --goCam(0, 0, 00.1, 0)
    setBlendMode("voidWGrid", "overlay")

    makeLuaSprite("flash", "" ,0, 0)
    makeGraphic("flash", 2000, 1800, "FFFFFF")
    screenCenter("flash")
    addLuaSprite("flash", true)
    setObjectCamera("flash", "hud")
    setProperty("flash.alpha", 0)
  
    setProperty("voidWGrid.alpha", 0.3)
    setProperty("voidBGrid.alpha", 0.8)
    setProperty("voidNum.alpha", 0.2)
    setProperty("voidNum2.alpha", 0.3)
    setProperty("voidNum3.alpha", 0.4)

    setProperty("sponges.alpha", 1)
    setProperty("sponges2.alpha", 0.6)
    setProperty("sponges3.alpha", 0.4)
    setProperty("sponges4.alpha", 0.2)
    setProperty("sponges4.angle", 180)

    makeLuaSprite("fakeFade", "" ,0, 0)
    makeGraphic("fakeFade", 2000, 1800, "000000")
    screenCenter("fakeFade")
    setProperty("fakeFade.y", -100)
    setScrollFactor("fakeFade", 0, 0)
    setObjectCamera('fakeFade', "other")
    addLuaSprite("fakeFade")

    setPropertyFromClass("FlxTransitionableState", "skipNextTransIn", true)
    doTweenY("fakeFadeY", "fakeFade", 1400, 4, "quadIn")
    doTweenAngle("fakeFadeAn", "fakeFade", 30, 4, "quadIn")
    doTweenAlpha("fakeFadeAl", "fakeFade", 0, 3, "quadIn")

    setSpriteShader('splitShader', 'split')
    setShaderFloat("splitShader", "multi", 1)
    if shaderEnable then
        setSpriteShader('lensShader', 'lensDis')
        setShaderFloat("lensShader", "intensity", 0)
        setSpriteShader('chromShader', "chromRadial")
        setShaderFloat("chromShader", "iMin", 0.01) -- 0.01
        setShaderFloat("chromShader", "iOffset", 0)
    end

    setProperty("camZoomingMult", 0)


    runHaxeCode([[
        var shaderEnable = ]]..(shaderEnable and "true" or 'false')..[[;
        if (shaderEnable){
            game.camGame.setFilters([
                new ShaderFilter(game.getLuaObject("lensShader").shader),
                new ShaderFilter(game.getLuaObject("chromShader").shader),
                new ShaderFilter(game.getLuaObject("splitShader").shader)
            ]);
            game.camHUD.setFilters([
                new ShaderFilter(game.getLuaObject("splitShader").shader),
                new ShaderFilter(game.getLuaObject("chromShader").shader)
            ]);
        } else {
            game.camGame.setFilters([
                new ShaderFilter(game.getLuaObject("splitShader").shader)
            ]);
            game.camHUD.setFilters([
                new ShaderFilter(game.getLuaObject("splitShader").shader),
            ]);
        }
    ]])

    setObjectCamera("botplayTxt", "game")

end

function hudYeet()
    local topY = -300;
    local bottomY = 1000;
    local duration = 1

    doTweenY("bgY", "stageback", -1400, 1, "quadOut")
    doTweenY("stagefront", "stagefront", 1200, 1, "quadOut")
    if not lowQuality then 
        doTweenY("lightL", "stagelight_left", -400, 1, "quadOut")
        doTweenY("lightR", "stagelight_right", -400, 1, "quadOut")
        doTweenY("curtain", "stagecurtains", -1000, 1, "quadOut")
    end
    doTweenY("dadOff", "dad", 1000, 1, "quadOut")
    doTweenY("bfOff", "boyfriend", 1000, 1, "quadOut")
    doTweenY("gfOff", "gf", -800, 1, "quadOut")

    doTweenY("hpMove", "healthBar", 1000, 1, "quadOut")
    doTweenY("p1Y", "iconP1", -300, 1, "quadOut")
    doTweenY("p2Y", "iconP2", -300, 1, "quadOut")
    doTweenY("timeBarHi", "timeBar", -300, 1, "quadOut")
    doTweenY("timeBarBGHi", "timeBarBG", -300, 1, "quadOut")
    doTweenY("timeBarTxtHi", "timeTxt", -300, 1, "quadOut")
    
    local sprites, texts = getProperty("hudSprites"), getProperty("hudText")
    for i = 1, #sprites do 
        local tag = sprites[i]
        setProperty(tag..".dirty", false)
        if getProperty(tag..".y") < 370 then 
            doTweenY(tag.."goaway", tag, topY, duration, "quadOut")
        else 
            doTweenY(tag.."goaway", tag, bottomY, duration, "quadOut")
        end
        doTweenAlpha(tag.."goHaway", tag, 0, duration, "quadOut")
    end
    for i = 1, #texts do 
        local tag = texts[i]
        if getProperty(tag..".y") < 370 then 
            doTweenY(tag.."tgoaway", tag, topY, duration, "quadOut")
        else 
            doTweenY(tag.."tgoaway", tag, bottomY, duration, "quadOut")
        end
        doTweenAlpha(tag.."tgoHaway", tag, 0, duration, "quadOut")
    end

    for i = 1, #sca do 
        removeLuaScript(sca[i])
    end


    setProperty('scoreTxt.visible', true)
    setProperty('scoreTxt.alpha', 0)

    setProperty('scoreTxt.y', scoreTxtY)
    doTweenY('scoreTxtYY', "scoreTxt", scoreTxtY + 100, duration, "quadInOut")
    doTweenAlpha('scoreTxtShow', "scoreTxt", 0.4, duration)

    runTimer('endHudHide', 1)
end

function onGhostTap(noteData)
    if checkNoteNear(0.5) then 
        addHealth(-0.1)
    end
end

function checkNoteNear(range)
    for i = 0, getProperty("notes.length")-1 do 
        local time = -0.001 * (getSongPosition() - getPropertyFromGroup('notes', i, 'strumTime'));
        if time <= (range) and time >= (0 - range) then 
            return true
        end
    end
    return false
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "endHudHide" then 
        local sprites, texts = getProperty("hudSprites"), getProperty("hudText")
        for i = 1, #sprites do 
            local tag = sprites[i]
            setProperty(tag..".visible", false)
        end
        for i = 1, #texts do 
            local tag = texts[i]
            setProperty(tag..".visible", false)
        end
        removeLuaSprite('stageback')
        removeLuaSprite('stagefront')
        removeLuaSprite('stagelight_left')
        removeLuaSprite('stagelight_right')
        removeLuaSprite('stagecurtains')
        removeLuaSprite("stageback"); removeLuaSprite("stagefront"); 
        if not lowQuality then removeLuaSprite("stagelight_left");  removeLuaSprite("stagelight_right");  removeLuaSprite("stagecurtains"); end

        setProperty("boyfriend.visible", false)
        setProperty("dad.visible", false)
        setProperty("gf.visible", false)

        setProperty("healthBar.visible", false)
        setProperty("healthBarBG.visible", false)
        setProperty("timeBar.visible", false)
        setProperty("timeBarBG.visible", false)
        setProperty("timeTxt.visible", false)
        setProperty("iconP1.visible", false)
        setProperty("iconP2.visible", false)
    end
end

function onGameOverStart() 
    scrollBGSpeed = 0;
    setShaderFloat("chromShader", "iOffset", 0.001)
    lensIntensity = 0
end

function onSongStart()
    setObjectOrder("bpmText", getObjectOrder("strumLineNotes") - 1)
end

function makeSprite(tag, image,x, y, scrollFactor, scale, hide, antialiasing)
    makeLuaSprite(tag, image ,x, y)
    setScrollFactor(tag, scrollFactor, scrollFactor)
    addLuaSprite(tag, false)
    setGraphicSize(tag, getProperty(tag..".width")*scale, getProperty(tag..".height")*scale)
    setProperty(tag..".antialiasing", (antialiasing or false))
    setProperty(tag..".visible", hide == false)
end

function makeText(tag, text, x, y, size, hide)
    makeLuaText(tag, text, 1280, x, y)
    setTextFont(tag, "DroidSerif.ttf")
    setTextSize(tag, size)
    addLuaText(tag)
    setProperty(tag..".visible", hide == false)
    setProperty(tag..'.antialiasing', getPropertyFromClass("ClientPrefs", 'globalAntialiasing'))
    setTextBorder(tag, 1, "0x00000000")
    setProperty(tag..".borderQuality", 0)
end

function createNormalStage()
    makeLuaSprite('stageback', 'stageback', -600, -300)
	setScrollFactor('stageback', 0.9, 0.9)
	
	makeLuaSprite('stagefront', 'stagefront', -650, 600)
	setScrollFactor('stagefront', 0.9, 0.9)
	scaleObject('stagefront', 1.1, 1.1)
	
	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
		makeLuaSprite('stagelight_left', 'stage_light', -125, -100)
		setScrollFactor('stagelight_left', 0.9, 0.9)
		scaleObject('stagelight_left', 1.1, 1.1)
	
		makeLuaSprite('stagelight_right', 'stage_light', 1225, -100)
		setScrollFactor('stagelight_right', 0.9, 0.9)
		scaleObject('stagelight_right', 1.1, 1.1)
		setProperty('stagelight_right.flipX', true) --mirror sprite horizontally

		makeLuaSprite('stagecurtains', 'stagecurtains', -500, -300)
		setScrollFactor('stagecurtains', 1.3, 1.3)
		scaleObject('stagecurtains', 0.9, 0.9)
	end

	addLuaSprite('stageback', false)
	addLuaSprite('stagefront', false)
	addLuaSprite('stagelight_left', false)
	addLuaSprite('stagelight_right', false)
	addLuaSprite('stagecurtains', false)

end

local warpDur = 0
local warpPos = {}
function hudWrap(direction, duration)

    local dir = (direction+90) * (180 / math.pi)
    local x = math.cos(dir-90) * 740
    local y = math.sin(dir-90) * 360
    warpDur = duration
    warpPos = {x, y}
    doTweenX("camHUDXMove", "camPos", -x, duration/2, "expoIn")
    doTweenY("camHUDYMove", "camPos", -y, duration/2, "expoIn")
end

function onTweenCompleted(tag)
    if tag == "camHUDYMove" then 
        cancelTween("camHUDXMove")
        setProperty("camPos.x", warpPos[1])
        setProperty("camPos.y", warpPos[2])
        doTweenX("camHUDXMoveE", "camPos", 0, warpDur/2, "expoOut")
        doTweenY("camHUDYMoveE", "camPos", 0, warpDur/2, "expoOut")
    end
    if string.find(tag, 'voidCir') then 
        removeLuaSprite(tag)
        table.remove(circleGroup, 1)
    end
end

local beatNumb = 1
function onStepHit()
    modTrigger(curStep)
    checkMissingStep()
    setProperty("botplayTxt.x", getScreenPositionX('scoreTxt') + 400 + (shakeMode and getRandomFloat(-10 ,10) or 0))
    setProperty("botplayTxt.y", getScreenPositionY('scoreTxt') - 200 + (shakeMode and getRandomFloat(-10 ,10) or 0))
    
end

function modTrigger(curStep)
    if not findMissStep(curStep) then
        table.insert( stepDone, curStep )
    end

    if curStep == 48 then 
        hudYeet()

        setProperty("health", 1)
        setProperty("songScore", 0)
        setProperty("ratingPercent", 0)
        doVar("zoomHUD", "hudZoom", 1 ,0.8, 1, "quadInOut")
        
        setProperty("eplipsyBG.alpha",0.6)

        setShaderFloat("chromShader", "iOffset", 0.001)
    end
    if curStep == 56 then 
        doTweenAlpha("flashin", "flash", 1, 0.48, "expoIn")
    end
    if curStep == 64 then 

        doTweenX("spongesZoomX", "sponges.scale", 0.4, crochet/1000*4*4, "quadIn")
        doTweenY("spongesZoomY", "sponges.scale", 0.4, crochet/1000*4*4, "quadIn")
        doTweenAngle("spongesAn", "sponges", 40, crochet/1000*4*4, "quadIn")
        doTweenX("sponges2ZoomX", "sponges2.scale", 0.7, crochet/1000*4*4, "quadIn")
        doTweenY("sponges2ZoomY", "sponges2.scale", 0.7, crochet/1000*4*4, "quadIn")
        doTweenAngle("sponges2An", "sponges2", -30, crochet/1000*4*4, "quadIn")
        doTweenX("sponges3ZoomX", "sponges3.scale", 0.8, crochet/1000*4*4, "quadIn")
        doTweenY("sponges3ZoomY", "sponges3.scale", 0.8, crochet/1000*4*4, "quadIn")
        doTweenAngle("sponges3An", "sponges3", -20, crochet/1000*4*4, "quadIn")
        doTweenX("sponges4ZoomX", "sponges4.scale", 0.9, crochet/1000*4*4, "quadIn")
        doTweenY("sponges4ZoomY", "sponges4.scale", 0.9, crochet/1000*4*4, "quadIn")
        doTweenAngle("sponges4An", "sponges4", 130, crochet/1000*4*4, "quadIn")
    
        setProperty("sponges.visible", true)
        setProperty("sponges2.visible", true)
        setProperty("sponges3.visible", true)
        setProperty("sponges4.visible", true)
        doTweenAlpha("eplipsybgIn", "eplipsyBG", 1, crochet/1000*4*4, "quadOut")
        
        doTweenAlpha("flashin", "flash", 0, crochet/1000*4, "circOut")

        doVar("lensIntensityD", "lensIntensity", 0 ,-3, crochet/1000*4*3.95, "quadIn")
    end
    if curStep == 96 then 
        doTweenAlpha("flashin", "flash", 1, crochet/1000*4*2, "quadIn")
    end
    if curStep >= 128 and curStep < 376 and curStep % 16 == 8 and curStep ~= 248 then 
        local duration = 2
        voidCircleAmount = voidCircleAmount + 1
        local tag = "voidCir"..voidCircleAmount
        makeSprite(tag, "aleph/Circle", getProperty("camFollow.x") , getProperty("camFollow.y"), 1.15, 0.01, false, false)
        doTweenX("vCirScaleX"..voidCircleAmount, tag..".scale", 1, duration,"quadOut")
        doTweenY("vCirScaleY"..voidCircleAmount, tag..".scale", 1, duration,"quadOut")
        doTweenAlpha(tag, tag, 0, duration,"quadIn")
        table.insert(circleGroup, tag)
    end

    -- goCam min and max
    -- x = 400 -  2450
    -- y = 200 - 1450
    if curStep == 128 then 
        setProperty("eplipsyBG.alpha",0)
        doTweenZoom("zoomCam", "camGame", 1.1, 1, "quadInOut")
        goCam(500, 400, voidDuration, 4, voidEase)
        setProperty("sponges.visible", false)
        setProperty("sponges2.visible", false)
        setProperty("sponges3.visible", false)
        setProperty("sponges4.visible", false)

        doTweenAlpha("flashout", "flash", 0, crochet/1000*2, "quadOut")

        setProperty("voidBG.visible", true)
        setProperty("voidWGrid.visible", true)
        setProperty("voidBGrid.visible", true)
        setProperty("voidNum.visible", true)
        setProperty("voidNum2.visible", true)
        setProperty("voidNum3.visible", true)

        lensIntensity = -0.25

        --hudWrap(-20, 1)
    end
    if curStep == 144 then 
        doTweenZoom("zoomCam", "camGame", 1.2, 1, "quadInOut")
        goCam(700, 1000, voidDuration, -7, voidEase)
        --hudWrap(140, 1)
    end
    if curStep == 160 then 
        doTweenZoom("zoomCam", "camGame", 1.12, 1, "quadInOut")
        goCam(1600, 700, voidDuration, 6, voidEase)
    end
    if curStep == 176 then 
        doTweenZoom("zoomCam", "camGame", 1.1, 0.4, "quadInOut")
        goCam(1200, 1450, voidDuration, -2, voidEase)
    end
    if curStep == 181 then 
        doVar("zoomHUD", "hudZoom", 0.8 ,1.3, stepCrochet/1000*3, "circIn")
        doTweenZoom("zoomCam", "camGame", 1.5, stepCrochet/1000*3, "circIn")
    end
    if curStep == 184 then 
        doVar("zoomHUD", "hudZoom", 1.3 ,0.8, 0.4, "quadOut")
        doTweenZoom("zoomCam", "camGame", 1, 0.4, "quadOut")
        lensIntensityBeat = lensIntensityBeat - 0.8
    end
    if curStep == 192 then 
        doTweenZoom("zoomCam", "camGame", 1.15, 1, "quadInOut")
        goCam(700, 560, voidDuration, -2, voidEase)
    end
    if curStep == 208 then 
        doTweenZoom("zoomCam", "camGame", 1.06, 1, "quadInOut")
        goCam(400, 900, voidDuration, 8, voidEase)
    end
    if curStep == 224 then  
        doTweenZoom("zoomCam", "camGame", 1.12, 1, "quadInOut")
        goCam(1200, 700, voidDuration, -3, voidEase)
    end
    if curStep == 240 then  --glitcinggggg
        hudZoomBeat = hudZoomBeat + 0.8
      
        setProperty("eplipsyBG.alpha", 0.1)

        setProperty("voidBG.visible", false)
        --setProperty("voidWGrid.visible", false)
        setProperty("voidBGrid.visible", false)
        setProperty("voidNum.visible", false)
        setProperty("voidNum2.visible", false)
        setProperty("voidNum3.visible", false)

        setProperty("errorT.visible", true)

      
        doTweenZoom("zoomCam", "camGame", 4, 0.6, "quadIn")

        doTweenY("errorTY", "errorT", getProperty("errorT.y") + 100, 1)
        doTweenAngle("errorTAn", "errorT", 20, 1)
    end
    if curStep == 248 then 
        doTweenZoom("zoomCam", "camGame", 1, 1, "quadOut")
        setShaderFloat("chromShader", "iOffset", 0.001)
        setProperty("eplipsyBG.alpha", 0)
        doVar("lensIntensityD", "lensIntensity", -5 ,-0.25, crochet/1000*2, "quadOut")
        setProperty("voidBG.visible", true)
        --setProperty("voidWGrid.visible", true)
        setProperty("voidBGrid.visible", true)
        setProperty("voidNum.visible", true)
        setProperty("voidNum2.visible", true)
        setProperty("voidNum3.visible", true)

        setProperty("errorT.visible", false)

        for i = 1, #circleGroup do 
            cancelTween(circleGroup[i])
            removeLuaSprite(circleGroup[i])
        end
    end
    if curStep >= 240 and curStep < 248 then 
        setShaderFloat("chromShader", "iOffset", getRandomFloat(1, 40)/100)
    end
    if curStep == 256 then 
        doTweenZoom("zoomCam", "camGame", 1.05, 1, "quadInOut")
        goCam(2000, 800, voidDuration, 4, voidEase)
    end
    if curStep == 272 then 
        doTweenZoom("zoomCam", "camGame", 1.1, 1, "quadInOut")
        goCam(1600, 1400, voidDuration, -5, voidEase)
    end
    if curStep == 288 then 
        doTweenZoom("zoomCam", "camGame", 1.05, 1, "quadInOut")
        goCam(1400, 500, voidDuration, 7, voidEase)
    end
    if curStep >= 296 and curStep < 300 then 
        setShaderFloat("chromShader", "iOffset", getRandomFloat(0.01, 0.03))
    end
    if curStep == 300 then 
        setShaderFloat("chromShader", "iOffset", 0.001)
    end
    if curStep == 304 then 
        doTweenZoom("zoomCam", "camGame", 1.03, 0.4, "quadInOut")
        goCam(1000, 1000, voidDuration, -2, voidEase)
    end
    if curStep == 309 then 
        doVar("zoomHUD", "hudZoom", 0.8 ,1.3, stepCrochet/1000*3, "circIn")
        doTweenZoom("zoomCam", "camGame", 1.5, stepCrochet/1000*3, "circIn")
        lensIntensityBeat = lensIntensityBeat - 0.8
    end
    if curStep == 312 then 
        doVar("zoomHUD", "hudZoom", 1.3 ,0.8, 0.4, "quadOut")
        doTweenZoom("zoomCam", "camGame", 1, 0.4, "quadOut")
    end
    if curStep == 320 then 
        doTweenZoom("zoomCam", "camGame", 1.1, 1, "quadInOut")
        goCam(500, 400, voidDuration, 4, voidEase)
    end
    if curStep == 336 then 
        doTweenZoom("zoomCam", "camGame", 1.2, 1, "quadInOut")
        goCam(700, 1000, voidDuration, -7, voidEase)
    end
    if curStep == 352 then 
        doTweenZoom("zoomCam", "camGame", 1.12, 1, "quadInOut")
        goCam(1600, 700, voidDuration, 6, voidEase)
    end
    if curStep == 368 then 
        doTweenZoom("zoomCam", "camGame", 1.1, 0.4, "quadInOut")
        goCam(1200, 1450, voidDuration, -2, voidEase)
    end
    if curStep == 384 then 
        setProperty("eplipsyBG.alpha", 0.15)
        doVar("lensIntensityD", "lensIntensity", -0.1 ,-0.4, 11, "quadOut")

        setProperty("voidBG.visible", false)
        setProperty("voidWGrid.visible", false)
        setProperty("voidBGrid.visible", false)
        setProperty("voidNum.visible", false)
        setProperty("voidNum2.visible", false)
        setProperty("voidNum3.visible", false)

        setProperty("gridNumber.visible", true)
        setProperty("number1.visible", true)
        setProperty("number2.visible", true)
        setProperty("number3.visible", true)
        setProperty("number4.visible", true)

        goCam(0, 0, 0, -2)
        goCam(3500, 2000, 13.72, 16, "sineIn", true)
        doTweenAngle('camGameTilt', 'camGame', 4, 4.5, "sineInOut")
    end
    if curStep == 432 then 
        doTweenAlpha("flashin", "flash", 1, 1.713, "expoIn")
        doTweenAngle('camGameTilt', 'camGame', 160, 1.713, "expoIn")
    end
    if curStep == 448 then 
        doTweenAlpha("flashin", "flash", 0, 2, "expoOut")
        doTweenAngle('camGameTilt', 'camGame', 187, 5.5, "sineOut")
    end
    if curStep == 496 then 
        doTweenZoom("zoomCam", "camGame", 2.5, 1.714, "quadIn")
        doVar("lensIntensityD", "lensIntensity", -0.4 ,-1, 1.713, "quadIn")
        doTweenAlpha("flashin", "flash", 1, 1.714, "linear")
    end
    if curStep == 512 then 
        doTweenZoom("zoomCam", "camGame", 1, 1, "quadOut")
        doVar("lensIntensityD", "lensIntensity", -3 , -0.25, crochet/1000*2, "quadOut")
        doTweenAlpha("flashin", "flash", 0, 0.5, "linear")
        goCam(0, 0, 0, 0)
        setProperty("gridNumber.visible", false)
        setProperty("number1.visible", false)
        setProperty("number2.visible", false)
        setProperty("number3.visible", false)
        setProperty("number4.visible", false)
        
    end
    if curStep == 528 then 
        setProperty('eplipsyBG.alpha', 0.9)
    end 
    if curStep == 540 then 
        setProperty('eplipsyBG.alpha', 0.1)
    end 
    if curStep == 544 or curStep == 552 then 
        setProperty('eplipsyBG.alpha', 0.5)
    end 
    if curStep == 549 then 
        setProperty('eplipsyBG.alpha', 0.05)
    end 
    if curStep == 560 then 
        setProperty('eplipsyBG.alpha', 0.05)
        setProperty("infiniteSponges.visible", true)
        setProperty("infiniteSponges2.visible", true)
        setProperty("infiniteSponges3.visible", true)
        doVar("scrollBGSpeedD", "scrollBGSpeed", 0 , 6, 2.88, "quadIn")
    end
    if curStep == 592 then 
        setProperty("bpmText.visible", true)
        setProperty("bpmText.alpha", 0)
        doTweenAlpha("showBPM", "bpmText", 0.8, 1.2, "quadIn")

        setProperty("clockOut.visible", true); setProperty("clockTime.visible", true); setProperty("clockIn.visible", true)
        doTweenAlpha("clockOut", "clockOut", 0.6, 1.4, "linear")
        doTweenAlpha("clockTime", "clockTime", 0.5, 1.4, "linear")
        doTweenAlpha("clockIn", "clockIn", 0.45, 1.4, "linear")
    end
    if curStep == 608 then 
        doVar("scrollBGSpeedD", "scrollBGSpeed", 8 , 0.8, 1, "quadOut")
    end
    if curStep == 624 then 
        doVar("scrollBGSpeedD", "scrollBGSpeed", 0.8 , 4, 24, "quadIn")
        doVar("lensIntensityD", "lensIntensity", -0.25 ,-0.6, 26, "quadIn")
        doVar("bpmIncrease", "bpmCounter", 250 ,400, 28.2567855, "linear")
    end
    if curStep == 1136 then 
        cancelVar("scrollBGSpeedD")
        setShaderFloat("splitShader", "multi", 1)
        scrollBGSpeed = 0;
        iTimeElapsed = 0;
    end
    if curStep == 1224 then 
        doVar("scrollBGSpeedD", "scrollBGSpeed", 0 , 8, 2.45, "quadIn")
        setProperty("bpmText.angle", 360)
        doTweenAngle("bpmSpin", "bpmText", 0, 1.7, "quadOut")

        setProperty("bpmText.scale.x", 1.5)
        setProperty("bpmText.scale.y", 1.5)
        doTweenX("bpmBeatX", 'bpmText.scale', 1, 1.7, "quadOut")
        doTweenY("bpmBeatY", 'bpmText.scale', 1, 1.7, "quadOut")

        setProperty("bpmText.alpha", 0)
        setProperty("flash.alpha", 1)
        doTweenAlpha("flashout", "flash", 0, 2, "linear")

        setProperty("temptation.visible", true)
        doTweenX("temptationSclax", 'temptation.scale', 1.02, 3, "quadOut")
        setProperty("flare.visible", true)
        doTweenX("flareScaleX", 'flare.scale', 12, 3, "quadOut")
        doTweenY("flareScaleY", 'flare.scale', 7, 3, "quadOut")

        doTweenAlpha("clockOut", "clockOut", 0, 0.2, "linear")
        doTweenAlpha("clockTime", "clockTime", 0, 0.2, "linear")
        doTweenAlpha("clockIn", "clockIn", 0, 0.2, "linear")

      
    end
    if curStep == 1280 then 
        doTweenAlpha("bpmInvisible", 'bpmText', 0.8, 2, "linear")
        doTweenAlpha("temptationAlpha", 'temptation',0, 1, "linear")
        doTweenAlpha("flareAlpha", 'flare',0, 1, "linear")
        doVar("bpmIncrease", "bpmCounter", 400 ,9999999, 2.4, "quadIn")
        setProperty("clockOut.visible", false); setProperty("clockTime.visible", false); setProperty("clockIn.visible", false)
    end
    if curStep >= 1280 and curStep < 1344 then
        hudZoomBeat = 0.1
        setProperty("infiniteSponges.angle", getRandomFloat(0, 359))
        setProperty("infiniteSponges2.angle", getRandomFloat(0, 359))
        setProperty("infiniteSponges3.angle", getRandomFloat(0, 359))
        setProperty("flash.alpha", 0.5)
        doTweenAlpha("flashout", "flash", 0, 0.02, "linear")

        changeTimed = changeTimed + 1
        if changeTimed > #spongeColor then changeTimed = 1 end
        setProperty("infiniteSponges.color", getColorFromHex(spongeColor[changeTimed]))
        setProperty("infiniteSponges2.color", getColorFromHex(spongeColor[changeTimed]))
        setProperty("infiniteSponges3.color", getColorFromHex(spongeColor[changeTimed]))
    end

    if short(curStep, {1136,1138,1140,1142,1144, 1148,1150,1152,1154,1156, 1160,1162,1164,1166,1168, 1172,1174,1176,1178,1180, 1184,1186,1188,1190,1192,
    1196,1198,1200,1202,1204, 1208,1210,1212,1214,1216,1218,1220,1222}) then 
        hudZoomBeat = 0.4
        setProperty("infiniteSponges.angle", getRandomFloat(0, 359))
        setProperty("infiniteSponges2.angle", getRandomFloat(0, 359))
        setProperty("infiniteSponges3.angle", getRandomFloat(0, 359))
        setProperty("flash.alpha", 0.5)
        doTweenAlpha("flashout", "flash", 0, 0.1, "linear")
        iTimeElapsed = 0;
        scrollBGSpeed = 0;

        changeTimed = changeTimed + 1
        if changeTimed > #spongeColor then changeTimed = 1 end
        setProperty("infiniteSponges.color", getColorFromHex(spongeColor[changeTimed]))
        setProperty("infiniteSponges2.color", getColorFromHex(spongeColor[changeTimed]))
        setProperty("infiniteSponges3.color", getColorFromHex(spongeColor[changeTimed]))
    end

    if curStep == 1344 then 
        setProperty('eplipsyBG.alpha', 0)
        setProperty("infiniteSponges.visible", false)
        setProperty("infiniteSponges2.visible", false)
        setProperty("infiniteSponges3.visible", false)
        setProperty("bpmText.visible", false)

        setProperty("pauseNum.visible", true)
        setProperty("pauseGrid.visible", true)
        setProperty("pauseNum.alpha", 0)
        setProperty("pauseGrid.alpha", 0)
        doTweenAlpha("pauseNum", "pauseNum", 0.3, 2)
        doTweenAlpha("pauseGrid", "pauseGrid", 0.7, 2)
        scrollBGSpeed = 1;
        goCam(0, 0, 0, 0)
    end
    if short(curStep, {1387, 1419, 1451, 1483}) then 
        scrollBGSpeed = -0.2
        setProperty("pauseNum.alpha", 0.3 / 2)
        setProperty("pauseGrid.alpha", 0.7 / 2)
    end
    if short(curStep, {1403, 1427, 1467, 1491}) then 
        scrollBGSpeed = 1
        setProperty("pauseNum.alpha", 0.3)
        setProperty("pauseGrid.alpha", 0.7)
    end
    if curStep == 1504 then  --1504
        setProperty('scoreTxt.visible', false)
        local duration = 1.89
        
        doTweenX("circleInx", "circle.scale", 0, duration, "circIn")
        doTweenY("circleIny", "circle.scale", 0, duration, "circIn")

        doTweenAlpha("whiteBG", "whiteBG", 1, 1)

        setProperty("circle.visible", true)
        setProperty('circle.alpha', 0)
        doTweenColor("circleColor", "circle", "000000", duration)
    end
    if curStep == 1536 then -- 1536 
        local duration = 1.92
        setProperty("pauseNum.visible", false)
        setProperty("pauseGrid.visible", false)
        
        setProperty("spongesKe.visible", true)
        setProperty("spongesKe2.visible", true)
        setProperty("spongesKe3.visible", true)
        setProperty("spongesKe4.visible", true)
  
        doTweenX("spongesKeX", "spongesKe", -300, duration, "quadIn")
        doTweenX("spongesKe2X", "spongesKe2", -200, duration, "quadIn")
        doTweenX("spongesKe3X", "spongesKe3", -250, duration, "quadIn")
        doTweenX("spongesKe4X", "spongesKe4", -200, duration, "quadIn")
        doTweenAlpha("spongesKeA", "spongesKe", 0.9, duration, "expoIn")
        doTweenAlpha("spongesKe2A", "spongesKe2", 0.6, duration, "expoIn")
        doTweenAlpha("spongesKe3A", "spongesKe3", 0.4, duration, "expoIn")
        doTweenAlpha("spongesKe4A", "spongesKe4", 0.2, duration, "expoIn")

        setProperty('flash.alpha', 1)
        doTweenAlpha("flashout", "flash", 0, 0.2, "linear")
        doTweenAlpha("whiteBG", "whiteBG", 0, 0.1)
        setProperty("alephT.visible", true)
        doTweenX("circleInx", "circle.scale", 2.5, duration, "quadOut")
        doTweenY("circleIny", "circle.scale", 2.5, duration, "quadOut")
        setProperty("alephT.scale.x", 0.1)
        doTweenX("alephText", "alephT.scale", 1, duration, "quadOut")

        setShaderFloat("chromShader", "iOffset", 0.02)
    end
    if curStep == 1548 then 
        doTweenAlpha("flashout", "flash", 1, 0.48, "linear")
    end
    if curStep == 1552 then 
        setShaderFloat("chromShader", "iOffset", 0.001)
        setProperty("circle.visible", false)
        setProperty("alephT.visible", false)
        scrollBGSpeed = 1
        doTweenAlpha("flashout", "flash", 0, 0.5, "linear")
        setProperty('scoreTxt.visible', true) 
        
    end
    if short(curStep, {1680, 1760, 1904, 1984}) then 
        scrollBGSpeed = 6;
        setProperty("spongesKe.color", getColorFromHex("0xff942516"))
        setProperty("spongesKe2.color", getColorFromHex("0xff942516"))
        setProperty("spongesKe3.color", getColorFromHex("0xff942516"))
        setProperty("spongesKe4.color", getColorFromHex("0xff942516"))
        shakeMode = true
        runHaxeCode([[
            Main.fpsVar.background = true;
        ]])
    end
    if short(curStep, {1744, 1888, 1968, 2112}) then 
        scrollBGSpeed = 1;
        setProperty("spongesKe.color", getColorFromHex("0xFF66c0d9"))
        setProperty("spongesKe2.color", getColorFromHex("0xFF66c0d9"))
        setProperty("spongesKe3.color", getColorFromHex("0xFF66c0d9"))
        setProperty("spongesKe4.color", getColorFromHex("0xFF66c0d9"))
        shakeMode = false
        setProperty("camFollowPos.x", 0)
        setProperty("camFollowPos.y", 0)
        runHaxeCode([[
            Main.fpsVar.background = false;
            Main.fpsVar.x = 10;
            Main.fpsVar.y = 3;
        ]])
    end
    if curStep == 2144 then 
        doTweenAlpha("flashin", "flash", 1, 3.84, "eircIn")
    end
    if curStep == 2128 then 
        scrollBGSpeed = 0
    end
    if curStep == 2160 then 
        doTweenAlpha("flashin", "flash", 0, 1.5, "linear")
        setProperty("spongesKe.visible", false)
        setProperty("spongesKe2.visible", false)
        setProperty("spongesKe3.visible", false)
        setProperty("spongesKe4.visible", false)

        setProperty("voidBG.visible", true)
        setProperty("voidWGrid.visible", true)
        setProperty("voidBGrid.visible", false)
        setProperty("voidNum.visible", true)
        setProperty("voidNum2.visible", true)
        setProperty("voidNum3.visible", true)
        setProperty('title.visible', true)

        setProperty("gridNumber.visible", false)
        setProperty("number1.visible", false)
        setProperty("number2.visible", false)
        setProperty("number3.visible", false)
        setProperty("number4.visible", false)

        setProperty("infiniteSponges.visible", false)
        setProperty("infiniteSponges2.visible", false)
        setProperty("infiniteSponges3.visible", false)
    end
    if curStep == 2192 then  --2192
        doVar("lensIntensityD", "lensIntensity", -0.6 ,-1, 3.5, "quadIn")
        screenCenter("fakeFade")
        setProperty("fakeFade.angle", 0)
        setProperty("fakeFade.alpha", 0)
        doTweenAlpha("fakeFadeAl", "fakeFade", 1, 3.5)
    end

    if ((curStep >= 128 and curStep < 242) or curStep >= 256 and curStep < 384) and short(curStep%64, {0,4,6,8,12, 16,22,28, 32,34,38,40,44,  48,54,56}) then 
        lensIntensityBeat = lensIntensityBeat - 0.2
        hudZoomBeat = hudZoomBeat + 0.02
    end
    if short(curStep+1, {384,396,400,404,408,410,416,422,424,428,432,436,440,442,448,460,464,468,472,474,480,492,496,498,500,504,505,506,507,508,509,510,511}) then 
        beatNumb = beatNumb + 1
        if beatNumb > 4 then beatNumb = 1 end
        local tag= "number"..beatNumb
        doTweenX("numberBeatx"..beatNumb, tag..".scale", 0.75, 0.1, "expoIn")
        doTweenY("numberBeaty"..beatNumb, tag..".scale", 0.75, crochet/1000*2, "quadOut")
    end
    if short(curStep, {384,396,400,404,408,410,416,422,424,428,432,436,440,442,448,460,464,468,472,474,480,492,496,498,500,504,505,506,507,508,509,510,511}) then 
        local tag= "number"..beatNumb
        doTweenX("numberBeatx"..beatNumb, tag..".scale", getProperty("gridNumber.scale.x"), 1, "quadOut")
        doTweenY("numberBeaty"..beatNumb, tag..".scale", getProperty("gridNumber.scale.y"), 1, "quadOut")
        lensIntensityBeat = lensIntensityBeat - 0.1
        hudZoomBeat = 0.03
    end
    if curStep >= 624 and curStep < 1136 then 
        if short((curStep+16)%64, {48,52,56,60, 0}) and curStep > 656 then 
            lensIntensityBeat = lensIntensityBeat - 0.8
            hudZoomBeat = 0.4
            setProperty("infiniteSponges.angle", getRandomFloat(0, 359))
            setProperty("infiniteSponges2.angle", getRandomFloat(0, 359))
            setProperty("infiniteSponges3.angle", getRandomFloat(0, 359))

            setProperty("flash.alpha", 0.3)
            setProperty("eplipsyBG.alpha", 1)
            doTweenAlpha("flashin", "flash", 0, 0.1, "linear")
            if (curStep+16)%64 == 48 then 
                setShaderFloat("splitShader", "multi", 2)
            elseif (curStep+16)%64 == 52 then
                setShaderFloat("splitShader", "multi", 3)
            elseif (curStep+16)%64 == 56 then
                setShaderFloat("splitShader", "multi", 4)
            elseif (curStep+16)%64 == 60 then
                setShaderFloat("splitShader", "multi", 5)
            elseif (curStep+16)%64 == 0 then
                setShaderFloat("splitShader", "multi", 1)
                changeTimed = changeTimed + 1
                if changeTimed > #spongeColor then changeTimed = 1 end
                setProperty("infiniteSponges.color", getColorFromHex(spongeColor[changeTimed]))
                setProperty("infiniteSponges2.color", getColorFromHex(spongeColor[changeTimed]))
                setProperty("infiniteSponges3.color", getColorFromHex(spongeColor[changeTimed]))
            end
            if curStep >= 880 then 
                doTweenAlpha("eplipsy", "eplipsyBG", 0.5, 2, "linear")
            else
                doTweenAlpha("eplipsy", "eplipsyBG", 0, 2, "linear")
            end

            setProperty("camHUD.angle", getRandomFloat(-20, 20))
            setProperty("camGame.zoom", 1.5)
            doTweenZoom("zoomCam", "camGame", 1, 1, "quadOut")
            doTweenAngle("camHUD", "camHUD", 0, 1, "quadOut")
        end
    end
end

targetCamPos = {0, 0}
function goCam(x, y, duration, angle, _ease, noAngle)
    local ease = (_ease or "sineInOut")
    if duration <= 0 then 
        setProperty("camFollow.x", x)
        setProperty("camFollowPos.x", x)

        setProperty("camFollow.y", y)
        setProperty("camFollowPos.y", y)

        if not noAngle then 
            setProperty("camGame.angle", angle)
        end
    else
        doTweenX("camFolX", "camFollow", x, duration, ease)
        doTweenX("camFolX2", "camFollowPos", x, duration, ease)

        doTweenY("camFolY", "camFollow", y, duration, ease)
        doTweenY("camFolY2", "camFollowPos", y, duration, ease)

        if not noAngle then 
            doTweenAngle('camGameTilt', 'camGame', angle, duration, ease)
        end
    end
    targetCamPos = {x, y}
    
end

function onBeatHit()
    if getProperty("bpmText.visible") and curBeat >=156 and curBeat < 306 then 
        setProperty("bpmText.scale.x", 1.1)
        setProperty("bpmText.scale.y", 1.1)
        doTweenX("bpmBeatX", 'bpmText.scale', 1, 0.4, "quadOut")
        doTweenY("bpmBeatY", 'bpmText.scale', 1, 0.4, "quadOut")
    end
end

voidBGElapsed = 0
iTimeElapsed = 0
function onUpdate(elapsed)
    lensIntensityBeat = lerp(lensIntensityBeat, 0 ,elapsed*10)
    lensIntensityBeatLerp = lerp (lensIntensityBeatLerp, lensIntensityBeat, elapsed * 12)
    setShaderFloat("lensShader", "intensity", lensIntensity + lensIntensityBeatLerp)
    if getProperty("bpmText.visible") then 
        setTextString("bpmText", math.floor(bpmCounter))
    end
    if shakeMode then 
        setProperty("camFollowPos.x", getRandomFloat(-50, 50))
        setProperty("camFollowPos.y", getRandomFloat(-50, 50))
    end
    if getProperty("alephT.visible") then 
        local rColor =  "00"
        local gColor =  "00"
        local bColor = "00"
        if voidBGElapsed%3 > 2 then 
            bColor = string.format("%x", (boundTo(voidBGElapsed%1, 0, 1)*255))
            gColor = string.format("%x", ((1-boundTo(voidBGElapsed%1, 0, 1))*255))
        elseif voidBGElapsed%3 > 1 then 
            gColor = string.format("%x", (boundTo(voidBGElapsed%1, 0, 1)*255))
            rColor = string.format("%x", ((1-boundTo(voidBGElapsed%1, 0, 1))*255))
        elseif voidBGElapsed%3 > 0 then 
            rColor = string.format("%x", (boundTo(voidBGElapsed%1, 0, 1)*255))
            bColor = string.format("%x", ((1-boundTo(voidBGElapsed%1, 0, 1))*255))
        end
        setTextBorder("alephT", 4, rColor..gColor..bColor)
        setProperty("circle.color", getColorFromHex(rColor..gColor..bColor))
    end
    if curStep >= 2128 and curStep < 2160 and (math.floor(curDecStep*10) % 2 == 0) then 
        local percent = 50
        setProperty("spongesKe.visible", getRandomBool(percent))
        setProperty("spongesKe2.visible", getRandomBool(percent))
        setProperty("spongesKe3.visible", getRandomBool(percent))
        setProperty("spongesKe4.visible", getRandomBool(percent))

        setProperty("voidBG.visible", getRandomBool(percent))
        setProperty("voidWGrid.visible", getRandomBool(percent))
        setProperty("voidBGrid.visible", getRandomBool(percent))
        setProperty("voidNum.visible", getRandomBool(percent))
        setProperty("voidNum2.visible", getRandomBool(percent))
        setProperty("voidNum3.visible", getRandomBool(percent))

        setProperty("gridNumber.visible", getRandomBool(percent))
        setProperty("number1.visible", getRandomBool(percent))
        setProperty("number2.visible", getRandomBool(percent))
        setProperty("number3.visible", getRandomBool(percent))
        setProperty("number4.visible", getRandomBool(percent))

        setProperty("infiniteSponges.visible", getRandomBool(percent))
        setProperty("infiniteSponges2.visible", getRandomBool(percent))
        setProperty("infiniteSponges3.visible", getRandomBool(percent))
    end
    
    
    iTimeElapsed = iTimeElapsed + (elapsed*scrollBGSpeed)
    for i = 1, #updateITime do 
        setShaderFloat(updateITime[i], "iTime", iTimeElapsed)
    end

    if getProperty("clockOut.visible") then 
        setProperty("clockOut.angle", getProperty("clockOut.angle") + ((bpmCounter - 226) * elapsed))
        setProperty("clockTime.angle", getProperty("clockTime.angle") + ((bpmCounter - 210) * elapsed))
        setProperty("clockIn.angle", getProperty("clockIn.angle") + ((bpmCounter - 190) * elapsed))
    end
   
    
    voidBGElapsed = voidBGElapsed + elapsed
    local rgbVoid = string.format("%x", ((0.8 + (math.sin(voidBGElapsed)*0.2)) * 255))
    setProperty("voidBG.color", getColorFromHex(rgbVoid..rgbVoid..rgbVoid))
    setProperty("voidNum.angle", math.sin(voidBGElapsed/2)*0.7)
    setProperty("voidNum2.angle", math.cos(voidBGElapsed/2.2)*0.5)
    setProperty("voidNum3.angle", -math.sin(voidBGElapsed/2.4)*0.33)
    setProperty("voidWGrid.angle", -math.sin(voidBGElapsed/1.6)*0.8)
    setProperty("voidBGrid.angle", math.cos(voidBGElapsed/1.3)*1)

    setProperty("eplipsyBG.color", getColorFromHex(string.format("%x",getRandomFloat(0,255))..string.format("%x",getRandomFloat(0,255))..string.format("%x",getRandomFloat(0,255))))

    if curStep >= 1 and curStep < 48 and getRandomBool(curStep/3) then 
        setProperty("health", getRandomFloat(0.1, 2))
        setProperty("songScore", getRandomFloat(curStep*40, curStep*10*9999))
        setProperty("ratingPercent", getRandomFloat(curStep*2, curStep*5))
    end
end

function onUpdatePost(elapsed)
    
    hudZoomBeat = lerp(hudZoomBeat, 0, elapsed * 8)
    setProperty("camHUD.zoom", hudZoom + hudZoomBeat)
    -- 10 , 3
    if (curStep >= 48 and curStep < 64) or shakeMode then 
        local rc = string.format("%x", (getRandomFloat(0, 255)))
        local gc = string.format("%x", (getRandomFloat(0, 255)))
        local bc = string.format("%x", (getRandomFloat(0, 255)))
        runHaxeCode([[
            Main.fpsVar.textColor = 0x]]..rc..gc..bc..[[;
            Main.fpsVar.x = ]]..getRandomFloat(-5, 15)..[[;
            Main.fpsVar.y = ]]..getRandomFloat(0, 6)..[[;
        ]])
    end
    if (curStep >= 64 and curStep < 70) then 
        runHaxeCode([[
            Main.fpsVar.x = 10;
            Main.fpsVar.y = 3;
        ]])
    end
end


function checkMissingStep()
    if curStep > #stepDone then  -- 1, 2, 3, 5
       debugPrint('lag Found')
       local finishedArray = stepDone
       local pluss = 0;
       for i = 1, #stepDone do 
          if stepDone[i] ~= i + pluss then 
             table.insert( finishedArray, i, i + pluss)
             modTrigger(i + pluss)
             pluss = pluss + 1
          end
       end
       stepDone = finishedArray
    end
 end
 
 function findMissStep(curSstep)
    for i = 0, #stepDone do 
       if stepDone[i] == curSstep then 
          return true
       end
    end
 
    return false
 end


function doVar(_tag, _var, fromValue ,toValue, duration, _ease)
    callScript("data/aleph-0/coolFunctions", "varTween", {_tag, _var, fromValue, toValue, duration, _ease, scriptName})
end

function cancelVar(_tag)
    callScript("data/aleph-0/coolFunctions", "cancelVarTween", {_tag})
end

function lerp(a,b,t) return a * (1-t) + b * t end

function short(value, array)
    for i = 1, #array do 
        if array[i] == value then return true end
    end
    return false
end

function boundTo(value, min, max) return math.max(min, math.min(max, value)) end