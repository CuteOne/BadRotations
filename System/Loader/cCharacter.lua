--- Character Class
-- All classes inherit from the base class /cCharacter.lua
cCharacter = {}
-- Creates new character with given class
function cCharacter:new(class)
	local self = {}
  self.augmentRune    = {         -- Contains the different buff IDs for Augment Runes
		Agility   					= 270058,
		Strength  					= 270058,
		Intellect 					= 270058,
		Legion	  					= 224001,
  }
  self.artifact       = {} 	-- Artifact Perk IDs
	self.buff           = {}        -- Buffs
  self.debuff         = {}        -- Debuffs on target
	self.class          = select(2, UnitClass("player")) -- Class
	self.cd             = {}        -- Cooldowns
	self.charges        = {}        -- Number of charges
	self.currentPet     = "None" 	-- Current Pet
  self.dynLastUpdate  = 0         -- Timer variable to reduce Dynamic Target updating
  self.dynTargetTimer = 0.5       -- Timer to reduce Dynamic Target updating (1/X = calls per second)
	self.enemies  	    = {}        -- Number of Enemies around player (must be overwritten by cCLASS or cSPEC)
	self.equiped 	    	= {} 	-- Item Equips
	self.gcd            = 1.5       -- Global Cooldown
	self.gcdMax 	    	= 1.5 	-- GLobal Max Cooldown
	self.glyph          = {}        -- Glyphs
	self.faction  	    = select(1,UnitFactionGroup("player")) -- Faction non-localised name
  self.flask 	    		= {}
  self.flask.wod 	    = {
	  -- Agility
	  agilityLow 					= 152638, 	 -- flask-of-the-currents
	  agilityBig 					= 152638, 	 -- flask-of-the-currents
	  -- Intellect
	  intellectLow 	      = 152639,        -- flask-of-endless-fathoms
	  intellectBig 	      = 152639,        -- flask-of-endless-fathoms
	  -- Stamina
	  staminaLow 					= 152640,        -- flask-of-the-vast-horizon
	  staminaBig					= 152640,        -- flask-of-the-vast-horizon
	  -- Strength
	  strengthLow 	      = 152641,        -- flask-of-the-undertow
	  strengthBig         = 152641,        -- flask-of-the-undertow
  }
  self.flask.wod.buff = {
	  -- Agility
	  agilityLow 					= 251836,
	  agilityBig 					= 251836,
	  -- Intellect
	  intellectLow       	= 251837,
	  intellectBig     		= 251837,
	  -- Stamina
	  staminaLow 					= 251838,
	  staminaBig 					= 251838,
	  -- Strength
	  strengthLow       	= 251839,
	  strengthBig 	      = 251839,
  }
    --self.functions 	    = {} 	-- Functions
	self.health         = 100       -- Health Points in %
	self.ignoreCombat   = false     -- Ignores combat status if set to true
	self.inCombat       = false     -- if is in combat
	self.instance 	    = select(2,IsInInstance()) 	-- Get type of group we are in (none, party, instance, raid, etc)
	self.level	    		= 0 	-- Player Level
	self.mode           = {}        -- Toggles
	self.moving         = false        -- Moving event
	self.options 	    	= {}        -- Contains options
	self.perk 	    		= {}	-- Perk Table
	self.petId 	    		= 0 	-- Current Pet Id
	self.pet 	    			= {} 	-- Pet Information Table
	self.pet.list 	    = {}
	self.potion 	    	= {}	-- Potion Table
	self.primaryStat    = nil       -- Contains the primary Stat: Strength, Agility or Intellect
	self.profile        = "None"    -- Spec
	self.queue 	    		= {} 	-- Table for Queued Spells
	self.race     	    = select(2,UnitRace("player"))  -- Race as non-localised name (undead = Scourge) !
	self.racial   	    = getRacialID()     -- Contains racial spell id
	self.recharge       = {}        -- Time for current recharge (for spells with charges)
	self.rechargeFull   = {}
	self.selectedRotation = 1       -- Default: First avaiable rotation
  self.rotation       = {} 	-- List of Rotations
	self.spell	    		= {}        -- Spells all classes may have (e.g. Racials, Mass Ressurection)
	self.talent         = {}        -- Talents
	self.timeToMax	    = 0		-- Time To Max Power
	self.traits         = {}	-- Azerite Traits
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
			self.potion.breathing = {}
			self.potion.health		= {}	-- Health Potions
			self.potion.intellect = {}	-- Intellect Potions
			self.potion.invis 		= {}
			self.potion.mana 			= {}	-- Mana Potions
			self.potion.rage 			= {}
			self.potion.rejuve 		= {}
			self.potion.speed			= {}
			self.potion.strength 	= {}	-- Strength Potions
			self.potion.versatility = {} 	-- Versatility Potions
			self.potion.waterwalk = {}
			self.getConsumables()		-- Find All The Tasty Things!
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
		if isChecked("Debug Timers") then
			br.debug.cpu.rotation.baseUpdate = debugprofilestop()-startTime or 0
		end
	end

-- Update Character Stats
	function self.getCharacterInfo()
		self.gcd 						= self.getGlobalCooldown()
		self.gcdMax 				= self.getGlobalCooldown(true)
		self.health 				= getHP("player")
		self.instance 			= select(2,IsInInstance())
		self.level 					= UnitLevel("player") -- TODO: EVENT - UNIT_LEVEL
		self.spec 					= select(2, GetSpecializationInfo(GetSpecialization())) or "None"
		self.currentPet			= UnitCreatureFamily("pet") or "None"
		if self.currentPet  ~= "None" then
		  self.petId 		    = tonumber(UnitGUID("pet"):match("-(%d+)-%x+$"), 10)
		else
		    self.petId 			= 0
		end
		self.posX, self.posY, self.posZ = GetObjectPosition("player")
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
	function self.getGlobalCooldown(max)
		local currentSpecName = select(2,GetSpecializationInfo(GetSpecialization()))
		if max == true then
			if currentSpecName=="Feral" or currentSpecName=="Brewmaster" or currentSpecName=="Windwalker" or UnitClass("player") == "Rogue" then
				return 1
			else
				return math.max(math.max(1, 1.5 / (1 + UnitSpellHaste("player") / 100)), 0.75)
			end
		end
		return getSpellCD(61304)
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
        self.selectedRotation = br.selectedProfile

        if br.rotationChanged then
            self.createOptions()
            self.createToggles()
            br.ui.window.profile.parent:Show()
        end
    end

-- Start the rotation or return if pause
    function self.startRotation()
    	local startTime = debugprofilestop()
        -- dont check if player is casting to allow off-cd usage and cast while other spell is casting
        if pause(true) then return end

        if self.rotation ~= nil then
        	self.rotation.run()
        else
        	return
        end
		if isChecked("Debug Timers") then
	        br.debug.cpu.rotation.currentTime = debugprofilestop()-startTime
			br.debug.cpu.rotation.totalIterations = br.debug.cpu.rotation.totalIterations + 1
			br.debug.cpu.rotation.elapsedTime = br.debug.cpu.rotation.elapsedTime + debugprofilestop()-startTime
			br.debug.cpu.rotation.averageTime = br.debug.cpu.rotation.elapsedTime / br.debug.cpu.rotation.totalIterations
			if not self.inCombat then
				if br.debug.cpu.rotation.currentTime > br.debug.cpu.rotation.maxTimeOoC then br.debug.cpu.rotation.maxTimeOoC = br.debug.cpu.rotation.currentTime end
				if br.debug.cpu.rotation.currentTime < br.debug.cpu.rotation.minTimeOoC then br.debug.cpu.rotation.minTimeOoC = br.debug.cpu.rotation.currentTime end
			else
				if br.debug.cpu.rotation.currentTime > br.debug.cpu.rotation.maxTimeInC then br.debug.cpu.rotation.maxTimeInC = br.debug.cpu.rotation.currentTime end
				if br.debug.cpu.rotation.currentTime < br.debug.cpu.rotation.minTimeInC then br.debug.cpu.rotation.minTimeInC = br.debug.cpu.rotation.currentTime end
			end
		end
    end

-- Updates special Equipslots
	function self.baseGetEquip()
		if self.equiped == nil then self.equiped = {} end
		if self.equiped.t17 == nil or br.equipHasChanged == nil or br.equipHasChanged then
			for i = 17, 21 do
				if self.equiped["t"..i] == nil then self.equiped["t"..i] = 0 end
				self.equiped["t"..i] = TierScan("T"..i) or 0
			end
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
			self.equiped.t18_classTrinket = isTrinketEquipped(classTrinket[string.lower(self.class)])

            br.equipHasChanged = false
        end
	end

-- Sets the racial
	function self.getRacial()
		-- local versioncheck = select(1,GetBuildInfo())
		-- local build = select(2,GetBuildInfo())
		-- local vnumber = versioncheck:gsub("(%D+)","")
		-- if tonumber(vnumber) > 735 or (tonumber(vnumber) == 735 and tonumber(build) >= 26972)
		-- 	then version = "BFA"
		-- else
		-- 	version = "Legion"
		-- end
		-- if version == "Legion" then
		-- 	if self.race == "BloodElf" then
		--         BloodElfRacial = select(7, GetSpellInfo(GetSpellInfo(69179)))
		--     end
		--     if self.race == "Draenei" then
		--         DraeneiRacial = select(7, GetSpellInfo(GetSpellInfo(28880)))
		--     end
		--     if self.race == "Orc" then
		--         OrcRacial = select(7, GetSpellInfo(GetSpellInfo(20572)))
		--     end
		-- 	local racialSpells = {
		-- 		-- Alliance
		-- 		Dwarf    			= 20594, -- Stoneform
		-- 		Gnome    			= 20589, -- Escape Artist
		-- 		Draenei  			= DraeneiRacial, -- Gift of the Naaru
		-- 		Human    			= 59752, -- Every Man for Himself
		-- 		NightElf 			= 58984, -- Shadowmeld
		-- 		Worgen   			= 68992, -- Darkflight
		-- 		-- Horde
		-- 		BloodElf 			= BloodElfRacial, -- Arcane Torrent
		-- 		Goblin   			= 69041, -- Rocket Barrage
		-- 		Orc      			= OrcRacial, -- Blood Fury
		-- 		Tauren  			= 20549, -- War Stomp
		-- 		Troll    			= 26297, -- Berserking
		-- 		Scourge  			= 7744,  -- Will of the Forsaken
		-- 		-- Both
		-- 		Pandaren 			= 107079, -- Quaking Palm
		-- 		-- Allied Races
		--         HighmountainTauren 	= 255654, -- Bull Rush
		--         LightforgedDraenei 	= 255647, -- Light's Judgment
		--         Nightborne 			= 260364, -- Arcane Pulse
		--         VoidElf 			= 256948, -- Spatial Rift
		-- 	}
		-- 	if br.player ~= nil then
		-- 		return br.player.spells.racial
		-- 	else
		-- 		return racialSpells[self.race]
		-- 	end
		-- elseif version == "BFA" then
		-- 	if self.race == "BloodElf" then
	        --     BloodElfRacial = select(7, GetSpellInfo(GetSpellInfo(69179)))
	        -- 	end
		--     if self.race == "Draenei" then
		--         DraeneiRacial = select(7, GetSpellInfo(GetSpellInfo(28880)))
		--     end
		--     if self.race == "Orc" then
		--         OrcRacial = select(7, GetSpellInfo(GetSpellInfo(33702)))
		--     end
		-- 	local racialSpells = {
		-- 		-- Alliance
		-- 		Dwarf    			= 20594, -- Stoneform
		-- 		Gnome    			= 20589, -- Escape Artist
		-- 		Draenei  			= DraeneiRacial, -- Gift of the Naaru
		-- 		Human    			= 59752, -- Every Man for Himself
		-- 		NightElf 			= 58984, -- Shadowmeld
		-- 		Worgen   			= 68992, -- Darkflight
		-- 		-- Horde
		-- 		BloodElf 			= BloodElfRacial, -- Arcane Torrent
		-- 		Goblin   			= 69041, -- Rocket Barrage
		-- 		Orc      			= OrcRacial, -- Blood Fury
		-- 		Tauren  			= 20549, -- War Stomp
		-- 		Troll    			= 26297, -- Berserking
		-- 		Scourge  			= 7744,  -- Will of the Forsaken
		-- 		-- Both
		-- 		Pandaren 			= 107079, -- Quaking Palm
		-- 		-- Allied Races
		--         HighmountainTauren 	= 255654, -- Bull Rush
		--         LightforgedDraenei 	= 255647, -- Light's Judgment
		--         Nightborne 			= 260364, -- Arcane Pulse
		--         VoidElf 			= 256948, -- Spatial Rift
		-- 		DarkIronDwarf 		= 265221, -- Fireblood
		--         MagharOrc 		= 274738, -- Ancestral Call
		-- 	}
		-- 	if br.player ~= nil then
				return self.racial
		-- 	else
		-- 		return racialSpells[self.race]
		-- 	end
		-- end

	end
    --self.racial = self.getRacial()
    -- if self.spell.racial == nil and br.player ~= nil then self.spell.racial = self.getRacial(); end

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

-- Return
	return self
end
