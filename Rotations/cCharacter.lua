--- Character Class
-- All classes inherit from the base class /cCharacter.lua

cCharacter = {}

-- Creates new character with given class
function cCharacter:new(class)
	local self = {}

	self.profile        = "None"	-- Spec
	self.class          = class 	-- Class
	self.buff           = {}		-- Buffs
	self.cd             = {}		-- Cooldowns
	self.charges        = {} 		-- Number of charges 
	self.eq 			= {			-- Special Equip like set bonus or class trinket (archimonde)
		--T17
		t17_2pc = false,
		t17_4pc = false,
		-- T18
		t18_2pc = false,
		t18_4pc = false,
		t18_classTrinket = false,
	}
	self.gcd            = 1.5		-- Global Cooldown
	self.glyph          = {}		-- Glyphs
	self.health         = 100		-- Health Points in %
	self.ignoreCombat   = false 	-- Ignores combat status if set to true
	self.power          = 0			-- Primary Ressource (e.g. Mana for Retribution, Holy Power must be specified)
	self.mode           = {}		-- Toggles
	self.rotation       = 1 		-- Default: First avaiable rotation
	self.inCombat       = false		-- if is in combat
	self.talent         = {}		-- Talents
	self.characterSpell = {}		-- Spells all classes may have (e.g. Racials, Mass Ressurection)
	self.recharge       = {} 		-- Time for current recharge (for spells with charges)
	self.units          = { 		-- Dynamic Units (used for dynamic targeting, if false then target)
		dyn5,
		dyn30,
		dyn40,
		dyn5AoE,
		dyn30AoE,
		dyn40AoE,
	} 
	self.enemies  = {} 				-- Number of Enemies around player (must be overwritten by cCLASS or cSPEC)

-- Things which get updated for every class in combat
-- All classes call the baseUpdate()
	function self.baseUpdate()
		-- Pause
		-- TODO

		-- Health and Power
		self.health = getHP("player")
		self.power = UnitPower("player")

		-- Food/Invis Check
		if canRun() ~= true then
			return false
		end

		-- Set Global Cooldown 
		self.gcd = self.getGlobalCooldown()

		-- Get toggle modes
		self.getToggleModes()

		-- Update common Dynamic Units
		self.baseGetDynamicUnits()

		-- Combat state update
		self.getInCombat()

		-- Start attacking (melee)
		self.startMeleeAttack()
	end

-- Updates things Out of Combat like Talents, Gear, etc.
	function self.baseUpdateOOC()
		-- Updates special Equip like set bonuses
		self.getEquip()
	end

-- Updates toggle data
	function self.getToggleModes()
		local BadBoy_data   = BadBoy_data
		-- Paladin:
		if self.class == "Paladin" then
			self.mode.aoe       = BadBoy_data["AoE"]
			self.mode.cooldowns = BadBoy_data["Cooldowns"]
			self.mode.defensive = BadBoy_data["Defensive"]
			self.mode.healing   = BadBoy_data["Healing"]
		end
		-- Priest - Shadow:
		if self.class == "Priest" and self.profile == "Shadow" then
			self.mode.defensive  = 	BadBoy_data['Defensive']
			self.mode.multidot   = 	BadBoy_data['DoT']
			self.mode.bosshelper = 	BadBoy_data['BossHelper']
			self.mode.t90        = 	BadBoy_data['T90']
			self.mode.cooldowns  = 	BadBoy_data['Cooldowns']
			self.mode.feather    = 	BadBoy_data['Feather']
		end
	end

-- Dynamic unit update
	function self.baseGetDynamicUnits()
		local dynamicTarget = dynamicTarget

		-- Normal
		self.units.dyn5  = dynamicTarget(5,true) -- Melee
		self.units.dyn30 = dynamicTarget(30,true) -- used for most range attacks
		self.units.dyn40 = dynamicTarget(40,true) -- used for most heals

		-- AoE
		self.units.dyn5AoE  = dynamicTarget(5,false) -- Melee
		self.units.dyn30AoE = dynamicTarget(30,false) -- used for most range attacks
		self.units.dyn40AoE = dynamicTarget(40,false) -- used for most heals
	end

-- Returns the Global Cooldown time
	function self.getGlobalCooldown()
		local gcd = (1.5 / ((UnitSpellHaste("player")/100)+1))
		if gcd < 1 then
			return  1
		else
			return gcd
		end
	end

-- Starts auto attack when in melee range and facing enemy
	function self.startMeleeAttack()
		if self.inCombat and (isInMelee() and getFacing("player","target") == true) then
			RunMacroText("/startattack")
		end
	end

-- Returns if in combat
	function self.getInCombat()
		if UnitAffectingCombat("player") or self.ignoreCombat then
			self.inCombat = true
		else
			self.inCombat = false
		end
	end

-- Updates special Equipslots
	function self.getEquip()
		-- Checks T17 Set
			local t17 = TierScan("T17")
			self.eq.t17_2pc = t17>=2 or false
			self.eq.t17_4pc = t17>=4 or false
		-- Checks T18 Set
			local t18 = TierScan("T18")
			self.eq.t18_2pc = t18>=2 or false
			self.eq.t18_4pc = t18>=4 or false
		-- Checks class trinket
			local classTrinket = {
				deathknight = 124513, -- Reaper's Harvest
				druid       = 124514, -- Seed of Creation
				hunter      = 124515, -- Talisman of the Master Tracker
				mage        = 124516, -- Tome of Shifting Words
				monk        = 124517, -- Sacred Draenic Incense
				paladin     = 124518, -- Libram of Vindication
				priest      = 124519, -- Repudiation of War
				rogue       = 124520, -- Bleeding Hollow Toxin Vessel
				shaman      = 124521, -- Core of the Primal Elements
				warlock     = 124522, -- Fragment of the Dark Star
				warrior     = 124523, -- Worldbreaker's Resolve
			}
			self.eq.t18_classTrinket = isTrinketEquipped(classTrinket[string.lower(self.class)])
	end

--[[ TODO:
	- add Flask usage
	- add Potion usage based on class and spec (both)
	- add pause toggle
	- add new options frame
	- add startRangeCombat()
	- many more

	]]

-- Return
	return self
end