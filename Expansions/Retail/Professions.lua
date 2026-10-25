-- Retail-only Profession Helper steps (System/Misc/ProfessionHelper) and fishing bait. Options:
-- Expansions/Retail/Options.lua (Other Features).
local _, br = ...

if not br.isRetail then return end

local LEATHER_SCRAPS = 110610 -- Raw Beast Hide Scraps (Warlords of Draenor): ten combine into a hide
local SCRAPS_NEEDED = 10
-- Battle for Azeroth fish that turn into Aromatic Fish Oil
local OIL_FISH = {
    [152543] = true, -- Sand Shifter
    [152544] = true, -- Slimy Mackerel
    [152545] = true, -- Frenzied Fangtooth
    [152546] = true, -- Lane Snapper
    [152547] = true, -- Great Sea Catfish
    [152548] = true, -- Tiragarde Perch
    [152549] = true, -- Redtail Loach
    [168646] = true, -- Mauve Stinger
}
-- Shadowlands fishing bait, in the Bait option's order: the item and the buff it gives
local BAITS = {
    { item = 173038, buff = 331688 }, -- Lost Sole Bait
    { item = 173040, buff = 331690 }, -- Silvergill Pike Bait
    { item = 173041, buff = 331695 }, -- Pocked Bonefish Bait
    { item = 173039, buff = 331692 }, -- Iridescent Amberjack Bait
    { item = 173042, buff = 331699 }, -- Spinefin Piranha Bait
    { item = 173043, buff = 331698 }, -- Elysian Thade Bait
}

br.api.professionSteps = br.api.professionSteps or {}
local steps = br.api.professionSteps

-- Leather Scraps
steps[#steps + 1] = function(_, totals)
    if not br.functions.misc:isChecked("Leather Scraps") then return false end
    if (totals[LEATHER_SCRAPS] or 0) >= SCRAPS_NEEDED and br._G.IsUsableItem(LEATHER_SCRAPS) then
        br._G.UseItemByName(LEATHER_SCRAPS)
        return true
    end
    return false
end

-- Fish Oil
steps[#steps + 1] = function(slots)
    if not br.functions.misc:isChecked("Fish Oil") then return false end
    for i = 1, #slots do
        local itemID = slots[i].itemID
        if OIL_FISH[itemID] and br._G.IsUsableItem(itemID) then
            br._G.UseItemByName(itemID)
            return true
        end
    end
    return false
end

-- Bait: kept up every tick, with or without Profession Helper
br.lifecycle:onTick(5, "fishing bait", function()
    if not br.functions.misc:isChecked("Bait") then return end
    local bait = BAITS[br.functions.misc:getValue("Bait")]
    if bait and br.functions.item:hasItem(bait.item) and br.functions.aura:getBuffRemain("player", bait.buff) == 0
        and br.functions.item:canUseItem(bait.item)
    then
        br.functions.item:useItem(bait.item)
    end
end)
