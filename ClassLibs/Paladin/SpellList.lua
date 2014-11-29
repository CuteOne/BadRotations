if select(3,UnitClass("player")) == 2 then
	if not initDone then
		_ArcaneTorrent				= 	155145
		_ArdentDefender             =   31850
		_AvengersShield             =   31935
		_AvengingWrath              =   31884
		_BastionOfGlory				=	114637
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
		_DivineProtection           =   498
		_DivinePurposeBuff			= 	90174
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
		_HolyLight                  =   82326
		_HolyPrism                  =   114165
		_HolyRadiance               =   82327
		_HolyShock                  =   20473
		_HolyWrath                  =   119072
		_GiftOfTheNaaru             =   59542
		_GuardianOfAncientKings     =   86659
		_GuardianOfAncientKingsHoly =   86669
		_GuardianOfAncientKingsRet  =   86698
		_Inquisition                =   84963
		_Judgment      	            =   20271
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
		_SelflessHealerBuff			= 	114250
		_ShieldOfTheRighteous       =   53600
		_SpeedOfLight               =   85499
		_TemplarsVerdict            =   85256
		_TurnEvil                   =   10326
		_WordOfGlory                =   85673

		HandOfSacrifaceDebuffs = {} -- Table that holds debuffs we should HoSacrifice
		protectionRemovableDebuffs = {} -- Table that holds debuffs that we should remove with protection spell
		snareToBeRemovedByHandsofFreedom = {
			162066,  -- Freezing Snare, Grim Depot
		}
		initDone = true
	end
	
	function checkForDebuffThatIShouldRemovewithHoF(unit)
		for i = 1, #snareToBeRemovedByHandsofFreedom do
			if UnitDebuffID(unit, snareToBeRemovedByHandsofFreedom[i]) then
				return true
			end
		end

		return false
	end
	
	function castHandOfFreedom(unit)
		if canCast(_HandOfFreedom) then
			if castSpell(unit,_HandOfFreedom,true) then 
				return true
			end
		end
		return false
	end
	-- Todo : Check Glyphs(is on us or can we cast it on ground 25 yards
	function castArcaneTorrent()
		if canCast(_ArcaneTorrent) then
			if castSpell("player",_ArcaneTorrent,true) then 
				return true
			end
		end
		return false
	end

	-- Todo : Check Glyphs(is on us or can we cast it on ground 25 yards
	function castConsecration(unit)
		if canCast(_Consecration) and isInMelee(unit) then
			if castSpell("player",_Consecration,true) then 
				return true
			end
		end
		return false
	end

	--Todo, we can check if the target is not inmelle there could be other targets in melee
	function castHolyWrath(unit)
		if canCast(_HolyWrath) and isInMelee(unit) then
			if castSpell(unit,_HolyWrath,true) then
				return true
			end
		end
		return false
	end

	function castLightsHammer(unit)
		if isChecked("Light's Hammer") then
			if getGround(unit) and not isMoving(unit) and UnitExists(unit) and ((isDummy(unit) or getDistance(unit,"targettarget") <= 5)) then
				if castGround(unit,_LightsHammer,30) then
					return true
				end
			end
		end
		return false
	end

	function castAvengersShield(unit)
		if canCast(_AvengersShield) then
			if getLineOfSight("player",unit) and getDistance("player",unit) <= 30 then
				if castSpell(unit,_AvengersShield,false,false) then
					return true
				end
			end
		end
		return false
	end

	function castJudgement(unit)
		if canCast(_Judgment) and getDistance("player", unit) <= 30 then
			if castSpell(unit,_Judgment,true,false) then
				return true
			end
		end
		return false
	end

	function castHammerOfWrath(unit)
		if canCast(_HammerOfWrath) and getLineOfSight("player",unit) and getDistance("player",unit) <= 30 and getHP(unit) <= 20 then
			if castSpell(unit,_HammerOfWrath,false,false) then
				return true
			end
		end
		return false
	end

	--ToDo :Sacred Shield is affected but Resolve. So we should snapshot resolve and if we are getting X procent more then we should reapply. 340% is max of resolve buff
	function castSacredShield(timeleft) -- Parameter is time left on buff
		local timeleft = timeleft or 0
		if not isBuffed("player", _SacredShield, timeleft) then
			if castSpell("player",_SacredShield,false,false) then
				return true
			end
		end
		return false
	end
	--function SacredShield()
    --       local SacredShieldCheck = BadBoy_data["Check Sacred Shield"];
    --  -      local SacredShield = BadBoy_data["Box Sacred Shield"];
    --        if UnitBuffID("player",20925) then SacredShieldTimer = select(7, UnitBuffID("player",20925)) - GetTime() else SacredShieldTimer = 0 end
    --       if SacredShieldCheck and getHP("player") <= SacredShield then
    --            if ((isMoving("player") or UnitAffectingCombat("player")) and not UnitBuffID("player",20925)) or (LastVengeance ~= nil and (GetVengeance() > (BadBoy_data["Box Sacred Vengeance"] + LastVengeance))) then
    --                LastVengeance = GetVengeance()
    --               return true;
    --            end
    --            if SacredShieldTimer <= 3 then
    --                return true;
    --            end
    --        end
    --        return false;
    --    end
	-- Todo: We should calculate expected heal with resolve to not overheal
	function castWordOfGlory(unit, health, holypower)
		if health == 0 then --Set it to 0 if we should use config set value
			health = getValue("Word Of Glory On Self")
		end

		if getHP(unit) <= health and (_HolyPower > holypower or UnitBuffID("player", _DivinePurposeBuff)) then -- Handle this via config? getHP does it include incoming heals? Bastion of Glory checks?
			if castSpell(unit,_WordOfGlory,true,false) then
				return true
			end
		end
		return false
	end

	function castShieldOfTheRighteous(unit, holypower)
		if canCast(_ShieldOfTheRighteous) and (_HolyPower >= holypower or UnitBuffID("player", _DivinePurposeBuff)) then
			if getDistance("player",unit) <= 4 then
				if castSpell(unit,_ShieldOfTheRighteous,false,false) then
					return true
				end
			end
			--Todo, we could check other targets to use HP on but this should be controlled by config.
		end
		return false
	end

	function castHandOfSacrifice()
	-- Todo: We should add glyph check or health check, at the moment we assume the glyph
	-- Todo:  We should be able to config who to use as candidate, other tank, healer, based on debuffs etc.
	-- Todo: add check if target already have sacrifice buff
	-- Todo Is the talent handle correctly? 2 charges? CD starts but u have 2 charges
	-- This is returning false since its not proper designed yet. We need to have a list of scenarios when we should cast sacrifice, off tanking, dangerous debuffs/dots or high spike damage on someone.
		return false
	end

	-- Todo This need to be enhanced to be much more logical
	function castLayOnHands(unit)
		if not unit then --We are not being told who to cast Lay On Hand on, therefore check lowest HP in party
			if isChecked("Lay On Hands Party") and nNova[1].hp <= getValue("Lay On Hands Party") and canCast(_LayOnHands) and not UnitDebuffID(nNova[1].unit,_Forbearance) then
				if castSpell(nNova[1].unit,_LayOnHands,true,false) then
					return true
				end
			end
		else -- else we think its ourself
			if isChecked("Lay On Hands Self") and getHP("player") <= getValue("Lay On Hands Self") and canCast(_LayOnHands) and not UnitDebuffID("player",_Forbearance) then
				if castSpell(nNova[1].unit,_LayOnHands,true,false) then
					return true
				end
			end
		end
		return false
	end

	-- Todo we are only checking lowest healthm we need to switch to threat
	-- Todo Add buff cehck if target already have the buff
	-- Todo Is the talent handle correctly? 2 charges? CD starts but u have 2 charges
	function castHandOfSalvation(unit)
		-- This is not coded properly yet, we need a threat list to see how has threat, then we need to make sure to handle tank switching etc.
		return false
	end

	function castRebuke(unit)
		castInterupt(_Rebuke, getValue("Rebuke"))
		return false
	end

	function castHammerOfJustice(unit)
		-- We check if we have the talent
		return false
	end

	function castRighteousFury()
		if isChecked("Righteous Fury") then
			if UnitBuffID("player",_RighteousFury)== nil then
				if castSpell("player",_RighteousFury, true, false) then
					return true
				end
			end
		end
		return false
	end
end