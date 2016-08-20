--- Priest Class
-- Inherit from: ../cCharacter.lua
-- All Priest specs inherit from cPriest.lua

if select(3, UnitClass("player")) == 5 then
	cPriest = {}

	-- Creates Priest with given specialisation
	function cPriest:new(spec)
		local self = cCharacter:new("Priest")

		self.artifact        = {}
        self.artifact.perks  = {}
        self.buff.duration   = {}       -- Buff Durations
        self.buff.remain     = {}       -- Buff Time Remaining
        self.castable        = {}        -- Cast Spell Functions
        self.debuff.duration = {}       -- Debuff Durations
        self.debuff.remain   = {}       -- Debuff Time Remaining
        self.debuff.refresh  = {}       -- Debuff Refreshable
		self.profile     = spec
		self.priestSpell = {

		}

		-- Update 
		function self.classUpdate()
			-- Call baseUpdate()
			self.baseUpdate()
		end

		-- Update OOC
		function self.classUpdateOOC()
			-- Call baseUpdateOOC()
			self.baseUpdateOOC()
		end

		-- Return
		return self
	end
end