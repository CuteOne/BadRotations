if select(3,UnitClass("player")) == 1 then

	function ProtectionWarrior()

		if currentConfig ~= "Protection Chumii" then
			WarriorProtConfig();
			WarriorProtToggles();
			currentConfig = "Protection Chumii";
		end

		GroupInfo();
	------------------------------------------------------------------------------------------------------
	-- Locals --------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		local rage = UnitPower("player");
		local myHP = getHP("player");
		--local ennemyUnits = getNumEnemies("player", 5)
		local GT = GetTime()
		local RV_START, RV_DURATION = GetSpellCooldown(Ravager)
		local RV_COOLDOWN = (RV_START - GT + RV_DURATION)
		local BLADESTORM = UnitBuffID("player",Bladestorm)
		local BB_START, BB_DURATION = GetSpellCooldown(Bloodbath)
		local BB_COOLDOWN = (BB_START - GT + BB_DURATION)
	------------------------------------------------------------------------------------------------------
	-- Food/Invis Check ----------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if canRun() ~= true or UnitInVehicle("Player") then
			return false;
		end
		if IsMounted("player") then
			return false;
		end
	------------------------------------------------------------------------------------------------------
	-- Pause ---------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
			ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
		end
	------------------------------------------------------------------------------------------------------
	-- Spell Queue ---------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if _Queues == nil then
		 _Queues = {
				[Shockwave]  = false,
				[Bladestorm] = false,
				[DragonRoar] = false,
		 }
		end
	------------------------------------------------------------------------------------------------------
	-- Input / Keys --------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
    if isChecked("HeroicLeapKey") and SpecificToggle("HeroicLeapKey") == true then
      if not IsMouselooking() then
          CastSpellByName(GetSpellInfo(6544))
          if SpellIsTargeting() then
              CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
              return true;
          end
      end
  	end
  	if isChecked("MockingBannerKey") and SpecificToggle("MockingBannerKey") == true then
      if not IsMouselooking() then
          CastSpellByName(GetSpellInfo(114192))
          if SpellIsTargeting() then
              CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
              return true;
          end
      end
  	end
	------------------------------------------------------------------------------------------------------
	-- Out of Combat -------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if not isInCombat("player") then
			if BadBoy_data['Gladiator'] == 2 then
				if GetShapeshiftForm() ~= 2 then
					if castSpell("player",DefensiveStance,true) then
						return;
					end
				end
			end
			if BadBoy_data['Gladiator'] == 1 then
				if GetShapeshiftForm() ~= 1 then
					if castSpell("player",GladiatorStance,true) then
						return;
					end
				end
			end

			-- Commanding Shout
				if isChecked("Shout") == true and getValue("Shout") == 1 and not UnitExists("mouseover") then
            for i = 1, #members do --members
                if not isBuffed(members[i].Unit,{21562,109773,469,90364}) and (#nNova==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
                    if castSpell("player",CommandingShout,false,false) then return; end
                end
            end
        end
        -- Battle Shout
				if isChecked("Shout") == true and getValue("Shout") == 2 and not UnitExists("mouseover") then
            for i = 1, #members do --members
                if not isBuffed(members[i].Unit,{57330,19506,6673}) and (#nNova==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
                    if castSpell("player",BattleShout,false,false) then return; end
                end
            end
        end
		end -- Out of Combat end
	------------------------------------------------------------------------------------------------------
	-- In Combat -----------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		-- if pause() ~= true and isInCombat("player") and canAttack("target","player") and not UnitIsDeadOrGhost("target") then
			if isInCombat("player") then
	------------------------------------------------------------------------------------------------------
	-- Dummy Test ----------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
			if isChecked("DPS Testing") then
				if UnitExists("target") then
					if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
						StopAttack()
						ClearTarget()
						print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
					end
				end
			end
	------------------------------------------------------------------------------------------------------
	-- Queued Spells -------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
			if _Queues[Shockwave] == true then
				if castSpell("target",Shockwave,false,false) then
					return;
				end
			end
			if _Queues[Bladestorm] == true then
				if castSpell("target",Bladestorm,false,false) then
					return;
				end
			end
			if _Queues[DragonRoar] == true then
				if castSpell("target",DragonRoar,false,false) then
					return;
				end
			end
	------------------------------------------------------------------------------------------------------
	-- Do everytime --------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------

			-- actions+=/auto_attack

			-- Shield Block / Barrier
			if UnitBuffID("player",DefensiveStance) then
				if getValue("BlockBarrier") == 1 and not UnitBuffID("player",ShieldBlockBuff) then
					if castSpell("player",ShieldBlock,true) then
						return;
					end
				elseif getValue("BlockBarrier") == 2 and not UnitBuffID("player",ShieldBarrierBuff) and rage >= 50 then
					if castSpell("player",ShieldBarrier,true) then
						return
					end
				end
			end
			-- ImpendingVictory / Victory Rush
			if isChecked("ImpendingVictory") then
				if isKnown(ImpendingVictory) and getHP("player") <= getValue("ImpendingVictory") then
					if castSpell("target",ImpendingVictory,false,false) then
						return;
					end
				elseif not isKnown(ImpendingVictory) and getHP("player") <= getValue("ImpendingVictory") then
					if castSpell("target",VictoryRush,false,false) then
						return;
					end
				end
			end
			--Bloodbath
			if castSpell("player",Bloodbath,true) then
				return;
			end
			-- Demo Shout
			if not UnitDebuffID("target",DemoralizingShout) then
				if castSpell("player",DemoralizingShout,true) then
					return;
				end
			end
	------------------------------------------------------------------------------------------------------
	-- Defensive Cooldowns -------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
			if useDefCDs() == true then
					-- LastStand
					if isChecked("LastStand") == true then
						if getHP("player") <= getValue("LastStand") then
							if castSpell("player",LastStand,true) then
								return;
							end
						end
					end
					-- Rallying Cry
					if isChecked("ShieldWall") == true then
						if getHP("player") <= getValue("ShieldWall") then
							if castSpell("player",ShieldWall,true) then
								return;
							end
						end
					end
					-- Enraged Regeneration
					if isChecked("EnragedRegeneration") == true then
						if isKnown(EnragedRegeneration) and getHP("player") <= getValue("EnragedRegeneration") then
							if castSpell("player",EnragedRegeneration,true) then
								return;
							end
						end
					end
					-- Healthstone
					if isChecked("Healthstone") == true then
						if getHP("player") <= getValue("Healthstone") then
							if canUse(5512) then
								UseItemByName(tostring(select(1,GetItemInfo(5512))))
							end
						end
					end
					-- Vigilance Focus
					if isChecked("VigilanceFocus") == true then
						if getHP("focus") <= getValue("VigilanceFocus") then
							if castSpell("focus",Vigilance,false,false) then
								return;
							end
						end
					end
			end -- isChecked("Defensive Mode") end
	------------------------------------------------------------------------------------------------------
	-- Offensive Cooldowns -------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
			if useCDs() == true then
				-- and getDistance("player","target") <= 5
				--and targetDistance <= 5 then
				-- actions+=/potion,name=draenic_strength,if=(target.health.pct<20&buff.recklessness.up)|target.time_to_die<=25
				if isChecked("usePot") then
					if (getHP("target") < 20 and UnitBuffID("player",Recklessness)) or getTimeToDie <= 25 then
						if canUse(76095) then -- MoP Potion
							UseItemByName(tostring(select(1,GetItemInfo(76095))))
						elseif canUse(109219) then -- WoD Potion
							UseItemByName(tostring(select(1,GetItemInfo(109219))))
						end
					end
				end
				-- actions+=/avatar,if=buff.recklessness.up|target.time_to_die<=25
				if isChecked("useAvatar") then
					if isKnown(Avatar) then
						--or getTimeToDie <= 25 then
						if castSpell("player",Avatar,true) then
							return;
						end
					end
				end
				-- actions+=/blood_fury,if=buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up)|buff.recklessness.up
				-- actions+=/berserking,if=buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up)|buff.recklessness.up
				if isChecked("useRacial") then
					if (isKnown(Bloodbath) and UnitBuffID("player",Bloodbath))
					or not isKnown(Bloodbath) then
						if select(2, UnitRace("player")) == "Troll" then
	        		if castSpell("player",26297,true) then
	        			return;
	        		end
	        	elseif select(2, UnitRace("player")) == "Orc" then
	        		if castSpell("player",20572,true) then
	        			return;
	        		end
	        	end
		      end
		    end
			end -- useCDs() end
	------------------------------------------------------------------------------------------------------
	-- Interrupts ----------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------------
	-- Protection -------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
			if BadBoy_data['Gladiator'] == 2 then
				if GetShapeshiftForm() ~= 2 then
				if castSpell("player",DefensiveStance,true) then
					return;
				end
			end
				if not useAoE() then
					-- Heroic Strike
			    if isKnown(UnyieldingStrikesTalent) then
			        if getBuffStacks("player",UnyieldingStrikesAura) == 6 then
			            if castSpell("target",HeroicStrike,false,false) then
			                return;
			            end
			        end
			    end
			    if UnitBuffID(Ultimatum) then
			        if castSpell("target",HeroicStrike,false,false) then
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
			    --Ravager
			    if isKnown(Ravager) then
			        if castGround("target",Ravager,40) then
			            return
			        end
			    end
			    -- StormBolt
			    if isKnown(StormBolt) then
			        if castSpell("target",StormBolt,false,false) then
			            return;
			        end
			    end
			    -- Dragon Roar
			    if isChecked("StormRoar") then
			        if isKnown(DragonRoar) and getDistance("player","target") <=8 then
			            if castSpell("target",DragonRoar,true) then
			                return;
			            end
			        end
			    end
			    --Impending Victory
			    if isKnown(ImpendingVictory) then
			        if castSpell("target",ImpendingVictory,false,false) then
			            return
			        end
			    end
			    if not isKnown(ImpendingVictory) then
			        if castSpell("target",VictoryRush,false,false) then
			            return
			        end
			    end
			    -- Execute
			    if UnitBuffID("player",SuddenDeathProc) then
			        if castSpell("target",Execute,false,false) then
			            return;
			        end
			    elseif UnitPower("player") > 90 then
			        if castSpell("target",Execute,false,false) then
			            return;
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
				end --single end
	-- AoE -----------------------------------------------------------------------------------------------
		if useAoE() then
							-- ThunderClap
				  --if not UnitDebuffID("target",DeepWounds) and getDistance("target") <= 8 then
				  if getDistance("target") <= 8 then
				      if castSpell("target",ThunderClap,true) then
				          return;
				      end
				  end
				  --Heroic Strike
				  if UnitBuffID(Ultimatum) or UnitPower("player") < 90 then
				      if castSpell("target",HeroicStrike,false,false) then
				          return
				      end
				  end
				  if isKnown(UnyieldingStrikesTalent) then
				      if getBuffStacks("player",UnyieldingStrikesAura) == 6 then
				          if castSpell("target",HeroicStrike,false,false) then
				              return;
				          end
				      end
				  end
				  --Shield Slam
				  if UnitBuffID(ShieldBlock) then
				      if castSpell("target",ShieldSlam,false,false) then
				          return
				      end
				  end
				  --Ravager
				  if isKnown(Ravager) then
				      if castGround("target",Ravager,40) then
				          return
				      end
				  end
				  -- DragonRoar
				  if isKnown(DragonRoar) and getDistance("target") <= 8 then
				      if not isKnown(Bloodbath) or (isKnown(Bloodbath) and (UnitBuffID("player",Bloodbath) or BB_COOLDOWN > 10)) then
				          if castSpell("target",DragonRoar,true) then
				              return;
				          end
				      end
				  end
				  -- BladeStorm
				  if isKnown(Bladestorm) then
				      if castSpell("target",Bladestorm,true) and getDistance("target") <= 8 then
				          return;
				      end
				  end
				  if castSpell("target",Revenger,false,false) then
				      return
				  end
				  if castSpell("target",ThunderClap,true,false) then
				      return
				  end
				  if castSpell("target",ShieldSlam,false,false) then
				      return
				  end
				  if isKnown(StormBolt) then
				      if castSpell("target",StormBolt,false,false) then
				          return
				      end
				  end
				  if UnitBuffID("player",SuddenDeathProc) then
				      if castSpell("target",Execute,false,false) then
				          return
				      end
				  end
				  if castSpell("target",Devastate,false,false) then
				      return
				  end
				end --aoe end
			end--Protection end
	------------------------------------------------------------------------------------------------------
	-- Gladiator --------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------------
		end -- In Combat end
	end -- ArmsWarrior() end
end -- Class Check end