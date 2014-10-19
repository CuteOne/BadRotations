if select(3,UnitClass("player")) == 1 then

	function ArmsWarrior()

		if Currentconfig ~= "Arms Warrior" then
			WarriorArmsConfig();
			WarriorArmsToggles()
			Currentconfig = "Arms Warrior";
		end

		--General Locals
		local RAGE = UnitPower("player");
		local TARGETHP = (100*(UnitHealth("target")/UnitHealthMax("target")));
		local PLAYERHP = (100*(UnitHealth("player")/UnitHealthMax("player"))); 
		local GT = GetTime()
		local INRANGE = getDistance("player","target") <= 5
		local INRANGE8 = getDistance("player","target") < 8
		
		--Buff/Debuff Locals
		local CS_DEBUFF,_,_,_,_,_,CS_TIMER = UnitDebuffID("target",ColossusSmash,"PLAYER")
		local REND_DEBUFF,_,_,_,_,_,REND_TIMER = UnitDebuffID("target",Rend,"PLAYER")
		
		local SD_BUFF = UnitBuffID("player",SuddenDeathProc)
		local BATTLESHOUT = UnitBuffID("player",BattleShout)
		local COMMANDINGSHOUT = UnitBuffID("player",CommandingShout)
		
		--Aoe
		if AOETimer == nil then AOETimer = 0; end
		if ENEMYS == nil or (AOETimer and AOETimer <= GetTime() - 1) then AOETimer = GetTime() ENEMYS = getNumEnemies("player", 5) end
		
		if isChecked("AutoAoE") ~= true then
			if isChecked("Rotation Up") == true then
				if SpecificToggle("Rotation Up") == true and GetCurrentKeyBoardFocus() == nil then
					if GetTime() - AOETimer > 0.25 then AOETimer = GetTime() ToggleValue("AoE"); end
				end
			end
			if isChecked("Rotation Down") == true then
				if SpecificToggle("Rotation Down") == true and GetCurrentKeyBoardFocus() == nil then
					if GetTime() - AOETimer > 0.25 then AOETimer = GetTime() ToggleMinus("AoE"); end
				end
			end
		end

		if canRun() ~= true or UnitInVehicle("Player") or IsMounted("player") then return false; end
		
		if IsPlayerSpell(Bladestorm) then
			if IsLeftAltKeyDown() and GetCurrentKeyBoardFocus() == nil then
				if INRANGE8 then
					if castSpell("player",Bladestorm,true) then return; end
				end
			end
		end
	
		--Combat
		if not isInCombat("player") then
			
		elseif isInCombat("player") then 
		
			--Use Bloodbath.
			if IsPlayerSpell(Bloodbath) then
				if INRANGE then
					CastSpellByName(GetSpellInfo(Bloodbath),"player");
				end
			end
		
			if BadBoy_data['AoE'] == 1 or (isChecked("AutoAoE") == true and ENEMYS <= 1) then
				if TARGETHP >= 20 then
					if CS_DEBUFF == nil then
						--Use Execute with Sudden Death.
						if SD_BUFF ~= nil then
							if INRANGE then
								if castSpell("target",ExecuteArms,false) then return; end
							end
						end
						--Maintain Rend on the target. You can refresh Rend when it has less than 5 seconds remaining.
						if REND_DEBUFF == nil or (REND_TIMER - GT < 5) then
							if INRANGE then
								if castSpell("target",Rend,false) then return; end
							end
						end
						--Use Mortal Strike.
						if INRANGE then
							if castSpell("target",MortalStrike,false) then return; end
						end
						--Use Colossus Smash.
						if INRANGE then
							if castSpell("target",ColossusSmash,false) then return; end
						end
						--Use Storm Bolt or Dragon Roar (depending on your choice).
						if IsPlayerSpell(StormBolt) then
							if castSpell("target",StormBolt,false) then return; end
						elseif IsPlayerSpell(DragonRoar) then
							if INRANGE8 then
								if castSpell("target",DragonRoar,true) then return; end
							end
						elseif IsPlayerSpell(Shockwave) then
							if INRANGE8 then
								if castSpell("target",Shockwave,true) then return; end
							end
						end
						--Use Whirlwind when you have more than 40 Rage.
						if RAGE > 40  then
							if not IsPlayerSpell(Slam) then
								if INRANGE8 then
									if castSpell("player",Whirlwind,true) then return; end
								end
						--Use Slam.
							elseif IsPlayerSpell(Slam) then
								if INRANGE then
									if castSpell("target",Slam,false) then return; end
								end
							end
						end
					elseif CS_DEBUFF ~= nil then
						--Use Execute with Sudden Death.
						if SD_BUFF ~= nil then
							if INRANGE then
								if castSpell("target",ExecuteArms,false) then return; end
							end
						end
						--Use Mortal Strike.
						if INRANGE then
							if castSpell("target",MortalStrike,false) then return; end
						end
						--Use Storm Bolt when you have more than 70 Rage.
						if IsPlayerSpell(StormBolt) then
							if RAGE > 70 then
								if castSpell("target",StormBolt,false) then return; end
							end
						end
						--Use Whirlwind.
						if not IsPlayerSpell(Slam) then
							if INRANGE8 then
								if castSpell("player",Whirlwind,true) then return; end
							end
						--Use Slam.
						elseif IsPlayerSpell(Slam) then
							if INRANGE then
								if castSpell("target",Slam,false) then return; end
							end
						end
					end
				elseif TARGETHP < 20 then
					if CS_DEBUFF == nil then
						--Use Execute with Sudden Death.
						if SD_BUFF ~= nil then
							if INRANGE then
								if castSpell("target",ExecuteArms,false) then return; end
							end
						end
						--Maintain Rend on the target. You can refresh Rend when it has less than 5 seconds remaining.
						if REND_DEBUFF == nil or (REND_TIMER - GT < 5) then
							if INRANGE then
								if castSpell("target",Rend,false) then return; end
							end
						end
						--Use Execute when you have 60 or more Rage.
						if RAGE >= 60 then
							if INRANGE then
								if castSpell("target",ExecuteArms,false) then return; end
							end
						end
						--Use Colossus Smash.
						if INRANGE then
							if castSpell("target",ColossusSmash,false) then return; end
						end
						--Use Storm Bolt or Dragon Roar (depending on your choice).
						if IsPlayerSpell(StormBolt) then
							if castSpell("target",StormBolt,false) then return; end
						elseif IsPlayerSpell(DragonRoar) then
							if INRANGE8 then
								if castSpell("target",DragonRoar,true) then return; end
							end
						elseif IsPlayerSpell(Shockwave) then
							if INRANGE8 then
								if castSpell("target",Shockwave,true) then return; end
							end
						end
					elseif CS_DEBUFF ~= nil then
						--Use Execute with Sudden Death.
						if SD_BUFF ~= nil then
							if INRANGE then
								if castSpell("target",ExecuteArms,false) then return; end
							end
						end
						--Use Storm Bolt if you less than 70 Rage.
						if IsPlayerSpell(StormBolt) then
							if RAGE < 70 then
								if castSpell("target",StormBolt,false) then return; end
							end
						end
						--Use Execute.
						if INRANGE then
							if castSpell("target",ExecuteArms,false) then return; end
						end
					end
				end
			elseif BadBoy_data['AoE'] == 2 or (isChecked("AutoAoE") == true and ENEMYS > 1) then
				--Use Execute with Sudden Death.
				if SD_BUFF ~= nil then
					if INRANGE then
						if castSpell("target",ExecuteArms,false) then return; end
					end
				end
				--Keep up Sweeping Strikes.
				if castSpell("player",SweepingStrikes,true) then return; end
				--Keep up Rend on multiple targets (up to a maximum of 4-5).
				if REND_DEBUFF == nil or (REND_TIMER - GT < 5) then
					if INRANGE then
						if castSpell("target",Rend,false) then return; end
					end
				end
				--Use Dragon Roar.
				if IsPlayerSpell(DragonRoar) then
					if INRANGE8 then
						if castSpell("target",DragonRoar,true) then return; end
					end
				elseif IsPlayerSpell(Shockwave) then
					if INRANGE8 then
						if castSpell("target",Shockwave,true) then return; end
					end
				end
				--Use Whirlwind.
				if INRANGE8 then
					if castSpell("player",Whirlwind,true) then return; end
				end
			end
		
		end
		
	end
end