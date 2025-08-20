-- req.saved.disableAutoTargeting = true
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
	"FaceObject",
	"FocusUnit",
	"FollowUnit",
	"ForceQuit",
	"GetDefaultLanguage",
	"GetPartyAssignment",
	"GetPlayerInfoByGUID",
	-- "GetRaidTargetIndex",
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
	-- "InteractUnit",
	"IsItemInRange",
	-- "C_Spell.IsSpellInRange",
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
	"C_Spell.PickupSpell",
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
	-- "TargetUnit",
	"ToggleAutoRun",
	"ToggleGameMenu",
	"ToggleRun",
	"C_Spell.ToggleSpellAutoCast",
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
	-- "UnitIsCharmed",
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
	-- "UseItemByName",
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
			br._G.print("Tinkr Unlocker Detected")
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
				return Eval(k .. "()", "")
			else
				return Eval(k .. "(" .. table.concat({ ... }, ", ") .. ")", "")
			end
		end
	end

	-------------------
	-- API Wrapping ---
	-------------------
	------------------------- Active Player -------------------
	b.FaceDirection = function(arg)
		if type(arg) == "number" then
			SetHeading(arg)
		else
			arg = b.GetAnglesBetweenObjects("player", arg)
			SetHeading(arg)
		end
	end

	b.GetMapId = GetMapID
	------------------------- Object --------------------------
	b.Object = function(...) return Object(...) end
	b.ObjectPointer = function(...) return Object(...) end
	b.ObjectExists = function(...) return Object(...) ~= nil end
	b.ObjectIsVisible = function(...) return Object(...) ~= nil end
	b.ObjectPosition = function(...)
		if ObjectMover(...) then return ObjectWorldPosition(...) end
		return ObjectPosition(...)
	end
	b.ObjectRawPosition = ObjectRawPosition
	b.MoveToRaw = MoveToRaw
	b.ObjectFacing = function(...)
		if ObjectMover(...) then return ObjectRawRotation(...) end
		return ObjectRotation(...)
	end
	b.ObjectGUID = function(...) return ObjectGUID(Object(...)) end
	b.ObjectName = function(...) return ObjectName(Object(...)) end
	b.ObjectID = function(...) return ObjectID(...) end
	b.ObjectType = function(...) return ObjectType(Object(...)) end
	b.ObjectRawType = function(...) return GameObjectType(Object(...)) end
	b.ObjectIsUnit = function(...)
		local ObjType = ObjectType(...)
		return ObjType == 5
	end
	b.GetDistanceBetweenPositions = function(X1, Y1, Z1, X2, Y2, Z2)
		--return math.sqrt(math.pow(X2 - X1, 2) + math.pow(Y2 - Y1, 2) + math.pow(Z2 - Z1, 2))
		return FastDistance(X1, Y1, Z1, X2, Y2, Z2)
	end
	b.GetAnglesBetweenObjects = function(Object1, Object2)
		Object1 = Object(Object1)
		Object2 = Object(Object2)
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
		unit1 = Object(unit1)
		unit2 = Object(unit2)
		local X1, Y1, Z1 = b.ObjectPosition(unit1)
		local X2, Y2, Z2 = b.ObjectPosition(unit2)
		if not X1 or not X2 then return end
		local AngleXY, AngleXYZ = b.GetAnglesBetweenPositions(X1, Y1, Z1, X2, Y2, Z2)
		return b.GetPositionFromPosition(X1, Y1, Z1, DistanceFromPosition1, AngleXY, AngleXYZ)
	end
	b.GetDistanceBetweenObjects = function(unit1, unit2)
		-- local X1, Y1, Z1 = b.ObjectPosition(unit1)
		-- local X2, Y2, Z2 = b.ObjectPosition(unit2)
		-- return math.sqrt((X2-X1)^2 + (Y2-Y1)^2 + (Z2-Z1)^2)
		unit1 = Object(unit1)
		unit2 = Object(unit2)
		return ObjectDistance(unit1, unit2)
	end
	b.ObjectIsFacing = function(obj1, obj2, degrees)
		obj1 = Object(obj1)
		obj2 = Object(obj2)
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
		return tostring(om[index])
	end
	b.GetObjectWithGUID = function(...)
		return Object(...)
	end
	------------------------- Unit ------------------
	b.UnitCreator = function(...) return ObjectCreator(Object(...)) end
	b.UnitMovementFlags = function(...) return ObjectMovementFlag(Object(...)) end
	b.UnitBoundingRadius = function(...) return ObjectBoundingRadius(Object(...)) end
	b.UnitCombatReach = function(...) return ObjectCombatReach(Object(...)) end
	b.UnitTarget = function(...) return ObjectCastingTarget(Object(...)) end
	b.UnitCastID = function(...) return ObjectCastingInfo(Object(...)) end
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
	-- b.AuraUtil = {}
	-- b.AuraUtil.FindAuraByName = function(name, unit, filter)
	-- 	-- return Eval("AuraUtil.FindAuraByName("..table.concat({...}, ", ")..")", "")
	-- 	return AuraUtil.FindAuraByName(name, Object(unit), filter)
	-- end
	b.ObjectIsGameObject = function(...)
		local ObjType = ObjectType(...)
		return ObjType == 8 or ObjType == 11
	end
	b.RunMacroText = function(text)
		return Eval("RunMacroText(\"" .. text .. "\")", "")
	end
	b.UseItemByName = function(text)
		return Eval("UseItemByName(\"" .. text .. "\")", "")
	end
	b.TargetUnit = function(unit)
		if Object(unit) then
			print("TargetUnit: Passed " .. tostring(unit) .. " with object ref " .. tostring(Object(unit)))
			return TargetUnit(Object(unit))
		else
			return nil
		end
	end
	b.InteractUnit = function(unit)
		if Object(unit) then
			return InteractUnit(Object(unit))
		else
			return
		end
	end
	------------------------------------------
	--- API - Unit Function Object Handler ---
	------------------------------------------
	-- b.CastSpellByName = function(spell, unit)
	-- 	-- return Eval("CastSpellByName(\"" .. spell .. "\", \"" .. Object(unit) .. "\")", "")
	-- 	return CastSpellByName(spell, Object(unit))
	-- end
	-- b.GetRaidTargetIndex = function(...)
	-- 	return GetRaidTargetIndex(Object(...))
	-- end
	-- b.GetUnitSpeed = function(...)
	-- 	return GetUnitSpeed(Object(...))
	-- end
	-- b.C_Spell.IsSpellInRange = function(spell, unit)
	-- 	if Object(unit) then
	-- 		return C_Spell.IsSpellInRange(spell, Object(unit))
	-- 	else
	-- 		return false
	-- 	end
	-- end
	-- b.UnitAffectingCombat = function(...)
	-- 	return UnitAffectingCombat(Object(...))
	-- end
	-- b.UnitAttackSpeed = function(...)
	-- 	return UnitAttackSpeed(Object(...))
	-- end
	-- -- b.UnitAura = function(unit, index, filter)
	-- -- 	local unpack = unpack
	-- -- 	local function UnpackAuraData(auraData)
	-- -- 		if not auraData then
	-- -- 			return nil
	-- -- 		end
	-- -- 		return auraData.name,
	-- -- 			auraData.icon,
	-- -- 			auraData.applications,
	-- -- 			auraData.dispelName,
	-- -- 			auraData.duration,
	-- -- 			auraData.expirationTime,
	-- -- 			auraData.sourceUnit,
	-- -- 			auraData.isStealable,
	-- -- 			auraData.nameplateShowPersonal,
	-- -- 			auraData.spellId,
	-- -- 			auraData.canApplyAura,
	-- -- 			auraData.isBossAura,
	-- -- 			auraData.isFromPlayerOrPlayerPet,
	-- -- 			auraData.nameplateShowAll,
	-- -- 			auraData.timeMod,
	-- -- 			unpack(auraData.points)
	-- -- 	end
	-- -- 	local GetAuraDataByIndex = C_UnitAuras.GetAuraDataByIndex
	-- -- 	local auraData = GetAuraDataByIndex(Object(unit), index, filter)
	-- -- 	if not auraData then return nil end
	-- -- 	return UnpackAuraData(auraData)
	-- -- 	-- return UnitAura(Object(unit), index, filter)
	-- -- end
	-- b.UnitBuff = function(unit, index, filter)
	-- 	return UnitBuff(Object(unit), index, filter)
	-- end
	-- b.UnitCanAttack = function(unit1, unit2)
	-- 	return UnitCanAttack(Object(unit1), Object(unit2))
	-- end
	-- b.UnitCastingInfo = function(...)
	-- 	return UnitCastingInfo(Object(...))
	-- end
	-- b.UnitChannelInfo = function(...)
	-- 	return UnitChannelInfo(Object(...))
	-- end
	-- b.UnitClass = function(...)
	-- 	return UnitClass(Object(...))
	-- end
	-- b.UnitClassification = function(...)
	-- 	return UnitClassification(Object(...))
	-- end
	-- b.UnitCreatureFamily = function(...)
	-- 	return UnitCreatureFamily(Object(...))
	-- end
	-- b.UnitCreatureType = function(...)
	-- 	return UnitCreatureType(Object(...))
	-- end
	-- b.UnitDebuff = function(unit, index, filter)
	-- 	return UnitDebuff(Object(unit), index, filter)
	-- end
	-- b.UnitExists = function(...)
	-- 	return UnitExists(Object(...))
	-- end
	-- b.UnitGetIncomingHeals = function(unit1, unit2)
	-- 	return UnitGetIncomingHeals(Object(unit1), Object(unit2))
	-- end
	-- b.UnitGUID = function(...)
	-- 	return ObjectGUID(...) --UnitGUID(Object(...))
	-- end
	-- b.UnitHealth = function(...)
	-- 	return UnitHealth(Object(...))
	-- end
	-- b.UnitHealthMax = function(...)
	-- 	return UnitHealthMax(Object(...))
	-- end
	-- b.UnitLevel = function(...)
	-- 	return UnitLevel(Object(...))
	-- end
	b.UnitName = function(...)
		if Object(...) then
			return UnitName(Object(...))
		else 
			return ""
		end
	end
	-- b.UnitInParty = function(...)
	-- 	return UnitInParty(Object(...))
	-- end
	-- b.UnitInRaid = function(...)
	-- 	return UnitInRaid(Object(...))
	-- end
	-- b.UnitInRange = function(...)
	-- 	return UnitInRange(Object(...))
	-- end
	-- b.UnitIsCharmed = function(...)
	-- 	return UnitIsCharmed(Object(...))
	-- end
	-- b.UnitIsConnected = function(...)
	-- 	return UnitIsConnected(Object(...))
	-- end
	-- b.UnitIsDeadOrGhost = function(...)
	-- 	return UnitIsDeadOrGhost(Object(...))
	-- end
	-- b.UnitIsEnemy = function(unit1, unit2)
	-- 	return UnitIsEnemy(Object(unit1), Object(unit2))
	-- end
	-- b.UnitIsFriend = function(unit1, unit2)
	-- 	return UnitIsFriend(Object(unit1), Object(unit2))
	-- end
	-- b.UnitIsPlayer = function(...)
	-- 	return UnitIsPlayer(Object(...))
	-- end
	-- b.UnitIsUnit = function(unit1, unit2)
	-- 	return UnitIsUnit(Object(unit1), Object(unit2))
	-- end
	-- b.UnitIsVisible = function(...)
	-- 	return UnitIsVisible(Object(...))
	-- end
	-- b.UnitOnTaxi = function(...)
	-- 	return UnitOnTaxi(Object(...))
	-- end
	-- b.UnitPhaseReason = function(...)
	-- 	return UnitPhaseReason(Object(...))
	-- end
	-- b.UnitPower = function(unit, powerType)
	-- 	return UnitPower(Object(unit), powerType)
	-- end
	-- b.UnitPowerMax = function(unit, powerType)
	-- 	return UnitPowerMax(Object(unit), powerType)
	-- end
	-- b.UnitRace = function(...)
	-- 	return UnitRace(Object(...))
	-- end
	-- b.UnitReaction = function(unit1, unit2)
	-- 	return UnitReaction(Object(unit1), Object(unit2))
	-- end
	-- b.UnitStat = function(unit, statIndex)
	-- 	return UnitStat(Object(unit), statIndex)
	-- end
	-- b.UnitIsTapDenied = function(...)
	-- 	return UnitIsTapDenied(Object(...))
	-- end
	-- b.UnitThreatSituation = function(unit1, unit2)
	-- 	return UnitThreatSituation(Object(unit1), Object(unit2))
	-- end
	-- b.UnitIsTrivial = function(...)
	-- 	return UnitIsTrivial(Object(...))
	-- end

	br.unlocker = "Tinkr"
	return true
end
