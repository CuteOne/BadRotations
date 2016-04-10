--- Adds objects which should be clicked/gathered
--  Helpful for things like dailies, garrison, ...
--  Usage:
--  Only add objects for the specific map ! this reduces unneeded check cycles
--  Table order: { OBJECT_ID / OBJECT_NAME, INTERACT_RANGE }
--  Make sure you use objectID as it is language independent, try to use name only if id is not known
--  Currently there is no known way to detect interact range, so you have to set it manually
function bb.helper:getObjectNodes()
    -- Garrison
    -- Check if Continent = Draenor and SubMap is Shadowmoon Valley
    if GetCurrentMapContinent() == 7 and GetCurrentMapZone() == 5 then
        insertTableIntoTable(self.objectNodes, {
            -- Cache (one for each faction?)
            {236916, 6}, -- Garrison Cache
            {237723, 6}, -- Hefty Garrison Cache
            {237722, 6}, -- Full Garrison Cache
            {237191, 6}, -- Garrison Cache
            {237720, 6}, -- Hefty Garrison Cache
            {237724, 6}, -- Full Garrison Cache
            -- Work Order
            {236638, 6}, -- Alchemy Work Order
            {235886, 6}, -- Work Order: Mine
            {235885, 6}, -- Work Order: Herb Garden
            {236683, 6}, -- Jewelcrafting Work Order
            {237027, 6}, -- Trading Post Work Order
            {239066, 6}, -- Dwarven Bunker Work Order
            {237666, 6}, -- Tailoring Work Order
        })
    end

    -- Draenor
    if GetCurrentMapContinent() == 7 then
        -- Tanaan Jungle
        if GetCurrentMapZone() == 11 then
            insertTableIntoTable(self.objectNodes, {
                -- Treasure
                {243796, 6}, -- Suspiciously Glowing Chest
                -- Fel Forge
                {241669, 5}, -- Siege Equipment Blueprints
                {241728, 6}, -- Reckless Power
                {241507, 5}, -- Ironbound Crate
                --
                {241283, 4}, -- Rage Potion
                -- Templ of Sha naar
                {240165, 6}, -- Grimoire of Haste
                {240173, 6}, -- Sargerei Soulcharger
            })
        end

    end

end