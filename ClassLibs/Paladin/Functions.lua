if select(3,UnitClass("player")) == 2 then

	function Blessings()
		if UnitBuffID("player",144051) ~= nil then return false end
		local BlessingCount = 0
		for i = 1, #nNova do
			local _, MemberClass = select(2,UnitClass(nNova[i].unit))
			if UnitExists(nNova[i].unit) then 
				if MemberClass ~= nil then
					if MemberClass == "DRUID" then BlessingCount = BlessingCount + 1 end                
					if MemberClass == "MONK" then BlessingCount = BlessingCount + 1 end                 
					if MemberClass == "PALADIN" then BlessingCount = BlessingCount + 50 end 
					if MemberClass == "SHAMAN" then BlessingCount = BlessingCount + 1000 end
				end     
			end 
		end 
		if BlessingCount > 50 and BlessingCount < 1000 then
			MyBlessing = _BlessingOfMight
		else
			MyBlessing = _BlessingOfKings
		end
		if ActiveBlessingsValue == 2 then
			MyBlessing = _BlessingOfKings
		elseif ActiveBlessingsValue == 3 then
			MyBlessing = _BlessingOfMight
		end 
		if MyBlessing == _BlessingOfMight and not Spells[_BlessingOfMight].known then MyBlessing = _BlessingOfKings end
		if MyBlessing == _BlessingOfKings and not Spells[_BlessingOfKings].known then BuffTimer = GetTime() + 600 return false end  
		if BuffTimer == nil or BuffTimer < GetTime() then
			for i=1, #nNova do
				if not UnitBuffID(nNova[i].unit,MyBlessing) then
					BuffTimer = GetTime() + random(15,30);
					if castSpell("player",MyBlessing) then return; end
				end
			end 
		end
	end

    function PaladinProtFunctions()
		
		-- Utility functions
		-- Hand of Salvation, Hand of Sacrifice
		-- Blinding Light
		-- Turn Evil
		function ProtPaladinUtility()
		end

	
        function SacredShield()
            local SacredShieldCheck = BadBoy_data["Check Sacred Shield"];
            local SacredShield = BadBoy_data["Box Sacred Shield"];
            if UnitBuffID("player",20925) then SacredShieldTimer = select(7, UnitBuffID("player",20925)) - GetTime() else SacredShieldTimer = 0 end
            if SacredShieldCheck and getHP("player") <= SacredShield then
                if ((isMoving("player") or UnitAffectingCombat("player")) and not UnitBuffID("player",20925)) or (LastVengeance ~= nil and (GetVengeance() > (BadBoy_data["Box Sacred Vengeance"] + LastVengeance))) then
                    LastVengeance = GetVengeance()
                    return true;
                end
                if SacredShieldTimer <= 3 then
                    return true;
                end
            end 
            return false;
        end

        function GetHolyGen()
            local Delay = 0.3;
            if UnitPower("player", 9) <= 4 and getSpellCD(_CrusaderStrike) < Delay or getSpellCD(_Judgment) < Delay or UnitBuffID("player", 85416) then 
                return true;
            else
                return false;
            end
        end
		
		-- Functionality regarding interrupting target(s) spellcasting
		-- Rebuke is used if available and implemented as of now. This could be enhanced to use other spells for interrup
		-- returns of the cast is succesful or not.
		-- ToDos:  Add multiple interrupts such as binding light(if within 10 yards and facing, Fist of Justice(stuns), Avengers shield
		-- Should perhaps move out the spellCD and ranged outside canInterrupt?? So first check if range and cd is ok for cast, then check for timeframe?d
		function ProtPaladinInterrupt()
			--See what spell we want to use
			if isChecked("Rebuke") then
				if canInterrupt(_Rebuke, tonumber(BadBoy_data["Box Rebuke"])) and getDistance("player","target") <= 4 then 
					return castSpell("target",_Rebuke,false);
				end
			end
			-- Should add Avengers Shield
			-- Should add Fist of Justice
			-- Should add Blinding Light with facing logic.
			return false
		end
		
		function ProtPaladinSurvivalSelf() -- Check if we are close to dying and act accoridingly
			local playerHP = getHP("player")
			
			if BadBoy_data["Check ------ Defensive -------"] == 1 then 
				-- Logic goes from lowest HP, ie the most critical prioritised spells
				-- Lay on Hands, we get full health back and is the last resort due to the other spells have damage reduction
				-- However do not cast if Ardent Defender is available or we have the AD buff removing killing blow and heals us to 15%.
				-- Todo, add if the box is checked or not
				-- Todo: Reset values dependent on using defensive CDs, ie dont pop all at once if getting very low.
				-- Todo: Reset values dependent on if single, dungeon(with or without healer), raid, pvp.
				if canCast(_LayOnHands, false, false) and playerHP <= getValue("Lay On Hands Self") and not UnitDebuffID("player",_Forbearance) and not (UnitBuffID("player", _ArdentDefender) or canCast(_ArdentDefender)) then
					if castSpell("player",_LayOnHands,true) then 
						return; 
					end
				end
			
				-- Todo, how should we handle the other defensive CDs, we should lower health threshold if GoaK is up for example
				if BadBoy_data["Check Ardent Defender"] == 1 and canCast(_ArdentDefender) and playerHP <= getValue("Ardent Defender") and not (UnitBuffID("player", _GuardianOfAncientKings) or canCast(_GuardianOfAncientKings))then
					if castSpell("player",_ArdentDefender,true) then 
						return;
					end
				end
			
				-- Divine Protection
				if BadBoy_data["Check Divine Protection"] == 1 and getHP("player") <= BadBoy_data["Box Divine Protection"] then -- Should we check if damage is physical?
					if castSpell("player",_DivineProtection,true) then 
						return; 
					end
				end
				
				-- Guardian of the Ancient Kings
				if BadBoy_data["Check GotAK Prot"] == 1 and getHP("player") <= BadBoy_data["Box GotAK Prot"] then 
					if castSpell("player",_GuardianOfAncientKings,true) then 
						return; 
					end
				end
			end
	
			-- Todos: Add more defensive actions. Pot, trinket, Spells(WoG, Sacred Shield, Hand Of Protection, Hand of Salvation, Flash Of Light if Instant....
		end
		
		-- ProtPaladinSurvivalOther() -- Check if raidmember are close to dying and act accoridingly
		function ProtPaladinSurvivalOther() 
			local _HolyPower = UnitPower("player", 9);
						
			-- Lay on Hands
			-- It should be possible to set this so we only cast it on non tanks, or tanks or all.
			if isChecked("Lay On Hands") and nNova[1].hp <= getValue("Lay On Hands") and canCast(_LayOnHands) and not UnitDebuffID("player",_Forbearance) then
				if castSpell(nNova[1].unit,_LayOnHands,true) then 
					return; 
				end
			end
			
			-- Todo: We should add glyph check or health check
			if isChecked("Hand Of Sacrifice Friend") and nNova[1].hp <= getValue("Hand Of Sacrifice") and canCast(_HandOfSacrifice) then
				if castSpell(nNova[1].unit,_HandOfSacrifice,true) then 
					return; 
				end
			end
			
			-- Todo, we should check if the target actually have threat from someone and is not a tank!.
			-- Could use Event to trigger Salvation when mob focus on someone.
			if isChecked("Hand Of Salvation Friend") and nNova[1].hp <= getValue("Hand Of Salvation Friend") and canCast(_HandOfSalvation) then
				if castSpell(nNova[1].unit,_HandOfSalvation,true) then 
					return; 
				end
			end
		
			-- ToDO: Cast Heal(WoG, Eternal, Sacred, FoL(Selfless Healer)), Cast Taunt, Cast Stun, Cast Hand of Protection 
		end
			
		function ProtPaladinBuffs() -- Make sure that we are buffed, 2 modes, inCombat and Out Of Combat, Blessings, RF, -- ProtPaladinBuffs()
			-- Righteous Fury
			if isChecked("Righteous Fury") then
				if UnitBuffID("player",_RighteousFury)== nil then
					if castSpell("player",_RighteousFury, true) then 
						return; 
					end
				end
			end
			--Blessings Logic here
			
		end
	
		-- Handles Seal logic dependent on situation
		function ProtPaladinSealLogic()
			local seal = getValue("Seal");
			if seal == 1 then 
				if GetShapeshiftForm() ~= 3 then 
					if castSpell("player",_SealOfInsight,true) then 
						return; 
					end
					return false
				end 
			end
			if seal == 2 then 
				if GetShapeshiftForm() ~= 1 then 
					if castSpell("player",_SealOfThruth,true) then 
					end 
				end 
			end
			if seal == 3 then
				if getHP("player") < 50 then 
					if GetShapeshiftForm() ~= 3 then 
						if castSpell("player",_SealOfInsight,true) then 
							return; 
						end
					end 
				elseif getHP("player") > 60 and numberOfTargetsMelee < 3 then 
					if GetShapeshiftForm() ~= 1 then 
						if castSpell("player",_SealOfThruth,true) then 
							return; 
						end 
					end 
				elseif getHP("player") > 60 and GetShapeshiftForm() ~= 2 then 
					if castSpell("player",_SealOfRighteousness,true) then 
						return; 
					end 
				end
			end
		end
			
		-- ProtPaladinDispells() -- Handling the dispelling self and party
		-- ProtPaladinCooldowns() -- Handles the use of offensive Coolsdowns, ProtPaladinSurvival... handles the defensive.
		
		
		
		
		-- Todo: Create logic for when to use it, proccs or whatever
		-- 			Also toggle/configuration for more flexibility, at the moment its on or off
		function ProtPaladinOffensiveCooldowns() -- Handles the usage of offensive CDs if toggled
			-- avenging_wrath
			if isInMelee() and isSelected("Avenging Wrath") then
				if castSpell("player",_AvengingWrath,true) then 
					return; 
				end
			end

			-- holy_avenger,if=talent.holy_avenger.enabled
			-- No logic here, we should use this as either protection or dps boost. Should be part of Defensive CDs
			if isInMelee() and isSelected("Holy Avenger") then
				if castSpell("player",_HolyAvenger,true) then 
					return; 
				end
			end	
		end
	end
	
	function ProtPaladinHolyPowerConsumers() -- Handle the use of HolyPower
		
		if castWordOfGlory("player", 80, 3) then
			return true
		end	
		
		if castShieldOfTheRighteous("target", 5) then
			return true
		end
		--Todo, we could check other targets to use HP on but this should be controlled by config.
	end
	
	function ProtPaladingHolyPowerCreaters() -- Handle the normal rotation
		-- Todos: This is optimised for dps. We should be able to keypress for aoe threat to pick up groups. So Avengers Shield, Lights Hammer, Holy Wrath and consecration to pick up groups.
				-- Suggestion is after isInMelee we do a check if AoE key is pressed then we cast Avenger Shield, Lights Hammer, HolyWrath and consecration and the user can then when he sees consecration he knows that aoe pick up is done.
		-- Todos: Talents, only light hammer is handled, Prism and Sentence is not
		-- Todos: Glyphs, we have no support for the Holy Wrath glyph which should put it higher on priority after Judgement.
		
		local strike = strike; -- We use either Crusader Strike or Hammer of Right dependent on how many unfriendly
		if BadBoy_data["AoE"] == 2 or (BadBoy_data["AoE"] == 3 and numberOfTargetsMelee > 2) or keyPressAoE then  --If Toggle to 2(AoE) or 3(Auto and more then 2 targets, its actually 4 but its just simplier to do aoe
			strike = _HammerOfTheRighteous; 
		else 
			strike = _CrusaderStrike; 
		end

		-- Cast Crusader for Single and Hammer of Right if aoe
		if isInMelee() then
			if castSpell("target",strike,false) then 
				return
			end
		end

		if castJudgement("target") then
			--print("Casting Judgement")
			return true
		end
		
		if castAvengersShield("target") then
			--print("Casting lights Hammer in rotation")
			return true
		end
		-- Todo We could add functionality that cycle all unit to find one that is casting since the Avenger Shield is silencing as well.
		
		
		if castLightsHammer("target") then
			--print("Casting lights Hammer in rotation")
			return true
		end

		if castHammerOfWrath("target") then
			--print("Casting Hammer of Wrath")
			return true
		end
		
		-- Todo: Could use enhanced logic here, cluster of mobs, cluster of damaged friendlies etc
		if castHolyWrath("target") then
			--print("Casting Holy Wrath")
			return true
		end
		-- Todo, we could check number of mobs in melee ranged
		
		if castConsecration() then 
			--print("Casting Consecration")
			return true
		end
		
		-- If we are waiting for CDs we can cast SS
		if castSacredShield(5) then 
				return true
		end
		--Todo Check number of targets in range do Concentration and have it earlier.
	end
	
	function ProtPaladingHolyPowerCreatersAoE() -- Rotation that focus on AoE, should be done to pick up group of adds
		-- Todos: Talents, only light hammer is handled, Prism and Sentence is not
		
		local strike = strike; -- We use either Crusader Strike or Hammer of Right dependent on how many unfriendly
		if BadBoy_data["AoE"] == 2 or (BadBoy_data["AoE"] == 3 and numberOfTargetsMelee > 2) or keyPressAoE then  --If Toggle to 2(AoE) or 3(Auto and more then 2 targets, its actually 4 but its just simplier to do aoe
			strike = _HammerOfTheRighteous; 
		else 
			strike = _CrusaderStrike; 
		end

		-- Cast Crusader for Single and Hammer of Right if aoe
		if isInMelee() then
			if castSpell("target",strike,false) then 
				return
			end
		end

		if castAvengersShield("target") then
			--print("Casting lights Hammer in AoE rotation")
			return true
		end
		-- Todo We could add functionality that cycle all unit to find one that is casting since the Avenger Shield is silencing as well.
		
		if castLightsHammer("target") then
			--print("Casting lights Hammer in AoE rotation")
			return true
		end
		
		if castHolyWrath("target") then
			--print("Casting AoE Holy Wrath")
			return true
		end
		-- Todo, we could check number of mobs in melee ranged

		if castConsecration("target") then 
			--print("Casting AOE Consecration")
			return true
		end
		--Todo Check number of targets in range do Concentration and have it earlier.
	end
end