local _, br = ...
local b = br._G
local unlock = br.unlock
local CurrentTable, OldTable
local function copyTable(datatable)
	local tblRes = {}
	if type(datatable) == "table" then
		for k, v in pairs(datatable) do
			tblRes[copyTable(k)] = copyTable(v)
		end
	else
		tblRes = datatable
	end
	return tblRes
end

local TagHandlerList = {
	"IsSpellInRange",
	"IsItemInRange",
	"UnitInRange",
	"br.isCritter",
	"UnitAura",
	"UnitAuraSlots",
	"UnitPlayerControlled",
	"UnitIsVisible",
	"GetUnitSpeed",
	"UnitClass",
	"UnitIsTappedByPlayer",
	"UnitThreatSituation",
	"UnitCanAttack",
	"UnitCreatureType",
	"UnitIsDeadOrGhost",
	"UnitDetailedThreatSituation",
	"UnitIsUnit",
	"UnitHealthMax",
	"UnitAffectingCombat",
	"UnitIsPlayer",
	"UnitIsDead",
	"UnitInParty",
	"UnitInRaid",
	"UnitHealth",
	"UnitCastingInfo",
	"UnitChannelInfo",
	"UnitName",
	"UnitBuff",
	"UnitDebuff",
	-- "CanLootUnit",
	"UnitIsFriend",
	"UnitClassification",
	"UnitReaction",
	"UnitGroupRolesAssigned",
	-- "SetPortraitTexture",
	"UnitXPMax",
	"UnitXP",
	-- "UnitUsingVehicle",
	"UnitStat",
	-- "UnitSex",
	-- "UnitSelectionColor",
	"UnitPhaseReason",
	"UnitResistance",
	"UnitRangedDamage",
	"UnitRangedAttackPower",
	"UnitRangedAttack",
	"UnitRace",
	"UnitPowerType",
	"UnitPowerMax",
	"UnitPower",
	"UnitPVPName",
	"UnitPlayerOrPetInRaid",
	"UnitPlayerOrPetInParty",
	"UnitManaMax",
	"UnitMana",
	"UnitLevel",
	"UnitIsTrivial",
	"UnitIsTapped",
	"UnitIsSameServer",
	"UnitIsPossessed",
	-- "UnitIsPVPSanctuary",
	-- "UnitIsPVPFreeForAll",
	"UnitIsPVP",
	"UnitIsGhost",
	"UnitIsFeignDeath",
	"UnitIsEnemy",
	"UnitIsDND",
	"UnitIsCorpse",
	"UnitIsConnected",
	"UnitIsCharmed",
	-- "UnitIsAFK",
	-- "UnitIsInMyGuild",
	"UnitInBattleground",
	-- "GetPlayerInfoByGUID",
	-- "UnitDefense",
	"UnitDamage",
	"UnitCreatureFamily",
	"UnitCanCooperate",
	"UnitCanAssist",
	"UnitAttackSpeed",
	"UnitAttackPower",
	"UnitAttackBothHands",
	"UnitArmor",
	-- "InviteUnit",
	"GetUnitPitch",
	-- "GetUnitName",
	"FollowUnit",
	"CheckInteractDistance",
	"InitiateTrade",
	"UnitOnTaxi",
	"AssistUnit",
	"SpellTargetUnit",
	"CopyToClipboard",
	"SpellTargetItem",
	"SpellCanTargetUnit",
	-- "CombatTextSetActiveUnit",
	-- "SummonFriend",
	-- "CanSummonFriend",
	-- "GrantLevel",
	-- "CanGrantLevel",
	"SetRaidTarget",
	-- "GetReadyCheckStatus",
	"GetRaidTargetIndex",
	-- "GetPartyAssignment",
	-- "DemoteAssistant",
	-- "PromoteToAssistant",
	"IsUnitOnQuest",
	"DropItemOnUnit",
	"GetDefaultLanguage",
	"GetCritChanceFromAgility",
	"GetSpellCritChanceFromIntellect",
	"UnitGetTotalHealAbsorbs",
	"UnitGetIncomingHeals",
	"CastSpellByName",
	"CastSpellByID",
	"UseItemByName",
	"SpellIsTargeting",
	"InteractUnit",
	-- "CancelUnitBuff",
	"TargetUnit",
	"UnitGUID",
	"UnitExists"
}
local UnlockList = {
	"ToggleGameMenu",
	"RunMacroText",
	"UseInventoryItem",
	"SpellStopCasting",
	"CameraOrSelectOrMoveStart",
	"CameraOrSelectOrMoveStop",
	"CancelShapeshiftForm",
	"PetAssistMode",
	"PetPassiveMode",
	"SpellStopTargeting",
	"AscendStop",
	"JumpOrAscendStart",
	"JumpOrAscendStop",
	"MoveBackwardStart",
	"MoveBackwardStop",
	"MoveForwardStart",
	"StrafeLeftStart",
	"StrafeLeftStop",
	"StrafeRightStart",
	"StrafeRightStop",
	"TurnLeftStart",
	"TurnLeftStop",
	"TurnRightStart",
	"TurnRightStop",
	"PitchUpStart",
	"PitchDownStart",
	"PitchDownStop",
	"ClearTarget",
	"AcceptProposal",
	"CastPetAction",
	"CastShapeshiftForm",
	"CastSpell",
	"ChangeActionBarPage",
	"ClearOverrideBindings",
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
	"Logout",
	"PetAttack",
	"PetDefensiveAssistMode",
	"PetDefensiveMode",
	"PetFollow",
	"PetStopAttack",
	"PetWait",
	"PickupAction",
	"PickupCompanion",
	"PickupMacro",
	"PickupPetAction",
	"PickupSpell",
	"PickupSpellBookItem",
	"Quit",
	"Region_GetBottom",
	"Region_GetCenter",
	"Region_GetPoint",
	"Region_GetRect",
	"Region_Hide",
	"Region_SetPoint",
	"Region_Show",
	"RegisterForSave",
	"ReplaceEnchant",
	"ReplaceTradeEnchant",
	"RunMacro",
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
	-- "Stuck",
	-- "SwapRaidSubgroup",
	"TargetLastEnemy",
	"TargetLastTarget",
	"TargetNearestEnemy",
	"TargetNearestFriend",
	-- "ToggleAutoRun",
	-- "ToggleRun",
	"TurnOrActionStart",
	"TurnOrActionStop",
	-- "UIObject_SetForbidden",
	-- "UninviteUnit",
	"UseAction",
	-- "UseContainerItem",
	"UseToy",
	"UseToyByName",
	-- "AcceptBattlefieldPort",
	"AcceptTrade",
	"AttackTarget",
	-- "CancelItemTempEnchantment",
	"CancelLogout",
	"StartAttack"
}
function unlock.LBUnlock()
	local unlocked = false
	local lb = _G.__LB__
	for _, val in ipairs(TagHandlerList) do
		for _, rot in ipairs(UnlockList) do
			if val == rot then
				print(rot)
			end
		end
	end
	local function lbUnlock(method)
		b[method] = function(...)
			return lb.Unlock(_G[method], ...)
		end
	end
	local function lbUnitTagHandler(method)
		b[method] = function(...)
			return lb.UnitTagHandler(lb.Unlock, _G[method], ...)
		end
	end
	for _, method in ipairs(TagHandlerList) do
		lbUnitTagHandler(method)
	end
	for _, method in ipairs(UnlockList) do
		lbUnlock(method)
	end
	b.GetCameraPosition = function(...) return lb.GetCameraPosition(...) end
	b.AuraUtil = {}
	b.AuraUtil.FindAuraByName = function(...)
		return lb.UnitTagHandler(lb.Unlock, _G.AuraUtil["FindAuraByName"], ...)
	end
	b.ObjectPointer = b.UnitGUID --compatibility change as LB returns GUIDs instead of Pointers in their OM
	b.ObjectPosition = function(...)
		return lb.ObjectPosition(...)
	end
	b.ObjectGUID = br._G.UnitGUID
	b.ObjectIsUnit = function(...)
		local ObjType = lb.ObjectType(...)
		return ObjType == 5 or ObjType == 6 or ObjType == 7
	end
	b.ObjectIsGameObject = function(...)
		local ObjType = lb.ObjectType(...)
		return ObjType == 8 or ObjType == 11
	end
	b.ObjectID = function(...)
		return lb.ObjectId(...)
	end
	b.UnitMovementFlags = function(...)
		return lb.UnitMovementFlags(...)
	end
	b.TraceLine = function(...)
		return lb.Raycast(...)
	end
	b.UnitTarget = lb.UnitTarget
	b.IsQuestObject = function(obj)
		return false, false
	end
	b.UnitCastID = function(...)
		local CastSpellID, CastTargetGUID, timeLeft, NotInterruptible = lb.UnitCastingInfo(...)
		local ChannelSpellID, ChannelTargetGUID, timeLeft, NotInterruptible = lb.UnitChannelInfo(...)
		return CastSpellID, ChannelSpellID, CastTargetGUID, ChannelTargetGUID
	end
	b.GetWoWDirectory = lb.GetGameDirectory
	b.CreateDirectory = lb.CreateDirectory
	b.GetDirectoryFiles = lb.GetFiles
	b.GetKeyState = lb.GetKeyState
	b.WorldToScreen = function(wX, wY, wZ)
		local ResolutionCoef = _G.WorldFrame:GetWidth() / lb.GetWindowSize()
		local sX, sY = lb.WorldToScreen(wX, wY, wZ)
		if sX and sY then
			return sX * ResolutionCoef, -sY * ResolutionCoef
		else
			return sX, sY
		end
	end
	b.ScreenToWorld = function()
		return 0, 0
	end
	b.GetDistanceBetweenPositions = function(X1, Y1, Z1, X2, Y2, Z2)
		return math.sqrt(math.pow(X2 - X1, 2) + math.pow(Y2 - Y1, 2) + math.pow(Z2 - Z1, 2))
	end

	b.GetAnglesBetweenObjects = function(Object1, Object2)
		local X1, Y1, Z1 = br._G.ObjectPosition(Object1)
		local X2, Y2, Z2 = br._G.ObjectPosition(Object2)
		-- print(Unit1,X1,Y1,Z1,unit2,X2,Y2,Z2)
		return math.atan2(Y2 - Y1, X2 - X1) % (math.pi * 2), math.atan((Z1 - Z2) / math.sqrt(math.pow(X1 - X2, 2) + math.pow(Y1 - Y2, 2))) % math.pi
	end

	b.GetAnglesBetweenPositions = function(X1, Y1, Z1, X2, Y2, Z2)
		return math.atan2(Y2 - Y1, X2 - X1) % (math.pi * 2), math.atan((Z1 - Z2) / math.sqrt(math.pow(X1 - X2, 2) + math.pow(Y1 - Y2, 2))) % math.pi
	end

	b.GetPositionFromPosition = function(X, Y, Z, Distance, AngleXY, AngleXYZ)
		return math.cos(AngleXY) * Distance + X, math.sin(AngleXY) * Distance + Y, math.sin(AngleXYZ) * Distance + Z
	end

	b.GetPositionBetweenPositions = function(X1, Y1, Z1, X2, Y2, Z2, DistanceFromPosition1)
		local AngleXY, AngleXYZ = b.GetAnglesBetweenPositions(X1, Y1, Z1, X2, Y2, Z2)
		return b.GetPositionFromPosition(X1, Y1, Z1, DistanceFromPosition1, AngleXY, AngleXYZ)
	end

	b.GetPositionBetweenObjects = function(unit1, unit2, DistanceFromPosition1)
		local X1, Y1, Z1 = br._G.ObjectPosition(unit1)

		local X2, Y2, Z2 = br._G.ObjectPosition(unit2)
		local AngleXY, AngleXYZ = b.GetAnglesBetweenPositions(X1, Y1, Z1, X2, Y2, Z2)
		return b.GetPositionFromPosition(X1, Y1, Z1, DistanceFromPosition1, AngleXY, AngleXYZ)
	end
	b.ObjectFacing = lb.ObjectFacing
	b.FaceDirection = function(arg)
		if type(arg) == "number" then
			lb.SetPlayerAngles(arg)
		else
			arg = b.GetAnglesBetweenObjects("player", arg)
			lb.SetPlayerAngles(arg)
		end
	end
	b.ObjectIsFacing = function(obj1, obj2, degrees)
		local Facing = lb.ObjectFacing(obj1)
		local AngleToUnit = b.GetAnglesBetweenObjects(obj1, obj2)
		local AngleDifference = Facing > AngleToUnit and Facing - AngleToUnit or AngleToUnit - Facing
		local ShortestAngle = AngleDifference < math.pi and AngleDifference or math.pi * 2 - AngleDifference
		degrees = degrees and br._G.rad(degrees) / 2 or math.pi / 2
		return ShortestAngle < degrees
	end
	-- br.getFacing = ObjectFacingObject
	b.UnitCreator = lb.ObjectCreator
	b.ObjectName = lb.ObjectName
	b.GetDistanceBetweenObjects = function(...) return lb.GetDistance3D(...) end
	b.GetMapId = lb.GetMapId
	b.UnitIsMounted = function(...)
		return lb.UnitHasFlag(..., lb.EUnitFlags.Mount)
	end
	b.SendMovementUpdate = lb.UpdatePlayerMovement

	b.ObjectDynamicFlags = lb.ObjectDynamicFlags

	b.IsHackEnabled = function(...)
		--print(...)
		return false
	end
	b.UnitCombatReach = lb.UnitCombatReach
	b.ReadFile = lb.ReadFile
	b.DirectoryExists = lb.DirectoryExists
	b.WriteFile = function(...)
		return lb.WriteFile(...)
	end
	-- local addedOM,removedOM = {}, {}
	b.GetObjectCount = function()
		if not OldTable and not CurrentTable then
			CurrentTable = lb.GetObjects()
			return #CurrentTable, true, CurrentTable, {}
		else
			OldTable = CurrentTable
			CurrentTable = lb.GetObjects()
			local TempTable = copyTable(CurrentTable)
			local TempTableOld = copyTable(OldTable)
			for i = #TempTableOld, 1, -1 do
				for k = #TempTable, 1, -1 do
					if TempTableOld[i] == TempTable[k] then
						table.remove(TempTable, k)
						table.remove(TempTableOld, i)
						break
					end
				end
			end
			return #CurrentTable, true, TempTable, TempTableOld
		end
	end
	b.GetObjectWithIndex = function(...)
		return CurrentTable[...]
	end
	b.GetObjectWithGUID = function(...)
		return ...
	end
	b.GetMousePosition = function()
		local cur_x, cur_y = br._G.GetCursorPosition()
		return cur_x, cur_y
	end
	b.ObjectIsVisible = lb.ObjectExists
	b.ObjectExists = lb.ObjectExists
	-- br.GetUnitIsVisible = lb.ObjectExists
	b.IsAoEPending = lb.IsAoEPending
	b.ClickPosition = lb.ClickPosition
	b.UnitBoundingRadius = lb.UnitBoundingRadius
	b.CancelPendingSpell = lb.CancelPendingSpells
	unlocked = true
	return unlocked
end
