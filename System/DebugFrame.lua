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
		BadBoy_data.successCasts = 0;
		BadBoy_data.failCasts = 0;
		if BadBoy_data.debugAlpha == nil then BadBoy_data.debugAlpha = 0.90; end
		BadBoy_data.ActualRow = 0;
		if BadBoy_data.shownRows == nil then BadBoy_data.shownRows = 10; end
		-- /run CreateDebugRow(0, "Spell Name")
		-- CreateRow
		if debugHeight == nil then debugHeight = 26; end
		function CreateDebugRow(value,textString)
			if value > 0 then
				_G["debug"..value.."Frame"] = CreateFrame("Frame", "MyButton", debugFrame);
				_G["debug"..value.."Frame"]:SetWidth(BadBoy_data.debugWidth);
				_G["debug"..value.."Frame"]:SetHeight(20);
				--_G["debug"..value.."Frame"]:SetNormalTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]]); 
				_G["debug"..value.."Frame"]:SetPoint("TOPLEFT",0,-((value*20)));
				_G["debug"..value.."Frame"]:SetAlpha(BadBoy_data.debugAlpha);
				_G["debug"..value.."Frame"]:SetScript("OnEnter", function(self)
					local MyValue = value;
					if debugTable ~= nil and debugTable[MyValue+BadBoy_data.ActualRow] ~= nil then
						GameTooltip:SetOwner(self, "BOTTOMLEFT", 250, 5);
						GameTooltip:SetText(debugTable[MyValue+BadBoy_data.ActualRow].toolTip, nil, nil, nil, nil, false);
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
				end)

				--_G["debug"..value.."Frame"]:Hide();
				_G["debug"..value.."Text"] = _G["debug"..value.."Frame"]:CreateFontString(_G["debug"..value.."Frame"], "OVERLAY");
				_G["debug"..value.."Text"]:SetWidth(BadBoy_data.debugWidth);
				_G["debug"..value.."Text"]:SetHeight(20);
				_G["debug"..value.."Text"]:SetPoint("TOPLEFT",0,0);
				_G["debug"..value.."Text"]:SetAlpha(1)
				_G["debug"..value.."Text"]:SetJustifyH("LEFT")
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
		CreateBorder(debugFrame, 8, 0.6, 0.6, 0.6);

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
					for i = 1, 25 do 
						if _G["debug"..i.."Frame"]:GetAlpha() ~= BadBoy_data.debugAlpha/100 then
							_G["debug"..i.."Frame"]:SetAlpha(BadBoy_data.debugAlpha/100);
							debugFrameText:SetAlpha(BadBoy_data.debugAlpha/100);
						end
					end
				end
			else	
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
					debugFrameText:SetWidth(BadBoy_data.debugWidth);
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




		debugFrameTopButton = CreateFrame("CheckButton", "MyButton", debugFrame, "UIPanelButtonTemplate");
		debugFrameTopButton:SetAlpha(0.80);
		debugFrameTopButton:SetWidth(30);
		debugFrameTopButton:SetHeight(18);
		debugFrameTopButton:SetPoint("TOPRIGHT", -31, -1);
		debugFrameTopButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		debugFrameTopButton:RegisterForClicks("AnyUp");
		debugFrameTopButton:SetText("Top");
		debugFrameTopButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "BOTTOMRIGHT", 0, 5);
			GameTooltip:SetText("|cffD60000Click to return to top.", nil, nil, nil, nil, true);
			GameTooltip:Show();
		end)
		debugFrameTopButton:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end)
		debugFrameTopButton:SetScript("OnClick", function()
			BadBoy_data.ActualRow = 0;
			debugRefresh();
		end)

		debugFrameText = debugFrame:CreateFontString(debugFrame, "ARTWORK");
		debugFrameText:SetFont("Fonts/MORPHEUS.ttf",17,"THICKOUTLINE");
		debugFrameText:SetTextHeight(16);
		debugFrameText:SetPoint("TOPLEFT",5, -4);
		debugFrameText:SetJustifyH("LEFT")
		debugFrameText:SetTextColor(225/255, 225/255, 225/255,1);
		debugFrameText:SetText("|cffFF001EBadBoy |cffFFFFFFDebug")

		if BadBoy_data.debugShown == false then debugFrame:Hide(); else debugFrame:Show(); end

		SetDebugWidth(BadBoy_data.debugWidth);

		--CreateDebugRow(0,"|cff12C8FFTime|cffFF001E/|cffFFFFFFSpell Name")

		for i = 1, 25 do
			CreateDebugRow(i,"")
		end

		function debugRefresh()
			if debugTable == nil then 			
				for i = 1, BadBoy_data.shownRows do
					local debugSpellName, debugSpellTip = "", ""
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
					local debugSpellName, debugSpellTip;
					if debugTable[BadBoy_data.ActualRow+i] ~= nil then
						debugSpellName = debugTable[BadBoy_data.ActualRow+i].textString;
					else
						debugSpellName = "";
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
		debugFrame.texture:SetAlpha(BadBoy_data.debugAlpha/100);
		for i = 1, 25 do 
			if _G["debug"..i.."Frame"]:GetAlpha() ~= BadBoy_data.debugAlpha/100 then
				_G["debug"..i.."Frame"]:SetAlpha(BadBoy_data.debugAlpha/100);
				debugFrameText:SetAlpha(BadBoy_data.debugAlpha/100);
			end
		end
		debugFrameText:SetWidth(BadBoy_data.debugWidth);
		debugFrame:SetWidth(BadBoy_data.debugWidth);
		for i = 1, 25 do 
			if _G["debug"..i.."Frame"]:GetWidth() ~= BadBoy_data.debugWidth then
				_G["debug"..i.."Frame"]:SetWidth(BadBoy_data.debugWidth);
			end
			if _G["debug"..i.."Text"]:GetWidth() ~= BadBoy_data.debugWidth then
				_G["debug"..i.."Text"]:SetWidth(BadBoy_data.debugWidth);
			end
		end
    	debugLoaded = true;
    	debugRefresh();
	end
end