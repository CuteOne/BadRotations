if select(3, UnitClass("player")) == 1 then
    function WarriorArmsConfig()
        bb.ui.window.profile = bb.ui:createProfileWindow("Arms")
        local section

        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "General Rotation")
        -- Multi-Rend
        -- bb.ui:createCheckbox(section,"Multi-Rend","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFRend spreading|cffFFBB00.")
        -- Pause Toggle
        bb.ui:createDropdown(section, "Pause Key", bb.dropOptions.Toggle,  4)
        -- Heroic Leap
        bb.ui:createDropdown(section, "Heroic Leap Key", bb.dropOptions.Toggle2,  2)
        -- Ravager
        bb.ui:createDropdown(section, "Ravager Key", bb.dropOptions.Toggle2,  2)
        -- Auto Bladestorm / DragonRoar Single Target
        bb.ui:createCheckbox(section,"Single BS/DR/RV")
        -- Auto Bladestorm / DragonRoar Multi Target
        bb.ui:createCheckbox(section,"Multi BS/DR/RV")
        bb.ui:checkSectionState(section)


        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "Buffs")
        -- Shout
        bb.ui:createDropdown(section,  "Shout", { "|cffFFBB00Command", "|cff0077FFBattle"},  2,  "Choose Shout to use.")
        bb.ui:checkSectionState(section)


        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
        -- Potion
        bb.ui:createCheckbox(section,"Use Potion")
        -- Recklessness
        bb.ui:createCheckbox(section,"Recklessness")
        -- Avatar
        bb.ui:createCheckbox(section,"Avatar")
        -- Racial
        bb.ui:createCheckbox(section,"Racial (Orc / Troll)")
        -- StormBolt
        bb.ui:createCheckbox(section,"StormBolt")
        -- Trinket
        bb.ui:createCheckbox(section,"Use Trinket")
        bb.ui:checkSectionState(section)


        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
        -- Die by the Sword
        bb.ui:createSpinner(section,  "Die by the Sword",  40,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDie by the Sword")
        -- Rallying Cry
        bb.ui:createSpinner(section,  "Rallying Cry",  40,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRallying Cry")
        -- Enraged Regeneration
        bb.ui:createSpinner(section,  "Enraged Regeneration",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFEnraged Regeneration")
        -- ImpendingVictory/Victory Rush
        bb.ui:createSpinner(section,  "Impending Victory",  40,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFImpending Victory (Victory Rush)")
        -- Vigilance Focus
        bb.ui:createSpinner(section,  "Vigilance on Focus",  25,  0,  100  ,  5,  "% HP of Focustarget to use Vigilance on Focustarget")
        -- Def Stance
        bb.ui:createSpinner(section,  "Defensive Stance",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDefensive Stance")
        -- Healthstone
        bb.ui:createSpinner(section,  "Healthstone",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        bb.ui:checkSectionState(section)


        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
        -- Pummel
        bb.ui:createSpinner(section,  "Pummel",  60 ,  0,  100  ,  5,  "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFPummel.")
        -- Disrupting Shout
        bb.ui:createSpinner(section,  "Disrupting Shout",  60 ,  0,  100  ,  5,  "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFDisrupting Shout.")
        bb.ui:checkSectionState(section)


        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "Misc")
        -- Dummy DPS Test
        bb.ui:createCheckbox(section,"DPS Testing")
        bb.ui:createSpinner(section, "DPS Testing",  5,  1,  15,  1,  "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1")
        bb.ui:checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"chumii"})
        bb:checkProfileWindowStatus()
    end
end