if select(3, UnitClass("player")) == 4 then
function CombatRogue()
	if AoEModesLoaded ~= "Combat Rogue AoE Modes" then
		CombatOptions();
		CombatToggles();
		AoEModesLoaded = "Combat Rogue AoE Modes";
		leftPoisonsTable = {
			{ 	name = "Crippling Poison" ,  	ID = 3408 	},
			{ 	name = "Leeching Poison" ,  	ID = 108211	}
		}
		rightPoisonsTable = {
			{ 	name = "Deadly Poison" , 		ID = 2823 	},
			{ 	name = "Wound Poison" , 		ID = 8679 	}
		}
	end

	ChatOverlay(canPickpocket)

--[[
Todo: 
finish leveling low level rogue to see if any issues for low level players...should be good though
marked for death logic
opener option ie. ambush, cheapshot or other
possible simple pvp mode if target = enemy faction

]]

--------------
--- Poison ---
--------------

	if poisonTimer == nil or poisonTimer <= GetTime() - 2 then
		if not UnitBuffID("player", leftPoisonsTable[getValue("Left Poison")].ID) then
			if castSpell("player",leftPoisonsTable[getValue("Left Poison")].ID) then poisonTimer = GetTime(); return; end
		end
		if not UnitBuffID("player", rightPoisonsTable[getValue("Right Poison")].ID) then
			if castSpell("player", rightPoisonsTable[getValue("Right Poison")].ID) then poisonTimer = GetTime(); return; end
		end
	end
--------------	
--- Locals ---
--------------
	local energy = getPower("player");
	local combo, _PowerPool;
	if _PowerPool == nil then _PowerPool = 0 end
	local _AnticipationStacks, _RealCombo  = select(4,UnitBuff("player", GetSpellInfo(115189))), GetComboPoints("player", "target")
	if _AnticipationStacks ~= nil then combo = _AnticipationStacks + _RealCombo; else combo = _RealCombo; end
	if _AnticipationStacks == nil then _AnticipationStacks = 0; end
	if isKnown(114015) == true and getBuffRemain("player", 84747) > 0 and getBuffRemain("player",_SliceAndDice) > 1 then 
		_PowerPool = 4 
	else
		_PowerPool = 0    
	end

	local numEnemies;
	local meleeEnemies = getNumEnemies("player",10);

-------------------------
---      Stealth      ---
-------------------------

	if not isInCombat("player") and not UnitBuffID("player",_Stealth) and canAttack("player","target") and not UnitIsDeadOrGhost("target") and targetDistance < 30 and getSpellCD(_Stealth)==0 then
			if castSpell("player",_Stealth,false,false,false) then return; end
	end
	
-------------------------
--- AMBUSH AKA Opener ---
-------------------------
	if getDistance("player","target") < 5 or (hasGlyph(56813) and getDistance("player","target") <= 10)  and (UnitBuffID("player",1784) ~= nil or UnitBuffID("player",58984) ~= nil or UnitBuffID("player",1856) ~= nil) and energy >= 60 and getFacing("player","target") == true then
	  	if castSpell("target",_Ambush,false,false) then return true; end
	end

-------------------------
---   Combat Starts   ---
-------------------------
	if UnitAffectingCombat("player") and isEnnemy("target") and not UnitIsDeadOrGhost("target") then

		-- Leveling 1-20 sux
		if UnitLevel("player") < 20 then
			-- Sinister Strike Spam
			if combo >= 4 then
			  	if castSpell("target",_Eviscerate,false,false) then return; end
			  		else
			  	if castSpell("target",_SinisterStrike,true) then return; end		
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

		-- Recuperate (with free glyph each kill resets to full original duration)
		if isChecked("Recuperate") == true then
			if combo > 2 and getHP("player") <= getValue("Recuperate") and getBuffRemain("player",73651) < 1 then
				if castSpell("player",_Recuperate,true,false) then return; end
				elseif combo > 3 and UnitLevel("player") < 90 and getBuffRemain("player",73651) < 1 and hasGlyph(63254) then
					if castSpell("player",_Recuperate,true,false) then return; end	
			end
		end	
		
		-- Combat Readiness
		if isChecked("Combat Readiness") == true and getHP("player") <= getValue("Combat Readiness") and UnitThreatSituation("player") == 3 then
			if castSpell("player",_CombatReadiness,true,false) then return; end
		end	

		-- Adrenaline Rush
		if getSpellCD(_AdrenalineRush) == 0 then
			if isChecked("Adrenaline Rush") == true and castSpell("player",_AdrenalineRush,true,false) then return; end	
		end

		-- Preparation 
		if getSpellCD(_Vanish) > 0 then
			if isChecked("Preparation") == true and castSpell("player",_Preparation,true,false) then return; end
		end

		-- Kick
		if isChecked("Kick") == true then
			if canInterrupt(_Kick, getValue("Kick")) and getDistance("player","target") <= 4 then
				castSpell("target",_Kick,false,false);
			end
		end

		-- Revealing Strike
		if getDebuffRemain("target", 84617) < 4 and UnitLevel("player")>=20 then
		  	if castSpell("target",_RevealingStrike,false,false) then return; end
		end

		-- SliceAndDice
		if getBuffRemain("player",_SliceAndDice) < 5 then
			if castSpell("player",_SliceAndDice,true,false) then return; end
		end
		--Marked For Death (need to add logic to use if will die in less than 60sec or in burn phase)	
		if combo < 1 then
			if castSpell("target",_MarkedForDeath,false) then return; end
		end

-------------------------
---   Aoe Rotation    ---
-------------------------
		if meleeEnemies > 2 and energy > 50 then
			if not UnitBuffID("player",13877) and getSpellCD(_BladeFlurry)==0 then
				if castSpell("player",_BladeFlurry) then return; end
			end	
			-- Crimson Tempest
			if combo >= 4 and getBuffRemain("player", _SliceAndDice) > 3 and meleeEnemies > 5 then
				if castSpell("player",_CrimsonTempest,true,false) then return; end
					else
				if castSpell("target",_Eviscerate,false,false) then return; end
			end	
			if combo < 5 then
				if castSpell("target",_SinisterStrike,true) then return; end
			end
		end

-----------------------
--- Single Rotation ---
-----------------------
		if meleeEnemies <= 2 then
			if UnitBuffID("player",13877) and getSpellCD(_BladeFlurry)==0 then 
				if castSpell("player",_BladeFlurry) then return; end
			end
			-- _Eviscerate
			if combo > 4 and getBuffRemain("player",_SliceAndDice) > 5 then
				if castSpell("target",_Eviscerate,false,false) then return; end
			end	
			-- SS
			if energy >= 70 then
				if castSpell("target",_SinisterStrike,true) then return; end
			end					
		end
	end
end
--[[
Single Target Rotation

Poison:
Lethal: Deadly Poison
Non-Lethal: Crippling Poison

Combo Point Builders:
Ambush is used whenever possible.
Revealing Strike is only used to maintain its debuff.
Sinister Strike is used to generate CP.

Finishing Moves:
Slice and Dice is maintained at all times.
Eviscerate is used to dump CP.

The Combat Rogue DPS rotation revolves around maintaining the Slice and Dice and Revealing Strike buffs while dumping your excess Combo Points into Eviscerate. 
To build Combo Points, you should use Ambush whenever possible. After this, only use Revealing Strike as needed to maintain its debuff. 
Sinister Strike is your primary Combo Point Builder. 
After building Combo Points, your top priorty is to maintain Slice and Dice at all times via 5 CP refreshes. 
Finally, dump your excess CP into 5 CP Eviscerate.

AoE Abilities:

Blade Flurry to apply damage and help build Combo Points.
Crimson Tempest to spend Combo Points.
At > 1 target activate Blade Flurry, but otherwise continue with the single target priority. 
At 6+ targets, continue to build Combo Points using the single target priority but use Crimson Tempest as your Combo Point dump instead of Eviscerate.

Talents

Shadow Focus allows you to cast a low-cost Ambush as you exit Stealth and again after every Vanish cooldown.
Marked for Death is best used for burst DPS and is especially potent on weaker targets that will quickly die and reset the cooldown on Marked for Death.

Effective Cooldowns

Adrenaline Rush Use on cooldown. Do not stack with Killing Spree.
Killing Spree Use at low Energy. Do not stack with Adrenaline Rush.
Preparation Use to reset Vanish to cast Ambush.
Tricks of the Trade Use as directed by your raid/party leader.
Vanish Use to cast a Ambush. Reset with Preparation.]]








end
