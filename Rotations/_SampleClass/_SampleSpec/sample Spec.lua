function WarriorFury() -- Change to ClassSpec() (IE: MageFire())
    if GetSpecializationInfo(GetSpecialization()) == 72 then -- Change to spec id
        if bb.player == nil or bb.player.profile ~= "Fury" then -- Change "Fury" to spec (IE: "Fire")
            bb.player = cFury:new("Fury") -- Change cFury to cSpec (IE: cFire) and Change "Fury" to spec (IE: "Fire")
            setmetatable(bb.player, {__index = cFury}) -- Change cFury to cSpec (IE: cFire)

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end