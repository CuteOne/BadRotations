--- Checks which herb nodes can be gathered
--  and puts them into the global table
--  Uses a range of 6y
function bb.helper:getHerbalismNodes()
    -- Garrison
    -- Check if Continent = Draenor and SubMap is Shadowmoon Valley
    if GetCurrentMapContinent() == 7 and GetCurrentMapZone() == 5 then
        insertTableIntoTable(self.gatherNodes, {
            235387, -- Fireweed
            235376, -- Frostweed
            235388, -- Gorgrond Flytrap
            235390, -- Nagrand Arrowbloom
            235389, -- Starflower
            235391, -- Talador Orchid
        })
    end

    -- Checks if 'Find herbs' is known
    if isKnown(2383) then
        -- Draenor
        if GetCurrentMapContinent() == 7 then
            insertTableIntoTable(self.gatherNodes, {
                228571, -- Frostweed
                233117,
                237398,
                228574, -- Starflower
                237404,
                228572, -- Fireweed
                237396,
                228575, -- Nagrand Arrowbloom
                237406,
                228573, -- Gorgrond Flytrap
                237402,
                228576, -- Talador Orchid
                237400,
                243334, -- Withered Herb
            })
        end
        -- Legion
    end
end