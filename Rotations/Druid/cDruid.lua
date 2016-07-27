-- Inherit from: ../cCharacter.lua
-- All Druid specs inherit from this file
if select(2, UnitClass("player")) == "DRUID" then
	cDruid = {}
	-- Creates Druid with given specialisation
	function cDruid:new(spec)
		local self = cCharacter:new("Druid")

		local player = "player" -- if someone forgets ""

	-----------------
    --- VARIABLES ---
    -----------------

		self.profile         = spec
		self.comboPoints     = getCombo("player")
		self.stealth		 = false
		self.artifact 		 = {}
		self.artifact.perks  = {}
		self.buff.duration	 = {}		-- Buff Durations
		self.buff.remain 	 = {}		-- Buff Time Remaining
		self.castable        = {}        -- Cast Spell Functions
		self.debuff.duration = {}		-- Debuff Durations
		self.debuff.remain 	 = {}		-- Debuff Time Remaining
		self.druidAbilities	 = { 		-- Abilities Available To All Druids
			-- Actions
			bearForm 					= 5487,
			catForm 					= 768,
			dash 						= 1850,
			dreamwalk 					= 193753,
			entanglingRoots 			= 339,
			flightForm 					= 165962,
			growl 						= 6795,
			moonfire 					= 8921,
			rebirth 					= 20484,
			revive 						= 50769,
			stagForm 					= 210053,
			travelForm 					= 783,
		}
		self.druidArtifacts  = {		-- Artifact Traits Available To All Druids
			artificialStamina 			= 211309,
		}
		self.druidBuffs 	 = {		-- Buffs Available To All Druids
			bearFormBuff 				= 5487,
			catFormBuff					= 768,
			dashBuff 					= 1850,
			displacerBeastBuff 			= 137452,
			flightFormBuff 				= 165962,
			prowlBuff 					= 5215,
			stagFormBuff 				= 210053,
			travelFormBuff 				= 783,
		}
		self.druidDebuffs 	 = {		-- Debuffs Available To All Druids
			entanglingRootsDebuff 		= 339,
			growlDebuff 				= 6795,
			moonfireDebuff 				= 8921,
		}
		self.druidGlyphs 	 = {		-- Glyphs Available To All Druids
			glyphOfTheCheetah 			= 131113,
			glyphOfTheDoe 				= 224122,
			glyphOfTheFeralChameleon 	= 210333,
			glyphOfTheOrca 				= 114333,
			glyphOfTheSentinel 			= 219062,
			glyphOfTheUrsolChameleon 	= 107059,
		}
		self.druidSpecials 	 = { 		-- Specializations Available To All Druids
			healingTouch 				= 5185,
			prowl 						= 5215,
		}
		self.druidTalents 	 = {		-- Talents Available To All Druids
			-- Ability
			displacerBeast 				= 102280,
			massEntanglement 			= 102359,
			mightyBash 					= 5211,
			typhoon 					= 132469,
			wildCharge 					= 102401,
		}
		-- Merge all spell tables into self.druidSpell
		self.druidSpell = {} 
		self.druidSpell = mergeTables(self.druidSpell,self.druidAbilities)
		self.druidSpell = mergeTables(self.druidSpell,self.druidArtifacts)
		self.druidSpell = mergeTables(self.druidSpell,self.druidBuffs)
		self.druidSpell = mergeTables(self.druidSpell,self.druidDebuffs)
		self.druidSpell = mergeTables(self.druidSpell,self.druidGlyphs)
		self.druidSpell = mergeTables(self.druidSpell,self.druidSpecials)
		self.druidSpell = mergeTables(self.druidSpell,self.druidTalents) 

    ------------------
    --- OOC UPDATE ---
    ------------------

		function self.classUpdateOOC()
			-- Call baseUpdateOOC()
			self.baseUpdateOOC()
			self.getClassArtifacts()
			self.getClassArtifactRanks()
			self.getClassGlyphs()
			self.getClassTalents()
			self.getClassPerks()
		end

    --------------
    --- UPDATE ---
    --------------

		function self.classUpdate()
			-- Call baseUpdate()
			self.baseUpdate()
			self.getClassDynamicUnits()
			self.getClassBuffs()
			self.getClassBuffsRemain()
			self.getClassBuffsDuration()
			self.getClassCharges()
			self.getClassCooldowns()
			self.getClassDebuffs()
			self.getClassDebuffsRemain()
			self.getClassDebuffsDuration()
			self.getClassCastable()

			-- Update Combo Points
			self.comboPoints = UnitPower("player",4)

	        -- Update Energy Regeneration
	        self.powerRegen  = getRegen("player")

			-- Stealth
			if self.race == "Night Elf" then
				self.stealth = UnitBuffID("player",self.spell.prowl) or UnitBuffID("player",self.racial)
			else
				self.stealth = UnitBuffID("player",self.spell.prowl)
			end
		end

	---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getClassDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn15 = dynamicTarget(15,true) -- Typhoon

            -- AoE
            self.units.dyn35AoE = dynamicTarget(35, false) -- Entangling Roots
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

    	function self.getClassArtifacts()
    		local isKnown = isKnown

    		self.artifact.artificialStamina = isKnown(self.spell.artificialStamina)
    	end

    	function self.getClassArtifactRanks()

    	end

    -------------
    --- BUFFS ---
    -------------
	
		function self.getClassBuffs()
			local UnitBuffID = UnitBuffID

			self.buff.bearForm 				= UnitBuffID("player",self.spell.bearFormBuff)~=nil or false
			self.buff.catForm 				= UnitBuffID("player",self.spell.catFormBuff)~=nil or false
			self.buff.dash 					= UnitBuffID("player",self.spell.dash)~=nil or false
			self.buff.displacerBeast		= UnitBuffID("player",self.spell.displacerBeastBuff)~=nil or false
			self.buff.flightForm 			= UnitBuffID("player",self.spell.flightFormBuff)~=nil or false
			self.buff.prowl 				= UnitBuffID("player",self.spell.prowlBuff)~=nil or false
			self.buff.stagForm 				= UnitBuffID("player",self.spell.stagFormBuff)~=nil or false
			self.buff.travelForm 			= UnitBuffID("player",self.spell.travelFormBuff)~=nil or false
		end

		function self.getClassBuffsDuration()
			local getBuffDuration = getBuffDuration

			self.buff.duration.dash					= getBuffDuration("player",self.spell.dash) or 0
			self.buff.duration.displacerBeast 		= getBuffDuration("player",self.spell.displacerBeastBuff) or 0
		end

		function self.getClassBuffsRemain()
			local getBuffRemain = getBuffRemain

			self.buff.remain.dash 					= getBuffRemain("player",self.spell.dash) or 0
			self.buff.remain.displacerBeast			= getBuffRemain("player",self.spell.displacerBeastBuff) or 0
		end

	---------------
	--- CHARGES ---
	---------------
		function self.getClassCharges()
			local getCharges = getCharges

			-- self.charges.survivalInstincts = getCharges(self.spell.survivalInstincts)
		end

	-----------------
	--- COOLDOWNS ---
	-----------------

		function self.getClassCooldowns()
			local getSpellCD = getSpellCD

			self.cd.dash 					= getSpellCD(self.spell.dash)
			self.cd.displacerBeast 			= getSpellCD(self.spell.displacerBeast)
			self.cd.growl 					= getSpellCD(self.spell.growl)
			self.cd.mightyBash 				= getSpellCD(self.spell.mightyBash)
			self.cd.prowl 					= getSpellCD(self.spell.prowl)
			self.cd.rebirth 				= getSpellCD(self.spell.rebirth)
			self.cd.typhoon 				= getSpellCD(self.spell.typhoon)
			self.cd.wildCharge 				= getSpellCD(self.spell.wildCharge)
		end

	---------------
	--- DEBUFFS ---
	---------------

		function self.getClassDebuffs()
			local UnitDebuffID = UnitDebuffID

			self.debuff.entanglingRoots 	= UnitDebuffID(self.units.dyn35AoE,self.spell.entanglingRootsDebuff,"player")~=nil or false
			self.debuff.moonfire 			= UnitDebuffID(self.units.dyn40AoE,self.spell.moonfireDebuff,"player")~=nil or false
			self.debuff.growl 				= UnitDebuffID(self.units.dyn30AoE,self.spell.growlDebuff,"player")~=nil or false
		end

		function self.getClassDebuffsDuration()
			local getDebuffDuration = getDebuffDuration

			self.debuff.duration.entanglingRoots 	= getDebuffRemain(self.units.dyn35AoE,self.spell.entanglingRootsDebuff,"player") or 0
			self.debuff.duration.moonfire 			= getDebuffRemain(self.units.dyn40AoE,self.spell.moonfireDebuff,"player") or 0
			self.debuff.duration.growl 				= getDebuffRemain(self.units.dyn30AoE,self.spell.growlDebuff,"player") or 0
		end

		function self.getClassDebuffsRemain()
			local getDebuffRemain = getDebuffRemain

			self.debuff.remain.entanglingRoots 			= getDebuffRemain(self.units.dyn35AoE,self.spell.entanglingRootsDebuff,"player") or 0
			self.debuff.remain.moonfire					= getDebuffRemain(self.units.dyn40AoE,self.spell.moonfireDebuff,"player") or 0
			self.debuff.remain.growl 					= getDebuffRemain(self.units.dyn30AoE,self.spell.growlDebuff,"player") or 0
		end

	--------------
	--- GLYPHS ---
	--------------

		function self.getClassGlyphs()
			local hasGlyph = hasGlyph

			-- self.glyph.cheetah 			= hasGlyph(self.spell.glyphOfTheCheetah)
			-- self.glyph.doe 				= hasGlyph(self.spell.glyphOfTheDoe)
			-- self.glyph.feralChameleon 	= hasGlyph(self.spell.glyphOfTheFeralChameleon)
			-- self.glyph.orca 			= hasGlyph(self.spell.glyphOfTheOrca)
			-- self.glyph.sentinel 		= hasGlyph(self.spell.glyphOfTheSentinel)
			-- self.glyph.ursolChameleon 	= hasGlyph(self.spell.glyphOfTheUrsolChameleon)
		end

	----------------
	--- TAALENTS ---
	----------------

		function self.getClassTalents()
			local getTalent = getTalent

			self.talent.displacerBeast 		= getTalent(2,2)
			self.talent.wildCharge 			= getTalent(2,3)
			self.talent.mightyBash 			= getTalent(4,1)
			self.talent.massEntanglement 	= getTalent(4,2)
			self.talent.typhoon 			= getTalent(4,3)
		end
			
	-------------
	--- PERKS ---
	-------------

		function self.getClassPerks()
			local isKnown = isKnown

			-- self.perk.enhancedRebirth = isKnown(self.spell.enhancedRebirth)
		end

	---------------
	--- OPTIONS ---
	---------------

		-- Class options
		-- Options which every Druid should have
		function self.createClassOptions()
            -- Class Wrap
            local section = bb.ui:createSection(bb.ui.window.profile,  "Class Options", "Nothing")
            bb.ui:checkSectionState(section)
		end

	--------------
	--- SPELLS ---
	--------------

		function self.getClassCastable()

		end

		---------------------
		--- CROWD CONTROL ---
		---------------------

		-- Entangling Roots
		function self.castEntanglingRoots()
			if self.level>=22 and self.powerPercentMana>6.5 and hasThreat(self.units.dyn35AoE) and getDistance(self.units.dyn35AoE)<35 then
				if castSpell(self.units.dyn35AoE,self.spell.entanglingRoots,false,false,false) then return end
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
		
		-----------------
		--- DEFENSIVE ---
		-----------------

		-- Healing Touch - Set target via thisUnit variable
		function self.castHealingTouch(thisUnit)
			local isLivePlayer = UnitIsPlayer(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and UnitIsFriend(thisUnit,"player")
			
			if self.level>=26 and self.powerPercentMana>10.35 and isLivePlayer and getDistance(thisUnit)<40 then
				if castSpell(thisUnit,self.spell.healingTouch,false,false,false) then return end
			end
		end
		
		-------------
		--- FORMS ---
		-------------

		-- Bear Form
		function self.castBearForm()
			if self.level>=8 then
				if castSpell("player",self.spell.bearForm,false,false,false) then return end
			end
		end
		-- Cat Form
		function self.castCatForm()
			if self.level>=1 then
				if castSpell("player",self.spell.catForm,false,false,false) then return end
			end
		end
		-- Flight Form
		function self.castFlightForm()
			if self.level>=58 and not self.inCombat then
				if castSpell("player",self.spell.flightForm,false,false,false) then return end
			end
		end
		-- Stag Form
		function self.castStagForm()
			if self.level>=40 then
				if castSpell("player",self.spell.flightForm,false,false,false) then return end
			end
		end
		-- Travel Form
		function self.castTravelForm()
			if self.level>=16 then
				if castSpell("player",self.spell.travelForm,false,false,false) then return end
			end
		end

		-----------------
		--- OFFENSIVE ---
		-----------------

		-- Moonfire - Set target via thisUnit variable
		function self.castMoonfire(thisUnit)
			if self.level>=10 and self.powerPercentMana>1.5 and hasThreat(thisUnit) and getDistance(thisUnit)<40 then
				if castSpell(thisUnit,self.spell.moonfire,false,false,false) then return end
			end
		end
		
		---------------
		--- UTILITY ---
		---------------

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
			if self.level>=5 and self.cd.prowl==0 and not self.buff.prowl then
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

			if self.level>=12 and self.powerPercentMana>4 and not self.inCombat and isDeadPlayer and getDistance(thisUnit)<40 then
				if castSpell(thisUnit,self.spell.revive,false,false,false,false,true) then return end
			end
		end
		-- Wild Charge - Set target via thisUnit variable
		function self.castWildCharge(thisUnit)
			if self.talent.wildCharge and self.cd.wildCharge==0 and getDistance(thisUnit)>=8 and (hasThreat(thisUnit) or self.instance=="none") and getDistance(thisUnit)<25 then
				if castSpell(thisUnit,self.spell.wildCharge,false,false,false) then return end
			end
		end

		-- Return
		return self
	end --End function cDruid:new(spec)
end -- End Select 