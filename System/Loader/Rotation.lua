local _, br = ...
--- Rotation
-- br.runner runs the selected rotation: it holds the spec's compiled spell lists and per-tick
-- state, keeps the profile API (br.api.profile, ProfileAPI.lua) built, and each tick runs the shared
-- modules and the rotation. Bootstrap creates it (Rotation:new) once the profiles are loaded.
br.loader.Rotation = br.loader.Rotation or {}
---@class br.loader.Rotation
local Rotation = br.loader.Rotation
Rotation.__index = Rotation

--- Creates the runner for a spec with its selected rotation, compiles the spell lists and builds
-- the profile API. Nil when the spec has no rotation.
-- @param spec Spec ID
-- @param specName Spec name (settings key; the profile window title)
function Rotation:new(spec, specName)
	local loadStart = br.game.debugprofilestop()
	-- Rotation files are loaded by the Bootstrap ROTATIONS stage before the runner is made.
	-- The previously chosen rotation, or the first available one
	local rotations = br.loader.rotations[spec]
	local selected
	if rotations ~= nil and br.loader.selectedProfile ~= nil and rotations[br.loader.selectedProfile] then
		selected = rotations[br.loader.selectedProfile]
	elseif rotations ~= nil then
		br.game.print("No Previously Selected Rotation, Defaulting To: " .. rotations[1].name)
		selected = rotations[1]
	else
		br.game.print("No Rotations Found!")
		return nil
	end

	local self = setmetatable({}, Rotation)
	self.specID = spec                  -- Spec this runner was made for
	self.specName = specName or "Initial" -- Spec name (settings key; the profile window title)
	self.selected = selected            -- The registered rotation it runs (br.loader.registerRotation)
	-- Its own copy: the spell compiler adds the spell lists' items to it
	self.items = {}
	for name, id in pairs(br.lists.items) do self.items[name] = id end
	self.pets = br.lists.pets
	-- Per-tick state, refreshed by baseUpdate()
	self.state = {
		gcd = 1.5,                                  -- Global Cooldown
		gcdMax = 1.5,                               -- Global Max Cooldown
		health = 100,                               -- Health Points in %
		inCombat = false,                           -- If BR considers the player in combat
		inCombatPrevious = false,                   -- Previous combat state, for start/end messages
		instance = select(2, br.game.IsInInstance()), -- Instance type (none, party, raid, etc)
		-- posX, posY, posZ: player position cache (Range.lua)
		-- mounted, dismountTime: mount state and when the player last landed (getCharacterInfo)
		-- pauseReason: why the rotation is paused this tick, nil when it runs (startRotation)
	}
	br.runner = self
	br.loader.profileAPI:reset()
	self:rebuild()
	br.debug.cpu:updateDebug(loadStart, "rotation.loadTime")
	return self
end

------------------
--- BUILD ---
------------------

-- Compiles the spell lists and builds the profile API (buff, cast, unit, ui, module, ...).
-- Runs at load and again on talent, level and equipment changes (requestRebuild).
function Rotation:rebuild()
	br.loader.spellCompiler:compileSpells(self, self.specID)
	br.loader.profileAPI:build(self, self.specID)
	self.rebuildNeeded = false
end

--- Asks for the spell lists and profile API to be built again before the next tick (talents,
-- level or equipment changed).
function Rotation:requestRebuild()
	self.rebuildNeeded = true
end

--------------
--- UPDATE ---
--------------

-- Per-tick update, called by Core
function Rotation:update()
	if self.specID ~= br.loader.selectedSpecID then return end
	if not br.game.UnitAffectingCombat("player") then self:updateOOC() end
	self:baseUpdate()
	br.functions.aura:cleanBleedSnapshots(self.specID)
	if self.rebuildNeeded then self:rebuild() end
	self:getToggleModes()
	self:startRotation()
end

-- Things which get updated for every class each tick
function Rotation:baseUpdate()
	local startTime = br.game.debugprofilestop()
	self:getCharacterInfo()
	self:getInCombat()
	br.debug.cpu:updateDebug(startTime, "rotation.baseUpdate")
end

-- Update Character Stats
function Rotation:getCharacterInfo()
	local state = self.state
	state.gcd = br.functions.spell:getGlobalCD()
	state.gcdMax = br.functions.spell:getGlobalCD(true)
	state.health = br.functions.unit:getHP("player")
	state.instance = select(2, br.game.IsInInstance())
	state.posX, state.posY, state.posZ = br.game.ObjectPosition("player")
	-- When the player last landed from a mount (unit.timeSinceDismount). Kept here, not in the
	-- profile, because the rotation doesn't run while mounted.
	local mounted = br.game.IsMounted() == true
	if mounted then
		state.dismountTime = nil
	elseif state.mounted then
		state.dismountTime = br.game.GetTime()
	end
	state.mounted = mounted
end

-- Out of combat update
function Rotation:updateOOC()
	if #br.functions.cast.queue ~= 0 and br.functions.misc:getOptionCheck("Queue Casting") then
		br.game.wipe(br.functions.cast.queue) -- Reset Queue Casting Table out of combat
		br.game.print("Out of Combat - Queue List Cleared")
	end
end

-- Combat state update, with start/end debug messages
function Rotation:getInCombat()
	local state = self.state
	state.inCombat = br.functions.combat:isInCombat("player")
	if state.inCombat ~= state.inCombatPrevious then
		if state.inCombat then
			br.log:debug("Combat Started")
		else
			br.log:debug("Combat Ended")
			br.log:debug("============")
		end
	end
	state.inCombatPrevious = state.inCombat
end

-- The overlay text for a pause reason; casting and similar pauses pass silently
local quietPauses = { ["dead"] = true, ["control disabled"] = true, ["casting"] = true, ["channelling"] = true, ["item channel"] = true }
local function pauseText(reason)
	if reason == "pause toggle" then return "\124cFFED0000 -- Paused -- " end
	return "Profile Paused: " .. reason
end

-- Start the rotation, unless BR is paused (misc:pauseReason). While paused, neither the shared
-- modules nor the profile run. A rotation registered with actsWhileCasting keeps running while
-- the player casts or channels.
function Rotation:startRotation()
	local startTime = br.game.debugprofilestop()
	-- Not for a moment after a loading screen, so aura data has arrived (System/Core.lua)
	if br.core:isSettling() then
		return
	end

	local state = self.state
	local reason = br.functions.misc:pauseReason(self.selected.actsWhileCasting == true)
	-- Shown once when the reason changes, not on every paused tick
	if reason ~= state.pauseReason and reason and not quietPauses[reason] then
		br.ui.chatOverlay:Show(pauseText(reason))
	end
	state.pauseReason = reason

	if reason == nil then
		br.functions.cast:openerBeginPass()
		self:runModules()
		self.selected.run()
		br.functions.cast:openerEndPass()
	end
	br.log.rotation:endTick()
	br.debug.melee:watch()
	br.debug.target:watch()
	br.debug.idle:watch(reason ~= nil)
	br.debug.melee:readComboPoints()
	br.debug.cpu:updateDebug(startTime, "rotation")
end

-- Runs the shared modules each tick, before the rotation. Racials and trinkets are left to a rotation
-- whose code uses them itself (ProfileLoader handledByProfile)
function Rotation:runModules()
	local api = br.api.profile
	local module = api.module
	if api.ui.useDefensive() then
		module.BasicHealing()
	end
	if not api.unit.inCombat() then
		-- Auto Mythic+ Keystone (Retail)
		if br.client.isRetail then module.autoKeystone() end
	else
		-- Combat Potion Up (Mists of Pandaria)
		if br.client.isMOP then module.CombatPotionUp() end
		if not self.selected.handlesTrinkets then module.BasicTrinkets() end
	end
	if not self.selected.handlesRacials then module.Racial() end
	-- Two Forms (Worgen)
	module.TwoForms()
end

-------------------------
--- OPTIONS / TOGGLES --- (built by br.loader.profileUI)
-------------------------

function Rotation:createOptions()
	br.loader.profileUI:createOptions(self, self.specID)
end

function Rotation:createToggles()
	br.loader.profileUI:createToggles(self)
end

function Rotation:getToggleModes()
	br.loader.profileUI:updateToggleModes()
end

-- The rotation, each tick (in a vehicle only with the target in melee)
br.lifecycle:onTick(50, "rotation", function()
	local rotation = br.runner
	if rotation == nil then return end
	if not br.game.CanExitVehicle() or (br.functions.unit:GetUnitExists("target") and br.functions.range:getDistance("target") < 5) then
		rotation:update()
	end
end)
