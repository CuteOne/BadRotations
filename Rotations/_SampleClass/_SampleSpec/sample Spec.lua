function WarriorFury() -- Change to ClassSpec() (IE: MageFire())
    if GetSpecializationInfo(GetSpecialization()) == 72 then -- Change to spec id
        if br.player == nil or br.player.profile ~= "Fury" then -- Change "Fury" to spec (IE: "Fire")
            br.player = cFury:new("Fury") -- Change cFury to cSpec (IE: cFire) and Change "Fury" to spec (IE: "Fire")
            setmetatable(br.player, {__index = cFury}) -- Change cFury to cSpec (IE: cFire)

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end