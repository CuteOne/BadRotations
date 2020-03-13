function bossHelper()
    -- Automatic catch the pig
    if br.unlocked then --EWT ~= nil then
        if select(8, GetInstanceInfo()) == 1754 then
            for i = 1, GetObjectCountBR() do
                local ID = ObjectID(GetObjectWithIndex(i))
                local object = GetObjectWithIndex(i)
                local x1, y1, z1 = ObjectPosition("player")
                local x2, y2, z2 = ObjectPosition(object)
                local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                if ID == 130099 and distance < 10 then
                    InteractUnit(object)
                end
            end
        end
    end
end
