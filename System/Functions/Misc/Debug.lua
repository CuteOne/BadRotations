local _, br = ...
-- Debug messages and developer mode.
---@class br.functions.misc
br.functions.misc = br.functions.misc or {}
local misc = br.functions.misc

-- On Forever, values BR may use can still be flagged secret, and any text built from one prints as
-- <SECRET> (and can't be written to a file). BR may compare them, so for printing they're rebuilt
-- from comparisons. Only for output: whether BR may use a value is misc:canUseValue.

-- Whether a value would print as <SECRET>
function misc:isFlagged(value) return br._G.issecretvalue ~= nil and br._G.issecretvalue(value) end

-- The whole number 0..max that value (scaled) rounds down to, found by halving
function misc:plainInteger(value, max)
	local low, high = 0, max
	while low < high do
		local mid = math.floor((low + high + 1) / 2)
		if value >= mid then low = mid else high = mid - 1 end
	end
	return low
end

-- A flagged number, to the nearest 0.01 (up to a billion either way), that prints
local PLAIN_MAX = 100000000000 -- a billion, in hundredths
function misc:plainNumber(value)
	if not misc:isFlagged(value) then return value end
	if value < 0 then return -misc:plainInteger(-value * 100 + 0.5, PLAIN_MAX) / 100 end
	return misc:plainInteger(value * 100 + 0.5, PLAIN_MAX) / 100
end

-- Flagged text, byte by byte, that prints
function misc:plainText(text)
	if not misc:isFlagged(text) then return text end
	local bytes = {}
	for i = 1, misc:plainInteger(#text, 4096) do bytes[i] = string.char(misc:plainInteger(text:byte(i), 255)) end
	return table.concat(bytes)
end

-- Addon Debug Messages, shown by the option's choice (1 System Only, 2 Profile Only, 3 All):
--   Profile Debug  what the rotation did: its casts and item uses, opener steps, combat start/end
--                  (ui.debug, also from shared modules acting for the profile)
--   System Debug   BR's own reasoning and state: cast gates and refusals, the loader's stages,
--                  engines (system = true)
-- The same line again within REPEAT_GAP seconds isn't repeated ("Casting" lines within 0.05 s: a
-- spell cast twice in a row is shown twice).
local REPEAT_GAP, CAST_REPEAT_GAP = 0.1, 0.05
local lastShown, lastShownCount = {}, 0 -- full line -> GetTime it was shown; cleared when it grows

function misc:addonDebug(msg, system)
	if msg == nil or not misc:isChecked("Addon Debug Messages") then return end
	local choice = misc:getValue("Addon Debug Messages")
	if system then
		if choice ~= 1 and choice ~= 3 then return end
	elseif choice ~= 2 and choice ~= 3 then
		return
	end
	local text = tostring(msg)
	-- Flagged text BR may use prints as plain text; text BR can't read says where it came from
	if not misc:canUseValue(text) then
		local where = br.ui.elementOptions and br.ui.elementOptions.rotationLine(true) or ""
		text = "(a debug line holding a secret value, from " .. (where ~= "" and where:gsub(":%s*$", "") or "BR") .. ")"
	else
		text = misc:plainText(text)
	end
	local label = system and "System Debug" or "Profile Debug"
	local key = label .. text
	local now = br._G.GetTime()
	local gap = (not system and text:find("Casting", 1, true)) and CAST_REPEAT_GAP or REPEAT_GAP
	if lastShown[key] and now - lastShown[key] < gap then return end
	if lastShownCount >= 200 then br._G.wipe(lastShown); lastShownCount = 0 end
	if not lastShown[key] then lastShownCount = lastShownCount + 1 end
	lastShown[key] = now
	br.log:say(label, br.log.colors.text .. text, br.ui.colors.class)
end

function misc:devMode()
	if br.functions.misc:isChecked("Dev Mode") then
		if _G.br == nil then
			_G.br = br
			br._G.print("<Dev Mode Enabled>")
		end
	else
		if _G.br ~= nil then
			_G.br = nil
			br._G.print("<Dev Mode Disabled>")
		end
	end
end
