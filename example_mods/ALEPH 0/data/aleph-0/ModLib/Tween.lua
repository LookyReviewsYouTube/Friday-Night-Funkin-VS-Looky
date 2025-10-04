--
-- Adapted from
-- Tweener's easing functions (Penner's Easing Equations)
-- and http://code.google.com/p/tweener/ (jstweener javascript version)
--

-- For all easing functions:
-- t = time
-- b = begin
-- c = change == ending - beginning
-- d = duration

local pow = math.pow
local sin = math.sin
local cos = math.cos
local pi = math.pi
local sqrt = math.sqrt
local abs = math.abs
local asin  = math.asin

local function linear(t, b, c, d)
  return c * t / d + b
end

local function inQuad(t, b, c, d)
  t = t / d
  return c * pow(t, 2) + b
end

local function outQuad(t, b, c, d)
  t = t / d
  return -c * t * (t - 2) + b
end

local function inOutQuad(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return c / 2 * pow(t, 2) + b
  else
    return -c / 2 * ((t - 1) * (t - 3) - 1) + b
  end
end

local function inCubic (t, b, c, d)
  t = t / d
  return c * pow(t, 3) + b
end

local function outCubic(t, b, c, d)
  t = t / d - 1
  return c * (pow(t, 3) + 1) + b
end

local function inOutCubic(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return c / 2 * t * t * t + b
  else
    t = t - 2
    return c / 2 * (t * t * t + 2) + b
  end
end

local function outInCubic(t, b, c, d)
  if t < d / 2 then
    return outCubic(t * 2, b, c / 2, d)
  else
    return inCubic((t * 2) - d, b + c / 2, c / 2, d)
  end
end

local function inQuart(t, b, c, d)
  t = t / d
  return c * pow(t, 4) + b
end

local function outQuart(t, b, c, d)
  t = t / d - 1
  return -c * (pow(t, 4) - 1) + b
end

local function inOutQuart(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return c / 2 * pow(t, 4) + b
  else
    t = t - 2
    return -c / 2 * (pow(t, 4) - 2) + b
  end
end

local function outInQuart(t, b, c, d)
  if t < d / 2 then
    return outQuart(t * 2, b, c / 2, d)
  else
    return inQuart((t * 2) - d, b + c / 2, c / 2, d)
  end
end

local function inQuint(t, b, c, d)
  t = t / d
  return c * pow(t, 5) + b
end

local function outQuint(t, b, c, d)
  t = t / d - 1
  return c * (pow(t, 5) + 1) + b
end

local function inOutQuint(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return c / 2 * pow(t, 5) + b
  else
    t = t - 2
    return c / 2 * (pow(t, 5) + 2) + b
  end
end

local function outInQuint(t, b, c, d)
  if t < d / 2 then
    return outQuint(t * 2, b, c / 2, d)
  else
    return inQuint((t * 2) - d, b + c / 2, c / 2, d)
  end
end

local function inSine(t, b, c, d)
  return -c * cos(t / d * (pi / 2)) + c + b
end

local function outSine(t, b, c, d)
  return c * sin(t / d * (pi / 2)) + b
end

local function inOutSine(t, b, c, d)
  return -c / 2 * (cos(pi * t / d) - 1) + b
end

local function outInSine(t, b, c, d)
  if t < d / 2 then
    return outSine(t * 2, b, c / 2, d)
  else
    return inSine((t * 2) -d, b + c / 2, c / 2, d)
  end
end

local function inExpo(t, b, c, d)
  if t == 0 then
    return b
  else
    return c * pow(2, 10 * (t / d - 1)) + b - c * 0.001
  end
end

local function outExpo(t, b, c, d)
  if t == d then
    return b + c
  else
    return c * 1.001 * (-pow(2, -10 * t / d) + 1) + b
  end
end

local function inOutExpo(t, b, c, d)
  if t == 0 then return b end
  if t == d then return b + c end
  t = t / d * 2
  if t < 1 then
    return c / 2 * pow(2, 10 * (t - 1)) + b - c * 0.0005
  else
    t = t - 1
    return c / 2 * 1.0005 * (-pow(2, -10 * t) + 2) + b
  end
end

local function outInExpo(t, b, c, d)
  if t < d / 2 then
    return outExpo(t * 2, b, c / 2, d)
  else
    return inExpo((t * 2) - d, b + c / 2, c / 2, d)
  end
end

local function inCirc(t, b, c, d)
  t = t / d
  return(-c * (sqrt(1 - pow(t, 2)) - 1) + b)
end

local function outCirc(t, b, c, d)
  t = t / d - 1
  return(c * sqrt(1 - pow(t, 2)) + b)
end

local function inOutCirc(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return -c / 2 * (sqrt(1 - t * t) - 1) + b
  else
    t = t - 2
    return c / 2 * (sqrt(1 - t * t) + 1) + b
  end
end

local function outInCirc(t, b, c, d)
  if t < d / 2 then
    return outCirc(t * 2, b, c / 2, d)
  else
    return inCirc((t * 2) - d, b + c / 2, c / 2, d)
  end
end

local function inElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d

  if t == 1  then return b + c end

  if not p then p = d * 0.3 end

  local s

  if not a or a < abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * asin(c/a)
  end

  t = t - 1

  return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
end

-- a: amplitud
-- p: period
local function outElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d

  if t == 1 then return b + c end

  if not p then p = d * 0.3 end

  local s

  if not a or a < abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * asin(c/a)
  end

  return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p) + c + b
end

-- p = period
-- a = amplitud
local function inOutElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d * 2

  if t == 2 then return b + c end

  if not p then p = d * (0.3 * 1.5) end
  if not a then a = 0 end

  if not a or a < abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * asin(c / a)
  end

  if t < 1 then
    t = t - 1
    return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
  else
    t = t - 1
    return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p ) * 0.5 + c + b
  end
end

-- a: amplitud
-- p: period
local function outInElastic(t, b, c, d, a, p)
  if t < d / 2 then
    return outElastic(t * 2, b, c / 2, d, a, p)
  else
    return inElastic((t * 2) - d, b + c / 2, c / 2, d, a, p)
  end
end

local function inBack(t, b, c, d, s)
  if not s then s = 1.70158 end
  t = t / d
  return c * t * t * ((s + 1) * t - s) + b
end

local function outBack(t, b, c, d, s)
  if not s then s = 1.70158 end
  t = t / d - 1
  return c * (t * t * ((s + 1) * t + s) + 1) + b
end

local function inOutBack(t, b, c, d, s)
  if not s then s = 1.70158 end
  s = s * 1.525
  t = t / d * 2
  if t < 1 then
    return c / 2 * (t * t * ((s + 1) * t - s)) + b
  else
    t = t - 2
    return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
  end
end

local function outInBack(t, b, c, d, s)
  if t < d / 2 then
    return outBack(t * 2, b, c / 2, d, s)
  else
    return inBack((t * 2) - d, b + c / 2, c / 2, d, s)
  end
end

local function outBounce(t, b, c, d)
  t = t / d
  if t < 1 / 2.75 then
    return c * (7.5625 * t * t) + b
  elseif t < 2 / 2.75 then
    t = t - (1.5 / 2.75)
    return c * (7.5625 * t * t + 0.75) + b
  elseif t < 2.5 / 2.75 then
    t = t - (2.25 / 2.75)
    return c * (7.5625 * t * t + 0.9375) + b
  else
    t = t - (2.625 / 2.75)
    return c * (7.5625 * t * t + 0.984375) + b
  end
end

local function inBounce(t, b, c, d)
  return c - outBounce(d - t, 0, c, d) + b
end

local function inOutBounce(t, b, c, d)
  if t < d / 2 then
    return inBounce(t * 2, 0, c, d) * 0.5 + b
  else
    return outBounce(t * 2 - d, 0, c, d) * 0.5 + c * .5 + b
  end
end

local function outInBounce(t, b, c, d)
  if t < d / 2 then
    return outBounce(t * 2, b, c / 2, d)
  else
    return inBounce((t * 2) - d, b + c / 2, c / 2, d)
  end
end

Ease = {
  linear = linear,
  quadIn = inQuad,
  quadOut = outQuad,
  quadInOut = inOutQuad,
  cubicIn  = inCubic ,
  cubicOut = outCubic,
  cubicInOut = inOutCubic,
  cubicOutIn = outInCubic,
  quartIn = inQuart,
  quartOut = outQuart,
  quartInOut = inOutQuart,
  quartOutIn = outInQuart,
  quintIn = inQuint,
  quintOut = outQuint,
  quintInOut = inOutQuint,
  quintOutIn = outInQuint,
  sineIn = inSine,
  sineOut = outSine,
  sineInOut = inOutSine,
  sineOutIn = outInSine,
  expoIn = inExpo,
  expoOut = outExpo,
  expoInOut = inOutExpo,
  expoOutIn = outInExpo,
  circIn = inCirc,
  circOut = outCirc,
  circInOut = inOutCirc,
  circOutIn = outInCirc,
  elasticIN = inElastic,
  elasticOut = outElastic,
  elasticInOut = inOutElastic,
  elasticOutIn = outInElastic,
  backIn = inBack,
  backOut = outBack,
  backInOut = inOutBack,
  backOutIn = outInBack,
  bounceIn = inBounce,
  bounceOut = outBounce,
  bounceInOut = inOutBounce,
  bounceOutIn = outInBounce,
}

--                  TWEEN MODULE BY RORUTOP                  --
--                     MODIFIED BY AN AMMAR                    --

function lerp(a,b,t) return a * (1-t) + b * t end
function limitToOne(min,max,t)
    return (t - min) / (max - min)
end
function cubicBezier(t, p0, p1, p2, p3)
	return (1 - t)^3*p0 + 3*(1 - t)^2*t*p1 + 3*(1 - t)*t^2*p2 + t^3*p3
end
function ValueToKey(t)
    local i={}
    for k,v in pairs(t) do 
        i[k] = k
    end
    return i
end
function FindValueByKey(tbl,key)
    for i,v in pairs(tbl) do
        if i == key then
            return v
        end
    end
    return nil
end
function getIndexFromValueById(tbl,specifyid,id)
    local letabel = {}
	for i,v in pairs(tbl) do
        table.insert(letabel,v)
	end
    for i,v in pairs(letabel) do
        if v[specifyid] == id then
			return i
		end
    end
	return nil
end
function isKeyinTbl(tbl)
    for i,v in pairs(tbl) do
        if type(i) == 'string' then
           return true
        end
    end
    return false
end

local valueLists = {['x'] = '.x' ,['y'] = '.y' ,['scalex'] = '.scale.x' ,['scaley'] = '.scale.y' ,['width'] = '.width' ,['height'] = '.height' ,['angle'] = '.angle' ,['alpha'] = '.alpha'}

local Tween = {}
Tween.CurrentTweens = {}
Tween.CurrentPlaying = {}
Tween.__index = Tween

local Signal = {}
Signal.Threads = {}
Signal.__index = Signal
function Signal.New(call)
    local self = {}
    self.Active = true
    self.Paused = false
    self.Elapsed = 0
    self.CallFunc = call
    function self:Pause()
        self.Paused = true
    end
    function self:Resume()
        self.Paused = false
    end
    function self:Disconnect()
        self.Active = false
    end
    table.insert(Signal.Threads,setmetatable(self,Signal))
    return setmetatable(self,Signal)
end

function Tween.Update(elapsed) -- cant use onUpdate cuz when using a script and require with it the onUpdate in module stops so put this shit in onUpdate or onUpdatePost with the elapsed parameter yeah idk
  for i,v in ipairs(Signal.Threads) do
        if v.Active and not v.Paused then
            v.CallFunc(elapsed)
        elseif not v.Paused then
            table.remove(Signal.Threads,getIndexFromValueById(Signal.Threads,'Active',false))
        end
    end
end

function Tween.Create(obj,position,duration,options)
    local lowercase = {{},{}}
    local self = {}
    if type(position) ~= 'table' then
        debugPrint('ERROR : Position must be a table.')
        return nil
    elseif isKeyinTbl(position) then
        for i,v in pairs(position) do
            lowercase[1][i:lower()] = v
        end
    end
    if type(options) ~= 'table' then
        debugPrint('WARNING : Options is not a table! Making it a default rn..')
        self.options = {easedirection = 'linear'}
    else
        for i,v in pairs(options) do
            lowercase[2][i:lower()] = v
        end
        self.options = lowercase[2]
    end
    self.obj = obj
    if not isKeyinTbl(position) then self.position = position[1] end
    self.pos = isKeyinTbl(position) and lowercase[1] or position
    -- POSITIONS: x , y , scalex , scaley , width , height , angle , alpha
    self.duration = duration
    -- OTHERS: EaseDirection , CallFunc
    table.insert(Tween.CurrentTweens,setmetatable(self,Tween))
    return setmetatable(self,Tween)
end

function Tween:Play()
    local obj = self.obj
    for i,v in pairs(Tween.CurrentPlaying) do
        if i:find(obj) and v == false then
            Tween.CurrentPlaying[i] = true
        end
    end

    local randomname = obj..math.random(1,99999999)
    Tween.CurrentPlaying[randomname] = false

    local currentOptions = self.options
    local currentFinishFunction
    local easedir = ''
    local easefound = false
    for i,v in pairs(Ease) do
        if currentOptions.easedirection:lower() == i:lower() then
            easedir = i
            easefound = true
            break
        end
    end
    if not easefound then
        --debugPrint('WARNING : Ease not found!!!!! Making it linear rn....')
        easedir = 'linear'
    end

    local currentDuration = self.duration
    local currentType = self.type
    local timer = 0
    if isKeyinTbl(self.pos) then
        local startValues = {}
        local currentValues = self.pos
        for i,v in pairs(self.pos) do
            startValues[i] = getProperty(obj..valueLists[i])
        end
        --local magnitude = {math.sqrt((self.pos.x or 0)^2 + (self.pos.y or 0)^2),math.sqrt(startValues.x^2 + startValues.y^2)}
        local lesignal
        lesignal = Signal.New(function(dt)
            if FindValueByKey(Tween.CurrentPlaying,randomname) == true then
                lesignal:Disconnect()
            end
            timer = timer + dt
            if currentOptions.callupdate ~= nil then currentOptions.callupdate(self) end
            if timer >= currentDuration then
                timer = currentDuration
                if currentOptions.callfunc ~= nil then currentOptions.callfunc() end
                lesignal:Disconnect()
            end
            local ratio = Ease[easedir](timer,0,1,currentDuration)
            local destinated = {}
            for i,v in pairs(currentValues) do
                if type(v) ~= 'table' then
                    destinated[i] = lerp(startValues[i],v,ratio)
                else
                    destinated[i] = cubicBezier(ratio,startValues[i],v[1],v[2],v[3])
                end
            end
            for i,v in pairs(destinated) do
                if i == ValueToKey(valueLists)[i] then
                    setProperty(obj..valueLists[i],v)
                end
            end
        end)
    else
        local currentValues = self.pos
        local lesignal
        lesignal = Signal.New(function(dt)
            if FindValueByKey(Tween.CurrentPlaying,randomname) == true then
                lesignal:Disconnect()
            end
            timer = timer + dt
            if currentOptions.callupdate ~= nil then currentOptions.callupdate(self) end
            if timer >= currentDuration then
                timer = currentDuration
                if currentOptions.callfunc ~= nil then currentOptions.callfunc() end
                lesignal:Disconnect()
            end
            local ratio = Ease[easedir](timer,0,1,currentDuration)
            if #currentValues >= 2 and #currentValues <= 3 then
                self.position = lerp(currentValues[1],currentValues[2],ratio)
            elseif #currentValues == 4 then
                self.position = cubicBezier(ratio,currentValues[1],currentValues[2],currentValues[3],currentValues[4])
            end
        end)
    end
end

function Tween:Stop()
    for i,v in pairs(Tween.CurrentPlaying) do
        if i:find(self.obj) and v == false then
            Tween.CurrentPlaying[i] = true
        end
    end
end

function Tween:Set(position,duration)
    local lowercase = {}
    if type(position) ~= 'table' then
        debugPrint('ERROR : Position must be a table.')
        return
    elseif isKeyinTbl(position) then
        for i,v in pairs(position) do
            lowercase[i:lower()] = v
        end
    end
    if not isKeyinTbl(position) then self.position = position[1] end
    self.pos = isKeyinTbl(position) and lowercase or position
    -- POSITIONS: x , y , scalex , scaley , width , height , angle , alpha
    self.duration = duration or self.duration
end

function Tween:SetOptions(options)
    local lowercase = {}
    if type(options) ~= 'table' then
        debugPrint('WARNING : Options is not a table! Making it a default rn..')
        self.options = {easedirection = 'linear'}
    else
        for i,v in pairs(options) do
            lowercase[i:lower()] = v
        end
        self.options = lowercase
    end
end

return Tween