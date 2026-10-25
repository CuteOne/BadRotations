local _, br = ...
-- Small value helpers: whether BR may use a (secret) value, rounding, names and addon paths.
---@class br.functions.misc
br.functions.misc = br.functions.misc or {}
local misc = br.functions.misc

-- Runs fn after the given seconds
function misc:after(seconds, fn)
	br.game.C_Timer.After(seconds, fn)
end

-- Whether BR may use a value (compare it, do arithmetic with it). See System/Secrets.lua:
-- issecretvalue is true even for values BR's protected scripts may use (measured on Forever), so
-- it only decides whether a value can be shown in chat.
function misc:canUseValue(value)
	return br.secrets.canUse(value)
end

function misc:convertName(name)
	if name ~= nil then
		-- Remove hyphens and lowercase the letter that follows
		name = name:gsub("-(%a)", function(letter)
			return letter:lower()
		end)
		-- Cap All First Letters of Words
		name = name:gsub("(%a)([%w_']*)", function(first, rest)
			return first:upper() .. rest:lower()
		end)
		-- Lower first character of name
		name = name:gsub("%a", string.lower, 1)
		-- Remove all non alphanumeric in string
		name = name:gsub("%W", "")
		return name
	end
	return "None"
end

-- BadRotations' folder on disk and the path separator for this OS.
-- local path, sep = br.functions.misc:getAddonPath()
function misc:getAddonPath()
	local sep = br.game.IsMacClient() and "/" or "\\"
	local wowDir = br.game.GetWoWDirectory() or ""
	if wowDir:match('_retail_') then
		return wowDir .. sep .. 'Interface' .. sep .. 'AddOns' .. sep .. br.loader.addonName, sep
	end
	return wowDir .. sep .. br.loader.addonName, sep
end

-- Class folder name used under Rotations/ and Settings/ (e.g. "Druid", "Death Knight").
-- local folder = br.functions.misc:getClassFolderName("DEATHKNIGHT")
function misc:getClassFolderName(class)
	if class == nil then class = "" end
	local formatClass = class:sub(1, 1):upper() .. class:sub(2):lower()
	if formatClass == "Deathknight" then formatClass = "Death Knight" end
	if formatClass == "Demonhunter" then formatClass = "Demon Hunter" end
	return formatClass
end

--- Round
function misc:round2(num, idp)
	local mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- UnitGUID("target"):sub(-15,-10)

-- The game clock in seconds
function misc:getTime()
	return br.game.GetTime()
end
