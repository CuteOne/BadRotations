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
        local alwaysCdNever = {"Always", "Cooldown", "Never"}
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- Target Lock
            br.ui:createCheckbox(section, "Enemy Target Lock", "In Combat, Locks targetting to enemies to avoid shenanigans", 1)
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Beast Mode
            br.ui:createCheckbox(section, "Beast Mode", "|cffFFFFFFWARNING! Selecting this will attack everything!")
            -- AoE Units
            br.ui:createSpinnerWithout(section, "Units To AoE", 2, 1, 10, 1, "|cffFFFFFFSet to desired units to start AoE at.")
            -- Misdirection
            br.ui:createDropdownWithout(section,"Misdirection", {"|cff00FF00Tank","|cffFFFF00Focus","|cffFF0000Pet"}, 1, "|cffFFFFFFSelect target to Misdirect to.")
            -- Covenant Ability
            br.ui:createDropdownWithout(section,"Covenant Ability", alwaysCdNever, 1, "|cffFFFFFFSet when to use ability.")
            -- Opener
            -- br.ui:createCheckbox(section, "Opener")
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
            br.player.module.BasicTrinkets(nil,section)
            -- Bestial Wrath
            br.ui:createDropdownWithout(section,"Bestial Wrath", alwaysCdNever, 2, "|cffFFFFFFSelect Bestial Wrath Usage.")
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
            -- Freezing Trap
            br.ui:createCheckbox(section, "Freezing Trap")
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
local covenant
local conduit
local debuff
local enemies
local module
local opener
local power
local runeforge
local talent
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
            -- Misdirect to Tank
            if ui.value("Misdirection") == 1 then
                local tankInRange, tankUnit = isTankInRange()
                if tankInRange then misdirectUnit = tankUnit end
            end
            -- Misdirect to Focus
            if ui.value("Misdirection") == 2 and unit.friend("focus","player") then
                misdirectUnit = "focus"
            end
            -- Misdirect to Pet
            if ui.value("Misdirection") == 3 then
                misdirectUnit = "pet"
            end
            -- Failsafe to Pet, if unable to misdirect to Tank or Focus
            if misdirectUnit == nil then misdirectUnit = "pet" end
            if misdirectUnit and cast.able.misdirection() and unit.exists(misdirectUnit) and unit.distance(misdirectUnit) < 40 and not unit.deadOrGhost(misdirectUnit) then
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
        -- Freezing Trap
        if ui.checked("Freezing Trap") and cast.able.freezingTrap() then
            for i = 1, #enemies.yards40 do
                thisUnit = enemies.yards40[i]
                if unit.distance(thisUnit) > 8 and cast.timeRemain(thisUnit) > 3 then
                    if cast.freezingTrap(thisUnit,"ground") then ui.debug("Casting Freezing Trap") return true end
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
            -- lights_judgment
            if (unit.race() == "LightforgedDraenei") then
                if cast.racial() then ui.debug("Casting Racial") return true end
            end
        end
    end -- End useCooldowns check
    -- Potion
    -- potion,if=buff.aspect_of_the_wild.up|target.time_to_die<26
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
    -- Aspect of the Wild
    -- aspect_of_the_wild
    if ui.checked("Aspect of the Wild") and ui.useCDs() and cast.able.aspectOfTheWild() and (unit.ttd(units.dyn40) > 15 or ui.useCDs()) then
        if cast.aspectOfTheWild() then ui.debug("Casting Aspect of the Wild") return true end
    end
    -- Barbed Shot
    -- barbed_shot,if=pet.main.buff.frenzy.up&pet.main.buff.frenzy.remains<gcd
    if unit.exists(br.petTarget) and cast.able.barbedShot(br.petTarget) and buff.frenzy.exists("pet") and buff.frenzy.remain("pet") <= unit.gcd(true) + 0.1 then
        if cast.barbedShot(br.petTarget) then ui.debug("[ST 1] Casting Barbed Shot on "..unit.name(br.petTarget)) return true end
    end
    -- Tar Trap
    -- tar_trap,if=runeforge.soulforge_embers&tar_trap.remains<gcd&cooldown.flare.remains<gcd
    if cast.able.tarTrap() and runeforge.soulforgeEmbers.equiped and debuff.tarTrap.remains(units.dyn40) < unit.gcd(true) and cd.flare.remains() < unit.gcd(true) then
        if cast.tarTrap(units.dyn40,"ground") then ui.debug("Casting Tar Trap [Soulforge Embers]") return true end
    end
    -- Flare
    -- flare,if=tar_trap.up&runeforge.soulforge_embers
    if cast.able.flare() and debuff.tarTrap.exists(units.dyn40) and runeforge.soulforgeEmbers.equiped then
        if cast.flare(units.dyn40) then ui.debug("Casting Flare [Soulforge Embers]") return true end
    end
    -- Bloodshed
    -- bloodshed
    if cast.able.bloodshed() then
        if cast.bloodshed() then ui.debug("Casting Bloodshed") return true end
    end
    -- Wild Spirits
    -- wild_spirits
    if ui.alwaysCdNever("Covenant Ability") and cast.able.wildSpirits() then
        if cast.wildSpirits() then ui.debug("Casting Wild Spirits [Night Fae]") return true end
    end
    -- Flayed Shot
    -- flayed_shot
    if ui.alwaysCdNever("Covenant Ability") and cast.able.flayedShot() then
        if cast.flayedShot() then ui.debug("Casting Flayed Shot [Venthhyr]") return true end
    end
    -- Kill Shot
    -- kill_shot,if=buff.flayers_mark.remains<5|target.health.pct<=20
    if cast.able.killShot(var.lowestHPUnit) and (buff.flayersMark.remains() < 5 or unit.hp(var.lowestHPUnit) < 20) then
        if cast.killShot(var.lowestHPUnit) then ui.debug("Casting Kill Shot") return true end
    end
    -- Barbed Shot
    -- barbed_shot,if=(cooldown.wild_spirits.remains>full_recharge_time|!covenant.night_fae)&(cooldown.bestial_wrath.remains<12*charges_fractional+gcd&talent.scent_of_blood|full_recharge_time<gcd&cooldown.bestial_wrath.remains)|target.time_to_die<9
    if unit.exists(br.petTarget) and cast.able.barbedShot(br.petTarget)
        and ((cd.wildSpirits.remains() > charges.barbedShot.timeTillFull() or not covenant.nightFae.active or not ui.alwaysCdNever("Covenant Ability"))
        and ((cd.bestialWrath.remains() < 12 * charges.barbedShot.frac() + unit.gcd(true) and talent.scentOfBlood)
            or (charges.barbedShot.timeTillFull() < unit.gcd(true) and (cd.bestialWrath.remains() > 0 or ui.mode.bestialWrath == 2 or not ui.alwaysCdNever("Bestial Wrath")))
            or (unit.ttd(br.petTarget) < 9 and ui.useCDs())))
    then
        if cast.barbedShot(br.petTarget) then ui.debug("[ST 2] Casting Barbed Shot on "..unit.name(br.petTarget)) return true end
    end
    -- Death Chakram
    -- death_chakram,if=focus+cast_regen<focus.max
    if ui.alwaysCdNever("Covenant Ability") and cast.able.deathChakram() and power.focus.amount() + cast.regen.deathChakram() < power.focus.max() then
        if cast.deathChakram() then ui.debug("Casting Death Chakram [Necrolord]") return true end
    end
    -- Stampede
    -- stampede,if=buff.aspect_of_the_wild.up|target.time_to_die<15
    if ui.checked("Stampede") and talent.stampede and cast.able.stampede()
        and (buff.aspectOfTheWild.exists() or (unit.ttd(units.dyn40) < 15 and ui.useCDs()))
    then
        if cast.stampede() then ui.debug("Casting Stampede") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if ui.checked("A Murder Of Crows / Barrage") and ui.mode.murderOfCrows == 1 and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows") return true end
    end
    -- Resonating Arrow
    -- resonating_arrow,if=buff.bestial_wrath.up|target.time_to_die<10
    if ui.alwaysCdNever("Covenant Ability") and cast.able.resonatingArrow() and (buff.bestialWrath.exists() or (unit.ttd(units.dyn40) < 10 and ui.useCDs())) then
        if cast.resonatingArrow() then ui.debug("Casting Resonating Arrow [Kyrian]") return true end
    end
    -- Bestial Wrath
    -- bestial_wrath,if=cooldown.wild_spirits.remains>15|!covenant.night_fae|target.time_to_die<15
    if ui.mode.bestialWrath == 1 and ui.alwaysCdNever("Bestial Wrath") and cast.able.bestialWrath()
        and (cd.wildSpirits.remains() > 15 or not covenant.nightFae.active or (unit.ttd(units.dyn40) < 15 + unit.gcd(true) or ui.useCDs()))
    then
        if cast.bestialWrath() then ui.debug("Casting Bestial Wrath") return true end
    end
    -- Chimaera Shot
    -- chimaera_shot
    if cast.able.chimaeraShot() then
        if cast.chimaeraShot() then ui.debug("Casting Chimaera Shot") return true end
    end
    -- Kill Command
    -- kill_command
    if cast.able.killCommand(br.petTarget) then
        if cast.killCommand(br.petTarget) then if br.petTarget ~= nil then ui.debug("[ST] Casting Kill Command on "..unit.name(br.petTarget)) else ui.debug("[ST] Casting Kill Command on nil") end return true end
    end
    -- Racial - Bag of Tricks
    -- bag_of_tricks,if=buff.bestial_wrath.down|target.time_to_die<5
    -- Dire Beast
    -- dire_beast
    if cast.able.direBeast() then
        if cast.direBeast() then ui.debug("Casting Dire Beast") return true end
    end
    -- Cobra Shot
    -- cobra_shot,if=(focus-cost+focus.regen*(cooldown.kill_command.remains-1)>action.kill_command.cost|cooldown.kill_command.remains>1+gcd)|(buff.bestial_wrath.up|buff.nesingwarys_trapping_apparatus.up)&!runeforge.qapla_eredun_war_order|target.time_to_die<3
    if cast.able.cobraShot() and ((power.focus.amount() - cast.cost.cobraShot() + power.focus.regen() * (cd.killCommand.remain() - 1) > cast.cost.killCommand() or cd.killCommand.remain() > 1 + unit.gcd(true))
        or (buff.bestialWrath.exists() or buff.nesingwarysTrappingApparatus.exists()) and not runeforge.qaplaEredunWarOrder.equiped
        or unit.ttd(units.dyn40) < 3 and ui.useCDs())
    then
        if cast.cobraShot() then ui.debug("Casting Cobra Shot") return true end
    end
    -- Barbed Shot
    -- barbed_shot,if=buff.wild_spirits.up
    if unit.exists(br.petTarget) and cast.able.barbedShot(br.petTarget) and debuff.wildMark.exists(br.petTarget) then
        if cast.barbedShot(br.petTarget) then ui.debug("[Wild Spirits] Casting Barbed Shot on "..unit.name(br.petTarget)) return true end
    end
    -- Arcane Pulse
    -- arcane_pulse,if=buff.bestial_wrath.down|target.time_to_die<5
    -- Tar Trap
    -- tar_trap,if=runeforge.soulforge_embers|runeforge.nessingwarys_trapping_apparatus
    if cast.able.tarTrap() and (runeforge.soulforgeEmbers.equiped or runeforge.nesingwarysTrappingApparatus.equiped) then
        if cast.tarTrap() then ui.debug("Casting Tar Trap [Soulforge Embers / Nesingwary's Trapping Apparatus]") return true end
    end
    -- Freezing Trap
    -- freezing_trap,if=runeforge.nessingwarys_trapping_apparatus
    if cast.able.freezingTrap() and runeforge.nesingwarysTrappingApparatus.equiped then
        if cast.freezingTrap() then ui.debug("Casting Freezing Trap [Nesingwary's Trapping Apparatus]") return true end
    end  
end -- End Action List - Single Target

-- Action List - Cleave
actionList.Cleave = function()
    -- Aspect of the Wild
    -- aspect_of_the_wild
    if ui.checked("Aspect of the Wild") and not buff.aspectOfTheWild.exists() and ui.useCDs() and cast.able.aspectOfTheWild() and (unit.ttd(units.dyn40) > 15 or ui.useCDs()) then
        if cast.aspectOfTheWild() then ui.debug("Casting Aspect of the Wild [AOE]") return true end
    end
    -- Barbed Shot
    -- barbed_shot,target_if=min:dot.barbed_shot.remains,if=pet.main.buff.frenzy.up&pet.main.buff.frenzy.remains<=gcd
    if cast.able.barbedShot(lowestBarbedShot) and buff.frenzy.exists("pet") and buff.frenzy.remain("pet") <= unit.gcd(true) + 0.1 then
        if cast.barbedShot(lowestBarbedShot) then ui.debug("[AOE 1] Casting Barbed Shot on "..unit.name(lowestBarbedShot)) return true end
    end
    -- Multishot
    -- multishot,if=gcd.max-pet.cat.buff.beast_cleave.remains>0.25
    if cast.able.multishot() and unit.gcd(true) - buff.beastCleave.remain("pet") > 0.25 --buff.beastCleave.remain("pet") < unit.gcd(true) + 0.1
         and not unit.isExplosive("target")
    then
        if cast.multishot() then ui.debug("Casting Multishot [AOE]") return true end
    end
    -- Tar Trap
    -- tar_trap,if=runeforge.soulforge_embers&tar_trap.remains<gcd&cooldown.flare.remains<gcd
    if cast.able.tarTrap() and runeforge.soulforgeEmbers.equiped and debuff.tarTrap.remains(units.dyn40) < unit.gcd(true) and cd.flare.remains() < unit.gcd(true) then
        if cast.tarTrap(units.dyn40,"ground") then ui.debug("Casting Tar Trap [Soulforge Embers AOE]") return true end
    end
    -- Flare
    -- flare,if=tar_trap.up&runeforge.soulforge_embers
    if cast.able.flare() and debuff.tarTrap.exists(units.dyn40) and runeforge.soulforgeEmbers.equiped then
        if cast.flare(units.dyn40) then ui.debug("Casting Flare [Soulforge Embers]") return true end
    end
    -- Death Chakram
    -- death_chakram,if=focus+cast_regen<focus.max
    if ui.alwaysCdNever("Covenant Ability") and cast.able.deathChakram() and power.focus.amount() + cast.regen.deathChakram() < power.focus.max() then
        if cast.deathChakram() then ui.debug("Casting Death Chakram [AOE Necrolord]") return true end
    end
    -- Wild Spirits
    -- wild_spirits
    if ui.alwaysCdNever("Covenant Ability") and cast.able.wildSpirits() then
        if cast.wildSpirits() then ui.debug("Casting Wild Spirits [AOE Night Fae]") return true end
    end
    -- Barbed Shot
    -- barbed_shot,target_if=min:dot.barbed_shot.remains,if=full_recharge_time<gcd&cooldown.bestial_wrath.remains|cooldown.bestial_wrath.remains<12+gcd&talent.scent_of_blood
    if cast.able.barbedShot(lowestBarbedShot) and (charges.barbedShot.timeTillFull() < unit.gcd(true)
        and cd.bestialWrath.remain() > unit.gcd(true) or cd.bestialWrath.remains() < 12 + unit.gcd(true) and talent.scentOfBlood)
    then
        if cast.barbedShot(lowestBarbedShot) then ui.debug("[AOE 2] Casting Barbed Shot on "..unit.name(lowestBarbedShot)) return true end
    end
    -- Bestial Wrath
    -- bestial_wrath
    if ui.mode.bestialWrath == 1 and cast.able.bestialWrath() and (ui.value("Bestial Wrath") == 2 or (ui.value("Bestial Wrath") == 1 and ui.useCDs())) then
        if cast.bestialWrath() then ui.debug("Casting Bestial Wrath [AOE]") return true end
    end
    -- Resonating Arrow
    -- resonating_arrow
    if ui.alwaysCdNever("Covenant Ability") and cast.able.resonatingArrow() then
        if cast.resonatingArrow() then ui.debug("Casting Resonating Arrow [Kyrian]") return true end
    end
    -- Stampede
    -- stampede,if=buff.aspect_of_the_wild.up|target.time_to_die<15
    if ui.checked("Stampede") and talent.stampede and cast.able.stampede()
        and (buff.aspectOfTheWild.exists() or (unit.ttdGroup(units.dyn40) < 15 and ui.useCDs()))
    then
        if cast.stampede() then ui.debug("Casting Stampede [AOE]") return true end
    end
    -- Flayed Shot
    -- flayed_shot
    if ui.alwaysCdNever("Covenant Ability") and cast.able.flayedShot() then
        if cast.flayedShot() then ui.debug("Casting Flayed Shot [AOE Venthhyr]") return true end
    end
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot(var.lowestHPUnit) and unit.hp(var.lowestHPUnit) < 20 then
        if cast.killShot(var.lowestHPUnit) then ui.debug("Casting Kill Shot [AOE]") return true end
    end
    -- Chimaera Shot
    -- chimaera_shot
    if cast.able.chimaeraShot() then
        if cast.chimaeraShot() then ui.debug("Casting Chimaera Shot [AOE]") return true end
    end
    -- Bloodshed
    -- bloodshed
    if cast.able.bloodshed() then
        if cast.bloodshed() then ui.debug("Casting Bloodshed [AOE]") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if ui.checked("A Murder Of Crows / Barrage") and ui.mode.murderOfCrows == 1 and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [AOE]") return true end
    end
    -- Barrage
    -- barrage,if=pet.main.buff.frenzy.remains>execute_time
    if ui.checked("A Murder Of Crows / Barrage") and cast.able.barrage() and buff.frenzy.remain("pet") > cast.time.barrage() then
        if cast.barrage() then ui.debug("Casting Barrage [AOE]") return true end
    end
    -- Kill Command
    -- kill_command,if=focus>cost+action.multishot.cost
    if unit.exists(br.petTarget) and cast.able.killCommand(br.petTarget) and power.focus.amount() > cast.cost.killCommand() + cast.cost.multishot() then
        if cast.killCommand(br.petTarget) then ui.debug("[AOE] Casting Kill Command on "..unit.name(br.petTarget)) return true end
    end
    -- Dire Beast
    -- dire_beast
    if cast.able.direBeast() then
        if cast.direBeast() then ui.debug("Casting Dire Beast [AOE]") return true end
    end
    -- Barbed Shot
    -- barbed_shot,target_if=min:dot.barbed_shot.remains,if=target.time_to_die<9
    if cast.able.barbedShot(lowestBarbedShot) and unit.ttd(units.dyn40) < 9 then
        if cast.barbedShot(lowestBarbedShot) then ui.debug("[AOE 4] Casting Barbed Shot on "..unit.name(lowestBarbedShot)) return true end
    end
    -- Cobra Shot
    -- cobra_shot,if=focus.time_to_max<gcd*2
    if cast.able.cobraShot() and power.focus.ttm() < unit.gcd(true) * 2 then
        if cast.cobraShot() then ui.debug("Casting Cobra Shot [AOE]") return true end
    end
    -- Tar Trap
    -- tar_trap,if=runeforge.soulforge_embers|runeforge.nessingwarys_trapping_apparatus
    if cast.able.tarTrap() and (runeforge.soulforgeEmbers.equiped or runeforge.nesingwarysTrappingApparatus.equiped) then
        if cast.tarTrap() then ui.debug("Casting Tar Trap [AOE Soulforge Embers / Nesingwary's Trapping Apparatus]") return true end
    end
    -- Freezing Trap
    -- freezing_trap,if=runeforge.nessingwarys_trapping_apparatus
    if cast.able.freezingTrap() and runeforge.nesingwarysTrappingApparatus.equiped then
        if cast.freezingTrap() then ui.debug("Casting Freezing Trap [AOE Nesingwary's Trapping Apparatus]") return true end
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
        -- Init Combat
        if unit.distance("target") < 40 and unit.valid("target") then-- and opener.complete then
            -- Auto Shot
            unit.startAttack("target",true)
        end
    end -- End No Combat
    -- Opener
    -- if actionList.Opener() then return true end
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
    covenant                           = br.player.covenant
    conduit                            = br.player.conduit
    debuff                             = br.player.debuff
    enemies                            = br.player.enemies
    module                             = br.player.module
    opener                             = br.player.opener
    power                              = br.player.power
    runeforge                          = br.player.runeforge
    unit                               = br.player.unit
    talent                             = br.player.talent
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

    var.lowestHPUnit = "target"
    var.lowestHP = 100
    for i = 1, #enemies.yards40f do
        local thisUnit = enemies.yards40f[i]
        local thisHP = unit.hp(thisUnit)
        if thisHP < var.lowestHP then
            var.lowestHP = thisHP
            var.lowestHPUnit = thisUnit
        end
    end

    -- Profile Specific Vars
    lowestBarbedShot = debuff.barbedShot.lowest(8,"remain","pet") or "target"

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
        if unit.inCombat() and unit.valid("target") then --and opener.complete then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end
            ------------------------
            --- In Combat - Main ---
            ------------------------
            -- Start Attack
            -- auto_shot
            unit.startAttack("target",true)
            -- Counter Shot
            -- counter_shot,line_cd=30,if=runeforge.sephuzs_proclamation|soulbind.niyas_tools_poison|(conduit.reversal_of_fortune&!runeforge.sephuzs_proclamation)
            -- Basic Trinket Module
            module.BasicTrinkets()
            -- Call Action List - Cooldowns
            -- call_action_list,name=cds
            if actionList.Cooldowns() then return true end
            -- Call Action List - Single Target
            -- call_action_list,name=st,if=active_enemies<2
            if (ui.mode.rotation == 1 and #enemies.yards8p < ui.value("Units To AoE")) or ui.mode.rotation == 3 or unit.level() < 16 then
                if actionList.St() then return true end
            end
            -- Call Action List - Cleave
            -- call_action_list,name=cleave,if=active_enemies>1
            if (ui.mode.rotation == 1 and #enemies.yards8p >= ui.value("Units To AoE")) or ui.mode.rotation == 2 then
                if actionList.Cleave() then return true end
            end
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
