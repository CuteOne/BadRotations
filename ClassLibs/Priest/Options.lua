if select(3, UnitClass("player")) == 5 then

--[[         ]]		--[[           ]]	--[[           ]]	--[[           ]]
--[[          ]]		  --[[]]		--[[           ]]	--[[           ]]
--[[]]	   --[[]]		  --[[]]		--[[]]	   			--[[]]
--[[]]	   --[[]]		  --[[]]		--[[           ]]	--[[]]
--[[]]	   --[[]]		  --[[]]				   --[[]]	--[[]]
--[[          ]]		  --[[]]		--[[           ]]	--[[           ]]
--[[         ]] 	--[[           ]]	--[[           ]]	--[[           ]]

--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
--[[           ]]	--[[]]	   --[[]]	--[[]]					 --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]

--[[           ]]	--[[]]	   --[[]]		  --[[]]		--[[         ]]		--[[           ]]	--[[]] 	   --[[]]
--[[           ]]	--[[]]	   --[[]]	     --[[  ]]		--[[          ]]	--[[           ]]	--[[]] 	   --[[]]
--[[]]				--[[]]	   --[[]]	    --[[    ]] 		--[[]]	   --[[]]	--[[]]	   --[[]]	--[[ ]]   --[[ ]]
--[[           ]]	--[[           ]]	   --[[      ]] 	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[           ]]
		   --[[]] 	--[[]]	   --[[]] 	  --[[        ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[           ]]
--[[           ]]	--[[]]	   --[[]]	 --[[]]    --[[]]	--[[          ]]	--[[           ]]	--[[ ]]   --[[ ]]
--[[           ]]	--[[]]	   --[[]]	--[[]]      --[[]]	--[[         ]]		--[[           ]]	 --[[]]   --[[]]

	function ShadowConfig()
		if currentConfig ~= "Shadow ragnar" then
			ClearConfig();
			thisConfig = 0;
			-- Title
			CreateNewTitle(thisConfig,"shadow ravens   |cffBA55D3by ragnar");


			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"      |cffBA55D3Offensive");

				-- -- Min Orbs to cast DP on traditional single target
				-- CreateNewDrop(thisConfig,"Min Orbs (trad)",1,"Choose the minimum orbs to cast DP if targetHP>20.","|cffCC00003","|cFF00CC005");
				-- CreateNewText(thisConfig,"Min Orbs (trad)");

				-- -- only cast DP with 5 Orbs on traditional single rota
				-- CreateNewCheck(thisConfig,"DP5");
				-- CreateNewText(thisConfig,"DP only with 5 orbs");

				-- Power Infusion
				if isKnown(PI) then
					CreateNewCheck(thisConfig,"Power Infusion");
					CreateNewText(thisConfig,"Power Infusion");
				end

				-- Troll Racial
				if isKnown(Berserking) then
					CreateNewCheck(thisConfig,"Berserking");
					CreateNewText(thisConfig,"Berserking");
				end

				-- Shadowfiend / Mindbender
				if isKnown(Mindbender) then
					CreateNewCheck(thisConfig,"Mindbender");
					CreateNewText(thisConfig,"Mindbender");
				else
					CreateNewCheck(thisConfig,"Shadowfiend");
					CreateNewText(thisConfig,"Shadowfiend");
				end

				-- onUse Trinkets
					CreateNewCheck(thisConfig,"Trinket 1");
					CreateNewText(thisConfig,"Trinket 1");
					CreateNewCheck(thisConfig,"Trinket 2");
					CreateNewText(thisConfig,"Trinket 2");

				-- SWD Glyphed
				if hasGlyph(GlyphOfSWD) then
					CreateNewCheck(thisConfig,"SWD glyphed");
					CreateNewText(thisConfig,"SWD glyphed");
				end

				-- LR Orbs
				CreateNewCheck(thisConfig,"Scan for Orbs");
				CreateNewText(thisConfig,"Scan for Orbs");				


			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"      |cffBA55D3Defensive");

				-- Shield
				CreateNewCheck(thisConfig,"PW: Shield");
				CreateNewBox(thisConfig, "PW: Shield", 0,100,2,90, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFShield");
				CreateNewText(thisConfig,"PW: Shield");

				-- Healthstone
				CreateNewCheck(thisConfig,"Healthstone");
				CreateNewBox(thisConfig, "Healthstone", 0,100,2,25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
				CreateNewText(thisConfig,"Healthstone");

				-- Desperate Prayer
				if isKnown(DesperatePrayer) then
					CreateNewCheck(thisConfig,"Desperate Prayer");
					CreateNewBox(thisConfig, "Desperate Prayer", 0,100,2,30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDesperate Prayer");
					CreateNewText(thisConfig,"Desperate Prayer");
				end

				-- Dispersion
				CreateNewCheck(thisConfig,"Dispersion");
				CreateNewBox(thisConfig, "Dispersion", 0,100,2,20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDispersion");
				CreateNewText(thisConfig,"Dispersion");

				-- Fade DMG reduction (with glyph)
				if hasGlyph(GlyphOfFade) then
					CreateNewCheck(thisConfig,"Fade Glyph");
					CreateNewBox(thisConfig, "Fade Glyph", 0, 100  , 2, 80, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFade");
					CreateNewText(thisConfig,"Fade Glyph");
				end
				
				-- Fade (aggro reduction)
				CreateNewCheck(thisConfig,"Fade Aggro", "|cffFFBB00Fade on Aggression |cffFF0000(only in group or raid)");
				CreateNewText(thisConfig,"Fade Aggro");


			-- Wrapper -----------------------------------------
			if isKnown(CoP) then
				CreateNewWrap(thisConfig,"      |cffBA55D3DoT Weave");

					-- Secondary Target for Weave
					CreateNewBox(thisConfig,"secondaryTarget", 1, 5, 1, 5, "Choose the secondary Target (boss<x>).\nMin: 1 / Max: 5 / Interval: 1");
					CreateNewText(thisConfig,"Secondary Target");
					
					-- General
					--CreateNewCheck(thisConfig,"DoTWeave");
					--CreateNewText(thisConfig,"DoTWeave");
					-- SWP
					CreateNewCheck(thisConfig,"SWP");
					CreateNewText(thisConfig,"Weave SWP");
					-- VT
					CreateNewCheck(thisConfig,"VT");
					CreateNewText(thisConfig,"Weave VT");
			end


			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"      |cffBA55D3Multidot");

				-- Skip Affecting Combat
				CreateNewCheck(thisConfig,"Skip Affecting Combat");
				CreateNewText(thisConfig,"Skip Affecting Combat");

				-- SWP
				CreateNewCheck(thisConfig,"Multi SWP");
				CreateNewText(thisConfig,"Multi SWP");

				-- VT
				CreateNewCheck(thisConfig,"Multi VT");
				CreateNewText(thisConfig,"Multi VT");

				-- Max Targets
				-- CreateNewCheck(thisConfig,"Max Targets");
				CreateNewBox(thisConfig,"Max Targets", 1, 18, 1, 5, "Maximum count of SWP/VT on Units.\nShould be not more than 18/GCD.\nMin: 1 / Max: 18 / Interval: 1");
				CreateNewText(thisConfig,"Max DoTs AoE");

				-- DoT Refresh
				CreateNewBox(thisConfig,"Refresh Time", 1.0, 4.5, 0.1, 2.0, "Minimum time to refresh DoT.\nMin: 1 / Max: 4.5 / Interval: 0.1");
				CreateNewText(thisConfig,"DoT refresh time");

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"      |cffBA55D3Utilities");

				-- Pause Toggle
				CreateNewCheck(thisConfig,"Pause Toggle");
				CreateNewDrop(thisConfig,"Pause Toggle", 4, "Toggle")
				CreateNewText(thisConfig,"Pause Key");
				
				--Power Word: Fortitude
				CreateNewCheck(thisConfig,"PW: Fortitude");
				CreateNewText(thisConfig,"PW: Fortitude");
				
				-- Shadowform Outfight
				CreateNewCheck(thisConfig,"Shadowform Outfight");
				CreateNewText(thisConfig,"Auto Shadowform Outfight");

				-- Auto Rez
				CreateNewCheck(thisConfig,"Auto Rez");
				CreateNewText(thisConfig,"Auto Rez(TBD)");

				-- AutoSpeedBuff
				if isKnown(AngelicFeather) then
					--Angelic Feather
					CreateNewCheck(thisConfig,"Angelic Feather");
					CreateNewText(thisConfig,"Angelic Feather");
				
				if isKnown(BodyAndSoul) then
					--Body And Soul
					CreateNewCheck(thisConfig,"Body And Soul");
					CreateNewText(thisConfig,"Body And Soul");
				end

				-- Dummy DPS Test
				CreateNewCheck(thisConfig,"DPS Testing");
				CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 5, "Set to desired time for test in minutes.\nMin: 1 / Max: 15 / Interval: 1");
				CreateNewText(thisConfig,"DPS Testing");


			-- General Configs ---------------------------------
			CreateGeneralsConfig();
			WrapsManager();
			end
		end
	end
end