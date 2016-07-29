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

		self.mode.bladeFlurry = bb.data["BladeFlurry"]

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

		self.buff.adrenalineRush = getBuffRemain(player,self.spell.adrenalineRush) or 0
		self.buff.bladeFlurry    = UnitBuffID(player,self.spell.bladeFlurry)~=nil or false -- TODO: richtig machen
		self.buff.deepInsight    = getBuffRemain(player,self.spell.deepInsight) or 0
		self.buff.instantPoison  = getBuffRemain(player,self.spell.instantPoison) or 0
		self.buff.killingSpree   = getBuffRemain(player,self.spell.killingSpree) or 0
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

    -- Rotation selection update
    function self.getRotation()
        self.rotation = bb.selectedProfile

        if bb.rotation_changed then
            --self.createToggles()
            self.createOptions()

            bb.rotation_changed = false
        end
    end

	function self.startRotation()
		if self.rotation == 1 then
			self:combatSimC()
		-- put different rotations below dont forget to setup your rota in options
		else
			ChatOverlay("No ROTATION ?!", 2000)
		end
	end

---------------
--- OPTIONS ---
---------------
	function self.createOptions()
        bb.ui.window.profile = bb.ui:createProfileWindow("Combat")
        local section

		-- Create Base and Class options
		self.createClassOptions()

		-- Combat options
		section = bb.ui:createSection(bb.ui.window.profile, "--- General ---")
        -- Stealth Timer
        CreateNewBox(thisConfig,"Stealth Timer", 0, 2, 0.25, 1, "|cffFFBB00How long to wait(seconds) before using \n|cffFFFFFFStealth.")
        -- Stealth
        bb.ui:createDropdown(section, "Stealth", {"|cff00FF00Always","|cffFFDD00PrePot","|cffFF000020Yards"}, 1, "Stealthing method.")
        bb.ui:checkSectionState(section)


		section = bb.ui:createSection(bb.ui.window.profile, "--- Cooldowns ---")
        -- Agi Pot
        --bb.ui:createCheckbox(section,"Agi-Pot")
        -- Vanish
        bb.ui:createCheckbox(section,"Vanish","Enable or Disable usage of Vanish.")
        bb.ui:createDropdown(section, "Vanish", bb.dropOptions.CD, 2)
        -- Adrenaline Rush
        bb.ui:createCheckbox(section,"Adrenaline Rush","Enable or Disable usage of Adrenaline Rush.")
        bb.ui:createDropdown(section, "Adrenaline Rush", bb.dropOptions.CD, 2)
        -- Killing Spree
        bb.ui:createCheckbox(section,"Killing Spree","Enable or Disable usage of Killing Spree.")
        bb.ui:createDropdown(section, "Killing Spree", bb.dropOptions.CD, 2)
        -- Blade Flurry
        bb.ui:createCheckbox(section,"Blade Flurry","Enable or Disable usage of Blade Flurry.",1)
        bb.ui:checkSectionState(section)


		section = bb.ui:createSection(bb.ui.window.profile, "--- Defensive ---")
        -- Healthstone
        --bb.ui:createCheckbox(section,"Pot/Stoned")
        --CreateNewBox(thisConfig,"Pot/Stoned", 0, 100, 5, 60, "|cffFFBB00Health Percentage to use at.")
        bb.ui:checkSectionState(section)


		section = bb.ui:createSection(bb.ui.window.profile, "--- Toggle Keys ---")
        -- Single/Multi Toggle
        bb.ui:createCheckbox(section,"Rotation Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFRotation Mode Toggle Key|cffFFBB00.")
        bb.ui:createDropdown(section, "Rotation Mode", bb.dropOptions.Toggle,  4)
        --Cooldown Key Toggle
        bb.ui:createCheckbox(section,"Cooldown Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFCooldown Mode Toggle Key|cffFFBB00.")
        bb.ui:createDropdown(section, "Cooldown Mode", bb.dropOptions.Toggle,  3)
        --Defensive Key Toggle
        bb.ui:createCheckbox(section,"Defensive Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFDefensive Mode Toggle Key|cffFFBB00.")
        bb.ui:createDropdown(section, "Defensive Mode", bb.dropOptions.Toggle,  6)
        --Interrupts Key Toggle
        bb.ui:createCheckbox(section,"Interrupt Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFInterrupt Mode Toggle Key|cffFFBB00.")
        bb.ui:createDropdown(section, "Interrupt Mode", bb.dropOptions.Toggle,  6)
        bb.ui:checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"Defmaster"})
        bb:checkProfileWindowStatus()
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
            CancelUnitBuff("player",self.spell.bladeFlurryBuff )
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