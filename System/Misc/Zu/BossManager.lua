local _, br = ...
br.misc.Zu = br.misc.Zu or {}
local Zu = br.misc.Zu

function Zu:bossHelper()
    local function clickHelper(ID)
        for _,v in pairs(br.player.enemies.get(40,nil,true)) do
            if ID == br.functions.unit:getUnitID(v) then
                local distance = br._G.GetDistanceBetweenObjects("player", v)
                if distance < 10 and br.debug.timer:useTimer("Action Delay", br.functions.misc:getOptionValue("Catcher/Snatcher Delay")) then
                    br._G.InteractUnit(v)
                end
            end
        end
    end
    if br.player ~= nil and br.player.ui ~= nil then
        -- Automatic catch the pig
        if br.player.ui.checked("Freehold - Pig Catcher") and select(8, br._G.GetInstanceInfo()) == 1754 then
            clickHelper(130099)
        end
        -- Automatic bomb catcher
        if br.player.ui.checked("De Other Side - Bomb Snatcher") and br.functions.custom:getCurrentZoneId() == 2291 then
            clickHelper(164561)
        end
    end
end
