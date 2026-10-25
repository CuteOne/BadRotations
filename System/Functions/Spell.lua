local _, br = ...
---@class br.functions.spell
br.functions.spell = br.functions.spell or {}
local spell = br.functions.spell
local maxStage = 0
local hasGCDSpell = nil -- whether this client has the GCD spell (spell:getGCDSpellID), checked once

local function getEventBuffIDs()
    return br.functions.spell:getHighestSpellID("forTheAlliance"),
           br.functions.spell:getHighestSpellID("forTheHorde")
end

local function flipRace()
    local race = select(2, br._G.UnitRace("player"))
    local class = select(3, br._G.UnitClass("player"))
    local forTheAllianceID, forTheHordeID = getEventBuffIDs()
    if br.functions.aura:UnitBuffID("player", forTheAllianceID) then
        if race == "Orc" then
            return "Dwarf"
        elseif race == "Undead" then
            return "Human"
        elseif race == "Troll" then
            if class == 7 then
                return "Draenei"
            elseif class == 9 then
                return "Human"
            else
                return "NightElf"
            end
        elseif race == "Tauren" then
            if class == 11 then
                return "NightElf"
            else
                return "Draenei"
            end
        elseif race == "BloodElf" then
            if class == 12 then
                return "NightElf"
            else
                return "Human"
            end
        elseif race == "Goblin" then
            if class == 3 or class == 7 then
                return "Dwarf"
            else
                return "Gnome"
            end
        elseif race == "Pandaren" then
            return "Pandaren"
        elseif race == "HighmountainTauren" then
            if class == 11 then
                return "NightElf"
            else
                return "Draenei"
            end
        elseif race == "Nightborne" then
            if class == 9 then
                return "Human"
            else
                return "NightElf"
            end
        elseif race == "MagharOrc" then
            return "DarkIronDwarf"
        end
    elseif br.functions.aura:UnitBuffID("player", forTheHordeID) then
        if race == "Worgen" then
            return "Troll"
        elseif race == "DarkIronDwarf" then
            return "MagharOrc"
        elseif race == "Human" then
            if class == 2 then
                return "BloodElf"
            else
                return "Undead"
            end
        elseif race == "NightElf" then
            if class == 12 then
                return "BloodElf"
            else
                return "Troll"
            end
        elseif race == "Dwarf" then
            if class == 2 then
                return "Tauren"
            elseif class == 5 then
                return "Undead"
            else
                return "Orc"
            end
        elseif race == "Draenei" then
            if class == 8 then
                return "Orc"
            else
                return "Tauren"
            end
        elseif race == "Pandaren" then
            return "Pandaren"
        elseif race == "Gnome" then
            if class == 10 then
                return "BloodElf"
            else
                return "Goblin"
            end
        elseif race == "VoidElf" then
            if class == 3 or class == 5 or class == 1 then
                return "BloodElf"
            else
                return "Troll"
            end
        elseif race == "LightforgedDraenei" then
            if class == 8 then
                return "Orc"
            else
                return "Tauren"
            end
        end
    end
end

-- Look up a spell ID from br.lists.spells by key name.
-- Recursively searches all class/spec/type subtables for the key.
-- If the found value is a rank table (Classic), returns the highest known rank.
-- @param key - The spell name key as it appears in the spell list (e.g. "rake", "global")
-- @return number|nil - The spell ID, or nil if the list is not loaded or the key is not found.
-- The spell ID for a spell list key (the highest known rank of a rank list), searching every list.
-- Answers are remembered per key until the spellbook changes (clearRankCache).
-- local gcdSpell = br.functions.spell:getHighestSpellID("global")
local highestSpellIDs = {}

local NO_SPELL = {}

local racialKeys = {
	BloodElf = "arcaneTorrent", Draenei = "giftOfTheNaaru", Dwarf = "stoneform", Gnome = "escapeArtist",
	Goblin = "rocketBarrage", Human = "willToSurvive", NightElf = "shadowmeld", Pandaren = "quakingPalm",
	Tauren = "warStomp", Undead = "willOfTheForsaken", Scourge = "willOfTheForsaken", Worgen = "darkflight",
}

local spellNames = {}

-- A combo point finisher's guaranteed damage (Ferocious Bite, Eviscerate, ...), read from its tooltip
-- once per spell ID: { [combo points] = low end of the damage roll, perEnergy = damage each Energy
-- above the cost adds }, or false when the tooltip doesn't list damage per combo point. English only.
local finisherDamage = {}

-- The rank to use for a spell list entry right now: on ranked clients the highest known rank
-- of a rank list, remembered until the spellbook changes (clearRankCache, called on
-- SPELLS_CHANGED and talent/level/spec changes in Readers/common.lua). So a rank bought at a
-- trainer is picked up straight away, without a rebuild.
local currentRanks = {}

-- br.functions.spell:canInterrupt("target",20)
function spell:canInterrupt(unit, percentint)
	unit = unit or "target"
	-- M+ Affix: Beguiling (Prevents Interrupt) - Queen's Decree: Unstoppable buff
	local queensDecreeID = br.functions.spell:getHighestSpellID("queensDecreeUnstoppable")
	if br.functions.aura:UnitBuffID(unit, queensDecreeID) ~= nil then return false end
	local interruptTarget = br.functions.misc:getOptionValue("Interrupt Target")
	if interruptTarget == 2 and not br.functions.unit:GetUnitIsUnit(unit, "target") then
		return false
	elseif interruptTarget == 3 and not br.functions.unit:GetUnitIsUnit(unit, "focus") then
		return false
	elseif interruptTarget == 4 and br.functions.misc:getOptionValue("Interrupt Mark") ~= br._G.GetRaidTargetIndex(unit) then
		return false
	end
	local castStartTime, castEndTime, interruptID, interruptable = 0, 0, 0, false
	local castDuration, castTimeRemain, castPercent = 0, 0, 0
	local channelDelay = 1    -- Delay to mimick human reaction time for channeled spells
	local castType = "spellcast" -- Handle difference in logic if the spell is cast or being channeles
	local onWhitelist = false
	local whitelistOnly = br.functions.misc:isChecked("Interrupt Only Whitelist")
	if br.functions.unit:GetUnitExists(unit)
		and br._G.UnitCanAttack("player", unit)
		and not br._G.UnitIsDeadOrGhost(unit)
	then
		-- Get Cast/Channel Info
		if select(5, br._G.UnitCastingInfo(unit)) and not select(8, br._G.UnitCastingInfo(unit)) then --Get spell cast time
			_, _, _, castStartTime, castEndTime, _, _, _, interruptID = br._G.UnitCastingInfo(unit)
			-- castStartTime = select(4, br._G.UnitCastingInfo(unit))
			-- castEndTime = select(5, br._G.UnitCastingInfo(unit))
			-- interruptID = select(9, br._G.UnitCastingInfo(unit))
			interruptable = true
			castType = "spellcast"
		elseif select(5, br._G.UnitChannelInfo(unit)) and not select(7, br._G.UnitChannelInfo(unit)) then -- Get spell channel time
			_, _, _, castStartTime, castEndTime, _, _, interruptID = br._G.UnitChannelInfo(unit)
			-- castStartTime = select(4, br._G.UnitChannelInfo(unit))
			-- castEndTime = select(5, br._G.UnitChannelInfo(unit))
			-- interruptID = select(8, br._G.UnitChannelInfo(unit))
			interruptable = true
			castType = "spellchannel"
		end
		-- Assign interrupt time
		if castEndTime > 0 and castStartTime > 0 then
			castDuration = (castEndTime - castStartTime) / 1000
			castTimeRemain = ((castEndTime / 1000) - br._G.GetTime())
			if percentint == nil and castPercent == 0 then
				if castType == "spellcast" then
					castPercent = math.random(25, 75) --  I am not sure that this is working,we are doing this check every pulse so its different randoms each time
				end
				if castType == "spellchannel" then
					if castDuration > 60 then
						castPercent = 100
					else
						castPercent = math.random(95, 99)
					end
				end
			elseif percentint == 0 and castPercent == 0 then
				if castType == "spellcast" then
					castPercent = math.random(25, 75)
				end
				if castType == "spellchannel" then
					if castDuration > 60 then
						castPercent = 100
					else
						castPercent = math.random(95, 99)
					end
				end
			elseif percentint > 0 then
				if castType == "spellcast" then
					castPercent = math.random((percentint - 5), (5 + percentint))
				end
				if castType == "spellchannel" then
					if castDuration > 60 then
						castPercent = 100
					else
						castPercent = math.random(95, 99)
					end
				end
			end
		end
		-- Check if on whitelist (if selected)
		if whitelistOnly and br.lists.interruptWhitelist[interruptID] then
			onWhitelist = true
		end
		-- Return when interrupt time is met
		if ((whitelistOnly and onWhitelist) or not whitelistOnly)
			or not (br.player.state.instance == "party" or br.player.state.instance == "raid" or br.player.state.instance == "scenario")
		then
			-- Nothing interruptible is being cast; also avoids 0/0, which raises "Division by zero" on Forever
			if not interruptable or castDuration <= 0 then return false end
			local ttd = br.engines.ttdTable:getTTD(unit)
			local withinsCastPercent = math.ceil((castTimeRemain / castDuration) * 100) <= castPercent
			-- ttdTable returns negative values when unknown/unreliable; don't block interrupts in that case.
			local willFinishCast = (ttd == nil) or (ttd < 0) or (ttd > castTimeRemain)
			if castType == "spellcast" then
				if withinsCastPercent and interruptable == true and willFinishCast then
					return true
				end
			end
			if castType == "spellchannel" then
				--if (GetTime() - castStartTime/1000) > channelDelay and interruptable == true then
				if (br._G.GetTime() - castStartTime / 1000) > (channelDelay - 0.2 + math.random() * 0.4)
					and (withinsCastPercent or castPercent == 100) and interruptable == true
					and (willFinishCast or castPercent == 100)
				then
					return true
				end
			end
		end
		return false
	end
end

function spell:clearRankCache()
	br._G.wipe(currentRanks)
	br._G.wipe(highestSpellIDs)
end

function spell:currentRank(ref)
	if type(ref) ~= "table" then return ref end -- (resolveRank gives the first ID on unranked clients)
	local id = currentRanks[ref]
	if id == nil then
		id = spell:resolveRank(ref)
		currentRanks[ref] = id
	end
	return id
end

function spell:findHighestSpellID(key)
    if not br.lists or not br.lists.spells then return nil end
    local function search(t)
        for k, v in pairs(t) do
            if k == key then
                if type(v) == "table" then
                    return self:getHighestKnownRank(v)
                end
                return v
            elseif type(v) == "table" then
                local found = search(v)
                if found then return found end
            end
        end
        return nil
    end
    return search(br.lists.spells)
end

-- True when the finisher, at your combo points on thisUnit and your Energy, is sure to kill it: the
-- low end of the damage roll plus the extra Energy it converts. Attack Power adds more, but tooltips
-- don't say how much, so it's left out (an underestimate). Never true for training dummies.
-- if br.functions.spell:finisherKills(22568, "target") then
function spell:finisherKills(spellID, thisUnit)
	if thisUnit == nil then thisUnit = "target" end
	if spellID == nil or spellID == 0 or br.functions.unit:isDummy(thisUnit) then return false end
	local comboPoints = br.functions.power:getCombo(thisUnit) or 0
	if comboPoints <= 0 then return false end
	local damage = spell:getFinisherDamage(spellID)
	if not damage or not damage[comboPoints] then return false end
	-- A free finisher (Clearcasting) converts no extra Energy that we can count on
	local cost = br.functions.power:getSpellCost(spellID) or 0
	local extraEnergy = cost > 0 and math.max(0, (br._G.UnitPower("player", 3) or 0) - cost) or 0
	return damage[comboPoints] + extraEnergy * damage.perEnergy >= (br._G.UnitHealth(thisUnit) or 0)
end

function spell:getCastingRegen(spellID)
	local regenRate = br.functions.power:getRegen("player")
	local power = 0
	local desc = br._G.C_Spell.GetSpellDescription(spellID)
	local generates = desc:gsub("%D+", "")
	local tooltip = tonumber(generates:sub(-2)) or 0
	-- Get the "execute time" of the spell (larger of GCD or the cast time).
	local castTime = br.functions.cast:getCastTime(spellID) or 0
	local gcd = br.player.state.gcdMax
	local castSeconds = (castTime > gcd) and castTime or gcd
	power = power + regenRate * castSeconds + tooltip

	-- Get the amount of time remaining on the Steady Focus buff.
	local steadyFocusID = br.functions.spell:getHighestSpellID("steadyFocus")
	if br.functions.aura:UnitBuffID("player", steadyFocusID) ~= nil then
		local seconds = br.functions.aura:getBuffRemain("player", steadyFocusID)
		if seconds <= 0 then
			seconds = 0
		elseif seconds > castSeconds then
			seconds = castSeconds
		end
		-- Steady Focus increases the focus regeneration rate by 50% for its duration.
		power = power + regenRate * 1.5 * seconds + tooltip
	end
	return power
end

-- if br.functions.spell:getCharges(115399) > 0 then
function spell:getCharges(spellID)
	local chargeInfo = br._G.C_Spell.GetSpellCharges(spellID)
	return chargeInfo and chargeInfo.currentCharges or 0
end

function spell:getChargesFrac(spellID, chargeMax)
	local chargeInfo = br._G.C_Spell.GetSpellCharges(spellID)
	local charges, maxCharges, start, duration = chargeInfo.currentCharges, chargeInfo.maxCharges,
		chargeInfo.cooldownStartTime, chargeInfo.cooldownDuration
	if chargeMax == nil then chargeMax = false end
	if maxCharges ~= nil then
		if chargeMax then
			return maxCharges
		else
			if start <= br._G.GetTime() then
				local endTime = start + duration
				local percentRemaining = 1 - (endTime - br._G.GetTime()) / duration
				return charges + percentRemaining
			else
				return charges
			end
		end
	end
	return 0
end

-- Name of the race's damage racial (cast.racial), or nil if the race has none on this client.
-- local name = br.functions.spell:getDamageRacialName("Troll")
function spell:getDamageRacialName(race)
	if race == "Orc" then return "Blood Fury" end
	if race == "Troll" then return "Berserking" end
	if br.isForever then
		if race == "NightElf" then return "Elune's Light" end
		if race == "Gnome" then return "Eureka!" end
	end
	return nil
end

function spell:getEmpoweredRank(spellID)
	local stage = 0
	if br.empowerID and spellID == br.empowerID then
		local _, _, _, startTime, _, _, _, _, _, totalStages = br._G.UnitChannelInfo("player")
		if totalStages and totalStages > 0 then
			maxStage = totalStages
			startTime = startTime / 1000 -- Doing this here so we don't divide by 1000 every loop index
			local currentTime = br._G.GetTime() -- If you really want to get time each loop, go for it. But the time difference will be miniscule for a single frame loop
			local stageDuration = 0
			for i = 1, totalStages do
				stageDuration = stageDuration + br._G.GetUnitEmpowerStageDuration("player", i - 1) / 1000
				if startTime + stageDuration > currentTime then
					break -- Break early so we don't keep checking, we haven't hit this stage yet
				end
				stage = i
			end
		end
		if totalStages == nil then
			stage = maxStage
		end
	end
	return stage
end

function spell:getFinisherDamage(spellID)
	local known = finisherDamage[spellID]
	if known ~= nil then return known end
	local desc = br._G.C_Spell.GetSpellDescription(spellID) or ""
	local damage = { perEnergy = tonumber(desc:match("into ([%d%.]+) additional damage")) or 0 }
	for cp, low in desc:gmatch("(%d) points?%s*:%s*([%d,]+)") do
		damage[tonumber(cp)] = tonumber((low:gsub(",", "")))
	end
	if damage[1] == nil then damage = false end
	finisherDamage[spellID] = damage
	return damage
end

-- Full RechargeTime of a Spell/dump getFullRechargeTime(214579)
function spell:getFullRechargeTime(spellID)
	local chargeInfo = br._G.C_Spell.GetSpellCharges(spellID)
	local charges, maxCharges, chargeStart, chargeDuration = chargeInfo.currentCharges, chargeInfo.maxCharges,
		chargeInfo.cooldownStartTime, chargeInfo.cooldownDuration
	if charges then
		local currentChargeTime = (charges or 0) < (maxCharges or 0) and
			chargeDuration - (br._G.GetTime() - (chargeStart or 0)) or 0
		local leftChargesTotalTime = (maxCharges - charges - 1) * chargeDuration
		if charges ~= maxCharges then
			return currentChargeTime + leftChargesTotalTime
		end
	end
	return 0
end

-- The spell whose cooldown is the global cooldown (br.lists.globalCooldown): the client's GCD
-- spell, or a class spell on clients without it.
-- local gcd = br.functions.spell:getSpellCD(br.functions.spell:getGCDSpellID())
function spell:getGCDSpellID()
	local list = br.lists.globalCooldown
	if hasGCDSpell == nil then
		hasGCDSpell = br._G.C_Spell.GetSpellInfo(list.spell) ~= nil
	end
	if hasGCDSpell then return list.spell end
	local _, class = br._G.UnitClass("player")
	return class and list.byClass[class] or list.byClass.DRUID
end

function spell:getGlobalCD(max)
	local currentSpecName = br.loader.selectedSpec
	if currentSpecName == "" then currentSpecName = "Initial" end
	if max == true then
		if currentSpecName == "Feral" or currentSpecName == "Brewmaster" or currentSpecName == "Windwalker" or br._G.UnitClass("player") == "Rogue" then
			return 1
		else
			return math.max(math.max(1, 1.5 / (1 + br._G.UnitSpellHaste("player") / 100)), 0.75)
		end
	end
	return br.functions.spell:getSpellCD(spell:getGCDSpellID())
end

-- Get the highest known rank of a spell from a spell ID table or single ID
-- @param spellIDOrTable - A spell ID (number) or table of spell IDs {rank1, rank2, ...}
-- @return spellID - The highest rank spell ID that the player knows, or the original ID if not a table
function spell:getHighestKnownRank(spellIDOrTable)
    if not br.api.hasSpellRanks then
        return type(spellIDOrTable) == "table" and spellIDOrTable[1] or spellIDOrTable
    end

    -- If it's not a table, just return it
    if type(spellIDOrTable) ~= "table" then
        return spellIDOrTable
    end

    -- It's a table of ranks - find the highest known one
    for i = #spellIDOrTable, 1, -1 do
        local rankID = spellIDOrTable[i]
        if self:isKnown(rankID) then
            return rankID
        end
    end

    -- No rank known, return the first rank (base)
    return spellIDOrTable[1]
end

function spell:getHighestSpellID(key)
    local known = highestSpellIDs[key]
    if known ~= nil then
        if known == NO_SPELL then return nil end
        return known
    end
    local found = spell:findHighestSpellID(key)
    -- Only once the player's spells are compiled: before that the class lists may not be loaded yet
    if br.player and br.player.spells then highestSpellIDs[key] = found == nil and NO_SPELL or found end
    return found
end

-- Get the current rank the player knows for a spell
-- @param spellIDOrTable - A spell ID (number) or table of spell IDs
-- @return number - The highest rank number known (1-based), or 0 if none known
function spell:getKnownRank(spellIDOrTable)
    if not br.api.hasSpellRanks then
        return self:isKnown(type(spellIDOrTable) == "table" and spellIDOrTable[1] or spellIDOrTable) and 1 or 0
    end

    -- If it's not a table, check if we know it
    if type(spellIDOrTable) ~= "table" then
        return self:isKnown(spellIDOrTable) and 1 or 0
    end

    -- Find the highest known rank
    for i = #spellIDOrTable, 1, -1 do
        if self:isKnown(spellIDOrTable[i]) then
            return i
        end
    end

    return 0
end

-- A spell's name by ID. Names don't change, so each is asked for once (unknown IDs aren't kept).
-- local name = br.functions.spell:getName(5176)
function spell:getName(spellID)
	if spellID == nil or type(spellID) == "table" then return nil end -- a rank list isn't one spell
	local name = spellNames[spellID]
	if name == nil then
		local info = br._G.C_Spell.GetSpellInfo(spellID)
		name = info and info.name
		spellNames[spellID] = name
	end
	return name
end

function spell:getRacial(thisRace)
    local forTheAllianceID, forTheHordeID = getEventBuffIDs()
    local forTheAlliance = br.functions.aura:UnitBuffID("player", forTheAllianceID) or false
    local forTheHorde    = br.functions.aura:UnitBuffID("player", forTheHordeID)    or false
    local race = select(2, br._G.UnitRace("player"))
    if forTheAlliance or forTheHorde then
        race = flipRace()
    end

    -- Racial IDs from the list (br.lists.racials)
    local r = (br.lists and br.lists.racials) or {}

    -- Three racials have IDs that vary by rank/level and must be resolved dynamically.
    -- In Classic/TBC, GetSpellInfo(GetSpellInfo(id)) resolved the highest known rank by name.
    -- In Retail, C_Spell.GetSpellInfo does not accept name-string lookups, so the double-lookup
    -- returns nil and falls back to the player's own racial.  Use a direct lookup instead;
    -- retail has no spell ranks so baseID is already the canonical spell ID.
    local BloodElfRacial, DraeneiRacial, OrcRacial
    if race == "BloodElf" or race == thisRace then
        local baseID = r._bloodElfBase
        BloodElfRacial = spell:getSpellID(baseID)
    end
    if race == "Draenei" or race == thisRace then
        local baseID = r._draeneiBase
        DraeneiRacial = spell:getSpellID(baseID)
    end
    if race == "Orc" or race == thisRace then
        local baseID = r._orcBase
        OrcRacial = spell:getSpellID(baseID)
    end

    local racialSpells = {
        -- Alliance
        Dwarf              = r.Dwarf,              -- Stoneform
        Gnome              = r.Gnome,              -- Escape Artist
        Draenei            = r.Draenei or DraeneiRacial, -- Gift of the Naaru
        Human              = r.Human,              -- Every Man for Himself
        NightElf           = r.NightElf,           -- Shadowmeld
        Worgen             = r.Worgen,             -- Darkflight
        -- Horde
        BloodElf           = r.BloodElf or BloodElfRacial, -- Arcane Torrent
        Goblin             = r.Goblin,             -- Rocket Barrage
        Orc                = r.Orc or OrcRacial,   -- Blood Fury
        Tauren             = r.Tauren,             -- War Stomp
        Troll              = r.Troll,              -- Berserking
        Scourge            = r.Scourge,            -- Will of the Forsaken
        -- Both
        Pandaren           = r.Pandaren,           -- Quaking Palm
        -- Allied Races
        HighmountainTauren = r.HighmountainTauren, -- Bull Rush
        LightforgedDraenei = r.LightforgedDraenei, -- Light's Judgment
        Nightborne         = r.Nightborne,         -- Arcane Pulse
        VoidElf            = r.VoidElf,            -- Spatial Rift
        DarkIronDwarf      = r.DarkIronDwarf,      -- Fireblood
        MagharOrc          = r.MagharOrc,          -- Ancestral Call
        ZandalariTroll     = r.ZandalariTroll,     -- Regeneratin'
        KulTiran           = r.KulTiran,           -- Haymaker
        Vulpera            = r.Vulpera,            -- Bag of Tricks
        Mechagnome         = r.Mechagnome,         -- Hyper Organic Light Originator
    }
    -- Every expansion reads the same map from its own br.lists.racials. Classic-era clients
    -- used to read a separate table holding only Draenei and Night Elf, so cast.racial()
    -- never resolved for any other race there. Races an expansion doesn't list stay nil.
    if thisRace ~= nil and racialSpells[thisRace] ~= nil then return racialSpells[thisRace] end
    return racialSpells[race]
end

-- ===========================
-- SPELL RANK SYSTEM (CLASSIC)
-- ===========================

-- Spell list key of a race's utility racial (e.g. "stoneform"), or nil. Race is UnitRace's token;
-- "Scourge" is accepted for Undead.
-- local key = br.functions.spell:getRacialKey("Dwarf")
function spell:getRacialKey(race)
	return racialKeys[race]
end

function spell:getRecharge(spellID, chargeMax)
	local chargeInfo = br._G.C_Spell.GetSpellCharges(spellID)
	local charges, maxCharges, chargeStart, chargeDuration = chargeInfo.currentCharges, chargeInfo.maxCharges,
		chargeInfo.cooldownStartTime, chargeInfo.cooldownDuration
	if chargeMax then return chargeDuration end
	if charges then
		if charges < maxCharges then
			local chargeEnd = chargeStart + chargeDuration
			return chargeEnd - br._G.GetTime()
		end
		return 0
	end
end

-- if br.functions.spell:getSpellCD(12345) <= 0.4 then
function spell:getSpellCD(SpellID)
	if SpellID == nil then return false end
	local spellCD = br._G.C_Spell.GetSpellCooldown(SpellID)
	if spellCD == nil or spellCD.startTime == 0 then
		return 0
	else
		local MyCD = spellCD.startTime + spellCD.duration - br._G.GetTime()
		MyCD = MyCD or 0 -- br.functions.misc:getLatency()
		if MyCD < 0 then MyCD = 0 end
		return MyCD
	end
end

-- Resolve a spell reference (id, name, or BR spell table with .id) to an id or name.
-- local id = br.functions.spell:getSpellIdFromRef(br.player.spell.regrowth)
-- The spell ID the client answers for an ID or a name (by name: the highest rank the player knows)
-- local id = br.functions.spell:getSpellID("Wrath")
function spell:getSpellID(spellIDOrName)
	if spellIDOrName == nil or type(spellIDOrName) == "table" then return nil end
	local info = br._G.C_Spell.GetSpellInfo(spellIDOrName)
	return info and info.spellID
end

function spell:getSpellIdFromRef(spellRef)
	if spellRef == nil then return nil end
	local refType = type(spellRef)
	if refType == "number" or refType == "string" then
		return spellRef
	end
	if refType == "table" then
		-- A spell list entry with ranks ({rank1ID, rank2ID, ...}): the highest rank the player knows
		if type(spellRef[1]) == "number" then
			return spell:getHighestKnownRank(spellRef)
		end
		if type(spellRef.id) == "function" then
			local ok, value = pcall(spellRef.id)
			if ok and value ~= nil then
				return value
			end
		elseif type(spellRef.id) == "number" then
			return spellRef.id
		end
	end
	return nil
end

function spell:getSpellRange(spellID, option)
	local info = br._G.C_Spell.GetSpellInfo(spellID)
	local maxRange = info and info.maxRange
	if maxRange == nil or maxRange == 0 then maxRange = 5 else maxRange = tonumber(maxRange) end
	-- Modifiers
	local rangeMod = 0
	-- Balance Affinity range change (Druid - Not Balance)
	if br.player ~= nil then
		if br.player.talent.balanceAffinity ~= nil then
			if br.player.talent.balanceAffinity and option ~= "noMod" then
				rangeMod = 5
			end
		end
	end
	return maxRange + rangeMod
end

-- The spell ID to cast when a profile asks for a rank (cast.<spell>.rank(n)): that rank, or the
-- highest known rank below it, as a player without that rank would use. When no rank up to it is
-- known, the rank asked for (the cast engine then reports it as not known). On clients without
-- ranks, or for a single ID, the spell list entry as it is.
-- @param spellIDOrTable - A spell ID (number) or table of spell IDs {rank1, rank2, ...}
-- @param rank - The rank number (1-based index)
function spell:getSpellRank(spellIDOrTable, rank)
    if not br.api.hasSpellRanks or type(spellIDOrTable) ~= "table" then return spellIDOrTable end
    local asked = math.max(1, math.min(tonumber(rank) or 1, #spellIDOrTable))
    for i = asked, 1, -1 do
        if self:isKnown(spellIDOrTable[i]) then return spellIDOrTable[i] end
    end
    return spellIDOrTable[asked]
end

function spell:getSpellType(spellName)
	if spellName == nil then return "Invalid" end
	local helpful = br._G.C_Spell.IsSpellHelpful(spellName) or false
	local harmful = br._G.C_Spell.IsSpellHarmful(spellName) or false
	if helpful and not harmful then return "Helpful" end
	if harmful and not helpful then return "Harmful" end
	if helpful and harmful then return "Both" end
	if not helpful and not harmful then return "Unknown" end
end

function spell:isKnown(spellID)
	if spellID == nil then return false end

	-- In Classic/TBC, spell ID is rank-specific so check by ID not by name
	if br.api.hasSpellRanks then
		-- Check if this specific spell ID is known
		return br._G.IsPlayerSpell(tonumber(spellID)) or br._G.IsSpellKnown(spellID) or br.functions.spell:isSpellInSpellbook(spellID, "spell")
	end

	-- For non-Classic, use the existing logic
	local spellName = spell:getName(spellID)
	local inBook = false
	if br._G.GetSpellBookItemInfo then
		inBook = br._G.GetSpellBookItemInfo(tostring(spellName)) ~= nil
	else
		-- Fallback to slot-based lookup if modern API missing
		inBook = br.functions.spell:isSpellInSpellbook(spellID, "spell")
	end
	return inBook or br._G.IsPlayerSpell(tonumber(spellID)) or br._G.IsSpellKnown(spellID) or br.functions.spell:isSpellInSpellbook(spellID,"spell")
end

-- Check whether a spell ID is a spell list entry or one of its ranks
-- @param spellID - The spell ID to look for
-- @param spellIDOrTable - A spell ID (number) or table of spell IDs {rank1, rank2, ...}
-- @return boolean - True when spellID is the entry (or one of its ranks)
function spell:isRankOf(spellID, spellIDOrTable)
    if type(spellIDOrTable) ~= "table" then
        return spellIDOrTable == spellID
    end
    for _, rankID in ipairs(spellIDOrTable) do
        if rankID == spellID then return true end
    end
    return false
end

function spell:isSpellInSpellbook(spellID, spellType)
	local spellSlot = br._G.FindSpellBookSlotBySpellID
		and br._G.FindSpellBookSlotBySpellID(spellID, spellType == "pet" and true or false)
	if spellSlot then
		-- Enum.SpellBookSpellBank does not exist on Classic-era clients (TBC, Classic).
		-- Fall back to the WoW global string constants "PET" / "SPELL" in that case.
		local petBank    = (Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Pet)    or "PET"
		local playerBank = (Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player) or "SPELL"
		local bank = (spellType == "pet") and petBank or playerBank

		-- Try modern API first if available
		if br._G.C_SpellBook and br._G.C_SpellBook.GetSpellBookItemInfo then
			local spellBookItemInfo = br._G.C_SpellBook.GetSpellBookItemInfo(spellSlot, bank)
			if spellBookItemInfo and spellBookItemInfo.actionID then
				return spellBookItemInfo.actionID == spellID
			end
		end
		-- Older API fallback (TBC / Classic: GetSpellBookItemInfo(slot, "PET" | "SPELL"))
		if br._G.GetSpellBookItemInfo then
			local itemType, id = br._G.GetSpellBookItemInfo(spellSlot, bank)
			if id == spellID then return true end
		end
		-- FindSpellBookSlotBySpellID returned a slot for this exact spell ID, so the
		-- spell IS in the book even if the secondary ID-verify calls above can't confirm.
		return true
	end
	return false
end

-- if br.functions.spell:isKnown(106832) then
-- function spell:isKnown(spellID)
-- 	local baseSpellID = br.api.wow.FindBaseSpellByID(spellID)
-- 	local _, _, spellInBookType = br.functions.spell:getSpellInSpellBook(spellID)
-- 	return spellID ~= nil and spellInBookType ~= "Future Spell" and
-- 		( --[[spellInBookType ~= nil or]] br._G.IsPlayerSpell(tonumber(spellID))
-- 			or br._G.IsSpellKnown(spellID) or br._G.IsPlayerSpell(tonumber(baseSpellID) or br._G.IsSpellKnown(baseSpellID))) -- or spellInBookType == "Spell")
-- end

-- Check whether a shapeshift form is a tanking form (Bear Form, Dire Bear Form or Defensive Stance
-- in the spell list)
-- @param formSpellID - The form's spell ID
-- @return boolean
function spell:isTankForm(formSpellID)
    local spells = br.player and br.player.spells
    if spells == nil or formSpellID == nil then return false end
    return spell:isRankOf(formSpellID, spells.bearForm) or spell:isRankOf(formSpellID, spells.direBearForm)
        or spell:isRankOf(formSpellID, spells.defensiveStance)
end

-- Highest known rank from a table of rank IDs (first rank if none known); non-tables pass through.
-- local id = br.functions.spell:resolveRank({ 5176, 5177, 5178 })
function spell:resolveRank(id)
	if type(id) ~= "table" then return id end
	return spell:getHighestKnownRank(id) or id[1]
end
