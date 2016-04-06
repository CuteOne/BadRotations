--- Checks which mining nodes can be gathered
--  and puts them into the global table
--  Uses a range of 6y
function bb.helper:getMiningNodes()
    -- Garrison
    -- Check if Continent = Draenor and SubMap is Shadowmoon Valley
    if GetCurrentMapContinent() == 7 and GetCurrentMapZone() == 5 then
        insertTableIntoTable(self.gatherNodes, {
            232542,
            232543,
            232544,
            232545,
            232541, -- Mine Cart
        })
    end

    -- Checks if 'Find minerals' is known
    if isKnown(2580) then
        -- Vanilla
        -- Burning Crusade
        -- WotLK
        -- Cataclysm
        -- Mists of Pandaria
        if GetCurrentMapContinent() == 6 then
            insertTableIntoTable(self.gatherNodes, {
                209311, -- Ghost Iron Deposit
                221538,
                209328, -- Rich Ghost Iron Deposit
                221539,
                209312, -- Kyparite Deposit
                209329, -- Rich Kyparite Deposit
                209313, -- Trillium Vein
                221541,
                209330, -- Rich Trillium Vein
                221540,
            })
        end
        -- Draenor
        if GetCurrentMapContinent() == 7 then
            insertTableIntoTable(self.gatherNodes, {
                228493, -- True Iron Deposit
                243314,
                237358,
                228510, -- Rich True Iron Deposit
                243315,
                237357,
                228563, -- Blackrock Deposit
                243313,
                237359,
                228564, -- Rich Blackrock Deposit
                243312,
                237360,
            })
        end
        -- Legion
    end

end
