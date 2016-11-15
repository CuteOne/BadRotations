function RogueOutlaw()
    if GetSpecializationInfo(GetSpecialization()) == 260 then--if select(2, UnitClass("player")) == "ROGUE" then
        if br.player == nil or br.player.profile ~= "Outlaw" then
            br.player = cOutlaw:new("Outlaw")
            setmetatable(br.player, {__index = cOutlaw})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()

    end --Spec Check End
end --Rogue Function End