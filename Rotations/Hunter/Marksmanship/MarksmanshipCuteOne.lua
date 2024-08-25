-------------------------------------------------------
-- Author = CuteOne
-- Patch = 11.0.2
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 100%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Limited
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Raid
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "CuteOne"
br.loadSupport("PetCuteOne")
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spells.aimedShot },
        [2] = { mode = "Mult", value = 2, overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spells.multishot },
        [3] = { mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spells.arcaneShot },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.aspectOfTheCheetah }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.trueshot },
        [2] = { mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.trueshot },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.trueshot }
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.aspectOfTheTurtle },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.aspectOfTheTurtle }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.counterShot },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.counterShot }
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
    -- MD Button
    local MisdirectionModes = {
        [1] = { mode = "On", value = 1, overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spells.misdirection },
        [2] = { mode = "Off", value = 2, overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spells.misdirection }
    };
    br.ui:createToggle(MisdirectionModes, "Misdirection", 5, 0)
    -- Volley Button
    local VolleyModes = {
        [1] = { mode = "On", value = 1, overlay = "Volley Enabled", tip = "Volley Enabled", highlight = 1, icon = br.player.spells.volley },
        [2] = { mode = "Off", value = 2, overlay = "Volley Disabled", tip = "Volley Disabled", highlight = 0, icon = br.player.spells.volley }
    };
    br.ui:createToggle(VolleyModes, "Volley", 6, 0)
    --Pet summon
    local PetSummonModes = {
        [1] = { mode = "1", value = 1, overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spells.callPet1 },
        [2] = { mode = "2", value = 2, overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spells.callPet2 },
        [3] = { mode = "3", value = 3, overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spells.callPet3 },
        [4] = { mode = "4", value = 4, overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spells.callPet4 },
        [5] = { mode = "5", value = 5, overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spells.callPet5 },
        [6] = { mode = "None", value = 6, overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spells.talents.loneWolf }
    };
    br.ui:createToggle(PetSummonModes, "PetSummon", 7, 0)
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
        --- General Options ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5,
            "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Hunter's Mark
        br.ui:createDropdownWithout(section, "Hunter's Mark", alwaysCdNever, 2, "|cffFFFFFFWhen to use Hunter's Mark")
        -- Misdirection
        br.ui:createDropdownWithout(section, "Misdirection", { "|cff00FF00Tank", "|cffFFFF00Focus", "|cffFF0000Pet" }, 1,
            "|cffFFFFFFWho to use Misdirection on.")
        -- Tar Trap
        br.ui:createCheckbox(section, "Tar Trap")
        -- Volly Units
        br.ui:createSpinnerWithout(section, "Volley Units", 3, 1, 5, 1,
            "|cffFFFFFFSet minimal number of units to cast Volley on")
        br.ui:checkSectionState(section)
        -------------------
        --- Pet Options ---
        -------------------
        br.rotations.support["PetCuteOne"].options()
        ------------------------
        --- Cooldown Options ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Module: Combat Potion Up
        br.player.module.CombatPotionUp(section)
        -- Racial
        br.ui:createCheckbox(section, "Racial")
        -- Barrage
        br.ui:createDropdownWithout(section, "Barrage", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use ability.")
        -- Explosive Shot
        br.ui:createDropdownWithout(section, "Explosive Shot", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use ability.")
        -- Salvo
        br.ui:createDropdownWithout(section, "Salvo", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use ability.")
        -- Trueshot
        br.ui:createDropdownWithout(section, "Trueshot", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use ability.")
        -- Volley
        br.ui:createDropdownWithout(section, "Volley", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use ability.")
        -- Wailing Arrow
        br.ui:createDropdownWithout(section, "Wailing Arrow", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use ability.")
        br.ui:checkSectionState(section)
        -------------------------
        --- Defensive Options ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Aspect of the Turtle
        br.ui:createSpinner(section, "Aspect Of The Turtle", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.");
        -- Bursting Shot
        br.ui:createSpinner(section, "Bursting Shot", 1, 1, 10, 1, "|cffFFBB00Number of Enemies within 8yrds to use at.")
        -- Concussive Shot
        br.ui:createSpinner(section, "Concussive Shot", 10, 5, 40, 5, "|cffFFBB00Minmal range to use at.")
        -- Disengage
        br.ui:createSpinner(section, "Disengage", 5, 5, 40, 5, "|cffFFBB00Minmal range to use at.")
        -- Exhilaration
        br.ui:createSpinner(section, "Exhilaration", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.");
        -- Feign Death
        br.ui:createSpinner(section, "Feign Death", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Survival of the Fittest
        br.ui:createSpinner(section, "Survival of the Fittest", 35, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Tranquilizing Shot
        br.ui:createDropdown(section, "Tranquilizing Shot", { "|cff00FF00Any", "|cffFFFF00Target" }, 2,
            "|cffFFFFFFHow to use Tranquilizing Shot.")
        br.ui:checkSectionState(section)
        -------------------------
        --- Interrupt Options ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Counter Shot
        br.ui:createCheckbox(section, "Counter Shot")
        -- Freezing Trap
        br.ui:createCheckbox(section, "Freezing Trap")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5, "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        --------------------------
        --- Toggle Key Options ---
        --------------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle, 6)
        -- Cooldown Key Toggle
        br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle, 6)
        -- Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
        -- Volley Key Toggle
        br.ui:createDropdownWithout(section, "Volley Mode", br.dropOptions.Toggle, 6)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
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
local actionList = {}
local buff
local cast
local cd
local charges
local debuff
local enemies
local focus
local module
local talent
local ui
local unit
local units
local use
local var

-----------------------
--- Local Functions ---
-----------------------

-- Multi-Dot HP Limit Set
local function canDoT(thisUnit)
    local unitHealthMax = unit.healthMax(thisUnit)
    if not unit.exists(units.dyn40) then return false end
    if not unit.isBoss(thisUnit) and unit.facing("player", thisUnit)
        and unit.isUnit(thisUnit, units.dyn40) and not unit.charmed(thisUnit)
    then
        return ((unitHealthMax > unit.healthMax("player") * 3)
            or (unit.health(thisUnit) < unitHealthMax and unit.ttd(thisUnit) > 10))
    end
    local maxHealth = 0
    for i = 1, #enemies.yards40f do
        local thisMaxHealth = unit.healthMax(enemies.yards40f[i])
        if thisMaxHealth > maxHealth then
            maxHealth = thisMaxHealth
        end
    end
    return unitHealthMax > maxHealth / 10
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    -- Feign Death
    if buff.feignDeath.exists() then
        unit.stopAttack()
        unit.clearTarget()
    end
    -- Hunter's Mark
    if ui.alwaysCdNever("Hunter's Mark") and cast.able.huntersMark("target") and not debuff.huntersMark.exists("target")
        and not unit.friend("target") and unit.hp("target") > 80
    then
        if cast.huntersMark("target") then
            ui.debug("Cast Hunter's Mark")
            return true
        end
    end
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing")) * 60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                br._G.PetStopAttack()
                br._G.PetFollow()
                ui.print(tonumber(ui.value("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Misdirection
    if ui.mode.misdirection == 1 then
        local misdirectUnit = nil
        if unit.valid("target") and unit.distance("target") < 50 and not unit.isCasting("player") and not buff.playDead.exists("pet") then
            -- Misdirect to Tank
            if ui.value("Misdirection") == 1 then
                local tankInRange, tankUnit = unit.isTankInRange()
                if tankInRange then misdirectUnit = tankUnit end
            end
            -- Misdirect to Focus
            if ui.value("Misdirection") == 2 and unit.friend("focus", "player") then
                misdirectUnit = "focus"
            end
            -- Misdirect to Pet
            if ui.value("Misdirection") == 3 then
                misdirectUnit = "pet"
            end
            -- Failsafe to Pet, if unable to misdirect to Tank or Focus
            if misdirectUnit == nil then misdirectUnit = "pet" end
            if misdirectUnit and cast.able.misdirection() and unit.exists(misdirectUnit) and unit.distance(misdirectUnit) < 50 and not unit.deadOrGhost(misdirectUnit) then
                if cast.misdirection(misdirectUnit) then
                    ui.debug("Casting Misdirection on " .. unit.name(misdirectUnit))
                    return true
                end
            end
        end
    end
    -- Tar Trap
    if ui.checked("Tar Trap") and cast.able.tarTrap("target", "ground", 1, 8) and unit.distance(units.dyn40) > 8 then
        if cast.tarTrap("target", "ground", 1, 8) then
            ui.debug("Casting Tar Trap")
            var.tarred = true
            return true
        end
    end
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Aspect of the Turtle
        if ui.checked("Aspect Of The Turtle") and unit.hp() <= ui.value("Aspect Of The Turtle") then
            if cast.aspectOfTheTurtle("player") then
                ui.debug("Casting Aspect of the Turtle")
                return true
            end
        end
        -- Bursting Shot
        if ui.checked("Bursting Shot") and #enemies.yards8f >= ui.value("Bursting Shot") and unit.inCombat() then
            if cast.burstingShot("player") then
                ui.debug("Casting Bursting Shot")
                return true
            end
        end
        -- Concussive Shot
        if ui.checked("Concussive Shot") and talent.concussiveShot and unit.distance("target") < ui.value("Concussive Shot")
            and unit.valid("target") and unit.facing("target") and unit.ttd("target") > unit.gcd(true)
            and unit.moving("target")
        then
            if cast.concussiveShot("target") then
                ui.debug("Casting Concussive Shot")
                return true
            end
        end
        -- Disengage
        if ui.checked("Disengage") and unit.distance("target") < ui.value("Disengage") and unit.valid("target") then
            if cast.disengage("player") then
                ui.debug("Casting Disengage")
                return true
            end
        end
        -- Exhilaration
        if ui.checked("Exhilaration") and unit.hp() <= ui.value("Exhilaration") then
            if cast.exhilaration("player") then
                ui.debug("Casting Exhilaration")
                return true
            end
        end
        -- Feign Death
        if ui.checked("Feign Death") and unit.hp() <= ui.value("Feign Death") then
            if cast.feignDeath("player") then
                ui.debug("Casting Feign Death")
                return true
            end
        end
        -- Survival of the Fittest
        if ui.checked("Survival of the Fittest") and unit.hp() <= ui.value("Survival of the Fittest") then
            if cast.survivalOfTheFittest("player") then
                ui.debug("Casting Survival of the Fittest")
                return true
            end
        end
        -- Tranquilizing Shot
        if ui.checked("Tranquilizing Shot") then
            if #enemies.yards40f > 0 then
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if ui.value("Tranquilizing Shot") == 1 or (ui.value("Tranquilizing Shot") == 2 and unit.isUnit(thisUnit, "target")) then
                        if unit.valid(thisUnit) and cast.dispel.tranquilizingShot(thisUnit) then
                            if cast.tranquilizingShot(thisUnit) then
                                ui.debug("Casting Tranquilizing Shot")
                                return true
                            end
                        end
                    end
                end
            end
        end
        -- Wing Clip
        if ui.checked("Wing Clip") and not talent.concussiveShot and cast.able.wingClip()
            and unit.exists(units.dyn5) and unit.ttd(units.dyn5) > 2 and unit.distance(units.dyn5) < 5
        then
            if cast.wingClip() then
                ui.debug("Casting Wing Clip")
                return true
            end
        end
    end -- End Defensive Toggle
end     -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            local distance = unit.distance(thisUnit)
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                if distance < 50 then
                    -- Counter Shot
                    if ui.checked("Counter Shot") then
                        if cast.counterShot(thisUnit) then
                            ui.debug("Casting Counter Shot")
                            return true
                        end
                    end
                    -- Freezing Trap
                    if ui.checked("Freezing Trap") then
                        if cast.freezingTrap(thisUnit, "ground") then
                            ui.debug("Casting Freezing Trap")
                            return true
                        end
                    end
                end
            end
        end
    end -- End useInterrupts check
end     -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if ui.useCDs() then
        -- Berserking
        -- berserking,if=buff.trueshot.up|fight_remains<13
        if ui.checked("Racial") and unit.race() == "Troll" and cast.able.berserking() and ((buff.trueshot.exists() or unit.ttdGroup(40) < 13)) then
            if cast.berserking() then
                ui.debug("Casting Berserking [Cooldowns]")
                return true
            end
        end
        -- Blood Fury
        -- blood_fury,if=buff.trueshot.up|cooldown.trueshot.remains>30|fight_remains<16
        if ui.checked("Racial") and unit.race() == "Orc" and cast.able.bloodFury() and ((buff.trueshot.exists() or cd.trueshot.remains() > 30 or unit.ttdGroup(40) < 16)) then
            if cast.bloodFury() then
                ui.debug("Casting Blood Fury [Cooldowns]")
                return true
            end
        end
        -- Ancestral Call
        -- ancestral_call,if=buff.trueshot.up|cooldown.trueshot.remains>30|fight_remains<16
        if ui.checked("Racial") and unit.race() == "MagharOrc" and cast.able.ancestralCall() and ((buff.trueshot.exists() or cd.trueshot.remains() > 30 or unit.ttdGroup(40) < 16)) then
            if cast.ancestralCall() then
                ui.debug("Casting Ancestral Call [Cooldowns]")
                return true
            end
        end
        -- Fireblood
        -- fireblood,if=buff.trueshot.up|cooldown.trueshot.remains>30|fight_remains<9
        if ui.checked("Racial") and unit.race() == "DarkIronDwarf" and cast.able.fireblood() and ((buff.trueshot.exists() or cd.trueshot.remains() > 30 or unit.ttdGroup(40) < 9)) then
            if cast.fireblood() then
                ui.debug("Casting Fireblood [Cooldowns]")
                return true
            end
        end
        -- Lights Judgment
        -- lights_judgment,if=buff.trueshot.down
        if ui.checked("Racial") and unit.race() == "LightforgedDraenei" and cast.able.lightsJudgment("target", "ground") and not buff.trueshot.exists() then
            if cast.lightsJudgment("target", "ground") then
                ui.debug("Casting Lights Judgment [Cooldowns]")
                return true
            end
        end
        -- Module - Combatpotion Up
        -- potion,if=buff.trueshot.up&(buff.bloodlust.up|target.health.pct<20)|fight_remains<26
        if buff.trueshot.exists()
            and (buff.bloodLust.exists() or unit.hp(units.dyn40) < 20)
            or unit.ttdGroup(40) < 26
        then
            module.CombatPotionUp()
        end
        -- Salvo
        -- salvo,if=active_enemies>2|cooldown.volley.remains<10
        if ui.alwaysCdAoENever("Salvo", 1, #enemies.yards8t) and cast.able.salvo() and ((#enemies.yards8t > 2 or cd.volley.remains() < 10)) then
            if cast.salvo() then
                ui.debug("Casting Salvo [Cooldowns]")
                return true
            end
        end
    end
end -- End Action List - Cooldowns

-- Action List - Trinkets
actionList.Trinkets = function()
    -- Variable - Sync Ready
    -- variable,name=sync_ready,value=variable.trueshot_ready
    var.syncReady = var.trueshotReady

    -- Variable - Sync Active
    -- variable,name=sync_active,value=buff.trueshot.up
    var.syncActive = buff.trueshot.exists()

    -- Variable - Sync Remains
    -- variable,name=sync_remains,value=cooldown.trueshot.remains_guess
    -- TODO

    -- Use Item - Use Off Gcd=1
    -- use_item,use_off_gcd=1,slot=trinket1,if=trinket.1.has_use_buff&(variable.sync_ready&(variable.trinket_1_stronger|trinket.2.cooldown.remains)|!variable.sync_ready&(variable.trinket_1_stronger&(variable.sync_remains>trinket.1.cooldown.duration%3&fight_remains>trinket.1.cooldown.duration+20|trinket.2.has_use_buff&trinket.2.cooldown.remains>variable.sync_remains-15&trinket.2.cooldown.remains-5<variable.sync_remains&variable.sync_remains+45>fight_remains)|variable.trinket_2_stronger&(trinket.2.cooldown.remains&(trinket.2.cooldown.remains-5<variable.sync_remains&variable.sync_remains>=20|trinket.2.cooldown.remains-5>=variable.sync_remains&(variable.sync_remains>trinket.1.cooldown.duration%3|trinket.1.cooldown.duration<fight_remains&(variable.sync_remains+trinket.1.cooldown.duration>fight_remains)))|trinket.2.cooldown.ready&variable.sync_remains>20&variable.sync_remains<trinket.2.cooldown.duration%3)))|!trinket.1.has_use_buff&(trinket.1.cast_time=0|!variable.sync_active)&(!trinket.2.has_use_buff&(variable.trinket_1_stronger|trinket.2.cooldown.remains)|trinket.2.has_use_buff&(variable.sync_remains>20|trinket.2.cooldown.remains>20))|fight_remains<25&(variable.trinket_1_stronger|trinket.2.cooldown.remains)
    -- TODO

    -- Use Item - Use Off Gcd=1
    -- use_item,use_off_gcd=1,slot=trinket2,if=trinket.2.has_use_buff&(variable.sync_ready&(variable.trinket_2_stronger|trinket.1.cooldown.remains)|!variable.sync_ready&(variable.trinket_2_stronger&(variable.sync_remains>trinket.2.cooldown.duration%3&fight_remains>trinket.2.cooldown.duration+20|trinket.1.has_use_buff&trinket.1.cooldown.remains>variable.sync_remains-15&trinket.1.cooldown.remains-5<variable.sync_remains&variable.sync_remains+45>fight_remains)|variable.trinket_1_stronger&(trinket.1.cooldown.remains&(trinket.1.cooldown.remains-5<variable.sync_remains&variable.sync_remains>=20|trinket.1.cooldown.remains-5>=variable.sync_remains&(variable.sync_remains>trinket.2.cooldown.duration%3|trinket.2.cooldown.duration<fight_remains&(variable.sync_remains+trinket.2.cooldown.duration>fight_remains)))|trinket.1.cooldown.ready&variable.sync_remains>20&variable.sync_remains<trinket.1.cooldown.duration%3)))|!trinket.2.has_use_buff&(trinket.2.cast_time=0|!variable.sync_active)&(!trinket.1.has_use_buff&(variable.trinket_2_stronger|trinket.1.cooldown.remains)|trinket.1.has_use_buff&(variable.sync_remains>20|trinket.1.cooldown.remains>20))|fight_remains<25&(variable.trinket_2_stronger|trinket.1.cooldown.remains)
    -- TODO
end -- End Action List - Trinkets

-- Action List - Trickshots
actionList.Trickshots = function()
    -- Steady Shot
    -- steady_shot,if=talent.steady_focus&steady_focus_count&buff.steady_focus.remains<8
    if cast.able.steadyShot() and cast.timeSinceLast.steadyShot() > unit.gcd("true") and not cast.current.steadyShot()
        and talent.steadyFocus and buff.steadyFocus.count() < 2 and buff.steadyFocus.remains() < 8
    then
        if cast.steadyShot() then
            ui.debug("Casting Steady Shot [Trickshots - Steady Focus]")
            return true
        end
    end
    -- Explosive Shot
    -- explosive_shot
    if ui.alwaysCdAoENever("Explosive Shot", 3, #enemies.yards8t) and cast.able.explosiveShot(units.dyn40, "aoe", 3, 8)
        and talent.explosiveShot and unit.ttd(units.dyn40) > 3
    then
        if cast.explosiveShot(units.dyn40, "aoe", 3, 8) then
            ui.debug("Casting Explosive Shot [Trickshots]")
            return true
        end
    end
    -- Volley
    -- volley
    if ui.alwaysCdAoENever("Volley", ui.value("Volley Units"), 8) and cast.able.volley("target", "ground", ui.value("Volley Units"), 8)
        and ui.mode.volley == 1 and #enemies.yards8t >= ui.value("Volley Units")
    then
        if cast.volley("target", "ground", ui.value("Volley Units"), 8) then
            ui.debug("Casting Volley [Trickshots]")
            return true
        end
    end
    -- Barrage
    -- barrage,if=talent.rapid_fire_barrage&buff.trick_shots.remains>=execute_time
    if ui.alwaysCdAoENever("Barrage", 3, #enemies.yards8t) and cast.able.barrage() and talent.barrage and talent.rapidFireBarrage
        and buff.trickShots.remains() >= cast.time.barrage()
    then
        if cast.barrage() then
            ui.debug("Casting Barrage [Trickshots]")
            return true
        end
    end
    -- Rapid Fire
    -- rapid_fire,if=buff.trick_shots.remains>=execute_time
    if cast.able.rapidFire() and buff.trickShots.remains() >= cast.time.rapidFire() then
        if cast.rapidFire() then
            ui.debug("Casting Rapid Fire [Trickshots]")
            return true
        end
    end
    -- Kill Shot
    -- kill_shot,if=buff.razor_fragments.up
    if cast.able.killShot(var.lowestHPUnit) and var.useKillShot and buff.razorFragments.exists() then
        if cast.killShot(var.lowestHPUnit) then
            ui.debug("Casting Kill Shot [Trickshots - Razor Fragments]")
            return true
        end
    end
    -- Black Arrow
    -- black_arrow
    if cast.able.blackArrow() then
        if cast.blackArrow() then
            ui.debug("Casting Black Arrow [Trickshots]")
            return true
        end
    end
    -- Wailing Arrow
    -- wailing_arrow,if=buff.precise_shots.down
    if ui.alwaysCdAoENever("Wailing Arrow", 3, #enemies.yards40f) and talent.wailingArrow and cast.able.wailingArrow(units.dyn40, "aoe", 3, 8) and not buff.preciseShots.exists() then
        if cast.wailingArrow(units.dyn40, "aoe", 3, 8) then
            ui.debug("Casting Wailing Arrow [Trickshots]")
            return true
        end
    end
    -- Trueshot
    -- trueshot,if=variable.trueshot_ready
    if ui.alwaysCdAoENever("Trueshot", 3, #enemies.yards40) and cast.able.trueshot("player") and var.trueshotReady then
        if cast.trueshot("player") then
            ui.debug("Casting Trueshot [Trickshots]")
            return true
        end
    end
    -- Aimed Shot
    -- aimed_shot,target_if=min:dot.serpent_sting.remains+action.serpent_sting.in_flight_to_target*99,if=buff.trick_shots.remains>=execute_time&buff.precise_shots.down
    if cast.able.aimedShot(var.minSerpentStingInFlightUnit) and not unit.moving("player")
        and buff.trickShots.remains() >= cast.time.aimedShot() and not buff.preciseShots.exists()
    then
        if cast.aimedShot(var.minSerpentStingInFlightUnit) then
            ui.debug("Casting Aimed Shot [Trickshots]")
            return true
        end
    end
    -- Multishot
    -- multishot,if=buff.trick_shots.down|buff.precise_shots.up|focus>cost+action.aimed_shot.cost
    if cast.able.multishot(units.dyn40, "aoe", 1, 10)
        and (not buff.trickShots.exists() or buff.preciseShots.exists() or focus() > var.multishotCost + var.aimedShotCost)
    then
        if cast.multishot(units.dyn40, "aoe", 1, 10) then
            ui.debug("Casting Multishot [Trickshots]")
            return true
        end
    end
    -- Bag Of Tricks
    -- bag_of_tricks,if=buff.trueshot.down
    if ui.checked("Racial") and unit.race() == "Vulpera" and cast.able.bagOfTricks() and not buff.trueshot.exists() then
        if cast.bagOfTricks() then
            ui.debug("Casting Bag Of Tricks [St]")
            return true
        end
    end
    -- Steady Shot
    -- steady_shot
    if cast.able.steadyShot() and unit.ttd(units.dyn40) > cast.time.steadyShot()
        and ((not buff.preciseShots.exists() or focus() < 20) and focus() <= var.multishotCost + var.aimedShotCost)
        and cast.timeSinceLast.steadyShot() > unit.gcd("true") and not cast.current.steadyShot()
    then
        if cast.steadyShot() then
            ui.debug("Casting Steady Shot [Trickshots]")
            return true
        end
    end
end -- End Action List - Trickshots

-- Action List - St
actionList.St = function()
    -- Steady Shot
    -- steady_shot,if=talent.steady_focus&steady_focus_count&buff.steady_focus.remains<8
    if cast.able.steadyShot() and cast.timeSinceLast.steadyShot() > unit.gcd("true") and not cast.current.steadyShot()
        and talent.steadyFocus and buff.steadyFocus.count() < 2 and buff.steadyFocus.remains() < 8
    then
        if cast.steadyShot() then
            ui.debug("Casting Steady Shot [St - Steady Focus]")
            return true
        end
    end
    -- Kill Shot
    -- kill_shot,if=buff.razor_fragments.up
    if cast.able.killShot(var.lowestHPUnit) and var.useKillShot and buff.razorFragments.exists() then
        if cast.killShot(var.lowestHPUnit) then
            ui.debug("Casting Kill Shot [St - Razor Fragments]")
            return true
        end
    end
    -- Black Arrow
    -- black_arrow
    if cast.able.blackArrow() then
        if cast.blackArrow() then
            ui.debug("Casting Black Arrow [St]")
            return true
        end
    end
    -- Explosive Shot
    -- explosive_shot,if=active_enemies>1
    if ui.alwaysCdAoENever("Explosive Shot", 1, #enemies.yards8t) and cast.able.explosiveShot(units.dyn40, "aoe", 1, 8)
        and talent.explosiveShot and unit.ttd(units.dyn40) > 3 and #enemies.yards8t > 1 then
        if cast.explosiveShot(units.dyn40, "aoe", 1, 8) then
            ui.debug("Casting Explosive Shot [St - Multiple Targets]")
            return true
        end
    end
    -- Volley
    -- volley
    if ui.alwaysCdAoENever("Volley", 1, 8) and cast.able.volley("target", "ground", 1, 8) and ui.mode.volley == 1 then
        if cast.volley("target", "ground", 1, 8) then
            ui.debug("Casting Volley [St]")
            return true
        end
    end
    -- Rapid Fire
    -- rapid_fire,if=!talent.lunar_storm|(!cooldown.lunar_storm.remains|cooldown.lunar_storm.remains>5)
    if cast.able.rapidFire() and (not talent.lunarStorm or (not cd.lunarStorm.exists() or cd.lunarStorm.remains() > 5)) then
        if cast.rapidFire() then
            ui.debug("Casting Rapid Fire [St - No Lunar Storm]")
            return true
        end
    end
    -- Trueshot
    -- trueshot,if=variable.trueshot_ready
    if ui.alwaysCdAoENever("Trueshot", 1, #enemies.yards40) and cast.able.trueshot() and var.trueshotReady then
        if cast.trueshot() then
            ui.debug("Casting Trueshot [St]")
            return true
        end
    end
    -- Multishot
    -- multishot,if=buff.salvo.up&!talent.volley
    if cast.able.multishot(units.dyn40, "aoe", 1, 10) and buff.salvo.exists() and not talent.volley then
        if cast.multishot(units.dyn40, "aoe", 1, 10) then
            ui.debug("Casting Multishot [St]")
            return true
        end
    end
    -- Wailing Arrow
    -- wailing_arrow
    if ui.alwaysCdAoENever("Wailing Arrow", 1, #enemies.yards40f) and talent.wailingArrow and cast.able.wailingArrow(units.dyn40, "aoe", 1, 8) then
        if cast.wailingArrow(units.dyn40, "aoe", 1, 8) then
            ui.debug("Casting Wailing Arrow [St]")
            return true
        end
    end
    -- Aimed Shot
    -- aimed_shot,target_if=min:dot.serpent_sting.remains+action.serpent_sting.in_flight_to_target*99,if=buff.precise_shots.down|(buff.trueshot.up|full_recharge_time<gcd+cast_time)&(active_enemies<2|!talent.chimaera_shot)|(buff.trick_shots.remains>execute_time&active_enemies>1)
    if cast.able.aimedShot(var.minSerpentStingInFlightUnit) and not unit.moving("player")
        and (not buff.preciseShots.exists() or (buff.trueshot.exists() or charges.aimedShot.timeTillFull() < unit.gcd() + cast.time.aimedShot())
            and (#enemies.yards40f < 2 or not talent.chimaeraShot) or (buff.trickShots.remains() > cast.time.aimedShot() and #enemies.yards40f > 1))
    then
        if cast.aimedShot(var.minSerpentStingInFlightUnit) then
            ui.debug("Casting Aimed Shot [St]")
            return true
        end
    end
    -- Steady Shot
    -- steady_shot,if=talent.steady_focus&buff.steady_focus.down&buff.trueshot.down
    if cast.able.steadyShot() and cast.timeSinceLast.steadyShot() > unit.gcd("true") and not cast.current.steadyShot()
        and talent.steadyFocus and not buff.steadyFocus.exists() and not buff.trueshot.exists()
    then
        if cast.steadyShot() then
            ui.debug("Casting Steady Shot [St - No Steady Focus]")
            return true
        end
    end
    -- Chimaera Shot
    -- chimaera_shot,if=buff.precise_shots.up
    if cast.able.chimaeraShot() and buff.preciseShots.exists() then
        if cast.chimaeraShot() then
            ui.debug("Casting Chimaera Shot [St]")
            return true
        end
    end
    -- Arcane Shot
    -- arcane_shot,if=buff.precise_shots.up
    if cast.able.arcaneShot() and buff.preciseShots.exists() then
        if cast.arcaneShot() then
            ui.debug("Casting Arcane Shot [St - Precise Shots]")
            return true
        end
    end
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot(var.lowestHPUnit) and var.useKillShot then
        if cast.killShot(var.lowestHPUnit) then
            ui.debug("Casting Kill Shot [St]")
            return true
        end
    end
    -- Barrage
    -- barrage,if=talent.rapid_fire_barrage
    if ui.alwaysCdAoENever("Barrage", 1, #enemies.yards8t) and cast.able.barrage() and talent.barrage and talent.rapidFireBarrage then
        if cast.barrage() then
            ui.debug("Casting Barrage [St]")
            return true
        end
    end
    -- Explosive Shot
    -- explosive_shot
    if ui.alwaysCdAoENever("Explosive Shot", 1, #enemies.yards8t) and cast.able.explosiveShot(units.dyn40, "aoe", 1, 8) and talent.explosiveShot and unit.ttd(units.dyn40) > 3 then
        if cast.explosiveShot(units.dyn40, "aoe", 1, 8) then
            ui.debug("Casting Explosive Shot [St]")
            return true
        end
    end
    -- Arcane Shot
    -- arcane_shot,if=focus>cost+action.aimed_shot.cost
    if cast.able.arcaneShot() and focus() > cast.cost.arcaneShot() + var.aimedShotCost then
        if cast.arcaneShot() then
            ui.debug("Casting Arcane Shot [St - High Focus]")
            return true
        end
    end
    -- Bag Of Tricks
    -- bag_of_tricks,if=buff.trueshot.down
    if ui.checked("Racial") and unit.race() == "Vulpera" and cast.able.bagOfTricks() and not buff.trueshot.exists() then
        if cast.bagOfTricks() then
            ui.debug("Casting Bag Of Tricks [St]")
            return true
        end
    end
    -- Steady Shot
    -- steady_shot
    if cast.able.steadyShot() and unit.ttd(units.dyn40) > cast.time.steadyShot()
        and ((not buff.preciseShots.exists() or focus() < 20) and focus() <= cast.cost.arcaneShot() + var.aimedShotCost)
        and cast.timeSinceLast.steadyShot() > unit.gcd("true") and not cast.current.steadyShot() then
        if cast.steadyShot() then
            ui.debug("Casting Steady Shot [St]")
            return true
        end
    end
end -- End Action List - St

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not buff.feignDeath.exists() then
        -- Module - Phial Up
        -- flask
        module.PhialUp()
        -- Module - Imbue Up
        -- augmentation
        module.ImbueUp()
        -- Summon Pet
        -- summon_pet,if=!talent.lone_wolf
        if actionList.PetManagement() then
            ui.debug("")
            return true
        end
        if unit.valid("target") and unit.distance("target") < 50 then
            -- Salvo
            -- salvo,precast_time=10
            if ui.alwaysCdAoENever("Salvo", 1, #enemies.yards8t) and cast.able.salvo() then
                if cast.salvo() then
                    ui.debug("Casting Salvo [Precombat]")
                    return true
                end
            end
            -- Aimed Shot
            -- aimed_shot,if=active_enemies<3&(!talent.volley|active_enemies<2)
            if cast.able.aimedShot("target") and not unit.moving("player")
                and cast.timeSinceLast.aimedShot() > unit.gcd("true") and not cast.current.aimedShot()
                and ((#enemies.yards40f < 3 and (not talent.volley or #enemies.yards40f < 2)))
            then
                if cast.aimedShot("target") then
                    ui.debug("Casting Aimed Shot [Precombat]")
                    return true
                end
            end
            -- Steady Shot
            -- steady_shot,if=active_enemies>2|talent.volley&active_enemies=2
            if cast.able.steadyShot("target") and ((#enemies.yards40f > 2 or talent.volley and #enemies.yards40f == 2)) then
                if cast.steadyShot("target") then
                    ui.debug("Casting Steady Shot [Precombat]")
                    return true
                end
            end
            -- Auto Shot
            if cast.able.autoShot("target") then
                if cast.autoShot("target") then
                    ui.debug("Casting Auto Shot [Pre-Pull]")
                    return true
                end
            end
        end
    end
end -- End Action List - Pre-Pull

-- Action List - Combat
actionList.Combat = function()
    if unit.inCombat() and not var.profileStop and unit.distance(units.dyn40) < 50 --and unit.valid(units.dyn40)
        and not cast.current.barrage() and not cast.current.rapidFire() and not cast.current.aimedShot() and not cast.current.steadyShot()
    then
        -- Auto Shot
        -- auto_shot
        if cast.able.autoShot("target") then
            if cast.autoShot("target") then
                br._G.PetAttack()
                ui.debug("Casting Auto Shot [Combat]")
                return true
            end
        end
        -- Call Action List - Cds
        -- call_action_list,name=cds
        if actionList.Cooldowns() then return true end
        -- Call Action List - Trinkets
        -- call_action_list,name=trinkets
        if actionList.Trinkets() then return true end
        -- Call Action List - St
        -- call_action_list,name=st,if=active_enemies<3|!talent.trick_shots
        if (ui.useST(10, 3, "target") or not talent.trickShots) then
            if actionList.St() then return true end
        end
        -- Call Action List - Trickshots
        -- call_action_list,name=trickshots,if=active_enemies>2
        if ui.useAOE(10, 3, "target") then
            if actionList.Trickshots() then return true end
        end
    end
end -- End Action List - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------------------------------
    --- Load Additional Rotation Files ---
    --------------------------------------
    if actionList.PetManagement == nil then
        actionList.PetManagement = br.rotations.support["PetCuteOne"].run
    end

    ---------------
    --- Defines ---
    ---------------
    buff    = br.player.buff
    cast    = br.player.cast
    cd      = br.player.cd
    charges = br.player.charges
    debuff  = br.player.debuff
    enemies = br.player.enemies
    focus   = br.player.power.focus
    module  = br.player.module
    talent  = br.player.talent
    ui      = br.player.ui
    unit    = br.player.unit
    units   = br.player.units
    use     = br.player.use
    var     = br.player.variables

    units.get(5)
    units.get(40)
    enemies.get(8, "target")
    enemies.get(8, "player", false, true)
    enemies.get(40)
    enemies.get(40, "player", false, true)

    -- Variables
    if var.profileStop == nil then var.profileStop = false end
    var.haltProfile = (unit.inCombat() and var.profileStop) or (unit.mounted() or unit.flying()) or ui.pause() or
        buff.feignDeath.exists() or ui.mode.rotation == 4
    var.serpentInFlight = 0 --cast.inFlight.serpentSting() and 1 or 0
    var.aimedShotCost = talent.aimedShot and cast.cost.aimedShot() or 0
    var.multishotCost = talent.multishot and cast.cost.multishot() or 0

    -- Variable - Trueshot Ready
    -- variable,name=trueshot_ready,value=cooldown.trueshot.ready&(!raid_event.adds.exists&(!talent.bullseye|fight_remains>cooldown.trueshot.duration_guess+buff.trueshot.duration%2|buff.bullseye.stack=buff.bullseye.max_stack)&(!trinket.1.has_use_buff|trinket.1.cooldown.remains>30|trinket.1.cooldown.ready)&(!trinket.2.has_use_buff|trinket.2.cooldown.remains>30|trinket.2.cooldown.ready)|raid_event.adds.exists&(!raid_event.adds.up&(raid_event.adds.duration+raid_event.adds.in<25|raid_event.adds.in>60)|raid_event.adds.up&raid_event.adds.remains>10)|fight_remains<25)
    var.trueshotReady = (not cd.trueshot.exists() and ((not talent.bullseye or unit.ttdGroup(40) > cd.trueshot.duration() + buff.trueshot.duration() / 2
            or buff.bullseye.stack() == buff.bullseye.stackMax()) and (cd.slot.remains(13) > 30 or cd.slot.ready(13))
        and (cd.slot.remains(14) > 30 or cd.slot.ready(14)) or unit.ttdGroup(40) < 25))


    -- target_if=min:dot.serpent_sting.remains+action.serpent_sting.in_flight_to_target*99
    var.minSerpentStingInFlight = 99999
    var.minSerpentStingInFlightUnit = "target"
    for i = 1, #enemies.yards40f do
        local thisUnit = enemies.yards40f[i]
        local thisCondition = debuff.serpentSting.remains(thisUnit) + var.serpentInFlight * 99
        if thisCondition < var.minSerpentStingInFlight then
            var.minSerpentStingInFlight = thisCondition
            var.minSerpentStingInFlightUnit = thisUnit
        end
    end

    var.lowestHP = 100
    var.lowestHPUnit = "target"
    for i = 1, #enemies.yards40f do
        local thisUnit = enemies.yards40f[i]
        local thisCondition = unit.hp(thisUnit)
        if thisCondition > var.lowestHP then
            var.lowestHP = thisCondition
            var.lowestHPUnit = thisUnit
        end
    end

    var.useKillShot = unit.hp(var.lowestHPUnit) < 20 or buff.deathblow.exists()

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif var.haltProfile and (not unit.isCasting() or ui.pause(true) or ui.mode.rotation == 4 or buff.feignDeath.exists()) then
        unit.stopAttack()
        if unit.isDummy() then unit.clearTarget() end
        return true
    else
        if not cast.current.barrage() and not cast.current.rapidFire() and not cast.current.aimedShot() and not cast.current.steadyShot() then
            -----------------------
            --- Extras Rotation ---
            -----------------------
            if actionList.Extras() then return true end
            --------------------------
            --- Defensive Rotation ---
            --------------------------
            if actionList.Defensive() then return true end
        end
        -----------------
        --- Pet Logic ---
        -----------------
        if actionList.PetManagement() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if unit.inCombat() and var.profileStop == false and unit.distance(units.dyn40) < 50 --and unit.valid(units.dyn40)
            and not cast.current.barrage() and not cast.current.rapidFire() and not cast.current.aimedShot() and not cast.current.steadyShot()
        then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end
            ------------------------
            --- In Combat - Main ---
            ------------------------
            -- Auto Shot
            if cast.able.autoShot(units.dyn40) then
                if cast.autoShot(units.dyn40) then
                    ui.debug("Casting Auto Shot")
                    return true
                end
            end
            -- Action List - Combat
            if actionList.Combat() then return true end
        end --End In Combat
    end     --End Rotation Logic
end         -- End runRotation
local id = 254
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
