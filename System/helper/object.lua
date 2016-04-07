--- Adds objects which should be clicked/gathered
--  Helpful for things like dailies, garrison, ...
--  Usage:
--  Only add objects for the specific map ! this reduces unneeded check cycles
--  Table order: { OBJECT_ID / OBJECT_NAME, INTERACT_RANGE }
--  Make sure you use objectID as it is language independent, tzry to use name only if id is not known
--  Currently there is no known way to detect interact range, so you have to set it manually
function bb.helper:getObjectNodes()
    -- Garrison
    -- Check if Continent = Draenor and SubMap is Shadowmoon Valley
    if GetCurrentMapContinent() == 7 and GetCurrentMapZone() == 5 then
        insertTableIntoTable(self.objectNodes, {
            {235886, 6}, -- Work Order: Mine
            {235885, 6}, -- Work Order: Herb Garden
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
            })
        end

    end

end