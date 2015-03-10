if select(3,UnitClass("player")) == 10 then


  function Raidbuff_Monk()
                if not LotWT_last_check or LotWT_last_check + 5 < GetTime() then
                        LotWT_last_check = GetTime()
                        LotWT_unbuffedPlayers = {}
                        --local unbuffedPlayers = LotWT_unbuffedPlayers

                        local StatsTable = {1126,115921,116781,20217,160206}
                        if GetNumGroupMembers()==0 then
                                if not UnitIsDeadOrGhost("player")  then
                                        local playerBuffed=false
                                        for auraIndex=1, #StatsTable do
                                                local buffActive=UnitBuffID("player", StatsTable[auraIndex])
                                                playerBuffed=playerBuffed or buffActive ~= nil
                                        end

                                        if not playerBuffed then
                                                local playerName=UnitName("player");
                                                --table.insert(unbuffedPlayers, playerName)
                                                if castSpell("player",_LegacyOfTheWhiteTiger,true) then return; end
                                        end
                                        --return unbuffedPlayers[1] ~= nil
                                end
                        else
                                for index=1, GetNumGroupMembers() do
                                        local name, _, subgroup, _, _, _, zone, online, isDead, _, _ = GetRaidRosterInfo(index)
                                        if online and not isDead and 1==IsSpellInRange(StatsTable[1], "raid"..index) then
                                                local playerBuffed = false
                                                for auraIndex=1, #StatsTable do
                                                        local buffActive = UnitBuffID(("raid"..index), StatsTable[auraIndex])
                                                        playerBuffed = playerBuffed or buffActive ~= nil
                                                end
                                                if not playerBuffed then
                                                        --table.insert(unbuffedPlayers, name)
                                                        if castSpell("player",_LegacyOfTheWhiteTiger,true) then return; end
                                                end
                                        end
                                end
                                --return unbuffedPlayers[1] ~= nil
                        end
                end
        end

  function StaggerValue()
    local staggerLight, _, iconLight, _, _, remainingLight, _, _, _, _, _, _, _, _, _, valueStaggerLight, _ = UnitAura("player", GetSpellInfo(124275), "", "HARMFUL")
    local staggerModerate, _, iconModerate, _, _, remainingModerate, _, _, _, _, _, _, _, _, _, valueStaggerModerate, _ = UnitAura("player", GetSpellInfo(124274), "", "HARMFUL")
    local staggerHeavy, _, iconHeavy, _, _, remainingHeavy, _, _, _, _, _, _, _, _, _, valueStaggerHeavy, _ = UnitAura("player", GetSpellInfo(124273), "", "HARMFUL")
    local staggerTotal= (valueStaggerLight or valueStaggerModerate or valueStaggerHeavy or 0)
    local percentOfHealth=(100/UnitHealthMax("player")*staggerTotal)
    local ticksTotal=(valueStaggerLight or valueStaggerLight or valueStaggerLight or 0)
    return percentOfHealth;
  end

  function DrinkStagger()
    if UnitDebuff("player", GetSpellInfo(124273)) then --Heavy Stagger
      return true
    end
    if UnitDebuff("player", GetSpellInfo(124274)) and StaggerValue() > 25 then --Moderate Stagger and Staggervalue > 25% HP
      return true
    end
    -- else
    --     return false
    -- end
  end

  function GuardSize()
    local name = GetSpellInfo(115295)
    local guard_size = select(15, UnitAura("player", name))
    return guard_size
  end

  function useCDsBrM()
    if (BadBoy_data['Cooldowns'] == 1 and (isBoss() or isDummy("target"))) or BadBoy_data['Cooldowns'] == 2 then
      return true
    else
      return false
    end
  end

  function useDefCDsBrM()
    if BadBoy_data['Defensive'] == 1 then
      return true
    else
      return false
    end
  end

  function useSingleRJW()
    if BadBoy_data['Singlerjw'] == 1 then
      return true
    else
      return false
    end
  end

  function getmeleeEnemiesBrM()
    if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
      meleeEnemies, ScanTimer = getNumEnemies("player",8), GetTime();
    -- print("MeleeEnemies:"..meleeEnemies);
    end
    return meleeEnemies;
  end

  function useAoEBrM()
    if BadBoy_data['AoE'] == 1 and getmeleeEnemiesBrM() >= 3 then
      -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
      return true
    else
      return false
    end
  end
  -- function useAoEBrM()
  --     if BadBoy_data['AoE'] == 1 and #enemiesTable >= 3 then
  --         return true
  --     else
  --         return false
  --     end
  -- end

  --[[]]     --[[]]	--[[           ]]	--[[           ]]	--[[           ]]
  --[[ ]]   --[[ ]] 		 --[[ ]]		--[[           ]]	--[[           ]]
  --[[           ]] 		 --[[ ]]		--[[]]	   				 --[[ ]]
  --[[           ]]		 --[[ ]]		--[[           ]]		 --[[ ]]
  --[[]] 	   --[[]]		 --[[ ]]				   --[[]]		 --[[ ]]
  --[[]]	   --[[]]		 --[[ ]]		--[[           ]]		 --[[ ]]
  --[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[ ]]

end
