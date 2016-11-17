if select(3, UnitClass("player")) == 11 then
    function DruidRestoration()
        if br.player == nil or br.player.profile ~= "Restoration" then
            br.player = cRestoration:new("Resto")
            setmetatable(br.player, {__index = cRestoration})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end
