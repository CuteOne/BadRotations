local _, br = ...
-- This creates the normal BadRotations Configuration Window
br.ui.window.config = {}
function br.ui:createConfigWindow()
    -- br._G.print("Creating Config Window") -- Debug
    br.ui.window.config = br.ui:createWindow("config", 275, 400, "Configuration")

    if not br.ui.window.config then
        br._G.print("Error: Failed to create config window")
        return
    end

    local section
    local function callGeneral()
        -- General
        section = br.ui:section("General", { window = br.ui.window.config })
        br.ui:checkbox(section, "Auto Delay", { tip = "Check to dynamically change update rate based on current FPS." })
        br.ui:spinner(section, "Bot Update Rate", { value = 0.1, max = 1.0, step = 0.01, checkbox = false,
            tip = "Adjust the update rate of Bot operations. Increase to improve FPS but may cause reaction delays. Will be ignored if Auto Delay is checked. Default: 0.1" })
        br.ui:checkbox(section, "Queue Casting", { tip = "Allow Queue Casting on some profiles." })
        br.ui:spinner(section, "Auto Loot", { value = 0.5, min = 0.1, max = 3, step = 0.1,
            tip = "Sets Autloot on/off.", boxTip = "Sets a delay for Auto Loot." })
        br.ui:checkbox(section, "Auto-Sell/Repair", { tip = "Automatically sells grays and repairs when you open a repair vendor." })
        br.ui:checkbox(section, "Accept Queues", { tip = "Automatically accept LFD, LFR, .. queue." })
        br.ui:checkbox(section, "Overlay Messages", { tip = "Check to enable chat overlay messages." })
        br.ui:spinner(section, "Notify Not Unlocked", { value = 10, min = 5, max = 60,
            tip = "Will alert you at the set interval when Unlocker is not attached." })
        br.ui:checkbox(section, "Reset Options", { tip = "|cffFF0000 WARNING!|cffFFFFFF Checking this will reset setting on reload!" })
        br.ui:checkbox(section, "Reset Saved Profiles", { tip = "|cffFF0000 WARNING!|cffFFFFFF Checking this will reset saved profiles on reload!" })
        br.ui:checkbox(section, "Auto Check for Updates", { tip = "EWT only. This uses the Git master head sha for comparison. |cffFF0000Experimental!" })
    end

    local function callEnemiesEngine()
        -- Enemies Engine
        section = br.ui:section("Enemies Engine", { window = br.ui.window.config })
        br.ui:dropdown(section, "Dynamic Targetting", { choices = { "Only In Combat", "Default" }, value = "Default",
            tip = "Check this to allow dynamic targetting. If unchecked, profile will only attack current target." })
        --br.ui:createCheckbox(section, "Include Range", "Checking this will pick a new target if current target is out of range. (Only valid on Lite mode)")
        br.ui:checkbox(section, "Target Dynamic Target", { tip = "Check this will target the current dynamic target." })
        br.ui:checkbox(section, "Tank Aggro = Player Aggro", { tip = "If checked, when tank gets aggro, player will go into combat" })
        br.ui:checkbox(section, "Hostiles Only", { tip = "Checking this will target only units hostile to you." })
        br.ui:checkbox(section, "Attack MC Targets", { tip = "Check this to allow addon to attack charmed/mind controlled targets." })
        br.ui:checkbox(section, "Enhanced Time to Die", { tip = "A more precise time to die check, but can be ressource heavy." })
        br.ui:checkbox(section, "Prioritize Totems", { tip = "Check this to target totems first." })
        br.ui:checkbox(section, "Darter Targeter", { tip = "Auto target Darters on Hivemind" })
        br.ui:dropdown(section, "Wise Target", { choices = { "Highest %", "Lowest %", "abs Highest", "abs Lowest", "Nearest", "Furthest" }, value = "Highest %",
            tip = "|cffFFDD11Check if you want to use Wise Targetting, if unchecked there will be no priorisation from hp/range." })
        br.ui:dropdown(section, "Wise Target Frequency", { choices = { "Default", "Only on Target Death" }, value = "Default", checkbox = false,
            tip = "Sets how often Wise Target checks for a better target." })
        br.ui:checkbox(section, "Forced Burn", { tip = "Check to allow forced Burn on specific whitelisted units." })
        br.ui:checkbox(section, "Avoid Shields", { tip = "Check to avoid attacking shielded units." })
        br.ui:checkbox(section, "Tank Threat", { tip = "Check add more priority to targets you lost aggro on(tank only)." })
        br.ui:checkbox(section, "Safe Damage Check", { tip = "Check to prevent damage to targets you dont want to attack." })
        --br.ui:createCheckbox(section, "Ignore Big Slime on PF", "Check to not attack Slimy Smorgasbord")
        br.ui:spinner(section, "Bursting Stack Limit", { value = 2, min = 1, max = 10, step = 1, checkbox = false,
            tip = "**Requires Safe Damage Check** - Set to desired limit, will still dps targets but not kill until below limit." })
        br.ui:checkbox(section, "Don't break CCs", { tip = "Check to prevent damage to targets that are CC." })
        br.ui:checkbox(section, "Skull First", { tip = "Check to enable focus skull dynamically." })
        br.ui:checkbox(section, "Boss Detection Only In Instance", { tip = "Check to only detect Dungeon/Raid Bosses, not Open World" })
        br.ui:checkbox(section, "Dispel Only Whitelist", { tip = "Check to only dispel debuffs listed on the whitelist." })
        br.ui:checkbox(section, "Purge Only Whitelist", { tip = "Check to only purge buffs listed on the whitelist." })
        br.ui:checkbox(section, "Interrupt Only Whitelist", { tip = "Check to only interrupt casts listed on the whitelist." })
        br.ui:dropdown(section, "Interrupt Target", { choices = { "All", "Target", "Focus", "Marked" }, value = "All", checkbox = false,
            tip = "Interrupt target settings." })
        br.ui:dropdown(section, "Interrupt Mark", { choices = { "|cffffff00Star", "|cffffa500Circle", "|cff800080Diamond", "|cff008000Triangle", "Moon", "|cff0000ffSquare", "|cffff0000Cross", "Skull" }, value = "Skull", checkbox = false,
            tip = "Mark to interrupt if Marked is selected in Interrupt Target." })
        br.ui:checkbox(section, "Only Known Units", { tip = "Check this to interrupt only on known units using whitelist." })
        -- br.ui:createCheckbox(section, "Crowd Control", "Check to use crowd controls on select units/buffs.")
        br.ui:checkbox(section, "Enrages Handler", { tip = "Check this to allow Enrages Handler." })
    end

    local function callHealingEngine()
        -- Healing Engine
        section = br.ui:section("Healing Engine", { window = br.ui.window.config })
        br.ui:checkbox(section, "HE Active", { tip = "Uncheck to disable Healing Engine.\nCan improves FPS if you dont rely on Healing Engine." })
        --br.ui:createCheckbox(section, "Handle Sorting in Healing Engine", "Uncheck this to handle sorting at the profile level if dev has made special sorting")
        --br.ui:createDropdownWithout(section, "Sort Health By", { "Percent HP","Absolute HP"}, 1, "Sort HP by Percent or Absolute")
        br.ui:checkbox(section, "Heal Pets", { tip = "Check this to Heal Pets." })
        br.ui:dropdown(section, "Special Heal", { choices = { "Target", "T/M", "T/M/F", "T/F" }, value = "Target",
            tip = "Check this to Heal Special Whitelisted Units.", boxTip = "Choose who you want to Heal." })
        br.ui:checkbox(section, "Prioritize Special Targets", { tip = "Prioritize Special targets(mouseover/target/focus)." })
        br.ui:spinner(section, "Blacklist", { value = 95,
            tip = "|cffFFBB00How much |cffFF0000%HP|cffFFBB00 do we want to add to |cffFFDD00Blacklisted |cffFFBB00units. Use /Blacklist while mouse-overing someone to add it to the black list." })
        br.ui:spinner(section, "Prioritize Tank", { value = 5, step = 1, tip = "Check this to prioritize tanks" })
        --br.ui:createSpinner(section, "Prioritize Debuff", 3, 0, 100, 1, "Check this to give debuffed targets more priority")
        br.ui:checkbox(section, "Ignore Absorbs", { tip = "Check this if you want to ignore absorb shields. If checked, it will add shieldBuffValue/4 to hp. May end up as overheals, disable to save mana." })
        br.ui:checkbox(section, "Incoming Heals", { tip = "If checked, it will add incoming health from other healers to hp. Check this if you want to prevent overhealing units." })
        br.ui:spinner(section, "Overhealing Cancel", { value = 95,
            tip = "Set Desired Threshold at which you want to prevent your own casts. CURRENTLY NOT IMPLEMENTED!" })
        --br.healingDebug = br.ui:createCheckbox(section, "Healing Debug", "Check to display Healing Engine Debug.")
        --br.ui:createSpinner(section, "Debug Refresh", 500, 0, 1000, 25, "Set desired Healing Engine Debug Table refresh for rate in ms.")
        br.ui:spinner(section, "Dispel delay", { value = 1.5, min = 0.5, max = 5, step = 0.1,
            tip = "Set desired dispel delay in seconds of debuff duration.\n|cffFF0000Will randomise around the value you set." })
        br.ui:checkbox(section, "Healer Line of Sight Indicator", { tip = "Draws a line to healers. Green In Line of Sight / Red Not In Line of Sight" })
    end

    local function callOtherFeaturesEngine()
        -- Other Features
        section = br.ui:section("Other Features", { window = br.ui.window.config })
        --br.ui:createCheckbox(section, "PokeRotation")
        br.ui:checkbox(section, "Bypass Vehicle Check")
        br.ui:spinner(section, "Profession Helper", { value = 0.5, max = 1, step = 0.1,
            tip = "Check to enable Professions Helper.", boxTip = "Set Desired Recast Delay." })
        br.ui:dropdown(section, "Prospect Ores", { choices = { "SL", "BFA", "Legion", "WoD", "MoP", "Cata", "All" }, value = "SL",
            tip = "Prospect Desired Ores. Profession Helper must be checked." })
        br.ui:dropdown(section, "Mill Herbs", { choices = { "SL", "BFA", "Legion", "WoD", "MoP", "Cata", "All" }, value = "SL",
            tip = "Mill Desired Herbs. Profession Helper must be checked." })
        br.ui:checkbox(section, "Disenchant", { tip = "Disenchant Cata blues/greens. Profession Helper must be checked." })
        br.ui:checkbox(section, "Leather Scraps", { tip = "Combine leather scraps. Profession Helper must be checked." })
        br.ui:checkbox(section, "Lockboxes", { tip = "Unlock Lockboxes. Profession Helper must be checked." })
        br.ui:dropdown(section, "Fishing", { choices = { "Enabled", "Disabled" }, value = "Disabled", tip = "Turn EWT Fishing On/Off" })
        br.ui:checkbox(section, "Fish Oil", { tip = "Turn Fish into Aromatic Fish Oil. Profession Helper must be checked." })
        br.ui:dropdown(section, "Bait", { choices = { "Lost Sole Bait", "Silvergill Pike Bait", "Pocked Bonefish Bait", "Iridescent Amberjack Bait", "Spinefin Piranha Bait", "Elysian Thade Bait" }, value = "Lost Sole Bait",
            tip = "Using the bait." })
        section = br.ui:section("Dungeon Helpers", { window = br.ui.window.config })
        br.ui:checkbox(section, "Quaking Helper", { tip = "Auto cancel channeling and block casts during mythic+ affix quaking" })
        br.ui:spinner(section, "Catcher/Snatcher Delay", { value = 0.5, max = 1, step = 0.1, checkbox = false })
        br.ui:checkbox(section, "Freehold - Pig Catcher", { tip = "Catch pig in Ring of Booty" })
        br.ui:checkbox(section, "De Other Side - Bomb Snatcher", { tip = "Catch bomb in The Manastorms fight" })
    end

    local function callSettingsEngine()
        -- Snapshots of this profile's Rotation Options, toggles and Base Options for different content
        local snapshots = { "Solo", "Dungeon", "M+ Dungeon", "Raid" }
        local snapshotParts = { "base", "profile" }
        local function selectedSnapshot() return snapshots[br.functions.misc:getValue("Select Settings")] or snapshots[1] end
        section = br.ui:section("Load Saved Profiles", { window = br.ui.window.config })
        br.ui:dropdown(section, "Select Settings", { choices = snapshots, value = "Dungeon", checkbox = false,
            tip = "Pick a set of settings, then Save the current settings to it or Load it" })
        br.ui:text(section, "Loading replaces your current settings")
        br.ui:text(section, "(the replaced files are kept as .bak1).")
        local y = -5
        for i = 1, #section.children do
            if section.children[i].type ~= "Spinner" and section.children[i].type ~= "Dropdown" then
                y = y - section.children[i].frame:GetHeight() * 1.2
            end
        end
        y = br.functions.misc:round2(y, 1)
        local settings = br.ui.settingsManagement
        br.ui:createButton(section, "Save", 10, y, function()
            local name = selectedSnapshot()
            settings:saveSnapshot(settings:snapshotDir(name), snapshotParts, name .. " settings")
        end)
        br.ui:createButton(section, "Load", -10, y, function()
            local name = selectedSnapshot()
            -- Snapshots saved before the settings rework live under Settings/Profile Settings/
            settings:loadSnapshot(settings:snapshotDir(name), snapshotParts, name .. " settings", settings:legacySnapshotDir(name))
        end, true)
        -- Every settings file (Bot, Base and Rotation Options) for moving or sharing them
        section = br.ui:section("Export/Import from Settings Folder", { window = br.ui.window.config })
        br.ui:text(section, "Export/Import all settings for this profile:")
        br.ui:text(section, "Settings/Exported Settings/<Class>/<Spec>/" .. tostring(br.loader.selectedProfileName))
        y = -5
        for i = 1, #section.children do
            if section.children[i].type ~= "Spinner" and section.children[i].type ~= "Dropdown" then
                y = y - section.children[i].frame:GetHeight() * 1.2
            end
        end
        y = br.functions.misc:round2(y, 1)
        br.ui:createButton(section, "Export", 10, y, function()
            settings:cleanSettings()
            settings:saveSnapshot(settings:exportDir(), { "bot", "base", "profile" }, "exported settings")
        end)
        br.ui:createButton(section, "Import", -10, y, function()
            settings:loadSnapshot(settings:exportDir(), { "bot", "base", "profile" }, "exported settings")
        end, true)
    end

    local function callTrackerEngine()
        -- Main
        section = br.ui:section("Main Settings", { window = br.ui.window.config })
        br.ui:checkbox(section, "Enable Tracker")
        br.ui:checkbox(section, "Display Extra Info")
        br.ui:checkbox(section, "Draw Lines to Tracked Objects")
        br.ui:checkbox(section, "Auto Interact with Any Tracked Object")
        br.ui:checkbox(section, "Rare Tracker", { tip = "Track All Rares In Range" })
        br.ui:dropdown(section, "Quest Tracker", { choices = { "Units", "Objects", "Both" }, value = "Both", tip = "Track Quest Units/Objects" })
        br.ui:createScrollingEditBox(section, "Custom Tracker", nil, "Type custom search, Can Seperate items by comma",
            300, 40)
    end

    local function callDebugOptions()
        -- Debug and Developer Options
        section = br.ui:section("Debug Options", { window = br.ui.window.config })
        br.ui.rotationLog = br.ui:checkbox(section, "Rotation Log", { tip = "Display Rotation Log." })
        br.ui:dropdown(section, "Addon Debug Messages", { choices = { "System Only", "Profile Only", "All" }, value = "All",
            tip = "Check this to display developer debug messages." })
        br.ui:checkbox(section, "Target Validation Debug", { tip = "Check this to display current target's validation." })
        br.ui:checkbox(section, "Display Failcasts", { tip = "Dispaly Failcasts in Debug." })
        br.ui:checkbox(section, "Cast Debug", { tip = "Shows information about how the bot is casting." })
        br.ui:checkbox(section, "Threat Debug", { tip = "Shows information about threat and threat changes." })

        section = br.ui:section("Developer Options", { window = br.ui.window.config })
        br.ui:checkbox(section, "Dev Mode", { tip = "|cffFF0000WARNING! This will expose the BR table to global for testing purposes.  Do not use unless you know what you're doing." })
        br.ui:checkbox(section, "Debug Timers", { tip = "Useless to users, for Devs." })
        br.ui:checkbox(section, "Cache Debuffs", { tip = "Experimental feature still in testing" })
        br.ui:checkbox(section, "Unit ID In Tooltip", { tip = "Show/Hide Unit IDs in Tooltip" })
        br.ui:checkbox(section, "Show Drawings", { tip = "Show drawings on screen using Lib Draw" })
    end

    local function callQueueEngine()
        local function pairsByKeys(t, f)
            local a = {}
            for n in pairs(t) do
                table.insert(a, n)
            end
            table.sort(a, f)
            local i = 0 -- iterator variable
            local iter = function()
                -- iterator function
                i = i + 1
                if a[i] == nil then
                    return nil
                else
                    return a[i], t[a[i]]
                end
            end
            return iter
        end
        section = br.ui:section("Smart Queue", { window = br.ui.window.config })
        br.ui:spinner(section, "Smart Queue", { value = 2, min = 0.5, max = 3, step = 0.1,
            tip = "Auto cast spells you press (Only EWT support)", boxTip = "Seconds to attempt cast" })
        if br.player ~= nil and br.player.spells ~= nil and br.player.spells.abilities ~= nil then
            for _, v in pairsByKeys(br.player.spells.abilities) do
                local id = type(v) == "table" and (br.functions.spell and br.functions.spell.getHighestKnownRank and br.functions.spell:getHighestKnownRank(v) or v[1]) or v
                local spellName = br.api.wow.GetSpellInfo(id)
                if id ~= 61304 and spellName ~= nil then
                    br.ui:dropdown(section, spellName .. " (Queue)", { choices = { "Normal", "Cursor", "Cursor (No Cast)", "Mouseover" }, value = "Normal",
                        tip = "Active Queueing Of " .. spellName .. " (ID: " .. id .. ")", boxTip = "Select cast mode" })
                end
            end
        end
    end

    local function callHealingOptions()
        section = br.ui:section("Healing Options", { window = br.ui.window.config })
        br.ui:checkbox(section, "Ignore Range Check", { tip = "Will ignore any range checks for dispels" })
        br.ui:checkbox(section, "Ignore Stack Count", { tip = "Will ignore any stack checks for dispels" })
        br.ui:spinner(section, "Bwonsamdi's Wrath HP", { value = 30, min = 1, checkbox = false,
            tip = "Set HP to decurse Bwonsamdi's Wrath (Mythic Conclave)" })
        br.ui:spinner(section, "Reaping", { value = 20, min = 1, checkbox = false, tip = "Set how many stacks of reaping needed to dispel." })
        br.ui:spinner(section, "Promise of Power", { value = 8, min = 1, max = 10, step = 1, checkbox = false,
            tip = "Set how many stacks of promise of power needed to dispel." })
        br.ui:spinner(section, "Toxic Brand", { value = 10, min = 1, max = 20, step = 1,
            tip = "Set how many stacks of toxic brand to stop healing party members at." })
        br.ui:checkbox(section, "Arcane Burst", { tip = "Will dispel Arcane Burst if checked." })
        br.ui:spinner(section, "Necrotic Rot", { value = 40, min = 1, tip = "Set how many stacks of necrotic rot to stop healing party members at." })
        br.ui:spinner(section, "Decaying Strike Timer", { value = 5, min = 1, max = 20, step = 1, checkbox = false,
            tip = "Set how long to stop healing tank before Decaying Strike is cast." })
    end

    -- local function callDebugOptions()
    --     local section
    --     br.debug.labels = {}
    --     local labels = br.debug.labels
    --     section = br.ui:createSection(br.ui.window.config, "Debug Info")
    --     br.ui:createCheckbox(section, "Enable Debug Info")
    --     labels.updateRate = br.ui:createText(section, "")
    --     -- br.ui:createText(section, "Lowest Unit")
    --     -- labels.lowest   = br.ui:createText(section, "")
    --     labels.target     = br.ui:createText(section, "")
    --     labels.ttd        = br.ui:createText(section, "")
    --     br.ui:checkSectionState(section)
    -- end

    -- Add Page Dropdown
    br.ui:createPagesDropdown(
        br.ui.window.config,
        {
            {
                [1] = "General",
                [2] = callGeneral
            },
            {
                [1] = "Enemies Engine",
                [2] = callEnemiesEngine
            },
            {
                [1] = "Healing Engine",
                [2] = callHealingEngine
            },
            {
                [1] = "Healing Options",
                [2] = callHealingOptions
            },
            {
                [1] = "Queue Engine",
                [2] = callQueueEngine
            },
            {
                [1] = "Other Features",
                [2] = callOtherFeaturesEngine
            },
            {
                [1] = "Save/Load Settings",
                [2] = callSettingsEngine
            },
            {
                [1] = "Tracker Engine",
                [2] = callTrackerEngine
            },
            {
                [1] = "Debug",
                [2] = callDebugOptions
            },
            -- {
            --     [1] = "Debug Info",
            --     [2] = callDebugOptions
            -- },
        }
    )

    br.ui:checkWindowStatus("config")
end
