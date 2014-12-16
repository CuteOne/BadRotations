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

    function GarbageButtons()
		for i = 1, #buttonsTable do
			local Name = buttonsTable[i].name
			_G["button"..Name]:Hide()
			_G["text"..Name]:Hide()
			_G["frame"..Name].texture:Hide()
			_G[Name.."Modes"] = nil
		end
	end

	function ToggleValue(toggleValue)
		-- prevent nil fails
		if BadBoy_data[tostring(toggleValue)] == nil then BadBoy_data[tostring(toggleValue)] = 1 end
		-- Scan Table and find wich mode = our i
		for i = 0, #_G[toggleValue.."Modes"] do
			if BadBoy_data[tostring(toggleValue)] == i then
				-- when we find a match, we reset tooltip
	        	local function ResetTip()
	        		GameTooltip:SetOwner(_G["button"..toggleValue], mainButton, 0 , 0)
					GameTooltip:SetText(_G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].tip, 225/255, 225/255, 225/255, nil, true)
					GameTooltip:Show()
				end
				local Icon;
				-- see if we can go higher in modes is #modes > i
				if #_G[toggleValue.."Modes"] > i then
					-- calculate newI
					newI = i + 1
					-- We set the value in DB
		    		BadBoy_data[tostring(toggleValue)] = newI
		    		-- We define the button text
					_G["text"..toggleValue]:SetText(_G[toggleValue.."Modes"][newI].mode)
					-- We define the icon
					if type(_G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].icon) == "number" then Icon = select(3,GetSpellInfo(_G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].icon)) else Icon = _G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].icon end
					_G["button"..toggleValue]:SetNormalTexture(Icon or emptyIcon)
					-- we set the highlight mode
					if _G[toggleValue.."Modes"][newI].highlight == 0 then
						_G["frame"..toggleValue].texture:SetTexture(genericIconOff)
					else
						_G["frame"..toggleValue].texture:SetTexture(genericIconOn)
					end
					-- We tell the user we changed mode
	        		ChatOverlay("\124cFF3BB0FF".._G[toggleValue.."Modes"][newI].overlay)
	        		-- We reset the tip
	        		ResetTip()
	        		break
	        	else
	        		-- if cannot go higher we define mode to 1.
	        		BadBoy_data[tostring(toggleValue)] = 1
	        		-- define text
					_G["text"..toggleValue]:SetText(_G[toggleValue.."Modes"][1].mode)
					-- define icon
					if type(_G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].icon) == "number" then Icon = select(3,GetSpellInfo(_G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].icon)) else Icon = _G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].icon end
					_G["button"..toggleValue]:SetNormalTexture(Icon or emptyIcon)
					-- define highlight
					if _G[toggleValue.."Modes"][1].highlight == 0 then
						_G["frame"..toggleValue].texture:SetTexture(genericIconOff)
					else
						_G["frame"..toggleValue].texture:SetTexture(genericIconOn)
					end
					-- We tell the user we changed mode
	        		ChatOverlay("\124cFF3BB0FF".._G[toggleValue.."Modes"][1].overlay)
	        		-- We reset the tip
	        		ResetTip()
	        	end
	        	-- we have our match so we exit that iteration
	        	break

	        end
		end
	end
	function ToggleMinus(toggleValue)
		-- prevent nil fails
		if BadBoy_data[tostring(toggleValue)] == nil then BadBoy_data[tostring(toggleValue)] = 1 end
		-- Scan Table and find wich mode = our i
		for i = 0, #_G[toggleValue.."Modes"] do
			if BadBoy_data[tostring(toggleValue)] == i then
				-- when we find a match, we reset tooltip
	        	local function ResetTip()
	        		GameTooltip:SetOwner(_G["button"..toggleValue], mainButton, 0 , 0)
					GameTooltip:SetText(_G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].tip, 225/255, 225/255, 225/255, nil, true)
					GameTooltip:Show()
				end
				local Icon
				-- see if we can go lower in modes
				if i > 1 then
					-- calculate newI
					newI = i - 1
					-- We set the value in DB
		    		BadBoy_data[tostring(toggleValue)] = newI
		    		-- We define the button text
					_G["text"..toggleValue]:SetText(_G[toggleValue.."Modes"][newI].mode)
					-- We define the icon
					if type(_G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].icon) == "number" then Icon = select(3,GetSpellInfo(_G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].icon)) else Icon = _G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].icon end
					_G["button"..toggleValue]:SetNormalTexture(Icon or emptyIcon)
					-- we set the highlight mode
					if _G[toggleValue.."Modes"][newI].highlight == 0 then
						_G["frame"..toggleValue].texture:SetTexture(genericIconOff)
					else
						_G["frame"..toggleValue].texture:SetTexture(genericIconOn)
					end
					-- We tell the user we changed mode
	        		ChatOverlay("\124cFF3BB0FF".._G[toggleValue.."Modes"][newI].overlay)
	        		-- We reset the tip
	        		ResetTip()
	        		break
	        	else
	        		-- if cannot go higher we define to last mode
	        		BadBoy_data[tostring(toggleValue)] = #_G[toggleValue.."Modes"]
	        		-- define text
					_G["text"..toggleValue]:SetText(_G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].mode)
					-- define icon
					if type(_G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].icon) == "number" then Icon = select(3,GetSpellInfo(_G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].icon)) else Icon = _G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].icon end
					_G["button"..toggleValue]:SetNormalTexture(Icon or emptyIcon)
					-- define highlight
					if _G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].highlight == 0 then
						_G["frame"..toggleValue].texture:SetTexture(genericIconOff)
					else
						_G["frame"..toggleValue].texture:SetTexture(genericIconOn)
					end
					-- We tell the user we changed mode
	        		ChatOverlay("\124cFF3BB0FF".._G[toggleValue.."Modes"][BadBoy_data[tostring(toggleValue)]].overlay)
	        		-- We reset the tip
	        		ResetTip()
	        	end
	        	-- we have our match so we exit that iteration
	        	break

	        end
		end
	end

	function UpdateButton(Name)
    	local Name = tostring(Name)
    	ToggleValue(Name)
    end

	---------------------------
	--     Main Frame UI     --
	---------------------------

	buttonSize = BadBoy_data["buttonSize"]
	buttonWidth = BadBoy_data["buttonSize"]
	buttonHeight = BadBoy_data["buttonSize"]

	mainButton = CreateFrame("Button","MyButton",UIParent,"SecureHandlerClickTemplate")
	mainButton:SetWidth(buttonWidth)
	mainButton:SetHeight(buttonHeight)
	mainButton:RegisterForClicks("AnyUp")
	local anchor,x,y
	if not BadBoy_data.BadBoyUI.mainButton then
		anchor = "CENTER"
		x = -75
		y = -200
	else
		anchor = BadBoy_data.BadBoyUI.mainButton.pos.anchor or "CENTER"
		x = BadBoy_data.BadBoyUI.mainButton.pos.x or -75
		y = BadBoy_data.BadBoyUI.mainButton.pos.y or -200
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
		if BadBoy_data['Power'] ~= 0 then
			BadBoy_data['Power'] = 0
			mainButton:SetNormalTexture(backIconOff)
			GameTooltip:SetText("|cff00FF00Enable |cffFF0000BadBoy \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.", 225/255, 225/255, 225/255)
			mainButtonFrame.texture:SetTexture(genericIconOff)
		else
			BadBoy_data['Power'] = 1
			GameTooltip:SetText("|cffFF0000Disable BadBoy \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.", 225/255, 225/255, 225/255)
			mainButton:SetNormalTexture(backIconOn)
			mainButtonFrame.texture:SetTexture(genericIconOn)
		end
	end )
	mainButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(mainButton, 0 , 0)
		if BadBoy_data['Power'] == 1 then
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
        BadBoy_data.BadBoyUI.mainButton.pos.x = x
        BadBoy_data.BadBoyUI.mainButton.pos.y = y
        BadBoy_data.BadBoyUI.mainButton.pos.anchor = anchor
    end)
	mainButton:SetScript("OnMouseWheel", function(self, delta)
		if IsLeftAltKeyDown() then
			local Go = false
			if delta < 0 and BadBoy_data["buttonSize"] > 1 then
				Go = true
			elseif delta > 0 and BadBoy_data["buttonSize"] < 50 then
				Go = true
			end
			if Go == true then
				BadBoy_data["buttonSize"] = BadBoy_data["buttonSize"] + delta
				mainButton:SetWidth(BadBoy_data["buttonSize"])
				mainButton:SetHeight(BadBoy_data["buttonSize"])
				mainText:SetTextHeight(BadBoy_data["buttonSize"]/3)
				mainText:SetPoint("CENTER",0,-(BadBoy_data["buttonSize"]/4))
				mainButtonFrame:SetWidth(BadBoy_data["buttonSize"]*1.67)
				mainButtonFrame:SetHeight(BadBoy_data["buttonSize"]*1.67)
				mainButtonFrame.texture:SetWidth(BadBoy_data["buttonSize"]*1.67)
				mainButtonFrame.texture:SetHeight(BadBoy_data["buttonSize"]*1.67)
				buttonsResize()
			end
		end
	end)

	function buttonsResize()
		for i = 1, #buttonsTable do
			local Name = buttonsTable[i].name
			local x = buttonsTable[i].bx
			local y = buttonsTable[i].by
			_G["button"..Name]:SetWidth(BadBoy_data["buttonSize"])
			_G["button"..Name]:SetHeight(BadBoy_data["buttonSize"])
			_G["button"..Name]:SetPoint("LEFT",x*(BadBoy_data["buttonSize"]),y*(BadBoy_data["buttonSize"]))
			_G["text"..Name]:SetTextHeight(BadBoy_data["buttonSize"]/3)
			_G["text"..Name]:SetPoint("CENTER",0,-(BadBoy_data["buttonSize"]/4))
			_G["frame"..Name]:SetWidth(BadBoy_data["buttonSize"]*1.67)
			_G["frame"..Name]:SetHeight(BadBoy_data["buttonSize"]*1.67)
			_G["frame"..Name].texture:SetWidth(BadBoy_data["buttonSize"]*1.67)
			_G["frame"..Name].texture:SetHeight(BadBoy_data["buttonSize"]*1.67)
		end
	end

	mainButtonFrame = CreateFrame("Frame", nil, mainButton)
	mainButtonFrame:SetWidth(BadBoy_data["buttonSize"]*1.67)
	mainButtonFrame:SetHeight(BadBoy_data["buttonSize"]*1.67)
	mainButtonFrame:SetPoint("CENTER")
	mainButtonFrame.texture = mainButtonFrame:CreateTexture(mainButton, "OVERLAY")
	mainButtonFrame.texture:SetAllPoints()
	mainButtonFrame.texture:SetWidth(BadBoy_data["buttonSize"]*1.67)
	mainButtonFrame.texture:SetHeight(BadBoy_data["buttonSize"]*1.67)
	mainButtonFrame.texture:SetAlpha(100)
	mainButtonFrame.texture:SetTexture(genericIconOn)

	mainText = mainButton:CreateFontString(nil, "OVERLAY")
	mainText:SetFont(BadBoy_data.BadBoyUI.font,BadBoy_data.BadBoyUI.fontsize,"THICKOUTLINE")
	mainText:SetTextHeight(BadBoy_data["buttonSize"]/3)
	mainText:SetPoint("CENTER",3,-(BadBoy_data["buttonSize"]/8))
	mainText:SetTextColor(.90,.90,.90,1)
	if BadBoy_data['Power'] == 0 then
		BadBoy_data['Power'] = 0
		mainText:SetText("Off")
		mainButtonFrame.texture:SetTexture(genericIconOff)
	else
		BadBoy_data['Power'] = 1
		mainText:SetText("On")
		mainButtonFrame.texture:SetTexture(genericIconOn)
	end

	buttonsTable = { }

	-- /run CreateButton("AoE",2,2)
	function CreateButton(Name,x,y)
		local Icon
		if BadBoy_data[Name] == nil or BadBoy_data[Name] > #_G[Name.."Modes"] then BadBoy_data[Name] = 1 end
		tinsert(buttonsTable, { name = Name, bx = x, by = y })
		_G["button"..Name] = CreateFrame("Button", "MyButton", mainButton, "SecureHandlerClickTemplate")
		_G["button"..Name]:SetWidth(BadBoy_data["buttonSize"])
		_G["button"..Name]:SetHeight(BadBoy_data["buttonSize"])
		_G["button"..Name]:SetPoint("LEFT",x*(BadBoy_data["buttonSize"])+(x*2),y*(BadBoy_data["buttonSize"])+(y*2))
		_G["button"..Name]:RegisterForClicks("AnyUp")
  		if _G[Name.."Modes"][BadBoy_data[Name]].icon ~= nil and type(_G[Name.."Modes"][BadBoy_data[Name]].icon) == "number" then
  			Icon = select(3,GetSpellInfo(_G[Name.."Modes"][BadBoy_data[Name]].icon))
  		else
  			Icon = _G[Name.."Modes"][BadBoy_data[Name]].icon
  		end
  		_G["button"..Name]:SetNormalTexture(Icon or emptyIcon)
		--CreateBorder(_G["button"..Name], 8, 0.6, 0.6, 0.6)
		_G["text"..Name] = _G["button"..Name]:CreateFontString(nil, "OVERLAY")
		_G["text"..Name]:SetFont(BadBoy_data.BadBoyUI.font,BadBoy_data.BadBoyUI.fontsize,"THICKOUTLINE")
		_G["text"..Name]:SetJustifyH("CENTER")
		_G["text"..Name]:SetTextHeight(BadBoy_data["buttonSize"]/3)
		_G["text"..Name]:SetPoint("CENTER",3,-(BadBoy_data["buttonSize"]/8))
		_G["text"..Name]:SetTextColor(1,1,1,1)
		_G["frame"..Name] = CreateFrame("Frame", nil, _G["button"..Name])
		_G["frame"..Name]:SetWidth(BadBoy_data["buttonSize"]*1.67)
		_G["frame"..Name]:SetHeight(BadBoy_data["buttonSize"]*1.67)
		_G["frame"..Name]:SetPoint("CENTER")
		_G["frame"..Name].texture = _G["frame"..Name]:CreateTexture(_G["button"..Name], "OVERLAY")
		_G["frame"..Name].texture:SetAllPoints()
		_G["frame"..Name].texture:SetWidth(BadBoy_data["buttonSize"]*1.67)
		_G["frame"..Name].texture:SetHeight(BadBoy_data["buttonSize"]*1.67)
		_G["frame"..Name].texture:SetAlpha(100)
		_G["frame"..Name].texture:SetTexture(genericIconOn)

		local modeTable
		if _G[Name.."Modes"] == nil then print("No table found for ".. Name); _G[Name.."Modes"] = tostring(Name) else _G[Name.."Modes"] = _G[Name.."Modes"] end
		local modeValue
		if BadBoy_data[tostring(Name)] == nil then BadBoy_data[tostring(Name)] = 1 modeValue = 1 else modeValue = BadBoy_data[tostring(Name)] end

		_G["button"..Name]:SetScript("OnClick", function(self, button)
			if button == "RightButton" then
				ToggleMinus(Name)
			else
				ToggleValue(Name)
			end
		end )
		local actualTip = _G[Name.."Modes"][BadBoy_data[Name]].tip
		_G["button"..Name]:SetScript("OnMouseWheel", function(self, delta)
			local Go = false
			if delta < 0 and BadBoy_data[tostring(Name)] > 1 then
				Go = true
			elseif delta > 0 and BadBoy_data[tostring(Name)] < #_G[Name.."Modes"] then
				Go = true
			end
			if Go == true then
				BadBoy_data[tostring(Name)] = BadBoy_data[tostring(Name)] + delta
			end
		end)
		_G["button"..Name]:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(_G["button"..Name], UIParent, 0 , 0)
			GameTooltip:SetText(_G[Name.."Modes"][BadBoy_data[Name]].tip, 225/255, 225/255, 225/255, nil, true)
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
        if BadBoy_data["Main"] == 1 then
            mainButton:Show()
        else
            mainButton:Hide()
        end
	end


end