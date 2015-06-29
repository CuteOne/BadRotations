--- Priest Class
-- Inherit from: ../cCharacter.lua
-- All Priest specs inherit from cPriest.lua

if select(3, UnitClass("player")) == 5 then
	cPriest = {}

	-- Creates Priest with given specialisation
	function cPriest:new(spec)
		local self = cCharacter:new("Priest")

		self.profile     = spec
		self.PriestSpell = {

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