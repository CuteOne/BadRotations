local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "divineStorm", overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range." },
        { name = "Mult", icon = "divineStorm", overlay = "Multiple Target Rotation", tip = "Multiple target rotation used." },
        { name = "Sing", icon = "crusaderStrike", overlay = "Single Target Rotation", tip = "Single target rotation used." },
        { name = "Off", icon = "flashOfLight", overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation" },
    } })
    ui.toggle("Cooldown", { modes = {
        { name = "Auto", icon = "avengingWrath", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On", icon = "avengingWrath", overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target." },
        { name = "Off", icon = "avengingWrath", overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used." },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "flashOfLight", overlay = "Defensive Enabled", tip = "Enables Defensive" },
        { name = "Off", icon = "flashOfLight", overlay = "Defensive Disabled", tip = "Disables Defensive" },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "hammerOfJustice", overlay = "Interrupt Enabled", tip = "Enables Interrupt" },
        { name = "Off", icon = "hammerOfJustice", overlay = "Interrupt Disabled", tip = "Disables Interrupt" },
    } })
end

---------------
--- OPTIONS ---
---------------
local function options()
    local section
    local playTarMouseFocLow = { "|cffFFFFFFPlayer", "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFFocus",
        "|cffFFFFFFLowest" }
    -----------------------
    --- GENERAL OPTIONS ---
    -----------------------
    section = ui.section("General")
    -- Dummy DPS Test
    ui.spinner(section, "DPS Testing", { value = 5, min = 5, max = 60,
        tip = "Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5" })
    -- Seal of Command
    ui.checkbox(section, "Seal of Command/Truth")
    ------------------------
    --- COOLDOWN OPTIONS ---
    ------------------------
    section = ui.section("Cooldown")
    -- Avenging Wrath
    ui.dropdown(section, "Avenging Wrath", { choices = "AlwaysCdAoeNever", value = "AOE", checkbox = false,
        tip = "Set when to use Avenging Wrath" })
    -- Execution Sentence
    ui.dropdown(section, "Execution Sentence", { choices = "AlwaysCdAoeNever", value = "AOE", checkbox = false,
        tip = "Set when to use Execution Sentence" })
    -- Exorcism
    ui.checkbox(section, "Exorcism")
    -- Guardian of Ancient Kings
    ui.dropdown(section, "Guardian of Ancient Kings", { choices = "AlwaysCdAoeNever", value = "AOE", checkbox = false,
        tip = "Set when to use Guardian of Ancient Kings" })
    -- Holy Avenger
    ui.dropdown(section, "Holy Avenger", { choices = "AlwaysCdAoeNever", value = "AOE", checkbox = false,
        tip = "Set when to use Holy Avenger" })
    -- Holy Prism
    ui.checkbox(section, "Holy Prism")
    -- Light's Hammer
    ui.dropdown(section, "Light's Hammer", { choices = "AlwaysCdAoeNever", value = "AOE", checkbox = false,
        tip = "Set when to use Light's Hammer" })
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    -- Cleanse
    ui.dropdown(section, "Cleanse", { choices = playTarMouseFocLow, value = 1, tip = "Target to Cast On" })
    -- Divine Shield
    ui.spinner(section, "Divine Shield", { value = 35, tip = "|cffFFBB00Health Percentage to use at." })
    -- Flash of Light
    ui.spinner(section, "Flash of Light", { value = 50, tip = "|cffFFBB00Health Percentage to use at." })
    ui.dropdown(section, "Flash of Light Target", { choices = playTarMouseFocLow, value = 5, checkbox = false,
        tip = "Target for Flash of Light" })
    -- Hammer of Justice
    ui.spinner(section, "Hammer of Justice - Defensive", { value = 30, tip = "Health Percent to Cast At" })
    -- Lay On Hands
    ui.spinner(section, "Lay On Hands", { value = 20, tip = "", boxTip = "Health Percentage to use at" })
    ui.dropdown(section, "Lay on Hands Target", { choices = playTarMouseFocLow, value = 5, checkbox = false, tip = "Target for Lay On Hands" })
    -- Redemption
    ui.dropdown(section, "Redemption", { choices = { "Target", "Mouseover", "Focus" }, value = "Target", tip = "Target to Cast On" })
   -- Word of Glory
    ui.spinner(section, "Word of Glory", { value = 40, tip = "Health Percent to Cast At" })
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = ui.section("Interrupts")
    -- Hammer of Justice
    ui.checkbox(section, "Hammer of Justice")
    -- Rebuke
    ui.checkbox(section, "Rebuke")
    -- Interrupt Percentage
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "|cffFFBB00Cast Percentage to use at." })
end

--------------
--- Locals ---
--------------
-- BR API Locals
local holyPower
-- Profile Specific Locals
local actionList     = {}
local var            = {}
var.haltProfile      = false
var.profileStop      = false

-----------------
--- Functions ---
-----------------

local getHealUnitOption = function(option, checkForbearance)
    local thisTar = ui.value(option)
    local thisUnit
    if thisTar == 1 then
        thisUnit = "player"
    end
    if thisTar == 2 then
        thisUnit = "target"
    end
    if thisTar == 3 then
        thisUnit = "mouseover"
    end
    if thisTar == 4 then
        thisUnit = "focus"
    end
    if thisTar == 5 then
        thisUnit = var.lowestUnit
        -- Get the next lowest unit if lowest unit has Forbearance debuff
        if checkForbearance and #units.friends > 1 and debuff.forbearance.exists(thisUnit) then
            for i = 1, #units.friends do
                local nextUnit = units.friends[i].unit
                if not debuff.forbearance.exists(nextUnit) then
                    thisUnit = nextUnit
                    break
                end
            end
        end
    end
    return thisUnit
end

--------------------
--- Action Lists ---
--------------------

-- Action List - Extras
actionList.Extras = function()
    -- * Dummy Test
    if ui.checked("DPS Testing") and unit.isDummy() then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing")) * 60) then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end
    -- * Seal of Command
    if ui.checked("Seal of Command/Truth") and cast.able.sealOfCommand("player") and not unit.formActive(spell.sealOfCommand.id()) and not spell.sealOfTruth.known() then
        if cast.sealOfCommand("player") then
            ui.debug("Casting Seal of Command")
            return true
        end
    end
    -- * Seal of Truth
    if not ui.checked("Seal of Command/Truth") and cast.able.sealOfTruth("player") and not unit.formActive(spell.sealOfTruth.id()) then
        if cast.sealOfTruth("player") then
            ui.debug("Casting Seal of Truth")
            return true
        end
    end
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- * Cleanse
        if ui.checked("Cleanse") then
            var.cleanseUnit = getHealUnitOption("Cleanse")
            if var.cleanseUnit ~= nil and cast.able.cleanse(var.cleanseUnit) and cast.dispel.cleanse(var.cleanseUnit) then
                if cast.cleanse(var.cleanseUnit) then
                    ui.debug("Casting Cleanse on " .. unit.name(var.cleanseUnit))
                    return true
                end
            end
        end
        -- * Divine Shield
        if ui.checked("Divine Shield") and cast.able.divineShield() and unit.inCombat() then
            if unit.hp() <= ui.value("Divine Shield") and not debuff.forbearance.exists("player") then
                if cast.divineShield() then
                    ui.debug("Casting Divine Shield")
                    return true
                end
            end
        end
        -- * Flash of Light
        if ui.checked("Flash of Light") and not (unit.mounted() or unit.flying()) and not cast.current.flashOfLight() then
            var.flashUnit = getHealUnitOption("Flash of Light Target")
            if var.flashUnit ~= nil and cast.able.flashOfLight(var.flashUnit) and unit.distance(var.flashUnit) < 40 then
                -- Instant Cast
                if talent.selflessHealer and buff.selflessHealer.stack() == 4 then
                    -- Don't waste instant heal!
                    var.flashUnit = unit.hp(var.flashUnit) <= ui.value("Flash of Light") and var.flashUnit or
                        var.lowestUnit
                    if cast.flashOfLight(var.flashUnit) then
                        ui.debug("Casting Flash of Light on " .. unit.name(var.flashUnit) .. " [Instant]")
                        return true
                    end
                end
                -- Long Cast
                if not unit.moving("player") and (var.forceHeal
                        or (unit.inCombat() and unit.hp(var.flashUnit) <= ui.value("Flash of Light"))
                        or (not unit.inCombat() and unit.hp(var.flashUnit) <= 90))
                then
                    if cast.flashOfLight(var.flashUnit) then
                        ui.debug("Casting Flash of Light on " .. unit.name(var.flashUnit) .. " [Long]")
                        return true
                    end
                end
            end
        end
        -- * Hammer of Justice
        if ui.checked("Hammer of Justice - Defensive") and cast.able.hammerOfJustice()
            and unit.inCombat() and unit.hp() < ui.value("Hammer of Justice - Defensive")
        then
            if cast.hammerOfJustice() then
                ui.debug("Casting Hammer of Justice [Defensive]")
                return true
            end
        end
        -- * Lay On Hands
        if ui.checked("Lay On Hands") then
            var.layUnit = getHealUnitOption("Lay On Hands Target", true)
            if var.layUnit ~= nil and cast.able.layOnHands(var.layUnit) and unit.inCombat(var.layUnit) and not debuff.forbearance.exists(var.layUnit)
                and unit.hp(var.layUnit) <= ui.value("Lay On Hands") and unit.distance(var.layUnit) < 40
            then
                if cast.layOnHands(var.layUnit) then
                    ui.debug("Casting Lay On Hands on " ..
                        tostring(unit.name(var.layUnit)) .. " [" .. tostring(unit.hp(var.layUnit)) .. "% Remaining]")
                    return true
                end
            end
        end
        -- * Redemption
        if ui.checked("Redemption") and not unit.moving("player") and var.resable then
            local redemptionTar = ui.value("Redemption")
            local redemptionUnit
            if redemptionTar == 1 then
                redemptionUnit = "target"
            end
            if redemptionTar == 2 then
                redemptionUnit = "mouseover"
            end
            if redemptionTar == 3 then
                redemptionUnit = "focus"
            end
            if redemptionUnit ~= nil and cast.able.redemption(redemptionUnit, "dead") then
                if cast.redemption(redemptionUnit, "dead") then
                    ui.debug("Casting Redemption on " .. unit.name(redemptionUnit))
                    return true
                end
            end
        end
        -- * Word of Glory
        if ui.checked("Word of Glory") and cast.able.wordOfGlory() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.inCombat(thisUnit) and unit.hp(thisUnit) <= ui.value("Word of Glory") then
                if cast.wordOfGlory(thisUnit) then
                    ui.debug("Casting Word of Glory on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards10 do
            local thisUnit = enemies.yards10[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                -- * Hammer of Justice
                if ui.checked("Hammer of Justice") and cast.able.hammerOfJustice(thisUnit) then
                    if cast.hammerOfJustice(thisUnit) then
                        ui.debug("Casting Hammer of Justice [Interrupt]")
                        return true
                    end
                end
            end
        end
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                -- * Rebuke
                -- rebuke
                if ui.checked("Rebuke") and cast.able.rebuke(thisUnit) then
                    if cast.rebuke(thisUnit) then
                        ui.debug("Casting Rebuke [Interrupt]")
                        return true
                    end
                end
            end
        end
    end -- End Interrupt Check
end     -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldowns = function()

end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- * Judgment
            if cast.able.judgment("target") and unit.exists("target") then
                if cast.judgment("target") then
                    ui.debug("Casting Judgment [Precombat]")
                    return true
                end
            end
            -- * Crusader Strike
            if cast.able.crusaderStrike("target") and unit.exists("target") then
                if cast.crusaderStrike("target") then
                    ui.debug("Casting Crusader Strike [Precombat]")
                    return true
                end
            end
            -- * Auto Attack
            if cast.able.autoAttack("target") and unit.exists("target") then
                if cast.autoAttack("target") then
                    ui.debug("Casting Auto Attack [Precombat]")
                    return true
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat    = function()
    if unit.valid("target") and cd.global.remain() == 0 then
        if unit.exists(units.dyn5) then
            -- Potion
            -- mogu_power_potion,if=(buff.bloodlust.react|(buff.ancient_power.up&buff.avenging_wrath.up)|target.time_to_die<=40)
            -- TODO: Add Potion Logic Here
            -- * Auto Attack
            -- auto_attack
            if cast.able.autoAttack(units.dyn5) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack(units.dyn5) then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
            -- * Inquisition
            -- inquisition,if=(buff.inquisition.down|buff.inquisition.remains<=2)&(holy_power>=3|target.time_to_die<holy_power*20|buff.divine_purpose.react)
            if cast.able.inquisition() then
                if debuff.remain.inquisition(units.dyn5) <= 2
                    and (holyPower() >= 3 or unit.ttd(units.dyn5) < holyPower() * 20 or buff.divinePurpose.exists())
                then
                    if cast.inquisition() then
                        ui.debug("Casting Inquisition")
                        return true
                    end
                end
            end
            -- * Avenging Wrath
            -- avenging_wrath,if=buff.inquisition.up
            if ui.alwaysCdAoENever("Avenging Wrath",3,#enemies.yards8) and cast.able.avengingWrath() then
                if buff.inquisition.exists() then
                    if cast.avengingWrath() then
                        ui.debug("Casting Avenging Wrath")
                        return true
                    end
                end
            end
            -- * Guardian of Ancient Kings
            -- guardian_of_ancient_kings,if=buff.inquisition.up
            if ui.alwaysCdAoENever("Guardian of Ancient Kings",3,#enemies.yards8) and cast.able.guardianOfAncientKings() then
                if buff.inquisition.exists() then
                    if cast.guardianOfAncientKings() then
                        ui.debug("Casting Guardian of Ancient Kings")
                        return true
                    end
                end
            end
            -- * Holy Avenger
            -- holy_avenger,if=talent.holy_avenger.enabled&(buff.inquisition.up&holy_power<=2)
            if talent.holyAvenger and ui.alwaysCdAoENever("Holy Avenger",3,#enemies.yards8) and cast.able.holyAvenger() then
                if buff.inquisition.exists() and holyPower() <= 2 then
                    if cast.holyAvenger() then
                        ui.debug("Casting Holy Avenger")
                        return true
                    end
                end
            end
            -- * Use Item - Reinbinder's Fists
            -- use_item,name=reinbinders_fists,if=buff.inquisition.up&(buff.ancient_power.down|buff.ancient_power.stack=12)
            -- TODO: Add Use Item Logic Here
            -- * Racials
            -- blood_fury
            -- berserking
            -- arcane_torrent
            if ui.alwaysCdNever("Racial") and cast.able.racial()
                and (unit.race() == "Orc" or unit.race() == "BloodElf" or unit.race() == "Troll")
            then
                if cast.racial() then ui.debug("Casting Racial") return true end
            end
            -- * Execution Sentence
            -- execution_sentence,if=talent.execution_sentence.enabled&(buff.inquisition.up&(buff.ancient_power.down|buff.ancient_power.stack=12))
            if talent.executionSentence and ui.alwaysCdAoENever("Execution Sentence",3,#enemies.yards8) and cast.able.executionSentence() then
                if buff.inquisition.exists()
                    and (not buff.ancientPower.exists() or buff.ancientPower.stack() == 12)
                then
                    if cast.executionSentence() then
                        ui.debug("Casting Execution Sentence")
                        return true
                    end
                end
            end
            -- * Light's Hammer
            -- lights_hammer,if=talent.lights_hammer.enabled&(buff.inquisition.up&(buff.ancient_power.down|buff.ancient_power.stack=12))
            if talent.lightsHammer and ui.alwaysCdAoENever("Light's Hammer",3,#enemies.yards8) and cast.able.lightsHammer() then
                if buff.inquisition.exists()
                    and (not buff.ancientPower.exists() or buff.ancientPower.stack() == 12)
                then
                    if cast.lightsHammer() then
                        ui.debug("Casting Light's Hammer")
                        return true
                    end
                end
            end
            -- * Divine Storm
            -- divine_storm,if=active_enemies>=2&(holy_power=5|buff.divine_purpose.react|(buff.holy_avenger.up&holy_power>=3))
            if ui.useAOE(8,2) and cast.able.divineStorm() then
                if (holyPower() == 5 or buff.divinePurpose.exists() or (buff.holyAvenger.exists() and holyPower() >= 3)) then
                    if cast.divineStorm() then
                        ui.debug("Casting Divine Storm")
                        return true
                    end
                end
            end
            -- divine_storm,if=buff.divine_crusader.react&holy_power=5
            if cast.able.divineStorm() then
                if buff.divineCrusader.exists() and holyPower() == 5 then
                    if cast.divineStorm() then
                        ui.debug("Casting Divine Storm - High Holy Power")
                        return true
                    end
                end
            end
            -- * Templar's Verdict
            -- templars_verdict,if=holy_power=5|buff.holy_avenger.up&holy_power>=3
            if (ui.useST(8,2) or not spell.divineStorm.known()) and cast.able.templarsVerdict() then
                if (holyPower.max() == 3 and holyPower() == 3) or holyPower() == 5 or (buff.holyAvenger.exists() and holyPower() >= 3) then
                    if cast.templarsVerdict() then
                        ui.debug("Casting Templar's Verdict - High Holy Power")
                        return true
                    end
                end
            end
            -- templars_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<4
            if (ui.useST(8,2) or not spell.divineStorm.known()) and cast.able.templarsVerdict() then
                if buff.divinePurpose.exists() and buff.divinePurpose.remain() < 4 then
                    if cast.templarsVerdict() then
                        ui.debug("Casting Templar's Verdict - Divine Purpose Expires Soon")
                        return true
                    end
                end
            end
            -- * Hammer of Wrath
            -- hammer_of_wrath
            if cast.able.hammerOfWrath() then
                if buff.avengingWrath.exists() or unit.hp(units.dyn5) <= 20 then
                    if cast.hammerOfWrath() then
                        ui.debug("Casting Hammer of Wrath")
                        return true
                    end
                end
            end
            -- * Wait
            -- wait,sec=cooldown.hammer_of_wrath.remains,if=cooldown.hammer_of_wrath.remains>0&cooldown.hammer_of_wrath.remains<=0.2
            if cd.hammerOfWrath.remain() > 0 and cd.hammerOfWrath.remain() <= 0.2 then
                -- ui.debug("Waiting for Hammer of Wrath Cooldown")
                return true
            end
            -- * Divine Storm
            -- divine_storm,if=buff.divine_crusader.react&buff.avenging_wrath.up
            if cast.able.divineStorm() then
                if buff.divineCrusader.exists() and buff.avengingWrath.exists() then
                    if cast.divineStorm() then
                        ui.debug("Casting Divine Storm - Avenging Wrath")
                        return true
                    end
                end
            end
            -- * Templar's Verdict
            -- templars_verdict,if=buff.avenging_wrath.up
            if (ui.useST(8,2) or not spell.divineStorm.known()) and cast.able.templarsVerdict() then
                if buff.avengingWrath.exists() then
                    if cast.templarsVerdict() then
                        ui.debug("Casting Templar's Verdict - Avenging Wrath")
                        return true
                    end
                end
            end
            -- * Hammer of the Righteous
            -- hammer_of_the_righteous,if=active_enemies>=4
            if ui.useAOE(8,4) and cast.able.hammerOfTheRighteous() then
                if cast.hammerOfTheRighteous() then
                    ui.debug("Casting Hammer of the Righteous")
                    return true
                end
            end
            -- * Crusader Strike
            -- crusader_strike
            if (ui.useST(8,4) or not spell.hammerOfTheRighteous.known()) and cast.able.crusaderStrike() then
                if cast.crusaderStrike() then
                    ui.debug("Casting Crusader Strike")
                    return true
                end
            end
            -- * Wait
            -- wait,sec=cooldown.crusader_strike.remains,if=cooldown.crusader_strike.remains>0&cooldown.crusader_strike.remains<=0.2
            if cd.crusaderStrike.remain() > 0 and cd.crusaderStrike.remain() <= 0.2 then
                -- ui.debug("Waiting for Crusader Strike Cooldown")
                return true
            end
            -- * Exorcism
            -- exorcism,if=active_enemies>=2&active_enemies<=4&set_bonus.tier15_2pc_melee&glyph.mass_exorcism.enabled
            -- if ui.useAOE(8,2) and ui.useAOE(8,4) and talent.glyphOfMassExorcism and cast.able.exorcism() then
            --     if cast.exorcism() then
            --         ui.debug("Casting Exorcism - AOE")
            --         return true
            --     end
            -- end
            -- * Judgment
            -- judgment
            if cast.able.judgment(units.dyn30) then
                if cast.judgment(units.dyn30) then
                    ui.debug("Casting Judgment")
                    return true
                end
            end
            -- * Wait
            -- wait,sec=cooldown.judgment.remains,if=cooldown.judgment.remains>0&cooldown.judgment.remains<=0.2
            if cd.judgment.remain() > 0 and cd.judgment.remain() <= 0.2 then
                -- ui.debug("Waiting for Judgment Cooldown")
                return true
            end
            -- * Divine Storm
            -- divine_storm,if=buff.divine_crusader.react
            if cast.able.divineStorm() then
                if buff.divineCrusader.exists() then
                    if cast.divineStorm() then
                        ui.debug("Casting Divine Storm - Divine Crusader")
                        return true
                    end
                end
            end
            -- * Templar's Verdict
            -- templars_verdict,if=buff.divine_purpose.react
            if (ui.useST(8,2) or not spell.divineStorm.known()) and cast.able.templarsVerdict() then
                if buff.divinePurpose.exists() then
                    if cast.templarsVerdict() then
                        ui.debug("Casting Templar's Verdict - Divine Purpose")
                        return true
                    end
                end
            end
            -- * Exorcism
            -- exorcism
            if ui.checked("Exorcism") and cast.able.exorcism() then
                if cast.exorcism() then
                    ui.debug("Casting Exorcism")
                    return true
                end
            end
            -- * Wait
            -- wait,sec=cooldown.exorcism.remains,if=cooldown.exorcism.remains>0&cooldown.exorcism.remains<=0.2
            if cd.exorcism.remain() > 0 and cd.exorcism.remain() <= 0.2 then
                -- ui.debug("Waiting for Exorcism Cooldown")
                return true
            end
            -- * Templar's Verdict
            -- templars_verdict,if=buff.tier15_4pc_melee.up&active_enemies<4
            -- if (ui.useST(8,2) or not spell.divineStorm.known()) and cast.able.templarsVerdict() then
            --     if buff.tier15_4pc_melee.exists() and #enemies.yards8 < 4 then
            --         if cast.templarsVerdict() then
            --             ui.debug("Casting Templar's Verdict - T15 4PC")
            --             return true
            --         end
            --     end
            -- end
            -- * Divine Storm
            -- divine_storm,if=active_enemies>=2&buff.inquisition.remains>4
            if ui.useAOE(8,2) and cast.able.divineStorm() then
                if buff.inquisition.remain() > 4 then
                    if cast.divineStorm() then
                        ui.debug("Casting Divine Storm - Inquisition")
                        return true
                    end
                end
            end
            -- * Templar's Verdict
            -- templars_verdict,if=buff.inquisition.remains>4
            if (ui.useST(8,2) or not spell.divineStorm.known()) and cast.able.templarsVerdict() then
                if buff.inquisition.remain() > 4 then
                    if cast.templarsVerdict() then
                        ui.debug("Casting Templar's Verdict - Inquisition")
                        return true
                    end
                end
            end
            -- * Holy Prism
            -- holy_prism,if=talent.holy_prism.enabled
            if ui.checked("Holy Prism") and talent.holyPrism and cast.able.holyPrism() then
                if cast.holyPrism() then
                    ui.debug("Casting Holy Prism")
                    return true
                end
            end
        end -- End In Combat Rotation
    end
end -- End Action List - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    holyPower   = power.holyPower
    -- Units
    units.get(5)
    units.get(30)
    -- Enemies
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    -- General Locals
    var.haltProfile = (unit.inCombat() and var.profileStop) or unit.mounted() or unit.flying() or ui.pause() or ui.mode.rotation == 4


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
        -------------
        --- Extra ---
        -------------
        if actionList.Extras() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        if unit.inCombat() then
            -----------------
            --- Cooldowns ---
            -----------------
            if actionList.Cooldowns() then return true end
            -----------------
            --- Interrupt ---
            -----------------
            if actionList.Interrupt() then return true end
            --------------
            --- Combat ---
            --------------
            if actionList.Combat() then return true end
        end
    end -- Pause
end -- End runRotation
registerRotation({
    handlesRacials = true,
    name      = rotationName,
    specID    = 70,
    expansion = "MOP",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})
