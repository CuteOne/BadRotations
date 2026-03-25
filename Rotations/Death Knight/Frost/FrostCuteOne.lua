local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spells.howlingBlast },
        [2] = { mode = "Mult", value = 2, overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spells.howlingBlast },
        [3] = { mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spells.frostStrike },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disarm DPS Rotation", highlight = 0, icon = br.player.spells.deathStrike }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.empowerRuneWeapon },
        [2] = { mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spells.empowerRuneWeapon },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.empowerRuneWeapon }
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.iceboundFortitude },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.iceboundFortitude }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupt Enabled", tip = "Enabled Interrupt", highlight = 1, icon = br.player.spells.mindFreeze },
        [2] = { mode = "Off", value = 2, overlay = "Interrupt Disabled", tip = "Disable Interrupt", highlight = 0, icon = br.player.spells.mindFreeze }
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
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
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5,
            "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Death Grip
        br.ui:createCheckbox(section, "Death Grip")
        -- Horn of Winter
        br.ui:createCheckbox(section, "Horn of Winter")
        -- Lichborne: allow breaking CC and enable self-heal via Death Coil
        br.ui:createCheckbox(section, "Lichborne")
        br.ui:createSpinnerWithout(section, "Lichborne Heal At", 35, 0, 95, 5,
            "|cffFFFFFFHealth percent to cast Lichborne+Death Coil on yourself")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        local alwaysCdNever = { "Always", "|cff0000ffCD", "|cffff0000Never" }
        local alwaysCdAoENever = { "Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never" }
        -- Army of the Dead
        br.ui:createDropdownWithout(section, "Army of the Dead", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Army of the Dead.")
        -- Empower Rune Weapon
        br.ui:createDropdownWithout(section, "Empower Rune Weapon", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Empower Rune Weapon.")
        -- Pillar of Frost
        br.ui:createDropdownWithout(section, "Pillar of Frost", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Pillar of Frost.")
        -- Raise Dead
        br.ui:createDropdownWithout(section, "Raise Dead", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Raise Dead.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Death Strike
        br.ui:createSpinner(section, "Death Strike", 50, 0, 95, 5,
            "|cffFFFFFFHealth Percent to Cast At")
        -- Death Pact
        br.ui:createSpinner(section, "Death Pact", 30, 0, 95, 5,
            "|cffFFFFFFHealth Percent to Cast Death Pact At")
        -- Raise Dead to enable Death Pact
        br.ui:createSpinner(section, "Death Pact Raise Dead", 30, 0, 95, 5,
            "|cffFFFFFFHealth Percent to Cast Raise Dead and Death Pact At")
        -- Icebound Fortitude
        br.ui:createSpinner(section, "Icebound Fortitude", 40, 0, 95, 5,
            "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupt")
        -- Death Grip (Interrupt)
        br.ui:createCheckbox(section, "Death Grip (Interrupt)")
        -- Mind Freeze
        br.ui:createCheckbox(section, "Mind Freeze")
        -- Strangulate
        br.ui:createCheckbox(section, "Strangulate")
        -- "Interrupt At"
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5,
            "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.ui.dropOptions.Toggle, 4)
        -- Cooldown Key Toggle
        br.ui:createDropdownWithout(section, "Cooldown Mode", br.ui.dropOptions.Toggle, 3)
        -- Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.ui.dropOptions.Toggle, 6)
        -- Interrupt Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.ui.dropOptions.Toggle, 6)
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
local debuff
local enemies
local module
local runes
local runicPower
local ui
local unit
local units
local spell
local talent
local use
local var
-- Profile Specific Locals
local actionList = {}

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- * Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing")) * 60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
end -- End Action List - Extra
-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- * Death Pact: try to use if available, otherwise optionally raise ghoul to enable
        if ui.checked("Death Pact") then
            -- If Death Pact is available, use it
            if cast.able.deathPact() and GetTime() < var.raiseDeadExpiresAt
                and unit.hp("player") <= ui.value("Death Pact")
            then
                if cast.deathPact() then
                    ui.debug("Casting Death Pact [Defensive]")
                    return true
                end
            end
            -- If not available, optionally raise ghoul to enable Death Pact
            if ui.checked("Death Pact Raise Dead") and cast.able.raiseDead()
                and unit.hp("player") <= ui.value("Death Pact Raise Dead")
            then
                if cast.raiseDead() then
                    ui.debug("Casting Raise Dead - to enable Death Pact [Defensive]")
                    var.raiseDeadExpiresAt = GetTime() + 60
                    return true
                end
            end
        end
        -- * Death Strike (Dark Succor)
        if ui.checked("Death Strike") and unit.inCombat() and buff.darkSuccor.exists() then
            for i = 1, #enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if buff.darkSuccor.exists()
                    and (buff.darkSuccor.remain() < unit.gcd(true) or unit.ttd(thisUnit) < unit.gcd(true) or unit.hp("player") <= 80)
                then
                    if buff.darkSuccor.exists() and cast.able.deathStrike(thisUnit) then
                        if cast.deathStrike(thisUnit) then
                            ui.debug("Casting Death Strike - Dark Succor [Defensive]")
                            return true
                        end
                    end
                end
            end
        end
        -- * Death Strike
        if ui.checked("Death Strike") and cast.able.deathStrike() then
            if unit.hp("player") <= tonumber(ui.value("Death Strike")) and runes.frost() > 0 and runes.unholy() > 0 then
                if cast.deathStrike() then
                    ui.debug("Casting Death Strike [Defensive]")
                    return true
                end
            end
        end
        -- * Icebound Fortitude
        if ui.checked("Icebound Fortitude") and cast.able.iceboundFortitude() and not unit.inCombat() then
            if unit.hp("player") <= tonumber(ui.value("Icebound Fortitude")) then
                if cast.iceboundFortitude() then
                    ui.debug("Casting Icebound Fortitude [Defensive]")
                    return true
                end
            end
        end
        -- * Lichborne: break CC or enable self-heal via Death Coil
        if ui.checked("Lichborne") and talent.lichborne then
            -- Break CC: Charm / Fear / Sleep
            if cast.able.lichborne() and cast.noControl.lichborne() then
                if cast.lichborne() then
                    ui.debug("Casting Lichborne - Break CC [Defensive]")
                    return true
                end
            end
            -- Self-heal: if lichborne buff present, cast Death Coil on player
            if buff.lichborne.exists() then
                if cast.able.deathCoil("player") and unit.hp("player") <= tonumber(ui.value("Lichborne Heal At")) then
                    if cast.deathCoil("player") then
                        ui.debug("Casting Death Coil -> Heal Self (via Lichborne) [Defensive]")
                        return true
                    end
                end
            else
                -- If low health and Lichborne is available, cast it to enable the heal next tick
                if cast.able.lichborne() and unit.hp("player") <= tonumber(ui.value("Lichborne Heal At")) then
                    if cast.lichborne() then
                        ui.debug("Casting Lichborne - Prepare Self-Heal [Defensive]")
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) and unit.distance(thisUnit) > 8 then
                -- * Strangulate
                if ui.checked("Strangulate") and cast.able.strangulate(thisUnit) and runes.blood() > 0 then
                    if cast.strangulate(thisUnit) then
                        ui.debug("Casting Strangulate [Int]")
                        return true
                    end
                end
                -- * Death Grip
                if ui.checked("Death Grip (Interrupt)") and cast.able.deathGrip()
                    and (not spell.strangulate.known() or (cd.strangulate.remains() > 0 and cd.strangulate.remains() < 55))
                then
                    if cast.deathGrip(thisUnit) then
                        ui.debug("Casting Death Grip [Int]")
                        return true
                    end
                end
            end
        end
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                -- * Mind Freeze
                if ui.checked("Mind Freeze") and cast.able.mindFreeze(thisUnit) then
                    if cast.mindFreeze(thisUnit) then
                        ui.debug("Casting Mind Freeze [Int]")
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - Interrupts

-- Action List - AOE
actionList.AOE = function()
    -- * Unholy Blight
    -- unholy_blight,if=talent.unholy_blight.enabled
    if talent.unholyBlight and cast.able.unholyBlight(nil,"aoe",1,8) then
        if cast.unholyBlight(nil,"aoe",1,8) then ui.debug("Casting Unholy Blight [AOE]") return true end
    end
    -- * Pestilence (spread plague if blood_plague ticking and talent)
    -- pestilence,if=dot.blood_plague.ticking&talent.plague_leech.enabled,line_cd=28
    if talent.plagueLeech and cast.able.pestilence() and debuff.bloodPlague.exists(units.dyn5) and debuff.frostFever.exists(units.dyn5)
        and ui.delay("pestilenceLineCD",28)
    then
        if cast.pestilence() then ui.debug("Casting Pestilence - Plague Leech [AOE]") return true end
    end
    -- pestilence,if=dot.blood_plague.ticking&talent.unholy_blight.enabled&cooldown.unholy_blight.remains<49,line_cd=28
    if talent.unholyBlight and cast.able.pestilence() and debuff.bloodPlague.exists(units.dyn5) and debuff.frostFever.exists(units.dyn5)
        and cd.unholyBlight.remains() < 49 and ui.delay("pestilenceLineCD2",28)
    then
        if cast.pestilence() then ui.debug("Casting Pestilence - Unholy Blight [AOE]") return true end
    end
    -- * Howling Blast
    -- howling_blast
    if (ui.mode.rotation == 3 or not cast.safe.howlingBlast(units.dyn5,"targetAOE",1,10)) and cast.able.icyTouch(units.dyn5) then
        if cast.icyTouch(units.dyn5) then ui.debug("Casting Icy Touch [AOE]") return true end
    elseif cast.able.howlingBlast(units.dyn5,"targetAOE",1,10) then
        if cast.howlingBlast(units.dyn5,"targetAOE",1,10) then ui.debug("Casting Howling Blast [AOE]") return true end
    end
    -- * Blood Tap
    -- blood_tap,if=talent.blood_tap.enabled&buff.blood_charge.stack>1
    if talent.bloodTap and cast.able.bloodTap() and buff.bloodCharge.stack() > 4 and runes() < 5 then
        if cast.bloodTap() then ui.debug("Casting Blood Tap - Blood Charges [AOE]") return true end
    end
    -- * Frost Strike when RP high
    -- frost_strike,if=runic_power>76
    if cast.able.frostStrike() and runicPower() > 76 then
        if cast.frostStrike() then ui.debug("Casting Frost Strike - High RP [AOE]") return true end
    end
    -- * Death and Decay
    -- death_and_decay,if=unholy=1
    if cast.able.deathAndDecay("best",nil,1,8) and runes.unholy() == 1 then
        if cast.deathAndDecay("best",nil,1,8) then ui.debug("Casting Death and Decay [AOE]") return true end
    end
    -- * Plague Strike
    -- plague_strike,if=unholy=2
    if cast.able.plagueStrike() and runes.unholy() == 2 then
        if cast.plagueStrike() then ui.debug("Casting Plague Strike - 2 Ungoly Runes [AOE]") return true end
    end
    -- * Blood Tap
    -- blood_tap,if=talent.blood_tap.enabled
    if talent.bloodTap and cast.able.bloodTap() and buff.bloodCharge.stack() > 4 and runes() < 5 then
        if cast.bloodTap() then ui.debug("Casting Blood Tap [AOE]") return true end
    end
    -- * Frost Strike
    -- frost_strike
    if cast.able.frostStrike() then
        if cast.frostStrike() then ui.debug("Casting Frost Strike [AOE]") return true end
    end
    -- * Horn of Winter
    -- horn_of_winter
    if ui.checked("Horn of Winter") and cast.able.hornOfWinter() then
        if cast.hornOfWinter() then ui.debug("Casting Horn of Winter [AOE]") return true end
    end
    -- * Plague Leech
    -- plague_leech,if=talent.plague_leech.enabled&unholy=1
    if talent.plagueLeech and runes() < 5 and runes.unholy() == 1 then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if cast.able.plagueLeech(thisUnit) and debuff.bloodPlague.exists(thisUnit) and debuff.frostFever.exists(thisUnit) then
                if cast.plagueLeech(thisUnit) then ui.debug("Casting Plague Leech [AOE]") return true end
            end
        end
    end
    -- * Plague Strike
    -- plague_strike,if=unholy=1
    if cast.able.plagueStrike() and runes.unholy() == 1 then
        if cast.plagueStrike() then ui.debug("Casting Plague Strike - 1 Unholy Rune [AOE]") return true end
    end
    -- * Empower Rune Weapon
    -- empower_rune_weapon
    if ui.alwaysCdAoENever("Empower Rune Weapon",3,#enemies.yards8) and cast.able.empowerRuneWeapon()
        and runes() == 0 and runicPower() <= 75
    then
        if cast.empowerRuneWeapon() then ui.debug("Casting Empower Rune Weapon [AOE]") return true end
    end
end -- End Action List - AOE

-- Action List - Single Target
actionList.SingleTarget = function()
    -- * Blood Tap: use to convert charges when stacks high and RP conditions met
    -- blood_tap,if=talent.blood_tap.enabled&(buff.blood_charge.stack>10&(runic_power>76|(runic_power>=20&buff.killing_machine.react)))
    if talent.bloodTap and cast.able.bloodTap() and buff.bloodCharge.stack() > 10 and runes() < 5
        and (runicPower() > 76 or (runicPower() >= 20 and buff.killingMachine.exists()))
    then
        if cast.bloodTap() then ui.debug("Casting Blood Tap - Killing Machine | High RP [Single]") return true end
    end
    -- * Frost Strike on Killing Machine or very high RP
    -- frost_strike,if=buff.killing_machine.react|runic_power>88
    if cast.able.frostStrike() and (buff.killingMachine.exists() or runicPower() > 88) then
        if cast.frostStrike() then ui.debug("Casting Frost Strike - Killing Machine | High RP [Single]") return true end
    end
    -- * Howling Blast: apply Frost Fever if missing or use on rime proc
    -- howling_blast,if=death>1|frost>1
    if (runes.death() > 1 or runes.frost() > 1) then
        if (ui.mode.rotation == 3 or not cast.safe.howlingBlast(units.dyn5,"targetAOE",1,10)) and cast.able.icyTouch(units.dyn5) then
            if cast.icyTouch(units.dyn5) then ui.debug("Casting Icy Touch - Multiple Death or Frost Runes [Single]") return true end
        elseif cast.able.howlingBlast(units.dyn5,"targetAOE",1,10) then
            if cast.howlingBlast(units.dyn5,"targetAOE",1,10) then ui.debug("Casting Howling Blast - Multiple Death or Frost Runes [Single]") return true end
        end
    end
    -- * Unholy Blight
    -- unholy_blight,if=talent.unholy_blight.enabled&((dot.frost_fever.remains<3|dot.blood_plague.remains<3))
    if talent.unholyBlight and cast.able.unholyBlight() and
        (debuff.frostFever.remains(units.dyn5) < 3 or debuff.bloodPlague.remains(units.dyn5) < 3)
    then
        if cast.unholyBlight() then ui.debug("Casting Unholy Blight [Single]") return true end
    end
    -- * Soul Reaper (execute range) - translate simc expression safely
    -- soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=45
    if cast.able.soulReaper() and (unit.hp(units.dyn5) - 3 * (unit.hp(units.dyn5) / unit.ttd(units.dyn5))) <= 45 then
        if cast.soulReaper() then ui.debug("Casting Soul Reaper [Single]") return true end
    end
    -- * Blood Tap
    -- blood_tap,if=talent.blood_tap.enabled&((target.health.pct-3*(target.health.pct%target.time_to_die)<=45&cooldown.soul_reaper.remains=0))
    if talent.bloodTap and cast.able.bloodTap() and buff.bloodCharge.stack() > 4 and runes() < 5
        and ((unit.hp(units.dyn5) - 3 * (unit.hp(units.dyn5) / unit.ttd(units.dyn5))) <= 45 and cd.soulReaper.remains() == 0)
    then
        if cast.bloodTap() then ui.debug("Casting Blood Tap - Soul Reaper Available [Single]") return true end
    end
    -- * Howling Blast
    -- howling_blast,if=!dot.frost_fever.ticking
    if not debuff.frostFever.exists(units.dyn5) then
        if (ui.mode.rotation == 3 or not cast.safe.howlingBlast(units.dyn5,"targetAOE",1,10)) and cast.able.icyTouch(units.dyn5) then
            if cast.icyTouch(units.dyn5) then ui.debug("Casting Icy Touch - No Frost Fever [Single]") return true end
        elseif cast.able.howlingBlast(units.dyn5,"targetAOE",1,10) then
            if cast.howlingBlast(units.dyn5,"targetAOE",1,10) then ui.debug("Casting Howling Blast - No Frost Fever [Single]") return true end
        end
    end
    -- * Plague Strike: apply Blood Plague if missing (unholy presence handled elsewhere)
    -- plague_strike,if=!dot.blood_plague.ticking&unholy>0
    if cast.able.plagueStrike() and not debuff.bloodPlague.exists(units.dyn5) and runes.unholy() > 0 then
        if cast.plagueStrike() then ui.debug("Casting Plague Strike [Single]") return true end
    end
    -- * Howling Blast
    -- howling_blast,if=buff.rime.react
    if buff.rime.exists() then
        if (ui.mode.rotation == 3 or not cast.safe.howlingBlast(units.dyn5,"targetAOE",1,10)) and cast.able.icyTouch(units.dyn5) then
            if cast.icyTouch(units.dyn5) then ui.debug("Casting Icy Touch - Rime Proc [Single]") return true end
        elseif cast.able.howlingBlast(units.dyn5,"targetAOE",1,10) then
            if cast.howlingBlast(units.dyn5,"targetAOE",1,10) then ui.debug("Casting Howling Blast - Rime Proc [Single]") return true end
        end
    end
    -- * Frost Strike
    -- frost_strike,if=runic_power>76
    if cast.able.frostStrike() and runicPower() > 76 then
        if cast.frostStrike() then ui.debug("Casting Frost Strike - High RP [Single]") return true end
    end
    -- * Obliterate
    -- obliterate,if=unholy>0&!buff.killing_machine.react
    if cast.able.obliterate() and runes.unholy() > 0 and not buff.killingMachine.exists() then
        if cast.obliterate() then ui.debug("Casting Obliterate [Single]") return true end
    end
    -- * Howling Blast / Icy Touch
    -- howling_blast
    if (ui.mode.rotation == 3 or not cast.safe.howlingBlast(units.dyn5,"targetAOE",1,10)) and cast.able.icyTouch(units.dyn5) then
        if cast.icyTouch(units.dyn5) then ui.debug("Casting Icy Touch [Single]") return true end
    elseif cast.able.howlingBlast(units.dyn5,"targetAOE",1,10) then
        if cast.howlingBlast(units.dyn5,"targetAOE",1,10) then ui.debug("Casting Howling Blast [Single]") return true end
    end
    -- * Frost Strike
    -- frost_strike,if=talent.runic_empowerment.enabled&unholy=1
    if talent.runicEmpowerment and cast.able.frostStrike() and runes.unholy() == 1 then
        if cast.frostStrike() then ui.debug("Casting Frost Strike - Runic Empowerment Single Unholy Rune [Single]") return true end
    end
    -- * Blood Tap
    -- blood_tap,if=talent.blood_tap.enabled&(target.health.pct-3*(target.health.pct%target.time_to_die)>35|buff.blood_charge.stack>=8)
    if talent.bloodTap and cast.able.bloodTap() and buff.bloodCharge.stack() > 4 and runes() < 5
        and ((unit.hp(units.dyn5) - 3 * (unit.hp(units.dyn5) / unit.ttd(units.dyn5))) > 35 or buff.bloodCharge.stack() >= 8)
    then
        if cast.bloodTap() then ui.debug("Casting Blood Tap - Execute | High Blood Charges [Single]") return true end
    end
    -- * Frost Strike
    -- frost_strike,if=runic_power>=40
    if cast.able.frostStrike() and runicPower() >= 40 then
        if cast.frostStrike() then ui.debug("Casting Frost Strike [Single]") return true end
    end
    -- * Horn of Winter
    -- horn_of_winter
    if ui.checked("Horn of Winter") and cast.able.hornOfWinter() then
        if cast.hornOfWinter() then ui.debug("Casting Horn of Winter [Single]") return true end
    end
    -- * Blood Tap
    -- blood_tap,if=talent.blood_tap.enabled
    if talent.bloodTap and cast.able.bloodTap() and buff.bloodCharge.stack() > 4 and runes() < 5 then
        if cast.bloodTap() then ui.debug("Casting Blood Tap [Single]") return true end
    end
    -- * Plague Leech: consume diseases to generate Runic Power when diseases are present and RP is not high
    -- plague_leech,if=talent.plague_leech.enabled
    if talent.plagueLeech and runes() < 5 then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if cast.able.plagueLeech(thisUnit) and debuff.bloodPlague.exists(thisUnit) and debuff.frostFever.exists(thisUnit) then
                if cast.plagueLeech(thisUnit) then ui.debug("Casting Plague Leech [Single]") return true end
            end
        end
    end
    -- * Empower Rune Weapon
    -- empower_rune_weapon
    if ui.alwaysCdAoENever("Empower Rune Weapon",3,#enemies.yards8) and cast.able.empowerRuneWeapon()
        and runes() == 0 and runicPower() <= 75
    then
        if cast.empowerRuneWeapon() then ui.debug("Casting Empower Rune Weapon [Single]") return true end
    end
end -- End Action List - Single Target

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then
        -- * Flask
        -- flask,type=winters_bite
        -- * Food
        -- food,type=black_pepper_ribs_and_shrimp
        if unit.valid("target") then
            -- * Horn of Winter
            -- horn_of_winter
            if ui.checked("Horn of Winter") and cast.able.hornOfWinter() and unit.distance("target") < 8 then
                if cast.hornOfWinter() then ui.debug("Casting Horn of Winter [Precombat]") return true end
            end
            -- * Frost Presence
            -- frost_presence
            if cast.able.frostPresence() and not buff.frostPresence.exists() then
                if cast.frostPresence() then ui.debug("Casting Frost Presence [Precombat]") return true end
            end
            -- * Army of the Dead
            -- army_of_the_dead
            if ui.alwaysCdAoENever("Army of the Dead",3,#enemies.yards8) and cast.able.armyOfTheDead() then
                if cast.armyOfTheDead() then ui.debug("Casting Army of the Dead [Precombat]") return true end
            end
            -- * Potion
            -- mogu_power_potion
            if module and module.CombatPotionUp then
                module.CombatPotionUp()
            end
            -- * Pillar of Frost
            -- pillar_of_frost
            if ui.alwaysCdAoENever("Pillar of Frost",3,#enemies.yards8) and cast.able.pillarOfFrost() then
                if cast.pillarOfFrost() then
                    ui.debug("Casting Pillar of Frost [Precombat]")
                    return true
                end
            end
            -- * Raise Dead
            -- raise_dead
            if ui.alwaysCdAoENever("Raise Dead",3,#enemies.yards8) and cast.able.raiseDead() then
                if cast.raiseDead() then
                    ui.debug("Casting Raise Dead [Precombat]")
                    var.raiseDeadExpiresAt = GetTime() + 60
                    return true
                end
            end
            -- * Death Grip
            if ui.checked("Death Grip") and cast.able.deathGrip("target") and not unit.isDummy("target")
                and unit.distance("target") > 8 and unit.distance("target") < 30
                and (not unit.moving("target") or (unit.moving("target") and not unit.facing("target", "player")))
            then
                if cast.deathGrip("target") then
                    ui.debug("Casting Death Grip [Precombat]")
                    return true
                end
            end
            -- * Howling Blast / Icy Touch
            if (ui.mode.rotation == 3 or not cast.safe.howlingBlast("target","targetAOE",1,10)) and cast.able.icyTouch("target") then
                if cast.icyTouch("target") then ui.debug("Casting Icy Touch [Precombat]") return true end
            elseif cast.able.howlingBlast("target","targetAOE",1,10) then
                if cast.howlingBlast("target","targetAOE",1,10) then ui.debug("Casting Howling Blast [Precombat]") return true end
            end
            -- * Start Attack
            -- actions=auto_attack
            if cast.able.autoAttack("target") and unit.distance("target") < 5 then
                if cast.autoAttack("target") then
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
    if unit.inCombat() and unit.valid("target") and not var.profileStop then
        -- * Start Attack
        -- actions=auto_attack
        if cast.able.autoAttack(units.dyn5) and unit.distance(units.dyn5) < 5 then
            if cast.autoAttack(units.dyn5) then
                ui.debug("Casting Auto Attack [Combat]")
                return true
            end
        end
        -- * Death Grip
        if ui.checked("Death Grip") and cast.able.deathGrip("target") and not unit.isDummy("target")
            and unit.distance("target") > 8 and unit.distance("target") < 30
            and (not unit.moving("target") or (unit.moving("target") and not unit.facing("target", "player")))
        then
            if cast.deathGrip("target") then
                ui.debug("Casting Death Grip [Combat]")
                return true
            end
        end
        -- -- Cooldowns / Utility
        -- -- * Anti-Magic Shell
        -- -- antimagic_shell,damage=100000
        -- if cast.able.antiMagicShell() then
        --     if cast.antiMagicShell() then ui.debug("Casting Anti-Magic Shell") return true end
        -- end
        -- * Pillar of Frost
        -- pillar_of_frost
        if ui.alwaysCdAoENever("Pillar of Frost",3,#enemies.yards8) and cast.able.pillarOfFrost() then
            if cast.pillarOfFrost() then ui.debug("Casting Pillar of Frost [Combat]") return true end
        end
        -- -- * Combat Potion usage
        -- -- mogu_power_potion,if=target.time_to_die<=30|(target.time_to_die<=60&buff.pillar_of_frost.up)
        -- if module and module.CombatPotionUp and unit.ttd and unit.ttd(units.dyn5) then
        --     if unit.ttd(units.dyn5) <= 30 or (unit.ttd(units.dyn5) <= 60 and buff and buff.pillarOfFrost and buff.pillarOfFrost.exists()) then
        --         module.CombatPotionUp()
        --     end
        -- end
        -- * Empower Rune Weapon
        -- empower_rune_weapon,if=target.time_to_die<=60&(buff.mogu_power_potion.up|buff.golemblood_potion.up)
        if ui.alwaysCdAoENever("Empower Rune Weapon", 3, #enemies.yards5f) and cast.able.empowerRuneWeapon()
            and runes() == 0 and runicPower() <= 75 and unit.ttd(units.dyn5) <= 60
        then
            if cast.empowerRuneWeapon() then ui.debug("Casting Empower Rune Weapon [Combat]") return true end
        end
        -- * Racials
        -- if br.player and br.player.race then
        --     if br.player.race == "Orc" and cast.able.bloodFury() then
        --         if cast.bloodFury() then ui.debug("Casting Blood Fury") return true end
        --     end
        --     if br.player.race == "Troll" and cast.able.berserking() then
        --         if cast.berserking() then ui.debug("Casting Berserking") return true end
        --     end
        --     if br.player.race == "BloodElf" and cast.able.arcaneTorrent() then
        --         if cast.arcaneTorrent() then ui.debug("Casting Arcane Torrent") return true end
        --     end
        -- end
        -- * Raise Dead
        -- raise_dead
        if ui.alwaysCdAoENever("Raise Dead", 3, #enemies.yards8) and cast.able.raiseDead() then
            if cast.raiseDead() then
                ui.debug("Casting Raise Dead [Combat]")
                var.raiseDeadExpiresAt = GetTime() + 60
                return true
            end
        end
        -- * Run Action List: AOE
        -- run_action_list,name=aoe,if=active_enemies>=3
        if ui.useAOE(8,3) then
            if actionList.AOE() then return true end
        end
        -- * Run Action List: Single Target
        -- run_action_list,name=single_target,if=active_enemies<3
        if ui.useST(8,3) then
            if actionList.SingleTarget() then return true end
        end
    end -- End In Combat Rotation
end -- End Action List - Combat

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
    debuff          = br.player.debuff
    enemies         = br.player.enemies
    module          = br.player.module
    runes           = br.player.power.runes
    runicPower      = br.player.power.runicPower
    spell           = br.player.spell
    talent          = br.player.talent
    ui              = br.player.ui
    unit            = br.player.unit
    units           = br.player.units
    use             = br.player.use
    var             = br.player.variables

    -- General Locals
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(30) -- Makes a variable called, units.dyn30
    units.get(40)
    -- Enemies
    enemies.get(5)  -- makes enemies.yards5
    enemies.get(5, "player", false, true)  -- makes enemies.yards5f
    enemies.get(8)
    enemies.get(15)
    enemies.get(30)

    if var.profileStop == nil then var.profileStop = false end
    if var.raiseDeadExpiresAt == nil then var.raiseDeadExpiresAt = 0 end

    -- ui.chatOverlay("Blood: " .. runes.blood() .. " | Frost: " .. runes.frost() .. " | Unholy: " .. runes.unholy()
    --     .. " | Death: " .. runes.death())
    -- ui.chatOverlay("Enemies (8y): " .. #enemies.yards8)

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop == true) or ui.pause() or unit.mounted() or unit.flying() then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        if ui.mode.rotation == 4 then return true end
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
local id = 251
local expansion = br.isMOP
br.loader.rotations[id] = br.loader.rotations[id] or {}
br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
