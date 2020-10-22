local rotationName = "Kink v0.0.1"

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "This is the only mode for this rotation.", highlight = 0, icon = br.player.spell.whirlwind }
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.berserk },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.berserk },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.berserk }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "No Defensives", tip = "This rotation does not use defensives.", highlight = 1, icon = br.player.spell.enragedRegeneration }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "No Interrupts", tip = "This rotation does not use interrupts.", highlight = 1, icon = br.player.spell.pummel }
    };
    CreateButton("Interrupt",4,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Trinkets
            br.ui:createCheckbox(section,"Presence of Mind")

        -- Mirror Image
            br.ui:createCheckbox(section,"Mirror Image")

        -- Arcane Power
            br.ui:createCheckbox(section,"Arcane Power")

        -- Charged Up
            br.ui:createCheckbox(section,"Charged Up")

        -- Charged Up
            br.ui:createCheckbox(section,"Rune of Power")

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
    if br.timer:useTimer("debugArcane", 0.1) then
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
--------------
--- Locals ---
--------------
        local arcaneCharges                                 = br.player.power.arcaneCharges.amount()
        local arcaneChargesMax                              = br.player.power.arcaneCharges.max()
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local castable                                      = br.player.cast.debug
        local combatTime                                    = getCombatTime()
        local inCombat                                      = isInCombat("player")
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local friendly                                      = GetUnitIsFriend("target", "player")
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local moving                                        = isMoving("player") ~= false or br.player.moving
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local ui                                            = br.player.ui
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.ui.mode
        local perk                                          = br.player.perk   
        local hasPet                                        = IsPetActive()     
        local playerCasting                                 = UnitCastingInfo("player")
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local deadtar, attacktar, hastar, playertar = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
        local hasMouse                                      = GetObjectExists("mouseover")
        local php                                           = br.player.health
        local pullTimer                                     = br.DBM:getPulltimer()
        local power                                         = br.player.power.mana.amount()
        local powerPercent                                  = br.player.power.mana.percent()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttm                                           = br.player.timeToMax
        local units                                         = br.player.units
        local trait                                         = br.player.traits
        local inInstance                                    = br.player.unit.instance() == "party"
        local inRaid                                        = br.player.unit.instance() == "raid"
        local manaPercent                                   = br.player.power.mana.percent()
        local lastSpell                                     = lastSpellCast
        local targetUnit                                    = nil
        local thp                                           = getHP("target")
        local travelTime                                    = getDistance("target") / 50 --Ice lance
        local ttm                                           = br.player.power.mana.ttm()
        local hasteAmount                                   = GetHaste() / 100
        local solo                                          = br.player.instance == "none"
        local units                                         = br.player.units
        local use                                           = br.player.use
        local pet                                           = br.player.pet.list
        local hasPet                                        = IsPetActive()
        local equiped                                       = br.player.equiped
        
        units.get(40)
        enemies.get(15, "target")
        enemies.get(8, "target")
        enemies.get(10)
        enemies.get(40)
        var_ap_minimum_mana_pct = 30
       --variable,name=aoe_totm_charges,op=set,value=2
        var_aoe_totm_charges = 2

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        --Player cast remain
        local playerCastRemain = 0
        if UnitCastingInfo("player") then playerCastRemain = (select(5, UnitCastingInfo("player")) / 1000) - GetTime() end

        -- spellqueue ready
        local function spellQueueReady()
            --Check if we can queue cast
            local castingInfo = {UnitCastingInfo("player")}
            if castingInfo[5] then
                if (GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow")))/1000)) < 0 then
                    return false
                end
            end
            return true
        end
            -- Pet Stance
        local function petFollowActive()
            for i = 1, NUM_PET_ACTION_SLOTS do
                local name, _, _,isActive = GetPetActionInfo(i)
                if isActive and name == "PET_ACTION_FOLLOW" then
                    return true
                end
            end
            return false
        end   
        
         -- Ice Floes
        if moving and talent.iceFloes and buff.iceFloes.exists() then
            moving = false
        end

        --rop notice
        if not ropNotice and talent.runeOfPower then
            print("Rune Of Power talent not supported in rotation yet, use manually")
            ropNotice = true
        elseif ropNotice and not talent.runeOfPower then
            ropNotice = false
        end

        units.get(40)
        enemies.get(10, "target", true)
        enemies.get(40, nil, nil, nil, spell.frostbolt)

        local dispelDelay = 1.5
        if isChecked("Dispel delay") then
            dispelDelay = getValue("Dispel delay")
        end

        if profileStop == nil or not inCombat then
            profileStop = false
        end

        --ttd
        local function ttd(unit)
            local ttdSec = getTTD(unit)
            if getOptionCheck("Enhanced Time to Die") then
                return ttdSec
            end
            if ttdSec == -1 then
                return 999
            end
            return ttdSec
        end

        local function calcHP(unit)
        local thisUnit = unit.unit
        local hp = UnitHealth(thisUnit)
        if br.unlocked then --EasyWoWToolbox ~= nil then
            local castID, _, castTarget = UnitCastID("player")
            if castID and castTarget and GetUnitIsUnit(unit, castTarget) and playerCasting then
                hp = hp - calcDamage(castID, unit)
            end
            for k, v in pairs(spell.abilities) do
                if br.InFlight.Check(v, thisUnit) then
                    hp = hp - calcDamage(v, unit)
                end
            end
            -- if UnitIsVisible("pet") then
            --     castID, _, castTarget = UnitCastID("pet")
            --     if castID and castTarget and UnitIsUnit(unit, castTarget) and UnitCastingInfo("pet") then
            --         local castRemain = (select(5, UnitCastingInfo("pet")) / 1000) - GetTime()
            --         if castRemain < 0.5 then
            --             hp = hp - calcDamage(castID, unit)
            --         end
            --     end
            -- end
        end
        return hp
    end

        local function spellstealCheck(unit)
        local i = 1
        local buffName, _, _, _, duration, expirationTime, _, isStealable, _, spellId = UnitBuff(unit, i)
        while buffName do
            if doNotSteal[spellId] then
                return false
            elseif isStealable and (GetTime() - (expirationTime - duration)) > dispelDelay then
                return true
            end
            i = i + 1
            buffName, _, _, _, duration, expirationTime, _, isStealable, _, spellId = UnitBuff(unit, i)            
        end
        return false
    end
        -- Blacklist enemies
        local function isTotem(unit)
        local eliteTotems = {
            -- totems we can dot
            [125977] = "Reanimate Totem",
            [127315] = "Reanimate Totem",
            [146731] = "Zombie Dust Totem"
        }
        local creatureType = UnitCreatureType(unit)
        local objectID = GetObjectID(unit)
        if creatureType ~= nil and eliteTotems[objectID] == nil then
            if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then
                return true
            end
        end
        return false
    end

        local noDotUnits = {
        [135824] = true, -- Nerubian Voidweaver
        [139057] = true, -- Nazmani Bloodhexer
        [129359] = true, -- Sawtooth Shark
        [129448] = true, -- Hammer Shark
        [134503] = true, -- Silithid Warrior
        [137458] = true, -- Rotting Spore
        [139185] = true, -- Minion of Zul
        [120651] = true -- Explosive
    }

            local function noDotCheck(unit)
        if isChecked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then
            return true
        end
        if isTotem(unit) then
            return true
        end
        local unitCreator = UnitCreator(unit)
        if unitCreator ~= nil and UnitIsPlayer(unitCreator) ~= nil and UnitIsPlayer(unitCreator) == true then
            return true
        end
        if GetObjectID(unit) == 137119 and getBuffRemain(unit, 271965) > 0 then
            return true
        end
        return false
    end

    local standingTime = 0
    if DontMoveStartTime then
        standingTime = GetTime() - DontMoveStartTime
    end

    --wipe timers table
    if timersTable then
        wipe(timersTable)
    end

    --local enemies table with extra data
    local facingUnits = 0
    local enemyTable40 = {}
    if #enemies.yards40 > 0 then
        local highestHP
        local lowestHP
        local distance20Max
        local distance20Min
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if (not noDotCheck(thisUnit) or GetUnitIsUnit(thisUnit, "target")) and not UnitIsDeadOrGhost(thisUnit) and (mode.rotation ~= 2 or GetUnitIsUnit(thisUnit, "target")) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                enemyUnit.distance = getDistance(thisUnit)
                enemyUnit.distance20 = math.abs(enemyUnit.distance - 20)
                enemyUnit.hpabs = UnitHealth(thisUnit)
                enemyUnit.facing = getFacing("player", thisUnit)
                if getOptionValue("APL Mode") == 2 then
                    enemyUnit.frozen = isFrozen(thisUnit)
                end
                enemyUnit.calcHP = calcHP(enemyUnit)
                tinsert(enemyTable40, enemyUnit)
                if enemyUnit.facing then
                    facingUnits = facingUnits + 1
                end
                if highestHP == nil or highestHP < enemyUnit.hpabs then
                    highestHP = enemyUnit.hpabs
                end
                if lowestHP == nil or lowestHP > enemyUnit.hpabs then
                    lowestHP = enemyUnit.hpabs
                end
                if distance20Max == nil or distance20Max < enemyUnit.distance20 then
                    distance20Max = enemyUnit.distance20
                end
                if distance20Min == nil or distance20Min > enemyUnit.distance20 then
                    distance20Min = enemyUnit.distance20
                end
            end
        end
        if #enemyTable40 > 1 then
            for i = 1, #enemyTable40 do
                local hpNorm = (5 - 1) / (highestHP - lowestHP) * (enemyTable40[i].hpabs - highestHP) + 5 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0 / 0) then
                    hpNorm = 0
                end -- NaN check
                local distance20Norm = (3 - 1) / (distance20Max - distance20Min) * (enemyTable40[i].distance20 - distance20Min) + 1 -- normalization of distance 20, low is good
                if distance20Norm ~= distance20Norm or tostring(distance20Norm) == tostring(0 / 0) then
                    distance20Norm = 0
                end -- NaN check
                local enemyScore = hpNorm + distance20Norm
                if enemyTable40[i].facing then
                    enemyScore = enemyScore + 10
                end
                if enemyTable40[i].ttd > 1.5 then
                    enemyScore = enemyScore + 10
                end
                enemyTable40[i].enemyScore = enemyScore
            end
            table.sort(
                enemyTable40,
                function(x, y)
                    return x.enemyScore > y.enemyScore
                end
            )
        end
        if isChecked("Auto Target") and #enemyTable40 > 0 and ((GetUnitExists("target") and (UnitIsDeadOrGhost("target") or (targetUnit and targetUnit.calcHP < 0)) and not GetUnitIsUnit(enemyTable40[1].unit, "target")) or not GetUnitExists("target")) then
            TargetUnit(enemyTable40[1].unit)
            return true
        end
        for i = 1, #enemyTable40 do
            if UnitIsUnit(enemyTable40[i].unit, "target") then
                targetUnit = enemyTable40[i]
            end
        end
    end

    -- spell usable check
    local function spellUsable(spellID)
        if isKnown(spellID) and not select(2, IsUsableSpell(spellID)) and getSpellCD(spellID) == 0 then
            return true
        end
        return false
    end

        
    --blizzard check
    local blizzardUnits = 0
    for i = 1, #enemies.yards10tnc do
        local thisUnit = enemies.yards10tnc[i]
        if ttd(thisUnit) > 4 then
            blizzardUnits = blizzardUnits + 1
        end
    end

    --Clear last cast table ooc to avoid strange casts
    if not inCombat and #br.lastCast.tracker > 0 then
        wipe(br.lastCast.tracker)
    end

    ---Target move timer
    if lastTargetX == nil then
        lastTargetX, lastTargetY, lastTargetZ = 0, 0, 0
    end
    if br.timer:useTimer("targetMove", 0.8) or combatTime < 0.2 then
        if UnitIsVisible("target") then
            local currentX, currentY, currentZ = ObjectPosition("target")
            local targetMoveDistance = math.sqrt(((currentX - lastTargetX) ^ 2) + ((currentY - lastTargetY) ^ 2) + ((currentZ - lastTargetZ) ^ 2))
            lastTargetX, lastTargetY, lastTargetZ = ObjectPosition("target")
            if targetMoveDistance < 3 then
                targetMoveCheck = true
            else
                targetMoveCheck = false
            end
        end
    end

    --Tank move check for aoe
    local tankMoving = false
    if inInstance then
        for i = 1, #br.friend do
            if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and isMoving(br.friend[i].unit) then
                tankMoving = true
            end
        end
    end

        
    function mageDamage()
        local X,Y,Z = ObjectPosition("player")
        print(Z)
        Z = select(3, TraceLine(X, Y, Z + 10, X, Y, Z - 10, 0x110))
        print(Z)
    end

    -- Opener Variables
    if not inCombat and not GetObjectExists("target") then
        fbInc = false
    end

    if Player:Covenant() ~= "Night Fae" then var_barrage_mana_pct = 80 else var_barrage_mana_pct = 90 end


--------------------
--- Action Lists ---
--------------------
    --[[
actions.aoe=use_mana_gem,if=(talent.enlightened.enabled&mana.pct<=80&mana.pct>=65)|(!talent.enlightened.enabled&mana.pct<=85)
actions.aoe+=/lights_judgment,if=buff.arcane_power.down
actions.aoe+=/bag_of_tricks,if=buff.arcane_power.down
actions.aoe+=/call_action_list,name=items,if=buff.arcane_power.up
actions.aoe+=/potion,if=buff.arcane_power.up
actions.aoe+=/berserking,if=buff.arcane_power.up
actions.aoe+=/blood_fury,if=buff.arcane_power.up
actions.aoe+=/fireblood,if=buff.arcane_power.up
actions.aoe+=/ancestral_call,if=buff.arcane_power.up
actions.aoe+=/time_warp,if=runeforge.temporal_warp.equipped
actions.aoe+=/frostbolt,if=runeforge.disciplinary_command.equipped&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_frost.down&(buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down)&cooldown.touch_of_the_magi.remains=0&(buff.arcane_charge.stack<=variable.aoe_totm_charges&((talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd&cooldown.arcane_power.remains>variable.totm_max_delay)|(!talent.rune_of_power.enabled&cooldown.arcane_power.remains>variable.totm_max_delay)|cooldown.arcane_power.remains<=gcd))
actions.aoe+=/fire_blast,if=(runeforge.disciplinary_command.equipped&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_fire.down&prev_gcd.1.frostbolt)|(runeforge.disciplinary_command.equipped&time=0)
actions.aoe+=/frost_nova,if=runeforge.grisly_icicle.equipped&cooldown.arcane_power.remains>30&cooldown.touch_of_the_magi.remains=0&(buff.arcane_charge.stack<=variable.aoe_totm_charges&((talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd&cooldown.arcane_power.remains>variable.totm_max_delay)|(!talent.rune_of_power.enabled&cooldown.arcane_power.remains>variable.totm_max_delay)|cooldown.arcane_power.remains<=gcd))
actions.aoe+=/frost_nova,if=runeforge.grisly_icicle.equipped&cooldown.arcane_power.remains=0&(((cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=variable.aoe_totm_charges))&buff.rune_of_power.down)
actions.aoe+=/touch_of_the_magi,if=runeforge.siphon_storm.equipped&prev_gcd.1.evocation
actions.aoe+=/arcane_power,if=runeforge.siphon_storm.equipped&(prev_gcd.1.evocation|prev_gcd.1.touch_of_the_magi)
actions.aoe+=/evocation,if=time>30&runeforge.siphon_storm.equipped&buff.arcane_charge.stack<=variable.aoe_totm_charges&cooldown.touch_of_the_magi.remains=0&cooldown.arcane_power.remains<=gcd
actions.aoe+=/evocation,if=time>30&runeforge.siphon_storm.equipped&cooldown.arcane_power.remains=0&(((cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=variable.aoe_totm_charges))&buff.rune_of_power.down),interrupt_if=buff.siphon_storm.stack=buff.siphon_storm.max_stack,interrupt_immediate=1
actions.aoe+=/mirrors_of_torment,if=(cooldown.arcane_power.remains>45|cooldown.arcane_power.remains<=3)&cooldown.touch_of_the_magi.remains=0&(buff.arcane_charge.stack<=variable.aoe_totm_charges&((talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd&cooldown.arcane_power.remains>5)|(!talent.rune_of_power.enabled&cooldown.arcane_power.remains>5)|cooldown.arcane_power.remains<=gcd))
actions.aoe+=/radiant_spark,if=cooldown.touch_of_the_magi.remains>variable.rs_max_delay&cooldown.arcane_power.remains>variable.rs_max_delay&(talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd|talent.rune_of_power.enabled&cooldown.rune_of_power.remains>variable.rs_max_delay|!talent.rune_of_power.enabled)&buff.arcane_charge.stack<=variable.aoe_totm_charges&debuff.touch_of_the_magi.down
actions.aoe+=/radiant_spark,if=cooldown.touch_of_the_magi.remains=0&(buff.arcane_charge.stack<=variable.aoe_totm_charges&((talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd&cooldown.arcane_power.remains>variable.totm_max_delay)|(!talent.rune_of_power.enabled&cooldown.arcane_power.remains>variable.totm_max_delay)|cooldown.arcane_power.remains<=gcd))
actions.aoe+=/radiant_spark,if=cooldown.arcane_power.remains=0&(((cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=variable.aoe_totm_charges))&buff.rune_of_power.down)
actions.aoe+=/deathborne,if=cooldown.arcane_power.remains=0&(((cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=variable.aoe_totm_charges))&buff.rune_of_power.down)
actions.aoe+=/touch_of_the_magi,if=buff.arcane_charge.stack<=variable.aoe_totm_charges&((talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd&cooldown.arcane_power.remains>variable.totm_max_delay)|(!talent.rune_of_power.enabled&cooldown.arcane_power.remains>variable.totm_max_delay)|cooldown.arcane_power.remains<=gcd)
actions.aoe+=/arcane_power,if=((cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=variable.aoe_totm_charges))&buff.rune_of_power.down
actions.aoe+=/rune_of_power,if=buff.rune_of_power.down&((cooldown.touch_of_the_magi.remains>20&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=variable.aoe_totm_charges))&(cooldown.arcane_power.remains>15|debuff.touch_of_the_magi.up)
actions.aoe+=/presence_of_mind,if=buff.deathborne.up&debuff.touch_of_the_magi.up&debuff.touch_of_the_magi.remains<=buff.presence_of_mind.max_stack*action.arcane_blast.execute_time
actions.aoe+=/arcane_blast,if=buff.deathborne.up&((talent.resonance.enabled&active_enemies<4)|active_enemies<5)
actions.aoe+=/supernova
actions.aoe+=/arcane_orb,if=buff.arcane_charge.stack=0
actions.aoe+=/nether_tempest,if=(refreshable|!ticking)&buff.arcane_charge.stack=buff.arcane_charge.max_stack
actions.aoe+=/shifting_power,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&cooldown.arcane_power.remains>0&cooldown.touch_of_the_magi.remains>0&(!talent.rune_of_power.enabled|(talent.rune_of_power.enabled&cooldown.rune_of_power.remains>0))
actions.aoe+=/arcane_missiles,if=buff.clearcasting.react&runeforge.arcane_infinity.equipped&talent.amplification.enabled&active_enemies<6
actions.aoe+=/arcane_missiles,if=buff.clearcasting.react&runeforge.arcane_infinity.equipped&active_enemies<4
actions.aoe+=/arcane_explosion,if=buff.arcane_charge.stack<buff.arcane_charge.max_stack
actions.aoe+=/arcane_explosion,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&prev_gcd.1.arcane_barrage
actions.aoe+=/arcane_barrage,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack
actions.aoe+=/evocation,interrupt_if=mana.pct>=85,interrupt_immediate=1
    --]]
local function actionList_AoE()


end


    local function actionList_Interrupts()
        if useInterrupts() and cd.counterspell.remain() == 0 then
            if not isChecked("Do Not Cancel Cast") or not playerCasting then
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                        if cast.counterspell(thisUnit) then
                            return
                        end
                    end
                end
            end
        end
    end    

local function actionList_Defensive()
        if useDefensive() then
            --Ice Block
            if isChecked("Ice Block") and php <= getOptionValue("Ice Block") and cd.iceBlock.remain() <= gcd then
                if UnitCastingInfo("player") then
                    SpellStopCasting()
                end
                if cast.iceBlock("player") then
                    return true
                end
            end

            --Pot/Stone
            if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned") and inCombat and (hasHealthPot() or hasItem(5512)) then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                end
            end

            --Heirloom Neck
            if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                if hasEquiped(heirloomNeck) then
                    if GetItemCooldown(heirloomNeck) == 0 then
                        useItem(heirloomNeck)
                    end
                end
            end

            --Ice Barrier
            if isChecked("Ice Barrier") and not playerCasting and php <= getOptionValue("Ice Barrier") then
                if cast.iceBarrier("player") then
                    return true
                end
            end

            --Gift of the Naaru (Racial)
            if br.player.race == "Draenei"  and isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 then
                if castSpell("player", racial, false, false, false) then
                    return
                end
            end

            --Remove Curse, Yoinked from Aura balance
            if isChecked("Remove Curse") then
                if getOptionValue("Remove Curse") == 1 then
                    if canDispel("player",spell.removeCurse) then
                        if cast.removeCurse("player") then return true end
                    end
                elseif getOptionValue("Remove Curse") == 2 then
                    if canDispel("target",spell.removeCurse) then
                        if cast.removeCurse("target") then return true end
                    end
                elseif getOptionValue("Remove Curse") == 3 then
                    if canDispel("player",spell.removeCurse) then
                        if cast.removeCurse("player") then return true end
                    elseif canDispel("target",spell.removeCurse) then
                        if cast.removeCurse("target") then return true end
                    end
                elseif getOptionValue("Remove Curse") == 4 then
                    if canDispel("mouseover",spell.removeCurse) then
                        if cast.removeCurse("mouseover") then return true end
                    end
                elseif getOptionValue("Remove Curse") == 5 then
                    for i = 1, #br.friend do
                        if canDispel(br.friend[i].unit,spell.removeCurse) then
                            if cast.removeCurse(br.friend[i].unit) then return true end
                        end
                    end
                end
            end
        end
    end

local function actionList_Cooldowns()
    if useCDs() and not moving and targetUnit.ttd >= getOptionValue("Cooldowns Time to Die Limit") then

    -- actions.cooldowns+=/potion,if=prev_gcd.1.icy_veins|target.time_to_die<30
    if isChecked("Potion") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() and (cast.last.icyVeins() or ttd("target") < 30) then
        use.battlePotionOfIntellect()
         return true
    end
    -- actions.cooldowns+=/mirror_image
            if cast.mirrorImage("player") then return true end

    --racials
    if isChecked("Racial") then
        if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" or race == "Troll" then
            if race == "LightforgedDraenei" then
                if cast.racial("target","ground") then return true end
            else
                if cast.racial("player") then return true end
                end
            end
        end
    end
end

local function actionList_Movement()
--actions.movement=blink_any,if=movement.distance>=10
--ctions.movement+=/presence_of_mind
--actions.movement+=/arcane_missiles,if=movement.distance<10
--actions.movement+=/arcane_orb
--actions.movement+=/fire_blast
end


local function actionList_Final_Burn()
    --arcane_missiles,if=buff.clearcasting.react,chain=1
    if cast.able.arcaneMissiles() 
    and buff.clearcasting.exists() then 
        if cast.arcaneMissiles() then br.addonDebug("Cast Arcane Missiles (Final Burn, Clearcasting)") return true end 
    end

    --arcane_blast
    if cast.able.arcaneBlast() then
        if cast.arcaneBlast() then br.addonDebug("Cast Arcane Blast (Final Burn)") return true end 
    end

    --arcane_barrage
    if cast.able.arcaneBarrage() then
        if cast.arcaneBarrage() then br.addonDebug("Cast Arcane Barrage (Final Burn)") return true end 
    end

end
--[[
actions.opener=variable,name=have_opened,op=set,value=1,if=prev_gcd.1.evocation
actions.opener+=/lights_judgment,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down
actions.opener+=/bag_of_tricks,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down
actions.opener+=/call_action_list,name=items,if=buff.arcane_power.up
actions.opener+=/potion,if=buff.arcane_power.up
actions.opener+=/berserking,if=buff.arcane_power.up
actions.opener+=/blood_fury,if=buff.arcane_power.up
actions.opener+=/fireblood,if=buff.arcane_power.up
actions.opener+=/ancestral_call,if=buff.arcane_power.up
actions.opener+=/fire_blast,if=runeforge.disciplinary_command.equipped&buff.disciplinary_command_frost.up
actions.opener+=/frost_nova,if=runeforge.grisly_icicle.equipped&mana.pct>95
actions.opener+=/mirrors_of_torment
actions.opener+=/deathborne
actions.opener+=/radiant_spark,if=mana.pct>40
actions.opener+=/cancel_action,if=action.shifting_power.channeling&gcd.remains=0
actions.opener+=/shifting_power,if=soulbind.field_of_blossoms.enabled
actions.opener+=/touch_of_the_magi
actions.opener+=/arcane_power
actions.opener+=/rune_of_power,if=buff.rune_of_power.down
actions.opener+=/use_mana_gem,if=(talent.enlightened.enabled&mana.pct<=80&mana.pct>=65)|(!talent.enlightened.enabled&mana.pct<=85)
actions.opener+=/berserking,if=buff.arcane_power.up
actions.opener+=/time_warp,if=runeforge.temporal_warp.equipped
actions.opener+=/presence_of_mind,if=debuff.touch_of_the_magi.up&debuff.touch_of_the_magi.remains<=buff.presence_of_mind.max_stack*action.arcane_blast.execute_time
actions.opener+=/arcane_blast,if=dot.radiant_spark.remains>5|debuff.radiant_spark_vulnerability.stack>0
actions.opener+=/arcane_blast,if=buff.presence_of_mind.up&debuff.touch_of_the_magi.up&debuff.touch_of_the_magi.remains<=action.arcane_blast.execute_time
actions.opener+=/arcane_barrage,if=buff.arcane_power.up&buff.arcane_power.remains<=gcd&buff.arcane_charge.stack=buff.arcane_charge.max_stack
actions.opener+=/arcane_missiles,if=debuff.touch_of_the_magi.up&talent.arcane_echo.enabled&buff.deathborne.down&debuff.touch_of_the_magi.remains>action.arcane_missiles.execute_time,chain=1
actions.opener+=/arcane_missiles,if=buff.clearcasting.react,chain=1
actions.opener+=/arcane_orb,if=buff.arcane_charge.stack<=2&(cooldown.arcane_power.remains>10|active_enemies<=2)
actions.opener+=/arcane_blast,if=buff.rune_of_power.up|mana.pct>15
actions.opener+=/evocation,if=buff.rune_of_power.down,interrupt_if=mana.pct>=85,interrupt_immediate=1
actions.opener+=/arcane_barrage

]]--
local function actionList_Opener()
    
end
--[[
actions.rotation=variable,name=final_burn,op=set,value=1,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&!buff.rule_of_threes.up&target.time_to_die<=((mana%action.arcane_blast.cost)*action.arcane_blast.execute_time)
actions.rotation+=/strict_sequence,if=debuff.radiant_spark_vulnerability.stack=debuff.radiant_spark_vulnerability.max_stack&buff.arcane_power.down&buff.rune_of_power.down,name=last_spark_stack:arcane_blast:arcane_barrage
actions.rotation+=/arcane_barrage,if=debuff.radiant_spark_vulnerability.stack=debuff.radiant_spark_vulnerability.max_stack&(buff.arcane_power.down|buff.arcane_power.remains<=gcd)&(buff.rune_of_power.down|buff.rune_of_power.remains<=gcd)
actions.rotation+=/arcane_blast,if=dot.radiant_spark.remains>5|debuff.radiant_spark_vulnerability.stack>0
actions.rotation+=/arcane_blast,if=buff.presence_of_mind.up&debuff.touch_of_the_magi.up&debuff.touch_of_the_magi.remains<=action.arcane_blast.execute_time
actions.rotation+=/arcane_missiles,if=debuff.touch_of_the_magi.up&talent.arcane_echo.enabled&buff.deathborne.down&(debuff.touch_of_the_magi.remains>action.arcane_missiles.execute_time|cooldown.presence_of_mind.remains>0|covenant.kyrian.enabled),chain=1
actions.rotation+=/arcane_missiles,if=buff.clearcasting.react&buff.expanded_potential.up
actions.rotation+=/arcane_missiles,if=buff.clearcasting.react&(buff.arcane_power.up|buff.rune_of_power.up|debuff.touch_of_the_magi.remains>action.arcane_missiles.execute_time),chain=1
actions.rotation+=/arcane_missiles,if=buff.clearcasting.react&buff.clearcasting.stack=buff.clearcasting.max_stack,chain=1
actions.rotation+=/arcane_missiles,if=buff.clearcasting.react&buff.clearcasting.remains<=((buff.clearcasting.stack*action.arcane_missiles.execute_time)+gcd),chain=1
actions.rotation+=/nether_tempest,if=(refreshable|!ticking)&buff.arcane_charge.stack=buff.arcane_charge.max_stack&buff.arcane_power.down&debuff.touch_of_the_magi.down
actions.rotation+=/arcane_orb,if=buff.arcane_charge.stack<=2
actions.rotation+=/supernova,if=mana.pct<=95&buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down




actions.rotation+=/shifting_power,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&cooldown.evocation.remains>0&cooldown.arcane_power.remains>0&cooldown.touch_of_the_magi.remains>0&(!talent.rune_of_power.enabled|(talent.rune_of_power.enabled&cooldown.rune_of_power.remains>0))
actions.rotation+=/arcane_blast,if=buff.rule_of_threes.up&buff.arcane_charge.stack>3
actions.rotation+=/arcane_barrage,if=mana.pct<variable.barrage_mana_pct&cooldown.evocation.remains>0&buff.arcane_power.down&buff.arcane_charge.stack=buff.arcane_charge.max_stack&essence.vision_of_perfection.minor
actions.rotation+=/arcane_barrage,if=cooldown.touch_of_the_magi.remains=0&(cooldown.rune_of_power.remains=0|cooldown.arcane_power.remains=0)&buff.arcane_charge.stack=buff.arcane_charge.max_stack
actions.rotation+=/arcane_barrage,if=mana.pct<=variable.barrage_mana_pct&buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&buff.arcane_charge.stack=buff.arcane_charge.max_stack&cooldown.evocation.remains>0
actions.rotation+=/arcane_barrage,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&buff.arcane_charge.stack=buff.arcane_charge.max_stack&talent.arcane_orb.enabled&cooldown.arcane_orb.remains<=gcd&mana.pct<=90&cooldown.evocation.remains>0
actions.rotation+=/arcane_barrage,if=buff.arcane_power.up&buff.arcane_power.remains<=gcd&buff.arcane_charge.stack=buff.arcane_charge.max_stack
actions.rotation+=/arcane_barrage,if=buff.rune_of_power.up&buff.rune_of_power.remains<=gcd&buff.arcane_charge.stack=buff.arcane_charge.max_stack
actions.rotation+=/arcane_blast
actions.rotation+=/evocation,interrupt_if=mana.pct>=85,interrupt_immediate=1
actions.rotation+=/arcane_barrage

]]--
local function actionList_Rotation()
    -- actions.rotation+=/supernova,if=mana.pct<=95&buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down
   -- if cast.able.supernova
    
    -- actions.rotation+=/shifting_power,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&cooldown.evocation.remains>0&cooldown.arcane_power.remains>0&cooldown.touch_of_the_magi.remains>0&(!talent.rune_of_power.enabled|(talent.rune_of_power.enabled&cooldown.rune_of_power.remains>0))
    if cast.able.shiftingPower() and not buff.arcanePower.exists() and not buff.runeofPower.exists() 
    and not debuff.touchoftheMagi.exists("target") and cd.evocation.remain()  > 0 and cd.arcanePower.remain() > 0 and cd.touchoftheMagi.remain() > 0 and not talent.runeofPower or talent.runeofPower and cd.runeofPower.remain() > 0 then
        if cast.shiftingPower() then return true end
    end

    -- actions.rotation+=/arcane_blast,if=buff.rule_of_threes.up&buff.arcane_charge.stack>3
    if cast.able.arcaneBlast() and buff.ruleofThrees.exists() and buff.arcaneCharge.stack() > 3 then
        if cast.arcaneBlast() then return true end 
    end

    -- actions.rotation+=/arcane_barrage,if=mana.pct<variable.barrage_mana_pct&cooldown.evocation.remains>0&buff.arcane_power.down&buff.arcane_charge.stack=buff.arcane_charge.max_stack&essence.vision_of_perfection.minor
    if cast.able.arcaneBarrage() and manaPercent < var_barrage_mana_pct and cd.evocation.remain() <= gcdMax and not buff.arcanePower.exists() and buff.arcaneCharge.stack() > 3 and essence.worldveinResonance.active then
       if cast.arcaneBarrage() then return true end 
    end

    -- actions.rotation+=/arcane_barrage,if=cooldown.touch_of_the_magi.remains=0&(cooldown.rune_of_power.remains=0|cooldown.arcane_power.remains=0)&buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneBarrage() and cd.touchOfTheMagi.remain() <= gcdMax and cd.runeofPower.remain() <= gcdMax or cd.arcanePower.remain() <= gcdMax and buff.arcaneCharge.stack() > 3 then
       if cast.arcaneBarrage() then return true end 
    end

    -- actions.rotation+=/arcane_barrage,if=mana.pct<=variable.barrage_mana_pct&buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&buff.arcane_charge.stack=buff.arcane_charge.max_stack&cooldown.evocation.remains>0
    if cast.able.arcaneBarrage() and manaPercent < var_barrage_mana_pct and not buff.arcanePower.exists() and not buff.arcanePower.exists() 
    and not debuff.touchoftheMagi.exists("target") and buff.arcaneCharge.stack() > 3 and cd.evocation.remain() > 0 then
        if cast.arcaneBarrage() then return true end 
    end

    -- actions.rotation+=/arcane_barrage,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&buff.arcane_charge.stack=buff.arcane_charge.max_stack&talent.arcane_orb.enabled&cooldown.arcane_orb.remains<=gcd&mana.pct<=90&cooldown.evocation.remains>0
    if cast.able.arcaneBarrage() and not buff.arcanePower.exists() and not buff.runeofPower.exists() and not debuff.touchoftheMagi.exists("target")
    and buff.arcaneCharge.stack() > 3 and talent.arcaneOrb and cd.arcaneOrb.remain() <= gcdMax and manaPercent <= 90 and cd.evocation.remain() > 0 then
        if cast.arcaneBarrage() then return true end 
    end

    --actions.rotation+=/arcane_barrage,if=buff.arcane_power.up&buff.arcane_power.remains<=gcd&buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneBarrage() and buff.arcanePower.exists() and buff.arcanePower.remain() <= gcd and buff.arcaneCharge.stack() > 3 then
        if cast.arcaneBarrage() then return true end 
    end

    --actions.rotation+=/arcane_barrage,if=buff.rune_of_power.up&buff.rune_of_power.remains<=gcd&buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneBarrage() and buff.runeofPower.exists() and buff.runeofPower.remain() <= gcd and buff.arcaneCharge.stack() > 3 then
        if cast.arcaneBarrage() then return true end 
    end

    -- actions.rotation+=/arcane_blast
    if cast.able.arcaneBlast() then if cast.arcaneBlast() then return true end

    if buff.evocation.exists() and manaPercent >= 83 then CancelUnitBuff("player", GetSpellInfo(spell.evocation)) br.addonDebug("Canceled Evo") return true end
    if cast.able.evocation() then
        if cast.evocation() then return true end end -- Somehow cancel at 85% max mana
    end

    --actions.rotation+=/arcane_barrage
    if cast.able.arcaneBarrage() then if cast.arcaneBarrage() then return true end end 
end

local function actionList_main()

    -- Mirror image when Arcane Power is not active, on CD
    if not buff.arcanePower.exists() and useCDs() and isChecked("Mirror Image") then
        if cast.mirrorImage() then return end
    end

    -- Use Evocation to get a full stack of Brain Storm before using Arcane Power.
    if cast.able.evocation() and cd.arcanePower.remain() < getCastTime(spell.evocation) and arcaneCharges == 4 and trait.brainStorm.active then
        if cast.evocation() then return end
    end

    -- Cast Rune of power just before Arcane Power, or if you are at 2 charges.
    if cast.able.runeOfPower() and isChecked("Rune of Power") and (cd.arcanePower.remain() < getCastTime(spell.runeOfPower) and arcaneCharges == 4) or (charges.runeOfPower.count() == 2 and cd.arcanePower.remain() > 12) then
        if cast.runeOfPower() then return end
    end

    -- Use Arcane Power at 4 Arcane Charges
    if cast.able.arcanePower() and isChecked("Arcane Power") and arcaneCharges == 4 then
        if cast.arcanePower() then return end
    end

    -- If you are at max Arcane Charges with RoT proc, use Arcane Blast instead of Missiles.
    if cast.able.arcaneBlast() and buff.ruleOfThrees.exists() and arcaneCharges == 4 then
        if cast.arcaneBlast() then return end
    end

    -- Use Arcane Missiles when you have RoT up and Arcane Power is down. Not with Galvanizing Spark
    if cast.able.arcaneMissiles() and buff.ruleOfThrees.exists() and not buff.arcanePower.exists() and not cast.able.arcaneExplosion("player","aoe", 3, 10) and not trait.galvanizingSpark.active then
        if cast.arcaneMissiles() then return end
    end

    -- Use Arcane Missiles with clearcasting if Arcane Power is down. (Req. NOT Amplification)
    if cast.able.arcaneMissiles() and buff.clearcasting.exists() and not buff.arcanePower.exists() and not cast.able.arcaneExplosion("player","aoe", 3, 10) and not talent.amplification then
        if cast.arcaneMissiles() then return end
    end

    -- Use Arcane Missiles with Clearcasting & Amplification talented
    if cast.able.arcaneMissiles() and buff.clearcasting.exists() and not cast.able.arcaneExplosion("player","aoe", 3, 10) and talent.amplification then
        if cast.arcaneMissiles() then return end
    end    

    -- Use Charged Up when you can get 3 charges from it
    if cast.able.chargedUp() and isChecked("Charged Up") and arcaneCharges <= 1 then
        if cast.chargedUp() then return end
    end

    -- Nether Tempest when it is in 30% refresh
    if cast.able.netherTempest() and (not debuff.netherTempest.exists(units.get(40)) and arcaneCharges == 4) or (debuff.netherTempest.refresh(units.get(40)) and not buff.runeOfPower.exists() and not buff.arcanePower.exists()) then
        if cast.netherTempest() then return end
    end

    -- Use Arcane Orb when you need 2 Arcane Charges
    if cast.able.arcaneOrb() and arcaneCharges < 3 then
        if cast.arcaneOrb() then return end
    end

    -- Use Arcane Explosion on 3+ targets. Also other stuff
    if cast.able.arcaneExplosion("player","aoe", 3, 10) and (buff.arcanePower.exists() or cast.able.evocation() or (powerPercent > 85)) and not trait.brainStorm.active then
        if cast.arcaneExplosion("player","aoe", 3, 10) then return end
    end
    
    -- Use Arcane Explosion of 3+ targets. Burn mana with Rune of Power up
    if cast.able.arcaneExplosion("player","aoe", 3, 10) and buff.runeOfPower.exists() and not trait.brainStorm.active then
        if cast.arcaneExplosion("player","aoe", 3, 10) then return end
    end

    -- Use Arcane Explosion if 3+ targets with Brain Storm
    if cast.able.arcaneExplosion("player","aoe", 3, 10) and trait.brainStorm.active then
        if cast.arcaneExplosion("player","aoe", 3, 10) then return end
    end

    -- Use PoM near end of Arcane Power or Rune of Power
    if cast.able.presenceOfMind() and useCDs() and isChecked("Presence of Mind") and (buff.arcanePower.exists() and buff.arcanePower.remain() < getCastTime(spell.arcaneBlast) * 2) or (buff.runeOfPower.exists() and buff.runeOfPower.remain() < getCastTime(spell.arcaneBlast) * 2) then
        if cast.presenceOfMind() then return end
    end

    -- If you have Rules of Threes up, use Arcane Blast
    if cast.able.arcaneBlast() and not trait.brainStorm.active and trait.galvanizingSpark.active and not cast.able.arcaneExplosion("player","aoe", 3, 10) then
        if cast.arcaneBlast() then return end
    end

    -- Spend mana at will with Arcane Power, or when Evocation is ready to use. Dump mana above 85%
    if cast.able.arcaneBlast() and not trait.brainStorm.active and #enemies.yards10 < 3 and (buff.arcanePower.exists() or cast.able.evocation() or (powerPercent > 85)) then
        if cast.arcaneBlast() then return end
    end

    -- Burn mana with Rune of Power up
    if cast.able.arcaneBlast() and buff.runeOfPower.exists() and #enemies.yards10 < 3 then
        if cast.arcaneBlast() then return end
    end

    -- Arcane Blast with Brain Storm
    if cast.able.arcaneBlast() and #enemies.yards10 < 3 and trait.brainStorm.active then
        if cast.arcaneBlast() then return end
    end

    -- Evocate when you don't have enough mana to cast Arcane Blast. Cancel at 85%
    if cast.able.evocation() and not trait.brainStorm.active then
        if cast.evocation() then return end -- Somehow cancel at 85% max mana
    end

    -- If you used Arcane Power at low mana and run out of mana for arcane blast before arcane power fades use Arcane Missiles if possible.
    if cast.able.arcaneMissiles() and buff.clearcasting.exists() or buff.ruleOfThrees.exists() and buff.arcanePower.exists() then
        if cast.arcaneMissiles() then return end
    end

    -- If you don't have Arcane Power, Rune of Power, or Evocation ready to use, dump your Arcane Charges with Arcane Barrage when you get to 4 charges.
    if cast.able.arcaneBarrage() and arcaneCharges == 4 then
        if cast.arcaneBarrage() then return end
    end

    -- Explosion without brain storm
    if cast.able.arcaneExplosion("player","aoe", 3, 10) then
        if cast.arcaneExplosion() then return end
    end

    -- Arcane Blast without Brain Storm
    if cast.able.arcaneBlast() and #enemies.yards10 < 3 then 
        if cast.arcaneBlast() then return end
    end

    -- Supernova with talent (please god never take this)
    if cast.able.supernova() then
        if cast.supernova() then return end
    end

end

-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 4 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then

            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
        if inCombat then
            if actionList_Rotation() then return end
        end -- End In Combat Rotation

        end -- Pause
    end -- End Timer
end -- End runRotation 
local id = 62
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})