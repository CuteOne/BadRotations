if select(3, UnitClass("player")) == 11 then
    -- SwiftMender
    function SwiftMender(lowestUnit,lowestHP)
        if isChecked("Swiftmend") and getSpellCD(18562) < 1 then
            if lowestHP <= getValue("Swiftmend") then
                if (getBuffRemain(lowestUnit,774,"player") > 1 or getBuffRemain(lowestUnit,8936,"player") > 1) then
                    CastSpellByName(GetSpellInfo(18562),lowestUnit)
                    return true
                end
            end
        end
    end

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

    -- select(2,DruidCastTime()) > 2
    function DruidCastTime()
        local castDuration = 0
        local castTimeRemain = 0

        if select(6,UnitCastingInfo("player"))  then
            castStartTime = select(5,UnitCastingInfo("player"))
            castEndTime = select(6,UnitCastingInfo("player"))
          else
            castStartTime = 0
            castEndTime = 0
        end
        if castEndTime > 0 and castStartTime > 0 then
            castDuration = (castEndTime - castStartTime)/1000
            castTimeRemain = ((castEndTime/1000) - GetTime())
        else
            castDuration = 0
            castTimeRemain = 0
        end
        if castDuration and castTimeRemain  then
           return castDuration,castTimeRemain
    	end
    end

    function isCastingDruid(Unit)
    	if Unit == nil then
            Unit = "player"
        end
    	if UnitCastingInfo(Unit) ~= nil or UnitChannelInfo(Unit) ~= nil
    	  or (GetSpellCooldown(61304) ~= nil and GetSpellCooldown(61304) > 0.001) then
    	  	return true
        else
            return false
    	end
    end

    function castMushFocus()
        if UnitExists("focus") and UnitAffectingCombat("focus") and UnitExists("focustarget")
          and UnitAffectingCombat("focus") and getDistance("focus","focustarget") < 5 then
            if castSpell("focus",145205,true,false) then
                return
            end
        end
    end

end