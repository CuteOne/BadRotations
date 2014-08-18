if select(3,UnitClass("player")) == 2 then

--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]	   
--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
--[[           ]]	--[[]]	   --[[]]	--[[]]					 --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]
 
--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]
--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]
--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]		 --[[ ]]
--[[         ]]		--[[         ]]	    --[[]]	   --[[]]		 --[[ ]]
--[[       ]]		--[[        ]]		--[[]]	   --[[]]		 --[[ ]]
--[[]]				--[[]]	  --[[]]	--[[           ]]	 	 --[[ ]]		
--[[]] 				--[[]]	   --[[]]	--[[           ]]		 --[[ ]]

    function PaladinProtToggles()

        -- Aoe Button
        if  AoEModesLoaded ~= "Prot Pal AoE Modes" then 
            AoEModes = { 
                [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cff00FF00Recommended for \n|cffFFDD11Single Target(1-2).", highlight = 0, icon = 35395 },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffFF0000Recommended for \n|cffFFDD11AoE(3+).", highlight = 0, icon = 53595 },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffFFDD11Recommended for \n|cffFFDD11Lazy people.", highlight = 1, icon = 114158 }
            };
            CreateButton("AoE",0,1)
            AoEModesLoaded = "Prot Pal AoE Modes";
        end
        -- Interrupts Button
        if  InterruptsModesLoaded ~= "Prot Pal Interrupts Modes" then 
            InterruptsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffFF0000Spells Included: \n|cffFFDD11Rebuke.", highlight = 1, icon = 96231 }
            };
            CreateButton("Interrupts",1,0)
            InterruptsModesLoaded = "Prot Pal Interrupts Modes";
        end

        -- Defensive Button
        if  DefensiveModesLoaded ~= "Prot Pal Defensive Modes" then 
            DefensiveModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Spells Included: \n|cffFFDD11Ardent Defender, \nDivine Protection, \nGuardian of Ancient Kings.", highlight = 1, icon = 86659 }
            };
            CreateButton("Defensive",1,1)
            DefensiveModesLoaded = "Prot Pal Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Prot Pal Cooldowns Modes" then 
            CooldownsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffFF0000No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffFF0000Cooldowns Included: \n|cffFFDD11Config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]] },
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Cooldowns Included: \n|cffFFDD11Avenging Wrath, \nHoly Avenger.", highlight = 1, icon = 31884 }
            };
            CreateButton("Cooldowns",2,0)
            CooldownsModesLoaded = "Prot Pal Cooldowns Modes";
        end
         -- Healing Button
        if  TrashModesLoaded ~= "Prot Pal Healing Modes" then 
            HealingModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Disable Healing.", tip = "|cffFF0000No healing will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "Self", value = 2 , overlay = "Heal only Self.", tip = "|cffFF0000Healing: |cffFFDD11On self only.", highlight = 1, icon = 19750 },
                [3] = { mode = "All", value = 3 , overlay = "Heal Everyone.", tip = "|cffFF0000Healing: |cffFFDD11On Everyone.", highlight = 1, icon = 114163 }
            };
            CreateButton("Healing",2,1)
            HealingModesLoaded = "Prot Pal Healing Modes";
        end       

    end

--[[           ]]	--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]	--[[           ]]
--[[]]	   --[[]]	--[[]]					 --[[ ]]
--[[         ]]		--[[           ]]	  	 --[[ ]]
--[[        ]]		--[[]]				  	 --[[ ]]
--[[]]	  --[[]]	--[[           ]]	 	 --[[ ]]		
--[[]]	   --[[]] 	--[[           ]]		 --[[ ]]











end