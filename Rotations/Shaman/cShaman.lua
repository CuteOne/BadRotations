-- Inherit from: ../cCharacter.lua
-- All Shaman specs inherit from this file
if select(2, UnitClass("player")) == "SHAMAN" then
	cShaman = {}

	-- Creates Shaman with given specialisation
	function cShaman:new(spec)
		local self = cCharacter:new("Shaman")

		local player = "player" -- if someone forgets ""

	-----------------
    --- VARIABLES ---
    -----------------

		self.profile         	= spec
	    self.powerRegen      	= getRegen("player")
	    self.powerPercent 		= ((UnitPower("player")/UnitPowerMax("player"))*100)
		self.buff.duration	 	= {}		-- Buff Durations
		self.buff.remain 	 	= {}		-- Buff Time Remaining
		self.debuff.duration 	= {}		-- Debuff Durations
		self.debuff.remain 	 	= {}		-- Debuff Time Remaining
		self.debuff.count 		= {} 		-- Debuff Target Count
		self.totem				= {} 		-- Totem Info
		self.totem.duration 	= {} 		-- Totem Durations
		self.totem.remain 		= {}		-- Totem Time Remaining
		self.shamanSpell 		= {
			-- Ability - Crowd Control
			windShear 					= 57994,
	        -- Ability - Defensive
	        ancestralGuidance 			= 108281,
	        astralShift 				= 108271,
	        healingRain 				= 73920,
	        healingSurge 				= 8004,
	        shamanisticRage 			= 30823,
	        -- Ability - Forms
	        -- Ability - Offensive
	        ancestralSwiftness 			= 16188,
	        ascendance					= 114052,
	        bloodlust 					= 2825,
	        chainLightning 				= 421,
	        elementalBlast 				= 117014,
	        elementalMastery 			= 16166,
	        flameShock 					= 8050,
	        frostShock 					= 8056,
	        heroism 					= 32182,
	        lightningBolt 				= 403,
	        lightningShield 			= 324,
	        liquidMagma 				= 152255,
	        -- Ability - Presense
	        -- Ability - Totems
	        callOfTheElements 			= 108285,
	        capacitorTotem 				= 108269,
	        earthbindTotem 				= 2484,
	        earthElementalTotem 		= 2062,
	        earthgrabTotem 				= 51485,        
	        fireElementalTotem 			= 2894,
	        groundingTotem 				= 8177,
	        healingStreamTotem 			= 5394,
	        searingTotem 				= 3599,
	        stormElementalTotem 		= 152256,
	        tremorTotem 				= 8143,
	        -- Ability - Utility
	        ancestralSpirit 			= 2008,
	        cleanseSpirit 				= 51886,
	        ghostWolf 					= 2645,
	        hex							= 51514,
	        purge 						= 370,
	        spiritWalk 					= 58875,
	        totemicRecall 				= 36936,
	        waterWalking				= 546,
	        -- Buff - Defensive
	        ancestralGuidanceBuff 		= 108281,
	        astralShiftBuff 			= 108271,
	        shamanisticRageBuff 		= 30823,
	        -- Buff - Forms
	        -- Buff - Offensive
	        ancestralSwiftnessBuff 		= 16188,
	        ascendanceBuff				= 114052,
	        bloodlustBuff 				= 2825,
	        elementalMasteryBuff 		= 16166,
	        heroismBuff 				= 32182,
	        lightningShieldBuff 		= 324,
	        liquidMagmaBuff 			= 152255,
	        -- Buff - Presense
	        -- Buff - Stacks
	        elementalFusionStacks 		= 157174,
	        -- Buff - Utility
	        ghostWolfBuff 				= 2645,
	        waterWalkingBuff 			= 546,
	        -- Debuff - Offensive
	        exhaustionDebuff			= 57723,
	        flameShockDebuff 			= 8050,
	        -- Debuff - Defensive
	        -- Glyphs
	        chainLightningGlyph 		= 55449,
	        -- Perks
	        -- Talents
	        ancestralGuidanceTalent 	= 108281,
	        astralShiftTalent 			= 108271,
	        callOfTheElementsTalent 	= 108285,
	        earthgrabTotemTalent 		= 51485,
	        echoOfTheElementsTalent 	= 108283,
	        elementalBlastTalent 		= 117014,
	        elementalFusionTalent 		= 152257,
	        elementalMasteryTalent 		= 16166,
	        liquidMagmaTalent 			= 152255,
	        stormElementalTotemTalent 	= 152256,
		}

	------------------
    --- OOC UPDATE ---
    ------------------

    	function self.classUpdateOOC()
			-- Call baseUpdateOOC()
			self.baseUpdateOOC()
			self.getClassGlyphs()
			self.getClassTalents()
		end

	--------------
    --- UPDATE ---
    --------------

		function self.classUpdate()
			-- Call baseUpdate()
			self.baseUpdate()
			self.getClassBuffs()
			self.getClassBuffsDuration()
			self.getClassBuffsRemain()
			self.getClassCharges()
			self.getClassCooldowns()
			self.getClassDynamicUnits()
			self.getClassDebuffs()
			self.getClassDebuffsDuration()
			self.getClassDebuffsRemain()
			self.getClassDebuffsCount()
			self.getClassTotems()
			self.getClassTotemsDuration()
			self.getClassTotemsRemain()
			self.getClassRecharge()
		end
		
	---------------------
    --- DYNAMIC UNITS ---
    ---------------------

		function self.getClassDynamicUnits()
			local dynamicTarget = dynamicTarget

			self.units.dyn8AoE 	= dynamicTarget(8, false)
			self.units.dyn10AoE = dynamicTarget(10, false)
			self.units.dyn25 	= dynamicTarget(25, true)
			self.units.dyn25AoE = dynamicTarget(25, false)
		end

	-------------
    --- BUFFS ---
    -------------

		function self.getClassBuffs()
			local UnitBuffID = UnitBuffID

			self.buff.ancestralGuidance 	= UnitBuffID("player",self.spell.ancestralGuidanceBuff)~=nil or false
			self.buff.ancestralSwiftness 	= UnitBuffID("player",self.spell.ancestralSwiftnessBuff)~=nil or false
			self.buff.ascendance 			= UnitBuffID("player",self.spell.ascendanceBuff) ~= nil or false
			self.buff.astralShift 			= UnitBuffID("player",self.spell.astralShiftBuff)~=nil or false
			self.buff.bloodlust 			= UnitBuffID("player",self.spell.bloodlustBuff)~=nil or false
			self.buff.elementalMastery 		= UnitBuffID("player",self.spell.elementalMasteryBuff)~=nil or false
			self.buff.ghostWolf 			= UnitBuffID("player",self.spell.ghostWolfBuff)~=nil or false
			self.buff.heroism 				= UnitBuffID("player",self.spell.heroismBuff)~=nil or false
			self.buff.lightningShield 		= UnitBuffID("player",self.spell.lightningShieldBuff)~=nil or false
			self.buff.liquidMagma 			= UnitBuffID("player",self.spell.liquidMagmaBuff)~=nil or false
			self.buff.shamanisticRage 		= UnitBuffID("player",self.spell.shamanisticRageBuff)~=nil or false
			self.buff.waterWalking 			= UnitBuffID("player",self.spell.waterWalkingBuff)~=nil or false
		end	

		function self.getClassBuffsDuration()
			local getBuffDuration = getBuffDuration

			self.buff.duration.ancestralGuidance	= getBuffDuration("player",self.spell.ancestralGuidanceBuff) or 0 
			self.buff.duration.ascendance 			= getBuffDuration("player",self.spell.ascendanceBuff) or 0
			self.buff.duration.astralShift 			= getBuffDuration("player",self.spell.astralShiftBuff) or 0 		
			self.buff.duration.bloodlust 			= getBuffDuration("player",self.spell.bloodlustBuff) or 0
			self.buff.duration.elementalMastery 	= getBuffDuration("player",self.spell.elementalMasteryBuff) or 0
			self.buff.duration.heroism 				= getBuffDuration("player",self.spell.heroismBuff) or 0
			self.buff.duration.lightningShield 		= getBuffDuration("player",self.spell.lightningShieldBuff) or 0
			self.buff.duration.liquidMagma 			= getBuffDuration("player",self.spell.liquidMagmaBuff) or 0
			self.buff.duration.shamanisticRage 		= getBuffDuration("player",self.spell.shamanisticRageBuff) or 0
		end

		function self.getClassBuffsRemain()
			local getBuffRemain = getBuffRemain

			self.buff.remain.ancestralGuidance	= getBuffRemain("player",self.spell.ancestralGuidanceBuff) or 0
			self.buff.remain.ascendance 		= getBuffRemain("player",self.spell.ascendanceBuff) or 0
			self.buff.remain.astralShift 		= getBuffRemain("player",self.spell.astralShiftBuff) or 0
			self.buff.remain.bloodlust 			= getBuffRemain("player",self.spell.bloodlustBuff) or 0
			self.buff.remain.elementalMastery 	= getBuffRemain("player",self.spell.elementalMasteryBuff) or 0
			self.buff.remain.heroism 			= getBuffRemain("player",self.spell.heroismBuff) or 0
			self.buff.remain.lightningShield 	= getBuffRemain("player",self.spell.lightningShieldBuff) or 0
			self.buff.remain.liquidMagma 		= getBuffRemain("player",self.spell.liquidMagmaBuff) or 0
			self.buff.remain.shamanisticRage 	= getBuffRemain("player",self.spell.shamanisticRageBuff) or 0
		end

	---------------
	--- CHARGES ---
	---------------

		function self.getClassCharges()
			local getBuffStacks = getBuffStacks
			local getCharges = getCharges

			self.charges.elementalFusion 	= getBuffStacks("player",self.spell.elementalFusionStacks,"player") or 0
		end

	-----------------
	--- COOLDOWNS ---
	-----------------

		function self.getClassCooldowns()
			local getSpellCD = getSpellCD

			self.cd.ancestralGuidance 	= getSpellCD(self.spell.ancestralGuidance)
			self.cd.ancestralSwiftness 	= getSpellCD(self.spell.ancestralSwiftness)
			self.cd.ascendance 			= getSpellCD(self.spell.ascendance)
			self.cd.astralShift 		= getSpellCD(self.spell.astralShift)
			self.cd.bloodlust 			= getSpellCD(self.spell.bloodlust)
			self.cd.capacitorTotem 		= getSpellCD(self.spell.capacitorTotem)
			self.cd.cleanseSpirit 		= getSpellCD(self.spell.cleanseSpirit)
			self.cd.earthbindTotem 		= getSpellCD(self.spell.earthbindTotem)
			self.cd.earthElementalTotem = getSpellCD(self.spell.earthElementalTotem)
			self.cd.earthgrabTotem 		= getSpellCD(self.spell.earthgrabTotem)
			self.cd.elementalBlast 		= getSpellCD(self.spell.elementalBlast)
			self.cd.elementalMastery 	= getSpellCD(self.spell.elementalMastery)
			self.cd.fireElementalTotem 	= getSpellCD(self.spell.fireElementalTotem)
			self.cd.flameShock 			= getSpellCD(self.spell.flameShock)
			self.cd.frostShock 			= getSpellCD(self.spell.frostShock)
			self.cd.groundingTotem 		= getSpellCD(self.spell.groundingTotem)
			self.cd.healingRain 		= getSpellCD(self.spell.healingRain)
			self.cd.healingStreamTotem 	= getSpellCD(self.spell.healingStreamTotem)
			self.cd.heroism 			= getSpellCD(self.spell.heroism)
			self.cd.hex					= getSpellCD(self.spell.hex)
			self.cd.liquidMagma 		= getSpellCD(self.spell.liquidMagma)
			self.cd.shamanisticRage 	= getSpellCD(self.spell.shamanisticRage)
			self.cd.stormElementalTotem = getSpellCD(self.spell.stormElementalTotem)
			self.cd.spiritWalk 			= getSpellCD(self.spell.spiritWalk)
			self.cd.tremorTotem 		= getSpellCD(self.spell.tremorTotem)
			self.cd.windShear 			= getSpellCD(self.spell.windShear)
		end

	---------------
	--- DEBUFFS ---
	---------------

		function self.getClassDebuffs()
			local UnitDebuffID = UnitDebuffID

			self.debuff.exhaustion = UnitDebuffID("player",self.spell.exhaustionDebuff)~=nil or false
			self.debuff.flameShock = UnitDebuffID("target",self.spell.flameShockDebuff,"player")~=nil or false
		end

		function self.getClassDebuffsDuration()
			local getDebuffDuration = getDebuffDuration

			self.debuff.duration.exhaustion = getDebuffDuration("player",self.spell.exhaustionDebuff) or 0
			self.debuff.duration.flameShock = getDebuffDuration("target",self.spell.flameShockDebuff,"player") or 0
		end

		function self.getClassDebuffsRemain()
			local getDebuffRemain = getDebuffRemain

			self.debuff.remain.exhaustion = getDebuffRemain("player",self.spell.exhaustionDebuff) or 0
			self.debuff.remain.flameShock = getDebuffRemain("target",self.spell.flameShockDebuff,"player") or 0
		end

		function self.getClassDebuffsCount()
			local UnitDebuffID = UnitDebuffID
			local flameShockCount = 0

			if flameShockCount>0 and not inCombat then flameShockCount = 0 end

			for i=1,#getEnemies("player",10) do
				local thisUnit = getEnemies("player",10)[i]
				if UnitDebuffID(thisUnit,self.spell.flameShockDebuff,"player") then
					flameShockCount = flameShockCount+1
				end
			end
			self.debuff.count.flameShock = flameShockCount or 0
		end

	----------------
	--- RECHARGE ---
	----------------

		function self.getClassRecharge()
			local getRecharge = getRecharge

			-- self.recharge.chiBrew 	 = getRecharge(self.spell.chiBrew)
		end

	-------------
	--- TOTEM ---
	-------------

		function self.getClassTotems()
			local fire, earth, water, air = 1, 2, 3, 4
			local GetTotemInfo = GetTotemInfo
			local GetSpellInfo = GetSpellInfo

			self.totem.exist 				= (GetTotemTimeLeft(fire) > 0 or GetTotemTimeLeft(earth) > 0 or GetTotemTimeLeft(water) > 0 or GetTotemTimeLeft(air) > 0)
			self.totem.capacitorTotem 		= (select(2, GetTotemInfo(air)) == GetSpellInfo(self.spell.capacitorTotem))
			self.totem.earthbindTotem 		= (select(2, GetTotemInfo(earth)) == GetSpellInfo(self.spell.earthbindTotem))
			self.totem.earthElementalTotem 	= (select(2, GetTotemInfo(earth)) == GetSpellInfo(self.spell.earthElementalTotem))
			self.totem.earthgrabTotem 	 	= (select(2, GetTotemInfo(earth)) == GetSpellInfo(self.spell.earthgrabTotem))
			self.totem.fireElementalTotem 	= (select(2, GetTotemInfo(fire)) == GetSpellInfo(self.spell.fireElementalTotem))
			self.totem.groundingTotem 		= (select(2, GetTotemInfo(air)) == GetSpellInfo(self.spell.groundingTotem))
			self.totem.healingStreamTotem 	= (select(2, GetTotemInfo(water)) == GetSpellInfo(self.spell.healingStreamTotem))
			self.totem.searingTotem 		= (select(2, GetTotemInfo(fire)) == GetSpellInfo(self.spell.searingTotem))
			self.totem.stormElementalTotem 	= (select(2, GetTotemInfo(air)) == GetSpellInfo(self.spell.stormElementalTotem))
			self.totem.tremorTotem  	 	= (select(2, GetTotemInfo(earth)) == GetSpellInfo(self.spell.tremorTotem))
		end

		function self.getClassTotemsDuration()

			self.totem.duration.capacitorTotem  	= 5
			self.totem.duration.earthbindTotem 		= 20
			self.totem.duration.earthElementalTotem = 60
			self.totem.duration.earthgrabTotem 		= 20
			self.totem.duration.fireElementalTotem 	= 60
			self.totem.duration.groundingTotem  	= 15
			self.totem.duration.healingStreamTotem 	= 15
			self.totem.duration.searingTotem 		= 60
			self.totem.duration.stormElementalTotem = 60
			self.totem.duration.tremorTotem 		= 10
		end

		function self.getClassTotemsRemain()
			local fire, earth, water, air = 1, 2, 3, 4
			local GetTotemTimeLeft = GetTotemTimeLeft

			if (select(2, GetTotemInfo(air)) == GetSpellInfo(self.spell.capacitorTotem)) then
				self.totem.remain.capacitorTotem 		= GetTotemTimeLeft(air) or 0
			else
				self.totem.remain.capacitorTotem  		= 0
			end
			if (select(2, GetTotemInfo(earth)) == GetSpellInfo(self.spell.earthbindTotem)) then
				self.totem.remain.earthbindTotem 		= GetTotemTimeLeft(earth) or 0
			else
				self.totem.remain.earthbindTotem 		= 0
			end
			if (select(2, GetTotemInfo(earth)) == GetSpellInfo(self.spell.earthElementalTotem)) then
				self.totem.remain.earthElementalTotem 	= GetTotemTimeLeft(earth) or 0
			else
				self.totem.remain.earthElementalTotem 	= 0
			end
			if (select(2, GetTotemInfo(earth)) == GetSpellInfo(self.spell.earthgrabTotem)) then
				self.totem.remain.earthgrabTotem 		= GetTotemTimeLeft(earth) or 0
			else
				self.totem.remain.earthgrabTotem 		= 0
			end
			if (select(2, GetTotemInfo(fire)) == GetSpellInfo(self.spell.fireElementalTotem)) then
				self.totem.remain.fireElementalTotem 	= GetTotemTimeLeft(fire) or 0
			else
				self.totem.remain.fireElementalTotem 	= 0
			end
			if (select(2, GetTotemInfo(air)) == GetSpellInfo(self.spell.groundingTotem)) then
				self.totem.remain.groundingTotem 		= GetTotemTimeLeft(air) or 0
			else
				self.totem.remain.groundingTotem  		= 0
			end
			if (select(2, GetTotemInfo(water)) == GetSpellInfo(self.spell.healingStreamTotem)) then
				self.totem.remain.healingStreamTotem 	= GetTotemTimeLeft(water) or 0
			else
				self.totem.remain.healingStreamTotem	= 0
			end
			if (select(2, GetTotemInfo(fire)) == GetSpellInfo(self.spell.searingTotem)) then
				self.totem.remain.searingTotem 			= GetTotemTimeLeft(fire) or 0
			else
				self.totem.remain.searingTotem 			= 0
			end
			if (select(2, GetTotemInfo(air)) == GetSpellInfo(self.spell.stormElementalTotem)) then
				self.totem.remain.stormElementalTotem 	= GetTotemTimeLeft(air) or 0
			else
				self.totem.remain.stormElementalTotem 	= 0
			end
			if (select(2, GetTotemInfo(earth)) == GetSpellInfo(self.spell.tremorTotem)) then
				self.totem.remain.tremorTotem 			= GetTotemTimeLeft(earth) or 0
			else
				self.totem.remain.tremorTotem 			= 0
			end
		end

	-------------
	--- GLYPH ---
	-------------

		function self.getClassGlyphs()
			local hasGlyph = hasGlyph

			self.glyph.chainLightning 	= hasGlyph(self.spell.chainLightningGlyph)
		end

	--------------
	--- TALENT ---
	--------------

		function self.getClassTalents()
			local getTalent = getTalent

			self.talent.astralShift 		= getTalent(1,3)
			self.talent.earthgrabTotem 		= getTalent(2,2)
			self.talent.callOfTheElements 	= getTalent(3,1)
			self.talent.elementalMastery 	= getTalent(4,1)
			self.talent.echoOfTheElements 	= getTalent(4,3)
			self.talent.ancestralGuidance 	= getTalent(5,2)
			self.talent.elementalBlast 		= getTalent(6,3)
			self.talent.elementalFusion 	= getTalent(7,1)
			self.talent.stormElementalTotem = getTalent(7,2)
			self.talent.liquidMagma 		= getTalent(7,3)
		end

	---------------
	--- OPTIONS ---
	---------------

		-- Class options
		-- Options which every Shaman should have
		function self.createClassOptions()
			-- Class Wrap
	        local section = bb.ui:createSection(bb.ui.window.profile,  "Class Options", "Nothing")
	        bb.ui:checkSectionState(section)
		end

	------------------------------
	--- SPELLS - CROWD CONTROL --- 
	------------------------------
		-- Wind Shear
		function self.castWindShear(thisUnit)
			local thisUnit = thisUnit
			if self.level>=16 and self.powerPercent>9.4 and getSpellCD(self.spell.windShear)==0 and getDistance(thisUnit)<25 then
				if castSpell(thisUnit,self.spell.windShear,false,false,false) then return end
			end
		end

	--------------------------
	--- SPELLS - DEFENSIVE ---
	--------------------------
		-- Ancestral Guidance
		function self.castAncestralGuidance()
			if self.talent.ancestralGuidance and self.cd.ancestralGuidance==0 then
				if castSpell("player",self.spell.ancestralGuidance,false,false,false) then return end
			end
		end
		-- Astral Shift
		function self.castAstralShift()
			if self.talent.astralShift and self.cd.astralShift==0 then
				if castSpell("player",self.spell.astralShift,false,false,false) then return end
			end
		end
		-- Healing Rain
		function self.castHealingRain(hpPercent,numOfUnits)
			local hpPercent = hpPercent
			local numOfUnits = numOfUnits
			if self.level>=60 and self.cd.healingRain==0 and self.powerPercent>21.6 then
		        if castHealGround(self.spell.healingRain,18,hpPercent,numOfUnits) then return end
		        --if castAoEHeal(self.spell.healingRain,numOfUnits,hpPercent,40) then return; end
		   	end
		end
		-- Healing Surge
		function self.castHealingSurge(thisUnit)
			local thisUnit = thisUnit
			if self.level>=7 and self.powerPercent>20.7 and UnitIsFriend(thisUnit,"player") and getDistance(thisUnit)<40 then
				if castSpell(thisUnit,self.spell.healingSurge,false,false,false) then return end
			end 
		end
		-- Shamanistic Rage
		function self.castShamanisticRage()
			if self.level>=65 and self.cd.shamanisticRage==0 then
				if castSpell("player",self.spell.shamanisticRage,false,false,false) then return end
			end
		end

	--------------------------
	--- SPELLS - OFFENSIVE ---
	--------------------------
		-- Ancestral Swiftness
		function self.castAncestralSwiftness()
			if self.level>=60 and self.cd.ancestralSwiftness==0 then
				if castSpell("player",self.spell.ancestralSwiftness,false,false,false) then return end
			end
		end
		function self.castAscendance()
			if self.cd.ascendance ==0 then
				if castSpell("player",self.spell.ascendance,false,false,false) then return end
			end
		end
		-- Chain Lightning
		function self.castChainLightning()
			local hasThreat = hasThreat(self.units.dyn30)
			if self.level>=28 and self.powerPercent>1 and getDistance(self.units.dyn30)<30 and (hasThreat or isDummy()) and self.shouldBolt() then
				if castSpell(self.units.dyn30,self.spell.chainLightning,false,false,false) then return end
			end
		end
		-- Elemental Blast
		function self.castElementalBlast()
			if self.talent.elementalBlast and self.cd.elementalBlast==0 and getDistance(self.units.dyn40)<40 then
				if castSpell(self.units.dyn40,self.spell.elementalBlast,false,false,false) then return end
			end
		end
		-- Elemental Mastery
		function self.castElementalMastery()
			if self.talent.elementalMastery and self.cd.elementalMastery==0 then
				if castSpell("player",self.spell.elementalMastery,false,false,false) then return end
			end
		end
		-- Flame Shock
		function self.castFlameShock(thisUnit)
			if thisUnit == nil then thisUnit = self.units.dyn25 end
			local hasThreat = hasThreat(thisUnit)
			if self.level>=12 and self.cd.flameShock==0 and self.powerPercent>1.25 and getDistance(thisUnit)<25 and (hasThreat or isDummy()) then
				if castSpell(thisUnit,self.spell.flameShock,false,false,false) then return end
			end
		end
		-- Frost Shock
		function self.castFrostShock()
			local hasThreat = hasThreat(self.units.dyn25)
			if self.level>=22 and self.cd.frostShock==0 and self.powerPercent>=1.25 and getDistance(self.units.dyn25)<25 and (hasThreat or isDummy()) then
				if castSpell(self.units.dyn25,self.spell.frostShock,false,false,false) then return end
			end
		end
		-- Heroism/Bloodlust
		function self.castHeroLust()
			if self.level>=70 and self.powerPercent>21.5 and not self.debuff.exhaustion then
				if self.faction == "Alliance" and self.cd.heroism==0 then
					if castSpell("player",self.spell.heroism,false,false,false) then return end
				end
				if self.faction == "Horde" and self.cd.bloodlust==0 then
					if castSpell("player",self.spell.bloodlust,false,false,false) then return end
				end
			end
		end
		-- Lightning Bolt
		function self.castLightningBolt()
			local hasThreat = hasThreat(self.units.dyn30)
			if self.level>=1 and self.powerPercent>1.75 and getDistance(self.units.dyn30)<30 and (hasThreat or isDummy()) and self.shouldBolt() then
				if castSpell(self.units.dyn30,self.spell.lightningBolt,false,false,false) then return end
			end
		end
		-- Lightning Shield
		function self.castLightningShield()
			if self.level>=8 then
				if castSpell("player",self.spell.lightningShield,false,false,false) then return end
			end
		end
		-- Liquid Magma
		function self.castLiquidMagma()
			if self.talent.liquidMagma and self.cd.liquidMagma==0 then
				if castSpell("player",self.spell.liquidMagma,false,false,false) then return end
			end
		end

	-----------------------
	--- SPELLS - TOTEMS ---
	-----------------------
		-- Capacitor Totem
		function self.castCapacitorTotem()
			if self.level>=63 and self.cd.capacitorTotem==0 and self.powerPercent>5 then
				if castSpell("player",self.spell.capacitorTotem,false,false,false) then return end
			end
		end
		-- Earthbind Totem
		function self.castEarthbindTotem()
			if not self.talent.earthgrabTotem and self.level>=26 and self.cd.earthbindTotem==0 and self.powerPercent>5.9 then
				if castSpell("player",self.spell.earthbindTotem,false,false,false) then return end
			end
		end
		-- Earth Elemental Totem
		function self.castEarthElementalTotem()
			if self.level>=58 and self.cd.earthElementalTotem==0 and self.powerPercent>28.1 then
				if castSpell("player",self.spell.earthElementalTotem,false,false,false) then return end
			end
		end
		-- Earthgrab Totem
		function self.castEarthgrabTotem()
			if self.talent.earthgrabTotem and self.cd.earthgrabTotem==0 and self.powerPercent>5 then
				if castSpell("player",self.spell.earthgrabTotem,false,false,false) then return end
			end
		end
		-- Fire Elemental Totem
		function self.castFireElementalTotem()
			if self.level>=66 and self.cd.fireElementalTotem==0 and self.powerPercent>26.9 then
				if castSpell("player",self.spell.fireElementalTotem,false,false,false) then return end
			end
		end
		-- Grounding Totem
		function self.castGroundingTotem()
			if self.level>=38 and self.cd.groundingTotem==0 and self.powerPercent>5.9 then
				if castSpell("player",self.spell.groundingTotem,false,false,false) then return end
			end
		end
		-- Healing Stream Totem
		function self.castHealingStreamTotem()
			if self.level>=30 and getSpellCD(5394) ==0 then 
				if castSpell("player",self.spell.healingStreamTotem,false,false,false) then return end
			end
		end
		-- Searing Totem
		function self.castSearingTotem()
			if self.level>=16 
				and ((not self.totem.searingTotem) or (self.totem.searingTotem and ObjectExists(self.units.dyn10AoE) and getTotemDistance(self.units.dyn10AoE)>=25 and getDistance(self.units.dyn10AoE)<25)) 
				and self.powerPercent>3 and ObjectExists(self.units.dyn10AoE) and getTimeToDie(self.units.dyn10AoE)>5 and (#getEnemies(self.units.dyn10AoE,10)==1 or BadBoy_data['AoE'] == 3) 
			then
				if castSpell("player",self.spell.searingTotem,false,false,false) then return end
			end
		end
		-- Storm Elemental Totem
		function self.castStormElementalTotem()
			if self.talent.stormElementalTotem and self.cd.stormElementalTotem==0 and self.powerPercent>26.9 then
				if castSpell("player",self.spell.stormElementalTotem,false,false,false) then return end
			end
		end
		-- Tremor Totem
		function self.castTremorTotem()
			if self.level>=54 and self.cd.tremorTotem==0 and self.powerPercent>2.3 then
				if castSpell("player",self.spell.tremorTotem,false,false,false) then return end
			end
		end

	------------------------
	--- SPELLS - UTILITY ---
	------------------------
		-- Ancestral Spirit
		function self.castAncestralSpirit()
			if self.level>=18 and self.power>50 and not self.inCombat and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and getDistance("mouseover")<40 then
				if castSpell("mouseover",self.spell.ancestralSpirit,false,false,false,false,true) then return end
			end
		end
		-- Cleanse Spirit
		function self.castCleanseSpirit(thisUnit)
			local thisUnit = thisUnit
			if self.level>=18 and self.cd.cleanseSpirit==0 and UnitIsPlayer(thisUnit) and UnitIsFriend(thisUnit,"player") then
				if castSpell(thisUnit,self.spell.cleanseSpirit,false,false,false) then return end
			end
		end
		-- Ghost Wolf
		function self.castGhostWolf()
			if self.level>=15 and not self.buff.ghostWolf and self.powerPercent>7.2 then
				if castSpell("player",self.spell.ghostWolf,false,false,false) then return end
			end
		end
		-- Purge
		function self.castPurge()
			if self.level>=12 and self.powerPercent>16.4 and getDistance("target")<30 then
				if castSpell("target",self.spell.purge,false,false,false) then return end
			end
		end
		-- Spirit Walk
		function self.castSpiritWalk()
			if self.level>=60 and self.cd.spiritWalk==0 and self.powerPercent>1.5 then
				if castSpell("player",self.spell.spiritWalk,false,false,false) then return end
			end
		end
		-- Totemic Recall
		function self.castTotemicRecall()
			if self.level>=30 and self.totem.exist then
				if castSpell("player",self.spell.totemicRecall,false,false,false) then return end
			end
		end
		-- Water Walking
		function self.castWaterWalking()
			if self.level>=24 and not self.buff.waterWalking and self.powerPercent>3.5 then
				if castSpell("player",self.spell.waterWalking,false,false,false) then return end
			end
		end

		function self.shouldBolt()
            --local self = enhancementShaman
            local lightning = 0
            local lowestCD = 0
            if useAoE() then
                if self.cd.chainLightning==0 and self.level>=28 then
                    if self.buff.ancestralSwiftness and (select(7,GetSpellInfo(self.spell.chainLightning))/1000)<10 then
                        lightning = 0
                    else
                        lightning = select(7,GetSpellInfo(self.spell.chainLightning))/1000
                    end
                else
                    if self.buff.ancestralSwiftness and select(7,GetSpellInfo(self.spell.lightningBolt)/1000)<10 then
                        lightning = 0
                    else
                        lightning = select(7,GetSpellInfo(self.spell.lightningBolt))/1000
                    end
                end
            else
                if self.buff.ancestralSwiftness and select(7,GetSpellInfo(self.spell.lightningBolt)/1000)<10 then
                    lightning = 0
                else
                    lightning = select(7,GetSpellInfo(self.spell.lightningBolt))/1000
                end
            end
            if self.level < 3 then
                lowestCD = lightning+1
            elseif self.level < 10 then
                lowestCD = min(self.cd.primalStrike)
            elseif self.level < 12 then
                lowestCD = min(self.cd.primalStrike,self.cd.lavaLash)
            elseif self.level < 26 then
                lowestCD = min(self.cd.primalStrike,self.cd.lavaLash,self.cd.flameShock)
            elseif self.level < 81 then
                lowestCD = min(self.cd.stormstrike,self.cd.lavaLash,self.cd.flameShock)
            elseif self.level < 87 then
                lowestCD = min(self.cd.stormstrike,self.cd.lavaLash,self.cd.flameShock,self.cd.unleashElements)
            elseif self.level >= 87 then
                if self.buff.remain.ascendance > 0 then
                    lowestCD = min(self.cd.windstrike,self.cd.lavaLash,self.cd.flameShock,self.cd.unleashElements)
                else
                    lowestCD = min(self.cd.stormstrike,self.cd.lavaLash,self.cd.flameShock,self.cd.unleashElements)
                end
            end
            if (lightning <= lowestCD or lightning <= self.gcd) and getTimeToDie("target") >= lightning then
                return true
            elseif castingUnit("player") and (isCastingSpell(self.spell.lightningBolt) or isCastingSpell(self.spell.chainLightning)) and lightning > lowestCD then
                StopCasting()
                return false
            else
                return false
            end
        end

	-- Return
		return self
	end

end -- End Select 