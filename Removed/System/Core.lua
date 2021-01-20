-- Queue Casting
if (isChecked("Queue Casting") or (br.player ~= nil and br.player.queue ~= 0)) and not UnitChannelInfo("player") then
	if castQueue() then
		return
	end
end
if (not isChecked("Queue Casting") or UnitIsDeadOrGhost("player") or not UnitAffectingCombat("player")) and br.player ~= nil and #br.player.queue ~= 0 then
	wipe(br.player.queue)
	if not isChecked("Mute Queue") then
		if not isChecked("Queue Casting") then Print("Queue System Disabled! - Queue Cleared.") end
		if UnitIsDeadOrGhost("player") then Print("Player Death Detected! - Queue Cleared.") end 
		if not UnitAffectingCombat("player") then Print("No Combat Detected! - Queue Cleared.") end
	end
end

if isCastingSpell(318763) then
	return true
end

-- Cast Spell Queue
function castQueue()
	-- Catch for spells not registering on Combat log
	if br.player ~= nil then
		if br.player.queue ~= nil and #br.player.queue > 0 and not IsAoEPending() then
			for i=1, #br.player.queue do
				local thisUnit = br.player.queue[i].target
				local debug = br.player.queue[i].debug
				local minUnits = br.player.queue[i].minUnits
				local effectRng = br.player.queue[i].effectRng
				local spellID = br.player.queue[i].id
				if createCastFunction(thisUnit,debug,minUnits,effectRng,spellID) then return end
			end
		end
	end
	return
end

function br.antiAfk()
	if br.unlocked and br.player then
		local ui = br.player.ui
		local IsHackEnabled = _G["IsHackEnabled"]
		local SetHackEnabled = _G["SetHackEnabled"]
		if ui.checked("Anti-Afk") then
			if not IsHackEnabled("antiafk") and ui.value("Anti-Afk") == 1 then
				SetHackEnabled("antiafk",true)
			end
		elseif ui.checked("Anti-Afk") and ui.value("Anti-Afk") == 2 then
			if IsHackEnabled("antiafk") then
				SetHackEnabled("antiafk",false)
			end
		end
	end
end

