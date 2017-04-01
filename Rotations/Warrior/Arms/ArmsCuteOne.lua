local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.cleave },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.whirlwind },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mortalStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.victoryRush}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.bladestorm },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.bladestorm },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.bladestorm }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dieByTheSword },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dieByTheSword }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.pummel },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    };
    CreateButton("Interrupt",4,0)
-- Movement Button
    MoverModes = {
        [1] = { mode = "On", value = 1 , overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap.", highlight = 1, icon = br.player.spell.charge },
        [2] = { mode = "Off", value = 2 , overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap.", highlight = 0, icon = br.player.spell.charge }
    };
    CreateButton("Mover",5,0)
-- Heroic Charge
    HeroicModes = {
        [1] = { mode = "On", value = 1 , overlay = "Heroic Charge Enabled", tip = "Will use Heroic Charge.", highlight = 1, icon = br.player.spell.heroicLeap },
        [2] = { mode = "Off", value = 2 , overlay = "Heroic Charge Disabled", tip = "Will NOT use Heroic Charge.", highlight = 0, icon = br.player.spell.heroicLeap }
    };
    CreateButton("Heroic",6,0)
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
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- AoE Slider
            br.ui:createSpinnerWithout(section, "AoE Threshold",  7,  1,  10,  1,  "|cffFFFFFFSet to desired targets to start AoE Rotation. Min: 1 / Max: 10 / Interval: 1")
            -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
            -- Berserker Rage
            br.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
            -- Charge
            br.ui:createCheckbox(section,"Charge", "Check to use Charge")
            -- Hamstring
            br.ui:createCheckbox(section,"Hamstring", "Check to use Hamstring")
            -- Heroic Leap
            br.ui:createDropdown(section,"Heroic Leap", br.dropOptions.Toggle, 6, "Set auto usage (No Hotkey) or desired hotkey to use Heroic Leap.")
            br.ui:createDropdownWithout(section,"Heroic Leap - Target",{"Best","Target"},1,"Desired Target of Heroic Leap")
            br.ui:createSpinner(section, "Heroic Charge",  15,  8,  25,  1,  "|cffFFFFFFSet to desired yards to Heroic Leap out to. Min: 8 / Max: 25 / Interval: 1")
            -- Shockwave
            br.ui:createCheckbox(section, "Shockwave")
            -- Storm Bolt
            br.ui:createCheckbox(section, "Storm Bolt")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Potion
            br.ui:createCheckbox(section, "Potion")
            -- Flask / Crystal
            br.ui:createCheckbox(section, "Flask / Crystal")
            -- Racial
            br.ui:createCheckbox(section, "Racial")
            -- Legendary Ring
            br.ui:createCheckbox(section, "Ring of Collapsing Futures")
            -- Draught of Souls
            br.ui:createCheckbox(section, "Draught of Souls")
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")
            -- Touch of the Void
            br.ui:createCheckbox(section,"Touch of the Void")
             -- Avatar
            br.ui:createDropdownWithout(section, "Avatar", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Avatar Ability.")
            -- Battle Cry
            br.ui:createDropdownWithout(section, "Battle Cry", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Battle Cry Ability.")
            -- Bladestorm
            br.ui:createSpinner(section, "Bladestorm",  5,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Bladestorm when set to AOE. Min: 1 / Max: 10 / Interval: 1")
            -- Ravager
            br.ui:createDropdown(section,"Ravager",{"Best","Target"},1,"Desired Target of Ravager")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone/Potion",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
            -- Commanding Shout
            br.ui:createSpinner(section, "Commanding Shout",  60,  0,  100,  5, "|cffFFBB00Health Percentage to use at.")
            -- Defensive Stance
            br.ui:createSpinner(section, "Defensive Stance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Die By The Sword
            br.ui:createSpinner(section, "Die by the Sword",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Intimidating Shout
            br.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Shockwave
            br.ui:createSpinner(section, "Shockwave - HP", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinner(section, "Shockwave - Units", 3, 1, 10, 1, "|cffFFBB00Minimal units to cast on.")
            -- Storm Bolt
            br.ui:createSpinner(section, "Storm Bolt", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Victory Rush
            br.ui:createSpinner(section, "Victory Rush", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Pummel
            br.ui:createCheckbox(section,"Pummel")
            -- Intimidating Shout
            br.ui:createCheckbox(section,"Intimidating Shoult - Int")
            -- Shockwave
            br.ui:createCheckbox(section,"Shockwave - Int")
            -- Storm Bolt
            br.ui:createCheckbox(section,"Storm Bolt - Int")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Mover Toggle
            br.ui:createDropdownWithout(section,  "Mover Mode", br.dropOptions.Toggle,  6)
            -- Heroic Toggle
            br.ui:createDropdownWithout(section,  "Heroic Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugArms", 0) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Mover",0.25)
        br.player.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]
        UpdateToggle("Heroic",0.25)
        br.player.mode.heroic = br.data.settings[br.selectedSpec].toggles["Heroic"]

--------------
--- Locals ---
--------------
        local addsExist                                     = false
        local addsIn                                        = 999
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local heirloomNeck                                  = 122667 or 122668
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powerDeficit, powerMax, powerGen       = br.player.power.amount.rage, br.player.power.rage.deficit, br.player.power.rage.max, br.player.power.regen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local recharge                                      = br.player.recharge
        local rage                                          = br.player.power.amount.rage
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local thp                                           = getHP(br.player.units(5))
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.ttm
        local units                                         = units or {}

        units.dyn5 = br.player.units(5)
        units.dyn8 = br.player.units(8)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards40 = br.player.enemies(40)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if focusTimer == nil then focusTimer = 0 end

        if useAvatar == nil then useAvatar = false end
        if cd.warbreaker <= 3 then usedWarbreaker = false end
        if getOptionValue("Battle Cry") == 3 or (getOptionValue("Battle Cry") == 2 and not useCDs()) then ignoreBattleCry = true else ignoreBattleCry = false end

        -- ChatOverlay(tostring(isInstanceBoss("target")))

        -- Heroic Leap for Charge (Credit: TitoBR)
        local function heroicLeapCharge()
            local thisUnit = units.dyn5
            local sX, sY, sZ = GetObjectPosition(thisUnit)
            local hitBoxCompensation = UnitCombatReach(thisUnit) / GetDistanceBetweenObjects("player",thisUnit)
            local yards = getOptionValue("Heroic Charge") + hitBoxCompensation
            for deg = 0, 360, 45 do
                local dX, dY, dZ = GetPositionFromPosition(sX, sY, sZ, yards, deg, 0)
                if TraceLine(sX, sY, sZ + 2.25, dX, dY, dZ + 2.25, 0x10) == nil and cd.heroicLeap == 0 and charges.charge > 0 then
                    if not IsAoEPending() then
                        CastSpellByName(GetSpellInfo(spell.heroicLeap))
                        -- cast.heroicLeap("player")
                    end
                    if IsAoEPending() then
                        ClickPosition(dX,dY,dZ)
                        break
                    end
                end
            end
        end

--------------------
--- Action Lists ---
--------------------
    -- Action list - Extras
        function actionList_Extra()
            -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end -- End Dummy Test
            -- Berserker Rage
            if isChecked("Berserker Rage") and hasNoControl(spell.berserkerRage) then
                if cast.berserkerRage() then return end
            end
        end -- End Action List - Extra
    -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() then
            -- Healthstone/Health Potion
                if isChecked("Healthstone/Potion") and php <= getOptionValue("Healthstone/Potion")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(getHealthPot()) then
                        useItem(getHealthPot())
                    end
                end
            -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(heirloomNeck) then
                        if canUse(heirloomNeck) then
                            useItem(heirloomNeck)
                        end
                    end
                end
            -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and br.player.race=="Draenei" and cd.giftOfTheNaaru == 0 then
                    if castSpell("player",racial,false,false,false) then return end
                end
            -- Commanding Shout
                if isChecked("Commanding Shout") and inCombat and php <= getOptionValue("Commanding Shout") then
                    if cast.commandingShout() then return end
                end
            -- Defensive Stance
                if isChecked("Defensive Stance") then
                    if php <= getOptionValue("Defensive Stance") and not buff.defensiveStance.exists() then
                        if cast.defensiveStance() then return end
                    elseif buff.defensiveStance.exists() then
                        if cast.defensiveStance() then return end
                    end
                end
            -- Die By The Sword
                if isChecked("Die By The Sword") and inCombat and php <= getOptionValue("Die By The Sword") then
                    if cast.dieByTheSword() then return end
                end
            -- Intimidating Shout
                if isChecked("Intimidating Shout") and inCombat and php <= getOptionValue("Intimidating Shout") then
                    if cast.intimidatingShout() then return end
                end
            -- Shockwave
                if inCombat and ((isChecked("Shockwave - HP") and php <= getOptionValue("Shockwave - HP")) or (isChecked("Shockwave - Units") and #enemies.yards8 >= getOptionValue("Shockwave - Units"))) then
                    if cast.shockwave() then return end
                end
            -- Storm Bolt
                if inCombat and isChecked("Storm Bolt") and php <= getOptionValue("Storm Bolt") then
                    if cast.stormBolt() then return end
                end
            -- Victory Rush
                if inCombat and isChecked("Victory Rush") and php <= getOptionValue("Victory Rush") and buff.victorious.exists() then
                    if cast.victoryRush() then return end
                end
            end -- End Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards40 do
                    thisUnit = enemies.yards40[i]
                    unitDist = getDistance(thisUnit)
                    targetMe = UnitIsUnit("player",thisUnit) or false
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                    -- Pummel
                        if isChecked("Pummel") and unitDist < 5 then
                            if cast.pummel(thisUnit) then return end
                        end
                    -- Intimidating Shout
                        if isChecked("Intimidating Shout - Int") and unitDist < 8 then
                            if cast.intimidatingShout() then return end
                        end
                    -- Shockwave
                        if isChecked("Shockwave - Int") and unitDist < 10 then
                            if cast.shockwave() then return end
                        end
                    -- Storm Bolt
                        if isChecked("Storm Bolt - Int") and unitDist < 20 then
                            if cast.stormBolt() then return end
                        end
                    end
                end
            end
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        function actionList_Cooldowns()
            if getDistance(units.dyn5) < 5 then
            -- Ring of Collapsing Futures
                if buff.battleCry.exists() or ignoreBattleCry then
                    if isChecked("Ring of Collapsing Futures") and hasEquiped(142173) and canUse(142173) and select(2,IsInInstance()) ~= "pvp"  then
                        useItem(142173)
                        return true
                    end
                end
            -- Draught of Souls
                --draught_of_souls,if=equipped.draught_of_souls&((prev_gcd.1.mortal_strike|cooldown.mortal_strike.remains>=3)&buff.battle_cry.remains>=3&debuff.colossus_smash.up&buff.avatar.remains>=3)
                if hasEquiped(140808) and ((lastCast == spell.mortalStrike or cd.mortalStrike >= 3) and buff.battleCry.remain() >= 3 and debuff.colossusSmash.exists(units.dyn5) and buff.avatar.remain() >= 3) then
                    useItem(140808)
                    return true
                end
            -- Potion
                -- potion,name=old_war,if=buff.avatar.up&buff.battle_cry.up&debuff.colossus_smash.up|target.time_to_die<=26
                -- if useCDs() and canUse(strPot) and inRaid and isChecked("Potion") then
                --     if (buff.avatar.exists() and buff.battleCry.exists() and debuff.colossusSmash[units.dyn5].exists()) or ttd(units.dyn5) <= 26 then
                --         useItem(strPot)
                --     end
                -- end
            -- Racials
                -- blood_fury,if=buff.battle_cry.up|target.time_to_die<=16
                -- berserking,if=buff.battle_cry.up|target.time_to_die<=11
                -- arcane_torrent,if=buff.battle_cry_deadly_calm.down&rage.deficit>40
                if useCDs() and isChecked("Racial") and getSpellCD(racial) == 0 and ((br.player.race == "Orc" and (buff.battleCry.exists() or ignoreBattleCry or ttd(units.dyn5) <= 16))
                    or (br.player.race == "Troll" and (buff.battleCry.exists() or ignoreBattleCry or ttd(units.dyn5) <= 11))
                    or (br.player.race == "BloodElf" and (not buff.battleCry.exists() and powerDeficit > 40)))
                then
                    if castSpell("player",racial,false,false,false) then return end
                end
            -- Touch of the Void
                if useCDs() and isChecked("Touch of the Void") then
                    if hasEquiped(128318) then
                        if GetItemCooldown(128318)==0 then
                            useItem(128318)
                        end
                    end
                end
            -- Trinkets
                if useCDs() and getOptionValue("Trinkets") ~= 4 then
                    if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUse(13) then
                        useItem(13)
                    end
                    if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUse(14) then
                        useItem(14)
                    end
                end
            end
        end -- End Action List - Cooldowns
    -- Action List - Pre-Combat
        function actionList_PreCombat()
        -- Flask
            -- flask,type=greater_draenic_strength_flask
            if isChecked("Str-Pot") then
                if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",176151) then
                    useItem(br.player.flask.wod.strengthBig)
                    return true
                end
                if flaskBuff==0 then
                    if br.player.useCrystal() then return end
                end
            end
            -- food,type=sleeper_sushi
            -- snapshot_stats
            -- potion,name=draenic_strength
            -- if useCDs() and inRaid and isChecked("Str-Pot") and isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
            --     if canUse(109219) then
            --         useItem(109219)
            --     end
            -- end
        end  -- End Action List - Pre-Combat
    -- Action List - Movement
        function actionList_Movement()
            if mode.mover == 1 and isValidUnit("target") then
        -- Heroic Leap
                -- -- heroic_leap
                if isChecked("Heroic Leap") and (getOptionValue("Heroic Leap")==6 or (SpecificToggle("Heroic Leap") and not GetCurrentKeyBoardFocus())) then
                    -- Best Location
                    if getOptionValue("Heroic Leap - Target") == 1 then
                        if cast.heroicLeap("best",nil,1,8) then return end
                    end
                    -- Target
                    if getOptionValue("Heroic Leap - Target") == 2 then
                        if cast.heroicLeap("target","ground") then return end
                    end
                end
        -- Charge
                -- charge
                if isChecked("Charge") then
                    if (cd.heroicLeap > 0 and cd.heroicLeap < 29) or not isChecked("Heroic Leap") or level < 26 then
                        if cast.charge("target") then return end
                    end
                end
        -- Storm Bolt
                -- storm_bolt
                if cast.stormBolt("target") then return end
        -- Heroic Throw
                -- heroic_throw
                if lastSpell == spell.charge or charges.charge == 0 or not isChecked("Charge") then
                    if cast.heroicThrow("target") then return end
                end
            end
        end
    -- Action List - MortalCry
        function actionList_MortalCry()
            if cd.mortalStrike == 0 then
                if talent.focusedRage then
                    if cast.focusedRage() then end
                end
                if cd.battleCry == 0 then
                    if cast.battleCry() then bcCast = GetTime(); end
                end
                if cast.mortalStrike() then msCast = GetTime(); end
            end
            return
        end
    -- Action List - Bladestorm
        function actionList_Bladestorm()
            -- if cd.bladestorm > gcd or level < 65 then return end
            if isChecked("Bladestorm") and getDistance(units.dyn5) < 5 then
                if #enemies.yards8 >= getOptionValue("Bladestorm") then
                    if artifact.warbreaker then
                        if cast.warbreaker("player") then usedWarbreaker = true; end
                    end
                    if cd.warbreaker > 3 or not artifact.warbreaker then
                        if cast.bladestorm() then return end
                    end
                end
                if (cd.warbreaker > 3 or not artifact.warbreaker) and #enemies.yards8 >= getOptionValue("AoE Threshold") then
                    if cast.bladestorm() then return end
                end
            end
        end
    -- Action List - Execute
        function actionList_Execute()
        -- Action List - Bladestorm
            if actionList_Bladestorm() then return end
            for i = 1, #enemies.yards8 do
                local executeUnit = enemies.yards8[i]
                if getDistance(executeUnit) < 5 and getFacing("player",executeUnit) then
                    if getHP(executeUnit) <= 20 then
                        -- if IsCurrentSpell(6603) and not UnitIsUnit(units.dyn5,executeUnit) then
                        --     StopAttack()
                        -- else
                        --     StartAttack(executeUnit)
                        -- end
        -- Focused Rage
                        if (buff.focusedRage.stack() < 3 and (buff.battleCry.exists() or ignoreBattleCry)) or powerDeficit < 25 or (buff.focusedRage.remain() < 3 and buff.focusedRage.stack() > 0) then
                            if cast.focusedRage(executeUnit) then return end
                        end
        -- Battle Cry
                        if (getOptionValue("Battle Cry") == 1 or (getOptionValue("Battle Cry") == 2 and useCDs())) then
                            if cd.battleCry == 0 and cd.mortalStrike == 0 and cd.colossusSmash > 2 and getDistance(units.dyn5) < 5 and lastSpell ~= spell.charge and lastSpell ~= spell.heroicThrow then
                                -- if cast.battleCry() then return end
                                if actionList_MortalCry() then return end
                            end
                        end
        -- Mortal Strike
                        -- mortal_strike,if=cooldown_react&buff.battle_cry.up&buff.focused_rage.stack()=3
                        if ((buff.battleCry.exists() or ignoreBattleCry) and buff.focusedRage.stack() == 3) or ((buff.focusedRage.remain() < cd.battleCry and cd.battleCry < 5) or (buff.focusedRage.remain() < 5 and ignoreBattleCry)) then
                            if cast.mortalStrike(executeUnit) then return end
                        end
        -- Heroic Charge
                        -- heroic_charge,if=rage.deficit>=40&(!cooldown.heroic_leap.remain()s|swing.mh.remain()s>1.2)
                        if mode.heroic == 1 and powerDeficit >= 40 and (cd.heroicLeap == 0 or swingTimer > 1.2) and getDistance(units.dyn5) < 5 then
                            heroicLeapCharge()
                        end
        -- Execute
                        -- execute,if=buff.battle_cry_deadly_calm.up
                        if (debuff.colossusSmash.exists(units.dyn5) or (cd.colossusSmash ~= 0 and (cd.warbreaker ~= 0 or not artifact.warbreaker
                            or (getOptionValue("Artifact") == 2 and not useCDs()) or getOptionValue("Artifact") == 3))) and buff.shatteredDefenses.exists()
                            and ((buff.battleCry.exists() or ignoreBattleCry) and talent.deadlyCalm)
                        then
                            if cast.execute(executeUnit) then return end
                        end
        -- Warbreaker
                        -- warbreaker,if=debuff.colossus_smash.remain()s<gcd
                        if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
                            if not buff.shatteredDefenses.exists() and cd.colossusSmash > gcd and getDistance(units.dyn5) < 5 then
                                if cast.warbreaker("player") then usedWarbreaker = true; return end
                            end
                        end
        -- Colossus Smash
                        -- colossus_smash,if=cooldown_react&buff.shattered_defenses.down
                        if debuff.colossusSmash.remain(units.dyn5) < gcd or not buff.shatteredDefenses.exists() then
                            if cast.colossusSmash(executeUnit) then return end
                        end
        -- Avatar
                        -- avatar,if=gcd.remain()s<0.25&(buff.battle_cry.up|cooldown.battle_cry.remain()s<15)|target.time_to_die<=20
                        if (getOptionValue("Avatar") == 1 or (getOptionValue("Avatar") == 2 and useCDs())) then
                            if (buff.battleCry.exists() or cd.battleCry < 15) and lastSpell ~= spell.charge and lastSpell ~= spell.heroicThrow then
                                if cast.avatar() then return end
                            end
                        end
        -- Execute
                        -- execute,if=buff.shattered_defenses.up&(rage>=17.6|buff.stone_heart.react)
                        if (debuff.colossusSmash.exists(units.dyn5) or (cd.colossusSmash ~= 0 and (cd.warbreaker ~= 0 or not artifact.warbreaker
                            or (getOptionValue("Artifact") == 2 and not useCDs()) or getOptionValue("Artifact") == 3))) and buff.shatteredDefenses.exists()
                            and (rage >= 17.6 or buff.stoneHeart.exists())
                        then
                            if cast.execute(executeUnit) then return end
                        end
        -- Mortal Strike
                        -- mortal_strike,if=cooldown_react&equipped.archavons_heavy_hand&rage<60
                        if hasEquiped(137060) and rage < 60 then
                            if cast.mortalStrike(executeUnit) then return end
                        end
        -- Execute
                        -- execute,if=buff.shattered_defenses.down
                        if (debuff.colossusSmash.exists(units.dyn5) or (cd.colossusSmash ~= 0 and (cd.warbreaker ~= 0 or not artifact.warbreaker
                            or (getOptionValue("Artifact") == 2 and not useCDs()) or getOptionValue("Artifact") == 3))) and not buff.shatteredDefenses.exists()
                        then
                            if cast.execute(executeUnit) then return end
                        end
                    else
                        return
                    end
                end
            end
        end -- End Action List - Execute
    -- Action List - Single
        function actionList_Single()
        -- Action List - Bladestorm
            if actionList_Bladestorm() then return end
        -- Warbreaker
            -- warbreaker,if=debuff.colossus_smash.remain()s<gcd
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
                if not buff.shatteredDefenses.exists() and cd.colossusSmash > gcd and getDistance(units.dyn5) < 5 then
                    if cast.warbreaker("player") then usedWarbreaker = true; return end
                end
            end
        -- Colossus Smash
            -- colossus_smash,if=cooldown_react&buff.shattered_defenses.down&(buff.battle_cry.down|buff.battle_cry.up&buff.battle_cry.remain()s>=gcd)
            if debuff.colossusSmash.remain(units.dyn5) < gcd or (not buff.shatteredDefenses.exists() and (not buff.battleCry.exists() or (buff.battleCry.exists() and buff.battleCry.remain() >= gcd))) then
                if cast.colossusSmash() then return end
            end
        -- Heroic Charge
            -- heroic_charge,if=rage.deficit>=40&(!cooldown.heroic_leap.remain()s|swing.mh.remain()s>1.2)
            if mode.heroic == 1 and powerDeficit >= 40 and (cd.heroicLeap == 0 or swingTimer > 1.2) and getDistance(units.dyn5) < 5 then
                heroicLeapCharge()
            end
        -- Avatar
            -- avatar,if=gcd.remain()s<0.25&(buff.battle_cry.up|cooldown.battle_cry.remain()s<15)|target.time_to_die<=20
            if (getOptionValue("Avatar") == 1 or (getOptionValue("Avatar") == 2 and useCDs())) then
                if (buff.battleCry.exists() or cd.battleCry < 15) and lastSpell ~= spell.charge and lastSpell ~= spell.heroicThrow then
                    if cast.avatar() then return end
                end
            end
        -- Focused Rage
            -- focused_rage,if=!buff.battle_cry_deadly_calm.up&buff.focused_rage.stack()<3&!cooldown.colossus_smash.up&(rage>=50|debuff.colossus_smash.down|cooldown.battle_cry.remain()s<=8)
            if ((buff.battleCry.remain() > cd.focusedRage or ignoreBattleCry) and (buff.focusedRage.stack() < 3 or cd.mortalStrike > 0))
                or (not ((buff.battleCry.exists() or ignoreBattleCry) and talent.deadlyCalm) and buff.focusedRage.stack() < 3 and cd.colossusSmash > 0
                    and (rage >= 50 or not debuff.colossusSmash.exists(units.dyn5) or cd.battleCry <= 8))
            then
                -- if cast.focusedRage() then return end
                cast.focusedRage()
            end
        -- Battle Cry
            if (getOptionValue("Battle Cry") == 1 or (getOptionValue("Battle Cry") == 2 and useCDs())) then
                if cd.battleCry == 0 and cd.mortalStrike == 0 --[[and cd.colossusSmash > 2]] and getDistance(units.dyn5) < 5 and lastSpell ~= spell.charge and lastSpell ~= spell.heroicThrow then
                    -- if cast.battleCry() then return end
                    if actionList_MortalCry() then return end
                end
            end
        -- Mortal Strike
            if cd.battleCry > gcd or ignoreBattleCry then
                if cast.mortalStrike() then return end
            end
        -- Execute
            -- execute,if=buff.stone_heart.react
            if buff.stoneHeart.exists() then
                if cast.execute() then return end
            end
            if (cd.mortalStrike > gcd and cd.colossusSmash > gcd) or level < 20 then
                if ((mode.rotation == 1 and #enemies.yards8 > 1) or mode.rotation == 2) and level >= 40 then
        -- Cleave
                    if cast.cleave() then return end
        -- Whirlwind
                    if cast.whirlwind() then return end
                elseif ((mode.rotation == 1 and #enemies.yards8 == 1) or mode.rotation == 3) or level < 40 then
        -- Slam
                    if rage > 32 or ((buff.battleCry.exists() or ignoreBattleCry) and talent.deadlyCalm) then
                        if cast.slam() then return end
                    end
                end
            end
        -- Focused Rage
            -- focused_rage,if=equipped.archavons_heavy_hand&buff.focused_rage.stack()<3
            if hasEquiped(137060) and buff.focusedRage.stack() < 3 then
                if cast.focusedRage() then return end
            end
        end -- End Action List - Single
    -- Action List - MultiTarget
        function actionList_MultiTarget()
        -- Action List - Bladestorm
            if actionList_Bladestorm() then return end
        -- Avatar
            if (getOptionValue("Avatar") == 1 or (getOptionValue("Avatar") == 2 and useCDs())) then
                if lastSpell ~= spell.charge and lastSpell ~= spell.heroicThrow then
                    if cast.avatar() then return end
                end
            end
        -- Warbreaker
            -- warbreaker,if=buff.shattered_defenses.down
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and getDistance(units.dyn5) < 5 then
                if cast.warbreaker("player") then usedWarbreaker = true; return end
            end
        -- Battle Cry
            if (getOptionValue("Battle Cry") == 1 or (getOptionValue("Battle Cry") == 2 and useCDs())) then
                if (usedWarbreaker and cd.bladestorm == 0) or cd.bladestorm > 2 then
                    if cast.battleCry() then return end
                end
            end
        -- Cleave
            -- cleave
            if cast.cleave() then return end
        -- Whirlwind
            -- whirlwind,if=rage>=40
            if rage >= 40 and level >= 40 then
                if cast.whirlwind() then return end
            end
        -- Single/Execute
            if rage < 20 or level < 40 then
                -- run_action_list,name=execute,target_if=target.health.pct<=20&spell_targets.whirlwind<5
                if level >= 8 then
                    if actionList_Execute() then return end
                end
                -- run_action_list,name=single,if=target.health.pct>20
                if getHP(units.dyn5) > 20 or level < 8 then
                    if actionList_Single() then return end
                end
            end
        end -- End Action List - MultiTarget
-----------------
--- Rotations ---
-----------------
        if actionList_Extra() then return end
        if actionList_Defensive() then return end
        -- Pause
        if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 4 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and isValidUnit("target") then
                if actionList_PreCombat() then return end
                if getDistance(units.dyn5)<5 then
                    if not IsCurrentSpell(6603) then
                        StartAttack(units.dyn5)
                    end
                else
            -- Action List - Movement
                    -- run_action_list,name=movement,if=movement.getDistance(units.dyn5)>5
                    -- if getDistance("target") >= 8 then
                        if actionList_Movement() then return end
                    -- end
                end
            end
-----------------------------
--- In Combat - Rotations ---
-----------------------------
            if inCombat and isValidUnit(units.dyn5) then
            -- Auto Attack
                --auto_attack
                -- if IsCurrentSpell(6603) and not UnitIsUnit(units.dyn5,"target") then
                --     StopAttack()
                -- else
                --     StartAttack(units.dyn5)
                -- end
                if not IsCurrentSpell(6603) then
                    StartAttack(units.dyn5)
                end
            -- Action List - Movement
                -- run_action_list,name=movement,if=movement.getDistance(units.dyn5)>5
                -- if getDistance(units.dyn8) > 8 then
                    if actionList_Movement() then return end
                -- end
            -- Action List - Interrupts
                if actionList_Interrupts() then return end
            -- Action List - Cooldowns
                if actionList_Cooldowns() then return end
            -- Rend
                -- rend,if=remains<gcd
                if debuff.rend.remain(units.dyn5) < gcd then
                    if cast.rend() then return end
                end
            -- Ravager
                -- ravager
                if useCDs() and isChecked("Ravager") then
                    -- Best Location
                    if getOptionValue("Ravager") == 1 then
                        if cast.ravager("best",nil,1,8) then return end
                    end
                    -- Target
                    if getOptionValue("Ravager") == 2 then
                        if cast.ravager("target","ground") then return end
                    end
                end
            -- Overpower
                -- overpower,if=buff.overpower.react
                if buff.overpower.exists() then
                    if cast.overpower() then return end
                end
            -- Action List - Bladestorm
                if actionList_Bladestorm() then return end
            -- Action List - Multitarget
                -- run_action_list,name=aoe,if=spell_targets.whirlwind>=5&!talent.sweeping_strikes.enabled
                if ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("AoE Threshold")) or mode.rotation == 2) then
                    if actionList_MultiTarget() then return end
                end
                if #enemies.yards5 > 0 and ((mode.rotation == 1 and #enemies.yards5 < getOptionValue("AoE Threshold")) or mode.rotation == 3) then
            -- Action List - Single/Execute
                    -- run_action_list,name=execute,target_if=target.health.pct<=20&spell_targets.whirlwind<5
                    if level >= 8 then
                        if actionList_Execute() then return end
                    end
                    -- run_action_list,name=single,if=target.health.pct>20
                    if getHP(units.dyn5) > 20 or level < 8 then
                        if actionList_Single() then return end
                    end
                end
            end -- End Combat Rotation
        end -- Pause
    end -- End Timer
end -- runRotation
local id = 71
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
