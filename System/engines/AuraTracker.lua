-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

-- ProbablyEngine.module.register("tracker", {
-- 	units = { }
-- })

if br.tracker == nil then br.tracker = {} end
if br.tracker ~= nil then
	if br.tracker.units == nil then br.tracker.units = {} end
end

-- local DiesalGUI = LibStub("DiesalGUI-1.0")
-- local explore = DiesalGUI:Create('TableExplorer')
-- explore:SetTable("Aura Tracker", br.tracker.units, 5)

-- local tracker = ProbablyEngine.module.tracker
local tracker = br.tracker

function tracker.add(guid, name, spellId, time) --Check if exists and creates if not
	if not tracker.units[guid] then -- Does table exists else create (same as self.(de)buff[k][thisUnit])
		tracker.units[guid] = { 
			guid = guid,
			name = name,
			auras = { }
		}
	end
	local unit = tracker.units[guid] -- unit shortcut
	if GetObjectExists(unit.guid) then
        objectID = GetObjectWithGUID(unit.guid)
    elseif GetObjectExists("target") then
        objectID = GetObjectWithGUID(UnitGUID("target"))
    else
    	objectID = GetObjectWithGUID(UnitGUID("player"))
    end
	if not unit.auras[spellId] then
		unit.auras[spellId] = {
			spellName = GetSpellInfo(spellId), --GetSpellName(spellId),
			id = spellId,
			duration = getAuraDuration(objectID, spellId),
			remain = getAuraRemain(objectID, spellId),
			refresh = getAuraRemain(objectID, spellId) < getAuraDuration(objectID, spellId) * 0.3,
			stacks = getAuraStacks(objectID, spellId),
			stack = 0,
			time = time
		}
		if explore then explore:BuildTree() end
	end
end

function tracker.remove(guid, spellId)
	if tracker.units[guid] then
		local unit = tracker.units[guid]
		if unit.auras[spellId] then
			unit.auras[spellId] = nil
			if explore then explore:BuildTree() end
		end
	end
end

function tracker.update(type, guid, spellId, amount, crit, name)
	if tracker.units[guid] then
		local unit = tracker.units[guid]
		if unit.auras[spellId] then
			local spell = unit.auras[spellId]
			-- -- spell.remain = getAuraRemain(name, spellId)
			-- spell.refresh = getAuraRemain(name, spellId) < getAuraDuration(name, spellId) * 0.3
			-- spell.stacks = getAuraStacks(name, spellId)
			if not spell[type] then
				spell[type] = {
					total = 0,
					avg = 0,
					count = 0,
					last = 0,
					low = 0,
					high = 0,
					crit = false,
					crits = 0,
				}
			end
			local track = spell[type]
			track.last = amount
			track.total = track.total + amount
			track.count = track.count + 1
			track.avg = track.total / track.count
			if amount > track.high then
				track.high = amount
				if track.low == 0 then
					track.low = amount
				end
			end
			if amount < track.low then
				track.low = amount
			end
			if crit then
				track.crits = track.crits + 1
				track.crit = true
			else
				track.crit = false
			end
			if explore then explore:BuildTree() end
		end
	end
end

function tracker.onUpdate()
	if tracker.units ~= nil then
		for k, v in pairs(tracker.units) do
			local unit = tracker.units[k]
			local name = unit.name
			local auras = unit.auras
			if GetObjectExists(unit.guid) then
                objectID = GetObjectWithGUID(unit.guid)
            elseif GetObjectExists("target") then
                objectID = GetObjectWithGUID(UnitGUID("target"))
            else
            	objectID = GetObjectWithGUID(UnitGUID("player"))
            end
			if auras ~= nil then
				for c, b in pairs(auras) do
					local spell = auras[c]
					spell.remain = getAuraRemain(objectID,c)
					spell.refresh = spell.remain < spell.duration * 0.3
				end
			end
		end
	end 
end

function tracker.stack(guid, spellId, amount)
	if tracker.units[guid] then
		local unit = tracker.units[guid]
		if unit.auras[spellId] then
			unit.auras[spellId].stacks = amount
			if explore then explore:BuildTree() end
		end
	end
end

function tracker.query(guid, spellId)
	if tracker.units[guid] then
		local unit = tracker.units[guid]
		if unit.auras[spellId] then
			return unit.auras[spellId]
		end
	end
	return false
end

function tracker.handleEvent(...) --Adjust handleEvent to CombatLogEventUnfiltered 
	local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags,
	      sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...

	-- add aura
	if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event == "SPELL_PERIODIC_AURA_APPLIED" then
		local spellId, spellName, spellSchool = select(12, ...)
		local auraType, amount = select(15, ...)
		tracker.add(destGUID, destName, spellId, timeStamp)
		-- tracker.duration(destGUID, spellId, destName)
		-- tracker.remain(destGUID, spellId, destName)
	-- remove aura 
	elseif event == "SPELL_AURA_REMOVED" or event == "SPELL_PERIODIC_AURA_REMOVED" then
		local spellId, spellName, spellSchool = select(12, ...)
		local auraType, amount = select(15, ...)
		tracker.remove(destGUID, spellId, timeStamp)
	elseif event == "SPELL_AURA_APPLIED_DOSE" or event == "SPELL_PERIODIC_AURA_APPLIED_DOSE"
		or event == "SPELL_AURA_REMOVED_DOSE" or event == "SPELL_PERIODIC_AURA_REMOVED_DOSE"  then
		local spellId, spellName, spellSchool = select(12, ...)
		local auraType, amount = select(15, ...)
		tracker.stack(destGUID, spellId, amount)

	-- aura damage
	elseif event == "SPELL_PERIODIC_DAMAGE" then
		local spellId, spellName, spellSchool = select(12, ...)
		local amount, overkill, school, resisted, blocked, absorbed, critical = select(15, ...)
		tracker.update('damage', destGUID, spellId, amount, critical, destName)

	elseif event == "SPELL_PERIODIC_HEAL" then
		local spellId, spellName, spellSchool = select(12, ...)
		local amount, overkill, school, resisted, blocked, absorbed, critical = select(15, ...)
		tracker.update('heal', destGUID, spellId, amount, critical, destName)
	end
end