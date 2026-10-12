local _, br = ...
-- Toggle keys: reading the key a toggle (or key option) is set to, cycling toggles, missing toggles.
---@class br.functions.misc
br.functions.misc = br.functions.misc or {}
local misc = br.functions.misc
local warnedMissingToggles = {}

function misc:SpecificToggle(toggle)
	if br.customToggle then
		return false
	elseif br.functions.misc:getOptionValue(toggle) == 1 then
		return br._G.IsLeftControlKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 2 then
		return br._G.IsLeftShiftKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 3 then
		return br._G.IsRightControlKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 4 then
		return br._G.IsRightShiftKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 5 then
		return br._G.IsRightAltKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 6 then
		return false
	elseif br.functions.misc:getOptionValue(toggle) == 7 then
		return br._G.GetKeyState(0x04)
	elseif br.functions.misc:getOptionValue(toggle) == 8 then
		return br._G.GetKeyState(0x05)
	elseif br.functions.misc:getOptionValue(toggle) == 9 then
		return br._G.GetKeyState(0x06)
	elseif br.functions.misc:getOptionValue(toggle) == 10 then
		return br._G.GetKeyState(0xC0)
	end
end

function misc:UpdateToggle(toggle, delay)
	--if toggle == nil then toggle = "toggle" end
	if br.customToggle then
		toggle = br.toggleKey
	end
	if br._G[toggle .. "Timer"] == nil then
		br._G[toggle .. "Timer"] = 0
	end
	if (br.functions.misc:SpecificToggle(toggle .. " Mode") or br.customToggle) and not br._G.GetCurrentKeyBoardFocus() and br._G.GetTime() - br._G[toggle .. "Timer"] > delay then
		br._G[toggle .. "Timer"] = br._G.GetTime()
		br.ui:ToggleValue(tostring(toggle))
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
