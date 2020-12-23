local rotationName = "Winstonv8"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.shadowform },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.mindSear },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mindFlay },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.shadowMend}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.mindBlast },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.mindBlast },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.mindBlast }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dispersion },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dispersion }
    };
    CreateButton("Defensive",3,0)
    -- Void Form Button
    VoidFormModes = {
        [1] = { mode = "On", value = 1 , overlay = "Void Form Enabled", tip = "Bot will shift to Void Form.", highlight = 1, icon = br.player.spell.voidEruption },
        [2] = { mode = "Off", value = 2 , overlay = "Void Form Disabled", tip = "Bot will NOT shift to Void Form.", highlight = 0, icon = br.player.spell.voidEruption }
    };
    CreateButton("VoidForm",4,0)
    -- Interrupt button
    InterruptToggleModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.silence},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.silence}
    };
    CreateButton("InterruptToggle",5,0)
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
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  1,  1,  60,  1,  "Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "Set to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Body and Soul
            br.ui:createCheckbox(section,"PWS: Body and Soul")
            -- Auto Buff Fortitude
            br.ui:createCheckbox(section,"Power Word: Fortitude", "Check to auto buff Fortitude on party.")
            -- Out of Combat Attack
            br.ui:createCheckbox(section,"Pull OoC", "Check to Engage the Target out of Combat.")
             -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Endless Fathoms","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "Set Elixir to use.")
            -- Mouseover Dotting
            br.ui:createCheckbox(section,"Mouseover Dotting")
            -- SWP before VT
            br.ui:createCheckbox(section,"SWP b4 VT", "Check to dot SWP before VT.")
            -- Use 1st Trinket off CD
            --br.ui:createCheckbox(section,"Trinket 1 Off CD", "Use Trinket  1 off Cooldown. Might Overrides individual trinket usage below.")
            --br.ui:createCheckbox(section,"Trinket 2 Off CD", "Use Trinket  1 off Cooldown. Might Overrides individual trinket usage below.")
        br.ui:checkSectionState(section)
        -- AoE Options
        section = br.ui:createSection(br.ui.window.profile, "AoE Options")
            -- Shadow Crash
            br.ui:createCheckbox(section,"Shadow Crash")
            -- SWP Max Targets
            br.ui:createSpinnerWithout(section, "SWP Max Targets",  3,  1,  7,  1, "Unit Count Limit that SWP will be cast on.")
            -- VT Max Targets
            br.ui:createSpinnerWithout(section, "VT Max Targets",  3,  1,  7,  1, "Unit Count Limit that VT will be cast on.")
            -- Mind Sear Targets
            br.ui:createSpinnerWithout(section, "Mind Sear Targets",  2,  2,  10,  1, "Unit Count Limit before Mind Sear is being used.")
            -- Dark Void Targets
            br.ui:createSpinnerWithout(section, "Dark Void Targets",  5,  1,  10,  1, "Unit Count Limit before Dark Void is being used.")
            -- Dark Ascension AoE
            br.ui:createSpinner(section, "Dark Ascension AoE",  5,  1,  10,  1, "Use DA as AoE Damage Burst at desired Unit Count Limit.")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Int Pot
            br.ui:createCheckbox(section,"Int Pot")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinket 1", "Use Trinket 1 on Cooldown.")
            br.ui:createCheckbox(section,"Trinket 2", "Use Trinket 2 on Cooldown.")
            -- Dark Ascension
            --if hasTalent(darkAscension) then
            br.ui:createCheckbox(section,"Dark Ascension", "Use Dark Ascension as Insanity Boost")
            -- Dark Ascension Burst
            br.ui:createCheckbox(section,"Dark Ascension Burst", "Use Dark Ascension for another Void Form Burst")
            -- Memory of Lucid Dreams
            br.ui:createCheckbox(section,"Lucid Dreams", "Use Memory of Lucid Dreams Essence")
            br.ui:createSpinnerWithout(section, "  Lucid Dreams VF Stacks",  20,  1,  50,  1, "Voidform Stacks when to use Lucid Dreams.")
            br.ui:createSpinnerWithout(section, "  Lucid Dreams Insanity",  50,  25,  100,  1, "Insanity Power when to use Lucid Dreams.")
            -- Shadowfiend
            br.ui:createCheckbox(section, "Shadowfiend / Mindbender", "Use Shadowfiend or Mindbender on CD")
            br.ui:createSpinner(section, "  Mindbender in VF", 10, 0, 50, 1, "Set to desired Void Form stacks to use at.")
            -- Surrender To Madness
            br.ui:createCheckbox(section,"Surrender To Madness")
            -- Dispersion
            --br.ui:createCheckbox(section, "Dispersion S2M")
            --br.ui:createSpinnerWithout(section, "  Dispersion Stacks", 10, 5, 100, 5, "Set to desired Void Form stacks to use at.")
            -- Void Torrent
            br.ui:createCheckbox(section,"Void Torrent")
            --br.ui:createSpinnerWithout(section, "  Void Torrent Stacks", 0, 0, 100, 1, "Set to desired Void Form stacks to use at.")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "Health Percentage to use at.")
            -- Gift of The Naaru
            --if br.player.race == "Draenei" then
            --    br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "Health Percent to Cast At")
            --end
            --if br.player.race == "Dwarf" then
            --    br.ui:createSpinner(section, "Stoneform",  50,  0,  100,  5,  "Health Percent to Cast At")
            --end
            -- Dispel Magic
            br.ui:createCheckbox(section,"Dispel Magic")
            -- Dispersion
            br.ui:createSpinner(section, "Dispersion",  20,  0,  100,  5,  "Health Percentage to use at.")
            -- Fade
            br.ui:createCheckbox(section, "Fade")
            -- Vampiric Embrace
            br.ui:createSpinner(section, "Vampiric Embrace",  25,  0,  100,  5,  "Health Percentage to use at.")
            -- Power Word: Shield
            br.ui:createSpinner(section, "Power Word: Shield",  60,  0,  100,  5,  "Health Percentage to use at.")
            -- Shadow Mend
            br.ui:createSpinner(section, "Shadow Mend",  60,  0,  100,  5,  "Health Percentage to use at.")
            -- Psychic Scream / Mind Bomb
            br.ui:createSpinner(section, "Psychic Scream / Mind Bomb",  40,  0,  100,  5,  "Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Silence
            br.ui:createCheckbox(section, "Silence")
            -- Psychic Horror
            br.ui:createCheckbox(section, "Psychic Horror")
            -- Psychic Scream
            br.ui:createCheckbox(section, "Psychic Scream")
            -- Mind Bomb
             br.ui:createCheckbox(section, "Mind Bomb")
            -- Interrupt Target
            --br.ui:createDropdownWithout(section,"Interrupt Unit", {"1. All in Range", "2. Target", "3. Focus"}, 1, "Interrupt your focus, your target, or all enemies in range.")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  45,  0,  95,  5,  "Cast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            -- Void Form
            br.ui:createDropdown(section, "Void Form Mode", br.dropOptions.Toggle,  6)
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
    --if br.timer:useTimer("debugShadow", 0.1) then
        --Print("Running: "..rotationName)    
---------------
--- Toggles ---
---------------
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("VoidForm",0.25)
    UpdateToggle("Interrupt",0.25)
    br.player.ui.mode.voidForm = br.data.settings[br.selectedSpec].toggles["VoidForm"]
    --br.player.ui.mode.interruptToggle = br.data.settings[br.selectedSpec].toggles["InterruptToggle"]
--------------
--- Locals ---
--------------
    local addsExist                                     = false
    local addsIn                                        = 999
    local artifact                                      = br.player.artifact
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local castable                                      = br.player.cast.debug
    local channelDelay                                  = 0.1
    local combatTime                                    = getCombatTime()
    local cd                                            = br.player.cd
    local charges                                       = br.player.charges
    local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
    local debuff                                        = br.player.debuff
    local enemies                                       = br.player.enemies
    local essence                                       = br.player.essence
    local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
    local friendly                                      = friendly or GetUnitIsFriend("target", "player")
    local gcd                                           = br.player.gcd
    local gcdMax                                        = br.player.gcdMax
    local gHaste                                        = br.player.gcdMax / (1 + GetHaste() / 100)
    local healPot                                       = getHealthPot()
    local hasMouse                                      = GetObjectExists("mouseover")
    local inCombat                                      = br.player.inCombat
    local inInstance                                    = br.player.instance=="party"
    local inRaid                                        = br.player.instance=="raid"
    local item                                          = br.player.items
    local level                                         = br.player.level
    local lootDelay                                     = getOptionValue("LootDelay")
    local lowestHP                                      = br.friend[1].unit
    local mode                                          = br.player.ui.mode
    local moveIn                                        = 999
    local moving                                        = (isMoving("player") and not br.player.buff.norgannonsForesight.exists() and not br.player.buff.surrenderToMadness.exists())
    local mrdm                                          = math.random
    local perk                                          = br.player.perk
    local pHaste                                        = 1 / (1 + GetHaste() / 100)
    local php                                           = br.player.health
    local playerMouse                                   = UnitIsPlayer("mouseover")
    local power, powmax, powgen, powerDeficit           = br.player.power.insanity.amount(), br.player.power.insanity.max(), br.player.power.insanity.regen(), br.player.power.insanity.deficit()
    local pullTimer                                     = br.DBM:getPulltimer()
    local racial                                        = br.player.getRacial()
    local solo                                          = #br.friend < 2
    local spell                                         = br.player.spell
    local t18_2pc                                       = TierScan("T18")>=2
    local t19_2pc                                       = TierScan("T19")>=2
    local t19_4pc                                       = TierScan("T19")>=4
    local t20_4pc                                       = TierScan("T20")>=4
    local t21_4pc                                       = TierScan("T21")>=4
    local talent                                        = br.player.talent
    local traits                                        = br.player.traits
    local thp                                           = getHP("target")
    local ttd                                           = getTTD
    local ttm                                           = br.player.power.insanity.ttm()
    local units                                         = br.player.units
    local use                                           = br.player.use
 
    local chgMax                                        = max(0.75, 1.5 * 2 / (1 + GetHaste() / 100))
    local DAmaxTargets                                  = getOptionValue("Dark Ascension AoE")
    local MSmaxTargets                                  = getOptionValue("Mind Sear Targets")
    local SWPmaxTargets                                 = getOptionValue("SWP Max Targets")
    local VTmaxTargets                                  = getOptionValue("VT Max Targets")
    local mindFlayRecast                                = br.timer:useTimer("mindFlayRecast", chgMax)
    local mindSearRecast                                = br.timer:useTimer("mindSearRecast", chgMax)

    local executeHP = 20

    units.get(5)
    units.get(8)
    units.get(12)
    units.get(15)
    units.get(30)
    units.get(40)
    enemies.get(5)
    enemies.get(8)
    enemies.get(8,"target")
    enemies.get(12)
    enemies.get(15)
    enemies.get(15, "target")
    enemies.get(20)
    enemies.get(20, "target")
    enemies.get(30)
    enemies.get(40)
    enemies.get(40, "target")

    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end

    if cmbLast == nil or not UnitExists(units.dyn40) then cmbLast = UnitGUID("player") end
    if cmvtLast == nil or not UnitExists(units.dyn40) then cmvtLast = UnitGUID("player") end
    if cmvtaLast == nil or not UnitExists(thisUnit) then cmvtaLast = UnitGUID("player") end
    if cswpb4vtLast == nil or not UnitExists(units.dyn40) then cswpb4vtLast = UnitGUID("player") end
    if cswvLast == nil or not UnitExists(units.dyn40) then cswvLast = UnitGUID("player") end
    if cvtaLast == nil or not UnitExists(thisUnit) then cvtaLast = UnitGUID("player") end
    if cvtLast == nil or not UnitExists(units.dyn40) then cvtLast = UnitGUID("player") end
    if mbLast == nil or not UnitExists("target") then mbLast = UnitGUID("player") end
    if mvtLast == nil or not UnitExists("target") then mvtLast = UnitGUID("player") end
    if pmbLast == nil or not UnitExists("target") then pmbLast = UnitGUID("player") end
    if pswvLast == nil or not UnitExists("target") then pswvLast = UnitGUID("player") end
    if pvtLast == nil or not UnitExists("target") then pvtLast = UnitGUID("player") end
    if swpb4vtLast == nil or not UnitExists(units.dyn40) then swpb4vtLast = UnitGUID("player") end
    if swvLast == nil or not UnitExists("target") then swvLast = UnitGUID("player") end
    if vtLast == nil or not UnitExists("target") then vtLast = UnitGUID("player") end
    if vtVFLast == nil or not UnitExists("target") then vtVFLast = UnitGUID("player") end

    -- if HackEnabled("NoKnockback") ~= nil then HackEnabled("NoKnockback", false) end

    --if t19_2pc then t19pc2 = 1 else t19pc2 = 0 end
    --if t20_4pc then t20pc4 = 1 else t20pc4 = 0 end
    --if t21_4pc then t21pc4 = 1 else t21pc4 = 0 end
    if hasBloodLust() then lusting = 1 else lusting = 0 end
    if talent.auspiciousSpirits then auspiciousSpirits = 1 else auspiciousSpirits = 0 end
    if talent.fortressOfTheMind then fortressOfTheMind = 1 else fortressOfTheMind = 0 end
    if talent.legacyOfTheVoid then legacyOfTheVoid = 1 else legacyOfTheVoid = 0 end
    if talent.lingeringInsanity then lingeringInsanity = 1 else lingeringInsanity = 0 end
    if talent.mindbender then mindbender = 1 else mindbender = 0 end
    if talent.sanlayn then sanlayn = 1 else sanlayn = 0 end
    --if hasEquiped(132864) then mangaMad = 1 else mangaMad = 0 end
    if #enemies.yards40 == 1 then singleEnemy = 1 else singleEnemy = 0 end
    local raidMovementWithin15 = 0   -- trying to come up with a clever way to manage this, maybe a toggle or something. For now, just assume we always have to move soon

    -- searEnemmies represents the number of enemies in mind sear range of the primary target.
    local activeEnemies = #enemies.yards20t
    local dAEnemies = getEnemies(units.dyn40, 8, true)
    local dVEnemies = getEnemies(units.dyn40, 8, true)
    local searEnemies = getEnemies(units.dyn40, 8, true)

    if mode.rotation == 3 then
        activeEnemies = 1
        MSmaxTargets = 1
        SWPmaxTargets = 1
        VTmaxTargets = 1
    end

    --print(tostring(cast.able.voidBolt()))

    -- Keep track of Drain Stacks
    -- Drain stacks will be equal to Voidform stacks, minus any time spent in diepersion and minus any time spent channeling void torrent
    if buff.voidForm.stack() == 0 then
        nonDrainTicks = 0
        drainStacks = 0
    else
        if inCombat and (buff.dispersion.exists() or buff.voidTorrent.exists()) then
            if br.timer:useTimer("drainStacker", 1) then
                nonDrainTicks = nonDrainTicks + 1
            end
        end
        drainStacks = buff.voidForm.stack() - nonDrainTicks
    end

    -- Insanity Drain
    insanityDrain = 6 + (0.68 * (drainStacks))
    --insanityDrained = insanityDrain + (15.6 * gcdMax)
    insanityDrained = insanityDrain * gcdMax * 3

    local lucisDreams = essence.memoryOfLucidDreams.active

    local dotsUp = debuff.shadowWordPain.exists() and debuff.vampiricTouch.exists()
    local dotsTick = debuff.shadowWordPain.remain() > 4.3 and debuff.vampiricTouch.remain() > 4.3
    local noHarvest = not buff.harvestedThoughts.exists() and not cast.current.mindSear()
    local noSdHarvest = not traits.searingDialogue.active and not cast.current.mindSear()
    local noTH = noHarvest or noSdHarvest
    local SWPb4VT = isChecked("SWP b4 VT") --or debuff.shadowWordPain.exists()
    local mindblastTargets = math.floor((4.5 + traits.whispersOfTheDamned.rank) / (1 + 0.27 * traits.searingDialogue.rank))
    local swp_trait_ranks_check = (1 - 0.07 * traits.deathThroes.rank + 0.2 * traits.thoughtHarvester.rank) * (1 - 0.09 * traits.thoughtHarvester.rank * traits.searingDialogue.rank)
    local vt_trait_ranks_check = (1 - 0.04 * traits.thoughtHarvester.rank - 0.05 * traits.spitefulApparitions.rank)
    local vt_mis_trait_ranks_check = (1 - 0.07 * traits.deathThroes.rank - 0.03 * traits.thoughtHarvester.rank - 0.055 * traits.spitefulApparitions.rank) * (1 - 0.27 * traits.thoughtHarvester.rank * traits.searingDialogue.rank)
    local vt_mis_sd_check = 1 - 0.014 * traits.searingDialogue.rank

    --Clear last cast table ooc to avoid strange casts
    if not inCombat and #br.lastCast.tracker > 0 then
        wipe(br.lastCast.tracker)
    end

--------------------
--- Action Lists ---
--------------------
-- Action list - Extras
    function actionList_Extra()
        -- Dispel Magic
        if isChecked("Dispel Magic") and canDispel("target",spell.dispelMagic) and not isBoss() and GetObjectExists("target") then
            if cast.dispelMagic() then return end
        end
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
    end -- End Action List - Extra
-- Action List - Defensive
    function actionList_Defensive()
        if mode.defensive == 1 and getHP("player")>0 then
            -- Pot/Stoned
                if isChecked("Healthstone") and php <= getOptionValue("Healthstone") 
                    and inCombat and (hasHealthPot() or hasItem(5512)) 
                then
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(healPot) then
                        useItem(healPot)
                    end
                end
            -- Gift of the Naaru
            --[[if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race=="Draenei" then
                if castSpell("player",racial,false,false,false) then return end
            end--]]
            -- Psychic Scream / Mind Bomb
            if isChecked("Vampiric Embrace") and inCombat and php <= getOptionValue("Vampiric Embrace") then
                if #enemies.yards40 > 0 then
                    if cast.vampiricEmbrace("player") then return end
                end
            end
            --[[ Stoneform - Dwarf racial
            if isChecked("Stoneform") and php <= getOptionValue("Stoneform") and php > 0 and br.player.race=="Dwarf" then
                if castSpell("player",racial,false,false,false) then return end
            end--]]
            -- Dispersion
            if isChecked("Dispersion") and php <= getOptionValue("Dispersion") then
                if cast.dispersion("player") then return end
            end
            -- Fade
            if isChecked("Fade") then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not solo and hasThreat(thisUnit) then
                        cast.fade("player")
                    end
                end
            end
            -- Psychic Scream / Mind Bomb
            if isChecked("Psychic Scream / Mind Bomb") and inCombat and php <= getOptionValue("Psychic Scream / Mind Bomb") then
                if not talent.mindBomb and #enemies.yards8 > 0 then
                    if cast.psychicScream("player") then return end
                else
                    if cast.mindBomb(units.dyn30) then return end
                end
            end
            -- Psychic Horror
            --if isChecked("Psychic Horror") and inCombat and php <= getOptionValue("Psychic Horror") then
            --    if talent.psychichHorror and #enemies.yards8 > 0 then
            --        if cast.psychicHorror(units.dyn30) then return end
            --    end
            -- Power Word: Shield
            if isChecked("Power Word: Shield") and php <= getOptionValue("Power Word: Shield") and not buff.powerWordShield.exists() then
                if cast.powerWordShield("player") then return end
            end
            -- Shadow Mend
            if isChecked("Shadow Mend") and php <= getOptionValue("Shadow Mend") then
                if cast.shadowMend("player") then return end
            end
        end -- End Defensive Check
    end -- End Action List - Defensive
-- Action List - Interrupts
    function actionList_Interrupts()
       if useInterrupts() then
        -- Silence
         if isChecked("Silence") then
             for i=1, #enemies.yards30 do
                 thisUnit = enemies.yards30[i]
                 if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                     if cast.silence(thisUnit) then return end
                 end
             end
         end
      -- Psychic Horror
         if talent.psychicHorror and isChecked("Psychic Horror") and (cd.silence.exists() or not isChecked("Silence")) then
             for i=1, #enemies.yards30 do
                 thisUnit = enemies.yards30[i]
                 if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                     if cast.psychicHorror(thisUnit) then return end --Print("pH on any") return end
                 end
             end
         end
        -- Psychic Scream
         if isChecked("Psychic Scream") then
             for i=1, #enemies.yards8 do
                 thisUnit = enemies.yards8[i]
                 if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                     if cast.psychicScream("player") then return end
                 end
             end
         end
        -- Mind Bomb
         if talent.mindBomb and isChecked("Mind Bomb") then
             for i=1, #enemies.yards30 do
                 thisUnit = enemies.yards30[i]
                 if canInterrupt(thisUnit,99) then
                    if cast.mindBomb(thisUnit) then return end
                end
            end
         end
     end
    end -- End Action List - Interrupts
-- Action List - Cooldowns
    function actionList_Cooldowns()
        if useCDs() then
            -- Touch of the Void
            if isChecked("Touch of the Void") and getDistance("target") <= 40 then
                if hasEquiped(128318) then
                    if GetItemCooldown(128318)==0 then
                        useItem(128318)
                    end
                end
            end
            -- KJ Burning Wish
            if isChecked("KJ Burning Wish") and getDistance("target") <= 40 then
                if hasEquiped(144259) then
                    if GetItemCooldown(144259)==0 then
                        useItem(144259)
                    end
                end
            end
            -- Tarnished Sentinel Medallion
            if isChecked("Tarnished Sentinel Medallion") and getDistance("target") <= 40 then
                if hasEquiped(147017) then
                    if GetItemCooldown(147017)==0 then
                        useItem(147017)
                    end
                end
            end
            -- Wriggling Sinew
            if isChecked("Wriggling Sinew") and getDistance("target") <= 40 then
                if hasEquiped(139326) then
                    if GetItemCooldown(139326)==0 then
                        useItem(139326)
                    end
                end
            end
            -- Pharameres Forbidden Grimoire
            if isChecked("Pharameres Forbidden Grimoire") and getDistance("target") <= 40 then
                if hasEquiped(140800) then
                    if GetItemCooldown(140800)==0 then
                        useItem(140800)
                    end
                end
            end
            -- Mrrgias Favor
            if isChecked("Mrrgias Favor") and getDistance("target") <= 40 then
                if hasEquiped(142160) then
                    if GetItemCooldown(142160)==0 then
                        useItem(142160)
                    end
                end
            end
            -- Moonlit Prism
            if isChecked("Moonlit Prism")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Prism Stacks") then
                if hasEquiped(137541) then
                    if GetItemCooldown(137541)==0 then
                        useItem(137541)
                    end
                end
            end
            -- Tome of Unravelling Sanity
            if isChecked("Tome of Unravelling Sanity")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Tome Stacks") then
                if hasEquiped(147019) then
                    if GetItemCooldown(147019)==0 then
                        useItem(147019)
                    end
                end
            end
            -- Charm of the Rising Tide
            if isChecked("Charm of the Rising Tide")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Charm Stacks") then
                if hasEquiped(147002) then
                    if GetItemCooldown(147002)==0 then
                        useItem(147002)
                    end
                end
            end
            -- Obelisk of the Void
            if isChecked("Obelisk of the Void")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Obelisk Stacks") then
                if hasEquiped(137433) then
                    if GetItemCooldown(137433)==0 then
                        useItem(137433)
                    end
                end
            end
            -- Horn of Valor
            if isChecked("Horn of Valor")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Horn Stacks") then
                if hasEquiped(133642) then
                    if GetItemCooldown(133642)==0 then
                        useItem(133642)
                    end
                end
            end
            -- Skull of Guldan
            if isChecked("Skull of Guldan")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Skull Stacks") then
                if hasEquiped(150522) then
                    if GetItemCooldown(150522)==0 then
                        useItem(150522)
                    end
                end
            end
            -- Figurehead of the Naglfar
            if isChecked("Figurehead of the Naglfar")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Figurehead Stacks") then
                if hasEquiped(137329) then
                    if GetItemCooldown(137329)==0 then
                        useItem(137329)
                    end
                end
            end
            -- Azurethos' Singed Plumage
            if isChecked("Azurethos' Singed Plumage")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Plumage Stacks") then
                if hasEquiped(161377) then
                    if GetItemCooldown(161377)==0 then
                        useItem(161377)
                    end
                end
            end
            -- T'zane's Barkspines
            if isChecked("T'zane's Barkspines")  and getDistance("target") <= 40 and buff.voidForm.exists() then
                if hasEquiped(161411) then
                    if GetItemCooldown(161411)==0 then
                        useItem(161411)
                    end
                end
            end
        -- Trinkets
            --if isChecked("Trinkets") then
            --    if canUseItem(11) then
            --        useItem(11)
            --    end
            --    if canUseItem(12) then
            --        useItem(12)
            --    end
            --    if canUseItem(13) then
            --        useItem(13)
            --    end
            --    if canUseItem(14) then
            --        useItem(14)
            --    end
            --end
            if isChecked("Trinket 1") and canUseItem(13) then
                useItem(13)
                return true
            end
            if isChecked("Trinket 2") and canUseItem(14) then
                useItem(14)
                return true
            end
        -- Potion
            -- potion,name=prolonged_power,if=buff.bloodlust.react|target.time_to_die<=80|(target.health.pct<35&cooldown.power_infusion.remains<30)
            -- TODO
        end
    end -- End Action List - Cooldowns
-- Action List - Pre-Combat
    function actionList_PreCombat()
     -- Shadow Form
         -- shadowform,if=!buff.shadowform.up
         if not buff.shadowform.exists() then
             cast.shadowform()
         end
     -- comment out Fort so you are not over casting other priests in raids. if you uncomment it will keep applying so its your fort up. easier to just manual cast i think.
     -- Power Word: Fortitude
         --if not buff.powerWordFortitude.exists() then
         --    cast.powerWordFortitude()
         --end
         if isChecked("Power Word: Fortitude") and br.timer:useTimer("PW:F Delay", mrdm(3,5)) then
             for i = 1, #br.friend do
                 if not buff.powerWordFortitude.exists(br.friend[i].unit,"any") and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                     if cast.powerWordFortitude() then return end
                 end
             end
         end
     -- Flask/Elixir
         -- flask,type=flask_of_the_whispered_pact
           -- Endless Fathoms Flask
         if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfEndlessFathoms.exists() and canUseItem(item.flaskOfEndlessFathoms) then
             if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
             if buff.felFocus.exists() then buff.felFocus.cancel() end
             if use.flaskOfEndlessFathoms() then return end
         end
         if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUseItem(item.repurposedFelFocuser) then
             if buff.flaskOfTheWhisperedPact.exists() then buff.flaskOfTheWhisperedPact.cancel() end
             if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
             if use.repurposedFelFocuser() then return end
         end
         if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUseItem(item.oraliusWhisperingCrystal) then
             if buff.flaskOfTheWhisperedPact.exists() then buff.flaskOfTheWhisperedPact.cancel() end
             if buff.felFocus.exists() then buff.felFocus.cancel() end
             if use.oraliusWhisperingCrystal() then return end
         end
     -- Mind Blast
         if isChecked("Pull OoC") and isValidUnit("target") then
             if activeEnemies == 1 or mode.rotation == 3 then
                if not moving then
                    if not talent.shadowWordVoid and br.timer:useTimer("mbRecast", gcdMax + getSpellCD(spell.mindBlast)) then
                        if UnitExists("target") and UnitGUID("target") ~= pmbLast then
                            if cast.mindBlast("target") then pmbLast = UnitGUID("target")
                            --Print("OoC MB")
                            return end
                        end
                    elseif talent.shadowWordVoid and charges.shadowWordVoid.count() > 1 and br.timer:useTimer("swvRecast", gcdMax + getSpellCD(spell.mindBlast)) then
                        if UnitExists("target") and UnitGUID("target") ~= pswvLast then
                            if cast.shadowWordVoid("target") then pswvLast = UnitGUID("target")
                                --Print("OoC swv")
                            return end
                        end
                    end
                elseif moving then
                    if not debuff.shadowWordPain.exists() then
                        if cast.shadowWordPain("target") then
                        --Print("OoC SWP")
                        return end 
                    end
                end
             elseif activeEnemies > 1 or mode.rotation == 2 then 
                if not moving then
                    if not debuff.vampiricTouch.exists() and not cast.current.vampiricTouch() and br.timer:useTimer("vtRecast", gcdMax + getSpellCD(spell.vampiricTouch)) then
                        if UnitExists("target") and UnitGUID("target") ~= pvtLast then
                            if cast.vampiricTouch("target") then pvtLast = UnitGUID("target")
                                --Print("OoC VT")
                            return end 
                        end
                    end
                elseif moving then
                    if not debuff.shadowWordPain.exists() then
                        if cast.shadowWordPain("target") then
                        --Print("OoC SWP")
                        return end 
                    end
                end
             end
         end
     --[[ Power Word: Shield Body and Soul
     --    if isChecked("PWS: Body and Soul") and talent.bodyAndSoul and isMoving("player") and buff.powerWordShield.remain() <= 8.5 and not buff.classHallSpeed.exists() then
     --        if cast.powerWordShield("player") then return end
     --    end
        if IsMovingTime(mrdm(60,120)/100) then
            if bnSTimer == nil then bnSTimer = GetTime() - 6 end
            if isChecked("PWS: Body and Soul") and talent.bodyAndSoul and buff.powerWordShield.remain("player") <= mrdm(6,8) and GetTime() >= bnSTimer + 6 then
                 if cast.powerWordShield("player") then
                 bnSTimer = GetTime() return end
             end
        end--]]
    end  -- End Action List - Pre-Combat
-- Action List - Cleave
    function actionList_Cleave()
    --Mouseover Dotting
        if isChecked("Mouseover Dotting") and hasMouse and (UnitIsEnemy("player","mouseover") or isDummy("mouseover")) and not moving then
            if getDebuffRemain("mouseover",spell.vampiricTouch,"player") <= 6.3 then
                if cast.vampiricTouch("mouseover") then
                    return
                end
            end
        end
        if isChecked("Mouseover Dotting") and hasMouse and (UnitIsEnemy("player","mouseover") or isDummy("mouseover")) then
            if getDebuffRemain("mouseover",spell.shadowWordPain,"player") <= 4.8 then
                if cast.shadowWordPain("mouseover") then
                    return
                end
            end
        end
    --Void Eruption
        -- void_eruption
        if mode.voidForm == 1 and cast.able.voidEruption() and not moving then
            if talent.darkVoid and cd.darkVoid.remain() ~= 30 then
                if cast.voidEruption(units.dyn40) then return end
            elseif not talent.darkVoid then
                if cast.voidEruption(units.dyn40) then return end
            end
        end
    --Dark Ascension
        if isChecked("Dark Ascension") and not isChecked("Dark Ascension AoE") and useCDs() then
            if power <= 60 and not buff.voidForm.exists() then
                if cast.darkAscension(units.dyn40) then
                    --Print("Cleave DA no VF")
                 return end
            end
        end
    --Dark Ascension
            --if power <= getOptionValue("  Insanity Percentage") and buff.voidForm.exists() then
        if isChecked("Dark Ascension Burst") and useCDs() then --and #searEnemies < mindblastTargets then
            if insanityDrain * gcdMax > power and buff.voidForm.exists() or not isChecked("Dark Ascension AoE") and #dAEnemies < getOptionValue("Dark Ascension AoE") and not buff.voidForm.exists() then
                if cast.darkAscension(units.dyn40) then
                    --Print("Cleave DA Burst VF")
                return end
            end
        end
     -- Vampiric Touch + Thought Harvester
        if traits.thoughtHarvester.active and traits.thoughtHarvester.rank >= 1 and not debuff.vampiricTouch.exists(units.dyn40) and not cast.current.vampiricTouch() then
            if UnitExists(units.dyn40) and UnitGUID(units.dyn40) ~= cvtLast or not cast.last.vampiricTouch() then
                if cast.vampiricTouch(units.dyn40) then cvtLast = UnitGUID(units.dyn40) return end
            end
        end
     -- Mind Sear
        --mind_sear,if=buff.harvested_thoughts.up
        if traits.thoughtHarvester.active and buff.harvestedThoughts.exists() and not cast.current.mindSear() then
            if cast.mindSear() then
                --Print("Cleave TH MS")
                return end
        end
    --Void Bolt
        if buff.voidForm.exists() and cast.able.voidBolt() then
           if cast.voidBolt(units.dyn40) then return end
        end
    --Lucid Dreams
        --memory_of_lucid_dreams,if=buff.voidform.stack>(20+5*buff.bloodlust.up)&insanity<=50
        if lucisDreams and isChecked("Lucid Dreams") and cast.able.memoryOfLucidDreams() and buff.voidForm.exists() and useCDs() then 
            if hasBloodLust() and buff.voidForm.stack() > (getOptionValue("  Lucid Dreams VF Stacks") + 5 + 5 * lusting) then
                if cast.memoryOfLucidDreams("player") then --[[Print("Lucid")--]] return end
            elseif buff.voidForm.stack() > getOptionValue("  Lucid Dreams VF Stacks") or power <= getOptionValue("  Lucid Dreams Insanity") or insanityDrained > power then
                if cast.memoryOfLucidDreams("player") then --[[Print("Lucid")--]] return end
            end
        end
    --Shadow Word: Death
        -- shadow_word_death,target_if=target.time_to_die<3|buff.voidform.down
        if talent.shadowWordDeath and thp < 20 then
            if ttd(units.dyn40) < 3 or not buff.voidForm.exists() then
                if cast.shadowWordDeath(units.dyn40) then return end
            end
        end
    --Surrender To Madness
        -- surrender_to_madness,if=buff.voidform.stack>10+(10*buff.bloodlust.up)
        if isChecked("Surrender To Madness") and useCDs() then 
            if talent.surrenderToMadness and buff.voidForm.stack() > 10 + (10 * lusting) then
                if cast.surrenderToMadness() then return end
            end
        end
     -- Dark Void
        -- dark_void,if=raid_event.adds.in>10&(dot.shadow_word_pain.refreshable|target.time_to_die>30)
        if not buff.voidForm.exists() and not moving then
            if talent.darkVoid and #dVEnemies >= getOptionValue("Dark Void Targets") and (debuff.shadowWordPain.refresh(units.dyn40) or ttd(units.dyn40) > 30) then
                if cast.darkVoid(units.dyn40) then
                    --Print("Cleave DV AoE")
                return end
            end
        end
     --Dark Ascension AoE
        if isChecked("Dark Ascension AoE") and not buff.voidForm.exists() then
            if #dAEnemies >= getOptionValue("Dark Ascension AoE") or (talent.darkVoid and cd.darkVoid.remain() ~= 30) then --or debuff.shadowWordPain.count() >= 3 then --math.min(getOptionValue("SWP Max Targets"),getOptionValue("Dark Ascension AoE")) then
                if cast.darkAscension(units.dyn40) then
                    --Print("Cleave DA AoE")
                return end
            end
        end
    --Shadowfiend / Mindbender
        -- mindbender,if=talent.mindbender.enabled|(buff.voidform.stack>18|target.time_to_die<15)
        if isChecked("Shadowfiend / Mindbender") and talent.mindbender and useCDs() then
            if isChecked("  Mindbender in VF") and getOptionValue("  Mindbender in VF") > 0 then
                if buff.voidForm.stack() >= getOptionValue("  Mindbender in VF") then
                    if cast.mindbender() then return end --Print("SFMB VF Stack") return end
                end
            elseif not isChecked("  Mindbender in VF") and useCDs() then
                if not buff.voidForm.exists() or buff.voidForm.stack() >= 1 then
                    if cast.mindbender() then return end --Print("SFMB CD") return end
                end
            end
        end
        if isChecked("Shadowfiend / Mindbender") and not talent.mindbender and useCDs() and dotsUp then
            if isChecked("  Mindbender in VF") and getOptionValue("  Mindbender in VF") > 0 then
                if buff.voidForm.stack() >= getOptionValue("  Mindbender in VF") then
                    if cast.shadowfiend() then return end --Print("SF CD") return end
                end
            elseif not isChecked("  Mindbender in VF") and ttd("target") < 15 and useCDs() then
                if cast.shadowfiend() then return end --Print("SF CD") return end
            end
        end
    --Mind Blast
        -- mind_blast,target_if=spell_targets.mind_sear<variable.mind_blast_targets
        if buff.voidForm.exists() and #searEnemies < mindblastTargets and cd.voidBolt.remain() >= mrdm(0.9,1.02) and noTH and not moving then
            if not talent.shadowWordVoid then
                if UnitExists(units.dyn40) and UnitGUID(units.dyn40) ~= cmbLast or not cast.last.mindBlast() then
                    if cast.mindBlast(units.dyn40) then cmbLast = UnitGUID(units.dyn40)
                --if cast.mindBlast(units.dyn40) then
                    --Print("Cleave MB VF")
                    --Print(mindblastTargets)
                    return end
                end
            elseif talent.shadowWordVoid and charges.shadowWordVoid.frac() >= 1.01 then
                if UnitExists(units.dyn40) and UnitGUID(units.dyn40) ~= cswvLast or not cast.last.shadowWordVoid() then
                    if cast.shadowWordVoid(units.dyn40) then cswvLast = UnitGUID(units.dyn40)
                    --Print("CLeave swv VF")
                    --Print(mindblastTargets)
                    return end
                end
            end
        end
    --Shadow Crash
        -- shadow_crash,if=raid_event.adds.in>5&raid_event.adds.duration<20
        if isChecked("Shadow Crash") and talent.shadowCrash and not isMoving("target") then
            if cast.shadowCrash("best",nil,1,8) then return end
        end
     --Shadow Word: Pain - on dyn40 target and extra targets with no Misery
        -- shadow_word_pain,target_if=refreshable&target.time_to_die>((-1.2+3.3*spell_targets.mind_sear)*variable.swp_trait_ranks_check*(1-0.012*azerite.searing_dialogue.rank*spell_targets.mind_sear)),if=!talent.misery.enabled
        if not talent.misery and noHarvest and SWPb4VT then
            if debuff.shadowWordPain.remain(units.dyn40) < 4.8 and ttd(units.dyn40) > ((-1.2 + 3.3 * #searEnemies) * swp_trait_ranks_check * (1 - 0.012 * traits.searingDialogue.rank * #searEnemies)) then
                if UnitExists(units.dyn40) and UnitGUID(units.dyn40) ~= cswpb4vtLast or not cast.last.shadowWordPain() then
                    if cast.shadowWordPain(units.dyn40) then cswpb4vtLast = UnitGUID(units.dyn40)
                    --Print("cast Cleave SWPb4VT on dyn40")
                    return end
                end
            end
            if debuff.shadowWordPain.remainCount(3) < SWPmaxTargets and SWPb4VT then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.shadowWordPain.remain(thisUnit) < 3 and ttd(thisUnit) > ((-1.2 + 3.3 * #searEnemies) * swp_trait_ranks_check * (1 - 0.012 * traits.searingDialogue.rank * #searEnemies)) then
                        if UnitExists(units.dyn40) and UnitGUID(units.dyn40) ~= cswpb4vtLast or not cast.last.shadowWordPain() then
                            if cast.shadowWordPain(thisUnit) then
                        --Print("cast Cleave SWPb4VT on adds")
                            return end
                        end
                    end
                end
            end
        end
     --Vampiric Touch - on dyn40 target and extra targets with no Misery
        -- vampiric_touch,target_if=refreshable,if=target.time_to_die>((1+3.3*spell_targets.mind_sear)*variable.vt_trait_ranks_check*(1+0.10*azerite.searing_dialogue.rank*spell_targets.mind_sear))
        if not talent.misery and not moving and not cast.current.vampiricTouch() and noTH then
            if debuff.vampiricTouch.remain(units.dyn40) < 6.3 and ttd(units.dyn40) > ((1 + 3.3 * #searEnemies) * vt_trait_ranks_check * (1 + 0.10 * traits.searingDialogue.rank * #searEnemies)) then
                if UnitExists(units.dyn40) and UnitGUID(units.dyn40) ~= cvtLast or not cast.last.vampiricTouch() then
                    if cast.vampiricTouch(units.dyn40) then cvtLast = UnitGUID(units.dyn40)
                    -- Print("cast Cleave VT on dyn40")
                    return end
                end
            end
            if debuff.vampiricTouch.remainCount(4) < VTmaxTargets then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.vampiricTouch.remain(thisUnit) < 4 and ttd(thisUnit) > ((1 + 3.3 * #searEnemies) * vt_trait_ranks_check * (1 + 0.10 * traits.searingDialogue.rank * #searEnemies)) then
                        if UnitExists(thisUnit) and UnitGUID(thisUnit) ~= cvtaLast or not cast.last.vampiricTouch() then
                            if cast.vampiricTouch(thisUnit) then cvtaLast = UnitGUID(thisUnit)
                            -- Print("cast Cleave VT on adds")
                            return end
                        end
                    end
                end
            end
        end
     -- Vampiric Touch - on dyn target and extra targets with Misery
        -- vampiric_touch,target_if=dot.shadow_word_pain.refreshable,if=(talent.misery.enabled&target.time_to_die>((1.0+2.0*spell_targets.mind_sear)*variable.vt_mis_trait_ranks_check*(variable.vt_mis_sd_check*spell_targets.mind_sear)))
        if talent.misery and not moving and not cast.current.vampiricTouch() and noTH then
            if debuff.shadowWordPain.remain(units.dyn40) < 4.8  or not debuff.vampiricTouch.exists() and ttd(units.dyn40) > ((1.0 + 2.0 * #searEnemies) * vt_mis_trait_ranks_check * (vt_mis_sd_check * #searEnemies)) then
                if UnitExists(units.dyn40) and UnitGUID(units.dyn40) ~= cmvtLast or not cast.last.vampiricTouch() then
                    if cast.vampiricTouch(units.dyn40) then cmvtLast = UnitGUID(units.dyn40)
                     --Print("cast Cleave Mis VT on dyn40")
                    return end
                end
            end
            --[[if debuff.shadowWordPain.count() < VTmaxTargets then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not debuff.shadowWordPain.exists(thisUnit) and ttd(thisUnit) > ((1.0 + 2.0 * #searEnemies) * vt_mis_trait_ranks_check * (vt_mis_sd_check * #searEnemies)) then --and not cast.last.vampiricTouch(1) then
                        if UnitExists(thisUnit) and UnitGUID(thisUnit) ~= cmvtaLast or not cast.last.vampiricTouch() then
                            if cast.vampiricTouch(thisUnit) then cmvtaLast = UnitGUID(thisUnit)
                            Print("cast Cleave Mis VT on adds")
                            return end
                        end
                    end
                end
            end--]]
            if debuff.shadowWordPain.remainCount(4) < VTmaxTargets then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.shadowWordPain.remain(thisUnit) < 4  or not debuff.vampiricTouch.exists() and ttd(thisUnit) > ((1.0 + 2.0 * #searEnemies) * vt_mis_trait_ranks_check * (vt_mis_sd_check * #searEnemies)) then
                        if UnitExists(thisUnit) and UnitGUID(thisUnit) ~= cmvtaLast or not cast.last.vampiricTouch() then
                            if cast.vampiricTouch(thisUnit) then cmvtaLast = UnitGUID(thisUnit)
                            --Print("rfrsh Cleave Mis VT on adds")
                            return end
                        end
                    end
                end
            end
        end
     --Shadow Word: Pain - on dyn40 target and extra targets with no Misery
        -- shadow_word_pain,target_if=refreshable&target.time_to_die>((-1.2+3.3*spell_targets.mind_sear)*variable.swp_trait_ranks_check*(1-0.012*azerite.searing_dialogue.rank*spell_targets.mind_sear)),if=!talent.misery.enabled
        if not talent.misery and noTH then
            if debuff.shadowWordPain.remain(units.dyn40) < 4.8 and ttd(units.dyn40) > ((-1.2 + 3.3 * #searEnemies) * swp_trait_ranks_check * (1 - 0.012 * traits.searingDialogue.rank * #searEnemies)) then
                if cast.shadowWordPain(units.dyn40) then
                --Print("cast Cleave SWP on dyn40")
                return end
            end
            if debuff.shadowWordPain.remainCount(3) < SWPmaxTargets then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.shadowWordPain.remain(thisUnit) < 3 and ttd(thisUnit) > ((-1.2 + 3.3 * #searEnemies) * swp_trait_ranks_check * (1 - 0.012 * traits.searingDialogue.rank * #searEnemies)) then
                        if cast.shadowWordPain(thisUnit) then
                        --Print("cast Cleave SWP on adds")
                        return end
                    end
                end
            end
        end
    --Mind Blast
        -- mind_blast,target_if=spell_targets.mind_sear<variable.mind_blast_targets
        if not buff.voidForm.exists() and #searEnemies < mindblastTargets and noTH and not moving then
            if not talent.shadowWordVoid then
                if UnitExists(units.dyn40) and UnitGUID(units.dyn40) ~= cmbLast or not cast.last.mindBlast() then
                    if cast.mindBlast(units.dyn40) then cmbLast = UnitGUID(units.dyn40)
                    --Print("Cleave MB no VF")
                    return end
                end
            elseif talent.shadowWordVoid and charges.shadowWordVoid.frac() >= 1.01 then
                if UnitExists(units.dyn40) and UnitGUID(units.dyn40) ~= cswvLast or not cast.last.shadowWordVoid() then
                    if cast.shadowWordVoid(units.dyn40) then cswvLast = UnitGUID(units.dyn40)
                    --Print("CLeave swv no VF")
                    return end
                end
            end
        end
     -- Void Torrent
        -- void_torrent,if=buff.voidform.up
        if isChecked("Void Torrent") and talent.voidTorrent and useCDs() and buff.voidForm.exists() and noTH then
            if cast.voidTorrent() then return end
        end
    --Mind Sear
        -- mind_sear,target_if=spell_targets.mind_sear>1,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
        if #searEnemies >= getOptionValue("Mind Sear Targets") and buff.voidForm.exists() and noTH then
            if not moving and not cast.current.mindSear() then
                if cast.mindSear() then
                    --Print("Cleave VF MS")
                return end
            end
        elseif #searEnemies >= getOptionValue("Mind Sear Targets") and not buff.voidForm.exists() and noTH then
            if not moving and not cast.current.mindSear() or (cast.active.mindSear() and mindSearRecast) then
                if cast.mindSear() then
                    --Print("Cleave MS")
                return end
            end
        end
    --Mind Flay
        -- mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(cooldown.void_bolt.up|cooldown.mind_blast.up)
        if #searEnemies < getOptionValue("Mind Sear Targets") and not buff.voidForm.exists() and noTH then 
            if not moving and not cast.current.mindFlay() and (cd.mindBlast.remain() > 0.5 or talent.shadowWordVoid and cd.shadowWordVoid.remain() < 4.2) or (cast.active.mindFlay() and mindFlayRecast) then
                if cast.mindFlay() then
                --Print("refresh Cleave mf")
                return end
            end
        elseif #searEnemies < getOptionValue("Mind Sear Targets") and buff.voidForm.exists() and noTH then 
            if not moving and not cast.current.mindFlay() and cd.voidBolt.remain() < 3.4 then --or cd.mindBlast.remain() < 4.2 * gHaste) then
                if cast.mindFlay() then
                --Print("refresh Cleave VF mf")
                return end
            end
        end
    --Shaow Word: Pain
        -- shadow_word_pain
        if moving then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.shadowWordPain.exists(thisUnit) then
                    if cast.shadowWordPain(thisUnit) then
                    --Print("cast SWP last resort")
                    return end
                end
            end
        end
    end
-- Action List - Single
    function actionList_Single()
    --Mouseover Dotting
        if isChecked("Mouseover Dotting") and hasMouse and (UnitIsEnemy("player","mouseover") or isDummy("mouseover")) and not moving then
            if getDebuffRemain("mouseover",spell.vampiricTouch,"player") <= 6.3 then
                if cast.vampiricTouch("mouseover") then
                    return
                end
            end
        end
        if isChecked("Mouseover Dotting") and hasMouse and (UnitIsEnemy("player","mouseover") or isDummy("mouseover")) then
            if getDebuffRemain("mouseover",spell.shadowWordPain,"player") <= 4.8 then
                if cast.shadowWordPain("mouseover") then
                    return
                end
            end
        end
    --Void Eruption
        -- void_eruption
        if cast.current.mindFlay() and not buff.voidForm.exists() and (power >= 90 or talent.legacyOfTheVoid and power >= 60) then
            RunMacroText('/stopcasting')
            --Print("stop for VE2")
            return true end
        --end
        if mode.voidForm == 1 and cast.able.voidEruption() and not moving then
            if cast.voidEruption() then return end
        end
    --Dark Ascension
        if isChecked("Dark Ascension") and dotsUp and useCDs() then
            if power <= 60 and not buff.voidForm.exists() then
                if cast.darkAscension(units.dyn40) then
                --Print("no VF")
                 return end
            end
        end
    --Dark Ascension
            --if power <= getOptionValue("  Insanity Percentage") and buff.voidForm.exists() then
        if isChecked("Dark Ascension Burst") and useCDs() then
            if insanityDrain * gcdMax > power and buff.voidForm.exists() then
                if cast.darkAscension(units.dyn40) then
                --Print("VF")
                return end
            end
        end
    --Void Bolt
        if buff.voidForm.exists() and cast.able.voidBolt() then
            if cast.voidBolt(units.dyn40) then return end
        end
    --Lucid Dreams
        --memory_of_lucid_dreams,if=buff.voidform.stack>(20+5*buff.bloodlust.up)&insanity<=50
        if lucisDreams and isChecked("Lucid Dreams") and cast.able.memoryOfLucidDreams() and buff.voidForm.exists() and useCDs() then 
            if hasBloodLust() and buff.voidForm.stack() > (getOptionValue("  Lucid Dreams VF Stacks") + 5 + 5 * lusting) then
                if cast.memoryOfLucidDreams("player") then --[[Print("Lucid")--]] return end
            elseif buff.voidForm.stack() > getOptionValue("  Lucid Dreams VF Stacks") or power <= getOptionValue("  Lucid Dreams Insanity") or insanityDrained > power then
                if cast.memoryOfLucidDreams("player") then --[[Print("Lucid")--]] return end
            end
        end
    --Mind Sear
        --mind_sear,if=buff.harvested_thoughts.up&cooldown.void_bolt.remains>=1.5&azerite.searing_dialogue.rank>=1
        if traits.searingDialogue.active and traits.thoughtHarvester.active and buff.voidForm.exists() then 
            if buff.harvestedThoughts.exists() and cd.voidBolt.remain() >= 1.5 and traits.searingDialogue.rank >= 1 and not cast.current.mindSear() then
                if cast.mindSear() then
                --Print("MS TH ST")
                return end
            end
        end
    --Shadow Word: Death
        -- shadow_word_death,if=target.time_to_die<3|cooldown.shadow_word_death.charges=2|(cooldown.shadow_word_death.charges=1&cooldown.shadow_word_death.remains<gcd.max)
        if talent.shadowWordDeath and thp < 20 then
            if ttd("target") < 3 or charges.shadowWordDeath.count() == 2 or (charges.shadowWordDeath.count() == 1 and cd.shadowWordDeath.remain() < gcdMax) then
                if cast.shadowWordDeath(units.dyn40) then return end
            end
        end
    --Surrender To Madness
        -- surrender_to_madness,if=buff.voidform.stack>10+(10*buff.bloodlust.up)
        if isChecked("Surrender To Madness") and useCDs() then 
            if talent.surrenderToMadness and buff.voidForm.stack() > 10 + (10 * lusting) then
                if cast.surrenderToMadness() then return end
            end
        end
    --Shadowfiend / Mindbender
        -- mindbender,if=talent.mindbender.enabled|(buff.voidform.stack>18|target.time_to_die<15)
        if isChecked("Shadowfiend / Mindbender") and talent.mindbender and useCDs() then
            if isChecked("  Mindbender in VF") and getOptionValue("  Mindbender in VF") > 0 then
                if buff.voidForm.stack() >= getOptionValue("  Mindbender in VF") then
                    if cast.mindbender() then return end --Print("SFMB VF Stack") return end
                end
            elseif not isChecked("  Mindbender in VF") and useCDs() then
                if not buff.voidForm.exists() or buff.voidForm.stack() >= 1 then
                    if cast.mindbender() then return end --Print("SFMB CD") return end
                end
            end
        end
        if isChecked("Shadowfiend / Mindbender") and not talent.mindbender and useCDs() and dotsUp then
            if isChecked("  Mindbender in VF") and getOptionValue("  Mindbender in VF") > 0 then
                if buff.voidForm.stack() >= getOptionValue("  Mindbender in VF") then
                    if cast.shadowfiend() then return end --Print("SF CD") return end
                end
            elseif not isChecked("  Mindbender in VF") and ttd("target") < 15 and useCDs() then
                if cast.shadowfiend() then return end --Print("SF CD") return end
            end
        end
    --Shadow Word: Death
        -- shadow_word_death,if=!buff.voidform.up|(cooldown.shadow_word_death.charges=2&buff.voidform.stack<15)
        if talent.shadowWordDeath and thp < 20 then
            if not buff.voidForm.exists() or (charges.shadowWordDeath.count() == 2 and buff.voidForm.stack() < 15) then
                if cast.shadowWordDeath(units.dyn40) then return end
            end
        end
    --Shadow Crash
        -- shadow_crash,if=raid_event.adds.in>5&raid_event.adds.duration<20
        if isChecked("Shadow Crash") and talent.shadowCrash and not isMoving("target") then
            if cast.shadowCrash("best",nil,1,8) then return end
        end
    --Mind Blast
        -- mind_blast,if=variable.dots_up&((!talent.shadow_word_void.enabled|buff.voidform.down|buff.voidform.stack>14&(insanity<70|charges_fractional>1.33)|buff.voidform.stack<=14&(insanity<60|charges_fractional>1.33))
        if buff.voidForm.exists() and dotsUp and noTH and cd.voidBolt.remain() >= mrdm(0.93,1.02) or ((buff.voidForm.stack() > 14 and power < 75) or (buff.voidForm.stack() <= 14 and power < 64)) and not moving then
            if not talent.shadowWordVoid then
                if UnitExists("target") and UnitGUID("target") ~= mbLast or not cast.last.mindBlast() then
                    if cast.mindBlast("target") then mbLast = UnitGUID("target")
                    --Print("mb VF")
                    return end
                end
            elseif talent.shadowWordVoid and charges.shadowWordVoid.frac() >= 1.02 then
                if UnitExists("target") and UnitGUID("target") ~= swvLast or not cast.last.shadowWordVoid() then
                    if cast.shadowWordVoid("target") then swvLast = UnitGUID("target")
                    --Print("swv VF")
                    return end
                end
            end
            --[[elseif talent.shadowWordVoid then
                if (buff.voidForm.stack() > 14 and (power < 70 or charges.shadowWordVoid.frac() >= 1.03)) or (buff.voidForm.stack() <= 14 and (power < 60 or charges.shadowWordVoid.frac() >= 1.03)) then
                    if UnitExists("target") and UnitGUID("target") ~= swvLast or not cast.last.shadowWordVoid() then
                        if cast.shadowWordVoid("target") then swvLast = UnitGUID("target")
                        --Print("swv VF")
                        return end
                    end
                end
            end--]]
            --[[if UnitExists("target") and UnitGUID("target") ~= mbLast or not cast.last.mindBlast() then
                if cast.mindBlast("target") then mbLast = UnitGUID("target")
                --Print("mb no lotv")
                return end
            end--]]
        end
     --Void Torrent
        -- void_torrent,if=dot.shadow_word_pain.remains>4&dot.vampiric_touch.remains>4&buff.voidform.up
        if isChecked("Void Torrent") and talent.voidTorrent and useCDs() and dotsTick and buff.voidForm.exists() then
            if cast.voidTorrent(units.dyn40) then return end
        end
    --Shadow Word: Pain -- cast on target and refresh if expiring soon
        -- shadow_word_pain,if=refreshable&target.time_to_die>4&!talent.misery.enabled&!talent.dark_void.enabled
        if not talent.misery and buff.voidForm.exists() and noTH and SWPb4VT then
            if debuff.shadowWordPain.remain("target") < 2.4 then
                if UnitExists(units.dyn40) and UnitGUID(units.dyn40) ~= swpb4vtLast or not cast.last.shadowWordPain() then
                    if cast.shadowWordPain(units.dyn40) then swpb4vtLast = UnitGUID(units.dyn40)
                    --Print("cast VF SWPb4VT on target not misery")
                    return end
                end
            end
        elseif not talent.misery and not buff.voidForm.exists() and SWPb4VT then
            if debuff.shadowWordPain.remain("target") < 4.8 and ttd("target") > 4 then
                if UnitExists(units.dyn40) and UnitGUID(units.dyn40) ~= swpb4vtLast or not cast.last.shadowWordPain() then
                    if cast.shadowWordPain(units.dyn40) then swpb4vtLast = UnitGUID(units.dyn40)
                    --Print("cast SWPb4VT on target not misery")
                    return end
                end
            end
        end
    --Vampiric Touch -- cast target and refresh if expiring soon
        -- vampiric_touch,if=refreshable&target.time_to_die>6|(talent.misery.enabled&dot.shadow_word_pain.refreshable)
        if not talent.misery and buff.voidForm.exists() and noTH then
            if debuff.vampiricTouch.remain("target") < 3.1 and ttd("target") > 6 and not moving and not cast.current.vampiricTouch() then
                if UnitExists("target") and UnitGUID("target") ~= vtLast or not cast.last.vampiricTouch() then
                    if cast.vampiricTouch("target") then vtLast = UnitGUID("target")
                    --Print("cast VF VT on target")
                    return end
                end
            end
        elseif not talent.misery and not buff.voidForm.exists() then 
            if debuff.vampiricTouch.remain("target") < 6.3 and ttd("target") > 6 and not moving and not cast.current.vampiricTouch() then
                if UnitExists("target") and UnitGUID("target") ~= vtLast or not cast.last.vampiricTouch() then
                    if cast.vampiricTouch("target") then vtLast = UnitGUID("target")
                    --Print("cast VT on target")
                   return end
                end
            end
        end
        if talent.misery and buff.voidForm.exists() and noTH then
            if debuff.shadowWordPain.remain("target") < 2.4 or not debuff.vampiricTouch.exists() and not moving and not cast.current.vampiricTouch() then
                if UnitExists("target") and UnitGUID("target") ~= mvtLast or not cast.last.vampiricTouch() then
                    if cast.vampiricTouch("target") then mvtLast = UnitGUID("target")
                --if cast.vampiricTouch(units.dyn40) then
                    --Print("cast VF VT  / Mis VT on target")
                    return end
                end
            end
        elseif talent.misery and not buff.voidForm.exists() then 
            if debuff.shadowWordPain.remain("target") < 4.8 or not debuff.vampiricTouch.exists() and not moving and not cast.current.vampiricTouch() then
                if UnitExists("target") and UnitGUID("target") ~= mvtLast or not cast.last.vampiricTouch() then
                    if cast.vampiricTouch("target") then mvtLast = UnitGUID("target")
                    --Print("cast Mis VT on target")
                    return end
                end
            end
        end
    --Shadow Word: Pain -- cast on target and refresh if expiring soon
        -- shadow_word_pain,if=refreshable&target.time_to_die>4&!talent.misery.enabled&!talent.dark_void.enabled
        if not talent.misery and buff.voidForm.exists() and noTH then
            if debuff.shadowWordPain.remain("target") < 2.4 then
                if cast.shadowWordPain(units.dyn40) then
                    --Print("cast VF SWP on target not misery")
                return end
            end
        elseif not talent.misery and not buff.voidForm.exists() then
            if debuff.shadowWordPain.remain("target") < 4.8 and ttd("target") > 4 then
                if cast.shadowWordPain(units.dyn40) then
                    --Print("cast SWP on target not misery")
                return end
            end
        end
    --Mind Blast
        -- mind_blast,if=variable.dots_up
        if not buff.voidForm.exists() and dotsUp --[[and debuff.vampiricTouch.remain(units.dyn40) > 9.3 * gHaste and not cast.current.mindBlast() then --]] and not moving then
            if not talent.shadowWordVoid then
                if UnitExists("target") and UnitGUID("target") ~= mbLast or not cast.last.mindBlast() then
                    if cast.mindBlast("target") then mbLast = UnitGUID("target")
                        --Print("mb no VF")
                    return end
                end
            elseif talent.shadowWordVoid and charges.shadowWordVoid.frac() >= 1.01 then
                if UnitExists("target") and UnitGUID("target") ~= swvLast or not cast.last.shadowWordVoid() then
                    if cast.shadowWordVoid("target") then swvLast = UnitGUID("target")
                    --Print("swv no VF")
                    return end
                end
            end
        end
    --[[Mind Sear
        -- mind_sear,if=azerite.searing_dialogue.rank>=3,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
        if traits.searingDialogue.active and not buff.voidForm.exists() then
            if not moving and traits.searingDialogue.rank >= 3 and not cast.current.mindSear() or (cast.active.mindSear() and mindSearRecast) then
                    if cast.mindSear() then
                return end
            end
        elseif traits.searingDialogue.active and buff.voidForm.exists() and noTH then
            if not moving and traits.searingDialogue.rank >= 3 and not cast.current.mindSear() then
                    if cast.mindSear() then
                return end
            end
        end--]]
    --Mind Flay
        -- mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(cooldown.void_bolt.up|cooldown.mind_blast.up)
        if activeEnemies == 1 and not buff.voidForm.exists() then --and --[[and not cast.able.voidEruption()--]] (power < 90 or talent.legacyOfTheVoid and power < 60) then --or mode.voidForm == 2 then--]]
            --if cast.active.mindFlay() and cast.able.voidEruption() then
                --RunMacroText('/stopcasting')
            --    Print("stop for VE2")
            --    return true end
            if not moving and (not cast.able.voidEruption() or mode.voidForm == 2) and not cast.current.mindFlay() and (cd.mindBlast.remain() > 0.5 or talent.shadowWordVoid and cd.shadowWordVoid.remain() < 4.2) or (cast.active.mindFlay() and mindFlayRecast) then
                if cast.mindFlay() then
                    --Print("refresh mf")
                return end
            end
        elseif activeEnemies == 1 and buff.voidForm.exists() and noTH then 
            if not moving and not cast.current.mindFlay() and cd.voidBolt.remain() < 3.4 then --or (cd.mindBlast.remain() > 0.5 or talent.shadowWordVoid and cd.shadowWordVoid.remain() < 4.2)) then
                if cast.mindFlay() then
                    --Print("refresh VF mf")
                return end
            end
        end
    --Shaow Word: Pain
        -- shadow_word_pain
        if moving then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.shadowWordPain.exists(thisUnit) then
                    if cast.shadowWordPain(thisUnit) then
                        --Print("cast SWP last resort")
                        return
                    end
                end
            end
        end
    end
---------------------
--- Begin Profile ---
---------------------
-- Profile Stop | Pause
    if not inCombat and not hastar and profileStop==true then
        profileStop = false
    elseif (inCombat and profileStop==true) or IsMounted() or IsFlying() or (pause(true) and not isCastingSpell(spell.mindFlay)) or mode.rotation==4 then
        return true
    else
-----------------
--- Rotations ---
-----------------
        if actionList_Extra() then return end
        --PowerWord: Shield
            if IsMovingTime(mrdm(60,120)/100) and not IsFalling() then
                if bnSTimer == nil then bnSTimer = GetTime() - 6 end
                if isChecked("PWS: Body and Soul") and talent.bodyAndSoul and buff.powerWordShield.remain("player") <= mrdm(6,8) and GetTime() >= bnSTimer + 6 then
                     if cast.powerWordShield("player") then
                     bnSTimer = GetTime() return end
                end
            end
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
        if not inCombat then --  and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player")
            if actionList_PreCombat() then return end
        end
-----------------------------
--- In Combat - Rotations ---
-----------------------------
        if inCombat and not IsMounted() and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 and not isCastingSpell(spell.voidTorrent) and not isCastingSpell(spell.mindBlast) and not isCastingSpell(303769) then
        -- Action List - Defensive
            if actionList_Defensive() then return end
        -- Action List - Cooldowns
            actionList_Cooldowns()
        -- Action List - Interrupts
            --if useInterrupts() then
                if actionList_Interrupts() then return end
            --end
        -- Trinkets off Cooldown
            --if isChecked("Trinket 1 Off CD") and canUseItem(13) then
            --    useItem(13)
            --    return true
            --end
            --if isChecked("Trinket 2 Off CD") and canUseItem(14) then
            --    useItem(14)
            --    return true
            --end
        -- Action List - Cleave
            -- run_action_list,name=cleave,if=active_enemies>1
            if activeEnemies > 1 or (mode.rotation == 2 and not mode.rotation == 3) then --Print("Cleave")
                --Print(mindblastTargets)
                if actionList_Cleave() then return end
            end
        -- Action List - Main
            -- run_action_list,name=single,if=active_enemies=1
            if activeEnemies == 1 or mode.rotation == 3 then --Print(insanityDrained) --Print("Single")
                if actionList_Single() then return end
            end
        end -- End Combat Rotation
    end
end -- Run Rotation

local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
