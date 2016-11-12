-- Inherit from: ../cCharacter.lua
-- All Death Knight specs inherit from this file
if select(2, UnitClass("player")) == "DEATHKNIGHT" then
	cDeathKnight = {}

-- Creates Death Knight with given specialisation
	function cDeathKnight:new(spec)
		local self = cCharacter:new("Death Knight")

		local player = "player" -- if someone forgets ""

		self.profile         			= spec
		self.spell.class 				= {}
		self.spell.class.abilities      = {
			antimagicShell 				= 48707,
			controlUndead 				= 111673,
			corpseExplosion 			= 127344,
			darkCommand 				= 56222,
			deathGate 					= 50977,
			deathGrip 					= 49576,
			deathStrike 				= 49998,
			frostBreath 				= 190780,
			mindFreeze 					= 47528,
			pathOfFrost 				= 3714,
			raiseAlly 					= 61999,
			wraithWalk 					= 212552,
	    }
	    self.spell.class.artifacts      = {        -- Artifact Traits Available To All Specs in Class
	        artificialStamina 			= 211309,
	    }
	    self.spell.class.buffs          = {        -- Buffs Available To All Specs in Class
	    	pathOfFrost 				= 3714,
	    	wraithWalk 					= 212552
	    }
	    self.spell.class.debuffs        = {        -- Debuffs Available To All Specs in Class
	    	bloodPlague 				= 55078,
	    	controlUndead 				= 111673,
	    	darkCommand 				= 56222,
	    	frostBreath 				= 190780,
	    	frostFever 					= 55095,
	    }
	    self.spell.class.glyphs         = {        -- Glyphs Available To All Specs in Class

	    }
	    self.spell.class.talents        = {        -- Talents Available To All Specs in Class

	    }

-- Update OOC
		function self.classUpdateOOC()
			-- Call baseUpdateOOC()
			self.baseUpdateOOC()
		end

-- Update 
		function self.classUpdate()
			-- Call baseUpdate()
			self.baseUpdate()
			cFileBuild("class",self)
		end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------

	    function useAoE()
	        local rotation = self.mode.rotation
	        if (rotation == 1 and #getEnemies("player",8) >= 3) or rotation == 2 then
	            return true
	        else
	            return false
	        end
	    end

	    function useCDs()
	        local cooldown = self.mode.cooldown
	        if (cooldown == 1 and isBoss()) or cooldown == 2 then
	            return true
	        else
	            return false
	        end
	    end

	    function useDefensive()
	        if self.mode.defensive == 1 then
	            return true
	        else
	            return false
	        end
	    end

	    function useInterrupts()
	        if self.mode.interrupt == 1 then
	            return true
	        else
	            return false
	        end
	    end

	-- Return
		return self
	end

end -- End Select 