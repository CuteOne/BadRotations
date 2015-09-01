-- Inherit from: ../cCharacter.lua
-- All Rogue specs inherit from this file
if select(2, UnitClass("player")) == "DEATH KNIGHT" then
cDeathKnight = {}

-- Creates Paladin with given specialisation
function cRogue:new(spec)
	local self = cCharacter:new("Death Knight")

	local player = "player" -- if someone forgets ""

	self.profile         = spec
    self.powerRegen      = getRegen("player")
	self.buff.duration	 = {}		-- Buff Durations
	self.buff.remain 	 = {}		-- Buff Time Remaining
	self.debuff.duration = {}		-- Debuff Durations
	self.debuff.remain 	 = {}		-- Debuff Time Remaining
	self.deathKnightSpell = {

		-- Ability - Crowd Control


        -- Ability - Defensive

        -- Ability - Forms

        -- Ability - Offensive        

        -- Ability - Utility

        -- Buff - Defensive

        -- Buff - Forms

        -- Buff - Offensive

        -- Buff - Utility

        -- Debuff - Offensive

        -- Debuff - Defensive

        -- Glyphs

        -- Perks

        -- Talents

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

		self.units.dyn10 = dynamicTarget(10, true)
		self.units.dyn15 = dynamicTarget(15, true)
	end

-- Buff updates
	function self.getClassBuffs()
		local UnitBuffID = UnitBuffID

		self.buff.anticipation 	   = UnitBuffID("player",self.spell.anticipationBuff)~=nil or false
	end	

	function self.getClassBuffsDuration()
		local getBuffDuration = getBuffDuration

		self.buff.duration.cloakOfShadows   = getBuffDuration("player",self.spell.cloakOfShadowsBuff) or 0
	end

	function self.getClassBuffsRemain()
		local getBuffRemain = getBuffRemain

		self.buff.remain.cloakOfShadows   = getBuffRemain("player",self.spell.cloakOfShadowsBuff) or 0
	end

	function self.getClassCharges()
		local getBuffStacks = getBuffStacks

		self.charges.anticipation = getBuffStacks("player",self.spell.anticipationBuff,"player")
	end

-- Cooldown updates
	function self.getClassCooldowns()
		local getSpellCD = getSpellCD

		self.cd.blind 			 = getSpellCD(self.spell.blind)
	end

-- Debuff updates
	function self.getClassDebuffs()
		local UnitDebuffID = UnitDebuffID

		self.debuff.blind 				= UnitDebuffID(self.units.dyn15,self.spell.blindDebuff,"player")~=nil or false
	end

	function self.getClassDebuffsDuration()
		local getDebuffDuration = getDebuffDuration

		self.debuff.duration.blind 				= getDebuffDuration(self.units.dyn15,self.spell.blindDebuff,"player") or 0
	end

	function self.getClassDebuffsRemain()
		local getDebuffRemain = getDebuffRemain

		self.debuff.remain.blind 			= getDebuffRemain(self.units.dyn15,self.spell.blindDebuff,"player") or 0
	end

-- Glyph updates
	function self.getClassGlyphs()
		local hasGlyph = hasGlyph

		self.glyph.disappearance 	= hasGlyph(self.spell.disappearanceGlyph)
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

		-- Spacer
		CreateNewText(" ");
	end

------------------------------
--- SPELLS - CROWD CONTROL --- 
------------------------------

--------------------------
--- SPELLS - DEFENSIVE ---
--------------------------

--------------------------
--- SPELLS - OFFENSIVE ---
--------------------------

------------------------
--- SPELLS - UTILITY ---
------------------------

-- Return
	return self
end

end -- End Select 