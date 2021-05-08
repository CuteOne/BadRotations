--------------------------------------------------------------------------------------------------------------------------------
-- unlockList
--------------------------------------------------------------------------------------------------------------------------------
local unlockList =
{
	"AcceptBattlefieldPort",
	"AcceptProposal",
	"AcceptTrade",
	"AscendStop",
	"AssistUnit",
	"AttackTarget",
	"CameraOrSelectOrMoveStart",
	"CameraOrSelectOrMoveStop",
	"CancelItemTempEnchantment",
	"CancelLogout",
	"CancelShapeshiftForm",
	"CancelUnitBuff",
	"CanSummonFriend",
	"CastPetAction",
	"CastShapeshiftForm",
	"CastSpell",
	"CastSpellByID",
	"CastSpellByName",
	"ChangeActionBarPage",
	"CheckInteractDistance",
	"ClearOverrideBindings",
	"ClearTarget",
	"CombatTextSetActiveUnit",
	"CopyToClipboard",
	"CreateMacro",
	"DeleteCursorItem",
	"DeleteMacro",
	"DemoteAssistant",
	"DescendStop",
	"DestroyTotem",
	"DropItemOnUnit",
	"FocusUnit",
	"FollowUnit",
	"ForceQuit",
	"GetDefaultLanguage",
	"GetPartyAssignment",
	"GetPlayerInfoByGUID",
	"GetRaidTargetIndex",
	"GetReadyCheckStatus",
	"GetUnitName",
	"GetUnitSpeed",
	"GetUnscaledFrameRect",
	"GuildControlSetRank",
	"GuildControlSetRankFlag",
	"GuildDemote",
	"GuildPromote",
	"GuildUninvite",
	"InitiateTrade",
	"InteractUnit",
	"IsItemInRange",
	"IsSpellInRange",
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
	"PitchDownStart",
	"PitchDownStop",
	"PitchUpStart",
	"PromoteToAssistant",
	"Quit",
	"ReplaceEnchant",
	"ReplaceTradeEnchant",
	"RunMacro",
	"RunMacroText",
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
	"SetPortraitTexture",
	"SetRaidTarget",
	"SetTurnEnabled",
	"ShowUIPanel",
	"SitStandOrDescendStart",
	"SpellCanTargetUnit",
	"SpellIsTargeting",
	"SpellStopCasting",
	"SpellStopTargeting",
	"SpellTargetItem",
	"SpellTargetUnit",
	"StartAttack",
	"StrafeLeftStart",
	"StrafeLeftStop",
	"StrafeRightStart",
	"StrafeRightStop",
	"Stuck",
	"SummonFriend",
	"SwapRaidSubgroup",
	"TargetLastEnemy",
	"TargetLastTarget",
	"TargetNearestEnemy",
	"TargetNearestFriend",
	"TargetUnit",
	"ToggleAutoRun",
	"ToggleGameMenu",
	"ToggleRun",
	"ToggleSpellAutocast",
	"TurnLeftStart",
	"TurnLeftStop",
	"TurnOrActionStart",
	"TurnOrActionStop",
	"TurnRightStart",
	"TurnRightStop",
	"UninviteUnit",
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
	"UseAction",
	"UseContainerItem",
	"UseInventoryItem",
	"UseItemByName",
	"UseToy",
	"UseToyByName"
}

--------------------------------------------------------------------------------------------------------------------------------
-- functions exported to BadRotations
--------------------------------------------------------------------------------------------------------------------------------
local _, br = ...
local b = br._G
local unlock = br.unlock
local wa = nil
local funcCopies = {}

-- helper function
local function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

-- obtain references to WA APIs from the BadRotations plugin
if _G.BR_WA then
	wa = _G.BR_WA
	_G.BR_WA = nil

	-- make a backup copy of all APIs before AddOns hook them
	for i = 1, #unlockList do
		local func = unlockList[i]
		funcCopies[func] = _G[func]
	end
else
	-- either not WA or BR addon is not enabled
end


function unlock.WowAdUnlock()
	if not wa then
		return false
	end
	--------------------------------
	-- API unlocking
	--------------------------------
	for k, v in pairs(funcCopies) do
		b[k] = function(...) return wa.CallSecureFunction(v, ...) end
	end

	--------------------------------
	-- API copy/rename/unlock
	--------------------------------
	b.ReadFile = wa.ReadFile
	b.DirectoryExists = wa.DirectoryExists
	b.WriteFile = wa.WriteFile
	b.ClickPosition = wa.ClickPosition
	b.CreateDirectory = wa.CreateDirectory
	b.GetKeyState = wa.GetKeyState
	b.ObjectName = wa.ObjectName
	b.GetObjectWithIndex = wa.GetObjectWithIndex
	b.ObjectPosition = wa.GetUnitPosition
	b.UnitMovementFlags = wa.GetUnitMovementFlags
	b.GetWoWDirectory = wa.GetWowDirectory
	b.ObjectFacing = wa.UnitFacing
	b.GetMousePosition = b.GetCursorPosition
	b.ObjectExists = wa.ObjectExists
	b.GetCameraPosition = wa.GetCameraPosition
	b.CancelPendingSpell = b.SpellStopTargeting
	b.ObjectIsVisible = b.UnitIsVisible
	b.IsAoEPending = b.SpellIsTargeting
	b.ObjectInteract = b.InteractUnit
	b.UnitFacing = wa.UnitFacing
	b.GetObjectCount = wa.GetObjectCount
	b.GetNewObjects = wa.GetNewObjects
	
	--------------------------------
	-- object fields
	--------------------------------
	b.UnitTarget = function(unit)
		return wa.ObjectField(unit, 0x1C58, 15)
	end
	b.UnitCreator = function(unit)
		return wa.ObjectField(unit, 0x13C8, 15)
	end
	b.UnitBoundingRadius = function(unit)
		return wa.ObjectField(unit, 0x1CEC, 10)
	end
	b.UnitCombatReach = function(unit)
		return wa.ObjectField(unit, 0x1CF0, 10)
	end	
	--------------------------------
	-- API conversions
	--------------------------------
	b.ObjectPointer = function(...)
		if b.UnitExists(...) then
			return b.UnitGUID(...)
		end
	end
	b.ObjectIsUnit = function(...)
		local ObjType = wa.ObjectType(...)
		return ObjType == 5
	end
	b.ObjectID = function(object)
		local guid = b.UnitGUID(object)
		if guid then
			local _, _, _, _, _, objectId, _ = strsplit("-", guid);
			return tonumber(objectId);
		else
			return 0
		end
	end
	b.TraceLine = function(...)
		local hit, hitx, hity, hitz = wa.TraceLine(...)
		if hit == 1 then
			return hitx, hity, hitz
		else
			return nil
		end
	end
	b.UnitCastID = function(...)
		local spellId1 = select(9, b.UnitCastingInfo(...)) or 0
		local spellId2 = select(9, b.UnitChannelInfo(...)) or 0
		local castGUID = b.UnitTarget(select(1,...))
		return spellId1, spellId2, castGUID, castGUID
	end
	b.GetDirectoryFiles = function(...)
		local filter = stringsplit(..., "*")
		local files = wa.GetDirectoryFiles(filter[1], "*.lua")
		return stringsplit(files, "|")
	end
	b.WorldToScreen = function(...)
		local multiplier = UIParent:GetScale()
		local sX, sY = wa.WorldToScreen(...)
		return sX * multiplier, -sY * multiplier
	end
	b.FaceDirection = function(arg)
		if type(arg) == "number" then
			wa.FaceDirection(arg)
		else
			arg = b.GetAnglesBetweenObjects("player", arg)
			wa.FaceDirection(arg)
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
		return math.sqrt((X2-X1)^2 + (Y2-Y1)^2 + (Z2-Z1)^2)
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
	b.AuraUtil.FindAuraByName = function(...)
		return wa.CallSecureFunction(_G.AuraUtil["FindAuraByName"], ...)
	end
	b.ObjectIsGameObject = function(...)
		local ObjType = wa.ObjectType(...)
		return ObjType == 8 or ObjType == 11
	end
	b.GetMapId = function()
		return select(8, GetInstanceInfo())
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
	--------------------------------
	-- cached functions
	--------------------------------	
	b.ObjectExists = wa.createCachedFunction(b.ObjectExists, 1)
	b.UnitExists = wa.createCachedFunction(b.UnitExists, 1)
	b.UnitIsVisible = wa.createCachedFunction(b.UnitIsVisible, 1)
	b.ObjectIsVisible = wa.createCachedFunction(b.ObjectIsVisible, 1)
	
	b.ObjectPointer = wa.createCachedFunction(b.ObjectPointer, 2)
	b.UnitGUID = wa.createCachedFunction(b.UnitGUID, 2)
	b.UnitIsDeadOrGhost = wa.createCachedFunction(b.UnitIsDeadOrGhost, 2)
	b.UnitHealthMax = wa.createCachedFunction(b.UnitHealthMax, 2)
	b.UnitHealth = wa.createCachedFunction(b.UnitHealth, 2)
	b.ObjectIsUnit = wa.createCachedFunction(b.ObjectIsUnit, 2)
	b.ObjectID = wa.createCachedFunction(b.ObjectID, 2)
	b.UnitName = wa.createCachedFunction(b.UnitName, 2)
	b.ObjectName = wa.createCachedFunction(b.ObjectName, 2)
	b.UnitIsPlayer = wa.createCachedFunction(b.UnitIsPlayer, 2)
	b.UnitAffectingCombat = wa.createCachedFunction(b.UnitAffectingCombat, 2)
	b.UnitTarget = wa.createCachedFunction(b.UnitTarget, 2)
	b.UnitCombatReach = wa.createCachedFunction(b.UnitCombatReach, 2, true)
	b.UnitBoundingRadius = wa.createCachedFunction(b.UnitBoundingRadius, 2, true)
	b.UnitPhaseReason = wa.createCachedFunction(b.UnitPhaseReason, 2, true)
	b.UnitCreator = wa.createCachedFunction(b.UnitCreator, 2, true)
	
	b.UnitCastingInfo = wa.createCachedFunction(b.UnitCastingInfo, 3)
	b.UnitChannelInfo = wa.createCachedFunction(b.UnitChannelInfo, 3)
	b.UnitCastID = wa.createCachedFunction(b.UnitCastID, 3)	
	
	b.UnitIsUnit = function(unit1, unit2)
		return b.UnitGUID(unit1) == b.UnitGUID(unit2)
	end
	br.unlocker = "WA"
	return true
end