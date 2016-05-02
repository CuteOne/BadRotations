if select(3, UnitClass("player")) == 10 then
    function NewMonk()
        if Currentconfig ~= "New Monk CuteOne" then
            NewMonkConfig();
            Currentconfig = "New Monk CuteOne";
        end
        
        local thisUnit      = dynamicTarget(5,true)
        local blackoutKick  = 100784
        local tigerPalm     = 100787
        local tigerPower    = 125359
        local jab           = 115698

        if getDistance(thisUnit) < 5 and canAttack(thisUnit,"player") and not UnitIsDeadOrGhost(thisUnit) then
            -- Blackout Kick
            if getChi("player")>1 and getBuffRemain("player",tigerPower)>0 then
                if castSpell(thisUnit,blackoutKick) then return; end
            end
            --Tiger Palm
            if getChi("player")>0 then
                if UnitLevel("player")>=7 then
                    if getBuffRemain("player",tigerPower)==0 then
                        if castSpell(thisUnit,tigerPalm) then return; end
                    end
                else
                    if castSpell(thisUnit,tigerPalm) then return; end
                end
            end
            --Jab
            if getPower("player")>=40 and (getChi("player")<4 or UnitLevel("player")<3) then
                if castSpell(thisUnit,jab) then return; end
            end
        end
    end
end
