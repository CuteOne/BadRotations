local _, br = ...
--- Pet: the player's pet: its action bar, commands and modes. One version for every client: the pet
-- action bar (GetPetActionInfo, TogglePetAutocast) exists on all of them, where the spell book
-- calls for pets don't (TBC Classic has no FindSpellBookSlotBySpellID or pet-aware IsSpellKnown).

---@class br.functions.pet
br.functions.pet = br.functions.pet or {}
local pet = br.functions.pet

-- The pet bar's slots by ability name, re-read at most every 5 seconds (the bar changes only when
-- the pet learns something or a new pet is out)
local barSlots, barReadAt = nil, 0

-- The pet's modes by the names the pet bar gives them
local MODE_NAMES = {
    PET_MODE_ASSIST = "assist", PET_MODE_DEFENSIVEASSIST = "defensiveAssist", PET_MODE_DEFENSIVE = "defensive",
    PET_MODE_PASSIVE = "passive", PET_MODE_AGGRESSIVE = "aggressive",
}
-- The game's command for each mode (not every client has every mode)
local MODE_COMMANDS = {
    assist = "PetAssistMode", defensiveAssist = "PetDefensiveAssistMode", defensive = "PetDefensiveMode",
    passive = "PetPassiveMode", aggressive = "PetAggressiveMode",
}

--- Sends the pet to attack a unit (its current target when unit is nil).
function pet:attack(unit)
    br.game.PetAttack(unit)
end

--- How many of the player's own pets with this NPC ID the enemies engine has seen.
function pet:countOwn(petID)
    local count = 0
    for _, ownPet in pairs(br.engines.enemiesEngine.ownPet) do
        if ownPet.id == petID then count = count + 1 end
    end
    return count
end

--- Dismisses the pet (Warlock demons, Hunter pets through Dismiss Pet are cast as spells).
function pet:dismiss()
    br.game.PetDismiss()
end

--- Calls the pet back to follow the player.
function pet:follow()
    br.game.PetFollow()
end

--- A pet ability's name, from its key in the class spell list (every rank of a ranked one has it).
function pet:getAbilityName(spellKey)
    local spellID = br.runner and br.runner.spells[spellKey]
    if type(spellID) == "table" then spellID = spellID[1] end
    return br.functions.spell:getName(spellID)
end

--- The pet bar slot holding an ability, by its name, or nil.
-- @param refresh true to read the bar again now (before casting from a slot)
function pet:getBarSlot(spellName, refresh)
    if not spellName then return nil end
    local now = br.game.GetTime()
    if refresh or not barSlots or now - barReadAt > 5 then
        barSlots, barReadAt = {}, now
        for i = 1, br.game.NUM_PET_ACTION_SLOTS or 0 do
            local name = br.game.GetPetActionInfo(i)
            if name and not barSlots[name] then barSlots[name] = i end
        end
    end
    return barSlots[spellName]
end

--- The name of the pet a Call Pet spell summons ("" when its stable slot is empty).
function pet:getCallPetName(callPetSpellID)
    if br.game.GetCallPetSpellInfo == nil or callPetSpellID == nil then return "" end
    local _, name = br.game.GetCallPetSpellInfo(callPetSpellID)
    return name or ""
end

--- The pet's happiness (1 unhappy, 2 content, 3 happy); 2 on clients without happiness.
function pet:getHappiness()
    return br.game.GetPetHappiness and br.game.GetPetHappiness() or 2
end

--- The pet's mode: "assist", "defensiveAssist", "defensive", "passive", "aggressive" or "none".
function pet:getMode()
    for i = 1, br.game.NUM_PET_ACTION_SLOTS or 0 do
        local name, _, _, isActive = br.game.GetPetActionInfo(i)
        if isActive and MODE_NAMES[name] then return MODE_NAMES[name] end
    end
    return "none"
end

--- True when the Hunter's active stable slot holds a pet (out, dismissed or dead): only then does
-- the game report pet experience, and only then can Call Pet work.
function pet:hasActiveSlotPet()
    return br.game.GetPetExperience ~= nil and br.game.GetPetExperience() ~= nil
end

--- True while the pet is attacking.
function pet:isAttacking()
    return br.game.IsPetAttackActive() == true
end

--- True when the pet's ability (by name) casts itself (autocast on).
function pet:isAutocast(spellName)
    local slot = self:getBarSlot(spellName)
    if slot == nil then return false end
    local _, _, _, _, _, autoCastEnabled = br.game.GetPetActionInfo(slot)
    return autoCastEnabled == true
end

--- True when the combat log saw the pet die and it hasn't been revived.
function pet:isDead()
    return br.readers.combatLog.deadPet == true
end

--- Turns the autocast of the pet's ability (by name) on or off.
function pet:setAutocast(spellName, on)
    local slot = self:getBarSlot(spellName)
    if slot ~= nil and self:isAutocast(spellName) ~= (on == true) then br.game.TogglePetAutocast(slot) end
end

--- Puts the pet in a mode ("assist", "defensiveAssist", "defensive", "passive", "aggressive"); false when
-- this client has no such mode.
function pet:setMode(mode)
    local command = MODE_COMMANDS[mode] and br.game[MODE_COMMANDS[mode]]
    if command == nil then return false end
    command()
    return true
end

--- Makes the pet stop attacking.
function pet:stopAttack()
    br.game.PetStopAttack()
end
