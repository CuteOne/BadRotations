--------------------------------------------------------------------------------------------------------------------------------
-- unlockList
--------------------------------------------------------------------------------------------------------------------------------
local lockedWoWAPI =
{
	"AcceptProposal",
	"AscendStop",
	"CancelShapeshiftForm",
	"CancelUnitBuff",
	"CastShapeshiftForm",
	"CastSpell",
	"CastSpellByID",
	"CastSpellByName",
	"ClearTarget",
	"DeleteCursorItem",
	"FocusUnit",
	"GetCursorPosition",
	"InteractUnit",
	"JumpOrAscendStart",
	"Logout",
	"MoveBackwardStart",
	"MoveBackwardStop",
	-- "MoveForwardStart",
	"MoveForwardStop",
	"PetAssistMode",
	"PetAttack",
	"PetDefensiveAssistMode",
	"PetDefensiveMode",
	"PetFollow",
	"PetPassiveMode",
	"PetStopAttack",
	"PetWait",
	"Reload",
	"RunMacroText",
	"SpellStopTargeting",
	"StartAttack",
	"TargetLastEnemy",
	"TargetUnit",
	"TurnOrActionStop",
	"UseContainerItem",
	"UseInventoryItem",
	"UseItemByName",
	"UseToy",
	"UseToyByName"
}
local regularWoWAPI =
{
	"GetRaidTargetIndex",
	"GetUnitName",
	"GetUnitSpeed",
	"IsItemInRange",
	"IsSpellInRange",
	"SpellIsTargeting",
	"UnitAffectingCombat",
	"UnitArmor",
	"UnitAttackPower",
	"UnitAttackSpeed",
	"UnitAura",
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
	"UnitHealth",
	"UnitHealthMax",
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
	"UnitIsPlayer",
	"UnitIsPossessed",
	"UnitIsPVP",
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
	"UnitPowerMax",
	"UnitPowerType",
	"UnitRace",
	"UnitRangedAttackPower",
	"UnitRangedDamage",
	"UnitReaction",
	"UnitSex",
	"UnitStat",
	"UnitThreatSituation",
	"UnitUsingVehicle",
}

--------------------------------------------------------------------------------------------------------------------------------
-- functions exported to BadRotations
--------------------------------------------------------------------------------------------------------------------------------
local _, br = ...
local b = br._G
local unlock = br.unlock
local mmb = nil
local funcCopiesLocked = {}
local funcCopiesRegular = {}

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
for i = 1, #lockedWoWAPI do
	local func = lockedWoWAPI[i]
	funcCopiesLocked[func] = _G[func]
end
for i = 1, #regularWoWAPI do
	local func = regularWoWAPI[i]
	funcCopiesRegular[func] = _G[func]
end

function unlock.MMBUnlock()
	--------------------------------
	-- WoW API copy/rename/unlock
	--------------------------------
	for k, v in pairs(funcCopiesLocked) do
		--b[k] = function(...) return mmb.CallSecureFunction(v, ...) end
		local lockedFunc = function(...) return MoveForwardStart("SafeCall", k, ...) end
		b[k] = function(...) return b:CallFunctionWithGuid(lockedFunc, ...) end
	end

	for k, v in pairs(funcCopiesRegular) do
		b[k] = function(...) return b:CallFunctionWithGuid(_G[k], ...) end
	end

	b.GetMousePosition = b.GetCursorPosition
	b.CancelPendingSpell = b.SpellStopTargeting
	b.ObjectIsVisible = b.UnitIsVisible
	b.IsAoEPending = b.SpellIsTargeting
	b.ObjectInteract = b.InteractUnit

	--------------------------------
	-- Unlocker API copy/rename/unlock
	-- --------------------------------
	--b.DirectoryExists = function(...) return MoveForwardStart("DirectoryExists", ...) end
	b.GetWoWDirectory = function(...) return MoveForwardStart("GetWowDirectory", ...) end
	b.ReadFile = function(path) return MoveForwardStart("OpenAndReadFile", path) end
	b.WriteFile = function(path, content, append) return MoveForwardStart("OpenAndWriteFile", path, content, append) end
	b.ClickPosition = function(...) return MoveForwardStart("ClickPosition", ...) end
	b.CreateDirectory = function(...) return MoveForwardStart("CreateNewDirectory", ...) end
	b.GetKeyState = function(...) return MoveForwardStart("GetKeyState", ...) end
	b.ObjectName = function(...) return nil end --MoveForwardStart("ObjectName", ...) end -- Need
	b.GetObjectWithIndex = function(...) return MoveForwardStart("GetObjectWithIndex", ...) end
	b.ObjectPosition = function(...)
		local guid = string.match(...,"\-") == nil and _G["UnitGUID"](...) or ...
		return MoveForwardStart("GetUnitPosition", guid)
	end
	b.UnitMovementFlags = function(...)
		local guid = string.match(...,"\-") == nil and _G["UnitGUID"](...) or ...
		return MoveForwardStart("GetUnitMovementFlags", guid)
	end
	b.ObjectFacing = function(...)
		local guid = string.match(...,"\-") == nil and _G["UnitGUID"](...) or ...
		return MoveForwardStart("UnitFacing", guid)
	end
	b.ObjectExists = function(...)
		local guid = string.match(...,"\-") == nil and _G["UnitGUID"](...) or ...
		return MoveForwardStart("IsValidObject", ...)
	end
	b.GetObjectCount = function(...) return MoveForwardStart("GetObjectCount", ...) end
	b.SetFocus = function(...) return MoveForwardStart("SetFocus", ...) end
	b.SetMouseOver = function(...) return MoveForwardStart("SetMouseOver", ...) end
	b.ClearMouseOver = function(...) return MoveForwardStart("ClearMouseOver", ...) end
	-- b.IsGuid = function(...) return MoveForwardStart("IsValidObject", ...) end
	b.GetNewObjects = nil

	--------------------------------
	-- object fields
	--------------------------------
	b.UnitTarget = function(unit)
		local guid = string.match("\-", unit) == nil and _G["UnitGUID"](unit) or unit
		return MoveForwardStart("ObjectField", guid, 0x1C58, 7)
	end
	b.UnitCreator = function(unit)
		local guid = string.match("\-", unit) == nil and _G["UnitGUID"](unit) or unit
		return MoveForwardStart("ObjectField", guid, 0x1C28, 7)
	end
	b.UnitBoundingRadius = function(unit)
		local guid = string.match("\-", unit) == nil and _G["UnitGUID"](unit) or unit
		return MoveForwardStart("ObjectField", guid, 0x1CEC, 4)
	end
	b.UnitCombatReach = function(unit)
		local guid = string.match("\-", unit) == nil and _G["UnitGUID"](unit) or unit
		return MoveForwardStart("ObjectField", guid, 0x1CF0, 4)
	end
	--------------------------------
	-- API conversions
	--------------------------------
	local GetFocus = function(...)
		if string.match(...,"\-") ~= nil then
			b.SetFocus(...)
			return "focus"
		else
			return ...
		end
	end
	b.UnitGUID = function(...)
		local guid = string.match(...,"\-") == nil and _G["UnitGUID"](...) or ...
		return guid
	end
	b.IsGuid = function(...)
		return ... ~= nil and string.match(...,"\-") ~= nil or false
	end
	b.ObjectPointer = function(...)
		if b.UnitExists(...) then
			return b.UnitGUID(...)
		end
	end
	b.ObjectIsUnit = function(...)
		if ... == nil then return false end
		local guid = string.match(...,"\-") == nil and _G["UnitGUID"](...) or ...
		local ObjType = MoveForwardStart("ObjectType", guid)
		return ObjType == 5
	end
	b.ObjectID = function(object)
		local _, _, _, _, _, objectId, _ = strsplit("\-", object);
		return tonumber(objectId);
	end
	b.TraceLine = function(...)
		local hit, hitx, hity, hitz = MoveForwardStart("TraceLine", ...)
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
		local filter = stringsplit(..., ";")
		local files = MoveForwardStart("EnumDirectoryFiles", ...)
		return stringsplit(files, ";")
	end
	b.DirectoryExists = function(...)
		local dirExists = MoveForwardStart("DirectoryExists", ...)
		if dirExists == 0 then return false else return true end
	end
	b.WorldToScreen = function(...)
		local multiplier = UIParent:GetScale()
		local sX, sY = MoveForwardStart("WorldToScreen", ...)
		return sX * multiplier, -sY * multiplier
	end
	b.FaceDirection = function(arg)
		if type(arg) == "number" then
			MoveForwardStart("FaceDirection", arg)
		else
			arg = b.GetAnglesBetweenObjects("player", arg)
			MoveForwardStart("FaceDirection", arg)
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
		return b:CallFunctionWithGuid(_G.AuraUtil["FindAuraByName"], ...)
	end
	b.ObjectIsGameObject = function(...)
		local guid = string.match(...,"\-") == nil and _G["UnitGUID"](...) or ...
		local ObjType = MoveForwardStart("ObjectType", guid)
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

	br.unlocker = "MMB"
	return true
end

function CallFunctionWithGuid(self, f, ...)
    local args = {...}
    local mouseoverUsed = false
    local focusUsed = false
    local oldMouseOver = ""
    local oldFocus = ""
	for i = 1, #args do
		local arg = args[i]
		local value = type(arg) == "string" and string.lower(args[i]) or arg
		if b.IsGuid(arg) or value == "target" or value == "player" or value == "focus" or value == "mouseover" then
			if UnitGUID("target") == arg or value == "target" then
				args[i] = "target"
			elseif UnitGUID("player") == arg or value == "player" then
				args[i] = "player"
			elseif UnitGUID("focus") == arg or value == "focus" then
				args[i] = "focus"
			elseif UnitGUID("mouseover") == arg or value == "mouseover" then
				args[i] = "mouseover"
			elseif not focusUsed then
				args[i] = "focus"
				oldFocus = UnitGUID("focus")
				b.SetFocus(arg)
				focusUsed = true
			elseif not mouseoverUsed then
				args[i] = "mouseover"
				oldMouseOver = UnitGUID("mouseover")
				b.SetMouseOver(arg)
				mouseoverUsed = true
			end
		end
	end
    local returnVal = {f(
		unpack(args)
	)}
    if mouseoverUsed then
        if oldMouseOver ~= "" then
            b.SetMouseOver(oldMouseOver)
        else
            b.ClearMouseOver()
        end
    end
    if focusUsed then
        if oldFocus ~= "" then
            b.SetFocus(oldFocus)
        else
            b.ClearFocus()
        end
    end

	return unpack(returnVal)
end