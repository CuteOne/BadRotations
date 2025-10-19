local _, br = ...
-- local LibDraw = br._G.LibStub("LibDraw-BR")
br.engines.questTracker = br.engines.questTracker or {}
local questTracker = br.engines.questTracker
questTracker.cache = questTracker.cache or {}
questTracker.objectCheckCache = questTracker.objectCheckCache or {} -- Cache for already-checked objects

--Quest stuff
--local questPlateTooltip = CreateFrame('GameTooltip', 'QuestPlateTooltip', nil, 'GameTooltipTemplate')
local questTooltipScanQuest = br._G.CreateFrame("GameTooltip", "QuestPlateTooltipScanQuest", nil, "GameTooltipTemplate")
local ScannedQuestTextCache = {}

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
	-- First check: Use native API if available (most reliable)
	if br._G.UnitIsQuestBoss then
		local isQuestBoss = br._G.UnitIsQuestBoss(Pointer)
		if isQuestBoss then
			-- Double-check it's not dead (unless friendly, like rescuable NPCs)
			if not br.functions.unit:GetUnitIsDeadOrGhost(Pointer) or br.functions.unit:GetUnitIsFriend("player", Pointer) then
				return true
			end
		end
	end

	-- Second check: Name-based matching (similar to object checking)
	-- Check if the unit's name appears in any active quest objective
	local unitName = br._G.UnitName(Pointer)
	if unitName and (not br.functions.unit:GetUnitIsDeadOrGhost(Pointer) or br.functions.unit:GetUnitIsFriend("player", Pointer)) then
		local numEntries = br._G.GetNumQuestLogEntries()
		for questIdx = 1, numEntries do
			local numObjectives = br._G.GetNumQuestLeaderBoards(questIdx)
			if numObjectives and numObjectives > 0 then
				for objIdx = 1, numObjectives do
					local objectiveText, objectiveType, finished = br._G.GetQuestLogLeaderBoard(objIdx, questIdx)
					if objectiveText and not finished then
						-- Check if the objective text contains the unit name (case-insensitive)
						-- This handles "Zan'thik Impaler" matching "Zan'thik Impaler slain: 0/6"
						if objectiveText:lower():find(unitName:lower(), 1, true) then
							return true
						end
					end
				end
			end
		end
	end

	-- Third check: Tooltip scanning for drop quests
	-- Some mobs drop quest items but aren't named in objectives (e.g., "Zan'thik Shackles" dropped by various Zan'thik mobs)
	-- Their tooltips show quest info to indicate they can drop quest items
	local guid
	if not br._G["lb"] then
		guid = br._G.UnitGUID(Pointer)
	else
		guid = Pointer
	end

	if guid then
		questTooltipScanQuest:SetOwner(br._G["WorldFrame"], 'ANCHOR_NONE')
		questTooltipScanQuest:SetHyperlink('unit:' .. guid)
		for i = 1, questTooltipScanQuest:NumLines() do
			ScannedQuestTextCache[i] = br._G["QuestPlateTooltipScanQuestTextLeft" .. i]
		end
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
							end
						else
							j = 99 -- Break here, saw threat% -> quest text is done
						end
					end
					j = j + 1
				end
			end
		end
	end

	if isQuestUnit and atLeastOneQuestUnfinished and
		(not br.functions.unit:GetUnitIsDeadOrGhost(Pointer) or br.functions.unit:GetUnitIsFriend("player", Pointer)) then
		return true
	else
		return false
	end
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
		local title, _, _, _, _, _, _, questId = _G["GetQuestLogTitle"](questIdx)
		-- local title = questInfo["title"]
		-- local questId = questInfo["questID"]
		if (type(questId) == "number" and questId > 0 and ignoreQuest[questId] == nil) then -- and not isComplete
			-- Cache the quest title with variations
			addNameVariations(title, br.engines.questTracker.cache)

			-- Also cache quest objectives (units/objects to kill/collect)
			local numObjectives = br._G.GetNumQuestLeaderBoards(questIdx)
			if numObjectives and numObjectives > 0 then
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
						end
					end
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
	br.engines.questTracker.cacheThrottle = br._G.C_Timer.NewTimer(2, QuestCacheUpdate)
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

	-- Get object name
	local objectName = br._G.ObjectName(object)
	if not objectName then
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
		return false
	end

	-- Check result cache first (avoids repeated lookups)
	if br.engines.questTracker.objectCheckCache[objectName] ~= nil then
		return br.engines.questTracker.objectCheckCache[objectName]
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
		return true
	end

	-- Main check: See if any quest objective text contains this object's name (or vice versa)
	-- Check both directions to handle cases like "Whitepetal Reed" (quest) vs "Whitepetal Reeds" (object)
	local numEntries = br._G.GetNumQuestLogEntries()
	for questIdx = 1, numEntries do
		local numObjectives = br._G.GetNumQuestLeaderBoards(questIdx)
		if numObjectives and numObjectives > 0 then
			for objIdx = 1, numObjectives do
				local objectiveText, objectiveType, finished = br._G.GetQuestLogLeaderBoard(objIdx, questIdx)
				if objectiveText and not finished then
					-- Extract just the target name from objective text (before the progress numbers)
					local targetName = objectiveText:match("^(.-)%s*:?%s*%d+/%d+") or
					                   objectiveText:match("^(.-)%s*:?%s*%d+%%") or
					                   objectiveText

					if targetName then
						targetName = br._G.strtrim(targetName)
						-- Remove common action words
						targetName = targetName:gsub("%s+(slain|destroyed|collected|gathered|killed|used)$", "")
						targetName = br._G.strtrim(targetName)

						local lowerTargetName = targetName:lower()
						local lowerObjectName = objectName:lower()

						-- Check if either string contains the other (handles singular/plural automatically)
						if lowerTargetName:find(lowerObjectName, 1, true) or lowerObjectName:find(lowerTargetName, 1, true) then
							br.engines.questTracker.objectCheckCache[objectName] = true
							return true
						end
					end
				end
			end
		end
	end

	-- Cache the negative result (object exists but isn't a quest object)
	br.engines.questTracker.objectCheckCache[objectName] = false
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
