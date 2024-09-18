luaDebugMode = true

function onEvent(name, value1, value2)
    if name == 'Focus Camera' then
	local splitV1 = stringSplit(value1, ',')

	local dadCamX = getMidpointX('dad') + 150 + getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]')
	local dadCamY = getMidpointY('dad') - 100 + getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]')

	if not string.find(value1, ',') then
	    if value1 == 'Opponent' then
		cameraSetTarget('dad')
		--[[if luaSpriteExists('eyes') then]] playAnim('eyes', 'lookleft') --end
	    elseif value1 == 'Player' then
		cameraSetTarget('boyfriend')
		--[[if luaSpriteExists('eyes') then]] playAnim('eyes', 'lookright') --end
	    elseif value1 == 'Girlfriend' then
		setProperty('camFollow.x', getMidpointX('gf')+getProperty('gf.cameraPosition[0]')+getProperty('girlfriendCameraOffset[0]'))
		setProperty('camFollow.y', getMidpointY('gf')+getProperty('gf.cameraPosition[1]')+getProperty('girlfriendCameraOffset[1]'))
	    end
	else
	    if splitV1[1] == 'Opponent' then
		setProperty('camFollow.x', dadCamX + splitV1[2])
		setProperty('camFollow.y', dadCamY + splitV1[3])
	    end
	end
    end
end

function onUpdate()
    setProperty('isCameraOnForcedPos', true)
end