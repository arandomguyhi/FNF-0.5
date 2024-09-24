local path = 'week5/christmas/erect/'

luaDebugMode = true
function onCreate()
    makeLuaSprite('bgWalls', path..'bgWalls', -1000, -440)
    scaleObject('bgWalls', 0.9, 0.9)
    setScrollFactor('bgWalls', 0.2, 0.2)
    addLuaSprite('bgWalls')

    makeAnimatedLuaSprite('upperBoppers', path..'upperBop', -240, -40)
    addAnimationByPrefix('upperBoppers', 'idle', 'upperBop', 24, false)
    scaleObject('upperBoppers', 0.85, 0.85)
    setScrollFactor('upperBoppers', 0.33, 0.33)
    addLuaSprite('upperBoppers')

    makeLuaSprite('bgEscalator', path..'bgEscalator', -1100, -540)
    scaleObject('bgEscalator', 0.9, 0.9)
    setScrollFactor('bgEscalator', 0.3, 0.3)
    addLuaSprite('bgEscalator')

    makeLuaSprite('christmasTree', path..'christmasTree', 370, -250)
    setScrollFactor('christmasTree', 0.4, 0.4)
    addLuaSprite('christmasTree')

    makeLuaSprite('fog', path..'white', -1000, 100)
    scaleObject('fog', 0.9, 0.9)
    setScrollFactor('fog', 0.85, 0.85)
    addLuaSprite('fog')

    makeAnimatedLuaSprite('bottomBoppers', path..'bottomBop', -410, 100)
    addAnimationByPrefix('bottomBoppers', 'idle', 'bottomBop', 24, false)
    setScrollFactor('bottomBoppers', 0.9, 0.9)
    addLuaSprite('bottomBoppers')

    makeLuaSprite('snowUnder', nil, -1200, 800)
    makeGraphic('snowUnder', 1, 1, 'F3F4F5')
    scaleObject('snowUnder', 5400, 3000)
    addLuaSprite('snowUnder')

    makeLuaSprite('fgSnow', 'week5/christmas/fgSnow', -1150, 680)
    addLuaSprite('fgSnow')

    makeAnimatedLuaSprite('santa', 'week5/christmas/santa', -840, 150)
    addAnimationByPrefix('santa', 'idle', 'santa idle in fear', 24, false)
    addLuaSprite('santa', true)

    newABot(540, 505)
end

local bzl = 0
function onUpdatePost(el)
    for i = 1,7 do setProperty('viz'..i..'.animation.curAnim.curFrame', 5)end
end

function onBeatHit()
    for _, bops in pairs({'speaker', 'upperBoppers', 'bottomBoppers', 'santa'}) do
	setProperty(bops..'.animation.curAnim.curFrame', 0)
	playAnim(bops, 'idle')
    end
end

function onCountdownTick(t)
    for _, bops in pairs({'speaker', 'upperBoppers', 'bottomBoppers', 'santa'}) do
	setProperty(bops..'.animation.curAnim.curFrame', 0)
	playAnim(bops, 'idle')
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
    addAnimationBySymbol('speaker', 'idle', 'Abot System', 24, false)
    playAnim('speaker', 'anim', true)
    addLuaSprite('speaker')
end