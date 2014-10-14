if select(3, UnitClass("player")) == 3 then
function SurvHunter()

if Currentconfig ~= "Survival Avery" then
	SurvConfig();
	SurvToggles();
	Currentconfig = "Survival Avery";
end

--Locals
local FOCUS = UnitPower("player")
local PLAYERHP = 100*(UnitHealth("player")/UnitHealthMax("player"))
local TARGETHP = 100*(UnitHealth("target")/UnitHealthMax("target"))
local PETHP = 100*(UnitHealth("pet")/UnitHealthMax("pet"))
local HIGHHP = UnitHealthMax("target") > (UnitHealthMax("player")*100)
local COMBATTIME = getCombatTime()
local BOSS = isBoss("target") or isDummy("target")
local TTD = getTimeToDie("target")
local GT = GetTime()

--pet
local FOCUSPET = UnitPower("pet")
local PETEXISTS = UnitExists("pet")
local PETDEAD = UnitIsDeadOrGhost("pet")
local PETALIVE = PETEXISTS ~= nil and PETDEAD == nil
local PETDISTANCE = getDistance("pet","target")
local PETLOS = getLineOfSight("pet","target")
local PETINRANGE = PETDISTANCE <= 25 and PETLOS ~= nil

--Buffs
local LALBUFF,_,_,LAL_COUNT,_,_,LAL_TIMER = UnitBuffID("player",LockandLoad)
local SS_DEBUFF,_,_,_,_,_,SS_TIMER = UnitDebuffID("target",SerpentStingDebuff,"PLAYER")
local BA_DEBUFF,_,_,_,_,_,BA_TIMER = UnitDebuffID("target",BlackArrowDebuff,"PLAYER")

--pet Buffs
local MENDBUFF,_,_,_,_,_,MEND_TIMER = UnitBuffID("pet",MendPet)

--Aoe checks
if AOETimer == nil then AOETimer = 0; end
if ENEMYS == nil or (AOETimer and AOETimer <= GetTime() - 1) then AOETimer = GetTime() ENEMYS = getNumEnemies("target", 5) end

if isChecked("AutoAoE") ~= true then
	if isChecked("Rotation Up") == true then
		if SpecificToggle("Rotation Up") == 1 and GetCurrentKeyBoardFocus() == nil then
			if GetTime() - AOETimer > 0.25 then AOETimer = GetTime() ToggleValue("AoE"); end
		end
	end
	if isChecked("Rotation Down") == true then
		if SpecificToggle("Rotation Down") == 1 and GetCurrentKeyBoardFocus() == nil then
			if GetTime() - AOETimer > 0.25 then AOETimer = GetTime() ToggleMinus("AoE"); end
		end
	end
end

-- Food/Invis/Cast Check
if not canRun() or UnitInVehicle("Player") then return false; end
if IsMounted("player") then waitForPetToAppear = nil; return false; end

-- Call Pet
if isChecked("Auto Call Pet") == true and UnitExists("pet") == nil then
	if waitForPetToAppear ~= nil and waitForPetToAppear < GetTime() - 2 then
		if lastFailedWhistle and lastFailedWhistle > GetTime() - 3 then
			if isMoving("player") == false then
				if castSpell("player",RevivePet) then return; end
			end
		else
			if getValue("Auto Call Pet") == 1 then
				if Exotic(1) then
					if castSpell("player",CallPet1,true) then
						return;
					end
				end
			elseif getValue("Auto Call Pet") == 2 then
				if Exotic(2) then
					if castSpell("player",CallPet2,true) then
						return;
					end
				end
			elseif getValue("Auto Call Pet") == 3 then
				if Exotic(3) then
					if castSpell("player",CallPet3,true) then
						return;
					end
				end
			elseif getValue("Auto Call Pet") == 4 then
				if Exotic(4) then
					if castSpell("player",CallPet4,true) then
						return;
					end
				end
			elseif getValue("Auto Call Pet") == 5 then
				if Exotic(5) then
					if castSpell("player",CallPet5,true) then
						return;
					end
				end
			end
		end
	end
	if waitForPetToAppear == nil then
		waitForPetToAppear = GetTime()
	end
end

--Revive Pet
if UnitIsDeadOrGhost("pet") then
	if isMoving("player") == false then
		if castSpell("player",RevivePet) then return; end
	end
end

--Mend Pet
if isChecked("Mend Pet") == true then
	if MENDBUFF == nil then
		if PETHP <= getValue("Mend Pet") then
			if castSpell("pet",MendPet) then return; end
		end
	end
end

--Out of Combat
if isInCombat("player") == nil then



--Combat
elseif isInCombat("player") and TargetValid("target") then
	
		--gloves
		if GetInventoryItemCooldown("player", 10) == 0 then
			UseInventoryItem(10)
		end
		
		--blood_fury
		if IsPlayerSpell(BloodFury) then
			if HIGHHP then
				if castSpell("player",BloodFury,false) then return; end
			end
		end
		
		--explosivetrap,if=activeenemies>1
		if canCast(TrapLauncherExplosive) then
			if (isChecked("AutoAoE") ~= true and BadBoydata['AoE'] == 2) or (isChecked("AutoAoE") == true and ENEMYS > 1) then
				if getGround("target") == true and isMoving("target") == false then 
					if castGround("target",TrapLauncherExplosive,40) then return; end
				end
			end
		end
		
		--fervor,if=enabled&focus<=50
		if IsPlayerSpell(Fervor) then
			if FOCUS <= 50 then
				if castSpell("player",Fervor,false) then return; end
			end
		end
		
		--amurderofcrows,if=enabled&!ticking
		if IsPlayerSpell(AMurderOfCrows) then
			if FOCUS >= 60 then
				if HIGHHP then
					if castSpell("target",AMurderOfCrows,false) then return; end
				end
			end
		end
		
		--arcane_shot,if=focus>=90&active_enemies<2
		if (isChecked("AutoAoE") ~= true and BadBoydata['AoE'] == 1) or (isChecked("AutoAoE") == true and ENEMYS <= 1) then
			if FOCUS >= 90 then
				if castSpell("target",ArcaneShot,false) then return; end
			end
		end
		
		--multi_shot,if=focus>=90&active_enemies>1
		if (isChecked("AutoAoE") ~= true and BadBoydata['AoE'] == 2) or (isChecked("AutoAoE") == true and ENEMYS > 1) then
			if FOCUS >= 90 then
				if castSpell("target",MultiShot,false) then return; end
			end
		end
		
		--explosiveshot,if=buff.lockandload.react
		if LALBUFF ~= nil then
			if LAL_COUNT >= 1 then
				if castSpell("target",ExplosiveShot,false,false) then return; end
			end
		end
		
		--cancel cobra_shot
		if isCasting() then return false; end
		
		--glaivetoss,if=enabled
		if IsPlayerSpell(GlaiveToss) then
			if FOCUS >= 15 then
				if castSpell("target",GlaiveToss,false) then return; end
			end
		end
		
		--todo single toggle check
		--barrage,if=enabled
		if IsPlayerSpell(Barrage) then
			if FOCUS >= 30 then
				if castSpell("target",Barrage,false) then return; end
			end
		end
		
		--serpentsting,if=!ticking&target.timetodie>=10
		if (isChecked("AutoAoE") ~= true and BadBoydata['AoE'] == 1) or (isChecked("AutoAoE") == true and ENEMYS <= 1) then
			if FOCUS >= 15 then
				if SS_DEBUFF == nil and TTD >= 10 then
					if castSpell("target",SerpentSting,false) then return; end
				end
			end
		end
		
		--explosiveshot,if=cooldownreact
		if FOCUS >= 25 then
			if castSpell("target",ExplosiveShot,false) then return; end
		end
		
		--killshot
		if TARGETHP <= 20 then
			if castSpell("target",KillShot,false) then return; end
		end
		
		--blackarrow,if=!ticking&target.timetodie>=8
		if FOCUS >= 35 then
			if (BA_DEBUFF == nil or (BA_DEBUFF ~= nil and (BA_TIMER - GT < 2))) and TTD >= 8 then
				if castSpell("target",BlackArrow,false) then return; end
			end
		end
		
		--multi_shot,if=active_enemies>3
		if (isChecked("AutoAoE") ~= true and BadBoydata['AoE'] == 3) or (isChecked("AutoAoE") == true and ENEMYS > 3) then
			if FOCUS >= 40 then
				if castSpell("target",MultiShot,false) then return; end
			end
		end
		
		--multi_shot,if=buff.thrill_of_the_hunt.react&dot.serpent_sting.remains<2
		--arcane_shot,if=buff.thrill_of_the_hunt.react
		
		--rapid_fire,if=!buff.rapid_fire.up
		if castSpell("player",RapidFire,false) then return; end
		
		--dire_beast,if=enabled
		if IsPlayerSpell(DireBeast) then
			if castSpell("target",DireBeast,false) then return; end
		end
		
		--stampede,if=trinket.stat.agility.up|target.time_to_die<=20|(trinket.stacking_stat.agility.stack>10&trinket.stat.agility.cooldown_remains<=3)
		
		--cobra_shot,if=dot.serpent_sting.remains<6
		if SS_DEBUFF ~= nil and (SS_TIMER - GT < 6) then
			if castSpell("target",CobraShotSurv,false,false) then return; end
		end
		
		--arcane_shot,if=focus>=67&active_enemies<2
		if (isChecked("AutoAoE") ~= true and BadBoydata['AoE'] == 1) or (isChecked("AutoAoE") == true and ENEMYS <= 1) then
			if FOCUS >= 67 then
				if castSpell("target",ArcaneShot,false) then return; end
			end
		end
		
		--multi_shot,if=focus>=67&active_enemies>1
		if (isChecked("AutoAoE") ~= true and BadBoydata['AoE'] == 2) or (isChecked("AutoAoE") == true and ENEMYS > 1) then
			if FOCUS >= 67 then
				if castSpell("target",MultiShot,false) then return; end
			end
		end
		
		--cobra_shot
		if castSpell("target",CobraShotSurv,false,false) then return; end
		
		end --if isInCombat("player") == nil then
	end -- function SurvHunter()
end --if select(3, UnitClass("player")) == 3 then
