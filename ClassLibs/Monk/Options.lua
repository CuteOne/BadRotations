if select(3,UnitClass("player")) == 10 then
-- Config Panel
function NewMonkConfig()
    bb.profile_window = createNewProfileWindow("Monk")
    local section

    section = createNewSection(bb.profile_window, "NOTHING")
    checkSectionState(section)

    --[[ Rotation Dropdown ]]--
    createNewRotationDropdown(bb.profile_window.parent, {"CuteOn"})
    bb:checkProfileWindowStatus()
end

--[[           ]]	--[[           ]]	--[[           ]]	--[[]] 	   --[[]]
--[[           ]]	--[[           ]]	--[[           ]]	--[[]] 	   --[[]]
--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]				--[[ ]]   --[[ ]]
--[[         ]]		--[[           ]]	--[[           ]]	--[[           ]]
--[[]]	   --[[]]	--[[        ]]		--[[]]				--[[           ]]
--[[           ]]	--[[]]	  --[[]]	--[[           ]]	--[[ ]]   --[[ ]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	 --[[]]   --[[]]

function MonkBrewConfig()
    bb.profile_window = createNewProfileWindow("Brewmaster")

    local section

    section = createNewSection(bb.profile_window, "General")
    -- Stats Buff
    createNewCheckbox(section, "Stats Buff")
    -- Detox
    createNewCheckbox(section, "Detox")
    -- Pause Toggle
    createNewDropdown(section, "Pause Toggle", bb.dropOptions.Toggle ,4)
    -- Dizzying Haze
    createNewDropdown(section, "Dizzying Haze Key", bb.dropOptions.Toggle2 ,2)
    -- Dizzying Haze
    createNewDropdown(section, "Black Ox Statue Key", bb.dropOptions.Toggle2 ,2)
    checkSectionState(section)



    section = createNewSection(bb.profile_window, "Cooldowns")
    -- Xuen
    createNewCheckbox(section, "Invoke Xuen")
    -- Breath of Fire
    createNewCheckbox(section, "Breath of Fire", "Disable usage of Breath of Fire")
    -- Elusive Brew"
    createNewSpinner(section, "Elusive Brew", 9, 0, 16, 1, "At what |cffFF0000Stack to use |cffFFFFFFElusive Brew")
    checkSectionState(section)



    section = createNewSection(bb.profile_window, "Defensive")
    -- Dazzling Brew
    --createNewCheckbox(section, "Dazzling Brew")
    -- Fortifying Brew
    createNewSpinner(section, "Fortifying Brew", 30, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFFortifying Brew")
    -- Diffuse Magic
    createNewSpinner(section, "Diffuse Magic", 30, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFDiffuse Magic")
    -- Dampen Harm
    createNewSpinner(section, "Dampen Harm", 30, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFDampen Harm")
    -- Guard
    createNewCheckbox(section, "Guard on CD")
    -- Expel Harm
    createNewSpinner(section, "Expel Harm", 30, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFExpel Harm")
    -- Healthstone
    createNewSpinner(section, "Healthstone", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFHealthstone")
    checkSectionState(section)


    section = createNewSection(bb.profile_window, "Utilities")
    -- Angry Monk
    createNewCheckbox(section, "Angry Monk", "|cffFF0000Disable Combat Check.")
    -- Resuscitate
    createNewCheckbox(section, "Resuscitate")
    checkSectionState(section)


    --[[ Rotation Dropdown ]]--
    createNewRotationDropdown(bb.profile_window.parent, {"Chumii"})

    bb:checkProfileWindowStatus()
end

--[[]]     --[[]]	--[[           ]]	--[[           ]]	--[[           ]]
--[[ ]]   --[[ ]] 		 --[[ ]]		--[[           ]]	--[[           ]]
--[[           ]] 		 --[[ ]]		--[[]]	   				 --[[ ]]
--[[           ]]		 --[[ ]]		--[[           ]]		 --[[ ]]
--[[]] 	   --[[]]		 --[[ ]]				   --[[]]		 --[[ ]]
--[[]]	   --[[]]		 --[[ ]]		--[[           ]]		 --[[ ]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[ ]]

function MonkMistConfig()
    bb.profile_window = createNewProfileWindow("Mistweaver")
    local section

    -- Wrapper -----------------------------------------
    section = createNewSection(bb.profile_window, "Buffs")
    -- Stance
    createNewDropdown(section,  "Stance", { "|cff00FF55Serpent", "|cff0077FFCrane"},  1,  "Choose Stance to use.")
    -- Legacy of the Emperor
    createNewCheckbox(section,"Legacy of the Emperor")

    createNewCheckbox(section,"Jade Serpent Statue (Left Shift)")
    checkSectionState(section)

    
    -- Wrapper -----------------------------------------
    section = createNewSection(bb.profile_window, "Cooldowns")
    createNewSpinner(section, "Revival", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFRevival")
    createNewSpinner(section,  "Revival People",  5,  0 , 25 ,  5,  "How many people need to be at the % to activate.")
    createNewSpinner(section, "Life Cocoon", 15, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFLife Cocoon")
    checkSectionState(section)


    -- Wrapper -----------------------------------------
    section = createNewSection(bb.profile_window, "Healing")
    -- Nature's Cure
    createNewDropdown(section, "Detox", { "|cffFFDD11MMouse", "|cffFFDD11MRaid", "|cff00FF00AMouse", "|cff00FF00ARaid"},  1,  "MMouse:|cffFFFFFFMouse / Match List. \nMRaid:|cffFFFFFFRaid / Match List. \nAMouse:|cffFFFFFFMouse / All. \nARaid:|cffFFFFFFRaid / All.")
    -- Chi Wave
    createNewSpinner(section,  "Chi Wave",  55,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFChi Wave.")
    -- Enveloping Mist
    createNewSpinner(section,  "Enveloping Mist",  45,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFEnveloping Mist.")
    -- Renewing Mist
    createNewSpinner(section,  "Renewing Mist",  85,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFRenewing Mist.")
    -- Soothing Mist
    createNewSpinner(section,  "Soothing Mist",  75,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFSoothing Mist.")
    -- Surging Mist
    createNewSpinner(section,  "Surging Mist",  65,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFSurging Mist.")
    checkSectionState(section)
    
    
    -- Wrapper -----------------------------------------
    section = createNewSection(bb.profile_window, "AoE Healing")
    createNewSpinner(section,  "Uplift",  75,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFUplift.")
    createNewSpinner(section,  "Uplift People",  5,  0 , 25 ,  5,  "How many people need to be at the % to activate.")
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
    -- DPS Toggle

    -- Wrapper -----------------------------------------
    section = createNewSection(bb.profile_window, "Utilities")
    -- Spear Hand Strike
    createNewSpinner(section,  "Spear Hand Strike",  60 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFSpear Hand Strike.")
    -- Quaking Palm
    createNewSpinner(section,  "Paralysis",  30 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFParalysis.")
    checkSectionState(section)



    --[[ Rotation Dropdown ]]--
    createNewRotationDropdown(bb.profile_window.parent, {"Kuukuu"})
    bb:checkProfileWindowStatus()
end
end
