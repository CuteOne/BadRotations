-- Action List - Pet Management
local br = _G["br"]
-- BR API Locals
local buff
local cast
local cd
local debuff
local enemies
local mode
local pet
local spell
local ui
local unit
local units
local var
local currentTarget
local fetching = false
local fetchCount = 0
local paused = false
local pausekey = false
local petAppearTimer = GetTime()
local petCalled = false
local petRevived = false
local targetSwitchTimer = GetTime()

br.rotations.support["PetCuteOne"] = {
    options = function()
        -- Pet Options    
        local section = br.ui:createSection(br.ui.window.profile, "Pet")
            -- Pet Target
            br.ui:createDropdownWithout(section, "Pet Target", {"Dynamic Unit", "Only Target", "Any Unit", "Assist"},1,"Select how you want pet to acquire targets.")
            -- Auto Attack/Passive
            br.ui:createCheckbox(section, "Auto Attack/Passive")
            -- Spec Ability
            br.ui:createCheckbox(section, "Master's Call - Cunning","|cffFFFFFFSelect to use. - Cunning Pets Only")
            br.ui:createDropdownWithout(section,"Primal Rage - Ferocity",{"Always","Cooldowns","Never"}, 1, "|cffFFFFFFSelect when to use - Ferocity Pets Only")
            br.ui:createSpinner(section,"Survival of the Fittest - Tenacity", 20, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast - Tenacity Pets Only")
            -- Attack Ability
            br.ui:createCheckbox(section, "Use Attack Ability","|cffFFFFFFPet will use Bite/Claw/Smack")
            -- Defense Ability
            br.ui:createSpinner(section, "Use Defense Ability", 30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast it's Defense/Dodge Ability")
            -- Debuff Ability
            br.ui:createCheckbox(section, "Use Debuff Ability", "|cffFFFFFFPet will use ability that debuffs the target with Mortal Wounds, if available.")
            -- Heal Ability
            br.ui:createSpinner(section, "Use Heal Ability", 30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast it's Heal Ability **Not all have heals**")
            -- Purge Ability
            br.ui:createDropdown(section, "Use Purge Ability", {"Every Unit","Only Target"}, 2, "Select if you want Purge only Target or every Unit arround the Pet")
            -- Utility Ability
            br.ui:createCheckbox(section, "Use Utility Ability", "|cffFFFFFFPet will use Slow Fall / Water Walking, if available.")
            -- Auto Growl
            br.ui:createCheckbox(section, "Auto Growl","|cffFFFFFFPet will growl any valid enemy it does not have threat on, disables if tank nearby.")
            -- Dash
            br.ui:createCheckbox(section, "Dash")
            -- Fetch
            br.ui:createCheckbox(section, "Fetch","|cffFFFFFFPet will fetch loot, if available.")
            -- Mend Pet
            br.ui:createSpinner(section, "Mend Pet",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Play Dead / Wake Up
            br.ui:createSpinner(section, "Play Dead / Wake Up", 25,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At, if available.")
            -- Stealth
            br.ui:createCheckbox(section, "Stealth", "|cffFFFFFFPet will use Prowl or Spirit Walk, if available.")
        br.ui:checkSectionState(section)
    end,
    run = function()
        local function getCurrentPetMode()
            local petMode = "None"
            for i = 1, NUM_PET_ACTION_SLOTS do
                local name, _, _,isActive = GetPetActionInfo(i)
                if isActive then
                    if name == "PET_MODE_ASSIST" then petMode = "Assist" end
                    if name == "PET_MODE_DEFENSIVEASSIST" then petMode = "Defensive" end
                    if name == "PET_MODE_PASSIVE" then petMode = "Passive" end
                end
            end
            return petMode
        end
        
        local function getLootableCount()
            local count = 0
            for k, v in pairs(br.lootable) do
                if br.lootable[k] ~= nil and unit.distance(br.lootable[k]) > 8 then
                    count = count + 1
                end
            end
            return count
        end

        --Set Pause Key
        if SpecificToggle("Pause Mode") == nil or br.player.ui.value("Pause Mode") == 6 then
            pausekey = IsLeftAltKeyDown()
        else
            pausekey = SpecificToggle("Pause Mode")
        end
        paused = pausekey and GetCurrentKeyBoardFocus() == nil and br.player.ui.checked("Pause Mode")

        ---------------------
        --- Define Locals ---
        ---------------------
        -- BR API Locals
        buff                                          = br.player.buff
        cast                                          = br.player.cast
        cd                                            = br.player.cd
        debuff                                        = br.player.debuff
        enemies                                       = br.player.enemies
        mode                                          = br.player.ui.mode
        pet                                           = br.player.pet
        spell                                         = br.player.spell
        ui                                            = br.player.ui
        unit                                          = br.player.unit
        units                                         = br.player.units
        var                                           = br.player.variables
        -- General Locals
        var.haltPetProfile                                  = UnitCastingInfo("pet") or UnitHasVehicleUI("player") or CanExitVehicle("player") or UnitOnTaxi("player") or unit.mounted() or unit.flying()
                                                                or paused or buff.feignDeath.exists() or buff.playDead.exists("pet") or mode.rotation==4
        -- Pet Specific Locals
        local callPet                                       = spell["callPet"..mode.petSummon]
        local callPetName                                   = mode.petSummon < 6 and select(2,GetCallPetSpellInfo(callPet)) or ""
        local friendUnit                                    = br.friend[1].unit
        local petActive                                     = pet.active.exists()
        local petDistance                                   = unit.distance(br.petTarget,"pet") or 99
        local petExists                                     = unit.exists("pet")
        local petHealth                                     = unit.hp("pet")
        local petMode                                       = getCurrentPetMode()
        local validTarget                                   = unit.exists(br.petTarget) and (unit.valid(br.petTarget) or unit.isDummy()) --or (not unit.exists(br.petTarget) and unit.valid("target")) or unit.isDummy()

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
        enemies.get(40,"pet",true)
        enemies.get(40,"player",false,true)
        enemies.get(40,"pet")
        enemies.yards40r = getEnemiesInRect(10,40,false) or 0

        -- Pet Target Modes
        if br.petTarget == nil then br.petTarget = "player" end
        if br.petTarget ~= "player" and (not unit.exists(br.petTarget) or unit.deadOrGhost(br.petTarget) or not UnitIsUnit("pettarget",br.petTarget)) then br.petTarget = "player" end
        if br.petTarget == "player" or (unit.exists("pettarget") and not unit.isUnit("pettarget",br.petTarget) and not unit.deadOrGhost(br.petTarget)) then
            -- Dynamic
            if ui.value("Pet Target") == 1 and units.dyn40 ~= nil
                and (br.petTarget == "player" or (unit.exists("pettarget") and not unit.isUnit(units.dyn40,br.petTarget)))
            then
                br.petTarget = units.dyn40
                if unit.exists(br.petTarget) then ui.debug("[Pet - Target Mode Dynamic] Pet is now targeting - "..unit.name(br.petTarget)) end
            end
            -- Target
            if ui.value("Pet Target") == 2 and unit.valid("target")
                and (br.petTarget == "player" or (unit.exists("pettarget") and not unit.isUnit("target",br.petTarget)))
            then
                br.petTarget = "target"
                if unit.exists(br.petTarget) then ui.debug("[Pet - Target Mode Only Target] Pet is now targeting - "..unit.name(br.petTarget)) end
            end
            -- Any
            if ui.value("Pet Target") == 3 and enemies.yards40[1] ~= nil
                and (br.petTarget == "player" or (unit.exists("pettarget") and not unit.isUnit(enemies.yards40[1],br.petTarget)))
            then
                br.petTarget = enemies.yards40[1]
                if unit.exists(br.petTarget) then ui.debug("[Pet - Target Mode Any Unit] Pet is now targeting - "..unit.name(br.petTarget)) end
            end
            -- Assist
            if ui.value("Pet Target") == 4 and (br.petTarget == "player" or (unit.exists("pettarget") and not unit.isUnit("pettarget",br.petTarget))) then
                br.petTarget = "pettarget"
                if unit.exists(br.petTarget) then ui.debug("[Pet - Target Mode Assist] Pet is now targeting - "..unit.name(br.petTarget)) end
            end
        end

        -- Pet Summoning (Call, Dismiss, Revive)
        if mode.petSummon ~= 6 and not var.haltPetProfile and not pause() and not unit.falling() then
            if petAppearTimer < GetTime() - 2 then
                -- Check for Pet
                if (petCalled or petRevived) and petExists and petActive then petCalled = false; petRevived = false end
                -- Dismiss Pet
                if cast.able.dismissPet() and petExists and petActive and (callPet == nil or unit.name("pet") ~= callPetName) then
                    if cast.dismissPet("player") then ui.debug("[Pet] Cast Dismiss Pet") petAppearTimer = GetTime(); return true end
                end
                if mode.petSummon <  6 and callPetName ~= "" then
                    -- Call Pet
                    if ((not br.deadPet and not petExists) or not petActive) and not buff.playDead.exists("pet") and not petCalled then
                        if cast["callPet"..mode.petSummon]("player") then ui.debug("[Pet] Call Pet") --[[ui.print("Hey "..callPetName.."...WAKE THE FUCK UP! It's already past noon!...GET YOUR LIFE TOGETHER!")]] petAppearTimer = GetTime(); petCalled = true; petRevived = false; return true end
                    end
                    -- Revive Pet
                    if br.deadPet or (petExists and petHealth == 0) or petCalled == true then
                        if cast.able.revivePet() and cast.timeSinceLast.revivePet() > unit.gcd(true) then
                            if cast.revivePet("player") then ui.debug("[Pet] Revive Pet") --[[ui.print("Hey "..callPetName.."...WAKE THE FUCK UP! It's already past noon!...GET YOUR LIFE TOGETHER!")]] petAppearTimer = GetTime(); petRevived = true; petCalled = false; return true end
                        end
                    end
                end
            end
        end

        -- Pet Combat Modes
        if ui.checked("Auto Attack/Passive") and petActive and petExists and not cast.last.dismissPet() and targetSwitchTimer < GetTime() -1 then
            -- Set Pet Modes
            if ui.value("Pet Target") == 4 and unit.inCombat() and (petMode == "Defensive" or petMode == "Passive") and not var.haltPetProfile  and petMode ~= "Assist" then
                ui.debug("[Pet] Pet is now Assisting")
                PetAssistMode()
            elseif (not unit.inCombat() or (unit.inCombat() and ui.value("Pet Target") ~= 4)) and #enemies.yards40pnc > 0 and not var.haltPetProfile  and petMode ~= "Defensive" then
                ui.debug("[Pet] Pet is now Defending")
                -- PetDefensiveMode()
                PetDefensiveAssistMode()
            elseif petMode ~= "Passive" and ((not unit.inCombat() and #enemies.yards40pnc == 0) or var.haltPetProfile) then
                ui.debug("[Pet] Pet is now Passive")
                PetPassiveMode()
            end
            -- Pet Attack / Retreat
            -- if br.petTarget == nil and unit.valid("target") then br.petTarget = "target" end
            if br.petTarget ~= "player" and not buff.playDead.exists("pet") and not var.haltPetProfile 
                and (not unit.exists("pettarget") or not unit.isUnit("pettarget",br.petTarget))
                and ((not unit.inCombat() and not unit.inCombat("pet")) 
                    or ((unit.inCombat() or unit.inCombat("pet")) and (currentTarget == nil or not unit.isUnit(br.petTarget,currentTarget))))
                and unit.distance("target") < 40           
            then
                ui.debug("[Pet] Pet is now attacking "..tostring(unit.name(br.petTarget)))
                PetAttack(br.petTarget)
                currentTarget = br.petTarget
            else
                if unit.exists("pettarget") and IsPetAttackActive()
                    and ((not unit.inCombat() and not unit.valid("target")) or (unit.inCombat() and not unit.valid(br.petTarget)) or var.haltPetProfile )
                then
                    ui.debug("[Pet] Pet stopped attacking!")
                    PetStopAttack()
                    if (#enemies.yards40 == 0 and #enemies.yards40p == 0) or var.haltPetProfile then 
                        ui.debug("[Pet] Pet is now following, Enemies40: "..#enemies.yards40..", var.haltPetProfile : "..tostring(var.haltPetProfile )) 
                        PetFollow()
                    end
                end
            end
            targetSwitchTimer = GetTime()
        end

        -- Manage Pet Abilities
        if not var.haltPetProfile  then
            -- Spec Abilities
            if unit.inCombat("pet") then
                if ui.checked("Master's Call - Cunning") and cast.noControl.mastersCall() then
                    if cast.mastersCall() then ui.debug("[Pet] Cast Master's Call") return true end
                end
                if ui.value("Primal Rage - Ferocity") == 1 or (ui.value("Primal Rage") == 2 and ui.useCDs()) then
                    if cast.primalRage() then ui.debug("[Pet] Cast Primal Rage") return true end
                end
                if ui.checked("Survival of the Fittest - Tenacity") and unit.hp("pet") < ui.value("Survival of the Fittest - Tenacity") then
                    if cast.survivalOfTheFittest() then ui.debug("[Pet] Cast Survival of the Fittest") return true end
                end
            end
            -- Attack Abilities
            if ui.checked("Use Attack Ability") and unit.inCombat("pet") and validTarget and petDistance < 5 and not isTotem(br.petTarget) then
                -- Bite
                if cast.able.bite() then
                    if cast.bite(br.petTarget,"pet") then ui.debug("[Pet] Cast Bite") return true end
                end
                -- Claw
                if cast.able.claw() then
                    if cast.claw(br.petTarget,"pet") then ui.debug("[Pet] Cast Claw") return true end
                end
                -- Smack
                if cast.able.smack() then
                    if cast.smack(br.petTarget,"pet") then ui.debug("[Pet] Cast Smack") return true end
                end
                -- Burrow Attack
                if cast.able.burrowAttack() and #enemies.yards8p > 2 then
                    if cast.burrowAttack() then ui.debug("[Pet] Cast Burrow Attack") return true end
                end
                -- Froststorm Breath
                if cast.able.froststormBreath() and #enemies.yards8p > 2 then
                    if cast.froststormBreath() then ui.debug("[Pet] Cast Froststorm Breath") return true end
                end
            end
            -- Defense Abilities
            if ui.checked("Use Defense Ability") and unit.inCombat("pet") and unit.hp("pet") < ui.value("Use Defense Ability") then
                -- Agile Reflexes
                if cast.able.agileReflexes() then 
                    if cast.agileReflexes() then ui.debug("[Pet] Cast Agile Reflexes") return true end
                end
                -- Bristle
                if cast.able.bristle() then 
                    if cast.bristle() then ui.debug("[Pet] Cast Bristle") return true end
                end
                -- Bulwark
                if cast.able.bulwark() then 
                    if cast.bulwark() then ui.debug("[Pet] Cast Bulwark") return true end
                end
                -- Cat-like Reflexes
                if cast.able.catlikeReflexes() then 
                    if cast.catlikeReflexes() then ui.debug("[Pet] Cast Cat-like Reflexes") return true end
                end
                -- Defense Matrix
                if cast.able.defenseMatrix() then 
                    if cast.defenseMatrix() then ui.debug("[Pet] Cast Defense Matrix") return true end
                end
                -- Dragon'checkSectionState Guile
                if cast.able.dragonsGuile() then 
                    if cast.dragonsGuile() then ui.debug("[Pet] Cast Dragon's Guile") return true end
                end
                -- Feather Flurry
                if cast.able.featherFlurry() then 
                    if cast.featherFlurry() then ui.debug("[Pet] Cast Feather Flurry") return true end
                end
                -- Fleethoof
                if cast.able.fleethoof() then 
                    if cast.fleethoof() then ui.debug("[Pet] Cast Fleethood") return true end
                end
                -- Harden Carapace
                if cast.able.hardenCarapace() then 
                    if cast.hardenCarapace() then ui.debug("[Pet] Cast Harden Carapace") return true end
                end
                -- Obsidian Skin
                if cast.able.obsidianSkin() then 
                    if cast.obsidianSkin() then ui.debug("[Pet] Cast Obsidian Skin") return true end
                end
                -- Primal Agility
                if cast.able.primalAgility() then 
                    if cast.primalAgility() then ui.debug("[Pet] Cast Primal Agility") return true end
                end
                -- Scale Shield
                if cast.able.scaleShield() then 
                    if cast.scaleShield() then ui.debug("[Pet] Cast Scale Shield") return true end
                end
                -- Serpent Swiftness
                if cast.able.serpentSwiftness() then 
                    if cast.serpentSwiftness() then ui.debug("[Pet] Cast Serpent Swiftness") return true end
                end
                -- Shell Shield
                if cast.able.shellShield() then 
                    if cast.shellShield() then ui.debug("[Pet] Cast Shell Shield") return true end
                end
                -- Solid Shell
                if cast.able.solidShell() then 
                    if cast.solidShell() then ui.debug("[Pet] Cast Solid Shell") return true end
                end
                -- Swarm Of Flies
                if cast.able.swarmOfFlies() then 
                    if cast.swarmOfFlies() then ui.debug("[Pet] Cast Swarm of Flies") return true end
                end
                -- Winged Agility
                if cast.able.wingedAgility() then 
                    if cast.wingedAgility() then ui.debug("[Pet] Cast Winged Agility") return true end
                end
            end
            -- Debuff Abilities
            if ui.checked("Use Debuff Ability") and unit.inCombat("pet") and validTarget and petDistance < 5 and not isTotem(br.petTarget) and debuff.mortalWounds.refresh(br.petTarget) then
                -- Acid Bite
                if cast.able.acidBite() then
                    if cast.acidBite(br.petTarget) then ui.debug("[Pet] Cast Acid Bite") return true end
                end
                -- Bloody Screech
                if cast.able.bloodyScreech() then
                    if cast.bloodyScreech(br.petTarget) then ui.debug("[Pet] Cast Bloody Screech") return true end
                end
                -- Deadly Sting
                if cast.able.deadlySting() then
                    if cast.deadlySting(br.petTarget) then ui.debug("[Pet] Cast Deadly Sting") return true end
                end
                -- Gnaw
                if cast.able.gnaw() then
                    if cast.gnaw(br.petTarget) then ui.debug("[Pet] Cast Gnaw") return true end
                end
                -- Gore
                if cast.able.gore() then
                    if cast.gore(br.petTarget) then ui.debug("[Pet] Cast Gore") return true end
                end
                -- Grievous Bite
                if cast.able.grievousBite() then
                    if cast.grievousBite(br.petTarget) then ui.debug("[Pet] Cast Grievous Bite") return true end
                end
                -- Gruesome Bite
                if cast.able.gruesomeBite() then
                    if cast.gruesomeBite(br.petTarget) then ui.debug("[Pet] Cast Gruesome Bite") return true end
                end
                -- Infected Bite
                if cast.able.infectedBite() then
                    if cast.infectedBite(br.petTarget) then ui.debug("[Pet] Cast Infected Bite") return true end
                end
                -- Monsterous Bite
                if cast.able.monsterousBite() then
                    if cast.monsterousBite(br.petTarget) then ui.debug("[Pet] Cast Monsterous Bite") return true end
                end
                -- Ravage
                if cast.able.ravage() then
                    if cast.ravage(br.petTarget) then ui.debug("[Pet] Cast Ravage") return true end
                end
                -- Savage Rend
                if cast.able.savageRend() then
                    if cast.savageRend(br.petTarget) then ui.debug("[Pet] Cast Savage Rend") return true end
                end
                -- Toxic Sting
                if cast.able.toxicSting() then
                    if cast.toxicSting(br.petTarget) then ui.debug("[Pet] Cast Toxic Sting") return true end
                end                
            end
            -- Heal Abilities
            if ui.checked("Use Heal Ability") then
                -- Eternal Guardian
                if cast.able.eternalGuardian() and (br.deadPet or (petExists and petHealth == 0)) then
                    if cast.eternalGuardian() then ui.debug("[Pet] Cast Eternal Guardian") return true end
                end
                -- Feast
                if cast.able.feast() and unit.hp("pet") < ui.value("Use Heal Ability") then
                    if (unit.deadOrGhost("target") and (isBeast("target") or isHumanoid("target"))) then
                        if cast.feast("target") then ui.debug("[Pet] Cast Feast on dead target.") return true end
                    end
                    if (unit.deadOrGhost("mouseover") and (isBeast("mouseover") or isHumanoid("mouseover"))) then
                        if cast.feast("mouseover") then ui.debug("[Pet] Cast Feast on dead mouseover.") return true end
                    end
                end
                -- Spirit Mend
                if cast.able.spiritmend() and unit.inCombat("pet") and unit.hp(friendUnit) <= ui.value("Use Heal Ability") then
                    if cast.spiritmend(friendUnit) then ui.debug("[Pet] Cast Spirit Mend on lowest HP Unit") return true end
                end
            end
            -- Purge Ability
            if ui.checked("Use Purge Ability") and unit.inCombat() then
                if #enemies.yards5p > 0 then
                    local dispelled = false
                    local dispelledUnit = "player"
                    for i = 1, #enemies.yards5p do
                        local thisUnit = enemies.yards5p[i]
                        if ui.value("Purge") == 1 or (ui.value("Purge") == 2 and unit.isUnit(thisUnit,"target")) then
                            if unit.valid(thisUnit) and cast.dispel.spiritPulse(thisUnit) then --canDispel(thisUnit,spell.spiritPulse) then
                                if cast.able.spiritPulse(thisUnit,"pet") then
                                    if cast.spiritPulse(thisUnit,"pet") then ui.debug("[Pet] Cast Spirit Pulse") dispelled = true; dispelledUnit = thisUnit; break end
                                elseif cast.able.chiJiTranq(thisUnit,"pet") then
                                    if cast.chiJiTranq(thisUnit,"pet") then ui.debug("[Pet] Cast Chi-Ji Tranquility") dispelled = true; dispelledUnit = thisUnit; break end
                                elseif cast.able.naturesGrace(thisUnit,"pet") then
                                    if cast.naturesGrace(thisUnit,"pet") then ui.debug("[Pet] Cast Nature's Grace") dispelled = true; dispelledUnit = thisUnit; break end
                                elseif cast.able.netherEnergy(thisUnit,"pet") then
                                    if cast.netherEnergy(thisUnit,"pet") then ui.debug("[Pet] Cast Nether Energy") dispelled = true; dispelledUnit = thisUnit; break end
                                elseif cast.able.sonicScreech(thisUnit,"pet") then
                                    if cast.sonicScreech(thisUnit,"pet") then ui.debug("[Pet] Cast Sonic Screech") dispelled = true; dispelledUnit = thisUnit; break end
                                elseif cast.able.soothingWater(thisUnit,"pet") then
                                    if cast.soothingWater(thisUnit,"pet") then ui.debug("[Pet] Cast Soothing Water") dispelled = true; dispelledUnit = thisUnit; break end
                                elseif cast.able.sporeCloud(thisUnit,"pet") then
                                    if cast.sporeCloud(thisUnit,"pet") then ui.debug("[Pet] Cast Spore Cloud") dispelled = true; dispelledUnit = thisUnit; break end
                                end
                            end
                        end
                    end
                    if dispelled then return true end
                end
            end
            -- Utility Ability
            if ui.checked("Use Utility Ability") then
                -- Updraft
                if cast.able.updraft() and not buff.updraft.exists() and getFallTime() > 2 then
                    if cast.updraft() then ui.debug("[Pet] Cast Updraft") return true end
                end
                -- Surface Trot
                if cast.able.surfaceTrot() and not buff.surfaceTrot.exists() and unit.swimming() then
                    if cast.surfaceTrot() then ui.debug("[Pet] Cast Surface Trot") return true end
                end
            end
            -- Auto Growl
            if ui.checked("Auto Growl") and unit.inCombat() then
                local _, autoCastEnabled = GetSpellAutocast(spell.growl)
                if autoCastEnabled then DisableSpellAutocast(spell.growl) end
                if not isTankInRange() and not buff.prowl.exists("pet") then
                    if ui.value("Misdirection") == 3 and cast.able.misdirection("pet") and #enemies.yards8p > 1 then
                        if cast.misdirection("pet") then ui.debug("[Pet] Cast Misdirection on Pet") return true end
                    end
                    if cast.able.growl() then
                        for i = 1, #enemies.yards30p do
                            local thisUnit = enemies.yards30p[i]
                            if isTanking(thisUnit) and unit.distance(thisUnit,"pet") < 30 then
                                if cast.growl(thisUnit,"pet") then ui.debug("[Pet] Cast Growl") return true end
                            end
                        end
                    end
                end
            end
            -- Dash
            if ui.checked("Dash") and cast.able.dash("player") and validTarget and petDistance > 10 and petDistance < 40 and not pause() then
                if cast.dash("player") then ui.debug("[Pet] Cast Dash") return true end
            end
            -- Fetch
            if ui.checked("Fetch") and not unit.inCombat() and not unit.inCombat("pet") and cast.able.fetch() and petExists and not br.deadPet then
                if fetching and (fetchCount ~= getLootableCount() or getLootableCount() == 0) then fetching = false end
                for k, _ in pairs(br.lootable) do
                    if br.lootable[k] ~= nil then
                        local thisDistance = unit.distance(k)
                        if thisDistance > 8 and thisDistance < 40 and not fetching then
                            cast.fetch("pet")
                            fetchCount = getLootableCount()
                            fetching = true
                            break
                        end
                    end
                end
            end
            -- Mend Pet
            if ui.checked("Mend Pet") and cast.able.mendPet() and petExists and not br.deadPet
                and not buff.mendPet.exists("pet") and petHealth < ui.value("Mend Pet")
            then
                if cast.mendPet("pet") then ui.debug("[Pet] Cast Mend Pet") return true end
            end
            -- Play Dead / Wake Up
            if ui.checked("Play Dead / Wake Up") and not br.deadPet then
                if cast.able.playDead() and unit.inCombat("pet") and not buff.playDead.exists("pet")
                    and petHealth < ui.value("Play Dead / Wake Up")
                then
                    if cast.playDead("player") then ui.debug("[Pet] Cast Play Dead") return true end
                end
                if cast.able.wakeUp() and buff.playDead.exists("pet") and not buff.feignDeath.exists()
                    and petHealth >= ui.value("Play Dead / Wake Up")
                then
                    if cast.wakeUp("player") then ui.debug("[Pet] Cast Wake Up") return true end
                end
            end
            -- Stealth
            if ui.checked("Stealth") and not unit.inCombat("pet") and not unit.inCombat("player") and (not IsResting() or unit.isDummy())
                and #enemies.yards40nc > 0 and not fetching and not pause()
            then
                if cast.able.spiritWalk() and not buff.spiritWalk.exists("pet") and not cd.spiritWalk.exists() then
                    if cast.spiritWalk("player") then ui.debug("[Pet] Cast Spirit Walk") return true end
                end
                if cast.able.prowl("player") and not buff.prowl.exists("pet") and not cd.prowl.exists() and cast.timeSinceLast.prowl() > unit.gcd(true) then
                    if cast.prowl("player") then ui.debug("[Pet] Cast Prowl") return true end
                end
            end
        end
    end -- End Action List - Pet Management
}
