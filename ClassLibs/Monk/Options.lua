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
    createNewDropdown(section,  "Stance", { "|cff00FF55Serpent", "|cff0077FFTiger"},  1,  "Choose Stance to use.")
    -- Legacy of the Emperor
    createNewCheckbox(section,"Legacy of the Emperor")
    checkSectionState(section)

    
    -- Wrapper -----------------------------------------
    section = createNewSection(bb.profile_window, "Cooldowns")
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
    -- Uplift Toggle
    createNewDropdown(section, "Uplift Toggle", bb.dropOptions.Toggle2,  4)
    -- Pause Toggle
    createNewDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  3)
    -- Focus Toggle
    createNewDropdown(section, "Focus Toggle", bb.dropOptions.Toggle2,  2)
    -- DPS Toggle
    createNewDropdown(section, "DPS Toggle", bb.dropOptions.Toggle2,  1)
    checkSectionState(section)


    -- Wrapper -----------------------------------------
    section = createNewSection(bb.profile_window, "Utilities")
    -- Follow Tank
    createNewSpinner(section,  "Follow Tank",  25,  10,  40  ,  1,  "Range from focus...")
    -- Spear Hand Strike
    createNewSpinner(section,  "Spear Hand Strike",  60 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFSpear and Strike.")
    -- Quaking Palm
    createNewSpinner(section,  "Quaking Palm",  30 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFQuaking Palm.")
    -- Resuscitate
    createNewCheckbox(section,"Resuscitate")
    -- Roll
    createNewCheckbox(section,"Roll")
    checkSectionState(section)



    --[[ Rotation Dropdown ]]--
    createNewRotationDropdown(bb.profile_window.parent, {"CodeMyLife"})
    bb:checkProfileWindowStatus()
end
end
