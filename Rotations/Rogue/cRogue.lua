-- Inherit from: ../cCharacter.lua
-- All Rogue specs inherit from this file
if select(2, UnitClass("player")) == "ROGUE" then
cRogue = {}

-- Creates Paladin with given specialisation
function cRogue:new(spec)
	local self = cCharacter:new("Rogue")

	local player = "player" -- if someone forgets ""

	self.profile         = spec
	self.comboPoints     = getCombo("player")
	self.lethalPoison    = nil
	self.nonLethalPoison = nil
	self.poisonTimer     = 10
    self.powerRegen      = getRegen("player")
	self.stealth		 = false
	self.buff.duration	 = {}		-- Buff Durations
	self.buff.remain 	 = {}		-- Buff Time Remaining
	self.debuff.duration = {}		-- Debuff Durations
	self.debuff.remain 	 = {}		-- Debuff Time Remaining
	self.rogueSpell = {
		-- Ability - Crowd Control
		blind 					= 2094,
		cheapShot				= 1833,
		distract 				= 1725,
		gouge 					= 1776,
		kidneyShot 				= 408,
		sap 					= 6770,

        -- Ability - Defensive
        cloakOfShadows 			= 31224,
        combatReadiness			= 74001,
        evasion 				= 5277,
        feint 					= 1966,
        kick 					= 1766,
        leechingPoison          = 108211,
        recuperate 				= 73651,
        smokeBomb 				= 76577,
        vanish 					= 1856,

        -- Ability - Forms

        -- Ability - Offensive
        ambush 					= 8676,
        crimsonTempest   		= 121411,
        deadlyPoison 			= 2823,
        deathFromAbove 			= 152150,
        eviscerate 				= 2098,
        fanOfKnives 			= 51723,
        garrote 				= 703,
        rupture 				= 1943,
        shadowReflection 		= 152151,
        shurikenToss 			= 114014,
        sinisterStrike			= 1752,
        sliceAndDice 			= 5171,
        throw 					= 121733,
        woundPoison 			= 8679,
        

        -- Ability - Utility
        burstOfSpeed 			= 108212,
        cripplingPoison 		= 3408,
        deadlyThrow 			= 26679,
        markedForDeath 			= 137619,
        pickLock 				= 1804,
        pickPocket 				= 921,
        preparation 			= 14185,
        shadowStep 				= 36554,
        shiv 					= 5938,
        sprint 					= 2983,
        stealth 				= 1784 or 115191,
        tricksOfTheTrade 		= 57934,

        -- Buff - Defensive
        cloakOfShadowsBuff		= 31224,
        combatReadinessBuff 	= 74001,
        cripplingPoisonBuff 	= 3408,
        evasionBuff				= 5277,
        feintDebuff 			= 1966,
        leechingPoisonBuff 		= 108211,
        recuperateBuff      	= 73651,
        woundPoisonBuff 		= 8679,

        -- Buff - Forms

        -- Buff - Offensive
        deadlyPoisonBuff 		= 2823,
        sliceAndDiceBuff		= 5171,

        -- Buff - Utility
        anticipationBuff        = 115189,
        detectTrapsBuff			= 2836,
        markedForDeathBuff 		= 137619,
        shadowStepBuff 			= 36554,
        sprintBuff 				= 2983,
        stealthBuff				= 1784 or 115191,
        tricksOfTheTradeBuff 	= 57934,
        vanishBuff				= 11327,

        -- Debuff - Offensive
        crimsonTempestDebuff 	= 121411,
        deadlyPoisonDebuff		= 2823,
        garroteDebuff 			= 703,
        internalBleedingDebuff 	= 154953,
        ruptureDebuff 			= 1943,

        -- Debuff - Defensive
        blindDebuff				= 2094,
        cheapShotDebuff 		= 1833,
        cripplingPoisonDebuff 	= 3409,
        deadlyThrowDebuff 		= 26679,
        gougeDebuff 			= 1776,
        kidneyShotDebuff 		= 408,
        sapDebuff				= 6770,
        woundPoisonDebuff 		= 8680,

        -- Glyphs
        disappearanceGlyph 		= 159638,
        pickPocketGlyph 		= 58017,

        -- Perks

        -- Talents
        anticipationTalent 		= 114015,
        burstOfSpeedTalent 		= 108212,
        cloakAndDaggerTalent 	= 138106,
        combatReadinessTalent 	= 74001,
        deadlyThrowTalent 		= 26679,
        deathFromAboveTalent 	= 152150,
        dirtyTricksTalent 		= 108216,
        elusivenessTalent		= 79008,
        internalBleedingTalent 	= 154904,
        leechingPoisonTalent 	= 108211,
        markedForDeathTalent    = 137619,
        shadowReflectionTalent 	= 152151,
        shadowStepTalent 		= 36554,
        shurikenTossTalent		= 114014,
        venomRushTalent 		= 152152,
	}

-- Update 
	function self.classUpdate()
		-- Call baseUpdate()
		self.baseUpdate()
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

		-- Update Combo Points
		self.comboPoints = GetComboPoints("player")

        -- Update Energy Regeneration
        self.powerRegen  = getRegen("player")

		-- Stealth
		self.stealth = GetShapeshiftForm() == 1
	end

-- Update OOC
	function self.classUpdateOOC()
		-- Call baseUpdateOOC()
		self.baseUpdateOOC()
		self.getClassGlyphs()
		self.getClassTalents()

		-- Apply Poison
		self.applyPoison()
	end

-- Dynamic Units updates
	function self.getClassDynamicUnits()
		local dynamicTarget = dynamicTarget

		self.units.dyn10 = dynamicTarget(10, true)
		self.units.dyn15 = dynamicTarget(15, true)
	end

-- Buff updates
	function self.getClassBuffs()
		local UnitBuffID = UnitBuffID

		self.buff.anticipation 	   = UnitBuffID("player",self.spell.anticipationBuff)~=nil or false
		self.buff.cloakOfShadows   = UnitBuffID("player",self.spell.cloakOfShadowsBuff)~=nil or false
		self.buff.combatReadiness  = UnitBuffID("player",self.spell.combatReadinessBuff)~=nil or false
		self.buff.cripplingPoison  = UnitBuffID("player",self.spell.cripplingPoisonBuff)~=nil or false
		self.buff.deadlyPoison     = UnitBuffID("player",self.spell.deadlyPoisonBuff)~=nil or false
		self.buff.evasion          = UnitBuffID("player",self.spell.evasionBuff)~=nil or false
		self.buff.leechingPoison   = UnitBuffID("player",self.spell.leechingPoisonBuff)~=nil or false
		self.buff.recuperate       = UnitBuffID("player",self.spell.recuperateBuff)~=nil or false
		self.buff.shadowStep       = UnitBuffID("player",self.spell.shadowStepBuff)~=nil or false
		self.buff.sliceAndDice     = UnitBuffID("player",self.spell.sliceAndDiceBuff)~=nil or false
		self.buff.sprint           = UnitBuffID("player",self.spell.sprintBuff)~=nil or false
		self.buff.stealth 		   = UnitBuffID("player",self.spell.stealthBuff)~=nil or false
		self.buff.tricksOfTheTrade = UnitBuffID("player",self.spell.tricksOfTheTradeBuff)~=nil or false
		self.buff.vanish           = UnitBuffID("player",self.spell.vanishBuff)~=nil or false
		self.buff.woundPoison	   = UnitBuffID("player",self.spell.woundPoisonBuff)~=nil or false
	end	

	function self.getClassBuffsDuration()
		local getBuffDuration = getBuffDuration

		self.buff.duration.cloakOfShadows   = getBuffDuration("player",self.spell.cloakOfShadowsBuff) or 0
		self.buff.duration.combatReadiness  = getBuffDuration("player",self.spell.combatReadinessBuff) or 0
		self.buff.duration.cripplingPoison  = getBuffDuration("player",self.spell.cripplingPoisonBuff) or 0
		self.buff.duration.deadlyPoison     = getBuffDuration("player",self.spell.deadlyPoisonBuff) or 0
		self.buff.duration.evasion          = getBuffDuration("player",self.spell.evasionBuff) or 0
		self.buff.duration.leechingPoison   = getBuffDuration("player",self.spell.leechingPoisonBuff) or 0
		self.buff.duration.recuperate       = getBuffDuration("player",self.spell.recuperateBuff) or 0
		self.buff.duration.shadowStep       = getBuffDuration("player",self.spell.shadowStepBuff) or 0
		self.buff.duration.sliceAndDice     = getBuffDuration("player",self.spell.sliceAndDiceBuff) or 0
		self.buff.duration.sprint           = getBuffDuration("player",self.spell.sprintBuff) or 0
		self.buff.duration.tricksOfTheTrade = getBuffDuration("player",self.spell.tricksOfTheTradeBuff) or 0
		self.buff.duration.vanish           = getBuffDuration("player",self.spell.vanishBuff) or 0
		self.buff.duration.woundPoison	    = getBuffDuration("player",self.spell.woundPoisonBuff) or 0
	end

	function self.getClassBuffsRemain()
		local getBuffRemain = getBuffRemain

		self.buff.remain.cloakOfShadows   = getBuffRemain("player",self.spell.cloakOfShadowsBuff) or 0
		self.buff.remain.combatReadiness  = getBuffRemain("player",self.spell.combatReadinessBuff) or 0
		self.buff.remain.cripplingPoison  = getBuffRemain("player",self.spell.cripplingPoisonBuff) or 0
		self.buff.remain.deadlyPoison     = getBuffRemain("player",self.spell.deadlyPoisonBuff) or 0
		self.buff.remain.evasion          = getBuffRemain("player",self.spell.evasionBuff) or 0
		self.buff.remain.leechingPoison   = getBuffRemain("player",self.spell.leechingPoisonBuff) or 0
		self.buff.remain.recuperate       = getBuffRemain("player",self.spell.recuperateBuff) or 0
		self.buff.remain.shadowStep       = getBuffRemain("player",self.spell.shadowStepBuff) or 0
		self.buff.remain.sliceAndDice     = getBuffRemain("player",self.spell.sliceAndDiceBuff) or 0
		self.buff.remain.sprint           = getBuffRemain("player",self.spell.sprintBuff) or 0
		self.buff.remain.tricksOfTheTrade = getBuffRemain("player",self.spell.tricksOfTheTradeBuff) or 0
		self.buff.remain.vanish           = getBuffRemain("player",self.spell.vanishBuff) or 0
		self.buff.remain.woundPoison	  = getBuffRemain("player",self.spell.woundPoisonBuff) or 0
	end

	function self.getClassCharges()
		local getBuffStacks = getBuffStacks

		self.charges.anticipation = getBuffStacks("player",self.spell.anticipationBuff,"player")
	end

-- Cooldown updates
	function self.getClassCooldowns()
		local getSpellCD = getSpellCD

		self.cd.blind 			 = getSpellCD(self.spell.blind)
		self.cd.burstOfSpeed 	 = getSpellCD(self.spell.burstOfSpeed)
		self.cd.cloakOfShadows   = getSpellCD(self.spell.cloakOfShadows)
		self.cd.combatReadiness  = getSpellCD(self.spell.combatReadiness)
		self.cd.deathFromAbove   = getSpellCD(self.spell.deathFromAbove)
		self.cd.distract 		 = getSpellCD(self.spell.distract)
		self.cd.evasion          = getSpellCD(self.spell.evasion)
		self.cd.gouge 			 = getSpellCD(self.spell.gouge)
		self.cd.kick			 = getSpellCD(self.spell.kick)
		self.cd.kidneyShot 		 = getSpellCD(self.spell.kidneyShot)
		self.cd.markedForDeath   = getSpellCD(self.spell.markedForDeath)
		self.cd.pickPocket 		 = getSpellCD(self.spell.pickPocket)
		self.cd.preparation      = getSpellCD(self.spell.preparation)
		self.cd.shadowReflection = getSpellCD(self.spell.shadowReflection)
		self.cd.shadowStep 		 = getSpellCD(self.spell.shadowStep)
		self.cd.shiv 			 = getSpellCD(self.spell.shiv)
		self.cd.smokeBomb 		 = getSpellCD(self.spell.smokeBomb)
		self.cd.sprint           = getSpellCD(self.spell.sprint)
		self.cd.stealth          = getSpellCD(self.spell.stealth)
		self.cd.tricksOfTheTrade = getSpellCD(self.spell.tricksOfTheTrade)
		self.cd.vanish           = getSpellCD(self.spell.vanish)
	end

-- Debuff updates
	function self.getClassDebuffs()
		local UnitDebuffID = UnitDebuffID

		self.debuff.blind 				= UnitDebuffID(self.units.dyn15,self.spell.blindDebuff,"player")~=nil or false
		self.debuff.cheapShot 			= UnitDebuffID(self.units.dyn5,self.spell.cheapShotDebuff,"player")~=nil or false
		self.debuff.crimsonTempest 		= UnitDebuffID(self.units.dyn5,self.spell.crimsonTempestDebuff,"player")~=nil or false
		self.debuff.cripplingPoison 	= UnitDebuffID(self.units.dyn5,self.spell.cripplingPoisonDebuff,"player")~=nil or false
		self.debuff.deadlyPoison    	= UnitDebuffID(self.units.dyn5,self.spell.deadlyPoisonDebuff,"player")~=nil or false
		self.debuff.deadlyThrow 		= UnitDebuffID(self.units.dyn30,self.spell.deadlyThrowDebuff,"player")~=nil or false
		self.debuff.garrote 			= UnitDebuffID(self.units.dyn5,self.spell.garroteDebuff,"player")~=nil or false
		self.debuff.gouge 				= UnitDebuffID(self.units.dyn5,self.spell.gougeDebuff,"player")~=nil or false
		self.debuff.kidneyShot 			= UnitDebuffID(self.units.dyn5,self.spell.kidneyShotDebuff,"player")~=nil or false
		self.debuff.internalBleeding 	= UnitDebuffID(self.units.dyn5,self.spell.internalBleedingDebuff,"player")~=nil or false		
		self.debuff.rupture 			= UnitDebuffID(self.units.dyn5,self.spell.ruptureDebuff,"player")~=nil or false
		self.debuff.sap 				= UnitDebuffID(self.units.dyn5,self.spell.sapDebuff,"player")~=nil or false
		self.debuff.woundPoison 		= UnitDebuffID(self.units.dyn5,self.spell.woundPoisonDebuff,"player")~=nil or false
	end

	function self.getClassDebuffsDuration()
		local getDebuffDuration = getDebuffDuration

		self.debuff.duration.blind 				= getDebuffDuration(self.units.dyn15,self.spell.blindDebuff,"player") or 0
		self.debuff.duration.cheapShot 			= getDebuffDuration(self.units.dyn5,self.spell.cheapShotDebuff,"player") or 0
		self.debuff.duration.crimsonTempest 	= getDebuffDuration(self.units.dyn5,self.spell.crimsonTempestDebuff,"player") or 0
		self.debuff.duration.cripplingPoison 	= getDebuffDuration(self.units.dyn5,self.spell.cripplingPoisonDebuff,"player") or 0
		self.debuff.duration.deadlyPoison    	= getDebuffDuration(self.units.dyn5,self.spell.deadlyPoison,"player") or 0
		self.debuff.duration.deadlyThrow 		= getDebuffDuration(self.units.dyn30,self.spell.deadlyThrowDebuff,"player") or 0
		self.debuff.duration.garrote 			= getDebuffDuration(self.units.dyn5,self.spell.garroteDebuff,"player") or 0
		self.debuff.duration.gouge 				= getDebuffDuration(self.units.dyn5,self.spell.gougeDebuff,"player") or 0
		self.debuff.duration.kidneyShot 		= getDebuffDuration(self.units.dyn5,self.spell.kidneyShotDebuff,"player")  or 0
		self.debuff.duration.internalBleeding	= getDebuffDuration(self.units.dyn5,self.spell.internalBleedingDebuff,"player")  or 0	
		self.debuff.duration.rupture 			= getDebuffDuration(self.units.dyn5,self.spell.ruptureDebuff,"player") or 0
		self.debuff.duration.sap				= getDebuffDuration(self.units.dyn5,self.spell.sapDebuff,"player") or 0
		self.debuff.duration.woundPoison 		= getDebuffDuration(self.units.dyn5,self.spell.woundPoisonDebuff,"player") or 0		
	end

	function self.getClassDebuffsRemain()
		local getDebuffRemain = getDebuffRemain

		self.debuff.remain.blind 			= getDebuffRemain(self.units.dyn15,self.spell.blindDebuff,"player") or 0
		self.debuff.remain.cheapShot 		= getDebuffRemain(self.units.dyn5,self.spell.cheapShotDebuff,"player") or 0
		self.debuff.remain.crimsonTempest 	= getDebuffRemain(self.units.dyn5,self.spell.crimsonTempestDebuff,"player") or 0
		self.debuff.remain.cripplingPoison 	= getDebuffRemain(self.units.dyn5,self.spell.cripplingPoisonDebuff,"player") or 0
		self.debuff.remain.deadlyPoison     = getDebuffRemain(self.units.dyn5,self.spell.deadlyPoisonDebuff,"player") or 0
		self.debuff.remain.deadlyThrow 		= getDebuffRemain(self.units.dyn30,self.spell.deadlyThrowDebuff,"player") or 0
		self.debuff.remain.garrote 			= getDebuffRemain(self.units.dyn5,self.spell.garroteDebuff,"player") or 0
		self.debuff.remain.gouge 			= getDebuffRemain(self.units.dyn5,self.spell.gougeDebuff,"player") or 0
		self.debuff.remain.kidneyShot 		= getDebuffRemain(self.units.dyn5,self.spell.kidneyShotDebuff,"player") or 0 	
		self.debuff.remain.internalBleeding	= getDebuffRemain(self.units.dyn5,self.spell.internalBleedingDebuff,"player")  or 0
		self.debuff.remain.rupture 			= getDebuffRemain(self.units.dyn5,self.spell.ruptureDebuff,"player") or 0
		self.debuff.remain.sap 				= getDebuffRemain(self.units.dyn5,self.spell.sapDebuff,"player") or 0
		self.debuff.remain.woundPoison 		= getDebuffRemain(self.units.dyn5,self.spell.woundPoisonDebuff,"player") or 0		
	end

-- Glyph updates
	function self.getClassGlyphs()
		local hasGlyph = hasGlyph

		self.glyph.disappearance 	= hasGlyph(self.spell.disappearanceGlyph)
		self.glyph.pickPocket   	= hasGlyph(self.spell.pickPocketGlyph)
	end

-- Talent updates
	function self.getClassTalents()
		local getTalent = getTalent

		self.talent.deadlyThrow 	 = getTalent(2,1)
		self.talent.combatReadiness  = getTalent(2,3)
		self.talent.leechingPoison 	 = getTalent(3,2)
		self.talent.elusiveness		 = getTalent(3,3)
		self.talent.cloakAndDagger 	 = getTalent(4,1)
		self.talent.shadowStep 		 = getTalent(4,2)
		self.talent.burstOfSpeed 	 = getTalent(4,3)
		self.talent.internalBleeding = getTalent(5,2)
		self.talent.dirtyTricks 	 = getTalent(5,3)
		self.talent.shurikenToss 	 = getTalent(6,1)
		self.talent.markedForDeath   = getTalent(6,2)
		self.talent.anticipation     = getTalent(6,3)
		self.talent.venomRush 		 = getTalent(7,1)
		self.talent.shadowReflection = getTalent(7,2)
		self.talent.deathFromAbove   = getTalent(7,3)
	end

-- Get Class option modes
	function self.getClassOptions()
		self.poisonTimer = getValue("Poison remain")
	end

-- Applies Poison
	function self.applyPoison()
		local getValue = getValue

		-------------------
		--- INFORMATION ---
		--------------------------------------------------------------------
		--- Everybody has Wound Poison hence its always Value 1          ---
		--- If its not selected Deadly will be used (instant for combat) ---
		--- Everybody has Crippling Poison hence its always Value != 2   ---
		--- If its not selected Leeching will be used                    ---
		--------------------------------------------------------------------

		-- Lethal
		self.lethalPoison    = getValue("Lethal")
		if self.lethalPoison == 1 then
			self.lethalPoison = self.spell.woundPoison
		else
			if self.profile == "Combat" then
				self.lethalPoison = self.spell.instantPoison
			else 
				self.lethalPoison = self.spell.deadlyPoison
			end
		end
		self.applyLethalPoison(self.lethalPoison)

		-- Non Lethal
		self.nonLethalPoison = getValue("Non-Lethal")
		if self.nonLethalPoison == 2 then
			self.nonLethalPoison = self.spell.leechingPoison
		else
			self.nonLethalPoison = self.spell.cripplingPoison
		end
		self.applyNonLethalPoison(self.nonLethalPoison)
	end

-- Applies LETHAL Posion
	function self.applyLethalPoison(lethalPoison)
		if isChecked("Lethal") and getBuffRemain("player",lethalPoison) < (self.poisonTimer*60) and not isMoving("player") and not castingUnit("player") and not IsMounted() then
			if lethalPoison == self.spell.instantPoison then lethalPoison = self.spell.deadlyPoison end
			if castSpell("player",lethalPoison,true,true) then return end
		end
	end

-- Applies NON-LETHAL Posion
	function self.applyNonLethalPoison(nonLethalPoison)
		if isChecked("Non-Lethal") and getBuffRemain("player",nonLethalPoison) < (self.poisonTimer*60) and not isMoving("player") and not castingUnit("player") and not IsMounted() then
			if castSpell("player",nonLethalPoison,true,true) then return end
		end
	end

-- Crimson Tempest Debuff
	function self.getCrimsonTempestDebuff()
		return getDebuffRemain("target",self.spell.crimsonTempest)
	end 

---------------
--- OPTIONS ---
---------------

	-- Class options
	-- Options which every Rogue should have
	function self.createClassOptions()
		-- Create Base Options
		self.createBaseOptions()

		-- Class Wrap
		CreateNewWrap(thisConfig, "--- Class Options ---")

		-- Leathal Poison
		CreateNewCheck(thisConfig, "Lethal");
		CreateNewDrop(thisConfig, "Lethal",1,"Lethal Poison.","|cffFF8000Wound","|cff13A300Instant");
		CreateNewText(thisConfig, "Lethal");

		-- Non-Leathal Poison
		CreateNewCheck(thisConfig, "Non-Lethal");
		CreateNewDrop(thisConfig, "Non-Lethal",1,"Non-Lethal Poison.","|cff6600FFCrip","|cff00CF1CLeech");
		CreateNewText(thisConfig, "Non-Lethal");

		-- Poison re-apply timer
		-- Use poison if X minutes remain
		CreateNewBox(thisConfig,"Poison remain",5,50,1,10,"How many minutes left until reapply?")
		CreateNewText(thisConfig, "Poison remain");

		-- Spacer
		CreateNewText(" ");
	end

------------------------------
--- SPELLS - CROWD CONTROL --- 
------------------------------
	-- Blind
	function self.castBlind(thisUnit)
		local thisUnit = thisUnit or "target"
		if self.cd.blind==0 and self.power>15 and self.level>=38 and ObjectExists(thisUnit) then
			return castSpell(thisUnit,self.spell.blind,true,false,false) == true or false
		end
	end

	-- Cheap Shot
	function self.castCheapShot()
		if self.power>40 and self.stealth and self.level>=30 and ObjectExists("target") then
			return castSpell("target",self.spell.cheapShot,false,false,false,false,false,true) == true or false
		end
	end

	-- Distract
	function self.castDistract()
		if self.cd.distract==0 and self.power>30 and self.level>=28 and ObjectExists(self.units.dyn30) then
			return castSpell(self.units.dyn30,self.spell.distract,true,false,false) == true or false
		end
	end

	-- Gouge
	function self.castGouge(thisUnit)
		local thisUnit = thisUnit or "target"
		if self.cd.gouge==0 and self.power>45 and self.level>=22 and ObjectExists(thisUnit) then
			return castSpell(thisUnit,self.spell.gouge,true,false,false) == true or false
		end
	end

	-- Kidney Shot
	function self.castKidneyShot(thisUnit)
		local thisUnit = thisUnit or "target"
		if self.cd.kidneyShot==0 and self.power>25 and self.level>=40 and ObjectExists(thisUnit) then
			return castSpell(thisUnit,self.spell.kidneyShot,true,false,false) == true or false
		end
	end

	-- Sap
	function self.castSap(thisUnit)
		local thisUnit = thisUnit or "target"
		if self.power>35 and self.level>=12 and self.stealth and ObjectExists(thisUnit) then
			return castSpell(thisUnit,self.spell.sap,true,false,false) == true or false
		end
	end

--------------------------
--- SPELLS - DEFENSIVE ---
--------------------------
	-- Cloak of Shadows
	function self.castCloakOfShadows()
		if self.cd.cloakOfShadows==0 and self.level>=58 then
			return castSpell("player",self.spell.cloakOfShadows,true,false,false) == true or false
		end
	end

	-- Combat Readiness
	function self.castCombatReadiness()
		if self.talent.combatReadiness and self.cd.combatReadiness==0 and self.level>=30 then
			return castSpell("player",self.spell.combatReadiness,true,false,false) == true or false
		end
	end

	-- Evasion
	function self.castEvasion()
		if self.cd.evasion==0 and self.level>=8 then
			return castSpell("player",self.spell.evasion,true,false,false) == true or false
		end
	end

	-- Feint
	function self.castFeint()
		if self.power>40 and self.level>=44 then
			return castSpell("player",self.spell.evasion,true,false,false) == true or false
		end
	end

	-- Kick
	function self.castKick(thisUnit)
		local thisUnit = thisUnit or "target"
		if self.cd.kick==0 and self.power>25 and self.level>=40 and ObjectExists(thisUnit) then
			return castSpell(thisUnit,self.spell.kick,false,false,false) == true or false
		end
	end

	-- Recuperate
	function self.castRecuperate()
		if self.power>30 and self.level>=16 and self.comboPoints>0 then
			return castSpell("player",self.spell.recuperate) == true or false
		end
	end

	-- Smoke Bomb
	function self.castSmokeBomb()
		if self.cd.smokeBomb==0 and self.level>=85 then
			return castSpell("player",self.spell.smokeBomb,true,false,false) == true or false
		end
	end

	-- Vanish
	function self.castVanish()
		if self.cd.vanish==0 and self.level>=34 then
			if castSpell("player",self.spell.vanish,true,false,false) then StopAttack(); return end
		end
	end

--------------------------
--- SPELLS - OFFENSIVE ---
--------------------------
	-- Ambush
	function self.castAmbush()
		if self.stealth and self.power>60 and self.level>=6 then
			return castSpell("target",self.spell.ambush,false,false,false,false,false,true) == true or false
		end
	end

	-- Crimson Tempest
	function self.castCrimsonTempest()
		if self.power>35 and self.level>=83 and self.comboPoints>=5 and ObjectExists(self.units.dyn5) then
			return castSpell("player",self.spell.crimsonTempest,true,false) == true or false
		end
	end

	-- Death From Above
	function self.castDeathFromAbove()
		if self.talent.deathFromAbove and self.cd.deathFromAbove==0 and self.power>50 and self.level>=100 and ObjectExists(self.units.dyn15) then
			return castSpell(self.units.dyn15,self.spell.deathFromAbove,true,false,false) == true or false
		end
	end

	-- Eviscerate
	function self.castEviscerate()
		if self.power>35 and self.level>=3 and ObjectExists(self.units.dyn5) then
			return castSpell(self.units.dyn5,self.spell.eviscerate,true,false,false) == true or false
		end
	end

	-- Fan of Knives
	function self.castFanOfKnives()
		if self.power>35 and self.level>=66 then
			return castSpell("player",self.spell.fanOfKnives,true,false,false) == true or false
		end
	end

	-- Garrote
	function self.castGarrote()
		if self.power>40 and self.stealth and self.level>=48 and ObjectExists(self.units.dyn5) then
			return castSpell(self.units.dyn5,self.spell.garrote,true,false,false) == true or false
		end
	end

    -- Rupture - used in simC
    function self.castRupture()
        return castSpell(self.units.dyn5, self.spell.rupture, false, false) == true or false
    end

    -- Rupture Cycle - used in simC
    function self.castRuptureCycle()
        for i = 1, #enemiesTable do
            if enemiesTable[i].distance < 5 then
                local thisUnit = enemiesTable[i].unit
                local ruptureRemain   = getDebuffRemain(thisUnit,self.spell.rupture,"player")
                local ruptureDuration = getDebuffDuration(thisUnit, self.spell.rupture, "player")
                if ruptureRemain <= ruptureDuration*0.3 then
                    return castSpell(thisUnit, self.spell.rupture,false,false,false) == true or false
                end
            end
        end
    end

    -- Rupture
    function self.castRupture(thisUnit)
    	local thisUnit = thisUnit or "target"
    	if self.power>25 and self.level>=46 and self.comboPoints>0 and ObjectExists(thisUnit) then
    		return castSpell(thisUnit,self.spell.rupture,true,false,false) == true or false
    	end
    end

    -- Shadow Reflection
	function self.castShadowReflection()
		if self.talent.shadowReflection and self.cd.shadowReflection==0 and self.level>=100 and ObjectExists(self.units.dyn20AoE) and (isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 4 * UnitHealthMax("player"))) then
			return castSpell(self.units.dyn20AoE,self.spell.shadowReflection,false,false) == true or false
		end
	end
	
	-- Shuriken Toss
	function self.castShurikenToss()
		if self.talent.shurikenToss and self.power>40 and ObjectExists(self.units.dyn30) then
			return castSpell(self.units.dyn30,self.spell.shurikenToss,true,false,false) == true or false
		end
	end

	-- Sinister Strike
	function self.castSinisterStrike()
		if self.power>=50 and ObjectExists(self.units.dyn5) then
			return castSpell(self.units.dyn5,self.spell.sinisterStrike,true,false,false) == true or false
		end
	end

	-- Slice and Dice
	function self.castSliceAndDice()
		if self.power>25 and self.level>=25 and self.comboPoints>0 then
			return castSpell("player",self.spell.sliceAndDice,true,false) == true or false
		end
	end

	-- Throw
	function self.castThrow()
		if ObjectExists(self.units.dyn30) then
			return castSpell(self.units.dyn30,self.spell.throw,true,false,false) == true or false
		end
	end

------------------------
--- SPELLS - UTILITY ---
------------------------

	-- Burst of Speed
	function self.castBurstOfSpeed()
		if self.talent.burstOfSpeed and self.cd.burstOfSpeed==0 and self.power>30 and self.level>=60 then
			return castSpell("player",self.spell.burstOfSpeed,true,false,false) == true or false
		end
	end 

	-- Deadly Throw
	function self.castDeadlyThrow()
		if self.talent.deadlyThrow and self.power>35 and self.level>=35 and ObjectExists(self.units.dyn30) then
			return castSpell(self.units.dyn30,self.spell.deadlyThrow,true,false,false) == true or false
		end
	end

	-- Marked for Death
	function self.castMarkedForDeath()
		if self.talent.markedForDeath and self.cd.markedForDeath==0 and self.comboPoints<0 and ObjectExists(self.units.dyn30AoE) then
			return castSpell(self.units.dyn30AoE,self.spell.markedForDeath,false,false) == true or false
		end
    end

    -- Pick Pocket
    -- TODO: improve pick pocket, does not always loot correctly
    function self.canPickPocket() --Pick Pocket Toggle State
        if BadBoy_data['Picker'] == 1 or BadBoy_data['Picker'] == 2 then
            return true
        else
            return false
        end
    end

   	function self.noAttack() --Pick Pocket Toggle State
   	   if BadBoy_data['Picker'] == 2 then
   	       return true
   	   else
   	       return false
   	   end
   	end

    function self.isPicked(thisUnit)	--	Pick Pocket Testing
    	local myTarget = myTarget or "target"
    	local thisUnit = thisUnit or "target"
    	if myTarget~=thisUnit then canPickpocket = true end
        if (canPickpocket == false or BadBoy_data['Picker'] == 3 or GetNumLootItems() > 0) then
            return true
        else
            return false
        end
    end

    function self.getPickPocketRange()
        if self.glyph.pickPocket then
            return 10
        else
            return 5
        end
    end

    function self.castPickPocket(thisUnit)
    	local thisUnit = thisUnit or "target"
        local targetDistance = getRealDistance("player", thisUnit)
        if self.stealth and self.level>=15 and self.canPickPocket() and not self.isPicked() and targetDistance < self.getPickPocketRange() then
            return castSpell(thisUnit,self.spell.pickPocket,false,false) == true or false
        end
    end
    
    -- Preparation
	function self.castPreparation()
		if self.cd.preparation==0 and self.level>=68 then
			return castSpell("player",self.spell.preparation,true,false) == true or false
		end
	end

	-- ShadowStep
	function self.castShadowStep()
		if self.talent.shadowStep and self.cd.shadowStep==0 and self.level>=60 and ObjectExists("target") then
			return castSpell("target",self.spell.shadowStep,true,false,false) == true or false
		end
	end

	-- Shiv
	function self.castShiv()
		if self.cd==0 and self.power>20 and self.level>=74 and ObjectExists(self.units.dyn5) then
			return castSpell(self.units.dyn5,self.spell.shiv,false,false) == true or false
		end
	end

	-- Sprint
	function self.castSprint()
		if self.cd==0 and self.level>=26 then
			return castSpell("player",self.spell.sprint,true,false,false) == true or false
		end
	end

	-- Stealth
	function self.castStealth()
		if isChecked("Stealth") and self.cd.stealth==0 and self.level>=5 and not self.stealth then
			return castSpell("player",self.spell.stealth,true,false,false) == true or false
		end
	end

	-- Tricks of the Trade
	function self.castTricksOfTheTrade(thisUnit)
		local thisUnit = thisUnit or "target"
		if self.cd.tricksOfTheTrade and self.level>=78 then
			return castSpell(thisUnit,self.spell.tricksOfTheTrade,false,false,false) == true or false
		end
	end

-- Return
	return self
end

end -- End Select 