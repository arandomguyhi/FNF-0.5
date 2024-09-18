luaDebugMode = true

function onEvent(name, value1, value2)
    if name == 'Scroll Speed' then
	local splitV1 = stringSplit(value1, ',')

	-- i'll make this better if theres another ocasion
	startTween('changeSpeed', 'this', {songSpeed = tonumber(splitV1[1])}, ((stepCrochet/1000) * tonumber(splitV1[2])), {ease = tostring(splitV1[3])})
    end
end