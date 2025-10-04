local v0 = false;
thingLerp = 1;
local v1 = true;
local v2 = false;
local v3 = false;
local v4 = true;
function onCreate()
    v4 = getDataFromSave("ammarc", "mechanic");
    v0 = getPropertyFromClass("ClientPrefs", "middleScroll");
    if v4 then
        setPropertyFromClass("ClientPrefs", "middleScroll", true);
    end
    setProperty("cameraSpeed", 1.1);
    if (getDataFromSave("ammarc", "highscore")["no-debug"] == nil) then
        setDataFromSave("ammarc", "hardmode", false);
        v2 = true;
    end
    if getDataFromSave("ammarc", "hardmode") then
        addLuaScript("data/" .. songPath .. "/modchart/eventsHard");
        addLuaScript("data/" .. songPath .. "/modchart/zmodchartHard");
        v3 = true;
    else
        addLuaScript("data/" .. songPath .. "/modchart/events");
        addLuaScript("data/" .. songPath .. "/modchart/zmodchart");
        v3 = false;
    end
end
function onDestroy()
    if v2 then
        setDataFromSave("ammarc", "hardmode", true);
    end
end
function onCreatePost()
    v1 = getDataFromSave("ammarc", "shaders") and getPropertyFromClass("ClientPrefs", "shaders");
    addHaxeLibrary("ShaderFilter", "openfl.filters");
    initLuaShader("scroll");
    makeLuaSprite("scrollShader");
    setSpriteShader("scrollShader", "scroll");
    setShaderFloat("scrollShader", "xSpeed", 10);
    setShaderFloat("scrollShader", "ySpeed", 0);
    setShaderFloat("scrollShader", "timeMulti", 0.1);
    setShaderFloat("scrollShader", "iTime", 0);
    if v1 then
        initLuaShader("ColorsEdit");
        makeLuaSprite("colorShader");
        setSpriteShader("colorShader", "ColorsEdit");
        runHaxeCode([[
    game.camGame.setFilters([new ShaderFilter(game.getLuaObject("colorShader").shader)]);
    game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("colorShader").shader)]);
 ]]);
        setShaderFloat("colorShader", "contrast", 1);
        setShaderFloat("colorShader", "saturation", 0.5);
        setShaderFloat("colorShader", "brightness", 1);
    end
    setProperty("camGame.maxScrollY", 1100);
    if (getDataFromSave("ammarc", "realDebugSong") or
        (getDataFromSave("ammarc", "prevSong") == (songName:gsub(" ", "-")):lower())) then
        setDataFromSave("ammarc", "realDebugSong", false);
    else
        exitSong(false);
    end
    if getDataFromSave("ammarc", "hardmode") then
        createNote();
    end
end
function onUpdatePost(v5)
    if not inGameOver then
        if (curBeat >= 68) then
            thingLerp = lerp(thingLerp, 0.8, v5 * 7);
            setProperty("cameraSpeed", thingLerp);
        end
        if (v1 and v4) then
            setShaderFloat("scrollShader", "iTime", getProperty("scrollShader.x"));
        end
    end
end
function opponentNoteHit(v6, v7, v8, v9)
    if (not v9 and v4 and (curStep <= 272)) then
        addHealth(-0.015);
    end
end
function onDestroy()
    setPropertyFromClass("ClientPrefs", "middleScroll", v0);
end
function createNote()
    addHaxeLibrary("Song");
    addHaxeLibrary("SwagSong", "Song");
    addHaxeLibrary("Section");
    addHaxeLibrary("SwagSection", "Section");
    addHaxeLibrary("Note");
    addHaxeLibrary("Std");
    addHaxeLibrary("Math");
    addHaxeLibrary("FlxMath", "flixel.math");
    for v13 = getProperty("unspawnNotes.length") - 1, 0, -1 do
        removeFromGroup("unspawnNotes", v13, true);
    end
    runHaxeCode([[
var SecondSong:SwagSong;
SecondSong = Song.loadFromJson(']] .. songPath .. [[-hard', ']] .. songPath .. [[');
var Notedata:Array<SwagSection>=SecondSong.notes;
for (Section in Notedata)
{
    for (songNotes in Section.sectionNotes)
    {
      var Strum:Float =songNotes[0];
      var NoteData:Int = Std.int(songNotes[1] % 4);
      var MustHitSection= Section.mustHitSection;
      if (songNotes[1] > 3)
      {
        MustHitSection = !Section.mustHitSection;
      }
      var LastNote:Note;
      if (game.unspawnNotes.length > 0) LastNote = game.unspawnNotes[Std.int(game.unspawnNotes.length - 1)];
      else LastNote = null;
      var NewNote:Note = new Note(Strum, NoteData, LastNote);
      NewNote.mustPress = MustHitSection;
      NewNote.sustainLength = songNotes[2];
      NewNote.noteType = songNotes[3];
      NewNote.scrollFactor.set();

      var Length:Float = NewNote.sustainLength;

      Length=Length / Conductor.stepCrochet;
      game.unspawnNotes.push(NewNote);

      var floor:Int = Math.floor(Length);
        if(floor > 0) {
            for (susNote in 0...floor+1)
            {
                LastNote = game.unspawnNotes[Std.int(game.unspawnNotes.length - 1)];
                var NewSustan:Note = new Note(Strum + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(]] ..
                    getProperty("songSpeed") .. [[, 2)), NoteData, LastNote, true);
                NewSustan.mustPress = MustHitSection;
                NewSustan.noteType = NewNote.noteType;
                NewSustan.scrollFactor.set();
                NewNote.tail.push(NewSustan);
                NewSustan.parent = NewNote;
                game.unspawnNotes.push(NewSustan);
                if (NewSustan.mustPress) NewSustan.x += FlxG.width / 2;
                else if(ClientPrefs.middleScroll) 
                {
                    NewSustan.x += 310;
                    if(NoteData > 1) NewSustan.x += FlxG.width / 2 + 25;
                }
            }
        }
        if (NewNote.mustPress) NewNote.x += FlxG.width / 2;
        else if(ClientPrefs.middleScroll)
        {
            NewNote.x += 310;
            if(Notedata > 1) NewNote.x += FlxG.width / 2 + 25;
        }
    }

    game.unspawnNotes.sort(game.sortByTime);
}

var songKey = Paths.formatToSongPath(song) + "/Inst-hard";
Paths.returnSound('songs', songKey);
]]);
end
function onCountdownStarted()
    if (getDataFromSave("ammarc", "hardmode")) then
        runHaxeCode([[
    coolVoices = function(song) {
        var songKey = Paths.formatToSongPath(song) + "/Voices-hard";
        var voices = Paths.returnSound('songs', songKey);
        return voices;
    }
    game.vocals.loadEmbedded(coolVoices(PlayState.SONG.song));
]]);
    end
end
function onSongStart()
    if getDataFromSave("ammarc", "hardmode") then
        runHaxeCode([[
        coolInst = function(song) {
            var songKey = Paths.formatToSongPath(song) + "/Inst-hard";
            var voices = Paths.returnSound('songs', songKey);
            return voices;
        }

        FlxG.sound.playMusic(coolInst(PlayState.SONG.song));

        game.songLength = FlxG.sound.music.length;
    ]]);
    end
end
function lerp(v10, v11, v12)
    return v10 + ((v11 - v10) * v12);
end
