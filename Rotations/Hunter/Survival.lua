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
local COMBATTIME = getCombatTime()
local PROF1, PROF2 = GetProfessions()
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

--Aoe checks
if AOETimer == nil then AOETimer = 0; end
if ENEMYS == nil or (AOETimer and AOETimer <= GetTime() - 1) then AOETimer = GetTime() ENEMYS = getNumEnnemies("target", 5) end

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
if isCasting() then return false; end

--Out of Combat
if isInCombat("player") == nil then



--Combat
elseif isInCombat("player") then
	
		--blood_fury
		if IsPlayerSpell(BloodFury) then
			if castSpell("player",BloodFury,false) then return; end
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
				if UnitHealth("target") > (UnitHealthMax("player")*50) then
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
