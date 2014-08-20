if select(3, UnitClass("player")) == 4 then
function SubRogue()
	--ChatOverlay(getNumEnnemies("player",10))
	if AoEModesLoaded ~= "Sub Rogue AoE Modes" then
		SubOptions();
		SubToggles();
		AoEModesLoaded = "Sub Rogue AoE Modes"
	end



_AdrenalineRush			= 13750
_Ambush     			= 8676
_Backstab     			= 53 
_Berserking  			= 26297
_BladeFlurry			= 13877
_Blind          		= 2094 
_BloodFury				= 20572      
_CheapShot      		= 1833  
_CloakOfShadows 		= 31224 
_CombatReadiness		= 74001
_CrimsonTempest 		= 121411
_CripplingPoison  		= 3408 
_DeadlyPoison   		= 2823 
_DeadlyThrow    		= 26679
_DisarmTrap    			= 1842
_Dismantle    			= 51722
_Dispatch				= 111240
_Distract    			= 1725
_Evasion    			= 5277 
_Envenom				= 32645
_Eviscerate     		= 2098 
_ExposeArmor    		= 8647 
_FanOfKnives   			= 51723 
_Feint     				= 1966
_Garrote    			= 703 
_Gouge     				= 1776 
_Hemorrhage    			= 1752
_Kick     				= 1766
_KidneyShot    			= 408 
_KillingSpree			= 51690
_LeechingPoison   		= 108211
_MarkedForDeath			= 137619
_MindnumbingPoison  	= 5761 
_Mutilate				= 1329
_ParalyticPoison  		= 108215 
_PickLock    			= 1804
_PickPocket    			= 921  
_Premeditation   		= 14183 
_Preparation   			= 14185 
_Recuperate    			= 73651 
_Redirect      			= 73981 
_RevealingStrike		= 84617
_Rupture    			= 1943
_Sap      				= 6770 
_ShadowBlades    		= 121471 
_ShadowDance    		= 51713 
_Shadowmeld				= 58984
_ShadowWalk    			= 114842 
_Shadowstep    			= 36554 
_Shiv      				= 5938
_ShroudOfConcealment 	= 114018 
_SinisterStrike			= 1752
_SliceAndDice   		= 5171 
_SmokeBomb    			= 76577 
_Sprint     			= 2983 
_Stealth    			= 115191
_Throw     				= 121733 
_TricksOfTheTrade  		= 57934 
_Vanish     			= 1856 
_WoundPoison   			= 8679
_FindWeakness			= 	91021
_Anticipation 			= 114015



leftPoisonsTable = { 
	{ 	name = "Crippling Poison" ,  	ID = 3408 	},
	{ 	name = "Mind-Numbling Poison" , ID = 5761 	},
	{ 	name = "Leeching Poison" ,  	ID = 108211	}
}
rightPoisonsTable = { 
	{ 	name = "Deadly Poison" , 		ID = 2823 	},
	{ 	name = "Wound Poison" , 		ID = 8679 	}
}

--[[
Si facing true tu peux faire 360 deg
Si facing false tu dois etre face a la target
Si movement false tu peux le caster en bougeant
Si movement true tu dois etre immobile

		   target	Spells		Facing, Movement
castSpell("player",_FanOfKnives,true    ,false)]]





	if poisonTimer == nil or poisonTimer <= GetTime() - 2 then
		if not UnitBuffID("player", leftPoisonsTable[getValue("Left Poison")].ID) then
			if castSpell("player",leftPoisonsTable[getValue("Left Poison")].ID) then poisonTimer = GetTime(); return; end
		elseif not UnitBuffID("player", rightPoisonsTable[getValue("Right Poison")].ID) then
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

	local numEnnemies;
	local meleeEnnemies = getNumEnnemies("player",10);




	-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then return false; end

	-- Stealth before fight
	if not UnitAffectingCombat("player") and (leftCombat == nil or leftCombat <= GetTime() - 2) and ((getValue("Stealth") == 2 and getBuffRemain("player",105697) > 0) or getValue("Stealth") == 1) and isChecked("Stealth") == true and UnitBuffID("player",1784) == nil then
		if stealthTimer == nil or stealthTimer <= 2 then
			if castSpell("player",1784,true,false) then return; end
		end
	end

	-- Ambush
	if getDistance("player","target") < 2.5 and (UnitBuffID("player",1784) ~= nil or UnitBuffID("player",58984) ~= nil or UnitBuffID("player",1856) ~= nil) and (energy >= 60 or (_ShadowDance and energy >= 40)) and getFacing("player","target") == true and getFacing("target","player") == false then
	  	if castSpell("target",_Ambush,false,false) then return true; end
	end


	if UnitAffectingCombat("player") and isEnnemy("target") then

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
		if getBuffRemain("player",31665) < 2 and (stealthTimer == nil or stealthTimer <= GetTime() - 2) then
			if isChecked("Shadow Dance") == true and castSpell("player",_ShadowDance) then stealthTimer = GetTime(); return; end
			if isChecked("Vanish") == true and castSpell("player",_Vanish) then stealthTimer = GetTime(); return; end
			if isChecked("Shadowmeld") == true and castSpell("player",_Shadowmeld) then stealthTimer = GetTime(); return; end
		end
		-- Preparation
		if getSpellCD(_Vanish) > 0 then
			if isChecked("Preparation") == true and castSpell("player",_Preparation,true,false) then return; end
		end

		-- ShadowBlades
		if isChecked("Shadow Blades") == true and castSpell("player",_ShadowBlades,true,false) then return; end

		-- Kick
		if isChecked("Kick") == true then
			if canInterrupt(_Kick, getValue("Kick")) and getDistance("player","target") <= 4 then
				castSpell("target",_Kick,false,false);
			end
		end

		-- SliceAndDice
		if getBuffRemain("player",_SliceAndDice) < 5 and _AnticipationStacks == 0 then
			if castSpell("player",_SliceAndDice,true,false) then return; end
		end

		-- AoE
		if meleeEnnemies > 2 and energy > 35 then
			-- Crimson Tempest
			if combo >= 4 and getBuffRemain("player", _SliceAndDice) > 3 then
				if castSpell("player",_CrimsonTempest,true,false) then return; end
			end	
			-- Fan of Knive
			if castSpell("player",_FanOfKnives,true,false) then return; end
		end

		-- Single
		if meleeEnnemies <= 2 then
			-- Rupture maintain buff (5 cp)//Garotte
			if energy > 35 and combo > 4 then
				if getBuffRemain("player",_ShadowDance) > 2 then
					if castSpell("target",_Garrote, false, false) then return; end
				else
					if castSpell("target",_Rupture, false, false) then return; end
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
			if energy >= 90 then
			  	if castSpell("target",_Hemorrhage,false,false) then return; end
			end					
		end




--[[


	


]]
--[[
		-- Mind Freeze
		if isChecked("Mind Freeze") == true then
			if canInterrupt(_MindFreeze, getValue("Mind Freeze")) and getDistance("player","target") <= 4 then
				castSpell("target",_MindFreeze,false);
			end
		end

    	-- Anti Magic Shell
    	if isChecked("Anti-Magic Shell") == true and getHP("player") <= getValue("Anti-Magic Shell") then
    		if castSpell("player",_AntiMagicShell,true) then return; end
    	end

    	-- Dancing Rune Weapon
    	if isChecked("Dancing Rune Weapon") == true and getHP("player") <= getValue("Dancing Rune Weapon") then
    		if castSpell("player",_DancingRuneWeapon,true) then return; end
    	end

    	-- Conversion
        if isChecked("Conversion") == true and getHP("player") <= getValue("Conversion") then
    		if castSpell("player",_Conversion,true) then return; end
    	end

    	-- Vampiric Blood
        if isChecked("Vampiric Blood") == true and getHP("player") <= getValue("Vampiric Blood") then
    		if castSpell("player",_VampiricBlood,true) then return; end
    	end

    	-- Icebound Fortitude
        if isChecked("Icebound Fortitude") == true and getHP("player") <= getValue("Icebound Fortitude") then
    		if castSpell("player",_IceboundFortitude,true) then return; end
    	end

    	-- Rune Tap
        if isChecked("Rune Tap") == true and getHP("player") <= getValue("Rune Tap") then
    		if castSpell("player",_RuneTap,true) then return; end
    	end

    	-- Empower Rune Weapon
        if isChecked("Empower Rune Weapon") == true and getHP("player") <= getValue("Empower Rune Weapon") then
    		if castSpell("player",_EmpowerRuneWeapon,true) then return; end
    	end
	end


	if isCasting() then return false; end

    -- Presence
    if isKnown(_BloodPresence) and isChecked("Presence") then
    	if getValue("Presence") == 1 and UnitBuffID("player",_BloodPresence) == nil then
    		if castSpell("player",_BloodPresence,true) then return; end
    	elseif getValue("Presence") == 2 and UnitBuffID("player",_FrostPresence) == nil then
    		if castSpell("player",_FrostPresence,true) then return; end
    	end
    elseif isChecked("Frost Presence") then
    	if getValue("Presence") == 2 and UnitBuffID("player",_FrostPresence) == nil then
    		if castSpell("player",_FrostPresence,true) then return; end
    	end
    end

	-- Horn of Winter
	if getBuffRemain("player",_HornOfWinter) <= 4 then
		if castSpell("player",_HornOfWinter,true) then return; end
	end

	if isInCombat("player") and isAlive() and (isEnnemy() or isDummy("target")) then

	    -- Death Siphon
	    if runesDeath >= 1 and getHP("player") <= 70 then
	    	if castSpell("target",_DeathSiphon,false) then return; end
	    end

		-- Raise Dead
		if isSelected("Raise Dead") then
			if castSpell("player",_RaiseDead,true) then return; end
		end

    	-- Bone Shield
    	if isChecked("Bone Shield") and UnitBuffID("player",_BoneShield) == nil then
    		if castSpell("player",_BoneShield,true) then return; end
    	end

    	-- Death and Decay
		if isSelected("Death And Decay") and (getRunes("unholy") >= 1 or getRunes("death") >= 1) then
			if getGround("target") == true and UnitExists("target") and ((isDummy("target") and getDistance("target","targettarget") <= 10) or getDistance("target","targettarget") <= 20) then
				if castGroundBetween("target",_DeathAndDecay,30) then return; end
			end
		end    	

	    -- Blood Tap
	    if getBuffStacks("player",114851) >= 5 and canTap() then
	    	if castSpell("player",_BloodTap,true) then return; end
	    end


	-- When pulling, you’ll want to apply diseases using Outbreak. 
		
		-- Then you can Heart Strike with both Blood Runes, and use Death Strike to take advantage of the Death Strike mechanics (healing for damage taken in preceding 5 sec).

		-- You’ll want to keep diseases active at all times. 
		-- The most efficient way to refresh your diseases is with Blood Boil thanks to Scarlet Fever. 
		-- However, if a disease expires, refresh the disease via Outbreak. 
		-- If Outbreak is on cooldown, then use Icy Touch and/or Plague Strike.

		-- Beyond diseases, you’ll want to Death Strike as much as possible with your Frost, Unholy, and Death Runes. 
		-- Use Heart Strike with Blood Runes, and Rune Strike whenever all Runes are depleted or when you are capped with Runic Power. 
		-- Soul Reaper replaces Heart Strike when your target has 35% or less Health.



	    -- Rune Strike//Death Coil
	    if runicPower >= 90 then
	    	if isKnown(_RuneStrike) then
	    		if castSpell("target",_RuneStrike,false) then return; end
	   		else
	   			-- Death Coil
	    		if castSpell("target",_DeathCoil,false) then return; end
	    	end
	    end

	    -- Pestilence - Bring
	    local PestiSpell;
	    if isKnown(_RoilingBlood) then PestiSpell = _BloodBoil; else PestiSpell = _Pestilence; end	    
	    if runesBlood >= 1 or runesDeath >= 1 and (pestiTimer == nil or pestiTimer <= GetTime() - 2) then
			if canCast(_Pestilence) then
				if getDebuffRemain("target",55078) == 0 then
					for i = 1, #targetEnnemies do
						local Guid = targetEnnemies[i]
						ISetAsUnitID(Guid,"thisUnit");
						if getCreatureType("thisUnit") == true and getDebuffRemain("thisUnit",55078,"player") >= 2 then
							if castSpell("thisUnit",_Pestilence,true) then pestiTimer = GetTime(); return; end								
						end
					end	
				end
			end
	    end

	    -- Blood Boil - Refresh
	    if targetDistance <= 10 and (runesBlood >= 1 or runesDeath >= 1) and ((UnitDebuffID("target",55078,"player") ~= nil and getDebuffRemain("target",55078) < 6)) then
	    	if castSpell("player",_BloodBoil,true) then return; end
	    end

	    -- Outbreak
	    if UnitDebuffID("target",55078,"player") == nil then
	    	if castSpell("target",_Outbreak,false) then return; end
	    end

	    -- Icy Touch
	    if (runesFrost >= 1 or runesDeath >= 1) and getDebuffRemain("target",55095) < 4 then
		    if castSpell("target",_IcyTouch,false) then return; end
	    end

	    -- Plague Strike
	    if (runesUnholy >= 1 or runesDeath >= 1) and getDebuffRemain("target",55078) < 4 then
	    	if castSpell("target",_PlagueStrike,false) then return; end
	    end

	    local numEnnemies = getNumEnnemies("target", 10)

	    -- Pestilence/Rolling Blood - Spread
	    if numEnnemies > 2 and (runesBlood >= 1 or runesDeath >= 1) and (pestiTimer == nil or pestiTimer <= GetTime() - 2) then
			if canCast(PestiSpell) then
				if getDebuffRemain("target",55078,"player") >= 2 then
					for i = 1, #targetEnnemies do
						local Guid = targetEnnemies[i]
						ISetAsUnitID(Guid,"thisUnit");
						if getCreatureType("thisUnit") == true and UnitDebuffID("thisUnit",55078) == nil then
							if castSpell("target",PestiSpell,true) then pestiTimer = GetTime(); return; end								
						end
					end	
				end
			end
	    end

	    -- Heart Strike//Blood Strike
	    if runesBlood > 1 or (runesBlood > 1 and UnitDebuffID("target",55078,"player") ~= nil) then
	    	if isKnown(_HeartStrike) and numEnnemies < 3 then
	    		if castSpell("target",_HeartStrike,false) then return; end
	    	elseif isKnown(_HeartStrike) == false and numEnnemies < 3 then
	    		if castSpell("target",_BloodStrike,false) then return; end
	    	else
	    		if castSpell("player",_BloodBoil,true) then return; end
	    	end
	    end

	    -- Death Strike
	    if (runesFrost >= 1 and runesUnholy >= 1) 
	      or (runesFrost >= 1 and runesDeath >= 1)
	      or (runesDeath >= 1 and runesUnholy >= 1)
	      or (runesDeath >= 2) then
	    	if castSpell("target",_DeathStrike,false) then return; end
	    end
	   
	    -- Blood Boil - Scarlet Fever
	    if targetDistance <= 5 and UnitBuffID("player",81141) ~= nil then
	    	if castSpell("player",_BloodBoil,true) then return; end
	    end

	    -- Icy Touch
	    if runesFrost > 1 then
	    	if castSpell("target",_IcyTouch,false) then return; end
	    end

	    -- Soul Reaper
	    if getHP("target") < 35 then
	    	if castSpell("target",_SoulReaper,false) then return; end
	    end

	    -- Rune Strike//Death Coil
	    if runicPower >= 40 then
		    if isKnown(_RuneStrike) then
		    	if castSpell("target",_RuneStrike,false) then return; end
		    else
		    	if castSpell("target",_DeathCoil,false) then return; end
		    end
		end

	    -- Horn of Winter
	    if UnitBuffID("player",_HornOfWinter) == nil then
	    	if castSpell("player",_HornOfWinter,true) then return; end
	    end

		--ChatOverlay("A L'ATTAQUE");
]]
	end
end
end




