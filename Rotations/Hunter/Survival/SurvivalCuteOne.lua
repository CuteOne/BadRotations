local rotationName = "CuteOne"
local br = _G["br"]
loadSupport("PetCuteOne")
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.serpentSting },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.carve },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.raptorStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.exhilaration}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.aspectOfTheEagle },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.aspectOfTheEagle },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.aspectOfTheEagle }
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
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.muzzle },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.muzzle }
    };
    CreateButton("Interrupt",4,0)
    -- Harpoon Button
    HarpoonModes = {
        [1] = { mode = "On", value = 1 , overlay = "Harpoon Enabled", tip = "Will cast Harpoon.", highlight = 1, icon = br.player.spell.harpoon },
        [2] = { mode = "Off", value = 2 , overlay = "Harpoon Disabled", tip = "Will NOT cat Harpoon.", highlight = 0, icon = br.player.spell.harpoon }
    };
    CreateButton("Harpoon",5,0)
    -- MD Button
    MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("Misdirection",6,0)
    -- Pet summon
    PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spell.callPet1 },
        [2] = { mode = "2", value = 2 , overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spell.callPet2 },
        [3] = { mode = "3", value = 3 , overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spell.callPet3 },
        [4] = { mode = "4", value = 4 , overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spell.callPet4 },
        [5] = { mode = "5", value = 5 , overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spell.callPet5 },
        [6] = { mode = "None", value = 6 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.callPet }
    };
    CreateButton("PetSummon",7,0)
    -- Aspect of the Eagle
    aotEModes = {
        [1] = { mode = "On", value = 1 , overlay = "Aspect of the Eagle Enabled", tip = "Aspect of the Eagle Enabled", highlight = 1, icon = br.player.spell.aspectOfTheEagle },
        [2] = { mode = "Off", value = 2 , overlay = "Aspect of the Eagle Disabled", tip = "Aspect of the Eagle Disabled", highlight = 0, icon = br.player.spell.aspectOfTheEagle }
    };
    CreateButton("aotE",8,0)
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
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Harpoon
            br.ui:createCheckbox(section, "Harpoon - Opener")
            -- Misdirection
            br.ui:createDropdownWithout(section,"Misdirection", {"|cff00FF00Tank","|cffFFFF00Focus","|cffFF0000Pet"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
            -- Opener
            br.ui:createDropdownWithout(section, "Opener", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use opener.")
            -- Heart Essence
            br.ui:createCheckbox(section, "Use Essence")
        br.ui:checkSectionState(section)
        -- Pet Options
        br.rotations.support["PetCuteOne"].options()
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- FlaskUp Module
            br.player.module.FlaskUp("Agility",section)
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Basic Trinkets Module
            br.player.module.BasicTrinkets(nil,section)
            -- A Murder of Crows
            br.ui:createDropdownWithout(section,"A Murder of Crows", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
            -- Aspect of the Eagle
            br.ui:createDropdownWithout(section,"Aspect of the Eagle", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
            -- Coordinated Assault
            br.ui:createDropdownWithout(section,"Coordinated Assault", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Aspect Of The Turtle
            br.ui:createSpinner(section, "Aspect Of The Turtle",  40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Exhilaration
            br.ui:createSpinner(section, "Exhilaration",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Feign Death
            br.ui:createSpinner(section, "Feign Death", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Intimidation
            br.ui:createSpinner(section, "Intimidation", 35, 0, 100, 5,  "|cffFFBB00Health Percentage to use at.")
            -- Tranquilizing Shot
            br.ui:createDropdown(section, "Tranquilizing Shot", {"|cff00FF00Any","|cffFFFF00Target"}, 2,"|cffFFFFFFHow to use Tranquilizing Shot.")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Freezing Trap
            br.ui:createCheckbox(section,"Freezing Trap")
            -- Intimidation
            br.ui:createCheckbox(section,"Intimidation - Int")
            -- Muzzle
            br.ui:createCheckbox(section,"Muzzle")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
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
local focus
local focusMax
local focusRegen
local gcd
local level
local module
local opener
local spell
local talent
local traits
local ui
local unit
local units
local var

local actionList = {}

-----------------
--- Functions ---
-----------------

-- Custom Profile Functions
local function focusTimeTill(amount)
    if focus >= amount then return 0.5 end
    return ((amount-focus)/focusRegen)+0.5
end

-- local function castRegen(spellID)
--     if GetSpellInfo(spellID) ~= nil then
--         local desc = GetSpellDescription(spellID)
--         local generates = desc:gsub("%D+", "")
--         local amount = generates:sub(-2)
--         return tonumber(amount)
--     else
--         return 0
--     end
-- end

local function nextBomb(nextBomb)
    local _,_,currentBomb = GetSpellInfo(spell.wildfireBomb)
    local _,_,shrapnelBomb = GetSpellInfo(spell.shrapnelBomb)
    local _,_,volatileBomb = GetSpellInfo(spell.volatileBomb)
    local _,_,pheromoneBomb = GetSpellInfo(spell.pheromoneBomb)
    if talent.wildfireInfusion and nextBomb ~= nil then
        if currentBomb == shrapnelBomb then return nextBomb == spell.shrapnelBomb end -- spell.volatileBomb
        if currentBomb == volatileBomb then return nextBomb == spell.volatileBomb end -- spell.pheromoneBomb
        if currentBomb == pheromoneBomb then return nextBomb == spell.pheromoneBomb end -- spell.shrapnelBomb
    else
        return nextBomb == spell.wildfireBomb
    end
    return currentBomb == nextBomb
end

local function eagleScout()
    if buff.aspectOfTheEagle.exists() then
        return #enemies.yards40
    else
        return #enemies.yards5
    end
end

-- local function outOfMelee()
--     if focus + cast.regen.killCommand() < focusMax then return false end
--     for i = 1, #enemies.yards40f do
--         local thisUnit = enemies.yards40f[i]
--         if unit.distance(thisUnit) > var.eagleRange and debuff.serpentSting.refresh(thisUnit) then return false end
--     end
--     return true
-- end

-- Multi-Dot HP Limit Set
local function canDoT(thisUnit)
    if not unit.isBoss(thisUnit) then ui.debug("") return true end
    local unitHealthMax = unit.healthMax(thisUnit)
    local maxHealth = 0
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        local thisMaxHealth = unit.healthMax(thisUnit)
        if thisMaxHealth > maxHealth then
            maxHealth = thisMaxHealth
        end
    end
    return unitHealthMax > maxHealth / 10
end

-- Action List - Extra
actionList.Extra = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
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
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Aspect of the Turtle
        if ui.checked("Aspect Of The Turtle") and cast.able.aspectOfTheTurtle()
            and unit.hp() <= ui.value("Aspect Of The Turtle") and unit.inCombat()
        then
            if cast.aspectOfTheTurtle("player") then ui.debug("Casting Aspect of the Turtle") return true end
        end
        -- Exhilaration
        if ui.checked("Exhilaration") and cast.able.exhilaration() and unit.hp() <= ui.value("Exhilaration") then
            if cast.exhilaration("player") then ui.debug("Casting Exhiliration") return true end
        end
        -- Feign Death
        if ui.checked("Feign Death") and cast.able.feignDeath()
            and unit.hp() <= ui.value("Feign Death") and unit.inCombat()
        then
            if cast.able.playDead() then
                if cast.playDead() then ui.debug("Casting Play Dead [Pet]") return true end
            end
            if cast.feignDeath("player") then ui.debug("Casting Feign Death") return true end
        end
        -- Intimidation
        if ui.checked("Intimidation") and cast.able.intimidation() and unit.hp() <= ui.value("Intimidation") then
            if cast.intimidation(units.dyn5p) then ui.debug("Casting Intimidation") return true end
        end
        -- Tranquilizing Shot
        if ui.checked("Tranquilizing Shot") then
            if #enemies.yards40f > 0 then
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if ui.value("Tranquilizing Shot") == 1 or (ui.value("Tranquilizing Shot") == 2 and UnitIsUnit(thisUnit,"target")) then
                        if unit.valid(thisUnit) and cast.dispel.tranquilizingShot(thisUnit) then
                            if cast.tranquilizingShot(thisUnit) then ui.debug("Casting Tranquilizing Shot") return true end
                        end
                    end
                end
            end
        end
    end -- End Defensive Toggle
end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        local thisUnit
        -- Muzzle
        if ui.checked("Muzzle") and cast.able.muzzle() then
            for i=1, #enemies.yards5 do
                thisUnit = enemies.yards5[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.muzzle(thisUnit) then ui.debug("Casting Muzzle") return true end
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
        if ui.checked("Intimidation - Int") and cast.able.intimidation() then
            for i=1, #enemies.yards5 do
                thisUnit = enemies.yards5[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.intimidation(thisUnit) then ui.debug("Casting Intimidaton [Interrupt]") return true end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldown = function()
    if ui.useCDs() and unit.distance(var.eagleUnit) < var.eagleRange then
        -- -- Trinkets
        -- if ui.checked("Trinkets") then
        --     for i = 13, 14 do
        --         if use.able.slot(i) and not (equiped.ashvanesRazorCoral(i) or equiped.galecallersBoon(i) or equiped.azsharasFontOfPower(i)) then
        --             use.slot(i)
        --         end
        --     end
        -- end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
        if ui.checked("Racial") then --and cd.racial.remain() == 0 then
            -- blood_fury,if=cooldown.coordinated_assault.remains>30
            -- ancestral_call,if=cooldown.coordinated_assault.remains>30
            -- fireblood,if=cooldown.coordinated_assault.remains>30
            if (cd.coordinatedAssault.remain() > 30 and (unit.race() == "Orc" or unit.race() == "MagharOrc" or unit.race() == "DarkIronDwarf")) then
                if cast.racial("player") then ui.debug("Casting Racial") return true end
            end
            -- lights_judgment
            if unit.race() == "LightforgedDraenei" then
                if cast.racial("target","ground") then ui.debug("Casting Racial") return true end
            end
            -- berserking,if=cooldown.coordinated_assault.remains>60|time_to_die<13
            if (cd.coordinatedAssault.remain() > 60 or unit.ttd(units.dyn5) < 13) and unit.race() == "Troll" then
                if cast.racial("player") then ui.debug("Casting Racial") return true end
            end
        end
        -- Potion
        -- potion,if=buff.guardian_of_azeroth.up&(buff.berserking.up|buff.blood_fury.up|!race.troll)|(consumable.potion_of_unbridled_fury&target.time_to_die<61|target.time_to_die<26)|!essence.condensed_lifeforce.major&buff.coordinated_assault.up
        -- if ui.checked("Potion") and unit.instance("raid") and use.able.potionOfFocusedResolve() and ui.useCDs() and buff.coordinatedAssault.exists()
        --     and ((unit.race() == "Orc" or unit.race() == "Troll") and buff.racial.exists()
        --         or not (unit.race() == "Orc" or unit.race() == "Troll") or unit.ttd(units.dyn5) < 26)
        -- then
        --     use.potionOfFocusedResolve()
        -- end
    end -- End useCooldowns check
    -- Aspect of the Eagle
    -- aspect_of_the_eagle,if=target.distance>=6
    if ui.mode.aotE == 1 and cast.able.aspectOfTheEagle() and (unit.distance("target") >= 6)
        and (ui.value("Aspect of the Eagle") == 1 or (ui.value("Aspect of the Eagle") == 2 and ui.useCDs()))
    then
        if cast.aspectOfTheEagle() then ui.debug("Casting Aspect of the Eagle") return true end
    end
    -- -- Ashvane's Razor Coral
    -- -- use_item,name=ashvanes_razor_coral,if=equipped.dribbling_inkpod&(debuff.razor_coral_debuff.down|time_to_pct_30<1|(health.pct<30&buff.guardian_of_azeroth.up|buff.memory_of_lucid_dreams.up))|(!equipped.dribbling_inkpod&(buff.memory_of_lucid_dreams.up|buff.guardian_of_azeroth.up)|debuff.razor_coral_debuff.down)|target.time_to_die<20
    -- if equiped.ashvanesRazorCoral() and use.able.ashvanesRazorCoral() and equiped.dribblingInkpod() and ((not debuff.razorCoral.exists(var.eagleUnit)
    --     or unit.hp(var.eagleUnit) <= 30 or (unit.hp(var.eagleUnit) < 30 and buff.guardianOfAzeroth.exists() or buff.memoryOfLucidDreams.exists()))
    --     or (not equiped.dribblingInkpod() and (buff.memoryOfLucidDreams.exists() or buff.guardianOfAzeroth.exists()) or not debuff.razorCoral.exists(var.eagleUnit))
    --     or (unit.ttd(var.eagleUnit) < 20 and ui.useCDs()))
    -- then
    --     use.ashvanesRazorCoral()
    --     return
    -- end
    -- -- Galecaller's Boon
    -- -- use_item,name=galecallers_boon,if=cooldown.memory_of_lucid_dreams.remains|talent.wildfire_infusion.enabled&cooldown.coordinated_assault.remains|cooldown.cyclotronic_blast.remains|!essence.memory_of_lucid_dreams.major&cooldown.coordinated_assault.remains
    -- if equiped.galecallersBoon() and use.able.galecallersBoon() and (cd.memoryOfLucidDreams.remain() > 0
    --     or talent.wildfireInfusion and cd.coordinatedAssault.remain() > 0 or cd.pocketSizedComputationDevice.remain() > 0
    --     or not essence.memoryOfLucidDreams.active and cd.coordinatedAssault.remain() > 0)
    -- then
    --     use.galecallersBoon()
    --     return
    -- end
    -- -- Azshara's Font of Power
    -- -- use_item,name=azsharas_font_of_power
    -- if equiped.azsharasFontOfPower() and use.able.azsharasFontOfPower() then
    --     use.azsharasFontOfPower()
    --     return
    -- end
    -- Heart Essence
    if ui.checked("Use Essence") then
        -- Focused Azerite Beam
        -- focused_azerite_beam,if=raid_event.adds.in>90&focus<focus.max-25|(active_enemies>1&!talent.birds_of_prey.enabled|active_enemies>2)&(buff.blur_of_talons.up&buff.blur_of_talons.remains>3*gcd|!buff.blur_of_talons.up)
        if cast.able.focusedAzeriteBeam() and (focus < focusMax - 25 or (#enemies.yards30r > 1 and not talent.birdsOfPrey or #enemies.yards30r > 2)
            and (buff.blurOfTalons.exists() and buff.blurOfTalons.remain() > 3 * unit.gcd(true) or not buff.blurOfTalons.exists()))
        then
            if cast.focusedAzeriteBeam(nil,"rect",var.minCount,8) then ui.debug("Casting Focused Azerite Beam") return true end
        end
        -- Blood of the Enemy
        -- blood_of_the_enemy,if=((raid_event.adds.remains>90|!raid_event.adds.exists)|(active_enemies>1&!talent.birds_of_prey.enabled|active_enemies>2))&focus<focus.max
        if cast.able.bloodOfTheEnemy() and ((#enemies.yards5 > 1 and not talent.birdsOfPrey or #enemies.yards5 > 2) and focus < focusMax) then
            if cast.bloodOfTheEnemy() then ui.debug("Casting Blood of the Enemy") return true end
        end
        -- Purifying Blast
        -- purifying_blast,if=((raid_event.adds.remains>60|!raid_event.adds.exists)|(active_enemies>1&!talent.birds_of_prey.enabled|active_enemies>2))&focus<focus.max
        if cast.able.purifyingBlast() and ((#enemies.yards8 > 1 and not talent.birdsOfPrey or #enemies.yards8 > 2) and focus < focusMax) then
            if cast.purifyingBlast("best", nil, var.minCount, 8) then ui.debug("Casting Purifying Blast") return true end
        end
        -- Guardian of Azeroth
        -- guardian_of_azeroth
        if ui.useCDs() and cast.able.guardianOfAzeroth() then
            if cast.guardianOfAzeroth() then ui.debug("Casting Guardian of Azeroth") return true end
        end
        -- Ripple In Space
        -- ripple_in_space
        if ui.useCDs() and cast.able.rippleInSpace() then
            if cast.rippleInSpace() then ui.debug("Casting Ripple In Space") return true end
        end
        -- Concentrated Flame
        -- concentrated_flame,if=full_recharge_time<1*gcd
        if cast.able.concentratedFlame() and charges.concentratedFlame.timeTillFull() < 1 * unit.gcd(true) then
            if cast.concentratedFlame() then ui.debug("Casting Concentrated Flame") return true end
        end
        -- The Unbound Force
        -- the_unbound_force,if=buff.reckless_force.up
        if cast.able.theUnboundForce() and buff.recklessForce.exists() then
            if cast.theUnboundForce() then ui.debug("Casting The Unbound Force") return true end
        end
        -- Worldvein Resonance
        -- worldvein_resonance
        if cast.able.worldveinResonance() and unit.distance(var.eagleUnit) < var.eagleRange then
            if cast.worldveinResonance() then ui.debug("Casting Worldvein Resonance") return true end
        end
        -- Reaping Flames
        -- reaping_flames,if=target.health.pct>80|target.health.pct<=20|target.time_to_pct_20>30
        if cast.able.reapingFlames() and (unit.hp("target") > 80 or unit.hp("target") <= 20 or unit.ttd("target",20) > 30) then
            if cast.reapingFlames() then ui.debug("Casting Reaping Flames") return true end
        end
    end
    -- Serpent Sting
    -- serpent_sting,if=essence.memory_of_lucid_dreams.major&refreshable&buff.vipers_venom.up&!cooldown.memory_of_lucid_dreams.remains
    if cast.able.serpentSting() and essence.memoryOfLucidDreams.active
        and debuff.serpentSting.refresh(units.dyn40) and buff.vipersVenom.exists()
        and not cd.memoryOfLucidDreams.exists()
    then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting [CD]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=essence.memory_of_lucid_dreams.major&!cooldown.memory_of_lucid_dreams.remains
    if cast.able.mongooseBite() and talent.mongooseBite and essence.memoryOfLucidDreams.active and not cd.memoryOfLucidDreams.exists() then
        if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [CD]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=essence.memory_of_lucid_dreams.major&full_recharge_time<1.5*gcd&focus<action.mongoose_bite.cost&!cooldown.memory_of_lucid_dreams.remains
    if cast.able.wildfireBomb() and essence.memoryOfLucidDreams.active and charges.wildfireBomb.timeTillFull() < 1.5 * unit.gcd(true)
        and focus < cast.cost.mongooseBite() and cd.memoryOfLucidDreams.remain() == 0
    then
        if cast.wildfireBomb() then ui.debug("Casting Wildfire Bomb [CD]") return true end
    end
    -- Memory of Lucid Dreams
    -- memory_of_lucid_dreams,if=focus<focus.max-30&buff.coordinated_assault.up
    if ui.useCDs() and ui.checked("Use Essence") and cast.able.memoryOfLucidDreams() and unit.distance(var.eagleUnit) < var.eagleRange
        and focus < focusMax - 30 and buff.coordinatedAssault.exists()
    then
        if cast.memoryOfLucidDreams() then ui.debug("Casting Memory of Lucid Dreams") return true end
    end
end -- End Action List - Cooldowns

-- Action List - Single Target
actionList.St = function()
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot() and unit.hp("target") < 20 then
        if cast.killShot("target") then ui.debug("Casting Kill Shot [ST]") return true end
    end
    -- Harpoon
    -- harpoon,if=talent.terms_of_engagement.enabled
    if cast.able.harpoon() and ui.mode.harpoon == 1 and talent.termsOfEngagement and unit.distance(units.dyn30) > 5 then
        if cast.harpoon() then ui.debug("Casting Harpoon [ST]") return true end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and (focus + cast.regen.flankingStrike() < focusMax) then
        if cast.flankingStrike() then ui.debug("Casting Flanking Strike [ST]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,if=buff.coordinated_assault.up&(buff.coordinated_assault.remains<1.5*gcd|buff.blur_of_talons.up&buff.blur_of_talons.remains<1.5*gcd)
    if cast.able.raptorStrike(var.eagleUnit) and not talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange
        and buff.coordinatedAssault.exists() and (buff.coordinatedAssault.remain() < 1.5 * unit.gcd(true)
            or (buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < 1.5 * unit.gcd(true)))
    then
        if cast.raptorStrike(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Raptor Strike [ST - Coordinated Assault]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.coordinated_assault.up&(buff.coordinated_assault.remains<1.5*gcd|buff.blur_of_talons.up&buff.blur_of_talons.remains<1.5*gcd)
    if cast.able.mongooseBite(var.eagleUnit) and talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange
        and buff.coordinatedAssault.exists() and (buff.coordinatedAssault.remain() < 1.5 * unit.gcd(true)
            or (buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < 1.5 * unit.gcd(true)))
    then
        if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [ST - Coordinated Assault]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max
    if cast.able.killCommand(var.lowestBloodseeker) and focus + cast.regen.killCommand() < focusMax then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [ST]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.up&buff.vipers_venom.remains<1*gcd
    if cast.able.serpentSting() and buff.vipersVenom.exists() and buff.vipersVenom.remain() < 1 * unit.gcd(true) then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting [ST - Viper's Venom Expire Soon]") return true end
    end
    -- Steel Trap
    -- steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap() and focus + focusRegen < focusMax then
        if cast.steelTrap("best",nil,1,5) then ui.debug("Casting Steel Trap [ST]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=focus+cast_regen<focus.max&refreshable&full_recharge_time<gcd&!buff.memory_of_lucid_dreams.up|focus+cast_regen<focus.max&(!dot.wildfire_bomb.ticking&(!buff.coordinated_assault.up|buff.mongoose_fury.stack<1|time_to_die<18|!dot.wildfire_bomb.ticking&azerite.wilderness_survival.rank>0))&!buff.memory_of_lucid_dreams.up
    if cast.able.wildfireBomb() and focus + cast.regen.wildfireBomb() < focusMax and charges.wildfireBomb.timeTillFull() < unit.gcd(true) and not buff.memoryOfLucidDreams.exists() 
        or focus + cast.regen.wildfireBomb() < focusMax and (not debuff.wildfireBomb.exists(units.dyn40) and (not buff.coordinatedAssault.exists() 
            or buff.mongooseFury.stack() < 1 or unit.ttd(units.dyn40) < 18 or not debuff.wildfireBomb.exists(units.dyn40) and traits.wildernessSurvival.rank > 0))
        and not buff.memoryOfLucidDreams.exists()
    then
        if cast.wildfireBomb(nil,"aoe") then ui.debug("Casting Wildfire Bomb [ST]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.up&dot.serpent_sting.remains<4*gcd|dot.serpent_sting.refreshable&!buff.coordinated_assault.up
    if cast.able.serpentSting() and (buff.vipersVenom.exists() and debuff.serpentSting.remain(units.dyn40) < 4 * unit.gcd(true)
        or debuff.serpentSting.refresh(units.dyn40) and not buff.coordinatedAssault.exists())
    then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting [ST - Viper's Venom Refresh]") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows,if=!buff.coordinated_assault.up
    if cast.able.aMurderOfCrows() and (ui.value("A Murder of Crows") == 1 or (ui.value("A Murder of Crows") == 2 and ui.useCDs()))
        and not buff.coordinatedAssault.exists()
    then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [ST]") return true end
    end
    -- Coordinated Assault
    -- coordinated_assault,if=!buff.coordinated_assault.up
    if cast.able.coordinatedAssault() and eagleScout() > 0
        and (ui.value("Coordinated Assault") == 1 or (ui.value("Coordinated Assault") == 2 and ui.useCDs()))
        and not buff.coordinatedAssault.exists()
    then
        if cast.coordinatedAssault() then ui.debug("Casting Coordinated Assault [ST]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.mongoose_fury.up|focus+cast_regen>focus.max-20&talent.vipers_venom.enabled|focus+cast_regen>focus.max-1&talent.terms_of_engagement.enabled|buff.coordinated_assault.up
    if cast.able.mongooseBite(var.eagleUnit) and talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange
        and ((buff.mongooseFury.exists() or (focus + focusRegen > focusMax - 20 and talent.vipersVenom))
            or (focus + focusRegen > focusMax - 1 and talent.termsOfEngagement) or buff.coordinatedAssault.exists())
    then
        if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [ST]") return true end
    end
    -- Raptor Strike
    -- raptor_strike
    if cast.able.raptorStrike(var.eagleUnit) and not talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange then
        if cast.raptorStrike(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Raptor Strike [ST]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=dot.wildfire_bomb.refreshable
    if cast.able.wildfireBomb() and debuff.wildfireBomb.refresh(units.dyn40) then
        if cast.wildfireBomb(nil,"aoe") then ui.debug("Casting Wildfire Bomb [ST - Refresh]") return true end
    end 
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.up
    if cast.able.serpentSting() and buff.vipersVenom.exists() then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting [ST - Viper's Venom]") return true end
    end
end -- End Action List - Single Target

-- Action List - Cleave
actionList.Cleave = function()
    -- Mongoose Bite
    if cast.able.mongooseBite() and talent.mongooseBite then
        -- mongoose_bite,if=azerite.blur_of_talons.rank>0&(buff.coordinated_assault.up&(buff.coordinated_assault.remains<1.5*gcd|buff.blur_of_talons.up&buff.blur_of_talons.remains<1.5*gcd|buff.coordinated_assault.remains&!buff.blur_of_talons.remains))
        if traits.blurOfTalons.rank > 0 and (buff.coordinatedAssault.exists()
            and (buff.coordinatedAssault.remain() < 1.5 * unit.gcd(true) or buff.blurOfTalons.exists()
            and buff.blurOfTalons.remain() < 1.5 * unit.gcd(true) or buff.coordinatedAssault.remain() and not buff.blurOfTalons.remain()))
        then
            if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [AOE - Blur of Talons]") return true end
        end
        -- mongoose_bite,target_if=min:time_to_die,if=debuff.latent_poison.stack>(active_enemies|9)&target.time_to_die<active_enemies*gcd
        if debuff.latentPoison.stack() > (#var.eagleEnemies or 9) and unit.ttd(var.eagleUnit) < #var.eagleEnemies * unit.gcd(true) then
            if cast.mongooseBite(var.lowestTTDUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [AOE - Lowest TTD]") return true end
        end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if cast.able.aMurderOfCrows() and (ui.value("A Murder of Crows") == 1 or (ui.value("A Murder of Crows") == 2 and ui.useCDs())) then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [AOE]") return true end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if cast.able.coordinatedAssault() and eagleScout() > 0
        and (ui.value("Coordinated Assault") == 1 or (ui.value("Coordinated Assault") == 2 and ui.useCDs()))
    then
        if cast.coordinatedAssault() then ui.debug("Casting Coordinated Assault [AOE]") return true end
    end
    -- Carve
    -- carve,if=dot.shrapnel_bomb.ticking
    -- carve,if=dot.shrapnel_bomb.ticking&!talent.hydras_bite.enabled|dot.shrapnel_bomb.ticking&active_enemies>5
    if cast.able.carve() and (debuff.shrapnelBomb.exists(units.dyn5) and not talent.hydrasBite or debuff.shrapnelBomb.exists(units.dyn5) and #enemies.yards5 > 5) then
        if cast.carve(nil,"cone",1,5) then ui.debug("Casting Carve [AOE - Shrapnel Bomb]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=!talent.guerrilla_tactics.enabled|full_recharge_time<gcd|raid_event.adds.remains<6&raid_event.adds.exists
    if cast.able.wildfireBomb() and (not talent.guerrillaTactics or charges.wildfireBomb.timeTillFull() < unit.gcd(true) or ui.useAOE()) then
        if cast.wildfireBomb(nil,"aoe") then ui.debug("Casting Wildfire Bomb [AOE - Cap Prevention]") return true end
    end
    -- Butchery
    -- butchery,if=charges_fractional>2.5|dot.shrapnel_bomb.ticking|cooldown.wildfire_bomb.remains>active_enemies-gcd|debuff.blood_of_the_enemy.remains|raid_event.adds.remains<5&raid_event.adds.exists
    if cast.able.butchery() and (charges.butchery.frac() > 2.5 or debuff.shrapnelBomb.exists(units.dyn5)
        or cd.wildfireBomb.remain() > #enemies.yards8 - unit.gcd(true) or debuff.bloodOfTheEnemy.remain(units.dyn5) or ui.useAOE())
    then
        if cast.butchery("player","aoe") then ui.debug("Casting Butchery [AOE - Cap Prevention]") return end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison.stack,if=debuff.latent_poison.stack>8
    if cast.able.mongooseBite(var.maxLatentPoison) and talent.mongooseBite and debuff.latentPoison.stack(var.maxLatentPoison) > 8 then
        if cast.mongooseBite(var.maxLatentPoison,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [AOE - High Latent Poison]") return true end
    end
    -- Chakrams
    -- chakrams
    if cast.able.chakrams() and enemies.yards40r > 0 then
        if cast.chakrams(nil,"rect",1,40) then ui.debug("Casting Chakrams [AOE]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max
    if cast.able.killCommand(var.lowestBloodseeker) and focus + cast.regen.killCommand() < focusMax then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [AOE - Lowest Bloodseeker]") return true end
    end
    -- Harpoon
    -- harpoon,if=talent.terms_of_engagement.enabled
    if cast.able.harpoon() and ui.mode.harpoon == 1 and talent.termsOfEngagement and unit.distance(units.dyn30) > 5 then
        if cast.harpoon() then ui.debug("Casting Harpoon [AOE]") return true end
    end
    -- Carve
    -- carve,if=talent.guerrilla_tactics.enabled
    if cast.able.carve() and (talent.guerrillaTactics) then
        if cast.carve(nil,"cone",1,5) then ui.debug("Casting Carve [AOE - Guerrilla Tactics]") return true end
    end
    -- Butchery
    -- butchery,if=cooldown.wildfire_bomb.remains>(active_enemies|5)
    if cast.able.butchery("player","aoe") and (cd.wildfireBomb.remains() > #enemies.yards5 or cd.wildfireBomb.remains() > 5) then
        if cast.butchery("player","aoe") then ui.debug("Casting Butchery [AOE - No Bombs]") return true end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and (focus + cast.regen.flankingStrike() < focusMax) then
        if cast.flankingStrike() then ui.debug("Casting Flanking Strike [AOE]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=dot.wildfire_bomb.refreshable|talent.wildfire_infusion.enabled
    if cast.able.wildfireBomb() and (debuff.wildfireBomb.refresh(units.dyn40) or talent.wildfireInfusion) then
        if cast.wildfireBomb(nil,"aoe") then ui.debug("Casting Wildfire Bomb [AOE - Refresh]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=buff.vipers_venom.react
    if cast.able.serpentSting(var.lowestSerpentSting) and canDoT(var.lowestSerpentSting) and (unit.ttd(var.lowestSerpentSting) > 3 or unit.isDummy()) and (buff.vipersVenom.exists()) then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [AOE - Viper's Venom]") return true end
    end
    -- Carve
    -- carve,if=cooldown.wildfire_bomb.remains>variable.carve_cdr%2
    if cast.able.carve() and (cd.wildfireBomb.remain() > var.carveCdr / 2) then
        if cast.carve(nil,"cone",1,5) then ui.debug("Casting Carve [AOE - No Bombs]") return true end
    end
    -- Steel Trap
    -- steel_trap
    if cast.able.steelTrap() then
        if cast.steelTrap("best",nil,1,5) then ui.debug("Casting Steel Trap [AOE]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=refreshable&buff.tip_of_the_spear.stack<3&next_wi_bomb.volatile|refreshable&azerite.latent_poison.rank>0
    if cast.able.serpentSting(var.lowestSerpentSting) and canDoT(var.lowestSerpentSting) and (unit.ttd(var.lowestSerpentSting) > 3 or unit.isDummy())
        and (debuff.serpentSting.refresh(var.lowestSerpentSting) and buff.tipOfTheSpear.stack() < 3
        and nextBomb(spell.volatileBomb) or debuff.serpentSting.refresh(var.lowestSerpentSting) and traits.latentPoison.rank > 0)
    then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [AOE - Refresh]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison.stack
    if cast.able.mongooseBite(var.maxLatentPoison) and talent.mongooseBite and unit.distance(var.maxLatentPoison) <= var.eagleRange then
        if cast.mongooseBite(var.maxLatentPoison,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [AOE - Latent Poison") return true end
    end
    -- Raptor Strike
    -- raptor_strike,target_if=max:debuff.latent_poison.stack
    if cast.able.raptorStrike(var.maxLatentPoison) and not talent.mongooseBite and unit.distance(var.maxLatentPoison) <= var.eagleRange then
        if cast.raptorStrike(var.maxLatentPoison,nil,1,var.eagleRange) then ui.debug("Casting Raptor Strike [AOE - Latent Poison") return true end
    end
end -- End Action List - Cleave

-- Action List - Alpha Predator
actionList.ApSt = function()
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot() and unit.hp("target") < 20 then
        if cast.killShot("target") then ui.debug("Casting Kill Shot [AP]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.coordinated_assault.up&(buff.coordinated_assault.remains<1.5*gcd|buff.blur_of_talons.up&buff.blur_of_talons.remains<1.5*gcd)
    if cast.able.mongooseBite(var.eagleUnit) and talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange
        and buff.coordinatedAssault.exists() and (buff.coordinatedAssault.remain() < 1.5 * unit.gcd(true)
            or (buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < 1.5 * unit.gcd(true)))
    then
        if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [AP - Coordinated Assault]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,if=buff.coordinated_assault.up&(buff.coordinated_assault.remains<1.5*gcd|buff.blur_of_talons.up&buff.blur_of_talons.remains<1.5*gcd)
    if cast.able.raptorStrike(var.eagleUnit) and not talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange
        and buff.coordinatedAssault.exists() and (buff.coordinatedAssault.remain() < 1.5 * unit.gcd(true)
            or (buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < 1.5 * unit.gcd(true)))
    then
        if cast.raptorStrike(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Raptor Strike [AP - Coordinated Assault]") return true end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and (focus + cast.regen.flankingStrike() < focusMax) then
        if cast.flankingStrike() then ui.debug("Casting Flanking Strike [AP]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=full_recharge_time<1.5*gcd&focus+cast_regen<focus.max
    if cast.able.killCommand(var.lowestBloodseeker) and charges.killCommand.timeTillFull() < 1.5 * unit.gcd(true)
        and focus + cast.regen.killCommand() < focusMax
    then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [AP - Cap Prevention]") return true end
    end
    -- Steel Trap
    -- steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap() and focus + focusRegen < focusMax then
        if cast.steelTrap("best",nil,1,5) then ui.debug("Casting Steel Trap [AP]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=focus+cast_regen<focus.max&!ticking&!buff.memory_of_lucid_dreams.up&(full_recharge_time<1.5*gcd|!dot.wildfire_bomb.ticking&!buff.coordinated_assault.up|!dot.wildfire_bomb.ticking&buff.mongoose_fury.stack<1)|time_to_die<18&!dot.wildfire_bomb.ticking
    if cast.able.wildfireBomb() and focus + focusRegen < focusMax and not debuff.wildfireBomb.exists(units.dyn40) and not buff.memoryOfLucidDreams.exists()
        and (charges.wildfireBomb.timeTillFull() < 1.5 * unit.gcd(true) or not debuff.wildfireBomb.exists(units.dyn40) and not buff.coordinatedAssault.exists()
        or not debuff.wildfireBomb.exists(units.dyn40) and buff.mongooseFury.stack() < 1) or (unit.ttd(units.dyn40) < 18 and not debuff.wildfireBomb.exists(units.dyn40)) 
    then
        if cast.wildfireBomb(nil,"aoe") then ui.debug("Casting Wildfire Bomb [AP]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,if=!dot.serpent_sting.ticking&!buff.coordinated_assault.up
    if cast.able.serpentSting() and not debuff.serpentSting.exists(units.dyn40) and not buff.coordinatedAssault.exists() then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting [AP - No Debuff]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&(buff.mongoose_fury.stack<5|focus<action.mongoose_bite.cost)
    if cast.able.killCommand(var.lowestBloodseeker) and focus + cast.regen.killCommand() < focusMax
        and (buff.mongooseFury.stack() < 5 or focus < cast.cost.mongooseBite())
    then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [AP]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,if=refreshable&!buff.coordinated_assault.up&buff.mongoose_fury.stack<5
    if cast.able.serpentSting() and debuff.serpentSting.refresh(units.dyn40) and not buff.coordinatedAssault.exists() and buff.mongooseFury.stack() < 5 then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting [AP - Refresh]") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows,if=!buff.coordinated_assault.up
    if cast.able.aMurderOfCrows() and (ui.value("A Murder of Crows") == 1 or (ui.value("A Murder of Crows") == 2 and ui.useCDs()))
        and not buff.coordinatedAssault.exists()
    then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [AP]") return true end
    end
    -- Coordinated Assault
    -- coordinated_assault,if=!buff.coordinated_assault.up
    if cast.able.coordinatedAssault() and eagleScout() > 0 and not buff.coordinatedAssault.exists()
        and (ui.value("Coordinated Assault") == 1 or (ui.value("Coordinated Assault") == 2 and ui.useCDs()))
    then
        if cast.coordinatedAssault() then ui.debug("Casting Coordinated Assault [AP]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.mongoose_fury.up|focus+cast_regen>focus.max-10|buff.coordinated_assault.up
    if cast.able.mongooseBite(var.eagleUnit) and talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange
        and (buff.mongooseFury.exists() or focus + focusRegen > focusMax - 10 or buff.coordinatedAssault.exists())
    then
        if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [AP]") return true end
    end
    -- Raptor Strike
    -- raptor_strike
    if cast.able.raptorStrike(var.eagleUnit) and not talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange then
        if cast.raptorStrike(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Raptor Strike [AP]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=!ticking
    if cast.able.wildfireBomb() and not debuff.wildfireBomb.exists(units.dyn40) then
        if cast.wildfireBomb(nil,"aoe") then ui.debug("Casting Wildfire Bomb [AP - No Debuff]") return true end
    end
end -- End Action List - Alpha Predator

-- Action List - Alpha Predator / Wildfire Infusion
actionList.ApWfi = function()
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot() and unit.hp("target") < 20 then
        if cast.killShot("target") then ui.debug("Casting Kill Shot [ApWfi]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.blur_of_talons.up&buff.blur_of_talons.remains<gcd
    if cast.able.mongooseBite(var.eagleUnit) and talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange
        and buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < unit.gcd(true)
    then
        if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [ApWfi - Blur of Talons]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,if=buff.blur_of_talons.up&buff.blur_of_talons.remains<gcd
    if cast.able.raptorStrike(var.eagleUnit) and not talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange
        and buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < unit.gcd(true)
    then
        if cast.raptorStrike(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Raptor Strike [ApWfi - Blur of Talons]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,if=!dot.serpent_sting.ticking
    if cast.able.serpentSting() and not debuff.serpentSting.exists(units.dyn40) and not buff.coordinatedAssault.exists() then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting [ApWfi - No Debuff]") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if cast.able.aMurderOfCrows() and (ui.value("A Murder of Crows") == 1 or (ui.value("A Murder of Crows") == 2 and ui.useCDs())) then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [ApWfi]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=full_recharge_time<1.5*gcd|focus+cast_regen<focus.max&(next_wi_bomb.volatile&dot.serpent_sting.ticking&dot.serpent_sting.refreshable|next_wi_bomb.pheromone&!buff.mongoose_fury.up&focus+cast_regen<focus.max-action.kill_command.cast_regen*3)
    if cast.able.wildfireBomb() and (charges.wildfireBomb.timeTillFull() < 1.5 * unit.gcd(true) or focus + focusRegen < focusMax
        and (nextBomb(spell.volatileBomb) and debuff.serpentSting.exists(units.dyn40) and debuff.serpentSting.refresh(units.dyn40)
            or nextBomb(spell.pheromoneBomb) and not buff.mongooseFury.exists() and focus + focusRegen < focusMax - cast.regen.killCommand() * 3))
    then
        if cast.wildfireBomb(nil,"aoe") then ui.debug("Casting Wildfire Bomb [ApWfi Cap Prevention]") return true end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if cast.able.coordinatedAssault() and eagleScout() > 0
        and (ui.value("Coordinated Assault") == 1 or (ui.value("Coordinated Assault") == 2 and ui.useCDs()))
    then
        if cast.coordinatedAssault() then ui.debug("Casting Coordinated Assault [ApWfi]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.mongoose_fury.remains&next_wi_bomb.pheromone
    if cast.able.mongooseBite() and talent.mongooseBite and buff.mongooseFury.exists() and nextBomb(spell.pheromoneBomb) then
        if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [ApWfi - Next Pheromone]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=full_recharge_time<1.5*gcd&focus+cast_regen<focus.max-20
    if cast.able.killCommand(var.lowestBloodseeker) and charges.killCommand.timeTillFull() < 1.5 * unit.gcd(true)
        and focus + cast.regen.killCommand() < focusMax - 20
    then
        Print("Focus: "..focus..", Regen: "..round2(cast.regen.killCommand(),2)..", Max: "..focusMax)
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [ApWfi - Cap Prevention]") return true end
    end
    -- Steel Trap
    -- steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap() and focus + focusRegen < focusMax then
        if cast.steelTrap("best",nil,1,5) then ui.debug("Casting Steel Trap [ApWfi]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,if=buff.tip_of_the_spear.stack=3|dot.shrapnel_bomb.ticking
    if cast.able.raptorStrike(var.eagleUnit) and not talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange
        and (buff.tipOfTheSpear.stack() == 3 or debuff.shrapnelBomb.exists(units.dyn40))
    then
        if cast.raptorStrike(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Raptor Strike [ApWfi - Tip of the Shrapnel]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=dot.shrapnel_bomb.ticking
    if cast.able.mongooseBite(var.eagleUnit) and talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange
        and debuff.shrapnelBomb.exists(units.dyn40)
    then
        if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [ApWfi - Shrapnel]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.shrapnel&focus>30&dot.serpent_sting.remains>5*gcd
    if cast.able.wildfireBomb() and nextBomb(spell.shrapnelBomb) and focus > 30 and debuff.serpentSting.remain(units.dyn40) > 5 * unit.gcd(true) then
        if cast.wildfireBomb(nil,"aoe") then ui.debug("Casting Wildfire Bomb [ApWfi - Next Shrapnel]") return true end
    end
    -- Chakrams
    -- chakrams,if=!buff.mongoose_fury.remains
    if cast.able.chakrams() and enemies.yards40r > 0 and not buff.mongooseFury.exists() then
        if cast.chakrams(nil,"rect",1,40) then ui.debug("Casting Chakrams [ApWfi]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,if=refreshable
    if cast.able.serpentSting() and debuff.serpentSting.refresh(units.dyn40) then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting [ApWfi - Refresh]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&(buff.mongoose_fury.stack<5|focus<action.mongoose_bite.cost)
    if cast.able.killCommand(var.lowestBloodseeker) and focus + cast.regen.killCommand() < focusMax
        and (buff.mongooseFury.stack() < 5 or focus < cast.cost.mongooseBite())
    then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [ApWfi]") return true end
    end
    -- Raptor Strike
    -- raptor_strike
    if cast.able.raptorStrike(var.eagleUnit) and not talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange then
        if cast.raptorStrike(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Raptor Strike [ApWfi]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.mongoose_fury.up|focus>40|dot.shrapnel_bomb.ticking
    if cast.able.mongooseBite(var.eagleUnit) and talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange
        and (buff.mongooseFury.exists() or focus > 40 or debuff.shrapnelBomb.exists(units.dyn40))
    then
        if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [ApWfi]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.volatile&dot.serpent_sting.ticking|next_wi_bomb.pheromone|next_wi_bomb.shrapnel&focus>50
    if cast.able.wildfireBomb() and (nextBomb(spell.volatileBomb) and debuff.serpentSting.exists(units.dyn40)
        or nextBomb(spell.pheromoneBomb) or nextBomb(spell.shrapnelBomb) and focus > 50)
    then
        if cast.wildfireBomb(nil,"aoe") then ui.debug("Casting Wildfire Bomb [ApWfi]") return true end
    end
end -- End Action List - Alpha Predator / Wildfire Infusion

-- Action List - Wildfire Infusion
actionList.Wfi = function()
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot() and unit.hp("target") < 20 then
        if cast.killShot("target") then ui.debug("Casting Kill Shot [Wfi]") return true end
    end
    -- Harpoon
    -- harpoon,if=focus+cast_regen<focus.max&talent.terms_of_engagement.enabled
    if cast.able.harpoon() and ui.mode.harpoon == 1 and focus + focusRegen < focusMax
        and talent.termsOfEngagement and unit.distance(units.dyn30) > 5
    then
        if cast.harpoon() then ui.debug("Casting Harpoon [Wfi]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.blur_of_talons.up&buff.blur_of_talons.remains<gcd
    if cast.able.mongooseBite(var.eagleUnit) and talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange
        and buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < unit.gcd(true)
    then
        if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [Wfi - Blur of Talons]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,if=buff.blur_of_talons.up&buff.blur_of_talons.remains<gcd
    if cast.able.raptorStrike(var.eagleUnit) and not talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange
        and buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < unit.gcd(true)
    then
        if cast.raptorStrike(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Raptor Strike [Wfi - Blur of Talons]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.up&buff.vipers_venom.remains<1.5*gcd|!dot.serpent_sting.ticking
    if cast.able.serpentSting() and ((buff.vipersVenom.exists() and buff.vipersVenom.remain() < 1.5 * unit.gcd(true))
        or not debuff.serpentSting.exists(units.dyn40))
    then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting [Wfi - Viper's Venom Expire Soon]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=full_recharge_time<1.5*gcd&focus+cast_regen<focus.max|(next_wi_bomb.volatile&dot.serpent_sting.ticking&dot.serpent_sting.refreshable|next_wi_bomb.pheromone&!buff.mongoose_fury.up&focus+cast_regen<focus.max-action.kill_command.cast_regen*3)
    if cast.able.wildfireBomb() and (charges.wildfireBomb.timeTillFull() < 1.5 * unit.gcd(true)
        or (nextBomb(spell.volatileBomb) and debuff.serpentSting.refresh(units.dyn40))
        or (nextBomb(spell.pheromoneBomb) and not buff.mongooseFury.exists() and focus + focusRegen < focusMax - cast.regen.killCommand() * 3))
    then
        if cast.wildfireBomb(nil,"aoe") then ui.debug("Casting Wildfire Bomb [Wfi - Cap Prevention]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max-focus.regen
    if cast.able.killCommand(var.lowestBloodseeker) and focus + cast.regen.killCommand() < focusMax then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [Wfi]") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if cast.able.aMurderOfCrows() and (ui.value("A Murder of Crows") == 1 or (ui.value("A Murder of Crows") == 2 and ui.useCDs())) then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [Wfi]") return true end
    end
    -- Steel Trap
    -- steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap() and focus + focusRegen < focusMax then
        if cast.steelTrap("best",nil,1,5) then ui.debug("Casting Steel Trap [Wfi]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=full_recharge_time<1.5*gcd
    if cast.able.wildfireBomb() and charges.wildfireBomb.timeTillFull() < 1.5 * unit.gcd(true) then
        if cast.wildfireBomb(nil,"aoe") then ui.debug("Casting Wildfire Bomb [Wfi - Cap Prevention]") return true end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if cast.able.coordinatedAssault() and eagleScout() > 0
        and (ui.value("Coordinated Assault") == 1 or (ui.value("Coordinated Assault") == 2 and ui.useCDs()))
    then
        if cast.coordinatedAssault() then ui.debug("Casting Coordinated Assault [Wfi]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.up&dot.serpent_sting.remains<4*gcd
    if cast.able.serpentSting() and ((buff.vipersVenom.exists() and debuff.serpentSting.remain(units.dyn40) < 4 * unit.gcd(true))
        or (debuff.serpentSting.refresh(units.dyn40) and not buff.coordinatedAssault.exists()))
    then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting [Wfi - Debuff Ending Soon]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=dot.shrapnel_bomb.ticking|buff.mongoose_fury.stack=5
    if cast.able.mongooseBite() and talent.mongooseBite and (debuff.shrapnelBomb.exists(units.dyn40) or buff.mongooseFury.stack() == 5) then
        if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [Wfi - Shrapnel Fury]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.shrapnel&dot.serpent_sting.remains>5*gcd
    if cast.able.wildfireBomb() and nextBomb(spell.shrapnelBomb) and debuff.serpentSting.remain(units.dyn40) > 5 * unit.gcd(true) then
        if cast.wildfireBomb(nil,"aoe") then ui.debug("Casting Wildfire Bomb [Wfi - Next Shrapnel]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,if=refreshable
    if cast.able.serpentSting() and debuff.serpentSting.refresh(units.dyn40) then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting [Wfi - Refresh]") return true end
    end
    -- Chakrams
    -- chakrams,if=!buff.mongoose_fury.remains
    if cast.able.chakrams() and enemies.yards40r > 0 and not buff.mongooseFury.exists() then
        if cast.chakrams(nil,"rect",1,40) then ui.debug("Casting Chakrams [Wfi]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite
    if cast.able.mongooseBite(var.eagleUnit) and talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange then
        if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite [Wfi]") return true end
    end
    -- Raptor Strike
    -- raptor_strike
    if cast.able.raptorStrike(var.eagleUnit) and not talent.mongooseBite and unit.distance(var.eagleUnit) <= var.eagleRange then
        if cast.raptorStrike(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Raptor Strike [Wfi]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.up
    if cast.able.serpentSting() and buff.vipersVenom.exists() then
        if cast.serpentSting() then ui.debug("Casting Serpent Sting [Wfi - Viper's Venom]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.volatile&dot.serpent_sting.ticking|next_wi_bomb.pheromone|next_wi_bomb.shrapnel
    if cast.able.wildfireBomb() and ((nextBomb(spell.volatileBomb) and debuff.serpentSting.exists(units.dyn40))
        or nextBomb(spell.pheromoneBomb) or nextBomb(spell.shrapnelBomb))
    then
        if cast.wildfireBomb(nil,"aoe") then ui.debug("Casting Wildfire Bomb [Wfi]") return true end
    end
end -- End Action List - Wildfire Infusion

-- Action List - Opener
actionList.Opener = function()
    -- Harpoon
    if ui.checked("Harpoon - Opener") and ui.mode.harpoon == 1 and cast.able.harpoon("target") and unit.valid("target")
        and unit.distance("target") >= 8 and unit.distance("target") < 30
    then
        if cast.harpoon("target") then ui.debug("") return true end
    end
    -- Start Attack
    -- auto_attack
    if (ui.value("Opener") == 1 or (ui.value("Opener") == 2 and ui.useCDs())) and not opener.complete then
        if unit.valid("target") and unit.distance("target") < var.eagleRange
            and unit.facing("player","target") and getSpellCD(61304) == 0
        then
            -- Begin
            if not opener.OPN1 then
                Print("Starting Opener")
                opener.count = opener.count + 1
                opener.OPN1 = true
                StartAttack()
                return
            -- Coordinated Assault
            elseif opener.OPN1 and not opener.CA1 then
                if level < 40 or cd.coordinatedAssault.remain() > gcd then
                    cast.openerFail("coordinatedAssault","CA1",opener.count)
                elseif cast.able.coordinatedAssault() then
                    cast.opener("coordinatedAssault","CA1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Serpent Sting
            elseif opener.CA1 and not opener.SS1 then
                if level < 12 or debuff.serpentSting.exists("target") then
                    cast.openerFail("serpentSting","SS1",opener.count)
                elseif cast.able.serpentSting() then
                    cast.opener("serpentSting","SS1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Wildfire Bomb
            elseif opener.SS1 and not opener.WB1 then
                if level < 20 or charges.wildfireBomb.count() == 0 then
                    cast.openerFail("wildfireBomb","WB1",opener.count)
                elseif cast.able.wildfireBomb() then
                    cast.opener("wildfireBomb","WB1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Raptor Strike
            elseif opener.WB1 and not opener.RS1 then
                if not cast.able.raptorStrike() then
                    cast.openerFail("raptorStrike","RS1",opener.count)
                elseif cast.able.raptorStrike() then
                    cast.opener("raptorStrike","RS1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Kill Command
            elseif opener.RS1 and not opener.KC1 then
                if cd.killCommand.remain() > gcd then
                    cast.openerFail("killCommand","KC1",opener.count)
                elseif cast.able.killCommand() then
                    cast.opener("killCommand","KC1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- End
            elseif opener.KC1 and opener.OPN1 then
                Print("Opener Complete")
                opener.count = 0
                opener.complete = true
            end
        end
    elseif (unit.exists("target") and (ui.value("Opener") == 2 and not ui.useCDs())) or ui.value("Opener") == 3 then
        opener.complete = true
    end
end -- End Action List - Opener

-- Action List - Pre-Combat
actionList.PreCombat = function()
    -- FlaskUp Module
    module.FlaskUp("Agility")
    -- Init Combat
    if not unit.inCombat() and unit.distance("target") < 40 and unit.valid("target") then --and opener.complete then
        -- Steel Trap
        -- steel_trap
        if cast.able.steelTrap("target") then
            if cast.steelTrap("target") then ui.debug("Casting Steel Trap [Pre-Combat]") return true end
        end
        -- Serpent Sting
        if cast.able.serpentSting("target") and (unit.ttd("target") > 3 or unit.isDummy()) and not debuff.serpentSting.exists("target") then
            if cast.serpentSting("target") then ui.debug("Casting Serpent Sting [Pre-Combat]") return true end
        end
        -- Start Attack
        if unit.distance("target") < 5 then
            unit.startAttack()
        end
    end
    -- Call Action List - Opener
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
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    essence                                       = br.player.essence
    focus                                         = br.player.power.focus.amount()
    focusMax                                      = br.player.power.focus.max()
    focusRegen                                    = br.player.power.focus.regen()
    level                                         = br.player.level
    module                                        = br.player.module
    opener                                        = br.player.opener
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    traits                                        = br.player.traits
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    var                                           = br.player.variables
    -- Units
    units.get(5)
    units.get(15)
    units.get(30)
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(5,"pet")
    enemies.get(8,"target")
    enemies.get(8,"pet")
    enemies.get(20,"pet")
    enemies.get(30)
    enemies.get(30,"pet")
    enemies.yards30r = getEnemiesInRect(10,30,false) or 0
    enemies.get(40)
    enemies.get(40,"player",true)
    enemies.get(40,"player",false,true)
    enemies.yards40r = getEnemiesInRect(10,40,false) or 0
    -- Opener Reset
    if (not unit.inCombat() and not unit.exists("target")) or opener.complete == nil then
        opener.count = 0
        opener.OPN1 = false
        opener.CA1 = false
        opener.SS1 = false
        opener.WB1 = false
        opener.RS1 = false
        opener.KC1 = false
        opener.complete = false
    end
    -- General Locals
    var.minCount                                  = ui.useCDs() and 1 or 3
    var.haltProfile                               = (unit.inCombat() and var.profileStop) or (unit.mounted() or unit.flying()) or ui.pause() or buff.feignDeath.exists() or ui.mode.rotation==4
    -- Profile Specific Locals
    var.eagleUnit                                 = buff.aspectOfTheEagle.exists() and units.dyn40 or units.dyn5
    var.eagleRange                                = buff.aspectOfTheEagle.exists() and 40 or 5
    var.eagleEnemies                              = buff.aspectOfTheEagle.exists() and enemies.yards40 or enemies.yards5
    var.lowestBloodseeker                         = debuff.bloodseeker.lowest(40,"remain") or "target"
    var.lowestSerpentSting                        = debuff.serpentSting.lowest(40,"remain") or "target"
    var.maxLatentPoison                           = debuff.latentPoison.max(var.eagleRange,"stack") or "target"
    
    if var.eagleUnit == nil then var.eagleUnit = "target" end
    -- variable,name=carve_cdr,op=setif,value=active_enemies,value_else=5,condition=active_enemies<5
    var.carveCdr = #enemies.yards5 < 5 and #enemies.yards5 or 5

    var.lowestTTDUnit = "target"
    var.lowestTTD = 99
    for i = 1, #var.eagleEnemies do
        local thisUnit = var.eagleEnemies[i]
        if unit.ttd(thisUnit) < var.lowestTTD then
            var.lowestTTD = unit.ttd(thisUnit)
            var.lowestTTDUnit = thisUnit
        end
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
        if cast.able.playDead() and cast.last.feignDeath() and not buff.playDead.exists("pet") then
            if cast.playDead() then ui.debug("Casting Play Dead [Pet]") return true end
        end
        StopAttack()
        if unit.isDummy() then ClearTarget() end
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -----------------------
        --- Extras Rotation ---
        -----------------------
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
        if unit.inCombat() and unit.valid("target") --[[and opener.complete]] and cd.global.remain() == 0 and not cast.current.focusedAzeriteBeam() then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupt() then return true end
            -- Start Attack
            -- actions=auto_attack
            if unit.distance(units.dyn5) < 5 then
                unit.startAttack()
            end
            -- Cooldowns
            -- call_action_list,name=CDs
            if actionList.Cooldown() then return true end
            -- Mongoose Bite
            -- mongoose_bite,if=active_enemies=1&target.time_to_die<focus%(action.mongoose_bite.cost-cast_regen)*gcd
            if cast.able.mongooseBite() and talent.mongooseBite and #var.eagleEnemies == 1
                and unit.ttd(var.eagleUnit) < focus / (cast.cost.mongooseBite() - cast.regen.mongooseBite()) * unit.gcd(true)
            then
                if cast.mongooseBite(var.eagleUnit,nil,1,var.eagleRange) then ui.debug("Casting Mongoose Bite") return true end
            end
            if (ui.mode.rotation == 1 and eagleScout() < 3) or (ui.mode.rotation == 3 and eagleScout() > 0) or level < 23 then
                -- Call Action List - Alpha Predator / Wildfire Infusion
                -- call_action_list,name=apwfi,if=active_enemies<3&talent.chakrams.enabled&talent.alpha_predator.enabled
                if talent.chakrams and talent.alphaPredator then
                    if actionList.ApWfi() then return true end
                end
                -- Call Action List - Wildfire Infusion
                -- call_action_list,name=wfi,if=active_enemies<3&talent.chakrams.enabled
                if talent.chakrams and not talent.alphaPredator then
                    if actionList.Wfi() then return true end
                end
                -- Call Action List - Single Target
                -- call_action_list,name=st,if=active_enemies<3&!talent.alpha_predator.enabled&!talent.wildfire_infusion.enabled
                if not talent.alphaPredator and not talent.wildfireInfusion then
                    if actionList.St() then return true end
                end
                -- Call Action List - Alpha Predator
                -- call_action_list,name=apst,if=active_enemies<3&talent.alpha_predator.enabled&!talent.wildfire_infusion.enabled
                if talent.alphaPredator and not talent.wildfireInfusion then
                    if actionList.ApSt() then return true end
                end
                -- Call Action List - Alpha Predator / Wildfire Infusion
                -- call_action_list,name=apwfi,if=active_enemies<3&talent.alpha_predator.enabled&talent.wildfire_infusion.enabled
                if talent.alphaPredator and talent.wildfireInfusion then
                    if actionList.ApWfi() then return true end
                end
                -- Call Action List - Wildfire Infusion
                -- call_action_list,name=wfi,if=active_enemies<3&!talent.alpha_predator.enabled&talent.wildfire_infusion.enabled
                if not talent.alphaPredator and talent.wildfireInfusion then
                    if actionList.Wfi() then return true end
                end
            end
            -- Call Action List - Cleave
            -- call_action_list,name=cleave,if=active_enemies>1&!talent.birds_of_prey.enabled|active_enemies>2
            if ((ui.mode.rotation == 1 and (((eagleScout() > 1 or #enemies.yards8t > 1) and not talent.birdsOfPrey)
                    or (eagleScout() > 2 or #enemies.yards8t > 2)))
                or (ui.mode.rotation == 2 and eagleScout() > 0)) and level >= 23
            then
                if actionList.Cleave() then return true end
            end
            -- Heart Essence - Concentrated Flame
            -- concentrated_flame
            if cast.able.concentratedFlame() then
                if cast.concentratedFlame() then ui.debug("Casting Concentrated Flame") return true end
            end
            -- Racial - Arcane Torrent
            -- arcane_torrent
            if ui.checked("Racial") and cast.able.racial() and unit.race() == "BloodElf" then
                if cast.racial() then ui.debug("Casting Racial") return true end
            end
        end -- End In Combat Rotation
    end -- Pause
    return true
end -- End runRotation
local id = 255
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
