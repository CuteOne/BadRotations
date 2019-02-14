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

----------------
--- ROTATION ---
----------------
local function runRotation()
    -- if br.timer:useTimer("debugRetribution", math.random(0.15,0.3)) then -- Change debugSpec tp name of Spec IE: debugFeral or debugWindwalker
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
	    UpdateToggle("Wake",0.25)
        br.player.mode.wake = br.data.settings[br.selectedSpec].toggles["Wake"]

--------------
--- Locals ---
--------------
        local artifact      = br.player.artifact
        local buff          = br.player.buff
        local cast          = br.player.cast
        local cd            = br.player.cd
        local charges       = br.player.charges
        local combatTime    = getCombatTime()
        local debuff        = br.player.debuff
        local enemies       = br.player.enemies
        local gcd           = br.player.gcdMax
        local hastar        = GetObjectExists("target")
        local healPot       = getHealthPot()
        local holyPower     = br.player.power.holyPower.amount()
        local inCombat      = br.player.inCombat
        local item          = br.player.spell.items
        local level         = br.player.level
        local mode          = br.player.mode
        local php           = br.player.health
        local race          = br.player.race
        local resable       = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
        local solo          = GetNumGroupMembers() == 0
        local spell         = br.player.spell
        local talent        = br.player.talent
        local thp           = getHP
        local ttd           = getTTD
        local units         = br.player.units
        local use           = br.player.use

        units.get(5)
        units.get(8)
        enemies.get(5)
        enemies.get(8)
        enemies.get(10)
        enemies.get(12)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if opener == nil then opener = false end
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        end
        if not inCombat and not GetObjectExists("target") then
            opener = false
            OPN1 = false
            ARC1 = false
            ARC2 = false
            BOJ1 = false
            BOJ2 = false
            CRU1 = false
            CRS1 = false
            CRS2 = false
            CRS3 = false
            CRS4 = false
            CRS5 = false
            CRS6 = false
            JUD1 = false
            JUD2 = false
            TMV1 = false
            TMV2 = false
            TMV3 = false
            TMV4 = false
            TMV5 = false
            TMV6 = false
            TMV7 = false
            WOA1 = false
        end

        -- variable,name=ds_castable,value=spell_targets.divine_storm>=2&!talent.righteous_verdict.enabled|spell_targets.divine_storm>=3&talent.righteous_verdict.enabled
        local dsCastable = (mode.rotation == 1 and (#enemies.yards8 >= getOptionValue("Divine Storm Units"))) or (mode.rotation == 2 and #enemies.yards8 > 0)
        -- variable,name=HoW,value=(!talent.hammer_of_wrath.enabled|target.health.pct>=20&(buff.avenging_wrath.down|buff.crusade.down))
        local howVar = (not talent.hammerOfWrath or thp(units.dyn5) >= 20) and (not buff.avengingWrath.exists() or not buff.crusade.exists())

        local greaterBuff
        greaterBuff = 0
        local lowestUnit
        local kingsUnit = "player"
        local wisdomUnit = "player"
        lowestUnit = "player"
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            local thisHP = getHP(thisUnit)
            local lowestHP = getHP(lowestUnit)
            local thisRole = UnitGroupRolesAssigned(thisUnit)
            if thisHP < lowestHP then
                lowestUnit = thisUnit
            end
            if getDistance(thisUnit) < 30 and not UnitIsDeadOrGhost(thisUnit) then
                if (buff.greaterBlessingOfKings.remain(kingsUnit) < 600 and buff.greaterBlessingOfKings.exists()) or (thisRole == "TANK" and not buff.greaterBlessingOfKings.exists()) then
                    kingsUnit = thisUnit
                end
                if (buff.greaterBlessingOfWisdom.remain(wisdomUnit) < 600 and buff.greaterBlessingOfWisdom.exists()) or (thisRole == "HEALER" and not buff.greaterBlessingOfWisdom.exists()) then
                    wisdomUnit = thisUnit
                end
            end
            -- if UnitBuffID(thisUnit,spell.buffs.greaterBlessingOfMight) ~= nil then
            --     greaterBuff = greaterBuff + 1
            -- end
        end

--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
        -- Blessing of Freedom
            if isChecked("Blessing of Freedom") and cast.able.blessingOfFreedom() and hasNoControl(spell.blessingOfFreedom) then
                if cast.blessingOfFreedom() then return end
            end
        -- Hand of Hinderance
            if isChecked("Hand of Hinderance") and cast.able.handOfHinderance("target") and isMoving("target") 
                and not getFacing("target","player") and getDistance("target") > 8 and getHP("target") < 25 
            then
                if cast.handOfHinderance("target") then return end
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
                if cast.greaterBlessingOfKings(kingsUnit) then return end
            end
        -- Greater Blessing of Wisdom
            if isChecked("Greater Blessing of Wisdom") and cast.able.greaterBlessingOfWisdom(wisdomUnit) 
                and buff.greaterBlessingOfWisdom.remain(wisdomUnit) < 600 and not IsMounted() 
            then
                if cast.greaterBlessingOfWisdom(wisdomUnit) then return end
            end
        end -- End Action List - Extras
    -- Action List - Defensives
        local function actionList_Defensive()
            if useDefensive() then
            -- Lay On Hands
                if isChecked("Lay On Hands") and inCombat then
                -- Player
                    if getOptionValue("Lay on Hands Target") == 1 then
                        if cast.able.layOnHands("player") and php <= getValue("Lay On Hands") then
                            if cast.layOnHands("player") then return true end
                        end
                -- Target
                    elseif getOptionValue("Lay on Hands Target") == 2 then
                        if cast.able.layOnHands("target") and getHP("target") <= getValue("Lay On Hands") then
                            if cast.layOnHands("target") then return true end
                        end
                -- Mouseover
                    elseif getOptionValue("Lay on Hands Target") == 3 then
                        if cast.able.layOnHands("mouseover") and getHP("mouseover") <= getValue("Lay On Hands") then
                            if cast.layOnHands("mouseover") then return true end
                        end
                -- LowestUnit
                    elseif cast.able.layOnHands(lowestUnit) and getHP(lowestUnit) <= getValue("Lay On Hands") then
                        -- Tank
                            if getOptionValue("Lay on Hands Target") == 4 then
                                if UnitGroupRolesAssigned(lowestUnit) == "TANK" then
                                    if cast.layOnHands(lowestUnit) then return true end
                                end
                        -- Healer
                            elseif getOptionValue("Lay on Hands Target") == 5 then
                                if UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
                                    if cast.layOnHands(lowestUnit) then return true end
                                end
                        -- Healer/Tank
                            elseif getOptionValue("Lay on Hands Target") == 6 then
                                if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "TANK" then
                                    if cast.layOnHands(lowestUnit) then return true end
                                end
                        -- Healer/Damager
                            elseif getOptionValue("Lay on Hands Target") == 7 then
                                if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
                                    if cast.layOnHands(lowestUnit) then return true end
                                end
                        -- Any
                            elseif  getOptionValue("Lay on Hands Target") == 8 then
                                if cast.layOnHands(lowestUnit) then return true end
                            end
                    end
                end
            -- Divine Shield
                if isChecked("Divine Shield") and cast.able.divineShield() then
                    if php <= getOptionValue("Divine Shield") and inCombat then
                        if cast.divineShield() then return end
                    end
                end
            -- Pot/Stoned
                if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
                        useItem(healPot)
                    end
                end
            -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(122667) then
                        if GetItemCooldown(122667)==0 then
                            useItem(122667)
                        end
                    end
                end
            -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and race == "Draenei" then
                    if cast.racial() then return end
                end
            -- Blessing of Protection
                if isChecked("Blessing of Protection") and cast.able.blessingOfProtection(lowestUnit) then
                    if getHP(lowestUnit) < getOptionValue("Blessing of Protection") and inCombat then
                        if cast.blessingOfProtection(lowestUnit) then return end
                    end
                end
            -- Blinding Light
                if cast.able.blindingLight() then 
                    if isChecked("Blinding Light - HP") and php <= getOptionValue("Blinding Light - HP") and inCombat and #enemies.yards10 > 0 then
                        if cast.blindingLight() then return end
                    end
                    if isChecked("Blinding Light - AoE") and #enemies.yards5 >= getOptionValue("Blinding Light - AoE") and inCombat then
                        if cast.blindingLight() then return end
                    end
                end
            -- Cleanse Toxins
                if isChecked("Cleanse Toxins") then
                    if getOptionValue("Cleanse Toxins")==1 and cast.able.clenseToxins("player") and canDispel("player",spell.cleanseToxins) then
                        if cast.cleanseToxins("player") then return end
                    end
                    if getOptionValue("Cleanse Toxins")==2 and cast.able.clenseToxins("target") and canDispel("target",spell.cleanseToxins) then
                        if cast.cleanseToxins("target") then return end
                    end
                    if getOptionValue("Cleanse Toxins")==3 and cast.able.clenseToxins("mouseover") and canDispel("mouseover",spell.cleanseToxins) then
                        if cast.cleanseToxins("mouseover") then return end
                    end
                end
            -- Eye for an Eye
                if isChecked("Eye for an Eye") and cast.able.eyeForAnEye() then
                    if php <= getOptionValue("Eye for an Eye") and inCombat then
                        if cast.eyeForAnEye() then return end
                    end
                end
            -- Shield of Vengeance
                if isChecked("Shield of Vengeance") and cast.able.shieldOfVengeance() then
                    if php <= getOptionValue("Shield of Vengeance") and inCombat then
                        if cast.shieldOfVengeance() then return end
                    end
                end
            -- Hammer of Justice
                if isChecked("Hammer of Justice - HP") and cast.able.hammerOfJustice() and inCombat then 
                    if php <= getOptionValue("Hammer of Justice - HP") then
                        if cast.hammerOfJustice() then return end
                    end
                    if isChecked("Justicar's Vengeance") and php <= getOptionValue("Justicar's Vengeance") then
                        if cast.hammerOfJustice() then return end
                    end
                end
            -- Redemption
                if isChecked("Redemption") and not isMoving("player") and resable then
                    if getOptionValue("Redemption")==1 and cast.able.redemption("target","dead") then
                        if cast.redemption("target","dead") then return end
                    end
                    if getOptionValue("Redemption")==2 and cast.able.redemption("mouseover","dead") then
                        if cast.redemption("mouseover","dead") then return end
                    end
                end
            -- Flash of Light
                if isChecked("Flash of Light") and cast.able.flashOfLight() then
                    if (forceHeal or (inCombat and php <= getOptionValue("Flash of Light") / 2) or (not inCombat and php <= getOptionValue("Flash of Light"))) and not isMoving("player") then
                        if cast.flashOfLight() then return end
                    end
                end
            end
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i = 1, #enemies.yards10 do
                    local thisUnit = enemies.yards10[i]
                    local distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Hammer of Justice
                        if isChecked("Hammer of Justice") and cast.able.hammerOfJustice(thisUnit) and distance < 10 and (not cast.able.rebuke() or distance >= 5) then
                            if cast.hammerOfJustice(thisUnit) then return end
                        end
        -- Rebuke
                        if isChecked("Rebuke") and cast.able.rebuke(thisUnit) and distance < 5 then
                            if cast.rebuke(thisUnit) then return end
                        end
        -- Blinding Light
                        if isChecked("Blinding Light") and cast.able.blindingLight() and distance < 10 and (not cast.able.rebuke() or distance >= 5 or #enemies.yards10 > 1) then
                            if cast.blindingLight(thisUnit,"aoe",1,10) then return end
                        end
                    end
                end
            end
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if (useCDs() or burst) and getDistance(units.dyn5) < 5 then
            -- Trinkets
                if isChecked("Trinkets") then
                    if canUse(13) and not hasEquiped(151190, 13) then
                        useItem(13)
                    end
                    if canUse(14) and not hasEquiped(151190, 14) then
                        useItem(14)
                    end
                end
            -- Potion
                -- potion,name=old_war,if=(buff.bloodlust.react|buff.avenging_wrath.up|buff.crusade.up&buff.crusade.remains<25|target.time_to_die<=40)
                if isChecked("Potion") and canUse(127844) and inRaid then
                    if (hasBloodlust() or buff.avengingWrath.exists() or (buff.crusade.exists() and buff.crusade.remain() < 25) or ttd(units.dyn5) <= 40) then
                        useItem(127844)
                    end
                end
            -- Racial
                if isChecked("Racial") and cast.able.racial() then
                    -- lights_judgment,if=spell_targets.lights_judgment>=2|(!raid_event.adds.exists|raid_event.adds.in>75)
                    if race == "LightforgedDraenei" and ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                        if cast.racial() then return end
                    end                
                    -- fireblood,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10
                    if race == "DarkIronDwarf" and (buff.avengingWrath.exists() or (buff.crusade.exists() and buff.crusade.stack() == 10) 
                        or (talent.crusade and not isChecked("Crusade")))
                    then 
                        if cast.racial() then return end 
                    end
                end
            -- Shield of Vengenace
                -- shield_of_vengeance
                if isChecked("Shield of Vengenace - CD") and cast.able.shieldOfVengeance() then
                    if cast.shieldOfVengeance() then return end
                end
            -- Avenging Wrath
                -- avenging_wrath,if=buff.inquisition.up|!talent.inquisition.enabled
                if isChecked("Avenging Wrath") and not talent.crusade and cast.able.avengingWrath() and (buff.inquisition.exists() or not talent.inquisition) then
                    if cast.avengingWrath() then return end
                end
            -- Crusade
                -- crusade,if=holy_power>=4
                if isChecked("Crusade") and talent.crusade and cast.able.crusade() and holyPower >= 4 then
                    if cast.crusade() then return end
                end
            end -- End Cooldown Usage Check
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
        -- Flask
                -- flask,type=flask_of_the_countless_armies
                if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheCountlessArmies.exists() and canUse(item.flaskOfTheCountlessArmies) then
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if use.flaskOfTheCountlessArmies() then return end
                end
                if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUse(item.repurposedFelFocuser) then
                    if buff.flaskOfTheCountlessArmies.exists() then buff.flaskOfTheCountlessArmies.cancel() end
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if use.repurposedFelFocuser() then return end
                end
                if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUse(item.oraliusWhisperingCrystal) then
                    if buff.flaskOfTheCountlessArmies.exists() then buff.flaskOfTheCountlessArmies.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if use.oraliusWhisperingCrystal() then return end
                end
        -- Food
                -- food,type=azshari_salad
        -- Augmenation
                -- augmentation,type=defiled
        -- Potion
                -- potion,name=old_war
                -- if isChecked("Potion") and canUse(127844) and inRaid then
                --     useItem(127844)
                -- end
                if isValidUnit("target") and (not isBoss("target") or not isChecked("Opener")) then
        -- Judgment
                    if cast.able.judgment("target") then 
                        if cast.judgment("target") then return end
                    end
        -- Blade of Justice
                    if cast.able.bladeOfJustice("target") then 
                        if cast.bladeOfJustice("target") then return end
                    end
        -- Crusader Strike
                    if cast.able.crusaderStrike("target") then 
                        if cast.crusaderStrike("target") then return end
                    end
        -- Start Attack
                    if getDistance("target") < 5 then StartAttack() end
                end
            end
        end -- End Action List - PreCombat
    -- -- Action List - Opener
    --     local function actionList_Opener()
    --         if isChecked("Opener") and isBoss("target") and opener == false then
    --             if isValidUnit("target") and getDistance("target") < 12 then
    --                 if not OPN1 then
    --                     Print("Starting Opener")
    --                     OPN1 = true
    --                 elseif OPN1 and not BOJ1 then
    --     -- Blade Of Justice/Divine Hammer
    --                     if not talent.divineHammer then
    --                         if castOpener("bladeOfJustice","BOJ1",1) then return end
    --                     else
    --                         if castOpener("divineHammer","BOJ1",1) then return end
    --                     end
    --                 elseif BOJ1 and not CRS1 and (getDistance("target") < 5 or not (t20Bleg or (not t20_4pc and not hasEquiped(137048)))) then
    --     -- Crusader Strike - T20 Blood Elf Leggo or no T20 and no Leggo
    --                     if t20Bleg or (not t20_4pc and not hasEquiped(137048)) then
    --                         if talent.zeal then
    --                             if castOpener("zeal","CRS1",2) then return end
    --                         else
    --                             if castOpener("crusaderStrike","CRS1",2) then return end
    --                         end
    --                     else
    --                         Print("2: Crusader Strike *special* (Uncastable)")
    --                         CRS1 = true
    --                     end
    --                 elseif CRS1 and not JUD1 then
    --     -- Judgment
    --                     if castOpener("judgment","JUD1",3) then return end
    --                 elseif JUD1 and not CRU1 then
    --     -- Crusade/Avenging Wrath
    --                     if talent.crusade then
    --                         if castOpener("crusade","CRU1",4) then return end
    --                     else
    --                         if castOpener("avengingWrath","CRU1",4) then return end
    --                     end
    --                 elseif CRU1 and not TMV1 then
    --     -- Templar's Verdict
    --                     if castOpener("templarsVerdict","TMV1",5) then return end
    --                 elseif TMV1 and not (ARC1 or WOA1) then
    --     -- Arcane Torrent / Wake of Ashes
    --                     if t20Bleg then
    --                         if isChecked("Racial") then
    --                             if castOpener("racial","ARC1",6) then return end
    --                         else
    --                             Print("6: Arcane Torrent (Uncastable)")
    --                             ARC1 = true
    --                         end
    --                     else
    --                         if castOpener("wakeOfAshes","WOA1",6) then return end
    --                     end
    --                 elseif (ARC1 or WOA1) and not TMV2 then
    --     -- Templar's Verdict
    --                     if castOpener("templarsVerdict","TMV2",7) then return end
    --                 elseif TMV2 and not (WOA2 or ARC2 or CRS2) then
    --     -- Wake of Ashes / Arcane Torrent / Crusader Strike
    --                     if t20Bleg then
    --                         if castOpener("wakeOfAshes","WOA2",8) then return end
    --                     elseif race == "BloodElf" and not t20_4pc then
    --                         if isChecked("Racial") then
    --                             if castOpener("racial","ARC2",8) then return end
    --                         else
    --                             Print("8: Arcane Torrent (Uncastable)")
    --                             ARC2 = true
    --                         end
    --                     elseif talent.zeal then
    --                         if castOpener("zeal","CRS2",8) then return end
    --                     else
    --                         if castOpener("crusaderStrike","CRS2",8) then return end
    --                     end
    --                 elseif (WOA2 or ARC2 or CRS2) and not TMV3 then
    --     -- Templar's Verdict
    --                     if castOpener("templarsVerdict","TMV3",9) then return end
    --                 elseif TMV3 and not (TMV4 or CRS3) then
    --     -- End Opener 1 / Templar's Verdict / Crusader Strike
    --                     if not t20_4pc or (t20_4pc and race == "BloodElf" and not hasEquiped(137048)) then
    --                         opener = true;
    --                         Print("Opener Complete")
    --                         return
    --                     elseif t20Bleg then
    --                         if castOpener("templarsVerdict","TMV4",10) then return end
    --                     elseif talent.zeal then
    --                         if castOpener("zeal","CRS3",10) then return end
    --                     else
    --                         if castOpener("crusaderStrike","CRS3",10) then return end
    --                     end
    --                 elseif (TMV4 or CRS3) and not BOJ2 then
    --     -- Blade Of Justice/Divine Hammer
    --                     if not talent.divineHammer then
    --                         if castOpener("bladeOfJustice","BOJ2",11) then return end
    --                     else
    --                         if castOpener("divineHammer","BOJ2",11) then return end
    --                     end
    --                 elseif BOJ2 and not (TMV5 or CRS4) then
    --     -- Templar's Verdict / Crusader Strike
    --                     if t20_4pc and hasEquiped(137048) then
    --                         if castOpener("templarsVerdict","TMV5",12) then return end
    --                     elseif talent.zeal then
    --                         if castOpener("zeal","CRS4",12) then return end
    --                     else
    --                         if castOpener("crusaderStrike","CRS4",12) then return end
    --                     end
    --                 elseif (TMV5 or CRS4) and not CRS5 then
    --     -- End of Opener 2 / Crusader Strike - T20 and Leggo
    --                     if t20Bleg then
    --                         opener = true;
    --                         Print("Opener Complete")
    --                         return
    --                     elseif t20_4pc and hasEquiped(137048) then
    --                         if talent.zeal then
    --                             if castOpener("zeal","CRS5",13) then return end
    --                         else
    --                             if castOpener("crusaderStrike","CRS5",13) then return end
    --                         end
    --                     else
    --                         Print("13: Crusader Strike *special* (Uncastable)")
    --                         CRS5 = true
    --                     end
    --                 elseif CRS5 and not JUD2 then
    --     -- Judgment
    --                     if castOpener("judgment","JUD2",14) then return end
    --                 elseif JUD2 and not TMV6 then
    --     -- Templar's Verdict
    --                     if castOpener("templarsVerdict","TMV6",15) then return end
    --                 elseif TMV6 and not CRS6 then
    --     -- End of Opener 3 / Crusader's Strile
    --                     if t20_4pc and hasEquiped(137048) then
    --                         opener = true;
    --                         Print("Opener Complete")
    --                         return
    --                     else
    --                         if talent.zeal then
    --                             if castOpener("zeal","CRS6",16) then return end
    --                         else
    --                             if castOpener("crusaderStrike","CRS6",16) then return end
    --                         end
    --                     end
    --                 elseif CRS6 and not TMV7 then
    --     -- Templar's Verdict
    --                     if castOpener("templarsVerdict","TMV7",17) then return end
    --                 elseif TMV7 then
    --     -- Final End of Opener
    --                     opener = true;
    --                     Print("Opener Complete")
    --                     return
    --                 end
    --             end
    --         elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
    --             opener = true
    --             return
    --         end
    --     end -- End Action List - Opener
    -- Action List - Finisher
        local function actionList_Finisher()
        -- Inquisition
            -- inquisition,if=buff.inquisition.down|buff.inquisition.remains<5&holy_power>=3|talent.execution_sentence.enabled&cooldown.execution_sentence.remains<10&buff.inquisition.remains<15|cooldown.avenging_wrath.remains<15&buff.inquisition.remains<20&holy_power>=3
            if cast.able.inquisition() and (not buff.inquisition.exists() or (buff.inquisition.remain() < 5 and holyPower >= 3) 
                or (talent.executionSentence and cd.executionSentence.remain() < 10 and buff.inquisition.remain() < 15) 
                or (cd.avengingWrath.remain() < 15 and buff.inquisition.remain() < 20 and holyPower >= 3))
            then 
                if cast.inquisition() then return end 
            end
        -- Execution Sentence
            -- execution_sentence,if=spell_targets.divine_storm<=2&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*2)
            if cast.able.executionSentence() and ((mode.rotation == 1 and #enemies.yards8 <= getOptionValue("Divine Storm Units")) or (mode.rotation == 3 and #enemies.yards8 > 0) or level < 40)
                and (not talent.crusade or cd.crusade.remain() > gcd * 2 or not isChecked("Crusade") or not useCDs()) 
            then
                if cast.executionSentence() then return end
            end
        -- Divine Storm
            -- divine_storm,if=variable.ds_castable&buff.divine_purpose.react
            if cast.able.divineStorm() and dsCastable and buff.divinePurpose.exists() then
                if cast.divineStorm("player","aoe",getOptionValue("Divine Storm Units"),8) then return end
            end
            -- divine_storm,if=variable.ds_castable&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*2)|buff.empyrean_power.up&debuff.judgment.down&buff.divine_purpose.down
            -- if cast.able.divineStorm() and ((dsCastable and (not talent.crusade or cd.crusade.remain() > gcd * 2 or not isChecked("Crusade") or not useCDs()))
            --     or (buff.empyreanPower.exists() and not debuff.judgment.exists(units.dyn8) and not buff.divinePurpose.exists()))
            -- then
            if cast.able.divineStorm() and (dsCastable and (not talent.crusade or cd.crusade.remain() > gcdMax * 2 or not isChecked("Crusade") or not useCDs()) 
                or buff.empyreanPower.exists() and not debuff.judgment.exists() and not buff.divinePurpose.exists()) 
            then
                if buff.empyreanPower.exists() then 
                    if cast.divineStorm("player","aoe",1,8) then return end
                else
                    if cast.divineStorm("player","aoe",getOptionValue("Divine Storm Units"),8) then return end
                end
            end
        -- Templar's Verdict
            if cast.able.templarsVerdict() and ((mode.rotation == 1 and #enemies.yards8 < getOptionValue("Divine Storm Units")) or (mode.rotation == 3 and #enemies.yards5 > 0) or level < 40) then
                -- templars_verdict,if=buff.divine_purpose.react
                if buff.divinePurpose.exists() then
                    if cast.templarsVerdict() then return end
                end
                -- templars_verdict,if=(!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)&(!talent.execution_sentence.enabled|buff.crusade.up&buff.crusade.stack<10|cooldown.execution_sentence.remains>gcd*2)
                if (not talent.crusade or cd.crusade.remain() > gcd * 3 or not isChecked("Crusade") or not useCDs()) 
                    and (not talent.executionSentence or (buff.crusade.exists() and buff.crusade.stack() < 10) or cd.executionSentence.remain() > gcd * 2) 
                then
                    if cast.templarsVerdict() then return end
                end
            end
        end
    -- Action List - Generator
        local function actionList_Generator()
        -- Call Action List - Finisher
            -- call_action_list,name=finishers,if=holy_power>=5
            if holyPower >= 5 then
                if actionList_Finisher() then return end
            end
        -- Wake of Ashes
            -- wake_of_ashes,if=(!raid_event.adds.exists|raid_event.adds.in>15|spell_targets.wake_of_ashes>=2)&(holy_power<=0|holy_power=1&cooldown.blade_of_justice.remains>gcd)
            if mode.wake == 1 and cast.able.wakeOfAshes() --and ((mode.rotation == 1 and #enemies.yards12 >=2) or (mode.rotation == 2 and #enemies.yards12 > 0)) 
                and (holyPower <= 0 or (holyPower == 1 and cd.bladeOfJustice.remain() > gcd))
            then
                if cast.wakeOfAshes(units.dyn12,"cone",1,12) then return end
            end
        -- Blade of Justice
            -- blade_of_justice,if=holy_power<=2|(holy_power=3&(cooldown.hammer_of_wrath.remains>gcd*2|variable.HoW))
            if cast.able.bladeOfJustice() and (holyPower <= 2 or (holyPower == 3 and (cd.hammerOfWrath.remain() > gcd * 2 or howVar))) then
                if cast.bladeOfJustice() then return end
            end
        -- Judgment
            -- judgment,if=holy_power<=2|(holy_power<=4&(cooldown.blade_of_justice.remains>gcd*2|variable.HoW))
            if cast.able.judgment() and (holyPower <= 2 or (holyPower <= 4 and (cd.bladeOfJustice.remain() > gcd * 2 or howVar))) then
                if cast.judgment() then return end
            end
        -- Hammer of Wrath 
            -- hammer_of_wrath,if=holy_power<=4
            if cast.able.hammerOfWrath() and holyPower <= 4 then 
                if cast.hammerOfWrath() then return end 
            end
        -- Consecration 
            -- consecration,if=holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2
            if cast.able.consecration() and (holyPower <= 2 or (holyPower <=3 and cd.bladeOfJustice.remain() > gcd * 2) 
                or (holyPower == 4 and cd.bladeOfJustice.remain() > gcd * 2 and cd.judgment.remain() > gcd * 2)) 
            then
                if cast.consecration("player","aoe",1,8) then return end 
            end
        -- Call Action List: Finishers
            -- call_action_list,name=finishers,if=talent.hammer_of_wrath.enabled&(target.health.pct<=20|buff.avenging_wrath.up|buff.crusade.up)
            if talent.hammerOfWrath and (thp(units.dyn5) <= 20 or buff.avengingWrath.exists() or buff.crusade.exists()) then 
                if actionList_Finisher() then return end 
            end 
        -- Crusader Strike
            -- crusader_strike,if=cooldown.crusader_strike.charges_fractional>=1.75&(holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2&cooldown.consecration.remains>gcd*2)
            if cast.able.crusaderStrike() and charges.crusaderStrike.frac() >= 1.75 
                and (holyPower <= 2 or (holyPower <= 3 and cd.bladeOfJustice.remain() > gcd * 2) 
                    or (holyPower == 4 and cd.bladeOfJustice.remain() > gcd * 2 and cd.judgment.remain() > gcd * 2 and cd.consecration.remain() > gcd * 2)) 
            then 
                if cast.crusaderStrike() then return end 
            end
        -- Call Action List: Finishers
            -- call_action_list,name=finishers
            if actionList_Finisher() then return end 
        -- Crusader Strike 
            -- crusader_strike,if=holy_power<=4
            if cast.able.crusaderStrike() and holyPower <= 4 then 
                if cast.crusaderStrike() then return end
            end 
        -- Arcane Torrent 
            -- arcane_torrent,if=holy_power<=4
            if cast.able.racial() and race == "BloodElf" and holyPower <= 4 then 
                if cast.racial() then return end 
            end 
        end
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 then
            return true
        else
-----------------------
--- Extras Rotation ---
-----------------------
            if actionList_Extras() then return end
--------------------------
--- Defensive Rotation ---
--------------------------
            if actionList_Defensive() then return end
------------------------------
--- Out of Combat Rotation ---
------------------------------
            if actionList_PreCombat() then return end
            -- if actionList_Opener() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and profileStop==false then
------------------------------
--- In Combat - Interrupts ---
------------------------------
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
                        end
                    end
            -- Action List - Interrupts
                    -- rebuke
                    if actionList_Interrupts() then return end
            -- -- Action List - Opener
            --         -- call_action_list,name=opener,if=time<2
            --         if combatTime < 2 then
            --             if actionList_Opener() then return end
            --         end
            --         if opener == true then
            -- Light's Judgment - Lightforged Draenei Racial
                        if isChecked("Racial") and race == "LightforgedDraenei" and #enemies.yards8 >= 3 then
                            if cast.racial() then return end
                        end
            -- Action List - Cooldowns
                        -- call_action_list,name=cooldowns
                        if actionList_Cooldowns() then return end
            -- Action List - Priority
                        -- call_action_list,name=generators
                        if actionList_Generator() then return end
                    -- end
                    br.debug.cpu.rotation.inCombat = debugprofilestop()-startTime
                end
            end -- End In Combat
        end -- End Profile
    -- end -- Timer
end -- runRotation
local id = 70
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
