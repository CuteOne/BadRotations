-- BadRotations: BR's tables and its lifecycle. The first file in the TOC; it calls nothing in the game.
-- What happens when: System/Bootstrap.lua starts BR once the player is in the world and runs the
-- startup stages; System/Core.lua runs it from then on.
local _, br = ...

--[[
  LAYERS: each calls only the one below it (.tests/layering_check.lua enforces it).

  Profiles (Rotations/)
    Run with the profile API as their environment and reach nothing else: cast.fireball(),
    buff.combustion.up(), cd.pyroblast.remain(), ui.checked("Name"). No br, no game API.

  Profile API — br.api.profile (System/API, built by System/Loader/ProfileAPI.lua)
    The tables profiles use (buff, cast, unit, ui, ...), made by the br.api.build.* builders
    from the spell lists. They call br.functions (and BR's engines and readers).

  Functions — br.functions (System/Functions), with the engines and readers
    The work: range checks, aura scans, unit queries, casting, with caching and the
    differences between clients handled once. They call br.game.

  Game — br.game (Expansions/Layers.lua)
    The game's API as BR sees it: the client's globals with the unlocker's functions,
    the polyfills (the modern API where the client lacks it, Expansions/Polyfills.lua) and
    BR's own versions on top. Write against the modern API; the polyfills cover older clients.

  The runner, br.runner (System/Loader/Rotation.lua), sits beside the profile API: it builds it,
  keeps the compiled spell lists (br.runner.spells) and runs the selected rotation each tick.
]]

-- BR's tables. Each module fills its own and keeps its own state there.
br.api = { build = {} }
br.bootstrap = {}
br.client = {}
br.core = {}
br.data = { settings = {}, ui = {} }
br.debug = {}
br.engines = {}
br.functions = {}
br.lists = {}
br.loader = {}
br.misc = {}
br.readers = {}
br.secrets = {}
br.slashCommands = {}
br.ui = {}
br.unlockers = {}

---------------------------------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------------------------------
-- Modules register their own steps; nothing here knows what they do.
--   br.lifecycle:onStart(order, name, fn)   once, when the player first enters the world, before the
--                                           startup stages (System/Bootstrap.lua)
--   br.lifecycle:onFrame(order, name, fn)   every frame once an unlocker is found (System/Core.lua)
--   br.lifecycle:onTick(order, name, fn)    every rotation tick, once BR runs (System/Core.lua); a
--                                           step that returns true ends the tick there
--   br.lifecycle:onPowerOff(order, name, fn) once when the player switches Power off (System/Core.lua)
--   br.lifecycle:onLogout(order, name, fn)  on logout and /reload
-- Steps run by order, lowest first (ties in the order they registered). Orders in use:
--   start   10 minimap button  20 combat log reader  21 other readers  30 Core's frame  40 loot engine
--   frame, tick, powerOff   see System/Core.lua
--   logout  10 spell queue window  20 settings  90 log files
br.lifecycle = { steps = { start = {}, frame = {}, tick = {}, powerOff = {}, logout = {} } }
local lifecycle = br.lifecycle

local function add(list, order, name, fn)
	local at = #list + 1
	for i = #list, 1, -1 do
		if list[i].order <= order then break end
		at = i
	end
	table.insert(list, at, { order = order, name = name, fn = fn })
end

function lifecycle:onStart(order, name, fn) add(self.steps.start, order, name, fn) end
function lifecycle:onFrame(order, name, fn) add(self.steps.frame, order, name, fn) end
function lifecycle:onTick(order, name, fn) add(self.steps.tick, order, name, fn) end
function lifecycle:onPowerOff(order, name, fn) add(self.steps.powerOff, order, name, fn) end
function lifecycle:onLogout(order, name, fn) add(self.steps.logout, order, name, fn) end

--- Runs one list's steps in order; returns true (and stops) when a step returns true.
function lifecycle:run(kind, ...)
	for _, step in ipairs(self.steps[kind]) do
		if step.fn(...) == true then return true end
	end
	return false
end
