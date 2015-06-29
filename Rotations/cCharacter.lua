--- Character Class
-- All classes inherit from the base class /cCharacter.lua

cCharacter = {}

-- Creates new character with given class
function cCharacter:new(class)
	local self = {}

	self.profile  = "None"
	self.class    = class
	self.buff     = {}
	self.cd       = {}
	self.charges  = {} -- Nr of charges 
	self.gcd      = 1.5
	self.glyph    = {}
	self.health   = 100
	self.ignoreCombat = false -- Set to true for farm mode
	self.power    = 0
	self.mode     = {}
	self.rotation = 1 -- Default: First avaiable rotation
	self.inCombat = false
	self.talent   = {}
	self.characterSpell    = {}
	self.recharge = {} -- Time to recharge
	self.units    = { -- Dynamic Units
		dyn5,
		dyn30,
		dyn40,
		dyn5AoE,
		dyn30AoE,
		dyn40AoE,
	} 
	self.enemies  = {} -- Number of Enemies

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

	end

-- Updates toggle data
	function self.getToggleModes()
		local BadBoy_data   = BadBoy_data
		-- Paladin:
		if select(3, UnitClass("player")) == 2 then
			self.mode.aoe       = BadBoy_data["AoE"]
			self.mode.cooldowns = BadBoy_data["Cooldowns"]
			self.mode.defensive = BadBoy_data["Defensive"]
			self.mode.healing   = BadBoy_data["Healing"]
		end
		-- Priest - Shadow:
		if select(3, UnitClass("player")) == 5 and GetSpecialization() == 3 then
			self.mode.defensive = 	BadBoy_data['Defensive']
			self.mode.multidot = 		BadBoy_data['DoT']
			self.mode.bosshelper = 	BadBoy_data['BossHelper']
			self.mode.t90 = 			BadBoy_data['T90']
			self.mode.cooldowns = 	BadBoy_data['Cooldowns']
			self.mode.feather = 		BadBoy_data['Feather']
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
		self.units.dyn5AoE = dynamicTarget(5,false) -- Melee
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
		if (self.inCombat or self.ignoreCombat) and (isInMelee() and getFacing("player","target") == true) then
			RunMacroText("/startattack")
		end
	end

-- Returns if in combat
	function self.getInCombat()
		if UnitAffectingCombat("player")
		or (GetNumGroupMembers()>1 and (UnitAffectingCombat("player") or UnitAffectingCombat("target"))) then
			self.inCombat = true
		else
			self.inCombat = false
		end
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