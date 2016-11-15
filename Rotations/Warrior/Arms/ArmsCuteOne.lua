if select(3,UnitClass("player")) == 1 then
    local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
    local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 0, icon = br.player.spell.sweepingStrikes },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.whirlwind },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mortalStrike },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.victoryRush}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.recklessness },
            [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.recklessness },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.recklessness }
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
                -- -- Battle/Commanding
                -- br.ui:createCheckbox(section, "Battle/Commanding", "Check to use Battle/Commanding Shouts")
                -- -- Berserker Rage
                -- br.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
                -- -- Hamstring
                -- br.ui:createCheckbox(section,"Hamstring", "Check to use Hamstring")
                -- -- Heroic Leap
                -- br.ui:createDropdown(section,"Heroic Leap", br.dropOptions.Toggle, 6, "Set auto usage (No Hotkey) or desired hotkey to use Heroic Leap.")
                -- br.ui:createDropdownWithout(section,"Heroic Leap - Traget",{"Best","Target"},1,"Desired Target of Heroic Leap")
                -- -- Intervene - Movement
                -- br.ui:createCheckbox(section,"Intervene - Movement", "Check to use Intervene as a gap closer")
                -- Pre-Pull Timer
                br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            br.ui:checkSectionState(section)
            ------------------------
            --- COOLDOWN OPTIONS ---
            ------------------------
            section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
                -- Agi Pot
                br.ui:createCheckbox(section,"Str-Pot")
                -- Legendary Ring
                br.ui:createCheckbox(section, "Legendary Ring", "Enable or Disable usage of Legendary Ring.")
                -- Flask / Crystal
                br.ui:createCheckbox(section,"Flask / Crystal")
                -- Trinkets
                br.ui:createCheckbox(section,"Trinkets")
                -- Touch of the Void
                br.ui:createCheckbox(section,"Touch of the Void")
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
                -- -- Defensive Stance
                -- br.ui:createSpinner(section, "Defensive Stance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- -- Die By The Sword
                -- br.ui:createSpinner(section, "Die by the Sword",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- -- Enraged Regeneration
                -- br.ui:createSpinner(section, "Enraged Regeneration", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
                -- -- Intervene
                -- br.ui:createSpinner(section, "Intervene",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- br.ui:createDropdownWithout(section, "Intervene - Target", {"|cff00FF00TANK","|cffFFFF00HEALER","|cffFF0000TANK/HEALER","ANY"}, 4, "|cffFFFFFFFriendly to cast on")
                -- -- Intimidating Shout
                -- br.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- -- Rallying Cry
                -- br.ui:createSpinner(section, "Rallying Cry",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- -- Shield Barrier
                -- br.ui:createSpinner(section, "Shield Barrier", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
                -- -- Vigilance
                -- br.ui:createSpinner(section, "Vigilance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- br.ui:createDropdownWithout(section, "Vigilance - Target", {"|cff00FF00TANK","|cffFFFF00HEALER","|cffFF0000TANK/HEALER","ANY"}, 4, "|cffFFFFFFFriendly to cast on")
            br.ui:checkSectionState(section)
            -------------------------
            --- INTERRUPT OPTIONS ---
            -------------------------
            section = br.ui:createSection(br.ui.window.profile, "Interrupts")
                -- -- Pummel
                -- br.ui:createCheckbox(section,"Pummel")
                -- -- Intimidating Shout
                -- br.ui:createCheckbox(section,"Intimidating Shoult - Int")
                -- -- Spell Reflection
                -- br.ui:createCheckbox(section,"Spell Refelection")
                -- Interrupt Percentage
                br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")    
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
                -- Mover Toggle
                br.ui:createDropdown(section,  "Mover Mode", br.dropOptions.Toggle,  6)
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
        if br.timer:useTimer("debugArms", 0.1) then
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
            local buff              = br.player.buff
            local dyn5              = br.player.units.dyn5
            local canFlask          = canUse(br.player.flask.wod.strengthBig)
            local cast              = br.player.cast
            local cd                = br.player.cd
            local charges           = br.player.charges
            local combatTime        = getCombatTime()
            local debuff            = br.player.debuff
            local distance          = getDistance("target")
            local enemies           = br.player.enemies
            local flaskBuff         = getBuffRemain("player",br.player.flask.wod.buff.strengthBig) or 0
            local frac              = br.player.frac
            local gcd               = br.player.gcd
            local glyph             = br.player.glyph
            local hasThreat         = hasThreat("target")
            local healthPot         = getHealthPot() or 0
            local heirloomNeck      = 122667 or 122668
            local inCombat          = br.player.inCombat
            local inRaid            = select(2,IsInInstance())=="raid"
            local level             = br.player.level
            local mode              = br.player.mode
            local php               = br.player.health
            local power             = br.player.power
            local pullTimer         = br.DBM:getPulltimer()
            local race              = br.player.race
            local racial            = br.player.getRacial()
            local raidAdd           = false --Need to determine how to check raid add
            local raidAddIn         = 0 --Time until Raid Add
            local ravaging          = false --Need to determine prev gcd is ravager
            local recharge          = br.player.recharge
            local regen             = br.player.powerRegen
            local solo              = select(2,IsInInstance())=="none"
            local spell             = br.player.spell
            local strPot            = 1 --Get Stregth Potion ID
            local t17_2pc           = br.player.eq.t17_2pc
            local t18_2pc           = br.player.eq.t18_2pc 
            local t18_4pc           = br.player.eq.t18_4pc
            local t18trinket        = false --Need to get check for T18 class trinket
            local talent            = br.player.talent
            local targets           = #getEnemies("player",8)
            local thp               = getHP(br.player.units.dyn5)
            local ttd               = getTimeToDie(br.player.units.dyn5)
            local ttm               = br.player.timeToMax
            local units             = br.player.units
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
                    if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and br.player.race=="Draenei" then
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
                --     if useCDs() and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "Blood Elf") then
                --         if br.player.castRacial() then return end
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