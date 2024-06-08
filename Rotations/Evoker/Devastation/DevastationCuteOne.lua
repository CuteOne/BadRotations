-------------------------------------------------------
-- Author = CuteOne
-- Patch = 10.0
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 95%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Full
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Basic
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "CuteOne" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------

local function createToggles() -- Define custom toggles
    -- Rotation Button
    local RotationModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Automatic Rotation",
            tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.",
            highlight = 1,
            icon = br.player.spells.disintegrate
        },
        [2] = {
            mode = "Mult",
            value = 2,
            overlay = "Multiple Target Rotation",
            tip = "Multiple target rotation used.",
            highlight = 1,
            icon = br.player.spells.azureStrike
        },
        [3] = {
            mode = "Sing",
            value = 3,
            overlay = "Single Target Rotation",
            tip = "Single target rotation used.",
            highlight = 1,
            icon = br.player.spells.livingFlame
        },
        [4] = {
            mode = "Off",
            value = 4,
            overlay = "DPS Rotation Disabled",
            tip = "Disable DPS Rotation",
            highlight = 0,
            icon = br.player.spells.blessingOfTheBronze
        }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Cooldowns Automated",
            tip = "Automatic Cooldowns - Boss Detection.",
            highlight = 1,
            icon = br.player.spells.furyOfTheAspects
        },
        [2] = {
            mode = "On",
            value = 2,
            overlay = "Cooldowns Enabled",
            tip = "Cooldowns used regardless of target.",
            highlight = 0,
            icon = br.player.spells.furyOfTheAspects
        },
        [3] = {
            mode = "Off",
            value = 3,
            overlay = "Cooldowns Disabled",
            tip = "No Cooldowns will be used.",
            highlight = 0,
            icon = br.player.spells.furyOfTheAspects
        }
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Defensive Enabled",
            tip = "Includes Defensive Cooldowns.",
            highlight = 1,
            icon = br.player.spells.livingFlame
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Defensive Disabled",
            tip = "No Defensives will be used.",
            highlight = 0,
            icon = br.player.spells.livingFlame
        }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Interrupts Enabled",
            tip = "Includes Basic Interrupts.",
            highlight = 1,
            icon = br.player.spells.tailSwipe
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Interrupts Disabled",
            tip = "No Interrupts will be used.",
            highlight = 0,
            icon = br.player.spells.tailSwipe
        }
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        local alwaysCdNever = { "Always", "|cff0000ffCD", "|cffff0000Never" }
        local alwaysCdAoENever = { "Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never" }
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5,
            "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Blessing of the Bronze
        br.ui:createCheckbox(section, "Blessing of the Bronze")
        -- Source of Magic
        br.ui:createCheckbox(section, "Source of Magic on Focus", "|cffFFFFFFWill cast Source of Magic Ability on Focus.")
        -- Stage Limiter
        br.ui:createCheckbox(section, "Empower Stage Limiter", "|cffFFFFFFEnable to set maximum stages to Empower to.")
        br.ui:createSpinnerWithout(section, "Fire Breath Stage Limit", 4, 1, 4, 1, "")
        br.ui:createSpinnerWithout(section, "Eternity Surge Stage Limit", 4, 1, 4, 1, "")
        -- Visage
        br.ui:createCheckbox(section, "Maintain Visage", "|cffFFFFFFWill use Visage Ability whenever possible.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Eternity Surge
        br.ui:createDropdownWithout(section, "Eternity Surge", alwaysCdAoENever, 1,
            "|cffFFFFFFWhen to use Eternity Surge.")
        -- Deep Breath
        br.ui:createDropdownWithout(section, "Deep Breath", alwaysCdAoENever, 3,
            "|cffFFFFFFWhen to use Deep Breath Ability.")
        -- Dragonrage
        br.ui:createDropdownWithout(section, "Dragonrage", alwaysCdAoENever, 3,
            "|cffFFFFFFWhen to use Dragonrage Ability.")
        -- Flame Breath
        br.ui:createDropdownWithout(section, "Fire Breath", alwaysCdAoENever, 1, "|cffFFFFFFWhen to use Fire Breath.")
        -- Tip the Scales
        br.ui:createDropdownWithout(section, "Tip the Scales", alwaysCdAoENever, 3,
            "|cffFFFFFFWhen to use Tip the Scales Ability.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Cauterizing Flame
        br.ui:createCheckbox(section, "Cauterizing Flame")
        br.ui:createDropdownWithout(section, "Cauterizing Flame - Target",
            { "|cff00FF00Player", "|cffFFFF00Target", "|cffFF0000Mouseover" }, 1, "|cffFFFFFFTarget to cast on")
        -- Emerald Blossom
        br.ui:createSpinner(section, "Emerald Blossom", 35, 0, 99, 5, "Use Emerald Blossom to Heal below this threshold")
        -- Expunge
        br.ui:createCheckbox(section, "Expunge")
        br.ui:createDropdownWithout(section, "Expunge - Target",
            { "|cff00FF00Player", "|cffFFFF00Target", "|cffFF0000Mouseover" }, 1, "|cffFFFFFFTarget to cast on")
        -- Living Flame
        br.ui:createSpinner(section, "Living Flame Heal", 45, 0, 99, 5, "Use Living Flame to Heal below this threshold")
        br.ui:createSpinnerWithout(section, "Living Flame OoC", 80, 0, 99, 5,
            "Use Living Flame to Heal Out of Combat below this threshold")
        -- Obsidian Scales
        br.ui:createSpinner(section, "Obsidian Scales", 50, 0, 99, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Renewing Blaze
        br.ui:createSpinner(section, "Renewing Blaze", 40, 0, 99, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Return
        br.ui:createCheckbox(section, "Return")
        br.ui:createDropdownWithout(section, "Return - Target", { "|cff00FF00Target", "|cffFF0000Mouseover" }, 1,
            "|cffFFFFFFTarget to cast on")
        -- Verdant Embrace
        br.ui:createSpinner(section, "Verdant Embrace", 55, 0, 99, 5, "Use Verdant Embrace to Heal below this threshold")
        -- Wing Buffet
        br.ui:createSpinner(section, "Wing Buffet - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Wing Buffet - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Quell
        br.ui:createCheckbox(section, "Quell")
        -- Tail Swipe
        br.ui:createCheckbox(section, "Tail Swipe")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "InterruptAt", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        -- Cooldown Key Toggle
        br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
        -- Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end
    optionTable = { {
        [1] = "Rotation Options",
        [2] = rotationOptions
    } }
    return optionTable
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local cast
local cd
local debuff
local enemies
local essence
local equiped
local spell
local talent
local ui
local unit
local units
local use
local var
-- General Locals - Common Non-BR API Locals used in profiles

-- Profile Specific Locals - Any custom to profile locals
local actionList = {}
local custom = {}
-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
custom.stageLimit = function(empowerSpell, requestedStage)
    if ui.checked("Empower Stage Limiter") then
        if empowerSpell == "FB" then return ui.value("Fire Breath Stage Limit") end
        if empowerSpell == "ES" then return ui.value("Eternity Surge Stage Limit") end
    end
    return requestedStage
end


custom.getDeepBreathLocation = function(minUnits)
    for i = 21, 50 do
        local enemies = #br.player.enemies.rect.get(6, i, false)
        if enemies >= minUnits then
            local playerX, playerY, playerZ = br.GetObjectPosition("player")
            local playerFacing = br.GetObjectFacing("player")
            local x = playerX + (i * math.cos(playerFacing))
            local y = playerY + (i * math.sin(playerFacing))
            return x, y, playerZ
        end
    end
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing")) * 60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test-- Dummy DPS Test
    -- Blessing of the Bronze
    if ui.checked("Blessing of the Bronze") and cast.able.blessingOfTheBronze("player") then
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            if not unit.deadOrGhost(thisUnit) and unit.distance(thisUnit) < 40 and buff.blessingOfTheBronze.remain(thisUnit) < 600 then
                if cast.blessingOfTheBronze("player") then
                    ui.debug("Casting Blessing of the Bronze")
                    return true
                end
            end
        end
    end
    -- Source of Magic
    if ui.checked("Source of Magic on Focus") and cast.able.sourceOfMagic("focus")
        and unit.exists("focus") and unit.friend("focus") and not buff.sourceOfMagic.exists("focus")
    then
        if cast.sourceOfMagic("focus") then
            ui.debug("Casting Source of Magic on " .. tostring(unit.name("focus")))
            return true
        end
    end
    -- Visage
    if ui.checked("Maintain Visage") and cast.able.visage() and not unit.inCombat() and spell.choosenIdentity.texture() ~= 136116
        and not buff.visageForm.exists() and not buff.visage.exists() and not buff.soar.exists() and not buff.hover.exists()
    then
        if cast.visage() then
            ui.debug("Casting Visage - Surely noone will tell you're a Dractyr.")
            return true
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() and not unit.mounted() then
        local opValue
        local thisUnit
        -- Cauterizing Flame
        if ui.checked("Cauterizing Flame") then
            opValue = ui.value("Cauterizing Flame - Target")
            if opValue == 1 then
                thisUnit = "player"
            elseif opValue == 2 then
                thisUnit = "target"
            elseif opValue == 3 then
                thisUnit = "mouseover"
            end
            if cast.able.cauterizingFlame(thisUnit) and (unit.friend(thisUnit) or unit.player(thisUnit))
                and cast.dispel.cauterizingFlame(thisUnit)
            then
                if cast.cauterizingFlame(thisUnit) then
                    ui.debug("Casting Cauterizing Flame on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
        -- Emerald Blossom
        if ui.checked("Emerald Blossom") and cast.able.emeraldBlossom("player") and unit.hp() <= ui.value("Emerald Blossom") then
            if cast.emeraldBlossom("player") then
                ui.debug("Casting Emerald Blossom")
                return true
            end
        end
        -- Expunge
        if ui.checked("Expunge") then
            opValue = ui.value("Expunge - Target")
            if opValue == 1 then
                thisUnit = "player"
            elseif opValue == 2 then
                thisUnit = "target"
            elseif opValue == 3 then
                thisUnit = "mouseover"
            end
            if cast.able.expunge(thisUnit) and (unit.friend(thisUnit) or unit.player(thisUnit))
                and cast.dispel.expunge(thisUnit)
            then
                if cast.expunge(thisUnit) then
                    ui.debug("Casting Expunge on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
        -- Living Flame
        if ui.checked("Living Flame Heal") and var.moveCast then
            thisUnit = unit.friend("target") and "target" or "player"
            if cast.able.livingFlame(thisUnit) and unit.hp(thisUnit) <= ui.value("Living Flame Heal")
                and cast.timeSinceLast.livingFlame() > cast.time.livingFlame() + unit.gcd(true)
            then
                if cast.livingFlame(thisUnit) then
                    ui.debug("Casting Living Flame on " .. unit.name(thisUnit))
                    return true
                end
            end
            if cast.able.livingFlame("player") and not unit.inCombat() and unit.hp() <= ui.value("Living Flame OoC") then
                if cast.livingFlame("player") then
                    ui.debug("Casting Living Flame [OoC]")
                    return true
                end
            end
        end
        -- Obsidian Scales
        if ui.checked("Obsidian Scales") and cast.able.obsidianScales("player") and unit.hp() <= ui.value("Obsidian Scales") then
            if cast.obsidianScales("player") then
                ui.debug("Casting Obsidian Scales")
                return true
            end
        end
        -- Renewing Blaze
        if ui.checked("Renewing Blaze") and cast.able.renewingBlaze("player") and unit.hp() <= ui.value("Renewing Blaze") then
            if cast.renewingBlaze("player") then
                ui.debug("Casting Renewing Blaze")
                return true
            end
        end
        -- Return
        if ui.checked("Return") and not unit.inCombat() and not unit.moving() then
            opValue = ui.value("Return - Target")
            if opValue == 1 then
                thisUnit = "target"
            elseif opValue == 2 then
                thisUnit = "mouseover"
            end
            if cast.able.returnEvoker(thisUnit, "dead") and unit.deadOrGhost(thisUnit)
                and (unit.friend(thisUnit) and unit.player(thisUnit))
            then
                if cast.returnEvoker(thisUnit, "dead") then
                    ui.debug("Casting Return on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
        -- Verdant Embrace
        if ui.checked("Verdant Embrace") then
            thisUnit = unit.friend("target") and "target" or "player"
            if cast.able.verdantEmbrace(thisUnit) and unit.hp(thisUnit) <= ui.value("Verdant Embrace") then
                if cast.verdantEmbrace(thisUnit) then
                    ui.debug("Casting Verdant Embrace on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
        -- Wing Buffet
        if ui.checked("Wing Buffet - HP") and unit.hp() <= ui.value("Wing Buffet - HP")
            and cast.able.wingBuffet() and unit.inCombat() and #enemies.yards15f > 0
        then
            if cast.wingBuffet() then
                ui.debug("Casting Wing Buffet [HP]")
                return true
            end
        end
        if ui.checked("Wing Buffet - AoE") and #enemies.yards15f >= ui.value("Wing Buffet - AoE")
            and cast.able.wingBuffet()
        then
            if cast.wingBuffet() then
                ui.debug("Casting Wing Buffet [AOE]")
                return true
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        local thisUnit
        -- Quell
        if ui.checked("Quell") then
            for i = 1, #enemies.yards25 do
                thisUnit = enemies.yards25[i]
                if cast.able.quell(thisUnit) and unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    if cast.quell(thisUnit) then
                        ui.debug("Casting Quell on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
        end
        -- Tail Swipe
        if ui.checked("Tail Swipe") then
            for i = 1, #enemies.yards8 do
                thisUnit = enemies.yards8[i]
                if cast.able.tailSwipe(thisUnit) and unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    if cast.tailSwipe(thisUnit) then
                        ui.debug("Casting Tail Swipe on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
        end
    end -- End useInterrupts check
end     -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- Remix - Oblivion Sphere
    if ui.useCDs() and cast.able.id(435313, "target", "ground", 1, 15) and not unit.moving("target") then
        if cast.id(435313, "target", "ground", 1, 15) then
            ui.debug("Casting Oblivion Sphere [Cds]")
            return true
        end
    end
end -- End Action List - Cooldowns

-- Action List - AOE
actionList.AoE = function()
    -- Shattering Star
    -- shattering_star,target_if=max:target.health.pct,if=cooldown.dragonrage.up
    if cast.able.shatteringStar(var.maxHpUnit) and not cd.dragonrage.exists() and var.moveCast then
        if cast.shatteringStar(var.maxHpUnit) then
            ui.debug("Casting Shattering Star [Aoe]")
            return true
        end
    end
    -- Firestorm
    -- firestorm,if=talent.raging_inferno&cooldown.dragonrage.remains<=gcd&(target.time_to_die>=32|fight_remains<30)
    if cast.able.firestorm("target", "ground", 1, 8) and ((talent.ragingInferno and cd.dragonrage.remains() <= unit.gcd(true)
            and (unit.ttd(units.dyn25) >= 32 or unit.ttdGroup(40) < 30)))
    then
        if cast.firestorm("target", "ground", 1, 8) then
            ui.debug("Casting Firestorm - Raging Inferno [Aoe]")
            return true
        end
    end
    -- Dragonrage
    -- dragonrage,if=target.time_to_die>=32|fight_remains<30
    if ui.alwaysCdAoENever("Dragonrage", 3, 25) and cast.able.dragonrage() and ((unit.ttd(units.dyn25) >= 32 or unit.ttdGroup(40) < 30)) then
        if cast.dragonrage() then
            ui.debug("Casting Dragonrage [Aoe]")
            return true
        end
    end
    -- Tip The Scales
    -- tip_the_scales,if=buff.dragonrage.up&(active_enemies<=3+3*talent.eternitys_span|!cooldown.fire_breath.up)
    if ui.alwaysCdAoENever("Tip the Scales", 3, 25) and cast.able.tipTheScales("player") and ((buff.dragonrage.exists()
            and (#enemies.yards25f <= 3 + 3 * var.eternitysSpan or cd.fireBreath.exists())))
    then
        if cast.tipTheScales("player") then
            ui.debug("Casting Tip The Scales [Aoe]")
            return true
        end
    end
    -- Call Action List - Fb
    -- call_action_list,name=fb,if=(!talent.dragonrage|variable.next_dragonrage>variable.dr_prep_time_aoe|!talent.animosity)&((buff.power_swell.remains<variable.r1_cast_time|(!talent.volatility&active_enemies=3))&buff.blazing_shards.remains<variable.r1_cast_time|buff.dragonrage.up)&(target.time_to_die>=8|fight_remains<30)
    if ui.alwaysCdAoENever("Fire Breath", 3, #enemies.yards25f) and not unit.moving()
        and ((not talent.dragonrage or var.nextDragonrage > var.drPrepTimeAoe or not talent.animosity)
            and ((buff.powerSwell.remains() < var.r1CastTime or (not talent.volatility and #enemies.yards25 == 3))
                and buff.blazingShards.remains() < var.r1CastTime or buff.dragonrage.exists())
            and (unit.ttd(units.dyn25) >= 8 or unit.ttdGroup(40) < 30 or unit.isDummy("target")))
    then
        if actionList.Fb() then return true end
    end
    -- Call Action List - Es
    -- call_action_list,name=es,if=buff.dragonrage.up|!talent.dragonrage|(cooldown.dragonrage.remains>variable.dr_prep_time_aoe&(buff.power_swell.remains<variable.r1_cast_time|(!talent.volatility&active_enemies=3))&buff.blazing_shards.remains<variable.r1_cast_time)&(target.time_to_die>=8|fight_remains<30)
    if ui.alwaysCdAoENever("Eternity Surge", 2, #enemies.yards25f)
        and (buff.dragonrage.exists() or not talent.dragonrage or (cd.dragonrage.remains() > var.drPrepTimeAoe
            and (buff.powerSwell.remains() < var.r1CastTime or (not talent.volatility and #enemies.yards25f == 3))
            and buff.blazingShards.remains() < var.r1CastTime) and (unit.ttd(units.dyn25) >= 8 or unit.ttdGroup(40) < 30 or unit.isDummy("target")))
    then
        if actionList.Es() then return true end
    end
    -- Deep Breath
    -- deep_breath,if=!buff.dragonrage.up&essence.deficit>3
    if ui.alwaysCdAoENever("Deep Breath", 3, #enemies.yards50r) and cast.able.deepBreath("groundLocation", var.deepBreathX, var.deepBreathY, 6)
        and #enemies.yards50r > 0 and not buff.dragonrage.exists() and essence.deficit() > 3 then
        if cast.deepBreath("groundLocation", var.deepBreathX, var.deepBreathY, 6) then
            ui.debug("Casting Deep Breath [Aoe]")
            return true
        end
    end
    -- Shattering Star
    -- shattering_star,target_if=max:target.health.pct,if=buff.essence_burst.stack<buff.essence_burst.max_stack|!talent.arcane_vigor
    if cast.able.shatteringStar(var.maxHpUnit) and ((buff.essenceBurst.stack() < var.essenceBurstMaxStacks or not talent.arcaneVigor)) then
        if cast.shatteringStar(var.maxHpUnit) then
            ui.debug("Casting Shattering Star - Low Essence Burst [Aoe]")
            return true
        end
    end
    -- Firestorm
    -- firestorm,if=talent.raging_inferno&(cooldown.dragonrage.remains>=20|cooldown.dragonrage.remains<=10)&(buff.essence_burst.up|essence>=2|cooldown.dragonrage.remains<=10)|buff.snapfire.up
    if cast.able.firestorm("target", "ground", 3, 8) and ((talent.ragingInferno and (cd.dragonrage.remains() >= 20 or cd.dragonrage.remains() <= 10)
            and (buff.essenceBurst.exists() or essence() >= 2 or cd.dragonrage.remains() <= 10) or buff.snapfire.exists()))
    then
        if cast.firestorm("target", "ground", 3, 8) then
            ui.debug("Casting Firestorm [Aoe]")
            return true
        end
    end
    -- Pyre
    -- pyre,target_if=max:target.health.pct,if=active_enemies>=4
    if cast.able.pyre(var.maxHpUnit, "aoe", 4, 8) then
        if cast.pyre(var.maxHpUnit, "aoe", 4, 8) then
            ui.debug("Casting Pyre - 4+ [Aoe]")
            return true
        end
    end
    -- Pyre
    -- pyre,target_if=max:target.health.pct,if=active_enemies>=3&talent.volatility
    if cast.able.pyre(var.maxHpUnit, "aoe", 3, 8) and talent.volatility then
        if cast.pyre(var.maxHpUnit, "aoe", 3, 8) then
            ui.debug("Casting Pyre - 3+ [Aoe]")
            return true
        end
    end
    -- Pyre
    -- pyre,target_if=max:target.health.pct,if=buff.charged_blast.stack>=15
    if cast.able.pyre(var.maxHpUnit, "aoe", 1, 8) and buff.chargedBlast.stack() >= 15 then
        if cast.pyre(var.maxHpUnit, "aoe", 1, 8) then
            ui.debug("Casting Pyre [Aoe]")
            return true
        end
    end
    -- Living Flame
    -- living_flame,target_if=max:target.health.pct,if=(!talent.burnout|buff.burnout.up|active_enemies>=4&cooldown.fire_breath.remains<=gcd.max*3|buff.scarlet_adaptation.up)&buff.leaping_flames.up&!buff.essence_burst.up&essence<essence.max-1
    if cast.able.livingFlame(var.maxHpUnit) and (((not talent.burnout or buff.burnout.exists() or #enemies.yards25 >= 4
                and cd.fireBreath.remains() <= unit.gcd(true) * 3 or buff.scarletAdaptation.exists()) and buff.leapingFlames.exists()
            and not buff.essenceBurst.exists() and essence() < essence.max() - 1))
    then
        if cast.livingFlame(var.maxHpUnit) then
            ui.debug("Casting Living Flame [Aoe]")
            return true
        end
    end
    -- Disintegrate
    -- disintegrate,target_if=max:target.health.pct,chain=1,early_chain_if=evoker.use_early_chaining&ticks>=2&buff.dragonrage.up&(raid_event.movement.in>2|buff.hover.up),interrupt_if=evoker.use_clipping&buff.dragonrage.up&ticks>=2&(raid_event.movement.in>2|buff.hover.up),if=raid_event.movement.in>2|buff.hover.up
    if cast.able.disintegrate(var.maxHpUnit) and var.moveCast then
        if cast.disintegrate(var.maxHpUnit) then
            ui.debug("Casting Disintegrate [Aoe]")
            return true
        end
    end
    -- Living Flame
    -- living_flame,target_if=max:target.health.pct,if=talent.snapfire&buff.burnout.up
    if cast.able.livingFlame(var.maxHpUnit) and talent.snapfire and buff.burnout.exists() then
        if cast.livingFlame(var.maxHpUnit) then
            ui.debug("Casting Living Flame [Aoe]")
            return true
        end
    end
    -- Firestorm
    -- firestorm
    if cast.able.firestorm("target", "ground", 3, 8) then
        if cast.firestorm("target", "ground", 3, 8) then
            ui.debug("Casting Firestorm [Aoe]")
            return true
        end
    end
    -- Call Action List - Green
    -- call_action_list,name=green,if=talent.ancient_flame&!buff.ancient_flame.up&!buff.dragonrage.up
    if talent.ancientFlame and not buff.ancientFlame.exists() and not buff.dragonrage.exists() then
        if actionList.Green() then return true end
    end
    -- Azure Strike
    -- azure_strike,target_if=max:target.health.pct
    if cast.able.azureStrike(var.maxHpUnit) then
        if cast.azureStrike(var.maxHpUnit) then
            ui.debug("Casting Azure Strike [Aoe]")
            return true
        end
    end
end -- End Action List - AOE

-- Action List - ES
actionList.Es = function()
    -- Eternity Surge
    if cast.able.eternitySurge(var.maxHpUnit, "aoe", 1, 12) and not unit.moving() and not cast.current.eternitySurge() then
        -- eternity_surge,empower_to=1,target_if=max:target.health.pct,if=active_enemies<=1+talent.eternitys_span|buff.dragonrage.remains<1.75*spell_haste&buff.dragonrage.remains>=1*spell_haste|buff.dragonrage.up&(active_enemies==5&!talent.font_of_magic|active_enemies>(3+talent.font_of_magic)*(1+talent.eternitys_span))|active_enemies>=6&!talent.eternitys_span
        if ((#enemies.yards8t <= 1 + var.eternitysSpan or buff.dragonrage.remains() < 1.75 * var.spellHaste
                and buff.dragonrage.remains() >= 1 * var.spellHaste or buff.dragonrage.exists()
                and (#enemies.yards8t == 5 and not talent.fontOfMagic or #enemies.yards8t > (3 + talent.fontOfMagic) * (1 + talent.eternitysSpan)) or #enemies.yards8t >= 6
                and not talent.eternitysSpan))
        then
            if cast.eternitySurge(var.maxHpUnit, "aoe", 1, 12) then
                var.stageEternitySurge = custom.stageLimit("ES", 1)
                ui.debug("Empowering Eternity Surge to Stage " .. var.stageEternitySurge .. " [ES]")
                return true
            end
        end
        -- eternity_surge,empower_to=2,target_if=max:target.health.pct,if=active_enemies<=2+2*talent.eternitys_span|buff.dragonrage.remains<2.5*spell_haste&buff.dragonrage.remains>=1.75*spell_haste
        if ((#enemies.yards8t <= 2 + 2 * var.eternitysSpan or buff.dragonrage.remains() < 2.5 * var.spellHaste and buff.dragonrage.remains() >= 1.75 * var.spellHaste)) then
            if cast.eternitySurge(var.maxHpUnit, "aoe", 1, 12) then
                var.stageEternitySurge = custom.stageLimit("ES", 2)
                ui.debug("Empowering Eternity Surge to Stage " .. var.stageEternitySurge .. " [ES]")
                return true
            end
        end
        -- eternity_surge,empower_to=3,target_if=max:target.health.pct,if=active_enemies<=3+3*talent.eternitys_span|!talent.font_of_magic|buff.dragonrage.remains<=3.25*spell_haste&buff.dragonrage.remains>=2.5*spell_haste
        if ((#enemies.yards8t <= 3 + 3 * var.eternitysSpan or not talent.fontOfMagic or buff.dragonrage.remains() <= 3.25 * var.spellHaste
                and buff.dragonrage.remains() >= 2.5 * var.spellHaste))
        then
            if cast.eternitySurge(var.maxHpUnit, "aoe", 1, 12) then
                var.stageEternitySurge = custom.stageLimit("ES", 3)
                ui.debug("Empowering Eternity Surge to Stage " .. var.stageEternitySurge .. " [ES]")
                return true
            end
        end
        -- eternity_surge,empower_to=4,target_if=max:target.health.pct
        if cast.eternitySurge(var.maxHpUnit, "aoe", 1, 12) then
            var.stageEternitySurge = custom.stageLimit("ES", 4)
            ui.debug("Empowering Eternity Surge to Stage " .. var.stageEternitySurge .. " [ES]")
            return true
        end
    end
end -- End Action List - ES

-- Action List - FB
actionList.Fb = function()
    -- Fire Breath
    if cast.able.fireBreath("player", "cone", 1, 25) and not cast.current.fireBreath() then
        -- fire_breath,empower_to=1,target_if=max:target.health.pct,if=(buff.dragonrage.up&active_enemies<=2)|(active_enemies=1&!talent.everburning_flame)|(buff.dragonrage.remains<1.75*spell_haste&buff.dragonrage.remains>=1*spell_haste)
        if (((buff.dragonrage.exists() and #enemies.yards25f <= 2) or (#enemies.yards25f == 1 and not talent.everburningFlame)
                or (buff.dragonrage.remains() < 1.75 * var.spellHaste and buff.dragonrage.remains() >= 1 * var.spellHaste)))
        then
            if cast.fireBreath("player", "cone", 1, 25) then
                var.stageFireBreath = custom.stageLimit("FB", 1)
                ui.debug("Empowering Fire Breath to Stage " .. var.stageFireBreath .. " [FB]")
                return true
            end
        end
        -- fire_breath,empower_to=2,target_if=max:target.health.pct,if=(!debuff.in_firestorm.up&talent.everburning_flame&active_enemies<=3)|(active_enemies=2&!talent.everburning_flame)|(buff.dragonrage.remains<2.5*spell_haste&buff.dragonrage.remains>=1.75*spell_haste)
        if ((( --[[not debuff.inFirestorm.exists(units.dyn25) and]] talent.everburningFlame and #enemies.yards25f <= 3) or (#enemies.yards25f == 2
                and not talent.everburningFlame) or (buff.dragonrage.remains() < 2.5 * var.spellHaste
                and buff.dragonrage.remains() >= 1.75 * var.spellHaste)))
        then
            if cast.fireBreath("player", "cone", 1, 25) then
                var.stageFireBreath = custom.stageLimit("FB", 2)
                ui.debug("Empowering Fire Breath to Stage " .. var.stageFireBreath .. " [FB]")
                return true
            end
        end
        -- fire_breath,empower_to=3,target_if=max:target.health.pct,if=(talent.everburning_flame&buff.dragonrage.up&active_enemies>=5)|!talent.font_of_magic|(debuff.in_firestorm.up&talent.everburning_flame&active_enemies<=3)|(buff.dragonrage.remains<=3.25*spell_haste&buff.dragonrage.remains>=2.5*spell_haste)
        if (((talent.everburningFlame and buff.dragonrage.exists() and #enemies.yards25f >= 5) or not talent.fontOfMagic
                or (debuff.inFirestorm.exists(units.dyn25) and talent.everburningFlame and #enemies.yards25f <= 3)
                or (buff.dragonrage.remains() <= 3.25 * var.spellHaste and buff.dragonrage.remains() >= 2.5 * var.spellHaste)))
        then
            if cast.fireBreath("player", "cone", 1, 25) then
                var.stageFireBreath = custom.stageLimit("FB", 3)
                ui.debug("Empowering Fire Breath to Stage " .. var.stageFireBreath .. " [FB]")
                return true
            end
        end
        -- fire_breath,empower_to=4,target_if=max:target.health.pct
        if cast.fireBreath("player", "cone", 1, 25) then
            var.stageFireBreath = custom.stageLimit("FB", 4)
            ui.debug("Empowering Fire Breath to Stage " .. var.stageFireBreath .. " [FB]")
            return true
        end
    end
end -- End Action List - FB

-- Action List - Green
actionList.Green = function()
    -- Emerald Blossom
    -- emerald_blossom
    if cast.able.emeraldBlossom("player") then
        if cast.emeraldBlossom("player") then
            ui.debug("Casting Emerald Blossom [Green]")
            return true
        end
    end
    -- Verdant Embrace
    -- verdant_embrace
    if cast.able.verdantEmbrace("player") then
        if cast.verdantEmbrace("player") then
            ui.debug("Casting Verdant Embrace [Green]")
            return true
        end
    end
end -- End Action List - Green

-- Action List - Trinkets
actionList.Trinkets = function()
    -- -- Use Item - Dreambinder Loom Of The Great Cycle,Use Off Gcd=1
    -- -- use_item,name=dreambinder_loom_of_the_great_cycle,use_off_gcd=1,if=gcd.remains>0.5
    -- if use.able.dreambinderLoomOfTheGreatCycle() and cd.dreambinderLoomOfTheGreatCycle.remains()>0.5 then
    --     if use.dreambinderLoomOfTheGreatCycle() then ui.debug("Using Dreambinder Loom Of The Great Cycle [Trinkets]") return true end
    -- end

    -- -- Use Item - Target If=Min:Target.Health.Pct,Iridal The Earths Master,Use Off Gcd=1
    -- -- use_item,target_if=min:target.health.pct,name=iridal_the_earths_master,use_off_gcd=1,if=gcd.remains>0.5
    -- -- TODO: The following conditions were not converted:
    -- -- target.health.pct
    -- -- Use Item - Target If=Min:Target.Health.Pct,Iridal The Earths Master,Use Off Gcd=1
    -- -- use_item,target_if=min:target.health.pct,name=iridal_the_earths_master,use_off_gcd=1,if=gcd.remains>0.5
    -- -- TODO: The following conditions were not converted:
    -- -- target.health.pct
    -- if use.able.targetIf=Min:Target.Health.Pct() and cd.targetIf==Min:Target.Health.Pct.remains()>0.5 then
    --     if use.targetIf=Min:Target.Health.Pct() then ui.debug("Using Target If=Min:Target.Health.Pct [Trinkets]") return true end
    -- end

    -- -- Use Item - Slot1
    -- -- use_item,slot=trinket1,if=buff.dragonrage.up&((buff.emerald_trance_stacking.stack>=4&set_bonus.tier31_2pc)|(variable.trinket_2_buffs&!cooldown.fire_breath.up&!cooldown.shattering_star.up&!equipped.nymues_unraveling_spindle&trinket.2.cooldown.remains)|(!cooldown.fire_breath.up&!cooldown.shattering_star.up&!set_bonus.tier31_2pc)|active_enemies>=3)&(!trinket.2.has_cooldown|trinket.2.cooldown.remains|variable.trinket_priority=1|variable.trinket_2_exclude)&!variable.trinket_1_manual|trinket.1.proc.any_dps.duration>=fight_remains|trinket.1.cooldown.duration<=60&(variable.next_dragonrage>20|!talent.dragonrage)&(!buff.dragonrage.up|variable.trinket_priority=1)
    -- -- TODO: The following conditions were not converted:
    -- -- trinket.2.has_cooldown
    -- -- trinket.1.proc.any_dps.duration
    -- if use.able.slot1() and ((buff.dragonrage.exists() and ((buff.emeraldTranceStacking.stack()>=4 and equiped.tier(31)>=2) or (var.trinket2Buffs and cd.fireBreath.exists() and cd.shatteringStar.exists() and not equiped.nymuesUnravelingSpindle() and cd.slot.remains(14)) or (cd.fireBreath.exists() and cd.shatteringStar.exists() and not equiped.tier(31)>=2) or #enemies.yards0>=3) and (not  or cd.slot.remains(14) or var.trinketPriority==1 or var.trinket2Exclude) and not var.trinket1Manual or >=unit.ttdGroup(40) or cd.slot.duration()<=60 and (var.nextDragonrage>20 or not talent.dragonrage) and (not buff.dragonrage.exists() or var.trinketPriority==1))) then
    --     if use.slot1() then ui.debug("Using Slot1 [Trinkets]") return true end
    -- end

    -- -- Use Item - Slot2
    -- -- use_item,slot=trinket2,if=buff.dragonrage.up&((buff.emerald_trance_stacking.stack>=4&set_bonus.tier31_2pc)|(variable.trinket_1_buffs&!cooldown.fire_breath.up&!cooldown.shattering_star.up&!equipped.nymues_unraveling_spindle&trinket.1.cooldown.remains)|(!cooldown.fire_breath.up&!cooldown.shattering_star.up&!set_bonus.tier31_2pc)|active_enemies>=3)&(!trinket.1.has_cooldown|trinket.1.cooldown.remains|variable.trinket_priority=2|variable.trinket_1_exclude)&!variable.trinket_2_manual|trinket.2.proc.any_dps.duration>=fight_remains|trinket.2.cooldown.duration<=60&(variable.next_dragonrage>20|!talent.dragonrage)&(!buff.dragonrage.up|variable.trinket_priority=2)
    -- -- TODO: The following conditions were not converted:
    -- -- trinket.1.has_cooldown
    -- -- trinket.2.proc.any_dps.duration
    -- if use.able.slot2() and ((buff.dragonrage.exists() and ((buff.emeraldTranceStacking.stack()>=4 and equiped.tier(31)>=2) or (var.trinket1Buffs and cd.fireBreath.exists() and cd.shatteringStar.exists() and not equiped.nymuesUnravelingSpindle() and cd.slot.remains(13)) or (cd.fireBreath.exists() and cd.shatteringStar.exists() and not equiped.tier(31)>=2) or #enemies.yards0>=3) and (not  or cd.slot.remains(13) or var.trinketPriority==2 or var.trinket1Exclude) and not var.trinket2Manual or >=unit.ttdGroup(40) or cd.slot.duration()<=60 and (var.nextDragonrage>20 or not talent.dragonrage) and (not buff.dragonrage.exists() or var.trinketPriority==2))) then
    --     if use.slot2() then ui.debug("Using Slot2 [Trinkets]") return true end
    -- end

    -- -- Use Item - Slot1
    -- -- use_item,slot=trinket1,if=!variable.trinket_1_buffs&(trinket.2.cooldown.remains|!variable.trinket_2_buffs)&(variable.next_dragonrage>20|!talent.dragonrage)&!variable.trinket_1_manual
    -- if use.able.slot1() and ((not var.trinket1Buffs and (cd.slot.remains(14) or not var.trinket2Buffs) and (var.nextDragonrage>20 or not talent.dragonrage) and not var.trinket1Manual)) then
    --     if use.slot1() then ui.debug("Using Slot1 [Trinkets]") return true end
    -- end

    -- -- Use Item - Slot2
    -- -- use_item,slot=trinket2,if=!variable.trinket_2_buffs&(trinket.1.cooldown.remains|!variable.trinket_1_buffs)&(variable.next_dragonrage>20|!talent.dragonrage)&!variable.trinket_2_manual
    -- if use.able.slot2() and ((not var.trinket2Buffs and (cd.slot.remains(13) or not var.trinket1Buffs) and (var.nextDragonrage>20 or not talent.dragonrage) and not var.trinket2Manual)) then
    --     if use.slot2() then ui.debug("Using Slot2 [Trinkets]") return true end
    -- end
end -- End Action List - Trinkets

-- Action List - ST
actionList.ST = function()
    -- Use Item - Kharnalex The First Light
    -- use_item,name=kharnalex_the_first_light,if=!buff.dragonrage.up&debuff.shattering_star_debuff.down&raid_event.movement.in>6
    if use.able.kharnalexTheFirstLight() and not buff.dragonrage.exists() and not debuff.shatteringStar.exists(units.dyn25f) then
        if use.kharnalexTheFirstLight() then
            ui.debug("Using Kharnalex The First Light [St]")
            return true
        end
    end
    -- Firestorm
    -- firestorm,if=buff.snapfire.up
    if cast.able.firestorm("target", "ground", 1, 8) and buff.snapfire.exists() then
        if cast.firestorm("target", "ground", 1, 8) then
            ui.debug("Casting Firestorm [St]")
            return true
        end
    end
    -- Dragonrage
    -- dragonrage,if=cooldown.fire_breath.remains<4&cooldown.eternity_surge.remains<10&target.time_to_die>=32|fight_remains<32
    if ui.alwaysCdAoENever("Dragonrage", 1, 25) and cast.able.dragonrage()
        and ((cd.fireBreath.remains() < 4 and cd.eternitySurge.remains() < 10
            and unit.ttd(units.dyn25f) >= 32 or unit.ttdGroup(40) < 32))
    then
        if cast.dragonrage() then
            ui.debug("Casting Dragonrage [St]")
            return true
        end
    end
    -- Tip The Scales
    -- tip_the_scales,if=buff.dragonrage.up&(((!talent.font_of_magic|talent.everburning_flame)&cooldown.fire_breath.remains<cooldown.eternity_surge.remains&buff.dragonrage.remains<14)|(cooldown.eternity_surge.remains<cooldown.fire_breath.remains&!talent.everburning_flame&talent.font_of_magic))
    if ui.alwaysCdAoENever("Tip the Scales") and cast.able.tipTheScales("player") and not buff.tipTheScales.exists()
        and ((buff.dragonrage.exists() and (((not talent.fontOfMagic or talent.everburningFlame)
            and cd.fireBreath.remains() < cd.eternitySurge.remains() and buff.dragonrage.remains() < 14) or (cd.eternitySurge.remains() < cd.fireBreath.remains()
            and not talent.everburningFlame and talent.fontOfMagic))))
    then
        if cast.tipTheScales("player") then
            ui.debug("Casting Tip The Scales [St]")
            return true
        end
    end
    -- Call Action List - Fb
    -- call_action_list,name=fb,if=(!talent.dragonrage|variable.next_dragonrage>variable.dr_prep_time_st|!talent.animosity)&(buff.blazing_shards.remains<variable.r1_cast_time|buff.dragonrage.up)&(!cooldown.eternity_surge.up|!talent.event_horizon|!buff.dragonrage.up)&(target.time_to_die>=8|fight_remains<30)
    if ui.alwaysCdAoENever("Fire Breath", 3, #enemies.yards25f) and var.moveCast
        and ((not talent.dragonrage or var.nextDragonrage > var.drPrepTimeSt or not talent.animosity)
            and (buff.blazingShards.remains() < var.r1CastTime or buff.dragonrage.exists())
            and (cd.eternitySurge.exists() or not talent.eventHorizon or not buff.dragonrage.exists())
            and (unit.ttd(units.dyn25f) >= 8 or unit.ttdGroup(40) < 30 or unit.isDummy("target")))
    then
        if actionList.Fb() then return true end
    end
    -- Shattering Star
    -- shattering_star,if=(buff.essence_burst.stack<buff.essence_burst.max_stack|!talent.arcane_vigor)&(!cooldown.eternity_surge.up|!buff.dragonrage.up|!talent.event_horizon)
    if cast.able.shatteringStar(unit.dyn25) and (((buff.essenceBurst.stack() < var.essenceBurstMaxStacks or not talent.arcaneVigor)
            and (cd.eternitySurge.exists() or not buff.dragonrage.exists() or not talent.eventHorizon)))
    then
        if cast.shatteringStar(unit.dyn25) then
            ui.debug("Casting Shattering Star [St]")
            return true
        end
    end
    -- Call Action List - Es
    -- call_action_list,name=es,if=(!talent.dragonrage|variable.next_dragonrage>variable.dr_prep_time_st|!talent.animosity)&(buff.blazing_shards.remains<variable.r1_cast_time|buff.dragonrage.up)&(target.time_to_die>=8|fight_remains<30)
    if ui.alwaysCdAoENever("Eternity Surge", 3, #enemies.yards25f) and ((not talent.dragonrage or var.nextDragonrage > var.drPrepTimeSt or not talent.animosity)
            and (buff.blazingShards.remains() < var.r1CastTime or buff.dragonrage.exists())
            and (unit.ttd(units.dyn25f) >= 8 or unit.ttdGroup(40) < 30 or unit.isDummy("target")))
    then
        if actionList.Es() then return true end
    end
    -- Wait
    -- wait,sec=cooldown.fire_breath.remains,if=talent.animosity&buff.dragonrage.up&buff.dragonrage.remains<gcd.max+variable.r1_cast_time*buff.tip_the_scales.down&buff.dragonrage.remains-cooldown.fire_breath.remains>=variable.r1_cast_time*buff.tip_the_scales.down
    if talent.animosity and buff.dragonrage.exists() and buff.dragonrage.remains() < unit.gcd(true) + var.r1CastTime * var.tipTheScales
        and buff.dragonrage.remains() - cd.fireBreath.remains() >= var.r1CastTime * var.tipTheScales
    then
        local waitFor = cd.fireBreath.remains()
        if cast.wait(waitFor, function() return true end) then
            ui.debug("Waiting for Sec=Cooldown.Fire Breath.Remains")
            return false
        end
    end
    -- Wait
    -- wait,sec=cooldown.eternity_surge.remains,if=talent.animosity&buff.dragonrage.up&buff.dragonrage.remains<gcd.max+variable.r1_cast_time&buff.dragonrage.remains-cooldown.eternity_surge.remains>variable.r1_cast_time*buff.tip_the_scales.down
    if talent.animosity and buff.dragonrage.exists() and buff.dragonrage.remains() < unit.gcd(true) + var.r1CastTime
        and buff.dragonrage.remains() - cd.eternitySurge.remains() > var.r1CastTime * var.tipTheScales
    then
        local waitFor = cd.eternitySurge.remains()
        if cast.wait(waitFor, function() return true end) then
            ui.debug("Waiting for Sec=Cooldown.Eternity Surge.Remains")
            return false
        end
    end
    -- Living Flame
    -- living_flame,if=buff.dragonrage.up&buff.dragonrage.remains<(buff.essence_burst.max_stack-buff.essence_burst.stack)*gcd.max&buff.burnout.up
    if cast.able.livingFlame(units.dyn25f) and buff.dragonrage.exists()
        and buff.dragonrage.remains() < (var.essenceBurstMaxStacks - buff.essenceBurst.stack()) * unit.gcd(true) and buff.burnout.exists()
    then
        if cast.livingFlame(units.dyn25f) then
            ui.debug("Casting Living Flame - Dragonrage Burnout [St]")
            return true
        end
    end
    -- Azure Strike
    -- azure_strike,if=buff.dragonrage.up&buff.dragonrage.remains<(buff.essence_burst.max_stack-buff.essence_burst.stack)*gcd.max
    if cast.able.azureStrike(units.dyn25f) and buff.dragonrage.exists()
        and buff.dragonrage.remains() < (var.essenceBurstMaxStacks - buff.essenceBurst.stack()) * unit.gcd(true)
    then
        if cast.azureStrike(units.dyn25f) then
            ui.debug("Casting Azure Strike - Dragonrage Essence Burst [St]")
            return true
        end
    end
    -- Living Flame
    -- living_flame,if=buff.burnout.up&(buff.leaping_flames.up&!buff.essence_burst.up|!buff.leaping_flames.up&buff.essence_burst.stack<buff.essence_burst.max_stack)&essence.deficit>=2
    if cast.able.livingFlame(units.dyn25f) and ((buff.burnout.exists() and (buff.leapingFlames.exists()
                and not buff.essenceBurst.exists() or not buff.leapingFlames.exists() and buff.essenceBurst.stack() < var.essenceBurstMaxStacks)
            and essence.deficit() >= 2))
    then
        if cast.livingFlame(units.dyn25f) then
            ui.debug("Casting Living Flame - Burnout [St]")
            return true
        end
    end
    -- Pyre
    -- pyre,if=debuff.in_firestorm.up&talent.raging_inferno&buff.charged_blast.stack==20&active_enemies>=2
    if cast.able.pyre(units.dyn25f, "aoe", 1, 8) --[[and debuff.inFirestorm.exists(units.dyn25f)]] and talent.ragingInferno
        and buff.chargedBlast.stack() == 20 and #enemies.yards8t >= 2
    then
        if cast.pyre(units.dyn25f, "aoe", 1, 8) then
            ui.debug("Casting Pyre [St]")
            return true
        end
    end
    -- Disintegrate
    -- disintegrate,chain=1,early_chain_if=evoker.use_early_chaining&ticks>=2&buff.dragonrage.up&(raid_event.movement.in>2|buff.hover.up),interrupt_if=evoker.use_clipping&buff.dragonrage.up&ticks>=2&(raid_event.movement.in>2|buff.hover.up),if=raid_event.movement.in>2|buff.hover.up
    if cast.able.disintegrate(units.dyn25f) and var.moveCast then
        if cast.disintegrate(units.dyn25f) then
            ui.debug("Casting Disintegrate [St]")
            return true
        end
    end
    -- Firestorm
    -- firestorm,if=!buff.dragonrage.up&debuff.shattering_star_debuff.down
    if cast.able.firestorm("target", "ground", 1, 8) and not buff.dragonrage.exists()
        and not debuff.shatteringStar.exists(unit.dyn25f)
    then
        if cast.firestorm("target", "ground", 1, 8) then
            ui.debug("Casting Firestorm [St]")
            return true
        end
    end
    -- Deep Breath
    -- deep_breath,if=!buff.dragonrage.up&active_enemies>=2&((raid_event.adds.in>=120&!talent.onyx_legacy)|(raid_event.adds.in>=60&talent.onyx_legacy))
    if ui.alwaysCdAoENever("Deep Breath", 3, #enemies.yards50r) and cast.able.deepBreath("groundLocation", var.deepBreathX, var.deepBreathY, 6)
        and ((not buff.dragonrage.exists() and #enemies.yards50r >= 2))
    then
        if cast.deepBreath("groundLocation", var.deepBreathX, var.deepBreathY, 6) then
            ui.debug("Casting Deep Breath [St]")
            return true
        end
    end
    -- Deep Breath
    -- deep_breath,if=!buff.dragonrage.up&talent.imminent_destruction&!debuff.shattering_star_debuff.up
    if ui.alwaysCdAoENever("Deep Breath", 3, #enemies.yards50r) and cast.able.deepBreath("groundLocation", var.deepBreathX, var.deepBreathY, 6)
        and not buff.dragonrage.exists() and talent.imminentDestruction and not debuff.shatteringStar.exists(units.dyn40f)
    then
        if cast.deepBreath("groundLocation", var.deepBreathX, var.deepBreathY, 6) then
            ui.debug("Casting Deep Breath - Imminent Destruction [St]")
            return true
        end
    end
    -- Call Action List - Green
    -- call_action_list,name=green,if=talent.ancient_flame&!buff.ancient_flame.up&!buff.shattering_star_debuff.up&talent.scarlet_adaptation&!buff.dragonrage.up
    if talent.ancientFlame and not buff.ancientFlame.exists() and not debuff.shatteringStar.exists(units.dyn25f) and talent.scarletAdaptation and not buff.dragonrage.exists() then
        if actionList.Green() then return true end
    end
    -- Living Flame
    -- living_flame,if=!buff.dragonrage.up|(buff.iridescence_red.remains>execute_time|buff.iridescence_blue.up)&active_enemies==1
    if cast.able.livingFlame(units.dyn25f) and ((not buff.dragonrage.exists() or (buff.iridescenceRed.remains() > cast.time.livingFlame()
            or buff.iridescenceBlue.exists()) and #enemies.yards25f == 1))
    then
        if cast.livingFlame(units.dyn25f) then
            ui.debug("Casting Living Flame [St]")
            return true
        end
    end
    -- Azure Strike
    -- azure_strike
    if cast.able.azureStrike(units.dyn25) then
        if cast.azureStrike(units.dyn25) then
            ui.debug("Casting Azure Strike [ST]")
            return true
        end
    end
end -- End Action List - ST

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Verdant Embrace
            -- verdant_embrace,if=talent.scarlet_adaptation
            if cast.able.verdantEmbrace() and talent.scarletAdaptation then
                if cast.verdantEmbrace() then
                    ui.debug("Casting Verdant Embrace [Pre-Combat]")
                    return true
                end
            end
            -- Firestorm
            -- firestorm,if=talent.firestorm
            if cast.able.firestorm("target", "ground", 1, 8) and talent.firestorm and var.moveCast then
                if cast.firestorm("target", "ground", 1, 8) then
                    ui.debug("Casting Firestorm [Pre-Combat]")
                    return true
                end
            end
            -- Living Flame
            -- living_flame,if=!talent.firestorm
            if cast.able.livingFlame("target") and not talent.firestorm and var.moveCast and not cast.current.livingFlame() then
                if cast.livingFlame("target") then
                    ui.debug("Casting Living Flame [Pre-Combat]")
                    return true
                end
            end
            -- Start Attack
            if unit.distance("target") < 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then
                        ui.debug("Casting Auto Attack [Pre-Combat]")
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action list - Combat
actionList.Combat = function()
    if unit.inCombat() and (cd.global.remain() == 0 or var.fireBreathStage > 0 or var.eternitySurgeStage > 0) then
        if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
            -----------------
            --- Interrupt ---
            -----------------
            if actionList.Interrupts() then return true end
            ------------
            --- Main ---
            ------------
            -- Call Action List - Trinkets
            -- call_action_list,name=trinkets
            -- if actionList.Trinkets() then return true end
            -- Call Action List - Cooldowns
            if actionList.Cooldowns() then return true end
            -- Run Action List - AOE
            -- run_action_list,name=aoe,if=spell_targets.pyre>=3
            if ui.useAOE(8, 3, units.dyn25) then
                if actionList.AoE() then return true end
            end
            -- Run Action List - ST
            -- run_action_list,name=st
            if ui.useST(8, 3, units.dyn25) then
                if actionList.ST() then return true end
            end
        end
    end -- End In Combat Rotation
end     -- End Action List - Combat

---------------- -
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                              = br.player.buff
    cast                                              = br.player.cast
    cd                                                = br.player.cd
    debuff                                            = br.player.debuff
    enemies                                           = br.player.enemies
    equiped                                           = br.player.equiped
    essence                                           = br.player.power.essence
    spell                                             = br.player.spell
    talent                                            = br.player.talent
    ui                                                = br.player.ui
    unit                                              = br.player.unit
    units                                             = br.player.units
    use                                               = br.player.use
    var                                               = br.player.variables
    -- General Locals

    -- Deep Breath Cast Location
    var.deepBreathX, var.deepBreathY, var.deepBreathZ = custom.getDeepBreathLocation(2)

    -- Fire Breath Stage
    if var.stageFireBreath == nil then var.stageFireBreath = 0 end
    if var.fireBreathStage == nil or br.empowerID ~= spell.fireBreath.id() then var.fireBreathStage = 0; end
    if cast.empowered.fireBreath() > 0 then
        var.fireBreathStage = cast.empowered.fireBreath()
    end
    if var.pauseForFbCd == nil then var.pauseForFbCd = false end

    -- Eternity Surge Stage
    if var.stageEternitySurge == nil then var.stageEternitySurge = 0 end
    if var.eternitySurgeStage == nil or br.empowerID ~= spell.eternitySurge.id() then var.eternitySurgeStage = 0; end
    if cast.empowered.eternitySurge() > 0 then
        var.eternitySurgeStage = cast.empowered.eternitySurge()
    end
    if var.pauseForEsCd == nil then var.pauseForEsCd = false end

    var.moveCast = (not unit.moving() or buff.hover.exists())
    var.profileStop = false
    var.haltProfile = (unit.inCombat() and var.profileStop) or unit.mounted() or br.pause() or ui.mode.rotation == 4
    -- Units
    units.get(25)
    units.get(40)
    -- Enemies
    enemies.get(8)
    enemies.get(8, units.dyn25)
    enemies.get(15, "player", false, true) -- makes enemies.yards15f
    enemies.get(25)
    enemies.get(25, "player", false, true)
    enemies.rect.get(8, 15, false)
    enemies.rect.get(6, 50, false)

    -- Cancel if casting with no enemies
    if #enemies.yards25f == 0 then
        if var.fireBreathStage > 0 then
            if cast.cancel.fireBreath() then
                ui.debug("Canceling Fire Breath [No Enemies in Range]")
                return true
            end
        end
        if var.eternitySurgeStage > 0 then
            if cast.cancel.eternitySurge() then
                ui.debug("Canceling Eternity Surge [No Enemies in Range]")
                return true
            end
        end
    end

    -- Cancel Disintegrate
    -- buff.dragonrage.up&ticks>=2
    if cast.current.disintegrate() and buff.dragonrage.exists() and cast.timeRemain() <= (cast.time.disintegrate() / 3) * 2 then
        if cast.cancel.disintegrate() then
            ui.debug("Canceling Disintegrate [Dragonrage > 2 ticks]")
            return true
        end
    end

    -- End Fire Breath Cast at Stage
    if var.stageFireBreath > 0 and var.fireBreathStage == var.stageFireBreath then
        if cast.fireBreath("player") then
            var.stageFireBreath = 0
            ui.debug("Casting Fire Breath at Empowered Stage " .. var.fireBreathStage)
            return true
        end
    end

    -- End Eternity Surge Cast at Stage
    if var.stageEternitySurge > 0 and var.eternitySurgeStage == var.stageEternitySurge then
        if cast.eternitySurge(units.dyn25) then
            var.stageEternitySurge = 0
            ui.debug("Casting Eternity Surge at Empowered Stage " .. var.eternitySurgeStage)
            return true
        end
    end

    -- Numeric Conversion
    var.eternitysSpan = talent.eternitysSpan and 1 or 0
    var.spellHaste = (unit.spellHaste() / 100)
    var.tipTheScales = not buff.tipTheScales.exists() and 1 or 0
    var.essenceBurstMaxStacks = talent.essenceAttunement and 2 or 1
    var.dragonrage = ui.alwaysCdAoENever("Dragonrage", 1, 25) and cd.dragonrage.remains() or 999

    -- SimC variables
    -- variable,name=next_dragonrage,value=cooldown.dragonrage.remains<?(cooldown.eternity_surge.remains-2*gcd.max)<?(cooldown.fire_breath.remains-gcd.max)
    var.nextDragonrage = math.max(var.dragonrage, (cd.eternitySurge.remains() - 2 * unit.gcd(true)),
        (cd.fireBreath.remains() - unit.gcd(true)))
    -- variable,name=r1_cast_time,value=1.0*spell_haste
    var.r1CastTime = 1.0 * var.spellHaste
    -- variable,name=dr_prep_time_aoe,default=4,op=reset
    var.drPrepTimeAoe = 4
    -- variable,name=dr_prep_time_st,default=13,op=reset
    var.drPrepTimeSt = 13

    var.maxHp = 0
    var.maxHpUnit = "target"
    for i = 1, #enemies.yards25f do
        local thisUnit = enemies.yards25f[i]
        if unit.hp(thisUnit) > var.maxHp then
            var.maxHp = unit.hp(thisUnit)
            var.maxHpUnit = thisUnit
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif var.haltProfile then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -------------
        --- Extra ---
        -------------
        if actionList.Extra() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if actionList.Combat() then return true end
    end         -- Pause
end             -- End runRotation
local id = 1467 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation
})
