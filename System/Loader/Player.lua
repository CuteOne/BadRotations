local _, br = ...
--- Player
-- The br.player object: runtime state, the per-tick update, and the methods Core calls.
-- Methods live on the shared Player class; builder:new() creates the object, loads the
-- rotation and builds the profile API on it (spellCompiler + playerAPI).
-- br.player.X resolves to the object's own fields, then Player methods. Per-tick state is in br.player.state.
br.loader.Player = br.loader.Player or {}
local Player = br.loader.Player
Player.__index = Player

--- Creates the player object for a spec.
-- @param spec Spec ID
function Player:new(spec)
	local self = setmetatable({}, Player)
	self.specID = spec                                      -- Spec this object was built for
	self.actionList = {}                                    -- Action Lists
	self.class = select(2, br._G.UnitClass("player"))       -- Class (non-localised)
	self.glyph = {}                                         -- Glyphs
	self.pandemic = {}                                      -- Base Duration per Unit/Debuff (combat log reader)
	self.pet = {}                                           -- Pet Information Table
	self.pet.list = {}                                      -- Table of Pets
	self.specName = "None"                                  -- Spec name (settings key; the profile window title)
	self.queue = {}                                         -- Queued Spells
	self.race = select(2, br._G.UnitRace("player"))         -- Race (non-localised; Undead = Scourge)
	self.rotation = {}                                      -- Selected Rotation
	self.variables = {}                                     -- Custom Profile Variables
	-- Per-tick runtime state, refreshed by baseUpdate()
	self.state = {
		gcd = 1.5,                                          -- Global Cooldown
		gcdMax = 1.5,                                       -- Global Max Cooldown
		health = 100,                                       -- Health Points in %
		inCombat = false,                                   -- If BR considers the player in combat
		inCombatPrevious = false,                           -- Previous combat state, for start/end messages
		instance = select(2, br._G.IsInInstance()),         -- Instance type (none, party, raid, etc)
		-- posX, posY, posZ: player position cache (Range.lua)
		-- mounted, dismountTime: mount state and when the player last landed (getCharacterInfo)
		-- pauseReason: why the rotation is paused this tick, nil when it runs (startRotation)
	}
	return self
end

------------------
--- BUILD ---
------------------

-- Compiles the spell lists and builds the profile API (buff, cast, unit, ui, module, ...).
-- Runs at load and again on talent, level and equipment changes (updatePlayer).
function Player:rebuild()
	br.loader.spellCompiler:compileSpells(self, self.specID)
	br.loader.playerAPI:build(self, self.specID)
	self.updatePlayer = false
end

--------------
--- UPDATE ---
--------------

-- Per-tick update, called by Core
function Player:update()
	if self.specID ~= br.loader.selectedSpecID then return end
	if not br._G.UnitAffectingCombat("player") then self:updateOOC() end
	self:baseUpdate()
	br.functions.aura:cleanBleedSnapshots(self.debuff, self.specID)
	if self.updatePlayer then self:rebuild() end
	self:getToggleModes()
	self:startRotation()
end

-- Things which get updated for every class each tick
function Player:baseUpdate()
	local startTime = br._G.debugprofilestop()
	self:getCharacterInfo()
	self:getInCombat()
	br.debug.cpu:updateDebug(startTime, "rotation.baseUpdate")
end

-- Update Character Stats
function Player:getCharacterInfo()
	local state = self.state
	state.gcd = br.functions.spell:getGlobalCD()
	state.gcdMax = br.functions.spell:getGlobalCD(true)
	state.health = br.functions.unit:getHP("player")
	state.instance = select(2, br._G.IsInInstance())
	state.posX, state.posY, state.posZ = br._G.ObjectPosition("player")
	-- When the player last landed from a mount (unit.timeSinceDismount). Kept here, not in the
	-- profile, because the rotation doesn't run while mounted.
	local mounted = br._G.IsMounted() == true
	if mounted then
		state.dismountTime = nil
	elseif state.mounted then
		state.dismountTime = br._G.GetTime()
	end
	state.mounted = mounted
end

-- Out of combat update
function Player:updateOOC()
	self:baseUpdateOOC()
end

-- Updates things out of combat
function Player:baseUpdateOOC()
	if #self.queue ~= 0 and br.functions.misc:getOptionCheck("Queue Casting") then
		self.queue = {} -- Reset Queue Casting Table out of combat
		br._G.print("Out of Combat - Queue List Cleared")
	end
end

-- Combat state update, with start/end debug messages
function Player:getInCombat()
	local state = self.state
	state.inCombat = br.functions.combat:isInCombat("player")
	if state.inCombat ~= state.inCombatPrevious and self.ui and self.ui.debug then
		if state.inCombat then
			self.ui.debug("Combat Started")
		else
			self.ui.debug("Combat Ended")
			self.ui.debug("============")
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
function Player:startRotation()
	local startTime = br._G.debugprofilestop()
	-- Halt all rotations during loading screens and transitions
	if br.disableControl or br.disablePulse then
		return
	end

	-- Suppress rotation for a short grace period after a zone transition so that
	-- aura/buff data has time to propagate before action lists query it.
	if br.zoneGraceEnd and br._G.GetTime() < br.zoneGraceEnd then
		return
	end

	-- The profile API (ui, module, ...) only exists once playerAPI:build() has run
	if self.ui == nil or self.module == nil then
		return
	end

	if self.rotation == nil or self.rotation.run == nil then
		return
	end

	local state = self.state
	local reason = br.functions.misc:pauseReason(self.rotation.actsWhileCasting == true)
	-- Shown once when the reason changes, not on every paused tick
	if reason ~= state.pauseReason and reason and not quietPauses[reason] then
		br.ui.chatOverlay:Show(pauseText(reason))
	end
	state.pauseReason = reason

	if reason == nil then
		br.functions.cast:openerBeginPass()
		self:runModules()
		self.rotation.run()
		br.functions.cast:openerEndPass()
	end
	br.debug.melee:watch(self)
	br.debug.target:watch()
	br.debug.idle:watch(self, reason ~= nil)
	br.debug.melee:readComboPoints()
	br.debug.cpu:updateDebug(startTime, "rotation")
end

-- Runs the shared modules each tick, before the rotation
function Player:runModules()
	if self.ui.useDefensive() then
		-- Basic Healing Module
		self.module.BasicHealing()
	end
	if not self.unit.inCombat() then
		-- Module Auto Mythic+ Keystone (Retail)
		if br.isRetail then self.module.autoKeystone() end
	else
		-- Module - Combatpotion Up (Mists of Pandaria)
		if br.isMOP then self.module.CombatPotionUp() end
		-- Module - Basic Trinkets
		if not self.localTrinkets then
			self.module.BasicTrinkets()
		end
	end
	-- Module - Racials (profiles that handle racials themselves set br.player.localRacial)
	if not self.localRacial then
		self.module.Racial()
	end
	-- Module - Two Forms (Worgen)
	self.module.TwoForms()
end

-------------------------
--- OPTIONS / TOGGLES --- (built by br.loader.profileUI)
-------------------------

function Player:createOptions()
	br.loader.profileUI:createOptions(self, self.specID)
end

function Player:createBaseOptions()
	br.loader.profileUI:createBaseOptions(self)
end

function Player:createToggles()
	br.loader.profileUI:createToggles(self)
end

function Player:getToggleModes()
	br.loader.profileUI:updateToggleModes(self)
end
