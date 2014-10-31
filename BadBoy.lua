function BadBoyRun()


	rc = LibStub("LibRangeCheck-2.0")
	minRange, maxRange = rc:GetRange('target')

	if BadBoy_data == nil then BadBoy_data = {
		["Power"] = 1,
		["Currentconfig"] = " ",
		["Pause"] = 0,
		["frameShown"] = true,
		["anchor"] = "BOTTOM",
		["x"] = -20,
		["y"] = 130.0000061548516,
		["configShown"] = true,
		["configanchor"] = "RIGHT",
		["configx"] = -140,
		["configy"] = -135,
		["configWidth"] = 250,
		["configAlpha"] = 90,


		["AoE"] = 3,
		["Cooldowns"] = 2,
		["Defensive"] = 1,
		["Interrupts"] = 1,

		["Check Engine Debug"] = 0,
		["Check Debug"] = 0,
		["Check PokeRotation"] = 0,
		["successCasts"] = 0,
		["failCasts"] = 0,
		["Check PokeRotation"] = 0,
		["engineAlpha"] = 90,
		["debugAlpha"] = 90,
	};
	end

	--[[These are there to make sure we do not startup with hacks from previous session.]]
	BadBoy_data["Check Fly Hack"] = 0;
	BadBoy_data["Check Hover Hack"] = 0;
	BadBoy_data["Check Water Walking"] = 0;
	BadBoy_data["Check Climb Hack"] = 0;
	BadBoy_data["Check Track Attackable"] = 0;

	--[[Init the readers codes (System/Reader.lua)]]
	ReaderRun();
	-- Globals
	classColors = {
		[1]				= {class = "Warrior", 	B=0.43,	G=0.61,	R=0.78,	hex="|cffc79c6e"},
		[2]				= {class = "Paladin", 	B=0.73,	G=0.55,	R=0.96,	hex="|cfff58cba"},
		[3]				= {class = "Hunter",	B=0.45,	G=0.83,	R=0.67,	hex="|cffabd473"},
		[4]				= {class = "Rogue",		B=0.41,	G=0.96,	R=1,	hex="|cfffff569"},
		[5]				= {class = "Priest",	B=1,		G=1,	R=1,	hex="|cffffffff"},
		[6]				= {class = "Deathknight",B=0.23,	G=0.12,	R=0.77,	hex="|cffc41f3b"},
		[7]				= {class = "Shaman",	B=0.87,	G=0.44,	R=0,	hex="|cff0070de"},
		[8]				= {class = "Mage",		B=0.94,	G=0.8,	R=0.41,	hex="|cff69ccf0"},
		[9]				= {class = "Warlock", 	B=0.79,	G=0.51,	R=0.58,	hex="|cff9482c9"},
		[10]			= {class = "Monk",		B=0.59,	G=1,	R=0,	hex="|cff00ff96"},
		[11]			= {class = "Druid", 	B=0.04,	G=0.49,	R=1,	hex="|cffff7d0a"},
		["Black"]		= {B=0.1, 	G=0.1,	R=0.12,	hex="|cff191919"},
		["Hunter"]		= {B=0.45,	G=0.83,	R=0.67,	hex="|cffabd473"},
		["Gray"]		= {B=0.2,	G=0.2,	R=0.2,	hex="|cff333333"},
		["Warrior"]		= {B=0.43,	G=0.61,	R=0.78,	hex="|cffc79c6e"},
		["Paladin"] 	= {B=0.73,	G=0.55,	R=0.96,	hex="|cfff58cba"},
		["Mage"]		= {B=0.94,	G=0.8,	R=0.41,	hex="|cff69ccf0"},
		["Priest"]		= {B=1,		G=1,	R=1,	hex="|cffffffff"},
		["Warlock"]		= {B=0.79,	G=0.51,	R=0.58,	hex="|cff9482c9"},
		["Shaman"]		= {B=0.87,	G=0.44,	R=0,	hex="|cff0070de"},
		["DeathKnight"]	= {B=0.23,	G=0.12,	R=0.77,	hex="|cffc41f3b"},
		["Druid"]		= {B=0.04,	G=0.49,	R=1,	hex="|cffff7d0a"},
		["Monk"]		= {B=0.59,	G=1,	R=0,	hex="|cff00ff96"},
		["Rogue"]		= {B=0.41,	G=0.96,	R=1,	hex="|cfffff569"}
	}
	qualityColors = {
		blue = "0070dd",
		green = "1eff00",
		white = "ffffff",
		grey = "9d9d9d"
	}

	---------------------------------
	-- Macro Toggle ON/OFF
	SLASH_BadBoy1 = "/BadBoy"
	function SlashCmdList.BadBoy(msg, editbox, ...)
		print(...)
		mainButton:Click();
	end

	SLASH_AoE1 = "/aoe"
	function SlashCmdList.AoE(msg, editbox)
		ToggleValue("AoE");
	end

	SLASH_FHStop1 = "/fhstop"
	function SlashCmdList.FHStop(msg, editbox)
		StopFalling();
		StopMoving();
	end

	SLASH_Cooldowns1 = "/Cooldowns"
	function SlashCmdList.Cooldowns(msg, editbox)
		ToggleValue("Cooldowns");
	end

	SLASH_DPS1 = "/DPS"
	function SlashCmdList.DPS(msg, editbox)
		ToggleValue("DPS");
	end

	SLASH_BlackList1, SLASH_BlackList2 = "/blacklist", "/bbb"
	function SlashCmdList.BlackList(msg, editbox)
		if BadBoy_data.blackList == nil then BadBoy_data.blackList = { }; end

		if msg == "dump" then
			print("|cffFF0000BadBoy Blacklist:");
			if #BadBoy_data.blackList == (0 or nil) then print("|cffFFDD11Empty"); end
			if BadBoy_data.blackList then
				for i = 1, #BadBoy_data.blackList do
					print("|cffFFDD11- "..BadBoy_data.blackList[i].name)
				end
			end
		elseif msg == "clear" then
			BadBoy_data.blackList = { }
			print("|cffFF0000BadBoy Blacklist Cleared");
		else
			if UnitExists("mouseover") then
				local mouseoverName = UnitName("mouseover");
				local mouseoverGUID = UnitGUID("mouseover");
				-- Now we're trying to find that unit in the blackList table to remove
				local found;
				for k,v in pairs(BadBoy_data.blackList) do
					-- Now we're trying to find that unit in the Cache table to remove
					if UnitGUID("mouseover") == v.guid then
						tremove(BadBoy_data.blackList, k)
						print("|cffFFDD11"..mouseoverName.."|cffFF0000 Removed from Blacklist");
						found = true
						--blackList[k] = nil;
					end
				end
				if not found then
					print("|cffFFDD11"..mouseoverName.."|cffFF0000 Added to Blacklist");
					tinsert(BadBoy_data.blackList, { guid = mouseoverGUID, name = mouseoverName});
				end
			end
		end
	end

	SLASH_Pause1 = "/Pause"
	function SlashCmdList.Pause(msg, editbox)
		if BadBoy_data['Pause'] == 0 then
	        ChatOverlay("\124cFFED0000 -- Paused -- ");
			BadBoy_data['Pause'] = 1;
		else
	        ChatOverlay("\124cFF3BB0FF -- Pause Removed -- ");
			BadBoy_data['Pause'] = 0;
		end
	end

	SLASH_Power1 = "/Power"
	function SlashCmdList.Power(msg, editbox)
		if BadBoy_data['Power'] == 0 then
	        ChatOverlay("\124cFF3BB0FF -- BadBoy Enabled -- ");
			BadBoy_data['Power'] = 1;
		else
	        ChatOverlay("\124cFFED0000 -- BadBoy Disabled -- ");
			BadBoy_data['Power'] = 0;
		end
	end

	function GetSpellCD(MySpell)
		if GetSpellCooldown(MySpell) == 0 then
			return 0
		else
			local Start ,CD = GetSpellCooldown(MySpell)
			local MyCD = Start + CD - GetTime()
			return MyCD
		end
	end
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

	--[[This function is refired everytime wow ticks. This frame is located in Core.lua]]
	function FrameUpdate(self)
		--UsefulFeatures();

		if randomReady == nil then randomReady = math.random(8,15); end
		if readyToAccept and readyToAccept <= GetTime() - 5 then AcceptProposal(); readyToAccept = nil; randomReady = nil; end
		PokeEngine();
		-- global vars
		targetDistance = getDistance("target") or 0;
		displayDistance = math.floor(targetDistance*100)/100
		mainText:SetText(displayDistance);
		profileStarts = GetTime();
		--interruptsRefresh();


		--if currentTarget ~= nil then ISetAsUnitID(currentTarget,"current"); end

		if NovaEngineUpdate == nil then NovaEngineUpdate = GetTime(); end
		if NovaEngineUpdate and NovaEngineUpdate <= GetTime() - getValue("Engine Refresh")/1000 then
			NovaEngineUpdate = GetTime()
			nNova:Update()
			engineRefresh()
		end

		--[[Updating UI location]]
		local _, _, anchor, x, y = configFrame:GetPoint(1);
		BadBoy_data.configx = x;
		BadBoy_data.configy = y;
		BadBoy_data.configanchor = anchor;

		local _, _, anchor, x, y = debugFrame:GetPoint(1);
		BadBoy_data.debugx = x;
		BadBoy_data.debugy = y;
		BadBoy_data.debuganchor = anchor;

		local _, _, anchor, x, y = engineFrame:GetPoint(1);
		BadBoy_data.enginex = x;
		BadBoy_data.enginey = y;
		BadBoy_data.engineanchor = anchor;

		if BadBoy_data["Check Debug"] == 1 then
			debugFrame:Show();
		else
			debugFrame:Hide();
		end

		if BadBoy_data["Check Engine Debug"] == 1 then
			engineFrame:Show();
		else
			engineFrame:Hide();
		end

		--if BadBoy_data["Check Interrupts Frame"] == 1 then
		--	interruptsFrame:Show();
		--else
		--	interruptsFrame:Hide();
		--end

		--[[Class/Spec Selector]]
		local _MyClass = select(3,UnitClass("player"));
		local _MySpec = GetSpecialization();
		if _MyClass == 1 then -- Warrior
			if _MySpec == 2 then
				FuryWarrior()
			elseif _MySpec == 3 then
				ProtectionWarrior()
			else
				ArmsWarrior()

			end
		elseif _MyClass == 2 then -- Paladin
			if _MySpec == 1 then
				PaladinHoly();
			elseif _MySpec == 2 then
				PaladinProtection();
			elseif _MySpec == 3 then
				PaladinRetribution();
			end
		elseif _MyClass == 3 then -- Hunter
			if _MySpec == 1 then
				BeastHunter();
			elseif _MySpec == 2 then
				MarkHunter();
			else
				SurvHunter();
			end
		elseif _MyClass == 4 then -- Rogue
			if _MySpec == 1 then
				AssassinationRogue();
			elseif _MySpec == 2 then
				CombatRogue();
			else
				SubRogue();
			end
		elseif _MyClass == 5 then -- Priest
			if _MySpec == 3 then
				PriestShadow();
			end
		elseif _MyClass == 6 then -- Deathknight
			if _MySpec == 1 then
				Blood();
			end
			if _MySpec == 2 then
				FrostDK();
			end
		elseif _MyClass == 7 then -- Shaman
			if _MySpec == 1 then
				ShamanElemental();
			end
			if _MySpec == 2 then
				ShamanEnhancement();
			end
			if _MySpec == 3 then
				ShamanRestoration();
			end
		elseif _MyClass == 8 then -- Mage
			if _MySpec == 1 then
				ArcaneMage();
			end
			if _MySpec == 2 then
				FireMage();
			end
			if _MySpec == 3 then
				FrostMage();
			end
		elseif _MyClass == 9 then -- Warlock
			if _MySpec == 2 then
				WarlockDemonology();
			elseif _MySpec == 3 then
				WarlockDestruction();
			end
		elseif _MyClass == 10 then -- Monk
			if _MySpec == nil then
				NewMonk();
			end
			if _MySpec == 1 then
				BrewmasterMonk();
			elseif _MySpec == 2 then
				MistweaverMonk();
			elseif _MySpec == 3 then
				WindwalkerMonk();
			end
		elseif _MyClass == 11 then -- Druid
			if _MySpec == 1 then
				DruidMoonkin();
			end
			if _MySpec == 2 then
				DruidFeral();
			end
			if _MySpec == 3 then
				DruidGuardian();
			end
			if _MySpec == 4 then
				DruidRestoration();
			end
		end
	end

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

	BadBoyEngine();
	BadBoyMinimapButton();
	BadBoyFrame();
	ConfigFrame();
	DebugFrameCreation();
	EngineFrameCreation();
	--InterruptsFrameCreation();
	ChatOverlay("-= BadBoy Loaded =-")
end