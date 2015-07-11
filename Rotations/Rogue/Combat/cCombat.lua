--- Combat Class
-- Inherit from: ../cCharacter.lua and ../cRogue.lua
if select(2, UnitClass("player")) == "ROGUE" then

cCombat = {}

-- Creates Combat Rogue
function cCombat:new()
	local self = cRogue:new("Combat")

	local player = "player" -- if someone forgets ""

	self.enemies = {
		yards5,
		yards8,
		yards12,
	}
	self.combatSpell = {
		-- Buff
		adrenalineRush  = 13750,
		bladeFlurry     = 13877,
		bladeFlurryBuff = 22482,
		deepInsight     = 84747,
		-- Defensive
		-- Offensive
		killingSpree    = 51690,
		revealingStrike = 84617,
		sinisterStrike  = 1752,
		-- Misc
		-- Poison
		instantPoison   = 157584,
	}
	self.rotation = 1
	-- Merge all spell tables into self.spell
	self.spell = {}
	self.spell = mergeSpellTables(self.spell, self.characterSpell, self.rogueSpell, self.combatSpell)
	

-- Update 
	function self.update()
		self.classUpdate()
		self.getBuffs()
		self.getCooldowns()
		self.getDynamicUnits()
		self.getEnemies()
		self.getRotation()

		self.mode.bladeFlurry = BadBoy_data["BladeFlurry"]

		-- Casting and GCD check
		-- TODO: -> does not use off-GCD stuff like pots, dp etc
		if castingUnit() then
			return
		end


		-- Start selected rotation
		self:startRotation()
	end

-- Update OOC
	function self.updateOOC()
		-- Call classUpdateOOC()
		self.classUpdateOOC()

		self.getGlyphs()
		self.getTalents()
	end

-- Buff updates
	function self.getBuffs()
		local getBuffRemain,UnitBuffID = getBuffRemain,UnitBuffID

		self.buff.adrenalineRush = getBuffRemain(player,self.spell.adrenalineRush)
		self.buff.bladeFlurry    = UnitBuffID(player,self.spell.bladeFlurry) -- TODO: richtig machen
		self.buff.deepInsight    = getBuffRemain(player,self.spell.deepInsight)
		self.buff.instantPoison  = getBuffRemain(player,self.spell.instantPoison)
		self.buff.killingSpree   = getBuffRemain(player,self.spell.killingSpree)
	end

-- Cooldown updates
	function self.getCooldowns()
		local getSpellCD = getSpellCD

		self.cd.adrenalineRush = getSpellCD(self.spell.adrenalineRush)
		self.cd.bladeFlurry    = getSpellCD(self.spell.bladeFlurry)
		self.cd.killingSpree   = getSpellCD(self.spell.killingSpree)
	end

-- Glyph updates
	function self.getGlyphs()
		--local hasGlyph = hasGlyph

		--self.glyph.   = hasGlyph()
	end

-- Talent updates
	function self.getTalents()
		--local isKnown = isKnown

		--self.talent. = isKnown(self.spell.)
	end

-- Update Dynamic units
	function self.getDynamicUnits()
		local dynamicTarget = dynamicTarget

		-- Normal
		self.units.dyn15 = dynamicTarget(15,true) -- Death from Above
		self.units.dyn20 = dynamicTarget(20,true) -- Shadow Reflection

		-- AoE

	end

-- Update Number of Enemies around player
	function self.getEnemies()
		local getEnemies = getEnemies

		self.enemies.yards5  = #getEnemies("player",5)
		self.enemies.yards8  = #getEnemies("player",8)  -- Blade Flurry
		self.enemies.yards10 = #getEnemies("player",10) -- Crimson Tempest
		self.enemies.yards12 = #getEnemies("player",12)
	end


-- Starts rotation, uses default if no other specified; starts if inCombat == true
	function self.startRotation()
		if self.rotation == 1 then
			self:combatSimC()
		-- put different rotations below; dont forget to setup your rota in options
		else
			ChatOverlay("No ROTATION ?!", 2000)
		end
	end

-- Revealing Strike Debuff
	function self.getRevealingStrikeDebuff()
		return getDebuffRemain("target",self.spell.revealingStrike)
	end 

---------------------------------------------------------------
-------------------- Spell functions --------------------------
---------------------------------------------------------------

-- Adrenaline Rush
	function self.castAdrenalineRush()
		if isSelected("Adrenaline Rush") then
			if (isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 4*UnitHealthMax("player"))) then
				if castSpell("player",self.spell.adrenalineRush,true,false) then
					return true
				end
			end
		end
		return false
	end

-- Killing Spree
	function self.castKillingSpree()
		if isSelected("Killing Spree") then
			if (isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 4*UnitHealthMax("player"))) then
				if castSpell("target",self.spell.killingSpree,false,false) then
					return true
				end
			end
		end
		return false
	end

-- Blade Flurry
	function self.castBladeFlurry()
		if isChecked("Blade Flurry") and self.mode.bladeFlurry ~= 1 then
			if castSpell("player",self.spell.bladeFlurry,true,false) then
				return true
			end
		end
		return false
	end

-- Revealing Strike
	function self.castRevealingStrike()
		return castSpell(self.units.dyn5,self.spell.revealingStrike,false,false) == true or false
	end

-- Sinister Strike
	function self.castSinisterStrike()
		return castSpell(self.units.dyn5,self.spell.sinisterStrike,false,false) == true or false
	end


-- Return
	return self
end
end