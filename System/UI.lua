
function BadBoyFrame()

    function UpdateButton(Name)
    	local Name = tostring(Name);
        _G["text"..Name]:SetText(_G[Name.."Modes"][BadBoy_data[Name]].mode); 
        if _G[Name.."Modes"][BadBoy_data[Name]].highlight == 0 then
            _G["button"..Name]:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]); 
        else
            _G["button"..Name]:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); 
        end
    end	

	function ToggleAoE()
		if BadBoy_data['AoE'] == 0 or BadBoy_data['AoE'] == nil then BadBoy_data['AoE'] = 1; end
		for i = 1, #AoEModes do
			if BadBoy_data['AoE'] == i then
	        	local function ResetTip()
	        		GameTooltip:SetOwner(mainButton, configFrame, 0 , 0);
					GameTooltip:SetText(AoEModes[BadBoy_data['AoE']].tip, 225/255, 225/255, 225/255, nil, true);
					GameTooltip:Show();
				end
				if #AoEModes > i then
		    		BadBoy_data['AoE'] = i+1;
	        		ChatOverlay("\124cFF3BB0FF"..AoEModes[i+1].overlay);	
	        		UpdateButton("AoE");
	        		ResetTip();
	        		break;
	        	else 
	        		BadBoy_data['AoE'] = 1;
	        		UpdateButton("AoE");
	        		ChatOverlay("\124cFF3BB0FF"..AoEModes[1].overlay);
	        		ResetTip();
	        	end
	        end
		end
	end
	---------------------------
	--     Basic Values      --
	---------------------------
	-- Base Modes
	if baseModes == nil then
		baseModes = { 
			[1] = { mode = "On", value = 1 , overlay = "Disabled", tip = "Option |cffFF0000Disabled." ,highlight = 0 },
			[2] = { mode = "Off", value = 2 , overlay = "Enables", tip = "Option |cff00FF00Enabled.",highlight = 1 },
		};
		baseModesLoaded = "Basic Modes";
	end
	-- Aoe Button
	if 	AoEModes == nil then 
		AoEModes = { 
			[1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "Recommended for one or two targets.", highlight = 0 },
			[2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "Recommended for three targets or more.", highlight = 0 },
            [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffFFDD11Recommended for \n|cffFFDD11Lazy people like me.", highlight = 1 }
		};
		AoEModesLoaded = "Basic AoE Modes";
	end
	-- Interrupts Button
	if 	InterruptsModes == nil then 
		InterruptsModes = { 
			[1] = { mode = "No", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.",highlight = 0 },
			[2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1 }
		};
		InterruptsModesLoaded = "Basic Interrupts Modes";
	end
	if BadBoy_data['Interrupts'] == nil then BadBoy_data['Interrupts'] = 1; end
	
	-- Defensive Button
	if 	DefensiveModes == nil then 
		DefensiveModes = { 
			[1] = { mode = "No", value = 1 , overlay = "Defensive Disabled", tip = "No cooldowns will be used." , highlight = 0 },
			[2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1 }
		};
		DefensiveModesLoaded = "Basic Defensive Modes";
	end
	if BadBoy_data['Defensive'] == nil then BadBoy_data['Defensive'] = 1; end
	-- Cooldowns Button
	if 	CooldownsModes == nil then 
		CooldownsModes = { 
           	[1] = { mode = "No", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffFF0000No cooldowns will be used.", highlight = 0 },
            [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Config's selected spells.", highlight = 1 },
            [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11None", highlight = 1 }
		};
		CooldownsModesLoaded = "Basic Cooldowns Modes";
	end
	if BadBoy_data['Cooldowns'] == nil then BadBoy_data['Cooldowns'] = 1; end
	-- Interrupts Button
	if InterruptsModes == nil then 
		InterruptsModes = { 
			[1] = { mode = "No", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0 },
			[2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1 }
		};
		InterruptsModesLoaded = "Basic Interrupts Modes";
	end
	if BadBoy_data['Interrupts'] == nil then BadBoy_data['Interrupts'] = 1; end
	---------------------------
	--     Main Frame UI     --
	---------------------------

	local buttonWidth = 32;
	local buttonHeight = 18;

	mainButton = CreateFrame("Button", "MyButton", configButton, "UIPanelButtonTemplate");
	mainButton:SetWidth(buttonWidth);
	mainButton:SetHeight(buttonHeight);
	mainButton:RegisterForClicks("AnyUp");
	mainButton:SetPoint(BadBoy_data.anchor,BadBoy_data.x,BadBoy_data.y);
	mainButton:EnableMouse(true);
	mainButton:SetMovable(true);
	mainButton:SetClampedToScreen(true);
	mainButton:RegisterForDrag("LeftButton");
	mainButton:SetScript("OnDragStart", mainButton.StartMoving);
	mainButton:SetScript("OnDragStop", mainButton.StopMovingOrSizing);
	--mainButton:SetScript("OnUpdate", mainFrame_OnUpdate);
	if BadBoy_data["Power"] == 1 then 
		mainButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); 
	else 
		mainButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]); 
	end
	mainButton:SetScript("OnClick", function()
		if BadBoy_data['Power'] ~= 0 then
			BadBoy_data['Power'] = 0;
			mainText:SetText("Off");
			GameTooltip:SetText("|cff00FF00Enable |cffFF0000BadBoy", 225/255, 225/255, 225/255);
			mainButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]); 
		else
			BadBoy_data['Power'] = 1;
			GameTooltip:SetText("|cffFF0000Disable BadBoy", 225/255, 225/255, 225/255);
			mainButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); 
			mainText:SetText("On");
		end
	end )
	mainButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(mainButton, 0 , 0);
		if BadBoy_data['Power'] == 1 then
			GameTooltip:SetText("|cffFF0000Disable BadBoy", 225/255, 225/255, 225/255);
		else
			GameTooltip:SetText("|cff00FF00Enable |cffFF0000BadBoy", 225/255, 225/255, 225/255);
		end
		GameTooltip:Show();
	end)
	mainButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
		local _, _, anchor, x, y = mainButton:GetPoint(1);
		BadBoy_data.x = x;
		BadBoy_data.y = y;
		BadBoy_data.anchor = anchor;
	end)

	mainText = mainButton:CreateFontString(nil, "OVERLAY");
	mainText:SetFont("Fonts/FRIZQT__.TTF",17,"THICKOUTLINE");
	mainText:SetTextHeight(9);
	mainText:SetPoint("CENTER",0,-1);
	mainText:SetTextColor(.90,.90,.90,1);
	if BadBoy_data['Power'] == 0 then
		BadBoy_data['Power'] = 0;
		mainText:SetText("Off");
		mainButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]); 
	else
		BadBoy_data['Power'] = 1;
		mainButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); 
		mainText:SetText("On");
	end

	-- /run CreateButton("AoE",2,2)
	function CreateButton(Name,x,y)
		_G["button"..Name] = CreateFrame("Button", "MyButton", mainButton, "UIPanelButtonTemplate");
		_G["button"..Name]:SetWidth(buttonWidth);
		_G["button"..Name]:SetHeight(buttonHeight);
		_G["button"..Name]:SetPoint("LEFT",x*(buttonWidth),y*(buttonHeight));
		_G["button"..Name]:RegisterForClicks("AnyUp");
		if BadBoy_data[tostring(Name)] == 1 then 
			_G["button"..Name]:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); 
		else 
			_G["button"..Name]:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]); 
		end		
		_G["text"..Name] = _G["button"..Name]:CreateFontString(nil, "OVERLAY");
		_G["text"..Name]:SetFont("Fonts/FRIZQT__.TTF",17,"THICKOUTLINE");
		_G["text"..Name]:SetTextHeight(9);
		_G["text"..Name]:SetPoint("CENTER",0,-1);
		_G["text"..Name]:SetTextColor(.90,.90,.90,1);	
		local modeTable;		
		if _G[Name.."Modes"] == nil then print("No table found for ".. Name); _G[Name.."Modes"] = tostring(Name); else _G[Name.."Modes"] = _G[Name.."Modes"] end
		local modeValue;
		if BadBoy_data[tostring(Name)] == nil then BadBoy_data[tostring(Name)] = 1; modeValue = 1 else modeValue = BadBoy_data[tostring(Name)] end
		_G["button"..Name]:SetScript("OnClick", function()
			if BadBoy_data[tostring(Name)] == 0 or BadBoy_data[tostring(Name)] == nil then BadBoy_data[tostring(Name)] = 1; end
			for i = 1, #_G[Name.."Modes"] do
				if BadBoy_data[tostring(Name)] == i then
		        	local function ResetTip()
		        		GameTooltip:SetOwner(_G["button"..Name], mainButton, 0 , 0);
						GameTooltip:SetText(_G[Name.."Modes"][BadBoy_data[tostring(Name)]].tip, 225/255, 225/255, 225/255, nil, true);
						GameTooltip:Show();
					end
					if #_G[Name.."Modes"] > i then
						newI = i + 1
			    		BadBoy_data[tostring(Name)] = newI;
						_G["text"..Name]:SetText(_G[Name.."Modes"][newI].mode); 	
						if _G[Name.."Modes"][newI].highlight == 0 then
							_G["button"..Name]:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]); 
						else
							_G["button"..Name]:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); 
						end

		        		ChatOverlay("\124cFF3BB0FF".._G[Name.."Modes"][newI].overlay);	
		        		ResetTip();
		        		break;
		        	else 
		        		BadBoy_data[tostring(Name)] = 1;
						_G["text"..Name]:SetText(_G[Name.."Modes"][1].mode); 	
						if _G[Name.."Modes"][1].highlight == 0 then
							_G["button"..Name]:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]); 
						else
							_G["button"..Name]:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); 
						end
		        		ChatOverlay("\124cFF3BB0FF".._G[Name.."Modes"][1].overlay);
		        		ResetTip();
		        	end
		        	break;
		        end
			end
		end )
		local actualTip = _G[Name.."Modes"][BadBoy_data[Name]].tip;
		_G["button"..Name]:SetScript("OnMouseWheel", function(self, delta)
			local Go = false;
			if delta < 0 and BadBoy_data[tostring(Name)] > 1 then
				Go = true;
			elseif delta > 0 and BadBoy_data[tostring(Name)] < #_G[Name.."Modes"] then
				Go = true;
			end
			if Go == true then
				BadBoy_data[tostring(Name)] = BadBoy_data[tostring(Name)] + delta
			end
		end)
		_G["button"..Name]:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(_G["button"..Name], UIParent, 0 , 0);
			GameTooltip:SetText(actualTip, 225/255, 225/255, 225/255, nil, true);
			GameTooltip:Show();
		end)
		_G["button"..Name]:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end)
		_G["text"..Name]:SetText(_G[Name.."Modes"][modeValue].mode); 	
		if _G[Name.."Modes"][modeValue].highlight == 0 then
			_G["button"..Name]:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]); 
		else
			_G["button"..Name]:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); 
		end
	end
end