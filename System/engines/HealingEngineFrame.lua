local _, br = ...
br.engines.healingEngineFrame = br.engines.healingEngineFrame or {}
local healingEngineFrame = br.engines.healingEngineFrame

function healingEngineFrame:pulseNovaDebug()
	-- if br.functions.misc:getOptionCheck("Healing Debug") ~= true then
	-- 	-- if healingDebug--[[Started]] and br._G["healingDebugFrame"]:IsShown() == true then
	-- 	-- 	_G["healingDebugFrame"]:Hide()
	-- 	-- end
	-- 	if not br.ui.window['healing']['parent'] then br.ui:createHealingWindow() end
	-- 	br.ui:showWindow("healing")
	-- else
	-- 	-- if healingDebug--[[Started]] and br._G["healingDebugFrame"]:IsShown() ~= true then
	-- 	-- 	_G["healingDebugFrame"]:Show()
	-- 	-- end
	-- 	if not br.ui.window['healing']['parent'] then br.ui:createHealingWindow() end
	-- 	br.ui:showWindow("healing")
	-- 	if not healingDebug then --Started then
	-- 		healingDebug = true --Started = true
	-- 		-- frameCreation("healingDebug",200,150,"|cffFF001Ebr.engines.healingEngine.friend")
	-- 		br.ui:createHealingWindow()
	-- 		for i = 1, 5 do
	-- 			local thisOption = { name = i, status = 100, statusMin = 0, statusMax = 100, unit = "thisUnit" }
	-- 			createNovaStatusBar("healingDebug",thisOption,10,-i*25,180,20,false)
	-- 		end
	-- 	end
	-- 	-- i will gather frames informations via thisDebugRow = br.engines.healingEngine.friendDebug[i]
	-- 	local novaUnits = #br.engines.healingEngine.friend
	-- 	if novaUnits > 5 then
	-- 		novaUnits = 5
	-- 	end
	-- 	for i = 1, novaUnits do
	-- 		local thisUnit = br.engines.healingEngine.friend[i]
	-- 		_G[br.engines.healingEngine.friendDebug[i]]:Show()
	-- 		thisDebugRow = br.engines.healingEngine.friendDebug[i]
	-- 		_G[thisDebugRow]:SetValue(thisUnit.hp)
	-- 		_G[thisDebugRow.."Text"]:SetText(math.floor(thisUnit.hp))
	-- 		if br.ui.colors.classs[thisUnit.class] ~= nil then
	-- 			_G[thisDebugRow]:SetStatusBarTexture(br.ui.colors.classs[thisUnit.class].R,br.ui.colors.classs[thisUnit.class].G,br.ui.colors.classs[thisUnit.class].B)
	-- 		else
	-- 			_G[thisDebugRow]:SetStatusBarTexture(1,1,1)
	-- 		end
	-- 		if thisUnit.dispel == true then
	-- 			_G[thisDebugRow]:SetStatusBarTexture(0.70,0,0)
	-- 		end
	-- 	end
	-- 	-- show up to 5 frames or #br.engines.healingEngine.friend
	-- 	if novaUnits < 5 then
	-- 		for i = 1, 5 do
	-- 			if i > novaUnits then
	-- 				_G[br.engines.healingEngine.friendDebug[i]]:Hide()
	-- 			end
	-- 		end
	-- 	end
	-- 	_G["healingDebugFrame"]:SetHeight((novaUnits+1)*23)
	-- end

	local DiesalGUI = br._G.LibStub("DiesalGUI-1.0")
	function br.ui:createBar(parent, option, unit, tooltip, tooltipSpin)
		local value, text, statusMin, statusMax = option.name, option.status, option.statusMin, option.statusMax
		---@diagnostic disable-next-line: undefined-field
		local newHPBar = DiesalGUI:Create("Bar")
		parent = parent or {}
		--print(newHPBar)

		-- Create Checkbox for Spinner
		-- local checkBox = br.ui:createCheckbox(parent, text, tooltip)

		-- Calculate position
		-- local howManyBoxes = 0
		-- for i=1, #parent.children do
		--     if parent.children[i].type == "Toggle" then
		--         howManyBoxes = howManyBoxes + 1
		--     end
		-- end
		-- local y = howManyBoxes
		-- if y  ~= 1 then y = ((y-1) * -15) -5 end
		-- if y == 1 then y = -5 end

		-- if hideCheckbox then
		--     checkBox:Disable()
		--     checkBox:ReleaseTextures()
		-- end

		-- Set size
		-- newBar.settings.height = 12

		-- -- Set Steps
		-- newBar.settings.min = min or 0
		-- newBar.settings.max = max or 100
		-- newBar.settings.step = br.functions.unit:getHP(unit) or 0

		newHPBar:SetParent(parent.content)

		-- Set anchor
		-- newBar:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -10, -5) -- y)
		newHPBar:SetSize(180, 22)

		local color = "|cffFFFFFF"
		local classColor = br.ui.colors:getColor(unit.unit)
		if classColor then
			color = classColor.hex
		end
		newHPBar:SetColor(color)

		-- Read number from config or set default
		if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][text .. "Status"] == nil then
			br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][text .. "Status"] = br.functions.unit:getHP(unit) or 0
		end
		local state = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][text .. "Status"]
		br.newHpBar:SetValue(state, 0, 100)

		-- Event: OnValueChange
		-- newBar:SetEventListener('OnValueChanged', function(this, event, checked)
		-- br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][text.."Status"] = newSpinner:GetNumber()
		-- end)
		-- Event: Tooltip
		if tooltip or tooltipSpin then
			tooltip = tooltipSpin or tooltip
			newHPBar:SetEventListener(
				"OnEnter",
				function(this, event)
					---@diagnostic disable-next-line: undefined-field
					br._G.GameTooltip:SetOwner(br._G.Minimap, "ANCHOR_CURSOR", 50, 50)
					---@diagnostic disable-next-line: undefined-field
					br._G.GameTooltip:SetText(tooltip, 214 / 255, 25 / 255, 25 / 255)
					---@diagnostic disable-next-line: undefined-field
					br._G.GameTooltip:Show()
				end
			)
			newHPBar:SetEventListener(
				"OnLeave",
				function(this, event)
					---@diagnostic disable-next-line: undefined-field
					br._G.GameTooltip:Hide()
				end
			)
		end

		newHPBar:ApplySettings()

		parent:AddChild(newHPBar)

		return newHPBar
	end

	function healingEngineFrame:createNovaStatusBar(parent, option, x, y, width, height)
		-- local value, status, statusMin, statusMax = option.name, option.status, option.statusMin, option.statusMax
		-- width = width or 180
		-- height = height or 22
		-- if br._G[parent .. value .. "Nova"] == nil then
		-- 	local scale = 1 --br.data.settings.optionsFrame.scale or 1
		-- 	local currentValue = 0--_G[parent .. value .. "Nova"]:GetValue()
		-- 	_G[parent .. value .. "Nova"] = br._G.CreateFrame("StatusBar", br._G[parent .. value .. "Nova"],
		-- 		br._G.UIParent, "BackdropTemplate")
		-- 	_G[parent .. value .. "Nova"]:SetWidth(width * scale)
		-- 	_G[parent .. value .. "Nova"]:SetHeight(height * scale)
		-- 	_G[parent .. value .. "Nova"]:SetPoint("TOPLEFT", x * scale, (y - 2) * scale)
		-- 	_G[parent .. value .. "Nova"]:SetAlpha(1)
		-- 	-- status part
		-- 	_G[parent .. value .. "Nova"]:SetStatusBarTexture(1, 1, 1)
		-- 	_G[parent .. value .. "Nova"]:SetMinMaxValues(statusMin, statusMax)
		-- 	_G[parent .. value .. "Nova"]:SetValue(currentValue or 50)
		-- 	-- hover event
		-- 	_G[parent .. value .. "Nova"]:SetBackdropColor(1, 1, 1)

		-- 	_G[parent .. value .. "Nova"]:SetScript(
		-- 		"OnEnter",
		-- 		function(self)
		-- 			---@diagnostic disable-next-line: undefined-field
		-- 			br._G.GameTooltip:SetOwner(self, "BOTTOMLEFT", 225, 5)
		-- 			local thisUnit = br.engines.healingEngine.friend[value]
		-- 			if thisUnit then
		-- 				local color = "|cffFFFFFF"
		-- 				for i = 1, #br.ui.colors.classs do
		-- 					if br.ui.colors.classs[i].class == thisUnit.class then
		-- 						color = "|cff" .. br.ui.colors.classs[i].hex
		-- 					end
		-- 				end
		-- 				---@diagnostic disable-next-line: undefined-field
		-- 				br._G.GameTooltip:SetText(
		-- 					color ..
		-- 					"Name: " ..
		-- 					thisUnit.name ..
		-- 					"\n|cffFF1100Health: " .. math.floor(thisUnit.hp) .. "\n|cff11A7DFRole: " .. thisUnit.role,
		-- 					nil,
		-- 					nil,
		-- 					nil,
		-- 					nil,
		-- 					true
		-- 				)
		-- 				---@diagnostic disable-next-line: undefined-field
		-- 				br._G.GameTooltip:Show()
		-- 			end
		-- 		end
		-- 	)
		-- 	-- leave event
		-- 	_G[parent .. value .. "Nova"]:SetScript(
		-- 		"OnLeave",
		-- 		function(self)
		-- 			---@diagnostic disable-next-line: undefined-field
		-- 			br._G.GameTooltip:Hide()
		-- 		end
		-- 	)
		-- 	-- leave event
		-- 	_G[parent .. value .. "Nova"]:SetScript(
		-- 		"OnMouseDown",
		-- 		function(self, button)
		-- 			if button == "RightButton" then
		-- 				br._G.FocusUnit(br.engines.healingEngine.friend[value].unit)
		-- 			else
		-- 				br._G.RunMacroText("/target " .. br._G.UnitName(br.engines.healingEngine.friend[value].unit))
		-- 			end
		-- 		end
		-- 	)
		-- 	-- text
		-- 	_G[parent .. value .. "NovaText"] = br._G[parent .. value .. "Nova"]:CreateFontString(
		-- 		_G[parent .. value .. "NovaText"], "ARTWORK")
		-- 	_G[parent .. value .. "NovaText"]:SetWidth(width * scale)
		-- 	_G[parent .. value .. "NovaText"]:SetHeight(height * scale)
		-- 	_G[parent .. value .. "NovaText"]:SetPoint("CENTER", 0, -2)
		-- 	_G[parent .. value .. "NovaText"]:SetAlpha(1)
		-- 	_G[parent .. value .. "NovaText"]:SetJustifyH("CENTER")
		-- 	_G[parent .. value .. "NovaText"]:SetFont(br.data.settings.font, br.data.settings.fontsize, "THICKOUTLINE")
		-- 	_G[parent .. value .. "NovaText"]:SetText(currentValue, nil, nil, nil, nil, false)
		-- 	if br.nNovaDebug == nil then
		-- 		br.nNovaDebug = {}
		-- 	end
		-- 	br.nNovaDebug[#br.nNovaDebug + 1] = parent .. value .. "Nova"
		-- end
	end

	local novaUnits = #br.engines.healingEngine.friend
	if novaUnits > 5 then
		novaUnits = 5
	end
	if br.functions.misc:getOptionCheck("Healing Debug") then
		-- br.data.settings[br.loader.selectedSpec]["healing"].height = ((novaUnits + 1) * 23) --:SetHeight
		-- textString = ""
		-- for i = 1, #br.engines.healingEngine.friend do
		-- 	local thisUnit = br.engines.healingEngine.friend[i]
		-- 	local color = "|cffFFFFFF"
		--           if classColors[thisUnit.class] ~= nil then
		--               color = "|"..classColors[thisUnit.class].hex
		--           end
		--           -- if textString == nil then
		-- 	textString = textString.."\nName: "..color..UnitName(br.engines.healingEngine.friend[i].unit).." |r HP:"..thisUnit.hp
		-- end
		-- br.ui.window.healing:AddMessage(textString)
		-- if not br.ui.window["healing"]["parent"] then
		-- 	br.ui:createHealingWindow()
		-- end
		--br.ui:showWindow("healing")
		-- if not healingDebug then --Started then
		-- 	healingDebug = true --Started = true
		-- frameCreation("healingDebug",200,150,"|cffFF001Ebr.engines.healingEngine.friend")
		-- br.ui:createHealingWindow()
		for i = 1, 5 do
			local thisOption = { name = i, status = 100, statusMin = 0, statusMax = 100, unit = "thisUnit" }
			-- br.ui.window.healing:AddMessage(thisOption)
			healingEngineFrame:createNovaStatusBar("healing", thisOption, 10, -i * 25, 180, 20)
			--br.ui:createBar("healing", thisOption, thisOption.unit, tooltip, tooltipSpin)
		end
		-- end
		-- i will gather frames informations via thisDebugRow = br.engines.healingEngine.friendDebug[i]
		for i = 1, novaUnits do
			local thisUnit = br.engines.healingEngine.friend[i]
			local thisDebugRow
			if thisUnit.class == "Death Knight" then
				thisUnit.class = "Deathknight"
			elseif thisUnit.class == "Demon Hunter" then
				thisUnit.class = "Demonhunter"
			end
			local classColor = br.ui.colors:getColor(thisUnit.unit)
			-- local tooltipMsg = color.."Name: "..thisUnit.name..
			--         "\n|cffFF1100Health: "..math.floor(thisUnit.hp)..
			--         "\n|cff11A7DFRole: "..thisUnit.role, nil, nil, nil, nil, true
			-- br.ui:createBar("healing", UnitName(thisUnit), thisUnit, tooltipMsg)
			-- _G[br.nNovaDebug[i]]:Show()
			thisDebugRow = br.nNovaDebug[i]
			_G[thisDebugRow]:SetValue(thisUnit.hp)
			_G[thisDebugRow .. "Text"]:SetText(math.floor(thisUnit.hp))
			if classColor then
				_G[thisDebugRow]:SetStatusBarTexture(classColor.R, classColor.G, classColor.B)
			else
				_G[thisDebugRow]:SetStatusBarTexture(1, 1, 1)
			end
			if thisUnit.dispel == true then
				_G[thisDebugRow]:SetStatusBarTexture(0.70, 0, 0)
			end
		end
		-- show up to 5 frames or #br.engines.healingEngine.friend
		if novaUnits < 5 then
			for i = 1, 5 do
				if i > novaUnits then
					_G[br.nNovaDebug[i]]:Hide()
				end
			end
		end
	elseif not br.functions.misc:getOptionCheck("Healing Debug") then
		for i = 1, novaUnits do
			if br.nNovaDebug ~= nil then
				_G[br.nNovaDebug[i]]:Hide()
			end
		end
	elseif br.ui.window["healing"]["parent"] and br.data.settings[br.loader.selectedSpec]["healing"].active == true then
		br.ui:closeWindow("healing")
	end
end

-- if br.functions.misc:getOptionCheck("Rotation Log") then
-- 	if not br.ui.window['debug']['parent'] then br.ui:createDebugWindow() end
-- 	br.ui:showWindow("debug")
-- elseif br.ui.window['debug']['parent'] and br.data.settings[br.loader.selectedSpec]["debug"].active == true then
-- 	br.ui:closeWindow("debug")
-- end
