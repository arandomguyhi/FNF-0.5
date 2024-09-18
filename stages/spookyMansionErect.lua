local lightningStrikeBeat = 0
local lightningStrikeOffset = 8

luaDebugMode = true
function onCreate()
    makeLuaSprite('solid', nil, -300, -500)
    makeGraphic('solid', 1, 1, '242336')
    scaleObject('solid', 2400, 2000)
    addLuaSprite('solid')

    makeAnimatedLuaSprite('bgTrees', 'week2/erect/bgtrees', 200, 50)
    addAnimationByPrefix('bgTrees', 'bgtrees', 'bgtrees', 5, true)
    playAnim('bgTrees', 'bgtrees')
    setScrollFactor('bgTrees', 0.8, 0.8)
    addLuaSprite('bgTrees')

    makeLuaSprite('bgDark', 'week2/erect/bgDark', -360, -220)
    addLuaSprite('bgDark')

    makeLuaSprite('bgLight', 'week2/erect/bgLight', -360, -220)
    addLuaSprite('bgLight')

    makeLuaSprite('stairsDark', 'week2/erect/stairsDark', 966, -225)
    addLuaSprite('stairsDark', true)

    makeLuaSprite('stairsLight', 'week2/erect/stairsLight', 966, -225)
    addLuaSprite('stairsLight', true)

    newABot(560, 435)
end

function onCreatePost()
    setProperty('bgLight.alpha', 0.001)
    setProperty('stairsLight.alpha', 0.001)

    createInstance('picoLight', 'objects.Character', {1025, 345, 'pico-playable', true})
    playAnim('picoLight', 'idle', true)
    addInstance('picoLight')

    createInstance('neneLight', 'objects.Character', {600, 112, 'nene'})
    addInstance('neneLight')

    createInstance('spookyLight', 'objects.Character', {150, 275, 'spooky'})
    addInstance('spookyLight')

    initLuaShader('adjustColor')

    for i = 1,7 do
	setSpriteShader('viz'..i, 'adjustColor')

	setShaderFloat('viz'..i, 'brightness', -12)
	setShaderFloat('viz'..i, 'hue', -26)
	setShaderFloat('viz'..i, 'contrast', 0)
	setShaderFloat('viz'..i, 'saturation', -45)
    end
    setSpriteShader('eyeBg', 'adjustColor')
    setShaderFloat('eyeBg', 'brightness', -12) setShaderFloat('eyeBg', 'hue', -26)
    setShaderFloat('eyeBg', 'contrast', 0) setShaderFloat('eyeBg', 'saturation', -45)
end

function onUpdatePost(elapsed)
    playAnim('picoLight', getProperty('boyfriend.animation.curAnim.name'), true)
    setProperty('picoLight.animation.curAnim.curFrame', getProperty('boyfriend.animation.curAnim.curFrame'))

    playAnim('neneLight', getProperty('gf.animation.curAnim.name'), true)
    setProperty('neneLight.animation.curAnim.curFrame', getProperty('gf.animation.curAnim.curFrame'))

    playAnim('spookyLight', getProperty('dad.animation.curAnim.name'), true)
    setProperty('spookyLight.animation.curAnim.curFrame', getProperty('dad.animation.curAnim.curFrame'))

    if getProperty('boyfriend.animation.curAnim.name') == 'burpShit' or getProperty('boyfriend.animation.curAnim.name') == 'burpSmile' then
	setProperty('picoLight.alpha', 0.001)
	if getProperty('boyfriend.animation.curAnim.finished') then setProperty('picoLight.alpha', 1) end
    end
end

function doLightningStrike(playsound, beat)
    if playsound then
	playSound('thunder_'..getRandomInt(1,2))
    end

    setProperty('bgLight.alpha', 1)
    setProperty('stairsLight.alpha', 1)
    setProperty('boyfriend.alpha', 0.001)
    setProperty('dad.alpha', 0.001)
    setProperty('gf.alpha', 0.001)

    setProperty('abotbglight.alpha', 1)
    for i = 1,7 do setProperty('vizlight'..i..'.alpha', 1) end
    setProperty('speakerlight.alpha', 1)

    runTimer('light1', 0.06)
    runTimer('light2', 0.12)

    lightningStrikeBeat = beat
    lightningStrikeOffset = getRandomInt(8, 24)
end

function onUpdate(elapsed)
    for i = 1,7 do
	setProperty('viz'..i..'.animation.curAnim.curFrame', 5)
    end
end

function onBeatHit()
    playAnim('speaker', 'anim', true) playAnim('speakerlight', 'idle', true)

    if curBeat == 4 and string.find(songName:lower(), 'spookeez') then
	doLightningStrike(false, curBeat)
    end

    if getRandomBool(10) and curBeat > (lightningStrikeBeat + lightningStrikeOffset) then
	doLightningStrike(true, curBeat)
    end
end

function onTimerCompleted(tag)
    if tag == 'light1' then
	setProperty('bgLight.alpha', 0.001)
	setProperty('stairsLight.alpha', 0.001)
	setProperty('boyfriend.alpha', 1)
	setProperty('dad.alpha', 1)
	setProperty('gf.alpha', 1)
    end

    if tag == 'light2' then
	setProperty('bgLight.alpha', 1)
	setProperty('stairsLight.alpha', 1)
	setProperty('boyfriend.alpha', 0.001)
	setProperty('dad.alpha', 0.001)
	setProperty('gf.alpha', 0.001)

	setProperty('abotbglight.alpha', 1)
	for i = 1,7 do setProperty('vizlight'..i..'.alpha', 1)end
	setProperty('speakerlight.alpha', 1)

	doTweenAlpha('lightbg', 'bgLight', 0.001, 1.5)
	doTweenAlpha('lightstair', 'stairsLight', 0.001, 1.5)
	doTweenAlpha('bfalpha', 'boyfriend', 1, 1.5)
	doTweenAlpha('dadalpha', 'dad', 1, 1.5)
	doTweenAlpha('gfalpha', 'gf', 1, 1.5)

	doTweenAlpha('light1', 'abotbglight', 0.001, 1.5)
	for i = 1,7 do doTweenAlpha('lightviz'..i, 'vizlight'..i, 0.001, 1.5)end
	doTweenAlpha('light3', 'speakerlight', 0.001, 1.5)
    end
end

local VIZ_POS_X = {0, 59, 56, 66, 54, 52, 51}
local VIZ_POS_Y = {0, -8, -3.5, -0.4, 0.5, 4.7, 7}

function newABot(x, y)
    makeLuaSprite('abotbg', 'characters/abot/stereoBG', 90 + x, 20 + y)
    addLuaSprite('abotbg')
    setProperty('abotbg.color', 0x616785)

    makeLuaSprite('abotbglight', 'characters/abot/stereoBG', 90 + x, 20 + y)
    addLuaSprite('abotbglight')

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

	makeAnimatedLuaSprite('vizlight'..i, 'characters/abot/aBotViz', vizX + 140 + x, vizY + 74 + y)
	addAnimationByPrefix('vizlight'..i, 'VIZ', 'viz'..i, 24, false)
	playAnim('vizlight'..i, 'VIZ', true)
	updateHitbox('vizlight'..i)
	runHaxeCode("game.getLuaObject('vizlight"..i.."').centerOffsets();")
	addLuaSprite('vizlight'..i)
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

    makeFlxAnimateSprite('speaker', -65 + x, -10 + y, 'characters/abot/dark/abotSystem')
    addAnimationBySymbol('speaker', 'anim', 'Abot System', 24, false)
    playAnim('speaker', 'anim', true)
    addLuaSprite('speaker')

    makeFlxAnimateSprite('speakerlight', -65 + x, -10 + y, 'characters/abot/abotSystem')
    addAnimationBySymbol('speakerlight', 'idle', 'Abot System', 24, false)
    playAnim('speakerlight', 'anim', true)
    addLuaSprite('speakerlight')

    setProperty('abotbglight.alpha', 0.001)
    for i = 1,7 do setProperty('vizlight'..i..'.alpha', 0.001)end
    setProperty('speakerlight.alpha', 0.001)
end