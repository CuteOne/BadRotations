if select(3, UnitClass("player")) == 10 then
    function NewMonk()
        if Currentconfig ~= "New Monk CuteOne" then
            NewMonkConfig();
            Currentconfig = "New Monk CuteOne";
        end
        local thisUnit = dynamicTarget(5,true)
        if getDistance(thisUnit) < 5 and canAttack(thisUnit,"player") and not UnitIsDeadOrGhost(thisUnit) then
            -- Blackout Kick
            if getChi("player")>1 and getBuffRemain("player",_TigerPower)>0 then
                if castSpell(thisUnit,_BlackoutKick) then return; end
            end
            --Tiger Palm
            if getChi("player")>0 then
                if UnitLevel("player")>=7 then
                    if getBuffRemain("player",_TigerPower)==0 then
                        if castSpell(thisUnit,_TigerPalm) then return; end
                    end
                else
                    if castSpell(thisUnit,_TigerPalm) then return; end
                end
            end
            --Jab
            if getPower("player")>=40 and (getChi("player")<4 or UnitLevel("player")<3) then
                if castSpell(thisUnit,_Jab) then return; end
            end
        end
    end
end
