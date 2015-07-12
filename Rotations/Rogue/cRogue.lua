-- Inherit from: ../cCharacter.lua
-- All Rogue specs inherit from this file
if select(2, UnitClass("player")) == "ROGUE" then
cRogue = {}

-- Creates Paladin with given specialisation
function cRogue:new(spec)
	local self = cCharacter:new("Rogue")

	local player = "player" -- if someone forgets ""

	self.profile         = spec
	self.comboPoints     = GetComboPoints("player")
	self.lethalPoison    = nil
	self.nonLethalPoison = nil
	self.poisonTimer     = 10
	self.stealth		 = false
	self.rogueSpell = {
		-- Buff
		anticipation   = 114015, -- TODO: charges ?
		sliceAndDice   = 5171,
		-- Defensive
		cloakOfShadows = 31224,
		evasion        = 5277,
		feint          = 1966,
		recuperate     = 73651,
		sprint         = 2983,
		stealth        = 115191,
		vanish         = 1856,
		-- Offensive
		ambush           = 8676,
		crimsonTempest   = 121411,
		deathFromAbove   = 152150,
		eviscerate       = 2098,
		markedForDeath   = 137619,
		shadowReflection = 152151,
		shiv             = 5938,
		-- Misc
		preparation      = 14185,
		tricksOfTheTrade = 57934,
		-- Poison
		cripplingPoison = 3408,
		deadlyPoison   = 2823,
		leechingPoison = 108211,
		woundPoison = 8679,
	}

-- Update 
	function self.classUpdate()
		-- Call baseUpdate()
		self.baseUpdate()
		self.getClassOptions()
		self.getClassBuffs()
		self.getClassCooldowns()

		-- Update Combo Points
		self.comboPoints = GetComboPoints("player")

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

-- Buff updates
	function self.getClassBuffs()
		local getBuffRemain,getCharges = getBuffRemain,getCharges

		self.buff.cloakOfShadows   = getBuffRemain(player,self.spell.cloakOfShadows)
		self.buff.deadlyPoison     = getBuffRemain(player,self.spell.deadlyPoison)
		self.buff.evasion          = getBuffRemain(player,self.spell.evasion)
		self.buff.feint            = getBuffRemain(player,self.spell.feint)
		self.buff.leechingPoison   = getBuffRemain(player,self.spell.leechingPoison)
		self.buff.recuperate       = getBuffRemain(player,self.spell.recuperate)
		self.buff.shadowReflection = getBuffRemain(player,self.spell.shadowReflection)
		self.buff.sliceAndDice     = getBuffRemain(player,self.spell.sliceAndDice)
		self.buff.sprint           = getBuffRemain(player,self.spell.sprint)
		self.buff.tricksOfTheTrade = getBuffRemain(player,self.spell.tricksOfTheTrade)
		self.buff.vanish           = getBuffRemain(player,self.spell.vanish)

		self.charges.anticipation  = getCharges(self.spell.anticipation)
	end

-- Cooldown updates
	function self.getClassCooldowns()
		local getSpellCD = getSpellCD

		self.cd.cloakOfShadows   = getSpellCD(self.spell.cloakOfShadows)
		self.cd.deathFromAbove   = getSpellCD(self.spell.deathFromAbove)
		self.cd.evasion          = getSpellCD(self.spell.evasion)
		self.cd.markedForDeath   = getSpellCD(self.spell.markedForDeath)
		self.cd.preparation      = getSpellCD(self.spell.preparation)
		self.cd.shadowReflection = getSpellCD(self.spell.shadowReflection)
		self.cd.sprint           = getSpellCD(self.spell.sprint)
		self.cd.stealth          = getSpellCD(self.spell.stealth)
		self.cd.tricksOfTheTrade = getSpellCD(self.spell.tricksOfTheTrade)
		self.cd.vanish           = getSpellCD(self.spell.vanish)
	end

-- Glyph updates
	function self.getClassGlyphs()
		--local hasGlyph = hasGlyph

		--self.glyph.   = hasGlyph()
	end

-- Talent updates
	function self.getClassTalents()
		local isKnown = isKnown

		self.talent.anticipation     = isKnown(self.spell.anticipation)
		self.talent.deathFromAbove   = isKnown(self.spell.deathFromAbove)
		self.talent.markedForDeath   = isKnown(self.spell.markedForDeath)
		self.talent.shadowReflection = isKnown(self.spell.shadowReflection)
	end

-- Class options
-- Options which every Rogue should have
	function self.classOptions()
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
		textOp(" ");
	end

-- Get Class option modes
	function self.getClassOptions()
		self.ignoreCombat = isChecked("Ignore Combat")==true or false
		self.poisonTimer = getValue("Poison remain")
	end

-- Applies Poison
	function self.applyPoison()
		local getValue = getValue

		-------------------
		--- INFORMATION ---
		-------------------
		--- Everybody has Wound Poison hence its always Value 1
		--- If its not selected Deadly will be used (instant for combat)
		--- Everybody has Crippling Poison hence its always Value != 2
		--- If its not selected Leeching will be used
		-----------------------------------------------------------

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

--------------
--- SPELLS ---
--------------

-- Ambush
	function self.castAmbush()
		return castSpell(self.units.dyn5,self.spell.ambush,false,false) == true or false
	end

-- Crimson Tempest
	function self.castCrimsonTempest()
		return castSpell("player",self.spell.crimsonTempest,true,false) == true or false
	end

-- Death From Above
	function self.castDeathFromAbove()
		if self.talent.deathFromAbove then
			return castSpell(self.units.dyn15,self.spell.deathFromAbove,false,false) == true or false
		end
	end

-- Eviscerate
	function self.castEviscerate()
		return castSpell(self.units.dyn5,self.spell.eviscerate,false,false) == true or false
	end

-- Marked for Death
	function self.castMarkedForDeath()
		if self.talent.markedForDeath then
			return castSpell(self.units.dyn30,self.spell.markedForDeath,false,false) == true or false
		end
	end

-- Preparation
	function self.castPreparation()
		return castSpell("player",self.spell.preparation,true,false) == true or false
	end

-- Shadow Reflection
	function self.castShadowReflection()
		if self.talent.shadowReflection then
			return castSpell(self.units.dyn20,self.spell.shadowReflection,false,false) == true or false
		end
	end

-- Shiv
	function self.castShiv()
		return castSpell(self.units.dyn5,self.spell.shiv,false,false) == true or false
	end

-- Slice and Dice
	function self.castSliceAndDice()
		return castSpell("player",self.spell.sliceAndDice,true,false) == true or false
	end

-- Stealth
	function self.castStealth()
		if isChecked("Stealth") then
			return castSpell("player",self.spell.stealth,true,false,false) == true or false
		end
	end

-- Vanish
	function self.castVanish()
		if isSelected("Vanish") then
			if castSpell("player",self.spell.vanish,true,false) then StopAttack(); return end
		end
	end

-- Return
	return self
end

end -- End Select 