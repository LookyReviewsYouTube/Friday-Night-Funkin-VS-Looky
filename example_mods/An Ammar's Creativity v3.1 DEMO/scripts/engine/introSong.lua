local textTargetPosX = 0
local logoTargetPosX = 0

local folder = "intro/"

logoName = ""
songs = {
   ["discord annoyer"] = "discord",
   ["shut up"] = "discord",
   ["hate comment"] = "youtube",
   ["twitter argument"] = "twitter",
   ["no debug"] = ""
}
doStuff = false

function onCreate()
   luaDebugMode = true
end
function onCreatePost()
   local songNameA = string.lower(songName:gsub( "-", " "))

   if songs[songNameA] == nil or songs[songNameA] == "" then return end

   doStuff = true
   logoName = songs[songNameA]
   
   makeLuaSprite("logo", (logoName == "" and "" or folder .. logoName) ,0,0)
   scaleObject("logo", 0.6, 0.6)
   setObjectCamera("logo", 'other')
   addLuaSprite("logo")
   screenCenter("logo")
   setBlendMode("logo", "add")

   makeLuaText("title", songName:gsub( "-", " ") , 500 ,0,0)
   setTextSize("title", 64)
   setObjectCamera("title", 'other')
   setTextFont("title", 'PhantoMuff/PhantomMuff Full Letters.ttf')
   setTextAlignment("title", "center")
   addLuaText("title")
   setTextBorder("title", 4, "000000")
   screenCenter("title")

   makeLuaText("hardmodeInfo", "(HARD MODE)" , 500 ,0, 450)
   setTextSize("hardmodeInfo", 32)
   setObjectCamera("hardmodeInfo", 'other')
   setTextFont("hardmodeInfo", 'PhantoMuff/PhantomMuff Full Letters.ttf')
   setTextAlignment("hardmodeInfo", "center")
   addLuaText("hardmodeInfo")
   setTextBorder("hardmodeInfo", 4, "000000")
   setTextColor('hardmodeInfo', "FF0000")
   screenCenter("hardmodeInfo", "X")

   if not getDataFromSave("ammarc", "hardmode") then
      setProperty("hardmodeInfo.visible", false)
   end
   setProperty("logo.alpha", 0)
   setProperty("title.alpha", 0)
   setProperty("hardmodeInfo.alpha", 0)
   
   textTargetPosX = getProperty("title.x")
   logoTargetPosX = getProperty("logo.x")
end

local eaaa = 0
function onUpdatePost(elapsed)
   if doStuff then
      eaaa = eaaa + elapsed
      setProperty("logo.angle", math.sin(eaaa*3) * 10)
   end
end

function onSongStart()
   startShowing()
end

function startShowing()
   local dur = 0.7
   scaleObject("logo", 0.6 + 0.5, 0.6 + 0.5, false)
   scaleObject("title", 1.5, 1.5, false)

   doTweenX("introLogoCX", "logo.scale", 0.6, dur, "quadIn")
   doTweenY("introLogoCY", "logo.scale", 0.6, dur, "quadIn")
   doTweenX("introTitleCX", "title.scale", 1, dur, "quadIn")
   doTweenY("introTitleCY", "title.scale", 1, dur, "quadIn")


   doTweenAlpha("introTA", "title", 1, dur, "quadIn")
   doTweenAlpha("introLA", "logo", 1, dur, "quadIn")
   doTweenAlpha("introHard", "hardmodeInfo", 1, dur, "linear")
   runTimer("endIntro", 2)
end

function onTimerCompleted(tag, loops, loopsLeft)
   if tag == "endIntro" then
      local dur = 0.7
      doTweenAlpha("introTA", "title", 0, dur)
      doTweenAlpha("introLA", "logo", 0, dur)
      doTweenAlpha("introHard", "hardmodeInfo", 0, dur, "linear")
   end
end
