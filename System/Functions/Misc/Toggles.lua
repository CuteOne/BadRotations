local _, br = ...
-- Toggle keys: reading the key a toggle (or key option) is set to, cycling toggles, missing toggles.
---@class br.functions.misc
br.functions.misc = br.functions.misc or {}
local misc = br.functions.misc
local warnedMissingToggles = {}

-- Whether each key choice is held, in br.ui.dropOptions.Toggle order
local KEY_HELD = {
	function() return br._G.IsLeftControlKeyDown() end,  -- LeftCtrl
	function() return br._G.IsLeftShiftKeyDown() end,    -- LeftShift
	function() return br._G.IsRightControlKeyDown() end, -- RightCtrl
	function() return br._G.IsRightShiftKeyDown() end,   -- RightShift
	function() return br._G.IsRightAltKeyDown() end,     -- RightAlt
	function() return false end,                         -- None
	function() return br._G.GetKeyState(0x04) end,       -- MMouse
	function() return br._G.GetKeyState(0x05) end,       -- Mouse4
	function() return br._G.GetKeyState(0x06) end,       -- Mouse5
}
-- When each toggle's key last cycled it
local lastCycled = {}

--- Whether the key chosen in a key option (a br.ui.dropOptions.Toggle dropdown) is held: false for
--- "None", nil when the option doesn't exist.
function misc:SpecificToggle(toggle)
	local held = KEY_HELD[misc:getOptionValue(toggle)]
	if held == nil then return nil end
	return held()
end

--- Moves a toggle to its next mode while its key ("<toggle> Mode") is held, at most once per delay
--- seconds.
function misc:UpdateToggle(toggle, delay)
	local now = br._G.GetTime()
	if now - (lastCycled[toggle] or 0) > delay and misc:SpecificToggle(toggle .. " Mode")
		and not br._G.GetCurrentKeyBoardFocus()
	then
		lastCycled[toggle] = now
		br.ui:ToggleValue(toggle)
	end
end

-- Warns once per profile when the rotation relies on a toggle it never created (e.g. it calls
-- ui.useCDs() without a "Cooldown" toggle, so cooldowns would silently never be used).
-- Only checks once startup has finished, so a toggle bar deferred by combat isn't reported.
-- br.functions.misc:warnMissingToggle("Cooldown", "cooldowns", "ui.useCDs()")
function misc:warnMissingToggle(toggleName, purpose, apiCall)
	if not (br.loader.bootstrap and br.loader.bootstrap.stage == "RUNNING") then return end
	if br.ui.toggles and br.ui.toggles.modes[toggleName] ~= nil then return end
	local profile = tostring(br.loader.selectedProfileName)
	local key = profile .. "|" .. toggleName
	if warnedMissingToggles[key] then return end
	warnedMissingToggles[key] = true
	br._G.print("|cffFF8800" .. profile .. " uses " .. purpose .. " (" .. apiCall .. ") but has no \"" .. toggleName
		.. "\" toggle, so " .. purpose .. " will never be used. Add a " .. toggleName .. " toggle to the profile.|r")
end
