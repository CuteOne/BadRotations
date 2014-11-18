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
		
		-- Cooldowns Button
		if CooldownsModesLoaded ~= "Shadow Priest Cooldowns Modes" then
			CooldownsModes = {
				[1] = { mode = "off", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffFF0000Cooldowns \n|cffFFDD11No cooldowns will be used.", highlight = 0, icon = 34433 },
				[2] = { mode = "on", value = 2 , overlay = "Cooldowns Enabled", tip = "|cff00FF00Cooldowns \nOnly used if enabled in Settings. \n|cffFF0000Spells Included: \n|cffFFDD11Power Infusion \nShadowfiend \nMindbender", highlight = 1, icon = 34433 }
			};
			CreateButton("Cooldowns",2,0)
			CooldownsModesLoaded = "Shadow Priest Cooldowns Modes";
		end

		-- Defensive Button
		if DefensiveModesLoaded ~= "Shadow Priest Defensive Modes" then
			DefensiveModes = {
				[1] = { mode = "off", value = 1, overlay = "Defensive Disabled", tip = "|cffFF0000Defensive \n|cffFFDD11No Defensive Cooldowns will be used.", highlight = 0, icon = 17 },
				[2] = { mode = "on", value = 2, overlay = "Defensive Enabled", tip = "|cff00FF00Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Power Word: Shield \nFade (glyphed) \nDesperate Prayer \nHealthstone", highlight = 1, icon = 17 },
			};
			CreateButton("Defensive",2,1)
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