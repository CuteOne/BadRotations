local _, br = ...
-- local LibDraw = br._G.LibStub("LibDraw-BR")
br.engines.questTracker = br.engines.questTracker or {}
local questTracker = br.engines.questTracker
questTracker.cache = questTracker.cache or {}
questTracker.objectCheckCache = questTracker.objectCheckCache or {} -- Cache for already-checked objects
questTracker.unitResultCache = questTracker.unitResultCache or {} -- Cache for isQuestUnit results by GUID
questTracker.objectResultCache = questTracker.objectResultCache or {} -- Cache for isQuestObject results by GUID
questTracker.questObjectivesCache = questTracker.questObjectivesCache or {} -- Cache parsed quest objectives
questTracker.lastCacheClean = questTracker.lastCacheClean or 0
local CACHE_EXPIRATION_TIME = 5 -- Seconds before cached result expires
local CACHE_CLEAN_INTERVAL = 30 -- Seconds between cache cleanups

--Quest stuff
--local questPlateTooltip = CreateFrame('GameTooltip', 'QuestPlateTooltip', nil, 'GameTooltipTemplate')
local questTooltipScanQuest = br._G.CreateFrame("GameTooltip", "QuestPlateTooltipScanQuest", nil, "GameTooltipTemplate")
local ScannedQuestTextCache = {}

-- Clean expired cache entries to prevent memory bloat
local function cleanExpiredCaches()
	local currentTime = br._G.GetTime()
	local cleanCount = 0

	-- Clean unit result cache
	for guid, data in pairs(questTracker.unitResultCache) do
		if currentTime - data.timestamp > CACHE_EXPIRATION_TIME then
			questTracker.unitResultCache[guid] = nil
			cleanCount = cleanCount + 1
		end
	end

	-- Clean object result cache
	for guid, data in pairs(questTracker.objectResultCache) do
		if currentTime - data.timestamp > CACHE_EXPIRATION_TIME then
			questTracker.objectResultCache[guid] = nil
			cleanCount = cleanCount + 1
		end
	end

	questTracker.lastCacheClean = currentTime
end

-- Helper function to add name variations to cache (called during cache build)
local function addNameVariations(name, cache)
	if not name or #name < 3 then return end

	-- Add the original name
	cache[name] = true

	-- Add plural variation (add 's')
	cache[name .. "s"] = true

	-- Add plural variation (add 'es')
	cache[name .. "es"] = true

	-- If name ends in 's', add singular
	if name:sub(-1) == "s" then
		cache[name:sub(1, -2)] = true
	end

	-- If name ends in 'es', add singular
	if name:sub(-2) == "es" then
		cache[name:sub(1, -3)] = true
	end

	-- Handle common word form variations
	-- "Salvaged" <-> "Salvageable"
	if name:match("Salvaged") then
		cache[name:gsub("Salvaged", "Salvageable")] = true
	elseif name:match("Salvageable") then
		cache[name:gsub("Salvageable", "Salvaged")] = true
	end

	-- "Damaged" <-> "Damageable"
	if name:match("Damaged") then
		cache[name:gsub("Damaged", "Damageable")] = true
	elseif name:match("Damageable") then
		cache[name:gsub("Damageable", "Damaged")] = true
	end

	-- Handle past tense variations (ed/able endings)
	-- This catches more generic cases like "Broken" <-> "Breakable"
	local root = name:match("^(.+)ed%s")
	if root then
		-- Found "ed " pattern (e.g., "Salvaged Metal")
		cache[root .. "able " .. name:match("%s(.+)$")] = true
	end

	root = name:match("^(.+)able%s")
	if root then
		-- Found "able " pattern (e.g., "Salvageable Metal")
		cache[root .. "ed " .. name:match("%s(.+)$")] = true
	end
end

function questTracker:isQuestUnit(Pointer)
	-- Get GUID for caching
	local guid
	if not br._G["lb"] then
		guid = br._G.UnitGUID(Pointer)
	else
		guid = Pointer
	end

	-- Check GUID-based result cache first
	if guid and questTracker.unitResultCache[guid] then
		local cached = questTracker.unitResultCache[guid]
		if br._G.GetTime() - cached.timestamp < CACHE_EXPIRATION_TIME then
			return cached.result
		end
	end

	-- Periodic cache cleanup
	if br._G.GetTime() - questTracker.lastCacheClean > CACHE_CLEAN_INTERVAL then
		cleanExpiredCaches()
	end

	-- First check: Use native API if available (most reliable)
	if br._G.UnitIsQuestBoss then
		local isQuestBoss = br._G.UnitIsQuestBoss(Pointer)
		if isQuestBoss then
			-- Double-check it's not dead (unless friendly, like rescuable NPCs)
			if not br.functions.unit:GetUnitIsDeadOrGhost(Pointer) or br.functions.unit:GetUnitIsFriend("player", Pointer) then
				if guid then
					questTracker.unitResultCache[guid] = {result = true, timestamp = br._G.GetTime()}
				end
				return true
			end
		end
	end

	-- Second check: Name-based matching (similar to object checking)
	-- Check if the unit's name appears in any active quest objective
	local unitName = br._G.UnitName(Pointer)
	if unitName and (not br.functions.unit:GetUnitIsDeadOrGhost(Pointer) or br.functions.unit:GetUnitIsFriend("player", Pointer)) then
		local lowerUnitName = unitName:lower()
		-- Use cached objectives instead of repeated API calls
		for _, objectives in pairs(questTracker.questObjectivesCache) do
			for _, objText in ipairs(objectives) do
				if objText:find(lowerUnitName, 1, true) then
					if guid then
						questTracker.unitResultCache[guid] = {result = true, timestamp = br._G.GetTime()}
					end
					return true
				end
			end
		end
	end

	-- Third check: Tooltip scanning for drop quests (expensive, use sparingly)
	-- Some mobs drop quest items but aren't named in objectives (e.g., "Zan'thik Shackles" dropped by various Zan'thik mobs)
	-- Their tooltips show quest info to indicate they can drop quest items
	-- Only do this check if we haven't found a match yet and GUID exists
	if not guid then
		return false
	end

	-- Perform tooltip scan (expensive operation)
	questTooltipScanQuest:SetOwner(br._G["WorldFrame"], 'ANCHOR_NONE')
	questTooltipScanQuest:SetHyperlink('unit:' .. guid)
	local numLines = questTooltipScanQuest:NumLines()

	-- Early exit if no lines
	if numLines == 0 then
		questTracker.unitResultCache[guid] = {result = false, timestamp = br._G.GetTime()}
		return false
	end

	-- Cache tooltip lines
	for i = 1, numLines do
		ScannedQuestTextCache[i] = br._G["QuestPlateTooltipScanQuestTextLeft" .. i]
	end

	local isQuestUnit = false
	local atLeastOneQuestUnfinished = false
	for i = 1, #ScannedQuestTextCache do
		local text = ScannedQuestTextCache[i]:GetText()
		if text then
			-- Check if tooltip line matches cached quest text
			if br.engines.questTracker.cache[text] then
				isQuestUnit = true
				-- Check the following lines for quest progress
				local j = i
				while ScannedQuestTextCache[j + 1] do
					local nextLineText = ScannedQuestTextCache[j + 1]:GetText()
					if nextLineText then
						if not nextLineText:match(br._G["THREAT_TOOLTIP"]) then
							local p1, p2 = nextLineText:match("(%d+)/(%d+)")
							if not p1 then
								-- Check for % based quests
								p1 = nextLineText:match("(%d+%%)")
								if p1 then
									p1 = string.gsub(p1, "%%", '')
								end
							end
							if (p1 and p2 and not (p1 == p2)) or (p1 and not p2 and not (p1 == "100")) then
								-- Quest not completed
								atLeastOneQuestUnfinished = true
								break -- Early exit once we found unfinished quest
							end
						else
							break -- Break here, saw threat% -> quest text is done
						end
					end
					j = j + 1
				end
				if atLeastOneQuestUnfinished then
					break -- Early exit from outer loop
				end
			end
		end
	end

	local result = isQuestUnit and atLeastOneQuestUnfinished and
		(not br.functions.unit:GetUnitIsDeadOrGhost(Pointer) or br.functions.unit:GetUnitIsFriend("player", Pointer))

	-- Cache the result
	questTracker.unitResultCache[guid] = {result = result, timestamp = br._G.GetTime()}
	return result
end

local QuestCacheUpdate = function()
	local ignoreQuest = {
		[56064] = true, -- Assault Black Empire (Vale)
		[57157] = true, -- Assault Black Empire (Uldum)
		[55350] = true, -- Assault Amathet Advance
		[56308] = true, -- Assault Aqir Unearthed
		[57008] = true, -- Assault The Warring Clans
		[57728] = true, --- Assault: The Endless Swarm
	}
	--clear the quest cache and object check cache
	br._G.wipe(br.engines.questTracker.cache)
	br._G.wipe(br.engines.questTracker.objectCheckCache)
	br._G.wipe(br.engines.questTracker.questObjectivesCache)

	--do not update if is inside an instance
	local isInInstance = br._G.IsInInstance()
	if (isInInstance) then
		return
	end

	--update the quest cache
	local numEntries = br._G.GetNumQuestLogEntries()
	for questIdx = 1, numEntries do
		-- local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questId, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle (questId)
		-- local questInfo = br._G.C_QuestLog.GetInfo(questIdx)
		local title, _, _, _, _, _, _, questId = br._G.GetQuestLogTitle(questIdx)
		-- local title = questInfo["title"]
		-- local questId = questInfo["questID"]
		if (type(questId) == "number" and questId > 0 and ignoreQuest[questId] == nil) then -- and not isComplete
			-- Cache the quest title with variations
			addNameVariations(title, br.engines.questTracker.cache)

			-- Also cache quest objectives (units/objects to kill/collect)
			local numObjectives = br._G.GetNumQuestLeaderBoards(questIdx)
			if numObjectives and numObjectives > 0 then
				local questObjectives = {}
				for objIdx = 1, numObjectives do
					local objectiveText, objectiveType, finished = br._G.GetQuestLogLeaderBoard(objIdx, questIdx)
					if objectiveText and not finished then
						-- Extract the objective name - just get everything before the progress numbers
						-- Examples: "Kill Murlocs: 5/10" -> "Kill Murlocs"
						--           "Dreadspore Bulbs destroyed 0/15" -> "Dreadspore Bulbs"
						--           "Mantid slain: 0/200" -> "Mantid"

						-- Match everything before number/number or number% patterns
						local objectiveName = objectiveText:match("^(.-)%s*%d+/%d+") or objectiveText:match("^(.-)%s*%d+%%")

						if objectiveName then
							-- Clean up any trailing colons, action words, and whitespace
							objectiveName = br._G.strtrim(objectiveName)
							-- Remove trailing colon if present
							objectiveName = objectiveName:gsub(":$", "")
							-- Remove common action words at the end
							objectiveName = objectiveName:gsub("%s+(slain|destroyed|collected|gathered|killed|used)$", "")
							objectiveName = br._G.strtrim(objectiveName)

							-- Cache with variations (handles plural/singular automatically)
							addNameVariations(objectiveName, br.engines.questTracker.cache)

							-- Store in structured objectives cache (lowercase for fast matching)
							table.insert(questObjectives, objectiveText:lower())
						end
					end
				end
				-- Store objectives for this quest
				if #questObjectives > 0 then
					br.engines.questTracker.questObjectivesCache[questId] = questObjectives
				end
			end
		end
	end

	local mapId = br._G.C_Map.GetBestMapForUnit("player")
	if (mapId) then
		-- Try new API first, fallback to old API for compatibility
		local worldQuests = br._G.C_TaskQuest.GetQuestsForPlayerOnMap and
			br._G.C_TaskQuest.GetQuestsForPlayerOnMap(mapId) or
			br._G.C_TaskQuest.GetQuestsOnMap(mapId)
		if (type(worldQuests) == "table") then
			for _, questTable in ipairs(worldQuests) do
				local questId = questTable.questId
				if (type(questId) == "number" and questId > 0 and ignoreQuest[questId] == nil) then
					local questName = br._G.C_TaskQuest.GetQuestInfoByQuestID(questId)
					-- Remove debug print to avoid spam
					-- br._G.print("Quest Name: " .. tostring(questName))
					if (questName) then
						addNameVariations(questName, br.engines.questTracker.cache)
					end

					-- Try to get world quest objectives
					local questInfo = br._G.C_TaskQuest.GetQuestInfoByQuestID(questId)
					if questInfo then
						-- World quests might have objectives we can parse similarly
						local objectives = br._G.C_QuestLog.GetQuestObjectives(questId)
						if objectives then
							for _, objective in ipairs(objectives) do
								if objective.text and not objective.finished then
									local objectiveName = objective.text:match("^(.-):%s*%d") or objective.text:match("^(.-)%s+slain:%s*%d")
									if objectiveName then
										objectiveName = br._G.strtrim(objectiveName)
										br.engines.questTracker.cache[objectiveName] = true
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

local function FunctionQuestLogUpdate() --private
	if (br.engines.questTracker.cacheThrottle and not br.engines.questTracker.cacheThrottle["_cancelled"]) then
		br.engines.questTracker.cacheThrottle:Cancel()
	end
	-- Increased from 2 to 3 seconds to reduce CPU usage during quest spam
	br.engines.questTracker.cacheThrottle = br._G.C_Timer.NewTimer(3, QuestCacheUpdate)
end

-- Debug function to print cache contents
function questTracker:printCache()
	br._G.print("=== Quest Tracker Cache Contents ===")
	local count = 0
	for name, _ in pairs(br.engines.questTracker.cache) do
		count = count + 1
		br._G.print(count .. ". " .. tostring(name))
	end
	br._G.print("=== Total cached items: " .. count .. " ===")
end

function questTracker:isQuestObject(object) --Ty Ssateneth
	local objectID = br._G.ObjectID(object)
	local ignoreObjects = {
		[327571] = true,
	}
	if ignoreObjects[objectID] ~= nil then
		return false
	end

	-- Get object GUID for caching
	-- Object can be either a GUID string or an object pointer
	local guid
	if type(object) == "string" and object:match("^GameObject") then
		guid = object
	end

	-- Check GUID-based result cache first
	if guid and questTracker.objectResultCache[guid] then
		local cached = questTracker.objectResultCache[guid]
		if br._G.GetTime() - cached.timestamp < CACHE_EXPIRATION_TIME then
			return cached.result
		end
	end

	-- Get object name
	local objectName = br._G.ObjectName(object)
	if not objectName then
		if guid then
			questTracker.objectResultCache[guid] = {result = false, timestamp = br._G.GetTime()}
		end
		return false
	end

	-- Exclude common non-quest interactables
	local nonQuestObjects = {
		["Mailbox"] = true,
		["Forge"] = true,
		["Anvil"] = true,
		["Cooking Fire"] = true,
		["Campfire"] = true,
		["Portal"] = true,
		["Meeting Stone"] = true,
		["Summoning Stone"] = true,
		["Bank"] = true,
		["Auction House"] = true,
		["Auctioneer"] = true,
	}

	if nonQuestObjects[objectName] then
		if guid then
			questTracker.objectResultCache[guid] = {result = false, timestamp = br._G.GetTime()}
		end
		return false
	end

	-- Check name-based cache first (avoids repeated lookups for same object name)
	if br.engines.questTracker.objectCheckCache[objectName] ~= nil then
		local result = br.engines.questTracker.objectCheckCache[objectName]
		if guid then
			questTracker.objectResultCache[guid] = {result = result, timestamp = br._G.GetTime()}
		end
		return result
	end

	-- Check hardcoded quest object IDs (specific expansions)
	if objectID == 325958 or objectID == 325962 or objectID == 325963 or objectID == 325959 or objectID == 335703 or
		objectID == 152692 or objectID == 163757 or objectID == 290542 or objectID == 113768 or objectID == 113771 or
		objectID == 113769 or objectID == 113770 or objectID == 153290 or
		objectID == 322413 or objectID == 326395 or objectID == 326399 or objectID == 326418 or objectID == 326413 or
		objectID == 327577 or objectID == 327576 or objectID == 327578 or objectID == 325799 or
		objectID == 326417 or objectID == 326411 or objectID == 326412 or objectID == 326413 or objectID == 326414 or
		objectID == 326415 or objectID == 326416 or objectID == 326417 or objectID == 326418 or objectID == 326419 or
		objectID == 326420 or objectID == 326403 or objectID == 326408 or objectID == 326407 or -- nasjatar chests
		objectID == 325662 or objectID == 325659 or objectID == 325660 or objectID == 325661 or objectID == 325663 or
		objectID == 325664 or objectID == 325665 or objectID == 325666 or objectID == 325667 or objectID == 325668 or
		-- mechagon chests
		objectID == 151166 -- algan units
	then
		br.engines.questTracker.objectCheckCache[objectName] = true
		if guid then
			questTracker.objectResultCache[guid] = {result = true, timestamp = br._G.GetTime()}
		end
		return true
	end

	-- Main check: See if any quest objective text contains this object's name (or vice versa)
	-- Check both directions to handle cases like "Whitepetal Reed" (quest) vs "Whitepetal Reeds" (object)
	local lowerObjectName = objectName:lower()

	-- Use cached objectives instead of repeated API calls
	for _, objectives in pairs(questTracker.questObjectivesCache) do
		for _, objText in ipairs(objectives) do
			-- objText is already lowercase from cache building
			-- Check if either string contains the other (handles singular/plural automatically)
			if objText:find(lowerObjectName, 1, true) or lowerObjectName:find(objText, 1, true) then
				br.engines.questTracker.objectCheckCache[objectName] = true
				if guid then
					questTracker.objectResultCache[guid] = {result = true, timestamp = br._G.GetTime()}
				end
				return true
			end
		end
	end

	-- Cache the negative result (object exists but isn't a quest object)
	br.engines.questTracker.objectCheckCache[objectName] = false
	if guid then
		questTracker.objectResultCache[guid] = {result = false, timestamp = br._G.GetTime()}
	end
	return false
end

local eventFunctions = {
	QUEST_REMOVED = function()
		FunctionQuestLogUpdate()
	end,
	QUEST_ACCEPTED = function()
		FunctionQuestLogUpdate()
	end,
	QUEST_ACCEPT_CONFIRM = function()
		FunctionQuestLogUpdate()
	end,
	QUEST_COMPLETE = function()
		FunctionQuestLogUpdate()
	end,
	QUEST_POI_UPDATE = function()
		FunctionQuestLogUpdate()
	end,
	QUEST_QUERY_COMPLETE = function()
		FunctionQuestLogUpdate()
	end,
	QUEST_DETAIL = function()
		FunctionQuestLogUpdate()
	end,
	QUEST_FINISHED = function()
		FunctionQuestLogUpdate()
	end,
	QUEST_GREETING = function()
		FunctionQuestLogUpdate()
	end,
	QUEST_LOG_UPDATE = function()
		FunctionQuestLogUpdate()
	end,
	UNIT_QUEST_LOG_CHANGED = function()
		FunctionQuestLogUpdate()
	end,
}

local function QuestEventHandler(_, event, ...)
	if br._G.GetObjectWithGUID then
		local func = eventFunctions[event]
		if (func) then
			---@diagnostic disable-next-line: redundant-parameter
			func(event, ...)
		else
			br._G.print("no registered function for event " .. (event or "unknown event"))
		end
	end
end

local f = br._G.CreateFrame("Frame", "QuestFrame", br._G.UIParent)
f:RegisterEvent("QUEST_ACCEPTED")
f:RegisterEvent("QUEST_REMOVED")
f:RegisterEvent("QUEST_ACCEPT_CONFIRM")
f:RegisterEvent("QUEST_COMPLETE")
f:RegisterEvent("QUEST_POI_UPDATE")
f:RegisterEvent("QUEST_DETAIL")
f:RegisterEvent("QUEST_FINISHED")
f:RegisterEvent("QUEST_GREETING")
f:RegisterEvent("QUEST_LOG_UPDATE")
f:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
f:SetScript("OnEvent", QuestEventHandler)
