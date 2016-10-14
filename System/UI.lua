-- this handles old profiles buttons
function BadBoyFrame()
	emptyIcon = [[Interface\FrameGeneral\UI-Background-Marble]]
	backIconOn = [[Interface\ICONS\Spell_Holy_PowerWordShield]]
	backIconOff = [[Interface\ICONS\SPELL_HOLY_DEVOTIONAURA]]
	genericIconOff = [[Interface\GLUES\CREDITS\Arakkoa1]]
	genericIconOn = [[Interface/BUTTONS/CheckButtonGlow]]
	-- function UpdateButton(Name)
	-- 	local Name = tostring(Name);
	-- 	_G["button"..Name]:Click("LeftButton", true)
	-- end
	-- when we find a match, we reset tooltip
	local function ResetTip(toggleValue,thisValue)
		GameTooltip:SetOwner(_G["button"..toggleValue], mainButton, 0 , 0)
		GameTooltip:SetText(_G[toggleValue.. "Modes"][thisValue].tip, 225/255, 225/255, 225/255, nil, true)
		GameTooltip:Show()
	end
	function GarbageButtons()
		if buttonsTable then
			for i = 1, #buttonsTable do
				local Name = buttonsTable[i].name
				_G["button"..Name]:Hide()
				_G["text"..Name]:Hide()
				_G["frame"..Name].texture:Hide()
				_G[Name.."Modes"] = nil
			end
		end
	end
	GarbageButtons()
	function ToggleValue(toggleValue)
		-- prevent nil fails
		local toggleOldValue = bb.data[tostring(toggleValue)] or 1
		local modesCount = #_G[toggleValue.."Modes"]
		if toggleOldValue == nil then
			bb.data[tostring(toggleValue)] = 1
			toggleOldValue = bb.data[tostring(toggleValue)]
		end
		-- Scan Table and find which mode = our i
		for i = 1,modesCount do
			if toggleOldValue == i then
				-- see if we can go higher in modes is #modes > i
				if modesCount > i then
					-- calculate newValue
					newValue = i + 1
					specialToggleCodes(toggleValue,newValue)
					-- We set the value in DB
					bb.data[tostring(toggleValue)] = newValue
					changeButton(toggleValue,newValue)
					-- We reset the tip
					ResetTip(toggleValue,newValue)
					break
				else
					specialToggleCodes(toggleValue,1)
					-- if cannot go higher we define mode to 1.
					bb.data[tostring(toggleValue)] = 1
					changeButton(toggleValue,1)
					-- We reset the tip
					ResetTip(toggleValue,1)
					break
				end
			end
		end
	end
	function ToggleMinus(toggleValue)
		-- prevent nil fails
		if bb.data[tostring(toggleValue)] == nil then
			bb.data[tostring(toggleValue)] = 1
		end
		local modesCount = #_G[toggleValue.."Modes"]
		-- Scan Table and find which mode = our i
		for i = 1,modesCount do
			local thisValue = bb.data[tostring(toggleValue)] or 1
			if thisValue == i then
				local Icon
				-- see if we can go lower in modes
				if i > 1 then
					-- calculate newValue
					newValue = i - 1
					specialToggleCodes(toggleValue,newValue)
					-- We set the value in DB
					bb.data[tostring(toggleValue)] = newValue
					-- change the button
					changeButton(toggleValue,newValue)
					-- We reset the tip
					ResetTip(toggleValue,newValue)
					break
				else
					-- if cannot go higher we define to last mode
					bb.data[tostring(toggleValue)] = modesCount
					specialToggleCodes(toggleValue,newValue)
					changeButton(toggleValue,newValue)
					-- We reset the tip
					ResetTip(toggleValue,newValue)
					break
				end
			end
		end
	end
	function specialToggleCodes(toggleValue,newValue)
		if toggleValue == "Interrupts" then
			local InterruptsModes = InterruptsModes
			if newValue == 1 and InterruptsModes[1].mode == "None" then
				-- no interupts mode
				if bb.data.options[bb.selectedSpec]["Interrupts HandlerCheck"] ~= 0 then
					_G["optionsInterrupts HandlerCheck"]:Click()
				end
			elseif newValue == 2 and InterruptsModes[2].mode == "Raid" then
				-- on/off switch
				if bb.data.options[bb.selectedSpec]["Interrupts HandlerCheck"] ~= 1 then
					_G["optionsInterrupts HandlerCheck"]:Click()
				end
				-- only known switch
				if bb.data.options[bb.selectedSpec]["Only Known UnitsCheck"] ~= 1 then
					_G["optionsOnly Known UnitsCheck"]:Click()
				end
				-- if we want to change drop down here is code.
				--[[if bb.data.options[bb.selectedSpec]["Interrupts HandlerDrop"] ~= 4 then

					-- _G[parent..value.."DropChild"]

            		local colorGreen = "|cff00FF00"

					_G["Interrupts Handler"..colorGreen.."AllDropChild"]:Click()

				end]]
			elseif newValue == 3 and InterruptsModes[3].mode == "All" then
				-- interrupt all mode
				-- on/off switch
				if bb.data.options[bb.selectedSpec]["Interrupts HandlerCheck"] ~= 1 then
					_G["optionsInterrupts HandlerCheck"]:Click()
				end
				-- only known switch
				if bb.data.options[bb.selectedSpec]["Only Known UnitsCheck"] ~= 0 then
					_G["optionsOnly Known UnitsCheck"]:Click()
				end
			end
		end
	end
	function changeButtonValue(toggleValue,newValue)
		bb.data[tostring(toggleValue)] = newValue
	end
	-- set to desired button value
	function changeButton(toggleValue,newValue)
		-- define text
		_G["text"..toggleValue]:SetText(_G[toggleValue.. "Modes"][newValue].mode)
		-- define icon
		if type(_G[toggleValue.. "Modes"][newValue].icon) == "number" then
			Icon = select(3,GetSpellInfo(_G[toggleValue.."Modes"][newValue].icon))
		else
			Icon = _G[toggleValue.."Modes"][newValue].icon
		end
		_G["button"..toggleValue]:SetNormalTexture(Icon or emptyIcon)
		-- define highlight
		if _G[toggleValue.."Modes"][newValue].highlight == 0 then
			_G["frame"..toggleValue].texture:SetTexture(genericIconOff)
		else
			_G["frame"..toggleValue].texture:SetTexture(genericIconOn)
		end
		-- We tell the user we changed mode
		ChatOverlay("\124cFF3BB0FF".._G[toggleValue.. "Modes"][newValue].overlay)
		-- We reset the tip
		ResetTip(toggleValue,newValue)
	end
	function UpdateButton(Name)
		local Name = tostring(Name)
		ToggleValue(Name)
	end
	---------------------------
	--     Main Frame UI     --
	---------------------------
	buttonSize = bb.data["buttonSize"]
	buttonWidth = bb.data["buttonSize"]
	buttonHeight = bb.data["buttonSize"]
	mainButton = CreateFrame("Button","MyButton",UIParent,"SecureHandlerClickTemplate")
	mainButton:SetWidth(buttonWidth)
	mainButton:SetHeight(buttonHeight)
	mainButton:RegisterForClicks("AnyUp")
	local anchor,x,y
	if not bb.data.BadBoyUI.mainButton then
		anchor = "CENTER"
		x = -75
		y = -200
	else
		anchor = bb.data.BadBoyUI.mainButton.pos.anchor or "CENTER"
		x = bb.data.BadBoyUI.mainButton.pos.x or -75
		y = bb.data.BadBoyUI.mainButton.pos.y or -200
	end
	mainButton:SetPoint(anchor,x,y)
	mainButton:EnableMouse(true)
	mainButton:SetMovable(true)
	mainButton:SetClampedToScreen(true)
	mainButton:RegisterForDrag("LeftButton")
	mainButton:SetScript("OnDragStart", mainButton.StartMoving)
	mainButton:SetScript("OnDragStop", mainButton.StopMovingOrSizing)
	--CreateBorder(mainButton, 8, 0.6, 0.6, 0.6)
	if getOptionCheck("Start/Stop BadBoy") then
		mainButton:SetNormalTexture(backIconOn)
	else
		mainButton:SetNormalTexture(backIconOff)
	end
	mainButton:SetScript("OnClick", function()
		if bb.data['Power'] ~= 0 then
			bb.data['Power'] = 0
			mainButton:SetNormalTexture(backIconOff)
			-- on/off switch
			-- if bb.selectedSpec == 5 then
			-- 	if bb.data.options[bb.selectedSpec][bb.selectedProfile]["Start/Stop BadBoyCheck"] ~= 0 then
			-- 		_G["optionsStart/Stop BadBoyCheck"]:Click()
			-- 	end
			-- else
				if bb.data.options[bb.selectedSpec]["Start/Stop BadBoyCheck"] ~= 0 then
					_G["optionsStart/Stop BadBoyCheck"]:Click()
				end
			-- end
			GameTooltip:SetText("|cff00FF00Enable |cffFF0000BadBoy \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.", 225/255, 225/255, 225/255)
			mainButtonFrame.texture:SetTexture(genericIconOff)
		else
			bb.data['Power'] = 1
			-- on/off switch
			-- if bb.selectedSpec == 5 then
			-- 	if bb.data.options[bb.selectedSpec][bb.selectedProfile]["Start/Stop BadBoyCheck"] ~= 1 then
			-- 		_G["optionsStart/Stop BadBoyCheck"]:Click()
			-- 	end
			-- else
				if bb.data.options[bb.selectedSpec]["Start/Stop BadBoyCheck"] ~= 1 then
					_G["optionsStart/Stop BadBoyCheck"]:Click()
				end
			-- end
			GameTooltip:SetText("|cffFF0000Disable BadBoy \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.", 225/255, 225/255, 225/255)
			mainButton:SetNormalTexture(backIconOn)
			mainButtonFrame.texture:SetTexture(genericIconOn)
		end
	end )
	mainButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(mainButton, 0 , 0)
		if bb.data['Power'] == 1 then
			GameTooltip:SetText("|cffFF0000Disable BadBoy \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.", 225/255, 225/255, 225/255)
		else
			GameTooltip:SetText("|cff00FF00Enable |cffFF0000BadBoy \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.", 225/255, 225/255, 225/255)
		end
		GameTooltip:Show()
	end)
	mainButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	mainButton:SetScript("OnReceiveDrag", function(self)
		local _, _, anchor, x, y = mainButton:GetPoint(1)
		bb.data.BadBoyUI.mainButton.pos.x = x
		bb.data.BadBoyUI.mainButton.pos.y = y
		bb.data.BadBoyUI.mainButton.pos.anchor = anchor
	end)
	mainButton:SetScript("OnMouseWheel", function(self, delta)
		if IsLeftAltKeyDown() then
			local Go = false
			if delta < 0 and bb.data["buttonSize"] > 1 then
				Go = true
			elseif delta > 0 and bb.data["buttonSize"] < 50 then
				Go = true
			end
			if Go == true then
				bb.data["buttonSize"] = bb.data["buttonSize"] + delta
				mainButton:SetWidth(bb.data["buttonSize"])
				mainButton:SetHeight(bb.data["buttonSize"])
				mainText:SetTextHeight(bb.data["buttonSize"]/3)
				mainText:SetPoint("CENTER",0,-(bb.data["buttonSize"]/4))
				mainButtonFrame:SetWidth(bb.data["buttonSize"]*1.67)
				mainButtonFrame:SetHeight(bb.data["buttonSize"]*1.67)
				mainButtonFrame.texture:SetWidth(bb.data["buttonSize"]*1.67)
				mainButtonFrame.texture:SetHeight(bb.data["buttonSize"]*1.67)
				buttonsResize()
			end
		end
	end)
	function buttonsResize()
		for i = 1, #buttonsTable do
			local Name = buttonsTable[i].name
			local x = buttonsTable[i].bx
			local y = buttonsTable[i].by
			_G["button"..Name]:SetWidth(bb.data["buttonSize"])
			_G["button"..Name]:SetHeight(bb.data["buttonSize"])
			_G["button"..Name]:SetPoint("LEFT",x*(bb.data["buttonSize"]),y*(bb.data["buttonSize"]))
			_G["text"..Name]:SetTextHeight(bb.data["buttonSize"]/3)
			_G["text"..Name]:SetPoint("CENTER",0,-(bb.data["buttonSize"]/4))
			_G["frame"..Name]:SetWidth(bb.data["buttonSize"]*1.67)
			_G["frame"..Name]:SetHeight(bb.data["buttonSize"]*1.67)
			_G["frame"..Name].texture:SetWidth(bb.data["buttonSize"]*1.67)
			_G["frame"..Name].texture:SetHeight(bb.data["buttonSize"]*1.67)
		end
	end
	mainButtonFrame = CreateFrame("Frame", nil, mainButton)
	mainButtonFrame:SetWidth(bb.data["buttonSize"]*1.67)
	mainButtonFrame:SetHeight(bb.data["buttonSize"]*1.67)
	mainButtonFrame:SetPoint("CENTER")
	mainButtonFrame.texture = mainButtonFrame:CreateTexture(mainButton, "OVERLAY")
	mainButtonFrame.texture:SetAllPoints()
	mainButtonFrame.texture:SetWidth(bb.data["buttonSize"]*1.67)
	mainButtonFrame.texture:SetHeight(bb.data["buttonSize"]*1.67)
	mainButtonFrame.texture:SetAlpha(100)
	mainButtonFrame.texture:SetTexture(genericIconOn)
	mainText = mainButton:CreateFontString(nil, "OVERLAY")
	mainText:SetFont(bb.data.BadBoyUI.font,bb.data.BadBoyUI.fontsize,"THICKOUTLINE")
	mainText:SetTextHeight(bb.data["buttonSize"]/3)
	mainText:SetPoint("CENTER",3,-(bb.data["buttonSize"]/8))
	mainText:SetTextColor(.90,.90,.90,1)
	if bb.data['Power'] == 0 then
		bb.data['Power'] = 0
		mainText:SetText("Off")
		mainButtonFrame.texture:SetTexture(genericIconOff)
	else
		bb.data['Power'] = 1
		mainText:SetText("On")
		mainButtonFrame.texture:SetTexture(genericIconOn)
	end
	buttonsTable = { }
	-- /run CreateButton("AoE",2,2)
	function CreateButton(Name,x,y)
		local Icon
        -- todo: extend to use spec + profile specific variable; ATM it shares between profile AND spec, -> global for char
		if bb.data[Name] == nil or bb.data[Name] > #_G[Name.."Modes"] then bb.data[Name] = 1 end
		tinsert(buttonsTable, { name = Name, bx = x, by = y })
		_G["button"..Name] = CreateFrame("Button", "MyButton", mainButton, "SecureHandlerClickTemplate")
		_G["button"..Name]:SetWidth(bb.data["buttonSize"])
		_G["button"..Name]:SetHeight(bb.data["buttonSize"])
		_G["button"..Name]:SetPoint("LEFT",x*(bb.data["buttonSize"])+(x*2),y*(bb.data["buttonSize"])+(y*2))
		_G["button"..Name]:RegisterForClicks("AnyUp")
		if _G[Name.."Modes"][bb.data[Name]].icon ~= nil and type(_G[Name.."Modes"][bb.data[Name]].icon) == "number" then
			Icon = select(3,GetSpellInfo(_G[Name.."Modes"][bb.data[Name]].icon))
		else
			Icon = _G[Name.."Modes"][bb.data[Name]].icon
		end
		_G["button"..Name]:SetNormalTexture(Icon or emptyIcon)
		--CreateBorder(_G["button"..Name], 8, 0.6, 0.6, 0.6)
		_G["text"..Name] = _G["button"..Name]:CreateFontString(nil, "OVERLAY")
		_G["text"..Name]:SetFont(bb.data.BadBoyUI.font,bb.data.BadBoyUI.fontsize,"THICKOUTLINE")
		_G["text"..Name]:SetJustifyH("CENTER")
		_G["text"..Name]:SetTextHeight(bb.data["buttonSize"]/3)
		_G["text"..Name]:SetPoint("CENTER",3,-(bb.data["buttonSize"]/8))
		_G["text"..Name]:SetTextColor(1,1,1,1)
		_G["frame"..Name] = CreateFrame("Frame", nil, _G["button"..Name])
		_G["frame"..Name]:SetWidth(bb.data["buttonSize"]*1.67)
		_G["frame"..Name]:SetHeight(bb.data["buttonSize"]*1.67)
		_G["frame"..Name]:SetPoint("CENTER")
		_G["frame"..Name].texture = _G["frame"..Name]:CreateTexture(_G["button"..Name], "OVERLAY")
		_G["frame"..Name].texture:SetAllPoints()
		_G["frame"..Name].texture:SetWidth(bb.data["buttonSize"]*1.67)
		_G["frame"..Name].texture:SetHeight(bb.data["buttonSize"]*1.67)
		_G["frame"..Name].texture:SetAlpha(100)
		_G["frame"..Name].texture:SetTexture(genericIconOn)
		local modeTable
		if _G[Name.."Modes"] == nil then print("No table found for ".. Name); _G[Name.."Modes"] = tostring(Name) else _G[Name.."Modes"] = _G[Name.."Modes"] end
		local modeValue
		if bb.data[tostring(Name)] == nil then bb.data[tostring(Name)] = 1 modeValue = 1 else modeValue = bb.data[tostring(Name)] end
		_G["button"..Name]:SetScript("OnClick", function(self, button)
			if button == "RightButton" then
				ToggleMinus(Name)
			else
				ToggleValue(Name)
			end
		end )
		local actualTip = _G[Name.."Modes"][bb.data[Name]].tip
		_G["button"..Name]:SetScript("OnMouseWheel", function(self, delta)
			local Go = false
			if delta < 0 and bb.data[tostring(Name)] > 1 then
				Go = true
			elseif delta > 0 and bb.data[tostring(Name)] < #_G[Name.."Modes"] then
				Go = true
			end
			if Go == true then
				bb.data[tostring(Name)] = bb.data[tostring(Name)] + delta
			end
		end)
		_G["button"..Name]:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(_G["button"..Name], UIParent, 0 , 0)
			GameTooltip:SetText(_G[Name.."Modes"][bb.data[Name]].tip, 225/255, 225/255, 225/255, nil, true)
			GameTooltip:Show()
		end)
		_G["button"..Name]:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
		_G["text"..Name]:SetText(_G[Name.."Modes"][modeValue].mode)
		if _G[Name.."Modes"][modeValue].highlight == 0 then
			_G["frame"..Name].texture:SetTexture(genericIconOff)
		else
			_G["frame"..Name].texture:SetTexture(genericIconOn)
		end
		if bb.data["Main"] == 1 then
			mainButton:Show()
		else
			mainButton:Hide()
		end
		-- Create button slash command

		_G["SLASH_" .. Name .. "1"] = "/"..Name
		SlashCmdList[Name] = function(msg, editbox)
			ToggleValue(Name)
		end
		SlashCommandHelp(Name,"Toggles "..Name.." Modes.")
	end
end
