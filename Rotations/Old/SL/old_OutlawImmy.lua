local rotationName = "immy1 "
local br = br
br.rogueTables = {}
local rogueTables = br.rogueTables
rogueTables.enemyTable5, rogueTables.enemyTable15, rogueTables.enemyTable20, rogueTables.burnTable20, rogueTables.burnTable5 = {}, {}, {}, {}, {}
local enemyTable5, enemyTable15, enemyTable20, burnTable20, burnTable5 = rogueTables.enemyTable5, rogueTables.enemyTable15, rogueTables.enemyTable20, rogueTables.burnTable20, rogueTables.burnTable5
local forcekill = {
            [120651]=true, -- Explosive
            [136330]=true, -- Soul Thorns Waycrest Manor
            [134388]=true -- A Knot of Snakes ToS
            }

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.dispatch},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.crimsonVial}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.adrenalineRush },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.adrenalineRush },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.adrenalineRush }
     };
    CreateButton("Cooldown",2,0)
-- Blade Flurry Button
    BladeFlurryModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.bladeFlurry},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.bladeFlurry}
    };
    CreateButton("BladeFlurry",3,0)
    NoBTEModes = {
        [1] = { mode = "best", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.betweenTheEyes},
        [2] = { mode = "target", value = 2 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.betweenTheEyes},
        [3] = { mode = "off", value = 3 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.betweenTheEyes}
    };
    CreateButton("NoBTE",3,1)    
-- Defensive Button
    SpecialModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.adrenalineRush},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.adrenalineRush},
    };
    CreateButton("Special",5,0)
    TiersevenModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.bladeRush},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.bladeRush},
    };
    CreateButton("Tierseven",5,1)    
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.kick},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.kick}
    };
    CreateButton("Interrupt",4,0)
        StunModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.gouge},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.gouge}
    };
    CreateButton("Stun",4,1)
    MFDModes = {
        [1] = { mode = "Tar", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.markedForDeath},
        [2] = { mode = "Adds", value = 2 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.markedForDeath},
        [3] = { mode = "reset", value = 3 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.markedForDeath},
        [4] = { mode = "Off", value = 4 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.markedForDeath}
    };
    CreateButton("MFD",6,0)
    RollforoneModes = {
        [1] = { mode = "any", value = 1 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.rollTheBones},
        [2] = { mode = "simc", value = 2 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.rollTheBones}
    };
    CreateButton("Rollforone",6,1)
    EssenceModes = {
        [1] = { mode = "Off", value = 1 , overlay = "Essence disabled", tip = "Won't use essence", highlight = 0, icon = br.player.spell.bloodOfTheEnemy},
        [2] = { mode = "On", value = 2 , overlay = "Essence enabled", tip = "Will use essence", highlight = 1, icon = br.player.spell.bloodOfTheEnemy},
    };
    CreateButton("Essence",7,0)  
end

forpro = false



---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- br.ui:createCheckbox(section, "Opener")
            -- br.ui:createCheckbox(section, "RTB Prepull")
            br.ui:createDropdown(section, "Stealth", {"|cff00FF00Always", "|cffFF000020Yards"},  2, "Stealthing method.")
            br.ui:createCheckbox(section, "Drawings", "Enable drawing on screen")

        br.ui:checkSectionState(section)
        ------------------------
        --- OFFENSIVE OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Offensive")
            br.ui:createCheckbox(section, "Trinkets")
            br.ui:createCheckbox(section, "AdrenalineRush", "|cffFFFFFF Will use Adrenaline Rush")
            br.ui:createCheckbox(section, "Vanish")
            br.ui:createCheckbox(section, "Racial")
            br.ui:createSpinnerWithout(section, "BF HP Limit", 15, 0, 105, 1, "|cffFFFFFFHP *10k hp for Blade FLurry to be used")
            -- Cooldowns Time To Die Limit
            br.ui:createSpinnerWithout(section,  "BF Time To Die Limit",  30,  0,  40,  1,  "|cffFFFFFFTarget Time to die limit for using cooldowns (in sec).")
            br.ui:createSpinner(section, "Pistol Shot out of range", 85,  5,  100,  5,  "|cffFFFFFFCheck to use Pistol Shot out of range and energy to use at.")
            -- br.ui:createSpinnerWithout(section, "MFD Sniping",  1,  0.5,  3,  0.1,  "|cffFFBB00Increase to have BR cast MFD on dying units quicker, too high might cause suboptimal casts")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Special")
            br.ui:createCheckbox(section, "AutoBtE", "|cffFFFFFF Auto BtE dangerous casts")
            br.ui:createCheckbox(section, "AutoGouge", "|cffFFFFFF Auto Gouge dangerous casts")
            br.ui:createCheckbox(section, "AutoBlind", "|cffFFFFFF Auto Blind dangerous casts")
            br.ui:createCheckbox(section, "AutoKick", "|cffFFFFFF Auto Kick dangerous casts")
            br.ui:createCheckbox(section, "Any Cast", "|cffFFFFFF Auto CC any cast")
            br.ui:createCheckbox(section, "|cffFF0000Force Burn Stuff", "Ghuunies/explosives orb = rip or hold shift")
            br.ui:createCheckbox(section, "DontWasteDeadShotOnOrbs")
            br.ui:createCheckbox(section, "|cffFFBB00Encounter Logic", "Use PvE Logic")
            br.ui:createCheckbox(section, "Ambush Opener", "Will use ambush as soon as target is in range")
            br.ui:createCheckbox(section, "PickPocket", "Will PickPocket before ambush ^^ for tmog")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Essences")
            br.ui:createCheckbox(section, "BotE", "Blood of the Enemy")
            br.ui:createCheckbox(section, "CLF", "Condensed Life-Force")
            br.ui:createDropdownWithout(section, "Use Concentrated Flame", {"DPS", "Heal", "Hybrid", "Never"}, 1)
            br.ui:createSpinnerWithout(section, "Concentrated Flame Heal", 70, 10, 90, 5)
            br.ui:createCheckbox(section, "CoS", "Strife Stack ooc with detection")
        br.ui:checkSectionState(section)

        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Kick
            br.ui:createCheckbox(section, "Kick")
            -- Gouge
            br.ui:createCheckbox(section, "Gouge")
            -- Blind
            br.ui:createCheckbox(section, "Blind")
            -- Between the Eyes
            br.ui:createCheckbox(section, "Between the Eyes")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  0,  0,  100,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)

        ------------------------
        --- CORRUPTION 8.3 -----
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Corruption")
            br.ui:createSpinnerWithout(section, "Corruption Immunity", 75, 0, 100, 5, "Health Percentage to use corruption immunities.")
            br.ui:createDropdown(section, "Use Cloak", { "Snare", "Eye", "THING", "Never" }, 4, "", "")
            br.ui:createDropdown(section, "Cloak of Shadows Corruption", { "Snare", "Eye", "THING", "Never" }, 4, "", "")
            br.ui:createCheckbox(section, "Vanish THING", "|cffFFFFFF Will use Vanish when Thing from beyond spawns")
            br.ui:createCheckbox(section, "Shadowmeld THING", "|cffFFFFFF Will use shadowmeld when Thing from beyond spawns")
            br.ui:createCheckbox(section, "Blind THING", "|cffFFFFFF Will use blind on Thing from beyond")
        br.ui:checkSectionState(section)

        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createDropdown(section, "Auto Tricks", {"|cff00FF00Focus", "|cffFF0000Tank"},  1, "Tricks of the Trade target." )
        br.ui:createSpinner(section, "Healing Potion/Healthstone", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinner(section, "Crimson Vial", 10, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinner(section, "Feint", 10, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinner(section, "Riposte", 10, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinner(section, "Engineer's Belt", 10, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)

        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Cleave Toggle
            br.ui:createDropdown(section,  "BladeFlurry Mode", br.dropOptions.Toggle,  6)
            br.ui:createDropdown(section,  "MFD Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
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
    local profile = br.debug.cpu.rotation.profile
    local startTime = debugprofilestop()

    -- WriteFile("countvisible.txt", countvisible .. "\n", true)
    -- print(countvisible)
    -- countvisible = 0

        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("BladeFlurry",0.25)
        br.player.ui.mode.bladeflurry = br.data.settings[br.selectedSpec].toggles["BladeFlurry"]
        br.player.ui.mode.stun = br.data.settings[br.selectedSpec].toggles["Stun"]
        br.player.ui.mode.mfd = br.data.settings[br.selectedSpec].toggles["MFD"]
        br.player.ui.mode.rollforone = br.data.settings[br.selectedSpec].toggles["Rollforone"]
        br.player.ui.mode.special = br.data.settings[br.selectedSpec].toggles["Special"]
        br.player.ui.mode.tierseven = br.data.settings[br.selectedSpec].toggles["Tierseven"]
        br.player.ui.mode.nobte = br.data.settings[br.selectedSpec].toggles["NoBTE"]
        br.player.ui.mode.essence = br.data.settings[br.selectedSpec].toggles["Essence"]
--------------
--- Locals ---
--------------
        -- print(br.DBM:getTimer(13892))
        -- print(IsItemInRange(44915)) --20
        -- print(tostring(br.BossMods:getPulltimer()))
        ---------------------------------------------------------
        if profileStop == nil then profileStop = false end
        local attacktar                                     = UnitCanAttack("target","player")
        local charges                                       = br.player.charges
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local cd                                            = br.player.cd
        local combo, comboDeficit, comboMax                 = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
        local debuff                                        = br.player.debuff
        local essence                                       = br.player.essence
        -- local pullTimer                                     = br.BossMods:getPulltimer()
        local enemies                                       = br.player.enemies
        local gcd                                           = getSpellCD(61304)
        local gcdMax                                        = br.player.gcdMax
        local hastar                                        = GetObjectExists("target")
        local has                                           = br.player.has
        local healPot                                       = getHealthPot()
        local inCombat                                      = isInCombat("player")
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local mode                                          = br.player.ui.mode
        local php                                           = br.player.health
        local power, powerDeficit, powerRegen               = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local solo                                          = #br.friend < 2
        local spell                                         = br.player.spell
        local stealth                                       = br.player.buff.stealth.exists()
        local stealthingAll                                 = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowmeld.exists()
        local stealthingRogue                               = br.player.buff.stealth.exists() or br.player.buff.vanish.exists()
        local talent                                        = br.player.talent
        local traits                                        = br.player.traits
        local ttm                                           = br.player.power.energy.ttm()
        local ttdd                                          = getTTD
        local units                                         = br.player.units
        local use                                           = br.player.use
        local lootDelay                                     = getOptionValue("LootDelay")
        local drawing                                       = isChecked("Drawings")
        -- ToggleToValue("BladeFlurry", 1)
        -- print(1)

    
    
    -- print(checkDR(199804,"target"))
    -- print(UnitClassification("target"))
    if not UnitAffectingCombat("player") then
        if not talent.markedForDeath then
            if mode.mfd ~= 4 then ToggleToValue("MFD", 4) end -- turn MFD off
            if buttonMFD:IsShown() then buttonMFD:Hide() end
        else
            if not buttonMFD:IsShown() then buttonMFD:Show() end
        end
        if not talent.killingSpree and not talent.bladeRush then
            if mode.tierseven ~= 2 then ToggleToValue("Tierseven", 2) end -- turn Tierseven off
            if buttonTierseven:IsShown() then buttonTierseven:Hide() end
        else
            if not buttonTierseven:IsShown() then buttonTierseven:Show() end
        end
    end

    local spread = false
    if GetKeyState(0x10) then
      spread = true
    end

    --Tricks from sir fisker
    local tricksUnit
    if isChecked("Auto Tricks") and GetSpellCooldown(spell.tricksOfTheTrade) == 0 and inCombat then
        if getOptionValue("Auto Tricks") == 1 and GetUnitIsFriend("player", "focus") and getLineOfSight("player", "focus") then
            tricksUnit = "focus"
        elseif getOptionValue("Auto Tricks") == 2 then
            for i = 1, #br.friend do
                local thisUnit = br.friend[i].unit
                if UnitGroupRolesAssigned(thisUnit) == "TANK" and not UnitIsDeadOrGhost(thisUnit) and getLineOfSight("player", thisUnit) then
                    tricksUnit = thisUnit
                    break
                end
            end
        end
    end

        dotHPLimit = getOptionValue("BF HP Limit") * 10000

        

        
--______________________________________
    
    enemies.get(40)
    enemies.get(20,nil,nil,nil,spell.pistolShot)
    enemies.get(20,nil,true,nil,spell.pistolShot)
    enemies.get(5)
    enemies.get(8)

    local function PickPocketable(Unit)
        if Unit == nil then Unit = "target" end
        local unitType = UnitCreatureType(Unit)
        local types = {
            "Humanoid",
            "Humanoid",
            "Humanoide",
            "Humanoide",
            "Humanoïde",
            "Umanoide",
            "Humanoide",
            "Гуманоид",
            "인간형",
            "人型生物",
            "人型生物"
        }
        for i = 1, #types do
            if unitType == types[i] then return true end
        end
        return false
    end

    local function ttd(unit)
        if UnitIsPlayer(unit) then return 999 end
        local ttdSec = getTTD(unit)
        if getOptionCheck("Enhanced Time to Die") then return ttdSec end
        if ttdSec == -1 then return 999 end
        return ttdSec
    end

    local groupTTD = 0
    for i = 1, #enemies.yards5 do
        thisUnit = enemies.yards5[i]
        groupTTD = groupTTD + ttdd(thisUnit)
    end

    local function getapdmg(offHand)
          local useOH = offHand or false
          local wdpsCoeff = 6
          local ap = UnitAttackPower("player")
          local minDamage, maxDamage, minOffHandDamage, maxOffHandDamage, physicalBonusPos, physicalBonusNeg, percent = UnitDamage("player")
          local speed, offhandSpeed = UnitAttackSpeed("player")
          if useOH and offhandSpeed then
            local wSpeed = offhandSpeed * (1 + GetHaste() / 100)
            local wdps = (minOffHandDamage + maxOffHandDamage) / wSpeed / percent - ap / wdpsCoeff
            return (ap + wdps * wdpsCoeff) * 0.5
          else
            local wSpeed = speed * (1 + GetHaste() / 100)
            local wdps = (minDamage + maxDamage) / 2 / wSpeed / percent - ap / wdpsCoeff
            return ap + wdps * wdpsCoeff
          end
    end


    local function rtdamage()
        local apMod         = getapdmg()
        local rtcoef       = 0.35
        local auramult      = 1.13
        local versmult      = (1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100))
        if talent.deeperStratagem then dsmod = 1.05 else dsmod = 1 end 
        return(
                apMod * combo * rtcoef * auramult * dsmod * versmult
                )
    end

    -- local function isTotem(unit)
    --     local eliteTotems = { -- totems we can dot
    --         [125977] = "Reanimate Totem",
    --         [127315] = "Reanimate Totem",
    --         [146731] = "Zombie Dust Totem"
    --     }
    --     local creatureType = UnitCreatureType(unit)
    --     local objectID = GetObjectID(unit)
    --     if creatureType ~= nil and eliteTotems[objectID] == nil then
    --         if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then return true end
    --     end
    --     return false
    -- end

    -- local function noDotCheck(unit)
    --     if isChecked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then return true end
    --     if isTotem(unit) then return true end
    --     local unitCreator = UnitCreator(unit)
    --     if unitCreator ~= nil and UnitIsPlayer(unitCreator) ~= nil and UnitIsPlayer(unitCreator) == true then return true end
    --     if GetObjectID(unit) == 137119 and getBuffRemain(unit, 271965) > 0 then return true end
    --     return false
    -- end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


                
    local function clearTable(t)
        local count = #t
        for i=0, count do t[i]=nil end
    end
    -- local sortingorbs = false
    -- local sort5 = false
    local bftargets = 0
    local notargetsort = false
    clearTable(enemyTable5)
    clearTable(enemyTable15)
    clearTable(enemyTable20)
    clearTable(burnTable20)
    clearTable(burnTable5)

    -- ?? mfd nill
    if #enemies.yards20 > 0 then
        local highestHP
        local lowestHP
        
        --------- Filling enemyTable20
        for i = 1, #enemies.yards20 do
            local thisUnit = enemies.yards20[i]
            if not UnitIsDeadOrGhost(thisUnit) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                enemyUnit.hpabs = UnitHealth(thisUnit)
                enemyUnit.id = GetObjectID(enemyUnit.unit)
                if IsSpellInRange(GetSpellInfo(1766), enemyUnit.unit) == 1 then
                    -- sort5 = true
                    if  enemyUnit.hpabs >= dotHPLimit and not forcekill[enemyUnit.id] then
                        bftargets = bftargets + 1
                    end
                    enemyUnit.distance = 5
                    enemyUnit.facing = getFacing(thisUnit,"player")
                elseif IsSpellInRange(GetSpellInfo(2094), enemyUnit.unit) == 1 then
                    enemyUnit.distance = 15
                else
                    enemyUnit.distance = 19
                end

                -- enemyUnit.id
                -- if forc
                
                if forcekill[enemyUnit.id] then
                    if enemyUnit.distance <= 5 then
                        tinsert(burnTable5, enemyUnit)
                    end
                    tinsert(burnTable20,enemyUnit)
                end
                tinsert(enemyTable20, enemyUnit)
                if highestHP == nil or highestHP < enemyUnit.hpabs then highestHP = enemyUnit.hpabs end
                if lowestHP == nil or lowestHP > enemyUnit.hpabs then lowestHP = enemyUnit.hpabs end
                if enemyTable20.lowestTTDUnit == nil or enemyTable20.lowestTTD > enemyUnit.ttd then
                    enemyTable20.lowestTTDUnit = enemyUnit.unit
                    enemyTable20.lowestTTD = enemyUnit.ttd
                end
                if talent.markedForDeath and enemyUnit.hpabs <= rtdamage() then mfdtarget = thisUnit end
            end
        end
        ----------------Enemy Score + Sorting
        if #enemyTable20 > 1 then
            for i = 1, #enemyTable20 do
                local hpNorm = (10-1)/(highestHP-lowestHP)*(enemyTable20[i].hpabs-highestHP)+10 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0/0) then hpNorm = 0 end -- NaN check
                local enemyScore = hpNorm
                -- if enemyTable20[i].facing then enemyScore = enemyScore + 30 end -- ??
                if enemyTable20[i].ttd > 1.5 then enemyScore = enemyScore + 5 end
                if enemyTable20[i].distance <= 5 then enemyScore = enemyScore + 30 end
                local raidTarget = GetRaidTargetIndex(enemyTable20[i].unit)
                if raidTarget ~= nil then 
                    enemyScore = enemyScore + raidTarget * 3
                    if raidTarget == 8 then enemyScore = enemyScore + 5 end
                end
                if talent.preyOnTheWeak and UnitDebuffID(enemyTable20[i].unit, 255909) then
                    notargetsort = true
                    enemyScore = enemyScore + 50
                end
                --if UnitBuffID(enemyTable30[i].unit, 277242) then enemyScore = enemyScore + 50 end -- ghuun check
                -- MfD Priority
                -- if UnitBuffID(enemyTable30[i].unit, 137619) then enemyScore = enemyScore + 50 end  --vend score
                enemyTable20[i].enemyScore = enemyScore
            end
            table.sort(enemyTable20, function(x,y)
                return x.enemyScore > y.enemyScore
            end)
        end
        
        ------ Filling other range tables
        for i = 1, #enemyTable20 do
            local thisUnit = enemyTable20[i]
            -- local fokIgnore = {
            --     -- [120651]=true -- Explosive
            -- }
            -- if thisUnit.distance <= 20 then
            -- if fokIgnore[objectID] == nil and not isTotem(thisUnit.unit) then
            --     tinsert(enemyTable20, thisUnit)
            --     --if deadlyPoison10 and not debuff.deadlyPoison.exists(thisUnit.unit) then deadlyPoison10 = false end
            -- end
            --if debuff.garrote.remain(thisUnit.unit) > 0.5 then garroteCount = garroteCount + 1 end
            if enemyTable20[i].distance <= 15 then
                tinsert(enemyTable15, thisUnit)
            end
            if enemyTable20[i].distance <= 5 then
                -- local objectID = GetObjectID(thisUnit.unit)
                -- local x,y,z = ObjectPosition(thisUnit.unit)
                -- if forcekill[objectID] then sortingorbs = true end
                -- LibDraw.Circle(x,y,z,2)
                tinsert(enemyTable5, thisUnit)
                -- libdra
            end
            -- end
        end
        if #enemyTable5 > 1 then
            if talent.markedForDeath and mode.mfd == 3 and mfdtarget ~= nil then
                table.sort(enemyTable5, function(x)
                    if GetUnitIsUnit(x.unit, "mfdtarget") then
                        return true
                    else
                        return false
                    end
                end)
            end
            if not notargetsort then
                table.sort(enemyTable5, function(x)
                    if GetUnitIsUnit(x.unit, "target") then
                        return true
                    else
                        return false
                    end
                end)
            end
            
        end
        if inCombat and #enemyTable5 > 0 and ((GetUnitExists("target") and UnitIsDeadOrGhost("target") and not GetUnitIsUnit(enemyTable5[1].unit, "target")) or not GetUnitExists("target")) then
            TargetUnit(enemyTable5[1].unit)
        end
    end
    --Just nil fixes
    if enemyTable20.lowestTTD == nil then enemyTable20.lowestTTD = 999 end
    -- print(bftargets)
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        


        -- if inCombat and #br.player.enemies.yards5 > 1 then
        --     -- table.sort(br.player.enemies.yards5, function(x,y)
        --     --     return UnitHealth(x) > UnitHealth(y)
        --     -- end)
        --     if GetUnitExists(mfdunit) then
        --         table.sort(br.player.enemies.yards5, function(x)
        --             if GetUnitIsUnit(x, mfdunit) then
        --                 return true
        --             else
        --                 return false
        --             end
        --         end)
        --     end
        --     if GetUnitExists("target") then
        --         table.sort(br.player.enemies.yards5, function(x)
        --             if GetUnitIsUnit(x, "target") then
        --                 return true
        --             else
        --                 return false
        --             end
        --         end)
        --     end
        --     if isChecked("|cffFF0000Force Burn Stuff") then
        --         table.sort(br.player.enemies.yards5, function(x,y)
        --                 if UnitHealth(x) < UnitHealth(y) and forcekill[GetObjectID(x)] and forcekill[GetObjectID(y)]  then
        --                     --print(UnitName(x).."true")
        --                     return true
        --                 else
        --                     --print(UnitName(x).."false")
        --                     return false
        --                 end
        --         end)
        --         -- table.sort(br.player.enemies.yards5, function(x,y)
        --         --     return UnitHealth(x) < UnitHealth(y) and forcekill[GetObjectID(x)] and forcekill[GetObjectID(y)]
        --         -- end)
        --     end  
        -- end
        local function shouldFinish()
            -- if=combo_points>=cp_max_spend-(buff.broadside.up+buff.opportunity.up)*(talent.quick_draw.enabled&(!talent.marked_for_death.enabled|cooldown.marked_for_death.remains>1))
            if combo >= comboMax - ((buff.broadside.exists("player") and 1 or 0) + ((buff.opportunity.exists("player") and 1 or 0)))*(talent.quickDraw and (not talent.markedForDeath or cd.markedForDeath.remain() > 1) and 1 or 0) then
                return true
            else 
                return false
            end
        end
        
        if leftCombat == nil then leftCombat = GetTime() end
        if vanishTime == nil then vanishTime = GetTime() end

        
        --print(viabletargetcount())

        if buff.rollTheBones == nil then buff.rollTheBones = {} end
        buff.rollTheBones.count    = 0
        buff.rollTheBones.duration = 0
        buff.rollTheBones.remain   = 0
        for k,v in pairs(spell.buffs.rollTheBones) do
            if UnitBuffID("player",v) ~= nil then
                buff.rollTheBones.count    = buff.rollTheBones.count + 1
                buff.rollTheBones.duration = getBuffDuration("player",v)
                buff.rollTheBones.remain   = getBuffRemain("player",v)
            end
        end

   

        local function rtbReroll()
            if mode.rollforone == 1 then 
                if buff.rollTheBones.count > 0 then return false end
            elseif bftargets >= 3 then 
				local sac
				if buff.skullAndCrossbones.exists("player") then sac = 1 else sac = 0 end
                return ((buff.rollTheBones.count - sac) < 2 and (buff.loadedDice.exists("player") or not (buff.ruthlessPrecision.exists("player") or buff.grandMelee.exists("player") or (talent.deeperStratagem and buff.broadside.exists("player"))))) and true or false
            --# Reroll for 2+ buffs or Deadshot with Ruthless Precision or Ace up your Sleeve.
            elseif traits.aceupyoursleeve.rank >= 1 or traits.deadshot.rank >= 1 then 
                return (buff.rollTheBones.count < 2 and (buff.loadedDice.exists() or (cd.betweenTheEyes.remain() >= buff.ruthlessPrecision.remain()))) and true or false
                --rtb_reroll,value=rtb_buffs<2&(buff.loaded_dice.up|!buff.grand_melee.up&!buff.ruthless_precision.up)
            else 
            	-- print("last roll")
                return (buff.rollTheBones.count < 2 and (not buff.grandMelee.exists() or not buff.ruthlessPrecision.exists() or buff.loadedDice.exists())) and true or false 
            end
        end

        -- Corruption stuff
        -- 1 = snare,  2 = eye,  3 = thing, 4 = never   -- snare = 315176
        if php <= getOptionValue("Corruption Immunity") then
            if br.player.equiped.shroudOfResolve and canUseItem(br.player.items.shroudOfResolve) and isChecked("Use Cloak") then
                if getValue("Use Cloak") == 1 and debuff.graspingTendrils.exists("player")
                    or getValue("Use Cloak") == 2 and debuff.eyeOfCorruption.exists("player")
                    or getValue("Use Cloak") == 3 and debuff.grandDelusions.exists("player") then
                    if br.player.use.shroudOfResolve() then end
                end
            end
            if isChecked("Cloak of Shadows Corruption") and not canUseItem(br.player.items.shroudOfResolve) or getValue("Use Cloak") == 4 then
                if getValue("Cloak of Shadows Corruption") == 1 and debuff.graspingTendrils.exists("player") 
                    or getValue("Cloak of Shadows Corruption") == 2 and debuff.eyeOfCorruption.exists("player")
                    or getValue("Cloak of Shadows Corruption") == 3 and debuff.grandDelusions.exists("player") then
                    if cast.cloakOfShadows() then return true end
                end
            end
            if debuff.grandDelusions.exists("player") and (not canUseItem(br.player.items.shroudOfResolve) or not isChecked("Use Cloak") or not getValue("Use Cloak") == 3) and 
             (cd.cloakOfShadows.exists() or not isChecked("Cloak of Shadows Corruption") or getValue("Cloak of Shadows Corruption") == 3) then
                if isChecked("Vanish THING") then
                    if cast.vanish("player") then return true end
                elseif isChecked("Shadowmeld THING") then
                    if cast.shadowmeld() then return true end    
                elseif isChecked("Blind THING") then
                    for i = 1, GetObjectCountBR() do
                        local object = GetObjectWithIndex(i)
                        local ID = ObjectID(object)                        
                        if ID == 161895 then
                            local x1, y1, z1 = ObjectPosition("player")
                            local x2, y2, z2 = ObjectPosition(object)
                            local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                            if distance <= 10 then
                                if cast.blind(object) then return end
                            end
                        end
                    end
                end
            end
        end

        --actions+=/variable,name=ambush_condition,value=combo_points.deficit>=2+2*(talent.ghostly_strike.enabled&cooldown.ghostly_strike.remains<1)+buff.broadside.up&energy>60&!buff.skull_and_crossbones.up
        local function ambushCondition()
            if comboDeficit >= 2 + 2 * ((talent.ghostlyStrike and cd.ghostlyStrike.remain() < 1) and 1 or 0) + (buff.broadside.exists() and 1 or 0) and power > 60 and not buff.skullAndCrossbones.exists() then
                return true
            end
            return false
        end

        local function bladeFlurrySync()
            return not mode.bladeflurry == 1 or bftargets < 2 or buff.bladeFlurry.exists()
        end
        -- finish,if=combo_points>=cp_max_spend-(buff.broadside.up+buff.opportunity.up)*(talent.quick_draw.enabled&(!talent.marked_for_death.enabled|cooldown.marked_for_death.remains>1))

-- # Finish at maximum CP. Substract one for each Broadside and Opportunity when Quick Draw is selected and MfD is not ready after the next second.
-- actions+=/call_action_list,name=finish,if=combo_points>=cp_max_spend-(buff.broadside.up+buff.opportunity.up)*(talent.quick_draw.enabled&(!talent.marked_for_death.enabled|cooldown.marked_for_death.remains>1))
        
        -- print(shouldFinish())

        local function cast5yards(skill,stuff)

            if isChecked("|cffFF0000Force Burn Stuff") or spread then
                for i = 1, #burnTable5 do
                    local thisUnit = burnTable5[i].unit
                    if stuff then
                        if cast[skill](thisUnit) then return true end
                    end
                end
            end

            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if stuff then
                    if cast[skill](thisUnit) then return true end
                end
            end
        end

        local function cast20yards(skill,stuff)
            if skill == "betweenTheEyes" and (mode.nobte == 3 or spread) then return end

            if isChecked("|cffFF0000Force Burn Stuff") or spread then
                for i = 1, #burnTable20 do
                    if burnTable20[i].id == 120651 then
                        if skill == "betweenTheEyes" then return end
                        if isChecked("DontWasteDeadShotOnOrbs") and skill == "pistolShot" and buff.deadShot.exists("player") then return end
                    end
                    local thisUnit = burnTable20[i].unit
                    if stuff then
                        if cast[skill](thisUnit) then return true end
                    end
                end
            end
            if mode.nobte == 1 then
                if skill == "betweenTheEyes" then
                    for i = 1, #enemyTable20 do
                        if enemyTable20[i].id == 120651 then return end
                        local thisUnit = enemyTable20[i].unit 
                        if isChecked("DRTracker") then
                            if stuff and canCC(199804, thisUnit) and (select(5,UnitCastingInfo(thisUnit)) ~= nil or select(5,UnitChannelInfo(thisUnit)) ~= nil) then
                                if cast[skill](thisUnit) then return true end
                            end
                        else
                            if stuff and (select(5,UnitCastingInfo(thisUnit)) ~= nil or select(5,UnitChannelInfo(thisUnit)) ~= nil) then
                                if cast[skill](thisUnit) then return true end
                            end
                        end
                    end
                    for i = 1, #enemyTable20 do
                        if enemyTable20[i].id == 120651 then return end
                        local thisUnit = enemyTable20[i].unit 
                        if isChecked("DRTracker") then
                            if stuff and canCC(199804, thisUnit) then
                                if cast[skill](thisUnit) then return true end
                            end
                        else
                            if stuff then
                                if cast[skill](thisUnit) then return true end
                            end
                        end
                    end
                end
            end
            if skill == "betweenTheEyes" and mode.nobte == 2 then
                if cast[skill]("target") then return true end
            end
            for i = 1, #enemyTable20 do
                local thisUnit = enemyTable20[i].unit 
                if stuff then
                    if cast[skill](thisUnit) then return true end
                end
            end

        end
--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        --[[local function actionList_Extras()
        end -- End Action List - Extras]]
    -- Action List - DefensiveModes
        local function actionList_Defensive()
          -- SLASH_FEINT1 = "/feinterino"
          -- SlashCmdList["FEINT"] = function(_)
          --   if not buff.feint.exists() or (buff.feint.exists() and buff.feint.remain() <= 0.8) or isDeBuffed("player", 230139) and mode.feint == 2 then
          --     if toggle("Feint", 1) then
          --       return true
          --     end
          --   end
          -- end
          -- -- Feint
          -- if mode.feint == 1 and not buff.feint.exists() then
          --   if cast.feint() and toggle("Feint", 2) then
          --     return true
          --   end
          -- end
          
          if not stealth then
            -- Health Pot/Healthstone
            if isChecked("Healing Potion/Healthstone") and (use.able.healthstone() or canUseItem(169451)) and php <= getOptionValue("Healing Potion/Healthstone") and inCombat and (hasItem(169451) or has.healthstone()) then
                if use.able.healthstone() then
                    use.healthstone()
                elseif canUseItem(169451) then
                    useItem(169451)
                end
            end
            -- Crimson Vial
            if isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
              if cast.crimsonVial() then
                return true
              end
            end
            -- Feint
            if isChecked("Feint") and php <= getOptionValue("Feint") and inCombat and not buff.feint.exists() then
              if cast.feint() then
                return true
              end
            end
            -- Evasion
            if isChecked("Riposte") and php <= getOptionValue("Riposte") and inCombat then
              if cast.riposte() then
                return true
              end
            end
            if isChecked("Engineer's Belt") and php <= getOptionValue("Engineer's Belt") and inCombat then
                if canUseItem(6) then
                    useItem(6)
                end
            end
          end
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemyTable5 do
                    local thisUnit = enemyTable5[i].unit
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) and hasThreat(thisUnit) then
                        -- kick
                        if isChecked("Kick") then
                            if cast.kick(thisUnit) then end
                        end
                    end
                end
            end -- End Interrupt and No Stealth Check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            local startTime = debugprofilestop()
        -- Trinkets
            if isChecked("Trinkets") and not hasEquiped(169311, 13) and not hasEquiped(169311, 14) then
                if hasBloodLust() or (ttd("target") <= 20 and isBoss("target"))  then
                    if canUseItem(13) then
                        useItem(13)
                    end
                    if canUseItem(14) then
                        useItem(14)
                    end
                end
            end

            -- # Razor Coral
            if isChecked("Trinkets") and targetDistance < 5 then
                if hasEquiped(169311, 13) and (not debuff.razorCoral.exists(units.dyn5) or (buff.adrenalineRush.remain() > 10 and (debuff.razorCoral.stack() >= 20 or (debuff.razorCoral.stack() >= 10 and buff.seethingRage.exists())))) then
                    useItem(13)
                elseif hasEquiped(169311, 14) and (not debuff.razorCoral.exists(units.dyn5) or (buff.adrenalineRush.remain() > 10 and (debuff.razorCoral.stack() >= 20 or (debuff.razorCoral.stack() >= 10 and buff.seethingRage.exists())))) then
                    useItem(14)
                end
            end

            -- # Pop Razor Coral right before Dribbling Inkpod proc to increase it's chance to crit (at 32-30% of HP)
            if isChecked("Trinkets") then
                if hasEquiped(169311, 13) and canUseItem(13) and hasEquiped(169319, 14) and getHP("target") < 31 then
                    useItem(13)
                elseif hasEquiped(169311, 14) and canUseItem(14) and hasEquiped(169319, 13) and getHP("target") < 31 then
                    useItem(14)
                end
            end

            --Essences 8.2
            if mode.essence == 2 then
                -- Essence: Reaping Flames
                -- reaping_flames,if=target.health.pct>80|target.health.pct<=20|target.time_to_pct_20>30
                if cast.able.reapingFlames() then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        local thisHP = getHP(thisUnit)
                    if ((essence.reapingFlames.rank >= 2 and thisHP > 80) or thisHP <= 20 or getTTD(thisUnit,20) > 30) then
                        if cast.reapingFlames(thisUnit) then return true end
                        end
                    end
                end
                -- # Blood of the Enemy
                if essence.bloodOfTheEnemy.active and isChecked("BotE") and not rtbReroll() and cd.betweenTheEyes.remain() < 5 then 
                    if buff.bladeFlurry.exists("player") and bftargets >= 3 then
                        if cast.bloodOfTheEnemy() then return true end
                    elseif isBoss("target") and buff.adrenalineRush.exists() then
                        if cast.bloodOfTheEnemy() then return true end
                    end
                end
                -- # Guardian of Azeroth
                if essence.guardianOfAzeroth.active and isChecked("CLF") and buff.adrenalineRush.remain() > 10 then
                    if cast.guardianOfAzeroth() then return true end
                end
                -- Crucible of flame
                if cast.able.concentratedFlame() then 
                    if getOptionValue("Use Concentrated Flame") ~= 1 and php <= getValue("Concentrated Flame Heal") then
                        if cast.concentratedFlame("player") then
                            return
                        end
                    end
                    if getOptionValue("Use Concentrated Flame") == 1 or (getOptionValue("Use Concentrated Flame") == 3 and php > getValue("Concentrated Flame Heal")) then
                        if cast.concentratedFlame("target") then
                            return
                        end
                    end	
                end
            end

    -- Non-NE Racial
            --blood_fury
            --berserking
            --arcane_torrent,if=energy.deficit>40
            if useCDs() and isChecked("Racial") and (race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" or "MagharOrc") then
                if cast.racial("player") then return true end
            end

            if useCDs() and isChecked("AdrenalineRush") and not buff.adrenalineRush.exists() and ttd("target") >= 10 then
                if cast.adrenalineRush("player") then
                    if isChecked("Trinkets") and not hasEquiped(169311, 13) then
                        if canUseItem(13) then
                            useItem(13)
                        end
                        if canUseItem(14) and not hasEquiped(169311, 14) then
                            useItem(14)
                        end
                    end
                return true end
            end    

            if talent.ghostlyStrike and bladeFlurrySync() and comboDeficit >= (1 + (buff.broadside.exists() and 1 or 0)) then
                if cast.ghostlyStrike("target") then return true end
            end

            if talent.killingSpree and mode.tierseven == 1 and bladeFlurrySync() and (ttm > 5 or power < 15) then
                if cast.killingSpree("target") then return true end
            end
    -- Blade Rush
            -- blade_rush,if=variable.blade_flurry_sync&energy.time_to_max>1
            if mode.tierseven == 1 and bladeFlurrySync() and getDistance("target") < 5 and ttm > 1 then
                if cast.bladeRush("target") then return true end
            end

            if isChecked("Debug Timers") then
                if profile.Cooldowns == nil then profile.Cooldowns = {} end
                local section = profile.Cooldowns
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
        -- Stealth
            if not inCombat and not stealthingAll then
                if isChecked("Stealth") then
                    if getOptionValue("Stealth") == 1 or #enemies.yards20nc > 0 then
                        if (not IsMounted() and not IsFlying()) then
                            if cast.stealth("player") then end
                        end
                    end
                end
            end

            if stealthingRogue and (br.player.instance=="party" or br.player.instance=="raid" or isDummy("target")) and isChecked("Vanish") then
                if cast.ambush("target") then end
            end

            if isChecked("PickPocket") then
                if #enemyTable5 > 0 and stealthingRogue then
                    for i = 1, #enemyTable5 do
                        local thisUnit = enemyTable5[i].unit
                        if isChecked("PickPocket") then
                            if PickPocketable(thisUnit) then
                                if cast.pickPocket(thisUnit) then
                                    CastSpellByID(8676, thisUnit)
                                end
                            end
                        end
                        
                    end
                    -- if GetUnitExists("target") then if cast.ambush("target") then return true end end
                end
            elseif isChecked("Ambush Opener") then
                if #enemyTable5 > 0 and stealthingRogue then
                    for i = 1, #enemyTable5 do
                        if cast.ambush(enemyTable5[i].unit) then return true end
                    end
                end
            end

        end -- End Action List - PreCombat
    -- Action List - Finishers
        local function actionList_Finishers() 
            local startTime = debugprofilestop()                          

            -- actions.finish=between_the_eyes,if=buff.ruthless_precision.up|(azerite.deadshot.rank>=2&buff.roll_the_bones.up)
            if (buff.ruthlessPrecision.exists() or ((traits.deadshot.rank > 0 or traits.aceupyoursleeve.rank > 0) and buff.rollTheBones.count > 0)) then
                --print("626")
                cast20yards("betweenTheEyes",true)
            end
            

            if not talent.sliceAndDice then
                if buff.rollTheBones.remain < 3 or rtbReroll() then
                    if cast.rollTheBones("player") then return true end
                end
            else
                if buff.sliceAndDice.remain() < ttd("target") and buff.sliceAndDice.refresh() then
                    if cast.sliceAndDice("player") then return true end
                end
            end

            if (traits.deadshot.rank > 0 or traits.aceupyoursleeve.rank > 0) then
                --print("643")
                 cast20yards("betweenTheEyes",true)
            end

            cast5yards("dispatch",true)

            if isChecked("Debug Timers") then
                if profile.Finishers == nil then profile.Finishers = {} end
                local section = profile.Finishers
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end            
        end

        local function actionList_Build()
            local startTime = debugprofilestop()      

            if not stealthingAll and comboDeficit >= (1 + (buff.broadside.exists() and 1 or 0) + (talent.quickDraw and 1 or 0)) and buff.opportunity.exists() and (buff.wits.stack() < 25 or power < 45 or buff.deadShot.exists()) then
                cast20yards("pistolShot",true)
            end

            cast5yards("sinisterStrike",true)

            if talent.dirtyTricks then
                cast5yards("gouge",true)
            end
            if isChecked("Debug Timers") then
                if profile.Builder == nil then profile.Builder = {} end
                local section = profile.Builder
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
        end -- End Action List - Build

        local function actionList_CC()
            local stunList = { -- Stolen from feng pala
            [274400] = true, -- Duelist Dash fh
            [274383] = true, -- Rat Traps fh
            [276292] = true, -- Whirling Slam SotS
            [268273] = true, -- Deep Smash SotS
            [256897] = true, -- Clamping Jaws SoB
            [272542] = true, -- Ricochet SoB
            [272888] = true, -- Ferocity SoB
            --[269266] = true, -- Slam SoB ????????? tentacle last bos?
            [258864] = true, -- Suppression Fire TD
            [259711] = true, -- Lockdown TD
            [264038] = true, -- Uproot WM
            [253239] = true, -- Merciless Assault AD
            [269931] = true, -- Gust Slash KR ????????
            [270084] = true, -- Axe Barrage KR
            [270482] = true, -- Blooded Leap KR
            [270506] = true, -- Deadeye Shot KR
            [270507] = true, -- Poison Barrage KR
            -- [267433] = true, -- Activate Mech ML ????????????
            [268702] = true, -- Furious Quake ML
            [268846] = true, -- Echo Blade ML
            [268865] = true, -- Force Cannon ML
            [258908] = true, -- Blade Flurry ToS
            [264574] = true, -- Power Shot ToS
            [272659] = true, -- Electrified Scales ToS
            [272655] = true, -- Scouring Sand ToS
            -- [277567] = true, -- infest 
            [265542] = true, -- Rotten Bile UR
            [250096] = true,  -- Yazma AD
            [256060] = true  -- FH Krag Channel heal

            }
            local channelAsapList = {
            [257756] = true, -- Goin' Bananas FH
            [258317] = true, --Riot Shield TD ???? only magic
            [258917] = true, -- Righteous Flames TD
            [267357] = true, -- Hail of Flechettes ML
            [267237] = true, -- Drain ToS
            [280604] = true, -- Iced Spritzer ML
            [265568] = true, -- Dark Omen UR
            [250368] = true  -- Vol’kaal AD
            }
            local channelLateList = {
            [270839] = true -- test
            }

            local willkick = nil
            if drawing then
                LibDraw.clearCanvas()
            end
            function canInterruptshit(unit, hardinterrupt, forpro, gouge)

                local hardinterrupt = hardinterrupt or false
                local timeforcc = (hardinterrupt and 2) or 0.4
                local interruptTarget = getOptionValue("Interrupt Target")
                if interruptTarget == 2 and not GetUnitIsUnit(unit, "target") then
                    return false
                elseif interruptTarget == 3 and not GetUnitIsUnit(unit, "focus") then
                    return false
                elseif interruptTarget == 4 and getOptionValue("Interrupt Mark") ~= GetRaidTargetIndex(unit) then
                    return false
                end
                local castStartTime, castEndTime, interruptID, interruptable, castLeft = 0, 0, 0, false, 999
                if GetUnitExists(unit)
                    and UnitCanAttack("player",unit)
                    and not UnitIsDeadOrGhost(unit)
                then
                    -- Get Cast/Channel Info
                    if select(5,UnitCastingInfo(unit)) and (not select(8,UnitCastingInfo(unit)) or hardinterrupt) then --Get spell cast time
                        castStartTime = select(4,UnitCastingInfo(unit))
                        castEndTime = select(5,UnitCastingInfo(unit))
                        castLeft = castEndTime/1000 - GetTime()
                        interruptID = select(9,UnitCastingInfo(unit))
                        if stunList[interruptID] or isChecked("Any Cast") then interruptable = true end
                    elseif select(5,UnitChannelInfo(unit)) and (not select(7,UnitChannelInfo(unit)) or hardinterrupt) then -- Get spell channel time
                        castStartTime = select(4,UnitChannelInfo(unit))
                        castEndTime = select(5,UnitChannelInfo(unit))
                        castLeft = castEndTime/1000 - GetTime()
                        interruptID = select(8,UnitChannelInfo(unit))
                        if channelAsapList[interruptID] or channelLateList[interruptID] or isChecked("Any Cast") then interruptable = true end
                    end
                    if interruptable or isChecked("Any Cast") then
                        if not cd.kick.exists() and not hardinterrupt then
                            if willkick == nil then
                                willkick = unit
                                local wx,wy,wz = ObjectPosition(willkick)
                                if drawing then
                                    if getDistance(unit) > 5 then
                                        LibDraw.SetColor(255,0,0)
                                    else
                                        LibDraw.SetColor(0,0,0)
                                    end
                                    LibDraw.Text("KICK SHIT", "GameFontNormal", wx,wy,wz+2)
                                end
                            end
                        end
                        if gouge and (willkick == nil or willkick ~= unit) and drawing then
                            if not getFacing(unit, "player") or getDistance(unit) > 5 then
                                LibDraw.SetColor(255,0,0)
                            else
                                LibDraw.SetColor(0,0,0)
                            end
                            local ux,uy,uz = ObjectPosition(unit)
                            LibDraw.Text("CC SHIT", "GameFontNormal", ux,uy,uz+2)
                        end
                        if willkick == unit and hardinterrupt then return false end
                        if castLeft <= timeforcc or channelAsapList[interruptID] ~= nil then
                            -- print(forpro)
                            if forpro or (GetTime() - castStartTime/1000) > 1  then
                                return true
                            end
                        end
                    end
                    return false
                end
            end
            for i = 1, #enemyTable20 do
                local thisUnit = enemyTable20[i].unit
                local distance = enemyTable20[i].distance
                if isBoss(thisUnit) then return end
                if isChecked("AutoKick") and distance <= 5 and not cd.kick.exists()  then
                    if canInterruptshit(thisUnit, nil, forpro) then
                        if cast.kick(thisUnit) then end
                    end
                end
                if isChecked("AutoGouge") and not cd.gouge.exists() and getFacing(thisUnit, "player") then
                    if canInterruptshit(thisUnit, true , forpro, true) then
                        if cast.gouge(thisUnit) then return true end
                    end
                elseif isChecked("AutoBtE") and distance <= 20 and combo >= 4 and not cd.betweenTheEyes.exists() and not spread then
                    if canInterruptshit(thisUnit, true , true) then
                        if cast.betweenTheEyes(thisUnit) then return true end
                    end
                elseif isChecked("AutoBlind") and distance <= 15 and not cd.blind.exists() then
                    if canInterruptshit(thisUnit, true , true) then
                        if cast.blind(thisUnit) then return true end
                    end
                end
            end
            -- if isChecked("AutoKick") and not cd.kick.exists() then
            --     for i = 1, #enemyTable5 do
            --         local thisUnit = enemyTable5[i].unit
            --         if canInterruptshit(thisUnit, nil , true) then
            --             if cast.kick(thisUnit) then end
            --         end
            --     end
            -- end
            -- if isChecked("AutoBtE") and combo > 4 and not cd.betweenTheEyes.exists() then
            --     for i = 1, #enemyTable20 do
            --         local thisUnit = enemyTable20[i].unit
            --         if canInterruptshit(thisUnit, true , true) then
            --             if cast.betweenTheEyes(thisUnit) then return true end
            --         end
            --     end
            -- end
            -- if isChecked("AutoGouge") and not cd.gouge.exists() then
            --     for i = 1, #enemyTable5 do
            --         local thisUnit = enemyTable5[i].unit
            --         if canInterruptshit(thisUnit, true , true) and thisUnit.facing then
            --             if cast.gouge(thisUnit) then return true end
            --         end
            --     end
            -- end
            -- if isChecked("AutoBtE") and combo > 0 and not cd.betweenTheEyes.exists() then
            --     for i = 1, #enemyTable20 do
            --         local thisUnit = enemyTable20[i].unit
            --         if canInterruptshit(thisUnit, true , true) then
            --             if cast.betweenTheEyes(thisUnit) then return true end
            --         end
            --     end
            -- end
            -- if isChecked("AutoBlind") and not cd.blind.exists() then
            --     for i = 1, #enemyTable15 do
            --         local thisUnit = enemyTable15[i].unit
            --         if canInterruptshit(thisUnit, true , true) then
            --             if cast.blind(thisUnit) then return true end
            --         end
            --     end
            -- end

            
        end
        

        local function actionList_Opener()                    
        end

    local function MythicStuff()
        local cloakPlayerlist = {
        [265773] = true -- Spit Gold KR 

        }
        
        local evasionPlayerlist = {
        [256979] = true, -- pewpew council boss
        [266231] = true, -- Severing Axe KR
        [256106] = true
        }
        
        local cloaklist = {
        [119300] = true --test rfc 2
        }
        
        local evasionlist = {

        }
        
        local feintlist = {

        }
        
        if eID then
            -- print(eID)
            local bosscount = 0
            for i = 1, 5 do
                if GetUnitExists("boss" .. i) then
                  bosscount = bosscount + 1
                end
            end
            for i = 1, bosscount do
                local spellname, castEndTime,interruptID, spellnamechannel, castorchan, spellID
                thisUnit = tostring("boss" .. i)
                if UnitCastingInfo(thisUnit) then
                    spellname = UnitCastingInfo(thisUnit)
                    -- castStartTime = select(4,UnitCastingInfo(thisUnit)) / 1000
                    castEndTime = select(5, UnitCastingInfo(thisUnit)) / 1000
                    interruptID = select(9,UnitCastingInfo("target"))
                    castorchan = "cast"
                elseif UnitChannelInfo(thisUnit) then
                    spellname = UnitChannelInfo(thisUnit)
                    -- castStartTime = select(4,UnitChannelInfo(thisUnit)) / 1000
                    castEndTime = select(5,UnitChannelInfo(thisUnit)) / 1000
                    interruptID = select(8,UnitChannelInfo(thisUnit))
                    castorchan = "channel"
                end
                if spellname ~= nil then
                    local castleft = castEndTime - GetTime()
                        -- WriteFile("encountertest.txt", tostring(ObjectName("boss"..i)) .. "," .. tostring(castleft) .. " left," .. tostring(spellname) .. ", spellid =" .. tostring(interruptID) .. "\n", true)
                        -- print(castleft.." cast left"..spellname)
                        -- print(castleft.." channel left"..spellname)
                    -- if castleft <= 3 then
                        if (select(3, UnitCastID(thisUnit)) == ObjectPointer("player") or select(4, UnitCastID(thisUnit)) == ObjectPointer("player")) and castleft <= 3 then--GetUnitIsUnit("player", "boss"..i.."target") or   then
                            if cloakPlayerlist[interruptID] then
                                if cast.cloakOfShadows("player") then end
                            elseif evasionPlayerlist[interruptID] then
                                if cast.riposte("player") then end
                            end
                        else
                            if cloaklist[interruptID] then
                                if cast.cloakOfShadows("player") then end
                            elseif evasionlist[interruptID] then
                                if cast.riposte("player") then end
                            elseif feintlist[interruptID] then
                                if cast.pool.feint("player") and cd.feint.remains() <= castleft then return true end
                                if cast.feint("player") then return true end
                            end
                        end
                    -- end
                end
            end
            --CC units
            -- for i=1, #enemies.yards20 do
            --         local thisUnit = enemies.yards20[i]
            --         local distance = getDistance(thisUnit)
            --         if isChecked("AutoBtE") or isChecked("AutoGouge") or isChecked("AutoBlind") then
            --             local interruptID, castStartTime, spellname, castEndTime
            --             if UnitCastingInfo(thisUnit) then
            --                 spellname = UnitCastingInfo(thisUnit)
            --                 -- castStartTime = select(4,UnitCastingInfo(thisUnit)) / 1000
            --                 castEndTime = select(5, UnitCastingInfo(thisUnit)) / 1000
            --                 interruptID = select(9,UnitCastingInfo("player"))
            --             elseif UnitChannelInfo(thisUnit) then
            --                 spellname = UnitChannelInfo(thisUnit)
            --                 -- castStartTime = select(4,UnitChannelInfo(thisUnit)) / 1000
            --                 castEndTime = select(5,UnitChannelInfo(thisUnit)) / 1000
            --                 interruptID = select(8,UnitChannelInfo(thisUnit))
            --             end
            --             if isChecked("AutoBtE") and interruptID ~= nil and combo > 0 and not spread and 
            --                     ((stunList[interruptID] and castEndTime - GetTime() <= 2 ) or
            --                     channelAsapList[interruptID] or
            --                     channelLateList[interruptID] and castEndTime - GetTime() <= 2)
            --                 then
            --                 if cast.betweenTheEyes(thisUnit) then print("bte stun on"..spellname); return true end
            --             end
            --             if isChecked("AutoGouge") and interruptID ~= nil and getFacing(thisUnit,"player") and
            --                     ((stunList[interruptID] and castEndTime - GetTime() <= 2 ) or
            --                     channelAsapList[interruptID] or
            --                     channelLateList[interruptID] and castEndTime - GetTime() <= 2)
            --                 then
            --                 if cast.gouge(thisUnit) then print("gouge on"..spellname) return true end
            --             end
            --             if isChecked("AutoBlind") and interruptID ~= nil and 
            --                     ((stunList[interruptID] and castEndTime - GetTime() <= 2 ) or
            --                     channelAsapList[interruptID] or
            --                     (channelLateList[interruptID] and castEndTime - GetTime() <= 2)) then
            --                 if cast.blind(thisUnit) then print("blind on "..spellname) return true end
            --             end
            --         end
            --     end
        end
    end   
        --`````````````````````````````````````````````````STARTING SHIT```````````````````````````````````````````````
        
        if UnitCastingInfo("player") then return true end
        
        -- print(UnitCastingInfo("player"))

        if actionList_PreCombat() then return end

        if isChecked("|cffFFBB00Encounter Logic") then 
            if MythicStuff() then return end
        end
        if mode.stun == 1 then
                if actionList_CC() then return true end
            end

        if (inCombat and profileStop == true) or not inCombat or pause() or (IsMounted() or IsFlying()) or mode.rotation == 2 or UnitCastingInfo("player") then
            return true
        else

        
 
            --print(rtbReroll())
            --print(br.player.power.energy.ttm())
            -- if cast.sinisterStrike() then return end
           -- print(getDistance("target"))
            --print(inRange(193315,"target"))
           -- print(IsSpellInRange(193315,"target"))
            --if castSpell("target",193315,true,false,false,true,false,true,false,false) then return end
            --RunMacroText("/cast Коварный удар")
        --if actionList_Extras() then return end

        if actionList_Defensive() then return end

        -- if isValidUnit("target") and isChecked("Opener") then
        --     if actionList_Opener() then return end
        -- end

        -- if mode.mfd == 3 and rtuseon ~= nil then
        --     if UnitIsDeadOrGhost(rtuseon) then rtuseon = nil return true end
        --             print("trying dispatch")
        --             if cast.dispatch(rtuseon) then
        --                 print("rt on mfd")
        --                 rtuseon = nil
        --             return true end
        -- end


        if mode.bladeflurry == 1 and buff.rollTheBones.remain >= 5 and bftargets >= 2 and not buff.bladeFlurry.exists() and charges.bladeFlurry.frac() >= 1.5 and groupTTD >= getOptionValue("BF Time To Die Limit") then
            if cast.bladeFlurry("player") then return true end
        end

        --tricks
        if tricksUnit ~= nil and validTarget and targetDistance < 5 and UnitThreatSituation("player") and UnitThreatSituation("player") >= 2 then
            cast.tricksOfTheTrade(tricksUnit)
        end


            if not IsCurrentSpell(6603) and inCombat and not stealth and isValidUnit("target") and getDistance("target") <= 5 and getFacing("player", "target") then
                StartAttack("target")
            end

            if mode.stun == 1 then
                if actionList_CC() then return true end
            end

            if talent.markedForDeath and mode.mfd == 3 and combo < comboMax and cd.markedForDeath.remain() <= 0 then
                if mfdtarget ~= nil and not UnitIsDeadOrGhost(mfdtarget) then
                    if cast.markedForDeath(mfdtarget) then end
                end
            end



            if actionList_Interrupts() then end

            if isChecked("Vanish") and ambushCondition() and cd.vanish.remain() <= 0.2 and getDistance("target") <= 5 and useCDs() and not solo then
                if gcd > 0.2 then return true end
                if cast.pool.ambush() then return true end
                if CastSpellByID(1856) then return true end
            end

            if (useCDs() or mode.tierseven == 1) and #enemyTable5 >= 1 then
                if actionList_Cooldowns() then return end
            end

            -- if stealthingAll then
            --     if actionList_Stealth() then return end
            -- end

                if talent.markedForDeath and mode.mfd == 1 and cd.markedForDeath.remain() <= 0.2 then                            
                    if comboDeficit >= comboMax - 1 then
                        CastSpellByID(137619,"target")
                        return true
                    end
                end
                if talent.markedForDeath and mode.mfd == 2 and cd.markedForDeath.remain() <= 0.2 then
                        local thisUnit = enemies.yards20[i]
                        if ttd(thisUnit) < comboDeficit  then
                                if CastSpellByID(137619,thisUnit) then return true end
                        end
                end
            if shouldFinish() or (traits.snakeeyes.rank > 0 and not buff.snakeeeyes.exists() and rtbReroll()) then
                if actionList_Finishers() then return end
            end
            if actionList_Build() then return end
            if isChecked("Pistol Shot out of range") and isValidUnit("target") and #enemyTable5 == 0 and not stealthingAll and power >= getOptionValue("Pistol Shot out of range") and (comboDeficit >= 1 or ttm <= 1.2) then
                if cast.pistolShot("target") then return true end
            end
            if useCDs() and isChecked("Racial") then
                if race == "BloodElf" and powerDeficit >= (15 + powerRegen) then
                    if cast.racial("player") then return true end
                elseif race == "Nightborne" then
                    if cast.racial("player") then return true end
                elseif race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then return true end
                end
            end

    end

    if isChecked("Debug Timers") then
        if profile.totalIterations == nil then profile.totalIterations = 0 end
        if profile.elapsedTime == nil then profile.elapsedTime = 0 end
        profile.currentTime = debugprofilestop()-startTime
        profile.totalIterations = profile.totalIterations + 1
        profile.elapsedTime = profile.elapsedTime + debugprofilestop()-startTime
        profile.averageTime = profile.elapsedTime / profile.totalIterations
    end
end
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
