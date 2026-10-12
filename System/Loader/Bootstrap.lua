local _, br = ...
--- Bootstrap
-- Owns BR's startup sequence as explicit stages. Core's per-frame Update calls
-- bootstrap:advance(); each stage does its work once and names the next stage.
--
--   WAITING_FOR_WORLD → WAITING_FOR_UNLOCK → SPELL_LISTS → ROTATIONS → SELECT_PROFILE
--     → SETTINGS → PLAYER → UI → UI_CLEANUP → RUNNING
--   ROTATIONS with no matching rotation → NO_ROTATION (waits for a spec change or reload)
--   Spec change → back to ROTATIONS (settings saved first)
--   Profile change / reload request → back to SETTINGS
br.loader.bootstrap = br.loader.bootstrap or {}
local bootstrap = br.loader.bootstrap

bootstrap.stage = "WAITING_FOR_WORLD"
bootstrap.settingsLoaded = false   -- true once the current spec/profile's settings are in memory

local function debug(message)
	if br.functions and br.functions.misc and br.functions.misc.addonDebug then
		br.functions.misc:addonDebug(message)
	end
end

local function setStage(stage)
	if bootstrap.stage ~= stage then
		debug("stage: " .. tostring(bootstrap.stage) .. " -> " .. stage)
		bootstrap.stage = stage
	end
end

-- Current spec ID and settings key (class name on expansions without sub-specs)
local function resolveSpec()
	local specID = (br.api and br.api.getEffectiveSpecID and br.api.getEffectiveSpecID())
		or br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())
	local specName = select(2, br._G.GetSpecializationInfoForSpecID(specID)) or "Initial"
	if specName == "" then specName = "Initial" end
	return specID, br.ui.settingsManagement:normalizeSpecKey(specName)
end

local function specSettings()
	return br.data.settings[br.loader.selectedSpec]
end

local function powerIsOff()
	local toggles = specSettings() and specSettings().toggles
	return toggles ~= nil and toggles["Power"] ~= nil and toggles["Power"] ~= 1
end

-- Shown once per session: the toggle bar (needed to switch Power on) and minimap button position
local function buildMainButtons()
	if bootstrap.mainButtonsBuilt then return end
	bootstrap.mainButtonsBuilt = true
	br.ui.toggles:TogglesFrame()
	local pos = br.data.settings.minimapButton and br.data.settings.minimapButton.pos
	if br.ui.minimapButton and br.ui.minimapButton.frame then
		br.ui.minimapButton.frame:ClearAllPoints()
		if pos and type(pos.x) == "number" and type(pos.y) == "number" and br._G.Minimap then
			br.ui.minimapButton.frame:SetPoint("CENTER", br._G.Minimap, "CENTER", pos.x, pos.y)
		else
			br.ui.minimapButton.frame:SetPoint("CENTER", br._G.Minimap or br._G.UIParent, "CENTER", 75.70, -6.63)
		end
	end
end

local stages = {}

stages.WAITING_FOR_WORLD = function() end -- br.load() moves on once the player is in the world

stages.WAITING_FOR_UNLOCK = function()
	if br.unlocked then setStage("SPELL_LISTS") end
end

stages.SPELL_LISTS = function()
	br.lists:loadExpansionSpells()
	setStage("ROTATIONS")
end

stages.ROTATIONS = function()
	br.loader.selectedSpecID, br.loader.selectedSpec = resolveSpec()
	if specSettings() == nil then br.data.settings[br.loader.selectedSpec] = {} end
	br.player = nil
	br.loader.profileLoader:loadProfiles()
	local rotations = br.loader.rotations[br.loader.selectedSpecID]
	if rotations and #rotations > 0 then
		setStage("SELECT_PROFILE")
	else
		setStage("NO_ROTATION")
	end
end

stages.NO_ROTATION = function()
	bootstrap:checkSpecChange()
end

stages.SELECT_PROFILE = function()
	br.ui.settingsManagement:loadSelection()
	setStage("SETTINGS")
end

stages.SETTINGS = function()
	local settingsManagement = br.ui.settingsManagement
	-- The selected profile: the tracker's choice, or the first rotation for this spec
	local rotations = br.loader.rotations[br.loader.selectedSpecID]
	local name = specSettings()["RotationDropValue"] or rotations[1].name
	br.loader.selectedProfileName = name
	settingsManagement:saveSelection()
	-- This profile's pages are rebuilt next; their options register again as they are created
	br.functions.misc:resetOptionIndex()
	settingsManagement:loadSettings(name)
	settingsManagement:defaultSettings()
	bootstrap.settingsLoaded = true
	buildMainButtons()
	setStage("PLAYER")
end

stages.PLAYER = function()
	-- Nothing is built while BR's Power toggle is off; still follow spec changes meanwhile
	if powerIsOff() then
		bootstrap:checkSpecChange()
		return
	end
	br.loader.selectedProfile = specSettings()["RotationDrop"] or 1
	br.player = br.loader.builder:new(br.loader.selectedSpecID, br.loader.selectedSpec)
	if br.player == nil then
		setStage("NO_ROTATION")
		return
	end
	setStage("UI")
end

-- UI frames are created out of combat only; the rotation already runs during these stages.
local function waitForCombat()
	if not br._G.InCombatLockdown() then
		bootstrap.uiDeferredNotified = nil
		return false
	end
	if not bootstrap.uiDeferredNotified then
		bootstrap.uiDeferredNotified = true
		br._G.print("Rotation loaded. Toggle bar setup deferred until after combat.")
	end
	return true
end

stages.UI = function()
	if waitForCombat() then return end
	br.ui:closeWindow("profile")
	-- Toggles first: the options window adds a Toggle Keys section for toggles made with br.ui:toggle
	br.player:createToggles()
	br.player:createOptions()
	br.ui:recreateWindows()
	br._G.print("Profile Load Complete")
	setStage("UI_CLEANUP")
end

-- One frame after the windows exist: register every page, then remove stale settings.
stages.UI_CLEANUP = function()
	if waitForCombat() then return end
	local settings = specSettings()
	settings.config = settings.config or {}
	local config = settings.config
	local firstLoad = not config.initialLoad
	if br.ui.window.config == nil or br.ui.window.config.frame == nil then
		br.ui.window.config = br.ui.window.config or {}
		br.ui:createConfigWindow()
	end
	if not br.ui.window.config.frame:IsShown() then
		br.ui:toggleWindow("config")
	end
	if br.ui.settingsManagement:registerAllOptions() then
		br.ui.settingsManagement:cleanSettings()
	end
	-- Bot Options opens on the very first load only
	if firstLoad then
		config.initialLoad = true
	else
		br.ui:closeWindow("config")
	end
	br._G.print("UI Load Complete")
	setStage("RUNNING")
end

stages.RUNNING = function() end -- Core runs the per-tick rotation body

--- Advances the startup sequence by one stage (called every frame by Core).
function bootstrap:advance()
	local run = stages[self.stage]
	if run then run() end
end

--- True when Core may run the per-tick body: once startup has finished, or while the UI stages
-- are waiting out combat (so the rotation keeps running in combat). Out of combat the UI is
-- built first, as the tick's helpers (e.g. the debug window) expect it.
function bootstrap:isPlayerReady()
	if br.player == nil then return false end
	if self.stage == "RUNNING" then return true end
	return (self.stage == "UI" or self.stage == "UI_CLEANUP") and br._G.InCombatLockdown()
end

--- True when settings for the current spec/profile are loaded and may be saved.
function bootstrap:canSave()
	return self.settingsLoaded and self.stage ~= "NO_ROTATION"
end

--- Starts the sequence once the player is in the world (br.load).
function bootstrap:start()
	if self.stage == "WAITING_FOR_WORLD" then setStage("WAITING_FOR_UNLOCK") end
end

--- Re-selects and reloads the current profile (profile dropdown, profile buttons, settings import).
-- Settings reload only when the spec/profile actually changed (loadSettings' own check).
function bootstrap:reloadProfile()
	if self.stage == "PLAYER" or self.stage == "UI" or self.stage == "UI_CLEANUP" or self.stage == "RUNNING" then
		setStage("SETTINGS")
	end
end

--- Detects a spec change (signalled by the ACTIVE_PLAYER_SPECIALIZATION_CHANGED reader) and
-- restarts from ROTATIONS after saving the old spec's settings.
function bootstrap:checkSpecChange()
	if not br.loader.specDirty then return end
	br.loader.specDirty = false
	local _, specName = resolveSpec()
	if specName == "" or specName == br.loader.selectedSpec then return end
	br.ui:closeWindow("all")
	if self:canSave() then
		br.ui.settingsManagement:saveSettings()
	end
	self.settingsLoaded = false
	br._G.wipe(br.slashCommands.commandHelp)
	br.slashCommands:slashHelpList()
	-- Invalidate cached melee spell so getDistance picks up the new spec.
	if br.functions.range.invalidateMeleeSpellCache then
		br.functions.range:invalidateMeleeSpellCache()
	end
	setStage("ROTATIONS")
end
