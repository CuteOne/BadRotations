---@diagnostic disable: param-type-mismatch, undefined-global
--------------------------------------------------------------------------------------------------------------------------------
-- NN (NilName) adapter: loaded by 3rd Party Files/NoName/_BRLoader.lua. Unlockers/README.md lists what an
-- adapter provides.
--------------------------------------------------------------------------------------------------------------------------------

-- Protected game functions BR calls, sent through NN's Unlock
local unlockList =
{
	"AcceptProposal",
	"CancelShapeshiftForm",
	"CastPetAction",
	"CastShapeshiftForm",
	"CastSpellByID",
	"CastSpellByName",
	"ClearTarget",
	"DeleteCursorItem",
	"DestroyTotem",
	"GetComboPoints",
	"JumpOrAscendStart",
	"MoveBackwardStart",
	"MoveBackwardStop",
	"PetAssistMode",
	"PetAttack",
	"PetDefensiveAssistMode",
	"PetDefensiveMode",
	"PetFollow",
	"PetPassiveMode",
	"PetStopAttack",
	"SpellStopCasting",
	"SpellStopTargeting",
	"StartAttack",
	"UseContainerItem",
	"UseItemByName",
}

-- Game functions BR calls that NN has its own version of (they accept NN's objects: numbers, one per
-- object, from Objects() and Object(token))
local globalCacheList =
{
	"AscendStop",
	"CreateDirectory",
	"DirectoryExists",
	"GetRaidTargetIndex",
	"GetUnitSpeed",
	"IsSpellInRange",
	"ReadFile",
	"ScreenToWorld",
	"SpellIsTargeting",
	"StartAttack",
	"UnitAffectingCombat",
	"UnitAttackPower",
	"UnitAttackSpeed",
	"UnitCanAttack",
	"UnitCastingInfo",
	"UnitChannelInfo",
	"UnitClass",
	"UnitClassification",
	"UnitCreatureType",
	"UnitDamage",
	"UnitDetailedThreatSituation",
	"UnitExists",
	"UnitGetIncomingHeals",
	"UnitGroupRolesAssigned",
	"UnitGUID",
	"UnitHealth",
	"UnitHealthMax",
	"UnitInParty",
	"UnitInRaid",
	"UnitInRange",
	"UnitIsCharmed",
	"UnitIsConnected",
	"UnitIsDeadOrGhost",
	"UnitIsEnemy",
	"UnitIsFriend",
	"UnitIsPlayer",
	"UnitIsTapDenied",
	"UnitIsTrivial",
	"UnitIsUnit",
	"UnitIsVisible",
	"UnitLevel",
	"UnitName",
	"UnitOnTaxi",
	"UnitPower",
	"UnitPowerMax",
	"UnitPowerType",
	"UnitRace",
	"UnitRangedDamage",
	"UnitReaction",
	"UnitStat",
	"UnitThreatSituation",
	"UnitTarget",
	"WriteFile",
}

local _, br = ...
local b = br.game
-- Only the ones this client has, read before other addons can hook them
local present = {}
for _, name in ipairs(unlockList) do
	if _G[name] ~= nil then present[#present + 1] = name end
end
-- NN's own globals (Object, Unlocker) share names with things in the editor's WoW API stubs
---@diagnostic disable: cannot-call

-- NN's protected call, if it has one under the name other unlockers use (not documented for NN)
if C_Timer.Nn and type(C_Timer.Nn.CallProtected) == "function" then
	br.unlockers.protect = C_Timer.Nn.CallProtected
end

function br.unlockers:NNUnlock()
	if not C_Timer.Nn then return false end
	-- NN's functions are globals in its own environment
	setfenv(1, C_Timer.Nn)

	--------------------------------
	-- secret unwrap helpers
	--------------------------------
	-- Clients without secret values, or without secretunwrap (removed on some clients, e.g. WoW
	-- Forever), get the results unchanged.
	local issecretvalue = issecretvalue
	local secretunwrap  = secretunwrap
	local canUnwrap     = issecretvalue ~= nil and secretunwrap ~= nil

	-- Unwrap each return value if it is a secret-wrapped scalar.
	local function unwrap(...)
		if not canUnwrap then return ... end
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
		if not canUnwrap or type(t) ~= "table" then return t end
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
		if not canUnwrap or not issecretvalue(t.spellId) then return t end
		for k, v in pairs(t) do
			t[k] = secretunwrap(v)
		end
		if t.points and t.points[1] then
			t.points = {secretunwrap(unpack(t.points))}
		end
		return t
	end

	--------------------------------
	-- unlocked and NN's own game functions
	--------------------------------
	for _, name in ipairs(present) do
		b[name] = function(...) return Unlock(name, ...) end
	end

	for _, name in ipairs(globalCacheList) do
		local fn = C_Timer.Nn[name]
		if fn ~= nil then
			b[name] = function(...) return unwrap(fn(...)) end
		end
	end

	-- C_Spell proxy: intercepts all method calls and unwraps any secret-wrapped
	-- return values. A table first return has its fields unwrapped via UnwrapTable;
	-- every other return is unwrapped via unwrap(). All returns are kept
	-- (IsSpellUsable's second one is insufficientPower). Method wrappers are cached
	-- on the proxy with rawset so they are only built once per method name.
	local function unwrapResults(first, ...)
		if type(first) == "table" then
			return UnwrapTable(first), unwrap(...)
		end
		return unwrap(first, ...)
	end
	if C_Spell then
		local _NN_C_Spell = C_Spell
		b.C_Spell = setmetatable({}, {
			__index = function(t, k)
				local fn = _NN_C_Spell[k]
				if type(fn) ~= "function" then return fn end
				local wrapper = function(...)
					return unwrapResults(fn(...))
				end
				rawset(t, k, wrapper)
				return wrapper
			end
		})
	end

	local ObjectUnit = function(unit)
		return type(unit) == "number" and Object(unit) or unit
	end

	--------------------------------
	-- object manager
	--------------------------------
	local om = {}
	b.GetObjectCount = function()
		-- Call Objects() exactly once: the snapshot used for GetObjectWithIndex must match
		-- the count returned, otherwise index overruns return nil under heavy load.
		om = Objects()
		return #om
	end
	b.GetObjectWithIndex = function(index)
		return om[index]
	end
	b.GetObjectWithGUID = function(...)
		return Object(...)
	end
	b.ObjectPointer = function(unit)
		return Object(unit)
	end
	b.ObjectExists = ObjectExists
	b.ObjectIsUnit = function(...)
		return ObjectType(...) == 5
	end
	b.ObjectIsGameObject = function(...)
		local objectType = ObjectType(...)
		return objectType == 8 or objectType == 11
	end
	b.ObjectID = function(unit)
		if unit == nil then return nil end
		if type(unit) == "string" then
			local guid = UnitGUID(unit)
			if guid == nil then return nil end
			local _, _, _, _, _, npcID = strsplit('-', guid)
			return tonumber(npcID)
		end
		return ObjectID(unit)
	end
	b.ObjectName = ObjectName

	--------------------------------
	-- position and unit fields
	--------------------------------
	b.ObjectPosition = ObjectPosition
	b.ObjectFacing = ObjectFacing
	-- NN's TraceLine returns false when nothing is hit (its docs); BR reads no hit as nil
	b.TraceLine = function(...)
		local x, y, z = TraceLine(...)
		if not x then return nil end
		return x, y, z
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
	-- ground spells and the screen
	--------------------------------
	b.IsAoEPending = b.SpellIsTargeting
	b.CancelPendingSpell = b.SpellStopTargeting
	b.ClickPosition = ClickPosition
	b.GetMousePosition = b.GetCursorPosition
	-- NN's WorldToScreen gives sx, sy from 0 to 1 and whether the point is visible (-1, -1 off screen).
	-- Its docs don't name the corner (0, 0) is; this reads it as the bottom-left, the game's own frame
	-- convention, like the Daemonic adapter's conversion.
	b.WorldToScreen = function(x, y, z)
		local sx, sy, visible = WorldToScreen(x, y, z)
		if not visible or sx < 0 or sy < 0 then return nil end
		local scale = UIParent:GetScale()
		local width, height = UIParent:GetWidth() * scale, UIParent:GetHeight() * scale
		return sx * width, -(height - sy * height)
	end

	--------------------------------
	-- actions
	--------------------------------
	b.CastSpellByName = function(spellName, unit)
		if unit == nil then return CastSpellByName(spellName) end
		return CastSpellByName(spellName, ObjectUnit(unit))
	end
	b.RunMacroText = RunMacroText
	b.TargetUnit = function(unit)
		if Object(unit) then
			return TargetUnit(Object(unit))
		end
	end
	b.InteractUnit = function(unit)
		return ObjectInteract(Object(unit))
	end
	b.ObjectInteract = b.InteractUnit
	b.FaceDirection = function(direction)
		SetPlayerFacing(direction)
	end
	b.AuraUtil = AuraUtil

	--------------------------------
	-- auras and the combat log
	--------------------------------
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
	-- files
	--------------------------------
	b.GetWoWDirectory = function()
		return "\\scripts"
	end
	b.GetDirectoryFiles = function(pattern)
		if pattern == nil or pattern == "*" then return {} end
		local str = pattern .. "*.lua"
		local filter = str:gsub(str:match("*.lua"), "*")
		local names = {}
		for _, file in ipairs(ListFiles(filter) or {}) do
			if file:match(".lua") then names[#names + 1] = file end
		end
		return names
	end

	br.unlockers.raw = C_Timer.Nn
	b.print("NN Unlocker Loaded")
	return true
end
