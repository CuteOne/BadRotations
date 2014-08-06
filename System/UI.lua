function BadBoyEngine()
	-- Hidden Frame
	if Pulse_Engine == nil then 
		Pulse_Engine = CreateFrame("Frame", nil, UIParent);
		Pulse_Engine:SetScript("OnUpdate", FrameUpdate);
		Pulse_Engine:SetPoint("TOPLEFT",0,0);
		Pulse_Engine:SetHeight(1);
		Pulse_Engine:SetWidth(1);
		Pulse_Engine:Show();
	end
end


function BadBoyMinimapButton()

	local dragMode = nil --"free", nil
	
	local function moveButton(self)
		local centerX, centerY = Minimap:GetCenter()
		local x, y = GetCursorPosition()
		x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
		centerX, centerY = math.abs(x), math.abs(y)
		centerX, centerY = (centerX / math.sqrt(centerX^2 + centerY^2)) * 76, (centerY / sqrt(centerX^2 + centerY^2)) * 76
		centerX = x < 0 and -centerX or centerX
		centerY = y < 0 and -centerY or centerY
		self:ClearAllPoints()
		self:SetPoint("CENTER", centerX, centerY)
	end

	local button = CreateFrame("Button", "BadBoyButton", Minimap)
	button:SetHeight(25)
	button:SetWidth(25)
	button:SetFrameStrata("MEDIUM")
	button:SetPoint("CENTER", 75.70,-6.63)
	button:SetMovable(true)
	button:SetUserPlaced(true)
	button:SetNormalTexture("Interface\\HelpFrame\\HotIssueIcon.blp")
	button:SetPushedTexture("Interface\\HelpFrame\\HotIssueIcon.blp")
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-Background.blp")

	button:SetScript("OnMouseDown", function(self, button)
		if IsShiftKeyDown() and IsAltKeyDown() then
			self:SetScript("OnUpdate", moveButton)
		end
	end)
	button:SetScript("OnMouseUp", function(self)
		self:SetScript("OnUpdate", nil)
	end)
	button:SetScript("OnClick", function(self, button)
		if button == "LeftButton" then 
			if IsShiftKeyDown() and not IsAltKeyDown() then 
				if BadBoy_data.frameShown == false then
					BadBoy_data.frameShown = true;
				else
					BadBoy_data.frameShown = false;
				end
			elseif not IsShiftKeyDown() and not IsAltKeyDown() then 
				if BadBoy_data.configShown == false then
					configFrame:Show();
					BadBoy_data.configShown = true;
				else
					configFrame:Hide();
					BadBoy_data.configShown = false;
				end
			end
		end	
	end)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50);
		GameTooltip:SetText("BadBoy Ultimate Raiding Routine", 214/255, 25/255, 25/255);
		GameTooltip:AddLine("By CodeMyLife and CuteOne ");
		GameTooltip:AddLine("Left Click to toggle config frame", 1, 1, 1, 1);
		GameTooltip:AddLine("Shift+Left Click to toggle main frame", 1, 1, 1, 1);
		GameTooltip:AddLine("Alt+Shift+LeftButton to drag", 1, 1, 1, 1);
		GameTooltip:Show();
	end)
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end)

end


--[HEALTH BAR] (Master Button)
--[POWER BAR] (Config Button)
--| Cooldowns      |         AoE | Defensive | Interrupts | Custom1 | Custom2 | ect...
--| (CD Button)    | (Aoe Button)| etc..

function BadBoyFrame()

	function ToggleAoE()
		if BadBoy_data['AoE'] == 0 or BadBoy_data['AoE'] == nil then BadBoy_data['AoE'] = 1; end
		for i = 1, #AoEModes do
			if BadBoy_data['AoE'] == i then
	        	local function ResetTip()
	        		GameTooltip:SetOwner(aoeButton, configFrame, 0 , 0);
					GameTooltip:SetText(AoEModes[BadBoy_data['AoE']].tip, 225/255, 225/255, 225/255, nil, true);
					GameTooltip:Show();
				end
				if #AoEModes > i then
		    		BadBoy_data['AoE'] = i+1;
	        		ChatOverlay("\124cFF3BB0FF"..AoEModes[i+1].overlay);	
	        		ResetTip();
	        		break;
	        	else 
	        		BadBoy_data['AoE'] = 1;
	        		ChatOverlay("\124cFF3BB0FF"..AoEModes[1].overlay);
	        		ResetTip();
	        	end
	        end
		end
	end

	---------------------------
	--     Basic Values      --
	---------------------------
	-- Aoe Button
	if 	AoEModes == nil then 
		AoEModes = { 
			[1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "Recommended for one or two targets." },
			[2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "Recommended for three targets or more." }
		};
		AoEModesLoaded = "Basic AoE Modes";
	end
	-- Interrupts Button
	if 	InterruptsModes == nil then 
		InterruptsModes = { 
			[1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
			[2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts." }
		};
		InterruptsModesLoaded = "Basic Interrupts Modes";
	end
	if BadBoy_data['Interrupts'] == nil then BadBoy_data['Interrupts'] = 1; end
	
	-- Defensive Button
	if 	DefensiveModes == nil then 
		DefensiveModes = { 
			[1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No cooldowns will be used." },
			[2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." }
		};
		DefensiveModesLoaded = "Basic Defensive Modes";
	end
	if BadBoy_data['Defensive'] == nil then BadBoy_data['Defensive'] = 1; end
	-- Cooldowns Button
	if 	CooldownsModes == nil then 
		CooldownsModes = { 
			[1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used." },
			[2] = { mode = "All", value = 2 , overlay = "Cooldowns Enabled", tip = "Includes Rapid Fire, Bestial Wrath and Focus Fire." }
		};
		CooldownsModesLoaded = "Basic Cooldowns Modes";
	end
	if BadBoy_data['Cooldowns'] == nil then BadBoy_data['Cooldowns'] = 1; end

	---------------------------
	--     Main Frame UI     --
	---------------------------
	-- Energy Bar
	mainFrame = CreateFrame("StatusBar", nil, UIParent);
	mainFrame:SetStatusBarTexture([[Interface\GLUES\MODELS\UI_Goblin\UI_Goblin_sky]],"ARTWORK");
	mainFrame:SetOrientation("HORIZONTAL");
	mainFrame:SetBackdropColor(1,1,1,1);
	mainFrame:GetStatusBarTexture():SetTexture([[Interface\GLUES\MODELS\UI_Goblin\UI_Goblin_sky]], "ARTWORK");
	mainFrame:SetMinMaxValues(0, 100);
	mainFrame:SetAlpha(1);
	mainFrame:SetValue(100);
	mainFrame:SetWidth(160);
	mainFrame:SetHeight(21);

	mainFrame:SetPoint(BadBoy_data.anchor,BadBoy_data.x,BadBoy_data.y);
	mainFrame:SetClampedToScreen(true);
	mainFrame:SetScript("OnUpdate", mainFrame_OnUpdate);
	mainFrame:EnableMouse(true);
	mainFrame:SetMovable(true);
	mainFrame:SetClampedToScreen(true);
	mainFrame:RegisterForDrag("LeftButton");
	mainFrame:SetScript("OnDragStart", mainFrame.StartMoving);
	mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing);

	bartext = mainFrame:CreateFontString(nil, "OVERLAY");
	mainFrame.Text = bartext;
	mainFrame.Text:SetFontObject("MovieSubtitleFont");
	mainFrame.Text:SetTextHeight(15);
	mainFrame.Text:SetPoint("CENTER",0,1);
	mainFrame.Text:SetTextColor(255/255, 255/255, 255/255,1);

	border = mainFrame:CreateTexture(nil, "OVERLAY");
	mainFrame.Border = border;
	mainFrame.Border:SetPoint("CENTER",0,0);
	mainFrame.Border:SetWidth(205);
	mainFrame.Border:SetHeight(39);

	--Health Frame
	healthFrame = CreateFrame("StatusBar", nil, mainFrame);
	healthFrame:SetBackdrop({ bgFile = [[Interface\Common\ShadowOverlay-Corner]], tile = false, tileSize = 16 });
	healthFrame:SetStatusBarTexture([[Interface\Buttons\GREENGRAD64]],"OVERLAY");
	healthFrame:SetOrientation("HORIZONTAL");
	healthFrame:SetFrameStrata("BACKGROUND")
	healthFrame:SetBackdropColor(1, 1, 1,1);
	healthFrame:GetStatusBarTexture():SetTexture([[Interface\Buttons\GREENGRAD64]],"OVERLAY");
	healthFrame:SetStatusBarColor(1,1,1,1);
	healthFrame:SetAlpha(1);
	healthFrame:SetMinMaxValues(0, 100);
	healthFrame:SetWidth(160);
	healthFrame:SetHeight(21);
	healthFrame:SetValue(100);
	healthFrame.texture = healthFrame:CreateTexture();
	healthFrame.texture:SetAllPoints()
	healthFrame.texture:SetTexture(25/255,25/255,25/255,1);
	healthFrame:SetPoint("LEFT",0,27);
	healthFrame:SetClampedToScreen(true);
	healthFrame:SetScript("OnUpdate", healthFrame_OnUpdate);

	border = healthFrame:CreateTexture(nil, "BACKGROUND");
	healthFrame.Border = border;
	healthFrame.Border:SetPoint("BOTTOMLEFT",-5,-57);
	healthFrame.Border:SetWidth(217);
	healthFrame.Border:SetHeight(85);
	healthFrame.Border:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]],0.25);

	healthbartext = healthFrame:CreateFontString(nil, "OVERLAY");
	healthFrame.healthbartext = healthbartext;
	healthFrame.healthbartext:SetFontObject("MovieSubtitleFont");
	healthFrame.healthbartext:SetTextHeight(14);
	healthFrame.healthbartext:SetPoint("LEFT",1,1);
	healthFrame.healthbartext:SetTextColor(1,1,1,1);

	healthbarnumbers = healthFrame:CreateFontString(nil, "OVERLAY");
	healthFrame.healthbarnumbers = healthbarnumbers;
	healthFrame.healthbarnumbers:SetFontObject("MovieSubtitleFont");
	healthFrame.healthbarnumbers:SetTextHeight(13);
	healthFrame.healthbarnumbers:SetPoint("RIGHT",-3,1);
	healthFrame.healthbarnumbers:SetTextColor(1,1,1,1);

	-- Power Button
	powerButton = CreateFrame("Button", "MyButton", mainFrame, "UIPanelButtonTemplate");
	powerButton:SetWidth(42);
	powerButton:SetHeight(23);
	powerButton:SetPoint("TOPLEFT", 165,29);
	powerButton:RegisterForClicks("AnyUp");
	powerButton:SetScript("OnClick", function()
		SlashCmdList.Power();
	end )
	powerButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(powerButton, configFrame, 0 , 0);
		GameTooltip:SetText("Toggles BadBoy On/Off", 225/255, 225/255, 225/255);
		GameTooltip:Show();
	end)
	powerButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end)

	powerText = powerButton:CreateFontString(nil, "OVERLAY");
	powerText:SetFontObject("QuestTitleFont");
	powerText:SetTextHeight(15);
	powerText:SetPoint("CENTER",0,0);
	powerText:SetTextColor(.90,.90,.90,1);

	-- Config Button
	configButton = CreateFrame("CheckButton", "MyButton", mainFrame, "UIPanelButtonTemplate");
	configButton:SetWidth(42);
	configButton:SetHeight(23);
	configButton:SetPoint("TOPLEFT",165,2);
	configButton:RegisterForClicks("AnyUp");
	configButton:SetScript("OnClick", function()
		if BadBoy_data.configShown == false then
			BadBoy_data.configShown = true;
			if configFrame:IsShown() == nil then configFrame:Show(); end
			if configButton:GetNormalTexture() ~= [[Interface\BUTTONS\CheckButtonHilight]] then configButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); end

		else
			BadBoy_data.configShown = false;
			if configFrame:IsShown() == 1 then configFrame:Hide(); end
			if configButton:GetNormalTexture() ~=[[Interface\BUTTONS\ButtonHilight-SquareQuickslot]] then configButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]); end
		end
	end )
	configButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(configButton, configFrame, 0 , 0);
		GameTooltip:SetText("Show/Hide Config", 225/255, 225/255, 225/255, nil, true);
		GameTooltip:Show();
	end)
	configButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end)
	configText = configButton:CreateFontString(nil, "OVERLAY");
	configText:SetFontObject("QuestTitleFont");
	configText:SetTextHeight(15);
	configText:SetPoint("CENTER",0,-1);
	configText:SetTextColor(.90,.90,.90,1);
	configText:SetText("Cfg");

	aoeButton = CreateFrame("Button", "MyButton", mainFrame, "UIPanelButtonTemplate");
	aoeButton:SetWidth(51);
	aoeButton:SetHeight(23);
	aoeButton:SetPoint("LEFT",0,-26);
	aoeButton:RegisterForClicks("AnyUp");
	aoeText = aoeButton:CreateFontString(nil, "OVERLAY");
	aoeText:SetFontObject("QuestTitleFont");
	aoeText:SetTextHeight(15);
	aoeText:SetPoint("CENTER",0,0);
	aoeText:SetTextColor(.90,.90,.90,1);				
	aoeButton:SetScript("OnClick", function()
		ToggleAoE();
	end )
	aoeButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(aoeButton, configFrame, 0 , 0);
		GameTooltip:SetText(AoEModes[BadBoy_data['AoE']].tip, 225/255, 225/255, 225/255, nil, true);
		GameTooltip:Show();
	end)
	aoeButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end)
	aoeButton:SetScript("OnMouseWheel", function(self, delta)
		local Go = false;
		if delta < 0 and BadBoy_data['AoE'] > 1 then
			Go = true;
		elseif delta > 0 and BadBoy_data['AoE'] < #AoEModes then
			Go = true;
		end
		if Go == true then
			BadBoy_data['AoE'] = BadBoy_data['AoE'] + delta
		end
	end)

	cooldownsButton = CreateFrame("Button", "MyButton", mainFrame, "UIPanelButtonTemplate");
	cooldownsButton:SetWidth(51);
	cooldownsButton:SetHeight(23);
	cooldownsButton:SetPoint("LEFT",53,-26);
	cooldownsButton:RegisterForClicks("AnyUp");
	cooldownsText = cooldownsButton:CreateFontString(nil, "OVERLAY");
	cooldownsText:SetFontObject("QuestTitleFont");
	cooldownsText:SetTextHeight(15);
	cooldownsText:SetPoint("CENTER",0,0);
	cooldownsText:SetTextColor(.90,.90,.90,1);				
	cooldownsButton:SetScript("OnClick", function()
		if BadBoy_data['Cooldowns'] == 0 or BadBoy_data['Cooldowns'] == nil then BadBoy_data['Cooldowns'] = 1; end
		for i = 1, #CooldownsModes do
			if BadBoy_data['Cooldowns'] == i then
	        	local function ResetTip()
	        		GameTooltip:SetOwner(cooldownsButton, configFrame, 0 , 0);
					GameTooltip:SetText(CooldownsModes[BadBoy_data['Cooldowns']].tip, 225/255, 225/255, 225/255, nil, true);
					GameTooltip:Show();
				end
				if #CooldownsModes > i then
		    		BadBoy_data['Cooldowns'] = i+1;
	        		ChatOverlay("\124cFF3BB0FF"..CooldownsModes[i+1].overlay);	
	        		ResetTip();
	        		break;
	        	else 
	        		BadBoy_data['Cooldowns'] = 1;
	        		ChatOverlay("\124cFF3BB0FF"..CooldownsModes[1].overlay);
	        		ResetTip();
	        	end
	        end
		end
	end )
	cooldownsButton:SetScript("OnMouseWheel", function(self, delta)
		local Go = false;
		if delta < 0 and BadBoy_data['Cooldowns'] > 1 then
			Go = true;
		elseif delta > 0 and BadBoy_data['Cooldowns'] < #CooldownsModes then
			Go = true;
		end
		if Go == true then
			BadBoy_data['Cooldowns'] = BadBoy_data['Cooldowns'] + delta
		end
	end)
	cooldownsButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(cooldownsButton, configFrame, 0 , 0);
		GameTooltip:SetText(CooldownsModes[BadBoy_data['Cooldowns']].tip, 225/255, 225/255, 225/255, nil, true);
		GameTooltip:Show();
	end)
	cooldownsButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end)


	-- Defensive Button
	if 	DefensiveModes == nil then 
		DefensiveModes = { 
			[1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No cooldowns will be used." },
			[2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." }
		};
		DefensiveModesLoaded = "Basic Defensive Modes";
	end
	if BadBoy_data['Defensive'] == nil then BadBoy_data['Defensive'] = 1; end

	defensiveButton = CreateFrame("Button", "MyButton", mainFrame, "UIPanelButtonTemplate");
	defensiveButton:SetWidth(51);
	defensiveButton:SetHeight(23);
	defensiveButton:SetPoint("LEFT",105,-26);
	defensiveButton:RegisterForClicks("AnyUp");
	defensiveText = defensiveButton:CreateFontString(nil, "OVERLAY");
	defensiveText:SetFontObject("QuestTitleFont");
	defensiveText:SetTextHeight(15);
	defensiveText:SetPoint("CENTER",0,0);
	defensiveText:SetTextColor(.90,.90,.90,1);				
	defensiveButton:SetScript("OnClick", function()
		if BadBoy_data['Defensive'] == 0 or BadBoy_data['Defensive'] == nil then BadBoy_data['Defensive'] = 1; end
		for i = 1, #DefensiveModes do
			if BadBoy_data['Defensive'] == i then
	        	local function ResetTip()
	        		GameTooltip:SetOwner(defensiveButton, configFrame, 0 , 0);
					GameTooltip:SetText(DefensiveModes[BadBoy_data['Defensive']].tip, 225/255, 225/255, 225/255, nil, true);
					GameTooltip:Show();
				end
				if #DefensiveModes > i then
		    		BadBoy_data['Defensive'] = i+1;
	        		ChatOverlay("\124cFF3BB0FF"..DefensiveModes[i+1].overlay);	
	        		ResetTip();
	        		break;
	        	else 
	        		BadBoy_data['Defensive'] = 1;
	        		ChatOverlay("\124cFF3BB0FF"..DefensiveModes[1].overlay);
	        		ResetTip();
	        	end
	        end
		end
	end )

	defensiveButton:SetScript("OnMouseWheel", function(self, delta)
		local Go = false;
		if delta < 0 and BadBoy_data['Defensive'] > 1 then
			Go = true;
		elseif delta > 0 and BadBoy_data['Defensive'] < #DefensiveModes then
			Go = true;
		end
		if Go == true then
			BadBoy_data['Defensive'] = BadBoy_data['Defensive'] + delta
		end
	end)
	defensiveButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(defensiveButton, configFrame, 0 , 0);
		GameTooltip:SetText(DefensiveModes[BadBoy_data['Defensive']].tip, 225/255, 225/255, 225/255, nil, true);
		GameTooltip:Show();
	end)
	defensiveButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end)



	-- Interrupts Button
	if 	InterruptsModes == nil then 
		InterruptsModes = { 
			[1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
			[2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts." }
		};
		InterruptsModesLoaded = "Basic Interrupts Modes";
	end
	if BadBoy_data['Interrupts'] == nil then BadBoy_data['Interrupts'] = 1; end

	interruptsButton = CreateFrame("Button", "MyButton", mainFrame, "UIPanelButtonTemplate");
	interruptsButton:SetWidth(51);
	interruptsButton:SetHeight(23);
	interruptsButton:SetPoint("LEFT",157,-26);
	interruptsButton:RegisterForClicks("AnyUp");
	interruptsText = interruptsButton:CreateFontString(nil, "OVERLAY");
	interruptsText:SetFontObject("QuestTitleFont");
	interruptsText:SetTextHeight(15);
	interruptsText:SetPoint("CENTER",0,0);
	interruptsText:SetTextColor(.90,.90,.90,1);				
	interruptsButton:SetScript("OnClick", function()
		if BadBoy_data['Interrupts'] == 0 or BadBoy_data['Interrupts'] == nil then BadBoy_data['Interrupts'] = 1; end
		for i = 1, #InterruptsModes do
			if BadBoy_data['Interrupts'] == i then
	        	local function ResetTip()
	        		GameTooltip:SetOwner(interruptsButton, configFrame, 0 , 0);
					GameTooltip:SetText(InterruptsModes[BadBoy_data['Interrupts']].tip, 225/255, 225/255, 225/255, nil, true);
					GameTooltip:Show();
				end
				if #InterruptsModes > i then
		    		BadBoy_data['Interrupts'] = i+1;
	        		ChatOverlay("\124cFF3BB0FF"..InterruptsModes[i+1].overlay);	
	        		ResetTip();
	        		break;
	        	else 
	        		BadBoy_data['Interrupts'] = 1;
	        		ChatOverlay("\124cFF3BB0FF"..InterruptsModes[1].overlay);
	        		ResetTip();
	        	end
	        end
		end
	end )
	interruptsButton:SetScript("OnMouseWheel", function(self, delta)
		local Go = false;
		if delta < 0 and BadBoy_data['Interrupts'] > 1 then
			Go = true;
		elseif delta > 0 and BadBoy_data['Interrupts'] < #InterruptsModes then
			Go = true;
		end
		if Go == true then
			BadBoy_data['Interrupts'] = BadBoy_data['Interrupts'] + delta
		end
	end)
	interruptsButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(interruptsButton, configFrame, 0 , 0);
		GameTooltip:SetText(InterruptsModes[BadBoy_data['Interrupts']].tip, 225/255, 225/255, 225/255, nil, true);
		GameTooltip:Show();
	end)
	interruptsButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end)
end












--[[                                          
										Pulse
]]
function UIUpdate()

	if BadBoy_data.frameShown == false then
		if mainFrame:IsShown() == 1 then
			mainFrame:Hide();
		end
	elseif BadBoy_data.frameShown == true then
		if mainFrame:IsShown() ~= 1 then
			mainFrame:Show();
		end
	end

	if BadBoy_data["Power"] ~= 1 and AoEModesLoaded == nil then
		configFrameText:SetText("BadBoy Disabled", 1, 0, 0, 1);
	elseif AoEModesLoaded == nil then
		configFrameText:SetText("No Rotation Enabled", 1, 1, 1, 0.7);
	else
		configFrameText:SetText("", 1, 1, 1, 0.7);
	end

	if BadBoy_data['Defensive'] == nil then BadBoy_data['Defensive'] = 1; end
	if BadBoy_data['Interrupts'] == nil then BadBoy_data['Interrupts'] = 1; end
	-- Power Status
	if BadBoy_data['Power'] == 1 and powerText:GetText() ~= "On" then powerText:SetText("On"); powerButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); end
	if BadBoy_data['Power'] == 0 and powerText:GetText() ~= "Off" then powerText:SetText("Off"); powerButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]); end
	-- AoE Status
	local AoE = BadBoy_data['AoE'];
	if AoEModes ~= nil and AoE ~= nil then 
		if AoE == 0 then AoE = 1; end
		aoeText:SetText(AoEModes[AoE].mode); 
	end
	if AoEModes ~= nil and AoEModes[AoE].highlight ~= nil then
		if AoEModes[AoE].highlight == 0 and aoeButton:GetNormalTexture() ~= "Interface\BUTTONS\ButtonHilight-SquareQuickslot" then
			 aoeButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		elseif AoEModes[AoE].highlight == 1 and aoeButton:GetNormalTexture() ~= "Interface\BUTTONS\CheckButtonHilight" then
			aoeButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]);
		end
	else
		if BadBoy_data['AoE'] == 1 and aoeButton:GetNormalTexture() ~= "Interface\BUTTONS\ButtonHilight-SquareQuickslot" then
			aoeButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		elseif aoeButton:GetNormalTexture() ~= "Interface\BUTTONS\CheckButtonHilight" then 
			aoeButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); 
		end
	end
	-- Cooldowns Status
	local Cooldowns = BadBoy_data['Cooldowns'];
	if Cooldowns ~= nil and CooldownsModes ~= nil then 
		if Cooldowns == 0 then Cooldowns = 1 end 
		cooldownsText:SetText(CooldownsModes[Cooldowns].mode); 
	end
	if CooldownsModes ~= nil and CooldownsModes[Cooldowns].highlight ~= nil then
		if CooldownsModes[Cooldowns].highlight == 0 and cooldownsButton:GetNormalTexture() ~= "Interface\BUTTONS\ButtonHilight-SquareQuickslot" then
			 cooldownsButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		elseif CooldownsModes[Cooldowns].highlight == 1 and cooldownsButton:GetNormalTexture() ~= "Interface\BUTTONS\CheckButtonHilight" then
			cooldownsButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]);
		end
	else
		if BadBoy_data['Cooldowns'] == 1 and cooldownsButton:GetNormalTexture() ~= "Interface\BUTTONS\ButtonHilight-SquareQuickslot" then
			cooldownsButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		elseif cooldownsButton:GetNormalTexture() ~= "Interface\BUTTONS\CheckButtonHilight" then 
			cooldownsButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); 
		end
	end
	-- Defensive Status
	local Defensive = BadBoy_data['Defensive'];
	defensiveText:SetText(DefensiveModes[Defensive].mode);
	if DefensiveModes ~= nil and DefensiveModes[Defensive].highlight ~= nil then
		if DefensiveModes[Defensive].highlight == 0 and defensiveButton:GetNormalTexture() ~= "Interface\BUTTONS\ButtonHilight-SquareQuickslot" then
			 defensiveButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		elseif DefensiveModes[Defensive].highlight == 1 and defensiveButton:GetNormalTexture() ~= "Interface\BUTTONS\CheckButtonHilight" then
			defensiveButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]);
		end
	else
		if BadBoy_data['Defensive'] == 1 and defensiveButton:GetNormalTexture() ~= "Interface\BUTTONS\ButtonHilight-SquareQuickslot" then
			defensiveButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		elseif defensiveButton:GetNormalTexture() ~= "Interface\BUTTONS\CheckButtonHilight" then 
			defensiveButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); 
		end
	end
	--Interrupts Status
	local Interrupts = BadBoy_data['Interrupts'];
	interruptsText:SetText(InterruptsModes[Interrupts].mode);

	if InterruptsModes ~= nil and InterruptsModes[Interrupts].highlight ~= nil then
		if InterruptsModes[Interrupts].highlight == 0 and interruptsButton:GetNormalTexture() ~= "Interface\BUTTONS\ButtonHilight-SquareQuickslot" then
			 interruptsButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		elseif InterruptsModes[Interrupts].highlight == 1 and interruptsButton:GetNormalTexture() ~= "Interface\BUTTONS\CheckButtonHilight" then
			interruptsButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]);
		end
	else
		if BadBoy_data['Interrupts'] == 1 and interruptsButton:GetNormalTexture() ~= "Interface\BUTTONS\ButtonHilight-SquareQuickslot" then
			interruptsButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		elseif interruptsButton:GetNormalTexture() ~= "Interface\BUTTONS\CheckButtonHilight" then 
			interruptsButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); 
		end
	end
	-- configShown
	if BadBoy_data.configShown == false then
		if configFrame:IsShown() == 1 then configFrame:Hide(); end
		if configButton:GetNormalTexture() ~= "Interface\BUTTONS\ButtonHilight-SquareQuickslot" then configButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]); end
	elseif BadBoy_data.configShown == true then
		if configFrame:IsShown() == nil then configFrame:Show(); end
		if configButton:GetNormalTexture() ~= "Interface\BUTTONS\CheckButtonHilight" then configButton:SetNormalTexture([[Interface\BUTTONS\CheckButtonHilight]]); end
	end
	-- Health Status
	local playerHealth = (100*UnitHealth("player")/UnitHealthMax("player"));
	if healthFrame:GetValue() ~= playerHealth or firstRun == nil then
		firstRun = true;
		healthFrame:SetValue(playerHealth);
		healthFrame.healthbartext:SetText(math.floor(playerHealth).."%", 1, 1, 1, 1);
		if UnitHealthMax("player") > 10000 then
			local playerHealth = math.floor(UnitHealth("player")/1000);
			local playerHealthMax = math.floor(UnitHealthMax("player")/1000);
			healthFrame.healthbarnumbers:SetText(playerHealth.."k / "..playerHealthMax.."k", 1, 1, 1, 1);
		else
			healthFrame.healthbarnumbers:SetText(UnitHealth("player").." / "..UnitHealthMax("player"), 1, 1, 1, 1);
		end
	end

	-- Focus
	if mainFrame:GetValue() ~= UnitPower("player") then
		local playerFocus = UnitPower("player");
		local playerFocusMax = UnitPowerMax("player");
		mainFrame:SetValue(playerFocus);
		mainFrame.Text:SetText(playerFocus.."/"..playerFocusMax, 1, 1, 1, 0.7);
		mainFrame:SetMinMaxValues(0, playerFocusMax);
	end
	--targetDistance = getDistance("player","target")
	--mainFrame.Text:SetText(targetDistance)


	-- 0 - Mana
	-- 1 - Rage
	-- 2 - Focus
	-- 3 - Energy
	-- 6 - Runic Power
	local powerType = UnitPowerType("player")
	if powerType == 0 and powerTypeDisplay ~= 0 then -- Mana
		powerTypeDisplay = 0;
		mainFrame.Border:SetTexture([[Interface\UNITPOWERBARALT\Rock_Horizontal_Frame]],"BORDER");
		mainFrame:GetStatusBarTexture():SetTexture([[Interface\GLUES\MODELS\UI_Goblin\UI_Goblin_sky]], "OVERLAY");
	elseif powerType == 1 and powerTypeDisplay ~= 1 then -- Rage
		powerTypeDisplay = 1;
		mainFrame.Border:SetTexture([[Interface\UNITPOWERBARALT\Rock_Horizontal_Frame]],"BORDER");
		mainFrame:GetStatusBarTexture():SetTexture([[Interface\GLUES\MODELS\UI_Goblin\UI_Goblin_sky]], "OVERLAY");
	elseif powerType == 2 and powerTypeDisplay ~= 2 then -- Focus
		powerTypeDisplay = 2;
		mainFrame.Border:SetTexture([[Interface\UNITPOWERBARALT\MetalGold_Horizontal_Frame]],"BORDER");
		mainFrame:GetStatusBarTexture():SetTexture([[Interface\Archeology\Arch-Progress-Fill]],"OVERLAY");
	elseif powerType == 3 and powerTypeDisplay ~= 3 then -- Energy
		powerTypeDisplay = 3;
		mainFrame.Border:SetTexture([[Interface\UNITPOWERBARALT\Fire_Horizontal_Frame]],"BORDER");
		mainFrame:GetStatusBarTexture():SetTexture([[Interface\UNITPOWERBARALT\Generic1Target_Horizontal_Flash]],"OVERLAY");
	end
end
