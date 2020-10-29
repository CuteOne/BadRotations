local rotationName = "CuteOne"
local br = _G["br"]
loadSupport("PetCuteOne")
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
    -- BW Button
    BestialWrathModes = {
        [1] = { mode = "On", value = 1 , overlay = "Will use BW", tip = "Will use BW according to rotation", highlight = 1, icon = br.player.spell.bestialWrath },
        [2] = { mode = "Off", value = 2 , overlay = "Will hold BW", tip = "Will hold BW until toggled again", highlight = 0, icon = br.player.spell.bestialWrath }
    };
    CreateButton("BestialWrath",3,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.aspectOfTheTurtle },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.aspectOfTheTurtle }
    };
    CreateButton("Defensive",4,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterShot },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterShot }
    };
    CreateButton("Interrupt",5,0)
    -- MD Button
    MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("Misdirection",6,0)
    -- Murder of crows
    MurderOfCrowsModes = {
        [1] = { mode = "On", value = 1 , overlay = "Always use MoC", tip = "Will Use Murder of Crows At All Times", highlight = 1, icon = br.player.spell.aMurderOfCrows },
        [2] = { mode = "CD", value = 2 , overlay = "Use MoC only on Cooldowns", tip = "Will Use Murder of Crows Only on Cooldowns", highlight = 0, icon = br.player.spell.aMurderOfCrows }
    };
    CreateButton("MurderOfCrows",7,0)
    --Pet summon
    PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spell.callPet1 },
        [2] = { mode = "2", value = 2 , overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spell.callPet2 },
        [3] = { mode = "3", value = 3 , overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spell.callPet3 },
        [4] = { mode = "4", value = 4 , overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spell.callPet4 },
        [5] = { mode = "5", value = 5 , overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spell.callPet5 },
        [6] = { mode = "None", value = 6 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.callPet }
    };
    CreateButton("PetSummon",8,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            br.ui:createCheckbox(section, "Enemy Target Lock", "In Combat, Locks targetting to enemies to avoid shenanigans", 1)
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Beast Mode
            br.ui:createCheckbox(section, "Beast Mode", "|cffFFFFFFWARNING! Selecting this will attack everything!")
            -- AoE Units
            br.ui:createSpinnerWithout(section, "Units To AoE", 2, 1, 10, 1, "|cffFFFFFFSet to desired units to start AoE at.")
            -- Misdirection
            br.ui:createDropdownWithout(section,"Misdirection", {"|cff00FF00Tank","|cffFFFF00Focus","|cffFF0000Pet"}, 1, "|cffFFFFFFSelect target to Misdirect to.")
            -- Heart Essence
            br.ui:createCheckbox(section,"Use Essence")
            -- Opener
            br.ui:createCheckbox(section, "Opener")
        br.ui:checkSectionState(section)
        -- Pet Options
        br.rotations.support["PetCuteOne"].options()
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Agi Pot
            br.ui:createCheckbox(section,"Potion")
            -- FlaskUp Module
            br.player.module.FlaskUp("Agility",section)
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")
            br.ui:createCheckbox(section,"Power Reactor")
            br.ui:createCheckbox(section,"Ashvane's Razor Coral")
            br.ui:createCheckbox(section,"Pocket Sized Computation Device")
            -- Bestial Wrath
            br.ui:createDropdownWithout(section,"Bestial Wrath", {"|cff00FF00Boss","|cffFFFF00Always"}, 1, "|cffFFFFFFSelect Bestial Wrath Usage.")
            -- Trueshot
            br.ui:createCheckbox(section,"Aspect of the Wild")
            -- Stampede
            br.ui:createCheckbox(section,"Stampede")
            -- A Murder of Crows / Barrage
            br.ui:createCheckbox(section,"A Murder Of Crows / Barrage")
            -- Spitting Cobra
            br.ui:createCheckbox(section,"Spitting Cobra")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Aspect of the Turtle
            br.ui:createSpinner(section, "Aspect Of The Turtle",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Concussive Shot
            br.ui:createSpinner(section, "Concussive Shot", 10, 5, 40, 5, "|cffFFBB00Minmal range to use at.")
            -- Disengage
            br.ui:createSpinner(section, "Disengage", 5, 5, 40, 5, "|cffFFBB00Minmal range to use at.")
            -- Exhilaration
            br.ui:createSpinner(section, "Exhilaration",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Feign Death
            br.ui:createSpinner(section, "Feign Death", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Tranquilizing Shot
            br.ui:createDropdown(section, "Tranquilizing Shot", {"|cff00FF00Any","|cffFFFF00Target"}, 2,"|cffFFFFFFHow to use Tranquilizing Shot." )
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Counter Shot
            br.ui:createCheckbox(section,"Counter Shot")
            -- Intimidation
            br.ui:createCheckbox(section,"Intimidation")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  6)
            -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  6)
            -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local cd
local charges
local debuff
local enemies
local essence
local module
local opener
local power
local talent
local traits
local unit
local units
local ui
local var
-- General Locals
local actionList = {}
local minCount
-- Profile Specific Locals
local lowestBarbedShot

-----------------
--- Functions ---
-----------------
local function isTankInRange()
    if ui.checked("Auto Growl") then
        if #br.friend > 1 then
            for i = 1, #br.friend do
                local friend = br.friend[i]
                if friend.GetRole()== "TANK" and not unit.deadOrGhost(friend.unit) and unit.distance(friend.unit) < 100 then
                return true
                end
            end
        end
    end
    return false
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if var.getCombatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                StopAttack()
                ClearTarget()
                Print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Misdirection
    if ui.mode.misdirection == 1 then
        local misdirectUnit = nil
        if unit.valid("target") and unit.distance("target") < 40 then
            if ui.value("Misdirection") == 3 then
                misdirectUnit = "pet"
            end
            if ui.value("Misdirection") == 1 then
                for i = 1, #br.friend do
                    local thisFriend = br.friend[i].unit
                    if (thisFriend == "TANK" or UnitGroupRolesAssigned(thisFriend) == "TANK")
                        and not unit.deadOrGhost(thisFriend)
                    then
                        misdirectUnit = thisFriend
                    end
                end
            end
            if ui.value("Misdirection") == 2 and not unit.deadOrGhost("focus")
                and unit.friend("focus","player")
            then
                misdirectUnit = "focus"
            end
            if unit.exists(misdirectUnit) then
                if cast.misdirection(misdirectUnit) then ui.debug("Casting Misdirection on "..unit.name(misdirectUnit)) return true end
            end
        end
    end
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Aspect of the Turtle
        if ui.checked("Aspect Of The Turtle") and unit.hp() <= ui.value("Aspect Of The Turtle") then
            if cast.aspectOfTheTurtle("player") then ui.debug("Casting Aspect of the Turtle") return true end
        end
        -- Concussive Shot
        if ui.checked("Concussive Shot") and unit.distance("target") < ui.value("Concussive Shot") and unit.valid("target") then
            if cast.concussiveShot("target") then ui.debug("Casting Concussive Shot") return true end
        end
        -- Disengage
        if ui.checked("Disengage") and unit.distance("target") < ui.value("Disengage") and unit.valid("target") then
            if cast.disengage("player") then ui.debug("Casting Disengage") return true end
        end
        -- Exhilaration
        if ui.checked("Exhilaration") and unit.hp() <= ui.value("Exhilaration") then
            if cast.exhilaration("player") then ui.debug("Casting Exhilaration") return true end
        end
        -- Feign Death
        if ui.checked("Feign Death") and unit.hp() <= ui.value("Feign Death") then
            if cast.feignDeath("player") then ui.debug("Casting Feign Death") return true end
        end
        -- Tranquilizing Shot
        if ui.checked("Tranquilizing Shot") then
            if #enemies.yards40f > 0 then
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if ui.value("Tranquilizing Shot") == 1 or (ui.value("Tranquilizing Shot") == 2 and unit.isUnit(thisUnit,"target")) then
                        if unit.valid(thisUnit) and cast.dispel.tranquilizingShot(thisUnit) then
                            if cast.tranquilizingShot(thisUnit) then ui.debug("Casting Tranquilizing Shot") return true end
                        end
                    end
                end
            end
        end
    end -- End Defensive Toggle
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        local thisUnit
        -- Counter Shot
        if ui.checked("Counter Shot") then
            for i=1, #enemies.yards40f do
            thisUnit = enemies.yards40f[i]
                if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                    if cast.counterShot(thisUnit) then ui.debug("Casting Counter Shot") return true end
                end
            end
        end
        -- Intimidation
        if ui.checked("Intimidation") and not unit.deadOrGhost("pet") and unit.exists("pet") then
            for i=1, #enemies.yards40f do
                thisUnit = enemies.yards40f[i]
                if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                    if cast.intimidation(thisUnit) then ui.debug("Casting Intimidation") return true end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if ui.useCDs() then
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
        if ui.checked("Racial") and cast.able.racial() then --and cd.racial.remain() == 0 then
            -- ancestral_call,if=cooldown.bestial_wrath.remains>30
            -- fireblood,if=cooldown.bestial_wrath.remains>30
            if cd.bestialWrath.remain() > 30 and (unit.race() == "MagharOrc" or unit.race() == "DarkIronDwarf") then
                if cast.racial() then ui.debug("Casting Racial") return true end
            end
            -- berserking,if=buff.aspect_of_the_wild.up&(target.time_to_die>cooldown.berserking.duration+duration|(target.health.pct<35|!talent.killer_instinct.enabled))|target.time_to_die<13
            -- blood_fury,if=buff.aspect_of_the_wild.up&(target.time_to_die>cooldown.blood_fury.duration+duration|(target.health.pct<35|!talent.killer_instinct.enabled))|target.time_to_die<16
            if (buff.aspectOfTheWild.exists()
                and ((unit.race() == "Troll" and unit.ttd(units.dyn40) < 13) or (unit.race() == "Orc" and unit.ttd(units.dyn40) < 16))
                and (unit.ttd(units.dyn40) > cd.racial.remain() + buff.racial.remain()
                    or (unit.hp(units.dyn40) < 35 or not talent.killerInstinct)))
            then
                if cast.racial() then ui.debug("Casting Racial") return true end
            end
            -- lights_judgment,if=pet.cat.buff.frenzy.up&pet.cat.buff.frenzy.remains>gcd.max|!pet.cat.buff.frenzy.up
            if (buff.frenzy.exists("pet") and buff.frenzy.remain("pet") > unit.gcd(true) or not buff.frenzy.exists("pet") and unit.race() == "LightforgedDraenei") then
                if cast.racial() then ui.debug("Casting Racial") return true end
            end
        end
    end -- End useCooldowns check
    -- Potion
    -- -- potion,if=buff.bestial_wrath.up&buff.aspect_of_the_wild.up&target.health.pct<35|((consumable.potion_of_unbridled_fury|consumable.unbridled_fury)&target.time_to_die<61|target.time_to_die<26)
    -- Heart Essence
    if ui.checked("Use Essence") then
        -- Essence - Worldvein Resonance
        -- worldvein_resonance,if=(prev_gcd.1.aspect_of_the_wild|cooldown.aspect_of_the_wild.remains<gcd|target.time_to_die<20)|!essence.vision_of_perfection.minor
        if cast.able.worldveinResonance() and ui.useCDs()
            and ((cast.last.aspectOfTheWild() or cd.aspectOfTheWild.remain() < unit.gcd(true) or unit.ttd(units.dyn40) < 20)
            or not essence.visionOfPerfection.minor)
        then
            if cast.worldveinResonance() then ui.debug("Casting Worldvein Resonance") return true end
        end
        -- Essence - Guardian of Azeroth
        -- guardian_of_azeroth,if=cooldown.aspect_of_the_wild.remains<10|target.time_to_die>cooldown+duration|target.time_to_die<30
        if cast.able.guardianOfAzeroth() and ui.useCDs() and (cd.aspectOfTheWild.remain() < 10
            or unit.ttd(units.dyn40) > cd.guardianOfAzeroth.remain() + 180 or (unit.ttd(units.dyn40) < 30 and ui.useCDs()))
        then
            if cast.guardianOfAzeroth() then ui.debug("Casting Guardian of Azeroth") return true end
        end
        -- Essence - Ripple In Space
        -- ripple_in_space
        if cast.able.rippleInSpace() and ui.useCDs() then
            if cast.rippleInSpace() then ui.debug("Casting Ripple In Space") return true end
        end
        -- Essence - Memory of Lucid Dreams
        -- memory_of_lucid_dreams
        if cast.able.memoryOfLucidDreams() and ui.useCDs() then
            if cast.memoryOfLucidDreams() then ui.debug("Casting Memory of Lucid Dreams") return true end
        end
        -- Essence - Reaping Flames
        -- reaping_flames,if=target.health.pct>80|target.health.pct<=20|target.time_to_pct_20>30
        if cast.able.reapingFlames() and (unit.hp(units.dyn40) > 80 or unit.hp(units.dyn40) <= 20 or unit.ttd(units.dyn40,20) > 30) then
            if cast.reapingFlames() then ui.debug("Casting Reaping Flames") return true end
        end
    end
end -- End Action List - Cooldowns

-- Action List - Opener
actionList.Opener = function()
    -- Start Attack
    -- auto_attack
    if ui.checked("Opener") and ui.useCDs() and not opener.complete then
        if unit.valid("target") and unit.distance("target") < 40
            and unit.facing("player","target") and getSpellCD(61304) == 0
        then
            -- Begin
            if not opener.OPN1 then
                Print("Starting Opener")
                opener.count = opener.count + 1
                opener.OPN1 = true
                StartAttack()
                return
            -- Aspect of the Wild - No Primal Instincts
            elseif opener.OPN1 and not opener.AOW1 then
                if traits.primalInstincts.active then
                    opener.AOW1 = true
                    opener.count = opener.count - 1
                elseif cd.aspectOfTheWild.remain() > unit.gcd(true) then
                    castOpenerFail("aspectOfTheWild","AOW1",opener.count)
                elseif cast.able.aspectOfTheWild() then
                    castOpener("aspectOfTheWild","AOW1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Bestial Wrath
            elseif opener.AOW1 and not opener.BW1 then
                if cd.bestialWrath.remain() > unit.gcd(true) then
                    castOpenerFail("bestialWrath","BW1",opener.count)
                elseif cast.able.bestialWrath() then
                    castOpener("bestialWrath","BW1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Barbed Shot
            elseif opener.BW1 and not opener.BS1 then
                if charges.barbedShot.count() == 0 then
                    castOpenerFail("barbedShot","BS1",opener.count)
                elseif cast.able.barbedShot() then
                    castOpener("barbedShot","BS1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Barbed Shot 2 - Primal Instincts
            elseif opener.BS1 and not opener.BS2 then
                if not traits.primalInstincts.active then
                    opener.BS2 = true
                    opener.count = opener.count - 1
                elseif charges.barbedShot.count() == 0 then
                    castOpenerFail("barbedShot","BS2",opener.count)
                elseif cast.able.barbedShot() then
                    castOpener("barbedShot","BS2",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Kill Command - No Primal Instincts
            elseif opener.BS2 and not opener.KC1 then
                if traits.primalInstincts.active then
                    opener.KC1 = true
                    opener.count = opener.count - 1
                elseif cd.killCommand.remain() > unit.gcd(true) then
                    castOpenerFail("killCommand","KC1",opener.count)
                elseif cast.able.killCommand() then
                    castOpener("killCommand","KC1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Aspect of the Wild - Primal Instincts
            elseif opener.KC1 and not opener.AOW2 then
                if not traits.primalInstincts.active then
                    opener.AOW2 = true
                    opener.count = opener.count - 1
                elseif cd.aspectOfTheWild.remain() > unit.gcd(true) then
                    castOpenerFail("aspectOfTheWild","AOW2",opener.count)
                elseif cast.able.aspectOfTheWild() then
                    castOpener("aspectOfTheWild","AOW2",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- A Murder of Crows
            elseif opener.AOW2 and not opener.MOC1 then
                if not talent.aMurderOfCrows or cd.aMurderOfCrows.remain() > unit.gcd(true) then
                    castOpenerFail("aMurderOfCrows","MOC1",opener.count)
                elseif cast.able.aMurderOfCrows() then
                    castOpener("aMurderOfCrows","MOC1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Kill Command 2 - Primal Instincts
            elseif opener.MOC1 and not opener.KC2 then
                if not traits.primalInstincts.active then
                    opener.KC2 = true
                    opener.count = opener.count - 1
                elseif cd.killCommand.remain() > unit.gcd(true) then
                    castOpenerFail("killCommand","KC2",opener.count)
                elseif cast.able.killCommand() then
                    castOpener("killCommand","KC2",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Chimaera Shot
            elseif opener.KC2 and not opener.CHS1 then
                if not talent.chimaeraShot or cd.chimaeraShot.remain() > unit.gcd(true) then
                    castOpenerFail("chimaeraShot","CHS1",opener.count)
                elseif cast.able.chimaeraShot() then
                    castOpener("chimaeraShot","CHS1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Cobra Shot
            elseif opener.CHS1 and not opener.COS1 then
                if not cast.able.cobraShot() then
                    castOpenerFail("cobraShot","COS1",opener.count)
                elseif cast.able.cobraShot() then
                    castOpener("cobraShot","COS1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Kill Command 3
            elseif opener.COS1 and not opener.KC3 then
                if cd.killCommand.remain() > unit.gcd(true) then
                    castOpenerFail("killCommand","KC3",opener.count)
                elseif cast.able.killCommand() then
                    castOpener("killCommand","KC3",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Barbed Shot 3
            elseif opener.KC3 and not opener.BS3 then
                if charges.barbedShot.count() == 0 then
                    castOpenerFail("barbedShot","BS3",opener.count)
                elseif cast.able.barbedShot() then
                    castOpener("barbedShot","BS3",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Cobra Shot 2 - No Primal Instincts
            elseif opener.BS3 and not opener.COS2 then
                if traits.primalInstincts.active then
                    opener.COS2 = true;
                    opener.count = opener.count - 1
                elseif not cast.able.cobraShot() then
                    castOpenerFail("cobraShot","COS2",opener.count)
                elseif cast.able.cobraShot() then
                    castOpener("cobraShot","COS2",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Kill Command 4 - No Primal Instincts
            elseif opener.COS2 and not opener.KC4 then
                if traits.primalInstincts.active then
                    opener.KC4 = true;
                    opener.count = opener.count - 1
                elseif cd.killCommand.remain() > unit.gcd(true) then
                    castOpenerFail("killCommand","KC4",opener.count)
                elseif cast.able.killCommand() then
                    castOpener("killCommand","KC4",opener.count)
                end
                opener.count = opener.count + 1
                return
            elseif opener.KC4 and opener.OPN1 then
                Print("Opener Complete")
                opener.count = 0
                opener.complete = true
            end
        end
    elseif (unit.exists("target") and not ui.useCDs()) or not ui.checked("Opener") then
        opener.complete = true
    end
end -- End Action List - Opener

-- Action List - Single Target
actionList.St = function()
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot() and unit.hp(units.dyn40) < 20 then
        if cast.killShot() then ui.debug("Casting Kill Shot") return true end
    end
    -- BLoodshed
    -- bloodshed
    if cast.able.bloodshed() then
        if cast.bloodshed() then ui.debug("Casting Bloodshed") return true end
    end
    -- Barbed Shot
    -- barbed_shot,if=pet.main.buff.frenzy.up&pet.main.buff.frenzy.remains<gcd|cooldown.bestial_wrath.remains&(full_recharge_time<gcd|azerite.primal_instincts.enabled&cooldown.aspect_of_the_wild.remains<gcd)|cooldown.bestial_wrath.remains<12+gcd&talent.scent_of_blood.enabled
    if cast.able.barbedShot(br.petTarget) and ((buff.frenzy.exists("pet") and buff.frenzy.remain("pet") <= unit.gcd(true) + 0.1)
        or (cd.bestialWrath.remain() > unit.gcd(true) and (charges.barbedShot.timeTillFull() < unit.gcd(true)
        or (traits.primalInstincts.active and ui.checked("Aspect of the Wild") and ui.useCDs() and cd.aspectOfTheWild.remain() < unit.gcd(true)))
        or cd.bestialWrath.remains() < 12 + unit.gcd(true) and talent.scentOfBlood))
    then
        if cast.barbedShot(br.petTarget) then if br.petTarget ~= nil then ui.debug("[ST 1] Casting Barbed Shot on "..unit.name(br.petTarget)) else ui.debug("[ST 1] Casting Barbed Shot on nil") end return end
    end
    -- Essence - Concentrated Flame
    -- concentrated_flame,if=focus+focus.regen*gcd<focus.max&buff.bestial_wrath.down&(!dot.concentrated_flame_burn.remains&!action.concentrated_flame.in_flight)|full_recharge_time<gcd|target.time_to_die<5
    if ui.checked("Use Essence") and cast.able.concentratedFlame() then
         if (power.focus.amount() + power.focus.regen() * unit.gcd(true) < power.focus.max() and not buff.bestialWrath.exists()
            and (not debuff.concentratedFlame.exists(units.dyn40) and cast.timeSinceLast.concentratedFlame() >= 2))
            or charges.concentratedFlame.timeTillFull() < unit.gcd(true) or (unit.ttd(units.dyn40) < 5 and ui.useCDs())
        then
        	if cast.concentratedFlame() then ui.debug("Casting Concentrated Flame") return true end
    	end
    end
    -- Aspect of the Wild
    -- aspect_of_the_wild,if=buff.aspect_of_the_wild.down&(cooldown.barbed_shot.charges<1|!azerite.primal_instincts.enabled)
    if ui.checked("Aspect of the Wild") and ui.useCDs() and cast.able.aspectOfTheWild() and (unit.ttd(units.dyn40) > 15 or ui.useCDs())
        and not buff.aspectOfTheWild.exists() and (charges.barbedShot.count() < 1 or not traits.primalInstincts.active)
    then
        if cast.aspectOfTheWild() then ui.debug("Casting Aspect of the Wild") return true end
    end
    -- Stampede
    -- stampede,if=buff.aspect_of_the_wild.up&buff.bestial_wrath.up|target.time_to_die<15
    if ui.checked("Stampede") and talent.stampede and cast.able.stampede()
    and (buff.aspectOfTheWild.exists() and buff.bestialWrath.exists()) and (unit.ttd(units.dyn40) > 15 or ui.useCDs())
    then
        if cast.stampede() then ui.debug("Casting Stampede") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if ui.checked("A Murder Of Crows / Barrage") and ui.mode.murderOfCrows == 1 and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows") return true end
    end
    -- Essence - Focused Azerite Beam
    -- focused_azerite_beam,if=buff.bestial_wrath.down|target.time_to_die<5
    if ui.checked("Use Essence") and cast.able.focusedAzeriteBeam()
        and (not buff.bestialWrath.exists() or ((unit.ttd(units.dyn40) < 5 or unit.isDummy()) and ui.useCDs()))
        and (enemies.yards30r >= 3 or ui.useCDs())
    then
        if cast.focusedAzeriteBeam(nil,"rect",minCount, 30) then ui.debug("Casting Focused Azerite Beam") return true end
    end
    -- The Unbound Force
    -- the_unbound_force,if=buff.reckless_force.up|buff.reckless_force_counter.stack<10|target.time_to_die<5
    if ui.checked("Use Essence") and cast.able.theUnboundForce() and (buff.recklessForce.exists()
        or buff.recklessForceCounter.stack() < 10 or (unit.ttd(units.dyn40) < 5 and ui.useCDs()))
    then
        if cast.theUnboundForce() then ui.debug("Casting The Unbound Force") return true end
    end
    -- Bestial Wrath
    -- bestial_wrath,if=talent.scent_of_blood.enabled|talent.one_with_the_pack.enabled&buff.bestial_wrath.remains<gcd|buff.bestial_wrath.down&cooldown.aspect_of_the_wild.remains>15|target.time_to_die<15+gcd
    if ui.mode.bestialWrath == 1 and cast.able.bestialWrath()
        and (ui.value("Bestial Wrath") == 2 or (ui.value("Bestial Wrath") == 1 and ui.useCDs()))
        and (talent.scentOfBlood or talent.oneWithThePack and buff.bestialWrath.remain() < unit.gcd(true)
            or not buff.bestialWrath.exists() and (cd.aspectOfTheWild.remain() > 15 or not ui.checked("Aspect of the Wild"))
            or (unit.ttd(units.dyn40) < 15 + unit.gcd(true) or ui.useCDs()))
    then
        if cast.bestialWrath() then ui.debug("Casting Bestial Wrath") return true end
    end
    -- Barbed Shot
    -- barbed_shot,if=azerite.dance_of_death.rank>1&buff.dance_of_death.remains<gcd
    if cast.able.barbedShot(br.petTarget) and traits.danceOfDeath.rank > 1 and buff.danceOfDeath.remain() < unit.gcd(true) then
        if cast.barbedShot(br.petTarget) then if br.petTarget ~= nil then ui.debug("[ST 2] Casting Barbed Shot on "..unit.name(br.petTarget)) else ui.debug("[ST 2] Casting Barbed Shot on nil") end return end
    end
    -- Essence - Blood of the Enemy
    -- blood_of_the_enemy,if=buff.aspect_of_the_wild.remains>10+gcd|target.time_to_die<10+gcd
    if ui.checked("Use Essence") and cast.able.bloodOfTheEnemy() and (buff.aspectOfTheWild.remain() > 10 + unit.gcd(true)
        or not ui.checked("Aspect of the Wild") or (unit.ttd(units.dyn40) < 10 + unit.gcd(true) and ui.useCDs()))
    then
        if cast.bloodOfTheEnemy() then ui.debug("Casting Blood of the Enemy") return true end
    end
    -- Kill Command
    -- kill_command
    if cast.able.killCommand(br.petTarget) then
        if cast.killCommand(br.petTarget) then if br.petTarget ~= nil then ui.debug("[ST] Casting Kill Command on "..unit.name(br.petTarget)) else ui.debug("[ST] Casting Kill Command on nil") end return end
    end
    -- Racial - Bag of Tricks
    -- bag_of_tricks,if=buff.bestial_wrath.down|target.time_to_die<5
    -- Chimaera Shot
    -- chimaera_shot
    if cast.able.chimaeraShot() then
        if cast.chimaeraShot() then ui.debug("Casting Chimaera Shot") return true end
    end
    -- Dire Beast
    -- dire_beast
    if cast.able.direBeast() then
        if cast.direBeast() then ui.debug("Casting Dire Beast") return true end
    end
    -- Barbed Shot
    -- barbed_shot,if=talent.one_with_the_pack.enabled&charges_fractional>1.5|charges_fractional>1.8|cooldown.aspect_of_the_wild.remains<pet.main.buff.frenzy.duration-gcd&azerite.primal_instincts.enabled|target.time_to_die<9
    if cast.able.barbedShot(br.petTarget) and ((talent.oneWithThePack and charges.barbedShot.frac() > 1.5) or charges.barbedShot.frac() > 1.8
        or (cd.aspectOfTheWild.remain() < buff.frenzy.remain("pet") - unit.gcd(true) and traits.primalInstincts.active) or (unit.ttd(units.dyn40) < 9 and ui.useCDs()))
    then
        if cast.barbedShot(br.petTarget) then if br.petTarget ~= nil then ui.debug("[ST 3] Casting Barbed Shot on "..unit.name(br.petTarget)) else ui.debug("[ST 3] Casting Barbed Shot on nil") end return end
    end
    -- Essence - Purifying Blast
    -- purifying_blast,if=buff.bestial_wrath.down|target.time_to_die<8
    if ui.checked("Use Essence") and cast.able.purifyingBlast() and (not buff.bestialWrath.exists() or (unit.ttd(units.dyn40) < 8 and ui.useCDs())) then
        if cast.purifyingBlast("best", nil, 1, 8) then ui.debug("Casting Purifying Blast") return true end
    end
    -- Barrage
    -- barrage
    if ui.checked("A Murder Of Crows / Barrage") and cast.able.barrage() then
        if cast.barrage() then ui.debug("Casting Barrage") return true end
    end
    -- Cobra Shot
    -- cobra_shot,if=(focus-cost+focus.regen*(cooldown.kill_command.remains-1)>action.kill_command.cost|cooldown.kill_command.remains>1+gcd&cooldown.bestial_wrath.remains_guess>focus.time_to_max|buff.memory_of_lucid_dreams.up)&cooldown.kill_command.remains>1|target.time_to_die<3
    if cast.able.cobraShot() and (((power.focus.amount() - cast.cost.cobraShot() + power.focus.regen() * (cd.killCommand.remain() - 1) > cast.cost.killCommand()
        or (cd.killCommand.remain() > 1 + unit.gcd(true) and cd.bestialWrath.remains() > power.focus.ttm()) or buff.memoryOfLucidDreams.exists()) and cd.killCommand.remain() > 1)
        or unit.ttd(units.dyn40) < 3 and ui.useCDs())
    then
        if cast.cobraShot() then ui.debug("Casting Cobra Shot") return true end
    end
    -- Barbed Shot
    -- barbed_shot,if=pet.turtle.buff.frenzy.duration-gcd>full_recharge_time
    if cast.able.barbedShot(br.petTarget) and buff.frenzy.duration("pet") - unit.gcd(true) > charges.barbedShot.timeTillFull() then
        if cast.barbedShot(br.petTarget) then if br.petTarget ~= nil then ui.debug("[ST 4] Casting Barbed Shot on "..unit.name(br.petTarget)) else ui.debug("[ST 4] Casting Barbed Shot on nil") end return end
    end
    -- Cobra Shot - Low Level
    if cast.able.cobraShot() and unit.level() < 20 then
        if cast.cobraShot() then ui.debug("Casting Cobra Shot [Low Level]") return true end
    end
end -- End Action List - Single Target

-- Action List - Cleave
actionList.Cleave = function()
    -- Barbed Shot
    -- barbed_shot,target_if=min:dot.barbed_shot.remains,if=pet.main.buff.frenzy.up&pet.main.buff.frenzy.remains<=gcd.max|cooldown.bestial_wrath.remains<12+gcd&talent.scent_of_blood.enabled
    if cast.able.barbedShot(lowestBarbedShot) and buff.frenzy.exists("pet") and buff.frenzy.remain("pet") <= unit.gcd(true) + 0.1 or cd.bestialWrath.remains() < 12 + unit.gcd(true) and talent.scentOfBlood then
        if cast.barbedShot(lowestBarbedShot) then if lowestBarbedShot ~= nil then ui.debug("[AOE 1] Casting Barbed Shot on "..unit.name(lowestBarbedShot)) else ui.debug("[AOE 1] Casting Barbed Shot on nil") end return end
    end
    -- Multishot
    -- multishot,if=gcd.max-pet.cat.buff.beast_cleave.remains>0.25
    if cast.able.multishot() and unit.gcd(true) - buff.beastCleave.remain("pet") > 0.25 --buff.beastCleave.remain("pet") < unit.gcd(true) + 0.1
         and not unit.isExplosive("target")
    then
        if cast.multishot() then ui.debug("Casting Multishot [AOE]") return true end
    end
    -- Barbed Shot
    -- barbed_shot,target_if=min:dot.barbed_shot.remains,if=full_recharge_time<gcd.max&cooldown.bestial_wrath.remains
    if cast.able.barbedShot(lowestBarbedShot) and (charges.barbedShot.timeTillFull() < unit.gcd(true) and cd.bestialWrath.remain() > unit.gcd(true)) then
        if cast.barbedShot(lowestBarbedShot) then if lowestBarbedShot ~= nil then ui.debug("[AOE 2] Casting Barbed Shot on "..unit.name(lowestBarbedShot)) else ui.debug("[AOE 2] Casting Barbed Shot on nil") end return end
    end
    -- Aspect of the Wild
    -- aspect_of_the_wild
    if ui.checked("Aspect of the Wild") and not buff.aspectOfTheWild.exists() and ui.useCDs() and cast.able.aspectOfTheWild() and (unit.ttd(units.dyn40) > 15 or ui.useCDs()) then
        if cast.aspectOfTheWild() then ui.debug("Casting Aspect of the Wild [AOE]") return true end
    end
    -- Stampede
    -- stampede,if=buff.aspect_of_the_wild.up&buff.bestial_wrath.up|target.time_to_die<15
    if ui.checked("Stampede") and talent.stampede and cast.able.stampede()
        and (buff.aspectOfTheWild.exists() and buff.bestialWrath.exists()) and (unit.ttd(units.dyn40) > 15 or ui.useCDs())
    then
        if cast.stampede() then ui.debug("Casting Stampede [AOE]") return true end
    end
    -- Bestial Wrath
    -- bestial_wrath,if=talent.scent_of_blood.enabled|cooldown.aspect_of_the_wild.remains_guess>20|talent.one_with_the_pack.enabled|target.time_to_die<15
    if ui.mode.bestialWrath == 1 and cast.able.bestialWrath() and (ui.value("Bestial Wrath") == 2 or (ui.value("Bestial Wrath") == 1 and ui.useCDs()))
        and (talent.scentOfBlood or not ui.checked("Aspect of the Wild") or (ui.value("Bestial Wrath") == 2 and not ui.useCDs())
            or cd.aspectOfTheWild.remains() > 20 or talent.oneWithThePack or (unit.ttd(units.dyn40) > 15 or ui.useCDs()))
    then
        if cast.bestialWrath() then ui.debug("Casting Bestial Wrath [AOE]") return true end
    end
    -- if cast.able.barbedShot(lowestBarbedShot) and traits.danceOfDeath.rank > 1 and buff.danceOfDeath.remain() < unit.gcd(true) + 0.5 then
    --     if cast.barbedShot(lowestBarbedShot) then if lowestBarbedShot ~= nil then ui.debug("[AOE 3] Casting Barbed Shot on "..unit.name(lowestBarbedShot)) else ui.debug("[AOE 3] Casting Barbed Shot on nil") end return end
    -- end
    -- Chimaera Shot
    -- chimaera_shot
    if cast.able.chimaeraShot() then
        if cast.chimaeraShot() then ui.debug("Casting Chimaera Shot [AOE]") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if ui.checked("A Murder Of Crows / Barrage") and ui.mode.murderOfCrows == 1 and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [AOE]") return true end
    end
    -- Barrage
    -- barrage
    if ui.checked("A Murder Of Crows / Barrage") and cast.able.barrage() then
        if cast.barrage() then ui.debug("Casting Barrage [AOE]") return true end
    end
    -- Kill Command
    -- kill_command,if=active_enemies<4|!azerite.rapid_reload.enabled
    if cast.able.killCommand(br.petTarget) and (#enemies.yards8p < 4 or not traits.rapidReload.active) then
        if cast.killCommand(br.petTarget) then if br.petTarget ~= nil then ui.debug("[AOE] Casting Kill Command on "..unit.name(br.petTarget)) else ui.debug("[AOE] Casting Kill Command on nil") end return end
    end
    -- Dire Beast
    -- dire_beast
    if cast.able.direBeast() then
        if cast.direBeast() then ui.debug("Casting Dire Beast [AOE]") return true end
    end
    -- Barbed Shot
    -- barbed_shot,target_if=min:dot.barbed_shot.remains,if=pet.main.buff.frenzy.down&(charges_fractional>1.8|buff.bestial_wrath.up)|cooldown.aspect_of_the_wild.remains<pet.main.buff.frenzy.duration-gcd&azerite.primal_instincts.enabled|charges_fractional>1.4|target.time_to_die<9
    if cast.able.barbedShot(lowestBarbedShot) and (not buff.frenzy.exists("pet") and (charges.barbedShot.frac() > 1.8 or buff.bestialWrath.exists())
        or (traits.primalInstincts.active and ui.checked("Aspect of the Wild") and ui.useCDs() and cd.aspectOfTheWild.remain() < (buff.frenzy.remain("pet") - unit.gcd(true)))
        or (ui.useCDs() and unit.ttd(units.dyn40) < 9))
    then
        if cast.barbedShot(lowestBarbedShot) then if lowestBarbedShot ~= nil then ui.debug("[AOE 4] Casting Barbed Shot on "..unit.name(lowestBarbedShot)) else ui.debug("[AOE 4] Casting Barbed Shot on nil") end return end
    end
    -- Heart Essence
    if ui.checked("Use Essence") then
        -- Essence - Focused Azerite Beam
        -- focused_azerite_beam
        if ui.checked("Use Essence") and cast.able.focusedAzeriteBeam() and not buff.bestialWrath.exists()
            and (enemies.yards30r >= 3 or ui.useCDs())
        then
            if cast.focusedAzeriteBeam(nil,"rect",minCount, 30) then ui.debug("Casting Focused Azerite Beam [AOE]") return true end
        end
        -- Essence - Purifying Blast
        -- purifying_blast
        if cast.able.purifyingBlast() then
            if cast.purifyingBlast("best", nil, 1, 8) then ui.debug("Casting Purifying Blast [AOE]") return true end
        end
        -- Essence - Concentrated Flame
        -- concentrated_flame
        if cast.able.concentratedFlame() then
            if cast.concentratedFlame() then ui.debug("Casting Concentrated Flame [AOE]") return true end
        end
        -- Essence - Blood of the Enemy
        -- blood_of_the_enemy
        if cast.able.bloodOfTheEnemy() then
            if cast.bloodOfTheEnemy() then ui.debug("Casting Blood of the Enemy [AOE]") return true end
        end
        -- Essence - The Unbound Force
        -- the_unbound_force,if=buff.reckless_force.up|buff.reckless_force_counter.stack<10
        if cast.able.theUnboundForce() and (buff.recklessForce.exists() or buff.recklessForceCounter.stack() < 10) then
            if cast.theUnboundForce() then ui.debug("Casting The Unbound Force [AOE]") return true end
        end
    end
    -- Multishot
    -- multishot,if=azerite.rapid_reload.enabled&active_enemies>2
    if cast.able.multishot() and traits.rapidReload.active and #enemies.yards40 > 2 and not unit.isExplosive("target") then
        if cast.multishot() then ui.debug("Casting Multishot [AOE Rapid Reload]") return true end
    end
    -- Cobra Shot
    -- cobra_shot,if=cooldown.kill_command.remains>focus.time_to_max&(active_enemies<3|!azerite.rapid_reload.enabled)
    if cast.able.cobraShot() and (cd.killCommand.remain() > power.focus.ttm() and (#enemies.yards8p < 3 or not traits.rapidReload.active)) then
        if cast.cobraShot() then ui.debug("Casting Cobra Shot [AOE]") return true end
    end
end -- End Action List - Cleave

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        -- Flask / Crystal
        module.FlaskUp("Agility")
        -- Beast Mode
        if (ui.checked("Beast Mode")) then
            for k,v in pairs(enemies.yards40nc) do
                TargetUnit(v)
            end
        end
        -- -- Pre-Pull
        -- if true then -- Need to Code Pre-Pull Section
        --     -- Aspect of the Wild
        --     -- aspect_of_the_wild,precast_time=1.3,if=!azerite.primal_instincts.enabled&!essence.essence_of_the_focusing_iris.major&(equipped.azsharas_font_of_power|!equipped.cyclotronic_blast)
        --     if ui.checked("Aspect of the Wild") and ui.useCDs()
        --         and cast.able.aspectOfTheWild() and (not traits.primalInstincts.active and not essence.focusedAzeriteBeam.major and (equiped.azsharaFontOfPower() or not equiped.pocketSizedComputationDevice()))
        --         and unit.ttd(units.dyn40) > 15
        --     then
        --         if cast.aspectOfTheWild() then ui.debug("") return true end
        --     end
        --     -- Bestial Wrath
        --     -- bestial_wrath,precast_time=1.5,if=azerite.primal_instincts.enabled&(!essence.essence_of_the_focusing_iris.major)&(!equipped.pocketsized_computation_device|!cooldown.cyclotronic_blast.duration)
        --     if ui.mode.bestialWrath == 1 and (ui.value("Bestial Wrath") == 2 or (ui.value("Bestial Wrath") == 1 and ui.useCDs()))
        --         and cast.able.bestialWrath() and (traits.primalInstincts.active) and not essence.focusedAzeriteBeam.major and unit.ttd(units.dyn40) > 15
        --         and (not equiped.pocketSizedComputationDevice() or cd.pocketSizedComputationDevice.remain() > 0)
        --     then
        --         if cast.bestialWrath() then ui.debug("") return true end
        --     end
        -- end
        -- Init Combat
        if unit.distance("target") < 40 and unit.valid("target") and opener.complete then
            -- Auto Shot
            StartAttack()
        end
    end -- End No Combat
    -- Opener
    if actionList.Opener() then return true end
end -- End Action List - PreCombat

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
    -- BR API
    buff                               = br.player.buff
    cast                               = br.player.cast
    cd                                 = br.player.cd
    charges                            = br.player.charges
    debuff                             = br.player.debuff
    enemies                            = br.player.enemies
    essence                            = br.player.essence
    module                             = br.player.module
    opener                             = br.player.opener
    power                              = br.player.power
    unit                               = br.player.unit
    talent                             = br.player.talent
    traits                             = br.player.traits
    ui                                 = br.player.ui
    unit                               = br.player.unit
    units                              = br.player.units
    var                                = br.player.variables

    -- Global Functions
    
    -- Get Best Unit for Range
    -- units.get(range, aoe)
    units.get(40)
    
    -- Get List of Enemies for Range
    -- enemies.get(range, from unit, no combat, variable)
    enemies.get(40)
    enemies.get(40,"player",false,true)
    enemies.get(40,"player",true)
    enemies.yards30r = getEnemiesInRect(10,30,false) or 0
    enemies.get(30,"pet")
    enemies.get(20,"pet")
    enemies.get(8,"pet")
    enemies.get(8,"player",false,true)
    enemies.get(8,"target")
    enemies.get(5,"pet")
    
    -- Variables
    var.getCombatTime = _G["getCombatTime"]
    var.haltProfile   = ((unit.inCombat() and var.profileStop) or IsMounted() or unit.flying() or pause() or buff.feignDeath.exists() or ui.mode.rotation==4)

    --wipe timers table
    if timersTable then
        wipe(timersTable)
    end

    if ui.checked("Enemy Target Lock") and unit.inCombat() and unit.friend("target", "player") then
        TargetLastEnemy()
    end

    -- General Vars
    if var.profileStop == nil or (not unit.inCombat() and not unit.exists("target") and var.profileStop == true) then
        var.profileStop = false
    end
    minCount = ui.useCDs() and 1 or 3

    -- Profile Specific Vars
    lowestBarbedShot = debuff.barbedShot.lowest(8,"remain","pet")

    -- Opener Reset
    if (not unit.inCombat() and not unit.exists("target")) or opener.complete == nil then
        opener.count = 0
        opener.OPN1 = false
        opener.AOW1 = false
        opener.BW1 = false
        opener.BS1 = false
        opener.BS2 = false
        opener.KC1 = false
        opener.AOW2 = false
        opener.MOC1 = false
        opener.KC2 = false
        opener.CHS1 = false
        opener.COS1 = false
        opener.KC3 = false
        opener.BS3 = false
        opener.COS2 = false
        opener.KC4 = false
        opener.complete = false
    end

    -----------------
    --- Pet Logic ---
    -----------------
    if actionList.PetManagement() then return true end
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif var.haltProfile then
        -- if cast.able.playDead() and cast.last.feignDeath() and not buff.playDead.exists("pet") then
        --     if cast.playDead() then ui.debug("") return true end
        -- end
        StopAttack()
        if unit.isDummy() then ClearTarget() end
        return true
    else
        -----------------
        --- Pet Logic ---
        -----------------
        -- if actionList.PetManagement() then return true end
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then return true end
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList.PreCombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if unit.inCombat() and unit.valid("target") and opener.complete then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if ui.value("APL Mode") == 1 then
                -- auto_shot
                 StartAttack()
                -- Basic Trinket Module
                module.BasicTrinkets()
                -- call_action_list,name=cds
                if actionList.Cooldowns() then return true end
                -- call_action_list,name=st,if=active_enemies<2
                if (ui.mode.rotation == 1 and #enemies.yards8p < ui.value("Units To AoE")) or ui.mode.rotation == 3 or unit.level() < 16 then
                    if actionList.St() then return true end
                end
                -- call_action_list,name=cleave,if=active_enemies>1
                if (ui.mode.rotation == 1 and #enemies.yards8p >= ui.value("Units To AoE")) or ui.mode.rotation == 2 then
                    if actionList.Cleave() then return true end
                end
            end -- End SimC APL
        end --End In Combat
    end --End Rotation Logic
end -- End runRotation
local id = 253
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
