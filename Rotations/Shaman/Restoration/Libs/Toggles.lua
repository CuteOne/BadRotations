if select(3, UnitClass("player")) == 7 then

--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[]]     --[[]]   --[[]]              --[[]]                   --[[ ]]        --[[]]     --[[]]
--[[           ]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[]]     --[[]]
--[[        ]]      --[[]]                         --[[]]        --[[ ]]        --[[]]     --[[]]
--[[]]    --[[]]    --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]
--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]

    function RestorationToggles()
        -- Aoe Button
        if  AoEModesLoaded ~= "CML Restoration AoE Modes" then
            AoEModes = {
                [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "Recommended for one or two targets.", highlight = 0 },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "Recommended for three targets or more.", highlight = 0 },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "Recommended for lazy people like me.", highlight = 1 }
            }
            AoEModesLoaded = "CML Restoration AoE Modes"
        end
        -- Interrupts Button
        if  InterruptsModesLoaded ~= "CML Restoration Interrupts Modes" then
            InterruptsModes = {
                [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0 },
                [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1 }
            }
            InterruptsModesLoaded = "CML Restoration Interrupts Modes"
        end

        -- Defensive Button
        if  DefensiveModesLoaded ~= "CML Restoration Defensive Modes" then
            DefensiveModes = {
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0 },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "Includes Deterrence.", highlight = 1 }
            }
            DefensiveModesLoaded = "CML Restoration Defensive Modes"
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "CML Restoration Cooldowns Modes" then
            CooldownsModes = {
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0 },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "Includes config's selected spells.", highlight = 1 },
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "Includes Ascendance, Stormlash.", highlight = 1 }
            }
            CooldownsModesLoaded = "CML Restoration Cooldowns Modes"
        end
    end

end