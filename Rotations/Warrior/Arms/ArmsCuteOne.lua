if select(3,UnitClass("player")) == 1 then
    local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
    local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 0, icon = bb.player.spell.sweepingStrikes },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.whirlwind },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.mortalStrike },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.victoryRush}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.recklessness },
            [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.recklessness },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.recklessness }
        };
        CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.dieByTheSword },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.dieByTheSword }
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = bb.player.spell.pummel },
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = bb.player.spell.pummel }
        };
        CreateButton("Interrupt",4,0)
    -- Movement Button
        MoverModes = {
            [1] = { mode = "On", value = 1 , overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap.", highlight = 1, icon = bb.player.spell.charge },
            [2] = { mode = "Off", value = 2 , overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap.", highlight = 0, icon = bb.player.spell.charge }
        };
        CreateButton("Mover",5,0)
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
            section = bb.ui:createSection(bb.ui.window.profile,  "General")
                -- Dummy DPS Test
                bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
                -- Battle/Commanding
                bb.ui:createCheckbox(section, "Battle/Commanding", "Check to use Battle/Commanding Shouts")
                -- Berserker Rage
                bb.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
                -- Hamstring
                bb.ui:createCheckbox(section,"Hamstring", "Check to use Hamstring")
                -- Heroic Leap
                bb.ui:createDropdown(section,"Heroic Leap", bb.dropOptions.Toggle, 6, "Set auto usage (No Hotkey) or desired hotkey to use Heroic Leap.")
                bb.ui:createDropdownWithout(section,"Heroic Leap - Traget",{"Best","Target"},1,"Desired Target of Heroic Leap")
                -- Intervene - Movement
                bb.ui:createCheckbox(section,"Intervene - Movement", "Check to use Intervene as a gap closer")
                -- Pre-Pull Timer
                bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            bb.ui:checkSectionState(section)
            ------------------------
            --- COOLDOWN OPTIONS ---
            ------------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Cooldowns")
                -- Agi Pot
                bb.ui:createCheckbox(section,"Str-Pot")
                -- Legendary Ring
                bb.ui:createCheckbox(section, "Legendary Ring", "Enable or Disable usage of Legendary Ring.")
                -- Flask / Crystal
                bb.ui:createCheckbox(section,"Flask / Crystal")
                -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
                -- Touch of the Void
                bb.ui:createCheckbox(section,"Touch of the Void")
            bb.ui:checkSectionState(section)
            -------------------------
            --- DEFENSIVE OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
                -- Healthstone
                bb.ui:createSpinner(section, "Healthstone/Potion",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Heirloom Neck
                bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Gift of The Naaru
                if bb.player.race == "Draenei" then
                    bb.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                end
                -- Defensive Stance
                bb.ui:createSpinner(section, "Defensive Stance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Die By The Sword
                bb.ui:createSpinner(section, "Die by the Sword",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Enraged Regeneration
                bb.ui:createSpinner(section, "Enraged Regeneration", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
                -- Intervene
                bb.ui:createSpinner(section, "Intervene",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                bb.ui:createDropdownWithout(section, "Intervene - Target", {"|cff00FF00TANK","|cffFFFF00HEALER","|cffFF0000TANK/HEALER","ANY"}, 4, "|cffFFFFFFFriendly to cast on")
                -- Intimidating Shout
                bb.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Rallying Cry
                bb.ui:createSpinner(section, "Rallying Cry",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Shield Barrier
                bb.ui:createSpinner(section, "Shield Barrier", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
                -- Vigilance
                bb.ui:createSpinner(section, "Vigilance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                bb.ui:createDropdownWithout(section, "Vigilance - Target", {"|cff00FF00TANK","|cffFFFF00HEALER","|cffFF0000TANK/HEALER","ANY"}, 4, "|cffFFFFFFFriendly to cast on")
            bb.ui:checkSectionState(section)
            -------------------------
            --- INTERRUPT OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
                -- Pummel
                bb.ui:createCheckbox(section,"Pummel")
                -- Intimidating Shout
                bb.ui:createCheckbox(section,"Intimidating Shoult - Int")
                -- Spell Reflection
                bb.ui:createCheckbox(section,"Spell Refelection")
                -- Interrupt Percentage
                bb.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")    
            bb.ui:checkSectionState(section)
            ----------------------
            --- TOGGLE OPTIONS ---
            ----------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Toggle Keys")
                -- Single/Multi Toggle
                bb.ui:createDropdown(section,  "Rotation Mode", bb.dropOptions.Toggle,  4)
                --Cooldown Key Toggle
                bb.ui:createDropdown(section,  "Cooldown Mode", bb.dropOptions.Toggle,  3)
                --Defensive Key Toggle
                bb.ui:createDropdown(section,  "Defensive Mode", bb.dropOptions.Toggle,  6)
                -- Interrupts Key Toggle
                bb.ui:createDropdown(section,  "Interrupt Mode", bb.dropOptions.Toggle,  6)
                -- Mover Toggle
                bb.ui:createDropdown(section,  "Mover Mode", bb.dropOptions.Toggle,  6)
                -- Pause Toggle
                bb.ui:createDropdown(section,  "Pause Mode", bb.dropOptions.Toggle,  6)   
            bb.ui:checkSectionState(section)
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
        if bb.timer:useTimer("debugArms", 0.1) then
            --print("Running: "..rotationName)

    ---------------
    --- Toggles ---
    ---------------
            UpdateToggle("Rotation",0.25)
            UpdateToggle("Cooldown",0.25)
            UpdateToggle("Defensive",0.25)
            UpdateToggle("Interrupt",0.25)
            UpdateToggle("Mover",0.25)
    --------------
    --- Locals ---
    --------------
            local buff              = bb.player.buff
            local dyn5              = bb.player.units.dyn5
            local canFlask          = canUse(bb.player.flask.wod.strengthBig)
            local cd                = bb.player.cd
            local charges           = bb.player.charges
            local combatTime        = getCombatTime()
            local debuff            = bb.player.debuff
            local distance          = getDistance("target")
            local enemies           = bb.player.enemies
            local flaskBuff         = getBuffRemain("player",bb.player.flask.wod.buff.strengthBig) or 0
            local frac              = bb.player.frac
            local gcd               = bb.player.gcd
            local glyph             = bb.player.glyph
            local hasThreat         = hasThreat("target")
            local healthPot         = getHealthPot() or 0
            local heirloomNeck      = 122667 or 122668
            local inCombat          = bb.player.inCombat
            local inRaid            = select(2,IsInInstance())=="raid"
            local level             = bb.player.level
            local php               = bb.player.health
            local power             = bb.player.power
            local pullTimer         = bb.DBM:getPulltimer()
            local race              = bb.player.race
            local racial            = bb.player.getRacial()
            local raidAdd           = false --Need to determine how to check raid add
            local raidAddIn         = 0 --Time until Raid Add
            local ravaging          = false --Need to determine prev gcd is ravager
            local recharge          = bb.player.recharge
            local regen             = bb.player.powerRegen
            local solo              = select(2,IsInInstance())=="none"
            local strPot            = 1 --Get Stregth Potion ID
            local t17_2pc           = bb.player.eq.t17_2pc
            local t18_2pc           = bb.player.eq.t18_2pc 
            local t18_4pc           = bb.player.eq.t18_4pc
            local t18trinket        = false --Need to get check for T18 class trinket
            local talent            = bb.player.talent
            local targets           = #getEnemies("player",8)
            local thp               = getHP(bb.player.units.dyn5)
            local ttd               = getTimeToDie(bb.player.units.dyn5)
            local ttm               = bb.player.timeToMax
            if t18_4pc then t18_4pcBonus = 1 else t18_4pcBonus = 0 end

    --------------------
    --- Action Lists ---
    --------------------
        -- Action list - Extras
            function actionList_Extra()
                if isChecked("Battle/Commanding") then
                -- Battle Shout
                    if bb.player.castBattleShout() then return end
                -- Commanding Shout
                    if bb.player.castCommandingShout() then return end
                end
                -- Berserker Rage
                if isChecked("Berserker Rage") then
                    if bb.player.castBeserkerRage() then return end
                end
                -- Hamstring
                if isChecked("Hamstring") then
                    for i=1,#getEnemies("player",5) do
                        thisUnit = getEnemies("player",5)[i]
                        if isMoving(thisUnit) and getFacing(thisUnit,"player") == false then
                            if bb.player.castHamstring(thisUnit) then return end
                        end
                    end
                end
                -- Intervene
                if isChecked("Intervene") and isChecked("Intervene - Movement") then
                    if bb.player.castIntervene("target") then return end
                end
                -- -- Heroic Leap
                -- if isChecked("Heroic Leap") and SpecificToggle("Heroic Leap") and not GetCurrentKeyBoardFocus() then
                --     if bb.player.castHeroicLeap("Mouse") then return end
                -- end
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
                            if GetItemCooldown(heirloomNeck)==0 then
                                useItem(heirloomNeck)
                            end
                        end
                    end 
                -- Gift of the Naaru
                    if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and bb.player.race=="Draenei" then
                        if castSpell("player",racial,false,false,false) then return end
                    end
                -- Defensive Stance
                    if isChecked("Defensive Stance") and inCombat and php <= getOptionValue("Defensive Stance") then
                        if bb.player.castDefensiveStance() then return end
                    elseif buff.defensiveStance then
                        if bb.player.castBattleStance() then return end
                    end 
                -- Die by the Sword
                    if isChecked("Die by the Sword") and inCombat and php <= getOptionValue("Die by the Sword") then
                        if bb.player.castDieByTheSword() then return end
                    end
                -- Enraged Regeneration
                    if isChecked("Enraged Regeneration") and inCombat and php <= getOptionValue("Enraged Regeneration") then
                        if bb.player.castEnragedRegeneration() then return end
                    end
                -- Intervene
                    if isChecked("Intervene") then
                        for i=1,#nNova do
                            thisUnit = nNova[i].unit
                            if thisUnit ~= "player" then
                                if getOptionValue("Intervene - Target")==4 then
                                    if getHP(thisUnit)<getOptionValue("Intervene") and getDistance(thisUnit)<25 then
                                        if bb.player.castIntervene(thisUnit) then return end
                                    end
                                end
                                if getOptionValue("Intervene - Target")==3 then
                                    if (UnitGroupRolesAssigned(thisUnit)=="HEALER" or UnitGroupRolesAssigned(thisUnit)=="TANK") and getHP(thisUnit)<getOptionValue("Intervene") and getDistance(thisUnit)<25 then
                                        if bb.player.castIntervene(thisUnit) then return end
                                    end
                                end
                                if getOptionValue("Intervene - Target")==2 then
                                    if UnitGroupRolesAssigned(thisUnit)=="HEALER" and getHP(thisUnit)<getOptionValue("Intervene") and getDistance(thisUnit)<25 then
                                        if bb.player.castIntervene(thisUnit) then return end
                                    end
                                end
                                if getOptionValue("Intervene - Target")==1 then
                                    if UnitGroupRolesAssigned(thisUnit)=="TANK" and getHP(thisUnit)<getOptionValue("Intervene") and getDistance(thisUnit)<25 then
                                        if bb.player.castIntervene(thisUnit) then return end
                                    end
                                end
                            end
                        end
                    end
                -- Intimidating Shout
                    if isChecked("Intimidating Shout") and inCombat and php <= getOptionValue("Intimidating Shout") then
                        if bb.player.castIntimidatingShout() then return end
                    end
                -- Shield Barrier
                    if isChecked("Shield Barrier") and inCombat and php <= getOptionValue("Shield Barrier") then
                        if not buff.defensiveStance and not buff.shieldBarrier and power>20 then
                            if bb.player.castDefensiveStance() then return end
                        else
                            if bb.player.castShieldBarrier() then return end
                        end
                    end
                -- Vigilance
                    if isChecked("Vigilance") then
                        for i=1,#nNova do
                            thisUnit = nNova[i].unit
                            if thisUnit ~= "player" then
                                if getOptionValue("Vigilance - Target")==4 then
                                    if getHP(thisUnit)<getOptionValue("Vigilance") and getDistance(thisUnit)<40 then
                                        if bb.player.castVigilance(thisUnit) then return end
                                    end
                                end
                                if getOptionValue("Vigilance - Target")==3 then
                                    if (UnitGroupRolesAssigned(thisUnit)=="HEALER" or UnitGroupRolesAssigned(thisUnit)=="TANK") and getHP(thisUnit)<getOptionValue("Vigilance") and getDistance(thisUnit)<40 then
                                        if bb.player.castVigilance(thisUnit) then return end
                                    end
                                end
                                if getOptionValue("Vigilance - Target")==2 then
                                    if UnitGroupRolesAssigned(thisUnit)=="HEALER" and getHP(thisUnit)<getOptionValue("Vigilance") and getDistance(thisUnit)<40 then
                                        if bb.player.castVigilance(thisUnit) then return end
                                    end
                                end
                                if getOptionValue("Vigilance - Target")==1 then
                                    if UnitGroupRolesAssigned(thisUnit)=="TANK" and getHP(thisUnit)<getOptionValue("Vigilance") and getDistance(thisUnit)<40 then
                                        if bb.player.castVigilance(thisUnit) then return end
                                    end
                                end
                            end
                        end
                    end
                -- Rallying Cry
                    if isChecked("Rallying Cry") and inCombat and php <= getOptionValue("Rallying Cry") then
                        if bb.player.castRallyingCry() then return end
                    end
                end -- End Defensive Check
            end -- End Action List - Defensive
        -- Action List - Interrupts
            function actionList_Interrupts()
                if useInterrupts() then
                -- Pummel
                    if isChecked("Pummel") then
                        for i=1, #getEnemies("player",5) do
                            thisUnit = getEnemies("player",5)[i]
                            if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                                if bb.player.castPummel(thisUnit) then return end
                            end
                        end
                    end
                -- Intimidating Shout
                    if isChecked("Intimidating Shout - Int") then
                        for i=1, #getEnemies("player",8) do
                            thisUnit = getEnemies("player",8)[i]
                            if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                                if bb.player.castIntimidatingShout() then return end
                            end
                        end
                    end
                -- Spell Reflection
                    if isChecked("Spell Reflection") then
                        for i=1, #getEnemies("player",40) do
                            thisUnit = getEnemies("player",40)[i]
                            targetMe = UnitIsUnit("player",thisUnit) or false
                            if UnitCastingInfo(thisUnit) ~= nil then
                                if (select(6,UnitCastingInfo(thisUnit))/1000 - GetTime())<5 and targetMe then
                                    if bb.player.castSpellReflection() then return end
                                end
                            end
                        end
                    end
                end
            end -- End Action List - Interrupts
        -- Action List - Cooldowns
            function actionList_Cooldowns()
                if inRange(bb.player.spell.rend,bb.player.units.dyn5) then
                -- Legendary Ring
                    -- use_item,name=thorasus_the_stone_heart_of_draenor,if=(buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up))
                    if useCDs() and isChecked("Legendary Ring") and (buff.bloodbath or (not talent.bloodbath and debuff.colossusSmash)) then
                        if hasEquiped(124634) and canUse(124634) then
                            useItem(124634)
                            return true
                        end
                    end
                -- Potion
                    -- potion,name=draenic_strength,if=(target.health.pct<20&buff.recklessness.up)|target.time_to_die<25
                    if useCDs() and canUse(strPot) and inRaid and isChecked("Agi-Pot") then
                        if (thp<20 and buff.recklessness) or ttd<25 then
                            useItem(strPot)
                        end
                    end
                -- Recklessness
                    -- recklessness,if=(((target.time_to_die>190|target.health.pct<20)&(buff.bloodbath.up|!talent.bloodbath.enabled))|target.time_to_die<=12|talent.anger_management.enabled)&((desired_targets=1&!raid_event.adds.exists)|!talent.bladestorm.enabled)
                    if useCDs() and (((ttd>190 or thp<20) and (buff.bloodbath or not talent.bloodbath)) or ttd<=12 or talent.angerManagement) and ((targets==1 and not raidAdd) or not talent.bladestorm) then
                        if bb.player.castRecklessness() then return end
                    end
                -- Bloodbath
                    -- bloodbath,if=(dot.rend.ticking&cooldown.colossus_smash.remains<5&((talent.ravager.enabled&prev_gcd.ravager)|!talent.ravager.enabled))|target.time_to_die<20
                    if useCDs() and (debuff.rend and cd.colossusSmash<5 and ((talent.ravager and not ravaging) or not talent.ravager)) or ttd<20 then
                        if bb.player.castBloodbath() then return end
                    end
                -- Avatar
                    -- avatar,if=buff.recklessness.up|target.time_to_die<25
                    if useCDs() and buff.recklessness or ttd<25 then
                        if bb.player.castAvatar() then return end
                    end
                -- Racials
                    -- blood_fury
                    -- arcane_torrent
                    -- berserking
                    if useCDs() and (bb.player.race == "Orc" or bb.player.race == "Troll" or bb.player.race == "Blood Elf") then
                        if bb.player.castRacial() then return end
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
                    if useCDs() and isChecked("Trinkets") then
                        if canUse(13) then
                            useItem(13)
                        end
                        if canUse(14) then
                            useItem(14)
                        end
                    end
                -- Heroic Leap 
                    -- heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
                    if useMover() then
                        if isChecked("Heroic Leap") and (getOptionValue("Heroic Leap")==6 or (SpecificToggle("Heroic Leap") and not GetCurrentKeyBoardFocus())) then
                            if getOptionValue("Heroic Leap - Target")==1 then
                                if bb.player.castHeroicLeap("Best") then return end
                            end
                            if getOptionValue("Heroic Leap - Target")==2 then
                                if bb.player.castHeroicLeap("Target") then return end
                            end
                            -- if getOptionValue("Heroic Leap - Target")==3 then
                            --     if bb.player.castHeroicLeap("Mouse") then return end
                            -- end
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
                        useItem(bb.player.flask.wod.strengthBig)
                        return true
                    end
                    if flaskBuff==0 then
                        if bb.player.useCrystal() then return end
                    end
                end
                -- food,type=sleeper_sushi
                -- stance,choose=battle
                if not buff.battleStance and php > getOptionValue("Defensive Stance") then
                    if bb.player.castBattleStance() then return end
                end
                -- snapshot_stats
                -- potion,name=draenic_strength
                if useCDs() and inRaid and isChecked("Str-Pot") and isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
                    if canUse(109219) then
                        useItem(109219)
                    end
                end
            end  -- End Action List - Pre-Combat
        -- Action List - Movement
            function actionList_Movement()
            -- Heroic Leap
                -- heroic_leap
                if useMover() then
                    if isChecked("Heroic Leap") and (getOptionValue("Heroic Leap")==6 or (SpecificToggle("Heroic Leap") and not GetCurrentKeyBoardFocus())) then
                        if getOptionValue("Heroic Leap - Target")==1 then
                            if bb.player.castHeroicLeap("Best") then return end
                        end
                        if getOptionValue("Heroic Leap - Target")==2 then
                            if bb.player.castHeroicLeap("Target") then return end
                        end
                        -- if getOptionValue("Heroic Leap - Target")==3 then
                        --     if bb.player.castHeroicLeap("Mouse") then return end
                        -- end
                    end
                end
            -- Charge
                -- charge,cycle_targets=1,if=debuff.charge.down
                if useMover() and not debuff.charge then
                    if bb.player.castCharge() then return end
                end
            -- Storm Bolt
                -- storm_bolt
                if bb.player.castStormBolt() then return end
            -- Heroic Throw
                -- heroic_throw
                if bb.player.castHeroicThrow() then return end
            end
        -- Action List - Single
            function actionList_Single()
            -- Rend
                -- rend,if=target.time_to_die>4&(remains<gcd|(debuff.colossus_smash.down&remains<5.4))
                if ttd>4 and (debuff.remain.rend<gcd or (not debuff.colosusSmash and debuff.remain.rend<5.4)) then
                    if bb.player.castRend(bb.player.units.dyn5) then return end
                end
            -- Ravager
                -- ravager,if=cooldown.colossus_smash.remains<4&(!raid_event.adds.exists|raid_event.adds.in>55)
                if cd.colossusSmash<4 then
                    if bb.player.castRavager() then return end
                end
            -- Colossus Smash
                -- colossus_smash,if=debuff.colossus_smash.down
                if not debuff.colossusSmash then
                    if bb.player.castColossusSmash() then return end
                end
            -- Mortal Strike
                -- mortal_strike,if=target.health.pct>20
                if thp>20 then
                    if bb.player.castMortalStrike() then return end
                end
            -- Colossus Smash
                -- colossus_smash
                if bb.player.castColossusSmash() then return end
            -- Bladestorm
                -- bladestorm,if=(((debuff.colossus_smash.up|cooldown.colossus_smash.remains>3)&target.health.pct>20)|(target.health.pct<20&rage<30&cooldown.colossus_smash.remains>4))&(!raid_event.adds.exists|raid_event.adds.in>55|(talent.anger_management.enabled&raid_event.adds.in>40))
                if (((debuff.colossusSmash or cd.colossusSmash>3) and thp>20) or (thp<20 and power<30 and cd.colossusSmash>4)) then
                    if bb.player.castBladestorm() then return end
                end
            -- Storm Bolt
                -- storm_bolt,if=debuff.colossus_smash.down
                if not debuff.colossusSmash then
                    if bb.player.castStormBolt() then return end
                end
            -- Siegebreaker
                -- siegebreaker
                if bb.player.castSiegebreaker() then return end
            -- Dragon Roar
                -- dragon_roar,if=!debuff.colossus_smash.up&(!raid_event.adds.exists|raid_event.adds.in>55|(talent.anger_management.enabled&raid_event.adds.in>40))
                if not debuff.colossusSmash then
                    if bb.player.castDragonRoar() then return end
                end
            -- Execute
                -- execute,if=buff.sudden_death.react
                if buff.suddenDeath then
                    if bb.player.castExecute(bb.player.units.dyn5) then return end
                end
                -- execute,if=!buff.sudden_death.react&(rage.deficit<48&cooldown.colossus_smash.remains>gcd)|debuff.colossus_smash.up|target.time_to_die<5
                if not buff.suddenDeath and (bb.player.powerDeficit<48 and (cd.colossusSmash>gcd or level<81)) or debuff.colossusSmash or ttd<5 then
                    if bb.player.castExecute(bb.player.units.dyn5) then return end
                end
            -- Rend
                -- rend,if=target.time_to_die>4&remains<5.4
                if ttd>4 and debuff.remain.rend<5.4 then
                    if bb.player.castRend(bb.player.units.dyn5) then return end
                end
            -- Wait
                -- wait,sec=cooldown.colossus_smash.remains,if=cooldown.colossus_smash.remains<gcd
                if cd.colossusSmash<gcd then
                    pause()
                end
            -- Shockwave
                -- shockwave,if=target.health.pct<=20
                if thp<=20 then
                    if bb.player.castShockwave() then return end
                end
            -- Wait
                -- wait,sec=0.1,if=target.health.pct<=20
                -- TODO
            -- Impending Victory
                -- impending_victory,if=rage<40&!set_bonus.tier18_4pc
                if power<40 and not t18_4pc then
                    if bb.player.castImpendingVictory() then return end
                end
            -- Victory Rush
                if php < 85 or buff.remain.victoryRush<2 then
                    if bb.player.castVictoryRush() then return end
                end
            -- Slam
                -- slam,if=rage>20&!set_bonus.tier18_4pc
                if power>20 and not t18_4pc then
                    if bb.player.castSlam() then return end
                end
            -- Thunder Clap
                -- thunder_clap,if=((!set_bonus.tier18_2pc&!t18_class_trinket)|(!set_bonus.tier18_4pc&rage.deficit<45)|rage.deficit<30)&(!talent.slam.enabled|set_bonus.tier18_4pc)&(rage>=40|debuff.colossus_smash.up)&glyph.resonating_power.enabled
                if ((not t18_2pc and not t18trinket) or (not t18_4pc and bb.player.powerDeficit<45) or bb.player.powerDeficit<30) and (not talent.slam or t18_4pc) and (power>=40 or debuff.colossusSmash or level<81) and (glyph.resonatingPower or level<26) then
                    if bb.player.castThunderClap() then return end
                end
            -- Whirlwind
                -- whirlwind,if=((!set_bonus.tier18_2pc&!t18_class_trinket)|(!set_bonus.tier18_4pc&rage.deficit<45)|rage.deficit<30)&(!talent.slam.enabled|set_bonus.tier18_4pc)&(rage>=40|debuff.colossus_smash.up)
                if ((not t18_2pc and not t18trinket) or (not t18_4pc and bb.player.powerDeficit<45) or bb.player.powerDeficit<30) and (not talent.slam or t18_4pc) and (power>=40 or debuff.colossusSmash or level<81) then
                    if bb.player.castWhirlwind() then return end
                end
            -- Shockwave
                --shockwave
                if bb.player.castShockwave() then return end
            end -- End Action List - Single
        -- Action List - MultiTarget
            function actionList_MultiTarget()
            -- Touch of the Void
                if isChecked("Touch of the Void") and inRange(bb.player.spell.rend,bb.player.units.dyn5) then
                    if hasEquiped(128318) then
                        if GetItemCooldown(128318)==0 then
                            useItem(128318)
                        end
                    end
                end
            -- Sweeping Strikes
                --sweeping_strikes
                if bb.player.castSweepingStrikes() then return end
            -- Rend
                -- rend,if=dot.rend.remains<5.4&target.time_to_die>4
                if debuff.remain.rend<5.4 and ttd>4 then
                    if bb.player.castRend(bb.player.units.dyn5) then return end
                end
                -- rend,cycle_targets=1,max_cycle_targets=2,if=dot.rend.remains<5.4&target.time_to_die>8&!buff.colossus_smash_up.up&talent.taste_for_blood.enabled
                if debuff.count.rend<2 then
                    for i=1, #getEnemies("player",5) do
                        thisUnit = getEnemies("player",5)[i]
                        if getDebuffRemain(thisUnit,bb.player.spell.rend,"player")<5.4 and getTimeToDie(thisUnit)>8 and talent.tasteForBlood then --TODO: Add buff check for Colossus Smash
                            if bb.player.castRend(thisUnit) then return end
                        end
                    end
                end
                -- rend,cycle_targets=1,if=dot.rend.remains<5.4&target.time_to_die-remains>18&!buff.colossus_smash_up.up&spell_targets.whirlwind<=8
                for i=1, #getEnemies("player",5) do
                    thisUnit = getEnemies("player",5)[i]
                    if getDebuffRemain(thisUnit,bb.player.spell.rend,"player")<5.4 and getTimeToDie(thisUnit)>18 and targets<=8 then --TODO: Add buff check for Colossus Smash
                        if bb.player.castRend(thisUnit) then return end
                    end
                end
            -- Ravager
                -- ravager,if=buff.bloodbath.up|cooldown.colossus_smash.remains<4
                if buff.bloodbath or cd.colossusSmash<4 then
                    if bb.player.castRavager() then return end
                end
            -- Bladestorm
                -- bladestorm,if=((debuff.colossus_smash.up|cooldown.colossus_smash.remains>3)&target.health.pct>20)|(target.health.pct<20&rage<30&cooldown.colossus_smash.remains>4)
                if ((debuff.colossusSmash or cd.colossusSmash>3) and thp>20) or (thp<20 and power<30 and cd.colossusSmash>4) then
                    if bb.player.castBladestorm() then return end
                end
            -- Colossus Smash
                -- colossus_smash,if=dot.rend.ticking
                if debuff.rend then
                    if bb.player.castColossusSmash() then return end
                end
            -- Execute
                -- execute,cycle_targets=1,if=!buff.sudden_death.react&spell_targets.whirlwind<=8&((rage.deficit<48&cooldown.colossus_smash.remains>gcd)|rage>80|target.time_to_die<5|debuff.colossus_smash.up)
                for i=1, #getEnemies("player",5) do
                    thisUnit = getEnemies("player",5)[i]
                    if buff.suddenDeath and targets<=8 and ((bb.player.powerDeficit<48 and cd.colossusSmash>gcd) or power>80 or ttd<5 or debuff.colossusSmash or level<81) then
                        if bb.player.castExecute(thisUnit) then return end
                    end
                end
            -- Mortal Strike
                -- mortal_strike,if=target.health.pct>20&(rage>60|debuff.colossus_smash.up)&spell_targets.whirlwind<=5
                if thp>20 and (power>60 or debuff.colossusSmash or level<81) and targets<=5 then
                    if bb.player.castMortalStrike() then return end
                end
            -- Dragon Roar
                -- dragon_roar,if=!debuff.colossus_smash.up
                if not debuff.colossusSmash then
                    if bb.player.castDragonRoar() then return end
                end
            -- Thunder Clap
                -- thunder_clap,if=(target.health.pct>20|spell_targets.whirlwind>=9)&glyph.resonating_power.enabled
                if (thp>20 or targets>=9) and (glyph.resonatingPower or level<26) then
                    if bb.player.castThunderClap() then return end
                end
            -- Rend
                -- rend,cycle_targets=1,if=dot.rend.remains<5.4&target.time_to_die>8&!buff.colossus_smash_up.up&spell_targets.whirlwind>=9&rage<50&!talent.taste_for_blood.enabled
                for i=1, #getEnemies("player",5) do
                    thisUnit = getEnemies("player",5)[i]
                    if getDebuffRemain(thisUnit,bb.player.spell.rend,"player")<5.4 and getTimeToDie(thisUnit)>8 and targets>=9 and power<50 and not talent.tasteForBlood then --TODO: Add buff check for Colossus Smash
                        if bb.player.castRend(thisUnit) then return end
                    end
                end
            -- Whirlwind
                -- whirlwind,if=target.health.pct>20|spell_targets.whirlwind>=9
                if thp>20 or targets>=9 then
                    if bb.player.castWhirlwind() then return end
                end
            -- Siegebreaker
                -- siegebreaker
                if bb.player.castSiegebreaker() then return end
            -- Storm Bolt
                -- storm_bolt,if=cooldown.colossus_smash.remains>4|debuff.colossus_smash.up
                if cd.colossusSmash>4 or debuff.colossusSmash then
                    if bb.player.castStormBolt() then return end
                end
            -- Shockwave
                -- shockwave
                if bb.player.castShockwave() then return end
            -- Execute
                -- execute,if=buff.sudden_death.react
                if buff.suddenDeath then
                    if bb.player.castExecute() then return end
                end      
            end -- End Action List - MultiTarget
  -----------------
  --- Rotations ---
  -----------------
            if actionList_Extra() then return end
            if actionList_Defensive() then return end
            -- Pause
            if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) then
                return true
            else
  ---------------------------------
  --- Out Of Combat - Rotations ---
  ---------------------------------
                if not inCombat and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                    if actionList_PreCombat() then return end
                    if inRange(bb.player.spell.rend,bb.player.units.dyn5) then
                        StartAttack()
                    else
                        if bb.player.castCharge() then return end
                    end
                end
  -----------------------------
  --- In Combat - Rotations --- 
  -----------------------------
                if inCombat then
                -- Charge
                    -- charge,if=debuff.charge.down
                    if useMover() and not debuff.charge then
                        if bb.player.castCharge() then return end
                    end
                -- Auto Attack
                    --auto_attack
                    if inRange(bb.player.spell.rend,bb.player.units.dyn5) then
                        StartAttack()
                    end
                -- Action List - Movement
                    -- run_action_list,name=movement,if=movement.distance>5
                    if not inRange(bb.player.spell.rend,bb.player.units.dyn5) then
                        if actionList_Movement() then return end
                    end
                -- Action List - Interrupts
                    if actionList_Interrupts() then return end
                -- Action List - Cooldowns
                    if actionList_Cooldowns() then return end
                -- Action List - Multi Target
                    if targets>1 and useAoE() then
                        if actionList_MultiTarget() then return end
                    end
                -- Action List - Single Target
                    if targets==1 or not useAoE() then
                        if actionList_Single() then return end
                    end
                end -- End Combat Rotation
            end -- Pause
        end -- End Timer
    end -- runRotation
    tinsert(cArms.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end -- End Select Warrior