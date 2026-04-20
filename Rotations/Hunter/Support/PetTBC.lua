-------------------------------------------------------
-- Author = CuteOne
-- Patch = 2.5.1
-- Coverage = 95%
-- Status = Full
-- Readiness = Raid
-------------------------------------------------------
-- TBC-specific Hunter pet management support module.
-- Covers the TBC pet system: single pet slot, no pet talent specs,
-- TBC-era abilities and all pet family special abilities.
-- Does NOT replace PetCuteOne (Retail).
-- Loaded via: br.loader.cBuilder:loadSupport("Pet")
-------------------------------------------------------

-- BR API Locals
local buff
local cast
local cd
local debuff
local enemies
local mode
local pet
local spell
local spells
local ui
local unit
local units
local var

-- Module state
local petAppearTimer        = br._G.GetTime()
local petCalled             = false
local petRevived            = false
local petDead               = false
local lastPetMode           = nil    -- Track applied pet stance; avoids redundant WoW API calls
local targetSwitchTimer     = br._G.GetTime()
local currentTarget         = nil
local happinessWarnTimer    = 0      -- Rate-limit unhappy pet warning to once per 30 seconds

local growlAutoCastDisabled = false  -- Disable Growl auto-cast once per session
local PET_CALL_TIMEOUT      = 10     -- Seconds to wait for a called pet before retrying (not reviving)

br.loader.rotations.support["PetTBC"] = {
    options = function()
        local section = br.ui:createSection(br.ui.window.profile, "Pet")

        -- Pet Mode: controls the WoW pet stance applied once on change
        br.ui:createDropdownWithout(section, "Pet Mode", { "Aggressive", "Defensive", "Passive" }, 1,
            "|cffFFFFFFAggressive: pet attacks nearby enemies. Defensive: responds to attacks on you/pet. Passive: player-directed only.")

        -- Summoning
        br.ui:createCheckbox(section, "Summon Pet",
            "|cffFFFFFFCall and maintain your active pet. Revives or re-calls if dead or missing.")

        -- Healing
        br.ui:createSpinner(section, "Mend Pet", 60, 0, 100, 5,
            "|cffFFFFFFHealth % below which Mend Pet is cast.")

        -- ── Family Special Abilities ──────────────────────────────────────────

        -- Furious Howl (Wolf) — short-CD party +physical damage buff; highest DPS priority
        br.ui:createCheckbox(section, "Furious Howl",
            "|cffFFFFFFWolf only. Buffs the physical damage of the next attack for all nearby party members. Use on cooldown.")

        -- Screech (Bat / Owl / Carrion Bird) — AoE attack-speed debuff on 2+ targets near pet
        br.ui:createCheckbox(section, "Screech",
            "|cffFFFFFFBat/Owl/Carrion Bird only. AoE melee attack-power debuff. Fires when 2+ enemies are within 8 yards of the pet.")

        -- Thunderstomp (Gorilla) — AoE threat builder on 2+ targets near pet
        br.ui:createCheckbox(section, "Thunderstomp",
            "|cffFFFFFFGorilla only. AoE Nature damage + threat builder. Fires when 2+ enemies are within 8 yards of the pet.")

        -- Fire Breath (Dragonhawk) — ranged fire damage on CD
        br.ui:createCheckbox(section, "Fire Breath",
            "|cffFFFFFFDragonhawk only. Ranged fire damage ability used on cooldown.")

        -- Shell Shield (Turtle) — large defensive CD triggered at pet health threshold
        br.ui:createCheckbox(section, "Shell Shield",
            "|cffFFFFFFTurtle only. Reduces pet damage taken by 50%. Activates below the configured health %.")
        br.ui:createSpinner(section, "Shell Shield HP", 40, 0, 100, 5,
            "|cffFFFFFFPet health % at which Shell Shield is activated.")

        -- Charge (Boar only) — gap-closing charge when pet is out of melee
        br.ui:createCheckbox(section, "Charge",
            "|cffFFFFFFBoar only (Crab has no abilities in TBC). Gap-closing charge + immobilize when the pet is more than 10 yards from its target.")

        -- Gore (Boar / Ravager) — stacking bleed on CD
        br.ui:createCheckbox(section, "Gore",
            "|cffFFFFFFBoar/Ravager only. Stacking bleed attack used on cooldown.")

        -- Scorpid Poison (Scorpid) — stacking AP-reducing poison on CD
        br.ui:createCheckbox(section, "Scorpid Poison",
            "|cffFFFFFFScorpid only. Stacking poison that reduces the target's attack power. Used on cooldown.")

        -- ── Core Abilities ────────────────────────────────────────────────────

        -- Lightning Breath — higher DPE than basic attacks; fires before Bite/Claw
        br.ui:createCheckbox(section, "Lightning Breath",
            "|cffFFFFFFWind Serpent only. Ranged nature attack. Prioritised over Bite/Claw due to higher damage-per-energy.")

        -- Pet Attack Ability — Bite / Claw basic energy dump
        br.ui:createCheckbox(section, "Pet Attack Ability",
            "|cffFFFFFFPet uses Bite or Claw as its primary melee energy-dump attack.")

        -- Auto Growl — manual per-target threat management
        br.ui:createCheckbox(section, "Auto Growl",
            "|cffFFFFFFPet taunts enemies it does not hold threat on. Automatically suppressed when a tank is in range.")

        -- Dash — gap closer when pet is chasing its target
        br.ui:createCheckbox(section, "Dash",
            "|cffFFFFFFUse Dash when the pet is moving and farther than 15 yards from its target.")

        -- Dive (Bat / Owl / Carrion Bird) — aerial dash equivalent
        br.ui:createCheckbox(section, "Dive",
            "|cffFFFFFFBat/Owl/Carrion Bird only. Speed burst used when the pet is moving and farther than 15 yards from its target.")

        br.ui:checkSectionState(section)
    end,

    run = function()
        ---------------------
        --- Define Locals ---
        ---------------------
        buff    = br.player.buff
        cast    = br.player.cast
        cd      = br.player.cd
        debuff  = br.player.debuff
        enemies = br.player.enemies
        mode    = br.player.ui.mode
        pet     = br.player.pet
        spell   = br.player.spell
        spells  = br.player.spells
        ui      = br.player.ui
        unit    = br.player.unit
        units   = br.player.units
        var     = br.player.variables

        -- Pre-populate enemy tables used by pet family abilities.
        enemies.get(8, "pet")    -- enemies.yards8pet: AoE radius for Screech / Thunderstomp

        -- Halt conditions — actions where pet management should be suppressed entirely.
        var.haltPetProfile = br._G.UnitCastingInfo("pet")
            or br._G.UnitHasVehicleUI("player")
            or br._G.CanExitVehicle("player")
            or br._G.UnitOnTaxi("player")
            or unit.mounted()
            or unit.flying()
            or ui.pause()
            or buff.feignDeath.exists()

        local petExists = unit.exists("pet")
        local petActive = pet.active.exists()
        local petHealth = unit.hp("pet")
        local petDist   = unit.distance("pet", "target") or 99

        if unit.deadOrGhost("pet") then petDead = true end

        ----------------------------
        --- Pet Happiness Warning ---
        ----------------------------
        -- TBC-exclusive: happiness 1=Unhappy (75% dmg), 2=Content (100%), 3=Happy (125%).
        -- Feed the pet manually to maintain Happy state and full damage output.
        if petExists and petActive then
            local happiness = br._G.GetPetHappiness and br._G.GetPetHappiness() or 2
            if happiness == 1 and br._G.GetTime() - happinessWarnTimer > 30 then
                ui.debug("|cffFF0000WARNING|r: Pet is Unhappy — suffering a 25% damage penalty. Feed your pet. [Pet]")
                happinessWarnTimer = br._G.GetTime()
            end
        end

        ----------------------------
        --- Pet Summoning / Revive ---
        ----------------------------
        if ui.checked("Summon Pet") and not var.haltPetProfile and not unit.falling()
            and petAppearTimer < br._G.GetTime() - 2
        then
            -- Confirm pending Call Pet: clear flag on success, or after timeout (do NOT set petDead —
            -- a dismissed/missing pet is not the same as a dead one).
            if petCalled then
                if petExists and petActive then
                    petCalled = false
                elseif br._G.GetTime() - petAppearTimer > PET_CALL_TIMEOUT then
                    petCalled = false  -- timed out; will retry Call Pet, not Revive Pet
                end
            end
            if petRevived and petExists and petActive then petRevived = false; petDead = false end

            -- Revive dead pet (works both in and out of combat).
            if petDead and (petExists and petHealth == 0 or not petExists) then
                if cast.able.revivePet("player") and cast.timeSinceLast.revivePet() > unit.gcd(true) then
                    if cast.revivePet("player") then
                        ui.debug("Casting Revive Pet [Pet]")
                        petAppearTimer = br._G.GetTime(); petRevived = true; petCalled = false; growlAutoCastDisabled = false
                        return true
                    end
                end
            end

            -- Call pet if not present and not already in-flight.
            -- GetPetExperience() returns non-nil for any pet in the active slot (summoned,
            -- dismissed, or dead). It returns nil only when no pet occupies the active slot
            -- (all stabled or no pets owned), in which case Call Pet would fail.
            local hasActivePet = br._G.GetPetExperience() ~= nil
            if not petExists and not petCalled and not petDead and hasActivePet then
                if cast.able.callPet("player") then
                    if cast.callPet("player") then
                        ui.debug("Casting Call Pet [Pet]")
                        petAppearTimer = br._G.GetTime(); petCalled = true; petRevived = false; growlAutoCastDisabled = false
                        return true
                    end
                end
            end
        end

        if var.haltPetProfile then return end

        ----------------------------
        --- Mend Pet              ---
        ----------------------------
        if ui.checked("Mend Pet") and petExists and petActive and not unit.deadOrGhost("pet")
            and not buff.mendPet.exists("pet")
            and petHealth < ui.value("Mend Pet")
            and cast.able.mendPet("pet")
        then
            if cast.mendPet("pet") then
                ui.debug("Casting Mend Pet [Pet]")
                return true
            end
        end

        if not petExists or not petActive or unit.deadOrGhost("pet") then return end

        ----------------------------
        --- Pet Mode Management   ---
        ----------------------------
        -- Apply the user-chosen stance once per change. Calling PetAssistMode() / etc. every
        -- frame is wasteful; we only call the WoW API when the value actually changes.
        local desiredMode = ui.value("Pet Mode")  -- 1=Assist, 2=Defensive, 3=Passive
        if desiredMode ~= lastPetMode then
            if desiredMode == 1 then
                br._G.PetAggressiveMode()
                ui.debug("Pet Mode → Aggressive [Pet]")
            elseif desiredMode == 2 then
                br._G.PetDefensiveMode()
                ui.debug("Pet Mode → Defensive [Pet]")
            elseif desiredMode == 3 then
                br._G.PetPassiveMode()
                ui.debug("Pet Mode → Passive [Pet]")
            end
            lastPetMode = desiredMode
        end

        ----------------------------
        --- PetAttack / PetFollow ---
        ----------------------------
        -- Direct the pet to attack the player's current target when combat begins or the target
        -- changes. A 1-second gate prevents hammering the WoW API every frame.
        -- currentTarget stores the GUID of the last directed target so that transient frame-drops
        -- (e.g. the pettarget token going nil for one tick while a mob fears) do not cause
        -- redundant PetAttack calls that interrupt the pet's current swing animation.
        if targetSwitchTimer < br._G.GetTime() - 1 then
            if unit.valid("target") and not unit.friend("target")
                and desiredMode ~= 3   -- Skip auto-direction in Passive; player controls directly
            then
                -- Send the pet to attack whenever there is a valid enemy target, even pre-combat.
                local targetGUID    = unit.guid("target")
                local pettargetGUID = unit.guid("pettarget")
                if not unit.exists("pettarget")             -- pet has no target at all
                    or targetGUID ~= (pettargetGUID or "")  -- pet is on a different unit
                    or targetGUID ~= currentTarget          -- player switched targets
                then
                    ui.debug("Pet Attack → " .. (unit.name("target") or "target") .. " [Pet]")
                    br._G.PetAttack("target")
                    currentTarget = targetGUID
                end
            elseif not unit.inCombat()
                and br._G.IsPetAttackActive and br._G.IsPetAttackActive()
            then
                -- Out of combat with no valid enemy target (e.g. target deselected pre-pull).
                br._G.PetStopAttack()
                br._G.PetFollow()
                currentTarget = nil
                ui.debug("Pet Follow [Pet]")
            end
            targetSwitchTimer = br._G.GetTime()
        end

        ----------------------------
        --- Growl Auto-Cast Disable ---
        ----------------------------
        -- Disable Growl's built-in auto-cast once per session so this module controls threat
        -- manually. TBC WoW API: GetPetActionInfo(slot) / TogglePetAutocast(slot).
        if ui.checked("Auto Growl") and not growlAutoCastDisabled then
            if br._G.NUM_PET_ACTION_SLOTS then
                for i = 1, br._G.NUM_PET_ACTION_SLOTS do
                    local name, _, _, _, _, autoCastEnabled = br._G.GetPetActionInfo(i)
                    if name and (name == "Growl" or name == "PET_ACTION_GROWL") and autoCastEnabled then
                        if br._G.TogglePetAutocast then
                            br._G.TogglePetAutocast(i)
                        end
                    end
                end
            end
            growlAutoCastDisabled = true
        end

        -- All abilities below require the pet to be attacking a valid enemy.
        if not unit.exists("pettarget") or not unit.valid("pettarget") then return end

        ----------------------------
        --- Furious Howl (Wolf)   ---
        ----------------------------
        -- Highest-priority offensive ability. Very short cooldown (~10s) — buffs the next physical
        -- attack of all nearby party members. Always fire the instant it comes off cooldown.
        if ui.checked("Furious Howl") and cast.able.furiousHowl("pet", "pet") then
            if cast.furiousHowl("pet", "pet") then
                ui.debug("Casting Furious Howl [Pet]")
                return true
            end
        end

        ----------------------------
        --- Shell Shield (Turtle) ---
        ----------------------------
        -- Fire before additional combat abilities so the pet survives to use them.
        if ui.checked("Shell Shield") and petHealth < ui.value("Shell Shield HP")
            and cast.able.shellShield("pet", "pet")
        then
            if cast.shellShield("pet", "pet") then
                ui.debug("Casting Shell Shield [Pet]")
                return true
            end
        end

        ----------------------------
        --- AoE: Screech          ---
        ----------------------------
        -- Carrion Bird/Bat/Owl: AoE melee-AP debuff. High value on 2+ enemies around the pet.
        local petAoECount = enemies.yards8pet and #enemies.yards8pet or 0
        if ui.checked("Screech") and petAoECount >= 2 and cast.able.screech("pettarget", "pet") then
            if cast.screech("pettarget", "pet") then
                ui.debug("Casting Screech (" .. petAoECount .. " targets in 8y) [Pet]")
                return true
            end
        end

        ----------------------------
        --- AoE: Thunderstomp     ---
        ----------------------------
        -- Gorilla: AoE Nature damage + threat generation. High value when 2+ enemies are around the pet.
        if ui.checked("Thunderstomp") and petAoECount >= 2 and cast.able.thunderstomp("pettarget", "pet") then
            if cast.thunderstomp("pettarget", "pet") then
                ui.debug("Casting Thunderstomp (" .. petAoECount .. " targets in 8y) [Pet]")
                return true
            end
        end

        ----------------------------
        --- On-CD Special Attacks ---
        ----------------------------

        -- Scorpid Poison (Scorpid): stacking AP-reducing poison. Fire any time off cooldown.
        if ui.checked("Scorpid Poison") and cast.able.scorpidPoison("pettarget", "pet") then
            if cast.scorpidPoison("pettarget", "pet") then
                ui.debug("Casting Scorpid Poison [Pet]")
                return true
            end
        end

        -- Gore (Boar / Ravager): stacking bleed attack on cooldown.
        if ui.checked("Gore") and cast.able.gore("pettarget", "pet") then
            if cast.gore("pettarget", "pet") then
                ui.debug("Casting Gore [Pet]")
                return true
            end
        end

        -- Fire Breath (Dragonhawk): ranged fire damage on cooldown.
        if ui.checked("Fire Breath") and cast.able.fireBreath("pettarget", "pet") then
            if cast.fireBreath("pettarget", "pet") then
                ui.debug("Casting Fire Breath [Pet]")
                return true
            end
        end

        ----------------------------
        --- Charge (Boar only)    ---
        ----------------------------
        -- Gap-closing charge. Boar only (Crab has NO abilities in TBC).
        -- Range band >10y (out of melee) and <25y (within Charge's effective range).
        -- Charge range (8-25y) is enforced by cast.able via the spell's built-in range data.
        if ui.checked("Charge") and cast.able.charge("pettarget", "pet") then
            if cast.charge("pettarget", "pet") then
                ui.debug("Casting Charge [Pet]")
                return true
            end
        end

        ----------------------------
        --- Lightning Breath      ---
        ----------------------------
        -- Wind Serpent: higher damage-per-energy than Bite/Claw; placed before basic attacks.
        if ui.checked("Lightning Breath") and cast.able.lightningBreath("pettarget", "pet") then
            if cast.lightningBreath("pettarget", "pet") then
                ui.debug("Casting Lightning Breath [Pet]")
                return true
            end
        end

        ----------------------------
        --- Auto Growl            ---
        ----------------------------
        -- Growl the pet's current target when off cooldown and no tank is in range.
        -- The pet's auto-cast for Growl is disabled above so this module controls timing.
        if ui.checked("Auto Growl") and unit.inCombat()
            and not unit.isTankInRange()
            and cast.able.growl("pettarget", "pet")
        then
            if cast.growl("pettarget", "pet") then
                ui.debug("Casting Growl [Pet]")
                return true
            end
        end

        ----------------------------
        --- Dash                  ---
        ----------------------------
        -- Use when the pet is actively moving toward its target and outside melee range.
        -- Dash is a self-cast on the pet; keep explicit distance guard since range = 'self'.
        if ui.checked("Dash") and unit.moving("pet")
            and petDist > 15 and petDist < 40
            and cast.able.dash("pet", "pet")
        then
            if cast.dash("pet", "pet") then
                ui.debug("Casting Dash [Pet]")
                return true
            end
        end

        ----------------------------
        --- Dive (Bat/Owl/Carrion) ---
        ----------------------------
        -- Aerial equivalent of Dash for Carrion Bird/Bat/Owl family.
        if ui.checked("Dive") and unit.moving("pet")
            and petDist > 15 and petDist < 40
            and cast.able.dive("pet", "pet")
        then
            if cast.dive("pet", "pet") then
                ui.debug("Casting Dive [Pet]")
                return true
            end
        end

        ----------------------------
        --- Pet Attack Ability    ---
        ----------------------------
        -- Bite / Claw: primary melee energy-dump attacks. Only fire within melee range.
        -- Note: Smack does not exist in TBC (Wrath+ mechanic only); it is not attempted.
        -- cast.able gates melee range via checkRange (maxRange==0 → distance<=5, pet-to-target).
        if ui.checked("Pet Attack Ability") then
            if cast.able.bite("pettarget", "pet") and cast.bite("pettarget", "pet") then
                ui.debug("Casting Bite [Pet]")
                return true
            end
            if cast.able.claw("pettarget", "pet") and cast.claw("pettarget", "pet") then
                ui.debug("Casting Claw [Pet]")
                return true
            end
        end
    end, -- run
} -- br.loader.rotations.support["PetTBC"]

