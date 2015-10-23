if select(3,UnitClass("player")) == 9 then
    function DemonologyConfig()

        bb.profile_window = createNewProfileWindow("Demonology")
        local section

        section = createNewSection(bb.profile_window, "Buffs")
        checkSectionState(section)


        section = createNewSection(bb.profile_window, "DPS")
        -- Multi-Moonfire
        createNewCheckbox(section,"Multi-Dotting")
        checkSectionState(section)


        section = createNewSection(bb.profile_window, "Cooldowns")
        checkSectionState(section)


        section = createNewSection(bb.profile_window, "Healing")
        -- Drain Life
        createNewSpinner(section,  "Drain Life",  65,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDrain Life")
        -- Healthstone
        createNewSpinner(section,  "Healthstone",  35,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        checkSectionState(section)


        section = createNewSection(bb.profile_window, "Defensive")
        checkSectionState(section)


        section = createNewSection(bb.profile_window, "Toggles")
        -- Pause Toggle
        createNewDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  3)
        -- Focus Toggle
        createNewDropdown(section, "Focus Toggle", bb.dropOptions.Toggle2,  2)
        checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"CodeMyLife"})
        bb:checkProfileWindowStatus()

    end
end
