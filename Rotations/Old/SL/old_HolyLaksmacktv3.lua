local rotationName = "Laks M+ " -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Define custom toggles
    -- Rotation Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 0, icon = br.player.spell.holyAvenger },
        [2] = { mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.auraMastery },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.absolution }
    }
    CreateButton("Cooldown", 1, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 0, icon = br.player.spell.divineProtection },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.blessingOfProtection }
    }
    CreateButton("Defensive", 2, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.blindingLight },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.blindingLight }
    }
    CreateButton("Interrupt", 3, 0)
    -- Cleanse Button
    CleanseModes = {
        [1] = { mode = "On", value = 1, overlay = "Cleanse Enabled", tip = "Cleanse Enabled", highlight = 0, icon = br.player.spell.cleanse },
        [2] = { mode = "Off", value = 2, overlay = "Cleanse Disabled", tip = "Cleanse Disabled", highlight = 0, icon = br.player.spell.cleanse }
    }
    CreateButton("Cleanse", 4, 0)
    -- Glimmer
    GlimmerModes = {
        [1] = { mode = "On", value = 1, overlay = "Glimmer mode", tip = "Glimmer on", highlight = 0, icon = 287280 },
        [2] = { mode = "Off", value = 2, overlay = "Normal", tip = "Glimmer off", highlight = 0, icon = br.player.spell.holyShock },
        [3] = { mode = "Tank", value = 3, overlay = "Normal", tip = "Glimmer on tank", highlight = 0, icon = 278573 }
    }
    CreateButton("Glimmer", 5, 0)
    -- DPS
    DPSModes = {
        [1] = { mode = "On", value = 1, overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 0, icon = br.player.spell.judgment },
        [2] = { mode = "Off", value = 2, overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.judgment },
    }
    CreateButton("DPS", 6, 0)
    PotsModes = {
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
        section = br.ui:createSection(br.ui.window.profile, "Corruption Management")
        br.ui:createCheckbox(section, "Use Hammer of Justice on TFTB")
        br.ui:createCheckbox(section, "Use Blinding Light on TFTB")
        br.ui:createCheckbox(section, "Use Blessing of Freedom for Snare")
        br.ui:createDropdownWithout(section, "Use Cloak", { "snare", "Eye", "THING", "Never" }, 4, "", "")
        br.ui:createSpinnerWithout(section, "Eye Of Corruption Stacks - Cloak", 1, 0, 20, 1)
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
        section = br.ui:createSection(br.ui.window.profile, "Essences")
        br.ui:createSpinner(section, "ConcentratedFlame - Heal", 50, 0, 100, 5, "", "health to heal at")
        br.ui:createCheckbox(section, "ConcentratedFlame - DPS")
        br.ui:checkSectionState(section)
    end

    local function oocoptions()
        section = br.ui:createSection(br.ui.window.profile, "OOC Settings")
        br.ui:createSpinner(section, "Auto Drink", 45, 0, 100, 5, "Mana Percent to Drink At")
        br.ui:createCheckbox(section, "Sugar Crusted Fish Feast", "Use feasts for mana?")
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

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local glimmerCount = 0
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
local buff
local cast
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
local drinking = getBuffRemain("player", 192002) ~= 0 or getBuffRemain("player", 167152) ~= 0 or getBuffRemain("player", 192001) ~= 0 or getDebuffRemain("player", 185710) ~= 0 or getDebuffRemain("player", 297098) ~= 0 or getDebuffRemain("player", 274914) ~= 0

local ttd

local burst = nil
local Burststack = 0
local BleedFriendCount = 0
local BleedStack = 0

local healTarget
local healReason
local healTargetHealth



-- Profile Specific Locals - Any custom to profile locals
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

if isChecked("ML - Stun jockeys") then
    HOJ_unitlis[130488] = "Mech Jockey"
end

-----------------
------ Functions --- -- List all profile specific custom functions here
-----------------

noconc_list = {
    [161124] = "urgroth - breaker - of - heroes",
    [161244] = "blood - of - the - corruptor",
    [161243] = "samhrek - beckoner - of - chaos",
    [161241] = "voidweaver - malthir"
}

local function noConc(unit)
    if isBoss(unit) or noconc_list[GetObjectID(unit)] ~= nil then
        return true
    end
end
local function isCC(unit)
    if getOptionCheck("Don't break CCs") then
        return isLongTimeCCed(Unit)
    end
end
local function noDamageCheck(unit)
    if isChecked("Dont DPS spotter") and GetObjectID(unit) == 135263 then
        return true
    end
    if isChecked("Shrine - ignore adds last boss") and GetObjectID(unit) == 135903 then
        return true
    end
    if isCC(unit) then
        return true
    end
    if hasBuff(263246, unit) then
        -- shields on first boss in temple
        return true
    end
    if hasBuff(260189, unit) then
        -- shields on last boss in MOTHERLODE
        return true
    end
    if hasBuff(261264, unit) or hasBuff(261265, unit) or hasBuff(261266, unit) then
        -- shields on witches in wm
        return true
    end
    if GetObjectID(thisUnit) == 128652 then
        --https://www.wowhead.com/npc=128652/viqgoth
        return true
    end

    return false --catchall
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
    while facing <= 6.28 do
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

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------

actionList.glimmer = function()
    -- glimmer()


    --  Print(mode.dPS)

    br.player.ui.mode.DPS = br.data.settings[br.selectedSpec].toggles["DPS"]

    if cast.able.holyShock() then
        local glimmerCount = 0
        for i = 1, #br.friend do
            if buff.glimmerOfLight.remain(br.friend[i].unit, "exact") > gcd then
                glimmerCount = glimmerCount + 1
            end
        end


        --Glimmer support
        if isChecked("Aggressive Glimmer") and br.player.ui.mode.DPS == 1 and br.player.inCombat and UnitIsEnemy("target", "player") and lowest.hp > getValue("Critical HP") then
            if br.player.ui.mode.DPS == 1 and not debuff.glimmerOfLight.exists("target", "EXACT") and GetUnitExists("target") and getFacing("player", "target") then
                if cast.holyShock("target") then
                    br.addonDebug("[GLIM] Aggressive Glimmer on: " .. UnitName("target"))
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
                if UnitInRange(tanks[i].unit) and getLineOfSight(tanks[i].unit, "player") then
                    if not UnitBuffID(tanks[i].unit, 287280) then
                        if cast.holyShock(tanks[i].unit) then
                            br.addonDebug("[GLIM] Tank-Glimmer on " .. UnitName(tanks[i].unit) .. "/" .. tostring(glimmerCount))
                            return true
                        end
                    end
                end
            end
        end

        if mode.glimmer == 1 then
            glimmerTable = {}
            for i = 1, #br.friend do
                if (UnitInRange(br.friend[i].unit) and getLineOfSight(br.friend[i].unit, "player") or br.friend[i].unit == "player") and not UnitBuffID(br.friend[i].unit, 287280, "PLAYER") and not UnitBuffID(br.friend[i].unit, 115191) then
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
                            --Print(getDistance(glimmerTable[1]))
                            br.addonDebug("[GLIM] Rule Of Law - distance: " .. tostring(glimmerTable[1].distance))
                            return true
                        end
                    end
                end
                if cast.holyShock(glimmerTable[1].unit) then
                    --Print("Just glimmered: " .. glimmerTable[1].unit)
                    br.addonDebug("[GLIM] Glimmer on: " .. UnitName(glimmerTable[1].unit) .. "/" .. tostring(glimmerCount))
                    return true
                end
            end
        end
    end

    -- Light of Dawn
    if isChecked("Light of Dawn") and cast.able.lightOfDawn() then
        if EasyWoWToolbox == nil then
            if healConeAround(getValue("LoD Targets"), getValue("Light of Dawn"), 90, lightOfDawn_distance * lightOfDawn_distance_coff, 5 * lightOfDawn_distance_coff)
            then
                if cast.lightOfDawn() then
                    return true
                end
            end
        else
            if bestConeHeal(spell.lightOfDawn, getValue("LoD Targets"), getValue("Light of Dawn"), 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5) then
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
            if canDispel(br.friend[i].unit, spell.cleanse) and (getLineOfSight(br.friend[i].unit) and getDistance(br.friend[i].unit) <= 40 or br.friend[i].unit == "player") then
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

    if isChecked("Auto Drink") and getMana("player") <= getOptionValue("Auto Drink") and not moving and getDebuffStacks("player", 240443) == 0 and getDebuffStacks("player", 240443) == 0 then
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

        if not isChecked("Sugar Crusted Fish Feast") or (isChecked("Sugar Crusted Fish Feast") and not hasItem(126936)) and not hasBuff(185710) then
            if hasItem(65499) and canUseItem(65499) then
                useItem(65499)
            end
            if hasItem(113509) and canUseItem(113509) then
                useItem(113509)
            end
            if hasItem(159867) and canUseItem(159867) then
                useItem(159867)
            end
            if hasItem(163784) and canUseItem(163784) then
                useItem(163784)
            end
        elseif isChecked("Sugar Crusted Fish Feast") and hasItem(126936) then
            local x1, y1, z1 = ObjectPosition("player")
            br.addonDebug("scaninning -  fish thingy")
            for i = 1, GetObjectCount() do
                local object = GetObjectWithIndex(i)
                local ID = ObjectID(object)
                local x2, y2, z2 = ObjectPosition(object)
                local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                if ID == 242405 and distance < 15 then
                    --print(tostring(distance))
                    InteractUnit(object)
                    fishfeast = 1
                    return true
                else
                    if hasItem(126936) and canUseItem(126936) and fishfeast == 0 then
                        useItem(126936)
                        x1 = x1 + math.random(-2, 2)
                        ClickPosition(x1, y1, z1)
                        br.addonDebug("Placing fish thingy")
                        fishfeast = 1
                        return true
                    end
                end
            end
        end
    end
    --I got nothing else to do
    local standingTime = 0
    if DontMoveStartTime then
        standingTime = GetTime() - DontMoveStartTime
    end
    if not isMoving("Player") and standingTime > getValue("OOC Holy Heal - Time") and not drinking and getMana("player") >= getValue("OOC Holy Heal - Mana") and getHP(lowest.unit) < getValue("OOC Holy Heal - Health") then
        if cast.holyLight(lowest.unit) then
        end
    end
end

actionList.dps = function()
    -- j / con / HS / CS

    --Auto attack
    if not IsAutoRepeatSpell(GetSpellInfo(6603)) and #enemies.yards8 >= 1 then
        StartAttack(units.dyn5)
    end

    --Judgment
    if cast.able.judgment() and cd.holyShock.remain() > 1 then
        if #tanks == 0 or #tanks > 0 and getDistance(units.dyn30, tanks[1].unit) <= 10 then
            if traits.indomitableJustice.active then
                for i = 1, #enemies.yards30 do
                    if getHP(enemies.yards30[i]) < getHP("player") and getFacing("player", enemies.yards30[i]) then
                        br.addonDebug("[DPS]Judgment - indomitableJustice" .. "[" .. round(getHP(enemies.yards30[i]), 2) .. "/" .. round(getHP("player"), 2) .. "]")
                        if cast.judgment(enemies.yards30[i]) then
                            return true
                        end
                    end
                end
            end
            if getFacing("player", units.dyn30) then
                if cast.judgment(units.dyn30) then
                    br.addonDebug("[DPS]Judgment [" .. round(getHP(enemies.yards30[i]), 2) .. "/" .. round(getHP("player"), 2) .. "]")
                    return true
                end
            end
        end
    end

    --Consecration
    if cast.able.consecration() and not isMoving("player") then
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

    if isChecked("Group CD's with DPS key") and SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus() then
        -- popping CD's with DPS Key
        if cast.holyAvenger() then
            return true
        end
        if cast.avengingWrath() then
            return true
        end
        --trinkets w/CD
        if isChecked("Trinket 1") and getOptionValue("Trinket 1 Mode") == 5 and inCombat then
            if canUseItem(13) then
                useItem(13)
            end
        end
        if isChecked("Trinket 2") and getOptionValue("Trinket 1 Mode") == 5 and inCombat then
            if canUseItem(14) then
                useItem(14)
            end
        end
    end

    if (inInstance and #tanks > 0 and getDistance(units.dyn40, tanks[1].unit) <= 15
            or #tanks > 0 and getDistance(tanks[1].unit) >= 90)
            or (inRaid and #tanks > 0 and getDistance(units.dyn40, tanks[1].unit) <= 40 or #tanks > 0 and getDistance(tanks[1].unit) >= 90)
            or not inInstance or not inRaid or solo then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if not debuff.glimmerOfLight.exists(thisUnit, "exact") and not noDamageCheck(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and getFacing("player", thisUnit) then
                if cast.holyShock(thisUnit) then
                    br.addonDebug("[DPS]HolyShock on " .. UnitName(thisUnit) .. " w/Glimmer")
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
    if isChecked("Trinket 1") and getOptionValue("Trinket 1 Mode") == 4 and inCombat then
        if canUseItem(13) then
            useItem(13)
        end
    end
    if isChecked("Trinket 2") and getOptionValue("Trinket 2 Mode") == 4 and inCombat then
        if canUseItem(14) then
            useItem(14)
        end
    end

    --Talent Crusaders Might   - should only be used to get full value out of holy shock proc .. hard coded to 1.5
    if cast.able.crusaderStrike() and ((talent.crusadersMight and cd.holyShock.remain() >= 1.5) or not talent.crusadersMight) and getFacing("player", units.dyn5) and #enemies.yards8 >= 1 then
        if cast.crusaderStrike(units.dyn5) then
            br.addonDebug("[DPSx]CrusaderStrike on " .. UnitName(units.dyn5) .. " CD/HS: " .. round(cd.holyShock.remain(), 2))
            return true
        end
    end
end

actionList.Extra = function()

    if isChecked("Use Blinding Light on TFTB") or isChecked("Use Hammer of Justice on TFTB") then

        local stun = 0

        if talent.blindingLight and cast.able.blindingLight() and isChecked("Use Blinding Light on TFTB") then
            stun = 115750
        elseif isChecked("Use Hammer of Justice on TFTB") and cast.able.hammerOfJustice() then
            stun = 853
        end

        for i = 1, GetObjectCount() do
            local object = GetObjectWithIndex(i)
            local ID = ObjectID(object)

            if stun ~= 0 then
                if ID == 161895 and not isLongTimeCCed(object) and not debuff.blindingLight.exists(object) and not debuff.hammerOfJustice.exists(object) then
                    local x1, y1, z1 = ObjectPosition("player")
                    local x2, y2, z2 = ObjectPosition(object)
                    local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                    if distance < 10 then
                        CastSpellByName(GetSpellInfo(stun), object)
                        return true
                    end
                end
            end -- end the thing
        end
    end

end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()


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
        if isChecked("Gift of The Naaru") and php <= getOptionValue("Gift of The Naaru") and php > 0 and br.player.race == "Draenei" then
            if castSpell("player", racial, false, false, false) then
                return true
            end
        end

        -- Divine Shield
        if isChecked("Divine Shield") and cast.able.divineShield() and not UnitDebuffID("player", 25771) then
            if (php <= getOptionValue("Divine Shield") --health check
                    or UnitDebuffID("player", 272571)) --choking water in siege
                    or UnitDebuffID("player", 255421) --Devour
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
            elseif buff.blessingOfSacrifice.exists("player") and php <= 80 then
                if cast.divineProtection() then
                    return true
                end
            end
        end

        --shroudOfResolve / cloak
        if br.player.equiped.shroudOfResolve and canUseItem(br.player.items.shroudOfResolve) then
            if getValue("Use Cloak") == 1 and debuff.graspingTendrils.exists("player")
                    or getValue("Use Cloak") == 2 and getDebuffStacks("player", 315161) >= getOptionValue("Eye Of Corruption Stacks - Cloak")
                    or getValue("Use Cloak") == 3 and debuff.grandDelusions.exists("player") then
                if br.player.use.shroudOfResolve() then
                    return
                end
            end
        end


        -- Blessing of Freedom
        if isChecked("Blessing of Freedom") and cast.able.blessingOfFreedom() and isMoving("player")
                and (hasNoControl(spell.blessingOfFreedom)
                or isChecked("Use Blessing of Freedom for Snare") and debuff.graspingTendrils.exists("player")
                or debuff.vileCorruption.exists("player")) then
            if cast.blessingOfFreedom("player") then
                return true
            end
        end


    end
end -- End Action List - Defensive


actionList.Interrupt = function()

    if isChecked("Hammer of Justice") and cast.able.hammerOfJustice() then
        for i = 1, #br.friend do
            if UnitIsCharmed(br.friend[i].unit) and getDebuffRemain(br.friend[i].unit, 272407) == 0 and br.friend[i].distance <= 10 then
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
            local distance = getDistance(thisUnit)
            if (HOJ_unitList[GetObjectID(thisUnit)] ~= nil or HOJ_list[select(9, UnitCastingInfo(thisUnit))] ~= nil or HOJ_list[select(7, GetSpellInfo(UnitChannelInfo(thisUnit)))] ~= nil) and getBuffRemain(thisUnit, 226510) == 0 and distance <= 10 then
                if cast.hammerOfJustice(thisUnit) then
                    return true
                end
            end
        end
    end

    if useInterrupts() and (cast.able.blindingLight() or cast.able.hammerOfJustice()) and (isChecked("Hammer of Justice") or isChecked("Blinding Light")) then
        for i = 1, #enemies.yards10 do
            local thisUnit = enemies.yards10[i]
            local distance = getDistance(thisUnit)
            if canInterrupt(thisUnit, 99) and distance <= 10 and not isBoss(thisUnit) and StunsBlackList[GetObjectID(thisUnit)] == nil and UnitCastingInfo(thisUnit) ~= GetSpellInfo(257899) and UnitCastingInfo(thisUnit) ~= GetSpellInfo(258150) and UnitCastingInfo(thisUnit) ~= GetSpellInfo(252923) then
                -- Blinding Light
                if isChecked("Blinding Light") then
                    if cast.blindingLight() then
                        return true
                    end
                end
                -- Hammer of Justice
                if isChecked("Hammer of Justice") and cast.able.hammerOfJustice()
                        and getBuffRemain(thisUnit, 226510) == 0 -- never stun in Sanguine
                        and not isExplosive(thisUnit)
                        and (thisUnit == 130488 and isChecked("ML - Stun jockeys") or thisUnit ~= 130488)
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
            if canInterrupt(thisUnit, 99) and getCastTimeRemain(thisUnit) > getCastTime(spell.repentance) and StunsBlackList[GetObjectID(thisUnit)] == nil and not isBoss(thisUnit) and UnitCastingInfo(thisUnit) ~= GetSpellInfo(257899) and UnitCastingInfo(thisUnit) ~= GetSpellInfo(258150) and UnitCastingInfo(thisUnit) ~= GetSpellInfo(252923) and UnitCreatureType(thisUnit) == CC_CreatureTypeList[i] then
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
            auto_pot = getOptionValue("Pots - 1 target (Boss)")
        elseif #enemies.yards8 >= 2 and #enemies.yards8 <= 3 then
            auto_pot = getOptionValue("Pots - 2-3 targets")
        elseif #enemies.yards8 >= 4 then
            auto_pot = getOptionValue("Pots - 4+ target")
        end

        if auto_pot ~= 1 and (buff.avengingWrath.remain() > 12 or buff.avengingCrusader.remain() > 12) then

            if auto_pot == 2 and canUseItem(163222) then
                useItem(163222)
            elseif auto_pot == 3 and canUseItem(152559) then
                useItem(152559)
            elseif auto_pot == 4 and canUseItem(109218) then
                useItem(109218)
            elseif auto_pot == 5 and canUseItem(142117) then
                useItem(142117)
            elseif auto_pot == 6 and #enemies.yards8 > 3 and canUseItem(168529) then
                useItem(168529)
            elseif auto_pot == 7 and canUseItem(168506) then
                useItem(168506)
            elseif auto_pot == 8 and canUseItem(168498) then
                useItem(168498)
            elseif auto_pot == 9 and canUseItem(169299) then
                useItem(169299)
            end
        end
    end  -- end pots

    if isChecked("Bursting") and inInstance and #tanks > 0 then
        Burststack = getDebuffStacks(tanks[1].unit, 240443)
    end
    --burst check
    if Burststack >= getOptionValue("Burst Essence/items") then
        burst = true
    end
    -- Mana Potion
    if isChecked("Mana Potion") and br.player.power.mana.percent() <= getValue("Mana Potion") then
        if hasItem(152495) and canUseItem(152495) then
            useItem(152495)
        end
        if hasItem(127835) and canUseItem(127835) then
            useItem(127835)
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
    if isChecked("Arcane Torrent Mana") and inCombat and race == "BloodElf" and cast.able.racial() and br.player.power.mana.percent() < getOptionValue("Arcane Torrent Mana") then
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


    --Concentrated Flame
    -- Concentrated Flame Heal
    if essence.concentratedFlame.active and getSpellCD(295373) <= gcd then
        if isChecked("ConcentratedFlame - Heal") and lowest.hp <= getValue("ConcentratedFlame - Heal") and getLineOfSight(lowest.unit) and getDistance(lowest.unit) <= 40 then
            if cast.concentratedFlame(lowest.unit) then
                return true
            end
        end
        if isChecked("ConcentratedFlame - DPS") and getTTD(units.dyn30) > 5 and not debuff.concentratedFlame.exists(units.dyn30) and not cast.last.concentratedFlame() then
            if cast.concentratedFlame(units.dyn30) then
                return true
            end
        end
    end
    --lucid dreams
    if isChecked("Memory of Lucid Dreams") and getSpellCD(298357) <= gcd and getMana("player") <= getValue("Memory of Lucid Dreams") then
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

    --BoP and BoF   blessing of freedom blessing of protection
    pre_BoF_list = {
        [264560] = { targeted = true } --"choking-brine"
    }

    if cast.able.blessingOfProtection() or cast.able.blessingOfFreedom() then
        for i = 1, #br.friend do
            if isChecked("Blessing of Freedom") and cast.able.blessingOfFreedom() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    local _, _, _, _, endCast, _, _, _, spellcastID = UnitCastingInfo(thisUnit)
                    spellTarget = select(3, UnitCastID(thisUnit))
                end
                if spellTarget ~= nil and endCast and pre_BoF_list[spellcastID] and ((endCast / 1000) - GetTime()) < 1 then
                    if cast.blessingOfFreedom(spellTarget) then
                        return true
                    end
                end
                if (isChecked("Freehold - Blackout Barrel") and getDebuffRemain(br.friend[i].unit, 258875) ~= 0) -- barrel in FH
                        or getDebuffRemain(br.friend[i].unit, 258058) ~= 0 -- squuuuuze in TD
                        or getDebuffRemain(br.friend[i].unit, 257478) ~= 0 --crippling-bite in FH
                        or getDebuffRemain(br.friend[i].unit, 274383) ~= 0 -- rat-traps in FH
                        or getDebuffRemain(br.friend[i].unit, 257747) ~= 0 -- earth-shaker in FH
                        or getDebuffRemain(br.friend[i].unit, 268050) ~= 0 -- anchor-of-binding in Shrine
                        or getDebuffRemain(br.friend[i].unit, 267899) ~= 0 -- hindering-cleave in Shrine
                        or getDebuffRemain(br.friend[i].unit, 267899) ~= 0 -- hindering-cleave in Shrine
                then
                    if cast.blessingOfFreedom(br.friend[i].unit) then
                        return true
                    end
                end
            end
            if isChecked("Blessing of Protection") and cast.able.blessingOfProtection() then
                if (br.friend[i].hp <= getValue("Blessing of Protection")
                        or getDebuffRemain(br.friend[i].unit, 260741) ~= 0 --Jagged Nettles
                        or (getDebuffRemain(br.friend[i].unit, 255421) ~= 0 and (br.friend[i].unit ~= "player" or cd.divineProtection.remain() > 0)) -- Devour
                        or (isChecked("Tol Dagor - Deadeye") and getDebuffRemain(br.friend[i].unit, 256038) ~= 0 and br.friend[i].unit ~= "player"))
                        or (isChecked("Freehold - Blackout Barrel") and getDebuffRemain(br.friend[i].unit, 258875) ~= 0)
                        or (isChecked("KR - Severing axe") and getDebuffRemain(br.friend[i].unit, 266231) ~= 0)
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
    end

    -- Lay on Hands        --LoH / LayonHands
    if isChecked("Lay on Hands") and cast.able.layOnHands(br.friend[1].unit) and not debuff.forbearance.exists(br.friend[1].unit) and UnitInRange(br.friend[1].unit) then
        if lowest.hp <= getValue("Lay on Hands") then
            if cast.layOnHands(lowest.unit) then
                return true
            end
        end
    end

    -- Blessing of Sacrifice


    if isChecked("Blessing of Sacrifice") and cast.able.blessingOfSacrifice() and inCombat then
        if getOptionValue("BoS Target") == 2 then
            -- tank only
            for i = 1, #tanks do
                if tanks[i].hp <= getValue("Blessing of Sacrifice") then
                    if cast.blessingOfSacrifice(tanks[i].unit) then
                        return true
                    end
                end
            end
        elseif getOptionValue("BoS Target") == 1 then
            -- "all"
            for i = 1, #br.friend do
                if br.friend[i].hp <= getValue("Blessing of Sacrifice") and not GetUnitIsUnit(br.friend[i].unit, "player") then
                    if cast.blessingOfSacrifice(br.friend[i].unit) then
                        return true
                    end
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
                    local loc
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
        elseif getOptionValue("Trinket 1 Mode") == 4 and inCombat then
            if canUseItem(13) then
                useItem(13)
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
                    local loc
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
            if canUseItem(14) and ttd(units.dyn40) > 5 then
                UseItemByName(select(1, GetInventoryItemID("player", 14)), units.dyn40)
                return true
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

    -- Unstable Temporal Time Shifter
    if isChecked("Eng Brez") and canUseItem(158379) and not moving and inCombat and lowest.hp > getValue("Critical HP") then
        if getOptionValue("Eng Brez") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") then
            UseItemByName(158379, "target")
        end
        if getOptionValue("Eng Brez") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover", "player") then
            UseItemByName(158379, "mouseover")
        end
        if getOptionValue("Eng Brez") == 3 then
            for i = 1, #br.friend do
                if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") then
                    UseItemByName(158379, br.friend[i].unit)
                end
            end
        end
    end


end -- End Action List - Cooldowns

actionList.bossfight = function()
end

actionList.heal = function()
    -- heal()

    --  Print("lowest:" .. UnitName(lowest.unit) .. " at: " .. round(getHP(lowest.unit), 2))

    --checking for HE
    if br.data.settings[br.selectedSpec][br.selectedProfile]["HE ActiveCheck"] == false and br.timer:useTimer("Error delay", 3.5) then
        Print("HEAL ENGINE IS NOT ON - HEAL ENGINE NEED TO BE ON - YOU SHOULD TURN THE HEAL ENGINE ON.")
        return
    end
    -- tanks = getTanksTable()
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
        if php <= getValue("Critical HP") then
            healTarget = "player"
            healReason = "CRIT"
        end
    end
    if healTarget == "none" then
        if lowest.hp <= getValue("Critical HP") and getLineOfSight(lowest.unit, "player") and UnitInRange(lowest.unit) then
            healTarget = lowest.unit
            healReason = "CRIT"
        end
    end

    if healTarget == "none" then
        -- Junkyard
        if inInstance and inCombat and select(8, GetInstanceInfo()) == 2097 then
            for i = 1, #br.friend do
                if getDebuffRemain(br.friend[i].unit, 302274) ~= 0 --Fulminating Zap
                        and br.friend[i].hp < 80 then
                    healTarget = br.friend[i].unit
                    healReason = "BOSS"
                end
            end
        end
        -- Waycrest Manor
        if inInstance and inCombat and select(8, GetInstanceInfo()) == 1862 then
            for i = 1, #br.friend do
                if getDebuffRemain(br.friend[i].unit, 260741) ~= 0 --Jagged Nettles
                        and br.friend[i].hp < 95 then
                    healTarget = br.friend[i].unit
                    healReason = "BOSS"
                end
            end
        end
        --Kings Rest
        if inInstance and inCombat and select(8, GetInstanceInfo()) == 1762 then
            for i = 1, #br.friend do
                if getDebuffRemain(br.friend[i].unit, 267626) ~= 0 -- Dessication
                        or getDebuffRemain(br.friend[i].unit, 267618) ~= 0 -- Drain Fluids
                        or getDebuffRemain(br.friend[i].unit, 266231) ~= 0 -- Severing axe from axe lady in council
                        or getDebuffRemain(br.friend[i].unit, 272388) ~= 0 -- shadow barrage
                        or getDebuffRemain(br.friend[i].unit, 265773) > 1 -- spit-gold
                        or (getDebuffRemain(br.friend[i].unit, 270487) ~= 0 and getDebuffStacks(br.friend[i].unit, 270487) > 1) -- severing-blade
                        and br.friend[i].hp < 95 then
                    healTarget = br.friend[i].unit
                    healReason = "BOSS"
                end
            end
        end
    end

    --Talent Crusaders Might   - should only be used to get full value out of holy shock proc .. hard coded to 1.5
    if cast.able.crusaderStrike() and talent.crusadersMight and cd.holyShock.remain() >= 1.5 and not cd.judgment.remain() == 0 and getFacing("player", units.dyn5) and #enemies.yards5 >= 1 then
        if cast.crusaderStrike(units.dyn5) then
            br.addonDebug("[FILL]CrusaderStrike on " .. UnitName(units.dyn5) .. " CD/HS: " .. round(cd.holyShock.remain(), 2))
            return true
        end
    end

    if healTarget == "none" then
        --Grievous Wounds
        if isChecked("Grievous Wounds") then
            for i = 1, #br.friend do
                if br.friend[i].hp < 100 and UnitInRange(br.friend[i].unit) or GetUnitIsUnit(br.friend[i].unit, "player") then
                    local CurrentBleedstack = getDebuffStacks(br.friend[i].unit, 240559)
                    if getDebuffStacks(br.friend[i].unit, 240559) >= getValue("Grievous Wounds") then
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
                if GetObjectID(GetObjectWithIndex(i)) == 133392 and getHP(GetObjectWithIndex(i)) < 100 and getBuffRemain(GetObjectWithIndex(i), 274148) == 0 then
                    healTarget = GetObjectWithIndex(i)
                    healReason = "BOSS"
                end
            end
        end
        if isChecked("Freehold - pig") and GetMinimapZoneText() == "Ring of Booty" then
            bossHelper()
        end
    end

    if cast.able.holyShock() then
        if healTarget == "none" and mode.glimmer == 3 and #tanks > 0 then
            for i = 1, #tanks do
                if not UnitBuffID(tanks[i].unit, 287280, "PLAYER") and not UnitBuffID(tanks[i].unit, 115191) and getLineOfSight(tanks[i].unit, "player") then
                    healTarget = tanks[i].unit
                    healReason = "GLIM"
                end
            end
        end
        if healTarget == "none" then
            if lowest.hp <= getValue("Holy Shock") and (getLineOfSight(lowest.unit, "player") and UnitInRange(lowest.unit) or lowest.unit == "player") then
                healTarget = lowest.unit
                healReason = "HEAL"
            end
        end
        if healTarget == "none" and not br.player.inCombat and isChecked("OOC Glimmer") then
            -- ooc blanketting
            for i = 1, #br.friend do
                if not buff.glimmerOfLight.exists(br.friend[i].unit, "exact") and (getLineOfSight(br.friend[i].unit, "player") and UnitInRange(br.friend[i].unit) or br.friend[i].unit == "player") then
                    healTarget = br.friend[i].unit
                    healReason = "GLIM"
                end
            end
        end
        if healTarget ~= "none" then
            healTargetHealth = round(getHP(healTarget), 1)
            if cast.holyShock(healTarget) then
                br.addonDebug("[" .. healReason .. "] Holyshock on: " .. UnitName(healTarget) .. "/" .. healTargetHealth)
                healTarget = "none"
                return true
            end
        end
    end -- end holy shock
    -- Light of Dawn
    if isChecked("Light of Dawn") and cast.able.lightOfDawn() then
        if EasyWoWToolbox == nil then
            if healConeAround(getValue("LoD Targets"), getValue("Light of Dawn"), 90, lightOfDawn_distance * lightOfDawn_distance_coff, 5 * lightOfDawn_distance_coff)
            then
                if cast.lightOfDawn() then
                    return true
                end
            end
        else
            if bestConeHeal(spell.lightOfDawn, getValue("LoD Targets"), getValue("Light of Dawn"), 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5) then
                healTarget = "none"
                return true
            end
        end
    end
    --hs, dawn, flash(infused), Lotm, flash xxxxxx
    --infused heals


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
                br.addonDebug("[" .. healReason .. "] Bestow Faith on: " .. UnitName(healTarget))
                healTarget = "none"
                return true
            end
        end
    end -- end Bestow Faith

    if cast.able.flashOfLight() and buff.infusionOfLight.exists() and not cast.last.flashOfLight() and not isMoving("player") then
        if healTarget == "none" then
            if lowest.hp <= getValue("Infused Flash of Light") and (getLineOfSight(lowest.unit, "player") and UnitInRange(lowest.unit) or lowest.unit == "player") then
                healTarget = lowest.unit
                healReason = "HEAL"
                --                Print("healtarget: " .. healTarget .. " health:" .. round(lowest.hp, 2) .. " //" .. tostring(lowest.hp < getValue("Infused Flash of Light")))
            end
        end
        if healTarget ~= "none" then
            healTargetHealth = round(getHP(healTarget), 1)
            --   if healTargetHealth < getValue("Infused Flash of Light") then
            if cast.flashOfLight(healTarget) then
                br.addonDebug("[" .. healReason .. "] (I)flashOfLight on: " .. UnitName(healTarget) .. "/" .. healTargetHealth .. "/" .. (getValue("Infused Flash of Light")))
                healTarget = "none"
                return true
                --      end
            end
        end
    end

    --hs, dawn, flash(infused), Lotm, flash xxxxxx
    -- Light of Martyr
    if healTarget == "none" then
        if isChecked("Light of the Martyr") and (php >= getOptionValue("LotM player HP limit") or buff.divineShield.exists("player")) and cast.able.lightOfTheMartyr()
                and getDebuffStacks("player", 267034) < 2 -- not if we got stacks on last boss of shrine
                and getDebuffStacks("player", 265773) == 0 -- not if we got spit gold on us then  then
                and lowest.hp <= getValue("Light of the Martyr") and not GetUnitIsUnit(lowest.unit, "player")
                and getLineOfSight(lowest.unit, "player") and UnitInRange(lowest.unit) then
            healTarget = lowest.unit
            healReason = "HEAL"
        end
    end
    if healTarget ~= "none" and not GetUnitIsUnit(healTarget, "player") and getDebuffStacks("player", 267034) < 2 then
        healTargetHealth = round(getHP(healTarget), 1)
        if cast.lightOfTheMartyr(healTarget) then
            br.addonDebug("[" .. healReason .. "] lightOfTheMartyr on: " .. UnitName(healTarget) .. "/" .. healTargetHealth)
            healTarget = "none"
            return true
        end
    end

    if cast.able.flashOfLight() and not isMoving("player") then
        if healTarget == "none" then
            if lowest.hp <= getValue("Flash of Light") and (getLineOfSight(lowest.unit, "player") and UnitInRange(lowest.unit) or lowest.unit == "player") then
                healTarget = lowest.unit
                healReason = "HEAL"
            end
        end
        if healTarget ~= "none" then
            healTargetHealth = round(getHP(healTarget), 1)
            if cast.flashOfLight(healTarget) then
                br.addonDebug("[" .. healReason .. "] flashOfLight on: " .. UnitName(healTarget) .. "/" .. healTargetHealth)
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
    lowest = br.friend[1]
    use = br.player.use
    tanks = getTanksTable()
    healTarget = "none"
    healReason = "none"
    healTargetHealth = 100
    inInstance = br.player.instance == "party"
    inRaid = br.player.instance == "raid"
    solo = br.friends == 1

    -- General Locals
    hastar = GetObjectExists("target")
    healPot = getHealthPot()
    profileStop = profileStop or false
    ttd = getTTD
    haltProfile = (inCombat and profileStop) or (IsMounted() or IsFlying()) or pause() or mode.rotation == 4
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

    if mode.glimmer == 1 then
        for i = 1, #br.friend do
            if buff.glimmerOfLight.remain(br.friend[i].unit, "exact") > gcd then
                glimmerCount = glimmerCount + 1
            end
        end
        if isChecked("Aggressive Glimmer") and debuff.glimmerOfLight.remain("target", "exact") > gcd then
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
        if pause() or drinking or hasBuff(250873) or hasBuff(115834) or hasBuff(58984) or hasBuff(185710) or isCastingSpell(212056) then
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
                if not SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus() or lowest.hp <= getOptionValue("Critical HP") then
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
                    if (mode.glimmer == 1 or mode.glimmer == 3) and cast.able.holyShock() or cast.able.lightOfDawn() then
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
        end -- end pause
        return true
    end
end

-- End runRotation
local id = 0
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})