local rotationName = "Vilt"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.shurikenStorm },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.shurikenStorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.backstab },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.crimsonVial}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.shadowBlades },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.shadowBlades },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.shadowBlades }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.evasion },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.evasion }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.kick },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick }
    };
    CreateButton("Interrupt",4,0)
-- Cleave Button
    CleaveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = br.player.spell.shurikenStorm },
        [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = br.player.spell.backstab }
    };
    CreateButton("Cleave",5,0)
-- Pick Pocket Button
    PickerModes = {
      [1] = { mode = "Auto", value = 2 , overlay = "Auto Pick Pocket Enabled", tip = "Profile will attempt to Pick Pocket prior to combat.", highlight = 1, icon = br.player.spell.pickPocket},
      [2] = { mode = "Only", value = 1 , overlay = "Only Pick Pocket Enabled", tip = "Profile will attempt to Sap and only Pick Pocket, no combat.", highlight = 0, icon = br.player.spell.pickPocket},
      [3] = { mode = "Off", value = 3, overlay = "Pick Pocket Disabled", tip = "Profile will not use Pick Pocket.", highlight = 0, icon = br.player.spell.pickPocket}
    };
    CreateButton("Picker",6,0)
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
            -- Stealth
            br.ui:createDropdown(section,  "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealthing method.")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            --Shuriken Toss OOR
            br.ui:createSpinner(section, "Shuriken Toss OOR",  85,  5,  100,  5,  "|cffFFBB00Check to use Shuriken Toss out of range and energy to use at.")
            -- SoD Prepull
            br.ui:createCheckbox(section, "Symbols of Death - Precombat")
            -- Crimson Vial
            br.ui:createSpinnerWithout(section, "SS Range",  5,  5,  8,  1,  "|cffFFBB00Shadow Strike range, 5 = Melee")
            br.ui:createCheckbox(section, "Open from Stealth")
            -- SSW Offset
            br.ui:createSpinnerWithout(section, "SSW Offset", 0, 0, 10, 1, "|cffFFBB00For Advanced Users, check SimC Wiki. Leave this at 0 if you don't know what you're doing.")
            -- NB TTD
            br.ui:createSpinner(section, "Nightblade Multidot", 8, 0, 16, 1, "|cffFFBB00Multidot Nightblade | Minimum TTD to use.")
            -- DfA Targets
            br.ui:createSpinner(section, "DfA Targets", 5, 1, 10, 1, "|cffFFBB00Amount of Targets for DfA")
            --[[ Enable Special dungeon/boss logic
            br.ui:createCheckbox(section, "Use Boss/Dungeon Logic")]]
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Agi Pot
            br.ui:createCheckbox(section, "Agi-Pot")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Marked For Death
            br.ui:createDropdown(section, "Marked For Death", {"|cff00FF00Target", "|cffFFDD00Lowest"}, 1, "|cffFFBB00Health Percentage to use at.")
            -- Shadow Blades
            br.ui:createCheckbox(section, "Shadow Blades")
            -- Shadow Dance
            br.ui:createCheckbox(section, "Shadow Dance")
            -- Vanish
            br.ui:createCheckbox(section, "Vanish")
            -- Sprint for Vanish
            br.ui:createCheckbox(section, "Sprint for Vanish", "This doesn't work properly (yet). Manual attention required if using this.")
            -- Cloak Sprint Vanish
            br.ui:createCheckbox(section, "Cloak Sprint Vanish", "Will use Cloak before using Sprint for Vanish (To hopefully avoid environmental damage cancelling it.)")
            -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
            --[[ Draught of Souls
            br.ui:createDropdown(section, "Draught of Souls", {"|cff00FF00With Sprint","|cffFFFF00Always"}, 1)]]
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healing Potion/Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Crimson Vial
            br.ui:createSpinner(section, "Crimson Vial",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Evasion
            br.ui:createSpinner(section, "Evasion",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Feint
            br.ui:createSpinner(section, "Feint", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Kick
            br.ui:createCheckbox(section, "Kick")
            -- Kidney Shot
            br.ui:createCheckbox(section, "Kidney Shot")
            -- Blind
            br.ui:createCheckbox(section, "Blind")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
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
            br.ui:createDropdown(section,  "Cleave Mode", br.dropOptions.Toggle,  6)
            -- Pick Pocket Toggle
            br.ui:createDropdown(section,  "Pick Pocket Mode", br.dropOptions.Toggle,  6)
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
    UpdateToggle("Cleave",0.25)
    br.player.mode.cleave = br.data.settings[br.selectedSpec].toggles["Cleave"]
    UpdateToggle("Picker",0.25)
    br.player.mode.pickPocket = br.data.settings[br.selectedSpec].toggles["Picker"]

--------------
--- Locals ---
--------------
    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end
    local addsExist                                     = false
    local addsIn                                        = 999
    local artifact                                      = br.player.artifact
    local attacktar                                     = UnitCanAttack("target","player")
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local cd                                            = br.player.cd
    local charges                                       = br.player.charges
    local combatTime                                    = getCombatTime()
    local combo, comboDeficit, comboMax                 = br.player.power.amount.comboPoints, br.player.power.comboPoints.deficit, br.player.power.comboPoints.max
    local deadtar                                       = UnitIsDeadOrGhost("target")
    local debuff                                        = br.player.debuff
    local enemies                                       = enemies or {}
    local flaskBuff, canFlask                           = getBuffRemain("player",br.player.flask.wod.buff.agilityBig), canUse(br.player.flask.wod.agilityBig)
    local gcd                                           = br.player.gcd
    local glyph                                         = br.player.glyph
    local hastar                                        = ObjectExists("target")
    local healPot                                       = getHealthPot()
    local inCombat                                      = br.player.inCombat
    local lastSpell                                     = lastSpellCast
    local level                                         = br.player.level
    local mode                                          = br.player.mode
    local multidot                                      = (br.player.mode.cleave == 1 or br.player.mode.rotation ~= 3)
    local perk                                          = br.player.perk
    local php                                           = br.player.health
    local power, powerDeficit, powerRegen, powerTTM     = br.player.power.amount.energy, br.player.power.energy.deficit, br.player.power.regen, br.player.power.ttm
    local pullTimer                                     = br.DBM:getPulltimer()
    local race                                          = br.player.race
    local racial                                        = br.player.getRacial()
    local solo                                          = #br.friend < 2
    local spell                                         = br.player.spell
    local stealth                                       = br.player.buff.stealth.exists()
    local stealthingAll                                 = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowmeld.exists() or br.player.buff.shadowDance.exists() or br.player.buff.subterfuge.exists()
    local stealthingRogue                               = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowDance.exists() or br.player.buff.subterfuge.exists()
    local talent                                        = br.player.talent
    local time                                          = getCombatTime()
    local ttd                                           = getTTD
    local ttm                                           = br.player.power.ttm
    local units                                         = units or {}
    local lootDelay                                     = getOptionValue("LootDelay")

    units.dyn5 = br.player.units(5)
    units.dyn8 = br.player.units(8)
    units.dyn30 = br.player.units(30)
    enemies.yards5 = br.player.enemies(5)
    enemies.yards8 = br.player.enemies(8)
    enemies.yards10 = br.player.enemies(10)
    enemies.yards20 = br.player.enemies(20)
    enemies.yards30 = br.player.enemies(30)

    if talent.anticipation then antital = 1 else antital = 0 end
    if talent.deeperStrategem then dStrat = 1 else dStrat = 0 end
    if talent.masterOfShadows then mosTalent = 1 else mosTalent = 0 end
    if talent.premeditation then premed = 1 else premed = 0 end
    if talent.vigor then vigorous = 1 else vigorous = 0 end
    if combatTime < 10 then justStarted = 1 else justStarted = 0 end
    if combatTime >= 10 then beenAWhile = 1 else beenAWhile = 0 end
    if vanishTime == nil then vanishTime = GetTime() end
    if ShDCdTime == nil then ShDCdTime = GetTime() end
    if ShdMTime == nil then ShdMTime = GetTime() end
    if hasEquiped(137032) then shadowWalker = 1 else shadowWalker = 0 end
    if buff.shadowBlades.exists() then sBladesUp = 1 else sBladesUp = 0 end
    if hasEquiped(144236) then mantle = 1 else mantle = 0 end

    --Sprint for Vanish stuff
    if sprintTimer == nil then sprintTimer = GetTime() end
    if sprintphp == nil then sprintphp = 1 end
    if resume == nil then resume = 2 end
    if buff.sprint.exists() and resume == 0 and getHP("player") > sprintphp then sprintphp = getHP("player") end
    --if GetTime() > (sprintTimer + 3) and mode.rotation == 4 then toggle("Rotation",1) end
    if buff.sprint.exists() and resume == 0 and getHP("player") < sprintphp then resume = 1 end
    if GetTime() > (sprintTimer + 3) and mode.rotation == 4 then resume = 1 end
    if resume == 1 then toggle("Rotation",1); resume = 0 end


    -- variable,name=ssw_refund,value=equipped.shadow_satyrs_walk*(6+ssw_refund_offset)
    --local sswVar = shadowWalker * (10 - math.floor(getDistance(units.dyn5)*0.5))
    local sswRefund = shadowWalker * (6 + getOptionValue("SSW Offset"))
    -- variable,name=stealth_threshold,value=(15+talent.vigor.enabled*35+talent.master_of_shadows.enabled*25+variable.ssw_refund)
    local edThreshVar = (10 + (vigorous * 35) + (mosTalent * 25) + sswRefund)
    local ShDVar = 2.45

    -- Custom Functions
    local function usePickPocket()
        if mode.pickPocket == 1 or mode.pickPocket == 2 then
            return true
        else
            return false
        end
    end
    local function isPicked(thisUnit)   --  Pick Pocket Testing
        if thisUnit == nil then thisUnit = "target" end
        if GetObjectExists(thisUnit) then
            if myTarget ~= UnitGUID(thisUnit) then
                canPickpocket = true
                myTarget = UnitGUID(thisUnit)
            elseif not (UnitCreatureType(units.dyn30) == "Humanoid" or UnitCreatureType(units.dyn30) == "Demon" or UnitCreatureType(units.dyn30) == "Aberration") then
                canPickpocket = false
            end
        end
        if (canPickpocket == false or mode.pickPocket == 3 or GetNumLootItems()>0) and not isDummy() then
            return true
        else
            return false
        end
    end

--------------------
--- Action Lists ---
--------------------
-- Mythic Dungeon Logic
    --local function actionList_MythicDungeon()
    --end
--Emerald Nightmare Logic
    --local function actionList_EmeraldNightmare()
    --end
--Trial of Valor Logic
    --local function actionList_TrialOfValor()
    --end
--Nighthold Logic
    --local function actionlist_NightHold()
    --end
-- Action List - Extras
    local function actionList_Extras()
    -- Pick Pocket
        if usePickPocket() then
            if UnitCanAttack(units.dyn5,"player") and (UnitExists(units.dyn5) or mode.pickPocket == 2) and mode.pickPocket ~= 3 then
                if not isPicked(units.dyn5) and not isDummy() then
                    if debuff.sap.remain(units.dyn5) < 1 and mode.pickPocket ~= 1 then
                        if cast.sap(units.dyn5) then return end
                    end
                    if cast.pickPocket() then return end
                end
            end
        end

    end -- End Action List - Extras
-- Action List - Defensives
    local function actionList_Defensive()
        if useDefensive() and not stealth then
        -- Pot/Stoned
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
        -- Evasion
            if isChecked("Evasion") and php < getOptionValue("Evasion") and inCombat then
                if cast.evasion() then return end
            end
        -- Feint
            if isChecked("Feint") and php <= getOptionValue("Feint") and inCombat then
                if cast.feint() then return end
            end
        end
    end -- End Action List - Defensive
-- Action List - Interrupts
    local function actionList_Interrupts()
        if useInterrupts() and not stealth then
            for i=1, #enemies.yards20 do
                local thisUnit = enemies.yards20[i]
                local distance = getDistance(thisUnit)
                if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Kick
                    -- kick
                    if isChecked("Kick") and distance < 5 then
                        if cast.kick(thisUnit) then return end
                    end
        -- Kidney Shot
                    if cd.kick ~= 0 and cd.blind == 0 then
                        if isChecked("Kidney Shot") then
                            if cast.kidneyShot(thisUnit) then return end
                        end
                    end
                    if isChecked("Blind") and (cd.kick ~= 0 or distance >= 5) then
        -- Blind
                        if cast.blind(thisUnit) then return end
                    end
                end
            end
        end -- End Interrupt and No Stealth Check
    end -- End Action List - Interrupts
-- Action List - Cooldowns
    local function actionList_Cooldowns()
        -- Print("Cooldowns")
        if useCDs() and getDistance(units.dyn5) <= 6 and attacktar and inCombat then
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
    -- Draught of Souls
            --use_item,slot=trinket1,if=cooldown.shadow_dance.charges_fractional<2.45&buff.shadow_dance.down
    --        if isChecked("Draught of Souls") then
    --            if hasEquiped(140808) and canUse(140808) then
     --               if getOptionValue("Draught of Souls") == 2 then
    --                    if charges.frac.shadowDance <= 2.45 and not buff.shadowDance.exists() then
     --                       useItem(140808)
    --                    end
     --               end
     --               if getOptionValue("Draught of Souls") == 1 then
    --                    if cd.sprint == 0 then
     --                       StopAttack()
     --                       if cast.sprint() then
    --                        useItem(140808)
     --                   end
     --                   end
     --               end
      --          end
     --       end
    -- Potion
            -- potion,name=old_war,if=buff.bloodlust.react|target.time_to_die<=25|buff.shadow_blades.up
            if isChecked("Agi-Pot") and isBoss("target") and (hasItem((127844)) or hasItem(142117)) then
                if ttd("target") <= 25 or buff.shadowBlades.exists() or hasBloodLust() then
                    if canUse(127844) then
                        useItem(127844)
                    end
                    if canUse(142117) then
                        useItem(142117)
                    end
                end
            end
    -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
            -- blood_fury,if=stealthed.rogue
            -- berserking,if=stealthed.rogue
            -- arcane_torrent,if=stealthed.rogue&energy.deficit>70
            if isChecked("Racial") and stealthingRogue and (race == "Orc" or race == "Troll" or (race == "BloodElf" and powerDeficit > 70)) then
                if castSpell("player",racial,false,false,false) then return end
            end
    -- Shadow Blades
            --shadow_blades
            if cd.backstab <= getLatency() and isChecked("Shadow Blades") and powerDeficit <= edThreshVar then
                if cast.shadowBlades() then return end
            end
    -- Goremaws Bite
            -- goremaws_bite,if=!stealthed.all&cooldown.shadow_dance.charges_fractional<=variable.shd_fractionnal&((combo_points.deficit>=4-(time<10)*2&energy.deficit>50+talent.vigor.enabled*25-(time>=10)*15)|(combo_points.deficit>=1&target.time_to_die<8))
            if not stealthingAll and charges.frac.shadowDance <= ShDVar and ((comboDeficit >= (4 - (justStarted * 2)) and powerDeficit >= (50 + (vigorous * 25) - (beenAWhile * 15))) or (comboDeficit >=1 and ttd("target") < 8)) and getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
                if cast.goremawsBite("target") then return end
            end
        end -- End Cooldown Usage Check
    end -- End Action List - Cooldowns
-- Action List - Stealth Cooldowns
    local function actionList_StealthCooldowns()
    -- Print("Stealth Cooldowns")
-- Shadow Dance
        -- shadow_dance,if=charges_fractional>=2.45
        if charges.frac.shadowDance >= ShDVar then
            if cast.shadowDance() then ShDCdTime = GetTime(); return end
        end
-- Vanish
        -- vanish,if=mantle_duration<=3
        if useCDs() and isChecked("Vanish") and not solo and cd.backstab == 0 and (buff.masterAssassinsInitiative.remain() <= 3 or not buff.masterAssassinsInitiative.exists()) and charges.frac.shadowDance <= ShDVar then
            if cast.vanish() then vanishTime = GetTime(); return end
        end
-- Shadow Dance
        -- shadow_dance,if=charges>=2&combo_points<=1
        if useCDs() and isChecked("Shadow Dance") and charges.shadowDance >= 2 and combo <= 1 then
            if cast.shadowDance() then ShDCdTime = GetTime(); return end
        end
-- Shadowmeld
        -- pool_resource,for_next=1,extra_amount=40
        -- shadowmeld,if=energy>=40&energy.deficit>=10+variable.ssw_refund
        if useCDs() and isChecked("Racial") and not solo then
            if power < 40 then
                return true
            elseif power >= 40 and powerDeficit >= 10 + sswRefund and cd.backstab == 0 then
                if cast.shadowmeld() then ShdMTime = GetTime(); return end
            end
        end
-- Shadow Dance
        -- shadow_dance,if=combo_points<=1
        if useCDs() and isChecked("Shadow Dance") and combo <= 1 then
            if cast.shadowDance() then ShDCdTime = GetTime(); return end
        end
    end
-- Action List - Stealth Starter
    local function actionList_ALS()
        if getDistance(units.dyn5) <= 6 then
            --call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold&(!equipped.shadow_satyrs_walk|cooldown.shadow_dance.charges_fractional>=2.45|energy.deficit>=10)
            --call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold&(!equipped.shadow_satyrs_walk|cooldown.shadow_dance.charges_fractional>=variable.shd_fractionnal|energy.deficit>=10)
            if powerDeficit <= edThreshVar and (not hasEquiped(137032) or charges.frac.shadowDance >= ShDVar or powerDeficit >= 10) then
                if actionList_StealthCooldowns() then return end
            end
            --call_action_list,name=stealth_cds,if=spell_targets.shuriken_storm>=5
            if #getEnemies("player",9.6) >= 5 then
                if actionList_StealthCooldowns() then return end
            end
            --call_action_list,name=stealth_cds,if=(cooldown.shadowmeld.up&!cooldown.vanish.up&cooldown.shadow_dance.charges<=1)
            if ((cd.shadowmeld == 0 or not isChecked("Racial") or solo) and (cd.vanish ~= 0 or not isChecked("Vanish") or solo) and charges.shadowDance <= 1) then
                if actionList_StealthCooldowns() then return end
            end
            --stealth_cds,if=target.time_to_die<12*cooldown.shadow_dance.charges_fractional*(1+equipped.shadow_satyrs_walk*0.5)
            if ttd("target") < (12 * charges.frac.shadowDance * (1 + shadowWalker * 0.5)) then
                if actionList_StealthCooldowns() then return end
            end
        end
    end
-- Action List - Finishers
    local function actionList_Finishers()
    -- Enveloping Shadows
        -- enveloping_shadows,if=buff.enveloping_shadows.remain()s<target.time_to_die&buff.enveloping_shadows.remain()s<=combo_points*1.8
        if buff.envelopingShadows.remain() < ttd("target") and buff.envelopingShadows.remain() <= combo * 1.8 then
            if cast.envelopingShadows() then return end
        end
    -- Death from Above
        -- death_from_above,if=spell_targets.death_from_above>=5
        if #enemies.yards8 >= getOptionValue("DfA Targets") then
            if cast.deathFromAbove() then return end
        end
    -- Night Blade
        -- nightblade,cycle_targets=1,if=target.time_to_die-remains>10&((refreshable&(!finality|buff.finality_nightblade.up))|remains<tick_time*2)
        if getTTD("target") >= 10 and ((debuff.nightblade.refresh() and (not artifact.finality or buff.finalityNightblade.exists())) or debuff.nightblade.remain() < 3) then
            if cast.nightblade("target") then return end
        end
        if isChecked("Nightblade Multidot") then
            for i=1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if getDistance(thisUnit) <= 5 then
                    if ttd(thisUnit) >= getOptionValue("Nightblade Multidot") and ((debuff.nightblade.refresh(thisUnit) and (not artifact.finality or buff.finalityNightblade.exists())) or debuff.nightblade.remain(thisUnit) < 3) then
                        if cast.nightblade(thisUnit) then return end
                    end
                end
            end
        end
    -- Death from Above
        -- death_from_above
        if #enemies.yards8 >= getOptionValue("DfA Targets") then
            if cast.deathFromAbove() then return end
        end
    -- Eviscerate
        -- eviscerate
        if cast.eviscerate() then return end
    end -- End Action List - Finishers
-- Action List - Stealthed
    local function actionList_Stealthed()
    -- Symbols of Death
        -- symbols_of_death,if=(buff.symbols_of_death.remain()s<target.time_to_die-4&buff.symbols_of_death.remain()s<=buff.symbols_of_death.duration*0.3)
        if (buff.symbolsOfDeath.remain() < (ttd("target") - 4) and buff.symbolsOfDeath.refresh()) then
            if cast.symbolsOfDeath() then return end
        end
    -- Shuriken Storm
    -- i quit this shit game a week ago lul
        --call_action_list,name=finish,if=combo_points>=5&(spell_targets.shuriken_storm>=2+talent.premeditation.enabled+equipped.shadow_satyrs_walk|(mantle_duration>0&mantle_duration<=1.2))
        if combo >= 5 and (#getEnemies("player",9.6) >= (2 + premed + shadowWalker) or (buff.masterAssassinsInitiative.remain() <= 1.3 and (buff.masterAssassinsInitiative.remain() - cd.global) >= 0.3)) then
            if actionList_Finishers() then return end
        end
        --shuriken_storm,if=buff.shadowmeld.down&((combo_points.deficit>=3&spell_targets.shuriken_storm>=2+talent.premeditation.enabled+equipped.shadow_satyrs_walk)|(combo_points.deficit>=1+buff.shadow_blades.up&buff.the_dreadlords_deceit.stack>=29))
        --if comboDeficit >= (1 + sBladesUp) and not buff.shadowmeld.exists() and ((comboDeficit >= 3 and #getEnemies("player",9.6) >= (2 + premed + shadowWalker)) or buff.theDreadlordsDeceit.stack >= 29) then
        if not buff.shadowmeld.exists() and ((comboDeficit >= 3 and #getEnemies("player",9.6) >= (2 + premed + shadowWalker)) or (comboDeficit >= (1 + sBladesUp) and buff.theDreadlordsDeceit.stack() >= 29)) then
            if cast.shurikenStorm() then return end
        end
    -- Shadowstrike
        --shadowstrike,if=combo_points.deficit>=2+talent.premeditation.enabled+buff.shadow_blades.up-equipped.mantle_of_the_master_assassin
        if getDistance(units.dyn8) <= getOptionValue ("SS Range") then
            if comboDeficit >= (2 + premed + sBladesUp - mantle) then
                if cast.shadowstrike() then return end
            end
        end
    -- Finisher
        -- call_action_list,name=finish,if=combo_points>=5
        if combo >= 5 then
            if actionList_Finishers() then return end
        end
    -- Shuriken Storm
        -- shuriken_storm,if=buff.shadowmeld.down&((combo_points.deficit>=3&spell_targets.shuriken_storm>=2+talent.premeditation.enabled+equipped.shadow_satyrs_walk)|buff.the_dreadlords_deceit.stack>=29)
    --    if not buff.shadowmeld.exists() and ((comboDeficit >= 3 and #getEnemies("player",9.6) >= (2 + premed + shadowWalker)) or buff.theDreadlordsDeceit.stack >= 29) then
    --        if cast.shurikenStorm() then return end
    --    end
    -- Shadowstrike
        -- shadowstrike
        --Print("Shadowstrike")
        if getDistance(units.dyn8) <= getOptionValue ("SS Range") then
             if cast.shadowstrike() then return end
        end
    end
-- Action List - Builders
    local function actionList_Build()
    -- Shuriken Storm
        -- shuriken_storm,if=spell_targets.shuriken_storm>=2
        if #getEnemies("player",9.6) >= 2 then
            if cast.shurikenStorm() then return end
        end
        -- gloomblade
        if talent.gloomblade then
            if cast.gloomblade() then return end
        end
        -- backstab
        if cast.backstab() then return end
    end -- End Action List - Builders
-- Action List - PreCombat
    local function actionList_PreCombat()
        -- stealth
        if not inCombat then
            if isChecked("Stealth") and (not IsResting() or isDummy("target")) then
                if getOptionValue("Stealth") == 1 then
                    if cast.stealth() then return end
                end
                --if getOptionValue("Stealth") == 3 then
                --    for i=1, #enemies.yards20 do
                --        local thisUnit = enemies.yards20
                --        if getDistance(thisUnit) <= 20 then
                --            if ObjectExists(thisUnit) and UnitCanAttack(thisUnit,"player") and GetTime()-leftCombat > lootDelay then
                --                if cast.stealth() then return end
                --            end
                --        end
                --    end
                --end
                if not stealth and #enemies.yards20 > 0 and getOptionValue("Stealth") == 3 and not IsResting() and GetTime()-leftCombat > lootDelay then
                    for i = 1, #enemies.yards20 do
                        local thisUnit = enemies.yards20[i]
                        if UnitIsEnemy(thisUnit,"player") or isDummy("target") then
                            if cast.stealth("player") then return end
                        end
                    end
                end
            end
        end
        -- symbols_of_death
        if isChecked("Symbols of Death - Precombat") and not inCombat and buff.symbolsOfDeath.refresh() and stealth then
            if cast.symbolsOfDeath("player") then return end
        end
    end -- End Action List - PreCombat
-- Action List - Opener
    local function actionList_Opener()
        if isValidUnit("target") then
    -- Shadowstrike
            if isChecked("Open from Stealth") and stealthingAll and getDistance("target") <= getOptionValue ("SS Range") and mode.pickPocket ~= 2 and not inCombat then
                if cast.shadowstrike("target") then return end
            end
    -- Start Attack
            if getDistance("target") < 5 and not stealthingAll and mode.pickPocket ~= 2 then
                StartAttack()
            end
        end
    end -- End Action List - Opener
---------------------
--- Begin Profile ---
---------------------
--Profile Stop | Pause
    if not inCombat and not hastar and profileStop==true then
        profileStop = false
    elseif (inCombat and profileStop == true) or pause() or (IsMounted() or IsFlying()) or mode.rotation==4 then
        return true
    else
------------------------
-- Special Boss Logic --
------------------------
        --[[if isChecked("Use Boss/Dungeon Logic") then
            if actionList_MythicDungeon() then return end
            if actionList_EmeraldNightmare() then return end
            if actionList_TrialOfValor() then return end
            if actionlist_NightHold() then return end
        end]]
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
----------------------------
--- Out of Combat Opener ---
----------------------------
        if actionList_Opener() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
        if inCombat and mode.pickPocket ~= 2 and isValidUnit(units.dyn5) --[[and getDistance(units.dyn5) <= 7]] then
------------------------------
--- In Combat - Interrupts ---
------------------------------
            if actionList_Interrupts() then return end
----------------------------------
--- In Combat - Begin Rotation ---
----------------------------------
    -- Cooldowns
            -- call_action_list,name=cds
            if actionList_Cooldowns() then return end
    -- Marked for Death
            --marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|(raid_event.adds.in>40&combo_points.deficit>=cp_max_spend)
            if isChecked("Marked For Death") then
                if getOptionValue("Marked For Death") == 1 then
                    if comboDeficit >= 4 + dStrat + antital then
                        if cast.markedForDeath() then return end
                    end
                end
                if isChecked("Marked For Death") then
                    if getOptionValue("Marked For Death") == 2 then
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if comboDeficit >= 6 then comboDeficit = (5 + dStrat) end
                            if ttd(thisUnit) > 0 and ttd(thisUnit) <= 100 then
                                if ttd(thisUnit) < comboDeficit*1.2 then
                                    if cast.markedForDeath(thisUnit) then return end
                                end
                            end
                        end
                    end
                end
            end
    -- Stealthed
            -- run_action_list,name=stealthed,if=stealthed.all
            if stealthingAll then
                if actionList_Stealthed() then return end
            else
    -- Finishers
                -- call_action_list,name=finish,if=combo_points>=5|(combo_points>=4&spell_targets.shuriken_storm>=3&spell_targets.shuriken_storm<=4)
                if combo >= 5 or (combo >= 4 and #enemies.yards10 >= 3 and #enemies.yards10 <= 4) then
                    if actionList_Finishers() then return end
                end
    -- Offensive Sprint for Vanish
                -- sprint_offensive,if=energy.time_to_max>=1.5&cooldown.shadow_dance.charges_fractional<variable.shd_fractionnal-1&!cooldown.vanish.up&target.time_to_die>=8
                -- TODO
                if useCDs() and ttm >= 1.5 and (charges.frac.shadowDance < ShDVar - 1) and cd.vanish ~= 0 and not solo and isChecked("Sprint for Vanish") and ttd("target") >= 8 and cd.sprint == 0  and artifact.flickeringShadows then
                    if isChecked("Cloak Sprint Vanish") and cd.cloakOfShadows == 0 then
                        if cast.cloakOfShadows() then return end
                    end
                    StopAttack()
                    if cast.sprint() then
                        sprintTimer = GetTime()
                        sprintphp = getHP("player")
                        resume = 0
                        toggle("Rotation",4)
                    end
                end
    -- Stealth Action List Starter
                -- call_action_list,name=stealth_als,if=combo_points.deficit>=2+talent.premeditation.enabled
                if comboDeficit >= (2 + premed) then
                    if actionList_ALS() then return end
                end
    -- Build
                -- call_action_list,name=build,if=energy.deficit<=variable.stealth_threshold
                if GetTime() > vanishTime + 1 and GetTime() > ShDCdTime + 1 and GetTime() > ShdMTime + 1 and powerDeficit <= edThreshVar then
                    if actionList_Build() then return end
                end
    -- Shuriken Toss Out of Range
                if isChecked("Shuriken Toss OOR") and isValidUnit("target") and power >= getOptionValue("Shuriken Toss OOR") and (combo < comboMax or ttm <= 1) and #enemies.yards8 == 0 and not stealth and not buff.sprint.exists() then
                    if cast.shurikenToss("target") then return end
                end
                    end
        end -- End In Combat
    end -- End Profile
end -- runRotation
local id = 261
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
