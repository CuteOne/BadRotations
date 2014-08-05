-- /run DebugFrameCreation()
function DebugFrameCreation()
	if debugLoaded ~= true then
		
		-- Vars
		if BadBoy_data.debugWidth == nil then 
			BadBoy_data.debugWidth = 400;
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
			_G["debug"..value.."Text"] = debugFrame:CreateFontString(nil, "OVERLAY");
			_G["debug"..value.."Text"]:SetFont("Fonts/MORPHEUS.ttf",16,"THICKOUTLINE");
			_G["debug"..value.."Text"]:SetPoint("TOPLEFT",5,-((value*20)+3));
			_G["debug"..value.."Text"]:SetWordWrap(enable)
			_G["debug"..value.."Text"]:SetTextColor(225/255, 225/255, 225/255,1);
			_G["debug"..value.."Text"]:SetText(textString, 1, 1, 1, 0.7);
		end

		debugFrame = CreateFrame("Frame", nil, UIParent);
		--debugFrame:SetAlpha(1);
		debugFrame:SetWidth(250);
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

		debugFrame:SetScript("OnMouseWheel", function(self, delta)
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
				if delta < 0 and BadBoy_data.ActualRow < 100 and debugTable[BadBoy_data.ActualRow+BadBoy_data.shownRows] ~= nil then
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
			GameTooltip:SetText("|cffD60000Roll mouse to scroll Rows.\n|cffFFFFFFLeft Click/Hold to move.\n|cffFFDD11Alt+Roll to adjust Debug Alpha.", nil, nil, nil, nil, true);
			GameTooltip:Show();
		end)
		debugFrame:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end)

		debugFrameRowsButton = CreateFrame("CheckButton", "MyButton", debugFrame, "UIPanelButtonTemplate");
		debugFrameRowsButton:SetAlpha(0.80);
		debugFrameRowsButton:SetWidth(30);
		debugFrameRowsButton:SetHeight(18);
		debugFrameRowsButton:SetPoint("TOPRIGHT", 0, 0);
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
		debugFrameText:SetTextHeight(17);
		debugFrameText:SetPoint("TOPLEFT",5, 0);
		debugFrameText:SetTextColor(225/255, 225/255, 225/255,1);

		if BadBoy_data.debugShown == false then debugFrame:Hide(); else debugFrame:Show(); end

		SetDebugWidth(BadBoy_data.debugWidth);

		CreateDebugRow(0,"|cff12C8FFTime|cffFF001E/|cffFFFFFFSpell Name|cffFF001E/|cff12C8FFSpell ID|cffFF001E/|cffFFFFFFTarget")

		for i = 1, 25 do
			CreateDebugRow(i,"")
		end

		function debugRefresh()
			for i = 1, BadBoy_data.shownRows do
				local debugSpellName = debugSpellName;
				if debugTable[BadBoy_data.ActualRow+i] ~= nil then
					debugSpellName = debugTable[BadBoy_data.ActualRow+i].textString;
				else
					debugSpellName = ""
				end
				if _G["debug"..i.."Text"]:IsShown() ~= 1 then
					_G["debug"..i.."Text"]:Show();
				end
				_G["debug"..i.."Text"]:SetText(debugSpellName, 1, 1, 1, 0.7);
			end
			for i = BadBoy_data.shownRows+1, 25 do
				if _G["debug"..i.."Text"]:IsShown() == 1 then
					_G["debug"..i.."Text"]:Hide();
				end
			end
			debugFrame:SetHeight((BadBoy_data.shownRows*20)+20);
		end

    	debugLoaded = true;
	end
end