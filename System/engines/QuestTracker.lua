local LibDraw = LibStub("LibDraw-1.0")
br.QuestCache = {}

--Quest stuff
--local questPlateTooltip = CreateFrame('GameTooltip', 'QuestPlateTooltip', nil, 'GameTooltipTemplate')
local questTooltipScanQuest = CreateFrame ("GameTooltip", "QuestPlateTooltipScanQuest", nil, "GameTooltipTemplate")
local ScannedQuestTextCache = {}

function isQuestUnit(Pointer)
	local guid = ObjectGUID(Pointer)
	--local myName = UnitName("player")
	questTooltipScanQuest:SetOwner(WorldFrame, 'ANCHOR_NONE')
	questTooltipScanQuest:SetHyperlink('unit:' .. guid)
	for i = 1, questTooltipScanQuest:NumLines() do
		ScannedQuestTextCache[i] = _G ["QuestPlateTooltipScanQuestTextLeft" .. i]
	end

	local isQuestUnit = false
	local atLeastOneQuestUnfinished = false
	for i = 1, #ScannedQuestTextCache do
		local text = ScannedQuestTextCache[i]:GetText()
		if (br.QuestCache[text]) then
			--unit belongs to a quest
			isQuestUnit = true
			local amount1, amount2 = nil, nil
			local j = i
			while (ScannedQuestTextCache[j+1]) do
				--check if the unit objective isn't already done
				local nextLineText = ScannedQuestTextCache [j+1]:GetText()
				if (nextLineText) then
					if not nextLineText:match(THREAT_TOOLTIP) then
						local p1, p2 = nextLineText:match ("(%d+)/(%d+)")
						if (not p1) then
							-- check for % based quests
							p1 = nextLineText:match ("(%d+%%)")
							if p1 then
								-- remove the % sign for consistency
								p1 = string.gsub(p1,"%%", '')
							end
						end
						if (p1 and p2 and not (p1 == p2)) or (p1 and not p2 and not (p1 == "100")) then
							-- quest not completed
							atLeastOneQuestUnfinished = true
							amount1, amount2 = p1, p2
						end
					else
						j = 99 --safely break here, as we saw threat% -> quest text is done
					end
				end
				j = j + 1
			end
		end
	end
	if isQuestUnit and atLeastOneQuestUnfinished and (not UnitIsDeadOrGhost(Pointer) or UnitIsFriend("player", Pointer)) then
		return true
	else
		return false
	end
end

local QuestCacheUpdate = function()

	local ignoreQuest = {
		[56064] = true, -- Assault Black Empire (Vale)
		[55350] = true, -- Assault Amathet Advance
		[56308] = true, -- Assault Aqir Unearthed
	}
	--clear the quest cache
	wipe(br.QuestCache)

	--do not update if is inside an instance
	local isInInstance = IsInInstance()
	if (isInInstance) then
		return
	end

	--update the quest cache
	local numEntries, numQuests = C_QuestLog.GetNumQuestLogEntries()
	for questIdx = 1, numEntries do
		-- local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questId, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle (questId)
		local title, _, questId = C_QuestLog.GetInfo(questIdx)
		if (type (questId) == "number" and questId > 0 and ignoreQuest[questId] == nil) then -- and not isComplete
			br.QuestCache[title] = true
		end
	end

	local mapId = C_Map.GetBestMapForUnit ("player")
	if (mapId) then
		local worldQuests = C_TaskQuest.GetQuestsForPlayerByMapID (mapId)
		if (type (worldQuests) == "table") then
			for i, questTable in ipairs (worldQuests) do
				local x, y, floor, numObjectives, questId, inProgress = questTable.x, questTable.y, questTable.floor, questTable.numObjectives, questTable.questId, questTable.inProgress
				if (type (questId) == "number" and questId > 0 and ignoreQuest[questId] == nil) then
					local questName = C_TaskQuest.GetQuestInfoByQuestID (questId)
					if (questName) then
						br.QuestCache[questName] = true
					end
				end
			end
		end
	end
end

local function FunctionQuestLogUpdate() --private
	if (QuestCacheThrottle and not QuestCacheThrottle._cancelled) then
		QuestCacheThrottle:Cancel()
	end
	QuestCacheThrottle = C_Timer.NewTimer (2, QuestCacheUpdate)
end

function isQuestObject(object) --Ty Ssateneth
	local objectID = ObjectID(object)
	local ignoreObjects = {
		[327571] = true,
	}
	if ignoreObjects[objectID] ~= nil then 
		return false
	end
    if objectID == 325958 or objectID == 325962 or objectID == 325963 or objectID == 325959 or objectID == 335703 or objectID == 152692 or objectID == 163757 or objectID == 290542 or objectID == 113768 or objectID == 113771 or objectID == 113769 or objectID == 113770 or objectID == 153290 or
        objectID == 322413 or objectID == 326395 or objectID == 326399 or objectID == 326418 or objectID == 326413 or objectID == 327577 or objectID == 327576 or objectID == 327578 or objectID == 325799 or
        objectID == 326417 or objectID == 326411 or objectID == 326412 or objectID == 326413 or objectID == 326414 or objectID == 326415 or objectID == 326416 or objectID == 326417 or objectID == 326418 or objectID == 326419 or objectID == 326420 or objectID == 326403 or objectID == 326408 or objectID == 326407 or -- nasjatar chests
        objectID == 325662 or objectID == 325659 or objectID == 325660 or objectID == 325661 or objectID == 325663 or objectID == 325664 or objectID == 325665 or objectID == 325666 or objectID == 325667 or objectID == 325668 or -- mechagon chests
        objectID == 151166 -- algan units
    then return true end
    local glow = ObjectDescriptor(object,GetOffset("CGObjectData__DynamicFlags"),"uint")
    if glow and (bit.band(glow,0x4)~=0 or bit.band(glow,0x20)~=0) then
        return true
    end
    return false
end

function ObjectFlags(object)
    local glow = ObjectDescriptor(object,GetOffset("CGObjectData__DynamicFlags"),"uint")
    if glow then
        for i = 0, 32 do
            local band = "0x"..i
            if bit.band(glow,band) ~= 0 then
                print(band)
            end
        end
    end
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
    if GetObjectWithGUID then
        local func = eventFunctions [event]
        if (func) then
            func (event, ...)
        else
            Print("no registered function for event " .. (event or "unknown event"))
        end
    end
end

local f = CreateFrame("Frame", "QuestFrame", UIParent)
		f:RegisterEvent ("QUEST_ACCEPTED")
		f:RegisterEvent ("QUEST_REMOVED")
		f:RegisterEvent ("QUEST_ACCEPT_CONFIRM")
		f:RegisterEvent ("QUEST_COMPLETE")
		f:RegisterEvent ("QUEST_POI_UPDATE")
		f:RegisterEvent ("QUEST_DETAIL")
		f:RegisterEvent ("QUEST_FINISHED")
		f:RegisterEvent ("QUEST_GREETING")
		f:RegisterEvent ("QUEST_LOG_UPDATE")
		f:RegisterEvent ("UNIT_QUEST_LOG_CHANGED")
f:SetScript ("OnEvent", QuestEventHandler)
