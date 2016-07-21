-- $Id: DiesalTools-1.0.lua 52 2014-04-08 11:52:40Z diesal@reece-tech.com $
local MAJOR, MINOR = "DiesalTools-1.0", "$Rev: 52 $"
local DiesalTools, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not DiesalTools then return end -- No Upgrade needed.
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, select, pairs, tonumber, tostring		= type, select, pairs, tonumber, tostring
local table_concat															= table.concat
local setmetatable, getmetatable, next					= setmetatable, getmetatable, next
local sub, format, lower, upper,gsub						= string.sub, string.format, string.lower, string.upper, string.gsub 
local floor, ceil, abs, modf										= math.floor, math.ceil, math.abs, math.modf	
-- ~~| WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local CreateFrame, UIParent, GetCursorPosition 	= CreateFrame, UIParent, GetCursorPosition
local GetScreenWidth, GetScreenHeight						= GetScreenWidth, GetScreenHeight	
-- ~~| DiesalStyle Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local escapeSequences = {
		[ "\a" ] = "\\a", -- Bell
		[ "\b" ] = "\\b", -- Backspace
		[ "\t" ] = "\\t", -- Horizontal tab
		[ "\n" ] = "\\n", -- Newline
		[ "\v" ] = "\\v", -- Vertical tab
		[ "\f" ] = "\\f", -- Form feed
		[ "\r" ] = "\\r", -- Carriage return
		[ "\\" ] = "\\\\", -- Backslash
		[ "\"" ] = "\\\"", -- Quotation mark
		[ "|" ]  = "||",
}
local lua_keywords = { 
	["and"] = true,    ["break"] = true,  ["do"] = true,
	["else"] = true,   ["elseif"] = true, ["end"] = true,
	["false"] = true,  ["for"] = true,    ["function"] = true,
	["if"] = true,     ["in"] = true,     ["local"] = true,
	["nil"] = true,    ["not"] = true,    ["or"] = true,
	["repeat"] = true, ["return"] = true, ["then"] = true,
	["true"] = true,   ["until"] = true,  ["while"] = true
}
local sub_table = {
	
}	
-- ~~| DiesalStyle API |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--[[ copy = TableCopy(src, dest, metatable)
	@Arguments:
		dest				Table to copy to 
		src					Table to copy
		metatable		if true copies the metatable as well (boolean)						
	@Returns:	
		table				copy of table		
--]]
function DiesalTools:TableCopy(src,dest,metatable)	
  if type(src) == 'table' then
  	 if not dest then dest = {} end	       
      for sk, sv in next, src, nil do        	
        dest[self:TableCopy(sk)] = self:TableCopy(sv)
      end
      if metatable then setmetatable(dest, self:TableCopy(getmetatable(src))) end
  else -- number, string, boolean, etc
  	dest = src
  end
  return dest		
end
--[[ red, blue, green = GetColor(value)	
	@Arguments:
		value		Hex color code or a table contating R,G,B color values		
	@Returns:	
		red 		Red component of color 	(0-1) (number)	
		green 	Green component of color(0-1) (number)	
		blue 		Blue component of color (0-1) (number)	 	
-- ]]
function DiesalTools:GetColor(value)	
	if not value then return end	
		
	if type(value) =='table' then
		return value[1]/255, value[2]/255, value[3]/255		
	else
		local rhex, ghex, bhex = sub(value, 1, 2), sub(value, 3, 4), sub(value, 5, 6)
		return tonumber(rhex, 16)/255, tonumber(ghex, 16)/255, tonumber(bhex, 16)/255
	end	
end
--[[ GetTxtColor(value)	
	@Arguments:
		value			Hex color code or a table contating R,G,B color values		
	@Returns:	
		text coloring escape sequence (|cFFFFFFFF)		 	
-- ]]
function DiesalTools:GetTxtColor(value)
	if not value then return end	
		
	if type(value) =='table' then value = string.format("%02x%02x%02x", value[1], value[2], value[3]) end	
	return format('|cff%s',value)	
end
--[[ GetFrameQuadrant(frame) 	
	@Arguments:
		frame			frame?!!						
	@Returns:	
		quadrant   	quadrant of the screen frames center is in 
-- ]]
function DiesalTools:GetFrameQuadrant(frame)
	local x, y = frame:GetCenter()
	local screenWidth = GetScreenWidth()
	local screenHeight = GetScreenHeight()
	local quadrant
	
	if not frame:GetCenter() then
		return "UNKNOWN", frame:GetName()
	end
	
	if (x > (screenWidth / 4) and x < (screenWidth / 4)*3) and y > (screenHeight / 4)*3 then
		quadrant = "TOP"
	elseif x < (screenWidth / 4) and y > (screenHeight / 4)*3 then
		quadrant = "TOPLEFT"
	elseif x > (screenWidth / 4)*3 and y > (screenHeight / 4)*3 then
		quadrant = "TOPRIGHT"
	elseif (x > (screenWidth / 4) and x < (screenWidth / 4)*3) and y < (screenHeight / 4) then
		quadrant = "BOTTOM"
	elseif x < (screenWidth / 4) and y < (screenHeight / 4) then
		quadrant = "BOTTOMLEFT"
	elseif x > (screenWidth / 4)*3 and y < (screenHeight / 4) then
		quadrant = "BOTTOMRIGHT"
	elseif x < (screenWidth / 4) and (y > (screenHeight / 4) and y < (screenHeight / 4)*3) then
		quadrant = "LEFT"
	elseif x > (screenWidth / 4)*3 and y < (screenHeight / 4)*3 and y > (screenHeight / 4) then
		quadrant = "RIGHT"
	else
		quadrant = "CENTER"
	end

	return quadrant
end
--[[ Get a piece of a texture as a cooridnate refernce
-- @Param 	column			the column in the texture
-- @Param 	row				the row in the texture
-- @Param 	size				the size in the texture	
-- @Param 	textureWidth	total texture width
-- @Param 	textureHeight	total texture height
-- @Return	edge coordinates for image cropping, plugs directly into Texture:SetTexCoord(left, right, top, bottom)		]]	
function DiesalTools:GetIconCoords(column,row,size,textureWidth,textureHeight)
	size 					= size or 16
	textureWidth 	= textureWidth or 128
	textureHeight = textureHeight	or 16	
	return (column * size - size) / textureWidth, (column * size) / textureWidth, (row * size - size) / textureHeight, (row * size) / textureHeight
end
--[[ Round a number
-- @Param 	number 	the number to round
-- @Param 	base		the number to round to (can be a decimal)	[Default:1]							
-- @Return	the rounded number to base		]]			
function DiesalTools:Round(number, base)
    base = base or 1
    return floor((number + base/2)/base) * base
end
--[[ Capitalize a string 
--	@Param 	str	the string to capatilize					
--	@Return	the capitilized string			]]
function DiesalTools:Capitalize(str)
  return (str:gsub("^%l", upper))
end
--[[ Escape all formatting in a WoW-lua string 
-- @Param 	str	the string to escape					
-- @Return	the escaped string		]]
function DiesalTools:EscapeString(string)
	return string:gsub( "[%z\1-\31\"\\|\127-\255]", escapeSequences )	
end
--[[ ID = CreateID(s) 
-- @Param 	s 	string to parse			
-- @Return	ID	string stripped of all non letter characters and color codes.]]
function DiesalTools:CreateID(s)	
	return gsub(s:gsub('c%x%x%x%x%x%x%x%x', ''), '[^%a%d]', '')
end
--[[ str = TrimString(s) 
-- @Param 	s 		string to parse			
-- @Return	str	string stripped of leading and trailing spaces.]]
function DiesalTools:TrimString(s)
    return s:gsub("^%s*(.-)%s*$", "%1")
end
--[[ Pack(...) blizzard dosnt use 5.2 yet so will have to create this one
	@Arguments:
		...			arguments to pack into a table								
	@Returns:	
		a new table with all parameters stored into keys 1, 2, etc. and with a field "n" with the total number of parameters
]]
function DiesalTools:Pack(...)
	return  { n = select("#", ...), ... }
end
--[[ Unpack(...) 
	@Arguments:
		t			table to unpack								
	@Returns:	
		...		list of arguments
]]
function DiesalTools:Unpack(t)
	if t.n then
		return unpack(t,1,t.n)
	end	
	return unpack(table)	
end
--[[ string = Serialize(table) 
	@Param	table	- table to to serialize						
	@Return	string - serialized table (string)
	
	@deserialization:
		local func,err = loadstring('serialized table')
	 	if err then error(err) end
	 	return func()	
]]
local function serialize_number(number)
	-- no argument checking - called very often
	local text = ("%.17g"):format(number)
	-- on the same platform tostring() and string.format()
	-- return the same results for 1/0, -1/0, 0/0
	-- so we don't need separate substitution table
	return sub_table[text] or text
end
local function impl(t, cat, visited)
	local t_type = type(t)
	if t_type == "table" then
		if not visited[t] then
			visited[t] = true

			cat("{")
			-- Serialize numeric indices
			local next_i = 0
			for i, v in ipairs(t) do
				if i > 1 then -- TODO: Move condition out of the loop
					cat(",")
				end
				impl(v, cat, visited)
				next_i = i
			end
			next_i = next_i + 1
			-- Serialize hash part
			-- Skipping comma only at first element iff there is no numeric part.
			local need_comma = (next_i > 1)
			for k, v in pairs(t) do
				local k_type = type(k)
				if k_type == "string" then
					if need_comma then
						cat(",")
					end
					need_comma = true
					-- TODO: Need "%q" analogue, which would put quotes
					--       only if string does not match regexp below
					if not lua_keywords[k] and ("^[%a_][%a%d_]*$"):match(k) then
						cat(k) cat("=")
					else
						cat(format("[%q]=", k))
					end
					impl(v, cat, visited)
				else
					if
					k_type ~= "number" or -- non-string non-number
					k >= next_i or k < 1 or -- integer key in hash part of the table
					k % 1 ~= 0 -- non-integer key
					then
						if need_comma then
							cat(",")
						end
						need_comma = true

						cat("[")
						impl(k, cat, visited)
						cat("]=")
						impl(v, cat, visited)
					end
				end
			end
			cat("}")
			visited[t] = nil
		else
			-- this loses information on recursive tables
			cat('"table (recursive)"')
		end
	elseif t_type == "number" then
		cat(serialize_number(t))
	elseif t_type == "boolean" then
		cat(tostring(t))
	elseif t == nil then
		cat("nil")
	else
		-- this converts non-serializable (functions) types to strings
		cat(format("%q", tostring(t)))
	end
end
local function tstr_cat(cat, t)
	impl(t, cat, {})
end
function DiesalTools:Serialize(t)
	local buf = {}
	local cat = function(v) buf[#buf + 1] = v end
	impl(t, cat, {})
	return format('return %s',table_concat(buf))	
end
-- ~~| AceAddon Mixin |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DiesalTools.embeds = DiesalTools.embeds or {} 
local mixins = {
	"CreateID",
	"TableCopy",
	"GetColor",
	"GetTxtColor",
	"GetFrameQuadrant",
	"GetIconCoords",
	"Round",
	"Capitalize",
	"TrimString",
	"EscapeString",
	"Pack",
	"Unpack",
	"Serialize",		
}
function DiesalTools:Embed(target)
	for k, v in ipairs(mixins) do
		target[v] = self[v]
	end
	self.embeds[target] = true
	return target
end
-- Finally: upgrade old embeds
for target, v in pairs(DiesalTools.embeds) do
	DiesalTools:Embed(target)
end

