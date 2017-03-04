-- This creates the normal BadBay Configuration Window
br.ui.window.config = {}
function br.ui:createConfigWindow()
    br.ui.window.config = br.ui:createWindow("config", 275, 400,"Configuration")

    local section

    local function callGeneral()
        -- General
        section = br.ui:createSection(br.ui.window.config, "General")
        br.ui:createSpinnerWithout(section, "Update Rate", 0.1, 0.0, 1.0, 0.01, "Adjust the update rate of FPS Intensive operations. Increase to improve FPS but may cause reaction delays. Default: 0.1")
        -- As you should use the toggle to stop, i (defmaster) just activated this toggle default and made it non interactive
        local startStop = br.ui:createCheckbox(section, "Start/Stop BadRotations", "Toggle this option from the Toggle Bar (Shift Left Click on the Minimap Icon.");
        startStop:SetChecked(true); br.data.settings[br.selectedSpec][br.selectedProfile]["Start/Stop BadRotationsCheck"] = true; startStop.frame:Disable()
        -- br.ui:createCheckbox(section, "Start/Stop BadRotations", "Uncheck to prevent BadRotations pulsing.");
        rotationLog = br.ui:createCheckbox(section, "Rotation Log", "Display Rotation Log.");
        -- br.ui:createCheckbox(section, "Rotation Log", "Display Rotation Log.")
        br.ui:createCheckbox(section, "Display Failcasts", "Dispaly Failcasts in Debug.")
        br.ui:createCheckbox(section, "Queue Casting", "Allow Queue Casting on some profiles.")
        br.ui:createSpinner(section,  "Auto Loot" ,0.5, 0.1, 3, 0.1, "Sets Autloot on/off.", "Sets a delay for Auto Loot.")
        br.ui:createCheckbox(section, "Auto-Sell/Repair", "Automatically sells grays and repairs when you open a repair vendor.")
        br.ui:createCheckbox(section, "Accept Queues", "Automatically accept LFD, LFR, .. queue.")
        br.ui:createCheckbox(section, "Overlay Messages", "Check to enable chat overlay messages.")
        br.ui:createSpinner(section,  "Notify Not Unlocked", 10, 5, 60, 5, "Will alert you at the set interval when FireHack or EWT is not attached.")
        br.ui:createCheckbox(section, "Reset Options", "|cffFF0000 WARNING!|cffFFFFFF Checking this will reset setting on reload!")
        br.ui:checkSectionState(section)
    end

    local function callEnemiesEngine()
        -- Enemies Engine
        section = br.ui:createSection(br.ui.window.config, "Enemies Engine")
        br.ui:createCheckbox(section, "Dynamic Targetting", "Check this to allow dynamic targetting. If unchecked, profile will only attack current target.")
        br.ui:createDropdown(section, "Wise Target", {"Highest", "Lowest", "abs Highest"}, 1, "|cffFFDD11Check if you want to use Wise Targetting, if unchecked there will be no priorisation from hp.")
        br.ui:createCheckbox(section, "Forced Burn", "Check to allow forced Burn on specific whitelisted units.")
        br.ui:createCheckbox(section, "Avoid Shields", "Check to avoid attacking shielded units.")
        br.ui:createCheckbox(section, "Tank Threat", "Check add more priority to taregts you lost aggro on(tank only).")
        br.ui:createCheckbox(section, "Safe Damage Check", "Check to prevent damage to targets you dont want to attack.")
        br.ui:createCheckbox(section, "Don't break CCs", "Check to prevent damage to targets that are CC.")
        br.ui:createCheckbox(section, "Skull First", "Check to enable focus skull dynamically.")
        br.ui:createDropdown(section, "Interrupts Handler", {"Target", "T/M", "T/M/F", "All"}, 1, "Check this to allow Interrupts Handler. DO NOT USE YET!")
        br.ui:createCheckbox(section, "Only Known Units", "Check this to interrupt only on known units using whitelist.")
        br.ui:createCheckbox(section, "Crowd Control", "Check to use crowd controls on select units/buffs.")
        br.ui:createCheckbox(section, "Enrages Handler", "Check this to allow Enrages Handler.")
        br.ui:checkSectionState(section)
    end

    local function callHealingEngine()
        -- Healing Engine
        section = br.ui:createSection(br.ui.window.config, "Healing Engine")
        br.ui:createCheckbox(section, "HE Active", "Uncheck to disable Healing Engine.\nCan improves FPS if you dont rely on Healing Engine.")
        br.ui:createCheckbox(section, "Heal Pets", "Check this to Heal Pets.")
        br.ui:createDropdown(section, "Special Heal", {"Target", "T/M", "T/M/F", "T/F"}, 1, "Check this to Heal Special Whitelisted Units.", "Choose who you want to Heal.")
        br.ui:createCheckbox(section, "Sorting with Role", "Sorting with Role")
        br.ui:createDropdown(section, "Prioritize Special Targets", {"Special", "All"}, 1, "Prioritize Special targets(mouseover/target/focus).", "Choose Which Special Units to consider.")
        br.ui:createSpinner(section, "Blacklist", 95, nil, nil, nil, "|cffFFBB00How much |cffFF0000%HP|cffFFBB00 do we want to add to |cffFFDD00Blacklisted |cffFFBB00units. Use /Blacklist while mouse-overing someone to add it to the black list.")
        br.ui:createCheckbox(section, "Ignore Absorbs", "Check this if you want to ignore absorb shields. If checked, it will add shieldBuffValue/4 to hp. May end up as overheals, disable to save mana.")
        br.ui:createCheckbox(section, "Incoming Heals", "If checked, it will add incoming health from other healers to hp. Uncheck this if you want to prevent overhealing units.")
        br.ui:createSpinner(section, "Overhealing Cancel", 95, nil, nil, nil, "Set Desired Threshold at which you want to prevent your own casts. CURRENTLY NOT IMPLEMENTED!")
        healingDebug = br.ui:createCheckbox(section, "Healing Debug", "Check to display Healing Engine Debug.")
        br.ui:createSpinner(section, "Debug Refresh", 500, 0, 1000, 25, "Set desired Healing Engine Debug Table refresh for rate in ms.")
        br.ui:createSpinner(section, "Dispel delay", 15, 5, 90, 5, "Set desired dispel delay in % of debuff duration.\n|cffFF0000Will randomise around the value you set.")
        br.ui:createCheckbox(section, "Healer Line of Sight Indicator", "Draws a line to healers. Green In Line of Sight / Red Not In Line of Sight")
        br.ui:checkSectionState(section)
    end

    local function callOtherFeaturesEngine()
        -- Other Features
        section = br.ui:createSection(br.ui.window.config, "Other Features")
        br.ui:createSpinner(section, "Profession Helper", 0.5, 0, 1, 0.1, "Check to enable Professions Helper.", "Set Desired Recast Delay.")
        br.ui:createDropdown(section, "Prospect Ores", {"Legion","WoD", "MoP", "Cata", "All"}, 1, "Prospect Desired Ores.")
        br.ui:createDropdown(section, "Mill Herbs", {"Legion","WoD", "MoP", "Cata", "All"}, 1, "Mill Desired Herbs.")
        br.ui:createCheckbox(section, "Disenchant", "Disenchant Cata blues/greens.")
        br.ui:createCheckbox(section, "Leather Scraps", "Combine leather scraps.")
        br.ui:checkSectionState(section)
    end

    -- Add Page Dropdown
    br.ui:createPagesDropdown(br.ui.window.config, {
        {
            [1] = "General",
            [2] = callGeneral,
        },
        {
            [1] = "Enemies Engine",
            [2] = callEnemiesEngine,
        },
        {
            [1] = "Healing Engine",
            [2] = callHealingEngine,
        },
        {
            [1] = "Other Features",
            [2] = callOtherFeaturesEngine,
        },
    })

    br.ui:checkWindowStatus("config")
end