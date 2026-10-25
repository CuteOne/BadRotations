-- Retail-only work each BR tick (a tick step, br.lifecycle; before the rotation).
local _, br = ...

if not br.isRetail then return end

-- Quaking (Mythic+ affix): stop a cast or channel that the quake would interrupt (Quaking Helper,
-- Expansions/Retail/Options.lua)
br.lifecycle:onTick(5, "quaking helper", function()
    if not br.functions.misc:getOptionCheck("Quaking Helper") then return end
    local quakingID = br.functions.spell:getHighestSpellID("quaking")
    if not (br.game.UnitChannelInfo("player") or br.game.UnitCastingInfo("player")) then return end
    local remain = br.functions.aura:getDebuffRemain("player", quakingID)
    if remain > 0 and remain < 0.5 then
        br.game.RunMacroText("/stopcasting")
    end
end)
