if select(3,UnitClass("player")) == 1 then

	function FuryWarrior()

		if Currentconfig ~= "Fury Warrior" then
			WarriorFuryConfig();
			WarriorFuryToggles()
			Currentconfig = "Fury Warrior";
		end

		--General Locals
		local RAGE = UnitPower("player");
		local TARGETHP = (100*(UnitHealth("target")/UnitHealthMax("target")));
		local PLAYERHP = (100*(UnitHealth("player")/UnitHealthMax("player")));
		local COMBATTIME = getCombatTime()

		--Buff/Debuff Locals
		local ENRAGED,_,_,_,_,_,ENRAGE_TIMER = UnitBuffID("player",Enrage)
		local RAGINGBLOWBUFF,_,_,RB_COUNT,_,_,RB_TIMER = UnitBuffID("player",RagingBlowProc)
		local MEATCLEAVER,_,_,MC_COUNT,_,_,MC_TIMER = UnitBuffID("player",MeatCleaver)

		local SD_BUFF = UnitBuffID("player",SuddenDeathProc)
		local BLOODSURGE = UnitBuffID("player",Bloodsurge)
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

		--Combat
		if not isInCombat("player") then

		elseif isInCombat("player") then

			if BadBoy_data['AoE'] == 1 or (isChecked("AutoAoE") == true and ENEMYS <= 1) then

				if TARGETHP >= 20 then

					--If you have chosen the Sudden Death Icon Sudden Death talent, then use these Execute Icon Executes as your highest priority.
					if SD_BUFF ~= nil then
						if castSpell("target",Execute,false) then return; end
					end
					--Use Berserker Rage if your Enrage falls off.
					--If you have taken the Unquenchable Thirst talent, you may also use Berserker Rage when you have no stacks of Raging Blow.
					if (ENRAGED == nil and COMBATTIME >= 5) or RAGINGBLOWBUFF == nil then
						if castSpell("player",BerserkerRage,true) then return; end
					end
					--Use Wild Strike to avoid reaching maximum Rage.
					if RAGE >= 100 then
						if castSpell("target",WildStrike,false) then return; end
					end
					--Use Raging Blow when you have 2 stacks.
					if RAGINGBLOWBUFF ~= nil then
						if RB_COUNT == 2 then
							if castSpell("target",RagingBlow,false) then return; end
						end
					end
					--Use Bloodthirst.
					--When you are not Enraged, if you have chosen the Unquenchable Thirst talent.
					--When you are not Enraged, or you have less than 80 Rage, if you have not chosen the Unquenchable Thirst talent.
					if isKnown(UnquenchableThirst) then
						if ENRAGED == nil then
							if castSpell("target",Bloodthirst,false) then return; end
						end
					elseif not isKnown(UnquenchableThirst) then
						if ENRAGED == nil or RAGE < 80 then
							if castSpell("target",Bloodthirst,false) then return; end
						end
					end
					--Use Raging Blow.
					if RAGINGBLOWBUFF ~= nil then
						if castSpell("target",RagingBlow,false) then return; end
					end
					--Use Wild Strike.
					if BLOODSURGE ~= nil or RAGE >= 45 then
						if castSpell("target",WildStrike,false) then return; end
					end
					--Use Storm Bolt or Dragon Roar (depending on your choice).
					if IsPlayerSpell(StormBolt) then
						if castSpell("target",StormBolt,false) then return; end
					elseif IsPlayerSpell(DragonRoar) then
						if castSpell("player",DragonRoar,true) then return; end
					end
					--Use Bloodthirst if you have chosen the Unquenchable Thirst talent, and you have no other action available.
					if isKnown(UnquenchableThirst) then
						if castSpell("target",Bloodthirst,false) then return; end
					end

				elseif TARGETHP < 20 then

					--If you have chosen the Sudden Death talent, then use these Execute as your highest priority.
					if SD_BUFF ~= nil then
						if castSpell("target",Execute,false) then return; end
					end
					--Use Berserker Rage if your Enrage falls off.
					--If you have taken the Unquenchable Thirst talent, you may also use Berserker Rage when you have no stacks of Raging Blow.
					if (ENRAGED == nil and COMBATTIME >= 5) or RAGINGBLOWBUFF == nil then
						if castSpell("player",BerserkerRage,true) then return; end
					end
					--Use Execute to avoid reaching maximum Rage.
					if RAGE >= 100 then
						if castSpell("target",Execute,false) then return; end
					end
					--Use Bloodthirst
					--When you are not Enraged, if you have chosen the Unquenchable Thirst Talent.
					--When you are not Enraged, or you have less than 80 Rage, if you have not chosen the Unquenchable Thirst talent.
					if isKnown(UnquenchableThirst) then
						if ENRAGED == nil then
							if castSpell("target",Bloodthirst,false) then return; end
						end
					elseif not isKnown(UnquenchableThirst) then
						if ENRAGED == nil or RAGE < 80 then
							if castSpell("target",Bloodthirst,false) then return; end
						end
					end
					--Use Execute.
					if RAGE >= 30 then
						if castSpell("target",Execute,false) then return; end
					end
					--use Raging Blow.
					if RAGINGBLOWBUFF ~= nil then
						if castSpell("target",RagingBlow,false) then return; end
					end
					--Use Wild Strike if you have a Bloodsurge proc.
					if BLOODSURGE ~= nil then
						if castSpell("target",WildStrike,false) then return; end
					end
					--Use Storm Bolt or Dragon Roar (depending on your choice).
					if IsPlayerSpell(StormBolt) then
						if castSpell("target",StormBolt,false) then return; end
					elseif IsPlayerSpell(DragonRoar) then
						if castSpell("player",DragonRoar,true) then return; end
					end
					--Use Bloodthirst if you have chosen the Unquenchable Thirst talent, and you have no other action available.
					if isKnown(UnquenchableThirst) then
						if castSpell("target",Bloodthirst,false) then return; end
					end

				end

			elseif BadBoy_data['AoE'] == 2 or (isChecked("AutoAoE") == true and ENEMYS == 2) or (isChecked("AutoAoE") == true and ENEMYS == 3) then

				--Use Bloodthirst to maintain your Enrage and generate Raging Blow stacks.
				if ENRAGED == nil then
					if castSpell("target",Bloodthirst,false) then return; end
				end
				--Use Whirlwind to gain stacks of Meat Cleaver as necessary for the amount of current targets.
				if (isChecked("AutoAoE") ~= true and BadBoy_data['AoE'] == 2) or (isChecked("AutoAoE") == true and ENEMYS == 2) then
					if MEATCLEAVER == nil then
						if castSpell("player",Whirlwind,true) then return; end
					end
				elseif (isChecked("AutoAoE") == true and ENEMYS == 3) then
					if MEATCLEAVER ~= nil then
						if MC_COUNT == 2 then
							if castSpell("player",Whirlwind,true) then return; end
						end
					end
				end
				--Use Raging Blow.
				if RAGINGBLOWBUFF ~= nil then
					if castSpell("target",RagingBlow,false) then return; end
				end
				--Use Dragon Roar.
				if IsPlayerSpell(DragonRoar) then
					if castSpell("player",DragonRoar,true) then return; end
				end
				--Use Wild Strike when you have a Bloodsurge.
				if BLOODSURGE ~= nil then
					if castSpell("target",WildStrike,false) then return; end
				end
				--Use Bloodthirst.
				--If you have taken the Unquenchable Thirst talent, use Bloodthirst to generate Rage.
				if castSpell("target",Bloodthirst,false) then return; end

			elseif BadBoy_data['AoE'] == 3 or (isChecked("AutoAoE") == true and ENEMYS >= 4) then

				--Bloodthirst in order to maintain your Enrage.
				if ENRAGED == nil then
					if castSpell("target",Bloodthirst,false) then return; end
				end
				--Use Whirlwind when you have 80+ Rage.
				if RAGE >= 80 then
					if castSpell("player",Whirlwind,true) then return; end
				end
				--Use Raging Blow.
				if RAGINGBLOWBUFF ~= nil then
					if castSpell("target",RagingBlow,false) then return; end
				end
				--Use Bloodsurge procs, only when you are low on Rage.
				if BLOODSURGE ~= nil then
					if castSpell("target",WildStrike,false) then return; end
				end
				--Use Bloodthirst.
				if castSpell("target",Bloodthirst,false) then return; end

			end

		end

	end
end