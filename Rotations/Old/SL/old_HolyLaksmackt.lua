--Version 1.0.0
local rotationName = "Laksmackt" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Define custom toggles
    -- Cooldown Button
    CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 0, icon = br.player.spell.holyAvenger},
        [2] = {mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.auraMastery},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.absolution}
    }
    CreateButton("Cooldown", 1, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 0, icon = br.player.spell.divineProtection},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.blessingOfProtection}
    }
    CreateButton("Defensive", 2, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.blindingLight},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.blindingLight}
    }
    CreateButton("Interrupt", 3, 0)
    -- Cleanse Button
    CleanseModes = {
        [1] = {mode = "On", value = 1, overlay = "Cleanse Enabled", tip = "Cleanse Enabled", highlight = 0, icon = br.player.spell.cleanse},
        [2] = {mode = "Off", value = 2, overlay = "Cleanse Disabled", tip = "Cleanse Disabled", highlight = 0, icon = br.player.spell.cleanse}
    }
    CreateButton("Cleanse", 4, 0)
    -- Glimmer
    GlimmerModes = {
        [1] = {mode = "On", value = 1, overlay = "Glimmer mode", tip = "Glimmer on", highlight = 0, icon = 287280},
        [2] = {mode = "Off", value = 2, overlay = "Normal", tip = "Glimmer off", highlight = 0, icon = br.player.spell.holyShock},
        [3] = {mode = "Tank", value = 3, overlay = "Normal", tip = "Glimmer on tank", highlight = 0, icon = 278573}
    }
    CreateButton("Glimmer", 5, 0)
    -- DPS
    DPSModes = {
        [1] = {mode = "On", value = 1, overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 0, icon = br.player.spell.judgment},
        [2] = {mode = "Off", value = 2, overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.judgment},
        [3] = {mode = "Max", value = 3, overlay = "DPS Burst", tip = "DPS MAX", highlight = 0, icon = br.player.spell.avengingWrath}
    }
    CreateButton("DPS", 6, 0)
    -- Beacon
    BeaconModes = {
        [1] = {mode = "BossTarget1", value = 1, overlay = "Boss1", tip = "BossTarget1", highlight = 0, icon = br.player.spell.beaconOfLight},
        [2] = {mode = "BossTarget2", value = 2, overlay = "Boss2", tip = "BossTarget2", highlight = 0, icon = br.player.spell.beaconOfLight},
        [3] = {mode = "BossTarget3", value = 3, overlay = "Boss3", tip = "BossTarget3", highlight = 0, icon = br.player.spell.beaconOfLight},
        [4] = {mode = "Off", value = 4, overlay = "Off", tip = "Off", highlight = 0, icon = br.player.spell.beaconOfLight}
    }
    CreateButton("Beacon", 7, 0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        ----------------------
        --[[         section = br.ui:createSection(br.ui.window.profile, "Visions Helpers")
        br.ui:createCheckbox(section,"Potions Tracker")
        br.ui:createCheckbox(section,"Chest Tracker")
        br.ui:createScrollingEditBox(section,"Custom Tracker", "", "Type custom search", 300, 40)
        br.ui:createCheckbox(section,"Draw Lines to Tracked Objects")
        br.ui:checkSectionState(section) ]]
        -- Trinkets
        section = br.ui:createSection(br.ui.window.profile, "Trinkets")
        --br.ui:createCheckbox(section,"glimmer debug")
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 1 Mode", {"|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround", "|cffFFFFFFDPS-Target"}, 1, "", "")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 2 Mode", {"|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround", "|cffFFFFFFDPS-Target"}, 1, "", "")
        -- br.ui:createCheckbox(section, "Advanced Trinket Support")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.002")
        -- Blessing of Freedom
        br.ui:createCheckbox(section, "Blessing of Freedom")
        br.ui:createCheckbox(section, "Blessing of Freedom Shadhar")
        br.ui:createCheckbox(section, "Blessing of Freedom Wrathion")
        br.ui:createSpinnerWithout(section, "Movement Stacks", 30, 0, 50, 5)

        if br.player.race == "BloodElf" then
            br.ui:createSpinner(section, "Arcane Torrent Dispel", 1, 0, 20, 1, "", "|cffFFFFFFMinimum Torrent Targets")
            br.ui:createSpinner(section, "Arcane Torrent Mana", 30, 0, 95, 1, "", "|cffFFFFFFMinimum When to use for mana")
        end
        if br.player.race == "LightforgedDraenei" then
            --lightsJudgment
            br.ui:createSpinner(section, "Light's Judgment", 1, 0, 20, 1, "", "Minimum Judgement Targets")
        end

        br.ui:createCheckbox(section, "Mass Rez")
        -- Critical
        br.ui:createSpinner(section, "Critical HP", 30, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Critical Heals")
        -- Overhealing Cancel
        br.ui:createSpinner(section, "Overhealing Cancel", 99, 0, 100, 1, "", "|cffFFFFFFSet Desired Threshold at which you want to prevent your own casts")
        br.ui:createCheckbox(section, "OOC Healing", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.", 1)

        br.ui:checkSectionState(section)
        -- Raid
        section = br.ui:createSection(br.ui.window.profile, "Raid")
        -- Mastery bonus
        br.ui:createCheckbox(section, "Mastery bonus", "|cff15FF00Give priority to the nearest player...(Only Raid)")
        -- Pre-Pull Timer
        br.ui:createSpinner(section, "Pre-Pull Timer", 5, 0, 20, 1, "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "M+ Settings")
        -- m+ Rot
        br.ui:createSpinner(section, "Necrotic Rot", 40, 0, 100, 1, "", "|cffFFFFFFNecrotic Rot Stacks does not healing the unit", true)
        --br.ui:createSpinner(section, "Reaping", 20, 0, 100, 1, "", "|cffFFFFFFReap Stacks Before Cleanse", true)
        br.ui:createCheckbox(section, "Grievous Wounds", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFGrievousWound|cffFFBB00.", 1)
        br.ui:createSpinner(section, "Bursting", 1, 0, 10, 3, "", "|cffFFFFFFBurst Targets")
        br.ui:createCheckbox(section, "Siege - Choking Waters", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFBubble from choking water|cffFFBB00.", 1)
        br.ui:createCheckbox(section, "Freehold - pig", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFCatches pig in Freehold|cffFFBB00.", 1)
        br.ui:createCheckbox(section, "Freehold - Blackout Barrel", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFBubble blacout barrel|cffFFBB00.", 1)
        br.ui:createCheckbox(section, "Atal - Devour", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFBubble Devour target|cffFFBB00.", 1)
        br.ui:createCheckbox(section, "Motherload - Stun jockeys", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFStun ...jockeys ... |cffFFBB00.", 1)
        br.ui:createCheckbox(section, "Tol Dagor - Deadeye", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFBubble Deadeye target|cffFFBB00.", 1)
        br.ui:createCheckbox(section, "Waycrest - jagged Nettles", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFBubble Nettles target|cffFFBB00.", 1)
        br.ui:createCheckbox(section, "Shrine - Dispel Whisper of Power", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFto dispel or not :)|cffFFBB00.", 0)
        br.ui:createCheckbox(section, "Dont DPS spotter", "wont DPS spotter", 1)

        br.ui:createSpinner(section, "Auto Drink", 45, 0, 100, 5, "Mana Percent to Drink At")
        br.ui:createCheckbox(section, "Sugar Crusted Fish Feast", "Use feasts for mana?")
        br.ui:checkSectionState(section)
        -------------------------
        ------ DEFENSIVES -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Pot/Stone
        br.ui:createSpinner(section, "Pot/Stoned", 30, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createCheckbox(section, "Crackling Tourmaline", "Use buff gem from crown", 0)
        br.ui:createCheckbox(section, "Use Sapphire of Brilliance", "Use buff gem from crown", 0)

        br.ui:createSpinner(section, "Divine Protection", 60, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Divine Shield", 20, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        -- Gift of The Naaru
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of The Naaru", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        end
        br.ui:createSpinner(section, "Engineering Belt", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        ------ Keys -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Keys")
        -- Divine Shield + Aura of Sacrifice
        br.ui:createDropdown(section, "Divine Shield + Aura of Sacrifice Key", br.dropOptions.Toggle, 6, "", "|cffFFFFFFDivine Shield + Aura of Sacrifice usage.")
        -- Divine Shield + Hand Of Reckoning
        br.ui:createDropdown(section, "Divine Shield + Hand Of Reckoning Key", br.dropOptions.Toggle, 6, "", "|cffFFFFFFDivine Shield + Hand Of Reckoning usage.")
        -- Unstable Temporal Time Shifter
        br.ui:createDropdown(section, "Unstable Temporal Time Shifter", {"|cff00FF00Target", "|cffFF0000Mouseover", "|cffFFBB00Auto"}, 1, "", "|cffFFFFFFTarget to cast on")
        -- Repentance
        br.ui:createDropdown(section, "Repentance Key", br.dropOptions.Toggle, 6, "", "|cffFFFFFFRepentance Key")
        br.ui:createDropdown(section, "Hard DPS Key", br.dropOptions.Toggle, 6, "", "Ignore all Healing while key is held.")
        br.ui:checkSectionState(section)
        --------------------------
        --- CORRUPTION OPTIONS ---
        --------------------------
        section = br.ui:createSection(br.ui.window.profile, "Corruption Management")
        br.ui:createCheckbox(section, "Corruption Radar On")
        br.ui:createCheckbox(section, "Use Hammer of Justice on TFTB")
        br.ui:createCheckbox(section, "Use Blinding Light on TFTB")
        br.ui:createCheckbox(section, "Use Blessing of Freedom for Snare")
        br.ui:createDropdownWithout(section, "Use Cloak", {"snare", "Eye", "THING", "Never"}, 4, "", "")
        br.ui:createSpinnerWithout(section, "Eye Of Corruption Stacks - Cloak", 1, 0, 20, 1)
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        --Hammer of Justice
        br.ui:createCheckbox(section, "Hammer of Justice")
        -- Blinding Light
        br.ui:createCheckbox(section, "Blinding Light")
        br.ui:createCheckbox(section, "Repentance as Interrupt")
        br.ui:createCheckbox(section, "organic grenade as int")

        -- Interrupt Percentage
        br.ui:createSpinner(section, "InterruptAt", 95, 0, 95, 5, "", "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        ------ COOL  DOWNS ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cool Downs")
        br.ui:createCheckbox(section, "Crackling Tourmaline", "Use buff gem from crown", 0)
        br.ui:createCheckbox(section, "Use Sapphire of Brilliance", "Use buff gem from crown", 0)

        -- Lay on Hand
        br.ui:createSpinner(section, "Lay on Hands - min", 20, 0, 100, 5, "", "|cffFFFFFFMin Health Percent to Cast At")
        br.ui:createSpinner(section, "Lay on Hands - max", 20, 0, 100, 5, "", "|cffFFFFFFMax Health Percent to Cast At", true)
        br.ui:createDropdownWithout(section, "Lay on Hands Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFSelf", "|cffFFFFFFHealer/DPS"}, 1, "|cffFFFFFFTarget for LoH")
        -- Blessing of Protection
        br.ui:createSpinner(section, "Blessing of Protection", 20, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "BoP Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFHealer/Damage", "|cffFFFFFFSelf"}, 3, "|cffFFFFFFTarget for BoP")
        -- Blessing of Sacrifice
        br.ui:createSpinner(section, "Blessing of Sacrifice", 40, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "BoS Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFDamage"}, 2, "|cffFFFFFFTarget for BoS")
        -- Avenging Wrath/Crusader
        br.ui:createSpinner(section, "Avenging Crusader", 50, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Avenging Crusader Targets", 4, 0, 40, 1, "", "|cffFFFFFFMinimum Avenging Wrath Targets", true)
        br.ui:createSpinner(section, "Avenging Crusader Targets", 4, 0, 40, 1, "", "|cffFFFFFFMinimum Avenging Wrath Targets", true)
        br.ui:createSpinner(section, "Avenging Wrath", 50, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Avenging Wrath Targets", 4, 0, 40, 1, "", "|cffFFFFFFMinimum Avenging Wrath Targets", true)

        -- Holy Avenger
        br.ui:createSpinner(section, "Holy Avenger", 60, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Holy Avenger Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Holy Avenger Targets", true)
        br.ui:createCheckbox(section, "Group Avenger w/ Wrath")

        -- Aura Mastery
        br.ui:createSpinner(section, "Aura Mastery", 50, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Aura Mastery Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Aura Mastery Targets", true)
        br.ui:checkSectionState(section)

        -- Essences
        --"Memory of Lucid Dreams"
        section = br.ui:createSection(br.ui.window.profile, "Essences")
        br.ui:createSpinner(section, "ConcentratedFlame - Heal", 50, 0, 100, 5, "", "health to heal at")
        br.ui:createCheckbox(section, "ConcentratedFlame - DPS")
        br.ui:createSpinner(section, "Memory of Lucid Dreams", 50, 0, 100, 5, "", "mana to pop it at")
        br.ui:createDropdown(section, "Ever Rising Tide", {"Always", "Pair with CDs", "Based on health"}, 1, "When to use this essence")
        br.ui:createSpinner(section, "Ever Rising Tide - Mana", 30, 0, 100, 5, "", "min mana to use")
        br.ui:createSpinner(section, "Ever Rising Tide - Health", 30, 0, 100, 5, "", "health threshold to pop at")
        br.ui:createSpinner(section, "Well of Existence  - Health", 30, 0, 100, 5, "", "health threshold to pop at")
        br.ui:createSpinner(section, "Seed of Eonar", 80, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Seed of Eonar Targets", 3, 0, 40, 1, "Minimum hurting friends")
        br.ui:checkSectionState(section)

        -------------------------
        ---- SINGLE TARGET ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
        --Flash of Light
        br.ui:createSpinner(section, "Flash of Light", 70, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "FoL Tanks", 70, 0, 100, 5, "", "|cffFFFFFFTanks Health Percent to Cast At", true)
        br.ui:createSpinner(section, "FoL Infuse", 70, 0, 100, 5, "", "|cffFFFFFFIn Infuse buff Health Percent to Cast At", true)
        --Holy Light
        br.ui:createSpinner(section, "Holy Light", 85, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "Holy Light Infuse", {"|cffFFFFFFNormal", "|cffFFFFFFOnly Infuse"}, 2, "|cffFFFFFFOnly Use Infusion Procs.")
        --Holy Shock
        br.ui:createSpinner(section, "Holy Shock", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Self Shock", 35, 0, 100, 5, "")
        --Word of Glory
        br.ui:createSpinner(section, "Word of Glory", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        --Bestow Faith
        br.ui:createSpinner(section, "Bestow Faith", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "Bestow Faith Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFSelf", "|cffFFFFFFSelf+LotM"}, 4, "|cffFFFFFFTarget for BF")
        -- Light of the Martyr
        br.ui:createSpinner(section, "Light of the Martyr", 40, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Moving LotM", 80, 0, 100, 5, "", "|cffFFFFFFisMoving Health Percent to Cast At")
        br.ui:createSpinner(section, "LoM after FoL", 60, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "LoM after FoL Target", {"|cffFFFFFFTanks", "|cffFFFFFFAll"}, 1, "|cffFFFFFFTarget for LoM after FoL")
        br.ui:createSpinner(section, "LotM player HP limit", 50, 0, 100, 5, "", "|cffFFFFFFLight of the Martyr Self HP limit", true)
        br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
        -- Rule of Law
        br.ui:createSpinner(section, "Rule of Law", 70, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "RoL Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum RoL Targets", true)
        br.ui:createCheckbox(section, "Judgment heal")
        -- Light of Dawn
        br.ui:createSpinner(section, "Light of Dawn", 90, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "LoD Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum LoD Targets", true)
        -- Beacon of Virtue
        br.ui:createSpinner(section, "Beacon of Virtue", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "BoV Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum BoV Targets", true)
        -- Holy Prism
        br.ui:createSpinner(section, "Holy Prism", 90, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Holy Prism Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Holy Prism Targets", true)
        -- Light's Hammer
        br.ui:createSpinner(section, "Light's Hammer", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Light's Hammer Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Light's Hammer Targets", true)
        br.ui:createDropdown(section, "Light's Hammer Key", br.dropOptions.Toggle, 6, "", "|cffFFFFFFLight's Hammer usage.")
        br.ui:checkSectionState(section)
        -------------------------
        ---------- DPS ----------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "DPS")
        br.ui:createCheckbox(section, "Auto Focus target")
        br.ui:createSpinner(section, "DPS Health", 70, 0, 100, 5, "", "|cffFFFFFFMinimum Health to DPS")
        br.ui:createSpinner(section, "DPS Mana", 70, 0, 100, 5, "", "|cffFFFFFFMinimum Mana % to DPS")
        -- Consecration
        br.ui:createSpinner(section, "Consecration", 1, 0, 40, 1, "", "|cffFFFFFFMinimum Consecration Targets")
        -- Holy Prism
        br.ui:createSpinner(section, "Holy Prism Damage", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Holy Prism Targets")
        -- Light's Hammer
        br.ui:createSpinner(section, "Light's Hammer Damage", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Light's Hammer Targets")
        -- Judgment
        br.ui:createCheckbox(section, "Judgment - DPS")
        -- Hammer of Wrath
        br.ui:createCheckbox(section, "Hammer of Wrath")
        -- Holy Shock
        br.ui:createCheckbox(section, "Holy Shock Damage")
        br.ui:createCheckbox(section, "Aggressive Glimmer", "tries to keep one glimmer on target")
        -- Shield of the Righteous
        br.ui:createSpinner(section, "Shield of the Righteous", 1, 0, 40, 1, "", "|cffFFFFFFMinimum Shield of the Righteous Targets")
        -- Crusader Strike
        br.ui:createCheckbox(section, "Crusader Strike")
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end

local stopCastingList = {
    [257732] = "Shattering Bellow",
    [266106] = "Sonic Screech",
    [267257] = "Thundering Crash"
}

local function shouldStopCast()
    local castStartTime, castEndTime, castTime

    for k, v in pairs(br.enemy) do
        local castReturn = {UnitCastingInfo(k)}
        if castReturn[5] and stopCastingList[castReturn[9]] then
            --Get spell cast time
            if castEndTime == nil or castReturn[5] < castEndTime then
                castEndTime = castReturn[5]
            end
        end
    end

    if castEndTime == nil or (castTime and castTime == 0) then
        return false
    end

    if (UnitChannelInfo("player") or UnitCastingInfo("player")) and ((castEndTime / 1000) - br.time) < 0.3 then
        SpellStopCasting()
        return true
    end

    return false
end
local queenBuff = false
local function noDamageCheck(unit)
    if isChecked("Dont DPS spotter") and GetObjectID(unit) == 135263 then
        return true
    end
    --[[
    if inInstance and UnitBuffID(unit, 290026) then
        if not queenBuff and IsSpellInRange(GetSpellInfo(spell.crusaderStrike), unit) == 1 then
            queenBuff = true
        end
        return true
    end
    ]]
    if inInstance and isCasting(302415, unit) then
        return true
    end
    return false
end

----------------
--- ROTATION ---
----------------

local function runRotation()
    -- if br.timer:useTimer("debugHoly", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
    --Print("Running: "..rotationName)

    ---------------
    --- Toggles --- -- List toggles here in order to update when pressed
    ---------------
    UpdateToggle("Rotation", 0.25)
    UpdateToggle("Cooldown", 0.25)
    UpdateToggle("Defensive", 0.25)
    UpdateToggle("Interrupt", 0.25)
    UpdateToggle("Cleanse", 0.25)
    br.player.ui.mode.cleanse = br.data.settings[br.selectedSpec].toggles["Cleanse"]
    br.player.ui.mode.Glimmer = br.data.settings[br.selectedSpec].toggles["Glimmer"]
    br.player.ui.mode.DPS = br.data.settings[br.selectedSpec].toggles["DPS"]
    br.player.ui.mode.Beacon = br.data.settings[br.selectedSpec].toggles["Beacon"]
    --------------
    --- Locals ---
    --------------
    --------------
    -- local artifact                                      = br.player.artifact
    -- local combatTime                                    = getCombatTime()
    -- local cd                                            = br.player.cd
    -- local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
    -- local healPot                                       = getHealthPot()
    -- local level                                         = br.player.level
    local holyPower = br.player.power.holyPower.amount()
    local holyPowerMax = br.player.power.holyPower.max()
    -- local lowestHP                                      = br.friend[1].unit
    -- local lowest                                        = br.friend[1]
    local mana = getMana("player")
    -- local perk                                          = br.player.perk
    -- local power, powmax, powgen                         = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
    -- local ttm                                           = br.player.power.mana.ttm()
    --------------
    -- Player
    --------------
    local buff = br.player.buff
    local cast = br.player.cast
    local php = br.player.health
    local spell = br.player.spell
    local talent = br.player.talent
    local essence = br.player.essence
    local gcd = (((br.player.gcdMax + br.player.gcd) / 2) * 0.9)
    local charges = br.player.charges
    local cd = br.player.cd
    local debuff = br.player.debuff
    local drinking = getBuffRemain("player", 192002) ~= 0 or getBuffRemain("player", 167152) ~= 0 or getBuffRemain("player", 192001) ~= 0
    local resable = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") and UnitInRange("target")
    local inCombat = isInCombat("player")
    local inInstance = br.player.instance == "party" or br.player.instance == "scenario"
    local inRaid = br.player.instance == "raid"
    local solo = #br.friend == 1
    local OWGroup = br.player.instance == "none" and #br.friend >= 2
    local race = br.player.race
    local racial = br.player.getRacial()
    local traits = br.player.traits
    local moving = isMoving("player")
    local BleedFriend = nil
    local BleedFriendCount = 0
    local BleedStack = 0
    local clumsy_counter_to_fix_bliz_bug = 0

    -------------
    -- Raid
    ------------

    local tanks = getTanksTable()
    local lowest = br.friend[1]
    local friends = friends or {}
    local glimmerCount = 0
    -------------
    -- Enemies
    -------------
    local enemies = br.player.enemies
    local lastSpell = lastSpellCast
    local mode = br.player.ui.mode
    local pullTimer = br.DBM:getPulltimer()
    local units = br.player.units
    local LightCount = 0
    local FaithCount = 0

    if traits.breakingDawn.active then
        lightOfDawn_distance = 40
    else
        lightOfDawn_distance = 15
    end
    if buff.ruleOfLaw.exists("player") then
        lightOfDawn_distance_coff = 1.5
        master_coff = 1.5
    else
        lightOfDawn_distance_coff = 1
        master_coff = 1.0
    end
    if not isCastingSpell(spell.flashOfLight) then
        BOV = nil
    end
    if not isCastingSpell(spell.flashOfLight) and not isCastingSpell(spell.holyLight) then
        healing_obj = nil
    end

    for i = 1, #br.friend do
        if buff.glimmerOfLight.remain(br.friend[i].unit) > gcd then
            glimmerCount = glimmerCount + 1
        end
    end

    --if isChecked("glimmer debug") then
    --Print(glimmerCount)
    --end

    if cast.current.holyLight() and not buff.infusionOfLight.exists("player") and getOptionValue("Holy Light Infuse") == 2 then
        SpellStopCasting()
    end
    --[[ if br.timer:useTimer("Tracker Lag", 0.05) then
        LibDraw.clearCanvas()
        for i = 1, GetObjectCountBR() do
            local object = GetObjectWithIndex(i)
            local name = ObjectName(object)
            if isChecked("Chest Tracker") then
                if string.match(strupper(name),strupper("cache")) or string.match(strupper(name),strupper("chest")) then
                    local xOb, yOb, zOb = ObjectPosition(object)
                    local pX,pY,pZ = ObjectPosition("player")
                    if xOb ~= nil and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) <200 then
                        --LibDraw.Circle(xOb,yOb,zOb, 2)
                        --LibDraw.Text(name,"GameFontNormal",xOb,yOb,zOb+3)
                        if isChecked("Draw Lines to Tracked Objects") then 
                            LibDraw.Line(pX,pY,pZ,xOb,yOb,zOb)
                        end
                    end
                end
            end

            if isChecked("Potions Tracker") then
                if string.match(strupper(name),strupper("vial")) then
                    local xOb, yOb, zOb = ObjectPosition(object)
                    local pX,pY,pZ = ObjectPosition("player")
                    if xOb ~= nil and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) <200 then
                        --LibDraw.Circle(xOb,yOb,zOb, 1)
                        --LibDraw.Text(name,"GameFontNormal",xOb,yOb,zOb+3)
                        if isChecked("Draw Lines to Tracked Objects") then 
                            LibDraw.Line(pX,pY,pZ,xOb,yOb,zOb)
                        end
                    end
                end
            end

            if isChecked("Custom Tracker") then
                if getDistance(object) < 100 and getOptionValue("Custom Tracker") ~= "" and string.len(getOptionValue("Custom Tracker")) >= 3 and string.match(strupper(name),strupper(getOptionValue("Custom Tracker"))) and not string.match(strupper(name),strupper("chang")) then
                    local xOb, yOb, zOb = ObjectPosition(object)
                    local pX,pY,pZ = ObjectPosition("player")
                    if xOb ~= nil and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) <200 then
                        --LibDraw.Circle(xOb,yOb,zOb, 1)
                        LibDraw.Text(name,"GameFontNormal",xOb,yOb,zOb+3)
                        if isChecked("Draw Lines to Tracked Objects") then 
                            LibDraw.Line(pX,pY,pZ,xOb,yOb,zOb)
                        end
                    end
                end
            end
        end
    end ]]
    units.get(5)
    units.get(8)
    units.get(15)
    units.get(30)
    units.get(40)
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    enemies.get(15)
    enemies.get(30)
    enemies.get(40)
    friends.yards40 = getAllies("player", 40 * master_coff)

    if timersTable then
        wipe(timersTable)
    end

    local CC_CreatureTypeList = {"Humanoid", "Demon", "Undead", "Dragonkin", "Giant"}
    local StunsBlackList = {
        -- Atal'Dazar
        [87318] = "Dazar'ai Colossus",
        [122984] = "Dazar'ai Colossus",
        [128455] = "T'lonja",
        [129553] = "Dinomancer Kish'o",
        [129552] = "Monzumi",
        -- Freehold
        [129602] = "Irontide Enforcer",
        [130400] = "Irontide Crusher",
        -- King's Rest
        [133935] = "Animated Guardian",
        [134174] = "Shadow-Borne Witch Doctor",
        [134158] = "Shadow-Borne Champion",
        [137474] = "King Timalji",
        [137478] = "Queen Wasi",
        [137486] = "Queen Patlaa",
        [137487] = "Skeletal Hunting Raptor",
        [134251] = "Seneschal M'bara",
        [134331] = "King Rahu'ai",
        [137484] = "King A'akul",
        [134739] = "Purification Construct",
        [137969] = "Interment Construct",
        [135231] = "Spectral Brute",
        [138489] = "Shadow of Zul",
        -- Shrine of the Storm
        [134144] = "Living Current",
        [136214] = "Windspeaker Heldis",
        [134150] = "Runecarver Sorn",
        [136249] = "Guardian Elemental",
        [134417] = "Deepsea Ritualist",
        [136353] = "Colossal Tentacle",
        [136295] = "Sunken Denizen",
        [136297] = "Forgotten Denizen",
        -- Siege of Boralus
        [129369] = "Irontide Raider",
        [129373] = "Dockhound Packmaster",
        [128969] = "Ashvane Commander",
        [138255] = "Ashvane Spotter",
        [138465] = "Ashvane Cannoneer",
        [135245] = "Bilge Rat Demolisher",
        -- Temple of Sethraliss
        [134991] = "Sandfury Stonefist",
        [139422] = "Scaled Krolusk Tamer",
        [136076] = "Agitated Nimbus",
        [134691] = "Static-charged Dervish",
        [139110] = "Spark Channeler",
        [136250] = "Hoodoo Hexer",
        [139946] = "Heart Guardian",
        -- MOTHERLODE!!
        [130485] = "Mechanized Peacekeeper",
        [136139] = "Mechanized Peacekeeper",
        [136643] = "Azerite Extractor",
        [134012] = "Taskmaster Askari",
        [133430] = "Venture Co. Mastermind",
        [133463] = "Venture Co. War Machine",
        [133436] = "Venture Co. Skyscorcher",
        [133482] = "Crawler Mine",
        -- Underrot
        [131436] = "Chosen Blood Matron",
        [133912] = "Bloodsworn Defiler",
        [138281] = "Faceless Corruptor",
        -- Tol Dagor
        [130025] = "Irontide Thug",
        -- Waycrest Manor
        [131677] = "Heartsbane Runeweaver",
        [135329] = "Matron Bryndle",
        [131812] = "Heartsbane Soulcharmer",
        [131670] = "Heartsbane Vinetwister",
        [135365] = "Matron Alma"
    }
    local HOJ_unitList = {
        [131009] = "Spirit of Gold",
        [134388] = "A Knot of Snakes",
        [129758] = "Irontide Grenadier"
    }

    ---functions
    if lodFaced ~= nil and lodFaced then
        FaceDirection(ObjectFacing("player"), true)
        lodFaced = false
    end

    local function bestConeHeal(spell, minUnits, health, angle, rangeInfront, rangeAround)
        if not isKnown(spell) or getSpellCD(spell) ~= 0 or select(2, IsUsableSpell(spell)) then
            return false
        end
        local curFacing = ObjectFacing("player")
        local playerX, playerY, playerZ = ObjectPosition("player")
        local coneTable = {}

        local unitsAround = 0
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            if br.friend[i].hp < health then
                if br.friend[i].distance < rangeAround then
                    unitsAround = unitsAround + 1
                elseif br.friend[i].distance < rangeInfront then
                    local unitX, unitY, unitZ = ObjectPosition(thisUnit)
                    if playerX and unitX then
                        local angleToUnit = rad(atan2(unitY - playerY, unitX - playerX))
                        if angleToUnit < 0 then
                            angleToUnit = rad(360 + atan2(unitY - playerY, unitX - playerX))
                        end
                        tinsert(coneTable, angleToUnit)
                    end
                end
            end
        end
        local facing, bestAngle, bestAngleUnitsHit = 0.1, 0, 0
        while facing <= 6.2 do
            local unitsHit = unitsAround
            for i = 1, #coneTable do
                local angleToUnit = coneTable[i]
                local angleDifference = facing > angleToUnit and facing - angleToUnit or angleToUnit - facing
                --local shortestAngle = angleDifference < math.pi and angleDifference or math.pi * 2 - angleDifference
                local finalAngle = angleDifference / math.pi * 180
                if finalAngle < angle then
                    unitsHit = unitsHit + 1
                end
            end
            if unitsHit > bestAngleUnitsHit then
                bestAngleUnitsHit = unitsHit
                bestAngle = facing
            end
            facing = facing + 0.05
        end
        if bestAngleUnitsHit >= minUnits then
            local mouselookActive = false
            if IsMouselooking() then
                mouselookActive = true
                MouselookStop()
                TurnOrActionStop()
                MoveAndSteerStop()
            end
            FaceDirection(bestAngle, true)
            CastSpellByName(GetSpellInfo(spell))
            FaceDirection(curFacing)
            if mouselookActive then
                MouselookStart()
            end
            lodFaced = true
            return true
        end
        return false
    end

    -- Beacon of Virtue
    if isChecked("Beacon of Virtue") and talent.beaconOfVirtue and cast.able.beaconOfVirtue and getSpellCD(200025) == 0 and not IsMounted() then
        for i = 1, #br.friend do
            if UnitInRange(br.friend[i].unit) then
                local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit, 30, getValue("Beacon of Virtue"), #br.friend)
                if
                    ((BOV ~= nil or BleedFriendCount >= 2) and isCastingSpell(spell.flashOfLight)) or
                        ((#lowHealthCandidates >= getValue("BoV Targets") or BleedFriendCount >= 2) and isCastingSpell(spell.flashOfLight)) or
                        (#lowHealthCandidates >= getValue("BoV Targets") and moving and cast.able.beaconOfVirtue() and getSpellCD(20473) < gcd)
                 then
                    if CastSpellByName(GetSpellInfo(200025), br.friend[i].unit) then
                        return
                    end
                end
            end
        end
    end

    --TODO Need better support for healing end boss - including LoH / Trinket option
    -- Temple of Sethraliss
    if GetObjectID("target") == 133392 and inCombat then
        if getHP("target") < 100 and getBuffRemain("target", 274148) == 0 then
            if getSpellCD(20473) == 0 then
                if CastSpellByName(GetSpellInfo(20473), "target") then
                    return true
                end
            end
            if php >= getOptionValue("LotM player HP limit") then
                if CastSpellByName(GetSpellInfo(183998), "target") then
                    return true
                end
            end
            if getSpellCD(20473) ~= 0 then
                if CastSpellByName(GetSpellInfo(19750), "target") then
                    return true
                end
            end
        end
    end
    -- Arcane Torrent
    if isChecked("Arcane Torrent Dispel") and race == "BloodElf" and getSpellCD(69179) == 0 then
        local torrentUnit = 0
        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]
            if canDispel(thisUnit, select(7, GetSpellInfo(GetSpellInfo(69179)))) then
                torrentUnit = torrentUnit + 1
                if torrentUnit >= getOptionValue("Arcane Torrent Dispel") then
                    if castSpell("player", racial, false, false, false) then
                        return true
                    end
                    break
                end
            end
        end
    end
    if isChecked("Arcane Torrent Mana") and inCombat and race == "BloodElf" and getSpellCD(69179) == 0 and mana < getOptionValue("Arcane Torrent Mana") then
        if castSpell("player", racial, false, false, false) then
            return true
        end
    end

    -- Light's Judgment
    if isChecked("Light's Judgment") and race == "LightforgedDraenei" and getSpellCD(255647) == 0 then
        if #enemies.yards40 >= getValue("Light's Judgment") then
            if cast.lightsJudgment(getBiggestUnitCluster(40, 5)) then
                return true
            end
        end
    end
    bossHelper()

    -----------------
    --- Rotations ---
    -----------------
    local function overhealingcancel()
        -- Overhealing Cancel
        if isChecked("Overhealing Cancel") and healing_obj ~= nil then
            if getHP(healing_obj) > getValue("Overhealing Cancel") and (isCastingSpell(spell.flashOfLight) or isCastingSpell(spell.holyLight)) then
                SpellStopCasting()
                healing_obj = nil
                Print("Cancel casting...")
            end
        end
    end
    local function key()
        -- Divine Shield + Aura of Sacrifice
        if isChecked("Divine Shield + Aura of Sacrifice Key") and (SpecificToggle("Divine Shield + Aura of Sacrifice Key") and not GetCurrentKeyBoardFocus()) then
            if buff.divineShield.exists() and talent.auraOfSacrifice then
                if cast.auraMastery() then
                    return true
                end
            end
            if cast.divineShield() then
                return true
            end
        end
        -- Light's Hammer
        if isChecked("Light's Hammer Key") and (SpecificToggle("Light's Hammer Key") and not GetCurrentKeyBoardFocus()) then
            CastSpellByName(GetSpellInfo(spell.lightsHammer), "cursor")
            return
        end
        -- Divine Shield + Hand Of Reckoning
        if isChecked("Divine Shield + Hand Of Reckoning Key") and (SpecificToggle("Divine Shield + Hand Of Reckoning Key") and not GetCurrentKeyBoardFocus()) then
            if buff.divineShield.exists() then
                if cast.handOfReckoning() then
                    return true
                end
            end
            if cast.divineShield() then
                return true
            end
        end
        -- Unstable Temporal Time Shifter
        if isChecked("Unstable Temporal Time Shifter") and canUseItem(158379) and not moving and inCombat then
            if getOptionValue("Unstable Temporal Time Shifter") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") then
                UseItemByName(158379, "target")
            end
            if getOptionValue("Unstable Temporal Time Shifter") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover", "player") then
                UseItemByName(158379, "mouseover")
            end
            if getOptionValue("Unstable Temporal Time Shifter") == 3 then
                for i = 1, #br.friend do
                    if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") then
                        UseItemByName(158379, br.friend[i].unit)
                    end
                end
            end
        end
        -- CC  /  Repentance
        if
            talent.repentance and isChecked("Repentance Key") and SpecificToggle("Repentance Key") and not GetCurrentKeyBoardFocus() and
                IsSpellInRange(GetSpellInfo(spell.repentance), "mouseover")
         then
            if castSpell("mouseover", spell.repentance, true, false, false, true, false, true, true, false) then
                return true
            end
        end
    end

    local function QOL()
        --crowns and gems from crowns
        --166798 --"Crackling Tourmaline"
        --166801 -- "Saphire of Brilliance"  buff 290365

        if isChecked("Crackling Tourmaline") then
            if hasItem(166798) and canUseItem(166798) and not buff.cracklingTourmaline.exists("player") then
                useItem(166798)
                return true
            end
        end
    end
    local function PrePull()
        -- Pre-Pull Timer
        if isChecked("Pre-Pull Timer") then
            if pullTimer <= getOptionValue("Pre-Pull Timer") then
                if canUseItem(142117) and not buff.prolongedPower.exists() then
                    useItem(142117)
                    return true
                end
            end
        end
    end
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Defensive ---------- Defensive ---------- Defensive ---------- Defensive ---------- Defensive ---------- Defensive ---------- Defensive --------- Defensive --------- Defensive
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function actionList_Defensive()
        if useDefensive() then
            --engineering belt / plate pants
            if isChecked("Engineering Belt") and php <= getOptionValue("Engineering Belt") and canUseItem(6) then
                useItem(6)
            end

            --Healthstone / Heathpots :  156634 == Silas Vial of Continuous curing / 5512 == warlock health stones
            if isChecked("Pot/Stoned") and php <= getValue("Pot/Stoned") and (hasHealthPot() or hasItem(5512) or hasItem(156634)) then
                if canUseItem(166799) then
                    useItem(166799)
                elseif canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(156634) then
                    useItem(156634)
                elseif canUseItem(169451) then
                    useItem(169451)
                elseif canUseItem(getHealthPot()) then
                    useItem(getHealthPot())
                elseif canUseItem(getHealthPot()) then
                    useItem(getHealthPot())
                end
            end

            -- Gift of the Naaru
            if isChecked("Gift of The Naaru") and php <= getOptionValue("Gift of The Naaru") and php > 0 and race == "Draenei" then
                if castSpell("player", racial, false, false, false) then
                    return true
                end
            end
            -- Divine Shield
            if isChecked("Divine Shield") and cast.able.divineShield() then
                if
                    (php <= getOptionValue("Divine Shield") or (isChecked("Siege - Choking Waters") and UnitDebuffID("player", 272571)) or
                        (isChecked("Atal - Devour") and UnitDebuffID("player", 255421))) and
                        not UnitDebuffID("player", 25771)
                 then
                    if cast.divineShield() then
                        return true
                    end
                end
            end
            --	Divine Protection
            if isChecked("Divine Protection") and cast.able.divineProtection() and not buff.divineShield.exists("player") then
                if php <= getOptionValue("Divine Protection") then
                    if cast.divineProtection() then
                        return true
                    end
                elseif buff.blessingOfSacrifice.exists("player") then
                    if cast.divineProtection() then
                        return true
                    end
                end
            end
            -- Blessing of Freedom
            if
                (isChecked("Blessing of Freedom") and cast.able.blessingOfFreedom() and hasNoControl(spell.blessingOfFreedom)) or
                    isChecked("Use Blessing of Freedom for Snare") and debuff.graspingTendrils.exists("player")
             then
                if cast.blessingOfFreedom("player") then
                    return true
                end
            end
            --Shroud
            if br.player.equiped.shroudOfResolve and canUseItem(br.player.items.shroudOfResolve) then
                if
                    getValue("Use Cloak") == 1 and debuff.graspingTendrils.exists("player") or
                        getValue("Use Cloak") == 2 and getDebuffStacks("player", 315161) >= getOptionValue("Eye Of Corruption Stacks - Cloak") or
                        getValue("Use Cloak") == 3 and debuff.grandDelusions.exists("player")
                 then
                    if br.player.use.shroudOfResolve() then
                        return
                    end
                end
            end
            if isChecked("Corruption Radar On") then
                local stun = "Hammer of Justice"

                for i = 1, GetObjectCountBR() do
                    local object = GetObjectWithIndex(i)
                    local ID = ObjectID(object)
                    if isChecked("Use Hammer of Justice on TFTB") then
                        if ID == 161895 then
                            local x1, y1, z1 = ObjectPosition("player")
                            local x2, y2, z2 = ObjectPosition(object)
                            local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                            if
                                distance <= 8 and isChecked("Use Blinding Light on TFTB") and cd.blindingLight.remains() <= gcd and talent.blindingLight and
                                    not debuff.hammerOfJustice.exists(object)
                             then
                                CastSpellByName("Blinding Light", object)
                                return true
                            end
                            if distance < 10 and not isLongTimeCCed(object) and cd.hammerOfJustice.remains() <= gcd and not debuff.blindingLight.exists(object) then
                                CastSpellByName(stun, object)
                                return true
                            end
                        end
                    end -- end the thing
                end
            end
        end
    end
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- CanIRess ----------- CanIRess ----------- CanIRess ----------- CanIRess ----------- CanIRess ----------- CanIRess ----------- CanIRess ----------- CanIRess -----------
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function CanIRess()
        if isChecked("Mass Rez") and not moving and resable then
            if cast.absolution("target", "dead") then
                return true
            end
        end
    end
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- BossEncounterCase ----------- BossEncounterCase ----------- BossEncounterCase ----------- BossEncounterCase ----------- BossEncounterCase ----------- BossEncounterCase -------
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function BossEncounterCase()
        local blessingOfFreedomCase = nil
        local blessingOfProtectionCase = nil
        local hammerOfJusticeCase = nil
        --Instance cases
        if inInstance then
            for i = 1, #br.friend do
                local localClass, englishClass, classIndex = UnitClass(br.friend[i].unit)
                if UnitInRange(br.friend[i].unit) then
                    if getDebuffRemain(br.friend[i].unit, 268896) ~= 0 or getDebuffRemain(br.friend[i].unit, 264526) ~= 0 or getDebuffRemain(br.friend[i].unit, 258058) ~= 0 then
                        blessingOfFreedomCase = br.friend[i].unit
                    end
                    if
                        (isChecked("Atal - Devour") and getDebuffRemain(br.friend[i].unit, 255421) ~= 0 and br.friend[i].unit ~= "player") or
                            (isChecked("Tol Dagor - Deadeye") and getDebuffRemain(br.friend[i].unit, 256038) ~= 0 and br.friend[i].unit ~= "player") or
                            (isChecked("Waycrest - jagged Nettles") and getDebuffRemain(br.friend[i].unit, 260741) ~= 0) or
                            (isChecked("Freehold - Blackout Barrel") and getDebuffRemain(br.friend[i].unit, 258875) ~= 0)
                     then
                        blessingOfProtectionCase = br.friend[i].unit
                    end
                    if UnitIsCharmed(br.friend[i].unit) and getDebuffRemain(br.friend[i].unit, 272407) == 0 and br.friend[i].distance <= 10 then
                        hammerOfJusticeCase = br.friend[i].unit
                    end
                end
            end
        end
        -- Raid Cases
        if inRaid then
            for i = 1, #br.friend do
                local localClass, englishClass, classIndex = UnitClass(br.friend[i].unit)
                local thisUnit = br.friend[i].unit
                if UnitInRange(thisUnit) then
                    if
                        (isChecked("Blessing of Freedom Shadhar")) and UnitDebuffID(thisUnit, 318078) ~= nil and
                            (classIndex == 1 or classIndex == 2 or classIndex == 4 or classIndex == 5 or classIndex == 9)
                     then
                        blessingOfFreedomCase = thisUnit
                    end
                    if (isChecked("Blessing of Freedom Wrathion")) and getDebuffStacks(thisUnit, 313255) >= getOptionValue("Movement Stacks") then
                        blessingOfFreedomCase = thisUnit
                    end
                end
            end
        end
        -- Blessing of Freedom
        if cast.able.blessingOfFreedom() then
            if getDebuffRemain("TANK", 267899) ~= 0 or getDebuffRemain("TANK", 257478) ~= 0 then
                if cast.blessingOfFreedom("TANK") then
                    return true
                end
            end
            if blessingOfFreedomCase ~= nil then
                if cast.blessingOfFreedom(blessingOfFreedomCase) then
                    return true
                end
            end
        end
        -- Blessing of Protection
        if cast.able.blessingOfProtection() then
            if blessingOfProtectionCase ~= nil then
                if cast.blessingOfProtection(blessingOfProtectionCase) then
                    return true
                end
            end
        end
        if cast.able.hammerOfJustice() then
            local HOJ_list = {
                [274400] = true,
                [274383] = true,
                [257756] = true,
                [276292] = true,
                [268273] = true,
                [256897] = true,
                [272542] = true,
                [272888] = true,
                [269266] = true,
                [258317] = true,
                [258864] = true,
                [259711] = true,
                [258917] = true,
                [264038] = true,
                [253239] = true,
                [269931] = true,
                [270084] = true,
                [270482] = true,
                [270506] = true,
                [270507] = true,
                [267433] = true,
                [267354] = true,
                [268702] = true,
                [268846] = true,
                [268865] = true,
                [258908] = true,
                [264574] = true,
                [272659] = true,
                [272655] = true,
                [267237] = true,
                [265568] = true,
                [277567] = true,
                [265540] = true
            }
            for i = 1, #enemies.yards10 do
                local thisUnit = enemies.yards10[i]
                local distance = getDistance(thisUnit)
                if
                    (HOJ_unitList[GetObjectID(thisUnit)] ~= nil or HOJ_list[select(9, UnitCastingInfo(thisUnit))] ~= nil or
                        HOJ_list[select(7, GetSpellInfo(UnitChannelInfo(thisUnit)))] ~= nil) and
                        getBuffRemain(thisUnit, 226510) == 0 and
                        distance <= 10
                 then
                    if cast.hammerOfJustice(thisUnit) then
                        return true
                    end
                end
            end
            if hammerOfJusticeCase ~= nil then
                if cast.hammerOfJustice(hammerOfJusticeCase) then
                    return true
                end
            end
        end

        if isChecked("Freehold - pig") and GetMinimapZoneText() == "Ring of Booty" then
            bossHelper()
        end
    end

    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Cleanse ----------- Cleanse ----------- Cleanse ----------- Cleanse ----------- Cleanse ----------- Cleanse ----------- Cleanse ----------- Cleanse ----------- Cleanse -------
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function Cleanse()
        -- Cleanse
        if br.player.ui.mode.cleanse == 1 and cast.able.cleanse() and not cast.last.cleanse() then
            for i = 1, #br.friend do
                --[[ DEBUG
                if getDebuffStacks(br.friend[i].unit, 288388) > 0 then
                  Print("Stacks: " ..getDebuffStacks(br.friend[i].unit, 288388) .." Threshold: " .. getValue("Reaping"))
                end]]
                -- 275014=putrid-waters, 252781= unstable-hex, 261440=virulent-pathogen, 288388=reap-soul, 282562-promises-of-power
                --[[ removing as support moved into HE system

                if inInstance and (getDebuffRemain(br.friend[i].unit, 275014) >= 2 or getDebuffRemain(br.friend[i].unit, 261440) >= 2) and #getAllies(br.friend[i].unit, 6) < 2
                        or (getDebuffStacks(br.friend[i].unit, 288388) >= getValue("Reaping") or (not inCombat and getDebuffStacks(br.friend[i].unit, 288388) > 0))
                        or (getDebuffStacks(br.friend[i].unit, 282562) >= getValue("Promise of Power") or (not inCombat and getDebuffStacks(br.friend[i].unit, 282562) > 0)) then
                  if cast.cleanse(br.friend[i].unit) then
                    return true
                  end
                end
                if (inInstance and getDebuffRemain(br.friend[i].unit, 275014) == 0 and getDebuffStacks(br.friend[i].unit, 288388) == 0 and getDebuffRemain(br.friend[i].unit, 261440) == 0 and getDebuffRemain(br.friend[i].unit, 270920) == 0)
                        or (inRaid and getDebuffRemain(br.friend[i].unit, 277498) == 0) or (inRaid and getDebuffRemain(br.friend[i].unit, 282562) == 0) or (not inInstance and not inRaid) then
                  -- stuff
                  if canDispel(br.friend[i].unit, spell.cleanse) then
                    if cast.cleanse(br.friend[i].unit) then
                      return true
                    end
                  end
                end]]
                if
                    canDispel(br.friend[i].unit, spell.cleanse) and getLineOfSight(br.friend[i].unit) and getDistance(br.friend[i].unit) <= 40 and
                        ((GetMinimapZoneText() == "Shrine of Shadows" and isChecked("Shrine - Dispel Whisper of Power")) or GetMinimapZoneText() ~= "Shrine of Shadows")
                 then
                    if cast.cleanse(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end
    end
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Interrupt --------- Interrupt --------- Interrupt --------- Interrupt --------- Interrupt --------- Interrupt --------- Interrupt --------- Interrupt --------- Interrupt -----
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function Interrupt()
        if useInterrupts() and (cast.able.blindingLight() or cast.able.hammerOfJustice()) then
            for i = 1, #enemies.yards10 do
                local thisUnit = enemies.yards10[i]
                local distance = getDistance(thisUnit)
                if
                    canInterrupt(thisUnit, getOptionValue("InterruptAt")) and distance <= 10 and StunsBlackList[GetObjectID(thisUnit)] == nil and
                        UnitCastingInfo(thisUnit) ~= GetSpellInfo(257899) and
                        UnitCastingInfo(thisUnit) ~= GetSpellInfo(258150) and
                        UnitCastingInfo(thisUnit) ~= GetSpellInfo(252923)
                 then
                    -- Blinding Light
                    if isChecked("Blinding Light") and cast.able.blindingLight() then
                        if cast.blindingLight() then
                            return true
                        end
                    end
                    -- Hammer of Justice
                    if
                        isChecked("Hammer of Justice") and cast.able.hammerOfJustice() and getBuffRemain(thisUnit, 226510) == 0 and
                            (thisUnit == 130488 and isChecked("Motherload - Stun jockeys") or thisUnit ~= 130488)
                     then
                        if cast.hammerOfJustice(thisUnit) then
                            return true
                        end
                    end
                end
            end
        end
        -- Repentance as interrupt
        if useInterrupts() and talent.repentance and cast.able.repentance() and isChecked("Repentance as Interrupt") then
            for i = 1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                if
                    canInterrupt(thisUnit, 99) and getCastTimeRemain(thisUnit) > getCastTime(spell.repentance) and StunsBlackList[GetObjectID(thisUnit)] == nil and
                        not isBoss(thisUnit) and
                        UnitCastingInfo(thisUnit) ~= GetSpellInfo(257899) and
                        UnitCastingInfo(thisUnit) ~= GetSpellInfo(258150) and
                        UnitCastingInfo(thisUnit) ~= GetSpellInfo(252923) and
                        UnitCreatureType(thisUnit) == CC_CreatureTypeList[i]
                 then
                    if cast.repentance(thisUnit) then
                        return true
                    end
                end
            end
        end
        if isChecked("organic grenade as int") and useInterrupts() and hasItem(153487) and canUseItem(153487) then
            for i = 1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                if
                    canInterrupt(thisUnit, 99) and getCastTimeRemain(thisUnit) > 1.5 and StunsBlackList[GetObjectID(thisUnit)] == nil and not isBoss(thisUnit) and
                        UnitCastingInfo(thisUnit) ~= GetSpellInfo(257899) and
                        UnitCastingInfo(thisUnit) ~= GetSpellInfo(258150) and
                        UnitCastingInfo(thisUnit) ~= GetSpellInfo(252923)
                 then
                    local currentX, currentY, currentZ = GetObjectPosition(thisUnit)
                    useItem(153487)
                    ClickPosition(currentX, currentY, currentZ)
                    return true
                end
            end
        end
    end
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Beacon ---------- Beacon ---------- Beacon ---l------- Beacon ---------- Beacon ---------- Beacon ---------- Beacon ---------- Beacon ---------- Beacon ---------- Beacon ------
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function Beacon()
        local beaconOfLightinRaid = nil
        local beaconOfLightTANK = nil
        local beaconOfFaithTANK = nil
        local beaconOfFaithplayer = nil
        LightCount = 0
        FaithCount = 0
        for i = 1, #br.friend do
            if UnitInRange(br.friend[i].unit) then
                if buff.beaconOfLight.exists(br.friend[i].unit) then
                    LightCount = LightCount + 1
                end
                if buff.beaconOfFaith.exists(br.friend[i].unit) then
                    FaithCount = FaithCount + 1
                end
            end
        end
        if mode.Beacon == 1 and (inInstance or inRaid or OWGroup) and #tanks > 0 then
            for i = 1, #br.friend do
                if UnitInRange(br.friend[i].unit) then
                    if
                        (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and GetUnitIsUnit(br.friend[i].unit, "boss1target") and
                            not buff.beaconOfLight.exists(br.friend[i].unit) and
                            not buff.beaconOfFaith.exists(br.friend[i].unit)
                     then
                        beaconOfLightinRaid = br.friend[i].unit
                    end
                    if
                        LightCount < 1 and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and
                            not buff.beaconOfFaith.exists(br.friend[i].unit)
                     then
                        beaconOfLightTANK = br.friend[i].unit
                    end
                    if
                        FaithCount < 1 and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and
                            not buff.beaconOfFaith.exists(br.friend[i].unit)
                     then
                        beaconOfFaithTANK = br.friend[i].unit
                    elseif FaithCount < 1 and not inRaid and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfFaithplayer = br.friend[i].unit
                    end
                end
            end
        end
        if mode.Beacon == 2 and (inInstance or inRaid or OWGroup) and #tanks > 0 then
            for i = 1, #br.friend do
                if UnitInRange(br.friend[i].unit) then
                    if
                        (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and GetUnitIsUnit(br.friend[i].unit, "boss2target") and
                            not buff.beaconOfLight.exists(br.friend[i].unit) and
                            not buff.beaconOfFaith.exists(br.friend[i].unit)
                     then
                        beaconOfLightinRaid = br.friend[i].unit
                    end
                    if
                        LightCount < 1 and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and
                            not buff.beaconOfFaith.exists(br.friend[i].unit)
                     then
                        beaconOfLightTANK = br.friend[i].unit
                    end
                    if
                        FaithCount < 1 and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and
                            not buff.beaconOfFaith.exists(br.friend[i].unit)
                     then
                        beaconOfFaithTANK = br.friend[i].unit
                    elseif FaithCount < 1 and not inRaid and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfFaithplayer = br.friend[i].unit
                    end
                end
            end
        end
        if mode.Beacon == 3 and (inInstance or inRaidor or OWGroup) and #tanks > 0 then
            for i = 1, #br.friend do
                if UnitInRange(br.friend[i].unit) then
                    if
                        (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and GetUnitIsUnit(br.friend[i].unit, "boss3target") and
                            not buff.beaconOfLight.exists(br.friend[i].unit) and
                            not buff.beaconOfFaith.exists(br.friend[i].unit)
                     then
                        beaconOfLightinRaid = br.friend[i].unit
                    end
                    if
                        LightCount < 1 and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and
                            not buff.beaconOfFaith.exists(br.friend[i].unit)
                     then
                        beaconOfLightTANK = br.friend[i].unit
                    end
                    if
                        FaithCount < 1 and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and
                            not buff.beaconOfFaith.exists(br.friend[i].unit)
                     then
                        beaconOfFaithTANK = br.friend[i].unit
                    elseif FaithCount < 1 and not inRaid and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfFaithplayer = br.friend[i].unit
                    end
                end
            end
        end
        if inRaid and beaconOfLightinRaid ~= nil then
            if cast.beaconOfLight(beaconOfLightinRaid) then
                return true
            end
        end
        if beaconOfLightTANK ~= nil and not cast.last.beaconOfLight() then
            if cast.beaconOfLight(beaconOfLightTANK) then
                return true
            end
        end
        if talent.beaconOfFaith then
            if beaconOfFaithTANK ~= nil then
                if cast.beaconOfFaith(beaconOfFaithTANK) then
                    return true
                end
            end
            if beaconOfFaithplayer ~= nil then
                if cast.beaconOfFaith(beaconOfFaithplayer) then
                    return true
                end
            end
        end
    end
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --Cooldowns ------- Cooldowns -------Cooldowns ------- Cooldowns ------- Cooldowns ------- Cooldowns ------- Cooldowns ------- Cooldowns ------- Cooldowns ------- Cooldowns -----
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function Cooldowns()
        local blessingOfProtectionall = nil
        local blessingOfProtectionTANK = nil
        local blessingOfProtectionHD = nil
        local blessingOfSacrificeall = nil
        local blessingOfSacrificeTANK = nil
        local blessingOfSacrificeDAMAGER = nil
        local layOnHandsTarget = nil
        local burst = nil

        --Essences
        --Concentrated Flame

        -- Concentrated Flame Heal
        if essence.concentratedFlame.active and getSpellCD(295373) <= gcd then
            if isChecked("ConcentratedFlame - Heal") and lowest.hp <= getValue("ConcentratedFlame - Heal") and getLineOfSight(lowest.unit) and getDistance(lowest.unit) <= 40 then
                if cast.concentratedFlame(lowest.unit) then
                    return true
                end
            end
            if isChecked("ConcentratedFlame - DPS") and getTTD("target") > 3 and getLineOfSight("target") and getDistance("target") <= 40 then
                if cast.concentratedFlame("target") then
                    return true
                end
            end
        end
        --lucid dreams
        if isChecked("Memory of Lucid Dreams") and getSpellCD(298357) <= gcd and mana <= getValue("Memory of Lucid Dreams") then
            if cast.memoryOfLucidDreams() then
                return
            end
        end
        -- the ever rising ride
        --overchargeMana

        if isChecked("Ever Rising Tide") and essence.overchargeMana.active and getSpellCD(296072) <= gcd then
            if getOptionValue("Ever Rising Tide") == 1 then
                if cast.overchargeMana() then
                    return
                end
            end

            if getOptionValue("Ever Rising Tide") == 2 then
                if (buff.avengingWrath.exists() and mode.DPS ~= 3) or buff.avengingCrusader.exists() or buff.holyAvenger.exists() or buff.auraMastery.exists() or burst == true then
                    if cast.overchargeMana() then
                        return
                    end
                end
            end
            if getOptionValue("Ever Rising Tide") == 3 then
                if lowest.hp < getOptionValue("Ever Rising Tide - Health") or burst == true then
                    if cast.overchargeMana() then
                        return
                    end
                end
            end
        end

        --"Well of Existence  - Health"
        if isChecked("Well of Existence  - Health") and essence.refreshment.active and getSpellCD(296197) <= gcd then
            if lowest.hp < getOptionValue("Well of Existence  - Health") or burst == true then
                if cast.refreshment(lowest.unit) then
                    return true
                end
            end
        end
        --Seed of Eonar
        if isChecked("Seed of Eonar") and essence.lifeBindersInvocation.active and cast.able.lifeBindersInvocation and not moving then
            for i = 1, #br.friend do
                if UnitInRange(br.friend[i].unit) then
                    local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit, 30, getValue("Seed of Eonar"), #br.friend)
                    if #lowHealthCandidates >= getValue("Seed of Eonar Targets") and not moving or burst == true then
                        if cast.lifeBindersInvocation() then
                            return true
                        end
                    end
                end
            end
        end
        if isChecked("Group Avenger w/ Wrath") then
            if
                cast.able.holyAvenger() and (buff.avengingWrath.exists() or buff.avengingCrusader.exists()) and
                    ((buff.avengingWrath.remain() > 12 and buff.avengingWrath.remain() < 17) or (buff.avengingCrusader.remain() > 12 and buff.avengingCrusader.remain() < 19))
             then
                if cast.holyAvenger() then
                    br.addonDebug("Grouping HA w/wings - Wings remain:" .. buff.avengingWrath.remain())
                    return true
                end
            end
        end

        --stat gem from crown
        if isChecked("Use Sapphire of Brilliance") then
            if hasItem(166801) and canUseItem(166801) and not buff.saphireofBrilliance.exists("player") then
                useItem(166801)
                return true
            end
        end

        --Bursting
        --Print("Check" ..isChecked("Bursting").."#: "..getOptionValue("Bursting"))
        if isChecked("Bursting") and inInstance and #tanks > 0 then
            local ourtank = tanks[1].unit
            local Burststack = getDebuffStacks(ourtank, 240443)
            if Burststack >= getOptionValue("Bursting") then
                burst = true
            end
        end

        --BoP
        for i = 1, #br.friend do
            if br.friend[i].hp < 100 and UnitInRange(br.friend[i].unit) and not UnitDebuffID(br.friend[i].unit, 25771) then
                if br.friend[i].hp <= getValue("Blessing of Protection") then
                    blessingOfProtectionall = br.friend[i].unit
                end
                if br.friend[i].hp <= getValue("Blessing of Protection") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
                    blessingOfProtectionTANK = br.friend[i].unit
                end
                if
                    br.friend[i].hp <= getValue("Blessing of Protection") and
                        (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or UnitGroupRolesAssigned(br.friend[i].unit) == "DAMAGER")
                 then
                    blessingOfProtectionHD = br.friend[i].unit
                end
                if br.friend[i].hp <= getValue("Blessing of Sacrifice") and not GetUnitIsUnit(br.friend[i].unit, "player") then
                    blessingOfSacrificeall = br.friend[i].unit
                end
                if br.friend[i].hp <= getValue("Blessing of Sacrifice") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
                    blessingOfSacrificeTANK = br.friend[i].unit
                end
                if br.friend[i].hp <= getValue("Blessing of Sacrifice") and UnitGroupRolesAssigned(br.friend[i].unit) == "DAMAGER" then
                    blessingOfSacrificeDAMAGER = br.friend[i].unit
                end
            end
        end
        -- Lay on Hands        --LoH / LayonHands
        if isChecked("Lay on Hands - min") and getSpellCD(633) == 0 then
            for i = 1, #br.friend do
                if br.friend[i].hp < 100 and UnitInRange(br.friend[i].unit) and not UnitDebuffID(br.friend[i].unit, 25771) then
                    if getOptionValue("Lay on Hands Target") == 1 then
                        if
                            br.friend[i].hp <= math.random(getValue("Lay on Hands - min"), getValue("Lay on Hands - max")) and
                                (solo or OWGroup or inRaid or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
                         then
                            layOnHandsTarget = br.friend[i].unit
                        end
                    elseif getOptionValue("Lay on Hands Target") == 2 then
                        if
                            br.friend[i].hp <= math.random(getValue("Lay on Hands - min"), getValue("Lay on Hands - max")) and
                                (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and
                                (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
                         then
                            layOnHandsTarget = br.friend[i].unit
                        end
                    elseif
                        getOptionValue("Lay on Hands Target") == 3 and getDebuffRemain("player", 267037) == 0 and
                            php <= math.random(getValue("Lay on Hands - min"), getValue("Lay on Hands - max"))
                     then
                        layOnHandsTarget = "player"
                    elseif getOptionValue("Lay on Hands Target") == 4 then
                        if UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
                            if
                                br.friend[i].hp <= math.random(getValue("Lay on Hands - min"), getValue("Lay on Hands - max")) and
                                    (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
                             then
                                layOnHandsTarget = br.friend[i].unit
                            end
                        end
                    end
                    if layOnHandsTarget ~= nil then
                        if cast.layOnHands(layOnHandsTarget) then
                            return true
                        end
                    end
                end
            end
        end
        -- Blessing of Protection
        if isChecked("Blessing of Protection") and cast.able.blessingOfProtection() and not UnitExists("boss1") then
            if getOptionValue("BoP Target") == 1 then
                if blessingOfProtectionall ~= nil then
                    if cast.blessingOfProtection(blessingOfProtectionall) then
                        return true
                    end
                end
            elseif getOptionValue("BoP Target") == 2 then
                if blessingOfProtectionTANK ~= nil then
                    if cast.blessingOfProtection(blessingOfProtectionTANK) then
                        return true
                    end
                end
            elseif getOptionValue("BoP Target") == 3 then
                if blessingOfProtectionHD ~= nil then
                    if cast.blessingOfProtection(blessingOfProtectionHD) then
                        return true
                    end
                end
            elseif getOptionValue("BoP Target") == 4 then
                if php <= getValue("Blessing of Protection") then
                    if cast.blessingOfProtection("player") then
                        return true
                    end
                end
            end
        end
        -- Blessing of Sacrifice
        if isChecked("Blessing of Sacrifice") and cast.able.blessingOfSacrifice() then
            if getOptionValue("BoS Target") == 1 then
                if blessingOfSacrificeall ~= nil then
                    if cast.blessingOfSacrifice(blessingOfSacrificeall) then
                        return true
                    end
                end
            elseif getOptionValue("BoS Target") == 2 then
                if blessingOfSacrificeTANK ~= nil then
                    if cast.blessingOfSacrifice(blessingOfSacrificeTANK) then
                        return true
                    end
                end
            elseif getOptionValue("BoS Target") == 3 then
                if blessingOfSacrificeDAMAGER ~= nil then
                    if cast.blessingOfSacrifice(blessingOfSacrificeDAMAGER) then
                        return true
                    end
                end
            end
        end
        -- Trinkets
        if isChecked("Trinket 1") and canUseItem(13) then
            if getOptionValue("Trinket 1 Mode") == 1 then
                if getLowAllies(getValue("Trinket 1")) >= getValue("Min Trinket 1 Targets") then
                    useItem(13)
                    return true
                end
            elseif getOptionValue("Trinket 1 Mode") == 2 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Trinket 1") then
                        UseItemByName(select(1, GetInventoryItemID("player", 13)), br.friend[i].unit)
                        return true
                    end
                end
            elseif getOptionValue("Trinket 1 Mode") == 3 and #tanks > 0 then
                for i = 1, #tanks do
                    -- get the tank's target
                    local tankTarget = UnitTarget(tanks[i].unit)
                    if tankTarget ~= nil then
                        -- get players in melee range of tank's target
                        local meleeFriends = getAllies(tankTarget, 5)
                        -- get the best ground circle to encompass the most of them
                        local loc = nil
                        if #meleeFriends >= 8 then
                            loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                        else
                            local meleeHurt = {}
                            for j = 1, #meleeFriends do
                                if meleeFriends[j].hp < getValue("Trinket 1") then
                                    tinsert(meleeHurt, meleeFriends[j])
                                end
                            end
                            if #meleeHurt >= getValue("Min Trinket 1 Targets") or burst == true then
                                loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                            end
                        end
                        if loc ~= nil then
                            useItem(13)
                            ClickPosition(loc.x, loc.y, loc.z)
                            return true
                        end
                    end
                end
            elseif getOptionValue("Trinket 1 Mode") == 4 then
                if canUseItem(13) and (getTTD(units.dyn40) < 5 and useCDs()) then
                    UseItemByName(select(1, GetInventoryItemID("player", 13)), units.dyn40)
                    return true
                end
            end
        end

        if isChecked("Trinket 2") and canUseItem(14) then
            if getOptionValue("Trinket 2 Mode") == 1 then
                if getLowAllies(getValue("Trinket 2")) >= getValue("Min Trinket 2 Targets") then
                    useItem(14)
                    return true
                end
            elseif getOptionValue("Trinket 2 Mode") == 2 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Trinket 2") then
                        UseItemByName(select(1, GetInventoryItemID("player", 14)), br.friend[i].unit)
                        return true
                    end
                end
            elseif getOptionValue("Trinket 2 Mode") == 3 and #tanks > 0 then
                for i = 1, #tanks do
                    -- get the tank's target
                    local tankTarget = UnitTarget(tanks[i].unit)
                    if tankTarget ~= nil then
                        -- get players in melee range of tank's target
                        local meleeFriends = getAllies(tankTarget, 5)
                        -- get the best ground circle to encompass the most of them
                        local loc = nil
                        if #meleeFriends >= 8 then
                            loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                        else
                            local meleeHurt = {}
                            for j = 1, #meleeFriends do
                                if meleeFriends[j].hp < getValue("Trinket 2") then
                                    tinsert(meleeHurt, meleeFriends[j])
                                end
                            end
                            if #meleeHurt >= getValue("Min Trinket 2 Targets") or burst == true then
                                loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                            end
                        end
                        if loc ~= nil then
                            useItem(14)
                            ClickPosition(loc.x, loc.y, loc.z)
                            return true
                        end
                    end
                end
            elseif getOptionValue("Trinket 1 Mode") == 4 then
                if canUseItem(14) and (getTTD(units.dyn40) < 5 and useCDs()) then
                    UseItemByName(select(1, GetInventoryItemID("player", 14)), units.dyn40)
                    return true
                end
            end
        end

        if isChecked("Advanced Trinket Support") then
            --special trinket support - under development
            local Trinket13 = GetInventoryItemID("player", 13)
            local Trinket14 = GetInventoryItemID("player", 14)

            --Balefire Branch(159630)
            if (Trinket13 == 159630 or Trinket14 == 159630) and GetItemCooldown(159630) == 0 then
                if getLowAllies(75) > 3 or (#tanks > 0 and tanks[1].hp <= 40) or lowest.hp <= 40 then
                    useItem(159630)
                end
            end
            -- Ward of Envelopment(165569)
            if (Trinket13 == 165569 or Trinket14 == 165569) and GetItemCooldown(165569) == 0 then
                -- get melee players
                for i = 1, #tanks do
                    -- get the tank's target
                    local tankTarget = UnitTarget(tanks[i].unit)
                    if tankTarget ~= nil then
                        -- get players in melee range of tank's target
                        local meleeFriends = getAllies(tankTarget, 5)
                        -- get the best ground circle to encompass the most of them
                        local loc = nil
                        if #meleeFriends >= 8 then
                            loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                        else
                            local meleeHurt = {}
                            for j = 1, #meleeFriends do
                                if meleeFriends[j].hp < 75 then
                                    tinsert(meleeHurt, meleeFriends[j])
                                end
                            end
                            if #meleeHurt >= 2 then
                                loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                            end
                        end
                        if loc ~= nil then
                            useItem(165569)
                            ClickPosition(loc.x, loc.y, loc.z)
                            return true
                        end
                    end
                end
            end
        end

        -- Holy Avenger
        if isChecked("Holy Avenger") and cast.able.holyAvenger() and talent.holyAvenger then
            if getLowAllies(getValue "Holy Avenger") >= getValue("Holy Avenger Targets") then
                if cast.holyAvenger() then
                    return true
                end
            end
        end
        -- Avenging Wrath
        if isChecked("Avenging Wrath") and cast.able.avengingWrath() and not talent.avengingCrusader then
            if getLowAllies(getValue "Avenging Wrath") >= getValue("Avenging Wrath Targets") then
                if cast.avengingWrath() then
                    return true
                end
            end
        end
        -- Avenging Crusader
        if isChecked("Avenging Crusader") and cast.able.avengingCrusader() and talent.avengingCrusader and getDistance("target") <= 5 then
            if getLowAllies(getValue "Avenging Crusader") >= getValue("Avenging Crusader Targets") then
                if cast.avengingCrusader() then
                    return true
                end
            end
        end
        -- Aura Mastery
        if isChecked("Aura Mastery") and cast.able.auraMastery() then
            if getLowAllies(getValue "Aura Mastery") >= getValue("Aura Mastery Targets") then
                if cast.auraMastery() then
                    return true
                end
            end
        end
    end
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS -----------
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function DPS()
        --and isChecked("DPS")
        if
            (mode.DPS == 1 or mode.DPS == 3) and (isChecked("DPS Mana") and mana > getValue("DPS Mana") or not isChecked("DPS Mana")) and
                (isChecked("DPS Health") and lowest.hp > getValue("DPS Health") or not isChecked("DPS Health"))
         then
            if
                isChecked("Holy Shock Damage") and
                    ((inInstance and #tanks > 0 and getDistance(units.dyn40, tanks[1].unit) <= 10) or (inInstance and #tanks == 0) or solo or OWGroup or
                        (inInstance and #tanks > 0 and getDistance(tanks[1].unit) >= 90))
             then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not debuff.glimmerOfLight.exists(thisUnit) and not noDamageCheck(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and getFacing("player", thisUnit) then
                        if cast.holyShock(thisUnit) then
                            return true
                        end
                    end
                end
                if cast.holyShock(units.dyn40) then
                    return true
                end
            end

            --Consecration
            if
                isChecked("Consecration") and cast.able.consecration() and #enemies.yards5 >= getValue("Consecration") and getDebuffRemain("target", 204242) == 0 and
                    (not GetTotemInfo(1) or (getDistanceToObject("player", cX, cY, cZ) > 7) or GetTotemTimeLeft(1) < 2)
             then
                if cast.consecration() then
                    cX, cY, cZ = GetObjectPosition("player")
                    return
                end
            end

            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if not noDamageCheck(thisUnit) and not UnitIsDeadOrGhost(thisUnit) then
                    if
                        isChecked("Auto Focus target") and not UnitExists("target") and not UnitIsDeadOrGhost("focustarget") and UnitAffectingCombat("focustarget") and
                            hasThreat("focustarget")
                     then
                        TargetUnit("focustarget")
                    end
                    -- Start Attack
                    if not IsAutoRepeatSpell(GetSpellInfo(6603)) and isValidUnit("target") and getDistance("target") <= 5 then
                        StartAttack()
                    end
                    -- Holy Prism
                    if isChecked("Holy Prism Damage") and talent.holyPrism and cast.able.holyPrism() and #enemies.yards15 >= getValue("Holy Prism Damage") then
                        if cast.holyPrism(thisUnit) then
                            return true
                        end
                    end
                    -- Hammer of Wrath Wings
                    --if isChecked("Hammer of Wrath") and holyPower <=4 then
                    --if buff.avengingWrath.exists() then
                    --if cast.hammerOfWrath(thisUnit) then
                    --  return true
                    --end
                    --end
                    --end
                    -- Hammer of Wrath
                    if isChecked("Hammer of Wrath") and holyPower <= 4 then
                        if getHP(thisUnit) < 20 then
                            if cast.hammerOfWrath(thisUnit) then
                                return true
                            end
                        end
                    end
                    -- Light's Hammer
                    if isChecked("Light's Hammer Damage") and talent.lightsHammer and cast.able.lightsHammer() and not moving then
                        if cast.lightsHammer("best", false, getOptionValue("Light's Hammer Damage"), 10) then
                            return true
                        end
                    end
                    -- Judgment
                    if isChecked("Judgment - DPS") and cast.able.judgment() and getFacing("player", thisUnit) then
                        if cast.judgment(thisUnit) then
                            return true
                        end
                    end
                end
            end

            -- Crusader Strike
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if not noDamageCheck(thisUnit) and not UnitIsDeadOrGhost(thisUnit) then
                    if isChecked("Crusader Strike") and (not talent.crusadersMight or solo or OWGroup) and cast.able.crusaderStrike() and getFacing("player", thisUnit) then
                        if cast.crusaderStrike(thisUnit) then
                            return true
                        end
                    end
                end
            end
        end
    end

    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --AOEHealing ------ AOEHealing ------AOEHealing ------ AOEHealing ------ AOEHealing ------ AOEHealing ------ AOEHealing ------ AOEHealing ------ AOEHealing ----- AOEHealing -----
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function AOEHealing()
        if burst then
        --Print("Burst:" .. burst)
        end
        --Lights Hammner
        if isChecked("Light's Hammer") and cast.able.lightsHammer() and talent.lightsHammer and not moving and burst == nil then
            if castWiseAoEHeal(br.friend, spell.lightsHammer, 10, getValue("Light's Hammer"), getValue("Light's Hammer Targets"), 6, false, true) then
                return true
            end
        elseif isChecked("Light's Hammer") and cast.able.lightsHammer() and talent.lightsHammer and not moving and burst ~= nil then
            if castWiseAoEHeal(br.friend, spell.lightsHammer, 10, 99, 1, 6, false, true) then
                return true
            end
        end
        -- Judgment as heal
        if isChecked("Judgment heal") and inCombat and cast.able.judgment() and (inInstance and #tanks > 0 and getDistance(units.dyn30, tanks[1].unit) <= 10 or not inInstance) then
            if
                buff.avengingCrusader.exists() or (talent.fistOfJustice and getSpellCD(853) > 5) or
                    (traits.graceoftheJusticar.active and inInstance and #tanks > 0 and tanks[1].hp <= 95 or not inInstance) or
                    (talent.judgmentOfLight and not debuff.judgmentoflight.exists(units.dyn30))
             then
                if cast.judgment(units.dyn30) then
                    return true
                end
            end
        end

        -- Rule of Law
        if isChecked("Rule of Law") and cast.able.ruleOfLaw() and talent.ruleOfLaw and not buff.ruleOfLaw.exists("player") then
            if getLowAllies(getValue("Rule of Law")) >= getValue("RoL Targets") then
                if cast.ruleOfLaw() then
                    return
                end
            end
        end
        -- Holy Prism
        if isChecked("Holy Prism") and talent.holyPrism and cast.able.holyPrism() and inCombat then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local lowHealthCandidates = getUnitsToHealAround(thisUnit, 15, getValue("Holy Prism"), #br.friend)
                if #lowHealthCandidates >= getValue("Holy Prism Targets") then
                    if cast.holyPrism(thisUnit) then
                        return true
                    end
                end
            end
        end
        --Beacon of Virtue
        if isChecked("Beacon of Virtue") and talent.beaconOfVirtue and getCastTime(spell.flashOfLight) < getSpellCD(spell.beaconOfVirtue) and not moving then
            if getLowAllies(getValue("Beacon of Virtue")) >= getValue("BoV Targets") or burst ~= nil then
                if lowest.hp <= getValue("Beacon of Virtue") then
                    if cast.flashOfLight(lowest.unit) then
                        BOV = lowest.unit
                        return
                    end
                end
            end
        end
        -- Light of Dawn
        if isChecked("Light of Dawn") and cast.able.lightOfDawn() and getSpellCD(20473) > gcd and holyPower >= 3 or buff.divinePurpose.exists() then
            if br.unlocked then --EasyWoWToolbox == nil then
                if healConeAround(getValue("LoD Targets"), getValue("Light of Dawn"), 90, lightOfDawn_distance * lightOfDawn_distance_coff, 5 * lightOfDawn_distance_coff) then
                    if cast.lightOfDawn() then
                        return true
                    end
                end
            else
                if bestConeHeal(spell.lightOfDawn, getValue("LoD Targets"), getValue("Light of Dawn"), 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5) then
                    return true
                end
            end
        end
    end
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --topPriority ------ topPriority ------topPriority ------ topPriority ------ topPriority ------ topPriority ------ topPriority ------ topPriority ------ topPriority ----
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function topPriority()
        shouldStopCast()

        --Grievous Wounds
        if isChecked("Grievous Wounds") then
            for i = 1, #br.friend do
                if br.friend[i].hp < 100 and UnitInRange(br.friend[i].unit) or GetUnitIsUnit(br.friend[i].unit, "player") then
                    local CurrentBleedstack = getDebuffStacks(br.friend[i].unit, 240559)
                    if getDebuffStacks(br.friend[i].unit, 240559) > 0 then
                        BleedFriendCount = BleedFriendCount + 1
                    end
                    if CurrentBleedstack > BleedStack then
                        BleedStack = CurrentBleedstack
                        BleedFriend = br.friend[i]
                    --debug stuff
                    --Print("Griev Debug Target: " .. BleedFriend.unit .. " Stacks: " ..CurrentBleedstack .. " HP: " .. BleedFriend.hp)
                    end
                end
            end
        end

        -- Jagged Nettles and Dessication logic
        if
            inInstance and inCombat and
                (GetMinimapZoneText() == "Ballroom" or GetMinimapZoneText() == "Chamber of Eternal Preservation" or GetMinimapZoneText() == "The Lustrous Apse")
         then
            for i = 1, #br.friend do
                if
                    getDebuffRemain(br.friend[i].unit, 260741) ~= 0 or getDebuffRemain(br.friend[i].unit, 267626) ~= 0 or
                        (getDebuffRemain(br.friend[i].unit, 265773) ~= 0 and br.friend[i].hp < 90)
                 then
                    if getSpellCD(20473) == 0 then
                        if cast.holyShock(br.friend[i].unit) then
                            return true
                        end
                    end
                    if php >= getOptionValue("LotM player HP limit") and not GetUnitIsUnit(br.friend[i].unit, "player") then
                        if cast.lightOfTheMartyr(br.friend[i].unit) then
                            return true
                        end
                    end
                    if getSpellCD(20473) > gcd then
                        if cast.flashOfLight(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            end
        end

        --Avenging Crusader (216331)  UnitBuffID("player", 216331)
        if buff.avengingCrusader.exists("player") then
            if
                mode.DPS == 1 or
                    mode.DPS == 3 and (isChecked("DPS Mana") and mana > getValue("DPS Mana") or not isChecked("DPS Mana")) and
                        (isChecked("DPS Health") and lowest.hp > getValue("DPS Health") or not isChecked("DPS Health")) and
                        lowest.hp > getValue("Critical HP")
             then
                if (inInstance and #tanks > 0 and getDistance(units.dyn40, tanks[1].unit) <= 10 or solo or OWGroup) then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not debuff.glimmerOfLight.exists(thisUnit) and not UnitIsOtherPlayersPet(thisUnit) and getFacing("player", thisUnit) then
                            if cast.holyShock(thisUnit) then
                                return true
                            end
                        end
                    end
                    if cast.holyShock(units.dyn40) then
                        return true
                    end
                end
            end
            if cast.judgment(units.dyn30) then
                return true
            end
            if cast.crusaderStrike(units.dyn5) then
                return true
            end
        end

        --Wings, burst mode MAX dps
        if
            (mode.DPS == 3 and (buff.avengingWrath.exists() or buff.avengingCrusader.exists("player")) or
                (GetMinimapZoneText() == "Shrine of Shadows" and getUnitID("target") == 136295)) or
                (isChecked("Hard DPS Key") and SpecificToggle("Hard DPS Key"))
         then
            if
                ((isChecked("DPS Mana") and mana > getValue("DPS Mana")) or not isChecked("DPS Mana")) and
                    ((isChecked("DPS Health") and lowest.hp > getValue("DPS Health")) or not isChecked("DPS Health")) and
                    lowest.hp > getValue("Critical HP")
             then
                if (inInstance and #tanks > 0 and getDistance(units.dyn40, tanks[1].unit) <= 10 or solo or OWGroup or inRaid) then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not debuff.glimmerOfLight.exists(thisUnit) and not UnitIsOtherPlayersPet(thisUnit) and getFacing("player", thisUnit) then
                            if cast.holyShock(thisUnit) then
                                return true
                            end
                        end
                    end
                    if cast.holyShock(units.dyn40) then
                        return true
                    end
                end
            end
            if
                isChecked("Consecration") and cast.able.consecration() and #enemies.yards5 >= getValue("Consecration") and getDebuffRemain("target", 204242) == 0 and
                    (not GetTotemInfo(1) or (getDistanceToObject("player", cX, cY, cZ) > 7) or GetTotemTimeLeft(1) < 3)
             then
                if cast.consecration() then
                    cX, cY, cZ = GetObjectPosition("player")
                    return
                end
            end
            if
                isChecked("Shield of the Righteous") and cast.able.shieldOfTheRighteous() and #enemies.yards5 >= getValue("Shield of the Righteous") and holyPower >= 3 or
                    buff.divinePurpose.exists()
             then
                if cast.shieldOfTheRighteous(thisUnit) then
                    return true
                end
            end
            if cast.judgment(units.dyn30) then
                return true
            end
            if cast.crusaderStrike(units.dyn5) then
                return true
            end
        end

        --Talent Crusaders Might
        if isChecked("Crusader Strike") and mode.Glimmer ~= 1 and talent.crusadersMight and cast.able.crusaderStrike() and lowest.hp > getValue("Critical HP") then
            if (getSpellCD(20473) > gcd) then
                if cast.crusaderStrike(units.dyn5) then
                    return true
                end
            end
        end
    end

    local function glimmer()
        --Glimmer support

        if
            isChecked("Aggressive Glimmer") and (mode.DPS == 1 or mode.DPS == 3) and inCombat and UnitIsEnemy("target", "player") and isChecked("Critical HP") and
                lowest.hp > getValue("Critical HP")
         then
            if not debuff.glimmerOfLight.exists("target") and getFacing("player", "target") then
                if cast.holyShock("target") then
                    br.addonDebug("glimmerOfLight on target")
                    return true
                end
            end
        end

        if mode.Glimmer == 3 and (inInstance or inRaid) and #tanks > 0 then
            for i = 1, #tanks do
                local thisUnit = tanks[i].unit
                if not UnitBuffID(thisUnit, 287280, "PLAYER") and not UnitBuffID(thisUnit, 115191) and getLineOfSight(thisUnit, "player") then
                    if cast.holyShock(thisUnit) then
                    end
                end
            end
        end

        if mode.Glimmer == 1 and (inInstance or inRaid or OWGroup) and #br.friend > 1 then
            if getSpellCD(20473) < gcd then
                -- Check here to see if shock is not ready, but dawn is - then use dawn
                --critical first
                if #tanks > 0 then
                    if tanks[1].hp <= getValue("Critical HP") and getDebuffStacks(tanks[1].unit, 209858) < getValue("Necrotic Rot") then
                        if cast.holyShock(tanks[1].unit) then
                            return true
                        end
                    end
                end
                if isChecked("Self Shock") and php <= getValue("Self Shock") and not UnitBuffID("player", 287280, "PLAYER") then
                    if cast.holyShock("player") then
                        return true
                    end
                end
                if lowest.hp <= getValue("Critical HP") and getDebuffStacks(lowest.unit, 209858) < getValue("Necrotic Rot") then
                    if cast.holyShock(lowest.unit) then
                        return true
                    end
                end
                --find lowest friend without glitter buff on them - tank first
                for i = 1, #br.friend do
                    if UnitInRange(br.friend[i].unit) and getLineOfSight(br.friend[i].unit, "player") then
                        if
                            (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and
                                not buff.beaconOfFaith.exists(br.friend[i].unit) and
                                not UnitBuffID(br.friend[i].unit, 287280)
                         then
                            if cast.holyShock(br.friend[i].unit) then
                                --Print(br.friend[i].unit)
                                return true
                            end
                        end
                    end
                end
                glimmerTable = {}
                for i = 1, #br.friend do
                    if
                        UnitInRange(br.friend[i].unit) and getLineOfSight(br.friend[i].unit, "player") and not UnitBuffID(br.friend[i].unit, 287280, "PLAYER") and
                            not UnitBuffID(br.friend[i].unit, 115191)
                     then
                        tinsert(glimmerTable, br.friend[i])
                    end
                end
                if #glimmerTable > 1 then
                    table.sort(
                        glimmerTable,
                        function(x, y)
                            return x.hp < y.hp
                        end
                    )
                end
                if glimmerCount ~= nil and glimmerCount >= 8 then
                    if cast.holyShock(lowest.unit) then
                        --Print("Glimmer cap glimmer")
                        return
                    end
                end
                if #glimmerTable >= 1 and glimmerTable[1].unit ~= nil and mode.Glimmer == 1 then
                    if isChecked("Rule of Law") and cast.able.ruleOfLaw() and talent.ruleOfLaw and not buff.ruleOfLaw.exists("player") and inCombat then
                        if #glimmerTable >= 1 and glimmerTable[1].distance ~= nil and glimmerTable[1].distance > 10 then
                            if cast.ruleOfLaw() then
                                --Print(getDistance(glimmerTable[1]))
                                return true
                            end
                        end
                    end
                    if cast.holyShock(glimmerTable[1].unit) then
                        --Print("Just glimmered: " .. glimmerTable[1].unit)
                        return true
                    end
                end
                if (glimmerTable ~= nil and #glimmerTable == 0 and (not isChecked("Holy Shock Damage") or (isChecked("Holy Shock Damage") and lowest.hp < getValue("Holy Shock")))) then
                    if cast.holyShock(lowest.unit) then
                        return
                    end
                end
            elseif getSpellCD(20473) > gcd then
                if br.unlocked then --EasyWoWToolbox == nil then
                    if
                        healConeAround(getValue("LoD Targets"), getValue("Light of Dawn"), 90, lightOfDawn_distance * lightOfDawn_distance_coff, 5 * lightOfDawn_distance_coff) and
                            holyPower >= 3 or
                            buff.divinePurpose.exists()
                     then
                        if cast.lightOfDawn() then
                            return true
                        end
                    end
                else
                    if bestConeHeal(spell.lightOfDawn, getValue("LoD Targets"), getValue("Light of Dawn"), 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5) then
                        return true
                    end
                end
            end
            if talent.crusadersMight and lowest.hp > getValue("Critical HP") and (getSpellCD(20473) > (gcd)) then
                if cast.crusaderStrike(units.dyn5) then
                    return true
                end
            end
        end
    end
    local function SingleTarget()
        local holyshocktarget = nil
        local folTarget = nil
        local lightOfTheMartyrDS = nil
        local lightOfTheMartyrHS = nil
        local lightOfTheMartyrTANK = nil
        local lightOfTheMartyrHP = nil
        local flashOfLightTANK = nil
        local flashOfLightInfuse10 = nil
        local flashOfLight10 = nil
        local flashOfLightInfuse20 = nil
        local flashOfLight20 = nil
        local flashOfLightInfuse30 = nil
        local flashOfLight30 = nil
        local flashOfLightInfuse40 = nil
        local flashOfLight40 = nil
        local lightOfTheMartyrBF10 = nil
        local lightOfTheMartyrBF20 = nil
        local lightOfTheMartyrBF30 = nil
        local lightOfTheMartyrBF40 = nil
        local holyLight10 = nil
        local holyLight20 = nil
        local holyLight30 = nil
        local holyLight40 = nil
        local lightOfTheMartyrM10 = nil
        local lightOfTheMartyrM20 = nil
        local lightOfTheMartyrM30
        local lightOfTheMartyrM40 = nil
        local wordOfGlorytarget = nil

        --and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")

        if #br.friend > 0 then
            for i = 1, #br.friend do
                if br.friend[i].hp < 100 and UnitInRange(br.friend[i].unit) or GetUnitIsUnit(br.friend[i].unit, "player") then
                    --count grievance stacks here
                    if isChecked("Grievous Wounds") then
                        local CurrentBleedstack = getDebuffStacks(br.friend[i].unit, 240559)
                        if getDebuffStacks(br.friend[i].unit, 240559) > 0 then
                            BleedFriendCount = BleedFriendCount + 1
                        end
                        if CurrentBleedstack > BleedStack then
                            BleedStack = CurrentBleedstack
                            BleedFriend = br.friend[i]
                        --debug stuff
                        --Print("Griev Debug Target: " .. BleedFriend.unit .. " Stacks: " ..CurrentBleedstack .. " HP: " .. BleedFriend.hp)
                        end
                    end

                    if isChecked("Mastery bonus") and inRaid then
                        if
                            br.friend[i].hp <= getValue("Holy Shock") and not buff.beaconOfFaith.exists(br.friend[i].unit) and not buff.beaconOfVirtue.exists(br.friend[i].unit) and
                                br.friend[i].distance <= (10 * master_coff)
                         then
                            holyshocktarget = br.friend[i].unit
                        end
                        if
                            holyshocktarget == nil and br.friend[i].hp <= getValue("Holy Shock") and not buff.beaconOfFaith.exists(br.friend[i].unit) and
                                not buff.beaconOfVirtue.exists(br.friend[i].unit) and
                                br.friend[i].distance <= (20 * master_coff)
                         then
                            holyshocktarget = br.friend[i].unit
                        end
                        if
                            holyshocktarget == nil and br.friend[i].hp <= getValue("Holy Shock") and not buff.beaconOfFaith.exists(br.friend[i].unit) and
                                not buff.beaconOfVirtue.exists(br.friend[i].unit) and
                                br.friend[i].distance <= (30 * master_coff)
                         then
                            holyshocktarget = br.friend[i].unit
                        end
                    end

                    if
                        holyshocktarget == nil and br.friend[i].hp <= getValue("Holy Shock") and
                            (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
                     then
                        holyshocktarget = br.friend[i].unit
                    end
                    if br.friend[i].hp <= 90 and buff.divineShield.exists("player") and not GetUnitIsUnit(br.friend[i].unit, "player") then
                        lightOfTheMartyrDS = br.friend[i].unit
                    end
                    if
                        br.friend[i].hp <= getValue("LoM after FoL") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and
                            getSpellCD(20473) >= gcd
                     then
                        lightOfTheMartyrTANK = br.friend[i].unit
                    end
                    if br.friend[i].hp <= getValue("LoM after FoL") and getSpellCD(20473) >= gcd and not GetUnitIsUnit(br.friend[i].unit, "player") then
                        lightOfTheMartyrHS = br.friend[i].unit
                    end
                    if
                        br.friend[i].hp <= getValue("Light of the Martyr") and not GetUnitIsUnit(br.friend[i].unit, "player") and
                            (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
                     then
                        lightOfTheMartyrHP = br.friend[i].unit
                    end

                    --Flash of Light
                    if
                        br.friend[i].hp <= getValue("FoL Tanks") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and
                            (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
                     then
                        folTarget = br.friend[i].unit
                    end

                    if isChecked("Mastery bonus") and inRaid then
                        if
                            folTarget == nil and br.friend[i].hp <= getValue("FoL Infuse") and br.friend[i].distance <= (10 * master_coff) and
                                buff.infusionOfLight.remain("player") > gcd
                         then
                            folTarget = br.friend[i].unit
                        elseif br.friend[i].hp <= getValue("Flash of Light") and br.friend[i].distance <= (10 * master_coff) then
                            folTarget = br.friend[i].unit
                        end
                        if
                            folTarget == nil and br.friend[i].hp <= getValue("FoL Infuse") and br.friend[i].distance <= (20 * master_coff) and
                                buff.infusionOfLight.remain("player") > gcd
                         then
                            folTarget = br.friend[i].unit
                        elseif folTarget == nil and br.friend[i].hp <= getValue("Flash of Light") and br.friend[i].distance <= (20 * master_coff) then
                            folTarget = br.friend[i].unit
                        end
                        if
                            folTarget == nil and br.friend[i].hp <= getValue("FoL Infuse") and br.friend[i].distance <= (30 * master_coff) and
                                buff.infusionOfLight.remain("player") > gcd
                         then
                            folTarget = br.friend[i].unit
                        elseif folTarget == nil and br.friend[i].hp <= getValue("Flash of Light") and br.friend[i].distance <= (30 * master_coff) then
                            folTarget = br.friend[i].unit
                        end
                    end

                    if
                        folTarget == nil and br.friend[i].hp <= getValue("FoL Infuse") and
                            (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot"))) and
                            buff.infusionOfLight.remain("player") > gcd
                     then
                        folTarget = br.friend[i].unit
                    elseif
                        folTarget == nil and br.friend[i].hp <= getValue("Flash of Light") and
                            (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
                     then
                        folTarget = br.friend[i].unit
                    end
                    if isChecked("Mastery bonus") and inRaid then
                        if br.friend[i].hp <= getValue("Bestow Faith") and not GetUnitIsUnit(br.friend[i].unit, "player") and br.friend[i].distance <= (10 * master_coff) then
                            lightOfTheMartyrBF10 = br.friend[i].unit
                        end
                        if br.friend[i].hp <= getValue("Bestow Faith") and not GetUnitIsUnit(br.friend[i].unit, "player") and br.friend[i].distance <= (20 * master_coff) then
                            lightOfTheMartyrBF20 = br.friend[i].unit
                        end
                        if br.friend[i].hp <= getValue("Bestow Faith") and not GetUnitIsUnit(br.friend[i].unit, "player") and br.friend[i].distance <= (30 * master_coff) then
                            lightOfTheMartyrBF30 = br.friend[i].unit
                        end
                    end
                    if
                        br.friend[i].hp <= getValue("Bestow Faith") and not GetUnitIsUnit(br.friend[i].unit, "player") and
                            (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
                     then
                        lightOfTheMartyrBF40 = br.friend[i].unit
                    end
                    if isChecked("Mastery bonus") and inRaid then
                        if br.friend[i].hp <= getValue("Holy Light") and br.friend[i].distance <= (10 * master_coff) then
                            holyLight10 = br.friend[i].unit
                        end
                        if br.friend[i].hp <= getValue("Holy Light") and br.friend[i].distance <= (20 * master_coff) then
                            holyLight20 = br.friend[i].unit
                        end
                        if br.friend[i].hp <= getValue("Holy Light") and br.friend[i].distance <= (30 * master_coff) then
                            holyLight30 = br.friend[i].unit
                        end
                    end
                    if
                        br.friend[i].hp <= getValue("Holy Light") and br.friend[i].hp >= getValue("Critical HP") and
                            (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
                     then
                        holyLight40 = br.friend[i].unit
                    end
                    if isChecked("Mastery bonus") and inRaid then
                        if br.friend[i].hp <= getValue("Moving LotM") and not GetUnitIsUnit(br.friend[i].unit, "player") and br.friend[i].distance <= (10 * master_coff) then
                            lightOfTheMartyrM10 = br.friend[i].unit
                        end
                        if br.friend[i].hp <= getValue("Moving LotM") and not GetUnitIsUnit(br.friend[i].unit, "player") and br.friend[i].distance <= (20 * master_coff) then
                            lightOfTheMartyrM20 = br.friend[i].unit
                        end
                        if br.friend[i].hp <= getValue("Moving LotM") and not GetUnitIsUnit(br.friend[i].unit, "player") and br.friend[i].distance <= (30 * master_coff) then
                            lightOfTheMartyrM30 = br.friend[i].unit
                        end
                    end
                    if
                        br.friend[i].hp <= getValue("Moving LotM") and not GetUnitIsUnit(br.friend[i].unit, "player") and
                            (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
                     then
                        lightOfTheMartyrM40 = br.friend[i].unit
                    end
                end
            end
        end

        -- Holy Shock
        if isChecked("Holy Shock") and getSpellCD(20473) < gcd then
            --critical first
            if #tanks > 0 then
                if tanks[1].hp <= getValue("Critical HP") and getDebuffStacks(tanks[1].unit, 209858) < getValue("Necrotic Rot") then
                    if cast.holyShock(tanks[1].unit) then
                        return true
                    end
                end
            end
            if php <= getValue("Critical HP") or getBuffRemain("player", 265773) ~= 0 then
                if cast.holyShock("player") then
                    return true
                end
            end
            if lowest.hp <= getValue("Critical HP") and getDebuffStacks(lowest.unit, 209858) < getValue("Necrotic Rot") then
                if cast.holyShock(lowest.unit) then
                    return true
                end
            end
            if BleedFriend ~= nil then
                if cast.holyShock(BleedFriend.unit) then
                    return true
                end
            end
            if isChecked("Mastery bonus") and inRaid and holyshocktarget ~= nil then
                if cast.holyShock(holyshocktarget) then
                    return true
                end
            elseif lowest.hp <= getValue("Holy Shock") and getDebuffStacks(lowest.unit, 209858) < getValue("Necrotic Rot") then
                if cast.holyShock(lowest.unit) then
                    return true
                end
            end
        end

        -- Grievous stuff

        if BleedFriend ~= nil then
            if cast.able.lightOfDawn() and isChecked("Light of Dawn") and holyPower >= 3 or buff.divinePurpose.exists() then
                if bestConeHeal(spell.lightOfDawn, 1, 80, 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5) then
                    return true
                end
            end

            if
                cast.able.lightOfTheMartyr() and isChecked("Light of the Martyr") and BleedFriend ~= player and php >= getOptionValue("LotM player HP limit") and
                    BleedFriend.hp > 70 and
                    getDebuffStacks("player", 267034) < 2
             then
                if cast.lightOfTheMartyr(BleedFriend.unit) then
                    return true
                end
            end
            if cast.able.flashOfLight() then
                if cast.flashOfLight(BleedFriend.unit) then
                    return true
                end
            end
        end
        -- Divine Shield and Light of the Martyr
        if lightOfTheMartyrDS ~= nil and php <= getValue("Critical HP") and getDebuffStacks("player", 267034) < 2 and getDebuffStacks("player", 265773) == 0 then
            if cast.lightOfTheMartyr(lightOfTheMartyrDS) then
                return true
            end
        end
        if isChecked("LoM after FoL") and isCastingSpell(spell.flashOfLight) and php >= getOptionValue("LotM player HP limit") then
            if getOptionValue("LoM after FoL Target") == 1 and lightOfTheMartyrTANK ~= nil then
                if CastSpellByName(GetSpellInfo(183998), lightOfTheMartyrTANK) then
                    return true
                end
            elseif getOptionValue("LoM after FoL Target") == 2 and lightOfTheMartyrHS ~= nil then
                if CastSpellByName(GetSpellInfo(183998), lightOfTheMartyrHS) then
                    return true
                end
            end
        end
        -- Light of Martyr
        if
            lightOfTheMartyrHP ~= nil and isChecked("Light of the Martyr") and php >= getOptionValue("LotM player HP limit") and getDebuffStacks("player", 267034) < 2 and
                getDebuffStacks("player", 265773) == 0 and
                getSpellCD(20473) < gcd
         then
            if cast.lightOfTheMartyr(lightOfTheMartyrHP) then
                return true
            end
        end
        -- Bestow Faith
        if talent.bestowFaith and isChecked("Bestow Faith") and cast.able.bestowFaith() and getSpellCD(20473) > gcd then
            if getOptionValue("Bestow Faith Target") == 1 then
                if lowest.hp <= getValue("Bestow Faith") and UnitInRange(lowest.unit) then
                    if cast.bestowFaith(lowest.unit) then
                        return true
                    end
                end
            elseif getOptionValue("Bestow Faith Target") == 2 and #tanks > 0 and UnitInRange(tanks[1].unit) then
                if tanks[1].hp <= getValue("Bestow Faith") then
                    if cast.bestowFaith(tanks[1].unit) then
                        return true
                    end
                end
            elseif getOptionValue("Bestow Faith Target") == 3 then
                if php <= getValue("Bestow Faith") then
                    if cast.bestowFaith("player") then
                        return true
                    end
                end
            elseif getOptionValue("Bestow Faith Target") == 4 then
                if lowest.hp <= getValue("Bestow Faith") then
                    if cast.bestowFaith("player") then
                        return true
                    end
                end
            end
        end -- end Bestow Faith

        -- Word of Glory
        if isChecked("Word of Glory") and getSpellCD(20473) > gcd and holyPower >= 3 or buff.divinePurpose.exists() then
            --Critical first
            if php <= getValue("Critical HP") then
                if cast.wordOfGlory("player") then
                    return true
                end
            end
            if #tanks > 0 then
                if tanks[1].hp <= getValue("Critical HP") and getDebuffStacks(tanks[1].unit, 209858) < getValue("Necrotic Rot") then
                    if cast.wordOfGlory(tanks[1].unit) then
                        healing_obj = tanks[1].unit
                        return true
                    end
                end
            end
            if lowest.hp <= getValue("Critical HP") and getDebuffStacks(lowest.unit, 209858) < getValue("Necrotic Rot") then
                if cast.wordOfGlory(lowest.unit) then
                    healing_obj = lowest.unit
                    return true
                end
            end
            if isChecked("Mastery bonus") and inRaid and wordOfGlorytarget ~= nil then
                if cast.wordOfGlory(wordOfGlorytarget) then
                    return true
                end
            elseif lowest.hp <= getValue("Word of Glory") and getDebuffStacks(lowest.unit, 209858) < getValue("Necrotic Rot") then
                if cast.wordOfGlory(lowest.unit) then
                    return true
                end
            end
        end
        -- Flash of Light
        if isChecked("Flash of Light") and not moving then
            --Critical first
            if php <= getValue("Critical HP") then
                if cast.flashOfLight("player") then
                    return true
                end
            end
            if #tanks > 0 then
                if tanks[1].hp <= getValue("Critical HP") and getDebuffStacks(tanks[1].unit, 209858) < getValue("Necrotic Rot") then
                    if cast.flashOfLight(tanks[1].unit) then
                        healing_obj = tanks[1].unit
                        return true
                    end
                end
            end
            if lowest.hp <= getValue("Critical HP") and getDebuffStacks(lowest.unit, 209858) < getValue("Necrotic Rot") then
                if cast.flashOfLight(lowest.unit) then
                    healing_obj = lowest.unit
                    return true
                end
            end
            if flashOfLightTANK ~= nil then
                if cast.flashOfLight(flashOfLightTANK) then
                    healing_obj = flashOfLightTANK
                    return true
                end
            end

            if folTarget ~= nil then
                if cast.flashOfLight(folTarget) then
                    healing_obj = folTarget
                    --Print(folTarget)
                    return true
                end
            end
        end
        -- Light of Martyr and Bestow Faith
        if
            isChecked("Light of the Martyr") and php >= 80 and buff.bestowFaith.exists("player") and getDebuffStacks("player", 267034) < 2 and
                getOptionValue("Bestow Faith Target") == 4 and
                getDebuffStacks("player", 265773) == 0
         then
            if lightOfTheMartyrBF10 ~= nil then
                if cast.lightOfTheMartyr(lightOfTheMartyrBF10) then
                    return true
                end
            end
            if lightOfTheMartyrBF20 ~= nil then
                if cast.lightOfTheMartyr(lightOfTheMartyrBF20) then
                    return true
                end
            end
            if lightOfTheMartyrBF30 ~= nil then
                if cast.lightOfTheMartyr(lightOfTheMartyrBF30) then
                    return true
                end
            end
            if lightOfTheMartyrBF40 ~= nil then
                if cast.lightOfTheMartyr(lightOfTheMartyrBF40) then
                    return true
                end
            end
        end
        -- Holy Light
        if
            isChecked("Holy Light") and not moving and getSpellCD(20473) > gcd and
                (getOptionValue("Holy Light Infuse") == 1 or
                    (getOptionValue("Holy Light Infuse") == 2 and buff.infusionOfLight.remain() > getCastTime(spell.holyLight) and flashOfLightInfuse40 == nil))
         then
            if holyLight10 ~= nil then
                if cast.holyLight(holyLight10) then
                    healing_obj = holyLight10
                    return true
                end
            end
            if holyLight20 ~= nil then
                if cast.holyLight(holyLight20) then
                    healing_obj = holyLight20
                    return true
                end
            end
            if holyLight30 ~= nil then
                if cast.holyLight(holyLight30) then
                    healing_obj = holyLight30
                    return true
                end
            end
            if holyLight40 ~= nil then
                if cast.holyLight(holyLight40) then
                    healing_obj = holyLight40
                    return true
                end
            end
        end
        -- Moving Martyr
        if
            isChecked("Moving LotM") and moving and php >= getOptionValue("LotM player HP limit") and getDebuffStacks("player", 267034) < 2 and
                getDebuffStacks("player", 265773) == 0
         then
            if #tanks > 0 then
                if tanks[1].hp <= getValue("Critical HP") and getDebuffStacks(tanks[1].unit, 209858) < getValue("Necrotic Rot") then
                    if cast.lightOfTheMartyr(tanks[1].unit) then
                        return true
                    end
                end
            end
            if
                lowest.hp <= getValue("Critical HP") and not GetUnitIsUnit(lowest.unit, "player") and getDebuffStacks(lowest.unit, 209858) < getValue("Necrotic Rot") and
                    getDebuffStacks("player", 267034) < 2
             then
                if cast.lightOfTheMartyr(lowest.unit) then
                    return true
                end
            end
            if lightOfTheMartyrM10 ~= nil then
                if cast.lightOfTheMartyr(lightOfTheMartyrM10) then
                    return true
                end
            end
            if lightOfTheMartyrM20 ~= nil then
                if cast.lightOfTheMartyr(lightOfTheMartyrM20) then
                    return true
                end
            end
            if lightOfTheMartyrM30 ~= nil then
                if cast.lightOfTheMartyr(lightOfTheMartyrM30) then
                    return true
                end
            end
            if lightOfTheMartyrM40 ~= nil then
                if cast.lightOfTheMartyr(lightOfTheMartyrM40) then
                    return true
                end
            end
        end
    end
    if (not IsMounted() or buff.divineSteed.exists()) then
        if pause() or drinking then
            return true
        else
            ---------------------------------
            --- Out Of Combat - Rotations ---
            ---------------------------------
            if not inCombat and not UnitBuffID("player", 115834) then
                -- auto drinking
                if isChecked("Auto Drink") and mana <= getOptionValue("Auto Drink") and not moving and getDebuffStacks("player", 240443) == 0 then
                    --240443 == bursting
                    --drink list
                    --[[
                item=163784/seafoam-coconut-water
                item=113509/conjured-mana-bun
                item=126936/sugar-crusted-fish-feast
                ]]
                    local fishfeast = 0
                    if not isChecked("Sugar Crusted Fish Feast") or (isChecked("Sugar Crusted Fish Feast") and not hasItem(126936)) then
                        if hasItem(113509) and canUseItem(113509) then
                            useItem(113509)
                        end
                        if hasItem(163784) and canUseItem(163784) then
                            useItem(163784)
                        end
                    elseif isChecked("Sugar Crusted Fish Feast") then
                        if br.unlocked then --EWT ~= nil then
                            for i = 1, GetObjectCountBR() do
                                local ID = ObjectID(GetObjectWithIndex(i))
                                local object = GetObjectWithIndex(i)
                                local x1, y1, z1 = ObjectPosition("player")
                                local x2, y2, z2 = ObjectPosition(object)
                                local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                                if ID == 242405 and distance < 15 then
                                    --print(tostring(distance))
                                    InteractUnit(object)
                                    fishfeast = 0
                                else
                                    if hasItem(126936) and canUseItem(126936) and fishfeast == 0 and not hasBuff(185710) then
                                        useItem(126936)
                                        x1 = x1 + math.random(-2, 2)
                                        ClickPosition(x1, y1, z1)
                                        br.addonDebug("Placing fish thingy")
                                        fishfeast = 1
                                        return
                                    end
                                end
                            end
                        end
                    end
                end

                if QOL() then
                    return
                end
                if key() then
                    return
                end
                if PrePull() then
                    return
                end
                if CanIRess() then
                    return
                end
                if Cleanse() then
                    return
                end
                if glimmer() then
                    return true
                end
                if isChecked("OOC Healing") then
                    if mode.Beacon ~= 4 and not talent.beaconOfVirtue then
                        if Beacon() then
                            return
                        end
                    end

                    if AOEHealing() then
                        return
                    end
                    if SingleTarget() then
                        return
                    end
                end
            end
            -----------------------------
            --- In Combat - Rotations ---
            -----------------------------
            if inCombat and not UnitBuffID("player", 115834) then
                if key() then
                    return
                end
                if BossEncounterCase() then
                    return
                end
                overhealingcancel()
                if actionList_Defensive() then
                    return
                end
                if Cleanse() then
                    return
                end
                if Interrupt() then
                    return
                end
                if mode.Beacon ~= 4 and not talent.beaconOfVirtue then
                    if Beacon() then
                        return
                    end
                end
                if useCDs() then
                    if Cooldowns() then
                        return
                    end
                end
                if topPriority() then
                    return true
                end
                if glimmer() then
                    return true
                end
                if AOEHealing() then
                    return
                end
                if SingleTarget() then
                    return
                end
                if DPS() then
                    return
                end
            end
        end
    end
end -- End runRotation
--if isChecked("Boss Helper") then
--      bossManager()
--end
local id = 0
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(
    br.rotations[id],
    {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation
    }
)
