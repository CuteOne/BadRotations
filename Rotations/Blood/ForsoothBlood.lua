local rotationName = "ForsoothBlood"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.runeStrike },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.runeStrike }
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.deathStrike },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.deathStrike }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupt Enabled", tip = "Enabled Interrupt", highlight = 1, icon = br.player.spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupt Disabled", tip = "Disable Interrupt", highlight = 0, icon = br.player.spell.mindFreeze }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",3,0)
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
            -- Death Grip
            br.ui:createCheckbox(section, "Death Grip")
            -- Trinkets
            br.ui:createCheckbox(section, "Trinkets")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Anti-Magic Shell
            br.ui:createSpinner(section, "Anti-Magic Shell", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Death Strike
            br.ui:createSpinner(section, "Death Strike", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupt")
            -- Death Grip
            br.ui:createCheckbox(section, "Death Grip - Int")
            -- Mind Freeze
            br.ui:createCheckbox(section, "Mind Freeze")
            -- "Interrupt At"
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupt Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
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
local cast
local cd
local enemies
local module
local runes
local runicPower
local gcd
local buff
local debuff
local charges
local talent
local pet
local ui
local unit
local units
local runicPowerDeficit
local use
local var
-- Profile Specific Locals
local actionList = {}
local var = {}
var.haltProfile = false
var.profileStop = false

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive
actionList.Defensive = function()
    -- Pot/Stoned
    if unit.hp() <= 50 and inCombat and (br.hasHealthPot() or br.hasItem(5512)) then
        if br.canUseItem(5512) then
            br.useItem(5512)
        elseif br.canUseItem(healPot) then
            br.useItem(healPot)
        end
    end



    -- Raise Ally
    if br._G.UnitIsPlayer("target") and br.GetUnitIsDeadOrGhost("target") and br.GetUnitIsFriend("target", "player") then
        if cast.raiseAlly("target", "dead") then
            return
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        -- Mind Freeze
        if cast.able.mindFreeze() then
            for i=1, #enemies.yards15 do
                local thisUnit = enemies.yards15[i]
                if br.canInterrupt(thisUnit,80) then
                    if cast.mindFreeze(thisUnit) then ui.debug("Casting Mind Freeze") return true end
                end
            end
        end
        --Death Grip
        if cast.able.deathGrip() then
            for i = 1,  #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if br.canInterrupt(thisUnit,80) and unit.distance(thisUnit) > 8 then
                    if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip [Int]") return true end
                end
            end
        end
    end
end-- End Action List - Interrupts

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Death Grip
            if cast.able.deathGrip("target") and not unit.isDummy("target")
                and unit.distance("target") > 8 and unit.distance("target") < 30
            then
                if cast.deathGrip("target") then ui.debug("Casting Death Grip [Pull]") return true end
            end
            -- Start Attack
            -- actions=auto_attack
            if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                br._G.StartAttack(units.dyn5)
            end
        end
    end
end -- End Action List - PreCombat

actionList.DrwUp = function()
    -- blood_boil,if=!dot.blood_plague.ticking
    if cast.able.bloodBoil() and not debuff.bloodPlague.exists() and #enemies.yards10 > 0 then
        cast.bloodBoil()
    end
    -- 	tombstone,if=buff.bone_shield.stack>5&rune>=2&runic_power.deficit>=30&!talent.shattering_bone|(talent.shattering_bone.enabled&death_and_decay.ticking)
    if cast.able.tombstone() and buff.boneShield.stack() > 5 and runes >= 2 and runicPowerDeficit >= 30 and not talent.shatteringBone or (talent.shatteringBone and buff.deathAndDecay.exists()) then
        cast.tombstone()
    end
    -- 	death_strike,if=buff.coagulopathy.remains<=gcd|buff.icy_talons.remains<=gcd
    if cast.able.deathStrike() and buff.coagulopathy.remains() <= gcd or buff.icyTalons.remains() <= gcd then
        cast.deathStrike()
    end
    -- 	marrowrend,if=(buff.bone_shield.remains<=4|buff.bone_shield.stack<variable.bone_shield_refresh_value)&runic_power.deficit>20
    if cast.able.marrowrend and (buff.boneShield.remains() <= 4 or buff.boneShield.stack() < var.boneShieldRefreshValue) and runicPowerDeficit > 20 then
        cast.able.marrowrend()
    end
    -- 	soul_reaper,if=active_enemies=1&target.time_to_pct_35<5&target.time_to_die>(dot.soul_reaper.remains+5)
    if cast.able.soulReaper() and #enemies.yards5 == 1 and unit.ttdGroup(5,35) < 5 and unit.ttd() > (debuff.soulReaper.remains() + 5) then
        cast.soulReaper()
    end
    -- soul_reaper,target_if=min:dot.soul_reaper.remains,if=target.time_to_pct_35<5&active_enemies>=2&target.time_to_die>(dot.soul_reaper.remains+5)
    if cast.able.soulReaper() and debuff.soulReaper.remains() < gcd and unit.ttdGroup(5,35) < 5 and #enemies.yards5 >= 2 and unit.ttd() > (debuff.soulReaper.remains() +5) then
        cast.soulReaper()
    end
    -- death_and_decay,if=!death_and_decay.ticking&(talent.sanguine_ground|talent.unholy_ground)
    if cast.able.deathAndDecay() and not buff.deathAndDecay.exists() and (talent.sanguineGround or talent.unholyGround) then
        cast.deathAndDecay("player")
    end
    -- blood_boil,if=spell_targets.blood_boil>2&charges_fractional>=1.1
    if cast.able.bloodBoil() and #enemies.yards10 >2 and charges.bloodBoil.frac() >= 1.1 then
        cast.bloodBoil()
    end
    -- variable,name=heart_strike_rp_drw,value=(25+spell_targets.heart_strike*talent.heartbreaker.enabled*2)
    var.heartStrikeRpDrw = (25+(#enemies.yards5 > 2 and 2 or #enemies.yards5)*(talent.heartbreaker and 1 or 0)*2)
    -- death_strike,if=runic_power.deficit<=variable.heart_strike_rp_drw|runic_power>=variable.death_strike_dump_amount
    if cast.able.deathStrike() and runicPowerDeficit <= var.heartStrikeRP or runicPower >= var.deathStrikeDumpAmount then
        cast.deathStrike()
    end
    --consumption
    if cast.able.consumption() then
        cast.consumption()
    end
    -- blood_boil,if=charges_fractional>=1.1&buff.hemostasis.stack<5
    if cast.able.bloodBoil() and charges.bloodBoil.frac() >= 1.1 and buff.hemostasis.stack() < 5 and #enemies.yards10 > 0 then
        cast.bloodBoil()
    end
    -- heart_strike,if=rune.time_to_2<gcd|runic_power.deficit>=variable.heart_strike_rp_drw
    if cast.able.heartStrike() and br.runeTimeTill(2) < gcd or runicPowerDeficit >= var.heartStrikeRpDrw then
        cast.heartStrike()
    end
end

actionList.Standard = function()
    -- tombstone,if=buff.bone_shield.stack>5&rune>=2&runic_power.deficit>=30&!talent.shattering_bone|(talent.shattering_bone.enabled&death_and_decay.ticking)&cooldown.dancing_rune_weapon.remains>=25
    if cast.able.tombstone() and buff.boneShield.stack() > 5 and runes >= 2 and runicPowerDeficit >= 30 and not talent.shatteringBone or (talent.shatteringBone and buff.deathAndDecay.exists()) and cd.dancingRuneWeapon.remains() >= 25 then
        cast.tombstone()
    end
    -- variable,name=heart_strike_rp,value=(10+spell_targets.heart_strike*talent.heartbreaker.enabled*2)
    var.heartStrikeRP = (10+(#enemies.yards5 > 2 and 2 or #enemies.yards5)*(talent.heartbreaker and 1 or 0)*2)
    -- death_strike,if=buff.coagulopathy.remains<=gcd|buff.icy_talons.remains<=gcd|runic_power>=variable.death_strike_dump_amount|runic_power.deficit<=variable.heart_strike_rp|target.time_to_die<10
    if cast.able.deathStrike() and buff.coagulopathy.remains() <= gcd or buff.icyTalons.remains() <= gcd or runicPower >= var.deathStrikeDumpAmount or runicPowerDeficit <= var.heartStrikeRP or unit.ttd() < 10 then
        cast.deathStrike()
    end
    -- deaths_caress,if=(buff.bone_shield.remains<=4|(buff.bone_shield.stack<variable.bone_shield_refresh_value+1))&runic_power.deficit>10&!(talent.insatiable_blade&cooldown.dancing_rune_weapon.remains<buff.bone_shield.remains)&!talent.consumption.enabled&!talent.blooddrinker.enabled&rune.time_to_3>gcd
    if cast.able.deathsCaress and (buff.boneShield.remains() <= 4 or (buff.boneShield.stack() < var.boneShieldRefreshValue+1)) and runicPowerDeficit > 10 and not (talent.insatiableBlade and cd.dancingRuneWeapon.remains() < buff.boneShield.remains()) and not talent.consumption and not talent.blooddrinker and br.runeTimeTill(3) > gcd then
        cast.deathsCaress()
    end
    -- marrowrend,if=(buff.bone_shield.remains<=4|buff.bone_shield.stack<variable.bone_shield_refresh_value)&runic_power.deficit>20&!(talent.insatiable_blade&cooldown.dancing_rune_weapon.remains<buff.bone_shield.remains)
    if cast.able.marrowrend() and (buff.boneShield.remains() <= 4 or buff.boneShield.stack() < var.boneShieldRefreshValue) and runicPowerDeficit>20 and not (talent.insatiableBlade and cd.dancingRuneWeapon.remains() < buff.boneShield.remains()) then
        cast.marrowrend()
    end
    --consumption
    if cast.able.consumption() then
        cast.consumption()
    end
    -- 	soul_reaper,if=active_enemies=1&target.time_to_pct_35<5&target.time_to_die>(dot.soul_reaper.remains+5)
    if cast.able.soulReaper() and #enemies.yards5 == 1 and unit.ttdGroup(5,35) < 5 and unit.ttd() > (debuff.soulReaper.remains() + 5) then
        cast.soulReaper()
    end
    -- soul_reaper,target_if=min:dot.soul_reaper.remains,if=target.time_to_pct_35<5&active_enemies>=2&target.time_to_die>(dot.soul_reaper.remains+5)
    if cast.able.soulReaper() and debuff.soulReaper.remains() < gcd and unit.ttdGroup(5,35) < 5 and #enemies.yards5 >= 2 and unit.ttd() > (debuff.soulReaper.remains() +5) then
        cast.soulReaper()
    end
    -- 	bonestorm,if=runic_power>=100
    if cast.able.bonestorm() and runicPower >= 100 then
        cast.bonestorm()
    end
    -- blood_boil,if=charges_fractional>=1.8&(buff.hemostasis.stack<=(5-spell_targets.blood_boil)|spell_targets.blood_boil>2)
    if cast.able.bloodBoil() and charges.bloodBoil.frac() >= 1.8 and (buff.hemostasis.stack() <= (5-#enemies.yards10) or #enemies.yards10 > 2) then
        cast.bloodBoil()
    end
    -- heart_strike,if=rune.time_to_4<gcd
    if cast.able.heartStrike() and br.runeTimeTill(4) < gcd then
        cast.heartStrike()
    end
    -- 	blood_boil,if=charges_fractional>=1.1
    if cast.able.bloodBoil() and charges.bloodBoil.frac() >= 1.1 and #enemies.yards10 > 0 then
        cast.bloodBoil()
    end
    -- heart_strike,if=(rune>1&(rune.time_to_3<gcd|buff.bone_shield.stack>7))
    if cast.able.heartStrike() and (runes > 1 and (br.runeTimeTill(3)<gcd or buff.boneShield.stack() > 7)) then
        cast.heartStrike()
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
    enemies                                       = br.player.enemies
    module                                        = br.player.module
    runes                                         = br.player.power.runes.amount()
    runicPower                                    = br.player.power.runicPower.amount()
    runicPowerDeficit = br.player.power.runicPower.deficit()
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    gcd = br.player.gcd
    charges = br.player.charges
    buff = br.player.buff
    talent = br.player.talent
    var = br.player.variables
    pet = br.player.pet
    debuff = br.player.debuff
    -- General Locals
    var.haltProfile                               = (unit.inCombat() and var.profileStop) or unit.mounted() or br.pause() or ui.mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    enemies.get(15)
    enemies.get(30)

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif var.haltProfile then
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
                -----------------
                --- Interrupt ---
                -----------------
                -- Start Attack
                -- actions=auto_attack
                if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    br._G.StartAttack(units.dyn5)
                end
                -- variable,name=death_strike_dump_amount,value=65
                var.deathStrikeDumpAmount = 65
                -- 	variable,name=bone_shield_refresh_value,value=4,op=setif,condition=!talent.deaths_caress.enabled|talent.consumption.enabled|talent.blooddrinker.enabled,value_else=5
                if talent.deathsCaress or talent.consumption or talent.blooddrinker then
                    var.boneShieldRefreshValue = 4
                else
                    var.boneShieldRefreshValue = 5
                end

                if actionList.Interrupts() then return true end

                -- icebound_fortitude,if=!(buff.dancing_rune_weapon.up|buff.vampiric_blood.up)&(target.cooldown.pause_action.remains>=8|target.cooldown.pause_action.duration>0)
                if cast.able.iceboundFortitude() and not (buff.dancingRuneWeapon.exists() or buff.vampiricBlood.exists()) and unit.ttd("target") >= 8 then
                    cast.iceboundFortitude()
                end
                -- 	vampiric_blood,if=!buff.vampiric_blood.up&!buff.vampiric_strength.up
                if cast.able.vampiricBlood() and not buff.vampiricBlood.exists() and not buff.vampiricStrength.exists() then
                    cast.vampiricBlood()
                end
                -- 	vampiric_blood,if=!(buff.dancing_rune_weapon.up|buff.icebound_fortitude.up|buff.vampiric_blood.up|buff.vampiric_strength.up)&(target.cooldown.pause_action.remains>=13|target.cooldown.pause_action.duration>0)
                if cast.able.vampiricBlood() and not (buff.dancingRuneWeapon.exists() or buff.iceboundFortitude.exists() or buff.vampiricBlood.exists() or buff.vampiricStrength.exists()) and unit.ttd("target") >= 13 then
                    cast.vampiricBlood()
                end
                -- 	deaths_caress,if=!buff.bone_shield.up
                if cast.able.deathsCaress() and not buff.boneShield.exists() then
                    cast.deathsCaress()
                end
                -- 	death_and_decay,if=!death_and_decay.ticking&(talent.unholy_ground|talent.sanguine_ground|spell_targets.death_and_decay>3|buff.crimson_scourge.up)
                if cast.able.deathAndDecay() and not buff.deathAndDecay.exists() and (talent.unholyGround or talent.sanguineGround or #enemies.yards8 > 3 or buff.crimsonScourge.exists()) then
                    cast.deathAndDecay("player")
                end
                -- death_strike,if=buff.coagulopathy.remains<=gcd|buff.icy_talons.remains<=gcd|runic_power>=variable.death_strike_dump_amount|runic_power.deficit<=variable.heart_strike_rp|target.time_to_die<10
                if cast.able.deathStrike() and buff.coagulopathy.remains() <= gcd or buff.icyTalons.remains() <= gcd or runicPower>=65 or runicPowerDeficit<=var.heartStrikeRP or unit.ttd("target") < 10 then
                    cast.deathStrike()
                end
                --blooddrinker,if=!buff.dancing_rune_weapon.up
                if cast.able.blooddrinker() and buff.dancingRuneWeapon.exists() then
                    cast.blooddrinker()
                end
                -- sacrificial_pact,if=!buff.dancing_rune_weapon.up&(pet.ghoul.remains<2|target.time_to_die<gcd)
                if cast.able.sacrificialPact and buff.dancingRuneWeapon.exists() and (pet.active.exists() or unit.ttd("target") < gcd) then
                    cast.sacrificialPact()
                end
                -- blood_tap,if=(rune<=2&rune.time_to_4>gcd&charges_fractional>=1.8)|rune.time_to_3>gcd
                if cast.able.bloodTap() and (runes < 2 and br.runeTimeTill(4) > gcd and charges.bloodTap.frac() >= 1.8 or br.runeTimeTill(3) > gcd) then
                    cast.bloodTap()
                end
                -- gorefiends_grasp,if=talent.tightening_grasp.enabled
                if cast.able.gorefiendsGrasp() and talent.tighteningGrasp then
                    cast.gorefiendsGrasp()
                end
                -- empower_rune_weapon,if=rune<6&runic_power.deficit>5
                if br.isBoss() and cast.able.empowerRuneWeapon() and runes < 6 and runicPowerDeficit > 5 and unit.ttd() >= 20 then
                    cast.able.empowerRuneWeapon()
                end
                -- abomination_limb
                if br.isBoss() and unit.ttd() >= 12 and cast.able.abominationLimb() then
                    cast.abominationLimb()
                end
                -- 	dancing_rune_weapon,if=!buff.dancing_rune_weapon.up
                if br.isBoss() and unit.ttd() >= 16 and cast.able.dancingRuneWeapon() and not buff.dancingRuneWeapon.exists() then
                    cast.dancingRuneWeapon()
                end
                -- run_action_list,name=drw_up,if=buff.dancing_rune_weapon.up
                if buff.dancingRuneWeapon.exists() then
                    actionList.DrwUp()
                -- 	call_action_list,name=standard
                else
                    actionList.Standard()
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 250
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})