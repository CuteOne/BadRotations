local rotationName = "immy"
local br = br
br.rogueTables = {}
local rogueTables = br.rogueTables
rogueTables.enemyTable5, rogueTables.enemyTable20, rogueTables.enemyTable30 = {}, {}, {}
local enemyTable5, enemyTable20, enemyTable30 = rogueTables.enemyTable5, rogueTables.enemyTable20, rogueTables.enemyTable30
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
-- Blade Flurry Button
    BladeFlurryModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.bladeFlurry},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.bladeFlurry}
    };
    CreateButton("BladeFlurry",2,0)
    NoBTEModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.betweenTheEyes},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.betweenTheEyes}
    };
    CreateButton("NoBTE",2,1)    
-- Defensive Button
    SpecialModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.adrenalineRush},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.adrenalineRush},
    };
    CreateButton("Special",4,0)
    TiersevenModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.bladeRush},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.bladeRush},
    };
    CreateButton("Tierseven",4,1)    
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.kick},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.kick}
    };
    CreateButton("Interrupt",3,0)
        StunModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.gouge},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.gouge}
    };
    CreateButton("Stun",3,1)
    MFDModes = {
        [1] = { mode = "Tar", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.markedForDeath},
        [2] = { mode = "Adds", value = 2 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.markedForDeath},
        [3] = { mode = "reset", value = 3 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.markedForDeath},
        [4] = { mode = "Off", value = 4 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.markedForDeath}
    };
    CreateButton("MFD",5,0)
    RollforoneModes = {
        [1] = { mode = "any", value = 1 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.rollTheBones},
        [2] = { mode = "simc", value = 2 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.rollTheBones}
    };
    CreateButton("Rollforone",5,1)    
end

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
            br.ui:createCheckbox(section, "Opener")
            br.ui:createCheckbox(section, "RTB Prepull")
            br.ui:createDropdown(section, "Stealth", {"|cff00FF00Always", "|cffFF000020Yards"},  2, "Stealthing method.")
        br.ui:checkSectionState(section)
        ------------------------
        --- OFFENSIVE OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Offensive")
            br.ui:createCheckbox(section, "Trinkets")
            br.ui:createCheckbox(section, "Vanish")
            br.ui:createCheckbox(section, "Racial")
            br.ui:createSpinnerWithout(section, "BF HP Limit", 15, 0, 105, 1, "|cffFFFFFFHP *10k hp for Blade FLurry to be used")
            br.ui:createSpinner(section, "Pistol Shot out of range", 85,  5,  100,  5,  "|cffFFFFFFCheck to use Pistol Shot out of range and energy to use at.")
            br.ui:createSpinnerWithout(section, "MFD Sniping",  1,  0.5,  3,  0.1,  "|cffFFBB00Increase to have BR cast MFD on dying units quicker, too high might cause suboptimal casts")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Special")
            br.ui:createCheckbox(section, "AutoBtE", "|cffFFFFFF Auto BtE dangerous casts")
            br.ui:createCheckbox(section, "AutoGouge", "|cffFFFFFF Auto Gouge dangerous casts")
            br.ui:createCheckbox(section, "AutoBlind", "|cffFFFFFF Auto Blind dangerous casts")
            br.ui:createCheckbox(section, "|cffFF0000Force Burn Stuff", "Ghuunies/explosives orb = rip")
            br.ui:createCheckbox(section, "|cffFFBB00Encounter Logic", "Use PvE Logic")
            br.ui:createCheckbox(section, "Ambush Opener", "Will use ambush as soon as target is in range")
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
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("BladeFlurry",0.25)
        br.player.mode.bladeflurry = br.data.settings[br.selectedSpec].toggles["BladeFlurry"]
        br.player.mode.stun = br.data.settings[br.selectedSpec].toggles["Stun"]
        br.player.mode.mfd = br.data.settings[br.selectedSpec].toggles["MFD"]
        br.player.mode.rollforone = br.data.settings[br.selectedSpec].toggles["Rollforone"]
        br.player.mode.special = br.data.settings[br.selectedSpec].toggles["Special"]
        br.player.mode.tierseven = br.data.settings[br.selectedSpec].toggles["Tierseven"]
        br.player.mode.nobte = br.data.settings[br.selectedSpec].toggles["NoBTE"]
--------------
--- Locals ---
--------------
        if profileStop == nil then profileStop = false end
        local attacktar                                     = UnitCanAttack("target","player")
        local charges                                       = br.player.charges
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local cd                                            = br.player.cd
        local combo, comboDeficit, comboMax                 = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
        local combospend                                    = ComboMaxSpend()
        local cTime                                         = getCombatTime()
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local gcd                                           = getSpellCD(61304)
        local gcdMax                                        = br.player.gcdMax
        local hastar                                        = GetObjectExists("target")
        local healPot                                       = getHealthPot()
        local inCombat                                      = isInCombat("player")
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local mode                                          = br.player.mode
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
        local units                                         = br.player.units
        local lootDelay                                     = getOptionValue("LootDelay")

        dotHPLimit = getOptionValue("BF HP Limit") * 10000

        local forcekill = {
                        [120651] = true -- explosive orb
                        --[141851] = true, -- ghuunies
                        --[144081] = true
                        } 
        
--______________________________________
    enemies.get(20)
    enemies.get(20,"player",true)
    enemies.get(30)

    local function ttd(unit)
        if UnitIsPlayer(unit) then return 999 end
        local ttdSec = getTTD(unit)
        if getOptionCheck("Enhanced Time to Die") then return ttdSec end
        if ttdSec == -1 then return 999 end
        return ttdSec
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
        if talent.DeeperStratagem then dsmod = 1.05 else dsmod = 1 end 
        return(
                apMod * 5 * rtcoef * auramult * dsmod * versmult
                )
    end

    local function isTotem(unit)
        local eliteTotems = { -- totems we can dot
            [125977] = "Reanimate Totem",
            [127315] = "Reanimate Totem",
            [146731] = "Zombie Dust Totem"
        }
        local creatureType = UnitCreatureType(unit)
        local objectID = GetObjectID(unit)
        if creatureType ~= nil and eliteTotems[objectID] == nil then
            if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then return true end
        end
        return false
    end

    local function noDotCheck(unit)
        if isChecked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then return true end
        if isTotem(unit) then return true end
        local unitCreator = UnitCreator(unit)
        if unitCreator ~= nil and UnitIsPlayer(unitCreator) ~= nil and UnitIsPlayer(unitCreator) == true then return true end
        if GetObjectID(unit) == 137119 and getBuffRemain(unit, 271965) > 0 then return true end
        return false
    end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function clearTable(t)
        local count = #t
        for i=0, count do t[i]=nil end
    end

    clearTable(enemyTable5)
    clearTable(enemyTable20)
    clearTable(enemyTable30)
    -- ?? mfd nill
    if #enemies.yards30 > 0 then
        local highestHP
        local lowestHP
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if (not noDotCheck(thisUnit) or GetUnitIsUnit(thisUnit, "target")) and not UnitIsDeadOrGhost(thisUnit) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                enemyUnit.distance = getDistance(thisUnit)
                enemyUnit.hpabs = UnitHealth(thisUnit)
                enemyUnit.facing = getFacing("player",thisUnit)
                tinsert(enemyTable30, enemyUnit)
                if highestHP == nil or highestHP < enemyUnit.hpabs then highestHP = enemyUnit.hpabs end
                if lowestHP == nil or lowestHP > enemyUnit.hpabs then lowestHP = enemyUnit.hpabs end
                if enemyTable30.lowestTTDUnit == nil or enemyTable30.lowestTTD > enemyUnit.ttd then
                    enemyTable30.lowestTTDUnit = enemyUnit.unit
                    enemyTable30.lowestTTD = enemyUnit.ttd
                end
                if enemyUnit.hpabs <= rtdamage() then mfdtarget = thisUnit end
            end
        end
        if #enemyTable30 > 1 then
            for i = 1, #enemyTable30 do
                local hpNorm = (10-1)/(highestHP-lowestHP)*(enemyTable30[i].hpabs-highestHP)+10 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0/0) then hpNorm = 0 end -- NaN check
                local enemyScore = hpNorm
                if enemyTable30[i].facing then enemyScore = enemyScore + 30 end -- ??
                if enemyTable30[i].ttd > 1.5 then enemyScore = enemyScore + 5 end
                if enemyTable30[i].distance <= 5 then enemyScore = enemyScore + 30 end
                local raidTarget = GetRaidTargetIndex(enemyTable30[i].unit)
                if raidTarget ~= nil then 
                    enemyScore = enemyScore + raidTarget * 3
                    if raidTarget == 8 then enemyScore = enemyScore + 5 end
                end
                --if UnitBuffID(enemyTable30[i].unit, 277242) then enemyScore = enemyScore + 50 end -- ghuun check
                -- MfD Priority
                if UnitBuffID(enemyTable30[i].unit, 137619) then enemyScore = enemyScore + 50 end  --vend score
                enemyTable30[i].enemyScore = enemyScore
            end
            table.sort(enemyTable30, function(x,y)
                return x.enemyScore > y.enemyScore
            end)
        end
        for i = 1, #enemyTable30 do
            local thisUnit = enemyTable30[i]
            local fokIgnore = {
                [120651]=true -- Explosive
            }
            local objectID = GetObjectID(thisUnit.unit)
            if thisUnit.distance <= 20 then
                if fokIgnore[objectID] == nil and not isTotem(thisUnit.unit) then
                    tinsert(enemyTable20, thisUnit)
                    --if deadlyPoison10 and not debuff.deadlyPoison.exists(thisUnit.unit) then deadlyPoison10 = false end
                end
                --if debuff.garrote.remain(thisUnit.unit) > 0.5 then garroteCount = garroteCount + 1 end
                if thisUnit.distance <= 5 then
                    tinsert(enemyTable5, thisUnit)
                end
            end
        end
        if #enemyTable5 > 1 then
            if isChecked("|cffFF0000Force Burn Stuff") then
                table.sort(enemyTable5, function(x)
                    local thisUnit = enemyTable5[i]
                    local objectID = GetObjectID(thisUnit.unit)
                    if forcekill[objectID] ~= nil then
                        return true
                    else
                        return false
                    end
                end)
            end
            table.sort(enemyTable5, function(x)
                if mode.mfd == 3 then
                    if GetUnitIsUnit(x.unit, "mfdtarget") then
                        return true
                    else
                        return false
                    end
                end
            end)
            table.sort(enemyTable5, function(x)
                if GetUnitIsUnit(x.unit, "target") then
                    return true
                else
                    return false
                end
            end)
        end
        if inCombat and #enemyTable30 > 0 and ((GetUnitExists("target") and UnitIsDeadOrGhost("target") and not GetUnitIsUnit(enemyTable30[1].unit, "target")) or not GetUnitExists("target")) then
            TargetUnit(enemyTable30[1].unit)
        end
    end
    --Just nil fixes
    if enemyTable30.lowestTTD == nil then enemyTable30.lowestTTD = 999 end

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
        
        
        if leftCombat == nil then leftCombat = GetTime() end
        if vanishTime == nil then vanishTime = GetTime() end

        local function viabletargetcount()
            local counter = 0
            for i = 1, #enemyTable5 do
                        local thisUnit = enemyTable5[i].unit
                        if UnitHealth(thisUnit) > dotHPLimit and GetObjectID(thisUnit) ~= 120651  then 
                            counter = counter + 1
                        end
            end
            return tonumber(counter)
        end
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
            if mode.rollforone == 1 then if buff.rollTheBones.count > 0 then return false end
            elseif traits.snakeeyes.rank > 0 then
                    if traits.snakeeyes.rank >= 2 and (buff.snakeeeyes.stack() >= 2 - (buff.broadside.exists() and 1 or 0)) then
                        return false
                    elseif buff.rollTheBones.count < 2 or (traits.snakeeyes.rank >= 3 and buff.rollTheBones.count < 5) then
                        return true
                    end
            elseif traits.deadshot.rank > 0 or traits.aceupyoursleeve.rank > 0 then 
                return (buff.rollTheBones.count < 2 and (buff.loadedDice.exists() or (buff.ruthlessPrecision.remain() <= br.player.cd.betweenTheEyes.remain()))) and true or false
            --rtb_reroll,value=rtb_buffs<2&(buff.loaded_dice.up|!buff.grand_melee.up&!buff.ruthless_precision.up)
            else return (buff.rollTheBones.count < 2 and (buff.loadedDice.exists() or (not buff.grandMelee.exists() and not buff.ruthlessPrecision.exists()))) and true or false
            end
        end
        --actions+=/variable,name=ambush_condition,value=combo_points.deficit>=2+2*(talent.ghostly_strike.enabled&cooldown.ghostly_strike.remains<1)+buff.broadside.up&energy>60&!buff.skull_and_crossbones.up

        local function ambushCondition()
            if comboDeficit >= 2 + 2 * ((talent.ghostlyStrike and cd.ghostlyStrike.remain() < 1) and 1 or 0) + (buff.broadside.exists() and 1 or 0) and power > 60 and not buff.skullAndCrossbones.exists()
                then
            return true
            else return false
            end
        end

        local function bladeFlurrySync()
            return not mode.bladeflurry == 1 or viabletargetcount() < 2 or buff.bladeFlurry.exists()
        end
        -- finish,if=combo_points>=cp_max_spend-(buff.broadside.up+buff.opportunity.up)*(talent.quick_draw.enabled&(!talent.marked_for_death.enabled|cooldown.marked_for_death.remains>1))

-- # Finish at maximum CP. Substract one for each Broadside and Opportunity when Quick Draw is selected and MfD is not ready after the next second.
-- actions+=/call_action_list,name=finish,if=combo_points>=cp_max_spend-(buff.broadside.up+buff.opportunity.up)*(talent.quick_draw.enabled&(!talent.marked_for_death.enabled|cooldown.marked_for_death.remains>1))
        local function shouldFinish()
            if talent.quickDraw then
                if buff.broadside.exists() then
                    combospend = combospend - 1
                end
                if buff.opportunity.exists() then
                    combospend = combospend - 1
                end
            end
            if combo >= combospend  then
                return true
            else 
                return false
            end
        end

            
        local function cast5yards(skill,stuff)
                for i = 1, #enemyTable5 do
                        local thisUnit = enemyTable5[i].unit
                        if stuff then
                            if cast[skill](thisUnit) then return true end
                        end
                end
        end
        --print(rtdamage())
--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        --[[local function actionList_Extras()
        end -- End Action List - Extras]]
    -- Action List - DefensiveModes
        local function actionList_Defensive()
            
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() and not stealth then
            for i=1, #enemies.yards20 do
                    local thisUnit = enemies.yards20[i]
                    local distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) and hasThreat(thisUnit) then
                        if distance < 5 then
                            -- kick
                            if isChecked("Kick") then
                                if cast.kick(thisUnit) then return true end
                            end
                            if cd.kick.remain() ~= 0 then
                                if isChecked("Gouge") and getFacing(thisUnit,"player") and isChecked("AutoGouge") then
                                    if cast.gouge(thisUnit) then return true end
                                end
                            end
                        end
                        -- Blind
                        if (cd.kick.remain() ~= 0 and cd.gouge.remain() ~= 0) or (distance >= 5 and distance < 15) then
                            if isChecked("Blind") then
                                if cast.blind(thisUnit) then return true end
                            end
                        end
                        -- Between the Eyes
                        if (((cd.kick.remain() ~= 0 and cd.gouge.remain() ~= 0) or distance >= 5) and (cd.blind.remain() ~= 0 or level < 38 or distance >= 15)) then
                            if isChecked("Between the Eyes") then
                                if cast.betweenTheEyes(thisUnit) then print("543"); return true end
                            end
                        end
                    end
                end
            end -- End Interrupt and No Stealth Check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            local startTime = debugprofilestop()
        -- Trinkets
            if isChecked("Trinkets") then
                if hasBloodLust() or (ttd("target") <= 20 and isBoss("target"))  then
                    if canUseItem(13) then
                        useItem(13)
                    end
                    if canUseItem(14) then
                        useItem(14)
                    end
                end
            end
    
    -- Non-NE Racial
            --blood_fury
            --berserking
            --arcane_torrent,if=energy.deficit>40
            -- if isChecked("Racial") and (race == "Orc" or race == "Troll" or (race == "BloodElf" and powerDeficit > 15 + powerRegen)) then
            --     if castSpell("player",racial,false,false,false) then return true end
            -- end

            if mode.special == 1 and not buff.adrenalineRush.exists() and ttd("target") >= gcd then
                if cast.adrenalineRush("player") then return true end
            end    

            if bladeFlurrySync() and comboDeficit >= (1 + (buff.broadside.exists() and 1 or 0)) then
                if cast.ghostlyStrike("target") then return true end
            end

            if mode.tierseven == 1 and bladeFlurrySync() and (ttm > 5 or power < 15) then
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
            if not inCombat and not stealth then
                if isChecked("Stealth") and (not IsResting() or isDummy("target")) then
                    if getOptionValue("Stealth") == 1 then
                        if cast.stealth("player") then return true end
                    end
                    if #enemies.yards20 > 0 and getOptionValue("Stealth") == 2 and not IsResting() and GetTime()-leftCombat > lootDelay then
                        for i=1, #enemies.yards20 do
                            local thisUnit = enemies.yards20[i]
                            if UnitIsEnemy(thisUnit,"player") or isDummy("target") then
                                if cast.stealth("player") then return true end
                            end
                        end
                    end
                end
            end
        end -- End Action List - PreCombat
    -- Action List - Finishers
        local function actionList_Finishers() 
            local startTime = debugprofilestop()                          

            -- actions.finish=between_the_eyes,if=buff.ruthless_precision.up|(azerite.deadshot.rank>=2&buff.roll_the_bones.up)
            if mode.nobte == 1 and (buff.ruthlessPrecision.exists() or ((traits.deadshot.rank > 0 or traits.aceupyoursleeve.rank > 0) and buff.rollTheBones.count > 0)) then
                --print("626")
                cast5yards("betweenTheEyes",true)
            end

            
            if talent.sliceAndDice then
                if buff.sliceAndDice.remain() < ttd("target") and buff.sliceAndDice.refresh() then
                    if cast.sliceAndDice("player") then return true end
                end
            end

            if not talent.sliceAndDice then
                if buff.rollTheBones.remain < 3 or rtbReroll()then
                    if cast.rollTheBones("player") then return true end
                end
            end

            if mode.nobte == 1 and (traits.deadshot.rank > 0 or traits.aceupyoursleeve.rank > 0) then
                --print("643")
                 cast5yards("betweenTheEyes",true)
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

            if comboDeficit >= (1 + (buff.broadside.exists() and 1 or 0) + (talent.quickDraw and 1 or 0)) and buff.opportunity.exists() and (buff.wits.stack() < 25 or buff.deadShot.exists()) then
                cast5yards("pistolShot",true)
            end

            cast5yards("sinisterStrike",true)

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

        local function actionList_Stun()
            local stunList = { -- Stolen from feng pala
            [274400] = true, [274383] = true, [257756] = true, [276292] = true, [268273] = true, [256897] = true, [272542] = true, [272888] = true, [269266] = true, [258317] = true, [258864] = true,
            [259711] = true, [258917] = true, [264038] = true, [253239] = true, [269931] = true, [270084] = true, [270482] = true, [270506] = true, [270507] = true, [267433] = true, [267354] = true,
            [268702] = true, [268846] = true, [268865] = true, [258908] = true, [264574] = true, [272659] = true, [272655] = true, [267237] = true, [265568] = true, [277567] = true, [265540] = true
            }
            for i=1, #enemies.yards20 do
                local thisUnit = enemies.yards20[i]
                local distance = getDistance(thisUnit)
                if (isChecked("AutoBtE") and combo > 0) or (isChecked("AutoGouge") and getFacing(thisUnit,"player") and distance <= 5) or (isChecked("AutoBlind") and distance <= 20) then
                    local interruptID, castStartTime
                    if UnitCastingInfo(thisUnit) then
                        castStartTime = select(4,UnitCastingInfo(thisUnit))
                        interruptID = select(9,UnitCastingInfo(thisUnit))
                    elseif UnitChannelInfo(thisUnit) then
                        castStartTime = select(4,UnitChannelInfo(thisUnit))
                        interruptID = select(7,GetSpellInfo(UnitChannelInfo(thisUnit)))
                    end
                    if interruptID ~=nil and stunList[interruptID] and (GetTime()-(castStartTime/1000)) > 0.1 and combo > 0 then
                        if cast.betweenTheEyes(thisUnit) then print("699"); return true end
                    end
                    if interruptID ~=nil and stunList[interruptID] and (GetTime()-(castStartTime/1000)) > 0.1 and getFacing(thisUnit,"player") then
                        if cast.gouge(thisUnit) then return true end
                    end
                    if interruptID ~=nil and stunList[interruptID] and (GetTime()-(castStartTime/1000)) > 0.1 and (distance > 5 or cd.betweenTheEyes.remain() > 1.5) then
                        if cast.blind(thisUnit) then return true end
                    end
                end
            end
        end
        

        local function actionList_Opener()                    
        end

        local function MythicStuff()

            local cloakPlayerlist = {
            }  

            local evasionPlayerlist = {
            }

            local cloaklist = {
            }

            local evasionlist = {
            }

            local feintlist = {
            }   

            if eID then
                local bosscount = 0
                for i = 1, 5 do
                    if GetUnitExists("boss"..i) then
                        bosscount = bosscount + 1
                    end
                end
                for i = 1, bosscount do
                    if UnitCastingInfo("boss"..i) then
                        BossSpellEnd,_,_,_,BossSpell = select(5,UnitCastingInfo("boss"..i))
                        --print(BossSpellEnd)
                    elseif UnitChannelInfo("boss"..i) then
                        BossSpellEnd = select(4,UnitChannelInfo("boss"..i))
                        BossSpell = select(7,GetSpellInfo(UnitChannelInfo("boss"..i)))
                        --print(BossSpell)
                    end
                    if BossSpellEnd ~= nil and BossSpellEnd/1000 <= GetTime() + 2 then
                        if GetUnitIsUnit("player","boss"..i.."target") then
                            if BossSpell ~= nil and cloakPlayerlist[BossSpell] then
                                if cast.cloakOfShadows("player") then return true end
                            elseif BossSpell ~= nil and evasionPlayerlist[BossSpell] then
                                if cast.riposte("player") then return true end
                            end
                        else
                            if BossSpell ~= nil and cloaklist[BossSpell] then
                                if cast.cloakOfShadows("player") then return true end
                            elseif BossSpell ~= nil and evasionlist[BossSpell] then
                                if cast.riposte("player") then return true end
                            elseif BossSpell ~= nil and feintlist[BossSpell] then
                                if cast.pool.feint("player") and not cd.feint.exists() then return true end
                                if cast.feint("player") then return true end
                            end
                        end
                    end
                end
            end
        end
        --`````````````````````````````````````````````````STARTING SHIT```````````````````````````````````````````````
        if cast.last.vanish() and (br.player.instance=="party" or br.player.instance=="raid" or isDummy("target")) then
            if cast.ambush("target") then return true end
        end

        if actionList_PreCombat() then return end

        if (inCombat and profileStop == true) or pause() or (IsMounted() or IsFlying()) or mode.rotation == 2 then
            return true
        else

        if isChecked("Ambush") then
            if getDistance("target") <= 5 and stealth then
                if cast.ambush("target") then return true end
            end
        end
            --print(rtbReroll())
            --print(br.player.power.energy.ttm())
            -- if cast.sinisterStrike() then return end
           -- print(getDistance("target"))
            --print(inRange(193315,"target"))
           -- print(IsSpellInRange(193315,"target"))
            --if castSpell("target",193315,true,false,false,true,false,true,false,false) then return end
            --RunMacroText("/cast Коварный удар")
        --if actionList_Extras() then return end

        -- if actionList_Defensive() then return end

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


        if mode.bladeflurry == 1 and buff.rollTheBones.remain >= 5 and viabletargetcount() >= 2 and not buff.bladeFlurry.exists() and charges.bladeFlurry.frac() >= 1.5 then
            if cast.bladeFlurry("player") then return true end
        end

        if inCombat and not stealth then

            if isValidUnit("target") and getDistance("target") <= 5 and getFacing("player", "target")  then
                StartAttack()
            end

            if mode.stun == 1 then
                if actionList_Stun() then return end
            end

            if mode.mfd == 3 and combo < combospend and cd.markedForDeath.remain() <= 0 then
                    if mfdtarget ~= nil and not UnitIsDeadOrGhost(mfdtarget) then
                        if cast.markedForDeath(mfdtarget) then end
                    end
            end



            if not stealthingAll then
                if actionList_Interrupts() then return end
            end

            if ambushCondition() and cd.vanish.remain() <= 0.2 and getDistance("target") <= 5 and mode.special == 1 and isChecked("Vanish") and (not solo or isDummy("target")) then
                if gcd > 0.2 then return true end
                if cast.pool.ambush() then return true end
                if CastSpellByID(1856) then return true end
            end

            if mode.special == 1 or mode.tierseven == 1 then
                if actionList_Cooldowns() then return end
            end

            -- if stealthingAll then
            --     if actionList_Stealth() then return end
            -- end

                if mode.mfd == 1 and cd.markedForDeath.remain() <= 0.2 then                            
                    if comboDeficit >= combospend - 1 then
                        CastSpellByID(137619,"target")
                        return true
                    end
                end
                if mode.mfd == 2 and cd.markedForDeath.remain() <= 0.2 then
                        local thisUnit = enemies.yards30[i]
                        if ttd(thisUnit) < comboDeficit * getOptionValue("MFD Sniping") then
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
local id = 260
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
