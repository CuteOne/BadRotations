br.ui.window.settings = {}
function br.ui:createSettingsWindow()
		if not br.ui.window['settings']['parent'] then
			br.ui.window.settings = br.ui:createWindow("Save/Load Settings", 200, 125, "Save/Load Settings")
			local section
			section = br.ui:createSection(br.ui.window.settings, "Save/Load")
			br.ui:createCheckbox(section, "Dungeons", "Save/Load Dungeon Data")
			br.ui:createCheckbox(section, "Raids", "Save/Load Raid Data")
			br.ui:createSettingsButton(section, "Save", 0, -40)
			br.ui:createSettingsButton(section, "Load", 100, -40)
        	br.ui:checkSectionState(section)
	        br.ui.window.settings.parent.closeButton:SetScript("OnClick", function()
		    	if br.data.settings[br.selectedSpec][br.selectedProfile] ~= nil then
					br.data.settings[br.selectedSpec][br.selectedProfile]["Save/Load SettingsCheck"] = false
				end
		    	if slsettings ~= nil then slsettings:SetChecked(false) end
		        br.data.settings[br.selectedSpec].settings["active"] = false
		        br.ui.window.settings.parent:Hide()
	    	end)
	    	br.ui:checkWindowStatus("settings")
			br.ui:closeWindow("settings")
		end
		if isChecked("Save/Load Settings") then
	    	if not br.ui.window['settings']['parent'] then 
	    		br.ui.window.settings = br.ui:createWindow("Save/Load Settings", 200, 125, "Save/Load Settings")
				local section
				section = br.ui:createSection(br.ui.window.settings, "Save/Load")
				br.ui:createCheckbox(section, "Dungeons", "Save/Load Dungeon Data")
				br.ui:createCheckbox(section, "Raids", "Save/Load Raid Data")
				br.ui:createSettingsButton(section, "Save", 0, -40)
				br.ui:createSettingsButton(section, "Load", 100, -40)
	        	br.ui:checkSectionState(section)
	        	br.ui.window.settings.parent.closeButton:SetScript("OnClick", function()
		    	if br.data.settings[br.selectedSpec][br.selectedProfile] ~= nil then
					br.data.settings[br.selectedSpec][br.selectedProfile]["Save/Load SettingsCheck"] = false
				end
		    	if slsettings ~= nil then slsettings:SetChecked(false) end
		        br.data.settings[br.selectedSpec].settings["active"] = false
		        br.ui.window.settings.parent:Hide()
	    	end)
	    	br.ui:checkWindowStatus("settings")
	        end
			br.ui:showWindow("settings")
	    elseif br.data.settings[br.selectedSpec]["settings"] == nil then
    		br.data.settings[br.selectedSpec]["settings"] = {}
    		br.data.settings[br.selectedSpec]["settings"].active = false
    	elseif br.data.settings[br.selectedSpec]["settings"].active == true then
	    	br.ui:closeWindow("settings")
		end
	end