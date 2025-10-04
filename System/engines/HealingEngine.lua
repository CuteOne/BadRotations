local _, br = ...
br.engines.healingEngine = br.engines.healingEngine or {} -- This will be the MetaTable attached to our Main Table that the world will see
local healingEngine = br.engines.healingEngine

--[[---------------------------------------------------------------------------------------------------



-----------------------------------------Bubba's Healing Engine--------------------------------------]]
-- local LGIST = br._G.LibStub("LibGroupInSpecT-1.1")
if not healingEngine.metaTable1 then
	-- localizing the commonly used functions while inside loops
	local getDistance, tinsert, tremove, UnitClass, GetUnitIsUnit = br.getDistance, br._G.tinsert, br._G.tremove, br._G.UnitClass, br.GetUnitIsUnit
	local UnitHealth, UnitHealthMax = br._G.UnitHealth, br._G.UnitHealthMax
	local GetTime, UnitDebuffID = br._G.GetTime, br.UnitDebuffID
	br.engines.healingEngine.friend = {} -- This is our main Table that the world will see
	healingEngine.memberSetup = {} -- This is one of our MetaTables that will be the default user/contructor
	healingEngine.memberSetup.cache = {} -- This is for the cache Table to check against
	healingEngine.__call = function(_) -- (_, forceRetable, excludePets, onlyInRange) [Not Implemented]
		local group = br._G.IsInRaid() and "raid" or "party" -- Determining if the UnitID will be raid or party based
		local groupSize = br._G.IsInRaid() and br._G.GetNumGroupMembers() or br._G.GetNumGroupMembers() - 1 -- If in raid, we check the entire raid. If in party, we remove one from max to account for the player.
		if group == "party" then
			tinsert(br.engines.healingEngine.friend, healingEngine.memberSetup:new("player"))
		end -- We are creating a new User for player if in a Group
		for i = 1, groupSize do -- start of the loop to read throught the party/raid
			local groupUnit = group .. i
			local groupMember = healingEngine.memberSetup:new(groupUnit)
			if groupMember then
				tinsert(br.engines.healingEngine.friend, groupMember)
			end -- Inserting a newly created Unit into the Main Frame
		end
	end
	healingEngine.__index = {
		-- Setting the Metamethod of Index for our Main Table
		name = "Healing Table",
		author = "Bubba"
	}
	-- Creating a default Unit to default to on a check
	healingEngine.memberSetup.__index = {
		name = "noob",
		hp = 100,
		unit = "noob",
		role = "NOOB",
		range = false,
		guid = 0,
		guidsh = 0,
		class = "NONE"
	}
	-- If ever somebody enters or leaves the raid, wipe the entire Table
	local updateHealingTable = br._G.CreateFrame("frame", nil)
	updateHealingTable:RegisterEvent("GROUP_ROSTER_UPDATE")
	updateHealingTable:SetScript(
		"OnEvent",
		function()
			_G.table.wipe(br.engines.healingEngine.friend)
			_G.table.wipe(healingEngine.memberSetup.cache)
			healingEngine:SetupTables()
		end
	)
	-- This is for those NPC units that need healing. Compare them against our list of Unit ID's
	local function SpecialHealUnit(tar)
		for i = 1, #br.engines.healingEngineCollections.SpecialHealUnitList do
			if br.functions.unit:getGUID(tar) == br.engines.healingEngineCollections.SpecialHealUnitList[i] then
				return true
			end
		end
	end
	-- We are checking if the user has a Debuff we either can not or don't want to heal them
	local function CheckBadDebuff(tar)
		for i = 1, 40 do
			local auraInfo = br._G.UnitAura(tar, i, "HELPFUL|HARMFUL")
			if auraInfo then
				if auraInfo.name then
					if br.engines.healingEngineCollections.BadDebuffList[auraInfo.spellID] ~= nil then
						return false
					end
				end
			end
		end
		return true
	end

	-- This is for NPC units we do not want to heal. Compare to list in collections.
	local function CheckSkipNPC(tar)
		local npcId = (br.functions.unit:getGUID(tar))
		for i = 1, #br.engines.healingEngineCollections.skipNPC do
			if npcId == br.engines.healingEngineCollections.skipNPC[i] then
				return true
			end
		end
		return false
	end
	local function CheckCreatureType(tar)
		local CreatureTypeList = {"Critter", "Totem", "Non-combat Pet", "Wild Pet"}
		for i = 1, #CreatureTypeList do
			if br._G.UnitCreatureType(tar) == CreatureTypeList[i] then
				return false
			end
		end
		if not br._G.UnitIsBattlePet(tar) and not br._G.UnitIsWildBattlePet(tar) then
			return true
		else
			return false
		end
	end
	-- Verifying the target is a Valid Healing target
	function healingEngine:HealCheck(tar)
		if
			(br.functions.unit:GetUnitIsVisible(tar) and br.functions.unit:GetUnitReaction("player", tar) > 4 and not br.functions.unit:GetUnitIsDeadOrGhost(tar) and br.functions.misc:getLineOfSight("player", tar) and CheckCreatureType(tar) and
				br._G.UnitInPhase(tar)) and
				((br.functions.misc:isPlayer(tar) and br._G.UnitIsConnected(tar) and CheckBadDebuff(tar) and not br._G.UnitIsCharmed(tar) and not br._G.UnitIsOtherPlayersPet(tar)) or
					((GetUnitIsUnit(tar,"pet") or br._G.UnitIsOtherPlayersPet(tar)) and br.functions.misc:getOptionCheck("Heal Pets")) or
					br.engines.healingEngineCollections.SpecialHealUnitList[tonumber(select(2, br.functions.unit:getGUID(tar)))] ~= nil)
		 then
			return true
		else
			return false
		end
	end
	function healingEngine.memberSetup:new(unit)
		-- Seeing if we have already cached this unit before
		if healingEngine.memberSetup.cache[br.functions.unit:getGUID(unit)] then
			return false
		end
		local o = {}
		setmetatable(o, healingEngine.memberSetup)
		if unit and type(unit) == "string" then
			o.unit = unit
		end
		-- We are checking the HP of the person through their own function.
		function o:CalcHP()
			local toxicBrand = br.functions.misc:getOptionValue("Toxic Brand")
			local necroRot = br.functions.misc:getOptionValue("Necrotic Rot")
			if toxicBrand == 0 or toxicBrand == nil then
				toxicBrand = 10
			end
			if necroRot == 0 or necroRot == nil then
				necroRot = 40
			end
			-- Bandaid fix?
			if o.unit == nil then return 0, 0, 0 end
			-- Darkness phase of Kil'Jaeden. basically blacklists all friends if I have this debuff, since I can't heal.
			-- but once I have Illidan's Sightless Gaze (241721), I can hea
			if br.functions.misc:isChecked("Necrotic Rot") and br.functions.aura:getDebuffStacks(o.unit, 209858) > 0 and br.functions.aura:getDebuffStacks(o.unit, 209858) >= necroRot then
				return 250, 250, 250
			end
			if br.functions.aura:UnitBuffID(o.unit, 360618) then
				return 250, 250, 250
			end
			if br.functions.aura:UnitBuffID(o.unit, 295271) then
				return 250, 250, 250
			end
			if br.functions.aura:UnitBuffID(o.unit, 344916) then
				return 250, 250, 250
			end
			if br.functions.aura:UnitBuffID(o.unit, 327140) or br.functions.aura:UnitBuffID(o.unit, 327676) then
				return 250, 250, 250
			end
			if br.functions.misc:isChecked("Toxic Brand") and br.player.eID and br.player.eID == 2298 then
				if br.functions.aura:getDebuffStacks(o.unit, 294715) > 0 and br.functions.aura:getDebuffStacks(o.unit, 294715) >= toxicBrand then
					return 250, 250, 250
				end
			end
			if select(9, br._G.GetInstanceInfo()) == 1676 and UnitDebuffID("player", 236555) and not UnitDebuffID("player", 241721) then
				return 250, 250, 250
			end
			if br.player.eID == 2331 then
				local time_remain = br.functions.DBM:getPulltimer(nil, 313213)
				if time_remain < br.functions.misc:getOptionValue("Decaying Strike Timer") then
					for i = 1, br._G.GetObjectCount() do
						local thisUnit = br._G.GetObjectWithIndex(i)
						if br.functions.unit:GetObjectID(thisUnit) == 156866 and br._G.UnitTarget(thisUnit) ~= nil then
							if br._G.UnitTarget(thisUnit) == o.unit then
								return 250, 250, 250
							end
						end
					end
				end
			end
			if br.player.eID == 2407 then
				local targetBuff = 0
				local playerBuff = 0
				if UnitDebuffID(o.unit, 340687) then
					targetBuff = 1
				end
				if UnitDebuffID("player", 340687) then
					playerBuff = 1
				end
				if playerBuff ~= targetBuff then
					return 250, 250, 250
				end
			end
			if br.player.eID == 2343 then
				local targetBuff = 0
				local playerBuff = 0
				if UnitDebuffID(o.unit, 310499) then
					targetBuff = 1
				end
				if UnitDebuffID("player", 310499) then
					playerBuff = 1
				end
				if playerBuff ~= targetBuff then
					return 250, 250, 250
				end
			end
			-- Place out of range players at the end of the list -- replaced range to 40 as we should be using lib range
			if not br._G.UnitInRange(o.unit) and getDistance(o.unit) > 40 and not GetUnitIsUnit("player", o.unit) then
				return 250, 250, 250
			end
			-- Place Dead players at the end of the list
			if o.hcRefresh == nil or o.hcRefresh < GetTime() - 1 then
				local startTime = br._G.debugprofilestop()
				if healingEngine:HealCheck(o.unit) ~= true or UnitHealth(o.unit) == 0 then
					return 250, 250, 250
				end
				br.debug.cpu.healingEngine.HealCheck = br._G.debugprofilestop() - startTime
				o.hcRefresh = GetTime()
			end
			-- incoming heals
			local incomingheals
			if br.functions.misc:getOptionCheck("Incoming Heals") == true and br._G.UnitGetIncomingHeals(o.unit, "player") ~= nil then
				incomingheals = br._G.UnitGetIncomingHeals(o.unit, "player")
			else
				incomingheals = 0
			end
			-- absorbs
			local nAbsorbs
			if br.functions.misc:getOptionCheck("Ignore Absorbs") ~= true then
				nAbsorbs = (br._G.UnitGetTotalAbsorbs(o.unit) * 0.25)
			else
				nAbsorbs = 0
			end
			-- calc base + absorbs + incomings
			local PercentWithIncoming = 100 * (UnitHealth(o.unit) + incomingheals + nAbsorbs) / UnitHealthMax(o.unit)
			if br.functions.misc:getOptionCheck("Prioritize Tank") then
				-- Using the group role assigned to the Unit
				if o.role == "TANK" then
					PercentWithIncoming = PercentWithIncoming - br.functions.misc:getOptionValue("Prioritize Tank")
				end
				-- Tank in Proving Grounds
				if o.guidsh == 72218 then
					PercentWithIncoming = PercentWithIncoming - br.functions.misc:getOptionValue("Prioritize Tank")
				end
				-- Using threat to remove %hp from all tanking units
				if o.threat == 3 then
					PercentWithIncoming = PercentWithIncoming - br.functions.misc:getOptionValue("Prioritize Tank")
				end
			end
			-- if br.functions.misc:getOptionCheck("Prioritize Debuff") then
			-- 	-- Using Dispel Check to see if we should give bonus weight
			-- 	if o.dispel then
			-- 		PercentWithIncoming = PercentWithIncoming - br.functions.misc:getOptionValue("Prioritize Debuff")
			-- 	end
			-- end
			local ActualWithIncoming = (UnitHealthMax(o.unit) - (UnitHealth(o.unit) + incomingheals))
			-- Debuffs HP compensation
			local debugTimerStartTime = GetTime()
			for i = 1, 40 do
				local _, _, count, _, _, _, _, _, _, SpellID = br._G.UnitAura(o.unit, i, "HELPFUL|HARMFUL")
				local debuffID = br.engines.healingEngineCollections.SpecificHPDebuffs[SpellID]
				if debuffID ~= nil then
				  for i = 1, #debuffID do
					  local debuffData = debuffID[i]
					  if debuffData ~= nil and (debuffData.stacks == nil or (count and count >= debuffData.stacks)) then
						  PercentWithIncoming = PercentWithIncoming - debuffData.value
						  break
					  end
				  end
			  end
      end
			local elapsedDebugTime = GetTime() - debugTimerStartTime
			if elapsedDebugTime > 0.5 then
				br._G.print("WARNING: Debuff Scan took a long time: " .. elapsedDebugTime .. " Seconds")
			end
			if br.functions.misc:getOptionCheck("Blacklist") == true and br.data.blackList ~= nil then
				for i = 1, #br.data.blackList do
					if o.guid == br.data.blackList[i].guid then
						PercentWithIncoming, ActualWithIncoming, nAbsorbs = PercentWithIncoming + br.functions.misc:getValue("Blacklist"), ActualWithIncoming + br.functions.misc:getValue("Blacklist"), nAbsorbs + br.functions.misc:getValue("Blacklist")
						break
					end
				end
			end
			return PercentWithIncoming, ActualWithIncoming, nAbsorbs
		end
		-- returns unit GUID
		function o:nGUID()
			local nShortHand = ""
			local targetGUID = ""
			if br.functions.unit:GetUnitIsVisible(unit) then
				targetGUID = br._G.UnitGUID(unit)
				nShortHand = br._G.UnitGUID(unit):sub(-5)
			end
			return targetGUID, nShortHand
		end
		-- Returns unit class
		function o:GetClass()
			if br._G.UnitGroupRolesAssigned(o.unit) == "NONE" then
				if GetUnitIsUnit("player", o.unit) then
					return UnitClass("player")
				end
				if br.engines.healingEngineCollections.roleTable[br._G.UnitName(o.unit)] ~= nil then
					return br.engines.healingEngineCollections.roleTable[br._G.UnitName(o.unit)].class
				end
			else
				return UnitClass(o.unit)
			end
		end
		-- return unit role
		function o:GetRole()
			if br._G.UnitGroupRolesAssigned(o.unit) == "NONE" then
				-- if we already have a role defined we dont scan
				if br.engines.healingEngineCollections.roleTable[br._G.UnitName(o.unit)] ~= nil then
					return br.engines.healingEngineCollections.roleTable[br._G.UnitName(o.unit)].role
				else
---@diagnostic disable-next-line: undefined-field
					-- local info = LGIST:GetCachedInfo(br.functions.unit:getGUID(o.unit))
					-- if info and info.spec_role then
					-- 	return info.spec_role
					-- end
					return ""
				end
			else
				return br._G.UnitGroupRolesAssigned(o.unit)
			end
		end
		-- sets actual position of unit in engine, shouldnt refresh more than once/sec
		function o:GetPosition()
			if br.functions.unit:GetUnitIsVisible(o.unit) and br.functions.misc:getLineOfSight("player",o.unit) then
				o.refresh = GetTime()
				local x, y, z = br.functions.unit:GetObjectPosition(o.unit)
				x = math.ceil(x * 100) / 100
				y = math.ceil(y * 100) / 100
				z = math.ceil(z * 100) / 100
				return x, y, z
			else
				return 0, 0, 0
			end
		end
		-- Group Number of Player: getUnitGroupNumber(1)
		function o:getUnitGroupNumber()
			-- check if in raid
			if br._G.IsInRaid() and br._G.UnitInRaid(o.unit) ~= nil then
				return select(3, br._G.GetRaidRosterInfo(br._G.UnitInRaid(o.unit)))
			end
			return 0
		end
		-- Unit distance to player
		function o:getUnitDistance()
			if GetUnitIsUnit("player", o.unit) then
				return 0
			end
			return getDistance("player", o.unit)
		end
		-- Updating the values of the Unit
		function o:UpdateUnit()
			if br.functions.misc:isChecked("Debug Timers") then
				local startTime
				local debugprofilestop = br._G.debugprofilestop

				-- assign Name of unit
				startTime = debugprofilestop()
				o.name = br._G.UnitName(o.unit)
				br.debug.cpu.healingEngine.UnitName = debugprofilestop() - startTime

				-- assign real GUID of unit
				startTime = debugprofilestop()
				o.guid = o:nGUID()
				br.debug.cpu.healingEngine.nGUID = debugprofilestop() - startTime

				-- assign unit role
				startTime = debugprofilestop()
				o.role = o:GetRole()
				br.debug.cpu.healingEngine.GetRole = debugprofilestop() - startTime

				-- subgroup number
				startTime = debugprofilestop()
				o.subgroup = o:getUnitGroupNumber()
				br.debug.cpu.healingEngine.getUnitGroupNumber = debugprofilestop() - startTime

				-- Short GUID of unit for the SetupTable
				o.guidsh = select(2, o:nGUID())

				-- set to true if unit should be dispelled
				startTime = debugprofilestop()
				--o.dispel = o:Dispel(o.unit)
				br.debug.cpu.healingEngine.Dispel = debugprofilestop() - startTime

				-- distance to player
				startTime = debugprofilestop()
				o.distance = o:getUnitDistance()
				br.debug.cpu.healingEngine.getUnitDistance = debugprofilestop() - startTime

				-- Unit's threat situation(1-4)
				startTime = debugprofilestop()
				o.threat = br._G.UnitThreatSituation(o.unit)
				br.debug.cpu.healingEngine.UnitThreatSituation = debugprofilestop() - startTime

				-- Unit HP absolute
				startTime = debugprofilestop()
				o.hpabs = UnitHealth(o.unit)
				br.debug.cpu.healingEngine.UnitHealth = debugprofilestop() - startTime

				-- Unit HP missing absolute
				startTime = debugprofilestop()
				o.hpmissing = UnitHealthMax(o.unit) - UnitHealth(o.unit)
				br.debug.cpu.healingEngine.hpMissing = debugprofilestop() - startTime

				-- Unit HP
				startTime = debugprofilestop()
				--o.hp = o:CalcHP()
				--o.absorb = select(3, o:CalcHP())
				br.debug.cpu.healingEngine.absorb = debugprofilestop() - startTime

				-- Target's target
				o.target = tostring(o.unit) .. "target"

				-- Unit Class
				startTime = debugprofilestop()
				o.class = o:GetClass()
				br.debug.cpu.healingEngine.GetClass = debugprofilestop() - startTime

				-- Unit is player
				startTime = debugprofilestop()
				o.isPlayer = br._G.UnitIsPlayer(o.unit)
				br.debug.cpu.healingEngine.UnitIsPlayer = debugprofilestop() - startTime

				-- precise unit position
				startTime = debugprofilestop()
				o.x, o.y, o.z = o:GetPosition()
				br.debug.cpu.healingEngine.GetPosition = debugprofilestop() - startTime

				--debug
				startTime = debugprofilestop()
				o.hp, _, o.absorb = o:CalcHP()
				br.debug.cpu.healingEngine.absorbANDhp = debugprofilestop() - startTime
			else
				-- assign Name of unit
				o.name = o.unit and br._G.UnitName(o.unit) or "None"
				-- assign real GUID of unit and Short GUID of unit for the SetupTable
				o.guid, o.guidsh = o:nGUID()
				-- assign unit role
				o.role = o:GetRole()
				-- subgroup number
				o.subgroup = o:getUnitGroupNumber()
				-- set to true if unit should be dispelled
				--o.dispel = o:Dispel(o.unit)
				-- distance to player
				o.distance = o:getUnitDistance()
				-- Unit's threat situation(1-4)
				o.threat = br._G.UnitThreatSituation(o.unit)
				-- Unit HP absolute
				o.hpabs = UnitHealth(o.unit)
				-- Unit HP missing absolute
				o.hpmissing = UnitHealthMax(o.unit) - UnitHealth(o.unit)
				-- Unit HP and Absorb
				o.hp, _, o.absorb = o:CalcHP()
				-- Target's target
				o.target = tostring(o.unit) .. "target"
				-- Unit Class
				o.class = o:GetClass()
				-- Unit is player
				o.isPlayer = br._G.UnitIsPlayer(o.unit)
				-- precise unit position
				o.x, o.y, o.z = o:GetPosition()
			end
			-- add unit to setup cache
			healingEngine.memberSetup.cache[select(2, br.functions.unit:getGUID(o.unit))] = o -- Add unit to SetupTable
		end
		-- Adding the user and functions we just created to this cached version in case we need it again
		-- This will also serve as a good check for if the unit is already in the table easily
		--Print(UnitName(unit), select(2, br.functions.unit:getGUID(unit)))
		healingEngine.memberSetup.cache[select(2, o:nGUID())] = o
		return o
	end
	-- Setting up the tables on either Wipe or Initial Setup
	function healingEngine:SetupTables()
		-- Creating the cache (we use this to check if some1 is already in the table)
		setmetatable(br.engines.healingEngine.friend, healingEngine) -- Set the metaTable of Main to Meta
		function br.engines.healingEngine.friend:Update()
			-- Print("HEAL PULSE: "..GetTime())		-- debug Print to check update time
			-- This is for special situations, IE world healing or NPC healing in encounters
			local selectedMode, SpecialTargets = br.functions.misc:getOptionValue("Special Heal"), {}
			if br.functions.misc:getOptionCheck("Special Heal") == true then
				if selectedMode == 1 then
					SpecialTargets = {"target"}
				elseif selectedMode == 2 then
					SpecialTargets = {"target", "mouseover"}
				elseif selectedMode == 3 then
					SpecialTargets = {"target", "mouseover", "focus"}
				else
					SpecialTargets = {"target", "focus"}
				end
			end
			for p = 1, #SpecialTargets do
				-- Checking if Unit Exists and it's possible to heal them
				if br.functions.unit:GetUnitExists(SpecialTargets[p]) and healingEngine:HealCheck(SpecialTargets[p]) and not CheckSkipNPC(SpecialTargets[p]) then
					if not healingEngine.memberSetup.cache[select(2, br.functions.unit:getGUID(SpecialTargets[p]))] then
						local SpecialCase = healingEngine.memberSetup:new(SpecialTargets[p])
						if SpecialCase then
							-- Creating a new user, if not already tabled, will return with the User
							for j = 1, #br.engines.healingEngine.friend do
								if br.engines.healingEngine.friend[j].unit == SpecialTargets[p] then
									-- Now we add the Unit we just created to the Main Table
									for k, _ in pairs(healingEngine.memberSetup.cache) do
										if br.engines.healingEngine.friend[j].guidsh == k then
											healingEngine.memberSetup.cache[k] = nil
										end
									end
									tremove(br.engines.healingEngine.friend, j)
									break
								end
							end
						end
						tinsert(br.engines.healingEngine.friend, SpecialCase)
						br.engines.healingEngineCollections.SavedSpecialTargets[SpecialTargets[p]] = select(2, br.functions.unit:getGUID(SpecialTargets[p]))
					end
				end
			end
			for p = 1, #SpecialTargets do
				local removedTarget = false
				for j = 1, #br.engines.healingEngine.friend do
					-- Trying to find a case of the unit inside the Main Table to remove
					if br.engines.healingEngine.friend[j].unit == SpecialTargets[p] and (br.engines.healingEngine.friend[j].guid ~= 0 and br.engines.healingEngine.friend[j].guid ~= br._G.UnitGUID(SpecialTargets[p])) then
						tremove(br.engines.healingEngine.friend, j)
						removedTarget = true
						break
					end
				end
				if removedTarget == true then
					for k, v in pairs(healingEngine.memberSetup.cache) do
						-- Now we're trying to find that unit in the Cache table to remove
						if SpecialTargets[p] == v.unit then
							healingEngine.memberSetup.cache[k] = nil
						end
					end
				end
			end
			for i = 1, #br.engines.healingEngine.friend do
				-- We are updating all of the User Info (Health/Range/Name)
				br.engines.healingEngine.friend[i]:UpdateUnit()
			end
			-- We are sorting by Health first
			table.sort(
				br.engines.healingEngine.friend,
				function(x, y)
					return x.hp < y.hp
				end
			)
			if br.functions.misc:getOptionCheck("Prioritize Special Targets") == true then
				if br.functions.unit:GetUnitExists("focus") and healingEngine.memberSetup.cache[select(2, br.functions.unit:getGUID("focus"))] then
					table.sort(
						br.engines.healingEngine.friend,
						function(x)
							if x.unit == "focus" then
								return true
							else
								return false
							end
						end
					)
				end
				if br.functions.unit:GetUnitExists("target") and healingEngine.memberSetup.cache[select(2, br.functions.unit:getGUID("target"))] then
					table.sort(
						br.engines.healingEngine.friend,
						function(x)
							if x.unit == "target" then
								return true
							else
								return false
							end
						end
					)
				end
				if br.functions.unit:GetUnitExists("mouseover") and healingEngine.memberSetup.cache[select(2, br.functions.unit:getGUID("mouseover"))] then
					table.sort(
						br.engines.healingEngine.friend,
						function(x)
							if x.unit == "mouseover" then
								return true
							else
								return false
							end
						end
					)
				end
			end
			if br.engines.healingEngineFrame.pulseNovaDebugTimer == nil or br.engines.healingEngineFrame.pulseNovaDebugTimer <= GetTime() then
				br.engines.healingEngineFrame.pulseNovaDebugTimer = GetTime() + 0.5
				br.engines.healingEngineFrame:pulseNovaDebug()
			end
			-- update these frames to current br.engines.healingEngine.friend values via a pulse in nova engine
		end
		-- We are creating the initial Main Table
		br.engines.healingEngine.friend()
	end
	-- We are setting up the Tables for the first time
	healingEngine:SetupTables()
end
