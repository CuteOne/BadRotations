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

-- A debug line in chat: the label in the class color, the text white
local function debugPrint(label, text)
	br._G.print(br.ui.colors.class .. label .. ": |cffFFFFFF" .. text)
end

function misc:addonDebug(msg, system)
	if msg == nil then
		return
	end
	local msgText = tostring(msg)
	-- A message built with a secret value (a unit name, say) can only print as <SECRET>; say where it
	-- came from instead, so the line can be found
	if br._G.issecretvalue and (br._G.issecretvalue(msg) or br._G.issecretvalue(msgText)) then
		local where = br.ui.elementOptions and br.ui.elementOptions.rotationLine(true) or ""
		msgText = "(a debug line holding a secret value, from " .. (where ~= "" and where:gsub(":%s*$", "") or "BR") .. ")"
	end
	-- Prefer the dropdown value for Addon Debug Messages. Some configs
	-- may not include a separate checkbox, so rely on the dropdown being
	-- set.
	local addonDebugValue = br.functions.misc:getValue("Addon Debug Messages")
	if br.functions.misc:isChecked("Addon Debug Messages") and addonDebugValue then
		-- Choices: 1 System Only, 2 Profile Only, 3 All
		local showSystem = addonDebugValue == 1 or addonDebugValue == 3
		local showProfile = addonDebugValue == 2 or addonDebugValue == 3

		-- Use a per-message short timer key so different messages printed
		-- within a short interval aren't suppressed by the same global key.
		local msgKey = msgText
		if #msgKey > 40 then msgKey = msgKey:sub(1, 40) end

		-- Immediate-print for casting-related messages to avoid them being
		-- swallowed by simultaneous 'Combat Started' messages. Use a
		-- short per-message guard so we don't spam identical lines.
		-- Respect configured channel filtering (System/Profile/All).
		if showProfile and system ~= true and string.find(msgText, "Casting") then
			local castKey = "Casting Immediate:" .. msgKey
			if br.debug.timer:useTimer(castKey, 0.05) then
				debugPrint("Profile Debug", msgText)
			end
			return
		end

		if system == true and showSystem then
			local timerKey = "System Delay:" .. msgKey
			if br.debug.timer:useTimer(timerKey, 0.1) then
				debugPrint("System Debug", msgText)
			end
		elseif system ~= true and showProfile then
			local timerKey = "Profile Delay:" .. msgKey
			if br.debug.timer:useTimer(timerKey, 0.1) then
				debugPrint("Profile Debug", msgText)
			end
		end
	end
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
