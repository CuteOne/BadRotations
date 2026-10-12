local _, br = ...
br.engines.lootEngine = br.engines.lootEngine or {}
local lootEngine = br.engines.lootEngine

-----------------------------------------Loot Engine--------------------------------------
if not lootEngine.metaTable then
	-- Localizing commonly used functions
	local tinsert, tremove, GetTime = br._G.tinsert, br._G.tremove, br._G.GetTime
	local UnitCastingInfo, UnitChannelInfo = br._G.UnitCastingInfo, br._G.UnitChannelInfo
	local IsMounted, GetUnitSpeed = br._G.IsMounted, br._G.GetUnitSpeed
	local UnitIsDeadOrGhost, CanLootUnit = br._G.UnitIsDeadOrGhost, br._G.CanLootUnit
	local ClearTarget = br._G.ClearTarget
	-- Note: InteractUnit is accessed via br._G dynamically to support late-loading unlockers

	local MAX_LOOT_OPENS = 3    -- Times we may OPEN a corpse's loot window while loot still
	                           -- remains (with bag space) before treating the leftover as a
	                           -- unique/quest/already-owned item we can't take, and skipping it.
	local WINDOW_TIMEOUT = 1.0 -- Seconds to wait for LOOT_OPENED after an interact before
	                           -- releasing the in-flight state and retrying (was an implicit 3s stall).

	-- Note: lootable table is managed by EnemiesEngine (br.engines.enemiesEngine.lootable)
	lootEngine.lootUnit = nil         -- Current unit to loot
	lootEngine.lootGUID = nil         -- GUID of the unit we last fired an interact on
	lootEngine.oldMessage = nil       -- For debug message tracking
	lootEngine.lastBagWarning = 0     -- Throttle bag full warnings
	lootEngine.lootAttempts = {}      -- Last interact time per GUID (paces re-interacts)
	lootEngine.lootOpenCount = {}     -- Times the loot window opened per GUID (unique-item detection)
	lootEngine.lootSkipList = {}      -- GUIDs to skip this session (loot that can't be taken)
	lootEngine.isLooting = false      -- Interact fired, awaiting loot window
	lootEngine.lootWindowOpen = false -- Track if loot window is currently open
	lootEngine.lootStartTime = 0      -- GetTime() the current interact was fired (timeout ref)
	lootEngine.metaTable = {}         -- MetaTable for the engine
	lootEngine.metaTable.__index = {
		name = "Loot Engine",
		author = "CuteOne",
	}

	setmetatable(lootEngine, lootEngine.metaTable)

	-- Debug function: a system line under Addon Debug Messages (a message isn't repeated in a row).
	-- It was keyed to an "isDebugging" toggle that nothing makes, so it never showed.
	function lootEngine:debug(message)
		if message and self.oldMessage ~= message then
			br.functions.misc:addonDebug("<LootEngine> " .. (math.floor(GetTime() * 1000) / 1000) .. " " .. message, true)
			self.oldMessage = message
		end
	end

	-- Check if available bag slots, return number of free slots
	function lootEngine:emptySlots()
		local openSlots = 0
		for i = 0, 4 do -- Check each bag
			local numBagSlots = br._G.C_Container.GetContainerNumSlots(i)
			if numBagSlots > 0 then -- Only look for slots if bag present
				openSlots = openSlots + select(1, br._G.C_Container.GetContainerNumFreeSlots(i))
			end
		end
		return openSlots
	end

	-- Count lootable units and set the next loot target
	function lootEngine:lootCount()
		local lootCount = 0
		self.lootUnit = nil
		local closestUnit = nil
		local closestDistance = 999

		-- Use the lootable table from EnemiesEngine
		local lootableTable = br.engines.enemiesEngine.lootable
		for k, v in pairs(lootableTable) do
			if v ~= nil and v.unit ~= nil and v.guid ~= nil then
				local thisUnit = v.unit
				local thisGUID = v.guid
				-- Verify the unit still exists and has loot
				if br.functions.unit:GetObjectExists(thisUnit) then
					local hasLoot = CanLootUnit(thisGUID)
					if hasLoot then
						-- Ignore (but keep) GUIDs we've skip-listed this session so a blocked
						-- unique item never starves looting of other nearby corpses.
						if not self.lootSkipList[thisGUID] then
							lootCount = lootCount + 1
							-- Find the closest lootable unit instead of just the first
							local distance = br.functions.range:getDistance(thisUnit)
							if distance < closestDistance then
								closestDistance = distance
								closestUnit = thisUnit
							end
						end
					else
						-- No longer has loot, remove from table
						lootableTable[k] = nil
					end
				else
					-- Unit no longer exists, remove from table
					lootableTable[k] = nil
				end
			end
		end

		-- Set the closest unit as the loot target
		if closestUnit then
			self.lootUnit = closestUnit
		end

		return lootCount
	end

	-- Main looting logic
	function lootEngine:getLoot(lootUnit)
		if not lootUnit then
			self:debug("getLoot called with nil unit")
			return
		end

		-- Verify unit still exists
		if not br.functions.unit:GetObjectExists(lootUnit) then
			self:debug("Loot unit no longer exists")
			self.lootUnit = nil
			return
		end

		local now = GetTime()

		-- Resolve any in-flight interact. If we fired an interact and the loot window
		-- never opened within WINDOW_TIMEOUT, release the state so we can retry — a
		-- window that fails to open is a range/LoS/timing miss, NOT a blocked item, so
		-- it must never count toward the skip logic. While still waiting on (or showing)
		-- a window, do nothing.
		if self.isLooting then
			if not self.lootWindowOpen and (now - self.lootStartTime) > WINDOW_TIMEOUT then
				self:debug("Interact produced no loot window in time - will retry")
				self.isLooting = false
			else
				return
			end
		end

		local unitGUID = br._G.UnitGUID(lootUnit)
		if not unitGUID then
			self:debug("Could not get GUID for loot unit")
			return
		end

		-- Verify unit still has loot; if it's been fully looted, clear its tracking.
		if not CanLootUnit(unitGUID) then
			self:debug("Unit no longer has loot available")
			if br.engines.enemiesEngine.lootable[lootUnit] then
				br.engines.enemiesEngine.lootable[lootUnit] = nil
			end
			self.lootOpenCount[unitGUID] = nil
			self.lootUnit = nil
			return
		end

		-- Already skip-listed: drop the selection and move on.
		if self.lootSkipList[unitGUID] then
			self.lootUnit = nil
			return
		end

		-- Unique/blocked-item detection. We only reach here when the corpse STILL has
		-- loot. If we've already OPENED its loot window MAX_LOOT_OPENS times and have bag
		-- space, the leftover can't be taken (unique / quest / already owned) — skip it
		-- so it doesn't loop forever. This counts *successful window opens*, never failed
		-- interacts, so a corpse that is merely out of range is retried indefinitely
		-- rather than being wrongly blacklisted (the old attempt-count bug).
		if (self.lootOpenCount[unitGUID] or 0) >= MAX_LOOT_OPENS and self:emptySlots() > 0 then
			self:debug("Skipping " .. (br._G.UnitName(lootUnit) or "unknown") .. " - loot remained after "
				.. MAX_LOOT_OPENS .. " window opens (likely a unique/quest item)")
			self.lootSkipList[unitGUID] = true
			if br.engines.enemiesEngine.lootable[lootUnit] then
				br.engines.enemiesEngine.lootable[lootUnit] = nil
			end
			self.lootUnit = nil
			return
		end

		-- Range + line of sight. Use the game's own interact-distance test (index 3 =
		-- interact range), mirroring the Tracker engine — far more reliable than a guessed
		-- yard threshold. A failed interact from here is transient (retried next pass) and
		-- never feeds the skip logic.
		if br._G.CheckInteractDistance and not br._G.CheckInteractDistance(lootUnit, 3) then
			self:debug("Loot unit not yet in interact range: "
				.. math.floor(br.functions.range:getDistance(lootUnit) or 99) .. " yards")
			return
		end
		if not br.functions.misc:getLineOfSight("player", lootUnit) then
			self:debug("No line of sight to loot unit")
			return
		end

		-- Respect rotation pause states (dead/eating/drinking/pause-mode/etc.).
		if br.functions.misc:pause(true) then return end

		-- Fire the interact. InteractUnit/ObjectInteract take the unit directly, so we
		-- never change the player's target to loot (no ClearTarget cleanup needed).
		local interactFunc = br._G.InteractUnit or br._G.ObjectInteract
		if not interactFunc then
			self:debug("ERROR: No interact function available (InteractUnit or ObjectInteract)")
			return
		end

		self:debug("Looting " .. (br._G.UnitName(lootUnit) or "unknown")
			.. " at " .. math.floor(br.functions.range:getDistance(lootUnit) or 0) .. " yards")
		self.lootGUID = unitGUID
		self.lootAttempts[unitGUID] = now
		self.isLooting = true
		self.lootStartTime = now
		interactFunc(lootUnit)
		-- Manual looting (when the game's auto-loot cvar is off) is handled by LOOT_OPENED.
	end

	-- Auto-loot functionality (called from rotation loop)
	function lootEngine:autoLoot()
		if not br.functions.misc:getOptionCheck("Auto Loot") then return end

		-- Single pacing throttle, driven by the "Auto Loot" spinner (delay in seconds). First, so the
		-- checks below (stealth auras, a bag scan) run at that pace rather than every tick; the
		-- in-flight isLooting/window state machine in getLoot prevents interact spam.
		local delay = br.functions.misc:getOptionValue("Auto Loot")
		if not delay or delay <= 0 then delay = 0.5 end
		if not br.debug.timer:useTimer("autoLoot", delay) then return end

		-- Combat policy: loot out of combat, or in combat only when no enemies are within
		-- 10y (e.g. AoE farming where the mobs we're looting are already dead). getLoot no
		-- longer hard-blocks on combat, so this single gate now actually governs the policy.
		if br.functions.misc:isInCombat("player") then
			if not (br.player and br.player.enemies and br.player.enemies.get) then
				return -- can't verify it's safe, don't loot in combat
			end
			local nearbyEnemies = br.player.enemies.get(10)
			if nearbyEnemies and nearbyEnemies[1] ~= nil then
				return
			end
		end

		-- Player-state gates (cheapest first).
		if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then return end -- don't interrupt casting
		if IsMounted("player") then return end                                                  -- don't loot while mounted
		if GetUnitSpeed("player") > 0 then return end                                            -- don't loot while moving
		if UnitIsDeadOrGhost("player") then return end                                           -- don't loot while dead

		-- Looting interacts with the corpse, which breaks Stealth/Prowl. Don't auto-loot
		-- while stealthed at all — respect the player's intent to stay hidden (whether for
		-- a nearby hostile, an opener, or any other reason); breaking it to grab loot would
		-- drop stealth and can get us detected and aggro'd.
		--
		-- Detected via the rotation buff API. Only the active spec's spell list is loaded,
		-- so each buff object is nil-guarded (buff.prowl is nil on a Rogue, buff.stealth is
		-- nil on a Druid). The buff API resolves ranks, so ranked Prowl is covered too.
		local pbuff = br.player and br.player.buff
		if pbuff and (
			(pbuff.prowl and pbuff.prowl.exists())
			or (pbuff.stealth and pbuff.stealth.exists())
			or (pbuff.shadowmeld and pbuff.shadowmeld.exists())
			or (pbuff.vanish and pbuff.vanish.exists())
		) then
			return -- stealthed: don't break it to loot
		end

		-- Bag space.
		if self:emptySlots() == 0 then
			local now = GetTime()
			if (now - self.lastBagWarning) > 30 then -- warn at most once per 30s
				br.ui.chatOverlay:Show("Bags are full, nothing will be looted!")
				self.lastBagWarning = now
			end
			return
		end

		-- Pick the closest lootable corpse (skip-listed GUIDs are ignored) and loot it.
		if self:lootCount() == 0 then return end
		if self.lootUnit then
			self:getLoot(self.lootUnit)
		end
	end

	-- Clean up stale loot attempts (prevent memory leak)
	function lootEngine:cleanupAttempts()
		local now = GetTime()
		for guid, timestamp in pairs(self.lootAttempts) do
			-- Remove attempts older than 30 seconds and reset their retry count
			-- (allows re-attempting a GUID encountered again after a long absence)
			if (now - timestamp) > 30 then
				self.lootAttempts[guid] = nil
				self.lootOpenCount[guid] = nil
				-- Note: lootSkipList entries are intentionally kept for the session
			end
		end
	end

	-- Get statistics about current loot state
	function lootEngine:getStats()
		local stats = {
			lootableCount = 0,
			freeSlots = self:emptySlots(),
			currentTarget = self.lootUnit,
			attemptsTracked = 0,
		}

		-- Count lootable units
		for k, _ in pairs(br.engines.enemiesEngine.lootable) do
			if br.engines.enemiesEngine.lootable[k] ~= nil then
				stats.lootableCount = stats.lootableCount + 1
			end
		end

		-- Count tracked attempts
		for _ in pairs(self.lootAttempts) do
			stats.attemptsTracked = stats.attemptsTracked + 1
		end

		return stats
	end

	-- Handle manual looting when Auto Loot game option is disabled
	function lootEngine:manuallyLootAll()
		if not br._G.LootFrame:IsShown() then return end

		local numItems = br._G.GetNumLootItems()
		if numItems == 0 then return end

		self:debug("Manually looting " .. numItems .. " items")

		-- Loot all items
		for slot = 1, numItems do
			if br._G.LootSlotHasItem(slot) then
				br._G.LootSlot(slot)
			end
		end

		-- Close loot window
		br._G.CloseLoot()
	end

	-- Handle Bind on Pickup confirmation
	function lootEngine:confirmBindOnPickup(slot)
		-- Get info about the item being looted
		local itemLink = br._G.GetLootSlotLink(slot)
		if itemLink then
			self:debug("Auto-confirming BoP loot: " .. itemLink)
		else
			self:debug("Auto-confirming BoP loot at slot " .. slot)
		end

		-- Confirm the binding
		br._G.ConfirmLootSlot(slot)

		-- After confirming BoP, check if we need to manually loot remaining items
		if br._G.GetCVar("AutoLootDefault") == "0" then
			-- Small delay to allow the confirmation to process
			br._G.C_Timer.After(0.1, function()
				lootEngine:manuallyLootAll()
			end)
		end
	end

	-- Initialize the engine (called when addon loads)
	function lootEngine:init()
		self:debug("Loot Engine initialized")

		-- Periodic cleanup, every 30 seconds
		br._G.C_Timer.NewTicker(30, function() lootEngine:cleanupAttempts() end)

		-- Register for loot events
		local eventFrame = br._G.CreateFrame("Frame")
		eventFrame:RegisterEvent("LOOT_OPENED")
		eventFrame:RegisterEvent("LOOT_CLOSED")
		eventFrame:RegisterEvent("LOOT_BIND_CONFIRM")
		eventFrame:SetScript("OnEvent", function(self, event, ...)
			if event == "LOOT_OPENED" then
				lootEngine.lootWindowOpen = true
				lootEngine.isLooting = false -- the interact succeeded; the window is up
				-- Count this successful open against the GUID we interacted with. Repeated
				-- opens with loot still remaining are how getLoot detects unlootable
				-- (unique/quest/already-owned) items — see MAX_LOOT_OPENS.
				if lootEngine.lootGUID then
					lootEngine.lootOpenCount[lootEngine.lootGUID] = (lootEngine.lootOpenCount[lootEngine.lootGUID] or 0) + 1
				end
				lootEngine:debug("Loot window opened")

				-- Remove the unit from lootable table now that loot window opened successfully
				if lootEngine.lootUnit then
					-- Find and remove the unit from the lootable table (indexed by unit token)
					if br.engines.enemiesEngine.lootable[lootEngine.lootUnit] then
						br.engines.enemiesEngine.lootable[lootEngine.lootUnit] = nil
						lootEngine:debug("Removed " .. (br._G.UnitName(lootEngine.lootUnit) or "unknown") .. " from lootable table")
					end
				end

				-- If program Auto Loot is enabled and game Auto Loot is disabled, manually loot
				if br.functions.misc:getOptionCheck("Auto Loot") and br._G.GetCVar("AutoLootDefault") == "0" then
					-- Small delay to ensure loot frame is fully populated
					br._G.C_Timer.After(0.1, function()
						lootEngine:manuallyLootAll()
					end)
				end

			elseif event == "LOOT_CLOSED" then
				lootEngine.lootWindowOpen = false
				lootEngine.isLooting = false
				lootEngine.lootStartTime = 0
				-- If the corpse we just looted is now empty, clear its open-count so the
				-- tracking starts fresh next time. If loot remains (a blocked unique item),
				-- keep the count so getLoot can skip it after MAX_LOOT_OPENS.
				if lootEngine.lootGUID and not CanLootUnit(lootEngine.lootGUID) then
					lootEngine.lootOpenCount[lootEngine.lootGUID] = nil
				end
				lootEngine.lootGUID = nil
				lootEngine.lootUnit = nil
				lootEngine:debug("Loot window closed")

			elseif event == "LOOT_BIND_CONFIRM" then
				-- Auto-confirm Bind on Pickup items when program Auto Loot is enabled
				local slot = ...
				if slot and br.functions.misc:getOptionCheck("Auto Loot") then
					lootEngine:debug("Auto-confirming BoP item at slot " .. slot)
					lootEngine:confirmBindOnPickup(slot)
				end
			end
		end)
	end
end
