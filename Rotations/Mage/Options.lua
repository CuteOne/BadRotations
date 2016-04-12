if select(3, UnitClass("player")) == 8 then

    function FrostMageConfig()
        bb.ui.window.profile = bb.ui:createProfileWindow("Frost")
        local section

        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile,"--- Buffs ---")
        --[[Arcane Brilliance]]
        bb.ui:createCheckbox(section,"Arcane Brilliance");
        bb.ui:checkSectionState(section) ;

        
        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile,"--- Cooldowns ---")
        bb.ui:createCheckbox(section,"Mirror Image");
        bb.ui:createCheckbox(section,"Icy Veins");
        bb.ui:createCheckbox(section,"Racial");
        bb.ui:checkSectionState(section) ;


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile,"--- Defensives ---")
        bb.ui:checkSectionState(section) ;


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile,"--- Toggles")
        --[[Pause Toggle]]
        bb.ui:createDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  3)
        -- [[Focus Toggle]]
        -- bb.ui:createDropdown(section, "Focus Toggle", bb.dropOptions.Toggle2,  2)
        bb.ui:checkSectionState(section) ;


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile,"--- Rotation ---")
        -- Rotation
        bb.ui:createDropdown(section,  "RotationSelect", { "|cffFFBB00IcyVeins", "|cff0077FFSimCraft"},  1,  "Choose Rotation to use.") ;
        bb.ui:checkSectionState(section) ;



        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"ragnar"})
        bb:checkProfileWindowStatus()
    end

    function ArcaneMageConfig()
        bb.ui.window.profile = bb.ui:createProfileWindow("Arcane")
        local section

        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile,"--- Buffs ---")
        --[[Arcane Brilliance]]
        bb.ui:createCheckbox(section,"Arcane Brilliance")
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile,"--- Cooldowns ---")
        bb.ui:createCheckbox(section,"Mirror Image")
        bb.ui:createCheckbox(section,"Arcane Power")
        bb.ui:createCheckbox(section,"Racial")
        bb.ui:createCheckbox(section,"Cold Snap")
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile,"--- Defensives ---")
        bb.ui:createSpinner(section, "Evanesce",  30,  0,  100  ,  5,  "|cffFFBB00Under what |cff69ccf0%HP|cffFFBB00 cast |cff69ccf0Evanesce.")
        -- Healthstone
        bb.ui:createSpinner(section, "Healthstone",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile,"--- Rotation ---")
        bb.ui:createSpinner(section, "ArcaneBlast (x4)",  93,  80,  100  ,  1,  "|cffFFBB00Under what |cff69ccf0%Mana|cffFFBB00 dont cast |cff69ccf0Arcane Blast at 4 stacks.")
        bb.ui:createCheckbox(section,"Burn Phase", "Do not enable on Dummy.")
        bb.ui:checkSectionState(section)


        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"ragnar & Gabbz"})
        bb:checkProfileWindowStatus()
    end

    function FireMageConfig()
        bb.ui.window.profile = bb.ui:createProfileWindow("Fire")
        local section

        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile,"--- Buffs ---")
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile,"--- Cooldowns ---")
        bb.ui:createCheckbox(section,"Mirror Image")
        bb.ui:createCheckbox(section,"Cold Snap")
        bb.ui:createCheckbox(section,"Racial")
        bb.ui:createCheckbox(section,"Potions")
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile,"--- Defensives ---")
        bb.ui:createSpinner(section, "Evanesce",  30,  0,  100  ,  5,  "|cffFFBB00Under what |cff69ccf0%HP|cffFFBB00 cast |cff69ccf0Evanesce.")
        -- Healthstone
        bb.ui:createSpinner(section, "Healthstone",  25,  0,  100  ,  5,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile,"--- Rotation ---")
        bb.ui:createCheckbox(section,"Gabbz")
        bb.ui:createCheckbox(section,"Burst")
        bb.ui:checkSectionState(section)


        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"Gabbz"})
        bb:checkProfileWindowStatus()
    end
end
