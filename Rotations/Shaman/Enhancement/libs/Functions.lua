if select(3,UnitClass("player")) == 7 then

--[[           ]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[]]     --[[]]
--[[           ]]   --[[]]     --[[]]   --[[  ]]   --[[]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[  ]]   --[[]]
--[[]]              --[[]]     --[[]]   --[[    ]] --[[]]   --[[]]                   --[[ ]]             --[[ ]]        --[[]]     --[[]]   --[[    ]] --[[]]
--[[           ]]   --[[]]     --[[]]   --[[           ]]   --[[]]                   --[[ ]]             --[[ ]]        --[[]]     --[[]]   --[[           ]]
--[[           ]]   --[[]]     --[[]]   --[[           ]]   --[[]]                   --[[ ]]             --[[ ]]        --[[]]     --[[]]   --[[           ]]
--[[]]              --[[           ]]   --[[]]   --[[  ]]   --[[           ]]        --[[ ]]        --[[           ]]   --[[           ]]   --[[]]   --[[  ]]
--[[]]              --[[           ]]   --[[]]     --[[]]   --[[           ]]        --[[ ]]        --[[           ]]   --[[           ]]   --[[]]     --[[]]

function isFireTotem(SpellID)
    if tostring(select(2,GetTotemInfo(1))) == tostring(GetSpellInfo(SpellID)) then return true; else return false; end
end

function isAirTotem(SpellID)
    if tostring(select(2,GetTotemInfo(4))) == tostring(GetSpellInfo(SpellID)) then return true; else return false; end
end

--[[           ]]   --[[]]              --[[           ]]
--[[           ]]   --[[]]              --[[           ]]
--[[]]              --[[]]              --[[]]
--[[           ]]   --[[]]              --[[           ]]
--[[]]              --[[]]              --[[]]
--[[           ]]   --[[]]              --[[           ]]
--[[           ]]   --[[           ]]   --[[           ]]




--[[           ]]   --[[]]     --[[]]   --[[]]     --[[]]         --[[]]        --[[]]     --[[]]   --[[           ]]   --[[           ]]
--[[           ]]   --[[  ]]   --[[]]   --[[]]     --[[]]        --[[  ]]       --[[  ]]   --[[]]   --[[           ]]   --[[           ]]
--[[]]              --[[    ]] --[[]]   --[[]]     --[[]]       --[[    ]]      --[[    ]] --[[]]   --[[]]              --[[]]
--[[           ]]   --[[           ]]   --[[           ]]      --[[      ]]     --[[           ]]   --[[]]              --[[           ]]
--[[]]              --[[           ]]   --[[]]     --[[]]     --[[        ]]    --[[           ]]   --[[]]              --[[]]
--[[           ]]   --[[]]   --[[  ]]   --[[]]     --[[]]    --[[]]    --[[]]   --[[]]   --[[  ]]   --[[           ]]   --[[           ]]
--[[           ]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[]]      --[[]]  --[[]]     --[[]]   --[[           ]]   --[[           ]]




function getMWC()
    mwstack = select(4,UnitBuffID("player",53817))
    if UnitLevel("player") >= 50 then
        if mwstack == nil then
            return 0
        else
            return mwstack
        end
    else
        return 5
    end
end
function hasFire()
    if GetTotemTimeLeft(1) > 0 then
        return true
    else
        return false
    end
end
function hasSearing()
    if select(2, GetTotemInfo(1)) == GetSpellInfo(_SearingTotem) then
        return true
    else
        return false
    end
end
function hasMagma()
    if select(2, GetTotemInfo(1)) == GetSpellInfo(_MagmaTotem) then
        return true
    else
        return false
    end
end
function hasFireElemental()
    if select(2, GetTotemInfo(1)) == GetSpellInfo(_FireElementalTotem) then
        return true
    else
        return false
    end
end
function hasWater()
    if GetTotemTimeLeft(3) > 0 then
        return true
    else
        return false
    end
end
function useCDs()
    if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
        return true
    else
        return false
    end
end
function useAoE()
    if (BadBoy_data['AoE'] == 1 and getNumEnemies("player",10) >= 3) or BadBoy_data['AoE'] == 2 then
        return true
    else
        return false
    end
end
function hasHST()
    if select(2, GetTotemInfo(3)) == GetSpellInfo(5394) then
        return true
    else
        return false
    end
end
function hasTotem()
    if UnitLevel("player") >= 30 and (GetTotemTimeLeft(1) > 0 or GetTotemTimeLeft(2) > 0 or GetTotemTimeLeft(3) > 0 or GetTotemTimeLeft(4) > 0) then
        return true
    else
        return false
    end
end
function getSearingCount()
    sfstack = select(4,UnitBuffID("player",_SearingFlames))
    if UnitLevel("player") >= 34 then
        if sfstack == nil then
            return 0
        else
            return sfstack
        end
    else
        return 5
    end
end
function shouldBolt()
    local lightning = 0
    local lowestCD = 0
    if useAoE() then
        if getSpellCD(_ChainLightning)==0 and UnitLevel("player")>=28 then
            if UnitBuffID("player",_AncestralSwiftness) and (select(7,GetSpellInfo(_ChainLightning))/1000)<10 then
                lightning = 0
            else
                lightning = select(7,GetSpellInfo(_ChainLightning))/1000
            end
        else
            if UnitBuffID("player",_AncestralSwiftness) and (select(7,GetSpellInfo(_LightningBolt))/1000)<10 then
                lightning = 0
            else
                lightning = select(7,GetSpellInfo(_LightningBolt))/1000
            end
        end
    else
        if UnitBuffID("player",_AncestralSwiftness) and (select(7,GetSpellInfo(_LightningBolt))/1000)<10 then
            lightning = 0
        else
            lightning = select(7,GetSpellInfo(_LightningBolt))/1000
        end
    end
    if UnitLevel("player") < 3 then
        lowestCD = lightning+1
    elseif UnitLevel("player") < 10 then
        lowestCD = min(getSpellCD(_PrimalStrike))
    elseif UnitLevel("player") < 12 then
        lowestCD = min(getSpellCD(_PrimalStrike),getSpellCD(_LavaLash))
    elseif UnitLevel("player") < 26 then
        lowestCD = min(getSpellCD(_PrimalStrike),getSpellCD(_LavaLash),getSpellCD(_FlameShock))
    elseif UnitLevel("player") < 81 then
        lowestCD = min(getSpellCD(_StormStrike),getSpellCD(_LavaLash),getSpellCD(_FlameShock))
    elseif UnitLevel("player") < 87 then
        lowestCD = min(getSpellCD(_Stormstrike),getSpellCD(_FlameShock),getSpellCD(_LavaLash),getSpellCD(_UnleashElements))
    elseif UnitLevel("player") >= 87 then
        if getBuffRemain("player",_AscendanceBuff) > 0 then
            lowestCD = min(getSpellCD(_Stormblast),getSpellCD(_FlameShock),getSpellCD(_LavaLash),getSpellCD(_UnleashElements))
        else
            lowestCD = min(getSpellCD(_Stormstrike),getSpellCD(_FlameShock),getSpellCD(_LavaLash),getSpellCD(_UnleashElements))
        end
    end
    if lightning <= lowestCD and getTimeToDie("target") >= lightning then
        return true;
    elseif castingUnit("player") and (isCastingSpell(_LightningBolt) or isCastingSpell(_ChainLightning)) and lightning > lowestCD then
        StopCasting()
        return false;
    else
        return false;
    end
end
--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[]]     --[[]]   --[[]]              --[[]]                   --[[ ]]        --[[]]     --[[]]
--[[           ]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[]]     --[[]]
--[[        ]]      --[[]]                         --[[]]        --[[ ]]        --[[]]     --[[]]
--[[]]    --[[]]    --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]
--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]



function EarthShield()
    -- We look if someone in Nova have our shield
    local foundShield, shieldRole = false, "none"
    for i = 1, #nNova do
        if getBuffStacks(nNova[i].unit,_EarthShield,"player") > 2 then
            if nNova[i].role == "TANK" or UnitIsUnit("focus",nNova[i].unit) then
                shieldRole = "tank or focus";
            end
            foundShield = true;
            break;
        end
    end

    -- if no valid shield found
    if foundShield == false or shieldRole == "none" then
        -- if we have focus, check if this unit have shield, if it's not ours, find another target.
        if UnitExists("focus") == true then
            if not UnitBuffID("focus", _WaterShield) and not UnitBuffID("focus", _EarthShield) and not UnitBuffID("focus", _LightningShield) then
                if castSpell("focus",_EarthShield,true,false) then print("recast focus")return; end
            end
        else
            -- if focus was already buffed or is invalid then we chek nNova roles for tank.
            for i = 1, #nNova do
                if not UnitBuffID(nNova[i].unit, _WaterShield) and not UnitBuffID(nNova[i].unit, _EarthShield) and not UnitBuffID(nNova[i].unit, _LightningShield) and nNova[i].role == "TANK" and nNova[i].hp < 100 then
                    if castSpell(nNova[i].unit,_EarthShield,true,false) then return; end
                end
            end
        end
        if shieldRole == "none" and shieldFound == false then
            -- if no tank was found we are gonna cast on the lowest unit and wait for it to be under 2 stack or we have a tank before recasting.
            for i = 1, # nNova do
                if not UnitBuffID("focus", _WaterShield) and not UnitBuffID("focus", _EarthShield) and not UnitBuffID("focus", _LightningShield) and nNova[i].hp < 100 and castSpell(nNova[i].unit,_EarthShield,true,false) then return; end
            end
        end
    end
end




end

