local rotationName = "Laks M+ " -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles()
    local CreateButton = br["CreateButton"]
    -- Rotation Button
    br.CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 0, icon = br.player.spell.holyAvenger },
        [2] = { mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.auraMastery },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.absolution }
    }
    CreateButton("Cooldown", 1, 0)
    -- Defensive Button
    br.DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 0, icon = br.player.spell.divineProtection },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.blessingOfProtection }
    }
    CreateButton("Defensive", 2, 0)
    -- Interrupt Button
    br.InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.blindingLight },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.blindingLight }
    }
    CreateButton("Interrupt", 3, 0)
    -- Cleanse Button
    br.CleanseModes = {
        [1] = { mode = "On", value = 1, overlay = "Cleanse Enabled", tip = "Cleanse Enabled", highlight = 0, icon = br.player.spell.cleanse },
        [2] = { mode = "Off", value = 2, overlay = "Cleanse Disabled", tip = "Cleanse Disabled", highlight = 0, icon = br.player.spell.cleanse }
    }
    CreateButton("Cleanse", 4, 0)
    -- Glimmer
    br.GlimmerModes = {
        [1] = { mode = "On", value = 1, overlay = "Glimmer mode", tip = "Glimmer on", highlight = 0, icon = 287280 },
        [2] = { mode = "Off", value = 2, overlay = "Normal", tip = "Glimmer off", highlight = 0, icon = br.player.spell.holyShock },
        [3] = { mode = "Tank", value = 3, overlay = "Normal", tip = "Glimmer on tank", highlight = 0, icon = 278573 }
    }
    CreateButton("Glimmer", 5, 0)
    -- DPS
    br.DPSModes = {
        [1] = { mode = "On", value = 1, overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 0, icon = br.player.spell.judgment },
        [2] = { mode = "Off", value = 2, overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.judgment },
    }
    CreateButton("DPS", 6, 0)
    br.PotsModes = {
        [1] = { mode = "On", value = 1, overlay = "Use Pots", tip = "Use Pots", highlight = 0, icon = 2259 },
        [2] = { mode = "Off", value = 2, overlay = "Use Pots", tip = "Use Pots", highlight = 0, icon = 2259 },
    }
    CreateButton("Pots", 7, 0)


end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        section = br.ui:createSection(br.ui.window.profile, "General - 20200609-1605")
        br.ui:createDropdownWithout(section, "DPS Key", br.dropOptions.Toggle, 6, "DPS Override")
        br.ui:createCheckbox(section, "Group CD's with DPS key", "Pop wings and HA with Dps override", 1)
        br.ui:createCheckbox(section, "Aggressive Glimmer")

        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Healing")
        br.ui:createSpinnerWithout(section, "Critical HP", 30, 0, 100, 5, "", "Health Percent to Critical Heals")
        br.ui:createSpinner(section, "Word of Glory", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Holy Shock", 80, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Light of the Martyr", 40, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "LotM player HP limit", 50, 0, 100, 5, "", "Light of the Martyr Self HP limit")
        -- Light of Dawn
        br.ui:createSpinner(section, "Light of Dawn", 90, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "LoD Targets", 3, 0, 40, 1, "", "Minimum LoD Targets", true)
        br.ui:createSpinner(section, "Infused Flash of Light", 70, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Flash of Light", 50, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createSpinner(section, "Aura Mastery", 50, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Aura Mastery Targets", 3, 0, 40, 1, "", "Minimum Aura Mastery Targets", true)
        br.ui:createSpinner(section, "Holy Avenger", 60, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Holy Avenger Targets", 3, 0, 40, 1, "", "Minimum Holy Avenger Targets", true)
        br.ui:createSpinner(section, "Lay on Hands", 20, 0, 100, 5, "", "Min Health Percent to Cast At")
        br.ui:createSpinner(section, "Blessing of Protection", 20, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Blessing of Sacrifice", 40, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createDropdownWithout(section, "BoS Target", { "Any", "Tanks" }, 1, "Target for BoS")
        br.ui:createCheckbox(section, "Blessing of Freedom", "Use Blessing of Freedom")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Trinkets")
        --br.ui:createCheckbox(section,"glimmer debug")
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 1 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround", "DPS-Target", "w/DPS KEY" }, 1, "", "")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 2 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround", "DPS-Target", "w/DPS KEY" }, 1, "", "")

        -- br.ui:createCheckbox(section, "Advanced Trinket Support")

        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Defensive")

        if br.player.race == "BloodElf" then
            br.ui:createSpinner(section, "Arcane Torrent Dispel", 1, 0, 20, 1, "", "|cffFFFFFFMinimum Torrent Targets")
            br.ui:createSpinner(section, "Arcane Torrent Mana", 30, 0, 95, 1, "", "|cffFFFFFFMinimum When to use for mana")
        end
        if br.player.race == "LightforgedDraenei" then
            --lightsJudgment
            br.ui:createSpinner(section, "Light's Judgment", 1, 0, 20, 1, "", "Minimum Judgement Targets")
        end

        -- Pot/Stone
        br.ui:createSpinner(section, "Pot/Stoned", 30, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Divine Protection", 60, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Divine Shield", 20, 0, 100, 5, "", "Health Percent to Cast At")
        -- Gift of The Naaru
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of The Naaru", 50, 0, 100, 5, "Health Percent to Cast At")
        end
        br.ui:createSpinner(section, "Engineering Belt", 60, 0, 100, 5, "Health Percentage to use at.")
        br.ui:createSpinner(section, "Mana Potion", 50, 0, 100, 1, "Mana Percent to Cast At")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Pots")
        br.ui:createDropdownWithout(section, "Pots - 1 target (Boss)", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury" }, 1, "", "Use Pot when Incarnation/Celestial Alignment is up")
        br.ui:createDropdownWithout(section, "Pots - 2-3 targets", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury" }, 1, "", "Use Pot when Incarnation/Celestial Alignment is up")
        br.ui:createDropdownWithout(section, "Pots - 4+ target", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury" }, 1, "", "Use Pot when Incarnation/Celestial Alignment is up")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        --Hammer of Justice
        br.ui:createCheckbox(section, "Hammer of Justice")
        -- Blinding Light
        br.ui:createCheckbox(section, "Blinding Light")
        br.ui:createSpinner(section, "InterruptAt", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Keys")
        br.ui:createDropdown(section, "Eng Brez", { "Target", "Mouseover", "Auto" }, 1, "", "Target to cast on")

        br.ui:checkSectionState(section)

    end
    local function mplusoptions()
        section = br.ui:createSection(br.ui.window.profile, "M+ Settings")
        -- m+ Rot
        br.ui:createSpinner(section, "Grievous Wounds", 2, 0, 10, 1, "Enables/Disables GrievousWound")
        br.ui:createCheckbox(section, "Freehold - pig", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFCatches pig in Freehold|cffFFBB00.", 1)
        br.ui:createCheckbox(section, "Freehold - Blackout Barrel", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFBubble blackout barrel|cffFFBB00.", 1)
        br.ui:createCheckbox(section, "KR - Severing axe", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFBubble Severing Axe|cffFFBB00.", 1)
        br.ui:createCheckbox(section, "Motherload - Stun jockeys", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFStun ...jockeys ... |cffFFBB00.", 1)
        br.ui:createCheckbox(section, "Tol Dagor - Deadeye", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFBubble Deadeye target|cffFFBB00.", 1)
        br.ui:createCheckbox(section, "Dont DPS spotter", "wont DPS spotter", 1)
        br.ui:createCheckbox(section, "Shrine - ignore adds last boss", "wont DPS those critters", 1)
        br.ui:checkSectionState(section)
    end

    local function oocoptions()
        section = br.ui:createSection(br.ui.window.profile, "OOC Settings")
        br.ui:createSpinner(section, "Auto Drink", 45, 0, 100, 5, "Mana Percent to Drink At")
        br.ui:createCheckbox(section, "OOC Glimmer", "Enables/Disables glimmer out of combat", 1)
        br.ui:createSpinnerWithout(section, "OOC Holy Heal - Time", 1, 0, 10, 5, "When I havent moved for x seconds")
        br.ui:createSpinnerWithout(section, "OOC Holy Heal - Mana", 60, 0, 100, 5, "and my mana is above")
        br.ui:createSpinnerWithout(section, "OOC Holy Heal - Health", 80, 0, 100, 5, "and peoples health are below")
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
end

-----Locals

local buff
local cast
local cd
local debuff
local enemies
local equiped
local gcd
local gcdMax
local has
local inCombat
local item
local level
local mode
local ui
local php
--local spell
local talent
local units
local use
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local hastar
local healPot
local profileStop
local drinking = br.getBuffRemain("player", 192002) ~= 0 or br.getBuffRemain("player", 167152) ~= 0 or br.getBuffRemain("player", 192001) ~= 0 or br.getDebuffRemain("player", 185710) ~= 0 or br.getDebuffRemain("player", 297098) ~= 0 or br.getDebuffRemain("player", 274914) ~= 0

local ttd

local burst
local Burststack = 0
local BleedFriendCount = 0
local BleedStack = 0

local healTarget
local healReason
local healTargetHealth

local holyPower
local holyPowerMax




-- homemade functions

-- spellqueue ready
local function spellQueueReady()
    --Check if we can queue cast
    local castingInfo = { UnitCastingInfo("player") }
    if castingInfo[5] then
        if (GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow"))) / 1000)) < 0 then
            --     Print((GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow"))) / 1000)))
            return false
        end
        --       Print((GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow"))) / 1000)))
    end
    return true
end

local timers = {}
timers._timers = {}
function timers.time(name, fn)
    local time = timers._timers[name]
    if fn then
        if not time then
            time = GetTime()
        end
    else
        time = nil
    end
    timers._timers[name] = time
    return time and (GetTime() - time) or 0
end

local function noConc(unit)
    if br.isBoss(unit) or noconc_list[br.GetObjectID(unit)] ~= nil then
        return true
    end
end
local function isCC(unit)
    if br.getOptionCheck("Don't break CCs") then
        return isLongTimeCCed(Unit)
    end
end
local function noDamageCheck(unit)
    if ui.checked("Dont DPS spotter") and br.GetObjectID(unit) == 135263 then
        return true
    end
    if ui.checked("Shrine - ignore adds last boss") and br.GetObjectID(unit) == 135903 then
        return true
    end
    if isCC(unit) then
        return true
    end
    if br.hasBuff(263246, unit) then
        -- shields on first boss in temple
        return true
    end
    if br.hasBuff(260189, unit) then
        -- shields on last boss in MOTHERLODE
        return true
    end
    if br.hasBuff(261264, unit) or br.hasBuff(261265, unit) or br.hasBuff(261266, unit) then
        -- shields on witches in wm
        return true
    end
    if br.GetObjectID(thisUnit) == 128652 then
        --https://www.wowhead.com/npc=128652/viqgoth
        return true
    end

    return false --catchall
end

local function bestConeHeal(spell, minUnits, health, angle, rangeInfront, rangeAround)
    if not br.isKnown(spell) or br.getSpellCD(spell) ~= 0 or select(2, br._G.IsUsableSpell(spell)) then
        return false
    end
    local curFacing = br._G.ObjectFacing("player")
    local playerX, playerY, playerZ = br._G.ObjectPosition("player")
    local coneTable = {}

    local unitsAround = 0
    for i = 1, #br.friend do
        local thisUnit = br.friend[i].unit
        if br.friend[i].hp < health then
            if br.friend[i].distance < rangeAround then
                unitsAround = unitsAround + 1
            elseif br.friend[i].distance < rangeInfront then
                local unitX, unitY, unitZ = br._G.ObjectPosition(thisUnit)
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

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local actionList = {}
local CC_CreatureTypeList = { "Humanoid", "Demon", "Undead", "Dragonkin", "Giant" }
local StunsBlackList = {
    -- 8.3 tier 4 adds
    [161244] = "Blood of the Corruptor",
    [161243] = "Samh'rek, Beckoner of Chaos",
    [161124] = "Urg'roth, Breaker of Heroes",
    [161241] = "Voidweaver Mal'thir",
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
    [135365] = "Matron Alma",
    -- Mechagon Workshop
    [151476] = "Blastatron X-80",
    [151773] = "Junkyard D.0.G.",
    -- Mechagon Junkyard
    [152009] = "Malfunctioning Scrapbot",
    [150160] = "Scrapbone Bully",
    [150276] = "Heavy Scrapbot",
    [150169] = "Toxic Lurker",
    [150292] = "Mechagon Cavalry",
    [150168] = "Toxic Monstrosity",
}

local HOJ_unitList = {
    [131009] = "Spirit of Gold",
    [134388] = "A Knot of Snakes",
    [129758] = "Irontide Grenadier",
    [152703] = "walkie-shockie-x1"
}

noconc_list = {
    [161124] = "urgroth - breaker - of - heroes",
    [161244] = "blood - of - the - corruptor",
    [161243] = "samhrek - beckoner - of - chaos",
    [161241] = "voidweaver - malthir"
}

actionList.glimmer = function()

    -- br.player.ui.mode.DPS = br.data.settings[br.selectedSpec].toggles["DPS"]

    if cast.able.holyShock() then
        local glimmerCount = 0
        for i = 1, #br.friend do
            if buff.glimmerOfLight.remain(br.friend[i].unit, "exact") > gcd then
                glimmerCount = glimmerCount + 1
            end
        end


        --Glimmer support
        if ui.checked("Aggressive Glimmer") and br.player.ui.mode.DPS == 1 and br.player.inCombat and UnitIsEnemy("target", "player") and lowest.hp > ui.value("Critical HP") then
            if br.player.ui.mode.DPS == 1 and not debuff.glimmerOfLight.exists("target", "EXACT") and br.GetUnitExists("target") and br.getFacing("player", "target") then
                if cast.holyShock("target") then
                    br.addonDebug("[GLIM] Aggressive Glimmer on: " .. br._G.UnitName("target"))
                    return true
                end
            end
            if debuff.glimmerOfLight.exists("target", "EXACT") then
                glimmerCount = glimmerCount + 1
            end
        end

        if #tanks > 1 then
            --find lowest friend without glitter buff on them - tank first  for i = 1, #tanks do
            for i = 1, #tanks do
                if UnitInRange(tanks[i].unit) and br.getLineOfSight(tanks[i].unit, "player") then
                    if not br.UnitBuffID(tanks[i].unit, 287280) then
                        if cast.holyShock(tanks[i].unit) then
                            br.addonDebug("[GLIM] Tank-Glimmer on " .. br._G.UnitName(tanks[i].unit) .. "/" .. tostring(glimmerCount))
                            return true
                        end
                    end
                end
            end
        end

        if mode.glimmer == 1 then
            glimmerTable = {}
            for i = 1, #br.friend do
                if (UnitInRange(br.friend[i].unit) and br.getLineOfSight(br.friend[i].unit, "player") or br.friend[i].unit == "player") and not br.UnitBuffID(br.friend[i].unit, 287280, "PLAYER") and not br.UnitBuffID(br.friend[i].unit, 115191) then
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
            if #glimmerTable > 0 and glimmerTable[1].unit ~= nil and mode.glimmer == 1 then
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
                    --Print("Just glimmered: " .. glimmerTable[1].unit)
                    br.addonDebug("[GLIM] Glimmer on: " .. br._G.UnitName(glimmerTable[1].unit) .. "/" .. tostring(glimmerCount))
                    return true
                end
            end
        end
    end

    -- Light of Dawn
    if ui.checked("Light of Dawn") and cast.able.lightOfDawn() then
        if EasyWoWToolbox == nil then
            if br.healConeAround(ui.value("LoD Targets"), ui.value("Light of Dawn"), 90, lightOfDawn_distance * lightOfDawn_distance_coff, 5 * lightOfDawn_distance_coff)
            then
                if cast.lightOfDawn() then
                    return true
                end
            end
        else
            if bestConeHeal(spell.lightOfDawn, ui.checked("LoD Targets"), ui.checked("Light of Dawn"), 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5) then
                healTarget = "none"
                return true
            end
        end
    end

end

actionList.cleanse = function()

    -- Cleanse
    if cast.able.cleanse() and not cast.last.cleanse() then
        for i = 1, #br.friend do
            if br.canDispel(br.friend[i].unit, spell.cleanse) and (br.getLineOfSight(br.friend[i].unit) and br.getDistance(br.friend[i].unit) <= 40 or br.friend[i].unit == "player") then
                if br.player.race == "DarkIronDwarf" and cast.able.racial() and br.friend[i].unit == "player" then
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
actionList.ooc = function()
    --things to do ooc

    if ui.checked("Auto Drink") and br.getMana("player") <= br.getOptionValue("Auto Drink") and not moving and br.getDebuffStacks("player", 240443) == 0 and br.getDebuffStacks("player", 240443) == 0 then
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

        if not ui.checked("Sugar Crusted Fish Feast") or (ui.checked("Sugar Crusted Fish Feast") and not br.hasItem(126936)) and not br.hasBuff(185710) then
            if br.hasItem(65499) and br.canUseItem(65499) then
                br.useItem(65499)
            end
            if br.hasItem(113509) and br.canUseItem(113509) then
                br.useItem(113509)
            end
            if br.hasItem(159867) and br.canUseItem(159867) then
                br.useItem(159867)
            end
            if br.hasItem(163784) and br.canUseItem(163784) then
                br.useItem(163784)
            end

        end
    end
    --I got nothing else to do
    local standingTime = 0
    if br.DontMoveStartTime then
        standingTime = GetTime() - br.DontMoveStartTime
    end
    if not br.isMoving("Player") and standingTime > ui.value("OOC Holy Heal - Time") and not drinking and br.getMana("player") >= ui.value("OOC Holy Heal - Mana") and br.getHP(lowest.unit) < ui.value("OOC Holy Heal - Health") then
        if cast.holyLight(lowest.unit) then
        end
    end
end

actionList.dps = function()
    -- j / con / HS / CS

    --Auto attack
    if not IsAutoRepeatSpell(GetSpellInfo(6603)) and #enemies.yards8 >= 1 then
        br._G.StartAttack(units.dyn5)
    end

    if br._G.IsSpellOverlayed(24275) then
        if cast.hammerOfWrath("target") then
            return
        end
    end


    --Judgment
    if cast.able.judgment() and cd.holyShock.remain() > 1 then
        if #tanks == 0 or #tanks > 0 and br.getDistance(units.dyn30, tanks[1].unit) <= 10 then
            if traits.indomitableJustice.active then
                for i = 1, #enemies.yards30 do
                    if br.getHP(enemies.yards30[i]) < br.getHP("player") and br.getFacing("player", enemies.yards30[i]) then
                        br.addonDebug("[DPS]Judgment - indomitableJustice" .. "[" .. round(br.getHP(enemies.yards30[i]), 2) .. "/" .. round(br.getHP("player"), 2) .. "]")
                        if cast.judgment(enemies.yards30[i]) then
                            return true
                        end
                    end
                end
            end
            if br.getFacing("player", units.dyn30) then
                if cast.judgment(units.dyn30) then
                    br.addonDebug("[DPS]Judgment [" .. round(br.getHP(enemies.yards30[i]), 2) .. "/" .. round(br.getHP("player"), 2) .. "]")
                    return true
                end
            end
        end
    end

    --Consecration
    if cast.able.consecration() and not br.isMoving("player") then
        for i = 1, #enemies.yards8 do
            if not cast.last.consecration(1)
                    and not noConc("target")
                    and not debuff.consecration.exists(enemies.yards8[i])
                    or GetTotemTimeLeft(1) < 2
                    or not cast.able.holyShock() and (cd.holyShock.remain() > 1.5 and cd.crusaderStrike.remain() ~= 0) then
                if cast.consecration() then
                end
            end
        end
    end

    if ui.checked("Group CD's with DPS key") and br.SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus() then
        -- popping CD's with DPS Key
        if cast.holyAvenger() then
            return true
        end
        if cast.avengingWrath() then
            return true
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

    if (inInstance and #tanks > 0 and br.getDistance(units.dyn40, tanks[1].unit) <= 15
            or #tanks > 0 and br.getDistance(tanks[1].unit) >= 90)
            or (inRaid and #tanks > 0 and br.getDistance(units.dyn40, tanks[1].unit) <= 40 or #tanks > 0 and br.getDistance(tanks[1].unit) >= 90)
            or not inInstance or not inRaid or solo then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if not debuff.glimmerOfLight.exists(thisUnit, "exact") and not noDamageCheck(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and br.getFacing("player", thisUnit) then
                if cast.holyShock(thisUnit) then
                    br.addonDebug("[DPS]HolyShock on " .. br._G.UnitName(thisUnit) .. " w/Glimmer")
                    return true
                end
            end
        end
        if cast.holyShock(units.dyn40) then
            br.addonDebug("[DPS]HolyShock - No-Glimmer")
            return true
        end
    end

    --using DPS trinkets
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

    --Talent Crusaders Might   - should only be used to get full value out of holy shock proc .. hard coded to 1.5
    if cast.able.crusaderStrike() and ((talent.crusadersMight and cd.holyShock.remain() >= 1.5) or not talent.crusadersMight) and br.getFacing("player", units.dyn5) and #enemies.yards8 >= 1 then
        if cast.crusaderStrike(units.dyn5) then
            br.addonDebug("[DPSx]CrusaderStrike on " .. br._G.UnitName(units.dyn5) .. " CD/HS: " .. round(cd.holyShock.remain(), 2))
            return true
        end
    end

    if lowest.hp > ui.value("Word of Glory") and cast.able.shieldOfTheRighteous() and (holyPower >= 3 or buff.divinePurpose.exists()) then
        if cast.shieldOfTheRighteous(units.dyn5) then
            return true
        end
    end

end

actionList.Extra = function()


end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()


    if br.useDefensive() then
        --engineering belt / plate pants
        if ui.checked("Engineering Belt") and php <= br.getOptionValue("Engineering Belt") and br.canUseItem(6) then
            br.useItem(6)
        end

        --Healthstone / Heathpots :  156634 == Silas Vial of Continuous curing / 5512 == warlock health stones
        if ui.checked("Pot/Stoned") and php <= ui.value("Pot/Stoned") and (br.hasHealthPot() or br.hasItem(5512) or br.hasItem(156634)) then
            if br.canUseItem(166799) then
                br.useItem(166799)
            elseif br.canUseItem(5512) then
                br.useItem(5512)
            elseif br.canUseItem(156634) then
                br.useItem(156634)
            elseif br.canUseItem(169451) then
                br.useItem(169451)
            elseif br.canUseItem(getHealthPot()) then
                br.useItem(getHealthPot())
            elseif br.canUseItem(getHealthPot()) then
                br.useItem(getHealthPot())
            end
        end

        -- Gift of the Naaru
        if ui.checked("Gift of The Naaru") and php <= br.getOptionValue("Gift of The Naaru") and php > 0 and br.player.race == "Draenei" then
            if castSpell("player", racial, false, false, false) then
                return true
            end
        end

        -- Divine Shield
        if ui.checked("Divine Shield") and cast.able.divineShield() and not br.UnitDebuffID("player", 25771) then
            if (php <= br.getOptionValue("Divine Shield") --health check
                    or br.UnitDebuffID("player", 272571)) --choking water in siege
                    or br.UnitDebuffID("player", 255421) --Devour
            then
                if cast.divineShield() then
                    return true
                end
            end
        end


        --	Divine Protection
        if ui.checked("Divine Protection") and cast.able.divineProtection() and not buff.divineShield.exists("player") then
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
        if ui.checked("Blessing of Freedom") and cast.able.blessingOfFreedom() and br.isMoving("player")
                and (br.hasNoControl(spell.blessingOfFreedom)
                or ui.checked("Use Blessing of Freedom for Snare") and debuff.graspingTendrils.exists("player")
                or debuff.vileCorruption.exists("player")) then
            if cast.blessingOfFreedom("player") then
                return true
            end
        end


    end
end -- End Action List - Defensive


actionList.Interrupt = function()

    if ui.checked("Hammer of Justice") and cast.able.hammerOfJustice() then
        for i = 1, #br.friend do
            if UnitIsCharmed(br.friend[i].unit) and br.getDebuffRemain(br.friend[i].unit, 272407) == 0 and br.friend[i].distance <= 10 then
                if cast.hammerOfJustice(thisUnit) then
                    return true
                end
            end
        end

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
            [265540] = true,
            [253544] = true
        }
        for i = 1, #enemies.yards10 do
            local thisUnit = enemies.yards10[i]
            local distance = br.getDistance(thisUnit)
            if (HOJ_unitList[br.GetObjectID(thisUnit)] ~= nil or HOJ_list[select(9, UnitCastingInfo(thisUnit))] ~= nil or HOJ_list[select(7, GetSpellInfo(UnitChannelInfo(thisUnit)))] ~= nil) and br.getBuffRemain(thisUnit, 226510) == 0 and distance <= 10 then
                if cast.hammerOfJustice(thisUnit) then
                    return true
                end
            end
        end
    end

    if br.useInterrupts() and (cast.able.blindingLight() or cast.able.hammerOfJustice()) and (ui.checked("Hammer of Justice") or ui.checked("Blinding Light")) then
        for i = 1, #enemies.yards10 do
            local thisUnit = enemies.yards10[i]
            local distance = br.getDistance(thisUnit)
            if br.canInterrupt(thisUnit, 99) and distance <= 10 and not br.isBoss(thisUnit) and StunsBlackList[br.GetObjectID(thisUnit)] == nil and UnitCastingInfo(thisUnit) ~= GetSpellInfo(257899) and UnitCastingInfo(thisUnit) ~= GetSpellInfo(258150) and UnitCastingInfo(thisUnit) ~= GetSpellInfo(252923) then
                -- Blinding Light
                if ui.checked("Blinding Light") then
                    if cast.blindingLight() then
                        return true
                    end
                end
                -- Hammer of Justice
                if ui.checked("Hammer of Justice") and cast.able.hammerOfJustice()
                        and br.getBuffRemain(thisUnit, 226510) == 0 -- never stun in Sanguine
                        and not br.isExplosive(thisUnit)
                        and (thisUnit == 130488 and ui.checked("ML - Stun jockeys") or thisUnit ~= 130488)
                then
                    if cast.hammerOfJustice(thisUnit) then
                        return true
                    end
                end
            end
        end
    end
    -- Repentance as interrupt
    if br.useInterrupts() and talent.repentance and cast.able.repentance() and ui.checked("Repentance as Interrupt") then
        for i = 1, #enemies.yards30 do
            thisUnit = enemies.yards30[i]
            if br.canInterrupt(thisUnit, 99) and getCastTimeRemain(thisUnit) > getCastTime(spell.repentance) and StunsBlackList[br.GetObjectID(thisUnit)] == nil and not br.isBoss(thisUnit) and UnitCastingInfo(thisUnit) ~= GetSpellInfo(257899) and UnitCastingInfo(thisUnit) ~= GetSpellInfo(258150) and UnitCastingInfo(thisUnit) ~= GetSpellInfo(252923) and UnitCreatureType(thisUnit) == CC_CreatureTypeList[i] then
                if cast.repentance(thisUnit) then
                    return true
                end
            end
        end
    end
end -- End Action List - Interrupt

actionList.Cooldown = function()


    if mode.pots == 1 then
        local auto_pot
        if #enemies.yards8 == 1 and noConc("target") then
            auto_pot = br.getOptionValue("Pots - 1 target (Boss)")
        elseif #enemies.yards8 >= 2 and #enemies.yards8 <= 3 then
            auto_pot = br.getOptionValue("Pots - 2-3 targets")
        elseif #enemies.yards8 >= 4 then
            auto_pot = br.getOptionValue("Pots - 4+ target")
        end

        if auto_pot ~= 1 and (buff.avengingWrath.remain() > 12 or buff.avengingCrusader.remain() > 12) then

            if auto_pot == 2 and br.canUseItem(163222) then
                br.useItem(163222)
            elseif auto_pot == 3 and br.canUseItem(152559) then
                br.useItem(152559)
            elseif auto_pot == 4 and br.canUseItem(109218) then
                br.useItem(109218)
            elseif auto_pot == 5 and br.canUseItem(142117) then
                br.useItem(142117)
            elseif auto_pot == 6 and #enemies.yards8 > 3 and br.canUseItem(168529) then
                br.useItem(168529)
            elseif auto_pot == 7 and br.canUseItem(168506) then
                br.useItem(168506)
            elseif auto_pot == 8 and br.canUseItem(168498) then
                br.useItem(168498)
            elseif auto_pot == 9 and br.canUseItem(169299) then
                br.useItem(169299)
            end
        end
    end  -- end pots

    if ui.checked("Bursting") and inInstance and #tanks > 0 then
        Burststack = br.getDebuffStacks(tanks[1].unit, 240443)
    end
    --burst check
    if Burststack >= br.getOptionValue("Burst Essence/items") then
        burst = true
    end
    -- Mana Potion
    if ui.checked("Mana Potion") and br.player.power.mana.percent() <= ui.value("Mana Potion") then
        if br.hasItem(152495) and br.canUseItem(152495) then
            br.useItem(152495)
        end
        if br.hasItem(127835) and br.canUseItem(127835) then
            br.useItem(127835)
        end
    end
    -- Arcane Torrent
    if ui.checked("Arcane Torrent Dispel") and race == "BloodElf" and br.getSpellCD(69179) == 0 then
        local torrentUnit = 0
        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]
            if br.canDispel(thisUnit, select(7, GetSpellInfo(GetSpellInfo(69179)))) then
                torrentUnit = torrentUnit + 1
                if torrentUnit >= br.getOptionValue("Arcane Torrent Dispel") then
                    if castSpell("player", racial, false, false, false) then
                        return true
                    end
                    break
                end
            end
        end
    end
    if ui.checked("Arcane Torrent Mana") and inCombat and race == "BloodElf" and cast.able.racial() and br.player.power.mana.percent() < br.getOptionValue("Arcane Torrent Mana") then
        if castSpell("player", racial, false, false, false) then
            return true
        end
    end
    -- Light's Judgment
    if ui.checked("Light's Judgment") and race == "LightforgedDraenei" and br.getSpellCD(255647) == 0 then
        if #enemies.yards40 >= ui.checked("Light's Judgment") then
            if cast.lightsJudgment(getBiggestUnitCluster(40, 5)) then
                return true
            end
        end
    end


    --BoP and BoF   blessing of freedom blessing of protection
    pre_BoF_list = {
        [264560] = { targeted = true } --"choking-brine"
    }

    if cast.able.blessingOfProtection() or cast.able.blessingOfFreedom() then
        if ui.checked("Blessing of Freedom") and cast.able.blessingOfFreedom() then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local _, _, _, _, endCast, _, _, _, spellcastID = UnitCastingInfo(thisUnit)
                spellTarget = select(3, br._G.UnitCastID(thisUnit))
            end
            if spellTarget ~= nil and endCast and pre_BoF_list[spellcastID] and ((endCast / 1000) - GetTime()) < 1 then
                if cast.blessingOfFreedom(spellTarget) then
                    return true
                end
            end

            for i = 1, #br.friend do
                if (ui.checked("Freehold - Blackout Barrel") and br.getDebuffRemain(br.friend[i].unit, 258875) ~= 0) -- barrel in FH
                        or br.getDebuffRemain(br.friend[i].unit, 258058) ~= 0 -- squuuuuze in TD
                        or br.getDebuffRemain(br.friend[i].unit, 257478) ~= 0 --crippling-bite in FH
                        or br.getDebuffRemain(br.friend[i].unit, 274383) ~= 0 -- rat-traps in FH
                        or br.getDebuffRemain(br.friend[i].unit, 257747) ~= 0 -- earth-shaker in FH
                        or br.getDebuffRemain(br.friend[i].unit, 268050) ~= 0 -- anchor-of-binding in Shrine
                        or br.getDebuffRemain(br.friend[i].unit, 267899) ~= 0 -- hindering-cleave in Shrine
                        or br.getDebuffRemain(br.friend[i].unit, 267899) ~= 0 -- hindering-cleave in Shrine
                then
                    if cast.blessingOfFreedom(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end
        if ui.checked("Blessing of Protection") and cast.able.blessingOfProtection() then
            if (br.friend[i].hp <= ui.value("Blessing of Protection")
                    or br.getDebuffRemain(br.friend[i].unit, 260741) ~= 0 --Jagged Nettles
                    or (br.getDebuffRemain(br.friend[i].unit, 255421) ~= 0 and (br.friend[i].unit ~= "player" or cd.divineProtection.remain() > 0)) -- Devour
                    or (ui.checked("Tol Dagor - Deadeye") and br.getDebuffRemain(br.friend[i].unit, 256038) ~= 0 and br.friend[i].unit ~= "player"))
                    or (ui.checked("Freehold - Blackout Barrel") and br.getDebuffRemain(br.friend[i].unit, 258875) ~= 0)
                    or (ui.checked("KR - Severing axe") and br.getDebuffRemain(br.friend[i].unit, 266231) ~= 0)
            then
                if UnitInRange(br.friend[i].unit) and not debuff.forbearance.exists(br.friend[i].unit)
                        and not (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
                    if cast.blessingOfProtection(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end
    end


    -- Lay on Hands        --LoH / LayonHands
    if ui.checked("Lay on Hands") and cast.able.layOnHands(br.friend[1].unit) and not debuff.forbearance.exists(br.friend[1].unit) and UnitInRange(br.friend[1].unit) then
        if timers.time("LoH Timer", lowest.hp <= ui.value("Lay on Hands")) > 0.8 then
            if cast.layOnHands(lowest.unit) then
                return true
            end
        end
    end

    -- Blessing of Sacrifice


    if ui.checked("Blessing of Sacrifice") and cast.able.blessingOfSacrifice() and inCombat then
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

    --[[
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
                      UseItemByName(select(1, _G.GetInventoryItemID("player", 13)), br.friend[i].unit)
                      return true
                  end
              end
          elseif br.getOptionValue("Trinket 1 Mode") == 3 and #tanks > 0 then
              for i = 1, #tanks do
                  -- get the tank's target
                  local tankTarget = br._G.UnitTarget(tanks[i].unit)
                  if tankTarget ~= nil then
                      -- get players in melee range of tank's target
                      local meleeFriends = getAllies(tankTarget, 5)
                      -- get the best ground circle to encompass the most of them
                      local loc
                      if #meleeFriends >= 8 then
                          loc = br.getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                      else
                          local meleeHurt = {}
                          for j = 1, #meleeFriends do
                              if meleeFriends[j].hp < ui.checked("Trinket 1") then
                                  tinsert(meleeHurt, meleeFriends[j])
                              end
                          end
                          if #meleeHurt >= ui.checked("Min Trinket 1 Targets") or burst == true then
                              loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                          end
                      end
                      if loc ~= nil then
                          br.useItem(13)
                          ClickPosition(loc.x, loc.y, loc.z)
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
                  if br.friend[i].hp <= ui.checked("Trinket 2") then
                      UseItemByName(select(1, _G.GetInventoryItemID("player", 14)), br.friend[i].unit)
                      return true
                  end
              end
          elseif br.getOptionValue("Trinket 2 Mode") == 3 and #tanks > 0 then
              for i = 1, #tanks do
                  -- get the tank's target
                  local tankTarget = br._G.UnitTarget(tanks[i].unit)
                  if tankTarget ~= nil then
                      -- get players in melee range of tank's target
                      local meleeFriends = getAllies(tankTarget, 5)
                      -- get the best ground circle to encompass the most of them
                      local loc
                      if #meleeFriends >= 8 then
                          loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                      else
                          local meleeHurt = {}
                          for j = 1, #meleeFriends do
                              if meleeFriends[j].hp < ui.checked("Trinket 2") then
                                  tinsert(meleeHurt, meleeFriends[j])
                              end
                          end
                          if #meleeHurt >= ui.checked("Min Trinket 2 Targets") or burst == true then
                              loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                          end
                      end
                      if loc ~= nil then
                          br.useItem(14)
                          ClickPosition(loc.x, loc.y, loc.z)
                          return true
                      end
                  end
              end
          elseif br.getOptionValue("Trinket 1 Mode") == 4 then
              if br.canUseItem(14) and ttd(units.dyn40) > 5 then
                  UseItemByName(select(1, _G.GetInventoryItemID("player", 14)), units.dyn40)
                  return true
              end
          end
      end
    ]]
    -- Holy Avenger
    if ui.checked("Holy Avenger") and cast.able.holyAvenger() and talent.holyAvenger then
        if br.getLowAllies(ui.value("Holy Avenger")) >= ui.value("Holy Avenger Targets") then
            if cast.holyAvenger() then
                return true
            end
        end
    end
    -- Avenging Wrath
    if ui.checked("Avenging Wrath") and cast.able.avengingWrath() and not talent.avengingCrusader then
        if br.getLowAllies(ui.value("Avenging Wrath")) >= ui.value("Avenging Wrath Targets") then
            if cast.avengingWrath() then
                return true
            end
        end
    end
    -- Avenging Crusader
    if ui.checked("Avenging Crusader") and cast.able.avengingCrusader() and talent.avengingCrusader and br.getDistance("target") <= 5 then
        if br.getLowAllies(ui.value("Avenging Crusader")) >= ui.value("Avenging Crusader Targets") then
            if cast.avengingCrusader() then
                return true
            end
        end
    end
    -- Aura Mastery
    if ui.checked("Aura Mastery") and cast.able.auraMastery() then
        if br.getLowAllies(ui.value("Aura Mastery")) >= ui.value("Aura Mastery Targets") then
            if cast.auraMastery() then
                return true
            end
        end
    end

    -- Unstable Temporal Time Shifter
    if ui.checked("Eng Brez") and br.canUseItem(184308) and not moving and inCombat and lowest.hp > ui.value("Critical HP") then
        if br.getOptionValue("Eng Brez") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and br.GetUnitIsFriend("target", "player") then
            br._G.UseItemByName(184308, "target")
        end
        if br.getOptionValue("Eng Brez") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and br.GetUnitIsFriend("mouseover", "player") then
            br._G.UseItemByName(184308, "mouseover")
        end
        if br.getOptionValue("Eng Brez") == 3 then
            for i = 1, #br.friend do
                if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") then
                    br._G.UseItemByName(184308, br.friend[i].unit)
                end
            end
        end
    end


end -- End Action List - Cooldowns

actionList.bossfight = function()
end

actionList.heal = function()
    -- heal()
    --  Print("lowest:" .. br._G.UnitName(lowest.unit) .. " at: " .. round(br.getHP(lowest.unit), 2))

    --checking for HE
    if br.data.settings[br.selectedSpec][br.selectedProfile]["HE ActiveCheck"] == false and br.timer:useTimer("Error delay", 3.5) then
        br._G.print("HEAL ENGINE IS NOT ON - HEAL ENGINE NEED TO BE ON - YOU SHOULD TURN THE HEAL ENGINE ON.")
        return
    end
    -- tanks = br.getTanksTable()
    -- always a beacon up on tank
    local LightCount = 0
    local FaithCount = 0
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

    if br.timer:useTimer("Beacon Delay", 3) then
        if #tanks > 0 and (LightCount == 0 or buff.beaconOfLight.exists("Player")) then
            for i = 1, #tanks do
                if not buff.beaconOfLight.exists(tanks[i].unit) and not buff.beaconOfFaith.exists(tanks[i].unit) and UnitInRange(tanks[i].unit) then
                    if cast.beaconOfLight(tanks[i].unit) then
                        return true
                    end
                end
            end
        elseif (#tanks == 0 and LightCount == 0) and not buff.beaconOfLight.exists("Player") and not buff.beaconOfFaith.exists("Player") then
            if cast.beaconOfLight("Player") then
                return true
            end
        end
    end

    --trying out new stuff here
    --hs, dawn, flash(infused), Lotm, flash

    --Critical first
    if healTarget == "none" then
        if php <= ui.value("Critical HP") then
            healTarget = "player"
            healReason = "CRIT"
        end
    end
    if healTarget == "none" then
        if lowest.hp <= ui.value("Critical HP") and br.getLineOfSight(lowest.unit, "player") and UnitInRange(lowest.unit) then
            healTarget = lowest.unit
            healReason = "CRIT"
        end
    end

    if healTarget == "none" then
        -- Junkyard
        if inInstance and inCombat and select(8, GetInstanceInfo()) == 2097 then
            for i = 1, #br.friend do
                if br.getDebuffRemain(br.friend[i].unit, 302274) ~= 0 --Fulminating Zap
                        and br.friend[i].hp < 80 then
                    healTarget = br.friend[i].unit
                    healReason = "BOSS"
                end
            end
        end
        -- Waycrest Manor
        if inInstance and inCombat and select(8, GetInstanceInfo()) == 1862 then
            for i = 1, #br.friend do
                if br.getDebuffRemain(br.friend[i].unit, 260741) ~= 0 --Jagged Nettles
                        and br.friend[i].hp < 95 then
                    healTarget = br.friend[i].unit
                    healReason = "BOSS"
                end
            end
        end
        --Kings Rest
        if inInstance and inCombat and select(8, GetInstanceInfo()) == 1762 then
            for i = 1, #br.friend do
                if br.getDebuffRemain(br.friend[i].unit, 267626) ~= 0 -- Dessication
                        or br.getDebuffRemain(br.friend[i].unit, 267618) ~= 0 -- Drain Fluids
                        or br.getDebuffRemain(br.friend[i].unit, 266231) ~= 0 -- Severing axe from axe lady in council
                        or br.getDebuffRemain(br.friend[i].unit, 272388) ~= 0 -- shadow barrage
                        or br.getDebuffRemain(br.friend[i].unit, 265773) > 1 -- spit-gold
                        or (br.getDebuffRemain(br.friend[i].unit, 270487) ~= 0 and br.getDebuffStacks(br.friend[i].unit, 270487) > 1) -- severing-blade
                        and br.friend[i].hp < 95 then
                    healTarget = br.friend[i].unit
                    healReason = "BOSS"
                end
            end
        end
    end

    --Talent Crusaders Might   - should only be used to get full value out of holy shock proc .. hard coded to 1.5

    if talent.crusadersMight and lowest.hp > ui.value("Critical HP") and (br.getSpellCD(20473) > (gcd)) then
        if cast.crusaderStrike(units.dyn5) then
            return true
        end
    end

    if cast.able.crusaderStrike() and talent.crusadersMight and cd.holyShock.remain() >= 1.5 and not cd.judgment.remain() == 0 and br.getFacing("player", units.dyn5) and #enemies.yards5 >= 1 then
        if cast.crusaderStrike(units.dyn5) then
            br.addonDebug("[FILL]CrusaderStrike on " .. br._G.UnitName(units.dyn5) .. " CD/HS: " .. round(cd.holyShock.remain(), 2))
            return true
        end
    end

    if healTarget == "none" then
        --Grievous Wounds
        if ui.checked("Grievous Wounds") then
            for i = 1, #br.friend do
                if br.friend[i].hp < 100 and UnitInRange(br.friend[i].unit) or br.GetUnitIsUnit(br.friend[i].unit, "player") then
                    local CurrentBleedstack = br.getDebuffStacks(br.friend[i].unit, 240559)
                    if br.getDebuffStacks(br.friend[i].unit, 240559) >= ui.value("Grievous Wounds") then
                        BleedFriendCount = BleedFriendCount + 1
                    end
                    if CurrentBleedstack > BleedStack then
                        BleedStack = CurrentBleedstack
                        healTarget = br.friend[i].unit
                        healReason = "GRIV"
                    end
                end
            end
            --todo here is an idea - what if healtarget is 80%+ HP and has glimmer buff on them .. but someone else in the group does not
        end
    end
    if healTarget == "none" then
        --m+ boss fight stuff

        --Last boss in temple
        if inCombat and br.player.eID and br.player.eID == 2127 then
            for i = 1, GetObjectCount() do
                if br.GetObjectID(GetObjectWithIndex(i)) == 133392 and br.getHP(GetObjectWithIndex(i)) < 100 and br.getBuffRemain(GetObjectWithIndex(i), 274148) == 0 then
                    healTarget = GetObjectWithIndex(i)
                    healReason = "BOSS"
                end
            end
        end
        if ui.checked("Freehold - pig") and GetMinimapZoneText() == "Ring of Booty" then
            bossHelper()
        end
    end

    if cast.able.holyShock() then
        if healTarget == "none" and mode.glimmer == 3 and #tanks > 0 then
            for i = 1, #tanks do
                if not br.UnitBuffID(tanks[i].unit, 287280, "PLAYER") and not br.UnitBuffID(tanks[i].unit, 115191) and br.getLineOfSight(tanks[i].unit, "player") then
                    healTarget = tanks[i].unit
                    healReason = "GLIM"
                end
            end
        end
        if healTarget == "none" then
            if lowest.hp <= ui.value("Holy Shock") and (br.getLineOfSight(lowest.unit, "player") and UnitInRange(lowest.unit) or lowest.unit == "player") then
                healTarget = lowest.unit
                healReason = "HEAL"
            end
        end
        if talent.glimmerOfLight and healTarget == "none" and not br.player.inCombat and ui.checked("OOC Glimmer") then
            -- ooc blanketting
            for i = 1, #br.friend do
                if not buff.glimmerOfLight.exists(br.friend[i].unit, "exact") and (br.getLineOfSight(br.friend[i].unit, "player") and UnitInRange(br.friend[i].unit) or br.friend[i].unit == "player") then
                    healTarget = br.friend[i].unit
                    healReason = "GLIM"
                end
            end
        end
        if healTarget ~= "none" then
            healTargetHealth = round(br.getHP(healTarget), 1)
            if cast.holyShock(healTarget) then
                br.addonDebug("[" .. healReason .. "] Holyshock on: " .. br._G.UnitName(healTarget) .. "/" .. healTargetHealth)
                healTarget = "none"
                return true
            end
        end
    end -- end holy shock
    -- Light of Dawn

    if ui.checked("Light of Dawn") and (holyPower >= 3 or buff.divinePurpose.exists()) then
        if bestConeHeal(spell.lightOfDawn, ui.value("LoD Targets"), ui.value("Light of Dawn"), 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5) then
            healTarget = "none"
            return true
        end
    end

    if healTarget == "none" and ui.checked("Word of Glory") and (holyPower >= 3 or buff.divinePurpose.exists()) then
        if (lowest.hp <= ui.value("Word of Glory")) then
            healTarget = lowest.unit
            healReason = "HEAL"
        end
    end
    if healTarget ~= "none" and ui.checked("Word of Glory") and (holyPower >= 3 or buff.divinePurpose.exists()) then
        if cast.wordOfGlory(healTarget) then
            healTarget = "none"
            return true
        end
    end


    -- Bestow Faith
    if talent.bestowFaith and cast.able.bestowFaith() then
        if healTarget == "none" then
            if lowest.hp <= 90 and (UnitInRange(lowest.unit) or lowest.unit == "player") then
                healTarget = lowest.unit
                healReason = "HEAL"
            end
        end
        if healTarget ~= "none" then
            if cast.bestowFaith(healTarget) then
                br.addonDebug("[" .. healReason .. "] Bestow Faith on: " .. br._G.UnitName(healTarget))
                healTarget = "none"
                return true
            end
        end
    end -- end Bestow Faith

    if cast.able.flashOfLight() and buff.infusionOfLight.exists() and not cast.last.flashOfLight() and not br.isMoving("player") then
        if healTarget == "none" then
            if lowest.hp <= ui.value("Infused Flash of Light") and (br.getLineOfSight(lowest.unit, "player") and UnitInRange(lowest.unit) or lowest.unit == "player") then
                healTarget = lowest.unit
                healReason = "HEAL"
                --                Print("healtarget: " .. healTarget .. " health:" .. round(lowest.hp, 2) .. " //" .. tostring(lowest.hp < ui.checked("Infused Flash of Light")))
            end
        end
        if healTarget ~= "none" then
            healTargetHealth = round(br.getHP(healTarget), 1)
            --   if healTargetHealth < ui.checked("Infused Flash of Light") then
            if cast.flashOfLight(healTarget) then
                br.addonDebug("[" .. healReason .. "] (I)flashOfLight on: " .. br._G.UnitName(healTarget) .. "/" .. healTargetHealth .. "/" .. (ui.value("Infused Flash of Light")))
                healTarget = "none"
                return true
                --      end
            end
        end
    end

    --hs, dawn, flash(infused), Lotm, flash xxxxxx
    -- Light of Martyr
    if healTarget == "none" then
        if ui.checked("Light of the Martyr") and (php >= br.getOptionValue("LotM player HP limit") or buff.divineShield.exists("player")) and cast.able.lightOfTheMartyr()
                and br.getDebuffStacks("player", 267034) < 2 -- not if we got stacks on last boss of shrine
                and br.getDebuffStacks("player", 265773) == 0 -- not if we got spit gold on us then  then
                and lowest.hp <= ui.value("Light of the Martyr") and not br.GetUnitIsUnit(lowest.unit, "player")
                and br.getLineOfSight(lowest.unit, "player") and UnitInRange(lowest.unit) then
            healTarget = lowest.unit
            healReason = "HEAL"
        end
    end
    if healTarget ~= "none" and not br.GetUnitIsUnit(healTarget, "player") and br.getDebuffStacks("player", 267034) < 2 then
        healTargetHealth = round(br.getHP(healTarget), 1)
        if cast.lightOfTheMartyr(healTarget) then
            br.addonDebug("[" .. healReason .. "] lightOfTheMartyr on: " .. br._G.UnitName(healTarget) .. "/" .. healTargetHealth)
            healTarget = "none"
            return true
        end
    end

    if cast.able.flashOfLight() and not br.isMoving("player") then
        if healTarget == "none" then
            if lowest.hp <= ui.value("Flash of Light") and (br.getLineOfSight(lowest.unit, "player") and UnitInRange(lowest.unit) or lowest.unit == "player") then
                healTarget = lowest.unit
                healReason = "HEAL"
            end
        end
        if healTarget ~= "none" then
            healTargetHealth = round(br.getHP(healTarget), 1)
            if cast.flashOfLight(healTarget) then
                br.addonDebug("[" .. healReason .. "] flashOfLight on: " .. br._G.UnitName(healTarget) .. "/" .. healTargetHealth)
                healTarget = "none"
                return true
            end
        end
    end
end -- End Action List - heal


actionList.PreCombat = function()
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()

    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff = br.player.buff
    cast = br.player.cast
    racial = br.player.getRacial()
    cd = br.player.cd
    debuff = br.player.debuff
    enemies = br.player.enemies
    equiped = br.player.equiped
    gcd = br.player.gcd
    gcdMax = br.player.gcdMax
    has = br.player.has
    inCombat = br.player.inCombat
    item = br.player.items
    level = br.player.level
    mode = br.player.ui.mode
    php = br.player.health
    spell = br.player.spell
    talent = br.player.talent
    traits = br.player.traits
    essence = br.player.essence
    units = br.player.units
    ui = br.player.ui
    lowest = br.friend[1]
    use = br.player.use
    tanks = br.getTanksTable()
    healTarget = "none"
    healReason = "none"
    healTargetHealth = 100
    inInstance = br.player.instance == "party"
    inRaid = br.player.instance == "raid"
    solo = br.friends == 1
    holyPower = br.player.power.holyPower.amount()
    holyPowerMax = br.player.power.holyPower.max()

    -- General Locals
    hastar = br.GetObjectExists("target")
    healPot = br.getHealthPot()
    profileStop = profileStop or false
    ttd = br.getTTD
    haltProfile = (inCombat and profileStop) or (br._G.IsMounted() or br._G.IsFlying()) or br.pause() or mode.rotation == 4
    -- Units
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

    local glimmerCount = 0

    if timersTable then
        wipe(timersTable)
    end

    if br.player.runeforge.shadowbreaker.equiped then
        lightOfDawn_distance = 40
    else
        lightOfDawn_distance = 15
    end
    if buff.ruleOfLaw.exists("player") then
        lightOfDawn_distance_coff = 1.5
    else
        lightOfDawn_distance_coff = 1
    end
    if buff.ruleOfLaw.exists("player") then
        lightOfDawn_distance_coff = 1.5
        master_coff = 1.5
    else
        lightOfDawn_distance_coff = 1
        master_coff = 1.0
    end
    if not br.isCastingSpell(spell.flashOfLight) then
        BOV = nil
    end
    if not br.isCastingSpell(spell.flashOfLight) and not br.isCastingSpell(spell.holyLight) then
        healing_obj = nil
    end

    if mode.glimmer == 1 then
        for i = 1, #br.friend do
            if buff.glimmerOfLight.remain(br.friend[i].unit, "exact") > gcd then
                glimmerCount = glimmerCount + 1
            end
        end
        if ui.checked("Aggressive Glimmer") and debuff.glimmerOfLight.remain("target", "exact") > gcd then
            glimmerCount = glimmerCount + 1
        end
    end

    br.player.ui.mode.DPS = br.data.settings[br.selectedSpec].toggles["DPS"]




    -- Profile Specific Locals

    -- SimC specific variables


    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if (not IsMounted() or buff.divineSteed.exists()) then
        if br.pause() or drinking or br.hasBuff(250873) or br.hasBuff(115834) or br.hasBuff(58984) or br.hasBuff(185710) or br.isCastingSpell(212056) then
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
                if actionList.PreCombat() then
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
                if actionList.heal() then
                    return true
                end
                if actionList.ooc() then
                    return true
                end
            else
                --Print("In Combat")

                --combat stuff
                if actionList.Extra() then
                    return true
                end
                if spellQueueReady() then
                    if not br.SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus() or lowest.hp <= br.getOptionValue("Critical HP") then
                        if actionList.Defensive() then
                            return true
                        end
                        if actionList.PreCombat() then
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
                        if talent.glimmerOfLight and (mode.glimmer == 1 or mode.glimmer == 3) and cast.able.holyShock() or cast.able.lightOfDawn() then
                            -- and glimmerCount <= 8
                            if actionList.glimmer() then
                                return true
                            end
                        end
                        if actionList.heal() then
                            return true
                        end
                    end
                    if actionList.dps() then
                        return true
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
tinsert(
        br.rotations[id],
        {
            name = rotationName,
            toggles = createToggles,
            options = createOptions,
            run = runRotation
        }
)