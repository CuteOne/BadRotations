function ConfigFrame()

	--BadBoy_data.options = { }
	--BadBoy_data.version = 0.03
	if not doneConfig then

		function ClearConfig()  
			if thisConfig ~= nil and doneConfig == true then
		        for i = 1, thisConfig do
		            DeleteRow(i)
		        end
		    end
		end

		if BadBoy_data.configWidth == nil then BadBoy_data.configWidth = 250; end
		if BadBoy_data.configAlpha == nil then BadBoy_data.configAlpha = 0.90; end
		-- Config Frame
		configHeight = 30
		configFrame = CreateFrame("Frame", nil, UIParent);
		--configFrame:SetAlpha(1);
		configFrame:SetWidth(250);
		configFrame:SetHeight(30);
		configFrame.texture = configFrame:CreateTexture(configFrame, "ARTWORK");
		configFrame.texture:SetAllPoints();
		configFrame.texture:SetWidth(BadBoy_data.configWidth);
		configFrame.texture:SetHeight(30);
		configFrame.texture:SetAlpha(BadBoy_data.configAlpha/100);
		configFrame.texture:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]]);

		function SetConfigWidth(Width)
			BadBoy_data.configWidth = Width
			configFrame:SetWidth(Width);
		end

		configFrame:SetScript("OnMouseWheel", function(self, delta)
			if IsAltKeyDown() then
				local Go = false;
				if delta < 0 and BadBoy_data.configAlpha > 0 then
					Go = true;
				elseif delta > 0 and BadBoy_data.configAlpha < 100 then
					Go = true;
				end
				if Go == true then
					BadBoy_data.configAlpha = BadBoy_data.configAlpha + (delta*5)
					configFrame.texture:SetAlpha(BadBoy_data.configAlpha/100);
				end
			else
				local Go = false;
				if delta < 0 and BadBoy_data.configWidth > 200 then
					Go = true;
				elseif delta > 0 and BadBoy_data.configWidth < 500 then
					Go = true;
				end
				if Go == true then
					SetConfigWidth(BadBoy_data.configWidth + delta*2)
				end
			end
		end)

		configFrame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "BOTTOMLEFT", 250, 5);
			GameTooltip:SetText("|cffD60000Roll mouse to adjust width.\n|cffFFFFFFLeft Click/Hold to move.\n|cffFFDD11Alt+Roll to adjust Config Alpha.", nil, nil, nil, nil, true);
			GameTooltip:Show();
		end)
		configFrame:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end)

		configFrame:SetPoint(BadBoy_data.configanchor,BadBoy_data.configx,BadBoy_data.configy);
		configFrame:SetClampedToScreen(true);
		configFrame:SetScript("OnUpdate", configFrame_OnUpdate);
		configFrame:EnableMouse(true);
		configFrame:SetMovable(true);
		configFrame:SetClampedToScreen(true);
		configFrame:RegisterForDrag("LeftButton");
		configFrame:SetScript("OnDragStart", configFrame.StartMoving);
		configFrame:SetScript("OnDragStop", configFrame.StopMovingOrSizing);

		configFrameExitButton = CreateFrame("CheckButton", "MyButton", configFrame, "UIPanelButtonTemplate");
		configFrameExitButton:SetAlpha(0.80);
		configFrameExitButton:SetWidth(21);
		configFrameExitButton:SetHeight(21);
		configFrameExitButton:SetPoint("TOPRIGHT", -3 , -3);
		configFrameExitButton:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
		configFrameExitButton:RegisterForClicks("AnyUp");
		configFrameExitButton:SetText("X");

		configFrameExitButton:SetScript("OnClick", function()
			BadBoy_data.configShown = false;
		end )

		configFrameExitButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "BOTTOMRIGHT", 0, 5);
			GameTooltip:SetText("|cffD60000Close Config.", nil, nil, nil, nil, true);
			GameTooltip:Show();
		end)
		configFrameExitButton:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end)

		configFrameText = configFrame:CreateFontString(nil, "ARTWORK");
		configFrameText:SetFontObject("QuestTitleFontBlackShadow",17,"THICKOUTLINE");
		configFrameText:SetTextHeight(17);
		configFrameText:SetPoint("TOPLEFT",28, 0);
		configFrameText:SetTextColor(225/255, 225/255, 225/255,1);

		if BadBoy_data.configShown == false then configFrame:Hide(); else configFrame:Show(); end

	    doneConfig = true;
		SetConfigWidth(BadBoy_data.configWidth);
	end
end


