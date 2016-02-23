if select(3,UnitClass("player")) == 7 then

    function RestorationConfig()
        bb.profile_window = createNewProfileWindow("Restoration")
        local section


        -- Wrapper
        section = createNewSection(bb.profile_window, "--- |cffFF0011Buffs ---")
        -- Earthliving Weapon
        createNewCheckbox(section,"Earth Shield")
        -- Water Shield
        createNewCheckbox(section,"Water Shield")
        checkSectionState(section)
        

        -- Wrapper
        section = createNewSection(bb.profile_window, "--- |cffFF0011Healing ---")
        -- Purify Spirit
        createNewDropdown(section, "Purify Spirit", { "|cffFFDD11MMouse", "|cffFFDD11MRaid", "|cff00FF00AMouse", "|cff00FF00ARaid"},  1,  "MMouse:|cffFFFFFFMouse / Match List. \nMRaid:|cffFFFFFFRaid / Match List. \nAMouse:|cffFFFFFFMouse / All. \nARaid:|cffFFFFFFRaid / All.")
        -- Chain Heal
        createNewSpinner(section, "Chain Heal", 70, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFChain Heal on targets.")
        -- Chain Heal People
        createNewSpinner(section,  "CH People",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
        -- Healing Rain
        createNewSpinner(section,"Healing Rain", 90, 0, 100, 1, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Rain.")
        -- Healing Rain Targets
        createNewSpinner(section, "Healing Rain Targets",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
        -- Healing Stream Totem
        createNewCheckbox(section, "Healing Stream Totem")
        -- Healing Surge
        createNewSpinner(section, "Healing Surge", 40, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Surge.")
        -- Healing Wave
        createNewSpinner(section, "Healing Wave", 85, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Wave.")
        -- Riptide
        createNewSpinner(section, "Riptide", 85, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFRiptide.")
        checkSectionState(section)
        

        -- Wrapper
        section = createNewSection(bb.profile_window, "--- |cffFF0011Cooldowns ---")
        -- Ascendance
        createNewSpinner(section, "Ascendance", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFAscendance")
        -- Ascendance People
        createNewSpinner(section,  "Ascendance People",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
        -- Healing Tide Totem
        createNewSpinner(section, "Healing Tide Totem", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFHealing Tide Totem")
        -- Healing Tide Totem People
        createNewSpinner(section,  "HT Totem People",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
        -- Spirit Link Totem
        createNewSpinner(section, "Spirit Link Totem", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFSpirit Link Totem")
        -- Spirit Link Totem People
        createNewSpinner(section,  "SL Totem People",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
        checkSectionState(section)

        -- Wrapper
        section = createNewSection(bb.profile_window, "--- |cffFF0011Defensive ---")
        -- Astral Shift
        createNewSpinner(section, "Astral Shift", 30, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFAstral Shit")
        -- Healing Stream
        createNewSpinner(section, "Healthstone", 50, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Stream")
        checkSectionState(section)

        -- Wrapper
        section = createNewSection(bb.profile_window, "--- |cffFF0011Utilities ---")
        -- Standard Interrupt
        createNewSpinner(section, "Wind Shear", 35 , 0, 100, 5, "|cffFFBB00Over what % of cast we want to |cffFFFFFFWind Shear.")
        -- Purge
        createNewCheckbox(section,"Purge")
        checkSectionState(section)

        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"Kuukuu"})
        bb:checkProfileWindowStatus()
    end
end
