if select(3,UnitClass("player")) == 7 then
    function ElementalConfig()
        bb.profile_window = createNewProfileWindow("Elemental")
        local section

        -- Wrapper
        section = createNewSection(bb.profile_window, "Buffs")
        -- Lightning Shield
        createNewCheckbox(section,"Lightning Shield")
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "Cooldowns")
        -- Ancestral Swiftness
        if isKnown(_AncestralSwiftness) then
            createNewDropdown(section,  "Ancestral Swiftness", bb.dropOptions.CD,  1)
        end
        -- Ascendance
        createNewDropdown(section,  "Ascendance", bb.dropOptions.CD,  1)
        -- Elemental Mastery
        if isKnown(_ElementalMastery) then
            createNewDropdown(section, "Elemental Mastery", bb.dropOptions.CD, 1)
        end
        -- Fire Elemental
        createNewDropdown(section, "Fire Elemental", bb.dropOptions.CD, 1)
        -- Storm Elemental Totem
        if isKnown(_StormElementalTotem) then
            createNewDropdown(section, "Storm Elemental Totem", bb.dropOptions.CD, 1)
        end
        -- Searing
        createNewCheckbox(section,"Searing")
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "DPS Tweaks")
        -- EarthQuake
        createNewDropdown(section, "EarthQuake", bb.dropOptions.CD, 1)
        -- Thunderstorm
        createNewDropdown(section, "Thunderstorm", bb.dropOptions.CD, 1)
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "Defensive")
        -- Astral Shift
        createNewSpinner(section, "Astral Shift", 30, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFAstral Shit")
        -- Healing Stream
        createNewSpinner(section, "Healing Stream", 50, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Stream")
        -- Healing Rain
        createNewSpinner(section, "Healing Rain", 50, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Stream")
        -- Shamanistic Rage
        createNewSpinner(section, "Shamanistic Rage", 70, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFShamanistic Rage")
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "Utilities")
        -- Healing Surge Toggle
        createNewDropdown(section, "Healing Surge Toggle", bb.dropOptions.Toggle2, 4)
        -- Pause Toggle
        createNewDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2, 3)
        -- Standard Interrupt
        createNewSpinner(section, "Wind Shear", 35, 0, 100, 5, "|cffFFBB00Over what % of cast we want to |cffFFFFFFWind Shear.")
        checkSectionState(section)

        

        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"CodeMyLife"})
        bb:checkProfileWindowStatus()
    end
end
