-- Retail-only work each BR tick (System/Core.lua runs br.api.pulseHooks before the rotation).
local _, br = ...

if not br.isRetail then return end

br.api.pulseHooks = br.api.pulseHooks or {}

-- Quaking (Mythic+ affix): stop a cast or channel that the quake would interrupt (Quaking Helper,
-- Expansions/Retail/Options.lua)
br.api.pulseHooks[#br.api.pulseHooks + 1] = function()
    if not br.functions.misc:getOptionCheck("Quaking Helper") then return end
    local quakingID = br.functions.spell:getHighestSpellID("quaking")
    if not (br._G.UnitChannelInfo("player") or br._G.UnitCastingInfo("player")) then return end
    local remain = br.functions.aura:getDebuffRemain("player", quakingID)
    if remain > 0 and remain < 0.5 then
        br._G.RunMacroText("/stopcasting")
    end
end
