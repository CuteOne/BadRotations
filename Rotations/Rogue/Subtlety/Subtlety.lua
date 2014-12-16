if select(3, UnitClass("player")) == 4 then
function SubRogue()
	--ChatOverlay(getNumEnemies("player",10))
	if AoEModesLoaded ~= "Sub Rogue AoE Modes" then
		SubOptions();
		SubToggles();
		AoEModesLoaded = "Sub Rogue AoE Modes";
		_Hemorrhage    			= 1752;
		leftPoisonsTable = { 
			{ 	name = "Crippling Poison" ,  	ID = 3408 	},
			--{ 	name = "Mind-Numbling Poison" , ID = 5761 	},
			{ 	name = "Leeching Poison" ,  	ID = 108211	}
		}
		rightPoisonsTable = { 
			{ 	name = "Deadly Poison" , 		ID = 2823 	},
			{ 	name = "Wound Poison" , 		ID = 8679 	}
		}
	end






--[[
Si facing true tu peux faire 360 deg
Si facing false tu dois etre face a la target
Si movement false tu peux le caster en bougeant
Si movement true tu dois etre immobile

		   target	Spells		Facing, Movement
castSpell("player",_FanOfKnives,true    ,false)]]




	--[[Poisons]]
	if poisonTimer == nil or poisonTimer <= GetTime() - 2 then
		if not UnitBuffID("player", leftPoisonsTable[getValue("Left Poison")].ID) then
			if castSpell("player",leftPoisonsTable[getValue("Left Poison")].ID) then poisonTimer = GetTime(); return; end
		end
		if not UnitBuffID("player", rightPoisonsTable[getValue("Right Poison")].ID) then
			if castSpell("player", rightPoisonsTable[getValue("Right Poison")].ID) then poisonTimer = GetTime(); return; end
		end
	end

	-- Locals
	local energy = getPower("player");
	local combo, _PowerPool;
	if _PowerPool == nil then _PowerPool = 0 end
	local _AnticipationStacks, _RealCombo  = select(4,UnitBuff("player", GetSpellInfo(115189))), GetComboPoints("player", "target")
	if _AnticipationStacks ~= nil then combo = _AnticipationStacks + _RealCombo; else combo = _RealCombo; end
	if _AnticipationStacks == nil then _AnticipationStacks = 0; end
	if isKnown(114015) == true and getBuffRemain("player", 84747) > 0 and getDebuffRemain("target",_FindWeakness,"player") > 1 and getBuffRemain("player",_SliceAndDice) > 1 then 
		_PowerPool = 4 
	else
		_PowerPool = 0    
	end

	local numEnemies;
	local meleeEnemies = getNumEnemies("player",10);

	-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then return false; end

	--[[Stealth before fight]]
	if isChecked("Stealth") and (stealthTimer == nil or stealthTimer <= getValue("Stealth Timer")) and not UnitAffectingCombat("player") and not UnitIsDeadOrGhost("target") and not (UnitExists("target") and not isEnnemy("target")) and getCreatureType("target") == true then
		--[[Always]]
		if getValue("Stealth") == 1 then 
			if not UnitBuffID("player",1784) then
				if castSpell("player",_Stealth) then return; end
			end
		end
		--[[Pre-Pot]]
		if getValue("Stealth") == 2 then
			if not UnitBuffID("player",_Stealth) and getBuffRemain("player",105697) > 0 and canAttack("player","target") and targetDistance < 30 and getSpellCD(_Stealth) == 0 then
				if castSpell("player",_Stealth) then return; end
			end
		end
		--[[30 Yards]]
		if getValue("Stealth") == 3 then
			if not isInCombat("player") and not UnitBuffID("player",_Stealth) and canAttack("player","target") and targetDistance < 30 and getSpellCD(_Stealth) == 0 then
				if castSpell("player",_Stealth) then return; end
			end
		end
	end

	-- Ambush
	if (getDistance("player","target") < 2.5 or getTalent(4,1)) and (UnitBuffID("player",1784) ~= nil or UnitBuffID("player",58984) ~= nil or UnitBuffID("player",1856) ~= nil) and (energy >= 60 or (_ShadowDance and energy >= 40)) and getFacing("player","target") == true and getFacing("target","player") == false then
	  	if castSpell("target",_Ambush,false,false,false,false,false,true) then return true; end
	end


	if UnitAffectingCombat("player") and isEnnemy("target") and not UnitIsDeadOrGhost("target") then

		-- Levleling 1-10
		if UnitLevel("player") < 10 then
			-- Hemorrhage maintain bleed
			if combo >= 3 then
			  	if castSpell("target",_Eviscerate,false,false) then return; end
			end
		end

		-- Evasion
		if isChecked("Evasion") == true and UnitThreatSituation("player") == 3 and getHP("player") <= getValue("Evasion") then
			if castSpell("player",_Evasion,true,false) then return; end
		end

		-- Feint
		if isChecked("Feint") == true and getHP("player") <= getValue("Feint") and getBuffRemain("player",1966) < 1 then
			if castSpell("player",_Feint,true,false) then return; end
		end

		-- Recuperate
		if combo > 2 and isChecked("Recuperate") == true and getHP("player") <= getValue("Recuperate") and getBuffRemain("player",73651) < 1 then
			if castSpell("player",_Recuperate,true,false) then return; end
		end		

		-- Combat Readiness
		if isChecked("Combat Readiness") == true and getHP("player") <= getValue("Combat Readiness") and UnitThreatSituation("player") == 3 then
			if castSpell("player",_CombatReadiness,true,false) then return; end
		end		

		-- Master of Subtlety
		if isBoss() and getBuffRemain("player",31665) < 2 and (stealthTimer == nil or stealthTimer <= GetTime() - 2) then
			if isChecked("Shadow Dance") == true and castSpell("player",_ShadowDance) then stealthTimer = GetTime(); return; end
			if isChecked("Vanish") == true and castSpell("player",_Vanish) then stealthTimer = GetTime(); return; end
			if isChecked("Shadowmeld") == true and castSpell("player",_Shadowmeld) then stealthTimer = GetTime(); return; end
		end
		-- Preparation
		if isBoss() and getSpellCD(_Vanish) > 0 then
			if isChecked("Preparation") == true and castSpell("player",_Preparation,true,false) then return; end
		end

		-- ShadowBlades
		--if isChecked("Shadow Blades") == true and castSpell("player",_ShadowBlades,true,false) then return; end

		-- Kick
		if isChecked("Kick") == true then
			if canInterrupt(_Kick, getValue("Kick")) and getDistance("player","target") <= 4 then
				castSpell("target",_Kick,false,false);
			end
		end

		-- SliceAndDice
		if getBuffRemain("player",_SliceAndDice) < 5 and _AnticipationStacks == 0 and UnitHealth("target") > UnitHealthMax("player")*3 then
			if castSpell("player",_SliceAndDice,true,false) then return; end
		end

		-- AoE
		if meleeEnemies > 2 and energy > 35 then
			-- Crimson Tempest
			if combo >= 4 and getBuffRemain("player", _SliceAndDice) > 3 then
				if castSpell("player",_CrimsonTempest,true,false) then return; end
			end	
			-- Fan of Knive
			if castSpell("player",_FanOfKnives,true,false) then return; end
		end

		-- Single
		if meleeEnemies <= 2 then
			-- Rupture maintain buff (5 cp)//Garotte
			if energy > 35 then
				if combo > 4 and getTimeToDie("target") > 10 then
					if getBuffRemain("player",_ShadowDance) > 2 then
						if castSpell("target",_Garrote, false, false) then return; end
					else
						if castSpell("target",_Rupture, false, false) then return; end 
					end
				end
				if (combo > 1 and getHP("target") < 50) or (combo > 4 and getTimeToDie("target") < 10) then 
					if castSpell("target",_Eviscerate, false, false) then return; end
				end
			end				
			-- Hemorrhage maintain bleed
			if getDebuffRemain("target", 89775,"player") < 2 then
			  	if castSpell("target",_Hemorrhage,false,false) then return; end
			end
			-- BackStab
			if energy >= 90 and getFacing("player","target") == true and getFacing("target","player") == false and castSpell("target",_Backstab,false,false) then return; end
			-- _Eviscerate (5 cp filler)
			if combo > 4 and getBuffRemain("player",_SliceAndDice) > 5 then
				if castSpell("target",_Eviscerate,false,false) then return; end
			end	
			-- Hemorrhage dump
			if energy >= 90 or (energy > 50 and getHP("target") < 75) then
			  	if castSpell("target",_Hemorrhage,false,false) then return; end
			end					
		end
	end
end
end




