local holdColors = {'Purple', 'Blue', 'Green', 'Red'}

--luaDebugMode = true
function onCreate()
    prevGhostTap = getPropertyFromClass('backend.ClientPrefs', 'data.ghostTapping')
    setPropertyFromClass('backend.ClientPrefs', 'data.ghostTapping', false)
end

function onCreatePost()
    for i = 0,7 do
        setPropertyFromGroup('strumLineNotes', i, 'x', getPropertyFromGroup('strumLineNotes', i, 'x')-35)
    end
    setProperty('timeBar.visible', false)
    setProperty('timeBar.bg.visible', false)
    setProperty('timeTxt.visible', false)
    setProperty('scoreTxt.visible', false)

    setProperty('botplayTxt.y', getProperty('healthBar.y') + (downscroll and 70 or -120))

    callMethod('healthBar.setColors', {0xFF0000, 0x00FF00})

    makeLuaText('newScore', 'Score: 0', getProperty('newScore.width'), getProperty('scoreTxt.x')+750, getProperty('scoreTxt.y')-10)
    setTextSize('newScore', 16)
    setObjectCamera('newScore', 'hud')
    addLuaText('newScore')

    for i = 1, #holdColors do
        makeAnimatedLuaSprite('glow'..holdColors[i], 'holdCover'..holdColors[i])
        addAnimationByPrefix('glow'..holdColors[i], 'holdStart'..holdColors[i], 'holdCoverStart'..holdColors[i], 24, false)
        addAnimationByPrefix('glow'..holdColors[i], 'hold'..holdColors[i], 'holdCover'..holdColors[i], 24, false)
        addAnimationByPrefix('glow'..holdColors[i], 'holdEnd'..holdColors[i], 'holdCoverEnd'..holdColors[i], 24, false)
        addLuaSprite('glow'..holdColors[i], true)
        setObjectCamera('glow'..holdColors[i], 'camHUD')
        setProperty('glow'..holdColors[i]..'.alpha', 0.001)

        makeAnimatedLuaSprite('opGlow'..holdColors[i], 'holdCover'..holdColors[i])
        addAnimationByPrefix('opGlow'..holdColors[i], 'hold'..holdColors[i], 'holdCover'..holdColors[i], 24, false)
        addLuaSprite('opGlow'..holdColors[i], true)
        setObjectCamera('opGlow'..holdColors[i], 'camHUD')
        setProperty('opGlow'..holdColors[i]..'.alpha', 0.001)
    end
end

-- i hate my life
if curStage == 'phillyTrainErect' then
function onCountdownTick(t)
    if t == 0 then
	onCreatePost()
	for _, i in pairs({'healthBar', 'healthBar.bg', 'iconP1', 'iconP2'}) do setProperty(i..'.visible', true)end
    end
end
end

function onUpdatePost()
    setTextString('newScore', 'Score: '..score)

    for i = 1, #holdColors do
        if getProperty('glow'..holdColors[i]..'.animation.curAnim.finished') then
            setProperty('glow'..holdColors[i]..'.alpha', 0.001)
        end

        if getProperty('opGlow'..holdColors[i]..'.animation.curAnim.finished') then
            setProperty('opGlow'..holdColors[i]..'.alpha', .001) end

	if getVar('playerShoots') and getVar('explode') then -- this is for the pico dead shit
	    setProperty('opGlow'..holdColors[i]..'.visible', false)end
    end
end

local prevCombo = 0
function goodNoteHit(i, d, t, s)
    if s then
	setProperty('boyfriend.holdTimer', 0)

        local noteOffsets = {
            x = getPropertyFromGroup('playerStrums', d, 'x'),
            y = getPropertyFromGroup('playerStrums', d, 'y')
        }

        --easy asf yea?
        setProperty('glow'..holdColors[d+1]..'.alpha', getPropertyFromGroup('playerStrums', d, 'alpha'))

        setProperty('glow'..holdColors[d+1]..'.x', noteOffsets.x-110)
        setProperty('glow'..holdColors[d+1]..'.y', noteOffsets.y-93)

        if string.find(getPropertyFromGroup('notes', i, 'animation.curAnim.name'):lower(), 'end') and s then
            playAnim('glow'..holdColors[d+1], 'holdEnd'..holdColors[d+1])
        else
            playAnim('glow'..holdColors[d+1], 'hold'..holdColors[d+1], true)
        end
    end

    if stringStartsWith(gfName, 'nene') then
	if combo == 50 then playAnim('gf', 'combo50', true) setProperty('gf.specialAnim', true)end
	if combo == 200 then playAnim('gf', 'combo100', true) setProperty('gf.specialAnim', true)end
    end
    prevCombo = combo
end

function opponentNoteHit(i,d,t,s)
    if s then
        local noteOffsets = {
            x = getPropertyFromGroup('opponentStrums', d, 'x'),
            y = getPropertyFromGroup('opponentStrums', d, 'y')
        }

        setProperty('opGlow'..holdColors[d+1]..'.alpha', getPropertyFromGroup('opponentStrums', d, 'alpha'))
        playAnim('opGlow'..holdColors[d+1], 'hold'..holdColors[d+1], true)

        setProperty('opGlow'..holdColors[d+1]..'.x', noteOffsets.x-110)
        setProperty('opGlow'..holdColors[d+1]..'.y', noteOffsets.y-93)
    end
end

function noteMiss()
    if prevCombo >= 70 and stringStartsWith(gfName, 'nene') then
	playAnim('gf', 'drop70')
	setProperty('gf.specialAnim', true)
    end
    prevCombo = 0
end

function onDestroy()
    setPropertyFromClass('backend.ClientPrefs', 'data.ghostTapping', prevGhostTap)
end