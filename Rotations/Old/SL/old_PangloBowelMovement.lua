local rotationName = "Beastiality"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.cobraShot },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.multishot },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.killCommand },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.exhilaration}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.aspectOfTheWild },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.aspectOfTheWild },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.aspectOfTheWild }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.aspectOfTheTurtle },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.aspectOfTheTurtle }
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterShot },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterShot }
    };
    CreateButton("Interrupt",4,0)
    -- MD Button
    MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("Misdirection",5,0)
    --Pet summon
    PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spell.callPet1 },
        [2] = { mode = "2", value = 2 , overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spell.callPet2 },
        [3] = { mode = "3", value = 3 , overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spell.callPet3 },
        [4] = { mode = "4", value = 4 , overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spell.callPet4 },
        [5] = { mode = "5", value = 5 , overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spell.callPet5 },
        [6] = { mode = "None", value = 6 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.callPet }
    };
    CreateButton("PetSummon",6,0)
    -- MD Button
    BestCleaveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Best Cleave Target Enabled", tip = "Best Cleave Target Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Best Cleave Target Disabled", tip = "Best Cleave Target Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("BestCleave",0,1)
    BestialWrathModes = {
        [1] = { mode = "ON", value = 1 , overlay = "Use Bestial Wrath always", tip = "BW ALWAYS", highlight = 1, icon = br.player.spell.bestialWrath },
        [2] = { mode = "CDS", value = 2 , overlay = "Use Besital Wrath on CD", tip = "BW CD Mode", highlight = 1, icon = br.player.spell.bestialWrath },
        [3] = { mode = "OFF", value = 2 , overlay = "Do not use Bestial Wrath", tip = "BW OFF", highlight = 0, icon = br.player.spell.bestialWrath }
    };
    CreateButton("BestialWrath",1,1)
end

local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General 5-22-20 22:42")
            br.ui:createCheckbox(section, "Enemy Target Lock", "In Combat, Locks targetting to enemies to avoid shenanigans", 1)
            -- AoE Units
            br.ui:createSpinnerWithout(section, "Units To AoE", 2, 2, 10, 1, "|cffFFFFFFSet to desired units to start AoE at.")
            -- Misdirection
            br.ui:createDropdownWithout(section,"Misdirection", {"|cff00FF00Tank","|cffFFFF00Focus","|cffFF0000Pet"}, 1, "|cffFFFFFFSelect target to Misdirect to.")
            br.ui:createCheckbox(section, "Use TTD for Aspect and Bestial")
            -- Cleave
            br.ui:createSpinnerWithout(section, "Humanize Switching for Burn", 2, 0.1, 5, 0.1)
        br.ui:checkSectionState(section)
        -- Pet Options
        section = br.ui:createSection(br.ui.window.profile, "Pet")
            -- Auto Growl
            br.ui:createCheckbox(section, "Auto Growl")
            -- Bite/Claw
            br.ui:createCheckbox(section, "Bite / Claw")
            -- Dash
            br.ui:createCheckbox(section, "Dash")
            -- Prowl/Spirit Walk
            br.ui:createCheckbox(section, "Prowl / Spirit Walk")
            -- Mend Pet
            br.ui:createSpinner(section, "Mend Pet",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Purge
            br.ui:createDropdown(section, "Purge", {"Every Unit","Only Target"}, 2, "Select if you want Purge only Target or every Unit arround the Pet")
            -- Spirit Mend
            br.ui:createSpinner(section, "Spirit Mend", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Survival of the Fittest
            br.ui:createSpinner(section, "Survival of the Fittest", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")
            -- Bestial Wrath
            br.ui:createDropdownWithout(section,"Bestial Wrath", {"|cff00FF00Boss","|cffFFFF00Always"}, 1, "|cffFFFFFFSelect Bestial Wrath Usage.")
            -- Trueshot
            br.ui:createCheckbox(section,"Aspect of the Wild")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Aspect of the Turtle
            br.ui:createSpinner(section, "Aspect Of The Turtle",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Exhilaration
            br.ui:createSpinner(section, "Exhilaration",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        br.ui:checkSectionState(section)
        -- corruption
        section = br.ui:createSection(br.ui.window.profile, "Corruption Management")
            br.ui:createCheckbox(section,"Enable Corruption")
            br.ui:createCheckbox(section,"Ice Trap")
            br.ui:createCheckbox(section,"Binding Shot")
            br.ui:createCheckbox(section,"Intimidation")
            br.ui:createCheckbox(section,"Conc Shot")
            br.ui:createCheckbox(section,"Tar Trap")
            --br.ui:createCheckbox(section,"Disengage?")
            br.ui:createCheckbox(section,"Feign Thing")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Counter Shot
            br.ui:createCheckbox(section,"Counter Shot")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

local function runRotation()
--------------
--- Locals ---
--------------
    local buff                               = br.player.buff
    local cast                               = br.player.cast
    local cd                                 = br.player.cd
    local charges                            = br.player.charges
    local debuff                             = br.player.debuff
    local enemies                            = br.player.enemies
    local equiped                            = br.player.equiped
    local essence                            = br.player.essence
    local focus                              = br.player.power.focus.amount()
    local focusMax                           = br.player.power.focus.max()
    local focusRegen                         = br.player.power.focus.regen()
    local focusTTM                           = br.player.power.focus.ttm()
    local focusDeficit                       = br.player.power.focus.deficit()
    local gcd                                = br.player.gcd
    local gcdMax                             = br.player.gcdMax
    local gcdFixed                           = GetSpellCooldown(61304) + .150
    local has                                = br.player.has
    local inCombat                           = br.player.inCombat
    local inInstance                         = br.player.instance=="party"
    local inRaid                             = br.player.instance=="raid"
    local item                               = br.player.items
    local level                              = br.player.level
    local mode                               = br.player.ui.mode
    local opener                             = br.player.opener
    local php                                = br.player.health
    local potion                             = br.player.potion
    local race                               = br.player.race
    local spell                              = br.player.spell
    local talent                             = br.player.talent
    local traits                             = br.player.traits
    local ttm                                = br.player.power.focus.ttm()
    local units                              = br.player.units
    local use                                = br.player.use
    local petTarget                          = "target"
    local explosiveCount                     = 0

    -- Global Functions
    local flying                             = IsFlying()
    local healPot                            = getHealthPot()
    local pullTimer                          = PullTimerRemain()
    local thp                                = getHP
    local ttd                                = getTTD
    local haltProfile                        = ((inCombat and profileStop) or IsMounted() or flying
                                            or pause() or buff.feignDeath.exists() or mode.rotation==4)

    if buff.aspectOfTheWild.exists("player") then
        gcdFixed = math.max(0.75, gcdFixed - 0.2 / (1 + GetHaste() / 100))
    end

    local function ttd(unit)
        if UnitIsPlayer(unit) then return 999 end
        local ttdSec = getTTD(unit)
        if getOptionCheck("Enhanced Time to Die") then return ttdSec end
        if ttdSec == -1 then return 999 end
        return ttdSec
    end
    

    -- Get Best Unit for Range
    -- units.get(range, aoe)
    units.get(40)

    -- Get List of Enemies for Range
    -- enemies.get(range, from unit, no combat, variable)
    enemies.get(40)
    enemies.get(40,"player",false,true)
    enemies.get(40,"player",true)
    enemies.get(30,"pet")
    enemies.get(20,"pet")
    enemies.get(8,"pet")
    enemies.get(5,"pet")

    if mode.misdirection == 1 then
        local misdirectUnit
        if getOptionValue("Misdirection") == 1 then
            for i = 1, #br.friend do
                local thisFriend = br.friend[i].unit
                if (thisFriend == "TANK" or UnitGroupRolesAssigned(thisFriend) == "TANK")
                    and not UnitIsDeadOrGhost(thisFriend)
                then
                    misdirectUnit = thisFriend
                end
            end
        end
        if getOptionValue("Misdirection") == 2 and not UnitIsDeadOrGhost("focus") and GetUnitIsFriend("focus","player") then
            misdirectUnit = "focus"
        end
        if getOptionValue("Misdirection") == 3 then
            misdirectUnit = "pet"
        end
        if misdirectUnit ~= nil then
            for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
                if UnitThreatSituation(misdirectUnit, thisUnit) ~= nil and UnitThreatSituation(misdirectUnit, thisUnit) <= 2 then
                    if cast.misdirection(misdirectUnit) then
                        return
                    end
                end
            end
        end
    end
    if timersTable then
        wipe(timersTable)
    end
    if mode.bestCleave == 1 then
        local biggestGroup = 0
        local bestUnit
        for i = 1, #enemies.yards20p do
            local thisUnit = enemies.yards20p[i]
            local thisGroup = #enemies.get(8,thisUnit)
            local targetGroup = #enemies.get(8,"target")
            if thisGroup > biggestGroup and thisGroup>targetGroup then
                thisGroup = biggestGroup
                bestUnit = thisUnit
            end
        end
        if br.timer:useTimer("Hunter Burn Timer", getOptionValue("Humanize Switching for Burn")) then
            for i = 1, GetObjectCountBR() do
                local object = GetObjectWithIndex(i)
                local ID = ObjectID(object)
                local distance = getDistance(object,"pet")
                if ObjectID("target") ~= 120651 and ObjectID(object) == 120651 and distance <= 8 and getHP(object) > 0 and not UnitIsDeadOrGhost(object)then 
                    TargetUnit(object) 
                else
                    TargetUnit(bestUnit)
                end
            end
        end
    end
    --75
    local Barb1 = buff.frenzy.remains("pet") <= (gcdFixed)
    --85
    local Barb2 = charges.barbedShot.timeTillFull() < gcdFixed and buff.bestialWrath.exists()
    --123
    local Barb3 = charges.barbedShot.frac() >= 1.8 or buff.bestialWrath.exists() or ((cd.aspectOfTheWild.remains() < (buff.frenzy.remains("pet") - gcdFixed)) and traits.primalInstincts.active) or charges.barbedShot.frac() > 1.4 or ttd("target") < 9 

    local function AoEBarbed()
        if cast.barbedShot(debuff.barbedShot.lowestPet()) then return end
    end

    for i = 1, #enemies.yards8p do
        local thisUnit = enemies.yards8p[i]
        if isExplosive(thisUnit) or (UnitIsOtherPlayersPet(thisUnit) and br.player.instance == "arena")then
            explosiveCount = explosiveCount + 1
        end
    end

    local unitcount
    if #enemies.yards8p > 1 then
        unitcount = #enemies.yards8p - explosiveCount
    else
        unitcount = 1
    end

    -----------PET SHIT-----------

    local petActive = IsPetActive()
    local petCombat = UnitAffectingCombat("pet")
    local petDistance = getDistance(petTarget,"pet") or 99
    local petExists = UnitExists("pet")
    local petHealth = getHP("pet")
    local validTarget = UnitExists(petTarget) and (isValidUnit(petTarget) or isDummy()) --or (not UnitExists("pettarget") and isValidUnit("target")) or isDummy()

    if IsMounted() or IsFlying() or UnitHasVehicleUI("player") or CanExitVehicle("player") then
        waitForPetToAppear = GetTime()
    elseif mode.petSummon ~= 6 then
        local callPet = spell["callPet"..mode.petSummon]
        if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
            if cast.able.dismissPet() and petExists and petActive and (callPet == nil or UnitName("pet") ~= select(2,GetCallPetSpellInfo(callPet))) then
                if cast.dismissPet() then waitForPetToAppear = GetTime(); return true end
            elseif callPet ~= nil then
                if br.deadPet or (petExists and petHealth == 0) then
                    if cast.able.revivePet() and cast.timeSinceLast.revivePet() > gcdMax then
                        if cast.revivePet("player") then waitForPetToAppear = GetTime(); return true end
                    end
                elseif not br.deadPet and not petExists and not buff.playDead.exists("pet") then
                    if castSpell("player",callPet,false,false,false,true,true,true,true,false) then waitForPetToAppear = GetTime(); return true end
                end
            end
        end
        if waitForPetToAppear == nil then
            waitForPetToAppear = GetTime()
        end
    end

    if isChecked("Enemy Target Lock") and inCombat and UnitIsFriend("target", "player") then
        TargetLastEnemy()
    end

    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil or (not inCombat and not UnitExists("target") and profileStop == true) then
        profileStop = false
    end

    local function hunterTTD()
        for i = 1, #enemies.yards20p do
            local thisUnit = enemies.yards20p[i]
            if ttd(thisUnit) >= 7 or not isChecked("Use TTD for Aspect and Bestial") then
                return true
            else 
                return false
            end
        end
    end

    local function Shadowshit()
        if isChecked("Enable Corruption") then
            for i = 1, GetObjectCountBR() do
                local object = GetObjectWithIndex(i)
                local ID = ObjectID(object)
                if ID == 161895 then
                    local x1, y1, z1 = ObjectPosition("player")
                    local x2, y2, z2 = ObjectPosition(object)
                    local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                    if not (debuff.freezingTrap.exists(object) or debuff.intimidation.exists(object)) 
                    and not (cast.last.freezingTrap() or cast.last.bindingShot() or cast.last.intimidation() or cast.last.feignDeath()) then
                        if cast.able.freezingTrap() and isChecked("Ice Trap") then
                            if distance <= 40 then
                                if cast.freezingTrap(object) then
                                    return true
                                end
                            end
                        elseif cast.able.bindingShot() and isChecked("Binding Shot") then
                            if distance < 30 then
                                if cast.bindingShot(object) then
                                    return true
                                end
                            end
                        elseif cast.able.intimidation() and getDistance(object,"pet") <= 8 and isChecked("Intimidation") then
                            if cast.intimidation(object) then
                                return true
                            end
                        elseif cast.able.concussiveShot() and isChecked("Conc Shot") then
                            if distance < 40 then
                                if cast.concussiveShot(object) then
                                    return true
                                end
                            end
                        elseif cast.able.tarTrap() and isChecked("Tar Trap") then
                            if distance < 40 then
                                if cast.tarTrap(object) then
                                    return true
                                end
                            end
                        --[[ elseif cast.able.disengage() and isChecked("Disengage?") then
                            if distance < 30 then
                                local facing = ObjectFacing("Player")
                                local mouselookActive = false
                                if IsMouselooking() then
                                    mouselookActive = true
                                    MouselookStop()
                                end
                                FaceDirection(object, true)
                                CastSpellByName(GetSpellInfo(781))
                                FaceDirection(facing)
                                if mouselookActive then
                                    MouselookStart()
                                end
                                C_Timer.After(0.1, function()
                                    FaceDirection(ObjectFacing("player"), true)
                                end)
                            end ]]
                        elseif (cd.freezingTrap.remains() > gcdFixed or not isChecked("Ice Trap")) and cast.able.feignDeath() and isChecked("Feign Thing") then
                            if cast.feignDeath() then
                                feignTime = GetTime()
                            end
                        end
                    end
                end
            end
        end
    end

    local function actionlist_Pet()
        if isChecked("Spirit Mend") and cast.able.spiritmend() and getHP("player") <= getOptionValue("Spirit Mend") then
            if cast.spiritmend("player") then return end
        end
        if isChecked("Cat-like Reflexes") and cast.able.catlikeReflexes() and petHealth <= getOptionValue("Cat-like Reflexes") then
            if cast.catlikeReflexes() then return end
        end
        if isChecked("Survival of the Fittest") and cast.able.survivalOfTheFittest()
            --[[and petCombat ]]and (petHealth <= getOptionValue("Survival of the Fittest") or php <= getOptionValue("Survival of the Fittest"))
        then
            if cast.survivalOfTheFittest() then return end
        end
        -- Bite/Claw
        if isChecked("Bite / Claw") and petCombat and validTarget and petDistance < 5 and not haltProfile and not isTotem(petTarget) then
            if cast.able.bite() then
                if cast.bite(petTarget,"pet") then return end
            end
            if cast.able.claw() then
                if cast.claw(petTarget,"pet") then return end
            end
        end
        -- Dash
        if isChecked("Dash") and cast.able.dash() and inCombat and validTarget and petDistance > 10 and getDistance(petTarget) < 40 then
            if cast.dash("pet") then return end
        end
        -- Purge
        if isChecked("Purge") and inCombat then
            if #enemies.yards40f > 0 then
                local dispelled = false
                local dispelledUnit = "player"
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if getOptionValue("Purge") == 1 or (getOptionValue("Purge") == 2 and UnitIsUnit(thisUnit,"target")) then
                        if isValidUnit(thisUnit) and canDispel(thisUnit,spell.spiritPulse) then
                            if cast.able.tranquilizingShot(thisUnit) then
                                if cast.tranquilizingShot(thisUnit) then return end
                            end
                            if cast.able.spiritPulse(thisUnit,"pet") then
                                if cast.spiritPulse(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            elseif cast.able.chiJiTranq(thisUnit,"pet") then
                                if cast.chiJiTranq(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            elseif cast.able.naturesGrace(thisUnit,"pet") then
                                if cast.naturesGrace(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            elseif cast.able.netherEnergy(thisUnit,"pet") then
                                if cast.netherEnergy(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            elseif cast.able.sonicScreech(thisUnit,"pet") then
                                if cast.sonicScreech(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            elseif cast.able.soothingWater(thisUnit,"pet") then
                                if cast.soothingWater(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            elseif cast.able.sporeCloud(thisUnit,"pet") then
                                if cast.sporeCloud(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                            end
                        end
                    end
                end
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
        -- Prowl
        if isChecked("Prowl / Spirit Walk") and not petCombat and (not IsResting() or isDummy()) and #enemies.yards40nc > 0 then
            if cast.able.spiritWalk() and not buff.spiritWalk.exists("pet") then
                if cast.spiritWalk("pet") then return end
            end
            if cast.able.prowl() and not buff.prowl.exists("pet") then
                if cast.prowl("pet") then return end
            end
        end
        -- Mend Pet
        if isChecked("Mend Pet") and cast.able.mendPet() and petExists and not br.deadPet
            and not buff.mendPet.exists("pet") and petHealth < getOptionValue("Mend Pet") and not haltProfile and not pause()
        then
            if cast.mendPet() then return end
        end
    end

    local function ST()
        if (useCDs() and isChecked("Aspect of the Wild") and cd.aspectOfTheWild.remains() <= 2) and 
        ((not cast.able.bestialWrath() and (mode.bestialWrath == 1 or mode.bestialWrath == 2 and useCDs())) or mode.bestialWrath == 3)
        and (not cast.able.killCommand() or buff.frenzy.stack("pet")< 3) then
            if cast.barbedShot("target") then return end
        end

        if not Barb1 and talent.killerCobra and buff.danceOfDeath.remains() < (gcdFixed + 2) and charges.barbedShot.frac() < 1.3 then
            if buff.bestialWrath.exists("player") then
                if useCDs() then if cast.aspectOfTheWild() then return end end
                if cast.killCommand("target") then return end
                if (cd.killCommand.remains() >= (gcdFixed+1) or focusDeficit <= 40) then
                    if cast.cobraShot("target") then return end
                end
            end
        end

        if hunterTTD() and not buff.aspectOfTheWild.exists() and isChecked("Aspect of the Wild") and useCDs() and ((charges.barbedShot.frac() <= 1.2 or not traits.primalInstincts.active) or buff.frenzy.stack("pet")< 3) then
            if cast.aspectOfTheWild() then return end
        end

        if hunterTTD() and (mode.bestialWrath == 1 or (mode.bestialWrath == 2 and useCDs())) and (buff.bestialWrath.remains() < gcdFixed) then
            if cast.bestialWrath() then return end
        end

        if traits.danceOfDeath.rank > 1 and buff.danceOfDeath.remains() < (gcdFixed + 2) and charges.barbedShot.frac() >= 1.1 then
            if cast.barbedShot("target") then return end
        end

        if cast.killCommand("target") then return end

        if charges.barbedShot.frac() >= 1.8 then
            if cast.barbedShot("target") then return end
        end
        if not Barb1 and (buff.frenzy.remains("pet") >= 2 or charges.barbedShot.frac() <= 0.7) and (cd.killCommand.remains() >= (gcdFixed+1) or focusDeficit <= 40) then
            if not buff.bestialWrath.exists() and buff.frenzy.exists("pet") and buff.frenzy.remains("pet") <= gcdFixed*2 and focusTTM > gcdFixed *2 then
                return false
            else 
                if cast.cobraShot("target") then return end
            end
        end
    end

    local function AOE()
        if (useCDs() and isChecked("Aspect of the Wild") and cd.aspectOfTheWild.remains() <= 2) and ((not cast.able.bestialWrath() and (mode.bestialWrath == 1 or mode.bestialWrath == 2 and useCDs())) or mode.bestialWrath == 3) then
            if cast.barbedShot("target") then return end
        end
        if (((buff.frenzy.exists("pet") and buff.frenzy.remains("pet") <= 2) or charges.barbedShot.frac() >= 1.8 or not buff.frenzy.exists("pet"))
            and (not useCDs() or (cd.aspectOfTheWild.remains() < gcdFixed))) or Barb1
        then
            if AoEBarbed() then Print("Barbed1") return end
        end

        if buff.beastCleave.remains("pet") < gcdFixed then
            if cast.multishot() then return end
        end

        if Barb2 then
            if AoEBarbed() then return end
        end

        if hunterTTD() and not buff.aspectOfTheWild.exists() and isChecked("Aspect of the Wild") and useCDs() and ((charges.barbedShot.frac() <= 1.2 or not traits.primalInstincts.active) or buff.frenzy.stack("pet")< 3)then
            if cast.aspectOfTheWild() then return end
        end

        if hunterTTD() and (mode.bestialWrath == 1 or (mode.bestialWrath == 2 and useCDs())) and (buff.bestialWrath.remains() < gcdFixed) then
            if cast.bestialWrath() then return end
        end

        if not Barb1 and (#enemies.yards8p < 4 or not traits.rapidReload.active) then
            if cast.killCommand() then return end
        end

        if Barb3 then
            if AoEBarbed() then return end
        end

        if traits.rapidReload.active and #enemies.yards8p > 2 and not Barb1 then
            if cast.multishot() then return end
        end

        if cd.killCommand.remains() > focusTTM and (#enemies.yards8p < 3 or not traits.rapidReload.active) and not Barb1 then
            if cast.cobraShot() then return end
        end
    end

    local function defensive()
        if useDefensive() then
            if isChecked("Pot/Stoned") and (use.able.healthstone() or canUseItem(healPot))
            and php <= getOptionValue("Pot/Stoned") and inCombat and (hasHealthPot() or has.healthstone()) 
            then
                if use.able.healthstone() then
                    use.healthstone()
                elseif canUseItem(healPot) then
                    useItem(healPot)
                end
            end

            if isChecked("Aspect Of The Turtle") and php <= getOptionValue("Aspect Of The Turtle") then
                if cast.aspectOfTheTurtle("player") then return end
            end

            if isChecked("Exhilaration") and php <= getOptionValue("Exhilaration") then
                if cast.exhilaration("player") then return end
            end
        end
    end

    local function interrupt()
        if useInterrupts() then
            if isChecked("Counter Shot") then
                for i=1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                        if cast.counterShot(thisUnit) then return end
                    end
                end
            end 
        end
    end

    local function offGCD()
        if actionlist_Pet() then return end
        if interrupt() then return end
        if inCombat and #enemies.yards40 >= 1 then
                PetAttack("target") 
                StartAttack()
        end
    end
    if feignTime == nil or (feignTime ~= nil and (GetTime() - feignTime > 1.2)) then
        if offGCD() then return end
        if not Barb1 then 
            if defensive() then return end
            if Shadowshit() then return end
        end
        if pause(true) or (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) or mode.rotation == 4 then
            return true
        else
            if inCombat then
                if (unitcount >= getOptionValue("Units To AoE")) and (mode.rotation == 2 or mode.rotation == 1) then
                    if AOE() then return end
                elseif unitcount < getOptionValue("Units To AoE") or mode.rotation == 3 then
                    if ST() then return end
                end
            end
        end
    end
end


local id = 0 --253
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
