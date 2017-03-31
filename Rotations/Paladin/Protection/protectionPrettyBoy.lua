local rotationName = "PrettyBoy"
---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.eyeOfTyr },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.avengersShield },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.judgment },
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
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.guardianOfAncientKings },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.guardianOfAncientKings }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.hammerOfJustice },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.hammerOfJustice }
    };
    CreateButton("Interrupt",4,0)
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
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Hand of Freedom
            br.ui:createCheckbox(section, "Hand of Freedom")
        -- Taunt
            br.ui:createCheckbox(section,"Taunt","|cffFFFFFFAuto Taunt usage.")
            -- Artifact
            --br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createSpinner(section, "Trinkets",  15,  0,  19,  1,  "|cffFFFFFFTime Remaining on Avenging Wrath")
            -- Seraphim
            br.ui:createSpinner(section, "Seraphim",  0,  0,  20,  2,  "|cffFFFFFFEnemy TTD")
            -- Avenging Wrath
            br.ui:createSpinner(section, "Avenging Wrath",  0,  0,  200,  5,  "|cffFFFFFFEnemy TTD")
            -- Bastion of Light
            br.ui:createCheckbox(section,"Bastion of Light")

        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Ardent Defender
            br.ui:createSpinner(section, "Ardent Defender",  30,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Blessing of Protection
            br.ui:createSpinner(section, "Blessing of Protection",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Blinding Light
            br.ui:createSpinner(section, "Blinding Light - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Blinding Light - AoE", 3, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
            -- Cleanse Toxin
            br.ui:createDropdown(section, "Clease Toxin", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Divine Shield
            br.ui:createSpinner(section, "Divine Shield",  5,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Eye of Tyr
            br.ui:createSpinner(section, "Eye of Tyr - HP", 35, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Eye of Tyr - AoE", 4, 0, 10, 1, "|cffFFFFFFNumber of Units in 10 Yards to Cast At")
            -- Flash of Light
            br.ui:createSpinner(section, "Flash of Light",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Guardian of Ancient Kings
            br.ui:createSpinner(section, "Guardian of Ancient Kings",  20,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Hammer of Justice
            br.ui:createSpinner(section, "Hammer of Justice - HP",  75,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Light of the Protector
            br.ui:createSpinner(section, "Light of the Protector",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use Hand/Light on self.")
            -- Hand of the Protector - on others
            br.ui:createSpinner(section, "Hand of the Protector - Party",  30,  0,  100,  5,  "|cffFFBB00Health Percentage to use at on others.")
            -- Lay On Hands
            br.ui:createSpinner(section, "Lay On Hands",  20,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            br.ui:createDropdownWithout(section, "Lay on Hands Target", {"|cffFFFFFFAll","|cffFFFFFFTanks", "|cffFFFFFFSelf"}, 1, "|cffFFFFFFTarget for LoH")
            -- Shield of the Righteous
            br.ui:createSpinner(section, "Shield of the Righteous - HP", 60, 0 , 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Redemption
            br.ui:createDropdown(section, "Redemption", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Blinding Light
            br.ui:createCheckbox(section, "Blinding Light - INT")
            -- Hammer of Justice
            br.ui:createCheckbox(section, "Hammer of Justice - INT")
            -- Rebuke
            br.ui:createCheckbox(section, "Rebuke - INT")
            -- Avenger's Shield
            br.ui:createCheckbox(section, "Avenger's Shield - INT")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  35,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ------------------------
        --- ROTATION OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Rotation Options")
            -- Avenger's Shield
            br.ui:createCheckbox(section,"Avenger's Shield")
            -- Consecration
            br.ui:createCheckbox(section,"Consecration")
            -- Blessed Hammer
            br.ui:createCheckbox(section,"Blessed Hammer")
            -- Blessed Hammer / Hammer of the Righteous Units
            --br.ui:createSpinner(section, "Blessed Hammer Units",  2,  2,  10,  1,  "|cffFFBB00Units to use Blessed/Righteous Hammer.")
            -- Hammer of the Righteous
            br.ui:createCheckbox(section,"Hammer of the Righteous")
            -- Judgment
            br.ui:createCheckbox(section,"Judgment")
            -- Shield of the Righteous
            br.ui:createCheckbox(section,"Shield of the Righteous")

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
    if br.timer:useTimer("debugProtection", math.random(0.15,0.3)) then -- Change debugSpec tp name of Spec IE: debugFeral or debugWindwalker
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)

--- FELL FREE TO EDIT ANYTHING BELOW THIS AREA THIS IS JUST HOW I LIKE TO SETUP MY ROTATIONS ---

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
        local enemies       = enemies or {}
        local gcd           = br.player.gcd
        local hastar        = GetObjectExists("target")
        local healPot       = getHealthPot()
        local inCombat      = br.player.inCombat
        local level         = br.player.level
        local mode          = br.player.mode
        local php           = br.player.health
        local race          = br.player.race
        local racial        = br.player.getRacial()
        local resable       = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
        local solo          = GetNumGroupMembers() == 0
        local spell         = br.player.spell
        local talent        = br.player.talent
        local ttd           = getTTD(br.player.units(5))
        local units         = units or {}

        units.dyn5 = br.player.units(5)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards10 = br.player.enemies(10)
        enemies.yards30 = br.player.enemies(30)

        if profileStop == nil then profileStop = false end
        judgmentExists = debuff.judgment.exists(units.dyn5)
        judgmentRemain = debuff.judgment.remain(units.dyn5)
        if debuff.judgment.exists(units.dyn5) or level < 42 or (cd.judgment > 2 and not debuff.judgment.exists(units.dyn5)) then
            judgmentVar = true
        else
            judgmentVar = false
        end

        local greaterBuff
        greaterBuff = 0
        local lowestUnit
        lowestUnit = "player"
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            local thisHP = getHP(thisUnit)
            local lowestHP = getHP(lowestUnit)
            if thisHP < lowestHP then
                lowestUnit = thisUnit
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
        -- Hand of Freedom
            if isChecked("Hand of Freedom") and hasNoControl() then
                if cast.handOfFreedom() then return end
            end
        -- Taunt
            if isChecked("Taunt") then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if not isAggroed(thisUnit) and hasThreat(thisUnit) then
                        if cast.handOfReckoning(thisUnit) then return end
                    end
                end
            end

        end -- End Action List - Extras
    -- Action List - Defensives
        local function actionList_Defensive()
            if useDefensive() then
        -- Light of the Protector
                if isChecked("Light of the Protector") and php <= getOptionValue("Light of the Protector") then
                    if talent.handOfTheProtector then
                        if cast.handOfTheProtector() then return end
                    end
                    if cast.lightOfTheProtector() then return end
                end
        -- Hand of the Protector - Others
                if isChecked("Hand of the Protector - Party") then
                    if getHP(lowestUnit) < getOptionValue("Hand of the Protector - Party") and inCombat then
                        if cast.handOfTheProtector(lowestUnit) then return end
                    end
                end
        -- Eye of Tyr
                if isChecked("Eye of Tyr - HP") and php <= getOptionValue("Eye of Tyr - HP") and inCombat and #enemies.yards10 > 0 then
                    if cast.eyeOfTyr() then return end
                end
                if isChecked("Eye of Tyr - AoE") and #enemies.yards10 >= getOptionValue("Eye of Tyr - AoE") and inCombat then
                    if cast.eyeOfTyr() then return end
                end
        -- Blinding Light
                if isChecked("Blinding Light - HP") and php <= getOptionValue("Blinding Light - HP") and inCombat and #enemies.yards10 > 0 then
                    if cast.blindingLight() then return end
                end
                if isChecked("Blinding Light - AoE") and #enemies.yards5 >= getOptionValue("Blinding Light - AoE") and inCombat then
                    if cast.blindingLight() then return end
                end
        -- Shield of the Righteous
                if isChecked("Shield of the Righteous - HP") then
                    if php <= getOptionValue("Shield of the Righteous - HP") and inCombat and not buff.shieldOfTheRighteous.exists() then
                        if cast.shieldOfTheRighteous() then return end
                    end
                end
        -- Guardian of Ancient Kings
                if isChecked("Guardian of Ancient Kings") then
                    if php <= getOptionValue("Guardian of Ancient Kings") and inCombat and not buff.ardentDefender.exists() then
                        if cast.guardianOfAncientKings() then return end
                    end
                end
        -- Ardent Defender
                if isChecked("Ardent Defender") then
                    if php <= getOptionValue("Ardent Defender") and inCombat and not buff.guardianOfAncientKings.exists() then
                        if cast.ardentDefender() then return end
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
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Hammer of Justice
                if isChecked("Hammer of Justice - HP") and php <= getOptionValue("Hammer of Justice - HP") and inCombat then
                    if cast.hammerOfJustice() then return end
                end
        -- Blessing of Protection
                if isChecked("Blessing of Protection") then
                    if getHP(lowestUnit) < getOptionValue("Blessing of Protection") and inCombat then
                        if cast.blessingOfProtection(lowestUnit) then return end
                    end
                end

        -- Cleanse Toxins
                if isChecked("Cleanse Toxins") then
                    if getOptionValue("Cleanse Toxins")==1 then
                        if cast.cleanseToxins("player") then return end
                    end
                    if getOptionValue("Cleanse Toxins")==2 then
                        if cast.cleanseToxins("target") then return end
                    end
                    if getOptionValue("Cleanse Toxins")==3 then
                        if cast.cleanseToxins("mouseover") then return end
                    end
                end
        -- Lay On Hands
                if isChecked("Lay On Hands") then
                    -- if getHP(lowestUnit) < getOptionValue("Lay On Hands") and inCombat then
                    --     if cast.layOnHands(lowestUnit) then return end
                    -- end
                    if getOptionValue("Lay on Hands Target") == 1 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Lay on Hands") then
                                if cast.layOnHands(br.friend[i].unit) then return end
                            end
                        end
                    elseif getOptionValue("Lay on Hands Target") == 2 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Lay on Hands") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                                if cast.layOnHands(br.friend[i].unit) then return end
                            end
                        end
                    elseif getOptionValue("Lay on Hands Target") == 3 then
                        if php <= getValue("Lay on Hands") then
                            if cast.layOnHands("player") then return end
                        end
                    end
                end
        -- Divine Shield
                if isChecked("Divine Shield") then
                    if php <= getOptionValue("Divine Shield") and inCombat then
                        if cast.divineShield() then return end
                    end
                end

        -- Flash of Light
                if isChecked("Flash of Light") then
                    if (forceHeal or (inCombat and php <= getOptionValue("Flash of Light") / 2) or (not inCombat and php <= getOptionValue("Flash of Light"))) and not isMoving("player") then
                        if cast.flashOfLight() then return end
                    end
                end


        -- Redemption
                if isChecked("Redemption") then
                    if getOptionValue("Redemption")==1 and not isMoving("player") and resable then
                        if cast.redemption("target","dead") then return end
                    end
                    if getOptionValue("Redemption")==2 and not isMoving("player") and resable then
                        if cast.redemption("mouseover","dead") then return end
                    end
                end
            end
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                if isChecked("Avenger's Shield - INT") then
                    for i = 1, #enemies.yards30 do
                        local thisUnit = enemies.yards30[i]
                        local distance = getDistance(thisUnit)
                        if canInterrupt(thisUnit, 100) then
                            if distance < 30 then
                                if cast.avengersShield() then return end
                            end
                        end
                    end
                end
                for i = 1, #enemies.yards10 do
                    local thisUnit = enemies.yards10[i]
                    local distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Hammer of Justice
                        if isChecked("Hammer of Justice - INT") and distance < 10 then
                            if cast.hammerOfJustice(thisUnit) then return end
                        end
        -- Rebuke
                        if isChecked("Rebuke - INT") and distance < 5 then
                            if cast.rebuke(thisUnit) then return end
                        end
        -- Blinding Light
                        if isChecked("Blinding Light - INT") and distance < 10 then
                            if cast.blindingLight() then return end
                        end
                    end
                end
            end
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if useCDs() or burst then
            -- Trinkets
                if isChecked("Trinkets") and getDistance(units.dyn5) < 5 and buff.avengingWrath.remain() >= getOptionValue("Trinkets") then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
            end -- End Cooldown Usage Check
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
            -- PreCombat abilities listed here
        end -- End Action List - PreCombat
    -- Action List - Opener
        local function actionList_Opener()
            if isValidUnit("target") then
        -- Judgment
                if cast.judgment("target") then return end
        -- Start Attack
                if getDistance("target") < 5 then StartAttack() end
            end
        end -- End Action List - Opener
---------------------
--- Begin Profile ---
---------------------
    --Profile Stop | Pause
        if not inCombat and not hastar and profileStop == true then
            profileStop = false
        elseif (inCombat and profileStop == true) or (IsMounted() or IsFlying()) or pause() or mode.rotation == 4 then
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
----------------------------
--- Out of Combat Opener ---
----------------------------
            if actionList_Opener() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and profileStop==false then
------------------------------
--- In Combat - Interrupts ---
------------------------------
                if actionList_Interrupts() then return end
-----------------------------
--- In Combat - Cooldowns ---
-----------------------------
                if actionList_Cooldowns() then return end
----------------------------------
--- In Combat - Begin Rotation ---
----------------------------------
--------------------------------
--- In Combat - SimCraft APL ---
--------------------------------
--[[actions=auto_attack
actions+=/seraphim,if=talent.seraphim.enabled&action.shield_of_the_righteous.charges>=1.99
actions+=/avenging_wrath,if=!talent.seraphim.enabled|buff.seraphim.up
actions+=/use_item,name=horn_of_valor,if=buff.avenging_wrath.up
actions+=/potion,name=old_war,if=buff.avenging_wrath.up
actions+=/shield_of_the_righteous,if=(!talent.seraphim.enabled|buff.seraphim.up|action.shield_of_the_righteous.charges>2.5)
actions+=/bastion_of_light,if=(action.shield_of_the_righteous.charges<0.2)&(!talent.seraphim.enabled|buff.seraphim.up)
actions+=/judgment,if=!talent.crusaders_judgment.enabled|action.judgment.charges=2
actions+=/consecration
actions+=/avengers_shield
actions+=/judgment
actions+=/blessed_hammer
actions+=/eye_of_tyr
actions+=/blinding_light
actions+=/hammer_of_the_righteous]]

            -- Start Attack
                    if getDistance(units.dyn5) < 5 then
                        if not IsCurrentSpell(6603) then
                            StartAttack(units.dyn5)
                        end
                    end
            -- Racials
                    -- blood_fury
                    -- berserking
                    if isChecked("Racial") and useCDs() then
                        if race == "Orc" or race == "Troll" and getSpellCD(racial) == 0 then
                            if castSpell("player",racial,false,false,false) then return end
                        end
                    end

                    if useCDs() and getDistance(units.dyn5) < 5 then
            -- Seraphim
                            -- actions+=/seraphim,if=talent.seraphim.enabled&action.shield_of_the_righteous.charges>=1.99
                            if isChecked("Seraphim") and charges.frac.shieldOfTheRighteous >= 1.99 and (getOptionValue("Seraphim") <= ttd ) then
                                if cast.seraphim() then return end
                            end
            -- Avenging Wrath
                            -- actions+=/avenging_wrath,if=!talent.seraphim.enabled|buff.seraphim.up
                            if isChecked("Avenging Wrath") and (not talent.seraphim or buff.seraphim.remain() > 15) and (getOptionValue("Avenging Wrath") <= ttd ) then
                                if cast.avengingWrath() then return end
                            end

            -- Bastion of Light
                        -- actions+=/bastion_of_light,if=(action.shield_of_the_righteous.charges<0.2)&(!talent.seraphim.enabled|buff.seraphim.up)
                        if isChecked("Bastion of Light") and (charges.frac.shieldOfTheRighteous < 0.2) and (not talent.seraphim or buff.seraphim.exists()) then
                            if cast.bastionOfLight() then return end
                        end
                    end
            -- Shield of the Righteous
                        --actions+=/shield_of_the_righteous,if=(!talent.seraphim.enabled|buff.seraphim.up|action.shield_of_the_righteous.charges>2.5)
                        --if isChecked("Shield of the Righteous") and (not talent.seraphim or buff.seraphim.exists() or charges.frac.shieldOfTheRighteous > 2.5) then
                        if isChecked("Shield of the Righteous") and (charges.frac.shieldOfTheRighteous > 2.5) then
                            if cast.shieldOfTheRighteous(units.dyn5) then return end
                        end
            -- Avenger's Shield actions+=/avengers_shield
                    if isChecked("Avenger's Shield") then
                        if cast.avengersShield() then return end
                    end
            -- Consecration actions+=/consecration
                    if isChecked("Consecration") and not isMoving("player") and (not buff.consecration.exists()) and getDistance(units.dyn5) < 5 then
                        if cast.consecration() then return end
                    end
            -- Judgment actions+=/judgment
                    if isChecked("Judgment") then
                        if cast.judgment() then return end
                    end
            -- Blessed Hammer actions+=/blessed_hammer
                    if isChecked("Blessed Hammer") and getDistance(units.dyn5) < 5 then
                        if cast.blessedHammer() then return end
                    end
            -- Eye of Tyr actions+=/eye_of_tyr
                    if isChecked("Eye of Tyr") and getDistance(units.dyn5) < 5 then
                        if cast.eyeOfTyr() then return end
                    end
            -- Hammer of the Righteous actions+=/hammer_of_the_righteous
                    if isChecked("Hammer of the Righteous") and getDistance(units.dyn5) < 5 then
                        if cast.blessedHammer() then return end
                    end



            end -- End In Combat
        end -- End Profile
    end -- Timer
end -- runRotation
local id = 66
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
