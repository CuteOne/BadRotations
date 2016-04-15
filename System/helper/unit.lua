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
                -- Ironhold Harbor
                {90069, 4}, -- True Iron Bomb
                {90126, 4}, -- True Iron Bomb
                {90486, 4}, -- Inferno Shot
                {90433, 4}, -- Iron Horde Banner
                -- Zeth' Gol Daily
                {90704, 6}, -- Blood Ritual Orb
                {90781, 3}, -- Unused Razor Net Trap
                -- Temple of Sha naar
                {90302, 5}, -- Defiled Corpse
                {90703, 5}, -- Bound Spirit
                {90501, 5}, -- Fel Pylon
                {92597, 5}, -- Demonic Focus
                -- Iron Front
                {90370, 4}, -- Iron Horde Banner
                {93013, 5}, -- Siege Weapon Schematics
                -- Ruins of Kra'nak
                {90300, 8}, -- Ritual Circle
                {90790, 4}, -- Lessons on Demon Summoning
                {90794, 4}, -- How to Awaken the Warlock Within
                {90795, 4}, -- Corrupt, Dominate, Banish
                {90796, 4}, -- The Art of Nethermancy
                {90706, 4}, -- Felflame Orb
                {91068, 7}, -- Inactive Sentry
            })
        end

    end

end