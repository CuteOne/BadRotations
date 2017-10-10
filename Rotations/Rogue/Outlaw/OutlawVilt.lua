local rotationName = "Vilt"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "DPS Rotation Enabled", tip = "Enable DPS Rotation", highlight = 1, icon = br.player.spell.runThrough},
        [2] = { mode = "Off", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.crimsonVial}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.adrenalineRush},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.adrenalineRush},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.adrenalineRush}
    };
    CreateButton("Cooldown",2,0)
-- Blade Flurry Button
    BladeFlurryModes = {
        [1] = { mode = "On", value = 1 , overlay = "Blade Flurry Enabled", tip = "Rotation will use Blade Flurry.", highlight = 1, icon = br.player.spell.bladeFlurry},
        [2] = { mode = "Off", value = 2 , overlay = "Blade Flurry Disabled", tip = "Rotation will not use Blade Flurry.", highlight = 0, icon = br.player.spell.bladeFlurry}
    };
    CreateButton("BladeFlurry",3,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.riposte},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.riposte}
    };
    CreateButton("Defensive",4,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.kick},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick}
    };
    CreateButton("Interrupt",5,0)
    MFDModes = {
        [1] = { mode = "Tgt", value = 1 , overlay = "Target", tip = "Will MFD Target", highlight = 1, icon = br.player.spell.markedForDeath},
        [2] = { mode = "Adds", value = 2 , overlay = "Adds", tip = "Will MFD Adds", highlight = 1, icon = br.player.spell.markedForDeath},
        [3] = { mode = "Off", value = 2 , overlay = "Off", tip = "Will not MFD", highlight = 0, icon = br.player.spell.markedForDeath}
    };
    CreateButton("MFD",6,0)
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
            -- Opening Attack
            br.ui:createCheckbox(section, "Opener")
            -- mfd prepull
            br.ui:createCheckbox(section, "Marked For Death - Precombat")
            -- RTb Prepull
            br.ui:createCheckbox(section, "RTB Prepull")
            -- Stealth
            br.ui:createDropdown(section, "Stealth", {"|cff00FF00Always", "|cffFF000020Yards"},  2, "Stealthing method.")
            -- Artifact
            br.ui:createCheckbox(section, "Artifact")
        br.ui:checkSectionState(section)
        ------------------------
        --- OFFENSIVE OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Offensive")
            -- Trinkets
            br.ui:createCheckbox(section, "Trinkets")
            -- Agi Pot
            br.ui:createCheckbox(section, "Agi-Pot")
            if hasEquiped(137031) then
            -- Sprint with Boots
                br.ui:createCheckbox(section, "Legendary Boots Logic")
            end
            -- Marked For Death
            --br.ui:createDropdown(section, "Marked For Death", {"|cff00FF00Target", "|cffFFDD00Lowest"}, 1)
            -- Vanish
            br.ui:createCheckbox(section, "Vanish")
            -- Racial
            br.ui:createCheckbox(section, "Racial")
            -- Pistol Shot OOR
            br.ui:createSpinner(section, "Pistol Shot out of range", 85,  5,  100,  5,  "|cffFFFFFFCheck to use Pistol Shot out of range and energy to use at.")
            -- CB
            br.ui:createSpinner(section, "Cannonball Barrage", 3, 0, 10, 1)
            -- KS
            br.ui:createCheckbox(section, "Killing Spree")
            -- RTB
            br.ui:createCheckbox(section, "RTB", "Roll for 2 with Loaded Dice")
            -- BF
            br.ui:createSpinnerWithout(section, "Blade Flurry Timer", 3, 0, 5, 1)
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healing Potion/Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Crimson Vial
            br.ui:createSpinner(section, "Crimson Vial",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Feint
            br.ui:createSpinner(section, "Feint", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Riposte
            br.ui:createSpinner(section, "Riposte",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Cloak with KS
            br.ui:createCheckbox(section, "Cloak Killing Spree")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Kick
            br.ui:createCheckbox(section, "Kick")
            -- Gouge
            br.ui:createCheckbox(section, "Gouge")
            -- Blind
            br.ui:createCheckbox(section, "Blind")
            -- Parley
            br.ui:createCheckbox(section, "Parley")
            -- Between the Eyes
            br.ui:createCheckbox(section, "Between the Eyes")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
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
            -- Cleave Toggle
            br.ui:createDropdown(section,  "BladeFlurry Mode", br.dropOptions.Toggle,  6)
            br.ui:createDropdown(section,  "MFD Mode", br.dropOptions.Toggle,  6)
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
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("BladeFlurry",0.25)
        br.player.mode.bladeflurry = br.data.settings[br.selectedSpec].toggles["BladeFlurry"]
        UpdateToggle("MFD",0.25)
        br.player.mode.mfd = br.data.settings[br.selectedSpec].toggles["MFD"]

--------------
--- Locals ---
--------------
        if profileStop == nil then profileStop = false end
        local attacktar                                     = UnitCanAttack("target","player")
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local cd                                            = br.player.cd
        local combo, comboDeficit, comboMax                 = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
        local cTime                                         = getCombatTime()
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local gcd                                           = br.player.gcd
        local hastar                                        = GetObjectExists("target")
        local healPot                                       = getHealthPot()
        local inCombat                                      = isInCombat("player")
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local mode                                          = br.player.mode
        local php                                           = br.player.health
        local power, powerDeficit, powerRegen               = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local solo                                          = #br.friend < 2
        local spell                                         = br.player.spell
        local stealth                                       = br.player.buff.stealth.exists()
        local stealthingAll                                 = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowmeld.exists()
        local stealthingRogue                               = br.player.buff.stealth.exists() or br.player.buff.vanish.exists()
        local stealthingMantle                              = br.player.buff.stealth.exists() or br.player.buff.vanish.exists()
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.energy.ttm()
        local units                                         = units or {}
        local lootDelay                                     = getOptionValue("LootDelay")

        if ImprovedSND == nil then ImprovedSND = false end

        units.dyn5 = br.player.units(5)
        units.dyn30 = br.player.units(30)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards20 = br.player.enemies(20)
        enemies.yards30 = br.player.enemies(30)

        if talent.acrobaticStikes then rangeMod = 3 else rangeMod = 0 end
        if leftCombat == nil then leftCombat = GetTime() end
        if vanishTime == nil then vanishTime = GetTime() end

        if buff.rollTheBones == nil then buff.rollTheBones = {} end
        buff.rollTheBones.count    = 0
        buff.rollTheBones.duration = 0
        buff.rollTheBones.remain   = 0
        for k,v in pairs(spell.buffs.rollTheBones) do
            if UnitBuffID("player",v) ~= nil then
                buff.rollTheBones.count    = buff.rollTheBones.count + 1
                buff.rollTheBones.duration = getBuffDuration("player",v)
                buff.rollTheBones.remain   = getBuffRemain("player",v)
            end
        end

        local function rtbReroll()
            --rtb_reroll,value=!talent.slice_and_dice.enabled&rtb_buffs<2&buff.loaded_dice.up
            return (not talent.sliceAndDice and buff.rollTheBones.count < 2 and buff.loadedDice.exists()) and true or false

            --[[if getOptionValue("RTB") == 1 then
                if not talent.sliceAndDice and (buff.rollTheBones.count >= 3 or buff.trueBearing.exists()) then
                    return false
                else
                    return true
                end

            elseif getOptionValue("RTB") == 2 then
                if not talent.sliceAndDice and (buff.rollTheBones.count >= 2  or buff.trueBearing.exists() or (buff.sharkInfestedWaters.exists() and (buff.adrenalineRush.exists() or debuff.curseOfTheDreadblades.exists("player")))) then
                    return false
                else
                    return true
                end

            elseif getOptionValue("RTB") == 3 then
                if not talent.sliceAndDice and buff.rollTheBones.count >= 1 then
                    return false
                 else
                    return true
                end
            end]]
        end

        local function ssUsableNoReroll()
            return (combo < 5 + (talent.deeperStrategem and 1 or 0) - ((buff.broadsides.exists() or buff.jollyRoger.exists()) and 1 or 0) - ((talent.alacrity and buff.alacrity.stack() <= 4) and 1 or 0)) and true or false
        end

        local function ssUsable()
            return (((talent.anticipation and combo < 5) or (not talent.anticipation and ((rtbReroll() and combo < 4 + (talent.deeperStrategem and 1 or 0)) or (not rtbReroll() and ssUsableNoReroll()))))) and true or false
        end

        local function ambushCondition()
            return (comboDeficit >= 2 + 2 * ((talent.ghostlyStrike and not debuff.ghostlyStrike.exists("target")) and 1 or 0) + (buff.broadsides.exists() and 1 or 0) and power >= 60 and not buff.jollyRoger.exists() and not buff.hiddenBlade.exists()) and true or false
        end

--------------------
--- Action Lists ---
--------------------
    --[[ Action List - Extras
        local function actionList_Extras()
        end -- End Action List - Extras]]
    -- Action List - DefensiveModes
        local function actionList_Defensive()
            if useDefensive() and not stealth then
            -- Health Pot/Healthstone
                if isChecked("Healing Potion/Healthstone") and php <= getOptionValue("Healing Potion/Healthstone")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
                        useItem(healPot)
                    end
                end
            -- Crimson Vial
                if isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
                    if cast.crimsonVial() then return end
                end
            -- Feint
                if isChecked("Feint") and php <= getOptionValue("Feint") and inCombat and not buff.feint then
                    if cast.feint() then return end
                end
            -- Riposte
                if isChecked("Riposte") and php <= getOptionValue("Riposte") and inCombat then
                    if cast.riposte() then return end
                end
            end
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() and not stealth then
                for i = 1, #enemies.yards20 do
                    local thisUnit = enemies.yards20[i]
                    local distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) and hasThreat(thisUnit) then
                        if distance < 5 then
        -- Kick
                            -- kick
                            if isChecked("Kick") then
                                if cast.kick(thisUnit) then return end
                            end
                            if cd.kick.remain() ~= 0 then
        -- Gouge
                                if isChecked("Gouge") and getFacing(thisUnit,"player") then
                                    if cast.gouge(thisUnit) then return end
                                end
                            end
                        end
                        if (cd.kick.remain() ~= 0 and cd.gouge.remain() ~= 0) or (distance >= 5 and distance < 15) then
        -- Blind
                            if isChecked("Blind") then
                                if cast.blind(thisUnit) then return end
                            end
                            if isChecked("Parley") then
                                if cast.parley(thisUnit) then return end
                            end
                        end
        -- Between the Eyes
                        if ((cd.kick.remain() ~= 0 and cd.gouge.remain() ~= 0) or distance >= 5) and (cd.blind.remain() ~= 0 or level < 38 or distance >= 15) then
                            if isChecked("Between the Eyes") then
                                if cast.betweenTheEyes(thisUnit) then return end
                            end
                        end
                    end
                end
            end -- End Interrupt and No Stealth Check
        end -- End Action List - Interrupts
    -- Action List - Blade Flurry
        local function actionList_BladeFlurry()
        -- Blade Flurry
            if buff.bladeFlurry.exists() then
                if #getEnemies("player",7) < 2 and buff.bladeFlurry.exists() then
                    -- if cast.bladeFlurry() then return end
                    if not delayBladeFlurry or delayBladeFlurry == 0 then
                        delayBladeFlurry = GetTime() + getOptionValue("Blade Flurry Timer")
                    elseif delayBladeFlurry < GetTime() then
                        CastSpellByName(GetSpellInfo(spell.bladeFlurry),"player");
                    end
                end
                if ((#getEnemies("player",7) >= 2 and buff.bladeFlurry.exists()) or (#getEnemies("player",7) < 2 and not buff.bladeFlurry.exists())) and delayBladeFlurry then
                    delayBladeFlurry = 0
                end
                if hasEquiped(141321) and cd.bladeFlurry.remain() == 0 and #getEnemies("player",7) >= 2 then
                    CastSpellByName(GetSpellInfo(spell.bladeFlurry),"player");
                end
            end
            if mode.bladeflurry == 1 then 
                -- blade_flurry,if=spell_targets.blade_flurry>=2&!buff.blade_flurry.up
                if #getEnemies("player",7) >= 2 and not buff.bladeFlurry.exists() then
                    CastSpellByName(GetSpellInfo(spell.bladeFlurry),"player");
                end
            end
        end
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
        -- Trinkets
            if isChecked("Trinkets") then
                if hasBloodLust() or ttd("target") <= 20 or comboDeficit <= 2 then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
            end
    -- Pots
            if isChecked("Agi-Pot") then
                if ttd("target") <= 25 or buff.adrenalineRush.exists() or hasBloodLust() then
                    if canUse(127844) and inRaid then
                        useItem(127844)
                    end
                    else
                    if canUse(142117) and inRaid then
                        useItem(142117)
                    end
                end
            end
    -- Non-NE Racial
            --blood_fury
            --berserking
            --arcane_torrent,if=energy.deficit>40
            if isChecked("Racial") and (race == "Orc" or race == "Troll" or (race == "BloodElf" and powerDeficit > 40)) then
                if castSpell("player",racial,false,false,false) then return end
            end
    -- Cannonball Barrage
            -- cannonball_barrage,if=spell_targets.cannonball_barrage>=1
            if #enemies.yards8 >= getOptionValue("Cannonball Barrage") and isChecked("Cannonball Barrage") then
                if cast.cannonballBarrage("best",false,#enemies.yards8,8) then return end
            end
    -- Adrenaline Rush
            -- adrenaline_rush,if=!buff.adrenaline_rush.up&energy.deficit>0
            if not buff.adrenalineRush.exists() and powerDeficit > 0 and ttm >= cd.global.remain() then
                if cast.adrenalineRush() then return end
            end
    -- Sprint
            -- sprint,if=equipped.thraxis_tricksy_treads&!variable.ss_useable
            if isChecked("Legendary Boots Logic") and hasEquiped(137031) and not ssUsable() then
                if cast.sprint() then return end
                -- darkflight,if=equipped.thraxis_tricksy_treads&!variable.ss_useable&buff.sprint.down
                if race == "Worgen" and not buff.sprint.exists() then
                    if castSpell("player",racial,false,false,false) then return end
                end
            end
    -- Curse of the Dreadblades
            -- curse_of_the_dreadblades,if=combo_points.deficit>=4&(!talent.ghostly_strike.enabled|debuff.ghostly_strike.up)
            if isChecked("Artifact") and (cd.saberSlash.remain() == 0 or cd.pistolShot.remain() == 0) then
                if comboDeficit >= 4 and (power >= 48 or buff.opportunity.exists() or buff.swordplay.exists()) and (not talent.ghostlyStrike or debuff.ghostlyStrike.exists(units.dyn5)) then
                    if cast.curseOfTheDreadblades() then return end
                end
            end
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
        -- Stealth
            if not inCombat and not stealth then
                if isChecked("Stealth") and (not IsResting() or isDummy("target")) then
                    if getOptionValue("Stealth") == 1 then
                        if cast.stealth("player") then return end
                    end
                    if #enemies.yards20 > 0 and getOptionValue("Stealth") == 2 and not IsResting() and GetTime()-leftCombat > lootDelay then
                        for i = 1, #enemies.yards20 do
                            local thisUnit = enemies.yards20[i]
                            if UnitIsEnemy(thisUnit,"player") or isDummy("target") then
                                if cast.stealth("player") then return end
                            end
                        end
                    end
                end
            end
        -- Marked for Death
            -- marked_for_death
            if not inCombat and isChecked("Marked For Death - Precombat") and getDistance("target") < 15 and isValidUnit("target") then
                if cast.markedForDeath("target") then return end
            end
        -- Roll The Bones
            -- roll_the_bones,if=!talent.slice_and_dice.enabled
            if not inCombat and isChecked("RTB Prepull") and not talent.sliceAndDice and buff.rollTheBones.count == 0 and isValidUnit("target") and getDistance("target") <= 10 then
                if cast.rollTheBones() then return end
            end
        end -- End Action List - PreCombat
    -- Action List - Finishers
        local function actionList_Finishers()
        -- Between the Eyes
            -- between_the_eyes,if=(mantle_duration>=gcd.remains+0.2&!equipped.thraxis_tricksy_treads)|(equipped.greenskins_waterlogged_wristcuffs&!buff.greenskins_waterlogged_wristcuffs.up)
            if (mantleDuration() >= cd.global.remain() + 0.2 and not hasEquiped(137031)) or (hasEquiped(137099) and not buff.greenskinsWaterloggedWristcuffs.exists()) then
                if cast.betweenTheEyes() then return end
            end
        -- Run Through
            -- run_through,if=!talent.death_from_above.enabled|energy.time_to_max<cooldown.death_from_above.remain()s+3.5
            if not talent.deathFromAbove or ttm < cd.deathFromAbove.remain() + 3.5 then
                if cast.runThrough() then return end
            end
        end -- End Action List - Finishers
    -- Action List - Build
        local function actionList_Build()
        -- Ambush
            if stealthingAll and ambushCondition() then
                if cast.ambush() then return end
            end
        -- Ghostly Strike
            -- ghostly_strike,if=combo_points.deficit>=1+buff.broadsides.up&!buff.curse_of_the_dreadblades.up&(debuff.ghostly_strike.remains<debuff.ghostly_strike.duration*0.3|(cooldown.curse_of_the_dreadblades.remains<3&debuff.ghostly_strike.remains<14))&(combo_points>=3|(variable.rtb_reroll&time>=10))
            if comboDeficit >= 1 + (buff.broadsides.exists() and 1 or 0) and not debuff.curseOfTheDreadblades.exists("player") and (debuff.ghostlyStrike.refresh("target") or (useCDs() and isChecked("Artifact") and cd.curseOfTheDreadblades.remain() < 3 and debuff.ghostlyStrike.remain("target") < 14)) and 
              (combo >= 3 or (rtbReroll() and cTime >= 10)) then
                if cast.ghostlyStrike("target") then return end
            end
        -- Pistol Shot
            -- pistol_shot,if=combo_points.deficit>=1+buff.broadsides.up&buff.opportunity.up&(energy.time_to_max>2-talent.quick_draw.enabled|(buff.blunderbuss.up&buff.greenskins_waterlogged_wristcuffs.up))
            if comboDeficit >= 1 + (buff.broadsides.exists() and 1 or 0) and buff.opportunity.exists() and ((ttm > 2 - (talent.quickDraw and 1 or 0)) or (buff.adrenalineRush.exists() and ttm > 1.5) or (IsUsableSpell(GetSpellInfo(202895)) and buff.greenskinsWaterloggedWristcuffs.exists())) then
                if cast.pistolShot("target") then return end
            end
        -- Saber Slash
            -- saber_slash
            if ssUsable() then
                if cast.saberSlash() then return end
            end
        end -- End Action List - Build
    -- Action List - Opener
        local function actionList_Opener()
            if isValidUnit("target") then          
        -- Opener
                if not inCombat then
                    if combo >= 5 then
                        if cast.runThrough("target") then return end
                    elseif stealthingAll then
                        if cast.ambush("target") then return end
                    else
                        if cast.saberSlash("target") then return end
                    end
                end
        -- StartAttack
                if getDistance("target") <= 5 and not stealthingAll and not StartAttack() then
                    StartAttack()
                end
            end
        end
    -- Action List - Stealth
        local function actionList_Stealth()            
        -- Ambush
            --ambush,if=variable.ambush_condition
            if stealthingAll then
                if not ssUsable() and not ambushCondition() then
                    if actionList_Finishers() then return end
                elseif ambushCondition() then
                    if cast.ambush() then return end
                elseif ssUsable() and not ambushCondition() then
                    if cast.saberSlash() then return end
                end
            else
        -- Vanish
                if cd.global.remain() <= getLatency() and not solo then
                    -- vanish,if=variable.ambush_condition|(equipped.mantle_of_the_master_assassin&mantle_duration=0&!variable.rtb_reroll&!variable.ss_useable)
                    if cd.vanish.remain() == 0 and useCDs() and isChecked("Vanish") and GetTime() >= vanishTime + cd.global.remain() and (ambushCondition() or (hasEquiped(144236) and mantleDuration() == 0 and not rtbReroll() and not ssUsable())) and isValidUnit("target") and getDistance("target") <= 5 then
                        if power < 35 then
                            return true
                        else
                            if cast.vanish() then 
                            vanishTime = GetTime()
                            if ambushCondition() then
                                cast.ambush()
                            end
                            return end
                        end
        -- Shadowmeld
                    -- shadowmeld,if=variable.ambush_condition
                    elseif cd.shadowmeld.remain() == 0 and useCDs() and isChecked("Racial") and GetTime() >= vanishTime + cd.global.remain() and race == "NightElf" and ambushCondition() and isValidUnit("target") and getDistance("target") <= 5 and not isMoving("player") then
                        if power < 35 then
                            return true
                        else
                            if cast.shadowmeld() then vanishTime = GetTime(); cast.ambush(); return end
                        end
                    end
                end
            end
        end
---------------------
--- Begin Profile ---
---------------------
    --Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop == true) or pause() or (IsMounted() or IsFlying()) or mode.rotation == 2 then
            return true
        else
-----------------------
--- Extras Rotation ---
-----------------------
            --if actionList_Extras() then return end
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
--------------------------------
--- In Combat - Blade Flurry ---
--------------------------------
            if actionList_BladeFlurry() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and isValidUnit(units.dyn5) then
                if not stealthingAll or level < 5 then
------------------------------
--- In Combat - Interrupts ---
------------------------------
                    if actionList_Interrupts() then return end
                end
-----------------------------
--- In Combat - Cooldowns ---
-----------------------------
                if useCDs() and getDistance("target") <= 6 and attacktar then
                    if actionList_Cooldowns() then return end
                end
---------------------------
--- In Combat - Stealth ---
---------------------------
                    -- call_action_list,name=stealth,if=stealthed.rogue|cooldown.vanish.up|cooldown.shadowmeld.up
                if (stealthingAll or cd.vanish.remain() == 0 or cd.shadowmeld.remain() == 0) then
                    if actionList_Stealth() then return end
                end
----------------------------------
--- In Combat - Begin Rotation ---
----------------------------------
                -- if not buff.stealth and not buff.vanish and not buff.shadowmeld and GetTime() > vanishTime + 2 and getDistance(units.dyn5) < 5 then
                if not stealthingAll then
                -- Marked for Death
                    if mode.mfd == 1 then                            
                        if comboDeficit >= ComboMaxSpend() - 1 then
                            if cast.markedForDeath("target") then return end
                        end
                    elseif mode.mfd == 2 then
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if comboDeficit >= 6 then comboDeficit = ComboMaxSpend() end
                            if ttd(thisUnit) > 0 and ttd(thisUnit) <= 100 then
                                if ttd(thisUnit) < comboDeficit*1.2 then
                                    if cast.markedForDeath(thisUnit) then return end
                                end
                            end
                        end
                    end
        -- Death from Above
                        -- death_from_above,if=energy.time_to_max>2&!variable.ss_useable_noreroll
                    if ttm > 2 and not ssUsableNoReroll() then
                        if cast.deathFromAbove() then return end
                    end

                    --[[if buff.loadedDice.exists() then
                        ImprovedSND = true
                    else
                        ImprovedSND = false
                    end]]

                    if talent.sliceAndDice then
    -- Slice and Dice
                        -- slice_and_dice,if=!variable.ss_useable&buff.slice_and_dice.remains<target.time_to_die&buff.slice_and_dice.remains<(1+combo_points)*1.8&!buff.slice_and_dice.improved&!buff.loaded_dice.up
                        if not ssUsable() and (buff.sliceAndDice.remain() < ttd("target") or not buff.sliceAndDice.exists()) and buff.sliceAndDice.refresh and not ImprovedSND and not buff.loadedDice.exists() then
                            if cast.sliceAndDice() then
                                if buff.loadedDice.exists() then
                                    ImprovedSND = true
                                else
                                    ImprovedSND = false
                                end
                                return
                            end
                        end
                        -- slice_and_dice,if=buff.loaded_dice.up&combo_points>=cp_max_spend&(!buff.slice_and_dice.improved|buff.slice_and_dice.remains<4)
                        if buff.loadedDice.exists() and combo >= ComboMaxSpend() and (not ImprovedSND or buff.sliceAndDice.remain() < 4) then
                            if cast.sliceAndDice() then
                                if buff.loadedDice.exists() then
                                    ImprovedSND = true
                                else
                                    ImprovedSND = false
                                end
                                return
                            end
                        end
                        -- slice_and_dice,if=buff.slice_and_dice.improved&buff.slice_and_dice.remains<=2&combo_points>=2&!buff.loaded_dice.up
                        if ImprovedSND and buff.sliceAndDice.remain() <= 2 and combo >= 2 and not buff.loadedDice.exists() then
                            if cast.sliceAndDice() then
                                if buff.loadedDice.exists() then
                                    ImprovedSND = true
                                else
                                    ImprovedSND = false
                                end
                                return
                            end
                        end
                    elseif isChecked("RTB") then
    -- Roll the Bones
                        -- roll_the_bones,if=!variable.ss_useable&(target.time_to_die>20|buff.roll_the_bones.remains<target.time_to_die)&(buff.roll_the_bones.remains<=3|variable.rtb_reroll)
                        if not ssUsable() and (ttd("target") > 20 or buff.rollTheBones.remain < ttd("target") or buff.rollTheBones.remain == 0) and (buff.rollTheBones.remain <= 3 or rtbReroll()) then
                            if cast.rollTheBones() then return end
                        end
                    end
    -- Killing Spree
                    -- killing_spree,if=energy.time_to_max>5|energy<15
                    if useCDs() and talent.killingSpree and isChecked("Killing Spree") and (ttm > 5 or power < 15) then
                        if isChecked("Cloak Killing Spree") and cd.killingSpree.remain() == 0 then
                            if cast.cloakOfShadows() then cast.killingSpree(); return end
                        end
                        if cast.killingSpree() then return end
                    end
    -- Build
                    -- call_action_list,name=build
                    if GetTime() >= vanishTime + cd.global.remain() then
                        if actionList_Build() then return end
                    end
    -- Finishers
                    -- call_action_list,name=finish,if=!variable.ss_useable
                    if not ssUsable() then
                        if actionList_Finishers() then return end
                    end
    -- Gouge
                    -- gouge,if=talent.dirty_tricks.enabled&combo_points.deficit>=1
                    if talent.dirtyTricks and comboDeficit >= 1 and not debuff.curseOfTheDreadblades.exists("player") then
                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            if not isBoss(thisUnit) and getFacing(thisUnit,"player") then
                                if cast.gouge(thisUnit) then return end
                            end
                        end
                    end
    -- Pistol Shot OOR
                    if isChecked("Pistol Shot out of range") and isValidUnit("target") and #enemies.yards8 == 0 and not stealthingAll and power >= getOptionValue("Pistol Shot out of range") and (comboDeficit >= 1 or ttm <= gcd) then
                        if cast.pistolShot("target") then return end
                    end
                end
            end -- End In Combat
        end -- End Profile
end -- runRotation
local id = 260
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
