if select(3,UnitClass("player")) == 2 then

    function PaladinHolyOptions()
        local myClassColor = classColors[select(3,UnitClass("player"))].hex

        bb.ui.window.profile = bb.ui:createProfileWindow(myClassColor.."Holy")
        local section

        -- Buffs
        section = bb.ui:createSection(bb.ui.window.profile, "Buffs")
        -- Blessing
        bb.ui:createDropdown(section, "Blessing", {"|cff006AFFKings","|cffFFAE00Might"}, 1, "Select which blessing you want to use.")
        -- Seal
        bb.ui:createCheckbox(section,"Seal Of Insight","Normal")
        bb.ui:checkSectionState(section)


        -- Cooldowns
        section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
        -- Guardian of Ancient Kings
        bb.ui:createSpinner(section, "GotAK Holy", 30, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFGuardian of Ancient Kings")

        -- Avenging Wrath
        bb.ui:createDropdown(section, "Avenging Wrath", bb.dropOptions.CD,  1)

        if isKnown(_HolyAvenger) then
            -- Holy Avenger
            bb.ui:createDropdown(section, "Holy Avenger", bb.dropOptions.CD, 1)

        elseif isKnown(_SanctifiedWrath) then
            -- Sanctified Wrath
            bb.ui:createDropdown(section, "Sanctified Wrath", bb.dropOptions.CD, 1)
        end

        if isKnown(_LightsHammer) then
            -- Light's Hammer
            bb.ui:createDropdown(section, "Light's Hammer", bb.dropOptions.CD, 1)
        end
        bb.ui:checkSectionState(section)


        -- Defensive
        section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
        -- Divine Protection
        bb.ui:createSpinner(section, "Divine Protection Holy", 75, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Protection")
        bb.ui:checkSectionState(section)


        -- Healing
        section = bb.ui:createSection(bb.ui.window.profile, "Healing")
        bb.ui:createSpinner(section, "Critical Health Level", 90, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFfast heals")

        bb.ui:createDropdown(section,  "Beacon Of Light", { "TANK","FOCUS","WISE"},  2,  "Choose mode:\nTank - Always on tank\nFocus - Always on focus.\nWise - Dynamic")


        -- Beacon of Faith
        if isKnown(_BeaconOfFaith) then
            bb.ui:createDropdown(section,  "Beacon Of Faith", { "TANK","FOCUS","WISE"},  2,  "Choose mode:\nTank - Always on tank\nFocus - Always on focus.\nWise - Dynamic")
        end

        -- Holy Light
        bb.ui:createSpinner(section, "Holy Light", 90, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHoly Light")

        -- Flash Of Light
        bb.ui:createSpinner(section, "Flash Of Light", 40, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFFlash Of Light")

        -- Holy Shock
        bb.ui:createSpinner(section, "Holy Shock", 90, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHoly Shock")

        -- Tier 3 talents
        if isKnown(_SacredShield) then
            bb.ui:createSpinner(section, "Sacred Shield", 95, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSacred Shield")
        elseif isKnown(_SelflessHealer) then
            bb.ui:createSpinner(section, "Selfless Healer", 35, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSelfless Healer on Raid")
        else
            bb.ui:createSpinner(section, "Eternal Flame", 70, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame on Raid")
        end
        if isKnown(_SelflessHealer) or isKnown(_SacredShield) then
            bb.ui:createSpinner(section, "Word Of Glory", 70, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFWord Of Glory on Raid")
        end

        -- Tier 6 talents
        if isKnown(_HolyPrism) then
            bb.ui:createSpinner(section,  "Holy Prism",  95,  0,  100  ,  1,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHoly Prism")
            -- Mode, cast always as heal or always as damage or dynamic
            bb.ui:createDropdown(section,  "Holy Prism Mode", { "Friend", "Enemy","WISE"},  2,  "Choose mode:\nFriend - Heal with damage\nEnemy - Damage with heal.\nWise - Dynamic")
        elseif isKnown(_LightsHammer) then
            bb.ui:createSpinner(section,  "Lights Hammer",  35,  0,  100  ,  1,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLights Hammer")
        else
            bb.ui:createSpinner(section,  "Execution Sentence",  70,  0,  100  ,  1,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFExecution Sentence")
        end
        if isKnown(_SelflessHealer) or isKnown(_SacredShield) then
            bb.ui:createSpinner(section,  "Word Of Glory",  70,  0,  100  ,  1,  "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFWord Of Glory on Raid")
        end

        if isKnown(_HandOfPurity) == true then
            bb.ui:createSpinner(section, "Hand of Purity", 50, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand of Purity")
        end

        bb.ui:createSpinner(section, "Lay On Hands", 12, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLay On Hands")

        bb.ui:createDropdown(section, "LoH Targets", { "|cffFF0000Me.Only", "|cffFFDD11Me.Prio", "|cff00FBEETank/Heal","|cff00FF00All"}, 1, "|cffFF0000Which Targets\n|cffFFBB00We want to use \n|cffFFFFFFLay On Hands")

        bb.ui:createSpinner(section, "Hand Of Sacrifice", 35, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand Of Sacrifice")
        bb.ui:checkSectionState(section)


        -- AoE Healing
        section = bb.ui:createSection(bb.ui.window.profile, "AoE Healing")
        bb.ui:createSpinner(section, "HR Missing Health", 75, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHoly Radiance")
        bb.ui:createSpinner(section, "HR Units", 3, 0, 25, 1, "|cffFFBB00Minimum number of |cffFF0000%Units|cffFFBB00 to use \n|cffFFFFFFHoly Radiance")
        bb.ui:checkSectionState(section)
        

        -- Utilities
        section = bb.ui:createSection(bb.ui.window.profile, "Utilities")
        -- Rebuke
        bb.ui:createSpinner(section, "Rebuke", 35, 0, 100, 5, "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFRebuke.")

        -- Nature's Cure
        bb.ui:createDropdown(section, "Dispell", { "|cffFFDD11MMouse", "|cffFFDD11MRaid", "|cff00FF00AMouse", "|cff00FF00ARaid"},  1,  "|cffFFBB00MMouse:|cffFFFFFFMouse / Match List. \n|cffFFBB00MRaid:|cffFFFFFFRaid / Match List. \n|cffFFBB00AMouse:|cffFFFFFFMouse / All. \n|cffFFBB00ARaid:|cffFFFFFFRaid / All.")
        bb.ui:checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"Gabbz & CodeMyLife"})
        bb:checkProfileWindowStatus()
    end
end
