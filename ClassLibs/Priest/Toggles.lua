if select(3, UnitClass("player")) == 5 then

	--[[         ]]     --[[           ]]   --[[           ]]   --[[           ]]
	--[[          ]]          --[[]]        --[[           ]]   --[[           ]]
	--[[]]     --[[]]         --[[]]        --[[]]              --[[]]
	--[[]]     --[[]]         --[[]]        --[[           ]]   --[[]]
	--[[]]     --[[]]         --[[]]                   --[[]]   --[[]]
	--[[          ]]          --[[]]        --[[           ]]   --[[           ]]
	--[[         ]]     --[[           ]]   --[[           ]]   --[[           ]]

	--[[]]     --[[]]   --[[           ]]   --[[]]              --[[]]    --[[]]
	--[[]]     --[[]]   --[[           ]]   --[[]]              --[[]]    --[[]]
	--[[           ]]   --[[]]     --[[]]   --[[]]                 --[[    ]]
	--[[           ]]   --[[]]     --[[]]   --[[]]                 --[[    ]]
	--[[           ]]   --[[]]     --[[]]   --[[]]                   --[[]]
	--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[]]
	--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[]]

	--[[           ]]   --[[]]     --[[]]         --[[]]        --[[         ]]     --[[           ]]   --[[]]     --[[]]
	--[[           ]]   --[[]]     --[[]]        --[[  ]]       --[[          ]]    --[[           ]]   --[[]]     --[[]]
	--[[]]              --[[]]     --[[]]       --[[    ]]      --[[]]     --[[]]   --[[]]     --[[]]   --[[ ]]   --[[ ]]
	--[[           ]]   --[[           ]]      --[[      ]]     --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]
	           --[[]]   --[[]]     --[[]]     --[[        ]]    --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]
	--[[           ]]   --[[]]     --[[]]    --[[]]    --[[]]   --[[          ]]    --[[           ]]   --[[ ]]   --[[ ]]
	--[[           ]]   --[[]]     --[[]]   --[[]]      --[[]]  --[[         ]]     --[[           ]]    --[[]]   --[[]]

	function ShadowToggles()
		-- Halo Button
		if isKnown(Halo) then
			if HaloModesLoaded ~= "Shadow Priest Halo Modes" then
				HaloModes = {
					[1] = { mode = "off", value = 1 , overlay = "Halo Disabled", tip = "|cffFF0000Halo \n|cffFFDD11No Halo will be used.", highlight = 0, icon = 120644 },
					[2] = { mode = "on", value = 2 , overlay = "Halo Enabled", tip = "|cff00FF00Halo \n|cffFFDD11Will be used.", highlight = 1, icon = 120644 }
				};
				CreateButton("Halo",2,1)
				HaloModesLoaded = "Shadow Priest Halo Modes";
			end
		end

		-- ORBS Button
		if BurnModesLoaded ~= "Shadow Priest Burn Modes" then
			BurnModes = {
				[1] = { mode = "off", value = 1 , overlay = "burn off", tip = "|cffFF0000Burn Orbs \n|cffFFDD11No Orbs will be burned.", highlight = 0, icon = 157217 },
				[2] = { mode = "burn", value = 2 , overlay = "burn on", tip = "|cff00FF00Burn Orbs \n|cffFFDD11Burn Orbs with DP if targetHP>20.\nIgnoring the Options", highlight = 1, icon = 157217 }
			};
			CreateButton("Burn",3,1)
			BurnModesLoaded = "Shadow Priest Burn Modes";
		end

		-- AoE Button
		if AoEModesLoaded ~= "Shadow Priest AoE Modes" then
			AoEModes = {
				[1] = { mode = "single", value = 1 , overlay = "Single Target", tip = "|cff00FF00AoE \n|cffFFDD11Single Target. \n|cffFF0000Style can be chosen in the options", highlight = 0, icon = 139139 },
				[2] = { mode = "AoE", value = 2 , overlay = "2-3 Targets", tip = "|cff00FF00AoE \n|cffFFDD112-3 Enemies. \n|cffFF0000", highlight = 0, icon = 589 },
				[3] = { mode = "auto", value = 3 , overlay = "AoE Auto", tip = "|cff00FF00AoE \n|cffFFDD11Auto decision (not implemented yet). \n|cffFF0000", highlight = 1, icon = 8092 }
			};
			CreateButton("AoE",0,1)
			AoEModesLoaded = "Shadow Priest AoE Modes";
		end
		-- Interrupt Button
		if InterruptModesLoaded ~= "Shadow Priest Interrupt Modes" then
			InterruptModes = {
				[1] = { mode = "off", value = 1 , overlay = "Kicks Disabled", tip = "|cffFF0000Interrupt \n|cffFFDD11No cooldowns will be used.", highlight = 0, icon = 15487 },
				[2] = { mode = "auto", value = 2 , overlay = "Kick Auto", tip = "|cff00FF00Interrupt \n|cffFF0000Spells Included: \n|cffFFDD11Silence \nArcane Torrent(not)", highlight = 1, icon = 15487 }
			};
			CreateButton("Interrupt",1,1)
			InterruptModesLoaded = "Shadow Priest Interrupt Modes";
		end

		-- Cooldowns Button
		if CooldownsModesLoaded ~= "Shadow Priest Cooldowns Modes" then
			CooldownsModes = {
				[1] = { mode = "off", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffFF0000Cooldowns \n|cffFFDD11No cooldowns will be used.", highlight = 0, icon = 34433 },
				[2] = { mode = "on", value = 2 , overlay = "Cooldowns Enabled", tip = "|cff00FF00Cooldowns \n|cffFFDD11Only used if enabled in Settings. \n|cffFF0000Spells Included: \n|cffFFDD11Power Infusion \nShadowfiend \nMindbender", highlight = 1, icon = 34433 }
			};
			CreateButton("Cooldowns",2,0)
			CooldownsModesLoaded = "Shadow Priest Cooldowns Modes";
		end

		-- Defensive Button
		if DefensiveModesLoaded ~= "Shadow Priest Defensive Modes" then
			DefensiveModes = {
				[1] = { mode = "off", value = 1, overlay = "Defensive Disabled", tip = "|cffFF0000Defensive \n|cffFFDD11No Defensive Cooldowns will be used.", highlight = 0, icon = 17 },
				[2] = { mode = "on", value = 2, overlay = "Defensive Enabled", tip = "|cff00FF00Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Power Word: Shield \nFade (glyphed) \nDesperate Prayer \nHealthstone", highlight = 1, icon = 17 }
			};
			CreateButton("Defensive",1,0)
			DefensiveModesLoaded = "Shadow Priest Defensive Modes";
		end


	end -- END TOGGLES




	-- handle specific toggles
	function SpecificToggle(toggle)
		if getValue(toggle) == 1 then
			return IsLeftControlKeyDown();
		elseif getValue(toggle) == 2 then
			return IsLeftShiftKeyDown();
		elseif getValue(toggle) == 3 then
			return IsLeftAltKeyDown();
		elseif getValue(toggle) == 4 then
			return IsRightControlKeyDown();
		elseif getValue(toggle) == 5 then
			return IsRightShiftKeyDown();
		elseif getValue(toggle) == 6 then
			return IsRightAltKeyDown();
		elseif getValue(toggle) == 7 then
			return 1
		end
	end

end