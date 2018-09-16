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
            br.ui:createSpinnerWithout(section, "AoE Threshold",  2,  1,  10,  1,  "|cffFFFFFFSet to desired targets to start AoE Rotation. Min: 1 / Max: 10 / Interval: 1")
            -- Battle Cry
            br.ui:createCheckbox(section, "Battle Shout")
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
            -- Sweeping Strikes
            br.ui:createCheckbox(section,"Sweeping Strikes")
            -- Warbreaker
            br.ui:createCheckbox(section,"Warbreaker")
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
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")
            -- Touch of the Void
            br.ui:createCheckbox(section,"Touch of the Void")
             -- Avatar
            br.ui:createCheckbox(section, "Avatar")
            -- Bladestorm
            br.ui:createSpinner(section, "Bladestorm",  5,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Bladestorm when set to AOE. Min: 1 / Max: 10 / Interval: 1")
            -- Ravager
            br.ui:createDropdownWithout(section,"Ravager",{"Best","Target","Never"},1,"Desired Target of Ravager")
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
            -- Defensive Stance
            br.ui:createSpinner(section, "Defensive Stance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Die By The Sword
            br.ui:createSpinner(section, "Die by the Sword",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Intimidating Shout
            br.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Rallying Cry
            br.ui:createSpinner(section, "Rallying Cry",  60,  0,  100,  5, "|cffFFBB00Health Percentage to use at.")
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
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local equiped                                       = br.player.equiped
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local hastar                                        = hastar or GetObjectExists("target")
        local heirloomNeck                                  = 122667 or 122668
        local inCombat                                      = br.player.inCombat
        local inRaid                                        = br.player.instance == "raid"
        local level                                         = br.player.level
        local mode                                          = br.player.mode
        local php                                           = br.player.health
        local power                                         = br.player.power.rage.amount()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local rage                                          = br.player.power.rage.amount()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local thp                                           = getHP("target")
        local traits                                        = br.player.traits
        local units                                         = br.player.units

        units.get(5)
        units.get(8)
        enemies.get(8)
        enemies.get(20)

        if profileStop == nil then profileStop = false end

        -- Heroic Leap for Charge (Credit: TitoBR)
        local function heroicLeapCharge()
            local thisUnit = units.dyn5
            local sX, sY, sZ = GetObjectPosition(thisUnit)
            local hitBoxCompensation = UnitCombatReach(thisUnit) / GetDistanceBetweenObjects("player",thisUnit)
            local yards = getOptionValue("Heroic Charge") + hitBoxCompensation
            for deg = 0, 360, 45 do
                local dX, dY, dZ = GetPositionFromPosition(sX, sY, sZ, yards, deg, 0)
                if TraceLine(sX, sY, sZ + 2.25, dX, dY, dZ + 2.25, 0x10) == nil and cd.heroicLeap.remain() == 0 and charges.charge.count() > 0 then
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
        -- Battle Shout
            if isChecked("Battle Shout") and cast.able.battleShout() then
                for i = 1, #br.friend do
                    local thisUnit = br.friend[i].unit
                    if getDistance(thisUnit) < 100 and buff.battleShout.remain(thisUnit) < 600 then
                        if cast.battleShout() then return end
                    end
                end
            end
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
                if isChecked("Gift of the Naaru") and cast.able.racial() and php <= getOptionValue("Gift of the Naaru") and race=="Draenei" and cd.giftOfTheNaaru.remain() == 0 then
                    if cast.racial() then return end
                end
            -- Defensive Stance
                if isChecked("Defensive Stance") and cast.able.defensiveStance() then
                    if php <= getOptionValue("Defensive Stance") and not buff.defensiveStance.exists() then
                        if cast.defensiveStance() then return end
                    elseif buff.defensiveStance.exists() and php > getOptionValue("Defensive Stance") then
                        if cast.defensiveStance() then return end
                    end
                end
            -- Die By The Sword
                if isChecked("Die By The Sword") and cast.able.dieByTheSword() and inCombat and php <= getOptionValue("Die By The Sword") then
                    if cast.dieByTheSword() then return end
                end
            -- Intimidating Shout
                if isChecked("Intimidating Shout") and cast.able.intimidatingShout() and inCombat and php <= getOptionValue("Intimidating Shout") then
                    if cast.intimidatingShout() then return end
                end
            -- Rallying Cry
                if isChecked("Rallying Cry") and cast.able.rallyingCry() and inCombat and php <= getOptionValue("Rallying Cry") then
                    if cast.rallyingCry() then return end
                end
            -- Storm Bolt
                if isChecked("Storm Bolt") and cast.able.stormBolt() and inCombat and php <= getOptionValue("Storm Bolt") then
                    if cast.stormBolt() then return end
                end
            -- Victory Rush
                if isChecked("Victory Rush") and (cast.able.victoryRush() or cast.able.impendingVictory()) and inCombat and php <= getOptionValue("Victory Rush") and buff.victorious.exists() then
                    if talent.impendingVictory then
                        if cast.impendingVictory() then return end
                    else
                        if cast.victoryRush() then return end
                    end
                end
            end -- End Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards20 do
                    thisUnit = enemies.yards20[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                    -- Pummel
                        if isChecked("Pummel") and cast.able.pummel(thisUnit) and distance < 5 then
                            if cast.pummel(thisUnit) then return end
                        end
                    -- Intimidating Shout
                        if isChecked("Intimidating Shout - Int") and cast.able.intimidatingShout() and distance < 8 then
                            if cast.intimidatingShout() then return end
                        end
                    -- Storm Bolt
                        if isChecked("Storm Bolt - Int") and cast.able.stormBolt(thisUnit) and distance < 20 then
                            if cast.stormBolt(thisUnit) then return end
                        end
                    end
                end
            end
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        function actionList_Cooldowns()
            if getDistance(units.dyn5) < 5 and useCDs() then
            -- Potion
                -- potion
                if isChecked("Potion") and inRaid then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
            -- Racials
                -- actions+=/blood_fury,if=debuff.colossus_smash.up
                -- actions+=/berserking,if=debuff.colossus_smash.up
                -- actions+=/arcane_torrent,if=debuff.colossus_smash.down&cooldown.mortal_strike.remains>1.5&rage<50
                -- actions+=/lights_judgment,if=debuff.colossus_smash.down
                -- actions+=/fireblood,if=debuff.colossus_smash.up
                -- actions+=/ancestral_call,if=debuff.colossus_smash.up
                if isChecked("Racial") and cast.able.racial()
                    and ((debuff.colossusSmash.exists(units.dyn5) and (race == "Orc" or race == "Troll" or race == "DarkIronDwarf" or race == "MagharOrc"))
                    or (not debuff.colossusSmash.exists(units.dyn5) and ((race == "BloodElf" and cd.mortalStrike.remain() > 1.5 and power < 50) or race == "LightforgedDraenei")))
                then
                    if race == "LightforgedDraenei" then
                        if cast.racial("target","ground") then return true end
                    else
                        if cast.racial("player") then return true end
                    end
                end
            -- Avatar
                -- avatar,if=cooldown.colossus_smash.remains<8|(talent.warbreaker.enabled&cooldown.warbreaker.remains<8)
                if isChecked("Avatar") and cast.able.avatar() then
                    if cd.colossusSmash.remain() < 8 or (talent.warbreaker and cd.warbreaker.remain() < 8) then
                        if cast.avatar() then return end
                    end
                end
            -- Touch of the Void
                if isChecked("Touch of the Void") then
                    if hasEquiped(128318) then
                        if GetItemCooldown(128318)==0 then
                            useItem(128318)
                        end
                    end
                end
            -- Trinkets
                if getOptionValue("Trinkets") ~= 4 then
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
                -- heroic_leap
                if isChecked("Heroic Leap") and cast.able.heroicLeap() and (getOptionValue("Heroic Leap")==6 or (SpecificToggle("Heroic Leap") and not GetCurrentKeyBoardFocus())) then
                    -- Best Location
                    if getOptionValue("Heroic Leap - Target") == 1 then
                        if cast.heroicLeap("best",nil,1,8) then return end
                    end
                    -- Target
                    if getOptionValue("Heroic Leap - Target") == 2 and getDistance("target") >= 8 then
                        if cast.heroicLeap("target","ground") then return end
                    end
                end
        -- Charge
                -- charge
                if isChecked("Charge") and cast.able.charge("target") and getDistance("target") >= 8 then
                    if (cd.heroicLeap.remain() > 0 and cd.heroicLeap.remain() < 43) or not isChecked("Heroic Leap") or level < 26 then
                        if cast.charge("target") then return end
                    end
                end
        -- Storm Bolt
                -- storm_bolt
                if isChecked("Storm Bolt") and cast.able.stormBolt("target") then
                    if cast.stormBolt("target") then return end
                end
        -- Heroic Throw
                -- heroic_throw
                if cast.able.heroicThrow() and getDistance("target") >= 8 and (cast.last.charge() or charges.charge.count() == 0 or not isChecked("Charge")) then
                    if cast.heroicThrow("target") then return end
                end
            end
        end
    -- Action List - Execute
        function actionList_Execute()
        -- Rend
            -- rend,if=remains<=duration*0.3&debuff.colossus_smash.down
            if cast.able.rend() and debuff.rend.refresh(units.dyn5) and not debuff.colossusSmash.exists(units.dyn5) then
                if cast.rend() then return end
            end
        -- Skullsplitter
            -- skullsplitter,if=rage<70&((cooldown.deadly_calm.remains>3&!buff.deadly_calm.up)|!talent.deadly_calm.enabled)
            if cast.able.skullsplitter() and power < 70 and ((cd.deadlyCalm.remain() > 3 and not buff.deadlyCalm.exists()) or not talent.deadlyCalm) then
                if cast.skullsplitter() then return end
            end
        -- Deadly Calm
            -- deadly_calm,if=cooldown.bladestorm.remains>6&((cooldown.colossus_smash.remains<2|(talent.warbreaker.enabled&cooldown.warbreaker.remains<2))|(equipped.weight_of_the_earth&cooldown.heroic_leap.remains<2))
            if cast.able.deadlyCalm() and ((cd.bladestorm.remain() > 6 or not isChecked("Bladestorm") or #enemies.yards8 < getOptionValue("Bladestorm"))
                and ((cd.colossusSmash.remain() < 2 or (talent.warbreaker and cd.warbreaker.remain() < 2)) or (equiped.weightOfTheEarth and cd.heroicLeap.remain() < 2)))
            then
                if cast.deadlyCalm() then return end
            end
        -- Colossus Smash
            -- colossus_smash,if=debuff.colossus_smash.down
            if cast.able.colossusSmash() and (not debuff.colossusSmash.exists(units.dyn5))
                and ((mode.rotation == 1 and #enemies.yards8 < getOptionValue("AoE Threshold")) or (mode.rotation == 3 and #enemies.yards8 > 0) or not talent.warbreaker)
            then
                if cast.colossusSmash() then return end
            end
        -- Warbreaker
            -- warbreaker,if=debuff.colossus_smash.down
            if isChecked("Warbreaker") and cast.able.warbreaker() and talent.warbreaker and (not debuff.colossusSmash.exists(units.dyn5))
                and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("AoE Threshold")) or (mode.rotation == 2 and #enemies.yards8 > 0))
            then
                if cast.warbreaker() then return end
            end
        -- Heroic Charge
            -- heroic_leap,if=equipped.weight_of_the_earth&debuff.colossus_smash.down&((cooldown.colossus_smash.remains>8&!prev_gcd.1.colossus_smash)|(talent.warbreaker.enabled&cooldown.warbreaker.remains>8&!prev_gcd.1.warbreaker))
            if cast.able.heroicLeap() and isChecked("Heroic Charge") and mode.heroic == 1 and (equiped.weightOfTheEarth and not debuff.colossusSmash.exists(units.dyn5)
            and ((cd.colossusSmash.remain() > 8 and not cast.last.colossusSmash()) or (talent.warbreaker and cd.warbreaker.remain() > 8 and not cast.last.warbreaker())))
            then
                heroicLeapCharge()
            end
        -- Bladestorm
            -- bladestorm,if=debuff.colossus_smash.remains>4.5&rage<70&(!buff.deadly_calm.up|!talent.deadly_calm.enabled)
            if cast.able.bladestorm(nil,"aoe") and isChecked("Bladestorm") and not talent.ravager and getDistance(units.dyn8) < 8
                and (debuff.colossusSmash.remain(units.dyn5) > 4.5 and rage < 70 and (not buff.deadlyCalm.exists() or not talent.deadlyCalm))
            then
                if cast.bladestorm(nil,"aoe") then return end
            end
        -- Ravager
            -- ravager,if=debuff.colossus_smash.up&(cooldown.deadly_calm.remains>6|!talent.deadly_calm.enabled)
            if cast.able.ravager() and useCDs() and getOptionValue("Ravager") ~= 3 and talent.ravager
                and (debuff.colossusSmash.exists(units.dyn5) and (cd.deadlyCalm.remain() > 6 or not talent.deadlyCalm))
            then
                -- Best Location
                if getOptionValue("Ravager") == 1 then
                    if cast.ravager("best",nil,1,8) then return end
                end
                -- Target
                if getOptionValue("Ravager") == 2 then
                    if cast.ravager("target","ground") then return end
                end
            end
        -- Cleave
            -- cleave,if=spell_targets.whirlwind>2
            if cast.able.cleave(nil,"aoe") and ((mode.rotation == 1 and #enemies.yards8 > 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                if cast.cleave(nil,"aoe") then return end
            end
        -- Mortal Strike
            -- mortal_strike,if=buff.overpower.stack=2&(talent.dreadnaught.enabled|equipped.archavons_heavy_hand)
            if cast.able.mortalStrike() and (buff.overpower.stack() == 2 and (talent.dreadnaught or equiped.archavonsHeavyHand)) then
                if cast.mortalStrike() then return end
            end
        -- Overpower
            -- overpower
            if cast.able.overpower() then
                if cast.overpower() then return end
            end
        -- Execute
            -- execute,if=rage>=40|debuff.colossus_smash.up|buff.sudden_death.react|buff.stone_heart.react
            if cast.able.execute() and (rage >= 40 or debuff.colossusSmash.exists(units.dyn5) or buff.suddenDeath.exists() or buff.stoneHeart.exists()) then
                if cast.execute() then return end
            end
        end -- End Action List - Execute
    -- Action List - Single
        function actionList_Single()
        -- Rend
            -- rend,if=remains<=duration*0.3&debuff.colossus_smash.down
            if cast.able.rend() and (debuff.rend.refresh(units.dyn5) and not debuff.colossusSmash.exists(units.dyn5)) then
                if cast.rend() then return end
            end
        -- Skullsplitter
            -- skullsplitter,if=rage<70&(cooldown.deadly_calm.remains>3|!talent.deadly_calm.enabled)
            if cast.able.skullsplitter() and (rage < 70 and (cd.deadlyCalm.remain() > 3 or not talent.deadlyCalm)) then
                if cast.skullsplitter() then return end
            end
        -- Deadly Calm
            -- deadly_calm,if= cooldown.bladestorm.remains>6&(                                                  (cooldown.colossus_smash.remains<2|(talent.warbreaker.enabled&cooldown.warbreaker.remains<2))|(equipped.weight_of_the_earth&cooldown.heroic_leap.remains<2))
            -- deadly_calm,if=(cooldown.bladestorm.remains>6|talent.ravager.enabled&cooldown.ravager.remains>6)&(cooldown.colossus_smash.remains<2|(talent.warbreaker.enabled&cooldown.warbreaker.remains<2))
            if cast.able.deadlyCalm() and ((cd.bladestorm.remain() > 6 or not isChecked("Bladestorm") or #enemies.yards8 < getOptionValue("Bladestorm")
                or talent.ravager and (cd.ravager.remain() > 6 or getOptionValue("Ravager") == 3 or (getOptionValue("Ravager") == 2 and not useCDs())))
                and (cd.colossusSmash.remain() < 2 or (talent.warbreaker and cd.warbreaker.remain() < 2)))
            then
                if cast.deadlyCalm() then return end
            end
        -- Colossus Smash
            -- colossus_smash,if=debuff.colossus_smash.down
            if cast.able.colossusSmash() and (not debuff.colossusSmash.exists(units.dyn5))
                and ((mode.rotation == 1 and #enemies.yards8 < getOptionValue("AoE Threshold")) or (mode.rotation == 3 and #enemies.yards8 > 0) or not talent.warbreaker)
            then
                if cast.colossusSmash() then return end
            end
        -- Warbreaker
            -- warbreaker,if=debuff.colossus_smash.down
            if isChecked("Warbreaker") and cast.able.warbreaker() and talent.warbreaker and (not debuff.colossusSmash.exists(units.dyn5))
                and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("AoE Threshold")) or ( mode.rotation == 2 and #enemies.yards8 > 0))
            then
                if cast.warbreaker() then return end
            end
        -- Heroic Charge
            -- heroic_leap,if=equipped.weight_of_the_earth&debuff.colossus_smash.down&((cooldown.colossus_smash.remains>8&!prev_gcd.1.colossus_smash)|(talent.warbreaker.enabled&cooldown.warbreaker.remains>8&!prev_gcd.1.warbreaker))
            if cast.able.heroicLeap() and isChecked("Heroic Charge") and mode.heroic == 1 and (equiped.weightOfTheEarth and not debuff.colossusSmash.exists()
                and ((cd.colossusSmash.remain() > 8 and not cast.last.colossusSmash()) or (talent.warbreaker and cd.warbreaker.remain() > 8 and not cast.last.warbreaker())))
            then
                heroicLeapCharge()
            end
        -- Execute
            -- execute,if=buff.sudden_death.react|buff.stone_heart.react
            if cast.able.execute() and (buff.suddenDeath.exists() or buff.stoneHeart.exists()) then
                if cast.execute() then return end
            end
        -- Bladestorm
            -- bladestorm,if=cooldown.mortal_strike.remains&((debuff.colossus_smash.up&!azerite.test_of_might.enabled)|buff.test_of_might.up)
            if cast.able.bladestorm(nil,"aoe") and isChecked("Bladestorm") and not talent.ravager and cd.mortalStrike.remain() > 0
                and ((debuff.colossusSmash.exists(units.dyn5) and not traits.testOfMight.active()) or buff.testOfMight.exists())
            then
                if cast.bladestorm(nil,"aoe") then return end
            end
        -- Ravager
            -- ravager,if=debuff.colossus_smash.up&(cooldown.deadly_calm.remains>6|!talent.deadly_calm.enabled)
            if cast.able.ravager() and useCDs() and (getOptionValue("Ravager") == 1 or (getOptionValue("Ravager") == 2 and useCDs()))
                and talent.ravager and (debuff.colossusSmash.exists(units.dyn5) and (cd.deadlyCalm.remain() > 6 or not talent.deadlyCalm))
            then
                -- Best Location
                if getOptionValue("Ravager") == 1 then
                    if cast.ravager("best",nil,1,8) then return end
                end
                -- Target
                if getOptionValue("Ravager") == 2 then
                    if cast.ravager("target","ground") then return end
                end
            end
        -- Cleave
            -- cleave,if=spell_targets.whirlwind>2
            if cast.able.cleave(nil,"aoe") and ((mode.rotation == 1 and #enemies.yards8 > 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                if cast.cleave(nil,"aoe") then return end
            end
        -- Overpower
            -- overpower,if=azerite.seismic_wave.rank=3
            if cast.able.overpower() and traits.seismicWave.rank() == 3 then
                if cast.overpower() then return end
            end
        -- Mortal Strike
            -- mortal_strike
            if cast.able.mortalStrike() then
                if cast.mortalStrike() then return end
            end
        -- Overpower
            -- overpower
            if cast.able.overpower() then
                if cast.overpower() then return end
            end
        -- Whirlwind
            -- whirlwind,if=talent.fervor_of_battle.enabled&(rage>=50|debuff.colossus_smash.up)
            if cast.able.whirlwind(nil,"aoe") and (talent.fervorOfBattle and (rage >= 50 or debuff.colossusSmash.exists(units.dyn5))) then
                if cast.whirlwind(nil,"aoe") then return end
            end
        -- Slam
            -- slam,if=!talent.fervor_of_battle.enabled&(rage>=40|debuff.colossus_smash.up)
            if cast.able.slam() and (not talent.fervorOfBattle and (rage >= 40 or debuff.colossusSmash.exists(units.dyn5))) then
                if cast.slam() then return end
            end
        end -- End Action List - Single
    -- Action List - MultiTarget
        function actionList_FiveTarget()
        -- Skullsplitter
            -- skullsplitter,if=rage<70&(cooldown.deadly_calm.remains>3|!talent.deadly_calm.enabled)
            if cast.able.skullsplitter() and (rage < 70 and (cd.deadlyCalm.remain() > 3 or not talent.deadlyCalm)) then
                if cast.skullsplitter() then return end
            end
        -- Deadly Calm
            -- deadly_calm,if=cooldown.bladestorm.remains>6&((cooldown.colossus_smash.remains<2|(talent.warbreaker.enabled&cooldown.warbreaker.remains<2))|(equipped.weight_of_the_earth&cooldown.heroic_leap.remains<2))
            if cast.able.deadlyCalm() and ((cd.bladestorm.remain() > 6 or not isChecked("Bladestorm") or #enemies.yards8 < getOptionValue("Bladestorm"))
                and ((cd.colossusSmash.remain() < 2 or (talent.warbreaker and cd.warbreaker.remain() < 2)) or (equiped.weightOfTheEarth and cd.heroicLeap.remain() < 2)))
            then
                if cast.deadlyCalm() then return end
            end
        -- Colossus Smash
            -- colossus_smash,if=debuff.colossus_smash.down
            if cast.able.colossusSmash() and (not debuff.colossusSmash.exists(units.dyn5))
                and ((mode.rotation == 1 and #enemies.yards8 < getOptionValue("AoE Threshold")) or (mode.rotation == 3 and #enemies.yards8 > 0) or not talent.warbreaker)
            then
                if cast.colossusSmash() then return end
            end
        -- Warbreaker
            -- warbreaker,if=debuff.colossus_smash.down
            if isChecked("Warbreaker") and cast.able.warbreaker() and talent.warbreaker and (not debuff.colossusSmash.exists(units.dyn5))
                and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("AoE Threshold")) or ( mode.rotation == 2 and #enemies.yards8 > 0))
            then
                if cast.warbreaker() then return end
            end
        -- Bladestorm
            -- bladestorm,if=buff.sweeping_strikes.down&debuff.colossus_smash.remains>4.5&(prev_gcd.1.mortal_strike|spell_targets.whirlwind>1)&(!buff.deadly_calm.up|!talent.deadly_calm.enabled)
            if cast.able.bladestorm(nil,"aoe") and isChecked("Bladestorm") and not talent.ravager and (not buff.sweepingStrikes.exists() and debuff.colossusSmash.remain() > 4.5
                and (cast.last.mortalStrike() or (mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Bladestorm")) or (mode.rotation == 2 and #enemies.yards8 > 0))
                and (not buff.deadlyCalm.exists() or not talent.deadlyCalm))
            then
                if cast.bladestorm(nil,"aoe") then return end
            end
        -- Ravager
            -- ravager,if=debuff.colossus_smash.up&(cooldown.deadly_calm.remains>6|!talent.deadly_calm.enabled)
            if cast.able.ravager() and (getOptionValue("Ravager") == 1 or (getOptionValue("Ravager") == 2 and useCDs())) and talent.ravager
                and (debuff.colossusSmash.exists(units.dyn5) and (cd.deadlyCalm.remain() > 6 or not talent.deadlyCalm))
            then
                -- Best Location
                if getOptionValue("Ravager") == 1 then
                    if cast.ravager("best",nil,1,8) then return end
                end
                -- Target
                if getOptionValue("Ravager") == 2 then
                    if cast.ravager("target","ground") then return end
                end
            end
        -- Cleave
            -- cleave
            if cast.able.cleave(nil,"aoe") then
                if cast.cleave(nil,"aoe") then return end
            end
        -- Execute
            -- execute,if=(!talent.cleave.enabled&dot.deep_wounds.remains<2)|(buff.sudden_death.react|buff.stone_heart.react)&(buff.sweeping_strikes.up|cooldown.sweeping_strikes.remains>8)
            if cast.able.execute() and ((not talent.cleave and debuff.deepWounds.remain(units.dyn5) < 2) or (buff.suddenDeath.exists() or buff.stoneHeart.exists())
                and (buff.sweepingStrikes.exists() or cd.sweepingStrikes.remain() > 8))
            then
                if cast.execute() then return end
            end
        -- Mortal Strike
            -- mortal_strike,if=(!talent.cleave.enabled&dot.deep_wounds.remains<2)|buff.sweeping_strikes.up&buff.overpower.stack=2&(talent.dreadnaught.enabled|equipped.archavons_heavy_hand)
            if cast.able.mortalStrike() and ((not talent.cleave and debuff.deepWounds.remain(units.dyn5) < 2) or buff.sweepingStrikes.exists()
                and buff.overpower.stack() == 2 and (talent.dreadnaught or equiped.archavonsHeavyHand))
            then
                if cast.mortalStrike() then return end
            end
        -- Whirlwind
            -- whirlwind,if=debuff.colossus_smash.up
            if cast.able.whirlwind(nil,"aoe") and (debuff.colossusSmash.exists(units.dyn5)) then
                if cast.whirlwind(nil,"aoe") then return end
            end
        -- Overpower
            -- overpower
            if cast.able.overpower() then
                if cast.overpower() then return end
            end
        -- Whirlwind
            -- whirlwind
            if cast.able.whirlwind(nil,"aoe") then
                if cast.whirlwind(nil,"aoe") then return end
            end
        end -- End Action List - Five Target
-----------------
--- Rotations ---
-----------------
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 then
            return true
        else
            if actionList_Extra() then return end
            if actionList_Defensive() then return end
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
            -- Sweeping Strikes
                -- sweeping_strikes,if=spell_targets.whirlwind>1&(cooldown.bladestorm.remains>10|cooldown.colossus_smash.remains>8|azerite.test_of_might.enabled)
                if isChecked("Sweeping Strikes") and cast.able.sweepingStrikes() and #enemies.yards8 > 1 and mode.rotation ~= 3
                    and (cd.bladestorm.remain() > 10 or cd.colossusSmash.remain() > 8 or traits.testOfMight.active())
                then
                    if cast.sweepingStrikes() then return end
                end
            -- Action List - Five Target
                -- run_action_list,name=five_target,if=spell_targets.whirlwind>4
                if ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("AoE Threshold")) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                    if actionList_FiveTarget() then return end
                end
            -- Action List - Execute
                -- run_action_list,name=execute,if=(talent.massacre.enabled&target.health.pct<35)|target.health.pct<20
                if ((talent.massacre and getHP(units.dyn5) < 35) or getHP(units.dyn5) < 20) and level >= 8 then
                    if actionList_Execute() then return end
                end
            -- Action List - Single
                -- run_action_list,name=single_target
                if getHP(units.dyn5) >= 35 or (not talent.massacre and getHP(units.dyn5) >= 20) or level < 8 then
                    if actionList_Single() then return end
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
