defaultNote = {}
local modchartEnable = true
local hradmodeEnable = true
function onCreate()
    makeLuaSprite("modchartVar", "", 0, 0)
    modchartEnable = getDataFromSave("ammarc", "mechanic")
    hardmodeEnable = getDataFromSave("ammarc", "hardmode")
end
function onStepHit()
    if modchartEnable and hardmodeEnable then
        modchart()
    end
end
function onUpdatePost(elapsed)
    if not inGameOver then
        modchartUpdate(elapsed)
    end
end

local noteArray = {
    {-1, 1, -1, 1},
    {1, -1, 1, -1}
}

function modchart()
    if curStep == 16 then 
        for i = 0,7 do 
            table.insert(defaultNote, {x = getPropertyFromGroup("strumLineNotes", i, "x"), y = getPropertyFromGroup("strumLineNotes", i, "y")})
        end
    end
    if (curStep >= 320 and curStep < 576) or (curStep >= 1376 and curStep < 1632) then 
        if curStep % 4 == 0 then
            for i = 0,7 do 
                setPropertyFromGroup("strumLineNotes",i,"y",defaultNote[i+1].y + (noteArray[curStep%8==0 and 1 or 2][i%4+1] * 40))
                noteTweenY("noteY"..i, i, defaultNote[i+1].y, crochet/1000, "quadOut")

                setPropertyFromGroup("strumLineNotes",i,"x",defaultNote[i+1].x + (curStep%8==0 and -50 or 50))
                noteTweenX("noteX"..i, i, defaultNote[i+1].x, crochet/1000, "quadOut")
            end
        end
    end

    if curStep == 608 then
        doTweenX("modchartVar", "modchartVar", 25, crochet/1000*4, "quadInOut")
    end
    if (curStep >= 736 and curStep < 864) or (curStep >= 992 and curStep < 1120) then
        if curStep%4 == 0  then
            doTweenX("modchartVar", "modchartVar", 35, crochet/1000*0.75, "quadOut")
        elseif curStep%4 == 3 then
            doTweenX("modchartVar", "modchartVar", -25, crochet/1000*0.25, "quadIn")
        end
    end
    if curStep == 864 then
        doTweenX("modchartVar", "modchartVar", 0, crochet/1000*4, "quadIn")
    end      
    if curStep == 1120 then
        for i = 0,7 do 
            noteTweenY("noteY"..i, i, defaultNote[i+1].y, crochet/1000*2, "quadOut")
        end
    end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
end

function modchartUpdate(elapsed)
    if curStep >= 608 and curStep < 1120 then
        for i = 0,7 do 
            setPropertyFromGroup("strumLineNotes",i,"y",defaultNote[i+1].y + (math.sin(getSongPosition()/150 + i*0.9) * getProperty("modchartVar.x")))
        end
    end
end