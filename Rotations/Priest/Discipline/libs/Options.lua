if select(3, UnitClass("player")) == 5 then

    function DisciplineConfig()
        bb.ui.window.profile = bb.ui:createProfileWindow("semi auto disc")
        local section

        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "|cffBA55D3Offensive")
        -- Smite
        bb.ui:createSpinner(section, "Smite Filler",  50,  1,  100,  2,  "Smite until %Mana")
        -- PWS
        bb.ui:createSpinner(section, "PW:Shield",  5,  1,  40,  1,  "Set to max count for PWS in raid")
        -- heal
        bb.ui:createSpinner(section, "Heal",  4,  1,  40,  1,  "Heal under %HP")
        -- flash heal
        bb.ui:createSpinner(section, "Flash Heal",  30,  1,  100,  2,  "Flash Heal under %HP")
        -- penance
        --bb.ui:createSpinner(section, "Penance",  4,  1,  40,  1,  "")
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "|cffBA55D3Utilities")
        -- Pause Toggle
        bb.ui:createCheckbox(section,"Pause Toggle")
        bb.ui:createDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  10)
        --Power Word: Fortitude
        bb.ui:createCheckbox(section,"PW:Fortitude")
        bb.ui:checkSectionState(section)

        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"ragnar"})
        bb:checkProfileWindowStatus()
    end
end