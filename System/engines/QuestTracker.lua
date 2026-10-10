local _, br = ...
br.engines.questTracker = br.engines.questTracker or {}
local questTracker = br.engines.questTracker
questTracker.cache = questTracker.cache or {}               -- quest titles/objective names (with variations), used by the tooltip scan
questTracker.objectCheckCache = questTracker.objectCheckCache or {} -- isQuestObject verdict by object name, wiped on rebuild
questTracker.objectives = questTracker.objectives or {}     -- [questId] = { { text = "...lowercase...", name = "...lowercase..." }, ... }
questTracker.objectiveCount = 0
questTracker.completedCount = 0
questTracker.completed = questTracker.completed or {} -- titles of finished quests, so their tooltip lines read as "done"
-- Bitmask of the game object dynamic-flag bit(s) the server sets on objects that are
-- interactable for an active quest. nil until verified on a client (see QuestProbe.lua);
-- when set, and the unlocker exposes ObjectDynamicFlags, it decides isQuestObject outright.
questTracker.dynFlagMask = questTracker.dynFlagMask or nil

local REBUILD_DELAY = 2 -- seconds; quest events arrive in bursts

--Quest stuff
local questTooltipScanQuest = br._G.CreateFrame("GameTooltip", "QuestPlateTooltipScanQuest", nil, "GameTooltipTemplate")
local ScannedQuestTextCache = {}

local ignoreQuest = {
	[56064] = true, -- Assault Black Empire (Vale)
	[57157] = true, -- Assault Black Empire (Uldum)
	[55350] = true, -- Assault Amathet Advance
	[56308] = true, -- Assault Aqir Unearthed
	[57008] = true, -- Assault The Warring Clans
	[57728] = true, -- Assault: The Endless Swarm
}

local ignoreObjects = {
	[327571] = true,
}

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

-- Objects known to be quest objects regardless of what the log says (specific expansions)
local questObjectIDs = {}
for _, id in ipairs({
	325958, 325962, 325963, 325959, 335703, 152692, 163757, 290542, 113768, 113771, 113769, 113770, 153290,
	322413, 326395, 326399, 326418, 326413, 327577, 327576, 327578, 325799,
	326417, 326411, 326412, 326414, 326415, 326416, 326419, 326420, 326403, 326408, 326407, -- nasjatar chests
	325662, 325659, 325660, 325661, 325663, 325664, 325665, 325666, 325667, 325668,
	151166, -- mechagon chests / algan units
}) do questObjectIDs[id] = true end

-- Words objective text appends to a name ("Murlocs slain: 5/10")
local actionWords = {
	"slain", "destroyed", "collected", "gathered", "killed", "used", "defeated", "freed", "rescued",
	"burned", "looted", "found", "retrieved", "recovered", "activated", "opened", "poisoned", "captured",
}

local function trim(text)
	return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

-- Pulls the thing an objective is about out of its text.
--   "Kill Murlocs: 5/10"      -> "kill murlocs"
--   "Mantid slain: 0/200"     -> "mantid"
--   "0/15 Dreadspore Bulbs"   -> "dreadspore bulbs"
--   "Escort the farmer: 40%"  -> "escort the farmer"
local function parseObjectiveName(text)
	local name = text:match("^(.-)%s*:?%s*%d+/%d+") or text:match("^%d+/%d+%s+(.+)$") or text:match("^(.-)%s*:?%s*%d+%%")
	if not name or name == "" then
		name = text:match("^%d+/%d+%s+(.+)$")
	end
	if not name then return nil end
	name = trim(name):gsub(":$", "")
	name = trim(name):lower()
	-- Lua patterns have no alternation, so strip one trailing action word at a time
	local stripped = true
	while stripped do
		stripped = false
		for i = 1, #actionWords do
			local w = actionWords[i]
			if name:sub(-#w - 1) == " " .. w then
				name = trim(name:sub(1, -#w - 2))
				stripped = true
			end
		end
	end
	-- ...and leading verbs ("Kill Murlocs")
	for _, verb in ipairs({ "kill ", "slay ", "defeat ", "collect ", "gather ", "destroy ", "rescue ", "free " }) do
		if name:sub(1, #verb) == verb then
			name = trim(name:sub(#verb + 1))
			break
		end
	end
	if #name < 3 then return nil end
	return name
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
		cache[(name:gsub("Salvaged", "Salvageable"))] = true
	elseif name:match("Salvageable") then
		cache[(name:gsub("Salvageable", "Salvaged"))] = true
	end

	-- "Damaged" <-> "Damageable"
	if name:match("Damaged") then
		cache[(name:gsub("Damaged", "Damageable"))] = true
	elseif name:match("Damageable") then
		cache[(name:gsub("Damageable", "Damaged"))] = true
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

-- Units come in as GUIDs or object pointers, depending on the unlocker
local function getGuid(pointer)
	if type(pointer) == "string" and pointer:find("^%a+%-%d") then return pointer end
	return br._G.UnitGUID(pointer)
end

local function isAliveOrFriend(unit)
	return not br.functions.unit:GetUnitIsDeadOrGhost(unit) or br.functions.unit:GetUnitIsFriend("player", unit)
end

-- Lowercase words separated by single spaces, padded so whole words can be found with " word "
local function paddedWords(text)
	return " " .. text:lower():gsub("[^%w']+", " "):gsub("^ +", ""):gsub(" +$", "") .. " "
end

-- The forms an objective's subject may take in a name: as written, and singular/plural of its
-- last word ("whitepetal reeds" also matches "Whitepetal Reed", "murloc" also "Murlocs")
local function subjectForms(subject)
	local forms = { subject, subject .. "s", subject .. "es" }
	if subject:sub(-2) == "es" then forms[#forms + 1] = subject:sub(1, -3) end
	if subject:sub(-1) == "s" then forms[#forms + 1] = subject:sub(1, -2) end
	return forms
end

-- True when `name` (a unit or object name) is what one of the active objectives is about: the name
-- contains the objective's subject as whole words ("Rabid Thistle Bear" for "Rabid Thistle Bear
-- slain", "School of Darkshore Grouper" for "Darkshore Grouper"). Only the parsed subject counts,
-- not the free text of event/description objectives ("Find a corrupt furbolg camp"), and a name that
-- is only part of the subject doesn't ("Thistle Bear" is not a "Rabid Thistle Bear").
local function matchesObjective(name)
	if #name < 3 then return false end
	local words = paddedWords(name)
	for _, objectives in pairs(questTracker.objectives) do
		for i = 1, #objectives do
			local forms = objectives[i].forms
			if forms then
				for _, form in ipairs(forms) do
					if words:find(" " .. form .. " ", 1, true) then return true end
				end
			end
		end
	end
	return false
end

-- Containers are named for what they hold, not after the quest item itself: "Chest of the
-- Raven Claw" holds the Raven Claw Talisman, "Chest of the Sky" the Sapphire of Sky. Drop
-- the container and filler words from the object's name, then require every word left
-- to appear in one open objective. Done objectives are not in the cache, so a looted
-- chest stops matching.
local containerWords = {
	chest = true, box = true, crate = true, cache = true, coffer = true, strongbox = true,
	footlocker = true, locker = true, trunk = true, sack = true, bag = true, barrel = true,
	urn = true, satchel = true, stash = true, pouch = true, casket = true,
}
local fillerWords = { ["of"] = true, ["the"] = true, ["a"] = true, ["an"] = true }

local function matchesContainer(name)
	local isContainer, words = false, {}
	for word in name:gmatch("[%a']+") do
		if containerWords[word] then
			isContainer = true
		elseif not fillerWords[word] and #word >= 3 then
			words[#words + 1] = word
		end
	end
	if not isContainer or #words == 0 then return false end
	for _, objectives in pairs(questTracker.objectives) do
		for i = 1, #objectives do
			-- Pad with spaces so each word must match whole ("sky" not in "skyline")
			local text = " " .. objectives[i].text:gsub("[^%a']", " ") .. " "
			local all = true
			for _, word in ipairs(words) do
				if not text:find(" " .. word .. " ", 1, true) then
					all = false
					break
				end
			end
			if all then return true end
		end
	end
	return false
end

----------------------------------------------------------------------------------------------------
-- Units
----------------------------------------------------------------------------------------------------

-- Legacy tooltip scan, for clients without C_TooltipInfo (Classic/TBC/MOP)
local function scanTooltipFrame(guid)
	questTooltipScanQuest:SetOwner(br._G["WorldFrame"], 'ANCHOR_NONE')
	questTooltipScanQuest:SetHyperlink('unit:' .. guid)
	local numLines = questTooltipScanQuest:NumLines()
	if numLines == 0 then return false end

	br._G.wipe(ScannedQuestTextCache)
	for i = 1, numLines do
		ScannedQuestTextCache[i] = br._G["QuestPlateTooltipScanQuestTextLeft" .. i]
	end

	for i = 1, numLines do
		local text = ScannedQuestTextCache[i]:GetText()
		if text and questTracker.cache[text] then
			-- Check the following lines for quest progress
			local j = i
			while ScannedQuestTextCache[j + 1] do
				local nextLineText = ScannedQuestTextCache[j + 1]:GetText()
				if nextLineText then
					if nextLineText:match(br._G["THREAT_TOOLTIP"]) then
						break -- saw threat% -> quest text is done
					end
					local p1, p2 = nextLineText:match("(%d+)/(%d+)")
					if not p1 then
						p1 = nextLineText:match("(%d+)%%")
					end
					if (p1 and p2 and p1 ~= p2) or (p1 and not p2 and p1 ~= "100") then
						return true -- unfinished objective
					end
				end
				j = j + 1
			end
		end
	end
	return false
end

-- Structured tooltip: quest title lines followed by objective lines.
-- true  = one of our open quests lists this unit with an unfinished objective
-- false = it only lists finished quests / finished objectives
-- nil   = no quest lines we recognise (or unreadable), so ask something else
local function scanTooltipData(guid)
	local data = br._G.C_TooltipInfo.GetHyperlink("unit:" .. guid)
	if type(data) ~= "table" or type(data.lines) ~= "table" then return nil end
	local lineTypes = br._G.Enum and br._G.Enum.TooltipDataLineType
	if not lineTypes or not lineTypes.QuestTitle or not lineTypes.QuestObjective then return nil end
	local issecret = br._G.issecretvalue
	local inQuest, found, sawCompleted, unfinished = false, false, false, false
	for _, line in ipairs(data.lines) do
		local text = line.leftText
		if text and not (issecret and issecret(text)) then
			if line.type == lineTypes.QuestTitle then
				inQuest = questTracker.cache[text] == true
				if inQuest then
					found = true
				elseif questTracker.completed[text] then
					sawCompleted = true
				end
			elseif inQuest and line.type == lineTypes.QuestObjective then
				local p1, p2 = text:match("(%d+)/(%d+)")
				if not p1 then p1 = text:match("(%d+)%%") end
				if (p1 and p2 and p1 ~= p2) or (p1 and not p2 and p1 ~= "100") or not p1 then
					unfinished = true
				end
			end
		end
	end
	if found then return unfinished end
	if sawCompleted then return false end
	return nil
end

-- Is this unit something the player needs for an active quest?
-- Cheapest and most reliable check first; the caller caches the verdict until the quest log changes.
function questTracker:isQuestUnit(unit)
	if not isAliveOrFriend(unit) then return false end

	local guid = getGuid(unit)
	-- Players and their pets are never quest targets (hunter pets named "Cat" used to match)
	if guid and (guid:find("^Pet%-") or guid:find("^Player%-")) then return false end
	local hasTooltipData = br._G.C_TooltipInfo and br._G.C_TooltipInfo.GetHyperlink

	-- The tooltip names the quest and its progress, so it is the only check that knows a quest is done
	if guid and hasTooltipData then
		local verdict = scanTooltipData(guid)
		if verdict ~= nil then return verdict end
	end

	-- Native: the client's own quest check, which also covers the NPC you turn a finished quest in to.
	-- It can't tell finished quests from open ones, so skip it when there are none of either.
	local questLog = br._G.C_QuestLog
	if (questTracker.objectiveCount > 0 or questTracker.completedCount > 0)
		and questLog and questLog.UnitIsRelatedToActiveQuest and questLog.UnitIsRelatedToActiveQuest(unit)
	then
		return true
	end

	-- These two only know about open objectives
	if questTracker.objectiveCount > 0 then
		if br._G.UnitIsQuestBoss and br._G.UnitIsQuestBoss(unit) then
			return true
		end

		-- Objective text names the unit ("Kill Murlocs")
		local unitName = br._G.UnitName(unit)
		if unitName and matchesObjective(unitName:lower()) then
			return true
		end
	end

	-- Clients without C_TooltipInfo: legacy tooltip frame scan
	if guid and not hasTooltipData then
		return scanTooltipFrame(guid)
	end
	return false
end

----------------------------------------------------------------------------------------------------
-- Game objects
----------------------------------------------------------------------------------------------------

function questTracker:isQuestObject(object)
	local objectID = br._G.ObjectID(object)
	if ignoreObjects[objectID] then return false end

	-- Server flag, when verified for this client
	local mask = questTracker.dynFlagMask
	if mask and br._G.ObjectDynamicFlags then
		local flags = br._G.ObjectDynamicFlags(object)
		if type(flags) == "number" then
			return br._G.bit.band(flags, mask) ~= 0
		end
	end

	if questObjectIDs[objectID] then return true end

	local objectName = br._G.ObjectName(object)
	if not objectName or nonQuestObjects[objectName] then return false end

	-- Name-based cache (avoids repeated lookups for the same object name)
	local cached = questTracker.objectCheckCache[objectName]
	if cached ~= nil then return cached end

	local lowerName = objectName:lower()
	local result = matchesObjective(lowerName) or matchesContainer(lowerName)
	questTracker.objectCheckCache[objectName] = result
	return result
end

----------------------------------------------------------------------------------------------------
-- Quest log cache
----------------------------------------------------------------------------------------------------

local function addObjective(questId, text)
	if not text or text == "" then return end
	local list = questTracker.objectives[questId]
	if not list then
		list = {}
		questTracker.objectives[questId] = list
	end
	local name = parseObjectiveName(text)
	list[#list + 1] = { text = text:lower(), name = name, forms = name and subjectForms(paddedWords(name):sub(2, -2)) }
	questTracker.objectiveCount = questTracker.objectiveCount + 1
	if name then addNameVariations(name, questTracker.cache) end
end

function questTracker:rebuild()
	br._G.wipe(questTracker.cache)
	br._G.wipe(questTracker.objectCheckCache)
	br._G.wipe(questTracker.objectives)
	br._G.wipe(questTracker.completed)
	questTracker.objectiveCount = 0
	questTracker.completedCount = 0

	local tracker = br.engines.tracker
	-- Anything classified against the old log is stale
	if tracker and tracker.invalidate then tracker:invalidate() end

	-- do not update if inside an instance
	if br._G.IsInInstance() then return end

	local questLog = br._G.C_QuestLog
	local numEntries = br._G.GetNumQuestLogEntries()
	for questIdx = 1, numEntries do
		local title, _, _, isHeader, _, isComplete, _, questId = br._G.GetQuestLogTitle(questIdx)
		if not isHeader and type(questId) == "number" and questId > 0 and ignoreQuest[questId] == nil then
			-- Finished quests (ready to turn in) have nothing left to track
			if isComplete == 1 or isComplete == true or (questLog and questLog.IsComplete and questLog.IsComplete(questId)) then
				if title then questTracker.completed[title] = true end
				questTracker.completedCount = questTracker.completedCount + 1
			elseif questLog and questLog.GetQuestObjectives then
				addNameVariations(title, questTracker.cache)
				local objectives = questLog.GetQuestObjectives(questId)
				if type(objectives) == "table" then
					for _, objective in ipairs(objectives) do
						if not objective.finished then addObjective(questId, objective.text) end
					end
				end
			else
				addNameVariations(title, questTracker.cache)
				for objIdx = 1, (br._G.GetNumQuestLeaderBoards(questIdx) or 0) do
					local objectiveText, _, finished = br._G.GetQuestLogLeaderBoard(objIdx, questIdx)
					if objectiveText and not finished then addObjective(questId, objectiveText) end
				end
			end
		end
	end

	-- World quests in the current zone
	local mapId = br._G.C_Map and br._G.C_Map.GetBestMapForUnit("player")
	if mapId and br._G.C_TaskQuest and questLog and questLog.GetQuestObjectives then
		local worldQuests = br._G.C_TaskQuest.GetQuestsForPlayerOnMap and
			br._G.C_TaskQuest.GetQuestsForPlayerOnMap(mapId) or
			br._G.C_TaskQuest.GetQuestsOnMap(mapId)
		if type(worldQuests) == "table" then
			for _, questTable in ipairs(worldQuests) do
				local questId = questTable.questId or questTable.questID
				if type(questId) == "number" and questId > 0 and ignoreQuest[questId] == nil then
					local questName = br._G.C_TaskQuest.GetQuestInfoByQuestID(questId)
					if questName then addNameVariations(questName, questTracker.cache) end
					local objectives = questLog.GetQuestObjectives(questId)
					if type(objectives) == "table" then
						for _, objective in ipairs(objectives) do
							if not objective.finished then addObjective(questId, objective.text) end
						end
					end
				end
			end
		end
	end
end

local function scheduleRebuild()
	local timer = questTracker.rebuildTimer
	if timer and not timer["_cancelled"] then timer:Cancel() end
	questTracker.rebuildTimer = br._G.C_Timer.NewTimer(REBUILD_DELAY, function() questTracker:rebuild() end)
end

-- Debug function to print cache contents
function questTracker:printCache()
	br._G.print("=== Quest Tracker Cache Contents ===")
	for questId, objectives in pairs(questTracker.objectives) do
		for _, o in ipairs(objectives) do
			br._G.print(questId .. ": " .. o.text .. "  ->  " .. tostring(o.name))
		end
	end
	local count = 0
	for _ in pairs(questTracker.cache) do count = count + 1 end
	br._G.print("=== " .. questTracker.objectiveCount .. " objectives, " .. count .. " cached names ===")
end

local f = br._G.CreateFrame("Frame", "QuestFrame", br._G.UIParent)
for _, event in ipairs({
	"QUEST_ACCEPTED", "QUEST_REMOVED", "QUEST_ACCEPT_CONFIRM", "QUEST_COMPLETE", "QUEST_POI_UPDATE",
	"QUEST_DETAIL", "QUEST_FINISHED", "QUEST_GREETING", "QUEST_LOG_UPDATE", "UNIT_QUEST_LOG_CHANGED",
	-- The log may already be loaded before BR is, and leaving an instance doesn't fire a quest event
	"PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA",
}) do
	f:RegisterEvent(event)
end
f:SetScript("OnEvent", scheduleRebuild)

-- BR can load after the quest log events already fired
br._G.C_Timer.After(1, function() questTracker:rebuild() end)
