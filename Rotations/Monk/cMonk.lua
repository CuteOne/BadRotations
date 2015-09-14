-- Inherit from: ../cCharacter.lua
-- All Monk specs inherit from this file
if select(2, UnitClass("player")) == "MONK" then
cMonk = {}

-- Creates Monk with given specialisation
function cMonk:new(spec)
	local self = cCharacter:new("Monk")

	local player = "player" -- if someone forgets ""

	self.profile         	= spec
    self.powerRegen      	= getRegen("player")
	self.buff.duration	 	= {}		-- Buff Durations
	self.buff.remain 	 	= {}		-- Buff Time Remaining
	self.chi 				= {}		-- Chi Information
	self.debuff.duration 	= {}		-- Debuff Durations
	self.debuff.remain 	 	= {}		-- Debuff Time Remaining
	self.monkSpell 			= {

		-- Ability - Crowd Control
		legSweep 						= 119381,
		spearHandStrike 				= 116705,
		paralysis 						= 115078,

        -- Ability - Defensive
        dampenHarm 						= 122278,
        diffuseMagic 					= 122783,
        expelHarm 						= 115072,
        fortifyingBrew 					= 115203,
        nimbleBrew 						= 137562,
        surgingMist 					= 116694,
        zenMeditation 					= 115176,
        zenSphere 						= 124081,

        -- Ability - Forms

        -- Ability - Offensive
        blackoutKick 					= 100784,
        chiBurst 						= 123986,
        chiTorpedo 						= 115008,
        chiWave 						= 115098,
        cracklingJadeLightning 			= 117952,
        jab 							= 100780,
        hurricanStrike 					= 152175,
        invokeXuen 						= 123904,
        legacyOfTheWhiteTiger 			= 116781,
        risingSunKick 					= 107428,
        rushingJadeWind 				= 116847,
        serenity 						= 152173,
        spinningCraneKick				= 101546,
        tigerPalm 						= 100787,
        touchOfDeath 					= 115080,

        -- Ability - Presense

        -- Ability - Utility
        chiBrew 						= 115399,
        detox 							= 115450,
        provoke 						= 115546,
        resuscitate 					= 115178,
        roll 							= 109132,
        tigersLust 						= 116841,

        -- Buff - Defensive
        dampenHarmBuff					= 122278,
        diffuseMacigBuff 				= 122783,
        fortifyingBrewBuff 				= 115203,

        -- Buff - Forms

        -- Buff - Offensive
        comboBreakerBlackoutKickBuff 	= 116768,
        comboBreakerTigerPalmBuff       = 118864,
        legacyOfTheWhiteTigerBuff 		= 116781,
        serenityBuff 					= 152173,
        touchOfDeathBuff 				= 121125,
        tigerPowerBuff 					= 125359,

        -- Buff - Presense

        -- Buff - Utility

        -- Debuff - Offensive
        risingSunKickDebuff 			= 107428,

        -- Debuff - Defensive

        -- Glyphs
        touchOfDeathGlyph 				= 123391,
        zenMeditationGlyph 				= 120477,

        -- Perks

        -- Talents
        celerityTalent 					= 115173,
        chiBrewTalent 					= 115399,
        chiBurstTalent 					= 123986,
        chiTorpedoTalent 				= 115008,
        chiWaveTalent 					= 115098,
        dampenHarmTalent 				= 122278,
        diffuseMagicTalent 				= 122783,
        hurricanStrikeTalent 			= 152175,
        invokeXuenTalent				= 123904,
        legSweepTalent 					= 119381,
        rushingJadeWindTalent 			= 116847,
        serenityTalent					= 152173,
        tigersLustTalent 				= 116841,
        zenSphereTalent 				= 124081,

	}

-- Update 
	function self.classUpdate()
		-- Call baseUpdate()
		self.baseUpdate()
		self.chi.count 	= getChi("player")
		self.chi.max 	= getChiMax("player")
		self.chi.diff 	= getChiMax("player")-getChi("player")
		self.getClassOptions()
		self.getClassBuffs()
		self.getClassBuffsDuration()
		self.getClassBuffsRemain()
		self.getClassCharges()
		self.getClassCooldowns()
		self.getClassDynamicUnits()
		self.getClassDebuffs()
		self.getClassDebuffsDuration()
		self.getClassDebuffsRemain()
		self.getClassRecharge()
	end

-- Update OOC
	function self.classUpdateOOC()
		-- Call baseUpdateOOC()
		self.baseUpdateOOC()
		self.getClassGlyphs()
		self.getClassTalents()
	end

-- Dynamic Units updates
	function self.getClassDynamicUnits()
		local dynamicTarget = dynamicTarget

		self.units.dyn8AoE = dynamicTarget(8, false) 
		self.units.dyn10 = dynamicTarget(10, true)
		self.units.dyn15 = dynamicTarget(15, true)
	end

-- Buff updates
	function self.getClassBuffs()
		local UnitBuffID = UnitBuffID

		-- self.buff.dampenHarm 	 			= UnitBuffID("player",self.spell.dampenHarmBuff)~=nil or false
		-- self.buff.diffuseMagic  			= UnitBuffID("player",self.spell.diffuseMagicBuff)~=nil or false
		self.buff.fortifyingBrew 			= UnitBuffID("player",self.spell.fortifyingBrewBuff)~=nil or false
		self.buff.legacyOfTheWhiteTiger 	= UnitBuffID("player",self.spell.legacyOfTheWhiteTigerBuff)~=nil or false
		self.buff.serenity 					= UnitBuffID("player",self.spell.serenityBuff)~=nil or false
		self.buff.tigerPower 				= UnitBuffID("player",self.spell.tigerPowerBuff)~=nil or false 
		self.buff.touchOfDeath 				= UnitBuffID("player",self.spell.touchOfDeathBuff)~=nil or false
	end	

	function self.getClassBuffsDuration()
		local getBuffDuration = getBuffDuration

		-- self.buff.duration.dampenHarm 				= getBuffDuration("player",self.spell.dampenHarmBuff) or 0
		-- self.buff.duration.diffuseMagic 			= getBuffDuration("player",self.spell.diffuseMagicBuff) or 0
		self.buff.duration.fortifyingBrew 			= getBuffDuration("player",self.spell.fortifyingBrewBuff) or 0
		self.buff.duration.legacyOfTheWhiteTiger 	= getBuffDuration("player",self.spell.legacyOfTheWhiteTigerBuff) or 0		
		self.buff.duration.serenity 				= getBuffDuration("player",self.spell.serenityBuff) or 0		
		self.buff.duration.tigerPower 				= getBuffDuration("player",self.spell.tigerPowerBuff) or 0
		self.buff.duration.touchOfDeath 			= getBuffDuration("player",self.spell.touchOfDeathBuff) or 0
	end

	function self.getClassBuffsRemain()
		local getBuffRemain = getBuffRemain

		-- self.buff.remain.dampenHarm  			= getBuffRemain("player",self.spell.dampenHarmBuff) or 0
		-- self.buff.remain.diffuseMagic 			= getBuffRemain("player",self.spell.diffuseMagicBuff) or 0
		self.buff.remain.fortifyingBrew 		= getBuffRemain("player",self.spell.fortifyingBrewBuff) or 0
		self.buff.remain.legacyOfTheWhiteTiger 	= getBuffRemain("player",self.spell.legacyOfTheWhiteTigerBuff) or 0
		self.buff.remain.serenity 				= getBuffRemain("player",self.spell.serenityBuff) or 0
		self.buff.remain.tigerPower 			= getBuffRemain("player",self.spell.tigerPowerBuff) or 0
		self.buff.remain.touchOfDeath 			= getBuffRemain("player",self.spell.touchOfDeathBuff) or 0
	end

	function self.getClassCharges()
		local getBuffStacks = getBuffStacks
		local getCharges = getCharges

		self.charges.chiBrew 	= getCharges(self.spell.chiBrew)
		self.charges.chiTorpedo = getCharges(self.spell.chiTorpedo)
		self.charges.roll 		= getCharges(self.spell.roll)
	end

-- Cooldown updates
	function self.getClassCooldowns()
		local getSpellCD = getSpellCD

		self.cd.chiBrew 		= getSpellCD(self.spell.chiBrew)
		self.cd.chiBurst 		= getSpellCD(self.spell.chiBurst)
		self.cd.chiTorpedo 		= getSpellCD(self.spell.chiTorpedo)
		self.cd.chiWave 		= getSpellCD(self.spell.chiWave)
		self.cd.dampenHarm 		= getSpellCD(self.spell.dampenHarm)
		self.cd.detox 			= getSpellCD(self.spell.detox) 
		self.cd.diffuseMagic 	= getSpellCD(self.spell.diffuseMagic)
		self.cd.expelHarm 		= getSpellCD(self.spell.expelHarm)
		self.cd.fortifyingBrew 	= getSpellCD(self.spell.fortifyingBrew)
		self.cd.hurricanStrike  = getSpellCD(self.spell.hurricanStrike)
		self.cd.invokeXuen 		= getSpellCD(self.spell.invokeXuen)
		self.cd.legSweep 		= getSpellCD(self.spell.legSweep)
		self.cd.nimbleBrew 		= getSpellCD(self.spell.nimbleBrew)
		self.cd.paralysis 		= getSpellCD(self.spell.paralysis)
		self.cd.provoke 		= getSpellCD(self.spell.provoke)
		self.cd.risingSunKick 	= getSpellCD(self.spell.risingSunKick)
		self.cd.rushingJadeWind = getSpellCD(self.spell.rushingJadeWind)
		self.cd.serenity 		= getSpellCD(self.spell.serenity)
		self.cd.spearHandStrike = getSpellCD(self.spell.spearHandStrike)
		self.cd.tigersLust 		= getSpellCD(self.spell.tigersLust)
		self.cd.touchOfDeath 	= getSpellCD(self.spell.touchOfDeath)
		self.cd.zenMeditation 	= getSpellCD(self.spell.zenMeditation)
		self.cd.zenSphere 		= getSpellCD(self.spell.zenSphere)
	end

-- Debuff updates
	function self.getClassDebuffs()
		local UnitDebuffID = UnitDebuffID

		if self.level<56 then
			self.debuff.risingSunKick = true
		else
			self.debuff.risingSunKick = UnitDebuffID(self.units.dyn5,self.spell.risingSunKickDebuff,"player")~=nil or false
		end
	end

	function self.getClassDebuffsDuration()
		local getDebuffDuration = getDebuffDuration

		if self.level<56 then
			self.debuff.duration.risingSunKick = 99
		else
			self.debuff.duration.risingSunKick = getDebuffDuration(self.units.dyn5,self.spell.risingSunKickDebuff,"player") or 0
		end
	end

	function self.getClassDebuffsRemain()
		local getDebuffRemain = getDebuffRemain

		if self.level<56 then
			self.debuff.remain.risingSunKick = 99
		else
			self.debuff.remain.risingSunKick = getDebuffRemain(self.units.dyn5,self.spell.risingSunKickDebuff,"player") or 0
		end
	end

-- Recharge updates
	function self.getClassRecharge()
		local getRecharge = getRecharge

		self.recharge.chiBrew 	 = getRecharge(self.spell.chiBrew)
		self.recharge.chiTorpedo = getRecharge(self.spell.chiTorpedo)
	end

-- Glyph updates
	function self.getClassGlyphs()
		local hasGlyph = hasGlyph

		self.glyph.touchOfDeath 	= hasGlyph(self.spell.touchOfDeathGlyph)
		self.glyph.zenMeditation 	= hasGlyph(self.spell.zenMeditationGlyph)
	end

-- Talent updates
	function self.getClassTalents()
		local getTalent = getTalent

		self.talent.celerity 		= getTalent(1,1)
		self.talent.tigersLust 		= getTalent(1,2)
		self.talent.chiWave  		= getTalent(2,1)
		self.talent.zenSphere 		= getTalent(2,2)
		self.talent.chiBurst 		= getTalent(2,3)
		self.talent.chiBrew  		= getTalent(3,3)
		self.talent.legSweep 		= getTalent(4,3)
		self.talent.dampenHarm 		= getTalent(5,2)
		self.talent.diffuseMagic 	= getTalent(5,3)
		self.talent.rushingJadeWind = getTalent(6,1)
		self.talent.invokeXuen 		= getTalent(6,2)
		self.talent.chiTorpedo  	= getTalent(6,3)
		self.talent.hurricanStrike 	= getTalent(7,1)
		self.talent.chiExplosion 	= getTalent(7,2)
		self.talent.serenity 		= getTalent(7,3)
	end

-- Get Class option modes
	function self.getClassOptions()
		--self.poisonTimer = getValue("Poison remain")
	end

---------------
--- OPTIONS ---
---------------

	-- Class options
	-- Options which every Monk should have
	function self.createClassOptions()
		-- Create Base Options
		self.createBaseOptions()

		-- Class Wrap
		CreateNewWrap(thisConfig, "--- Class Options ---")

        -- Spacer
		CreateNewText(" ");
	end

------------------------------
--- SPELLS - CROWD CONTROL --- 
------------------------------
	-- Leg Sweep
	function self.castLegSweep(thisUnit)
		if getTalent(4,3) and self.cd.legSweep==0 and getDistance(thisUnit)<5 then
			if castSpell(thisUnit,self.spell.legSweep,false,false,false) then return end
		end
	end
	-- Paralysis
	function self.castParalysis(thisUnit)
		if self.level>=44 and self.cd.paralysis==0 and self.power>20 and getDistance(thisUnit)<20 then
			if castSpell(thisUnit,self.spell.paralysis,false,false,false) then return end
		end
	end
	-- Quaking Palm - Racial
	function self.castQuakingPalm(thisUnit)
		if self.race == "Pandaren" and getSpellCD(self.racial)==0 and getDistance(thisUnit)<5 then
			if castSpell(thisUnit,self.racial,false,false,false) then return end
		end		
	end
	-- Spear Hand Strike
	function self.castSpearHandStrike(thisUnit)
		if self.level>=32 and self.cd.spearHandStrike==0 and getDistance(thisUnit)<5 then
			if castSpell(thisUnit,self.spell.spearHandStrike,false,false,false) then return end
		end
	end

--------------------------
--- SPELLS - DEFENSIVE ---
--------------------------
	-- Dampen Harm
	function self.castDampenHarm()
		if getTalent(5,2) and self.cd.dampenHarm==0 then
			if castSpell("player",self.spell.dampenHarm,false,false,false) then return end
		end
	end
	-- Diffuse Magic
	function self.castDiffuseMagic()
		if getTalent(5,3) and self.cd.diffuseMagic==0 then
			if castSpell("player",self.spell.diffuseMagic,false,false,false) then return end
		end
	end
	-- Expel Harm
	function self.castExpelHarm()
		if self.level>=26 and self.cd.expelHarm==0 and self.power>40 then
			if castSpell("player",self.spell.expelHarm,false,false,false) then return end
		end
	end
	-- Fortifying Brew
	function self.castFortifyingBrew()
		if self.level>=24 and self.cd.fortifyingBrew==0 then
			if castSpell("player",self.spell.fortifyingBrew,false,false,false) then return end
		end
	end
	-- Nimble Brew
	function self.castNimbleBrew()
		if self.level>=30 and self.cd.nimbleBrew==0 then
			if castSpell("player",self.spell.nimbleBrew,false,false,false) then return end
		end
	end
	-- Surging Mist
	function self.castSurgingMist()
		if self.level>=12 and self.power>30 and not isMoving("player") then
			if castSpell("player",self.spell.surgingMist,false,false,false) then return end
		end
	end
	-- Zen Meditation
	function self.castZenMeditation()
		if self.level>=82 and self.cd.zenMeditation==0 and (self.glyph.zenMeditation or (not self.glyph.zenMeditation and not isMoving("player"))) and getDistance(self.units.dyn5)>5 then
			if castSpell("player",self.spell.zenMeditation,false,false,false) then return end
		end
	end
--------------------------
--- SPELLS - OFFENSIVE ---
--------------------------
	-- Blackout Kick
	function self.castBlackoutKick()
		if self.level>=7 and (self.chi.count>=2 or getBuffRemain("player",self.spell.comboBreakerBlackoutKickBuff)>0) and getDistance(self.units.dyn5)<5 then
			if castSpell(self.units.dyn5,self.spell.blackoutKick,false,false,false) then return end
		end
	end
	-- Chi Burst
	function self.castChiBurst()
		if getTalent(2,3) and self.cd.chiBurst==0 and getDistance(self.units.dyn40AoE)<40 then
			if castSpell(self.units.dyn40,self.spell.chiBurst,false,false,false) then return end
		end
	end
	-- Chi Torpedo
	function self.castChiTorpedo()
		if getTalent(6,3) and self.cd.chiTorpedo==0 and self.charges.chiTorpedo>=1 then
			if castSpell("player",self.spell.chiTorpedo,false,false,false) then return end
		end
	end
	-- Chi Wave
	function self.castChiWave()
		if getTalent(2,1) and self.cd.chiWave==0 and getDistance(self.units.dyn40AoE)<40 then
			if castSpell("player",self.spell.chiWave,false,false,false) then return end
		end
	end
	-- Crackling Jade Lightning
	function self.castCracklingJadeLightning()
		if self.level>=54 and self.power>15 and getDistance("target")<40 then
			if castSpell("target",self.spell.cracklingJadeLightning,false,false,false) then return end
		end
	end
	-- Hurricane Strike
	function self.castHurricaneStrike()
		if getTalent(7,1) and self.cd.hurricanStrike==0 and self.chi.count>=3 and getDistance(self.units.dyn10)<10 then
			if castSpell("player",self.spell.hurricanStrike,false,false,false) then return end
		end
	end
	-- Invoke Xuen
	function self.castInvokeXuen()
		if getTalent(6,2) and self.cd.invokeXuen==0 and getDistance(self.units.dyn40AoE)<40 then
			if castSpell(self.units.dyn40AoE,self.spell.invokeXuen,false,false,false) then return end
		end
	end
	-- Jab
	function self.castJab()
		if self.level>=1 and self.power>40 and getDistance(self.units.dyn5)<5 then
			if castSpell(self.units.dyn5,self.spell.jab,false,false,false) then return end
		end
	end
	-- Legacy of the Whie Tiger
	function self.castLegacyOfTheWhiteTiger()
		if self.level>=81 and self.power>20 then
			if castSpell("player",self.spell.legacyOfTheWhiteTiger,false,false,false) then return end
		end
	end
	-- Rising Sun Kick
	function self.castRisingSunKick()
		if self.level>=56 and self.cd.risingSunKick==0 and self.chi.count>=2 and getDistance(self.units.dyn5)<5 then
			if castSpell(self.units.dyn5,self.spell.risingSunKick,false,false,false) then return end
		end
	end
	-- Rushing Jade Wind
	function self.castRushingJadeWind()
		if getTalent(6,1) and cd.rushingJadeWind==0 and self.power>40 then
			if castSpell("player",self.spell.rushingJadeWind,false,false,false) then return end
		end
	end
	-- Serenity
	function self.castSerenity()
		if getTalent(7,3) and self.cd.serenity==0 and getDistance(self.units.dyn5)<5 then
			if castSpell("player",self.spell.serenity,false,false,false) then return end
		end
	end
	-- Spinning Crane Kick
	function self.castSpinningCraneKick()
		if self.level>=46 and self.power>40 and getDistance(self.units.dyn8AoE)<8 then
			if castSpell("player",self.spell.spinningCraneKick,false,false,false) then return end
		end
	end
	-- Tiger Palm
	function self.castTigerPalm()
		if self.level>=3 and (self.chi.count>=1 or getBuffRemain("player",self.spell.comboBreakerTigerPalmBuff)>0) and getDistance(self.units.dyn5)<5 then
			if castSpell(self.units.dyn5,self.spell.tigerPalm,false,false,false) then return end
		end
	end
	-- Touch of Death
	function self.castTouchOfDeath()
		if self.level>=22 and self.cd.touchOfDeath==0 and (self.chi.count>=3 or self.glyph.touchOfDeath) and getDistance(self.units.dyn5)<5 then
			if castSpell(self.units.dyn5,self.spell.touchOfDeath,false,false,false) then return end
		end
	end
	-- Zen Sphere
	function self.castZenSphere(thisUnit)
		if getTalent(2,2) and self.cd.zenSphere==0 then
			if castSpell(thisUnit,self.spell.zenSphere,false,false,false) then return end
		end
	end

------------------------
--- SPELLS - UTILITY ---
------------------------
	-- Chi Brew
	function self.castChiBrew()
		if getTalent(3,3) and self.charges.chiBrew>=1 and getDistance(self.units.dyn5)<5 then
			if castSpell("player",self.spell.chiBrew,false,false,false) then return end
		end
	end
	-- Detox
	function self.castDetox(unit)
		if self.level>=20 and self.cd.detox==0 then
			if castSpell(unit,self.spell.detox,false,false,false) then return end
		end
	end
	-- Provoke
	function self.castProvoke()
		if self.level>=14 and self.cd.provoke==0 and getDistance("target")<30 then
			if castSpell("target",self.spell.provoke,false,false,false) then return end
		end
	end
	-- Resuscitate
	function self.castResuscitate()
		if self.level>=18 and self.power>50 and not self.inCombat and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and getDistance("mouseover")<40 then
			if castSpell("mouseover",self.spell.resuscitate,false,false,false) then return end
		end
	end
	-- Roll
	function self.castRoll()
		if self.level>=5 and self.charges.roll>=1 then
			if castSpell("plater",self.spell.roll,false,false,false) then return end
		end
	end
	-- Tiger's Lust
	function self.castTigersLust()
		if getTalent(1,2) and self.cd.tigersLust==0 then
			if castSpell("player",self.spell.tigersLust,false,false,false) then return end
		end
	end

-- Return
	return self
end

end -- End Select 