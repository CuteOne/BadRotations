local rotationName = "ForsoothGuardian" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.wrath },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.moonfire },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shred },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.regrowth}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.regrowth },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.regrowth }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
    -- Form Button
    local FormModes = {
        [1] = { mode = "Caster", value = 1 , overlay = "Caster Form", tip = "Will force and use Caster Form", highlight = 1, icon = br.player.spell.moonkinForm },
        [2] = { mode = "Cat", value = 2 , overlay = "Cat Form", tip = "Will force and use Cat Form", highlight = 0, icon = br.player.spell.catForm },
        [3] = { mode = "Bear", value = 3 , overlay = "Bear Form", tip = "Will force and use Bear Form", highlight = 0, icon = br.player.spell.bearForm }
    };
    br.ui:createToggle(FormModes,"Forms",3,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            br.ui:createSpinnerWithout(section, "Shift Wait Time", 2, 0, 5, 1, "|cffFFFFFFTime in seconds the profile will wait while moving to shift. Combat is instant!")
            -- Mark of the Wild
            br.ui:createDropdown(section, "Mark of the Wild",{"|cffFFFFFFPlayer", "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFFocus", "|cffFFFFFFGroup"}, 1, "|cffFFFFFFSet how to use Mark of the Wild")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Regrowth
            br.ui:createSpinner(section, "Regrowth",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
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
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local cast
local cd
local comboPoints
local debuff
local enemies
local rage
local energy
local module
local ui
local unit
local units
local spell
local talent
local var = {}
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local profileStop
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}
local fbMaxEnergy
local movingTimer

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
-- Ferocious Bite Finish
local function ferociousBiteFinish(thisUnit)
    local GetSpellDescription = br._G["GetSpellDescription"]
    local desc = GetSpellDescription(spell.ferociousBite)
    local damage = 0
    local finishHim = false
    if thisUnit == nil then thisUnit = units.dyn5 end
    if comboPoints > 0 and not unit.isDummy(thisUnit) then
        local comboStart = desc:find(" "..comboPoints.." ",1,true)
        if comboStart ~= nil then
            comboStart = comboStart + 2
            local damageList = desc:sub(comboStart,desc:len())
            comboStart = damageList:find(": ",1,true)+2
            damageList = damageList:sub(comboStart,desc:len())
            local comboEnd = damageList:find(" ",1,true)-1
            damageList = damageList:sub(1,comboEnd)
            damage = damageList:gsub(",","")
        end
        finishHim = tonumber(damage) >= unit.health(thisUnit)
    end
    return finishHim
end
-- Time Moving
local function timeMoving()
    if movingTimer == nil then movingTimer = br._G.GetTime() end
    if not unit.moving() then
        movingTimer = br._G.GetTime()
    end
    return br._G.GetTime() - movingTimer
end

local getMarkUnitOption = function(option)
    local thisTar = ui.value(option)
    local thisUnit
    if thisTar == 1 then
        thisUnit = "player"
    end
    if thisTar == 2 then
        thisUnit = "target"
    end
    if thisTar == 3 then
        thisUnit = "mouseover"
    end
    if thisTar == 4 then
        thisUnit = "focus"
    end
    if thisTar == 5 then
        thisUnit = "player"
        if #br.friend > 1 then
            for i = 1, #br.friend do
                local nextUnit = br.friend[i].unit
                if buff.markOfTheWild.refresh(nextUnit) and unit.distance(var.markUnit) < 40 then
                    thisUnit = nextUnit
                    break
                end
            end
        end
    end
    return thisUnit
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Auto Shapeshift
    if (not buff.travelForm.exists() and unit.moving() and timeMoving() > ui.value("Shift Wait Time")) or unit.inCombat()
        or (unit.exists("target") and (unit.id("target") == 164577 or unit.id("target") == 166906) and unit.canAttack("player","target"))
    then
        local formValue = ui.mode.forms
        -- Bear Form
        if formValue == 3 and unit.level() >= 8 and cast.able.bearForm() and not buff.bearForm.exists() then
            if cast.bearForm() then ui.debug("Casting Bear Form") return true end
        end
        -- Caster Form
        if (formValue == 1 or (unit.exists("target") and (unit.id("target") == 164577 or unit.id("target") == 166906) and unit.canAttack("player","target")))
            and (buff.bearForm.exists() or buff.catForm.exists())
        then
            br._G.RunMacroText("/CancelForm")
            ui.debug("Casting Caster Form")
            return true
        end
        --Cat Form
        if (formValue == 2 or (formValue == 3 and unit.level() < 8)) and unit.level() >= 5 and cast.able.catForm() and not buff.catForm.exists()
            and ((unit.id("target") ~= 164577 and unit.id("target") ~= 166906) or not unit.canAttack("player","target"))
        then
            if cast.catForm() then ui.debug("Casting Cat Form") return true end
        end
        -- Mark of the Wild
        if ui.checked("Mark of the Wild") then
            var.markUnit = getMarkUnitOption("Mark of the Wild")
            if cast.able.markOfTheWild(var.markUnit) and buff.markOfTheWild.refresh(var.markUnit) and unit.distance(var.markUnit) < 40 then
                if cast.markOfTheWild(var.markUnit) then ui.debug("Casting Mark of the Wild") return true end
            end
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if br.player.health <= 70 and cast.able.barkskin() then
        cast.barkskin()
    end
    if br.player.health <= 60 and cast.able.survivalInstincts() then
        cast.survivalInstincts()
    end
    if br.player.health < 50 and cast.able.frenziedRegeneration() then
        cast.frenziedRegeneration()
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    for i=1, #enemies.yards10 do
        local thisUnit = enemies.yards10[i]
        
        if br.player.talent.skullBash and cast.able.skullBash() and unit.interruptable(thisUnit,70) then
            cast.skullBash(thisUnit)
        end
        if br.player.talent.incapacitatingRoar and cast.able.incapacitatingRoar() and unit.interruptable(thisUnit,70) then
            cast.incapacitatingRoar()
        end
    end
end -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
    --actions.precombat+=/variable,name=If_build,value=1,value_else=0,if=talent.thorns_of_iron.enabled&talent.reinforced_fur.enabled
    if talent.thornsOfIron and talent.reinforcedFur then
        var.If_build = 1
    else
        var.If_build = 0
    end
    if not unit.inCombat() then
        if unit.valid("target") then
            -- Auto Attack
            if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) then
                br._G.StartAttack(units.dyn5)
            end
        end
    end
end -- End Action List - PreCombat

actionList.bear = function()
    -- actions.bear=bear_form,if=!buff.bear_form.up
    if not buff.bearForm.exists() then
        cast.bearForm()
    end
    -- actions.bear+=/heart_of_the_Wild,if=talent.heart_of_the_wild.enabled
    if br.isBoss() and unit.ttd() > 45 and cast.able.heartOfTheWild() then
        cast.heartOfTheWild()
    end
    -- actions.bear+=/moonfire,cycle_targets=1,if=(((!ticking&time_to_die>12)|(refreshable&time_to_die>12))&active_enemies<7&talent.fury_of_nature.enabled)|(((!ticking&time_to_die>12)|(refreshable&time_to_die>12))&active_enemies<4&!talent.fury_of_nature.enabled)
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        if unit.InCombat(thisUnit) and (((not debuff.moonfire.exists(thisUnit) and unit.ttd(thisUnit) > 12) or (debuff.moonfire.refresh(thisUnit) and unit.ttd(thisUnit) > 12)) and #enemies.yards40 < 7 and talent.furyOfNature) or (((not debuff.moonfire.exists(thisUnit) and unit.ttd(thisUnit) > 12) or (debuff.moonfire.refresh(thisUnit) and unit.ttd(thisUnit) > 12)) and #enemies.yards40 < 4 and not talent.furyOfNature) then
            cast.moonfire(thisUnit)
        end
    end
    -- actions.bear+=/thrash_bear,target_if=refreshable|(dot.thrash_bear.stack<5&talent.flashing_claws.rank=2|dot.thrash_bear.stack<4&talent.flashing_claws.rank=1|dot.thrash_bear.stack<3&!talent.flashing_claws.enabled)
    if cast.able.thrashBear() and debuff.thrashBear.refresh() or (debuff.thrashBear.stack() < 5 and talent.rank.flashingClaws == 2 or debuff.thrashBear.stack() < 4 and talent.rank.flashingClaws == 1 or debuff.thrashBear.stack() < 3 and not talent.flashingClaws) then
        cast.thrashBear()
    end
    -- actions.bear+=/bristling_fur,if=!cooldown.pause_action.remains
    if cast.able.bristlingFur() and unit.ttd() > 8 then
        cast.bristlingFur()
    end
    -- actions.bear+=/barkskin,if=buff.bear_form.up
    if cast.able.barkskin() then
        cast.barkskin()
    end
    -- actions.bear+=/convoke_the_spirits
    if br.isBoss() and unit.ttd() > 4 and cast.able.convokeTheSpirits() then
        cast.convokeTheSpirits()
    end
    -- actions.bear+=/berserk_bear
    if cast.able.berserkPersistence() and br.isBoss() and unit.ttd() > 15 then
        cast.berserkPersistence()
    end
    -- actions.bear+=/incarnation
    if cast.able.incarnationGuardianOfUrsoc() and br.isBoss() and unit.ttd() > 30 then
        cast.incarnationGuardianOfUrsoc()
    end
    -- actions.bear+=/lunar_beam
    if cast.able.lunarBeam() and br.isBoss() and unit.ttd() > 8 then
        cast.lunarBeam()
    end
    -- actions.bear+=/rage_of_the_sleeper,if=buff.incarnation_guardian_of_ursoc.down&cooldown.incarnation_guardian_of_ursoc.remains>60|buff.incarnation_guardian_of_ursoc.up|(talent.convoke_the_spirits.enabled)
    if cast.able.rageOfTheSleeper() and br.isBoss() and unit.ttd() > 10 and not buff.incarnationGuardianOfUrsoc.exists() and cd.incarnationGuardianOfUrsoc.remains() > 60 or buff.incarnationGuardianOfUrsoc.exists() or (talent.convokeTheSpirits) then
        cast.rageOfTheSleeper()
    end
    -- actions.bear+=/berserking,if=(buff.berserk_bear.up|buff.incarnation_guardian_of_ursoc.up)
    -- actions.bear+=/maul,if=(buff.rage_of_the_sleeper.up&buff.tooth_and_claw.stack>0&active_enemies<=6&!talent.raze.enabled&variable.If_build=0)|(buff.rage_of_the_sleeper.up&buff.tooth_and_claw.stack>0&active_enemies=1&talent.raze.enabled&variable.If_build=0)
    if cast.able.maul() and (buff.rageOfTheSleeper.exists() and buff.toothAndClaw.stack() > 0 and #enemies.yards5 <= 6 and not talent.raze and var.If_build == 0) or (buff.rageOfTheSleeper.exists() and buff.toothAndClaw.stack() > 0 and #enemies.yards05 == 1 and talent.raze and var.If_build == 0) then
        cast.maul()
    end
    -- actions.bear+=/raze,if=buff.rage_of_the_sleeper.up&buff.tooth_and_claw.stack>0&variable.If_build=0&active_enemies>1
    if cast.able.raze() and buff.rageOfTheSleeper.exists() and buff.toothAndClaw.stack() > 0 and var.If_build == 0 and #enemies.yards > 1 then
        cast.raze()
    end
    -- actions.bear+=/maul,if=(((buff.incarnation.up|buff.berserk_bear.up)&active_enemies<=5&!talent.raze.enabled&(buff.tooth_and_claw.stack>=1))&variable.If_build=0)|(((buff.incarnation.up|buff.berserk_bear.up)&active_enemies=1&talent.raze.enabled&(buff.tooth_and_claw.stack>=1))&variable.If_build=0)
    if cast.able.maul() and (((buff.incarnationGuardianOfUrsoc.exists() or buff.berserkPersistence.exists()) and #enemies.yards5 <= 5 and not talent.raze and (buff.toothAndClaw.stack() >= 1)) and var.If_build == 0) or (((buff.incarnationGuardianOfUrsoc.exists() or buff.berserkPersistence.exists()) and #enemies.yards5 == 1 and talent.raze and (buff.toothAndClaw.stack() >= 1)) and var.If_build == 0) then
        cast.maul()
    end
    -- actions.bear+=/raze,if=(buff.incarnation.up|buff.berserk_bear.up)&(variable.If_build=0)&active_enemies>1
    if cast.able.raze() and (buff.incarnationGuardianOfUrsoc.exists() or buff.berserkPersistence.exists()) and (var.If_build == 0) and #enemies.yards5 > 1 then
        cast.raze()
    end
    -- actions.bear+=/ironfur,target_if=!debuff.tooth_and_claw_debuff.up,if=!buff.ironfur.up&rage>50&!cooldown.pause_action.remains&variable.If_build=0&!buff.rage_of_the_sleeper.up|rage>90&variable.If_build=0&!buff.rage_of_the_sleeper.up
    if cast.able.ironfur() and not debuff.toothAndClaw.exists() and not buff.ironfur.exists() and rage > 50 and var.If_build == 0 and not buff.rageOfTheSleeper.exists() or rage > 90 and var.If_build == 0 and not buff.rageOfTheSleeper.exists() then
        cast.ironfur()
    end
    -- actions.bear+=/ironfur,if=rage>90&variable.If_build=1|(buff.incarnation.up|buff.berserk_bear.up)&rage>20&variable.If_build=1
    if cast.able.ironfur() and rage > 90 and var.If_build == 1 or (buff.incarnationGuardianOfUrsoc.exists() or buff.berserkPersistence.exists()) and rage > 20 and var.If_build == 1 then
        cast.ironfur()
    end
    -- actions.bear+=/raze,if=(buff.tooth_and_claw.up)&active_enemies>1
    if cast.able.raze() and (buff.toothAndClaw.exists()) and #enemies.yards5 > 1 then
        cast.raze()
    end
    -- actions.bear+=/raze,if=(variable.If_build=0)&active_enemies>1
    if cast.able.raze() and (var.If_build == 0) and #enemies.yards5 > 1 then
        cast.raze()
    end
    -- actions.bear+=/mangle,if=buff.gore.up&active_enemies<11|buff.vicious_cycle_mangle.stack=3
    if cast.able.mangle() and buff.gore.exists() and #enemies.yards5 < 11 or buff.viciousCycleMangle.stack() == 3 then
        cast.mangle()
    end
    -- actions.bear+=/maul,if=(buff.tooth_and_claw.up&active_enemies<=5&!talent.raze.enabled)|(buff.tooth_and_claw.up&active_enemies=1&talent.raze.enabled)
    if cast.able.maul() and (buff.toothAndClaw.exists() and #enemies.yards5 <= 5 and not talent.raze) or (buff.toothAndClaw.exists() and #enemies.yards5 == 1 and talent.raze) then
        cast.maul()
    end
    -- actions.bear+=/maul,if=(active_enemies<=5&!talent.raze.enabled&variable.If_build=0)|(active_enemies=1&talent.raze.enabled&variable.If_build=0)
    if cast.able.maul() and (#enemies.yards5 <= 5 and not talent.raze and var.If_build == 0) or (#enemies.yards5 == 1 and talent.raze and var.If_build == 0) then
        cast.maul()
    end
    -- actions.bear+=/thrash_bear,target_if=active_enemies>=5
    if cast.able.thrashBear() and #enemies.yards5 >= 5 then
        cast.thrashBear()
    end
    -- actions.bear+=/swipe,if=buff.incarnation_guardian_of_ursoc.down&buff.berserk_bear.down&active_enemies>=11
    if cast.able.swipe() and not buff.incarnationGuardianOfUrsoc.exists() and not buff.berserkPersistence.exists() and #enemies.yards5 >= 11 then
        cast.swipe()
    end
    -- actions.bear+=/mangle,if=(buff.incarnation.up&active_enemies<=4)|(buff.incarnation.up&talent.soul_of_the_forest.enabled&active_enemies<=5)|((rage<90)&active_enemies<11)|((rage<85)&active_enemies<11&talent.soul_of_the_forest.enabled)
    if cast.able.mangle() and (buff.incarnationGuardianOfUrsoc.exists() and #enemies.yards5 <= 4) or (buff.incarnationGuardianOfUrsoc.exists() and talent.soulOfTheForest and #enemies.yards5 <= 5) or (( rage < 90) and #enemies.yards5 <11) or ((rage < 85) and #enemies.yards5 < 11 and talent.soulOfTheForest) then
        cast.mangle()
    end
    -- actions.bear+=/thrash_bear,if=active_enemies>1
    if cast.able.thrashBear() and #enemies.yards5 > 1 then
        cast.thrashBear()
    end
    -- actions.bear+=/pulverize,target_if=dot.thrash_bear.stack>2
    if cast.able.pulverize() and debuff.thrashBear.stack() > 2 then
        cast.pulverize()
    end
    -- actions.bear+=/thrash_bear
    if cast.able.thrashBear() then
        cast.thrashBear()
    end
    -- actions.bear+=/moonfire,if=buff.galactic_guardian.up
    if cast.able.moonfire() and buff.galacticGuardian.exists() then
        cast.moonfire()
    end
    -- actions.bear+=/swipe_bear
    if cast.able.swipeBear() then
        cast.swipeBear()
    end
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                        = br.player.buff
    cast                                        = br.player.cast
    cd                                          = br.player.cd
    comboPoints                                 = br.player.power.comboPoints.amount()
    debuff                                      = br.player.debuff
    enemies                                     = br.player.enemies
    energy                                      = br.player.power.energy.amount()
    module                                      = br.player.module
    ui                                          = br.player.ui
    unit                                        = br.player.unit
    units                                       = br.player.units
    spell                                       = br.player.spell
    rage = br.player.power.rage.amount()
    talent = br.player.talent
    -- General Locals
    profileStop                                 = profileStop or false
    haltProfile                                 = (unit.inCombat() and profileStop) or br.pause() or ui.rotation==4 or unit.id("target") == 156716
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    -- Enemies
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(10)
    enemies.get(40) -- Makes a varaible called, enemies.yards40

    -- Profile Specific Locals
    fbMaxEnergy = energy >= 50
    if not unit.inCombat() and not unit.exists("target") then
        if profileStop then profileStop = false end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
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
        if unit.inCombat() and unit.valid("target") and cd.global.remain() == 0 then

            ------------------------
            --- In Combat - Main ---
            ------------------------
            -- Melee in melee range--
            if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                -- Start Attack
                if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) then
                    br._G.StartAttack(units.dyn5)
                end
                ---------------
                --- Interrupt ---
                -----------------
                if actionList.Interrupt() then return true end
                -- Bear Form
                if buff.bearForm.exists() then
                    actionList.bear()
                end
            end
        end -- End In Combat Rotation
    end -- Pause
    return true
end -- End runRotation
local id = 104 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})