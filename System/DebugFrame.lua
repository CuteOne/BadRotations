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
		BadBoy_data.ActualRow = 0;
		if BadBoy_data.shownRows == nil then BadBoy_data.shownRows = 10; end
		-- /run CreateDebugRow(0, "Spell Name")
		-- CreateRow
		if debugHeight == nil then debugHeight = 26; end
		function CreateDebugRow(value,textString)
			_G["debug"..value.."Text"] = debugFrame:CreateFontString(nil, "ARTWORK");
			_G["debug"..value.."Text"]:SetFontObject("QuestTitleFont",17,"THICKOUTLINE");
			_G["debug"..value.."Text"]:SetTextHeight(17);
			_G["debug"..value.."Text"]:SetPoint("TOPLEFT",5,-((value*20)));
			--_G["debug"..value.."Text"]:SetWidth(BadBoy_data.debugWidth);
			_G["debug"..value.."Text"]:SetWordWrap(enable)
			_G["debug"..value.."Text"]:SetTextColor(225/255, 225/255, 225/255,1);
			_G["debug"..value.."Text"]:SetText(textString, 1, 1, 1, 0.7);
			if (value*22)+26 > debugHeight then
				debugHeight = (value*20)+22
				debugFrame:SetHeight(debugHeight+5);
			end
		end



		debugTable = { };

		

		debugFrame = CreateFrame("Frame", nil, UIParent);
		debugFrame:SetFrameStrata("BACKGROUND")
		debugFrame:SetAlpha(1);
		debugFrame:SetWidth(250);
		debugFrame:SetHeight(30);
		debugFrame.textureTopLeft = debugFrame:CreateTexture(debugFrame, "ARTWORK");
		debugFrame.textureTopLeft:SetAllPoints();
		debugFrame.textureTopLeft:SetWidth(BadBoy_data.debugWidth);
		debugFrame.textureTopLeft:SetHeight(30);
		debugFrame.textureTopLeft:SetAlpha(0.00);
		--debugFrame.texture:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]],0.25);
		debugFrame.textureTopLeft:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]],0.25);

		function SetDebugWidth(Width)
			BadBoy_data.debugWidth = Width
			debugFrame:SetWidth(Width);
		end

		debugFrame:SetScript("OnMouseWheel", function(self, delta)
			local Go = false;
			if delta < 0 and BadBoy_data.ActualRow > 0 then
				Go = true;
			elseif delta > 0 and BadBoy_data.ActualRow < 100 and debugTable[BadBoy_data.ActualRow+BadBoy_data.shownRows] ~= nil then
				Go = true;
			end
			if Go == true then
				BadBoy_data.ActualRow = BadBoy_data.ActualRow + delta
				debugRefresh()
			end
		end)

		--debugFrame.texture:SetTexture(25/255,25/255,25/255,1);
		debugFrame:SetPoint(BadBoy_data.debuganchor,BadBoy_data.debugx,BadBoy_data.debugy);
		debugFrame:SetClampedToScreen(true);
		debugFrame:SetScript("OnUpdate", debugFrame_OnUpdate);
		debugFrame:EnableMouse(true);
		debugFrame:SetMovable(true);
		debugFrame:SetClampedToScreen(true);
		debugFrame:RegisterForDrag("LeftButton");
		debugFrame:SetScript("OnDragStart", debugFrame.StartMoving);
		debugFrame:SetScript("OnDragStop", debugFrame.StopMovingOrSizing);

		debugFrameRowsButton = CreateFrame("CheckButton", "MyButton", debugFrame, "UIPanelButtonTemplate");
		debugFrameRowsButton:SetAlpha(0.80);
		debugFrameRowsButton:SetWidth(30);
		debugFrameRowsButton:SetHeight(18);
		debugFrameRowsButton:SetPoint("TOPRIGHT", -25 , 0);
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



		debugFrameExitButton = CreateFrame("CheckButton", "MyButton", debugFrame, "UIPanelButtonTemplate");
		debugFrameExitButton:SetAlpha(0.80);
		debugFrameExitButton:SetWidth(18);
		debugFrameExitButton:SetHeight(18);
		debugFrameExitButton:SetPoint("TOPRIGHT", -3 , 0);
		debugFrameExitButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		debugFrameExitButton:RegisterForClicks("AnyUp");
		debugFrameExitButton:SetText("X");

		debugFrameExitButton:SetScript("OnClick", function()
			BadBoy_data.debugShown = false;
		end )

		debugFrameExitButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "BOTTOMRIGHT", 0, 5);
			GameTooltip:SetText("|cffD60000Close Debug.", nil, nil, nil, nil, true);
			GameTooltip:Show();
		end)
		debugFrameExitButton:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end)



		debugFrameText = debugFrame:CreateFontString(nil, "ARTWORK");
		debugFrameText:SetFontObject("QuestTitleFontBlackShadow",17,"THICKOUTLINE");
		debugFrameText:SetTextHeight(17);
		debugFrameText:SetPoint("TOPLEFT",5, 0);
		debugFrameText:SetTextColor(225/255, 225/255, 225/255,1);

		if BadBoy_data.debugShown == false then debugFrame:Hide(); else debugFrame:Show(); end

		SetDebugWidth(BadBoy_data.debugWidth);

		CreateDebugRow(0,"|cff12C8FFTime |cffFF001E| |cffFFFFFFSpell Name |cffFF001E| |cff12C8FFSpell ID |cffFF001E| |cffFFFFFFLast Target")

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
		end

    	debugLoaded = true;
	end
end