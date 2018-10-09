local rotationName = "Winston"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.flamestrike},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.flamestrike},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.pyroblast},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.iceBlock}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.combustion},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.combustion},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.combustion}
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.blazingBarrier},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.blazingBarrier}
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterspell},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterspell}
    };
    CreateButton("Interrupt",4,0)
-- Legendary Dragonbreath Button
    DragonsBreathModes = {
        [1] = { mode = "On", value = 1 , overlay = "Legendary Dragonbreath Enabled", tip = "Always use Legendary Dragonbreath.", highlight = 1, icon = br.player.spell.dragonsBreath},
        [2] = { mode = "Off", value = 2 , overlay = "Legendary Dragonbreath Disabled", tip = "Let BR decide when to use Legedary Dragonbreath.", highlight = 0, icon = br.player.spell.dragonsBreath}
    };
    CreateButton("DragonsBreath",5,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
    -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- FlameStrike Targets
            br.ui:createSpinnerWithout(section, "Flamestrike Targets",  3,  1,  10,  1, "Unit Count Limit before casting Flamestrike.")
        -- Artifact 
        --    br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Mirror Image
            br.ui:createCheckbox(section,"Mirror Image")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
        -- Frost Nova
            br.ui:createSpinner(section, "Frost Nova",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Blazing Barrier
            br.ui:createCheckbox(section,"Blazing Barrier")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Couterspell
            br.ui:createCheckbox(section, "Counterspell")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
        -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
        -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
        -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
        -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugFire", math.random(0.07,0.1)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("DragonsBreath",0.25)
        br.player.mode.dragonsBreath = br.data.settings[br.selectedSpec].toggles["DragonsBreath"]
--------------
--- Locals ---
--------------
        local addsExist                                     = false 
        local addsIn                                        = 999
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local castable                                      = br.player.cast.debug
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or GetUnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
        local hasteAmount                                   = GetHaste()/100
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local moveIn                                        = 999
        local moving                                        = isMoving("player")
        local tmoving                                       = isMoving("target")
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units

        units.get(12)
        units.get(25)
        units.get(40)
        enemies.get(6,"target")
        enemies.get(8,"target")
        enemies.get(10,"target")
        enemies.get(12,"target")
        enemies.get(25,"target")
        enemies.get(30)
        
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if talent.kindling then kindle = 1 else kindle = 0 end
        if not talent.kindling then notKindle = 1 else notKindle = 0 end
        --if #enemies.yards40 == 1 then singleEnemy = 1 else singleEnemy = 0 end
        
        --local activeEnemies = #enemies.yards40
        local fSEnemies = getEnemies(units.dyn40, 8, true)


--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
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

        end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
            if useDefensive() then
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
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end
        -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Frost Nova
                if isChecked("Frost Nova") and php <= getOptionValue("Frost Nova") and #enemies.yards12 > 0 then
                    if cast.frostNova() then return end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Counterspell
                        if isChecked("Counterspell") then
                            if cast.counterspell(thisUnit) then return end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if useCDs() and getDistance(units.dyn40) < 40 then
        -- Potion
                -- potion,name=deadly_grace
                -- TODO
        -- Trinkets
                -- use_item,slot=trinket2,if=buff.chaos_blades.up|!talent.chaos_blades.enabled 
                if isChecked("Trinkets") then
                    -- if buff.chaosBlades or not talent.chaosBlades then 
                        if canUse(13) then
                            useItem(13)
                        end
                        if canUse(14) then
                            useItem(14)
                        end
                    -- end
                end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury | berserking | arcane_torrent
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "Blood Elf") then
                    if castSpell("player",racial,false,false,false) then return end
                end
            end -- End useCDs check
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
                if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

                end -- End Pre-Pull
                if isValidUnit("target") and getDistance("target") < 40 then
            -- Arcane Intellect
                    if not buff.arcaneIntellect.exists() then
                        cast.arcaneIntellect()
                    end                    
            -- Mirror Image
                    if useCDs() and isChecked("Mirror Image") then
                        if cast.mirrorImage() then return end
                    end
            -- Pyroblast
                    if br.timer:useTimer("delayPyro", getCastTime(spell.pyroblast)+0.5) then
                        if cast.pyroblast("target") then return end
                    end
                end
            end -- End No Combat
        end -- End Action List - PreCombat
    -- Action List - Active Talents
        local function actionList_ActiveTalents()
        -- Flame On
            -- flame_on,if=action.fire_blast.charges=0&(cooldown.combustion.remains>40+(talent.kindling.enabled*25)|target.time_to_die.remains<cooldown.combustion.remains)
            --if charges.fireBlast.count() == 0 and (cd.combustion.remain() > 40 + (kindle * 25) or (ttd("target") < cd.combustion.remain()) or (isDummy("target") and cd.combustion.remain() > 45)) then
            --    if cast.flameOn() then return end
            --end
        -- Blast Wave
            -- blast_wave,if=(buff.combustion.down)|(buff.combustion.up&action.fire_blast.charges<1&action.phoenixs_flames.charges<1)
            if (not buff.combustion.exists()) or (buff.combustion.exists() and charges.fireBlast.count() < 1 and charges.phoenixsFlames.count() < 1) then
                if cast.blastWave() then return end
            end
        -- Meteor
            -- meteor,if=cooldown.combustion.remains>30|(cooldown.combustion.remains>target.time_to_die)|buff.rune_of_power.up
            if (cd.combustion.remain() > 30 or (cd.combustion.remain() > ttd("target")) or buff.runeOfPower.exists()) and ttd("target") > 8 and not tmoving then
                if cast.meteor("target",nil,1,7) then return end
            end
        -- Cinderstorm
            -- cinderstorm,if=cooldown.combustion.remains<cast_time&(buff.rune_of_power.up|!talent.rune_on_power.enabled)|cooldown.combustion.remains>10*spell_haste&!buff.combustion.up
            if cd.combustion.remain() < getCastTime(spell.cinderstorm) and (buff.runeOfPower.exists() or not talent.runeOfPower) or cd.combustion.remain() > 10 * hasteAmount and not buff.combustion.exists() then
                if cast.cinderstorm() then return end
            end
        -- Dragon's Breath
            -- dragons_breath,if=equipped.132863
            --(getFacing("player",units.dyn12,10) and hasEquiped(132863) and getDistance(units.dyn12) < 12)
            --(getFacing("player",units.dyn37,10) and talent.alexstraszasFury and not buff.hotStreak.exists() and getDistance(units.dyn37) < 37)
            if (getFacing("player",units.dyn25,10) and talent.alexstraszasFury and hasEquiped(132863) and getDistance(units.dyn25) < 25) and getEnemiesInCone(25,10) > 2 then
                if cast.dragonsBreath(units.dyn25) then return end
            elseif (getFacing("player",units.dyn12,10) and talent.alexstraszasFury and getDistance(units.dyn12) < 12) 
                or (getFacing("player",units.dyn25,10) and hasEquiped(132863) and getDistance(units.dyn25) < 25) then
                if cast.dragonsBreath(units.dyn12) then return end
            end
        -- Living Bomb
            -- living_bomb,if=active_enemies>1&buff.combustion.down
--            if ((#enemies.yards10t >= 1 and mode.rotation == 1) or mode.rotation == 2) and not buff.combustion.exists() then
            if ((#enemies.yards6t >= 1 and mode.rotation == 1) or mode.rotation == 2) then
                if cast.livingBomb("target") then return end
            end
        end -- End Active Talents Action List
    -- Action List - Combustion Phase
        local function actionList_CombustionPhase()
        -- Rune of Power
            -- rune_of_power,if=buff.combustion.down
            if not moving and not buff.combustion.exists() then 
                if cast.runeOfPower("player","ground") then return end
            end
        -- Call Action List - Active Talents
            -- call_action_list,name=active_talents
            if actionList_ActiveTalents() then return end
        -- Combustion
            -- combustion
            if useCDs() and (not talent.firestarter or (talent.firestarter and getHP("target") < 90)) then
                if cast.combustion() then return end
            end
        -- Call Action List - Cooldowns
            if actionList_Cooldowns() then return end
        -- Pyroblast
            -- pyroblast,if=buff.kaelthas_ultimate_ability.react&buff.combustion.remains>execute_time 
            -- pyroblast,if=buff.hot_streak.up
            if (buff.kaelthasUltimateAbility.exists() or buff.pyroclasm.exists() and buff.combustion.remain() > getCastTime(spell.pyroblast)) or buff.hotStreak.exists() then
                if cast.pyroblast() then return end
            end
        -- Fire Blast
            -- fire_blast,if=buff.heating_up.up
            if (charges.fireBlast.frac() > 1.5 and cd.combustion.remain() == 0) then
                if cast.fireBlast() then return end
            elseif buff.heatingUp.exists() and buff.combustion.exists() then
                if cast.fireBlast() then return end
            end
        -- Phoenix's Flames
            -- phoenixs_flames
            if buff.combustion.exists() and not buff.hotStreak.exists() and charges.phoenixsFlames.count() > 1 then
               if cast.phoenixsFlames() then return end
           end
        -- Scorch
            -- scorch,if=buff.combustion.remains>cast_time
            if buff.combustion.remain() > getCastTime(spell.scorch) then
                if cast.scorch() then return end
            end
        -- Dragon's Breath
            -- dragons_breath,if=buff.hot_streak.down&action.fire_blast.charges<1&action.phoenixs_flames.charges<1
            --(getFacing("player",units.dyn12,10) and hasEquiped(132863) and getDistance(units.dyn12) < 12)
            --(getFacing("player",units.dyn25,10) and talent.alexstraszasFury and not buff.hotStreak.exists() and getDistance(units.dyn25) < 25)
            if (getFacing("player",units.dyn12,10) and not buff.hotStreak.exists() and charges.fireBlast.count() < 1 and charges.phoenixsFlames.count() < 1 and getDistance(units.dyn12) < 12) then
                -- if cast.dragonsBreath(units.dyn12) then return end
                if cast.dragonsBreath("player") then return end
            elseif not buff.hotStreak.exists() then
                if (getDistance(units.dyn12) < 12) and talent.alexstraszasFury then
                    -- if cast.dragonsBreath(units.dyn12) then return end
                    if cast.dragonsBreath("player") then return end
                elseif ((getDistance(units.dyn25) < 25) and hasEquiped(132863)) then
                    -- if cast.dragonsBreath(units.dyn25) then return end
                    if cast.dragonsBreath("player") then return end
                end
            end
        -- Scorch
            -- scorch,if=target.health.pct<=25&equipped.132454
            if getHP("target") <= 25 and talent.searingTouch then
                if cast.scorch() then return end
            end
        end -- End Combustion Phase Action List
    -- Action List - ROP Phase
        local function actionList_ROPPhase()
        -- Rune of Power
            -- rune_of_power
            if not moving and useCDs() then
                if cast.runeOfPower() then return end
            end
        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.up
            if buff.hotStreak.exists() then
                if cast.pyroblast() then return end
            end
        -- Call Action List - Active Talents
            -- call_action_list,name=active_talents
            if actionList_ActiveTalents() then return end
        -- Pyroblast
            -- pyroblast,if=buff.kaelthas_ultimate_ability.react
            if buff.kaelthasUltimateAbility.exists() or buff.pyroclasm.exists() then
                if cast.pyroblast() then return end
            end
        -- Fire Blast
            -- fire_blast,if=!prev_off_gcd.fire_blast
            if lastSpell ~= spell.fireBlast then
                if cast.fireBlast() then return end
            end
        -- Phoenix's Flames
            -- phoenixs_flames,if=!prev_gcd.phoenixs_flames
            if lastSpell ~= spell.phoenixsFlames then
                if cast.phoenixsFlames() then return end
            end
        -- Scorch
            -- scorch,if=target.health.pct<=25&equipped.132454
            if getHP("target") <= 25 and talent.searingTouch then
                if cast.scorch() then return end
            end
        -- Fireball
            -- fireball
            if cast.fireball() then return end
        end -- End ROP Phase Action List
    -- Action List - Single Target
        local function actionList_Single()
        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.up&buff.hot_streak.remains<action.fireball.execute_time
            if buff.hotStreak.exists() and buff.hotStreak.remain() < getCastTime(spell.fireball) then
                if cast.pyroblast() then return end
            end
        -- Phoenix's Flames
            -- /phoenixs_flames,if=charges_fractional>1.7
            if charges.phoenixsFlames.frac() > 1.7 then
                if ((mode.cooldown == 1 and isBoss()) or mode.cooldown == 2) then
                    if cast.phoenixsFlames() then return end
                end
            end
            -- /phoenixs_flames,if=charges_fractional>2&active_enemies>2    
            if (charges.phoenixsFlames.frac() >= 2 and charges.phoenixsFlames.frac() <= 2.7) then
                if ((#enemies.yards8t >= 2 and mode.rotation == 1) or mode.rotation == 2) then
                    if cast.phoenixsFlames() then return end
                end
            end
        -- Flamestrike
            -- flamestrike,if=talent.flame_patch.enabled&active_enemies>2&buff.hot_streak.react - #enemies.yards8t - #fSEnemies
            if ((#fSEnemies >= getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) and buff.hotStreak.exists() then
                if cast.flamestrike("best",nil,1,8) then return end
            elseif ((#fSEnemies >= getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) and buff.hotStreak.exists() and not talent.pyromaniac then
                if cast.flamestrike("best",nil,1,8) then return end
            end
        -- Dragon's Breath
            --(getFacing("player",units.dyn12,10) and hasEquiped(132863) and getDistance(units.dyn12) < 12)
            --(getFacing("player",units.dyn25,10) and talent.alexstraszasFury and not buff.hotStreak.exists() and getDistance(units.dyn25) < 25)
            if ((getFacing("player",units.dyn12,10) and mode.rotation == 1) or mode.rotation == 2) and getDistance(units.dyn12) < 12 then
                if cast.dragonsBreath(units.dyn12) then return end
            elseif ((talent.alexstraszasFury and hasEquiped(132863)) or talent.alexstraszasFury or hasEquiped(132863)) then
                if hasEquiped(132863) and ((getDistance(units.dyn25) < 24) and mode.rotation == 1) then
                    -- if cast.dragonsBreath(units.dyn25) then return end
                    if cast.dragonsBreath("player") then return end
                elseif ((getDistance(units.dyn12) < 12) and mode.rotation == 1) then
                    -- if cast.dragonsBreath(units.dyn12) then return end
                    if cast.dragonsBreath("player") then return end
                end
            end
        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.up&!prev_gcd.pyroblast
            -- pyroblast,if=buff.hot_streak.react&target.health.pct<=25&equipped.132454
            -- pyroblast,if=buff.kaelthas_ultimate_ability.react
            if (buff.hotStreak.exists() and lastSpell ~= spell.pyroblast)
                or (buff.hotStreak.exists() and getHP("target") <= 25 and hasEquiped(132454))
                or buff.kaelthasUltimateAbility.exists() or buff.pyroclasm.exists()
            then
                if cast.pyroblast() then return end
            end
        -- Call Action List - Active Talents
            -- call_action_list,name=active_talents
            if actionList_ActiveTalents() then return end
        -- Fire Blast
            -- fire_blast,if=!talent.kindling.enabled&buff.heating_up.up&(!talent.rune_of_power.enabled|charges_fractional>1.4|cooldown.combustion.remains<40)&(3-charges_fractional)*(12*spell_haste)<cooldown.combustion.remains+3|target.time_to_die.remains<4
            -- fire_blast,if=talent.kindling.enabled&buff.heating_up.up&(!talent.rune_of_power.enabled|charges_fractional>1.5|cooldown.combustion.remains<40)&(3-charges_fractional)*(18*spell_haste)<cooldown.combustion.remains+3|target.time_to_die.remains<4
            if (not talent.kindling and buff.heatingUp.exists() and (not talent.runeOfPower or charges.fireBlast.frac() > 1.4 or cd.combustion.remain() < 40) and (3 - charges.fireBlast.frac()) * (12 * hasteAmount) < cd.combustion.remain() + 3 or ttd("target") < 4)
                or (talent.kindling and buff.heatingUp.exists() and (not talent.runeOfPower or charges.fireBlast.frac() > 1.5 or cd.combustion.remain() < 40) and (3 - charges.fireBlast.frac()) * (18 * hasteAmount) < cd.combustion.remain() + 3 or ttd("target") < 4)
            then
                if cast.fireBlast() then return end
            end
        -- Phoenix's Flames
            -- phoenixs_flames,if=(buff.combustion.up|buff.rune_of_power.up|buff.incanters_flow.stack>3|talent.mirror_image.enabled)&artifact.phoenix_reborn.enabled().enabled&(4-charges_fractional)*13<cooldown.combustion.remains+5|target.time_to_die.remains<10
            -- phoenixs_flames,if=(buff.combustion.up|buff.rune_of_power.up)&(4-charges_fractional)*30<cooldown.combustion.remains+5
            if isBoss() and (charges.phoenixsFlames.count() >= 1 or useCDs()) and (((buff.combustion.exists() or buff.runeOfPower.exists() or buff.incantersFlow.stack() > 3 or talent.mirrorImage) and artifact.phoenixReborn.enabled() and (4 - charges.phoenixsFlames.frac()) * 13 < cd.combustion.remain() + 5 or ttd("target") < 10) 
                or ((buff.combustion.exists() or buff.runeOfPower.exists()) and (4 - charges.phoenixsFlames.frac()) * 30 < cd.combustion.remain() + 5))
            then
                if cast.phoenixsFlames() then return end
            end
        -- Scorch
            -- scorch,actions.standard_rotation+=/scorch,if=(target.health.pct<=30&talent.searing_touch.enabled)|(azerite.preheat.enabled&debuff.preheat.down)
            if getHP("target") <= 30 and talent.searingTouch then --or (traits.preheat.active() and not buff.preheat.exists("player")) then
                if cast.scorch() then return end
            end
        -- Fireball
            -- fireball
            if cast.fireball() then return end
        end  -- End Single Target Action List
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or IsMounted() or pause() or mode.rotation==4 then
            if buff.heatingUp.exists() then
                if cast.fireBlast() then return end
            end
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
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and profileStop==false and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 then
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
        -- Blazing Barrier
                    if isChecked("Blazing Barrier") and not buff.blazingBarrier.exists() then
                        if cast.blazingBarrier() then return end
                    end
        -- Dragon's Breath
                    if (getFacing("player",units.dyn25,10) and hasEquiped(132863) and getDistance(units.dyn25) < 25) and mode.dragonsBreath == 1 then
                        if cast.dragonsBreath(units.dyn25) then return end
                    end
        -- Flamestrike
                    -- flamestrike,if=talent.flame_patch.enabled&active_enemies>2&buff.hot_streak.react
                    if ((#fSEnemies >= getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) and buff.hotStreak.exists() then
                        if cast.flamestrike("best",nil,1,8) then return end
                    elseif ((#fSEnemies >= getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) and buff.hotStreak.exists() and not talent.pyromaniac then
                        if cast.flamestrike("best",nil,1,8) then return end
                    end
        -- Mirror Image
                    -- mirror_image,if=buff.combustion.down
                    if useCDs() and isChecked("Mirror Image") and not buff.combustion.exists() then
                        if cast.mirrorImage() then return end
                    end
        -- Rune of Power
                    -- rune_of_power,if=cooldown.combustion.remains>40&buff.combustion.down&(cooldown.flame_on.remains<5|cooldown.flame_on.remains>30)&!talent.kindling.enabled|target.time_to_die.remains<11|talent.kindling.enabled&(charges_fractional>1.8|time<40)&cooldown.combustion.remains>40
                    if not moving and useCDs() and cd.combustion.remain() > 40 and not buff.combustion.exists() and (cd.flameOn.remain() < 5 or cd.flameOn.remain() > 30) and (not talent.kindling or ttd("target") < 11 or (talent.kindling and (charges.fireBlast.frac() > 1.8 or combatTime < 40) and cd.combustion.remain() > 40)) then
                        if cast.runeOfPower("player","ground") then return end
                    end
        -- Action List - Combustion Phase
                    -- call_action_list,name=combustion_phase,if=cooldown.combustion.remains<=action.rune_of_power.cast_time+(!talent.kindling.enabled*gcd)|buff.combustion.up
                    if cd.combustion.remain() < getCastTime(spell.runeOfPower) + (notKindle * gcd) or buff.combustion.exists() then
                        if actionList_CombustionPhase() then return end
                    end
        -- Action List - Rune of Power Phase
                    -- call_action_list,name=rop_phase,if=buff.rune_of_power.up&buff.combustion.down
                    if buff.runeOfPower.exists() and not buff.combustion.exists() then
                        if actionList_ROPPhase() then return end
                    end
        -- Action List - Single
                    -- call_action_list,name=single_target
                    if actionList_Single() then return end
        -- Scorch
                    if moving then
                        if cast.scorch() then return end
                    end
                end -- End SimC APL
    ----------------------
    --- AskMrRobot APL ---
    ----------------------
                if getOptionValue("APL Mode") == 2 then

                end
            end --End In Combat
        end --End Rotation Logic
    end -- End Timer
end -- End runRotation
local id = 63
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})