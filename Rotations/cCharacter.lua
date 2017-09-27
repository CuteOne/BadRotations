--- Character Class
-- All classes inherit from the base class /cCharacter.lua
cCharacter = {}


-- Creates new character with given class
function cCharacter:new(class)
	local self = {}
	self.augmentRune 	= {        -- Contains the different buff IDs for Augment Runes
		Agility   = 175456,
		Strength  = 175439,
		Intellect = 175457,
		Legion	  = 224001, 
    }
    self.artifact       = {} 		-- Artifact Perk IDs
	self.buff           = {}        -- Buffs
    self.debuff         = {}        -- Debuffs on target
	self.class          = select(2, UnitClass("player")) -- Class
	self.cd             = {}        -- Cooldowns
	self.charges        = {}        -- Number of charges
    self.dynLastUpdate  = 0         -- Timer variable to reduce Dynamic Target updating
    self.dynTargetTimer = 0.5       -- Timer to reduce Dynamic Target updating (1/X = calls per second)
	self.enemies  		= {}        -- Number of Enemies around player (must be overwritten by cCLASS or cSPEC)
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
	self.gcdMax 		= 1.5 		-- GLobal Max Cooldown
	self.glyph          = {}        -- Glyphs
	self.faction  		= select(1,UnitFactionGroup("player")) -- Faction non-localised name
    self.flask 			= {}
    self.flask.wod 		= {
        -- Agility
        agilityLow 		= 127848, 	-- Flask of the Seventh Demon (Legion)
        agilityBig 		= 127848, 	-- Flask of the Seventh Demon (Legion)
        -- Intellect
        intellectLow 	= 109147,
        intellectBig 	= 109155,
        -- Stamina
        staminaLow 		= 109152,
        staminaBig		= 109160,
        -- Strength
        strengthLow 	= 109148,
        strengthBig 	= 109156,
    }
    self.flask.wod.buff = {
        -- Agility
        agilityLow 		= 188033, 	-- Flask of the Seventh Demon (Legion)
        agilityBig 		= 188033, 	-- Flask of the Seventh Demon (Legion)
        -- Intellect
        intellectLow 	= 156070,
        intellectBig 	= 156079,
        -- Stamina
        staminaLow 		= 156077,
        staminaBig 		= 156084,
        -- Strength
        strengthLow 	= 156071,
        strengthBig 	= 156080,
    }
    self.functions 		= {} 		-- Functions
	self.health         = 100       -- Health Points in %
	self.ignoreCombat   = false     -- Ignores combat status if set to true
	self.inCombat       = false     -- if is in combat
	self.instance 		= select(2,IsInInstance()) 	-- Get type of group we are in (none, party, instance, raid, etc)
	self.level			= 0 		-- Player Level
	self.mode           = {}        -- Toggles
	self.options 		= {}        -- Contains options
	self.perk 			= {}		-- Perk Table
	self.pet 			= "None" 	-- Current Pet
	self.petId 			= 0 		-- Current Pet Id
	self.petInfo 		= {} 		-- Pet Information Table
	self.potion 		= {}		-- Potion Table
	self.primaryStat 	= nil       -- Contains the primary Stat: Strength, Agility or Intellect
	self.profile        = "None"    -- Spec
	self.queue 			= {} 		-- Table for Queued Spells
	self.race     		= select(2,UnitRace("player")) -- Race as non-localised name (undead = Scourge) !
	self.racial   		= nil       -- Contains racial spell id
	self.recharge       = {}        -- Time for current recharge (for spells with charges)
	self.rechargeFull 	= {}
	self.rotation       = 1         -- Default: First avaiable rotation
    self.rotations 		= {} 		-- List of Rotations
	self.spell			= {}        -- Spells all classes may have (e.g. Racials, Mass Ressurection)
	self.talent         = {}        -- Talents
	self.timeToMax		= 0			-- Time To Max Power
	self.units          = {}        -- Dynamic Units (used for dynamic targeting, if false then target)
	

-- Things which get updated for every class in combat
-- All classes call the baseUpdate()
	function self.baseUpdate()
		local startTime = debugprofilestop()
		-- Pause
		-- TODO

		-- Get base options
		self.baseGetOptions()

		-- Get Character Info
		self.getCharacterInfo()

		-- Get Consumables	
		if bagsUpdated then
			self.potion.action 		= {}
			self.potion.agility		= {}	-- Agility Potions
			self.potion.armor 		= {}	-- Armor Potions
			self.potion.breathing  	= {}
			self.potion.health		= {}	-- Health Potions
			self.potion.intellect 	= {}	-- Intellect Potions
			self.potion.invis 		= {}
			self.potion.mana 		= {}	-- Mana Potions
			self.potion.rage 		= {}
			self.potion.rejuve 		= {}
			self.potion.speed		= {}
			self.potion.strength 	= {}	-- Strength Potions
			self.potion.versatility = {} 	-- Versatility Potions
			self.potion.waterwalk 	= {}
			self.getConsumables()			-- Find All The Tasty Things!
			bagsUpdated = false
		end


		-- Crystal
		self.useCrystal()
		
		-- Fel Focuser
		self.useFelFocuser()

		-- Empowered Augment Rune
		self.useEmpoweredRune()

        -- Get selected rotation
        self.getRotation()

		-- Get toggle modes
		self.getToggleModes()

		-- Combat state update
		self.getInCombat()

		-- Food/Invis Check
		if canRun() ~= true then
			return false
		end
		br.debug.cpu.rotation.baseUpdate = debugprofilestop()-startTime or 0
	end

-- Update Character Stats
	function self.getCharacterInfo()

		self.gcd 				= self.getGlobalCooldown()
		self.gcdMax 			= max(1, 1.5 / (1 + UnitSpellHaste("player") / 100))
		self.health 			= getHP("player")
		self.instance 			= select(2,IsInInstance())
		self.level 				= UnitLevel("player") -- TODO: EVENT - UNIT_LEVEL
		self.spec 				= select(2, GetSpecializationInfo(GetSpecialization())) or "None"
		self.pet 				= UnitCreatureFamily("pet") or "None"
		if self.pet ~= "None" then
			self.petId 			= tonumber(UnitGUID("pet"):match("-(%d+)-%x+$"), 10)
		else
			self.petId 			= 0
		end
	end

-- Updates things Out of Combat like Talents, Gear, etc.
	function self.baseUpdateOOC()
		-- Update Artifact data
		if self.artifact.rank == nil then updateArtifact() end
		-- Updates special Equip like set bonuses
		self.baseGetEquip()
		if getOptionCheck("Queue Casting") and #self.queue ~= 0 then
			self.queue = {} -- Reset Queue Casting Table out of combat
			Print("Out of Combat - Queue List Cleared")
		end
	end

-- Updates toggle data
    -- TODO: here should only happen generic ones like Defensive etc.
	function self.getToggleModes()

		self.mode.rotation  = br.data.settings[br.selectedSpec].toggles["Rotation"]
		self.mode.cooldown 	= br.data.settings[br.selectedSpec].toggles["Cooldown"]
		self.mode.defensive = br.data.settings[br.selectedSpec].toggles["Defensive"]
		self.mode.interrupt = br.data.settings[br.selectedSpec].toggles["Interrupt"]
	end

-- Returns the Global Cooldown time
	function self.getGlobalCooldown()
    	local currentSpecName = select(2,GetSpecializationInfo(GetSpecialization())) 
        local gcd = getSpellCD(61304)
        local gcdMIN = 0.75
        if currentSpecName=="Feral" or currentSpecName=="Brewmaster" or currentSpecName=="Windwalker" or UnitClass("player") == "Rogue" then 
        	return 1
        else 
        	return gcd > gcdMIN and gcd or gcdMIN 
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
        self.rotation = br.selectedProfile

        if br.rotation_changed then
            self.createOptions()
            self.createToggles()
            br.ui.window.profile.parent:Show()

            br.rotation_changed = false
        end
    end

-- Start the rotation or return if pause
    function self.startRotation()
    	local startTime = debugprofilestop()
        -- dont check if player is casting to allow off-cd usage and cast while other spell is casting
        if pause(true) then return end

        if self.rotations[br.selectedProfile] ~= nil then
        	self.rotations[br.selectedProfile].run()
        else
        	return
        end
        br.debug.cpu.rotation.currentTime = debugprofilestop()-startTime
		br.debug.cpu.rotation.totalIterations = br.debug.cpu.rotation.totalIterations + 1
		br.debug.cpu.rotation.elapsedTime = br.debug.cpu.rotation.elapsedTime + debugprofilestop()-startTime
		br.debug.cpu.rotation.averageTime = br.debug.cpu.rotation.elapsedTime / br.debug.cpu.rotation.totalIterations
    end

-- Updates special Equipslots
	function self.baseGetEquip()
        if br.equipHasChanged == nil or br.equipHasChanged then
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

            br.equipHasChanged = false
        end
	end

-- Sets the racial
	function self.getRacial()
		if self.race == "BloodElf" then
			if self.class == "WARRIOR" then BloodElfRacial = 69179 end
			if self.class == "MONK" then BloodElfRacial = 129597 end
			if self.class == "MAGE" or self.class == "WARLOCK" then BloodElfRacial = 28730 end
			if self.class == "DEATHKNIGHT" then BloodElfRacial = 50613 end
			if self.class == "HUNTER" then BloodElfRacial = 80483 end
			if self.class == "PALADIN" then BloodElfRacial = 155145 end
			if self.class == "PRIEST" then BloodElfRacial = 232633 end
			if self.class == "ROGUE" then BloodElfRacial = 25046 end
			if self.class == "DEMONHUNTER" then BloodElfRacial = 202719 end
		end
		local racialSpells = {
			-- Alliance
			Dwarf    = 20594, -- Stoneform
			Gnome    = 20589, -- Escape Artist
			Draenei  = 59547, -- Gift of the Naaru
			Human    = 59752, -- Every Man for Himself
			NightElf = 58984, -- Shadowmeld
			Worgen   = 68992, -- Darkflight
			-- Horde
			BloodElf = BloodElfRacial, -- Arcane Torrent
			Goblin   = 69041, -- Rocket Barrage
			Orc      = 20572, -- Blood Fury
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
		if getSpellCD(self.racial) == 0 and getOptionValue("Racial") then
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
        local section_base = br.ui:createSection(br.ui.window.profile, "Base Options")
        br.ui:createCheckbox(section_base, "Cast Debug", "Shows information about how the bot is casting.")
        br.ui:createCheckbox(section_base, "Ignore Combat")
        br.ui:createCheckbox(section_base, "Mute Queue")
        br.ui:createDropdown(section_base, "Pause Mode", br.dropOptions.Toggle, 2, "Define a key which pauses the rotation.")
        br.ui:createCheckbox(section_base, "Use Crystal")
		br.ui:createCheckbox(section_base, "Use Fel Focuser")
        br.ui:createDropdown(section_base, "Use emp. Rune", {"|cff00FF00Normal","|cffFF0000Raid Only"}, 1, "Use rune anytime or only in raids")
        br.ui:checkSectionState(section_base)
    end

 -- Get option modes
	function self.baseGetOptions()
		self.ignoreCombat             = isChecked("Ignore Combat")==true or false
		self.options.useCrystal       = isChecked("Use Crystal")==true or false
		self.options.useFelFocuser    = isChecked("Use Fel Focuser")==true or false
		self.options.useEmpoweredRune = isChecked("Use emp. Rune",true)==true or false
	end

-- Use Oralius Crystal +100 to all Stat - ID: 118922, Buff: 176151 (Whispers of Insanity)
	function self.useCrystal()
		if self.options.useCrystal and getBuffRemain("player",176151) < 600 and not hasBuff(242551) and not canUse(147707) and not IsMounted() and not UnitIsDeadOrGhost("player") then
            -- Check if other flask is present, if so abort here
            for _,flaskID in pairs(self.flask.wod.buff) do
                if hasBuff(flaskID) then return end
            end
            useItem(118922)
		end
    end
	
-- Use Fel Focuser +500 to all Stat - ID: 147707, Buff: 242551 (Fel Focus)
	function self.useFelFocuser()
		if canUse(147707) and not IsMounted() then cancelBuff(176151) end
			
		if self.options.useFelFocuser and getBuffRemain("player",242551) < 600 and not hasBuff(176151) and not IsMounted() and not UnitIsDeadOrGhost("player") then
            -- Check if other flask is present, if so abort here
            for _,flaskID in pairs(self.flask.wod.buff) do
                if hasBuff(flaskID) then return end
            end
            useItem(147707)
		end
    end	
	
-- Use Empowered Augment Rune +50 to prim. Stat - ID: 128482 Alliance / ID: 128475 Horde
	function self.useEmpoweredRune()
		if self.options.useEmpoweredRune and not UnitIsDeadOrGhost("player") and not IsMounted() then
			if self.level < 110 then
				if getOptionValue("Use emp. Rune") == 1 then
					if getBuffRemain("player",self.augmentRune[self.primaryStat]) < 600 and not IsFlying() then
						if self.faction == "Alliance" and self.level < 110 then
							useItem(128482)
						else 
							useItem(128475)
						end
					end
				end
				if getOptionValue("Use emp. Rune") == 2 and br.player.instance=="raid" then
					if getBuffRemain("player",self.augmentRune[self.primaryStat]) < 600 and not IsFlying() then
						if self.faction == "Alliance" and self.level < 110 then
							useItem(128482)
						else 
							useItem(128475)
						end
					end
				end
			elseif self.level >= 110 then
				if getOptionValue("Use emp. Rune") == 1 then
					if getBuffRemain("player",224001) < 600 and not IsFlying() and not IsMounted() then
						useItem(140587)
					end
				end
				if getOptionValue("Use emp. Rune") == 2 and br.player.instance=="raid" then
					if getBuffRemain("player",224001) < 600 and not IsFlying() and not IsMounted() then
						useItem(140587)
					end
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

	function self.getConsumables()
		for i = 0, 4 do --Let's look at each bag
			local numBagSlots = GetContainerNumSlots(i)
			if numBagSlots>0 then
				for x = 1, numBagSlots do --Let's look at each bag slot
					local itemID = GetContainerItemID(i,x)
					if itemID~=nil then -- Is there and item in the slot?
						local itemEffect = select(1,GetItemSpell(itemID))
						if itemEffect~=nil then --Does the item provide a use effect? 
							local itemInfo = { --Collect Item Data
								itemID 		= itemID,
								itemCD 		= GetItemCooldown(itemID),
								itemName 	= select(1,GetItemInfo(itemID)),
								minLevel 	= select(5,GetItemInfo(itemID)),
								itemType 	= select(7,GetItemInfo(itemID)),
								itemEffect 	= itemEffect,
								itemCount 	= GetItemCount(itemID)
							}
							if itemInfo.itemType == "Potion" and self.level >= itemInfo.minLevel then -- Is the item a Potion and am I level to use it?
								local potionList = {
									{ptype = "action", 		effect = "Action"},
									{ptype = "agility", 	effect = "Agility"},
									{ptype = "armor", 		effect = "Armor"},
									{ptype = "breathing", 	effect = "Underwater"},
									{ptype = "health", 		effect = "Healing"},
									{ptype = "intellect", 	effect = "Intellect"},
									{ptype = "invis", 		effect = "Invisibility"},
									{ptype = "mana", 		effect = "Mana"},
									{ptype = "rage", 		effect = "Rage"},
									{ptype = "rejuve", 		effect = "Rejuvenation"},
									{ptype = "speed", 		effect = "Swiftness"},
									{ptype = "strength", 	effect = "Strength"},
									{ptype = "versatility", effect = "Versatility"},
									{ptype = "waterwalk", 	effect = "Water Walking"}
								}
								for y = 1, #potionList do --Look for and add to right potion table
									local potionEffect = potionList[y].effect
									local potionType = potionList[y].ptype
									-- if self.potion[potionType] == nil then self.potion[potionType] = {} end
									if strmatch(itemEffect,potionEffect)~=nil then
										tinsert(self.potion[potionType],itemInfo)
										table.sort(self.potion[potionType], function(x,y)
											return x.minLevel and y.minLevel and x.minLevel > y.minLevel or false
										end)
									end
								end
							end
							if itemInfo.itemType == "Flask" and self.level >= itemInfo.minLevel then -- Is the item a Flask and am I level to use it?
								--TODO
							end
						end
					end
				end
			end
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