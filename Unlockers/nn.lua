---@diagnostic disable: param-type-mismatch, undefined-global
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
	"ObjectType",
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
	"C_Spell.PickupSpell",
	"PickupSpellBookItem",
	"Quit",
	"ReplaceEnchant",
	"ReplaceTradeEnchant",
	"RunMacro",
	-- "C_Macro.RunMacroText",
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
	-- "TargetUnit",
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
	-- "CanSummonFriend", -- Not Provided
	"CheckInteractDistance",
	"CombatTextSetActiveUnit",
	"CopyToClipboard",
	"CreateDirectory",
	"DemoteAssistant",
	"DirectoryExists",
	"DropItemOnUnit",
	"FollowUnit",
	"GetAnglesBetweenPositions",
	"GetDefaultLanguage",
	"GetPartyAssignment",
	"GetPlayerInfoByGUID",
	"GetPositionFromPosition",
	"GetReadyCheckStatus",
	"GetUnitName",
	"InitiateTrade",
	"IsItemInRange",
	"IsSpellInRange",
	"PitchDownStart",
	"PitchDownStop",
	"PitchUpStart",
	"PromoteToAssistant",
	"ReadFile",
	"ScreenToWorld",
	"SetPortraitTexture",
	"SetRaidTarget",
	"SpellCanTargetUnit",
	"SpellIsTargeting",
	"SpellTargetItem",
	"StartAttack",
	-- "SummonFriend", -- Not Provided
	"SwapRaidSubgroup",
	"ToggleGameMenu",
	-- "ToggleSpellAutoCast", -- Not Provided
	"TraceLine",
	"UnitAffectingCombat",
	"UnitArmor",
	"UnitAttackPower",
	"UnitAttackSpeed",
	-- "UnitAura", -- Not Provided
	-- "UnitAuraSlots", -- Not Provided
	-- "UnitBuff",-- Not Provided
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
	-- "UnitDebuff", -- Not Provided
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
	"UnitTarget",
	"UnitUsingVehicle",
	"UnitXP",
	"UnitXPMax",
	"UseInventoryItem",
	"WorldToScreen",
	"WriteFile"
}


--------------------------------------------------------------------------------------------------------------------------------
-- functions exported to BadRotations
--------------------------------------------------------------------------------------------------------------------------------
local _, br = ...
local b = br._G
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
		if C_Timer.Nn[v] == nil then
			print("Function: " .. tostring(v) .. ", was not provided.")
		else
			b[v] = C_Timer.Nn[v]
		end
	end
	for k, v in pairs(globalFuncCopies) do
		if not b[k] then
			b[k] = function(...) return v(...) end
		end
	end

	--------------------------------
	-- API copy/rename/unlock
	--------------------------------
	-- b.DirectoryExists = DirectoryExists
	b.ClickPosition = ClickPosition
	b.GetKeyState = GetKeyState
	b.ObjectName = ObjectName
	b.ObjectPosition = ObjectPosition
	b.UnitMovementFlags = UnitMovementFlag
	b.ObjectFacing = ObjectFacing
	b.ObjectExists = ObjectExists
	b.GetCameraPosition = GetCameraPosition
	b.UnitFacing = ObjectFacing
	b.GetMousePosition = b.GetCursorPosition
	b.CancelPendingSpell = b.SpellStopTargeting
	b.ObjectIsVisible = b.UnitIsVisible
	b.IsAoEPending = b.SpellIsTargeting
	b.ObjectInteract = b.ObjectInteract
	b.InteractUnit = b.ObjectInteract
	b.GetDistanceBetweenPositions = Distance
	b.GetDistanceBetweenObjects = Distance
	b.RunMacroText = RunMacroText
	b.AuraUtil = AuraUtil

	local ObjectUnit = function(unit)
		return type(unit) == "number" and Object(unit) or unit
	end

	b.CastSpellByName = function(spellName, unit)
		if unit == nil then return CastSpellByName(spellName) end
		return CastSpellByName(spellName, ObjectUnit(unit))
	end

	b.ObjectPointer = function(unit)
		return Object(unit)
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

	-- b.UnitTarget = function(unit)
	-- 	return UnitTarget(unit)
	-- end
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
		return om[index]
	end

	b.ObjectIsUnit = function(...)
		return ObjectType(...) == 5
	end

	b.UnitCastID = function(...)
		local spellId1 = select(9, b.UnitCastingInfo(...)) or 0
		local spellId2 = select(9, b.UnitChannelInfo(...)) or 0
		local castGUID = b.UnitTarget(select(1, ...))
		return spellId1, spellId2, castGUID, castGUID
	end
	b.GetDirectoryFiles = function(...)
		local str = ...
		if str == nil or str == "*" then return "" end
		-- print("str: "..tostring(str))
		str = str .. "*.lua" --:match("*.lua") or str
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

	b.GetAnglesBetweenObjects = function(Object1, Object2)
		if Object1 and Object2 then
			local X1, Y1, Z1 = b.ObjectPosition(Object1)
			local X2, Y2, Z2 = b.ObjectPosition(Object2)
			return GetAnglesBetweenPositions(X1, Y1, Z1, X2, Y2, Z2)
		else
			return 0, 0
		end
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

	b.ObjectIsFacing = function(obj1, obj2, degrees)
		local Facing = b.UnitFacing(obj1)
		local AngleToUnit = b.GetAnglesBetweenObjects(obj1, obj2)
		local AngleDifference = Facing > AngleToUnit and Facing - AngleToUnit or AngleToUnit - Facing
		local ShortestAngle = AngleDifference < math.pi and AngleDifference or math.pi * 2 - AngleDifference
		degrees = degrees and b.rad(degrees) / 2 or math.pi / 2
		return ShortestAngle < degrees
	end
	------------------------- Miscellaneous -------------------
	-- b.AuraUtil = {}
	-- b.AuraUtil.FindAuraByName = function(name, unit, filter)
	-- 	-- return Eval("AuraUtil.FindAuraByName("..table.concat({...}, ", ")..")", "")
	-- 	return AuraUtil.FindAuraByName(name, ObjectUnit(unit), filter)
	-- end
	b.ObjectIsGameObject = function(...)
		local ObjType = ObjectType(...)
		return ObjType == 8 or ObjType == 11
	end

	b.TargetUnit = function(unit)
		if Object(unit) then
			return TargetUnit(Object(unit))
		else
			return
		end
	end
	b.InteractUnit = function(unit)
		return ObjectInteract(Object(unit))
	end
	------------------------------------------
	--- API - Unit Function Object Handler ---
	------------------------------------------
	-- b.CastSpellByName = function(spell, unit)
	-- 	return Unlock("CastSpellByName(\""..spell.."\", \""..ObjectUnit(unit).."\")", "")
	-- end
	b.GetRaidTargetIndex = function(...)
		return GetRaidTargetIndex(ObjectUnit(...))
	end
	b.GetUnitSpeed = function(...)
		return GetUnitSpeed(ObjectUnit(...))
	end
	b.InSpellInRange = function(spell, unit)
		return C_Spell.IsSpellInRange(spell, ObjectUnit(unit))
	end
	b.UnitAffectingCombat = function(...)
		return UnitAffectingCombat(ObjectUnit(...))
	end
	b.UnitAttackSpeed = function(...)
		return UnitAttackSpeed(ObjectUnit(...))
	end
	b.UnitAura = function(unit, index, filter)
		return C_UnitAuras.GetAuraDataByIndex(ObjectUnit(unit), index, filter)
	end
	b.UnitBuff = function(unit, index, filter)
		return C_UnitAuras.GetBuffDataByIndex(ObjectUnit(unit), index, filter)
	end
	b.UnitCanAttack = function(unit1, unit2)
		return UnitCanAttack(ObjectUnit(unit1), ObjectUnit(unit2))
	end
	b.UnitCastingInfo = function(...)
		return UnitCastingInfo(ObjectUnit(...))
	end
	b.UnitChannelInfo = function(...)
		return UnitChannelInfo(ObjectUnit(...))
	end
	b.UnitClass = function(...)
		return UnitClass(ObjectUnit(...))
	end
	b.UnitClassification = function(...)
		return UnitClassification(ObjectUnit(...))
	end
	b.UnitCreatureFamily = function(...)
		return UnitCreatureFamily(ObjectUnit(...))
	end
	b.UnitCreatureType = function(...)
		return UnitCreatureType(ObjectUnit(...))
	end
	b.UnitDebuff = function(unit, index, filter)
		return C_UnitAuras.GetDebuffDataByIndex(ObjectUnit(unit), index, filter)
	end
	b.UnitExists = function(...)
		return UnitExists(ObjectUnit(...))
	end
	b.UnitGetIncomingHeals = function(unit1, unit2)
		return UnitGetIncomingHeals(ObjectUnit(unit1), ObjectUnit(unit2))
	end
	b.UnitGUID = function(...)
		return UnitGUID(ObjectUnit(...))
	end
	b.UnitHealth = function(...)
		return UnitHealth(ObjectUnit(...))
	end
	b.UnitHealthMax = function(...)
		return UnitHealthMax(ObjectUnit(...))
	end
	b.UnitLevel = function(...)
		return UnitLevel(ObjectUnit(...))
	end
	b.UnitName = function(...)
		return UnitName(ObjectUnit(...))
	end
	b.UnitInParty = function(...)
		return UnitInParty(ObjectUnit(...))
	end
	b.UnitInRaid = function(...)
		return UnitInRaid(ObjectUnit(...))
	end
	b.UnitInRange = function(...)
		return UnitInRange(ObjectUnit(...))
	end
	b.UnitIsCharmed = function(...)
		return UnitIsCharmed(ObjectUnit(...))
	end
	b.UnitIsConnected = function(...)
		return UnitIsConnected(ObjectUnit(...))
	end
	b.UnitIsDeadOrGhost = function(...)
		return UnitIsDeadOrGhost(ObjectUnit(...))
	end
	b.UnitIsEnemy = function(unit1, unit2)
		return UnitIsEnemy(ObjectUnit(unit1), ObjectUnit(unit2))
	end
	b.UnitIsFriend = function(unit1, unit2)
		return UnitIsFriend(ObjectUnit(unit1), ObjectUnit(unit2))
	end
	b.UnitIsPlayer = function(...)
		return UnitIsPlayer(ObjectUnit(...))
	end
	b.UnitIsUnit = function(unit1, unit2)
		return UnitIsUnit(ObjectUnit(unit1), ObjectUnit(unit2))
	end
	b.UnitIsVisible = function(...)
		return UnitIsVisible(ObjectUnit(...))
	end
	b.UnitOnTaxi = function(...)
		return UnitOnTaxi(ObjectUnit(...))
	end
	b.UnitPhaseReason = function(...)
		return UnitPhaseReason(ObjectUnit(...))
	end
	b.UnitPower = function(unit, powerType)
		return UnitPower(ObjectUnit(unit), powerType)
	end
	b.UnitPowerMax = function(unit, powerType)
		return UnitPowerMax(ObjectUnit(unit), powerType)
	end
	b.UnitRace = function(...)
		return UnitRace(ObjectUnit(...))
	end
	b.UnitReaction = function(unit1, unit2)
		return UnitReaction(ObjectUnit(unit1), ObjectUnit(unit2))
	end
	b.UnitStat = function(unit, statIndex)
		return UnitStat(ObjectUnit(unit), statIndex)
	end
	b.UnitIsTapDenied = function(...)
		return UnitIsTapDenied(ObjectUnit(...))
	end
	b.UnitThreatSituation = function(unit1, unit2)
		return UnitThreatSituation(ObjectUnit(unit1), ObjectUnit(unit2))
	end
	b.UnitIsTrivial = function(...)
		return UnitIsTrivial(ObjectUnit(...))
	end

	--------------------------------
	-- extra APIs
	--------------------------------
	-- b.AuraUtil = {}
	-- b.AuraUtil.FindAuraByName = _G.AuraUtil["FindAuraByName"]
	-- b.ObjectIsGameObject = function(...)
	-- 	local ObjType = ObjectType(...)
	-- 	return ObjType == 8 or ObjType == 11
	-- end
	b.GetMapId = function()
		return select(8, b.GetInstanceInfo())
	end
	--------------------------------
	-- missing APIs
	--------------------------------
	b.IsQuestObject = function(obj)
		return false
	end

	br.unlocker = "NN"
	return true
end
