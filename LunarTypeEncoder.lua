--[[

string
boolean
number
UDim
UDim2
BrickColor
Color3
Vector2
Vector3
CFrame
NumberSequence
ColorSequence
NumberRange
Rect
Font

nil

]]

local luaEncode = {}

luaEncode = {
	["string"] = function (value: string)
		return "\"".. value:gsub("\"", "\\\"").. "\""
	end,
	
	["boolean"] = function (value: boolean)
		if value then
			return "true"
		else
			return "false"
		end
	end,
	
	["number"] = function (value: number)
		return tostring(value)
	end,
	
	["UDim"] = function (value: UDim)
		return "UDim.new(".. tostring(value.Scale).. ", ".. tostring(value.Offset).. ")"
	end,
	
	["UDim2"] = function (value: UDim2)
		if value.X.Scale == 0 and value.Y.Scale == 0 then
			return "UDim2.fromOffset("..tostring(value.X.Offset)..", "..tostring(value.Y.Offset)..")"
		elseif value.X.Offset == 0 and value.Y.Offset == 0 then
			return "UDim2.fromScale("..tostring(value.X.Scale)..", "..tostring(value.Y.Scale)..")"
		else
			return "UDim2.new("..tostring(value.X.Scale)..", "..tostring(value.X.Offset)..", "..tostring(value.Y.Scale)..", "..tostring(value.Y.Offset)..", "..")"
		end
	end,
	
	["BrickColor"] = function (value: BrickColor)
		return "BrickColor.new(".. value.Name.. ")"
	end,
	
	["Color3"] = function (value: Color3)
		return "Color3.new(".. value.R.. ", ".. value.G.. ", ".. value.B.. ")"
	end,
	
	["Vector2"] = function (value: Vector2)
		if value.X == 0 and value.Y == 0 then
			return "Vector2.zero"
		elseif value.X == 1 and value.Y == 1 then
			return "Vector2.one"
		elseif value.X == 1 and value.Y == 0 then
			return "Vector2.xAxis"
		elseif value.X == 0 and value.Y == 1 then
			return "Vector2.yAxis"
		else
			return "Vector2.new(".. tostring(value.X).. ", ".. tostring(value.Y).. ")"
		end
	end,

	["Vector3"] = function (value: Vector3)
		if value.X == 0 and value.Y == 0 and value.Z == 0 then
			return "Vector3.zero"
		elseif value.X == 1 and value.Y == 1 and value.Z == 1 then
			return "Vector3.one"
		elseif value.X == 1 and value.Y == 0 and value.Z == 0 then
			return "Vector3.xAxis"
		elseif value.X == 0 and value.Y == 1 and value.Z == 0 then
			return "Vector3.yAxis"
		elseif value.X == 0 and value.Y == 0 and value.Z == 1 then
			return "Vector3.zAxis"
		else
			return "Vector32.new(".. tostring(value.X).. ", ".. tostring(value.Y).. ", ".. tostring(value.Z).. ")"
		end
	end,

	["CFrame"] = function (value: CFrame)
		-- ????
		return "CFrame.new(".. tostring(value).. ")"
	end,
	
	["NumberSequenceKeypoint"] = function (value: NumberSequenceKeypoint)
		if value.Envelope == 0 then
			return "NumberSequenceKeypoint.new(".. tostring(value.Value).. ", ".. tostring(value.Time).. ")"
		else
			return "NumberSequenceKeypoint.new(".. tostring(value.Value).. ", ".. tostring(value.Time).. ", ".. tostring(value.Envelope).. ")"
		end
	end,
	
	["NumberSequence"] = function (value: NumberSequence)
		if value.Keypoints[2].Time == 1 and value.Keypoints[1].Envelope == 0 and value.Keypoints[2].Envelope == 0 and #value.Keypoints==2 then
			if value.Keypoints[1].Value == value.Keypoints[2].Value then
				return "NumberSequence.new(".. tostring(value.Keypoints[1].Value) ..")"
			else
				return "NumberSequence.new(".. tostring(value.Keypoints[1].Value).. ", ".. tostring(value.Keypoints[2].Value)..")"
			end
		else
			local l = {}
			for i, v in pairs(value.Keypoints) do
				table.insert(l, luaEncode["NumberSequenceKeypoint"](v))
			end
			
			return "NumberSequence.new({".. table.concat(l, ", ").. "})"
		end
	end,
	
	["ColorSequenceKeypoint"] = function (value: ColorSequenceKeypoint)
		return "ColorSequenceKeypoint.new(".. luaEncode["Color3"](value.Value).. ", ".. tostring(value.Time)..")"
	end,
	
	["ColorSequence"] = function (value: ColorSequence)
		if value.Keypoints[1].Value == value.Keypoints[2].Value and #value.Keypoints == 2 then
			return "ColorSequence.new(".. luaEncode["Color3"](value.Keypoints[1].Value).. ")"
		elseif #value.Keypoints == 2 then
			return "ColorSequence.new(".. luaEncode["Color3"](value.Keypoints[1].Value).. ", ".. luaEncode["Color3"](value.Keypoints[2].Value).. ")"
		else
			local l = {}
			for i, v in pairs(value.Keypoints) do
				table.insert(l, luaEncode["ColorSequenceKeypoint"](v))
			end

			return "ColorSequence.new({".. table.concat(l, ", ").. "})"
		end
	end,
	
	["NumberRange"] = function (value: NumberRange)
		return "NumberRange.new(".. tostring(value.Min).. ", ".. tostring(value.Max).. ")"
	end,
	
	["Rect"] = function (value: Rect)
		return "Rect.new(".. value.Min.X.. ",".. value.Min.Y.. ",".. value.Max.X.. ",".. value.Max.Y.. ")"
	end,
	
	["Font"] = function (value: Font)
		return "Font.new(".. value.Family.. ", Enum.FontWeight.".. value.Weight.Name.. ", Enum.FontStyle.".. value.Style.. ")"
	end,
	
	["nil"] = function (value: nil)
		return "nil"
	end,

	["Instance"] = function (value: Instance)
		local path = value:GetFullName()
		local fullpath = "game."

		for i, v in pairs(path:split(".")) do
			if ({v:find(" ")})[1] or ({v:find(".")})[1] or ({v:find("[!@#$^&*()-=,/?;'\"\\]")})[1] then
				fullpath += "[".. luaEncode["string"](v).. "]"
			else
				fullpath += "."..v
			end
		end

		return fullpath
	end,
}

local stringEncode = {}
stringEncode = {
	["UDim2"] = function (value: UDim2)
		return "{".. tostring(value.X.Scale).. ", ".. tostring(value.X.Offset).. "}, {".. tostring(value.Y.Scale).. ", " ..tostring(value.Y.Offset).. "}" 
	end,
	
	["Instance"] = function (value: Instance)
		return value:GetFullName()
	end,
}



local module = {}

function module:toLua(value)
	local encodeFunction = luaEncode[typeof(value)]
	assert(encodeFunction, "Unencodable data type")
	
	return encodeFunction(value)
end

function module:toString(value)
	local encodeFunction = stringEncode[typeof(value)]
	
	if encodeFunction then
		return encodeFunction(value)
	else
		return tostring(value)
	end
end

return module
