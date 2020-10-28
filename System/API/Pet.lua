if br.api == nil then br.api = {} end
br.api.pets = function(pet,k,v,brplayer)
    -- Active Pet - EX: br.player.pet.active.exists()
    local petList = pet
    local pet = brplayer.pet
    if pet.active == nil then
        pet.active = {}
        pet.active.exists = function()
            return GetObjectExists("pet")
        end
        pet.active.count = function()
            local count = 0
            for l,w in pairs(brplayer.pet.list) do
                local listID = brplayer.pet.list[l].id
                if GetObjectID("pet") == listID then count = count + 1 end
            end
            return count
        end
        pet.active.id =  function()
            return GetObjectID("pet")
        end
    end
    pet = petList
    -- All Pets - EX: br.player.pet.imp.exists()
    pet.count = function()
        local count = 0
        for l,w in pairs(brplayer.pet.list) do
            local listID = brplayer.pet.list[l].id
            if v == listID then count = count + 1 end
        end
        return count
    end
    pet.active = function()
        return pet.count() > 0
    end
    pet.exists = function()
        return pet.count() > 0
    end
    pet.id = function()
        return v
    end
end