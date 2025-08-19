local _, br = ...
-- local LibDraw = br._G.LibStub("LibDraw-BR")
br.QuestCache = {}

--Quest stuff
--local questPlateTooltip = CreateFrame('GameTooltip', 'QuestPlateTooltip', nil, 'GameTooltipTemplate')
local questTooltipScanQuest = br._G.CreateFrame("GameTooltip", "QuestPlateTooltipScanQuest", nil, "GameTooltipTemplate")
local ScannedQuestTextCache = {}

function br.isQuestUnit(Pointer)
	local guid
	if not br._G["lb"] then
		guid = br._G.UnitGUID(Pointer)
	else
		guid = Pointer
	end
	--local myName = UnitName("player")
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
		if (br.QuestCache[text]) then
			--unit belongs to a quest
			isQuestUnit = true
			-- local amount1, amount2 = nil, nil
			local j = i
			while (ScannedQuestTextCache[j + 1]) do
				--check if the unit objective isn't already done
				local nextLineText = ScannedQuestTextCache[j + 1]:GetText()
				if (nextLineText) then
					if not nextLineText:match(br._G["THREAT_TOOLTIP"]) then
						local p1, p2 = nextLineText:match("(%d+)/(%d+)")
						if (not p1) then
							-- check for % based quests
							p1 = nextLineText:match("(%d+%%)")
							if p1 then
								-- remove the % sign for consistency
								p1 = string.gsub(p1, "%%", '')
							end
						end
						if (p1 and p2 and not (p1 == p2)) or (p1 and not p2 and not (p1 == "100")) then
							-- quest not completed
							atLeastOneQuestUnfinished = true
							-- amount1, amount2 = p1, p2
						end
					else
						j = 99 --safely break here, as we saw threat% -> quest text is done
					end
				end
				j = j + 1
			end
		end
	end
	if isQuestUnit and atLeastOneQuestUnfinished and
		(not br.GetUnitIsDeadOrGhost(Pointer) or br.GetUnitIsFriend("player", Pointer)) then
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
	--clear the quest cache
	br._G.wipe(br.QuestCache)

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
		_, title, _, _, _, _, _, questID = GetQuestLogTitle(questLogIndex)
		-- local title = questInfo["title"]
		-- local questId = questInfo["questID"]
		if (type(questId) == "number" and questId > 0 and ignoreQuest[questId] == nil) then -- and not isComplete
			br.QuestCache[title] = true
		end
	end

	local mapId = br._G.C_Map.GetBestMapForUnit("player")
	if (mapId) then
		local worldQuests = br._G.C_TaskQuest.GetQuestsOnMap(mapId)
		if (type(worldQuests) == "table") then
			for _, questTable in ipairs(worldQuests) do
				local questId = questTable.questId
				if (type(questId) == "number" and questId > 0 and ignoreQuest[questId] == nil) then
					local questName = br._G.C_TaskQuest.GetQuestInfoByQuestID(questId)
					if (questName) then
						br.QuestCache[questName] = true
					end
				end
			end
		end
	end
end

local function FunctionQuestLogUpdate() --private
	if (br.QuestCacheThrottle and not br.QuestCacheThrottle["_cancelled"]) then
		br.QuestCacheThrottle:Cancel()
	end
	br.QuestCacheThrottle = br._G.C_Timer.NewTimer(2, QuestCacheUpdate)
end

function br.isQuestObject(object) --Ty Ssateneth
	local objectID = br._G.ObjectID(object)
	local ignoreObjects = {
		[327571] = true,
	}
	if ignoreObjects[objectID] ~= nil then
		return false
	end
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
	then return true end
	local glow = br.getItemGlow(object) --or select(2, CanLootUnit(object)) or questObj == 12
	if glow then
		return true
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
