if select(3, UnitClass("player")) == 11 then
    function GuardianConfig()
        bb.profile_window = createNewProfileWindow("Guardian")
        local section

        section = createNewSection(bb.profile_window, "---------- Buffs ---------")
        -- Mark Of The Wild
        createNewCheckbox(section,"Mark Of The Wild")
        -- Auto Shift
        createNewCheckbox(section,"Auto Shapeshifts", "Auto Shapeshifts")
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "--------- Healing -------")
        -- DoC Healing Touch
        createNewDropdown(section,  "DoCHT", { "|cffFFBB00Player", "|cff0077FFLowest"},  2,  "Use DoC Procs Healing Touch on...")
        -- Cenarion Ward
        createNewDropdown(section,  "CenWard", { "|cffFFBB00Player", "|cff0077FFLowest"},  2,  "Use Cenarion Ward on...")
        checkSectionState(section)

        
        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "------- Cooldowns -----")
        createNewCheckbox(section,"useBerserk", "Check to use Berserk on CD (Boss/Dummy)")
        createNewSpinner(section, "useHotW",  65,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHotW and start keeping Rejuvenation up")
        createNewCheckbox(section,"useNVigil")
        createNewCheckbox(section,"useIncarnation")
        checkSectionState(section)

        
        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "------- Defensive ------")        -- Healthstone
        createNewSpinner(section,  "Healthstone",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        -- Survival Instincts
        createNewSpinner(section,  "Survival Instincts",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSurvival Instincts")
        -- Barkskin
        createNewSpinner(section,  "Barkskin",  40,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin")
        -- Renewal
        createNewSpinner(section,  "Renewal",  40,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRenewal")
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "-------- Toggles --------")
        checkSectionState(section)
        -- Pause Toggle
        createNewDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  3)
        

        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "------ Utilities ------")
        -- Follow Tank
        createNewSpinner(section,  "Follow Tank",  25,  10,  40  ,  1,  "|cffFFBB00Range from focus...")
        -- Zoo Master
        createNewCheckbox(section,"Zoo Master")
        checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"chumii"})
        bb:checkProfileWindowStatus()

    end
end
