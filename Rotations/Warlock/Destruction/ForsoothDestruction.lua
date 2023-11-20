local rotationName = "ForsoothDestruction"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.shadowBolt },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.soulShards }
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.unendingResolve},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.unendingResolve}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
    --Pet summon
    local PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Imp", tip = "Summon Imp", highlight = 1, icon = br.player.spell.summonImp },
        [2] = { mode = "2", value = 2 ,overlay = "Voidwalker", tip = "Summon Voidwalker", highlight = 1, icon = br.player.spell.summonVoidwalker },
        [3] = { mode = "None", value = 3 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.fear }
    };
    br.ui:createToggle(PetSummonModes,"PetSummon",3,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Corruption
            br.ui:createCheckbox(section, "Use Corruption")
            -- Curse of Weakness
            br.ui:createCheckbox(section, "Use Curse of Weakness")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Drain Life
            br.ui:createSpinner(section, "Drain Life", 40, 0, 100, 5, "|cffFFFFFFPet Health Percent to Cast At")
            -- Health Funnel
            br.ui:createSpinner(section, "Health Funnel", 30, 0, 95, 5, "|cffFFFFFFPet Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Player Limit", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to not use below.")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  95,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Unending Resolve
            br.ui:createSpinner(section, "Unending Resolve", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
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
-- BR API Locals
local buff
local cast
local cd
local charges
local talent
local debuff
local enemies
local equiped
local has
local mode
local ui
local gcd
local pet
local spell
local unit
local units
local use
local var
local ui
local soulShards
-- General Locals
local haltProfile
local profileStop
-- Profile Specific Locals
local actionList = {}

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive
actionList.Defensive = function()
    -- Drain Life
    if cast.able.drainLife(units.dyn40) and unit.hp() <= ui.value("Drain Life") and unit.inCombat() then
        if cast.drainLife() then ui.debug("Channeling Drain Life") return true end
    end
    -- Health Funnel
    if cast.able.healthFunnel() and unit.hp("pet") <= ui.value("Health Funnel") and unit.hp("player") > ui.value("Player Limit") then
        if cast.healthFunnel("pet") then ui.debug("Channeling Health Funnel") return true end
    end
    -- Healthstone
    if ui.checked("Healthstone") then
        if use.able.healthstone() and unit.inCombat() and has.healthstone() and unit.hp() <= ui.value("Healthstone") then
            if use.healthstone() then ui.debug("Using Healthstone") return true end
        end
        if cast.able.createHealthstone() and not has.healthstone() and not ui.fullBags() then
            if cast.createHealthstone() then ui.debug("Casting Create Healthstone") return true end
        end
    end
    -- Unending Resolve
    if ui.checked("Unending Resolve") and unit.hp() <= ui.value("Unending Resolve") and unit.inCombat() then
        if cast.unendingResolve() then ui.debug("Casting Unending Resolve") return true end
    end

end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            --actions.precombat+=/summon_pet
    if not unit.moving() and unit.level() >= 3 and GetTime() - br.pauseTime > 0.5
        and br.timer:useTimer("summonPet", 1)
    then
        if (mode.petSummon == 1 or (mode.petSummon == 2 and not spell.known.summonVoidwalker())) and not pet.imp.active() then
            if cast.summonImp("player") then return true end
        end
        if mode.petSummon == 2 and spell.known.summonVoidwalker() and not pet.voidwalker.active() then
            if cast.summonVoidwalker("player") then return true end
        end
        if mode.petSummon == 3 and (pet.imp.active() or pet.voidwalker.active()) then
            PetDismiss()
        end
    end
    -- 	variable,name=cleave_apl,default=0,op=reset
    var.cleaveApl = false
    -- variable,name=opti_cc,value=talent.crashing_chaos&equipped.neltharions_call_to_dominance,op=set
    var.optiCC = talent.crashingChaos and (equiped.neltharionsCallToDominance(13) or equiped.neltharionsCallToDominance(14))
    -- grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
    if cast.able.grimoireOfSacrifice() and talent.grimoireOfSacrifice then
        cast.grimoireOfSacrifice()
    end
    -- soul_fire
    if cast.able.soulFire() then
        cast.soulFire()
    end
    -- cataclysm,if=raid_event.adds.in>15
    if cast.able.cataclysm() then
        cast.cataclysm()
    end
    -- incinerate
    if cast.able.incinerate() then
        ui.debug("Hitting bottom incinerate 2")
        cast.incinerate()
    end
end
end
    
end -- End Action List - PreCombat

actionList.aoe = function()
    ui.debug("Action List AOE")
    -- rain_of_fire,if=pet.infernal.active|pet.blasphemy.active
    if cast.able.rainOfFire() and pet.infernal.active() or pet.blasphemy.active() then
        cast.rainOfFire("best",nil,3,8)
    end

    -- rain_of_fire,if=fight_remains<12
    if cast.able.rainOfFire() and unit.ttd() < 12 then
        cast.rainOfFire("best",nil,3,8)
    end

    -- 	rain_of_fire,if=gcd.max>buff.madness_rof.remains&buff.madness_rof.up
    if cast.able.rainOfFire and unit.gcd(true) > buff.madnessOfTheAzjaqir.remains() and buff.madnessOfTheAzjaqir.exists() then
        cast.rainOfFire("best",nil,3,8)
    end

    -- rain_of_fire,if=soul_shard>=(4.5-0.1*active_dot.immolate)&time>5
    if cast.able.rainOfFire() and soulShards.frac() >= 4.5 and unit.combatTime() > 5 then
        cast.rainOfFire("best",nil,3,8)
    end

    -- chaos_bolt,if=soul_shard > 3.5 - (0.1 * active_enemies) and not talent.rain_of_fire
    if cast.able.chaosBolt() and (soulShards.frac() > (3.5 - 0.1 * #enemies.yards40) and not talent.rainOfFire) then
        cast.chaosBolt()
    end

    -- cataclysm,if=raid_event.adds.in>15
    if cast.able.cataclysm() then
        cast.cataclysm()
    end

    -- havoc, target_if=min:((-target.time_to_die)<?-15) + dot.immolate.remains + 99 * (self.target=target), if=(!cd.summonInfernal.ready() or !talent.summonInfernal or (talent.inferno and activeEnemies() > 4) and unit.ttd() > 8
    if cast.able.havoc() and (not cd.summonInfernal.ready() or not talent.summonInfernal or (talent.inferno and #enemies.yards40 > 4) and unit.ttd() > 8) then
        cast.havoc()
    end

    -- immolate, target_if=min:dot.immolate.remains + 99 * debuff.havoc.remains, if=debuff.immolate.refreshable() and (not talent.cataclysm or cd.cataclysm.remains() > debuff.immolate.remains()) and (not talent.ragingDemonfire or cd.channelDemonfire.remains() > debuff.immolate.remains() or unit.time() < 5) and activeDot.immolate() <= 4 and unit.ttd() > 18
    if cast.able.immolate() and (debuff.immolate.refreshable and (not talent.cataclysm or cd.cataclysm.remains() > debuff.immolate.remains()) and (not talent.ragingDemonfire or cd.channelDemonfire.remains() > debuff.immolate.remains() or unit.time() < 5) and unit.ttd() > 18) then
        cast.immolate()
    end

    -- channel_demonfire,if=debuff.immolate.remains() > cast.time.channelDemonfire() and talent.ragingDemonfire
    if cast.able.channelDemonfire() and (debuff.immolate.remains() > cast.time.channelDemonfire() and talent.ragingDemonfire) then
        cast.channelDemonfire()
    end

    -- summon_soulkeeper,if=buff.tormentedSoul.stack() == 10 or buff.tormentedSoul.stack() > 3 and unit.ttd() < 10
    if cast.able.summonSoulkeeper() and (buff.tormentedSoul.stack() == 10 or buff.tormentedSoul.stack() > 3 and unit.ttd() < 10) then
        cast.summonSoulkeeper()
    end

    -- rain_of_fire,if=not debuff.pyrogenics.exists() and activeEnemies() <= 4
    if cast.able.rainOfFire() and (not debuff.pyrogenics.exists() and #enemies.yards40 <= 4) then
        cast.rainOfFire("best",nil,3,8)
    end

    -- channel_demonfire,if=debuff.immolate.remains() > cast.time.channelDemonfire()
    if cast.able.channelDemonfire() and (debuff.immolate.remains() > cast.time.channelDemonfire()) then
        cast.channelDemonfire()
    end

    -- immolate, target_if=min:dot.immolate.remains + 99 * debuff.havoc.remains, if((debuff.immolate.refreshable() and (not talent.cataclysm or cd.cataclysm.remains() > dot.immolate.remains())) or activeEnemies() > activeDot.immolate()) and unit.ttd() > 10 and not havocActive()
    if cast.able.immolate() and (((debuff.immolate.refreshable and (not talent.cataclysm or cd.cataclysm.remains() > debuff.immolate.remains()))) and unit.ttd() > 10 and not debuff.havoc.exists()) then
        cast.immolate()
    end

    -- immolate, target_if=min:dot.immolate.remains + 99 * debuff.havoc.remains, if((debuff.immolate.refreshable() and variable.havocImmoTime() < 5.4) or (debuff.immolate.remains() < 2 and debuff.immolate.remains() < havocRemains) or not debuff.immolate.exists() or (variable.havocImmoTime() < 2 and havocActive()) and (not talent.cataclysm or cd.cataclysm.remains() > dot.immolate.remains()) and unit.ttd() > 11
    if cast.able.immolate() and ((debuff.immolate.refreshable and var.havocImmoTime < 5.4) or (debuff.immolate.remains() < 2 and debuff.immolate.remains() < debuff.havoc.remains()) or not debuff.immolate.exists() or (var.havocImmoTime < 2 and debuff.havoc.exists()) and (not talent.cataclysm or cd.cataclysm.remains() > debuff.immolate.remains()) and unit.ttd() > 11) then
        cast.immolate()
    end

    -- soul_fire,if=buff.backdraft.exists()
    if cast.able.soulFire() and buff.backdraft.exists() then
        cast.soulFire()
    end

    -- incinerate,if=talent.fireAndBrimstone and buff.backdraft.exists()
    if cast.able.incinerate() and talent.fireAndBrimstone and buff.backdraft.exists() then
        ui.debug("Hitting bottom incinerate 3")
        cast.incinerate()
    end

    -- conflagrate,if buff.backdraft.stack() < 2 or not talent.backdraft
    if cast.able.conflagrate() and (buff.backdraft.stack() < 2 or not talent.backdraft) then
        cast.conflagrate()
    end

    -- dimensional_rift
    if cast.able.dimensionalRift() then
        cast.dimensionalRift()
    end

    -- incinerate
    if cast.able.incinerate() then
        ui.debug("Hitting bottom incinerate 4")
        cast.incinerate()
    end

end

actionList.cleave = function()
    ui.debug("Action List Cleave")
    -- call_action_list,name=havoc,if=havoc_active and havoc_remains > gcd.max
    if debuff.havoc.exists() and debuff.havoc.remains() > unit.gcd(true) then
        actionList.havoc()
    end

    -- variable,name=pool_soul_shards,value=cd.havoc.remains() <= 10 or talent.mayhem
    var.poolSoulShards = cd.havoc.remains() <= 10 or talent.mayhem

    -- conflagrate,if=(talent.roaringBlaze and debuff.conflagrate.remains() < 1.5) or charges.conflagrate.count() == 2
    if cast.able.conflagrate() and (talent.roaringBlaze and debuff.conflagrate.remains() < 1.5 or charges.conflagrate.count() == 2) then
        cast.conflagrate()
    end

    -- dimensional_rift,if=soulShards.frac() < 4.7 and (charges.dimensionalRift > 2 or unit.ttd() < cd.dimensionalRift.duration())
    if cast.able.dimensionalRift() and soulShards.frac() < 4.7 and (charges.dimensionalRift > 2 or unit.ttd() < cd.dimensionalRift.duration()) then
        cast.dimensionalRift()
    end

    -- cataclysm,if=raid_event.adds.in>15
    if cast.able.cataclysm() then
        cast.cataclysm()
    end

    -- channel_demonfire,if=talent.ragingDemonfire and activeDot.immolate() == 2
    if cast.able.channelDemonfire() and talent.ragingDemonfire then
        cast.channelDemonfire()
    end

    -- soul_fire,if=soulShards.frac() <= 3.5 and (debuff.conflagrate.remains() > cast.time.soulFire() + cast.time.travelTime() or not talent.roaringBlaze and buff.backdraft.exists()) and not var.poolSoulShards
    if cast.able.soulFire() and soulShards.frac() <= 3.5 and (debuff.conflagrate.remains() > cast.time.soulFire() + cast.time.travelTime() or not talent.roaringBlaze and buff.backdraft.exists()) and not var.poolSoulShards then
        cast.soulFire()
    end

    -- immolate, target_if=min:dot.immolate.remains() + 99 * debuff.havoc.remains, if (debuff.immolate.refreshable() and (debuff.immolate.remains() < cd.havoc.remains() or not debuff.immolate.exists())) and (not talent.cataclysm or cd.cataclysm.remains() > immolate.remains()) and (not talent.soulFire or cd.soulFire.remains() + (not talent.mayhem * cast.time.soulFire()) > immolate.remains()) and unit.ttd() > 15
    if cast.able.immolate() and (debuff.immolate.refreshable and (debuff.immolate.remains() < cd.havoc.remains() or not debuff.immolate.exists()) and (not talent.cataclysm or cd.cataclysm.remains() > debuff.immolate.remains()) and (not talent.soulFire or cd.soulFire.remains() + (not talent.mayhem * cast.time.soulFire()) > debuff.immolate.remains()) and unit.ttd() > 15) then
        cast.immolate()
    end

    -- havoc, target_if=min:((-target.time_to_die)<?-15) + dot.immolate.remains() + 99 * (self.target=target), if (!cd.summonInfernal.ready() or !talent.summonInfernal) and unit.ttd() > 8
    if cast.able.havoc() and (not cd.summonInfernal.ready() or not talent.summonInfernal) and unit.ttd() > 8 then
        cast.havoc()
    end

    -- chaos_bolt,if=pet.infernal.active() or pet.blasphemy.active() or soulShards.amount() >= 4
    if cast.able.chaosBolt() and (pet.infernal.active() or pet.blasphemy.active() or soulShards.amount() >= 4) then
        cast.chaosBolt()
    end

    -- summon_infernal
    if cast.able.summonInfernal() then
        cast.summonInfernal()
    end

    -- channel_demonfire,if talent.rank.ruin > 1 and not (talent.diabolicEmbers and talent.avatarOfDestruction and (talent.burnToAshes or talent.chaosIncarnate))
    if cast.able.channelDemonfire() and talent.rank.ruin > 1 and not (talent.diabolicEmbers and talent.avatarOfDestruction and (talent.burnToAshes or talent.chaosIncarnate)) then
        cast.channelDemonfire()
    end

    -- conflagrate,if not buff.backdraft.exists() and soulShards.frac() >= 1.5 and not var.poolSoulShards
    if cast.able.conflagrate() and not buff.backdraft.exists() and soulShards.frac() >= 1.5 and not var.poolSoulShards then
        cast.conflagrate()
    end

    -- incinerate,if cast.time.incinerate() + cast.time.chaosBolt() < buff.madnessCB.remains()
    if cast.able.incinerate() and cast.time.incinerate() + cast.time.chaosBolt() < buff.madnessCB.remains() then
        ui.debug("Hitting bottom incinerate 5")
        cast.incinerate()
    end

    -- chaos_bolt,if buff.rainOfChaos.remains() > cast.time.chaosBolt()
    if cast.able.chaosBolt() and buff.rainOfChaos.remains() > cast.time.chaosBolt() then
        cast.chaosBolt()
    end

    -- chaos_bolt,if buff.backdraft.exists() and not var.poolSoulShards
    if cast.able.chaosBolt() and buff.backdraft.exists() and not var.poolSoulShards then
        cast.chaosBolt()
    end

    -- chaos_bolt,if talent.eradication and not var.poolSoulShards and debuff.eradication.remains() < cast.time and not cast.inFlight.chaosBolt()
    if cast.able.chaosBolt() and talent.eradication and not var.poolSoulShards and debuff.eradication.remains() < cast.time.chaosBolt() and not cast.inFlight.chaosBolt() then
        cast.chaosBolt()
    end

    -- chaos_bolt,if buff.madnessCB.exists() and (not var.poolSoulShards or (talent.burnToAshes and buff.burnToAshes.stack() == 0) or talent.soulFire)
    if cast.able.chaosBolt() and buff.madnessCB.exists() and (not var.poolSoulShards or (talent.burnToAshes and buff.burnToAshes.stack() == 0) or talent.soulFire) then
        cast.chaosBolt()
    end

    -- soul_fire,if soulShards.amount() <= 4 and talent.mayhem
    if cast.able.soulFire() and soulShards.amount() <= 4 and talent.mayhem then
        cast.soulFire()
    end

    -- channel_demonfire,if not (talent.diabolicEmbers and talent.avatarOfDestruction and (talent.burnToAshes or talent.chaosIncarnate))
    if cast.able.channelDemonfire() and not (talent.diabolicEmbers and talent.avatarOfDestruction and (talent.burnToAshes or talent.chaosIncarnate)) then
        cast.channelDemonfire()
    end

    -- dimensional_rift
    if cast.able.dimensionalRift() then
        cast.dimensionalRift()
    end

    -- chaos_bolt,if soulShards.amount() > 3.5 and not var.poolSoulShards
    if cast.able.chaosBolt() and soulShards.amount() > 3.5 and not var.poolSoulShards then
        cast.chaosBolt()
    end

    -- chaos_bolt,if not var.poolSoulShards and (talent.soulConduit and not talent.madnessOfTheAzjaqir or not talent.backdraft)
    if cast.able.chaosBolt() and not var.poolSoulShards and (talent.soulConduit and not talent.madnessOfTheAzjaqir or not talent.backdraft) then
        cast.chaosBolt()
    end

    -- chaos_bolt,if fightRemains() < 5 and fightRemains() > cast.time + cast.time.travelTime()
    if cast.able.chaosBolt() and unit.ttd() < 5 and unit.ttd() > cast.time.chaosBolt() then
        cast.chaosBolt()
    end

    -- summon_soulkeeper,if buff.tormentedSoul.stack() == 10 or buff.tormentedSoul.stack() > 3 and fightRemains() < 10
    if cast.able.summonSoulkeeper() and (buff.tormentedSoul.stack() == 10 or buff.tormentedSoul.stack() > 3 and unit.ttd() < 10) then
        cast.summonSoulkeeper()
    end

    -- conflagrate,if charges.conflagrate.count() > (charges.conflagrate.max() - 1) or fightRemains() < gcd.max * charges.conflagrate.count()
    if cast.able.conflagrate() and (charges.conflagrate.count() > (charges.conflagrate.max() - 1) or unit.ttd() < unit.gcd(true) * charges.conflagrate.count()) then
        cast.conflagrate()
    end

    -- incinerate
    if cast.able.incinerate() then
        ui.debug("Hitting bottom incinerate 6")
        cast.incinerate()
    end

end

actionList.havoc = function()
    ui.debug("Action List Havoc")
    -- conflagrate,if talent.backdraft and not buff.backdraft.exists() and soulShards.frac() >= 1 and soulShards.frac() <= 4
    if talent.backdraft and not buff.backdraft.exists() and soulShards.frac() >= 1 and soulShards.frac() <= 4 then
        cast.conflagrate()
    end

    -- soul_fire,if cast.time.soulFire() < havocRemains() and soulShards.frac() < 2.5
    if cast.able.soulFire() and cast.time.soulFire() < debuff.havoc.remains() and soulShards.frac() < 2.5 then
        cast.soulFire()
    end

    -- channel_demonfire,if soulShards.frac() < 4.5 and talent.ragingDemonfire.rank() == 2
    if cast.able.channelDemonfire() and soulShards.frac() < 4.5 and talent.rank.ragingDemonfire == 2 then
        cast.channelDemonfire()
    end

    -- immolate, target_if=min:debuff.immolate.remains() + 100 * debuff.havoc.remains(), if (((debuff.immolate.refreshable() and var.havocImmoTime() < 5.4) and unit.ttd() > 5) or ((debuff.immolate.remains() < 2 and debuff.immolate.remains() < havocRemains()) or not debuff.immolate.exists() or var.havocImmoTime() < 2) and unit.ttd() > 11) and soulShards.frac() < 4.5
    if cast.able.immolate() and ((debuff.immolate.refreshable and var.havocImmoTime < 5.4 and unit.ttd() > 5) or ((debuff.immolate.remains() < 2 and debuff.immolate.remains() < debuff.havoc.remains()) or not debuff.immolate.exists() or var.havocImmoTime < 2) and unit.ttd() > 11) and soulShards.frac() < 4.5 then
        cast.immolate()
    end

    -- chaos_bolt,if ((talent.cryHavoc and not talent.inferno) or not talent.rainOfFire) and cast.time.chaosBolt() < havocRemains()
    if ((talent.cryHavoc and not talent.inferno) or not talent.rainOfFire) and cast.time.chaosBolt() < debuff.havoc.remains() then
        cast.chaosBolt()
    end

    -- chaos_bolt,if cast.time.chaosBolt() < havocRemains() and (activeEnemies.yards40() <= 3 - talent.inferno + (talent.madnessOfTheAzjaqir and not talent.inferno))
    if cast.time.chaosBolt() < debuff.havoc.remains() and (#enemies.yards40 <= 3 - (talent.inferno and 1 or 0) + ((talent.madnessOfTheAzjaqir and not talent.inferno) and 1 or 0)) then
        cast.chaosBolt()
    end
    

    -- rain_of_fire,if activeEnemies.yards40() >= 3 and talent.inferno
    if #enemies.yards40 >= 3 and talent.inferno and cast.able.rainOfFire() then
        cast.rainOfFire("best",nil,3,8)
    end

    -- rain_of_fire,if activeEnemies.yards40() >= 4 - talent.inferno + talent.madnessOfTheAzjaqir
    if #enemies.yards40 >= 4 - (talent.inferno and 1 or 0) + (talent.madnessOfTheAzjaqir and 1 or 0) then
        cast.rainOfFire("best",nil,3,8)
    end

    -- rain_of_fire,if activeEnemies.yards40() > 2 and (talent.avatarOfDestruction or (talent.rainOfChaos and buff.rainOfChaos.exists())) and talent.inferno
    if #enemies.yards40 > 2 and (talent.avatarOfDestruction or (talent.rainOfChaos and buff.rainOfChaos.exists())) and talent.inferno then
        cast.rainOfFire("best",nil,3,8)
    end

    -- channel_demonfire,if soulShards.frac() < 4.5
    if cast.able.channelDemonfire() and soulShards.frac() < 4.5 then
        cast.channelDemonfire()
    end

    -- conflagrate,if not talent.backdraft
    if not talent.backdraft then
        cast.conflagrate()
    end

    -- incinerate,if cast.time.incinerate() < havocRemains()
    if cast.able.incinerate() and cast.time.incinerate() < debuff.havoc.remains() then
        ui.debug("Hitting bottom incinerate 7")
        cast.incinerate()
    end

end

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    debuff                                        = br.player.debuff
    has                                           = br.player.has
    mode                                          = br.player.ui.mode
    ui                                            = br.player.ui
    pet                                           = br.player.pet
    spell                                         = br.player.spell
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    enemies = br.player.enemies
    equiped = br.player.equiped
    charges = br.player.charges
    var = br.player.variables
    talent = br.player.talent
    soulShards = br.player.power.soulShards
    buff = br.player.buff
    gcd = br.player.gcd
    -- General Locals
    ui = br.player.ui
    profileStop                                   = profileStop or false
    haltProfile                                   = (unit.inCombat() and profileStop) or IsMounted() or br.pause() or mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40,true)

    enemies.get(40)

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = GetTime() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") then
        profileStop = false
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
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
        -- Check for combat
        if cd.global.remain() == 0 then
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                ------------------------------
                --- In Combat - Interrupts ---
                ------------------------------
                -- Start Attack
                -- actions=auto_attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    br._G.StartAttack(units.dyn5)
                end
                -- variable,name=havoc_immo_time,op=reset
                -- cycling_variable,name=havoc_immo_time,op=add,value=dot.immolate.remains*debuff.havoc.up
                if debuff.havoc.exists() then
                    var.havocImmoTime = debuff.immolate.remains()
                else
                    var.havocImmoTime = 0
                end
                -- variable,name=infernal_active,op=set,value=pet.infernal.active|cooldown.summon_infernal.remains>160
                var.infernalActive = pet.infernal.active() or cd.summonInfernal.remains() > 160
                -- call_action_list,name=aoe,if=(active_enemies>=3-(talent.inferno&!talent.madness_of_the_azjaqir))&!(!talent.inferno&talent.madness_of_the_azjaqir&talent.chaos_incarnate&active_enemies<4)&!variable.cleave_apl
                if #enemies.yards40 >= 3 - (talent.inferno and not talent.madnessOfTheAzjaqir and 1) and not (not talent.inferno and talent.madnessOfTheAzjaqir and talent.chaosIncarnate and #enemies.yards40 < 4) and not var.cleaveApl then
                    actionList.aoe()
                end
                
                -- call_action_list,name=cleave,if=active_enemies!=1|variable.cleave_apl
                if #enemies.yards40 ~= 1 or var.cleaveApl then
                    actionList.cleave()
                end
                -- conflagrate,if=(talent.roaring_blaze&debuff.conflagrate.remains<1.5)|charges=max_charges
                if cast.able.conflagrate and (talent.roaringBlaze and debuff.conflagrate.remains() < 1.5 or charges.conflagrate.count() == 2) then
                    cast.conflagrate()
                end
                -- dimensional_rift,if=soul_shard<4.7&(charges>2|fight_remains<cooldown.dimensional_rift.duration)
                if cast.able.dimensionalRift() and soulShards.frac() < 4.7 and (charges.dimensionalRift.count() > 2 or unit.ttd() < cd.dimensionalRift.remains()) then
                    cast.dimensionalRift()
                end
                -- cataclysm,if=raid_event.adds.in>15
                if cast.able.cataclysm() then
                    cast.cataclysm()
                end
                -- channel_demonfire,if=talent.raging_demonfire&(dot.immolate.remains-5*(action.chaos_bolt.in_flight&talent.internal_combustion))>cast_time&(debuff.conflagrate.remains>execute_time|!talent.roaring_blaze)
                if cast.able.channelDemonfire() and talent.ragingDemonfire and (debuff.immolate.remains()-5*((cast.inFlight.chaosBolt() and 1 or 0) and (talent.internalCombustion and 1 or 0))) > cast.time.channelDemonfire() and (debuff.conflagrate.remains() > cast.time.channelDemonfire() or not talent.roaringBlaze) then
                    cast.channelDemonfire()
                end
                -- 	soul_fire,if=soul_shard<=3.5&(debuff.conflagrate.remains>cast_time+travel_time|!talent.roaring_blaze&buff.backdraft.up)
                if cast.able.soulFire() and soulShards.frac() <= 3.5 and (debuff.conflagrate.remains() > cast.time.soulFire() or not talent.roaringBlaze and buff.backdraft.exists()) then
                    cast.soulFire()
                end
                -- immolate,if=(((dot.immolate.remains-5*(action.chaos_bolt.in_flight&talent.internal_combustion))<dot.immolate.duration*0.3)|dot.immolate.remains<3|(dot.immolate.remains-action.chaos_bolt.execute_time)<5&talent.infernal_combustion&action.chaos_bolt.usable)&(!talent.cataclysm|cooldown.cataclysm.remains>dot.immolate.remains)&(!talent.soul_fire|cooldown.soul_fire.remains+action.soul_fire.cast_time>(dot.immolate.remains-5*talent.internal_combustion))&target.time_to_die>8
                if cast.able.immolate() and (((debuff.immolate.remains() - 5 * (cast.inFlight.chaosBolt() and talent.internalCombustion or 1)) < (cd.immolate.duration() * 0.3)) or debuff.immolate.remains() < 3 or ((debuff.immolate.remains() - cast.time.chaosBolt()) < 5 and talent.infernalCombustion and (cast.able.chaosBolt() or 0))) and (not talent.cataclysm or cd.catalysm.remains() > debuff.immolate.remains()) and (not talent.soulFire or (cd.soulFire.remains() + cast.time.soulFire()) > (debuff.immolate.remains() - 5 * (talent.internalCombustion and 1))) and unit.ttd() > 8 then
                    cast.immolate()
                end
                
                
                -- 	channel_demonfire,if=dot.immolate.remains>cast_time&set_bonus.tier30_4pc
                if cast.able.channelDemonfire() and debuff.immolate.remains()>cast.time.channelDemonfire() and equiped.tier(30) >= 4 then
                    cast.channelDemonfire()
                end
                -- chaos_bolt,if=cooldown.summon_infernal.remains=0&soul_shard>4&(trinket.spoils_of_neltharus.ready_cooldown|!equipped.spoils_of_neltharus)&buff.domineering_arrogance.stack<3&talent.crashing_chaos
                if cast.able.chaosBolt() and cd.summonInfernal.ready() and soulShards.amount() > 4 and (((equiped.spoilsOfNeltharus(13) and use.able.slot(13)) or (equiped.spoilsOfNeltharus(13) and use.able.slot(14))) or (not equiped.spoilsOfNeltharus(13) and not equiped.spoilsOfNeltharus(14))) and buff.domineeringArrogance.stack() < 3 and talent.crashingChaos then
                    cast.chaosBolt()
                end
                -- summon_infernal,if=variable.opti_cc&((soul_shard>4&buff.domineering_arrogance.stack>=3|buff.domineering_arrogance.stack<3&buff.madness_cb.remains>2*gcd.max)&(trinket.spoils_of_neltharus.cooldown.remains<2|!equipped.spoils_of_neltharus))|!variable.opti_cc|fight_remains<30
                if br.isBoss() and unit.ttd() > 30 and cast.able.summonInfernal() and var.optiCC and ((soulShards.amount() > 4 and buff.domineeringArrogance.stack() >= 3 or buff.domineeringArrogance.stack() < 3 and buff.madnessCB.remains() > 2*unit.gcd(true)) and ((equiped.spoilsOfNeltharus(13) and use.able.slot(13)) or (equiped.spoilsOfNeltharus(13) and use.able.slot(14)))) or not var.optiCC or unit.ttd() < 30 then
                    cast.summonInfernal()
                end
                -- chaos_bolt,if=pet.infernal.active|pet.blasphemy.active|soul_shard>=4&(variable.opti_cc&(cooldown.summon_infernal.remains<?trinket.spoils_of_neltharus.cooldown.remains)>2|!variable.opti_cc)
                if cast.able.chaosBolt() and pet.infernal.active() or pet.blasphemy.active() or soulShards.amount() >= 4 then
                    cast.chaosBolt()
                end
                -- channel_demonfire,if=talent.ruin.rank>1&!(talent.diabolic_embers&talent.avatar_of_destruction&(talent.burn_to_ashes|talent.chaos_incarnate))&dot.immolate.remains>cast_time
                if cast.able.channelDemonfire() and talent.rank.ruin > 1 and not (talent.diabolicEmbers and talent.avatarOfDestruction and (talent.burnToAshes or talent.chaosIncarnate)) and debuff.immolate.remains() > cast.time.channelDemonfire() then
                    cast.channelDemonfire()
                end
                -- 	conflagrate,if=buff.backdraft.down&soul_shard>=1.5&!talent.roaring_blaze
                if cast.able.conflagrate and not buff.backdraft.exists() and soulShards.frac() >= 1.5 and not talent.roaringBlaze then
                    cast.conflagrate()
                end
                -- 	incinerate,if=cast_time+action.chaos_bolt.cast_time<buff.madness_cb.remains&(buff.call_to_dominance.down|!variable.opti_cc)
                if cast.able.incinerate() and cast.time.incinerate()+cast.time.chaosBolt() < buff.madnessCB.remains() and (not buff.callToDominance.exists() or not var.optiCC) then
                    ui.debug("Hitting bottom incinerate 8")
                    cast.incinerate()
                end
                -- 	chaos_bolt,if=buff.rain_of_chaos.remains>cast_time
                if cast.able.chaosBolt() and buff.rainOfChaos.remains() > cast.time.chaosBolt() then
                    cast.chaosBolt()
                end
                -- chaos_bolt,if=buff.backdraft.up&!talent.eradication&!talent.madness_of_the_azjaqir
                if cast.able.chaosBolt() and buff.backdraft.exists() and not talent.eradication and not talent.madnessOfTheAzjaqir then
                    cast.chaosBolt()
                end
                -- chaos_bolt,if=buff.madness_cb.up&((cooldown.summon_infernal.remains<?trinket.spoils_of_neltharus.cooldown.remains)>10|!variable.opti_cc)
                if cast.able.chaosBolt() and buff.madnessCB.exists() then
                    cast.chaosBolt()
                end
                -- 	channel_demonfire,if=!(talent.diabolic_embers&talent.avatar_of_destruction&(talent.burn_to_ashes|talent.chaos_incarnate))&dot.immolate.remains>cast_time
                if not (talent.diabolicEmbers and talent.avatarOfDestruction and (talent.burnToAshes or talent.chaosIncarnate)) and debuff.immolate.remains() > cast.time.channelDemonfire() then
                    cast.channelDemonfire()
                end
                -- dimensional_rift
                if cast.able.dimensionalRift() then
                    cast.dimensionalRift()
                end

                -- chaos_bolt,if=soul_shard>3.5&(cooldown.summon_infernal.remains_expected>5|!variable.opti_cc)
                if cast.able.chaosBolt() and soulShards.frac() > 3.5 and (cd.summonInfernal.remains() > 5 or not var.optiCC) then
                    cast.chaosBolt()
                end

                -- chaos_bolt,if=talent.soul_conduit&!talent.madness_of_the_azjaqir|!talent.backdraft
                if cast.able.chaosBolt() and (talent.soulConduit and not talent.madnessOfTheAzjaqir or not talent.backdraft) then
                    cast.chaosBolt()
                end

                -- chaos_bolt,if=fight_remains<5&fight_remains>cast_time+travel_time
                if cast.able.chaosBolt() and unit.ttd() < 5 and unit.ttd() > cast.time.chaosBolt() then
                    cast.chaosBolt()
                end

                -- conflagrate,if=charges>(max_charges-1)|fight_remains<gcd.max*charges
                if cast.able.conflagrate() and (charges.conflagrate.count() > (charges.conflagrate.max() - 1) or unit.ttd() < cast.time.conflagrate() * charges.conflagrate.count()) then
                    cast.conflagrate()
                end

                -- incinerate
                if cast.able.incinerate() then
                    ui.debug("Hitting bottom incinerate")
                    cast.incinerate()
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 267 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})