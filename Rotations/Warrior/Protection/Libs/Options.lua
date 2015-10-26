if select(3, UnitClass("player")) == 1  then
    function WarriorProtOptions()
        bb.profile_window = createNewProfileWindow("Protection")
        local section


        -- Wrapper
        section = createNewSection(bb.profile_window, "Buffs")
        -- Shout
        createNewDropdown(section,  "Shout", { "|cffFFBB00Command", "|cff0077FFBattle"},  1,  "Choose Shout to use.")
        -- Rotation
        createNewDropdown(section,  "Stance", { "|cffFFBB00Gladiator", "|cff0077FFProtection"},  1,  "Choose Stance to use.")
        checkSectionState(section)

        
        -- Wrapper
        section = createNewSection(bb.profile_window, "Cooldowns")
        -- Bladestorm
        createNewCheckbox(section,"Auto Bladestorm","Use Bladestorm automatically")
        -- DragonRoar
        createNewCheckbox(section,"Auto Dragon Roar","Use Dragon Roar automatically")
        -- Ravager
        createNewCheckbox(section,"Auto Ravager","Use Ravager automatically")
        -- Bloodbath
        createNewCheckbox(section,"Auto Bloodbath","Use Bloodbath automatically")
        -- Avatar
        createNewCheckbox(section,"Auto Avatar","Use Avatar automatically")
        -- Racial
        createNewCheckbox(section,"Racial (Orc / Troll)")
        -- Dummy DPS Test
        createNewSpinner(section, "DPS Testing",  5,  1,  15,  1,  "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1")
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "Defensive")
        -- Shield Block / Barrier
        createNewDropdown(section,  "Block or Barrier", { "|cffFFBB00Block", "|cff0077FFBarrier"},  1,  "Use Shield Block or Shield Barrier")

        createNewSpinner(section, "Last Stand", 20, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLast Stand")

        createNewSpinner(section, "Shield Wall", 25, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFShield Wall")

        createNewSpinner(section,  "Enraged Regeneration",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFEnraged Regeneration")
        -- ImpendingVictory/Victory Rush
        createNewSpinner(section,  "Impending Victory",  40,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFImpending Victory (Victory Rush)")
        -- Healthstone
        createNewSpinner(section,  "Healthstone",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        -- Safeguard Focus
        createNewSpinner(section,  "Safeguard at Focus",  25,  0,  100  ,  5,  "% HP of Focustarget to Safeguard at Focustarget")
        -- Vigilance Focus
        createNewSpinner(section,  "Vigilance on Focus",  25,  0,  100  ,  5,  "% HP of Focustarget to use Vigilance on Focustarget")
        checkSectionState(section)

        
        -- Wrapper
        section = createNewSection(bb.profile_window, "Keys")
        -- Pause Toggle
        createNewDropdown(section, "Pause Key", bb.dropOptions.Toggle,  4)
        -- Heroic Leap
        createNewDropdown(section, "Heroic Leap Key", bb.dropOptions.Toggle2,  2)
        -- Mocking Banner
        createNewDropdown(section, "Mocking Banner Key", bb.dropOptions.Toggle2,  7)
        --Ravager
        createNewDropdown(section, "Ravager Key", bb.dropOptions.Toggle2,  7)
        checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"Cpoworks"})
        bb:checkProfileWindowStatus()
    end
end