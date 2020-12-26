local rotationName = "CuteOne"
local br = _G["br"]
loadSupport("PetCuteOne")
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.aimedShot },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.multishot },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.arcaneShot },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.aspectOfTheCheetah}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.trueshot },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.trueshot },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.trueshot }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.aspectOfTheTurtle },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.aspectOfTheTurtle }
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterShot },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterShot }
    };
    CreateButton("Interrupt",4,0)
    -- MD Button
    MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("Misdirection",5,0)
    --Pet summon
    PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spell.callPet1 },
        [2] = { mode = "2", value = 2 , overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spell.callPet2 },
        [3] = { mode = "3", value = 3 , overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spell.callPet3 },
        [4] = { mode = "4", value = 4 , overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spell.callPet4 },
        [5] = { mode = "5", value = 5 , overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spell.callPet5 },
        [6] = { mode = "None", value = 6 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.callPet }
    };
    CreateButton("PetSummon",6,0)
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
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Dont Auto Engage
            br.ui:createCheckbox(section, "Do Not Auto Engage if OOC")
            -- Misdirection
            br.ui:createDropdownWithout(section,"Misdirection", {"|cff00FF00Tank","|cffFFFF00Focus","|cffFF0000Pet"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
            -- Volly Units
            br.ui:createSpinner(section,"Volley Units", 3, 1, 5, 1, "|cffFFFFFFSet minimal number of units to cast Volley on")
            -- Covenant Ability
            br.ui:createDropdownWithout(section,"Covenant Ability", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
        br.ui:checkSectionState(section)
        -- Pet Options
        br.rotations.support["PetCuteOne"].options()
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Agi Pot
            br.ui:createCheckbox(section,"Potion")
            -- Flask Up Module
            br.player.module.FlaskUp("Agility",section)
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Basic Trinkets Module
            br.player.module.BasicTrinkets(nil,section)
            -- A Murder of Crows
            br.ui:createDropdownWithout(section,"A Murder of Crows", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
            -- Barrage
            br.ui:createDropdownWithout(section,"Barrage", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
            -- Double Tap
            br.ui:createDropdownWithout(section,"Double Tap", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
            -- Explosive Shot
            br.ui:createDropdownWithout(section,"Explosive Shot", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
            -- Rapid Fire
            br.ui:createDropdownWithout(section,"Rapid Fire", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
            -- Trueshot
            br.ui:createDropdownWithout(section,"Trueshot", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Aspect of the Turtle
            br.ui:createSpinner(section, "Aspect Of The Turtle",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Bursting Shot
            br.ui:createSpinner(section, "Bursting Shot", 1, 1, 10, 1, "|cffFFBB00Number of Enemies within 8yrds to use at.")
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
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  6)
            -- Cooldown Key Toggle
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle,  6)
            -- Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Explosive Shot Key Toggle
            br.ui:createDropdownWithout(section, "Explosive Shot Mode", br.dropOptions.Toggle,  6)
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
local buff
local cast
local cd
local charges
local covenant
local conduit
local debuff
local enemies
local equiped
local module
local power
local runeforge
local talent
local ui
local unit
local units
local var
local actionList = {}

-----------------------
--- Local Functions ---
-----------------------
local function alwaysCdNever(option)
    if option == "Racial" then GetSpellInfo(br.player.spell.racial) end
    local thisOption = ui.value(option)
    return thisOption == 1 or (thisOption == 2 and ui.useCDs())
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
                PetStopAttack()
                PetFollow()
                Print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Misdirection
    if ui.mode.misdirection == 1 then
        local misdirectUnit = nil
        if unit.valid("target") and unit.distance("target") < 40 and not unit.isCasting("player") then
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
        -- Bursting Shot
        if ui.checked("Bursting Shot") and #enemies.yards8 >= ui.value("Bursting Shot") and unit.inCombat() then
            if cast.burstingShot("player") then ui.debug("Casting Bursting Shot") return true end
        end
        -- Concussive Shot
        if ui.checked("Concussive Shot") and unit.distance("target") < ui.value("Concussive Shot")
            and unit.valid("target") and unit.facing("target") and unit.ttd("target") > unit.gcd(true)
            and unit.moving("target")
        then
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
        for i=1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            local distance = unit.distance(thisUnit)
            if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                if distance < 50 then
                    -- Counter Shot
                    if ui.checked("Counter Shot") then
                        if cast.counterShot(thisUnit) then ui.debug("Casting Counter Shot") return true end
                    end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
    if ui.useCDs() and ui.checked("Racial") then
        -- berserking,if=buff.trueshot.up|target.time_to_die<13
        -- blood_fury,if=buff.trueshot.up|target.time_to_die<16
        -- ancestral_call,if=buff.trueshot.up|target.time_to_die<16
        -- fireblood,if=buff.trueshot.up|target.time_to_die<9
        if (buff.trueshot.exists() and not unit.race() == "LightforgedDraenei")
            or (unit.race() == "Troll" and unit.ttd() < 13 and ui.useCDs())
            or ((unit.race() == "Orc" or unit.race() == "MagharOrc") and unit.ttd() < 16 and ui.useCDs())
            or (unit.race() == "DarkIronDwarf" and unit.ttd() < 9 and ui.useCDs())
        then
            if cast.racial() then ui.debug("Casting Racial") return true end
        end
        -- lights_judgment,if=buff.trueshot.down
        if unit.race() == "LightforgedDraenei" and not buff.trueshot.exists() then
            if cast.racial("target","ground") then return true end
        end
        -- bag_of_tricks,if=buff.trueshot.down
    end
    -- Potion
    -- potion,if=buff.trueshot.up&buff.bloodlust.up|buff.trueshot.up&target.health.pct<20|target.time_to_die<26
    -- if ui.useCDs() and ui.checked("Potion") and canUseItem(142117) and unit.instance("raid") then
    --     if buff.trueshot.exists() and (buff.bloodLust.exists() or var.caActive or buff.trueshot.exists or (unit.ttd(units.dyn40) < 25 and ui.useCDs())) then
    --         useItem(142117)
    --     end
    -- end
end -- End Action List - Cooldowns

-- Action List - Trick Shots
actionList.TrickShots = function()
    -- Steady Shot
    -- steady_shot,if=talent.steady_focus&in_flight&buff.steady_focus.remains<5
    if cast.able.steadyShot() and talent.steadyFocus and cast.inFlight.steadyShot() and buff.steadyFocus.remains() < 5 then
        if cast.steadyShot() then ui.debug("Casting Steady Shot [Trick Shots Steady Focus]") return true end
    end
    -- Double Tap
    -- double_tap,if=covenant.kyrian&cooldown.resonating_arrow.remains<gcd|!covenant.kyrian&!covenant.night_fae|covenant.night_fae&(cooldown.wild_spirits.remains<gcd|cooldown.trueshot.remains>55)|target.time_to_die<10
    if alwaysCdNever("Double Tap") and cast.able.doubleTap() and talent.doubleTap
        and ((((covenant.kyrian.active and (cd.resonatingArrow.remains() < unit.gcd(true) or not alwaysCdNever("Covenant Ability"))) or not covenant.kyrian.active)
        and (not covenant.nightFae.active or (covenant.nightFae.active and ((cd.wildSpirits.remain() < unit.gcd(true) or not alwaysCdNever("Covenant Ability")) or cd.trueshot.remains() > 55))))
        or (unit.isBoss("target") and unit.ttd("target") < 10))
    then
        if cast.doubleTap() then ui.debug("Casting Double Tap [Trick Shots]") return true end
    end
    -- Tar Trap
    -- tar_trap,if=runeforge.soulforge_embers&tar_trap.remains<gcd&cooldown.flare.remains<gcd
    if cast.able.tarTrap() and runeforge.soulforgeEmbers.equiped and debuff.tarTrap.remains(units.dyn40) < unit.gcd(true) and cd.flare.remains() < unit.gcd(true) then
        if cast.tarTrap(units.dyn40,"ground") then ui.debug("Casting Tar Trap [Trick Shots Soulforge Embers]") return true end
    end
    -- Flare
    -- flare,if=tar_trap.up&runeforge.soulforge_embers
    if cast.able.flare() and debuff.tarTrap.exists(units.dyn40) and runeforge.soulforgeEmbers.equiped then
        if cast.flare(units.dyn40) then ui.debug("Casting Flare [Trick Shots Soulforge Embers]") return true end
    end
    -- Explosive Shot
    -- explosive_shot
    if alwaysCdNever("Explosive Shot") and cast.able.explosiveShot() and talent.explosiveShot then
        if cast.explosiveShot() then ui.debug("Casting Explosive Shot [Trick Shots]") return true end
    end
    -- Wild Spirits
    -- wild_spirits
    if alwaysCdNever("Covenant Ability") and cast.able.wildSpirits() then
        if cast.wildSpirits() then ui.debug("Casting Wild Spirits [Trick Shots Night Fae]") return true end
    end
    -- Resonating Arrow
    -- resonating_arrow
    if alwaysCdNever("Covenant Ability") and cast.able.resonatingArrow() then
        if cast.resonatingArrow() then ui.debug("Casting Resonating Arrow [Trick Shots Kyrian]") return true end
    end
    -- Volley
    -- volley
    if cast.able.volley() and ui.checked("Volley Units") and #enemies.yards8t >= ui.value("Volley Units") then
        if cast.volley("best",nil,ui.value("Volley Units"),8) then ui.debug("Casting Volley [Trick Shots]") return true end
    end
    -- Barrage
    -- barrage
    if alwaysCdNever("Barrage") and cast.able.barrage() and talent.barrage then
        if cast.barrage() then ui.debug("Casting Barrage [Trick Shots]") return true end
    end
    -- Trueshot
    -- trueshot
    if alwaysCdNever("Trueshot") and cast.able.trueshot() then
        if cast.trueshot("player") then ui.debug("Casting Trueshot [Trick Shots]") return true end
    end 
    -- Rapid Fire
    -- rapid_fire,if=buff.trick_shots.remains>=execute_time&runeforge.surging_shots&buff.double_tap.down
    if alwaysCdNever("Rapid Fire") and cast.able.rapidFire() and buff.trickShots.remains() > cast.time.rapidFire()
        and runeforge.surgingShots.equiped and not buff.doubleTap.exists()
    then
        if cast.rapidFire() then ui.debug("Casting Rapid Fire [Trick Shots Surging Shots]") return true end
    end
    -- Aimed Shot
    -- aimed_shot,target_if=min:dot.serpent_sting.remains+action.serpent_sting.in_flight_to_target*99,if=buff.trick_shots.remains>=execute_time&(buff.precise_shots.down|full_recharge_time<cast_time+gcd|buff.trueshot.up)
    if cast.able.aimedShot(var.lowestAimedSerpentSting) and not unit.moving("player") and unit.ttd(units.dyn40) > cast.time.aimedShot() and buff.trickShots.remains() >= cast.time.aimedShot()
        and (not buff.preciseShots.exists() or charges.aimedShot.timeTillFull() < cast.time.aimedShot() + unit.gcd(true) or buff.trueshot.exists())
    then
        if cast.aimedShot(var.lowestAimedSerpentSting) then ui.debug("Casting Aimed Shot [Trick Shots]") return true end
    end
    -- Death Chakram
    -- death_chakram,if=focus+cast_regen<focus.max
    if alwaysCdNever("Covenant Ability") and cast.able.deathChakram() and power.focus.amount() + cast.regen.deathChakram() < power.focus.max() then
        if cast.deathChakram() then ui.debug("Casting Death Chakram [Trick Shots Necrolord]") return true end
    end
    -- Rapid Fire
    -- rapid_fire,if=buff.trick_shots.remains>=execute_time
    if alwaysCdNever("Rapid Fire") and cast.able.rapidFire() and buff.trickShots.remains() >= cast.time.rapidFire() then
        if cast.rapidFire() then ui.debug("Casting Rapid Fire [Trick Shots]") return true end
    end
    -- Multishot
    -- multishot,if=buff.trick_shots.down|buff.precise_shots.up&focus>cost+action.aimed_shot.cost&(!talent.chimaera_shot|active_enemies>3)
    if cast.able.multishot() and (not buff.trickShots.exists() or buff.preciseShots.exists()
        and power.focus.amount() > cast.cost.multishot() + cast.cost.aimedShot() and (not talent.chimaeraShot or #enemies.yards10t > 3))
        and #enemies.yards10t > 0
    then
        if cast.multishot() then ui.debug("Casting Multishot [Trick Shots]") return true end
    end
    -- Chimaera Shot
    -- chimaera_shot,if=buff.precise_shots.up&focus>cost+action.aimed_shot.cost&active_enemies<4
    if cast.able.chimaeraShot() and buff.preciseShots.exists() and power.focus.amount() > cast.cost.chimaeraShot() + cast.cost.aimedShot() and #enemies.yards40f < 4 then
        if cast.chimaeraShot() then ui.debug("Casting Chimaera Shot [Trick Shots]") return true end
    end
    -- Kill Shot
    -- kill_shot,if=buff.dead_eye.down
    if cast.able.killShot(var.lowestHPUnit) and unit.hp(var.lowestHPUnit) < 20 and not buff.deadEye.exists() then
        if cast.killShot(var.lowestHPUnit) then ui.debug("Casting Kill Shot [Trick Shots Dead Eye]") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if alwaysCdNever("A Murder of Crows") and cast.able.aMurderOfCrows() and talent.aMurderOfCrows then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [Trick Shots]") return true end
    end
    -- Flayed Shot
    -- flayed_shot
    if alwaysCdNever("Covenant Ability") and cast.able.flayedShot() then
        if cast.flayedShot() then ui.debug("Casting Flayed Shot [Trick Shots Venthhyr]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:dot.serpent_sting.remains,if=refreshable
    if cast.able.serpentSting(var.lowestSerpentSting) and talent.serpentSting and debuff.serpentSting.refresh(var.lowestSerpentSting) then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [Trick Shots]") return true end
    end
    -- Multishot
    -- multishot,if=focus>cost+action.aimed_shot.cost
    if cast.able.multishot() and power.focus.amount() > cast.cost.multishot() + cast.cost.aimedShot() and #enemies.yards10t > 0 then
        if cast.multishot() then ui.debug("Casting Multishot [Trick Shots]") return true end
    end
    -- Steady Shot
    -- steady_shot
    if cast.able.steadyShot() and unit.ttd(units.dyn40) > cast.time.steadyShot() then
        if cast.steadyShot() then ui.debug("Casting Steady Shot [Trick Shots]") return true end
    end
end -- End Action List - Trick Shots

-- Action List - Single Target
actionList.SingleTarget = function()
    -- Steady Shot
    -- steady_shot,if=talent.steady_focus&(prev_gcd.1.steady_shot&buff.steady_focus.remains<5|buff.steady_focus.down)
    if cast.able.steadyShot() and talent.steadyFocus and ((cast.last.steadyShot() and buff.steadyFocus.remain() < 5) or not buff.steadyFocus.exists()) then
        if cast.steadyShot() then ui.debug("Casting Steady Shot [Steady Focus]") return true end
    end
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot(var.lowestHPUnit) and unit.hp(var.lowestHPUnit) < 20 then
        if cast.killShot(var.lowestHPUnit) then ui.debug("Casting Kill Shot") return true end
    end
    -- Double Tap
    -- double_tap,if=covenant.kyrian&cooldown.resonating_arrow.remains<gcd|!covenant.kyrian&!covenant.night_fae|covenant.night_fae&(cooldown.wild_spirits.remains<gcd|cooldown.trueshot.remains>55)|target.time_to_die<15
    if alwaysCdNever("Double Tap") and cast.able.doubleTap() and talent.doubleTap and (not cast.last.steadyShot() or buff.steadyFocus.exists() or not talent.steadyFocus)
        and ((((covenant.kyrian.active and (cd.resonatingArrow.remains() < unit.gcd(true) or not alwaysCdNever("Covenant Ability"))) or not covenant.kyrian.active)
        and (not covenant.nightFae.active or (covenant.nightFae.active and ((cd.wildSpirits.remains() < unit.gcd(true) or not alwaysCdNever("Covenant Ability")) or cd.trueshot.remains() > 55))))
        or (unit.isBoss("target") or unit.ttd("target") < 15))
    then
        if cast.doubleTap() then ui.debug("Casting Double Tap") return true end
    end
    -- Flare
    -- flare,if=tar_trap.up&runeforge.soulforge_embers
    if cast.able.flare() and debuff.tarTrap.exists(units.dyn40) and runeforge.soulforgeEmbers.equiped then
        if cast.flare(units.dyn40) then ui.debug("Casting Flare [Soulforge Embers]") return true end
    end
    -- Tar Trap
    -- tar_trap,if=runeforge.soulforge_embers&tar_trap.remains<gcd&cooldown.flare.remains<gcd
    if cast.able.tarTrap() and runeforge.soulforgeEmbers.equiped
        and debuff.tarTrap.remains(units.dyn40) < unit.gcd(true) and cd.flare.remains() < unit.gcd(true)
    then
        if cast.tarTrap(units.dyn40,"ground") then ui.debug("Casting Tar Trap [Soulforge Embers]") return true end
    end
    -- Explosive Shot
    -- explosive_shot
    if alwaysCdNever("Explosive Shot") and cast.able.explosiveShot() and talent.explosiveShot then
        if cast.explosiveShot() then ui.debug("Casting Explosive Shot") return true end
    end
    -- Wild Spirits
    -- wild_spirits
    if alwaysCdNever("Covenant Ability") and cast.able.wildSpirits() then
        if cast.wildSpirits() then ui.debug("Casting Wild Spirits [Night Fae]") return true end
    end
    -- Flayed Shot
    -- flayed_shot
    if alwaysCdNever("Covenant Ability") and cast.able.flayedShot() then
        if cast.flayedShot() then ui.debug("Casting Flayed Shot [Venthhyr]") return true end
    end
    -- Death Chakram
    -- death_chakram,if=focus+cast_regen<focus.max
    if alwaysCdNever("Covenant Ability") and cast.able.deathChakram() and power.focus.amount() + cast.regen.deathChakram() < power.focus.max() then
        if cast.deathChakram() then ui.debug("Casting Death Chakram [Necrolord]") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if alwaysCdNever("A Murder of Crows") and cast.able.aMurderOfCrows() and talent.aMurderOfCrows then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows") return true end
    end
    -- Resonating Arrow
    -- resonating_arrow
    if alwaysCdNever("Covenant Ability") and cast.able.resonatingArrow() then
        if cast.resonatingArrow() then ui.debug("Casting Resonating Arrow [Kyrian]") return true end
    end
    -- Volley
    -- volley,if=buff.precise_shots.down|!talent.chimaera_shot|active_enemies<2
    if cast.able.volley() and ui.checked("Volley Units") and (not buff.preciseShots.exists() or not talent.chimaeraShot or #enemies.yards8t < 2) and (#enemies.yards8t >= ui.value("Volley Units")) then
        if cast.volley("best",nil,ui.value("Volley Units"),8) then ui.debug("Casting Volley") return true end
    end
    -- Trueshot
    -- trueshot,if=buff.precise_shots.down|buff.resonating_arrow.up|buff.wild_spirits.up|buff.volley.up&active_enemies>1
    if alwaysCdNever("Trueshot") and cast.able.trueshot() and (not buff.preciseShots.exists() or debuff.resonatingArrow.exists(units.dyn40)
        or debuff.wildMark.exists(units.dyn40) or buff.volley.exists() and #enemies.yards40f > 1)
    then
        if cast.trueshot("player") then ui.debug("Casting Trueshot [Trick Shots]") return true end
    end 
    -- Aimed Shot
    -- aimed_shot,target_if=min:dot.serpent_sting.remains+action.serpent_sting.in_flight_to_target*99,if=buff.precise_shots.down|(buff.trueshot.up|full_recharge_time<gcd+cast_time)&(!talent.chimaera_shot|active_enemies<2)|buff.trick_shots.remains>execute_time&active_enemies>1
    if cast.able.aimedShot(var.lowestAimedSerpentSting) and not unit.moving("player") and (not buff.preciseShots.exists()
        or ((buff.trueshot.exists() or charges.aimedShot.timeTillFull() < unit.gcd(true) + cast.time.aimedShot())
        and (not talent.chimaeraShot or #enemies.yards40f < 2)) or buff.trickShots.remain() > cast.time.aimedShot() and #enemies.yards40f > 1)
    then
        if cast.aimedShot(var.lowestAimedSerpentSting) then ui.debug("Casting Aimed Shot") return true end
    end
    -- Rapid Fire
    -- rapid_fire,if=focus+cast_regen<focus.max&(buff.trueshot.down|!runeforge.eagletalons_true_focus)&(buff.double_tap.down|talent.streamline)
    if alwaysCdNever("Rapid Fire") and cast.able.rapidFire() and (power.focus.amount() + power.focus.regen() < power.focus.max()
        and (not buff.trueshot.exists() or not runeforge.eagletalonsTrueFocus.equiped)
        and (not buff.doubleTap.exists() or talent.streamline))
    then
        if cast.rapidFire() then ui.debug("Casting Rapid Fire") return true end
    end
    -- Chimaera Shot
    -- chimaera_shot,if=buff.precise_shots.up|focus>cost+action.aimed_shot.cost
    if cast.able.chimaeraShot() and (buff.preciseShots.exists()
        or power.focus.amount() > cast.cost.chimaeraShot() + cast.cost.aimedShot())
    then
        if cast.chimaeraShot() then ui.debug("Casting Chimaera Shot") return true end
    end
    -- Arcane Shot
    -- arcane_shot,if=buff.precise_shots.up|focus>cost+action.aimed_shot.cost
    if cast.able.arcaneShot() and (buff.preciseShots.exists()
        or power.focus.amount() > cast.cost.arcaneShot() + cast.cost.aimedShot())
    then
        if cast.arcaneShot() then ui.debug("Casting Arcane Shot") return true end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=refreshable&target.time_to_die>duration
    if cast.able.serpentSting(var.lowestSerpentSting) and debuff.serpentSting.refresh(var.lowestSerpentSting)
        and unit.ttd(var.lowestSerpentSting) > debuff.serpentSting.duration(var.lowestSerpentSting)
    then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting") return true end
    end
    -- Barrage
    -- barrage,if=active_enemies>1
    if alwaysCdNever("Barrage") and cast.able.barrage() and talent.barrage
        and ((ui.mode.rotation == 1 and #enemies.yards40f > 1) or (ui.mode.rotation == 2 and #enemies.yards40f > 0))
    then
        if cast.barrage() then ui.debug("Casting Barrage") return true end
    end
    -- Rapid Fire
    -- rapid_fire,if=focus+cast_regen<focus.max&(buff.double_tap.down|talent.streamline)
    if alwaysCdNever("Rapid Fire") and cast.able.rapidFire()
        and (power.focus.amount() + power.focus.regen() < power.focus.max()
        and (not buff.doubleTap.exists() or talent.streamline))
    then
        if cast.rapidFire() then ui.debug("Casting Rapid Fire") return true end
    end
    -- Steady Shot
    -- steady_shot
    if cast.able.steadyShot() and unit.ttd(units.dyn40) > cast.time.steadyShot() then
        if cast.steadyShot() then ui.debug("Casting Steady Shot") return true end
    end
end -- End Action List - Single Target

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not buff.feignDeath.exists() then
        -- Flask Up Module
        module.FlaskUp("Agility")
        -- Augmentation
        -- augmentation
        -- Summon Pet
        -- summon_pet
        -- if actionList.PetManagement() then ui.debug("") return true end
        if unit.valid("target") and unit.distance("target") < 40 and not ui.checked("Do Not Auto Engage if OOC") then
            -- Tar Trap
            -- tar_trap,if=runeforge.soulforge_embers
            if cast.able.tarTrap() and runeforge.soulforgeEmbers.equiped then
                if cast.tarTrap(units.dyn40,"ground") then ui.debug("Casting Tar Trap [Soulforge Embers]") return true end
            end
            -- Double Tap
            -- double_tap,precast_time=10,if=active_enemies>1|!covenant.kyrian&!talent.volley
            if cast.able.doubleTap() and ui.pullTimer() <= 10 and (#enemies.yards40f > 1 or (not covenant.kyrian.active and not talent.volley)) then
                if cast.doubleTap() then ui.debug("Casting Double Tap [Pre-Pull]") return true end
            end
            -- Aimed Shot
            -- aimed_shot,if=active_enemies<3&(!covenant.kyrian&!talent.volley|active_enemies<2)
            if cast.able.aimedShot() and not unit.moving("player") and #enemies.yards40f < 3 and (#enemies.yards40f < 2 or (not covenant.kyrian.active and not talent.volley)) then
                if cast.aimedShot("target") then ui.debug("Casting Aimed Shot [Pre-Pull]") return true end
            end
            -- Arcane Shot
            -- steady_shot,if=active_enemies>2|(covenant.kyrian|talent.volley)&active_enemies=2
            if cast.able.arcaneShot() and (#enemies.yards40f > 2 or ((covenant.kyrian.active or talent.volley) and #enemies.yards40f == 2)) then
                if cast.arcaneShot("target") then ui.debug("Casting Arcane Shot [Pre-Pull]") return true end
            end
            -- Auto Shot
            unit.startAttack("target")
        end
    end
end -- End Action List - Pre-Pull

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
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    covenant                                      = br.player.covenant
    conduit                                       = br.player.conduit
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    equiped                                       = br.player.equiped
    module                                        = br.player.module
    power                                         = br.player.power
    runeforge                                     = br.player.runeforge
    talent                                        = br.player.talent
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    var                                           = br.player.variables

    units.get(40)
    enemies.get(5,"pet")
    enemies.get(8)
    enemies.get(8,"target")
    enemies.get(8,"pet")
    enemies.yards10t = enemies.get(10,units.get(40))
    enemies.yards25r = getEnemiesInRect(8,25,false) or 0
    enemies.get(30,"pet")
    enemies.get(40)
    enemies.get(40,"player",true)
    enemies.get(40,"player",false,true)

    -- Variables
    if var.profileStop == nil then var.profileStop = false end
    var.getCombatTime = _G["getCombatTime"]
    var.haltProfile = (unit.inCombat() and var.profileStop) or (unit.mounted() or unit.flying()) or pause() or buff.feignDeath.exists() or ui.mode.rotation==4
    var.role = _G["UnitGroupRolesAssigned"]
    var.caActive = talent.carefulAim and (unit.hp(units.dyn40) > 80 or unit.hp(units.dyn40) < 20)
    var.lowestSerpentSting = debuff.serpentSting.lowest(40,"remain") or "target"
    var.serpentInFlight = cast.inFlight.serpentSting() and 1 or 0
    
    var.lowestAimedSerpentSting = "target"
    var.lowestAimedRemain = 99
    var.lowestHPUnit = "target"
    var.lowestHP = 100
    for i = 1, #enemies.yards40f do
        local thisUnit = enemies.yards40f[i]
        local thisHP = unit.hp(thisUnit)
        local serpentStingRemain = debuff.serpentSting.remain(thisUnit) + var.serpentInFlight * 99
        if ui.mode.rotation < 3 and serpentStingRemain < var.lowestAimedRemain then
            var.lowestAimedRemain = serpentStingRemain
            var.lowestAimedSerpentSting = thisUnit
        end
        if thisHP < var.lowestHP then
            var.lowestHP = thisHP
            var.lowestHPUnit = thisUnit
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif var.haltProfile and (not unit.isCasting() or pause(true)) then
        StopAttack()
        if unit.isDummy() then ClearTarget() end
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then return true end
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
        if unit.inCombat() and var.profileStop == false and unit.valid(units.dyn40) and unit.distance(units.dyn40) < 40
            and not cast.current.barrage() and not cast.current.rapidFire() and not cast.current.aimedShot() and not cast.current.steadyShot()
        then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end
            ------------------------
            --- In Combat - Main ---
            ------------------------
            -- Counter Shot
            -- counter_shot,line_cd=30,if=runeforge.sephuzs_proclamation|soulbind.niyas_tools_poison|(conduit.reversal_of_fortune&!runeforge.sephuzs_proclamation)
            -- Basic Trinkets Module
            -- use_items,if=buff.trueshot.remains>14|!talent.calling_the_shots.enabled|target.time_to_die<20
            if buff.trueshot.remains() > 14 or not talent.callingTheShots or (unit.ttd(units.dyn40) < 20 and ui.useCDs()) then
                module.BasicTrinkets()
            end
            -- Call Action List - Cooldowns
            -- call_action_list,name=cooldowns
            if actionList.Cooldowns() then return true end
            -- Call Action List - Single Target
            -- call_action_list,name=st,if=active_enemies<3
            if ((ui.mode.rotation == 1 and #enemies.yards40f < 3) or (ui.mode.rotation == 3 and #enemies.yards40f > 0) or unit.level() < 32) then
                if actionList.SingleTarget() then return true end
            end
            -- Call Action List - Trick Shots
            -- call_action_list,name=trickshots,if=active_enemies>2
            if unit.level() >= 32 and ((ui.mode.rotation == 1 and #enemies.yards40f > 2) or (ui.mode.rotation == 2 and #enemies.yards40f > 0)) then
                if actionList.TrickShots() then return true end
            end
        end --End In Combat
    end --End Rotation Logic
end -- End runRotation
local id = 254
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
