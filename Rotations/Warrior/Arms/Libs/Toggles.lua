if select(3, UnitClass("player")) == 1 then

   function WarriorArmsToggles()

        -- AoE Button
        -- if AoEModesLoaded ~= "Arms Warrior AoE Modes" then
        --     CustomAoEModes = {
        --     [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip ="Automatic Rotation Mode based on number of targets in range", highlight = 0, icon = SweepingStrikes },
        --     [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip ="Multiple Target Rotation", highlight = 0, icon = Cleave },
        --     [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip ="Multiple Target Rotation", highlight = 0, icon = MortalStrike }
        --     };
        --     AoEModes = CustomAoEModes
        --     CreateButton("AoE",1,0)
        --     AoEModesLoaded = "Arms Warrior AoE Modes";
        -- end

        if AoEModesLoaded ~= "Arms Warrior AoE Modes" then
            CustomAoEModes = {
                [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 0, icon = _SweepingStrikes },
                [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = _Whirlwind },
                [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = _MortalStrike }
            };
           AoEModes = CustomAoEModes
           CreateButton("AoE",1,0)
           AoEModesLoaded = "Arms Warrior AoE Modes";
        end

        -- Cooldowns Button
        if CooldownsModesLoaded ~= "Cooldown Modes" then
            CustomCooldownsModes = {
                [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = Recklessness },
                [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = Recklessness },
                [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = Recklessness }
            };
           CooldownsModes = CustomCooldownsModes
           CreateButton("Cooldowns",2,0)
           CooldownsModesLoaded = "Cooldown Modes";
        end

        -- Defensive Button
        if DefensiveModesLoaded ~= "Defensive Modes" then
            CustomDefensiveModes = {
                [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = DiebytheSword },
                [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = DiebytheSword }
            };
            DefensiveModes = CustomDefensiveModes
            CreateButton("Defensive",3,0)
            DefensiveModesLoaded = "Defensive Modes";
        end

     -- Interrupts Button
        if InterruptsModesLoaded ~= "Interrupt Modes" then
            CustomInterruptsModes = {
                [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = Pummel },
                [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = Pummel }
            };
            InterruptsModes = CustomInterruptsModes
            CreateButton("Interrupts",4,0)
            InterruptsModesLoaded = "Interrupt Modes";
        end

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

	function WarriorFuryToggles()

        if AoEModesLoaded ~= "Fury Warrior AoE Modes" then
            CustomAoEModes = {
			[1] = { mode = "One", value = 1 , overlay = "Single Target Enabled", tip = "", highlight = 0, icon = Bloodthirst },
            [2] = { mode = "Two", value = 2 , overlay = "Two/Three Target Enabled", tip = "", highlight = 0, icon = RagingBlow },
            [3] = { mode = "Three", value = 3 , overlay = "Four+ Target Enabled", tip = "", highlight = 0, icon = Whirlwind }
            };
			AoEModes = CustomAoEModes
			CreateButton("AoE",1,0)
			AoEModesLoaded = "Fury Warrior AoE Modes";
        end

		if InterruptsModesLoaded ~= "Fury Interrupt Modes" then
            CustomInterruptsModes = {
                [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "", highlight = 1, icon = Pummel },
                [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "", highlight = 0, icon = Pummel }
            };
			InterruptsModes = CustomInterruptsModes
            CreateButton("Interrupts",2,0)
            InterruptsModesLoaded = "Fury Interrupt Modes";
        end

		function SpecificToggle(toggle)
            if getValue(toggle) == 1 then
                return IsLeftControlKeyDown();
            elseif getValue(toggle) == 2 then
                return IsLeftShiftKeyDown();
            elseif getValue(toggle) == 3 then
                return IsRightControlKeyDown();
            elseif getValue(toggle) == 4 then
                return IsRightShiftKeyDown();
            elseif getValue(toggle) == 5 then
                return IsRightAltKeyDown();
            elseif getValue(toggle) == 6 then
                return 0
            end
        end

    end

   function WarriorProtToggles()
        if AoEModesLoaded ~= "Prot Warrior AoE Modes" then
            AoEModes = {
                [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = ThunderClap },
                [2] = { mode = "Sing", value = 2 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = Devastate }
            };
           CreateButton("AoE",1,0)
           AoEModesLoaded = "Prot Warrior AoE Modes";
        end

        -- Cooldowns Button
        if CooldownsModesLoaded ~= "Cooldown Modes" then
            CustomCooldownsModes = {
                [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = Avatar },
                [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = Avatar },
                [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = Avatar }
            };
           CooldownsModes = CustomCooldownsModes
           CreateButton("Cooldowns",2,0)
           CooldownsModesLoaded = "Cooldown Modes";
        end

        -- Defensive Button
        if DefensiveModesLoaded ~= "Defensive Modes" then
            CustomDefensiveModes = {
                [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = ShieldWall },
                [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = ShieldWall }
            };
            DefensiveModes = CustomDefensiveModes
            CreateButton("Defensive",3,0)
            DefensiveModesLoaded = "Defensive Modes";
        end

     -- Interrupts Button
        if InterruptsModesLoaded ~= "Interrupt Modes" then
            CustomInterruptsModes = {
                [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = Pummel },
                [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = Pummel }
            };
            InterruptsModes = CustomInterruptsModes
            CreateButton("Interrupts",4,0)
            InterruptsModesLoaded = "Interrupt Modes";
        end

        -- --Gladiator Button
        -- if GladiatorModesLoaded ~= "Gladiator Modes" then
        --     CustomGladiatorModes = {
        --         [1] = { mode = "Glad", value = 1 , overlay = "Gladiator Enabled", tip = "Gladiator Rotation", highlight = 0, icon = GladiatorStance },
        --         [2] = { mode = "Prot", value = 2 , overlay = "Protection Enabled", tip = "Protection Rotation", highlight = 0, icon = DefensiveStance }
        --     };
        --     GladiatorModes = CustomGladiatorModes
        --     CreateButton("Gladiator",5,0)
        --     GladiatorModesLoaded = "Gladiator Modes";
        -- end

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
end