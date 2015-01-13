if select(3, UnitClass("player")) == 5 then

--[[         ]]		--[[           ]]	--[[           ]]	--[[           ]]
--[[          ]]		  --[[]]		--[[           ]]	--[[           ]]
--[[]]	   --[[]]		  --[[]]		--[[]]	   			--[[]]
--[[]]	   --[[]]		  --[[]]		--[[           ]]	--[[]]
--[[]]	   --[[]]		  --[[]]				   --[[]]	--[[]]
--[[          ]]		  --[[]]		--[[           ]]	--[[           ]]
--[[         ]] 	--[[           ]]	--[[           ]]	--[[           ]]

	function DisciplineConfig()
		if currentConfig ~= "Discipline ragnar" then
			ClearConfig();
			thisConfig = 0;
			-- Title
			CreateNewTitle(thisConfig,"discotime |cffBA55D3by ragnar");


			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Offensive");

				-- Shadowfiend / Mindbender
					if isKnown(Mindbender) then
						CreateNewCheck(thisConfig,"Mindbender");
						CreateNewText(thisConfig,"Mindbender");
					else
						CreateNewCheck(thisConfig,"Shadowfiend");
						CreateNewText(thisConfig,"Shadowfiend");
					end

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Defensive");

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

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Healing")

				-- Heal
				CreateNewCheck(thisConfig,"Heal")
				CreateNewBox(thisConfig, "Heal",0,100,5,65,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHeal.")
				CreateNewText(thisConfig,"Heal")

				-- Flash  Heal
				CreateNewCheck(thisConfig,"Flash Heal")
				CreateNewBox(thisConfig, "Flash Heal",0,100,5,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFlash Heal.")
				CreateNewText(thisConfig,"Flash Heal")

				-- Shield Filler
				CreateNewCheck(thisConfig,"Shield Filler Count")
				CreateNewBox(thisConfig, "Shield Filler Count",1,25,1,5,"|cffFFBB00Number of members to keep |cffFFFFFFShield |cffFFBB00as Filler.")
				CreateNewText(thisConfig,"Shield Filler Count")

				-- Penance Tank
				CreateNewCheck(thisConfig,"Penance Tank")
				CreateNewBox(thisConfig, "Penance Tank",1,100,2,90,"|cffFFBB00Number of members to keep |cffFFFFFFShield |cffFFBB00as Filler.")
				CreateNewText(thisConfig,"Penance Tank")

				-- Penance
				--CreateNewCheck(thisConfig,"Penance")
				CreateNewBox(thisConfig, "Penance",1,100,2,75,"|cffFFBB00Number of members to keep |cffFFFFFFShield |cffFFBB00as Filler.")
				CreateNewText(thisConfig,"Penance")


			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3AoE Healing")


			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Utilities");

				-- Pause Toggle
				CreateNewCheck(thisConfig,"Pause Toggle");
				CreateNewDrop(thisConfig,"Pause Toggle", 4, "Toggle")
				CreateNewText(thisConfig,"Pause Toggle");
				
				--Power Word: Fortitude
				CreateNewCheck(thisConfig,"PW: Fortitude");
				CreateNewText(thisConfig,"PW: Fortitude");
				
				-- -- Auto Rez
				-- CreateNewCheck(thisConfig,"Auto Rez");
				-- CreateNewText(thisConfig,"Auto Rez(TBD)");

				-- -- AutoSpeedBuff
				-- if isKnown(AngelicFeather) then
				-- 	--Angelic Feather
				-- 	CreateNewCheck(thisConfig,"Angelic Feather");
				-- 	CreateNewText(thisConfig,"Angelic Feather");
				-- end
				
				if isKnown(BodyAndSoul) then
					--Body And Soul
					CreateNewCheck(thisConfig,"Body And Soul");
					CreateNewText(thisConfig,"Body And Soul");
				end

				-- Dummy DPS Test
				CreateNewCheck(thisConfig,"Heal Testing");
				CreateNewBox(thisConfig,"Heal Testing", 1, 15, 1, 4, "Set to desired time for test in minutes.\nMin: 1 / Max: 15 / Interval: 1");
				CreateNewText(thisConfig,"Heal Testing");


			-- General Configs ---------------------------------
			CreateGeneralsConfig();
			WrapsManager();
		end
	end
end