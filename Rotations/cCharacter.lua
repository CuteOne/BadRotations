--- Character Class
-- All classes inherit from the base class /cCharacter.lua

cCharacter = {}

-- Creates new character with given class
function cCharacter:new(class)
	local self = {}

	self.profile        = "None"    -- Spec
	self.class          = class     -- Class
	self.buff           = {}        -- Buffs
    self.debuff         = {}        -- Debuffs on target
	self.cd             = {}        -- Cooldowns
	self.charges        = {}        -- Number of charges
	self.eq             = {         -- Special Equip like set bonus or class trinket (archimonde)
		--T17
		t17_2pc = false,
		t17_4pc = false,
		-- T18
		t18_2pc = false,
		t18_4pc = false,
		t18_classTrinket = false,
	}
	self.gcd            = 1.5       -- Global Cooldown
	self.glyph          = {}        -- Glyphs
	self.health         = 100       -- Health Points in %
	self.ignoreCombat   = false     -- Ignores combat status if set to true
	self.power          = 0         -- Primary Resource (e.g. Mana for Retribution, Holy Power must be specified)
	self.powerMax		= 100		-- Max Primary Resource
	self.powerDeficit	= 0			-- Difference between Max Power and Power
	self.timeToMax		= 0			-- Time To Max Power
	self.level			= 0 		-- Player Level
	self.mode           = {}        -- Toggles
	self.rotation       = 1         -- Default: First avaiable rotation
	self.inCombat       = false     -- if is in combat
	self.talent         = {}        -- Talents
	self.characterSpell = {}        -- Spells all classes may have (e.g. Racials, Mass Ressurection)
	self.recharge       = {}        -- Time for current recharge (for spells with charges)
	self.units          = {         -- Dynamic Units (used for dynamic targeting, if false then target)
		dyn5,
		dyn30,
		dyn40,
		dyn5AoE,
		dyn30AoE,
		dyn40AoE,
	}
	self.enemies  = {}              -- Number of Enemies around player (must be overwritten by cCLASS or cSPEC)
	self.race     = select(2,UnitRace("player")) -- Race as non-localised name (undead = Scourge) !
	self.racial   = nil             -- Contains racial spell id
	self.faction  = select(1,UnitFactionGroup("player")) -- Faction non-localised name
	self.augmentRune = {            -- Contains the different buff IDs for Augment Runes
		Agility   = 175456,
		Strength  = 175439,
		Intellect = 175457,
    }
    self.flask = {}
    self.flask.wod = {
        -- Agility
        agilityLow = 109145,
        agilityBig = 109153,
        -- Intellect
        intellectLow = 109147,
        intellectBig = 109155,
        -- Stamina
        staminaLow = 109152,
        staminaBig = 109160,
        -- Strength
        strengthLow = 109148,
        strengthBig = 109156,
    }
    self.flask.wod.buff = {
        -- Agility
        agilityLow = 156073,
        agilityBig = 156064,
        -- Intellect
        intellectLow = 156070,
        intellectBig = 156079,
        -- Stamina
        staminaLow = 156077,
        staminaBig = 156084,
        -- Strength
        strengthLow = 156071,
        strengthBig = 156080,
    }
	self.options = {}               -- Contains options
	self.primaryStat = nil          -- Contains the primary Stat: Strength, Agility or Intellect
	self.perk = {}
	self.potion = {}
	self.potion.wod = {
		-- Agility
		agilityBasic    = 109217,
		agilityGarrison = 122453,
		-- Intellect
		intellectBasic    = 109218,
		intellectGarrison = 122454,
		-- Armor
		armorBasic    = 109220,
		armorGarrison = 122456,
		-- Strength
		strengthBasic 	 = 109219,
		strengthGarrison = 122455,
	}
	self.potion.wod.buff = {
		-- Agility
		agility = 156423,
		-- Intellect
		intellect = 156426,
		-- Armor
		armor = 156430,
		-- Strength
		strength = 156428,
	} 

-- Things which get updated for every class in combat
-- All classes call the baseUpdate()
	function self.baseUpdate()
		-- Pause
		-- TODO

		-- Get base options
		self.baseGetOptions()

		-- Level, Health
		self.level 		= UnitLevel("player")
		self.health 	= getHP("player")

		-- Power
		self.power  		= getPower("player")
		self.powerMax 		= UnitPowerMax("player")
		self.powerDeficit 	= UnitPowerMax("player")-getPower("player")
		self.timeToMax 		= getTimeToMax("player")

		-- Racial Cooldown
		self.cd.racial = getSpellCD(self.racial)

		-- Crystal
		self.useCrystal()

		-- Empowered Augment Rune
		self.useEmpoweredRune()

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
		if not self.class=="Priest" and (self.stealth == false or self.stealth == nil) then
			self.startMeleeAttack()
		end
	end

-- Updates things Out of Combat like Talents, Gear, etc.
	function self.baseUpdateOOC()
		-- Updates special Equip like set bonuses
		self.baseGetEquip()
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
			self.mode.defensive  =  BadBoy_data['Defensive']
			self.mode.bosshelper =  BadBoy_data['BossHelper']
			self.mode.t90        =  BadBoy_data['T90']
			self.mode.cooldowns  =  BadBoy_data['Cooldowns']
			self.mode.feather    =  BadBoy_data['Feather']
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
			StartAttack()
		end
	end

-- Returns if in combat
	function self.getInCombat()
		if UnitAffectingCombat("player") or self.ignoreCombat
		or (GetNumGroupMembers()>1 and (UnitAffectingCombat("player") or UnitAffectingCombat("target"))) then
			self.inCombat = true
		else
			self.inCombat = false
		end
	end

-- Rotation selection update
	function self.getRotation()
		self.rotation = getValue("Rotation")
	end

-- Updates special Equipslots
	function self.baseGetEquip()
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

-- Sets the racial
	function self.getRacial()
		local racialSpells = {
			-- Alliance
			Dwarf    = 20594, -- Stoneform
			Gnome    = 20589, -- Escape Artist
			Draenei  = 121093, -- Gift of the Naaru
			Human    = 59752, -- Every Man for Himself
			NightElf = 58984, -- Shadowmeld
			Worgen   = 68992, -- Darkflight
			-- Horde
			BloodElf = 28730, -- Arcane Torrent
			Goblin   = 69041, -- Rocket Barrage
			Orc      = 33697, -- Blood Fury
			Tauren   = 20549, -- War Stomp
			Troll    = 26297, -- Berserking
			Scourge  = 7744,  -- Will of the Forsaken
			-- Both
			Pandaren = 107079, -- Quaking Palm
		}
		return racialSpells[self.race]
	end
	self.racial = self.getRacial()

-- Casts the racial
	function self.castRacial()
		if self.cd.racial == 0 and self.options.useRacial then
			if self.race == "Pandaren" or self.race == "Goblin" then
				return castSpell("target",self.racial,true,false) == true
			else
				return castSpell("player",self.racial,true,false) == true
			end
		end
	end

---------------
--- OPTIONS ---
---------------

 -- Character options
 -- Options which every Class should have
 -- Call after Title
	function self.createBaseOptions()
		-- Base Wrap
		CreateNewWrap(thisConfig, "--- Base Options ---")

		-- Ignore Combat option
		CreateNewCheck(thisConfig,"Ignore Combat","Ignore Combat. Farm mode.","0")
		CreateNewText(thisConfig, "Ignore Combat");

		-- Use Crystal Flask
		CreateNewCheck(thisConfig,"Use Crystal","Use Oralius Crystal +100 to all Stats.","0")
		CreateNewText(thisConfig, "Use Crystal");

		-- Use Empowered Rune (unlimited rune)
		CreateNewCheck(thisConfig,"Use emp. Rune","Use Empowered Rune. +50 to primary Stat.","0")
		CreateNewText(thisConfig, "Use emp. Rune");

		-- Use Racial
		CreateNewCheck(thisConfig,"Use Racial","Use Racial.","0")
		CreateNewText(thisConfig, "Use Racial");

		-- Spacer
		CreateNewText(thisConfig, " ");
	end

 -- Get option modes
	function self.baseGetOptions()
		self.ignoreCombat             = isChecked("Ignore Combat")==true or false
		self.options.useCrystal       = isChecked("Use Crystal")==true or false
		self.options.useEmpoweredRune = isChecked("Use emp. Rune")==true or false
		self.options.useRacial        = isSelected("Use Racial")==true or false
	end

-- Use Oralius Crystal +100 to all Stat - ID: 118922, Buff: 176151 (Whispers of Insanity)
	function self.useCrystal()
		if self.options.useCrystal and getBuffRemain("player",176151) < 600 then
            -- Check if other flask is present, if so abort here
            for _,flaskID in pairs(self.flask.wod.buff) do
                if hasBuff(flaskID) then return end
            end
            useItem(118922)
		end
    end

-- Use Empowered Augment Rune +50 to prim. Stat - ID: 128482 Alliance / ID: 128475 Horde
	function self.useEmpoweredRune()
		if self.options.useEmpoweredRune then
			if getBuffRemain("player",self.augmentRune[self.primaryStat]) < 600 then
				if self.faction == "Alliance" then
					useItem(128482)
				else
					useItem(128475)
				end
			end
		end
	end

-- Returns and sets highest stat, which will be the primary stat
	function self.getPrimaryStat()
		-- local stat, effectiveStat, posBuff, negBuff = UnitStat("player", statIndex)
		-- 1 - Strength, 2 - Agility, 3 - Stamina, 4 - Intellect, 5 - Spirit

		local stat = {
			Strength = select(2,UnitStat("player", 1)),
			Agility  = select(2,UnitStat("player", 2)),
			Intellect = select(2,UnitStat("player", 4)),
		}
		local highestStat = ""
		local highestStatValue = 0

		for statName,statValue in pairs(stat) do
			if statValue > highestStatValue then
				highestStatValue = statValue
				highestStat = statName
			end
		end

		return highestStat
	end
	self.primaryStat = self.getPrimaryStat()

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