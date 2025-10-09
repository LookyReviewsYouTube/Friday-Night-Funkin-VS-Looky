function onCreatePost()
    makeLuaText("subtitle", "", 0, 0, 500)
    setTextSize("subtitle", 32)
    addLuaText("subtitle", true)
    screenCenter("subtitle", "X")
    addHaxeLibrary('Std')
    runHaxeCode([[
        var subtitleIcon = new HealthIcon(game.dad.curCharacter);
        subtitleIcon.cameras = [game.camHUD];
        subtitleIcon.screenCenter();
        subtitleIcon.setGraphicSize(Std.int(subtitleIcon.width * 0.65));
        subtitleIcon.updateHitbox();
        subtitleIcon.y = game.getLuaObject('subtitle').y + -128;
        game.add(subtitleIcon);
        subtitleIcon.visible = false;
        setVar('subtitleIcon', subtitleIcon);
    ]])
end
function onEvent(name, v1, v2)
    if name == "Set_Subtitle" then
        local a = stringSplit(v1, ":")
        local text = a[1]
        local player = #a >= 1 and a[2] or ""
        setTextString("subtitle", text)
        setTextColor("subtitle", #v2 >= 6 and v2 or "0xFFFFFFFF")
        screenCenter("subtitle", "X")
        runHaxeCode([[
            var icon = getVar("subtitleIcon");
            var name = "]]..player..[[";
            icon.visible = name.length > 0;
            icon.changeIcon(name);
        ]])
		runTimer('textgone', 2, 2)
		setProperty('subtitle.alpha', 1)

    end
end
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'textgone' then -- Timer completed, play dialogue
		doTweenAlpha('subtitle','subtitle',0,0.5,linear)
     	
     	setProperty('subtitleIcon.visible', false)
	end
end
