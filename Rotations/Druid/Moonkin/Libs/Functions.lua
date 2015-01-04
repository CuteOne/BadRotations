if select(3, UnitClass("player")) == 11 then
    function findShroom()
        if shroomsTable[1].x == nil then
            local myShroom = shroomsTable[1].guid
            for i = 1, ObjectCount() do
                if ObjectExists(ObjectWithIndex(i)) == true then
                    --print(UnitGUID(ObjectWithIndex(i)))
                    if shroomsTable[1].guid == UnitGUID(ObjectWithIndex(i)) then
                        X, Y, Z = ObjectPosition(ObjectWithIndex(i))
                       -- print("lol")
                        shroomsTable[1] = { x = X, y = Y, z = Z, guid = myShroom }
                        return true
                    end
                end
            end
        else
            return true
        end
        return false
    end

    function MultiMoon()
        if canCast(_Moonfire,false,false) and isChecked("Multidotting") then
            -- begin loop
            if enemiesTable ~= nil then
                for i = 1, #enemiesTable do
                    -- now that we know the unit is valid, we can use it to check whatever we want.. let's call it thisUnit
                    local thisUnit = enemiesTable[i].unit
                    -- Here I do my specific spell checks
                    if ((UnitAffectingCombat(thisUnit) == true) or isDummy(thisUnit)) and getDebuffRemain(thisUnit,_Moonfire) < (18*0.3) then
                        -- All is good, let's cast.
                        if castSpell(thisUnit,_Moonfire,false,false) then
                            return
                        end
                    end
                end
            end
        end
    end

end