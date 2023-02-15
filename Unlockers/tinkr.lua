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
	-- "CastSpellByName",
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
	-- "GetUnitSpeed",
	"GetUnscaledFrameRect",
	"GuildControlSetRank",
	"GuildControlSetRankFlag",
	"GuildDemote",
	"GuildPromote",
	"GuildUninvite",
	"InitiateTrade",
	"InteractUnit",
	"IsItemInRange",
	-- "IsSpellInRange",
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
	-- "RunMacroText",
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
	-- "SpellIsTargeting",
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
	-- "UnitAffectingCombat",
	"UnitArmor",
	"UnitAttackPower",
	-- "UnitAttackSpeed",
	-- "UnitAura",
	"UnitAuraSlots",
	-- "UnitBuff",
	"UnitCanAssist",
	-- "UnitCanAttack",
	"UnitCanCooperate",
	-- "UnitCastingInfo",
	-- "UnitChannelInfo",
	-- "UnitClass",
	-- "UnitClassification",
	-- "UnitCreatureFamily",
	-- "UnitCreatureType",
	"UnitDamage",
	-- "UnitDebuff",
	"UnitDetailedThreatSituation",
	-- "UnitExists",
	-- "UnitGetIncomingHeals",
	"UnitGetTotalHealAbsorbs",
	"UnitGroupRolesAssigned",
	-- "UnitGUID",
	-- "UnitHealth",
	-- "UnitHealthMax",
	"UnitInBattleground",
	-- "UnitInParty",
	-- "UnitInRaid",
	-- "UnitInRange",
	"UnitIsAFK",
	"UnitIsCharmed",
	-- "UnitIsConnected",
	"UnitIsCorpse",
	"UnitIsDead",
	-- "UnitIsDeadOrGhost",
	"UnitIsDND",
	-- "UnitIsEnemy",
	"UnitIsFeignDeath",
	-- "UnitIsFriend",
	"UnitIsGhost",
	"UnitIsInMyGuild",
	-- "UnitIsPlayer",
	"UnitIsPossessed",
	"UnitIsPVP",
	"UnitIsPVPFreeForAll",
	"UnitIsPVPSanctuary",
	"UnitIsSameServer",
	-- "UnitIsTrivial",
	-- "UnitIsVisible",
	-- "UnitLevel",
	-- "UnitName",
	-- "UnitOnTaxi",
	-- "UnitPhaseReason",
	"UnitPlayerControlled",
	"UnitPlayerOrPetInParty",
	"UnitPlayerOrPetInRaid",
	-- "UnitPower",
	-- "UnitPowerMax",
	"UnitPowerType",
	"UnitPVPName",
	-- "UnitRace",
	"UnitRangedAttackPower",
	"UnitRangedDamage",
	-- "UnitReaction",
	"UnitSelectionColor",
	"UnitSex",
	-- "UnitStat",
	-- "UnitThreatSituation",
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
local tinkrUnlocked = false
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

-- make a backup copy of all APIs before AddOns hook them
for i = 1, #unlockList do
    local func = unlockList[i]
    funcCopies[func] = func --_G[func]
end
local Unlocker = ...
local File
function unlock.TinkrUnlock()
	if not tinkrUnlocked then
        if Unlocker and Unlocker.name == "Tinkr" then
            tinkrUnlocked = true
			File = Unlocker.Util.File
        else
            return false
        end
    end

    --------------------------------
	-- API unlocking
	--------------------------------
	for k, v in pairs(funcCopies) do
		b[k] = function(...)
			if select('#', ...) == 0 then
				return Eval(k.."()", "")
			else
				return Eval(k.."("..table.concat({...}, ", ")..")", "")
			end
		end
	end

    -------------------
	-- API Wrapping ---
	-------------------
	------------------------- Active Player -------------------
	b.FaceDirection = function(arg)
		if type(arg) == "number" then
			FaceDirection(arg,true)
		else
			arg = b.GetAnglesBetweenObjects("player", arg)
			FaceDirection(arg,true)
		end
	end
	b.GetMapId = GetMapID
	------------------------- Object --------------------------
	b.ObjectPointer = Object
	b.ObjectExists = function(...) return Object(...) ~= nil end
	b.ObjectIsVisible = function(...) return Object(...) ~= nil end
	b.ObjectPosition = ObjectPosition
	b.ObjectFacing = ObjectRotation
	b.ObjectGUID = ObjectGUID
	b.ObjectName = ObjectName
	b.ObjectID = ObjectId
	b.ObjectRawType = GameObjectType
	b.ObjectIsUnit = function(...)
		local ObjType = ObjectType(...)
		return ObjType == 5
	end
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
	b.IsQuestObject = function(obj)
		return false
	end
	------------------------- Object Manager ------------------
	local om = {}
	b.GetObjectCount = function()
		table.wipe(om)
		om = Objects()
		return #Objects()
	end
	b.GetObjectWithIndex = function(index)
		return om[index]
	end
	b.GetObjectWithGUID = Object
	------------------------- Unit ------------------
	b.UnitCreator = ObjectCreator
	b.UnitMovementFlags = ObjectMovementFlag
	b.UnitBoundingRadius = ObjectBoundingRadius
	b.UnitCombatReach = ObjectCombatReach
	b.UnitTarget = ObjectTarget
	b.UnitCastID = ObjectCastingInfo
	------------------------- World ---------------------------
	b.TraceLine = TraceLine
	b.GetCameraPosition = CameraPosition
	b.CancelPendingSpell = b.SpellStopTargeting
	b.ClickPosition = Click
	b.IsAoEPending = IsSpellPending
	b.WorldToScreen = function(...)
		local multiplier = UIParent:GetScale()
		local sX, sY = Draw:WorldToScreen(...)
		return sX * multiplier, -sY * multiplier
	end
	b.ScreenToWorld = function(...)
		return Common.ScreenToWorld(...)
	end
	b.GetMousePosition = function()
		local mx, my, mz = Common.ScreenToWorld(GetCursorPosition())
		return mx, my, mz
	end
	------------------------- File ----------------------------
	b.GetDirectoryFiles = function(...)
		local filter = stringsplit(..., "*")
		local dirFiles = File:List(filter[1])
		local files = {}
		for _, file in ipairs(dirFiles) do
			--b.print(file)
			-- Find the last occurrence of "/" in the string
			local start_index = string.find(file, "/[^/]+$")

			-- If "/" is found, extract the substring after it
			if start_index then
				local extracted = string.sub(file, start_index + 1)
				table.insert(files, extracted)
			end
		end
		return files
	end
	b.ReadFile = function(...)
		return ReadFile(...)
	end
	b.WriteFile = function(...)
		return WriteFile(...)
	end
	b.CreateDirectory = function(...)
		return File:CreateDirectory(...)
	end
	b.DirectoryExists = function(...)
		return File:DirectoryExists(...)
	end
	b.GetWoWDirectory = function()
		return "scripts"
	end
	------------------------- Miscellaneous -------------------
	b.GetKeyState = GetKeyState
	b.UnitFacing = b.ObjectFacing
	b.ObjectInteract = b.InteractUnit
    b.IsHackEnabled = function(...) return false end
	b.AuraUtil = {}
	b.AuraUtil.FindAuraByName = function(name, unit, filter)
		-- return Eval("AuraUtil.FindAuraByName("..table.concat({...}, ", ")..")", "")
		return AuraUtil.FindAuraByName(name, ObjectUnit(unit), filter)
	end
	b.ObjectIsGameObject = function(...)
		local ObjType = ObjectType(...)
		return ObjType == 8 or ObjType == 11
	end
	b.RunMacroText = function(text)
		return Eval("RunMacroText(\""..text.."\")", "")
	end
	------------------------------------------
	--- API - Unit Function Object Handler ---
	------------------------------------------
	b.CastSpellByName = function(spell, unit)
		return Eval("CastSpellByName(\""..spell.."\", \""..ObjectUnit(unit).."\")", "")
	end
	b.GetUnitSpeed = function(...)
		return GetUnitSpeed(ObjectUnit(...))
	end
	b.InSpellInRange = function(spell, unit)
		return IsSpellInRange(spell, ObjectUnit(unit))
	end
	b.UnitAffectingCombat = function(...)
		return UnitAffectingCombat(ObjectUnit(...))
	end
	b.UnitAttackSpeed = function(...)
		return UnitAttackSpeed(ObjectUnit(...))
	end
	b.UnitAura = function(unit, index, filter)
		return UnitAura(ObjectUnit(unit), index, filter)
	end
	b.UnitBuff = function(unit, index, filter)
		return UnitBuff(ObjectUnit(unit), index, filter)
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
		return UnitDebuff(ObjectUnit(unit), index, filter)
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
	b.UnitReaction = function (unit1, unit2)
		return UnitReaction(ObjectUnit(unit1), ObjectUnit(unit2))
	end
	b.UnitStat = function(unit, statIndex)
		return UnitStat(ObjectUnit(unit), statIndex)
	end
	b.UnitThreatSituation = function(...)
		return UnitThreatSituation(ObjectUnit(...))
	end
	b.UnitIsTrivial = function(...)
		return UnitIsTrivial(ObjectUnit(...))
	end

    br.unlocker = "Tinkr"
	return true
end