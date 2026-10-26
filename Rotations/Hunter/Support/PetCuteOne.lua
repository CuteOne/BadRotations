-- Action List - Pet Management
-- BR API Locals
-- Editor types: the keys of Retail Hunter BeastMastery_Marksmanship's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.buff]]
local cast = cast --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.cast]]
local cd = cd --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.cd]]
local charges = charges --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.charges]]
local debuff = debuff --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.debuff]]
local equiped = equiped --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.equiped]]
local glyph = glyph --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.glyph]]
local has = has --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.has]]
local heroTree = heroTree --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.heroTree]]
local imbues = imbues --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.imbues]]
local spell = spell --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.spell]]
local talent = talent --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.talent]]
local totem = totem --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.totem]]
local use = use --[[@as BR.Retail.Hunter.BeastMastery_Marksmanship.use]]

local mode
local currentTarget
local fetching = false
local lootCount
local petAppearTimer = 0
local petCalled = false
local petDead = false
local petRevived = false
local targetSwitchTimer = 0
-- The pet's modes as this file names them
local PET_MODES = { assist = "Assist", defensiveAssist = "Defensive", passive = "Passive" }

return {
    options = function()
        local alwaysCdAoENever = { "Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never" }
        -- Pet Options
        local section = ui.section("Pet")
        -- Pet Target
        ui.dropdown(section, "Pet Target", { choices = { "Dynamic Unit", "Only Target", "Any Unit", "Assist" }, value = "Dynamic Unit", checkbox = false,
            tip = "Select how you want pet to acquire targets." })
        -- Auto Attack/Passive
        ui.checkbox(section, "Auto Attack/Passive")
        -- Spec Ability
        ui.checkbox(section, "Master's Call - Cunning", { tip = "Select to use. - Cunning Pets Only" })
        --br.ui:createDropdownWithout(section,"Primal Rage - Ferocity", alwaysCdAoENever, 1, "|cffFFFFFFSelect when to use - Ferocity Pets Only")
        ui.spinner(section, "Survival of the Fittest - Tenacity", { value = 20, tip = "Health Percent to Cast - Tenacity Pets Only" })
        -- Attack Ability
        ui.checkbox(section, "Use Attack Ability", { tip = "Pet will use Bite/Claw/Smack" })
        -- Defense Ability
        ui.spinner(section, "Use Defense Ability", { value = 30, tip = "Health Percent to Cast it's Defense/Dodge Ability" })
        -- Debuff Ability
        ui.checkbox(section, "Use Debuff Ability", { tip = "Pet will use ability that debuffs the target with Mortal Wounds, if available." })
        -- Heal Ability
        ui.spinner(section, "Use Heal Ability", { value = 30, tip = "Health Percent to Cast it's Heal Ability **Not all have heals**" })
        -- Purge Ability
        ui.dropdown(section, "Use Purge Ability", { choices = { "Every Unit", "Only Target" }, value = "Only Target",
            tip = "Select if you want Purge only Target or every Unit arround the Pet" })
        -- Utility Ability
        ui.checkbox(section, "Use Utility Ability", { tip = "Pet will use Slow Fall / Water Walking, if available." })
        -- Auto Growl
        ui.checkbox(section, "Auto Growl", { tip = "Pet will growl any valid enemy it does not have threat on, disables if tank nearby." })
        -- Dash
        ui.checkbox(section, "Dash")
        -- Fetch
        ui.checkbox(section, "Fetch", { tip = "Pet will fetch loot, if available." })
        -- Mend Pet
        ui.spinner(section, "Mend Pet", { value = 50, tip = "Health Percent to Cast At" })
        -- Play Dead / Wake Up
        ui.spinner(section, "Play Dead / Wake Up", { value = 25, tip = "Health Percent to Cast At, if available." })
        -- Stealth
        ui.checkbox(section, "Stealth", { tip = "Pet will use Prowl or Spirit Walk, if available." })
    end,
    run = function()

        ---------------------
        --- Define Locals ---
        ---------------------
        -- BR API Locals
        mode               = ui.mode
        -- General Locals
        var.haltPetProfile = unit.casting("pet") or unit.inVehicle() or unit.taxi() or unit.mounted() or unit.flying()
            or ui.pauseKey() or buff.feignDeath.exists() or buff.playDead.exists("pet") or
            (mode.rotation == 4 or (mode.rotation == 2 and unit.spec() == "Initial"))
        -- Pet Specific Locals
        local callPet      = mode.petSummon < 6 and ("callPet" .. mode.petSummon) or nil
        local callPetName  = callPet and pet.callName(callPet) or ""
        local friendUnit   = units.friends[1].unit
        local petActive    = pet.active.exists()
        local petDistance  = unit.distance(var.petTarget, "pet") or 99
        local petExists    = unit.exists("pet")
        local petHealth    = unit.hp("pet")
        local petMode      = PET_MODES[pet.mode()] or "None"
        local validTarget  = unit.exists(var.petTarget) and
            (unit.valid(var.petTarget) or unit.isDummy()) --or (not unit.exists(var.petTarget) and unit.valid("target")) or unit.isDummy()

        if unit.deadOrGhost("pet") then petDead = true end

        -- Units
        units.get(5)
        units.get(40)
        -- Enemies
        enemies.get(5)
        enemies.get(5, "pet")
        enemies.get(8, "target")
        enemies.get(8, "pet")
        enemies.get(20, "pet")
        enemies.get(20, "pet", true)
        enemies.get(30)
        enemies.get(30, "pet")
        enemies.get(40)
        enemies.get(40, "pet", true)
        enemies.get(40, "player", false, true)
        enemies.get(40, "pet")
        enemies.yards40r = enemies.rect.get(10, 40, false)

        -- Loot Count
        lootCount = units.lootCount()

        -- Pet Target Modes
        if var.petTarget == nil then var.petTarget = "target" end
        if var.petTarget ~= "target" and (not unit.exists(var.petTarget) or unit.deadOrGhost(var.petTarget) or (unit.exists("pettarget") and not unit.isUnit("pettarget", var.petTarget))) then
            var.petTarget = "target"
        end
        if --[[var.petTarget == "player" or]] (unit.exists("pettarget") and not unit.isUnit("pettarget", var.petTarget) and not unit.deadOrGhost(var.petTarget)) then
            -- Dynamic
            if ui.value("Pet Target") == 1 and units.dyn40 ~= nil
                and (var.petTarget == "target" or (unit.exists("pettarget") and not unit.isUnit(units.dyn40, var.petTarget)))
            then
                var.petTarget = units.dyn40
                -- if unit.exists(var.petTarget) then ui.debug("[Pet - Target Mode Dynamic] Pet is now targeting - "..unit.name(var.petTarget)) end
            end
            -- Target
            if ui.value("Pet Target") == 2 and unit.valid("target")
                and (var.petTarget == "target" or (unit.exists("pettarget") and not unit.isUnit("target", var.petTarget)))
            then
                var.petTarget = "target"
                -- if unit.exists(var.petTarget) then ui.debug("[Pet - Target Mode Only Target] Pet is now targeting - "..unit.name(var.petTarget)) end
            end
            -- Any
            if ui.value("Pet Target") == 3 and enemies.yards40[1] ~= nil
                and (var.petTarget == "target" or (unit.exists("pettarget") and not unit.isUnit(enemies.yards40[1], var.petTarget)))
            then
                var.petTarget = enemies.yards40[1]
                -- if unit.exists(var.petTarget) then ui.debug("[Pet - Target Mode Any Unit] Pet is now targeting - "..unit.name(var.petTarget)) end
            end
            -- Assist
            if ui.value("Pet Target") == 4 and (var.petTarget == "target" or (unit.exists("pettarget") and not unit.isUnit("pettarget", var.petTarget))) then
                var.petTarget = "pettarget"
                -- if unit.exists(var.petTarget) then ui.debug("[Pet - Target Mode Assist] Pet is now targeting - "..unit.name(var.petTarget)) end
            end
        end

        -- Pet Summoning (Call, Dismiss, Revive)
        if not var.haltPetProfile and not ui.pause() and not unit.falling() then
            if petAppearTimer < util.time() - 2 then
                -- Check for Pet
                -- if (petCalled or petRevived) and petExists and petActive then petCalled = false; petRevived = false end
                if petCalled and petExists and petActive then petCalled = false else petDead = true end
                if petRevived and petExists and petActive then
                    petRevived = false
                    petDead = false
                end
                -- Dismiss Pet
                if cast.able.dismissPet("player") and petExists and petActive and (callPet == nil or unit.name("pet") ~= callPetName) then
                    if cast.dismissPet("player") then
                        ui.debug("[Pet] Casting Dismiss Pet")
                        petAppearTimer = util.time(); return true
                    end
                end
                if mode.petSummon < 6 and callPetName ~= "" then
                    -- Call Pet
                    if (not petExists or not petActive) and not buff.playDead.exists("pet") and not petCalled then
                        if cast["callPet" .. mode.petSummon]("player") then
                            ui.debug("[Pet] Casting Call Pet") --[[ui.print("Hey "..callPetName.."...WAKE THE FUCK UP! It's already past noon!...GET YOUR LIFE TOGETHER!")]]
                            petAppearTimer = util.time(); petCalled = true; petRevived = false; return true
                        end
                    end
                    if (not petExists or not petActive or unit.hp("pet") == 0) and petDead then
                        if cast.able.revivePet("player") and cast.timeSinceLast.revivePet() > unit.gcd(true) then
                            if cast.revivePet("player") then
                                ui.debug("[Pet] Casting Revive Pet") --[[ui.print("Hey "..callPetName.."...WAKE THE FUCK UP! It's already past noon!...GET YOUR LIFE TOGETHER!")]]
                                petAppearTimer = util.time(); petRevived = true; petCalled = false; return true
                            end
                        end
                    end
                    -- -- Call Pet
                    -- if ((not pet.dead() and not petExists) or not petActive) and not buff.playDead.exists("pet") and not petCalled then
                    --     if cast["callPet"..mode.petSummon]("player") then ui.debug("[Pet] Casting Call Pet") --[[ui.print("Hey "..callPetName.."...WAKE THE FUCK UP! It's already past noon!...GET YOUR LIFE TOGETHER!")]] petAppearTimer = util.time(); petCalled = true; petRevived = false; return true end
                    -- end
                    -- -- Revive Pet
                    -- if pet.dead() or (petExists and petHealth == 0) or petCalled == true then
                    --     if cast.able.revivePet("player") and cast.timeSinceLast.revivePet() > unit.gcd(true) then
                    --         if cast.revivePet("player") then ui.debug("[Pet] Casting Revive Pet") --[[ui.print("Hey "..callPetName.."...WAKE THE FUCK UP! It's already past noon!...GET YOUR LIFE TOGETHER!")]] petAppearTimer = util.time(); petRevived = true; petCalled = false; return true end
                    --     end
                    -- end
                end
            end
        end

        -- Pet Combat Modes
        if ui.checked("Auto Attack/Passive") and petActive and petExists and not cast.last.dismissPet() and targetSwitchTimer < util.time() - 1 then
            -- Set Pet Modes
            if ui.value("Pet Target") == 4 and unit.inCombat() and (petMode == "Defensive" or petMode == "Passive") and not var.haltPetProfile and petMode ~= "Assist" then
                ui.debug("[Pet] Pet is now Assisting")
                pet.setMode("assist")
            elseif (not unit.inCombat() or unit.valid(var.petTarget) or (unit.inCombat() and ui.value("Pet Target") ~= 4))
                and (#enemies.yards20pnc > 0 or unit.valid(var.petTarget)) and not var.haltPetProfile and petMode ~= "Defensive"
                and (petMode ~= "Assist" or not unit.inCombat("player"))
            then
                ui.debug("[Pet] Pet is now Defending")
                pet.setMode("defensiveAssist")
            elseif petMode ~= "Passive" and ((not unit.inCombat() and #enemies.yards20pnc == 0 and not unit.valid(var.petTarget)) or var.haltPetProfile)
                and (not spell.fetch.known() or lootCount == 0)
            then
                ui.debug("[Pet] Pet is now Passive")
                pet.setMode("passive")
            end
            -- Pet Attack / Retreat
            -- if var.petTarget == nil and unit.valid("target") then var.petTarget = "target" end
            if (var.petTarget ~= "target" or unit.valid(var.petTarget)) and not buff.playDead.exists("pet") and not var.haltPetProfile
                and ((not unit.exists("pettarget") and not unit.isUnit(currentTarget, var.petTarget)) or (unit.exists("pettarget") and not unit.isUnit("pettarget", var.petTarget)))
                and ((not unit.inCombat() and not unit.inCombat("pet")) or (unit.casting("player") and unit.valid(var.petTarget) and unit.isUnit(var.petTarget, currentTarget))
                    or ((unit.inCombat() or unit.inCombat("pet") or (unit.valid("target") and unit.casting("player"))) and (currentTarget == nil or not unit.isUnit(var.petTarget, currentTarget))))
                and unit.distance("target") < 40 and not unit.friend("target")
            then
                ui.debug("[Pet] Pet is now attacking " .. tostring(unit.name(var.petTarget)))
                pet.attack(var.petTarget)
                currentTarget = var.petTarget
            elseif unit.exists("pettarget") and pet.attacking()
                and ((not unit.inCombat() and not unit.valid("target")) or (unit.inCombat() and not unit.valid(var.petTarget)) or var.haltPetProfile)
            then
                ui.debug("[Pet] Pet stopped attacking!")
                pet.stopAttack()
                if petMode == "Passive" then
                    pet.setMode("defensiveAssist")
                end
                pet.setMode("passive")
                if (#enemies.yards40 == 0 and #enemies.yards40p == 0) or var.haltPetProfile then
                    ui.debug("[Pet] Pet is now following, Enemies40: " ..
                        #enemies.yards40 .. ", var.haltPetProfile : " .. tostring(var.haltPetProfile))
                    pet.follow()
                end
            end
            targetSwitchTimer = util.time()
        end

        -- Manage Pet Abilities
        -- Spec Abilities
        if unit.inCombat("pet") and not buff.playDead.exists("pet") and not var.haltPetProfile then
            if ui.checked("Master's Call - Cunning") and cast.noControl.mastersCall() then
                if cast.mastersCall() then
                    ui.debug("[Pet] Cast Master's Call")
                    return true
                end
            end
            if ui.alwaysCdAoENever("Primal Rage - Ferocity") then
                if cast.primalRage() then
                    ui.debug("[Pet] Cast Primal Rage")
                    return true
                end
            end
            if ui.checked("Survival of the Fittest - Tenacity") and unit.hp("pet") < ui.value("Survival of the Fittest - Tenacity") then
                if cast.survivalOfTheFittest() then
                    ui.debug("[Pet] Cast Survival of the Fittest")
                    return true
                end
            end
        end
        -- Attack Abilities
        if ui.checked("Use Attack Ability") and not var.haltPetProfile and unit.inCombat("pet") and validTarget and petDistance < 5
            and not unit.totem(var.petTarget) and not buff.playDead.exists("pet")
        then
            -- Bite
            if cast.able.bite(var.petTarget, "pet") then
                if cast.bite(var.petTarget, "pet") then
                    ui.debug("[Pet] Cast Bite")
                    return true
                end
            end
            -- Claw
            if cast.able.claw(var.petTarget, "pet") then
                if cast.claw(var.petTarget, "pet") then
                    ui.debug("[Pet] Cast Claw")
                    return true
                end
            end
            -- Smack
            if cast.able.smack(var.petTarget, "pet") then
                if cast.smack(var.petTarget, "pet") then
                    ui.debug("[Pet] Cast Smack")
                    return true
                end
            end
            -- Burrow Attack
            if cast.able.burrowAttack() and #enemies.yards8p > 2 then
                if cast.burrowAttack() then
                    ui.debug("[Pet] Cast Burrow Attack")
                    return true
                end
            end
            -- Froststorm Breath
            if cast.able.froststormBreath() and #enemies.yards8p > 2 then
                if cast.froststormBreath() then
                    ui.debug("[Pet] Cast Froststorm Breath")
                    return true
                end
            end
        end
        -- Defense Abilities
        if ui.checked("Use Defense Ability") and unit.inCombat("pet") and unit.hp("pet") < ui.value("Use Defense Ability") and not buff.playDead.exists("pet") then
            -- Agile Reflexes
            if cast.able.agileReflexes() then
                if cast.agileReflexes() then
                    ui.debug("[Pet] Cast Agile Reflexes")
                    return true
                end
            end
            -- Bristle
            if cast.able.bristle() then
                if cast.bristle() then
                    ui.debug("[Pet] Cast Bristle")
                    return true
                end
            end
            -- Bulwark
            if cast.able.bulwark() then
                if cast.bulwark() then
                    ui.debug("[Pet] Cast Bulwark")
                    return true
                end
            end
            -- Cat-like Reflexes
            if cast.able.catlikeReflexes() then
                if cast.catlikeReflexes() then
                    ui.debug("[Pet] Cast Cat-like Reflexes")
                    return true
                end
            end
            -- Defense Matrix
            if cast.able.defenseMatrix() then
                if cast.defenseMatrix() then
                    ui.debug("[Pet] Cast Defense Matrix")
                    return true
                end
            end
            -- Dragon'checkSectionState Guile
            if cast.able.dragonsGuile() then
                if cast.dragonsGuile() then
                    ui.debug("[Pet] Cast Dragon's Guile")
                    return true
                end
            end
            -- Feather Flurry
            if cast.able.featherFlurry() then
                if cast.featherFlurry() then
                    ui.debug("[Pet] Cast Feather Flurry")
                    return true
                end
            end
            -- Fleethoof
            if cast.able.fleethoof() then
                if cast.fleethoof() then
                    ui.debug("[Pet] Cast Fleethood")
                    return true
                end
            end
            -- Harden Carapace
            if cast.able.hardenCarapace() then
                if cast.hardenCarapace() then
                    ui.debug("[Pet] Cast Harden Carapace")
                    return true
                end
            end
            -- Obsidian Skin
            if cast.able.obsidianSkin() then
                if cast.obsidianSkin() then
                    ui.debug("[Pet] Cast Obsidian Skin")
                    return true
                end
            end
            -- Primal Agility
            if cast.able.primalAgility() then
                if cast.primalAgility() then
                    ui.debug("[Pet] Cast Primal Agility")
                    return true
                end
            end
            -- Scale Shield
            if cast.able.scaleShield() then
                if cast.scaleShield() then
                    ui.debug("[Pet] Cast Scale Shield")
                    return true
                end
            end
            -- Serpent Swiftness
            if cast.able.serpentSwiftness() then
                if cast.serpentSwiftness() then
                    ui.debug("[Pet] Cast Serpent Swiftness")
                    return true
                end
            end
            -- Shell Shield
            if cast.able.shellShield() then
                if cast.shellShield() then
                    ui.debug("[Pet] Cast Shell Shield")
                    return true
                end
            end
            -- Solid Shell
            if cast.able.solidShell() then
                if cast.solidShell() then
                    ui.debug("[Pet] Cast Solid Shell")
                    return true
                end
            end
            -- Swarm Of Flies
            if cast.able.swarmOfFlies() then
                if cast.swarmOfFlies() then
                    ui.debug("[Pet] Cast Swarm of Flies")
                    return true
                end
            end
            -- Winged Agility
            if cast.able.wingedAgility() then
                if cast.wingedAgility() then
                    ui.debug("[Pet] Cast Winged Agility")
                    return true
                end
            end
        end
        -- Debuff Abilities
        if ui.checked("Use Debuff Ability") and not var.haltPetProfile and unit.inCombat("pet") and not buff.playDead.exists("pet")
            and validTarget and petDistance < 5 and not unit.totem(var.petTarget) and debuff.mortalWounds.refresh(var.petTarget)
        then
            -- Acid Bite
            if cast.able.acidBite(var.petTarget) then
                if cast.acidBite(var.petTarget) then
                    ui.debug("[Pet] Cast Acid Bite")
                    return true
                end
            end
            -- Bloody Screech
            if cast.able.bloodyScreech(var.petTarget) then
                if cast.bloodyScreech(var.petTarget) then
                    ui.debug("[Pet] Cast Bloody Screech")
                    return true
                end
            end
            -- Deadly Sting
            if cast.able.deadlySting(var.petTarget) then
                if cast.deadlySting(var.petTarget) then
                    ui.debug("[Pet] Cast Deadly Sting")
                    return true
                end
            end
            -- Gnaw
            if cast.able.gnaw(var.petTarget) then
                if cast.gnaw(var.petTarget) then
                    ui.debug("[Pet] Cast Gnaw")
                    return true
                end
            end
            -- Gore
            if cast.able.gore(var.petTarget) then
                if cast.gore(var.petTarget) then
                    ui.debug("[Pet] Cast Gore")
                    return true
                end
            end
            -- Grievous Bite
            if cast.able.grievousBite(var.petTarget) then
                if cast.grievousBite(var.petTarget) then
                    ui.debug("[Pet] Cast Grievous Bite")
                    return true
                end
            end
            -- Gruesome Bite
            if cast.able.gruesomeBite(var.petTarget) then
                if cast.gruesomeBite(var.petTarget) then
                    ui.debug("[Pet] Cast Gruesome Bite")
                    return true
                end
            end
            -- Infected Bite
            if cast.able.infectedBite(var.petTarget) then
                if cast.infectedBite(var.petTarget) then
                    ui.debug("[Pet] Cast Infected Bite")
                    return true
                end
            end
            -- Monsterous Bite
            if cast.able.monsterousBite(var.petTarget) then
                if cast.monsterousBite(var.petTarget) then
                    ui.debug("[Pet] Cast Monsterous Bite")
                    return true
                end
            end
            -- Ravage
            if cast.able.ravage(var.petTarget) then
                if cast.ravage(var.petTarget) then
                    ui.debug("[Pet] Cast Ravage")
                    return true
                end
            end
            -- Savage Rend
            if cast.able.savageRend(var.petTarget) then
                if cast.savageRend(var.petTarget) then
                    ui.debug("[Pet] Cast Savage Rend")
                    return true
                end
            end
            -- Toxic Sting
            if cast.able.toxicSting(var.petTarget) then
                if cast.toxicSting(var.petTarget) then
                    ui.debug("[Pet] Cast Toxic Sting")
                    return true
                end
            end
        end
        -- Heal Abilities
        if ui.checked("Use Heal Ability") and not buff.playDead.exists("pet") then
            -- Eternal Guardian
            if cast.able.eternalGuardian() and (pet.dead() or (petExists and petHealth == 0)) then
                if cast.eternalGuardian() then
                    ui.debug("[Pet] Cast Eternal Guardian")
                    return true
                end
            end
            -- Feast
            if unit.hp("pet") < ui.value("Use Heal Ability") then
                if cast.able.feast("target") and (unit.deadOrGhost("target") and (unit.beast("target") or unit.humanoid("target"))) then
                    if cast.feast("target") then
                        ui.debug("[Pet] Cast Feast on dead target.")
                        return true
                    end
                end
                if cast.able.feast("mosueover") and (unit.deadOrGhost("mouseover") and (unit.beast("mouseover") or unit.humanoid("mouseover"))) then
                    if cast.feast("mouseover") then
                        ui.debug("[Pet] Cast Feast on dead mouseover.")
                        return true
                    end
                end
            end
            -- Spirit Mend
            if cast.able.spiritmend(friendUnit) and unit.inCombat("pet") and unit.hp(friendUnit) <= ui.value("Use Heal Ability") then
                if cast.spiritmend(friendUnit) then
                    ui.debug("[Pet] Cast Spirit Mend on lowest HP Unit")
                    return true
                end
            end
        end
        -- Purge Ability
        if ui.checked("Use Purge Ability") and unit.inCombat() and not buff.playDead.exists("pet") then
            if #enemies.yards5p > 0 then
                local dispelled = false
                for i = 1, #enemies.yards5p do
                    local thisUnit = enemies.yards5p[i]
                    if ui.value("Use Purge Ability") == 1 or (ui.value("Use Purge Ability") == 2 and unit.isUnit(thisUnit, "target")) then
                        if unit.valid(thisUnit) and cast.dispel.spiritPulse(thisUnit) then --br.functions.aura:canDispel(thisUnit,spells.spiritPulse) then
                            if cast.able.spiritPulse(thisUnit, "pet") then
                                if cast.spiritPulse(thisUnit, "pet") then
                                    ui.debug("[Pet] Cast Spirit Pulse")
                                    dispelled = true; break
                                end
                            elseif cast.able.chiJiTranq(thisUnit, "pet") then
                                if cast.chiJiTranq(thisUnit, "pet") then
                                    ui.debug("[Pet] Cast Chi-Ji Tranquility")
                                    dispelled = true; break
                                end
                            elseif cast.able.naturesGrace(thisUnit, "pet") then
                                if cast.naturesGrace(thisUnit, "pet") then
                                    ui.debug("[Pet] Cast Nature's Grace")
                                    dispelled = true; break
                                end
                            elseif cast.able.netherEnergy(thisUnit, "pet") then
                                if cast.netherEnergy(thisUnit, "pet") then
                                    ui.debug("[Pet] Cast Nether Energy")
                                    dispelled = true; break
                                end
                            elseif cast.able.sonicScreech(thisUnit, "pet") then
                                if cast.sonicScreech(thisUnit, "pet") then
                                    ui.debug("[Pet] Cast Sonic Screech")
                                    dispelled = true; break
                                end
                            elseif cast.able.soothingWater(thisUnit, "pet") then
                                if cast.soothingWater(thisUnit, "pet") then
                                    ui.debug("[Pet] Cast Soothing Water")
                                    dispelled = true; break
                                end
                            elseif cast.able.sporeCloud(thisUnit, "pet") then
                                if cast.sporeCloud(thisUnit, "pet") then
                                    ui.debug("[Pet] Cast Spore Cloud")
                                    dispelled = true; break
                                end
                            end
                        end
                    end
                end
                if dispelled then return true end
            end
        end
        -- Utility Ability
        if ui.checked("Use Utility Ability") and not buff.playDead.exists("pet") then
            -- Updraft
            if cast.able.updraft() and not buff.updraft.exists() and unit.fallTime() > 2 then
                if cast.updraft() then
                    ui.debug("[Pet] Cast Updraft")
                    return true
                end
            end
            -- Surface Trot
            if cast.able.surfaceTrot() and not buff.surfaceTrot.exists() and unit.swimming() then
                if cast.surfaceTrot() then
                    ui.debug("[Pet] Cast Surface Trot")
                    return true
                end
            end
        end
        -- Auto Growl
        if ui.checked("Auto Growl") and unit.inCombat() and cast.timeSinceLast.growl() > unit.gcd(true) and not buff.playDead.exists("pet") then
            pet.setAutocast("growl", false)
            if not unit.isTankInRange() and not buff.prowl.exists("pet") then
                if ui.value("Misdirection") == 3 and cast.able.misdirection("pet") and #enemies.yards8p > 1 then
                    if cast.misdirection("pet") then
                        ui.debug("[Pet] Cast Misdirection on Pet")
                        return true
                    end
                end
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if not var.haltPetProfile and cast.able.growl(thisUnit, "pet") and cd.growl.remains() == 0 and unit.isTanking(thisUnit) and unit.distance(thisUnit) < 30 then
                        if cast.growl(thisUnit, "pet") then
                            ui.debug("[Pet] Cast Growl")
                            return true
                        end
                    end
                end
            end
        end
        -- Dash
        if ui.checked("Dash") and cast.able.dash("player") and unit.inCombat("pet") and unit.moving("pet") and validTarget and petDistance > 10 and petDistance < 40
            and not ui.pause() and cast.timeSinceLast.dash() > unit.gcd(true) and not buff.playDead.exists("pet")
        then
            if cast.dash("player") then
                ui.debug("[Pet] Cast Dash")
                return true
            end
        end
        -- Fetch
        if ui.checked("Fetch") and not unit.inCombat() and not unit.inCombat("pet") and cast.able.fetch("pet") and not cast.current.fetch("pet")
            and petExists and not pet.dead() and cast.timeSinceLast.fetch() > unit.gcd(true) * 2 and not buff.playDead.exists("pet")
        then
            if fetching and (lootCount == 0) then fetching = false end
            if not fetching then
                for _, v in pairs(units.lootable()) do
                    local thisDistance = unit.distance(v.unit)
                    if thisDistance > 8 and thisDistance < 40 then
                        if cast.fetch("pet") then
                            fetching = true
                            ui.debug("[Pet] Cast Fetch")
                            break
                        end
                    end
                end
            end
        end
        -- Mend Pet
        if ui.checked("Mend Pet") and cast.able.mendPet("pet") and petExists and not pet.dead()
            and not buff.mendPet.exists("pet") and petHealth < ui.value("Mend Pet")
        then
            if cast.mendPet("pet") then
                ui.debug("[Pet] Cast Mend Pet")
                return true
            end
        end
        -- Play Dead / Wake Up
        if ui.checked("Play Dead / Wake Up") and not pet.dead() then
            if cast.able.playDead("player") and unit.inCombat("pet") and not buff.playDead.exists("pet")
                and petHealth < ui.value("Play Dead / Wake Up")
            then
                if cast.playDead("player") then
                    ui.debug("[Pet] Cast Play Dead")
                    return true
                end
            end
            if ui.checked("Play Dead / Wake Up") and not pet.dead() then
                var.woke = ui.value("Play Dead / Wake Up") > 50 and 100 or 50
                if cast.able.wakeUp("player") and buff.playDead.exists("pet") and not buff.feignDeath.exists()
                    and petHealth >= var.woke
                then
                    if cast.wakeUp("player") then
                        ui.debug("[Pet] Cast Wake Up")
                        return true
                    end
                end
            end
        end
        -- Stealth
        if ui.checked("Stealth") and not unit.inCombat("pet") and not unit.inCombat("player") and (not unit.resting() or unit.isDummy())
            and #enemies.yards20pnc > 0 and not fetching and not ui.pause() and not buff.playDead.exists("pet")
        then
            if cast.able.spiritWalk("player") and not buff.spiritWalk.exists("pet") and not cd.spiritWalk.exists() then
                if cast.spiritWalk("player") then
                    ui.debug("[Pet] Cast Spirit Walk")
                    return true
                end
            end
            if cast.able.prowl("player") and not buff.prowl.exists("pet") and not cd.prowl.exists() and cast.timeSinceLast.prowl() > unit.gcd(true) * 2 then
                if cast.prowl("player") then
                    ui.debug("[Pet] Cast Prowl")
                    return true
                end
            end
        end
    end -- End Action List - Pet Management
}
