luaDebugMode = true
function onCreate()
    makeLuaSprite('backDark', 'week1/erect/backDark', 729, -170)
    addLuaSprite('backDark')

    makeLuaSprite('brightLightSmall', 'week1/erect/brightLightSmall', 967, -103)
    setScrollFactor('brightLightSmall', 1.2, 1.2)
    addLuaSprite('brightLightSmall')

    makeAnimatedLuaSprite('crowd', 'week1/erect/crowd', 560, 290)
    addAnimationByPrefix('crowd', 'idle', 'Symbol 2 instance 1', 12, true)
    setScrollFactor('crowd', 0.8, 0.8)
    addLuaSprite('crowd')

    makeLuaSprite('bg', 'week1/erect/bg', -603, -187)
    addLuaSprite('bg')

    makeLuaSprite('server', 'week1/erect/server', -361, 205)
    addLuaSprite('server')

    makeLuaSprite('lights', 'week1/erect/lights', -601, -147)
    setScrollFactor('lights', 1.2, 1.2)
    addLuaSprite('lights', true)

    makeLuaSprite('orangeLight', 'week1/erect/orangeLight', 189, -195)
    addLuaSprite('orangeLight')

    makeLuaSprite('lightgreen', 'week1/erect/lightgreen', -171, 242)
    addLuaSprite('lightgreen')

    makeLuaSprite('lightred', 'week1/erect/lightred', -101, 560)
    addLuaSprite('lightred')

    makeLuaSprite('lightAbove', 'week1/erect/lightAbove', 804, -117)
    addLuaSprite('lightAbove', true)

    newABot(240, 475)
end

function onCreatePost()
    initLuaShader('adjustColor')

    setSpriteShader('boyfriend', 'adjustColor')
    setSpriteShader('gf', 'adjustColor')
    setSpriteShader('dad', 'adjustColor')

    setShaderFloat('boyfriend', 'brightness', -23)
    setShaderFloat('boyfriend', 'hue', 12)
    setShaderFloat('boyfriend', 'contrast', 7)
    setShaderFloat('boyfriend', 'saturation', 0)

    setShaderFloat('gf', 'brightness', -30)
    setShaderFloat('gf', 'hue', -9)
    setShaderFloat('gf', 'contrast', -4)
    setShaderFloat('gf', 'saturation', 0)

    setShaderFloat('dad', 'brightness', -33)
    setShaderFloat('dad', 'hue', -32)
    setShaderFloat('dad', 'contrast', -23)
    setShaderFloat('dad', 'saturation', 0)

    runHaxeCode([[
	game.getLuaObject('brightLightSmall').blend = 0;
	game.getLuaObject('orangeLight').blend = 0;
	game.getLuaObject('lightgreen').blend = 0;
	game.getLuaObject('lightred').blend = 0;
	game.getLuaObject('lightAbove').blend = 0;
    ]])
end

local VIZ_POS_X = {0, 59, 56, 66, 54, 52, 51}
local VIZ_POS_Y = {0, -8, -3.5, -0.4, 0.5, 4.7, 7}

function newABot(x, y)
    makeLuaSprite('abotbg', 'characters/abot/stereoBG', 90 + x, 20 + y)
    addLuaSprite('abotbg')

    local vizX = 0
    local vizY = 0
    for i = 1, 7 do
	vizX = vizX + VIZ_POS_X[i]
	vizY = vizY + VIZ_POS_Y[i]
	makeAnimatedLuaSprite('viz'..i, 'characters/abot/aBotViz', vizX + 140 + x, vizY + 74 + y)
	addAnimationByPrefix('viz'..i, 'VIZ', 'viz'..i, 24, false)
	playAnim('viz'..i, 'VIZ', true)
	updateHitbox('viz'..i)
	runHaxeCode("game.getLuaObject('viz"..i.."').centerOffsets();")
	addLuaSprite('viz'..i)
    end

    makeLuaSprite('eyeBg', nil, -30 + x, 215 + y)
    makeGraphic('eyeBg', 1, 1, 'FFFFFF')
    scaleObject('eyeBg', 160, 60)
    addLuaSprite('eyeBg')

    makeFlxAnimateSprite('eyes', -10 + x, 230 + y, 'characters/abot/systemEyes')
    addAnimationBySymbolIndices('eyes', 'lookleft', 'a bot eyes lookin', {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17}, 24, false)
    addAnimationBySymbolIndices('eyes', 'lookright', 'a bot eyes lookin', {18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35}, 24, false)
    playAnim('eyes', 'lookright', true)
    addLuaSprite('eyes')

    makeFlxAnimateSprite('speaker', -65 + x, -10 + y, 'characters/abot/abotSystem')
    addAnimationBySymbol('speaker', 'anim', 'Abot System', 24, false)
    playAnim('speaker', 'anim', true)
    addLuaSprite('speaker')
end

function onUpdate() for i = 1,7 do setProperty('viz'..i..'.animation.curAnim.curFrame', 5)end end

function onBeatHit()
    playAnim('speaker', 'anim')

    -- doing this like that for now, changing to event later
    if songName:lower() == 'bopeebo (pico mix)' then
	if curBeat >= 32 and curBeat <= 64 or curBeat >= 96 and curBeat <= 108 or curBeat >= 112 and curBeat <= 132 then
	    setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.03 * 0.6)
	elseif curBeat >= 68 and curBeat <= 96 then
	    setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.03 * 0.7)
	elseif curBeat >= 108 and curBeat <= 112 then
	    setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.03 * 0.4)
	end
    end
end

function onMoveCamera(target)
    --playAnim('eyes', target == 'dad' and 'lookleft' or 'lookright')
end