if select(3, UnitClass("player")) == 11 then
    function DruidResto()
        if br.player == nil or br.player.profile ~= "Resto" then
            br.player = cResto:new("Resto")
            setmetatable(br.player, {__index = cResto})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end
