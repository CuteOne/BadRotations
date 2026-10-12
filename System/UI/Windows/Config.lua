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
    -- Options an expansion adds at the end of a page (Expansions/<Name>/Options.lua)
    local function expansionOptions(page)
        local add = br.api.botOptions and br.api.botOptions[page]
        if add then add(section, br.ui.window.config) end
    end

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
    end

    local function callEnemiesEngine()
        -- Enemies Engine
        section = br.ui:section("Enemies Engine", { window = br.ui.window.config })
        br.ui:checkbox(section, "Tank Aggro = Player Aggro", { tip = "If checked, when tank gets aggro, player will go into combat" })
        br.ui:checkbox(section, "Enhanced Time to Die", { tip = "A more precise time to die check, but can be ressource heavy." })
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
        expansionOptions("Enemies Engine")
    end

    -- Targeting options before 2026-10-12 lived on the Enemies Engine page under other names: copy a
    -- character's choices to the Targeting page once (the old keys are then cleaned up as unused)
    local function migrateTargetingOptions()
        local profileSettings = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
        local old = profileSettings and profileSettings["Bot Options/Enemies Engine"]
        if type(old) ~= "table" or old["Dynamic Targetting Check"] == nil then return end
        local function page(name)
            profileSettings[name] = profileSettings[name] or {}
            return profileSettings[name]
        end
        local targeting = page("Bot Options/Targeting")
        if targeting["Targeting Mode Drop"] == nil then
            targeting["Targeting Mode Drop"] = not old["Dynamic Targetting Check"] and 1
                or old["Target Dynamic Target Check"] and 3 or 2
            targeting["Targeting Only In Combat Check"] = old["Dynamic Targetting Drop"] == 1
            targeting["Target Preference Drop"] = old["Wise Target Check"] and (old["Wise Target Drop"] or 1) + 1 or 1
        end
        for name, keys in pairs({
            ["Bot Options/Priorities"] = { "Skull First", "Prioritize Totems", "Forced Burn", "Avoid Shields", "Tank Threat" },
            ["Bot Options/Crowd Control"] = { "Don't break CCs" },
            ["Bot Options/Safety"] = { "Safe Damage Check", "Hostiles Only", "Attack MC Targets" },
        }) do
            local to = page(name)
            for _, key in ipairs(keys) do
                if to[key .. " Check"] == nil and old[key .. " Check"] ~= nil then to[key .. " Check"] = old[key .. " Check"] end
            end
        end
    end

    local function callTargeting()
        migrateTargetingOptions()
        section = br.ui:section("Targeting", { window = br.ui.window.config })
        br.ui:dropdown(section, "Targeting Mode", { choices = { "Off", "Assist", "Full" }, value = "Assist", checkbox = false,
            tip = "Off: spells only use your target. Assist: BR picks the best enemy for each spell when your target can't take it (in combat without a target, it targets that enemy). Full: BR also switches your target to its pick." })
        br.ui:checkbox(section, "Targeting Only In Combat", { tip = "BR picks enemies only while you're in combat; out of combat, spells only use your target." })
        br.ui:dropdown(section, "Target Preference", { choices = { "None", "Highest %", "Lowest %", "Highest health", "Lowest health", "Nearest", "Furthest" },
            value = "None", checkbox = false, tip = "Which enemy BR leans towards when others are equal." })
        br.ui:checkbox(section, "Prefer Near Death", { tip = "Weigh enemies below 20% health more, so all your spells finish them off. Your profile's execute logic still applies." })
        section = br.ui:section("Priorities", { window = br.ui.window.config })
        br.ui:checkbox(section, "Skull First", { tip = "Prefer the enemy marked with a skull." })
        br.ui:checkbox(section, "Prioritize Totems", { tip = "Prefer totems." })
        br.ui:checkbox(section, "Forced Burn", { tip = "Prefer specific whitelisted units that must die first." })
        br.ui:checkbox(section, "Avoid Shields", { tip = "Avoid enemies behind a shield." })
        br.ui:checkbox(section, "Tank Threat", { tip = "When you tank: prefer enemies attacking someone else." })
        section = br.ui:section("Crowd Control", { window = br.ui.window.config })
        br.ui:checkbox(section, "Don't break CCs", { checked = true,
            tip = "Leave crowd-controlled, feared or rooted enemies alone. Your own target may be attacked once no other enemy is fighting, you've stopped moving and you're ready (below), or at once if it fled at low health." })
        br.ui:spinner(section, "Ready To Fight Health", { value = 60, min = 10, max = 100, step = 5, checkbox = false,
            tip = "Your health (%) before BR breaks a crowd control on your target; in a group, the tanks' too." })
        br.ui:spinner(section, "Ready To Fight Mana", { value = 40, min = 0, max = 100, step = 5, checkbox = false,
            tip = "Your mana (%) before BR breaks a crowd control on your target (mana users)." })
        section = br.ui:section("Safety", { window = br.ui.window.config })
        br.ui:checkbox(section, "Safe Damage Check", { tip = "Don't damage units that must not be attacked (whitelisted mechanics)." })
        br.ui:checkbox(section, "Hostiles Only", { tip = "Only attack hostile units (not neutral ones), unless they're your target or attacking you." })
        br.ui:checkbox(section, "Attack MC Targets", { tip = "Allow attacking charmed / mind-controlled players." })
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
        br.ui:checkbox(section, "Fish Oil", { tip = "Turn Fish into Aromatic Fish Oil. Profession Helper must be checked." })
        br.ui:dropdown(section, "Bait", { choices = { "Lost Sole Bait", "Silvergill Pike Bait", "Pocked Bonefish Bait", "Iridescent Amberjack Bait", "Spinefin Piranha Bait", "Elysian Thade Bait" }, value = "Lost Sole Bait",
            tip = "Using the bait." })
        expansionOptions("Other Features")
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
        local y = br.ui.elementOptions.nextRowY(section)
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
        y = br.ui.elementOptions.nextRowY(section)
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
        br.ui:checkbox(section, "Display Failcasts", { tip = "Show casts that failed for a reason worth fixing (not enough power, wrong form, a cast the game rejected). Expected refusals (out of range, target died, not enough targets) are left out." })
        br.ui:checkbox(section, "Cast Debug", { tip = "Troubleshooting: show every cast refusal and check, including the expected ones (tagged as expected)." })
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
                if id ~= br.api.wow.GetGCDSpellID() and spellName ~= nil then
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
        expansionOptions("Healing Options")
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
                [1] = "Targeting",
                [2] = callTargeting
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
