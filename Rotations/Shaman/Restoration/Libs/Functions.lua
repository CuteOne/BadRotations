if select(3,UnitClass("player")) == 7 then

function EarthShield()
    -- We look if someone in Nova have our shield
    local foundShield, shieldRole = false, "none"
    for i = 1, #nNova do
        if getBuffStacks(nNova[i].unit,_EarthShield,"player") > 2 then
            if nNova[i].role == "TANK" or UnitIsUnit("focus",nNova[i].unit) then
                shieldRole = "tank or focus"
            end
            foundShield = true
            break
        end
    end

    -- if no valid shield found
    if foundShield == false or shieldRole == "none" then
        -- if we have focus, check if this unit have shield, if it's not ours, find another target.
        if UnitExists("focus") == true then
            if not UnitBuffID("focus", _WaterShield) and not UnitBuffID("focus", _EarthShield) and not UnitBuffID("focus", _LightningShield) then
                if castSpell("focus",_EarthShield,true,false) then print("recast focus")return end
            end
        else
            -- if focus was already buffed or is invalid then we chek nNova roles for tank.
            for i = 1, #nNova do
                if not UnitBuffID(nNova[i].unit, _WaterShield) and not UnitBuffID(nNova[i].unit, _EarthShield) and not UnitBuffID(nNova[i].unit, _LightningShield) and nNova[i].role == "TANK" and nNova[i].hp < 100 then
                    if castSpell(nNova[i].unit,_EarthShield,true,false) then return end
                end
            end
        end
        if shieldRole == "none" and shieldFound == false then
            -- if no tank was found we are gonna cast on the lowest unit and wait for it to be under 2 stack or we have a tank before recasting.
            for i = 1, # nNova do
                if not UnitBuffID("focus", _WaterShield) and not UnitBuffID("focus", _EarthShield) and not UnitBuffID("focus", _LightningShield) and nNova[i].hp < 100 and castSpell(nNova[i].unit,_EarthShield,true,false) then return end
            end
        end
    end
end




end

