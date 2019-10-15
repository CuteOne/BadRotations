local rotationName = "CuteOne"
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
            -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of the Countless Armies","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
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
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
            -- Blessing of Protection
            br.ui:createSpinner(section, "Blessing of Protection",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Blinding Light
            br.ui:createSpinner(section, "Blinding Light - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Blinding Light - AoE", 3, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
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
            -- Blinding Light
            br.ui:createCheckbox(section, "Blinding Light")
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
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
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
-- BR API
local buff
local cast
local cd
local charges
local debuff
local debug
local enemies
local essence
local equiped
local gcd
local has
local holyPower
local inCombat
local item
local level
local mode
local opener
local php
local race
local spell
local talent
local units
local use
-- General API
local combatTime
local hastar
local healPot
local leftCombat
local moving
local profileStop
local resable
local solo
local thp
local ttd
-- SimC Profile Variables
local wingsPool
local dsCastable
local howVar
-- Custom Profile Variables
local greaterBuff
local kingsUnit
local lowestUnit
local thisGlory
local thisUnit
local wisdomUnit
-- Init
greaterBuff = 0
kingsUnit = "player"
leftCombat = GetTime()
lowestUnit = "player"
thisGlory = "player"
thisUnit = "target"
profileStop = false
wisdomUnit = "player"

------------------------
--- Custom Functions ---
------------------------
local getLowestGreater = function()
    if #br.friend > 1 then
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            local thisRole = UnitGroupRolesAssigned(thisUnit)
            local thisHP = getHP(thisUnit)
            local opValue = getOptionValue("Lay on Hands Target")
            if thisHP < getHP(lowestUnit) then
                -- Tank
                if opValue == 4 and thisRole == "TANK" then lowestUnit = thisUnit end
                -- Healer
                if opValue == 5 and thisRole == "HEALER" then lowestUnit = thisUnit end
                -- Healer/Tank
                if opValue == 6 and (thisRole == "HEALER" or thisRole == "TANK") then lowestUnit = thisUnit end
                -- Healer/Damager
                if opValue == 7 and (thisRole == "HEALER" or thisRole == "DAMAGER") then lowestUnit = thisUnit end
                -- Any
                if opValue == 8 then
                    lowestUnit = thisUnit
                end
            end
            if getDistance(thisUnit) < 30 and not UnitIsDeadOrGhost(thisUnit) then
                if (buff.greaterBlessingOfKings.exists(thisUnit) and kingsUnit ~= "player")
                    or (thisRole == "TANK" and not buff.greaterBlessingOfKings.exists() and kingsUnit == "player")
                then
                    kingsUnit = thisUnit
                end
                if (buff.greaterBlessingOfWisdom.exists(thisUnit) and wisdomUnit ~= "player")
                    or (thisRole == "HEALER" and not buff.greaterBlessingOfWisdom.exists() and wisdomUnit == "player")
                then
                    wisdomUnit = thisUnit
                end
            end
            -- if UnitBuffID(thisUnit,spell.buffs.greaterBlessingOfMight) ~= nil then
            --     greaterBuff = greaterBuff + 1
            -- end
        end
    end
end

local canGlory = function()
    local optionValue = getOptionValue("Word of Glory")
    local otherCounter = 0
    if charges.wordOfGlory.count() > 0 then
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            local thisHP = getHP(thisUnit)
            if thisHP < optionValue then
                -- Emergency Single
                if thisHP < 25 then
                    thisGlory = thisUnit
                    return true
                end
                -- Group Heal
                if otherCounter < 2 then
                    for j = 1, #br.friend do
                        local otherUnit = br.friend[j].unit
                        local otherHP = getHP(otherUnit)
                        local distanceFromYou = getDistance(otherUnit,"player")
                        if distanceFromYou < 30 and otherHP < optionValue then
                            otherCounter = otherCounter + 1
                        end
                    end
                else
                    thisGlory = thisUnit
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
    if isChecked("Blessing of Freedom") and cast.able.blessingOfFreedom() and hasNoControl(spell.blessingOfFreedom) then
        if cast.blessingOfFreedom() then debug("Casting Blessing of Freedom") return true end
    end
    -- Hand of Hinderance
    if isChecked("Hand of Hinderance") and cast.able.handOfHinderance("target") and isMoving("target")
        and not getFacing("target","player") and getDistance("target") > 8 and getHP("target") < 25
    then
        if cast.handOfHinderance("target") then debug("Casting Hand of Hinderance on "..UnitName("target")) return true end
    end
    -- Greater Blessing of Might
    -- if isChecked("Greater Blessing of Might") and greaterBuff < 3 then
    --     for i = 1, #br.friend do
    --         local thisUnit = br.friend[i].unit
    --         local unitRole = UnitGroupRolesAssigned(thisUnit)
    --         if UnitBuffID(thisUnit,spell.buffs.greaterBlessingOfMight) == nil and (unitRole == "DAMAGER" or solo) then
    --             if cast.greaterBlessingOfMight(thisUnit) then return end
    --         end
    --     end
    -- end
    -- Greater Blessing of Kings
    if isChecked("Greater Blessing of Kings") and cast.able.greaterBlessingOfKings(kingsUnit)
        and buff.greaterBlessingOfKings.remain(kingsUnit) < 600 and not IsMounted()
    then
        if cast.greaterBlessingOfKings(kingsUnit) then debug("Casting Greater Blessing of Kings on "..UnitName(kingsUnit)) return true end
    end
    -- Greater Blessing of Wisdom
    if isChecked("Greater Blessing of Wisdom") and cast.able.greaterBlessingOfWisdom(wisdomUnit)
        and buff.greaterBlessingOfWisdom.remain(wisdomUnit) < 600 and not IsMounted()
    then
        if cast.greaterBlessingOfWisdom(wisdomUnit) then debug("Casting Greater Blessing of Wisdom on "..UnitName(wisdomUnit)) return true end
    end
end -- End Action List - Extras
-- Action List - Defensives
actionList.Defensive = function()
    if useDefensive() then
        -- Lay On Hands
        if isChecked("Lay On Hands") and inCombat then
            local lohTar = getOptionValue("Lay on Hands Target")
            local lohUnit
            if lohTar == 1 then lohUnit = "player" end
            if lohTar == 2 then lohUnit = "target" end
            if lohTar == 3 then lohUnit = "mouseover" end
            if lohTar >= 4 then lohUnit = lowestUnit end
            if cast.able.layOnHands(lohUnit) and getHP(lohUnit) <= getValue("Lay On Hands") then
                if cast.layOnHands(lohUnit) then
                    debug("Casting Lay On Hands on "..UnitName(lohUnit).." ("..getHP(lohUnit).."% Remaining)")
                    return true
                end
            end
        end
        -- Divine Shield
        if isChecked("Divine Shield") and cast.able.divineShield() then
            if php <= getOptionValue("Divine Shield") and inCombat then
                if cast.divineShield() then debug("Casting Divine Shield") return true end
            end
        end
        -- Pot/Stoned
        if isChecked("Pot/Stoned") and inCombat and (use.able.healthstone() or canUseItem(healPot))
            and (hasHealthPot() or has.healthstone()) and php <= getOptionValue("Pot/Stoned")
        then
            if use.able.healthstone() then
                if use.healthstone() then debug("Using Healthstone") return true end
            elseif canUseItem(healPot) then
                useItem(healPot)
                debug("Using Health Potion")
            end
        end
        -- Heirloom Neck
        if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
            if use.able.heirloomNeck() and item.heirloomNeck ~= 0
                and item.heirloomNeck ~= item.manariTrainingAmulet
            then
                if use.heirloomNeck() then debug("Using Heirloom Neck") return true end
            end
        end
        -- Gift of the Naaru
        if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru")
            and php > 0 and race == "Draenei"
        then
            if cast.racial() then debug("Casting Racial: Gift of the Naaru") return true end
        end
        -- Blessing of Protection
        if isChecked("Blessing of Protection") and cast.able.blessingOfProtection(lowestUnit) then
            if getHP(lowestUnit) < getOptionValue("Blessing of Protection") and inCombat then
                if cast.blessingOfProtection(lowestUnit) then
                    debug("Casting Lay On Hands on "..UnitName(lowestUnit).." ("..getHP(lowestUnit).."% Remaining)")
                    return true
                end
            end
        end
        -- Blinding Light
        if cast.able.blindingLight() and inCombat then
            if isChecked("Blinding Light - HP") and php <= getOptionValue("Blinding Light - HP") and #enemies.yards10 > 0 then
                if cast.blindingLight() then debug("Casting Blinding Light (HP)") return true end
            end
            if isChecked("Blinding Light - AoE") and #enemies.yards5 >= getOptionValue("Blinding Light - AoE") then
                if cast.blindingLight() then debug("Casting Blinding Light (AOE)") return true end
            end
        end
        -- Cleanse Toxins
        if isChecked("Cleanse Toxins") then
            local cleanseTar = getOptionValue("Cleanse Toxins")
            local cleanseUnit
            if cleanseTar == 1 then cleanseUnit = "player" end
            if cleanseTar == 2 then cleanseUnit = "target" end
            if cleanseTar == 3 then cleanseUnit = "mouseover" end
            if cast.able.clenseToxins(cleanseUnit) and canDispel(cleanseUnit,spell.cleanseToxins) then
                if cast.cleanseToxins(cleanseUnit) then debug("Casting Lay On Hands on "..UnitName(cleanseUnit)) return true end
            end
        end
        -- Eye for an Eye
        if isChecked("Eye for an Eye") and cast.able.eyeForAnEye() then
            if php <= getOptionValue("Eye for an Eye") and inCombat then
                if cast.eyeForAnEye() then debug("Casting Eye For An Eye") return true end
            end
        end
        -- Shield of Vengeance
        if isChecked("Shield of Vengeance") and cast.able.shieldOfVengeance() then
            if php <= getOptionValue("Shield of Vengeance") and inCombat then
                if cast.shieldOfVengeance() then debug("Casting Shield of Vengeance") return true end
            end
        end
        -- Hammer of Justice
        if isChecked("Hammer of Justice - HP") and cast.able.hammerOfJustice() and inCombat then
            if php <= getOptionValue("Hammer of Justice - HP") then
                if cast.hammerOfJustice() then debug("Casting Hammer of Justice [Defensive]") return true end
            end
        end
        -- Justicar's Vengeance
        if isChecked("Justicar's Vengeance") and cast.able.justicarsVengeance() and holyPower >= 5 then
            if php <= getOptionValue("Justicar's Vengeance") then
                if cast.justicarsVengeance() then debug("Casting Justicar's Vengeance") return true end
            end
        end
        -- Redemption
        if isChecked("Redemption") and not isMoving("player") and resable then
            local redemptionTar = getOptionValue("Redemption")
            local redemptionUnit
            if redemptionTar == 1 then redemptionUnit = "target" end
            if redemptionTar == 2 then redemptionUnit = "mouseover" end
            if cast.able.redemption(redemptionUnit,"dead") then
                if cast.redemption(redemptionUnit,"dead") then debug("Casting Redemption on "..UnitName(redemptionUnit)) return true end
            end
        end
        -- Word of Glory
        if isChecked("Word of Glory") and talent.wordOfGlory and cast.able.wordOfGlory() and canGlory() then
            if cast.wordOfGlory(thisGlory) then debug("Casting Word of Glory on "..UnitName(thisGlory)) return true end
        end
        -- Flash of Light
        if isChecked("Flash of Light") and cast.able.flashOfLight() and not (IsMounted() or IsFlying())
            and (getOptionValue("Auto Heal") ~= 1 or (getOptionValue("Auto Heal") == 1
            and getDistance(br.friend[1].unit) < 40))
        then
            local folHP = php
            local folUnit = "player"
            local lowUnit = getLowestUnit(40)
            local fhp = getHP(lowUnit)
            local folValue = getOptionValue("Flash of Light")
            if getOptionValue("Auto Heal") == 1 then folHP = fhp; folUnit = lowUnit end
            -- Instant Cast
            if talent.selflessHealer and folHP <= folValue and buff.selflessHealer.stack() == 4 then
                if cast.flashOfLight(folUnit) then debug("Casting Flash of Light on "..UnitName(folUnit).." [Instant]") return true end
            end
            -- Long Cast
            folHP = getHP(br.friend[1].unit)
            if not isMoving("player") and (forceHeal or (inCombat and folHP <= folValue / 2) or (not inCombat and folHP <= folValue)) then
                if cast.flashOfLight(folUnit) then debug("Casting Flash of Light on "..UnitName(folUnit).." [Long]") return true end
            end
        end
    end
end -- End Action List - Defensive
-- Action List - Interrupts
actionList.Interrupts = function()
    if useInterrupts() then
        for i = 1, #enemies.yards10 do
            thisUnit = enemies.yards10[i]
            local distance = getDistance(thisUnit)
            if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                -- Hammer of Justice
                if isChecked("Hammer of Justice") and cast.able.hammerOfJustice(thisUnit) and distance < 10 and (not cast.able.rebuke() or distance >= 5) then
                    if cast.hammerOfJustice(thisUnit) then debug("Casting Hammer of Justice [Interrupt]") return true end
                end
                -- Rebuke
                if isChecked("Rebuke") and cast.able.rebuke(thisUnit) and distance < 5 then
                    if cast.rebuke(thisUnit) then debug("Casting Rebuke") return true end
                end
                -- Blinding Light
                if isChecked("Blinding Light") and cast.able.blindingLight() and distance < 10 and (not cast.able.rebuke() or distance >= 5 or #enemies.yards10 > 1) then
                    if cast.blindingLight(thisUnit,"aoe",1,10) then debug("Casting Blinding Light") return true end
                end
            end
        end
    end
end -- End Action List - Interrupts
-- Action List - Cooldowns
actionList.Cooldowns = function()
    if (useCDs() or burst) and getDistance(units.dyn5) < 5 then
        -- Potion
        -- potion,if=(cooldown.guardian_of_azeroth.remains>90|!essence.condensed_lifeforce.major)&(buff.bloodlust.react|buff.avenging_wrath.up&buff.avenging_wrath.remains>18|buff.crusade.up&buff.crusade.remains<25)
        if isChecked("Potion") and use.able.potionOfFocusedResolve() and inRaid then
            if (cd.guardianOfAzeroth.remain() > 90 or not essence.condensedLifeForce.active)
                and (hasBloodlust() or (buff.avengingWrath.exists() and buff.avengingWrath.remain() > 18)
                    or (buff.crusade.exists() and buff.crusade.remain() < 25))
            then
                use.potionOfFocusedResolve()
                debug("Used Potion of Focused Resolve")
            end
        end
        -- Racial
        if isChecked("Racial") and cast.able.racial() then
            -- lights_judgment,if=spell_targets.lights_judgment>=2|(!raid_event.adds.exists|raid_event.adds.in>75)
            if race == "LightforgedDraenei" and ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                if cast.racial() then debug("Casting Racial: Lightforged Draenei") return true end
            end
            -- fireblood,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10
            if race == "DarkIronDwarf" and (buff.avengingWrath.exists() or (buff.crusade.exists() and buff.crusade.stack() == 10)
            or (talent.crusade and not isChecked("Crusade")))
            then
                if cast.racial() then debug("Casting Racial: Dark Iron Dwarf") return true end
            end
        end
    -- Shield of Vengenace
        -- shield_of_vengeance,if=buff.seething_rage.down&buff.memory_of_lucid_dreams.down
        if isChecked("Shield of Vengenace - CD") and cast.able.shieldOfVengeance()
            and not buff.seethingRage.exists() and not buff.memoryOfLucidDreams.exists()
        then
            if cast.shieldOfVengeance() then debug("Casting Shield of Vengeance [CD]") return true end
        end
    -- Trinkets
        if isChecked("Trinkets") then
            for i = 13, 14 do
                if use.able.slot(i) and not (equiped.ashvanesRazorCoral(i) or equiped.pocketSizedComputationDevice(i)) then
                    use.slot(i)
                    debug("Using Trinket Slot "..i)
                end
            end
        end
        -- use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.down|(buff.avenging_wrath.remains>=20|buff.crusade.stack=10&buff.crusade.remains>15)&(cooldown.guardian_of_azeroth.remains>90|target.time_to_die<30|!essence.condensed_lifeforce.major)                
        if isChecked("Trinkets") and equiped.ashvanesRazorCoral() and (not debuff.razorCoral.exists(units.dyn5)
            or ((not talent.crusade and (not useCDs() or not isChecked("Avenging Wrath") or buff.avengingWrath.remain() >= 20))
                or (talent.crusade and (not useCDs() or not isChecked("Crusade") or (buff.crusade.stack() == 10 and buff.crusade.remain() > 15))))
            and (cd.guardianOfAzeroth.remain() > 90 or ttd(units.dyn5) < 30 or not essence.condensedLifeForce.active))
        then
            for i = 13, 14 do
                if use.able.slot(i) and equiped.ashvanesRazorCoral(i) then
                    use.slot(i)
                    debug("Using Ashvanes Razor Coral on Slot "..i)
                end
            end
        end
    -- Heart Essence
        if isChecked("Use Essence") then
        -- Essence: The Unbound Force
            -- the_unbound_force,if=time<=2|buff.reckless_force.up
            if cast.able.theUnboundForce() and (combatTime <= 2 or buff.recklessForce.exists()) then
                if cast.theUnboundForce() then debug("Casting Heart Essence: The Unbound Force") return true end
            end
        -- Essence: Blood of the Enemy
            -- blood_of_the_enemy,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10
            if cast.able.bloodOfTheEnemy()
                and (buff.avengingWrath.exists() or (buff.crusade.exists() and buff.crusade.stack() == 10))
            then
                if cast.bloodOfTheEnemy() then debug("Casting Heart Essence: Blood of the Enemy") return true end
            end
        -- Essence: Guardian of Azeroth
            -- guardian_of_azeroth,if=!talent.crusade.enabled&(cooldown.avenging_wrath.remains<5&holy_power>=3&(buff.inquisition.up|!talent.inquisition.enabled)|cooldown.avenging_wrath.remains>=45)|(talent.crusade.enabled&cooldown.crusade.remains<gcd&holy_power>=4|holy_power>=3&time<10&talent.wake_of_ashes.enabled|cooldown.crusade.remains>=45)
            if cast.able.guardianOfAzeroth()
                and ((not talent.crusade and ((cd.avengingWrath.remain() < 5 and holyPower >= 3 and (buff.inquisition.exists() or not talent.inquisition))
                    or cd.avengingWrath.remain() >= 45)) or ((talent.crusade and cd.crusade.remain() < gcd and holyPower >= 4)
                        or (holyPower >= 3 and combatTime < 10 and talent.wakeOfAshes) or cd.crusade.remain() >= 45))
            then
                if cast.guardianOfAzeroth() then debug("Casting Heart Essence: Guardian of Azeroth") return true end
            end
        -- Essence: Worldvein Resonance
            -- worldvein_resonance,if=cooldown.avenging_wrath.remains<gcd&holy_power>=3|cooldown.crusade.remains<gcd&holy_power>=4|cooldown.avenging_wrath.remains>=45|cooldown.crusade.remains>=45
            if cast.able.worldveinResonance()
                and ((cd.avengingWrath.remain() < gcd and holyPower >= 3)
                    or (cd.crusade.remain() < gcd and holyPower >= 4)
                    or cd.avengingWrath.remain() >= 45 or cd.crusade.remain() >= 45)
            then
                if cast.worldveinResonance() then debug("Casting Heart Essence: Worldvein Resonance") return true end
            end
        -- Essence: Focused Azerite Beam
            -- focused_azerite_beam,if=(!raid_event.adds.exists|raid_event.adds.in>30|spell_targets.divine_storm>=2)&(buff.avenging_wrath.down|talent.crusade.enabled&buff.crusade.down)&(cooldown.blade_of_justice.remains>gcd*3&cooldown.judgment.remains>gcd*3)
            if cast.able.focusedAzeriteBeam() and (not buff.avengingWrath.exists() and (talent.crusade and not buff.crusade.exists()))
                and (cd.bladeOfJustice.remain() > gcd * 3 and cd.judgment.remain() > gcd * 3)
                and (#enemies.yards8f >= 3 or useCDs()) and not moving
            then
                local minCount = useCDs() and 1 or 3
                if cast.focusedAzeriteBeam(nil,"cone",minCount, 8) then debug("Casting Heart Essence: Focused Azerite Beam") return true end
            end
        -- Essence: Memory of Lucid Dreams
            -- memory_of_lucid_dreams,if=(buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10)&holy_power<=3
            if cast.able.memoryOfLucidDreams()
                and (buff.avengingWrath.exists() or (buff.crusade.exists() and buff.crusade.stack() == 10)) and holyPower <= 3
            then
                if cast.memoryOfLucidDreams() then debug("Casting Heart Essence: Memory of Lucid Dreams") return true end
            end
        -- Essence: Purifying Blast
            -- purifying_blast,if=(!raid_event.adds.exists|raid_event.adds.in>30|spell_targets.divine_storm>=2)
            if cast.able.purifyingBlast() then
                if cast.purifyingBlast("best", nil, 1, 8) then debug("Casting Heart Essence: Purifying Blast") return true end
            end
        end
    -- Pocket Sized Computation Device: Cyclotronic Blast
        -- use_item,effect_name=cyclotronic_blast,if=(buff.avenging_wrath.down|talent.crusade.enabled&buff.crusade.down)&(cooldown.blade_of_justice.remains>gcd*3&cooldown.judgment.remains>gcd*3)
        if isChecked("Trinkets") and equiped.pocketSizedComputationDevice() and (not buff.avengingWrath.exists() and (talent.crusade and not buff.crusade.exists()))
            and (cd.bladeOfJustice.remain() > gcd * 3 and cd.judgment.remain() > gcd * 3)
        then
            for i = 13, 14 do
                if use.able.slot(i) and equiped.pocketSizedComputationDevice(i) then
                    use.slot(i)
                    debug("Using Pocket Sized Computation Device: Cyclotronic Blast")
                end
            end
        end
    -- Avenging Wrath
        -- avenging_wrath,if=(!talent.inquisition.enabled|buff.inquisition.up)&holy_power>=3
        if isChecked("Avenging Wrath") and not talent.crusade and cast.able.avengingWrath()
            and (not talent.inquisition or buff.inquisition.exists()) and holyPower >= 3
        then
            if cast.avengingWrath() then debug("Casting Avenging Wrath") return true end
        end
    -- Crusade
        -- crusade,if=holy_power>=4
        -- crusade,if=holy_power>=4|holy_power>=3&time<10&talent.wake_of_ashes.enabled
        if isChecked("Crusade") and talent.crusade and cast.able.crusade()
            and (holyPower >= 4 or (holyPower >= 3 and combatTime < 10 and talent.wakeOfAshes))
        then
            if cast.crusade() then debug("Casting Crusade") return true end
        end
    end -- End Cooldown Usage Check
end -- End Action List - Cooldowns
-- Action List - Finisher
actionList.Finisher = function()
    -- Inquisition
    -- inquisition,if=buff.avenging_wrath.down&(buff.inquisition.down|buff.inquisition.remains<8&holy_power>=3|talent.execution_sentence.enabled&cooldown.execution_sentence.remains<10&buff.inquisition.remains<15|cooldown.avenging_wrath.remains<15&buff.inquisition.remains<20&holy_power>=3)
    if cast.able.inquisition() and not buff.avengingWrath.exists() and (not buff.inquisition.exists() or (buff.inquisition.remain() < 5 and holyPower >= 3)
        or (talent.executionSentence and cd.executionSentence.remain() < 10 and buff.inquisition.remain() < 15)
        or (cd.avengingWrath.remain() < 15 and buff.inquisition.remain() < 20 and holyPower >= 3))
    then
        if cast.inquisition() then debug("Casting Inquisition") return true end
    end
    -- Execution Sentence
    -- execution_sentence,if=spell_targets.divine_storm<=2&(!talent.crusade.enabled&cooldown.avenging_wrath.remains>10|talent.crusade.enabled&buff.crusade.down&cooldown.crusade.remains>10|buff.crusade.stack>=7)
    if cast.able.executionSentence()
        and ((mode.rotation == 1 and #enemies.yards8 <= getOptionValue("Divine Storm Units")) or (mode.rotation == 3 and #enemies.yards8 > 0) or level < 40)
        and ((not talent.crusade and (cd.avengingWrath.remain() > 10 or not isChecked("Avenging Wrath")))
            or (talent.crusade and ((not buff.crusade.exists() and cd.crusade.remain() > 10) or buff.crusade.stack() >= 7 or not isChecked("Crusade")))
            or not useCDs())
    then
        if cast.executionSentence() then debug("Casting Execution Sentence") return true end
    end
    -- Divine Storm
    -- divine_storm,if=variable.ds_castable&variable.wings_pool&((!talent.execution_sentence.enabled|(spell_targets.divine_storm>=2|cooldown.execution_sentence.remains>gcd*2))|(cooldown.avenging_wrath.remains>gcd*3&cooldown.avenging_wrath.remains<10|cooldown.crusade.remains>gcd*3&cooldown.crusade.remains<10|buff.crusade.up&buff.crusade.stack<10))
    if cast.able.divineStorm() and dsCastable and wingsPool
        and ((not talent.executionSentence or (mode.rotation == 2 or #enemies.yards8 >= 2 or cd.executionSentence.remain() > gcd * 2))
            or (not talent.crusade and ((cd.avengingWrath.remain() > gcd * 3 and cd.avengingWrath.remain() < 10) or not isChecked("Avenging Wrath")))
            or (talent.crusade and ((cd.crusade.remain() > gcd * 3 and cd.crusade.remain() < 10) or not isChecked("Crusade")))
            or (talent.crusade and buff.crusade.exists() and buff.crusade.stack() < 10)
            or not useCDs())
    then
        local theseUnits = mode.roation == 2 and 1 or getOptionValue("Divine Storm Units")
        if cast.divineStorm("player","aoe",theseUnits,8) then debug("Casting Divine Storm") return true end
    end
    -- Templar's Verdict
    -- templars_verdict,if=variable.wings_pool&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*2|cooldown.avenging_wrath.remains>gcd*3&cooldown.avenging_wrath.remains<10|cooldown.crusade.remains>gcd*3&cooldown.crusade.remains<10|buff.crusade.up&buff.crusade.stack<10)
    if cast.able.templarsVerdict() and ((mode.rotation == 1 and #enemies.yards8 < getOptionValue("Divine Storm Units"))
        or (mode.rotation == 3 and #enemies.yards5 > 0) or level < 40)
    then
        if wingsPool and (not talent.executionSentence or cd.executionSentence.remain() > gcd * 2
            or (not talent.crusade and cd.avengingWrath.remain() > gcd * 3 and cd.avengingWrath.remain() < 10)
            or (talent.crusade and cd.crusade.remain() > gcd * 3 and cd.crusade.remain() < 10)
            or (talent.crusade and buff.crusade.exists() and buff.crusade.stack() < 10))
        then
            if cast.templarsVerdict() then debug("Casting Templar's Verdict") return true end
        end
    end
end -- End Action List - Finisher
-- Action List - Generator
actionList.Generator = function()
    -- Wake of Ashes
    -- wake_of_ashes,if=(!raid_event.adds.exists|raid_event.adds.in>15|spell_targets.wake_of_ashes>=2)&(holy_power<=0|holy_power=1&cooldown.blade_of_justice.remains>gcd)&(cooldown.avenging_wrath.remains>10|talent.crusade.enabled&cooldown.crusade.remains>10)
    if mode.wake == 1 and cast.able.wakeOfAshes() --and ((mode.rotation == 1 and #enemies.yards12 >=2) or (mode.rotation == 2 and #enemies.yards12 > 0))
        and (holyPower <= 0 or (holyPower == 1 and cd.bladeOfJustice.remain() > gcd))
        and ((not talent.crusade and (cd.avengingWrath.remain() > 10 or not isChecked("Avenging Wrath")))
            or (talent.crusade and (cd.crusade.remain() > 10 or not isChecked("Crusade")))
            or not useCDs())
    then
        if cast.wakeOfAshes(units.dyn12,"cone",1,12) then debug("Casting Wake of Ashes") return true end
    end
    -- Blade of Justice
    -- blade_of_justice,if=holy_power<=2|(holy_power=3&(cooldown.hammer_of_wrath.remains>gcd*2|variable.HoW))
    if cast.able.bladeOfJustice() and (holyPower <= 2 or (holyPower == 3 and (cd.hammerOfWrath.remain() > gcd * 2 or howVar))) then
        if cast.bladeOfJustice() then return end
    end
    -- Judgment
    -- judgment,if=holy_power<=2|(holy_power<=4&(cooldown.blade_of_justice.remains>gcd*2|variable.HoW))
    if cast.able.judgment() and (holyPower <= 2 or (holyPower <= 4 and (cd.bladeOfJustice.remain() > gcd * 2 or howVar))) then
        if cast.judgment() then debug("Casting Judgment") return true end
    end
    -- Hammer of Wrath
    -- hammer_of_wrath,if=holy_power<=4
    if cast.able.hammerOfWrath() and holyPower <= 4 then
        if buff.avengingWrath.exists() or buff.crusade.exists() then
            if cast.hammerOfWrath() then debug("Casting Hammer of Wrath [Avenging Wrath]") return true end
        end
        for i = 1, #enemies.yards30f do
            local thisUnit = enemies.yards30f[i]
            if getHP(thisUnit) < 20 then
                if cast.hammerOfWrath(thisUnit) then debug("Casting Hammer of Wrath [Less Than 20 HP]") return true end
            end
        end
    end
    -- Consecration
    -- consecration,if=holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2
    if cast.able.consecration() and (holyPower <= 2 or (holyPower <=3 and cd.bladeOfJustice.remain() > gcd * 2)
        or (holyPower == 4 and cd.bladeOfJustice.remain() > gcd * 2 and cd.judgment.remain() > gcd * 2))
    then
        if cast.consecration("player","aoe",1,8) then debug("Casting Consecration") return true end
    end
    -- Call Action List: Finishers
    -- call_action_list,name=finishers,if=talent.hammer_of_wrath.enabled&target.health.pct<=20|buff.avenging_wrath.up|buff.crusade.up
    if (talent.hammerOfWrath and thp(units.dyn5) <= 20) or buff.avengingWrath.exists() or buff.crusade.exists() then
        if actionList.Finisher() then return end
    end
    -- Crusader Strike
    -- crusader_strike,if=cooldown.crusader_strike.charges_fractional>=1.75&(holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2&cooldown.consecration.remains>gcd*2)
    if cast.able.crusaderStrike() and charges.crusaderStrike.frac() >= 1.75
        and (holyPower <= 2 or (holyPower <= 3 and cd.bladeOfJustice.remain() > gcd * 2)
            or (holyPower == 4 and cd.bladeOfJustice.remain() > gcd * 2 and cd.judgment.remain() > gcd * 2 and cd.consecration.remain() > gcd * 2))
    then
        if cast.crusaderStrike() then debug("Casting Crusader Strike [2 Charges]") return true end
    end
    -- Call Action List: Finishers
    -- call_action_list,name=finishers
    if actionList.Finisher() then return end
    -- Essence: Concentrated Flame
    if isChecked("Use Essence") and cast.able.concentratedFlame() then
        if cast.concentratedFlame() then debug("Casting Heart Essence: Concentrated Flame") return true end
    end
    -- Crusader Strike
    -- crusader_strike,if=holy_power<=4
    if cast.able.crusaderStrike() and holyPower <= 4 then
        if cast.crusaderStrike() then debug("Casting Crusader Strike") return true end
    end
    -- Arcane Torrent
    -- arcane_torrent,if=holy_power<=4
    if isChecked("Racial") and cast.able.racial() and race == "BloodElf" and holyPower <= 4 then
        if cast.racial() then debug("Casting Racial: Blood Elf") return true end
    end
end -- End Action List - Generator
-- Action List - Opener
actionList.Opener = function()
    -- Start Attack
    -- auto_attack
    if isChecked("Opener") and useCDs() and not opener.complete then
        if isValidUnit("target") and getDistance("target") < 40
            and getFacing("player","target") and getSpellCD(61304) == 0
        then
            -- Begin
            if not opener.OPN1 then
                Print("Starting Opener")
                opener.count = opener.count + 1
                opener.OPN1 = true
                StartAttack()
                return
            -- Avenging Wrath - Divine Purpose
            elseif opener.OPN1 and not opener.AW1 then
                if not talent.divinePurpose then
                    opener.AW1 = true
                    opener.count = opener.count - 1
                elseif cd.avengingWrath.remain() > gcd then
                    castOpenerFail("avengingWrath","AW1",opener.count)
                else
                    castOpener("avengingWrath","AW1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Blade of Judgment
            elseif opener.AW1 and not opener.BOJ1 then
                if cd.bladeOfJustice.remain() > gcd then
                    castOpenerFail("bladeOfJustice","BOJ1",opener.count)
                elseif cast.able.bladeOfJustice() then
                    castOpener("bladeOfJustice","BOJ1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Judgment
            elseif opener.BOJ1 and not opener.JUD1 then
                if cd.judgment.remain() > gcd then
                    castOpenerFail("judgment","JUD1",opener.count)
                elseif cast.able.judgment() then
                    castOpener("judgment","JUD1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Hammer of Wrath - Divine Purpose w/ Divine Judgment or Consecration 
            elseif opener.JUD1 and not opener.HOW1 then
                if not talent.hammerOfWrath or not talent.divinePurpose or (not talent.divineJudgment and not talent.consecration) then
                    opener.HOW1 = true
                    opener.count = opener.count - 1
                elseif cd.hammerOfWrath.remain() > gcd then
                    castOpenerFail("hammerOfWrath","HOW1",opener.count)
                elseif cast.able.hammerOfWrath() then
                    castOpener("hammerOfWrath","HOW1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Crusader Strike - Crusade w/ Divine Judgment
            elseif opener.HOW1 and not opener.CS1 then
                if not talent.crusade or cd.crusade.remain() > gcd or not talent.divineJudgment then
                    opener.CS1 = true
                    opener.count = opener.count - 1
                elseif charges.crusaderStrike.count() < 1 then
                    castOpenerFail("crusaderStrike","CS1",opener.count)
                elseif cast.able.crusaderStrike() then
                    castOpener("crusaderStrike","CS1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Consecration
            elseif opener.CS1 and not opener.CON1 then
                if not talent.consecration then
                    opener.CON1 = true
                    opener.count = opener.count - 1
                elseif cd.consecration.remain() > gcd then
                    castOpenerFail("consecration","CON1",opener.count)
                elseif cast.able.consecration() then
                    castOpener("consecration","CON1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Crusader Strike - Inquisition w/ Divine Judgment or Consecration
            elseif opener.CON1 and not opener.CS2 then
                if not talent.inquisition or (not talent.divineJudgment and not talent.consecration) then
                    opener.CS2 = true
                    opener.count = opener.count - 1
                elseif charges.crusaderStrike.count() < 1 then
                    castOpenerFail("crusaderStrike","CS2",opener.count)
                elseif cast.able.crusaderStrike() then
                    castOpener("crusaderStrike","CS2",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Inquisition
            elseif opener.CS2 and not opener.INQ1 then
                if not talent.inquisition then
                    opener.INQ1 = true
                    opener.count = opener.count - 1
                elseif holyPower == 0 then
                    castOpenerFail("inquisition","INQ1",opener.count)
                elseif cast.able.inquisition() then
                    castOpener("inquisition","INQ1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Avenging Wrath - Inquisition
            elseif opener.INQ1 and not opener.AW2 then
                if not talent.inquisition then
                    opener.AW2 = true
                    opener.count = opener.count - 1
                elseif cd.avengingWrath.remain() > gcd then
                    castOpenerFail("avengingWrath","AW2",opener.count)
                elseif cast.able.avengingWrath() then
                    castOpener("avengingWrath","AW2",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Wake of Ashes - Inquisition
            elseif opener.AW2 and not opener.WOA1 then
                if not talent.wakeOfAshes or not talent.inquisition then
                    opener.WOA1 = true
                    opener.count = opener.count - 1
                elseif cd.wakeOfAshes.remain() > gcd then
                    castOpenerFail("wakeOfAshes","WOA1",opener.count)
                elseif cast.able.wakeOfAshes() then
                    castOpener("wakeOfAshes","WOA1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Crusade
            elseif opener.WOA1 and not opener.CRU1 then
                if not talent.crusade then
                    opener.CRU1 = true
                    opener.count = opener.count - 1
                elseif cd.crusade.remain() > gcd then
                    castOpenerFail("crusade","CRU1",opener.count)
                elseif cast.able.crusade() then
                    castOpener("crusade","CRU1",opener.count)
                end
                opener.count = opener.count + 1
                return   
            -- Hammer of Wrath - Crusade w/ Divine Judgment or Consecration 
            elseif opener.CRU1 and not opener.HOW2 then
                if not talent.hammerOfWrath or not talent.crusade or (not talent.divineJudgment and not talent.consecration) then
                    opener.HOW2 = true
                    opener.count = opener.count - 1
                elseif cd.hammerOfWrath.remain() > gcd then
                    castOpenerFail("hammerOfWrath","HOW2",opener.count)
                elseif cast.able.hammerOfWrath() then
                    castOpener("hammerOfWrath","HOW2",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Execution Sentence or Templar's Verdict - (Inquisition w/ Wake of Ashes) or Crusade or Divine Purpose
            elseif opener.HOW2 and not opener.ES1 then
                if not (talent.inquisition and talent.wakeOfAshes) and not talent.crusade and not talent.divinePurpose then
                    opener.ES1 = true
                    opener.count = opener.count - 1
                elseif talent.executionSentence then
                    if cd.executionSentence.remain() > gcd or holyPower < 3 then
                        castOpenerFail("executionSentence","ES1",opener.count)
                    elseif cast.able.executionSentence() and holyPower >= 3 then
                        castOpener("executionSentence","ES1",opener.count)
                    end
                else
                    if holyPower < 3 then
                        castOpenerFail("templarsVerdict","ES1",opener.count)
                    elseif cast.able.templarsVerdict() and holyPower >= 3 then
                        castOpener("templarsVerdict","ES1",opener.count)
                    end
                end
                opener.count = opener.count + 1
                return
            -- Wake of Ashes - Crusade or Divine Purpose
            elseif opener.ES1 and not opener.WOA2 then
                if not talent.wakeOfAshes or (not talent.crusade and not talent.divinePurpose) then
                    opener.WOA2 = true
                    opener.count = opener.count - 1
                elseif cd.wakeOfAshes.remain() > gcd then
                    castOpenerFail("wakeOfAshes","WOA2",opener.count)
                elseif cast.able.wakeOfAshes() then
                    castOpener("wakeOfAshes","WOA2",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Templar's Verdict - Wake of Ashes w/ Crusade or Divine Purpose
            elseif opener.WOA2 and not opener.TV1 then
                if not talent.wakeOfAshes or (not talent.crusade and not talent.divinePurpose) then
                    opener.TV1 = true
                    opener.count = opener.count - 1
                elseif holyPower < 3 then
                    castOpenerFail("templarsVerdict","TV1",opener.count)
                elseif cast.able.templarsVerdict() and holyPower >= 3 then
                    castOpener("templarsVerdict","TV1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Hammer of Wrath or Crusader Strike - (Wake of Ashes w/ Crusade or Divine Purpose) or Inquisition
            elseif opener.TV1 and not opener.HOW3 then
                if (not talent.wakeOfAshes or (not talent.crusade and not talent.divinePurpose)) and not talent.inquisition then
                    opener.HOW3 = true
                    opener.count = opener.count - 1
                elseif talent.hammerOfWrath then
                    if cd.hammerOfWrath.remain() > gcd then
                        castOpenerFail("hammerOfWrath","HOW3",opener.count)
                    elseif cast.able.hammerOfWrath() then
                        castOpener("hammerOfWrath","HOW3",opener.count)
                    end
                else
                    if charges.crusaderStrike.count() < 1 then
                        castOpenerFail("crusaderStrike","HOW3",opener.count)
                    elseif cast.able.crusaderStrike() then
                        castOpener("crusaderStrike","HOW3",opener.count)
                    end
                end
                opener.count = opener.count + 1
                return
            -- Crusader Strike - Inquisition w/ Divine Judgment
            elseif opener.HOW3 and not opener.CS3 then
                if not talent.inquisition or not talent.divineJudgment then
                    opener.CS3 = true
                    opener.count = opener.count - 1
                elseif charges.crusaderStrike.count() < 1 then
                    castOpenerFail("crusaderStrike","CS3",opener.count)
                elseif cast.able.crusaderStrike() then
                    castOpener("crusaderStrike","CS3",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Execution Sentence or Templar's Verdict - Inquisition w/ Divine Judgment or Consecration
            elseif opener.CS3 and not opener.ES2 then
                if not talent.inquisition or (not talent.divineJudgment and not talent.consecration) then
                    opener.ES2 = true
                    opener.count = opener.count - 1
                elseif talent.executionSentence then
                    if cd.executionSentence.remain() > gcd or holyPower < 3 then
                        castOpenerFail("executionSentence","ES2",opener.count)
                    elseif cast.able.executionSentence() and holyPower >= 3 then
                        castOpener("executionSentence","ES2",opener.count)
                    end
                else
                    if holyPower < 3 then
                        castOpenerFail("templarsVerdict","ES2",opener.count)
                    elseif cast.able.templarsVerdict() and holyPower >= 3 then
                        castOpener("templarsVerdict","ES2",opener.count)
                    end
                end
                opener.count = opener.count + 1
                return
            -- Templar's Verdict - Wake of Ashes
            elseif opener.ES2 and not opener.TV2 then
                if not talent.wakeOfAshes then
                    opener.TV2 = true
                    opener.count = opener.count - 1
                elseif holyPower < 3 then
                    castOpenerFail("templarsVerdict","TV2",opener.count)
                elseif cast.able.templarsVerdict() and holyPower >= 3 then
                    castOpener("templarsVerdict","TV2",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Finish
            elseif opener.TV2 and opener.OPN1 then
                Print("Opener Complete")
                opener.count = 0
                opener.complete = true
            end
        end
    elseif (UnitExists("target") and not useCDs()) or not isChecked("Opener") then
        opener.complete = true
    end
end -- End Action List - Opener
-- Action List - PreCombat
actionList.PreCombat = function()
    if not inCombat and not (IsFlying() or IsMounted()) then
        -- Flask
        -- flask,type=flask_of_the_countless_armies
        if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheCountlessArmies.exists() and canUseItem(item.flaskOfTheCountlessArmies) then
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.flaskOfTheCountlessArmies() then debug("Using Flask of the Countless Armies") return true end
        end
        if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUseItem(item.repurposedFelFocuser) then
            if buff.flaskOfTheCountlessArmies.exists() then buff.flaskOfTheCountlessArmies.cancel() end
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if use.repurposedFelFocuser() then debug("Using Repurposed Fel Focuser") return true end
        end
        if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUseItem(item.oraliusWhisperingCrystal) then
            if buff.flaskOfTheCountlessArmies.exists() then buff.flaskOfTheCountlessArmies.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.oraliusWhisperingCrystal() then debug("Using Oralius's Whispering Crystal") return true end
        end
        -- Food
        -- food,type=azshari_salad
        -- Augmenation
        -- augmentation,type=defiled
        -- Potion
        -- potion,name=old_war
        -- if isChecked("Potion") and canUseItem(127844) and inRaid then
        --     useItem(127844)
        -- end
        if isValidUnit("target") and opener.complete then
            -- Judgment
            if cast.able.judgment("target") then
                if cast.judgment("target") then debug("Casting Judgment [Pre-Pull]") return true end
            end
            -- Blade of Justice
            if cast.able.bladeOfJustice("target") then
                if cast.bladeOfJustice("target") then debug("Casting Blade of Justice [Pre-Pull]") return true end
            end
            -- Crusader Strike
            if cast.able.crusaderStrike("target") then
                if cast.crusaderStrike("target") then debug("Casting Crusader Strike [Pre-Pull]") return true end
            end
            -- Start Attack
            if getDistance("target") < 5 then StartAttack() debug("Casting Auto Attack [Pre-Pull]") end
        end
    end
    -- Opener
    if actionList.Opener() then return true end
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
    debug         = br.addonDebug
    enemies       = br.player.enemies
    essence       = br.player.essence
    equiped       = br.player.equiped
    gcd           = br.player.gcdMax
    has           = br.player.has
    holyPower     = br.player.power.holyPower.amount()
    inCombat      = br.player.inCombat
    item          = br.player.items
    level         = br.player.level
    mode          = br.player.mode
    opener        = br.player.opener
    php           = br.player.health
    race          = br.player.race
    spell         = br.player.spell
    talent        = br.player.talent
    units         = br.player.units
    use           = br.player.use
    -- General API
    combatTime    = getCombatTime()
    hastar        = GetObjectExists("target")
    healPot       = getHealthPot()
    moving        = GetUnitSpeed("player") > 0
    resable       = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
    solo          = GetNumGroupMembers() == 0
    thp           = getHP
    ttd           = getTTD

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
    -- variable,name=wings_pool,value=!equipped.169314&(!talent.crusade.enabled&cooldown.avenging_wrath.remains>gcd*3|cooldown.crusade.remains>gcd*3)|equipped.169314&(!talent.crusade.enabled&cooldown.avenging_wrath.remains>gcd*6|cooldown.crusade.remains>gcd*6)
    wingsPool = (not useCDs()
        or (talent.crusade and (not isChecked("Crusade")
            or (not equiped.azsharasFontOfPower() and cd.crusade.remain() > gcd * 3) or cd.crusade.remain() > gcd * 6))
        or (not talent.crusade and (not isChecked("Avenging Wrath")
            or (not equiped.azsharasFontOfPower() and cd.avengingWrath.remain() > gcd * 3) or cd.avengingWrath.remain() > gcd * 6)))
    -- variable,name=ds_castable,value=spell_targets.divine_storm>=2&!talent.righteous_verdict.enabled|spell_targets.divine_storm>=3&talent.righteous_verdict.enabled|buff.empyrean_power.up&debuff.judgment.down&buff.divine_purpose.down&buff.avenging_wrath_autocrit.down
    dsCastable = ((mode.rotation == 1 and (#enemies.yards8 >= getOptionValue("Divine Storm Units"))) or (mode.rotation == 2 and #enemies.yards8 > 0))
        or (buff.empyreanPower.exists() and not debuff.judgment.exists(units.dyn8) and not buff.divinePurpose.exists() and not buff.avengingWrath.exists())
    -- variable,name=HoW,value=(!talent.hammer_of_wrath.enabled|target.health.pct>=20&(buff.avenging_wrath.down|talent.crusade.enabled&buff.crusade.down))
    howVar = (not talent.hammerOfWrath or thp(units.dyn5) >= 20) and (not buff.avengingWrath.exists() or (talent.crusade and not buff.crusade.exists()))

    -- Opener Reset
    if opener.complete == nil or (not inCombat and not GetObjectExists("target")) then
        opener.count    = 0
        opener.complete = false
        opener.OPN1     = false
        opener.PP1      = false
        opener.AW1      = false
        opener.BOJ1     = false
        opener.JUD1     = false
        opener.HOW1     = false
        opener.CS1      = false
        opener.CON1     = false
        opener.CS2      = false
        opener.INQ1     = false
        opener.AW2      = false
        opener.WOA1     = false
        opener.CRU1     = false
        opener.HOW2     = false
        opener.ES1      = false
        opener.WOA2     = false
        opener.TV1      = false
        opener.HOW3     = false
        opener.CS3      = false
        opener.ES2      = false
        opener.TV2      = false
    end

    -- Find Lowest Unit / Greater Buff Unit
    getLowestGreater()

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop==true then
        profileStop = false
    elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 or cast.current.focusedAzeriteBeam() then
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
        -- if actionList.Opener() then return end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if inCombat and isValidUnit("target") and opener.complete then
            ----------------------------------
            --- In Combat - Begin Rotation ---
            ----------------------------------
            --------------------------------
            --- In Combat - SimCraft APL ---
            --------------------------------
            if getOptionValue("APL Mode") == 1 then
                local startTime = debugprofilestop()
                -- Start Attack
                -- auto_attack
                if getDistance(units.dyn5) < 5 then --and opener == true then
                    if not IsCurrentSpell(6603) then
                        StartAttack(units.dyn5)
                        debug("Casting Auto Attack")
                    end
                end
                -- Action List - Interrupts
                -- rebuke
                if actionList.Interrupts() then return end
                -- Light's Judgment - Lightforged Draenei Racial
                if isChecked("Racial") and race == "LightforgedDraenei" and #enemies.yards8 >= 3 then
                    if cast.racial() then debug("Casting Racial: Lightforged Draenei [AOE]") return true end
                end
                -- Action List - Cooldowns
                -- call_action_list,name=cooldowns
                if actionList.Cooldowns() then return end
                -- Divine Storm
                if cast.able.divineStorm() and buff.empyreanPower.exists() then
                    if cast.divineStorm("player","aoe",1,8) then debug("Casting Divine Storm [Empyrean Power]") return true end
                end
                -- Call Action List - Finisher
                -- call_action_list,name=finishers,if=holy_power>=5|buff.memory_of_lucid_dreams.up|buff.seething_rage.up|buff.inquisition.down&holy_power>=3
                if holyPower >= 5 or buff.memoryOfLucidDreams.exists() or buff.seethingRage.exists()
                    or (not buff.inquisition.exists() and holyPower >= 3)
                then
                    if actionList.Finisher() then return end
                else
                -- Call Action List - Generator
                    -- call_action_list,name=generators
                    if actionList.Generator() then return end
                end
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