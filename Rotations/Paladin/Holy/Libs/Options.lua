if select(3,UnitClass("player")) == 2 then

    function PaladinHolyOptions()
        local myClassColor = classColors[select(3,UnitClass("player"))].hex

        bb.profile_window = createNewProfileWindow(myClassColor.."Holy")
        local section

        -- Buffs
        section = createNewSection(bb.profile_window, "Buffs")
        -- Blessing
        createNewDropdown(section, "Blessing", {"|cff006AFFKings","|cffFFAE00Might"}, 1, "Select which blessing you want to use.")
        -- Seal
        createNewCheckbox(section,"Seal Of Insight","Normal")
        checkSectionState(section)


        -- Cooldowns
        section = createNewSection(bb.profile_window, "Cooldowns")
        -- Guardian of Ancient Kings
        createNewSpinner(section, "GotAK Holy", 30, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFGuardian of Ancient Kings")

        -- Avenging Wrath
        createNewDropdown(section, "Avenging Wrath", bb.dropOptions.CD,  1)

        if isKnown(_HolyAvenger) then
            -- Holy Avenger
            createNewDropdown(section, "Holy Avenger", bb.dropOptions.CD, 1)

        elseif isKnown(_SanctifiedWrath) then
            -- Sanctified Wrath
            createNewDropdown(section, "Sanctified Wrath", bb.dropOptions.CD, 1)
        end

        if isKnown(_LightsHammer) then
            -- Light's Hammer
            createNewDropdown(section, "Light's Hammer", bb.dropOptions.CD, 1)
        end
        checkSectionState(section)


        -- Defensive
        section = createNewSection(bb.profile_window, "Defensive")
        -- Divine Protection
        createNewSpinner(section, "Divine Protection Holy", 75, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Protection")
        checkSectionState(section)


        -- Healing
        section = createNewSection(bb.profile_window, "Healing")
        createNewSpinner(section, "Critical Health Level", 90, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFfast heals")

        createNewDropdown(section,  "Beacon Of Light", { "TANK","FOCUS","WISE"},  2,  "Choose mode:\nTank - Always on tank\nFocus - Always on focus.\nWise - Dynamic")


        -- Beacon of Faith
        if isKnown(_BeaconOfFaith) then
            createNewDropdown(section,  "Beacon Of Faith", { "TANK","FOCUS","WISE"},  2,  "Choose mode:\nTank - Always on tank\nFocus - Always on focus.\nWise - Dynamic")
        end

        -- Holy Light
        createNewSpinner(section, "Holy Light", 90, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHoly Light")

        -- Flash Of Light
        createNewSpinner(section, "Flash Of Light", 40, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFFlash Of Light")

        -- Holy Shock
        createNewSpinner(section, "Holy Shock", 90, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHoly Shock")

        -- Tier 3 talents
        if isKnown(_SacredShield) then
            createNewSpinner(section, "Sacred Shield", 95, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSacred Shield")
        elseif isKnown(_SelflessHealer) then
            createNewSpinner(section, "Selfless Healer", 35, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSelfless Healer on Raid")
        else
            createNewSpinner(section, "Eternal Flame", 70, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame on Raid")
        end
        if isKnown(_SelflessHealer) or isKnown(_SacredShield) then
            createNewSpinner(section, "Word Of Glory", 70, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFWord Of Glory on Raid")
        end

        -- Tier 6 talents
        if isKnown(_HolyPrism) then
            createNewSpinner(section,  "Holy Prism",  95,  0,  100  ,  1,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHoly Prism")
            -- Mode, cast always as heal or always as damage or dynamic
            createNewDropdown(section,  "Holy Prism Mode", { "Friend", "Enemy","WISE"},  2,  "Choose mode:\nFriend - Heal with damage\nEnemy - Damage with heal.\nWise - Dynamic")
        elseif isKnown(_LightsHammer) then
            createNewSpinner(section,  "Lights Hammer",  35,  0,  100  ,  1,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLights Hammer")
        else
            createNewSpinner(section,  "Execution Sentence",  70,  0,  100  ,  1,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFExecution Sentence")
        end
        if isKnown(_SelflessHealer) or isKnown(_SacredShield) then
            createNewSpinner(section,  "Word Of Glory",  70,  0,  100  ,  1,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFWord Of Glory on Raid")
        end

        if isKnown(_HandOfPurity) == true then
            createNewSpinner(section, "Hand of Purity", 50, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand of Purity")
        end

        createNewSpinner(section, "Lay On Hands", 12, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLay On Hands")

        createNewDropdown(section, "LoH Targets", { "|cffFF0000Me.Only", "|cffFFDD11Me.Prio", "|cff00FBEETank/Heal","|cff00FF00All"}, 1, "|cffFF0000Which Targets\n|cffFFBB00We want to use \n|cffFFFFFFLay On Hands")

        createNewSpinner(section, "Hand Of Sacrifice", 35, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand Of Sacrifice")
        checkSectionState(section)


        -- AoE Healing
        section = createNewSection(bb.profile_window, "AoE Healing")
        createNewSpinner(section, "HR Missing Health", 75, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHoly Radiance")
        createNewSpinner(section, "HR Units", 3, 0, 25, 1, "|cffFFBB00Minimum number of |cffFF0000%Units|cffFFBB00 to use \n|cffFFFFFFHoly Radiance")
        checkSectionState(section)
        

        -- Utilities
        section = createNewSection(bb.profile_window, "Utilities")
        -- Rebuke
        createNewSpinner(section, "Rebuke", 35, 0, 100, 5, "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFRebuke.")

        -- Nature's Cure
        createNewDropdown(section, "Dispell", { "|cffFFDD11MMouse", "|cffFFDD11MRaid", "|cff00FF00AMouse", "|cff00FF00ARaid"},  1,  "|cffFFBB00MMouse:|cffFFFFFFMouse / Match List. \n|cffFFBB00MRaid:|cffFFFFFFRaid / Match List. \n|cffFFBB00AMouse:|cffFFFFFFMouse / All. \n|cffFFBB00ARaid:|cffFFFFFFRaid / All.")
        checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"Gabbz & CodeMyLife"})
        bb:checkProfileWindowStatus()
    end
end
