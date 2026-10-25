local _, br = ...
br.engines.healingEngine = br.engines.healingEngine or {} -- This will be the MetaTable attached to our Main Table that the world will see
local healingEngine = br.engines.healingEngine

--[[---------------------------------------------------------------------------------------------------



-----------------------------------------Bubba's Healing Engine--------------------------------------]]
-- local LGIST = br.game.LibStub("LibGroupInSpecT-1.1")
if not healingEngine.metaTable1 then
	-- localizing the commonly used functions while inside loops
	local tinsert, tremove, UnitClass = br.game.tinsert, br.game.tremove, br.game.UnitClass
	-- These two are methods: stored as plain locals and called without self, every argument
	-- shifted by one (getDistance(unit) always measured 0, GetUnitIsUnit("player", unit) was always false)
	local function getDistance(...) return br.functions.range:getDistance(...) end
	local function GetUnitIsUnit(...) return br.functions.unit:GetUnitIsUnit(...) end
	local UnitHealth, UnitHealthMax = br.game.UnitHealth, br.game.UnitHealthMax
	local GetTime = br.game.GetTime
	local function UnitDebuffID(unit, spellID) return br.functions.aura:UnitDebuffID(unit, spellID) end
	br.engines.healingEngine.friend = {} -- This is our main Table that the world will see
	healingEngine.memberSetup = {} -- This is one of our MetaTables that will be the default user/contructor
	healingEngine.memberSetup.cache = {} -- This is for the cache Table to check against
	healingEngine.__call = function(_) -- (_, forceRetable, excludePets, onlyInRange) [Not Implemented]
		local group = br.game.IsInRaid() and "raid" or "party" -- Determining if the UnitID will be raid or party based
		local groupSize = br.game.IsInRaid() and br.game.GetNumGroupMembers() or br.game.GetNumGroupMembers() - 1 -- If in raid, we check the entire raid. If in party, we remove one from max to account for the player.
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
	local updateHealingTable = br.game.CreateFrame("frame", nil)
	updateHealingTable:RegisterEvent("GROUP_ROSTER_UPDATE")
	updateHealingTable:SetScript(
		"OnEvent",
		function()
			-- Track group size changes for buff stability
			healingEngine.lastGroupSize = healingEngine.currentGroupSize or 0
			healingEngine.currentGroupSize = #br.engines.healingEngine.friend
			healingEngine.groupSizeChangeTime = br.game.GetTime()

			_G.table.wipe(br.engines.healingEngine.friend)
			_G.table.wipe(healingEngine.memberSetup.cache)
			healingEngine:SetupTables()
		end
	)

	-- Helper function to check if group composition is stable (for buff logic)
	-- Returns true if group size hasn't changed in the last 3 seconds
	function healingEngine:isGroupStable(seconds)
		seconds = seconds or 3 -- Default to 3 seconds
		if not healingEngine.groupSizeChangeTime then
			return true -- No changes recorded yet, assume stable
		end
		return (br.game.GetTime() - healingEngine.groupSizeChangeTime) >= seconds
	end
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
		-- Debuff records have the same shape on every client; stop at the first empty slot
		local badDebuffs = br.engines.healingEngineCollections.BadDebuffList
		for i = 1, 40 do
			local auraInfo = br.game.C_UnitAuras.GetDebuffDataByIndex(tar, i, "HARMFUL")
			if not auraInfo then break end
			if badDebuffs[auraInfo.spellId] ~= nil then
				return false
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
	-- Verifying the target is a Valid Healing target
	function healingEngine:HealCheck(tar)
		if
			(br.functions.unit:GetUnitIsVisible(tar) and br.functions.unit:GetUnitReaction("player", tar) > 4 and not br.functions.unit:GetUnitIsDeadOrGhost(tar) and br.functions.misc:getLineOfSight("player", tar) and br.functions.unit:getCreatureType(tar) and
				br.game.UnitPhaseReason(tar) == nil) and
				((br.functions.misc:isPlayer(tar) and br.game.UnitIsConnected(tar) and CheckBadDebuff(tar) and not br.game.UnitIsCharmed(tar) and not br.game.UnitIsOtherPlayersPet(tar)) or
					((GetUnitIsUnit(tar,"pet") or br.game.UnitIsOtherPlayersPet(tar)) and br.functions.misc:getOptionCheck("Heal Pets")) or
					br.engines.healingEngineCollections.SpecialHealUnitList[tonumber(select(2, br.functions.unit:getGUID(tar)))] ~= nil)
		 then
			return true
		else
			return false
		end
	end
	function healingEngine.memberSetup:new(unit)
		-- Seeing if we have already cached this unit before
		if healingEngine.memberSetup.cache[select(2, br.functions.unit:getGUID(unit))] then -- keyed by short GUID
			return false
		end
		local o = {}
		setmetatable(o, healingEngine.memberSetup)
		if unit and type(unit) == "string" then
			o.unit = unit
		end
		-- We are checking the HP of the person through their own function.
		function o:CalcHP()
			-- Bandaid fix?
			if o.unit == nil then return 0, 0, 0 end
			-- Raid mechanics where this member shouldn't be healed (HealingEngineCollections.doNotHeal)
			local doNotHeal = br.engines.healingEngineCollections.doNotHeal
			local aura = br.functions.aura
			for i = 1, 40 do
				local buff = br.game.C_UnitAuras.GetBuffDataByIndex(o.unit, i, "HELPFUL")
				if not buff then break end
				if doNotHeal.buffs[buff.spellId] then return 250, 250, 250 end
			end
			if br.functions.misc:isChecked("Necrotic Rot") then
				local necroRot = br.functions.misc:getOptionValue("Necrotic Rot")
				if necroRot == 0 or necroRot == nil then necroRot = 40 end
				local stacks = aura:getDebuffStacks(o.unit, doNotHeal.necroticRot)
				if stacks > 0 and stacks >= necroRot then return 250, 250, 250 end
			end
			local encounter = br.readers.common.encounterID
			if br.functions.misc:isChecked("Toxic Brand") and encounter and encounter == doNotHeal.toxicBrand.encounter then
				local toxicBrand = br.functions.misc:getOptionValue("Toxic Brand")
				if toxicBrand == 0 or toxicBrand == nil then toxicBrand = 10 end
				local stacks = aura:getDebuffStacks(o.unit, doNotHeal.toxicBrand.debuff)
				if stacks > 0 and stacks >= toxicBrand then return 250, 250, 250 end
			end
			local darkness = doNotHeal.darkness
			if select(9, br.game.GetInstanceInfo()) == darkness.instance and UnitDebuffID("player", darkness.debuff)
				and not UnitDebuffID("player", darkness.unlessDebuff)
			then
				return 250, 250, 250
			end
			local decaying = doNotHeal.decayingStrike
			if encounter == decaying.encounter then
				local time_remain = br.functions.DBM:getPulltimer(nil, decaying.spell)
				if time_remain < br.functions.misc:getOptionValue("Decaying Strike Timer") then
					for i = 1, br.game.GetObjectCount() do
						local thisUnit = br.game.GetObjectWithIndex(i)
						if br.functions.unit:GetObjectID(thisUnit) == decaying.caster and br.game.UnitTarget(thisUnit) ~= nil and br.game.UnitIsUnit(br.game.UnitTarget(thisUnit), o.unit) then
							return 250, 250, 250
						end
					end
				end
			end
			local matchDebuff = encounter and doNotHeal.matchPlayerDebuff[encounter]
			if matchDebuff and (UnitDebuffID(o.unit, matchDebuff) ~= nil) ~= (UnitDebuffID("player", matchDebuff) ~= nil) then
				return 250, 250, 250
			end
			-- Place out of range players at the end of the list -- replaced range to 40 as we should be using lib range
			if not br.game.UnitInRange(o.unit) and getDistance(o.unit) > 40 and not GetUnitIsUnit("player", o.unit) then
				return 250, 250, 250
			end
			-- Place Dead players at the end of the list
			if o.hcRefresh == nil or o.hcRefresh < GetTime() - 1 then
				local startTime = br.game.debugprofilestop()
				if healingEngine:HealCheck(o.unit) ~= true or UnitHealth(o.unit) == 0 then
					return 250, 250, 250
				end
				br.debug.cpu.healingEngine.HealCheck = br.game.debugprofilestop() - startTime
				o.hcRefresh = GetTime()
			end
			-- incoming heals
			local incomingheals
			if br.functions.misc:getOptionCheck("Incoming Heals") == true and br.game.UnitGetIncomingHeals(o.unit, "player") ~= nil then
				incomingheals = br.game.UnitGetIncomingHeals(o.unit, "player")
			else
				incomingheals = 0
			end
			-- absorbs
			local nAbsorbs
			if br.functions.misc:getOptionCheck("Ignore Absorbs") ~= true then
				nAbsorbs = (br.game.UnitGetTotalAbsorbs(o.unit) * 0.25)
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
				if br.lists.unitRules.provingGrounds[br.functions.unit:GetObjectID(o.unit)] == "TANK" then
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
			local hpDebuffs = br.engines.healingEngineCollections.SpecificHPDebuffs
			for i = 1, 40 do
				local auraInfo = br.game.C_UnitAuras.GetDebuffDataByIndex(o.unit, i, "HARMFUL")
				if not auraInfo then break end
				local debuffID = hpDebuffs[auraInfo.spellId]
				if debuffID ~= nil then
					local count = auraInfo.applications
					for j = 1, #debuffID do
						local debuffData = debuffID[j]
						if debuffData ~= nil and (debuffData.stacks == nil or (count and count >= debuffData.stacks)) then
							PercentWithIncoming = PercentWithIncoming - debuffData.value
							break
						end
					end
				end
			end
			local elapsedDebugTime = GetTime() - debugTimerStartTime
			if elapsedDebugTime > 0.5 then
				br.log:warning("Debuff scan took a long time: " .. elapsedDebugTime .. " seconds")
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
				targetGUID = br.game.UnitGUID(unit)
				nShortHand = br.game.UnitGUID(unit):sub(-5)
			end
			return targetGUID, nShortHand
		end
		-- Returns unit class
		function o:GetClass()
			if br.game.UnitGroupRolesAssigned(o.unit) == "NONE" then
				if GetUnitIsUnit("player", o.unit) then
					return UnitClass("player")
				end
				if br.engines.healingEngineCollections.roleTable[br.game.UnitName(o.unit)] ~= nil then
					return br.engines.healingEngineCollections.roleTable[br.game.UnitName(o.unit)].class
				end
			else
				return UnitClass(o.unit)
			end
		end
		-- return unit role
		function o:GetRole()
			if br.game.UnitGroupRolesAssigned(o.unit) == "NONE" then
				-- if we already have a role defined we dont scan
				if br.engines.healingEngineCollections.roleTable[br.game.UnitName(o.unit)] ~= nil then
					return br.engines.healingEngineCollections.roleTable[br.game.UnitName(o.unit)].role
				else
---@diagnostic disable-next-line: undefined-field
					-- local info = LGIST:GetCachedInfo(br.functions.unit:getGUID(o.unit))
					-- if info and info.spec_role then
					-- 	return info.spec_role
					-- end
					return ""
				end
			else
				return br.game.UnitGroupRolesAssigned(o.unit)
			end
		end
		-- Position of the member, or 0, 0, 0 when out of sight. Line of sight is a trace, so it's
		-- rechecked on its own timer (0.5 s in combat, 1 s out); the position is read every update.
		function o:GetPosition()
			local now = GetTime()
			if o.losAt == nil or now > o.losAt + (br.game.UnitAffectingCombat("player") and 0.5 or 1.0) then
				o.los = br.functions.misc:getLineOfSight("player", o.unit)
				o.losAt = now
			end
			if br.functions.unit:GetUnitIsVisible(o.unit) and o.los then
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
			if br.game.IsInRaid() and br.game.UnitInRaid(o.unit) ~= nil then
				return select(3, br.game.GetRaidRosterInfo(br.game.UnitInRaid(o.unit)))
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
			local startTime = br.game.debugprofilestop()
			local now = GetTime()
			-- Facts that rarely change (name, GUID, role, group, class, player or not): once a second
			if o.factsAt == nil or now - o.factsAt >= 1 or o.guidsh == "" then
				o.factsAt = now
				o.name = o.unit and br.game.UnitName(o.unit) or "None"
				o.guid, o.guidsh = o:nGUID()
				o.role = o:GetRole()
				o.subgroup = o:getUnitGroupNumber()
				o.class = o:GetClass()
				o.isPlayer = br.game.UnitIsPlayer(o.unit)
				o.target = tostring(o.unit) .. "target"
			end
			-- distance to player
			o.distance = o:getUnitDistance()
			-- Unit's threat situation(1-4)
			o.threat = br.game.UnitThreatSituation(o.unit)
			-- Unit HP absolute and missing
			o.hpabs = UnitHealth(o.unit)
			o.hpmissing = UnitHealthMax(o.unit) - o.hpabs
			-- Unit HP and Absorb
			o.hp, _, o.absorb = o:CalcHP()
			-- precise unit position
			o.x, o.y, o.z = o:GetPosition()
			-- add unit to setup cache
			if o.guidsh ~= "" then healingEngine.memberSetup.cache[o.guidsh] = o end
			br.debug.cpu:updateDebug(startTime, "healingEngine.updateUnit")
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
					if br.engines.healingEngine.friend[j].unit == SpecialTargets[p] and (br.engines.healingEngine.friend[j].guid ~= 0 and br.engines.healingEngine.friend[j].guid ~= br.game.UnitGUID(SpecialTargets[p])) then
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
				-- Focus, then target, then mouseover each move to the front, so the order ends up
				-- mouseover, target, focus, then everyone else by health
				local friends = br.engines.healingEngine.friend
				for _, special in ipairs({ "focus", "target", "mouseover" }) do
					if br.functions.unit:GetUnitExists(special) and healingEngine.memberSetup.cache[select(2, br.functions.unit:getGUID(special))] then
						for j = 1, #friends do
							if friends[j].unit == special then
								tinsert(friends, 1, tremove(friends, j))
								break
							end
						end
					end
				end
			end
		end
		-- We are creating the initial Main Table
		br.engines.healingEngine.friend()
	end
	-- We are setting up the Tables for the first time
	healingEngine:SetupTables()
end

-- Before the profile runs, so heal decisions see this tick's group health
br.lifecycle:onTick(20, "healing engine", function()
	if br.functions.misc:isChecked("HE Active") then healingEngine.friend:Update() end
end)
