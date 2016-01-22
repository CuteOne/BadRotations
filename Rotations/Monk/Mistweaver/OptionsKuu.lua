 if select(3,UnitClass("player")) == 10 then
-- Config Panel
   function MistMonkConfig()
            bb.profile_window = createNewProfileWindow("Mistweaver")
            local section

            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Buffs")
            -- Stance
            createNewDropdown(section,  "Stance", { "|cff00FF55Serpent", "|cff0077FFCrane"},  1,  "Choose Stance to use.")
            -- Legacy of the Emperor
            createNewCheckbox(section,"Legacy of the Emperor")
            --Jade Serpent Statue
            createNewCheckbox(section,"Jade Serpent Statue (Left Shift)")
            checkSectionState(section)
    
            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Cooldowns")
            -- Revival
            createNewSpinner(section, "Revival", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFRevival")
            -- Revival People
            createNewSpinner(section,  "Revival People",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
            -- Life Coccon
            createNewSpinner(section, "Life Cocoon", 15, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFLife Cocoon")
            checkSectionState(section)

            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Healing")
            -- Nature's Cure
            createNewDropdown(section, "Detox", { "|cffFFDD11MMouse", "|cffFFDD11MRaid", "|cff00FF00AMouse", "|cff00FF00ARaid"},  1,  "MMouse:|cffFFFFFFMouse / Match List. \nMRaid:|cffFFFFFFRaid / Match List. \nAMouse:|cffFFFFFFMouse / All. \nARaid:|cffFFFFFFRaid / All.")
            -- Mana Tea
            createNewSpinner(section, "Mana Tea", 90, 0 , 100, 5,  "Under what |cffFF0000%MP to use |cffFFFFFFMana Tea.")
            -- Chi Wave
            createNewSpinner(section,  "Chi Wave",  55,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFChi Wave.")
            -- Enveloping Mist
            createNewSpinner(section,  "Enveloping Mist",  45,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFEnveloping Mist.")
            -- Renewing Mist
            createNewCheckbox(section,  "Renewing Mist")
            -- Soothing Mist
            createNewSpinner(section,  "Soothing Mist",  75,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFSoothing Mist.")
            -- Surging Mist
            createNewSpinner(section,  "Surging Mist",  65,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFSurging Mist.")
            checkSectionState(section)
    
            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "AoE Healing")
            -- Uplift
            createNewSpinner(section,  "Uplift",  75,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFUplift.")
            -- Uplift People
            createNewSpinner(section,  "Uplift People",  5,  0 , 25 ,  5,  "How many people need to be at the % to activate.")
            -- Spinning Crane Kick/RJW
            createNewSpinner(section,  "Spinning Crane Kick",  75,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFSCK.")
            checkSectionState(section)

            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Defensive")
            -- Expel Harm
            createNewSpinner(section,  "Expel Harm",  80,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFExpel Harm")
            -- Fortifying Brew
            createNewSpinner(section,  "Fortifying Brew",  30,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFFortifying Brew")
            -- Healthstone
            createNewSpinner(section,  "Healthstone",  20,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFHealthstone")
            checkSectionState(section)
    
            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Toggles")
            -- Pause Toggle
            createNewDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  3)

            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Utilities")
            -- Spear Hand Strike
            createNewSpinner(section,  "Spear Hand Strike",  60 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFSpear Hand Strike.")
            -- Paralysis
            createNewSpinner(section,  "Paralysis",  30 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFParalysis.")
            checkSectionState(section)

            --[[ Rotation Dropdown ]]--
            createNewRotationDropdown(bb.profile_window.parent, {"Kuukuu"})
            bb:checkProfileWindowStatus()
        end
  end