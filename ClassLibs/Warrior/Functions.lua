if select(3, UnitClass("player")) == 1 then

-------------------------------------
--- Evil Eye CD Reduction Trinket ---
-------------------------------------
function EvilEye()
  if CD_Trinket == nil then

    if (GetInventoryItemID("player", 13) == 105491
      or GetInventoryItemID("player", 14) == 105491) then -- heroic warforged 47%
        CD_Reduction_Value = (1 / 1.47)
        CD_Trinket = true

    elseif (GetInventoryItemID("player", 13) == 104495 -- heroic 44%
      or GetInventoryItemID("player", 14) == 104495) then
        CD_Reduction_Value = (1 / 1.44)
        CD_Trinket = true

    elseif (GetInventoryItemID("player", 13) == 105242 -- warforged 41%
      or GetInventoryItemID("player", 14) == 105242) then
        CD_Reduction_Value = (1 / 1.41)
        CD_Trinket = true

    elseif (GetInventoryItemID("player", 13) == 102298  -- normal 39%
      or GetInventoryItemID("player", 14) == 102298) then
        CD_Reduction_Value = (1 / 1.39)
        CD_Trinket = true

    elseif (GetInventoryItemID("player", 13) == 104744 -- flex 34%
      or GetInventoryItemID("player", 14) == 104744) then
        CD_Reduction_Value = (1 / 1.34)
        CD_Trinket = true

    elseif (GetInventoryItemID("player", 13) == 104993  -- lfr 31%
      or GetInventoryItemID("player", 14) == 104993) then
        CD_Reduction_Value = (1 / 1.31)
        CD_Trinket = true
    end

    if CD_Trinket ~= true then
      CD_Trinket = false
      CD_Reduction_Value = 1
    end
  end
end

-----------
--- AoE ---
-----------
function useAoE()
    if (BadBoy_data['AoE'] == 1 and getNumEnemies("player",8) >= 2) or BadBoy_data['AoE'] == 2 then
    -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
        return true
    else
        return false
    end
end

-----------------
--- Cooldowns ---
-----------------
function useCDs()
    if (BadBoy_data['Cooldowns'] == 1 and (isBoss("target") or isDummy("target"))) or BadBoy_data['Cooldowns'] == 2 then
        return true
    else
        return false
    end
end

function useDefCDs()
    if BadBoy_data['Defensive'] == 1 then
        return true
    else
        return false
    end
end

-----------------------
--- Bloodlust check ---
-----------------------
function hasLust()
    if UnitBuffID("player",2825)        -- Bloodlust
    or UnitBuffID("player",80353)       -- Timewarp
    or UnitBuffID("player",32182)       -- Heroism
    or UnitBuffID("player",90355) then  -- Ancient Hysteria
        return true
    else
        return false
    end
end

-------------------------------------
--- Shield Block / Barrier Switch ---
-------------------------------------

SLASH_BLOCKBARRIER1 = '/blockbarrier';
function SlashCmdList.BLOCKBARRIER(msg, editbox)
  if BadBoy_data["Drop BlockBarrier"] == 1 then
    RunMacroText("/run BadBoy_data['Drop BlockBarrier'] = 2");
    ChatOverlay("Using Shield Barrier")
  elseif BadBoy_data["Drop BlockBarrier"] == 2 then
    RunMacroText("/run BadBoy_data['Drop BlockBarrier'] = 1");
    ChatOverlay("Using Shield Block")
  end
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

function ArmsSingleTarIcyVeins()
    if castSpell("player",Bloodbath,true) then
        return;
    end
    --and getDistance("player","target") <= 5
    if not useAoE() then
        if UnitBuffID("player",SuddenDeathSpellAura) then
            if castSpell("target",ExecuteArms,false,false) then
                return;
            end
        end
        if getHP("target") > 20 then
            -- Outside CS
            if not UnitDebuffID("target",ColossusSmash,"player") then
                -- Rend
                if isGarrMCd("target") == false then
                if getDebuffRemain("target",Rend,"player") <= 5 then
                    if castSpell("target",Rend,false,false) then
                        return;
                    end
                end
            end
                -- MS
                if castSpell("target",MortalStrike,false,false) then
                    return;
                end
                -- CS
                if castSpell("target",ColossusSmash,false,false) then
                    return;
                end
                -- DragonRoar
                if isKnown(DragonRoar) then
                    if castSpell("target",DragonRoar,true) then
                        return;
                    end
                end
                -- Stormbolt
                if isKnown(StormBolt) then
                    if castSpell("target",StormBolt,false,false) then
                        return;
                    end
                end
                -- Slam
                if not isKnown(Slam) then
                    if castSpell("target",Whirlwind,false,false) then
                        return;
                    end
                end
                -- Whirlwind
                if isKnown(Slam) then
                    if castSpell("target",Slam,false,false) then
                        return;
                    end
                end
            end -- Outside CS end
            -- Inside CS
            if UnitDebuffID("target",ColossusSmash,"player") then
                -- MS
                if castSpell("target",MortalStrike,false,false) then
                    return;
                end
                -- Stormbolt
                if isKnown(StormBolt) then
                    if castSpell("target",StormBolt,false,false) then
                        return;
                    end
                end
                if not isKnown(Slam) then
                    if castSpell("target",Whirlwind,false,false) then
                        return;
                    end
                end
                if isKnown(Slam) then
                    if castSpell("target",Slam,false,false) then
                        return;
                    end
                end
            end -- Inside CS end
        end -- > 20% end
        -- Execute Phase
        if getHP("target") < 20 then
            -- Outside CS
            if not UnitDebuffID("target",ColossusSmash,"player") then
                -- Rend
                if isGarrMCd("target") == false then
                if getDebuffRemain("target",Rend,"player") <= 5 then
                    if castSpell("target",Rend,false,false) then
                        return;
                    end
                end
            end
                -- Execute
                if UnitPower("player") >= 60 then
                    if castSpell("target",ExecuteArms,false,false) then
                        return;
                    end
                end
                -- CS
                    if castSpell("target",ColossusSmash,false,false) then
                        return;
                    end
                -- DragonRoar
                if isKnown(DragonRoar) then
                    if castSpell("target",DragonRoar,true) then
                        return;
                    end
                end
                -- Stormbolt
                if isKnown(StormBolt) then
                    if castSpell("target",StormBolt,false,false) then
                        return;
                    end
                end
            end -- Outside CS end
            -- Inside CS
            if UnitDebuffID("target",ColossusSmash,"player") then
                -- Stormbolt
                if isKnown(StormBolt) then
                    if UnitPower("player") < 70 then
                        if castSpell("target",StormBolt,false,false) then
                            return;
                        end
                    end
                end
                -- Execute
                if castSpell("target",ExecuteArms,false,false) then
                    return;
                end
            end -- Inside CS end
        end -- < 20% end
    end -- Single Target end
end

function ArmsMultiTarIcyVeins()
    if useAoE() then
        if castSpell("player",Bloodbath,true) then
        return;
    end
                -- SweepingStrikes
                if not UnitBuffID("player",SweepingStrikes) then
                    if castSpell("player",SweepingStrikes,true) then
                        return;
                    end
                end
                -- Spread Rend to 4-5 Tars
                if isGarrMCd("target") == false then
                    if getDebuffRemain("target",Rend,"player") <= 5 then
                        if castSpell("target",Rend,false,false) then
                            return;
                        end
                    end
                end
                -- Dragon Roar
                if isKnown(DragonRoar) then
                    if castSpell("target",DragonRoar,true) then
                        return;
                    end
                end
                --Whirlwind
                if castSpell("target",Whirlwind,false,false) then
                    return;
                end
            end -- Multi Target end
        end

function ArmsSingleTarSimCraft()
    if not useAoE() then
        if castSpell("player",Bloodbath,true) then
        return;
    end
        -- actions.single=rend,if=ticks_remain<2&target.time_to_die>4
        if isGarrMCd("target") == false then
            if getDebuffRemain("target",Rend) < 5 and getTimeToDie("target") > 4 then
                if castSpell("target",Rend,false,false) then
                    return;
                end
            end
        end
        -- actions.single+=/mortal_strike,if=target.health.pct>20
        if getHP("target") > 20 then
            if castSpell("target",MortalStrike,false,false) then
                return;
            end
        end
        -- actions.single+=/ravager,if=cooldown.colossus_smash.remains<3

        -- actions.single+=/colossus_smash
        if castSpell("target",ColossusSmash,false,false) then
            return;
        end
        -- actions.single+=/storm_bolt,if=(cooldown.colossus_smash.remains>4|debuff.colossus_smash.up)&rage<90
        if (getSpellCD(ColossusSmash) > 4 or UnitDebuffID("target",ColossusSmash)) and UnitPower("player") < 90 then
            if castSpell("target",StormBolt,false,false) then
                return;
            end
        end
        -- actions.single+=/siegebreaker

        -- actions.single+=/dragon_roar,if=!debuff.colossus_smash.up
        if isKnown(DragonRoar) then
            if not UnitDebuffID("target",ColossusSmash) and getDistance("player","target") < 8 then
                if castSpell("target",DragonRoar,true) then
                    return;
                end
            end
        end
        -- actions.single+=/execute,if=(rage>60&cooldown.colossus_smash.remains>execute_time)|debuff.colossus_smash.up|buff.sudden_death.react|target.time_to_die<5
        if UnitPower("player") > 60 or UnitDebuffID("target",ColossusSmash) or UnitBuffID("player",SuddenDeathSpellAura) or getTimeToDie("target") < 5 then
            if castSpell("target",ExecuteArms,false,false) then
                return;
            end
        end
        -- actions.single+=/slam,if=(rage>20|cooldown.colossus_smash.remains>execute_time)&target.health.pct>20
        if isKnown(Slam) then
            if UnitPower("player") > 20 and getHP("target") > 20 then
                if castSpell("target",Slam,false,false) then
                    return;
                end
            end
        end
        -- actions.single+=/whirlwind,if=target.health.pct>20&!talent.slam.enabled&(rage>40|set_bonus.tier17_4pc)
        if getHP("target") > 20 and not isKnown(Slam) and UnitPower("player") > 40 then
            if castSpell("target",Whirlwind,false,false) then
                return;
            end
        end
        -- actions.single+=/shockwave
    end
end

function ArmsMultiTarSimCraft()
    if useAoE() then
        if castSpell("player",Bloodbath,true) then
        return;
    end
        -- actions.aoe=sweeping_strikes
        if castSpell("player",SweepingStrikes,true) then
            return;
        end
        -- actions.aoe+=/bladestorm
        if isKnown(Bladestorm) then
            if getDistance("player","target") < 8 then
                if castSpell("target",Bladestorm,true) then
                    return;
                end
            end
        end
        -- actions.aoe+=/rend,if=active_enemies<=4&ticks_remain<2
        if isGarrMCd("target") == false then
            if getDebuffRemain("target",Rend,"player") <= 5 then
                if castSpell("target",Rend,false,false) then
                    return;
                end
            end
        end
        -- actions.aoe+=/ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
        -- actions.aoe+=/colossus_smash
        if castSpell("target",ColossusSmash,false,false) then
            return;
        end
        -- actions.aoe+=/dragon_roar,if=!debuff.colossus_smash.up
        if isKnown(DragonRoar) then
            if not UnitDebuffID("target",ColossusSmash) and getDistance("player","target") < 8 then
                if castSpell("target",DragonRoar,true) then
                    return;
                end
            end
        end
        -- actions.aoe+=/execute,if=active_enemies<=3&((rage>60&cooldown.colossus_smash.remains>execute_time)|debuff.colossus_smash.up|target.time_to_die<5)
        if getNumEnemies("player",8) <= 3 and (UnitPower("player") > 60 or UnitDebuffID("target",ColossusSmash) or getTimeToDie("target") < 5) then
            if castSpell("target",ExecuteArms,false,false) then
                return;
            end
        end
        -- actions.aoe+=/whirlwind,if=active_enemies>=4|(active_enemies<=3&(rage>60|cooldown.colossus_smash.remains>execute_time)&target.health.pct>20)
        if getNumEnemies("player",8) >= 4 or (getNumEnemies("player",8) <= 3 and UnitPower("player") > 60 and getHP("target") > 20) then
            if castSpell("target",Whirlwind,false,false) then
                return;
            end
        end
        -- actions.aoe+=/bladestorm,interrupt_if=!cooldown.colossus_smash.remains|!cooldown.ravager.remains
        if isChecked("StormRoar") and isKnown(Bladestorm) then
            if (CS_COOLDOWN <= 1 or canCast(ColossusSmash,true)) and BLADESTORM ~= nil
            or (RV_COOLDOWN <= 1 or canCast(Ravager,true)) and BLADESTORM ~= nil then
                RunMacroText("/cancelaura bladestorm")
                return false;
                else
                  if castSpell("target",Bladestorm,true) then
                    return;
                  end
            end
        end
        -- actions.aoe+=/rend,cycle_targets=1,if=!ticking
        -- actions.aoe+=/siegebreaker,if=active_enemies=2
        -- actions.aoe+=/storm_bolt,if=cooldown.colossus_smash.remains>4|debuff.colossus_smash.up
        if getSpellCD(ColossusSmash) > 4 or UnitDebuffID("target",ColossusSmash) then
            if castSpell("target",StormBolt,false,false) then
                return;
            end
        end
        -- actions.aoe+=/shockwave
    end
end



--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]	  --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]	  --[[]]
--[[]] 				--[[]]	   --[[]]	--[[]]	   --[[]]	   --[[    ]]
--[[           ]]	--[[]]	   --[[]]	--[[         ]]		   --[[    ]]
--[[           ]]	--[[]]	   --[[]]	--[[        ]]			 --[[]]
--[[]] 				--[[           ]]	--[[]]	  --[[]]		 --[[]]
--[[]]      		--[[           ]]	--[[]]		--[[]]		 --[[]]

--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]
--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]
--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]		 --[[ ]]
--[[         ]]		--[[         ]]	    --[[]]	   --[[]]		 --[[ ]]
--[[       ]]		--[[        ]]		--[[]]	   --[[]]		 --[[ ]]
--[[]]				--[[]]	  --[[]]	--[[           ]]	 	 --[[ ]]
--[[]] 				--[[]]	   --[[]]	--[[           ]]		 --[[ ]]


function ProtSingeTar()
    -- Dragon Roar
    if isKnown(DragonRoar) and getDistance("player","target") <=8 then
        if castSpell("target",DragonRoar,true) then
            return;
        end
    end
    -- ShieldSlam
    if castSpell("target",ShieldSlam,false,false) then
        return;
    end
    -- Revenge
    if castSpell("target",Revenge,false,false) then
        return;
    end
    -- Execute
    if UnitBuffID("player",SuddenDeathSpellAura) then
        if castSpell("target",ExecuteArms,false,false) then
            return;
        end
    elseif UnitPower("player") > 90 then
        if castSpell("target",ExecuteArms,false,false) then
            return;
        end
    end
    -- StormBolt
    if isKnown(StormBolt) then
        if castSpell("target",StormBolt,false,false) then
            return;
        end
    end
    -- Heroic Strike
    if isKnown(UnyieldingStrikesTalent) then
        if getBuffStacks("player",UnyieldingStrikesAura) == 6 then
            if castSpell("target",HeroicStrike,false,false) then
                return;
            end
        end
    end
    -- Devastate
    if castSpell("target",Devastate,false,false) then
        return;
    end
    -- Rage Dump
    if UnitPower("player") >= 100 then
        if castSpell("target",HeroicStrike,false,false) then
           return;
        end
    end
end

--[[           ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[  ]]   --[[]]
--[[]]				--[[]]	   --[[]]	--[[    ]] --[[]]   --[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[    ]] --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[           ]]
--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[   		   ]]
--[[]]	   			--[[           ]]	--[[]]	 --[[  ]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	 --[[  ]]
--[[]]	   			--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]

end
