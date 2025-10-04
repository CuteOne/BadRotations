local _, br = ...
br.engines.auraTracker = br.engines.auraTracker or {}
local auraTracker = br.engines.auraTracker

auraTracker.units = auraTracker.units or {}

-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

-- ProbablyEngine.module.register("tracker", {
-- 	units = { }
-- })

function auraTracker:add(guid, name, spellId, time) --Check if exists and creates if not
	if not auraTracker.units[guid] then -- Does table exists else create (same as self.(de)buff[k][thisUnit])
		auraTracker.units[guid] = {
			guid = guid,
			name = name,
			auras = { }
		}
	end
	local unit = auraTracker.units[guid] -- unit shortcut
	if br.functions.unit:GetObjectExists(unit.guid) then
        br.objectID = br._G.GetObjectWithGUID(unit.guid)
    elseif br.functions.unit:GetObjectExists("target") then
        br.objectID = br._G.GetObjectWithGUID(br._G.UnitGUID("target"))
    else
		br.objectID = br._G.GetObjectWithGUID(br._G.UnitGUID("player"))
    end
	if not unit.auras[spellId] then
		unit.auras[spellId] = {
			spellName = br._G.GetSpellInfo(spellId), --GetSpellName(spellId),
			id = spellId,
			duration = br.functions.aura:getAuraDuration(br.objectID, spellId),
			remain = br.functions.aura:getAuraRemain(br.objectID, spellId),
			refresh = br.functions.aura:getAuraRemain(br.objectID, spellId) < br.functions.aura:getAuraDuration(br.objectID, spellId) * 0.3,
			stacks = br.functions.aura:getAuraStacks(br.objectID, spellId),
			stack = 0,
			time = time
		}
		if br.explore then br.explore:BuildTree() end
	end
end

function auraTracker.remove(guid, spellId)
	if auraTracker.units[guid] then
		local unit = auraTracker.units[guid]
		if unit.auras[spellId] then
			unit.auras[spellId] = nil
			if br.explore then br.explore:BuildTree() end
		end
	end
end

function auraTracker.update(type, guid, spellId, amount, crit, name)
	if auraTracker.units[guid] then
		local unit = auraTracker.units[guid]
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
			if br.explore then br.explore:BuildTree() end
		end
	end
end

function auraTracker.onUpdate()
	if auraTracker.units ~= nil then
		for k, _ in pairs(auraTracker.units) do
			local unit = auraTracker.units[k]
			-- local name = unit.name
			local auras = unit.auras
			if br.functions.unit:GetObjectExists(unit.guid) then
                br.objectID = br._G.GetObjectWithGUID(unit.guid)
            elseif br.functions.unit:GetObjectExists("target") then
                br.objectID = br._G.GetObjectWithGUID(br._G.UnitGUID("target"))
            else
				br.objectID = br._G.GetObjectWithGUID(br._G.UnitGUID("player"))
            end
			if auras ~= nil then
				for c, _ in pairs(auras) do
					local spell = auras[c]
					spell.remain = br.functions.aura:getAuraRemain(br.objectID,c)
					spell.refresh = spell.remain < spell.duration * 0.3
				end
			end
		end
	end
end

function auraTracker.stack(guid, spellId, amount)
	if auraTracker.units[guid] then
		local unit = auraTracker.units[guid]
		if unit.auras[spellId] then
			unit.auras[spellId].stacks = amount
			if br.explore then br.explore:BuildTree() end
		end
	end
end

function auraTracker.query(guid, spellId)
	if auraTracker.units[guid] then
		local unit = auraTracker.units[guid]
		if unit.auras[spellId] then
			return unit.auras[spellId]
		end
	end
	return false
end

function auraTracker.handleEvent(...) --Adjust handleEvent to CombatLogEventUnfiltered
	local timeStamp, event, _, _, _, _,
	      _, destGUID, destName, _, _ = ...

	-- add aura
	if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event == "SPELL_PERIODIC_AURA_APPLIED" then
		local spellId, _, _ = select(12, ...)
		auraTracker.add(destGUID, destName, spellId, timeStamp)
	-- remove aura
	elseif event == "SPELL_AURA_REMOVED" or event == "SPELL_PERIODIC_AURA_REMOVED" then
		local spellId, _, _ = select(12, ...)
		auraTracker.remove(destGUID, spellId)
	elseif event == "SPELL_AURA_APPLIED_DOSE" or event == "SPELL_PERIODIC_AURA_APPLIED_DOSE"
		or event == "SPELL_AURA_REMOVED_DOSE" or event == "SPELL_PERIODIC_AURA_REMOVED_DOSE"  then
		local spellId, _, _ = select(12, ...)
		local _, amount = select(15, ...)
		auraTracker.stack(destGUID, spellId, amount)

	-- aura damage
	elseif event == "SPELL_PERIODIC_DAMAGE" then
		local spellId, _, _ = select(12, ...)
		local amount, _, _, _, _, _, critical = select(15, ...)
		auraTracker.update('damage', destGUID, spellId, amount, critical, destName)

	elseif event == "SPELL_PERIODIC_HEAL" then
		local spellId, _, _ = select(12, ...)
		local amount, _, _, _, _, _, critical = select(15, ...)
		auraTracker.update('heal', destGUID, spellId, amount, critical, destName)
	end
end