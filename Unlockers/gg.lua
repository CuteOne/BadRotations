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
	"GetCursorPosition",
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
	"Reload",
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
local funcCopies = {}
local ggUnlocked = false
local gg = {}

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

for i = 1, #unlockList do
	local func = unlockList[i]
	funcCopies[func] = _G[func]
end


function unlock.GGUnlock()
	if not ggUnlocked then
		if _G["GetExeDirectory"] == nil then return false end
		RunScript(ReadFile(GetExeDirectory().."\\api.lua"))
		if GetWowDirectory() ~= nil then
			-- b.print("Unlocked")
			ggUnlocked = true
			CreateApiReferences(gg)
			for k, v in pairs(gg) do
				b[k] = v
			end
		else
			-- b.print("Unlock Failed")
			return false
		end
	end
	--------------------------------
	-- API unlocking
	--------------------------------
	for k, v in pairs(funcCopies) do
		b[k] = function(...) return b.Unlock(v, ...) end
	end

	b.AuraUtil = {}
	local Aura = {}
	b.AuraUtil.FindAuraByName = function(...)
		if Aura ~= nil then table.wipe(Aura) end
		local spellName, unit, filter = ...
		if filter ~= nil then
			if _G.strfind(_G.strupper(filter), "HELPFUL") then
				for i = 1, 40 do
					local buffName, _, _, _, _, _, _, _, _, buffSpellID = b.UnitBuff(unit, i, "player")
					if buffName == nil then	return nil end
					-- if buffSpellID == spellID then
					if buffName == spellName then
						return Aura
					end
				end
			else
				for i = 1, 40 do
					local buffName, _, _, _, _, _, _, _, _, buffSpellID = b.UnitDebuff(unit, i, "player")
					if buffName == nil then	return nil end
					-- if buffSpellID == spellID then
					if buffName == spellName then
						return Aura
					end
				end
			end
		end
		return nil
	end

	local FieldType =
	{
		["Bool"] = 1,
		["Char"] = 2,
		["Byte"] = 3,
		["Short"] = 4,
		["UShort"] = 5,
		["Int"] = 6,
		["UInt"] = 7,
		["Long"] = 8,
		["ULong"] = 9,
		["Float"] = 10,
		["Double"] = 11,
		["StringType"] = 12,
		["IntPtr"] = 13,
		["UIntPtr"] = 14,
		["GUID"] = 15,
	}

	--------------------------------
	-- API copy/rename/unlock
	--------------------------------
	b.GetWoWDirectory = function(...) return b.GetWowDirectory(...) end
	b.ObjectFacing = function(...) return b.UnitFacing(...) end
	b.UnitMovementFlags = function(...) return b.GetUnitMovementFlags(...) end
	b.CancelPendingSpell = function(...) return b.SpellStopTargeting(...) end
	b.GetMousePosition = function(...) return b.GetCursorPosition(...) end
	b.IsAoEPending = function(...) return b.SpellIsTargeting(...) end
	b.ObjectInteract = function(...) return b.InteractUnit(...) end
	b.ObjectIsVisible = function(...) return b.UnitIsVisible(...) end

	--------------------------------
	-- object fields
	--------------------------------
	b.UnitTarget = function(unit)
		return b.ObjectField(unit, 0x9C, FieldType.GUID) --b.ObjectField(unit, 0x1748, 15)
	end
	b.UnitCreator = function(unit)
		return b.ObjectField(unit, 0x6C, FieldType.GUID) --b.ObjectField(unit, 0x1718, 15)
	end
	b.UnitBoundingRadius = function(unit)
		return b.ObjectField(unit, 0x19C, FieldType.Float) --b.ObjectField(unit, 0x17DC, 10)
	end
	b.UnitCombatReach = function(unit)
		return b.ObjectField(unit, 0x1A0, FieldType.Float) --b.ObjectField(unit, 0x17E0, 10)
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
		local ObjType = b.ObjectType(...)
		return ObjType == 5
	end
	b.ObjectID = function(object)
		return b.ObjectField(object, 0x10, FieldType.Int)
		-- local guid = b.UnitGUID(object)
		-- if guid then
		-- 	local _, _, _, _, _, objectId, _ = strsplit("-", guid);
		-- 	return tonumber(objectId);
		-- else
		-- 	return 0
		-- end
	end
	b.TraceLine = function(...)
		local hit, hitx, hity, hitz = gg.TraceLine(...)
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
		local files = gg.GetDirectoryFiles(filter[1], "*.lua")
		return stringsplit(files, "|")
	end
	b.WorldToScreen = function(...)
		-- local multiplier = UIParent:GetScale()
		-- local sX, sY = gg.WorldToScreen(...)
		-- return sX * multiplier, -sY * multiplier
		local scale, x, y = UIParent:GetEffectiveScale(), gg.WorldToScreen(...)
        local sx = GetScreenWidth() * scale
        local sy = GetScreenHeight() * scale
        return x * sx, y * sy
	end
	b.FaceDirection = function(arg)
		if type(arg) == "number" then
			gg.FaceDirection(arg)
		else
			arg = b.GetAnglesBetweenObjects("player", arg)
			gg.FaceDirection(arg)
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
	b.ObjectIsGameObject = function(...)
		local ObjType = b.ObjectType(...)
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
	b.UnitIsUnit = function(unit1, unit2)
		return b.UnitGUID(unit1) == b.UnitGUID(unit2)
	end
	br.unlocker = "GG"
	return true
end