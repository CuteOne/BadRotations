-------------------------------------------------------
-- Author = CuteOne
-- Patch = 11.0.2
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 50%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Limited
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Untested
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1, overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spells.runeStrike },
        [2] = { mode = "Off", value = 4, overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spells.runeStrike }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.deathStrike },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.deathStrike }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupt Enabled", tip = "Enabled Interrupt", highlight = 1, icon = br.player.spells.mindFreeze },
        [2] = { mode = "Off", value = 2, overlay = "Interrupt Disabled", tip = "Disable Interrupt", highlight = 0, icon = br.player.spells.mindFreeze }
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 3, 0)
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
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- Death Grip
        br.ui:createCheckbox(section, "Death Grip")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Basic Trinkets Module
        br.player.module.BasicTrinkets(nil, section)
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Basic Healing Module
        br.player.module.BasicHealing(section)
        -- Lichborne
        br.ui:createSpinner(section, "Lichborne", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
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
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5,
            "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        -- Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Interrupt Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end
    optionTable = { {
        [1] = "Rotation Options",
        [2] = rotationOptions,
    } }
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
local debuff
local enemies
local module
local pet
local runes
local runicPower
local talent
local ui
local unit
local units
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
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Lichborne
        if ui.checked("Lichborne") and cast.able.lichborne() and unit.hp() < ui.value("Lichborne") then
            if cast.lichborne() then
                ui.debug("Casting Lichborne")
                return true
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                -- Death Grip
                if ui.checked("Death Grip - Int") and unit.distance(thisUnit) > 8 then
                    if cast.deathGrip(thisUnit) then return end
                end
                -- Mind Freeze
                if ui.checked("Mind Freeze") and unit.distance(thisUnit) < 15 then
                    if cast.mindFreeze(thisUnit) then return end
                end
            end
        end -- End useInterrupts check
    end
end         -- End Action List - Interrupts

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        -- Module - Phial Up
        -- flask
        module.PhialUp()

        -- Module - Imbue Up
        -- augmentation
        module.ImbueUp()
        -- Variable - Trinket 1 Buffs
        -- variable,name=trinket_1_buffs,value=trinket.1.has_use_buff|(trinket.1.has_buff.strength|trinket.1.has_buff.mastery|trinket.1.has_buff.versatility|trinket.1.has_buff.haste|trinket.1.has_buff.crit)|trinket.1.is.mirror_of_fractured_tomorrows
        -- TODO

        -- Variable - Trinket 2 Buffs
        -- variable,name=trinket_2_buffs,value=trinket.2.has_use_buff|(trinket.2.has_buff.strength|trinket.2.has_buff.mastery|trinket.2.has_buff.versatility|trinket.2.has_buff.haste|trinket.2.has_buff.crit)|trinket.2.is.mirror_of_fractured_tomorrows
        -- TODO

        -- Variable - Trinket 1 Exclude
        -- variable,name=trinket_1_exclude,value=trinket.1.is.ruby_whelp_shell|trinket.1.is.whispering_incarnate_icon
        -- TODO

        -- Variable - Trinket 2 Exclude
        -- variable,name=trinket_2_exclude,value=trinket.2.is.ruby_whelp_shell|trinket.2.is.whispering_incarnate_icon
        -- TODO

        -- Variable - Damage Trinket Priority
        -- variable,name=damage_trinket_priority,op=setif,value=2,value_else=1,condition=!variable.trinket_2_buffs&trinket.2.ilvl>=trinket.1.ilvl|variable.trinket_1_buffs
        -- TODO

        if unit.valid("target") then
            -- Death Grip
            if ui.checked("Death Grip") and cast.able.deathGrip("target") and not unit.isDummy("target")
                and unit.distance("target") > 8 and unit.distance("target") < 30
                and (not unit.moving("target") or (unit.moving("target") and not unit.facing("target", "player")))
            then
                if cast.deathGrip("target") then
                    ui.debug("Casting Death Grip [Precombat]")
                    return true
                end
            end
            -- Death Coil - Ranged
            if cast.able.deathCoil() and runicPower > 30 and unit.distance(units.dyn5) >= 5 then
                if cast.deathCoil() then
                    ui.debug("Casting Death Coil [Precombat")
                    return true
                end
            end
            -- Start Attack
            -- actions=auto_attack
            if cast.able.autoAttack() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack() then
                    ui.debug("Casting Auto Attack [Precombat]")
                    return true
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    -- Check for combat
    if unit.valid("target") and cd.global.remain() == 0 then
        if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
            -- Start Attack
            -- actions=auto_attack
            if cast.able.autoAttack() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack() then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
            -- Death Grip
            if ui.checked("Death Grip") and cast.able.deathGrip("target") and not unit.isDummy("target")
                and unit.distance("target") > 8 and unit.distance("target") < 30
                and (not unit.moving("target") or (unit.moving("target") and not unit.facing("target", "player")))
            then
                if cast.deathGrip("target") then
                    ui.debug("Casting Death Grip [Pull]")
                    return true
                end
            end
            -- Variable - Death Strike Dump Amount
            -- variable,name=death_strike_dump_amount,value=65
            var.deathStrikeDumpAmount = 65
            -- Variable - Bone Shield Refresh Value,Value=4,Op=Setif,Condition=Talent.Consumption.Enabled|Talent.Blooddrinker.Enabled,Value Else=5
            -- variable,name=bone_shield_refresh_value,value=4,op=setif,condition=talent.consumption.enabled|talent.blooddrinker.enabled,value_else=5
            if talent.consumption or talent.blooddrinker then
                var.boneShieldRefreshValue = 4
            else
                var.boneShieldRefreshValue = 5
            end
            -- Call Action List -Interrupts
            if actionList.Interrupts() then return true end
            -- Module - Combatpotion Up
            -- potion,if=buff.dancing_rune_weapon.up
            if buff.dancingRuneWeapon.exists() then
                module.CombatpotionUp()
            end
            -- Call Action List - Trinkets
            -- call_action_list,name=trinkets
            if actionList.Trinkets() then return true end
            -- Raise Dead
            -- raise_dead
            if cast.able.raiseDead() then
                if cast.raiseDead() then
                    ui.debug("Casting Raise Dead [Combat]")
                    return true
                end
            end
            -- Reapers Mark
            -- reapers_mark
            if cast.able.reapersMark() then
                if cast.reapersMark() then
                    ui.debug("Casting Reapers Mark [Combat]")
                    return true
                end
            end
            -- Icebound Fortitude
            -- icebound_fortitude,if=!(buff.dancing_rune_weapon.up|buff.vampiric_blood.up)&(target.cooldown.pause_action.remains>=8|target.cooldown.pause_action.duration>0)
            -- TODO

            -- Vampiric Blood
            -- vampiric_blood,if=!(buff.dancing_rune_weapon.up|buff.icebound_fortitude.up|buff.vampiric_blood.up)&(target.cooldown.pause_action.remains>=13|target.cooldown.pause_action.duration>0)
            -- TODO

            -- Deaths Caress
            -- deaths_caress,if=!buff.bone_shield.up
            if cast.able.deathsCaress() and not buff.boneShield.exists() then
                if cast.deathsCaress() then
                    ui.debug("Casting Deaths Caress [Combat]")
                    return true
                end
            end
            -- Death And Decay
            -- death_and_decay,if=!death_and_decay.ticking&(talent.unholy_ground|talent.sanguine_ground|spell_targets.death_and_decay>3|buff.crimson_scourge.up)
            if cast.able.deathAndDecay("target", "ground", 1, 8) and ((not buff.deathAndDecay.exists(units.dyn40)
                    and (talent.unholyGround or talent.sanguineGround or #enemies.yards8 > 3 or buff.crimsonScourge.exists())))
            then
                if cast.deathAndDecay("target", "ground", 1, 8) then
                    ui.debug("Casting Death And Decay [Combat]")
                    return true
                end
            end
            -- Death Strike
            -- death_strike,if=buff.coagulopathy.remains<=gcd|buff.icy_talons.remains<=gcd|runic_power>=variable.death_strike_dump_amount|runic_power.deficit<=variable.heart_strike_rp|target.time_to_die<10
            if cast.able.deathStrike() and ((buff.coagulopathy.remains() <= unit.gcd(true) or buff.icyTalons.remains() <= unit.gcd(true)
                    or runicPower() >= var.deathStrikeDumpAmount or runicPower.deficit() <= var.heartStrikeRp or unit.ttd(units.dyn5) < 10))
            then
                if cast.deathStrike() then
                    ui.debug("Casting Death Strike [Combat]")
                    return true
                end
            end
            -- Blooddrinker
            -- blooddrinker,if=!buff.dancing_rune_weapon.up
            if cast.able.blooddrinker() and not buff.dancingRuneWeapon.exists() then
                if cast.blooddrinker() then
                    ui.debug("Casting Blooddrinker [Combat]")
                    return true
                end
            end
            -- Call Action List - Racials
            -- call_action_list,name=racials
            if actionList.Racials() then return true end
            -- Sacrificial Pact
            -- sacrificial_pact,if=!buff.dancing_rune_weapon.up&(pet.ghoul.remains<2|target.time_to_die<gcd)
            if cast.able.sacrificialPact() and ((not buff.dancingRuneWeapon.exists() and (pet.ghoul.exists() or unit.ttd(units.dyn5) < unit.gcd(true)))) then
                if cast.sacrificialPact() then
                    ui.debug("Casting Sacrificial Pact [Combat]")
                    return true
                end
            end
            -- Blood Tap
            -- blood_tap,if=(runes<=2&runes.time_to_4>gcd&charges_fractional>=1.8)|runes.time_to_3>gcd
            if cast.able.bloodTap() and (((runes() <= 2 and runes.ttm(4) > unit.gcd(true) and charges.bloodTap.frac() >= 1.8) or runes.ttm(3) > unit.gcd(true))) then
                if cast.bloodTap() then
                    ui.debug("Casting Blood Tap [Combat]")
                    return true
                end
            end
            -- Gorefiends Grasp
            -- gorefiends_grasp,if=talent.tightening_grasp.enabled
            if cast.able.gorefiendsGrasp() and talent.tighteningGrasp then
                if cast.gorefiendsGrasp() then
                    ui.debug("Casting Gorefiends Grasp [Combat]")
                    return true
                end
            end
            -- Abomination Limb
            -- abomination_limb
            if cast.able.abominationLimb() then
                if cast.abominationLimb() then
                    ui.debug("Casting Abomination Limb [Combat]")
                    return true
                end
            end
            -- Dancing runes Weapon
            -- dancing_rune_weapon,if=!buff.dancing_rune_weapon.up
            if cast.able.dancingRuneWeapon() and not buff.dancingRuneWeapon.exists() then
                if cast.dancingRuneWeapon() then
                    ui.debug("Casting Dancing runes Weapon [Combat]")
                    return true
                end
            end
            -- Call Action List - Drw Up
            -- run_action_list,name=drw_up,if=buff.dancing_rune_weapon.up
            if buff.dancingRuneWeapon.exists() then
                if actionList.DrwUp() then return true end
            end
            -- Call Action List - Standard
            -- call_action_list,name=standard
            if actionList.Standard() then return true end
        end -- End In Combat Rotation
    end
end         -- End Action List - Combat

-- Action List - DrwUp
actionList.DrwUp = function()
    -- Blood Boil
    -- blood_boil,if=!dot.blood_plague.ticking
    if cast.able.bloodBoil() and not debuff.bloodPlague.exists(units.dyn5) then
        if cast.bloodBoil() then
            ui.debug("Casting Blood Boil [Drw Up]")
            return true
        end
    end
    -- Tombstone
    -- tombstone,if=buff.bone_shield.stack>5&runes>=2&runic_power.deficit>=30&!talent.shattering_bone|(talent.shattering_bone.enabled&death_and_decay.ticking)
    if cast.able.tombstone() and ((buff.boneShield.stack() > 5 and runes() >= 2 and runicPower.deficit() >= 30 and not talent.shatteringBone
            or (talent.shatteringBone and buff.deathAndDecay.exists(units.dyn5))))
    then
        if cast.tombstone() then
            ui.debug("Casting Tombstone [Drw Up]")
            return true
        end
    end
    -- Death Strike
    -- death_strike,if=buff.coagulopathy.remains<=gcd|buff.icy_talons.remains<=gcd
    if cast.able.deathStrike() and ((buff.coagulopathy.remains() <= unit.gcd(true) or buff.icyTalons.remains() <= unit.gcd(true))) then
        if cast.deathStrike() then
            ui.debug("Casting Death Strike [Drw Up]")
            return true
        end
    end
    -- Marrowrend
    -- marrowrend,if=(buff.bone_shield.remains<=4|buff.bone_shield.stack<variable.bone_shield_refresh_value)&runic_power.deficit>20
    if cast.able.marrowrend() and (((buff.boneShield.remains() <= 4 or buff.boneShield.stack() < var.boneShieldRefreshValue) and runicPower.deficit() > 20)) then
        if cast.marrowrend() then
            ui.debug("Casting Marrowrend [Drw Up]")
            return true
        end
    end
    -- Soul Reaper
    -- soul_reaper,if=active_enemies=1&target.time_to_pct_35<5&target.time_to_die>(dot.soul_reaper.remains+5)
    if cast.able.soulReaper() and #enemies.yards5f == 1 and unit.ttd(units.dyn5, 35) < 5 and unit.ttd(units.dyn5) > (debuff.soulReaper.remains(units.dyn5) + 5) then
        if cast.soulReaper() then
            ui.debug("Casting Soul Reaper [Drw Up - ST]")
            return true
        end
    end
    -- Soul Reaper
    -- soul_reaper,target_if=min:dot.soul_reaper.remains,if=target.time_to_pct_35<5&active_enemies>=2&target.time_to_die>(dot.soul_reaper.remains+5)
    if cast.able.soulReaper(var.minSoulReaperUnit) and unit.ttd(units.dyn5, 35) < 5 and #enemies.yards5f >= 2 and unit.ttd(units.dyn5) > (debuff.soulReaper.remains(units.dyn5) + 5) then
        if cast.soulReaper(var.minSoulReaperUnit) then
            ui.debug("Casting Soul Reaper [Drw Up - AOE]")
            return true
        end
    end
    -- Death And Decay
    -- death_and_decay,if=!death_and_decay.ticking&(talent.sanguine_ground|talent.unholy_ground)
    if cast.able.deathAndDecay("target", "ground", 1, 8) and ((not buff.deathAndDecay.exists(units.dyn5) and (talent.sanguineGround or talent.unholyGround))) then
        if cast.deathAndDecay("target", "ground", 1, 8) then
            ui.debug("Casting Death And Decay [Drw Up]")
            return true
        end
    end
    -- Blood Boil
    -- blood_boil,if=spell_targets.blood_boil>2&charges_fractional>=1.1
    if cast.able.bloodBoil() and #enemies.yards5f > 2 and charges.bloodBoil.frac() >= 1.1 then
        if cast.bloodBoil() then
            ui.debug("Casting Blood Boil [Drw Up]")
            return true
        end
    end
    -- Variable - Heart Strike Rp Drw
    -- variable,name=heart_strike_rp_drw,value=(25+spell_targets.heart_strike*talent.heartbreaker.enabled*2)
    var.heartStrikeRpDrw = (25 + #enemies.yards5f * var.heartbreaker * 2)
    -- Death Strike
    -- death_strike,if=runic_power.deficit<=variable.heart_strike_rp_drw|runic_power>=variable.death_strike_dump_amount
    if cast.able.deathStrike() and ((runicPower.deficit() <= var.heartStrikeRpDrw or runicPower() >= var.deathStrikeDumpAmount)) then
        if cast.deathStrike() then
            ui.debug("Casting Death Strike [Drw Up]")
            return true
        end
    end
    -- Consumption
    -- consumption
    if cast.able.consumption() then
        if cast.consumption() then
            ui.debug("Casting Consumption [Drw Up]")
            return true
        end
    end
    -- Blood Boil
    -- blood_boil,if=charges_fractional>=1.1&buff.hemostasis.stack<5
    if cast.able.bloodBoil() and charges.bloodBoil.frac() >= 1.1 and buff.hemostasis.stack() < 5 then
        if cast.bloodBoil() then
            ui.debug("Casting Blood Boil [Drw Up]")
            return true
        end
    end
    -- Heart Strike
    -- heart_strike,if=runes.time_to_2<gcd|runic_power.deficit>=variable.heart_strike_rp_drw
    if cast.able.heartStrike() and ((runes.ttm(2) < unit.gcd(true) or runicPower.deficit() >= var.heartStrikeRpDrw)) then
        if cast.heartStrike() then
            ui.debug("Casting Heart Strike [Drw Up]")
            return true
        end
    end
end -- End Action List - DrwUp

-- Action List - Racials
actionList.Racials = function()
    -- Blood Fury
    -- blood_fury,if=cooldown.dancing_rune_weapon.ready&(!cooldown.blooddrinker.ready|!talent.blooddrinker.enabled)
    if unit.race() == "Orc" and cast.able.bloodFury() and ((not cd.dancingRuneWeapon.exists() and (not not cd.blooddrinker.exists() or not talent.blooddrinker))) then
        if cast.bloodFury() then
            ui.debug("Casting Blood Fury [Racials]")
            return true
        end
    end
    -- Berserking
    -- berserking
    if unit.race() == "Troll" and cast.able.berserking() then
        if cast.berserking() then
            ui.debug("Casting Berserking [Racials]")
            return true
        end
    end
    -- Arcane Pulse
    -- arcane_pulse,if=active_enemies>=2|runes<1&runic_power.deficit>60
    if unit.race() == "VoidElf" and cast.able.arcanePulse() and ((#enemies.yards5f >= 2 or runes() < 1 and runicPower.deficit() > 60)) then
        if cast.arcanePulse() then
            ui.debug("Casting Arcane Pulse [Racials]")
            return true
        end
    end
    -- Lights Judgment
    -- lights_judgment,if=buff.unholy_strength.up
    if unit.race() == "LightforgedDraenei" and cast.able.lightsJudgment() and buff.unholyStrength.exists() then
        if cast.lightsJudgment() then
            ui.debug("Casting Lights Judgment [Racials]")
            return true
        end
    end
    -- Ancestral Call
    -- ancestral_call
    if unit.race() == "MagharOrc" and cast.able.ancestralCall() then
        if cast.ancestralCall() then
            ui.debug("Casting Ancestral Call [Racials]")
            return true
        end
    end
    -- Fireblood
    -- fireblood
    if unit.race() == "DarkIronDwarf" and cast.able.fireblood() then
        if cast.fireblood() then
            ui.debug("Casting Fireblood [Racials]")
            return true
        end
    end
    -- Bag Of Tricks
    -- bag_of_tricks
    if unit.race() == "Vulpera" and cast.able.bagOfTricks() then
        if cast.bagOfTricks() then
            ui.debug("Casting Bag Of Tricks [Racials]")
            return true
        end
    end
    -- Arcane Torrent
    -- arcane_torrent,if=runic_power.deficit>20
    if unit.race() == "BloodElf" and cast.able.arcaneTorrent() and runicPower.deficit() > 20 then
        if cast.arcaneTorrent() then
            ui.debug("Casting Arcane Torrent [Racials]")
            return true
        end
    end
end -- End Action List - Racials

-- Action List - Standard
actionList.Standard = function()
    -- Tombstone
    -- tombstone,if=buff.bone_shield.stack>5&runes>=2&runic_power.deficit>=30&!talent.shattering_bone|(talent.shattering_bone.enabled&death_and_decay.ticking)&cooldown.dancing_rune_weapon.remains>=25
    if cast.able.tombstone() and ((buff.boneShield.stack() > 5 and runes >= 2 and runicPower.deficit() >= 30
            and not talent.shatteringBone or (talent.shatteringBone and buff.deathAndDecay.exists(units.dyn5)) and cd.dancingRuneWeapon.remains() >= 25))
    then
        if cast.tombstone() then
            ui.debug("Casting Tombstone [Standard]")
            return true
        end
    end
    -- Variable - Heart Strike Rp
    -- variable,name=heart_strike_rp,value=(10+spell_targets.heart_strike*talent.heartbreaker.enabled*2)
    var.heartStrikeRp = (10 + #enemies.yards5f * var.heartbreaker * 2)
    -- Death Strike
    -- death_strike,if=buff.coagulopathy.remains<=gcd|buff.icy_talons.remains<=gcd|runic_power>=variable.death_strike_dump_amount|runic_power.deficit<=variable.heart_strike_rp|target.time_to_die<10
    if cast.able.deathStrike() and ((buff.coagulopathy.remains() <= unit.gcd(true) or buff.icyTalons.remains() <= unit.gcd(true)
            or runicPower() >= var.deathStrikeDumpAmount or runicPower.deficit() <= var.heartStrikeRp or unit.ttd(unit.dyn5) < 10))
    then
        if cast.deathStrike() then
            ui.debug("Casting Death Strike [Standard]")
            return true
        end
    end
    -- Deaths Caress
    -- deaths_caress,if=(buff.bone_shield.remains<=4|(buff.bone_shield.stack<variable.bone_shield_refresh_value+1))&runic_power.deficit>10&!(talent.insatiable_blade&cooldown.dancing_rune_weapon.remains<buff.bone_shield.remains)&!talent.consumption.enabled&!talent.blooddrinker.enabled&runes.time_to_3>gcd
    if cast.able.deathsCaress() and (((buff.boneShield.remains() <= 4 or (buff.boneShield.stack() < var.boneShieldRefreshValue + 1))
            and runicPower.deficit() > 10 and not (talent.insatiableBlade and cd.dancingRuneWeapon.remains() < buff.boneShield.remains())
            and not talent.consumption and not talent.blooddrinker and runes.ttm(3) > unit.gcd(true)))
    then
        if cast.deathsCaress() then
            ui.debug("Casting Deaths Caress [Standard]")
            return true
        end
    end
    -- Marrowrend
    -- marrowrend,if=(buff.bone_shield.remains<=4|buff.bone_shield.stack<variable.bone_shield_refresh_value)&runic_power.deficit>20&!(talent.insatiable_blade&cooldown.dancing_rune_weapon.remains<buff.bone_shield.remains)
    if cast.able.marrowrend() and (((buff.boneShield.remains() <= 4 or buff.boneShield.stack() < var.boneShieldRefreshValue)
            and runicPower.deficit() > 20 and not (talent.insatiableBlade and cd.dancingRuneWeapon.remains() < buff.boneShield.remains())))
    then
        if cast.marrowrend() then
            ui.debug("Casting Marrowrend [Standard]")
            return true
        end
    end
    -- Consumption
    -- consumption
    if cast.able.consumption() then
        if cast.consumption() then
            ui.debug("Casting Consumption [Standard]")
            return true
        end
    end
    -- Soul Reaper
    -- soul_reaper,if=active_enemies=1&target.time_to_pct_35<5&target.time_to_die>(dot.soul_reaper.remains+5)
    if cast.able.soulReaper() and #enemies.yards5f == 1 and unit.ttd(units.dyn5, 35) < 5 and unit.ttd(units.dyn5) > (debuff.soulReaper.remains(units.dyn5) + 5) then
        if cast.soulReaper() then
            ui.debug("Casting Soul Reaper [Standard - ST]")
            return true
        end
    end
    -- Soul Reaper
    -- soul_reaper,target_if=min:dot.soul_reaper.remains,if=target.time_to_pct_35<5&active_enemies>=2&target.time_to_die>(dot.soul_reaper.remains+5)
    if cast.able.soulReaper(var.minSoulReaperUnit) and unit.ttd(units.dyn5, 35) < 5 and #enemies.yards5f >= 2 and unit.ttd(units.dyn5) > (debuff.soulReaper.remains(units.dyn5) + 5) then
        if cast.soulReaper(var.minSoulReaperUnit) then
            ui.debug("Casting Soul Reaper [Standard - AOE]")
            return true
        end
    end
    -- Bonestorm
    -- bonestorm,if=buff.bone_shield.stack>=5
    if cast.able.bonestorm() and buff.boneShield.stack() >= 5 then
        if cast.bonestorm() then
            ui.debug("Casting Bonestorm [Standard]")
            return true
        end
    end
    -- Blood Boil
    -- blood_boil,if=charges_fractional>=1.8&(buff.hemostasis.stack<=(5-spell_targets.blood_boil)|spell_targets.blood_boil>2)
    if cast.able.bloodBoil() and ((charges.bloodBoil.frac() >= 1.8 and (buff.hemostasis.stack() <= (5 - #enemies.yards5f) or #enemies.yards5f > 2))) then
        if cast.bloodBoil() then
            ui.debug("Casting Blood Boil [Standard]")
            return true
        end
    end
    -- Heart Strike
    -- heart_strike,if=runes.time_to_4<gcd
    if cast.able.heartStrike() and runes.ttm(4) < unit.gcd(true) then
        if cast.heartStrike() then
            ui.debug("Casting Heart Strike [Standard]")
            return true
        end
    end
    -- Blood Boil
    -- blood_boil,if=charges_fractional>=1.1
    if cast.able.bloodBoil() and charges.bloodBoil.frac() >= 1.1 then
        if cast.bloodBoil() then
            ui.debug("Casting Blood Boil [Standard]")
            return true
        end
    end
    -- Heart Strike
    -- heart_strike,if=(runes>1&(runes.time_to_3<gcd|buff.bone_shield.stack>7))
    if cast.able.heartStrike() and (((runes() > 1 and (runes.ttm(3) < unit.gcd(true) or buff.boneShield.stack() > 7)))) then
        if cast.heartStrike() then
            ui.debug("Casting Heart Strike [Standard]")
            return true
        end
    end
end -- End Action List - Standard

-- Action List - Trinkets
actionList.Trinkets = function()
    -- Use Item - Fyralath The Dreamrender
    -- use_item,name=fyralath_the_dreamrender,if=dot.mark_of_fyralath.ticking
    -- TODO

    -- Use Item - Use Off Gcd=1
    -- use_item,use_off_gcd=1,slot=trinket1,if=!variable.trinket_1_buffs&(variable.damage_trinket_priority=1|trinket.2.cooldown.remains|!trinket.2.has_cooldown)
    -- TODO

    -- Use Item - Use Off Gcd=1
    -- use_item,use_off_gcd=1,slot=trinket2,if=!variable.trinket_2_buffs&(variable.damage_trinket_priority=2|trinket.1.cooldown.remains|!trinket.1.has_cooldown)
    -- TODO

    -- Use Item - Use Off Gcd=1
    -- use_item,use_off_gcd=1,slot=main_hand,if=!equipped.fyralath_the_dreamrender&(variable.trinket_1_buffs|trinket.1.cooldown.remains)&(variable.trinket_2_buffs|trinket.2.cooldown.remains)
    -- TODO

    -- Use Item - Use Off Gcd=1
    -- use_item,use_off_gcd=1,slot=trinket1,if=variable.trinket_1_buffs&(buff.dancing_rune_weapon.up|!talent.dancing_rune_weapon|cooldown.dancing_rune_weapon.remains>20)&(variable.trinket_2_exclude|trinket.2.cooldown.remains|!trinket.2.has_cooldown|variable.trinket_2_buffs)
    -- TODO

    -- Use Item - Use Off Gcd=1
    -- use_item,use_off_gcd=1,slot=trinket2,if=variable.trinket_2_buffs&(buff.dancing_rune_weapon.up|!talent.dancing_rune_weapon|cooldown.dancing_rune_weapon.remains>20)&(variable.trinket_1_exclude|trinket.1.cooldown.remains|!trinket.1.has_cooldown|variable.trinket_1_buffs)
    -- TODO
end -- End Action List - Trinkets

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff            = br.player.buff
    cast            = br.player.cast
    cd              = br.player.cd
    charges         = br.player.charges
    debuff          = br.player.debuff
    enemies         = br.player.enemies
    module          = br.player.module
    pet             = br.player.pet
    runes           = br.player.power.runes
    runicPower      = br.player.power.runicPower
    talent          = br.player.talent
    ui              = br.player.ui
    unit            = br.player.unit
    units           = br.player.units
    -- General Locals
    var.haltProfile = (unit.inCombat() and var.profileStop) or unit.mounted() or br.pause() or ui.mode.rotation == 2
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40)
    -- Enemies
    enemies.get(5, "player", false, true)
    enemies.get(8)
    enemies.get(15)
    enemies.get(30)

    -- General Variables
    var.heartbreaker = talent.heartbreaker and 1 or 0

    -- Target Variables
    -- target_if=min:dot.soul_reaper.remains
    var.minSoulReaper = 99999
    var.minSoulReaperUnit = "target"
    for i = 1, #enemies.yards5f do
        local thisUnit = enemies.yards5f[i]
        local thisCondition = debuff.soulReaper.remains(thisUnit)
        if thisCondition < var.minSoulReaper then
            var.minSoulReaper = thisCondition
            var.minSoulReaperUnit = thisUnit
        end
    end

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
        -----------------
        --- Interrupt ---
        -----------------
        if actionList.Interrupts() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if actionList.Combat() then return true end
    end -- Pause
end     -- End runRotation
local id = 250
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
