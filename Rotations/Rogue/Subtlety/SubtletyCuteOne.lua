local rotationName = "CuteOne"

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
    PickPocketModes = {
      [1] = { mode = "Auto", value = 1 , overlay = "Auto Pick Pocket Enabled", tip = "Profile will attempt to Pick Pocket prior to combat.", highlight = 1, icon = br.player.spell.pickPocket},
      [2] = { mode = "Only", value = 2 , overlay = "Only Pick Pocket Enabled", tip = "Profile will attempt to Sap and only Pick Pocket, no combat.", highlight = 0, icon = br.player.spell.pickPocket},
      [3] = { mode = "Off", value = 3, overlay = "Pick Pocket Disabled", tip = "Profile will not use Pick Pocket.", highlight = 0, icon = br.player.spell.pickPocket}
    };
    CreateButton("PickPocket",6,0)
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
            -- Shadowstep
            br.ui:createCheckbox(section,  "Shadowstep")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Agi Pot
            br.ui:createCheckbox(section, "Agi-Pot")
            -- Legendary Ring
            --br.ui:createCheckbox(section, "Legendary Ring")
            br.ui:createCheckbox(section, "Marked For Death - Precombat")
            br.ui:createCheckbox(section, "Symbols of Death - Precombat")
            -- Shadow Strike
            br.ui:createSpinnerWithout(section, "SS Range",  5,  5,  15,  1,  "|cffFFBB00Shadow Strike range, 5 = Melee")
            --Shuriken Toss OOR
            br.ui:createSpinner(section, "Shuriken Toss OOR",  85,  5,  100,  5,  "|cffFFBB00Check to use Shuriken Toss out of range and energy to use at.")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
            -- Death From Above
            br.ui:createSpinner(section, "Death From Above", 4, 1, 5, 1, "|cffFFBB00Check to use DFA and minimal units to use on.")
            -- Marked For Death
            br.ui:createDropdown(section, "Marked For Death", {"|cff00FF00Target", "|cffFFDD00Lowest"}, 1, "|cffFFBB00Health Percentage to use at.")
            -- Shadow Blades
            br.ui:createCheckbox(section, "Shadow Blades")
            -- Shadow Dance
            br.ui:createCheckbox(section, "Shadow Dance")
            -- Vanish
            br.ui:createCheckbox(section, "Vanish")
            -- SSW Offset
            br.ui:createSpinnerWithout(section, "SSW Offset", 0, 0, 10, 1, "|cffFFBB00For Advanced Users, check SimC Wiki. Leave this at 0 if you don't know what you're doing.")
            -- NB TTD
            br.ui:createSpinner(section, "Nightblade Multidot", 8, 0, 16, 1, "|cffFFBB00Multidot Nightblade | Minimum TTD to use.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
           -- Cloak of Shadows
            br.ui:createCheckbox(section, "Cloak of Shadows")
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
            br.ui:createDropdown(section,  "PickPocket Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugSubtlety", math.random(0.10,0.2)) then
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
        UpdateToggle("PickPocket",0.25)
        br.player.mode.pickPocket = br.data.settings[br.selectedSpec].toggles["PickPocket"]

--------------
--- Locals ---
--------------
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        local addsExist                                                 = false
        local addsIn                                                    = 999
        local artifact                                                  = br.player.artifact
        local attacktar                                                 = UnitCanAttack("target","player")
        local buff                                                      = br.player.buff
        local cast                                                      = br.player.cast
        local cd                                                        = br.player.cd
        local charges                                                   = br.player.charges
        local combatTime                                                = getCombatTime()
        local combo, comboDeficit, comboMax                             = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
        local deadtar                                                   = UnitIsDeadOrGhost("target")
        local debuff                                                    = br.player.debuff
        local enemies                                                   = enemies or {}
        local flaskBuff, canFlask                                       = getBuffRemain("player",br.player.flask.wod.buff.agilityBig), canUse(br.player.flask.wod.agilityBig)
        local gcd                                                       = br.player.gcd
        local gcdMax                                                    = br.player.gcdMax
        local glyph                                                     = br.player.glyph
        local hastar                                                    = GetObjectExists("target")
        local healPot                                                   = getHealthPot()
        local inCombat                                                  = br.player.inCombat
        local lastSpell                                                 = lastSpellCast
        local level                                                     = br.player.level
        local mode                                                      = br.player.mode
        local multidot                                                  = (br.player.mode.cleave == 1 or br.player.mode.rotation ~= 3)
        local perk                                                      = br.player.perk
        local php                                                       = br.player.health
        local power, powerMax, powerDeficit, powerRegen, powerTTM       = br.player.power.energy.amount(), br.player.power.energy.max(), br.player.power.energy.deficit(), br.player.power.energy.regen(), br.player.power.energy.ttm()
        local pullTimer                                                 = br.DBM:getPulltimer()
        local race                                                      = br.player.race
        local racial                                                    = br.player.getRacial()
        local solo                                                      = #br.friend < 2
        local spell                                                     = br.player.spell
        local stealth                                                   = br.player.buff.stealth.exists()
        local stealthingAll                                             = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowmeld.exists() or br.player.buff.shadowDance.exists() or br.player.buff.subterfuge.exists()
        local stealthingRogue                                           = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowDance.exists() or br.player.buff.subterfuge.exists()
        local t18_4pc                                                   = br.player.eq.t18_4pc
        local t19_2pc                                                   = TierScan("T19") >= 2
        local t19_4pc                                                   = TierScan("T19") >= 4
        local t20_2pc                                                   = TierScan("T20") >= 2
        local t20_4pc                                                   = TierScan("T20") >= 4
        local talent                                                    = br.player.talent
        local time                                                      = getCombatTime()
        local ttd                                                       = getTTD
        local ttm                                                       = br.player.power.energy.ttm()
        local units                                                     = units or {}

        units.dyn5 = br.player.units(5)
        units.dyn30 = br.player.units(30)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards8t = br.player.enemies(8,br.player.units(8,true))
        enemies.yards10 = br.player.enemies(10)
        enemies.yards20 = br.player.enemies(20)
        enemies.yards30 = br.player.enemies(30)

        if talent.anticipation then antital = 1 else antital = 0 end
        if talent.darkShadow and t20_4pc then dark20 = 1 else dark20 = 0 end
        if not talent.darkShadow and t20_4pc then notDark20 = 1 else notDark20 = 0 end
        if talent.deeperStrategem then dStrat = 1 else dStrat = 0 end
        if talent.deeperStrategem and buff.vanish.exists() then deepVanish = 1 else deepVanish = 0 end
        if talent.deeperStrategem and not buff.shadowBlades.exists() and (buff.masterAssassinsInitiative.remain() == 0 or t20_4pc) and (not buff.theFirstOfTheDead.exists() or dshDFA) then dStratNoBlades = 1 else dStratNoBlades = 0 end
        if talent.envelopingShadows then enveloped = 1 else enveloped = 0 end
        if talent.masterOfShadows then mosTalent = 1 else mosTalent = 0 end
        if talent.premeditation then premed = 1 else premed = 0 end
        if talent.shadowFocus then shadFoc = 1 else shadFoc = 0 end
        if talent.subterfuge then subty = 1 else subty = 2 end
        if talent.subterfuge or buff.theFirstOfTheDead.exists() then subtyDead = 1 else subtyDead = 0 end
        if talent.vigor then vigorous = 1 else vigorous = 0 end
        if combatTime < 10 then justStarted = 1 else justStarted = 0 end
        if vanishTime == nil then vanishTime = GetTime() end
        if ShDCdTime == nil then ShDCdTime = GetTime() end
        if ShdMTime == nil then ShdMTime = GetTime() end
        if buff.shadowBlades.exists() then shadowedBlade = 1 else shadowedBlade = 0 end
        if buff.theFirstOfTheDead.exists() then firstDead = 1 else firstDead = 0 end
        if buff.theFirstOfTheDead.exists() and talent.anticipation then firstAnti = 1 else firstAnti = 0 end
        if hasEquiped(137032) then shadowWalker = 1 else shadowWalker = 0 end
        if hasEquiped(144236) then mantleMaster = 1 else mantleMaster = 0 end
        if mantleMaster == 1 and combatTime < 30 then mantleMasterRecent = 1 else mantleMasterRecent = 0 end
        if hasEquiped(144236) and hasEquiped(137100) then halfMantled = 1 else halfMantled = 0 end
        if hasEquiped(137049) then insignia = 1 else insignia = 0 end
        if stealthingAll then stealthedAll = 1 else stealthedAll = 0 end
        if t20_4pc then t20pc4 = 1 else t20pc4 = 0 end
        if cd.goremawsBite.remain() > 0 and not buff.feedingFrenzy.exists() then noGoreFrenzy = 1 else noGoreFrenzy = 0 end

        -- variable,name=ssw_refund,value=equipped.shadow_satyrs_walk*(6+ssw_refund_offset)
        local sswRefund = shadowWalker * (6 + getOptionValue("SSW Offset"))
        -- variable,name=stealth_threshold,value=(65+talent.vigor.enabled*35+talent.master_of_shadows.enabled*10+variable.ssw_refund)
        local stealthThreshold = (65 + vigorous * 35 + mosTalent * 10 + sswRefund)
        -- variable,name=shd_fractional,value=1.725+0.725*talent.enveloping_shadows.enabled
        local shdFrac = 1.725 + 0.725 * enveloped
        -- variable,name=dsh_dfa,value=talent.death_from_above.enabled&talent.dark_shadow.enabled&spell_targets.death_from_above<4
        local dshDFA = talent.deathFromAbove and talent.darkShadow and #enemies.yards8t < 4

        -- Custom Functions
        local function usePickPocket()
            if stealthingAll and not inCombat and (mode.pickPocket == 1 or mode.pickPocket == 2) then
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
    -- Action List - Extras
        local function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        ChatOverlay(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end
        -- Pick Pocket
            if usePickPocket() then
                if (isValidUnit(units.dyn5) or mode.pickPocket == 2) and mode.pickPocket ~= 3 then
                    if not isPicked(units.dyn5) and not isDummy(units.dyn5) then
                        if debuff.sap.remain(units.dyn5) < 1 and mode.pickPocket ~= 1 then
                            if cast.sap(units.dyn5) then return end
                        end
                        if lastSpell ~= spell.vanish then
                            if cast.pickPocket() then return end
                        end
                    end
                end
            end
        end -- End Action List - Extras
    -- Action List - Defensives
        local function actionList_Defensive()
            if useDefensive() and not stealth then
            -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") and not inCombat then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end
            -- Pot/Stoned
                if isChecked("Healthstone") and php <= getOptionValue("Healthstone") and inCombat and hasHealthPot() then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
                        useItem(healPot)
                    end
                end
            -- Cloak of Shadows
                if isChecked("Cloak of Shadows") and canDispel("player",spell.cloakOfShadows) then
                    if cast.cloakOfShadows() then return end
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
                if isChecked("Feint") and php <= getOptionValue("Feint") and inCombat and not buff.feint.exists() then
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
                        if cd.kick.remain() ~= 0 and cd.blind.remain() == 0 then
                            if isChecked("Kidney Shot") then
                                if cast.kidneyShot(thisUnit) then return end
                            end
                        end
                        if isChecked("Blind") and (cd.kick.remain() ~= 0 or distance >= 5) then
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
            if getDistance(units.dyn5) < 5 then
        -- Potion
                -- potion,if=buff.bloodlust.react|target.time_to_die<=60|(buff.vanish.up&(buff.shadow_blades.up|cooldown.shadow_blades.remains<=30))
                if useCDs() and isChecked("Agi-Pot") and canUse(127844) and inRaid then
                    if hasBloodLust() or ttd(units.dyn5) <= 25 or (buff.vanish.exists() and (buff.shadowBlades.exists() or cd.shadowBlades.remain() <= 30)) then
                        useItem(127844)
                    end
                end
        -- Draught of Souls
                -- use_item,name=draught_of_souls,if=!stealthed.rogue&energy.deficit>30+talent.vigor.enabled*10
                if useCDs() and isChecked("Trinkets") and hasEquiped(140808) and canUse(140808) then
                    if not stealthingRogue and powerDeficit > 30 + vigorous * 10 then
                        useItem(140808)
                    end
                end
        -- Specter of Betrayal
                if useCDs() and isChecked("Trinkets") and hasEquiped(151190) and canUse(151190) then
                    -- use_item,name=specter_of_betrayal,if=talent.dark_shadow.enabled&buff.shadow_dance.up&(!set_bonus.tier20_4pc|buff.symbols_of_death.up|(!talent.death_from_above.enabled&((mantle_duration>=3|!equipped.mantle_of_the_master_assassin)|cooldown.vanish.remains>=43)))
                    if talent.darkShadow and buff.shadowDance.exists() 
                        and (not t20_4pc or buff.symbolsOfDeath or (not talent.deathFromAbove and ((buff.masterAssassinsInitiative.remain() >= 3 or not hasEquiped(144236)) or cd.vanish.remain() >= 43))) 
                    then
                        useItem(151190)
                    end
                    -- use_item,name=specter_of_betrayal,if=!talent.dark_shadow.enabled&!buff.stealth.up&!buff.vanish.up&(mantle_duration>=3|!equipped.mantle_of_the_master_assassin)
                    if not talent.darkShadow and not buff.stealth.exists() and not buff.vanish.exists() and (buff.masterAssassinsInitiative.remain() >= 3 or not hasEquiped(144236)) then
                        useItem(151190)
                    end
                end
        -- Trinkets
                if useCDs() and isChecked("Trinkets") then
                    if canUse(13) and not (hasEquiped(140808, 13) or hasEquiped(151190, 13)) then
                        useItem(13)
                    end
                    if canUse(14) and not (hasEquiped(140808, 14) or hasEquiped(151190, 14)) then
                        useItem(14)
                    end
                end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury,if=stealthed.rogue
                -- berserking,if=stealthed.rogue
                -- arcane_torrent,if=stealthed.rogue&energy.deficit>70
                if useCDs() and isChecked("Racial") and stealthingRogue and (race == "Orc" or race == "Troll" or (race == "BloodElf" and powerDeficit > 70)) and getSpellCD(racial) == 0 then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Symbols of Death
                -- symbols_of_death,if=!talent.death_from_above.enabled&((time>10&energy.deficit>=40-stealthed.all*30)|(time<10&dot.nightblade.ticking))
                if not talent.deathFromAbove and ((combatTime > 10 and powerDeficit >= 40 - stealthedAll * 30) or (combatTime < 10 and debuff.nightblade.exists(units.dyn5))) then
                    if cast.symbolsOfDeath() then return end
                end
                -- symbols_of_death,if=(talent.death_from_above.enabled&cooldown.death_from_above.remains<=3&(dot.nightblade.remains>=cooldown.death_from_above.remains+3|target.time_to_die-dot.nightblade.remains<=6)&(time>=3|set_bonus.tier20_4pc|equipped.the_first_of_the_dead))|target.time_to_die-remains<=10
                if (talent.deathFromAbove and cd.deathFromAbove.remain() <= 3 and (debuff.nightblade.remain(units.dyn5) >= cd.deathFromAbove.remain() + 3 or ttd(units.dyn5) - debuff.nightblade.remain(units.dyn5) <= 6) 
                    and (combatTime >= 3 or t20_4pc or hasEquiped(151818))) or ttd(units.dyn5) <= 10 
                then
                    if cast.symbolsOfDeath() then return end
                end
        -- Marked For Death
                -- marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit
                -- marked_for_death,if=raid_event.adds.in>40&!stealthed.all&combo_points.deficit>=cp_max_spend
                if isChecked("Marked For Death") then
                    if getOptionValue("Marked For Death") == 1 then
                        if ttd("target") < comboDeficit or (not stealthingAll and comboDeficit >= comboMax) then
                            if cast.markedForDeath("target") then return end
                        end
                    end
                    if getOptionValue("Marked For Death") == 2 then
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                                if ttd(thisUnit) < comboDeficit or (not stealthingAll and comboDeficit >= comboMax) then
                                    if cast.markedForDeath(thisUnit) then return end
                                end
                            end
                        end
                    end
                end
        -- Shadow Blades
                -- shadow_blades,if=(time>10&combo_points.deficit>=2+stealthed.all-equipped.mantle_of_the_master_assassin)|(time<10&(!talent.marked_for_death.enabled|combo_points.deficit>=3|dot.nightblade.ticking))
                if useCDs() and isChecked("Shadow Blades") then
                    if (combatTime > 10 and comboDeficit >= 2 + stealthedAll - mantleMaster) or (combatTime < 10 and (not talent.markedForDeath or comboDeficit >= 3 or debuff.nightblade.exists(units.dyn5))) then
                        if cast.shadowBlades() then return end
                    end
                end
        -- Goremaws Bite
                -- goremaws_bite,if=!stealthed.all&cooldown.shadow_dance.charges_fractional<=variable.shd_fractional&((combo_points.deficit>=4-(time<10)*2&energy.deficit>50+talent.vigor.enabled*25-(time>=10)*15)|(combo_points.deficit>=1&target.time_to_die<8))
                if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and cd.goremawsBite.remain() == 0 then 
                    if not stealthingAll and charges.shadowDance.frac() <= shdFrac 
                        and ((comboDeficit >= 4 - justStarted * 2 and powerDeficit > 50 + vigorous * 25 - justStarted * 15) or (comboDeficit >= 1 and ttd(units.dyn5) < 8)) 
                    then
                        if cast.goremawsBite() then return end
                    end
                end
        -- Vanish
                -- pool_resource,for_next=1,extra_amount=55-talent.shadow_focus.enabled*10
                -- vanish,if=energy>=55-talent.shadow_focus.enabled*10&variable.dsh_dfa&(!equipped.mantle_of_the_master_assassin|buff.symbols_of_death.up)&cooldown.shadow_dance.charges_fractional<=variable.shd_fractional&!buff.shadow_dance.up&!buff.stealth.up&mantle_duration=0&(dot.nightblade.remains>=cooldown.death_from_above.remains+6|target.time_to_die-dot.nightblade.remains<=6)&cooldown.death_from_above.remains<=1|target.time_to_die<=7
                if useCDs() and isChecked("Vanish") and not solo then
                    if power < 55 - (shadFoc * 10) then
                        return true
                    elseif power > 55 - (shadFoc * 10) and dshDFA and (not hasEquiped(144236) or buff.symbolsOfDeath.exists()) 
                        and charges.shadowDance.frac() <= shdFrac and not buff.shadowDance.exists() and not buff.stealth.exists() and buff.masterAssassinsInitiative.remain() == 0 
                        and (debuff.nightblade.remain(units.dyn5) >= cd.deathFromAbove.remain() + 6 or ttd(units.dyn5) - debuff.nightblade.remain(units.dyn5) <= 6) and cd.deathFromAbove.remain() <= 1 or ttd(units.dyn5) <= 7 
                    then
                        if cast.vanish() then vanishTime = GetTime(); return end
                    end
                end
        -- Shadow Dance
                -- shadow_dance,if=!buff.shadow_dance.up&target.time_to_die<=4+talent.subterfuge.enabled
                if useCDs() and isChecked("Shadow Dance") and not buff.shadowDance.exists() and ttd(units.dyn5) <= 4 + subty then
                    if cast.shadowDance() then ShDCdTime = GetTime(); return end
                end
            end -- End Cooldown Usage Check
        end -- End Action List - Cooldowns
    -- Action List - Stealth Cooldowns
        local function actionList_StealthCooldowns()
            if getDistance(units.dyn5) < 5 then
            -- Print("Stealth Cooldowns")
        -- Vanish
                -- vanish,if=!variable.dsh_dfa&mantle_duration=0&cooldown.shadow_dance.charges_fractional<variable.shd_fractional+(equipped.mantle_of_the_master_assassin&time<30)*0.3&(!equipped.mantle_of_the_master_assassin|buff.symbols_of_death.up)
                if useCDs() and isChecked("Vanish") and not solo then
                    if not dshDFA and buff.masterAssassinsInitiative.remain() == 0 and charges.shadowDance.frac() < shdFrac + mantleMasterRecent * 0.3 
                        and (not hasEquiped(144236) or buff.symbolsOfDeath.exists()) 
                    then
                        if cast.vanish() then vanishTime = GetTime(); return end
                    end
                end
        -- Shadow Dance
                -- shadow_dance,if=charges_fractional>=variable.shd_fractional|target.time_to_die<cooldown.symbols_of_death.remains
                if useCDs() and isChecked("Shadow Dance") and not buff.shadowDance.exists() then
                    if charges.shadowDance.frac() >= shdFrac or ttd(units.dyn5) < cd.symbolsOfDeath.remain() then
                        if cast.shadowDance() then ShDCdTime = GetTime(); return end
                    end
                end
        -- Shadowmeld
                -- pool_resource,for_next=1,extra_amount=40
                -- shadowmeld,if=energy>=40&energy.deficit>=10+variable.ssw_refund
                if useCDs() and isChecked("Racial") and not solo and race == "NightElf" then
                    if power < 40 then
                        return true
                    elseif power >= 40 and powerDeficit >= 10 + sswRefund then
                        if cast.shadowmeld() then ShdMTime = GetTime(); return end
                    end
                end
        -- Shadow Dance
                -- shadow_dance,if=!variable.dsh_dfa&combo_points.deficit>=2+talent.subterfuge.enabled*2&(buff.symbols_of_death.remains>=1.2+gcd.remains|cooldown.symbols_of_death.remains>=12+(talent.dark_shadow.enabled&set_bonus.tier20_4pc)*3-(!talent.dark_shadow.enabled&set_bonus.tier20_4pc)*4|mantle_duration>0)&(spell_targets.shuriken_storm>=4|!buff.the_first_of_the_dead.up)
                if useCDs() and isChecked("Shadow Dance") and not buff.shadowDance.exists() then
                    if not dshDFA and comboDeficit >= 2 + subty * 2 
                        and (buff.symbolsOfDeath.remain() >= 1.2 + gcd or cd.symbolsOfDeath.remain() >= 12 + (dark20 * 3) - (notDark20 * 4) or buff.masterAssassinsInitiative.remain() > 0)
                        and (#enemies.yards10 >= 4 or not buff.theFirstOfTheDead.exists()) 
                    then
                        if cast.shadowDance() then ShDCdTime = GetTime(); return end
                    end
                end
            end
        end
    -- Action List - Finishers
        local function actionList_Finishers()
            -- Print("Finishers")
        -- Nightblade
            -- nightblade,if=(!talent.dark_shadow.enabled|!buff.shadow_dance.up)&target.time_to_die-remains>6&(mantle_duration=0|remains<=mantle_duration)&((refreshable&(!finality|buff.finality_nightblade.up|variable.dsh_dfa))|remains<tick_time*2)&(spell_targets.shuriken_storm<4&!variable.dsh_dfa|!buff.symbols_of_death.up)
            if (not talent.darkShadow or not buff.shadowDance.exists()) and ttd(units.dyn5) - debuff.nightblade.remain(units.dyn5) > 6 
                and (buff.masterAssassinsInitiative.remain() == 0 or debuff.nightblade.remain(units.dyn5) <= buff.masterAssassinsInitiative.remain()) 
                and ((debuff.nightblade.refresh(units.dyn5) and (not artifact.finality.enabled() or buff.finalityNightblade.exists() or dshDFA)) or debuff.nightblade.remain(units.dyn5) < 2 * 2) 
                and (#enemies.yards10 < 4 and not dshDFA or not buff.symbolsOfDeath.exists()) 
            then
                if cast.nightblade(units.dyn5) then return end
            end
            -- nightblade,cycle_targets=1,if=(!talent.death_from_above.enabled|set_bonus.tier19_2pc)&(!talent.dark_shadow.enabled|!buff.shadow_dance.up)&target.time_to_die-remains>12&mantle_duration=0&((refreshable&(!finality|buff.finality_nightblade.up|variable.dsh_dfa))|remains<tick_time*2)&(spell_targets.shuriken_storm<4&!variable.dsh_dfa|!buff.symbols_of_death.up)
            if isChecked("Nightblade Multidot") then
                for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if getDistance(thisUnit) <= 5 then
                        if (not talent.deathFromAbove or t19_2pc) and (not talent.darkShadow or not buff.shadowDance.exists()) 
                            and ttd(thisUnit) - debuff.nightblade.remain(thisUnit) > 12 and buff.masterAssassinsInitiative.remain() == 0 
                            and ((debuff.nightblade.refresh(thisUnit) and (not artifact.finality.enabled() or buff.finalityNightblade.exists() or dshDFA)) or debuff.nightblade.remain(thisUnit) < 2 * 2) 
                            and (#enemies.yards10 < 4 and not dshDFA or not buff.symbolsOfDeath.exists()) 
                        then
                            if cast.nightblade(thisUnit) then return end
                        end 
                    end
                end
            end
            -- nightblade,if=remains<cooldown.symbols_of_death.remains+10&cooldown.symbols_of_death.remains<=5+(combo_points=6*2)&target.time_to_die-remains>cooldown.symbols_of_death.remains+5
            if debuff.nightblade.remain(units.dyn5) < cd.symbolsOfDeath.remain() + 10 and cd.symbolsOfDeath.remain() <= 5 and ttd(units.dyn5) - debuff.nightblade.remain(units.dyn5) > cd.symbolsOfDeath.remain() + 5 then
                 if cast.nightblade(units.dyn5) then return end
            end
        -- Death from Above
            -- death_from_above,if=!talent.dark_shadow.enabled|(!buff.shadow_dance.up|spell_targets>=4)&(buff.symbols_of_death.up|cooldown.symbols_of_death.remains>=10+set_bonus.tier20_4pc*5)&buff.the_first_of_the_dead.remains<1&(buff.finality_eviscerate.up|spell_targets.shuriken_storm<4)
            if isChecked("Death From Above") then
                if not talent.darkShadow or (not buff.shadowDance.exists() or #enemies.yards8t >= getOptionValue("Death From Above")) 
                    and (buff.symbolsOfDeath.exists() or cd.symbolsOfDeath.remain() >= 10 + t20pc4 * 5) and buff.theFirstOfTheDead.remain() < 1
                    and (buff.finalityEviscerate.exists() or #enemies.yards10 < 4) 
                then
                    if cast.deathFromAbove() then return end
                end
            end
        -- Eviscerate
            -- eviscerate
            if cast.eviscerate() then return end
        end -- End Action List - Finishers
    -- Action List - Stealthed
        local function actionList_Stealthed()
            -- Print("Stealth")
        -- Shadowstrike
            -- shadowstrike,if=buff.stealth.up
            if buff.stealth.exists() and getDistance("target") <= getOptionValue ("SS Range") then
                if cast.shadowstrike() then return end
            end
        -- Finisher
            -- call_action_list,name=finish,if=combo_points>=5+(talent.deeper_stratagem.enabled&buff.vanish.up)&(spell_targets.shuriken_storm>=3+equipped.shadow_satyrs_walk|(mantle_duration<=1.3&mantle_duration>=0.3))
            if combo >= 5 + deepVanish and (#enemies.yards10 >= 3 + shadowWalker or (buff.masterAssassinsInitiative.remain() <= 1.3 and buff.masterAssassinsInitiative.remain() >= 0.3)) then
                if actionList_Finishers() then return end
            end
        -- Shuriken Storm
            -- shuriken_storm,if=buff.shadowmeld.down&((combo_points.deficit>=2+equipped.insignia_of_ravenholdt&spell_targets.shuriken_storm>=3+equipped.shadow_satyrs_walk)|(combo_points.deficit>=1&buff.the_dreadlords_deceit.stack>=29))
            if (mode.cleave == 1 or mode.rotation == 2) and not buff.shadowmeld.exists() 
                and ((comboDeficit >= 2 + insignia and ((mode.rotation == 1 and #enemies.yards10 >= 3 + shadowWalker) or (mode.rotation == 2 and #enemies.yards10 > 0))) 
                or (comboDeficit >= 1 and buff.theDreadlordsDeceit.stack() >= 29)) 
            then
                if cast.shurikenStorm() then return end
            end
        -- Finisher
            -- call_action_list,name=finish,if=combo_points>=5+(talent.deeper_stratagem.enabled&buff.vanish.up)&combo_points.deficit<3+buff.shadow_blades.up-equipped.mantle_of_the_master_assassin
            if combo >= 5 + deepVanish and comboDeficit < 3 + shadowedBlade - mantleMaster then
                if actionList_Finishers() then return end
            end
        -- Shadowstrike
            -- shadowstrike
            if getDistance("target") <= getOptionValue ("SS Range") then
                 if cast.shadowstrike() then return end
            end
        end
    -- Action List - Generators
        local function actionList_Generators()
            -- Print("Generator")
        -- Shuriken Storm
            -- shuriken_storm,if=spell_targets.shuriken_storm>=2
            if (mode.cleave == 1 or mode.rotation == 2) and ((mode.rotation == 1 and #enemies.yards10 >= 2 + firstDead) or (mode.rotation == 2 and #enemies.yards10 >= 0)) then
                if cast.shurikenStorm() then return end
            end
        -- Backstab / Gloomblade
            -- gloomblade
            -- backstab
            if cast.backstab() then return end
        end -- End Action List - Generators
    -- Action List - Starter
        local function actionList_Starter()
        -- Stealth Cooldowns
            -- call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold-25*(!cooldown.goremaws_bite.up&!buff.feeding_frenzy.up)&(!equipped.shadow_satyrs_walk|cooldown.shadow_dance.charges_fractional>=variable.shd_fractional|energy.deficit>=10)
            if powerDeficit <= stealthThreshold - 25 * noGoreFrenzy and (not hasEquiped(137032) or charges.shadowDance.frac() >= shdFrac or powerDeficit >= 10) then
                if actionList_StealthCooldowns() then return end
            end
            -- call_action_list,name=stealth_cds,if=mantle_duration>2.3
            if buff.masterAssassinsInitiative.remain() > 2.3 then
                if actionList_StealthCooldowns() then return end
            end
            -- call_action_list,name=stealth_cds,if=spell_targets.shuriken_storm>=4
            if #enemies.yards10 >= 4 then
                if actionList_StealthCooldowns() then return end
            end
            -- call_action_list,name=stealth_cds,if=(cooldown.shadowmeld.up&!cooldown.vanish.up&cooldown.shadow_dance.charges<=1)
            if (cd.shadowmeld.remain() == 0 and cd.vanish.remain() > 0 and charges.shadowDance.count() <= 1) then
                if actionList_StealthCooldowns() then return end
            end
            -- call_action_list,name=stealth_cds,if=target.time_to_die<12*cooldown.shadow_dance.charges_fractional*(1+equipped.shadow_satyrs_walk*0.5)
            if ttd(units.dyn5) < 12 * charges.shadowDance.frac() * (1 + shadowWalker * 0.5) then
                if actionList_StealthCooldowns() then return end
            end
        end
    -- Action List - PreCombat
        local function actionList_PreCombat()
            -- Print("PreCombat")
        -- Stealth
            -- stealth
            if isChecked("Stealth") and (not IsResting() or isDummy("target")) and not inCombat and not stealth then
                if getOptionValue("Stealth") == 1 then
                    if cast.stealth() then return end
                end
                if getOptionValue("Stealth") == 2 then
                    for i = 1, #enemies.yards20 do
                        local thisUnit = enemies.yards20[i]
                        if UnitIsEnemy(thisUnit,"player") or isDummy("target") then
                            if cast.stealth() then return end
                        end
                    end
                end
            end
            if isValidUnit("target") and mode.pickPocket ~= 2 then
        -- Potion
                -- potion
                if stealth then
                    if useCDs() and isChecked("Potion") and inRaid then
                        if canUse(127844) then
                            useItem(127844)
                        elseif canUse(142117) then
                            useItem(142117)
                        end
                    end
                end 
        -- Marked For Death
                -- marked_for_death,if=raid_event.adds.in>40
                if isChecked("Marked For Death - Precombat") and not inCombat then
                    if cast.markedForDeath("target") then return end
                end
        -- Symbols of Death
                -- symbols_of_death
                if isChecked("Symbols of Death - Precombat") and not inCombat then
                    if cast.symbolsOfDeath("player") then return end
                end
            end
        end -- End Action List - PreCombat
    -- Action List - Opener
        local function actionList_Opener()
            if isValidUnit("target") and mode.pickPocket ~= 2 then
        -- Shadowstep
                if isChecked("Shadowstep") and (not stealthingAll or power < 40 or getDistance("target") > getOptionValue ("SS Range")) and not inCombat and getDistance("target") >= 8 then
                    if cast.shadowstep("target") then return end
                end
        -- Shadowstrike
                if (not isChecked("Shadowstep") or stealthingAll) and getDistance("target") <= getOptionValue ("SS Range") and not inCombat then
                    if cast.shadowstrike("target") then return end
                end
        -- Start Attack
                if getDistance("target") < 5 and not stealthingAll then
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
            if inCombat and mode.pickPocket ~= 2 and isValidUnit(units.dyn5) then
------------------------------
--- In Combat - Interrupts ---
------------------------------
                if actionList_Interrupts() then return end
----------------------------------
--- In Combat - Begin Rotation ---
----------------------------------
        -- Shadowstep
                if isChecked("Shadowstep") and getDistance("target") >= 8 then
                    if cast.shadowstep("target") then return end
                end
        -- Shuriken Toss
                if isChecked("Shuriken Toss OOR") and power >= getOptionValue("Shuriken Toss OOR") and getDistance(units.dyn30) > 8 and hasThreat(units.dyn30) and not stealthingAll then
                    if cast.shurikenToss() then return end
                end
                if getDistance(units.dyn5) < 5 then
        -- Shadow Dance 
                    -- shadow_dance,if=talent.dark_shadow.enabled&(!stealthed.all|buff.subterfuge.up)&buff.death_from_above.up&buff.death_from_above.remains<=0.15
                    if useCDs() and isChecked("Shadow Dance") and not buff.shadowDance.exists() then
                        if talent.darkShadow and (not stealthingAll or buff.subterfuge.exists())and buff.deathFromAbove.exists() and buff.deathFromAbove.remain() <= 0.15 then
                            if cast.shadowDance() then ShDCdTime = GetTime(); return end
                        end
                    end
        -- Cooldowns
                    -- call_action_list,name=cds
                    if actionList_Cooldowns() then return end
        -- Stealthed
                    -- run_action_list,name=stealthed,if=stealthed.all
                    if stealthingAll then
                        if actionList_Stealthed() then return end
                    end
        -- Nightblade
                    -- nightblade,if=target.time_to_die>6&remains<gcd.max&combo_points>=4-(time<10)*2
                    if ttd(units.dyn5) > 6 and debuff.nightblade.remain(units.dyn5) < gcdMax and combo >= 4 - (justStarted * 2) then
                        if cast.nightblade() then return end
                    end
        -- Starter
                    -- call_action_list,name=stealth_als,if=talent.dark_shadow.enabled&combo_points.deficit>=2+buff.shadow_blades.up&(dot.nightblade.remains>4+talent.subterfuge.enabled|cooldown.shadow_dance.charges_fractional>=1.9&(!equipped.denial_of_the_halfgiants|time>10))
                    if talent.darkShadow and comboDeficit >= 2 + shadowedBlade 
                        and (debuff.nightblade.remain(units.dyn5) > 4 + subty or charges.shadowDance.frac() >= 1.9 and (not hasEquiped(137100) or combatTime > 10)) 
                    then
                        if actionList_Starter() then return end
                    end
                    -- call_action_list,name=stealth_als,if=!talent.dark_shadow.enabled&(combo_points.deficit>=2+buff.shadow_blades.up|cooldown.shadow_dance.charges_fractional>=1.9+talent.enveloping_shadows.enabled)
                    if not talent.darkShadow and (comboDeficit >= 2 + shadowedBlade or charges.shadowDance.frac() >= 1.9 + enveloped) then
                        if actionList_Starter() then return end
                    end
        -- Finishers
                    -- call_action_list,name=finish,if=combo_points>=5+3*(buff.the_first_of_the_dead.up&talent.anticipation.enabled)+(talent.deeper_stratagem.enabled&!buff.shadow_blades.up&(mantle_duration=0|set_bonus.tier20_4pc)&(!buff.the_first_of_the_dead.up|variable.dsh_dfa))|(combo_points>=4&combo_points.deficit<=2&spell_targets.shuriken_storm>=3&spell_targets.shuriken_storm<=4)|(target.time_to_die<=1&combo_points>=3)
                    if combo >= 5 + 3 * firstAnti + dStratNoBlades
                        or (combo >= 4 and comboDeficit <= 2 and #enemies.yards10 >= 3 and #enemies.yards10 <= 4)
                        or (ttd(units.dyn5) <= 1 and combo >= 3) 
                    then
                        if actionList_Finishers() then return end
                    end
                    -- call_action_list,name=finish,if=variable.dsh_dfa&cooldown.symbols_of_death.remains<=1&combo_points>=2&equipped.the_first_of_the_dead&spell_targets.shuriken_storm<2
                    if dshDFA and cd.symbolsOfDeath.remain() <= 1 and combo >= 2 and hasEquiped(151818) and #enemies.yards10 < 2 then
                        if actionList_Finishers() then return end
                    end
        -- Generators
                    -- call_action_list,name=build,if=energy.deficit<=variable.stealth_threshold
                    -- if GetTime() > vanishTime + 1 and GetTime() > ShDCdTime + 1 and GetTime() > ShdMTime + 1 and edThreshVar then
                    if powerDeficit <= stealthThreshold and combo < 5 then
                        if actionList_Generators() then return end
                    end
                end
            end -- End In Combat
        end -- End Profile
    end -- Timer
end -- runRotation
local id = 261
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
