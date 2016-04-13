 if select(3,UnitClass("player")) == 10 then
-- Config Panel
   function MistMonkConfig()
            bb.ui.window.profile = bb.ui:createProfileWindow("Mistweaver")
            local section

            -- Wrapper -----------------------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Buffs")
            -- Stance
            bb.ui:createDropdown(section,  "Stance", { "|cff00FF55Serpent", "|cff0077FFCrane"},  1,  "Choose Stance to use.")
            -- Legacy of the Emperor
            bb.ui:createCheckbox(section,"Legacy of the Emperor")
            --Jade Serpent Statue
            bb.ui:createCheckbox(section,"Jade Serpent Statue (Left Shift)")
            bb.ui:checkSectionState(section)
    
            -- Wrapper -----------------------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
            -- Revival
            bb.ui:createSpinner(section, "Revival", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFRevival")
            -- Revival People
            bb.ui:createSpinner(section,  "Revival People",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
            -- Life Coccon
            bb.ui:createSpinner(section, "Life Cocoon", 15, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFLife Cocoon")
            bb.ui:checkSectionState(section)

            -- Wrapper -----------------------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Healing")
            -- Nature's Cure
            bb.ui:createDropdown(section, "Detox", { "|cffFFDD11MMouse", "|cffFFDD11MRaid", "|cff00FF00AMouse", "|cff00FF00ARaid"},  1,  "MMouse:|cffFFFFFFMouse / Match List. \nMRaid:|cffFFFFFFRaid / Match List. \nAMouse:|cffFFFFFFMouse / All. \nARaid:|cffFFFFFFRaid / All.")
            -- Mana Tea
            bb.ui:createSpinner(section, "Mana Tea", 90, 0 , 100, 5,  "Under what |cffFF0000%MP to use |cffFFFFFFMana Tea.")
            -- Chi Wave
            bb.ui:createSpinner(section,  "Chi Wave",  55,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFChi Wave.")
            -- Enveloping Mist
            bb.ui:createSpinner(section,  "Enveloping Mist",  45,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFEnveloping Mist.")
            -- Renewing Mist
            bb.ui:createCheckbox(section,  "Renewing Mist")
            -- Soothing Mist
            bb.ui:createSpinner(section,  "Soothing Mist",  75,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFSoothing Mist.")
            -- Surging Mist
            bb.ui:createSpinner(section,  "Surging Mist",  65,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFSurging Mist.")
            bb.ui:checkSectionState(section)
    
            -- Wrapper -----------------------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "AoE Healing")
            -- Uplift
            bb.ui:createSpinner(section,  "Uplift",  75,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFUplift.")
            -- Uplift People
            bb.ui:createSpinner(section,  "Uplift People",  1,  0 , 25 ,  5,  "How many people need to be at the % to activate.")
            -- Spinning Crane Kick/RJW
            bb.ui:createSpinner(section,  "Spinning Crane Kick",  75,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFSCK.")
            bb.ui:checkSectionState(section)

            -- Wrapper -----------------------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
            -- Expel Harm
            bb.ui:createSpinner(section,  "Expel Harm",  80,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFExpel Harm")
            -- Fortifying Brew
            bb.ui:createSpinner(section,  "Fortifying Brew",  30,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFFortifying Brew")
            -- Healthstone
            bb.ui:createSpinner(section,  "Healthstone",  20,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFHealthstone")
            bb.ui:checkSectionState(section)
    
            -- Wrapper -----------------------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Toggles")
            -- Pause Toggle
            bb.ui:createDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  3)

            -- Wrapper -----------------------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Utilities")
            -- Loss of Control
            bb.ui:createCheckbox(section,"Control", "Use Loss of Control Abilities")
            -- Spear Hand Strike
            bb.ui:createSpinner(section,  "Spear Hand Strike",  60 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFSpear Hand Strike.")
            -- Paralysis
            bb.ui:createSpinner(section,  "Paralysis",  30 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFParalysis.")
            bb.ui:checkSectionState(section)

            --[[ Rotation Dropdown ]]--
            bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"Kuukuu"})
            bb:checkProfileWindowStatus()
        end
  end