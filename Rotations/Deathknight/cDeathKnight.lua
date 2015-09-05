-- Inherit from: ../cCharacter.lua
-- All Death Knight specs inherit from this file
if select(2, UnitClass("player")) == "DEATHKNIGHT" then
cDK = {}

-- Creates Paladin with given specialisation
function cDK:new(spec)
	local self = cCharacter:new("Death Knight")

	local player = "player" -- if someone forgets ""

	self.profile         = spec
    self.powerRegen      = getRegen("player")
	self.buff.duration	 = {}		-- Buff Durations
	self.buff.remain 	 = {}		-- Buff Time Remaining
	self.debuff.duration = {}		-- Debuff Durations
	self.debuff.remain 	 = {}		-- Debuff Time Remaining
	self.rune 			 = {}		-- Rune Info
	self.rune.count		 = {} 		-- Rune Count
	self.rune.percent 	 = {}		-- Rune Percent
	self.dkSpell = {

		-- Ability - Crowd Control

        -- Ability - Defensive

        -- Ability - Forms

        -- Ability - Offensive  
        hornOfWinter 		= 57330,

        -- Ability - Presense
        frostPresense 		= 48266,      

        -- Ability - Utility

        -- Buff - Defensive

        -- Buff - Forms

        -- Buff - Offensive
        hornOfWinterBuff 	= 57330, 

        -- Buff - Presense
        frostPresenseBuff 	= 48266,

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
		self.getRunes()
		self.getRuneCounts()
		self.getRunePercents()
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

		self.buff.frostPresense 	= UnitBuffID("player",self.spell.frostPresenseBuff)~=nil or false 
		self.buff.hornOfWinter 		= UnitBuffID("player",self.spell.hornOfWinterBuff)~=nil or false
	end	

	function self.getClassBuffsDuration()
		local getBuffDuration = getBuffDuration

		self.buff.duration.hornOfWinter = getDebuffDuration("player",self.spell.hornOfWinterBuff) or 0
	end

	function self.getClassBuffsRemain()
		local getBuffRemain = getBuffRemain

		self.buff.remain.hornOfWinter = getBuffRemain("player",self.spell.hornOfWinterBuff) or 0
	end

	function self.getClassCharges()
		local getBuffStacks = getBuffStacks

		-- self.charges.anticipation = getBuffStacks("player",self.spell.anticipationBuff,"player")
	end

-- Cooldown updates
	function self.getClassCooldowns()
		local getSpellCD = getSpellCD

		-- self.cd.blind 			 = getSpellCD(self.spell.blind)
	end

-- Debuff updates
	function self.getClassDebuffs()
		local UnitDebuffID = UnitDebuffID

		-- self.debuff.blind 				= UnitDebuffID(self.units.dyn15,self.spell.blindDebuff,"player")~=nil or false
	end

	function self.getClassDebuffsDuration()
		local getDebuffDuration = getDebuffDuration

		-- self.debuff.duration.blind 				= getDebuffDuration(self.units.dyn15,self.spell.blindDebuff,"player") or 0
	end

	function self.getClassDebuffsRemain()
		local getDebuffRemain = getDebuffRemain

		-- self.debuff.remain.blind 			= getDebuffRemain(self.units.dyn15,self.spell.blindDebuff,"player") or 0
	end

-- Glyph updates
	function self.getClassGlyphs()
		local hasGlyph = hasGlyph

		-- self.glyph.disappearance 	= hasGlyph(self.spell.disappearanceGlyph)
	end

-- Talent updates
	function self.getClassTalents()
		local getTalent = getTalent

		-- self.talent.deadlyThrow 	 = getTalent(2,1)
	end

-- Rune Updates
	function self.getRunes()
		local getRuneInfo = getRuneInfo

		self.rune.info = getRuneInfo()
	end

	function self.getRuneCounts()
		local getRuneCount = getRuneCount

		self.rune.count.death 	= getRuneCount("death")
		self.rune.count.blood 	= getRuneCount("blood")+getRuneCount("death")
		self.rune.count.frost 	= getRuneCount("frost")+getRuneCount("death")
		self.rune.count.unholy 	= getRuneCount("unholy")+getRuneCount("death")
	end

	function self.getRunePercents()
		local getRunePercent = getRunePercent

		self.rune.percent.death 	= getRunePercent("death")
		self.rune.percent.blood 	= getRunePercent("blood")+getRunePercent("death")
		self.rune.percent.frost 	= getRunePercent("frost")+getRunePercent("death")
		self.rune.percent.unholy 	= getRunePercent("unholy")+getRunePercent("death")
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

		-- Class Wrap
		CreateNewWrap(thisConfig, "--- Class Options ---")

        -- Horn of Winter
        CreateNewCheck(thisConfig,"Horn of Winter","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic Horn of Winter usage. When enabled rotation will scan party/raid groups and cast if anyone in range in missing a similar buff.")
        CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.hornOfWinter))))

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
	-- Frost Presense
	function self.castFrostPresense()
		if self.level>=55 then
			if castSpell("player",self.spell.frostPresence,true,false,false) then return end
		end
	end
	-- Horn of Winter
	function self.castHornOfWinter()
		if self.level>=65 then
			if castSpell("player",self.spell.hornOfWinter,true,false,false) then return end
		end
	end

------------------------
--- SPELLS - UTILITY ---
------------------------

-- Return
	return self
end

end -- End Select 