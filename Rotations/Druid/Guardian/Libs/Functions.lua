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
    if BadBoy_data['AoE'] == 1 and chumiigetmeleeEnemies() >= 5 then
      -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
      return true
    else
      return false
    end
  end

  -- TODO: better cylce, prio 1 should be the one with lowest time remain (if < 4sec) -> with lowest stack -> if all at 3 then lowest time remain
  function getLacerateTarget()
      local enemiesTable = enemiesTable
      local bestEnemy = "target"
      if #enemiesTable > 1 then
          bestEnemy = enemiesTable[1].unit
          for i = 1, #enemiesTable do
              local thisEnemy = enemiesTable[i]
              local thisLac = getDebuffRemain(thisEnemy.unit, lac) or 0
              local thisLacStacks = getDebuffStacks(thisEnemy.unit, lac) or 0
              local bestLac = getDebuffRemain(bestEnemy, lac) or 0
              local bestLacStacks = getDebuffStacks(bestEnemy, lac) or 0

              -- if its in range
              if thisEnemy.distance <= 5 then
                  -- Prio 1: Lacerate refresh if under 3sec
                  if thisLac < 3 and thisLacStacks >= 1  then
                     bestEnemy = thisEnemy.unit
                     return bestEnemy
                  end

                  -- Prio 2: lowest Lacerate Stack
                  if bestLacStacks > thisLacStacks then
                      bestEnemy = thisEnemy.unit
                  end

                  -- Prio 3: lowest Lacerate remain
                  if bestLac > thisLac and (thisLacStacks >= 1 and bestLacStacks >= 1) then
                      bestEnemy = thisEnemy.unit
                  end
              end
          end
      end
      return bestEnemy
  end

end
