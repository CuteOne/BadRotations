-- /run EngineFrameCreation()
function EngineFrameCreation()
	if engineFrameLoaded ~= true then
		
		-- Vars
		if BadBoy_data.engineWidth == nil then 
			BadBoy_data.engineWidth = 200;
			BadBoy_data.engineanchor = "Center"
			BadBoy_data.enginex = -200;
			BadBoy_data.enginey = 100;
			BadBoy_data.engineActualRow = 0;
			BadBoy_data.engineAlpha = 95;
			BadBoy_data.engineRows = 5;
		end

		BadBoy_data.successCasts = 0;
		BadBoy_data.failCasts = 0;
		BadBoy_data.engineActualRow = 0;
		if BadBoy_data.engineRows == nil then  end
		-- /run CreateDebugRow(0, "Spell Name")
		-- CreateRow
		if engineHeight == nil then engineHeight = 26; end
		function CreateDebugRow(value,textString)
			if value > 0 then
				_G["engine"..value.."Frame"] = CreateFrame("Frame", "MyButton", engineFrame);
				_G["engine"..value.."Frame"]:SetWidth(BadBoy_data.engineWidth);
				_G["engine"..value.."Frame"]:SetHeight(20);
				--_G["engine"..value.."Frame"]:SetNormalTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]]); 
				_G["engine"..value.."Frame"]:SetPoint("TOPLEFT",0,-((value*20)));
				_G["engine"..value.."Frame"]:SetAlpha(BadBoy_data.engineAlpha/100);
				_G["engine"..value.."Frame"]:SetScript("OnEnter", function(self)
					local MyValue = value;
					if nNova ~= nil and nNova[MyValue+BadBoy_data.engineActualRow] ~= nil then
						GameTooltip:SetOwner(self, "BOTTOMLEFT", 250, 5);
						GameTooltip:SetText("|cffFF0000Role: |cffFFDD11"..nNova[MyValue+BadBoy_data.engineActualRow].role..
							"\n|cffFF0000Name: |cffFFDD11"..nNova[MyValue+BadBoy_data.engineActualRow].name..
							"\n|cffFF0000GUID: |cffFFDD11"..nNova[MyValue+BadBoy_data.engineActualRow].guid..
							"\n|cffFF0000Target: |cffFFDD11"..nNova[MyValue+BadBoy_data.engineActualRow].target, nil, nil, nil, nil, false);
						GameTooltip:Show();
					end
				end)
				_G["engine"..value.."Frame"]:SetScript("OnLeave", function(self)
					if tooltipLock ~= true then
						GameTooltip:Hide();
					end
					tooltipLock = false;
				end)

				_G["engine"..value.."Frame"]:SetScript("OnMouseWheel", function(self, delta)
					local Go = false;
					if delta < 0 and BadBoy_data.engineActualRow < 100 and engineTable ~= nil and engineTable[BadBoy_data.engineActualRow+BadBoy_data.engineRows] ~= nil then
						Go = true;
					elseif delta > 0 and BadBoy_data.engineActualRow > 0 then
						Go = true;
					end
					if Go == true then
						BadBoy_data.engineActualRow = BadBoy_data.engineActualRow - delta
						engineRefresh()
					end
				end)

				--_G["engine"..value.."Frame"]:Hide();
				_G["engine"..value.."Text"] = _G["engine"..value.."Frame"]:CreateFontString(_G["engine"..value.."Frame"], "OVERLAY");
				_G["engine"..value.."Text"]:SetWidth(BadBoy_data.engineWidth);
				_G["engine"..value.."Text"]:SetHeight(20);
				_G["engine"..value.."Text"]:SetPoint("TOPLEFT",0,0);
				_G["engine"..value.."Text"]:SetAlpha(1)
				_G["engine"..value.."Text"]:SetJustifyH("LEFT")
				_G["engine"..value.."Text"]:SetFont("Fonts/MORPHEUS.ttf",16,"THICKOUTLINE");
				_G["engine"..value.."Text"]:SetText(textString, 1, 1, 1, 0.7);
			end
		end

		engineFrame = CreateFrame("Frame", nil, UIParent);
		engineFrame:SetWidth(BadBoy_data.engineWidth);
		engineFrame:SetHeight((BadBoy_data.engineRows*20)+20)
		engineFrame.texture = engineFrame:CreateTexture(engineFrame, "ARTWORK");
		engineFrame.texture:SetAllPoints();
		engineFrame.texture:SetWidth(BadBoy_data.engineWidth);
		engineFrame.texture:SetHeight(30);
		engineFrame.texture:SetAlpha(BadBoy_data.engineAlpha/100);
		engineFrame.texture:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]]);
		CreateBorder(engineFrame, 8, 0.6, 0.6, 0.6);

		function SetDebugWidth(Width)
			BadBoy_data.engineWidth = Width;
			engineFrame:SetWidth(Width);
		end

		engineFrame:SetPoint(BadBoy_data.engineanchor,BadBoy_data.enginex,BadBoy_data.enginey);
		engineFrame:SetClampedToScreen(true);
		engineFrame:SetScript("OnUpdate", engineFrame_OnUpdate);
		engineFrame:EnableMouse(true);
		engineFrame:SetMovable(true);
		engineFrame:SetClampedToScreen(true);
		engineFrame:RegisterForDrag("LeftButton");
		engineFrame:SetScript("OnDragStart", engineFrame.StartMoving);
		engineFrame:SetScript("OnDragStop", engineFrame.StopMovingOrSizing);
		engineFrame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "BOTTOMLEFT", 250, 5);
			GameTooltip:SetText("|cffD60000Roll Mouse to adjust Width.\n|cffFFFFFFLeft Click/Hold to move.\n|cffFFDD11Alt+Roll to adjust Debug Alpha.", nil, nil, nil, nil, true);
			GameTooltip:Show();
		end)
		engineFrame:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end)
		engineFrame:SetScript("OnMouseWheel", function(self, delta)
			if IsAltKeyDown() then
				local Go = false;
				if delta < 0 and BadBoy_data.engineAlpha >= 0 then
					Go = true;
				elseif delta > 0 and BadBoy_data.engineAlpha <= 100 then
					Go = true;
				end
				if Go == true then
					BadBoy_data.engineAlpha = BadBoy_data.engineAlpha + (delta*5)
					engineFrame.texture:SetAlpha(BadBoy_data.engineAlpha/100);
					for i = 1, 25 do 
						if _G["engine"..i.."Frame"]:GetAlpha() ~= BadBoy_data.engineAlpha/100 then
							_G["engine"..i.."Frame"]:SetAlpha(BadBoy_data.engineAlpha/100);
							engineFrameText:SetAlpha(BadBoy_data.engineAlpha/100);
						end
					end
				end
			else	
				local Go = false;
				if delta < 0 and BadBoy_data.engineWidth < 500 then
					Go = true;
				elseif delta > 0 and BadBoy_data.engineWidth > 0 then
					Go = true;
				end
				if Go == true then
					BadBoy_data.engineWidth = BadBoy_data.engineWidth + (delta*5)
					engineFrame:SetWidth(BadBoy_data.engineWidth);
					for i = 1, 25 do 
						if _G["engine"..i.."Frame"]:GetWidth() ~= BadBoy_data.engineWidth then
							_G["engine"..i.."Frame"]:SetWidth(BadBoy_data.engineWidth);
						end
						if _G["engine"..i.."Text"]:GetWidth() ~= BadBoy_data.engineWidth then
							_G["engine"..i.."Text"]:SetWidth(BadBoy_data.engineWidth);
						end
					end
					engineFrameText:SetWidth(BadBoy_data.engineWidth);
				end
			end
		end)
		engineFrameRowsButton = CreateFrame("CheckButton", "MyButton", engineFrame, "UIPanelButtonTemplate");
		engineFrameRowsButton:SetAlpha(0.80);
		engineFrameRowsButton:SetWidth(30);
		engineFrameRowsButton:SetHeight(18);
		engineFrameRowsButton:SetPoint("TOPRIGHT", -1, -1);
		engineFrameRowsButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		engineFrameRowsButton:RegisterForClicks("AnyUp");
		engineFrameRowsButton:SetText(BadBoy_data.engineRows);
		engineFrameRowsButton:SetScript("OnMouseWheel", function(self, delta)
			local Go = false;
			if delta < 0 and BadBoy_data.engineRows > 1 then
				Go = true;
			elseif delta > 0 and BadBoy_data.engineRows < 25 then
				Go = true;
			end
			if Go == true then
				BadBoy_data.engineRows = BadBoy_data.engineRows + delta
				engineFrameRowsButton:SetText(BadBoy_data.engineRows);
				engineRefresh()
				engineFrame:SetHeight((BadBoy_data.engineRows*20)+20);
			end
		end)
		engineFrameRowsButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "BOTTOMRIGHT", 0, 5);
			GameTooltip:SetText("|cffD60000Number of Rows to Display.", nil, nil, nil, nil, true);
			GameTooltip:Show();
		end)
		engineFrameRowsButton:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end)




		engineFrameTopButton = CreateFrame("CheckButton", "MyButton", engineFrame, "UIPanelButtonTemplate");
		engineFrameTopButton:SetAlpha(0.80);
		engineFrameTopButton:SetWidth(30);
		engineFrameTopButton:SetHeight(18);
		engineFrameTopButton:SetPoint("TOPRIGHT", -31, -1);
		engineFrameTopButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		engineFrameTopButton:RegisterForClicks("AnyUp");
		engineFrameTopButton:SetText("Top");
		engineFrameTopButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "BOTTOMRIGHT", 0, 5);
			GameTooltip:SetText("|cffD60000Click to return to top.", nil, nil, nil, nil, true);
			GameTooltip:Show();
		end)
		engineFrameTopButton:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end)
		engineFrameTopButton:SetScript("OnClick", function()
			BadBoy_data.engineActualRow = 0;
			engineRefresh();
		end)

		engineFrameText = engineFrame:CreateFontString(engineFrame, "ARTWORK");
		engineFrameText:SetFont("Fonts/MORPHEUS.ttf",17,"THICKOUTLINE");
		engineFrameText:SetTextHeight(16);
		engineFrameText:SetPoint("TOPLEFT",5, -4);
		engineFrameText:SetJustifyH("LEFT")
		engineFrameText:SetTextColor(225/255, 225/255, 225/255,1);
		engineFrameText:SetText("|cffFF001En|cff00F2FFNova |cffFFFFFFEngine")

		if BadBoy_data.engineShown == false then engineFrame:Hide(); else engineFrame:Show(); end

		SetDebugWidth(BadBoy_data.engineWidth);

		--CreateDebugRow(0,"|cff12C8FFTime|cffFF001E/|cffFFFFFFSpell Name")

		for i = 1, 25 do
			CreateDebugRow(i,"")
		end

		function engineRefresh()
			if nNova == nil then 			
				for i = 1, BadBoy_data.engineRows do
					local engineName, engineTip = "", ""
					if _G["engine"..i.."Frame"]:IsShown() ~= 1 then
						_G["engine"..i.."Text"]:Show();
						_G["engine"..i.."Frame"]:Show();
					end
					_G["engine"..i.."Text"]:SetText(engineName, 1, 1, 1, 0.7);
				end 
				for i = BadBoy_data.engineRows+1, 25 do
					if _G["engine"..i.."Frame"]:IsShown() == 1 then
						_G["engine"..i.."Text"]:Hide();
						_G["engine"..i.."Frame"]:Hide();
					end
				end
			else
				for i = 1, BadBoy_data.engineRows do
					local engineName;
					if nNova[BadBoy_data.engineActualRow+i] ~= nil then
						local healthDisplay = "|cffFF0000"..math.floor(nNova[BadBoy_data.engineActualRow+i].hp) or 0;
						local roleDisplay = "|cffFFBB00 "..nNova[BadBoy_data.engineActualRow+i].role or " |cffFFBB00NONE";
						local nameDisplay = nameDisplay;
						if select(3,UnitClass(nNova[BadBoy_data.engineActualRow+i].unit)) ~= nil and nNova[BadBoy_data.engineActualRow+i].name ~= nil then
							nameDisplay = classColors[select(3,UnitClass(nNova[BadBoy_data.engineActualRow+i].unit))].hex.." "..nNova[BadBoy_data.engineActualRow+i].name;
						else 
							nameDisplay = " No Name";
						end

						local targetDisplay;
						local hisTarget = tostring(nNova[BadBoy_data.engineActualRow+i].target) or " |cff00F2FFNo Target";
						if UnitName(hisTarget) ~= nil then targetDisplay = "|cff00F2FF "..UnitName(hisTarget) else targetDisplay = " |cff00F2FFNo Target" end
						engineName = healthDisplay..nameDisplay..targetDisplay
					else
						engineName = "";
					end

					if _G["engine"..i.."Frame"]:IsShown() ~= 1 then
						_G["engine"..i.."Text"]:Show();
						_G["engine"..i.."Frame"]:Show();
					end

					_G["engine"..i.."Text"]:SetText(engineName, 1, 1, 1, 0.7);

				end
				for i = BadBoy_data.engineRows+1, 25 do
					if _G["engine"..i.."Frame"]:IsShown() == 1 then
						_G["engine"..i.."Text"]:Hide();
						_G["engine"..i.."Frame"]:Hide();
					end
				end
			end
			
			engineFrame:SetHeight((BadBoy_data.engineRows*20)+20);
		end
		engineFrame.texture:SetAlpha(BadBoy_data.engineAlpha/100);
		for i = 1, 25 do 
			if _G["engine"..i.."Frame"]:GetAlpha() ~= BadBoy_data.engineAlpha/100 then
				_G["engine"..i.."Frame"]:SetAlpha(BadBoy_data.engineAlpha/100);
				engineFrameText:SetAlpha(BadBoy_data.engineAlpha/100);
			end
		end
		engineFrameText:SetWidth(BadBoy_data.engineWidth);
		engineFrame:SetWidth(BadBoy_data.engineWidth);
		for i = 1, 25 do 
			if _G["engine"..i.."Frame"]:GetWidth() ~= BadBoy_data.engineWidth then
				_G["engine"..i.."Frame"]:SetWidth(BadBoy_data.engineWidth);
			end
			if _G["engine"..i.."Text"]:GetWidth() ~= BadBoy_data.engineWidth then
				_G["engine"..i.."Text"]:SetWidth(BadBoy_data.engineWidth);
			end
		end
    	engineFrameLoaded = true;
    	engineRefresh();
	end
end