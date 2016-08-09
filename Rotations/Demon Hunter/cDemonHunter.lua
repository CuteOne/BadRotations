-- Inherit from: ../cCharacter.lua
-- All Death Knight specs inherit from this file
if select(2, UnitClass("player")) == "DEMONHUNTER" then
cDemonHunter = {}

-- Creates Death Knight with given specialisation
function cDemonHunter:new(spec)
	local self = cCharacter:new("Demon Hunter")

	local player = "player" -- if someone forgets ""

	self.profile         = spec
    self.powerRegen      = getRegen("player")
	self.buff.duration	 = {}		-- Buff Durations
	self.buff.remain 	 = {}		-- Buff Time Remaining
	self.debuff.duration = {}		-- Debuff Durations
	self.debuff.remain 	 = {}		-- Debuff Time Remaining
	self.demonHunterSpell = {

	}

-- Update OOC
	function self.classUpdateOOC()
		-- Call baseUpdateOOC()
		self.baseUpdateOOC()
		self.getClassGlyphs()
		self.getClassTalents()
	end

-- Update 
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
	end

-- Dynamic Units updates
	function self.getClassDynamicUnits()
		local dynamicTarget = dynamicTarget

		self.units.dyn8AoE 	= dynamicTarget(8, false)
		self.units.dyn10 	= dynamicTarget(10, true)
		self.units.dyn10AoE = dynamicTarget(10, false)
		self.units.dyn12 	= dynamicTarget(12, true)
		self.units.dyn15 	= dynamicTarget(15, true)
		self.units.dyn20AoE = dynamicTarget(20, false)
	end

-- Buff updates
	function self.getClassBuffs()
		local UnitBuffID = UnitBuffID

		-- self.buff.bloodPresence 		= UnitBuffID("player",self.spell.bloodPresenceBuff)~=nil or false
	end	

	function self.getClassBuffsDuration()
		local getBuffDuration = getBuffDuration

		-- self.buff.duration.breathOfSindragosa 	= getBuffDuration("player",self.spell.breathOfSindragosaBuff) or 0
	end

	function self.getClassBuffsRemain()
		local getBuffRemain = getBuffRemain

		-- self.buff.remain.breathOfSindragosa = getBuffRemain("player",self.spell.breathOfSindragosaBuff) or 0
	end

	function self.getClassCharges()
		local getBuffStacks 	= getBuffStacks
		local getDebuffStacks 	= getDebuffStacks

		-- self.charges.bloodTap 		= getBuffStacks("player",self.spell.bloodCharge,"player")
	end

-- Cooldown updates
	function self.getClassCooldowns()
		local getSpellCD = getSpellCD

		-- self.cd.antiMagicShell 		= getSpellCD(self.spell.antiMagicShell)
	end

-- Debuff updates
	function self.getClassDebuffs()
		local UnitDebuffID = UnitDebuffID

		-- self.debuff.bloodPlague 		= UnitDebuffID(self.units.dyn5,self.spell.bloodPlagueDebuff,"player")~=nil or false
	end

	function self.getClassDebuffsDuration()
		local getDebuffDuration = getDebuffDuration

		-- self.debuff.duration.bloodPlague 		= getDebuffDuration(self.units.dyn5,self.spell.bloodPlagueDebuff,"player") or 0
	end

	function self.getClassDebuffsRemain()
		local getDebuffRemain = getDebuffRemain

		-- self.debuff.remain.bloodPlague 			= getDebuffRemain(self.units.dyn5,self.spell.bloodPlagueDebuff,"player") or 0
	end

-- Glyph updates
	function self.getClassGlyphs()
		local hasGlyph = hasGlyph

		-- self.glyph.shiftingPresences = hasGlyph(self.spell.shiftingPresencesGlyph)
	end

-- Talent updates
	function self.getClassTalents()
		local getTalent = getTalent

		-- self.talent.plagueLeech 		= getTalent(1,2)
	end

---------------
--- OPTIONS ---
---------------

	-- Class options
	-- Options which every Rogue should have
	function self.createClassOptions()

        -- Class Wrap
        local section = bb.ui:createSection(bb.ui.window.profile,  "Class Options")
        
        bb.ui:checkSectionState(section)
	end

--------------
--- SPELLS --- 
--------------

------------------------
--- CUSTOM FUNCTIONS ---
------------------------


-- Return
	return self
end

end -- End Select 