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
		-- Config Frame
		configHeight = 30
		configFrame = CreateFrame("Frame", nil, UIParent);
		configFrame:SetFrameStrata("BACKGROUND")
		configFrame:SetAlpha(1);
		configFrame:SetWidth(250);
		configFrame:SetHeight(30);
		configFrame.textureTopLeft = configFrame:CreateTexture(configFrame, "ARTWORK");
		configFrame.textureTopLeft:SetAllPoints();
		configFrame.textureTopLeft:SetWidth(BadBoy_data.configWidth);
		configFrame.textureTopLeft:SetHeight(30);
		configFrame.textureTopLeft:SetAlpha(0.90);
		--configFrame.texture:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]],0.25);
		configFrame.textureTopLeft:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]],0.25);

		function SetConfigWidth(Width)
			BadBoy_data.configWidth = Width
			configFrame:SetWidth(Width);
		end

		configFrame:SetScript("OnMouseWheel", function(self, delta)
			local Go = false;
			if delta < 0 and BadBoy_data.configWidth > 200 then
				Go = true;
			elseif delta > 0 and BadBoy_data.configWidth < 500 then
				Go = true;
			end
			if Go == true then
				SetConfigWidth(BadBoy_data.configWidth + delta*2)
			end
		end)

		--configFrame.texture:SetTexture(25/255,25/255,25/255,1);
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


