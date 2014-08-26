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

    -- Overlay Messages
    CreateNewCheck(thisConfig,"Overlay Messages", "|cffFFBB00Check this to enable Chat Overlay Messages.");
    CreateNewText(thisConfig,"Overlay Messages");

    -- Debug
    CreateNewCheck(thisConfig,"Debug", "|cffFFBB00Check this to start |cffFFFFFFChat Debug |cffFFBB00of casted spells.");
    CreateNewText(thisConfig,"Debug");

    -- Wrapper -----------------------------------------
    CreateNewWrap(thisConfig,"----- PokeRotation -----");

    -- PokeRotation
    CreateNewCheck(thisConfig,"PokeRotation", "|cffFFBB00Check this to start PokeRotation.");
    CreateNewText(thisConfig,"PokeRotation");

	CreateNewText(thisConfig,"In Battle");

	--PetHealValue				= 65
	CreateNewCheck(thisConfig,"Pet Heal");
	CreateNewBox(thisConfig, "Pet Heal", 1, 100  , 5, 60, "|cffFFBB00Set pet healing value");
	CreateNewText(thisConfig,"Pet Heal");

	--CaptureValue				= 4
	CreateNewCheck(thisConfig,"Pet Capture");
	CreateNewBox(thisConfig, "Pet Capture", 1, 4  , 1, 4, "|cffFFBB00Set pet Rarity Capture Treshold");
	CreateNewText(thisConfig,"Pet Capture");

	--NumberOfPetsValue			= 1
	CreateNewBox(thisConfig, "Number of Pets", 1, 3  , 1, 1, "|cffFFBB00Set number of pets of each kind to capture");
	CreateNewText(thisConfig,"Number of Pets");

	CreateNewText(thisConfig,"Out of Battle");

	--ReviveBattlePetsValue		= 1
	CreateNewCheck(thisConfig,"Revive Battle Pets");
	CreateNewText(thisConfig,"Revive Battle Pets");

	--AutoClickerValue			= 1
	CreateNewCheck(thisConfig,"Auto Clicker Range");
	CreateNewBox(thisConfig, "Auto Clicker Range", 0, 200  , 5, 30, "|cffFFBB00Set Auto Clicker range.");
	CreateNewText(thisConfig,"Auto Clicker Range");

	--PetLevelingValue			= 6
	CreateNewCheck(thisConfig,"Pet Leveling");
	CreateNewBox(thisConfig, "Pet Leveling", 1, 25  , 1, 6, "|cffFFBB00Pet Leveling minimum pet level");
	CreateNewText(thisConfig,"Pet Leveling");

	--PetLevelingValue			= 6
	CreateNewCheck(thisConfig,"Pet Leveling Max");
	CreateNewBox(thisConfig, "Pet Leveling Max", 1, 25  , 1, 6, "|cffFFBB00Pet Leveling maximum pet level");
	CreateNewText(thisConfig,"Pet Leveling Max");

	--LevelingPriorityValue 		= 3
	CreateNewCheck(thisConfig,"Leveling Priority");
	CreateNewBox(thisConfig, "Leveling Priority", 1, 4  , 1, 4, "|cffFFBB00Set Leveling Priority");
	CreateNewText(thisConfig,"Leveling Priority");

	--LevelingRarityValue 		= 4
	CreateNewCheck(thisConfig,"Leveling Rarity");
	CreateNewBox(thisConfig, "Leveling Rarity", 1, 4  , 1, 4, "|cffFFBB00Set Leveling Rarity");
	CreateNewText(thisConfig,"Leveling Rarity");

	--SwapInHealthValue			= 65
	CreateNewCheck(thisConfig,"Swap in Health");
	CreateNewBox(thisConfig, "Swap in Health", 1, 100  , 1, 60, "|cffFFBB00Minimum Health to Swap Pet in.");
	CreateNewText(thisConfig,"Swap in Health");

	--SwapOutHealthValue			= 35
	CreateNewBox(thisConfig, "Swap Out Health", 1, 100  , 1, 30, "|cffFFBB00Set Swap Out Health Treshold");
	CreateNewText(thisConfig,"Swap Out Health");

	-- Pause Toggle
    CreateNewCheck(thisConfig,"Pause Toggle");
    CreateNewDrop(thisConfig,"Pause Toggle", 4, "Toggle2")
    CreateNewText(thisConfig,"Pause Toggle"); 










   -- Bound
    CreateNewBound(thisConfig,"End"); 
    doneConfig = true;
end














--[[



if CODEMYLIFE_POKEROTATION == nil then
	PQIconfig = {
		name	= "PokeRotation",
		author	= "CodeMyLife",
		abilities = {
		
			{	name = "Objective",
				enable = true,
				tooltip = "|cffFFFFFFWhat's your primary objective.",
				widget = { type = 'select',
					values = {"Pet Leveling","PvP","Beasts of Fables","Masters"},
					value = 1,
					tooltip = "|cffFFFFFFSelect one!",
					width  = 110,
				},
			},
			
			---- Pet Healing  ----
			{ 	name	= "Pet Heal",
				enable	= true,
				tooltip	= "|cffFFFFFFIn Battle - |cff33CCFFMinimum pet |cffFFFFFFHealth Value |cff33CCFFto use their |cffFFFFFFhealing Abilities|cff33CCFF.",
				widget	= { type = "numBox",
					value	= 70,
					step	= 5,
					tooltip	= "|cffFFFFFFIn Battle - |cff33CCFFMinimum pet |cffFFFFFFHealth Value |cff33CCFFto use their |cffFFFFFFhealing Abilities|cff33CCFF.",
				},
			},
				
			----  Swap Out Treshold  ----
			{ 	name	= "Swap Out Health",
				enable	= true,
				tooltip	= "|cffFFFFFFIn Battle - |cff33CCFFMinimum pet |cffFFFFFFHealth Value |cff33CCFFto |cffFFFFFFSwap-out pet 1 and 2|cff33CCFF. |cffFFFFFFPet 3 will always fight until death|cff33CCFF.",
				widget	= { type = "numBox",
					value	= 25,
					step	= 5,
					tooltip	= "|cffFFFFFFIn Battle - |cff33CCFFMinimum pet |cffFFFFFFHealth Value |cff33CCFFto |cffFFFFFFSwap-Out Pets|cff33CCFF.",
				},
			},
			
			----  Swap In Treshold  ----
			{ 	name	= "Swap In Health",
				enable	= true,
				tooltip	= "|cffFFFFFFIn Battle - |cff33CCFFCheck to |cffFFFFFFActivate Pet Switching|cff33CCFF.",
				widget	= { type = "numBox",
					value	= 35,
					step	= 5,
					tooltip	= "|cffFFFFFFIn Battle - |cff33CCFFMinimum |cffFFFFFFHealth to |cffFFFFFFSwap Pets In|cff33CCFF.",
				},
			},
			
			----  Capture Treshold  ----
			{ 	name	= "Capture",
				enable	= true,
				tooltip	= "|cffFFFFFFIn Battle - |cff33CCFFMinimum pet rarity to Capture: |cff"..(RarityColorsTable[1].Color).."1-Poor |cff"..(RarityColorsTable[2].Color).."2-Common |cff"..(RarityColorsTable[3].Color).."3-Uncommon |cff"..(RarityColorsTable[4].Color).."4-Rare.",
				widget = { type = 'select',
					values = {"|cff"..(RarityColorsTable[1].Color).."Poor","|cff"..(RarityColorsTable[2].Color).."Common","|cff"..(RarityColorsTable[3].Color).."Uncommun","|cff"..(RarityColorsTable[4].Color).."Rare"},
					value = 4,
					tooltip = "|cffFFFFFFIn Battle - |cff33CCFFMinimum pet rarity to Capture: |cff"..(RarityColorsTable[1].Color).."1-Poor |cff"..(RarityColorsTable[2].Color).."2-Common |cff"..(RarityColorsTable[3].Color).."3-Uncommon |cff"..(RarityColorsTable[4].Color).."4-Rare.",
					width  = 80,
					
				},
				newSection = true,	
			},
			
			----  Number of Pets to Capture  ----
			{ 	name	= "Number Of Pets",
				enable	= true,
				tooltip	= "|cffFFFFFFIn Battle - |cff33CCFFCheck to |cffFFFFFFManage How Many Pets of Each Kind |cff33CCFFyou want to |cffFFFFFFCapture|cff33CCFF.",
				widget	= { type = "numBox",
					min		= 1,
					max		= 3,
					value	= 1,
					step	= 1,
					tooltip	= "|cffFFFFFFIn Battle - |cff33CCFFHow Many |cffFFFFFFPets of Each Kind do you want to |cffFFFFFFCapture|cff33CCFF.",
				},
			},
			
			----  Revive Battle Pets ----
			{ 	name	= "Revive Battle Pets",
				enable	= true,
				tooltip	= "|cffFFFFFFOut of Battle - |cff33CCFFCheck to |cffFFFFFFActivate Revive Battle Pets|cff33CCFF..",
				widget	= { type = "numBox",
					value	= 70,
					step	= 5,
					tooltip	= "|cffFFFFFFOut of Battle - |cff33CCFFMinimum |cffFFFFFFTeam Health Value |cff33CCFFto use |cffFFFFFFRevive Battle Pets|cff33CCFF.",
				},
				newSection = true,
			},
			
			----  Pet Leveling  ----		    
		    { 	name	= "Pet Leveling",
				tooltip	= "|cffFFFFFFIn Battle - |cff33CCFFCheck this to |cffFFFFFFMake your Pet in Slot 1 Level Quick. It will interact only once |cff33CCFFand hide behind other pets.",
				enable	= true,
				widget	= { type = "numBox",
					min		= 1,
					max		= 25,
					value	= 25,
					step	= 1,
					tooltip	= "|cffFFFFFFIn Battle - |cff33CCFFSet this value to the |cffFFFFFFlevel |cff33CCFFyou want |cffFFFFFFto consider the pet high level enough to fight|cffFF0000(cancels Pet Leveling).",
				},
			},
			
			----  Leveling Priority  ----
			{ 	name	= "Leveling Priority",
				enable	= true,
				tooltip	= "|cffFFFFFFOut of Battle - |cff33CCFFChoose the desired Table sorting for Pet Leveling",
				widget = { type = 'select',
					values = {"|cff"..(RarityColorsTable[3].Color).."Low Level","|cffFF0000High Level","|cffFFFFFFNon-Wilds|cff33CCFF/|cff"..(RarityColorsTable[3].Color).."Low Level","|cffFFFFFFNon-Wilds|cff33CCFF/|cffFF0000HighLevel"},
					value = 3,
					tooltip = "|cff"..(RarityColorsTable[3].Color).."Low Level |cff33CCFFwill add priority to |cff"..(RarityColorsTable[3].Color).."Low Level Pets. |cffFFFFFFNon-Wild |cff33CCFFwill add priority to |cffFFFFFFNon-Wild Pets. |cffFFFFFFFavorite |cff33CCFFis |cffFFFFFFTop Priority |cff33CCFFby |cffFFFFFFDefault.",
					width  = 120,
					
				},	
			},
			
			----  Leveling Rarity  ----
			{ 	name	= "Leveling Rarity",
				enable	= true,
				tooltip	= "|cffFFFFFFOut of Battle - |cff33CCFFMinimum pet rarity to Level: |cff"..(RarityColorsTable[1].Color).."1-Poor |cff"..(RarityColorsTable[2].Color).."2-Common |cff"..(RarityColorsTable[3].Color).."3-Uncommon |cff"..(RarityColorsTable[4].Color).."4-Rare.",
				widget = { type = 'select',
					values = {"|cff"..(RarityColorsTable[1].Color).."Poor","|cff"..(RarityColorsTable[2].Color).."Common","|cff"..(RarityColorsTable[3].Color).."Uncommun","|cff"..(RarityColorsTable[4].Color).."Rare"},
					value = 4,
					tooltip = "|cffFFFFFFIn Battle - |cff33CCFFMinimum pet rarity to Level: |cff"..(RarityColorsTable[1].Color).."1-Poor |cff"..(RarityColorsTable[2].Color).."2-Common |cff"..(RarityColorsTable[3].Color).."3-Uncommon |cff"..(RarityColorsTable[4].Color).."4-Rare.",
					width  = 80,
					
				},	
			},
			
			----  Pet Swapper  ----
			{ 	name	= "Pet Swap Max",
				enable	= true,
				tooltip	= "|cffFFFFFFOut of Battle - |cff33CCFFCheck to |cffFFFFFFActivate Pet Swapper|cff33CCFF.",
				widget	= { type = "numBox",
					min		= 2,
					max		= 25,
					value	= 25,
					step	= 1,
					tooltip	= "|cffFFFFFFOut of Battle - |cff33CCFFDesired |cffFFFFFFMaximum Slot 1 Level|cff33CCFF.",
				},
			},
			{ 	name	= "Pet Swap Min",
				enable	= true,
				tooltip	= "|cffFFFFFFOut of Battle - |cff33CCFFCheck to |cffFFFFFFActivate Pet Swapper|cff33CCFF.",
				widget	= { type = "numBox",
					min		= 1,
					max		= 25,
					value	= 1,
					step	= 1,
					tooltip	= "|cffFFFFFFOut of Battle - |cff33CCFFDesired |cffFFFFFFMinimum Slot 1 Level|cff33CCFF.",
				},
			},
			
			----  Auto Clicker  ----
			{ 	name = "Auto Clicker",
				enable = false,
				tooltip = "|cffFFFFFFOut of Battle - |cff33CCFFChase Pets!",
			 	widget = { type = 'txtbox', 
			    	value = '"Pet Name"', 
			   		width = 80,
					tooltip = "|cffFFFFFFOut of Battle - |cff33CCFFEnter the |cffFFFFFFExact Pet Name |cff33CCFFyou want |cffFFFFFFTo Chase|cff33CCFF.",
				},
				newSection = true,
			 },
			 
			 ----  Follower Distance  ----
			{ 	name = "Follower Distance",
				enable = false,
				tooltip = "|cffFFFFFFOut of Battle - |cff33CCFFActivate |cffFFFFFFFollower Max Distance|cff33CCFF.",
				widget	= { type = "numBox",
					min		= 10,
					max		= 300,
					value	= 30,
					step	= 10,
					tooltip	= "|cffFFFFFFOut of Battle - |cff33CCFFSet this value to the |cffFFFFFFRange |cff33CCFFyou want to |cffFFFFFF consider the pet close enough to follow it|cff33CCFF.",
				},
			},
			
			----  PvP  ----
			{ 	name	= "PvP",
				enable	= false,
				tooltip	= "|cffFFFFFFQueue for PvP Match|cff33CCFF.",
				widget	= { type = "numBox",
					min		= 1,
					max		= 3,
					value	= 1,
					step	= 1,
					tooltip	= "|cffFFFFFFPet Slot |cff33CCFFto use on |cffFFFFFFPvP Match Start|cff33CCFF.",
				},
				newSection = true,
			},
		},		
		
		----  Pause  ----
		hotkeys = {
			{	name	= "Pause",
				enable	= true,
				hotkeys	= {'la'},
				tooltip	= "|cff33CCFFAssign |cffFFFFFFPause |cff33CCFFKeybind.",
			},
		},
	}
	CODEMYLIFE_POKEROTATION = PQI:AddRotation(PQIconfig)
end]]