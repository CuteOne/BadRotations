local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.howlingBlast },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.howlingBlast },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.frostStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.deathStrike}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.empowerRuneWeapon },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.empowerRuneWeapon },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.empowerRuneWeapon }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.iceboundFortitude },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.iceboundFortitude }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.mindFreeze }
    };
    CreateButton("Interrupt",4,0)
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
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Artifact
            br.ui:createDropdownWithout(section, "Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
            br.ui:createSpinnerWithout(section, "Artifact Units",  5,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Singragosa's Fury on. Min: 1 / Max: 10 / Interval: 1")
            -- Death Grip
            br.ui:createCheckbox(section,"Death Grip")
            -- Glacial Advance
            br.ui:createSpinner(section, "Glacial Advance",  5,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Glacial Advance on. Min: 1 / Max: 10 / Interval: 1")
            -- Path of Frost
            br.ui:createCheckbox(section,"Path of Frost")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Breath of Sindragosa - Debug
            br.ui:createCheckbox(section, "Breath Of Sindragosa Debug", "|cffFFFFFFShows when BoS is active and time it is active for.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Countless Armies","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Horn of Valor
            br.ui:createCheckbox(section,"Horn of Valor")
            -- Ring of Collapsing Futures
            br.ui:createSpinner(section, "Ring of Collapsing Futures",  1,  1,  5,  1,  "|cffFFFFFFSet to desired number of Temptation stacks before letting fall off. Min: 1 / Max: 5 / Interval: 1")
            -- Breath of Sindragosa
            br.ui:createCheckbox(section,"Breath of Sindragosa")
            -- Empower Rune Weapon
            br.ui:createCheckbox(section,"Empower/Hungering Rune Weapon")
            -- Obliteration
            br.ui:createCheckbox(section,"Obliteration")
            -- Pillar of Frost
            br.ui:createDropdownWithout(section, "Pillar of Frost", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Pillar of Frost Ability.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healing Potion/Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Anti-Magic Shell
            br.ui:createSpinner(section, "Anti-Magic Shell",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Blinding Sleet
            br.ui:createSpinner(section, "Blinding Sleet",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Death Strike
            br.ui:createSpinner(section, "Death Strike",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Icebound Fortitude
            br.ui:createSpinner(section, "Icebound Fortitude",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Raise Ally
            br.ui:createCheckbox(section,"Raise Ally")
            br.ui:createDropdownWithout(section, "Raise Ally - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Anti-Magic Zone
            -- br.ui:createCheckbox(section,"Anti-Magic Zone - Int")
            -- Blinding Sleet
            -- br.ui:createCheckbox(section,"Blinding Sleet - Int")
            -- Mind Freeze
            br.ui:createCheckbox(section,"Mind Freeze")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Cleave Toggle
            br.ui:createDropdownWithout(section,  "Cleave Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugFrost", 0.1) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
--------------
--- Locals ---
--------------
        local attacktar         = UnitCanAttack("target", "player")
        local buff              = br.player.buff
        local cast              = br.player.cast
        local cd                = br.player.cd
        local charges           = br.player.charges
        local deadtar           = UnitIsDeadOrGhost("target") or isDummy()
        local debuff            = br.player.debuff
        local enemies           = enemies or {}
        local equiped           = br.player.equiped
        local gcd               = br.player.gcd
        local glyph             = br.player.glyph
        local healPot           = getHealthPot()
        local inCombat          = br.player.inCombat
        local item              = br.player.item
        local level             = br.player.level
        local mode              = br.player.mode
        local moving            = GetUnitSpeed("player")>0
        local php               = br.player.health
        local power             = br.player.power
        local pullTimer         = br.DBM:getPulltimer()
        local racial            = br.player.getRacial()
        local runicPower        = br.player.power.runicPower.amount()
        local runicPowerDeficit = br.player.power.runicPower.deficit()
        local runes             = br.player.power.runes.amount()
        local runeFrac          = br.player.power.runes.frac()
        local swimming          = IsSwimming()
        local talent            = br.player.talent
        local t19_2pc           = TierScan("T19") >= 2
        local t19_4pc           = TierScan("T19") >= 4
        local t20_2pc           = TierScan("T20") >= 2
        local t20_4pc           = TierScan("T20") >= 4
        local ttd               = getTTD
        local units             = units or {}
        local use               = br.player.use

    -- Enemies
        units.dyn5        = br.player.units(5)
        units.dyn8        = br.player.units(8)
        units.dyn30       = br.player.units(30)
        enemies.yards8    = br.player.enemies(8)
        enemies.yards10   = br.player.enemies(10)
        enemies.yards10t  = br.player.enemies(10,br.player.units(10,true))
        enemies.yards15   = br.player.enemies(15)
        enemies.yards30   = br.player.enemies(30)
        enemies.yards40   = br.player.enemies(40)

        if breathOfSindragosaActive == nil then breathOfSindragosaActive = false end
        if breathOfSindragosaActive and not breathTimerSet then currentBreathTime = GetTime(); breathTimerSet = true end
        if not breathOfSindragosaActive then breathTimerSet = false end --; breathTimer = GetTime() end
        if currentBreathTime == nil then breathTimer = 0 end
        if breathTimerSet then breathTimer = round2(GetTime() - currentBreathTime,2) end
        if profileDebug == nil or not inCombat then profileDebug = "None" end

        if isChecked("Breath Of Sindragosa Debug") then
            ChatOverlay("Breath Active: "..tostring(breathOfSindragosaActive).." | Breath Timer: "..breathTimer)
        end

        -- ChatOverlay(tostring(profileDebug))

    -- Profile Stop
        if profileStop == nil then profileStop = false end
--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
            profileDebug = "Extras"
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                        profileStop = true
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        return true
                    end
                end
            end
        -- Chains of Ice
            if isChecked("Chains of Ice") then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if not debuff.chainsOfIce.exists(thisUnit) and not getFacing(thisUnit,"player") and getFacing("player",thisUnit)
                        and isMoving(thisUnit) and getDistance(thisUnit) > 8 and inCombat
                    then
                        if cast.chainsOfIce(thisUnit) then return end
                    end
                end
            end
        -- Death Grip
            if isChecked("Death Grip") then
                if inCombat and isValidUnit(units.dyn30) and getDistance(units.dyn30) > 8 and not isDummy(units.dyn30) then
                    if cast.deathGrip(units.dyn30) then return end
                end
            end
        -- Path of Frost
            if isChecked("Path of Frost") then
                if not inCombat and swimming and not buff.pathOfFrost.exists() then
                    if cast.pathOfFrost() then return end
                end
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
            profileDebug = "Defensive"
            if useDefensive() and not IsMounted() then
        -- Healthstone
                if isChecked("Healthstone") and php <= getOptionValue("Healing Potion/Healthstone") and inCombat and (hasHealthPot() or hasItem(5512)) then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
                        useItem(healPot)
                    end
                end
        -- Anti-Magic Shell
                if isChecked("Anti-Magic Shell") and php < getOptionValue("Anti-Magic Shell") and inCombat then
                    if cast.antiMagicShell() then return end
                end
        -- Blinding Sleet
                if isChecked("Blinding Sleet") and php < getOptionValue("Blinding Sleet") and inCombat then
                    if cast.blindingSleet() then return end
                end
        -- Death Strike
                if isChecked("Death Strike") and inCombat and (buff.darkSuccor.exists() or php < getOptionValue("Death Strike"))
                    and (not talent.breathOfSindragosa or ((cd.breathOfSindragosa.remain() > 15 and not breathOfSindragosaActive) or not useCDs() or not isChecked("Breath of Sindragosa")))
                then
                    if cast.deathStrike() then return end
                end
        -- Icebound Fortitude
                if isChecked("Icebound Fortitude") and php < getOptionValue("Icebound Fortitude") and inCombat then
                    if cast.iceboundFortitude() then return end
                end
        -- Raise Ally
                if isChecked("Raise Ally") then
                    if getOptionValue("Raise Ally - Target")==1
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                    then
                        if cast.raiseAlly("target","dead") then return end
                    end
                    if getOptionValue("Raise Ally - Target")==2
                        and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                    then
                        if cast.raiseAlly("mouseover","dead") then return end
                    end
                end
            end -- End Use Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            profileDebug = "Interrupts"
            if useInterrupts() then
        -- Mind Freeze
                if isChecked("Mind Freeze") then
                    for i=1, #enemies.yards15 do
                        thisUnit = enemies.yards15[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if cast.mindFreeze(thisUnit) then return end
                        end
                    end
                end
            end -- End Use Interrupts Check
        end -- End Action List - Interrupts
    -- Action List - Cold Heart
        local function actionList_ColdHeart()
            profileDebug = "Cold Heart"
        -- Chains of Ice
            -- chains_of_ice,if=buff.cold_heart.stack=20&buff.unholy_strength.up&cooldown.pillar_of_frost.remains>6
            if buff.coldHeart.stack() == 20 and buff.unholyStrength.exists() and cd.pillarOfFrost.remain() > 6 then
                if cast.chainsOfIce() then return end
            end
            -- chains_of_ice,if=buff.pillar_of_frost.up&buff.pillar_of_frost.remains<gcd&(buff.cold_heart.stack>=11|(buff.cold_heart.stack>=10&set_bonus.tier20_4pc))
            if buff.pillarOfFrost.exists() and buff.pillarOfFrost.remain() < gcd and (buff.coldHeart.stack() >= 11 or (buff.coldHeart.stack() >= 10 and tier20_4pc)) then
                if cast.chainsOfIce() then return end
            end
            -- chains_of_ice,if=buff.unholy_strength.up&buff.unholy_strength.remains<gcd&buff.cold_heart.stack>16&cooldown.pillar_of_frost.remains>6
            if buff.unholyStrength.exists() and buff.unholyStrength.remain() < gcd and buff.coldHeart.stack() > 16 and cd.pillarOfFrost.remain() > 6 then
                if cast.chainsOfIce() then return end
            end
            -- chains_of_ice,if=buff.cold_heart.stack>=4&target.time_to_die<=gcd
            if buff.coldHeart.stack() >= 4 and ttd(units.dyn5) <= gcd then
                if cast.chainsOfIce() then return end
            end
        end -- End Action List - Cold Heart
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            profileDebug = "Cooldowns"
            if getDistance(units.dyn5) < 5 then
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- arcane_torrent,if=runic_power<80&!talent.breath_of_sindragosa.enabled
                -- arcane_torrent,if=dot.breath_of_sindragosa.ticking&runic_power<50&rune<2
                -- blood_fury,if=buff.pillar_of_frost.up
                -- berserking,if=buff.pillar_of_frost.up
                if isChecked("Racial") and useCDs() and (((br.player.race == "Troll" or br.player.race == "Orc") and buff.pillarOfFrost.exists())
                    or (br.player.race == "BloodElf" and ((runicPower < 80 and not talent.breathOfSindragosa) 
                        or (breathOfSindragosaActive and runicPower < 50 and runes < 2)))) 
                    and getSpellCD(racial) == 0
                then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Trinkets
                -- use_items
                if isChecked("Trinkets") and useCDs() then
                    if not (equiped.hornOfValor(13) or equiped.draughtOfSouls(13) or equiped.feloiledInfernalMachine(13)) then
                        use.slot(13)
                    end
                    if not (equiped.hornOfValor(14) or equiped.draughtOfSouls(14) or equiped.feloiledInfernalMachine(14)) then
                        use.slot(14)
                    end
                end
        -- Ring of Collapsing Futures
                -- use_item,name=ring_of_collapsing_futures,if=(buff.temptation.stack=0&target.time_to_die>60)|target.time_to_die<60
                if isChecked("Ring of Collapsing Futures") and useCDs() then
                    if (debuff.temptation.stack("player") < getOptionValue("Ring of Collapsing Futures") and ttd("target") > 60) or ttd("target") < 60 and select(2,IsInInstance()) ~= "pvp" then
                        use.ringOfCollapsingFutures()
                    end
                end
        -- Horn of Valor
                -- use_item,name=horn_of_valor,if=buff.pillar_of_frost.up&(!talent.breath_of_sindragosa.enabled|!cooldown.breath_of_sindragosa.remains)
                if isChecked("Horn of Valor") and useCDs() then
                    if buff.pillarOfFrost.exists() and (not talent.breathOfSindragosa or cd.breathOfSindragosa.remain() == 0 or not isChecked("Breath of Sindragosa")) then
                        use.hornOfValor()
                    end
                end
        -- Draught of Souls
                -- use_item,name=draught_of_souls,if=rune.time_to_5<3&(!dot.breath_of_sindragosa.ticking|runic_power>60)
                if isChecked("Draught of Souls") and useCDs() then
                    if runeTimeTill(5) < 3 and (not breathOfSindragosaActive or runicPower > 60) then
                        use.draughtOfSouls()
                    end
                end
        -- Feloiled Infernal Machine
                -- use_item,name=feloiled_infernal_machine,if=!talent.obliteration.enabled|buff.obliteration.up
                if isChecked("Feloiled Infernal Machine") and useCDs() then
                    if not talent.obliteration or buff.obliteration.exists() then
                        use.feloiledInfernalMachine()
                    end
                end
        -- Potion
                -- potion,if=buff.pillar_of_frost.up&(dot.breath_of_sindragosa.ticking|buff.obliteration.up|talent.hungering_rune_weapon.enabled)
                if isChecked("Potion") and useCDs() and raid then 
                    if buff.pillarOfFrost.exists() and (debuff.breathOfSindragosa.exists(units.dyn5) or (talent.breathOfSindragosa and not isChecked("Breath of Sindragosa")) 
                        or buff.obliteration.exists() or talent.hungeringRuneWeapon) 
                    then
                        use.potionOfProlongedPower()
                    end
                end
        -- Pillar of Frost
                if getOptionValue("Pillar of Frost") == 1 or (getOptionValue("Pillar of Frost") == 2 and useCDs()) and getDistance(units.dyn5) < 5 then
                    -- pillar_of_frost,if=talent.obliteration.enabled&(cooldown.obliteration.remains>20|cooldown.obliteration.remains<10|!talent.icecap.enabled)
                    if talent.obliteration and (cd.obliteration.remain() > 20 or cd.obliteration.remain() < 10 or not talent.icecap) then
                        if cast.pillarOfFrost() then return end
                    end
                    -- pillar_of_frost,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.ready&runic_power>50
                    if talent.breathOfSindragosa and cd.breathOfSindragosa.remain() == 0 and isChecked("Break of Sindragosa") and runicPower > 50 then
                        if cast.pillarOfFrost() then return end
                    end
                    -- pillar_of_frost,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>40
                    if talent.breathOfSindragosa and cd.breathOfSindragosa.remain() > 40 then
                        if cast.pillarOfFrost() then return end
                    end
                    -- pillar_of_frost,if=talent.hungering_rune_weapon.enabled
                    if talent.hungeringRuneWeapon then
                        if cast.pillarOfFrost() then return end
                    end
                end
        -- Breath of Sindragosa
                -- breath_of_sindragosa,if=buff.pillar_of_frost.up
                if isChecked("Breath of Sindragosa") and useCDs() then
                    if buff.pillarOfFrost.exists() or (getOptionValue("Pillar of Frost") == 3 and runicPower >= 50 
                        and ((equiped.convergenceOfFates() and cd.hungeringRuneWeapon.remain() < 10) or (not equiped.convergenceOfFates() and (cd.hungeringRuneWeapon.remain() < 15 or ttd("target") > 135))))
                    then
                        if cast.breathOfSindragosa() then return end
                    end
                end
        -- Call Action List - Cold Heart
                -- call_action_list,name=cold_heart,if=equipped.cold_heart&((buff.cold_heart.stack>=10&!buff.obliteration.up)|target.time_to_die<=gcd)
                if useCDs() and equiped.coldHeart() and ((buff.coldHeart.stack() >= 10 and not buff.obliteration.exists()) or ttd(units.dyn5) <= gcd) then
                    if actionList_ColdHeart() then return end
                end
        -- Obliteration
                -- obliteration,if=rune>=1&runic_power>=20&(!talent.frozen_pulse.enabled|rune<2|buff.pillar_of_frost.remains<=12)&(!talent.gathering_storm.enabled|!cooldown.remorseless_winter.ready)&(buff.pillar_of_frost.up|!talent.icecap.enabled)
                if isChecked("Obliteration") and useCDs() then
                    if runes >= 1 and runicPower >= 20 
                        and (not talent.frozenPulse or runes < 2 or buff.pillarOfFrost.remain() <= 12) 
                        and (not talent.gatheringStorm or cd.remorselessWinter.remain() > 0) 
                        and (buff.pillarOfFrost.exists() or not talent.icecap)
                    then
                        if cast.obliteration() then return end
                    end
                end 
            end -- End Use Cooldowns Check
        end -- End Action List - Cooldowns
    -- Action List - Breath of Sindragosa Pooling
        local function actionList_BoS_Pooling()
            profileDebug = "Breath Of Sindragosa - Pooling"
        -- Remorseless Winter
            -- remorseless_winter,if=talent.gathering_storm.enable
            if talent.gatheringStorm and getDistance(units.dyn5) < 5 then
                if cast.remorselessWinter() then return end
            end
        -- Howling Blast
            -- howling_blast,if=buff.rime.react&rune.time_to_4<(gcd*2)
            if buff.rime.exists() and runeTimeTill(4) < (gcd * 2) then
                if cast.howlingBlast() then return end
            end
        -- Obliterate
            -- obliterate,if=rune.time_to_6<gcd&!talent.gathering_storm.enabled
            if runeTimeTill(6) < gcd and not talent.gatheringStorm then
                if cast.obliterate() then return end
            end
            -- obliterate,if=rune.time_to_4<gcd&(cooldown.breath_of_sindragosa.remains|runic_power_deficit>=30)
            if runeTimeTill(4) < gcd and (cd.breathOfSindragosa.remain() > 0 or runicPowerDeficit >= 30) then
                if cast.obliterate() then return end
            end
        -- Frost Strike
            -- frost_strike,if=runic_power.deficit<5&set_bonus.tier19_4pc&cooldown.breath_of_sindragosa.remains&(!talent.shattering_strikes.enabled|debuff.razorice.stack<5|cooldown.breath_of_sindragosa.remains>6)
            if runicPowerDeficit < 5 and t19_4pc and cd.breathOfSindragosa.remain() > 0 and (not talent.shatteringStrikes or debuff.razorice.stack(units.dyn5) < 5 or cd.breathOfSindragosa.remain() > 6) then
                if cast.frostStrike() then return end
            end
        -- Remorseless Winter
            -- remorseless_winter,if=buff.rime.react&equipped.perseverance_of_the_ebon_martyr
            if buff.rime.exists() and equiped.perseveranceOfTheEbonMartyr() and getDistance(units.dyn5) < 5 then
                if cast.remorselessWinter() then return end
            end
        -- Howling Blast
            -- howling_blast,if=buff.rime.react&(buff.remorseless_winter.up|cooldown.remorseless_winter.remains>gcd|(!equipped.perseverance_of_the_ebon_martyr&!talent.gathering_storm.enabled))
            if buff.rime.exists() and (debuff.remorselessWinter.exists(units.dyn5) or cd.remorselessWinter.remain() > gcd or (not equiped.perseveranceOfTheEbonMatyr() and not talent.gatheringStorm)) then
                if cast.howlingBlast() then return end
            end
        -- Obliterate
            -- obliterate,if=!buff.rime.react&!(talent.gathering_storm.enabled&!(cooldown.remorseless_winter.remains>(gcd*2)|rune>4))&rune>3
            if not buff.rime.exists() and not (talent.gatheringStorm and not (cd.remorselessWinter.remain() > (gcd * 2) or runes > 4)) and runes > 3 then
                if cast.obliterate() then return end
            end
        -- Sindragosa's Fury
            -- sindragosas_fury,if=(equipped.consorts_cold_core|buff.pillar_of_frost.up)&buff.unholy_strength.up&debuff.razorice.stack=5
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and #enemies.yards40 >= getOptionValue("Artifact Units") and getFacing("player",units.dyn8) then
                if (equiped.consortsColdCore() or buff.pillarOfFrost.exists()) and buff.unholyStrength.exists() and debuff.razorice.stack(units.dyn5) == 5 then
                    if cast.sindragosasFury() then return end
                end
            end
        -- Frost Strike
            -- frost_strike,if=runic_power.deficit<30&(!talent.shattering_strikes.enabled|debuff.razorice.stack<5|cooldown.breath_of_sindragosa.remains>rune.time_to_4)
            if runicPowerDeficit < 30 and (not talent.shatteringStrikes or debuff.razorice.stack(units.dyn5) < 5 or cd.breathOfSindragosa.remain() > runeTimeTill(4)) then
                if cast.frostStrike() then return end
            end 
        -- Frostscythe
            -- frostscythe,if=buff.killing_machine.up&(!equipped.koltiras_newfound_will|spell_targets.frostscythe>=2)
            if buff.killingMachine.exists() and (not equiped.koltirasNewfoundWill() or ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0))) then
                if cast.frostscythe() then return end
            end
        -- Glacial Advance
            -- glacial_advance,if=spell_targets.glacial_advance>=2
            if ((mode.rotation == 1 and #enemies.yards10 >= getOptionValue("Glacial Advance")) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                if cast.glacialAdvance("player") then return end
            end
        -- Remorseless Winter
            -- remorseless_winter,if=spell_targets.remorseless_winter>=2
            if ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) and getDistance(units.dyn5) < 5 then
                if cast.remorselessWinter() then return end
            end
        -- Frostscythe
            -- frostscythe,if=spell_targets.frostscythe>=3
            if ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                if cast.frostscythe() then return end
            end
        -- Frost Strike
            -- frost_strike,if=(cooldown.remorseless_winter.remains<(gcd*2)|buff.gathering_storm.stack=10)&cooldown.breath_of_sindragosa.remains>rune.time_to_4&talent.gathering_storm.enabled&(!talent.shattering_strikes.enabled|debuff.razorice.stack<5|cooldown.breath_of_sindragosa.remains>6)
            if (cd.remorselessWinter.remain() < (gcd * 2) or buff.gatheringStorm.stack() == 10) 
                and (cd.breathOfSindragosa.remain() > runeTimeTill(4) or not useCDs() or not isChecked("Breath of Sindragosa")) 
                and talent.gatheringStorm and (not talent.shatteringStrikes or debuff.razorice.stack(units.dyn5) < 5 or cd.breathOfSindragosa.remain() > 6) 
            then
                if cast.frostStrike() then return end
            end
        -- Obliterate
            -- obliterate,if=!buff.rime.react&(!talent.gathering_storm.enabled|cooldown.remorseless_winter.remains>gcd)
            if not buff.rime.exists() and (not talent.gatheringStorm or cd.remorselessWinter.remain() > gcd) then
                if cast.obliterate() then return end
            end
        -- Frost Strike
            -- frost_strike,if=cooldown.breath_of_sindragosa.remains>rune.time_to_4&(!talent.shattering_strikes.enabled|debuff.razorice.stack<5|cooldown.breath_of_sindragosa.remains>6)
            if cd.breathOfSindragosa.remain() > runeTimeTill(4) and (not talent.shatteringStrikes or debuff.razorice.stack(units.dyn5) < 5 or cd.breathOfSindragosa.remain() > 6) then
                if cast.frostStrike() then return end
            end
        end
    -- Action List - Breath of Sindragosa Ticking
        local function actionList_BoS_Ticking()
            profileDebug = "Breath Of Sindragosa - Ticking"
        -- Frost Strike
            -- frost_strike,if=talent.shattering_strikes.enabled&runic_power<40&rune.time_to_2>2&cooldown.empower_rune_weapon.remains&debuff.razorice.stack=5&(cooldown.horn_of_winter.remains|!talent.horn_of_winter.enabled)
            if talent.shatteringStrikes and runicPower < 40 and runeTimeTill(2) > 2 and cd.empowerRuneWeapon.remain() > 0 and debuff.razorice.stack(units.dyn5) == 5 and (cd.hornOfWinter.remain() > 0 or not talent.hornOfWinter) then
                if cast.frostStrike() then return end
            end
        -- Remorseless Winter
            -- remorseless_winter,if=runic_power>=30&((buff.rime.react&equipped.perseverance_of_the_ebon_martyr)|(talent.gathering_storm.enabled&(buff.remorseless_winter.remains<=gcd|!buff.remorseless_winter.remains)))
            if runicPower >= 30 and ((buff.rime.exists() and equiped.perseveranceOfTheEbonMartyr()) 
                    or (talent.gatheringStorm and (debuff.remorselessWinter.remain(units.dyn5) <= gcd or not debuff.remorselessWinter.exists(units.dyn5)))) 
                and getDistance(units.dyn5) < 5 
            then
                if cast.remorselessWinter() then return end
            end
        -- Howling Blast
            -- howling_blast,if=((runic_power>=20&set_bonus.tier19_4pc)|runic_power>=30)&buff.rime.react
            if ((runicPower >= 20 and t19_4pc) or runicPower >= 30) and buff.rime.exists() then
                if cast.howlingBlast() then return end
            end
        -- Frost Strike
            -- frost_strike,if=set_bonus.tier20_2pc&runic_power.deficit<=15&rune<=3&buff.pillar_of_frost.up&!talent.shattering_strikes.enabled
            if t20_2pc and runicPowerDeficit <= 15 and runes <= 3 and buff.pillarOfFrost.exists() and not talent.shatteringStrikes then
                if cast.frostStrike() then return end
            end
        -- Obliterate
            -- obliterate,if=runic_power<=45|rune.time_to_5<gcd
            if runicPower <= 45 or runeTimeTill(5) < gcd then
                if cast.obliterate() then return end
            end
        -- Sindragosa's Fury
            -- sindragosas_fury,if=(equipped.consorts_cold_core|buff.pillar_of_frost.up)&buff.unholy_strength.up&debuff.razorice.stack=5
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and #enemies.yards40 >= getOptionValue("Artifact Units") and getFacing("player",units.dyn8) then
                if (equiped.consortsColdCore() or buff.pillarOfFrost.exists()) and buff.unholyStrength.exists() and debuff.razorice.stack(units.dyn5) == 5 then
                    if cast.sindragosasFury() then return end
                end
            end 
        -- Horn of Winter
            -- horn_of_winter,if=runic_power.deficit>=30&rune.time_to_3>gcd
            if runicPowerDeficit >= 30 and runeTimeTill(3) > gcd then
                if cast.hornOfWinter() then return end
            end
        -- Frostscythe
            -- frostscythe,if=buff.killing_machine.up&(!equipped.koltiras_newfound_will|talent.gathering_storm.enabled|spell_targets.frostscythe>=2)
            if buff.killingMachine.exists() and (not equiped.koltirasNewfoundWill() or talent.gatheringStorm or ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0))) then
                if cast.frostscythe() then return end
            end
        -- Glacial Advance
            -- glacial_advance,if=spell_targets.glacial_advance>=2
            if ((mode.rotation == 1 and #enemies.yards10 >= getOptionValue("Glacial Advance")) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                if cast.glacialAdvance("player") then return end
            end
        -- Remorseless Winter
            -- remorseless_winter,if=spell_targets.remorseless_winter>=2
            if ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) and getDistance(units.dyn5) < 5 then
                if cast.remorselessWinter() then return end
            end
        -- Obliterate
            -- obliterate,if=runic_power.deficit>25|rune>3
            if runicPowerDeficit > 25 or runes > 3 then
                if cast.obliterate() then return end
            end
            if isChecked("Empower/Hungering Rune Weapon") and useCDs() then
        -- Empower Rune Weapon
                -- empower_rune_weapon,if=runic_power<30&rune.time_to_2>gcd
                if runicPower < 30 and runeTimeTill(2) > gcd then
                    if cast.empowerRuneWeapon("player") then return end
                end
            end
        end
    -- Action List - Obliteration
        local function actionList_Obliteration()
            profileDebug = "Obliteration"
        -- Remorseless Winter
            -- remorseless_winter,if=talent.gathering_storm.enabled
            if talent.gatheringStorm and getDistance(units.dyn5) < 5 then
                if cast.remorselessWinter() then return end
            end
        -- Frostscythe
            -- frostscythe,if=buff.killing_machine.up&spell_targets.frostscythe>1
            if buff.killingMachine.exists() and ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                if cast.frostscythe() then return end
            end
        -- Obliterate
            -- obliterate,if=buff.killing_machine.up|(spell_targets.howling_blast>=3&!buff.rime.up)
            if buff.killingMachine.exists() or (((mode.rotation == 1 and #enemies.yards10t >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0)) and not buff.rime.exists()) then
                if cast.obliterate() then return end
            end
        -- Howling Blast
            -- howling_blast,if=buff.rime.up&spell_targets.howling_blast>1
            if buff.rime.exists() and ((mode.rotation == 1 and #enemies.yards10t > 1) or (mode.rotation == 2 and #enemies.yards10t > 0)) then
                if cast.howlingBlast() then return end
            end
            -- howling_blast,if=!buff.rime.up&spell_targets.howling_blast>2&rune>3&talent.freezing_fog.enabled&talent.gathering_storm.enabled
            if not buff.rime.exists() and ((mode.rotation == 1 and #enemies.yards10t >= 3) or (mode.rotation == 2 and #enemies.yards10t > 0)) and runes > 3 and talent.freezingFog and talent.gatheringStorm then
                if cast.howlingBlast() then return end
            end
        -- Frost Strike
            -- frost_strike,if=!buff.rime.up|rune.time_to_1>=gcd|runic_power.deficit<20
            if not buff.rime.exists() or runeTimeTill(1) >= gcd or runicPowerDeficit < 20 then
                if cast.frostStrike() then return end
            end
        -- Howling BLast
            -- howling_blast,if=buff.rime.up
            if buff.rime.exists() then
                if cast.howlingBlast() then return end
            end
        -- Obliterate
            if cast.obliterate() then return end
        end -- End Action List - Obliteration
    -- Action List - Standard
        local function actionList_Standard()
            profileDebug = "Standard"
        -- Frost Strike
            -- frost_strike,if=talent.icy_talons.enabled&buff.icy_talons.remains<=gcd
            if talent.icyTalons and buff.icyTalons.remain() <= gcd then
                if cast.frostStrike() then return end
            end
            -- frost_strike,if=talent.shattering_strikes.enabled&debuff.razorice.stack=5&buff.gathering_storm.stack<2&!buff.rime.up
            if talent.shatteringStrikes and debuff.razorice.stack(units.dyn5) == 5 and buff.gatheringStorm.stack() < 2 and not buff.rime.exists() then
                if cast.frostStrike() then return end
            end
        -- Remorseless Winter
            -- remorseless_winter,if=(buff.rime.react&equipped.perseverance_of_the_ebon_martyr)|talent.gathering_storm.enabled
            if (buff.rime.exists() and equiped.perseveranceOfTheEbonMartyr()) or talent.gatheringStorm then
                if cast.remorselessWinter() then return end
            end
        -- Obliterate
            -- obliterate,if=(equipped.koltiras_newfound_will&talent.frozen_pulse.enabled&set_bonus.tier19_2pc=1)|rune.time_to_4<gcd&buff.hungering_rune_weapon.up
            if (equiped.koltirasNewfoundWill() and talent.frozenPulse and t19_2pc) or runeTimeTill(4) < gcd and buff.hungeringRuneWeapon.exists() then
                if cast.obliterate() then return end
            end
        -- Frost Strike
            -- frost_strike,if=(!talent.shattering_strikes.enabled|debuff.razorice.stack<5)&runic_power.deficit<10
            if (not talent.shatteringStrikes or debuff.razorice.stack(units.dyn5) < 5) and runicPowerDeficit < 10 then
                if cast.frostStrike() then return end
            end
        -- Howling Blast
            -- howling_blast,if=buff.rime.react
            if buff.rime.exists() then
                if cast.howlingBlast() then return end
            end
        -- Obliterate
            -- obliterate,if=(equipped.koltiras_newfound_will&talent.frozen_pulse.enabled&set_bonus.tier19_2pc=1)|rune.time_to_5<gcd
            if (equiped.koltirasNewfoundWill() and talent.frozenPulse and t19_2pc) or runeTimeTill(5) < gcd then
                if cast.obliterate() then return end
            end
        -- Sindragosa's Fury
            -- sindragosas_fury,if=(equipped.consorts_cold_core|buff.pillar_of_frost.up)&buff.unholy_strength.up&debuff.razorice.stack=5
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and #enemies.yards40 >= getOptionValue("Artifact Units") and getFacing("player",units.dyn8) then
                if (equiped.consortsColdCore() or buff.pillarOfFrost.exists()) and buff.unholyStrength.exists() and debuff.razorice.stack(units.dyn5) == 5 then
                    if cast.sindragosasFury() then return end
                end
            end
        -- Frost Strike
            -- frost_strike,if=runic_power.deficit<10&!buff.hungering_rune_weapon.up
            if runicPowerDeficit < 10 and not buff.hungeringRuneWeapon.exists() then
                if cast.frostStrike() then return end
            end
        -- Frostscythe
            -- frostscythe,if=buff.killing_machine.up&(!equipped.koltiras_newfound_will|spell_targets.frostscythe>=2)
            if buff.killingMachine.exists() and (not equiped.koltirasNewfoundWill() or ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0))) then
                if cast.frostscythe() then return end
            end
        -- Obliterate
            -- obliterate,if=buff.killing_machine.react
            if buff.killingMachine.exists() then
                if cast.obliterate() then return end
            end
        -- Frost Strike
            -- frost_strike,if=runic_power.deficit<20
            if runicPowerDeficit < 20 then
                if cast.frostStrike() then return end
            end
        -- Remorseless Winter
            -- remorseless_winter,if=spell_targets.remorseless_winter>=2
            if ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) and getDistance(units.dyn5) < 5 then
                if cast.remorselessWinter() then return end
            end
        -- Glacial Advance
            -- glacial_advance,if=spell_targets.glacial_advance>=2
            if ((mode.rotation == 1 and #enemies.yards10 >= getOptionValue("Glacial Advance")) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                if cast.glacialAdvance("player") then return end
            end
        -- Frostscythe
            -- frostscythe,if=spell_targets.frostscythe>=3
            if ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                if cast.frostscythe() then return end
            end
        -- Obliterate
            -- obliterate,if=!talent.gathering_storm.enabled|cooldown.remorseless_winter.remains>(gcd*2)
            if not talent.gatheringStorm or cd.remorselessWinter.remain() > (gcd * 2) then
                if cast.obliterate() then return end
            end
        -- Horn of Winter
            -- horn_of_winter,if=!buff.hungering_rune_weapon.up&(rune.time_to_2>gcd|!talent.frozen_pulse.enabled)
            if not buff.hungeringRuneWeapon.exists() and (runeTimeTill(2) > gcd or not talent.frozenPulse) then
                if cast.hornOfWinter() then return end
            end
        -- Frost Strike
            -- frost_strike,if=!(runic_power<50&talent.obliteration.enabled&cooldown.obliteration.remains<=gcd)
            if not (runicPower < 50 and talent.obliteration and cd.obliteration.remain() <= gcd) then
                if cast.frostStrike() then return end
            end
        -- Obliterate
            -- obliterate,if=!talent.gathering_storm.enabled|talent.icy_talons.enabled
            if not talent.gatheringStorm or talent.icyTalons then
                if cast.obliterate() then return end
            end
        -- Empower Rune Weapon
            -- empower_rune_weapon,if=!talent.breath_of_sindragosa.enabled|target.time_to_die<cooldown.breath_of_sindragosa.remains
            if isChecked("Empower/Hungering Rune Weapon") and useCDs() then
                if not talent.breathOfSindragosa or ttd(units.dyn5) < cd.breathOfSindragosa.remain() or not isChecked("Breath of Sindragosa") then
                    if cast.empowerRuneWeapon() then return end
                end
            end
        end -- End Action List - Standard
    -- Action List - Pre-Combat
        local function actionList_PreCombat()
            profileDebug = "Pre-Combat"
        -- Flask / Crystal
            -- flask,type=flask_of_the_countless_armies
            if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheCountlessArmies.exists() then
                if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                if buff.felFocus.exists() then buff.felFocus.cancel() end
                if use.flaskOfTheCountlessArmies() then return end
            end
            if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() then
                if buff.flaskOfTheCountlessArmies.exists() then buff.flaskOfTheCountlessArmies.cancel() end
                if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                if use.repurposedFelFocuser() then return end
            end
            if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() then
                if buff.flaskOfTheCountlessArmies.exists() then buff.flaskOfTheCountlessArmies.cancel() end
                if buff.felFocus.exists() then buff.felFocus.cancel() end
                if use.oraliusWhisperingCrystal() then return end
            end
        -- Flask / Crystal
            -- flask,name=countless_armies
            if isChecked("Flask / Crystal") and not (IsFlying() or IsMounted()) then
                if (raid or solo) and not (buff.strenthFlaskLow or buff.strengthFlaskBig) then--Draenor Str Flasks
                    if not UnitBuffID("player",176151) and canUse(118922) then --Draenor Insanity Crystal
                        if br.player.useCrystal() then return end
                    end
                end
            end
        -- Food
            -- food,type=food,name=fishbrul_special
        -- Augmentation
            -- augmentation,name=defiled
        -- Potion
            -- potion,name=old_war
        -- Pre-pull
            if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

            end -- Pre-Pull
        -- Start Attack
            if isValidUnit("target") and not inCombat then
                StartAttack()
            end
        end -- End Action List - PreCombat
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or IsFlying() or IsMounted() or pause() or mode.rotation==4 then
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
        -- Combat Start
            if inCombat and profileStop==false and isValidUnit(units.dyn5) then
                profileDebug = "Combat Rotation"
                -- auto_attack
                if getDistance(units.dyn5) < 5 then
                    StartAttack()
                end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    -----------------------------
    --- In Combat - Cooldowns ---
    -----------------------------
                if actionList_Cooldowns() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
        -- BoS_Pooling
                    -- run_action_list,name=bos_pooling,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<15
                    if isChecked("Breath of Sindragosa") and useCDs() and talent.breathOfSindragosa and cd.breathOfSindragosa.remain() < 15 then
                        if actionList_BoS_Pooling() then return end
                    end
        -- BoS_Ticking
                    -- run_action_list,name=bos_ticking,if=dot.breath_of_sindragosa.ticking
                    if debuff.breathOfSindragosa.exists() then
                        if actionList_BoS_Ticking() then return end
                    end
        -- Obliteration
                    -- run_action_list,name=obliteration,if=buff.obliteration.up
                    if buff.obliteration.exists() then
                        if actionList_Obliteration() then return end
                    end
        -- Standard
                    -- call_action_list,name=standard
                    if actionList_Standard() then return end
                end -- End Simc APL
            end -- End Combat Check
        end -- End Rotation Pause
    end -- End Timer
end -- runRotation
local id = 251
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
