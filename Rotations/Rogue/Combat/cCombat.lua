--- Combat Class
-- Inherit from: ../cCharacter.lua and ../cRogue.lua
if select(2, UnitClass("player")) == "ROGUE" then

cCombat = {}

-- Creates Combat Rogue
function cCombat:new()
	local self = cRogue:new("Combat")

	local player = "player" -- if someone forgets ""

-----------------
--- VARIABLES ---
-----------------
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
	-- Merge all spell tables into self.spell
	self.spell = {}
	self.spell = mergeSpellTables(self.spell, self.characterSpell, self.rogueSpell, self.combatSpell)
	
------------------
--- OOC UPDATE ---
------------------
	function self.updateOOC()
		-- Call classUpdateOOC()
		self.classUpdateOOC()

		self.getGlyphs()
		self.getTalents()
	end

--------------
--- UPDATE ---
--------------
	function self.update()
		-- Call Base and Class update
		self.classUpdate()
		-- Updates OOC things
		if not UnitAffectingCombat("player") then self.updateOOC() end

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

-------------
--- BUFFS ---
-------------
	function self.getBuffs()
		local getBuffRemain,UnitBuffID = getBuffRemain,UnitBuffID

		self.buff.adrenalineRush = getBuffRemain(player,self.spell.adrenalineRush)
		self.buff.bladeFlurry    = UnitBuffID(player,self.spell.bladeFlurry) -- TODO: richtig machen
		self.buff.deepInsight    = getBuffRemain(player,self.spell.deepInsight)
		self.buff.instantPoison  = getBuffRemain(player,self.spell.instantPoison)
		self.buff.killingSpree   = getBuffRemain(player,self.spell.killingSpree)
	end

---------------
--- DEBUFFS ---
---------------
	-- Revealing Strike Debuff
	function self.getRevealingStrikeDebuff()
		return getDebuffRemain("target",self.spell.revealingStrike)
	end

-----------------
--- COOLDOWNS ---
-----------------
	function self.getCooldowns()
		local getSpellCD = getSpellCD

		self.cd.adrenalineRush = getSpellCD(self.spell.adrenalineRush)
		self.cd.bladeFlurry    = getSpellCD(self.spell.bladeFlurry)
		self.cd.killingSpree   = getSpellCD(self.spell.killingSpree)
	end

--------------
--- GLYPHS ---
--------------
	function self.getGlyphs()
		--local hasGlyph = hasGlyph

		--self.glyph.   = hasGlyph()
	end

---------------
--- TALENTS ---
---------------
	function self.getTalents()
		--local isKnown = isKnown

		--self.talent. = isKnown(self.spell.)
	end

---------------------
--- DYNAMIC UNITS ---
---------------------
	function self.getDynamicUnits()
		local dynamicTarget = dynamicTarget

		-- Normal
		self.units.dyn15 = dynamicTarget(15,true) -- Death from Above
		self.units.dyn20 = dynamicTarget(20,true) -- Shadow Reflection

		-- AoE

	end

---------------
--- ENEMIES ---
---------------
	function self.getEnemies()
		local getEnemies = getEnemies

		self.enemies.yards5  = #getEnemies("player",5)
		self.enemies.yards8  = #getEnemies("player",8)  -- Blade Flurry
		self.enemies.yards10 = #getEnemies("player",10) -- Crimson Tempest
		self.enemies.yards12 = #getEnemies("player",12)
	end


----------------------
--- START ROTATION ---
----------------------
	function self.startRotation()
		if self.rotation == 1 then
			self:combatSimC()
		-- put different rotations below; dont forget to setup your rota in options
		else
			ChatOverlay("No ROTATION ?!", 2000)
		end
	end

---------------
--- OPTIONS ---
---------------
	function self.createOptions()
		thisConfig = 0

		-- Title
		CreateNewTitle(thisConfig,"Combat Defmaster")

		-- Create Base and Class options
		self.createClassOptions()

		-- Combat options
		CreateNewWrap(thisConfig,"--- General ---");

		-- Rotation
		CreateNewDrop(thisConfig,"Rotation",1,"Select Rotation.","|cff00FF00SimC");
		CreateNewText(thisConfig,"Rotation");

		-- Dummy DPS Test
		--CreateNewCheck(thisConfig,"DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.");
		--CreateNewBox(thisConfig,"DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
		--CreateNewText(thisConfig,"DPS Testing");

		-- Stealth Timer
		CreateNewCheck(thisConfig,"Stealth Timer");
		CreateNewBox(thisConfig,"Stealth Timer", 0, 2, 0.25, 1, "|cffFFBB00How long to wait(seconds) before using \n|cffFFFFFFStealth.");
		CreateNewText(thisConfig,"Stealth Timer");

		-- Stealth
		CreateNewCheck(thisConfig,"Stealth");
		CreateNewDrop(thisConfig,"Stealth",1,"Stealthing method.","|cff00FF00Always","|cffFFDD00PrePot","|cffFF000020Yards");
		CreateNewText(thisConfig,"Stealth");

		-- Spacer
		CreateNewText(thisConfig," ");
		CreateNewWrap(thisConfig,"--- Cooldowns ---");

		-- Agi Pot
		--CreateNewCheck(thisConfig,"Agi-Pot");
		--CreateNewText(thisConfig,"Agi-Pot");

		-- Vanish
		CreateNewCheck(thisConfig,"Vanish","Enable or Disable usage of Vanish.");
		CreateNewDrop(thisConfig,"Vanish",2,"CD")
		CreateNewText(thisConfig,"Vanish");

		-- Adrenaline Rush
		CreateNewCheck(thisConfig,"Adrenaline Rush","Enable or Disable usage of Adrenaline Rush.");
		CreateNewDrop(thisConfig,"Adrenaline Rush",2,"CD")
		CreateNewText(thisConfig,"Adrenaline Rush");

		-- Killing Spree
		CreateNewCheck(thisConfig,"Killing Spree","Enable or Disable usage of Killing Spree.");
		CreateNewDrop(thisConfig,"Killing Spree",2,"CD")
		CreateNewText(thisConfig,"Killing Spree");

		-- Blade Flurry
		CreateNewCheck(thisConfig,"Blade Flurry","Enable or Disable usage of Blade Flurry.",1);
		CreateNewText(thisConfig,"Blade Flurry");

		-- Spacer
		CreateNewText(thisConfig," ");
		CreateNewWrap(thisConfig,"--- Defensive ---");

		-- Healthstone
		--CreateNewCheck(thisConfig,"Pot/Stoned");
		--CreateNewBox(thisConfig,"Pot/Stoned", 0, 100, 5, 60, "|cffFFBB00Health Percentage to use at.");
		--CreateNewText(thisConfig,"Pot/Stoned");

		-- Spacer
		CreateNewText(thisConfig," ");
		CreateNewWrap(thisConfig,"--- Toggle Keys ---");

		-- Single/Multi Toggle
		CreateNewCheck(thisConfig,"Rotation Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFRotation Mode Toggle Key|cffFFBB00.");
		CreateNewDrop(thisConfig,"Rotation Mode", 4, "Toggle")
		CreateNewText(thisConfig,"Rotation Mode");

		--Cooldown Key Toggle
		CreateNewCheck(thisConfig,"Cooldown Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFCooldown Mode Toggle Key|cffFFBB00.");
		CreateNewDrop(thisConfig,"Cooldown Mode", 3, "Toggle")
		CreateNewText(thisConfig,"Cooldowns")

		--Defensive Key Toggle
		CreateNewCheck(thisConfig,"Defensive Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFDefensive Mode Toggle Key|cffFFBB00.");
		CreateNewDrop(thisConfig,"Defensive Mode", 6, "Toggle")
		CreateNewText(thisConfig,"Defensive")

		--Interrupts Key Toggle
		CreateNewCheck(thisConfig,"Interrupt Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFInterrupt Mode Toggle Key|cffFFBB00.");
		CreateNewDrop(thisConfig,"Interrupt Mode", 6, "Toggle")
		CreateNewText(thisConfig,"Interrupts")


		-- General Configs
		CreateGeneralsConfig();

		WrapsManager();
	end

--------------
--- SPELLS ---
--------------
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
				if castSpell(self.units.dyn5,self.spell.killingSpree,false,false) then
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

    -- Cancel Blade Flurry
    function self.cancelBladeFlurry()
        if isChecked("Blade Flurry") and self.mode.bladeFlurry ~= 1 then
            CancelUnitBuff("player", buff.bladeFlurry )
        end
    end

	-- Revealing Strike
	function self.castRevealingStrike()
		return castSpell(self.units.dyn5,self.spell.revealingStrike,false,false) == true or false
	end

	-- Sinister Strike
	function self.castSinisterStrike()
		return castSpell(self.units.dyn5,self.spell.sinisterStrike,false,false) == true or false
	end

-----------------------------
--- CALL CREATE FUNCTIONS ---
-----------------------------

	self.createOptions()


-- Return
	return self
end -- cCombat
end -- select Rogue