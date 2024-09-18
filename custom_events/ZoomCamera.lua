-- isso nao ta nem 10% pronto, nao ria :rage:
local DEFAULT_ZOOM = 1
local DEFAULT_DURATION = 1
local DEFAULT_MODE = 'direct'
local DEFAULT_EASE = 'linear'

luaDebugMode = true
function tweenCameraZoom(zoom, duration, direct, ease)
	local stageZoom = callMethodFromClass('backend.StageData', 'getStageFile', {curStage}).defaultZoom
	local targetZoom = zoom --* (direct and getProperty('defaultCamZoom') or stageZoom)

	if duration == 0 then
		setProperty('defaultCamZoom', targetZoom)
	else
		startTween('zoomEventTween', 'game', {defaultCamZoom = targetZoom}, (stepCrochet / 1000) * duration, {ease = tostring(ease)})
	end
end

function onEvent(n, v1, v2)
	if n == 'ZoomCamera' then
		local splitV1 = stringSplit(v1, ',')
		tweenCameraZoom(
			(splitV1[1] == nil and DEFAULT_ZOOM or splitV1[1]), --[[zoom]]
			(splitV1[2] == nil and DEFAULT_DURATION or splitV1[2] / 2), --[[duration]]
			false, --[[doesnt really metter, it'll later]]
			(splitV1[3] == nil and DEFAULT_EASE or splitV1[3])
		);
	end
end