-------------------------------------------------------
-- Author = CuteOne
-- Patch = 2.5.1
-- Coverage = 90%
--    Covers: BM / MM / SV single-target, AoE, opener,
--            pet management (via PetTBC), utility, defensives.
-- Status = Full
-- Readiness = Raid
-------------------------------------------------------
-- TBC Hunter rotation for Beast Mastery (253),
-- Marksmanship (254), and Survival (255).
--
-- Rotation priority (single target endgame):
--   Kill Command → Multi-Shot (on CD) → Steady Shot
--   Falls back to Arcane Shot when Steady Shot not yet learned (leveling).
--
-- AoE: Explosive Trap (7+) → Multi-Shot → Volley (10+, both on CD)
--
-- Pet management is handled by PetTBC support module.
-------------------------------------------------------

local rotationName = "CuteOne"
br.loader.cBuilder:loadSupport("PetTBC")

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto",  value = 1, overlay = "Automatic Rotation",        tip = "Swaps between Single and AoE based on enemies in range.",    highlight = 1, icon = br.player.spells.steadyShot },
        [2] = { mode = "Multi", value = 2, overlay = "Multiple Target Rotation",  tip = "Forces AoE rotation (Multi-Shot / Volley priority).",         highlight = 0, icon = br.player.spells.multiShot },
        [3] = { mode = "Sing",  value = 3, overlay = "Single Target Rotation",    tip = "Forces single-target rotation.",                              highlight = 0, icon = br.player.spells.arcaneShot },
        [4] = { mode = "Off",   value = 4, overlay = "DPS Rotation Disabled",     tip = "Disable DPS rotation.",                                       highlight = 0, icon = br.player.spells.aspectOfTheCheetah },
    }
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Cooldowns used on boss targets only.",       highlight = 1, icon = br.player.spells.rapidFire },
        [2] = { mode = "On",   value = 2, overlay = "Cooldowns Enabled",   tip = "Cooldowns used regardless of target.",       highlight = 0, icon = br.player.spells.rapidFire },
        [3] = { mode = "Off",  value = 3, overlay = "Cooldowns Disabled",  tip = "No cooldowns will be used.",                 highlight = 0, icon = br.player.spells.rapidFire },
    }
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On",  value = 1, overlay = "Defensive Enabled",  tip = "Includes defensive cooldowns.", highlight = 1, icon = br.player.spells.feignDeath },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No defensives will be used.",   highlight = 0, icon = br.player.spells.feignDeath },
    }
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt / CC Button
    local InterruptModes = {
        [1] = { mode = "On",  value = 1, overlay = "CC/Interrupt Enabled",  tip = "Uses Silencing Shot, Concussive Shot, Scatter Shot, Freezing Trap.", highlight = 1, icon = br.player.spells.concussiveShot },
        [2] = { mode = "Off", value = 2, overlay = "CC/Interrupt Disabled", tip = "No interrupts, CC, or slows will be used.",                          highlight = 0, icon = br.player.spells.concussiveShot },
    }
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
    -- Misdirection Button
    local MisdirectionModes = {
        [1] = { mode = "On",  value = 1, overlay = "Misdirection Enabled",  tip = "Misdirection cast on pull and on cooldown.", highlight = 1, icon = br.player.spells.misdirection },
        [2] = { mode = "Off", value = 2, overlay = "Misdirection Disabled", tip = "Misdirection will not be used.",              highlight = 0, icon = br.player.spells.misdirection },
    }
    br.ui:createToggle(MisdirectionModes, "Misdirection", 5, 0)
end

---------------
--- Options ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        local alwaysCdNever = { "Always", "|cff0000ffCD", "|cffff0000Never" }

        -----------------------
        --- General Options ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5,
            "|cffFFFFFFSet duration for dummy DPS test in minutes. Min: 5 / Max: 60")
        -- Hunter's Mark
        br.ui:createDropdownWithout(section, "Hunter's Mark", alwaysCdNever, 1,
            "|cffFFFFFFWhen to apply Hunter's Mark. 'CD' = only on bosses / cooldown eligible targets.")
        -- Misdirection target
        br.ui:createDropdownWithout(section, "Misdirection Target",
            { "|cff00FF00Tank", "|cffFFFF00Focus", "|cffFF0000Pet" }, 1,
            "|cffFFFFFFWho to cast Misdirection on.")
        -- Sting selection (mutually exclusive: only one sting per target at a time)
        br.ui:createDropdownWithout(section, "Sting",
            { "None", "Serpent Sting", "Scorpid Sting", "Wyvern Sting" }, 1,
            "|cffFFFFFFWhich sting to use. Serpent: sustained DoT (leveling). Scorpid: -AP debuff (physical bosses). Wyvern: CC sleep via interrupts section (Survival talent). One sting per target.")
        -- Wing Clip
        br.ui:createCheckbox(section, "Wing Clip",
            "|cffFFFFFFApply Wing Clip while running away from a mob in melee range to slow it and create kiting distance. Only fires while moving. Skipped when a tank is nearby.")
        br.ui:checkSectionState(section)

        --------------------
        --- Aspect Options ---
        --------------------
        section = br.ui:createSection(br.ui.window.profile, "Aspects")
        -- Viper Threshold
        br.ui:createSpinner(section, "Viper Threshold", 20, 5, 60, 5,
            "|cffFFFFFFMana % to enter Aspect of the Viper for mana recovery.")
        -- Viper Recovery
        br.ui:createSpinner(section, "Viper Recovery", 90, 60, 95, 5,
            "|cffFFFFFFMana % to leave Aspect of the Viper and return to the normal aspect.")
        -- Aspect of the Wild
        br.ui:createCheckbox(section, "Aspect of the Wild",
            "|cffFFFFFFUse Aspect of the Wild (+Nature resistance) when available. Overrides Hawk while active.")
        -- Monkey in Melee
        br.ui:createCheckbox(section, "Monkey in Melee",
            "|cffFFFFFFSwap to Aspect of the Monkey when any enemy is within 5y, boosting dodge chance and Mongoose Bite procs. Returns to Hawk immediately once no enemies are in melee range.")
        -- Cheetah (Solo)
        br.ui:createCheckbox(section, "Cheetah (Solo)",
            "|cffFFFFFFAuto-apply Aspect of the Cheetah when solo and out of combat after moving for the Travel Delay duration. Returns to Hawk when combat begins or movement stops.")
        -- Pack (Group)
        br.ui:createCheckbox(section, "Pack (Group)",
            "|cffFFFFFFAuto-apply Aspect of the Pack when grouped and out of combat after moving for the Travel Delay duration. Returns to Hawk when combat begins or movement stops.")
        -- Travel Delay
        br.ui:createSpinner(section, "Travel Delay", 3, 1, 10, 1,
            "|cffFFFFFFSeconds of continuous movement required before switching to a travel aspect (Cheetah or Pack). Prevents brief repositioning from triggering a swap.")
        br.ui:checkSectionState(section)

        -----------------
        --- Pet Options ---
        -----------------
        br.loader.rotations.support["PetTBC"].options()

        -------------------------
        --- Cooldown Options  ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Rapid Fire
        br.ui:createDropdownWithout(section, "Rapid Fire", alwaysCdNever, 2,
            "|cffFFFFFFWhen to use Rapid Fire. 'CD' = boss targets only.")
        -- Bestial Wrath (BM only — cast.able naturally gatekeeps)
        br.ui:createDropdownWithout(section, "Bestial Wrath", alwaysCdNever, 2,
            "|cffFFFFFFWhen to use Bestial Wrath (Beast Mastery only). 'CD' = boss targets only.")
        br.ui:checkSectionState(section)

        -------------------------
        --- AoE Options        ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AoE")
        -- Explosive Trap threshold
        br.ui:createSpinner(section, "Explosive Trap Threshold", 4, 2, 20, 1,
            "|cffFFFFFFMinimum melee-range enemies to use Explosive Trap.")
        -- Volley threshold
        br.ui:createSpinner(section, "Volley Threshold", 5, 2, 20, 1,
            "|cffFFFFFFMinimum ranged enemies to channel Volley.")
        -- Immolation Trap (ST counterpart to Explosive Trap)
        br.ui:createCheckbox(section, "Immolation Trap",
            "|cffFFFFFFDrop Immolation Trap (single-target fire DoT) when the target is within 8y during single-target rotation. Explosive Trap takes precedence in AoE mode.")
        br.ui:checkSectionState(section)

        -------------------------
        --- Defensive Options ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Frost Trap
        br.ui:createCheckbox(section, "Frost Trap",
            "|cffFFFFFFDrop Frost Trap when 2+ enemies reach melee range to slow pursuers and create kiting distance.")
        -- Feign Death
        br.ui:createSpinner(section, "Feign Death", 20, 5, 60, 5,
            "|cffFFFFFFHealth % to use Feign Death as a defensive (drops threat + avoids death).")
        -- Disengage
        br.ui:createCheckbox(section, "Disengage",
            "|cffFFFFFFUse Disengage to escape melee range and re-establish ranged distance when a mob is within 5y.")
        br.ui:checkSectionState(section)

        -------------------------
        --- Interrupt Options  ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Interrupt % threshold
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5,
            "|cffFFFFFFCast % to use CC/interrupt. 0 = at any cast stage.")
        -- Scatter Shot
        br.ui:createCheckbox(section, "Scatter Shot",
            "|cffFFFFFFUse Scatter Shot (MM talent) to disorient casting enemies as a follow-up CC.")
        -- Freezing Trap
        br.ui:createCheckbox(section, "Freezing Trap",
            "|cffFFFFFFUse Freezing Trap on actively casting enemies (2s in-combat delay applies).")
        -- Distracting Shot
        br.ui:createCheckbox(section, "Distracting Shot",
            "|cffFFFFFFUse Distracting Shot to pull aggro off a friendly (party member or pet) being attacked by an enemy.")
        br.ui:checkSectionState(section)

        ----------------------
        --- Toggle Options ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        br.ui:createDropdownWithout(section, "Rotation Mode",     br.ui.dropOptions.Toggle, 4)
        br.ui:createDropdownWithout(section, "Cooldown Mode",     br.ui.dropOptions.Toggle, 3)
        br.ui:createDropdownWithout(section, "Defensive Mode",    br.ui.dropOptions.Toggle, 6)
        br.ui:createDropdownWithout(section, "Interrupt Mode",    br.ui.dropOptions.Toggle, 6)
        br.ui:createDropdownWithout(section, "Misdirection Mode", br.ui.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end

    optionTable = { {
        [1] = "Rotation Options",
        [2] = rotationOptions,
    } }
    return optionTable
end

--------------
--- Locals ---
--------------
local buff
local cast
local cd
local debuff
local enemies
local mana
local module
local pet
local ui
local unit
local units
local spell
local var = {}
local haltProfile
local profileStop
local actionList = {}

local function wantHuntersMark()
    local v = ui.value("Hunter's Mark")
    return v == 1 or (v == 2 and ui.useCDs())
end

--------------------
--- Action Lists ---
--------------------

-- Action List - Aspects
-- Desired-state model: compute the single correct aspect each tick and apply it if not active.
-- Priority: Viper (low mana) > Monkey (combat+melee) > Wild (option) > Hawk (default) >
--           Pack (grouped OOC, moving) > Cheetah (solo OOC, moving) > Monkey (leveling fallback)
--
-- Design notes:
--   Intent resolution uses only stable game-state booleans — no cast.able.* anywhere. cast.able
--   returns false during the GCD, which would corrupt desired state and create oscillation.
--
--   The apply block also omits cast.able. Aspects are instant self-casts with no cooldown, so
--   the only guard needed is "not already active". If cast.X() returns false for a transient
--   reason (e.g. currently channeling), the function returns nil and retries next tick.
--   Since Aspects runs first in runRotation, it wins the first free GCD over any combat shot.
--
--   inMelee uses a 2s hysteresis window (var.lastMeleeTime) to absorb positional jitter at
--   the 5y boundary. Without it, server position updates can flip inMelee on alternating ticks.
--
--   inGroup uses unit.groupCount() > 0 rather than unit.inGroup() because the latter is backed
--   by the healing engine friend list which may include the player and return > 1 when solo.
actionList.Aspects = function()
    local now      = ui.time()
    local inCombat = unit.inCombat()
    local inGroup  = unit.groupCount() > 0
    local inMelee  = enemies.yards5 ~= nil and #enemies.yards5 > 0

    -- Update hysteresis timestamp while enemies are actively in melee range
    if inMelee then var.lastMeleeTime = now end
    local inMeleeRecent = inMelee or (now - (var.lastMeleeTime or 0)) < 2.0

    local movingDuration = unit.moving() and var.moveStart and (ui.time() - var.moveStart) or 0
    local movingLong     = movingDuration >= ui.value("Travel Delay")

    -- Viper: intent based purely on mana % and buff state
    local wantViper
    if spell.aspectOfTheViper.known() then
        if buff.aspectOfTheViper.exists() then
            wantViper = mana.percent() < ui.value("Viper Recovery")
        else
            wantViper = mana.percent() <= ui.value("Viper Threshold")
        end
    end

    -- Monkey: respect a manually cast buff while the base conditions still hold (in combat,
    -- enemy recently in melee). The option only controls whether the rotation applies it fresh.
    local wantMonkey = not wantViper and inCombat and inMeleeRecent
        and (
            buff.aspectOfTheMonkey.exists()        -- keep manual or auto cast
            or ui.checked("Monkey in Melee")       -- apply fresh when enabled
        )

    -- Wild: respect a manually cast buff while higher-priority aspects aren't needed.
    -- spell.known() prevents a checked-but-unlearned option from blocking all other aspects.
    local wantWild   = not wantViper and not wantMonkey
        and spell.aspectOfTheWild.known()
        and (
            buff.aspectOfTheWild.exists()          -- keep manual or auto cast
            or ui.checked("Aspect of the Wild")    -- apply fresh when enabled
        )

    -- Travel aspects: movingLong gates the *initial* switch in; once active the buff itself
    -- keeps the aspect desired until combat begins or a hostile target is acquired.
    -- aboutToPull covers the gap between targeting a mob and inCombat flipping true —
    -- without it, Cheetah stays desired until the server registers combat (1-2 ticks delay).
    -- groupMemberInCombat: Pack daze can cause a party member to be attacked while the player
    -- is still OOC. Drop Pack immediately when any party member comes under threat.
    local aboutToPull = unit.valid("target") and not unit.friend("target")
    local groupMemberInCombat = false
    if inGroup then
        for i = 1, 4 do
            if unit.inCombat("party" .. i) then
                groupMemberInCombat = true
                break
            end
        end
    end
    -- wantPack / wantCheetah: true when the rotation should keep or apply the travel aspect.
    -- A manually cast buff is respected while the base conditions still hold (OOC, right group
    -- state, not about to pull), regardless of whether the UI toggle is enabled.
    -- The toggle only controls whether the rotation *applies* the aspect fresh (movingLong gate).
    local wantPack    = not inCombat and not aboutToPull and not groupMemberInCombat and inGroup
        and (
            buff.aspectOfThePack.exists()                              -- keep manual or auto cast
            or (ui.checked("Pack (Group)") and movingLong)             -- apply fresh when enabled
        )
    local wantCheetah = not inCombat and not aboutToPull and not inGroup
        and (
            buff.aspectOfTheCheetah.exists()                           -- keep manual or auto cast
            or (ui.checked("Cheetah (Solo)") and movingLong)           -- apply fresh when enabled
        )

    -- Resolve desired aspect from pure game state
    local desired
    if wantViper then
        desired = "viper"
    elseif wantMonkey then
        desired = "monkey"
    elseif wantWild then
        desired = "wild"
    elseif inCombat then
        desired = "hawk"
    elseif wantPack then
        desired = "pack"
    elseif wantCheetah then
        desired = "cheetah"
    elseif spell.aspectOfTheHawk.known() then
        desired = "hawk"
    else
        desired = "monkey"  -- early-level fallback: Hawk not yet learned
    end

    -- Apply desired aspect when not already active.
    if desired == "viper" and not buff.aspectOfTheViper.exists() and cast.able.aspectOfTheViper("player") then
        if cast.aspectOfTheViper("player") then
            ui.debug("Casting Aspect of the Viper [Aspects]")
            return true
        end
    elseif desired == "monkey" and not buff.aspectOfTheMonkey.exists() and cast.able.aspectOfTheMonkey("player") then
        if cast.aspectOfTheMonkey("player") then
            ui.debug("Casting Aspect of the Monkey [Aspects]")
            return true
        end
    elseif desired == "wild" and not buff.aspectOfTheWild.exists() and cast.able.aspectOfTheWild("player") then
        if cast.aspectOfTheWild("player") then
            ui.debug("Casting Aspect of the Wild [Aspects]")
            return true
        end
    elseif desired == "hawk" and not buff.aspectOfTheHawk.exists() and cast.able.aspectOfTheHawk("player") then
        if cast.aspectOfTheHawk("player") then
            ui.debug("Casting Aspect of the Hawk [Aspects]")
            return true
        end
    elseif desired == "pack" and not buff.aspectOfThePack.exists() and cast.able.aspectOfThePack("player") then
        if cast.aspectOfThePack("player") then
            ui.debug("Casting Aspect of the Pack [Aspects]")
            return true
        end
    elseif desired == "cheetah" and not buff.aspectOfTheCheetah.exists() and cast.able.aspectOfTheCheetah("player") then
        if cast.aspectOfTheCheetah("player") then
            ui.debug("Casting Aspect of the Cheetah [Aspects]")
            return true
        end
    end
end

-- Action List - Extra (out of combat maintenance)
actionList.Extra = function()
    ---------------------------------------------------------------
    --- Trueshot Aura (MM talent; gatekept by cast.able)
    ---------------------------------------------------------------
    if not buff.trueShotAura.exists() and cast.able.trueShotAura() then
        if cast.trueShotAura("player") then
            ui.debug("Casting Trueshot Aura [Extra]")
            return true
        end
    end

    ---------------------------------------------------------------
    --- Hunter's Mark
    ---------------------------------------------------------------
    if unit.valid("target") and not unit.friend("target") then
        local hmACN    = wantHuntersMark()
        local hmAble   = cast.able.huntersMark("target")
        local hmDebuff = debuff.huntersMark.exists("target")
        if hmACN and hmAble and not hmDebuff then
            if cast.huntersMark("target") then
                ui.debug("Casting Hunter's Mark [Extra]")
                return true
            end
        end
    end
end

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Frost Trap (kite slow; drop at player's feet when 2+ enemies reach melee range)
        if ui.checked("Frost Trap") and #enemies.yards8 >= 2
            and cast.able.frostTrap() and not unit.moving()
        then
            if cast.frostTrap() then
                ui.debug("Casting Frost Trap [Defensive]")
                return true
            end
        end

        -- Feign Death (emergency — drops threat, prevents death)
        if ui.checked("Feign Death") and cast.able.feignDeath()
            and unit.hp("player") <= ui.value("Feign Death") and unit.inCombat()
        then
            if cast.feignDeath() then
                ui.debug("Casting Feign Death [Defensive]")
                return true
            end
        end
    end
end

-- Action List - Interrupts / CC
actionList.Interrupts = function()
    if ui.useInterrupt() and ui.delay("Interrupts", unit.gcd(true)) then
        -- Distracting Shot: redirect aggro off a friendly to the player
        if ui.checked("Distracting Shot") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local mobTarget = unit.target(thisUnit)
                if mobTarget
                    and not unit.isUnit(mobTarget, "player")
                    and unit.friend("player", mobTarget)
                    and cast.able.distractingShot(thisUnit)
                then
                    if cast.distractingShot(thisUnit) then
                        ui.debug("Casting Distracting Shot on " .. unit.name(thisUnit) .. " [Interrupts]")
                        return true
                    end
                end
            end
        end
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                -- Silencing Shot (MM talent — real 3s school silence; highest priority)
                if cast.able.silencingShot(thisUnit) then
                    if cast.silencingShot(thisUnit) then
                        ui.debug("Casting Silencing Shot on " .. unit.name(thisUnit) .. " [Interrupts]")
                        return true
                    end
                end
                -- Scatter Shot (MM talent — 4s disorient; follow-up when Silencing is on CD)
                if ui.checked("Scatter Shot") and cast.able.scatterShot(thisUnit)
                    and cd.silencingShot.remains() > 0
                then
                    if cast.scatterShot(thisUnit) then
                        ui.debug("Casting Scatter Shot on " .. unit.name(thisUnit) .. " [Interrupts]")
                        return true
                    end
                end
                -- Concussive Shot (instant slow — delays cast; universal fallback)
                if cast.able.concussiveShot(thisUnit) then
                    if cast.concussiveShot(thisUnit) then
                        ui.debug("Casting Concussive Shot on " .. unit.name(thisUnit) .. " [Interrupts]")
                        return true
                    end
                end
                -- Freezing Trap (CC — 2s arming delay in TBC; only off CD, target not in melee)
                if ui.checked("Freezing Trap") and cast.able.freezingTrap()
                    and unit.distance(thisUnit) > 5 and cd.freezingTrap.remains() == 0
                then
                    if cast.freezingTrap() then
                        ui.debug("Casting Freezing Trap [Interrupts]")
                        return true
                    end
                end
                -- Wyvern Sting (SV talent — sleep secondary target when Freezing Trap is on CD)
                if ui.value("Sting") == 4 and cast.able.wyvernSting(thisUnit)
                    and cd.freezingTrap.remains() > 0
                    and not debuff.wyvernSting.exists(thisUnit)
                then
                    if cast.wyvernSting(thisUnit) then
                        ui.debug("Casting Wyvern Sting on " .. unit.name(thisUnit) .. " [Interrupts]")
                        return true
                    end
                end
            end
        end
    end
end

-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- Basic Trinkets
    module.BasicTrinkets()

    -- Rapid Fire
    if ui.alwaysCdNever("Rapid Fire") and cast.able.rapidFire() then
        if cast.rapidFire() then
            ui.debug("Casting Rapid Fire [Cooldowns]")
            return true
        end
    end

    -- Bestial Wrath (BM talent — cast.able is false unless specced BM)
    if ui.alwaysCdNever("Bestial Wrath") and cast.able.bestialWrath() then
        if cast.bestialWrath() then
            ui.debug("Casting Bestial Wrath [Cooldowns]")
            return true
        end
    end

    -- Intimidation (stuns pet's current target; BM talent)
    if ui.useCDs() and cast.able.intimidation() and unit.valid("target") and unit.distance("target") < 5 then
        if cast.intimidation() then
            ui.debug("Casting Intimidation [Cooldowns]")
            return true
        end
    end

    -- Misdirection (in-combat; 30s CD; redirect threat to tank/focus/pet)
    -- Falls back to pet if the preferred target is unavailable.
    if unit.inCombat() and cast.able.misdirection() and ui.mode.misdirection == 1 then
        local mdPref = ui.value("Misdirection Target")
        local mdResolved = nil
        if mdPref == 1 then
            for i = 1, unit.groupCount() do
                local member = "party" .. i
                if unit.exists(member) and unit.isTank(member)
                    and cast.able.misdirection(member)
                then
                    mdResolved = member
                    break
                end
            end
        elseif mdPref == 2
            and unit.exists("focus") and cast.able.misdirection("focus")
        then
            mdResolved = "focus"
        elseif mdPref == 3
            and unit.exists("pet") and cast.able.misdirection("pet")
        then
            mdResolved = "pet"
        end
        -- Fallback to pet if preferred target unavailable
        if not mdResolved and unit.exists("pet") and cast.able.misdirection("pet") then
            mdResolved = "pet"
        end
        if mdResolved then
            if cast.misdirection(mdResolved) then
                ui.debug("Casting Misdirection on " .. unit.name(mdResolved) .. " [Cooldowns]")
                return true
            end
        end
    end
end

-- Action List - Pre-Combat (not in combat, valid target exists)
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        if unit.valid("target") and not unit.friend("target") then
            -- Hunter's Mark
            local hmAble   = cast.able.huntersMark("target")
            local hmDebuff = debuff.huntersMark.exists("target")
            if wantHuntersMark() and hmAble and not hmDebuff then
                if cast.huntersMark("target") then
                    ui.debug("Casting Hunter's Mark [PreCombat]")
                    return true
                end
            end

            local targetDist = unit.distance("target") or 99

            -- If already in melee range before combat starts (e.g. mob walked up, ambush
            -- scenario), kick in the melee branch immediately so the rotation isn't stalled
            -- waiting for a ranged opener that can never fire.
            if targetDist < 5 then
                if actionList.Melee() then return true end
            end

            if targetDist > 8 and targetDist < 40 then
                -- Misdirection on tank / focus / pet before the pull.
                -- Falls back to pet if the preferred target is unavailable.
                if ui.mode.misdirection == 1 and cast.able.misdirection() then
                    local mdPref = ui.value("Misdirection Target")
                    local mdResolved = nil
                    if mdPref == 1 then
                        for i = 1, unit.groupCount() do
                            local member = "party" .. i
                            if unit.exists(member) and unit.isTank(member)
                                and cast.able.misdirection(member)
                            then
                                mdResolved = member
                                break
                            end
                        end
                    elseif mdPref == 2
                        and unit.exists("focus") and not unit.friend("focus")
                        and cast.able.misdirection("focus")
                    then
                        mdResolved = "focus"
                    elseif mdPref == 3
                        and unit.exists("pet") and cast.able.misdirection("pet")
                    then
                        mdResolved = "pet"
                    end
                    -- Fallback to pet if preferred target unavailable
                    if not mdResolved and unit.exists("pet") and cast.able.misdirection("pet") then
                        mdResolved = "pet"
                    end
                    if mdResolved then
                        if cast.misdirection(mdResolved) then
                            ui.debug("Casting Misdirection on " .. unit.name(mdResolved) .. " [PreCombat]")
                            return true
                        end
                    end
                end

                -- Aimed Shot pre-pull (3s cast; time it to finish as the pull timer hits 0)
                if cast.able.aimedShot("target") and not unit.moving() then
                    if cast.aimedShot("target") then
                        ui.debug("Casting Aimed Shot [PreCombat]")
                        return true
                    end
                end

                -- Auto Shot (begins auto-attack loop)
                if cast.able.autoShot("target") then
                    if cast.autoShot("target") then
                        ui.debug("Casting Auto Shot [PreCombat]")
                        return true
                    end
                end
            end
        end
    end
end

-- Action List - Pet Management (delegate to PetTBC support)
actionList.PetManagement = br.loader.rotations.support["PetTBC"].run

-- Action List - Melee (target within 5y; ranged shots blocked by dead zone)
-- Provides melee DPS and escape tools while the Hunter re-ranges.
-- Priority: Mongoose Bite (after dodge) > Raptor Strike (swing bonus) > Counterattack (after parry) > Wing Clip (moving) > Disengage (escape)
actionList.Melee = function()
    if not unit.exists(units.dyn5) or unit.distance(units.dyn5) >= 5 then return false end

    -- Ensure melee auto-attack is running. Placed here without returning so all ability
    -- checks execute on this same frame. Calling startAttack() repeatedly is idempotent.
    if unit.valid(units.dyn5) and not unit.deadOrGhost(units.dyn5) then
        unit.startAttack()
    end

    -- Mongoose Bite: instant; proc-based, only usable after dodging (game engine enforces via cast.able)
    if cast.able.mongooseBite(units.dyn5) then
        if cast.mongooseBite(units.dyn5) then
            ui.debug("Casting Mongoose Bite [Melee]")
            return true
        end
    end

    -- Raptor Strike: queues bonus damage on next melee swing; use on cooldown.
    -- cast.able is blocked while it is already queued via the IsCurrentSpell gate
    -- in the cast framework (gateAutoRepeat), so no extra guard is needed here.
    if cast.able.raptorStrike(units.dyn5) then
        if cast.raptorStrike(units.dyn5) then
            ui.debug("Casting Raptor Strike [Melee]")
            return true
        end
    end

    -- Counterattack: SV talent; usable after parrying; snares and damages target
    if cast.able.counterattack(units.dyn5) then
        if cast.counterattack(units.dyn5) then
            ui.debug("Casting Counterattack [Melee]")
            return true
        end
    end

    -- Wing Clip: slow the attacker while running away to create kiting distance
    if ui.checked("Wing Clip") and unit.moving() and cast.able.wingClip(units.dyn5)
        and not debuff.concussiveShot.exists(units.dyn5)
        and not unit.isTankInRange()
    then
        if cast.wingClip(units.dyn5) then
            ui.debug("Casting Wing Clip [Melee]")
            return true
        end
    end

    -- Disengage: drop threat on current target and re-establish ranged distance.
    -- Safe to use when a tank (group) or an active, living pet (solo) can absorb the
    -- transferred aggro. Without one of these, the mob simply re-targets the hunter.
    local petCanTank = unit.exists("pet") and not unit.deadOrGhost("pet") and pet.active.exists()
    if ui.checked("Disengage") and cast.able.disengage()
        and unit.threatStatus() >= 2
        and (unit.isTankInRange() or petCanTank)
    then
        if cast.disengage() then
            ui.debug("Casting Disengage [Threat Reduction]")
            return true
        end
    end
end

-- Action List - Ranged
-- All ranged damage in priority order, covering both AoE and single-target.
-- Called from actionList.Combat after melee and trap handling; assumes target is >= 5y away.
-- Priority: AoE (Explosive Trap > Multi-Shot > Volley) or ST (Kill Command > Sting > Multi > Steady > Aimed > Arcane > Auto)
actionList.Ranged = function()
    local targetDist = unit.distance(units.dyn40) or 99
    local shotCount  = #enemies.yards40  -- ranged enemies (Multi-Shot / Volley eligibility)
    local isAoE      = ui.mode.rotation == 2
        or (ui.mode.rotation == 1 and shotCount >= 3)

    -- Ranged auto-shot timer (seconds until next auto fires).
    -- Used to gate Steady Shot so it never clips the auto cycle.
    -- autoTimer == 999 means the timer hasn't calibrated yet (first shot); allow cast freely.
    local autoTimer  = br.player.swing and br.player.swing.ranged and br.player.swing.ranged.timer or 999
    local steadyTime = cast.time.steadyShot and cast.time.steadyShot() or 2.0

    ---------------------------------------------------------------
    --- AoE Branch
    ---------------------------------------------------------------
    if isAoE then
        -- Multi-Shot (highest-priority ranged AoE; use on cooldown).
        -- targetAOE type: hits enemies within 8 yards of the primary target (TBC Multi-Shot mechanic).
        if cast.able.multiShot(units.dyn40, "targetAOE", 1, 8) and not unit.moving() then
            if cast.multiShot(units.dyn40, "targetAOE", 1, 8) then
                ui.debug("Casting Multi-Shot [Ranged AoE]")
                return true
            end
        end
        -- Volley (channel AoE; configurable threshold; Multi-Shot must be on CD)
        if shotCount >= ui.value("Volley Threshold")
            and cast.able.volley(units.dyn40)
            and not cast.able.multiShot(units.dyn40)
            and not unit.moving()
        then
            if cast.volley(units.dyn40) then
                ui.debug("Casting Volley [Ranged AoE]")
                return true
            end
        end
    end

    ---------------------------------------------------------------
    --- Kill Command (off-GCD proc; fires in AoE and ST modes)
    ---------------------------------------------------------------
    if cast.able.killCommand() then
        if cast.killCommand() then
            ui.debug("Casting Kill Command [Ranged]")
            return true
        end
    end

    ---------------------------------------------------------------
    --- Sting maintenance (dropdown selection; one sting per target)
    ---------------------------------------------------------------
    local stingChoice = ui.value("Sting")
    if stingChoice == 3 and cast.able.scorpidSting(units.dyn40)
        and not debuff.scorpidSting.exists(units.dyn40)
        and unit.ttd(units.dyn40) > 6
    then
        if cast.scorpidSting(units.dyn40) then
            ui.debug("Casting Scorpid Sting [Ranged]")
            return true
        end
    end
    if stingChoice == 2 and cast.able.serpentSting(units.dyn40)
        and not debuff.serpentSting.exists(units.dyn40)
        and unit.ttd(units.dyn40) > 6
    then
        if cast.serpentSting(units.dyn40) then
            ui.debug("Casting Serpent Sting [Ranged]")
            return true
        end
    end

    ---------------------------------------------------------------
    --- Aimed Shot (endgame: debuff +240 ranged damage taken; refresh when missing)
    --- Only fires when Steady Shot is trained. Leveling block below handles
    --- the pre-Steady case where Aimed Shot is the primary filler.
    ---------------------------------------------------------------
    if spell.steadyShot.known() and spell.aimedShot.known()
        and cast.able.aimedShot(units.dyn40) and not unit.moving()
        and not debuff.aimedShot.exists(units.dyn40)
        and unit.ttd(units.dyn40) > 8
    then
        if cast.aimedShot(units.dyn40) then
            ui.debug("Casting Aimed Shot [Ranged - Debuff]")
            return true
        end
    end

    ---------------------------------------------------------------
    --- Aimed Shot (leveling; before Steady Shot is trained)
    --- Prioritised over Multi-Shot per guide: Aimed Shot > Multi-Shot.
    --- Woven between autos (3s cast guard) and gated on mana so the
    --- rotation does not OOM before targets die.
    ---------------------------------------------------------------
    if not spell.steadyShot.known() and spell.aimedShot.known()
        and cast.able.aimedShot(units.dyn40) and not unit.moving()
        and mana.percent() >= 30
    then
        local aimedTime   = 3.0
        local safeToAimed = autoTimer >= (aimedTime - 0.15) or autoTimer == 999
        if safeToAimed then
            if cast.aimedShot(units.dyn40) then
                ui.debug("Casting Aimed Shot [Ranged - Leveling] (auto=" .. string.format("%.2f", autoTimer) .. "s)")
                return true
            end
        end
    end

    ---------------------------------------------------------------
    --- Multi-Shot (single-target: use on cooldown for highest DPE)
    --- Leveling: gated on mana per guide ("if you are fine on Mana").
    ---------------------------------------------------------------
    if not isAoE and cast.able.multiShot(units.dyn40, "targetAOE", 1, 8)
        and (spell.steadyShot.known() or mana.percent() >= 30)
        and not unit.moving()
    then
        if cast.multiShot(units.dyn40, "targetAOE", 1, 8) then
            ui.debug("Casting Multi-Shot [Ranged ST]")
            return true
        end
    end

    ---------------------------------------------------------------
    --- Steady Shot — shot-weave gating
    --- Only cast when enough of the auto cycle remains that Steady
    --- will finish before the next auto fires, preventing clipping.
    ---------------------------------------------------------------
    if cast.able.steadyShot(units.dyn40) and not unit.moving() then
        local safeToSteady = autoTimer >= (steadyTime - 0.15) or autoTimer == 999
        if safeToSteady then
            if cast.steadyShot(units.dyn40) then
                ui.debug("Casting Steady Shot [Ranged] (auto=" .. string.format("%.2f", autoTimer) .. "s)")
                return true
            end
        end
    end

    ---------------------------------------------------------------
    --- Arcane Shot
    ---   < 18  (no Multi-Shot): primary instant filler; fires stationary (mana gated).
    ---   18-19 (no Aimed Shot): secondary filler when Multi-Shot is on CD (mana gated).
    ---   20+   (Aimed Shot known, pre-Steady): stationary use dropped — Aimed Shot
    ---          already owns the mana budget; continue while moving only.
    ---   Endgame (Steady Shot trained): moving filler only; no mana gate (kiting matters).
    ---------------------------------------------------------------
    if cast.able.arcaneShot(units.dyn40) then
        if unit.moving() then
            -- Always valuable while kiting; no mana gate so it never silences a kite.
            if cast.arcaneShot(units.dyn40) then
                ui.debug("Casting Arcane Shot [Ranged - Kiting]")
                return true
            end
        elseif not spell.steadyShot.known() and not spell.aimedShot.known()
            and mana.percent() >= 30
        then
            -- Stationary primary/secondary filler only before Aimed Shot is trained (pre-20).
            if cast.arcaneShot(units.dyn40) then
                ui.debug("Casting Arcane Shot [Ranged - Filler]")
                return true
            end
        end
    end

    ---------------------------------------------------------------
    --- Auto Shot (engage ranged auto-attack)
    ---------------------------------------------------------------
    if cast.able.autoShot(units.dyn40) and targetDist > 8 then
        if cast.autoShot(units.dyn40) then
            ui.debug("Casting Auto Shot [Ranged]")
            return true
        end
    end
end

-- Action List - Combat (dispatcher)
-- Handles entry guards and context-sensitive traps, then delegates to Melee or Ranged.
actionList.Combat = function()
    -- Require: in combat or a valid target ready, not halted, GCD free
    if (unit.inCombat() or unit.valid(units.dyn40)) and not var.profileStop
        and unit.exists(units.dyn40) and cd.global.remain() == 0
    then
        local targetDist = unit.distance(units.dyn40) or 99
        local aoeCount   = #enemies.yards8
        local shotCount  = #enemies.yards40
        local isAoE      = ui.mode.rotation == 2
            or (ui.mode.rotation == 1 and shotCount >= 3)

        ---------------------------------------------------------------
        --- Melee Branch (target within 5y; ranged shots inactive)
        ---------------------------------------------------------------
        if actionList.Melee() then return true end

        ---------------------------------------------------------------
        --- Proximity Traps (both require target within 8y; AoE or ST context)
        ---------------------------------------------------------------
        -- Explosive Trap (AoE burst; configurable enemy count threshold)
        if isAoE and aoeCount >= ui.value("Explosive Trap Threshold")
            and cast.able.explosiveTrap() and targetDist < 8
        then
            if cast.explosiveTrap() then
                ui.debug("Casting Explosive Trap [Combat]")
                return true
            end
        end
        -- Immolation Trap (ST fire DoT; inverse counterpart to Explosive Trap)
        if not isAoE and ui.checked("Immolation Trap")
            and cast.able.immolationTrap() and targetDist < 8 and not unit.moving()
        then
            if cast.immolationTrap() then
                ui.debug("Casting Immolation Trap [Combat]")
                return true
            end
        end

        ---------------------------------------------------------------
        --- Ranged Rotation
        ---------------------------------------------------------------
        if actionList.Ranged() then return true end
    end
end

----------------
--- Rotation ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    buff    = br.player.buff
    cast    = br.player.cast
    cd      = br.player.cd
    debuff  = br.player.debuff
    enemies = br.player.enemies
    mana    = br.player.power.mana
    module  = br.player.module
    pet     = br.player.pet
    ui      = br.player.ui
    unit    = br.player.unit
    units   = br.player.units
    spell   = br.player.spell

    -- General locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop)
        or ui.pause()
        or ui.mode.rotation == 4
        or unit.id("target") == 156716   -- training dummy stop ID

    -- Rebind PetManagement each tick so support table is always current
    actionList.PetManagement = br.loader.rotations.support["PetTBC"].run

    -- Units
    units.get(5)         -- units.dyn5  (melee range)
    units.get(40)        -- units.dyn40 (ranged)
    units.get(40, true)  -- units.dyn40AOE

    -- Enemies
    enemies.get(5)   -- enemies.yards5   (melee/trap)
    enemies.get(8)   -- enemies.yards8   (melee AoE / Explosive Trap range)
    enemies.get(30)  -- enemies.yards30  (Growl range)
    enemies.get(40)  -- enemies.yards40  (Multi-Shot / Volley / CC)

    -- Reset profile stop when out of combat with no target
    if not unit.inCombat() and not unit.exists("target") then
        if profileStop then profileStop = false end
    end

    -- Track movement transitions every frame, before the halt check.
    -- unit.movingTime() only resets when called, so if action lists are skipped
    -- (halted, paused, or between pulls) the timer freezes and Travel Delay fires
    -- instantly when the player next moves. var.moveStart records the exact moment
    -- movement begins and is cleared the moment it stops, giving a clean elapsed time.
    local isMovingNow = unit.moving()
    if isMovingNow and not var.wasMoving then
        var.moveStart = ui.time()
    elseif not isMovingNow then
        var.moveStart = nil
    end
    var.wasMoving = isMovingNow

    ---------------------
    --- Begin Profile ---
    ---------------------
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        return true
    else
        -----------------------
        --- Aspects          ---
        -----------------------
        if actionList.Aspects() then return true end

        -----------------------
        --- Extras           ---
        -----------------------
        if actionList.Extra() then return true end

        -----------------
        --- Defensive  ---
        -----------------
        if actionList.Defensive() then return true end

        -------------------------
        --- Pet Management    ---
        -------------------------
        if actionList.PetManagement() then return true end

        -----------------------
        --- Cooldowns        ---
        -----------------------
        if actionList.Cooldowns() then return true end

        ------------------
        --- Pre-Combat  ---
        ------------------
        if actionList.PreCombat() then return true end

        ----------------------------
        --- Interrupts / CC      ---
        ----------------------------
        if actionList.Interrupts() then return true end

        -----------------
        --- Combat      ---
        -----------------
        if actionList.Combat() then return true end
    end

    return true
end

local id = 361 -- TBC/Classic Hunter spec ID (same class-level ID as Classic; hasSubSpecs = false)
br.loader.rotations[id] = br.loader.rotations[id] or {}
if br.api.expansion == "TBC" then
    br._G.tinsert(br.loader.rotations[id], {
        name    = rotationName,
        toggles = createToggles,
        options = createOptions,
        run     = runRotation,
    })
end
