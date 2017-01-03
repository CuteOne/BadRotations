local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.whirlwind },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladestorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.furiousSlash },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.battleCry },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.battleCry },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.battleCry }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.enragedRegeneration },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.enragedRegeneration }
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
            -- Bladestorm Units
            br.ui:createSpinner(section, "Bladestorm Units", 3, 1, 10, 1, "|cffFFFFFFSet to desired minimal number of units required to use Bladestorm.")
            -- Berserker Rage
            br.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
            -- Heroic Leap
            br.ui:createDropdown(section,"Heroic Leap", br.dropOptions.Toggle, 6, "Set auto usage (No Hotkey) or desired hotkey to use Heroic Leap.")
            br.ui:createDropdownWithout(section,"Heroic Leap - Target",{"Best","Target"},1,"Desired Target of Heroic Leap")
            -- Piercing Howl
            br.ui:createCheckbox(section,"Piercing Howl", "Check to use Piercing Howl")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Artifact 
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
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
            -- Racials
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Touch of the Void
            br.ui:createCheckbox(section,"Touch of the Void")
            -- Avatar
            br.ui:createCheckbox(section,"Avatar")
            -- Battle Cry
            br.ui:createCheckbox(section,"Battle Cry")
            -- Bladestorm
            br.ui:createCheckbox(section,"Bladestorm")
            -- Bloodbath
            br.ui:createCheckbox(section,"Bloodbath")
            -- Dragon Roar
            br.ui:createCheckbox(section,"Dragon Roar")
            -- Shockwave
            br.ui:createCheckbox(section,"Shockwave")
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
            br.ui:createSpinner(section, "Commanding Shout", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Enraged Regeneration
            br.ui:createSpinner(section, "Enraged Regeneration", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Intimidating Shout
            br.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Shockwave
            br.ui:createSpinner(section, "Shockwave - HP", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinner(section, "Shockwave - Units", 3, 1, 10, 1, "|cffFFBB00Minimal units to cast on.")
            -- Storm Bolt
            br.ui:createSpinner(section, "Storm Bolt", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.") 
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Pummel
            br.ui:createCheckbox(section,"Pummel")
            -- Intimidating Shout
            br.ui:createCheckbox(section,"Intimidating Shout - Int")
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
    if br.timer:useTimer("debugFury", 0.1) then
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
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = ObjectExists("mouseover")
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
        local power, powerMax, powerGen                     = br.player.power.amount.rage, br.player.power.rage.max, br.player.power.regen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local recharge                                      = br.player.recharge
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local thp                                           = getHP(br.player.units.dyn5)
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.ttm
        local units                                         = br.player.units
        
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        -- ChatOverlay(round2(getDistance2("target"),2)..", "..round2(getDistance3("target"),2)..", "..round2(getDistance4("target"),2)..", "..round2(getDistance("target"),2))

--------------------
--- Action Lists ---
--------------------
    -- Action list - Extras
        function actionList_Extra()
            -- Dummy Test
            if isChecked("DPS Testing") then
                if ObjectExists("target") then
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
            -- Piercing Howl
            if isChecked("Piercing Howl") then
                for i=1, #enemies.yards15 do
                    thisUnit = enemies.yards15[i]
                    if isMoving(thisUnit) and getFacing(thisUnit,"player") == false and getDistance(thisUnit) >= 5 then
                        if cast.piercingHowl(thisUnit) then return end
                    end
                end
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
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and cd.giftOfTheNaaru==0 then
                    if cast.giftOfTheNaaru() then return end
                end
            -- Commanding Shout
                if isChecked("Commanding Shout") and inCombat and php <= getOptionValue("Commanding Shout") then
                    if cast.commandingShout() then return end
                end
            -- Enraged Regeneration
                if isChecked("Enraged Regeneration") and inCombat and php <= getOptionValue("Enraged Regeneration") then
                    if cast.enragedRegeneration() then return end
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
            if useCDs() and getDistance("target") < 5 then
        -- Touch of the Void
                if isChecked("Touch of the Void") then
                    if hasEquiped(128318) then
                        if GetItemCooldown(128318)==0 then
                            useItem(128318)
                        end
                    end
                end
        -- Trinkets
                if isChecked("Trinkets") then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
        -- Draught of Souls
                -- use_item,name=draught_of_souls,if=(spell_targets.whirlwind>1|!raid_event.adds.exists)&((talent.bladestorm.enabled&cooldown.bladestorm.remains=0)|buff.battle_cry.up|target.time_to_die<25)
        -- Potions
                -- potion,name=old_war,if=(target.health.pct<20&buff.battle_cry.up)|target.time_to_die<30
        -- Battle Cry
                -- battle_cry,if=(cooldown.odyns_fury.remains=0&(cooldown.bloodthirst.remains=0|(buff.enrage.remains>cooldown.bloodthirst.remains)))&buff.dragon_roar.up&gcd.remains<0.2
                if isChecked("Battle Cry") then
                    if ((not artifact.odynsFury or cd.odynsFury == 0) and (cd.bloodthirst == 0 or (buff.enrage.remain > cd.bloodthirst))) and (buff.dragonRoar.exists or not talent.dragonRoar) and cd.global < 0.2 then
                        if cast.battleCry() then return end
                    end
                end
        -- Avatar
                -- avatar,if=buff.battle_cry.up|(target.time_to_die<(cooldown.battle_cry.remains+10))
                if isChecked("Avatar") then
                    if buff.battleCry.exists or (ttd(units.dyn5) < (cd.battleCry + 10)) then
                        if cast.avatar() then return end
                    end
                end
        -- Bloodbath
                -- bloodbath,if=buff.dragon_roar.up|(!talent.dragon_roar.enabled&(buff.battle_cry.up|cooldown.battle_cry.remains>10))
                if isChecked("Bloodbath") then
                    if buff.dragonRoar.exists or (not talent.dragonRoar and (buff.battleCry.exists or cd.battleCry > 10)) then
                        if cast.bloodbath() then return end
                    end
                end
        -- Racials
                -- blood_fury,if=buff.battle_cry.up
                -- berserking,if=buff.battle_cry.up
                -- arcane_torrent,if=rage<rage.max-40
                if isChecked("Racial") then
                    if ((race == "Orc" or race == "Troll") and buff.battleCry.exists) or (race == "BloodElf" and power < powerMax - 40) then
                        if castSpell("target",racial,false,false,false) then return end
                    end
                end
            end 
        end
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
            -- food,type=pickled_eel
            -- stance,choose=battle
            -- if not buff.battleStance and php > getOptionValue("Defensive Stance") then
            --     if br.player.castBattleStance() then return end
            -- end
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
            if mode.mover == 1 and isValidUnit("target") then
        -- Heroic Leap
                -- heroic_leap
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
                if (cd.heroicLeap > 0 and cd.heroicLeap < 43) or level < 26 then
                    if cast.charge("target") then return end
                end 
        -- Storm Bolt
                -- storm_bolt
                if cast.stormBolt("target") then return end
        -- Heroic Throw
                -- heroic_throw
                if lastSpell == spell.charge or charges.charge == 0 then
                    if cast.heroicThrow("target") then return end
                end
            end
        end
    -- Action List - Bladestorm (OH GOD WHY!?!?!)
        function actionList_Bladestorm() 
        -- Bladestorm
            -- bladestorm,if=buff.enrage.remains>2&(raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets)
            if useCDs() and isChecked("Bladestorm") and getDistance(units.dyn8) < 8 then
                if buff.enrage.remain > 2 and (addsIn > 90 or not addsExists or #enemies.yards8 > getOptionValue("Bladestorm Units")) then
                    if cast.bladestorm() then return end
                end
            end
        end -- End Action List - Bladestorm (OH GOD WHY!?!?!)
    -- Action List - Single
        function actionList_Single()
        -- Bloodthirst
            -- bloodthirst,if=buff.fujiedas_fury.up&buff.fujiedas_fury.remains<2
            if buff.fujiedasFury.exists and buff.fujiedasFury.remain < 2 then
                if cast.bloodthirst() then return end
            end
        -- Execute
            -- execute,if=(artifact.juggernaut.enabled&(!buff.juggernaut.up|buff.juggernaut.remains<2))|buff.stone_heart.react
            if (artifact.juggernaut and (not buff.juggernaut.exists or buff.juggernaut.remain)) or buff.stoneHeart.exists then
                if cast.execute() then return end
            end
        -- Rampage
            -- rampage,if=rage=100&(target.health.pct>20|target.health.pct<20&!talent.massacre.enabled)|buff.massacre.react&buff.enrage.remains<1
            if (power == 100 and (thp > 20 or (thp < 20 and not talent.massacre))) or (buff.massacre.exists and buff.enrage.remain < 1) then
                if cast.rampage() then return end
            end
        -- Berserker Rage
            -- berserker_rage,if=talent.outburst.enabled&cooldown.odyns_fury.remains=0&buff.enrage.down
            if talent.outburst and cd.odynsFury == 0 and not buff.enrage.exists and getDistance(units.dyn5) < 5 then
                if cast.berserkerRage() then return end
            end
        -- Dragon Roar
            -- dragon_roar,if=cooldown.odyns_fury.remains>=10|cooldown.odyns_fury.remains<=3
            if isChecked("Dragon Roar") and getDistance(units.dyn5) < 5 then
                if cd.odynsFury >= 10 or cd.odynsFury <= 3 then
                    if cast.dragonRoar() then return end
                end
            end
        -- Odyn's Fury
            -- odyns_fury,if=buff.battle_cry.up&buff.enrage.up
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and getDistance(units.dyn5) < 5 then
                if buff.battleCry.exists and buff.enrage.exists then
                    if cast.odynsFury() then return end
                end
            end
        -- Rampage
            -- rampage,if=buff.enrage.down&buff.juggernaut.down
            if not buff.enrage.exists and not buff.juggernaut.exists then
                if cast.rampage() then return end
            end
        -- Furious Slash
            -- furious_slash,if=talent.frenzy.enabled&(buff.frenzy.down|buff.frenzy.remains<=3)
            if talent.frenzy and (not buff.frenzy.exists or buff.frenzy.remain <= 3) then
                if cast.furiousSlash() then return end
            end
        -- Raging Blow
            -- raging_blow,if=buff.juggernaut.down&buff.enrage.up
            if not buff.juggernaut.exists and buff.enrage.exists then
                if cast.ragingBlow() then return end
            end
        -- Whirlwind
            -- whirlwind,if=buff.wrecking_ball.react&buff.enrage.up
            if buff.wreckingBall.exists and buff.enrage.exists and getDistance(units.dyn8) < 8 then
                if cast.whirlwind() then return end
            end
        -- Execute
            -- execute,if=talent.inner_rage.enabled|!talent.inner_rage.enabled&rage>50
            if talent.innerRage or (not talent.innerRage and power > 50) then
                if cast.execute() then return end
            end
        -- Bloodthirst
            -- bloodthirst,if=buff.enrage.down
            if not buff.enrage.exists then
                if cast.bloodthirst() then return end
            end
        -- Raging Blow
            -- raging_blow,if=buff.enrage.down
            if not buff.enrage.exists then
                if cast.ragingBlow() then return end
            end
        -- Execute
            -- execute,if=artifact.juggernaut.enabled
            if artifact.juggernaut then
                if cast.execute() then return end
            end
        -- Raging Blow
            -- raging_blow
            if cast.ragingBlow() then return end
        -- Bloodthirst
            -- bloodthirst
            if cast.bloodthirst() then return end
        -- Furious Slash
            -- furious_slash
            if cast.furiousSlash() then return end
        -- Call Action List: Bladestorm
            -- call_action_list,name=bladestorm
            if actionList_Bladestorm() then return end
        -- Bloodbath
            -- bloodbath,if=buff.frothing_berserker.up|(rage>80&!talent.frothing_berserker.enabled)
            if useCDs() and isChecked("Bloodbath") and getDistance(units.dyn5) < 5 then
                if buff.frothingBerserker.exists or (power > 80 and not talent.frothingBerserker) then
                    if cast.bloodbath() then return end
                end
            end
        end -- End Action List - Single
    -- Action List - Two Targets
        function actionList_TwoTargets()
        -- Whirlwind
            -- whirlwind,if=buff.meat_cleaver.down
            if not buff.meatCleaver.exists and getDistance(units.dyn8) < 8 then
                if cast.whirlwind() then return end
            end
        -- Call Action List: Bladestorm
            -- call_action_list,name=bladestorm
            if actionList_Bladestorm() then return end
        -- Rampage
            -- rampage,if=buff.enrage.down|(rage=100&buff.juggernaut.down)|buff.massacre.up
            if not buff.enrage.exists or (power == 100 and not buff.juggernaut.exists) or buff.massacre.exists then
                if cast.rampage() then return end
            end
        -- Bloodthirst
            -- bloodthirst,if=buff.enrage.down
            if not buff.enrage.exists then
                if cast.bloodthirst() then return end
            end
        -- Odyn's Fury
            -- odyns_fury,if=buff.battle_cry.up&buff.enrage.up
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and getDistance(units.dyn5) < 5 then
                if buff.battleCry.exists and buff.enrage.exists then
                    if cast.odynsFury() then return end
                end
            end
        -- Raging Blow
            -- raging_blow,if=talent.inner_rage.enabled&spell_targets.whirlwind=2
            if talent.innerRage and #enemies.yards8 == 2 then
                if cast.ragingBlow() then return end
            end
        -- Whirlwind
            -- whirlwind,if=spell_targets.whirlwind>2
            if getDistance(units.dyn8) < 8 then
                if cast.whirlwind() then return end
            end
        -- Dragon Roar
            -- dragon_roar
            if isChecked("Dragon Roar") and getDistance(units.dyn5) < 5 then
                if cast.dragonRoar() then return end
            end
        -- Bloodthirst
            -- bloodthirst
            if cast.bloodthirst() then return end
        -- Whirlwind
            -- whirlwind
            if getDistance(units.dyn8) < 8 then
                if cast.whirlwind() then return end
            end
        end -- End Action List - Two Targets
    -- Action List - MultiTarget
        function actionList_MultiTarget()
        -- Touch of the Void
            if isChecked("Touch of the Void") and getDistance(units.dyn5) < 5 then
                if hasEquiped(128318) then
                    if GetItemCooldown(128318)==0 then
                        useItem(128318)
                    end
                end
            end
        -- Bloodthirst
            -- bloodthirst,if=buff.enrage.down|rage<50
            if not buff.enrage.exists or power < 50 then
                if cast.bloodthirst() then return end
            end
        -- Call Action List Bladestorm
            -- call_action_list,name=bladestorm
            if actionList_Bladestorm() then return end
        -- Odyn's Fury
            -- odyns_fury,if=buff.battle_cry.up&buff.enrage.up
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and getDistance(units.dyn5) < 5 then
                if buff.battleCry.exists and buff.enrage.exists then
                    if cast.odynsFury() then return end
                end
            end
        -- Whirlwind
            -- whirlwind,if=buff.enrage.up
            if buff.enrage.exists and getDistance(units.dyn8) < 8 then
                if cast.whirlwind() then return end
            end
        -- Dragon Roar
            -- dragon_roar
            if isChecked("Dragon Roar") and getDistance(units.dyn5) < 5 then
                if cast.dragonRoar() then return end
            end
        -- Rampage
            -- rampage,if=buff.meat_cleaver.up
            if buff.meatCleaver.exists then
                if cast.rampage() then return end
            end
        -- Bloodthirst
            -- bloodthirst
            if cast.bloodthirst() then return end
        -- Whirlwind
            -- whirlwind
            if getDistance(units.dyn8) < 8 then
                if cast.whirlwind() then return end
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
                    StartAttack()
                else
            -- Action List - Movement
                    -- run_action_list,name=movement,if=movement.getDistance(units.dyn5)>5
                    if getDistance("target") >= 8 then
                        if actionList_Movement() then return end
                    end
                end
            end
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat and isValidUnit(units.dyn5) then
            -- Auto Attack
                --auto_attack
                if getDistance(units.dyn5) < 5 then
                    if not IsCurrentSpell(6603) then
                        StartAttack(units.dyn5)
                    end
                end
            -- Action List - Movement
                -- run_action_list,name=movement,if=movement.getDistance(units.dyn5)>5
                if getDistance(units.dyn8) > 8 then
                    if actionList_Movement() then return end
                end
            -- Action List - Interrupts
                if actionList_Interrupts() then return end
            -- Action List - Cooldowns
                if actionList_Cooldowns() then return end
            -- Action List - Two Targets
                -- actions+=/call_action_list,name=two_targets,if=spell_targets.whirlwind=2|spell_targets.whirlwind=3
                if ((#enemies.yards8 == 2 or #enemies.yards8 == 3) and mode.rotation==1) and level >= 28 then
                    if actionList_TwoTargets() then return end
                end
            -- Action List - Multi Target
                --actions+=/call_action_list,name=aoe,if=spell_targets.whirlwind>3
                if ((#enemies.yards8 > 3 and mode.rotation == 1) or mode.rotation == 2) and level >= 28 then
                    if actionList_MultiTarget() then return end
                end
            -- Action List - Single Target
                -- actions+=/call_action_list,name=single_target
                if ((#enemies.yards8 == 1 and mode.rotation == 1) or mode.rotation == 3) or level < 28 then
                    if actionList_Single() then return end
                end
            end -- End Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation 
local id = 72
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})