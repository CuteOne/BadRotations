local rotationName = "ForsoothProtection"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.victoryRush },
        [2] = { mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.victoryRush}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.shieldBlock},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.shieldBlock}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
    -- Movement Button
    local MoverModes = {
        [1] = { mode = "On", value = 1, overlay = "Mover Enabled", tip = "Will use Charge.", highlight = 1, icon = br.player.spell.charge},
        [2] = { mode = "Off", value = 2, overlay = "Mover Disabled", tip = "Will NOT use Charge.", highlight = 0, icon = br.player.spell.charge}
    };
    br.ui:createToggle(MoverModes,"Mover", 3, 0)
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

        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")

        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")

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
local debuff
local talent
local cast
local cd
local mode
local ui
local spell
local unit
local units
local rage
local rageDeficit
-- General Locals
local haltProfile
local profileStop
local enemies
local equiped
-- Profile Specific Locals
local actionList = {}

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive
actionList.Defensive = function()
    --Shield Block
    if unit.hp() < 70 then
        if cast.able.shieldBlock and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            if cast.shieldBlock() then ui.debug("Casting Shield Block") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()
    for i = 1, #br.friend do
        local nextUnit = br.friend[i].unit
        if buff.battleShout.refresh(nextUnit) and unit.distance(100) < 40 then
            thisUnit = nextUnit
            break
        end
    end
end -- End Action List - PreCombat

actionList.aoe = function()
    -- actions.aoe=thunder_clap,if=dot.rend.remains<=1
    if cast.able.thunderClap() and debuff.rend.remains() <= 1 then
        cast.thunderClap()
    end
    -- actions.aoe+=/shield_slam,if=(set_bonus.tier30_2pc|set_bonus.tier30_4pc)&spell_targets.thunder_clap<=7|buff.earthen_tenacity.up
    if cast.able.shieldSlam() and (equiped.tier(30) >= 2 or equiped.tier(30) >= 4) and #enemies.yards8 <= 7 then
        cast.shieldSlam()
    end
    -- actions.aoe+=/thunder_clap,if=buff.violent_outburst.up&spell_targets.thunderclap>6&buff.avatar.up&talent.unstoppable_force.enabled
    if cast.able.thunderClap() and buff.violentOutburst.exists() and #enemies.yards8 > 6 and buff.avatar.exists() and talent.unstoppableForce then
        cast.thunderClap()
    end
    -- actions.aoe+=/revenge,if=rage>=70&talent.seismic_reverberation.enabled&spell_targets.revenge>=3
    if cast.able.revenge() and rage >= 70 and talent.seismicReverberation and #enemies.yards5 >= 3 then
        cast.revenge()
    end
    -- actions.aoe+=/shield_slam,if=rage<=60|buff.violent_outburst.up&spell_targets.thunderclap<=7
    if cast.able.shieldSlam() and rage <= 60 or buff.violentOutburst.exists() and #enemies.yards8 <= 7 then
        cast.shieldSlam()
    end
    -- actions.aoe+=/thunder_clap
    if cast.able.thunderClap() then
        cast.thunderClap()
    end
    -- actions.aoe+=/revenge,if=rage>=30|rage>=40&talent.barbaric_training.enabled
    if cast.able.revenge() and rage >= 30 or rage >= 40 and talent.barbaricTraining then
        cast.revenge()
    end
end

actionList.generic = function()
    -- shield_slam
    if cast.able.shieldSlam() then
        cast.shieldSlam()
    end
    -- thunder_clap,if=dot.rend.remains<=1&buff.violent_outburst.down
    if cast.able.thunderClap() and #enemies.yards8 > 0 and debuff.rend.remains() <= 1 and not buff.violentOutburst.exists() then
        cast.thunderClap()
    end
    --execute,if=buff.sudden_death.up&talent.sudden_death.enabled
    if cast.able.execute() and buff.suddenDeath.exists() and talent.suddenDeath then
        cast.execute()
    end
    -- execute,if=spell_targets.revenge=1&rage>=50
    if cast.able.execute() and #enemies.yards5 == 1 and rage >= 50 then
        cast.execute()
    end
    -- 	thunder_clap,if=(spell_targets.thunder_clap>1|cooldown.shield_slam.remains&!buff.violent_outburst.up)
    if cast.able.thunderClap() and ((#enemies.yards8 > 1 or not cd.shieldSlam.ready()) and buff.violentOutburst.exists()) then
        cast.thunderClap()
    end
    -- revenge,if=(rage>=60&target.health.pct>20|buff.revenge.up&target.health.pct<=20&rage<=18&cooldown.shield_slam.remains|buff.revenge.up&target.health.pct>20)|(rage>=60&target.health.pct>35|buff.revenge.up&target.health.pct<=35&rage<=18&cooldown.shield_slam.remains|buff.revenge.up&target.health.pct>35)&talent.massacre.enabled
    if cast.able.revenge() and (rage >= 60 and unit.hp("target") > 20 or buff.revenge.exists() and unit.hp("target") <= 20 and rage <= 18 and not cd.shieldSlam.ready() or buff.revenge.exists() and unit.hp("target") > 20) or (rage >= 60 and unit.hp("target") > 35 or buff.revenge.exists() and unit.hp("target") <= 35 and rage <= 18 and not cd.shieldSlam.ready() or buff.revenge.exists() and unit.hp("target") > 35) and talent.massacre then
        cast.revenge()
    end
    -- execute,if=spell_targets.revenge=1
    if cast.able.execute() and #enemies.yards5 == 1 then
        cast.execute()
    end 
    -- revenge
    if cast.able.revenge() and #enemies.yards5 > 0 then
        cast.revenge()
    end
    -- thunder_clap,if=(spell_targets.thunder_clap>=1|cooldown.shield_slam.remains&buff.violent_outburst.up)
    if cast.able.thunderClap() and #enemies.yards8 > 0 and debuff.rend.remains() <= 1 and buff.violentOutburst.exists() then
        cast.thunderClap()
    end
    -- devastate
    if cast.able.devastate() then
        cast.devastate()
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
    mode                                          = br.player.ui.mode
    ui                                            = br.player.ui
    spell                                         = br.player.spell
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    buff = br.player.buff
    debuff = br.player.debuff
    talent = br.player.talent
    enemies = br.player.enemies
    rage = br.player.power.rage.amount()
    rageDeficit = br.player.power.rage.deficit()
    equiped = br.player.equiped
    -- General Locals
    profileStop                                   = profileStop or false
    haltProfile                                   = (unit.inCombat() and profileStop) or unit.mounted() or br.pause() or mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40,true)

    enemies.get(5)
    enemies.get(8)
    enemies.get(12)

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = ui.time() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        br.pauseTime = ui.time()
        return true
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
        if unit.valid("target") and cd.global.remain() == 0 then
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                ------------------------------
                --- In Combat - Interrupts ---
                ------------------------------
                -- Start Attack
                for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    
                    if cast.able.pummel() and unit.interruptable(thisUnit,70) then
                        if cast.pummel() then ui.debug("Casting Pummel [Interrupt]") return true end
                    end
                end
                -- actions=auto_attack
                if not cast.auto.autoAttack() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    if cast.autoAttack() then ui.debug("Casting Auto Attack") return true end
                end
                -- avatar
                if br.isBoss() and unit.ttd() > 20 and cast.able.avatar() then
                    cast.avatar()
                end
                -- shield_wall,if=talent.immovable_object.enabled&buff.avatar.down
                if br.isBoss() and unit.ttd() > 20 and cast.able.shieldWall() and talent.immovableObject and not buff.avatar.exists() then
                    cast.shieldWall()
                end
                -- blood_fury
                if br.isBoss() and unit.ttd() > 15 and cast.able.racial() then
                    cast.racial()
                end
                -- ignore_pain,if=target.health.pct>=20&(rage.deficit<=15&cooldown.shield_slam.ready|rage.deficit<=40&cooldown.shield_charge.ready&talent.champions_bulwark.enabled|rage.deficit<=20&cooldown.shield_charge.ready|rage.deficit<=30&cooldown.demoralizing_shout.ready&talent.booming_voice.enabled|rage.deficit<=20&cooldown.avatar.ready|rage.deficit<=45&cooldown.demoralizing_shout.ready&talent.booming_voice.enabled&buff.last_stand.up&talent.unnerving_focus.enabled|rage.deficit<=30&cooldown.avatar.ready&buff.last_stand.up&talent.unnerving_focus.enabled|rage.deficit<=20|rage.deficit<=40&cooldown.shield_slam.ready&buff.violent_outburst.up&talent.heavy_repercussions.enabled&talent.impenetrable_wall.enabled|rage.deficit<=55&cooldown.shield_slam.ready&buff.violent_outburst.up&buff.last_stand.up&talent.unnerving_focus.enabled&talent.heavy_repercussions.enabled&talent.impenetrable_wall.enabled|rage.deficit<=17&cooldown.shield_slam.ready&talent.heavy_repercussions.enabled|rage.deficit<=18&cooldown.shield_slam.ready&talent.impenetrable_wall.enabled),use_off_gcd=1
                if cast.able.ignorePain() and unit.hp() >= 20 and ((rageDeficit<=15 and cd.shieldSlam.ready()) or (rageDeficit<=40 and cd.shieldCharge.ready() and talent.championsBulwark) or (rageDeficit<=20 and cd.shieldCharge.ready()) or (rageDeficit <= 30 and cd.demoralizingShout.ready() and talent.boomingVoice) or (rageDeficit<=20 and cd.avatar.ready()) or (rageDeficit<=45 and cd.demoralizingShout.ready() and talent.boomingVoice and buff.lastStand.exists() and talent.unnervingFocus) or (rageDeficit <= 20) or (rageDeficit <= 40 and cd.shieldSlam.ready() and buff.violentOutburst.exists() and talent.heavyRepercussions and talent.impentrableWall) or (rageDeficit <= 55 and cd.shieldSlam.ready() and buff.violentOutburst.exists() and buff.lastStand.exists() and talent.unnervingFocus and talent.heavyRepercussions and talent.impentrableWall) or (rageDeficit <= 17 and cd.shieldSlam.ready() and talent.heavyRepercussions) or (rageDeficit <= 18 and cd.shieldSlam.ready() and talent.impentrableWall)) then
                    cast.ignorePain()
                end
                -- last_stand,if=(target.health.pct>=90&talent.unnerving_focus.enabled|target.health.pct<=20&talent.unnerving_focus.enabled)|talent.bolster.enabled|set_bonus.tier30_2pc|set_bonus.tier30_4pc
                if cast.able.lastStand() and ((unit.hp("target") >= 90 and talent.unnervingFocus) or (unit.hp("target") <= 20  and talent.unnervingFocus)) or talent.bolster then
                    cast.lastStand()
                end
                -- ravager
                if br.isBoss() and unit.ttd() > 11 and cast.able.ravager() then
                    cast.ravager()
                end
                -- demoralizing_shout,if=talent.booming_voice.enabled
                if cast.able.demoralizingShout() and talent.boomingVoice then
                    cast.demoralizingShout()
                end
                -- spear_of_bastion
                if br.isBoss() and unit.ttd() > 5 and cast.able.spearOfBastion("best",nil,1,5) then
                    cast.spearOfBastion("best",nil,1,5)
                end
                -- 	thunderous_roar
                if br.isBoss() and cast.able.thunderousRoar() and #enemies.yards12 > 0 then
                    cast.thunderousRoar()
                end
                -- shockwave,if=talent.sonic_boom.enabled&buff.avatar.up&talent.unstoppable_force.enabled&!talent.rumbling_earth.enabled
                if cast.able.shockwave() and talent.sonicBoom and buff.avatar.exists() and talent.unstoppableForce and not talent.rumblingEarth then
                    cast.shockwave()
                end
                -- shield_charge
                if cast.able.shieldCharge() then
                    cast.shieldCharge()
                end
                -- shield_block,if=buff.shield_block.duration<=18&talent.enduring_defenses.enabled|buff.shield_block.duration<=12
                if cast.able.shieldBlock() and buff.shieldBlock.remains() <= 18 and (talent.enduringDefenses or buff.shieldBlock.remains() <= 12) then
                    cast.shieldBlock()
                end
                -- actions+=/run_action_list,name=aoe,if=spell_targets.thunder_clap>=3
                if #enemies.yards8 >= 3 then
                    actionList.aoe()
                end
                -- actions+=/call_action_list,name=generic
                actionList.generic()
                

            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 73 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})