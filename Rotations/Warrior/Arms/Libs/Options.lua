if select(3, UnitClass("player")) == 1 then
    function WarriorArmsConfig()
        bb.profile_window = createNewProfileWindow("Arms")
        local section

        -- Wrapper
        section = createNewSection(bb.profile_window, "General Rotation")
        -- Multi-Rend
        -- createNewCheckbox(section,"Multi-Rend","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFRend spreading|cffFFBB00.")
        -- Pause Toggle
        createNewDropdown(section, "Pause Key", bb.dropOptions.Toggle,  4)
        -- Heroic Leap
        createNewDropdown(section, "Heroic Leap Key", bb.dropOptions.Toggle2,  2)
        -- Ravager
        createNewDropdown(section, "Ravager Key", bb.dropOptions.Toggle2,  2)
        -- Auto Bladestorm / DragonRoar Single Target
        createNewCheckbox(section,"Single BS/DR/RV")
        -- Auto Bladestorm / DragonRoar Multi Target
        createNewCheckbox(section,"Multi BS/DR/RV")
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "Buffs")
        -- Shout
        createNewDropdown(section,  "Shout", { "|cffFFBB00Command", "|cff0077FFBattle"},  2,  "Choose Shout to use.")
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "Cooldowns")
        -- Potion
        createNewCheckbox(section,"Use Potion")
        -- Recklessness
        createNewCheckbox(section,"Recklessness")
        -- Avatar
        createNewCheckbox(section,"Avatar")
        -- Racial
        createNewCheckbox(section,"Racial (Orc / Troll)")
        -- StormBolt
        createNewCheckbox(section,"StormBolt")
        -- Trinket
        createNewCheckbox(section,"Use Trinket")
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "Defensive")
        -- Die by the Sword
        createNewSpinner(section,  "Die by the Sword",  40,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDie by the Sword")
        -- Rallying Cry
        createNewSpinner(section,  "Rallying Cry",  40,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRallying Cry")
        -- Enraged Regeneration
        createNewSpinner(section,  "Enraged Regeneration",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFEnraged Regeneration")
        -- ImpendingVictory/Victory Rush
        createNewSpinner(section,  "Impending Victory",  40,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFImpending Victory (Victory Rush)")
        -- Vigilance Focus
        createNewSpinner(section,  "Vigilance on Focus",  25,  0,  100  ,  5,  "% HP of Focustarget to use Vigilance on Focustarget")
        -- Def Stance
        createNewSpinner(section,  "Defensive Stance",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDefensive Stance")
        -- Healthstone
        createNewSpinner(section,  "Healthstone",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "Interrupts")
        -- Pummel
        createNewSpinner(section,  "Pummel",  60 ,  0,  100  ,  5,  "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFPummel.")
        -- Disrupting Shout
        createNewSpinner(section,  "Disrupting Shout",  60 ,  0,  100  ,  5,  "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFDisrupting Shout.")
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "Misc")
        -- Dummy DPS Test
        createNewCheckbox(section,"DPS Testing")
        createNewSpinner(section, "DPS Testing",  5,  1,  15,  1,  "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1")
        checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"chumii"})
        bb:checkProfileWindowStatus()
    end
end