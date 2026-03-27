-- [[ Global Variables and Tables Initialization ]] --
-- define br global that will hold the bot global background features
local _, br = ...

--[[
  API TIER HIERARCHY — call the highest tier that meets your need.

  Tier 1 — br._G
    Raw proxy over native WoW globals (_G) with br.api.wow overrides applied.
    Use for WoW API calls that have no higher-level wrapper, or when you need
    guaranteed access to the raw unlocker/WoW surface.
    Example: br._G.UnitHealth("player")

  Tier 2 — br.api.wow
    Expansion compatibility shims. Each expansion file (retail.lua, mop.lua, etc.)
    overrides functions here so the rest of the codebase can call a single name
    regardless of which WoW version is running.
    Example: br.api.wow.GetSpellInfo(spellID)

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
br._G = setmetatable({}, { __index = _G })

-- WoW API Compatibility Layer
-- Expansion-specific API wrappers are loaded via Expansions/wowapi.lua -> Expansions/<name>/Functions.lua
-- This allows all API differences to be managed in one place per expansion
-- Access API functions via: br.api.wow.FunctionName() or br._G.FunctionName()

-- Override br._G to use compatibility layer when available
local originalIndex = getmetatable(br._G).__index
setmetatable(br._G, {
	__index = function(t, k)
		-- First check if we have a compatibility wrapper
		if br.api and br.api.wow and br.api.wow[k] then
			return br.api.wow[k]
		end
		-- Fall back to global _G
		return originalIndex[k]
	end
})
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
br.unlockers = {}

-- Other Initialization
br.data = {}
br.data.settings = {}
br.loader.addonName = "BadRotations"
br.loader.rotations = {}
br.loader.selectedSpec = "None"
br.loader.selectedSpecID = 0
br.loader.selectedProfile = 1
br.loader.selectedProfileName = "None"
br.loader.settingsFile = "None.lua"
-- developers debug, use /run br.data.settings[br.loader.selectedSpec].toggles["isDebugging"] = true

-- Run
function br.Run()
	if br.loader.selectedSpec == nil then
		br.loader.selectedSpecID, br.loader.selectedSpec = br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())
		if br.loader.selectedSpec == "" then
			br.loader.selectedSpec = "Initial"
		end
	end
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
	-- Update Selected Spec
	br.loader.selectedSpecID, br.loader.selectedSpec = br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())
	if br.loader.selectedSpec == "" then
		br.loader.selectedSpec = "Initial"
	end
	if br.data == nil then
		br.data = {}
	end
	if br.data.tracker == nil then
		br.data.tracker = {}
	end
	if br.data.settings == nil then
		br.data.settings = {}
	end
	if br.data.ui == nil then
		br.data.ui = {}
	end
	if br.data.settings[br.loader.selectedSpec] == nil then
		br.data.settings[br.loader.selectedSpec] = {}
	end
	if not br.unlocked then
		br.ui.settingsManagement.initializeSettings = true
		print(br.ui.colors.class .. "[BadRotations] |cffFFFFFFInitializing Please Wait...")
	end
	if not loadedIn then
		if br.engines.enemiesEngine.damaged == nil then
			br.engines.enemiesEngine.damaged = {}
		end
		-- br.bagsUpdated = true
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
	end
	if event == "PLAYER_LOGOUT" then
		-- Attempt to save settings and UI state on logout regardless of unlock status.
		-- Guard calls to avoid errors if subsystems are not available.
		-- Return queue window to previous setting if possible
		if br._G and br._G.C_CVar and br._G.GetCVar and br._G.RunMacroText then
			if br._G.C_CVar.GetCVar("SpellQueueWindow") == "0" then
				br._G.RunMacroText("/console SpellQueueWindow " .. br._G.GetCVar("SpellQueueWindow"))
			end
		end
		if br.ui and br.ui.settingsManagement then
			br.ui:saveWindowPosition()
			br.ui.settingsManagement:cleanSettings()
			if br.data and br.data.settings and br.data.settings[br.loader.selectedSpec] and br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] and br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["PageList"] then
				table.wipe(br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["PageList"])
			end
			if br.functions and br.functions.misc and br.functions.misc:getOptionCheck("Reset Options") then
				-- Reset Settings
				br.ui.settingsManagement:saveSettings(nil, nil, br.loader.selectedSpec, br.loader.selectedProfileName, true)
			else
				-- Save Settings
				br.ui.settingsManagement:saveSettings(nil, nil, br.loader.selectedSpec, br.loader.selectedProfileName)
			end
			br.ui.settingsManagement:saveLastProfileTracker()
			table.wipe(br.ui)
		end
	end
	if event == "PLAYER_ENTERING_WORLD" then
		br.load()
	end
end

-- Setting the OnEvent script handler
frame:SetScript("OnEvent", OnEvent)
