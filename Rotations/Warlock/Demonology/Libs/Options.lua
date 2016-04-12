if select(3,UnitClass("player")) == 9 then
    function DemonologyConfig()

        bb.ui.window.profile = bb.ui:createProfileWindow("Demonology")
        local section

        section = bb.ui:createSection(bb.ui.window.profile, "Buffs")
        bb.ui:checkSectionState(section)


        section = bb.ui:createSection(bb.ui.window.profile, "DPS")
        -- Multi-Moonfire
        bb.ui:createCheckbox(section,"Multi-Dotting")
        bb.ui:checkSectionState(section)


        section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
        bb.ui:checkSectionState(section)


        section = bb.ui:createSection(bb.ui.window.profile, "Healing")
        -- Drain Life
        bb.ui:createSpinner(section,  "Drain Life",  65,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDrain Life")
        -- Healthstone
        bb.ui:createSpinner(section,  "Healthstone",  35,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        bb.ui:checkSectionState(section)


        section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
        bb.ui:checkSectionState(section)


        section = bb.ui:createSection(bb.ui.window.profile, "Toggles")
        -- Pause Toggle
        bb.ui:createDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  3)
        -- Focus Toggle
        bb.ui:createDropdown(section, "Focus Toggle", bb.dropOptions.Toggle2,  2)
        bb.ui:checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"CodeMyLife"})
        bb:checkProfileWindowStatus()

    end
end
