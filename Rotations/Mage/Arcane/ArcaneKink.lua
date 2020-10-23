local rotationName = "Kink v0.1.0"

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
        local cl                                            = br.read
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
        local covenant                                      = C_Covenants.GetActiveCovenantID()
        
        units.get(40)
        enemies.get(15, "target")
        enemies.get(8, "target")
        enemies.get(10)
        enemies.get(40)
        -- Units-
        units.get(5) -- Makes a variable called, units.dyn5
        units.get(40) -- Makes a variable called, units.dyn40
        units.get(15) -- Makes a variable called, units.dyn15
        -- Enemies
        enemies.get(5) -- Makes a varaible called, enemies.yards5
        enemies.get(10, "target") -- Makes a variable called, enemies.yards10t
        enemies.get(15, "target") -- Makes a variable called, enemies.yards15t
        enemies.get(40) -- Makes a varaible called, enemies.yards40

        local ccMaxStack = 3
       --variable,name=aoe_totm_charges,op=set,value=2
        local var_prepull_evo
        local var_rs_max_delay
        local var_ap_max_delay
        local var_rop_max_delay
        local var_totm_max_delay
        local var_barrage_mana_pct
        local var_ap_minimum_mana_pct
        local var_aoe_totm_charges
        local var_init = false
        local RadiantSparlVulnerabilityMaxStack = 4
        local ClearCastingMaxStack = 3
        local ArcaneOpener

        ArcaneOpener = {}
        function ArcaneOpener:Reset()
            self.state = false
            self.final_burn = false
            self.has_opened = fals
            var_init = false
        end
        ArcaneOpener:Reset()

        if #enemies.yards10t > 2 or var_prepull_evo then
            ArcaneOpener:StopOpener()
        end
  --varia
  --variable,name=prepull_evo,op=set,value=0
  --variable,name=prepull_evo,op=set,value=1,if=runeforge.siphon_storm.equipped&active_enemies>2
  --variable,name=prepull_evo,op=set,value=1,if=runeforge.siphon_storm.equipped&covenant.necrolord.enabled&active_enemies>1
  --variable,name=prepull_evo,op=set,value=1,if=runeforge.siphon_storm.equipped&covenant.night_fae.enabled
  -- NYI legendaries
  var_prepull_evo = false
  --variable,name=have_opened,op=set,value=0
  --variable,name=have_opened,op=set,value=1,if=active_enemies>2
  --variable,name=have_opened,op=set,value=1,if=variable.prepull_evo=1
  if #enemies.yards15t >2 or var_prepull_evo then
    ArcaneOpener:StopOpener()
  end
  --variable,name=rs_max_delay,op=set,value=5
  var_rs_max_delay = 5
  --variable,name=ap_max_delay,op=set,value=10
  var_ap_max_delay = 10
  --variable,name=rop_max_delay,op=set,value=20
  var_rop_max_delay = 20
  
  --variable,name=totm_max_delay,op=set,value=3,if=runeforge.disciplinary_command.equipped
  --variable,name=totm_max_delay,op=set,value=15,if=conduit.arcane_prodigy.enabled&active_enemies<3
  --variable,name=totm_max_delay,op=set,value=30,if=essence.vision_of_perfection.minor
  -- NYI legendaries, conduit, essence
  if covenant~= "Night Fae" then
    --variable,name=totm_max_delay,op=set,value=15,if=covenant.night_fae.enabled
    var_totm_max_delay = 15
  else
    --variable,name=totm_max_delay,op=set,value=5
    var_totm_max_delay = 5
  end
  --variable,name=barrage_mana_pct,op=set,value=90
  --variable,name=barrage_mana_pct,op=set,value=80,if=covenant.night_fae.enabled

    var_barrage_mana_pct = 90
  --variable,name=ap_minimum_mana_pct,op=set,value=30
  --variable,name=ap_minimum_mana_pct,op=set,value=50,if=runeforge.disciplinary_command.equipped
  --variable,name=ap_minimum_mana_pct,op=set,value=50,if=runeforge.grisly_icicle.equipped
  -- NYI legendaries
  var_ap_minimum_mana_pct = 30
  --variable,name=aoe_totm_charges,op=set,value=2
  var_aoe_totm_charges = 2

function ArcaneOpener:StartOpener()
  if inCombat then
    self.state = true
    self.final_burn = false
    self.has_opened = false
    VarInit()
  end
end

function ArcaneOpener:StopOpener()
  self.state = false
  self.has_opened = true
end

function ArcaneOpener:On()
  return self.state or (not inCombat and (UnitCastingInfo("player") == GetSpellInfo(spell.frostbolt)) or UnitChannelInfo("player") == GetSpellInfo(spell.evocation))
end

function ArcaneOpener:HasOpened()
  return self.has_opened
end

function ArcaneOpener:StartFinalBurn()
  self.final_burn = true
end

function ArcaneOpener:IsFinalBurn()
  return self.final_burn
end

function cl:Mage(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    if source == br.guid then
        -- CLear dot table after each death/individual combat scenarios. 
        if source == br.guid and param == "PLAYER_REGEN_ENABLED" then 
            VarConserveMana = 0
            VarTotalBurns = 0
            VarAverageBurnLength = 0
            VarFontPrecombatChannel = 0
        end       
        if param == "PLAYER_REGEN_DISABLED" then ArcaneOpener:Reset() end
    end 
end

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
        if not ropNotice and talent.runeofPower then
            print("Rune Of Power talent not supported in rotation yet, use manually")
            ropNotice = true
        elseif ropNotice and not talent.runeofPower then
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

        local function castarcaneOrb(minUnits, safe, minttd)
        if not isKnown(spell.arcaneOrb) or getSpellCD(spell.arcaneOrb) ~= 0then
            return false
        end  
        local x, y, z = ObjectPosition("player")
        local length = 35
        local width = 17
        ttd = ttd or 0
        safe = safe or true
        local function getRectUnit(facing)
            local halfWidth = width/2
            local nlX, nlY, nlZ = GetPositionFromPosition(x, y, z, halfWidth, facing + math.rad(90), 0)
            local nrX, nrY, nrZ = GetPositionFromPosition(x, y, z, halfWidth, facing + math.rad(270), 0)
            local frX, frY, frZ = GetPositionFromPosition(nrX, nrY, nrZ, length, facing, 0)
            return nlX, nlY, nrX, nrY, frX, frY
        end
        local enemiesTable = getEnemies("player", length, true)
        local facing = ObjectFacing("player")        
        local unitsInRect = 0
        local nlX, nlY, nrX, nrY, frX, frY = getRectUnit(facing)
        local thisUnit
        for i = 1, #enemiesTable do
            thisUnit = enemiesTable[i]
            local uX, uY, uZ = ObjectPosition(thisUnit)
            if isInside(uX, uY, nlX, nlY, nrX, nrY, frX, frY) and not TraceLine(x, y, z+2, uX, uY, uZ+2, 0x100010) then
                if safe and not UnitAffectingCombat(thisUnit) and not isDummy(thisUnit) then
                    unitsInRect = 0
                    break
                end            
                if ttd(thisUnit) >= minttd then                
                    unitsInRect = unitsInRect + 1
                end
            end
        end
        if unitsInRect >= minUnits then
            CastSpellByName(GetSpellInfo(arcaneOrb))
            return true
        else
            return false
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
local function actionList_Extras()
        if isChecked("DPS Testing") and GetObjectExists("target") and getCombatTime() >= (tonumber(getOptionValue("DPS Testing")) * 60) and isDummy() then
            StopAttack()
            ClearTarget()
            if isChecked("Pet Management") and not talent.lonelyWinter then
                PetStopAttack()
                PetFollow()
            end
            print(tonumber(getOptionValue("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
            profileStop = true
        end
        --Ice Barrier
        if not IsResting() and not inCombat and not playerCasting and isChecked("Ice Barrier OOC") then
            if cast.iceBarrier("player") then
                return true
            end
        end
        -- Spell Steal
        if isChecked("Spellsteal") and inCombat then
            for i = 1, #enemyTable40 do
                if spellstealCheck(enemyTable40[i].unit) then
                    if cast.spellsteal(enemyTable40[i].unit) then return true end
                end
            end
        end
        -- Arcane Intellect
        if isChecked("Arcane Intellect") and br.timer:useTimer("AI Delay", math.random(15, 30)) then
            for i = 1, #br.friend do
                if not buff.arcaneIntellect.exists(br.friend[i].unit,"any") and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                    if cast.arcaneIntellect() then return true end
                end
            end
        end
        -- Trinkets
            -- Trinket 1
            if (getOptionValue("Trinket 1") == 1 or (getOptionValue("Trinket 1") == 2 and useCDs())) and inCombat then
                if use.able.slot(13) then
                    use.slot(13)
                end
            end
        -- Trinket 2
            if (getOptionValue("Trinket 2") == 1 or (getOptionValue("Trinket 2") == 2 and useCDs())) and inCombat then
                if use.able.slot(14) then
                    use.slot(14)
                end
            end      
        -- Slow Fall
        if isChecked("Slow Fall Distance") and cast.able.slowFall() and not buff.slowFall.exists() then
            if IsFalling() and getFallDistance() >= getOptionValue("Slow Fall Distance") then
                if cast.slowFall() then return end
            end
        end         
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
local function Opener ()
  if not ArcaneOpener:On() then
    ArcaneOpener:StartOpener()
    return "Start opener"
  end
  -- --actions.opener=variable,name=have_opened,op=set,value=1,if=prev_gcd.1.evocat
  if last.cast.evocation(2) and ArcaneOpener:On() then
    ArcaneOpener:StopOpener()
    return "Stop opener 1"
  end

  --actions.opener+=/lights_judgment,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down
if br.player.race == "Lightforged Draenei" or br.player.race == "Vulpera" 
  and not buff.arcanePower.exists() 
  and not buff.runeofPower.exists() 
  and cast.able.Racial()
  and not debuff.touchoftheMagi.exists("target") 
  then 
      if cast.Racial() then return true end
  end
  --actions.opener+=/potion,if=buff.arcane_power.up
   

  --actions.opener+=/berserking,if=buff.arcane_power
    if ui.checked("Racial") 
    and buff.arcanePower.exists() 
    and (race == "Troll" or race == "Orc" or race == "DarkIronDwarf" or race == "MagharOrc")
    then
        if cast.racial() then br.addonDebug("Casting Berserking") return true end
    end

    --actions.opener+=/fire_blast,if=runeforge.disciplinary_command.equipped&buff.disciplinary_command_frost.up

    --actions.opener+=/frost_nova,if=runeforge.grisly_icicle.equipped&mana.pct>95

    --actions.opener+=/mirrors_of_torment

    --actions.opener+=/deathborne

    --actions.opener+=/radiant_spark,if=mana.pct>40

    --actions.opener+=/cancel_action,if=action.shifting_power.channeling&gcd.remains=0

    --actions.opener+=/shifting_power,if=soulbind.field_of_blossoms.enabled

    --actions.opener+=/touch_of_the_magi

    if cast.able.touchoftheMagi() then if cast.touchoftheMagi() then return true end end 

    --actions.opener+=/arcane_power
    if cast.able.arcanePower() then if cast.arcanePower() then return true end end 

    --actions.opener+=/rune_of_power,if=buff.rune_of_power.down
    if cast.able.runeofPower() then if cast.runeofPower() then return true end end

    --actions.opener+=/use_mana_gem,if=(talent.enlightened.enabled&mana.pct<=80&mana.pct>=65)|(!talent.enlightened.enabled&mana.pct<=85)
    if has.manaGem() and use.able.manaGem()
    and (talent.enlightened and manaPercent <= 80 and manaPercent >= 65)
    or (not talent.enlightened and manaPercent <= 85)
    then
        if use.manaGem() then return true end
    end
        

    --actions.opener+=/berserking,if=buff.arcane_power.up

    --actions.opener+=/time_warp,if=runeforge.temporal_warp.equipped

    --actions.opener+=/presence_of_mind,if=debuff.touch_of_the_magi.up&debuff.touch_of_the_magi.remains<=buff.presence_of_mind.max_stack*action.arcane_blast.execute_time
    if cast.able.presenceofMind()
    and debuff.touchoftheMagi.exists("target")
    and debuff.touchoftheMagi.remain("target") <= 2 * cast.time.arcaneBlast() 
    then
        if cast.presenceofMind() then return true end
    end
    --actions.opener+=/arcane_blast,if=dot.radiant_spark.remains>5|debuff.radiant_spark_vulnerability.stack>0

    

    --actions.opener+=/arcane_blast,if=buff.presence_of_mind.up&debuff.touch_of_the_magi.up&debuff.touch_of_the_magi.remains<=action.arcane_blast.execute_time
    if cast.able.arcaneBlast()
    and debuff.prresenceofMind.exists()
    and debuff.touchoftheMagi.remain("target") < cast.time.arcaneBlast() 
    then
        if cast.presenceofMind() then return true end
    end

    --actions.opener+=/arcane_barrage,if=buff.arcane_power.up&buff.arcane_power.remains<=gcd&buff.arcane_charge.stack=buff.arcane_charge.max_stack

    if cast.able.arcaneBarrage()
    and buff.arcanePower.exists()
    and buff.arcanePower.remain() <= gcdMax 
    and arcaneCharges > 3
    then
        if cast.arcaneBarrage() then return true end 
    end
    

    --actions.opener+=/arcane_missiles,if=debuff.touch_of_the_magi.up&talent.arcane_echo.enabled&buff.deathborne.down&debuff.touch_of_the_magi.remains>action.arcane_missiles.execute_time,chain=1

    if cast.able.arcaneMissiles()
    and debuff.touchoftheMagi.exists("target")
    and talent.arcaneEcho 
    and not buff.deathBorne.exists()
    and debuff.touchoftheMagi.remain("target") > cast.time.arcaneMissiles()
    then
        if cast.arcaneMissiles() then return true end 
    end

    --actions.opener+=/arcane_missiles,if=buff.clearcasting.react,chain=1

    if cast.able.arcaneMissiles()
    and buff.clearcasting.exists()
    then
        if cast.arcaneMissiles() then return true end 
    end

    --actions.opener+=/arcane_orb,if=buff.arcane_charge.stack<=2&(cooldown.arcane_power.remains>10|active_enemies<=2)

    if cast.able.arcaneOrb()
    and arcaneCharges <= 2 or cd.arcanePower.remain() > 10 or #enemies.yards10t <= 2
    then
       if castarcanOrb(1, true, 4) then return true end
    end

    --actions.opener+=/arcane_blast,if=buff.rune_of_power.up|mana.pct>15
    if cast.able.arcaneBlast()
    and buff.runeofPower.exists()
    or manaPercent > 15
    then
        if cast.arcaneBlast() then return true end
    end


    --actions.opener+=/evocation,if=buff.rune_of_power.down,interrupt_if=mana.pct>=85,interrupt_immediate=1
    
    --actions.opener+=/arcane_barrage
end
    --
local function actionList_Rotation()
    --actions.rotation=variable,name=final_burn,op=set,value=1,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&!buff.rule_of_threes.up&target.time_to_die<=((mana%action.arcane_blast.cost)*action.arcane_blast.execute_time)
    if cast.able.arcaneMissiles()
    and arcaneCharges > 3 
    and not buff.ruleofThrees.exists() 
    and getTTD("target") <= ( manaPercent / spell.arcaneBlast.cost() * cast.time.arcaneBlast() )
    then
        if cast.arcaneBlast() then br.addonDebug("Casting Arcane Missiles ()") return truee end
    end

    --aactions.rotation+=/arcane_blast,if=buff.presence_of_mind.up&debuff.touch_of_the_magi.up&debuff.touch_of_the_magi.remains<=action.arcane_blast.execute_tim
    if cast.able.arcaneBlast() 
    and buff.presenceOfMind.exists() 
    and debuff.touchoftheMagi.exists("target") 
    and debuff.touchoftheMagi.remain("target") <= cast.time.arcaneBlast() 
    then
        if cast.arcaneBlast() then br.addonDebug("Casting Arcane Blast (PoM, Magi)") return truee end
    end

    --actions.rotation+=/arcane_missiles,if=debuff.touch_of_the_magi.up&talent.arcane_echo.enabled&buff.deathborne.down&(debuff.touch_of_the_magi.remains>action.arcane_missiles.execute_time|cooldown.presence_of_mind.remains>0|covenant.kyrian.enabled),chain=1
    if cast.able.arcaneMissiles() 
    and debuff.touchoftheMagi.exists("target") 
    and talent.arcaneEcho 
    and not buff.deathBorne.exists() 
    and debuff.touchoftheMagi.remain("target") > cast.time.arcaneMissiles() or cd.presenceOfMind.remain() > 0 
    then
       if cast.arcaneMissiles() then br.addonDebug("Casting Arcane Missiles (clear casting + expanded potential)") return true end
    end

    --actions.rotation+=/arcane_missiles,if=buff.clearcasting.react&buff.expanded_potential.up
    if cast.able.arcaneMissiles() 
    and buff.clearcasting.exists() 
    and buff.expandedPotential.exists() 
    then
        if cast.arcaneMissiles() then br.addonDebug("Casting Arcane Missiles (clear casting + expanded potential)") return true end
    end

    --actions.rotation+=/arcane_missiles,if=buff.clearcasting.react&(buff.arcane_power.up|buff.rune_of_power.up|debuff.touch_of_the_magi.remains>action.arcane_missiles.execute_time),chain=1
    if cast.able.arcaneMissiles() 
    and buff.clearcasting.exists() 
    and buff.arcanePower.exists() 
    and buff.runeofPower.exists() 
    and debuff.touchoftheMagi.remain("target") > cast.time.arcaneMissiles() 
    then
        if cast.arcaneMissiles() then br.addonDebug("Casting Arcane Missiles (Clearcasting + RoP, AP, + Magi Debuff)") return true end
    end

    --actions.rotation+=/arcane_missiles,if=buff.clearcasting.react&buff.clearcasting.stack=buff.clearcasting.max_stack,chain=1
    if cast.able.arcaneMissiles() 
    and buff.clearcasting.exists() 
    and buff.clearcasting.stack() == ccMaxStack 
    then
        if cast.arcaneMissiles() then br.addonDebug("Casting Arcane Missiles (clearcasting max stack)") return true end
    end

    --actions.rotation+=/arcane_missiles,if=buff.clearcasting.react&buff.clearcasting.remains<=((buff.clearcasting.stack*action.arcane_missiles.execute_time)+gcd),chain=1
    if cast.able.arcaneMissiles() 
    and buff.clearcasting.exists() 
    and buff.clearcasting.remain() <= ((buff.clearcasting.stack() * cast.time.arcaneMissiles()) + gcdMax)
    then
        if cast.arcaneMissiles() then br.addonDebug("Casting Arcane Missiles (clearcasting)")  return true end 
    end

    -- actions.rotation+=/nether_tempest,if=(refreshable|!ticking)&buff.arcane_charge.stack=buff.arcane_charge.max_stack&buff.arcane_power.down&debuff.touch_of_the_magi.down
    if cast.able.netherTempest() 
    and debuff.netherTempest.refresh("target") or not debuff.netherTempest.exists("target") 
    and arcaneCharges > 3 and not buff.arcanePower.exists() 
    and not debuff.touchoftheMagi.exists("target") 
    then
        if cast.netherTempest() then br.addonDebug("Casting Nether Tempest") return true end
    end

    -- actions.rotation+=/arcane_orb,if=buff.arcane_charge.stack<=2
    if cast.able.arcaneOrb() and arcaneCharges <= 2 then if castarcaneOrb(1, true, 4) then br.addonDebug("Arcane Orb <=2 AC") return true end end

    -- actions.rotation+=/supernova,if=mana.pct<=95&buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down
    if cast.able.supernova()
    and manaPercent <= 95 
    and not buff.arcanePower.exists() 
    and not buff.runeofPower.exists() 
    and not debuff.touchoftheMagi.exists("target") 
    then
       if cast.supernova() then br.addonDebug("Casting Supernova (no AP, No RoP, no Magi)") return true end 
    end
    
    -- actions.rotation+=/shifting_power,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&cooldown.evocation.remains>0&cooldown.arcane_power.remains>0&cooldown.touch_of_the_magi.remains>0&(!talent.rune_of_power.enabled|(talent.rune_of_power.enabled&cooldown.rune_of_power.remains>0))
    --if cast.able.shiftingPower() and not buff.arcanePower.exists() and not buff.runeofPower.exists() 
    --and not debuff.touchoftheMagi.exists("target") and cd.evocation.remain()  > 0 and cd.arcanePower.remain() > 0 and cd.touchoftheMagi.remain() > 0 and not talent.runeofPower or talent.runeofPower and cd.runeofPower.remain() > 0 then
    --    if cast.shiftingPower() then return true end
    --end

    -- actions.rotation+=/arcane_blast,if=buff.rule_of_threes.up&buff.arcane_charge.stack>3
    if cast.able.arcaneBlast() 
    and buff.ruleOfThrees.exists() 
    and arcaneCharges > 3 then
        if cast.arcaneBlast() then return true end 
    end

    -- actions.rotation+=/arcane_barrage,if=mana.pct<variable.barrage_mana_pct&cooldown.evocation.remains>0&buff.arcane_power.down&buff.arcane_charge.stack=buff.arcane_charge.max_stack&essence.vision_of_perfection.minor
    if cast.able.arcaneBarrage() and manaPercent < var_barrage_mana_pct and cd.evocation.remain() <= gcdMax and not buff.arcanePower.exists() and arcaneCharges > 3 and essence.worldveinResonance.active then
       if cast.arcaneBarrage() then return true end 
    end

    -- actions.rotation+=/arcane_barrage,if=cooldown.touch_of_the_magi.remains=0&(cooldown.rune_of_power.remains=0|cooldown.arcane_power.remains=0)&buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneBarrage() and cd.touchOfTheMagi.remain() <= gcdMax and cd.runeofPower.remain() <= gcdMax or cd.arcanePower.remain() <= gcdMax and arcaneCharges > 3 then
       if cast.arcaneBarrage() then return true end 
    end

    -- actions.rotation+=/arcane_barrage,if=mana.pct<=variable.barrage_mana_pct&buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&buff.arcane_charge.stack=buff.arcane_charge.max_stack&cooldown.evocation.remains>0
    if cast.able.arcaneBarrage() and manaPercent < var_barrage_mana_pct and not buff.arcanePower.exists() and not buff.arcanePower.exists() 
    and not debuff.touchoftheMagi.exists("target") and arcaneCharges > 3 and cd.evocation.remain() > 0 then
        if cast.arcaneBarrage() then return true end 
    end

    -- actions.rotation+=/arcane_barrage,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&buff.arcane_charge.stack=buff.arcane_charge.max_stack&talent.arcane_orb.enabled&cooldown.arcane_orb.remains<=gcd&mana.pct<=90&cooldown.evocation.remains>0
    if cast.able.arcaneBarrage() and not buff.arcanePower.exists() and not buff.runeofPower.exists() and not debuff.touchoftheMagi.exists("target")
    and arcaneCharges > 3 and talent.arcaneOrb and cd.arcaneOrb.remain() <= gcdMax and manaPercent <= 90 and cd.evocation.remain() > 0 then
        if cast.arcaneBarrage() then return true end 
    end

    --actions.rotation+=/arcane_barrage,if=buff.arcane_power.up&buff.arcane_power.remains<=gcd&buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneBarrage() and buff.arcanePower.exists() and buff.arcanePower.remain() <= gcd and arcaneCharges > 3 then
        if cast.arcaneBarrage() then return true end 
    end

    --actions.rotation+=/arcane_barrage,if=buff.rune_of_power.up&buff.rune_of_power.remains<=gcd&buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneBarrage() and buff.runeofPower.exists() and buff.runeofPower.remain() <= gcd and arcaneCharges > 3 then
        if cast.arcaneBarrage() then return true end 
    end

    -- actions.rotation+=/arcane_blast
    if cast.able.arcaneBlast() then if cast.arcaneBlast() then return true end

    -- Cancel Evocation 
    if UnitCastingInfo("player") == GetSpellInfo(spell.evocation) and manaPercent >= 83 then CancelUnitBuff("player", GetSpellInfo(spell.evocation)) br.addonDebug("Canceled Evo") return true end
    if cast.able.evocation() then
        if cast.evocation() then br.addonDebug("Casting Evocation (>= 85 mana)") return true end end -- Somehow cancel at 85% max mana
    end

    --actions.rotation+=/arcane_barrage
    if cast.able.arcaneBarrage() then if cast.arcaneBarrage() then return true end end 
end

local function actionList_main()

end
    -----------------------
    --- Extras Rotation ---
    -----------------------
    if actionList_Extras() then return true end
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
                -- Create Healthstone
                if GetItemCount(36799) < 1 or itemCharges(36799) < 3 then
                   if cast.conjuremanaGem() then br.addonDebug("Casting Conjure Mana Gem" ) return true end
                end
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