-- TBC API Compatibility Layer
-- Handles API differences in TBC
local _, br = ...

if not br.isBC then return end

-- Capability flags for TBC
br.api.hasSpellRanks = true        -- spells have rank-specific IDs
br.api.hasSubSpecs   = false       -- no talent specialization subfolders
br.api.comboPointsOnTarget = true  -- combo points are stored on the target, lost on switch
br.api.expansion = "TBC"

local api = br.api.wow

-- IsPassiveSpell, HookTooltipSet*, UnitInPhase, GetNumQuestLogEntries, GetQuestLogTitle,
-- FindBaseSpellByID, GCDSpells/GetGCDSpellID, and C_Spell shims are all provided by
-- shared.lua. GetSpellInfo is overridden below to fix the TBC field swap.
-- GetSpellInfo wrapper
-- TBC: C_Spell.GetSpellInfo returns a table (like Retail)
-- Returns: name, rank, iconID, castTime, minRange, maxRange, spellID, originalIconID
-- NOTE: TBC API has minRange/maxRange swapped in the table!
api.GetSpellInfo = function(spellIdentifier)
    if not spellIdentifier then return nil end

    -- GetSpellInfo doesn't accept tables, only numbers or strings
    if type(spellIdentifier) == "table" then return nil end

    -- Try C_Spell first (TBC has this like Retail)
    if _G.C_Spell and _G.C_Spell.GetSpellInfo then
        local spellInfo = _G.C_Spell.GetSpellInfo(spellIdentifier)
        if spellInfo and type(spellInfo) == "table" then
            -- TBC BUG FIX: minRange and maxRange are swapped in the TBC API
            -- spellInfo.minRange actually contains maxRange, and vice versa
            return spellInfo.name,
                   nil,
                   spellInfo.iconID,
                   spellInfo.castTime,
                   spellInfo.maxRange,  -- Swapped: use maxRange field for minRange
                   spellInfo.minRange,  -- Swapped: use minRange field for maxRange
                   spellInfo.spellID,
                   spellInfo.originalIconID
        end
    end

    -- Fallback to global GetSpellInfo if C_Spell not available
    if _G.GetSpellInfo then
        return _G.GetSpellInfo(spellIdentifier)
    end

    return nil
end

-- Talent System - TBC uses tier/column system
api.getTalentInfo = function(spec, spellTalents)
    local talents = {}

    -- -- Initial profiles (spec > 1400) don't have talents
    -- if spec > 1400 then return talents end

    -- local activeSpecGroup = _G.C_SpecializationInfo and _G.C_SpecializationInfo.GetActiveSpecGroup and _G.C_SpecializationInfo.GetActiveSpecGroup()
    -- if not activeSpecGroup then return talents end

    -- -- TBC talents: 7 tiers x 3 columns
    -- for tier = 1, 7 do
    --     for column = 1, 3 do
    --         local info = _G.C_SpecializationInfo and _G.C_SpecializationInfo.GetTalentInfo and
    --                      _G.C_SpecializationInfo.GetTalentInfo({ tier = tier, column = column, specializationIndex = activeSpecGroup })
    --         if info and info.spellID then
    --             talents[info.spellID] = {
    --                 active = info.selected and true or false,
    --                 rank = 0, -- TBC talents don't expose rank
    --                 tier = tier,
    --                 column = column,
    --             }
    --         end
    --     end
    -- end

    return talents
end

-- C_Spell shim overrides for TBC.
-- C_Spell does not exist natively in TBC Classic (it was introduced in Shadowlands).
-- The NoName-backported C_Spell namespace returns incorrect values for cooldowns
-- and usability, causing the cast gate to fire spells too rapidly (depleting energy)
-- or to miss legitimate energy/rage checks. Override with raw _G APIs that work reliably.
do
    local cs = br.api.wow.C_Spell

    -- GetSpellCooldown: NN shim may return startTime==0 even when a spell is on GCD,
    -- making getSpellCD() always 0. That causes getSpellCD(spellID) <= updateRate to
    -- permanently pass, allowing multiple different spells to fire within a single GCD
    -- window and rapidly draining energy. _G.GetSpellCooldown returns accurate data.
    if _G.GetSpellCooldown then
        cs.GetSpellCooldown = function(spellID)
            local startTime, duration, isEnabled, modRate = _G.GetSpellCooldown(spellID)
            if startTime == nil then return nil end
            return { startTime = startTime, duration = duration, isEnabled = isEnabled, modRate = modRate or 1 }
        end
    end

    -- IsSpellUsable: NN shim may return (true, false) regardless of whether the player
    -- has enough energy/rage, so spells are never blocked on resource checks.
    -- _G.IsUsableSpell correctly returns (false, false) when resources are insufficient.
    if _G.IsUsableSpell then
        cs.IsSpellUsable = function(spellID)
            return _G.IsUsableSpell(spellID)
        end
    end
end

-- FindSpellOverrideByID: Retail API for talent-overridden spells (e.g. Condemn replaces Execute).
-- TBC has no spell override system. Stub it to return the input ID so gateSpellID's
-- identity check always passes and castingSpell's condemn patch is never triggered.
if not _G.FindSpellOverrideByID then
	_G.FindSpellOverrideByID = function(id) return id end
end

-- Print version info on load
if br.api.compat.getVersionInfo then
    local versionInfo = br.api.compat:getVersionInfo()
    print("|cffA330C9BadRotations|r |cffFFFFFFAPI:|r TBC compatibility layer loaded (Build: " .. versionInfo.build .. ")")
end
