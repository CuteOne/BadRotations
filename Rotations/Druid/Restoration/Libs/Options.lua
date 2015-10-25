if select(3, UnitClass("player")) == 11 then
    function RestorationConfig()
        bb.profile_window = createNewProfileWindow("Restoration")
        local section

        imDebugging = false


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "Buffs")
        -- Mark Of The Wild
        createNewCheckbox(section,"Mark Of The Wild")

        -- Nature's Cure
        createNewDropdown(section, "Nature's Cure", { "|cffFFDD11MMouse", "|cffFFDD11MRaid", "|cff00FF00AMouse", "|cff00FF00ARaid"},  1,  "|cffFFBB00MMouse:|cffFFFFFFMouse / Match List. \n|cffFFBB00MRaid:|cffFFFFFFRaid / Match List. \n|cffFFBB00AMouse:|cffFFFFFFMouse / All. \n|cffFFBB00ARaid:|cffFFFFFFRaid / All.")
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "Resurrection")
        createNewCheckbox(section,"MouseOver Rebirth")
        createNewCheckbox(section,"Revive")
        checkSectionState(section)


        
        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "Level 60 Talent")

        if isKnown(114107) then
            -- Harmoney SotF
            createNewSpinner(section,  "Harmoney SotF", 40, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 to refresh Harmoney during |cffFFFFFFSotF.")

            -- WildGrowth SotF
            createNewSpinner(section,  "WildGrowth SotF", 45, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWild Growth with SotF.")

            -- WildGrowth SotF Count
            createNewSpinner(section,  "WildGrowth SotF Count", 3, 1, 25, 1, "|cffFFBB00Number of members under Wildgrowth SotF treshold to use |cffFFFFFFWild Growth with SotF.")

        elseif isKnown(102693) then
            -- Force of Nature
            createNewSpinner(section,  "Force of Nature", 45, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFForce of Nature.")

            -- Force of Nature Count
            createNewSpinner(section,  "Force of Nature Count", 3, 1, 25, 1, "|cffFFBB00Number of members under Force of Nature threshold needed to use |cffFFFFFFForce of Nature.")

        elseif isKnown(33891) then
            -- Germination Tol
            createNewSpinner(section,  "Germination Tol", 90, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation|cffFFBB00 while in Tree of Life. \n|cffFFDD11Used after Rejuvenation if Rejuvenation All Tol is not selected.")

            -- Germination All Tol
            createNewCheckbox(section,"Germination All Tol")

            -- Rejuvenation Tol
            createNewSpinner(section,  "Rejuvenation Tol", 90, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation|cffFFBB00 while in Tree of Life. \n|cffFFDD11Used after Rejuvenation if Rejuvenation All Tol is not selected.")

            -- Rejuvenation All Tol
            createNewCheckbox(section,"Rejuvenation All Tol")

            -- Regrowth Tol
            createNewSpinner(section,  "Regrowth Tol", 40, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 while in Tree of Life.")

            -- Regrowth Tank Tol
            createNewSpinner(section,  "Regrowth Tank Tol", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 on tanks while in Tree of Life .")

            -- Regrowth Omen Tol
            createNewSpinner(section,  "Regrowth Omen Tol", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 while in Tree of Life and Omen proc.")

            -- WildGrowth Tol
            createNewSpinner(section,  "WildGrowth Tol", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWildGrowth|cffFFBB00 while in Tree of Life.")

            -- Mushrooms Bloom Count
            createNewSpinner(section,  "WildGrowth Tol Count", 5, 1, 25, 1, "|cffFFBB00Number of members under WildGrowth Tol threshold needed to use |cffFFFFFFWildGrowth|cffFFBB00 while in Tree of Life.")
        end
        checkSectionState(section)



        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "Healing")
        -- Genesis Tank
        createNewSpinner(section, "Genesis Tank", 35, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFGenesis on a low health tank.")

        -- Germination
        createNewSpinner(section,  "Germination", 80, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation.")

        -- Germination Tank
        createNewSpinner(section,  "Germination Tank", 65, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation |cffFFBB00on Tanks.")

        -- Germination All
        createNewCheckbox(section,"Germination All","Check to force rejuv |cffFFBB00on all targets(low prio).")

        -- Healing Touch Harmoney
        createNewCheckbox(section,"HT Harmoney")

        -- Healing Touch
        createNewSpinner(section,  "Healing Touch", 65, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch.")

        -- Healing Touch Tank
        createNewSpinner(section,  "Healing Touch Tank", 55, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 on Tanks.")

        -- Healing Touch Ns
        createNewSpinner(section,  "Healing Touch Ns", 25, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 with |cffFFFFFFNature Swiftness.")

        -- Healing Touch Sm
        createNewSpinner(section,  "Healing Touch Sm", 70,  0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 for |cffFFFFFF Sage Mender.")

        -- Lifebloom
        createNewSpinner(section,  "Lifebloom", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to |cffFFFFFFlet Lifebloom Bloom |cffFFBB00on Focus.")

        -- Regrowth
        createNewSpinner(section,  "Regrowth", 65, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth.")

        -- Regrowth Tank
        createNewSpinner(section,  "Regrowth Tank", 55, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 on Tanks.")

        -- Regrowth Omen
        createNewSpinner(section,  "Regrowth Omen", 80, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 with Omen of Clarity.")

        -- Rejuvenation
        createNewSpinner(section,  "Rejuvenation", 80,  0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation.")

        -- Rejuvenation Tank
        createNewSpinner(section,  "Rejuvenation Tank", 65, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation |cffFFBB00on Tanks.")

        -- Rejuvenation Meta
        createNewCheckbox(section,"Rejuvenation Meta","Check to force rejuv |cffFFBB00on all targets(meta proc).")

        -- Rejuvenation All
        createNewCheckbox(section,"Rejuvenation All","Check to force rejuv |cffFFBB00on all targets(low prio).")

        -- Rejuvenation Filler
        createNewSpinner(section,  "Rejuv Filler Count", 5, 1, 25, 1, "|cffFFBB00Number of members to keep |cffFFFFFFRejuvenation |cffFFBB00as Filler.")

        -- Rejuvenation Debuff
        createNewSpinner(section,  "Rejuvenation Debuff", 65, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation |cffFFBB00on Debuffed units.")

        -- if isKnown(114107) ~= true then
        -- Swiftmend
        createNewSpinner(section,  "Swiftmend", 35, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSwiftmend.")
        -- Harmoney
        createNewSpinner(section,  "Swiftmend Harmoney", 40, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSwiftmend|cffFFBB00 to refresh Harmoney.")
        -- end
        checkSectionState(section)



        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "AoE Healing")
        -- Genesis
        createNewSpinner(section, "Genesis", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFGenesis.")

        -- Genesis Count
        createNewSpinner(section,  "Genesis Count", 5, 1, 25, 1, "|cffFFBB00Number of members under Genesis threshold needed to use |cffFFFFFFGenesis.")

        -- Genesis Filler
        createNewSpinner(section,  "Genesis Filler", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFGenesis |cffFFBB00as Filler(low prio).")

        -- Mushrooms
        createNewSpinner(section, "Mushrooms", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWild Mushrooms.")

        -- Mushrooms on Who
        createNewDropdown(section, "Mushrooms Who", {"|cffFFDD11Tank", "|cffFFDD113 Units"}, 1, "|cffFFBB00Tank:|cffFFFFFFAlways on the tank. \n|cffFFBB003 Units:|cffFFFFFFWill always try to cast on 3 of lowest units.|cffFF1100Note: If Tank selected and no Focus defined, will use on 3 targets.")

        -- WildGrowth
        createNewSpinner(section,  "WildGrowth", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWildGrowth.")

        -- WildGrowth Count
        createNewSpinner(section,  "WildGrowth Count", 5, 1, 25, 1, "|cffFFBB00Number of members under WildGrowth threshold needed to use |cffFFFFFFWildGrowth.")

        -- WildGrowth All
        createNewSpinner(section,  "WildGrowth All", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWildGrowth.")

        -- WildGrowth All Count
        createNewSpinner(section,  "WildGrowth All Count", 5, 1, 25, 1, "|cffFFBB00Number of members under WildGrowth threshold needed to use |cffFFFFFFWildGrowth.")

        checkSectionState(section)



        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "Defensive")
        -- Barkskin
        createNewSpinner(section,  "Barkskin", 40, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin")

        -- Healthstone
        createNewSpinner(section,  "Healthstone", 25, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        checkSectionState(section)




        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "-------- Toggles --------")
        -- DPS Toggle
        createNewDropdown(section, "DPS Toggle", bb.dropOptions.Toggle2, 1)

        -- Focus Toggle
        createNewDropdown(section, "Focus Toggle", bb.dropOptions.Toggle2, 2)

        -- Genesis Toggle
        createNewDropdown(section, "Genesis Toggle", bb.dropOptions.Toggle2, 4)

        -- Pause Toggle
        createNewDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2, 3)

        -- Rebirth
        createNewDropdown(section, "Rebirth Toggle", bb.dropOptions.Toggle2, 9)

        -- Regrowth Toggle
        createNewDropdown(section, "Regrowth Toggle", bb.dropOptions.Toggle2, 5)

        -- Reju  Toggle
        createNewDropdown(section, "Reju Toggle", bb.dropOptions.Toggle2, 7)

        -- Reju  Toggle Mode
        createNewDropdown(section, "Reju Toggle Mode", { "|cffFFBB00Toggle", "|cffFF0000Hold"}, 1, "|cffFFBB00Toggle: |cffFFFFFFTap button to toggle ON/OFF. \n|cffFF0000Hold: |cffFFFFFFHold button to stay ON.")

        -- WildGroth Toggle
        createNewDropdown(section, "WG Toggle", bb.dropOptions.Toggle2, 6)

        -- Wild mushroom Toggle
        createNewDropdown(section, "WildMushroom", bb.dropOptions.Toggle2, 8)
        checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = createNewSection(bb.profile_window, "------ Utilities ------")
        -- No Kitty DPS
        createNewCheckbox(section,"No Kitty DPS","|cffFF0011Check |cffFFDD11this to prevent |cffFFFFFFKitty |cffFFDD11DPS",0)

        -- Multidotting
        createNewCheckbox(section,"Multidotting","|cffFF0011Check |cffFFDD11this to allow |cffFFFFFFMoonfire |cffFFDD11Multidotting",0)

        -- MoonFire
        createNewCheckbox(section,"MoonFire","|cffFF0011Check |cffFFDD11this to allow |cffFFFFFFMoonfire",0)

        -- Safe DPS Threshold
        createNewSpinner(section,  "Safe DPS Threshold", 45, 1, 100, 5,"|cffFF0011Check |cffFFFFFF to force healing when units in your group fall under threshold.", "|cffFFBB00What threshold you want to force start healing allies while DPSing.")

        --[[ Follow Tank
              createNewCheckbox(section,"Follow Tank")
              createNewSpinner(section,  "Follow Tank", 25, 10, 40, 1, "|cffFFBB00Range from focus...")
          ]]

        if imDebugging == true then
            createNewCheckbox(section,"Debugging Mode")
        end
        checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"Masou"})
        bb:checkProfileWindowStatus()
    end
end
