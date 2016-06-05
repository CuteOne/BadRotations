if select(3,UnitClass("player")) == 1 then
    local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
    local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 0, icon = bb.player.spell.whirlwind },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.bladestorm },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.wildStrike },
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
                -- Piercing Howl
                bb.ui:createCheckbox(section,"Piercing Howl", "Check to use Piercing Howl")
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
                -- Racials
                bb.ui:createCheckbox(section,"Racial")
                -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
                -- Touch of the Void
                bb.ui:createCheckbox(section,"Touch of the Void")
                -- Avatar
                bb.ui:createCheckbox(section,"Avatar")
                -- Bladestorm
                bb.ui:createCheckbox(section,"Bladestorm")
                -- Bloodbath
                bb.ui:createCheckbox(section,"Bloodbath")
                -- Dragon Roar
                bb.ui:createCheckbox(section,"Dragon Roar")
                -- Ravager
                bb.ui:createCheckbox(section,"Ravager")
                -- Recklessness
                bb.ui:createCheckbox(section,"Recklessness")
                -- Shockwave
                bb.ui:createCheckbox(section,"Shockwave")
                -- Siegebreaker
                bb.ui:createCheckbox(section,"Siegebreaker")
            bb.ui:checkSectionState(section)
            -------------------------
            --- DEFENSIVE OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
                -- Healthstone
                bb.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
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
        if bb.timer:useTimer("debugFury", 0.1) then
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
            local powermax          = bb.player.powerMax
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
                if isChecked("Berserker Rage") and hasNoControl(bb.player.spell.berserkerRage) then
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
                -- Piercing Howl
                if isChecked("Piercing Howl") then
                    for i=1,#getEnemies("player",15) do
                        thisUnit = getEnemies("player",15)[i]
                        if isMoving(thisUnit) and getFacing(thisUnit,"player") == false then
                            if bb.player.castEnrangedRegeneration(thisUnit) then return end
                        end
                    end
                end
                -- Intervene
                if isChecked("Intervene") then
                    if bb.player.castIntervene("target") then return end
                end
            end -- End Action List - Extra
        -- Action List - Defensive
            function actionList_Defensive()
                if useDefensive() then
                -- Heirloom Neck
                    if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                        if hasEquiped(heirloomNeck) then
                            if GetItemCooldown(heirloomNeck)==0 then
                                useItem(heirloomNeck)
                            end
                        end
                    end 
                -- Gift of the Naaru
                    if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and cd.racial==0 and bb.player.race=="Draenei" then
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
                            if getOptionValue("Intervene - Target")==4 then
                                if getHP(thisUnit)<getOptionValue("Intervene") and getDistance(thisUnit)<25 then
                                    if bb.player.castVigilance(thisUnit) then return end
                                end
                            end
                            if getOptionValue("Intervene - Target")==3 then
                                if (UnitGroupRolesAssigned(thisUnit)=="HEALER" or UnitGroupRolesAssigned(thisUnit)=="TANK") and getHP(thisUnit)<getOptionValue("Intervene") and getDistance(thisUnit)<25 then
                                    if bb.player.castVigilance(thisUnit) then return end
                                end
                            end
                            if getOptionValue("Intervene - Target")==2 then
                                if UnitGroupRolesAssigned(thisUnit)=="HEALER" and getHP(thisUnit)<getOptionValue("Intervene") and getDistance(thisUnit)<25 then
                                    if bb.player.castVigilance(thisUnit) then return end
                                end
                            end
                            if getOptionValue("Intervene - Target")==1 then
                                if UnitGroupRolesAssigned(thisUnit)=="TANK" and getHP(thisUnit)<getOptionValue("Intervene") and getDistance(thisUnit)<25 then
                                    if bb.player.castVigilance(thisUnit) then return end
                                end
                            end
                        end
                    end
                -- Intimidating Shout
                    if isChecked("Intimidating Shout") and inCombat and php <= getOptionValue("Intimidating Shout") then
                        if bb.player.castIntimidatingShout() then return end
                    end
                -- Rallying Cry
                    if isChecked("Rallying Cry") and inCombat and php <= getOptionValue("Rallying Cry") then
                        if bb.player.castRallyingCry() then return end
                    end
                -- Shield Barrier
                    if isChecked("Shield Barrier") and inCombat and php <= getOptionValue("Shield Barrier") then
                        if not buff.defensiveStance and not buff.shieldBarrier then
                            if bb.player.castDefensiveStance() then return end
                        else
                            if bb.player.castShieldBarrier() then return end
                        end
                    end
                -- Vigilance
                    if isChecked("Vigilance") then
                        for i=1,#nNova do
                            thisUnit = nNova[i].unit
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
                            if UnitCastingInfo(thisUnit) ~= nil then
                                if (select(6,UnitCastingInfo(thisUnit))/1000 - GetTime())<5 and UnitName("targettarget") == UnitName("player") then
                                    if bb.player.castSpellReflection() then return end
                                end
                            end
                        end
                    end
                end
            end -- End Action List - Interrupts
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
                -- food,type=pickled_eel
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
                if useMover() and lastSpellCast~=bb.player.spell.charge then
                    if bb.player.castHeroicLeap() then return end
                end
            -- Charge
                -- charge,cycle_targets=1,if=debuff.charge.down
                if useMover() then
                    if bb.player.castCharge() then return end
                end 
            -- Storm Bolt
                -- storm_bolt
                if bb.player.castStormBolt() then return end
            -- Heroic Throw
                -- heroic_throw
                if bb.player.castHeroicThrow() then return end
            end
        -- Action List - Bladestorm (OH GOD WHY!?!?!)
            function actionList_Bladestorm() 
            -- Recklessness
                -- recklessness,sync=bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets)
                if useCDs() and isChecked("Recklessness") and getDistance(bb.player.units.dyn8AoE)<8 then
                    if buff.remain.enrage>6 then
                        if bb.player.castRecklessness() then return end
                    end
                end
            -- Bladestorm
                -- bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets)
                if useCDs() and isChecked("Bladestorm") and getDistance(bb.player.units.dyn8AoE)<8 then
                    if buff.remain.enrage>6 then
                        if bb.player.castBladestorm() then return end
                    end
                end
            end -- End Action List - Bladestorm (OH GOD WHY!?!?!)
        -- Action List - Single
            function actionList_Single()
            -- Bloodbath
                -- bloodbath
                if isChecked("Bloodbath") and getDistance(bb.player.units.dyn8AoE)<8 then
                    if bb.player.castBloodbath() then return end
                end
            -- Recklessness
                -- recklessness,if=target.health.pct<20&raid_event.adds.exists
                if useCDs() and isChecked("Recklessness") then
                    if thp<20 then
                        if bb.player.castRecklessness() then return end
                    end
                end
            -- Wild Strike
                -- wild_strike,if=(rage>rage.max-20)&target.health.pct>20
                if (power>powermax-20) and thp>20 then
                    if bb.player.castWildStrike() then return end
                end
            -- Bloodthirst
                -- bloodthirst,if=(!talent.unquenchable_thirst.enabled&(rage<rage.max-40))|buff.enrage.down|buff.raging_blow.stack<2
                if (not talent.unquenchableThirst and (power<powermax-40)) or not buff.enrage or charges.ragingBlow<2 then
                    if bb.player.castBloodthirst() then return end
                end
            -- Ravager
                -- ravager,if=buff.bloodbath.up|(!talent.bloodbath.enabled&(!raid_event.adds.exists|raid_event.adds.in>60|target.time_to_die<40))
                if isChecked("Ravager") then
                    if buff.bloodbath or (not talent.bloodbath and ttd<40) then
                        if bb.player.castRavager() then return end
                    end
                end
            -- Siegebreaker
                -- siegebreaker
                if isChecked("Siegebreaker") and getDistance(bb.player.units.dyn5)<5 then
                    if bb.player.castSiegebreaker() then return end
                end
            -- Execute
                -- execute,if=buff.sudden_death.react
                if buff.suddenDeath then
                    if bb.player.castExecute(bb.player.units.dyn5) then return end
                end
            -- Storm Bolt
                -- storm_bolt
                if bb.player.castStormBolt() then return end
            -- Wild Strike
                -- wild_strike,if=buff.bloodsurge.up
                if buff.bloodsurge then
                    if bb.player.castWildStrike() then return end
                end
            -- Execute
                -- execute,if=buff.enrage.up|target.time_to_die<12
                if buff.enrage or ttd<12 then
                    if bb.player.castExecute(bb.player.units.dyn5) then return end
                end
            -- Dragon Roar
                -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
                if isChecked("Dragon Roar") and getDistance(bb.player.units.dyn8AoE)<8 then
                    if buff.bloodbath or not talent.bloodbath then
                        if bb.player.castDragonRoar() then return end
                    end
                end
            -- Raging Blow
                -- raging_blow
                if bb.player.castRagingBlow() then return end
            -- Wait
                -- wait,sec=cooldown.bloodthirst.remains,if=cooldown.bloodthirst.remains<0.5&rage<50
                if cd.bloodthirst>0 and cd.bloodthirst<0.5 and power<50 then
                    return true
                end
            -- Wild Strike
                -- wild_strike,if=buff.enrage.up&target.health.pct>20
                if buff.enrage and thp>20 then
                    if bb.player.castWildStrike() then return end
                end
            -- Bladestorm
                -- bladestorm,if=!raid_event.adds.exists
                if isChecked("Bladestorm") and getDistance(bb.player.units.dyn8AoE)<8 then 
                    if bb.player.castBladestorm() then return end
                end
            -- Shockwave
                -- shockwave,if=!talent.unquenchable_thirst.enabled
                if isChecked("Shockwave") and getDistance(bb.player.units.dyn8AoE)<8 then
                    if not talent.unquenchableThirst then
                        if bb.player.castShockwave() then return end
                    end
                end
            -- Impending Victory
                -- impending_victory,if=!talent.unquenchable_thirst.enabled&target.health.pct>20
                if not talent.unquenchableThirst and thp>20 then
                    if bb.player.castImpendingVictory() then return end
                end
            -- Bloodthirst
                -- bloodthirst
                if bb.player.castBloodthirst() then return end
            end -- End Action List - Single
        -- Action List - Two Targets
            function actionList_TwoTargets()
            -- Bloodbath
                -- bloodbath
                if isChecked("Bloodbath") and getDistance(bb.player.units.dyn8AoE)<8 then
                    if bb.player.castBloodbath() then return end
                end
            -- Ravager
                -- ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
                if isChecked("Ravager") then
                    if buff.bloodbath or not talent.bloodbath then
                        if bb.player.castRavager() then return end
                    end
                end
            -- Dragon Roar
                -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
                if isChecked("Dragon Roar") and getDistance(bb.player.units.dyn8AoE)<8 then
                    if buff.bloodbath or not talent.bloodbath then
                        if bb.player.castDragonRoar() then return end
                    end
                end
            -- Call Action List - Bladestorm (OH GOD WHY!?!?!)
                -- call_action_list,name=bladestorm
                if actionList_Bladestorm() then return end
            -- Bloodthirst
                -- bloodthirst,if=buff.enrage.down|rage<40|buff.raging_blow.down
                if not buff.enrage or power<40 or not buff.ragingBlow then
                    if bb.player.castBloodthirst() then return end
                end
            -- Siegebreaker
                -- siegebreaker
                if isChecked("Siegebreaker") and getDistance(bb.player.units.dyn5)<5 then
                    if bb.player.castSiegebreaker() then return end
                end
            -- Execute
                -- execute,cycle_targets=1
                for i=1, #getEnemies("player",5) do
                    thisUnit = getEnemies("player",5)[i]
                    if bb.player.castExecute(thisUnit) then return end
                end
            -- Raging Blow
                -- raging_blow,if=buff.meat_cleaver.up|target.health.pct<20
                if buff.meatCleaver or thp<20 then
                    if bb.player.castRagingBlow() then return end
                end
            -- Whirlwind
                -- whirlwind,if=!buff.meat_cleaver.up&target.health.pct>20
                if not buff.meatCleaver and thp>20 then
                    if bb.player.castWhirlwind() then return end
                end
            -- Wild Strike
                -- wild_strike,if=buff.bloodsurge.up
                if buff.bloodsurge then
                    if bb.player.castWildStrike() then return end
                end
            -- Bloodthirst
                -- bloodthirst
                if bb.player.castBloodthirst() then return end
            -- Whirlwind
                -- whirlwind
                if bb.player.castWhirlwind() then return end
            end -- End Action List - Two Targets
        -- Action List - Three Targets
            function actionList_ThreeTargets()
            -- Bloodbath
                -- bloodbath
                if isChecked("Bloodbath") and getDistance(bb.player.units.dyn8AoE)<8 then
                    if bb.player.castBloodbath() then return end
                end
            -- Ravager
                -- ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
                if isChecked("Ravager") then
                    if buff.bloodbath or not talent.bloodbath then
                        if bb.player.castRavager() then return end
                    end
                end
            -- Call Action List - Bladestorm (OH GOD WHY!?!?!)
                if actionList_Bladestorm() then return end
            -- Bloodthirst
                -- bloodthirst,if=buff.enrage.down|rage<50|buff.raging_blow.down
                if not buff.enrage or power<50 or not buff.ragingBlow then
                    if bb.player.castBloodthirst() then return end
                end
            -- Raging Blow
                -- raging_blow,if=buff.meat_cleaver.stack>=2
                if charges.meatCleaver>=2 then
                    if bb.player.castRagingBlow() then return end
                end
            -- Siegebreaker
                -- siegebreaker
                if isChecked("Siegebreaker") and getDistance(bb.player.units.dyn5)<5 then
                    if bb.player.castSiegebreaker() then return end
                end
            -- Execute
                -- execute,cycle_targets=1
                for i=1, #getEnemies("player",5) do
                    thisUnit = getEnemies("player",5)[i]
                    if bb.player.castExecute(thisUnit) then return end
                end
            -- Dragon Roar
                -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
                if isChecked("Dragon Roar") and getDistance(bb.player.units.dyn8AoE)<8 then
                    if buff.bloodbath or not talent.bloodbath then
                        if bb.player.castDragonRoar() then return end
                    end
                end
            -- Whirlwind
                -- whirlwind,if=target.health.pct>20
                if thp>20 then
                    if bb.player.castWhirlwind() then return end
                end
            -- Bloodthirst
                -- bloodthirst
                if bb.player.castBloodthirst() then return end
            -- Wild Strike
                -- wild_strike,if=buff.bloodsurge.up
                if buff.bloodsurge then
                    if bb.player.castWildStrike() then return end
                end
            -- Raging Blow
                if bb.player.castRagingBlow() then return end
            end -- End Action List - Three Targets
        -- Action List - MultiTarget
            function actionList_MultiTarget()
            -- Touch of the Void
                if isChecked("Touch of the Void") and getDistance(bb.player.units.dyn5)<5 then
                    if hasEquiped(128318) then
                        if GetItemCooldown(128318)==0 then
                            useItem(128318)
                        end
                    end
                end
            -- Bloodbath
                -- bloodbath
                if isChecked("Bloodbath") and getDistance(bb.player.units.dyn8AoE)<8 then
                    if bb.player.castBloodbath() then return end
                end
            -- Ravager
                -- ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
                if isChecked("Ravager") then
                    if buff.bloodbath or not talent.bloodbath then
                        if bb.player.castRavager() then return end
                    end
                end
            -- Raging Blow
                -- if=buff.meat_cleaver.stack>=3&buff.enrage.up
                if charges.meatCleaver>=3 and buff.enrage then
                    if bb.player.castRagingBlow() then return end
                end
            -- Bloodthirst
                -- bloodthirst,if=buff.enrage.down|rage<50|buff.raging_blow.down
                if not buff.enrage or power<50 or not buff.ragingBlow then
                    if bb.player.castBloodthirst() then return end
                end
            -- Call Action List - Bladestorm (OH GOD WHY!?!?!)
                -- call_action_list,name=bladestorm
                if actionList_Bladestorm() then return end
            -- Whirlwind
                -- whirlwind
                if bb.player.castWhirlwind() then return end
            -- Siegebreaker
                -- siegebreaker
                if isChecked("Siegebreaker") and getDistance(bb.player.units.dyn5)<5 then
                    if bb.player.castSiegebreaker() then return end
                end
            -- Execute
                -- execute,if=buff.sudden_death.react
                if buff.suddenDeath then
                    if bb.player.castExecute(bb.player.units.dyn5) then return end
                end
            -- Dragon Roar
                -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
                if isChecked("Dragon Roar") and getDistance(bb.player.units.dyn8AoE)<8 then
                    if buff.bloodbath or not talent.bloodbath then
                        if bb.player.castDragonRoar() then return end
                    end
                end  
            -- Bloodthirst
                -- bloodthirst
                if bb.player.castBloodthirst() then return end
            -- Wild Strike
                -- wild_strike,if=buff.bloodsurge.up
                if buff.bloodsurge then
                    if bb.player.castWildStrike() then return end
                end   
            end -- End Action List - MultiTarget
        -- Action List - Recklessness w/ Anger Management
            function actionList_ReckAngerManagement()
            -- Recklessness
                -- recklessness,if=(target.time_to_die>140|target.health.pct<20)&(buff.bloodbath.up|!talent.bloodbath.enabled|target.time_to_die<15)
                if useCDs() and isChecked("Recklessness") then
                    if (ttd>140 or thp<20) and (buff.bloodbath or not talent.bloodbath or ttd<15) then
                        if bb.player.castRecklessness() then return end
                    end
                end
            end -- End Action List - Recklessness w/ Anger Management
        -- Action List - Recklessness w/o Anger Management
            function actionList_ReckNoAnger()
            -- Recklessness
                -- recklessness,if=(target.time_to_die>190|target.health.pct<20)&(buff.bloodbath.up|!talent.bloodbath.enabled|target.time_to_die<15)
                if useCDs() and isChecked("Recklessness") then
                    if (ttd>190 or thp<20) and (buff.bloodbath or not talent.bloodbath or ttd<15) then
                        if bb.player.castRecklessness() then return end
                    end
                end 
            end -- End Action List - Recklessness w/o Anger Management
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
                    if distance<5 then
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
                    if useMover() then
                        if bb.player.castCharge() then return end
                    end
                -- Auto Attack
                    --auto_attack
                    if distance<5 then
                        StartAttack()
                    end
                -- Action List - Movement
                    -- run_action_list,name=movement,if=movement.distance>5
                    if distance>5 then
                        if actionList_Movement() then return end
                    end
                -- Action List - Interrupts
                    if actionList_Interrupts() then return end
                -- Berserker Rage
                    -- berserker_rage,if=buff.enrage.down|(prev_gcd.bloodthirst&buff.raging_blow.stack<2)
                    if not buff.enrage or (lastSpellCast==bb.player.spell.bloodthirst and charges.ragingBlow<2) then
                        if getDistance(bb.player.units.dyn5)<5 then
                            if bb.player.castBeserkerRage() then return end
                        end
                    end
                -- Heroic Leap
                    -- heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
                    if useMover() and lastSpellCast~=bb.player.spell.charge then
                        if bb.player.castHeroicLeap() then return end
                    end
                -- Legendary Ring
                    -- use_item,name=thorasus_the_stone_heart_of_draenor,if=(buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up))
                    if useCDs() and isChecked("Legendary Ring") and (buff.bloodbath or (not talent.bloodbath and debuff.colossusSmash)) then
                        if hasEquiped(124634) and canUse(124634) then
                            useItem(124634)
                            return true
                        end
                    end
                -- Potion
                    -- potion,name=draenic_strength,if=(target.health.pct<20&buff.recklessness.up)|target.time_to_die<=30
                    if useCDs() and getDistance(bb.player.units.dyn5)<5 and canUse(strPot) and inRaid and isChecked("Agi-Pot") then
                        if (thp<20 and buff.recklessness) or ttd<=30 then
                            useItem(strPot)
                        end
                    end
                -- Touch of the Void
                    if useCDs() and isChecked("Touch of the Void") and getDistance(bb.player.units.dyn5)<5 then
                        if hasEquiped(128318) then
                            if GetItemCooldown(128318)==0 then
                                useItem(128318)
                            end
                        end
                    end
                -- Trinkets
                    if useCDs() and isChecked("Trinkets") and getDistance(bb.player.units.dyn5)<5 then
                        if canUse(13) then
                            useItem(13)
                        end
                        if canUse(14) then
                            useItem(14)
                        end
                    end
                -- Action List - Single Target
                    -- run_action_list,name=single_target,if=(raid_event.adds.cooldown<60&raid_event.adds.count>2&spell_targets.whirlwind=1)|raid_event.movement.cooldown<5
                    if targets==1 or not useAoE() then
                        if actionList_Single() then return end
                    end
                -- Recklessness
                    -- recklessness,if=(buff.bloodbath.up|cooldown.bloodbath.remains>25|!talent.bloodbath.enabled|target.time_to_die<15)&((talent.bladestorm.enabled&(!raid_event.adds.exists|enemies=1))|!talent.bladestorm.enabled)&set_bonus.tier18_4pc
                    if useCDs() and isChecked("Recklessness") and getDistance(bb.player.units.dyn5)<5 then
                        if (buff.bloodbath or cd.bloodbath > 25 or not talent.bloodbath or ttd<15) and ((talent.bladestorm and (targets==1)) or not talent.bladestorm) and t18_4pc then
                            if bb.player.castRecklessness() then return end
                        end
                    end
                -- Call Action List - Recklessness w/ Anger Management
                    -- call_action_list,name=reck_anger_management,if=talent.anger_management.enabled&((talent.bladestorm.enabled&(!raid_event.adds.exists|enemies=1))|!talent.bladestorm.enabled)&!set_bonus.tier18_4pc
                    if useCDs() and getDistance(bb.player.units.dyn5)<5 then
                        if talent.angerManagement and ((talent.bladestorm and enemies==1) or not talent.bladestorm) and not t18_4pc then
                            if actionList_ReckAngerManagement() then return end
                        end
                    end
                -- Call Action List - Recklessness w/o Anger Management
                    -- call_action_list,name=reck_no_anger,if=!talent.anger_management.enabled&((talent.bladestorm.enabled&(!raid_event.adds.exists|enemies=1))|!talent.bladestorm.enabled)&!set_bonus.tier18_4pc
                    if useCDs() and getDistance(bb.player.units.dyn5)<5 then
                        if not talent.angerManagement and ((talent.bladestorm and enemies==1) or not talent.bladestorm) and not t18_4pc then
                            if actionList_ReckNoAnger() then return end
                        end
                    end
                -- Avatar
                    -- avatar,if=buff.recklessness.up|cooldown.recklessness.remains>60|target.time_to_die<30
                    if useCDs() and isChecked("Avatar") and getDistance(bb.player.units.dyn5)<5 then
                        if buff.recklessness or cd.recklessness>60 or ttd<30 then
                            if bb.player.castAvatar() then return end
                        end
                    end
                -- Racials
                    -- blood_fury
                    -- arcane_torrent
                    -- berserking
                    if useCDs() and isChecked("Racial") and getDistance(bb.player.units.dyn5)<5 then
                        if (bb.player.race == "Orc" or bb.player.race == "Troll" or bb.player.race == "Blood Elf") then
                            if bb.player.castRacial() then return end
                        end
                    end
                -- Action List - Two Targets
                    -- call_action_list,name=two_targets,if=spell_targets.whirlwind=2
                    if targets==2 and useAoE() then
                        if actionList_TwoTargets() then return end
                    end
                -- Action List - Three Targets
                    -- call_action_list,name=three_targets,if=spell_targets.whirlwind=3
                    if targets==3 and useAoE() then
                        if actionList_ThreeTargets() then return end
                    end
                -- Action List - Multi Target
                    if targets>3 and useAoE() then
                        if actionList_MultiTarget() then return end
                    end
                -- Action List - Single Target
                    if targets==1 or not useAoE() then
                        if actionList_Single() then return end
                    end
                end -- End Combat Rotation
            end -- Pause
        end -- End Timer
    end -- End runRotation 
    tinsert(cFury.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end -- End Select Warrior