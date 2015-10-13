--- Warlock Class
-- Inherit from: ../cCharacter.lua
-- All Warlock specs inherit from cWarlock.lua

if select(3, UnitClass("player")) == 9 then
	cWarlock = {}

	-- Creates Priest with given specialisation
	function cWarlock:new(spec)
		local self = cCharacter:new("Warlock")

		self.profile     = spec
		self.WarlockSpell = {

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