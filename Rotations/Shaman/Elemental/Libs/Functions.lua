if select(3,UnitClass("player")) == 7 then

function isFireTotem(SpellID)
    return tostring(select(2,GetTotemInfo(1))) == tostring(GetSpellInfo(SpellID)) == true or false
end

function isAirTotem(SpellID)
    return tostring(select(2,GetTotemInfo(4))) == tostring(GetSpellInfo(SpellID)) == true or false
end

end

