if select(3, UnitClass("player")) == 11 then
    function MoonkinConfig()
        bb.profile_window = createNewProfileWindow("Moonkin")
        local section

        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "|cffBA55D3Offensive")
        -- bosscheck
        createNewCheckbox(section,"isBoss")

        if isKnown(26297) then
            createNewCheckbox(section,"Berserking")
        end

        -- Celestial Alignment
        createNewCheckbox(section,"Celestial Alignment")

        createNewCheckbox(section,"CA: Wrath","Cast Wrath instead of Starfire on Celestial Alignment")

        -- Incarnation
        createNewCheckbox(section,"Incarnation")

        -- onUse Trinkets
        createNewCheckbox(section,"Trinket 1")
        createNewCheckbox(section,"Trinket 2")
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "|cffBA55D3Defensive")
        -- Rejuvenation
        createNewSpinner(section,  "Rejuvenation", 60,  0, 100, 2,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation")

        -- Healing Touch
        createNewSpinner(section,  "Healing Touch", 30,  0, 100, 2,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch")

        -- Barkskin
        createNewSpinner(section,  "Barkskin", 25,  0, 100, 2,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin")

        -- Natures Vigil
        -- createNewCheckbox(section,"Natures Vigil")

        -- Healing Tonic
        createNewSpinner(section,  "Healing Tonic", 25,  0, 100, 2,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Tonic")
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "|cffBA55D3Boss Specific")
        checkSectionState(section)

        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "|cffBA55D3Multitarget")
        -- Sort EnemiesTable by HPabs
        -- createNewCheckbox(section,"sortByHPabs","Sort enemiesTable by descending health, so the highest absolute health unit will be dotted first.")

        -- Min Health
        createNewSpinner(section, "Min Health",  0.1,  0.0,  7.5,  0.1,  "Minimum Health in |cffFF0000million HP|cffFFBB00.\nMin: 0 / Max: 7.5  / Interval: 0.1")

        -- Max Targets
        createNewSpinner(section, "Max Targets",  5,  1,  10,  1,  "Maximum count of Moonfire/Sunfire on Units.")

        -- Starfall Targets
        -- Auto Starfall
        createNewSpinner(section, "Starfall Charges",  2,  1,  10,  1, "Automatic Starfall if enough charges",  "Minimum count of charges \nto use Starfall. \nMin: 0 / Max: 3 / Interval: 1")
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "|cffBA55D3Utilities")
        -- Pause Toggle
        createNewDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  10)

        -- Mark of the Wild
        createNewCheckbox(section,"MotW")

        -- Shadowform Outfight
        createNewCheckbox(section,"Boomkin Form")

        -- Dummy DPS Test
        createNewSpinner(section, "DPS Testing",  4,  1,  15,  1,  "Set to desired time for test in minutes.\nMin: 1 / Max: 15 / Interval: 1")
        checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"ragnar"})
        bb:checkProfileWindowStatus()
    end
end