local rotationName = "RalphShadow" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 0, icon = br.player.spell.shadowform },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.mindSear },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mindFlay },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.shadowMend}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.voidEruption },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.voidEruption },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.mindBlast }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dispersion },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dispersion }
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.silence },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.silence }
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
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
             -- Dummy DPS Test
             br.ui:createSpinner(section, "DPS Testing",  1,  1,  60,  1,  "Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
             -- Pre-Pull Timer
             br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "Set to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
             -- Body and Soul
             br.ui:createCheckbox(section,"PWS: Body and Soul")
             -- Auto Buff Fortitude
             br.ui:createCheckbox(section,"Power Word: Fortitude", "Check to auto buff Fortitude on party.")
        br.ui:checkSectionState(section)
        -----------------
        ---AOE OPTIONS---
        -----------------
        section = br.ui:createSection(br.ui.window.profile,  "AOE Options")
            -- Shadow Crash
            br.ui:createCheckbox(section,"Shadow Crash")
            -- SWP Max Targets
            br.ui:createSpinnerWithout(section, "SWP Max Targets",  4,  1,  7,  1, "Unit Count Limit that SWP will be cast on.")
            -- VT Max Targets
            br.ui:createSpinnerWithout(section, "VT Max Targets",  4,  1,  7,  1, "Unit Count Limit that VT will be cast on.")
            -- Mind Sear Targets
            br.ui:createSpinnerWithout(section, "Mind Sear Targets",  2,  2,  10,  1, "Unit Count Limit before Mind Sear is being used.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinket 1", "Use Trinket 1 on Cooldown.")
            br.ui:createCheckbox(section,"Trinket 2", "Use Trinket 2 on Cooldown.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- -- Healthstone
            -- br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "Health Percentage to use at.")
            -- Dispel Magic
            br.ui:createCheckbox(section,"Dispel Magic")
            -- -- Dispersion
            -- br.ui:createSpinner(section, "Dispersion",  20,  0,  100,  5,  "Health Percentage to use at.")
            -- -- Fade
            -- br.ui:createCheckbox(section, "Fade")
            -- -- Vampiric Embrace
            -- br.ui:createSpinner(section, "Vampiric Embrace",  25,  0,  100,  5,  "Health Percentage to use at.")
            -- -- Power Word: Shield
            -- br.ui:createSpinner(section, "Power Word: Shield",  60,  0,  100,  5,  "Health Percentage to use at.")
            -- -- Shadow Mend
            -- br.ui:createSpinner(section, "Shadow Mend",  60,  0,  100,  5,  "Health Percentage to use at.")
            -- -- Psychic Scream / Mind Bomb
            -- br.ui:createSpinner(section, "Psychic Scream / Mind Bomb",  40,  0,  100,  5,  "Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
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
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
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

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local cast
local cd
local conduit
local covenant
local debuff
local enemies
local equiped
local gcd
local gcdMax
local has
local inCombat
local item
local level
local mode
local moving
local mrdm
local php
local power
local spell
local talent
local thp
local units
local use
local voidform
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local hastar
local healPot
local profileStop
local ttd
-- Profile Specific Locals - Any custom to profile locals
local allDotsUp
local biggestGroup
local bestUnit
local dotsUp
local mfTicks
local msTicks
local novaEnemies
local pool
local snmCutoff
local searEnemies
local targetGroup
local thisGroup
local thisUnit
local SWPmaxTargets
local VTmaxTargets

local actionList = {}

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
local function CwC()
    if not pool and cast.current.mindFlay() and mfTicks >= 2 and not (debuff.devouringPlague.exists() and power > 50 or power > 90) then
        if cast.devouringPlague('target') then return end
    end
    if (voidform or buff.dissonantEchoes.exists()) and mfTicks >= 2 and cast.current.mindFlay() and cd.voidBolt.ready() then
        RunMacroText('/stopcasting')
        br.addonDebug("void bolt stopcast")
    end
    -- if cast.current.mindFlay() and cd.mindBlast.ready() then
    --     RunMacroText('/stopcasting')
    --     br.addonDebug("mind blast stopcast")
    -- end
    -- if cast.current.mindFlay() and cd.voidTorrent.ready() then
    --     RunMacroText('/stopcasting')
    --     br.addonDebug("void torrent stopcast")
    -- end
    -- if cast.current.mindSear() and msTicks >= 3 and cd.voidEruption.ready() then
    --     RunMacroText('/stopcasting')
    --     br.addonDebug('sear ticks >= 2 stopcast')
    -- end
    -- if talent.searingNightmare and select(1,UnitChannelInfo("player")) == GetSpellInfo(48045) then
    --     if power > 35 then
    --         if cast.searingNightmare() then
    --             return
    --         end
    --     end
    -- end
    
    -- # Use Searing Nightmare if you will hit enough targets and Power Infusion and Voidform are not ready, or to refresh SW:P on two or more targets.
    -- actions.cwc=searing_nightmare,use_while_casting=1,target_if=(variable.searing_nightmare_cutoff&!variable.pool_for_cds)|(dot.shadow_word_pain.refreshable&spell_targets.mind_sear>1)
    if ((snmCutoff and not pool) or (not swpCheck and #searEnemies > 1)) and cast.current.mindSear() then
        if power > 30 then
            if cast.searingNightmare() then return end
        end
    end
    
    -- # Short Circuit Searing Nightmare condition to keep SW:P up in AoE
    -- actions.cwc+=/searing_nightmare,use_while_casting=1,target_if=talent.searing_nightmare.enabled&dot.shadow_word_pain.refreshable&spell_targets.mind_sear>2
    if talent.searingNightmare and not swpCheck and #searEnemies > 2 and select(1,UnitChannelInfo("player")) == GetSpellInfo(48045) then
        if power > 30 then
            if cast.searingNightmare() then 
            br.addonDebug('SNM to refresh SW:P') return end
        end
    end    
    
    if cast.current.mindFlay() or cast.current.mindSear() then
        if buff.darkThoughts.exists() then
            if cast.mindBlast() then
                return 
            end
        end
    end
end

local function dotsCheck()
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        if (debuff.shadowWordPain.refresh(thisUnit) and ttd(thisUnit) > 4) or (debuff.vampiricTouch.refresh(thisUnit) and ttd(thisUnit) > 6) then
            return true
        else
            return false
        end
    end
end

local function swpCheck()
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        if debuff.shadowWordPain.refresh(thisUnit) and ttd(thisUnit) > 4 then
            return false
        else
            return true
        end
    end
end

local function ToF()
    if talent.twistOfFate then
        return 1
    else 
        return 0
    end
end

local function vtCheck()
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        if debuff.vampiricTouch.refresh(thisUnit) and ttd(thisUnit) > 6 then
            return true
        end
    end
end

local function dEchoesCheck()
    if conduit.dissonantEchoes.enabled then
        return 1
    else
        return 0
    end
end

local function snmEnabled()
    if talent.searingNightmare then
        return 1
    else
        return 0
    end
end
--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- shadowform,if=!buff.shadowform.up
    if not buff.shadowform.exists() then
        if not voidform then
            if cast.shadowform() then return end
        end
    end
    -- Dispel Magic
    if isChecked("Dispel Magic") and canDispel("target",spell.dispelMagic) and not isBoss() and GetObjectExists("target") then
        if cast.dispelMagic() then return end
    end
    --PowerWord: Shield
    if moving and not IsFalling() then
        if isChecked("PWS: Body and Soul") and talent.bodyAndSoul and not debuff.weakenedSoul.exists('player') then
             if cast.powerWordShield("player") then return end
        end
    end
    if isChecked("Power Word: Fortitude") then
        for i = 1, #br.friend do
            if not buff.powerWordFortitude.exists(br.friend[i].unit,"any") and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                if cast.powerWordFortitude() then return end
            end
        end
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
actionList.Defensive = function()

end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
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
end -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldown = function()
    -- # Use Power Infusion with Voidform. Hold for Voidform comes off cooldown in the next 10 seconds otherwise use on cd unless the Pelagos Trait Combat Meditation is talented, or if there will not be another Void Eruption this fight.
    -- actions.cds=power_infusion,if=buff.voidform.up|!soulbind.combat_meditation.enabled&cooldown.void_eruption.remains>=10|fight_remains<cooldown.void_eruption.remains
    if useCDs() then
        if voidform or cd.voidEruption.remain() >= 10 or ttd('target') < cd.voidEruption.remain() then
            if cast.powerInfusion() then return end
        end
    -- # Use Silence on CD to proc Sephuz's Proclamation.
    -- actions.cds+=/silence,target_if=runeforge.sephuzs_proclamation.equipped&(target.is_add|target.debuff.casting.react)
    
    -- # Use on CD but prioritise using Void Eruption first, if used inside of VF on ST use after a voidbolt for cooldown efficiency and for hungering void uptime if talented.
    -- actions.cds+=/boon_of_the_ascended,if=!buff.voidform.up&!cooldown.void_eruption.up&spell_targets.mind_sear>1&!talent.searing_nightmare.enabled|(buff.voidform.up&spell_targets.mind_sear<2&!talent.searing_nightmare.enabled&prev_gcd.1.void_bolt)|(buff.voidform.up&talent.searing_nightmare.enabled)
        if covenant.kyrian.active then
            if not voidform and cd.voidEruption.exists() and #searEnemies > 1 and not talent.searingNightmare or (voidform and #searEnemies < 2 and not talent.searingNightmare and cast.last.voidBolt()) or (voidform and talent.searingNightmare) then
                if cast.boonOfTheAscended() then return end
            end
        end
    -- actions.cds+=/call_action_list,name=trinkets
        if isChecked("Trinket 1") and canUseItem(13) then
            useItem(13)
            return true
        end
        if isChecked("Trinket 2") and canUseItem(14) then
            useItem(14)
            return true
        end
    end
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    -- # Executed before combat begins. Accepts non-harmful actions only.
    -- actions.precombat=flask
    -- actions.precombat+=/food
    -- actions.precombat+=/augmentation
    -- # Snapshot raid buffed stats before combat begins and pre-potting is done.
    -- actions.precombat+=/snapshot_stats
    -- actions.precombat+=/shadowform,if=!buff.shadowform.up
    -- actions.precombat+=/arcane_torrent
    -- actions.precombat+=/use_item,name=azsharas_font_of_power
    -- actions.precombat+=/variable,name=mind_sear_cutoff,op=set,value=2
    -- actions.precombat+=/vampiric_touch
    if not moving and isValidUnit("target") then
        if not debuff.vampiricTouch.exists() and not cast.current.vampiricTouch() then
            if cast.vampiricTouch("target") then return end 
        end
    end
end -- End Action List - PreCombat

-- Action List - ST
actionList.ST = function()
    -- actions.main=call_action_list,name=boon,if=buff.boon_of_the_ascended.up
    if buff.boonOfTheAscended.exists() then
        -- actions.boon=ascended_blast,if=spell_targets.mind_sear<=3
        if #searEnemies <= 3 then
            if cast.ascendedBlast() then return end
        end
        -- actions.boon+=/ascended_nova,if=spell_targets.ascended_nova>1&spell_targets.mind_sear>1+talent.searing_nightmare.enabled
        if #novaEnemies > 1 and #searEnemies > 1 + snmEnabled() then
            if cast.ascendedNova() then return end
        end
    end
   
    -- # Use Void Eruption on cooldown pooling at least 40 insanity but not if you will overcap insanity in VF. Make sure shadowfiend/mindbender is on cooldown before VE.
    -- actions.main+=/void_eruption,if=variable.pool_for_cds&insanity>=40&(insanity<=85|talent.searing_nightmare.enabled&variable.searing_nightmare_cutoff)&!cooldown.fiend.up
    if useCDs() and not voidform and not moving and power >= 40 and (power <= 85 or (talent.searingNightmare and snmCutoff)) and cd.shadowfiend.exists() then
        if cast.voidEruption() then return end
    end
    
    -- # Make sure you put up SW:P ASAP on the target if Wrathful Faerie isn't active.
    -- actions.main+=/shadow_word_pain,if=buff.fae_guardians.up&!debuff.wrathful_faerie.up
    if buff.faeGuardians.exists() and not debuff.wrathfulFaerie.exists('target') then
        if cast.shadowWordPain('target') then return end
    end

    if debuff.shadowWordPain.remainCount(3) < SWPmaxTargets then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if debuff.shadowWordPain.refresh(thisUnit) and ttd(thisUnit) > 4 and not talent.misery and not (talent.searingNightmare and #searEnemies > getOptionValue("Mind Sear Targets")) and (not talent.psychicLink or (talent.psychicLink and #searEnemies <= 2)) then
                cast.shadowWordPain(thisUnit)
            end
        end
    end
    
    -- actions.main+=/call_action_list,name=cds
    -- if actionList.Cooldown() then return true end
    
    
    -- # High Priority Mind Sear action to refresh DoTs with Searing Nightmare
    -- actions.main+=/mind_sear,target_if=talent.searing_nightmare.enabled&spell_targets.mind_sear>variable.mind_sear_cutoff&!dot.shadow_word_pain.ticking&!cooldown.fiend.up
    if not moving and talent.searingNightmare and power > 30 and #searEnemies > getOptionValue("Mind Sear Targets") and not swpCheck and cd.shadowfiend.exists() then
        if cast.mindSear('target') then return end
    end
    
    if debuff.vampiricTouch.remainCount(4) < VTmaxTargets then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if not moving and not cast.current.vampiricTouch() and (debuff.vampiricTouch.refresh(thisUnit) and ttd(thisUnit) > 6 or (talent.misery and debuff.shadowWordPain.refresh() or buff.unfurlingDarkness.exists())) then
                if cast.vampiricTouch(thisUnit) then return end
            end
        end
    end
    
    -- # Prefer to use Damnation ASAP if any DoT is not up.
    -- actions.main+=/damnation,target_if=!variable.all_dots_up
    if talent.damnation and not allDotsUp then
        if cast.damnation('target') then return end
    end
    
    -- # Use Void Bolt at higher priority with Hungering Void up to 4 targets, or other talents on ST.
    -- actions.main+=/void_bolt,if=insanity<=85&talent.hungering_void.enabled&talent.searing_nightmare.enabled&spell_targets.mind_sear<=6|((talent.hungering_void.enabled&!talent.searing_nightmare.enabled)|spell_targets.mind_sear=1)
    if power <= 85 and talent.hungeringVoid and talent.searingNightmare and #searEnemies <= 6 or ((talent.hungeringVoid and not talent.searingNightmare) or #searEnemies == 1) then
        if cast.voidBolt('target') then return end
    end
   
    -- # Don't use Devouring Plague if you can get into Voidform instead, or if Searing Nightmare is talented and will hit enough targets.
    -- actions.main+=/devouring_plague,target_if=(refreshable|insanity>75)&(!variable.pool_for_cds|insanity>=85)&(!talent.searing_nightmare.enabled|(talent.searing_nightmare.enabled&!variable.searing_nightmare_cutoff))
    if (debuff.devouringPlague.refresh('target') or power > 75) and (not pool or power >= 85) and (not talent.searingNightmare or (talent.searingNightmare and not snmCutoff)) then
        if cast.devouringPlague('target') then return end
    end
   
    -- # Use VB on CD if you don't need to cast Devouring Plague, and there are less than 4 targets out (5 with conduit).
    -- actions.main+=/void_bolt,if=spell_targets.mind_sear<(4+conduit.dissonant_echoes.enabled)&insanity<=85&talent.searing_nightmare.enabled|!talent.searing_nightmare.enabled
    if #searEnemies < (4 + dEchoesCheck()) and power <= 85 and talent.searingNightmare or not talent.searingNightmare then
        if buff.dissonantEchoes.exists() then
            if cast.devoidBolt('target') then return end
        else
            if cast.voidBolt('target') then return end
        end
    end
    
    -- # Use Shadow Word: Death if the target is about to die or you have Shadowflame Prism equipped with Mindbender or Shadowfiend active.
    -- actions.main+=/shadow_word_death,target_if=(target.health.pct<20&spell_targets.mind_sear<4)|(pet.fiend.active&runeforge.shadowflame_prism.equipped)
    if (thp < 20 and #searEnemies < 4) then
        if cast.shadowWordDeath('target') then return end
    end
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        if getHP(thisUnit) < 20 and #searEnemies < 4 then
            if cast.shadowWordDeath(thisUnit) then return end
        end
    end
    
    -- # Use Surrender to Madness on a target that is going to die at the right time.
    -- actions.main+=/surrender_to_madness,target_if=target.time_to_die<25&buff.voidform.down
    if talent.surrenderToMadness and ttd('target') < 25 and not buff.voidForm.exists() then
        if cast.surrenderToMadness() then return end
    end
    
    -- # Use Void Torrent only if SW:P and VT are active and the target won't die during the channel.
    -- actions.main+=/void_torrent,target_if=variable.dots_up&target.time_to_die>3&buff.voidform.down&active_dot.vampiric_touch==spell_targets.vampiric_touch&spell_targets.mind_sear<(5+(6*talent.twist_of_fate.enabled))
    if not moving and dotsUp and ttd('target') > 5 and not voidform and not cast.last.voidEruption() and not vtCheck() and #searEnemies < (5 + (6 * ToF())) and power <= 60 then
        if cast.voidTorrent('target') then return end
    end
    
    -- actions.main+=/mindbender,if=dot.vampiric_touch.ticking&(talent.searing_nightmare.enabled&spell_targets.mind_sear>variable.mind_sear_cutoff|dot.shadow_word_pain.ticking)
    if useCDs() and debuff.vampiricTouch.exists('target') and (talent.searingNightmare and #searEnemies > getOptionValue("Mind Sear Targets") or debuff.shadowWordPain.exists('target')) then
        if talent.mindBender then
            if cast.mindBender('target') then return end
        else
            if cast.shadowfiend('target') then return end
        end
    end
    
    -- # Use SW:D with Painbreaker Psalm unless the target will be below 20% before the cooldown comes back
    -- actions.main+=/shadow_word_death,if=runeforge.painbreaker_psalm.equipped&variable.dots_up&target.time_to_pct_20>(cooldown.shadow_word_death.duration+gcd)


    -- Venthyr Cov
    if covenant.venthyr.active and dotsUp and not moving then
        if cast.mindgames('target') then return end
    end
    
    -- # Use Shadow Crash on CD unless there are adds incoming.
    -- actions.main+=/shadow_crash,if=raid_event.adds.in>10
    if talent.shadowCrash and cd.shadowCrash.ready() and isChecked('Shadow Crash') then
        if cast.shadowCrash("best",nil,1,8) then
            SpellStopTargeting() return 
        end
    end
    
    -- dark thoughts procs handled in cwc
    -- # Use Mind Sear to consume Dark Thoughts procs on AOE. TODO Confirm is this is a higher priority than redotting on AOE unless dark thoughts is about to time out
    -- actions.main+=/mind_sear,target_if=spell_targets.mind_sear>variable.mind_sear_cutoff&buff.dark_thought.up,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
    -- # Use Mind Flay to consume Dark Thoughts procs on ST. TODO Confirm if this is a higher priority than redotting unless dark thoughts is about to time out
    -- actions.main+=/mind_flay,if=buff.dark_thought.up&variable.dots_up,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&cooldown.void_bolt.up
    
    
    -- # Use Mind Blast if you don't need to refresh DoTs. Stop casting at 4 or more targets with Searing Nightmare talented.
    -- actions.main+=/mind_blast,if=variable.dots_up&raid_event.movement.in>cast_time+0.5&(spell_targets.mind_sear<4&!talent.misery.enabled|spell_targets.mind_sear<6&talent.misery.enabled)
    if not moving and dotsUp and (#searEnemies < 4 and not talent.misery or #searEnemies < 6 and talent.misery) then
        if cast.mindBlast('target') then return end
    end
   
    -- actions.main+=/vampiric_touch,target_if=refreshable&target.time_to_die>6|(talent.misery.enabled&dot.shadow_word_pain.refreshable)|buff.unfurling_darkness.up
    if not moving and not cast.current.vampiricTouch() and (debuff.vampiricTouch.refresh('target') and ttd('target') > 6 or (talent.misery and debuff.shadowWordPain.refresh() or buff.unfurlingDarkness.exists())) then
        --if not cast.last.vampiricTouch() then
            if cast.vampiricTouch('target') then return end
        --end
    end
    if debuff.vampiricTouch.remainCount(4) < VTmaxTargets then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if not moving and not cast.current.vampiricTouch() and (debuff.vampiricTouch.refresh(thisUnit) and ttd(thisUnit) > 6 or (talent.misery and debuff.shadowWordPain.refresh() or buff.unfurlingDarkness.exists())) then
                if cast.vampiricTouch(thisUnit) then return end
            end
        end
    end
    
    -- # Special condition to stop casting SW:P on off-targets when fighting 3 or more stacked mobs and using Psychic Link and NOT Misery.
    -- actions.main+=/shadow_word_pain,if=refreshable&target.time_to_die>4&!talent.misery.enabled&talent.psychic_link.enabled&spell_targets.mind_sear>2
    if debuff.shadowWordPain.refresh() and ttd(units.dyn40) > 4 and not talent.misery and talent.psychicLink and #searEnemies > 2 then
        if cast.shadowWordPain(units.dyn40) then return end
    end
    
    -- # Keep SW:P up on as many targets as possible, except when fighting 3 or more stacked mobs with Psychic Link.
    -- actions.main+=/shadow_word_pain,target_if=refreshable&target.time_to_die>4&!talent.misery.enabled&!(talent.searing_nightmare.enabled&spell_targets.mind_sear>variable.mind_sear_cutoff)&(!talent.psychic_link.enabled|(talent.psychic_link.enabled&spell_targets.mind_sear<=2))
    if debuff.shadowWordPain.refresh(units.dyn40) and ttd(units.dyn40) > 4 and not talent.misery and not (talent.searingNightmare and #searEnemies > getOptionValue("Mind Sear Targets")) and (not talent.psychicLink or (talent.psychicLink and #searEnemies <= 2)) then
        if cast.shadowWordPain(units.dyn40) then return end
    end

    if debuff.shadowWordPain.remainCount(3) < SWPmaxTargets then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if debuff.shadowWordPain.refresh(thisUnit) and ttd(thisUnit) > 4 and not talent.misery and not (talent.searingNightmare and #searEnemies > getOptionValue("Mind Sear Targets")) and (not talent.psychicLink or (talent.psychicLink and #searEnemies <= 2)) then
                cast.shadowWordPain(thisUnit)
            end
        end
    end
    
    -- actions.main+=/mind_sear,target_if=spell_targets.mind_sear>variable.mind_sear_cutoff,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
    if #searEnemies > getOptionValue("Mind Sear Targets") and not moving then
        if cast.mindSear('target') then return end
    end
    
    -- actions.main+=/mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&cooldown.void_bolt.up
    if dotsUp and not moving then
        if cast.mindFlay('target') then return end
    end
  
    -- # Use SW:D as last resort if on the move
    -- actions.main+=/shadow_word_death
    if moving and cd.shadowWordDeath.ready() and getHP(units.dyn40) then
        if cast.shadowWordDeath(units.dyn40) then return end
    end
    
    -- # Use SW:P as last resort if on the move and SW:D is on CD
    -- actions.main+=/shadow_word_pain
    if moving and debuff.shadowWordPain.refresh() then
        if cast.shadowWordPain(units.dyn40) then return end
    end
    if moving then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if debuff.shadowWordPain.refresh(thisUnit) then
                if cast.shadowWordPain(thisUnit) then return end
            end
        end
    end

end -- End Action List - ST

-- Action List - AE
actionList.AE = function()

end -- End Action List - AE

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                            = br.player.buff
    cast                                            = br.player.cast
    cd                                              = br.player.cd
    conduit                                         = br.player.conduit
    covenant                                        = br.player.covenant
    debuff                                          = br.player.debuff
    enemies                                         = br.player.enemies
    equiped                                         = br.player.equiped
    gcd                                             = br.player.gcd
    gcdMax                                          = br.player.gcdMax
    has                                             = br.player.has
    inCombat                                        = br.player.inCombat
    item                                            = br.player.items
    level                                           = br.player.level
    mode                                            = br.player.ui.mode
    moving                                          = isMoving('player')
    mrdm                                            = math.random
    power                                           = br.player.power.insanity.amount()
    php                                             = br.player.health
    spell                                           = br.player.spell
    talent                                          = br.player.talent
    thp                                             = getHP("target")
    units                                           = br.player.units
    use                                             = br.player.use
    voidform                                        = buff.voidForm.exists()
    -- General Locals   
    hastar                                          = GetObjectExists("target")
    healPot                                         = getHealthPot()
    profileStop                                     = profileStop or false
    ttd                                             = getTTD
    haltProfile = (inCombat and profileStop) or (IsMounted() or IsFlying()) or pause() or mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    -- Enemies
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(8) -- Makes a varaible called, enemies.yards8
    enemies.get(20) -- Makes a variable called, enemies.yards20
    enemies.get(30) -- Makes a varaible called, enemies.yards30
    enemies.get(40) -- Makes a varaible called, enemies.yards40

    -- Profile Specific Locals
    allDotsUp                                       = debuff.shadowWordPain.exists() and debuff.vampiricTouch.exists() and debuff.devouringPlague.exists()
    dotsUp                                          = debuff.shadowWordPain.exists() and debuff.vampiricTouch.exists()
    mfTicks                                         = br.mfTicks
    msTicks                                         = br.msTicks
    novaEnemies                                     = getEnemies('player', 8, true)
    --actions+=/variable,name=pool_for_cds,op=set,value=cooldown.void_eruption.up&(!raid_event.adds.up|raid_event.adds.duration<=10
    --|raid_event.adds.remains>=10+5*(talent.hungering_void.enabled|covenant.kyrian))&((raid_event.adds.in>20|spell_targets.void_eruption>=5)
    --|talent.hungering_void.enabled|covenant.kyrian)
    pool                                            = cd.voidEruption.ready()
    searEnemies                                     = getEnemies(units.dyn40, 8, true)
    --# Start using Searing Nightmare at 3+ targets or 4+ if you are in Voidform
    --actions+=/variable,name=searing_nightmare_cutoff,op=set,value=spell_targets.mind_sear>2+buff.voidform.up
    snmCutoff                                       = #searEnemies > 2 + buff.voidForm.count()
    SWPmaxTargets                                 = getOptionValue("SWP Max Targets")
    VTmaxTargets                                  = getOptionValue("VT Max Targets")

    -- biggestGroup = 0
    -- for i = 1, #enemies.yards20 do
    --     thisUnit = enemies.yards20[i]
    --     thisGroup = #enemies.get(8,thisUnit)
    --     targetGroup = #enemies.get(8,"target")
    --     if thisGroup > biggestGroup and thisGroup>targetGroup then
    --         thisGroup = biggestGroup
    --         bestUnit = thisUnit
    --     end
    -- end

    -- SimC specific variables
    

    --Clear last cast table ooc to avoid strange casts
    if not inCombat and #br.lastCast.tracker > 0 then
        wipe(br.lastCast.tracker)
    end
    ---------------------
    --- Begin Profile ---
    ---------------------
    if CwC() then return end
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop then
        profileStop = false
    elseif haltProfile then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extra() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if inCombat and isValidUnit("target") then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupt() then return true end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            -- Cooldowns
            -- call_action_list,name=CDs
            if actionList.Cooldown() then return true end
            -- call_cation_list,name=Main
            if actionList.ST() then return true end
            --if actionList.AE() then return true end

        end -- End In Combat Rotation
    end -- Pause
    return true
end -- End runRotation
local id = 258 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})