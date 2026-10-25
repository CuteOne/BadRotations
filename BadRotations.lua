-- [[ Global Variables and Tables Initialization ]] --
-- define br global that will hold the bot global background features
local _, br = ...

--[[
  API TIER HIERARCHY — call the highest tier that meets your need.

  Tier 1 — br._G
    The game's API as BR sees it: the client's globals with the unlocker's functions,
    the polyfills (the modern API where the client lacks it) and BR's own versions on
    top (layers: Expansions/wowapi.lua). Use it for WoW API calls that have no
    higher-level wrapper. Write against the modern API; the polyfills cover older clients.
    Example: br._G.UnitHealth("player")

  Tier 2 — br.api.wow
    The polyfill layer of br._G (Expansions/shared.lua, Expansions/<name>/Functions.lua).
    Call br._G, not this table: only Expansions/ writes here.

  Tier 3 — br.functions
    Low-level manipulation helpers: range checks, aura scans, unit queries, etc.
    These call Tier 1/2 and add caching, cross-version normalization, and logic
    that is too low-level for rotation code to repeat inline.
    Example: br.functions.range:getDistance("player", "target")

  Tier 4 — br.player  (also br.player.cast, br.player.buff, etc.)
    Rotation-facing clean API. Rotation authors should call this tier exclusively.
    These wrap Tier 3 with per-spell/per-unit closures generated at load time.
    Example: cast.fireball()   buff.combustion.up()   cd.pyroblast.remain()

  Rule: never call a lower tier from a higher tier (e.g. don't call br._G directly
  from a rotation file — use br.player.* instead). Reach down only when the
  higher-tier wrapper does not exist yet.
]]

local loadedIn = false
-- Guard to make br.load idempotent when multiple loaders invoke it
local _br_loaded = false
-- System Table Initialization
br.api = br.api or {} -- Don't overwrite if already initialized by wowapi.lua
br.engines = {}
br.functions = {}
br.lists = {}
br.loader = {}
br.misc = {}
br.readers = {}
br.ui = {}
br.debug = {}
br.slashCommands = {}
br.unlockers = br.unlockers or {} -- br.unlockers.api is set up by wowapi.lua

-- Other Initialization
br.data = {}
br.data.settings = {}
br.data.ui = {}
br.loader.addonName = "BadRotations"
br.loader.rotations = {}
br.loader.selectedSpec = "None"
br.loader.selectedSpecID = 0
br.loader.selectedProfile = 1
br.loader.selectedProfileName = "None"
br.loader.settingsFile = "None.lua"

-- Run
function br.Run()
	-- add minimap fire icon
	br.ui:MinimapButton()
	-- Build up pulse frame (hearth)
	if not loadedIn then
		-- Start Logs
		-- combat log
		br.readers.combatLog:combatLog()
		-- other readers
		br.readers.common:commonReaders()
		-- Start Engines
		br.engines:Main()
		br.engines:ObjectManager()
		br.engines:ObjectTracker()
		-- Initialize Loot Engine
		if br.engines.lootEngine and br.engines.lootEngine.init then
			br.engines.lootEngine:init()
		end
			loadedIn = true
	end
end

function br.load()
	if _br_loaded then return end
	_br_loaded = true
	br._G.print("Initializing Please Wait...")
	-- Spec, rotations, settings and the player are set up by the startup stages (System/Bootstrap.lua)
	br.bootstrap:start()
	if not loadedIn then
		if br.engines.enemiesEngine and br.engines.enemiesEngine.damaged == nil then
			br.engines.enemiesEngine.damaged = {}
		end
		br:Run()
	end
end

-- [[ Event Listeners ]] --
local frame = br._G.CreateFrame("FRAME")

-- Registering events
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("LOADING_SCREEN_ENABLED")
frame:RegisterEvent("LOADING_SCREEN_DISABLED")

-- Separate OnEvent function
local function OnEvent(self, event)
	if event == "LOADING_SCREEN_ENABLED" then
		br.disablePulse = true
	end
	if event == "LOADING_SCREEN_DISABLED" then
		br.disablePulse = false
		-- Give aura/buff data a few ticks to propagate before rotations run again.
		br.zoneGraceEnd = br._G.GetTime() + 3
	end
	if event == "PLAYER_LOGOUT" then
		-- Attempt to save settings and UI state on logout regardless of unlock status.
		-- Guard calls to avoid errors if subsystems are not available.
		-- Restore SpellQueueWindow to the value BR saved before changing it.
		if br._G and br._G.RunMacroText and br.unlockers and br.unlockers.origQueueWindow then
			br._G.RunMacroText("/console SpellQueueWindow " .. br.unlockers.origQueueWindow)
		end
		-- Only save once this session's settings were actually loaded (never defaults over a real file)
		if br.ui and br.ui.settingsManagement and br.bootstrap:canSave() then
			br.ui:saveWindowPosition()
			br.ui.settingsManagement:cleanSettings()
			if br.data and br.data.settings and br.data.settings[br.loader.selectedSpec] and br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] and br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["PageList"] then
				table.wipe(br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["PageList"])
			end
			if br.functions and br.functions.misc and br.functions.misc:getOptionCheck("Reset Options") then
				-- Reset Settings
				br.ui.settingsManagement:saveSettings(true)
			else
				-- Save Settings
				br.ui.settingsManagement:saveSettings()
			end
			br.ui.settingsManagement:saveSelection()
			table.wipe(br.ui)
		end
	end
	if event == "PLAYER_ENTERING_WORLD" then
		br.load()
	end
end

-- Setting the OnEvent script handler
frame:SetScript("OnEvent", OnEvent)

-- When injected after login, PLAYER_ENTERING_WORLD has already fired. Load on
-- the next frame instead, once the rest of the TOC's files have run.
if br._G.IsLoggedIn and br._G.IsLoggedIn() then
	br._G.C_Timer.After(0, br.load)
end
