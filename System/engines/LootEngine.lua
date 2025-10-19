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

	-- Note: lootable table is managed by EnemiesEngine (br.engines.enemiesEngine.lootable)
	lootEngine.lootUnit = nil         -- Current unit to loot
	lootEngine.oldMessage = nil       -- For debug message tracking
	lootEngine.lastBagWarning = 0     -- Throttle bag full warnings
	lootEngine.lootAttempts = {}      -- Track loot attempts to avoid spam
	lootEngine.isLooting = false      -- Global looting state flag
	lootEngine.lootWindowOpen = false -- Track if loot window is currently open
	lootEngine.lootStartTime = 0      -- Track when looting started for timeout
	lootEngine.metaTable = {}         -- MetaTable for the engine
	lootEngine.metaTable.__index = {
		name = "Loot Engine",
		author = "CuteOne",
	}

	setmetatable(lootEngine, lootEngine.metaTable)

	-- Debug function
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
		for k, _ in pairs(lootableTable) do
			if lootableTable[k] ~= nil then
				local thisUnit = lootableTable[k].unit
				local hasLoot = CanLootUnit(lootableTable[k].guid)
				if br.functions.unit:GetObjectExists(thisUnit) and hasLoot then
					lootCount = lootCount + 1
					-- Find the closest lootable unit instead of just the first
					local distance = br.functions.range:getDistance(thisUnit)
					if distance < closestDistance then
					closestDistance = distance
						closestUnit = thisUnit
					end
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
		if not lootUnit then return end

		-- Don't loot while in combat
		if br.functions.misc:isInCombat("player") then
			return
		end

		-- Reset isLooting flag if it's been stuck for more than 3 seconds
		if self.isLooting and (GetTime() - self.lootStartTime) > 3 then
			self:debug("Looting timeout - resetting looting state")
			self.isLooting = false
			self.lootStartTime = 0
		end

		-- Don't attempt to loot if we're already in the process of looting
		if self.isLooting or self.lootWindowOpen then
			return
		end

		local unitGUID = br._G.UnitGUID(lootUnit)
		if not unitGUID then return end

		-- Throttle loot attempts on same unit
		local now = GetTime()
		if self.lootAttempts[unitGUID] and (now - self.lootAttempts[unitGUID]) < 2 then
			return
		end

		-- If we have a unit to loot, check if it's time to loot
		if br.debug.timer:useTimer("getLoot", br.functions.misc:getOptionValue("Auto Loot")) then
			local distance = br.functions.range:getDistance(lootUnit)

			-- Check distance and line of sight
			if distance < 7 and br.functions.misc:getLineOfSight("player", lootUnit) then
				self.lootAttempts[unitGUID] = now
				self:debug("Looting " .. br._G.UnitName(lootUnit) .. " at " .. math.floor(distance) .. " yards")
				-- Use InteractUnit or ObjectInteract depending on what the unlocker provides
				local interactFunc = br._G.InteractUnit or br._G.ObjectInteract
				if interactFunc then
					self.isLooting = true
					self.lootStartTime = now
					interactFunc(lootUnit)
				end

				-- Note: Manual looting is handled by LOOT_OPENED event
				-- This ensures the loot frame is fully loaded before attempting to loot items
			else
				if distance >= 7 then
					self:debug("Unit too far for looting: " .. math.floor(distance) .. " yards")
				end
			end

			-- Clean up after looting
			if not br.functions.misc:isInCombat("player") and self.isLooting then
				ClearTarget()
			end

			return
		end
	end

	-- Auto-loot functionality (called from rotation loop)
	function lootEngine:autoLoot()
		if not br.functions.misc:getOptionCheck("Auto Loot") then return end

		-- Only loot when out of combat or no enemies nearby
		if br.functions.misc:isInCombat("player") and br.player.enemies.get(10)[1] ~= nil then
			return
		end

		-- Check if there are units to loot
		if self:lootCount() == 0 then return end

		-- Check for bag space
		local freeSlots = self:emptySlots()
		if freeSlots == 0 then
			local now = GetTime()
			-- Only show warning once every 30 seconds
			if (now - self.lastBagWarning) > 30 then
				br.ui.chatOverlay:Show("Bags are full, nothing will be looted!")
				self.lastBagWarning = now
			end
			return
		end

		-- Check various conditions before looting
		if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then
			return -- Don't interrupt casting
		end

		if IsMounted("player") then
			return -- Don't loot while mounted
		end

		if GetUnitSpeed("player") > 0 then
			return -- Don't loot while moving
		end

		if UnitIsDeadOrGhost("player") then
			return -- Don't loot while dead
		end

		-- Use timer to throttle loot attempts
		if not br.debug.timer:useTimer("lootTimer", 1) then
			return
		end

		-- All checks passed, attempt to loot
		if self.lootUnit then
			self:getLoot(self.lootUnit)
		end
	end

	-- Clean up stale loot attempts (prevent memory leak)
	function lootEngine:cleanupAttempts()
		local now = GetTime()
		for guid, timestamp in pairs(self.lootAttempts) do
			-- Remove attempts older than 30 seconds
			if (now - timestamp) > 30 then
				self.lootAttempts[guid] = nil
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

		-- Set up periodic cleanup
		local cleanupFrame = br._G.CreateFrame("Frame")
		cleanupFrame:SetScript("OnUpdate", function(self, elapsed)
			self.timeSinceLastCleanup = (self.timeSinceLastCleanup or 0) + elapsed
			if self.timeSinceLastCleanup >= 30 then -- Clean up every 30 seconds
				lootEngine:cleanupAttempts()
				self.timeSinceLastCleanup = 0
			end
		end)

		-- Register for loot events
		local eventFrame = br._G.CreateFrame("Frame")
		eventFrame:RegisterEvent("LOOT_OPENED")
		eventFrame:RegisterEvent("LOOT_CLOSED")
		eventFrame:RegisterEvent("LOOT_BIND_CONFIRM")
		eventFrame:SetScript("OnEvent", function(self, event, ...)
			if event == "LOOT_OPENED" then
				lootEngine.lootWindowOpen = true
				lootEngine:debug("Loot window opened")

				-- Remove the unit from lootable table now that loot window opened successfully
				if lootEngine.lootUnit then
					local unitGUID = br._G.UnitGUID(lootEngine.lootUnit)
					if unitGUID and br.engines.enemiesEngine.lootable[unitGUID] then
						br.engines.enemiesEngine.lootable[unitGUID] = nil
						lootEngine:debug("Removed " .. br._G.UnitName(lootEngine.lootUnit) .. " from lootable table")
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
