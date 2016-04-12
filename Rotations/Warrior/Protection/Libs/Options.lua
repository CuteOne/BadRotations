if select(3, UnitClass("player")) == 1  then
    function WarriorProtOptions()
        bb.ui.window.profile = bb.ui:createProfileWindow("Protection")
        local section


        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "Buffs")
        -- Shout
        bb.ui:createDropdown(section,  "Shout", { "|cffFFBB00Command", "|cff0077FFBattle"},  1,  "Choose Shout to use.")
        -- Rotation
        bb.ui:createDropdown(section,  "Stance", { "|cffFFBB00Gladiator", "|cff0077FFProtection"},  1,  "Choose Stance to use.")
        bb.ui:checkSectionState(section)

        
        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
        -- Bladestorm
        bb.ui:createCheckbox(section,"Auto Bladestorm","Use Bladestorm automatically")
        -- DragonRoar
        bb.ui:createCheckbox(section,"Auto Dragon Roar","Use Dragon Roar automatically")
        -- Ravager
        bb.ui:createCheckbox(section,"Auto Ravager","Use Ravager automatically")
        -- Bloodbath
        bb.ui:createCheckbox(section,"Auto Bloodbath","Use Bloodbath automatically")
        -- Avatar
        bb.ui:createCheckbox(section,"Auto Avatar","Use Avatar automatically")
        -- Racial
        bb.ui:createCheckbox(section,"Racial (Orc / Troll)")
        -- Dummy DPS Test
        bb.ui:createSpinner(section, "DPS Testing",  5,  1,  15,  1,  "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1")
        bb.ui:checkSectionState(section)


        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
        -- Shield Block / Barrier
        bb.ui:createDropdown(section,  "Block or Barrier", { "|cffFFBB00Block", "|cff0077FFBarrier"},  1,  "Use Shield Block or Shield Barrier")

        bb.ui:createSpinner(section, "Last Stand", 20, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLast Stand")

        bb.ui:createSpinner(section, "Shield Wall", 25, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFShield Wall")

        bb.ui:createSpinner(section,  "Enraged Regeneration",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFEnraged Regeneration")
        -- ImpendingVictory/Victory Rush
        bb.ui:createSpinner(section,  "Impending Victory",  40,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFImpending Victory (Victory Rush)")
        -- Healthstone
        bb.ui:createSpinner(section,  "Healthstone",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        -- Safeguard Focus
        bb.ui:createSpinner(section,  "Safeguard at Focus",  25,  0,  100  ,  5,  "% HP of Focustarget to Safeguard at Focustarget")
        -- Vigilance Focus
        bb.ui:createSpinner(section,  "Vigilance on Focus",  25,  0,  100  ,  5,  "% HP of Focustarget to use Vigilance on Focustarget")
        bb.ui:checkSectionState(section)

        
        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "Keys")
        -- Pause Toggle
        bb.ui:createDropdown(section, "Pause Key", bb.dropOptions.Toggle,  4)
        -- Heroic Leap
        bb.ui:createDropdown(section, "Heroic Leap Key", bb.dropOptions.Toggle2,  2)
        -- Mocking Banner
        bb.ui:createDropdown(section, "Mocking Banner Key", bb.dropOptions.Toggle2,  7)
        --Ravager
        bb.ui:createDropdown(section, "Ravager Key", bb.dropOptions.Toggle2,  7)
        bb.ui:checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"Cpoworks"})
        bb:checkProfileWindowStatus()
    end
end