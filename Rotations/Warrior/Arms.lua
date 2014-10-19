if select(3,UnitClass("player")) == 1 then

	function ArmsWarrior()

		if currentConfig ~= "Arms Chumii" then
			WarriorArmsConfig();
			WarriorArmsToggles();
			currentConfig = "Arms Chumii";
		end

		GroupInfo();
	------------------------------------------------------------------------------------------------------
	-- Locals --------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		local rage = UnitPower("player");
		local myHP = getHP("player");
		--local ennemyUnits = getNumEnemies("player", 5)
		local GT = GetTime()
		local CS_START, CS_DURATION = GetSpellCooldown(ColossusSmash)
		local CS_COOLDOWN = (CS_START - GT + CS_DURATION)
		local RV_START, RV_DURATION = GetSpellCooldown(Ravager)
		local RV_COOLDOWN = (RV_START - GT + RV_DURATION)
		local BLADESTORM = UnitBuffID("player",Bladestorm)
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
	------------------------------------------------------------------------------------------------------
	-- Out of Combat -------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if not isInCombat("player") then
			-- actions.precombat+=/stance,choose=battle
			if GetShapeshiftForm() ~= 1 then
				if castSpell("player",BattleStance,true) then
					return;
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

	------------------------------------------------------------------------------------------------------
	-- Defensive Cooldowns -------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
			if useDefCDs() == true then
					-- Die by the Sword
					if isChecked("DiebytheSword") == true then
						if getHP("player") <= getValue("DiebytheSword") then
							if castSpell("player",DiebytheSword,true) then
								return;
							end
						end
					end
					-- Rallying Cry
					if isChecked("RallyingCry") == true then
						if getHP("player") <= getValue("RallyingCry") then
							if castSpell("player",RallyingCry,true) then
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
					-- Def Stance
					if isChecked("DefensiveStance") == true then
						if getHP("player") <= getValue("DefensiveStance") and GetShapeshiftForm() ~= 2 then
							if castSpell("player",DefensiveStance,true) then
								return;
							end
						elseif getHP("player") > getValue("DefensiveStance") and GetShapeshiftForm() ~= 1 then
							if castSpell("player",BattleStance,true) then
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
				-- actions+=/recklessness,if=(target.time_to_die>190|target.health.pct<20)&(!talent.bloodbath.enabled&(cooldown.colossus_smash.remains<2|debuff.colossus_smash.remains>=5)|buff.bloodbath.up)|target.time_to_die<=10
				if isChecked("useRecklessness") then
					--if (getTimeToDie > 190 or getHP("target") < 20)
					if getHP("target") <20
					and (not isKnown(Bloodbath) and CS_COOLDOWN < 2 or getDebuffRemain("target",ColossusSmash,"player") >= 5)
					or UnitDebuffID("target",Bloodbath)
					or getTimeToDie("target") <= 10 then
						if castSpell("player",Recklessness,true) then
							return;
						end
					end
				end
				-- actions+=/avatar,if=buff.recklessness.up|target.time_to_die<=25
				if isChecked("useAvatar") then
					if isKnown(Avatar) and UnitBuffID("player",Recklessness) then
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
					or (not isKnown(Bloodbath) and UnitDebuffID("target",ColossusSmash,"player"))
					or UnitBuffID("player",Recklessness) then
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
	-- Main Rotaion --------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if getValue("RotationSelect") == 1 then
			ArmsSingleTarIcyVeins();
			ArmsMultiTarIcyVeins();
		end
		if getValue("RotationSelect") == 2 then
			ArmsSingleTarSimCraft();
			ArmsMultiTarSimCraft();
		end
	------------------------------------------------------------------------------------------------------
		end -- In Combat end
	end -- ArmsWarrior() end
end -- Class Check end