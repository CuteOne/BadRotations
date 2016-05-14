if select(3, UnitClass("player")) == 4 then
    function NewRogue()
        if Currentconfig ~= "New Rogue CuteOne" then
            Currentconfig = "New Rogue CuteOne";
        end
        local tarDist         = getDistance(dynamicTarget(5,true))
        local thisUnit        = dynamicTarget(5,true)
        local stealth         = 1784
        local evasion         = 5277
        local ambush          = 8676
        local sinisterStrike  = 1752
        local eviscerate      = 2098
        if tarDist < 20 and canAttack("target","player") and not UnitIsDeadOrGhost("target") then
            if not UnitBuffID("player",stealth) and not isInCombat("player") then
                if castSpell("player",stealth,true,false,false) then return end
            end
            if getHP("player")<=50 and isInCombat("player") then
                if castSpell("player",evasion,true,false,false) then return end
            end
            if UnitBuffID("player",stealth) and getPower("player")>60 and tarDist<5 then
                if castSpell(thisUnit,ambush,false,false,false) then return end
            end
            if getPower("player")>35 and (getCombo()>=3 or (getTimeToDie(thisUnit)<3 and getCombo()>0)) and tarDist<5 then
                if castSpell(thisUnit,eviscerate,false,false,false) then return end
            end
            if getPower("player")>50 
                and ((not UnitBuffID("player",stealth) and UnitLevel("player")>=6) or UnitLevel("player")<6) and (getCombo()<5 or UnitLevel("player")<3) 
                and tarDist<5 
            then
                if castSpell(thisUnit,sinisterStrike,false,false,false) then return end
            end
        end
    end
end
