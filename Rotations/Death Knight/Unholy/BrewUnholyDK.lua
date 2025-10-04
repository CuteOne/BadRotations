-------------------------------------------------------
-- Author = BrewingCoder
-- Patch = 10.2.5
-- Coverage = 90%
-- Status = Limited
-- Readiness = Development
-------------------------------------------------------
local rotationName = "BrewUnholyDK"

local colors = {
    blue    = "|cff4285F4",
    red     = "|cffDB4437",
    yellow  = "|cffF4B400",
    green   = "|cff0F9D58",
    white   = "|cffFFFFFF",
    purple  = "|cff9B30FF",
    aqua    = "|cff89E2C7",
    blue2   = "|cffb8d0ff",
    green2  = "|cff469a81",
    blue3   = "|cff6c84ef",
    orange  = "|cffff8000"
}

local text = {
    options = {
        onlyUseConsumablesInRaid = "Only Use Consumables in Dungeon or Raid",
        onlyUseGargAODonBoss = "Only CDs (BURST Dmg) on Boss",
        useCombatPotWhenCDsActive = "Use CombatPotion When CDs Active",
        onlyUseCombatPotOnBoss = "Use CombatPotion only with Boss"
    },
    aoe = {
        aoeCount = "Number of Targets to run AOE rotation",
        aoeUseGargAODonBoss ="Only AOE CDs (Burst Dmg) on Boss"
    }

}

local function createToggles()
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spells.darkCommand },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spells.heartStrike },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spells.iceboundFortitude },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.bloodTap}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)

    local AutoPullModes = {
        [1] = { mode = "On", value =1, overlay = "Auto Pull Enabled", tip = "Auto Pull Enemies", highlight = 1, icon = br.player.spells.deathGrip},
        [2] = { mode = "Off", value = 2, overlay = "Auto Pull Disabled", tip = "Do Not AutoPull Enemies", highlight=0, icon=br.player.spells.deathGrip}
    };
    br.ui:createToggle(AutoPullModes,"Autopull",2,0)


    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.antiMagicShell },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.deathsAdvance},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.antiMagicShell }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",3,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.lichborne },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.lichborne }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",4,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.mindFreeze }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",5,0)
end


local function createOptions()
    local optionTable
    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
                    br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
                    br.ui:createCheckbox(section, "Auto Engage")
                    br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")

        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
           br.ui:createCheckbox(section,text.options.onlyUseGargAODonBoss)
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile,"AOE")
            br.ui:createCheckbox(section,text.aoe.aoeUseGargAODonBoss)
            br.ui:createSpinnerWithout(section,text.aoe.aoeCount,3,1,10,1,"|cffFFFFFFNumber of targets within 8 yards to start using AOE routine")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"Potions,Phials,and Runes")
            br.ui:createCheckbox(section,text.options.onlyUseConsumablesInRaid)
            br.player.module.PhialUp(section)
            br.player.module.ImbueUp(section)
            br.player.module.CombatPotionUp(section)
            br.ui:createCheckbox(section,text.options.useCombatPotWhenCDsActive)
            br.ui:createCheckbox(section,text.options.onlyUseCombatPotOnBoss)
            br.player.module.BasicHealing(section)
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Mind Freeze
            br.ui:createCheckbox(section,"Mind Freeze")
            br.ui:createCheckbox(section,"Use Death Grip as Interrupt")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.ui.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.ui.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.ui.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.ui.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.ui.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

local debugMessage = function(message)
    print(colors.red.. date() .. colors.white .. ": ".. message)
end



--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local cast
local cd
local charges
local enemies
local module
local power
local talent
local ui
local unit
local units
local use
local var
local debuff
local runes
local runicPower
local runicPowerMax
local pet


local function printWoundApply(thisUnit,SpellInfo)
    local unitName = UnitName(thisUnit)
    if unitName == nil then unitName="Unknown" end
    debugMessage("Build Wound " ..SpellInfo .. "[" .. colors.orange .. unitName .. ":" .. colors.red .. debuff.festeringWound.stack(thisUnit) .. "]")
end
local function printWoundSpend(thisUnit,SpellInfo)
    local unitName = UnitName(thisUnit)
    if unitName == nil then unitName="Unknown" end
    debugMessage("Spend Wound " .. SpellInfo .. "[" .. colors.orange .. unitName .. ":" .. colors.red .. debuff.festeringWound.stack(thisUnit) .. "]")
end

-- Any variables/functions made should have a local here to prevent possible conflicts with other things.
local function runeTimeUntil(rCount)
    if rCount <= var.runeCount then return 0 end
        local delta = rCount - var.runeCount
        local maxTime = 0
        for i=1,delta do
            maxTime = math.max(maxTime,var.runeCooldowns[i])
        end
        return maxTime
end

local function boolNumeric(value)
    return value and 1 or 0
end

--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
local actionList = {} -- Table for holding action lists.


actionList.Extra = function()
    if cast.able.raiseDead() and not pet.active.exists() then
        if cast.raiseDead() then ui.debug("[EXTRA] summoning Ghoul") return true; end;
    end
end -- End Action List - Extra


actionList.Defensive = function()
    if(var.inParty or var.inRaid) then
        if module.ImbueUp() then return true end
        if module.PhialUp() then return true end
    end
    module.BasicHealing()
end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
    if ui.useInterrupt() and ui.delay("Interrupts",unit.gcd()) then
        local thisUnit
        if ui.checked("Mind Freeze") and cast.able.mindFreeze("target") then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.mindFreeze(thisUnit) then ui.debug("Casting Mind Freeze on "..unit.name(thisUnit)) return true end
                end
            end
        end
        if ui.checked("Use Death Grip as Interrupt") and cast.able.deathGrip("target") then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip Interrupt on "..unit.name(thisUnit)) return true end
                end
            end
        end
    end
end -- End Action List - Interrupt


actionList.Cooldown = function()
    --summon_gargoyle,if=buff.commander_of_the_dead.up|!talent.commander_of_the_dead
        if cast.able.summonGargoyle("target") and ( (ui.checked(text.options.onlyUseGargAODonBoss) and unit.isBoss("target")) or not ui.checked(text.options.onlyUseGargAODonBoss)) and (
            buff.commanderOfTheDead.exists() or not talent.commanderOfTheDead
        ) then
            if cast.summonGargoyle("target") then ui.debug("CD Summon  Gargoyle") return true; end;
        end
    --raise_dead,if=!pet.ghoul.active
    if cast.able.raiseDead() and not pet.active.exists() then
        if cast.raiseDead("pet") then ui.debug("CD:Raise Dead") return true; end;
    end
    --dark_transformation,if=cooldown.apocalypse.remains<5
    if cast.able.darkTransformation() and (cd.apocalypse.remains() < 5) then
        if cast.darkTransformation() then ui.debug("CD Dark Transformation") return true; end;
    end
    --apocalypse,target_if=max:debuff.festering_wound.stack,if=variable.st_planning&debuff.festering_wound.stack>=4
    if cast.able.apocalypse(var.maxFesteringWounds) and(
        debuff.festeringWound.stack(var.maxFesteringWounds) >= 4
    ) then
        if cast.apocalypse(var.maxFesteringWounds) then ui.debug("T:CD apocalypse") return true; end;
    end
    --empower_rune_weapon,if=variable.st_planning&
    --(pet.gargoyle.active&pet.gargoyle.remains<=23|!talent.summon_gargoyle&talent.army_of_the_damned&pet.army_ghoul.active&pet.apoc_ghoul.active|
    --!talent.summon_gargoyle&!talent.army_of_the_damned&buff.dark_transformation.up|!talent.summon_gargoyle&!talent.summon_gargoyle&buff.dark_transformation.up)|
    --fight_remains<=21
    if cast.able.empowerRuneWeapon() and (
        (var.hasGargoyle and var.GargoyleTTL <=23 or not talent.summonGargoyle and
        talent.armyOfTheDamned and cast.last.time.armyOfTheDead(30) or talent.summonGargoyle and not talent.armyOfTheDamned and buff.darkTransformation.exists()
        or not talent.summonGargoyle and not talent.summon_gargoyle and buff.darkTransformation.exists()) or
        unit.ttdGroup(40) <= 21
    ) then
        if cast.empowerRuneWeapon() then ui.debug("U:CD Empower Rune Weapon") return true; end;
    end

    --unholy_assault,target_if=min:debuff.festering_wound.stack
    if cast.able.unholyAssault("target") then
        if cast.unholyAssault(var.minFesteringWounds) then printWoundApply(var.minFesteringWounds,"UnHoly Assault") return true; end;
    end
    --soul_reaper,if=active_enemies=1&target.time_to_pct_35<5&target.time_to_die>5
    if cast.able.soulReaper("target") and (
        #enemies.yards5 ==1 and
        unit.ttd("target",35) <= 35 and
        unit.ttd("target") > 5
    ) then
        if cast.soulReaper("target") then ui.debug("W:CD Soul reaper") return true; end;
    end





end
actionList.AOECooldown = function()
    --actions.aoe_cooldowns=vile_contagion,target_if=max:debuff.festering_wound.stack,if=debuff.festering_wound.stack>=4&cooldown.any_dnd.remains<3
    -- if cast.able.vileContagion() and (

    -- ) then
    --     if cast.vileContagion() then ui.debug("AOECD: Vile Contagion") return true; end;
    -- end
end
actionList.PreCombat = function()
    if cast.able.raiseDead() and not pet.active.exists() then
        if cast.raiseDead() then ui.debug("[EXTRA] summoning Ghoul") return true; end;
    end
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        module.FlaskUp("Strength")
        -- if  not buff.augmentation.exists() then
        --     if use.bestItem(br.list.items.howlingRuneQualities) then ui.debug("Applying best Howling Rune") return true end
        -- end

        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Logic based on pull timers (IE: DBM/BigWigs)
        end -- End Pre-Pull

    end -- End No Combat
end
actionList.HighPrioActions = function()

    --antimagic_shell,if=runic_power.deficit>40&(pet.gargoyle.active|!talent.summon_gargoyle|cooldown.summon_gargoyle.remains>cooldown.antimagic_shell.duration)

        if cast.able.antiMagicShell() and (
            var.runicPowerDeficit > 40 and (var.hasGargoyle or not talent.summonGargoyle or cd.summonGargoyle.remains() > cd.antiMagicShell.duration())
        ) then
            if cast.antiMagicShell() then ui.debug("HPA.01: AntiMagic Shell") return true; end;
        end


    --potion,if=(30>=pet.gargoyle.remains&pet.gargoyle.active)|(!talent.summon_gargoyle|cooldown.summon_gargoyle.remains>60|cooldown.summon_gargoyle.ready)
    --&(buff.dark_transformation.up&30>=buff.dark_transformation.remains|pet.army_ghoul.active&pet.army_ghoul.remains<=30|pet.apoc_ghoul.active
    --&pet.apoc_ghoul.remains<=30)|fight_remains<=30
    -- if(
    --     30 >=var.GargoyleTTL and
    --     var.hasGargoyle) or
    --     (not talent.summonGargoyle or cd.summonGargoyle.remains()>60 or cd.summonGargoyle.ready()) and
    --     (buff.darkTransformation.exists() and buff.darkTransformation.remains() <= 30 ) or
    --     unit.ttdGroup(40) <= 30 then
    --     if (ui.checked(text.options.onlyUseConsumablesInRaid) and (var.inParty or var.inRaid)) or not (ui.checked(text.options.onlyUseConsumablesInRaid)) then
    --         if module.CombatPotionUp() then ui.debug("HPA.02: Combat Potion") return true; end;
    --     end
    -- end

    if ((ui.checked(text.options.onlyUseConsumablesInRaid) and (var.inParty or var.inRaid)) or not ui.checked(text.options.onlyUseConsumablesInRaid)) then
        if ((ui.checked(text.options.onlyUseCombatPotOnBoss) and unit.isBoss("target")) or not ui.checked(text.options.onlyUseCombatPotOnBoss)) then
            if ((var.hasGargoyle and 30 >= var.GargoyleTTL) or not talent.summonGargoyle) and
                (buff.darkTransformation.exists() or not talent.darkTransformation) and
                cast.last.time.armyOfTheDead(20) and
                unit.ttdGroup(40) >= 30 then
                    if module.CombatPotionUp() then ui.debug(colors.blue3 .. " COMBAT POTION!!!!!") return true end
                end
        end
    end
    --if ((var.hasGargoyle and 30 >= var.GargoyleTTL) or not talent.summonGargoyle) and (buff.darkTransformation.exists() or not talent.darkTransformation) and unit.ttdGroup(40) >= 30

    --army_of_the_dead,if=talent.summon_gargoyle&cooldown.summon_gargoyle.remains<2|!talent.summon_gargoyle|fight_remains<35
    if cast.able.armyOfTheDead() and (
        talent.summonGargoyle and cd.summonGargoyle.remains() < 2 or not talent.summonGargoyle or unit.ttdGroup(40) < 35
    ) then
        if cast.armyOfTheDead() then ui.debug("HPA.03: Army of the Dead") return true; end;
    end

    --death_coil,if=(active_enemies<=3|!talent.epidemic)&(pet.gargoyle.active&talent.commander_of_the_dead&buff.commander_of_the_dead.up&cooldown.apocalypse.remains<5&buff.commander_of_the_dead.remains>27|debuff.death_rot.up&debuff.death_rot.remains<gcd)
    if cast.able.deathCoil("target") and (
        (#enemies.yards5  <= 3 or not talent.epidemic) and
        (var.hasGargoyle and talent.commanderOfTheDead and buff.commanderOfTheDead.exists() and cd.apocalypse.remains() < 5 and buff.commanderOfTheDead.remains() > 27 or debuff.deathRot.exists("target") and debuff.deathRot.remains("target") < unit.gcd())
    ) then
        if cast.deathCoil("target") then ui.debug("HPA.04: Death Coil") return true end;
    end

    --epidemic,if=active_enemies>=4&(talent.commander_of_the_dead&buff.commander_of_the_dead.up&cooldown.apocalypse.remains<5|debuff.death_rot.up&debuff.death_rot.remains<gcd)
    if cast.able.epidemic() and (
        #enemies.yards30 >= 4 and (talent.commanderOfTheDead and buff.commanderOfTheDead.exists() and cd.apocalypse.remains() < 5 or debuff.deathRot.exists("target") and debuff.deathRot.remains("target") < unit.gcd())
    ) then
        if cast.epidemic() then ui.debug("HPA.05: Epidemic") return true; end;
    end

    --actions.high_prio_actions+=/wound_spender,if=(cooldown.apocalypse.remains>variable.apoc_timing+3|active_enemies>=3)&talent.plaguebringer&
    --(talent.superstrain|talent.unholy_blight)&buff.plaguebringer.remains<gcd
    if (cd.apocalypse.remains() > var.apoc_timing+3 or #enemies.yards5 >=3) and talent.plaguebringer and
    (talent.superstrain or talent.unholyBlight) and buff.plaguebringer.remains() > unit.gcd() then
        if talent.clawingShadows then
            if cast.able.clawingShadows("target") then
                if cast.clawingShadows("target") then printWoundSpend("target","HPA.06: Clawing Shadows") return true; end;
            end
        else
            if cast.able.scourgeStrike("target") then
                if cast.scourgeString("target") then printWoundSpend("target","HPA.06: Scourge Strike") return true; end;
            end
        end
    end

    --unholy_blight,if=variable.st_planning&((!talent.apocalypse|cooldown.apocalypse.remains)&talent.morbidity|!talent.morbidity)|variable.adds_remain|fight_remains<21
    if talent.unholyBlight and cast.able.unholyBlight() and (
        var.st_planning and (( not talent.apocalypse or cd.apocalypse.remains()) and talent.morbidity or not talent.morbidity) or var.adds_remain or unit.ttdGroup(40) < 21
    ) then
        if cast.unholyBlight() then ui.debug("HPA.07: Unholy Blight") return true; end;
    end


    --outbreak,target_if=target.time_to_die>dot.virulent_plague.remains&(dot.virulent_plague.refreshable|talent.superstrain&
    --(dot.frost_fever_superstrain.refreshable|dot.blood_plague_superstrain.refreshable))&
    --(!talent.unholy_blight|talent.unholy_blight&cooldown.unholy_blight.remains>15%((talent.superstrain*3)+(talent.plaguebringer*2)+(talent.ebon_fever*2)))
    if cast.able.outbreak("target") and (
        unit.ttd("target") > debuff.virulentPlague.remains("target") and (debuff.virulentPlague.refresh("target")) and
        (not talent.unholyBlight or
            (talent.unholyBlight and cd.unholyBlight.remains >15%((boolNumeric(talent.superstrain)*3)+(boolNumeric(talent.plaguebringer)*2)+(boolNumeric(talent.ebonFever*2))))        )
    ) then
        if cast.outbreak("target") then ui.debug("HPA.08 Outbreak") return true; end;
    end


end
actionList.Trinkets = function()
end
actionList.GargSetup = function()
        --apocalypse,if=debuff.festering_wound.stack>=4&(buff.commander_of_the_dead.up&pet.gargoyle.remains<23|!talent.commander_of_the_dead)
        if cast.able.apocalypse("target") and (
            debuff.festeringWound.stack("target") >= 4 and (buff.commanderOfTheDead.exists() and var.GargoyleTTL<23 or not talent.commanderOfTheDead)
        ) then
            if cast.apocalypse("target") then ui.debug("GARGSETUP.01: apocalypse") return true; end;
        end

        --army_of_the_dead,if=talent.commander_of_the_dead&(cooldown.dark_transformation.remains<3|buff.commander_of_the_dead.up)|
        --!talent.commander_of_the_dead&talent.unholy_assault&cooldown.unholy_assault.remains<10|!talent.unholy_assault&!talent.commander_of_the_dead
        if cast.able.armyOfTheDead() and (
            talent.commanderOfTheDead and
                (cd.darkTransformation.remains()<3 or buff.commanderOfTheDead.exists()) or
                not talent.commanderOfTheDead and talent.unholyAssault and cd.unholyAssault.remains()<10 or
                (not talent.unholyAssault and not talent.commanderOfTheDead)
        ) then
            if cast.armyOfTheDead() then ui.debug("GARGSETUP.02: Army of the Dead") return true; end;
        end

        --soul_reaper,if=active_enemies=1&target.time_to_pct_35<5&target.time_to_die>5
        if cast.able.soulReaper("target") and (
            #enemies.yards5==1 and unit.ttd("target",35) <= 35 and unit.ttd("target") > 5
        ) then
            if cast.soulReaper("target") then ui.debug("GARGSETUP.03: Soul Reaper") return true; end;
        end

        --summon_gargoyle,use_off_gcd=1,if=buff.commander_of_the_dead.up|!talent.commander_of_the_dead&runic_power>=40
        if cast.able.summonGargoyle("target") and (
            buff.commanderOfTheDead.exists or not talent.commanderOfTheDead and runicPower >= 40
        ) then
            if cast.summonGargoyle("target") then ui.debug("GARGSETUP.04: Summon Gargoyle") return true; end;
        end

        --empower_rune_weapon,if=pet.gargoyle.active&pet.gargoyle.remains<=23
        if cast.able.empowerRuneWeapon() and (
            var.hasGargoyle and var.GargoyleTTL <= 23
        ) then
            if cast.empowerRuneWeapon() then ui.debug("GARGSETUP.05: Empower Rune Weapon") return true; end;
        end

        --unholy_assault,if=pet.gargoyle.active&pet.gargoyle.remains<=23
        if cast.able.unholyAssault("target")  and (
            var.hasGargoyle and var.GargoyleTTL <= 23
        ) then
            if cast.unholyAssault("target") then ui.debug("GARGSETUP.06: Unholy Assault") return true; end;
        end

        --TODO this is where we need to hit up our Combat Potion
        --potion,if=(30>=pet.gargoyle.remains&pet.gargoyle.active)|(!talent.summon_gargoyle|cooldown.summon_gargoyle.remains>60
        --|cooldown.summon_gargoyle.ready)&(buff.dark_transformation.up&30>=buff.dark_transformation.remains|pet.army_ghoul.active&pet.army_ghoul.remains<=30|pet.apoc_ghoul.active&pet.apoc_ghoul.remains<=30)
        if (30>=var.GargoyleTTL and var.hasGargoyle) or (not talent.summonGargoyle or cd.summonGargoyle.remains() > 60 or cd.summonGargoyle.ready()) and
        (buff.darkTransformation.exists() and 30>= buff.darkTransformation.remains or cast.last.time.armyOfTheDead(5)) then
            if module.CombatPotionUp() then ui.debug("GARGSETUP: COMBAT POTION") return true; end;
        end

        --dark_transformation,if=talent.commander_of_the_dead&runic_power>40|!talent.commander_of_the_dead
        if cast.able.darkTransformation() and (
            (talent.commanderOfTheDead and runicPower > 40) or not talent.commanderOfTheDead
        ) then
            if cast.darkTransformation() then ui.debug("GARGSETUP.07: Dark Transformation") return true; end;
        end

        --any_dnd,if=!death_and_decay.ticking&debuff.festering_wound.stack>0
        if talent.defile then
            if cast.able.defile("target") and unit.distance("target") <= 10 and (
            not buff.defile.exists("player") and debuff.festeringWound.stack("target") > 0
            ) then
                if cast.defile("target") then ui.debug("GARGSETUP.08: Defile") return true; end;
            end
        else
            if cast.able.deathAndDecay("target") and unit.distance("target") <= 10 and not unit.moving() (
            not buff.deathAndDecay.exists("player") and debuff.festeringWound.stack("target") > 0
            ) then
                if cast.deathAndDecay("target") then ui.debug("GARGSETUP.09: Death and Decay") return true; end;
            end
        end
        --festering_strike,if=debuff.festering_wound.stack=0|!talent.apocalypse|runic_power<40&!pet.gargoyle.active
        if cast.able.festeringStrike("target") and (
            debuff.festeringWound.stack("target") == 0 or (not talent.apocalypse or runicPower < 40 and not var.hasGargoyle)
        ) then
            if cast.festeringStrike("target") then ui.debug("GARGSETUP.10: Festering Strike") return true; end;
        end
        --death_coil,if=rune<=1
        if cast.able.deathCoil("target") and (runes <= 1) then
            if cast.deathCoil("target") then ui.debug("GARGSETUP.11 Coil") return true; end;
        end
end
actionList.St = function()

    --death_coil,if=!variable.epidemic_priority&(!variable.pooling_runic_power&variable.spend_rp|fight_remains<10)
    if cast.able.deathCoil("target") and (
        not var.epidemic_priority and (not var.pooling_runic_power and var.spend_rp or unit.ttdGroup(40)<10)
    ) then
        if cast.deathCoil("target") then ui.debug("ST.01: Death Coil") return true; end;
    end

    --actions.st+=/epidemic,if=variable.epidemic_priority&(!variable.pooling_runic_power&variable.spend_rp|fight_remains<10)
    if cast.able.epidemic("target") and (var.epidemic_priority and (not var.pooling_runic_power and var.spend_rp or unit.ttdGroup(40)<10)) then
        if cast.epidemic("target") then ui.debug("ST.02: epidemic") return true; end;
    end

    --any_dnd,if=!death_and_decay.ticking&(active_enemies>=2|talent.unholy_ground&(pet.apoc_ghoul.active&pet.apoc_ghoul.remains>=13|pet.gargoyle.active&pet.gargoyle.remains>8|pet.army_ghoul.active&pet.army_ghoul.remains>8|!variable.pop_wounds&debuff.festering_wound.stack>=4)|talent.defile&(pet.gargoyle.active|pet.apoc_ghoul.active|pet.army_ghoul.active|buff.dark_transformation.up))&(death_knight.fwounded_targets=active_enemies|active_enemies=1)
    if cast.able.deathAndDecay("target") and not unit.moving() and (
        true--not buff.deathAndDecay.exists() and (#enemies.yards5 >= 2 or talent.unholyGround and (var.hasGargoyle or var.GargoyleTTL > 8 or cast.last.armyOfTheDead(30) or not var.pop_wounds==1 and debuff.festeringWound.stack("target")>=4) or talent.defile and (var.hasGargoyle or cast.last.armyOfTheDead(30) or buff.darkTransformation.exist()))
    ) then
        if cast.deathAndDecay("target") then ui.debug("ST.03: Death and Decay") return true; end;
    end

    --wound_spender,target_if=max:debuff.festering_wound.stack,if=variable.pop_wounds|active_enemies>=2&death_and_decay.ticking
    if (var.pop_wounds or #enemies.yards5f >=2 and buff.deathAndDecay.exists("target")) then
             if talent.clawingShadows then
                if cast.able.clawingShadows(var.maxFesteringWounds) then
                    if cast.clawingShadows(var.maxFesteringWounds) then printWoundSpend(var.maxFesteringWounds,"ST.04: Clawing Shadows") return true; end;
                end
            else
                if cast.able.scourgeStrike(var.maxFesteringWounds) then
                    if cast.clawingShadows(var.maxFesteringWounds) then printWoundSpend(var.maxFesteringWounds,"ST.04: Scourge Strike") return true; end;
                end
            end
    end

    --festering_strike,target_if=min:debuff.festering_wound.stack,if=!variable.pop_wounds&debuff.festering_wound.stack<4
    if (not var.pop_wounds and debuff.festeringWound.stack(var.minFesteringWounds) < 4) and cast.able.festeringStrike(var.minFesteringWounds) then
        if cast.festeringStrike(var.minFesteringWounds) then printWoundApply(var.minFesteringWounds,"ST.05: Festering Wounds") return true; end;
    end

    --death_coil
    if cast.able.deathCoil("target") then
        if cast.deathCoil("target") then ui.debug("ST.06: Death Coil") return true; end;
    end

    --wound_spender,target_if=max:debuff.festering_wound.stack,if=!variable.pop_wounds&debuff.festering_wound.stack>=4
    if (not var.pop_wounds and debuff.festeringWound.stack(var.maxFesteringWounds) >=4) then
        if talent.clawingShadows then
            if cast.able.clawingShadows(var.maxFesteringWounds) then
                if cast.clawingShadows(var.maxFesteringWounds) then  printWoundSpend(var.maxFesteringWounds,"ST.07: Clawing Shadows")  return true; end;
            end
        else
            if cast.able.scourgeStrike(var.maxFesteringWounds) then
                if cast.scourgeString(var.maxFesteringWounds) then  printWoundSpend(var.maxFesteringWounds,"ST.07: Scourge Strike")  return true; end;
            end
        end
    end
end

actionList.SingleTargetStandard = function()
    if #enemies.yards5f == 1  then
        if br.functions.unit:getHP("target") <= 35 and unit.ttd("target") > 5 and not debuff.exists.soulReaper("target") and cast.able.soulReaper("target") then
            if cast.soulReaper("target") then ui.debug("STS.01: Soul Reaper") return true; end;
        end
        if talent.outbreak and
        (not debuff.virulentPlague.exists("target") or debuff.virulentPlague.remains("target") < unit.gcd(false))
        and cast.able.outbreak("target") then
            if cast.outbreak("target")     then ui.debug("STS.02: outbreak") return true; end;
        end
        if talent.unholyBlight and
        (not debuff.virulentPlague.exists("target") or debuff.virulentPlague.remains("target") < unit.gcd(false))
        and cast.able.unholyBlight("target") then
            if cast.unholyBlight("target") then ui.debug("STS.03: unholy Blight") return true; end;
        end
        if buff.suddenDoom.exists("target") or debuff.deathRot.remains("target") < unit.gcd(false) or runicPower >= 80 then
            if cast.able.deathCoil("target") then
                if cast.deathCoil("target") then ui.debug("STS.04 Death Coil") return true; end;
            end
        end
        if debuff.festeringWound.stack("target") == 0 or (cd.apocalypse.remains() <= (unit.gcd()*2) and debuff.festeringWound.stack("target") < 4) then
            if cast.able.festeringStrike("target") then
                if cast.festeringStrike("target") then ui.debug("STS.05: Festering Strike") return true; end;
            end
        end
        if debuff.festeringWound.stack("target") >= 1 and cast.able.clawingShadows("target") then
            if cast.clawingShadows("target") then ui.debug("STS.06 Clawing Shadows") return true; end;
        end
    end
    return false;
end
actionList.GargoyleActive = function()

    if br.functions.unit:getHP("target") <= 35 and not debuff.exists.soulReaper("target") and cast.able.soulReaper("target") then
        if cast.soulReaper("target") then ui.debug("GARG.01: Soul Reaper") return true; end;
    end
    if cast.able.deathCoil("target") and (runicPower >= 30 or buff.suddenDoom.exists()) then
        if cast.deathCoil("target") then ui.debug("GARG.02: DeathCoil") return true; end;
    end
    if talent.outbreak and
    (not debuff.virulentPlague.exists("target") or debuff.virulentPlague.remains("target") < unit.gcd(false))
    and cast.able.outbreak("target") then
        if cast.outbreak("target")     then ui.debug("GARG.03: outbreak") return true; end;
    end
    if talent.unholyBlight and
    (not debuff.virulentPlague.exists("target") or debuff.virulentPlague.remains("target") < unit.gcd(false))
    and cast.able.unholyBlight("target") then
        if cast.unholyBlight("target") then ui.debug("GARG.04: unholy Blight") return true; end;
    end
    if debuff.festeringWound.stack("target") == 0  then
        if cast.able.festeringStrike("target") then
            if cast.festeringStrike("target") then ui.debug("GARG.05: Festering Strike") return true; end;
        end
    end
    if debuff.festeringWound.stack("target") >= 2 and cast.able.clawingShadows("target") then
        if cast.clawingShadows("target") then ui.debug("GARG.06: clawing Shadows") return true; end;
    end
end
actionList.CoolDownTwo = function()
    if cast.able.armyOfTheDead() then
        if cast.armyOfTheDead() then ui.debug("CD2.1: Army of the dead") return true; end;
    end
    if cast.able.darkTransformation() then
        if cast.darkTransformation() then ui.debug("CD2.2: Dark Transformation") return true; end;
    end
    if cast.able.summonGargoyle("target")  and not (cd.armyOfTheDead.remains()< 2 ) then
        if cast.summonGargoyle("target") then ui.debug("CD2.3: Summon Gargoyle") return true; end;
    end
end

actionList.AOE = function()
    --actions.aoe=epidemic,if=!variable.pooling_runic_power|fight_remains<10
    if not var.pooling_runic_power or unit.ttdGroup(40) < 10 then
        if cast.able.epidemic() then
            if cast.epidemic() then ui.debug("GAOE.1: epidemic") return true; end
        end
    end
    --actions.aoe+=/wound_spender,target_if=max:debuff.festering_wound.stack,if=variable.pop_wounds
    if var.pop_wounds then
        if talent.clawingShadows then
            if cast.able.clawingShadows(var.maxFesteringWounds) then
                if cast.clawingShadows(var.maxFesteringWounds) then printWoundSpend(var.maxFesteringWounds,"GAOE.2: clawing shadows") return true; end;
            end
        else
            if cast.able.scourgeStrike(var.maxFesteringWounds) then
                if cast.scourgeString(var.maxFesteringWounds) then printWoundSpend(var.maxFesteringWounds,"GAOE.2: scourge strike") return true; end;
            end
        end
    else  --actions.aoe+=/festering_strike,target_if=max:debuff.festering_wound.stack,if=!variable.pop_wounds
        if cast.able.festeringStrike(var.maxFesteringWounds) then
            if cast.festeringStrike(var.maxFesteringWounds) then printWoundApply(var.maxFesteringWounds,"GAOE.3: Festering Strike") return true; end
        end
    end
    --actions.aoe+=/death_coil,if=!variable.pooling_runic_power&!talent.epidemic
    if not var.pooling_runic_power and not talent.epidemic then
        if cast.able.deathCoil("target") then
            if cast.deathCoil("target") then ui.debug("GAOE.3: death coil") return true; end
        end
    end
end

actionList.AOEBurst = function()
    --actions.aoe_burst=epidemic,if=(!talent.bursting_sores|rune<1|talent.bursting_sores&debuff.festering_wound.stack=0)
    --&!variable.pooling_runic_power&(active_enemies>=6|runic_power.deficit<30|buff.festermight.stack=20)
    if (not talent.burstingSores or runes < 1 or talent.burstingSores and debuff.festeringWound.stack("target")==0) and
        not var.pooling_runic_power and (#enemies.yards8 >= 6 or var.runicPowerDeficit < 30 or buff.festermight.stack()==20) then
            if cast.able.epidemic() then
                if cast.epidemic() then ui.debug("AOEBurst.1: epidemic") return true; end
            end
        end

   -- actions.aoe_burst+=/wound_spender,target_if=max:debuff.festering_wound.stack,if=debuff.festering_wound.stack>=1
   if debuff.festeringWound.stack(var.maxFesteringWounds) >= 1 then
        if talent.clawingShadows then
            if cast.able.clawingShadows(var.maxFesteringWounds) then
                if cast.clawingShadows(var.maxFesteringWounds) then printWoundSpend(var.maxFesteringWounds,"AOEBurst.2: clawing shadows") return true; end;
            end
        else
            if cast.able.scourgeStrike(var.maxFesteringWounds) then
                if cast.scourgeString(var.maxFesteringWounds) then printWoundSpend(var.maxFesteringWounds,"AOEBurst.2: scourge strike") return true; end;
            end
        end
   end

    --actions.aoe_burst+=/epidemic,if=!variable.pooling_runic_power|fight_remains<10
    if not var.pooling_runic_power or unit.ttdGroup(40) < 10 then
        if cast.able.epidemic() then
            if cast.epidemic() then ui.debug("AOEBurst.3: epidemic") return true end
        end
    end
    --actions.aoe_burst+=/death_coil,if=!variable.pooling_runic_power&!talent.epidemic
    if not var.pooling_runic_power and not talent.epidemic then
        if cast.able.deathCoil("target") then
            if cast.deathCoil("target") then ui.debug("AOEBurst.4: death coil") return true end
        end
    end
    --actions.aoe_burst+=/wound_spender
    if talent.clawingShadows then
            if cast.able.clawingShadows("target") then
                if cast.clawingShadows("target") then printWoundSpend("target","AOEBurst.5: clawing shadows") return true; end;
            end
    else
            if cast.able.scourgeStrike("target") then
                if cast.scourgeString("target") then printWoundSpend("target","AOEBurst.5: scourge strike") return true; end;
            end
    end
end

actionList.AOESetup = function()
    --actions.aoe_setup=any_dnd,if=(!talent.bursting_sores|death_knight.fwounded_targets=active_enemies|death_knight.fwounded_targets>=8|raid_event.adds.exists&raid_event.adds.remains<=11&raid_event.adds.remains>5)
    --basically going to cast DnD regardless, just check and see if we are standing in it or not
    if not buff.deathAndDecay.exists() and cast.able.deathAndDecay("playerGround") and not unit.moving("player") then
        if cast.deathAndDecay("playerGround") then ui.debug("AOESetup: DnD") return true; end
    end
    --actions.aoe_setup+=/festering_strike,target_if=min:debuff.festering_wound.stack,if=death_knight.fwounded_targets<active_enemies&talent.bursting_sores
    if  var.fwounded_targets < #enemies.yards5f and talent.burstingSores then
        if cast.able.festeringStrike(var.minFesteringWounds) then
            if cast.festeringStrike(var.minFesteringWounds) then ui.debug("AOESetup: festering strike on Min Unit") return true; end
        end
    end
    --actions.aoe_setup+=/epidemic,if=!variable.pooling_runic_power|fight_remains<10
    if not var.pooling_runic_power or unit.ttdGroup(40) < 10 then
        if cast.able.epidemic() then
            if cast.epidemic() then ui.debug("AOESetup: epidemic") return true; end;
        end
    end
    --actions.aoe_setup+=/festering_strike,target_if=min:debuff.festering_wound.stack,if=death_knight.fwounded_targets<active_enemies
    if var.fwounded_targets < #enemies.yards5f then
        if cast.able.festeringStrike(var.minFesteringWounds) then
            if cast.festeringStrike(var.minFesteringWounds) then ui.debug("AOESetup: Festering strike on Min Unit") return true; end
        end
    end
    --actions.aoe_setup+=/festering_strike,target_if=max:debuff.festering_wound.stack,if=cooldown.apocalypse.remains<variable.apoc_timing
    --&debuff.festering_wound.stack<4
    if cd.apocalypse.remains() < var.apoc_timing and debuff.festeringWound.stack(var.minFesteringWounds) < 4 then
        if cast.able.festeringStrike(var.minFesteringWounds) then
            if cast.festeringStrike(var.minFesteringWounds) then ui.debug("AOESetup. Festing wounds on min Unit") return true; end
        end
    end
    --actions.aoe_setup+=/death_coil,if=!variable.pooling_runic_power&!talent.epidemic
    if not var.pooling_runic_power and not talent.epidemic then
        if cast.able.deathCoil("target") then
            if cast.deathCoil("target") then ui.debug("AOESetup: Death Coil") return true; end
        end
    end
end


----------------
--- ROTATION ---
----------------


local function runRotation() -- This is the main profile loop, any below this point is ran every cycle, everything above is ran only once during initialization.
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals - These are the same as the locals above just defined for use.
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    enemies                                       = br.player.enemies
    module                                        = br.player.module
    power                                         = br.player.power
    talent                                        = br.player.talent
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    var                                           = br.player.variables
    debuff                                        = br.player.debuff
    runes                                         = br.player.power.runes()
    runicPower                                    = br.player.power.runicPower()
    pet                                           = br.player.pet
    runicPowerMax                                 = UnitPowerMax("player",6)
    var.inRaid                                    = br.player.instance=="raid"
    var.inParty                                   = br.player.instance=="party"
    var.healPot                                   =
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(8)
    enemies.get(10)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40) -- Makes a varaible called, enemies.yards40
    enemies.get(5,"player",false,true) -- makes enemies.yards5f
    enemies.get(10,"player",false, true)
    enemies.get(20,"player",false,true)
    enemies.get(30,"player",false,true)
    enemies.get(40,"player",false,true)

     var.runicPowerDeficit = runicPowerMax - runicPower
     var.deathStrikeDumpAmount = 65

    var.minTTD=99999
    var.minTTDUnit="target"
    var.maxTTD = unit.ttd("target")
    var.maxTTDUnit = "target"
    for i=1,#enemies.yards8 do
        local thisUnit=enemies.yards8[i]
        local thisCondition=unit.ttd(thisUnit)
        if not unit.isBoss(thisUnit) and thisCondition<var.minTTD then
            var.minTTD=thisCondition
            var.minTTDUnit=thisUnit
        end
        if not unit.isBoss(thisUnit) and thisCondition > var.maxTTD then
            var.maxTTD=thisCondition
            var.maxTTDUnit=thisUnit
        end
    end

    var.maxFesteringWoundsGain=0
    var.maxFesteringWounds = "target"
    for i=1,#enemies.yards8 do
        local thisUnit = enemies.yards8[i]
        local thisCondition = debuff.festeringWound.stack(thisUnit)
        if thisCondition > var.maxFesteringWoundsGain then
            var.maxFesteringWoundsGain = thisCondition
            var.maxFesteringWounds = thisUnit
        end
    end

    var.minFesteringWoundsGain = 0
    var.minFesteringWounds = "target"
    for i=1,#enemies.yards8 do
        local thisUnit = enemies.yards8[i]
        local thisCondition = debuff.festeringWound.stack(thisUnit)
        if thisCondition < var.minFesteringWoundsGain then
            var.minFesteringWoundsGain = thisCondition
            var.minFesteringWounds = thisUnit
        end
    end

    var.fwounded_targets = 0
    for i=1,#enemies.yards8 do
        local thisUnit = enemies.yards8[i]
        if debuff.festeringWound.exists(thisUnit) then
            var.fwounded_targets = var.fwounded_targets + 1
        end
    end

    --determine if dungeonBoss is in part of active enemies
    var.InstanceBossIsActive = false
    for i=1,#enemies.yards8 do
        local thisUnit= enemies.yards8[i]
        if unit.isBoss(thisUnit) then var.InstanceBossIsActive = true end
    end



   var.hasGargoyle = false;
   var.GargoyleTTL = 0;
    for i = 1, 5 do
        local present,name,start,duration,icon = GetTotemInfo(i)
        if present and name=="Ebon Gargoyle" then
            var.hasGargoyle = present
            var.GargoyleTTL = start + duration - ui.time() + 1.2
        end
    end



    --rune cooldown timing, build table of rune cooldowns so we know exactly how long until we get X # of runes
    var.runeCount = 0
    var.runeCountCoolDown = 0
    var.runeCooldowns = {}
    for i=1,6 do
        local rStart, rDuration, rRuneReady = _G.GetRuneCooldown(i)
        if rRuneReady then
            var.runeCount = var.runeCount + 1
        else
            var.runeCountCoolDown = var.runeCountCoolDown + 1
            table.insert(var.runeCooldowns,(rStart + rDuration) - ui.time())
        end
    end
    table.sort(var.runeCooldowns)

    --Simulation Craft Variables

    --actions.variables=variable,name=epidemic_priority,op=setif,value=1,value_else=0,
    --condition=talent.improved_death_coil&!talent.coil_of_devastation&active_enemies>=3|talent.coil_of_devastation&active_enemies>=4|
    --!talent.improved_death_coil&active_enemies>=2
    if (
        talent.improvedDeathCoil and not talent.coilOfDevastation and #enemies.yards5 >=3 or
        talent.coilOfDevastation and #enemies.yards5f >= 4 or
        not talent.improvedDeathCoil and #enemies.yards5f >= 2
    ) then
        var.epidemic_priority=true
    else
        var.epidemic_priority=false
    end

    --actions.variables+=/variable,name=garg_setup_complete,op=setif,value=1,value_else=0,condition=
    --active_enemies>=3|cooldown.summon_gargoyle.remains>1&(cooldown.apocalypse.remains>1|!talent.apocalypse)|!talent.summon_gargoyle|time>20
    if (
        #enemies.yards5 >= 3 or cd.summonGargoyle.remains() > 1 and (cd.apocalypse.remains() > 1 or not talent.apocalypse) or
        not talent.summonGargoyle or unit.combatTime() > 20
    ) then
        var.garg_setup_complete=true
    else
        var.garg_setup_complete=false
    end

    --actions.variables+=/variable,name=apoc_timing,op=setif,value=7,value_else=2,condition=
    --cooldown.apocalypse.remains<10&debuff.festering_wound.stack<=4&cooldown.unholy_assault.remains>10
    if (
        cd.apocalypse.remains() < 10 and debuff.festeringWound.stack("target") <= 4 and cd.unholyAssault.remains() > 10
    ) then
        var.apoc_timing=7
    else
        var.apoc_timing=2
    end

    --actions.variables+=/variable,name=festermight_tracker,op=setif,value=debuff.festering_wound.stack>=1,
    --value_else=debuff.festering_wound.stack>=(3-talent.infected_claws),condition=
    --!pet.gargoyle.active&talent.festermight&buff.festermight.up&(buff.festermight.remains%(5*gcd.max))>=1
    var.festermight_tracker = debuff.festeringWound.stack("target") >= 1
    if not var.hasGargoyle and talent.festermight and buff.festermight.exists() and (buff.festermight.remains()%(5*unit.gcd(false))>=1) then
        var.festermight_tracker = debuff.festeringWound.stack("target") >=(3-boolNumeric(talent.infectedClaws))
    end

    --actions.variables+=/variable,name=st_planning,op=setif,value=1,value_else=0,condition=active_enemies=1&(!raid_event.adds.exists|raid_event.adds.in>15)
    if (#enemies.yards8==1 and ( (var.inRaid or var.inParty))) then
        var.st_planning = true
    else
        var.st_planning = false
    end

    --actions.variables+=/variable,name=pop_wounds,op=setif,value=1,
    --value_else=0,
    --condition=(cooldown.apocalypse.remains>variable.apoc_timing|!talent.apocalypse)&
    --(variable.festermight_tracker|debuff.festering_wound.stack>=1&cooldown.unholy_assault.remains<20&talent.unholy_assault&variable.st_planning-
    --|debuff.rotten_touch.up&debuff.festering_wound.stack>=1|debuff.festering_wound.stack>4|set_bonus.tier31_4pc&
    --(pet.apoc_magus.active|pet.army_magus.active)&
    --debuff.festering_wound.stack>=1)|fight_remains<5&debuff.festering_wound.stack>=1

    if (cd.apocalypse.remains() > var.apoc_timing or not talent.apocalypse)  and
        (var.festermight_tracker or debuff.festeringWound.stack("target") >=1 and
        cd.unholyAssault.remains()<20 and talent.unholyAssault and var.st_planning or
        debuff.rottenTouch.exists("target") and debuff.festeringWound.stack("target") >=1) or unit.ttdGroup(40)<5 or debuff.festeringWound.stack("target")>4
    then
        var.pop_wounds = true
    else
        var.pop_wounds = false
    end

    --actions.variables+=/variable,name=pooling_runic_power,op=setif,value=1,value_else=0,
    --condition=talent.vile_contagion&cooldown.vile_contagion.remains<3&runic_power<60&!variable.st_planning

    if(talent.vileContagion and cd.vileContagion.remains() <3 and runicPower < 60 and not var.st_planning) then
        var.pooling_runic_power = true
    else
        var.pooling_runic_power = false
    end

    --actions.variables+=/variable,name=adds_remain,op=setif,value=1,value_else=0,condition=active_enemies>=2&(!raid_event.adds.exists|raid_event.adds.exists&raid_event.adds.remains>6)
    --TODO figure out how to get encounter adds from BW/DBM
    var.adds_remain=1

    --actions.variables+=/variable,name=spend_rp,op=setif,value=1,value_else=0,
    --condition=(!talent.rotten_touch|talent.rotten_touch&!debuff.rotten_touch.up|runic_power.deficit<20)&
    --TODO set bonuses
    --(!set_bonus.tier31_4pc|set_bonus.tier31_4pc&!(pet.apoc_magus.active|pet.army_magus.active)|runic_power.deficit<20|rune<3)&
    --((talent.improved_death_coil&(active_enemies=2|talent.coil_of_devastation)|rune<3|pet.gargoyle.active|buff.sudden_doom.react|cooldown.apocalypse.remains<10
    --&debuff.festering_wound.stack>3|!variable.pop_wounds&debuff.festering_wound.stack>=4))

    if (not talent.rottenTouch or (talent.rottenTouch and not debuff.rottenTouch.exists("target") and var.runicPowerDeficit<20)) and
    ((talent.improvedDeathCoil and (#enemies.yards5==2 or talent.coilOfDevastation)) or
    runes<3 or var.hasGargoyle or cd.apocalypse.remains() <10) and
    (debuff.festeringWound.stack("target")>3 or (var.pop_wounds==0 and debuff.festeringWound.stack("target")>=4))
     then
        var.spend_rp = true
     else
        var.spend_rp = false
    end





    -- Any other local varaible from above would also need to be defined here to be use.
    if var.profileStop == nil then var.profileStop = false end -- Trigger variable to help when needing to stop a profile.

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then -- Reset profile stop once stopped
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then -- If profile triggered to stop go here until it has.
        return true
    else -- Profile is free to perform actions
        --------------
        --- Extras ---
        --------------
        if actionList.Extra() then return true end
        if actionList.Defensive() then return true end
        if actionList.PreCombat() then return true end
         if unit.inCombat() and unit.valid("target") and not var.profileStop then

            if actionList.Interrupt() then return true end
            if ((var.inParty or var.inRaid) and unit.isBoss("target") and ui.checked(text.options.onlyUseGargAODonBoss)) or
                not ui.checked(text.options.onlyUseGargAODonBoss) or unit.isDummy("target") then
                if actionList.HighPrioActions() then return true end
                if not var.garg_setup_complete then
                    if actionList.GargSetup() then return true end
                end
            end

            if var.st_planning then
                if actionList.Cooldown() then return true end
            end

            --AOE Rotatation
            if #enemies.yards8 >= ui.value(text.aoe.aoeCount) then
                if cd.deathAndDecay.remains() < 10 and not buff.deathAndDecay.exists() then
                    if actionList.AOESetup() then return true end
                end
                if #enemies.yards5f >= ui.value(text.aoe.aoeCount) and buff.deathAndDecay.exists() then
                    if actionList.AOEBurst() then return true end
                end
                if #enemies.yards5f >= ui.value(text.aoe.aoeCount) and (cd.deathAndDecay.remains() >10 and not buff.deathAndDecay.exists()) then
                    if actionList.AOE() then return true end
                end
            else
                if actionList.St() then return true end
            end
            if cast.able.autoAttack("target") and unit.distance("target") <= 5 then
                if cast.autoAttack("target") then ui.debug("EOR: Auto Attack") return true end
            end

        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 252
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
tinsert(br.loader.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})