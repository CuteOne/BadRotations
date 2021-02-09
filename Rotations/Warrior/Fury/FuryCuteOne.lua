local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.whirlwind },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladestorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.ragingBlow },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
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
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- AoE Slider
            br.ui:createSpinnerWithout(section, "AoE Threshold",  2,  1,  10,  1,  "|cffFFFFFFSet to desired targets to start AoE Rotation. Min: 1 / Max: 10 / Interval: 1")
            -- Battle Shout
            br.ui:createCheckbox(section,"Battle Shout")
            -- Bladestorm Units
            br.ui:createSpinnerWithout(section, "Bladestorm Units", 3, 1, 10, 1, "|cffFFFFFFSet to desired minimal number of units required to use Bladestorm.")
            -- Berserker Rage
            br.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
            -- Charge
            br.ui:createCheckbox(section,"Charge", "Check to use Charge")
            -- Heroic Leap
            br.ui:createDropdown(section,"Heroic Leap", br.dropOptions.Toggle, 6, "Set auto usage (No Hotkey) or desired hotkey to use Heroic Leap.")
            br.ui:createDropdownWithout(section,"Heroic Leap - Target",{"Best","Target"},1,"Desired Target of Heroic Leap")
            -- Piercing Howl
            br.ui:createCheckbox(section,"Piercing Howl", "Check to use Piercing Howl")
			-- Rampage Fast
			br.ui:createCheckbox(section,"Faster Rampage", "Uses Rampage faster")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- Racials
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Bladestorm
            br.ui:createCheckbox(section,"Bladestorm")
			-- Heroic Throw
            br.ui:createCheckbox(section,"Heroic Throw")
            -- Dragon Roar
            br.ui:createCheckbox(section,"Dragon Roar")
            -- Recklessness
            br.ui:createDropdownWithout(section, "Recklessness", {"Always", "Cooldown", "Never"}, 1, "Desired usage of spell.")
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
            -- Enraged Regeneration
            br.ui:createSpinner(section, "Enraged Regeneration", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Intimidating Shout
            br.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Rallying Cry
            br.ui:createSpinner(section, "Rallying Cry", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
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
            br.ui:createCheckbox(section,"Intimidating Shout - Int")
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
        br.player.ui.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]

--------------
--- Locals ---
--------------
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local hastar                                        = hastar or GetObjectExists("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local equiped                                       = br.player.equiped
        local gcd                                           = br.player.gcdMax
        local heirloomNeck                                  = 122667 or 122668
        local inCombat                                      = br.player.inCombat
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local mode                                          = br.player.ui.mode
        local moving                                        = GetUnitSpeed("player")>0
        local php                                           = br.player.health
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
        enemies.get(15)
        enemies.get(20)

        if profileStop == nil then profileStop = false end

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
                    if not UnitIsDeadOrGhost(thisUnit) and getDistance(thisUnit) < 100 and buff.battleShout.remain(thisUnit) < 600 then
                        if cast.battleShout() then return end
                    end
                end
            end
            -- Berserker Rage
            if isChecked("Berserker Rage") and cast.able.berserkerRage() and hasNoControl(spell.berserkerRage) then
                if cast.berserkerRage() then return end
            end
            -- Piercing Howl
            if isChecked("Piercing Howl") and cast.able.piercingHowl() then
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
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(getHealthPot()) then
                        useItem(getHealthPot())
                    end
                end
            -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(heirloomNeck) then
                        if canUseItem(heirloomNeck) then
                            useItem(heirloomNeck)
                        end
                    end
                end
            -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and cast.able.racial() and race == "Draenei" and php <= getOptionValue("Gift of the Naaru") and php > 0 then
                    if cast.racial() then return end
                end
            -- Enraged Regeneration
                if isChecked("Enraged Regeneration") and cast.able.enragedRegeneration() and inCombat and php <= getOptionValue("Enraged Regeneration") then
                    if cast.enragedRegeneration() then return end
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
				if isChecked("Heroic Throw")
					and cast.able.heroicThrow() and getDistance("target") >= 8 and (cast.last.charge() or charges.charge.count() == 0 or not isChecked("Charge")) then
						if cast.heroicThrow("target") then return end
                end
            end
        end
    -- Action List - Single
        function actionList_Single()
        --Seigebreaker
            -- siegebreaker
            if cast.able.siegebreaker() then
                if cast.siegebreaker() then return end
            end
        -- Rampage
            -- rampage,if=buff.recklessness.up|(talent.frothing_berserker.enabled|talent.carnage.enabled&(buff.enrage.remains<gcd|rage>90)|talent.massacre.enabled&(buff.enrage.remains<gcd|rage>90))
            if isChecked("Faster Rampage") then
                if cast.able.rampage() and buff.recklessness.exists()
                    or (talent.carnage and (buff.enrage.exists() or rage > 75))
                    or (talent.frothingBerserker and (buff.enrage.exists() or rage > 95))
                    or (talent.massacre and (buff.enrage.exists() or rage > 85))
                then
                    if cast.rampage() then return end
                end
            else
                if cast.able.rampage() and (buff.recklessness.exists()
                    or (talent.frothingBerserker or talent.carnage and (buff.enrage.remain() < gcd or rage > 90)
                    or talent.massacre and (buff.enrage.remain() < gcd or rage > 90)))
                then
                    if cast.rampage() then return end
                end
            end
        -- Execute
            -- execute,if=buff.enrage.up
            if cast.able.execute() and (buff.enrage.exists()) then
                if cast.execute() then return end
	      end
        -- Bloodthirst
            -- bloodthirst,if=buff.enrage.down|azerite.cold_steel_hot_blood.rank>1
            if cast.able.bloodthirst() and (not buff.enrage.exists() or traits.coldSteelHotBlood.rank > 1) then
                if cast.bloodthirst() then return end
            end
        -- Raging Blow
            -- raging_blow,if=charges=2
            if cast.able.ragingBlow() and (charges.ragingBlow.count() == 2) then
                if cast.ragingBlow() then return end
            end
        -- Bloodthirst
            -- bloodthirst
            if cast.able.bloodthirst() then
                if cast.bloodthirst() then return end
            end
        -- Bladestorm
            -- bladestorm,if=prev_gcd.1.rampage&(debuff.siegebreaker.up|!talent.siegebreaker.enabled)
            if isChecked("Bladestorm") 
				and	cast.able.bladestorm() and ((mode.rotation == 1 and (#enemies.yards8 >= getOptionValue("AoE Threshold") or talent.siegebreaker)) or (mode.rotation == 2 and #enemies.yards8 > 0))
					and (cast.last.rampage() and (debuff.siegebreaker.exists(units.dyn8) or not talent.siegebreaker))
            then
                if cast.bladestorm() then return end
            end
        -- Dragon Roar
            -- dragon_roar,if=buff.enrage.up
            if isChecked("Dragon Roar") and cast.able.dragonRoar(nil,"aoe") and buff.enrage.exists() then
                if cast.dragonRoar(nil,"aoe") then return end
            end
        -- Raging Blow
            -- raging_blow,if=talent.carnage.enabled|(talent.massacre.enabled&rage<80)|(talent.frothing_berserker.enabled&rage<90)
            if cast.able.ragingBlow() and (talent.carnage or (talent.massacre and rage < 80) or (talent.frothingBerserker and rage < 90)) then
                if cast.ragingBlow() then return end
            end
        -- Furious Slash
            -- furious_slash,if=talent.furious_slash.enabled
            if cast.able.furiousSlash() and (talent.furiousSlash) then
                if cast.furiousSlash() then return end
            end
        -- Whirlwind
            -- whirlwind
            if cast.able.whirlwind(nil,"aoe") and #enemies.yards8 > 0 and (level < 75 or charges.ragingBlow.count() == 0
                or rage >= 90 or (talent.massacre and rage >= 80))
            then
                if cast.whirlwind(nil,"aoe") then return end
            end
        end -- End Action List - Single
    -- Action List - Pre-Combat
        function actionList_PreCombat()
            -- food,type=pickled_eel
            -- snapshot_stats
            -- potion,name=Potion Of Bursting blood
            if useCDs() and inRaid and isChecked("Str-Pot") and isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
                if canUseItem(152560) then
                    useItem(152560)
                end
            end
        end  -- End Action List - Pre-Combat
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
            if not inCombat and isValidUnit("target") and not IsMounted() then
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
            if inCombat and isValidUnit(units.dyn5) and not IsMounted() then
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
            -- Potions
                -- potion
                if useCDs() and getDistance("target") < 5 and inRaid and isChecked("Potion") then
                    if canUseItem(152560) then
                        useItem(152560)
                    end
                end
            -- Furious Slash
                -- furious_slash,if=talent.furious_slash.enabled&(buff.furious_slash.stack<3|buff.furious_slash.remains<3|(cooldown.recklessness.remains<3&buff.furious_slash.remains<9))
                if cast.able.furiousSlash() and (talent.furiousSlash and (buff.furiousSlash.stack() < 3
                    or buff.furiousSlash.remain() < 3 or (cd.recklessness.remain() < 3 and buff.furiousSlash.remain() < 9)))
                then
                    if cast.furiousSlash() then return end
                end
            -- Rampage
                -- rampage,if=cooldown.recklessness.remains<3
                if cast.able.rampage() and (cd.recklessness.remain() < 3) then
                    if cast.rampage() then return end
                end
            -- Recklessness
                -- recklessness
                if cast.able.recklessness() and (getOptionValue("Recklessness") == 1 or (getOptionValue("Recklessness") == 2 and useCDs())) then
                    if cast.recklessness() then return end
                end
            -- Whirlwind
                -- whirlwind,if=spell_targets.whirlwind>1&!buff.meat_cleaver.up
                if cast.able.whirlwind() and (((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("AoE Threshold")) or (mode.rotation == 2 and #enemies.yards8 > 0)) and not buff.meatCleaver.exists()) then
                    if cast.whirlwind() then return end
                end
            -- Racial
                -- blood_fury,if=buff.recklessness.up
                -- berserking,if=buff.recklessness.up
                -- lights_judgment,if=buff.recklessness.down
                -- fireblood,if=buff.recklessness.up
                -- ancestral_call,if=buff.recklessness.up
                if cast.able.racial() and useCDs()
                    and ((buff.recklessness.exists() and (race == "Orc" or race == "Troll" or race == "DarkIronDwarf" or race == "MagharOrc"))
                        or (not buff.recklessness.exists() and race == "LightforgedDraenei"))
                then
                    if race == "LightforgedDraenei" then
                        if cast.racial("target","ground") then return true end
                    else
                        if cast.racial("player") then return true end
                    end
                end
            -- Trinkets
                if isChecked("Trinkets") and buff.enrage.exists() then
                    if canUseItem(13) and not (hasEquiped(140808,13) or hasEquiped(147012,13)) then
                        useItem(13)
                    end
                    if canUseItem(14) and not (hasEquiped(140808,14) or hasEquiped(147012,13)) then
                        useItem(14)
                    end
                end
            -- Action List - Single Target
                -- call_action_list,name=single_target
                if actionList_Single() then return end
            end -- End Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation
local id = 0 --72
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
