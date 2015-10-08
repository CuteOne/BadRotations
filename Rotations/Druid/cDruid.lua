-- Inherit from: ../cCharacter.lua
-- All Druid specs inherit from this file
if select(2, UnitClass("player")) == "DRUID" then
	cDruid = {}
	-- Creates Druid with given specialisation
	function cDruid:new(spec)
		local self = cCharacter:new("Druid")

		local player = "player" -- if someone forgets ""

		self.profile         = spec
		self.comboPoints     = getCombo("player")
		self.stealth		 = false
		self.buff.duration	 = {}		-- Buff Durations
		self.buff.remain 	 = {}		-- Buff Time Remaining
		self.debuff.duration = {}		-- Debuff Durations
		self.debuff.remain 	 = {}		-- Debuff Time Remaining
		self.druidSpell 	 = {

			-- Ability - Crowd Control
			cyclone 					= 33786,
			entanglingRoots 			= 339,
			hurricane 					= 16914,
			incapacitatingRoar 			= 99,
			mightyBash 					= 5211,
			typhoon 					= 132469,
			ursolsVortex 				= 102793,

			-- Ability - Defensive
			barkskin 					= 22812,
			cenarionWard 				= 102351,
			frenziedRegeneration 		= 22842,
			healingTouch 				= 5185,
			naturesVigil 				= 124974,
			rejuvenation 				= 774,
			removeCorruption 			= 2782,
			renewal 					= 108238,
			survivalInstincts 			= 61336,

			-- Ability - Forms
			bearForm 					= 5487,
			catForm 					= 768,
			flightForm 					= 165962,
			travelForm 					= 783,

			-- Ability - Offensive
			berserk 					= 106951,
			faerieFire 					= 770,
			faerieSwarm 				= 102355,	
			ferociousBite 				= 22568,
			markOfTheWild 				= 1126,
			mangle 						= 33917,
			moonfire 					= 8921,
			shred 						= 5221,
			wrath 						= 5176,

			-- Ability - Utility
			dash 						= 1850,
			displacerBeast 				= 102280,
			growl 						= 6795,
			innervate 					= 29166,
			prowl 						= 5215,
			rebirth 					= 20484,
			revive 						= 50769,
			skullBash 					= 106839,
			soothe 						= 2908,
			teleportMoonglade 			= 18960,
			trackHumanoids 				= 5225,
			wildCharge 					= 102401,

			-- Buff - Defensive
			barkskinBuff 				= 22812,
			cenarionWardBuff 			= 102351,
			frenziedRegenerationBuff	= 22842,
			rejuvenationBuff 			= 774,
			survivalInstinctsBuff 		= 61336,

			-- Buff - Forms
			bearFormBuff 				= 5487,
			catFormBuff					= 768,
			flightFormBuff 				= 165962,
			travelFormBuff 				= 783,

			-- Buff - Offensive
			berserkBuff 				= 106951,
			markOfTheWildBuff 			= 1126,

			-- Buff - Utility
			clearcastingBuff 			= 16870,
			dashBuff 					= 1850,
			displacerBeastBuff 			= 102280,
			innervateBuff 				= 173565,
			prowlBuff 					= 5215,

			-- Debuff - Crowd Control
			cycloneDebuff 				= 33786,
			entanglingRootsDebuff 		= 339,
			hurricaneDebuff 			= 16914,
			incapacitatingRoarDebuff	= 99,

			-- Debuff - Offensive
			faerieFireDebuff 			= 770,
			faerieSwarmDebuff 			= 102355,
			infectedWoundsDebuff 		= 48484,
			moonfireDebuff 				= 8921,

			-- Debuff - Utility
			growlDebuff 				= 6795,

			-- Glyphs
			aquaticFormGlyph 			= 57856,
			barkskinGlyph 				= 63057,
			charmWoodlandCreatureGlyph 	= 57855,
			cycloneGlyph 				= 48514,
			dashGlyph 					= 59219,
			entanglingRootsGlyph 		= 54760,
			faerieFireGlyph 			= 94386,
			graceGlyph 					= 114295,
			oneWithNatureGlyph 			= 146656,
			rebirthGlyph 				= 54733,
			skullBashGlyph 				= 116216,
			stampedingRoarGlyph 		= 114222,
			survivalInstinctsGlyph 		= 114223,
			chameleonGlyph 				= 107059,
			cheetahGlyph 				= 131113,
			masterShapreshifterGlyph 	= 116172,
			orcaGlyph 					= 114333,
			predatorGlyph 				= 114280,
			shapemenderGlyph 			= 159453,
			stagGlyph 					= 114338,
			treantGlyph 				= 125047,
			travelGlyph 				= 159456,

			-- Perks
			enhancedRebirth 			= 157301,

			-- Talents
			cenarionWardTalent 			= 102351,
			displacerBeastTalent 		= 102280,
			fearieSwarmTalent 			= 106707,
			incapacitatingRoarTalent 	= 99,
			massEntanglementTalent 		= 102359,
			mightyBashTalent 			= 5211,
			naturesVigilTalent 			= 124974,
			renewalTalent 				= 108238,
			typhoonTalent 				= 132469,
			ursolsVortexTalent 			= 102793,
			wildChargeTalent 			= 102401,
			yserasGiftTalent 			= 145108,
		}

	-- Update 
		function self.classUpdate()
			-- Call baseUpdate()
			self.baseUpdate()
			self.getClassOptions()
			self.getClassDynamicUnits()
			self.getClassBuffs()
			self.getClassBuffsRemain()
			self.getClassBuffsDuration()
			self.getClassCharges()
			self.getClassCooldowns()
			self.getClassDebuffs()
			self.getClassDebuffsRemain()
			self.getClassDebuffsDuration()

			-- Update Combo Points
			self.comboPoints = GetComboPoints("player")

	        -- Update Energy Regeneration
	        self.powerRegen  = getRegen("player")

			-- Stealth
			if self.race == "Night Elf" then
				self.stealth = UnitBuffID("player",self.spell.prowl) or UnitBuffID("player",self.racial)
			else
				self.stealth = UnitBuffID("player",self.spell.prowl)
			end
		end

	-- Update OOC
		function self.classUpdateOOC()
			-- Call baseUpdateOOC()
			self.baseUpdateOOC()
			self.getClassGlyphs()
			self.getClassTalents()
			self.getClassPerks()
		end

	---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getClassDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn15 = dynamicTarget(15,true) -- Typhoon

            -- AoE
            self.units.dyn10AoE = dynamicTarget(10, false) -- Incapacitating Roar
            self.units.dyn20AoE = dynamicTarget(20, false) -- Cyclone
            self.units.dyn35AoE = dynamicTarget(35, false) -- Entangling Roots
        end

	-- Buff updates
		function self.getClassBuffs()
			local UnitBuffID = UnitBuffID

			self.buff.barkskin 				= UnitBuffID("player",self.spell.barkskinBuff)~=nil or false
			self.buff.bearForm 				= UnitBuffID("player",self.spell.bearFormBuff)~=nil or false
			self.buff.berserk 				= UnitBuffID("player",self.spell.berserkBuff)~=nil or false
			self.buff.catForm 				= UnitBuffID("player",self.spell.catFormBuff)~=nil or false
			self.buff.cenarionWard 			= UnitBuffID("player",self.spell.cenarionWardBuff)~=nil or false
			self.buff.clearcasting 			= UnitBuffID("player",self.spell.clearcastingBuff)~=nil or false
			self.buff.dash 					= UnitBuffID("player",self.spell.dash)~=nil or false
			self.buff.displacerBeast		= UnitBuffID("player",self.spell.displacerBeastBuff)~=nil or false
			self.buff.flightForm 			= UnitBuffID("player",self.spell.flightFormBuff)~=nil or false
			self.buff.frenziedRegeneration 	= UnitBuffID("player",self.spell.frenziedRegenerationBuff)~=nil or false
			self.buff.innervate 			= UnitBuffID("player",self.spell.innervateBuff)~=nil or false
			self.buff.markOfTheWild 		= UnitBuffID("player",self.spell.markOfTheWildBuff)~=nil or false
			self.buff.prowl 				= UnitBuffID("player",self.spell.prowlBuff)~=nil or false
			self.buff.rejuvenation 			= UnitBuffID("player",self.spell.rejuvenationBuff)~=nil or false
			self.buff.survivalInstincts 	= UnitBuffID("player",self.spell.survivalInstinctsBuff)~=nil or false
			self.buff.travelForm 			= UnitBuffID("player",self.spell.travelFormBuff)~=nil or false
		end

		function self.getClassBuffsDuration()
			local getBuffDuration = getBuffDuration

			self.buff.duration.barkskin				= getBuffDuration("player",self.spell.barkskinBuff) or 0
			self.buff.duration.berserk 				= getBuffDuration("player",self.spell.berserkBuff) or 0
			self.buff.duration.cenarionWard			= getBuffDuration("player",self.spell.cenarionWardBuff) or 0
			self.buff.duration.clearcasting			= getBuffDuration("player",self.spell.clearcastingBuff) or 0
			self.buff.duration.dash					= getBuffDuration("player",self.spell.dash) or 0
			self.buff.duration.displacerBeast 		= getBuffDuration("player",self.spell.displacerBeastBuff) or 0
			self.buff.duration.frenziedRegeneration	= getBuffDuration("player",self.spell.frenziedRegenerationBuff) or 0
			self.buff.duration.innervate 			= getBuffDuration("player",self.spell.innervateBuff) or 0
			self.buff.duration.markOfTheWild		= getBuffDuration("player",self.spell.markOfTheWildBuff) or 0
			self.buff.duration.rejuvenation 		= getBuffDuration("player",self.spell.rejuvenationBuff) or 0
			self.buff.duration.survivalInstincts 	= getBuffDuration("player",self.spell.survivalInstinctsBuff) or 0
		end

		function self.getClassBuffsRemain()
			local getBuffRemain = getBuffRemain

			self.buff.remain.barkskin 				= getBuffRemain("player",self.spell.barkskinBuff) or 0
			self.buff.remain.berserk 				= getBuffRemain("player",self.spell.berserkBuff) or 0
			self.buff.remain.cenarionWard 			= getBuffRemain("player",self.spell.cenarionWardBuff) or 0
			self.buff.remain.clearcasting 			= getBuffRemain("player",self.spell.clearcastingBuff) or 0
			self.buff.remain.dash 					= getBuffRemain("player",self.spell.dash) or 0
			self.buff.remain.displacerBeast			= getBuffRemain("player",self.spell.displacerBeastBuff) or 0
			self.buff.remain.frenziedRegeneration 	= getBuffRemain("player",self.spell.frenziedRegenerationBuff) or 0
			self.buff.remain.innervate 				= getBuffRemain("player",self.spell.innervateBuff) or 0
			self.buff.remain.markOfTheWild 			= getBuffRemain("player",self.spell.markOfTheWildBuff) or 0
			self.buff.remain.rejuvenation 			= getBuffRemain("player",self.spell.rejuvenationBuff) or 0
			self.buff.remain.survivalInstincts 		= getBuffRemain("player",self.spell.survivalInstinctsBuff) or 0
		end

	-- Charge updates
		function self.getClassCharges()
			local getCharges = getCharges

			self.charges.survivalInstincts = getCharges(self.spell.survivalInstincts)
		end

	-- Cooldown updates
		function self.getClassCooldowns()
			local getSpellCD = getSpellCD

			self.cd.barkskin 				= getSpellCD(self.spell.barkskin)
			self.cd.berserk 				= getSpellCD(self.spell.berserk)
			self.cd.cenarionWard 			= getSpellCD(self.spell.cenarionWard)
			self.cd.dash 					= getSpellCD(self.spell.dash)
			self.cd.displacerBeast 			= getSpellCD(self.spell.displacerBeast)
			self.cd.frenziedRegeneration 	= getSpellCD(self.spell.frenziedRegeneration)
			self.cd.growl 					= getSpellCD(self.spell.growl)
			self.cd.incapacitatingRoar 		= getSpellCD(self.spell.incapacitatingRoar)
			self.cd.mightyBash 				= getSpellCD(self.spell.mightyBash)
			self.cd.naturesVigil 			= getSpellCD(self.spell.naturesVigil)
			self.cd.prowl 					= getSpellCD(self.spell.prowl)
			self.cd.rebirth 				= getSpellCD(self.spell.rebirth)
			self.cd.removeCorruption 		= getSpellCD(self.spell.removeCorruption)
			self.cd.renewal 				= getSpellCD(self.spell.renewal)
			self.cd.skullBash 				= getSpellCD(self.spell.skullBash)
			self.cd.trackHumanoids 			= getSpellCD(self.spell.trackHumanoids)
			self.cd.typhoon 				= getSpellCD(self.spell.typhoon)
			self.cd.ursolsVortex 			= getSpellCD(self.spell.ursolsVortex)
			self.cd.wildCharge 				= getSpellCD(self.spell.wildCharge)
		end

	-- Debuff updates
		function self.getClassDebuffs()
			local UnitDebuffID = UnitDebuffID

			self.debuff.cyclone 			= UnitDebuffID(self.units.dyn20AoE,self.spell.cycloneDebuff,"player")~=nil or false
			self.debuff.entanglingRoots 	= UnitDebuffID(self.units.dyn35AoE,self.spell.entanglingRootsDebuff,"player")~=nil or false
			self.debuff.hurricane 			= UnitDebuffID(self.units.dyn35AoE,self.spell.hurricaneDebuff,"player")~=nil or false
			self.debuff.incapacitatingRoar 	= UnitDebuffID(self.units.dyn10AoE,self.spell.incapacitatingRoarDebuff,"player")~=nil or false
			self.debuff.faerieFire 			= UnitDebuffID(self.units.dyn35AoE,self.spell.faerieFireDebuff,"player")~=nil or false
			self.debuff.faerieSwarm 		= UnitDebuffID(self.units.dyn35AoE,self.spell.faerieSwarmDebuff,"player")~=nil or false
			self.debuff.infectedWounds 		= UnitDebuffID(self.units.dyn5,self.spell.infectedWoundsDebuff,"player")~=nil or false
			self.debuff.moonfire 			= UnitDebuffID(self.units.dyn40AoE,self.spell.moonfireDebuff,"player")~=nil or false
			self.debuff.growl 				= UnitDebuffID(self.units.dyn30AoE,self.spell.growlDebuff,"player")~=nil or false
		end

		function self.getClassDebuffsDuration()
			local getDebuffDuration = getDebuffDuration

			self.debuff.duration.cyclone 			= getDebuffDuration(self.units.dyn20AoE,self.spell.cycloneDebuff,"player") or 0
			self.debuff.duration.entanglingRoots 	= getDebuffRemain(self.units.dyn35AoE,self.spell.entanglingRootsDebuff,"player") or 0
			self.debuff.duration.hurricane 			= getDebuffRemain(self.units.dyn35AoE,self.spell.hurricaneDebuff,"player") or 0
			self.debuff.duration.incapacitatingRoar = getDebuffRemain(self.units.dyn10AoE,self.spell.incapacitatingRoarDebuff,"player") or 0
			self.debuff.duration.faerieFire 		= getDebuffRemain(self.units.dyn35AoE,self.spell.faerieFireDebuff,"player") or 0
			self.debuff.duration.faerieSwarm 		= getDebuffRemain(self.units.dyn35AoE,self.spell.faerieSwarmDebuff,"player") or 0
			self.debuff.duration.infectedWounds 	= getDebuffRemain(self.units.dyn5,self.spell.infectedWoundsDebuff,"player") or 0
			self.debuff.duration.moonfire 			= getDebuffRemain(self.units.dyn40AoE,self.spell.moonfireDebuff,"player") or 0
			self.debuff.duration.growl 				= getDebuffRemain(self.units.dyn30AoE,self.spell.growlDebuff,"player") or 0
		end

		function self.getClassDebuffsRemain()
			local getDebuffRemain = getDebuffRemain

			self.debuff.remain.cyclone 					= getDebuffRemain(self.units.dyn20AoE,self.spell.cycloneDebuff,"player") or 0
			self.debuff.remain.entanglingRoots 			= getDebuffRemain(self.units.dyn35AoE,self.spell.entanglingRootsDebuff,"player") or 0
			self.debuff.remain.hurricane 	 			= getDebuffRemain(self.units.dyn35AoE,self.spell.hurricaneDebuff,"player") or 0
			self.debuff.remain.incapacitatingRoar 		= getDebuffRemain(self.units.dyn10AoE,self.spell.incapacitatingRoarDebuff,"player") or 0
			self.debuff.remain.faerieFire 				= getDebuffRemain(self.units.dyn35AoE,self.spell.faerieFireDebuff,"player") or 0
			self.debuff.remain.faerieSwarm  			= getDebuffRemain(self.units.dyn35AoE,self.spell.faerieSwarmDebuff,"player") or 0
			self.debuff.remain.infectedWounds 			= getDebuffRemain(self.units.dyn5,self.spell.infectedWoundsDebuff,"player") or 0
			self.debuff.remain.moonfire					= getDebuffRemain(self.units.dyn40AoE,self.spell.moonfireDebuff,"player") or 0
			self.debuff.remain.growl 					= getDebuffRemain(self.units.dyn30AoE,self.spell.growlDebuff,"player") or 0
		end

	-- Glyph updates
		function self.getClassGlyphs()
			local hasGlyph = hasGlyph

			self.glyph.aquaticForm 				= hasGlyph(self.spell.aquaticFormGlyph)
			self.glyph.barkskin 				= hasGlyph(self.spell.barkskinGlyph)
			self.glyph.charmWoodlandCreature 	= hasGlyph(self.spell.charmWoodlandCreatureGlyph)
			self.glyph.cyclone 					= hasGlyph(self.spell.cycloneGlyph)
			self.glyph.dash 					= hasGlyph(self.spell.dashGlyph)
			self.glyph.entanglingRoots 			= hasGlyph(self.spell.entanglingRootsGlyph)
			self.glyph.faerieFire 				= hasGlyph(self.spell.fearieFireGlyph)
			self.glyph.grace 					= hasGlyph(self.spell.graceGlyph)
			self.glyph.oneWithNature 			= hasGlyph(self.spell.oneWithNatureGlyph)
			self.glyph.rebirth 					= hasGlyph(self.spell.rebirthGlyph)
			self.glyph.skullBash 				= hasGlyph(self.spell.skullBashGlyph)
			self.glyph.stampedingRoar 			= hasGlyph(self.spell.stampedingRoarGlyph)
			self.glyph.survivalInstincts 		= hasGlyph(self.spell.survivalInstinctsGlyph)
			self.glyph.chameleon 				= hasGlyph(self.spell.chameleonGlyph)
			self.glyph.cheetah 					= hasGlyph(self.spell.cheetahGlyph)
			self.glyph.masterShapreshifter 		= hasGlyph(self.spell.masterShapreshifterGlyph)
			self.glyph.orca 					= hasGlyph(self.spell.orcaGlyph)
			self.glyph.predator 				= hasGlyph(self.spell.predatorGlyph)
			self.glyph.shapemender 				= hasGlyph(self.spell.shapemenderGlyph)
			self.glyph.stag 					= hasGlyph(self.spell.stagGlyph)
			self.glyph.treant 					= hasGlyph(self.spell.treantGlyph)
			self.glyph.travel 					= hasGlyph(self.spell.travelGlyph)
		end

	-- Talent updates
		function self.getClassTalents()
			local getTalent = getTalent

			self.talent.felineSwiftness 	= getTalent(1,1)
			self.talent.displacerBeast 		= getTalent(1,2)
			self.talent.wildCharge 			= getTalent(1,3)
			self.talent.yserasGift 			= getTalent(2,1)
			self.talent.renewal 			= getTalent(2,2)
			self.talent.cenarionWard 		= getTalent(2,3)
			self.talent.fearieSwarm 		= getTalent(3,1)
			self.talent.massEntanglement 	= getTalent(3,2)
			self.talent.typhoon 			= getTalent(3,3)
			self.talent.incapacitatingRoar 	= getTalent(5,1)
			self.talent.ursolsVortex 		= getTalent(5,2)
			self.talent.mightyBash 			= getTalent(5,3)
			self.talent.naturesVigil 		= getTalent(6,3)	
		end

	-- Perk updates
		function self.getClassPerks()
			local isKnown = isKnown

			self.perk.enhancedRebirth = isKnown(self.spell.enhancedRebirth)
		end

	-- Get Class option modes
		function self.getClassOptions()
			--self.poisonTimer = getValue("Poison remain")
		end

	---------------
	--- OPTIONS ---
	---------------

		-- Class options
		-- Options which every Rogue should have
		function self.createClassOptions()
			-- Create Base Options
			self.createBaseOptions()
		end

	------------------------------
	--- SPELLS - CROWD CONTROL ---
	------------------------------

		-- Cyclone
		function self.castCyclone()
			if self.level>=78 and self.powerPercentMana>7.5 and hasThreat(self.units.dyn20AoE) and getDistance(self.units.dyn20AoE)<20 then
				if castSpell(self.units.dyn20AoE,self.spell.cyclone,false,false,false) then return end
			end
		end
		-- Entangling Roots
		function self.castEntanglingRoots()
			if self.level>=10 and self.powerPercentMana>6.5 and hasThreat(self.units.dyn35AoE) and getDistance(self.units.dyn35AoE)<35 then
				if castSpell(self.units.dyn35AoE,self.spell.entanglingRoots,false,false,false) then return end
			end
		end
		-- Hurricane
		function self.castHurricane()
			if self.level>=42 and self.powerPercentMana>10 and hasThreat(self.units.dyn35AoE) and getDistance(self.units.dyn35AoE)<35 then
				if castGoundAtBestLocation(self.spell.hurricane,8,1,35) then return end
			end
		end
		-- Incapacitating Roar
		function self.castIncapacitatingRoar()
			if self.level>=75 and self.cd.incapacitatingRoar==0 and hasThreat(self.units.dyn10AoE) and getDistance(self.units.dyn10AoE)<10 then
				if castSpell(self.units.dyn10AoE,self.spell.incapacitatingRoar,false,false,false) then return end
			end
		end
		-- Mighty Bash
		function self.castMightyBash()
			if self.talent.mightyBash and self.cd.mightyBash==0 and hasThreat(self.units.dyn5) and getDistance(self.units.dyn5)<5 then
				if castSpell(self.units.dyn5,self.spell.mightyBash,false,false,false) then return end
			end
		end
		-- Typhoon
		function self.castTyphoon()
			if self.talent.typhoon and self.cd.typhoon==0 and hasThreat(self.units.dyn15) and getDistance(self.units.dyn15)<15 then
				if castSpell(self.units.dyn15,self.spell.typhoon,false,false,false) then return end
			end
		end
		-- Ursol's Vortex
		function self.castUrsolsVortex()
			if self.talent.ursolsVortex and self.cd.ursolsVortex==0 and hasThreat(self.units.dyn30AoE) and getDistance(self.units.dyn30AoE)<30 then
				if castGoundAtBestLocation(self.spell.ursolsVortex,8,1,30) then return end
			end
		end

	--------------------------
	--- SPELLS - DEFENSIVE ---
	--------------------------

		-- Barkskin
		function self.castBarkskin()
			if (self.spec=="Balance" or self.spec=="Guardian" or self.spec=="Restoration") and self.level>=44 and self.cd.barkskin==0 then
				if castSpell("player",self.spell.barkskin,false,false,false) then return end
			end
		end
		-- Cenarion Ward - Set target via thisUnit variable
		function self.castCenarionWard(thisUnit)
			local isLivePlayer = UnitIsPlayer(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and UnitIsFriend(thisUnit,"player")

			if self.talent.cenarionWard and self.cd.cenarionWard==0 and self.powerPercentMana>9.2 and isLivePlayer and getDistance(thisUnit)<40 then
				if castSpell(thisUnit,self.spell.cenarionWard,false,false,false) then return end
			end
		end
		-- Frenzied Regeneration
		function self.castFrenziedRegeneration()
			if self.level>=68 and self.cd.frenziedRegeneration==0 and self.buff.bearForm and self.power>0 then
				if castSpell("player",self.spell.frenziedRegeneration,false,false,false) then return end
			end
		end
		-- Healing Touch - Set target via thisUnit variable
		function self.castHealingTouch(thisUnit)
			local isLivePlayer = UnitIsPlayer(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and UnitIsFriend(thisUnit,"player")
			
			if self.level>=26 and self.powerPercentMana>10.35 and isLivePlayer and getDistance(thisUnit)<40 then
				if castSpell(thisUnit,self.spell.healingTouch,false,false,false) then return end
			end
		end
		-- Nature's Vigil
		function self.castNaturesVigil()
			if self.talent.naturesVigil and self.cd.naturesVigil==0 then
				if castSpell("player",self.spell.naturesVigil,false,false,false) then return end
			end
		end
		-- Rejuvenation - Set target via thisUnit variable
		function self.castRejuvenation(thisUnit)
			local isLivePlayer = UnitIsPlayer(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and UnitIsFriend(thisUnit,"player")
			
			if self.level>=4 and self.powerPercentMana>9.45 and isLivePlayer and getDistance(thisUnit)<40 then
				if castSpell(thisUnit,self.spell.rejuvenation,false,false,false) then return end
			end
		end
		-- Remove Corruption - Set target via thisUnit variable
		function self.castRemoveCorruption(thisUnit)
			if (self.spec=="Balance" or self.spec=="Feral" or self.spec=="Guardian") and self.level>=22 and self.powerPercentMana>15.8 and self.cd.removeCorruption==0 and canDispel(thisUnit,self.spell.removeCorruption) and getDistance(thisUnit)<40 then
				if castSpell(thisUnit,self.spell.removeCorruption,false,false,false) then return end
			end
		end
		-- Renewal
		function self.castRenewal()
			if self.talent.renewal and self.cd.renewal==0 and self.health<70 then
				if castSpell("player",self.spell.renewal,false,false,false) then return end
			end
		end
		-- Survival Instincts
		function self.castSurvivalInstincts()
			if (self.spec=="Feral" or self.spec=="Guardian") and self.level>=56 and self.charges.survivalInstincts>0 then
				if castSpell("player",self.spell.survivalInstincts,false,false,false) then return end
			end
		end

	----------------------
	--- SPELLS - FORMS ---
	----------------------

		-- Bear Form
		function self.castBearForm()
			if self.level>=8 and self.powerPercentMana>7.4 then
				if castSpell("player",self.spell.bearForm,false,false,false) then return end
			end
		end
		-- Cat Form
		function self.castCatForm()
			if self.level>=6 and self.powerPercentMana>7.4 then
				if castSpell("player",self.spell.catForm,false,false,false) then return end
			end
		end
		-- Flight Form
		function self.castFlightForm()
			if self.level>=58 and self.powerPercentMana>7.4 and not self.inCombat then
				if castSpell("player",self.spell.flightForm,false,false,false) then return end
			end
		end
		-- Travel Form
		function self.castTravelForm()
			if self.level>=16 and self.powerPercentMana>7.4 then
				if castSpell("player",self.spell.travelForm,false,false,false) then return end
			end
		end

	--------------------------
	--- SPELLS - OFFENSIVE ---
	--------------------------

		-- Berserk
		function self.castBerserk()
			if (self.spec=="Feral" or self.spec=="Guardian") and self.level>=48 and self.cd.berserk==0 and (self.buff.bearForm or self.buff.catForm) then
				if castSpell("player",self.spell.berserk,false,false,false) then return end
			end
		end
		-- Faerie Fire
		function self.castFaerieFire(thisUnit)
			if (self.spec=="Feral" or self.spec=="Guardian") and self.level>=28 and hasThreat(thisunit) and getDistance(thisunit)<35 then
				if castSpell(thisUnit,self.spell.faerieFire,false,false,false) then return end
			end
		end
		-- Faerie Swarm
		function self.castFaerieSwarm(thisUnit)
			if (self.spec=="Feral" or self.spec=="Guardian") and self.talent.faerieSwarm and hasThreat(thisUnit) and getDistance(thisunit)<35 then
				if castSpell(thisUnit,self.spell.faerieSwarm,false,false,false) then return end
			end
		end
		-- Ferocious Bite - Set target via thisUnit variable
		function self.castFerociousBite(thisUnit)
			if self.level>=6 and self.power>25 and self.buff.catForm and self.comboPoints>0 and hasThreat(thisUnit) and getDistance(thisUnit)<5 then
				if castSpell(thisUnit,self.spell.ferociousBite,false,false,false) then return end
			end
		end
		-- Mark of the Wild
		function self.castMarkOfTheWild()
			if self.level>=62 and self.powerPercentMana>5 then
		        if self.instance=="none" and not isBuffed("player",{1126,115921,116781,20217,160206,69378,159988,160017,90363,160077}) then
		        	if castSpell("player",self.spell.markOfTheWild,false,false,false) then return end
		        else
			        local totalCount = GetNumGroupMembers()
			        local currentCount = currentCount or 0
			        local needsBuff = needsBuff or 0
			        for i=1,#nNova do
			            local thisUnit = nNova[i].unit
			            local distance = getDistance(thisUnit)
			            if distance<30 then
			                currentCount = currentCount+1
			            end
			            if not isBuffed(thisUnit,{1126,115921,116781,20217,160206,69378,159988,160017,90363,160077}) then
			            	needsBuff = needsBuff+1
			            end
			        end
			        if currentCount>=totalCount and needsBuff>0 then
			            if castSpell("player",self.spell.markOfTheWild,false,false,false) then return end
			        end
			    end
		    end
		end
		-- Mangle
		function self.castMangle(thisUnit)
			if self.level>=8 and self.cd.mangle==0 and self.buff.bearForm and hasThreat(thisUnit) and getDistance(thisUnit)<5 then
				if castSpell(thisUnit,self.spell.mangle,false,false,false) then return end
			end
		end
		-- Moonfire - Set target via thisUnit variable
		function self.castMoonfire(thisUnit)
			if self.level>=3 and self.powerPercentMana>1.5 and hasThreat(thisUnit) and getDistance(thisUnit)<40 then
				if castSpell(thisUnit,self.spell.moonfire,false,false,false) then return end
			end
		end
		-- Shred
		function self.castShred(thisUnit)
			if self.level>=6 and self.buff.catForm and self.power>40 and hasThreat(thisUnit) and getDistance(thisUnit)<5 then
				if castSpell(thisUnit,self.spell.shred,false,false,false) then return end
			end
		end
		-- Wrath
		function self.castWrath(thisUnit)
			if self.level>=1 and self.powerPercentMana>3.5 and hasThreat(thisUnit) and getDistance(thisUnit)<40 then
				if castSpell(thisUnit,self.spell.wrath,false,false,false) then return end
			end
		end

	------------------------
	--- SPELLS - UTILITY ---
	------------------------

		-- Dash
		function self.castDash()
			if self.level>=24 and self.cd.dash==0 then
				if castSpell("player",self.spell.dash,false,false,false) then return end
			end
		end
		-- Displacer Beast
		function self.castDisplacerBeast()
			if self.talent.displacerBeast and self.cd.displacerBeast==0 then
				if castSpell("player",self.spell.displacerBeast,false,false,false) then return end
			end
		end
		-- Growl
		function self.castGrowl(thisUnit)
			if self.level>=8 and self.cd.growl==0 and self.buff.bearForm and hasThreat(thisUnit) and getDistance(thisUnit)<30 then
				if castSpell(thisUnit,self.spell.growl,false,false,false) then return end
			end
		end
		-- Prowl
		function self.castProwl()
			if self.level>=6 and self.cd.prowl==0 and not self.buff.prowl then
				if castSpell("player",self.spell.prowl,false,false,false) then return end
			end
		end
		-- Rebirth - Set target via thisUnit variable
		function self.castRebirth(thisUnit)
			local isDeadPlayer = UnitIsPlayer(thisUnit) and UnitIsDeadOrGhost(thisUnit) and UnitIsFriend(thisUnit,"player")

			if self.level>=56 and self.cd.rebirth==0 and self.inCombat and isDeadPlayer and getDistance(thisUnit)<40 then
				if castSpell(thisUnit,self.spell.rebirth,false,false,false,false,true) then return end
			end
		end
		-- Revive - Set target via thisUnit variable
		function self.castRevive(thisUnit)
			local isDeadPlayer = UnitIsPlayer(thisUnit) and UnitIsDeadOrGhost(thisUnit) and UnitIsFriend(thisUnit,"player")

			if self.level>=12 and self.powerPercentMana>4 and not inCombat and isDeadPlayer and hasThreat(thisUnit) and getDistance(thisUnit)<40 then
				if castSpell(thisUnit,self.spell.revive,false,false,false,false,true) then return end
			end
		end
		-- Skull Bash - Set target via thisUnit variable
		function self.castSkullBash(thisUnit)
			if (self.spec=="Feral" or self.spec=="Guardian") and self.level>=64 and self.cd.skullBash==0 and (self.buff.bearForm or self.buff.catForm) and hasThreat(thisUnit) and getDistance(thisUnit)<13 then 
				if castSpell(thisUnit,self.spell.skullBash,false,false,false) then return end
			end
		end
		-- Soothe - Set target via thisUnit variable
		function self.castSoothe(thisUnit)
			if self.level>=60 and self.powerPercentMana>5.6 and canDispel(thisUnit,self.spell.soothe) and hasThreat(thisUnit) and getDistance(thisUnit)<40 then
				if castSpell(thisUnit,self.spell.soothe,false,false,false) then return end
			end
		end
		-- Wild Charge - Set target via thisUnit variable
		function self.castWildCharge(thisUnit)
			if self.talent.wildCharge and self.cd.wildCharge==0 and getDistance(thisUnit)>=5 and hasThreat(thisUnit) and getDistance(thisUnit)<25 then
				if self.castSpell(thisUnit,self.spell.wildCharge,false,false,false) then return end
			end
		end

		-- Return
		return self
	end --End function cDruid:new(spec)
end -- End Select 