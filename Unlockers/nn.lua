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
	"GetComboPoints",
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
	"GetRaidTargetIndex",
	"GetReadyCheckStatus",
	"GetUnitName",
	"GetUnitSpeed",
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
	"UnitIsTapDenied",
	"UnitIsTrivial",
	"UnitIsUnit",
	"UnitIsVisible",
	"UnitLevel",
	"UnitName",
	"UnitOnTaxi",
	-- "UnitPhaseReason",
	-- "UnitInPhase", -- Not Provided in Build 66709; fallback handled in Expansions/Retail/Functions.lua
	"UnitPlayerControlled",
	"UnitPlayerOrPetInParty",
	"UnitPlayerOrPetInRaid",
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
	"UnitTarget",
	"UnitUsingVehicle",
	"UnitXP",
	"UnitXPMax",
	"UseInventoryItem",
	-- "WorldToScreen",
	"WriteFile"
}


--------------------------------------------------------------------------------------------------------------------------------
-- functions exported to BadRotations
--------------------------------------------------------------------------------------------------------------------------------
local Nn, br = ...
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
function br.unlockers:NNUnlock()
	if not C_Timer.Nn then return false end
	setfenv(1, C_Timer.Nn)
	-- print("NN Api Loaded")

	--------------------------------
	-- secret unwrap helpers
	--------------------------------
	local issecretvalue = issecretvalue
	local secretunwrap  = secretunwrap

	-- Unwrap each return value if it is a secret-wrapped scalar.
	-- Safe no-op when secrets are not present (classic/non-midnight envs).
	local function unwrap(...)
		if not issecretvalue then return ... end
		local n = select('#', ...)
		local t = {...}
		for i = 1, n do
			if issecretvalue(t[i]) then
				t[i] = secretunwrap(t[i])
			end
		end
		return unpack(t, 1, n)
	end

	-- Unwrap every field of a returned table in-place.
	local function UnwrapTable(t)
		if not issecretvalue or type(t) ~= "table" then return t end
		for k, v in pairs(t) do
			if issecretvalue(v) then
				t[k] = secretunwrap(v)
			end
		end
		return t
	end

	-- Aura-specific table unwrap. Uses spellId as a cheap early-exit guard
	-- so non-secret aura tables (vanilla/non-midnight builds) are untouched.
	local function UnwrapAuraTable(t)
		if not t then return end
		if not issecretvalue or not issecretvalue(t.spellId) then return t end
		for k, v in pairs(t) do
			t[k] = secretunwrap(v)
		end
		if t.points and t.points[1] then
			t.points = {secretunwrap(unpack(t.points))}
		end
		return t
	end

	--------------------------------
	-- API unlocking
	--------------------------------
	---
	for k, v in pairs(funcCopies) do
		b[k] = function(...) return Unlock(k, ...) end
	end

	for _, v in pairs(globalCacheList) do
		if C_Timer.Nn[v] == nil then
			print("Function: " .. tostring(v) .. ", was not provided.")
		else
			local fn = C_Timer.Nn[v]
			b[v] = function(...) return unwrap(fn(...)) end
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
	-- C_Spell proxy: intercepts all method calls and unwraps any secret-wrapped
	-- return values. Table returns have fields unwrapped via UnwrapTable; scalar
	-- returns have each value unwrapped via unwrap(). Method wrappers are cached
	-- on the proxy with rawset so they are only built once per method name.
	if C_Spell then
		local _NN_C_Spell = C_Spell
		b.C_Spell = setmetatable({}, {
			__index = function(t, k)
				local fn = _NN_C_Spell[k]
				if type(fn) ~= "function" then return fn end
				local wrapper = function(...)
					local result = fn(...)
					if type(result) == "table" then
						return UnwrapTable(result)
					end
					return unwrap(result)
				end
				rawset(t, k, wrapper)
				return wrapper
			end
		})
	end
	-- b.DirectoryExists = DirectoryExists
	b.ClickPosition = ClickPosition
	b.GetKeyState = GetKeyState
	b.ObjectName = ObjectName
	b.ObjectPosition = ObjectPosition
	b.UnitMovementFlags = UnitMovementFlag
	b.ObjectFacing = ObjectFacing
	b.ObjectExists = ObjectExists
	b.GetCameraPosition = GetCameraPosition
	b.UnitFacing = UnitFacing
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
		-- Call Objects() exactly once: the snapshot used for GetObjectWithIndex must match
		-- the count returned, otherwise index overruns return nil under heavy load.
		local objects = Objects()
		om = objects
		return #objects
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
		local files = ListFiles(filter) or {}
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
		return Object(...)
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
	b.UnitAura = function(unit, index, filter)
		return UnwrapAuraTable(C_UnitAuras.GetAuraDataByIndex(ObjectUnit(unit), index, filter))
	end

	b.UnitBuff = function(unit, index, filter)
		return UnwrapAuraTable(C_UnitAuras.GetBuffDataByIndex(ObjectUnit(unit), index, filter))
	end

	b.UnitDebuff = function(unit, index, filter)
		return UnwrapAuraTable(C_UnitAuras.GetDebuffDataByIndex(ObjectUnit(unit), index, filter))
	end

	-- Proxy C_UnitAuras so that index-based aura lookups apply ObjectUnit conversion and
	-- UnwrapAuraTable, matching UnitAura/UnitBuff/UnitDebuff above. All other C_UnitAuras
	-- methods pass through to the real namespace unchanged.
	b.C_UnitAuras = setmetatable({
		GetAuraDataByIndex = function(unit, index, filter)
			return UnwrapAuraTable(C_UnitAuras.GetAuraDataByIndex(ObjectUnit(unit), index, filter))
		end,
		GetBuffDataByIndex = function(unit, index, filter)
			return UnwrapAuraTable(C_UnitAuras.GetBuffDataByIndex(ObjectUnit(unit), index, filter))
		end,
		GetDebuffDataByIndex = function(unit, index, filter)
			return UnwrapAuraTable(C_UnitAuras.GetDebuffDataByIndex(ObjectUnit(unit), index, filter))
		end,
	}, { __index = C_UnitAuras })

	b.CombatLogGetCurrentEventInfo = function()
		return unwrap(CombatLogGetCurrentEventInfo())
	end

	--------------------------------
	-- extra APIs
	--------------------------------
	b.GetMapId = function()
		return select(8, b.GetInstanceInfo())
	end
	-- b.WorldToScreen = Nn.WorldToScreen

	--------------------------------
	-- missing APIs
	--------------------------------
	b.IsQuestObject = function(obj)
		return false
	end

	br.unlockers.selected = "NN"
	b.print("NN Unlocker Loaded")
	return true
end
