if select(3,UnitClass("player")) == 7 then
    function ElementalConfig()
        bb.ui.window.profile = bb.ui:createProfileWindow("Elemental")
        local section

        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "Buffs")
        -- Lightning Shield
        bb.ui:createCheckbox(section,"Lightning Shield")
        bb.ui:checkSectionState(section)


        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
        -- Ancestral Swiftness
        if isKnown(_AncestralSwiftness) then
            bb.ui:createDropdown(section,  "Ancestral Swiftness", bb.dropOptions.CD,  1)
        end
        -- Ascendance
        bb.ui:createDropdown(section,  "Ascendance", bb.dropOptions.CD,  1)
        -- Elemental Mastery
        if isKnown(_ElementalMastery) then
            bb.ui:createDropdown(section, "Elemental Mastery", bb.dropOptions.CD, 1)
        end
        -- Fire Elemental
        bb.ui:createDropdown(section, "Fire Elemental", bb.dropOptions.CD, 1)
        -- Storm Elemental Totem
        if isKnown(_StormElementalTotem) then
            bb.ui:createDropdown(section, "Storm Elemental Totem", bb.dropOptions.CD, 1)
        end
        -- Searing
        bb.ui:createCheckbox(section,"Searing")
        bb.ui:checkSectionState(section)


        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "DPS Tweaks")
        -- EarthQuake
        bb.ui:createDropdown(section, "EarthQuake", bb.dropOptions.CD, 1)
        -- Thunderstorm
        bb.ui:createDropdown(section, "Thunderstorm", bb.dropOptions.CD, 1)
        bb.ui:checkSectionState(section)


        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
        -- Astral Shift
        bb.ui:createSpinner(section, "Astral Shift", 30, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFAstral Shit")
        -- Healing Stream
        bb.ui:createSpinner(section, "Healing Stream", 50, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Stream")
        -- Healing Rain
        bb.ui:createSpinner(section, "Healing Rain", 50, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Stream")
        -- Shamanistic Rage
        bb.ui:createSpinner(section, "Shamanistic Rage", 70, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFShamanistic Rage")
        bb.ui:checkSectionState(section)


        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "Utilities")
        -- Healing Surge Toggle
        bb.ui:createDropdown(section, "Healing Surge Toggle", bb.dropOptions.Toggle2, 4)
        -- Pause Toggle
        bb.ui:createDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2, 3)
        -- Standard Interrupt
        bb.ui:createSpinner(section, "Wind Shear", 35, 0, 100, 5, "|cffFFBB00Over what % of cast we want to |cffFFFFFFWind Shear.")
        bb.ui:checkSectionState(section)

        

        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"CodeMyLife"})
        bb:checkProfileWindowStatus()
    end
end
