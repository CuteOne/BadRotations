-- TBC API Compatibility Layer
-- Handles API differences in TBC
local _, br = ...

if br.client.flavour ~= "TBC" then return end

-- The unlocker's version of a game name, else the client's (Expansions/Layers.lua)
local base = br.client.base

-- C_Spell shim overrides for TBC.
-- C_Spell does not exist natively in TBC Classic (it was introduced in Shadowlands).
-- The NoName-backported C_Spell namespace returns incorrect values for cooldowns
-- and usability, causing the cast gate to fire spells too rapidly (depleting energy)
-- or to miss legitimate energy/rage checks. Override with raw _G APIs that work reliably.
do
    local cs = br.client.polyfills.C_Spell

    -- GetSpellCooldown: NN shim may return startTime==0 even when a spell is on GCD,
    -- making getSpellCD() always 0. That causes getSpellCD(spellID) <= updateRate to
    -- permanently pass, allowing multiple different spells to fire within a single GCD
    -- window and rapidly draining energy. base.GetSpellCooldown returns accurate data.
    if base.GetSpellCooldown then
        cs.GetSpellCooldown = function(spellID)
            local startTime, duration, isEnabled, modRate = base.GetSpellCooldown(spellID)
            if startTime == nil then return nil end
            return { startTime = startTime, duration = duration, isEnabled = isEnabled, modRate = modRate or 1 }
        end
    end

    -- IsSpellUsable: NN shim may return (true, false) regardless of whether the player
    -- has enough energy/rage, so spells are never blocked on resource checks.
    -- base.IsUsableSpell correctly returns (false, false) when resources are insufficient.
    if base.IsUsableSpell then
        cs.IsSpellUsable = function(spellID)
            return base.IsUsableSpell(spellID)
        end
    end
end
