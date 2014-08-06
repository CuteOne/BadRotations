-- /run DebugFrameCreation()
function DebugFrameCreation()
	if debugLoaded ~= true then
		
		-- Vars
		if BadBoy_data.debugWidth == nil then 
			BadBoy_data.debugWidth = 200;
			BadBoy_data.debuganchor = "Center"
			BadBoy_data.debugx = -200;
			BadBoy_data.debugy = 100;
			BadBoy_data.ActualRow = 0;
		end
		if BadBoy_data.debugAlpha == nil then BadBoy_data.debugAlpha = 0.10; end
		BadBoy_data.ActualRow = 0;
		if BadBoy_data.shownRows == nil then BadBoy_data.shownRows = 10; end
		-- /run CreateDebugRow(0, "Spell Name")
		-- CreateRow
		if debugHeight == nil then debugHeight = 26; end
		function CreateDebugRow(value,textString)
			if value > 0 then
				_G["debug"..value.."Frame"] = CreateFrame("CheckButton", "MyButton", debugFrame, "UIPanelButtonTemplate");
				_G["debug"..value.."Frame"]:SetAlpha(0.10);
				_G["debug"..value.."Frame"]:SetWidth(BadBoy_data.debugWidth);
				_G["debug"..value.."Frame"]:SetHeight(20);
				_G["debug"..value.."Frame"]:SetNormalTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]]);
				_G["debug"..value.."Frame"]:SetPoint("TOPLEFT",0,-((value*20)));
				_G["debug"..value.."Frame"]:SetAlpha(1);
				_G["debug"..value.."Frame"]:SetScript("OnEnter", function(self)

					GameTooltip:SetOwner(self, "BOTTOMLEFT", 250, 5);
					if debugTable ~= nil and debugTable[value] ~= nil then
						if debugTable[value].sourcename == nil then debugTable[value].sourcename = "No Caster"; end
						if debugTable[value].sourceguid == nil then debugTable[value].sourceguid = "Invalid GUID"; end
						if debugTable[value].spellid == nil then debugTable[value].spellid = "Invalid Spell ID"; end
						if debugTable[value].spellname == nil then debugTable[value].spellname = "Invalid Spell Name"; end
						if debugTable[value].destguid == nil then debugTable[value].destguid = "Invalid Dest Guid"; end
						if debugTable[value].destname == nil then debugTable[value].destname = "Invalid Dest Name"; end
						if debugTable[value].power == nil then debugTable[value].power = "No Power Reported"; end
						if debugTable[value].distance == nil then debugTable[value].distance = "No Distance Reported"; end
						if debugTable[value].uierror == nil then debugTable[value].uierror = "No Error Reported"; end
						GameTooltip:SetText("|cffFF001ERoll Mouse to Scroll Rows\n|cffFFFFFF"..debugTable[value].sourcename.." "..debugTable[value].sourceguid..
						  "\n|cffFFDD11"..debugTable[value].spellname.." "..debugTable[value].spellid..
						  "\n|cff00FF00On: "..debugTable[value].destname.." "..debugTable[value].destguid..
						  "\n|cffFFFFFFPower: "..debugTable[value].power.."%"..
						  "\n|cff00FF00Distance: "..debugTable[value].distance..
						  "\n|cffFF0000"..debugTable[value].uierror, nil, nil, nil, nil, true);
						GameTooltip:Show();
					end
				end)
				_G["debug"..value.."Frame"]:SetScript("OnLeave", function(self)
					if tooltipLock ~= true then
						GameTooltip:Hide();
					end
					tooltipLock = false;
				end)

				_G["debug"..value.."Frame"]:SetScript("OnMouseWheel", function(self, delta)
					if IsAltKeyDown() then
						local Go = false;
						if delta < 0 and BadBoy_data.debugAlpha > 0 then
							Go = true;
						elseif delta > 0 and BadBoy_data.debugAlpha < 100 then
							Go = true;
						end
						if Go == true then
							BadBoy_data.debugAlpha = BadBoy_data.debugAlpha + (delta*5)
							debugFrame.texture:SetAlpha(BadBoy_data.debugAlpha/100);
						end
					else			
						local Go = false;
						if delta < 0 and BadBoy_data.ActualRow < 100 and debugTable ~= nil and debugTable[BadBoy_data.ActualRow+BadBoy_data.shownRows] ~= nil then
							Go = true;
						elseif delta > 0 and BadBoy_data.ActualRow > 0 then
							Go = true;
						end
						if Go == true then
							BadBoy_data.ActualRow = BadBoy_data.ActualRow - delta
							debugRefresh()
						end
					end
				end)
				_G["debug"..value.."Frame"]:SetScript("OnClick", function(self, button)
					if button == "LeftButton" then 
						if tooltipLock ~= true then
							tooltipLock = true;
						else
							tooltipLock = false;
							GameTooltip:Hide();
						end
					end	
				end)



				--_G["debug"..value.."Frame"]:Hide();
				_G["debug"..value.."Text"] = _G["debug"..value.."Frame"]:CreateFontString(_G["debug"..value.."Frame"], "OVERLAY");
				_G["debug"..value.."Text"]:SetAlpha(0.10);
				_G["debug"..value.."Text"]:SetWidth(BadBoy_data.debugWidth);
				_G["debug"..value.."Text"]:SetHeight(20);
				_G["debug"..value.."Text"]:SetPoint("TOPLEFT",0,0);
				_G["debug"..value.."Text"]:SetJustifyH("LEFT")
				_G["debug"..value.."Text"]:SetAlpha(1);
				_G["debug"..value.."Text"]:SetFont("Fonts/MORPHEUS.ttf",16,"THICKOUTLINE");
				_G["debug"..value.."Text"]:SetText(textString, 1, 1, 1, 0.7);
			end
		end

		debugFrame = CreateFrame("Frame", nil, UIParent);
		debugFrame:SetWidth(BadBoy_data.debugWidth);
		debugFrame:SetHeight((BadBoy_data.shownRows*20)+20)
		debugFrame.texture = debugFrame:CreateTexture(debugFrame, "ARTWORK");
		debugFrame.texture:SetAllPoints();
		debugFrame.texture:SetWidth(BadBoy_data.debugWidth);
		debugFrame.texture:SetHeight(30);
		debugFrame.texture:SetAlpha(BadBoy_data.debugAlpha/100);
		debugFrame.texture:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]]);

		function SetDebugWidth(Width)
			BadBoy_data.debugWidth = Width
			debugFrame:SetWidth(Width);
		end

		debugFrame:SetPoint(BadBoy_data.debuganchor,BadBoy_data.debugx,BadBoy_data.debugy);
		debugFrame:SetClampedToScreen(true);
		debugFrame:SetScript("OnUpdate", debugFrame_OnUpdate);
		debugFrame:EnableMouse(true);
		debugFrame:SetMovable(true);
		debugFrame:SetClampedToScreen(true);
		debugFrame:RegisterForDrag("LeftButton");
		debugFrame:SetScript("OnDragStart", debugFrame.StartMoving);
		debugFrame:SetScript("OnDragStop", debugFrame.StopMovingOrSizing);
		debugFrame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "BOTTOMLEFT", 250, 5);
			GameTooltip:SetText("|cffD60000Roll Mouse to adjust Width.\n|cffFFFFFFLeft Click/Hold to move.\n|cffFFDD11Alt+Roll to adjust Debug Alpha.", nil, nil, nil, nil, true);
			GameTooltip:Show();
		end)
		debugFrame:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end)
		debugFrame:SetScript("OnMouseWheel", function(self, delta)
			local Go = false;
			if delta < 0 and BadBoy_data.debugWidth < 500 then
				Go = true;
			elseif delta > 0 and BadBoy_data.debugWidth > 0 then
				Go = true;
			end
			if Go == true then
				BadBoy_data.debugWidth = BadBoy_data.debugWidth + (delta*5)
				debugFrame:SetWidth(BadBoy_data.debugWidth);
				for i = 1, 25 do 
					if _G["debug"..i.."Frame"]:GetWidth() ~= BadBoy_data.debugWidth then
						_G["debug"..i.."Frame"]:SetWidth(BadBoy_data.debugWidth);
					end
					if _G["debug"..i.."Text"]:GetWidth() ~= BadBoy_data.debugWidth then
						_G["debug"..i.."Text"]:SetWidth(BadBoy_data.debugWidth);
					end
				end
			end
		end)
		debugFrameRowsButton = CreateFrame("CheckButton", "MyButton", debugFrame, "UIPanelButtonTemplate");
		debugFrameRowsButton:SetAlpha(0.80);
		debugFrameRowsButton:SetWidth(30);
		debugFrameRowsButton:SetHeight(18);
		debugFrameRowsButton:SetPoint("TOPRIGHT", -1, -1);
		debugFrameRowsButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		debugFrameRowsButton:RegisterForClicks("AnyUp");
		debugFrameRowsButton:SetText(BadBoy_data.shownRows);
		debugFrameRowsButton:SetScript("OnMouseWheel", function(self, delta)
			local Go = false;
			if delta < 0 and BadBoy_data.shownRows > 1 then
				Go = true;
			elseif delta > 0 and BadBoy_data.shownRows < 25 then
				Go = true;
			end
			if Go == true then
				BadBoy_data.shownRows = BadBoy_data.shownRows + delta
				debugFrameRowsButton:SetText(BadBoy_data.shownRows);
				debugRefresh()
				debugFrame:SetHeight((BadBoy_data.shownRows*20)+20);
			end
		end)
		debugFrameRowsButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "BOTTOMRIGHT", 0, 5);
			GameTooltip:SetText("|cffD60000Number of Rows to Display.", nil, nil, nil, nil, true);
			GameTooltip:Show();
		end)
		debugFrameRowsButton:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end)

		debugFrameText = debugFrame:CreateFontString(nil, "ARTWORK");
		debugFrameText:SetFont("Fonts/MORPHEUS.ttf",16,"THICKOUTLINE");
		debugFrameText:SetTextHeight(16);
		debugFrameText:SetPoint("TOPLEFT",5, -2);
		debugFrameText:SetTextColor(225/255, 225/255, 225/255,1);
		debugFrameText:SetText("|cffFF001EBadBoy |cffFFFFFFDebug Frame")

		if BadBoy_data.debugShown == false then debugFrame:Hide(); else debugFrame:Show(); end

		SetDebugWidth(BadBoy_data.debugWidth);

		--CreateDebugRow(0,"|cff12C8FFTime|cffFF001E/|cffFFFFFFSpell Name")

		for i = 1, 25 do
			CreateDebugRow(i,"")
		end

		function debugRefresh()
			if debugTable == nil then 			
				for i = 1, BadBoy_data.shownRows do
					local debugSpellName = ""
					if _G["debug"..i.."Frame"]:IsShown() ~= 1 then
						_G["debug"..i.."Text"]:Show();
						_G["debug"..i.."Frame"]:Show();
					end
					_G["debug"..i.."Text"]:SetText(debugSpellName, 1, 1, 1, 0.7);
				end 
				for i = BadBoy_data.shownRows+1, 25 do
					if _G["debug"..i.."Frame"]:IsShown() == 1 then
						_G["debug"..i.."Text"]:Hide();
						_G["debug"..i.."Frame"]:Hide();
					end
				end
			else
				for i = 1, BadBoy_data.shownRows do
					local debugSpellName = debugSpellName;
					if debugTable[BadBoy_data.ActualRow+i] ~= nil then
						debugSpellName = debugTable[BadBoy_data.ActualRow+i].textString;
					else
						debugSpellName = ""
					end
					if _G["debug"..i.."Frame"]:IsShown() ~= 1 then
						_G["debug"..i.."Text"]:Show();
						_G["debug"..i.."Frame"]:Show();
					end
					_G["debug"..i.."Text"]:SetText(debugSpellName, 1, 1, 1, 0.7);
				end
				for i = BadBoy_data.shownRows+1, 25 do
					if _G["debug"..i.."Frame"]:IsShown() == 1 then
						_G["debug"..i.."Text"]:Hide();
						_G["debug"..i.."Frame"]:Hide();
					end
				end
			end
			
			debugFrame:SetHeight((BadBoy_data.shownRows*20)+20);
		end

    	debugLoaded = true;
    	debugRefresh();
	end
end