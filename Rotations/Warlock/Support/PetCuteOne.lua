-- Action List - Pet Management
br.rotations.support["PetCuteOne"] = function()
    local function getCurrentPetMode()
        local petMode = "None"
        for i = 1, NUM_PET_ACTION_SLOTS do
            local name, _, _,isActive = GetPetActionInfo(i)
            if isActive then
                if name == "PET_MODE_ASSIST" then petMode = "Assist" end
                if name == "PET_MODE_DEFENSIVE" then petMode = "Defensive" end
                if name == "PET_MODE_PASSIVE" then petMode = "Passive" end
            end
        end
        return petMode
    end

    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local enemies                                       = br.player.enemies
    local inCombat                                      = br.player.inCombat
    local mode                                          = br.player.ui.mode
    local spell                                         = br.player.spell
    local units                                         = br.player.units
    -- General Locals
    local profileStop                                   = profileStop or false
    local haltProfile                                   = (inCombat and profileStop) or (IsMounted() or IsFlying()) or pause(true) or mode.rotation==4
    -- Units
    units.get(5)
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(5,"pet")
    enemies.get(8,"target")
    enemies.get(8,"pet")
    enemies.get(20,"pet")
    enemies.get(30)
    enemies.get(30,"pet")
    enemies.get(40)
    enemies.get(40,"player",true)
    enemies.get(40,"player",false,true)
    enemies.yards40r = getEnemiesInRect(10,40,false) or 0

    -- local petTarget
    -- if petTarget == nil or not UnitExists(petTarget) or not isValidUnit(petTarget) then
    --     if getOptionValue("Pet Target") == 1 and isValidUnit(units.dyn40) then
    --         petTarget = units.dyn40
    --     elseif getOptionValue("Pet Target") == 2 and isValidUnit("target") then
    --         petTarget = "target"
    --     elseif getOptionValue("Pet Target") == 3 then
    --         for i=1, #enemies.yards40 do
    --             local thisUnit = enemies.yards40[i]
    --             if (isValidUnit(thisUnit) or isDummy()) then petTarget = thisUnit break end
    --         end
    --     end
    -- end

    local friendUnit = br.friend[1].unit
    local petActive = IsPetActive()
    local petCombat = UnitAffectingCombat("pet")
    local petDistance = getDistance(petTarget,"pet") or 99
    local petExists = UnitExists("pet")
    local petHealth = getHP("pet")
    local petMode = getCurrentPetMode()
    local validTarget = UnitExists(petTarget) and (isValidUnit(petTarget) or isDummy()) --or (not UnitExists("pettarget") and isValidUnit("target")) or isDummy()

    -- if IsMounted() or IsFlying() or UnitHasVehicleUI("player") or CanExitVehicle("player") then
    --     waitForPetToAppear = GetTime()
    -- elseif mode.petSummon ~= 6 then
    --     local callPet = spell["callPet"..mode.petSummon]
    --     if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
    --         if cast.able.dismissPet() and petExists and petActive and (callPet == nil or UnitName("pet") ~= select(2,GetCallPetSpellInfo(callPet))) then
    --             if cast.dismissPet() then waitForPetToAppear = GetTime(); return true end
    --         elseif callPet ~= nil then
    --             if deadPet or (petExists and petHealth == 0) then
    --                 if cast.able.revivePet() then
    --                     if cast.revivePet("player") then waitForPetToAppear = GetTime(); return true end
    --                 end
    --             elseif not deadPet and not petExists and not buff.playDead.exists("pet") then
    --                 if castSpell("player",callPet,false,false,false,true,true,true,true,false) then waitForPetToAppear = GetTime(); return true end
    --             end
    --         end
    --     end
    --     if waitForPetToAppear == nil then
    --         waitForPetToAppear = GetTime()
    --     end
    -- end
    if isChecked("Pet - Auto Attack/Passive") then
        -- Set Pet Mode Out of Comat / Set Mode Passive In Combat
        if inCombat and (petMode == "Defensive" or petMode == "Passive") and not haltProfile then
            PetAssistMode()
        elseif not inCombat and petMode == "Assist" and #enemies.yards40nc > 0 and not haltProfile then
            PetDefensiveMode()
        elseif petMode ~= "Passive" and ((inCombat and #enemies.yards40 == 0) or haltProfile) and not isUnitCasting("player") then
            PetPassiveMode()
        end
        -- Pet Attack / retreat
        if (inCombat or petCombat) and not haltProfile then
            PetAttack(petTarget)
        elseif not inCombat or (inCombat and not isValidUnit(petTarget)) or haltProfile
            and IsPetAttackActive() and not isUnitCasting("player")
        then
            PetStopAttack()
            PetFollow()
        end
    end
    -- Manage Pet Abilities
    -- -- Cat-like Refelexes / Spirit Mend / Survival of the Fittest
    -- if isChecked("Spirit Mend") and cast.able.spiritmend() and getHP(friendUnit) <= getOptionValue("Spirit Mend") then
    --     if cast.spiritmend(friendUnit) then return end
    -- end
    -- if isChecked("Cat-like Reflexes") and cast.able.catlikeReflexes() and petHealth <= getOptionValue("Cat-like Reflexes") then
    --     if cast.catlikeReflexes() then return end
    -- end
    -- if isChecked("Survival of the Fittest") and cast.able.survivalOfTheFittest()
    --     --[[and petCombat ]]and petHealth <= getOptionValue("Survival of the Fittest")
    -- then
    --     if cast.survivalOfTheFittest() then return end
    -- end
    -- -- Bite/Claw
    -- if isChecked("Bite / Claw") and petCombat and validTarget and petDistance < 5 and not haltProfile and not isTotem(petTarget) then
    --     if cast.able.bite() then
    --         if cast.bite(petTarget,"pet") then return end
    --     end
    --     if cast.able.claw() then
    --         if cast.claw(petTarget,"pet") then return end
    --     end
    -- end
    -- -- Dash
    -- if isChecked("Dash") and cast.able.dash() and validTarget and petDistance > 10 and getDistance(pertTarget) < 40 then
    --     if cast.dash("pet") then return end
    -- end
    -- -- Purge
    -- if isChecked("Purge") and inCombat then
    --     if #enemies.yards5p > 0 then
    --         local dispelled = false
    --         local dispelledUnit = "player"
    --         for i = 1, #enemies.yards5p do
    --             local thisUnit = enemies.yards5p[i]
    --             if getOptionValue("Purge") == 1 or (getOptionValue("Purge") == 2 and UnitIsUnit(thisUnit,"target")) then
    --                 if canDispel(thisUnit,spell.spiritShock) then
    --                     if cast.able.spiritShock(thisUnit,"pet") then
    --                         if cast.spiritShock(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
    --                     elseif cast.able.chiJiTranq(thisUnit,"pet") then
    --                         if cast.chiJiTranq(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
    --                     elseif cast.able.naturesGrace(thisUnit,"pet") then
    --                         if cast.naturesGrace(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
    --                     elseif cast.able.netherShock(thisUnit,"pet") then
    --                         if cast.netherShock(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
    --                     elseif cast.able.sonicBlast(thisUnit,"pet") then
    --                         if cast.sonicBlast(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
    --                     elseif cast.able.soothingWater(thisUnit,"pet") then
    --                         if cast.soothingWater(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
    --                     elseif cast.able.sporeCloud(thisUnit,"pet") then
    --                         if cast.sporeCloud(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
    --                     end
    --                 end
    --             end
    --         end
    --         if dispelled then Print("Casting dispel on ".. UnitName(dispelledUnit)); return end
    --     end
    -- end
    -- -- Growl
    -- if isChecked("Auto Growl") and inCombat then
    --     local _, autoCastEnabled = GetSpellAutocast(spell.growl)
    --     if autoCastEnabled then DisableSpellAutocast(spell.growl) end
    --     if not isTankInRange() and not buff.prowl.exists("pet") then
    --         if getOptionValue("Misdirection") == 3 and cast.able.misdirection("pet") and #enemies.yards8p > 1 then
    --             if cast.misdirection("pet") then return end
    --         end
    --         if cast.able.growl() then
    --             for i = 1, #enemies.yards30p do
    --                 local thisUnit = enemies.yards30p[i]
    --                 if isTanking(thisUnit) then
    --                     if cast.growl(thisUnit,"pet") then return end
    --                 end
    --             end
    --         end
    --     end
    -- end
    -- -- Play Dead / Wake Up
    -- if isChecked("Play Dead / Wake Up") and not deadPet then
    --     if cast.able.playDead() and petCombat and not buff.playDead.exists("pet")
    --         and petHealth < getOptionValue("Play Dead / Wake Up")
    --     then
    --         if cast.playDead() then return end
    --     end
    --     if cast.able.wakeUp() and buff.playDead.exists("pet") and not buff.feignDeath.exists()
    --         and petHealth >= getOptionValue("Play Dead / Wake Up")
    --     then
    --         if cast.wakeUp() then return end
    --     end
    -- end
    -- -- Prowl
    -- if isChecked("Prowl / Spirit Walk") and not petCombat
    --     and (not IsResting() or isDummy()) and #enemies.yards40nc > 0
    -- then
    --     if cast.able.spiritWalk() and not buff.spiritWalk.exists("pet") then
    --         if cast.spiritWalk("pet") then return end
    --     end
    --     if cast.able.prowl() and not buff.prowl.exists("pet") then
    --         if cast.prowl("pet") then return end
    --     end
    -- end
    -- -- Mend Pet
    -- if isChecked("Mend Pet") and cast.able.mendPet() and petExists and not deadPet
    --     and not buff.mendPet.exists("pet") and petHealth < getOptionValue("Mend Pet") and not haltProfile and not pause()
    -- then
    --     if cast.mendPet() then return end
    -- end
end -- End Action List - Pet Management