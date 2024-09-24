local customPropertyBehaviour = {
	["Parent"] = function (obj, value, meta)
		if typeof(value) == 'number' or typeof(value) == 'string' then
			obj.Parent = meta.DoneTree[value]
		else
			obj.Parent = value
		end
	end
}

local defaultClassPropertyValues = {}

local function parseProperties(newObject, doneTree, properties)
	for property, value in pairs(properties) do
		local behaviour = customPropertyBehaviour[property]

		if behaviour then
			behaviour(newObject, value, {
				["DoneTree"] = doneTree
			})
		else
			newObject[property] = value
		end
	end
end


-- Module

local module = {}

function module:ResetDefaultPropertyValues(className)
	defaultClassPropertyValues[className] = nil
end

function module:SetDefaultPropertyValue(className: string, property: string, value: any)
	local defaults = defaultClassPropertyValues[className]
	
	if not defaults then
		defaultClassPropertyValues[className] = {
			[property] = value
		}
	else
		-- roblox dumb idiot noob
		-- no key-value table inset gr
		
		local newTable = {}
		for i, v in pairs(defaults) do
			newTable[i] = v
		end
		
		newTable[property] = value
		defaultClassPropertyValues[className] = newTable
	end
end

function module:Create(tree: {}): {Instance}
	local doneTree = {}
	
	for objectId, object in pairs(tree) do
		local class = object[1]
		local properties = object[2]
		
		local newObject = Instance.new(class)
		table.insert(doneTree, newObject)
		
		local defaults = defaultClassPropertyValues[class]
		if defaults then
			parseProperties(newObject, doneTree, defaults)
		end

		parseProperties(newObject, doneTree, properties)
	end
	
	return doneTree
end

return module
