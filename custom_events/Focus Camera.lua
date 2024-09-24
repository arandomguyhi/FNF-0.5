-- I'M MAKING THIS MUCH BETTER LATER I PROMISE :SOB:
luaDebugMode = true

local tweenDuration = 0
function onEvent(name, value1, value2)
    if name == 'Focus Camera' then
	local splitV1 = stringSplit(value1, ',')
	local splitV2 = stringSplit(value2, ',')

	local bfCamX = getMidpointX('boyfriend') - 100 - getProperty('boyfriend.cameraPosition[0]') + getProperty('boyfriendCameraOffset[0]')
    	local bfCamY = getMidpointY('boyfriend') - 100 + getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]')
	local dadCamX = getMidpointX('dad') + 150 + getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]')
	local dadCamY = getMidpointY('dad') - 100 + getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]')
	local gfCamX = getMidpointX('gf')+getProperty('gf.cameraPosition[0]')+getProperty('girlfriendCameraOffset[0]')
	local gfCamY = getMidpointY('gf')+getProperty('gf.cameraPosition[1]')+getProperty('girlfriendCameraOffset[1]')

	if not string.find(value1, ',') then
	    if value1 == 'Opponent' then
		cancelTween('gfCamTween') cancelTween('dadCamTween')
		cameraSetTarget('dad')
	    elseif value1 == 'Player' then
		cancelTween('gfCamTween') cancelTween('dadCamTween')
		cameraSetTarget('boyfriend')
	    elseif value1 == 'Girlfriend' then
		setProperty('camFollow.x', gfCamX)
		setProperty('camFollow.y', gfCamY)
	    end
	else
	    if value2 ~= '' then tweenDuration = (stepCrochet/1000)*tonumber(splitV2[1]) end
	    if splitV1[1] == 'Opponent' then
		if value2 ~= '' then
		    startTween('dadCamTween', 'camFollow', {x = dadCamX + splitV1[2], y = dadCamY + splitV1[3]}, tweenDuration/2, {ease = tostring(splitV2[2])})
		else
		    if value2 ~= '' then return end
		    setProperty('camFollow.x', dadCamX + splitV1[2])
		    setProperty('camFollow.y', dadCamY + splitV1[3])
		end
	    elseif splitV1[1] == 'Player' then
		if value2 ~= '' then
		    startTween('bfCamTween', 'camFollow', {x = bfCamX + splitV1[2], y = bfCamY + splitV1[3]}, tweenDuration/2, {ease = tostring(splitV2[2])})
		else
		    if value2 ~= '' then return end
		    setProperty('camFollow.x', bfCamX + splitV1[2])
		    setProperty('camFollow.y', bfCamY + splitV1[3])
		end
	    elseif splitV1[1] == 'Girlfriend' then
		if value2 ~= '' then
		    startTween('gfCamTween', 'camFollow', {x = gfCamX + splitV1[2], y = gfCamY + splitV1[3]}, tweenDuration/2, {ease = tostring(splitV2[2])})
		else
		    if value2 ~= '' then return end
		    setProperty('camFollow.x', gfCamX + splitV1[2])
		    setProperty('camFollow.y', gfCamY + splitV1[3])
		end
	    end
	end

	-- for abot eyes
	if string.find(value1, 'Opponent') then
	--    if getProperty('eyes.anim.curFrame') <= 17 then
		playAnim('eyes', 'lookleft') -- else return
	--    end
	else
	--    if getProperty('eyes.anim.curFrame') >= 17 then
		playAnim('eyes', 'lookright') -- else return
	--    end
	end
    end
end

function onUpdate()
    setProperty('isCameraOnForcedPos', true)
end