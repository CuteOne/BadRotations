if select(3, UnitClass("player")) == 11 then
    function RestorationConfig()
        bb.ui.window.profile = bb.ui:createProfileWindow("Restoration")
        local section

        imDebugging = false


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "Buffs")
        -- Mark Of The Wild
        bb.ui:createCheckbox(section,"Mark Of The Wild")

        -- Nature's Cure
        bb.ui:createDropdown(section, "Nature's Cure", { "|cffFFDD11MMouse", "|cffFFDD11MRaid", "|cff00FF00AMouse", "|cff00FF00ARaid"},  1,  "|cffFFBB00MMouse:|cffFFFFFFMouse / Match List. \n|cffFFBB00MRaid:|cffFFFFFFRaid / Match List. \n|cffFFBB00AMouse:|cffFFFFFFMouse / All. \n|cffFFBB00ARaid:|cffFFFFFFRaid / All.")
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "Resurrection")
        bb.ui:createCheckbox(section,"MouseOver Rebirth")
        bb.ui:createCheckbox(section,"Revive")
        bb.ui:checkSectionState(section)


        
        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "Level 60 Talent")

        if isKnown(114107) then
            -- Harmoney SotF
            bb.ui:createSpinner(section,  "Harmoney SotF", 40, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 to refresh Harmoney during |cffFFFFFFSotF.")

            -- WildGrowth SotF
            bb.ui:createSpinner(section,  "WildGrowth SotF", 45, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWild Growth with SotF.")

            -- WildGrowth SotF Count
            bb.ui:createSpinner(section,  "WildGrowth SotF Count", 3, 1, 25, 1, "|cffFFBB00Number of members under Wildgrowth SotF treshold to use |cffFFFFFFWild Growth with SotF.")

        elseif isKnown(102693) then
            -- Force of Nature
            bb.ui:createSpinner(section,  "Force of Nature", 45, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFForce of Nature.")

            -- Force of Nature Count
            bb.ui:createSpinner(section,  "Force of Nature Count", 3, 1, 25, 1, "|cffFFBB00Number of members under Force of Nature threshold needed to use |cffFFFFFFForce of Nature.")

        elseif isKnown(33891) then
            -- Germination Tol
            bb.ui:createSpinner(section,  "Germination Tol", 90, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation|cffFFBB00 while in Tree of Life. \n|cffFFDD11Used after Rejuvenation if Rejuvenation All Tol is not selected.")

            -- Germination All Tol
            bb.ui:createCheckbox(section,"Germination All Tol")

            -- Rejuvenation Tol
            bb.ui:createSpinner(section,  "Rejuvenation Tol", 90, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation|cffFFBB00 while in Tree of Life. \n|cffFFDD11Used after Rejuvenation if Rejuvenation All Tol is not selected.")

            -- Rejuvenation All Tol
            bb.ui:createCheckbox(section,"Rejuvenation All Tol")

            -- Regrowth Tol
            bb.ui:createSpinner(section,  "Regrowth Tol", 40, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 while in Tree of Life.")

            -- Regrowth Tank Tol
            bb.ui:createSpinner(section,  "Regrowth Tank Tol", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 on tanks while in Tree of Life .")

            -- Regrowth Omen Tol
            bb.ui:createSpinner(section,  "Regrowth Omen Tol", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 while in Tree of Life and Omen proc.")

            -- WildGrowth Tol
            bb.ui:createSpinner(section,  "WildGrowth Tol", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWildGrowth|cffFFBB00 while in Tree of Life.")

            -- Mushrooms Bloom Count
            bb.ui:createSpinner(section,  "WildGrowth Tol Count", 5, 1, 25, 1, "|cffFFBB00Number of members under WildGrowth Tol threshold needed to use |cffFFFFFFWildGrowth|cffFFBB00 while in Tree of Life.")
        end
        bb.ui:checkSectionState(section)



        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "Healing")
        -- Genesis Tank
        bb.ui:createSpinner(section, "Genesis Tank", 35, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFGenesis on a low health tank.")

        -- Germination
        bb.ui:createSpinner(section,  "Germination", 80, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation.")

        -- Germination Tank
        bb.ui:createSpinner(section,  "Germination Tank", 65, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation |cffFFBB00on Tanks.")

        -- Germination All
        bb.ui:createCheckbox(section,"Germination All","Check to force rejuv |cffFFBB00on all targets(low prio).")

        -- Healing Touch Harmoney
        bb.ui:createCheckbox(section,"HT Harmoney")

        -- Healing Touch
        bb.ui:createSpinner(section,  "Healing Touch", 65, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch.")

        -- Healing Touch Tank
        bb.ui:createSpinner(section,  "Healing Touch Tank", 55, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 on Tanks.")

        -- Healing Touch Ns
        bb.ui:createSpinner(section,  "Healing Touch Ns", 25, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 with |cffFFFFFFNature Swiftness.")

        -- Healing Touch Sm
        bb.ui:createSpinner(section,  "Healing Touch Sm", 70,  0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 for |cffFFFFFF Sage Mender.")

        -- Lifebloom
        bb.ui:createSpinner(section,  "Lifebloom", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to |cffFFFFFFlet Lifebloom Bloom |cffFFBB00on Focus.")

        -- Regrowth
        bb.ui:createSpinner(section,  "Regrowth", 65, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth.")

        -- Regrowth Tank
        bb.ui:createSpinner(section,  "Regrowth Tank", 55, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 on Tanks.")

        -- Regrowth Omen
        bb.ui:createSpinner(section,  "Regrowth Omen", 80, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 with Omen of Clarity.")

        -- Rejuvenation
        bb.ui:createSpinner(section,  "Rejuvenation", 80,  0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation.")

        -- Rejuvenation Tank
        bb.ui:createSpinner(section,  "Rejuvenation Tank", 65, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation |cffFFBB00on Tanks.")

        -- Rejuvenation Meta
        bb.ui:createCheckbox(section,"Rejuvenation Meta","Check to force rejuv |cffFFBB00on all targets(meta proc).")

        -- Rejuvenation All
        bb.ui:createCheckbox(section,"Rejuvenation All","Check to force rejuv |cffFFBB00on all targets(low prio).")

        -- Rejuvenation Filler
        bb.ui:createSpinner(section,  "Rejuv Filler Count", 5, 1, 25, 1, "|cffFFBB00Number of members to keep |cffFFFFFFRejuvenation |cffFFBB00as Filler.")

        -- Rejuvenation Debuff
        bb.ui:createSpinner(section,  "Rejuvenation Debuff", 65, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation |cffFFBB00on Debuffed units.")

        -- if isKnown(114107) ~= true then
        -- Swiftmend
        bb.ui:createSpinner(section,  "Swiftmend", 35, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSwiftmend.")
        -- Harmoney
        bb.ui:createSpinner(section,  "Swiftmend Harmoney", 40, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSwiftmend|cffFFBB00 to refresh Harmoney.")
        -- end
        bb.ui:checkSectionState(section)



        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "AoE Healing")
        -- Genesis
        bb.ui:createSpinner(section, "Genesis", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFGenesis.")

        -- Genesis Count
        bb.ui:createSpinner(section,  "Genesis Count", 5, 1, 25, 1, "|cffFFBB00Number of members under Genesis threshold needed to use |cffFFFFFFGenesis.")

        -- Genesis Filler
        bb.ui:createSpinner(section,  "Genesis Filler", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFGenesis |cffFFBB00as Filler(low prio).")

        -- Mushrooms
        bb.ui:createSpinner(section, "Mushrooms", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWild Mushrooms.")

        -- Mushrooms on Who
        bb.ui:createDropdown(section, "Mushrooms Who", {"|cffFFDD11Tank", "|cffFFDD113 Units"}, 1, "|cffFFBB00Tank:|cffFFFFFFAlways on the tank. \n|cffFFBB003 Units:|cffFFFFFFWill always try to cast on 3 of lowest units.|cffFF1100Note: If Tank selected and no Focus defined, will use on 3 targets.")

        -- WildGrowth
        bb.ui:createSpinner(section,  "WildGrowth", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWildGrowth.")

        -- WildGrowth Count
        bb.ui:createSpinner(section,  "WildGrowth Count", 5, 1, 25, 1, "|cffFFBB00Number of members under WildGrowth threshold needed to use |cffFFFFFFWildGrowth.")

        -- WildGrowth All
        bb.ui:createSpinner(section,  "WildGrowth All", 85, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWildGrowth.")

        -- WildGrowth All Count
        bb.ui:createSpinner(section,  "WildGrowth All Count", 5, 1, 25, 1, "|cffFFBB00Number of members under WildGrowth threshold needed to use |cffFFFFFFWildGrowth.")

        bb.ui:checkSectionState(section)



        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
        -- Barkskin
        bb.ui:createSpinner(section,  "Barkskin", 40, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin")

        -- Healthstone
        bb.ui:createSpinner(section,  "Healthstone", 25, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        bb.ui:checkSectionState(section)




        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "-------- Toggles --------")
        -- DPS Toggle
        bb.ui:createDropdown(section, "DPS Toggle", bb.dropOptions.Toggle2, 1)

        -- Focus Toggle
        bb.ui:createDropdown(section, "Focus Toggle", bb.dropOptions.Toggle2, 2)

        -- Genesis Toggle
        bb.ui:createDropdown(section, "Genesis Toggle", bb.dropOptions.Toggle2, 4)

        -- Pause Toggle
        bb.ui:createDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2, 3)

        -- Rebirth
        bb.ui:createDropdown(section, "Rebirth Toggle", bb.dropOptions.Toggle2, 9)

        -- Regrowth Toggle
        bb.ui:createDropdown(section, "Regrowth Toggle", bb.dropOptions.Toggle2, 5)

        -- Reju  Toggle
        bb.ui:createDropdown(section, "Reju Toggle", bb.dropOptions.Toggle2, 7)

        -- Reju  Toggle Mode
        bb.ui:createDropdown(section, "Reju Toggle Mode", { "|cffFFBB00Toggle", "|cffFF0000Hold"}, 1, "|cffFFBB00Toggle: |cffFFFFFFTap button to toggle ON/OFF. \n|cffFF0000Hold: |cffFFFFFFHold button to stay ON.")

        -- WildGroth Toggle
        bb.ui:createDropdown(section, "WG Toggle", bb.dropOptions.Toggle2, 6)

        -- Wild mushroom Toggle
        bb.ui:createDropdown(section, "WildMushroom", bb.dropOptions.Toggle2, 8)
        bb.ui:checkSectionState(section)


        -- Wrapper -----------------------------------------
        section = bb.ui:createSection(bb.ui.window.profile, "------ Utilities ------")
        -- No Kitty DPS
        bb.ui:createCheckbox(section,"No Kitty DPS","|cffFF0011Check |cffFFDD11this to prevent |cffFFFFFFKitty |cffFFDD11DPS",0)

        -- Multidotting
        bb.ui:createCheckbox(section,"Multidotting","|cffFF0011Check |cffFFDD11this to allow |cffFFFFFFMoonfire |cffFFDD11Multidotting",0)

        -- MoonFire
        bb.ui:createCheckbox(section,"MoonFire","|cffFF0011Check |cffFFDD11this to allow |cffFFFFFFMoonfire",0)

        -- Safe DPS Threshold
        bb.ui:createSpinner(section,  "Safe DPS Threshold", 45, 1, 100, 5,"|cffFF0011Check |cffFFFFFF to force healing when units in your group fall under threshold.", "|cffFFBB00What threshold you want to force start healing allies while DPSing.")

        --[[ Follow Tank
              bb.ui:createCheckbox(section,"Follow Tank")
              bb.ui:createSpinner(section,  "Follow Tank", 25, 10, 40, 1, "|cffFFBB00Range from focus...")
          ]]

        if imDebugging == true then
            bb.ui:createCheckbox(section,"Debugging Mode")
        end
        bb.ui:checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"Masou"})
        bb:checkProfileWindowStatus()
    end
end
