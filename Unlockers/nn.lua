--------------------------------------------------------------------------------------------------------------------------------
-- unlockList
--------------------------------------------------------------------------------------------------------------------------------
local unlockList =
{
	"AcceptBattlefieldPort",
	"AcceptProposal",
	"AcceptTrade",
	"AssistUnit",
	"AttackTarget",
	"CameraOrSelectOrMoveStart",
	"CameraOrSelectOrMoveStop",
	"CancelItemTempEnchantment",
	"CancelLogout",
	"CancelShapeshiftForm",
	"CancelUnitBuff",
	"CastPetAction",
	"CastShapeshiftForm",
	"CastSpell",
	"CastSpellByID",
	"CastSpellByName",
	"ChangeActionBarPage",
	"ClearOverrideBindings",
	"ClearTarget",
	"CreateMacro",
	"DeleteCursorItem",
	"DeleteMacro",
	"DescendStop",
	"DestroyTotem",
	"FocusUnit",
	"ForceQuit",
	"GetUnscaledFrameRect",
	"GuildControlSetRank",
	"GuildControlSetRankFlag",
	"GuildDemote",
	"GuildPromote",
	"GuildUninvite",
	"JoinBattlefield",
	"JumpOrAscendStart",
	"Logout",
	"MoveBackwardStart",
	"MoveBackwardStop",
	"MoveForwardStart",
	"MoveForwardStop",
	"PetAssistMode",
	"PetAttack",
	"PetDefensiveAssistMode",
	"PetDefensiveMode",
	"PetFollow",
	"PetPassiveMode",
	"PetStopAttack",
	"PetWait",
	"PickupAction",
	"PickupCompanion",
	"PickupMacro",
	"PickupPetAction",
	"PickupSpell",
	"PickupSpellBookItem",
	"Quit",
	"ReplaceEnchant",
	"ReplaceTradeEnchant",
	"RunMacro",
	"RunMacroText",
	"StartAttack",
	"SendChatMessage",
	"SetBinding",
	"SetBindingClick",
	"SetBindingItem",
	"SetBindingMacro",
	"SetBindingSpell",
	"SetCurrentTitle",
	"SetMoveEnabled",
	"SetOverrideBinding",
	"SetOverrideBindingClick",
	"SetOverrideBindingItem",
	"SetOverrideBindingMacro",
	"SetOverrideBindingSpell",
	"SetTurnEnabled",
	"ShowUIPanel",
	"SitStandOrDescendStart",
	"SpellStopCasting",
	"SpellStopTargeting",
	"SpellTargetUnit",
	"StrafeLeftStart",
	"StrafeLeftStop",
	"StrafeRightStart",
	"StrafeRightStop",
	"Stuck",
	"TargetLastEnemy",
	"TargetLastTarget",
	"TargetNearestEnemy",
	"TargetNearestFriend",
	"TargetUnit",
	"ToggleAutoRun",
	"ToggleRun",
	"TurnLeftStart",
	"TurnLeftStop",
	"TurnOrActionStart",
	"TurnOrActionStop",
	"TurnRightStart",
	"TurnRightStop",
	"UninviteUnit",
	"UseAction",
	"UseContainerItem",
	"UseItemByName",
	"UseToy",
	"UseToyByName"
}

local globalCacheList =
{
	"AscendStop",
	"CanSummonFriend",
	"CheckInteractDistance",
	"CombatTextSetActiveUnit",
	"CopyToClipboard",
	"DemoteAssistant",
	"DropItemOnUnit",
	"FollowUnit",
	"GetDefaultLanguage",
	"GetPartyAssignment",
	"GetPlayerInfoByGUID",
	"GetRaidTargetIndex",
	"GetReadyCheckStatus",
	"GetUnitName",
	"GetUnitSpeed",
	"InitiateTrade",
	"InteractUnit",
	"IsItemInRange",
	"IsSpellInRange",
	"PitchDownStart",
	"PitchDownStop",
	"PitchUpStart",
	"PromoteToAssistant",
	"SetPortraitTexture",
	"SetRaidTarget",
	"SpellCanTargetUnit",
	"SpellIsTargeting",
	"SpellTargetItem",
	"StartAttack",
	"SummonFriend",
	"SwapRaidSubgroup",
	"ToggleGameMenu",
	"ToggleSpellAutocast",
	"UnitAffectingCombat",
	"UnitArmor",
	"UnitAttackPower",
	"UnitAttackSpeed",
	"UnitAura",
	"UnitAuraSlots",
	"UnitBuff",
	"UnitCanAssist",
	"UnitCanAttack",
	"UnitCanCooperate",
	"UnitCastingInfo",
	"UnitChannelInfo",
	"UnitClass",
	"UnitClassification",
	"UnitCreatureFamily",
	"UnitCreatureType",
	"UnitDamage",
	"UnitDebuff",
	"UnitDetailedThreatSituation",
	"UnitExists",
	"UnitGetIncomingHeals",
	"UnitGetTotalHealAbsorbs",
	"UnitGroupRolesAssigned",
	"UnitGUID",
	"UnitHealth",
	"UnitHealthMax",
	"UnitInBattleground",
	"UnitInParty",
	"UnitInRaid",
	"UnitInRange",
	"UnitIsAFK",
	"UnitIsCharmed",
	"UnitIsConnected",
	"UnitIsCorpse",
	"UnitIsDead",
	"UnitIsDeadOrGhost",
	"UnitIsDND",
	"UnitIsEnemy",
	"UnitIsFeignDeath",
	"UnitIsFriend",
	"UnitIsGhost",
	"UnitIsInMyGuild",
	"UnitIsPlayer",
	"UnitIsPossessed",
	"UnitIsPVP",
	"UnitIsPVPFreeForAll",
	"UnitIsPVPSanctuary",
	"UnitIsSameServer",
	"UnitIsTrivial",
	"UnitIsUnit",
	"UnitIsVisible",
	"UnitLevel",
	"UnitName",
	"UnitOnTaxi",
	"UnitPhaseReason",
	"UnitPlayerControlled",
	"UnitPlayerOrPetInParty",
	"UnitPlayerOrPetInRaid",
	"UnitPower",
	"UnitPower",
	"UnitPowerMax",
	"UnitPowerType",
	"UnitPVPName",
	"UnitRace",
	"UnitRangedAttackPower",
	"UnitRangedDamage",
	"UnitReaction",
	"UnitSelectionColor",
	"UnitSex",
	"UnitStat",
	"UnitThreatSituation",
	"UnitUsingVehicle",
	"UnitXP",
	"UnitXPMax",
	"UseInventoryItem"
}


--------------------------------------------------------------------------------------------------------------------------------
-- functions exported to BadRotations
--------------------------------------------------------------------------------------------------------------------------------
local _, br = ...
local b = br._G
local unlock = br.unlock
local funcCopies = {}
local globalFuncCopies = {}

-- local NoName = ...
-- local read   = NoName.Utils.Storage.read
-- local write  = NoName.Utils.Storage.write
-- local JSON   = NoName.Utils.JSON
-- local AceGUI = NoName.Utils.AceGUI

-- print "Loading Files. "
-- NoName:Require('/scripts/BadRotations/System/Lists/FileList', br)
-- for file, load in (br.files) do
-- 	if load then
-- 		NoName:Require('/scripts/'..file, br)
-- 	end
-- end

-- helper function
local function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		-- b.print(str)
		table.insert(t, str)
	end
	return t
end

local function fixPath(...)
	local str = ...
	if str == nil then return "" end

	if str:match("\\Interface\\AddOns\\") ~= nil then
		str = str:gsub(str:match("\\Interface\\AddOns\\"), "..\\")
	end
	local path = str:gsub(str:match("..\\BadRotations"), "\\scripts\\BadRotations")

	-- local filter = str:gsub(str:match("*.lua"),"*")
	-- local path = filter:gsub(filter:match("..\\BadRotations"),"\\scripts\\BadRotations")
	return path
end

-- make a backup copy of all APIs before AddOns hook them
for i = 1, #unlockList do
	local func = unlockList[i]
	funcCopies[func] = _G[func]
end

for i = 1, #globalCacheList do
	local func = globalCacheList[i]
	globalFuncCopies[func] = _G[func]
end
-- print("NN File Called")
function br.unlock:NNUnlock()
	if not C_Timer.Nn then return false end
	setfenv(1, C_Timer.Nn)
	-- print("NN Api Loaded")
	--------------------------------
	-- API unlocking
	--------------------------------
	for k, v in pairs(funcCopies) do
		b[k] = function(...) return Unlock(k, ...) end
	end
	for _, v in pairs(globalCacheList) do
		b[v] = C_Timer.Nn[v]
	end
	for k, v in pairs(globalFuncCopies) do
		if not b[k] then
			b[k] = function(...) return v(...) end
		end
	end

	--------------------------------
	-- API copy/rename/unlock
	--------------------------------
	-- b.ReadFile = ReadFile
	-- b.DirectoryExists = DirectoryExists
	-- b.WriteFile = WriteFile
	b.ClickPosition = ClickPosition
	-- b.CreateDirectory = CreateDirectory
	b.GetKeyState = GetKeyState
	b.ObjectName = ObjectName
	-- b.GetObjectWithIndex = ObjectByIndex
	b.ObjectPosition = ObjectPosition
	b.UnitMovementFlags = UnitMovementFlag
	-- b.GetWoWDirectory = GetWowDirectory
	b.ObjectFacing = ObjectFacing
	b.ObjectExists = ObjectExists
	b.GetCameraPosition = GetCameraPosition
	b.UnitFacing = ObjectFacing
	-- b.ObjectPointer = ObjectPointer
	-- b.TraceLine = TraceLine

	b.GetMousePosition = b.GetCursorPosition
	b.CancelPendingSpell = b.SpellStopTargeting
	b.ObjectIsVisible = b.UnitIsVisible
	b.IsAoEPending = b.SpellIsTargeting
	b.ObjectInteract = b.ObjectInteract
	b.InteractUnit = b.ObjectInteract

	b.TraceLine = function(unit1X, unit1Y, unit1Z, unit2X, unit2Y, unit2Z, offset)
		return TraceLine(unit1X, unit1Y, unit1Z, unit2X, unit2Y, unit2Z, offset) == false
	end

	b.CastSpellByName = function(spellName, unit)
		if unit == nil then return CastSpellByName(spellName) end --b.print("No unit provided to CastSpellByName") end
		return BRCastSpellByName(spellName, unit)
	end

	b.ObjectPointer = function(unit)
		return type(unit) == "number" and unit or ObjectPointer(unit)
	end

	b.ObjectID = function(unit)
		if unit == nil then return nil end
		if (type(unit) == "string") then
			local guid = UnitGUID(unit)
			if guid == nil then return nil end
			local _, _, _, _, _, npc_id = strsplit('-', guid)
			return tonumber(npc_id)
		end
		return ObjectID(unit)
	end

	b.UnitTarget = function(unit)
		return UnitTarget(unit)
	end
	b.UnitCreator = function(unit)
		return UnitCreator(unit)
	end
	b.UnitBoundingRadius = function(unit)
		return ObjectBoundingRadius(unit)
	end
	b.UnitCombatReach = function(unit)
		return CombatReach(unit)
	end


	--------------------------------
	-- API conversions
	--------------------------------
	b.GetWoWDirectory = function()
		return "\\scripts"
	end
	local om = {}
	b.GetObjectCount = function()
		om = Objects()
		return #Objects()
	end
	b.GetObjectWithIndex = function(index)
		return om[index]--ObjectByIndex(index)
	end
	b.ObjectType = function(...)
		return ObjectType(...)
	end
	b.ObjectIsUnit = function(...)
		local ObjType = ObjectType(...)
		return ObjType == 5
	end
	b.UnitCastID = function(...)
		local spellId1 = select(9, b.UnitCastingInfo(...)) or 0
		local spellId2 = select(9, b.UnitChannelInfo(...)) or 0
		local castGUID = b.UnitTarget(select(1, ...))
		return spellId1, spellId2, castGUID, castGUID
	end
	b.GetDirectoryFiles = function(...)
		local str = ...
		if str == nil then return "" end
		local filter = str:gsub(str:match("*.lua"), "*")
		-- print("Filter: "..filter)
		local files = ListFiles(filter)
		local returnFiles = ""
		for i = 1, #files do
			-- print("File: "..files[i])
			if files[i]:match(".lua") then
				if returnFiles == "" then
					returnFiles = files[i]
				else
					returnFiles = returnFiles .. "|" .. files[i]
				end
			end
		end
		return stringsplit(returnFiles, "|")
	end
	b.ReadFile = function(...)
		local path = ...--fixPath(...)
		return ReadFile(path)
	end
	b.WriteFile = function(...)
		local file, data, append = ...
		local path = file --fixPath(file)
		return WriteFile(path, data, append)
	end
	b.CreateDirectory = function(...)
		local path = ... --fixPath(...)
		return CreateDirectory(path)
	end
	b.DirectoryExists = function(...)
		local path = ... --fixPath(...)
		return DirectoryExists(path)
	end
	b.WorldToScreen = function(...)
		local multiplier = UIParent:GetScale()
		local sX, sY = WorldToScreen(...)
		return sX * multiplier, -sY * multiplier
	end
	b.FaceDirection = function(arg)
		if type(arg) == "number" then
			SetPlayerFacing(arg)
		else
			arg = b.GetAnglesBetweenObjects("player", arg)
			SetPlayerFacing(arg)
		end
	end
	b.GetObjectWithGUID = function(...)
		return ...
	end
	b.IsHackEnabled = function(...) return false end
	--------------------------------
	-- math
	--------------------------------
	b.GetDistanceBetweenPositions = function(X1, Y1, Z1, X2, Y2, Z2)
		return math.sqrt(math.pow(X2 - X1, 2) + math.pow(Y2 - Y1, 2) + math.pow(Z2 - Z1, 2))
	end
	b.GetAnglesBetweenObjects = function(Object1, Object2)
		if Object1 and Object2 then
			local X1, Y1, Z1 = b.ObjectPosition(Object1)
			local X2, Y2, Z2 = b.ObjectPosition(Object2)
			return math.atan2(Y2 - Y1, X2 - X1) % (math.pi * 2),
				math.atan((Z1 - Z2) / math.sqrt(math.pow(X1 - X2, 2) + math.pow(Y1 - Y2, 2))) % math.pi
		else
			return 0, 0
		end
	end
	b.GetAnglesBetweenPositions = function(X1, Y1, Z1, X2, Y2, Z2)
		return math.atan2(Y2 - Y1, X2 - X1) % (math.pi * 2),
			math.atan((Z1 - Z2) / math.sqrt(math.pow(X1 - X2, 2) + math.pow(Y1 - Y2, 2))) % math.pi
	end
	b.GetPositionFromPosition = function(X, Y, Z, Distance, AngleXY, AngleXYZ)
		return math.cos(AngleXY) * Distance + X, math.sin(AngleXY) * Distance + Y, math.sin(AngleXYZ) * Distance + Z
	end
	b.GetPositionBetweenPositions = function(X1, Y1, Z1, X2, Y2, Z2, DistanceFromPosition1)
		local AngleXY, AngleXYZ = b.GetAnglesBetweenPositions(X1, Y1, Z1, X2, Y2, Z2)
		return b.GetPositionFromPosition(X1, Y1, Z1, DistanceFromPosition1, AngleXY, AngleXYZ)
	end
	b.GetPositionBetweenObjects = function(unit1, unit2, DistanceFromPosition1)
		local X1, Y1, Z1 = b.ObjectPosition(unit1)
		local X2, Y2, Z2 = b.ObjectPosition(unit2)
		if not X1 or not X2 then return end
		local AngleXY, AngleXYZ = b.GetAnglesBetweenPositions(X1, Y1, Z1, X2, Y2, Z2)
		return b.GetPositionFromPosition(X1, Y1, Z1, DistanceFromPosition1, AngleXY, AngleXYZ)
	end
	b.GetDistanceBetweenObjects = function(unit1, unit2)
		local X1, Y1, Z1 = b.ObjectPosition(unit1)
		local X2, Y2, Z2 = b.ObjectPosition(unit2)
		return math.sqrt((X2 - X1) ^ 2 + (Y2 - Y1) ^ 2 + (Z2 - Z1) ^ 2)
	end
	b.ObjectIsFacing = function(obj1, obj2, degrees)
		local Facing = b.UnitFacing(obj1)
		local AngleToUnit = b.GetAnglesBetweenObjects(obj1, obj2)
		local AngleDifference = Facing > AngleToUnit and Facing - AngleToUnit or AngleToUnit - Facing
		local ShortestAngle = AngleDifference < math.pi and AngleDifference or math.pi * 2 - AngleDifference
		degrees = degrees and b.rad(degrees) / 2 or math.pi / 2
		return ShortestAngle < degrees
	end
	--------------------------------
	-- extra APIs
	--------------------------------
	b.AuraUtil = {}
	b.AuraUtil.FindAuraByName = _G.AuraUtil["FindAuraByName"]
	b.ObjectIsGameObject = function(...)
		local ObjType = ObjectType(...)
		return ObjType == 8 or ObjType == 11
	end
	b.GetMapId = function()
		return select(8, b.GetInstanceInfo())
	end
	--------------------------------
	-- missing APIs
	--------------------------------
	b.IsQuestObject = function(obj)
		return false
	end
	b.ScreenToWorld = function()
		return 0, 0
	end




	br.unlocker = "NN"
	return true
end
