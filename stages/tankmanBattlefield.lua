addHaxeLibrary('FlxAngle', 'flixel.math')

luaDebugMode = true
function onCreate()
    makeLuaSprite('solid', nil, -500, -1000)
    makeGraphic('solid', 1, 1, 'E3A26D')
    scaleObject('solid', 2400, 2000)
    setScrollFactor('solid', 0, 0)
    addLuaSprite('solid')

    makeLuaSprite('tankSky', 'week7/tankSky', -400, -400)
    setScrollFactor('tankSky', 0, 0)
    addLuaSprite('tankSky')

    makeLuaSprite('tankMountains', 'week7/tankMountains', -280, -20)
    scaleObject('tankMountains', 1.2, 1.2)
    setScrollFactor('tankMountains', 0.2, 0.2)
    addLuaSprite('tankMountains')

    makeLuaSprite('clouds', 'week7/tankClouds')
    setScrollFactor('clouds', 0.4, 0.4)
    addLuaSprite('clouds')

    makeLuaSprite('tankBuildings', 'week7/tankBuildings', -180, 0)
    scaleObject('tankBuildings', 1.1, 1.1)
    setScrollFactor('tankBuildings', 0.3, 0.3)
    addLuaSprite('tankBuildings')

    makeLuaSprite('tankRuins', 'week7/tankRuins', -180, 0)
    scaleObject('tankRuins', 1.1, 1.1)
    setScrollFactor('tankRuins', 0.35, 0.35)
    addLuaSprite('tankRuins')

    makeAnimatedLuaSprite('smokeLeft', 'week7/smokeLeft', -200)
    addAnimationByPrefix('smokeLeft', 'smokeLeft', 'SmokeBlurLeft', 24, true)
    playAnim('smokeLeft', 'smokeLeft')
    setScrollFactor('smokeLeft', 0.4, 0.4)
    addLuaSprite('smokeLeft')

    makeAnimatedLuaSprite('smokeRight', 'week7/smokeRight', 1100, -100)
    addAnimationByPrefix('smokeRight', 'smokeRight', 'SmokeRight', 24, true)
    playAnim('smokeRight', 'smokeRight')
    setScrollFactor('smokeRight', 0.4, 0.4)
    addLuaSprite('smokeRight')

    makeAnimatedLuaSprite('watchtower', 'week7/tankWatchtower', 100, 50)
    addAnimationByPrefix('watchtower', 'idle', 'watchtower gradient color', 24, false)
    setScrollFactor('watchtower', 0.5, 0.5)
    addLuaSprite('watchtower')

    makeAnimatedLuaSprite('tankRolling', 'week7/tankRolling', 300, 300)
    addAnimationByPrefix('tankRolling', 'roll', 'BG tank w lighting', 24, true)
    playAnim('tankRolling', 'roll')
    setScrollFactor('tankRolling', 0.5, 0.5)
    addLuaSprite('tankRolling')

    makeLuaSprite('tankGround', 'week7/tankGround', -420, -150)
    scaleObject('tankGround', 1.15, 1.15)
    addLuaSprite('tankGround')

    makeAnimatedLuaSprite('tankmanAudience0', 'week7/tank0', -500, 650)
    addAnimationByPrefix('tankmanAudience0', 'idle', 'fg tankhead far right instance 1', 24, false)
    setScrollFactor('tankmanAudience0', 1.7, 1.5)
    addLuaSprite('tankmanAudience0', true)

    makeAnimatedLuaSprite('tankmanAudience2', 'week7/tank2', 360, 980)
    addAnimationByPrefix('tankmanAudience2', 'idle', 'foreground man 3 instance 1', 24, false)
    setScrollFactor('tankmanAudience2', 1.5, 1.5)
    addLuaSprite('tankmanAudience2', true)

    makeAnimatedLuaSprite('tankmanAudience5', 'week7/tank5', 1550, 700)
    addAnimationByPrefix('tankmanAudience5', 'idle', 'fg tankhead far right instance 1', 24, false)
    setScrollFactor('tankmanAudience5', 1.5, 1.5)
    addLuaSprite('tankmanAudience5', true)

    makeAnimatedLuaSprite('tankmanAudience4', 'week7/tank4', 1200, 900)
    addAnimationByPrefix('tankmanAudience4', 'idle', 'fg tankman bobbin 3 instance 1', 24, false)
    setScrollFactor('tankmanAudience4', 1.5, 1.5)
    addLuaSprite('tankmanAudience4', true)

    makeAnimatedLuaSprite('tankmanAudience3', 'week7/tank3', 1050, 1240)
    addAnimationByPrefix('tankmanAudience3', 'idle', 'fg tankhead 4 instance 1', 24, false)
    setScrollFactor('tankmanAudience3', 3.5, 2.5)
    addLuaSprite('tankmanAudience3', true)

    makeAnimatedLuaSprite('tankmanAudience1', 'week7/tank1', -300, 750)
    addAnimationByPrefix('tankmanAudience1', 'idle', 'fg tankhead 5 instance 1', 24, false)
    setScrollFactor('tankmanAudience1', 2.0, 0.2)
    addLuaSprite('tankmanAudience1', true)

    newABot(405, 365)
end

function onCreatePost()
    setProperty('clouds.active', true)
    setProperty('clouds.x', getRandomInt(-700, -100))
    setProperty('clouds.y', getRandomInt(-20, 20))
    setProperty('clouds.velocity.x', getRandomFloat(5, 15))
end

function onUpdatePost(el)
    for i = 1,7 do setProperty('viz'..i..'.animation.curAnim.curFrame', 5)end

    moveTank(el)
end

local tankMoving = false
local tankAngle = getRandomInt(-90, 45)
local tankSpeed = getRandomFloat(5, 7)
local tankX = 400

function onBeatHit()
    playAnim('speaker', 'anim')

    for _, boppers in pairs({'tankmanAudience0', 'tankmanAudience1', 'tankmanAudience2', 'tankmanAudience3', 'tankmanAudience4', 'tankmanAudience5', 'watchtower'}) do
	setProperty(boppers..'.animation.curAnim.curFrame', 0)
	playAnim(boppers, 'idle')
    end
end

function onCountdownTick(t)
    for _, boppers in pairs({'tankmanAudience0', 'tankmanAudience1', 'tankmanAudience2', 'tankmanAudience3', 'tankmanAudience4', 'tankmanAudience5', 'watchtower'}) do
	setProperty(boppers..'.animation.curAnim.curFrame', 0)
	playAnim(boppers, 'idle')
    end
end

function moveTank(elapsed)
    local daAngleOffset = 1
    tankAngle = tankAngle + elapsed * tankSpeed

    setProperty('tankRolling.angle', tankAngle - 90 + 15)
    setProperty('tankRolling.x', tankX + math.cos(asRadians((tankAngle * daAngleOffset) + 180)) * 1500)
    setProperty('tankRolling.y', 1300 + math.sin(asRadians((tankAngle * daAngleOffset) + 180)) * 1100)
end

function asRadians(radius)
    return runHaxeCode("FlxAngle.asRadians("..radius..");")
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