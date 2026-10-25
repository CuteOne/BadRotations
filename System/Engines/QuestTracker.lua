local _, br = ...
br.engines.questTracker = br.engines.questTracker or {}
local questTracker = br.engines.questTracker
questTracker.cache = questTracker.cache or {}               -- quest titles/objective names (with variations), used by the tooltip scan
questTracker.objectCheckCache = questTracker.objectCheckCache or {} -- isQuestObject verdict by object name, wiped on rebuild
questTracker.objectives = questTracker.objectives or {}     -- [questId] = { { text = "...lowercase...", name = "...lowercase..." }, ... }
questTracker.objectiveCount = 0
questTracker.completedCount = 0
questTracker.completed = questTracker.completed or {} -- titles of finished quests, so their tooltip lines read as "done"

local REBUILD_DELAY = 2 -- seconds; quest events arrive in bursts

--Quest stuff
local questTooltipScanQuest = br.game.CreateFrame("GameTooltip", "QuestPlateTooltipScanQuest", nil, "GameTooltipTemplate")
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
	return br.game.UnitGUID(pointer)
end

local function isAliveOrFriend(unit)
	return not br.functions.unit:GetUnitIsDeadOrGhost(unit) or br.functions.unit:GetUnitIsFriend("player", unit)
end

-- Lowercase words separated by single spaces, padded so whole words can be found with " word "
local function paddedWords(text)
	return " " .. text:lower():gsub("[^%w']+", " "):gsub("^ +", ""):gsub(" +$", "") .. " "
end

local function splitWords(text)
	local words = {}
	for w in text:gmatch("[%w']+") do
		words[#words + 1] = w
	end
	return words
end

-- What a word may be without a plural ending: without "es" and without "s" ("boxes" -> "box",
-- "boxe"; "snakes" -> "snak", "snake"; "reeds" -> "reed"). Either may be nil.
local function singularForms(word)
	local withoutEs = word:sub(-2) == "es" and #word > 3 and word:sub(1, -3) or nil
	local withoutS = word:sub(-1) == "s" and #word > 2 and word:sub(1, -2) or nil
	return withoutEs, withoutS
end

-- The same word once plural endings are allowed for ("snake" / "snakes", "box" / "boxes")
local function sameWordOrPlural(a, b)
	if a == b then return true end
	local aEs, aS = singularForms(a)
	if aEs == b or aS == b then return true end
	local bEs, bS = singularForms(b)
	return bEs == a or bS == a
end

-- Same word, singular/plural of it, or (allowFuzzy) a word from the same stem: both at least 5
-- letters and sharing all but the last 2 letters of the shorter one ("fungus" / "fungal", but not
-- "grouper" / "groundling")
local function wordsRelated(a, b, allowFuzzy)
	if sameWordOrPlural(a, b) then return true end
	if not allowFuzzy or #a < 5 or #b < 5 then return false end
	local need = math.min(#a, #b) - 2
	return a:sub(1, need) == b:sub(1, need)
end

-- True when every word of an objective's subject (or a word from the same stem) is in the name, in
-- any order. Stems only count for subjects of two or more words, so one loose word can't match
-- broadly ("lunar fungus" matches "Lunar Fungal Bloom").
local function subjectWordsInName(subjectWords, name)
	local nameWords = splitWords(name)
	if #subjectWords == 0 or #nameWords == 0 then return false end
	local allowFuzzy = #subjectWords >= 2
	for i = 1, #subjectWords do
		local matched = false
		for j = 1, #nameWords do
			if wordsRelated(subjectWords[i], nameWords[j], allowFuzzy) then
				matched = true
				break
			end
		end
		if not matched then return false end
	end
	return true
end

-- The forms an objective's subject may take in a name: as written, and singular/plural of its
-- last word ("whitepetal reeds" also matches "Whitepetal Reed", "murloc" also "Murlocs")
local function subjectForms(subject)
	local forms = { subject, subject .. "s", subject .. "es" }
	local withoutEs, withoutS = singularForms(subject)
	forms[#forms + 1] = withoutEs
	forms[#forms + 1] = withoutS
	return forms
end

-- True when `name` (a unit or object name) is what one of the active objectives is about: the name
-- contains the objective's subject as whole words ("Rabid Thistle Bear" for "Rabid Thistle Bear
-- slain", "School of Darkshore Grouper" for "Darkshore Grouper"). Only the parsed subject counts,
-- not the free text of event/description objectives ("Find a corrupt furbolg camp"), and a name that
-- is only part of the subject doesn't ("Thistle Bear" is not a "Rabid Thistle Bear"). Failing that,
-- the subject's words may appear in any order or as a word from the same stem ("Lunar Fungal Bloom"
-- for "Lunar Fungus"; see subjectWordsInName).
-- Objectives about creatures or players ("Murkdeep slain") can't be about a game object
local creatureObjective = { monster = true, player = true }

-- forObject: the name is a game object's, so creature objectives don't count (a "WANTED: Murkdeep"
-- board is not Murkdeep)
local function matchesObjective(name, forObject)
	if #name < 3 then return false end
	local words = paddedWords(name)
	for _, objectives in pairs(questTracker.objectives) do
		for i = 1, #objectives do
			if not (forObject and creatureObjective[objectives[i].kind]) then
				local forms = objectives[i].forms
				if forms then
					for _, form in ipairs(forms) do
						if words:find(" " .. form .. " ", 1, true) then return true end
					end
				end
				local subjectWords = objectives[i].words
				if subjectWords and subjectWordsInName(subjectWords, name) then return true end
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
			if not creatureObjective[objectives[i].kind] then
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
	end
	return false
end

----------------------------------------------------------------------------------------------------
-- Units
----------------------------------------------------------------------------------------------------

-- Legacy tooltip scan, for clients without C_TooltipInfo (Classic/TBC/MOP)
local function scanTooltipFrame(guid)
	questTooltipScanQuest:SetOwner(br.game["WorldFrame"], 'ANCHOR_NONE')
	questTooltipScanQuest:SetHyperlink('unit:' .. guid)
	local numLines = questTooltipScanQuest:NumLines()
	if numLines == 0 then return false end

	br.game.wipe(ScannedQuestTextCache)
	for i = 1, numLines do
		ScannedQuestTextCache[i] = br.game["QuestPlateTooltipScanQuestTextLeft" .. i]
	end

	for i = 1, numLines do
		local text = ScannedQuestTextCache[i]:GetText()
		if text and questTracker.cache[text] then
			-- Check the following lines for quest progress
			local j = i
			while ScannedQuestTextCache[j + 1] do
				local nextLineText = ScannedQuestTextCache[j + 1]:GetText()
				if nextLineText then
					if nextLineText:match(br.game["THREAT_TOOLTIP"]) then
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
	local data = br.game.C_TooltipInfo.GetHyperlink("unit:" .. guid)
	if type(data) ~= "table" or type(data.lines) ~= "table" then return nil end
	local lineTypes = br.game.Enum and br.game.Enum.TooltipDataLineType
	if not lineTypes or not lineTypes.QuestTitle or not lineTypes.QuestObjective then return nil end
	local issecret = br.game.issecretvalue
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
	local hasTooltipData = br.game.C_TooltipInfo and br.game.C_TooltipInfo.GetHyperlink

	-- The tooltip names the quest and its progress, so it is the only check that knows a quest is done
	if guid and hasTooltipData then
		local verdict = scanTooltipData(guid)
		if verdict ~= nil then return verdict end
	end

	-- Native: the client's own quest check, which also covers the NPC you turn a finished quest in to.
	-- It can't tell finished quests from open ones, so skip it when there are none of either.
	local questLog = br.game.C_QuestLog
	if (questTracker.objectiveCount > 0 or questTracker.completedCount > 0)
		and questLog and questLog.UnitIsRelatedToActiveQuest and questLog.UnitIsRelatedToActiveQuest(unit)
	then
		return true
	end

	-- These two only know about open objectives
	if questTracker.objectiveCount > 0 then
		if br.game.UnitIsQuestBoss and br.game.UnitIsQuestBoss(unit) then
			return true
		end

		-- Objective text names the unit ("Kill Murlocs")
		local unitName = br.game.UnitName(unit)
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
	local objectID = br.game.ObjectID(object)
	if ignoreObjects[objectID] then return false end

	-- The server's quest flag on the object, on clients where its bit is known (br.client.rules.questObjectFlag,
	-- set per expansion) and the unlocker can read it: it decides outright
	local mask = br.client.rules.questObjectFlag
	if mask and br.game.ObjectDynamicFlags then
		local flags = br.game.ObjectDynamicFlags(object)
		if type(flags) == "number" then
			return br.game.bit.band(flags, mask) ~= 0
		end
	end

	if questObjectIDs[objectID] then return true end

	local objectName = br.game.ObjectName(object)
	if not objectName or nonQuestObjects[objectName] then return false end

	-- Name-based cache (avoids repeated lookups for the same object name)
	local cached = questTracker.objectCheckCache[objectName]
	if cached ~= nil then return cached end

	local lowerName = objectName:lower()
	local result = matchesObjective(lowerName, true) or matchesContainer(lowerName)
	questTracker.objectCheckCache[objectName] = result
	return result
end

----------------------------------------------------------------------------------------------------
-- Quest log cache
----------------------------------------------------------------------------------------------------

local function addObjective(questId, text, kind)
	if not text or text == "" then return end
	local list = questTracker.objectives[questId]
	if not list then
		list = {}
		questTracker.objectives[questId] = list
	end
	local name = parseObjectiveName(text)
	list[#list + 1] = { text = text:lower(), kind = kind, name = name, forms = name and subjectForms(paddedWords(name):sub(2, -2)),
		words = name and splitWords(name) }
	questTracker.objectiveCount = questTracker.objectiveCount + 1
	if name then addNameVariations(name, questTracker.cache) end
end

function questTracker:rebuild()
	br.game.wipe(questTracker.cache)
	br.game.wipe(questTracker.objectCheckCache)
	br.game.wipe(questTracker.objectives)
	br.game.wipe(questTracker.completed)
	questTracker.objectiveCount = 0
	questTracker.completedCount = 0

	local tracker = br.engines.tracker
	-- Anything classified against the old log is stale
	if tracker and tracker.invalidate then tracker:invalidate() end

	-- do not update if inside an instance
	if br.game.IsInInstance() then return end

	local questLog = br.game.C_QuestLog
	local numEntries = questLog.GetNumQuestLogEntries()
	for questIdx = 1, numEntries do
		local info = questLog.GetInfo(questIdx)
		local title, questId = info and info.title, info and info.questID
		if info and not info.isHeader and type(questId) == "number" and questId > 0 and ignoreQuest[questId] == nil then
			-- Finished quests (ready to turn in) have nothing left to track
			if questLog.IsComplete(questId) then
				if title then questTracker.completed[title] = true end
				questTracker.completedCount = questTracker.completedCount + 1
			elseif questLog and questLog.GetQuestObjectives then
				addNameVariations(title, questTracker.cache)
				local objectives = questLog.GetQuestObjectives(questId)
				if type(objectives) == "table" then
					for _, objective in ipairs(objectives) do
						if not objective.finished then addObjective(questId, objective.text, objective.type) end
					end
				end
			else
				addNameVariations(title, questTracker.cache)
				for objIdx = 1, (br.game.GetNumQuestLeaderBoards(questIdx) or 0) do
					local objectiveText, objectiveType, finished = br.game.GetQuestLogLeaderBoard(objIdx, questIdx)
					if objectiveText and not finished then addObjective(questId, objectiveText, objectiveType) end
				end
			end
		end
	end

	-- World quests in the current zone
	local mapId = br.game.C_Map and br.game.C_Map.GetBestMapForUnit("player")
	if mapId and br.game.C_TaskQuest and questLog and questLog.GetQuestObjectives then
		local worldQuests = br.game.C_TaskQuest.GetQuestsForPlayerOnMap and
			br.game.C_TaskQuest.GetQuestsForPlayerOnMap(mapId) or
			br.game.C_TaskQuest.GetQuestsOnMap(mapId)
		if type(worldQuests) == "table" then
			for _, questTable in ipairs(worldQuests) do
				local questId = questTable.questId or questTable.questID
				if type(questId) == "number" and questId > 0 and ignoreQuest[questId] == nil then
					local questName = br.game.C_TaskQuest.GetQuestInfoByQuestID(questId)
					if questName then addNameVariations(questName, questTracker.cache) end
					local objectives = questLog.GetQuestObjectives(questId)
					if type(objectives) == "table" then
						for _, objective in ipairs(objectives) do
							if not objective.finished then addObjective(questId, objective.text, objective.type) end
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
	questTracker.rebuildTimer = br.game.C_Timer.NewTimer(REBUILD_DELAY, function() questTracker:rebuild() end)
end

-- Debug function to print cache contents
function questTracker:printCache()
	br.game.print("=== Quest Tracker Cache Contents ===")
	for questId, objectives in pairs(questTracker.objectives) do
		for _, o in ipairs(objectives) do
			br.game.print(questId .. ": " .. o.text .. "  ->  " .. tostring(o.name))
		end
	end
	local count = 0
	for _ in pairs(questTracker.cache) do count = count + 1 end
	br.game.print("=== " .. questTracker.objectiveCount .. " objectives, " .. count .. " cached names ===")
end

local f = br.game.CreateFrame("Frame", "QuestFrame", br.game.UIParent)
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
br.game.C_Timer.After(1, function() questTracker:rebuild() end)
