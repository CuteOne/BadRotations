if select(3,UnitClass("player")) == 10 then
-- Config Panel
function NewMonkConfig()
    bb.ui.window.profile = bb.ui:createProfileWindow("Monk")
    local section

    section = bb.ui:createSection(bb.ui.window.profile, "NOTHING")
    bb.ui:checkSectionState(section)

    --[[ Rotation Dropdown ]]--
    bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"CuteOn"})
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
    bb.ui.window.profile = bb.ui:createProfileWindow("Brewmaster")

    local section

    section = bb.ui:createSection(bb.ui.window.profile, "General")
    -- Stats Buff
    bb.ui:createCheckbox(section, "Stats Buff")
    -- Detox
    bb.ui:createCheckbox(section, "Detox")
    -- Pause Toggle
    bb.ui:createDropdown(section, "Pause Toggle", bb.dropOptions.Toggle ,4)
    -- Dizzying Haze
    bb.ui:createDropdown(section, "Dizzying Haze Key", bb.dropOptions.Toggle2 ,2)
    -- Dizzying Haze
    bb.ui:createDropdown(section, "Black Ox Statue Key", bb.dropOptions.Toggle2 ,2)
    bb.ui:checkSectionState(section)



    section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
    -- Xuen
    bb.ui:createCheckbox(section, "Invoke Xuen")
    -- Breath of Fire
    bb.ui:createCheckbox(section, "Breath of Fire", "Disable usage of Breath of Fire")
    -- Elusive Brew"
    bb.ui:createSpinner(section, "Elusive Brew", 9, 0, 16, 1, "At what |cffFF0000Stack to use |cffFFFFFFElusive Brew")
    bb.ui:checkSectionState(section)



    section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
    -- Dazzling Brew
    --bb.ui:createCheckbox(section, "Dazzling Brew")
    -- Fortifying Brew
    bb.ui:createSpinner(section, "Fortifying Brew", 30, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFFortifying Brew")
    -- Diffuse Magic
    bb.ui:createSpinner(section, "Diffuse Magic", 30, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFDiffuse Magic")
    -- Dampen Harm
    bb.ui:createSpinner(section, "Dampen Harm", 30, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFDampen Harm")
    -- Guard
    bb.ui:createCheckbox(section, "Guard on CD")
    -- Expel Harm
    bb.ui:createSpinner(section, "Expel Harm", 30, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFExpel Harm")
    -- Healthstone
    bb.ui:createSpinner(section, "Healthstone", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFHealthstone")
    bb.ui:checkSectionState(section)


    section = bb.ui:createSection(bb.ui.window.profile, "Utilities")
    -- Angry Monk
    bb.ui:createCheckbox(section, "Angry Monk", "|cffFF0000Disable Combat Check.")
    -- Resuscitate
    bb.ui:createCheckbox(section, "Resuscitate")
    bb.ui:checkSectionState(section)


    --[[ Rotation Dropdown ]]--
    bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"Chumii"})

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
    bb.ui.window.profile = bb.ui:createProfileWindow("Mistweaver")
    local section

    -- Wrapper -----------------------------------------
    section = bb.ui:createSection(bb.ui.window.profile, "Buffs")
    -- Stance
    bb.ui:createDropdown(section,  "Stance", { "|cff00FF55Serpent", "|cff0077FFCrane"},  1,  "Choose Stance to use.")
    -- Legacy of the Emperor
    bb.ui:createCheckbox(section,"Legacy of the Emperor")

    bb.ui:createCheckbox(section,"Jade Serpent Statue (Left Shift)")
    bb.ui:checkSectionState(section)

    
    -- Wrapper -----------------------------------------
    section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
    bb.ui:createSpinner(section, "Revival", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFRevival")
    bb.ui:createSpinner(section,  "Revival People",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
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
    bb.ui:createSpinner(section,  "Renewing Mist",  85,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFRenewing Mist.")
    -- Soothing Mist
    bb.ui:createSpinner(section,  "Soothing Mist",  75,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFSoothing Mist.")
    -- Surging Mist
    bb.ui:createSpinner(section,  "Surging Mist",  65,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFSurging Mist.")
    bb.ui:checkSectionState(section)
    
    
    -- Wrapper -----------------------------------------
    section = bb.ui:createSection(bb.ui.window.profile, "AoE Healing")
    bb.ui:createSpinner(section,  "Uplift",  75,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFUplift.")
    bb.ui:createSpinner(section,  "Uplift People",  5,  0 , 25 ,  5,  "How many people need to be at the % to activate.")
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
    -- DPS Toggle

    -- Wrapper -----------------------------------------
    section = bb.ui:createSection(bb.ui.window.profile, "Utilities")
    -- Spear Hand Strike
    bb.ui:createSpinner(section,  "Spear Hand Strike",  60 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFSpear Hand Strike.")
    -- Quaking Palm
    bb.ui:createSpinner(section,  "Paralysis",  30 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFParalysis.")
    bb.ui:checkSectionState(section)



    --[[ Rotation Dropdown ]]--
    bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"Kuukuu"})
    bb:checkProfileWindowStatus()
end
end
