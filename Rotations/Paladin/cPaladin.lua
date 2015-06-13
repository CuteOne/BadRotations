--- Paladin Class
-- Inherit from: ../cCharacter.lua
-- All Paladin specs inherit from classPaladin.lua

cPaladin = {}

-- Creates Paladin with given specialisation
function cPaladin.new(spec)
	local self = cCharacter.new("Paladin")

	self.profile     = spec
	self.holyPower   = 0
	self.defaultSeal = 1 -- Uses first Seal as default if no one is specified in c_SPEC_.lua
	self.seal        = true
	self.spell = {
		crusaderStrike      = 35395,
		divineShield        = 642,
		eternalFlame        = 114163,
		executionSentence   = 114157,
		exorcism            = 879,
		fistOfJustice       = 105593,
		flashOfLight        = 19750,
		hammerOfJustice     = 853,
		hammerOfWrath       = 24275,
		holyAvenger         = 105809,
		holyPrism           = 114165,
		judgment            = 20271,
		layOnHands          = 633,
		lightsHammer        = 114158,
		rebuke              = 96231,
		repentance          = 20066,
		sacredShield        = 20925,
		sealOfRighteousness = 20154,
		sealOfThruth        = 31801,
		wordOfGlory         = 85673,
	}

-- Update 
	function self.classUpdate()
	-- Call baseUpdate()
		self.baseUpdate()

	-- Holy Power
		self.holyPower = UnitPower("player",9)

	-- Seal check
		self.checkSeal()

	-- Blessing check
		-- TODO
	end

-- Update OOC
	function self.classUpdateOOC()
	-- Call baseUpdateOOC()
		self.baseUpdateOOC()
	end

-- Casts given Seal
	function self.castSeal(seal)
		return castSpell("player",seal,true,false) == true or false
	end

-- Checks if seal is applied; casts given seal or defaultSeal if not
	function self.checkSeal(seal)
		if self.seal == 0 then
			if seal == nil then
				seal = self.defaultSeal
			end
			if self.castSeal(seal) then return end
		else
			return false
		end
	end
	

-- Return
	return self
end