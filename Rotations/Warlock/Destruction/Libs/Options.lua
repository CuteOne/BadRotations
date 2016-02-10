 if select(3,UnitClass("player")) == 9 then
-- Config Panel
   function DestructionConfig()
            bb.profile_window = createNewProfileWindow("Destruction")
            local section

            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Buffs")
            -- Dark Intent
            createNewCheckbox(section,"Dark Intent")
            checkSectionState(section)

            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window,  "General")
            -- Dummy DPS Test
            createNewSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Demon
            createNewDropdown(section,  "Summon Demon", { "Felhunter","Imp","Succubus","VoidWalker"},  1,  "Choose Demon to Summon.")
            -- Flask / Crystal
            createNewCheckbox(section,"Flask")
            checkSectionState(section)

            -- Wrapper -----------------------------------------
            --section = createNewSection(bb.profile_window,  "Cooldowns")
            -- Legendary Ring
                --createNewCheckbox(section,"Legendary Ring")
            -- Trinkets
                --createNewCheckbox(section,"Trinkets")
            -- Touch of the Void
                --createNewCheckbox(section,"Touch of the Void")
            --checkSectionState(section)

            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Defensive")
            -- Expel Harm
            createNewSpinner(section,  "Ember Tap",  80,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFEmber Tap")
            -- Fortifying Brew
            createNewSpinner(section,  "Heirloom Neck",  30,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFHeirloom Neck")
            -- Healthstone
            createNewSpinner(section,  "Pot/Stoned",  20,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFHealthstone")
            -- Unending Resolve
            createNewSpinner(section,  "Unending Resolve",  20,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFUnending Resolve")
            checkSectionState(section)
    
            -- Wrapper -----------------------------------------
            --section = createNewSection(bb.profile_window, "Toggles")
            -- Pause Toggle
            --createNewDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  3)

            -- Wrapper -----------------------------------------
            --section = createNewSection(bb.profile_window, "Utilities")
            -- Shadowfury
            --createNewSpinner(section,  "Shadowfury",  60 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFShadowfury.")
            --checkSectionState(section)

            --[[ Rotation Dropdown ]]--
            createNewRotationDropdown(bb.profile_window.parent, {"Kuukuu","Test"})
            bb:checkProfileWindowStatus()
        end
  end
