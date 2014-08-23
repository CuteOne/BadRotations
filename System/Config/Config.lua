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
		configFrame:SetWidth(250);
		configFrame:SetHeight(30);
		configFrame.texture = configFrame:CreateTexture(configFrame, "ARTWORK");
		configFrame.texture:SetAllPoints();
		configFrame.texture:SetWidth(BadBoy_data.configWidth);
		configFrame.texture:SetHeight(30);
		configFrame.texture:SetAlpha(BadBoy_data.configAlpha/100);
		configFrame.texture:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]]);
		CreateBorder(configFrame, 8, 0.6, 0.6, 0.6, 3, 3, 3, 3, 3, 3, 3, 3 )
    CreateBorder(myFrame, borderSize, r, g, b, uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2)
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
		configFrameExitButton:SetText(" X");

		configFrameExitButton:SetScript("OnClick", function()
			BadBoy_data.configShown = false;
			configFrame:Hide()
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
		configFrameText:SetFont("Fonts/FRIZQT__.TTF",17,"THICKOUTLINE");
		configFrameText:SetTextHeight(17);
		configFrameText:SetPoint("TOPLEFT",28, 0);
		configFrameText:SetTextColor(225/255, 225/255, 225/255,1);

	    doneConfig = true;
		SetConfigWidth(BadBoy_data.configWidth);
		if BadBoy_data["configShown"] ~= true then configFrame:Hide(); end
	end
end


function CreateGeneralsConfig()

    -- Wrapper -----------------------------------------
    CreateNewWrap(thisConfig,"--- Healing Engine ----");

    -- Heal Pets
    CreateNewCheck(thisConfig,"Heal Pets");
    CreateNewText(thisConfig,"Heal Pets");

    -- Special Heal
    CreateNewCheck(thisConfig,"Special Heal");
    CreateNewDrop(thisConfig,"Special Heal", 2, "|cffFFDD11Select wich targets you want to add to engine:Mouseover/Focus/Target Heal. \n|cffFF0000All: |cffFFDD11All targets. \n|cffFF0000Special: |cffFFDD11Only special Units.", "|cffFF0000All", "|cffFFDD11Special")
    CreateNewText(thisConfig,"Special Heal");

    -- Special Priority
    CreateNewCheck(thisConfig,"Special Priority","|cffFFBB00Priorise Special targets.");     
    CreateNewText(thisConfig,"Special Priority");

    -- Blacklist
    CreateNewCheck(thisConfig,"Blacklist");
    CreateNewBox(thisConfig, "Blacklist", 0, 105  , 5, 105, "|cffFFBB00How much |cffFF0000%HP|cffFFBB00 do we want to add to |cffFFDD00Blacklisted |cffFFBB00units.");
    CreateNewText(thisConfig,"Blacklist");

    -- No Absorbs
    CreateNewCheck(thisConfig,"No Absorbs","Uncheck this if you want to prevent overhealing shielded units. If checked, it will add shieldBuffValue/4 to hp.");
    CreateNewText(thisConfig,"No Absorbs"); 

    -- No Incoming Heals
    CreateNewCheck(thisConfig,"No Incoming Heals","Uncheck this if you want to prevent overhealing units. If checked, it will add incoming health from other healers to hp.");
    CreateNewText(thisConfig,"No Incoming Heals");

    -- Overhealing Cancel Cast
    CreateNewCheck(thisConfig,"Overhealing Cancel");       
    CreateNewBox(thisConfig, "Overhealing Cancel", 100, 200  , 5, 100, "|cffFFBB00Stop casting heal if target is going to have over this amount of HP after heal.");
    CreateNewText(thisConfig,"Overhealing Cancel");

    -- Engine Debug
    CreateNewCheck(thisConfig,"Engine Debug");       
    CreateNewText(thisConfig,"Engine Debug");

    -- Engine Refresh
    CreateNewCheck(thisConfig,"Engine Refresh");       
    CreateNewBox(thisConfig, "Engine Refresh", 0, 1000  , 5, 0, "|cffFFBB00Time to wait before refreshing engine.");
    CreateNewText(thisConfig,"Engine Refresh");
	
    -- Wrapper -----------------------------------------
    CreateNewWrap(thisConfig,"--------- General -------");

    -- Auto-Sell/Repair
    CreateNewCheck(thisConfig,"Auto-Sell/Repair");
    CreateNewText(thisConfig,"Auto-Sell/Repair");

    -- Accept Queues
    CreateNewCheck(thisConfig,"Accept Queues");
    CreateNewText(thisConfig,"Accept Queues");

    -- PokeRotation
    CreateNewCheck(thisConfig,"PokeRotation", "|cffFFBB00Check this to start PokeRotation.");
    CreateNewText(thisConfig,"PokeRotation");

    -- Debug
    CreateNewCheck(thisConfig,"Debug", "|cffFFBB00Check this to start |cffFFFFFFChat Debug |cffFFBB00of casted spells.");
    CreateNewText(thisConfig,"Debug");

   -- Bound
    CreateNewBound(thisConfig,"End"); 
    doneConfig = true;
end