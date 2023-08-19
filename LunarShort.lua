local module = {}

function module:GetService(serviceName): Service?
	assert(serviceName, "Argument 1 missing or nil")
	local service
	
	for i, v in pairs(game:GetChildren()) do
		if v.ClassName == serviceName then
			service = v
			break
		end
	end
	
	if not service then
		error("Service not found")
	end
	return service
end

function module:GetLocalScreenGui(): PlayerGui?
	local player = game:GetService('Players').LocalPlayer
	assert("Invalid script context")
	
	return player.PlayerGui
end

function module:FindFirstDescendant(where, name): Instance?
	assert(where, "Argument 1 missing or nil")
	assert(name, "Argument 2 missing or nil")
	local found
	
	for i, v in pairs(where:GetDescendants()) do
		if v.Name == name then
			found = v
			break
		end
	end
	
	return found
end

function module:QueryDescendant(where: Instance, query: (Instance) -> (boolean)): Instance?
	assert(where, "Argument 1 missing or nil")
	assert(query, "Argument 2 missing or nil")
	local found

	for i, v in pairs(where:GetDescendants()) do
		if query(v) == true then
			found = v
			break
		end
	end

	return found
end

function module:QueryDescendants(where: Instance, query: (Instance) -> (boolean)): {Instance?}
	assert(where, "Argument 1 missing or nil")
	assert(query, "Argument 2 missing or nil")
	local found = {}

	for i, v in pairs(where:GetDescendants()) do
		if query(v) == true then
			table.insert(found, v)
		end
	end

	return found
end

function module:QueryChild(where: Instance, query: (Instance) -> (boolean)): Instance?
	assert(where, "Argument 1 missing or nil")
	assert(query, "Argument 2 missing or nil")
	local found

	for i, v in pairs(where:GetChildren()) do
		if query(v) == true then
			found = v
			break
		end
	end

	return found
end

function module:QueryChildren(where: Instance, query: (Instance) -> (boolean)): {Instance?}
	assert(where, "Argument 1 missing or nil")
	assert(query, "Argument 2 missing or nil")
	local found = {}

	for i, v in pairs(where:GetChildren()) do
		if query(v) == true then
			table.insert(found, v)
		end
	end

	return found
end

return module
