local rotationName = "AssaS0ul - 9.0.5"
local garrotePrioList = "157475"
local dotBlacklist = "168962|175992|171557|175992|167999"
local stunSpellList = "332329|332671|326450|328177|336451|331718|331743|334708|333145|326450|332671|321807|334748|327130|327240|330532|328475|330423|328177|336451|294171|330586|328429"
local StunsBlackList = "167876|169861|168318|165824|165919|171799|168942|167612|169893|167536"
local bossPool = false

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    local CreateButton = br["CreateButton"]
    br.RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of enemies in range.", highlight = 1, icon = br.player.spell.garrote },
        [2] = { mode = "Sing", value = 2 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mutilate }
    };
    CreateButton("Rotation",1,0)
    br.FocusModes = {
        [1] = { mode = "Norm", value = 1 , overlay = "Normal", tip = "Will use normal aoe rotation", highlight = 1, icon = br.player.spell.rupture },
        [2] = { mode = "Prio", value = 2 , overlay = "Prio", tip = "Priority Target AoE Rotation.", highlight = 1, icon = br.player.spell.envenom }
    };
    CreateButton("Focus",1,-1)
    br.CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.vendetta },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.vendetta },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.vendetta },
        [4] = { mode = "Lust", value = 4 , overlay = "Cooldowns With Bloodlust", tip = "Cooldowns will be used with bloodlust or simlar effects.", highlight = 1, icon = br.player.spell.vendetta }
    };
    CreateButton("Cooldown",2,0)
    br.DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.evasion },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.evasion }
    };
    CreateButton("Defensive",2,-1)
    br.InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.kick },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick }
    };
    CreateButton("Interrupt",3,0)
    br.VanishModes = {
        [1] = { mode = "On", value = 1 , overlay = "Vanish Enabled", tip = "Will use Vanish.", highlight = 1, icon = br.player.spell.vanish },
        [2] = { mode = "Off", value = 2 , overlay = "Vanish Disabled", tip = "Won't use Vanish.", highlight = 0, icon = br.player.spell.vanish }
    };
    CreateButton("Vanish",3,-1)
    br.GarroteModes = {
        [1] = { mode = "On", value = 1 , overlay = "Garrote On", tip = "Will use Garrote outside stealth.", highlight = 1, icon = br.player.spell.garrote },
        [2] = { mode = "Off", value = 2 , overlay = "Garrote Off", tip = "Will not use Garrote outside stealth.", highlight = 0, icon = br.player.spell.garrote }
    };
    CreateButton("Garrote",4,0)
    br.ExsangModes = {
        [1] = { mode = "On", value = 1 , overlay = "Exsanguinate On", tip = "Will use Exsanguinate.", highlight = 1, icon = br.player.spell.exsanguinate },
        [2] = { mode = "Off", value = 2 , overlay = "Exsanguinate Off", tip = "Will not use Exsanguinate.", highlight = 0, icon = br.player.spell.exsanguinate }
    };
    CreateButton("Exsang",4,-1)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
        br.ui:createDropdown(section, "Non-Lethal Poison", {"Crippling","Numbing",}, 2, "Non-Lethal Poison to apply")
            br.ui:createDropdown(section, "Lethal Poison", {"Deadly","Wound",}, 1, "Lethal Poison to apply")
            br.ui:createDropdown(section, "Auto Stealth", {"Always", "25 Yards"},  1, "Auto stealth mode")
            br.ui:createDropdown(section, "Auto Tricks", {"Focus", "Tank"},  1, "Tricks of the Trade target" )
            br.ui:createCheckbox(section, "Auto Target", "Will auto change to a new target, if current target is dead")
            br.ui:createSpinner(section, "Auto Soothe", 1, 0, 100, 5, "TTD for soothing")
            br.ui:createCheckbox(section, "Disable Auto Combat", "Will not auto attack out of stealth, don't use with vanish CD enabled, will pause rotation after vanish")
            br.ui:createCheckbox(section, "Dot Blacklist", "Check to ignore certain units when multidotting")
            br.ui:createSpinnerWithout(section,  "Multidot Limit",  5,  0,  8,  1,  "Max units to dot with garrote")
            br.ui:createSpinner(section, "Poisoned Knife out of range", 120,  1,  170,  5,  "Use Poisoned Knife out of range")
            br.ui:createDropdown(section, "Ignore Blacklist for FoK/CT", {"Both","FoK","CT",}, 1, "Ignore blacklist for Fan of Knives and/or Crimson Tempest usage")
            br.ui:createSpinner(section,  "Disable Garrote on # Units",  5,  1,  20,  1,  "Max units within 10 yards for garrote usage outside stealth (FoK spam)")
            br.ui:createCheckbox(section, "Dot Players", "Check to dot player targets (MC ect.)")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            br.ui:createCheckbox(section, "Racial", "Will use Racial")
            br.ui:createCheckbox(section, "Trinkets", "Will use Trinkets")
            br.ui:createCheckbox(section, "Precombat", "Will use items/pots on pulltimer")
            br.ui:createDropdown(section, "Potion", {"Phantom Fire", "Empowered Exorcism", "Spectral Agi"}, 3, "Potion with CDs")
            br.ui:createCheckbox(section, "Vendetta", "Will use Vendetta")
            br.ui:createSpinnerWithout(section,  "CDs TTD Limit",  5,  0,  20,  1,  "Time to die limit for using cooldowns.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            br.player.module.BasicHealing(section)
            br.ui:createCheckbox(section, "Cloak of Shadows")
            br.ui:createSpinner(section, "Crimson Vial",  40,  0,  100,  5,  "Health Percentage to use at.")
            br.ui:createSpinner(section, "Evasion",  30,  0,  100,  5,  "Health Percentage to use at.")
            br.ui:createSpinner(section, "Feint", 50, 0, 100, 5, "Health Percentage to use at.")
            br.ui:createCheckbox(section, "Auto Defensive Unavoidables", "Will use feint/evasion on certain unavoidable boss abilities")
            br.ui:createSpinnerWithout(section,  "Evasion Unavoidables HP Limit",  85,  0,  100,  5,  "Player HP to use evasion on unavoidables.")
            br.ui:createCheckbox(section, "Cloak Unavoidables", "Will cloak on unavoidables")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
            section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            br.ui:createCheckbox(section, "Kick")
            br.ui:createCheckbox(section, "Kidney Shot")
            br.ui:createCheckbox(section, "Blind")
            br.ui:createSpinnerWithout(section, "Interrupt %",  0,  0,  95,  5,  "Remaining Cast Percentage to interrupt at.")
            br.ui:createCheckbox(section, "Stuns", "Auto stun mobs from whitelist")
            br.ui:createSpinnerWithout(section, "Max CP For Stun",  3,  1,  6,  1,  " Maximum number of combo points to stun")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            br.ui:createDropdownWithout(section, "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
        ----------------------
        -------- LISTS -------
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Lists")
            br.ui:createScrollingEditBoxWithout(section,"Dot Blacklist Units", dotBlacklist, "List of units to blacklist when multidotting", 240, 40)
            br.ui:createScrollingEditBoxWithout(section,"Stun Spells", stunSpellList, "List of spells to stun with auto stun function", 240, 50)
            br.ui:createScrollingEditBoxWithout(section,"Stun Blacklist", StunsBlackList, "List of enemies we can't stun", 240, 50)
            br.ui:createScrollingEditBoxWithout(section,"Garrote Prio Units", garrotePrioList, "List of units to prioritize for garrote", 240, 50)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------
    --- Toggles --- -- List toggles here in order to update when pressed
    ---------------
    br.UpdateToggle("Rotation",0.25)
    br.UpdateToggle("Cooldown",0.25)
    br.UpdateToggle("Defensive",0.25)
    br.UpdateToggle("Interrupt",0.25)
    br.UpdateToggle("Exsang",0.25)
    br.UpdateToggle("Garrote",0.25)
    br.UpdateToggle("Focus",0.25)
    br.UpdateToggle("Vanish",0.25)
    br.player.ui.mode.open = br.data.settings[br.selectedSpec].toggles["Open"]
    br.player.ui.mode.exsang = br.data.settings[br.selectedSpec].toggles["Exsang"]
    br.player.ui.mode.tb = br.data.settings[br.selectedSpec].toggles["TB"]
    br.player.ui.mode.garrote = br.data.settings[br.selectedSpec].toggles["Garrote"]
    br.player.ui.mode.focus = br.data.settings[br.selectedSpec].toggles["Focus"]
    br.player.ui.mode.vanish = br.data.settings[br.selectedSpec].toggles["Vanish"]
    if not br.isInCombat("player") then
        if not br.player.talent.exsanguinate then
            br.buttonExsang:Hide()
        else
            br.buttonExsang:Show()
        end
    end

    --------------
    --- Locals ---
    --------------
    local module                              = br.player.module
    local runeforge                           = br.player.runeforge
    local buff                                = br.player.buff
    local talent                              = br.player.talent
    local cast                                = br.player.cast
    local php                                 = br.player.health
    local power, powmax, powgen               = br.player.power, br.player.powerMax, br.player.powerRegen
    local combo, comboDeficit, comboMax       = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
    local energy, energyDeficit, energyRegen  = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
    local cd                                  = br.player.cd
    local charges                             = br.player.charges
    local debuff                              = br.player.debuff
    local equiped                             = br.player.equiped
    local enemies                             = br.player.enemies
    local gcd                                 = br.player.gcd
    local gcdMax                              = br.player.gcdMax
    local has                                 = br.player.has
    local inCombat                            = br.player.inCombat
    local level                               = br.player.level
    local ui                                  = br.player.ui
    local mode                                = br.player.ui.mode
    local race                                = br.player.race
    local racial                              = br.player.getRacial()
    local spell                               = br.player.spell
    local units                               = br.player.units
    local unit                                = br.player.unit
    local use                                 = br.player.use
    local covenant                            = br.player.covenant
    local conduit                             = br.player.conduit
    local stealth                             = br.player.buff.stealth.exists()
    local stealthedRogue                      = stealth or br.player.buff.vanish.exists() or br.player.buff.subterfuge.remain() > 0.4 or br.player.cast.last.vanish(1)
    local stealthedAll                        = stealthedRogue or br.player.buff.shadowmeld.exists()
    local combatTime                          = br.getCombatTime()
    local cdUsage                             = br.useCDs()
    local falling, swimming, flying           = br.getFallTime(), br._G.IsSwimming(), br._G.IsFlying()
    local moving                              = unit.moving("player")
    local pullTimer                           = br.DBM:getPulltimer()
    local thp                                 = unit.hp("target")
    local tickTime                            = 2 / (1 + (br._G.GetHaste()/100))
    local validTarget                         = unit.valid("target")
    local targetDistance                      = unit.distance("target")
    local inInstance                          = br.player.instance == "party" or br.player.instance == "scenario" or br.player.instance == "pvp" or br.player.instance == "arena" or br.player.instance == "none"
    local inRaid                              = br.player.instance == "raid" or br.player.instance == "pvp" or br.player.instance == "arena" or br.player.instance == "none"

    enemies.get(5)
    enemies.get(20)
    enemies.get(20,"player",true)
    enemies.get(25,"player", true) -- makes enemies.yards25nc
    enemies.get(30)

    if br.timersTable then
        br._G.wipe(br.timersTable)
    end

    local tricksUnit
    if ui.checked("Auto Tricks") and br._G.GetSpellCooldown(spell.tricksOfTheTrade) == 0 and inCombat then
        if ui.value("Auto Tricks") == 1 and br.GetUnitIsFriend("player", "focus") and br.getLineOfSight("player", "focus") then
            tricksUnit = "focus"
        elseif ui.value("Auto Tricks") == 2 then
            for i = 1, #br.friend do
                local thisUnit = br.friend[i].unit
                if unit.role(thisUnit) == "TANK" and not br.GetUnitIsDeadOrGhost(thisUnit) and br.getLineOfSight("player", thisUnit) then
                    tricksUnit = thisUnit
                    break
                end
            end
        end
    end

    -----------------
    --- Functions ---
    -----------------

    local function int (b)
        return b and 1 or 0
    end

    local function ttd(unit)
        if br._G.UnitIsPlayer(unit) then return 999 end
        local ttdSec = br.getTTD(unit)
        if br.getOptionCheck("Enhanced Time to Die") then return ttdSec end
        if ttdSec == -1 then return 999 end
        return ttdSec
    end

    local function shallWeDot(unit)
        if ui.checked("Auto Rupture HP Limit") and ttd(unit) == 999 and not br._G.UnitIsPlayer(unit) and not br.isDummy(unit) then
            local hpLimit = 0
            if #br.friend == 1 then
                if br._G.UnitHealth(unit) > br._G.UnitHealthMax("player") * 0.40 then
                    return true
                end
                return false
            end
            for i = 1, #br.friend do
                local thisUnit = br.friend[i].unit
                local thisHP = br._G.UnitHealthMax(thisUnit)
                local thisRole = unit.role(thisUnit)
                if not br.GetUnitIsDeadOrGhost(thisUnit) and unit.distance(unit, thisUnit) < 40 then
                    if thisRole == "TANK" then hpLimit = hpLimit + (thisHP * 0.15) end
                    if (thisRole == "DAMAGER" or thisRole == "NONE") then hpLimit = hpLimit + (thisHP * 0.3) end
                end
            end
            if br._G.UnitHealth(unit) > hpLimit then return true end
            return false
        end
        return true
    end

    local function isTotem(unit)
        local eliteTotems = { -- totems we can dot
            [125977] = "Reanimate Totem",
            [127315] = "Reanimate Totem",
            [146731] = "Zombie Dust Totem"
        }
        local creatureType = br._G.UnitCreatureType(unit)
        local objectID = br.GetObjectID(unit)
        if creatureType ~= nil and eliteTotems[objectID] == nil then
            if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then return true end
        end
        return false
    end

    local noDotUnits = {}
    for i in string.gmatch(br.getOptionValue("Dot Blacklist Units"), "%d+") do
        noDotUnits[tonumber(i)] = true
    end

    local function noDotCheck(unit)
        if ui.checked("Dot Blacklist") and (noDotUnits[br.GetObjectID(unit)] or br._G.UnitIsCharmed(unit)) then return true end
        if isTotem(unit) then return true end
        local unitCreator = br._G.UnitCreator(unit)
        if unitCreator ~= nil and br._G.UnitIsPlayer(unitCreator) ~= nil and br._G.UnitIsPlayer(unitCreator) == true then return true end
        if br.GetObjectID(unit) == 137119 and br.getBuffRemain(unit, 271965) > 0 then return true end
        return false
    end

    local garroteList = {}
    for i in string.gmatch(br.getOptionValue("Garrote Prio Units"), "%d+") do
        garroteList[tonumber(i)] = true
    end

    local enemyTable30 = { }
    local enemyTable10 = { }
    local enemyTable5 = { }
    local deadlyPoison10 = true
    local fightRemain = 0
    local garroteCount = 0
    local ruptureCount = 0
    local serratedCount = 0
    if #enemies.yards30 > 0 then
        local highestHP
        local lowestHP
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if (not noDotCheck(thisUnit) or br.GetUnitIsUnit(thisUnit, "target"))
             and not br.GetUnitIsDeadOrGhost(thisUnit) and br.isSafeToAttack(thisUnit)
             and (mode.rotation ~= 2 or (mode.rotation == 2 and br.GetUnitIsUnit(thisUnit, "target"))) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                enemyUnit.distance = unit.distance(thisUnit)
                enemyUnit.hpabs = br._G.UnitHealth(thisUnit)
                enemyUnit.facing = unit.facing("player",thisUnit)
                br._G.tinsert(enemyTable30, enemyUnit)
                if highestHP == nil or highestHP < enemyUnit.hpabs then highestHP = enemyUnit.hpabs end
                if lowestHP == nil or lowestHP > enemyUnit.hpabs then lowestHP = enemyUnit.hpabs end
                if fightRemain == nil or fightRemain < enemyUnit.ttd then fightRemain = enemyUnit.ttd end
                if enemyTable30.lowestTTDUnit == nil or enemyTable30.lowestTTD > enemyUnit.ttd then
                    enemyTable30.lowestTTDUnit = enemyUnit.unit
                    enemyTable30.lowestTTD = enemyUnit.ttd
                end
                if enemyTable30.highestTTDUnit == nil or enemyTable30.highestTTD < enemyUnit.ttd then
                    enemyTable30.highestTTDUnit = enemyUnit.unit
                    enemyTable30.highestTTD = enemyUnit.ttd
                end
            end
        end
        if #enemyTable30 > 1 then
            for i = 1, #enemyTable30 do
                local thisUnit = enemyTable30[i]
                local hpNorm = (10-1)/(highestHP-lowestHP)*(thisUnit.hpabs-highestHP)+10 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0/0) then hpNorm = 0 end -- NaN check
                local enemyScore = hpNorm
                if thisUnit.ttd > 1.5 then enemyScore = enemyScore + 10 end
                if thisUnit.facing then enemyScore = enemyScore + 30 end
                if thisUnit.distance <= 5 then enemyScore = enemyScore + 30 end
                if garroteList[thisUnit.objectID] ~= nil then enemyScore = enemyScore + 50 end
                if br.GetUnitIsUnit(thisUnit.unit, "target") then enemyScore = enemyScore + 100 end
                if br.getUnitID(thisUnit) == 166969 then enemyScore = enemyScore + 500 end
                if br.getUnitID(thisUnit) == 166970 then enemyScore = enemyScore + 150 end
                if br.getUnitID(thisUnit) == 166971 then enemyScore = enemyScore + 50 end
                local raidTarget = br._G.GetRaidTargetIndex(thisUnit.unit)
                if raidTarget ~= nil then
                    enemyScore = enemyScore + raidTarget * 3
                    if raidTarget == 8 then enemyScore = enemyScore + 5 end
                end
                thisUnit.enemyScore = enemyScore
            end
            table.sort(enemyTable30, function(x,y)
                return x.enemyScore > y.enemyScore
            end)
        end
        for i = 1, #enemyTable30 do
            local thisUnit = enemyTable30[i]
            local fokIgnore  = {
                [120651]=true, -- Explosive
                [168962]=true, -- Sun King's Reborn Phoenix
                [166969]=true, -- Baroness Frieda
                [166971]=true, -- Castellan Niklaus
                [166970]=true, -- Lord Stavros
            }
            if debuff.serratedBoneSpike.exists(thisUnit.unit) then serratedCount = serratedCount + 1 end
            if thisUnit.distance <= 10 then
                if fokIgnore [thisUnit.objectID] == nil and not isTotem(thisUnit.unit) then
                    br._G.tinsert(enemyTable10, thisUnit)
                    if deadlyPoison10 and
                        (br.getOptionValue("Lethal Poison") == 1 and not debuff.instantPoison.exists(thisUnit.unit)) or
                        (br.getOptionValue("Lethal Poison") == 2 and not debuff.woundPoison.exists(thisUnit.unit))
                        then deadlyPoison10 = false
                    end
                end
                if thisUnit.distance <= 5 then
                    br._G.tinsert(enemyTable5, thisUnit)
                end
                if debuff.garrote.remain(thisUnit.unit) > 0.5 then garroteCount = garroteCount + 1 end
                if debuff.rupture.remain(thisUnit.unit) > 0.5 then ruptureCount = ruptureCount + 1 end
                if br.getUnitID(thisUnit) == 175992 and thisUnit.distance <= 5 then br._G.TargetUnit(thisUnit) end
            end
        end
        if ui.checked("Auto Target") and inCombat and #enemyTable30 > 0 and ((br.GetUnitExists("target") and br.GetUnitIsDeadOrGhost("target") and not br.GetUnitIsUnit(enemyTable30[1].unit, "target")) or not br.GetUnitExists("target")) then
            br._G.TargetUnit(enemyTable30[1].unit)
        end
    end

    local function trinket_Pop()
        if (debuff.vendetta.exists() or (br.isBoss() and fightRemain <= 20)) and targetDistance < 5 and ttd("target") > br.getOptionValue("CDs TTD Limit") then
            if br.canUseItem(13) and not br.hasEquiped(178715, 13) and not br.hasEquiped(184016, 13) and not br.hasEquiped(181333, 13) and not br.hasEquiped(179350, 13) then
                br.useItem(13)
            end
            if br.canUseItem(14) and not br.hasEquiped(178715, 14) and not br.hasEquiped(184016, 14) and not br.hasEquiped(181333, 14) and not br.hasEquiped(179350, 14) then
                br.useItem(14)
            end
        end
        -- Inscrutable Quantum Device
        if (debuff.vendetta.exists() or (br.isBoss() and fightRemain <= 20)) and targetDistance < 5 and ttd("target") > br.getOptionValue("CDs TTD Limit") and
         (br._G.GetInventoryItemID("player", 13) == 179350 or br._G.GetInventoryItemID("player", 14) == 179350) and br.canUseItem(179350) then
            br.useItem(179350)
        end
        -- Skuler's Wing
        if (br._G.GetInventoryItemID("player", 13) == 184016 or br._G.GetInventoryItemID("player", 14) == 184016) and br.canUseItem(184016) and #enemyTable10 > 0 then
            br.useItem(184016)
        end
        -- Dreadfire Vessel
        if (br._G.GetInventoryItemID("player", 13) == 184030 or br._G.GetInventoryItemID("player", 14) == 184030) and br.canUseItem(184030) and (#enemyTable10 > 1 or debuff.vendetta.exists("target")) then
            br.useItem(184030)
        end
    end

    -- nil fixes
    if enemyTable30.lowestTTD == nil then enemyTable30.lowestTTD = 999 end
    if enemyTable30.highestTTD == nil then enemyTable30.highestTTD = 999 end

    --Variables
    local enemies10 = #enemyTable10
    local fokenemies10 = #enemyTable10
    local ctenemies10 = #enemyTable10
    local dSEnabled, sRogue, priorityRotation, animachargedCP, DPEquipped, DSEquipped, DoomEquipped, critOnly
    if talent.deeperStratagem then dSEnabled = 1 else dSEnabled = 0 end
    if stealthedRogue == true then sRogue = 1 else sRogue = 0 end
    if runeforge.duskwalkersPatch.equiped then DPEquipped = 1 else DPEquipped = 0 end
    if runeforge.dashingScoundrel.equiped then DSEquipped = 1 else DSEquipped = 0 end
    if runeforge.doomblade.equiped then DoomEquipped = 1 else DoomEquipped = 0 end
    if buff.masterAssassin.exists() or buff.masterAssassinsMark.exists() then critOnly = 1 else critOnly = 0 end
    --actions+=/variable,name=energy_regen_combined,value=energy.regen+poisoned_bleeds*8%(2*spell_haste)
    local energyRegenCombined = energyRegen + ((garroteCount + ruptureCount) * 8 / (2 * (1 / (1 + (br._G.GetHaste()/100)))))
    local poisonedBleeds = garroteCount + ruptureCount
    --actions+=/variable,name=single_target,value=spell_targets.fan_of_knives<2
    local singleTarget = (enemies10 < 2) or false

    -- # Only change rotation if we have priority_rotation set and multiple targets up.
    -- actions+=/variable,name=use_priority_rotation,value=priority_rotation&spell_targets.shuriken_storm>=2
    if mode.focus == 2 and enemies10 >= 2 then priorityRotation = true else priorityRotation = false end
    if (br.hasBuff(323558) and combo == 2 or br.hasBuff(323559) and combo == 3 or br.hasBuff(323560) and combo == 4) then animachargedCP = true else animachargedCP = false end

    if br.isChecked("Ignore Blacklist for FoK/CT") and mode.rotation ~= 2 then
        if br.getOptionValue("Ignore Blacklist for FoK/CT") == 1 then --Both
            fokenemies10 = #enemies.get(10, nil, nil, nil)
            ctenemies10 = #enemies.get(10, nil, nil, nil)
        elseif br.getOptionValue("Ignore Blacklist for FoK/CT") == 2 then --Fan of Knifes
            fokenemies10 = #enemies.get(10, nil, nil, nil)
        elseif br.getOptionValue("Ignore Blacklist for FoK/CT") == 3 then --CT
            ctenemies10 = #enemies.get(10, nil, nil, nil)
        end
    end

    local garroteCheck = true
    if (br.isChecked("Disable Garrote on # Units") and enemies10 >= br.getOptionValue("Disable Garrote on # Units")) or mode.garrote == 2 then
        garroteCheck = false
    end

    --------------------
    --- Action Lists ---
    --------------------
    local function actionList_Extra()
        if not inCombat then
            -- actions.precombat+=/apply_poison
            if ui.checked("Lethal Poison") and not moving then
                if ui.value("Lethal Poison") == 1 and buff.deadlyPoison.remain() < 300 and not cast.last.deadlyPoison(1) then
                    if cast.deadlyPoison("player") then return true end
                elseif ui.value("Lethal Poison") == 2 and buff.woundPoison.remain() < 300 and not cast.last.woundPoison(1) then
                    if cast.woundPoison("player") then return true end
                end
            end
            if ui.checked("Non-Lethal Poison") and not moving then
                if ui.value("Non-Lethal Poison") == 1 and buff.cripplingPoison.remain() < 300 and not cast.last.cripplingPoison(1) then
                    if cast.cripplingPoison("player") then return true end
                elseif ui.value("Non-Lethal Poison") == 2 and buff.numbingPoison.remain() < 300 and not cast.last.numbingPoison(1) then
                    if cast.numbingPoison("player") then return true end
                end
            end
            -- actions.precombat+=/stealth
            if ui.checked("Auto Stealth") and br._G.IsUsableSpell(br._G.GetSpellInfo(spell.stealth)) and not cast.last.vanish() and not br._G.IsResting() and
            (br.botSpell ~= spell.stealth or (br.botSpellTime == nil or br._G.GetTime() - br.botSpellTime > 0.1)) then
                if ui.value("Auto Stealth") == 1 then
                    if cast.stealth("player") then return end
                end
                if #enemies.yards25nc > 0 and ui.value("Auto Stealth") == 2 then
                    if cast.stealth("player") then return end
                end
            end
        end
        --Burn Units
        local burnUnits = {
            [175992] = true, -- Dutiful Attendant
        }
        if br.GetObjectExists("target") and burnUnits[br.GetObjectID("target")] ~= nil then
            if combo >= 4 + dSEnabled then
                if cast.eviscerate("target") then return true end
            end
        end
        -- Soothe
        if ui.checked("Auto Soothe") and cast.able.shiv() then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if br.canDispel(thisUnit, spell.shiv) and ttd(thisUnit) > ui.value("Auto Soothe") then
                    if cast.shiv(thisUnit) then
                        return true
                    end
                end
            end
        end
    end

    local function actionList_Defensive()
        if br.useDefensive() then
            if ui.checked("Auto Defensive Unavoidables") then
                local bossID = br.GetObjectID("boss1")
                local boss2ID = br.GetObjectID("boss2")
                local boss3ID = br.GetObjectID("boss3")
                local boss = "boss1"
                if boss2ID == 126848 then
                    bossID = 126848
                    boss = "boss2"
                end
                --Frozen Binds (4th boss NW)
                if bossID == 162693 and br.isCastingSpell(320788, "boss1") and br.GetUnitIsUnit("player", br._G.UnitTarget("boss1")) and ui.checked("Cloak Unavoidables") then
                    if cd.cloakOfShadows.remain() > 2 then
                        if cast.vanish("player") then return true end
                    end
                    if cast.cloakOfShadows("player") then return true end
                end
                --Dark Exile (4th boss NW)
                if bossID == 162693 and br.isCastingSpell(321894, "boss1") and br.GetUnitIsUnit("player", br._G.UnitTarget("boss1")) then
                    if cast.vanish("player") then return true end
                end
                --Sire Shattering Pain
                if bossID == 167406 and br.isCastingSpell(332626, "boss1") then
                    if cast.feint() then return true end
                end
                --Azerite Powder Shot (1st boss freehold)
                if not bossPool and bossID == 126832 and br.DBM:getTimer(256106) <= 1 then -- pause 1 sec before cast for pooling
                    bossPool = true
                end
                if bossID == 126832 and br.isCastingSpell(256106, "boss1") then
                    bossPool = false
                    if br.GetUnitIsUnit("player", br._G.UnitTarget("boss1")) then
                        if cast.feint() then return true end
                    end
                end
                if bossPool then return true end
            end
            module.BasicHealing()
            if ui.checked("Cloak of Shadows") and br.canDispel("player",spell.cloakOfShadows) and inCombat then
                if cast.cloakOfShadows("player") then return true end
            end
            if ui.checked("Crimson Vial") and php < ui.value("Crimson Vial") then
                if cast.crimsonVial("player") then return true end
            end
            if ui.checked("Evasion") and php < ui.value("Evasion") and inCombat and not stealth then
                if cast.evasion("player") then return true end
            end
            if ui.checked("Feint") and php <= ui.value("Feint") and inCombat and not buff.feint.exists() then
                if cast.feint("player") then return true end
            end
        end
    end

    local function actionList_Interrupts()
        local stunList = {}
        local noStunList = {}
        local interrupt_target
        local priority_target
        local distance
        if ui.checked("Priority Mark") then
            for i = 1, #enemies.yards20 do
                if br._G.GetRaidTargetIndex(enemies.yards20[i]) == ui.value("Priority Mark") then
                    priority_target = enemies.yards20[i]
                    break
                end
            end
        end
        for i in string.gmatch(ui.value("Stun Spells"), "%d+") do
            stunList[tonumber(i)] = true
        end
        for i in string.gmatch(ui.value("Stun Blacklist"), "%d+") do
            noStunList[tonumber(i)] = true
        end
        if br.useInterrupts() and not stealthedRogue then
            for i=1, #enemies.yards20 do
                if priority_target ~= nil then
                    interrupt_target = priority_target
                else
                    interrupt_target = enemies.yards20[i]
                end
                distance = unit.distance(interrupt_target)
                if br.canInterrupt(interrupt_target,ui.value("Interrupt %")) and br.player.cast.timeRemain(interrupt_target) < br.getTTD(interrupt_target) then
                    if ui.checked("Kick") and distance < 5 and cast.able.kick() then
                        if cast.kick(interrupt_target) then end
                    end
                    if cd.kick.exists() and distance < 5 and ui.checked("Kidney Shot") and noStunList[br.GetObjectID(interrupt_target)] == nil and br.getBuffRemain(interrupt_target, 226510) == 0 then
                        if cast.kidneyShot(interrupt_target) then return true end
                    end
                    if ui.checked("Blind") and (cd.kick.exists() or distance >= 5) and noStunList[br.GetObjectID(interrupt_target)] == nil then
                        if cast.blind(interrupt_target) then return end
                    end
                end
                local interruptID, castStartTime
                if ui.checked("Stuns") and distance < 5 and br.player.cast.timeRemain(interrupt_target) < br.getTTD(interrupt_target)
                 and noStunList[br.GetObjectID(interrupt_target)] == nil and br.getBuffRemain(interrupt_target, 226510) == 0
                 and (not br.isBoss(interrupt_target) or stunList[interruptID] or br.isCrowdControlCandidates(interrupt_target)) then
                    if br._G.UnitCastingInfo(interrupt_target) then
                        castStartTime = select(4,br._G.UnitCastingInfo(interrupt_target))
                        interruptID = select(9,br._G.UnitCastingInfo(interrupt_target))
                    elseif br._G.UnitChannelInfo(interrupt_target) then
                        castStartTime = select(4,br._G.UnitChannelInfo(interrupt_target))
                        interruptID = select(7,br._G.GetSpellInfo(br._G.UnitChannelInfo(interrupt_target)))
                    end
                    if interruptID ~=nil and stunList[interruptID] and (br._G.GetTime()-(castStartTime/1000)) > 0.1 then
                        if combo > 0 and combo <= ui.value("Max CP For Stun") then
                            if cast.kidneyShot(interrupt_target) then return true end
                        end
                    end
                end
            end
        end
    end

    local function actionList_PreCombat()
        -- actions.precombat+=/potion
        if ui.checked("Precombat") and pullTimer <= 0.5 then
            if ui.value("Potion") == 1 and br.canUseItem(171349) then
                br.useItem(171349)
            elseif ui.value("Potion") == 2 and br.canUseItem(171352) then
                br.useItem(171352)
            elseif ui.value("Potion") == 3 and br.canUseItem(171270) then
                br.useItem(171270)
            end
        end
        -- actions.precombat+=/marked_for_death,precombat_seconds=15
        if ui.checked("Precombat") and validTarget and pullTimer < 15 and stealth and comboDeficit > 2 and talent.markedForDeath and targetDistance < 25 then
            if cast.markedForDeath("target") then return true end
        end
        -- actions.precombat+=/Slice and Dice, if=precombat_seconds=1
        -- if ui.checked("Precombat") and (pullTimer <= 1 or targetDistance < 10) and combo > 0 and buff.sliceAndDice.remain() < 6+(combo*3) then
        --     if cast.sliceAndDice("player") then return true end
        -- end
    end

    local function actionList_Cooldowns()
        -- flagellation for opener
        if covenant.venthyr.active and cast.able.flagellation() and buff.sliceAndDice.exists("player") and not debuff.flagellation.exists("target") then
            if cast.flagellation("target") then return true end
        end
        --actions.precombat+=/variable,name=vendetta_cdr,value=1-(runeforge.duskwalkers_patch*0.45)
        local vendettaCDR = 1-(DPEquipped*0.45)
        -- # If adds are up, snipe the one with lowest TTD. Use when dying faster than CP deficit or without any CP.
        -- actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit*1.5|combo_points.deficit>=cp_max_spend)
        if #enemyTable30 > 1 and (enemyTable30.lowestTTD < (comboDeficit * 1.5) or comboDeficit >= comboMax) then
            if cast.markedForDeath(enemyTable30.lowestTTDUnit) then return true end
        end
        -- # If no adds will die within the next 30s, use MfD on boss without any CP.
        -- actions.cds+=/marked_for_death,if=raid_event.adds.in>30-raid_event.adds.duration&combo_points.deficit>=cp_max_spend
        if #enemyTable30 == 1 and comboDeficit >= comboMax then
            if cast.markedForDeath("target") then return true end
        end
        --# Sync Flagellation with Vendetta as long as we won't lose a cast over the fight duration
        if covenant.venthyr.active and cast.able.flagellation() then
            --actions.cds+=/flagellation,if=!stealthed.rogue&(cooldown.vendetta.remains<3&effective_combo_points>=4&target.time_to_die>10|debuff.vendetta.up|fight_remains<24)
            if not stealthedAll and ((cd.vendetta.remain() < 3 and combo >= 4 and ttd("target") > 10) or debuff.vendetta.exists("target") or fightRemain < 24) then
                if cast.flagellation("target") then return true end
            end
            --actions.cds+=/flagellation,if=!stealthed.rogue&effective_combo_points>=4&(floor((fight_remains-24)%cooldown)>floor((fight_remains-24-cooldown.vendetta.remains*variable.vendetta_cdr)%cooldown))
            if not stealthedAll and combo >= 4 and (math.floor((fightRemain-24)%cd.flagellation.remain())>math.floor((fightRemain-24-cd.vendetta.remain()*vendettaCDR)%cd.flagellation.remain())) then
                if cast.flagellation("target") then return true end
            end
        end
        --# Sync Sepsis with Vendetta as long as we won't lose a cast over the fight duration, but prefer targets that will live at least 10s
        if covenant.nightFae.active and cast.able.sepsis() then
            --actions.cds+=/sepsis,if=!stealthed.rogue&(cooldown.vendetta.remains<1&target.time_to_die>10|debuff.vendetta.up|fight_remains<10)
            if not stealthedAll and ((cd.vendetta.remain() < 1 and ttd("target") > 10) or debuff.vendetta.exists("target") or fightRemain < 10) then
                if cast.sepsis("target") then return true end
            end
            --actions.cds+=/sepsis,if=!stealthed.rogue&(floor((fight_remains-10)%cooldown)>floor((fight_remains-10-cooldown.vendetta.remains*variable.vendetta_cdr)%cooldown))
            if not stealthedAll and (math.floor((fightRemain-10)%cd.sepsis.remain()) > math.floor((fightRemain-10-cd.vendetta.remain()*vendettaCDR)%cd.sepsis.remain())) then
                if cast.sepsis("target") then return true end
            end
        end
        --# Sync Vendetta window with Nightstalker+Exsanguinate if applicable
        -- actions.cds+=/variable,name=vendetta_nightstalker_condition,value=!talent.nightstalker.enabled|!talent.exsanguinate.enabled|cooldown.exsanguinate.remains<5-2*talent.deeper_stratagem.enabled
        local vendettaNightstalkerCondition = (not talent.nightstalker or not talent.exsanguinate or cd.exsanguinate.remain() < 5-2*dSEnabled) or false
        --# Sync Vendetta with Flagellation and Sepsis as long as we won't lose a cast over the fight duration
        --actions.cds+=/variable,name=vendetta_covenant_condition,if=covenant.kyrian|covenant.necrolord|covenant.none,value=1
        --actions.cds+=/variable,name=vendetta_covenant_condition,if=covenant.venthyr,value=floor((fight_remains-20)%(120*variable.vendetta_cdr))>floor((fight_remains-20-cooldown.flagellation.remains)%(120*variable.vendetta_cdr))|buff.flagellation_buff.up|debuff.flagellation.up|fight_remains<20
        --actions.cds+=/variable,name=vendetta_covenant_condition,if=covenant.night_fae,value=floor((fight_remains-20)%(120*variable.vendetta_cdr))>floor((fight_remains-20-cooldown.sepsis.remains)%(120*variable.vendetta_cdr))|dot.sepsis.ticking|fight_remains<20
        local vendettaCovenantCondition = 0
        if covenant.kyrian.active or covenant.necrolord.active then vendettaCovenantCondition = 1 end
        if (covenant.venthyr.active and (math.floor((fightRemain-20)%(120*vendettaCDR)) > math.floor((fightRemain-20-cd.flagellation.remain())%(120*vendettaCDR)) or buff.flagellation.exists() or debuff.flagellation.exists("target") or fightRemain < 20)) then vendettaCovenantCondition = 1 end
        if (covenant.nightFae.active and (math.floor((fightRemain-20)%(120*vendettaCDR)) > math.floor((fightRemain-20-cd.sepsis.remain())%(120*vendettaCDR)) or debuff.sepsis.exists("target") or fightRemain < 20)) then vendettaCovenantCondition = 1 end
        --actions.cds+=/vendetta,if=!stealthed.rogue&dot.rupture.ticking&!debuff.vendetta.up&variable.vendetta_nightstalker_condition&variable.vendetta_covenant_condition
        if cdUsage and ttd("target") > br.getOptionValue("CDs TTD Limit") and targetDistance < 5 and not stealthedAll
         and debuff.rupture.exists("target") and not debuff.vendetta.exists("target") and vendettaNightstalkerCondition and vendettaCovenantCondition then
            vendettaCovenantCondition = 0
            if cast.vendetta("target") then return true end
        end
        --# Exsanguinate when not stealthed and both Rupture and Garrote are up for long enough.
        --actions.cds+=/exsanguinate,if=!stealthed.rogue&(!dot.garrote.refreshable&dot.rupture.remains>4+4*cp_max_spend|dot.rupture.remains*0.5>target.time_to_die)&target.time_to_die>4
        if not stealthedAll and mode.exsang == 1 and talent.exsanguinate and br.getSpellCD(spell.exsanguinate) == 0 and debuff.rupture.remain("target") > 25 and ttd("target") > 4 and
         (debuff.garrote.remain("target") > 15 or garroteCheck == false or debuff.garrote.applied("target") > 1) and (not cast.last.vanish(1) and not cast.last.vanish(2)) then
            if cast.exsanguinate("target") then return true end
        end
        -- # Shiv if we are about to Envenom, and attempt to sync with Sepsis final hit if we won't waste more than half the cooldown.
        -- actions.cds+=/shiv,if=dot.rupture.ticking&(!cooldown.sepsis.ready|cooldown.vendetta.remains>12)|dot.sepsis.ticking
        if debuff.rupture.exists("target") and (cd.sepsis.exists() or cd.vendetta.remain() > 12) or debuff.sepsis.exists("target") then
            if cast.shiv("target") then return true end
        end
        -- actions.cds=potion,if=buff.bloodlust.react|debuff.vendetta.up
        if cdUsage and ttd("target") > br.getOptionValue("CDs TTD Limit") and ui.checked("Potion") and (br.hasBloodLust() and cd.vendetta.remain() > 0 or debuff.vendetta.exists("target")) and targetDistance < 5 then
            if ui.value("Potion") == 1 and br.canUseItem(171349) then
                br.useItem(171349)
            elseif ui.value("Potion") == 2 and br.canUseItem(171352) then
                br.useItem(171352)
            elseif ui.value("Potion") == 3 and br.canUseItem(171270) then
                br.useItem(171270)
            end
        end
        --actions.cds+=/call_action_list,name=vanish,if=!stealthed.all&master_assassin_remains=0
        if mode.vanish == 1 and not stealthedAll and not buff.masterAssassin.exists() then
            --# Vanish with Master Assasin: Rupture+Garrote not in refresh range, during Vendetta+Shiv.
            --actions.vanish+=/vanish,if=(talent.master_assassin.enabled|runeforge.mark_of_the_master_assassin)&!dot.rupture.refreshable&dot.garrote.remains>3&debuff.vendetta.up&(debuff.shiv.up|debuff.vendetta.remains<4|dot.sepsis.ticking)&dot.sepsis.remains<3
            if (talent.masterAssassin or runeforge.masterAssassin) and not debuff.rupture.refresh("target") and debuff.garrote.remain("target") > 3 and debuff.vendetta.exists("target")
                and debuff.shiv.exists("target") and not covenant.nightFae.active then
                if cast.vanish("player") then return true end
            end
            --# Finish with max CP for Nightstalker, unless using Deathly Shadows
            --actions.vanish=variable,name=nightstalker_cp_condition,value=(!runeforge.deathly_shadows&effective_combo_points>=cp_max_spend)|(runeforge.deathly_shadows&combo_points<2)
            local nightstalkerCpCondition = ((not runeforge.deathlyShadows.equipped and combo >= comboMax) or (runeforge.deathlyShadows.equipped and combo < 2)) or false
            --# Vanish with Exsg + Nightstalker: Maximum CP and Exsg ready for next GCD
            --actions.vanish+=/vanish,if=talent.exsanguinate.enabled&talent.nightstalker.enabled&variable.nightstalker_cp_condition&cooldown.exsanguinate.remains<1
            if talent.exsanguinate and talent.nightstalker and nightstalkerCpCondition and cd.exsanguinate.remain() < 1 then
                if cast.vanish("player") then return true end
            end
            --# Vanish with Nightstnalker + No Exsg: Maximum CP and Vendetta up
            --actions.vanish+=/vanish,if=talent.nightstalker.enabled&!talent.exsanguinate.enabled&variable.nightstalker_cp_condition&debuff.vendetta.up
            if talent.nightstalker and not talent.exsanguinate and nightstalkerCpCondition and (debuff.vendetta.exists("target") or not ui.checked("Vendetta")) then
                if cast.vanish("player") then return true end
            end
            --actions.vanish+=/pool_resource,for_next=1,extra_amount=45
            --actions.vanish+=/vanish,if=talent.subterfuge.enabled&cooldown.garrote.up&(dot.garrote.refreshable|debuff.vendetta.up&dot.garrote.pmultiplier<=1)&combo_points.deficit>=(spell_targets.fan_of_knives>?4)&raid_event.adds.in>12
            if talent.subterfuge and not cd.garrote.exists() and (debuff.garrote.refresh("target") or debuff.vendetta.exists("target") and debuff.garrote.applied("target") <= 1) and
                comboDeficit >= (int(enemies10>4)) then
                if cast.pool.garrote() then return true end
                if cast.vanish("player") then return true end
            end
            --# Vanish with Master Assasin: Rupture+Garrote not in refresh range, during Vendetta+Shiv. Sync with Sepsis final hit if possible.
            --actions.vanish+=/vanish,if=(talent.master_assassin.enabled|runeforge.mark_of_the_master_assassin)&!dot.rupture.refreshable&dot.garrote.remains>3&debuff.vendetta.up&(debuff.shiv.up|debuff.vendetta.remains<4|dot.sepsis.ticking)&dot.sepsis.remains<3
            if (talent.masterAssassin or runeforge.masterAssassin) and not debuff.rupture.refresh("target") and debuff.garrote.remain("target") > 3 and debuff.vendetta.exists("target")
                and (debuff.shiv.exists("target") or debuff.vendetta.remain("target") < 4 or debuff.sepsis.exists("target")) and debuff.sepsis.remain() < 3 then
                if cast.vanish("player") then return true end
            end
        end
        -- actions.cds+=/use_items,slots=trinket1,if=variable.trinket_sync_slot=1&(debuff.vendetta.up|fight_remains<=20)
        if ui.checked("Trinkets") then
            if trinket_Pop() then return true end
        end
        -- actions.cds+=/blood_fury,if=debuff.vendetta.up
        -- actions.cds+=/berserking,if=debuff.vendetta.up
        -- actions.cds+=/fireblood,if=debuff.vendetta.up
        -- actions.cds+=/ancestral_call,if=debuff.vendetta.up
        if cdUsage and ui.checked("Racial") and debuff.vendetta.exists("target") and ttd("target") > 5 and targetDistance < 5  then
            if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
                if cast.racial("player") then end
            end
        end
    end

    local function actionList_Direct()
        -- # Refresh garrote when we have Vendetta or Toxic Blade on a target with Master Assassin
        if talent.masterAssassin and debuff.garrote.refresh("target") and debuff.vendetta.exists("target") and not debuff.shiv.exists("target") and comboDeficit > 0 and buff.sliceAndDice.exists("player") and combo > 1 then
            if cast.garrote("target") then return true end
        end
        -- # Shiv if we are about to Envenom, and attempt to sync with Sepsis final hit if we won't waste more than half the cooldown
        if ((debuff.rupture.remain("target") > 9 and debuff.garrote.remain("target") > 9) or debuff.vendetta.exists("target")) and ttd("target") > 9
        and not buff.masterAssassin.exists() and (cd.vendetta.remain() > 9 or mode.cooldown == 3) then
            if cast.shiv("target") then return true end
        end
        -- # Envenom at 4+ (5+ with DS) CP. Immediately on 2+ targets, with Vendetta, or with TB; otherwise wait for some energy. Also wait if Exsg combo is coming up.
        -- actions.direct=envenom,if=combo_points>=4+talent.deeper_stratagem.enabled&(debuff.vendetta.up|debuff.shiv.up|debuff.flagellation.up|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target)&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)
        if combo >= (4 + dSEnabled) and ((debuff.vendetta.exists("target") or not cdUsage or ttd("target") < br.getOptionValue("CDs TTD Limit")) or debuff.shiv.exists("target") or debuff.flagellation.exists("target") or energyDeficit <= (25 + energyRegenCombined) or not singleTarget)
         and (not talent.exsanguinate or cd.exsanguinate.remain() > 2 or debuff.rupture.remain("target") > 27 or ttd("target") < 4 or mode.exsang == 2) then
            if cast.envenom("target") then return true end
        end
        -- actions.direct+=/variable,name=use_filler,value=combo_points.deficit>1|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target
        local useFiller = (comboDeficit > 1 or energyDeficit <= (25 + energyRegenCombined) or enemies10 > 1) and (not stealthedRogue or talent.masterAssassin) and not br.GetUnitIsFriend("player", "target")
        -- actions.direct+=/serrated_bone_spike
        if not stealthedRogue and not buff.masterAssassin.exists() and cd.vanish.remain() < 115 and buff.sliceAndDice.exists("player") and buff.leadByExample.remain() <= 3 then
            local spikeCount = serratedCount + 2
            local spikeList = enemies.get(30, "player", false, true)
            if #spikeList > 0 then
                if (comboDeficit >= spikeCount or (spikeCount > 3 and combo < 2)) then
                    if #spikeList > 1 then
                        table.sort(spikeList, function(x, y)
                            return br.getHP(x) < br.getHP(y)
                        end
                        )
                    end
                    for i = 1, #spikeList do
                        if br.isSafeToAttack(spikeList[i]) and (br.getHP(spikeList[i]) < 90 or br.getUnitID(thisUnit) ~= 171557) and 
                         (not debuff.serratedBoneSpikeDot.exists(spikeList[i]) or charges.serratedBoneSpike.frac() >= 2.75) then
                            if cast.serratedBoneSpike(spikeList[i]) then
                                return true
                            end
                        end
                    end
                    if #spikeList == 1 and (debuff.shiv.exists("target") or charges.serratedBoneSpike.frac() >= 2.75) and (charges.serratedBoneSpike.frac() >= 2 or fightRemain < 30) then
                        if cast.serratedBoneSpike("target") then
                            return true
                        end
                    end
                end
            end
        end
        if #enemyTable30 > 1 and (enemyTable30.lowestTTD < (comboDeficit * 1.5) or comboDeficit >= comboMax) then
            if cast.markedForDeath(enemyTable30.lowestTTDUnit) then return true end
        end
        --# Fan of Knives at 19+ stacks of Hidden Blades or against 4+ targets.
        --actions.direct+=/fan_of_knives,if=variable.use_filler&(buff.hidden_blades.stack>=19|(!priority_rotation&spell_targets.fan_of_knives>=4+stealthed.rogue))
        if useFiller and not buff.masterAssassin.exists() and (buff.hiddenBlades.stack() >= 19 or (not priorityRotation and fokenemies10 >= (4 + sRogue))) then
            if cast.fanOfKnives("player") then return true end
        end
        --# Fan of Knives to apply Deadly Poison if inactive on any target at 3 targets.
        --actions.direct+=/fan_of_knives,target_if=!dot.deadly_poison_dot.ticking,if=variable.use_filler&spell_targets.fan_of_knives>=3
        if useFiller and not deadlyPoison10 and fokenemies10 >= 3 then
            if cast.fanOfKnives("player") then return true end
        end
        --actions.direct+=/echoing_reprimand,if=variable.use_filler&cooldown.vendetta.remains>10
        if useFiller and cast.able.echoingReprimand() and cd.vendetta.remain() > 10 then
            if cast.echoingReprimand("target") then return true end
        end
        --actions.direct+=/ambush,if=variable.use_filler&(master_assassin_remains=0|buff.blindside.up)
        if useFiller and cast.able.ambush("target") and (not buff.masterAssassin.exists() or buff.blindside.exists()) and debuff.rupture.exists("target") then
            if cast.ambush("target") then return true end
        end
        --# Tab-Mutilate to apply Deadly Poison at 2 targets
        --actions.direct+=/mutilate,target_if=!dot.deadly_poison_dot.ticking,if=variable.use_filler&spell_targets.fan_of_knives=2
        if useFiller and enemies10 == 2 then
            if (br.getOptionValue("Lethal Poison") == 1 and not debuff.instantPoison.exists("target")) or (br.getOptionValue("Lethal Poison") == 2 and not debuff.woundPoison.exists("target")) then
                if cast.mutilate("target") then return true end
            end
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if (br.getOptionValue("Lethal Poison") == 1 and not debuff.instantPoison.exists(thisUnit)) or (br.getOptionValue("Lethal Poison") == 2 and not debuff.woundPoison.exists(thisUnit)) then
                    if cast.mutilate(thisUnit) then return true end
                end
            end
        end
        --actions.direct+=/mutilate,if=variable.use_filler
        if useFiller then
            if cast.mutilate("target") then return true end
        end
        -- Throw  Poisoned Knife if we can't reach the target
        if br.isChecked("Poisoned Knife out of range") and not stealthedRogue and #enemyTable5 == 0 and energy >= br.getOptionValue("Poisoned Knife out of range") and inCombat then
            for i = 1, #enemyTable30 do
                local thisUnit = enemyTable30[i].unit
                --check if any targets are not poisoned firstget
                if (br.getOptionValue("Lethal Poison") == 1 and not debuff.instantPoison.exists(thisUnit)) or (br.getOptionValue("Lethal Poison") == 2 and not debuff.woundPoison.exists(thisUnit)) then
                    if cast.poisonedKnife(thisUnit) then
                        return true
                    end
                else
                    if cast.poisonedKnife(thisUnit) then
                        return true
                    end
                end
            end
        end
        --evis low level
        if level < 36 and combo >= 4 then
            if cast.eviscerate("target") then return true end
        end
        -- Sinister Strike
        if level < 40 then
            if cast.sinisterStrike("target") then return true end
        end
    end

    local function actionList_Dot()
        --# Limit Garrotes on non-primrary targets for the priority rotation if 5+ bleeds are already up
        --actions.dot=variable,name=skip_cycle_garrote,value=priority_rotation&spell_targets.fan_of_knives>3&(dot.garrote.remains<cooldown.garrote.duration|poisoned_bleeds>5)
        local skipCycleGarrote = (priorityRotation and enemies10 > 3 and (debuff.garrote.remain("target") < cd.garrote.remain() or poisonedBleeds > 5)) or false
        --# Limit Ruptures on non-primrary targets for the priority rotation if 5+ bleeds are already up
        --actions.dot+=/variable,name=skip_cycle_rupture,value=priority_rotation&spell_targets.fan_of_knives>3&(debuff.shiv.up|poisoned_bleeds>5)
        local skipCycleRupture = (priorityRotation and enemies10 > 3 and (debuff.shiv.exists("target") or poisonedBleeds > 5)) or false
        --# Limit Ruptures if Vendetta+Shiv/Master Assassin is up and we have 2+ seconds left on the Rupture DoT
        --actions.dot+=/variable,name=skip_rupture,value=debuff.vendetta.up&(debuff.shiv.up|master_assassin_remains>0)&dot.rupture.remains>2
        local skipRupture = (debuff.vendetta.exists("target") and (debuff.shiv.exists("target") or buff.masterAssassin.exists()) and debuff.rupture.remain() > 2) or false
        if mode.exsang == 1 and talent.exsanguinate then
            -- # Special Garrote and Rupture setup prior to Exsanguinate cast
            -- actions.dot+=/garrote,if=talent.exsanguinate.enabled&!exsanguinated.garrote&dot.garrote.pmultiplier<=1&cooldown.exsanguinate.remains<2&spell_targets.fan_of_knives=1&raid_event.adds.in>6&dot.garrote.remains*0.5<target.time_to_die
            if debuff.garrote.applied("target") <= 1 and not debuff.garrote.exsang("target") and cd.exsanguinate.remain() < 1.5 and debuff.garrote.remain("target") * 0.5 < ttd("target") and debuff.garrote.remain("target") < 16 then
                if cast.garrote("target") then return true end
            end
            -- # Special Rupture setup for Exsg
            -- actions.dot+=/rupture,if=talent.exsanguinate.enabled&(combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1&dot.rupture.remains*0.5<target.time_to_die)
            if combo >= comboMax and cd.exsanguinate.remain() < 2 and debuff.rupture.remain("target") * 0.5 < ttd("target") and debuff.rupture.remain("target") < 26 then
                if cast.rupture("target") then return true end
            end
        end
        --# Garrote upkeep, also tries to use it as a special generator for the last CP before a finisher
        --actions.dot+=/pool_resource,for_next=1
        --actions.dot+=/garrote,if=refreshable&combo_points.deficit>=1&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3)&(target.time_to_die-remains)>4&master_assassin_remains=0
        --actions.dot+=/pool_resource,for_next=1
        --actions.dot+=/garrote,cycle_targets=1,if=!variable.skip_cycle_garrote&target!=self.target&refreshable&combo_points.deficit>=1&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3)&(target.time_to_die-remains)>12&master_assassin_remains=0
        local vanishCheck, vendettaCheck = false, false
        if cdUsage and ttd("target") > br.getOptionValue("CDs TTD Limit") then
            if mode.vanish == 1 and cd.vanish.remain() == 0 then vanishCheck = true end
            if br.isChecked("Vendetta") and cd.vendetta.remain() <= 4 then vendettaCheck = true end
        end
        if (not talent.subterfuge or not (vanishCheck and vendettaCheck)) and not skipCycleGarrote and comboDeficit >= 1 and garroteCheck and br.getSpellCD(spell.garrote) == 0 then
            if garroteCount <= br.getOptionValue("Multidot Limit") and (not talent.masterAssassin or not buff.masterAssassin.exists()) then
                for i = 1, #enemyTable5 do
                    local thisUnit = enemyTable5[i].unit
                    local garroteRemain = debuff.garrote.remain(thisUnit)
                    if br.GetObjectID(thisUnit) ~= 167999 and ((garroteRemain == 0 and garroteCount < br.getOptionValue("Multidot Limit")) or (garroteRemain > 0 and garroteCount <= br.getOptionValue("Multidot Limit"))) and
                     debuff.garrote.refresh(thisUnit) and (debuff.garrote.applied(thisUnit) <= 1 or (garroteRemain <= tickTime and enemies10 >= 3)) and
                     (not debuff.garrote.exsang(thisUnit) or (garroteRemain < (tickTime * 2) and enemies10 >= 3)) and
                     (((enemyTable5[i].ttd-garroteRemain)>4 and enemies10 <= 1) or (enemyTable5[i].ttd-garroteRemain)>12)  then
                        if cast.pool.garrote() then return true end
                        if cast.garrote(thisUnit) then return true end
                    end
                end
            end
        end
        --# Crimson Tempest on multiple targets at 4+ CP when running out in 2-3s as long as we have enough regen and aren't setting up for Vendetta
        --actions.dot+=/crimson_tempest,if=spell_targets>=2&remains<2+(spell_targets>=5)&effective_combo_points>=4&energy.regen_combined>20&(!cooldown.vendetta.ready|dot.rupture.ticking)
        if talent.crimsonTempest and ctenemies10 > 1 and not stealthedAll and combo >= 4 and energyRegenCombined > 20 then
            local crimsonTargets
            if ctenemies10 >= 5 then crimsonTargets = 1 else crimsonTargets = 0 end
            for i = 1, ctenemies10 do
                local thisUnit = enemyTable10[i].unit
                local crimsonRemain = debuff.crimsonTempest.remain(thisUnit)
                if crimsonRemain < (2+crimsonTargets) and (cd.vendetta.exists() or ruptureCount > 0) then
                    if cast.crimsonTempest("player", "aoe", 1, 10) then return true end
                end
            end
        end
        --# Keep up Rupture at 4+ on all targets (when living long enough and not snapshot)
        --actions.dot+=/rupture,if=!variable.skip_rupture&(effective_combo_points>=4&refreshable|!ticking&(time>10|combo_points>=2))&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3)&target.time_to_die-remains>4
        if singleTarget and not skipRupture and combo >= 4 and cast.able.rupture("target") and (debuff.rupture.refresh("target") or not debuff.rupture.exists("target")) and
         (debuff.rupture.applied("target") <= 1 or (debuff.rupture.remain("target") <= tickTime and enemies10 >= 3))
         and (not debuff.rupture.exsang("target") or (debuff.rupture.remain("target") < (tickTime *2) and enemies10 >= 3))
         and (ttd("target")-debuff.rupture.remain("target")) > 4 and debuff.garrote.exists("target") then
            if cast.rupture("target") then return true end
         end
        --actions.dot+=/rupture,cycle_targets=1,if=!variable.skip_cycle_rupture&!variable.skip_rupture&target!=self.target&effective_combo_points>=4&refreshable&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3)&target.time_to_die-remains>(4+runeforge.dashing_scoundrel*9+runeforge.doomblade*6)
        if not skipCycleRupture and combo >= 4 and br.getSpellCD(spell.rupture) == 0 and (mode.focus == 1 or energyDeficit > (25 + energyRegenCombined)) then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                local ruptureRemain = debuff.rupture.remain(thisUnit)
                if br.GetObjectID(thisUnit) ~= 167999 and debuff.rupture.refresh(thisUnit) and
                 (debuff.rupture.applied(thisUnit) <= 1 or (ruptureRemain <= tickTime and enemies10 >= 3)) and
                 (not debuff.rupture.exsang(thisUnit) or (ruptureRemain < (tickTime *2) and enemies10 >= 3)) and
                 (enemyTable5[i].ttd-ruptureRemain) > (4 + (DSEquipped*9) + (DoomEquipped*6)) and
                 (debuff.garrote.exists(thisUnit) or combatTime > 5) then
                    if cast.rupture(thisUnit) then return true end
                end
            end
        end
        --# Crimson Tempest on ST if in pandemic and nearly max energy and if Envenom won't do more damage due to TB/MA
        --actions.dot+=/crimson_tempest,if=spell_targets=1&effective_combo_points>=(cp_max_spend-1)&refreshable&!exsanguinated&!debuff.shiv.up&master_assassin_remains=0&(energy.deficit<=25+variable.energy_regen_combined)&target.time_to_die-remains>4
        if singleTarget and combo >= (comboMax-1) and debuff.crimsonTempest.refresh("target") and not debuff.crimsonTempest.exsang("target") and not debuff.shiv.exists("target") and not buff.masterAssassin.exists() and (energyDeficit <= (25 + energyRegenCombined)) and ttd("target") > 4 then
            if cast.crimsonTempest("player", "aoe", 1, 10) then return true end
        end
    end

    local function actionList_Stealthed()
        --# Nighstalker on 3T: Crimson Tempest
        --actions.stealthed=crimson_tempest,if=talent.nightstalker.enabled&spell_targets>=3&combo_points>=4&target.time_to_die-remains>6
        if talent.nightstalker and enemies10 >= 3 and combo >= 4 and (ttd("target")-debuff.crimsonTempest.remain("target")) > 6 then
            if cast.crimsonTempest("player", "aoe", 1, 10) then return true end
        end
        --# Nighstalker on 1T: Snapshot Rupture
        --actions.stealthed+=/rupture,if=talent.nightstalker.enabled&combo_points>=4&target.time_to_die-remains>6
        if combo >= 4 and ttd("target") > 6 and talent.nightstalker then
            if cast.rupture("target") then return true end
        end
        --# Subterfuge: Apply or Refresh with buffed Garrotes
        --actions.stealthed+=/pool_resource,for_next=1
        --actions.stealthed+=/garrote,target_if=min:remains,if=talent.subterfuge.enabled&(remains<12|pmultiplier<=1)&target.time_to_die-remains>2
        if talent.subterfuge then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                local garroteRemain = debuff.garrote.remain(thisUnit)
                if shallWeDot(thisUnit) and (garroteRemain < 12 or debuff.garrote.applied(thisUnit) <= 1) and not debuff.garrote.exsang(thisUnit) and (enemyTable5[i].ttd - garroteRemain) > 2 then
                    if cast.pool.garrote() then return true end
                    if cast.garrote(thisUnit) then return true end
                end
            end
        end
        --# Subterfuge + Exsg on 1T: Refresh Garrote at the end of stealth to get max duration before Exsanguinate
        --actions.stealthed+=/pool_resource,for_next=1
        --actions.stealthed+=/garrote,if=talent.subterfuge.enabled&talent.exsanguinate.enabled&active_enemies=1&buff.subterfuge.remains<1.3
        if mode.exsang == 1 and talent.subterfuge and talent.exsanguinate and enemies10 == 1 and buff.subterfuge.remain() < 1.3 and not debuff.vendetta.exists("target") then
            if cast.pool.garrote() then return true end
            if cast.garrote("target") then return true end
        end
        if cast.able.serratedBoneSpike() and (combatTime < 1.5 and cd.vanish.remain() < 118) and not talent.subterfuge then
            if cast.serratedBoneSpike("target") then return true end
        end
        --actions.stealthed+=/mutilate,if=talent.subterfuge.enabled&combo_points<=3
        if talent.subterfuge and combo <= 3 then
            if cast.mutilate("target") then return true end
        end
    end

-----------------
--- Rotations ---
-----------------
    -- Pause
    if br._G.IsMounted() or br._G.IsFlying() or br.isLooting() or br.pause() or mode.rotation==3 or ((buff.soulshape.exists() or br.hasBuff(338659)) and not inCombat) then
        return true
    else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
    if not cast.last.vanish(1) then
        if actionList_Extra() then return true end
    end
    if not inCombat and br.GetObjectExists("target") and not br.GetUnitIsDeadOrGhost("target") and br._G.UnitCanAttack("target", "player") then
        if actionList_PreCombat() then return true end
    end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations ---
-----------------------------
        if (inCombat or (not ui.checked("Disable Auto Combat") and (cast.last.vanish(1) or cast.last.vanish(2) or (validTarget and targetDistance < 15)))) then
            if (cast.last.vanish(1) and mode.vanish == 2) then br._G.StopAttack()end
            if mode.defensive == 1 then
                if actionList_Defensive() then return true end
            end
            if mode.interrupt == 1 then
                if actionList_Interrupts() then return true end
            end
            -- actions.precombat+=/marked_for_death,precombat_seconds=5,if=raid_event.adds.in>40
            if stealth and comboDeficit > 2 and talent.markedForDeath and validTarget and targetDistance < 5 then
                if cast.markedForDeath("target") then
                    combo = comboMax
                    comboDeficit = 0
                end
            end
            --tricks
            if tricksUnit ~= nil and validTarget and targetDistance < 5 and br._G.UnitThreatSituation("player") and br._G.UnitThreatSituation("player") > 0 then
                cast.tricksOfTheTrade(tricksUnit)
            end
            -- # Restealth if possible (no vulnerable enemies in combat)
            -- actions=stealth
            if br._G.IsUsableSpell(br._G.GetSpellInfo(spell.stealth)) and not br._G.IsStealthed() and not inCombat and not cast.last.vanish() then
                cast.stealth("player")
            end
            -- actions+=/call_action_list,name=stealthed,if=stealthed.rogue
            if stealthedAll and targetDistance < 5 then
                if actionList_Stealthed() then return true end
            end
            --start aa
            if not stealthedRogue and validTarget and targetDistance < 5 and not br._G.IsCurrentSpell(6603) then
                br._G.StartAttack("target")
            end
            -- actions+=/call_action_list,name=cds,if=(!talent.master_assassin.enabled|dot.garrote.ticking)
            if validTarget and (not talent.masterAssassin or debuff.garrote.exists("target")) then
                if actionList_Cooldowns() then return true end
            end
            --# Put SnD up initially for Cut to the Chase, refresh with Envenom if at low duration
            -- actions+=/slice_and_dice,if=!buff.slice_and_dice.up&combo_points>=3
            if (not buff.sliceAndDice.exists("player") and combatTime < 3 and cd.vanish.remain() < 117) then -- (not buff.sliceAndDice.exists("player") and combo >= 3 and not animachargedCP) or
                if cast.sliceAndDice("player") then return true end
            end
            -- actions+=/call_action_list,name=dot
            if buff.sliceAndDice.exists("player") then
                if actionList_Dot() then return true end
            end
            -- actions+=/call_action_list,name=direct
            if actionList_Direct() then return true end
            -- actions+=/arcane_torrent,if=energy.deficit>=15+variable.energy_regen_combined
            -- actions+=/arcane_pulse
            -- actions+=/lights_judgment
            if cdUsage and br.isChecked("Racial") and targetDistance < 5 then
                if race == "BloodElf" and energyDeficit >= (15 + energyRegenCombined) and not buff.masterAssassin.exists() then
                    if cast.racial("player") then return true end
                elseif race == "Nightborne" then
                    if cast.racial("player") then return true end
                elseif race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then return true end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation

local id = 259 --Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
