if select(3,UnitClass("player")) == 1 then

function FuryWarrior()

if Currentconfig ~= "Fury Avery/Chumii" then
	WarriorFuryConfig();
	FuryToggles()
	Currentconfig = "Fury Avery/Chumii";
end

--aoe toggle
if isChecked("AutoAoE") ~= true then

	if AOETimer == nil then AOETimer = 0; end

	if SpecificToggle("Rotation Up") == 1 and GetCurrentKeyBoardFocus() == nil then
		if GetTime() - AOETimer > 0.25 then
			AOETimer = GetTime()
			ToggleValue("AoE");
		end
	end

	if isChecked("Rotation Down") then
		if SpecificToggle("Rotation Down") == 1 and GetCurrentKeyBoardFocus() == nil then
			if GetTime() - AOETimer > 0.25 then
				AOETimer = GetTime()
				ToggleMinus("AoE");
			end
		end
	end
end

-- Locals
local RAGE = UnitPower("player");
local PLAYERHP = 100*(UnitHealth("player")/UnitHealthMax("player"))
local TARGETHP = 100*(UnitHealth("target")/UnitHealthMax("target"))
local ENEMYS = getNumEnnemies("player", 5)
local COMBATTIME = getCombatTime()

--Cooldowns
local GT = GetTime()
local BT_START, BT_DURATION = GetSpellCooldown(Bloodthirst)
local BT_COOLDOWN = (BT_START - GT + BT_DURATION)
local SB_START, SB_DURATION = GetSpellCooldown(StormBolt)
local SB_COOLDOWN = (SB_START - GT + SB_DURATION)
local CS_START, CS_DURATION = GetSpellCooldown(ColossusSmash)
local CS_COOLDOWN = (CS_START - GT + CS_DURATION)
local DS_START, DS_DURATION = GetSpellCooldown(DisruptingShout)
local DS_COOLDOWN = (DS_START - GT + DS_DURATION)

--Buffs
local ENRAGED,_,_,_,_,_,ENRAGE_TIMER = UnitBuffID("player",Enrage)
local CS_DEBUFF,_,_,_,_,_,CS_TIMER = UnitDebuffID("target",ColossusSmash,"PLAYER")
local DW_DEBUFF,_,_,_,_,_,DW_TIMER = UnitDebuffID("target",DeepWounds,"PLAYER")
local RAGINGBLOWBUFF,_,_,RB_COUNT,_,_,RB_TIMER = UnitBuffID("player",RagingBlowProc)
local MEATCLEAVER,_,_,MC_COUNT,_,_,MC_TIMER = UnitBuffID("player",MeatCleaver)
local BLOODSURGE = UnitBuffID("player",Bloodsurge)
local BATTLESHOUT = UnitBuffID("player",BattleShout)
local COMMANDINGSHOUT = UnitBuffID("player",CommandingShout)
local BLADESTORMBUFF = UnitBuffID("player",Bladestorm)

--Trinkets
local OUTRAGE = UnitBuffID("player",Outrage)
local DETERMINATION = UnitBuffID("player",Determination)

-- Food/Invis Check
if canRun() ~= true then
	return false; 
end

--vehicle check
if isChecked("Vehicle") ~= true then
	if UnitInVehicle("Player") then
		return false;
	end
end

if IsMounted("player") then 
	return false; 
end

--heroic leap
if isChecked("HeroicLeap") == true then 
	if IsMouseButtonDown(3) and not GetCurrentKeyBoardFocus() and not IsMouselooking() then
		CastSpellByName(GetSpellInfo(HeroicLeap))
		if SpellIsTargeting() then 
			CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop() 
			return true;
		end
	end
end

--manual bladestorm
if IsPlayerSpell(Bladestorm) == true then
	if isChecked("Bladestorm") == true then
		if IsLeftAltKeyDown() and not GetCurrentKeyBoardFocus() then
			if IsSpellInRange(GetSpellInfo(HeroicStrike),"target") == 1 then
				if castSpell("target",Bladestorm,true) then
					return;
				end
			end
		end
	end
end

--manual dragon roar
if IsPlayerSpell(DragonRoar) == true then
	if isChecked("Dragon Roar") == true then
		if IsLeftAltKeyDown() and not GetCurrentKeyBoardFocus() then
			if IsSpellInRange(GetSpellInfo(HeroicStrike),"target") == 1 then
				if castSpell("target",DragonRoar,true) then
					return;
				end
			end
		end
	end
end

--autotarget
if isChecked("Autotarget") == true then
	if isInCombat("player") then
		if not UnitExists("target") or (UnitExists("target") and UnitIsDeadOrGhost("target")) then
			TargetNearestEnemy()
			return true;
		end
	end
end

--out of combat check
if not isInCombat("player") then

--Shouts
if isMoving("player") == true then
	if isChecked("Battle") == true then
		if BATTLESHOUT == nil then
			if castSpell("player",BattleShout,true) then
				return;
			end  
		end
	elseif isChecked("Commanding") == true then
		if COMMANDINGSHOUT == nil then
			if castSpell("player",CommandingShout,true) then 
				return; 
			end  
		end
	end
end

--Charge if getDistance > 10
if isChecked("Charge") == true and canAttack("target","player") and not UnitIsDeadOrGhost("target") and getDistance("player","target") > 10 then
	if targetDistance <= 40 and getGround("target") == true and UnitExists("target") then
		if castSpell("target",Charge,false,false) then 
			return; 
		end
	end
end

end --if not isInCombat("player") then

if pause() ~= true and isInCombat("player") and canAttack("target","player") and not UnitIsDeadOrGhost("target") then		

-----------------
--- In Combat ---
-----------------

-----------------
--- interrupts ---
-----------------

--Quaking Palm
if IsPlayerSpell(QuakingPalm) == true then
	if isChecked("Quaking Palm") and canInterrupt(QuakingPalm,tonumber(getValue("Quaking Palm"))) then
		if castSpell("target",QuakingPalm,false) then
			return;
		end
	end
end

--Pummel
if isChecked("Pummel") == true and canInterrupt(Pummel,tonumber(getValue("Pummel"))) then
	if isChecked("Disrupting Shout") == true then
		if (DS_COOLDOWN <= 38  and DS_COOLDOWN > 0) then
			if castSpell("target",Pummel,false) then
				return; 
			end
		end
	elseif isChecked("Disrupting Shout") ~= true then
		if castSpell("target",Pummel,false) then
			return; 
		end
	end
end

--Disrupting Shout
if IsPlayerSpell(DisruptingShout) == true then
	if isChecked("Disrupting Shout") == true and canInterrupt(DisruptingShout,tonumber(getValue("Disrupting Shout"))) then
		if castSpell("target",DisruptingShout,false) then
			return; 
		end
	end
end

-----------------
--- defensives ---
-----------------

-- Die by the Sword
if isChecked("DiebytheSword") == true then
	if PLAYERHP <= getValue("DiebytheSword") then
		if castSpell("player",DiebytheSword,true) then
			return;
		end
	end
end

-- ShieldWall
if isChecked("ShieldWall") == true then
	if PLAYERHP <= getValue("ShieldWall") then
		if castSpell("player",ShieldWall,true) then
			return;
		end
	end
end

-- Def Stance
if isChecked("DefensiveStance") == true then
	if PLAYERHP <= getValue("DefensiveStance") and GetShapeshiftForm() ~= 2 then
		if castSpell("player",DefensiveStance,true) then
			return;
		end
	elseif PLAYERHP > getValue("DefensiveStance") and GetShapeshiftForm() ~= 1 then
		if castSpell("player",BattleStance,true) then
			return;
		end
	end  
end

--Healthstone
if isChecked("Healthstone") then
	if PLAYERHP <= getValue("Healthstone") then
		if canUse(5512) then
			UseItemByName(tostring(select(1,GetItemInfo(5512))))
		end
	end
end

if isCasting() then 
	return false; 
end

--------------------
--- Out of Range ---
--------------------

if targetDistance > 5 and targetDistance <= 40 then

--Charge
if isChecked("Charge") == true and canAttack("target","player") and not UnitIsDeadOrGhost("target") and getDistance("player","target") > 10 then
	if targetDistance <= 40 and getGround("target") == true and UnitExists("target") then
		if castSpell("target",Charge,false,false) then 
			return;
		end
	end
end

----------------
--- In Range ---
----------------

elseif UnitExists("target") and not UnitIsDeadOrGhost("target") and isEnnemy("target") == true and getCreatureType("target") == true then

--autoface
--if isChecked("Autoface") == true then 
--	RunMacroText("/script Target:Face()")
--end

----------------
--- Single ---
----------------
if (isChecked("AutoAoE") == nil and BadBoy_data['AoE'] == 1) or (isChecked("AutoAoE") == true and ENEMYS == 1) then

--berserker_rage,if=buff.enrage.remains<1&cooldown.bloodthirst.remains>1
if ENRAGED ~= nil then
	if (ENRAGE_TIMER - GT < 1) and BT_COOLDOWN > 1 then
		if castSpell("player",BerserkerRage,true) then
			return;
		end  
	end
end

--heroic_strike,if=(debuff.colossus_smash.up&rage>=40|rage>=100)&buff.enrage.up
if RAGE >= 30 then
	if ((CS_DEBUFF ~= nil and RAGE >= 40) or (RAGE >= 100)) and ENRAGED ~= nil then
		if castSpell("target",HeroicStrike,true,false) then
			return;
		end
	end
end

--bloodthirst,if=!buff.enrage.up
if ENRAGED == nil then
	if castSpell("target",Bloodthirst,true,false) then
		return;
	end
end

--storm_bolt,if=enabled&buff.cooldown_reduction.up&debuff.colossus_smash.up
if IsPlayerSpell(StormBolt) == true then
	if CS_DEBUFF ~= nil then
		if castSpell("target",StormBolt,true,false) then
			return;
		end
	end
end

--raging_blow,if=buff.raging_blow.stack=2&debuff.colossus_smash.up
if RAGE >= 10 then
	if RB_COUNT == 2 and CS_DEBUFF ~= nil then
		if castSpell("target",RagingBlow,true,false) then
			return;
		end
	end
end

--dragon_roar,if=enabled&(!debuff.colossus_smash.up&(buff.bloodbath.up|!talent.bloodbath.enabled))
if IsPlayerSpell(DragonRoar) == true then
	if isChecked("Dragon Roar") ~= true then
		if (CS_DEBUFF == nil or (OUTRAGE ~= nil or DETERMINATION ~= nil)) and COMBATTIME > 5 then
			if IsSpellInRange(GetSpellInfo(HeroicStrike),"target") == 1 then
				if castSpell("target",DragonRoar,true) then
					return;
				end
			end
		end
	end
end

--bloodthirst
if castSpell("target",Bloodthirst,true,false) then
	return;
end

--wild_strike,if=buff.bloodsurge.react&cooldown.bloodthirst.remains<=1&cooldown.bloodthirst.remains>0.3
if (BLOODSURGE ~= nil and (BT_COOLDOWN <= 1 and BT_COOLDOWN > 0)) then
	if castSpell("target",WildStrike,true,false) then
		return;
	end
end

--wait,sec=cooldown.bloodthirst.remains,if=!(debuff.colossus_smash.up&rage>=30&buff.enrage.up)&cooldown.bloodthirst.remains<=1
if (TARGETHP >= 20 and CS_DEBUFF == nil and RAGE < 30 and ENRAGED == nil) then
	if (BT_COOLDOWN <= 1 and BT_COOLDOWN > 0) then
		return;
	end
end

--colossus_smash
if SB_COOLDOWN <= 4 or canCast(StormBolt,true) then
	if castSpell("target",ColossusSmash,true,false) then
		return;
	end
end

--execute,if=buff.raging_blow.stack<2&( ((rage>70&!debuff.colossus_smash.up)|debuff.colossus_smash.up )|trinket.proc.strength.up )|target.time_to_die<5
if (RAGINGBLOWBUFF == nil or RB_COUNT == 1) 
and (((RAGE > 70 and CS_DEBUFF == nil) or CS_DEBUFF ~= nil) or (DETERMINATION ~= nil or OUTRAGE ~= nil)) or getTimeToDie("target") < 5 then
	if castSpell("target",Execute,true,false) then
		return;
	end
end

--berserker_rage,if=buff.raging_blow.stack<=1&target.health.pct>=20
if (RAGINGBLOWBUFF == nil or RB_COUNT == 1) and TARGETHP >= 20 then
	if castSpell("player",BerserkerRage,true) then
		return;
	end  
end

--raging_blow,if=buff.raging_blow.stack=2|debuff.colossus_smash.up|buff.raging_blow.remains<=3
if RAGINGBLOWBUFF ~= nil then
	if RB_COUNT == 2 or CS_DEBUFF ~= nil or (RB_TIMER - GT <= 3) then
		if castSpell("target",RagingBlow,true,false) then
			return;
		end
	end
end

--bladestorm,if=enabled,interrupt_if=cooldown.bloodthirst.remains<1
if IsPlayerSpell(Bladestorm) == true then
	if isChecked("Bladestorm") ~= true then
		if (BT_COOLDOWN < 1 and BT_COOLDOWN > 0) and BLADESTORMBUFF ~= nil then
			RunMacroText("/cancelaura bladestorm")
			return false;
		else
			if IsSpellInRange(GetSpellInfo(HeroicStrike),"target") == 1 then
				if castSpell("target",Bladestorm,true) then
					return;
				end
			end
		end
	end
end

--raging_blow,if=cooldown.colossus_smash.remains>=1
if CS_COOLDOWN >= 1 then
	if castSpell("target",RagingBlow,true,false) then
		return;
	end	
end

--wild_strike,if=buff.bloodsurge.up
if BLOODSURGE ~= nil then
	if castSpell("target",WildStrike,true,false) then
		return;
	end
end

--shattering_throw,if=cooldown.colossus_smash.remains>5
if isChecked("Shattering Throw") == true then
	if CS_COOLDOWN > 5 then
		if castSpell("target",ShatteringThrow,true,true) then
			return;
		end
	end
end

--shockwave,if=enabled
if castSpell("target",Shockwave,true,false) then
	return;
end

--heroic_throw,if=debuff.colossus_smash.down&rage<60
if CS_DEBUFF == nil and RAGE < 60 then
	if castSpell("target",HeroicThrow,true,false) then
		return;
	end
end

--wild_strike,if=debuff.colossus_smash.up
if CS_DEBUFF ~= nil then
	if castSpell("target",WildStrike,true,false) then
		return;
	end
end

--shout,if=rage<70
if RAGE < 70 then 
	if isChecked("Battle") == true then
		if castSpell("player",BattleShout,true) then
			return;
		end  
	elseif isChecked("Commanding") == true then
		if castSpell("player",CommandingShout,true) then 
			return; 
		end 
	elseif BATTLESHOUT == nil then
		if castSpell("player",BattleShout,true) then
			return;
		end  
	end
end 

--impending_victory,if=enabled&cooldown.colossus_smash.remains>=1.5
if CS_COOLDOWN >= 1.5 then
	if castSpell("target",ImpendingVictory,true,false) then
		return;
	end
end

--wild_strike,if=cooldown.colossus_smash.remains>=2&rage>=70
if CS_COOLDOWN >= 2 and RAGE >= 70 then
	if castSpell("target",WildStrike,true,false) then
		return;
	end
end	

end	
----------------
--- Single ---
----------------

----------------
--- Two ---
----------------
if (isChecked("AutoAoE") == nil and BadBoy_data['AoE'] == 2) or (isChecked("AutoAoE") == true and ENEMYS == 2) then
--buff.enrage.remains<1&cooldown.bloodthirst.remains>1)
if ENRAGED ~= nil then
	if (ENRAGE_TIMER - GT < 1) and BT_COOLDOWN > 1 then
		if castSpell("player",BerserkerRage,true) then
			return;
		end  
	end
end

--cleave,if=(rage>=60&debuff.colossus_smash.up)|rage>110
if RAGE >= 30 then
	if ((CS_DEBUFF ~= nil and RAGE >= 60) or (RAGE >= 110)) then
		if castSpell("target",Cleave,true,false) then
			return;
		end
	end
end

--bladestorm,if=enabled&(buff.bloodbath.up|!talent.bloodbath.enabled)&(!talent.storm_bolt.enabled|(talent.storm_bolt.enabled&!debuff.colossus_smash.up))
if IsPlayerSpell(Bladestorm) == true then
	if isChecked("Bladestorm") ~= true then
		if CS_DEBUFF == nil then
			if IsSpellInRange(GetSpellInfo(HeroicStrike),"target") == 1 then
				if castSpell("target",Bladestorm,true) then
					return;
				end
			end
		end
	end
end

--dragon_roar,if=enabled&(!debuff.colossus_smash.up&(buff.bloodbath.up|!talent.bloodbath.enabled))
if IsPlayerSpell(DragonRoar) == true then
	if isChecked("Dragon Roar") ~= true then
		if (CS_DEBUFF == nil or (OUTRAGE ~= nil or DETERMINATION ~= nil)) and COMBATTIME > 5 then
			if IsSpellInRange(GetSpellInfo(HeroicStrike),"target") == 1 then
				if castSpell("target",DragonRoar,true) then
					return;
				end
			end
		end
	end
end

--colossus_smash
if SB_COOLDOWN <= 4 or canCast(StormBolt,true) then
	if castSpell("target",ColossusSmash,true,false) then
		return;
	end
end

--bloodthirst,cycle_targets=1,if=dot.deep_wounds.remains<5
if DW_DEBUFF == nil or (DW_DEBUFF ~= nil and (DW_TIMER - GT < 5)) then
	if castSpell("target",Bloodthirst,true,false) then
		return;
	end
end

--storm_bolt,if=enabled&debuff.colossus_smash.up
if IsPlayerSpell(StormBolt) == true then
	if CS_DEBUFF ~= nil then
		if castSpell("target",StormBolt,true,false) then
			return;
		end
	end
end

--bloodthirst
if castSpell("target",Bloodthirst,true,false) then
	return;
end

--wait,sec=cooldown.bloodthirst.remains,if=!(target.health.pct<20&debuff.colossus_smash.up&rage>=30&buff.enrage.up)&cooldown.bloodthirst.remains<=1
if (TARGETHP >= 20 and CS_DEBUFF == nil and RAGE < 30 and ENRAGED == nil) then
	if (BT_COOLDOWN <= 1 and BT_COOLDOWN > 0) then
		return;
	end
end

--raging_blow,if=buff.meat_cleaver.up
if MEATCLEAVER ~= nil then
	if castSpell("target",RagingBlow,true,false) then
		return;
	end
end

--whirlwind,if=!buff.meat_cleaver.up
if MEATCLEAVER == nil then
	if castSpell("target",Whirlwind,true,false) then
		return;
	end
end

--shockwave,if=enabled
if castSpell("target",Shockwave,true,false) then
	return;
end

--execute
if castSpell("target",Execute,true,false) then
	return;
end

--shout
if isChecked("Battle") == true then
	if castSpell("player",BattleShout,true) then
		return;
	end  
elseif isChecked("Commanding") == true then
	if castSpell("player",CommandingShout,true) then 
		return; 
	end 
elseif BATTLESHOUT == nil then
	if castSpell("player",BattleShout,true) then
		return;
	end  
end

--heroic_throw
if castSpell("target",HeroicThrow,true,false) then
	return;
end

end
----------------
--- Two ---
----------------

----------------
--- Three ---
----------------
if (isChecked("AutoAoE") == nil and BadBoy_data['AoE'] == 3) or (isChecked("AutoAoE") == true and ENEMYS == 3) then

--buff.enrage.remains<1&cooldown.bloodthirst.remains>1)
if ENRAGED ~= nil then
	if (ENRAGE_TIMER - GT < 1) and BT_COOLDOWN > 1 then
		if castSpell("player",BerserkerRage,true) then
			return;
		end  
	end
end

--cleave,if=(rage>=70&debuff.colossus_smash.up)|rage>90
if RAGE >= 30 then
	if ((CS_DEBUFF ~= nil and RAGE >= 70) or (RAGE >= 90)) then
		if castSpell("target",Cleave,true,false) then
			return;
		end
	end
end

--bladestorm,if=enabled&(buff.bloodbath.up|!talent.bloodbath.enabled)
if IsPlayerSpell(Bladestorm) == true then
	if isChecked("Bladestorm") ~= true then
		if IsSpellInRange(GetSpellInfo(HeroicStrike),"target") == 1 then
			if castSpell("target",Bladestorm,true) then
				return;
			end
		end
	end
end

--dragon_roar,if=enabled&(!debuff.colossus_smash.up&(buff.bloodbath.up|!talent.bloodbath.enabled))
if IsPlayerSpell(DragonRoar) == true then
	if isChecked("Dragon Roar") ~= true then
		if (CS_DEBUFF == nil or (OUTRAGE ~= nil or DETERMINATION ~= nil)) and COMBATTIME > 5 then
			if IsSpellInRange(GetSpellInfo(HeroicStrike),"target") == 1 then
				if castSpell("target",DragonRoar,true) then
					return;
				end
			end
		end
	end
end

--bloodthirst,cycle_targets=1,if=!dot.deep_wounds.ticking
if DW_DEBUFF == nil then
	if castSpell("target",Bloodthirst,true,false) then
		return;
	end
end

--colossus_smash
if SB_COOLDOWN <= 4 or canCast(StormBolt,true) then
	if castSpell("target",ColossusSmash,true,false) then
		return;
	end
end

--storm_bolt,if=enabled&debuff.colossus_smash.up
if IsPlayerSpell(StormBolt) == true then
	if CS_DEBUFF ~= nil then
		if castSpell("target",StormBolt,true,false) then
			return;
		end
	end
end

--raging_blow,if=buff.meat_cleaver.stack=2
if MEATCLEAVER ~= nil and (MC_COUNT == 2 or MC_COUNT == 3) then
	if castSpell("target",RagingBlow,true,false) then
		return;
	end
end

--whirlwind
if castSpell("target",Whirlwind,true,false) then
	return;
end

--shockwave,if=enabled
if castSpell("target",Shockwave,true,false) then
	return;
end

--raging_blow
if castSpell("target",RagingBlow,true,false) then
	return;
end

--battle_shout
if isChecked("Battle") == true then
	if castSpell("player",BattleShout,true) then
		return;
	end  
elseif isChecked("Commanding") == true then
	if castSpell("player",CommandingShout,true) then 
		return; 
	end 
elseif BATTLESHOUT == nil then
	if castSpell("player",BattleShout,true) then
		return;
	end  
end

--heroic_throw
if castSpell("target",HeroicThrow,true,false) then
	return;
end

end
----------------
--- Three ---
----------------

----------------
--- Four ---
----------------
if (isChecked("AutoAoE") == nil and BadBoy_data['AoE'] == 4) or (isChecked("AutoAoE") == true and ENEMYS >= 4) then

--buff.enrage.remains<1&cooldown.bloodthirst.remains>1)
if ENRAGED ~= nil then
	if (ENRAGE_TIMER - GT < 1) and BT_COOLDOWN > 1 then
		if castSpell("player",BerserkerRage,true) then
			return;
		end  
	end
end

--cleave,if=rage>90
if RAGE >= 30 then
	if RAGE >= 90 then
		if castSpell("target",Cleave,true,false) then
			return;
		end
	end
end

--bladestorm,if=enabled&(buff.bloodbath.up|!talent.bloodbath.enabled)
if IsPlayerSpell(Bladestorm) == true then
	if isChecked("Bladestorm") ~= true then
		if IsSpellInRange(GetSpellInfo(HeroicStrike),"target") == 1 then
			if castSpell("target",Bladestorm,true) then
				return;
			end
		end
	end
end

--bloodthirst,cycle_targets=1,if=!dot.deep_wounds.ticking&buff.enrage.down
if ENRAGED == nil then
	if castSpell("target",Bloodthirst,true,false) then
		return;
	end
end

--raging_blow,if=buff.meat_cleaver.stack=3
if MEATCLEAVER ~= nil and MC_COUNT == 3 then
	if castSpell("target",RagingBlow,true,false) then
		return;
	end
end

--whirlwind
if castSpell("target",Whirlwind,true,false) then
	return;
end

--dragon_roar,if=enabled&(!debuff.colossus_smash.up&(buff.bloodbath.up|!talent.bloodbath.enabled))
if IsPlayerSpell(DragonRoar) == true then
	if isChecked("Dragon Roar") ~= true then
		if (CS_DEBUFF == nil or (OUTRAGE ~= nil or DETERMINATION ~= nil)) and COMBATTIME > 5 then
			if IsSpellInRange(GetSpellInfo(HeroicStrike),"target") == 1 then
				if castSpell("target",DragonRoar,true) then
					return;
				end
			end
		end
	end
end

--bloodthirst,cycle_targets=1,if=!dot.deep_wounds.ticking
if DW_DEBUFF == nil then
	if castSpell("target",Bloodthirst,true,false) then
		return;
	end
end

--colossus_smash
if castSpell("target",ColossusSmash,true,false) then
	return;
end

--storm_bolt,if=enabled
if IsPlayerSpell(StormBolt) == true then
	if castSpell("target",StormBolt,true,false) then
		return;
	end
end

--shockwave,if=enabled
if castSpell("target",Shockwave,true,false) then
	return;
end

--battle_shout
if isChecked("Battle") == true then
	if castSpell("player",BattleShout,true) then
		return;
	end  
elseif isChecked("Commanding") == true then
	if castSpell("player",CommandingShout,true) then 
		return; 
	end 
elseif BATTLESHOUT == nil then
	if castSpell("player",BattleShout,true) then
		return;
	end  
end

end
----------------
--- Four ---
----------------

			end --elseif UnitExists("target") and not UnitIsDeadOrGhost("target") and isEnnemy("target") == true and getCreatureType("target") == true then
		end --if pause() ~= true and isInCombat("player") and canAttack("target","player") and not UnitIsDeadOrGhost("target") then		
	end -- function FuryWarrior()
end --if select(3,UnitClass("player")) == 1 then