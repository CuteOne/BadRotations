-- BadRotations: BR's tables and its lifecycle. The first file in the TOC; it calls nothing in the game.
-- What happens when: System/Bootstrap.lua starts BR once the player is in the world and runs the
-- startup stages; System/Core.lua runs it from then on.
local _, br = ...

--[[
  API TIER HIERARCHY — call the highest tier that meets your need.

  Tier 1 — br.game
    The game's API as BR sees it: the client's globals with the unlocker's functions,
    the polyfills (the modern API where the client lacks it) and BR's own versions on
    top (layers: Expansions/Layers.lua). Use it for WoW API calls that have no
    higher-level wrapper. Write against the modern API; the polyfills cover older clients.
    Example: br.game.UnitHealth("player")

  Tier 2 — br.api.wow
    The polyfill layer of br.game (Expansions/Polyfills.lua, Expansions/<name>/Functions.lua).
    Call br.game, not this table: only Expansions/ writes here.

  Tier 3 — br.functions
    Low-level manipulation helpers: range checks, aura scans, unit queries, etc.
    These call Tier 1/2 and add caching, cross-version normalization, and logic
    that is too low-level for rotation code to repeat inline.
    Example: br.functions.range:getDistance("player", "target")

  Tier 4 — br.player  (also br.player.cast, br.player.buff, etc.)
    Rotation-facing clean API. Rotation authors should call this tier exclusively.
    These wrap Tier 3 with per-spell/per-unit closures generated at load time.
    Example: cast.fireball()   buff.combustion.up()   cd.pyroblast.remain()

  Rule: never call a lower tier from a higher tier (e.g. don't call br.game directly
  from a rotation file — use br.player.* instead). Reach down only when the
  higher-tier wrapper does not exist yet.
]]

-- BR's tables. Each module fills its own and keeps its own state there.
br.api = {}
br.data = { settings = {}, ui = {} }
br.debug = {}
br.engines = {}
br.functions = {}
br.lists = {}
br.loader = {}
br.misc = {}
br.readers = {}
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
