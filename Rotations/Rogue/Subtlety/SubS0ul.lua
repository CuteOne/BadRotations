local rotationName = "SubS0ul - 9.0.5"
local dotBlacklist = "168962|175992|171557|175992"
local stunSpellList = "332329|332671|326450|328177|336451|331718|331743|334708|333145|326450|332671|321807|334748|327130|327240|330532|328475|330423|328177|336451|294171|330586|328429"
local StunsBlackList = "167876|169861|168318|165824|165919|171799|168942|167612|169893|167536"
---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    local CreateButton = br["CreateButton"]
    br.RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of enemies in range.", highlight = 1, icon = br.player.spell.shurikenStorm },
        [2] = { mode = "Sing", value = 2 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shadowstrike },
        [3] = { mode = "Off", value = 3 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.stealth}
    };
    CreateButton("Rotation",1,0)
    br.AoeModes = {
        [1] = { mode = "Std", value = 1 , overlay = "Standard AoE Rotation", tip = "Standard AoE Rotation.", highlight = 1, icon = br.player.spell.rupture },
        [2] = { mode = "Prio", value = 2 , overlay = "Priority Target AoE Rotation", tip = "Priority Target AoE Rotation.", highlight = 1, icon = br.player.spell.eviscerate }
    };
    CreateButton("Aoe",1,-1)
    br.CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.shadowBlades },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.shadowBlades },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.shadowBlades },
        [4] = { mode = "Lust", value = 4 , overlay = "Cooldowns With Bloodlust", tip = "Cooldowns will be used with bloodlust or simlar effects.", highlight = 0, icon = br.player.spell.shadowBlades }
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
        [1] = { mode = "On", value = 1 , overlay = "Use Vanish", tip = "Use Vanish", highlight = 1, icon = br.player.spell.vanish },
        [2] = { mode = "Off", value = 2 , overlay = "Vanish Disabled", tip = "Vanish Disabled.", highlight = 0, icon = br.player.spell.vanish }
    };
    CreateButton("Vanish",3,-1)
    br.SDModes = {
        [1] = { mode = "On", value = 1 , overlay = "Use Shadow Dance", tip = "Using Shadow Dance.", highlight = 1, icon = br.player.spell.shadowDance },
        [2] = { mode = "Off", value = 2 , overlay = "Shadow Dance Disabled", tip = "Shadow Dance Disabled.", highlight = 0, icon = br.player.spell.shadowDance }
    };
    CreateButton("SD",4,0)
    br.SoDModes = {
        [1] = { mode = "On", value = 1 , overlay = "Use Symbols of Death", tip = "Using Symbols of Death.", highlight = 1, icon = br.player.spell.symbolsOfDeath },
        [2] = { mode = "Off", value = 2 , overlay = "Symbols of Death Disabled", tip = "Symbols of Death Disabled.", highlight = 0, icon = br.player.spell.symbolsOfDeath }
    };
    CreateButton("SoD",4,-1)
    br.STModes = {
        [1] = { mode = "On", value = 1 , overlay = "Use Secret Technique", tip = "Using Secret Technique.", highlight = 1, icon = br.player.spell.secretTechnique },
        [2] = { mode = "Off", value = 2 , overlay = "Secret Technique Disabled", tip = "Secret Technique Disabled.", highlight = 0, icon = br.player.spell.secretTechnique }
    };
    CreateButton("ST",5,0)
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
            br.ui:createDropdown(section, "Non-Lethal Poison", {"Crippling","Numbing",}, 1, "Non-Lethal Poison to apply")
            br.ui:createDropdown(section, "Lethal Poison", {"Instant","Wound",}, 1, "Lethal Poison to apply")
            br.ui:createDropdown(section, "Auto Stealth", {"Always", "25 Yards"},  1, "Auto stealth mode.")
            br.ui:createDropdown(section, "Auto Tricks", {"Focus", "Tank"},  1, "Tricks of the Trade target." )
            br.ui:createCheckbox(section, "Auto Target", "Will auto change to a new target, if current target is dead.")
            br.ui:createSpinner(section, "Auto Soothe", 1, 0, 100, 5, "TTD for soothing")
            br.ui:createCheckbox(section, "Disable Auto Combat", "Will not auto attack out of stealth.")
            br.ui:createCheckbox(section, "Dot Blacklist", "Check to ignore certain units when multidotting.")
            br.ui:createCheckbox(section, "Auto Rupture HP Limit", "Will try to calculate if we should rupture units, based on their HP")
            br.ui:createSpinnerWithout(section,  "Multidot Limit",  3,  0,  8,  1,  "Max units to dot with rupture.")
            br.ui:createSpinner(section, "Shuriken Toss out of range", 90,  1,  100,  5,  "Use Shuriken Toss out of range")
            br.ui:createCheckbox(section, "Spread Find Weakness", "Will shadowstrike to apply find weakness on multiple enemies, I advise uncheking that in raids.")
            br.ui:createCheckbox(section, "Ignore Blacklist for SS", "Ignore blacklist for Shrukien Storm usage.")
            br.ui:createSpinner(section,  "Save SD Charges for CDs",  0.75,  0,  1,  0.05,  "Shadow Dance charges to save for CDs. (Use toggle to disable SD for saving all)")
            br.ui:createDropdownWithout(section, "MfD Target", {"Lowest TTD", "Always Target"},  1, "MfD Target.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            br.ui:createCheckbox(section, "Racial", "Will use Racial")
            br.ui:createCheckbox(section, "Trinkets", "Will use Trinkets")
            br.ui:createDropdown(section, "Potion", {"Phantom Fire", "Empowered Exorcisms", "Spectral Agi"}, 1, "Potion with CDs")
            br.ui:createCheckbox(section, "Shadow Blades", "Will use Shadow Blades")
            br.ui:createCheckbox(section, "Precombat", "Will use items/pots on pulltimer")
            br.ui:createCheckbox(section, "Opener", "Cast all cooldowns during opener with bosses")
            br.ui:createSpinnerWithout(section,  "CDs TTD Limit",  5,  0,  20,  1,  "Time to die limit for using cooldowns.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            br.player.module.BasicHealing(section)
            br.ui:createCheckbox(section, "Cloak of Shadows")
            br.ui:createSpinner(section, "Crimson Vial",  40,  0,  100,  5,  "Health Percentage to use at.")
            br.ui:createSpinner(section, "Evasion",  50,  0,  100,  5,  "Health Percentage to use at.")
            br.ui:createSpinner(section, "Feint", 75, 0, 100, 5, "Health Percentage to use at.")
            br.ui:createCheckbox(section, "Auto Defensive Unavoidables", "Will use feint/evasion on certain unavoidable boss abilities")
            br.ui:createSpinnerWithout(section,  "Evasion Unavoidables HP Limit",  85,  0,  100,  5,  "Player HP to use evasion on unavoidables.")
            br.ui:createCheckbox(section, "Cloak Unavoidables", "Will cloak on unavoidables")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            br.ui:createCheckbox(section, "Kick")
            br.ui:createDropdown(section, "Kidney/Cheap interrupt", {"Kidney","Cheap","Both"}, 3, "What to use to interrupt")
            br.ui:createCheckbox(section, "Blind")
            br.ui:createDropdown(section, "Priority Mark", { "|cffffff00Star", "|cffffa500Circle", "|cff800080Diamond", "|cff008000Triangle", "|cffffffffMoon", "|cff0000ffSquare", "|cffff0000Cross", "|cffffffffSkull" }, 8, "Mark to Prioritize")
            br.ui:createSpinnerWithout(section,  "Interrupt %",  0,  0,  95,  5,  "Remaining Cast Percentage to interrupt at.")
            br.ui:createCheckbox(section, "Stuns", "Auto stun mobs from whitelist")
            br.ui:createSpinnerWithout(section,  "Max CP For Stun",  3,  1,  6,  1,  " Maximum number of combo points to stun")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            br.ui:createDropdownWithout(section,  "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
        ----------------------
        -------- LISTS -------
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Lists")
            br.ui:createScrollingEditBoxWithout(section,"Dot Blacklist Units", dotBlacklist, "List of units to blacklist when multidotting", 240, 40)
            br.ui:createScrollingEditBoxWithout(section,"Stun Spells", stunSpellList, "List of spells to stun with auto stun function", 240, 50)
            br.ui:createScrollingEditBoxWithout(section,"Stun Blacklist", StunsBlackList, "List of enemies we can't stun", 240, 50)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

---------------
---CombatLog---
---------------
-- local someone_casting = false
-- local frame = br._G.CreateFrame("Frame")
-- frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
-- local function reader()
--     local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = br._G.CombatLogGetCurrentEventInfo()
--     if param == "SPELL_CAST_START" and br._G.bit.band(sourceFlags, 0x00000800) > 0 then
--         br._G.C_Timer.After(0.02, function()
--             someone_casting = true
--         end)
--     end
-- end
-- frame:SetScript("OnEvent", reader)

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------
    --- Toggles --- -- Add toggles if ability speced
    ---------------
    br.UpdateToggle("Rotation",0.25)
    br.UpdateToggle("Cooldown",0.25)
    br.UpdateToggle("Defensive",0.25)
    br.UpdateToggle("Interrupt",0.25)
    br.player.ui.mode.aoe = br.data.settings[br.selectedSpec].toggles["Aoe"]
    br.player.ui.mode.sd = br.data.settings[br.selectedSpec].toggles["SD"]
    br.player.ui.mode.sod = br.data.settings[br.selectedSpec].toggles["SoD"]
    br.player.ui.mode.st = br.data.settings[br.selectedSpec].toggles["ST"]
    br.player.ui.mode.vanish = br.data.settings[br.selectedSpec].toggles["Vanish"]
    if not br.isInCombat("player") then
        if not br.player.talent.secretTechnique then
            br.buttonST:Hide()
        else
            br.buttonST:Show()
        end
    end
    --------------
    --- Locals ---
    --------------
    local lastSpell                           = br.lastSpellCast
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
    local enemies                             = br.player.enemies
    local equiped                             = br.player.equiped
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
    local stealthedRogue                      = stealth or br.player.buff.vanish.exists() or br.player.buff.subterfuge.remain() > 0.2 or br.player.cast.last.vanish(1)
    local stealthedAll                        = stealth or br.player.buff.vanish.exists() or br.player.buff.subterfuge.remain() > 0.2 or br.player.cast.last.vanish(1) or br.player.buff.shadowmeld.exists() or br.player.buff.shadowDance.exists() or br.player.cast.last.shadowDance(1)
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
    if leftCombat == nil then leftCombat = br._G.GetTime() end
    if profileStop == nil then profileStop = false end

    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    -- Enemies
    enemies.get(5) -- Makes a variable  called, enemies.yards5
    enemies.get(20)
    enemies.get(20,"player",true)
    enemies.get(25,"player",true) -- makes enemies.yards25nc
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
    for i in string.gmatch(ui.value("Dot Blacklist Units"), "%d+") do
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

    local enemyTable30 = { }
    local enemyTable10 = { }
    local enemyTable5 = { }
    local fightRemain = 0
    local ruptureCount = 0
    local serratedCount = 0
    if #enemies.yards30 > 0 then
        local highestHP
        local lowestHP
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if (not noDotCheck(thisUnit) or br.GetUnitIsUnit(thisUnit, "target")) and not br.GetUnitIsDeadOrGhost(thisUnit) and br.isSafeToAttack(thisUnit)
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
                local sStormIgnore = {
                    [120651]=true, -- Explosive
                    [168962]=true, -- Sun King's Reborn Phoenix
                    [166969]=true, -- Baroness Frieda
                    [166971]=true, -- Castellan Niklaus
                    [166970]=true, -- Lord Stavros
                }
                local thisUnit = enemyTable30[i]
                local hpNorm = (10-1)/(highestHP-lowestHP)*(thisUnit.hpabs-highestHP)+10 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0/0) then hpNorm = 0 end -- NaN check
                local enemyScore = hpNorm
                if debuff.serratedBoneSpike.exists(thisUnit.unit) then serratedCount = serratedCount + 1 end
                if thisUnit.distance <= 10 then
                    if sStormIgnore[thisUnit.objectID] == nil and not isTotem(thisUnit.unit) then
                        br._G.tinsert(enemyTable10, thisUnit)
                    end
                    if thisUnit.distance <= 5 then
                        br._G.tinsert(enemyTable5, thisUnit)
                    end
                    if debuff.rupture.remain(thisUnit.unit) > 0.5 then ruptureCount = ruptureCount + 1 end
                end
                if thisUnit.ttd > 1.5 then enemyScore = enemyScore + 10 end
                if thisUnit.facing then enemyScore = enemyScore + 30 end
                if thisUnit.distance <= 5 then enemyScore = enemyScore + 30 end
                if br.GetUnitIsUnit(thisUnit.unit, "target") then enemyScore = enemyScore + 100 end
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
        if ui.checked("Auto Target") and inCombat and #enemyTable30 > 0 and ((br.GetUnitExists("target") and br.GetUnitIsDeadOrGhost("target") and not br.GetUnitIsUnit(enemyTable30[1].unit, "target")) or not br.GetUnitExists("target")) then
            br._G.TargetUnit(enemyTable30[1].unit)
        end
    end

    local function trinket_Pop()
        if cdUsage and ui.checked("Trinkets") and (buff.symbolsOfDeath.exists() or cd.symbolsOfDeath.remain() < 1) and ttd("target") > ui.value("CDs TTD Limit") then
            if br.canUseItem(13) and not br.hasEquiped(178715, 13) and not br.hasEquiped(184016, 13) and not br.hasEquiped(181333, 13) and not br.hasEquiped(179350, 13) then
                br.useItem(13)
            end
            if br.canUseItem(14) and not br.hasEquiped(178715, 14) and not br.hasEquiped(184016, 14) and not br.hasEquiped(181333, 14) and not br.hasEquiped(179350, 14) then
                br.useItem(14)
            end
        end
        -- Inscrutable Quantum Device
        if ui.checked("Trinkets") and (br._G.GetInventoryItemID("player", 13) == 179350 or br._G.GetInventoryItemID("player", 14) == 179350) and br.canUseItem(179350) and (buff.shadowBlades.exists() or (br.isBoss() and fightRemain <= 20)) then
            br.useItem(179350)
        end
        -- Skuler's Wing
        if ui.checked("Trinkets") and (br._G.GetInventoryItemID("player", 13) == 184016 or br._G.GetInventoryItemID("player", 14) == 184016) and br.canUseItem(184016) and #enemyTable10 > 0 then
            br.useItem(184016)
        end
    end

    -- nil fixes
    if enemyTable30.lowestTTD == nil then enemyTable30.lowestTTD = 999 end
    if enemyTable30.highestTTD == nil then enemyTable30.highestTTD = 999 end

    --Variables
    local dSEnabled, subterfugeActive, vEnabled, mosEnabled, sfEnabled, aEnabled, sndCondition, ssThd, priorityRotation, necroActive, animachargedCP, flagellationActive, nightstalkerActive, darkShadowActive
    local ruptureRemain = debuff.rupture.remain("target")
    local enemies10 = #enemyTable10
    if talent.deeperStratagem then dSEnabled = 1 else dSEnabled = 0 end
    if talent.vigor then vEnabled = 1 else vEnabled = 0 end
    if talent.masterOfShadows then mosEnabled = 1 else mosEnabled = 0 end
    if talent.shadowFocus then sfEnabled = 1 else sfEnabled = 0 end
    if talent.alacrity then aEnabled = 1 else aEnabled = 0 end
    if talent.subterfuge then subterfugeActive = 1 else subterfugeActive = 0 end
    if talent.gloomblade then gloombladeActive = 1 else gloombladeActive = 0 end
    if talent.flagellation then flagellationActive = 1 else flagellationActive = 0 end
    if talent.nightstalker then nightstalkerActive = 1 else nightstalkerActive = 0 end
    if talent.darkShadow then darkShadowActive = 1 else darkShadowActive = 0 end
    if enemies10 >= 4 then ssThd = 1 else ssThd = 0 end
    if covenant.necrolord.active then necroActive = 1 else necroActive = 0 end
    --if cast.last.kick() or cast.last.kidneyShot() or cast.last.cheapShot() or cast.last.blind() or combatTime < 1 then someone_casting = false end
    -- # Used to determine whether cooldowns wait for SnD based on targets.
    -- variable,name=snd_condition,value=buff.slice_and_dice.up|spell_targets.shuriken_storm>=6
    if buff.sliceAndDice.exists("player") or enemies10 >= 6 then sndCondition = 1 else sndCondition = 0 end
    -- # Only change rotation if we have priority_rotation set and multiple targets up.
    -- actions+=/variable,name=use_priority_rotation,value=priority_rotation&spell_targets.shuriken_storm>=2
    if mode.aoe == 2 and enemies10 >= 2 then priorityRotation = true else priorityRotation = false end
    -- # Check to see if the next CP (in the event of a ShT proc) is Animacharged
    if br.hasBuff(323558) and combo == 2 or br.hasBuff(323559) and combo == 3 or br.hasBuff(323560) and combo == 4 then animachargedCP = true else animachargedCP = false end

    if ui.checked("Ignore Blacklist for SS") and mode.rotation ~= 2 then
        enemies10 = #enemies.get(10)
    end
    --------------------
    --- Action Lists ---
    --------------------
    local function actionList_Extra()
        if not inCombat then
            -- actions.precombat+=/apply_poison
            if ui.checked("Lethal Poison") and not moving then
                if ui.value("Lethal Poison") == 1 and buff.instantPoison.remain() < 300 and not cast.last.instantPoison(1) then
                    if cast.instantPoison("player") then return true end
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
            [120651] = true, -- Explosive
            [164362] = true, -- Plaguefall Slimy Morsel
            [164427] = true, -- NW Reanimated Warrior
            [164414] = true, -- NW Reanimated Mage
            [168246] = true, -- NW Reanimated Crossbowman
            [164702] = true, -- NW Carrion Worm
            [175992] = true, -- Dutiful Attendant
        }
        if br.GetObjectExists("target") and burnUnits[br.GetObjectID("target")] ~= nil then
            if combo >= 4 then
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
                --Powder Shot (2nd boss freehold)
                if bossID == 126848 and br.isCastingSpell(256979, "target") and br.GetUnitIsUnit("player", br._G.UnitTarget("target")) then
                    if talent.elusiveness then
                        if cast.feint("player") then return true end
                    elseif ui.value("Evasion Unavoidables HP Limit") >= php then
                        if cast.evasion("player") then return true end
                    end
                end
                --Azerite Powder Shot (1st boss freehold)
                if bossID == 126832 and br.isCastingSpell(256106, "boss1") and unit.facing("boss1", "player") then
                    if cast.feint("player") then return true end
                end
                --Spit gold (1st boss KR)
                if bossID == 135322 and br.isCastingSpell(265773, "boss1") and br.GetUnitIsUnit("player", br._G.UnitTarget("boss1")) and ui.checked("Cloak Unavoidables") then
                    if cast.cloakOfShadows("player") then return true end
                end
                if br.UnitDebuffID("player",265773) and br.getDebuffRemain("player",265773) <= 2 then
                    if cast.feint("player") then return true end
                end
                --Static Shock (1st boss Temple)
                if (bossID == 133944 or br.GetObjectID("boss2") == 133944) and (br.isCastingSpell(263257, "boss1") or br.isCastingSpell(263257, "boss2")) then
                    if ui.checked("Cloak Unavoidables") then
                        if cast.cloakOfShadows("player") then return true end
                    end
                    if not buff.cloakOfShadows.exists() then
                        if cast.feint("player") then return true end
                    end
                end
                --Noxious Breath (2nd boss temple)
                if bossID == 133384 and br.isCastingSpell(263912, "boss1") and (select(5,br._G.UnitCastingInfo("boss1"))/1000-br._G.GetTime()) < 1.5 then
                    if cast.feint("player") then return true end
                end
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
                    if cd.kick.exists() and distance < 5 and ui.checked("Kidney/Cheap interrupt") and noStunList[br.GetObjectID(interrupt_target)] == nil and br.getBuffRemain(interrupt_target, 226510) == 0 then
                        if cast.able.cheapShot() and ui.value("Kidney/Cheap interrupt") ~= 1 then
                            if cast.cheapShot(interrupt_target) then return true end
                        elseif ui.value("Kidney/Cheap interrupt") ~= 2 then
                            if cast.kidneyShot(interrupt_target) then return true end
                        end
                    end
                    if ui.checked("Blind") and (cd.kick.exists() or distance >= 5) and noStunList[br.GetObjectID(interrupt_target)] == nil then
                        if cast.blind(interrupt_target) then return end
                    end
                end
                local interruptID, castStartTime
                if ui.checked("Stuns") and distance < 5 and br.player.cast.timeRemain(interrupt_target) < br.getTTD(interrupt_target) and br.isCrowdControlCandidates(interrupt_target)
                 and noStunList[br.GetObjectID(interrupt_target)] == nil and (not br.isBoss(interrupt_target) or stunList[interruptID]) and br.getBuffRemain(interrupt_target, 226510) == 0 then
                    if br._G.UnitCastingInfo(interrupt_target) then
                        castStartTime = select(4,br._G.UnitCastingInfo(interrupt_target))
                        interruptID = select(9,br._G.UnitCastingInfo(interrupt_target))
                    elseif br._G.UnitChannelInfo(interrupt_target) then
                        castStartTime = select(4,br._G.UnitChannelInfo(interrupt_target))
                        interruptID = select(7,br._G.GetSpellInfo(br._G.UnitChannelInfo(interrupt_target)))
                    end
                    if interruptID ~=nil and stunList[interruptID] and (br._G.GetTime()-(castStartTime/1000)) > 0.1 then
                        if cast.able.cheapShot() then
                            if cast.cheapShot(interrupt_target) then return true end
                        elseif combo > 0 and combo <= ui.value("Max CP For Stun") then
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
        if ui.checked("Precombat") and (pullTimer <= 1 or targetDistance < 10) and combo > 0 and buff.sliceAndDice.remain() < 6+(combo*3) then
            if cast.sliceAndDice("player") then return true end
        end
    end

    local function actionList_Cooldowns()
        -- Slice and dice for opener
        if enemies10 < 6 and combo >= 2 and not buff.sliceAndDice.exists("player") and (combatTime < 6 and cd.vanish.remain() < 118) then
            if cast.sliceAndDice("player") then return true end
        end
        -- # Rupture condition for opener with MA
        if talent.premeditation and br.isBoss() and not debuff.rupture.exists("target") and combo > 1 and (combatTime < 5 and cd.vanish.remain() < 118) then
            if cast.rupture("target") then return true end
        end
        -- Kyrian opener
        if sndCondition == 1 and buff.symbolsOfDeath.exists() and (combatTime < 4 and cd.vanish.remain() < 118) and cast.able.echoingReprimand() then
            if cast.echoingReprimand("target") then return true end
        end
        -- # Rupture for opener
        if not talent.premeditation and sndCondition == 1 and buff.symbolsOfDeath.exists() and (combatTime < 5 and cd.vanish.remain() < 118) and not debuff.rupture.exists("target") and combo > 1 then
            if cast.rupture("target") then return true end
        end
        -- Necro, Fae, Venthyr opener
        if sndCondition == 1 and not stealthedRogue and (not talent.premeditation or debuff.rupture.exists("target")) and (combatTime < 4 and cd.vanish.remain() < 118) then
            if covenant.necrolord.active and cast.able.serratedBoneSpike() and lastSpell ~= spell.serratedBoneSpike then
                if cast.serratedBoneSpike("target") then return true end
            elseif covenant.nightFae.active and cast.able.sepsis() then
                if cast.sepsis("target") then return true end
            elseif covenant.venthyr.active and cast.able.flagellation() then
                if cast.flagellation("target") then return true end
            end  
        end
        -- actions.cds=shadow_dance,use_off_gcd=1,if=!buff.shadow_dance.up&buff.shuriken_tornado.up&buff.shuriken_tornado.remains<=3.5
        if mode.sd == 1 and not buff.shadowDance.exists() and buff.shurikenTornado.exists() and buff.shurikenTornado.remain() <= 3.5 and ttd("target") > ui.value("CDs TTD Limit") then
            if cast.shadowDance("player") then return true end
        end
        -- actions.cds+=/symbols_of_death,use_off_gcd=1,if=buff.shuriken_tornado.up&buff.shuriken_tornado.remains<=3.5
        if mode.sod == 1 and sndCondition == 1 and (buff.shurikenTornado.exists() and buff.shurikenTornado.remain() <= 3.5 or not talent.shurikenTornado) and ttd("target") > ui.value("CDs TTD Limit") then
            if cast.symbolsOfDeath("player") then return true end
        end
        -- actions.cds+=/flagellation,target_if=max:target.time_to_die,if=variable.snd_condition&!stealthed.mantle&(cooldown.shadow_dance.up)&combo_points>=5&target.time_to_die>10
        if sndCondition == 1 and cast.able.flagellation("target") and not debuff.flagellation.exists("target") and cd.shadowDance.exists() and combo >= 5 and ttd("target") > 10 then
            if cast.flagellation("target") then return true end
        end
        -- actions.cds+=/vanish,if=(runeforge.mark_of_the_master_assassin&combo_points.deficit<=1-talent.deeper_strategem.enabled|runeforge.deathly_shadows&combo_points<1)&buff.symbols_of_death.up&buff.shadow_dance.up&master_assassin_remains=0&buff.deathly_shadows.down
        if mode.vanish == 1 and (runeforge.markOfTheMasterAssassin.equiped and comboDeficit <= (1 - dSEnabled) or runeforge.deathlyShadows.equiped and combo < 1) 
         and buff.symbolsOfDeath.exists() and buff.shadowDance.exists() and not buff.masterAssassinsMark.exists() and not buff.deathlyShadows.exists() then
            if cast.vanish("player") then return true end
        end
        -- actions.cds+=/shuriken_tornado,if=spell_targets.shuriken_storm<=1&energy>=60&variable.snd_condition&cooldown.symbols_of_death.up&cooldown.shadow_dance.charges>=1&(!runeforge.obedience|buff.flagellation_buff.up|spell_targets.shuriken_storm>=(1+4*(!talent.nightstalker.enabled&!talent.dark_shadow.enabled)))&combo_points<=2&!buff.premeditation.up&(!covenant.venthyr&!talent.flagellation|!cooldown.flagellation.up)
        if enemies10 <= 1 and energy >= 60 and sndCondition == 1 and not cd.symbolsOfDeath.exists() and charges.shadowDance.frac() >= 1 and (not runeforge.obedience.equiped or buff.flagellation.exists() or enemies10 >= (1 + 4 * (not nightstalkerActive and not darkShadowActive)))
         and combo <= 2 and not buff.premeditation.exists() and (not covenant.venthyr and not talent.flagellation or cd.flagellation.exists()) then
            if cast.shurikenTornado("player") then return true end
        end
        -- actions.cds+=/sepsis,if=variable.snd_condition&combo_points.deficit>=1&target.time_to_die>=16
        if cast.able.sepsis("target") and sndCondition == 1 and comboDeficit >= 1 and ttd("target") >= 16 then
            if cast.sepsis("target") then return true end
        end
        -- actions.cds+=/symbols_of_death,if=variable.snd_condition&(!stealthed.all|buff.perforated_veins.stack<4|spell_targets.shuriken_storm>4&!variable.use_priority_rotation)&(!talent.shuriken_tornado.enabled|talent.shadow_focus.enabled|spell_targets.shuriken_storm>=2|cooldown.shuriken_tornado.remains>2)&(!covenant.venthyr&!talent.flagellation|cooldown.flagellation.remains>10|cooldown.flagellation.up&combo_points>=5)
        if mode.sod == 1 and sndCondition == 1 and (not stealth or buff.perforatedVeins.stack() < 4 or enemies10 > 4 and not priorityRotation) 
         and (not talent.shurikenTornado or talent.shadowFocus or enemies10 >= 2 or cd.shurikenTornado.remain() > 2) and (not covenant.venthyr.active and not talent.flagellation or cd.flagellation.remain() > 10 or cd.flagellation.exists() and combo >= 5) then
            if cast.symbolsOfDeath("player") then return true end
        end
        -- # If adds are up, snipe the one with lowest TTD. Use when dying faster than CP deficit or not stealthed without any CP.
        -- actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit|!stealthed.all&combo_points.deficit>=cp_max_spend)
        if ui.value("MfD Target") == 1 then
            if #enemyTable30 > 1 and (enemyTable30.lowestTTD < comboDeficit or (not stealthedAll and comboDeficit >= comboMax)) then
                if cast.markedForDeath(enemyTable30.lowestTTDUnit) then return true end
            end
        else
            if #enemyTable30 > 1 and (ttd("target") < comboDeficit or (not stealthedAll and comboDeficit >= comboMax)) then
                if cast.markedForDeath("target") then return true end
            end
        end
        -- # If no adds will die within the next 30s, use MfD on boss without any CP and no stealth.
        -- actions.cds+=/marked_for_death,if=raid_event.adds.in>30-raid_event.adds.duration&combo_points.deficit>=cp_max_spend
        if #enemyTable30 == 1 and comboDeficit >= comboMax then
            if cast.markedForDeath("target") then return true end
        end
        -- actions.cds+=/shadow_blades,if=variable.snd_condition&combo_points.deficit>=2&(buff.symbols_of_death.up|fight_remains<=20)
        if cast.able.shadowBlades() and sndCondition == 1 and comboDeficit >= 2 and (buff.symbolsOfDeath.exists() or fightRemain <= 20) then
            if cast.shadowBlades("player") then return true end
        end
        -- actions.cds+=/echoing_reprimand,if=(!talent.shadow_focus.enabled|!stealthed.all|spell_targets.shuriken_storm>=4)&variable.snd_condition&combo_points.deficit>=2&(variable.use_priority_rotation|spell_targets.shuriken_storm<=4|runeforge.resounding_clarity|talent.resounding_clarity)
        if (not talent.shadowFocus or not stealthedAll or enemies10 >= 4) and sndCondition == 1 and comboDeficit >= 2 and (priorityRotation or enemies10 <= 4 or talent.resoundingClarity) then
            if cast.echoingReprimand("target") then return true end
        end
        -- # With SF, if not already done, use Tornado with SoD up.
        -- actions.cds+=/shuriken_tornado,if=(talent.shadow_focus.enabled|spell_targets.shuriken_storm>=2)&variable.snd_condition&buff.symbols_of_death.up&combo_points<=2&(!buff.premeditation.up|spell_targets.shuriken_storm>4)
        if talent.shadowFocus and sndCondition == 1 and buff.symbolsOfDeath.exists() and combo <= 2 and (not buff.premeditation.exists() or enemies10 > 4) then
            if cast.shurikenTornado("player") then return true end
        end
        -- actions.cds+=/shadow_dance,if=!buff.shadow_dance.up&fight_remains<=8+talent.subterfuge.enabled
        if mode.sd == 1 and cdUsage and not buff.shadowDance.exists() and fightRemain <= (8 + subterfugeActive) and ttd("target") > ui.value("CDs TTD Limit") then
            if cast.shadowDance("player") then return true end
        end
        -- actions.cds+=/thistle_tea,if=cooldown.symbols_of_death.remains>=3&!buff.thistle_tea.up&(energy.deficit>=100|cooldown.thistle_tea.charges_fractional>=2.75&energy.deficit>=40)
        if cdUsage and cd.symbolsOfDeath.remain() >= 3 and not buff.thistleTea.exists() and (energyDeficit >= 100 or charges.thistleTea.frac() >= 2.75 and energyDeficit >= 40) then
            if cast.thistleTea("player") then return true end
        end
        -- actions.cds+=/fleshcraft,if=(soulbind.pustule_eruption|soulbind.volatile_solvent)&energy.deficit>=30&!stealthed.all&buff.symbols_of_death.down
        -- if cdUsage and (soulbind.pustuleEruption or soulbind.volatileSolvent) and energyDeficit >= 30 and not stealthedAll and not buff.symbolsOfDeath.exists() then
        --     if cast.fleshcraft("player") then return true end
        -- end
        -- actions.cds+=/potion,if=buff.bloodlust.react|fight_remains<30|buff.symbols_of_death.up&(buff.shadow_blades.up|cooldown.shadow_blades.remains<=10)
        if cdUsage and ttd("target") > ui.value("CDs TTD Limit") and ui.checked("Potion") and (br.hasBloodLust() or (fightRemain < 30 and br.isBoss()) or (buff.shadowBlades.exists() or cd.shadowBlades.remain() <= 10)) then
            if ui.value("Potion") == 1 and br.canUseItem(171349) then
                br.useItem(171349)
            elseif ui.value("Potion") == 2 and br.canUseItem(171352) then
                br.useItem(171352)
            elseif ui.value("Potion") == 3 and br.canUseItem(171270) then
                br.useItem(171270)
            end
        end
        -- actions.cds+=/use_items,if=buff.symbols_of_death.up|fight_remains<20
        if trinket_Pop() then return true end
    end

    local function actionList_Finishers()
        if not animachargedCP then
            -- # While using Premeditation, avoid casting Slice and Dice when Shadow Dance is soon to be used, except for Kyrian
            -- actions.finish=variable,name=premed_snd_condition,value=talent.premeditation.enabled&spell_targets.shuriken_storm<(5-covenant.necrolord)&!covenant.kyrian
            local premedSndCondition = (talent.premeditation and enemies10 < (5 - necroActive) and not covenant.kyrian.active) or false
            -- actions.finish+=/slice_and_dice,if=!variable.premed_snd_condition&spell_targets.shuriken_storm<6&!buff.shadow_dance.up&buff.slice_and_dice.remains<fight_remains&refreshable
            if not premedSndCondition and enemies10 < 6 and not buff.shadowDance.exists() and buff.sliceAndDice.remain() < fightRemain and buff.sliceAndDice.refresh() then
                if cast.sliceAndDice("player") then return true end
            end
            -- actions.finish+=/slice_and_dice,if=variable.premed_snd_condition&cooldown.shadow_dance.charges_fractional<1.75&buff.slice_and_dice.remains<cooldown.symbols_of_death.remains&(cooldown.shadow_dance.ready&buff.symbols_of_death.remains-buff.shadow_dance.remains<1.2)
            if premedSndCondition and charges.shadowDance.frac() < 1.75 and buff.sliceAndDice.remain() < cd.symbolsOfDeath.remain() and (not cd.shadowDance.exists() and buff.symbolsOfDeath.remain() - buff.shadowDance.remain() < 1.2) then
                if cast.sliceAndDice("player") then return true end
            end
        end
        -- # Helper Variable for Rupture. Skip during Master Assassin or during Dance with Dark and no Nightstalker.
        -- actions.finish+=/variable,name=skip_rupture,value=master_assassin_remains>0
        local skipRupture = ttd("target") == 999 or not br.isBoss() or buff.masterAssassinsMark.exists() or false
        -- # Keep up Rupture if it is about to run out. Don't ruptre if they die faster than debuff.
        -- actions.finish+=/rupture,if=(!variable.skip_rupture|variable.use_priority_rotation)&target.time_to_die-remains>6&refreshable
        if (not skipRupture or priorityRotation) and ttd("target") >= (5 + 2 * combo) and debuff.rupture.refresh("target") and shallWeDot("target") then
            if cast.rupture("target") then return true end
        end
        -- actions.finish+=/secret_technique
        if talent.secretTechnique and mode.st == 1 then
            if cast.secretTechnique("target") then return true end
        end
        -- # Multidotting targets that will live for the duration of Rupture, refresh during pandemic.
        -- actions.finish+=/rupture,cycle_targets=1,if=!variable.skip_rupture&!variable.use_priority_rotation&spell_targets.shuriken_storm>=2&target.time_to_die>=(2*combo_points)&refreshable
        if not skipRupture and not priorityRotation and enemies10 >= 2 and br.getSpellCD(spell.rupture) == 0 and ruptureCount < ui.value("Multidot Limit") then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if ttd(thisUnit) >= (2 * combo) and debuff.rupture.refresh(thisUnit) and shallWeDot(thisUnit) and unit.facing("player",thisUnit) then
                    if cast.rupture(thisUnit) then return true end
                end
            end
        end
        -- # Refresh Rupture early if it will expire during Symbols. Do that refresh if SoD gets ready in the next 5s.
        -- actions.finish+=/rupture,if=!variable.skip_rupture&remains<cooldown.symbols_of_death.remains+10&cooldown.symbols_of_death.remains<=5&target.time_to_die-remains>cooldown.symbols_of_death.remains+5
        if not skipRupture and ruptureRemain < cd.symbolsOfDeath.remain() + 10 and cd.symbolsOfDeath.remain() <= 5 and shallWeDot("target") and ttd("target") - ruptureRemain > cd.symbolsOfDeath.remain() + 5 then
            if cast.rupture(thisUnit) then return true end
        end
        local skipPowder = (br.getUnitID("target") == 166969 or br.getUnitID("target") == 175992) or false
        -- actions.finish+=/black_powder,if=!variable.use_priority_rotation&spell_targets>=3
        if not priorityRotation and enemies10 >= 3 and cast.able.blackPowder() and not skipPowder then
            if cast.blackPowder("target") then return true end
        end
        -- actions.finish+=/eviscerate
        if cast.eviscerate("target") then return true end
    end

    local function actionList_StealthCD()
        -- # Helper Variable
        -- actions.stealth_cds=variable,name=shd_threshold,value=cooldown.shadow_dance.charges_fractional>=1.75
        local shdThreshold = false
        if charges.shadowDance.frac() >= 1.75 then shdThreshold = true else shdThreshold = false end
        -- actions.stealth_cds=variable,name=shd_threshold,if=runeforge.the_rotten|talent.the_rotten,value=cooldown.shadow_dance.charges_fractional>=1.75|cooldown.symbols_of_death.remains>=16
        if runeforge.theRotten or talent.theRotten then
            if charges.shadowDance.frac() >= 1.75 or cd.symbolsOfDeath.remain() >= 16 then shdThreshold = true else shdThreshold = false end
        end
        -- # Vanish if we are capping on Dance charges. Early before first dance if we have no Nightstalker but Dark Shadow in order to get Rupture up (no Master Assassin).
        -- actions.stealth_cds+=/vanish,if=(!variable.shd_threshold|!talent.nightstalker.enabled&talent.dark_shadow.enabled)&combo_points.deficit>1&!runeforge.mark_of_the_master_assassin.equipped
        if cdUsage and mode.vanish == 1 and (not shdThreshold or not talent.nightstalker and talent.darkShadow) and comboDeficit > 1 and targetDistance < 5 and combatTime > 16 
         and ttd("target") > ui.value("CDs TTD Limit") then
            if cast.vanish("player") then return true end
        end
        -- # Pool for Shadowmeld + Shadowstrike unless we are about to cap on Dance charges. Only when Find Weakness is about to run out.
        -- actions.stealth_cds+=/pool_resource,for_nextement: Dance only before finishers i=1,extra_amount=40,if=race.night_elf
        -- actions.stealth_cds+=/shadowmeld,if=energy>=40&energy.deficit>=10&!variable.shd_threshold&combo_points.deficit>1
        if cdUsage and ui.checked("Racial") and race == "NightElf" and not cast.last.vanish() and not buff.vanish.exists() then
            if (cast.pool.racial() or cast.able.racial()) and energy >= 40 and energyDeficit >= 10 and not shdThreshold and comboDeficit > 1 then
                if cast.pool.racial() then return true end
                if cast.able.racial() then
                    if cast.racial("player") then return true end
                end
            end
        end
        -- # CP requirement: Dance at low CP by default.
        -- actions.stealth_cds+=/variable,name=shd_combo_points,value=combo_points.deficit>=2+buff.shadow_blades.up
        -- actions.stealth_cds+=/variable,name=shd_combo_points,value=combo_points.deficit>=3,if=covenant.kyrian
        -- actions.stealth_cds+=/variable,name=shd_combo_points,value=combo_points.deficit<=1,if=variable.use_priority_rotation&spell_targets.shuriken_storm>=4
        -- actions.stealth_cds+=/variable,name=shd_combo_points,value=combo_points.deficit<=1,if=spell_targets.shuriken_storm=4
        local shdComboPoints, shadowBladesUp
        if buff.shadowBlades.exists() then shadowBladesUp = 1 else shadowBladesUp = 0 end
        if (comboDeficit >= (2 + shadowBladesUp)) or (comboDeficit >= 3 and covenant.kyrian.active) or (comboDeficit <= 1 and priorityRotation and enemies10 >= 4) then shdComboPoints = 1 else shdComboPoints = 0 end
        if (comboDeficit <= 1 and enemies10 == 4) then shdComboPoints = 1 else shdComboPoints = 0 end
        -- actions.stealth_cds+=/shadow_dance,if=(variable.shd_combo_points&(variable.shd_threshold|buff.symbols_of_death.remains>=(2.2-talent.flagellation.enabled))|buff.flagellation.up|buff.flagellation_persist.remains>=6|spell_targets.shuriken_storm>=4&cooldown.symbols_of_death.remains>10)&(buff.perforated_veins.stack<4|spell_targets.shuriken_storm>3)&!cooldown.flagellation.up
        if mode.sd == 1 and (ttd(enemyTable30.highestTTDUnit) > 8 or enemies10 > 3 or charges.shadowDance.frac() >= 1.75) and ((ui.checked("Save SD Charges for CDs") and buff.symbolsOfDeath.remain() >= 1.2 or buff.shadowBlades.remain() > 5 or charges.shadowDance.frac() >= (ui.value("Save SD Charges for CDs") + 1)) or (combatTime < 12 and cd.vanish.remain() < 108) or not ui.checked("Save SD Charges for CDs"))
         and shdComboPoints and (shdThreshold or buff.symbolsOfDeath.remain() >= (2.2 - flagellationActive) or buff.flagellation.exists("target") or enemies10 >= 4 and cd.symbolsOfDeath.remain() > 10) and (buff.perforatedVeins.stack() < 4 or enemies10 > 3) and not cd.flagellation.exists()
         and (not cast.last.vanish(1) or cast.last.shadowstrike(1)) and gcd < 0.5 and (not covenant.kyrian.active or cd.echoingReprimand.exists()) and (not covenant.necrolord.active or charges.serratedBoneSpike.frac() < 3) then
            if cast.shadowDance("player") then return true end
        end
        -- Burn remaining Dances before the fight ends if SoD won't be ready in time.
        -- actions.stealth_cds+=/shadow_dance,if=variable.shd_combo_points&fight_remains<cooldown.symbols_of_death.remains
        if mode.sd == 1 and cdUsage and shdComboPoints and fightRemain < cd.symbolsOfDeath.remain() then
            if cast.shadowDance("player") then return true end
        end
    end

    local function actionList_Stealthed()
        -- Cold Blood when off cooldown
        if cast.able.coldBlood() then
            if cast.coldBlood("target") then return true end
        end
        -- Extra echoing reprimand while in SD window
        if sndCondition == 1 and comboDeficit >= 2 and (priorityRotation or enemies10 <= 4) and cast.able.echoingReprimand() then
            if cast.echoingReprimand("target") then return true end
        end
        -- # If Stealth/vanish are up, use Shadowstrike to benefit from the passive bonus and Find Weakness, even if we are at max CP (unless using Master Assassin)
        -- actions.stealthed=shadowstrike,if=(buff.stealth.up|buff.vanish.up)&master_assassin_remains=0
        if (stealth or buff.vanish.exists() or buff.shadowmeld.exists()) and targetDistance < 5 and not buff.masterAssassinsMark.exists() then
            if cast.shadowstrike("target") then return true end
        end
        -- # Finish at 3+ CP without DS / 4+ with DS with Shuriken Tornado buff up to avoid some CP waste situations.
        -- actions.stealthed+=/call_action_list,name=finish,if=buff.shuriken_tornado.up&combo_points.deficit<=2
        -- # Also safe to finish at 4+ CP with exactly 4 targets. (Same as outside stealth.)
        -- actions.stealthed+=/call_action_list,name=finish,if=spell_targets.shuriken_storm>=4&combo_points>=4
        -- # Finish at 4+ CP without DS, 5+ with DS, and 6 with DS after Vanish
        -- actions.stealthed+=/call_action_list,name=finish,if=combo_points.deficit<=1-(talent.deeper_stratagem.enabled&buff.vanish.up)
        local finishThd = 0
        if dSEnabled and (buff.vanish.exists() or cast.last.vanish(1)) then finishThd = 1 else finishThd = 0 end
        if (buff.shurikenTornado.exists() and comboDeficit <= 2) or (enemies10 >= 4 and combo >= 4) or (comboDeficit <= (1 - finishThd)) then
            if actionList_Finishers() then return true end
        end
        -- # For pre-patch, keep Find Weakness up on the primary target due to no Shadow Vault
        -- actions.stealthed+=/shadowstrike,if=level<52&debuff.find_weakness.remains<1&target.time_to_die-remains>6
        if level < 52 and debuff.findWeakness.remain("target") < 1 and ttd("target") > 6 then
            if cast.shadowstrike("target") then return true end
        end
        -- # Up to 3 targets (no prio) keep up Find Weakness by cycling Shadowstrike.
        -- actions.stealthed+=/shadowstrike,cycle_targets=1,if=!variable.use_priority_rotation&debuff.find_weakness.remains<1&spell_targets.shuriken_storm<=3&target.time_to_die-remains>6
        if enemies10 <= 3 and not priorityRotation and ui.checked("Spread Find Weakness") then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if debuff.findWeakness.remain(thisUnit) < 1 and ttd(thisUnit) > 6 then
                    if cast.shadowstrike(thisUnit) then return true end
                end
            end
        end
        -- # For priority rotation, use Shadowstrike over Storm 1) with WM against up to 4 targets, 2) if FW is running off (on any amount of targets), or 3) to maximize SoD extension with Inevitability on 3 targets (4 with BitS).
        -- actions.stealthed+=/shadowstrike,if=variable.use_priority_rotation&(debuff.find_weakness.remains<1|talent.weaponmaster.enabled&spell_targets.shuriken_storm<=4)
        if priorityRotation and (debuff.findWeakness.remain("target") < 1 or talent.weaponmaster and enemies10 <= 4) and targetDistance < 5 then
            if cast.shadowstrike("target") then return true end
        end
        -- actions.stealthed+=/shuriken_storm,if=spell_targets>=3+(buff.the_rotten.up|runeforge.akaaris_soul_fragment&conduit.deeper_daggers.rank>=7)&(buff.symbols_of_death_autocrit.up|!buff.premeditation.up|spell_targets>=5)
        local stealthedsStorm = 0
        if (buff.theRotten.exists() or runeforge.akaarisSoulFragment.equiped and conduit.deeperDaggers.rank >= 7) and (buff.symbolsOfDeathCrit.exists() or not buff.premeditation.exists() or enemies10 >=5) then stealthedsStorm = 1 else stealthedsStorm = 0 end
        if enemies10 >= 3 + stealthedsStorm then
            if cast.shurikenStorm("player") then return true end
        end
        -- # Shadowstrike to refresh Find Weakness and to ensure we can carry over a full FW into the next SoD if possible.
        -- actions.stealthed+=/shadowstrike,if=debuff.find_weakness.remains<=1|cooldown.symbols_of_death.remains<18&debuff.find_weakness.remains<cooldown.symbols_of_death.remains
        if debuff.findWeakness.remain("target") <= 1 or cd.symbolsOfDeath.remain() < 1 and debuff.findWeakness.remain("target") < cd.symbolsOfDeath.remain() then
            if cast.shadowstrike("target") then return true end
        end
        -- gloomblade
        if cast.able.gloomblade() and talent.gloomblade then
            if cast.gloomblade("target") then return end
        end
        -- -- actions.stealthed+=/gloomblade,if=buff.perforated_veins.stack>=5&conduit.perforated_veins.rank>=13
        if buff.perforatedVeins.stack() >= 5 and conduit.perforatedVeins.rank >= 13 then
            if cast.gloomblade("target") then return true end
        end
        -- -- actions.stealthed+=/gloomblade,if=runeforge.akaaris_soul_fragment.equipped&buff.perforated_veins.stack>=3&(conduit.perforated_veins.rank+conduit.deeper_dagger.rank)>=16
        if runeforge.akaarisSoulFragment.equiped and buff.perforatedVeins.stack() >= 3 and (conduit.perforatedVeins.rank + conduit.deeperDaggers.rank) >= 16 then
            if cast.gloomblade("target") then return true end
        end
        -- actions.stealthed+=/shadowstrike
        if cast.able.shadowstrike() then
            if cast.shadowstrike("target") then return true end
        end
        -- actions.stealthed+=/cheap_shot,if=!target.is_boss&combo_points.deficit>=1&buff.shot_in_the_dark.up&energy.time_to_40>gcd.max
        if cast.able.cheapShot() and br.isBoss() and comboDeficit >= 1 and buff.shotInTheDark.exists() and br.getTimeToMax("player", 40) > gcdMax then
            if cast.cheapShot("target") then return true end
        end
    end

    --Builders
    local function actionList_Builders()
        -- actions.build=shiv,if=!talent.nightstalker.enabled&runeforge.tiny_toxic_blade&spell_targets.shuriken_storm<5
        if cast.able.shiv() and not talent.nightstalker and runeforge.tinyToxicBlade.equiped and enemies10 < 5 then
            if cast.shiv("target") then return true end
        end
        -- actions.build+=/shuriken_storm,if=spell_targets>=2&(!covenant.necrolord|cooldown.serrated_bone_spike.max_charges-charges_fractional>=0.25|spell_targets.shuriken_storm>4)&(buff.perforated_veins.stack<=4|spell_targets.shuriken_storm>4&!variable.use_priority_rotation)
        if enemies10 >= 2 and (buff.perforatedVeins.stack() <= 4 or enemies10 > 4 and not priorityRotation) then
            if cast.shurikenStorm("player") then return true end
        end
        -- actions.build+=/gloomblade
        if talent.gloomblade then
            if cast.gloomblade("target") then return true end
        end
        -- Sinister Strike
        if level < 14 then
            if cast.sinisterStrike("target") then return true end
        end
        -- Failsafe for shadowstrike, prevents backstab after SD
        if cast.able.shadowstrike() then
            if cast.shadowstrike("target") then return true end
        end
        -- actions.build+=/backstab
        if (not cast.last.vanish(1) or cast.last.shadowstrike(1)) and not buff.shadowDance.exists() and (not buff.symbolsOfDeath.exists() or charges.shadowDance.frac() < 1 or mode.sd == 2) then
            if cast.backstab("target") then return true end
        end
        -- Use Shuriken Toss if we can't reach the target
        if ui.checked("Shuriken Toss out of range") and not stealthedRogue and #enemyTable5 == 0 and energy >= ui.value("Shuriken Toss out of range") and inCombat then
            if cast.shurikenToss("target") then return true end
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
        if (inCombat or (not ui.checked("Disable Auto Combat") and (cast.last.vanish(1) or (validTarget and targetDistance < 5)))) then
            if cast.last.vanish(1) and mode.vanish == 2 then br._G.StopAttack() end
            if mode.defensive == 1 then
                if actionList_Defensive() then return true end
            end
            if mode.interrupt == 1 then
                if actionList_Interrupts() then return true end
            end
            --pre mfd
            if stealth and validTarget and comboDeficit > 2 and talent.markedForDeath and targetDistance < 10 then
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
            -- # Run fully switches to the Stealthed Rotation (by doing so, it forces pooling if nothing is available).
            -- actions+=/run_action_list,name=stealthed,if=stealthed.all
            if stealthedAll then
                if animachargedCP then
                    if actionList_Finishers() then return true end
                end
                if actionList_Stealthed() then return true end
            end
            --start aa
            if not stealthedRogue and validTarget and targetDistance < 5 and not br._G.IsCurrentSpell(6603) then
                br._G.StartAttack("target")
            end
            -- OG Opener
            if cdUsage and ui.checked("Opener") and combatTime < 2 and cd.vanish.remain() < 115 and sndCondition == 1 and gcd < (0.1 + br.getLatency()) and br.isBoss() 
             and (not covenant.necrolord.active or charges.serratedBoneSpike.frac() < 2.75) then
                cast.shadowBlades("player")
                cast.symbolsOfDeath("player")
                if ui.checked("Trinkets") then
                    br.useItem(179350)
                end
                if not covenant.kyrian.active then
                    cast.shadowDance("player")
                end
                if race == "Orc" or race == "Troll" or race == "MagharOrc" then
                    cast.racial("player")
                end
                return true
            end
            if br.isBoss() and buff.shadowBlades.exists() and buff.shadowDance.exists() then
                if trinket_Pop() then return true end
            end
            if validTarget and (combatTime >= 1.5 or cd.vanish.remain() > 118.5 or sndCondition == 1) then
                if gcd < br.getLatency() then
                    -- # Check CDs at first
                    -- actions+=/call_action_list,name=cds
                    if targetDistance < 5 then
                        if actionList_Cooldowns() then return true end
                    end
                    -- # Apply Slice and Dice at 2+ CP during the first 10 seconds, after that 4+ CP if it expires within the next GCD or is not up
                    -- actions+=/slice_and_dice, if=spell_targets.shuriken_storm<6&fight_remains>6&buff.slice_and_dice.remains<gcd.max&combo_points>=4-(time<10)*2
                    local cTime = 0
                    if (combatTime < 10 and not cd.vanish.exists()) then 
                        cTime = 1
                    end
                    if enemies10 < 6 and fightRemain > 6 and buff.sliceAndDice.remain() < gcdMax and combo >= 4-(cTime*2) and buff.sliceAndDice.remain() < 6+(combo*3) then
                        if cast.sliceAndDice("player") then return true end
                    end
                end
                -- # Priority Rotation? Let's give a crap about energy for the stealth CDs (builder still respect it). Yup, it can be that simple.
                -- actions+=/call_action_list,name=stealth_cds,if=variable.use_priority_rotation
                if priorityRotation and validTarget and not stealthedAll and targetDistance < 5 then
                    --br._G.print("Valid target: " .. (validTarget and 'true' or 'false'))
                    if actionList_StealthCD() then return true end
                end
                -- # Used to define when to use stealth CDs or builders
                -- actions+=/variable,name=stealth_threshold,value=25+talent.vigor.enabled*20+talent.master_of_shadows.enabled*20+talent.shadow_focus.enabled*25+talent.alacrity.enabled*20+25*(spell_targets.shuriken_storm>=4)
                local stealthThd = 25 + vEnabled * 20 + mosEnabled * 20 + sfEnabled * 25 + aEnabled * 20 + 25 * ssThd
                -- # Consider using a Stealth CD when reaching the energy threshold
                -- actions+=/call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold
                if energyDeficit <= stealthThd and validTarget and not stealthedAll and targetDistance < 5 then
                    if actionList_StealthCD() then return true end
                end
                -- actions+=/call_action_list,name=finish,if=variable.effective_combo_points>=cp_max_spend
                if animachargedCP then
                    if actionList_Finishers() then return true end
                end
                if gcd < br.getLatency() then             
                    -- # Finish at 4+ without DS or with SoD crit buff, 5+ with DS (outside stealth)
                    -- actions+=/call_action_list,name=finish,if=combo_points.deficit<=1|fight_remains<=1&variable.effective_combo_points>=3
                    if comboDeficit <= 1 or (fightRemain <= 1 and combo >= 3) then
                        if actionList_Finishers() then return true end
                    end
                    -- # With DS also finish at 4+ against 4 targets (outside stealth)
                    -- actions+=/call_action_list,name=finish,if=spell_targets.shuriken_storm>=4&variable.effective_combo_points>=4
                    if enemies10 >= 4 and combo >= 4 then
                        if actionList_Finishers() then return true end
                    end
                    -- # Use a builder when reaching the energy threshold
                    -- actions+=/call_action_list,name=build,if=energy.deficit<=variable.stealth_threshold
                    if energyDeficit <= stealthThd then
                        if actionList_Builders() then return true end
                    end
                end
                -- # Lowest priority in all of the APL because it causes a GCD
                -- actions+=/arcane_torrent,if=energy.deficit>=15+energy.regen
                -- actions+=/arcane_pulse
                -- actions+=/lights_judgment
                -- actions+=/bag_of_tricks
                if cdUsage and ui.checked("Racial") and targetDistance < 5 then
                    if race == "BloodElf" and energyDeficit >= (15 + energyRegen) then
                        if cast.racial("player") then return true end
                    elseif race == "Nightborne" then
                        if cast.racial("player") then return true end
                    elseif race == "LightforgedDraenei" then
                        if cast.racial("target","ground") then return true end
                    end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation 
local id = 261 --Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
