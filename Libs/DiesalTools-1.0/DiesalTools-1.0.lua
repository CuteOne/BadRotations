-- $Id: DiesalTools-1.0.lua 61 2017-03-28 23:13:41Z diesal2010 $
local MAJOR, MINOR = "DiesalTools-1.0", "$Rev: 61 $"
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
-- ~~| Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
local colors = {
	blue				= '|cff'..'00aaff',
	darkblue		= '|cff'..'004466',
	orange			= '|cff'..'ffaa00',
	darkorange	= '|cff'..'4c3300',
	grey				= '|cff'..'7f7f7f',
	darkgrey		= '|cff'..'414141',
	white				= '|cff'..'ffffff',
	red					= '|cff'..'ff0000',
	green				= '|cff'..'00ff2b',
	yellow			= '|cff'..'ffff00',
	lightyellow	= '|cff'..'ffea7f',
}

local formattedArgs = {}

local function GetCaller(level)
	-- ADDON:LogMessage(debugstack(10,2, 0))
	for trace in debugstack(level,2, 0):gmatch("(.-)\n") do
		-- Blizzard Sandbox
		local match, _, file, line = trace:find("^.*\\(.-):(%d+)")
		if match then return format('%s[%s%s: %s%s%s]|r',colors.orange,colors.yellow,file,colors.lightyellow,line,colors.orange) end
		-- PQI DataFile
		local match, _, file,line = trace:find('^%[string "[%s%-]*(.-%.lua).-"%]:(%d+)')
		if match then return format('%s[%s%s: %s%s%s]|r',colors.orange,colors.yellow,file,colors.lightyellow,line,colors.orange) end
		-- PQR Ability code
		local match, _, file,line = trace:find('^%[string "(.-)"%]:(%d+)')
		if match then return format('%s[%s%s: %s%s%s]|r',colors.orange,colors.yellow,file,colors.lightyellow,line,colors.orange) end
	end
	return format('%s[%sUnknown Caller%s]|r',colors.orange,colors.red,colors.orange)
end
local function round(number, base)
	base = base or 1
	return floor((number + base/2)/base) * base
end
local function getRGBColorValues(color,g,b)
  if type(color) == 'number' and type(g) == 'number' and type(b) == 'number' then
    if color <= 1 and g <= 1 and b <= 1 then
      return round(color*255), round(g*255), round(b*255)
    end
    return color[1], color[2], color[3]
  elseif type(color) == 'table' and type(color[1]) == 'number' and type(color[2]) == 'number' and type(color[3]) == 'number' then
    if color[1] <= 1 and color[2] <= 1 and color[3] <= 1 then
      return round(color[1]*255), round(color[2]*255), round(color[3]*255)
    end
    return color[1], color[2], color[3]
  elseif type(color) == 'string' then
    return tonumber(sub(color, 1, 2),16), tonumber(sub(color, 3, 4),16), tonumber(sub(color, 5, 6),16)
  end
end


function DiesalTools.GetColor(value)
	if not value then return end

  if type(value) == 'table' and #value >= 3 then
		return value[1]/255, value[2]/255, value[3]/255
	elseif type(value) == 'string' then
		return tonumber(sub(value,1,2),16)/255, tonumber(sub(value,3,4),16)/255, tonumber(sub(value,5,6),16)/255
	end
end

-- ~~| API |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





function DiesalTools.Stack()
	print("|r------------------------------| Stack Trace |-------------------------------")
	local stack = debugstack(1,12, 0)
	for trace in stack:gmatch("(.-)\n") do
		match, _, file, line, func = trace:find("^.*\\(.-):(%d+).-`(.*)'$")
		if match then print(format("%s[%s%s: %s%s%s] %sfunction|r %s|r",colors.orange,colors.yellow,file,colors.lightyellow,line,colors.orange,colors.blue,func)) end
	end
	print("|r--------------------------------------------------------------------------------")
end
--[[ copy = TableCopy(src, dest, metatable)
	@Arguments:
		dest				Table to copy to
		src					Table to copy
		metatable		if true copies the metatable as well (boolean)
	@Returns:
		table				copy of table
--]]
function DiesalTools.TableCopy(src,dest,metatable)
  if type(src) == 'table' then
  	 if not dest then dest = {} end
      for sk, sv in next, src, nil do
        dest[DiesalTools.TableCopy(sk)] = DiesalTools.TableCopy(sv)
      end
      if metatable then setmetatable(dest, DiesalTools.TableCopy(getmetatable(src))) end
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


-- | Color Tools |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- converts a color from RGB[0-1], RGB[0-255], HEX or HSL to RGB[0-1], RGB[0-255] or HEX
function DiesalTools.ConvertColor(from,to,v1,v2,v3)
  if not from or not to or not v1 then return end
  if type(v1) == 'table' then v1,v2,v3 = v1[1],v1[2],v1[3] end
  local r, g, b
  from, to = from:lower(), to:lower()

  if from == 'rgb255' and type(v1) == 'number' and type(v2) == 'number' and type(v3) == 'number' then
    r,g,b = v1, v2, v3
  elseif from == 'rgb1' and type(v1) == 'number' and type(v2) == 'number' and type(v3) == 'number' then
    r,g,b = round(v1*255), round(v2*255), round(v3*255)
  elseif from == 'hex' and type(v1) == 'string' and #v1 > 5 then
    r,g,b = tonumber(sub(v1, 1, 2),16), tonumber(sub(v1, 3, 4),16), tonumber(sub(v1, 5, 6),16)
  elseif from == 'hsl' and type(v1) == 'number' and type(v2) == 'number' and type(v3) == 'number' then
    if v2 == 0 then
      v3 = round(v3 * 255)
      r,g,b = v3,v3,v3
    else
      v1, v2, v3 = v1/360*6, min(max(0, v2), 1), min(max(0, v3), 1)
      local c = (1-abs(2*v3-1))*v2
      local x = (1-abs(v1%2-1))*c
      local m = (v3-.5*c)
      r,g,b = 0,0,0
      if v1 < 1 then r,g,b = c,x,0
      elseif v1 < 2 then r,g,b = x,c,0
      elseif v1 < 3 then r,g,b = 0,c,x
      elseif v1 < 4 then r,g,b = 0,x,c
      elseif v1 < 5 then r,g,b = x,0,c
      else r,g,b = c,0,x end

      r,g,b = round((r+m)*255),round((g+m)*255),round((b+m)*255)
    end
  else
    return
  end
  r,g,b = min(255,max(0,r)), min(255,max(0,g)), min(255,max(0,b))

  if to == 'rgb255' then
    return r,g,b
  elseif to == 'rgb1' then
    return r/255,g/255,b/255
  elseif to == 'hex' then
    return format("%02x%02x%02x",r,g,b)
  end
end
-- Mixes a color with pure white to produce a lighter color
function DiesalTools.TintColor(color, percent, to, from)
   percent = min(1,max(0,percent))
   from, to = from or 'hex', to and to:lower() or 'hex'
   local r,g,b = DiesalTools.ConvertColor(from,'rgb255',color)

   if to == 'rgb255' then
     return round((255-r)*percent+r), round((255-g)*percent+g), round((255-b)*percent+b)
   elseif to == 'rgb1' then
     return round( ((255-r)*percent+r) / 255 ), round( ((255-g)*percent+g) / 255 ), round( ((255-b)*percent+b) / 255 )
   elseif to == 'hex' then
     return format("%02x%02x%02x", round((255-r)*percent+r), round((255-g)*percent+g), round((255-b)*percent+b) )
   end
  --  return format("%02x%02x%02x", round((255-r)*percent+r), round((255-g)*percent+g), round((255-b)*percent+b) )
end
-- Mixes a color with pure black to produce a darker color
function DiesalTools.ShadeColor(color, percent, to, from)
   percent = min(1,max(0,percent))
   from, to = from or 'hex', to and to:lower() or 'hex'
   local r,g,b = DiesalTools.ConvertColor(from,'rgb255',color)

   if to == 'rgb255' then
     return round(-r*percent+r), round(-g*percent+g), round(-b*percent+b)
   elseif to == 'rgb1' then
     return round( (-r*percent+r) / 255 ), round( (-g*percent+g) / 255 ), round( (-b*percent+b) / 255 )
   elseif to == 'hex' then
     return format("%02x%02x%02x", round(-r*percent+r), round(-g*percent+g), round(-b*percent+b) )
   end
end
-- Mixes a color with the another color to produce an intermediate color.
function DiesalTools.MixColors(color1, color2, percent, to, from)
  percent = min(1,max(0,percent))
  from, to = from or 'hex', to and to:lower() or 'hex'
  -- to = to and to:lower() or 'hex'

  local r1, g1, b1 = DiesalTools.ConvertColor(from,'rgb255',color1)
  local r2, g2, b2 = DiesalTools.ConvertColor(from,'rgb255',color2)

  if to == 'rgb255' then
    return round((r2-r1)*percent)+r1, round((g2-g1)*percent)+g1, round((b2-b1)*percent)+b1
  elseif to == 'rgb1' then
    return round( ((r2-r1)*percent+r1) / 255 ), round( ((g2-g1)*percent+g1) / 255 ), round( ((b2-b1)*percent+b1) / 255 )
  elseif to == 'hex' then
    return format("%02x%02x%02x", round((r2-r1)*percent)+r1, round((g2-g1)*percent)+g1, round((b2-b1)*percent)+b1 )
  end
end
--- converts color HSL to HEX
function DiesalTools.HSL(v1,v2,v3)
  if not v1 then return end
  if type(v1) == 'table' then v1,v2,v3 = v1[1],v1[2],v1[3] end
  local r, g, b

  if v2 == 0 then
    v3 = round(v3 * 255)
    r,g,b = v3,v3,v3
  else
    v1, v2, v3 = v1/360*6, min(max(0, v2), 1), min(max(0, v3), 1)
    local c = (1-abs(2*v3-1))*v2
    local x = (1-abs(v1%2-1))*c
    local m = (v3-.5*c)
    r,g,b = 0,0,0
    if v1 < 1 then r,g,b = c,x,0
    elseif v1 < 2 then r,g,b = x,c,0
    elseif v1 < 3 then r,g,b = 0,c,x
    elseif v1 < 4 then r,g,b = 0,x,c
    elseif v1 < 5 then r,g,b = x,0,c
    else r,g,b = c,0,x end

    r,g,b = round((r+m)*255),round((g+m)*255),round((b+m)*255)
  end

  r,g,b = min(255,max(0,r)), min(255,max(0,g)), min(255,max(0,b))

  return format("%02x%02x%02x",r,g,b)
end

--[[ GetTxtColor(value)
	@Arguments:
		value			Hex color code or a table contating R,G,B color values
	@Returns:
		text coloring escape sequence (|cFFFFFFFF)
-- ]]
function DiesalTools.GetTxtColor(value)
	if not value then return end

	if type(value) =='table' then value = string.format("%02x%02x%02x", value[1], value[2], value[3]) end
	return format('|cff%s',value)
end

-- | Texture Tools |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--[[ Get a piece of a texture as a cooridnate refernce
-- @Param 	column			the column in the texture
-- @Param 	row				the row in the texture
-- @Param 	size				the size in the texture
-- @Param 	textureWidth	total texture width
-- @Param 	textureHeight	total texture height
-- @Return	edge coordinates for image cropping, plugs directly into Texture:SetTexCoord(left, right, top, bottom)		]]
function DiesalTools.GetIconCoords(column,row,size,textureWidth,textureHeight)
	size 					= size or 16
	textureWidth 	= textureWidth or 128
	textureHeight = textureHeight	or 16
	return (column * size - size) / textureWidth, (column * size) / textureWidth, (row * size - size) / textureHeight, (row * size) / textureHeight
end
-- | String Tools |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--[[ Capitalize a string
--	@Param 	str	the string to capatilize
--	@Return	the capitilized string			]]
function DiesalTools.Capitalize(str)
  return (str:gsub("^%l", upper))
end
--[[ Escape all formatting in a WoW-lua string
-- @Param 	str	the string to escape
-- @Return	the escaped string		]]
function DiesalTools.EscapeString(string)
	return string:gsub( "[%z\1-\31\"\\|\127-\255]", escapeSequences )
end
--[[ ID = CreateID(s)
-- @Param 	s 	string to parse
-- @Return	ID	string stripped of all non letter characters and color codes.]]
function DiesalTools.CreateID(s)
	return gsub(s:gsub('c%x%x%x%x%x%x%x%x', ''), '[^%a%d]', '')
end
--[[ str = TrimString(s)
-- @Param 	s 		string to parse
-- @Return	str	string stripped of leading and trailing spaces.]]
function DiesalTools.TrimString(s)
    return s:gsub("^%s*(.-)%s*$", "%1")
end
--[[ string = SpliceString(string, start, End, txt)
	@Arguments:
		string			string to splice
		start				starting index of splice
		End					ending index of splice
		txt					new text to splice in (string)
	@Returns:
		string			resulting string of the splice

	@example:
		DiesalTools.SpliceString("123456789",2,4,'NEW') -- returns: "1NEW56789"
--]]
function DiesalTools.SpliceString(string,start,End,txt)
	return string:sub(1, start-1)..txt..string:sub(End+1,-1)
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
function DiesalTools.Serialize(t)
	local buf = {}
	local cat = function(v) buf[#buf + 1] = v end
	impl(t, cat, {})
	return format('return %s',table_concat(buf))
end

-- | Math Tools |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--[[ Round a number
-- @Param 	number 	the number to round
-- @Param 	base		the number to round to (can be a decimal)	[Default:1]
-- @Return	the rounded number to base		]]
function DiesalTools.Round(number, base)
	base = base or 1
	return floor((number + base/2)/base) * base
end
--[[ Round a number for printing
-- @Param 	number 	the number to round
-- @Param 	idp			number of decimal points to round to	[Default:1]
-- @Return	the rounded number ]]
function DiesalTools.RoundPrint(num, idp)
	return string.format("%." .. (idp or 0) .. "f", num)
end

-- | Frame Tools |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--[[ GetFrameQuadrant(frame)
	@Arguments:
		frame			frame?!!
	@Returns:
		quadrant   	quadrant of the screen frames center is in
-- ]]
function DiesalTools.GetFrameQuadrant(frame)
  if not frame:GetCenter() then	return "UNKNOWN", frame:GetName()	end

	local x, y = frame:GetCenter()
	local screenWidth = GetScreenWidth()
	local screenHeight = GetScreenHeight()
	local quadrant	

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

-- | Misc Tools |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--[[ Pack(...) blizzard dosnt use 5.2 yet so will have to create this one
	@Arguments:
		...			arguments to pack into a table
	@Returns:
		a new table with all parameters stored into keys 1, 2, etc. and with a field "n" with the total number of parameters
]]
function DiesalTools.Pack(...)
	return  { n = select("#", ...), ... }
end
--[[ Unpack(...)
	@Arguments:
		t			table to unpack
	@Returns:
		...		list of arguments
]]
function DiesalTools.Unpack(t)
	if t.n then
		return unpack(t,1,t.n)
	end
	return unpack(table)
end
