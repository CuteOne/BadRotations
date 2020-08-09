-- Action List - Pet Management
local currentTarget
local fetching = false
local fetchCount = 0
local paused = false
local pausekey = false
local petCalled = false
local petRevived = false
local petui = {}

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

    --Set Pause Key
    if SpecificToggle("Pause Mode") == nil or getValue("Pause Mode") == 6 then
		pausekey = IsLeftAltKeyDown()
	else
		pausekey = SpecificToggle("Pause Mode")
    end
    paused = pausekey and GetCurrentKeyBoardFocus() == nil and isChecked("Pause Mode")

    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local enemies                                       = br.player.enemies
    local gcdMax                                        = br.player.gcdMax
    local inCombat                                      = br.player.inCombat
    local mode                                          = br.player.mode
    local spell                                         = br.player.spell
    local units                                         = br.player.units
    -- General Locals
    local haltPetProfile                                = IsMounted() or IsFlying() or paused or buff.feignDeath.exists() or buff.playDead.exists("pet") or mode.rotation==4
    -- Pet Specific Locals
    local friendUnit                                    = br.friend[1].unit
    local petActive                                     = IsPetActive()
    local petCombat                                     = UnitAffectingCombat("pet")
    local petDistance                                   = getDistance(br.petTarget,"pet") or 99
    local petExists                                     = UnitExists("pet")
    local petHealth                                     = getHP("pet")
    local petMode                                       = getCurrentPetMode()
    local validTarget                                   = UnitExists(br.petTarget) and (isValidUnit(br.petTarget) or isDummy()) --or (not UnitExists(br.petTarget) and isValidUnit("target")) or isDummy()
    local petTargetOp                                   = getOptionValue("Pet Target")
    petui.debug                                         = br.addonDebug

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

    -- Pet Target Modes
    if br.petTarget ~= nil and (not isValidUnit(br.petTarget) or not br.player.inCombat or not UnitExists(br.petTarget) or UnitIsDeadOrGhost(br.petTarget)) then 
        br.petTarget = nil 
        petui.debug("[Pet] Pet no longer has a target")
    end
    if (br.player.inCombat or petCombat) and (br.petTarget == nil
        or ((petTargetOp == 1 or petTargetOp == 3) and (not isValidUnit(br.petTarget)))
        or (petTargetOp == 2 and not UnitIsUnit(br.petTarget,"target"))
        or petTargetOp == 4)
    then
        if petTargetOp == 1 and units.dyn40 ~= nil and (br.petTarget == nil or not UnitIsUnit(units.dyn40,br.petTarget)) then
            br.petTarget = units.dyn40
            petui.debug("[Pet - Target Mode Dynamic] Pet is now attacking - "..UnitName(br.petTarget).." | This is your target: "..tostring(UnitIsUnit("target",br.petTarget)))
        end
        if petTargetOp == 2 and isValidUnit("target") and (br.petTarget == nil or not UnitIsUnit(br.petTarget,"target")) then
            br.petTarget = "target"
            petui.debug("[Pet - Target Mode Only Target] Pet is now attacking - "..UnitName(br.petTarget).." | This is your target: "..tostring(UnitIsUnit("target",br.petTarget)))
        end
        if petTargetOp == 3 and enemies.yards40[1] ~= nil and (br.petTarget == nil or not UnitIsUnit(enemies.yards40[1],br.petTarget)) then
            br.petTarget = enemies.yards40[1]
                petui.debug("[Pet - Target Mode Any Unit] Pet is now attacking - "..UnitName(br.petTarget).." | This is your target: "..tostring(UnitIsUnit("target",br.petTarget)))
        end
        if petTargetOp == 4 and UnitExists("pettarget") and (br.petTarget == nil or not UnitIsUnit(br.petTarget,"pettarget")) then
            br.petTarget = "pettarget"
            petui.debug("[Pet - Target Mode Assist] Pet is now attacking - "..UnitName(br.petTarget).." | This is your pet's target: "..tostring(UnitIsUnit("pettarget",br.petTarget)))
        end
    end

    -- Pet Summoning (Call, Dismiss, Revive)
    if IsMounted() or IsFlying() or UnitHasVehicleUI("player") or CanExitVehicle("player") or waitForPetToAppear == nil then
        waitForPetToAppear = GetTime()
    elseif mode.petSummon ~= 6 and not haltPetProfile then
        local callPet = spell["callPet"..mode.petSummon]
        if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
            -- Check for Pet
            if (petCalled or petRevived) and petExists and petActive then petCalled = false; petRevived = false end
            -- Dismiss Pet
            if cast.able.dismissPet() and petExists and petActive and (callPet == nil or UnitName("pet") ~= select(2,GetCallPetSpellInfo(callPet))) then
                if cast.dismissPet() then waitForPetToAppear = GetTime(); return true end
            end
            if callPet ~= nil then
                -- Call Pet
                if ((not deadPet and not petExists) or not petActive) and not buff.playDead.exists("pet") and not petCalled then
                    if castSpell("player",callPet,false,false,false,true,true,true,true,false) then waitForPetToAppear = GetTime(); petCalled = true; petRevived = false; return true end
                end
                -- Revive Pet
                if deadPet or (petExists and petHealth == 0) or petCalled == true then
                    if cast.able.revivePet() and cast.timeSinceLast.revivePet() > gcdMax then
                        if cast.revivePet("player") then waitForPetToAppear = GetTime(); petRevived = true; petCalled = false; return true end
                    end
                end
            end
        end
    end

    -- Pet Combat Modes
    if isChecked("Auto Attack/Passive") and petActive and petExists then
        -- -- Set Pet Modes
        -- if petTargetOp == 4 and inCombat and (petMode == "Defensive" or petMode == "Passive") and not haltPetProfile and petMode ~= "Assist" then
        --     petui.debug("[Pet] Pet is now Assisting")
        --     PetAssistMode()
        -- elseif ((not inCombat and petMode == "Assist") or (inCombat and petTargetOp ~= 4)) and #enemies.yards40nc > 0 and not haltPetProfile and petMode ~= "Defensive" then
        --     petui.debug("[Pet] Pet is now Defending")
        --     PetDefensiveMode()
        -- elseif petMode ~= "Passive" and ((not inCombat and #enemies.yards40nc == 0) or haltPetProfile) and petMode ~= "Passive" then
        --     petui.debug("[Pet] Pet is now Passive")
        --     PetPassiveMode()
        -- end
        -- Pet Attack / Retreat
        if (inCombat or petCombat) and not buff.playDead.exists("pet") and not haltPetProfile and br.petTarget ~= nil and (currentTarget == nil or not UnitIsUnit(br.petTarget,currentTarget)) then
            petui.debug("[Pet] Pet is now attacking "..tostring(UnitName(br.petTarget)))
            PetAttack(br.petTarget)
            currentTarget = br.petTarget
        elseif (not inCombat or (inCombat and not isValidUnit(br.petTarget)) or haltPetProfile) and IsPetAttackActive() then
            petui.debug("[Pet] Pet stopped attacking!")
            PetStopAttack()
            if #enemies.yards40 == 0 or haltPetProfile then 
                petui.debug("[Pet] Pet is now following, Enemies40: "..#enemies.yards40..", haltPetProfile: "..tostring(haltPetProfile)) 
                PetFollow()
            end
        end
    end

    -- Manage Pet Abilities
    if not haltPetProfile then
        -- Cat-like Refelexes / Spirit Mend / Survival of the Fittest
        if isChecked("Spirit Mend") and cast.able.spiritmend() and getHP(friendUnit) <= getOptionValue("Spirit Mend") then
            if cast.spiritmend(friendUnit) then return end
        end
        if isChecked("Cat-like Reflexes") and cast.able.catlikeReflexes() and petHealth <= getOptionValue("Cat-like Reflexes") then
            if cast.catlikeReflexes() then return end
        end
        if isChecked("Survival of the Fittest") and cast.able.survivalOfTheFittest()
            --[[and petCombat ]]and petHealth <= getOptionValue("Survival of the Fittest")
        then
            if cast.survivalOfTheFittest() then return end
        end
        -- Bite/Claw
        if isChecked("Bite / Claw") and petCombat and validTarget and petDistance < 5 and not isTotem(br.petTarget) then
            if cast.able.bite() then
                if cast.bite(br.petTarget,"pet") then return end
            end
            if cast.able.claw() then
                if cast.claw(br.petTarget,"pet") then return end
            end
        end
        -- Dash
        if isChecked("Dash") and cast.able.dash() and validTarget and petDistance > 10 and getDistance(br.petTarget) < 40 then
            if cast.dash("pet") then return end
        end
        -- Purge
        if isChecked("Purge") and inCombat then
            if #enemies.yards5p > 0 then
                local dispelled = false
                local dispelledUnit = "player"
                for i = 1, #enemies.yards5p do
                    local thisUnit = enemies.yards5p[i]
                    if getOptionValue("Purge") == 1 or (getOptionValue("Purge") == 2 and UnitIsUnit(thisUnit,"target")) then
                        if isValidUnit(thisUnit) and canDispel(thisUnit,spell.spiritShock) then
                            if cast.able.spiritShock(thisUnit,"pet") then
                                if cast.spiritShock(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            elseif cast.able.chiJiTranq(thisUnit,"pet") then
                                if cast.chiJiTranq(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            elseif cast.able.naturesGrace(thisUnit,"pet") then
                                if cast.naturesGrace(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            elseif cast.able.netherShock(thisUnit,"pet") then
                                if cast.netherShock(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            elseif cast.able.sonicBlast(thisUnit,"pet") then
                                if cast.sonicBlast(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            elseif cast.able.soothingWater(thisUnit,"pet") then
                                if cast.soothingWater(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            elseif cast.able.sporeCloud(thisUnit,"pet") then
                                if cast.sporeCloud(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            end
                        end
                    end
                end
                if dispelled then return end
            end
        end
        -- Growl
        if isChecked("Auto Growl") and inCombat then
            local _, autoCastEnabled = GetSpellAutocast(spell.growl)
            if autoCastEnabled then DisableSpellAutocast(spell.growl) end
            if not isTankInRange() and not buff.prowl.exists("pet") then
                if getOptionValue("Misdirection") == 3 and cast.able.misdirection("pet") and #enemies.yards8p > 1 then
                    if cast.misdirection("pet") then return end
                end
                if cast.able.growl() then
                    for i = 1, #enemies.yards30p do
                        local thisUnit = enemies.yards30p[i]
                        if isTanking(thisUnit) then
                            if cast.growl(thisUnit,"pet") then return end
                        end
                    end
                end
            end
        end
        -- Play Dead / Wake Up
        if isChecked("Play Dead / Wake Up") and not deadPet then
            if cast.able.playDead() and petCombat and not buff.playDead.exists("pet")
                and petHealth < getOptionValue("Play Dead / Wake Up")
            then
                if cast.playDead() then return end
            end
            if cast.able.wakeUp() and buff.playDead.exists("pet") and not buff.feignDeath.exists()
                and petHealth >= getOptionValue("Play Dead / Wake Up")
            then
                if cast.wakeUp() then return end
            end
        end
        -- Prowl
        if isChecked("Prowl / Spirit Walk") and not petCombat
            and (not IsResting() or isDummy()) and #enemies.yards40nc > 0
        then
            if cast.able.spiritWalk() and not buff.spiritWalk.exists("pet") then
                if cast.spiritWalk("pet") then return end
            end
            if cast.able.prowl() and not buff.prowl.exists("pet") then
                if cast.prowl("pet") then return end
            end
        end
        -- Mend Pet
        if isChecked("Mend Pet") and cast.able.mendPet() and petExists and not deadPet
            and not buff.mendPet.exists("pet") and petHealth < getOptionValue("Mend Pet")
        then
            if cast.mendPet() then return end
        end
        -- Fetch
        local function getLootableCount()
            local count = 0
            for k, v in pairs(br.lootable) do
                if br.lootable[k] ~= nil and getDistance(br.lootable[k]) > 8 then
                    count = count + 1
                end
            end
            return count
        end

        if isChecked("Fetch") and not inCombat and cast.able.fetch() and petExists and not deadPet then
            if fetching and (fetchCount ~= getLootableCount() or getLootableCount() == 0) then fetching = false end
            for k, v in pairs(br.lootable) do
                if br.lootable[k] ~= nil then
                    if getDistance(br.lootable[k]) > 8 and not fetching then
                        cast.fetch("pet")
                        fetchCount = getLootableCount()
                        fetching = true
                        petui.debug("[Pet] Pet is fetching loot! "..fetchCount.." loots found!")
                        break
                    end
                end
            end
        end
    end
end -- End Action List - Pet Management
