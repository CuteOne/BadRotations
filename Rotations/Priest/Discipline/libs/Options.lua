if select(3, UnitClass("player")) == 5 then

    function DisciplineConfig()
        bb.profile_window = createNewProfileWindow("semi auto disc")
        local section

        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "|cffBA55D3Offensive")
        -- Smite
        createNewSpinner(section, "Smite Filler",  50,  1,  100,  2,  "Smite until %Mana")
        -- PWS
        createNewSpinner(section, "PW:Shield",  5,  1,  40,  1,  "Set to max count for PWS in raid")
        -- heal
        createNewSpinner(section, "Heal",  4,  1,  40,  1,  "Heal under %HP")
        -- flash heal
        createNewSpinner(section, "Flash Heal",  30,  1,  100,  2,  "Flash Heal under %HP")
        -- penance
        --createNewSpinner(section, "Penance",  4,  1,  40,  1,  "")
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "|cffBA55D3Utilities")
        -- Pause Toggle
        createNewCheckbox(section,"Pause Toggle")
        createNewDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  10)
        --Power Word: Fortitude
        createNewCheckbox(section,"PW:Fortitude")
        checkSectionState(section)

        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"ragnar"})
        bb:checkProfileWindowStatus()
    end
end