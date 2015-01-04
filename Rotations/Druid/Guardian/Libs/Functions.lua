if select(3, UnitClass("player")) == 11 then

--chumii useAoE / no idea, but cutes didnt work for me oO
function chumiigetmeleeEnemies()
    if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
    meleeEnemies, ScanTimer = getNumEnemies("player",8), GetTime();
   -- print("MeleeEnemies:"..meleeEnemies);
    end
    return meleeEnemies;
end

function chumiiuseAoE()
    if BadBoy_data['AoE'] == 1 and chumiigetmeleeEnemies() >= 3 then
    -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
        return true
    else
        return false
    end
end

end