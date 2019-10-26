-- This creates the normal BadRotations Configuration Window
br.ui.window.config = {}
function br.ui:createConfigWindow()
    br.ui.window.config = br.ui:createWindow("config", 275, 400,"Configuration")

    local section
    local function callGeneral()
        -- General
        section = br.ui:createSection(br.ui.window.config, "General")
        br.ui:createCheckbox(section, "Auto Delay", "Check to dynamically change update rate based on current FPS.")
        br.ui:createSpinnerWithout(section, "Bot Update Rate", 0.1, 0.0, 1.0, 0.01, "Adjust the update rate of Bot operations. Increase to improve FPS but may cause reaction delays. Will be ignored if Auto Delay is checked. Default: 0.1")
        br.ui:createSpinnerWithout(section, "Spell Queue", 0.5, 0, 5, 0.1, "Adjust the length of time remaining in a spell to start casting another one.")
        rotationLog = br.ui:createCheckbox(section, "Rotation Log", "Display Rotation Log.");
        -- br.ui:createCheckbox(section, "Rotation Log", "Display Rotation Log.")
        br.ui:createDropdown(section, "Addon Debug Messages", {"System Only", "Profile Only","All"}, 3, "Check this to display developer debug messages.")
        targetval = br.ui:createCheckbox(section, "Target Validation Debug", "Check this to display current target's validation.")
        br.ui:createCheckbox(section, "Display Failcasts", "Dispaly Failcasts in Debug.")
        br.ui:createCheckbox(section, "Queue Casting", "Allow Queue Casting on some profiles.")
        br.ui:createSpinner(section,  "Auto Loot" ,0.5, 0.1, 3, 0.1, "Sets Autloot on/off.", "Sets a delay for Auto Loot.")
        br.ui:createCheckbox(section, "Auto-Sell/Repair", "Automatically sells grays and repairs when you open a repair vendor.")
        br.ui:createCheckbox(section, "Accept Queues", "Automatically accept LFD, LFR, .. queue.")
        br.ui:createCheckbox(section, "Overlay Messages", "Check to enable chat overlay messages.")
        br.ui:createCheckbox(section, "Talent Anywhere", "Check to enable swapping of talents outside of rest areas.")
        br.ui:createSpinner(section,  "Notify Not Unlocked", 10, 5, 60, 5, "Will alert you at the set interval when Unlocker is not attached.")
        br.ui:createCheckbox(section, "Reset Options", "|cffFF0000 WARNING!|cffFFFFFF Checking this will reset setting on reload!")
        br.ui:createCheckbox(section, "Reset Saved Profiles", "|cffFF0000 WARNING!|cffFFFFFF Checking this will reset saved profiles on reload!")
        br.ui:checkSectionState(section)
    end

    local function callEnemiesEngine()
        -- Enemies Engine
        section = br.ui:createSection(br.ui.window.config, "Enemies Engine")
        br.ui:createDropdown(section, "Dynamic Targetting", {"Only In Combat","Default", --[["Lite"]]}, 2, "Check this to allow dynamic targetting. If unchecked, profile will only attack current target.")
        --br.ui:createCheckbox(section,"Include Range", "Checking this will pick a new target if current target is out of range. (Only valid on Lite mode)")
        br.ui:createCheckbox(section, "Target Dynamic Target", "Check this will target the current dynamic target.")
        br.ui:createCheckbox(section, "Tank Aggro = Player Aggro", "If checked, when tank gets aggro, player will go into combat")
        br.ui:createCheckbox(section, "Hostiles Only", "Checking this will target only units hostile to you.")
        br.ui:createCheckbox(section, "Attack MC Targets", "Check this to allow addon to attack charmed/mind controlled targets.")
        br.ui:createCheckbox(section, "Enhanced Time to Die", "A more precise time to die check, but can be ressource heavy.")
        br.ui:createCheckbox(section, "Prioritize Totems", "Check this to target totems first.")
        br.ui:createDropdown(section, "Wise Target", {"Highest %", "Lowest %", "abs Highest", "abs Lowest", "Nearest", "Furthest"}, 1, "|cffFFDD11Check if you want to use Wise Targetting, if unchecked there will be no priorisation from hp/range.")
        --br.ui:createDropdownWithout(section, "Wise Target Frequency", {"Default","Only on Target Death"}, 1, "Sets how often Wise Target checks for a better target.")
        br.ui:createCheckbox(section, "Forced Burn", "Check to allow forced Burn on specific whitelisted units.")
        br.ui:createCheckbox(section, "Avoid Shields", "Check to avoid attacking shielded units.")
        br.ui:createCheckbox(section, "Tank Threat", "Check add more priority to targets you lost aggro on(tank only).")
        br.ui:createCheckbox(section, "Safe Damage Check", "Check to prevent damage to targets you dont want to attack.")
        br.ui:createCheckbox(section, "Don't break CCs", "Check to prevent damage to targets that are CC.")
        br.ui:createCheckbox(section, "Skull First", "Check to enable focus skull dynamically.")
        br.ui:createCheckbox(section, "Dispel Only Whitelist", "Check to only dispel debuffs listed on the whitelist.")
        br.ui:createCheckbox(section, "Purge Only Whitelist", "Check to only purge buffs listed on the whitelist.")
        br.ui:createCheckbox(section, "Interrupt Only Whitelist", "Check to only interrupt casts listed on the whitelist.")
        br.ui:createDropdownWithout(section, "Interrupt Target", {"All", "Target", "Focus", "Marked"},  1, "Interrupt target settings.")
        br.ui:createDropdownWithout(section, "Interrupt Mark", {"|cffffff00Star", "|cffffa500Circle", "|cff800080Diamond", "|cff008000Triangle", "|cffffffffMoon", "|cff0000ffSquare", "|cffff0000Cross", "|cffffffffSkull"},  8, "Mark to interrupt if Marked is selected in Interrupt Target.")
        br.ui:createCheckbox(section, "Only Known Units", "Check this to interrupt only on known units using whitelist.")
        br.ui:createCheckbox(section, "Crowd Control", "Check to use crowd controls on select units/buffs.")
        br.ui:createCheckbox(section, "Enrages Handler", "Check this to allow Enrages Handler.")
        br.ui:checkSectionState(section)
    end

    local function callHealingEngine()
        -- Healing Engine
        section = br.ui:createSection(br.ui.window.config, "Healing Engine")
        br.ui:createCheckbox(section, "HE Active", "Uncheck to disable Healing Engine.\nCan improves FPS if you dont rely on Healing Engine.")
        --br.ui:createCheckbox(section, "Disable Object Manager", "Check to disable OM. Will disable dynamic targetting. Will prevent all spells that require OM from working correctly.")
        br.ui:createCheckbox(section, "Heal Pets", "Check this to Heal Pets.")
        br.ui:createDropdown(section, "Special Heal", {"Target", "T/M", "T/M/F", "T/F"}, 1, "Check this to Heal Special Whitelisted Units.", "Choose who you want to Heal.")
        br.ui:createDropdown(section, "Prioritize Special Targets", {"Special", "All"}, 1, "Prioritize Special targets(mouseover/target/focus).", "Choose Which Special Units to consider.")
        br.ui:createSpinner(section, "Blacklist", 95, nil, nil, nil, "|cffFFBB00How much |cffFF0000%HP|cffFFBB00 do we want to add to |cffFFDD00Blacklisted |cffFFBB00units. Use /Blacklist while mouse-overing someone to add it to the black list.")
        br.ui:createSpinner(section, "Prioritize Tank", 5, 0, 100, 1, "Check this to give tanks more priority")
        --br.ui:createSpinner(section, "Prioritize Debuff", 3, 0, 100, 1, "Check this to give debuffed targets more priority")
        br.ui:createCheckbox(section, "Ignore Absorbs", "Check this if you want to ignore absorb shields. If checked, it will add shieldBuffValue/4 to hp. May end up as overheals, disable to save mana.")
        br.ui:createCheckbox(section, "Incoming Heals", "If checked, it will add incoming health from other healers to hp. Check this if you want to prevent overhealing units.")
        br.ui:createSpinner(section, "Overhealing Cancel", 95, nil, nil, nil, "Set Desired Threshold at which you want to prevent your own casts. CURRENTLY NOT IMPLEMENTED!")
        --healingDebug = br.ui:createCheckbox(section, "Healing Debug", "Check to display Healing Engine Debug.")
        --br.ui:createSpinner(section, "Debug Refresh", 500, 0, 1000, 25, "Set desired Healing Engine Debug Table refresh for rate in ms.")
        br.ui:createSpinner(section, "Dispel delay", 1.5, 0.5, 5, 0.1, "Set desired dispel delay in seconds of debuff duration.\n|cffFF0000Will randomise around the value you set.")
        br.ui:createCheckbox(section, "Healer Line of Sight Indicator", "Draws a line to healers. Green In Line of Sight / Red Not In Line of Sight")
        br.ui:checkSectionState(section)
    end

    local function callOtherFeaturesEngine()
        -- Other Features
        section = br.ui:createSection(br.ui.window.config, "Other Features")
        br.ui:createSpinner(section, "Profession Helper", 0.5, 0, 1, 0.1, "Check to enable Professions Helper.", "Set Desired Recast Delay.")
        br.ui:createDropdown(section, "Prospect Ores", {"BFA","Legion","WoD", "MoP", "Cata", "All"}, 1, "Prospect Desired Ores. Profession Helper must be checked.")
        br.ui:createDropdown(section, "Mill Herbs", {"BFA","Legion","WoD", "MoP", "Cata", "All"}, 1, "Mill Desired Herbs. Profession Helper must be checked.")
        br.ui:createCheckbox(section, "Disenchant", "Disenchant Cata blues/greens. Profession Helper must be checked.")
        br.ui:createCheckbox(section, "Leather Scraps", "Combine leather scraps. Profession Helper must be checked.")
        br.ui:createCheckbox(section, "Lockboxes", "Unlock Lockboxes. Profession Helper must be checked.")
        br.ui:createDropdown(section, "Fishing", {"Enabled","Disabled"}, 2, "Turn EWT Fishing On/Off")
        br.ui:createCheckbox(section, "Fish Oil", "Turn Fish into Aromatic Fish Oil. Profession Helper must be checked.")
        br.ui:createDropdown(section, "Anti-Afk", {"Enabled","Disabled"}, 2, "Turn EWT Anti-Afk On/Off")
        br.ui:createCheckbox(section, "Quaking Helper", "Auto cancel channeling and block casts during mythic+ affix quaking")
        br.ui:createCheckbox(section, "Debug Timers", "Useless to users, for Devs.")
        br.ui:createCheckbox(section, "Cache Debuffs", "Experimental feature still in testing")
        br.ui:createCheckbox(section, "Show Drawings", "Show drawings on screen using Lib Draw")
        br.ui:checkSectionState(section)
    end

    local function callSettingsEngine()
        section = br.ui:createSection(br.ui.window.config, "Create New Settings Profiles or Load Existing")
        --br.ui:createDropdownWithout(section, "Load Prior Saved Settings", {"Dungeons", "Mythic Dungeons", "Raids", "Mythic Raids"}, 1, "Select Profile to Load.")
        br.ui:createProfileDropdown(section)
        br.ui:createSaveButton(section, " +", 200, -5)
        br.ui:createDeleteButton(section, " -", 220, -5)
        br.ui:createLoadButton(section, "Load", 20, -40)
        br.ui:createText(section,"Export/Import from Settings Folder")
        br.ui:createExportButton(section, "Export", 40, -90)
        br.ui:createImportButton(section, "Import", 140, -90)
        br.ui:createText(section,"FileName: "..br.selectedSpec..br.selectedProfileName..".lua")
        br.ui:checkSectionState(section)
    end

    local function callQueueEngine()
        local function pairsByKeys (t, f)
            local a = {}
            for n in pairs(t) do table.insert(a, n) end
                table.sort(a, f)
                local i = 0      -- iterator variable
                local iter = function ()   -- iterator function
                i = i + 1
                if a[i] == nil then 
                    return nil
                else return a[i], t[a[i]]
                end
            end
            return iter
        end
        section = br.ui:createSection(br.ui.window.config, "Smart Queue")
        br.ui:createSpinner(section,  "Smart Queue", 2, 0.5, 3, 0.1, "Auto cast spells you press (Only EWT support)", "Seconds to attempt cast")
        if br.player ~= nil and br.player.spell ~= nil and br.player.spell.abilities ~= nil then
            for k, v in pairsByKeys(br.player.spell.abilities) do
                local spellName = GetSpellInfo(v)
                if v ~= 61304 and spellName ~= nil then
                    br.ui:createDropdown(section, spellName .. " (Queue)", {"Normal", "Cursor", "Cursor (No Cast)", "Mouseover"}, 1, "Active Queueing Of " .. spellName .. " (ID: " .. v .. ")", "Select cast mode")
                end
            end
        end
        br.ui:checkSectionState(section)
    end

    local function callHealingOptions()
        section = br.ui:createSection(br.ui.window.config, "Healing Options")
        br.ui:createSpinnerWithout(section, "Bwonsamdi's Wrath HP", 30,1,100, 5, "Set HP to decurse Bwonsamdi's Wrath (Mythic Conclave)")
        br.ui:createSpinnerWithout(section, "Reaping", 20, 1, 100, 5, "Set how many stacks of reaping needed to dispel.")
        br.ui:createSpinnerWithout(section, "Promise of Power", 8, 1, 10, 1, "Set how many stacks of promise of power needed to dispel.")
        br.ui:createSpinner(section, "Toxic Brand", 10, 1, 20, 1, "Set how many stacks of toxic brand to stop healing party members at.")
        br.ui:createCheckbox(section, "Arcane Bomb Range Check","Will check range of target from rest of party if checked.")
        br.ui:createCheckbox(section, "Arcane Burst", "Will dispel Arcane Burst if checked.")
        br.ui:createSpinner(section, "Necrotic Rot", 40, 1, 100, 5, "Set how many stacks of necrotic rot to stop healing party members at.")
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
            [1] = "Healing Options",
            [2] = callHealingOptions,
        },
        {
            [1] = "Queue Engine",
            [2] = callQueueEngine,
        },
        {
            [1] = "Other Features",
            [2] = callOtherFeaturesEngine,
        },
         {
             [1] = "Save/Load Settings",
             [2] = callSettingsEngine,
         },
    })

    br.ui:checkWindowStatus("config")
end
