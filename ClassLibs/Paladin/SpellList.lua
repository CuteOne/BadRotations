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
	_ShieldOfTheRighteous       =   53600
	_SpeedOfLight               =   85499
	_TemplarsVerdict            =   85256
	_TurnEvil                   =   10326       
	_WordOfGlory                =   85673
	
	-- Todo : Check Glyphs(is on us or can we cast it on ground 25 yards
	function castConsecration()
		if canCast(_Consecration) and isInMelee() then 
			if castSpell("target",_Consecration,true) then  -- Why are we using target here?
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
				if castSpell(unit,_AvengersShield,false) then 
					return true
				end	
			end
		end	
		return false
	end
	
	function castJudgement(unit)
		if canCast(_Judgment) and getDistance("player", unit) <= 30 then
			if castSpell(unit,_Judgment,true) then 
				return true
			end
		end
		return false
	end	
	
	function castHammerOfWrath(unit)
		if canCast(_HammerOfWrath) and getLineOfSight("player",unit) and getDistance("player",unit) <= 30 and getHP(unit) <= 20 then
			if castSpell(unit,_HammerOfWrath, false) then 
				return true
			end			
		end
		return false
	end
	
	function castSacredShield(timeleft) -- Parameter is time left on buff
		if not isBuffed("player", _SacredShield, timeleft) then
			if castSpell("player",_SacredShield, false) then
				return true
			end
		end
		return false
	end
end