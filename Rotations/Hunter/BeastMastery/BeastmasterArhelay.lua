-------------------------------------------------------
-- Author = Arhelay
-- Patch = 10.0 
--	  Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 69%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Limited
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = NoRaid
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "Arhelay"
br.loadSupport("PetCuteOne")
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.cobraShot },
        [2] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.killCommand },
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)

	-- Handbrake
    local HandbrakeModes = {
        [1] = { mode = "Drive", value = 1 , overlay = "Full sail", tip = "Starts/stops the rotation", highlight = 1, icon = br.player.spell.feignDeath },
        [2] = { mode = "Park", value = 2 , overlay = "Drop the anchor", tip = "Rotation stopped", highlight = 0, icon = br.player.spell.feignDeath },
    };
    br.ui:createToggle(HandbrakeModes,"Handbrake",2,0)
    ---- Cooldown Button
    --local CooldownModes = {
        --[1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.aspectOfTheWild },
        --[2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.aspectOfTheWild },
        --[3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.aspectOfTheWild }
    --};
    --br.ui:createToggle(CooldownModes,"Cooldown",3,0)
    -- BW Button
    local BestialWrathModes = {
        [1] = { mode = "On", value = 1 , overlay = "Will use BW", tip = "Will use BW according to rotation", highlight = 1, icon = br.player.spell.bestialWrath },
        [2] = { mode = "Off", value = 2 , overlay = "Will hold BW", tip = "Will hold BW until toggled again", highlight = 0, icon = br.player.spell.bestialWrath }
    };
    br.ui:createToggle(BestialWrathModes,"BestialWrath",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterShot },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterShot }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
    -- MD Button
    local MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    br.ui:createToggle(MisdirectionModes,"Misdirection",5,0)
    --Pet summon
    local PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spell.callPet1 },
        [2] = { mode = "2", value = 2 , overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spell.callPet2 },
        [3] = { mode = "3", value = 3 , overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spell.callPet3 },
        [4] = { mode = "4", value = 4 , overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spell.callPet4 },
        [5] = { mode = "5", value = 5 , overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spell.callPet5 },
        [6] = { mode = "None", value = 6 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.callPet }
    };
    br.ui:createToggle(PetSummonModes,"PetSummon",6,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable


    local function rotationOptions()
        local section
        local alwaysCdAoENever = {"Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never"}
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- Target Lock
            --br.ui:createCheckbox(section, "Enemy Target Lock", "In Combat, Locks targetting to enemies to avoid shenanigans", 1)
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  1,  60,  1,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
			-- OOC check
			br.ui:createCheckbox(section, "NoOOC", "Selecting this will prevent attacking out of combat")
            -- Beast Mode
            br.ui:createCheckbox(section, "Beast Mode", "|cffFFFFFFWARNING! Selecting this will attack everything!")
            -- AoE Units
            br.ui:createSpinnerWithout(section, "Units To AoE", 2, 1, 10, 1, "|cffFFFFFFSet to desired units to start AoE at.")
            -- Misdirection
            br.ui:createDropdownWithout(section,"Misdirection", {"|cff00FF00Tank","|cffFFFF00Focus","|cffFF0000Pet"}, 1, "|cffFFFFFFSelect target to Misdirect to.")
            -- Covenant Ability
            -- br.ui:createDropdownWithout(section,"Covenant Ability", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use ability.")
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
            --br.player.module.BasicTrinkets(nil,section)
            -- Bestial Wrath
            br.ui:createCheckbox(section,"Bestial Wrath")
            -- Stampede
            --br.ui:createCheckbox(section,"Stampede")
            -- A Murder of Crows / Barrage
            --br.ui:createCheckbox(section,"A Murder Of Crows / Barrage")
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
			-- Handbrake Toggle
            br.ui:createDropdown(section, "Handbrake Mode", br.dropOptions.Toggle,  6)
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
local anima
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
-- Profile Specific Locals
local lowestBarbedShot
local NoOOC

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
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Misdirection
    if ui.mode.misdirection == 1 then
        local misdirectUnit = nil
        if unit.valid("target") and unit.distance("target") < 40 and not buff.playDead.exists("pet") then
            -- Misdirect to Tank
            if ui.value("Misdirection") == 1 then
                local tankInRange, tankUnit = unit.isTankInRange()
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
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.counterShot(thisUnit) then ui.debug("Casting Counter Shot") return true end
                end
            end
        end
        -- Freezing Trap
        if ui.checked("Freezing Trap") and cast.able.freezingTrap(thisUnit,"ground") then
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
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
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
            if (unit.race() == "Troll" or unit.race() == "Orc") and ((buff.aspectOfTheWild.exists()))
                and (unit.ttd(units.dyn40) > cd.racial.remain() + buff.racial.remain()
                    or (unit.hp(units.dyn40) < 35 or not talent.killerInstinct))
                    or (unit.isBoss(units.dyn40) and ((unit.race() == "Troll" and unit.ttd(units.dyn40) < 13) or (unit.race() == "Orc" and unit.ttd(units.dyn40) < 16)))
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
    -- if ui.checked("Opener") and ui.useCDs() and not opener.complete then
    --     if unit.valid("target") and unit.distance("target") < 40
    --         and unit.facing("player","target") and cd.global.remain() == 0
    --     then
    --         -- Begin
    --         if not opener.OPN1 then
    --             ui.print("Starting Opener")
    --             opener.count = opener.count + 1
    --             opener.OPN1 = true
    --             unit.startAttack()
    --             return
    --         -- Aspect of the Wild - No Primal Instincts
    --         elseif opener.OPN1 and not opener.AOW1 then
    --             if traits.primalInstincts.active then
    --                 opener.AOW1 = true
    --                 opener.count = opener.count - 1
    --             elseif cd.aspectOfTheWild.remain() > unit.gcd(true) then
    --                 br.castOpenerFail("aspectOfTheWild","AOW1",opener.count)
    --             elseif cast.able.aspectOfTheWild() then
    --                 br.castOpener("aspectOfTheWild","AOW1",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         -- Bestial Wrath
    --         elseif opener.AOW1 and not opener.BW1 then
    --             if cd.bestialWrath.remain() > unit.gcd(true) then
    --                 br.castOpenerFail("bestialWrath","BW1",opener.count)
    --             elseif cast.able.bestialWrath() then
    --                 br.castOpener("bestialWrath","BW1",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         -- Barbed Shot
    --         elseif opener.BW1 and not opener.BS1 then
    --             if charges.barbedShot.count() == 0 then
    --                 br.castOpenerFail("barbedShot","BS1",opener.count)
    --             elseif cast.able.barbedShot() then
    --                 br.castOpener("barbedShot","BS1",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         -- Barbed Shot 2 - Primal Instincts
    --         elseif opener.BS1 and not opener.BS2 then
    --             if not traits.primalInstincts.active then
    --                 opener.BS2 = true
    --                 opener.count = opener.count - 1
    --             elseif charges.barbedShot.count() == 0 then
    --                 br.castOpenerFail("barbedShot","BS2",opener.count)
    --             elseif cast.able.barbedShot() then
    --                 br.castOpener("barbedShot","BS2",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         -- Kill Command - No Primal Instincts
    --         elseif opener.BS2 and not opener.KC1 then
    --             if traits.primalInstincts.active then
    --                 opener.KC1 = true
    --                 opener.count = opener.count - 1
    --             elseif cd.killCommand.remain() > unit.gcd(true) then
    --                 br.castOpenerFail("killCommand","KC1",opener.count)
    --             elseif cast.able.killCommand() then
    --                 br.castOpener("killCommand","KC1",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         -- Aspect of the Wild - Primal Instincts
    --         elseif opener.KC1 and not opener.AOW2 then
    --             if not traits.primalInstincts.active then
    --                 opener.AOW2 = true
    --                 opener.count = opener.count - 1
    --             elseif cd.aspectOfTheWild.remain() > unit.gcd(true) then
    --                 br.castOpenerFail("aspectOfTheWild","AOW2",opener.count)
    --             elseif cast.able.aspectOfTheWild() then
    --                 br.castOpener("aspectOfTheWild","AOW2",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         -- A Murder of Crows
    --         elseif opener.AOW2 and not opener.MOC1 then
    --             if not talent.aMurderOfCrows or cd.aMurderOfCrows.remain() > unit.gcd(true) then
    --                 br.castOpenerFail("aMurderOfCrows","MOC1",opener.count)
    --             elseif cast.able.aMurderOfCrows() then
    --                 br.castOpener("aMurderOfCrows","MOC1",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         -- Kill Command 2 - Primal Instincts
    --         elseif opener.MOC1 and not opener.KC2 then
    --             if not traits.primalInstincts.active then
    --                 opener.KC2 = true
    --                 opener.count = opener.count - 1
    --             elseif cd.killCommand.remain() > unit.gcd(true) then
    --                 br.castOpenerFail("killCommand","KC2",opener.count)
    --             elseif cast.able.killCommand() then
    --                 br.castOpener("killCommand","KC2",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         -- Chimaera Shot
    --         elseif opener.KC2 and not opener.CHS1 then
    --             if not talent.chimaeraShot or cd.chimaeraShot.remain() > unit.gcd(true) then
    --                 br.castOpenerFail("chimaeraShot","CHS1",opener.count)
    --             elseif cast.able.chimaeraShot() then
    --                 br.castOpener("chimaeraShot","CHS1",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         -- Cobra Shot
    --         elseif opener.CHS1 and not opener.COS1 then
    --             if not cast.able.cobraShot() then
    --                 br.castOpenerFail("cobraShot","COS1",opener.count)
    --             elseif cast.able.cobraShot() then
    --                 br.castOpener("cobraShot","COS1",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         -- Kill Command 3
    --         elseif opener.COS1 and not opener.KC3 then
    --             if cd.killCommand.remain() > unit.gcd(true) then
    --                 br.castOpenerFail("killCommand","KC3",opener.count)
    --             elseif cast.able.killCommand() then
    --                 br.castOpener("killCommand","KC3",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         -- Barbed Shot 3
    --         elseif opener.KC3 and not opener.BS3 then
    --             if charges.barbedShot.count() == 0 then
    --                 br.castOpenerFail("barbedShot","BS3",opener.count)
    --             elseif cast.able.barbedShot() then
    --                 br.castOpener("barbedShot","BS3",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         -- Cobra Shot 2 - No Primal Instincts
    --         elseif opener.BS3 and not opener.COS2 then
    --             if traits.primalInstincts.active then
    --                 opener.COS2 = true;
    --                 opener.count = opener.count - 1
    --             elseif not cast.able.cobraShot() then
    --                 br.castOpenerFail("cobraShot","COS2",opener.count)
    --             elseif cast.able.cobraShot() then
    --                 br.castOpener("cobraShot","COS2",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         -- Kill Command 4 - No Primal Instincts
    --         elseif opener.COS2 and not opener.KC4 then
    --             if traits.primalInstincts.active then
    --                 opener.KC4 = true;
    --                 opener.count = opener.count - 1
    --             elseif cd.killCommand.remain() > unit.gcd(true) then
    --                 br.castOpenerFail("killCommand","KC4",opener.count)
    --             elseif cast.able.killCommand() then
    --                 br.castOpener("killCommand","KC4",opener.count)
    --             end
    --             opener.count = opener.count + 1
    --             return
    --         elseif opener.KC4 and opener.OPN1 then
    --             ui.print("Opener Complete")
    --             opener.count = 0
    --             opener.complete = true
    --         end
    --     end
    -- elseif (unit.exists("target") and not ui.useCDs()) or not ui.checked("Opener") then
    --     opener.complete = true
    -- end
end -- End Action List - Opener

-- Action List - Single Target
actionList.St = function()

    -- Barbed Shot
    -- barbed_shot
    if (cast.able.barbedShot(lowestBarbedShot) and buff.frenzy.exists("pet") and buff.frenzy.remain("pet") <= unit.gcd(true) + 0.15)
		or ((cd.bestialWrath.remains() < 12 * charges.barbedShot.frac() + unit.gcd(true)) and talent.scentOfBlood)
			then
        if cast.barbedShot(lowestBarbedShot) then ui.debug("[ST] Barbed Shot low frenzy on "..unit.name(lowestBarbedShot)) return true end
    end	
		
    -- Kill Command
    -- kill_command
    if charges.killCommand.timeTillFull() < unit.gcd(true) then
        if cast.killCommand() then ui.debug("[ST] Kill Command cap on "..unit.name(br.petTarget)) return true end
    end
	
	-- Barbed Shot
    -- barbed_shot
    if unit.exists(br.petTarget) and cast.able.barbedShot(br.petTarget)
        and (charges.barbedShot.frac() > 1.4)
    then
        if cast.barbedShot(br.petTarget) then ui.debug("[ST] Barbed Shot frac > 1.4 on "..unit.name(br.petTarget)) return true end
    end	
	
	-- Kill Shot
    -- kill_shot
	if (cast.able.killShot() and buff.flayersMark.exists()) then
		if cast.killShot() then ui.debug("[ST] Killshot Venthyr") return true end
	end	
	
    -- Flayed Shot
    -- flayed_shot
    if cast.able.flayedShot() then
        if cast.flayedShot() then ui.debug("[ST] Flayed Shot [Venthyr]") return true end
    end
	
    -- Bestial Wrath 
	-- bestial_wrath
    if ui.checked("Bestial Wrath") and cast.able.bestialWrath()
            --and ((unit.ttd(units.dyn40) < 15 + unit.gcd(true)) and not unit.isDummy())
    then
        if cast.bestialWrath() then ui.debug("[ST] Bestial Wrath") return true end
    end
	
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot(var.lowestHPUnit) and unit.hp(var.lowestHPUnit) < 20 then
        if cast.killShot(var.lowestHPUnit) then ui.debug("[ST] Kill shot on "..tostring(unit.name(var.lowestHPUnit))) return true end
    end
	
    -- Kill Command
    -- kill_command
    if cast.able.killCommand() then
        if cast.killCommand() then ui.debug("[ST] Kill Command on "..unit.name(br.petTarget)) return true end
    end	
	
    -- Cobra Shot
    -- cobra_shot,if=focus.time_to_max<gcd*2
    if cast.able.cobraShot() and power.focus.ttm() < unit.gcd(true) * 2 then
            if cast.cobraShot() then ui.debug("[ST] Cobra shot on") return true end
        end

end -- End Action List - Single Target

-- Action List - Cleave
actionList.Cleave = function()

    -- Barbed Shot
    -- barbed_shot
    if (cast.able.barbedShot(lowestBarbedShot) and buff.frenzy.exists("pet") and buff.frenzy.remain("pet") <= unit.gcd(true) + 0.15)
		or ((cd.bestialWrath.remains() < 12 * charges.barbedShot.frac() + unit.gcd(true)) and talent.scentOfBlood)
			then
        if cast.barbedShot(lowestBarbedShot) then ui.debug("[AOE] Barbed Shot low frenzy on "..unit.name(lowestBarbedShot)) return true end
    end
	
    -- Multishot
    -- multishot
    if cast.able.multishot(units.dyn40,"aoe",1,8) and (unit.gcd(true) - buff.beastCleave.remain("pet") > 0.25)
         and not unit.isExplosive("target")
    then
        if cast.multishot(units.dyn40,"aoe",1,8) then ui.debug("[AOE] Multishot") return true end
    end
	
    -- Barbed Shot
    -- barbed_shot
    if cast.able.barbedShot(lowestBarbedShot) and (charges.barbedShot.frac() > 1.4) and cd.bestialWrath.remain() > unit.gcd(true) 
		or (cd.bestialWrath.remains() < 12 + unit.gcd(true) and talent.scentOfBlood)
    then
        if cast.barbedShot(lowestBarbedShot) then ui.debug("[AOE] Barbed shot cap "..unit.name(lowestBarbedShot)) return true end
    end	
	
    -- Kill Command
    -- kill_command
    if talent.killCleave and cast.able.killCommand() and buff.beastCleave.exists("pet") then
        if cast.killCommand() then ui.debug("[AOE] Kill Cleave on "..unit.name(br.petTarget)) return true end
    end		
	
	-- Kill Shot
    -- kill_shot
	if (cast.able.killShot() and buff.flayersMark.exists()) then
		if cast.killShot() then ui.debug("[AOE] Killshot Venthyr") return true end
	end	
	
    -- Flayed Shot
    -- flayed_shot
    if cast.able.flayedShot() then
        if cast.flayedShot() then ui.debug("[AOE] Flayed Shot [Venthyr]") return true end
    end	
	
    -- Bestial Wrath
    -- bestial_wrath
    if ui.checked("Bestial Wrath") and cast.able.bestialWrath() then
        if cast.bestialWrath() then ui.debug("[AOE] Bestial Wrath") return true end
    end
	
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot(var.lowestHPUnit) and unit.hp(var.lowestHPUnit) < 20 then
        if cast.killShot(var.lowestHPUnit) then ui.debug("[AOE] Kill Shot on "..tostring(unit.name(var.lowestHPUnit))) return true end
    end

    -- Kill Command
    -- kill_command,if=focus>cost+action.multishot.cost
    if unit.exists(br.petTarget) and cast.able.killCommand(br.petTarget) and power.focus.amount() > cast.cost.killCommand() + cast.cost.multishot() then
        if cast.killCommand(br.petTarget) then ui.debug("[AOE] Casting Kill Command on "..unit.name(br.petTarget)) return true end
    end
	
    -- Cobra Shot
    -- cobra_shot,if=focus.time_to_max<gcd*2
    if cast.able.cobraShot() and power.focus.ttm() < unit.gcd(true) * 2 then
            if cast.cobraShot() then ui.debug("[AOE] Cobra shot on") return true end
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
                br._G.TargetUnit(v)
            end
        end
        -- Init Combat
        if unit.distance("target") < 40 and unit.valid("target") then-- and opener.complete then
            -- Auto Shot
		if not ui.checked("NoOOC") then
            if cast.able.autoShot("target") then
                if cast.autoShot("target") then ui.debug("Casting Auto Shot [Pre-Pull]") return true end
				end
			end
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
    anima                              = br.player.anima
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
    enemies.get(30,"pet")
    enemies.get(20,"pet")
    enemies.get(12,"target")
    enemies.get(8,"pet")
    enemies.get(8,"player",false,true)
    enemies.get(8,"target")
    enemies.get(5,"pet")

    -- Variables
    --var.haltProfile = ((unit.inCombat() and var.profileStop) or unit.mounted() or unit.flying() or ui.pause() or buff.feignDeath.exists() or ui.mode.rotation==4)
    var.haltProfile = (unit.inCombat() and var.profileStop) or (unit.mounted() or unit.flying()) or ui.pause() or buff.feignDeath.exists()

    --wipe timers table
    if br._G.timersTable then
        br._G.wipe(br._G.timersTable)
    end

    if ui.checked("Enemy Target Lock") and unit.inCombat() and unit.friend("target", "player") then
        br._G.TargetLastEnemy()
    end

    if var.tarred == nil then var.tarred = false end

    -- General Vars
    if var.profileStop == nil or (not unit.inCombat() and not unit.exists("target") and var.profileStop == true) then
        var.profileStop = false
    end

    var.lowestHPUnit = "target"
    var.lowestHP = 100
    for i = 1, #enemies.yards40f do
        local thisUnit = enemies.yards40f[i]
        local thisHP = unit.hp(thisUnit)
        if thisHP < var.lowestHP then
            var.lowestHP = thisHP
            var.lowestHPUnit = thisUnit
            ui.chatOverlay("Lowest Unit is now: "..unit.name(var.lowestHPUnit))									  
        end
    end

    -- Profile Specific Vars
    lowestBarbedShot = debuff.barbedShot.lowest(8,"remain","pet") or "target"

    -- var.executeConditions = function(thisUnit)
        -- if thisUnit == nil then thisUnit = units.dyn40 end
        -- return unit.hp(thisUnit) < 20
    -- end

	-- var.executable = function(thisUnit)
        -- if thisUnit == nil then thisUnit = units.dyn40 end
        -- return var.executeConditions(thisUnit)
    -- end

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

    if var.tarred == nil or cd.tarTrap.remain() == 0 or not unit.inCombat() then var.tarred = false end

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
    elseif var.haltProfile and (not unit.isCasting() or ui.pause(true)) then
        unit.stopAttack()
        if unit.isDummy() then unit.clearTarget() end
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
            -- Auto Shot
            -- auto_shot
            if cast.able.autoShot(units.dyn40) then
                -- if cast.autoShot(units.dyn40) then ui.debug("Casting Auto Shot") return true end			
                if cast.autoShot(units.dyn40) then return true end
            end
            -- Counter Shot
            -- counter_shot,line_cd=30,if=runeforge.sephuzs_proclamation|soulbind.niyas_tools_poison|(conduit.reversal_of_fortune&!runeforge.sephuzs_proclamation)
            -- Basic Trinket Module
            module.BasicTrinkets()
            -- Call Action List - Cooldowns
            -- call_action_list,name=cds
            if actionList.Cooldowns() then return true end
            -- Call Action List - Single Target
            -- call_action_list,name=st,if=active_enemies<2
            if ((ui.mode.rotation == 1 and #enemies.yards8p < ui.value("Units To AoE")) or ui.mode.rotation == 2 or unit.level() < 16) and ui.mode.handbrake == 1  then
                if actionList.St() then return true end
            end
            -- Call Action List - Cleave
            -- call_action_list,name=cleave,if=active_enemies>1
            if (ui.mode.rotation == 1 and #enemies.yards8p >= ui.value("Units To AoE")) and ui.mode.handbrake == 1 then
                if actionList.Cleave() then return true end
            end
        end --End In Combat
    end --End Rotation Logic
end -- End runRotation
local id = 253
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})