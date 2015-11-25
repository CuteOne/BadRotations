--- Warrior Class
-- Inherit from: ../cCharacter.lua
-- All Warrior specs inherit from cWarrior.lua

if select(3, UnitClass("player")) == 1 then
	cWarrior = {}
	
	-- Creates Paladin with given specialisation
	function cWarrior:new(spec)
		local self = cCharacter:new("Warrior")
		
		self.profile		= spec
		self.warriorSpell 	= {
			
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