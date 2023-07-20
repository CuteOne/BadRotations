-------------------------------------------------------
-- Author = Nessaj911
-- Patch = 10.0.2
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 90%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Full
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Development
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --

local rotationName = "Nessaj m+" -- Profile name
---------------
--- Toggles ---
---------------
local function createToggles()
    local CreateButton = br["CreateButton"]
    -- Rotation Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 0, icon = br.player.spell.holyAvenger },
        [2] = { mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.auraMastery },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.absolution }
    }
    br.ui:createToggle(CooldownModes, "Cooldown", 1, 0)

    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 0, icon = br.player.spell.divineProtection },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.blessingOfProtection }
    }
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)

    -- Cleanse Button
    local CleanseModes = {
        [1] = { mode = "On", value = 1, overlay = "Cleanse Enabled", tip = "Cleanse Enabled", highlight = 0, icon = br.player.spell.cleanse },
        [2] = { mode = "Off", value = 2, overlay = "Cleanse Disabled", tip = "Cleanse Disabled", highlight = 0, icon = br.player.spell.cleanse }
    }
    br.ui:createToggle(CleanseModes, "Cleanse", 3, 0)

    -- Glimmer
    local GlimmerModes = {
        [1] = { mode = "On", value = 1, overlay = "Glimmer mode", tip = "Glimmer on", highlight = 0, icon = 287280 },
        [2] = { mode = "Off", value = 2, overlay = "Normal", tip = "Glimmer off", highlight = 0, icon = br.player.spell.holyShock },
        [3] = { mode = "Tank", value = 3, overlay = "Normal", tip = "Glimmer on tank", highlight = 0, icon = 278573 }
    }
    br.ui:createToggle(GlimmerModes, "Glimmer", 4, 0)

    -- DPS
    local DPSModes = {
        [1] = { mode = "On", value = 1, overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 0, icon = br.player.spell.judgment },
        [2] = { mode = "Off", value = 2, overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.judgment },
    }
    br.ui:createToggle(DPSModes, "DPS", 5, 0)

    local PotsModes = {
        [1] = { mode = "On", value = 1, overlay = "Use Pots", tip = "Use Pots", highlight = 0, icon = 2259 },
        [2] = { mode = "Off", value = 2, overlay = "Use Pots", tip = "Use Pots", highlight = 0, icon = 2259 },
    }
    br.ui:createToggle(PotsModes, "Pots", 6, 0)

    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.blindingLight },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.blindingLight }
    }
    br.ui:createToggle(InterruptModes, "Interrupt", 1, 1)

    -- M+ Stuns
    local StunModes = {
        [1] = { mode = "On", value = 1, overlay = "DPS Enabled", tip = "M+ Stun Logic Enabled", highlight = 0, icon = br.player.spell.hammerOfJustice },
        [2] = { mode = "Off", value = 2, overlay = "DPS Disabled", tip = "M+ Stun Logic Disabled", highlight = 0, icon = br.player.spell.hammerOfJustice },
    }
    br.ui:createToggle(StunModes, "Stuns", 2, 1)

    -- FREEEDOM!!
    local FreedomModes = {
        [1] = { mode = "On", value = 1, overlay = "Freedoms Enabled", tip = "M+ Freedom/BoP Logic Enabled", highlight = 0, icon = br.player.spell.blessingOfFreedom },
        [2] = { mode = "Off", value = 2, overlay = "Freedoms Disabled", tip = "M+ Freedom/BoP Logic Disabled", highlight = 0, icon = br.player.spell.blessingOfFreedom },
    }
    br.ui:createToggle(FreedomModes, "Freedom", 3, 1)


end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
    -- General
    local function rotationOptions()
        section = br.ui:createSection(br.ui.window.profile, "General - v.0.1")
        br.ui:createDropdownWithout(section, "DPS Key", br.dropOptions.Toggle, 6, "DPS Override")
        br.ui:createCheckbox(section, "Group CD's with DPS key", "Pop wings and HA with Dps override", 1)
        br.ui:createSpinner(section, "Divine Toll during DPS Key", 3, 1, 5, 1, "Use Divine Toll at >= x units")
        br.ui:createCheckbox(section, "Blessing of the Seasons", "Use all blessing on player", 1)

        -- Healing
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Healing")
        br.ui:createSpinnerWithout(section, "Critical HP", 40, 0, 100, 5, "", "Health Percent to Critical Heals")
        br.ui:createDropdownWithout(section, "Fish Spell for Awakening", { "WoG", "LoD" }, 1)
        br.ui:createSpinner(section, "Word of Glory", 75, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Holy Shock", 90, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Light of the Martyr", 55, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "LotM player HP limit", 65, 0, 100, 5, "", "Light of the Martyr Self HP limit")
        br.ui:createCheckbox(section, "LOTM Spam with Divine shield")
        br.ui:createDropdown(section, "Divine Toll", { "At 0 Holy Power", "As a Heal" }, 1)
        br.ui:createSpinnerWithout(section, "Divine Toll Units", 3, 1, 5, 1)
        br.ui:createSpinnerWithout(section, "Divine Toll Health", 70, 0, 100, 1)
        br.ui:createSpinnerWithout(section, "Max Holy Power", 2, 0, 5, 1, "Only use Divine Toll when at or below this value")
        br.ui:checkSectionState(section)
        -- LoD
        br.ui:createSpinner(section, "Light of Dawn", 90, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "LoD Targets", 4, 0, 40, 1, "", "Minimum LoD Targets", true)
        -- Lights Hammer
        br.ui:createSpinnerWithout(section, "Light's Hammer Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Light's Hammer Targets", true)
        -- FoL
        br.ui:createSpinner(section, "Infused Flash of Light", 65, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Flash of Light", 45, 0, 100, 5, "", "Health Percent to Cast At")
        -- HL
        br.ui:createCheckbox(section, "Infused Holy Light")
        br.ui:createSpinner(section, "Tank Infused Holy Light HP Limit", 65, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At", true)
        br.ui:createSpinner(section, "DPS/Healer Infused Holy Light HP Limit", 40, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At", true)
        -- Beacon
        br.ui:createCheckbox(section, "Beacon of Light")
        br.ui:createSpinner(section, "Beacon of Virtue", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "BoV Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum BoV Targets", true)
        -- Beacon Emergency Healing Swap
        br.ui:createCheckbox(section, "Beacon Swap Emergency Healing")
        br.ui:createSpinner(section, "Beacon Swap Min HP", 20, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At", true)
        br.ui:checkSectionState(section)

        -- Cooldowns
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Aura mastery
        br.ui:createSpinner(section, "Aura Mastery", 50, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Aura Mastery Targets", 3, 0, 40, 1, "", "Minimum Aura Mastery Targets", true)
        -- Wings\Avanger
        br.ui:createSpinner(section, "Holy Avenger", 60, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Holy Avenger Targets", 3, 0, 40, 1, "", "Minimum Holy Avenger Targets", true)
        br.ui:createSpinner(section, "Avenging Wrath", 60, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Avenging Wrath Targets", 3, 0, 40, 1, "", "Minimum Holy Avenger Targets", true)
        -- Seraphim
        br.ui:createSpinner(section, "Seraphim", 0, 0, 20, 2, "|cffFFFFFFEnemy TTD")
        -- Other CD
        br.ui:createSpinner(section, "Lay on Hands", 20, 0, 100, 5, "", "Min Health Percent to Cast At")
        br.ui:createSpinner(section, "Blessing of Protection", 20, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Blessing of Sacrifice", 40, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createDropdownWithout(section, "BoS Target", { "Any", "Tanks" }, 2, "Target for BoS")
        br.ui:createCheckbox(section, "Blessing of Freedom", "Use Blessing of Freedom")
        br.ui:createCheckbox(section, "Automatic Aura replacement")
        br.ui:checkSectionState(section)
        
        -- Trinket support
        section = br.ui:createSection(br.ui.window.profile, "Trinkets")
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 1 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround", "DPS-Target", "w/DPS KEY" }, 1, "", "")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 2 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround", "DPS-Target", "w/DPS KEY" }, 1, "", "")
        br.ui:checkSectionState(section)

        -- Glimmer debug
        --br.ui:createCheckbox(section,"glimmer debug")

        -- Self Defence(Pot\Stone\other)
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        if br.player.race == "BloodElf" then
            br.ui:createSpinner(section, "Arcane Torrent Dispel", 1, 0, 20, 1, "", "|cffFFFFFFMinimum Torrent Targets")
            br.ui:createSpinner(section, "Arcane Torrent Mana", 30, 0, 95, 1, "", "|cffFFFFFFMinimum When to use for mana")
            br.ui:createCheckbox(section, "Arcane Torrent HolyPower")
        end
        -- Pot/Stone
        br.ui:createSpinner(section, "Pot/Stoned", 30, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Divine Protection", 60, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Divine Shield", 20, 0, 100, 5, "", "Health Percent to Cast At")
        -- Gift of The Naaru
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of The Naaru", 50, 0, 100, 5, "Health Percent to Cast At")
        end
        br.ui:checkSectionState(section)

        -- DPS options
        section = br.ui:createSection(br.ui.window.profile, "DPS Options")
        br.ui:createSpinnerWithout(section, "DPS Min HP", 75, 0, 100, 1, "Health Percent of lowest ally to stop SOTR/Aggressive HS.")
        br.ui:createCheckbox(section, "Prioritize Hammer of Wrath")
        br.ui:createCheckbox(section, "Shield of the Righteous")
        br.ui:createCheckbox(section, "Use Holy Shock for DPS")
        br.ui:checkSectionState(section)

        --POTS
        section = br.ui:createSection(br.ui.window.profile, "Pots")
        br.ui:createSpinner(section, "Mana Potion", 50, 0, 100, 1, "Mana Percent to Cast At")
        --br.ui:createDropdownWithout(section, "Pots - 1 target (Boss)", { "None", "Potion of Spectral Intellect", "Potion of Phantom Fire" }, 1, "", "Use Pot when Avenging Wrath/Crusader is up")
        --br.ui:createDropdownWithout(section, "Pots - 2-3 targets", { "None", "Potion of Spectral Intellect", "Potion of Phantom Fire" }, 1, "", "Use Pot when Avenging Wrath/Crusader is up")
        --br.ui:createDropdownWithout(section, "Pots - 4+ target", { "None", "Potion of Spectral Intellect", "Potion of Phantom Fire" }, 1, "", "Use Pot when Avenging Wrath/Crusader is up")
        br.ui:checkSectionState(section)

        -- Interrutps
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section, "Hammer of Justice")
        br.ui:createCheckbox(section, "Rebuke")
        br.ui:createCheckbox(section, "Blinding Light")
        br.ui:createSpinner(section, "InterruptAt", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        
    end -- end rotations options



        -- M+ Options
        local function mplusoptions()
            section = br.ui:createSection(br.ui.window.profile, "M+ Settings")
            -- m+ Rot
            br.ui:createSpinner(section, "Grievous Wounds", 2, 0, 10, 1, "Enables/Disables GrievousWound")
            br.ui:createSpinner(section, "Infused Holy Light Grievous", 70, 0, 100, 5, "", "Health Percent to Cast At")
            --br.ui:createCheckbox(section, "DBM/BW Precast CDs", "Uses DBM (ONLY DBM) to precast mitigation spells", 1)
            --br.ui:createCheckbox(section, "Pride Heal")
            br.ui:checkSectionState(section)
        end

        -- Out of combat options
        local function oocoptions()
            section = br.ui:createSection(br.ui.window.profile, "OOC Settings")
            br.ui:createSpinner(section, "Auto Drink", 45, 0, 100, 5, "Mana Percent to Drink At")
            br.ui:createCheckbox(section, "OOC Glimmer", "Enables/Disables glimmer out of combat", 1)
            br.ui:createSpinnerWithout(section, "OOC Holy Heal - Time", 1, 0, 10, 5, "When I havent moved for x seconds")
            br.ui:createSpinnerWithout(section, "OOC Holy Heal - Mana", 60, 0, 100, 5, "and my mana is above")
            br.ui:createSpinnerWithout(section, "OOC Holy Heal - Health", 90, 0, 100, 5, "and peoples health are below")
            br.ui:checkSectionState(section)
        end

        optionTable = {
            {
                [1] = "Rotation Options",
                [2] = rotationOptions,
            },
            {
                [1] = "M+ Options",
                [2] = mplusoptions,
            },
            {
                [1] = "Out of Combat",
                [2] = oocoptions,
            }
    
        }
        return optionTable
end -- end all options

----Locals
local AssFlag
local buff
local cast
local cd
local charges
local debuff
local enemies
local equiped
local gcd
local gcdMax
local has
local racial
local inCombat
local item
local eating
local inInstance
local inRaid
local level
local solo
local stun
local mode
local ui
local php
local talent
local tuftTargetHP
local lowest
local units
local tanks
local unit
local use
local haltProfile
local hastar
local healPot
local profileStop
-- NEED FIX ID drinking
local drinking = br.getBuffRemain("player", 396162) ~= 0 or br.getBuffRemain("player", 167152) ~= 0 or br.getBuffRemain("player", 192001) ~= 0 or br.getDebuffRemain("player", 185710) ~= 0 or br.getDebuffRemain("player", 297098) ~= 0 or br.getDebuffRemain("player", 274914) ~= 0
-- NEED FIX ID drinking
local ttd
local canDPS
local burst
local Burststack = 0
local BleedFriendCount = 0
local BleedStack = 0
local healTarget
local healReason
local healTargetHealth
local holyPower
local holyPowerMax

--lists PRE FREEDOM(DBM TIMER) change ID if needed

local pre_BoF_list = {
    --[320788] = { targeted = true }, --"NW Last boss",
    --[324608] = { targeted = true }, --]/charged-stomp
    --[317231] = { targeted = nil }, --/crushing-slam
    --[320729] = { targeted = nil }, --/massive-cleave
}

-- Stun list basic list HoJ targets - format  MOB_ID, CAST_ID, CHAN_ID, BUFF_ID, AGGRO_FLAG, NOTES
local stunList = {
    [168319] = { CAST_ID = nil, CHAN_ID = nil, BUFF_ID = nil, AGGRO_FLAG = nil, NOTES = "TEST MOB" },
    [174773] = { CAST_ID = nil, CHAN_ID = nil, BUFF_ID = nil, AGGRO_FLAG = 1, NOTES = "Affix - Stun Spiteful" },
    [187969] = { CAST_ID = "372735", CHAN_ID = nil, BUFF_ID = nil, AGGRO_FLAG = nil, NOTES = "RUBY - Flashfrost Earthshaper CC Logic" },
    [190206] = { CAST_ID = nil, CHAN_ID = "373972", BUFF_ID = nil, AGGRO_FLAG = nil, NOTES = "RUBY - Primalist Flamedancer Trash CC Logic" },
    [197509] = { CAST_ID = "392398", CHAN_ID = nil, BUFF_ID = nil, AGGRO_FLAG = nil, NOTES = "RUBY - Primal Thundercloud Trash CC Logic" },
    [197985] = { CAST_ID = "392451", CHAN_ID = nil, BUFF_ID = nil, AGGRO_FLAG = nil, NOTES = "RUBY - Flame Channeler Trash CC Logic" },
    [192796] = { CAST_ID = "383723", CHAN_ID = nil, BUFF_ID = nil, AGGRO_FLAG = nil, NOTES = "NOKHUD - Nokhud Hornsounder Trash CC Logic" },
    [192789] = { CAST_ID = "384476", CHAN_ID = nil, BUFF_ID = nil, AGGRO_FLAG = nil, NOTES = "NOKHUD - Nokhud Longbow Trash CC Logic" },
    [189886] = { CAST_ID = "373017", CHAN_ID = nil, BUFF_ID = nil, AGGRO_FLAG = nil, NOTES = "RUBY - STORM" },
}

-- basic functions
local function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function already_stunned(unit)
    if unit == nil then
        br._G.print("error")
        return false
    end
    local already_stunned_list = {
        [105421] = "Blinding Light",
        [47481] = "Gnaw",
        [5211] = "Mighty Bash",
        [22570] = "Maim",
        [19577] = "Intimidation",
        [119381] = "Leg Sweep",
        [853] = "Hammer of Justice",
        [408] = "Kidney Shot",
        [1833] = "Cheap Shot",
        [199804] = "Between the eyes",
        [107570] = "Storm Bolt",
        [46968] = "Shockwave",
        [221562] = "Asphyxiate",
        [91797] = "Monstrous Blow",
        [179057] = "Chaos Nova",
        [211881] = "Fel Eruption",
        [1822] = "Rake",
        [192058] = "Capacitor Totem",
        [118345] = "Pulverize",
        [89766] = "Axe Toss",
        [30283] = "Shadowfury",
        [1122] = "Summon Infernal",
    }
    for i = 1, 22 do
        -- br._G.print(select(10, UnitDebuff(Unit, i)))
        local debuffSpellID = select(10, br._G.UnitDebuff(unit, i))
        -- br._G.print(tostring(already_stunned_list[tonumber(debuffSpellID)]))
        if already_stunned_list[tonumber(debuffSpellID)] ~= nil then
            return true
        end
        --   if debuffSpellID == nil then
        --        return false
        --     end
    end
    return false
end

--can we heal? 
local function canheal(unit)
    if br.GetUnitIsUnit(unit, "player")
            or br._G.UnitIsPlayer(unit)
            and br._G.UnitInRange(unit)
            --and not br.UnitBuffID(unit, 327140) --forgeborne-reveries old content
            and (not br.UnitBuffID(unit, 108978) or br.getHP(unit) < ui.value("Critical HP")) --mages ...
            and br.getLineOfSight(unit, "player")
            and not br.GetUnitIsDeadOrGhost(unit)
            and br.GetUnitIsFriend(unit, "player") then
        return true
    else
        return false
    end
end

--Consecration
local function consecration()
    if mode.DPS == 1 and (canDPS or br.SpecificToggle("DPS Key"))
            and cast.able.consecration()
            and not br.isMoving("player")
            and not buff.holyAvenger.exists()
            and (cd.holyShock.remain() > gcd * 1.5 and charges.crusaderStrike.count() == 0 or #enemies.yards8 >= 2)
    then
        for i = 1, #enemies.yards8 do
            if not debuff.consecration.exists(enemies.yards8[i])
                    or br._G.GetTotemTimeLeft(1) < 2 then
                if cast.consecration() then
                end
            end
        end
    end
end

-- spellqueue ready
local function spellQueueReady()
    --Check if we can queue cast
    local castingInfo = { br._G.UnitCastingInfo("player") }
    if castingInfo[5] then
        if (br._G.GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow"))) / 1000)) < 0 then
            --     Print((GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow"))) / 1000)))
            return false
        end
        --       Print((GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow"))) / 1000)))
    end
    return true
end

-- timers
local timers = {}
timers._timers = {}
function timers.time(name, fn)
    local time = timers._timers[name]
    if fn then
        if not time then
            time = br._G.GetTime()
        end
    else
        time = nil
    end
    timers._timers[name] = time
    return time and (br._G.GetTime() - time) or 0
end

------------------------------------------------
local function isCC(unit)
    if br.getOptionCheck("Don't break CCs") then
        return br.isLongTimeCCed(Unit)
    end
end

local function noDamageCheck(unit)
    if isCC(unit) then
        return true
    end 
    if br.hasBuff(113309, unit) then
         --2nd boss shield jade temple
        return true
    end
    return false --catchall
end

--start DMB list
local precast_spell_list = {
    -- MORE OLD STUFF NEED CHANGE CAST ID 
    --spell_id	, precast_time	,	spell_name,     spell to cast
    --{ 322759, 1.5, "Blood Barrier", "devotionAura" }, -- DOS Hakkar
    --{ 320141, 1.5, "Diabolical Dooooooom!", "devotionAura" }, -- DOS Manastorms
    --{ 320230, 1.5, "Explosive Contrivance", "devotionAura" }, -- DOS Dealer
    --{ 319733, 1.5, "Stone Call", "devotionAura" }, -- HOA Echelon
    --{ 323552, 1.5, "Volley of Power", "devotionAura" }, -- HOA Adjugator
    --{ 328791, 1.5, "Ritual of Woe", "devotionAura" }, -- HOA Lord Chamberlain
    --{ 325360, 1.5, "Rite of Supremacy", "devotionAura" } -- SD Grand Proctor Beryllia


}
--end of dbm list

-- Cone heal for LoD
local function bestConeHeal(spell, minUnits, health, angle, rangeInfront, rangeAround)
    if not br.isKnown(spell) or br.getSpellCD(spell) ~= 0 or select(2, br._G.IsUsableSpell(spell)) then
        return false
    end
    local curFacing = br._G.ObjectFacing("player")
    local playerX, playerY, _ = br._G.ObjectPosition("player")
    local coneTable = {}

    local unitsAround = 0
    for i = 1, #br.friend do
        local thisUnit = br.friend[i].unit
        if br.friend[i].hp < health then
            if br.friend[i].distance < rangeAround then
                unitsAround = unitsAround + 1
            elseif br.friend[i].distance < rangeInfront then
                local unitX, unitY, _ = br._G.ObjectPosition(thisUnit)
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
        if br._G.IsMouselooking() then
            mouselookActive = true
            br._G.MouselookStop()
            br._G.TurnOrActionStop()
        end
        br._G.FaceDirection(bestAngle, true)
        br._G.CastSpellByName(br._G.GetSpellInfo(spell))
        br._G.FaceDirection(curFacing)
        if mouselookActive then
            br._G.MouselookStart()
        end
        lodFaced = true
        return true
    end
    return false
end

local actionList = {}
local CC_CreatureTypeList = { "Humanoid", "Demon", "Undead", "Dragonkin", "Giant" }
local StunsBlackList = {
    -- 8.3 tier 4 adds
     -- [161244] = "Blood of the Corruptor",
}

local HOJ_unitList = {
    --[131009] = "Spirit of Gold",
}

noconc_list = {
    --[161124] = "urgroth - breaker - of - heroes",
}

-- HARD DPS KEY
local function HardDPSkey()
    -- Hard DPS SOTR
    if cast.able.shieldOfTheRighteous() and (holyPower >= 3 or buff.divinePurpose.exists()) then
        if cast.shieldOfTheRighteous() then
            br.addonDebug("[HARDKEY] SOTR")
            return true
        end
    end
    -- Hard DPS Hammer
    if br.player.inCombat and br._G.IsSpellOverlayed(24275) and holyPower < 5 then
        if not noDamageCheck("target") and not br._G.UnitIsPlayer("target") and br.getFacing("player", "target") and br.UnitIsTappedByPlayer("target") and (not cd.holyShock.ready() or holyPower == 2) then
            if cast.hammerOfWrath("target") then
                br.addonDebug("[HARDKEY] Hammer Time")
                return true
            end
        end
    end

    -- Hard DPS Consecrate, don't waste GCD during HA/DS Spam
    if not buff.holyAvenger.exists() and cd.holyShock.remain() > 1 then
        consecration()
    end

    -- Hard DPS Holy Shock
    if br.player.inCombat then
        if cd.holyShock.ready() and holyPower < 5 then
            if cast.holyShock("target") then
                br.addonDebug("[HARDKEY] ST DPS Holy Shock")
                return true
            end
        end
    end

    -- Hard DPS Talent Crusaders Might   - should only be used to get full value out of holy shock proc .. hard coded to 1.5
    if talent.crusadersMight and (talent.holyAvenger and buff.holyAvenger.exists() and holyPower < 3 or holyPower < 5)
            and not noDamageCheck(units.dyn5) and not br._G.UnitIsPlayer(units.dyn5) and br.getFacing("player", units.dyn5) and (br.getSpellCD(20473) > (gcd)) and ((holyPower == 2 and not cd.holyShock.ready) or cd.holyShock.remain() >= 1.5) then
        if cast.crusaderStrike(units.dyn5) then
            br.addonDebug("[HARDKEY]CrusaderStrike on " .. br._G.UnitName(units.dyn5) .. " CD/HS: " .. round(cd.holyShock.remain(), 2))
            return true
        end
    end

    -- Hard DPS Judgment
    if not buff.holyAvenger.exists() and cd.judgment.ready() and not cd.holyShock.ready() and inCombat then
        if not noDamageCheck("target") and not br._G.UnitIsPlayer("target") and br.getFacing("player", "target") and br.UnitIsTappedByPlayer("target") then
            if cast.judgment("target") then
                br.addonDebug("[HARDKEY] ST DPS Judgment")
                return true
            end
        end
    end
end

-- Hammer of wrath with WINGS or 20% HP
actionList.hammerOfWrathDPS = function()
    if br.player.inCombat and not cd.holyShock.ready() and ((buff.holyAvenger.exists() and holyPower < 3) or holyPower < 5) then
        if br._G.IsSpellOverlayed(24275) and br.getFacing("player", "target") and br.getDistance("target", "player") <= 30
                and not br.isExplosive("target") then
            if cast.hammerOfWrath("target") then
                br.addonDebug("[DPS] Hammer of Wrath 1")
                return true
            end
        else
            for i = 1, #enemies.yards30 do
                if unit.hp(enemies.yards30[i]) < 20 and br.getFacing("player", enemies.yards30[i]) and not br.GetUnitIsDeadOrGhost(enemies.yards30[i]) then
                    if br._G.CastSpellByName(br._G.GetSpellInfo(spell.hammerOfWrath), enemies.yards30[i]) then
                        br.addonDebug("[DPS] Hammer of Wrath2")
                        br._G.print("FOOO")
                        return true
                    end
                end
            end
        end
    end
end

-- GLIMMER (NEED SOME CHANGE FOR AGRESSIVE GLIMMER MULTI TARGET)
actionList.glimmer = function()

    -- br.player.ui.mode.DPS = br.data.settings[br.selectedSpec].toggles["DPS"]

    if cd.holyShock.ready() then
        local glimmerCount = 0
        for i = 1, #br.friend do
            if buff.glimmerOfLight.remain(br.friend[i].unit, "exact") > gcd then
                glimmerCount = glimmerCount + 1
            end
        end
        --[[ Glimmer support
        if ui.checked("Aggressive Glimmer") and br.player.ui.mode.DPS == 1 and br.player.inCombat and br._G.UnitIsEnemy("target", "player") and lowest.hp > ui.value("Critical HP") then
            if not debuff.glimmerOfLight.exists("target", "EXACT") and br.GetUnitExists("target") and br.getFacing("player", "target") then
                if cast.holyShock("target") then
                    br.addonDebug("[GLIM] Aggressive Glimmer on: " .. br._G.UnitName("target"))
                    return true
                end
            end
            if debuff.glimmerOfLight.exists("target", "EXACT") then
                glimmerCount = glimmerCount + 1
            end
        end]]

        if #tanks > 1 then
            --find lowest friend without glitter buff on them - tank first  for i = 1, #tanks do
            for i = 1, #tanks do
                if canheal(tanks[i].unit) then
                    if not br.UnitBuffID(tanks[i].unit, 287280) then
                        if cast.holyShock(tanks[i].unit) then
                            br.addonDebug("[GLIM] Tank-Glimmer on " .. br._G.UnitName(tanks[i].unit) .. "/" .. tostring(glimmerCount))
                            healTarget = "none"
                            return true
                        end
                    end
                end
            end
        end

        if mode.glimmer == 1 then
            glimmerTable = {}
            for i = 1, #br.friend do
                if (canheal(br.friend[i].unit) or br.friend[i].unit == "player") and not br.UnitBuffID(br.friend[i].unit, 287280, "PLAYER") and not br.UnitBuffID(br.friend[i].unit, 115191) then
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
            --[[ if glimmerCount ~= nil and glimmerCount >= 8 then
                 if cast.holyShock(lowest.unit) then
                     --Print("Glimmer cap glimmer")
                     return
                 end
             end]]
            if #glimmerTable > 0 and glimmerTable[1].unit ~= nil and mode.glimmer == 1 and canheal(glimmerTable[1].unit) then
                if cast.able.ruleOfLaw() and talent.ruleOfLaw and not buff.ruleOfLaw.exists("player") and inCombat then
                    if glimmerTable[1].distance ~= nil and glimmerTable[1].distance > 10 then
                        if cast.ruleOfLaw() then
                            --Print(br.getDistance(glimmerTable[1]))
                            br.addonDebug("[GLIM] Rule Of Law - distance: " .. tostring(glimmerTable[1].distance))
                            return true
                        end
                    end
                end
                if cast.holyShock(glimmerTable[1].unit) then
                    br.addonDebug("[GLIM] Glimmer on: " .. br._G.UnitName(glimmerTable[1].unit) .. "/" .. tostring(glimmerCount))
                    return true
                end
            end
        end
    end
end

-- CLEANSE
actionList.cleanse = function()
    
    if cd.cleanse.ready() and not cast.last.cleanse() then
        for i = 1, #br.friend do
            if br.canDispel(br.friend[i].unit, spell.cleanse) and canheal(br.friend[i].unit) then
                if (br.player.race == "DarkIronDwarf" or br.player.race == "Dwarf") and cast.able.racial() and br.friend[i].unit == "player" then
                    if cast.racial("player") then
                        return true
                    end
                end
                if cast.cleanse(br.friend[i].unit) then
                    return true
                end
            end
        end    
    end
end

-- OUT OF COMBAT FUNCTIONS
actionList.ooc = function()

    -- BEACON BUFF
    if ui.checked("Beacon of Light") and br.timer:useTimer("BEACTimer", 5) then
        if #tanks > 0 then
            if not buff.beaconOfLight.exists(tanks[1].unit) and not buff.beaconOfFaith.exists(tanks[1].unit) and br._G.UnitInRange(tanks[1].unit) then
                if cast.beaconOfLight(tanks[1].unit) then
                    return true
                end
            end
         if buff.beaconOfLight.exists(tanks[1].unit) and not buff.beaconOfFaith.exists("Player") then
            if cast.beaconOfFaith("Player") then
                return true
            end
        end
        elseif #tanks == 0 and not buff.beaconOfLight.exists("Player") then
            if cast.beaconOfLight("Player") then
                return true
            end
        end
    end
    
    --AUTO DRINK (NEED ADD FOOD\DRINK ID)
    if ui.checked("Auto Drink") and br.getMana("player") <= br.getOptionValue("Auto Drink") and not moving and br.getDebuffStacks("player", 240443) == 0 and br.getDebuffStacks("player", 226510) == 0 then
        --240443 == bursting
        -- 226510 == sanguine
        --drink list
        --[[
        item=65499/conjured getMana("player") cookies - TW food
        item=159867/rockskip-mineral-wate (alliance bfa)
        item=163784/seafoam-coconut-water  (horde bfa)
        item=113509/conjured-mana-bun
        item=126936/sugar-crusted-fish-feast ff
        ]]
    end

    -- HL TO HEAL IF NOTHING TO DO
    local standingTime = 0
    if br.DontMoveStartTime then
        standingTime = br._G.GetTime() - br.DontMoveStartTime
    end
    if not br.isMoving("Player") and standingTime > ui.value("OOC Holy Heal - Time") and not drinking and br.getMana("player") >= ui.value("OOC Holy Heal - Mana") and br.getHP(lowest.unit) < ui.value("OOC Holy Heal - Health") then
        if cast.holyLight(lowest.unit) then
            br.addonDebug("[HEAL] OOC HL")
            return true
        end
    end
end

-- DPS FUNCTIONS
actionList.dps = function()
    -- j / con / HS / CS   (dps())

    --Auto attack
    if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and #enemies.yards8 >= 1 then
        br._G.StartAttack(units.dyn5)
    end

    if br.isChecked("Divine Toll during DPS Key") and br.SpecificToggle("DPS Key") and not br._G.GetCurrentKeyBoardFocus() and #enemies.yards30 >= br.getValue("Divine Toll during DPS Key") then
        if cast.divineToll(units.dyn30) then
            return true
        end
    end

    -- Judgment of Light
    if talent.judgmentOfLight and not buff.holyAvenger.exists() and cast.able.judgment() and inCombat and lowest.hp > ui.value("Critical HP") then
        -- ST
        if br.getDebuffRemain("target", 196941) == 0 or #enemies.yards30 == 1 then
            if not noDamageCheck("target") and not br._G.UnitIsPlayer("target") and br.getFacing("player", "target") and br.UnitIsTappedByPlayer("target") then
                if cast.judgment("target") then
                    br.addonDebug("[HEAL] Judgment of Light ST")
                    return true
                end
            end
        end

        -- AOE
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if br.getDebuffRemain(thisUnit, 196941) == 0 or br.getDebuffRemain(thisUnit, 196941) < 10 then
                if not noDamageCheck(thisUnit) and not br._G.UnitIsPlayer(thisUnit) and br.getFacing("player", thisUnit) and br.UnitIsTappedByPlayer(thisUnit) then
                    if cast.judgment(thisUnit) then
                        br.addonDebug("[HEAL] Judgment of Light Spread")
                        -- br._G.print("FOOO")
                        return true
                    end
                end
            end
        end
    end

    --Judgment
    if not talent.judgmentofLight and cast.able.judgment() and cd.holyShock.remain() > 1 and lowest.hp > ui.value("Critical HP") then
        if #tanks == 0 or #tanks > 0 and br.getDistance(units.dyn30, tanks[1].unit) <= 10 then
            if br.getFacing("player", units.dyn30) then
                if cast.judgment(units.dyn30) then
                    br.addonDebug("[DPS]Judgment [" .. round(br.getHP(enemies.yards30[i]), 2) .. "/" .. round(br.getHP("player"), 2) .. "]")
                    return true
                end
            end
        end
    end

    -- Consecrate, don't waste GCD during HA/DS Spam
    if not buff.holyAvenger.exists() or not buff.divineShield.exists() then
        consecration()
    end

    if ui.checked("Group CD's with DPS key") and br.SpecificToggle("DPS Key") and not br._G.GetCurrentKeyBoardFocus() then
        -- popping CD's with DPS Key
        if cd.avengingWrath.ready() then
            if cast.avengingWrath() then
                return true
            end
        end
        if talent.holyAvenger and cd.holyAvenger.ready() then
            if cast.holyAvenger() then
                return true
            end
        end
        --trinkets w/CD
        if ui.checked("Trinket 1") and br.getOptionValue("Trinket 1 Mode") == 5 and inCombat then
            if br.canUseItem(13) then
                br.useItem(13)
            end
        end
        if ui.checked("Trinket 2") and br.getOptionValue("Trinket 1 Mode") == 5 and inCombat then
            if br.canUseItem(14) then
                br.useItem(14)
            end
        end
    end

    --using DPS trinkets
    if canDPS then
        if ui.checked("Trinket 1") and br.getOptionValue("Trinket 1 Mode") == 4 and inCombat then
            if br.canUseItem(13) then
                br.useItem(13)
            end
        end
        if ui.checked("Trinket 2") and br.getOptionValue("Trinket 2 Mode") == 4 and inCombat then
            if br.canUseItem(14) then
                br.useItem(14)
            end
        end
    end
end

-- extras
actionList.Extra = function()

    if br.SpecificToggle("Turn Evil Key") and not br._G.GetCurrentKeyBoardFocus() then
        br._G.CastSpellByName(br._G.GetSpellInfo(spell.turnEvil), "mouseover")
        return
    end
    if br.SpecificToggle("Repentance Key") and not br._G.GetCurrentKeyBoardFocus() then
        br._G.CastSpellByName(br._G.GetSpellInfo(spell.repentance), "mouseover")
        return
    end

    if br.SpecificToggle("DPS Key") and not br._G.GetCurrentKeyBoardFocus() then
        if HardDPSkey() then
            return true
        end
    end


    -- Light of Martyr spam with Divine shield
    if ui.checked("Light of the Martyr") and ui.checked("LOTM Spam with Divine shield")
            and buff.divineShield.exists() and not cast.able.holyShock() and php > 60 then
        if healTarget == "none" and cast.able.lightOfTheMartyr()
                and not br.GetUnitIsUnit(lowest.unit, "player")
                and canheal(lowest.unit) then
            healTarget = lowest.unit
            healReason = "SPAM"
        end
        if healTarget ~= "none" and not br.GetUnitIsUnit(healTarget, "player") then
            healTargetHealth = round(br.getHP(healTarget), 1)
            if canheal(healTarget) then
                if cast.lightOfTheMartyr(healTarget) then
                    br.addonDebug("[" .. healReason .. "] lightOfTheMartyr on: " .. br._G.UnitName(healTarget) .. "/" .. healTargetHealth)
                    healTarget = "none"
                    return true
                end
            end
        end
    end

    if lowest.hp > ui.value("Critical HP") and (not buff.holyAvenger.exists() or not buff.divineShield.exists()) and cd.holyShock.remain() > 1 then
        consecration()
    end

    --blessing of freedom need add debuff on BoF_List
    if inCombat and mode.freedom == 1 and cd.blessingOfFreedom.ready() then
        if cast.able.blessingOfFreedom() then
            local endCast, spellcastID, spellTarget
            for i = 1, #enemies.yards40 do
                _, _, _, _, endCast, _, _, _, spellcastID = br._G.UnitCastingInfo(enemies.yards40[i])
                if spellcastID ~= nil then
                    local unitBOF = pre_BoF_list[spellcastID]
                    if unitBOF and unitBOF.targeted == true then
                        spellTarget = select(3, br._G.UnitCastID(enemies.yards40[i]))
                    elseif unitBOF and unitBOF.targeted ~= true then
                        spellTarget = "player"
                    end
                end
            end
            if spellTarget ~= nil and canheal(spellTarget) and endCast and pre_BoF_list[spellcastID]
                    and ((endCast / 1000) - br._G.GetTime()) < 1.2
                    and ((endCast / 1000) - br._G.GetTime()) > 0 then
                if cast.blessingOfFreedom(spellTarget) then
                    return true
                end
            end

            -- Debuff
            local BoFDebuff = { 207278, 387150, 388777 } 
            for k, v in pairs(BoFDebuff) do
                if br.getDebuffRemain("player", v) ~= 0 then
                    if cast.blessingOfFreedom("player") then
                        return true
                    end
                end
                for i = 1, #br.friend do
                    if br.getDebuffRemain(br.friend[i].unit, v) ~= 0 then
                        if cast.blessingOfFreedom(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            end
        end
    end
    
    -- Blessing of Protection
    if ui.checked("Blessing of Protection") and cd.blessingOfProtection.ready() and inCombat then
        for i = 1, #br.friend do
            if br.friend[i].hp <= ui.value("Blessing of Protection")
                    --old stuff need changes ID
                    --or br.getDebuffRemain(br.friend[i].unit, 323406) ~= 0 --323406/jagged-gash
                    --or br.getDebuffRemain(br.friend[i].unit, 324154) ~= 0 --324154 / dark - stride
                    --or br.getDebuffRemain(br.friend[i].unit, 335306) ~= 0 --335306/barbed shackle
                    --or br.getDebuffRemain(br.friend[i].unit, 323020) ~= 0 --323020/bloodletting
                    --or br.getDebuffStacks(br.friend[i].unit, 240443) >= 3 --322796/wickedgash>3
                    --or br.getDebuffRemain(br.friend[i].unit, 326827) > 3 --326827/dreadbindings
                    --or br.getDebuffRemain(br.friend[i].unit, 322429) ~= 0 --322429/severing-slice
                    --or br.getDebuffRemain(br.friend[i].unit, 333861) ~= 0 --333861/ricocheting-blade
                    --or br.getDebuffRemain(br.friend[i].unit, 326827) > 3 --343555/morbid-fixation
            then
                if not debuff.forbearance.exists(br.friend[i].unit) and canheal(br.friend[i].unit)
                        and not (br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")
                then
                    if cd.divineShield.ready() and br.GetUnitIsUnit(br.friend[i].unit, "player") then
                        if cast.divineShield() then
                            return true
                        end
                    else
                        if cast.blessingOfProtection(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            end
        end
    end

    -- I like DBM
    if ui.checked("DBM/BW Precast CDs") and cd.devotionAura.ready() and inCombat then
        for i = 1, 7 do
            local boss_spell_id = precast_spell_list[i][1]
            local precast_time = precast_spell_list[i][2]
            local spell_name = precast_spell_list[i][3]
            local spelltocast = precast_spell_list[i][4]
            local time_remain = br.DBM:getTimer(boss_spell_id)
            --    local time_remain = br.DBM:getPulltimer(nil, boss_spell_id)
            --   br._G.print(spelltocast)
            -- Cast things for boss encounter
            if spelltocast == "devotionAura" and time_remain < precast_time then
                if cast.auraMastery("player") then
                    br.addonDebug("[PRE-DBM] Devo (" .. spell_name .. ")")
                    return true
                end
            end
        end
    end
    -- aura replacement(need add check talent\add change on spell.lua???)
    if ui.checked("Automatic Aura replacement") then
        if not buff.devotionAura.exists() and (not br._G.IsMounted() or buff.divineSteed.exists()) then
            if cast.devotionAura("player") then
                return
            end
        elseif not buff.crusaderAura.exists() and br._G.IsMounted() then
            if cast.crusaderAura("player") then
                return
            end
        end
    end

    if inCombat and mode.stuns == 1 and (talent.blindingLight and cd.blindingLight.ready() or cd.hammerOfJustice.ready()) then
        for i = 1, br._G.GetObjectCount() do
            local object = br._G.GetObjectWithIndex(i)
            local ID = br._G.ObjectID(object)
            local unitStun = stunList[ID]

            if unitStun ~= nil and br.getBuffRemain(object, 226510) == 0
                    and not br.GetUnitIsDeadOrGhost(object)
                    and not already_stunned(object)
                    and not br.isLongTimeCCed(object)
                    and br.getDistance(object) <= 10
            then
                if ((not unitStun.AGGRO_FLAG or br.GetUnitIsUnit("player", br._G.UnitTarget(object)))
                        and (
                        (unitStun.CAST_ID and br.isCasting(unitStun.CAST_ID))
                                or unitStun.CHAN_ID and br._G.UnitCastingInfo(object) == GetSpellInfo(unitStun.CHAN_ID)
                                or unitStun.BUFF_ID and br.getBuffRemain(object, unitStun.BUFF_ID) > 0
                                or not unitStun.CAST_ID and not unitStun.CHAN_ID and not unitStun.BUFF_ID)
                )
                then
                    br.addonDebug(tostring(already_stunned(object)))

                    if cast.hammerOfJustice(object) then
                        br.addonDebug("[STUN]: Hammer on " .. br._G.UnitName(object))
                        return true
                    end
                    if cast.blindingLight() then
                        br.addonDebug("[STUN]: BlindingLight")
                        return true
                    end
                end
            end
        end -- end stun
    end -- end radar

end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if br.useDefensive() then
        
        --Healthstone / Heathpots :  156634 == Silas Vial of Continuous curing / 5512 == warlock health stones
        if ui.checked("Pot/Stoned") and php <= ui.value("Pot/Stoned") and (br.hasHealthPot() or br.hasItem(5512) or br.hasItem(156634)) then
            if br.canUseItem(5512) then
                br.useItem(5512)
            elseif br.canUseItem(191380) then
                br.useItem(191380)
            end
        end


        -- Gift of the Naaru
        if ui.checked("Gift of The Naaru") and php <= br.getOptionValue("Gift of The Naaru") and php > 0 and br.player.race == "Draenei" then
            if castSpell("player", racial, false, false, false) then
                return true
            end
        end

        -- Divine Shield
        if ui.checked("Divine Shield") and cd.divineShield.ready() and not br.UnitDebuffID("player", 25771) then
            if (php <= br.getOptionValue("Divine Shield")) --health check
            then
                if cast.divineShield() then
                    return true
                end
            end
        end

        --	Divine Protection
        if ui.checked("Divine Protection") and cd.divineProtection.ready() and not buff.divineShield.exists("player") then
            if php <= br.getOptionValue("Divine Protection") then
                if cast.divineProtection() then
                    return true
                end
            elseif buff.blessingOfSacrifice.exists("player") and php <= 80 then
                if cast.divineProtection() then
                    return true
                end
            end
        end

        -- Blessing of Freedom
        if mode.freedom ~= 1 and ui.checked("Blessing of Freedom") and cd.blessingOfFreedom.ready() and br.hasNoControl(spell.blessingOfFreedom) then
            if cast.blessingOfFreedom("player") then
                return true
            end
        end
    end
end -- End Action List - Defensiv

--Interrupts
actionList.Interrupt = function()

    if ui.checked("Hammer of Justice") and cd.hammerOfJustice.ready() then
        for i = 1, #br.friend do
            if UnitIsCharmed(br.friend[i].unit) and br.getDebuffRemain(br.friend[i].unit, 272407) == 0 and br.friend[i].distance <= 10 then
                if cast.hammerOfJustice(thisUnit) then
                    return true
                end
            end
        end

        -- NEED CHANGE\ADD ID IN HoJ LIST!!!!!!
        --[[local HOJ_list = {
            -- [274400] = true,

        }
        for i = 1, #enemies.yards10 do
            local thisUnit = enemies.yards10[i]
            local distance = br.getDistance(thisUnit)
            if (HOJ_unitList[br.GetObjectID(thisUnit)] ~= nil or HOJ_list[select(9, br._G.UnitCastingInfo(thisUnit))] ~= nil or HOJ_list[select(7, br._G.GetSpellInfo(br._G.UnitChannelInfo(thisUnit)))] ~= nil) and br.getBuffRemain(thisUnit, 226510) == 0 and distance <= 10 then
                if cast.hammerOfJustice(thisUnit) then
                    return true
                end
            end
        end]]
    end


    if br.useInterrupts() and (cd.blindingLight.ready() or cd.hammerOfJustice.ready()) and (ui.checked("Hammer of Justice") or ui.checked("Blinding Light")) then
        for i = 1, #enemies.yards10 do
            local thisUnit = enemies.yards10[i]
            local distance = br.getDistance(thisUnit)
            if br.canInterrupt(thisUnit, 99) and distance <= 10 and not br.isBoss(thisUnit) and StunsBlackList[br.GetObjectID(thisUnit)] == nil and br._G.UnitCastingInfo(thisUnit) ~= br._G.GetSpellInfo(257899) and br._G.UnitCastingInfo(thisUnit) ~= br._G.GetSpellInfo(258150) and br._G.UnitCastingInfo(thisUnit) ~= br._G.GetSpellInfo(252923) then
                -- Blinding Light
                if ui.checked("Blinding Light") then
                    if cast.blindingLight() then
                        return true
                     end
                 end
                 -- Hammer of Justice
                    if ui.checked("Hammer of Justice") and cd.hammerOfJustice.ready()
                        and br.getBuffRemain(thisUnit, 226510) == 0 -- never stun in Sanguine
                        and not br.isExplosive(thisUnit)
                       then
                      if cast.hammerOfJustice(thisUnit) then
                        return true
                    end
                end
            end
        end
    end
    -- Repentance as interrupt
    --[[if br.useInterrupts() and talent.repentance and cd.repentance.ready() and ui.checked("Repentance as Interrupt") then
        for i = 1, #enemies.yards30 do
            thisUnit = enemies.yards30[i]
            if br.canInterrupt(thisUnit, 99) and br._G.getCastTimeRemain(thisUnit) > br._G.getCastTime(spell.repentance) and StunsBlackList[br.GetObjectID(thisUnit)] == nil and not br.isBoss(thisUnit) and br._G.UnitCastingInfo(thisUnit) ~= br._G.GetSpellInfo(257899) and br._G.UnitCastingInfo(thisUnit) ~= br._G.GetSpellInfo(258150) and br._G.UnitCastingInfo(thisUnit) ~= br._G.GetSpellInfo(252923) and br._G.UnitCreatureType(thisUnit) == CC_CreatureTypeList[i] then
                if cast.repentance(thisUnit) then
                    return true
                end
            end
        end
    end]]
    -- Rebuke Interrupt
    if talent.rebuke and cd.rebuke.ready() and ui.checked("Rebuke") then 
        for i = 1, #enemies.yards10 do
            thisUnit = enemies.yards10[i]
            local distance = br.getDistance(thisUnit)
            if br.canInterrupt(thisUnit, 99) and distance <= 5 then
                if cast.rebuke(thisUnit) then
                    return true
                end
            end
        end
    end
end -- End Action List - Interrupt

--COOLDOWNS
actionList.Cooldown = function()

    -- Mana Potion
    if ui.checked("Mana Potion") and br.player.power.mana.percent() <= ui.value("Mana Potion") then
        if br.hasItem(191386) and br.canUseItem(191386) then
            br.useItem(191386)
        end
    end

    -- Arcane Torrent

    -- br._G.print(tostring(br.player.getRacial()))
    if br.player.race == "BloodElf" and br.getSpellCD(155145) == 0 and inCombat then
        if ui.checked("Arcane Torrent Dispel") then
            local torrentUnit = 0
            for i = 1, #enemies.yards8 do
                local thisUnit = enemies.yards8[i]
                if br.canDispel(thisUnit, select(7, br._G.GetSpellInfo(br._G.GetSpellInfo(69179)))) then
                    torrentUnit = torrentUnit + 1
                    if torrentUnit >= br.getOptionValue("Arcane Torrent Dispel") then
                        br._G.CastSpellByName(br._G.GetSpellInfo(155145))
                        --     if br.castSpell("player", racial, false, false, false) then
                        return true
                    end
                    break
                end
            end
        end
        if ui.checked("Arcane Torrent Mana") and br.player.power.mana.percent() < ui.value("Arcane Torrent Mana") then
            br._G.CastSpellByName(br._G.GetSpellInfo(155145))
            return true
        end
        if ui.checked("Arcane Torrent HolyPower") then
            if talent.holyAvenger and ((not cd.holyAvenger.ready() and cd.holyAvenger.remain() < 120) or buff.holyAvenger.exists()) or not talent.holyAvenger
                    and (buff.holyAvenger.exists() and holyPower < 3 or holyPower < 5) then
                br._G.CastSpellByName(br._G.GetSpellInfo(155145))
                return true
            end
        end
    end

    -- Seraphim
    if ui.checked("Seraphim") and talent.seraphim and holyPower > 2 and br.getTTD("target") > br.getOptionValue("Seraphim") then
        if cast.seraphim() then
            return true
        end
    end

    -- Lay on Hands        --LoH / LayonHands
    if ui.checked("Lay on Hands") and cd.layOnHands.ready() and not debuff.forbearance.exists(lowest.unit) and canheal(lowest.unit) then
        if timers.time("LoH Timer", lowest.hp <= ui.value("Lay on Hands")) > 0.8 then
            if cast.layOnHands(lowest.unit) then
                return true
            end
        end
    end

    -- Divine Toll(some questions about choosing a target???)
    if br.isChecked("Divine Toll") and cast.able.divineToll() and (holyPower <= br.getValue("Max Holy Power") or br.getDebuffStacks(lowest.unit, 240443) >= 4) then
        if br.getOptionValue("Divine Toll") == 1 and holyPower == 0 then
            if cast.divineToll(lowest.unit) then
                return true
            end
        end
        if br.getOptionValue("Divine Toll") == 2 then
            if br.getLowAllies(br.getValue("Divine Toll Health")) >= br.getValue("Divine Toll Units") then
                if cast.divineToll(lowest.unit) then
                    return true
                end
            end
        end
    end


    -- Blessing of Sacrifice
    if ui.checked("Blessing of Sacrifice") and cd.blessingOfSacrifice.ready() and inCombat then
        if br.getOptionValue("BoS Target") == 2 then
            -- tank only
            for i = 1, #tanks do
                if tanks[i].hp <= ui.value("Blessing of Sacrifice") then
                    if cast.blessingOfSacrifice(tanks[i].unit) then
                        return true
                    end
                end
            end
        elseif br.getOptionValue("BoS Target") == 1 then
            -- "all"
            for i = 1, #br.friend do
                if br.friend[i].hp <= ui.value("Blessing of Sacrifice") and not br.GetUnitIsUnit(br.friend[i].unit, "player") then
                    if cast.blessingOfSacrifice(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end
    end


    -- Trinkets
    if ui.checked("Trinket 1") and br.canUseItem(13) then
        if br.getOptionValue("Trinket 1 Mode") == 1 then
            if br.getLowAllies(br.getOptionValue("Trinket 1")) >= br.getOptionValue("Min Trinket 1 Targets") then
                br.useItem(13)
                return true
            end
        elseif br.getOptionValue("Trinket 1 Mode") == 2 then
            for i = 1, #br.friend do
                if br.friend[i].hp <= ui.checked("Trinket 1") then
                    br._G.UseItemByName(select(1, _G.GetInventoryItemID("player", 13)), br.friend[i].unit)
                    return true
                end
            end
        elseif br.getOptionValue("Trinket 1 Mode") == 3 and #tanks > 0 then
            for i = 1, #tanks do
                -- get the tank's target
                local tankTarget = br._G.UnitTarget(tanks[i].unit)
                if tankTarget ~= nil then
                    -- get players in melee range of tank's target
                    local meleeFriends = br.getAllies(tankTarget, 5)
                    -- get the best ground circle to encompass the most of them
                    local loc
                    if #meleeFriends >= 8 then
                        loc = br.getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                    else
                        local meleeHurt = {}
                        for j = 1, #meleeFriends do
                            if meleeFriends[j].hp < ui.checked("Trinket 1") then
                                br._G.tinsert(meleeHurt, meleeFriends[j])
                            end
                        end
                        if #meleeHurt >= ui.checked("Min Trinket 1 Targets") or burst == true then
                            loc = br.getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                        end
                    end
                    if loc ~= nil then
                        br.useItem(13)
                        br._G.ClickPosition(loc.x, loc.y, loc.z)
                        return true
                    end
                end
            end
        elseif br.getOptionValue("Trinket 1 Mode") == 4 and inCombat then
            if br.canUseItem(13) then
                br.useItem(13)
            end
        end
    end

    if ui.checked("Trinket 2") and br.canUseItem(14) then
        if br.getOptionValue("Trinket 2 Mode") == 1 then
            if br.getLowAllies(ui.value("Trinket 2")) >= ui.value("Min Trinket 2 Targets") then
                br.useItem(14)
                return true
            end
        elseif br.getOptionValue("Trinket 2 Mode") == 2 then
            for i = 1, #br.friend do
                if br.friend[i].hp <= ui.value("Trinket 2") then
                    br._G.UseItemByName(select(1, _G.GetInventoryItemID("player", 14)), br.friend[i].unit)
                    return true
                end
            end
        elseif br.getOptionValue("Trinket 2 Mode") == 3 and #tanks > 0 then
            for i = 1, #tanks do
                -- get the tank's target
                local tankTarget = br._G.UnitTarget(tanks[i].unit)
                if tankTarget ~= nil then
                    -- get players in melee range of tank's target
                    local meleeFriends = br.getAllies(tankTarget, 5)
                    -- get the best ground circle to encompass the most of them
                    local loc
                    if #meleeFriends >= 8 then
                        loc = br.getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                    else
                        local meleeHurt = {}
                        for j = 1, #meleeFriends do
                            if meleeFriends[j].hp < ui.value("Trinket 2") then
                                br._G.tinsert(meleeHurt, meleeFriends[j])
                            end
                        end
                        if #meleeHurt >= ui.checked("Min Trinket 2 Targets") or burst == true then
                            loc = br.getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                        end
                    end
                    if loc ~= nil then
                        br.useItem(14)
                        br._G.ClickPosition(loc.x, loc.y, loc.z)
                        return true
                    end
                end
            end
        elseif br.getOptionValue("Trinket 1 Mode") == 4 then
            if br.canUseItem(14) and ttd(units.dyn40) > 5 then
                br._G.UseItemByName(select(1, _G.GetInventoryItemID("player", 14)), units.dyn40)
                return true
            end
        end
    end

    -- Holy Avenger
    if ui.checked("Holy Avenger") and cd.holyAvenger.ready() and talent.holyAvenger then
        if br.getLowAllies(ui.value("Holy Avenger")) >= ui.value("Holy Avenger Targets") then
            if cast.holyAvenger() then
                return true
            end
        end
    end
    -- Avenging Wrath
    if ui.checked("Avenging Wrath") and cd.avengingWrath.ready() and not talent.avengingCrusader then
        if br.getLowAllies(ui.value("Avenging Wrath")) >= ui.value("Avenging Wrath Targets") then
            if cast.avengingWrath() then
                return true
            end
        end
    end
    -- Avenging Crusader
    if ui.checked("Avenging Crusader") and cd.avengingCrusader.ready() and talent.avengingCrusader and br.getDistance("target") <= 5 then
        if br.getLowAllies(ui.value("Avenging Crusader")) >= ui.value("Avenging Crusader Targets") then
            if cast.avengingCrusader() then
                return true
            end
        end
    end
    -- Aura Mastery
    if ui.checked("Aura Mastery") and cd.auraMastery.ready() then
        if br.getLowAllies(ui.value("Aura Mastery")) >= ui.value("Aura Mastery Targets") then
            if cast.auraMastery() then
                return true
            end
        end
    end

end -- End Action List - Cooldowns

actionList.bossfight = function()
end

--HOLYPOWER GENERATORS
actionList.generators = function()

    -- Blessing of the Seasons
if talent.blessingOfSummer and ui.checked("Blessing of the Seasons") then
    if cast.able.blessingOfSummer() then
        if cast.blessingOfSummer("player") then
            br.addonDebug("Blessing of Summer")
            return true
        elseif cast.able.blessingOfAutumn() then
            if cast.blessingOfAutumn("player") then
                br.addonDebug("Blessing of Autumn")
            end
        elseif cast.able.blessingOfWinter() then
            if cast.blessingOfWinter("player") then
                br.addonDebug("Blessing of Winter")
            end
        elseif cast.able.blessingOfSpring() then
            if cast.blessingOfSpring("player") then
                br.addonDebug("Blessing of Spring")
            end
        end
    end
end

    --Holyshock
    if cd.holyShock.ready() then
        if healTarget == "none" and mode.glimmer == 3 and #tanks > 0 and talent.glimmerOfLight then
            for i = 1, #tanks do
                if not br.UnitBuffID(tanks[i].unit, 287280, "PLAYER") and not br.UnitBuffID(tanks[i].unit, 115191) and canheal(tanks[i].unit) then
                    healTarget = tanks[i].unit
                    healReason = "GLIM-PRE"
                    if cast.holyShock(tanks[i].unit) then
                        healTarget = "none"
                        return true
                    end
                end
            end
        end
        if healTarget == "none" then
            if lowest.hp <= ui.value("Holy Shock") and canheal(lowest.unit) then
                healTarget = lowest.unit
                healReason = "HEAL"
                --        br.addonDebug("setting lowest to: " .. healTarget)
            end
        end
        if talent.glimmerOfLight and healTarget == "none" and mode.glimmer == 1 and (not br.player.inCombat or ui.checked("OOC Glimmer")) then
            for i = 1, #br.friend do
                if not buff.glimmerOfLight.exists(br.friend[i].unit, "exact") and canheal(br.friend[i].unit) then
                    healTarget = br.friend[i].unit
                    healReason = "GLIM"
                    break
                end
            end
        end

        if healTarget ~= "none" and canheal(healTarget) then
            healTargetHealth = round(br.getHP(healTarget), 1)
            if canheal(healTarget) then
                if cast.holyShock(healTarget) then
                    br.addonDebug("[" .. healReason .. "] Holyshock on: " .. br._G.UnitName(healTarget) .. "/" .. healTargetHealth)
                    healTarget = "none"
                    healReason = "none"
                    return true
                end
            end
        end
    end -- end holy shock

    -- DPS Holy Shock
    if ui.checked("Use Holy Shock for DPS")
            and mode.DPS == 1
            and br.player.inCombat
            and canDPS
            and cd.holyShock.ready()
            and holyPower < 5
    then
        -- ST
        if br.getDebuffRemain("target", 287268) == 0 or #enemies.yards30 == 1 then
            if not noDamageCheck("target") and not br._G.UnitIsPlayer("target") and br.getFacing("player", "target") and br.UnitIsTappedByPlayer("target") then
                if cast.holyShock("target") then
                    br.addonDebug("[GEN] ST DPS Holy Shock")
                    return true
                end
            end
        end
        -- AOE (not working change target)
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if br.getDebuffRemain(thisUnit, 287268) == 0 or br.getDebuffRemain(thisUnit, 287268) < 10 then
                if not noDamageCheck(thisUnit) and not br._G.UnitIsPlayer(thisUnit) and br.getFacing("player", thisUnit) and br.UnitIsTappedByPlayer(thisUnit) then
                    if cast.holyShock(thisUnit) then
                        br.addonDebug("[GEN] AoE DPS Holyshock")
                        -- br._G.print("FOOO")
                        return true
                    end
                end
            end
        end
        -- Use if nothing else
        if cast.holyShock("target") then
            br.addonDebug("[GEN] Never Holy Shock")
            return true
        end
    end

    --Talent Crusaders Might   - should only be used to get full value out of holy shock proc .. hard coded to 1.5
    if talent.crusadersMight and br.getFacing("player", units.dyn5)
            and (talent.holyAvenger and buff.holyAvenger.exists() and holyPower < 3 or holyPower < 5)
            -- and canDPS
            and (charges.crusaderStrike.count() == 2
            or (charges.crusaderStrike.count() == 1 and cast.last.holyShock()
            or cd.holyShock.remain() > gcd * 1.5))
    then
        if cast.crusaderStrike(units.dyn5) then
            br.addonDebug("[GEN]CrusaderStrike on " .. br._G.UnitName(units.dyn5) .. " CD/HS: " .. round(cd.holyShock.remain(), 2))
            return true
        end
    end
end

actionList.triage = function()

    healTarget = "none"
    healReason = "none"

    --Critical first
    if healTarget == "none" then
        if php <= ui.value("Critical HP") then
            healTarget = "player"
            healReason = "CRIT"
        end
    end
    if healTarget == "none" then
        if lowest.hp <= ui.value("Critical HP") and canheal(lowest.unit) then
            healTarget = lowest.unit
            healReason = "CRIT"
        end
    end

    --[[
   --OLD M+ AFIX CODE--    
    if healTarget == "none" and ui.checked("Pride Heal") and br.GetObjectID("target") == 173729 then
        local prideHealTarget = "player"
        local prideHealHealth = br._G.UnitHealth("player")
        for i = 1, #br.friend do
            if canheal(br.friend[i].unit) and br._G.UnitHealth(br.friend[i].unit) < prideHealHealth then
                prideHealTarget = br.friend[i].unit
            end
        end
        if br.getHP(prideHealTarget) < ui.value("DPS Min HP") then
            healTarget = prideHealTarget
            healReason = "PRIDE"
        end
    end]] 

    if healTarget == "none" and ui.checked("Grievous Wounds") then
        --Grievous Wounds
        BleedStack = 0
        for i = 1, #br.friend do
            if br.friend[i].hp < 90 and canheal(br.friend[i].unit) then
                local CurrentBleedstack = br.getDebuffStacks(br.friend[i].unit, 240559)
                if br.getDebuffStacks(br.friend[i].unit, 240559) >= ui.value("Grievous Wounds") then
                    BleedFriendCount = BleedFriendCount + 1
                end
                if CurrentBleedstack > BleedStack then
                    BleedStack = CurrentBleedstack
                    healTarget = br.friend[i].unit
                    healReason = "GRIEV"
                end
            end
        end
    end
end

--SPENDERS
actionList.spenders = function()
    -- ui.print("Debug - HP: " .. tostring(holyPower) .. " Buff?: " .. tostring(buff.divinePurpose.exists()))
    -- Light of Dawn Fish
    if br.getOptionValue("Fish Spell for Awakening") == 2
            and talent.awakening
            and not buff.avengingWrath.exists()
            and (holyPower == 5 or (buff.divinePurpose.exists() and br.getBuffRemain("player", 223817) < 3 or holyPower == 5))
    then
        if bestConeHeal(spell.lightOfDawn, 0, 100, 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5) then
            br.addonDebug("[Fish] LoD")
            return true
        end
    end

    -- Light of Dawn
    if ui.checked("Light of Dawn")
            and (holyPower >= 3 or buff.divinePurpose.exists())
            and lowest.hp > ui.value("Critical HP")
    then
        if bestConeHeal(spell.lightOfDawn, ui.value("LoD Targets"), ui.value("Light of Dawn"), 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5) then
            return true
        end
    end

    -- Word of Glory
    if ui.checked("Word of Glory") then
        if healTarget == "none"
                and (holyPower >= 3 or buff.divinePurpose.exists())
        then
            -- WOG Heal
            if lowest.hp <= ui.value("Word of Glory")
                    and lowest.hp > ui.value("Critical HP")
                    and canheal(lowest.unit)
            then
                healTarget = lowest.unit
                healReason = "HEAL"
            end
            -- WOG fishing for Wings
            if healTarget == "none"
                    and br.getOptionValue("Fish Spell for Awakening") == 1
                    and talent.awakening
                    and not buff.avengingWrath.exists()
                    and (holyPower == 5 or (buff.divinePurpose.exists() and br.getBuffRemain("player", 223817) < 3 or holyPower == 5))
            then
                healTarget = lowest.unit
                healReason = "FISH"
            end
        end
        -- cast
        if healTarget ~= "none"
                and canheal(healTarget)
                and (holyPower >= 3 or buff.divinePurpose.exists())
        then
            if cast.wordOfGlory(healTarget) then
                br.addonDebug("[" .. healReason .. "] WOG : " .. br._G.UnitName(healTarget) .. "/" .. healTargetHealth)
                healTarget = "none"
                return true
            end
        end
    end

    -- SOTR
    if ui.checked("Shield of the Righteous") and mode.DPS == 1
            and healTarget == "none"
            and lowest.hp > ui.value("DPS Min HP")
            and cast.able.shieldOfTheRighteous()
            and (holyPower == 5 or buff.divinePurpose.exists())
            and (talent.awakening and buff.avengingWrath.exists() or not talent.awakening)
    then
        if cast.shieldOfTheRighteous() then
            return true
        end
    end
end

actionList.heal = function()
    -- heal()
    --
    --checking for HE
    if br.data.settings[br.selectedSpec][br.selectedProfile]["HE ActiveCheck"] == false and br.timer:useTimer("Error delay", 3.5) then
        br._G.print("HEAL ENGINE IS NOT ON - HEAL ENGINE NEED TO BE ON - YOU SHOULD TURN THE HEAL ENGINE ON.")
        return
    end

    --Biggest Group(txh Panglo)
    local biggestGroup = 0
    local bestUnit
    for i = 1, #br.friend do
        local thisUnit = br.friend[i].unit
        local thisGroup = #br.getUnitsToHealAround(thisUnit, 6, ui.value("Light's Hammer"),
            ui.value("Light's Hammer Targets"))
        local tankGroup = 0
        if #tanks > 0 then
            tankGroup = #br.getUnitsToHealAround(tanks[1].unit, 6, ui.value("Light's Hammer"),
                ui.value("Light's Hammer Targets"))
        end

        if thisGroup > biggestGroup then
            biggestGroup = thisGroup
            bestUnit = thisUnit
        end
        if #tanks > 0 then
            if tankGroup == biggestGroup then
                biggestGroup = tankGroup
                bestUnit = tanks[1].unit
            end
        end
    end

    if br.isChecked("Beacon of Light") and not talent.beaconOfVirtue then
        -- Beacon Tank, Elseif Self
        if #tanks > 0 and (lowest.hp > ui.value("Beacon Swap Min HP") or not ui.checked("Beacon Swap Emergency Healing")) then
            for i = 1, #tanks do
                if not buff.beaconOfLight.exists(tanks[i].unit) and not buff.beaconOfFaith.exists(tanks[i].unit) and br._G.UnitInRange(tanks[i].unit) then
                    if cast.beaconOfLight(tanks[i].unit) then
                        return true
                    end
                end
            end
        elseif #tanks == 0 and not buff.beaconOfLight.exists("Player") then
            if cast.beaconOfLight("Player") then
                return true
            end
        end
        -- Emergency Beacon Swap
        if ui.checked("Beacon Swap Emergency Healing") and lowest.hp <= ui.value("Beacon Swap Min HP") and not buff.beaconOfLight.exists(lowest.unit) and not buff.beaconOfFaith.exists(lowest.unit) then
            if cast.beaconOfLight(lowest.unit) then
                return true
            end
        end
    else
        -- Beacon of Virtue
        if unit.inCombat() and ui.checked("Beacon of Virtue") and br.getSpellCD(200025) == 0 and not br._G.IsMounted() then
            if br.getLowAllies(ui.value("Beacon of Virtue")) >= ui.value("BoV Targets") then
                if cast.beaconOfVirtue(lowest.unit) then
                    return true
                end
            end
        end
    end

    -- Bestow Faith
    if talent.bestowFaith and cd.bestowFaith.ready() then
        if healTarget == "none" then
            if lowest.hp <= 90 and canheal(lowest.unit) then
                healTarget = lowest.unit
                healReason = "HEAL"
            end
        end
        if healTarget ~= "none" and healReason ~= "FISH" then
            if cast.bestowFaith(healTarget) then
                br.addonDebug("[" .. healReason .. "] Bestow Faith on: " .. br._G.UnitName(healTarget))
                healTarget = "none"
                return true
            end
        end
    end -- end Bestow Faith

    -- Light of Martyr
    if ui.checked("Light of the Martyr") then
        if healTarget == "none" and (php >= br.getOptionValue("LotM player HP limit") or buff.divineShield.exists("player")) and cast.able.lightOfTheMartyr()
                -- M+ Stuff
                --[[and br.getDebuffStacks("player", 267034) < 2 -- not if we got stacks on last boss of shrine
                and br.getDebuffStacks("player", 323020) == 0 -- MISTS - Bloodletting Bleed DoT
                and br.getDebuffStacks("player", 325021) == 0 -- MISTS - Mistveil Tear Bleed DoT
                and br.getDebuffStacks("player", 326874) == 0 -- HOA - Ankle Bites DoT
                and br.getDebuffStacks("player", 322429) == 0 -- SD - Severing Slice Bleed DoT
                and br.getDebuffStacks("player", 335306) == 0 -- SD - Barbed Shackle DoT
                and br.getDebuffStacks("player", 322554) == 0 -- SD - Castigate DoT
                and br.getDebuffStacks("player", 333861) == 0 -- ToP - Richocheting Blade
                -- Raid Stuff
                and br.getDebuffStacks("player", 334765) == 0 -- CN: SLG - Heart Rend
                and br.getDebuffStacks("player", 334771) == 0 -- CN: SLG - Heart Hemmorage]]

                -- Can we heal?
                and lowest.hp <= ui.value("Light of the Martyr") and not br.GetUnitIsUnit(lowest.unit, "player")
                and canheal(lowest.unit) then
            healTarget = lowest.unit
            healReason = "HEAL"
        end
        -- Cast
        if healTarget ~= "none" and healReason ~= "FISH" and healReason ~= "BOSS" and not br.GetUnitIsUnit(healTarget, "player") and not cast.able.holyShock() then
            healTargetHealth = round(br.getHP(healTarget), 1)
            if canheal(healTarget) then
                if cast.lightOfTheMartyr(healTarget) then
                    br.addonDebug("[" .. healReason .. "] lightOfTheMartyr on: " .. br._G.UnitName(healTarget) .. "/" .. healTargetHealth)
                    healTarget = "none"
                    return true
                end
            end
        end
    end

    -- Holy Light
    if (ui.checked("Infused Holy Light") or ui.checked("Infused Holy Light Grievous"))
            and not br.isMoving("player")
    then
        -- Infused Holy Light

        if buff.infusionOfLight.exists() then
            if ui.checked("Infused Holy Light") and healTarget == "none" then
                for i = 1, #br.friend do
                    if (br.friend[i].role == "HEALER" or br.friend[i].role == "DAMAGER")
                            and br.friend[i].hp <= ui.value("DPS/Healer Infused Holy Light HP Limit")
                            and canheal(br.friend[i].unit) then
                        healTarget = br.friend[i].unit
                        healReason = "I_HEAL"
                        break
                    end
                end
                if healTarget == "none" and #tanks > 0 then
                    if canheal(tanks[1].unit) and tanks[1].hp <= ui.value("Tank Infused Holy Light HP Limit") then
                        healTarget = tanks[1].unit
                        healReason = "I_HEAL"
                    end
                end
            end
            --Infused Holy Light Grievous
            if ui.checked("Infused Holy Light Grievous") and healTarget == "none" and buff.infusionOfLight.exists() then
                for i = 1, #br.friend do
                    if (br.friend[i].role == "HEALER" or br.friend[i].role == "DAMAGER")
                            and br.getDebuffStacks(br.friend[i].unit, 240559) >= ui.value("Grievous Wounds")
                            and br.friend[i].hp <= ui.value("DPS/Healer Infused Holy Light HP Limit")
                            and canheal(br.friend[i].unit) then
                        healTarget = br.friend[i].unit
                        healReason = "GRIEV"
                        break
                    end
                end
                if healTarget == "none" and #tanks > 0 then
                    if canheal(tanks[1].unit)
                            and tanks[1].hp <= ui.value("Tank Infused Holy Light HP Limit")
                            and br.getDebuffStacks(tanks[1].unit, 240559) >= ui.value("Grievous Wounds") then
                        healTarget = tanks[1].unit
                        healReason = "GRIEV"
                    end
                end
            end
        end
        -- Cast

        if (ui.checked("Infused Holy Light") or ui.checked("Infused Holy Light Grievous") and healTarget ~= "none")
                or ((ui.checked("Infused Holy Light") or ui.checked("Holy Light")) and mode.raid == 1 and br.getMana("player") <= 75 and (healReason == "BOSS" or healReason == "RAIDHELP"))
        then
            if cast.holyLight(healTarget) then
                br.addonDebug("[" .. healReason .. "] holyLight on: " .. br._G.UnitName(healTarget))
                healTarget = "none"
                return true
            end
        end
    end

    -- Flash of Light
    if (ui.checked("Flash of Light") or ui.checked("Infused Flash of Light") or mode.raid == 1)
            and not br.isMoving("player")
    then
        --Infusion of Light
        if ui.checked("Infused Flash of Light")
                and buff.infusionOfLight.exists()
                and not cast.last.flashOfLight()
        then
            if ui.checked("Infused Flash of Light") and healTarget == "none" then
                if lowest.hp <= ui.value("Infused Flash of Light") and canheal(lowest.unit) then
                    healTarget = lowest.unit
                    healReason = "I_HEAL"
                end
                if lowest.hp <= ui.value("Beacon Swap Min HP") and buff.beaconOfLight.exists(lowest.unit) and holyPower < 3 and cd.holyShock.remain() > 1.5 and cd.crusaderStrike.remain() ~= 0 and canheal(lowest.unit) then
                    healTarget = lowest.unit
                    healReason = "I_FOL_HPGEN"
                end
                if lowest.hp <= ui.value("Infused Flash of Light") and cd.holyShock.remain() > 1.5 and canheal(lowest.unit) then
                    healTarget = lowest.unit
                    healReason = "I_IMBUED_INFUSIONS"
                end
            end
        end
        -- Non Infused FOL
        if ui.checked("Flash of Light") and healTarget == "none" then
            if lowest.hp <= ui.value("Flash of Light") and canheal(lowest.unit) then
                healTarget = lowest.unit
                healReason = "HEAL"
            end
            if buff.innervate.exists("player") and cd.holyShock.remain() > 1.5 and cd.crusaderStrike.remain() ~= 0 and canheal(lowest.unit) then
                healTarget = lowest.unit
                healReason = "INNERVATED"
            end
            if lowest.hp <= ui.value("Beacon Swap Min HP") and buff.beaconOfLight.exists(lowest.unit) and holyPower < 3 and cd.holyShock.remain() > 1.5 and cd.crusaderStrike.remain() ~= 0 and canheal(lowest.unit) then
                healTarget = lowest.unit
                healReason = "FOL_HPGEN"
            end
        end
        -- Cast
        if (ui.checked("Flash of Light") or ui.checked("Infused Flash of Light")) and
                (healTarget ~= "none" or mode.raid == 1 and br.player.instance == "raid" and br.getMana("player") >= 75 and (healReason == "BOSS" or healReason == "RAIDHELP"))
        then
            healTargetHealth = round(br.getHP(healTarget), 1)
            --   if healTargetHealth < ui.checked("Infused Flash of Light") then

            if canheal(healTarget) then
                if cast.flashOfLight(healTarget) then
                    br.addonDebug("[" .. healReason .. "] flashOfLight on: " .. br._G.UnitName(healTarget) .. "/" .. healTargetHealth .. "/" .. (ui.value("Infused Flash of Light")))
                    healTarget = "none"
                    return true
                end
            end
        end
        -- Light's Hammer
        if ui.checked("Light's Hammer") and unit.inCombat() and talent.lightsHammer then
            if biggestGroup >= ui.value("Light's Hammer Targets") then
                if cast.lightsHammer(bestUnit) then
                    br._G.SpellStopTargeting()
                    return 
                end
            end
        end
    end --LoD/WoG >> DT >> HS >> BF >> LOTM >> FOL/HL >> LH
end -- End Action List - heal

----------------
--- ROTATION ---
----------------

local someone_casting = false

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local function reader()
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    if param == "SPELL_CAST_START" and bit.band(sourceFlags, 0x00000800) > 0 then
        C_Timer.After(0.02, function()
            someone_casting = true
            --   Print(sourceName .. " is casting " .. spellName .. " - creature[" .. tostring(bit.band(sourceFlags, 0x00000800) > 0) .. "]")
        end)
    end
end
frame:SetScript("OnEvent", reader)
local setwindow = false

local function runRotation()

    if setwindow == false then
        br._G.RunMacroText("/console SpellQueueWindow 0")
        br.player.ui.print("Set SQW")
        setwindow = true
    end

    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff = br.player.buff
    cast = br.player.cast
    racial = br.player.getRacial()
    cd = br.player.cd
    charges = br.player.charges
    debuff = br.player.debuff
    enemies = br.player.enemies
    equiped = br.player.equiped
    gcd = br.player.gcd
    gcdMax = br.player.gcdMax
    has = br.player.has
    solo = #br.friend == 1
    inCombat = br.player.inCombat
    item = br.player.items
    level = br.player.level
    mode = br.player.ui.mode
    php = br.player.health
    spell = br.player.spell
    talent = br.player.talent
    units = br.player.units
    ui = br.player.ui
    lowest = br.friend[1]
    use = br.player.use
    tanks = br.getTanksTable()
    unit = br.player.unit
    healTarget = "none"
    healReason = "none"
    healTargetHealth = 100
    inInstance = br.player.instance == "party"
    inRaid = br.player.instance == "raid"
    solo = br.friends == 1
    holyPower = br.player.power.holyPower.amount()
    holyPowerMax = br.player.power.holyPower.max()
    eating = br.getBuffRemain("player", 192002) ~= 0 or br.getBuffRemain("player", 167152) ~= 0 or br.getBuffRemain("player", 192001) ~= 0 or br.getBuffRemain("player", 308433) ~= 0

    canDPS = lowest.hp > ui.value("DPS Min HP") and lowest.hp > ui.value("Critical HP") and true or false
    -- General Locals
    hastar = br.GetObjectExists("target")
    healPot = br.getHealthPot()
    profileStop = profileStop or false
    ttd = br.getTTD
    haltProfile = (inCombat and profileStop) or (br._G.IsMounted() or br._G.IsFlying()) or br.pause() or mode.rotation == 4 or br.getBuffRemain("player", 307195) > 0
    -- Units
    units.get(5)
    --units.get(8)
    units.get(15)
    units.get(30)
    -- units.get(40)
    --  enemies.get(5)
    --  enemies.get(5, "player", false, true)
    enemies.get(8)
    enemies.get(10)
    --enemies.get(15)
    enemies.get(30)
    enemies.get(40)

    if br.timer:useTimer("random_timer", 10) then
        tuftTargetHP = math.random(ui.value("Tuft of Smoldering Plumeage - min"), ui.value("Tuft of Smoldering Plumeage - max"))
    end

    local glimmerCount = 0

    if br.timersTable then
        wipe(br.timersTable)
    end
    if talent.breakingDawn then
        lightOfDawn_distance = 40
    else
        lightOfDawn_distance = 15
    end
    if buff.ruleOfLaw.exists("player") then
        lightOfDawn_distance_coff = 1.5
    else
        lightOfDawn_distance_coff = 1
    end

    if mode.glimmer == 1 and talent.glimmerOfLight then
        for i = 1, #br.friend do
            if buff.glimmerOfLight.remain(br.friend[i].unit, "exact") > gcd then
                glimmerCount = glimmerCount + 1
            end
        end
        --[[ if ui.checked("Aggressive Glimmer") and debuff.glimmerOfLight.remain("target", "exact") > gcd then
            glimmerCount = glimmerCount + 1
        end ]]
    end

    br.player.ui.mode.DPS = br.data.settings[br.selectedSpec].toggles["DPS"]




    -- Profile Specific Locals

    -- SimC specific variables


    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if (not br._G.IsMounted() or buff.divineSteed.exists()) then
        if br.pause() or eating or br.hasBuff(250873) or br.hasBuff(115834) or br.hasBuff(58984) or br.hasBuff(185710) or br.isCastingSpell(212056) then --need change buff id
            return true
        else
            if not inCombat then
                -- out of combat stuff
                --  Print("Not in Combat")

                if actionList.Extra() then
                    return true
                end

                if actionList.Defensive() then
                    return true
                end

                if actionList.Interrupt() then
                    return true
                end

                if actionList.Cooldown() then
                    return true
                end

                if br.player.ui.mode.cleanse == 1 then
                    if actionList.cleanse() then
                        return true
                    end
                end

                actionList.triage()
                if healTarget ~= "none" or lowest.hp < 80 then
                    if actionList.generators() then
                        return true
                    end
                    if actionList.spenders() then
                        return true
                    end
                    if actionList.heal() then
                        return true
                    end
                end

                if actionList.ooc() then
                    return true
                end

                if talent.glimmerOfLight and (mode.glimmer == 1 or mode.glimmer == 3) and cd.holyShock.ready() then
                    -- and glimmerCount <= 8
                    if actionList.glimmer() then
                        return true
                    end
                end
            else
                --Print("In Combat")

                --combat stuff

                if actionList.Extra() then
                    return true
                end
                if spellQueueReady() then
                    if not br.SpecificToggle("DPS Key") and not br._G.GetCurrentKeyBoardFocus() or lowest.hp <= br.getOptionValue("Critical HP") then
                        if actionList.Defensive() then
                            return true
                        end
                        if actionList.heal() then
                            return true
                        end
                        if actionList.generators() then
                            return true
                        end
                        if (holyPower >= 3 and not cd.holyShock.ready()) or buff.divinePurpose.exists() or holyPower == 5 then --need add seal of clarity check
                            if actionList.spenders() then
                                return true
                            end
                        end
                        -- executed outside of gcd
                        --We will check for interrupt whenever someone is casting (based on log)
                        if someone_casting == true and inCombat then
                            if actionList.Interrupt() then
                            end
                        end
                        if actionList.Cooldown() then
                            return true
                        end
                        if br.player.ui.mode.cleanse == 1 then
                            if actionList.cleanse() then
                                return true
                            end
                        end
                        if ui.checked("Prioritize Hammer of Wrath") then
                            if actionList.hammerOfWrathDPS() then
                                return true
                            end
                        end
                        actionList.triage()
                        if talent.glimmerOfLight and (mode.glimmer == 1 or mode.glimmer == 3) and cd.holyShock.ready() then
                            -- and glimmerCount <= 8
                            if actionList.glimmer() then
                                return true
                            end
                        end
                        --[[if actionList.heal() then
                            return true
                        end]]
                    end
                    if actionList.hammerOfWrathDPS() then
                        return true
                    end
                    if mode.DPS == 1 then
                        if actionList.dps() then
                            return true
                        end
                    end
                end
            end
        end -- end pause
        return true
    end
end

local id = 65
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
br._G.tinsert(
        br.rotations[id],
        {
            name = rotationName,
            toggles = createToggles,
            options = createOptions,
            run = runRotation
        }
)
