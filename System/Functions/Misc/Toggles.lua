local _, br = ...
-- Toggle keys: reading the key a toggle (or key option) is set to, cycling toggles, missing toggles.
---@class br.functions.misc
br.functions.misc = br.functions.misc or {}
local misc = br.functions.misc
local warnedMissingToggles = {}

-- Whether each key choice is held, in br.ui.dropOptions.Toggle order
local KEY_HELD = {
	function() return br.game.IsLeftControlKeyDown() end,  -- LeftCtrl
	function() return br.game.IsLeftShiftKeyDown() end,    -- LeftShift
	function() return br.game.IsRightControlKeyDown() end, -- RightCtrl
	function() return br.game.IsRightShiftKeyDown() end,   -- RightShift
	function() return br.game.IsRightAltKeyDown() end,     -- RightAlt
	function() return false end,                         -- None
	function() return br.game.GetKeyState(0x04) end,       -- MMouse
	function() return br.game.GetKeyState(0x05) end,       -- Mouse4
	function() return br.game.GetKeyState(0x06) end,       -- Mouse5
}
-- When each toggle's key last cycled it
local lastCycled = {}

-- True while that mouse button is down, or any of the five when none is named
function misc:isMouseButtonDown(button)
	local down = br.game.IsMouseButtonDown
	if button ~= nil then return down(button) end
	return down("LeftButton") or down("RightButton") or down("MiddleButton") or down("Button4") or down("Button5")
end

-- True while the player types in an edit box (chat, search), when keybind toggles must not fire
function misc:isTyping()
	return br.game.GetCurrentKeyBoardFocus() ~= nil
end

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
	local now = br.game.GetTime()
	if now - (lastCycled[toggle] or 0) > delay and misc:SpecificToggle(toggle .. " Mode")
		and not br.game.GetCurrentKeyBoardFocus()
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
	if br.bootstrap.stage ~= "RUNNING" then return end
	if br.ui.toggles and br.ui.toggles.modes[toggleName] ~= nil then return end
	local profile = tostring(br.loader.selectedProfileName)
	local key = profile .. "|" .. toggleName
	if warnedMissingToggles[key] then return end
	warnedMissingToggles[key] = true
	br.log:warning(profile .. " uses " .. purpose .. " (" .. apiCall .. ") but has no \"" .. toggleName
		.. "\" toggle, so " .. purpose .. " will never be used. Add a " .. toggleName .. " toggle to the profile.")
end
