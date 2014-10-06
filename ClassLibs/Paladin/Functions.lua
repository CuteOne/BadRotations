if select(3,UnitClass("player")) == 2 then
	_ArdentDefender             =   31850
	_AvengersShield             =   31935
	_AvengingWrath              =   31884
	_BeaconOfLight              =   53563
	_Berserking                 =   26297  
	_BlessingOfKings            =   20217
	_BlessingOfMight            =   19740
	_BlindingLight              =   115750
	_BloodFury                  =   20572 
	_Cleanse                    =   4987
	_Consecration               =   26573
	_CrusaderStrike             =   35395
	_Denounce                   =   2812
	_DevotionAura               =   31821
	_DivineFavor                =   31842
	_DivineLight                =   82326
	_DivinePlea                 =   54428
	_DivineProtection           =   498
	_DivineShield               =   642
	_DivineStorm                =   53385
	_EternalFlame               =   114163
	_ExecutionSentence          =   114157
	_Exorcism                   =   879
	_FistOfJustice              =   105593
	_FlashOfLight               =   19750
	_Forbearance				= 	25771
	_HandOfFreedom              =   1044
	_HandOfProtection           =   1022
	_HandOfPurity               =   114039
	_HandOfSacrifice            =   6940
	_HandOfSalvation            =   1038
	_HammerOfJustice            =   853
	_HammerOfTheRighteous       =   53595
	_HammerOfWrath              =   24275
	_HolyAvenger                =   105809
	_HolyLight                  =   635
	_HolyPrism                  =   114165
	_HolyRadiance               =   82327
	_HolyShock                  =   20473
	_HolyWrath                  =   119072
	_GiftOfTheNaaru             =   59542
	_GuardianOfAncientKings     =   86659
	_GuardianOfAncientKingsHoly =   86669
	_GuardianOfAncientKingsRet  =   86698
	_Inquisition                =   84963
	_Judgment                  =   20271
	_LayOnHands                 =   633
	_LightOfDawn                =   85222
	_LightsHammer               =   114158
	_MassExorcism               =   122032
	_MassResurection            =   83968
	_Rebuke                     =   96231
	_Reckoning                  =   62124
	_Redemption                 =   7328
	_RighteousFury              =   25780           
	_Repentance                 =   20066
	_SanctifiedWrath            =   53376
	_SacredShield               =   20925
	_SealOfInsight              =   20165
	_SealOfRighteousness        =   20154
	_SealOfThruth               =   31801
	_SelflessHealer             =   85804
	_ShieldOfTheRighteous       =   53600
	_SpeedOfLight               =   85499
	_TemplarsVerdict            =   85256
	_TurnEvil                   =   10326       
	_WordOfGlory                =   85673

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
		
		function ProtPaladinHolyPowerConsumers() -- Handle the use of HolyPower
			-- We can use Hoy Power on Shield of Right or Word OF Glory(inclduing Sacred Shield and Eternal Flame)
			-- since this are Off GCD we can use them regardless so we return false here 
			-- Use SoR if we have 5 HP and dont need heal and have Eternal Flame/Sacred Shield on us
			-- Cast Eternal Flame/sacred Shield on us if we have more then 3 HP and buffs are ending
			-- Cast Eternal Flame/Word if we are below HP threshold
			-- Cast Eternal Flame/Word if party member is below HP threshold and config set
			
			-- Once you have cast your initial EF, be sure to recast EF with 3 HoPo every ~25 seconds to ensure the HoT does not fall off. 
			--As a general rule, recast it whenever you have 3 HoPo and less than 5 seconds remaining on the HoT. If you need those HoPo for a ShoR for a boss special ability, 
			--then delay the EF or try to juggle things so that you refresh the EF earlier.
			if IsPlayerSpell(_EternalFlame) then
				-- First prio is to keep Eternal Flame HoT on our selfs
				if _HolyPower > 2 and not isBuffed("player", _EternalFlame, 5) then 
					if castSpell("player",_EternalFlame) then 
						return; 
					end
				end
				-- TODO Here we should have EF blankets on prio target such as other tank and one healer or something,
				-- TODO Should be configurable on how many we should blanket, overkill maybe
				if BadBoy_data["healing"] == 3 and _HolyPower > 2 then
					if nNova[1].hp <= getValue("Eternal Flame")  and not isBuffed(nNova[1].unit, _EternalFlame) then --Todos, this is not correct since we are checking us
						if castSpell(nNova[1].unit,_EternalFlame,true) then 
							return; 
						end
					end
				end
			else
				if (getHP("player") <= 80 and _HolyPower > 2) then 
					if castSpell("player",_WordOfGlory,true) then 
						return; 
					end
				elseif BadBoy_data["healing"] == 3 and nNova[1].hp <= 60 then
					if castSpell(nNova[1].unit,_WordOfGlory,true) then 
						return; 
					end
				end
			end
			--Todo we should/could add same logic as eternal flame, shielding tank and priotised group members.
			-- Todo, fix sacred shield, now no config values
			--if isKnown(_SacredShield) then
			--	if isChecked("Sacred Shield") and not isBuffed("player", _SacredShield, 5) then
			--		if castSpell("player",_SacredShield,true) then 
			--			return; 
			--		end
			--	end	
			--end
			
			-- shield_of_the_righteous,if=holy_power>=5|buff.divine_purpose.react|incoming_damage_1500ms>=health.max*0.3
			if canCast(_ShieldOfTheRighteous) and _HolyPower > 4 then 
				if getDistance("player","target") <= 4 then
					if castSpell("target",_ShieldOfTheRighteous,false) then 
						return; 
					end
				end
				--Todo, we could check other targets to use HP on but this should be controlled by config.
			end
		end
		
		function ProtPaladingHolyPowerCreaters() -- Handle the normal rotation
			local strike = strike; -- We use either Crusader Strike or Hammer of Right dependent on how many unfriendly
			if BadBoy_data["AoE"] == 2 or (BadBoy_data["AoE"] == 3 and numberOfTargetsMelee > 2) then  --If Toggle to 2(AoE) or 3(Auto and more then 2 targets, its actually 4 but its just simplier to do aoe
				strike = _HammerOfTheRighteous; 
			else 
				strike = _CrusaderStrike; 
			end
			
			if isInMelee() then
				if castSpell("target",strike,false) then 
					return; 
				end
			end
			
			
			if canCast(_AvengersShield) == true and UnitBuffID("player", 85416) ~= nil then
				if getLineOfSight("player","target") and getDistance("player","target") <= 30 then
					if castSpell("target",_AvengersShield,false) then 
						return; 
					end
				end
			-- Todo We could add functionality that cycle all unit to find one in melee and/or is casting
			-- Removed due to low performance
			end		
		
			if canCast(_Judgment) and getDistance("player","target") <= 30 then
				if castSpell("target",_Judgment,true) then 
					return; 
				end
			end
			-- Todo We could add functionality that cycle all unit to find one in melee
			-- Removed due to low performance
		
			-- avengers_shield
			if canCast(_AvengersShield) == true then
				if getLineOfSight("player","target") and getDistance("player","target") <= 30 then
					if castSpell("target",_AvengersShield,false) then 
						return; 
					end	
				end
			end					 
			-- Todo We could add functionality that cycle all unit to find one in melee and/or is casting
			-- Removed due to low performance
			
			if isSelected("Execution Sentence") then
				if (isDummy("target") or (UnitHealth("target") >= 150*UnitHealthMax("player")/100)) then
					if castSpell("target",_ExecutionSentence,false) then 
						return; 
					end
				end
			end		
		
			-- lights_hammer,if=talent.lights_hammer.enabled
			if isSelected("Light's Hammer") then
				if getGround("target") == true and isMoving("target") == false and UnitExists("target") and (isDummy("target") or getDistance("target","targettarget") <= 5) then
					if castGround("target",_LightsHammer,30) then 
						return; 
					end
				end
			end

			-- hammer_of_wrath
			if canCast(_HammerOfWrath) and getLineOfSight("player","target") and getDistance("player","target") <= 30 and getHP("target") <= 20 then
				if castSpell("target",_HammerOfWrath,false) then 
					return; 
				end			
			end
			-- Todo We could add functionality that cycle all unit to find one in melee that have low HPand/or is casting
			-- Removed due to low performance
			
			-- holy_wrath
			if canCast(_HolyWrath) and isInMelee("target") then --Should check number of targets in melee
				if castSpell("target",_HolyWrath,true) then 
					return; 
				end
			end
			-- consecration,if=target.debuff.flying.down&!ticking
			if canCast(_Consecration) and isInMelee() then --Should check number of targets in melee
				if castSpell("target",_Consecration,true) then 
					return; 
				end	
			end

			-- holy_prism,if=talent.holy_prism.enabled
			-- Cast Holy Prism on youself if you have more then one enemy 15 yards around u.
			--if numberOfTargetsHolyPrismDamage > 1 then
			--	if castSpell("player",_HolyPrism,false) then 
			--		return; 
			--	end
			--else
				--Otherwise cast it on targeta
			--	if castSpell("target",_HolyPrism,false) then 
			--		return; 
			--	end
			--end
		end
		
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
--[[           ]]	--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]	--[[           ]]
--[[]]	   --[[]]	--[[]]					 --[[ ]]
--[[         ]]		--[[           ]]	  	 --[[ ]]
--[[        ]]		--[[]]				  	 --[[ ]]
--[[]]	  --[[]]	--[[           ]]	 	 --[[ ]]		
--[[]]	   --[[]] 	--[[           ]]		 --[[ ]]
end