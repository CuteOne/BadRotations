if select(3, UnitClass("player")) == 11 then
    function GuardianConfig()
        bb.ui.window.profile = bb.ui:createProfileWindow("Guardian")
        local section

        section = bb.ui:createSection(bb.ui.window.profile, "---------- Buffs ---------")
        -- Mark Of The Wild
        bb.ui:createCheckbox(section,"Mark Of The Wild")
        -- Auto Shift
        bb.ui:createCheckbox(section,"Auto Shapeshifts", "Auto Shapeshifts")
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "--------- Healing -------")
        -- DoC Healing Touch
        bb.ui:createDropdown(section,  "DoCHT", { "|cffFFBB00Player", "|cff0077FFLowest"},  2,  "Use DoC Procs Healing Touch on...")
        -- Cenarion Ward
        bb.ui:createDropdown(section,  "CenWard", { "|cffFFBB00Player", "|cff0077FFLowest"},  2,  "Use Cenarion Ward on...")
        bb.ui:checkSectionState(section)

        
        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "------- Cooldowns -----")
        bb.ui:createCheckbox(section,"useBerserk", "Check to use Berserk on CD (Boss/Dummy)")
        bb.ui:createSpinner(section, "useHotW",  65,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHotW and start keeping Rejuvenation up")
        bb.ui:createCheckbox(section,"useNVigil")
        bb.ui:createCheckbox(section,"useIncarnation")
        bb.ui:checkSectionState(section)

        
        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "------- Defensive ------")        -- Healthstone
        bb.ui:createSpinner(section,  "Healthstone",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        -- Survival Instincts
        bb.ui:createSpinner(section,  "Survival Instincts",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSurvival Instincts")
        -- Barkskin
        bb.ui:createSpinner(section,  "Barkskin",  40,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin")
        -- Renewal
        bb.ui:createSpinner(section,  "Renewal",  40,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRenewal")
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "-------- Toggles --------")
        bb.ui:checkSectionState(section)
        -- Pause Toggle
        bb.ui:createDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  3)
        

        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "------ Utilities ------")
        -- Follow Tank
        bb.ui:createSpinner(section,  "Follow Tank",  25,  10,  40  ,  1,  "|cffFFBB00Range from focus...")
        -- Zoo Master
        bb.ui:createCheckbox(section,"Zoo Master")
        bb.ui:checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"chumii"})
        bb:checkProfileWindowStatus()

    end
end
