if select(3,UnitClass("player")) == 7 then

    function RestorationConfig()
        bb.ui.window.profile = bb.ui:createProfileWindow("Restoration")
        local section


        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "--- |cffFF0011Buffs ---")
        -- Earthliving Weapon
        bb.ui:createCheckbox(section,"Earth Shield")
        -- Water Shield
        bb.ui:createCheckbox(section,"Water Shield")
        bb.ui:checkSectionState(section)
        

        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "--- |cffFF0011Healing ---")
        -- Purify Spirit
        bb.ui:createDropdown(section, "Purify Spirit", { "|cffFFDD11MMouse", "|cffFFDD11MRaid", "|cff00FF00AMouse", "|cff00FF00ARaid"},  1,  "MMouse:|cffFFFFFFMouse / Match List. \nMRaid:|cffFFFFFFRaid / Match List. \nAMouse:|cffFFFFFFMouse / All. \nARaid:|cffFFFFFFRaid / All.")
        -- Chain Heal
        bb.ui:createSpinner(section, "Chain Heal", 70, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFChain Heal on targets.")
        -- Chain Heal People
        bb.ui:createSpinner(section,  "CH People",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
        -- Healing Rain
        bb.ui:createSpinner(section,"Healing Rain", 90, 0, 100, 1, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Rain.")
        -- Healing Rain Targets
        bb.ui:createSpinner(section, "Healing Rain Targets",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
        -- Healing Stream Totem
        bb.ui:createCheckbox(section, "Healing Stream Totem")
        -- Healing Surge
        bb.ui:createSpinner(section, "Healing Surge", 40, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Surge.")
        -- Healing Wave
        bb.ui:createSpinner(section, "Healing Wave", 85, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Wave.")
        -- Riptide
        bb.ui:createSpinner(section, "Riptide", 85, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFRiptide.")
        bb.ui:checkSectionState(section)
        

        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "--- |cffFF0011Cooldowns ---")
        -- Ascendance
        bb.ui:createSpinner(section, "Ascendance", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFAscendance")
        -- Ascendance People
        bb.ui:createSpinner(section,  "Ascendance People",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
        -- Healing Tide Totem
        bb.ui:createSpinner(section, "Healing Tide Totem", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFHealing Tide Totem")
        -- Healing Tide Totem People
        bb.ui:createSpinner(section,  "HT Totem People",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
        -- Spirit Link Totem
        bb.ui:createSpinner(section, "Spirit Link Totem", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFSpirit Link Totem")
        -- Spirit Link Totem People
        bb.ui:createSpinner(section,  "SL Totem People",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
        bb.ui:checkSectionState(section)

        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "--- |cffFF0011Defensive ---")
        -- Astral Shift
        bb.ui:createSpinner(section, "Astral Shift", 30, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFAstral Shit")
        -- Healing Stream
        bb.ui:createSpinner(section, "Healthstone", 50, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Stream")
        bb.ui:checkSectionState(section)

        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "--- |cffFF0011Utilities ---")
        -- Standard Interrupt
        bb.ui:createSpinner(section, "Wind Shear", 35 , 0, 100, 5, "|cffFFBB00Over what % of cast we want to |cffFFFFFFWind Shear.")
        -- Purge
        bb.ui:createCheckbox(section,"Purge")
        bb.ui:checkSectionState(section)

        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"Kuukuu"})
        bb:checkProfileWindowStatus()
    end
end
