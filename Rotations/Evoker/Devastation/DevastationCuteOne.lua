-------------------------------------------------------
-- Author = CuteOne
-- Patch = 10.0
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 90%
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
            icon = br.player.spell.disintegrate
        },
        [2] = {
            mode = "Mult",
            value = 2,
            overlay = "Multiple Target Rotation",
            tip = "Multiple target rotation used.",
            highlight = 1,
            icon = br.player.spell.azureStrike
        },
        [3] = {
            mode = "Sing",
            value = 3,
            overlay = "Single Target Rotation",
            tip = "Single target rotation used.",
            highlight = 1,
            icon = br.player.spell.livingFlame
        },
        [4] = {
            mode = "Off",
            value = 4,
            overlay = "DPS Rotation Disabled",
            tip = "Disable DPS Rotation",
            highlight = 0,
            icon = br.player.spell.blessingOfTheBronze
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
            icon = br.player.spell.furyOfTheAspects
        },
        [2] = {
            mode = "On",
            value = 2,
            overlay = "Cooldowns Enabled",
            tip = "Cooldowns used regardless of target.",
            highlight = 0,
            icon = br.player.spell.furyOfTheAspects
        },
        [3] = {
            mode = "Off",
            value = 3,
            overlay = "Cooldowns Disabled",
            tip = "No Cooldowns will be used.",
            highlight = 0,
            icon = br.player.spell.furyOfTheAspects
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
            icon = br.player.spell.livingFlame
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Defensive Disabled",
            tip = "No Defensives will be used.",
            highlight = 0,
            icon = br.player.spell.livingFlame
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
            icon = br.player.spell.tailSwipe
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Interrupts Disabled",
            tip = "No Interrupts will be used.",
            highlight = 0,
            icon = br.player.spell.tailSwipe
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
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Blessing of the Bronze
            br.ui:createCheckbox(section, "Blessing of the Bronze")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            local alwaysCdAoENever = {"Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never"}
            -- Basic Trinkets Module
            br.player.module.BasicTrinkets(nil, section)
            -- Deep Breath
            br.ui:createDropdownWithout(section, "Deep Breath", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Deep Breath Ability.")
            -- Dragonrage
            br.ui:createDropdownWithout(section, "Dragonrage", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Dragonrage Ability.")
            -- Tip the Scales
            br.ui:createDropdownWithout(section, "Tip the Scales", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Tip the Scales Ability.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Emerald Blossom
            br.ui:createSpinner(section, "Emerald Blossom", 35, 0, 99, 5, "Use Emerald Blossom to Heal below this threshold")
            -- Living Flame
            br.ui:createSpinner(section, "Living Flame Heal", 45, 0, 99, 5, "Use Living Flame to Heal below this threshold")
            -- Obsidian Scales
            br.ui:createSpinner(section, "Obsidian Scales", 50, 0, 99, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Return
            br.ui:createCheckbox(section,"Return")
            br.ui:createDropdownWithout(section, "Return - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
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
            -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions
    }}
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
local equiped
local module
local power
local spell
local talent
local ui
local unit
local units
local use
local var
-- General Locals - Common Non-BR API Locals used in profiles
local essence
local essenceMax
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}
local custom = {}
if custom.initFireBreath == nil then custom.initFireBreath = false end
if custom.initEternitySurge == nil then custom.initEternitySurge = false end

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
custom.castFireBreath = function(castAtStage, list)
    if not cast.current.fireBreath() and not custom.initFireBreath and cast.timeSinceLast.fireBreath() > cast.time.fireBreath() + unit.gcd(true) then
        if cast.fireBreath("player","rect",1,25) then custom.initFireBreath = true ui.debug("Casting Fire Breath ["..list.."]") return true end
    end
    if custom.initFireBreath and var.fireBreathStage == castAtStage then
        if cast.fireBreath("player") then custom.initFireBreath = false ui.debug("Casting Fire Breath - Empowered Stage "..var.fireBreathStage.." ["..list.."]") return true end
    end
end
custom.castEternitySurge = function(castAtStage, list)
    if not custom.initEternitySurge and cast.timeSinceLast.eternitySurge() > cast.time.eternitySurge() + unit.gcd(true) then
        if cast.eternitySurge(units.dyn25) then custom.initEternitySurge = true ui.debug("Casting Eternity Surge ["..list.."]") return true end
    end
    if custom.initEternitySurge and var.eternitySurgeStage == castAtStage then
        if cast.eternitySurge(units.dyn25) then custom.initEternitySurge = false ui.debug("Casting Eternity Surge - Empowered Stage "..var.eternitySurgeStage.." ["..list.."]") return true end
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
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test-- Dummy DPS Test
    -- Blessing of the Bronze
    if ui.checked("Blessing of the Bronze") and cast.able.blessingOfTheBronze() then
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            if not unit.deadOrGhost(thisUnit) and unit.distance(thisUnit) < 40 and buff.blessingOfTheBronze.remain(thisUnit) < 600 then
                if cast.blessingOfTheBronze() then ui.debug("Casting Blessing of the Bronze") return true end
            end
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() and not unit.mounted() then
        local opValue
        local thisUnit
        -- Basic Healing Module
        module.BasicHealing()
        -- Emerald Blossom
        if ui.checked("Emerald Blossom") and cast.able.emeraldBlossom("player") and unit.hp() <= ui.value("Emerald Blossom") then
            if cast.emeraldBlossom("player") then ui.debug("Casting Emerald Blossom") return true end
        end
        -- Living Flame
        if ui.checked("Living Flame Heal") and not unit.moving() then
            thisUnit = unit.friend("target") and "target" or "player"
            if cast.able.livingFlame(thisUnit) and unit.hp(thisUnit) <= ui.value("Living Flame Heal") and cast.timeSinceLast.livingFlame() > cast.time.livingFlame() + unit.gcd(true) then
                if cast.livingFlame(thisUnit) then ui.debug("Casting Living Flame on " .. unit.name(thisUnit)) return true end
            end
        end
        -- Obsidian Scales
        if ui.checked("Obsidian Scales") and cast.able.obsidianScales("player") and unit.hp() <= ui.value("Obsidian Scales") then
            if cast.obsidianScales("player") then ui.debug("Casting Obsidian Scales") return true end
        end
        -- Return
        if ui.checked("Return") and not unit.inCombat() and not unit.moving() then
            opValue = ui.value("Return - Target")
            if opValue == 1 then
                thisUnit = "target"
            elseif opValue == 2 then
                thisUnit = "mouseover"
            end
            if cast.able.returnEvoker(thisUnit,"dead") and unit.deadOrGhost(thisUnit)
                and (unit.friend(thisUnit) and unit.player(thisUnit))
            then
                if cast.returnEvoker(thisUnit,"dead") then ui.debug("Casting Return on "..unit.name(thisUnit)) return true end
            end
        end
        -- Verdant Embrace
        if ui.checked("Verdant Embrace") then
            thisUnit = unit.friend("target") and "target" or "player"
            if cast.able.verdantEmbrace(thisUnit) and unit.hp(thisUnit) <= ui.value("Verdant Embrace") then
                if cast.verdantEmbrace(thisUnit) then ui.debug("Casting Verdant Embrace on "..unit.name(thisUnit)) return true end
            end
        end
        -- Wing Buffet
        if ui.checked("Wing Buffet - HP") and unit.hp() <= ui.value("Wing Buffet - HP")
            and cast.able.wingBuffet() and unit.inCombat() and #enemies.yards15f > 0
        then
            if cast.wingBuffet() then ui.debug("Casting Wing Buffet [HP]") return true end
        end
        if ui.checked("Wing Buffet - AoE") and #enemies.yards15f >= ui.value("Wing Buffet - AoE")
            and cast.able.wingBuffet()
        then
            if cast.wingBuffet() then ui.debug("Casting Wing Buffet [AOE]") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        local thisUnit
        -- Quell
        if ui.checked("Quell") and cast.able.quell() then
            for i=1, #enemies.yards25 do
                thisUnit = enemies.yards25[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.quell(thisUnit) then ui.debug("Casting Quell on "..unit.name(thisUnit)) return true end
                end
            end
        end
        -- Tail Swipe
        if ui.checked("Tail Swipe") and cast.able.tailSwipe() then
            for i=1, #enemies.yards8 do
                thisUnit = enemies.yards8[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.tailSwipe(thisUnit) then ui.debug("Casting Tail Swipe on "..unit.name(thisUnit)) return true end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- Trinket - Non-Specific
    if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        module.BasicTrinkets()
    end
end -- End Action List - Cooldowns

-- Action List - AOE
actionList.AoE = function()
    -- Dragonrage
    -- dragonrage,if=cooldown.fire_breath.remains<=gcd.max&cooldown.eternity_surge.remains<3*gcd.max
    if ui.alwaysCdAoENever("Dragonrage",1,25) and cast.able.dragonrage() and cd.fireBreath.remains() <= unit.gcd(true)
        and cd.eternitySurge.remains() < 3 * unit.gcd(true)
    then
        if cast.dragonrage() then ui.debug("Casting Dragonrage [AOE]") return true end
    end
    -- Tip the Scales
    -- tip_the_scales,if=buff.dragonrage.up&(spell_targets.pyre<=6|!cooldown.fire_breath.up)
    if ui.alwaysCdAoENever("Tip the Scales") and cast.able.tipTheScales("player") and buff.dragonrage.exists()
        and (#enemies.yards8t <= 6 or cd.fireBreath.remains() > 0)
    then
        if cast.tipTheScales("player") then ui.debug("Csating Tip the Scales [AOE]") return true end
    end
    -- Call Action List - FB
    -- call_action_list,name=fb,if=buff.dragonrage.up|!talent.dragonrage|cooldown.dragonrage.remains>10&talent.everburning_flame
    if not unit.moving() and (buff.dragonrage.exists() or not talent.dragonrage or (cd.dragonrage.remains() > 10 and talent.everburningFlame)) then
        if actionList.FB() then return true end
    end
    -- Fire Breath
    -- fire_breath,empower_to=1,if=cooldown.dragonrage.remains>10&spell_targets.pyre>=7
    if cast.able.fireBreath("player","rect",1,25) and not unit.moving() and (cd.dragonrage.remains() > 10 or not ui.alwaysCdAoENever("Dragonrage",1,25))
        and #enemies.yards8t >= 7
    then
        return custom.castFireBreath(1,"AOE")
    end
    -- fire_breath,empower_to=2,if=cooldown.dragonrage.remains>10&spell_targets.pyre>=6
    if cast.able.fireBreath("player","rect",1,25) and not unit.moving() and (cd.dragonrage.remains() > 10 or not ui.alwaysCdAoENever("Dragonrage",1,25))
        and #enemies.yards8t >= 6
    then
        return custom.castFireBreath(2,"AOE")
    end
    -- fire_breath,empower_to=3,if=cooldown.dragonrage.remains>10&spell_targets.pyre>=4
    if cast.able.fireBreath("player","rect",1,25) and not unit.moving() and (cd.dragonrage.remains() > 10 or not ui.alwaysCdAoENever("Dragonrage",1,25))
        and #enemies.yards8t >= 4
    then
        return custom.castFireBreath(3,"AOE")
    end
    -- fire_breath,empower_to=2,if=cooldown.dragonrage.remains>10
    if cast.able.fireBreath("player","rect",1,25) and not unit.moving()
        and (cd.dragonrage.remains() > 10 or not ui.alwaysCdAoENever("Dragonrage",1,25))
    then
        return custom.castFireBreath(2,"AOE")
    end
    -- Call Action List - ES
    -- call_action_list,name=es,if=buff.dragonrage.up|!talent.dragonrage|cooldown.dragonrage.remains>15
    if not unit.moving() and (buff.dragonrage.exists() or not talent.dragonrage or cd.dragonrage.remains() > 15) then
        if actionList.ES() then return true end
    end
    -- Azure Strike
    -- azure_strike,if=buff.dragonrage.up&buff.dragonrage.remains<(buff.essence_burst.max_stack-buff.essence_burst.stack)*gcd.max
    if cast.able.azureStrike(units.dyn25) and buff.dragonrage.exists() and buff.dragonrage.remains() < (var.essenceBurstMaxStacks - buff.essenceBurst.stack()) * unit.gcd(true) then
        if cast.azureStrike(units.dyn25) then ui.debug("Casting Azure Strike [Dragonrage - AOE]") return true end
    end
    -- Deep Breath
    -- deep_breath,if=!buff.dragonrage.up
    if ui.alwaysCdAoENever("Deep Breath",1,40) and cast.able.deepBreath("best","rect",1,6) and not buff.dragonrage.exists() then
        if cast.deepBreath("best","rect",1,6) then ui.debug("Casting Deep Breath [AOE]") return true end
    end
    -- Firestorm
    -- firestorm
    if cast.able.firestorm("best",nil,1,8) and var.moveCast then
        if cast.firestorm("best",nil,1,8) then ui.debug("Casting Firestorm [AOE]") return true end
    end
    -- Shattering Star
    -- shattering_star
    if cast.able.shatteringStar(units.dyn25) and var.moveCast then
        if cast.shatteringStar(units.dyn25) then ui.debug("Casting Shattering Star [AOE]") return true end
    end
    -- Azure Strike
    -- azure_strike,if=cooldown.dragonrage.remains<gcd.max*6&cooldown.fire_breath.remains<6*gcd.max&cooldown.eternity_surge.remains<6*gcd.max
    if cast.able.azureStrike(units.dyn25) and talent.dragonrage and ui.alwaysCdAoENever("Dragonrage",1,25) and cd.dragonrage.remains() < unit.gcd(true) * 6
        and cd.fireBreath.remains() < 6 * unit.gcd(true) and cd.eternitySurge.remains() < 6 * unit.gcd(true)
    then
        if cast.azureStrike(units.dyn25) then ui.debug("Casting Azure Strike [Dragonrage Soon - AOE]") return true end
    end
    -- Pyre
    -- pyre,if=talent.volatility
    if cast.able.pyre(units.dyn25,"AOE",1,8) and talent.volatility then
        if cast.pyre(units.dyn25,"AOE",1,8) then ui.debug("Casting Pyre [Volatility - AOE]") return true end
    end
    -- Living Flame
    -- living_flame,if=buff.burnout.up&buff.leaping_flames.up&!buff.essence_burst.up
    if cast.able.livingFlame(units.dyn25) and var.moveCast and buff.burnout.exists() and buff.leapingFlames.exists() and not buff.essenceBurst.exists()
        and cast.timeSinceLast.livingFlame() > cast.time.livingFlame() + unit.gcd(true)
    then
        if cast.livingFlame(units.dyn25) then ui.debug("Casting Living Flame [Leaping Burnout - AOE]") return true end
    end
    -- Pyre
    -- pyre,if=cooldown.dragonrage.remains>=10&spell_targets.pyre>=4
    -- pyre,if=cooldown.dragonrage.remains>=10&spell_targets.pyre=3&buff.charged_blast.stack>=10
    if cast.able.pyre(units.dyn25,"AOE",1,8) and var.moveCast and (cd.dragonrage.remains() >= 10 or not ui.alwaysCdAoENever("Dragonrage",1,25)) then
        if #enemies.yards8t >= 4 then
            if cast.pyre(units.dyn25,"AOE",1,8) then ui.debug("Casting Pyre [4+ Targets - AOE]") return true end
        end
        if #enemies.yards8t == 3 and buff.chargedBlast.stack() >= 10 then
            if cast.pyre(units.dyn25,"AOE",1,8) then ui.debug("Casting Pyre [3 Targets - AOE]") return true end
        end
    end
    -- Disintegrate
    -- disintegrate,chain=1,if=!talent.shattering_star|cooldown.shattering_star.remains>5|essence>essence.max-1|buff.essence_burst.stack==buff.essence_burst.max_stack
    if cast.able.disintegrate() and var.moveCast and cast.timeSinceLast.disintegrate() > cast.time.disintegrate() + unit.gcd(true)
        and (not talent.shatteringStar or cd.shatteringStar.remains() > 5
            or essence > essenceMax - 1 or buff.essenceBurst.stack() == var.essenceBurstMaxStacks)
    then
        if cast.disintegrate() then ui.debug("Casting Disintegrate [AOE]") return true end
    end
    -- Living Flame
    -- living_flame,if=talent.snapfire&buff.burnout.up
    if cast.able.livingFlame(units.dyn25) and var.moveCast and talent.snapfire and buff.burnout.exists()
        and cast.timeSinceLast.livingFlame() > cast.time.livingFlame() + unit.gcd(true)
    then
        if cast.livingFlame(units.dyn52) then ui.debug("Casting Living Flame [Snapfire - AOE]") return true end
    end
    -- azure_strike
    if cast.able.azureStrike(units.dyn25) then
        if cast.azureStrike(units.dyn25) then ui.debug("Casting Azure Strike [AOE]") return true end
    end
end -- End Action List - AOE

-- Action List - ES
actionList.ES = function()
    -- Eternity Surge
    if cast.able.eternitySurge(units.dyn25) then
        -- eternity_surge,empower_to=1,if=spell_targets.pyre<=1+talent.eternitys_span|buff.dragonrage.remains<1.75*spell_haste&buff.dragonrage.remains>=1*spell_haste
        if #enemies.yards8t <= 1 + var.eternitySpan or buff.dragonrage.remains() < 1.75 * var.spellHaste
            and buff.dragonrage.remains() >= 1 * var.spellHaste
        then
            if custom.castEternitySurge(1,"ES") then return true end
        end
        -- eternity_surge,empower_to=2,if=spell_targets.pyre<=2+2*talent.eternitys_span|buff.dragonrage.remains<2.5*spell_haste&buff.dragonrage.remains>=1.75*spell_haste
        if #enemies.yards8t <= 2 + 2 * var.eternitySpan or buff.dragonrage.remains() < 2.5 * var.spellHaste
            and buff.dragonrage.remains() >= 1.75 * var.spellHaste
        then
            if custom.castEternitySurge(2,"ES") then return true end
        end
        -- eternity_surge,empower_to=3,if=spell_targets.pyre<=3+3*talent.eternitys_span|!talent.font_of_magic|buff.dragonrage.remains<=3.25*spell_haste&buff.dragonrage.remains>=2.5*spell_haste
        if #enemies.yards8t <= 3 + 3 * var.eternitySpan or not talent.fontOfMagic or (buff.dragonrage.remains() <= 3.25 * var.spellHaste
            and buff.dragonrage.remains() >= 2.5 * var.spellHaste)
        then
            if custom.castEternitySurge(3,"ES") then return true end
        end
        -- eternity_surge,empower_to=4
        if custom.castEternitySurge(4,"ES") then return true end
    end
end -- End Action List - ES

-- Action List - FB
actionList.FB = function()
    -- Fire Breath
    if cast.able.fireBreath("player","rect",1,25) then
        -- fire_breath,empower_to=1,if=(20+2*talent.blast_furnace.rank)+dot.fire_breath_damage.remains<(20+2*talent.blast_furnace.rank)*1.3|buff.dragonrage.remains<1.75*spell_haste&buff.dragonrage.remains>=1*spell_haste|active_enemies<=2
        if (20 + 2 * talent.rank.blastFurnace) + debuff.fireBreath.remains(units.dyn25) < (20 + 2 * talent.rank.blastFurnace) * 1.3
            or buff.dragonrage.remains() < 1.75 * var.spellHaste and buff.dragonrage.remains() >= 1 * var.spellHaste or #enemies.yards25f <= 2
        then
            if custom.castFireBreath(1,"FB") then return true end
        end
        -- fire_breath,empower_to=2,if=(14+2*talent.blast_furnace.rank)+dot.fire_breath_damage.remains<(20+2*talent.blast_furnace.rank)*1.3|buff.dragonrage.remains<2.5*spell_haste&buff.dragonrage.remains>=1.75*spell_haste
        if (14 + 2 * talent.rank.blastFurnace) + debuff.fireBreath.remains(units.dyn25) < (20 + 2 * talent.rank.blastFurnace) * 1.3
        or buff.dragonrage.remains() < 2.5 * var.spellHaste and buff.dragonrage.remains() >= 1.75 * var.spellHaste
        then
            if custom.castFireBreath(2,"FB") then return true end
        end
        -- fire_breath,empower_to=3,if=(8+2*talent.blast_furnace.rank)+dot.fire_breath_damage.remains<(20+2*talent.blast_furnace.rank)*1.3|!talent.font_of_magic|buff.dragonrage.remains<=3.25*spell_haste&buff.dragonrage.remains>=2.5*spell_haste
        if (8 + 2 * talent.rank.blastFurnace) + debuff.fireBreath.remains(units.dyn25) < (20 + 2 * talent.rank.blastFurnace) * 1.3 or not talent.fontOfMagic
        or buff.dragonrage.remains() < 3.25 * var.spellHaste and buff.dragonrage.remains() >= 2.5 * var.spellHaste
        then
            if custom.castFireBreath(3,"FB") then return true end
        end
        -- fire_breath,empower_to=4
        if custom.castFireBreath(4,"FB") then return true end
    end
end -- End Action List - FB

-- Action List - ST
actionList.ST = function()
    -- Dragonrage
    -- dragonrage,if=cooldown.fire_breath.remains<gcd.max&cooldown.eternity_surge.remains<2*gcd.max|fight_remains<30
    if ui.alwaysCdAoENever("Dragonrage",1,25) and cast.able.dragonrage() and cd.fireBreath.remains() < unit.gcd(true) and cd.eternitySurge.remains() < 2 * unit.gcd(true) then
        if cast.dragonrage() then ui.debug("Casting Dragonrage [ST]") return true end
    end
    -- Tip the Scales
    -- tip_the_scales,if=buff.dragonrage.up&(buff.dragonrage.remains<variable.r1_cast_time&(buff.dragonrage.remains>cooldown.fire_breath.remains|buff.dragonrage.remains>cooldown.eternity_surge.remains)|talent.feed_the_flames&!cooldown.fire_breath.up)
    if ui.alwaysCdAoENever("Tip the Scales") and cast.able.tipTheScales("player") and buff.dragonrage.exists()
        and (buff.dragonrage.remains() < var.r1CastTime and (buff.dragonrage.remains() > cd.fireBreath.remains()
            or buff.dragonrage.remains() > cd.eternitySurge.remains()) or talent.feedTheFlames and not cd.fireBreath.exists())
    then
        if cast.tipTheScales("player") then ui.debug("Casting Tip the Scales [ST]") return true end
    end
    -- Call Action List - FB
    -- call_action_list,name=fb,if=!talent.dragonrage|variable.next_dragonrage>15|!talent.animosity
    if not unit.moving() and (not talent.dragonrage or var.nextDragonrage > 15 or not talent.animosity) then
        if actionList.FB() then return true end
    end
    -- Call Action List - ES
    -- call_action_list,name=es,if=!talent.dragonrage|variable.next_dragonrage>15|!talent.animosity
    if not unit.moving() and (not talent.dragonrage or var.nextDragonrage > 15 or not talent.animosity) then
        if actionList.ES() then return true end
    end
    -- Pause
    -- wait,sec=cooldown.fire_breath.remains,if=talent.animosity&buff.dragonrage.up&buff.dragonrage.remains<gcd.max+variable.r1_cast_time*buff.tip_the_scales.down&buff.dragonrage.remains-cooldown.fire_breath.remains>=variable.r1_cast_time*buff.tip_the_scales.down
    if talent.animosity and buff.dragonrage.exists() and buff.dragonrage.remains() < unit.gcd(true) + var.r1CastTime * var.tipTheScales
        and buff.dragonrage.remains() - cd.fireBreath.remains() >= var.r1CastTime * var.tipTheScales
    then
        if cd.fireBreath.exists() then return true end
    end
    -- wait,sec=cooldown.eternity_surge.remains,if=talent.animosity&buff.dragonrage.up&buff.dragonrage.remains<gcd.max+variable.r1_cast_time&buff.dragonrage.remains-cooldown.eternity_surge.remains>variable.r1_cast_time*buff.tip_the_scales.down
    if talent.animosity and buff.dragonrage.exists() and buff.dragonrage.remains() < unit.gcd(true) + var.r1CastTime
        and buff.dragonrage.remains() - cd.eternitySurge.remains() > var.r1CastTime * var.tipTheScales
    then
        if cd.eternitySurge.exists() then return true end
    end
    -- Shattering Star
    -- shattering_star,if=!buff.dragonrage.up|buff.essence_burst.stack==buff.essence_burst.max_stack|talent.eye_of_infinity
    if cast.able.shatteringStar(units.dyn25) and var.moveCast and (not buff.dragonrage.exists() or buff.essenceBurst.stack() == var.essenceBurstMaxStacks or talent.eyeOfInfinity) then
        if cast.shatteringStar(units.dyn25) then ui.debug("Casting Shattering Star [ST]") return true end
    end
    -- Living Flame
    -- living_flame,if=buff.dragonrage.up&buff.dragonrage.remains<(buff.essence_burst.max_stack-buff.essence_burst.stack)*gcd.max&buff.burnout.up
    if cast.able.livingFlame(units.dyn25) and var.moveCast and buff.dragonrage.exists() and buff.dragonrage.remains() < (var.essenceBurstMaxStacks - buff.essenceBurst.stack()) * unit.gcd(true)
        and buff.burnout.exists() and cast.timeSinceLast.livingFlame() > cast.time.livingFlame() + unit.gcd(true)
    then
        if cast.livingFlame(units.dyn25) then ui.debug("Casting Living Flame [Dragonrage Burnout - ST]") return true end
    end
    -- Azure Strike
    -- azure_strike,if=buff.dragonrage.up&buff.dragonrage.remains<(buff.essence_burst.max_stack-buff.essence_burst.stack)*gcd.max
    if cast.able.azureStrike(units.dyn25) and buff.dragonrage.exists() and buff.dragonrage.remains() < (var.essenceBurstMaxStacks - buff.essenceBurst.stack()) * unit.gcd(true) then
        if cast.azureStrike(units.dyn25) then ui.debug("Casting Azure Strike [Dragonrage Essence Burst - ST]") return true end
    end
    -- Firestorm
    -- firestorm,if=!buff.dragonrage.up&debuff.shattering_star_debuff.down|buff.snapfire.up
    if cast.able.firestorm("best",nil,1,8) and (var.moveCast or buff.snapFire.exists()) and ((not buff.dragonrage.exists() and not debuff.shatteringStar.exists(units.dyn25)) or buff.snapFire.exists())
        and (var.moveCast or buff.snapFire.exists())
    then
        if cast.firestorm("best",nil,1,8) then ui.debug("Casting Firestorm [ST]") return true end
    end
    -- Living Flame
    -- living_flame,if=buff.burnout.up&buff.essence_burst.stack<buff.essence_burst.max_stack&essence<essence.max-1
    if cast.able.livingFlame(units.dyn25) and var.moveCast and buff.burnout.exists() and buff.essenceBurst.stack() < 1
        and essence < essenceMax - var.essenceBurstMaxStacks and cast.timeSinceLast.livingFlame() > cast.time.livingFlame() + unit.gcd(true)
    then
        if cast.livingFlame(units.dyn25) then ui.debug("Casting Living Flame [Burnout - ST]") return true end
    end
    -- Azure Strike
    -- azure_strike,if=buff.dragonrage.up&(essence<3&!buff.essence_burst.up|(talent.shattering_star&cooldown.shattering_star.remains<=(buff.essence_burst.max_stack-buff.essence_burst.stack)*gcd.max))
    if cast.able.azureStrike(units.dyn25) and (buff.dragonrage.exists() and (essence < 3 and not buff.essenceBurst.exists()
        or (talent.shatteringStar and cd.shatteringStar.remains() <= (var.essenceBurstMaxStacks - buff.essenceBurst.stack()) * unit.gcd(true))))
    then
        if cast.azureStrike(units.dyn25) then ui.debug("Casting Azure Strike [Dragonrage ST]") return true end
    end
    -- Disintegrate
    -- disintegrate,chain=1,early_chain_if=buff.dragonrage.up&ticks>=2,interrupt_if=buff.dragonrage.up&ticks>=2,if=buff.dragonrage.up|(!talent.shattering_star|cooldown.shattering_star.remains>6|essence>essence.max-1|buff.essence_burst.stack==buff.essence_burst.max_stack)
    if cast.able.disintegrate() and var.moveCast and cast.timeSinceLast.disintegrate() > cast.time.disintegrate() + unit.gcd(true)
        and (buff.dragonrage.exists() or (not talent.shatteringStar or cd.shatteringStar.remains() > 6
            or essence > essenceMax - 1 or buff.essenceBurst.stack() == var.essenceBurstMaxStacks))
    then
        if cast.disintegrate() then ui.debug("Casting Disintegrate [ST]") return true end
    end
    -- Deep Breath
    -- deep_breath,if=!buff.dragonrage.up&spell_targets.deep_breath>1
    if ui.alwaysCdAoENever("Deep Breath",2,40) and cast.able.deepBreath("best","rect",2,6) and not buff.dragonrage.exists() and #enemies.yards40r > 1 then
        if cast.deepBreath("best","rect",2,6) then ui.debug("Casting Deep Breath [ST]") return true end
    end
    -- Item - Kharnalex The First Light
    -- use_item,name=kharnalex_the_first_light,if=!buff.dragonrage.up&debuff.shattering_star_debuff.down
    if equiped.kharnalexTheFirstLight() and use.able.kharnalexTheFirstLight(units.dyn25)
        and not buff.dragonrage.exists() and not debuff.shatteringStar.exists(units.dyn25)
        and var.moveCast
    then
        if use.kharnalexTheFirstLight(units.dyn25) then ui.debug("Using Kharnalex The First Light [ST]") return true end
    end
    -- Living Flame
    -- living_flame
    if cast.able.livingFlame(units.dyn25) and var.moveCast and cast.timeSinceLast.livingFlame() > cast.time.livingFlame() + unit.gcd(true) then
        if cast.livingFlame(units.dyn25) then ui.debug("Casting Living Flame [ST]") return true end
    end
end -- End Action List - ST

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Firestorm
            -- firestorm,if=talent.firestorm
            if cast.able.firestorm("best",nil,1,8) and talent.firestorm and var.moveCast then
                if cast.firestorm("best",nil,1,8) then ui.debug("Casting Firestorm [Pre-Combat]") return true end
            end
            -- Living Flame
            -- living_flame,if=!talent.firestorm
            if cast.able.livingFlame("target") and not talent.firestorm and var.moveCast then
                if cast.livingFlame("target") then ui.debug("Casting Living Flame [Pre-Combat]") return true end
            end
        end
    end
end -- End Action List - PreCombat

---------------- -
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff            = br.player.buff
    cast            = br.player.cast
    cd              = br.player.cd
    debuff          = br.player.debuff
    enemies         = br.player.enemies
    equiped         = br.player.equiped
    module          = br.player.module
    power           = br.player.power
    spell           = br.player.spell
    talent          = br.player.talent
    ui              = br.player.ui
    unit            = br.player.unit
    units           = br.player.units
    use             = br.player.use
    var             = br.player.variables
    -- General Locals
    essence = power.essence.amount()
    essenceMax = power.essence.max()
    -- Fire Breath Stage
    if var.fireBreathStage == nil or br.empowerID ~= spell.fireBreath then var.fireBreathStage = 0; custom.initFireBreath = false end
    if cast.empowered.fireBreath() > 0 then
        var.fireBreathStage = cast.empowered.fireBreath()
    end
    -- Eternity Surge Stage
    if var.eternitySurgeStage == nil or br.empowerID ~= spell.eternitySurge then var.eternitySurgeStage = 0; custom.initEternitySurge = false end
    if cast.empowered.eternitySurge() > 0 then
        var.eternitySurgeStage = cast.empowered.eternitySurge()
    end
    var.moveCast = (not unit.moving() or buff.hover.exists())
    var.profileStop = false
    var.haltProfile = (unit.inCombat() and var.profileStop) or unit.mounted() or br.pause() or ui.mode.rotation == 4
    -- Units
    units.get(25)
    units.get(40)
    -- Enemies
    enemies.get(8)
    enemies.get(8, units.dyn25)
    enemies.get(15,"player",false,true) -- makes enemies.yards15f
    enemies.get(25)
    enemies.get(25,"player",false,true)
    enemies.rect.get(8,15,false)
    enemies.rect.get(6,40,false)

    -- Cancel if casting with no enemies
    if #enemies.yards25f == 0 then
        if var.fireBreathStage > 0 then cast.cancel.fireBreath() end
        if var.eternitySurgeStage > 0 then cast.cancel.eternitySurge() end
    end

    -- Cancel Disintegrate
    -- buff.dragonrage.up&ticks>=2
    if cast.current.disintegrate() and buff.dragonrage.exists() and cast.timeRemain() <= (cast.time.disintegrate() / 3) * 2 then
        cast.cancel.disintegrate()
    end

    -- Numeric Conversion
    var.eternitySpan = talent.eternitys_span and 1 or 0
    var.spellHaste = (unit.spellHaste() / 100)
    var.tipTheScales = not buff.tipTheScales.exists() and 1 or 0
    var.essenceBurstMaxStacks = talent.essenceAttunement and 2 or 1
    var.dragonrage = ui.alwaysCdAoENever("Dragonrage",1,25) and cd.dragonrage.remains() or 999

    -- SimC variables
    -- variable,name=next_dragonrage,value=cooldown.dragonrage.remains<?(cooldown.eternity_surge.remains-2*gcd.max)<?(cooldown.fire_breath.remains-gcd.max)
    var.nextDragonrage = math.max(var.dragonrage, (cd.eternitySurge.remains() - 2 * unit.gcd(true)), (cd.fireBreath.remains() - unit.gcd(true)))
    -- variable,name=r1_cast_time,value=1.3*spell_haste
    var.r1CastTime = 1.3 * var.spellHaste

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
        -- Check for combat
        if unit.inCombat() or (not unit.inCombat() and unit.valid("target")) and (cd.global.remain() == 0 or var.fireBreathStage > 0 or var.eternitySurgeStage > 0) then
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                -----------------
                --- Interrupt ---
                -----------------
                if actionList.Interrupts() then return true end
                ------------
                --- Main ---
                ------------
                -- Run Action List - AOE
                -- run_action_list,name=aoe,if=spell_targets.pyre>=3
                if ui.useAOE(8,3,units.dyn25) then
                    if actionList.AoE() then return true end
                end
                -- Run Action List - ST
                -- run_action_list,name=st
                if ui.useST(8,3,units.dyn25) then
                    if actionList.ST() then return true end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 1467 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation
})