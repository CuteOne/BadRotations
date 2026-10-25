---
-- Pet functions are the profile API table `pet` (br.api.profile.pet); profiles use it by name.
-- pet.active.* is the player's current pet, pet.<name>.* each pet in the pet list (System/Lists/Pets.lua),
-- and the rest are commands for the pet and what its action bar says.
-- @module pet
local _, br = ...
br.api.build.pet = function(api, petList)
    local pet = api.pet
    local functions = br.functions.pet

    pet.active = {}

    --- Checks if the player's current pet exists
    -- @function pet.active.exists
    -- @return boolean True if player has an active pet, false otherwise
    pet.active.exists = function()
        return br.functions.unit:GetObjectExists("pet")
    end

    --- Counts the player's pets of the current pet's kind
    -- @function pet.active.count
    -- @return number
    pet.active.count = function()
        return functions:countOwn(br.functions.unit:GetObjectID("pet"))
    end

    --- Gets the ID of the player's current pet
    -- @function pet.active.id
    -- @return number
    pet.active.id = function()
        return br.functions.unit:GetObjectID("pet")
    end

    --- Sends the pet to attack a unit (its current target when thisUnit is nil).
    -- @function pet.attack
    -- @string[opt] thisUnit
    pet.attack = function(thisUnit) return functions:attack(thisUnit) end

    --- True while the pet is attacking.
    -- @function pet.attacking
    -- @return boolean
    pet.attacking = function() return functions:isAttacking() end

    --- True when the pet's ability casts itself.
    -- @function pet.autocast
    -- @string spellKey A spell in the class spell list
    -- @return boolean
    pet.autocast = function(spellKey) return functions:isAutocast(functions:getAbilityName(spellKey)) end

    --- The name of the pet a Call Pet spell summons (Hunter), "" when its stable slot is empty.
    -- @function pet.callName
    -- @string spellKey A Call Pet spell in the class spell list (callPet1 ... callPet5)
    -- @return string
    pet.callName = function(spellKey) return functions:getCallPetName(br.rotation.spells[spellKey]) end

    --- True when the combat log saw the pet die and it hasn't been revived.
    -- @function pet.dead
    -- @return boolean
    pet.dead = function() return functions:isDead() end

    --- Dismisses the pet.
    -- @function pet.dismiss
    pet.dismiss = function() return functions:dismiss() end

    --- Calls the pet back to follow the player.
    -- @function pet.follow
    pet.follow = function() return functions:follow() end

    --- The pet's happiness: 1 unhappy, 2 content, 3 happy (2 on clients without happiness).
    -- @function pet.happiness
    -- @return number
    pet.happiness = function() return functions:getHappiness() end

    --- True when the Hunter's active stable slot holds a pet (out, dismissed or dead), so Call Pet can work.
    -- @function pet.hasActivePet
    -- @return boolean
    pet.hasActivePet = function() return functions:hasActiveSlotPet() end

    --- The pet's mode: "assist", "defensiveAssist", "defensive", "passive", "aggressive" or "none".
    -- @function pet.mode
    -- @return string
    pet.mode = function() return functions:getMode() end

    --- Turns the autocast of the pet's ability on or off.
    -- @function pet.setAutocast
    -- @string spellKey A spell in the class spell list
    -- @boolean on
    pet.setAutocast = function(spellKey, on) return functions:setAutocast(functions:getAbilityName(spellKey), on) end

    --- Puts the pet in a mode (the names pet.mode returns); false when this client has no such mode.
    -- @function pet.setMode
    -- @string mode
    -- @return boolean
    pet.setMode = function(mode) return functions:setMode(mode) end

    --- Makes the pet stop attacking.
    -- @function pet.stopAttack
    pet.stopAttack = function() return functions:stopAttack() end

    -- Each pet in the pet list - EX: pet.imp.exists()
    for k, v in pairs(petList or {}) do
        local entry = {}
        pet[k] = entry

        --- Counts the player's pets of this kind
        -- @function pet.<name>.count
        -- @return number
        entry.count = function() return functions:countOwn(v) end

        --- True when a pet of this kind is out
        -- @function pet.<name>.exists
        -- @return boolean
        entry.exists = function() return entry.count() > 0 end
        entry.active = entry.exists

        --- This pet kind's NPC ID
        -- @function pet.<name>.id
        -- @return number
        entry.id = function() return v end
    end
end
