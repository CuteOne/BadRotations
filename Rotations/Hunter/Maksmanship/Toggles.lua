if select(3, UnitClass("player")) == 3 then

	function MarkToggles()
        GarbageButtons()
        -- Aoe Button
        if  AoEModesLoaded ~= "Mavmins Target Modes" then
            AoEModes = {
                [1] = { mode = "One", value = 1 , overlay = "Single Target Enabled", tip = "Single target rotation.", highlight = 0, icon = [[INTERFACE\ICONS\ability_hunter_focusedaim]] },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Abilities Enabled", tip = "Enables AoE abilities in rotation.", highlight = 0, icon = [[INTERFACE\ICONS\achievement_arena_5v5_7]] },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto Rotation Mode Enabled", tip = "Profile will handle rotation selection", highlight = 1, icon = [[INTERFACE\ICONS\achievement_doublerainbow]] }
            }
            CreateButton("AoE",0,1)
            AoEModesLoaded = "Mavmins Target Modes"
        end
        -- Interrupts Button
        if  InterruptsModesLoaded ~= "Mavmins Interrupt Mode" then
            InterruptsModes = {
                [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\ability_hibernation]] },
                [2] = { mode = "Raid", value = 2 , overlay = "Interrupts Specific Abilities", tip = "Interrupts preset abilities only.", highlight = 1, icon = [[INTERFACE\ICONS\INV_Misc_Head_Dragon_01.png]]},
                [3] = { mode = "All", value = 3 , overlay = "Interrupt All Abilities", tip = "Interrupts everything.", highlight = 1, icon = 147362}
            }
            CreateButton("Interrupts",1,0)
            InterruptsModesLoaded = "Mavmins Interrupt Mode"
        end

        -- Defensive Button
        if  DefensiveModesLoaded ~= "Mavmins Defensive Mode" then
            DefensiveModes = {
                [1] = { mode = "Off", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\ability_hibernation]] },
                [2] = { mode = "On", value = 2 , overlay = "Defensive Enabled", tip = "Includes Deterrence and Feign Death.", highlight = 1, icon = [[INTERFACE\ICONS\ability_warrior_defensivestance]] }
            }
            CreateButton("Defensive",1,1)
            DefensiveModesLoaded = "Mavmins Defensive Mode"
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Mavmins Cooldowns Mode" then
            CooldownsModes = {
                [1] = { mode = "Off", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\ability_hibernation]] },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "Uses selected Cooldowns from config.", highlight = 1, icon = [[INTERFACE\ICONS\inv_gizmo_thebiggerone]]},
                [3] = { mode = "Boss", value = 3 , overlay = "Raid Mode Enabled", tip = "Uses all CDs on boss units.", highlight = 1, icon = [[INTERFACE\ICONS\INV_Misc_Head_Dragon_01.png]] }
            }
            CreateButton("Cooldowns",2,0)
            CooldownsModesLoaded = "Mavmins Cooldowns Mode"
        end
        -- Pet Button
        if  PetModesLoaded ~= "Mavmins Pet Mode" then
            PetModes = {
                [1] = { mode = "Off", value = 1 , overlay = "Pet Management Disabled", tip = "Will not manage Pet.", highlight = 0, icon = [[INTERFACE\ICONS\ability_hibernation]] },
                [2] = { mode = "On", value = 2 , overlay = "Pet Management Enabled", tip = "Will manage Pet.", highlight = 1, icon = [[INTERFACE\ICONS\ability_hunter_sickem]] },
            }
            CreateButton("Pet",2,1)
            PetModesLoaded = "Mavmins Pet Mode"
        end
	end

end
