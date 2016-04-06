function bb.helper:getUnitNodes()
    -- Garrison
    -- Check if Continent = Draenor and SubMap is Shadowmoon Valley
    if GetCurrentMapContinent() == 7 and GetCurrentMapZone() == 5 then
    --   insertTableIntoTable(self.unitNodes, {
    --   })
    end


    -- Draenor
    if GetCurrentMapContinent() == 7 then
        -- Tanaan Jungle
        if GetCurrentMapZone() == 11 then
            insertTableIntoTable(self.unitNodes, {
                -- Fel Forge
                {91901, 5}, -- Hellfire Shell
                {92741, 5}, -- Hellfire Shell Stack
                -- Zeth' Gol Daily
                {90704, 6}, -- Blood Ritual Orb
                {90781, 3}, -- Unused Razor Net Trap
            })
        end

    end

end