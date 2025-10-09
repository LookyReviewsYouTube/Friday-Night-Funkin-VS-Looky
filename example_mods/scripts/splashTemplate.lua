local settings = {

     --[[Script enabled?]]
     isEnabled = true,

     --[[Cache splashes?]]
     cacheSplashes = true,

     --[[
          Enable splashes for either character?
          First one is for player, second is opponent.
     ]]
     enableSplashForCharacter = {
          true, true
     },

     --[[
          Splash textures.
          First one is for player, second is opponent.
     ]]
     splashTextures = {
          'noteSplashes',
          'noteSplashes'
     },

     --[[
          Splash anims in each XML.
          First set is for player, second is opponent.
     ]]
     curSplashAnims = {
          {'note splash purple 1', 'note splash blue 1', 'note splash green 1', 'note splash red 1'},
          {'note splash purple 1', 'note splash blue 1', 'note splash green 1', 'note splash red 1'}
     },

     --[[
          Scale of the splashes.
          First set is for player, second is opponent.
          Default scales are (0.75).
     ]]
     splashScaling = {
          {0.75, 0.75},
          {0.75, 0.75}
     },

     --[[
          Alphas for the splashes.
          First one is for player, second is opponent.
     ]]
     splashAlphas = {
          0.6, 0.6
     },

     --[[
          Do the splashes have anti-aliasing?
          First one is for player, second is opponent.
     ]]
     hasAntialiasing = {
          true, true
     },

     --[[
          Positions for each splash. Keep these nil, since they're handled under onCreatePost(). You'll want to edit this from there.
          First set is for the player, second is for the opponent.
     ]]
     splashPOS = {
          {{nil, nil}, {nil, nil}, {nil, nil}, {nil, nil}},
          {{nil, nil}, {nil, nil}, {nil, nil}, {nil, nil}}
     },

     --[[Blacklist of your noteTypes go here. Each not listed is prevented from splashing.]]
     blackList = {
          'example note',
          'example two note'
     }

}

function onCreatePost()

     local cSplashEnabled = getPropertyFromClass('ClientPrefs', 'noteSplashes');
     if (not cSplashEnabled) or ((not settings.enableSplashForCharacter[1]) and (not settings.enableSplashForCharacter[2])) then settings.isEnabled = false end

     if settings.isEnabled then

          luaDebugMode = true

          for k, v in pairs(settings.blackList) do settings.blackList[k] = ('"'..v:gsub('"', '\\"')..'"') end

          if settings.cacheSplashes then for guh = 1, #settings.splashTextures do precacheImage(settings.splashTextures[guh]); end end
     
          -- Y values for upscroll and downscroll here. "u" means upscroll, "d" means downscroll, pretty self-explanatory.
          local y = {u = -30, d = 500}
     
          if (not middlescroll) and (not downscroll) then -- upscroll
               settings.splashPOS = {
                    {{660, y.u}, {770, y.u}, {883, y.u}, {993, y.u}},
                    {{18, y.u}, {130, y.u}, {243, y.u}, {353, y.u}}
               }
          elseif (not middlescroll) and (downscroll) then -- downscroll
               settings.splashPOS = {
                    {{550, y.d}, {660, y.d}, {773, y.d}, {883, y.d}},
                    {{18, y.d}, {130, y.d}, {243, y.d}, {353, y.d}}
               }
          elseif (middlescroll) and (not downscroll) then -- upscroll + middlescroll
               settings.splashPOS = {
                    {{340, y.u}, {450, y.u}, {563, y.u}, {673, y.u}},
                    {{8, y.u}, {118, y.u}, {893, y.u}, {1013, y.u}}
               }
          elseif (middlescroll) and (downscroll) then -- downscroll + middlescroll
               settings.splashPOS = {
                    {{340, y.d}, {450, y.d}, {563, y.d}, {673, y.d}},
                    {{8, y.d}, {118, y.d}, {893, y.d}, {1013, y.d}}
               }
          end

          -- Edit all the splash stuff here!

          for splashIndex = 0, 3 do

               if (settings.enableSplashForCharacter[1]) then

                    makeAnimatedLuaSprite('splash_'..splashIndex, settings.splashTextures[1], settings.splashPOS[1][(splashIndex + 1)][1], settings.splashPOS[1][(splashIndex + 1)][2]);
                    addAnimationByPrefix('splash_'..splashIndex, 'spurt', settings.curSplashAnims[1][(splashIndex + 1)], 24, false);
                    setObjectCamera('splash_'..splashIndex, 'camHUD');
                    setObjectOrder('splash_'..splashIndex, getObjectOrder('strumLineNotes') + 1);
                    scaleObject('splash_'..splashIndex, settings.splashScaling[1][1], settings.splashScaling[1][2]);
                    setProperty('splash_'..splashIndex..'.alpha', settings.splashAlphas[1]);
                    setProperty('splash_'..splashIndex..'.antialiasing', settings.hasAntialiasing[1]);
                    setProperty('splash_'..splashIndex..'.visible', false);
                    addLuaSprite('splash_'..splashIndex, false);

               end

               if (settings.enableSplashForCharacter[2]) then

                    makeAnimatedLuaSprite('Osplash_'..splashIndex, settings.splashTextures[2], settings.splashPOS[2][(splashIndex + 1)][1], settings.splashPOS[2][(splashIndex + 1)][2]);
                    addAnimationByPrefix('Osplash_'..splashIndex, 'spurt', settings.curSplashAnims[2][(splashIndex + 1)], 24, false);
                    setObjectCamera('Osplash_'..splashIndex, 'camHUD');
                    setObjectOrder('Osplash_'..splashIndex, getObjectOrder('strumLineNotes') + 1);
                    scaleObject('Osplash_'..splashIndex, settings.splashScaling[2][1], settings.splashScaling[2][2]);
                    if (settings.splashAlphas[2] > 0.6) and (middlescroll) then settings.splashAlphas[2] = 0.6 end
                    setProperty('Osplash_'..splashIndex..'.alpha', settings.splashAlphas[2]);
                    setProperty('Osplash_'..splashIndex..'.antialiasing', settings.hasAntialiasing[2]);
                    setProperty('Osplash_'..splashIndex..'.visible', false);
                    addLuaSprite('Osplash_'..splashIndex, false);

               end

          end

     end

end

function goodNoteHit(i, d, n, s) check(i, d, n, s, true); end
function opponentNoteHit(i, d, n, s) check(i, d, n, s, false); end

function check(i, d, n, s, isPlayer)
     local isBlackList = runHaxeCode('return ['..table.concat(settings.blackList, ', ')..'].contains("'..n:lower()..'");')
     if (not isBlackList) and (settings.isEnabled) then
          if (isPlayer) and (settings.enableSplashForCharacter[1]) then playerSplash(i, d, n, s);
          elseif (not isPlayer) and (settings.enableSplashForCharacter[2]) then opponentSplash(i, d, n, s);
          end
     end
end

function playerSplash(i, d, n, s)
     local sick = (getPropertyFromGroup('notes', i, 'rating') == 'sick')
     if (sick) and (not s) then setProperty('grpNoteSplashes.visible', false); setProperty('splash_'..d..'.visible', true); playAnim('splash_'..d, 'spurt', true); end
end

function opponentSplash(i, d, n, s) if (not s) then setProperty('Osplash_'..d..'.visible', true); playAnim('Osplash_'..d, 'spurt', true); end end

function onUpdatePost(e)
     if (settings.isEnabled) then
          for i = 0, 3 do
               if (settings.enableSplashForCharacter[1]) and getProperty('splash_'..i..'.animation.curAnim.name') == 'spurt' and getProperty('splash_'..i..'.animation.curAnim.finished') then
                    setProperty('splash_'..i..'.visible', false);
               end
               if (settings.enableSplashForCharacter[2]) and getProperty('Osplash_'..i..'.animation.curAnim.name') == 'spurt' and getProperty('Osplash_'..i..'.animation.curAnim.finished') then
                    setProperty('Osplash_'..i..'.visible', false);
               end
          end
     end
end