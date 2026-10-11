local _, br = ...
-- Debug messages and developer mode.
br.functions.misc = br.functions.misc or {}
local misc = br.functions.misc

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

function misc:addonDebug(msg, system)
	if msg == nil then
		return
	end
	local msgText = tostring(msg)
	-- A message built with a secret value (a unit name, say) can only print as <SECRET>; say where it
	-- came from instead, so the line can be found
	if br._G.issecretvalue and (br._G.issecretvalue(msg) or br._G.issecretvalue(msgText)) then
		local where = br.ui.elementOptions and br.ui.elementOptions.rotationLine() or ""
		msgText = "(a debug line holding a secret value, from " .. (where ~= "" and where:gsub(":%s*$", "") or "BR") .. ")"
	end
	-- Prefer the dropdown value for Addon Debug Messages. Some configs
	-- may not include a separate checkbox, so rely on the dropdown being
	-- set.
	local addonDebugValue = br.functions.misc:getValue("Addon Debug Messages")
	if br.functions.misc:isChecked("Addon Debug Messages") and addonDebugValue then
		local showSystem = addonDebugValue == 1 or addonDebugValue == 2
		local showProfile = addonDebugValue == 1 or addonDebugValue == 3

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
				print(br.ui.colors.class .. "[BadRotations] Profile Debug: |cffFFFFFF" .. msgText)
			end
			return
		end

		if system == true and showSystem then
			local timerKey = "System Delay:" .. msgKey
			if br.debug.timer:useTimer(timerKey, 0.1) then
				print(br.ui.colors.class .. "[BadRotations] System Debug: |cffFFFFFF" .. msgText)
			end
		elseif system ~= true and showProfile then
			local timerKey = "Profile Delay:" .. msgKey
			if br.debug.timer:useTimer(timerKey, 0.1) then
				print(br.ui.colors.class .. "[BadRotations] Profile Debug: |cffFFFFFF" .. msgText)
			end
		end
	end
end
