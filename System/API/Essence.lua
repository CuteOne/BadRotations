if br.api == nil then br.api = {} end
br.api.essences = function(essence,k,v)
    essence.active = GetSpellInfo(GetSpellInfo(v)) ~= nil --isActiveEssence(v)
    essence.key = k
    essence.id = v
    essence.spellID = select(7,GetSpellInfo(GetSpellInfo(v))) or v
end