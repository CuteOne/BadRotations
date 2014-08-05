if select(3, UnitClass("player")) == 11 then

--Shred glyph and facing checks
function canShred()
    if ((UnitBuffID("player",106951) or UnitBuffID("player",5217)) and hasGlyph(114234) == true) or getFacing("target","player") == false then
        return true;
    else
        return false;
    end
end

--Potential Mangle Damage
function getMangleDamage() 
    local calc = (1 * 78 + 1.25 * (select(1, UnitDamage("player")) + select(2, UnitDamage("player"))))*(1 - (24835 * (1 - .04 * 0)) / (24835 * (1 - .04*0) + 46257.5));
    if select(4,UnitBuffID("player",145152)) == nil then 
        return calc;
    else
        return calc*1.3;
    end
end

--Potential Ferocious Bite Damage
function getFerociousBiteDamage()
    local calc = (315 + 762 * GetComboPoints("player") + 0.196 * GetComboPoints("player") * UnitAttackPower("player"))
    if select(4,UnitBuffID("player",145152)) == nil then
        return calc;
    else
        return calc*1.3;
    end
end

--Savage Roar Duration Tracking
function getSRR()        
    if hasGlyph(127540) then
        if UnitBuffID("player",127538) and UnitLevel("player") >= 18 then
            return getBuffRemain("player",127538)
        else
            if UnitLevel("player") < 18 then
                return 999
            else
                return 0
            end
        end
    else
        if UnitBuffID("player",52610) and UnitLevel("player") >= 18 then
            return getBuffRemain("player",127538)
        else
            if UnitLevel("player") < 18 then
                return 999
            else
                return 0
            end
        end
    end
end

--Total Savage Roar Time
function getSRT()        
    if (12 + (getCombo("player")*6)) > (getSRR() + 12) then
        return true
    else
        return false
    end
end

--Savage Roar / Rip Duration Difference
function getSrRpDiff()   
    if UnitLevel("player") >= 20 then
        local srrpdiff = (getDebuffRemain("target",rp) - getSRR()) 
        if srrpdiff < 0 then
            return -srrpdiff 
        else
            return srrpdiff 
        end
    else
        return 0
    end
end

--Rune of Reorigination Duration Tracking
function getRoRoRemain()       
    if UnitBuffID("player",139121) then
        return (select(7, UnitBuffID("player",139121)) - GetTime())
    elseif UnitBuffID("player",139117) then
        return (select(7, UnitBuffID("player",139117)) - GetTime())
    elseif UnitBuffID("player",139120) then
        return (select(7, UnitBuffID("player",139120)) - GetTime())
    else
        return 0
    end
end

--Rake Filler
function getRkFill()  
    if getTimeToDie("target") > 3 
        and CRKD()*((getDebuffRemain("target",rk) / 3 ) + 1 ) - RKD()*(getDebuffRemain("target",rk) / 3) > getMangleDamage() 
    then
        return true
    else
        return false
    end
end

--Rake Override
function getRkOver()   
    if getTimeToDie("target") - getDebuffRemain("target",rk) > 3 
        and (RKP() > 108 or (getDebuffRemain("target",rk) < 3 and getRakeDamage() >= 75))
    then
        return true
    else 
        return false
    end
end

--Symbiosis Priority Cast
function classPrio(t)
    local class = select(3,UnitClass(t))
   
    if class == 1 then --Warrior
            return 1
    elseif class == 2 then --Paladin
            return 5
    elseif class == 3 then --Hunter
            return 8
    elseif class == 4 then --Rogue
            return 4
    elseif class == 5 then --Priest
            return 6
    elseif class == 6 then --Deathknight
            return 7
    elseif class == 7 then --Shaman
            return 2
    elseif class == 8 then --Mage
            return 9
    elseif class == 9 then --Warlock
            return 3
    elseif class == 10 then --Monk
            return 10
    elseif class == 11 then --Druid
            return 11
    end
end
 
local symIDs = {
 110478, --DK
 110479, --Hunter
 110482, --Made
 110483, --Monk
 110484, --Paladin
 110485, --Priest
 110486, --Rogue
 110488, --Shaman
 110490, --Warlock
 110491 --Warrior
}
 
function HasSymb( t )
    for i=1, #symIDs do
        local hasSym = select(15,UnitBuffID(t,symIDs[i]))
        local class = select(3,UnitClass( t ))
 
        if hasSym or class == 11 then
                return true
        else
                return false
        end
    end
end
 
function SymMem()
--  symmem, symgroup = { { Unit = "player", Prio = classPrio("Player"), Class = select(2, UnitClass("Player")),ClassID = select(3,UnitClass("Player")) } }, { low = 0, tanks = { } }
    symmem, symgroup = { {Prio = 12 } }, { low = 0, tanks = { } }
    symgroup.type = IsInRaid() and "raid" or "party"
    symgroup.number = GetNumGroupMembers()
    if symgroup.number > 0 then   
        for i=1,symgroup.number do
            if CanHeal(symgroup.type..i) and not HasSymb(symgroup.type..i) then
                local unit, prio, class, classID = symgroup.type..i, classPrio(symgroup.type..i), select(2, UnitClass(symgroup.type..i)), select(3,UnitClass(symgroup.type..i))
                table.insert( symmem,{ Unit = unit, Prio = prio, Class = class, ClassID = classID } )
 
                if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(symgroup.tanks,unit) end
            end
        end
   
        if symgroup.type == "Raid" and #members > 1 then table.remove(symmem,1) end
        table.sort(symmem, function(x,y) return x.Prio < y.Prio end)
  --  local customtarget = CanHeal("target") and "target" -- or CanHeal("mouseover") and GetMouseFocus() ~= WorldFrame and "mouseover"
  --  if customtarget then table.sort(symmem, function(x) return UnitIsUnit(customtarget,x.Unit) end) end
    end
end

function GroupInfo()
    members, group = { { Unit = "player" } }, { low = 0, tanks = { } }      
    group.type = IsInRaid() and "raid" or "party" 
    group.number = GetNumGroupMembers()
    if group.number > 0 then
        for i=1,group.number do 
            local unit = group.type..i
            table.insert( members,{ Unit = unit } ) 
        end 
        if group.type == "raid" and #members > 1 then table.remove(members,1) end    
    end
end

-- Bleed Calculations
function getStatsMult()
    local CritDamageMult = 2 -- adjust for crit damage meta
    local APBase, APPos, APNeg = UnitAttackPower("player")
    local AP = APBase + APPos + APNeg
    local DamageMult = select(7, UnitDamage("player"))
    local Mastery = 1 + GetMasteryEffect() / 100
    
    local PlayerLevel, TargetLevel = UnitLevel("player"), UnitLevel("target")
    local CritChance
    if TargetLevel == -1 then
        CritChance = (GetCritChance()-3)/100
    else
        CritChance = (GetCritChance()-max(TargetLevel-PlayerLevel,0))/100
    end
    local CritEffMult =  1 + (CritDamageMult-1)*CritChance
    
    local CP = GetComboPoints("player", "target")
    if CP == 0 then CP = 5 end
    
    local DoCSID = select(11, UnitAura("player", "Dream of Cenarius"))
    if DoCSID == 145152 then
        DamageMult = DamageMult * 1.3
    end

    local StatsMultiplier = Mastery*DamageMult--*CritEffMult
    return StatsMultiplier
end

--Calculated Rake Dot Damage
function CRKD()
    local APBase, APPos, APNeg = UnitAttackPower("player")
    local AP = APBase + APPos + APNeg
    local calcRake = round2((99+0.3*AP)*getStatsMult(),0)
    return calcRake
end

--Applied Rake Dot Damage 
function RKD()
    local rakeDot = 1
    if Rake_sDamage[UnitGUID("target")] ~= nil then rakeDot = Rake_sDamage[UnitGUID("target")]; end
    return rakeDot
end

function OldRKD()
    local OldrakeDot = 1
    OldrakeDot = getDotDamage("target",rk)
    return OldrakeDot
end  

--Rake Dot Damage Percent
function RKP()
    local RatioPercent = (CRKD() / RKD()) * 100
    return RatioPercent
end

--Calculated Rip Dot Damage
function CRPD()
    local APBase, APPos, APNeg = UnitAttackPower("player")
    local AP = APBase + APPos + APNeg
    local calcRip = (113+5*(320+0.0484*AP))*getStatsMult()     
    return calcRip
end

--Applied Rake Dot Damage
function RPD()
    local ripDot = 1
    if Rip_sDamage[UnitGUID("target")] ~= nil then ripDot = Rip_sDamage[UnitGUID("target")]; end
    return ripDot
end

--Rip Dot Damage Percent
function RPP()
    local RatioPercent = (CRPD() /RPD()) * 100
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
    if (BadBoy_data['AoE'] == 1 and getNumEnnemies("player",10) >= 3) or BadBoy_data['AoE'] == 2 then
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


end