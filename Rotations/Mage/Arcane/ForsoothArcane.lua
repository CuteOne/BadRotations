local rotationName = "ForsoothArcane"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.frostBolt },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.frostBolt }
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.frostNova},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.frostNova}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
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

        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")

        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")

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
local arcaneCharges
local arcaneChargesMax
local buff
local cast
local cd
local mode
local ui
local spell
local unit
local has
local enemies
local units
-- General Locals
local haltProfile
local profileStop
-- Profile Specific Locals
local actionList = {}
local debuff
local talent
local var
local equiped
local mana
local charges
local use

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive
actionList.Defensive = function()
    --Frost Nova
    if unit.hp() < 95 then
        if cast.able.frostNova and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            if cast.frostNova() then ui.debug("Casting Frost Nova") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()
    -- variable,name=aoe_target_count,op=reset,default=3
    var.aoe_target_count = 3
    -- 	variable,name=conserve_mana,op=set,value=0
    var.conserve_mana = 0
    -- variable,name=opener,op=set,value=1
    var.opener = 1
    -- variable,name=opener_min_mana,default=-1,op=set,if=variable.opener_min_mana=-1,value=225000-(25000*!talent.arcane_harmony)
    var.opener_min_mana = -1
    if var.opener_min_mana == -1 then
        var.opener_min_mana = 225000-(2500*(not talent.arcaneHarmony and 1 or 0))
    end
    -- 	variable,name=totm_on_last_spark_stack,default=-1,op=set,if=variable.totm_on_last_spark_stack=-1,value=!set_bonus.tier30_4pc
    var.totm_on_last_spark_stack = -1
    if var.totm_on_last_spark_stack == -1 then
        var.totm_on_last_spark_stack = equiped.tier(30) < 4
    end
    -- mirror_image
    if br.isBoss() and unit.ttd() > 40 and cast.able.mirrorImage() then
        cast.mirrorImage()
    end
    -- arcane_blast,if=!talent.siphon_storm
    if cast.able.arcaneBlast() and not talent.siphonStorm then
        cast.arcaneBlast()
    end
    -- evocation,if=talent.siphon_storm
    if br.isBoss() and unit.ttd() > 10 and talent.siphonStorm then
        cast.evocation()
    end
end -- End Action List - PreCombat

actionList.cooldown_phase = function()
    -- 
end

actionList.aoe_spark_phase = function()
    -- cancel_buff,name=presence_of_mind,if=prev_gcd.1.arcane_blast&cooldown.arcane_surge.remains>75
    if buff.presenceOfMind.exists() and cast.last.arcaneBlast(1) and cd.arcaneSurge.remains() > 75 then
        buff.presenceOfMind.cancel()
    end
    -- touch_of_the_magi,use_off_gcd=1,if=prev_gcd.1.arcane_barrage
    if cast.last.arcaneBarrage(1) and cast.able.touchOfTheMagi() then
        cast.touchOfTheMagi()
    end
    -- radiant_spark
    if cast.able.radiantSpark() then
        cast.radiantSpark()
    end
    -- 	arcane_orb,if=buff.arcane_charge.stack<3,line_cd=1
    if cast.able.arcaneOrb() and arcaneCharges < 3 then
        cast.arcaneOrb(1,true,4)
    end
    -- nether_tempest,if=talent.arcane_echo,line_cd=15
    if cast.able.netherTempest() and not debuff.netherTempest.exists() and talent.arcaneEcho then
        cast.netherTempest()
    end
    -- arcane_surge
    if cast.able.arcaneSurge() then
        cast.arcaneSurge()
    end
    -- arcane_barrage,if=cooldown.arcane_surge.remains<75&debuff.radiant_spark_vulnerability.stack=4&!talent.orb_barrage
    if cast.able.arcaneBarrage() and cd.arcaneSurge.remains() < 75 and debuff.radiantSparkVulnerability.stack() == 4 and not talent.orbBarrage then
        cast.arcaneBarrage()
    end
    -- 	arcane_barrage,if=(debuff.radiant_spark_vulnerability.stack=2&cooldown.arcane_surge.remains>75)|(debuff.radiant_spark_vulnerability.stack=1&cooldown.arcane_surge.remains<75)&!talent.orb_barrage
    if cast.able.arcaneBarrage() and (debuff.radiantSparkVulnerability.stack() == 2 and cd.arcaneSurge.remains() > 75) or (debuff.radiantSparkVulnerability.stack() == 1 and cd.arcaneSurge.remains() < 75) and not talent.orbBarrage then
        cast.arcaneBarrage()
    end
    -- 	arcane_barrage,if=(debuff.radiant_spark_vulnerability.stack=1|debuff.radiant_spark_vulnerability.stack=2|(debuff.radiant_spark_vulnerability.stack=3&active_enemies>5)|debuff.radiant_spark_vulnerability.stack=4)&buff.arcane_charge.stack=buff.arcane_charge.max_stack&talent.orb_barrage
    if cast.able.arcaneBarrage() and (debuff.radiantSparkVulnerability.stack() == 1 or debuff.radiantSparkVulnerability.stack() == 2 or (debuff.radiantSparkVulnerability.stack() == 3 and #enemies.yards40 > 5) or debuff.radiantSparkVulnerability.stack() == 4) and arcaneCharges == arcaneChargesMax and talent.orbBarrage then
        cast.arcaneBarrage()
    end
    -- 	presence_of_mind
    if unit.ttd() > 45 and cast.able.presenceOfMind() then
        cast.presenceOfMind()
    end
    -- arcane_blast,if=((debuff.radiant_spark_vulnerability.stack=2|debuff.radiant_spark_vulnerability.stack=3)&!talent.orb_barrage)|(debuff.radiant_spark_vulnerability.remains&talent.orb_barrage)
    if cast.able.arcaneBlast() and ((debuff.radiantSparkVulnerability.stack() == 2 or debuff.radiantSparkVulnerability.stack() == 3) and not talent.orbBarrage) or (debuff.radiantSparkVulnerability.remains() and talent.orbBarrage) then
        cast.arcaneBlast()
    end
    -- 	arcane_barrage,if=(debuff.radiant_spark_vulnerability.stack=4&buff.arcane_surge.up)|(debuff.radiant_spark_vulnerability.stack=3&buff.arcane_surge.down)&!talent.orb_barrage
    if cast.able.arcaneBarrage and (debuff.radiantSparkVulnerability.stack() == 4 and buff.arcaneSurge.exists()) or (debuff.radiantSparkVulnerability.stack() == 3 and not buff.arcaneSurge.exists()) and not talent.orbBarrage then
        cast.arcaneBarrage()
    end
end

actionList.spark_phase = function()
    -- nether_tempest,if=!ticking&variable.opener&buff.bloodlust.up,line_cd=45
    if cast.able.netherTempest() and not debuff.netherTempest.exists() and var.opener and buff.bloodLust.exists() then
        cast.able.netherTempest()
    end
    -- arcane_missiles,if=variable.opener&buff.bloodlust.up&buff.clearcasting.react&buff.clearcasting.stack>0&cooldown.radiant_spark.remains<5&buff.nether_precision.down&(!buff.arcane_artillery.up|buff.arcane_artillery.remains<=(gcd.max*6))&set_bonus.tier31_4pc,chain=1
    if cast.able.arcaneMissiles() and var.opener and buff.bloodLust.exists() and buff.clearcasting.exists() and buff.clearcasting.stack() > 0 and cd.radiantSpark.remains() < 5 and not buff.nether_precision.exists() and (not buff.arcaneArtillery.exists() or buff.arcaneArtillery.remains() <= (unit.gcd()*6)) and equiped.tier(31) >= 4 then
        cast.arcaneMissiles()
    end
    -- arcane_blast,if=variable.opener&cooldown.arcane_surge.ready&buff.bloodlust.up&mana>=variable.opener_min_mana&buff.siphon_storm.remains>15
    if cast.able.arcaneBlast() and var.opener and cd.arcaneSurge.ready() and buff.bloodLust.exists() and mana.amount() >= var.opener_min_mana and buff.siphonStorm.remains() > 15 then
        cast.arcaneBlast()
    end
    -- 	arcane_missiles,if=variable.opener&buff.bloodlust.up&buff.clearcasting.react&buff.clearcasting.stack>=2&cooldown.radiant_spark.remains<5&buff.nether_precision.down&(!buff.arcane_artillery.up|buff.arcane_artillery.remains<=(gcd.max*6)),chain=1
    if cast.able.arcaneMissiles() and var.opener and buff.bloodLust.exists() and buff.clearcasting.exists() and buff.clearcasting.stack() >=2 and cd.radiantSpark.remains() < 5 and not buff.netherPrecision.exists() and (not buff.arcaneArtillery.exists() or buff.arcaneArtillery.remains() <= (unit.gcd()*6)) then
        cast.arcaneMissiles()
    end
    -- arcane_missiles,if=talent.arcane_harmony&buff.arcane_harmony.stack<15&((variable.opener&buff.bloodlust.up)|buff.clearcasting.react&cooldown.radiant_spark.remains<5)&cooldown.arcane_surge.remains<30,chain=1
    if cast.able.arcaneMissiles() and talent.arcaneHarmony and buff.arcaneHarmony.stack() < 15 and (( var.opener and buff.bloodLust.exists()) or buff.clearcasting.exists() and cd.radiantSpark.remains() < 5) and cd.arcaneSurge.remains() < 30 then
        cast.arcaneMissiles()
    end
    -- radiant_spark
    if cast.able.radiantSpark() then
        cast.radiantSpark()
    end
    -- 	nether_tempest,if=(!variable.surge_last_spark_stack&prev_gcd.4.radiant_spark&cooldown.arcane_surge.remains<=execute_time)|prev_gcd.5.radiant_spark,line_cd=15
    if cast.able.netherTempest and not debuff.netherTempest.exists() and (not var.surge_last_spark_stack and cast.last.radiantSpark(4) and cd.arcaneSurge.remains() <= cast.time.netherTempest()) or cast.last.radiantSpark(5) then
        cast.netherTempest()
    end
    -- arcane_surge,if=(!talent.nether_tempest&((prev_gcd.4.radiant_spark&!variable.surge_last_spark_stack)|prev_gcd.5.radiant_spark))|prev_gcd.1.nether_tempest
    if cast.able.arcaneSurge() and (not talent.netherTempest and ((cast.last.radiantSpark(4) and not var.surge_last_spark_stack) or cast.last.radiantSpark(5))) or cast.last.netherTempest(1) then
        cast.arcaneSurge()
    end
    -- arcane_blast,if=cast_time>=gcd&execute_time<debuff.radiant_spark_vulnerability.remains&(!talent.arcane_bombardment|target.health.pct>=35)&(talent.nether_tempest&prev_gcd.6.radiant_spark|!talent.nether_tempest&prev_gcd.5.radiant_spark)&!(action.arcane_surge.executing&action.arcane_surge.execute_remains<0.5&!variable.surge_last_spark_stack)
    if cast.able.arcaneBlast() and cast.time.arcaneBlast() >= unit.gcd() and cast.time.arcaneBlast() < debuff.radiantSparkVulnerability.remains() and (not talent.arcaneBombardment or unit.hp("target") >= 35) and (talent.netherTempest and cast.last.radiantSpark(6) or not talent.netherTempest and cast.last.radiantSpark(5)) and not (cast.current.arcaneSurge() and cast.timeremain()<0.5 and not var.surge_last_spark_stack) then
        cast.radiantSpark()
    end
    -- arcane_barrage,if=debuff.radiant_spark_vulnerability.stack=4
    if cast.able.arcaneBarrage() and debuff.radiantSparkVulnerability.stack() == 4 then
        cast.arcaneBarrage()
    end
    -- touch_of_the_magi,use_off_gcd=1,if=prev_gcd.1.arcane_barrage&(action.arcane_barrage.in_flight_remains<=0.2|gcd.remains<=0.2)
    if cast.able.touchOfTheMagi() and cast.last.arcaneBarrage(1) and (cast.inFlight.arcaneBarrage() or unit.gcd() <= 0.2) then
        cast.touchOfTheMagi()
    end
    -- arcane_blast
    if cast.able.arcaneBlast() then
        cast.arcaneBlast()
    end
    -- arcane_barrage
    if cast.able.arcaneBarrage() then
        cast.arcaneBarrage()
    end
end

actionList.aoe_touch_phase = function()
    -- variable,name=conserve_mana,op=set,if=debuff.touch_of_the_magi.remains>9,value=1-variable.conserve_mana
    if debuff.touchOfTheMagi.remains() > 9 then
        var.conserve_mana = 1-var.conserve_mana
    end
    -- arcane_missiles,if=buff.arcane_artillery.up&buff.clearcasting.up
    if cast.able.arcaneMissiles() and buff.arcaneArtillery.exists() and buff.clearcasting.exists() then
        cast.arcaneMissiles()
    end
    -- arcane_barrage,if=(active_enemies<=4&buff.arcane_charge.stack=3)|buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneBarrage() and (#enemies.yards40 <= 4 and arcaneCharges == 3) or arcaneCharges == arcaneChargesMax then
        cast.arcaneBarrage()
    end
    -- 	arcane_orb,if=buff.arcane_charge.stack<2
    if cast.able.arcaneOrb() and arcaneCharges < 2 then
        cast.arcaneOrb(1,true,4)
    end
    -- 	arcane_explosion
    if cast.able.arcaneExplosion() and #enemies.yards10 > 0 then
        cast.arcaneExplosion()
    end
end

actionList.touch_phase = function()
    -- variable,name=conserve_mana,op=set,if=debuff.touch_of_the_magi.remains>9,value=1-variable.conserve_mana
    if(debuff.touchOfTheMagi.remains() > 9) then
        var.conserve_mana = 1 - var.conserve_mana
    end
    -- presence_of_mind,if=debuff.touch_of_the_magi.remains<=gcd.max
    if cast.able.presenceOfMind() and debuff.touchOfTheMagi.remains() <= unit.gcd() then
        cast.presenceOfMind()
    end
    -- arcane_blast,if=buff.presence_of_mind.up&buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneBlast() and buff.presenceOfMind.exists() and arcaneCharges == arcaneChargesMax then
        cast.arcaneBlast()
    end
    -- arcane_barrage,if=(buff.arcane_harmony.up|(talent.arcane_bombardment&target.health.pct<35))&debuff.touch_of_the_magi.remains<=gcd.max
    if cast.able.arcaneBarrage() and (buff.arcaneHarmony.exists() or (talent.arcaneBombardment and unit.hp("target") < 35)) and debuff.touchOfTheMagi.remains() <= unit.gcd() then
        cast.arcaneBarrage()
    end
    -- arcane_missiles,if=buff.clearcasting.stack>1&talent.conjure_mana_gem&cooldown.use_mana_gem.ready,chain=1
    if cast.able.arcaneMissiles() and buff.clearcasting.stack() > 1 and talent.conjuremanaGem and u.able.manaGem() then
        cast.arcaneMissiles()
    end
    -- arcane_blast,if=buff.nether_precision.up
    if cast.able.arcaneBlast() and buff.netherPrecision.exists() then
        cast.arcaneBlast()
    end
    -- arcane_missiles,if=buff.clearcasting.react&(debuff.touch_of_the_magi.remains>execute_time|!talent.presence_of_mind),chain=1
    if cast.able.arcaneMissiles() and buff.clearcasting.exists() and (debuff.touchOfTheMagi.remains() > cast.time.arcaneMissiles() or not talent.presenceofMind) then
        cast.arcaneMissiles()
    end
    -- arcane_blast
    if cast.able.arcaneBlast() then
        cast.arcaneBlast()
    end
    -- arcane_barrage
    if cast.able.arcaneBarrage() then
        cast.arcaneBarrage()
    end
end

actionList.aoe_rotation = function()
    -- shifting_power,if=(!talent.evocation|cooldown.evocation.remains>12)&(!talent.arcane_surge|cooldown.arcane_surge.remains>12)&(!talent.touch_of_the_magi|cooldown.touch_of_the_magi.remains>12)&buff.arcane_surge.down&((!talent.charged_orb&cooldown.arcane_orb.remains>12)|(action.arcane_orb.charges=0|cooldown.arcane_orb.remains>12))
    if cast.able.shiftingPower and (not talent.evocation or cd.evocation.remains() > 12) and (not talent.arcaneSurge or cd.arcaneSurge.remains() > 12) and (not talent.touchOfTheMagi or cd.touchOfTheMagi.remains() > 12) and not buff.arcaneSurge.exists() and ((not talent.chargedOrb and cd.arcaneOrb.remains() > 12) or (charges.arcaneOrb.count() == 0 or cd.arcaneOrb.remains() > 12)) then
        cast.shiftingPower()
    end
    -- nether_tempest,if=(refreshable|!ticking)&buff.arcane_charge.stack=buff.arcane_charge.max_stack&buff.arcane_surge.down&(active_enemies>6|!talent.orb_barrage)
    if cast.able.netherTempest and (debuff.netherTempest.exists() and debuff.netherTempest.refreshable) and arcaneCharges == arcaneChargesMax and not buff.arcaneSurge.exists() and (#enemies.yards40 > 6 or not talent.orbBarrage) then
        cast.netherTempest()
    end
    -- 	arcane_missiles,if=buff.arcane_artillery.up&buff.clearcasting.up&cooldown.touch_of_the_magi.remains>(buff.arcane_artillery.remains+5)
    if cast.able.arcaneMissiles and buff.arcaneArtillery.exists() and buff.clearcasting.exists() and cd.touchOfTheMagi.remains() > (buff.arcaneArtillery.remains()+5) then
        cast.arcaneMissiles()
    end
    -- arcane_barrage,if=(active_enemies<=4|buff.clearcasting.up)&buff.arcane_charge.stack=3
    if cast.able.arcaneBarrage() and (#enemies.yards40 <= 4 or buff.clearcasting.exists()) and arcaneCharges == 3 then
        cast.arcaneBarrage()
    end
    -- arcane_orb,if=buff.arcane_charge.stack=0&cooldown.touch_of_the_magi.remains>18
    if cast.able.arcaneOrb() and arcaneCharges == 0 and cd.touchOfTheMagi.remains() > 18 then
        cast.arcaneOrb(1,true,4)
    end
    -- arcane_barrage,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack|mana.pct<10
    if cast.able.arcaneBarrage() and arcaneCharges == arcaneChargesMax or mana.percent() < 10 then
        cast.arcaneBarrage()
    end
    -- 	arcane_explosion
    if cast.able.arcaneExplosion() and #enemies.yards10 > 0 then
        cast.arcaneExplosion()
    end
end

actionList.rotation = function()
    -- arcane_orb,if=buff.arcane_charge.stack<3&(buff.bloodlust.down|mana.pct>70|(variable.totm_on_last_spark_stack&cooldown.touch_of_the_magi.remains>30))
    if cast.able.arcaneOrb() and arcaneCharges < 3 and (not buff.bloodLust.exists() or mana.percent() > 70 or (var.totm_on_last_spark_stack and cd.touchOfTheMagi.remains() > 30)) then
        cast.arcaneOrb(1,true,4)
    end
    -- variable,name=conserve_mana,op=set,if=cooldown.arcane_surge.remains>30,value=0+(cooldown.touch_of_the_magi.remains>10)
    if cd.arcaneSurge.remains() > 30 then
        var.conserve_mana = 0 + (cd.touchOfTheMagi.remains() > 10 and 1 or 0)
    end
    -- variable,name=conserve_mana,op=set,if=cooldown.arcane_surge.remains<30,value=0
    if cd.arcaneSurge.remains() < 30 then
        var.conserve_mana = 0
    end
    -- shifting_power,if=variable.totm_on_last_spark_stack&(!talent.evocation|cooldown.evocation.remains>12)&(!talent.arcane_surge|cooldown.arcane_surge.remains>12)&(!talent.touch_of_the_magi|cooldown.touch_of_the_magi.remains>12)&buff.arcane_surge.down&fight_remains>15
    if cast.able.shiftingPower() and var.totm_on_last_spark_stack and (not talent.evocation or cd.evocation.remains() > 12) and (not talent.arcaneSurge or cd.arcaneSurge.remains() > 12) and not buff.arcaneSurge.exists() and unit.ttd() > 15 then
        cast.shiftingPower()
    end
    -- shifting_power,if=!variable.totm_on_last_spark_stack&buff.arcane_surge.down&cooldown.arcane_surge.remains>45&fight_remains>15
    if cast.able.shiftingPower and not var.totm_on_last_spark_stack and not buff.arcaneSurge.exists() and cd.arcaneSurge.remains() > 45 and unit.ttd() > 15 then
        cast.shiftingPower()
    end
    -- 	nether_tempest,if=(refreshable|!ticking)&equipped.neltharions_call_to_chaos&fight_remains>=12
    -- presence_of_mind,if=buff.arcane_charge.stack<3&target.health.pct<35&talent.arcane_bombardment
    if cast.able.presenceOfMind() and arcaneCharges < 3 and unit.hp("target") < 35 and talent.arcaneBombardment then
        cast.presenceOfMind()
    end
    -- 	arcane_blast,if=talent.time_anomaly&buff.arcane_surge.up&buff.arcane_surge.remains<=6
    if cast.able.arcaneBlast() and talent.timeAnomaly and buff.arcaneSurge.exists() and buff.arcaneSurge.remains() <= 6 then
        cast.arcaneBlast()
    end
    -- arcane_blast,if=buff.presence_of_mind.up&target.health.pct<35&talent.arcane_bombardment&buff.arcane_charge.stack<3
    if cast.able.arcaneBlast() and buff.presenceOfMind.exists() and unit.hp("target") < 35 and talent.arcaneBombardment and arcaneCharges < 3 then
        cast.arcaneBlast()
    end
    -- arcane_missiles,if=buff.clearcasting.react&buff.clearcasting.stack=buff.clearcasting.max_stack
    if cast.able.arcaneMissiles() and buff.clearcasting.exists() and buff.clearcasting.stack() == arcaneChargesMax then
        cast.arcaneMissiles()
    end
    -- nether_tempest,if=(refreshable|!ticking)&buff.arcane_charge.stack=buff.arcane_charge.max_stack&(buff.temporal_warp.up|mana.pct<10|!talent.shifting_power)&buff.arcane_surge.down&fight_remains>=12
    if cast.able.netherTempest() and (debuff.netherTempest.refreshable or not debuff.netherTempest.exists()) and arcaneCharges == arcaneChargesMax and (buff.temporalWarp.exists() or mana.percent() < 10 or not talent.shiftingPower) and not buff.arcaneSurge.exists() and unit.ttd() >= 12 then
        cast.netherTempest()
    end
    -- arcane_barrage,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&mana.pct<50&!talent.evocation&fight_remains>20
    if cast.able.arcaneBarrage() and arcaneCharges == arcaneChargesMax and mana.percent() < 50 and not talent.evocation and unit.ttd() > 20 then
        cast.arcaneBarrage()
    end
    -- 	arcane_barrage,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&mana.pct<70&variable.conserve_mana&buff.bloodlust.up&cooldown.touch_of_the_magi.remains>5&fight_remains>20
    if cast.able.arcaneBarrage() and arcaneCharges == arcaneChargesMax and mana.percent() < 70 and var.conserve_mana and buff.bloodLust.exists() and cd.touchOfTheMagi.remains() > 5 and unit.ttd() > 20 then
        cast.arcaneBarrage()
    end
    -- 	arcane_missiles,if=buff.clearcasting.react&buff.concentration.up&buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneMissiles() and buff.clearcasting.exists() and buff.concentration.exists() and arcaneCharges == arcaneChargesMax then
        cast.arcaneMissiles()
    end
    -- 	arcane_blast,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&buff.nether_precision.up
    if cast.able.arcaneBlast() and arcaneCharges == arcaneChargesMax and buff.netherPrecision.exists() then
        cast.arcaneBlast()
    end
    -- 	arcane_barrage,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&mana.pct<60&variable.conserve_mana&cooldown.touch_of_the_magi.remains>10&cooldown.evocation.remains>40&fight_remains>20
    if cast.able.arcaneBarrage() and arcaneCharges == arcaneChargesMax and mana.percent() < 60 and var.conserve_mana and cd.touchOfTheMagi.remains() > 10 and cd.evocation.remains() > 40 and unit.ttd() > 20 then
        cast.arcaneBarrage()
    end
    -- cancel_action,if=action.arcane_missiles.channeling&gcd.remains=0&&buff.nether_precision.up&(mana.pct>30&cooldown.touch_of_the_magi.remains>30|mana.pct>70)&!buff.arcane_artillery.up
    if cast.current.arcaneMissiles() and cd.global.remain() and buff.netherPrecision.exists() and (mana.percent() > 30 and cd.touchOfTheMagi.remains() > 30 or mana.percent() > 70) and not buff.arcaneArtillery.exists() then
        cast.cancel.arcaneMissiles()
    end
    -- arcane_missiles,if=buff.clearcasting.react&buff.nether_precision.down&(!variable.totm_on_last_spark_stack|!variable.opener)
    if cast.able.arcaneMissiles() and buff.clearcasting.exists() and not buff.netherPrecision.exists() and (not var.totm_on_last_spark_stack or not var.opener) then
        cast.arcaneMissiles()
    end
    -- arcane_blast
    if cast.able.arcaneBlast() then
        cast.arcaneBlast()
    end
    -- arcane_barrage
    if cast.able.arcaneBarrage() then
        cast.arcaneBarrage()
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
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    mode                                          = br.player.ui.mode
    has = br.player.has
    ui                                            = br.player.ui
    spell                                         = br.player.spell
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    enemies = br.player.enemies
    debuff = br.player.debuff
    talent = br.player.talent
    var = br.player.variables
    equiped = br.player.equiped
    mana = br.player.power.mana
    charges = br.player.charges
    use = br.player.use
    -- General Locals
    profileStop                                   = profileStop or false
    haltProfile                                   = (unit.inCombat() and profileStop) or br._G.IsMounted() or br.pause() or mode.rotation==4
    arcaneCharges                                 = br.player.power.arcaneCharges.amount()
    arcaneChargesMax                              = br.player.power.arcaneCharges.max()
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40,true)
    enemies.get(10)
    enemies.get(40)

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = br._G.GetTime() end

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
            --Arcane Intellect
            if cast.able.arcaneIntellect() and not buff.arcaneIntellect.exists("player") then
                if cast.arcaneIntellect() then ui.debug("Casting Arcane Intellect") return true end
            end
            -- Arcane Familiar
            if cast.able.arcaneFamiliar() and not buff.arcaneFamiliar.exists("player") then
                cast.arcaneFamiliar()
            end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        -- Check for combat
        if cd.global.remain() == 0 then
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                ------------------------------
                --- In Combat - Interrupts ---
                ------------------------------
                --Counterspell Interrupt
                if br.canInterrupt() then
                    if cast.able.counterspell() and unit.distance(units.dyn40) then
                        if cast.counterspell() then ui.debug("Casting Counterspell") return true end
                    end
                end

                -- variable,name=aoe_spark_phase,op=set,value=1,if=active_enemies>=variable.aoe_target_count&(action.arcane_orb.charges>0|buff.arcane_charge.stack>=3)&cooldown.radiant_spark.ready&cooldown.touch_of_the_magi.remains<=(gcd.max*2)
                if #enemies.yards40 >= var.aoe_target_count and (charges.arcaneOrb.count() > 0 or arcaneCharges >= 3) and cd.radiantSpark.ready() and cd.touchOfTheMagi.remains() <= (unit.gcd()*2) then
                    var.aoe_spark_phase = 1
                end
                -- variable,name=aoe_spark_phase,op=set,value=0,if=variable.aoe_spark_phase&debuff.radiant_spark_vulnerability.down&dot.radiant_spark.remains<7&cooldown.radiant_spark.remains
                if var.aoe_spark_phase and not debuff.radiantSparkVulnerability.exists() and debuff.radiantSpark.remains() < 7 and cd.radiantSpark.remains() then
                    var.aoe_spark_phase = 0
                end
                -- variable,name=spark_phase,op=set,value=1,if=buff.arcane_charge.stack>3&active_enemies<variable.aoe_target_count&cooldown.radiant_spark.ready&cooldown.touch_of_the_magi.remains<=(gcd.max*7)
                if arcaneCharges > 3 and #enemies.yards40 < var.aoe_target_count and cd.radiantSpark.ready() and cd.touchOfTheMagi.remains() <= (unit.gcd()*7) then
                    var.spark_phase = 1
                end
                -- variable,name=spark_phase,op=set,value=0,if=variable.spark_phase&debuff.radiant_spark_vulnerability.down&dot.radiant_spark.remains<7&cooldown.radiant_spark.remains
                if var.spark_phase and not debuff.radiantSparkVulnerability.exists() and debuff.radiantSpark.remains() < 7 and cd.radiantSpark.remains() then
                    var.spark_phase = 0
                end
                -- variable,name=surge_last_spark_stack,op=set,if=action.arcane_blast.cast_time>=gcd.max,value=0
                if cast.time.arcaneBlast() >= unit.gcd() then
                    var.surge_last_spark_stack = 0
                end
                -- variable,name=surge_last_spark_stack,op=set,if=action.arcane_blast.cast_time<gcd.max,value=1
                if cast.time.arcaneBlast() < unit.gcd() then
                    var.surge_last_spark_stack = 1
                end

                -- cancel_action,if=action.evocation.channeling&mana.pct>=95&!talent.siphon_storm
                if cast.current.evocation() and mana.percent() >= 95 and not talent.siphonStorm then
                    cast.cancel.evocation()
                end
                -- 	cancel_action,if=action.evocation.channeling&(mana.pct>fight_remains*4)&!(fight_remains>10&cooldown.arcane_surge.remains<1)
                if cast.current.evocation() and (mana.percent() > unit.ttd()*4) and not(unit.ttd() > 10 and cd.arcaneSurge.remains() < 1) then
                    cast.cancel.evocation()
                end
                -- arcane_barrage,if=fight_remains<2
                if cast.able.arcaneBarrage() and unit.ttd() < 2 then
                    cast.arcaneBarrage()
                end
                -- evocation,if=buff.arcane_surge.down&debuff.touch_of_the_magi.down&((mana.pct<10&cooldown.touch_of_the_magi.remains<20)|cooldown.touch_of_the_magi.remains<15)&(mana.pct<fight_remains*4)
                if cast.able.evocation() and not buff.arcaneSurge.exists() and not debuff.touchOfTheMagi.exists() and ((mana.percent() < 10 and cd.touchOfTheMagi.remains() < 20) or cd.touchOfTheMagi.remains() < 15) and (mana.percent() < unit.ttd()* 4) then
                    cast.evocation()
                end
                -- conjure_mana_gem,if=debuff.touch_of_the_magi.down&buff.arcane_surge.down&cooldown.arcane_surge.remains<30&cooldown.arcane_surge.remains<fight_remains&!mana_gem_charges
                if cast.able.conjuremanaGem() and debuff.touchOfTheMagi.exists() and not buff.arcaneSurge.exists() and cd.arcaneSurge.remains() < 30 and cd.arcaneSurge.remains() < unit.ttd() and not has.manaGem() then
                    cast.conjuremanaGem()
                end
                -- use_mana_gem,if=talent.cascading_power&buff.clearcasting.stack<2&buff.arcane_surge.up
                if use.able.manaGem() and talent.cascadingPower and buff.clearcasting.stack() < 2 and buff.arcaneSurge().exists() then
                    use.manaGem()
                end
                -- use_mana_gem,if=!talent.cascading_power&(prev_gcd.1.arcane_surge&!variable.surge_last_spark_stack|variable.surge_last_spark_stack&prev_gcd.2.arcane_surge)
                if use.able.manaGem() and not talent.cascadingPower and (cast.last.arcaneSurge and cast.time.arcaneBlast() <= unit.gcd() or cast.time.arcaneBlast() <= unit.gcd() and cast.last.arcaneSurge(2)) then
                    use.manaGem()
                end
                -- call_action_list,name=cooldown_phase,if=!variable.totm_on_last_spark_stack&(cooldown.arcane_surge.remains<=(gcd.max*(1+(talent.nether_tempest&talent.arcane_echo)))|buff.arcane_surge.up|buff.arcane_overload.up)&cooldown.evocation.remains>45&((cooldown.touch_of_the_magi.remains<gcd.max*4)|cooldown.touch_of_the_magi.remains>20)&active_enemies<variable.aoe_target_count
                if not var.totm_on_last_spark_stack and (cd.arcaneSurge.remains()<= (unit.gcd()*(1+(talent.netherTempest and talent.arcaneEcho and 1 or 0))) or buff.arcaneSurge.exists() or buff.arcaneOverload.exists()) and cd.evocation.remains() > 45 and ((cd.touchOfTheMagi.remains() < unit.gcd()*4) or cd.touchOfTheMagi.remains() > 20) and #enemies.yards40 < var.aoe_target_count then
                    --actionList.cooldown_phase()
                end
                -- 	call_action_list,name=cooldown_phase,if=!variable.totm_on_last_spark_stack&cooldown.arcane_surge.remains>30&(cooldown.radiant_spark.ready|dot.radiant_spark.remains|debuff.radiant_spark_vulnerability.up)&(cooldown.touch_of_the_magi.remains<=(gcd.max*3)|debuff.touch_of_the_magi.up)&active_enemies<variable.aoe_target_count
                if not var.totm_on_last_spark_stack and cd.arcaneSurge.remains() > 30 and (cd.radiantSpark.ready() or debuff.radiantSpark.exists() or debuff.radiantSparkVulnerability.exists) and (cd.touchOfTheMagi.remains() <= (unit.gcd()*3) or debuff.touchOfTheMagi.exists()) and #enemies.yards40 < var.aoe_target_count then
                    --actionList.cooldown_phase()
                end
                -- call_action_list,name=aoe_spark_phase,if=talent.radiant_spark&variable.aoe_spark_phase
                if talent.radiantSpark and var.aoe_spark_phase then
                    ui.debug("aoe spark phase")
                    actionList.aoe_spark_phase()
                end
                -- call_action_list,name=spark_phase,if=variable.totm_on_last_spark_stack&talent.radiant_spark&variable.spark_phase
                if var.totm_on_last_spark_stack and talent.radiantSpark and var.spark_phase then
                    ui.debug("spark phase")
                    actionList.spark_phase()
                end
                -- call_action_list,name=aoe_touch_phase,if=debuff.touch_of_the_magi.up&active_enemies>=variable.aoe_target_count
                if debuff.touchOfTheMagi.exists() and #enemies.yards40 >= var.aoe_target_count then
                    ui.debug("aoe touch phase")
                    actionList.aoe_touch_phase()
                end
                -- call_action_list,name=touch_phase,if=variable.totm_on_last_spark_stack&debuff.touch_of_the_magi.up&active_enemies<variable.aoe_target_count
                if var.totm_on_last_spark_stack and debuff.touchOfTheMagi.exists() and #enemies.yards40 < var.aoe_target_count then
                    ui.debug("touch phase")
                    actionList.touch_phase()
                end
                -- call_action_list,name=aoe_rotation,if=active_enemies>=variable.aoe_target_count
                if #enemies.yards40 >= var.aoe_target_count then
                    ui.debug("aoe rotation")
                    actionList.aoe_rotation()
                end
                -- call_action_list,name=rotation
                    ui.debug("rotation")
                actionList.rotation()

            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 62 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
}) 
