-- TBC API Compatibility Layer
-- Handles API differences in TBC
local _, br = ...

if br.api.expansion ~= "TBC" then return end

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
