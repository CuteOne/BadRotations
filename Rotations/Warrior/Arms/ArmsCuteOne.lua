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
                -- -- Battle/Commanding
                -- bb.ui:createCheckbox(section, "Battle/Commanding", "Check to use Battle/Commanding Shouts")
                -- -- Berserker Rage
                -- bb.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
                -- -- Hamstring
                -- bb.ui:createCheckbox(section,"Hamstring", "Check to use Hamstring")
                -- -- Heroic Leap
                -- bb.ui:createDropdown(section,"Heroic Leap", bb.dropOptions.Toggle, 6, "Set auto usage (No Hotkey) or desired hotkey to use Heroic Leap.")
                -- bb.ui:createDropdownWithout(section,"Heroic Leap - Traget",{"Best","Target"},1,"Desired Target of Heroic Leap")
                -- -- Intervene - Movement
                -- bb.ui:createCheckbox(section,"Intervene - Movement", "Check to use Intervene as a gap closer")
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
                -- -- Defensive Stance
                -- bb.ui:createSpinner(section, "Defensive Stance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- -- Die By The Sword
                -- bb.ui:createSpinner(section, "Die by the Sword",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- -- Enraged Regeneration
                -- bb.ui:createSpinner(section, "Enraged Regeneration", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
                -- -- Intervene
                -- bb.ui:createSpinner(section, "Intervene",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- bb.ui:createDropdownWithout(section, "Intervene - Target", {"|cff00FF00TANK","|cffFFFF00HEALER","|cffFF0000TANK/HEALER","ANY"}, 4, "|cffFFFFFFFriendly to cast on")
                -- -- Intimidating Shout
                -- bb.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- -- Rallying Cry
                -- bb.ui:createSpinner(section, "Rallying Cry",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- -- Shield Barrier
                -- bb.ui:createSpinner(section, "Shield Barrier", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
                -- -- Vigilance
                -- bb.ui:createSpinner(section, "Vigilance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- bb.ui:createDropdownWithout(section, "Vigilance - Target", {"|cff00FF00TANK","|cffFFFF00HEALER","|cffFF0000TANK/HEALER","ANY"}, 4, "|cffFFFFFFFriendly to cast on")
            bb.ui:checkSectionState(section)
            -------------------------
            --- INTERRUPT OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
                -- -- Pummel
                -- bb.ui:createCheckbox(section,"Pummel")
                -- -- Intimidating Shout
                -- bb.ui:createCheckbox(section,"Intimidating Shoult - Int")
                -- -- Spell Reflection
                -- bb.ui:createCheckbox(section,"Spell Refelection")
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
            local cast              = bb.player.cast
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
            local mode              = bb.player.mode
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
            local spell             = bb.player.spell
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
            local units             = bb.player.units
            if t18_4pc then t18_4pcBonus = 1 else t18_4pcBonus = 0 end

    --------------------
    --- Action Lists ---
    --------------------
        -- Action list - Extras
            function actionList_Extra()

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
                    if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and bb.player.race=="Draenei" then
                        if castSpell("player",racial,false,false,false) then return end
                    end
                end -- End Defensive Check
            end -- End Action List - Defensive
        -- Action List - Interrupts
            function actionList_Interrupts()

            end -- End Action List - Interrupts
        -- Action List - Cooldowns
            function actionList_Cooldowns()
                -- -- Legendary Ring
                --     -- use_item,name=thorasus_the_stone_heart_of_draenor,if=(buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up))
                --     if useCDs() and isChecked("Legendary Ring") and (buff.bloodbath or (not talent.bloodbath and debuff.colossusSmash)) then
                --         if hasEquiped(124634) and canUse(124634) then
                --             useItem(124634)
                --             return true
                --         end
                --     end
                -- -- Potion
                --     -- potion,name=draenic_strength,if=(target.health.pct<20&buff.recklessness.up)|target.time_to_die<25
                --     if useCDs() and canUse(strPot) and inRaid and isChecked("Agi-Pot") then
                --         if (thp<20 and buff.recklessness) or ttd<25 then
                --             useItem(strPot)
                --         end
                --     end
                -- -- Racials
                --     -- blood_fury
                --     -- arcane_torrent
                --     -- berserking
                --     if useCDs() and (bb.player.race == "Orc" or bb.player.race == "Troll" or bb.player.race == "Blood Elf") then
                --         if bb.player.castRacial() then return end
                --     end
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
            -- Charge
                if cast.charge("target") then return end
            end
        -- Action List - Single
            function actionList_Single()

            end -- End Action List - Single
        -- Action List - MultiTarget
            function actionList_MultiTarget()
           
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
                if not inCombat and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                    if actionList_PreCombat() then return end
                    if inRange(spell.slam,units.dyn5) then
                        StartAttack()
                    else
                        if cast.charge("target") then return end
                    end
                end
  -----------------------------
  --- In Combat - Rotations --- 
  -----------------------------
                if inCombat then
                    if actionList_Movement() then return end
            -- Execute
                    if cast.execute() then return end
            -- Mortal Strike
                    if cast.mortalStrike() then return end
            -- Slam
                    if cd.mortalStrike > 0 or level < 5 then
                        if cast.slam() then return end
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