local path = 'week3/philly/erect/'
local LIGHT_COUNT = 4

luaDebugMode = true
function onCreate()
    initLuaShader('adjustColor')

    makeLuaSprite('sky', path..'sky', -100)
    setScrollFactor('sky', 0.1, 0.1)
    addLuaSprite('sky')

    makeLuaSprite('city', path..'city', -10)
    scaleObject('city', 0.85, 0.85)
    setScrollFactor('city', 0.3, 0.3)
    addLuaSprite('city')

    for i = 0, 4 do
	makeLuaSprite('lights'..i, path..'win'..i, -10)
	scaleObject('lights'..i, 0.85, 0.85)
	setScrollFactor('lights'..i, 0.3, 0.3)
	addLuaSprite('lights'..i)
	setProperty('lights'..i..'.visible', false)
    end

    makeLuaSprite('behindTrain', path..'behindTrain', -40, 50)
    addLuaSprite('behindTrain')

    makeLuaSprite('train', 'week3/philly/train', 2000, 360)
    addLuaSprite('train')

    makeLuaSprite('street', path..'street', -40, 50)
    addLuaSprite('street')

    newABot(490, 430)
end

local trainMoving = false
local trainFrameTiming = 0
local trainCars = 8
local trainFinishing = false
local trainCooldown = 0

setVar('hueValue', 1) -- -26
setVar('saturationValue', 1) -- -16
setVar('contrastValue', 1)
setVar('brightnessValue', 1) -- -5
 
function onUpdate(elapsed)
    for i = 1,7 do
	setProperty('viz'..i..'.animation.curAnim.curFrame', 5)end

    setSpriteShader('boyfriend', 'adjustColor')
    setSpriteShader('gf', 'adjustColor')
    setSpriteShader('dad', 'adjustColor')

    for _, colorShader in pairs({'boyfriend', 'gf', 'dad'}) do
	setShaderFloat(colorShader, 'hue', getVar('hueValue'))
	setShaderFloat(colorShader, getVar('saturationValue'))
	setShaderFloat(colorShader, 'contrast', getVar('contrastValue'))
	setShaderFloat(colorShader, 'brightness', getVar('brightnessValue'))
    end

    local amount = 1
    if trainMoving then
	trainFrameTiming = trainFrameTiming + elapsed

	if trainFrameTiming >= 1 / 24 then
	    updateTrainPos()
	    trainFrameTiming = 0
	end
    end
end

function onBeatHit()
    playAnim('speaker', 'anim')

    if not trainMoving then
	trainCooldown = trainCooldown + 1 end

    if curBeat % 8 == 4 and getRandomBool(30) and not trainMoving and trainCooldown > 8 then
	trainCooldown = getRandomInt(-4, 0)
	trainStart()
    end

    if curBeat % 4 == 0 then
	curLight = getRandomInt(1, LIGHT_COUNT - 1)
	for i = 0, LIGHT_COUNT do
	    setProperty('lights'..i..'.visible', (i == curLight))
	    --setVar('shaderInput', 1)

	    setProperty('lights'..i..'.alpha', 1)
	    doTweenAlpha('light'..i, 'lights'..i, 0.001, stepCrochet / 1000 * 12, 'linear')
	end
    end
end

function trainStart()
    trainMoving = true
    playSound('week3/train_passes', 1, 'trainSound')
end

local startedMoving = false
function updateTrainPos()
    if getSoundTime('trainSound') >= 4700 then
	startedMoving = true
	playAnim('gf', 'hairBlow', true)
	setProperty('gf.specialAnim', true)
    end

    if startedMoving then
	setProperty('train.x', getProperty('train.x') - 400)

	if getProperty('train.x') < -2000 and not trainFinishing then
	    setProperty('train.x', -1150)
	    trainCars = trainCars - 1

	    if trainCars <= 0 then
		trainFinishing = true
	    end
	end

	if getProperty('train.x') < -4000 and trainFinishing then
	    trainReset()
	end
    end
end

function trainReset()
    playAnim('gf', 'hairFall', true)
    setProperty('gf.specialAnim', true)
    setProperty('train.x', screenWidth + 200)

    trainMoving = false
    trainCars = 8
    trainFinishing = false
    startedMoving = false
end

function onCountdownTick(t)
    if t == 0 then
	runHaxeCode([[
	    FlxTween.num(getVar('hueValue'), -26, 1, {onUpdate: function(val) { setVar('hueValue', val); }}, function(value) {
		setVar('hueValue', value);
	    });
	    FlxTween.num(getVar('saturationValue'), -16, 1, {onUpdate: function(val) { setVar('saturationValue', val); }}, function(value) {
		setVar('saturationValue', value);
	    });
	    FlxTween.num(getVar('contrastValue'), 0, 1, {onUpdate: function(val) { setVar('contrastnValue', val); }}, function(value) {
		setVar('contrastValue', value);
	    });
	    FlxTween.num(getVar('brightnessValue'), -5, 1, {onUpdate: function(val) { setVar('brightnessValue', val); }}, function(value) {
		setVar('brightnessValue', value);
	    });
    	]])
    end
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