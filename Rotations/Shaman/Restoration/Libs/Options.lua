if select(3,UnitClass("player")) == 7 then

    function RestorationConfig()
        bb.profile_window = createNewProfileWindow("Restoration")
        local section


        -- Wrapper
        section = createNewSection(bb.profile_window, "--- |cffFF0011Buffs ---")
        -- Earthliving Weapon
        createNewCheckbox(section,"Earthliving Weapon")
        -- Water Shield
        createNewCheckbox(section,"Water Shield")
        checkSectionState(section)
        

        -- Wrapper
        section = createNewSection(bb.profile_window, "--- |cffFF0011Healing ---")
        -- Healing Wave
        createNewSpinner(section, "Healing Wave", 85, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Wave.")
        -- Healing Surge
        createNewSpinner(section, "Healing Surge", 40, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Surge.")
        -- Chain Heal
        createNewSpinner(section, "Chain Heal", 70, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFChain Heal on 3 targets.")
        checkSectionState(section)
        

        -- Wrapper
        section = createNewSection(bb.profile_window, "--- |cffFF0011Cooldowns ---")
        -- Ascendance
        createNewDropdown(section, "Ascendance", bb.dropOptions.CD, 1)
        -- Fire Elemental
        createNewDropdown(section, "Fire Elemental", bb.dropOptions.CD, 1)
        -- Stormlash
        createNewDropdown(section, "Stormlash", bb.dropOptions.CD, 1)
        checkSectionState(section)
       

        -- Wrapper
        section = createNewSection(bb.profile_window, "--- |cffFF0011DPS Tweaks ---")
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "--- |cffFF0011Defensive ---")
        -- Astral Shift
        createNewSpinner(section, "Astral Shift", 30, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFAstral Shit")
        -- Healing Stream
        createNewSpinner(section, "Healing Stream", 50, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Stream")
        -- Shamanistic Rage
        createNewSpinner(section, "Shamanistic Rage", 70, 0, 100, 5, "|cffFFBB00Under what %HP to use |cffFFFFFFShamanistic Rage")
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "--- |cffFF0011Utilities ---")
        -- Standard Interrupt
        createNewSpinner(section, "Wind Shear", 35 , 0, 100, 5, "|cffFFBB00Over what % of cast we want to |cffFFFFFFWind Shear.")
        checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"CodeMyLife"})
        bb:checkProfileWindowStatus()
    end
end
