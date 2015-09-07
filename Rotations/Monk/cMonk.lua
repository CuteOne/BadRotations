-- Inherit from: ../cCharacter.lua
-- All Monk specs inherit from this file
if select(2, UnitClass("player")) == "MONK" then
cMonk = {}

-- Creates Monk with given specialisation
function cMonk:new(spec)
	local self = cCharacter:new("Monk")

	local player = "player" -- if someone forgets ""

	self.profile         = spec
    self.powerRegen      = getRegen("player")
	self.buff.duration	 = {}		-- Buff Durations
	self.buff.remain 	 = {}		-- Buff Time Remaining
	self.debuff.duration = {}		-- Debuff Durations
	self.debuff.remain 	 = {}		-- Debuff Time Remaining
	self.monkSpell = {

		-- Ability - Crowd Control

        -- Ability - Defensive

        -- Ability - Forms

        -- Ability - Offensive

        -- Ability - Presense

        -- Ability - Utility

        -- Buff - Defensive

        -- Buff - Forms

        -- Buff - Offensive

        -- Buff - Presense

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

		-- self.buff.frostPresense 	= UnitBuffID("player",self.spell.frostPresenseBuff)~=nil or false 
	end	

	function self.getClassBuffsDuration()
		local getBuffDuration = getBuffDuration

		-- self.buff.duration.hornOfWinter = getDebuffDuration("player",self.spell.hornOfWinterBuff) or 0
	end

	function self.getClassBuffsRemain()
		local getBuffRemain = getBuffRemain

		-- self.buff.remain.hornOfWinter = getBuffRemain("player",self.spell.hornOfWinterBuff) or 0
	end

	function self.getClassCharges()
		local getBuffStacks = getBuffStacks

		-- self.charges.anticipation = getBuffStacks("player",self.spell.anticipationBuff,"player")
	end

-- Cooldown updates
	function self.getClassCooldowns()
		local getSpellCD = getSpellCD

		-- self.cd.defile = getSpellCD(self.spell.defile)
	end

-- Debuff updates
	function self.getClassDebuffs()
		local UnitDebuffID = UnitDebuffID

		-- self.debuff.defile = UnitDebuffID(self.units.dyn30AoE,self.spell.defileDebuff,"player")~=nil or false
	end

	function self.getClassDebuffsDuration()
		local getDebuffDuration = getDebuffDuration

		-- self.debuff.duration.defile = getDebuffDuration(self.units.dyn30AoE,self.spell.defileDebuff,"player") or 0
	end

	function self.getClassDebuffsRemain()
		local getDebuffRemain = getDebuffRemain

		-- self.debuff.remain.defile = getDebuffRemain(self.units.dyn30AoE,self.spell.defileDebuff,"player") or 0
	end

-- Glyph updates
	function self.getClassGlyphs()
		local hasGlyph = hasGlyph

		-- self.glyph.disappearance 	= hasGlyph(self.spell.disappearanceGlyph)
	end

-- Talent updates
	function self.getClassTalents()
		local getTalent = getTalent

		-- self.talent.defile = getTalent(7,2)
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