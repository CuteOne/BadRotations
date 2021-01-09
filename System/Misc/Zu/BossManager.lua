function bossHelper()
    local function clickHelper(ID)
        for _,v in pairs(br.player.enemies.get(40,nil,true)) do
            if ID == getUnitID(v) then
                local distance = GetDistanceBetweenObjects("player", v)
                if distance < 10 then
                    InteractUnit(v)
                end
            end
        end
    end
    -- Automatic catch the pig
    if br.player.ui.checked("Freehold - Pig Catcher") and select(8, GetInstanceInfo()) == 1754 then
        clickHelper(130099)
    end
    -- Automatic bomb catcher
    if br.player.ui.checked("De Other Side - Bomb Snatcher") and getCurrentZoneId() == 13309 then
        clickHelper(164561)
    end
end
