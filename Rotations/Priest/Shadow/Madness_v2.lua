local rotationName = "Madness v2" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.mindControl },
        [2] = { mode = "Sing", value = 2 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mindFlay },
        [3] = { mode = "Off", value = 3 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0}
    };
    CreateButton("Rotation",1,0)
-- Essence Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic", tip = "Automatic Cooldowns - Boss detection.", highlight = 1, icon = br.player.spell.mindVision },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Always use Cooldowns", highlight = 0, icon = br.player.spell.shadowfiend },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "Off", highlight = 0}
    };
    CreateButton("Cooldown",2,0)
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
        br.ui:checkSectionState(section)
        -----------------------
        --- Trinket OPTIONS --- -- Define Trinket Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "Trinkets")
            br.ui:createCheckbox(section, "Use Trinkets", "Use Trinkets on CD")
            br.ui:createCheckbox(section, "Azshara's Font of Power")
        br.ui:checkSectionState(section)
        -----------------------
        --- GENERAL DPS OPTIONS --- -- Define Dps Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General Dps")
            br.ui:createSpinnerWithout(section, "Vamp Touch Max Targets", 4, 1, 10, 1)
            br.ui:createSpinnerWithout(section, "Shadow Word: Pain Max Targets", 4, 1, 10, 1)
            br.ui:createSpinnerWithout(section, "Max HP for Dots", 5, 1, 10, 1, "Num * 10k for Max HP to Dot")
        br.ui:checkSectionState(section)
        -----------------------
        --- Essence OPTIONS --- -- Define Essence Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "Essences")
            br.ui:createCheckbox(section, "Use Essences", "Will update/add individual essences later. Currently supports Lucid Dreams, Conc, and Focused Azerite Beam and Guardian")
            br.ui:createSpinnerWithout(section, "Meme Beam Enemies", 2, 1, 10, 1, "Number of Enemies to Cast Focused Azerite Beam")

        br.ui:checkSectionState(section)

        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            br.ui:createCheckbox(section, "Shadowfiend", "Casts Shadowfiend.")

        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

local actionList = {}

----------------
--- ROTATION ---
----------------
local function runRotation()
    if br.timer:useTimer("Madness", 0.1) then
    --------------------------------------
    --- Load Additional Rotation Files ---
    --------------------------------------
    -- if actionList.Blacklist == nil then
    --     loadSupport("Blacklist")
    --     actionList.Blacklist = br.rotations.support["Blacklist"]
    -- end


---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldowns",0.25)

--------------
--- Locals ---
--------------
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies                                      
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player") > 0
        local focusedTime                                   = GetTime()
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local gHaste                                        = br.player.gcdMax / (1 + GetHaste() / 100)
        local inCombat                                      = br.player.inCombat
        local leftCombat
        local mode                                          = br.player.mode      
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power, br.player.powerMax, br.player.powerRegen
        local profileStop
        local spell                                         = br.player.spell
        local totalHaste                                    = UnitSpellHaste("player") / 100
        local talent                                        = br.player.talent
        local tinsert                                       = table.insert
        local traits                                        = br.player.traits
        local ttd                                           = getTTD
        local units                                         = br.player.units
        local power, powmax, powgen, powerDeficit           = br.player.power.insanity.amount(), br.player.power.insanity.max(), br.player.power.insanity.regen(), br.player.power.insanity.deficit()

        --Class Specific
        local mindBlastTargets                              = ((4.5 + traits.whispersOfTheDamned.rank) % (1 + 0.27 * traits.searingDialogue.rank))
        local hasDots                                       = debuff.vampiricTouch.exists("target") and debuff.shadowWordPain.exists("target")
        local voidForm                                      = buff.voidForm.exists()

        --Vamp Touch Anti Clip
        a = {}

        local vtTickRate                                    = 3 / (1 + totalHaste)      -- Vamp Touch Tick Rate
        local vtTotalTicks                                  = 21 / vtTickRate           -- Total Vamp Touch Ticks
        local vampDuration                                  = 21
        local vtTickInTime                                  = 0
        local i = 0
        while i < vtTotalTicks do
            vtTickInTime = vampDuration - vtTickRate
            vampDuration = vampDuration - vtTickRate
            i = i + 1
            tinsert(a, vtTickInTime)
        end
        local vtAntiClip = a[getn(a) - 2]
        --Print(a[getn(a)] .. " = Last")
        --Print(a[getn(a) - 1] .. " = Second to last")
        --Print(a[getn(a) - 2] .. " = Third to last")


        --Shadow Word Pain Anti Clip
        b = {}

        local swpTickRate                                   = 2 / (1 + totalHaste)
        local swpTotalTicks                                 = 16 / swpTickRate
        local swpDuration                                   = 16
        local swpTickInTime                                 = 0
        local y = 0
        while y < swpTotalTicks do
            swpTickInTime = swpDuration - swpTickRate
            swpDuration   = swpDuration - swpTickRate
            y = y + 1
            tinsert(b, swpTickInTime)
        end
        local swpAntiClip = b[getn(b) - 2]
        --Print(b[getn(b)] .. " = Last")
        --Print(b[getn(b) - 1] .. " = Second to last")
        --Print(b[getn(b) - 2] .. " = Third to last")        
       
        --Essence Stuff
        local beamEnemies = getEnemiesInRect(5,30)

        --General
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil  then
            profileStop = false
        end
        if hasBloodLust() then lusting = 1 else lusting = 0 end

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
        insanityDrained = insanityDrain * gcdMax * 3

        --Enemy Tables
        enemies.get(8)
        enemies.get(8, "target")
        enemies.get(40)
        enemies.get(40, "target")

        local searEnemyTable = {}
        if #enemies.yards8t > 0 then
            for i = 1, #enemies.yards8t do
                local thisUnit = enemies.yards8t[i]
                tinsert(searEnemyTable, thisUnit)
            end
        end
        local enemyTable40 = {}
        if #enemies.yards40 > 0 then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if isValidTarget(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and not isCCed(thisUnit) then
                    local enemyUnit = {}
                    enemyUnit.unit = thisUnit
                    enemyUnit.ttd = thisUnit
                    enemyUnit.distance = getDistance(thisUnit)
                    enemyUnit.distance20 = math.abs(getDistance(thisUnit) - 20)
                    enemyUnit.hpabs = UnitHealth(thisUnit)
                    enemyUnit.facing = getFacing(player, thisUnit)
                tinsert(enemyTable40, enemyUnit)
                end
            end
        end
            --Print(#enemyTable40)

---------------------
--- Extra Actions ---
---------------------
--Shadow form if buff does not exist
function shadowForm()
    if not buff.shadowform.exists() then
            if cast.shadowform() then return end
    end
end
---------------------
--- Action Lists ----
---------------------
--  run everytime actor is available
--	variable,name=dots_up,op=set,value=dot.shadow_word_pain.ticking&dot.vampiric_touch.ticking
--  run_action_list,name=cleave,if=active_enemies>1
--  run_action_list,name=single,if=active_enemies=1

function coolies()
    if useCDs() and isChecked("Shadowfiend") then
        --Shadowfiend
        if cast.shadowfiend() then return end
        --Trinkets
        if isChecked("Trinkets") then
            if canUseItem(13) then
                useItem(13)
            end
            if canUseItem(14) then
                useItem(14)
            end
        end
    end
end

function crit_cds()
    --Azshara's Font of Power
    if isChecked("Azshara's Font of Power") then
        --use_item,name=azsharas_font_of_power
        if GetItemCooldown(169314) <= gcdMax then
            UseItemByName(169314)
        end
    end
end

function essences()
    if isChecked("Use Essences") and useCDs() then   
    --	memory_of_lucid_dreams,if=(buff.voidform.stack>20&insanity<=50)|buff.voidform.stack>(26+7*buff.bloodlust.up)|(current_insanity_drain*gcd.max*3)>insanity
    --  Use Memory of Lucid Dreams right before you are about to fall out of 
    if inCombat and (buff.voidForm.stack() > 20 and power <= 50) or (buff.voidForm.stack() > 26 + 7 * lusting) or (insanityDrain * gcdMax * 3) > power then
        if cast.memoryOfLucidDreams() then return end
    end
    --  blood_of_the_enemy
    --  guardian_of_azeroth,if=buff.voidform.stack>15
    if cast.able.guardianOfAzeroth() and buff.voidForm.stack() >= 15 then
        if cast.guardianOfAzeroth() then return end
    end
    --  focused_azerite_beam,if=spell_targets.mind_sear>=2|raid_event.adds.in>60
    if beamEnemies >= getOptionValue("Meme Beam Enemies") and not moving then
        if cast.focusedAzeriteBeam() then return end
    end
	--  purifying_blast,if=spell_targets.mind_sear>=2|raid_event.adds.in>60
    --  the_unbound_force
    --  concentrated_flame
    if cast.able.concentratedFlame() then
        if cast.concentratedFlame() then return end
    end
	--  ripple_in_space
	--  worldvein_resonance,if=buff.lifeblood.stack<3
	--  call_action_list,name=crit_cds,if=(buff.voidform.up&buff.chorus_of_insanity.stack>20)|azerite.chorus_of_insanity.rank=0
    --  Use these cooldowns in between your 1st and 2nd Void Bolt in your 2nd Voidform when you have Chorus of Insanity active
	--  use_items
    --  Default fallback for usable items: Use on cooldown.
    end
end

function voidFormCleave_List()
    --  void bolt
    if cast.able.voidBolt() then
        if cast.voidBolt() then return end
    end  
    --  coolies
    if essences() then return end
    if coolies() then return end

    --  crit cd's
    --  call_action_list,name=crit_cds,if=(buff.voidform.up&buff.chorus_of_insanity.stack>20)|azerite.chorus_of_insanity.rank=0
    if (buff.voidForm.exists() and buff.chorusOfInsanity.stack() > 20) or traits.chorusOfInsanity.rank == 0 then
        if crit_cds() then return end
    end
    --  mind_blast,target_if=spell_targets.mind_sear<variable.mind_blast_targets
    for i = 1, #enemyTable40 do
        local thisUnit = enemyTable40[i].unit
        if not moving and (#searEnemyTable - 1) < mindBlastTargets then
            if cast.mindBlast(thisUnit) then return end
        end
    end
    --  shadow_crash,if=(raid_event.adds.in>5&raid_event.adds.duration<2)|raid_event.adds.duration>2
    if cast.able.shadowCrash() then
        if cast.shadowCrash("target") then return end
    end
    --  shadow_word_pain,target_if=refreshable&target.time_to_die>((-1.2+3.3*spell_targets.mind_sear)*variable.swp_trait_ranks_check*(1-0.012*azerite.searing_dialogue.rank*spell_targets.mind_sear)),if=!talent.misery.enabled
    if not talent.misery and debuff.shadowWordPain.remainCount() < getOptionValue("Shadow Word: Pain Max Targets") or not debuff.shadowWordPain.exists("target") then
        for i = 1, #enemyTable40 do
            local thisUnit = enemyTable40[i].unit
            if not talent.misery and ttd(thisUnit) > ((-1.2 + 3.3 * #searEnemyTable) * ((1 - 0.07 * traits.deathThroes.rank + 0.2 * traits.thoughtHarvester.rank) * (1 - 0.09 * traits.thoughtHarvester.rank * traits.searingDialogue.rank)) * (1 - 0.012 * traits.searingDialogue.rank * #searEnemyTable))
            and (not debuff.shadowWordPain.exists(thisUnit) or debuff.shadowWordPain.remain(thisUnit) < swpAntiClip) then
                if cast.shadowWordPain(thisUnit) then return end
            end
        end
    end
    --  vampiric_touch,target_if=refreshable,if=target.time_to_die>((1+3.3*spell_targets.mind_sear)*variable.vt_trait_ranks_check*(1+0.10*azerite.searing_dialogue.rank*spell_targets.mind_sear))
    if debuff.vampiricTouch.count() < getOptionValue("Vamp Touch Max Targets") or not debuff.vampiricTouch.exists("target") then
        for i = 1, #enemyTable40 do
            local thisUnit = enemyTable40[i].unit
            if ttd(thisUnit) > ((1 + 3.3 * #searEnemyTable) * (1 - 0.04 * traits.thoughtHarvester.rank - 0.05 * traits.spitefulApparitions.rank) * (1 + 0.10 * traits.searingDialogue.rank * #searEnemyTable)) and
            not moving and ((not debuff.vampiricTouch.exists(thisUnit) or debuff.vampiricTouch.remain(thisUnit) < vtAntiClip) or (talent.misery and debuff.shadowWordPain.remain(thisUnit) < swpAntiClip or not debuff.shadowWordPain.exists(thisUnit))) then
                if cast.vampiricTouch(thisUnit) then return end
            end
        end
    end
    --	mind_sear,target_if=spell_targets.mind_sear>1,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
    if #searEnemyTable > 1 and not moving and not cast.current.mindSear() then
        if cast.mindSear() then return end
    end
end

function voidFormSingle_List()
    --  void eruption
    if not moving and cast.able.voidEruption() then
        if cast.voidEruption("target") then return end
    end
    --  void bolt
    if not cast.last.voidBolt() then
        if cast.voidBolt("target") then return end
    end
    --  coolies
    if essences() then return end
    if coolies() then return end

    --  crit cd's
    --  call_action_list,name=crit_cds,if=(buff.voidform.up&buff.chorus_of_insanity.stack>20)|azerite.chorus_of_insanity.rank=0
    if (buff.voidForm.exists() and buff.chorusOfInsanity.stack() > 20) or traits.chorusOfInsanity.rank == 0 then
        if crit_cds() then return end
    end
    --  Mind Sear if Dialogue Proc
    --  mind_sear,if=buff.harvested_thoughts.up&cooldown.void_bolt.remains>=1.5&azerite.searing_dialogue.rank>=1
    if not moving and buff.harvestedThoughts.exists() and (br.player.cd.voidBolt.remain() >= 1.5 or not buff.voidForm.exists()) and traits.searingDialogue.rank >= 1 and not cast.current.mindSear() then
        if cast.mindSear("target") then return end
    end
    --  shadow_crash,if=raid_event.adds.in>5&raid_event.adds.duration<20
    --  Use Shadow Crash on CD unless there are adds incoming.
    if cast.able.shadowCrash("target") then
        if cast.shadowCrash("target") then return end
    end
    --  mind_blast,if=variable.dots_up&(!talent.shadow_word_void.enabled|buff.voidform.down|buff.voidform.stack>14&(insanity<70|charges_fractional>1.33)|buff.voidform.stack<=14&(insanity<60|charges_fractional>1.33))
    if not moving and (not talent.shadowWordVoid or not buff.voidForm.exists() or buff.voidForm.stack() > 14 and (power < 70 or getChargesFrac(spell.shadowWordVoid) > 1.33 or buff.voidForm.stack() <= 14 and (power < 60 or getChargesFrac(spell.shadowWordVoid) > 1.33) )) then
        if cast.mindBlast("target") then return end
    end
    --shadow_word_pain,if=refreshable&target.time_to_die>4&!talent.misery.enabled&!talent.dark_void.enabled
    if not cast.last.shadowWordPain("target") and ttd("target") > 4 and (not talent.misery and not talent.darkVoid) and (not debuff.shadowWordPain.exists("target") or debuff.shadowWordPain.remain("target") < swpAntiClip) then
        if cast.shadowWordPain() then Print("Casting SWP with "..debuff.shadowWordPain.remain("target").." seconds left.") return end
    end
    --vampiric_touch,if=refreshable&target.time_to_die>6|(talent.misery.enabled&dot.shadow_word_pain.refreshable)
    if not cast.last.vampiricTouch("target") and not moving and ttd("target") > 6 and (not debuff.vampiricTouch.exists("target") or (debuff.vampiricTouch.remain("target") < vtAntiClip) or (talent.misery and debuff.shadowWordPain.remain("target") < swpAntiClip)) then
        if cast.vampiricTouch() then return end
    end
    --mind mindFlay
    if not moving and not cast.current.mindFlay() then
        if cast.mindFlay("target") then return end
    end
end

function cleave()
    --  void eruption
    if cast.able.voidEruption() then
        if cast.voidEruption() then return end
    end
    --  mind_blast,target_if=spell_targets.mind_sear<variable.mind_blast_targets
    for i = 1, #enemyTable40 do
        local thisUnit = enemyTable40[i].unit
        if not moving and (#searEnemyTable - 1) < mindBlastTargets then
            if cast.mindBlast(thisUnit) then return end
        end
    end
    --  shadow_crash,if=(raid_event.adds.in>5&raid_event.adds.duration<2)|raid_event.adds.duration>2
    if cast.able.shadowCrash() then
        if cast.shadowCrash("target") then return end
    end
    --  shadow_word_pain,target_if=refreshable&target.time_to_die>((-1.2+3.3*spell_targets.mind_sear)*variable.swp_trait_ranks_check*(1-0.012*azerite.searing_dialogue.rank*spell_targets.mind_sear)),if=!talent.misery.enabled
    if not talent.misery and debuff.shadowWordPain.remainCount() < getOptionValue("Shadow Word: Pain Max Targets") or not debuff.shadowWordPain.exists("target") then
        for i = 1, #enemyTable40 do
            local thisUnit = enemyTable40[i].unit
            if not talent.misery and ttd(thisUnit) > ((-1.2 + 3.3 * #searEnemyTable) * ((1 - 0.07 * traits.deathThroes.rank + 0.2 * traits.thoughtHarvester.rank) * (1 - 0.09 * traits.thoughtHarvester.rank * traits.searingDialogue.rank)) * (1 - 0.012 * traits.searingDialogue.rank * #searEnemyTable))
            and (not debuff.shadowWordPain.exists(thisUnit) or debuff.shadowWordPain.remain(thisUnit) < swpAntiClip) then
                if cast.shadowWordPain(thisUnit) then return end
            end
        end
    end
    --  vampiric_touch,target_if=refreshable,if=target.time_to_die>((1+3.3*spell_targets.mind_sear)*variable.vt_trait_ranks_check*(1+0.10*azerite.searing_dialogue.rank*spell_targets.mind_sear))
    if debuff.vampiricTouch.count() < getOptionValue("Vamp Touch Max Targets") or not debuff.vampiricTouch.exists("target") then
        for i = 1, #enemyTable40 do
            local thisUnit = enemyTable40[i].unit
            if ttd(thisUnit) > ((1 + 3.3 * #searEnemyTable) * (1 - 0.04 * traits.thoughtHarvester.rank - 0.05 * traits.spitefulApparitions.rank) * (1 + 0.10 * traits.searingDialogue.rank * #searEnemyTable)) and
            not moving and ((not debuff.vampiricTouch.exists(thisUnit) or debuff.vampiricTouch.remain(thisUnit) < vtAntiClip) or (talent.misery and debuff.shadowWordPain.remain(thisUnit) < swpAntiClip or not debuff.shadowWordPain.exists(thisUnit))) then
                if cast.vampiricTouch(thisUnit) then return end
            end
        end
    end

    --	mind_sear,target_if=spell_targets.mind_sear>1,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
    if #searEnemyTable > 1 and not moving and not cast.current.mindSear() then
        if cast.mindSear() then return end
    end
    --  mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(cooldown.void_bolt.up|cooldown.mind_blast.up)
    if not moving and not cast.current.mindFlay() then
        if cast.mindFlay() then return end
    end
end

function singleTarget()
    --  void eruption
    if not moving and cast.able.voidEruption() then
        if cast.voidEruption() then return end
    end
    --  Mind Sear if Dialogue Proc
    --  mind_sear,if=buff.harvested_thoughts.up&cooldown.void_bolt.remains>=1.5&azerite.searing_dialogue.rank>=1
    if not moving and buff.harvestedThoughts.exists() and (br.player.cd.voidBolt.remain() >= 1.5 or not buff.voidForm.exists()) and traits.searingDialogue.rank >= 1 and not cast.current.mindSear() then
        if cast.mindSear() then return end
    end
    --  shadow_crash,if=raid_event.adds.in>5&raid_event.adds.duration<20
    --  Use Shadow Crash on CD unless there are adds incoming.
    if cast.able.shadowCrash("target") then
        if cast.shadowCrash("target") then return end
    end
    --  mind_blast,if=variable.dots_up&(!talent.shadow_word_void.enabled|buff.voidform.down|buff.voidform.stack>14&(insanity<70|charges_fractional>1.33)|buff.voidform.stack<=14&(insanity<60|charges_fractional>1.33))
    if not moving and (not talent.shadowWordVoid or not buff.voidForm.exists() or buff.voidForm.stack() > 14 and (power < 70 or getChargesFrac(spell.shadowWordVoid) > 1.33 or buff.voidForm.stack() <= 14 and (power < 60 or getChargesFrac(spell.shadowWordVoid) > 1.33) )) then
        if cast.mindBlast() then return end
    end
    --shadow_word_pain,if=refreshable&target.time_to_die>4&!talent.misery.enabled&!talent.dark_void.enabled
    if not cast.last.shadowWordPain("target") and ttd("target") > 4 and (not talent.misery and not talent.darkVoid) and (not debuff.shadowWordPain.exists("target") or debuff.shadowWordPain.remain("target") < swpAntiClip) then
        if cast.shadowWordPain() then Print("Casting SWP with "..debuff.shadowWordPain.remain("target").." seconds left.") return end
    end
    --vampiric_touch,if=refreshable&target.time_to_die>6|(talent.misery.enabled&dot.shadow_word_pain.refreshable)
    if not cast.last.vampiricTouch("target") and not moving and ttd("target") > 6 and (not debuff.vampiricTouch.exists("target") or (debuff.vampiricTouch.remain("target") < vtAntiClip) or (talent.misery and debuff.shadowWordPain.remain("target") < swpAntiClip)) then
        if cast.vampiricTouch() then Print("Casting VT with "..debuff.vampiricTouch.remain("target").." seconds left.") return end
    end
    --mind mindFlay
    if not moving and not cast.current.mindFlay() then
        if cast.mindFlay() then return end
    end
end

-----------------
--- Rotations ---
-----------------
        -- Pause
        if (pause() or (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) or mode.rotation == 3) and not isCastingSpell(spell.mindFlay) and not (isCastingSpell(spell.mindSear) and not traits.searingDialogue.active) then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and (not IsMounted() or not IsFlying()) then
                if shadowForm() then return end
            end
            if not inCombat and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                if shadowForm() then return end
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat and isValidUnit("target") and profileStop == false and not (IsMounted() or IsFlying()) then
                if voidForm and #enemyTable40 >= 2 then
                    if voidFormCleave_List() then return end
                else
                    if voidForm and #enemyTable40 == 1 or mode.rotation == 2 then
                        if voidFormSingle_List() then return end
                    else
                        if #enemyTable40 == 1 or mode.rotation == 2 then
                            if singleTarget() then return end
                        else
                            if #enemyTable40 >= 2 then
                                if cleave() then return end
                            end
                        end
                    end
                end
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation


local id = 258
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})