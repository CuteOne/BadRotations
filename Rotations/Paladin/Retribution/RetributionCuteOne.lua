local rotationName = "CuteOne"
local br = _G["br"]
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.divineStorm },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.divineStorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.crusaderStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.flashOfLight }
    }
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.avengingWrath },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.avengingWrath },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avengingWrath }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.flashOfLight },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.flashOfLight }
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.hammerOfJustice },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.hammerOfJustice }
    };
    CreateButton("Interrupt",4,0)
    -- Hold Wake
    WakeModes = {
        [1] = { mode = "On", value = 1 , overlay = "Use wake", tip = "Use wake", highlight = 1, icon = br.player.spell.wakeOfAshes},
        [2] = { mode = "Off", value = 2 , overlay = "Don't use wake", tip = "Don't use wake", highlight = 0, icon = br.player.spell.wakeOfAshes}
    };
    CreateButton("Wake",5,0)
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
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Opener
            br.ui:createCheckbox(section, "Opener")
            -- Greater Blessing of Might
            -- br.ui:createCheckbox(section, "Greater Blessing of Might
            -- Greater Blessing of Kings
            br.ui:createCheckbox(section, "Greater Blessing of Kings")
            -- Greater Blessing of Wisdom
            br.ui:createCheckbox(section, "Greater Blessing of Wisdom")
            -- Blessing of Freedom
            br.ui:createCheckbox(section, "Blessing of Freedom")
            -- Hand of Hinderance
            br.ui:createCheckbox(section, "Hand of Hinderance")
            -- Divine Storm Units
            br.ui:createSpinnerWithout(section, "Divine Storm Units",  2,  2,  3,  1,  "|cffFFBB00Units to use Divine Storm.")
            -- Heart Essence
            br.ui:createCheckbox(section, "Use Essence")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- FlaskUp Module
            br.player.module.FlaskUp("Strength",section)
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.player.module.BasicTrinkets(nil,section)
            -- Avenging Wrath
            br.ui:createCheckbox(section,"Avenging Wrath")
            -- Cruusade
            br.ui:createCheckbox(section,"Crusade")
            -- Holy Wrath
            br.ui:createCheckbox(section,"Holy Wrath")
            -- Shield of Vengeance
            br.ui:createCheckbox(section,"Shield of Vengeance - CD")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Blessing of Protection
            br.ui:createSpinner(section, "Blessing of Protection",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Cleanse Toxin
            br.ui:createDropdown(section, "Clease Toxin", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|cffFFFFFFTarget to Cast On")
            -- Divine Shield
            br.ui:createSpinner(section, "Divine Shield",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Eye for an Eye
            br.ui:createSpinner(section, "Eye for an Eye", 50, 0 , 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Shield of Vengeance
            br.ui:createSpinner(section,"Shield of Vengeance", 90, 0 , 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Flash of Light
            br.ui:createSpinner(section, "Flash of Light",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Hammer of Justice
            br.ui:createSpinner(section, "Hammer of Justice - HP",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            br.ui:createCheckbox(section, "Hammer of Justice - Legendary")
            -- Justicar's Vengeance
            br.ui:createSpinner(section, "Justicar's Vengeance",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at over Templar's Verdict.")
            -- Lay On Hands
            br.ui:createSpinner(section, "Lay On Hands", 20, 0, 100, 5, "","Health Percentage to use at")
            br.ui:createDropdownWithout(section, "Lay on Hands Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 8, "|cffFFFFFFTarget for Lay On Hands")
            -- Redemption
            br.ui:createDropdown(section, "Redemption", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|cffFFFFFFTarget to Cast On")
            -- Word of Glory
            br.ui:createSpinner(section, "Word of Glory", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Auto-Heal
            br.ui:createDropdownWithout(section, "Auto Heal", { "|cffFFDD11LowestHP", "|cffFFDD11Player"},  1,  "|cffFFFFFFSelect Target to Auto-Heal")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Hammer of Justice
            br.ui:createCheckbox(section, "Hammer of Justice")
            -- Rebuke
            br.ui:createCheckbox(section, "Rebuke")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Wake of Ashes Key Toggle
            br.ui:createDropdownWithout(section, "Wake Mode", br.dropOptions.Toggle, 6)
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
-- BR API
local buff
local cast
local cd
local charges
local debuff
local enemies
local holyPower
local module
local race
local talent
local ui
local unit
local units
local var

------------------------
--- Custom Functions ---
------------------------
local canGlory = function()
    local optionValue = ui.value("Word of Glory")
    local otherCounter = 0
    if charges.wordOfGlory.count() > 0 then
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            local thisHP = unit.hp(thisUnit)
            if thisHP < optionValue then
                -- Emergency Single
                if thisHP < 25 then
                    var.thisGlory = thisUnit
                    return true
                end
                -- Group Heal
                if otherCounter < 2 then
                    for j = 1, #br.friend do
                        local otherUnit = br.friend[j].unit
                        local otherHP = unit.hp(otherUnit)
                        local distanceFromYou = unit.distance(otherUnit,"player")
                        if distanceFromYou < 30 and otherHP < optionValue then
                            otherCounter = otherCounter + 1
                        end
                    end
                else
                    var.thisGlory = thisUnit
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
local actionList = {}
-- Action List - Extras
actionList.Extras = function()
    -- Blessing of Freedom
    if ui.checked("Blessing of Freedom") and cast.able.blessingOfFreedom() and cast.noControl.blessingOfFreedom() then
        if cast.blessingOfFreedom() then ui.debug("Casting Blessing of Freedom") return true end
    end
    -- Hand of Hinderance
    if ui.checked("Hand of Hinderance") and cast.able.handOfHinderance("target") and unit.moving("target")
        and not unit.facing("target","player") and unit.distance("target") > 8 and unit.hp("target") < 25
    then
        if cast.handOfHinderance("target") then ui.debug("Casting Hand of Hinderance on "..unit.name("target")) return true end
    end
    -- Greater Blessing of Might
    -- if ui.checked("Greater Blessing of Might") and greaterBuff < 3 then
    --     for i = 1, #br.friend do
    --         local thisUnit = br.friend[i].unit
    --         local unitRole = UnitGroupRolesAssigned(thisUnit)
    --         if UnitBuffID(thisUnit,spell.buffs.greaterBlessingOfMight) == nil and (unitRole == "DAMAGER" or solo) then
    --             if cast.greaterBlessingOfMight(thisUnit) then return end
    --         end
    --     end
    -- end
    -- -- Greater Blessing of Kings
    -- if ui.checked("Greater Blessing of Kings") and cast.able.greaterBlessingOfKings(kingsUnit)
    --     and buff.greaterBlessingOfKings.remain(kingsUnit) < 600 and not var.mounted()
    -- then
    --     if cast.greaterBlessingOfKings(kingsUnit) then ui.debug("Casting Greater Blessing of Kings on "..unit.name(kingsUnit)) return true end
    -- end
    -- -- Greater Blessing of Wisdom
    -- if ui.checked("Greater Blessing of Wisdom") and cast.able.greaterBlessingOfWisdom(wisdomUnit)
    --     and buff.greaterBlessingOfWisdom.remain(wisdomUnit) < 600 and not var.mounted()
    -- then
    --     if cast.greaterBlessingOfWisdom(wisdomUnit) then ui.debug("Casting Greater Blessing of Wisdom on "..unit.name(wisdomUnit)) return true end
    -- end
end -- End Action List - Extras
-- Action List - Defensives
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Lay On Hands
        if ui.checked("Lay On Hands") and unit.inCombat() then
            local lohTar = ui.value("Lay on Hands Target")
            local lohUnit
            if lohTar == 1 then lohUnit = "player" end
            if lohTar == 2 then lohUnit = "target" end
            if lohTar == 3 then lohUnit = "mouseover" end
            if lohTar >= 4 then lohUnit = var.lowestUnit end
            if cast.able.layOnHands(lohUnit) and unit.hp(lohUnit) <= ui.value("Lay On Hands") then
                if cast.layOnHands(lohUnit) then
                    ui.debug("Casting Lay On Hands on "..unit.name(lohUnit).." ["..unit.hp(lohUnit).."% Remaining]")
                    return true
                end
            end
        end
        -- Divine Shield
        if ui.checked("Divine Shield") and cast.able.divineShield() then
            if unit.hp() <= ui.value("Divine Shield") and unit.inCombat() then
                if cast.divineShield() then ui.debug("Casting Divine Shield") return true end
            end
        end
        -- Basic Healing Module
        module.BasicHealing()
        -- Blessing of Protection
        if ui.checked("Blessing of Protection") and cast.able.blessingOfProtection(var.lowestUnit) then
            if unit.hp(var.lowestUnit) < ui.value("Blessing of Protection") and unit.inCombat() then
                if cast.blessingOfProtection(var.lowestUnit) then
                    ui.debug("Casting Blessing of Protection on "..unit.name(var.lowestUnit).." ["..unit.hp(var.lowestUnit).."% Remaining]")
                    return true
                end
            end
        end
        -- Cleanse Toxins
        if ui.checked("Cleanse Toxins") then
            local cleanseTar = ui.value("Cleanse Toxins")
            local cleanseUnit
            if cleanseTar == 1 then cleanseUnit = "player" end
            if cleanseTar == 2 then cleanseUnit = "target" end
            if cleanseTar == 3 then cleanseUnit = "mouseover" end
            if cast.able.clenseToxins(cleanseUnit) and cast.dispel.cleanseToxins(cleanseUnit) then
                if cast.cleanseToxins(cleanseUnit) then ui.debug("Casting Cleanse Toxins on "..unit.name(cleanseUnit)) return true end
            end
        end
        -- Eye for an Eye
        if ui.checked("Eye for an Eye") and cast.able.eyeForAnEye() then
            if unit.hp() <= ui.value("Eye for an Eye") and unit.inCombat() then
                if cast.eyeForAnEye() then ui.debug("Casting Eye For An Eye") return true end
            end
        end
        -- Shield of Vengeance
        if ui.checked("Shield of Vengeance") and cast.able.shieldOfVengeance() then
            if unit.hp() <= ui.value("Shield of Vengeance") and unit.inCombat() then
                if cast.shieldOfVengeance() then ui.debug("Casting Shield of Vengeance") return true end
            end
        end
        -- Hammer of Justice
        if ui.checked("Hammer of Justice - HP") and cast.able.hammerOfJustice() and unit.inCombat() then
            if unit.hp() <= ui.value("Hammer of Justice - HP") then
                if cast.hammerOfJustice() then ui.debug("Casting Hammer of Justice [Defensive]") return true end
            end
        end
        -- Justicar's Vengeance
        if ui.checked("Justicar's Vengeance") and cast.able.justicarsVengeance() and holyPower >= 5 then
            if unit.hp() <= ui.value("Justicar's Vengeance") then
                if cast.justicarsVengeance() then ui.debug("Casting Justicar's Vengeance") return true end
            end
        end
        -- Redemption
        if ui.checked("Redemption") and not unit.moving("player") and var.resable then
            local redemptionTar = ui.value("Redemption")
            local redemptionUnit
            if redemptionTar == 1 then redemptionUnit = "target" end
            if redemptionTar == 2 then redemptionUnit = "mouseover" end
            if cast.able.redemption(redemptionUnit,"dead") then
                if cast.redemption(redemptionUnit,"dead") then ui.debug("Casting Redemption on "..unit.name(redemptionUnit)) return true end
            end
        end
        -- Word of Glory
        if ui.checked("Word of Glory") and talent.wordOfGlory and cast.able.wordOfGlory() and canGlory() then
            if cast.wordOfGlory(var.thisGlory) then ui.debug("Casting Word of Glory on "..unit.name(var.thisGlory)) return true end
        end
        -- Flash of Light
        if ui.checked("Flash of Light") and cast.able.flashOfLight() and not (unit.mounted() or unit.flying())
            and (ui.value("Auto Heal") ~= 1 or (ui.value("Auto Heal") == 1
            and unit.distance(br.friend[1].unit) < 40))
        then
            local folHP = unit.hp()
            local folUnit = "player"
            local lowUnit = unit.lowest(40)
            local fhp = unit.hp(lowUnit)
            local folValue = ui.value("Flash of Light")
            if ui.value("Auto Heal") == 1 then folHP = fhp; folUnit = lowUnit end
            -- Instant Cast
            if talent.selflessHealer and folHP <= folValue and buff.selflessHealer.stack() == 4 then
                if cast.flashOfLight(folUnit) then ui.debug("Casting Flash of Light on "..unit.name(folUnit).." [Instant]") return true end
            end
            -- Long Cast
            folHP = unit.hp(br.friend[1].unit)
            if not unit.moving("player") and (var.forceHeal or (unit.inCombat() and folHP <= folValue / 2) or (not unit.inCombat() and folHP <= folValue)) then
                if cast.flashOfLight(folUnit) then ui.debug("Casting Flash of Light on "..unit.name(folUnit).." [Long]") return true end
            end
        end
    end
end -- End Action List - Defensive
-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards10 do
            local thisUnit = enemies.yards10[i]
            local distance = unit.distance(thisUnit)
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                -- Hammer of Justice
                if ui.checked("Hammer of Justice") and cast.able.hammerOfJustice(thisUnit) and distance < 10 and (not cast.able.rebuke() or distance >= 5) then
                    if cast.hammerOfJustice(thisUnit) then ui.debug("Casting Hammer of Justice [Interrupt]") return true end
                end
                -- Rebuke
                if ui.checked("Rebuke") and cast.able.rebuke(thisUnit) and distance < 5 then
                    if cast.rebuke(thisUnit) then ui.debug("Casting Rebuke") return true end
                end
            end
        end
    end
end -- End Action List - Interrupts
-- Action List - Cooldowns
actionList.Cooldowns = function()
    if (ui.useCDs() or var.burst) and unit.distance(units.dyn5) < 5 then
        -- -- Potion
        -- -- potion,if=(cooldown.guardian_of_azeroth.remains>90|!essence.condensed_lifeforce.major)&(buff.bloodlust.react|buff.avenging_wrath.up&buff.avenging_wrath.remains>18|buff.crusade.up&buff.crusade.remains<25)
        -- if ui.checked("Potion") and use.able.potionOfFocusedResolve() and unit.instance("raid") then
        --     if (cd.guardianOfAzeroth.remain() > 90 or not essence.condensedLifeForce.active)
        --         and (hasBloodlust() or (buff.avengingWrath.exists() and buff.avengingWrath.remain() > 18)
        --             or (buff.crusade.exists() and buff.crusade.remain() < 25))
        --     then
        --         use.potionOfFocusedResolve()
        --         ui.debug("Used Potion of Focused Resolve")
        --     end
        -- end
        -- Racial
        if ui.checked("Racial") and cast.able.racial() then
            -- lights_judgment,if=spell_targets.lights_judgment>=2|(!raid_event.adds.exists|raid_event.adds.in>75)
            if race == "LightforgedDraenei" and ui.useAOE() then
                if cast.racial() then ui.debug("Casting Racial: Lightforged Draenei") return true end
            end
            -- fireblood,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10
            if race == "DarkIronDwarf" and (buff.avengingWrath.exists() or (buff.crusade.exists() and buff.crusade.stack() == 10)
            or (talent.crusade and not ui.checked("Crusade")))
            then
                if cast.racial() then ui.debug("Casting Racial: Dark Iron Dwarf") return true end
            end
        end
        -- Shield of Vengenace
        -- shield_of_vengeance
        if ui.checked("Shield of Vengeance - CD") and cast.able.shieldOfVengeance() then
            if cast.shieldOfVengeance() then ui.debug("Casting Shield of Vengeance [CD]") return true end
        end
        -- Trinkets
        module.BasicTrinkets()
        -- -- use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.down|(buff.avenging_wrath.remains>=20|buff.crusade.stack=10&buff.crusade.remains>15)&(cooldown.guardian_of_azeroth.remains>90|target.time_to_die<30|!essence.condensed_lifeforce.major)                
        -- if ui.checked("Trinkets") and equiped.ashvanesRazorCoral() and (not debuff.razorCoral.exists(units.dyn5)
        --     or ((not talent.crusade and (not useCDs() or not ui.checked("Avenging Wrath") or buff.avengingWrath.remain() >= 20))
        --         or (talent.crusade and (not useCDs() or not ui.checked("Crusade") or (buff.crusade.stack() == 10 and buff.crusade.remain() > 15))))
        --     and (cd.guardianOfAzeroth.remain() > 90 or ttd(units.dyn5) < 30 or not essence.condensedLifeForce.active))
        -- then
        --     for i = 13, 14 do
        --         if use.able.slot(i) and equiped.ashvanesRazorCoral(i) then
        --             use.slot(i)
        --             ui.debug("Using Ashvanes Razor Coral on Slot "..i)
        --         end
        --     end
        -- end        
        -- Avenging Wrath
        -- avenging_wrath,if=(holy_power>=4&time<5|holy_power>=3&time>5|talent.holy_avenger.enabled&cooldown.holy_avenger.remains=0)&time_to_hpg=0
        if ui.checked("Avenging Wrath") and not talent.crusade and cast.able.avengingWrath()
            and (holyPower >= 4 and unit.combatTime() < 5 or holyPower >= 3 and unit.combatTime() > 5 or talent.holyAvenger and not cd.holyAvenger.exists())
            and var.timeToHPG == 0
        then
            if cast.avengingWrath() then ui.debug("Casting Avenging Wrath") return true end
        end
        -- Crusade
        -- crusade,if=(holy_power>=4&time<5|holy_power>=3&time>5|talent.holy_avenger.enabled&cooldown.holy_avenger.remains=0)&time_to_hpg=0
        if ui.checked("Crusade") and talent.crusade and cast.able.crusade()
            and (holyPower >= 4 and unit.combatTime() < 5 or holyPower >= 3 and unit.combatTime() > 5 or talent.holyAvenger and not cd.holyAvenger.exists())
            and var.timeToHPG == 0
        then
            if cast.crusade() then ui.debug("Casting Crusade") return true end
        end
        -- Ashen Hallow 
        -- ashen_hallow
        -- Holy Avenger
        -- holy_avenger,if=time_to_hpg=0&((buff.avenging_wrath.up|buff.crusade.up)|(buff.avenging_wrath.down&cooldown.avenging_wrath.remains>40|buff.crusade.down&cooldown.crusade.remains>40))
        if ui.checked("Holy Avenger") and var.timeToHPG == 0
            and ((buff.avengingWrath.exists() or buff.crusade.exists())
                or (not buff.avengingWrath.exists() and cd.avengingWrath.remains() > 40
                    or not buff.crusade.exists() and buff.crusade.remains() > 40))
        then
            if cast.holyAvenger() then ui.debug("Casting Holy Avenger") return true end
        end
        -- Final Reckoning
        -- final_reckoning,if=holy_power>=3&cooldown.avenging_wrath.remains>gcd&time_to_hpg=0&(!talent.seraphim.enabled|buff.seraphim.up)
        if ui.checked("Final Reckoning") and holyPower >= 3 and cd.avengingWrath.remains() > unit.gcd(true) and var.timeToHPG == 0 and (not talent.seraphim or buff.seraphim.exists()) then
            if cast.finalReckoning() then ui.debug("Casting Final Reckoning") return true end
        end
        -- Heart Essence
        if ui.checked("Use Essence") then
            -- Essence: The Unbound Force
            -- the_unbound_force,if=time<=2|buff.reckless_force.up
            if cast.able.theUnboundForce() and (unit.combatTime() <= 2 or buff.recklessForce.exists()) then
                if cast.theUnboundForce() then ui.debug("Casting Heart Essence: The Unbound Force") return true end
            end
            -- Essence: Blood of the Enemy
            -- blood_of_the_enemy,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10
            if cast.able.bloodOfTheEnemy()
                and ((not talent.crusade and buff.avengingWrath.exists())
                or (talent.crusade and buff.crusade.exists() and buff.crusade.stack() == 10))
            then
                if cast.bloodOfTheEnemy() then ui.debug("Casting Heart Essence: Blood of the Enemy") return true end
            end
            -- Essence: Guardian of Azeroth
            -- guardian_of_azeroth,if=!talent.crusade.enabled&(cooldown.avenging_wrath.remains<5&holy_power>=3|cooldown.avenging_wrath.remains>=45)|(talent.crusade.enabled&cooldown.crusade.remains<gcd&holy_power>=4|cooldown.crusade.remains>=45)
            if cast.able.guardianOfAzeroth()
                and ((not talent.crusade and (cd.avengingWrath.remain() < 5 and holyPower >= 3 or cd.avengingWrath.remain() >= 45))
                    or (talent.crusade and cd.crusade.remain() < unit.gcd(true)and holyPower >= 4 or cd.crusade.remain() >= 45))
            then
                if cast.guardianOfAzeroth() then ui.debug("Casting Heart Essence: Guardian of Azeroth") return true end
            end
            -- Essence: Worldvein Resonance
            -- worldvein_resonance,if=cooldown.avenging_wrath.remains<gcd&holy_power>=3|talent.crusade.enabled&cooldown.crusade.remains<gcd&holy_power>=4|cooldown.avenging_wrath.remains>=45|cooldown.crusade.remains>=45
            if cast.able.worldveinResonance()
                and ((not talent.crusade and cd.avengingWrath.remain() < unit.gcd(true)and holyPower >= 3)
                    or (talent.crusade and cd.crusade.remain() < unit.gcd(true)and holyPower >= 4)
                    or (not talent.crusade and cd.avengingWrath.remain() >= 45) 
                    or (talent.crusade and cd.crusade.remain() >= 45))
            then
                if cast.worldveinResonance() then ui.debug("Casting Heart Essence: Worldvein Resonance") return true end
            end
            -- Essence: Focused Azerite Beam
            -- focused_azerite_beam,if=(!raid_event.adds.exists|raid_event.adds.in>30|spell_targets.divine_storm>=2)&!(buff.avenging_wrath.up|buff.crusade.up)&(cooldown.blade_of_justice.remains>gcd*3&cooldown.judgment.remains>gcd*3)
            if cast.able.focusedAzeriteBeam() and not (buff.avengingWrath.exists() or buff.crusade.exists())
                and (cd.bladeOfJustice.remain() > unit.gcd(true)* 3 and cd.judgment.remain() > unit.gcd(true)* 3)
                and (#enemies.yards8f >= 3 or ui.useCDs()) and not unit.moving()
            then
                local minCount = ui.useCDs() and 1 or 3
                if cast.focusedAzeriteBeam(nil,"cone",minCount, 8) then ui.debug("Casting Heart Essence: Focused Azerite Beam") return true end
            end
            -- Essence: Memory of Lucid Dreams
            -- memory_of_lucid_dreams,if=(buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10)&holy_power<=3
            if cast.able.memoryOfLucidDreams()
                and ((not talent.crusade and buff.avengingWrath.exists())
                     or (talent.crusade and buff.crusade.exists() and buff.crusade.stack() == 10))
                and holyPower <= 3
            then
                if cast.memoryOfLucidDreams() then ui.debug("Casting Heart Essence: Memory of Lucid Dreams") return true end
            end
            -- Essence: Purifying Blast
            -- purifying_blast,if=(!raid_event.adds.exists|raid_event.adds.in>30|spell_targets.divine_storm>=2)
            if cast.able.purifyingBlast() then
                if cast.purifyingBlast("best", nil, 1, 8) then ui.debug("Casting Heart Essence: Purifying Blast") return true end
            end
        end
    end -- End Cooldown Usage Check
end -- End Action List - Cooldowns
-- Action List - Finisher
actionList.Finisher = function()
    -- Seraphim
    -- seraphim,if=((!talent.crusade.enabled&buff.avenging_wrath.up|cooldown.avenging_wrath.remains>25)|(buff.crusade.up|cooldown.crusade.remains>25))&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains<10)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains<10)&time_to_hpg=0
    if cast.able.seraphim()
        and ((not talent.crusade and buff.avengingWrath.exists() or cd.avengingWrath.remains() > 25)
            or (buff.crusade.exists() and cd.crusade.remains() > 25))
        and (not talent.finalReckoning or cd.finalReckoning.remains() < 10)
        and (not talent.executionSentence or cd.executionSentence.remains() < 10)
        and var.timeToHPG == 0
    then
        if cast.serphim() then ui.debug("Casting Seraphim") return true end
    end
    -- Vanquisher's Hammer
    -- vanquishers_hammer,if=(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*10|debuff.final_reckoning.up)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*10|debuff.execution_sentence.up)|spell_targets.divine_storm>=2
    -- Execution Sentence
    -- execution_sentence,if=spell_targets.divine_storm<=3&((!talent.crusade.enabled|buff.crusade.down&cooldown.crusade.remains>10)|buff.crusade.stack>=3|cooldown.avenging_wrath.remains>10|debuff.final_reckoning.up)&time_to_hpg=0
    if cast.able.executionSentence()
        and (var.dsUnits or unit.level() < 23) and ((not talent.crusade or not buff.crusade.exists() and cd.crusade.remain() > 10)
            or buff.crusade.stack() >= 3 or cd.avengingWrath.remain() > 10 or not ui.checked("Avenging Wrath") or debuff.finalReckoning.exists(units.dyn5))
        and var.timeToHPG == 0
    then
        if cast.executionSentence() then ui.debug("Casting Execution Sentence") return true end
    end
    -- Divine Storm
    -- divine_storm,if=variable.ds_castable&!buff.vanquishers_hammer.up&((!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*3|spell_targets.divine_storm>=3)|spell_targets.divine_storm>=2&(talent.holy_avenger.enabled&cooldown.holy_avenger.remains<gcd*3|buff.crusade.up&buff.crusade.stack<10))
    if cast.able.divineStorm() and var.dsCastable and (((not talent.crusade or cd.crusade.remains() > unit.gcd(true) * 3 or not ui.checked("Crusade"))
        and (not talent.executionSentence or cd.executionSentance.remains() > unit.gcd(true) * 3 or var.dsUnits) or var.dsUnits
        and (talent.holyAvenger and cd.hoylAvenger.remains() < unit.gcd(true) * 3 or buff.crusade.exists() and buff.crusade.stack() < 10))
            or not ui.useCDs())
    then
        local theseUnits = ui.mode.roation == 2 and 1 or ui.value("Divine Storm Units")
        if cast.divineStorm("player","aoe",theseUnits,8) then ui.debug("Casting Divine Storm") return true end
    end
    -- Templar's Verdict
    -- templars_verdict,if=variable.wings_pool&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*2|cooldown.avenging_wrath.remains>gcd*3&cooldown.avenging_wrath.remains<10|cooldown.crusade.remains>gcd*3&cooldown.crusade.remains<10|buff.crusade.up&buff.crusade.stack<10)
    -- templars_verdict,if=(!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*3&spell_targets.divine_storm<=3)&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*3)&(!covenant.necrolord.enabled|cooldown.vanquishers_hammer.remains>gcd)|talent.holy_avenger.enabled&cooldown.holy_avenger.remains<gcd*3|buff.holy_avenger.up|buff.crusade.up&buff.crusade.stack<10|buff.vanquishers_hammer.up
    if cast.able.templarsVerdict() and ((ui.mode.rotation == 1 and #enemies.yards8 < ui.value("Divine Storm Units"))
        or (ui.mode.rotation == 3 and #enemies.yards5 > 0) or unit.level() < 40)
    then
        if ((not talent.crusade or cd.cursade.remains() > unit.gcd(true) * 3 or not ui.checked("Crusade"))
            and (not talent.executionSentence or cd.executionSentence.remains() > unit.gcd(true) * 3 and var.dsUnits)
            and (not talent.finalReckoning or cd.finalReckoning.remains() > unit.gcd(true) * 3) 
                or talent.holyAvenger and cd.holyAvenger.remains() < unit.gcd(true) * 3 or buff.holyAvenger.exists() 
                and buff.crusade.stack() < 10) or not ui.useCDs()
        then
            if cast.templarsVerdict() then ui.debug("Casting Templar's Verdict") return true end
        end
    end
end -- End Action List - Finisher
-- Action List - Generator
actionList.Generator = function()
    -- Call Action List - Finishers
    -- call_action_list,name=finishers,if=holy_power>=5|buff.holy_avenger.up|debuff.final_reckoning.up|debuff.execution_sentence.up|buff.memory_of_lucid_dreams.up|buff.seething_rage.up
    if holyPower >= 5 or buff.holyAvenger.exists() or debuff.finalReckoning.exists(units.dyn5) or debuff.executionSentence.exists(units.dyn5) or buff.memoryOfLucidDreams.exists() then
        if actionList.Finisher() then return true end
    end
    -- Divine Toll
    -- divine_toll,if=!debuff.judgment.up&(!raid_event.adds.exists|raid_event.adds.in>30)&(holy_power<=2|holy_power<=4&(cooldown.blade_of_justice.remains>gcd*2|debuff.execution_sentence.up|debuff.final_reckoning.up))&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*10)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*10)

    -- Wake of Ashes
    -- wake_of_ashes,if=(holy_power=0|holy_power<=2&(cooldown.blade_of_justice.remains>gcd*2|debuff.execution_sentence.up|debuff.final_reckoning.up))&(!raid_event.adds.exists|raid_event.adds.in>20)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>15)&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>15)
    if ui.mode.wake == 1 and cast.able.wakeOfAshes()
        and (holyPower <= 0 or holyPower <= 2 and (cd.bladeOfJustice.remain() > unit.gcd(true) or debuff.executionSentence.exists(units.dyn5) or debuff.finalReckoning.exists(units.dyn5)))
        and ui.useST() and (not talent.executionSentence or cd.executionSentence.remains() > 15) and (not talent.finalReckoning or cd.finalReckoning.remains() > 15)
    then
        if cast.wakeOfAshes(units.dyn12,"cone",1,12) then ui.debug("Casting Wake of Ashes") return true end
    end
    -- Blade of Justice
    -- blade_of_justice,if=holy_power<=3
    if cast.able.bladeOfJustice() and holyPower <= 3 then
        if cast.bladeOfJustice() then ui.debug("Casting Blade of Justice") return true end
    end
    -- Hammer of Wrath
    -- hammer_of_wrath,if=holy_power<=4
    if cast.able.hammerOfWrath() and holyPower <= 4 then
        if buff.avengingWrath.exists() or buff.crusade.exists() then
            if cast.hammerOfWrath() then ui.debug("Casting Hammer of Wrath [Avenging Wrath]") return true end
        end
        for i = 1, #enemies.yards30f do
            local thisUnit = enemies.yards30f[i]
            if unit.hp(thisUnit) < 20 then
                if cast.hammerOfWrath(thisUnit) then ui.debug("Casting Hammer of Wrath [Less Than 20 HP]") return true end
            end
        end
    end
    -- Judgment
    -- judgment,if=!debuff.judgment.up&(holy_power<=2|holy_power<=4&cooldown.blade_of_justice.remains>gcd*2)
    if cast.able.judgment() and not debuff.judgment.exists(unit.dyn5) and (holyPower <= 2 or holyPower <= 4 and cd.bladeOfJustice.remain() > unit.gcd(true)* 2) then
        if cast.judgment() then ui.debug("Casting Judgment") return true end
    end
    -- Call Action List: Finishers
    -- call_action_list,name=finishers,if=(target.health.pct<=20|buff.avenging_wrath.up|buff.crusade.up|buff.empyrean_power.up)
    if (unit.hp(units.dyn5) <= 20 or buff.avengingWrath.exists() or buff.crusade.exists() or buff.empyreanPower.exists()) then
        if actionList.Finisher() then return end
    end
    -- Crusader Strike
    -- crusader_strike,if=cooldown.crusader_strike.charges_fractional>=1.75&(holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2)
    if cast.able.crusaderStrike() and charges.crusaderStrike.frac() >= 1.75
        and (holyPower <= 2 or holyPower <= 3 and cd.bladeOfJustice.remain() > unit.gcd(true)* 2
            or holyPower == 4 and cd.bladeOfJustice.remain() > unit.gcd(true)* 2 and cd.judgment.remain() > unit.gcd(true)* 2)
    then
        if cast.crusaderStrike() then ui.debug("Casting Crusader Strike [Cap Prevention]") return true end
    end
    -- Call Action List: Finishers
    -- call_action_list,name=finishers
    if actionList.Finisher() then return end
    -- -- Essence: Concentrated Flame
    -- if ui.checked("Use Essence") and cast.able.concentratedFlame() then
    --     if cast.concentratedFlame() then ui.debug("Casting Heart Essence: Concentrated Flame") return true end
    -- end
    -- Crusader Strike
    -- crusader_strike,if=holy_power<=4
    if cast.able.crusaderStrike() and holyPower <= 4 then
        if cast.crusaderStrike() then ui.debug("Casting Crusader Strike") return true end
    end
    -- Arcane Torrent
    -- arcane_torrent,if=holy_power<=4
    if ui.checked("Racial") and cast.able.racial() and race == "BloodElf" and holyPower <= 4 then
        if cast.racial() then ui.debug("Casting Racial: Blood Elf") return true end
    end
    -- Consecration
    -- consecration,if=time_to_hpg>gcd
    if cast.able.consecration() and var.timeToHPG > unit.gcd(true)
    then
        if cast.consecration("player","aoe",1,8) then ui.debug("Casting Consecration") return true end
    end
end -- End Action List - Generator
-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        -- Flask
        -- flask,type=flask_of_the_countless_armies
        module.FlaskUp("Strength")
        -- Food
        -- food,type=azshari_salad
        -- Augmenation
        -- augmentation,type=defiled
        -- Potion
        -- potion,name=old_war
        -- if ui.checked("Potion") and canUseItem(127844) and unit.instance("raid") then
        --     useItem(127844)
        -- end
        if unit.valid("target") then--and opener.complete then
            -- Judgment
            if cast.able.judgment("target") and unit.distance("target") < 30 then
                if cast.judgment("target") then ui.debug("Casting Judgment [Pre-Pull]") return true end
            end
            -- Blade of Justice
            if cast.able.bladeOfJustice("target") and unit.distance("target") < 12 then
                if cast.bladeOfJustice("target") then ui.debug("Casting Blade of Justice [Pre-Pull]") return true end
            end
            -- Crusader Strike
            if cast.able.crusaderStrike("target") and unit.distance("target") < 5 then
                if cast.crusaderStrike("target") then ui.debug("Casting Crusader Strike [Pre-Pull]") return true end
            end
            -- Start Attack
            if unit.distance("target") < 5 then StartAttack() ui.debug("Casting Auto Attack [Pre-Pull]") end
        end
    end
    -- Opener
    -- if actionList.Opener() then return true end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local runRotation = function()
    -----------------
    --- Variables ---
    -----------------
    -- BR API
    buff          = br.player.buff
    cast          = br.player.cast
    cd            = br.player.cd
    charges       = br.player.charges
    debuff        = br.player.debuff
    enemies       = br.player.enemies
    holyPower     = br.player.power.holyPower.amount()
    module        = br.player.module
    race          = br.player.race
    talent        = br.player.talent
    ui            = br.player.ui
    unit          = br.player.unit
    units         = br.player.units
    var           = br.player.variables
    -- General API
    
    -- Dynamic Units
    units.get(5)
    units.get(8)
    -- Enemies Lists
    enemies.get(5)
    enemies.get(8)
    enemies.get(8,"player",false,true)
    enemies.get(10)
    enemies.get(12)
    enemies.get(30,"player",false,true)
    
    -- Profile Variables
    -- variable,name=ds_castable,value=spell_targets.divine_storm>=2|buff.empyrean_power.up&debuff.judgment.down&buff.divine_purpose.down|spell_targets.divine_storm>=2&buff.crusade.up&buff.crusade.stack<10
    var.dsUnits = ((ui.mode.rotation == 1 and (#enemies.yards8 >= ui.value("Divine Storm Units"))) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
    var.dsCastable = var.dsUnits or buff.empyreanPower.exists() and not debuff.judgment.exists(units.dyn8) and not buff.divinePurpose.exists() or var.dsUnits and buff.crusade.exists() and buff.crusade.stack() < 10
    var.lowestUnit = br.friend[1].unit
    var.resable   = unit.player("target") and unit.deadOrGhost("target") and unit.friend("target","player")
    var.timeToHPG = cd.crusaderStrike.remain()
    if unit.level() >= 46 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.bladeOfJustice.remain(), cd.judgment.remain(), cd.hammerOfWrath.remain(), cd.wakeOfAshes.remain())
    end
    if unit.level() >= 39 then
        var.timeToHPG =math.min(cd.crusaderStrike.remain(), cd.bladeOfJustice.remain(), cd.judgment.remain(), cd.wakeOfAshes.remain())
    end
    if unit.level() >= 19 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.bladeOfJustice.remain(), cd.judgment.remain())
    end
    if unit.level() >= 16 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.judgment.remain())
    end

    -- Find Lowest Unit / Greater Buff Unit
    -- getLowestGreater()

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not hastar and profileStop==true then
        profileStop = false
    elseif (unit.inCombat() and profileStop==true) or pause() or ui.mode.rotation==4 then
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then return end
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList.PreCombat() then return end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if unit.inCombat() and unit.valid("target") then --and opener.complete then
            ----------------------------------
            --- In Combat - Begin Rotation ---
            ----------------------------------
            --------------------------------
            --- In Combat - SimCraft APL ---
            --------------------------------
            if ui.value("APL Mode") == 1 then
                local startTime = debugprofilestop()
                -- Start Attack
                -- auto_attack
                if unit.distance(units.dyn5) < 5 then --and opener == true then
                    if not IsCurrentSpell(6603) then
                        StartAttack(units.dyn5)
                        ui.debug("Casting Auto Attack")
                    end
                end
                -- Action List - Interrupts
                -- rebuke
                if actionList.Interrupts() then return end
                -- Light's Judgment - Lightforged Draenei Racial
                if ui.checked("Racial") and race == "LightforgedDraenei" and #enemies.yards8 >= 3 then
                    if cast.racial() then ui.debug("Casting Racial: Lightforged Draenei [AOE]") return true end
                end
                -- Action List - Cooldowns
                -- call_action_list,name=cooldowns
                if actionList.Cooldowns() then return end
                -- -- Divine Storm
                -- if cast.able.divineStorm() and buff.empyreanPower.exists() then
                --     if cast.divineStorm("player","aoe",1,8) then ui.debug("Casting Divine Storm [Empyrean Power]") return true end
                -- end
                -- Call Action List - Generator
                -- call_action_list,name=generators
                if actionList.Generator() then return end
                br.debug.cpu.rotation.inCombat = debugprofilestop()-startTime
            end -- End SimC Profile
        end -- End In Combat
    end -- End Profile
end -- runRotation
local id = 70
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})