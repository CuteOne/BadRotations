local rotationName = "Winstonv8"

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
    --DragonsBreathModes = {
    --    [1] = { mode = "On", value = 1 , overlay = "Legendary Dragonbreath Enabled", tip = "Always use Legendary Dragonbreath.", highlight = 1, icon = br.player.spell.dragonsBreath},
    --    [2] = { mode = "Off", value = 2 , overlay = "Legendary Dragonbreath Disabled", tip = "Let BR decide when to use Legedary Dragonbreath.", highlight = 0, icon = br.player.spell.dragonsBreath}
    --};
    --CreateButton("DragonsBreath",5,0)
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
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  1,  1,  60,  1,  "|cffFFFFFFSet to desired time for test in minuts. Min: 1 / Max: 60 / Interval: 5")
        br.ui:checkSectionState(section)
    -- Pre-Combat Options
        section = br.ui:createSection(br.ui.window.profile, "Pre-Combat")
        -- Auto Buff Arcane Intellect
            br.ui:createCheckbox(section,"Arcane Intellect", "Check to auto buff Arcane Intellect on party.")
        -- Pre-Pot
            br.ui:createCheckbox(section, "Pre-Pot", "|cffFFFFFFCheck to use Pre Pots before Boss Fights.")
        -- Pots
            br.ui:createDropdownWithout(section,"  Pots", {"1-Superior Battle Int","2-Battle Int","3-Unbridled Fury","4-Rising Death","5-None"}, 1, "Set Pot to use.")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  0.1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Opener
            br.ui:createCheckbox(section, "Opener")
        -- Out of Combat Attack
            --br.ui:createCheckbox(section,"Pull OoC", "Check to Engage the Target out of Combat.")
        -- Aditional Fireball Opener if no Crit
        --    br.ui:createCheckbox(section,"  No Crit-Opener", "Check if Pyroblast did not Crit.")
        br.ui:checkSectionState(section)
    -- AoE Options
        section = br.ui:createSection(br.ui.window.profile, "Area of Effect")
        -- AoE Meteor
            br.ui:createSpinner(section, "Meteor Targets",  8,  8,  10,  1, "Max AoE Units to use Meteor on.")
        -- FlameStrike Targets
            br.ui:createSpinnerWithout(section, "Flamestrike Targets",  4,  4,  10,  1, "Unit Count Limit before casting Flamestrike.")
        -- Focused Beam
            br.ui:createSpinnerWithout(section, "Focused Beam Targets",  3,  2,  10,  1, "Unit Count Limit before casting Focused Beam.")
        -- Artifact 
        --    br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Cyclotronic Blast
            br.ui:createCheckbox(section,"Cyclotronic Blast", "Use Cyclotronic Blast on Cooldown.")
        -- Hyperthread Wristwraps
            br.ui:createCheckbox(section,"Hyperthread Wristwraps", "Use Hyperthread Wrist on Cooldown.")
        -- Mirror Image
            br.ui:createCheckbox(section,"Mirror Image")
        -- Shiver Venom Relic
            br.ui:createCheckbox(section,"Shiver Venoms", "Freeze them Shivery Venoms on Cooldown.")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinket 1", "Use Trinket 1 on Cooldown.")
            br.ui:createCheckbox(section,"Trinket 2", "Use Trinket 2 on Cooldown.")
            --br.ui:createCheckbox(section,"Trinkets")
        -- Racial 
            br.ui:createCheckbox(section,"Racial")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
        -- Blast Wave
            br.ui:createSpinner(section, "Blast Wave",  30,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        -- Blazing Barrier
            br.ui:createSpinner(section,"Blazing Barrier", 85, 0, 100, 5,   "|cffFFBB00Health Percentage to use at.")
        -- Frost Nova
            br.ui:createSpinner(section, "Frost Nova",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        -- Ice Block
            br.ui:createSpinner(section, "Ice Block", 15, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")
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
    --if br.timer:useTimer("debugFire", math.random(0.07,0.1)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        --UpdateToggle("DragonsBreath",0.25)
        --br.player.mode.dragonsBreath = br.data.settings[br.selectedSpec].toggles["DragonsBreath"]
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
        local essence                                       = br.player.essence
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or GetUnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
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
        local castin                                        = UnitCastingInfo("player")
        local mrdm                                          = math.random
        local tmoving                                       = isMoving("target")
        local traits                                        = br.player.traits
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local playerCasting                                 = UnitCastingInfo("player")
        local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
        local pullTimer                                     = PullTimerRemain()
        local racial                                        = br.player.getRacial()
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local thp                                           = getHP("target")
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units

        units.get(6)
        units.get(8)
        units.get(10)
        units.get(12)
        units.get(16)
        units.get(25)
        units.get(30)
        units.get(40)
        enemies.get(6)
        enemies.get(8)
        enemies.get(10)
        enemies.get(10, "player", true)
        enemies.get(12)
        enemies.get(16)
        enemies.get(25)
        enemies.get(30)
        enemies.get(40)
        enemies.get(6,"target")
        enemies.get(8,"target")
        enemies.get(10,"target")
        enemies.get(12,"target")
        enemies.get(16,"target")
        enemies.get(25,"target")
        enemies.get(30,"target")
        enemies.get(40,"target")
        
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if talent.kindling then kindle = 1 else kindle = 0 end
        if not talent.kindling then notKindle = 1 else notKindle = 0 end
        if talent.runeOfPower then powerRune = true else runeOfPower = false end

        if co_opn_fblast == nil or not UnitAffectingCombat("player") then co_opn_fblast = false end
        if fballLast == nil or not UnitAffectingCombat("player") then fballLast = false end
        if fblastLast == nil or not UnitAffectingCombat("player") then fblastLast = false end
        if pyroLast == nil or not UnitAffectingCombat("player") then pyroLast = false end
        if scorchLast == nil or not UnitAffectingCombat("player") then scorchLast = false end
        if scorch2Last == nil or not UnitAffectingCombat("player") then scorch2Last = false end
        if teorLast == nil or not UnitAffectingCombat("player") then teorLast = false end
        if pullfball == nil or not UnitAffectingCombat("player") then pullfball = false end
        if pullpyro == nil or not UnitAffectingCombat("player") then pullpyro = false end
        if soloPull == nil or not UnitAffectingCombat("player") then soloPull = true end
        if timedPull == nil or not UnitAffectingCombat("player") then timedPull = false end

        if not inCombat and not GetObjectExists("target") then
            co_opn_fblast = false
            fballLast = false
            fblastLast = false
            pyroLast = false
            scorchLast = false
            scorch2Last = false
            teorLast = false
            pullfball = false
            pullpyro = false
            soloPull = true
            timedPull = false
            opener = false
            OPN1 = false
            OPN2 = false
            OPN3 = false
            OPN4 = false
            OPN5 = false
            OPN6 = false
        end

        --if #enemies.yards40 == 1 then singleEnemy = 1 else singleEnemy = 0 end
        
        --local activeEnemies = #enemies.yards40

        --local fSEnemies = getEnemies(units.dyn40, 8, true)
        local fSEnemies = #enemies.yards8t
        local dBEnemies = getEnemies(units.dyn12, 6, true)

        local firestarterActive = talent.firestarter and thp > 90
        local firestarterInactive = thp < 90 or isDummy()
        
        local lucisDreams = essence.memoryOfLucidDreams.active
        local focusedBeam = essence.focusedAzeriteBeam.active
        local pyroReady = cast.time.pyroblast() == 0 --and br.timer:useTimer("pyroReady", 0.56)
        local hotterStreak = buff.hotStreak.exists() and buff.hotStreak.remain() > 10
        local heatsUp = buff.heatingUp.exists() and buff.heatingUp.remain() > 4
        
        local nofS = fSEnemies < getOptionValue("Flamestrike Targets")

        --[[local function ttd(unit)
            if UnitIsPlayer(unit) then return 999 end
            local ttdSec = getTTD(unit)
            if getOptionCheck("Enhanced Time to Die") then return ttdSec end
            if ttdSec == -1 then return 999 end
            return ttdSec
        end--]]

        local function ttd(unit)
            local ttdSec = getTTD(unit)
            if getOptionCheck("Enhanced Time to Die") then
                return ttdSec
            end
            if ttdSec == -1 then
                return 999
            end
            return ttdSec
        end

        local function firestarterRemain(unit, pct)
            if not GetObjectExists(unit) then return -1 end
            if not string.find(unit,"0x") then unit = ObjectPointer(unit) end
            if getOptionCheck("Enhanced Time to Die") and getHP(unit) > pct and br.unitSetup.cache[unit] ~= nil then
                return br.unitSetup.cache[unit]:unitTtd(pct)
            end
            return -1
        end



        local firestarterremain = firestarterRemain("target", 90)
        local cdMeteorDuration = 45 --select(2,GetSpellCooldown(spell.meteor))
        local fblastCDduration = select(2,GetSpellCooldown(spell.fireBlast))
        local pblastcasttime = cast.time.pyroblast()

        if traits.blasterMaster then bMasterFBCD = fblastCDduration else bMasterFBCD = 0 end

        --# This variable sets the time at which Rune of Power should start being saved for the next Combustion phase
        --actions.precombat+=/variable,name=combustion_rop_cutoff,op=set,value=60
        local combustionROPcutoff = 60
        
        --variable,name=phoenix_pooling,value=talent.rune_of_power.enabled&cooldown.rune_of_power.remains<cooldown.phoenix_flames.full_recharge_time&cooldown.combustion.remains>variable.combustion_rop_cutoff&(cooldown.rune_of_power.remains<target.time_to_die|action.rune_of_power.charges>0)|cooldown.combustion.remains<action.phoenix_flames.full_recharge_time&cooldown.combustion.remains<target.time_to_die
        local phoenixPool = talent.runeOfPower and cd.runeOfPower.remain() < charges.phoenixsFlames.timeTillFull() and cd.combustion.remain() > combustionROPcutoff and (cd.runeOfPower.remain() < ttd("target") or charges.runeOfPower.count() > 0) or cd.combustion.remain() < charges.phoenixsFlames.timeTillFull() and cd.combustion.remain() < ttd("target")

        --variable,name=fire_blast_pooling,value=talent.rune_of_power.enabled&cooldown.rune_of_power.remains<cooldown.fire_blast.full_recharge_time&(cooldown.combustion.remains>variable.combustion_rop_cutoff|firestarter.active)&(cooldown.rune_of_power.remains<target.time_to_die|action.rune_of_power.charges>0)|cooldown.combustion.remains<action.fire_blast.full_recharge_time+cooldown.fire_blast.duration*azerite.blaster_master.enabled&!firestarter.active&cooldown.combustion.remains<target.time_to_die|talent.firestarter.enabled&firestarter.active&firestarter.remains<cooldown.fire_blast.full_recharge_time+cooldown.fire_blast.duration*azerite.blaster_master.enabled
        local fireBlastPool = talent.runeOfPower and cd.runeOfPower.remain() < charges.fireBlast.timeTillFull() and (cd.combustion.remain() > combustionROPcutoff or firestarterActive) and (cd.runeOfPower.remain() < ttd("target") or charges.runeOfPower.count() > 0) or cd.combustion.remain() < bMasterFBCD and (not firestarterActive and cd.combustion.remain() < ttd("target")) or talent.firestarter and firestarterActive and firestarterremain < bMasterFBCD --then

        if timersTable then
             wipe(timersTable)
        end

        --Clear last cast table ooc to avoid strange casts
        if not inCombat and #br.lastCast.tracker > 0 then
            wipe(br.lastCast.tracker)
        end

        if inCombat and not buff.hotStreak.exists() and not buff.pyroclasm.exists() and not buff.heatingUp.exists() and (lucisDreams and not buff.memoryOfLucidDreams.exists()) and not pyroReady then
            if cast.current.pyroblast() then
            if br.timer:useTimer("hc stop Delay", 0.32 / (1 + GetHaste() / 100)) then
            --CancelPendingSpell()
            SpellStopCasting()
            ChatOverlay("no hardcast allowed!")
        return true end end end

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
            -- Arcane Intellect
                    if isChecked("Arcane Intellect") and br.timer:useTimer("AI Delay", 1) then
                        for i = 1, #br.friend do
                            if not buff.arcaneIntellect.exists(br.friend[i].unit,"any") and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                                if cast.arcaneIntellect() then return true end
                            end
                        end
                    end
        end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
            if useDefensive() then
        -- Pot/Stoned
                if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned") 
                    and inCombat and (hasHealthPot() or hasItem(5512)) 
                then
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(healPot) then
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
                if isChecked("Frost Nova") and php <= getOptionValue("Frost Nova") and #enemies.yards10 > 0 then
                    if cast.frostNova("player","aoe",1,10) then return end --Print("fs") return end
                end
        -- Blast Wave
            if talent.blastWave and isChecked("Blast Wave") and php <= getOptionValue("Blast Wave") then
                for i = 1, #enemies.yards10 do
                    local thisUnit = enemies.yards10[i]
                    if #enemies.yards10 > 1 and hasThreat(thisUnit) then
                        if cast.blastWave("player","aoe",1,10) then return end
                    end
                end
            end
        -- Blazing Barrier
                if isChecked("Blazing Barrier") and php <= getOptionValue("Blazing Barrier") and not buff.blazingBarrier.exists() and not isCastingSpell(spell.fireball) and not buff.hotStreak.exists() and not buff.heatingUp.exists() then
                    if cast.blazingBarrier("player") then return end
                end
        -- Iceblock
                if isChecked("Ice Block") and php <= getOptionValue("Ice Block") then
                    if UnitCastingInfo("player") then
                        RunMacroText('/stopcasting')
                    end
                    if cast.iceBlock("player") then
                        return true
                    end
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
                if isChecked("Trinket 1") and canUseItem(13) then
                        useItem(13)
                        return true
                end
                if isChecked("Trinket 2") and canUseItem(14) then
                        useItem(14)
                        return true
                end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury | berserking | arcane_torrent
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "Blood Elf") then
                    if castSpell("player",racial,false,false,false) then return end
                end
            end -- End useCDs check
        end -- End Action List - Cooldowns
    -- Action List - Opener
        local function actionList_Opener()
            if isChecked("Opener") --[[and (isBoss("target") or isDummy("target"))]] and opener == false then
                if isValidUnit("target") and getDistance("target") < 40 then
                    if not OPN1 then
                        Print("Starting Opener")
                        OPN1 = true

                    elseif OPN1 and not OPN2 then
                        if not cast.last.fireball() and not moving then
                            if castOpener("fireball","OPN2",1) then return end
                        end

                    elseif OPN2 and not OPN3 then
                        if lucisDreamsand then
                            if castOpener("memoryOfLucidDreams","OPN3",2) then return end
                        elseif not lucisDreams then
                            OPN3 = true
                        end

                    elseif OPN3 and not OPN4 then
                        if buff.heatingUp.exists() then
                            if castOpener("fireBlast","OPN4",3) then return end
                        elseif not buff.heatingUp.exists() and not buff.hotStreak.exists() then
                            OPN4 = true
                        end

                    elseif OPN4 and not OPN5 then
                        if talent.runeOfPower then
                            if castOpener("runeOfPower","OPN5",4) then return end
                        elseif not talent.runeOfPower then
                            OPN5 = true
                        end

                    elseif OPN5 and not OPN6 then
                            if castOpener("combustion","OPN6",5) then return end

                    elseif OPN6 and not OPN7 then
                        if not cast.last.fireBlast() then
                            if castOpener("fireBlast","OPN7",6) then return end
                        end

                    elseif OPN7 then
                        opener = true;
                        Print("Opener Complete")
                        return
                    end
                end
            elseif (UnitExists("target") and (not isBoss("target") or not isDummy("target"))) or not isChecked("Opener") then
            	opener = true
            	return
            end
        end -- End Action List - Opener
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
                if isChecked("Pre-Pull Timer") and (inInstance or inRaid) --[[and isValidUnit("target"))]] or isDummy() then --and pullTimer <= getOptionValue("Pre-Pull Timer") then

                    if pullTimer <= getOptionValue("Pre-Pull Timer") * gcdMax then

                    --potion,name=Int_power
                        if isChecked("Pre-Pot") and not solo or isDummy() then
                            if getOptionValue("  Pots") == 1 and canUseItem(168498) then
                                useItem(168498)
                            elseif getOptionValue("  Pots") == 2 and canUseItem(163222) then
                                useItem(163222)
                            elseif getOptionValue("  Pots") == 3 and canUseItem(169299) then
                                useItem(169299)
                            elseif getOptionValue("  Pots") == 4 and canUseItem(152559) then
                                useItem(152559)
                            end
                        end

                    -- Opener Sequence
                        if actionList_Opener() then return end

                        if opener == true then
                            timedPull = true
                        elseif opener == false then
                            soloPull = true
                        end

                    end

                elseif solo or not isChecked("Pre-Pull Timer") or (not inInstance and not inRaid) then
                   soloPull = true

                end -- End Pre-Pull
            end -- End No Combat
        end -- End Action List - PreCombat
    -- Action List - Active Talents
        local function actionList_ActiveTalents()
        -- Meteor
            -- meteor,if=buff.rune_of_power.up&(firestarter.remains>cooldown.meteor.duration|!firestarter.active)|cooldown.rune_of_power.remains>target.time_to_die&action.rune_of_power.charges<1|(cooldown.meteor.duration<cooldown.combustion.remains|cooldown.combustion.ready)&!talent.rune_of_power.enabled&(cooldown.meteor.duration<firestarter.remains|!talent.firestarter.enabled|!firestarter.active)
            if useCDs() and not firestarterActive and not tmoving then
                if buff.runeOfPower.exists() and (firestarterremain > cdMeteorDuration or not firestarterActive) or cd.runeOfPower.remain() > ttd("target") and charges.runeOfPower.count() < 1 or (cd.combustion.remain() > cdMeteorDuration or cd.combustion.remain() == 0) and not talent.runeOfPower and (firestarterremain > cdMeteorDuration or not firestarterActive) then
                    --if cast.meteor("target",nil,1,8,spell.meteor) then
                    if createCastFunction("best", false, 1, 8, spell.meteor, nil, false, 0) then teorLast = true
                        --Print("Talents Meteor")
                        return true end
                end
            end
        -- Living Bomb
            -- living_bomb,if=active_enemies>1&buff.combustion.down&(cooldown.combustion.remains>cooldown.living_bomb.duration|cooldown.combustion.ready)
           --  if ((#enemies.yards10t >= 1 and mode.rotation == 1) or mode.rotation == 2) and not buff.combustion.exists() then
            if ((#enemies.yards10t > 1 and mode.rotation == 1) or mode.rotation == 2) and not buff.combustion.exists() and (cd.combustion.remain() > getSpellCD(spell.livingBomb) or cd.combustion.remain() == 0) then
                if cast.livingBomb("target") then return end
            end
        end -- End Active Talents Action List

    -- Action List - Blaster Master Combustion Phase
        local function actionList_BMCombustionPhase()
        -- Living Bomb
            -- living_bomb,if=buff.combustion.down&active_enemies>1
           --  if ((#enemies.yards10t >= 1 and mode.rotation == 1) or mode.rotation == 2) and not buff.combustion.exists() then
            if not buff.combustion.exists() and ((#enemies.yards6t >= 1 and mode.rotation == 1) or mode.rotation == 2) then
                if cast.livingBomb("target") then return end
            end
        -- Rune of Power
            -- rune_of_power,if=buff.combustion.down
            if not moving and not buff.combustion.exists() then 
                if cast.runeOfPower("player") then return end
            end
        -- Fireblast
            -- fire_blast,use_while_casting=1,if=buff.blaster_master.down&(talent.rune_of_power.enabled&action.rune_of_power.executing&action.rune_of_power.execute_remains<0.6|(cooldown.combustion.ready|buff.combustion.up)&
            -- !talent.rune_of_power.enabled&!action.pyroblast.in_flight&!action.fireball.in_flight)
            if not buff.blasterMaster.exists() and (talent.runeOfPower and cast.current.runeOfPower() and getCastTimeRemain("player") < 0.6 or (buff.combustion.remain() == 0 or buff.combustion.exists()) and
               not talent.runeOfPower and not cast.inFlight.pyroblast() and not cast.inFlight.fireball()) then
                if cast.fireBlast("target") then 
                    --Print("BfA BM Co fblast1") 
                   return true
                end
            end
        -- Call Action List - Active Talents
            -- call_action_list,name=active_talents
            if traits.blasterMaster.active then
                if actionList_ActiveTalents() then
                    --Print("BfA BM Comb Talents")
                 return end
            end
        -- Combustion
            -- combustion,use_off_gcd=1,use_while_casting=1,if=azerite.blaster_master.enabled&((action.meteor.in_flight&action.meteor.in_flight_remains<0.2)|!talent.meteor.enabled|prev_gcd.1.meteor)&(buff.rune_of_power.up|!talent.rune_of_power.enabled)
            --if (talent.meteor and cd.meteor.remain() <= mrdm(43,43.2) and cd.meteor.remain() > gcdMax) and (buff.runeOfPower.exists() or not talent.runeOfPower) or not talent.meteor then
            if cast.able.combustion() and (talent.meteor and cast.inFlight.meteor() or not talent.meteor or cast.last.meteor()) and (buff.runeOfPower.exists() or not talent.runeOfPower) then
                if cast.combustion("player") then
                    --Print("BM TeorComb")
                    return 
                end
            end
        -- Call Action List - Cooldowns
            if actionList_Cooldowns() then return end
        -- Pyroblast
            -- pyroblast,if=prev_gcd.1.scorch&buff.heating_up.up
            if cast.last.scorch() and buff.heatingUp.exists() and pyroReady then
                if cast.pyroblast("target") then --pyroLast = true
                    --Print("BfA BM Co Pyro1") 
                    return true 
                end
            end
        -- Pyroblast
            -- pyroblast,if=buff.pyroclasm.react&cast_time<buff.combustion.remains 
            -- pyroblast,if=buff.hot_streak.up
            if (buff.pyroclasm.react() and cast.time.pyroblast() < buff.combustion.remain()) or buff.hotStreak.exists() then
                if cast.pyroblast("target") then --pyroLast = true
                    --Print("BfA BM Co Pyro2")
                   return
                end
            end
        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.up
            if buff.hotStreak.exists() then
                if cast.pyroblast("target") then --pyroLast = true
                    --Print("BfA BM Co Pyro3")
                   return
                end
            end
        -- Phoenix's Flames
            -- phoenixs_flames
            if buff.combustion.exists() and not buff.hotStreak.exists() and charges.phoenixsFlames.count() > 1 then
                if cast.phoenixsFlames("target") then return end
            end
         -- Fire Blast
            -- fire_blast,use_off_gcd=1,if=buff.blaster_master.stack=1&buff.hot_streak.down&!buff.pyroclasm.react&prev_gcd.1.pyroblast&(buff.blaster_master.remains<0.15|gcd.remains<0.15)
            if --[[cd.meteor.remain() ~= 45 and--]] buff.blasterMaster.stack() == 1 and not buff.hotStreak.exists() and not buff.pyroclasm.exists() and cast.last.pyroblast() and (buff.blasterMaster.remain() <= 0.15 or cd.fireBlast.remain() < 0.25) then
                if cast.fireBlast("target") then 
                    --Print("BfA BM Co fblast2") 
                   return true
                end
            end
         -- Fire Blast
            -- fire_blast,use_while_casting=1,if=buff.blaster_master.stack=1&(action.scorch.executing&action.scorch.execute_remains<0.15|buff.blaster_master.remains<0.15)
            if --[[cast.able.fireBlast() and]] buff.blasterMaster.stack() == 1 and (cast.current.scorch() and getCastTimeRemain("player") < 0.15 or buff.blasterMaster.remain() <= 0.25) then
                if cast.fireBlast("target") then 
                    --Print("BfA BM Co fblast3") 
                   return true
                end
            end
        -- Scorch
            -- scorch,if=buff.combustion.remains>cast_time&&buff.combustion.up|buff.combustion.down
            if --[[not buff.heatingUp.exists() and]] not buff.hotStreak.exists() or charges.fireBlast.frac() < 1.3 or cast.time.scorch() > buff.combustion.remain() and buff.combustion.exists() or not buff.combustion.exists() then --cd.combustion.remain() ~= 110 then
                if cast.scorch("target") then --scorchLast = true
                    --Print("BfA BM Co scor1") 
                    return true 
                end
            end
         -- Fire Blast
            -- fire_blast,use_while_casting=1,use_off_gcd=1,if=buff.blaster_master.stack>1&(prev_gcd.1.scorch&!buff.hot_streak.up&!action.scorch.executing|buff.blaster_master.remains<0.15)
            if --[[cast.able.fireBlast() and]] buff.blasterMaster.stack() > 1 and (cast.last.scorch() and not buff.hotStreak.exists() and not cast.current.scorch() or buff.blasterMaster.remain() <= 0.25) then
                if cast.fireBlast("target") then 
                    --Print("BfA BM Co fblast4") 
                   return true
                end
            end
        -- Living Bomb
            -- living_bomb,if=active_enemies>1&buff.combustion.down
           --  if ((#enemies.yards10t >= 1 and mode.rotation == 1) or mode.rotation == 2) and not buff.combustion.exists() then
            if (buff.combustion.remain() < gcdMax) and ((#enemies.yards6t >= 1 and mode.rotation == 1) or mode.rotation == 2) then
                if cast.livingBomb("target") then return end
            end
        -- Dragon's Breath
            -- dragons_breath,if=buff.combustion.remains<gcd.max
            if (getFacing("player",units.dyn8,30) and (buff.combustion.remain() < gcdMax) and buff.combustion.exists() and getDistance(units.dyn8) <= 8) then
                if cast.dragonsBreath("player","cone",1,10) then return end --Print("db2") return end
              elseif not buff.hotStreak.exists() then
                if (getDistance(units.dyn8) <= 8) and talent.alexstraszasFury then
                    if cast.dragonsBreath("player","cone",1,10) then return end --Print("db3") return end
                end
            end
        -- Fireblast
            if cast.last.combustion(1) and not buff.heatingUp.exists() and not pyroReady and not bmco_opn_fblast then
                --if br.timer:useTimer("cofblastwait", 0.56) then
                    if cast.fireBlast() then  bmco_opn_fblast = true
                        --Print("BfA BM Co fblast1.5") 
                    return true
                    end
                --end
            end
        -- Scorch
            -- scorch,if=target.health.pct<=30&talent.searing_touch.enabled
            -- if getHP("target") <= 30 and talent.searingTouch then
            --     if cast.scorch("target") then --scorchLast = true
            --         --Print("BfA BM Co scor2") 
            --         return 
            --     end
            -- end
            if IsMovingTime(mrdm(40,80)/100) then
                if cast.scorch("target") then
                    --Print("BM CO sco")
                return end
            end
        end -- End Blaster Master Combustion Phase Action List
    -- Action List - Combustion Phase
        local function actionList_CombustionPhase()
        -- Call Action List - Blaster Master Comb Phase
            -- call_action_list,name=bm_combustion_phase,if=azerite.blaster_master.enabled&talent.flame_on.enabled&!essence.memory_of_lucid_dreams.enabled
            -- if traits.blasterMaster.active and not lucisDreams then --talent.flameOn then
            --     if actionList_BMCombustionPhase() then --[[Print("bm comb phase")]] return end
            -- end
        --Lucid Dreams
            --memory_of_lucid_dreams
            -- if lucisDreams and cast.able.memoryOfLucidDreams() and (talent.runeOfPower and buff.runeOfPower.exists()) then 
            --     if cast.memoryOfLucidDreams("player") then --[[Print("Lucid")--]] return end
            -- elseif lucisDreams and cast.able.memoryOfLucidDreams() and not talent.runeOfPower then 
            --     if cast.memoryOfLucidDreams("player") then --[[Print("Lucid")--]] return end
            -- end
        --Hyperthread Wristwraps
            -- use_item,name=hyperthread_wristwraps,if=buff.combustion.up&action.fire_blast.charges_fractional<1.2
            if hasItem(168989) and isChecked("Hyperthread Wristwraps") then
                if buff.combustion.exists() and charges.fireBlast.frac() < 1.2 then
                    if canUseItem(168989) then
                        useItem(168989)
                    end
                end
            end            
        -- Rune of Power
            -- rune_of_power,if=buff.combustion.down
            if not moving and not buff.combustion.exists() then 
                if cast.runeOfPower("player") then return end
            end
        -- Call Action List - Active Talents
            -- call_action_list,name=active_talents,if=(azerite.blaster_master.enabled&buff.blaster_master.stack>=3)|!azerite.blaster_master.enabled
            if (traits.blasterMaster.active and buff.blasterMaster.stack() >= 3) or not traits.blasterMaster.active then
                --if br.timer:useTimer("coteorwait", 0.7) then
                    if actionList_ActiveTalents() then teorLast = true
                    --Print("BfA Comb Talents")
                    return
                    end
                --end
            end
            if teorLast and cast.inFlight.meteor() and buff.heatingUp.exists() then
                if cast.fireBlast("target") then 
                    --Print("BfA Co fblasteor") 
                   return true
                end
            elseif teorLast and cast.inFlight.meteor() and buff.hotStreak.exists() then
                if cast.pyroblast("target") then 
                    --Print("BfA Co Pyroteor")
                   return
                end
            end
        -- Combustion
            -- combustion,use_off_gcd=1,use_while_casting=1,if=!essence.memory_of_lucid_dreams.enabled&(!azerite.blaster_master.enabled|!talent.flame_on.enabled)&((action.meteor.in_flight&action.meteor.in_flight_remains<=0.5)|!talent.meteor.enabled)&(buff.rune_of_power.up|!talent.rune_of_power.enabled)
            if cast.able.combustion() and not lucisDreams and (not traits.blasterMaster.active or not talent.flameOn) and (talent.meteor and cast.inFlight.meteor()) and (buff.runeOfPower.exists() or not talent.runeOfPower) or not talent.meteor then
                if cast.combustion("player") then
                        --Print("TeorComb")
                    return 
                end
            end
        -- Combustion
           -- combustion,use_off_gcd=1,use_while_casting=1,if=essence.memory_of_lucid_dreams.enabled&(buff.rune_of_power.up|!talent.rune_of_power.enabled)
            if cast.able.combustion() and lucisDreams and (buff.runeOfPower.exists() or not talent.runeOfPower) then -- or not talent.meteor then
                if cast.combustion("player") then
                        --Print("Lucis TeorComb")
                    return 
                end
            end
        -- Call Action List - Cooldowns
            if actionList_Cooldowns() then return end
        -- Flamestrike
            -- flamestrike,if=((talent.flame_patch.enabled&active_enemies>2)|active_enemies>6)&buff.hot_streak.react - #enemies.yards8t - #fSEnemies
            if buff.hotStreak.react() and ((talent.flamePatch and fSEnemies > 2) or (fSEnemies >= getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) then
                --if br.timer:useTimer("cofswait", 0.7) then
                    if cast.flamestrike("best",nil,1,8) then
                    --Print("BfA Co fStrike")
                    return end
            --[[elseif ((#fSEnemies >= getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) and buff.hotStreak.exists() and not talent.pyromaniac then
                if cast.flamestrike("best",nil,1,8) then return end--]]
                --end
            end
        -- Pyroblast
            -- pyroblast,if=buff.pyroclasm.react&buff.combustion.remains>cast_time 
            if buff.pyroclasm.react() and buff.combustion.remain() > cast.time.pyroblast() then
                if cast.pyroblast("target") then 
                    --Print("BfA Co Pyro1")
                   return
                end
            end
        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.up
            if hotterStreak then
                if cast.pyroblast("target") then 
                    --Print("BfA Co Pyro2")
                   return
                end
            end
        -- Fire Blast
            -- fire_blast,use_off_gcd=1,use_while_casting=1,if=essence.memory_of_lucid_dreams.enabled&((buff.combustion.up&(buff.heating_up.react&!action.pyroblast.in_flight&!action.scorch.executing)|
            -- (action.scorch.execute_remains&buff.heating_up.down&buff.hot_streak.down&!action.pyroblast.in_flight)))
            if lucisDreams and ((buff.combustion.exists() and (buff.heatingUp.exists() and not cast.inFlight.pyroblast() and not cast.current.scorch())
            or (cast.current.scorch() and not buff.heatingUp.exists() and not buff.hotStreak.exists() and not cast.inFlight.pyroblast()))) then
                if cast.fireBlast("target") then 
                    --Print("BfA Co fblast1") 
                   return true
                end
            end
        -- Fire Blast
            -- fire_blast,use_off_gcd=1,use_while_casting=1,if=!essence.memory_of_lucid_dreams.enabled&(!azerite.blaster_master.enabled|!talent.flame_on.enabled)&((buff.combustion.up&(buff.heating_up.react&!action.pyroblast.in_flight&!action.scorch.executing)|
            -- (action.scorch.execute_remains&buff.heating_up.down&buff.hot_streak.down&!action.pyroblast.in_flight)))
            if not lucisDreams and (not traits.blasterMaster.active or not talent.flameOn) and ((buff.combustion.exists() and (buff.heatingUp.exists() and not cast.inFlight.pyroblast() and not cast.current.scorch()) 
            or (cast.current.scorch() and not buff.heatingUp.exists() and not buff.hotStreak.exists() and not cast.inFlight.pyroblast()))) then
                if cast.fireBlast("target") then 
                    --Print("BfA Co fblast2") 
                   return true
                end
            end
        -- Pyroblast
            -- pyroblast,if=prev_gcd.1.scorch&buff.heating_up.up
            if cast.last.scorch() and heatsUp or pyroReady then --and talent.searingTouch and thp < 30 then
                if cast.pyroblast("target") then 
                    --Print("BfA Co Pyro3") 
                    return true 
                end
            -- elseif cast.last.scorch(2) and buff.hotStreak.exists() then
            --     if cast.pyroblast("target") then 
            --         Print("BfA Co Pyro3.5") 
            --         return true 
            --     end
            end
        -- Phoenix's Flames
            -- phoenixs_flames
            if buff.combustion.exists() and not buff.hotStreak.exists() and charges.phoenixsFlames.count() > 1 then
               if cast.phoenixsFlames("target") then return end
           end
        -- Scorch
            -- scorch,if=buff.combustion.remains>cast_time&&buff.combustion.up|buff.combustion.down
            if lucisDreams then
                if not buff.memoryOfLucidDreams.exists() and not buff.heatingUp.exists() and not buff.hotStreak.exists() or charges.fireBlast.frac() < 1.3 or buff.combustion.remain() > cast.time.scorch() --[[or cast.time.scorch() > buff.memoryOfLucidDreams.remain()]] --[[or cd.combustion.remain() > gcdMax]] or not buff.combustion.exists() then
                    if cast.scorch("target") then --scorchLast = true
                        --Print("BfA Co Lu scor1") 
                        return true 
                    end
                end
            elseif not lucisDreams then
                if buff.combustion.exists() and buff.combustion.remain() > cast.time.scorch() and not buff.heatingUp.exists() or charges.fireBlast.frac() < 1.3 and not buff.hotStreak.exists() or not buff.combustion.exists() --[[and cd.combustion.remain() > gcdMax--]] then
                    if cast.scorch("target") then 
                        --Print("BfA Co nolu scor1") 
                        return true 
                    end
                end
            end
        -- Living Bomb
            -- living_bomb,if=buff.combustion.remains<gcd.max&active_enemies>1
           --  if ((#enemies.yards10t >= 1 and mode.rotation == 1) or mode.rotation == 2) and not buff.combustion.exists() then
            if (buff.combustion.remain() < gcdMax) and ((#enemies.yards6t >= 1 and mode.rotation == 1) or mode.rotation == 2) then
                if cast.livingBomb("target") then return end
            end
        -- Dragon's Breath
            -- dragons_breath,if=buff.combustion.remains<gcd.max&buff.combustion.up
            if (getFacing("player",units.dyn8,30) and (buff.combustion.remain() < gcdMax) and buff.combustion.exists() and getDistance(units.dyn8) <= 8) then
                if cast.dragonsBreath("player","cone",1,10) then return end --Print("db2") return end
              elseif not buff.hotStreak.exists() then
                if (getDistance(units.dyn8) <= 8) and talent.alexstraszasFury then
                    if cast.dragonsBreath("player","cone",1,10) then return end --Print("db3") return end
                end
            end
        -- Fireblast
            if cast.last.combustion(1) or cast.last.memoryOfLucidDreams() and buff.memoryOfLucidDreams.exists() and not buff.heatingUp.exists() and not pyroReady then --and not co_opn_fblast then
                --if br.timer:useTimer("cofblastwait", 0.56) then
                    if cast.fireBlast() then co_opn_fblast = true
                        --Print("BfA Co fblast1.5") 
                    return true
                    end
                --end
            end
        -- Scorch
            -- scorch,if=target.health.pct<=30&talent.searing_touch.enabled
            if getHP("target") <= 30 and talent.searingTouch and not buff.hotStreak.exists() then
                if cast.scorch("target") then --scorchLast = true
                    --Print("BfA Co scor2") 
                    return 
                end
            end
        end -- End Combustion Phase Action List
    -- Action List - ROP Phase
        local function actionList_ROPPhase()
        -- Rune of Power
            -- rune_of_power
            if not moving then --and useCDs() then
                if cast.runeOfPower("player") then 
                    --Print("BfA RoP rop") 
                    return 
                end
            end
        -- Flamestrike
            -- flamestrike,if=((talent.flame_patch.enabled&active_enemies>1)|active_enemies>4)&buff.hot_streak.react
            if buff.hotStreak.react() and ((talent.flamePatch and fSEnemies > 1) or (fSEnemies > getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) then
                if cast.flamestrike("best",nil,1,8) then
                    --Print("BfA RoP fStrike 1")
                    return end
            end
        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.react
            if hotterStreak then
                if cast.pyroblast("target") then 
                    --Print("BfA RoP Pyro1") 
                    return true 
                end
            end
        -- Fire Blast
            -- fire_blast,use_off_gcd=1,use_while_casting=1,if=(cooldown.combustion.remains>0|firestarter.active&buff.rune_of_power.up)&(!buff.heating_up.react&!buff.hot_streak.react&!prev_off_gcd.fire_blast&
            -- (action.fire_blast.charges>=2|(action.phoenix_flames.charges>=1&talent.phoenix_flames.enabled)|(talent.alexstraszas_fury.enabled&cooldown.dragons_breath.ready)|(talent.searing_touch.enabled&target.health.pct<=30)|
            -- (talent.firestarter.enabled&firestarter.active)))
            if (cd.combustion.remain() >= 0 or firestarterActive and buff.runeOfPower.exists()) and (not buff.heatingUp.exists() and not buff.hotStreak.exists() and not cast.last.fireBlast() and
            (charges.fireBlast.count() >= 2 or (talent.phoenixsFlames and charges.phoenixsFlames.count() >= 1) or (talent.alexstraszasFury and cd.dragonsBreath.remain() == 0) or
            (talent.searingTouch and thp <= 30) or (talent.firestarter and firestarterActive))) then
               if cast.fireBlast("target") then --fblastLast = true
                    --Print("BfA RoP fBlast1") 
                    return true 
                end
            end
        -- Call Action List - Active Talents
            -- call_action_list,name=active_talents
            if actionList_ActiveTalents() then return end
        -- Pyroblast
            -- pyroblast,if=buff.pyroclasm.react&cast_time<buff.pyroclasm.remains&buff.rune_of_power.remains>cast_time
            if talent.pyroclasm and buff.pyroclasm.exists() and cast.time.pyroblast() < buff.pyroclasm.remain() and buff.runeOfPower.remain() > cast.time.runeOfPower() then
                if cast.pyroblast("target") then 
                    --Print("BfA RoP Pyro2") 
                    return true 
                end
            end
        -- Fire Blast
            -- fire_blast,use_off_gcd=1,use_while_casting=1,if=(cooldown.combustion.remains>0|firestarter.active&buff.rune_of_power.up)&(buff.heating_up.react&(target.health.pct>=30|!talent.searing_touch.enabled)) 
            if (cd.combustion.remain() >= 0 or firestarterActive and buff.runeOfPower.exists()) and (buff.heatingUp.exists() and (thp >= 30 or not talent.searingTouch)) then
                if cast.fireBlast("target") then --fblastLast = true
                    --Print("BfA RoP fBlast2") 
                    return true 
                end
            end
        -- Fire Blast
            -- fire_blast,use_off_gcd=1,use_while_casting=1,if=(cooldown.combustion.remains>0|firestarter.active&buff.rune_of_power.up)&talent.searing_touch.enabled&target.health.pct<=30&
            -- (buff.heating_up.react&!action.scorch.executing|!buff.heating_up.react&!buff.hot_streak.react)
            if (cd.combustion.remain() >= 0 or firestarterActive and buff.runeOfPower.exists()) and (talent.searingTouch and thp <= 30) and (buff.heatingUp.exists() and not cast.current.scorch() or not buff.heatingUp.exists() and not buff.hotStreak.exists()) then
                if cast.fireBlast("target") then --fblastLast = true
                    --Print("BfA RoP fBlast3") 
                    return true 
                end
            end
        -- Pyroblast
            -- pyroblast,if=prev_gcd.1.scorch&buff.heating_up.up&talent.searing_touch.enabled&target.health.pct<=30&(!talent.flame_patch.enabled|active_enemies=1)
            if cast.last.scorch() and heatsUp and talent.searingTouch and thp <= 30 and pyroReady and (not talent.flamePatch or fSEnemies == 1) then
                if cast.pyroblast("target") then 
                    --Print("BfA RoP Pyro3") 
                    return true 
                end
            end
        -- Phoenix's Flames
            -- phoenix_flames,if=!prev_gcd.1.phoenix_flames&buff.heating_up.react
            if not cast.last.phoenixsFlames() and buff.heatingUp.exists() then
                if cast.phoenixsFlames("target") then return end
            end
        -- Scorch
            -- scorch,if=target.health.pct<=30&talent.searing_touch.enabled
            if thp <= 30 and talent.searingTouch then
                if cast.scorch("target") then --scorchLast = true
                    --Print("BfA RoP scor1") 
                    return 
                end
            end
        -- Dragon's Breath
            --dragons_breath,if=active_enemies>2
            if #enemies.yards8t > 2 and ((getFacing("player",units.dyn8,30) and mode.rotation == 1) or mode.rotation == 2) and getDistance(units.dyn8) <= 8 then
                if cast.dragonsBreath("player","cone",1,10) then --[[Print("db4")--]] return end
            elseif #enemies.yards8t > 2 and talent.alexstraszasFury then
                if ((getDistance(units.dyn8) <= 8) and mode.rotation == 1) then
                    if cast.dragonsBreath("player","cone",1,10) then --[[Print("db5")--]] return end
                end
            end
        -- Flamestrike
            -- flamestrike,if=(talent.flame_patch.enabled&active_enemies>2)|active_enemies>5 - #enemies.yards8t - #fSEnemies
        --     if buff.hotStreak.react() and ((talent.flamePatch and fSEnemies > 2) or (fSEnemies > getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) then
        --         if cast.flamestrike("best",nil,1,8) then
        --             --Print("BfA RoP fStrike 2")
        --             return end
        --     end
        -- Fireball
            -- fireball
            if not moving then --and not cast.current.fireball() then
                if cast.fireball("target") then --fballLast = true
                    --Print("BfA RoP FB")
                    return 
                end
            end
            if not buff.heatingUp.exists() and (cast.last.fireball(2) and cast.current.fireball()) and charges.fireBlast.count() > 2 and not cast.last.fireBlast() then
                if cast.fireBlast("target") then 
                    --Print("BfA RoP fblastfill") 
                   return true
                end
            end
        -- Fireblast
            if cast.last.runeOfPower() and cast.last.combustion() and buff.combustion.exists() and not buff.heatingUp.exists() and not pyroReady and not ropco_opn_fblast then
                --if br.timer:useTimer("cofblastwait", 0.56) then
                    if cast.fireBlast() then ropco_opn_fblast = true
                        --Print("BfA RoP Co fblast1.5") 
                    return true
                    end
                --end
            end
        -- Scorch
            if IsMovingTime(mrdm(40,80)/100) and not buff.hotStreak.exists() then
                if cast.scorch("target") then
                    --Print("BfA ST sco")
                return end
            end

        end -- End ROP Phase Action List
    -- Action List - Standard Rotation
        local function actionList_Standard()
        -- AoE Meteor
            if isChecked("Meteor Targets") and ((#enemies.yards8t > getOptionValue("Meteor Targets") and mode.rotation == 1) or mode.rotation == 2) and not tmoving then --and cd.combustion.remain() > cdMeteorDuration and buff.heatingUp.exists() then
                if createCastFunction("best", false, getOptionValue("Meteor Targets"), 8, spell.meteor, nil, false, 0) then
                    --Print("AoE Meteor")
                    return end
            end
        -- Flamestrike
            -- flamestrike,if=((talent.flame_patch.enabled&active_enemies>1&!firestarter.active)|active_enemies>4)&buff.hot_streak.react - #enemies.yards8t - #fSEnemies
            if buff.hotStreak.react() and ((talent.flamePatch and fSEnemies > 1 and not firestarterActive) or (fSEnemies >= getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) then
                    --if cast.flamestrike("best",nil,1,8,spell.flamestrike) then
                if createCastFunction("best", false, 1, 8, spell.flamestrike, nil, false, 0) then
                    --Print("BfA ST fStrike1.1")
                    return end
            --elseif ((fSEnemies >= getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) and buff.hotStreak.react() then --and not talent.pyromaniac then
                --if cast.flamestrike("best",nil,1,8) then return end
            end
            if br.timer:useTimer("stfswait", 0.56) then return end
        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.up&buff.hot_streak.remains<action.fireball.execute_time
            if buff.hotStreak.exists() and buff.hotStreak.remain() < cast.time.fireball() or buff.hotStreak.exists() and cast.current.scorch() and thp > 30 then
                if cast.pyroblast("target") then 
                    --Print("BfA ST Pyro1") 
                    return --true 
                end
            end
        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.react&(prev_gcd.1.fireball|firestarter.active|action.pyroblast.in_flight)
            if buff.hotStreak.exists() and (cast.last.fireball() or fballLast --[[or cast.last.fireBlast() and charges.fireBlast.frac() > 0.75]] or firestarterActive or (cast.inFlight.pyroblast() or cast.last.pyroblast())) then
                --if br.timer:useTimer("stfswait", 0.56) then
                    if cast.pyroblast("target") then fballLast = false
                            --Print("BfA ST Pyro2") 
                            return --true 
                    end
                --end
            end
        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.react&target.health.pct<=30&talent.searing_touch.enabled
            if buff.hotStreak.exists() and thp <= 30 and talent.searingTouch and pyroReady then
                if cast.pyroblast("target") then 
                    --Print("BfA ST Pyro3") 
                    return 
                end
            -- pyroblast,if=buff.pyroclasm.react&cast_time<buff.pyroclasm.remains
            elseif buff.pyroclasm.react() and cast.time.pyroblast() < buff.pyroclasm.remain() then
                if cast.pyroblast("target") then 
                    --Print("BfA ST Pyro4") 
                    return 
                end
            end
        -- Fire Blast
            -- if=(cooldown.combustion.remains>0&buff.rune_of_power.down|firestarter.active)&!talent.kindling.enabled&!variable.fire_blast_pooling&(((action.fireball.executing|action.pyroblast.executing)&(buff.heating_up.react|firestarter.active&!buff.hot_streak.react&!buff.heating_up.react))|
            -- (talent.searing_touch.enabled&target.health.pct<=30&(buff.heating_up.react&!action.scorch.executing|!buff.hot_streak.react&!buff.heating_up.react&action.scorch.executing&!action.pyroblast.in_flight&!action.fireball.in_flight))|
            -- (firestarter.active&(action.pyroblast.in_flight|action.fireball.in_flight)&!buff.heating_up.react&!buff.hot_streak.react))
            --[[cast.able.fireBlast() and charges.fireBlast.frac() > 1.5 and--]] 
            if cast.able.fireBlast() and (cd.combustion.remain() >= 0 and not buff.runeOfPower.exists() or firestarterActive) and not talent.kindling and not fireBlastPool
                and ((cast.current.fireball() or cast.current.pyroblast()) and buff.heatingUp.exists() or firestarterActive and not buff.hotStreak.exists() and not buff.heatingUp.exists())
                or (talent.searingTouch and thp <= 30 and (buff.heatingUp.exists() and not cast.current.scorch() or not buff.hotStreak.exists() and not buff.heatingUp.exists() and cast.current.scorch() and not cast.inFlight.pyroblast() and not cast.inFlight.fireball())
                or firestarterActive and (cast.inFlight.pyroblast() or cast.inFlight.fireball()) and not buff.heatingUp.exists() and not buff.hotStreak.exists())
            then
                if cast.fireBlast("target") then
                    --Print("BfA ST Fblast1")
                    return
                end
            end
        -- Fire Blast    
            -- fire_blast,if=talent.kindling.enabled&buff.heating_up.react&(cooldown.combustion.remains>full_recharge_time+2+talent.kindling.enabled|firestarter.remains>full_recharge_time|(!talent.rune_of_power.enabled|cooldown.rune_of_power.remains>target.time_to_die&action.rune_of_power.charges<1)&cooldown.combustion.remains>target.time_to_die)
            if talent.kindling and buff.heatingUp.exists() and (cd.combustion.remain() > charges.fireBlast.timeTillFull() + 2 + kindle or firestarterremain > charges.fireBlast.timeTillFull() or (not talent.runeOfPower or cd.runeOfPower.remain() > ttd("target") and charges.runeOfPower.count() < 1) and cd.combustion.remain() > ttd("target")) then
                if cast.fireBlast("target") then 
                    --Print("BfA ST Fblast2") 
                    return --true 
                end
            end
        -- PyroBlast
            --pyroblast,if=prev_gcd.1.scorch&buff.heating_up.up&talent.searing_touch.enabled&target.health.pct<=30&((talent.flame_patch.enabled&active_enemies=1&!firestarter.active)|(active_enemies<4&!talent.flame_patch.enabled))
            if cast.last.scorch() and heatsUp and talent.searingTouch and thp <= 30 and pyroReady and ((talent.flamePatch and fSEnemies == 1 and not firestarterActive) or (fSEnemies < getOptionValue("Flamestrike Targets") and not talent.flamePatch)) then --or pyroReady and thp <= 30 then
                if cast.pyroblast("target") then
                    scorchLast = false
                    --scorch2Last = false
                    --Print("BfA ST Pyro5") 
                    return 
                end
            -- elseif cast.last.scorch() and buff.hotStreak.exists() and ((talent.flamePatch and fSEnemies == 1 and not firestarterActive) or (fSEnemies < getOptionValue("Flamestrike Targets") and not talent.flamePatch)) then
            --     if cast.pyroblast("target") then
            --         Print("BfA ST Pyro5.5") 
            --         return 
            --     end
            end
        -- Phoenix's Flames
            --phoenix_flames,if=(buff.heating_up.react|(!buff.hot_streak.react&(action.fire_blast.charges>0|talent.searing_touch.enabled&target.health.pct<=30)))&!variable.phoenix_pooling
            if buff.heatingUp.exists() or (not buff.hotStreak.exists() and charges.fireBlast.count() > 0) or (talent.searingTouch and thp <= 30) and not phoenixPool then
                if cast.phoenixsFlames("target") then return end
            end 
        -- Call Action List - Active Talents
            -- call_action_list,name=active_talents
            --if br.timer:useTimer("stteorwait", 0.7) then
                if actionList_ActiveTalents() then 
                --Print("ST Talents")
                return end
            --end
        -- Dragon's Breath
            --dragons_breath,if=active_enemies>1
            if #enemies.yards8t >= 1 and ((getFacing("player",units.dyn8,30) and mode.rotation == 1) or mode.rotation == 2) and getDistance(units.dyn8) <= 8 then
                if cast.dragonsBreath("player","cone",1,10) then --[[Print("db4")--]] return end
            elseif #enemies.yards8t >= 1 and talent.alexstraszasFury then
                if ((getDistance(units.dyn8) <= 8) and mode.rotation == 1) then
                    if cast.dragonsBreath("player","cone",1,10) then --[[Print("db5")--]] return end
                end
            end
        -- Cyclotronic Blast
            if hasItem(293491) and isChecked("Cyclotronic Blast") then
                if canUseItem(293491) then
                    useItem(293491)
                end
            end
        -- Scorch
            -- scorch,if=target.health.pct<=30&talent.searing_touch.enabled
            if thp <= 30 and talent.searingTouch then
                if cast.scorch("target") then scorchLast = true
                    --Print("BfA ST Scor") 
                    return 
                end
            end
            --if scorchLast then scorch2Last = true return end
            --if scorchLast then Print("scorch2 true") return end
        -- Fireball
            -- fireball
            if not moving and (not buff.combustion.exists() and not cast.last.combustion()) and not cast.last.runeOfPower() then --and not cast.current.fireball() then ----[[and not buff.heatingUp.exists()--]] and not buff.hotStreak.exists() then --]]
                if cast.fireball("target") then fballLast = true
                    --Print("BfA ST fBall")
                return end
            end
            if not buff.heatingUp.exists() and (cast.last.fireball(2) and cast.current.fireball()) and charges.fireBlast.count() > 2 and not cast.last.fireBlast() then
                if cast.fireBlast("target") then 
                    --Print("BfA ST fblastfill") 
                   return true
                end
            end
            --if cast.last.fireball() then print(GetTime() .. " fireball") end
            -- Make sure hotStreak proccs are being consumed!
            -- if cast.current.fireball() and buff.hotStreak.exists() or buff.combustion.exists() then
            --     if br.timer:useTimer("delaystop", getCastTime(spell.fireball)*gcdMax) then
            --         SpellStopCasting()
            --         fballLast = true
            --         --Print("stop for Pyro")
            --     return true end
            -- end
        -- Scorch
            if IsMovingTime(mrdm(40,80)/100) then
                if cast.scorch("target") then
                    --Print("BfA ST sco")
                return end
            end
        end  -- End BfA Single Target Action List

---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or IsMounted() or pause(true) --[[or cast.current.focusedAzeriteBeam() or isCastingSpell(293491)]] or mode.rotation==4 then
            if buff.heatingUp.exists() and not buff.combustion.exists() then
                if cast.fireBlast("target") then return end
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
            if inCombat and profileStop==false and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 and (timedPull == true or soloPull == true) and not isCastingSpell(293491) and not cast.current.focusedAzeriteBeam() then
   
            --end
                    
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    ----------------------
    --- SimC BfA APL ---
    ----------------------
                if getOptionValue("APL Mode") == 1 then --Print("BfA ST Fblast")
                    --Print(0.32 * (1 + GetHaste() / 100))
        -- Mirror Image
                    -- mirror_image,if=buff.combustion.down
                    if useCDs() and isChecked("Mirror Image") and not buff.combustion.exists() then
                        if cast.mirrorImage() then return end
                        end
        -- Focused Azerite Beam
                    --focused_azerite_beam
                    if focusedBeam --[[and useCDs()]] and getDistance("target") <= 16 and ((fSEnemies >= getOptionValue("Focused Beam Targets") and mode.rotation == 1) or mode.rotation == 2) or isBoss() then
                        if cast.focusedAzeriteBeam("player") then return end
                    end
        -- Lucid Dreams
                --memory_of_lucid_dreams
                -- if lucisDreams and cast.able.memoryOfLucidDreams() and (talent.runeOfPower and buff.runeOfPower.exists()) then 
                --     if cast.memoryOfLucidDreams("player") then --[[Print("Lucid")--]] return end
                if useCDs() and lucisDreams and cast.able.memoryOfLucidDreams() then --and cast.last.runeOfPower() then 
                    if cast.memoryOfLucidDreams("player") then --[[Print("Lucid")--]] return end
                end
        -- Shiver Venom Relic
                if (GetInventoryItemID("player", 13) == 168905 or GetInventoryItemID("player", 14) == 168905) and isChecked("Shiver Venoms") then
                    if  getDebuffStacks("target", 301624) == 5 then
                        if canUseItem(168905) then
                            useItem(168905)
                        end
                    end
                end
    -- Rune of Power
                    -- rune_of_power,if=talent.firestarter.enabled&firestarter.remains>full_recharge_time|cooldown.combustion.remains>variable.combustion_rop_cutoff&buff.combustion.down|target.time_to_die<cooldown.combustion.remains&buff.combustion.down
                     if useCDs() and not moving then
                        if talent.firestarter and firestarterremain > charges.runeOfPower.timeTillFull() or cd.combustion.remain() > combustionROPcutoff and not buff.combustion.exists() or ttd("target") < cd.combustion.remain() and not buff.combustion.exists() then
                            if cast.runeOfPower("player") then 
                                --Print("RoP") 
                                return 
                            end
                        end
                    end
        -- Action List - BM Combustion Phase
                    -- combustion_phase,if=(talent.rune_of_power.enabled&cooldown.combustion.remains<=action.rune_of_power.cast_time|cooldown.combustion.ready)&!firestarter.active|buff.combustion.up
                    --if mode.cooldown == 1 or mode.cooldown == 2 then
                    if useCDs() and traits.blasterMaster.active --[[and talent.flameOn--]] and not lucisDreams then --and not firestarterActive then 
                        if (talent.runeOfPower and cd.combustion.remain() < cast.time.runeOfPower() or cd.combustion.remain() == 0) and not firestarterActive or buff.combustion.exists() then
                                if actionList_BMCombustionPhase() then 
                                ChatOverlay("BMaster Combustion Phase") 
                                return 
                            end
                        end
                    end--]]
        -- Action List - Combustion Phase
                    -- combustion_phase,if=(talent.rune_of_power.enabled&cooldown.combustion.remains<=action.rune_of_power.cast_time|cooldown.combustion.ready)&!firestarter.active|buff.combustion.up
                    if useCDs() and (not traits.blasterMaster.active or lucisDreams) then --or not talent.flameOn) then --and firestarterInactive then 
                        if (talent.runeOfPower and cd.combustion.remain() < cast.time.runeOfPower() or cd.combustion.remain() == 0) and not firestarterActive or buff.combustion.exists() then
                                if actionList_CombustionPhase() then 
                                    ChatOverlay("Combustion Phase") 
                                return 
                            end
                        end
                    end
        -- Action List - Rune of Power Phase
                    -- rop_phase,if=buff.rune_of_power.up&buff.combustion.down
                    if buff.runeOfPower.exists() and not buff.combustion.exists() and not moving then
                        if actionList_ROPPhase() then 
                            ChatOverlay("RoP Phase") 
                            return 
                        end
                    end
        -- Action List - Standard
                    -- name=standard_rotation
                    if not buff.combustion.exists() and not buff.runeOfPower.exists() then
                        if actionList_Standard() then 
                            ChatOverlay("Standard Rotation") 
                            return 
                        end
                    end
        -- Scorch
                    --if not buff.hotStreak.exists() and moving then
                    --    if cast.scorch() then return end
                    --end
                end -- End SimC BfA APL
            end --End In Combat
        end --End Rotation Logic
    --end -- End Timer
end -- End runRotation
local id = 63
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})