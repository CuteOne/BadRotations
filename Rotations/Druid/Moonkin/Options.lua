if select(3, UnitClass("player")) == 11 then
    function MoonkinConfig()
        bb.ui.window.profile = bb.ui:createProfileWindow("Moonkin")
        local section

        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "|cffBA55D3Offensive")
        -- bosscheck
        bb.ui:createCheckbox(section,"isBoss")

        if isKnown(26297) then
            bb.ui:createCheckbox(section,"Berserking")
        end

        -- Celestial Alignment
        bb.ui:createCheckbox(section,"Celestial Alignment")

        bb.ui:createCheckbox(section,"CA: Wrath","Cast Wrath instead of Starfire on Celestial Alignment")

        -- Incarnation
        bb.ui:createCheckbox(section,"Incarnation")

        -- onUse Trinkets
        bb.ui:createCheckbox(section,"Trinket 1")
        bb.ui:createCheckbox(section,"Trinket 2")
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "|cffBA55D3Defensive")
        -- Rejuvenation
        bb.ui:createSpinner(section,  "Rejuvenation", 60,  0, 100, 2,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation")

        -- Healing Touch
        bb.ui:createSpinner(section,  "Healing Touch", 30,  0, 100, 2,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch")

        -- Barkskin
        bb.ui:createSpinner(section,  "Barkskin", 25,  0, 100, 2,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin")

        -- Natures Vigil
        -- bb.ui:createCheckbox(section,"Natures Vigil")

        -- Healing Tonic
        bb.ui:createSpinner(section,  "Healing Tonic", 25,  0, 100, 2,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Tonic")
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "|cffBA55D3Boss Specific")
        bb.ui:checkSectionState(section)

        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "|cffBA55D3Multitarget")
        -- Sort bb.enemy by HPabs
        -- bb.ui:createCheckbox(section,"sortByHPabs","Sort bb.enemy by descending health, so the highest absolute health unit will be dotted first.")

        -- Min Health
        bb.ui:createSpinner(section, "Min Health",  0.1,  0.0,  7.5,  0.1,  "Minimum Health in |cffFF0000million HP|cffFFBB00.\nMin: 0 / Max: 7.5  / Interval: 0.1")

        -- Max Targets
        bb.ui:createSpinner(section, "Max Targets",  5,  1,  10,  1,  "Maximum count of Moonfire/Sunfire on Units.")

        -- Starfall Targets
        -- Auto Starfall
        bb.ui:createSpinner(section, "Starfall Charges",  2,  1,  10,  1, "Automatic Starfall if enough charges",  "Minimum count of charges \nto use Starfall. \nMin: 0 / Max: 3 / Interval: 1")
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "|cffBA55D3Utilities")
        -- Pause Toggle
        bb.ui:createDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  10)

        -- Mark of the Wild
        bb.ui:createCheckbox(section,"MotW")

        -- Shadowform Outfight
        bb.ui:createCheckbox(section,"Boomkin Form")

        -- Dummy DPS Test
        bb.ui:createSpinner(section, "DPS Testing",  4,  1,  15,  1,  "Set to desired time for test in minutes.\nMin: 1 / Max: 15 / Interval: 1")
        bb.ui:checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"ragnar"})
        bb:checkProfileWindowStatus()
    end
end