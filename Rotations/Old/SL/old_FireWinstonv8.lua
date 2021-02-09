local rotationName = "pyroMania"

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
-- Dragonbreath Button
    DragonsBreathModes = {
       [1] = { mode = "On", value = 1 , overlay = "Dragonbreath Enabled", tip = "Always use Dragonbreath.", highlight = 1, icon = br.player.spell.dragonsBreath},
       [2] = { mode = "Off", value = 2 , overlay = "Dragonbreath Disabled", tip = "Don't use Dragonbreath.", highlight = 0, icon = br.player.spell.dragonsBreath}
    };
    CreateButton("DragonsBreath",5,0)
-- Save FB Button
    SaveFBModes = {
       [1] = { mode = "On", value = 1 , overlay = "Using Fireblasts", tip = "Use Fireblast Charges.", highlight = 1, icon = br.player.spell.fireBlast},
       [2] = { mode = "Off", value = 2 , overlay = "Saving Fireblasts", tip = "Save Fireblast Charges.", highlight = 0, icon = br.player.spell.fireBlast}
    };
    CreateButton("SaveFB",6,0)

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
            --br.ui:createCheckbox(section, "Opener")
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
            br.ui:createSpinnerWithout(section, "Flamestrike Targets",  4,  2,  10,  1, "Unit Count Limit before casting Flamestrike.")
        -- Focused Beam
            br.ui:createSpinnerWithout(section, "Focused Beam Targets",  3,  2,  10,  1, "Unit Count Limit before casting Focused Beam.")
        -- Artifact 
        --    br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Cyclotronic Blast
            --br.ui:createCheckbox(section,"Cyclotronic Blast", "Use Cyclotronic Blast on Cooldown.")
        -- Hyperthread Wristwraps
            --br.ui:createCheckbox(section,"Hyperthread Wristwraps", "Use Hyperthread Wrist on Cooldown.")
        -- Mirror Image
            br.ui:createCheckbox(section,"Mirror Image")
        -- Shiver Venom Relic
            --br.ui:createCheckbox(section,"Shiver Venoms", "Freeze them Shivery Venoms on Cooldown.")
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
        -- Spellsteal
            br.ui:createDropdown(section,"Spellsteal", {"|cffFFFF00Selected Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")
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
        UpdateToggle("DragonsBreath",0.25)
        br.player.ui.mode.dragonsBreath = br.data.settings[br.selectedSpec].toggles["DragonsBreath"]
        UpdateToggle("SaveFB",0.25)
        br.player.ui.mode.fireBlast = br.data.settings[br.selectedSpec].toggles["SaveFB"]
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
        local dPrint                                        = br.addonDebug
        local enemies                                       = br.player.enemies
        local equiped                                       = br.player.equiped
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
        local mode                                          = br.player.ui.mode
        local moveIn                                        = 999
        local moving                                        = isMoving("player")
        local castin                                        = UnitCastingInfo("player")
        local mrdm                                          = math.random
        local tmoving                                       = isMoving("target")
        local traits                                        = br.player.traits
        local perk                                          = br.player.perk        
        local pHaste                                        = 1 / (1 + GetHaste() / 100)
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
        local use                                           = br.player.use

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
        --local fSEnemies = #enemies.yards8t
        if #enemies.yards6t > 0 then fSEnemies = #enemies.yards6t else fSEnemies = #enemies.yards40 end
        local dBEnemies = getEnemies(units.dyn12, 6, true)

        local firestarterActive = talent.firestarter and thp > 90
        local firestarterInactive = thp < 90 or isDummy()
        
        local lucisDreams = essence.memoryOfLucidDreams.active
        local focusedBeam = essence.focusedAzeriteBeam.active
        local azerothsGuard = essence.guardianOfAzeroth.active

        local pyroReady = cast.time.pyroblast() == 0 --and br.timer:useTimer("pyroReady", 0.56)
        local hotterStreak = buff.hotStreak.exists() and buff.hotStreak.remain() > 5
        local heatsUp = buff.heatingUp.exists() and buff.heatingUp.remain() > 5

        local pSlot09 = GetInventoryItemID("player", 9)
        local pSlot13 = GetInventoryItemID("player", 13)
        local pSlot14 = GetInventoryItemID("player", 14)
        
        local disable_combustion = false

        local nofS = fSEnemies < getOptionValue("Flamestrike Targets")

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

        local dispelDelay = 1.5
        if isChecked("Dispel delay") then
            dispelDelay = getValue("Dispel delay")
        end

        local doNotSteal = {
            [273432] = "Bound By Shadow(Uldir)",
            [269935] = "Bound By Shadow(KR)"
        }
        local function spellstealCheck(unit)
            local i = 1
            local buffName, _, _, _, duration, expirationTime, _, isStealable, _, spellId = UnitBuff(unit, i)
            while buffName do
                if doNotSteal[spellId] then
                    return false
                elseif isStealable and (GetTime() - (expirationTime - duration)) > dispelDelay then
                    return true
                end
                i = i + 1
                buffName, _, _, _, duration, expirationTime, _, isStealable, _, spellId = UnitBuff(unit, i)            
            end
            return false
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

        --cooldown.combustion.remains<action.fire_blast.full_recharge_time+cooldown.fire_blast.duration*azerite.blaster_master.enabled
        --if traits.blasterMaster then bMasterFBCRG = charges.fireBlast.timeTillFull() + fblastCDduration else bMasterFBCRG = 0 end
        if traits.blasterMaster.active then bMasterFBCD = cd.fireBlast.remain() + fblastCDduration else bMasterFBCD = 0 end

        -- if hasItem(167528) then notorious_aspirants_badge = 1 else notorious_aspirants_badge = 0 end
        -- if hasItem(167380) then notorious_gladiators_badge = 1 else notorious_gladiators_badge = 0 end
        -- if hasItem(165058) then sinister_gladiators_badge = 1 else sinister_gladiators_badge = 0 end
        -- if hasItem(165223) then sinister_aspirants_badge = 1 else sinister_aspirants_badge = 0 end
        -- if hasItem(161902) then dread_gladiators_badge = 1 else dread_gladiators_badge = 0 end
        -- if hasItem(162966) then dread_aspirants_badge = 1 else dread_aspirants_badge = 0 end
        -- if hasItem(161813) then dread_combatants_insignia = 1 else dread_combatants_insignia = 0 end
        -- if hasItem(167525) then notorious_aspirants_medallion = 1 else notorious_aspirants_medallion = 0 end
        -- if hasItem(167377) then notorious_gladiators_medallion = 1 else notorious_gladiators_medallion = 0 end
        -- if hasItem(165055) then sinister_gladiators_medallion = 1 else sinister_gladiators_medallion = 0 end
        -- if hasItem(165220) then sinister_aspirants_medallion = 1 else sinister_aspirants_medallion = 0 end
        -- if hasItem(161674) then dread_gladiators_medallion = 1 else dread_gladiators_medallion = 0 end
        -- if hasItem(162897) then dread_aspirants_medallion = 1 else dread_aspirants_medallion = 0 end
        -- if hasItem(161811) then dread_combatants_medallion = 1 else dread_combatants_medallion = 0 end
        if equiped.azsharasFontOfPower() then azsharas_font_of_power = 1 else azsharas_font_of_power = 0 end 
        if hasItem(159615) then ignition_mages_fuse = 1 else ignition_mages_fuse = 0 end
        if hasItem(161411) then tzanes_barkspines = 1 else tzanes_barkspines = 0 end
        if hasItem(161377) then azurethos_singed_plumage = 1 else azurethos_singed_plumage = 0 end
        if hasItem(166793) then ancient_knot_of_wisdom = 1 else ancient_knot_of_wisdom = 0 end
        if hasItem(169318) then shockbiters_fang = 1 else shockbiters_fang = 0 end
        if hasItem(168973) then neural_synapse_enhancer = 1 else neural_synapse_enhancer = 0 end
        if hasItem(159630) then balefire_branch = 1 else balefire_branch = 0 end
    
        --# This variable sets the time at which Rune of Power should start being saved for the next Combustion phase
        --actions.precombat+=/variable,name=combustion_rop_cutoff,op=set,value=60
        local combustionROPcutoff = 60
        local fBlastCombSave = cd.combustion.remain() < 16 * pHaste and cd.combustion.remain() > 0
        local poweringRune = (isCastingSpell(spell.runeOfPower) and getCastTimeRemain("player") < 0.6)

        --variable,name=combustion_on_use,op=set,value=equipped.notorious_aspirants_badge|equipped.notorious_gladiators_badge|equipped.sinister_gladiators_badge|equipped.sinister_aspirants_badge|equipped.dread_gladiators_badge|equipped.dread_aspirants_badge|
                                                     --equipped.dread_combatants_insignia|equipped.notorious_aspirants_medallion|equipped.notorious_gladiators_medallion|equipped.sinister_gladiators_medallion|equipped.sinister_aspirants_medallion|
                                                     --equipped.dread_gladiators_medallion|equipped.dread_aspirants_medallion|equipped.dread_combatants_medallion|equipped.ignition_mages_fuse|equipped.tzanes_barkspines|equipped.azurethos_singed_plumage|
                                                     --equipped.ancient_knot_of_wisdom|equipped.shockbiters_fang|equipped.neural_synapse_enhancer|equipped.balefire_branch
        -- local combustion_on_use = notorious_aspirants_badge or notorious_gladiators_badge or sinister_gladiators_badge or sinister_aspirants_badge or dread_gladiators_badge or dread_aspirants_badge or dread_combatants_insignia or notorious_aspirants_medallion
        --                           or notorious_gladiators_medallion or sinister_gladiators_medallion or sinister_aspirants_medallion or dread_gladiators_medallion or dread_aspirants_medallion or dread_combatants_medallion or ignition_mages_fuse
        --                           or tzanes_barkspines or azurethos_singed_plumage or ancient_knot_of_wisdom or shockbiters_fang or neural_synapse_enhancer or balefire_branch

        local combustion_on_use = ignition_mages_fuse or tzanes_barkspines or azurethos_singed_plumage or ancient_knot_of_wisdom or shockbiters_fang or neural_synapse_enhancer or balefire_branch

        --variable,name=font_double_on_use,op=set,value=equipped.azsharas_font_of_power&variable.combustion_on_use
        local font_double_on_use = azsharas_font_of_power and combustion_on_use

        --variable,name=on_use_cutoff,op=set,value=20*variable.combustion_on_use&!variable.font_double_on_use+40*variable.font_double_on_use+25*equipped.azsharas_font_of_power&!variable.font_double_on_use
        local on_use_cutoff = 20 * combustion_on_use and 0 + 40 * font_double_on_use + 25 * azsharas_font_of_power and 0

        --variable,name=phoenix_pooling,value=talent.rune_of_power.enabled&cooldown.rune_of_power.remains<cooldown.phoenix_flames.full_recharge_time&cooldown.combustion.remains>variable.combustion_rop_cutoff&(cooldown.rune_of_power.remains<target.time_to_die|action.rune_of_power.charges>0)|cooldown.combustion.remains<action.phoenix_flames.full_recharge_time&cooldown.combustion.remains<target.time_to_die
        local phoenixPool = talent.runeOfPower and cd.runeOfPower.remain() < cd.phoenixsFlames.remain() and cd.combustion.remain() > combustionROPcutoff and (cd.runeOfPower.remain() < ttd("target") or charges.runeOfPower.count() > 0) or cd.combustion.remain() < charges.phoenixsFlames.timeTillFull() and cd.combustion.remain() < ttd("target")

        --variable,name=fire_blast_pooling,value=talent.rune_of_power.enabled&cooldown.rune_of_power.remains<cooldown.fire_blast.full_recharge_time&(cooldown.combustion.remains>variable.combustion_rop_cutoff|firestarter.active)&(cooldown.rune_of_power.remains<target.time_to_die|action.rune_of_power.charges>0)|cooldown.combustion.remains<action.fire_blast.full_recharge_time+cooldown.fire_blast.duration*azerite.blaster_master.enabled&!firestarter.active&cooldown.combustion.remains<target.time_to_die|talent.firestarter.enabled&firestarter.active&firestarter.remains<cooldown.fire_blast.full_recharge_time+cooldown.fire_blast.duration*azerite.blaster_master.enabled
        local fireBlastPool = talent.runeOfPower and cd.runeOfPower.remain() < cd.fireBlast.remain() and (cd.combustion.remain() > combustionROPcutoff or firestarterActive) and (cd.runeOfPower.remain() < ttd("target") or charges.runeOfPower.count() > 0) or cd.combustion.remain() < bMasterFBCD and not firestarterActive and cd.combustion.remain() < ttd("target") or talent.firestarter and firestarterActive and firestarterremain < bMasterFBCD --then

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

        if inCombat and IsAoEPending() then
            SpellStopTargeting()
            return true
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

        -- Spell Steal
                if isChecked("Spellsteal") and not pyroReady then
                    if getOptionValue("Spellsteal") == 1 then
                        if spellstealCheck("target") and GetObjectExists("target") then
                            if cast.spellsteal("target") then br.addonDebug("Casting Spellsteal") return true end
                        end
                    elseif getOptionValue("Spellsteal") == 2 then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if spellstealCheck(thisUnit) then
                                if cast.spellsteal(thisUnit) then br.addonDebug("Casting Spellsteal") return true end
                            end
                        end
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
                -- if isChecked("Trinket 1") and canUseItem(13) then
                --         useItem(13)
                --         return true
                -- end
                -- if isChecked("Trinket 2") and canUseItem(14) then
                --         useItem(14)
                --         return true
                -- end

        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury | berserking | arcane_torrent

                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "Blood Elf") then
                    if castSpell("player",racial,false,false,false) then return end
                end

            end -- End useCDs check
        end -- End Action List - Cooldowns
    -- Action List - Items Combustion
        local function actionList_ItemsCombustion()
        -- Hyperthread Wristwraps
            -- use_item,name=hyperthread_wristwraps,if=buff.combustion.up&action.fire_blast.charges=0&action.fire_blast.recharge_time>gcd.max

            if pSlot09 == 168989 and canUseItem(9) then --and not pyroReady then
                if buff.combustion.exists() and charges.fireBlast.count() == 0 and charges.fireBlast.timeTillFull() > gcdMax then
                      --if  then
                          useItem(168989)
                      --end
                  end
              --end
          end

            if isChecked("Trinket 1") or isChecked("Trinket 2") then

            -- Ignition Mages Fuse
                -- use_item,name=ignition_mages_fuse

                if (pSlot13 == 159615 or pSlot14 == 159615) then
                    if canUseItem(159615) then
                        useItem(159615)
                    end
                end

            -- Azurethos Singed Plumage
                --use_item,use_off_gcd=1,name=azurethos_singed_plumage,if=buff.combustion.up|action.meteor.in_flight&action.meteor.in_flight_remains<=0.5

                if (pSlot13 == 161377 or pSlot14 == 161377) then
                    if buff.combustion.exists() or cast.inFlight.meteor() then
                        if canUseItem(161377) then
                            useItem(161377)
                        end
                    end
                end

            -- Balefire Branch
                --use_item,use_off_gcd=1,name=balefire_branch,if=buff.combustion.up|action.meteor.in_flight&action.meteor.in_flight_remains<=0.5

                if (pSlot13 == 159630 or pSlot14 == 159630) then
                    if buff.combustion.exists() or cast.inFlight.meteor() then
                        if canUseItem(159630) then
                            useItem(159630)
                        end
                    end
                end

            -- Shockbiters Fang
                --use_item,use_off_gcd=1,name=shockbiters_fang,if=buff.combustion.up|action.meteor.in_flight&action.meteor.in_flight_remains<=0.5

                if (pSlot13 == 169318 or pSlot14 == 169318) then
                    if buff.combustion.exists() or cast.inFlight.meteor() then
                        if canUseItem(169318) then
                            useItem(169318)
                        end
                    end
                end

            -- Tzanes Barkspines
                --use_item,use_off_gcd=1,name=tzanes_barkspines,if=buff.combustion.up|action.meteor.in_flight&action.meteor.in_flight_remains<=0.5

                if (pSlot13 == 161411 or pSlot14 == 161411) then
                    if buff.combustion.exists() or cast.inFlight.meteor() then
                        if canUseItem(161411) then
                            useItem(161411)
                        end
                    end
                end

            -- Acient Knot of Wisdom
                --use_item,use_off_gcd=1,name=ancient_knot_of_wisdom,if=buff.combustion.up|action.meteor.in_flight&action.meteor.in_flight_remains<=0.5

                if (pSlot13 == 166793 or pSlot14 == 166793) then
                    if buff.combustion.exists() or cast.inFlight.meteor() then
                        if canUseItem(166793) then
                            useItem(166793)
                        end
                    end
                end

            -- Neural Synapse Enhancer
                --use_item,use_off_gcd=1,name=neural_synapse_enhancer,if=buff.combustion.up|action.meteor.in_flight&action.meteor.in_flight_remains<=0.5

                if (pSlot13 == 168973 or pSlot14 == 168973) then
                    if buff.combustion.exists() or cast.inFlight.meteor() then
                        if canUseItem(168973) then
                            useItem(168973)
                        end
                    end
                end

            -- Malformed Heralds Legwraps
                --use_item,use_off_gcd=1,name=malformed_heralds_legwraps,if=buff.combustion.up|action.meteor.in_flight&action.meteor.in_flight_remains<=0.5

                if (pSlot13 == 167835 or pSlot14 == 167835) then
                    if buff.combustion.exists() or cast.inFlight.meteor() then
                        if canUseItem(167835) then
                            useItem(167835)
                        end
                    end
                end
            end

        end -- End Items Combustion
    -- Action List - Items High Prio
        local function actionList_ItemsHighPrio()
            --call_action_list,name=items_combustion,if=(talent.rune_of_power.enabled&cooldown.combustion.remains<=action.rune_of_power.cast_time|cooldown.combustion.ready)&!firestarter.active|buff.combustion.up

            if (talent.runeOfPower and cd.combustion.remain() <= cast.time.runeOfPower() or cd.combustion.remain() == 0) and not firestarterActive or buff.combustion.exists() then
                if actionList_ItemsCombustion() then return end
            end

            --use_items
            if actionList_Cooldowns() then return end

            -- --use_item,name=azsharas_font_of_power,if=cooldown.combustion.remains<=5+15*variable.font_double_on_use

                if cd.combustion.remain() <= 5 + 15 * font_double_on_use then
                    if equiped.azsharasFontOfPower() and use.able.azsharasFontOfPower() then
                        SpellStopCasting()
                        if use.azsharasFontOfPower() then return true end
                    end
                end

            --use_item,name=rotcrusted_voodoo_doll,if=cooldown.combustion.remains>variable.on_use_cutoff

            if (GetInventoryItemID("player", 13) == 159624 or GetInventoryItemID("player", 14) == 159624) then
                if cd.combustion.remain() > on_use_cutoff then
                    if canUseItem(159624) then
                        useItem(159624)
                    end
                end
            end

            --use_item,name=aquipotent_nautilus,if=cooldown.combustion.remains>variable.on_use_cutoff

            if (GetInventoryItemID("player", 13) == 169305 or GetInventoryItemID("player", 14) == 169305) then
                if cd.combustion.remain() > on_use_cutoff then
                    if canUseItem(169305) then
                        useItem(169305)
                    end
                end
            end

            --use_item,name=shiver_venom_relic,if=cooldown.combustion.remains>variable.on_use_cutoff

            if (GetInventoryItemID("player", 13) == 168905 or GetInventoryItemID("player", 14) == 168905) then
                if cd.combustion.remain() > on_use_cutoff and getDebuffStacks("target", 301624) == 5 then
                    if canUseItem(168905) then
                        useItem(168905)
                    end
                end
            end

            --use_item,name=forbidden_obsidian_claw,if=cooldown.combustion.remains>variable.on_use_cutoff|variable.disable_combustion

            if (GetInventoryItemID("player", 13) == 173944 or GetInventoryItemID("player", 14) == 173944) then
                if cd.combustion.remain() > on_use_cutoff then
                    if canUseItem(173944) then
                        useItem(173944)
                    end
                end
            end


            --use_item,effect_name=harmonic_dematerializer

            if equiped.pocketSizedComputationDevice() and equiped.socket.pocketSizedComputationDevice(167677,1) and use.able.pocketSizedComputationDevice() then
                use.pocketSizedComputationDevice()
            end

            --use_item,name=malformed_heralds_legwraps,if=cooldown.combustion.remains>=55&buff.combustion.down&cooldown.combustion.remains>variable.on_use_cutoff

            if GetInventoryItemID("player", 7) == 167835 then
                if cd.combustion.remain() >= 55 and not buff.combustion.exists() and cd.combustion.remain() > on_use_cutoff then
                    if canUseItem(7) then
                        useItem(167835)
                    end
                end
            end

            --use_item,name=ancient_knot_of_wisdom,if=cooldown.combustion.remains>=55&buff.combustion.down&cooldown.combustion.remains>variable.on_use_cutoff

            if (GetInventoryItemID("player", 13) == 166793 or GetInventoryItemID("player", 14) == 166793) then
                if cd.combustion.remain() >= 55 and not buff.combustion.exists() and cd.combustion.remain() > on_use_cutoff then
                    if canUseItem(166793) then
                        useItem(166793)
                    end
                end
            end

        end -- End Action List - Items High Prio
    -- Action List - Items Low Prio
        local function actionList_ItemsLowPrio()
            --use_item,name=tidestorm_codex,if=cooldown.combustion.remains>variable.on_use_cutoff|talent.firestarter.enabled&firestarter.remains>variable.on_use_cutoff

            if (GetInventoryItemID("player", 13) == 165576 or GetInventoryItemID("player", 14) == 165576) then
                if cd.combustion.remain() > on_use_cutoff or talent.firestarter and firestarterremain > on_use_cutoff then
                    if canUseItem(165576) then
                        useItem(165576)
                    end
                end
            end

            --use_item,effect_name=cyclotronic_blast,if=cooldown.combustion.remains>variable.on_use_cutoff|talent.firestarter.enabled&firestarter.remains>variable.on_use_cutoff

            if cd.combustion.remain() > on_use_cutoff or talent.firestarter and firestarterremain > on_use_cutoff then
                if equiped.pocketSizedComputationDevice() and equiped.socket.pocketSizedComputationDevice(167672,1) and use.able.pocketSizedComputationDevice() then
                    use.pocketSizedComputationDevice()
                end
            end

        end -- End Action List - Items Low Prio
    -- Action List - Opener
        -- local function actionList_Opener()
        --     if isChecked("Opener") --[[and (isBoss("target") or isDummy("target"))]] and opener == false then
        --         if isValidUnit("target") and getDistance("target") < 40 then
        --             if not OPN1 then
        --                 Print("Starting Opener")
        --                 OPN1 = true

        --             elseif OPN1 and not OPN2 then
        --                 if not cast.last.fireball() and not moving then
        --                     if castOpener("fireball","OPN2",1) then return end
        --                 end

        --             elseif OPN2 and not OPN3 then
        --                 if lucisDreamsand then
        --                     if castOpener("memoryOfLucidDreams","OPN3",2) then return end
        --                 elseif not lucisDreams then
        --                     OPN3 = true
        --                 end

        --             elseif OPN3 and not OPN4 then
        --                 if buff.heatingUp.exists() then
        --                     if castOpener("fireBlast","OPN4",3) then return end
        --                 elseif not buff.heatingUp.exists() and not buff.hotStreak.exists() then
        --                     OPN4 = true
        --                 end

        --             elseif OPN4 and not OPN5 then
        --                 if talent.runeOfPower then
        --                     if castOpener("runeOfPower","OPN5",4) then return end
        --                 elseif not talent.runeOfPower then
        --                     OPN5 = true
        --                 end

        --             elseif OPN5 and not OPN6 then
        --                     if castOpener("combustion","OPN6",5) then return end

        --             elseif OPN6 and not OPN7 then
        --                 if not cast.last.fireBlast() then
        --                     if castOpener("fireBlast","OPN7",6) then return end
        --                 end

        --             elseif OPN7 then
        --                 opener = true;
        --                 Print("Opener Complete")
        --                 return
        --             end
        --         end
        --     elseif (UnitExists("target") and (not isBoss("target") or not isDummy("target"))) or not isChecked("Opener") then
        --     	opener = true
        --     	return
        --     end
        -- end -- End Action List - Opener
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then

            -- Mirror Image
                if useCDs() and isChecked("Mirror Image") then
                    if cast.mirrorImage() then return end
                end

            -- Pre-Pull

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

                    if not disable_combustion then
                        if equiped.azsharasFontOfPower() and use.able.azsharasFontOfPower() then
                            SpellStopCasting()
                            use.azsharasFontOfPower()
                        end
                    end

                    -- Opener Sequence
                        -- if actionList_Opener() then return end

                        -- if opener == true then
                        --     timedPull = true
                        -- elseif opener == false then
                        --     soloPull = true
                        -- end

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

            if useCDs() and fSEnemies >= 1 --[[and cast.able.meteor() and not firestarterActive]] and (cdMeteorDuration < cd.combustion.remain() or cd.combustion.remain() == 0) and not tmoving then
                --if buff.runeOfPower.exists() and (firestarterremain > cdMeteorDuration or not firestarterActive) or cd.runeOfPower.remain() > ttd("target") and charges.runeOfPower.count() < 1 or (cd.combustion.remain() > cdMeteorDuration or cd.combustion.remain() == 0) and not talent.runeOfPower and (cdMeteorDuration < firestarterremain or not firestarterActive) then
                if buff.runeOfPower.exists() and (firestarterremain > cd.meteor.duration() or not firestarterActive) or (cd.runeOfPower.remain() > ttd("target") and charges.runeOfPower.count() < 1) or --[[(cd.meteor.duration() < cd.combustion.remain() or cd.combustion.remain() == 0) and]] not talent.runeOfPower and (cdMeteorDuration < firestarterremain or not talent.firestarter or not firestarterActive) then
                    --if cast.meteor("target",nil,1,8,spell.meteor) then
                    if createCastFunction("best", false, 1, 8, spell.meteor, nil, false, 0) and TargetLastEnemy() then teorLast = true
                        dPrint("Talents Meteor")
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
    -- Action List - Combustion Phase
        local function actionList_CombustionPhase()

            --lights_judgment,if=buff.combustion.down
            --blood_of_the_enemy

        -- Lucid Dreams
            --memory_of_lucid_dreams

            if lucisDreams then --and teorLast == true then --and (talent.meteor and cd.meteor.remain() == 0 or debuff.meteorBurn.exists("target") or not talent.meteor) then --and cast.able.memoryOfLucidDreams() then --and cast.last.runeOfPower() then
                if cd.combustion.remain() < gcdMax or cd.combustion.remain() == 0 and not tmoving then
                    if cast.memoryOfLucidDreams() then dPrint("Comb Lucid") return end
                end
            end

        -- FireBlast
            -- fire_blast,use_while_casting=1,use_off_gcd=1,if=charges>=1&((action.fire_blast.charges_fractional+(buff.combustion.remains-buff.blaster_master.duration)%cooldown.fire_blast.duration-(buff.combustion.remains)%(buff.blaster_master.duration-0.5))>=0
            -- |!azerite.blaster_master.enabled|buff.combustion.remains<=buff.blaster_master.duration|buff.blaster_master.remains<0.5
            -- |equipped.hyperthread_wristwraps&cooldown.hyperthread_wristwraps.remains<5)&buff.combustion.up&(!action.scorch.executing&!action.pyroblast.in_flight&buff.heating_up.up
            -- |action.scorch.executing&buff.hot_streak.down&(buff.heating_up.down|azerite.blaster_master.enabled)
            -- |azerite.blaster_master.enabled&action.pyroblast.in_flight&buff.heating_up.down&buff.hot_streak.down)

            --if not cast.last.fireBlast() --[[and br.timer:useTimer("fblastdelay", 0.3)]] then
                if charges.fireBlast.count() >= 1 and ((charges.fireBlast.frac() + (buff.combustion.remain() - buff.blasterMaster.duration()) / fblastCDduration - (buff.combustion.remain()) / (buff.blasterMaster.duration() - 0.5)) >= 0
                or not traits.blasterMaster.active or buff.combustion.remain() <= buff.blasterMaster.duration() or buff.blasterMaster.remain() < 0.5
                or hasItem(168989) and GetItemCooldown(168989) < 5) and buff.combustion.exists() and (not cast.current.scorch() and not cast.inFlight.pyroblast() and buff.heatingUp.exists()
                or cast.current.scorch() and not buff.hotStreak.exists() and (not buff.heatingUp.exists() or traits.blasterMaster.active)
                or traits.blasterMaster.active and cast.inFlight.pyroblast() and not buff.heatingUp.exists() and not buff.hotStreak.exists()) then
                    if not cast.last.fireBlast() then 
                        if br.timer:useTimer("fblastdelay", 0.21) then
                            if cast.fireBlast("target") then 
                                dPrint("Comb fblast1") 
                            return
                            end
                        end
                    end
                end
            --end

            -- if cast.last.combustion() or cast.last.runeOfPower() or cast.last.memoryOfLucidDreams() then
            --     if buff.latentArcana.exists() and charges.fireBlast.count() == 3 then
            --         if cast.fireBlast("target") then 
            --             dPrint("Comb fblast1.1") 
            --         return
            --         end
            --     end
            -- end

        -- Rune of Power
            -- rune_of_power,if=buff.combustion.down

            if not moving and not buff.combustion.exists() then 
                if cast.runeOfPower() then dPrint("Comb RoP") return end
            end

        -- FireBlast
           -- fire_blast,use_while_casting=1,if=azerite.blaster_master.enabled&essence.memory_of_lucid_dreams.major&talent.meteor.enabled&talent.flame_on.enabled&buff.blaster_master.down&(talent.rune_of_power.enabled&action.rune_of_power.executing&action.rune_of_power.execute_remains<0.6|
           -- (cooldown.combustion.ready|buff.combustion.up)&!talent.rune_of_power.enabled&!action.pyroblast.in_flight&!action.fireball.in_flight)

           if (charges.fireBlast.count() == 3 and not cast.last.fireBlast()) then --or cast.last.pyroblast() then
                if traits.blasterMaster.active and lucisDreams and talent.meteor and talent.flameOn and not buff.blasterMaster.exists() then
                    if talent.runeOfPower and poweringRune then
                        if cast.fireBlast("target") then 
                            dPrint("Comb fblast2.1") 
                        return
                        end
                    end
                    if (cd.combustion.remain() == 0 or buff.combustion.exists()) and not talent.runeOfPower and not cast.inFlight.pyroblast() and not cast.inFlight.fireball() and not cast.last.fireBlast() then
                        if cast.fireBlast("target") then 
                            dPrint("Comb fblast2.2") 
                        return
                        end
                    end
                end
            end

        -- Call Action List - Active Talents
            -- call_action_list,name=active_talents

                    if actionList_ActiveTalents() then --teorLast = true
                    dPrint("Comb Talents")
                    return
                    end

            -- if teorLast == true and cast.inFlight.meteor() and buff.heatingUp.exists() then
            --     if cast.fireBlast("target") then 
            --         dPrint("Comb fblasteor") 
            --        return true
            --     end
            -- if teorLast == true and cast.inFlight.meteor() and pyroReady then
            --     if cast.pyroblast("target") then 
            --         dPrint("Comb Pyroteor")
            --        return
            --     end
            -- end

        -- Combustion
            -- combustion,use_off_gcd=1,use_while_casting=1,if=((action.meteor.in_flight&action.meteor.in_flight_remains<=0.5)|!talent.meteor.enabled)&(buff.rune_of_power.up|!talent.rune_of_power.enabled)

            --if (talent.kindling and cd.memoryOfLucidDreams.remain() <= 2) or not talent.kindling then
                if ((cast.inFlight.meteor() or teorLast == true) or not talent.meteor) and (buff.runeOfPower.exists() or not talent.runeOfPower) then
                    if cast.combustion() then teorLast = false
                            dPrint("COMBUSTION!")
                        return 
                    end
                end
            --end

            -- if teorLast == true or cast.last.combustion() and not buff.heatingUp.exists() then
            --     if cast.fireBlast("target") then 
            --         dPrint("Comb fblas") 
            --        return true
            --     end
            -- end

            --potion
            --blood_fury
            --berserking
            --fireblood
            --ancestral_call

        -- Call Action List - Cooldowns
            --if actionList_Cooldowns() then return end

        -- Flamestrike
            -- flamestrike,if=((talent.flame_patch.enabled&active_enemies>2)|active_enemies>6)&buff.hot_streak.up&!azerite.blaster_master.enabled  - #enemies.yards8t - #fSEnemies

            if buff.hotStreak.exists() then
                if ((talent.flamePatch and fSEnemies > 2) or (fSEnemies >= getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) and not traits.blasterMaster.active then
                --if br.timer:useTimer("cofswait", 0.7) then
                if createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then
                    SpellStopTargeting()
                    dPrint("Comb fStrike")
                    return end
            --[[elseif ((#fSEnemies >= getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) and buff.hotStreak.exists() and not talent.pyromaniac then
                if cast.flamestrike("best",nil,1,8) then return end--]]
                --end
            end end

        -- Pyroblast
            -- pyroblast,if=buff.pyroclasm.react&buff.combustion.remains>cast_time

            if buff.pyroclasm.exists() and buff.combustion.remain() > cast.time.pyroblast() then
                if cast.pyroblast("target") then 
                    dPrint("Comb Pyro1")
                   return
                end
            end

        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.up

            if hotterStreak then
                if cast.pyroblast("target") then 
                    dPrint("Comb Pyro2")
                   return
                end
            end

        -- Pyroblast
            -- pyroblast,if=prev_gcd.1.scorch&buff.heating_up.up

            if cast.last.scorch() and --[[heatsUp or]] hotterStreak or pyroReady then --and talent.searingTouch and thp < 30 then
                if cast.pyroblast("target") then 
                    dPrint("Comb Pyro3") 
                    return true 
                end
            -- elseif cast.last.scorch(2) and buff.hotStreak.exists() then
            --     if cast.pyroblast("target") then 
            --         Print("Comb Pyro3.5") 
            --         return true 
            --     end
            end

        -- Phoenix's Flames
            -- phoenixs_flames

            if buff.combustion.exists() and not buff.hotStreak.exists() and charges.phoenixsFlames.count() > 1 then
               if cast.phoenixsFlames("target") then return end
           end

        -- Scorch
            -- scorch,if=buff.combustion.remains>cast_time&buff.combustion.up|buff.combustion.down

            if not cast.last.fireBlast() then 
                if (not buff.memoryOfLucidDreams.exists() or not buff.combustion.exists() and buff.memoryOfLucidDreams.exists() and buff.memoryOfLucidDreams.remain() < 10) and
                    not heatsUp and not pyroReady --[[or charges.fireBlast.frac() < 1.3]] or buff.combustion.remain() > cast.time.scorch() then --or not buff.combustion.exists() then
                    if cast.scorch("target") then 
                        dPrint("Comb scor1") 
                        return true 
                    end
                end
                -- elseif buff.combustion.remain() > cast.time.scorch() then --or not buff.combustion.exists() then
                --     if cast.scorch("target") then 
                --         dPrint("Comb scor1.1") 
                --         return true 
                --     end
                --end
            end

        -- Living Bomb
            -- living_bomb,if=buff.combustion.remains<gcd.max&active_enemies>1

           --  if ((#enemies.yards10t >= 1 and mode.rotation == 1) or mode.rotation == 2) and not buff.combustion.exists() then
            if (buff.combustion.remain() < gcdMax) and ((#enemies.yards6t >= 1 and mode.rotation == 1) or mode.rotation == 2) then
                if cast.livingBomb("target") then return end
            end

        -- Dragon's Breath
            -- dragons_breath,if=buff.combustion.remains<gcd.max&buff.combustion.up

            if mode.dragonsBreath == 1 then
                if (getFacing("player","target",30) and (buff.combustion.remain() < gcdMax) and buff.combustion.exists() and getDistance("target") <= 8) then
                    if cast.dragonsBreath("player","cone",1,10) then return end --dPrint("db2") return end
                elseif not buff.hotStreak.exists() then
                    if (getDistance("target") <= 8) and talent.alexstraszasFury then
                        if cast.dragonsBreath("player","cone",1,10) then return end --dPrint("db3") return end
                    end
                end
            end

        -- Scorch
            -- scorch,if=target.health.pct<=30&talent.searing_touch.enabled

            if getHP("target") <= 30 and talent.searingTouch and not buff.hotStreak.exists() then
                if cast.scorch("target") then --scorchLast = true
                    dPrint("Comb scor2") 
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
                    dPrint("RoP rop") 
                    return 
                end
            end

        -- Flamestrike
            -- flamestrike,if=((talent.flame_patch.enabled&active_enemies>1)|active_enemies>4)&buff.hot_streak.react

            if buff.hotStreak.exists() and ((talent.flamePatch and fSEnemies > 1) or (fSEnemies > getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) then
                if createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then
                    SpellStopTargeting()
                    dPrint("RoP fStrike 1")
                    return end
            end

        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.react

            if hotterStreak then
                if cast.pyroblast("target") then 
                    dPrint("RoP Pyro1") 
                    return true 
                end
            end

        -- Fire Blast
            -- fire_blast,use_off_gcd=1,use_while_casting=1,if=!(talent.flame_patch.enabled&active_enemies>2|active_enemies>5)&(!firestarter.active&cooldown.combustion.remains>0)&
            -- (!buff.heating_up.react&!buff.hot_streak.react&!prev_off_gcd.fire_blast&(action.fire_blast.charges>=2|(action.phoenix_flames.charges>=1&talent.phoenix_flames.enabled)|
            -- (talent.alexstraszas_fury.enabled&cooldown.dragons_breath.ready)|(talent.searing_touch.enabled&target.health.pct<=30)))

            if (talent.flamePatch and fSEnemies > 2 or (fSEnemies > 5 and mode.rotation == 1) or mode.rotation == 2) and (not firestarterActive and cd.combustion.remain() >= 0) and
               (not buff.heatingUp.exists() and not buff.hotStreak.exists() and not cast.last.fireBlast() and (charges.fireBlast.count() >= 2 or (charges.phoenixsFlames.count() >= 1 and talent.phoenixsFlames) or
               (talent.alexstraszasFury and cd.dragonsBreath.remain() == 0) or (talent.searingTouch and thp <= 30))) then
                if cast.fireBlast("target") then
                    dPrint("RoP fblast1")
                    return true
                end
            end

        -- Call Action List - Active Talents
            -- call_action_list,name=active_talents

            --if not playerCasting then
            if actionList_ActiveTalents() then dPrint("RoP Talents") return end --end

        -- Pyroblast
            -- pyroblast,if=buff.pyroclasm.react&cast_time<buff.pyroclasm.remains&buff.rune_of_power.remains>cast_time

            if talent.pyroclasm and buff.pyroclasm.exists() and cast.time.pyroblast() < buff.pyroclasm.remain() and buff.runeOfPower.remain() > cast.time.runeOfPower() then
                if cast.pyroblast("target") then 
                    dPrint("RoP Pyro2") 
                    return true 
                end
            end

        -- Fire Blast
            -- fire_blast,use_off_gcd=1,use_while_casting=1,if=!(talent.flame_patch.enabled&active_enemies>2|active_enemies>5)&(!firestarter.active&cooldown.combustion.remains>0)&(buff.heating_up.react&(target.health.pct>=30|!talent.searing_touch.enabled))

            if not (talent.flamePatch and fSEnemies > 2 or (fSEnemies > 5 and mode.rotation == 1) or mode.rotation == 2) and (not firestarterActive and cd.combustion.remain() > 1) and (buff.heatingUp.exists() and (thp >= 30 or not talent.searingTouch)) then
                if cast.fireBlast("target") then --fblastLast = true
                    dPrint("RoP fBlast2") 
                    return true 
                end
            end

        -- Fire Blast
            -- fire_blast,use_off_gcd=1,use_while_casting=1,if=!(talent.flame_patch.enabled&active_enemies>2|active_enemies>5)&(!firestarter.active&cooldown.combustion.remains>0)&talent.searing_touch.enabled&target.health.pct<=30&

            -- (buff.heating_up.react&!action.scorch.executing|!buff.heating_up.react&!buff.hot_streak.react)
            if not (talent.flamePatch and fSEnemies > 2 or (fSEnemies > 5 and mode.rotation == 1) or mode.rotation == 2) and (not firestarterActive and cd.combustion.remain() >= 0) and talent.searingTouch and thp <= 30 and
                (buff.heatingUp.exists() and not cast.current.scorch() or not buff.heatingUp.exists() and not buff.hotStreak.exists()) then
                if cast.fireBlast("target") then --fblastLast = true
                    dPrint("RoP fBlast3") 
                    return true 
                end
            end

        -- Pyroblast
            -- pyroblast,if=prev_gcd.1.scorch&buff.heating_up.up&talent.searing_touch.enabled&target.health.pct<=30&(!talent.flame_patch.enabled|active_enemies=1)

            if cast.last.scorch() and heatsUp and talent.searingTouch and thp <= 30 and pyroReady and (not talent.flamePatch or fSEnemies == 1) then
                if cast.pyroblast("target") then 
                    dPrint("RoP Pyro3") 
                    return true 
                end
            end

        -- Phoenix's Flames
            -- phoenix_flames,if=!prev_gcd.1.phoenix_flames&buff.heating_up.react

            if not cast.last.phoenixsFlames() and buff.heatingUp.exists() then
                if cast.phoenixsFlames("target") then dPrint("RoP phoenixflames") return end
            end

        -- Scorch
            -- scorch,if=target.health.pct<=30&talent.searing_touch.enabled

            if thp <= 30 and talent.searingTouch then
                if cast.scorch("target") then --scorchLast = true
                    dPrint("RoP scor1") 
                    return 
                end
            end

        -- Dragon's Breath
            --dragons_breath,if=active_enemies>2

            if mode.dragonsBreath == 1 then
                if #enemies.yards8t > 2 and ((getFacing("player","target",30) and mode.rotation == 1) or mode.rotation == 2) and getDistance("target") <= 8 then
                    if cast.dragonsBreath("player","cone",1,10) then --[[Print("db4")--]] return end
                elseif #enemies.yards8t > 2 and talent.alexstraszasFury then
                    if ((getDistance("target") <= 8) and mode.rotation == 1) then
                        if cast.dragonsBreath("player","cone",1,10) then --[[Print("db5")--]] return end
                    end
                end
            end

        -- Fireblast
            -- fire_blast,use_off_gcd=1,use_while_casting=1,if=(talent.flame_patch.enabled&active_enemies>2|active_enemies>5)&(cooldown.combustion.remains>0&!firestarter.active)&
            -- buff.hot_streak.down&(!azerite.blaster_master.enabled|buff.blaster_master.remains<0.5)

            if (talent.flamePatch and fSEnemies > 2 or (fSEnemies > 5 and mode.rotation == 1) or mode.rotation == 2) and (cd.combustion.remain() >= 0 and not firestarterActive)
            and buff.hotStreak.exists() and (not traits.blasterMaster.active or buff.blasterMaster.remain() < 0.5) then
                if cast.fireBlast("target") then --fblastLast = true
                    dPrint("RoP fBlast4") 
                    return true 
                end
            end

        -- Flamestrike
            -- flamestrike,if=(talent.flame_patch.enabled&active_enemies>2)|active_enemies>5 - #enemies.yards8t - #fSEnemies

            if --[[buff.hotStreak.exists() and]] ((talent.flamePatch and fSEnemies > 2) or (fSEnemies > 5 and mode.rotation == 1) or mode.rotation == 2) then
            if createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then
                SpellStopTargeting()
                dPrint("RoP fStrike 2")
                    return end
            end

        -- Fireball
            -- fireball

            if not moving then
                if (not buff.memoryOfLucidDreams.exists() or buff.memoryOfLucidDreams.exists() and buff.memoryOfLucidDreams.remain() < 10) and not buff.combustion.exists() then --and not cast.current.fireball() then
                    if cast.fireball("target") then --fballLast = true
                        --dPrint("RoP FB")
                        return 
                    end
                end
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

            if buff.hotStreak.exists() and ((talent.flamePatch and fSEnemies > 1 and not firestarterActive) or (fSEnemies >= getOptionValue("Flamestrike Targets") and mode.rotation == 1) or mode.rotation == 2) then
                if createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then
                    SpellStopTargeting() 
                --if cast.flamestrike("best",nil,1,8) then return end
                dPrint("ST fStrike1")
                    return end
            end

            if br.timer:useTimer("stfswait", 0.56) then return end

        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.up&buff.hot_streak.remains<action.fireball.execute_time

            if buff.hotStreak.exists() and buff.hotStreak.remain() < cast.time.fireball() or buff.hotStreak.exists() and cast.current.scorch() and thp > 30 then
                if cast.pyroblast("target") then 
                    dPrint("ST Pyro1") 
                    return --true 
                end
            end

        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.react&(prev_gcd.1.fireball|firestarter.active|action.pyroblast.in_flight)

            if buff.hotStreak.exists() and (cast.last.fireball() or fballLast --[[or cast.last.fireBlast() and charges.fireBlast.frac() > 0.75]] or firestarterActive or (cast.inFlight.pyroblast() or cast.last.pyroblast())) then
                --if br.timer:useTimer("stfswait", 0.56) then
                    if cast.pyroblast("target") then fballLast = false
                            dPrint("ST Pyro2") 
                            return --true 
                    end
                --end
            end

        -- Phoenix's Flames
            -- phoenix_flames,if=charges>=3&active_enemies>2&!variable.phoenix_pooling

            if charges.phoenixsFlames.count() >= 3 and fSEnemies > 2 and not phoenixPool then
                if cast.phoenixsFlames("target") then return end
            end

        -- Pyroblast
            -- pyroblast,if=buff.hot_streak.react&target.health.pct<=30&talent.searing_touch.enabled

            if buff.hotStreak.exists() and thp <= 30 and talent.searingTouch and pyroReady then
                if cast.pyroblast("target") then 
                    dPrint("ST Pyro3") 
                    return 
                end

            -- pyroblast,if=buff.pyroclasm.react&cast_time<buff.pyroclasm.remains

            elseif buff.pyroclasm.exists() and cast.time.pyroblast() < buff.pyroclasm.remain() then
                if cast.pyroblast("target") then 
                    dPrint("ST Pyro4") 
                    return 
                end
            end

        -- Fire Blast
            -- if=(cooldown.combustion.remains>0&buff.rune_of_power.down&!firestarter.active)&!talent.kindling.enabled&!variable.fire_blast_pooling&(((action.fireball.executing|action.pyroblast.executing)&(buff.heating_up.react))|
            -- (talent.searing_touch.enabled&target.health.pct<=30&(buff.heating_up.react&!action.scorch.executing|!buff.hot_streak.react&!buff.heating_up.react&action.scorch.executing&!action.pyroblast.in_flight&!action.fireball.in_flight)))

            if mode.fireBlast == 1 then
                if not cast.last.fireBlast() and
                    (cd.combustion.remain() >= 0 and not buff.runeOfPower.exists() and not firestarterActive) and not talent.kindling and not fBlastCombSave and not fireBlastPool and ((cast.current.fireball() or cast.current.pyroblast()) and buff.heatingUp.exists()) or
                    (talent.searingTouch and thp <= 30 and (buff.heatingUp.exists() and not cast.current.scorch() or not buff.hotStreak.exists() and not buff.heatingUp.exists() and cast.current.scorch() and not cast.inFlight.pyroblast() and not cast.inFlight.fireball()))
                then
                    if cast.fireBlast("target") then
                        dPrint("ST Fblast1")
                        return
                    end
                end
            end

        -- Fire Blast
            -- fire_blast,if=talent.kindling.enabled&buff.heating_up.react&!firestarter.active&(cooldown.combustion.remains>full_recharge_time+2+talent.kindling.enabled|
            -- (!talent.rune_of_power.enabled|cooldown.rune_of_power.remains>target.time_to_die&action.rune_of_power.charges<1)&cooldown.combustion.remains>target.time_to_die)

            if mode.fireBlast == 1 then
                if talent.kindling and buff.heatingUp.exists() and not firestarterActive and (cd.combustion.remain() > charges.fireBlast.timeTillFull() + 2 + kindle or
                (not talent.runeOfPower or cd.runeOfPower.remain() > ttd("target") and charges.runeOfPower.count() < 1) and cd.combustion.remain() > ttd("target")) then
                    if cast.fireBlast("target") then 
                        dPrint("ST Fblast2") 
                        return --true 
                    end
                end
            end

        -- PyroBlast
            --pyroblast,if=prev_gcd.1.scorch&buff.heating_up.up&talent.searing_touch.enabled&target.health.pct<=30&((talent.flame_patch.enabled&active_enemies=1&!firestarter.active)|(active_enemies<4&!talent.flame_patch.enabled))

            if cast.last.scorch() and heatsUp and talent.searingTouch and thp <= 30 and pyroReady and ((talent.flamePatch and fSEnemies == 1 and not firestarterActive) or (fSEnemies < getOptionValue("Flamestrike Targets") and not talent.flamePatch)) then --or pyroReady and thp <= 30 then
                if cast.pyroblast("target") then
                    scorchLast = false
                    --scorch2Last = false
                    dPrint("ST Pyro5") 
                    return 
                end

            -- elseif cast.last.scorch() and buff.hotStreak.exists() and ((talent.flamePatch and fSEnemies == 1 and not firestarterActive) or (fSEnemies < getOptionValue("Flamestrike Targets") and not talent.flamePatch)) then
            --     if cast.pyroblast("target") then
            --         Print("ST Pyro5.5") 
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
                dPrint("ST Talents")
                return end
            --end

        -- Dragon's Breath
            --dragons_breath,if=active_enemies>1

            if mode.dragonsBreath == 1 then
                if #enemies.yards8t > 1 and ((getFacing("player","target",30) and mode.rotation == 1) or mode.rotation == 2) and getDistance("target") <= 8 then
                    if cast.dragonsBreath("player","cone",1,10) then --[[Print("db4")--]] return end
                elseif #enemies.yards8t > 1 and talent.alexstraszasFury then
                    if ((getDistance("target") <= 8) and mode.rotation == 1) then
                        if cast.dragonsBreath("player","cone",1,10) then --[[Print("db5")--]] return end
                    end
                end
            end

        -- Call Action List - Low Prio

            if useCDs() then
                if actionList_ItemsLowPrio() then return end
            end

        -- Scorch
            -- scorch,if=target.health.pct<=30&talent.searing_touch.enabled

            if thp <= 30 and talent.searingTouch then
                if cast.scorch("target") then scorchLast = true
                    --Print("ST Scor") 
                    return 
                end
            end

            --if scorchLast then scorch2Last = true return end
            --if scorchLast then Print("scorch2 true") return end
        -- Fire Blast
           -- fire_blast,use_off_gcd=1,use_while_casting=1,if=(talent.flame_patch.enabled&active_enemies>2|active_enemies>9)&(cooldown.combustion.remains>0&!firestarter.active)&buff.hot_streak.down&(!azerite.blaster_master.enabled|buff.blaster_master.remains<0.5)

            if mode.fireBlast == 1 then
                if (talent.flamePatch and fSEnemies > 2 or ((fSEnemies > 9 and mode.rotation == 1) or mode.rotation == 2)) and (cd.combustion.remain() >= 0 and not firestarterActive) and not buff.hotStreak.exists() and (not traits.blasterMaster.active or buff.blasterMaster.remain() < 0.5) then
                    if cast.fireBlast("target") then
                        dPrint("ST Fblast3")
                        return
                    end
                end
            end

        -- Flamestrike
            -- flamestrike,if=talent.flame_patch.enabled&active_enemies>2|active_enemies>9
            if (not moving or pyroReady) then
            if talent.flamePatch and fSEnemies > 2 or ((fSEnemies > 9 and mode.rotation == 1) or mode.rotation == 2) then
                if createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then
                    SpellStopTargeting()
                    dPrint("ST fStrike 2")
                    return end
            end end

        -- Fireball
            -- fireball

            if not moving then 
                if (not buff.memoryOfLucidDreams.exists() or buff.memoryOfLucidDreams.exists() and buff.memoryOfLucidDreams.remain() < 10) and (not buff.combustion.exists() and
                    not cast.last.combustion()) and (not buff.runeOfPower.exists() and not cast.last.runeOfPower()) then --and not cast.current.fireball() then ----[[and not buff.heatingUp.exists()--]] and not buff.hotStreak.exists() then --]]
                    if cast.fireball("target") then fballLast = true
                        --dPrint("ST fBall")
                    return end
                end
            end

        -- Scorch

            if IsMovingTime(mrdm(10,20)/100) then
                if cast.scorch("target") then
                    --Print("ST sco")
                return end
            end

        end  -- End BfA Single Target Action List

---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or IsMounted() or pause(true) --[[or cast.current.focusedAzeriteBeam() or or isCastingSpell(296971) or cast.current.latentArcana()]] or mode.rotation==4 then
            if buff.heatingUp.exists() --[[and not hasBuff(296962)]] and not fBlastCombSave and not buff.combustion.exists() then --and cd.combustion.remain() > 16 then
                if cast.fireBlast("target") then dPrint("Pause fBlast") return end
            end
            -- if buff.runeOfPower.exists() or buff.memoryOfLucidDreams.exists() then
            --     if cast.combustion("player") then dPrint("Pause Comb") return end
            -- end
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
            if inCombat and profileStop==false and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 --[[and (timedPull == true or soloPull == true)]] and not cast.current.focusedAzeriteBeam() and not cast.current.latentArcana() --[[or not isCastingSpell(293491)]] then
   
            --end
                    
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    ----------------------
    --- SimC BfA APL ---
    ----------------------
                if getOptionValue("APL Mode") == 1 then
        -- High Prio Item List
                    if useCDs() then
                        if actionList_ItemsHighPrio() then dPrint("HighPrioItems") return end
                    end
        -- Mirror Image
                    -- mirror_image,if=buff.combustion.down
                    if useCDs() and isChecked("Mirror Image") and not buff.combustion.exists() then
                        if cast.mirrorImage() then return end
                    end
        -- Guardian of Azeroth
                    --guardian_of_azeroth,if=cooldown.combustion.remains<10|target.time_to_die<cooldown.combustion.remains
                    if azerothsGuard and cast.able.guardianOfAzeroth() then
                        if cd.combustion.remain() < 10 or ttd < cd.combustion.remain() then
                            if cast.guardianOfAzeroth("player") then dPrint("guardian") return end
                        end
                    end

        -- Focused Azerite Beam
                    --focused_azerite_beam
                    if focusedBeam then
                        if (getDistance("target") <= 16 and ((fSEnemies >= getOptionValue("Focused Beam Targets") and mode.rotation == 1) or mode.rotation == 2)) or (getDistance("target") <= 16 and isBoss()) then
                            if cast.focusedAzeriteBeam("player") then dPrint("Focused Beam") return end
                        end
                    end

        -- Rune of Power
                    -- rune_of_power,if=talent.firestarter.enabled&firestarter.remains>full_recharge_time|cooldown.combustion.remains>variable.combustion_rop_cutoff&buff.combustion.down|target.time_to_die<cooldown.combustion.remains&buff.combustion.down
                     if useCDs() and not moving then
                        if talent.firestarter and firestarterremain > charges.runeOfPower.timeTillFull() or cd.combustion.remain() > combustionROPcutoff and not buff.combustion.exists() or ttd("target") < cd.combustion.remain() and not buff.combustion.exists() or disable_combustion then
                            if cast.runeOfPower("player") then 
                                --Print("RoP") 
                                return 
                            end
                        end
                    end
        -- Action List - Combustion Phase
                    -- combustion_phase,if=(talent.rune_of_power.enabled&cooldown.combustion.remains<=action.rune_of_power.cast_time|cooldown.combustion.ready)&!firestarter.active|buff.combustion.up
                    if useCDs() and not moving then --and (not traits.blasterMaster.active or lucisDreams) then --or not talent.flameOn) then --and firestarterInactive then 
                        if not disable_combustion and (talent.runeOfPower and cd.combustion.remain() <= cast.time.runeOfPower() or cd.combustion.remain() == 0) and not firestarterActive or buff.combustion.exists() then
                            if actionList_CombustionPhase() then 
                                ChatOverlay("Combustion Phase") 
                                return 
                            end
                        end
                    end
        -- Action - Fireblast
                    -- fire_blast,use_while_casting=1,use_off_gcd=1,if=(essence.memory_of_lucid_dreams.major|essence.memory_of_lucid_dreams.minor&azerite.blaster_master.enabled)&
                    -- charges=max_charges&!buff.hot_streak.react&!(buff.heating_up.react&(buff.combustion.up&(action.fireball.in_flight|action.pyroblast.in_flight|action.scorch.executing)|
                    -- target.health.pct<=30&action.scorch.executing))&!(!buff.heating_up.react&!buff.hot_streak.react&buff.combustion.down&(action.fireball.in_flight|action.pyroblast.in_flight))
                    if (lucisDreams or traits.blasterMaster.active) and (not isBoss() or not isDummy() or thp <= 90) and not fBlastCombSave and
                       charges.fireBlast.count() == 3 and not buff.hotStreak.exists() and not (buff.heatingUp.exists() and (buff.combustion.exists() and (cast.inFlight.fireball() or cast.inFlight.pyroblast() or cast.current.scorch()) or
                       thp <= 30 and cast.current.scorch)) and not (not buff.heatingUp.exists() and not buff.hotStreak.exists() and not buff.combustion.exists() and (cast.inFlight.fireball() or cast.inFlight.pyroblast())) then
                        if cast.fireBlast("target") then
                            dPrint("Fblast1")
                            return
                        end
                    end
        -- Action - Fireblast
                    -- fire_blast,use_while_casting=1,use_off_gcd=1,if=firestarter.active&charges>=1&(!variable.fire_blast_pooling|buff.rune_of_power.up)&
                    -- (!azerite.blaster_master.enabled|buff.blaster_master.remains<0.5)&
                    -- (!action.fireball.executing&!action.pyroblast.in_flight&buff.heating_up.up|action.fireball.executing&buff.hot_streak.down|action.pyroblast.in_flight&buff.heating_up.down&buff.hot_streak.down)
                    if firestarterActive and charges.fireBlast.count() == 1 and (not fireBlastPool or buff.runeOfPower.exists()) and
                       (not traits.blasterMaster.active or buff.blasterMaster.remain() < 0.5) and
                       (not cast.current.fireball() and not cast.inFlight.pyroblast() and buff.heatingUp.exists() or cast.current.fireball() and not buff.hotStreak.exists() or cast.inFlight.pyroblast() and not buff.heatingUp.exists() and not buff.hotStreak.exists()) then
                        if cast.fireBlast("target") then
                            dPrint("Fblast2")
                            return
                        end
                    end
        -- Action List - Rune of Power Phase
                    -- rop_phase,if=buff.rune_of_power.up&buff.combustion.down
                    if buff.runeOfPower.exists() and not buff.combustion.exists() then --and not moving then
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
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})