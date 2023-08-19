local module = {}

function module:GetService(serviceName)
	assert(serviceName, "Argument 1 missing or nil")
	local service
	
	for i, v in pairs(game:GetChildren()) do
		if v.ClassName == serviceName then
			service = v
		end
	end
	
	if not service then
		error("Service not found")
	end
	return service
end

function module:GetLocalScreenGui()
	local player = game:GetService('Players').LocalPlayer
	assert("Invalid script context")
	
	return player.PlayerGui
end

return module
