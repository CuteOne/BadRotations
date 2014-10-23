if select(3, UnitClass("player")) == 11 then

-- --Shred glyph and facing checks
-- function canShred()
--     if ((UnitBuffID("player",106951) or UnitBuffID("player",5217)) and hasGlyph(114234) == true) or getFacing("target","player") == false then
--         return true;
--     else
--         return false;
--     end
-- end

-- --Potential Mangle Damage
-- function getMangleDamage()
--     local calc = (1 * 78 + 1.25 * (select(1, UnitDamage("player")) + select(2, UnitDamage("player"))))*(1 - (24835 * (1 - .04 * 0)) / (24835 * (1 - .04*0) + 46257.5));
--     if select(4,UnitBuffID("player",145152)) == nil then
--         return calc;
--     else
--         return calc*1.3;
--     end
-- end

-- --Potential Ferocious Bite Damage
-- function getFerociousBiteDamage()
--     local calc = (315 + 762 * GetComboPoints("player") + 0.196 * GetComboPoints("player") * UnitAttackPower("player"))
--     if select(4,UnitBuffID("player",145152)) == nil then
--         return calc;
--     else
--         return calc*1.3;
--     end
-- end

-- --Savage Roar Duration Tracking
-- function getSRR()
--     if hasGlyph(127540) then
--         if UnitBuffID("player",127538) and UnitLevel("player") >= 18 then
--             return getBuffRemain("player",127538)
--         else
--             if UnitLevel("player") < 18 then
--                 return 999
--             else
--                 return 0
--             end
--         end
--     else
--         if UnitBuffID("player",52610) and UnitLevel("player") >= 18 then
--             return getBuffRemain("player",127538)
--         else
--             if UnitLevel("player") < 18 then
--                 return 999
--             else
--                 return 0
--             end
--         end
--     end
-- end

-- --Total Savage Roar Time
-- function getSRT()
--     if (12 + (getCombo("player")*6)) > (getSRR() + 12) then
--         return true
--     else
--         return false
--     end
-- end

-- --Savage Roar / Rip Duration Difference
-- function getSrRpDiff()
--     if UnitLevel("player") >= 20 then
--         local srrpdiff = (getDebuffRemain("target",rp) - getSRR())
--         if srrpdiff < 0 then
--             return -srrpdiff
--         else
--             return srrpdiff
--         end
--     else
--         return 0
--     end
-- end

-- --Rune of Reorigination Duration Tracking
-- function getRoRoRemain()
--     if UnitBuffID("player",139121) then
--         return (select(7, UnitBuffID("player",139121)) - GetTime())
--     elseif UnitBuffID("player",139117) then
--         return (select(7, UnitBuffID("player",139117)) - GetTime())
--     elseif UnitBuffID("player",139120) then
--         return (select(7, UnitBuffID("player",139120)) - GetTime())
--     else
--         return 0
--     end
-- end

-- --Rake Filler
-- function getRkFill()
--     if getTimeToDie("target") > 3
--         and CRKD()*((getDebuffRemain("target",rk) / 3 ) + 1 ) - RKD()*(getDebuffRemain("target",rk) / 3) > getMangleDamage()
--     then
--         return true
--     else
--         return false
--     end
-- end

-- --Rake Override
-- function getRkOver()
--     if getTimeToDie("target") - getDebuffRemain("target",rk) > 3
--         and (RKP() > 108 or (getDebuffRemain("target",rk) < 3 and getRakeDamage() >= 75))
--     then
--         return true
--     else
--         return false
--     end
-- end

------Member Check------
function CalculateHP(unit)
  incomingheals = UnitGetIncomingHeals(unit) or 0
  return 100 * ( UnitHealth(unit) + incomingheals ) / UnitHealthMax(unit)
end

function GroupInfo()
    members, group = { { Unit = "player", HP = CalculateHP("player") } }, { low = 0, tanks = { } }
    group.type = IsInRaid() and "raid" or "party"
    group.number = GetNumGroupMembers()
    if group.number > 0 then
        for i=1,group.number do
            if canHeal(group.type..i) then
                local unit, hp = group.type..i, CalculateHP(group.type..i)
                table.insert( members,{ Unit = unit, HP = hp } )
                if hp < 90 then group.low = group.low + 1 end
                if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(group.tanks,unit) end
            end
        end
        if group.type == "raid" and #members > 1 then table.remove(members,1) end
        table.sort(members, function(x,y) return x.HP < y.HP end)
        --local customtarget = canHeal("target") and "target" -- or CanHeal("mouseover") and GetMouseFocus() ~= WorldFrame and "mouseover"
        --if customtarget then table.sort(members, function(x) return UnitIsUnit(customtarget,x.Unit) end) end
    end
end

function WA_calcStats_feral()
    local DamageMult = 1 --select(7, UnitDamage("player"))

    local CP = GetComboPoints("player", "target")
    if CP == 0 then CP = 5 end

    if UnitBuffID("player", tf) then
        DamageMult = DamageMult * 1.15
    end

    if UnitBuffID("player", svr) then
        DamageMult = DamageMult * 1.4
    end

    WA_stats_BTactive = WA_stats_BTactive or  0
    if UnitBuffID("player", bt) then
        WA_stats_BTactive = GetTime()
        DamageMult = DamageMult * 1.3
    elseif GetTime() - WA_stats_BTactive < .2 then
        DamageMult = DamageMult * 1.3
    end

    local RakeMult = 1
    WA_stats_prowlactive = WA_stats_prowlactive or  0
    if UnitBuffID("player", inc) then
        RakeMult = 2
    elseif UnitBuffID("player", prl) then
        WA_stats_prowlactive = GetTime()
        RakeMult = 2
    elseif GetTime() - WA_stats_prowlactive < .2 then
        RakeMult = 2
    end

    WA_stats_RipTick = CP*DamageMult
    WA_stats_RipTick5 = 5*DamageMult
    WA_stats_RakeTick = DamageMult*RakeMult
    WA_stats_ThrashTick = DamageMult
end

--Calculated Rake Dot Damage
function CRKD()
    WA_calcStats_feral()
    local calcRake = WA_stats_RakeTick
    return calcRake
end

--Applied Rake Dot Damage
function RKD()
    local rakeDot = 1
    if UnitExists("target") then
        if Rake_sDamage[UnitGUID("target")]~=nil then rakeDot = Rake_sDamage[UnitGUID("target")]; end
    end
    return rakeDot
end

--Rake Dot Damage Percent
function RKP()
    local RatioPercent = floor(CRKD()/RKD()*100+0.5)
    return RatioPercent
end

--Calculated Rip Dot Damage
function CRPD()
    WA_calcStats_feral()
    local calcRip = WA_stats_RipTick5
    return calcRip
end

--Applied Rip Dot Damage
function RPD()
    local ripDot = 1
    if UnitExists("target") then
        if Rip_sDamage[UnitGUID("target")]~=nil then ripDot = Rip_sDamage[UnitGUID("target")]; end
    end
    return ripDot
end

--Rip Dot Damage Percent
function RPP()
    local RatioPercent = floor(CRPD()/RPD()*100+0.5)
    return RatioPercent
end

function useCDs()
    if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
        return true
    else
        return false
    end
end

function useAoE()
    if numEnemies == nil then numEnemies = 0 end
    if not enemiesTimer or enemiesTimer <= GetTime() - 1 then
        numEnemies, enemiesTimer = getNumEnemies("player",10), GetTime()
    end
    if (BadBoy_data['AoE'] == 1 and numEnemies >= 3) or BadBoy_data['AoE'] == 2 then
        return true
    else
        return false
    end
end

function useThrash()
    if BadBoy_data['Thrash']==1 then
        return true
    else
        return false
    end
end

function outOfWater()
    if swimTime == nil then swimTime = 0 end
    if outTime == nil then outTime = 0 end
    if IsSwimming() then
        swimTime = GetTime()
        outTime = 0
    end
    if not IsSwimming() then
        outTime = swimTime
        swimTime = 0
    end
    if outTime ~= 0 and swimTime == 0 then
        return true
    end
    if outTime ~= 0 and IsFlying() then
        outTime = 0
        return false
    end
end
        -- for i = 1, ObjectCount() do
        --     if getCreatureType(ObjectWithIndex(i)) == true then
        --         --local thisUnit = ObjectWithIndex(i)
        --         return ObjectWithIndex(i)
        --     end
        -- end


function dynamicTarget(range)
    if myEnemies==nil then myEnemies = 0 end
    if myMultiTimer == nil or myMultiTimer <= GetTime() - 1 then
        myEnemies, myMultiTimer = getEnemies("player",range), GetTime()
    end
    for i = 1, #myEnemies do
        if getCreatureType(myEnemies[i]) == true then
            local thisUnit = myEnemies[i]
            if UnitCanAttack(thisUnit,"player")
                and (UnitAffectingCombat(thisUnit) or isDummy(thisUnit))
                and not UnitIsDeadOrGhost(thisUnit)
                and getFacing("player",thisUnit)
            then
                return thisUnit
            end
        end
    end
end

function feralForms()
    local targetDistance = getDistance("player","target")

-- Flying Form
    if (getFallTime() > 1 or outOfWater()) and not isInCombat("player") and IsFlyableArea() then
        if not (UnitBuffID("player", trf) or UnitBuffID("player", flf)) and UnitLevel("player")>=58 then
            if hasGlyph(114338) then
                if castSpell("player",flf,false,false) then return; end
            elseif not hasGlyph(114338) then
                if castSpell("player",trf,false,false) then return; end
            end
        else
            if castSpell("player",cf,false,false) then return; end
        end
    end
-- Aquatic Form
    if IsSwimming() and not outOfWater() and not UnitBuffID("player",trf) and not UnitExists("target") then
        if castSpell("player",trf,false,false) then return; end
    end
-- Cat Form
    if ((not UnitIsDeadOrGhost("target") and UnitExists("target") and canAttack("player", "target") and targetDistance<=40) or (isMoving("player") and not UnitBuffID("player",trf) and not IsFalling()))
        and (not IsFlying() or (IsFlying() and targetDistance<10))
        and not UnitBuffID("player",cf)
        and (getFallTime()==0 or targetDistance<10)
    then
        if castSpell("player",cf,false,false) then return; end
    end
-- PowerShift
    if hasNoControl() then
        for i=1, 6 do
            if i == GetShapeshiftForm() then
                CastShapeshiftForm(i)
                return true
            end
        end
    end
    return false
end

function feralBuffs()
    if not UnitBuffID("player", prl)
        and not UnitBuffID("player", 80169) -- Food
        and not UnitBuffID("player", 87959) -- Drink
        and UnitCastingInfo("player") == nil
        and UnitChannelInfo("player") == nil
        and not UnitIsDeadOrGhost("player")
        and not IsMounted()
        and not IsFlying()
        and not isInCombat("player")
    then
        -- Mark of the Wild
        if isChecked("Mark of the Wild") and not UnitExists("mouseover") then
            for i = 1, #members do --members
                if not isBuffed(members[i].Unit,{115921,20217,1126,90363,159988,160017,160077}) and (#nNova==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
                    if UnitPower("player") ~= UnitPower("player",0) then
                        CancelShapeshiftForm()
                    else
                        if castSpell("player",mow,false,false) then return; end
                    end
                end
            end
        end

        -- Flask / Crystal
        if isChecked("Flask / Crystal") then
            if (select(2,IsInInstance())=="raid" or select(2,IsInInstance())=="none") and not UnitBuffID("player",105689) then
                if not UnitBuffID("player",127230) and canUse(86569) then
                    UseItemByName(tostring(select(1,GetItemInfo(86569))))
                end
            end
        end
    else
        return false
    end
end

function feralPotAssist()
    return false
end

function feralCooldowns()
    local targetDistance = getDistance("player","target")
    local prlRemain = getBuffRemain("player",prl)
    local savageRemain = getBuffRemain("player",svr)
    local tfRemain = getBuffRemain("player",tf)
    local tfCdRemain = getSpellCD(tf)
    local fonCdRemain = getSpellCD(fon)
    local feralTimeToDie = getTimeToDie("target")

    if useCDs()
        and isInCombat("player")
        and UnitBuffID("player",cf)
        and prlRemain==0
        and targetDistance<=5
    then
        if savageRemain > 0 and tfRemain > 0 then
-- Agi-Pot
            if canUse(76089) and getCombo() >= 4 and getHP("target") <= 25 and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") then
                --useItem(76089)
                UseItemByName(tostring(select(1,GetItemInfo(76089))))
            end
-- Racial: Troll Berserking
            if select(2, UnitRace("player")) == "Troll" and getPower("player") >= 75 then
                if castSpell("player",rber,false,false) then return; end
            end
-- Profession: Engineering Hands
            -- if getPower("player") >= 75 and GetInventoryItemCooldown("player",10) == 0 and not UnitBuffID("player",ber) and getBuffRemain("player",96228)==0 then
            --     UseInventoryItem(10)
            -- end
-- Berserk
            if getPower("player") >= 75 and tfCdRemain > 6 and feralTimeToDie >= 18 then
                if castSpell("player",ber,false,false) then return; end
            end
-- Tier 4 Talent: Incarnation - King of the Jungle
            if feralTimeToDie >= 15 and UnitBuffID("player",ber) then
                if castSpell("player",inc,false,false) then return; end
            end
-- Tier 6 Talent: Nature's Vigil
            if feralTimeToDie >= 15 and getPower("player") >= 75 then
                if castSpell("player",nv,false,false) then return; end
            end
        end
-- Tier 4 Talent: Force of Nature
        if fonCdRemain == 0 then
            if select(1, GetSpellCharges(fon)) == 3 or (select(1, GetSpellCharges(fon)) == 2 and (select(3, GetSpellCharges(fon)) - GetTime()) > 19) then
                if castSpell("target",fon,true,false,false) then return; end
            elseif (getBuffRemain("player",148903)>0 and getBuffRemain("player",148903)<1 )
                or (getBuffStacks("player",146310)==20)
                or feralTimeToDie<20
                or (getBuffRemain("player",61336)>0 and getBuffRemain("player",61336)<1 ) then
                if castSpell("target",fon,true,false,true) then return; end
            end
        end
    else
        return false
    end
end

function feralDefensives()

    if isChecked("Defensive Mode") then
        if not UnitBuffID("player",prl)
            and not UnitBuffID("player", 80169) -- Food
            and not UnitBuffID("player", 87959) -- Drink
            and not UnitCastingInfo("player")
            and not UnitChannelInfo("player")
            and not UnitIsDeadOrGhost("player")
            and not IsMounted()
            and not IsFlying()
        then
-- Rejuvenation
            if isChecked("Rejuvenation") and getHP("player") <= getValue("Rejuvenation") then
                if getBuffRemain("player",prl)==0 and getBuffRemain("player",rej)==0 and not isInCombat("player") then
                    if castSpell("player",rej,false,false) then return; end
                end
            end
-- Pot/Stoned
            if isChecked("Pot/Stoned") and getHP("player") <= getValue("Pot/Stoned") then
                if isInCombat("player") and usePot then
                    if canUse(5512) then
                        --useItem(5512)
                        UseItemByName(tostring(select(1,GetItemInfo(5512))))
                    elseif canUse(76097) then
                        --useItem(76097)
                        UseItemByName(tostring(select(1,GetItemInfo(76097))))
                    end
                end
            end
-- Healing Touch
            if isChecked("Healing Touch") and getBuffRemain("player",ps) > 0 and getHP("player") <= getValue("Healing Touch") and not (UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover")) then
                if castSpell("player",ht,false,false) then return; end
            end
-- Survival Instincts
            if isChecked("Survival Instincts") and getHP("player") <= getValue("Survival Instincts") and not UnitBuffID("player",si) then
                if castSpell("player",si,false,false) then return; end
            end
-- Frenzied Regeneration
            if isChecked("Frenzied Regen") and getHP("player") <= getValue("Frenzied Regen") then
                --if debugTable[1].spellid == nil then lastSpell = 0; else lastSpell = debugTable[1].spellid; end
                if not UnitBuffID("player",bf) then
                    if castSpell("player",bf,false,false) then return; end
                end
                if UnitBuffID("player",bf) and getPower("player")>0 then --and lastSpell ~= fr then
                    if castSpell("player",fr,false,false) then return; end
                end
                if UnitBuffID("player",bf) and getPower("player")==0 then
                    if castSpell("player",cf,false,false) then return; end --CancelShapeshiftForm();--
                end
            end
        else
            return false
        end
    else
        return false
    end
end

function feralInterrupts()
    local targetDistance = getDistance("player","target")

    if isChecked("Interrupt Mode") and UnitBuffID("player",cf) and not UnitBuffID("player",prl) then
        -- Skull Bash
        if canInterrupt(sb, tonumber(getValue("Interrupts")))
            and isChecked("Skull Bash")
            and targetDistance<=13
        then
            if castSpell("target",sb,false,false) then return; end
        end
        -- Mighty Bash
        if canInterrupt(mb, tonumber(getValue("Interrupts")))
            and isChecked("Mighty Bash")
            and (getSpellCD(sb) < 14 or not isChecked("Skull Bash"))
            and targetDistance<=5
        then
            if castSpell("target",mb,false,false) then return; end
        end
        -- Maim (PvP)
        if canInterrupt(ma, tonumber(getValue("Interrupts")))
            and (getSpellCD(sb) < 14 or not isChecked("Skull Bash"))
            and (getSpellCD(mb) < 49 or not isChecked("Mighty Bash"))
            and getCombo() > 0
            and UnitPower("player") >= 35
            and isInPvP()
            and targetDistance<=5
        then
            if castSpell("target",ma,false,false) then return; end
        end
    else
        return false
    end
end

function feralOpener()
    local targetDistance = getDistance("player","target")

    if not UnitIsDeadOrGhost("target")
        and UnitExists("target")
        and canAttack("player", "target")
        and UnitBuffID("player",cf)
        and targetDistance<=20
        and not isInCombat("player")
        and not isChecked("Death Cat Mode")
    then
        -- Prowl
        if not UnitBuffID("player",prl) then
            if castSpell("player",prl,false,false) then return; end
        end
        -- Shred
        if isInMelee() then
            if castSpell("target",shr,false,false) then return; end
        end
    else
        return false
    end
end

function feralSingle()
    if not enemiesTimer or enemiesTimer <= GetTime() - 1 then
        enemiesInRange, enemiesTimer = getNumEnemies("player",10), GetTime()
    end
    --local thisUnit = dynamicTarget(5)
    local feralPower = getPower("player")
    local feralPowerDiff = UnitPowerMax("player")-UnitPower("player")
    local targetDistance = getDistance("player","target")
    local prlRemain = getBuffRemain("player",prl)
    local savageRemain = getBuffRemain("player",svr)
    local ccRemain = getBuffRemain("player",cc)
    local rkRemain = getDebuffRemain("target",rk,"player")
    local rkDuration = getDebuffDuration("target",rk,"player")
    local ripRemain = getDebuffRemain("target",rp,"player")
    local ripDuration = getDebuffDuration("target",rp,"player")
    local thrRemain = getDebuffRemain("target",thr,"player")
    local thrDuration = getDebuffDuration("target",thr,"player")
    local rkCalc = CRKD()
    local rkApplied = RKD()
    local ripCalc = CRPD()
    local ripApplied = RPD()
    local feralTimeToMax = getTimeToMax("player")
    local tfCdRemain = getSpellCD(tf)

    -- Death Cat Mode
    if isChecked("Death Cat Mode") then
        if not UnitBuffID("player",cf) then
            if castSpell("player",cf,true) then return; end
        end
        if UnitExists("target") and targetDistance > 8 then
            ClearTarget()
        end
        if UnitBuffID("player",cf) and getPower("player") >= 25 then
            if enemiesInRange > 0 then
                if getPower("player") <= 35 and getSpellCD(tf) == 0 then
                    if castSpell("player",tf,false,false) then return; end
                end
                if getCombo() >= 5 then
                    if castSpell("player",svr,false,false) then return; end
                end
                if getPower("player") >= 40 and enemiesInRange == 1 then
                    if myEnemies == nil or myMultiTimer == nil or myMultiTimer <= GetTime() - 1 then
                        myEnemies, myMultiTimer = getEnemies("player",5), GetTime()
                    end
                    for i = 1, #myEnemies do
                        if getCreatureType(myEnemies[i]) == true then
                            local thisUnit = myEnemies[i]
                            if UnitCanAttack("player",thisUnit) and getDistance(thisUnit) <= 4 and getFacing(thisUnit) == true then
                                if castSpell(thisUnit,shr,false,false) then swipeSoon = nil; return; end
                            end
                        end
                    end
                end
                if getPower("player") >= 45 and enemiesInRange > 1 then
                    if swipeSoon == nil then
                        swipeSoon = GetTime();
                    end
                    if swipeSoon ~= nil and swipeSoon < GetTime() - 1 then
                        if castSpell("player",sw,false,false) then swipeSoon = nil; return; end
                    end
                end
            end
        end
    else
        if not UnitIsDeadOrGhost("target")
            and UnitExists("target")
            and canAttack("player", "target")
            and UnitBuffID("player",cf)
            and targetDistance<=20
            and isInCombat("player")
            and not isGarrMCd()
        then
            -- Dummy Test
            if isChecked("DPS Testing") then
                if UnitExists("target") then
                    if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                    end
                end
            end
            --Rake - if=buff.prowl.up|buff.shadowmeld.up
            if isInMelee() and (prlRemain>0 or rkRemain<3) and feralPower>=35 then
                if castSpell("target",rk,false,false) then return; end
            end
            -- Tiger's Fury - if=(!buff.omen_of_clarity.react&energy.max-energy>=60)|energy.max-energy>=80
            if isInMelee() and ((feralPowerDiff>=60 and ccRemain==0) or feralPowerDiff>=80) then
                if castSpell("player",tf,false,false) then return; end
            end
            -- Ferocious Bite - if=dot.rip.ticking&dot.rip.remains<=3&target.health.pct<25
            if isInMelee() and ripRemain>0 and ripRemain<=3 and getHP("target")<25 and feralPower>=25 then
                if castSpell("target",fb,false,false) then return; end
            end
            -- Healing Touch
            if getBuffRemain("player", ps) > 0 and (getBuffRemain("player", ps) <= 1.5 or getCombo() >= 4) then
                if getValue("Auto Heal")==1 then
                    if castSpell(nNova[1].unit,ht) then return; end
                end
                if getValue("Auto Heal")==2 then
                    if castSpell("player",ht,false,false) then return; end
                end
            end
            -- Savage Roar - if=buff.savage_roar.remains<3
            if savageRemain<3 and getCombo() > 0 and feralPower>=25 then
                if castSpell("player",svr,false,false) then return; end
            end
            -- Thrash - if=buff.omen_of_clarity.react&remains<=duration*0.3&active_enemies>1
            if useThrash() and targetDistance < 8 and ccRemain>0 and thrRemain <= thrDuration*0.3 then
                if castSpell("target",thr,false,false) then return; end
            end
            -- Ferocious Bite - if=combo_points=5&target.health.pct<25&dot.rip.ticking
            if isInMelee() and getCombo()>=5 and getHP("target")<25 and ripRemain>0 and feralPower>=50 then
                if castSpell("target",fb,false,false) then return; end
            end
            -- Rip - if=combo_points=5&remains<=3
            if isInMelee() and getCombo()>=5 and ripRemain<=3 and feralPower>=30 then
                if castSpell("target",rp,false,false) then return; end
            end
            -- Rip - if=combo_points=5&remains<=duration*0.3&persistent_multiplier>dot.rip.pmultiplier
            if isInMelee() and getCombo()>=5 and ripRemain<=ripDuration*0.3 and ripCalc > ripApplied and feralPower>=30 then
                if castSpell("target",rp,false,false) then return; end
            end
            -- Savage Roar - if=combo_points=5&(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)&buff.savage_roar.remains<42*0.3
            if getCombo()>=5 and (feralTimeToMax<=1 or UnitBuffID("player",ber) or tfCdRemain<3) and savageRemain<42*0.3 and feralPower>=25 then
                if castSpell("player",svr,false,false) then return; end
            end
            -- Ferocious Bite - if=combo_points=5&(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)
            if isInMelee() and getCombo()>=5 and (feralTimeToMax<=1 or UnitBuffID("player",ber) or tfCdRemain<3) and feralPower>=25 then
                if castSpell("target",fb,false,false) then return; end
            end
            -- Rake - if=remains<=3&combo_points<5
            if isChecked("Multi-Rake") and canCast(rk) then
                if  myEnemies == nil or myMultiTimer == nil or myMultiTimer <= GetTime() - 1 then
                    myEnemies, myMultiTimer = getEnemies("player",5), GetTime()
                end
                for i = 1, #myEnemies do
                    local thisUnit = myEnemies[i]
                    if getCreatureType(thisUnit)
                        and UnitCanAttack(thisUnit,"player")
                        and not UnitIsDeadOrGhost(thisUnit)
                        and getFacing("player",thisUnit)
                        and (UnitAffectingCombat(thisUnit) or isDummy(thisUnit))
                        and getDebuffRemain(thisUnit,rk,"player") < 3
                        and getPower("player") >= 35
                    then
                        if castSpell(thisUnit,rk,false,false) then return; end
                    end
                end
            end
            -- if isChecked("Multi-Rake") and canCast(rk) then
            --     if getDebuffRemain(thisUnit,rk,"player") < 3 and getPower("player") >= 35 then
            --         if castSpell(thisUnit,rk,false,false) then return; end
            --     end
            -- end
            -- Rake - if=remains<=duration*0.3&combo_points<5&persistent_multiplier>dot.rake.pmultiplier
            if isInMelee() and rkRemain<=rkDuration*0.3 and getCombo()<5 and rkCalc > rkApplied and feralPower>=35 then
                if castSpell("target",rk,false,false) then return; end
            end
            -- Thrash - if=remains<=duration*0.3&active_enemies>1
            if useThrash() and targetDistance < 8 and thrRemain<=thrDuration*0.3 and feralPower>=50 and ripRemain>ripDuration*0.3 then
                if castSpell("target",thr,false,false) then return; end
            end
            -- Rake - if=persistent_multiplier>dot.rake.pmultiplier&combo_points<5
            if isInMelee() and rkCalc > rkApplied and getCombo()<5 and feralPower>=35 then
                if castSpell("target",rk,false,false) then return; end
            end
            --swipe,if=combo_points<5&active_enemies>=3
            if useAoE() and targetDistance < 8 and getCombo()<5 and feralPower>=45 then
                if castSpell("target",sw,false,false) then return; end
            end
            -- Shred - if=combo_points<5&active_enemies<3
            if not useAoE() and isInMelee() and getCombo()<5 and feralPower>=40 and (getCombo()<5 or feralTimeToMax <= 1) then
                if castSpell("target",shr,false,false) then return; end
            end
        else
            return false
        end
    end
end


--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[]]     --[[]]   --[[]]              --[[]]                   --[[ ]]        --[[]]     --[[]]
--[[           ]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[]]     --[[]]
--[[        ]]      --[[]]                         --[[]]        --[[ ]]        --[[]]     --[[]]
--[[]]    --[[]]    --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]
--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]


-- SwiftMender
function SwiftMender()
    if isChecked("Swiftmend") then
        if lowestHP < getValue("Swiftmend") then
            if lowestHP <= getValue("Swiftmend") then
                if getBuffRemain(lowestUnit,774,"player") > 1 or getBuffRemain(lowestUnit,8936,"player") > 1 then
                    if castSpell(lowestUnit,18562,true,false) then return; end
                end
            end
        end
    end
end

function findShroom()
    if shroomsTable[1].x == nil then
        for i = 1, ObjectCount() do
            local myShroom = shroomsTable[1].guid
            --print(UnitGUID(ObjectWithIndex(i)))
            if shroomsTable[1].guid == UnitGUID(ObjectWithIndex(i)) then
                X, Y, Z = ObjectPosition(ObjectWithIndex(i));
               -- print("lol")
                shroomsTable[1] = { x = X, y = Y, z = Z, guid = myShroom };
                return true
            end
        end
    else
        return true
    end
    return false;
end




end