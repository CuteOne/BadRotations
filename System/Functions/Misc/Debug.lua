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

-- Dev Mode exposes br as a global while it's checked
br.lifecycle:onTick(1, "dev mode", function() misc:devMode() end)
