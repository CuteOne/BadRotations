function RogueOutlaw()
    if GetSpecializationInfo(GetSpecialization()) == 260 then--if select(2, UnitClass("player")) == "ROGUE" then
        if bb.player == nil or bb.player.profile ~= "Outlaw" then
            bb.player = cOutlaw:new("Outlaw")
            setmetatable(bb.player, {__index = cOutlaw})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end --Spec Check End
end --Rogue Function End