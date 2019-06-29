if br.api == nil then br.api = {} end
br.api.essences = function(essence,k,v)
    essence.active = isActiveEssence(v)
    essence.key = k
    essence.id = v
end