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
            -- Misdirection
            br.ui:createDropdownWithout(section,"Misdirection", {"|cff00FF00Tank","|cffFFFF00Focus","|cffFF0000Pet"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
            -- Heart Essence
            br.ui:createCheckbox(section,"Use Essence")
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
local debuff
local enemies
local essence
local equiped
local module
local power
local talent
local traits
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
    return thisOption == 1 or (thisOption == 2 and ui.ui.useCDs())
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
        if unit.valid("target") and unit.distance("target") < 40 then
            local misdirectUnit = "pet"
            if ui.value("Misdirection") == 1 and (unit.instance("party") or unit.instance("raid")) then
                for i = 1, #br.friend do
                    local thisFriend = br.friend[i].unit
                    if (br.friend[i].role == "TANK" or var.role(thisFriend) == "TANK")
                        and not unit.deadOrGhost(thisFriend)
                    then
                        misdirectUnit = thisFriend
                        break
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
        -- Bursting Shot
        if ui.checked("Bursting Shot") and #enemies.yards8 >= ui.value("Bursting Shot") and unit.inCombat() then
            if cast.burstingShot("player") then ui.debug("Casting Bursting Shot") return true end
        end
        -- Concussive Shot
        if ui.checked("Concussive Shot") and unit.distance("target") < ui.value("Concussive Shot")
            and unit.valid("target") and unit.facing("target") and unit.ttd("target") > unit.gcd(true)
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
    end -- End Defensive Toggle
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i=1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            local distance = unit.distance(thisUnit)
            if canInterrupt(thisUnit,ui.value("Interrupts")) then
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
    -- Double Tap
    -- double_tap,if=cooldown.rapid_fire.remains<gcd|cooldown.rapid_fire.remains<cooldown.aimed_shot.remains|target.time_to_die<20
    if alwaysCdNever("Double Tap") and cast.able.doubleTap() and talent.doubleTap
        and (cd.rapidFire.remain() < unit.gcd(true) or cd.rapidFire.remain() < cd.aimedShot.remain() or (unit.ttd(units.dyn40) < 20 and ui.ui.useCDs()))
    then
        if cast.doubleTap() then ui.debug("Casting Double Tap") return true end
    end
    -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
    if ui.useCDs() and ui.checked("Racial") then
        -- berserking,    if=buff.trueshot.remains>14&(target.time_to_die>cooldown.berserking.duration+duration    |(target.health.pct<20|!talent.careful_aim.enabled))|target.time_to_die<13
        -- blood_fury,    if=buff.trueshot.remains>14&(target.time_to_die>cooldown.blood_fury.duration+duration    |(target.health.pct<20|!talent.careful_aim.enabled))|target.time_to_die<16
        -- ancestral_call,if=buff.trueshot.remains>14&(target.time_to_die>cooldown.ancestral_call.duration+duration|(target.health.pct<20|!talent.careful_aim.enabled))|target.time_to_die<16
        -- fireblood,     if=buff.trueshot.remains>14&(target.time_to_die>cooldown.fireblood.duration+duration     |(target.health.pct<20|!talent.careful_aim.enabled))|target.time_to_die<9
        if (unit.race() == "Troll" and buff.trueshot.remain() > 14 and (unit.ttd(units.dyn40) > (180 + 15) or (unit.hp(units.dyn40) < 20 or not talent.carefulAim)) or unit.ttd(units.dyn40) < 13)
            or (unit.race() == "Orc" and buff.trueshot.remain() > 14 and (unit.ttd(units.dyn40) > (120 + 15) or (unit.hp(units.dyn40) < 20 or not talent.carefulAim)) or unit.ttd(units.dyn40) < 16)
            or (unit.race() == "MagharOrc" and buff.trueshot.remain() > 14 and (unit.ttd(units.dyn40) > (120 + 15) or (unit.hp(units.dyn40) < 20 or not talent.carefulAim)) or unit.ttd(units.dyn40) < 13)
            or (unit.race() == "DarkIronDwarf" and buff.trueshot.remain() > 14 and (unit.ttd(units.dyn40) > (120 + 15) or (unit.hp(units.dyn40) < 20 or not talent.carefulAim)) or unit.ttd(units.dyn40) < 13)
        then
            if cast.racial() then ui.debug("Casting Racial") return true end
        end
        -- lights_judgment,if=buff.trueshot.down
        if unit.race() == "LightforgedDraenei" and not buff.trueshot.exists() then
            if cast.racial("target","ground") then return true end
        end
    end
    -- Heart Essence
    if ui.checked("Use Essence") then
        -- reaping_flames,if=buff.trueshot.down&(target.health.pct>80|target.health.pct<=20|target.time_to_pct_20>30)
        if cast.able.reapingFlames() and not buff.trueshot.exists() and (unit.hp(units.dyn40) > 80 or unit.hp(units.dyn40) <= 20 or unit.ttd(units.dyn40,20) > 30) then
            if cast.reapingFlames() then ui.debug("Casting Reaping Flames") return true end
        end
        -- worldvein_resonance,if=(trinket.azsharas_font_of_power.cooldown.remains>20|!equipped.azsharas_font_of_power|target.time_to_die<trinket.azsharas_font_of_power.cooldown.duration+34&target.health.pct>20)&(cooldown.trueshot.remains_guess<3|(essence.vision_of_perfection.minor&target.time_to_die>cooldown+buff.worldvein_resonance.duration))|target.time_to_die<20
        if cast.able.worldveinResonance() and (cd.azsharasFontOfPower.remain() > 20 or not equiped.azsharasFontOfPower() or unit.ttd(units.dyn40) < (120 + 34) and unit.hp(units.dyn40) > 20)
            and (cd.trueshot.remain() < 3 or (essence.visionOfPerfection.minor and unit.ttd(units.dyn40) > (60 + 12))) or (unit.ttd(units.dyn40) < 20 and ui.useCDs())
        then
            if cast.worldveinResonance() then ui.debug("Casting Worldvein Resonance") return true end
        end
        -- guardian_of_azeroth,if=(ca_active|target.time_to_die>cooldown+30)&(buff.trueshot.up|cooldown.trueshot.remains<16)|target.time_to_die<31
        if ui.useCDs() and cast.able.guardianOfAzeroth() and (var.caActive or unit.ttd(units.dyn40) > (180 + 30))
            and (buff.trueshot.exists() or cd.trueshot.remain() < 16) or (unit.ttd(units.dyn40) < 31 and ui.useCDs())
        then
            if cast.guardianOfAzeroth() then ui.debug("Casting Guardian of Azeroth") return true end
        end
        -- ripple_in_space,if=cooldown.trueshot.remains<7
        if cast.able.rippleInSpace() and cd.trueshot.remain() < 7 then
            if cast.rippleInSpace() then ui.debug("Casting Ripple In Space") return true end
        end
        -- memory_of_lucid_dreams,if=!buff.trueshot.up
        if ui.useCDs() and cast.able.memoryOfLucidDreams() and not buff.trueshot.exists() then
            if cast.memoryOfLucidDreams() then ui.debug("Casting Memory of Lucid Dreams") return true end
        end
    end
    -- Potion
    -- potion,if=buff.trueshot.react&buff.bloodlust.react|buff.trueshot.remains>14&target.health.pct<20|((consumable.potion_of_unbridled_fury|consumable.unbridled_fury)&target.time_to_die<61|target.time_to_die<26)
    -- if ui.useCDs() and ui.checked("Potion") and canUseItem(142117) and unit.instance("raid") then
    --     if buff.trueshot.exists() and (buff.bloodLust.exists() or var.caActive or buff.trueshot.exists or (unit.ttd(units.dyn40) < 25 and ui.useCDs())) then
    --         useItem(142117)
    --     end
    -- end
    -- Trueshot
    -- trueshot,if=buff.trueshot.down&cooldown.rapid_fire.remains|target.time_to_die<15
    if alwaysCdNever("Trueshot") and cast.able.trueshot() and (not buff.trueshot.exists() and cd.rapidFire.exists() or (unit.ttd(units.dyn40) < 15 and ui.useCDs())) then
        if cast.trueshot("player") then ui.debug("Casting Trueshot") return true end
    end
end -- End Action List - Cooldowns

-- Action List - Trick Shots
actionList.TrickShots = function()
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot() then
        if cast.killShot() then unit.debug("Casting Kill Shot [Trick Shots]") return true end
    end
    -- Volley
    -- volley
    if cast.able.volley() then
        if cast.volley("best",nil,3,8) then ui.debug("Casting Volley [Trick Shots]") return true end
    end
    -- Barrage
    -- barrage
    if alwaysCdNever("Barrage") and cast.able.barrage() and talent.barrage then
        if cast.barrage() then ui.debug("Casting Barrage [Trick Shots]") return true end
    end
    -- Explosive Shot
    -- explosive_shot
    if alwaysCdNever("Explosive Shot") and cast.able.explosiveShot() and talent.explosiveShot then
        if cast.explosiveShot() then ui.debug("Casting Explosive Shot [Trick Shots]") return true end
    end
    -- Aimed Shot
    -- aimed_shot,if=buff.trick_shots.up&ca_active&buff.double_tap.up
    if cast.able.aimedShot() and not unit.moving("player") and buff.trickShots.exists()
        and var.caActive and buff.doubleTap.exists() and unit.ttd(units.dyn40) > cast.time.aimedShot()
    then
        if cast.aimedShot() then ui.debug("Casting Aimed Shot [Trick Shots Careful Aim]") return true end
    end
    -- Rapid Fire
    -- rapid_fire,if=buff.trick_shots.up&(azerite.focused_fire.enabled|azerite.in_the_rhythm.rank>1|azerite.surging_shots.enabled|talent.streamline.enabled)
    if alwaysCdNever("Rapid Fire") and cast.able.rapidFire() and buff.trickShots.exists()
        and (traits.focusedFire.active or traits.inTheRhythm.rank > 1 or traits.surgingShots.active or talent.streamline)
    then
        if cast.rapidFire() then ui.debug("Casting Rapid Fire [Trick Shots Traits]") return true end
    end
    -- Aimed Shot
    -- aimed_shot,if=buff.trick_shots.up&(buff.precise_shots.down|cooldown.aimed_shot.full_recharge_time<action.aimed_shot.cast_time|buff.trueshot.up)
    if cast.able.aimedShot() and not unit.moving("player") and unit.ttd(units.dyn40) > cast.time.aimedShot() and buff.trickShots.exists()
        and (not buff.preciseShots.exists() or charges.aimedShot.timeTillFull() < cast.time.aimedShot() or buff.trueshot.exists())
    then
        if cast.aimedShot() then ui.debug("Casting Aimed Shot [Trick Shots]") return true end
    end
    -- Rapid Fire
    -- rapid_fire,if=buff.trick_shots.up
    if alwaysCdNever("Rapid Fire") and cast.able.rapidFire() and buff.trickShots.exists() then
        if cast.rapidFire() then ui.debug("Casting Rapid Fire [Trick Shots]") return true end
    end
    -- Multishot
    -- multishot,if=buff.trick_shots.down|buff.precise_shots.up&!buff.trueshot.up|focus>70
    if cast.able.multishot() and (not buff.trickShots.exists() or buff.preciseShots.exists() and not buff.trueshot.exists() or power.focus.amount() > 70) then
        if cast.multishot() then ui.debug("Casting Multishot [Trick Shots]") return true end
    end
    -- Heart Essence
    if ui.checked("Use Essence") then
        -- Focused Azerite Beam
        -- focused_azerite_beam
        if cast.able.focusedAzeriteBeam() and not unit.isExplosive("target")
            and (enemies.yards25r >= 3 or (ui.useCDs() and enemies.yards25r > 0))
        then
            local minBeamCount = ui.useCDs() and 1 or 3
            if cast.focusedAzeriteBeam(nil,"rect",minBeamCount,30) then ui.debug("Casting Focused Azerite Beam [Trick Shots]") return true end
        end
        -- Purifying Blast
        -- purifying_blast
        if cast.able.purifyingBlast() then
            if cast.purifyingBlast("best", nil, 1, 8) then ui.debug("Casting Purifying Blast [Trick Shots]") return true end
        end
        -- Concentrated Flame
        -- concentrated_flame
        if cast.able.concentratedFlame() then
            if cast.concentratedFlame() then ui.debug("Casting Concentrated Flame [Trick Shots]") return true end
        end
        -- Blood of the Enemy
        -- blood_of_the_enemy
        if cast.able.bloodOfTheEnemy() then
            if cast.bloodOfTheEnemy() then ui.debug("Casting Blood of the Enemy [Trick Shots]") return true end
        end
        -- The Unbound Force
        -- the_unbound_force,if=buff.reckless_force.up|buff.reckless_force_counter.stack<10
        if cast.able.theUnboundForce() and (buff.recklessForce.exists() or buff.recklessForce.stack() < 10) then
            if cast.theUnboundForce() then ui.debug("Casting The Unbound Force [Trick Shots]") return true end
        end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if alwaysCdNever("A Murder of Crows") and cast.able.aMurderOfCrows() and talent.aMurderOfCrows then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [Trick Shots]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,if=refreshable&!action.serpent_sting.in_flight
    if cast.able.serpentSting() and talent.serpentSting and debuff.serpentSting.refresh(units.dyn40) and not cast.inFlight.serpentSting(units.dyn40) then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting [Trick Shots]") return true end
    end
    -- Steady Shot
    -- steady_shot
    if cast.able.steadyShot() and unit.ttd(units.dyn40) > cast.time.steadyShot() then
        if cast.steadyShot() then ui.debug("Casting Steady Shot [Trick Shots]") return true end
    end
end -- End Action List - Trick Shots

-- Action List - Single Target
actionList.SingleTarget = function()
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot() then
        if cast.killShot() then ui.debug("Casting Kill Shot") return true end
    end
    -- Explosive Shot
    -- explosive_shot
    if alwaysCdNever("Explosive Shot") and cast.able.explosiveShot() and talent.explosiveShot then
        if cast.explosiveShot() then ui.debug("Casting Explosive Shot") return true end
    end
    -- Barrage
    -- barrage,if=active_enemies>1
    if alwaysCdNever("Barrage") and cast.able.barrage() and talent.barrage
        and ((ui.mode.rotation == 1 and #enemies.yards40f > 1) or (ui.mode.rotation == 2 and #enemies.yards40f > 0))
    then
        if cast.barrage() then ui.debug("Casting Barrage") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if alwaysCdNever("A Murder of Crows") and cast.able.aMurderOfCrows() and talent.aMurderOfCrows then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows") return true end
    end
    -- Volley
    -- volley
    if cast.able.volley() then
        if cast.volley("best",nil,3,8) then ui.debug("Casting Volley") return true end
    end
    -- Serpent Sting
    -- serpent_sting,if=refreshable&!action.serpent_sting.in_flight
    if cast.able.serpentSting() and talent.serpentSting and debuff.serpentSting.refresh(units.dyn40) and not cast.inFlight.serpentSting(units.dyn40) then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting") return true end
    end
    -- Rapid Fire
    -- rapid_fire,if=buff.trueshot.down|focus<35|focus<60&!talent.lethal_shots.enabled|buff.in_the_rhythm.remains<execute_time
    if alwaysCdNever("Rapid Fire") and cast.able.rapidFire() and (not buff.trueshot.exists() or power.focus.amount() < 35
        or (power.focus.amount() < 60 and not talent.lethalShots or buff.inTheRhythm.remains() < unit.gcd(true)))
    then
        if cast.rapidFire() then ui.debug("Casting Rapid Fire") return true end
    end
    -- Heart Essence: Blood of the Enemy
    -- blood_of_the_enemy,if=buff.trueshot.up&(buff.unerring_vision.stack>4|!azerite.unerring_vision.enabled)|target.time_to_die<11
    if ui.checked("Use Essence") and cast.able.bloodOfTheEnemy() and (buff.trueshot.exist()
        and (buff.unerringVision.stack() > 4 or not traits.unerringVision.active)
            or (unit.ttd(units.dyn40) < 11 or ui.useCDs()))
    then
        if cast.bloodOfTheEnemy() then ui.debug("Casting Blood of the Enemy") return true end
    end
    -- Heart Essence: Focused Azerite Beam
    -- focused_azerite_beam,if=!buff.trueshot.up|target.time_to_die<5
    if ui.checked("Use Essence") and cast.able.focusedAzeriteBeam() and not unit.isExplosive("target")
        and (enemies.yards25r >= 3 or (ui.useCDs() and enemies.yards25r > 0))
        and (not buff.trueshot.exists() or (unit.ttd("target") < 5 and ui.useCDs()))
    then
        local minBeamCount = ui.useCDs() and 1 or 3
        if cast.focusedAzeriteBeam(nil,"rect",minBeamCount,30) then ui.debug("Casting Focused Azerite Beam") return true end
    end
    -- Aimed Shot
    -- aimed_shot,if=buff.trueshot.up|(buff.double_tap.down|ca_active)&buff.precise_shots.down|full_recharge_time<cast_time&cooldown.trueshot.remains
    if cast.able.aimedShot() and not unit.moving("player") and (buff.trueshot.exists() or (not buff.doubleTap.exists() or var.caActive)
        and not buff.preciseShots.exists() or charges.aimedShot.timeTillFull() < cast.time.aimedShot()
        and cd.trueshot.remain() > 0) and unit.ttd(units.dyn40) > cast.time.aimedShot()
    then
        if cast.aimedShot() then ui.debug("Casting Aimed Shot") return true end
    end
    -- Heart Essence
    if ui.checked("Use Essence") then
        -- purifying_blast,if=!buff.trueshot.up|target.time_to_die<8
        if cast.able.purifyingBlast() and not buff.trueshot.exists() then
            if cast.purifyingBlast("best", nil, 1, 8) then ui.debug("Casting Purifying Blast") return true end
        end
        -- concentrated_flame,if=focus+focus.regen*gcd<focus.max&buff.trueshot.down&(!dot.concentrated_flame_burn.remains&!action.concentrated_flame.in_flight)|full_recharge_time<gcd|target.time_to_die<5
        if cast.able.concentratedFlame() and power.focus.amount() + power.focus.regen() * unit.gcd(true) < power.focus.max() and not buff.trueshot.exists()
            and (not debuff.concentratedFlame.exists(units.dyn40) and not cast.inFlight.concentratedFlame(units.dyn40))
            or charges.concentratedFlame.timeTillFull() < unit.gcd(true) or (unit.ttd(units.dyn40) < 5 and useCDs)
        then
            if cast.concentratedFlame() then ui.debug("Casting Concentrated Flame") return true end
        end
        -- the_unbound_force,if=buff.reckless_force.up|buff.reckless_force_counter.stack<10|target.time_to_die<5
        if cast.able.theUnboundForce() and (buff.recklessForce.exists() or buff.recklessForce.stack() < 10) then
            if cast.theUnboundForce() then ui.debug("Casting The Unbound Force") return true end
        end
    end
    -- Arcane Shot
    -- arcane_shot,if=buff.trueshot.down&(buff.precise_shots.up&(focus>55)|focus>75|target.time_to_die<5)
    if cast.able.arcaneShot() and not buff.trueshot.exists() and ((buff.preciseShots.exists()
        and power.focus.amount() > 55) or power.focus.amount() > 75 or (unit.ttd(units.dyn40) < 5 and ui.useCDs()))
    then
        if cast.arcaneShot() then ui.debug("Casting Arcane Shot") return true end
    end
    -- Chimaera Shot
    -- chimaera_shot,if=buff.trueshot.down&(buff.precise_shots.up&(focus>55)|focus>75|target.time_to_die<5)
    if cast.able.chimaeraShot() and (not buff.trueshot.exists() and ((buff.preciseShots.exists() and power.focus.amount() > 55)
        or power.focus.amount() > 75 or (unit.ttd(units.dyn40) < 5 and ui.useCDs())))
    then
        if cast.chimaeraShot() then ui.debug("Casting Chimaera Shot") return true end
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
        if unit.valid("target") and unit.distance("target") < 40 then
            -- Double Tap
            -- double_tap,precast_time=10
            if cast.able.doubleTap() and ui.pullTimer() <= 10 then
                if cast.doubleTap() then ui.debug("Casting Double Tap [Pre-Pull]") return true end
            end
            if ui.checked("Use Essence") and ui.useCDs() then
                -- worldvein_resonance
                if cast.able.worldveinResonance() then
                    if cast.worldveinResonance() then ui.debug("Casting Worldvein Resonance [Pre-Pull]") return true end
                end
                -- guardian_of_azeroth
                if cast.able.guardianOfAzeroth() then
                    if cast.guardianOfAzeroth() then ui.debug("Casting Guardian of Azeroth [Pre-Pull]") return true end
                end
                -- memory_of_lucid_dreams
                if cast.able.memoryOfLucidDreams() then
                    if cast.memoryOfLucidDreams() then ui.debug("Casting Memory of Lucid Dreams [Pre-Pull]") return true end
                end
            end
            -- Trueshot
            -- trueshot,precast_time=1.5,if=active_enemies>2
            if cast.able.trueshot() and ui.pullTimer() <= 3 then
                if cast.trueshot() then ui.debug("Casting Trueshot [Pre-Pull]") return true end
            end
            -- Potion
            -- potion,dynamic_prepot=1
            -- Aimed Shot
            -- aimed_shot,if=active_enemies<3
            if cast.able.aimedShot() and not unit.moving("player") and ui.pullTimer() <= 2 and unit.ttd(units.dyn40) > cast.time.aimedShot() then --and ((ui.mode.rotation == 1 and #enemies.yards40f < 3) or (ui.mode.rotation == 3 and #enemies.yards40f > 0)) then
                if cast.aimedShot("target") then ui.debug("Casting Aimed Shot [Pre-Pull]") return true end
            end
            -- Auto Shot
            StartAttack()
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
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    essence                                       = br.player.essence
    equiped                                       = br.player.equiped
    module                                        = br.player.module
    power                                         = br.player.power
    talent                                        = br.player.talent
    traits                                        = br.player.traits
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    var                                           = br.player.variables

    units.get(40)
    enemies.get(5,"pet")
    enemies.get(8)
    enemies.get(8,"pet")
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

    -- Explosions Gotta Have More Explosions!
    if br.player.petInfo ~= nil then
        for k,v in pairs(br.player.petInfo) do
            local thisPet = br.player.petInfo[k]
            if thisPet.id == 11492 and #enemies.get(8,thisPet.unit) > 0 then
                -- Print("Explosions!!!!")
                if cast.explosiveShotDetonate("player") then ui.debug("Casting Explosive Shot: Detonate!") return true end
                -- CastSpellByName(GetSpellInfo(spell.explosiveShotDetonate))
                break
            end
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif var.haltProfile then
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
            and not cast.current.barrage() and not cast.current.focusedAzeriteBeam()
        then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end
            ------------------------
            --- In Combat - Main ---
            ------------------------
            -- Auto Shot
            -- auto_shot
            if unit.distance(units.dyn40) < 40 then
                StartAttack()
            end
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
