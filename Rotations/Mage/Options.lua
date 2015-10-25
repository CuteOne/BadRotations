if select(3, UnitClass("player")) == 8 then

    function FrostMageConfig()
        bb.profile_window = createNewProfileWindow("Frost")
        local section

        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window,"--- Buffs ---")
        --[[Arcane Brilliance]]
        createNewCheckbox(section,"Arcane Brilliance");
        checkSectionState(section) ;

        
        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window,"--- Cooldowns ---")
        createNewCheckbox(section,"Mirror Image");
        createNewCheckbox(section,"Icy Veins");
        createNewCheckbox(section,"Racial");
        checkSectionState(section) ;


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window,"--- Defensives ---")
        checkSectionState(section) ;


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window,"--- Toggles")
        --[[Pause Toggle]]
        createNewDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  3)
        -- [[Focus Toggle]]
        -- createNewDropdown(section, "Focus Toggle", bb.dropOptions.Toggle2,  2)
        checkSectionState(section) ;


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window,"--- Rotation ---")
        -- Rotation
        createNewDropdown(section,  "RotationSelect", { "|cffFFBB00IcyVeins", "|cff0077FFSimCraft"},  1,  "Choose Rotation to use.") ;
        checkSectionState(section) ;



        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"ragnar"})
        bb:checkProfileWindowStatus()
    end

    function ArcaneMageConfig()
        bb.profile_window = createNewProfileWindow("Arcane")
        local section

        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window,"--- Buffs ---")
        --[[Arcane Brilliance]]
        createNewCheckbox(section,"Arcane Brilliance")
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window,"--- Cooldowns ---")
        createNewCheckbox(section,"Mirror Image")
        createNewCheckbox(section,"Arcane Power")
        createNewCheckbox(section,"Racial")
        createNewCheckbox(section,"Cold Snap")
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window,"--- Defensives ---")
        createNewSpinner(section, "Evanesce",  30,  0,  100  ,  5,  "|cffFFBB00Under what |cff69ccf0%HP|cffFFBB00 cast |cff69ccf0Evanesce.")
        -- Healthstone
        createNewSpinner(section, "Healthstone",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window,"--- Rotation ---")
        createNewSpinner(section, "ArcaneBlast (x4)",  93,  80,  100  ,  1,  "|cffFFBB00Under what |cff69ccf0%Mana|cffFFBB00 dont cast |cff69ccf0Arcane Blast at 4 stacks.")
        createNewCheckbox(section,"Burn Phase", "Do not enable on Dummy.")
        checkSectionState(section)


        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"ragnar & Gabbz"})
        bb:checkProfileWindowStatus()
    end

    function FireMageConfig()
        bb.profile_window = createNewProfileWindow("Fire")
        local section

        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window,"--- Buffs ---")
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window,"--- Cooldowns ---")
        createNewCheckbox(section,"Mirror Image")
        createNewCheckbox(section,"Cold Snap")
        createNewCheckbox(section,"Racial")
        createNewCheckbox(section,"Potions")
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window,"--- Defensives ---")
        createNewSpinner(section, "Evanesce",  30,  0,  100  ,  5,  "|cffFFBB00Under what |cff69ccf0%HP|cffFFBB00 cast |cff69ccf0Evanesce.")
        -- Healthstone
        createNewSpinner(section, "Healthstone",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window,"--- Rotation ---")
        createNewCheckbox(section,"Gabbz")
        createNewCheckbox(section,"Burst")
        checkSectionState(section)


        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"Gabbz"})
        bb:checkProfileWindowStatus()
    end
end
