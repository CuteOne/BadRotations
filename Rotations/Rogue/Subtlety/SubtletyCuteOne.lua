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
            br.ui:createCheckbox(section, "Death From Above")
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
        local combo, comboDeficit, comboMax                             = br.player.power.amount.comboPoints, br.player.power.comboPoints.deficit, br.player.power.comboPoints.max
        local deadtar                                                   = UnitIsDeadOrGhost("target")
        local debuff                                                    = br.player.debuff
        local enemies                                                   = enemies or {}
        local flaskBuff, canFlask                                       = getBuffRemain("player",br.player.flask.wod.buff.agilityBig), canUse(br.player.flask.wod.agilityBig)
        local gcd                                                       = br.player.gcd
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
        local power, powerMax, powerDeficit, powerRegen, powerTTM       = br.player.power.amount.energy, br.player.power.energy.max, br.player.power.energy.deficit, br.player.power.regen, br.player.power.ttm
        local pullTimer                                                 = br.DBM:getPulltimer()
        local race                                                      = br.player.race
        local racial                                                    = br.player.getRacial()
        local solo                                                      = #br.friend < 2
        local spell                                                     = br.player.spell
        local stealth                                                   = br.player.buff.stealth.exists()
        local stealthingAll                                             = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowmeld.exists() or br.player.buff.shadowDance.exists() or br.player.buff.subterfuge.exists()
        local stealthingRogue                                           = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowDance.exists() or br.player.buff.subterfuge.exists()
        local t18_4pc                                                   = br.player.eq.t18_4pc
        local talent                                                    = br.player.talent
        local time                                                      = getCombatTime()
        local ttd                                                       = getTTD
        local ttm                                                       = br.player.power.ttm
        local units                                                     = units or {}

        units.dyn5 = br.player.units(5)
        units.dyn30 = br.player.units(30)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards10 = br.player.enemies(10)
        enemies.yards20 = br.player.enemies(20)
        enemies.yards30 = br.player.enemies(30)

        if talent.anticipation then antital = 1 else antital = 0 end
        if talent.deeperStrategem then dStrat = 1 else dStrat = 0 end
        if talent.envelopingShadows then enveloped = 1 else enveloped = 0 end
        if talent.masterOfShadows then mosTalent = 1 else mosTalent = 0 end
        if talent.premeditation then premed = 1 else premed = 0 end
        if talent.subterfuge then subty = 1 else subty = 2 end
        if talent.subterfuge or buff.theFirstOfTheDead.exists() then subtyDead = 1 else subtyDead = 0 end
        if talent.vigor then vigorous = 1 else vigorous = 0 end
        if combatTime < 10 then justStarted = 1 else justStarted = 0 end
        if vanishTime == nil then vanishTime = GetTime() end
        if ShDCdTime == nil then ShDCdTime = GetTime() end
        if ShdMTime == nil then ShdMTime = GetTime() end
        if buff.shadowBlades.exists() then shadowedBlade = 1 else shadowedBlade = 0 end
        if hasEquiped(137032) then shadowWalker = 1 else shadowWalker = 0 end
        if hasEquiped(144236) then mantleMaster = 1 else mantleMaster = 0 end
        if mantleMaster == 1 and combatTime < 30 then mantleMasterRecent = 1 else mantleMasterRecent = 0 end
        if hasEquiped(144236) and hasEquiped(137100) then halfMantled = 1 else halfMantled = 0 end
        if stealthingAll then stealthedAll = 1 else stealthedAll = 0 end

        -- variable,name=ssw_refund,value=equipped.shadow_satyrs_walk*(6+ssw_refund_offset)
        local sswRefund = shadowWalker * (6 + getOptionValue("SSW Offset"))
        -- variable,name=stealth_threshold,value=(65+talent.vigor.enabled*35+talent.master_of_shadows.enabled*10+variable.ssw_refund)
        local stealthThreshold = (65 + vigorous * 35 + mosTalent * 10 + sswRefund)
        -- variable,name=shd_fractionnal,value=1.725+0.725*talent.enveloping_shadows.enabled
        local shdFrac = 1.725 + 0.725 * enveloped

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
            if getDistance(units.dyn5) < 5 then
        -- Potion
                -- potion,if=buff.bloodlust.react|target.time_to_die<=25|buff.shadow_blades.up
                if useCDs() and isChecked("Agi-Pot") and canUse(127844) and inRaid then
                    if ttd(units.dyn5) <= 25 or buff.shadowBlades.exists() or hasBloodLust() then
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
                -- use_item,name=specter_of_betrayal
                if useCDs() and isChecked("Trinkets") and hasEquiped(151190) and canUse(151190) then
                    useItem(151190)
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
                -- symbols_of_death,if=energy.deficit>=40-stealthed.all*30
                if powerDeficit >= 40 - stealthedAll * 30 then
                    if cast.symbolsOfDeath() then return end
                end
        -- Marked For Death
                -- marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit
                -- marked_for_death,if=raid_event.adds.in>40&combo_points.deficit>=cp_max_spend
                if isChecked("Marked For Death") then
                    if getOptionValue("Marked For Death") == 1 then
                        if ttd("target") < comboDeficit or comboDeficit >= comboMax then
                            if cast.markedForDeath() then return end
                        end
                    end
                    if getOptionValue("Marked For Death") == 2 then
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                                if ttd(thisUnit) < comboDeficit or comboDeficit >= comboMax then
                                    if cast.markedForDeath(thisUnit) then return end
                                end
                            end
                        end
                    end
                end
        -- Shadow Blades
                -- shadow_blades,if=combo_points.deficit>=2+stealthed.all-equipped.mantle_of_the_master_assassin
                if useCDs() and isChecked("Shadow Blades") and combo >= 2 + stealthedAll - mantleMaster then
                    if cast.shadowBlades() then return end
                end
        -- Goremaws Bite
                -- goremaws_bite,if=!stealthed.all&cooldown.shadow_dance.charges_fractional<=variable.shd_fractional&((combo_points.deficit>=4-(time<10)*2&energy.deficit>50+talent.vigor.enabled*25-(time>=10)*15)|(combo_points.deficit>=1&target.time_to_die<8))
                if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and cd.goremawsBite == 0 then 
                    if not stealthingAll and charges.frac.shadowDance <= shdFrac 
                        and ((comboDeficit >= 4 - justStarted * 2 and powerDeficit > 50 + vigorous * 25 - justStarted * 15) or (comboDeficit >= 1 and ttd(units.dyn5) < 8)) 
                    then
                        if cast.goremawsBite() then return end
                    end
                end
            end -- End Cooldown Usage Check
        end -- End Action List - Cooldowns
    -- Action List - Stealth Cooldowns
        local function actionList_StealthCooldowns()
            if getDistance(units.dyn5) < 5 then
            -- Print("Stealth Cooldowns")
        -- Vanish
                -- vanish,if=mantle_duration=0&cooldown.shadow_dance.charges_fractional<variable.shd_fractionnal+(equipped.mantle_of_the_master_assassin&time<30)*0.3
                if useCDs() and isChecked("Vanish") and not solo then
                    if buff.masterAssassinsInitiative.remain() == 0 and charges.frac.shadowDance < shdFrac + mantleMasterRecent * 0.3 then
                        if cast.vanish() then vanishTime = GetTime(); return end
                    end
                end
        -- Shadow Dance
                -- shadow_dance,if=charges_fractional>=variable.shd_fractionnal
                if useCDs() and isChecked("Shadow Dance") and charges.frac.shadowDance >= shdFrac then
                    if cast.shadowDance() then ShDCdTime = GetTime(); return end
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
                -- shadow_dance,if=combo_points.deficit>=2+(talent.subterfuge.enabled|buff.the_first_of_the_dead.up)*2&(cooldown.symbols_of_death.remains>2|!talent.dark_shadow.enabled)
                if useCDs() and isChecked("Shadow Dance") and not buff.shadowDance.exists() then
                    if comboDeficit >= 2 + subtyDead * 2 and (cd.symbolsOfDeath > 2 or not talent.darkShadow) then
                        if cast.shadowDance() then ShDCdTime = GetTime(); return end
                    end
                end
            end
        end
    -- Action List - Finishers
        local function actionList_Finishers()
            -- Print("Finishers")
        -- Death from Above
            -- death_from_above,if=spell_targets.death_from_above>=5
            if isChecked("Death From Above") and #enemies.yards8 >= 5 then
                if cast.deathFromAbove() then return end
            end
        -- Night Blade
            -- nightblade,if=target.time_to_die-remains>8&(mantle_duration=0|remains<=mantle_duration)&((refreshable&(!finality|buff.finality_nightblade.up))|remains<tick_time*2)
            if ttd("target") - debuff.nightblade.remain("target") > 8 and (buff.masterAssassinsInitiative.remain() == 0 or debuff.nightblade.remain("target") <= buff.masterAssassinsInitiative.remain()) 
                and ((debuff.nightblade.refresh("target") and (not artifact.finality or buff.finalityNightblade.exists())) or debuff.nightblade.remain("target") < 2) 
            then
                if cast.nightblade("target") then return end
            end
            -- nightblade,cycle_targets=1,if=target.time_to_die-remains>8&mantle_duration=0&((refreshable&(!finality|buff.finality_nightblade.up))|remains<tick_time*2)
            if isChecked("Nightblade Multidot") then
                for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if getDistance(thisUnit) <= 5 then
                        if ttd(thisUnit) - debuff.nightblade.remain(thisUnit) >= getOptionValue("Nightblade Multidot") and buff.masterAssassinsInitiative.remain() == 0 
                            and ((debuff.nightblade.refresh(thisUnit) and (not artifact.finality or buff.finalityNightblade.exists())) or debuff.nightblade.remain(thisUnit) < 2) 
                        then
                            if cast.nightblade(thisUnit) then return end
                        end
                    end
                end
            end
        -- Death from Above
            -- death_from_above
            if isChecked("Death From Above") then
                if cast.deathFromAbove() then return end
            end
        -- Eviscerate
            -- eviscerate,if=!talent.death_from_above.enabled|cooldown.death_from_above.remains>=(energy.max-energy-combo_points*6)%energy.regen-(2+(equipped.mantle_of_the_master_assassin&equipped.denial_of_the_halfgiants))
            if not talent.deathFromAbove or cd.deathFromAbove >= (powerMax - power - combo * 6) / powerRegen - (2 + halfMantled) then
                if cast.eviscerate() then return end
            end
        end -- End Action List - Finishers
    -- Action List - Stealthed
        local function actionList_Stealthed()
            -- Print("Stealth")
        -- Finisher
            -- call_action_list,name=finish,if=combo_points>=5&(spell_targets.shuriken_storm>=3+equipped.shadow_satyrs_walk|(mantle_duration<=1.3&mantle_duration-gcd.remains>=0.3))
            if combo >= 5 and (#enemies.yards10 >= 3 + shadowWalker or (buff.masterAssassinsInitiative.remain() <= 1.3 and buff.masterAssassinsInitiative.remain() - cd.global >= 0.3)) then
                if actionList_Finishers() then return end
            end
        -- Shuriken Storm
            -- shuriken_storm,if=buff.shadowmeld.down&((combo_points.deficit>=3&spell_targets.shuriken_storm>=3+equipped.shadow_satyrs_walk)|(combo_points.deficit>=1&buff.the_dreadlords_deceit.stack>=29))
            if not buff.shadowmeld.exists() and ((comboDeficit >= 3 and #enemies.yards10 >= 3 + shadowWalker) or (comboDeficit >= 1 and buff.theDreadlordsDeceit.stack() >= 29)) then
                if cast.shurikenStorm() then return end
            end
        -- Finisher
            -- call_action_list,name=finish,if=combo_points>=5&combo_points.deficit<3+buff.shadow_blades.up-equipped.mantle_of_the_master_assassin
            if combo >= 5 and comboDeficit < 3 + shadowedBlade - mantleMaster then
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
            if #enemies.yards10 >= 2 then
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
            -- call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold&(!equipped.shadow_satyrs_walk|cooldown.shadow_dance.charges_fractional>=variable.shd_fractionnal|energy.deficit>=10)
            if powerDeficit <= stealthThreshold and (not hasEquiped(137032) or charges.frac.shadowDance >= shdFrac or powerDeficit >= 10) then
                if actionList_StealthCooldowns() then return end
            end
            -- call_action_list,name=stealth_cds,if=mantle_duration>2.3
            if buff.masterAssassinsInitiative.remain() > 2.3 then
                if actionList_StealthCooldowns() then return end
            end
            -- call_action_list,name=stealth_cds,if=spell_targets.shuriken_storm>=5
            if #enemies.yards10 >= 5 then
                if actionList_StealthCooldowns() then return end
            end
            -- call_action_list,name=stealth_cds,if=(cooldown.shadowmeld.up&!cooldown.vanish.up&cooldown.shadow_dance.charges<=1)
            if (cd.shadowmeld == 0 and cd.vanish > 0 and charges.shadowDance <= 1) then
                if actionList_StealthCooldowns() then return end
            end
            -- call_action_list,name=stealth_cds,if=target.time_to_die<12*cooldown.shadow_dance.charges_fractional*(1+equipped.shadow_satyrs_walk*0.5)
            if ttd(units.dyn5) < 12 * charges.frac.shadowDance * (1 + shadowWalker * 0.5) then
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
        -- Cooldowns
                    -- call_action_list,name=cds
                    if actionList_Cooldowns() then return end
        -- Stealthed
                    -- run_action_list,name=stealthed,if=stealthed|buff.shadowmeld.up
                    if stealthingAll then
                        if actionList_Stealthed() then return end
                    end
        -- Nightblade
                    -- nightblade,if=target.time_to_die>8&remains<gcd.max&combo_points>=4
                    if ttd(units.dyn5) > 8 and debuff.nightblade.remain(units.dyn5) < gcd and combo >= 4 then
                        if cast.nightblade() then return end
                    end
        -- Starter
                    -- call_action_list,name=stealth_als,if=talent.dark_shadow.enabled&combo_points.deficit>=3&(dot.nightblade.remains>4+talent.subterfuge.enabled|cooldown.shadow_dance.charges_fractional>=1.9&(!equipped.denial_of_the_halfgiants|time>10))
                    if talent.darkShadow and comboDeficit >= 3 and (debuff.nightblade.remain(units.dyn5) > 4 + subty or charges.frac.shadowDance >= 1.9 and (not hasEquiped(137100) or combatTime > 10)) then
                        if actionList_Starter() then return end
                    end
                    -- call_action_list,name=stealth_als,if=!talent.dark_shadow.enabled&(combo_points.deficit>=3|cooldown.shadow_dance.charges_fractional>=1.9+talent.enveloping_shadows.enabled)
                    if not talent.darkShadow and (comboDeficit >= 3 or charges.frac.shadowDance >= 1.9 + enveloped) then
                        if actionList_Starter() then return end
                    end
        -- Finishers
                    -- call_action_list,name=finish,if=combo_points>=5|(combo_points>=4&combo_points.deficit<=2&spell_targets.shuriken_storm>=3&spell_targets.shuriken_storm<=4)
                    if combo >= 5 or (combo >= 4 and comboDeficit <= 2 and #enemies.yards10 >= 3 and #enemies.yards10 <= 4) then
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
