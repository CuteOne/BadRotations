 if select(3,UnitClass("player")) == 9 then
-- Config Panel
   function DestructionConfig()
            bb.ui.window.profile = bb.ui:createProfileWindow("Destruction")
            local section

            -- Wrapper -----------------------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Buffs")
            -- Dark Intent
            bb.ui:createCheckbox(section,"Dark Intent")
            bb.ui:checkSectionState(section)

            -- Wrapper -----------------------------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "General")
            -- Dummy DPS Test
            bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Demon
            bb.ui:createDropdown(section,  "Summon Demon", { "Felhunter","Imp","Succubus","VoidWalker"},  1,  "Choose Demon to Summon.")
            -- Flask / Crystal
            bb.ui:createCheckbox(section,"Flask")
            bb.ui:checkSectionState(section)

            -- Wrapper -----------------------------------------
            --section = bb.ui:createSection(bb.ui.window.profile,  "Cooldowns")
            -- Legendary Ring
                --bb.ui:createCheckbox(section,"Legendary Ring")
            -- Trinkets
                --bb.ui:createCheckbox(section,"Trinkets")
            -- Touch of the Void
                --bb.ui:createCheckbox(section,"Touch of the Void")
            --bb.ui:checkSectionState(section)

            -- Wrapper -----------------------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
            -- Expel Harm
            bb.ui:createSpinner(section,  "Ember Tap",  80,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFEmber Tap")
            -- Fortifying Brew
            bb.ui:createSpinner(section,  "Heirloom Neck",  30,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFHeirloom Neck")
            -- Healthstone
            bb.ui:createSpinner(section,  "Pot/Stoned",  20,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFHealthstone")
            -- Unending Resolve
            bb.ui:createSpinner(section,  "Unending Resolve",  20,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFUnending Resolve")
            bb.ui:checkSectionState(section)
    
            -- Wrapper -----------------------------------------
            --section = bb.ui:createSection(bb.ui.window.profile, "Toggles")
            -- Pause Toggle
            --bb.ui:createDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  3)

            -- Wrapper -----------------------------------------
            --section = bb.ui:createSection(bb.ui.window.profile, "Utilities")
            -- Shadowfury
            --bb.ui:createSpinner(section,  "Shadowfury",  60 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFShadowfury.")
            --bb.ui:checkSectionState(section)

            --[[ Rotation Dropdown ]]--
            bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"Kuukuu","Test"})
            bb:checkProfileWindowStatus()
        end
  end
