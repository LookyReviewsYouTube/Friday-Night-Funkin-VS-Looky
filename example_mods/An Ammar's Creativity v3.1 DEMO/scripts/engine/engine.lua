New_Input = true;
New_HUD = true;
ratePrefix = "ACCURACY: ";
scorePrefix = "SCORES: ";
missPrefix = "MISSED: ";
comboPrefix = "COMBOS: ";
Hide_Bar = true;
SmoothHP = true;
New_NotesIntro = true;
HudIntro = true;
LIVES = 0;
curLive = 0;
local v0 = false;
local v1 = false;
local v2 = false;
iconSpeed = 4;
local v3;
local v4;
local v5 = false;
local v6 = false;
local v7 = 0;
local v8 = false;
local v9 = false;
local v10 = false;
local v11 = false;
function onCreate()
    luaDebugMode = true;
    v10 = buildTarget == "android";
    v8 = getDataFromSave("ammarc", "youtubeshort");
    v9 = getPropertyFromClass("ClientPrefs", "middleScroll");
    if v8 then
        setPropertyFromClass("ClientPrefs", "middleScroll", true);
    end
    package.path = getProperty("modulePath") .. ";" .. package.path;
    v4 = require("TweenModule");
    v3 = require("SpriteUtil");
    precacheImage("menu/checker");
    precacheSound("cancelMenu");
    precacheSound("scrollMenu");
    addHaxeLibrary("FlxText", "flixel.text");
    addHaxeLibrary("FlxSound", "flixel.system");
    addHaxeLibrary("FlxMath", "flixel.math");
    addHaxeLibrary("Std");
    addHaxeLibrary("FlxPoint", "flixel.math");
    addHaxeLibrary("Math", "flixel");
    v5 = getPropertyFromClass("ClientPrefs", "comboStacking");
    setPropertyFromClass("PlayState", "STRUM_X", 48);
    setPropertyFromClass("PlayState", "STRUM_X_MIDDLESCROLL", -272);
    if New_NotesIntro then
        setProperty("skipArrowStartTween", true);
    end
    if (not v6 and (getDataFromSave("ammarc", "highscore")["no-debug"] == nil)) then
        setProperty("debugKeysChart", nil);
        setProperty("debugKeysCharacter", nil);
    end
end
local v12 = true;
function onCreatePost()
    v12 = getDataFromSave("ammarc", "newSplashes");
    if (New_HUD and not string.find(songName, "menu")) then
        createHUD();
        if v8 then
            scaleObject("healthBar", 0.8, 1);
            scaleObject("healthBarBG", 0.8, 1);
            screenCenter("healthBar", "X");
        end
    end
    if New_Input then
        for v92 = 0, getProperty("unspawnNotes.length") - 1 do
            if getPropertyFromGroup("unspawnNotes", v92, "isSustainNote") then
                setPropertyFromGroup("unspawnNotes", v92, "hitHealth", 0);
                setPropertyFromGroup("unspawnNotes", v92, "missHealth", 0);
                setPropertyFromGroup("unspawnNotes", v92, "alpha", 1);
                setPropertyFromGroup("unspawnNotes", v92, "multAlpha", 1);
            end
        end
    end
    canDebugggggggggg = (getDataFromSave("ammarc", "highscore")["no-debug"] ~= nil) or v6;
end
function onPause()
    if getPropertyFromClass("PlayState", "chartingMode") then
        return;
    end
    openCustomSubstate("FakePauseSubstate", true);
    return Function_Stop;
end
function onUpdate(v25)
    if inGameOver then
        return;
    end
    HUDUpdate(v25);
    if ((keyboardJustPressed("SEVEN") or keyboardJustPressed("EIGHT")) and not v6 and (songName ~= "No-Debug") and
        (getDataFromSave("ammarc", "highscore")["no-debug"] == nil)) then
        v7 = v7 + 1;
        if (v7 >= 3) then
            cheaterDetected();
        end
        triggerEvent("Add Camera Zoom", -0.2, -0.2);
    end
end
function cheaterDetected()
    v7 = -1000;
    runHaxeCode([[
    FlxTween.tween(game, {playbackRate: 0}, 6);
]]);
    runTimer("loadDebugSong", 6.2);
end
local v13 = false;
function noCpu()
    if not v13 then
        if (getProperty("cpuControlled") or getProperty("practiceMode")) then
            runHaxeCode('game.addTextToDebug("NO CHEATING | YOUR SCORES WILL NOT BE SAVED", 0xFFFFFF00)');
            setProperty("cpuControlled", false);
            setProperty("practiceMode", false);
            setProperty("botplayTxt.visible", false);
        end
    end
end
local v14 = false;
function onUpdatePost(v26)
    if inGameOver then
        return;
    end
    if (getPropertyFromClass("PlayState", "chartingMode") and v11 and not v14 and (songName ~= "No-Debug") and not v6 and
        (getDataFromSave("ammarc", "highscore")["no-debug"] == nil)) then
        v14 = true;
        runTimer("turnOffChartingMode", 1);
        setProperty("canPause", false);
        runTimer("cheaterDetect", 5);
    end
    if (songName == "No-Debug") then
        setPropertyFromClass("PlayState", "chartingMode", false);
    end
    noCpu();
    v4.Update(v26);
end
function goodNoteHit(v27, v28, v29, v30)
    HUDScoreUpdate(false, v30);
    combo(getPropertyFromGroup("notes", v27, "rating"));
    if (v30 and not botPlay) then
        addScore(5);
    end
    if (v30 and New_Input) then
        for v93 = 0, getPropertyFromGroup("notes", v27, "parent.tail.length") - 1 do
            setProperty("notes.members[" .. v27 .. "].parent.tail[" .. v93 .. "].colorSwap.brightness",
                1 + (math.sin(os.clock() * 18) * 0.8));
        end
    end
    if v12 then
        for v94 = 0, getProperty("grpNoteSplashes.length") - 1 do
            local v95 = v94;
            setProperty("grpNoteSplashes.members[" .. v95 .. "].alpha",
                1 - (getProperty("grpNoteSplashes.members[" .. v95 .. "].animation.curAnim.curFrame") / 4));
            setProperty("grpNoteSplashes.members[" .. v95 .. "].scale.x", 0.65);
            setProperty("grpNoteSplashes.members[" .. v95 .. "].scale.y", 0.65);
            setProperty("grpNoteSplashes.members[" .. v95 .. "].offset.x", 1);
            setProperty("grpNoteSplashes.members[" .. v95 .. "].offset.y", -1);
            setProperty("grpNoteSplashes.members[" .. v95 .. "].animation.curAnim.frameRate", 15);
            setBlendMode("grpNoteSplashes.members[" .. v95 .. "]", "add");
        end
    end
end
function combo(v31)
    if (v31 == "bad") then
        addHealth(-0.024);
    end
    if (v31 == "shit") then
        addHealth(-0.035);
        addMisses(1);
    end
end
function onSongStart()
    v11 = true;
end
local v15 = 20;
local v16 = "gaposiss.ttf";
space = 30;
local v17 = {};
local v18 = 0;
local v19 = 0;
local v20 = {};
local v21 = {};
local v22 = 1;
local v23 = {};
function createHUD()
    setProperty("scoreTxt.visible", false);
    setProperty("scoreTxt.alpha", 0);
    setProperty("healthBar.numDivisions", 300);
    setObjectOrder("healthBar", getObjectOrder("healthBarBG") - 1);
    v17 = {getProperty("healthBar.offset.y"), getProperty("healthBarBG.offset.y")};
    setProperty("iconP1.visible", false);
    setProperty("iconP2.visible", false);
    setProperty("timeBar.visible", false);
    setProperty("timeBarBG.visible", false);
    setProperty("timeTxt.visible", false);
    setProperty("showCombo", false);
    setProperty("showComboNum", false);
    setProperty("showRating", false);
    setPropertyFromClass("ClientPrefs", "comboStacking", false);
    screenCenter("healthBar", "x");
    v3.makeText({
        tag = "scoreText",
        x = v15,
        y = 700 - v15,
        size = 20,
        align = 20,
        font = v16,
        text = scorePrefix .. "0",
        antialiasing = false
    });
    v3.makeText({
        tag = "rateText",
        x = v15,
        y = (700 - v15) - space,
        size = 20,
        align = 20,
        font = v16,
        text = ratePrefix .. "?",
        antialiasing = false
    });
    v3.makeText({
        tag = "missText",
        x = v15,
        y = (700 - v15) - (space * 2),
        size = 20,
        align = 20,
        font = v16,
        text = missPrefix .. "0",
        antialiasing = false
    });
    v3.makeText({
        tag = "comboText",
        x = v15,
        y = (700 - v15) - (space * 2),
        size = 20,
        align = 20,
        font = v16,
        text = comboPrefix .. "0",
        antialiasing = false
    });
    setProperty("comboText.alpha", 0);
    v3.makeAnimateSprite({
        tag = "nIconP1",
        x = 200,
        y = 200,
        antialiasing = true,
        cam = "camHUD"
    });
    local v32 = getProperty("dad.healthIcon");
    loadGraphic("nIconP1", "icons/icon-" .. v32);
    local v33 = getProperty("nIconP1.width");
    loadGraphic("nIconP1", "icons/icon-" .. v32, 150);
    local v34 = {};
    for v69 = 0, math.floor(v33 / 150) - 1 do
        table.insert(v34, v69);
    end
    addAnimation("nIconP1", "idle", v34, 0, true);
    playAnim("nIconP1", "idle");
    v3.makeAnimateSprite({
        tag = "nIconP2",
        x = 400,
        y = 200,
        antialiasing = true,
        cam = "camHUD"
    });
    local v32 = getProperty("boyfriend.healthIcon");
    loadGraphic("nIconP2", "icons/icon-" .. v32);
    local v33 = getProperty("nIconP2.width");
    loadGraphic("nIconP2", "icons/icon-" .. v32, 150);
    local v34 = {};
    for v70 = 0, math.floor(v33 / 150) - 1 do
        table.insert(v34, v70);
    end
    addAnimation("nIconP2", "idle", v34, 0, true);
    playAnim("nIconP2", "idle");
    setProperty("nIconP2.flipX", true);
    v20 = {"icon-face", "icon-face"};
    setObjectOrder("nIconP1", getObjectOrder("iconP1") - 1);
    setObjectOrder("nIconP2", getObjectOrder("nIconP1") - 1);
    if (LIVES > 0) then
        setProperty("missText.visible", true);
        setProperty("comboText.y", getProperty("comboText.y") - space);
        curLive = LIVES;
        setTextString("missText", "LIVES: " .. curLive .. "/" .. LIVES);
    else
        setProperty("missText.visible", false);
    end
    if downscroll then
        local v71 = -10;
        setProperty("healthBar.y", getProperty("healthBar.y") + v71);
    else
        local v72 = 30;
        setProperty("healthBar.y", getProperty("healthBar.y") + v72);
    end
    v23 = {getProperty("healthBar.x"), getProperty("healthBar.y")};
    v1 = true;
    if (HudIntro and
        not ((getPropertyFromClass("PlayState", "startOnTime") > 0) or (getProperty("skipCountdown") == true))) then
        setProperty("rateText.x", -250);
        setProperty("scoreText.x", -250);
        setProperty("healthBar.y", v23[2] + ((downscroll and -150) or 150));
    end
end
function HUDScoreUpdate(v35, v36, v37)
    if not v1 then
        return;
    end
    local v37 = v37 or false;
    if (v35 and not getProperty("missText.visible") and (misses >= 1)) then
        setProperty("missText.visible", true);
        setProperty("comboText.y", getProperty("comboText.y") - space);
    end
    if v35 then
        setProperty("missText.x", 10);
        doTweenX("msTextMove", "missText", v15, 0.5, "circOut");
        setProperty("scoreText.color", getColorFromHex("ffb0b0"));
        doTweenColor("scTextColor", "scoreText", "FFFFFFF", 0.5, "circOut");
        setProperty("missText.color", getColorFromHex("ffb0b0"));
        doTweenColor("msTextColor", "missText", "FFFFFFF", 0.5, "circOut");
        setProperty("rateText.color", getColorFromHex("ffb0b0"));
        doTweenColor("raTextColor", "rateText", "FFFFFFF", 0.5, "circOut");
    elseif not v36 then
        setProperty("scoreText.x", 10);
        doTweenX("scTextMove", "scoreText", v15, 0.5, "circOut");
        setProperty("rateText.x", 15);
        doTweenX("raTextMove", "rateText", v15, 0.5, "circOut");
    end
    if not v36 then
        setTextString("comboText", comboPrefix .. getProperty("combo"));
        setProperty("comboText.alpha", 1);
        setProperty("comboText.x", 10);
        doTweenX("coTextMove", "comboText", v15, 0.5, "circOut");
        doTweenAlpha("coTextAlpha", "comboText", 0, 0.5, "linear");
    end
    if (LIVES <= 0) then
        setTextString("missText", missPrefix .. misses);
    end
    setTextString("scoreText", scorePrefix .. score);
    setTextString("rateText", ratePrefix .. (math.floor(getProperty("ratingPercent") * 100 * 10) / 10) .. "%");
end
function iconsSpecialty(v38, v39)
    if (((v38 == "twitter") or (v38 == "bunny") or (v38 == "hacker") or (v38 == "demon-sky") or (v38 == "depression")) and
        (v39 > 0.8)) then
        return {
            x = getRandomFloat(5, -5),
            y = getRandomFloat(4, -4)
        };
    end
    return {
        x = 0,
        y = 0
    };
end
function HUDUpdate(v40)
    if not v1 then
        return;
    end
    v18 = lerp(v18, 0, v40 * 8);
    local v41 = getRandomFloat(-v18 * 100, v18 * 100) / 100;
    setProperty("healthBar.offset.y", v17[1] + v41);
    setProperty("healthBarBG.offset.y", v17[2] + v41);
    if (getProperty("health") <= 0.4) then
        v19 = v19 + (v40 * 8);
        local v73 = string.format("%x", (0.5 + (math.sin(v19) * 0.5)) * 255);
        local v74 = string.format("%x", 255 - ((0.5 + (math.sin(v19) * 0.5)) * 255));
        setProperty("healthBar.color", getColorFromHex(v73 .. v74 .. v74));
    else
        setProperty("healthBar.color", getColorFromHex("FFFFFF"));
    end
    if (v20[1] ~= getProperty("dad.healthIcon")) then
        loadGraphic("nIconP1", "icons/icon-" .. getProperty("dad.healthIcon"));
        local v75 = getProperty("nIconP1.width");
        loadGraphic("nIconP1", "icons/icon-" .. getProperty("dad.healthIcon"), 150);
        local v76 = {};
        for v96 = 0, math.floor(v75 / 150) - 1 do
            table.insert(v76, v96);
        end
        addAnimation("nIconP1", "idle", v76, 0, true);
        playAnim("nIconP1", "idle");
        v20[1] = getProperty("dad.healthIcon");
        v21[1] = math.floor(v75 / 150);
    end
    if (v20[2] ~= getProperty("boyfriend.healthIcon")) then
        loadGraphic("nIconP2", "icons/icon-" .. getProperty("boyfriend.healthIcon"));
        local v79 = getProperty("nIconP2.width");
        loadGraphic("nIconP2", "icons/icon-" .. getProperty("boyfriend.healthIcon"), 150);
        local v80 = {};
        for v97 = 0, math.floor(v79 / 150) - 1 do
            table.insert(v80, v97);
        end
        addAnimation("nIconP2", "idle", v80, 0, true);
        playAnim("nIconP2", "idle");
        v20[2] = getProperty("boyfriend.healthIcon");
        v21[2] = math.floor(v79 / 150);
    end
    if (healthPercent() < 0.2) then
        if (v21[1] >= 3) then
            setProperty("nIconP1.animation.curAnim.curFrame", 2);
        end
        if (v21[2] >= 2) then
            setProperty("nIconP2.animation.curAnim.curFrame", 1);
        end
    elseif (healthPercent() > 0.8) then
        if (v21[1] >= 2) then
            setProperty("nIconP1.animation.curAnim.curFrame", 1);
        end
        if (v21[2] >= 3) then
            setProperty("nIconP2.animation.curAnim.curFrame", 2);
        end
    else
        setProperty("nIconP1.animation.curAnim.curFrame", 0);
        setProperty("nIconP2.animation.curAnim.curFrame", 0);
    end
    v22 = (SmoothHP and lerp(v22, healthPercent(), v40 * 25)) or healthPercent();
    local v42 = iconsSpecialty(getProperty("dad.healthIcon"), healthPercent());
    local v43 = iconsSpecialty(getProperty("boyfriend.healthIcon"), healthPercent());
    setProperty("nIconP1.origin.x", 75 + 40);
    setProperty("nIconP1.origin.y", 110);
    setProperty("nIconP2.origin.y", 110);
    local v44 = getProperty("healthBar.width") * ((v8 and 0.8) or 1);
    if (songName == "Google") then
        setProperty("nIconP2.x", (((getProperty("healthBar.x") + (v44 * (1 - v22))) - 20) - 75) + v43.x);
        setProperty("nIconP2.origin.x", 75);
    else
        setProperty("nIconP2.x", ((getProperty("healthBar.x") + (v44 * (1 - v22))) - 20) + v43.x);
        setProperty("nIconP2.origin.x", 75 - 40);
    end
    setProperty("nIconP1.x", ((getProperty("healthBar.x") + (v44 * (1 - v22))) - 150) + 20 + v42.x);
    setProperty("nIconP1.y", (getProperty("healthBar.y") - 95) + v41 + v42.y);
    setProperty("nIconP2.y", (getProperty("healthBar.y") - 95) + v41 + v43.y);
    local v45, v46 = lerp(getProperty("nIconP1.scale.x"), 1, (stepCrochet / 10) * v40),
        lerp(getProperty("nIconP2.scale.x"), 1, (stepCrochet / 10) * v40);
    scaleObject("nIconP1", v45, v45, false);
    scaleObject("nIconP2", v46, v46, false);
    setProperty("healthBar.value", v22);
end
function onCountdownStarted()
    if (New_NotesIntro and
        not ((getPropertyFromClass("PlayState", "startOnTime") > 0) or (getProperty("skipCountdown") == true))) then
        local v83 = getPropertyFromGroup("strumLineNotes", 0, "y");
        local v84 = 100;
        for v98 = ((songName == "Google") and 4) or 0, 7 do
            setPropertyFromGroup("strumLineNotes", v98, "y", v83 + ((downscroll and v84) or -v84));
            setPropertyFromGroup("strumLineNotes", v98, "alpha", 0);
            local v99 = v4.Create("noteIntro" .. v98, {v83 + ((downscroll and v84) or -v84), v83},
                (crochet / 1000) * 2.8, {
                    EaseDirection = "OutBack",
                    callUpdate = function(v102)
                        setPropertyFromGroup("strumLineNotes", v98, "y", v102.position);
                    end,
                    delay = (((crochet / 1000) + ((v98 % 4) * 0.4)) * crochet) / 1000
                });
            v99:Play();
            local v100 = v4.Create("noteAIntro" .. v98, {0, 1}, (crochet / 1000) * 2, {
                EaseDirection = "linear",
                callUpdate = function(v103)
                    setPropertyFromGroup("strumLineNotes", v98, "alpha", v103.position);
                end,
                delay = (((crochet / 1000) + ((v98 % 4) * 0.4)) * crochet) / 1000
            });
            v100:Play();
        end
    end
end
function hudCountdown(v47)
    scaleObject("nIconP1", 1.1, 1.1, false);
    scaleObject("nIconP2", 1.1, 1.1, false);
    if ((v47 == 1) and HudIntro) then
        doTweenX("raTextIntro", "rateText", v15, (crochet / 1000) * 2, "circOut");
        doTweenX("scTextIntro", "scoreText", v15, (crochet / 1000) * 2, "circOut");
    end
    if ((v47 == 2) and HudIntro) then
        doTweenY("hpIntro", "healthBar", v23[2], (crochet / 1000) * 2, "backOut");
    end
end
function onBeatHit()
    if (v1 and ((curBeat % (4 / iconSpeed)) == 0)) then
        scaleObject("nIconP1", 1.2, 1.2, false);
        scaleObject("nIconP2", 1.2, 1.2, false);
    end
    if ((songName == "Discord-Annoyer") and ((curBeat % 2) == 1)) then
        if ((((curBeat >= 32) and (curBeat < 156)) or ((curBeat >= 168) and (curBeat < 208)) or
            ((curBeat >= 216) and (curBeat < 232)) or ((curBeat >= 296) and (curBeat < 304))) and
            not ((curBeat >= 60) and (curBeat <= 63)) and (not curBeat ~= 127)) then
            setProperty("nIconP1.angle", -15);
            setProperty("nIconP2.angle", 15);
            doTweenAngle("nIconP1Spin", "nIconP1", 0, crochet / 1000, "quadOut");
            doTweenAngle("nIconP2Spin", "nIconP2", 0, crochet / 1000, "quadOut");
        end
    end
end
function healthPercent()
    return math.max(0, math.min(1, getHealth() / 2));
end
function noteMiss(v48, v49, v50, v51)
    HUDScoreUpdate(true, v51);
    loseMiss(true);
    local v52 = 1 - (getProperty("health") / 2);
    v18 = 16 * v52;
    if (v51 and New_Input) then
        for v101 = 0, getPropertyFromGroup("notes", v48, "parent.tail.length") - 1 do
            setProperty("notes.members[" .. v48 .. "].parent.tail[" .. v101 .. "].blockHit", true);
            setProperty("notes.members[" .. v48 .. "].parent.tail[" .. v101 .. "].ignoreNote", true);
            setProperty("notes.members[" .. v48 .. "].parent.tail[" .. v101 .. "].colorSwap.brightness", -0.5);
        end
    end
end
function loseMiss(v53, v54)
    local v54 = v54 or -1;
    if (LIVES > 0) then
        if (gotMiss or (v54 <= 0)) then
            curLive = curLive - 1;
            if (curLive <= 0) then
                addHealth(-9);
            end
        end
        setTextString("missText", "LIVES: " .. curLive .. "/" .. LIVES);
    end
end
function noteMissPress(v55)
    HUDScoreUpdate(true, false, true);
    local v56 = 1 - (getProperty("health") / 2);
    v18 = 16 * v56;
end
function onCustomSubstateCreate(v57)
    if (v57 == "FakePauseSubstate") then
        runTimer("canPress", 0.1);
        local v85 = (getDataFromSave("ammarc", "hardmode") and "HARD MODE") or "NORMAL";
        runHaxeCode([[
        curSelected = 0;
        totalElapsed = 0;
        menuItems = []] ..
                        (((songName:lower() == "no-debug") and not v6 and
                            (getDataFromSave("ammarc", "highscore")["no-debug"] == nil) and
                            "'Resume', 'Restart Song', 'Exit to Menu'") or
                            "'Resume', 'Restart Song', 'Charting Mode', 'Exit to Menu'") .. [[];
        grpMenuShit = [];
        songName = ']] .. songName:gsub("-", " ") .. [[';
        difficultyName = ']] .. v85 .. [[';
        deathCounter = ]] .. tostring(getPropertyFromClass("PlayState", "deathCounter")) .. [[;
        blueballed = 'Blueballed: ' + deathCounter;
        mobileMode = ]] .. ((v10 and "true") or "false") .. [[;

        changeSelection = function(?change = 0, makeSound:Bool = true)
        {
            curSelected += change;
            if (curSelected < 0)
                curSelected = menuItems.length - 1;
            if (curSelected >= menuItems.length)
                curSelected = 0;
    
            var bullShit = 0;
    
            for (item in grpMenuShit)
            {
                item.targetY = bullShit - curSelected;
                bullShit++;
            }

            if (makeSound) { 
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.4); 
            }

            game.setOnLuas('curSelectedPauseItem', menuItems[curSelected]);
        }
        FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);

        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFffffff);
        bg.color = 0xFF000000;
        bg.alpha = 0;
        bg.scrollFactor.set();
        CustomSubstate.instance.add(bg);

        checker = new FlxSprite(0, 0).loadGraphic(Paths.image("menu/checker"));
        checker.alpha = 0;
        checker.screenCenter();
        CustomSubstate.instance.add(checker);

        
        checker1 = new FlxSprite(0, 0).loadGraphic(Paths.image("menu/checker"));
        checker1.alpha = 0;
        checker1.screenCenter();
        checker1.x += 1280;
        CustomSubstate.instance.add(checker1);

        levelInfo = new FlxText(20, 15, 0, songName, 32);
        levelInfo.scrollFactor.set();
        levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
        levelInfo.updateHitbox();
        CustomSubstate.instance.add(levelInfo);

        levelDifficulty = new FlxText(20, 15 + 32, 0, ']] .. difficultyName:upper() .. [[', 32);
        levelDifficulty.scrollFactor.set();
        levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
        levelDifficulty.updateHitbox();
        CustomSubstate.instance.add(levelDifficulty);

        blueballedTxt = new FlxText(20, 15 + 64, 0, blueballed, 32);
        blueballedTxt.scrollFactor.set();
        blueballedTxt.setFormat(Paths.font('vcr.ttf'), 32);
        blueballedTxt.updateHitbox();
        CustomSubstate.instance.add(blueballedTxt);

        practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MDOE", 32);
        practiceText.scrollFactor.set();
        practiceText.setFormat(Paths.font('vcr.ttf'), 32);
        practiceText.x = FlxG.width - (practiceText.width + 20);
        practiceText.updateHitbox();
        practiceText.visible = game.practiceMode;
        CustomSubstate.instance.add(practiceText);

        chartingText = new FlxText(20, 15 + 101, 0, "CHARTING MODE", 32);
        chartingText.scrollFactor.set();
        chartingText.setFormat(Paths.font('vcr.ttf'), 32);
        chartingText.x = FlxG.width - (chartingText.width + 20);
        chartingText.y = FlxG.height - (chartingText.height + 20);
        chartingText.updateHitbox();
        chartingText.visible = game.chartingMode;
        CustomSubstate.instance.add(chartingText);

        buttonDown = new FlxSprite(1000, 480).loadGraphic(Paths.image("menu/mobileButtonMove"));
        buttonDown.setGraphicSize(buttonDown.width * 0.6);
        buttonDown.updateHitbox();
        buttonDown.antialiasing = false;
        buttonDown.angle = 90;
        buttonDown.alpha = 0.25;

        buttonUp = new FlxSprite(1000, 260).loadGraphic(Paths.image("menu/mobileButtonMove"));
        buttonUp.setGraphicSize(buttonUp.width * 0.6);
        buttonUp.updateHitbox();
        buttonUp.antialiasing = false;
        buttonUp.angle = -90;
        buttonUp.alpha = 0.25;

        buttonAccept = new FlxSprite(1000, 20).loadGraphic(Paths.image("menu/mobileButtonAccept"));
        buttonAccept.setGraphicSize(buttonAccept.width * 0.6);
        buttonAccept.updateHitbox();
        buttonAccept.antialiasing = false;
        buttonAccept.alpha = 0.25;

        if (mobileMode) {
            CustomSubstate.instance.add(buttonDown);
            CustomSubstate.instance.add(buttonUp);
            CustomSubstate.instance.add(buttonAccept);

            game.variables.set("buttonDown", buttonDown);
            game.variables.set("buttonUp", buttonUp);
            game.variables.set("buttonAccept", buttonAccept);
        }
       
       

        blueballedTxt.alpha = 0;
        levelDifficulty.alpha = 0;
        levelInfo.alpha = 0;

        levelInfo.x = FlxG.width - (levelInfo.width + 20);
        levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
        blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);

        FlxTween.tween(bg, {alpha: 0.6}, 0.2, {ease: FlxEase.quartInOut});
        FlxTween.tween(checker, {alpha: 0.3}, 1);
        FlxTween.tween(checker1, {alpha: 0.3}, 1);

        FlxTween.tween(checker, {x: -1280}, 10, {type: FlxTween.LOOPING});
        FlxTween.tween(checker1, {x: 0}, 10, {type: FlxTween.LOOPING});
        FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.2});
        FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.4});
        if (deathCounter >= 1) FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

        for (i in 0...menuItems.length) {
            textThingy = new Alphabet(90, 320, menuItems[i], true);
            textThingy.isMenuItem = true;
            textThingy.targetY = i;
            textThingy.changeX = false;
            grpMenuShit.push(textThingy);
            CustomSubstate.instance.add(textThingy);
            textThingy.x -= 800 + (i * 800);
        }
        changeSelection(0, false);

        pauseMusic = new FlxSound().loadEmbedded(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)), true, true);
        pauseMusic.volume = 0;
        pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
        FlxG.sound.list.add(pauseMusic);
    ]]);
    end
end
function onCustomSubstateUpdatePost(v58, v59)
    if (v58 == "FakePauseSubstate") then
        runHaxeCode([[
        if (CustomSubstate.instance.controls.UI_DOWN_P) changeSelection(1, true);
        if (CustomSubstate.instance.controls.UI_UP_P) changeSelection(-1, true);
        if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.01 * ]] .. tostring(v59) .. [[;

        totalElapsed += FlxG.elapsed;
        for (item in grpMenuShit) {
            var targetX = FlxMath.lerp(item.x, (1280/2) - item.width/2, FlxG.elapsed*8);
            item.x = targetX;
            if (item.targetY == 0)
            {
                var targetSize = FlxMath.lerp(item.scale.x, 1.25 + (FlxMath.fastSin(totalElapsed*4) * 0.1), FlxG.elapsed*6);
                var targetAlpha = FlxMath.lerp(item.alpha, 1, FlxG.elapsed*15);
                item.scale.set(targetSize, targetSize);
                item.alpha = targetAlpha;
            }
            else 
            {
                var targetSize = FlxMath.lerp(item.scale.x, 1, FlxG.elapsed*6);
                var targetAlpha = FlxMath.lerp(item.alpha, 0.5, FlxG.elapsed*9);
                item.scale.set(targetSize, targetSize);
                item.alpha = targetAlpha;
            }
        }
    ]]);
        if ((getProperty("controls.ACCEPT") or spriteClick("buttonAccept")) and v0) then
            if (curSelectedPauseItem:lower() == "resume") then
                closeCustomSubstate();
            elseif (curSelectedPauseItem:lower() == "restart song") then
                restartSong();
            elseif (curSelectedPauseItem:lower() == "charting mode") then
                runHaxeCode([[
                game.openChartEditor();
            ]]);
            elseif (curSelectedPauseItem:lower() == "exit to menu") then
                loadSong("ammar menu");
                setPropertyFromClass("PlayState", "seenCutscene", false);
            end
        end
        if (spriteClick("buttonUp") and v10) then
            runHaxeCode("changeSelection(-1, true);");
        end
        if (spriteClick("buttonDown") and v10) then
            runHaxeCode("changeSelection(1, true);");
        end
    end
end
function onCustomSubstateDestroy(v60)
    if (v60 == "FakePauseSubstate") then
        runHaxeCode([[
        pauseMusic.destroy();
    ]]);
    end
end
function onTimerCompleted(v61, v62, v63)
    if (v61 == "canPress") then
        v0 = true;
    end
    if (v61 == "loadDebugSong") then
        setDataFromSave("ammarc", "realDebugSong", true);
        loadSong("No-Debug");
    end
    if (v61 == "cheaterDetect") then
        cheaterDetected();
    end
    if (v61 == "turnOffChartingMode") then
        setPropertyFromClass("PlayState", "chartingMode", false);
    end
end
function onCountdownTick(v64)
    if v1 then
        hudCountdown(v64);
    end
    if (v64 == 1) then
        setObjectCamera("countdownReady", "other");
        setProperty("countdownReady.y", 500);
        scaleObject("countdownReady", 0.5, 0.5);
        screenCenter("countdownReady", "X");
    end
    if (v64 == 2) then
        setObjectCamera("countdownSet", "other");
        setProperty("countdownSet.y", 500);
        scaleObject("countdownSet", 0.5, 0.5);
        screenCenter("countdownSet", "X");
    end
    if (v64 == 3) then
        setObjectCamera("countdownGo", "other");
        setProperty("countdownGo.y", 460);
        scaleObject("countdownGo", 0.6, 0.6);
        screenCenter("countdownGo", "X");
    end
end
function onDestroy()
    setPropertyFromClass("flixel.FlxG", "autoPause", true);
    setPropertyFromClass("ClientPrefs", "comboStacking", v5);
    if v8 then
        setPropertyFromClass("ClientPrefs", "middleScroll", v9);
    end
end
function spriteClick(v65)
    if v10 then
        local v86 = getMouseX("camOther");
        local v87 = getMouseY("camOther");
        local v88, v89, v90, v91 = getProperty(v65 .. ".x"), getProperty(v65 .. ".y"), getProperty(v65 .. ".width"),
            getProperty(v65 .. ".height");
        return (v86 >= v88) and (v86 <= (v88 + v90)) and (v87 >= v89) and (v87 <= (v89 + v91)) and (mouseClicked(""));
    else
        return false;
    end
end
function lerp(v66, v67, v68)
    return v66 + ((v67 - v66) * v68);
end
