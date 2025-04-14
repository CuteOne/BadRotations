---
-- Pet handling functions for BadRotations.
-- These functions provide pet management capabilities such as checking if pets exist,
-- counting specific pets, and retrieving pet information.
-- @module br.player.pets
local _, br = ...
if br.api == nil then br.api = {} end
br.api.pets = function(pet,k,v,brplayer)
    -- Active Pet - EX: br.player.pet.active.exists()
    local petList = pet
    local pet = brplayer.pet
    if pet.active == nil then
        pet.active = {}

        ---
        -- Checks if the player's current pet exists
        -- @function br.player.pet.active.exists
        -- @return boolean True if player has an active pet, false otherwise
        -- @usage local hasPet = br.player.pet.active.exists()
        pet.active.exists = function()
            return br.GetObjectExists("pet")
        end

        ---
        -- Counts player pets that match any pet in the list
        -- @function br.player.pet.active.count
        -- @return number The count of matching active pets
        pet.active.count = function()
            local count = 0
            for l,_ in pairs(brplayer.pet.list) do
                local listID = brplayer.pet.list[l].id
                if br.GetObjectID("pet") == listID then count = count + 1 end
            end
            return count
        end

        ---
        -- Gets the ID of the player's current pet
        -- @function br.player.pet.active.id
        -- @return number The ID of the active pet
        pet.active.id =  function()
            return br.GetObjectID("pet")
        end
    end
    pet = petList
    -- All Pets - EX: br.player.pet.imp.exists()

    ---
    -- Counts specific pets matching the current pet ID
    -- @function br.player.pet.count
    -- @return number The count of matching pets
    -- @usage local impCount = br.player.pet.imp.count()
    pet.count = function()
        local count = 0
        for l,_ in pairs(brplayer.pet.list) do
            local listID = brplayer.pet.list[l].id
            if v == listID then count = count + 1 end
        end
        return count
    end

    ---
    -- Checks if the specific pet type is active
    -- @function br.player.pet.active
    -- @return boolean True if this pet type is active, false otherwise
    -- @usage local hasImp = br.player.pet.imp.active()
    pet.active = function()
        return pet.count() > 0
    end

    ---
    -- Checks if the specific pet type exists
    -- @function br.player.pet.exists
    -- @return boolean True if this pet type exists, false otherwise
    -- @usage local hasImp = br.player.pet.imp.exists()
    pet.exists = function()
        return pet.count() > 0
    end

    ---
    -- Gets the ID of the specific pet type
    -- @function br.player.pet.id
    -- @return number The pet ID
    -- @usage local impID = br.player.pet.imp.id()
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