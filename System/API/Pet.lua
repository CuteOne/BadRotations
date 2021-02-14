local _, br = ...
if br.api == nil then br.api = {} end
br.api.pets = function(pet,k,v,brplayer)
    -- Active Pet - EX: br.player.pet.active.exists()
    local petList = pet
    local pet = brplayer.pet
    if pet.active == nil then
        pet.active = {}
        pet.active.exists = function()
            return br.GetObjectExists("pet")
        end
        pet.active.count = function()
            local count = 0
            for l,_ in pairs(brplayer.pet.list) do
                local listID = brplayer.pet.list[l].id
                if br.GetObjectID("pet") == listID then count = count + 1 end
            end
            return count
        end
        pet.active.id =  function()
            return br.GetObjectID("pet")
        end
    end
    pet = petList
    -- All Pets - EX: br.player.pet.imp.exists()
    pet.count = function()
        local count = 0
        for l,_ in pairs(brplayer.pet.list) do
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
    -- if self.pet.buff == nil then self.pet.buff = {} end
    -- self.pet.buff.exists = function(buffID,petID)
    --     for k, v in pairs(self.pet) do
    --         local pet = self.pet[k]
    --         if self.pet[k].id == petID and br.UnitBuffID(k,buffID) ~= nil then return true end
    --     end
    --     return false
    -- end

    -- self.pet.buff.count = function(buffID,petID)
    --     local petCount = 0
    --     for k, v in pairs(self.pet) do
    --         local pet = self.pet[k]
    --         if self.pet[k].id == petID and br.UnitBuffID(k,buffID) ~= nil then petCount = petCount + 1 end
    --     end
    --     return petCount
    -- end

    -- self.pet.buff.missing = function(buffID,petID)
    --     local petCount = 0
    --     for k, v in pairs(self.pet) do
    --         local pet = self.pet[k]
    --         if self.pet[k].id == petID and br.UnitBuffID(k,buffID) == nil then petCount = petCount + 1 end
    --     end
    --     return petCount
    -- end
end