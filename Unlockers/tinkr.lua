---@diagnostic disable: undefined-global
--------------------------------------------------------------------------------------------------------------------------------
-- Tinkr adapter: loaded by 3rd Party Files/Tinkr/_BRLoader.lua, with Tinkr's table as the file's first argument.
-- Tinkr's API: WoW-U/vscode-tinkr-api (lua-definitions/Tinkr.lua). Unlockers/README.md lists what an adapter
-- provides.
--------------------------------------------------------------------------------------------------------------------------------
local Unlocker, br = ...
local b = br.game
-- Tinkr's own globals (Object, Unlocker) share names with things in the editor's WoW API stubs
---@diagnostic disable: cannot-call
local unlock = br.unlockers
local File

function unlock.TinkrUnlock()
	if File == nil then
		if Unlocker and Unlocker.name == "Tinkr" then
			br.game.print("Tinkr Unlocker Detected")
			---@diagnostic disable-next-line: undefined-field
			File = Unlocker.Util.File
		else
			return false
		end
	end

	--------------------------------
	-- object manager
	--------------------------------
	local om = {}
	b.GetObjectCount = function()
		table.wipe(om)
		for i, object in ipairs(Objects()) do
			om[i] = object
		end
		return #om
	end
	b.GetObjectWithIndex = function(index)
		return tostring(om[index])
	end
	b.GetObjectWithGUID = function(...)
		return Object(...)
	end
	b.ObjectPointer = function(...) return Object(...) end
	b.ObjectExists = function(...) return Object(...) ~= nil end
	b.ObjectIsUnit = function(...)
		return ObjectType(...) == 5
	end
	b.ObjectIsGameObject = function(...)
		local objectType = ObjectType(...)
		return objectType == 8 or objectType == 11
	end
	b.ObjectID = function(...) return ObjectID(...) end
	b.ObjectName = function(...) return ObjectName(Object(...)) end
	b.UnitName = function(...)
		if Object(...) then
			return UnitName(Object(...))
		end
		return ""
	end

	--------------------------------
	-- position and unit fields
	--------------------------------
	b.ObjectPosition = function(...)
		if ObjectMover(...) then return ObjectWorldPosition(...) end
		return ObjectPosition(...)
	end
	b.ObjectFacing = function(...)
		if ObjectMover(...) then return ObjectRawRotation(...) end
		return ObjectRotation(...)
	end
	b.UnitCreator = function(...) return ObjectCreator(Object(...)) end
	-- ObjectFlags(unit) returns flags1-4, unitFlags1, unitFlags2, dynamicFlags; unitFlags1 is the unit
	-- flags field. Not yet seen in play.
	b.UnitFlags = function(...)
		local object = Object(...)
		if object == nil then return nil end
		return (select(5, ObjectFlags(object)))
	end
	b.UnitBoundingRadius = function(...) return ObjectBoundingRadius(Object(...)) end
	b.UnitCombatReach = function(...) return ObjectCombatReach(Object(...)) end
	-- Not the unit's target: Tinkr's API has no call for that, only the destination of the unit's
	-- current cast. Until one is found, "is it targeting me" checks only see casts.
	b.UnitTarget = function(...) return ObjectCastingTarget(Object(...)) end
	-- BR reads no hit as nil; a false from Tinkr is turned into that
	b.TraceLine = function(...)
		local x, y, z = TraceLine(...)
		if not x then return nil end
		return x, y, z
	end

	--------------------------------
	-- ground spells and the screen
	--------------------------------
	b.IsAoEPending = IsSpellPending
	b.CancelPendingSpell = b.SpellStopTargeting
	b.ClickPosition = Click
	b.WorldToScreen = function(...)
		local multiplier = UIParent:GetScale()
		local sX, sY = Draw:WorldToScreen(...)
		return sX * multiplier, -sY * multiplier
	end
	b.ScreenToWorld = function(...)
		return Common.ScreenToWorld(...)
	end
	b.GetMousePosition = function()
		return Common.ScreenToWorld(GetCursorPosition())
	end

	--------------------------------
	-- actions
	--------------------------------
	-- No unit: the game's own choice (self, or the current target)
	b.CastSpellByName = function(spell, unit)
		if unit == nil then return CastSpellByName(spell) end
		local object = Object(unit)
		if object then return CastSpellByName(spell, object) end
	end
	-- %q quotes the text, so quotes and backslashes in it don't break the code Eval runs
	b.RunMacroText = function(text)
		return Eval(("RunMacroText(%q)"):format(text), "")
	end
	-- The unit BR passes is dropped: it may be a Tinkr object, which the code Eval runs can't name
	b.UseItemByName = function(name)
		return Eval(("UseItemByName(%q)"):format(name), "")
	end
	b.TargetUnit = function(unit)
		if Object(unit) then
			return TargetUnit(Object(unit))
		end
	end
	b.InteractUnit = function(unit)
		if Object(unit) then
			return InteractUnit(Object(unit))
		end
	end
	b.ObjectInteract = b.InteractUnit
	b.FaceDirection = function(direction)
		SetHeading(direction)
	end

	--------------------------------
	-- files
	--------------------------------
	b.GetWoWDirectory = function()
		return "scripts"
	end
	b.ReadFile = function(...)
		return ReadFile(...)
	end
	-- WriteFile(path, data, append) appends itself
	b.WriteFile = function(...)
		return WriteFile(...)
	end
	unlock.nativeAppend = true
	b.CreateDirectory = function(...)
		return File:CreateDirectory(...)
	end
	b.DirectoryExists = function(...)
		return File:DirectoryExists(...)
	end
	-- "folder/*.lua": the names of the files in folder
	b.GetDirectoryFiles = function(pattern)
		local names = {}
		for _, file in ipairs(File:List(pattern:match("^[^*]*"))) do
			local name = file:match("/([^/]+)$")
			if name then names[#names + 1] = name end
		end
		return names
	end

	unlock.raw = getfenv(1)
	return true
end
