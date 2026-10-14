local _, br = ...
-- The Rotation Log window (System/RotationLog.lua): shown while the Bot Options "Rotation Log"
-- checkbox is ticked; closing the window unticks it. Its text can be selected and copied.
br.ui.window.debug = {}

local OPTION_PAGE = "Bot Options/Debug Options"

local function setOption(checked)
	local profileSettings = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
	if profileSettings ~= nil and profileSettings[OPTION_PAGE] ~= nil then
		profileSettings[OPTION_PAGE]["Rotation Log Check"] = checked
		if br.data.ui ~= nil and br.data.ui[OPTION_PAGE] ~= nil then
			br.data.ui[OPTION_PAGE]["Rotation Log Check"] = checked
		end
	end
	if br.ui.rotationLog ~= nil then br.ui.rotationLog:SetChecked(checked) end
end

function br.ui:createDebugWindow()
	br.ui.window.debug = br.ui:createWindow("debug", 520, 260, "Rotation Log - Ctrl+C copies", nil, "copy")
	br.ui.window.debug.parent.closeButton:SetScript("OnClick", function()
		br.ui:savePosition("debug")
		setOption(false)
		br.ui.window.debug.parent:Hide()
	end)
	br.ui:showRotationLog(br.functions.misc:isChecked("Rotation Log"))
end

--- Shows or hides the Rotation Log window (the checkbox calls this when it changes)
function br.ui:showRotationLog(shown)
	local box = br.ui.window.debug
	if box == nil or box.parent == nil then return end
	if shown then
		box.parent:Show()
		br.log.rotation:refreshWindow()
	else
		box.parent:Hide()
	end
end
