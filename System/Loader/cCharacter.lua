--- Character Class
-- All classes inherit from the base class /cCharacter.lua
cCharacter = {}
-- Creates new character with given class
function cCharacter:new(class)
	local self = {}
	self.augmentRune    = {         -- Contains the different buff IDs for Augment Runes
			Agility   		= 270058,
			Strength  		= 270058,
			Intellect 		= 270058,
			Legion	  		= 224001,
	}
	self.artifact       	= {} 									-- Artifact Perk IDs
	self.buff           	= {}        							-- Buffs API
	self.debuff         	= {}        							-- Debuffs API
	self.class          	= select(2, UnitClass("player")) 		-- Class
	self.cd             	= {}        							-- Cooldowns
	self.charges        	= {}        							-- Number of charges
	self.currentPet     	= "None" 								-- Current Pet
	self.dynLastUpdate  	= 0         							-- Timer variable to reduce Dynamic Target updating
	self.dynTargetTimer 	= 0.5       							-- Timer to reduce Dynamic Target updating (1/X = calls per second)
	self.enemies  	    	= {}        							-- Number of Enemies around player (must be overwritten by cCLASS or cSPEC)
	self.essence 			= {} 									-- Azerite Essence
	self.equiped 	    	= {} 									-- Item Equips
	self.gcd            	= 1.5       							-- Global Cooldown
	self.gcdMax 	    	= 1.5 									-- GLobal Max Cooldown
	self.glyph          	= {}        							-- Glyphs
	self.faction  	    	= select(1,UnitFactionGroup("player")) 	-- Faction non-localised name
	self.flask 	    		= {}
	self.flask.wod 	    	= {
		-- Agility
		agilityLow 			= 152638, 	 							-- flask-of-the-currents
		agilityBig 			= 152638, 	 							-- flask-of-the-currents
		-- Intellect
		intellectLow 	    = 152639,        						-- flask-of-endless-fathoms
		intellectBig 	    = 152639,        						-- flask-of-endless-fathoms
		-- Stamina
		staminaLow 			= 152640,        						-- flask-of-the-vast-horizon
		staminaBig			= 152640,        						-- flask-of-the-vast-horizon
		-- Strength
		strengthLow 	    = 152641,        						-- flask-of-the-undertow
		strengthBig         = 152641,        						-- flask-of-the-undertow
	}
	self.flask.wod.buff = {
		-- Agility
		agilityLow 			= 251836,
		agilityBig 			= 251836,
		-- Intellect
		intellectLow       	= 251837,
		intellectBig     	= 251837,
		-- Stamina
		staminaLow 			= 251838,
		staminaBig 			= 251838,
		-- Strength
		strengthLow       	= 251839,
		strengthBig 	    = 251839,
	}
    self.functions 	    	= {} 							-- Custom Profile Functions
	self.health         	= 100       					-- Health Points in %
	self.ignoreCombat   	= false     					-- Ignores combat status if set to true
	self.inCombat       	= false     					-- if is in combat
	self.instance 	    	= select(2,IsInInstance()) 		-- Get type of group we are in (none, party, instance, raid, etc)
	self.level	    		= 0 							-- Player Level
	self.moving         	= false        					-- Moving event
	self.opener 			= {} 							-- Opener flag tracking, reduce global vars
	self.pandemic 			= {}  							-- Tracking Base Duration per Unit/Debuff
	self.perk 	    		= {}							-- Perk Table
	self.petId 	    		= 0 							-- Current Pet Id
	self.pet 	    		= {} 							-- Pet Information Table
	self.pet.list 	    	= {}							-- Table of Pets
	self.potion 	    	= {}							-- Potion Table
	self.primaryStat    	= nil       					-- Contains the primary Stat: Strength, Agility or Intellect
	self.profile        	= "None"    					-- Profile Name
	self.queue 	    		= {} 							-- Table for Queued Spells
	self.race     	    	= select(2,UnitRace("player"))  -- Race as non-localised name (undead = Scourge) !
	self.racial   	    	= 0     						-- Contains racial spell id
	-- self.recharge       	= {}        					-- Time for current recharge (for spells with charges)
	-- self.rechargeFull   	= {}							
	self.selectedRotation 	= 1       						-- Default: First avaiable rotation
	self.rotation       	= {} 							-- List of Rotations
	self.spell	    		= {}        					-- Spells all classes may have (e.g. Racials, Mass Ressurection)
	self.talent         	= {}        					-- Talents
	self.timeToMax	    	= 0								-- Time To Max Power
	self.traits         	= {}							-- Azerite Traits
	self.units          	= {}        					-- Dynamic Units (used for dynamic targeting, if false then target)
	self.ui 				= {}							-- UI API
	self.variables 			= {} 							-- Custom Profile Variables

-- Things which get updated for every class in combat
-- All classes call the baseUpdate()
	function self.baseUpdate()
		local startTime = debugprofilestop()
		-- Pause
		-- TODO
		-- Get Character Info
		self.getCharacterInfo()
		-- Get Consumables
		if br.bagsUpdated then
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
			self.flask.agility 		= {}
			self.flask.intellect  = {}
			self.flask.stamina		= {}
			self.flask.strength   = {}
			self.getConsumables()		-- Find All The Tasty Things!
			br.bagsUpdated = false
		end
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
		-- Debugging
		br.debug.cpu:updateDebug(startTime,"rotation.baseUpdate")
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
		-- Updates special Equip like set bonuses
		self.baseGetEquip()
		if getOptionCheck("Queue Casting") and #self.queue ~= 0 then
			self.queue = {} -- Reset Queue Casting Table out of combat
			Print("Out of Combat - Queue List Cleared")
		end
		self.ignoreCombat = getOptionCheck("Ignore Combat")
	end

-- Updates toggle data
    -- TODO: here should only happen generic ones like Defensive etc.
	function self.getToggleModes()

		self.ui.mode.rotation  = br.data.settings[br.selectedSpec].toggles["Rotation"]
		self.ui.mode.cooldown 	= br.data.settings[br.selectedSpec].toggles["Cooldown"]
		self.ui.mode.defensive = br.data.settings[br.selectedSpec].toggles["Defensive"]
		self.ui.mode.interrupt = br.data.settings[br.selectedSpec].toggles["Interrupt"]
	end

-- Returns the Global Cooldown time
	function self.getGlobalCooldown(max)
		return getGlobalCD(max)
    end

-- Starts auto attack when in melee range and facing enemy
	function self.startMeleeAttack()
		if self.inCombat and (isInMelee() and getFacing("player","target") == true) then
			StartAttack()
		end
	end

	function self.tankAggro()
		if self.instance=="raid" or self.instance=="party" then
			local tanksTable = getTanksTable()
			if tanksTable ~= nil then
				for i = 1, #tanksTable do
					if UnitAffectingCombat(tanksTable[i].unit) and tanksTable[i].distance < 40 then
						return true
					end
				end
			end
		end
		return false
	end


-- Returns if in combat
	function self.getInCombat()
		if UnitAffectingCombat("player") or self.ignoreCombat or (isChecked("Tank Aggro = Player Aggro") and self.tankAggro())
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
        -- if pause(true) then return end

        if self.rotation ~= nil then
			self.rotation.run()
        else
			return
		end
		-- Debugging
		br.debug.cpu:updateDebug(startTime,"rotation")
		-- if isChecked("Debug Timers") then
		-- 	-- br.debug.cpu.rotation = {
		-- 	-- 	maxTimeOoC = 0,
		-- 	-- 	minTimeOoC = 999,
		-- 	-- 	maxTimeInC = 0,
		-- 	-- 	minTimeInC = 999,
		-- 	-- }
		-- 	if not self.inCombat then
		-- 		if br.debug.cpu.rotation.currentTime > br.debug.cpu.rotation.maxTimeOoC then br.debug.cpu.rotation.maxTimeOoC = br.debug.cpu.rotation.currentTime end
		-- 		if br.debug.cpu.rotation.currentTime < br.debug.cpu.rotation.minTimeOoC then br.debug.cpu.rotation.minTimeOoC = br.debug.cpu.rotation.currentTime end
		-- 	else
		-- 		if br.debug.cpu.rotation.currentTime > br.debug.cpu.rotation.maxTimeInC then br.debug.cpu.rotation.maxTimeInC = br.debug.cpu.rotation.currentTime end
		-- 		if br.debug.cpu.rotation.currentTime < br.debug.cpu.rotation.minTimeInC then br.debug.cpu.rotation.minTimeInC = br.debug.cpu.rotation.currentTime end
		-- 	end
		-- end
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
		return br.getRacial()
	 end

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
        br.ui:createCheckbox(section_base, "Ignore Combat", "Checking this will make BR think it is always in combat")
		br.ui:createCheckbox(section_base, "Mute Queue", "Mute messages from Smart Queue and Queue Casting")
        br.ui:createDropdown(section_base, "Pause Mode", br.dropOptions.Toggle, 2, "Define a key which pauses the rotation.")
        br.ui:checkSectionState(section_base)
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
								itemName 	= GetItemInfo(itemID),
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
								local flaskList = {
									{id = 152638,   type = "agility"},
									{id = 152639,   type = "intellect"},
									{id = 152640,   type = "stamina"},
									{id = 152641,   type = "strength"},
								}
								for y = 1, #flaskList do
									local flasktype = flaskList[y].type
									local flaskID = flaskList[y].id
									if strmatch(itemInfo.itemID,flaskID)~=nil then
										tinsert(self.flask[flasktype],itemInfo)
										table.sort(self.flask[flasktype], function(x,y)
											return x.minLevel and y.minLevel and x.minLevel > y.minLevel or false
										end)
									end
								end
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
