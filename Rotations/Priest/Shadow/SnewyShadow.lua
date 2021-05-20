local rotationName = "SnewyShadow"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Cooldown
    local CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Enabled", tip = "Includes Cooldowns.", highlight = 1, icon = br.player.spell.voidEruption},
        [2] = {mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Includes Cooldowns.", highlight = 1, icon = br.player.spell.voidEruption},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.voidEruption}
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 1, 0)
    
    -- Defensive
    local DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensives.", highlight = 1, icon = br.player.spell.dispersion},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dispersion}
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    
    -- Dispel
    local DispelModes = {
        [1] = {mode = "On", value = 1, overlay = "Dispels Enabled", tip = "Includes Dispels.", highlight = 1, icon = br.player.spell.dispelMagic},
        [2] = {mode = "Off", value = 2, overlay = "Dispels Disabled", tip = "No Dispels will be used.", highlight = 0, icon = br.player.spell.dispelMagic}
    }
    br.ui:createToggle(DispelModes, "Dispel", 3, 0)
    
    -- Interrupt
    local InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.silence},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.silence}
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
end -- End createToggles

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
    
    local function generalOptions()
        local section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createSpinner(section, "Pre-Pull Timer", 2, 1, 10, 1, "Desired time to start Pre-Pull.")
        br.ui:createSpinner(section, "Heal Out of Combat", 90, 1, 100, 1, "Health Percentage to heal Out of Combat.")
        br.ui:createCheckbox(section, "Shadowform", "Use Shadowform.")
        br.ui:createCheckbox(section, "Power Word: Fortitude", "Use Power Word: Fortitude on party.")
        br.ui:createSpinner(section, "Power Word: Shield (Body and Soul)", 1, 0, 100, 1, "Use Power Word: Shield (Body and Soul) after past seconds of moving.")
        br.ui:createSpinner(section, "Fade", 100, 0, 100, 1, "Health Percentage to use Fade when we have aggro.")
        br.ui:createDropdown(section, "Dispel Magic", {"Target", "Auto"}, 1, "Use Dispel Magic on current or dynamic Target.")
        br.ui:createDropdown(section, "Purify Disease", {"Target", "Auto"}, 1, "Use Purify Disease on current or dynamic Target.")
        br.ui:checkSectionState(section)
        -- Interrupts
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createDropdown(section, "Interrupt", {"Target", "Auto"}, 1, "Use Interrupts on current or dynamic Target.")
        br.ui:createCheckbox(section, "Silence", "Use Silence to interrupt.")
        br.ui:createCheckbox(section, "Psychic Scream", "Use Psychic Scream to interrupt.")
        br.ui:createCheckbox(section, "Psychic Horror", "Use Psychic Horror to interrupt.")
        br.ui:createCheckbox(section, "Mind Bomb", "Use Mind Bomb to interrupt.")
        if br.player.race == "Pandaren" then br.ui:createCheckbox(section, "Quaking Palm", "Use Quaking Palm to interrupt.") end
        br.ui:createSpinner(section, "Interrupt At", 85, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
    end -- End generalOptions
    
    local function healingOptions()
        local section = br.ui:createSection(br.ui.window.profile, "Healing")
        br.ui:createSpinner(section, "Shadow Mend", 40, 0, 100, 5, "Health Percentage to use at.")
        br.ui:checkSectionState(section)
    end -- End healingOptions
    
    local function damageOptions()
        local section = br.ui:createSection(br.ui.window.profile, "Damage")
        br.ui:createCheckbox(section, "Damnation", "Use Damnation.")
        br.ui:createCheckbox(section, "Devouring Plague", "Use Devouring Plague.")
        br.ui:createCheckbox(section, "Mind Blast", "Use Mind Blast.")
        br.ui:createCheckbox(section, "Mind Flay", "Use Mind Flay.")
        br.ui:createSpinner(section, "Mind Sear Targets", 3, 1, 50, 1, "Minimum Mind Sear Targets to use at.")
        br.ui:createCheckbox(section, "Searing Nightmare", "Use Searing Nightmare.")
        br.ui:createCheckbox(section, "Shadow Crash", "Use Shadow Crash.")
        br.ui:createCheckbox(section, "Shadow Word: Death", "Use Shadow Word: Death.")
        br.ui:createCheckbox(section, "Shadow Word: Death Sniping", "Use Shadow Word: Death Sniping.")
        br.ui:createSpinner(section, "Shadow Word: Pain Targets", 3, 0, 20, 1, "Maximum Shadow Word: Pain Targets to use at.")
        br.ui:createCheckbox(section, "Explosive Rotation", "Use Shadow Word: Pain at explosives.")
        br.ui:createSpinner(section, "Vampiric Touch Targets", 3, 0, 20, 1, "Maximum Vampiric Touch Targets to use at.")
        br.ui:createCheckbox(section, "Void Bolt", "Use Void Bolt.")
        br.ui:createCheckbox(section, "Void Torrent", "Use Void Torrent.")
        br.ui:checkSectionState(section)
    end -- End damageOptions
    
    local function cooldownOptions()
        local section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createCheckbox(section, "Racial", "Use Racial.")
        br.ui:createCheckbox(section, "Boon of the Ascended", "Use Boon of the Ascended.")
        br.ui:createCheckbox(section, "Power Infusion", "Use Power Infusion.")
        br.ui:createCheckbox(section, "Void Eruption", "Use Void Eruption.")
        br.ui:createCheckbox(section, "Surrender to Madness", "Use Surrender to Madness.")
        br.ui:createCheckbox(section, "Mindbender", "Use Mindbender.")
        br.ui:createCheckbox(section, "Mindgames", "Use Mindgames.")
        br.ui:createCheckbox(section, "Shadowfiend", "Use Shadowfiend.")
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 1, "Health Percentage to use at.")
        br.ui:createSpinnerWithout(section, "Trinket 1 Targets", 3, 1, 40, 1, "Minimum Trinket 1 Targets to use at.")
        br.ui:createDropdown(section, "Trinket 1 Mode", {"Enemy", "Friend"}, 1, "Use Trinket 1 on enemy or on friend.")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 1, "Health Percentage to use at.")
        br.ui:createSpinnerWithout(section, "Trinket 2 Targets", 3, 1, 40, 1, "Minimum Trinket 2 Targets to use at.")
        br.ui:createDropdown(section, "Trinket 2 Mode", {"Enemy", "Friend"}, 1, "Use Trinket 2 on enemy or on friend.")
        br.ui:checkSectionState(section)
    end -- End cooldownOptions
    
    local function defensiveOptions()
        local section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Vampiric Embrace", 50, 0, 100, 1, "Health Percentage to use at.")
        br.ui:createSpinner(section, "Desperate Prayer", 40, 0, 100, 1, "Health Percentage to use at.")
        br.ui:createSpinner(section, "Dispersion", 30, 0, 100, 1, "Health Percentage to use at.")
        br.ui:createSpinner(section, "Healthstone", 35, 0, 100, 1, "Health Percentage to use at.")
        if br.player.race == "Draenei" then br.ui:createSpinner(section, "Gift of the Naaru", 50, 0, 100, 1, "Health Percentage to use at.") end
        br.ui:checkSectionState(section)
    end -- End defensiveOptions
    
    optionTable = {
        {
            [1] = "General",
            [2] = generalOptions,
        },
        {
            [1] = "Healing",
            [2] = healingOptions
        },
        {
            [1] = "Damage",
            [2] = damageOptions
        },
        {
            [1] = "Cooldowns",
            [2] = cooldownOptions
        },
        {
            [1] = "Defensive",
            [2] = defensiveOptions
        }
    }
    return optionTable
end -- End createOptions

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local cd
local charges
local covenant
local debuff
local enemies
local friends
local gcd
local inCombat
local mode
local moving
local pet
local race
local runeforge
local spell
local talent
local ui
local unit
local units
local var
-- Other Locals
local allDotsUp
local dotsUp
local fiendActive
local fiendRemain
local hp
local insanity
local lowestUnit
local mana
local mindSearUnit
local mindSearUnitsCount
local mfTicks
local msTicks
local poolForVoidEruption
local searingNightmareCutoff
local shadowWordPainCount
local thisUnit
local vampiricTouchCount
local vampiricTouchRefreshable

-----------------
--- Functions ---
-----------------
local function ttd(u)
    local ttdSec = unit.ttd(u)
    if ttdSec == nil or ttdSec < 0 then
        return 999
    end
    return ttdSec
end

--------------------
--- Action Lists ---
--------------------
local actionList = {}

-- Action List - PreCombat
actionList.PreCombat = function()
    if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
        if unit.valid("target") then
            if ui.checked("Vampiric Touch Targets") and not moving then
                if cast.vampiricTouch("target") then ui.debug("Casting Vampiric Touch on target [PreCombat]") return true end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Extra
actionList.Extra = function()
    if ui.checked("Shadowform") then
        if not buff.shadowform.exists() and not buff.voidForm.exists() then
            if cast.shadowform() then ui.debug("Casting Shadowform [Extra]") return end
        end
    end
    if ui.checked("Power Word: Fortitude") then
        for i = 1, #friends do
            thisUnit = friends[i].unit
            if not buff.powerWordFortitude.exists(thisUnit, "any") and unit.distance(thisUnit) < 40 and not unit.deadOrGhost(thisUnit) then
                if cast.powerWordFortitude() then ui.debug("Casting Power Word: Fortitude [Extra]") return true end
            end
        end
    end
    if br.IsMovingTime(ui.value("Power Word: Shield (Body and Soul)")) then
        if ui.checked("Power Word: Shield (Body and Soul)") and talent.bodyAndSoul and not debuff.weakenedSoul.exists("player") then
            if cast.powerWordShield("player") then ui.debug("Casting Power Word: Shield on Player [Extra]") return true end
        end
    end
end -- End Action List Extra

-- Action List - Dispel
actionList.Dispel = function()
    if mode.dispel == 1 then
        if ui.checked("Dispel Magic") then
            if ui.value("Dispel Magic") == 1 then
                if unit.valid("target") and br.canDispel("target", spell.dispelMagic) then
                    if cast.dispelMagic("target") then ui.debug("Casting Dispel Magic on Target [Dispel]") return true end
                end
            elseif ui.value("Dispel Magic") == 2 then
                for i = 1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if br.canDispel(thisUnit, spell.dispelMagic) then
                        if cast.dispelMagic(thisUnit) then ui.debug("Casting Dispel Magic on Auto [Dispel]") return true end
                    end
                end
            end
        end
        if ui.checked("Purify Disease") then
            if ui.value("Purify Disease") == 1 then
                if unit.exists("target") and br.canDispel("target", spell.purifyDisease) then
                    if cast.purifyDisease("target") then ui.debug("Casting Purify Disease on Target [Dispel]") return true end
                end
            elseif ui.value("Purify Disease") == 2 then
                for i = 1, #friends do
                    thisUnit = friends[i].unit
                    if br.canDispel(thisUnit, spell.purifyDisease) then
                        if cast.purifyDisease(thisUnit) then ui.debug("Casting Purify Disease on Auto [Dispel]") return true end
                    end
                end
            end
        end
    end
end -- End Action List - Dispel

-- Action List - Interrrupt
actionList.Interrupt = function()
    if ui.useInterrupt() and ui.checked("Interrupt") then
        if ui.value("Interrupt") == 1 then
            if unit.interruptable("target", ui.value("Interrupt At")) then
                if ui.checked("Silence") then
                    if cast.silence("target") then ui.debug("Casting Silence on Target [Interrupt]") return true end
                end
                if ui.checked("Psychic Horror") then
                    if cast.psychicHorror("target") then ui.debug("Casting Psychic Horror on Target [Interrupt]") return true end
                end
                if ui.checked("Mind Bomb") then
                    if cast.mindBomb("target") then ui.debug("Casting Mind Bomb on Target [Interrupt]") return true end
                end
                if ui.checked("Psychic Scream") and unit.distance("target") < 8 then
                    if cast.psychicScream() then ui.debug("Casting Psychic Scream [Interrupt]") return true end
                end
                if ui.checked("Quaking Palm") and unit.distance("target") < 5 then
                    if cast.quakingPalm("target") then ui.debug("Casting Quaking Palm on Target [Interrupt]") return true end
                end
            end
        elseif ui.value("Interrupt") == 2 then
            for i = 1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                if br.canInterrupt(thisUnit, ui.value("Interrupt At")) then
                    if ui.checked("Silence") then
                        if cast.silence(thisUnit) then ui.debug("Casting Silence on Auto [Interrupt]") return true end
                    end
                    if ui.checked("Psychic Horror") then
                        if cast.psychicHorror(thisUnit) then ui.debug("Casting Psychic Horror on Auto [Interrupt]") return true end
                    end
                    if ui.checked("Mind Bomb") then
                        if cast.mindBomb(thisUnit) then ui.debug("Casting Mind Bomb on Auto [Interrupt]") return true end
                    end
                    if ui.checked("Psychic Scream") and unit.distance(thisUnit) < 8 then
                        if cast.psychicScream() then ui.debug("Casting Psychic Scream [Interrupt]") return true end
                    end
                    if ui.checked("Quaking Palm") and unit.distance(thisUnit) < 5 then
                        if cast.quakingPalm(thisUnit) then ui.debug("Casting Quaking Palm on Auto [Interrupt]") return true end
                    end
                end
            end
        end
    end
end -- End Action List - Interrupt

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        if ui.checked("Fade") and hp <= ui.value("Fade") then
            for i = 1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                if unit.isTanking(thisUnit) and unit.inCombat(thisUnit) then
                    if cast.fade() then ui.debug("Casting Fade [Defensive]") end
                end
            end
        end
        if ui.checked("Healthstone") and hp <= ui.value("Healthstone") and inCombat and (br.hasItem(5512) and br.canUseItem(5512)) then
            if br.useItem(5512) then ui.debug("Using Healthstone [Defensive]") end
        end
        if ui.checked("Gift of the Naaru") and hp <= ui.value("Gift of the Naaru") and inCombat and race == "Draenei" then
            if cast.giftOfTheNaaru() then ui.debug("Casting Gift of the Naaru [Defensive]") return true end
        end
        if ui.checked("Vampiric Embrace") and hp <= ui.value("Vampiric Embrace") then
            if cast.vampiricEmbrace() then ui.debug("Casting Vampiric Embrace [Defensive]") return true end
        end
        if ui.checked("Desperate Prayer") and hp <= ui.value("Desperate Prayer") then
            if cast.desperatePrayer() then ui.debug("Casting Desperate Prayer [Defensive]") return true end
        end
        if ui.checked("Dispersion") and hp <= ui.value("Dispersion") then
            if cast.dispersion() then ui.debug("Casting Dispersion [Defensive]") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Cooldown
actionList.Cooldown = function()
    if ui.useCDs() then
        if ui.checked("Power Infusion") then
            if buff.voidForm.exists() or cd.voidEruption.remain() >= 10 or ttd(units.dyn40) < cd.voidEruption.remain() then
                if cast.powerInfusion() then ui.debug("Casting Power Infusion [Cooldown]") return true end
            end
        end
        if ui.checked("Boon of the Ascended") then
            if covenant.kyrian.active and not buff.voidForm.exists() and not cd.voidEruption.exists() and mindSearUnitsCount > 1 and not talent.searingNightmare or (buff.voidForm.exists() and mindSearUnitsCount < 2 and not talent.searingNightmare and cast.last.voidBolt()) or (buff.voidForm.exists() and talent.searingNightmare) then
                if cast.boonOfTheAscended() then ui.debug("Casting Boon of the Ascended [Cooldown]") return true end
            end
        end
        if ui.checked("Mindgames") then
            if covenant.venthyr.active and insanity < 90 and (allDotsUp or buff.voidForm.exists()) and (not talent.hungeringVoid or debuff.hungeringVoid.exists() or not buff.voidForm.exists()) and (not talent.searingNightmare or mindSearUnitsCount < 5) and not moving then
                if cast.mindgames('target') then ui.debug("Casting Mindgames on Target [Cooldown]") return true end
            end
        end
        if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") or (mana < 70 and race == "BloodElf") then
            if race == "LightforgedDraenei" then
                if cast.racial("target", "ground") then ui.debug("Casting Lightforged Draenei Racial [Cooldown]") return true end
            else
                if cast.racial("player") then ui.debug("Casting Racial on Player [Cooldown]") return true end
            end
        end
        if ui.checked("Trinket 1") and br.canTrinket(13) then
            if ui.value("Trinket 1 Mode") == 1 and mindSearUnitsCount >= ui.value("Trinket 1 Targets") then
                if br.useItem(13) then ui.debug("Using Trinket 1 [Cooldown]") end
            elseif ui.value("Trinket 1 Mode") == 2 and br.getLowAllies(ui.value("Trinket 1")) >= ui.value("Trinket 1 Targets") then
                if unit.hp(lowestUnit) <= ui.value("Trinket 1") then
                    if br.useItem(13, lowestUnit) then ui.debug("Using Trinket 1 on Lowest Unit [Cooldown]") end
                end
            end
        end
        if ui.checked("Trinket 2") and br.canTrinket(14) then
            if ui.value("Trinket 2 Mode") == 1 and mindSearUnitsCount >= ui.value("Trinket 1 Targets") then
                if br.useItem(14) then ui.debug("Using Trinket 2 [Cooldown]") end
            elseif ui.value("Trinket 2 Mode") == 2 and br.getLowAllies(ui.value("Trinket 2")) >= ui.value("Trinket 2 Targets") then
                if unit.hp(lowestUnit) <= ui.value("Trinket 2") then
                    if br.useItem(14, lowestUnit) then ui.debug("Using Trinket 2 on Lowest Unit [Cooldown]") end
                end
            end
        end
    end
end -- End Action List - Cooldown

-- Action List - Healing
actionList.Healing = function()
    if ui.checked("Shadow Mend") and not moving then
        if hp <= ui.value("Shadow Mend") then
            if cast.shadowMend() then ui.debug("Casting Shadow Mend [Healing]") return true end
        end
        if ui.checked("Heal Out of Combat") and not inCombat and hp <= ui.value("Heal Out of Combat") then
            if cast.shadowMend() then ui.debug("Casting Shadow Mend OoC [Healing]") return true end
        end
    end
end -- End Action List - Healing

-- Action List - DamageWhileCasting
actionList.DamageWhileCasting = function()
    if cast.current.mindFlay() or cast.current.mindSear() then
        if ui.checked("Searing Nightmare") and talent.searingNightmare then
            if (searingNightmareCutoff and not poolForVoidEruption) or (debuff.shadowWordPain.refresh(units.dyn40) and mindSearUnitsCount > 1) then
                if cast.searingNightmare(units.dyn40) then ui.debug("Casting Searing Nightmare [DamageWhileCasting]") return true end
            end
        end
        if ui.checked("Mind Blast") then
            if cd.mindBlast.ready() and ((buff.voidForm.exists() and cd.voidBolt.exists()) or not buff.voidForm.exists()) then
                if buff.darkThoughts.exists() then
                    if cast.mindBlast(units.dyn40) then ui.debug("Casting Mind Blast [DamageWhileCasting]") return true end
                end
            end
        end
        if ui.checked("Devouring Plague") and mfTicks >= 1 then
            if (debuff.devouringPlague.refresh(units.dyn40) or insanity > 75) and (not poolForVoidEruption or insanity >= 85) and (not talent.searingNightmare or (talent.searingNightmare and not searingNightmareCutoff)) then
                if cast.devouringPlague(units.dyn40) then ui.debug("Casting Devouring Plague [DamageWhileCasting]") return true end
            end
        end
        if ui.checked("Void Bolt") then
            if (buff.voidForm.exists() or buff.dissonantEchoes.exists()) and mfTicks >= 1 and cast.current.mindFlay() and cd.voidBolt.ready() then
                if cast.cancel.mindFlay() then ui.debug("Cancel Mind Flay [DamageWhileCasting]") return true end
            end
        end
        if ui.checked("Boon of the Ascended") then
            if (cast.current.mindFlay() or cast.current.mindSear()) and buff.boonOfTheAscended.exists() and cd.ascendedBlast.ready() then
                if cast.current.mindFlay() then
                    if cast.cancel.mindFlay() then ui.debug("Cancel Mind Flay [DamageWhileCasting]") return true end
                end
                if cast.current.mindSear() then
                    if cast.cancel.mindSear() then ui.debug("Cancel Mind Sear [DamageWhileCasting]") return true end
                end
            end
        end
        if ui.checked("Vampiric Touch Targets") then
            if cast.current.mindFlay() and mfTicks >= 1 and vampiricTouchRefreshable then
                if cast.cancel.mindFlay() then ui.debug("Cancel Mind Flay [DamageWhileCasting]") return true end
            end
        end
        if cast.current.mindSear() and msTicks >= 5 and cast.last.searingNightmare() and insanity > 30 then
            if cast.cancel.mindSear() then ui.debug("Cancel Mind Sear [DamageWhileCasting]") return true end
        end
    end
end -- End Action List - DamageWhileCasting

-- Action List - PreCdsDamage
actionList.PreCdsDamage = function()
    if ui.checked("Explosive Rotation") and unit.isExplosive(units.dyn40) then
        if cast.shadowWordPain(units.dyn40) then ui.debug("Casting Shadow Word: Pain Explosive [DamageWhileCasting]") return true end
    end
    if ui.checked("Void Eruption") and not moving and ui.useCDs() and not buff.voidForm.exists() then
        if poolForVoidEruption and (insanity >= 40 or (fiendActive and runeforge.shadowflamePrism.equiped)) then
            if cast.voidEruption(units.dyn40) then ui.debug("Casting Void Eruption [DamageWhileCasting]") return true end
        end
    end
    if ui.checked("Shadow Word: Pain Targets") then
        if buff.faeGuardians.exists() and not debuff.wrathfulFaerie.exists() and mindSearUnitsCount < 4 and shadowWordPainCount <= ui.value("Shadow Word: Pain Targets") then
            if cast.shadowWordPain(units.dyn40) then ui.debug("Casting Shadow Word: Pain [DamageWhileCasting]") return true end
        end
    end
end -- End Action List - PreCdsDamage

-- Action List - Damage
actionList.Damage = function()
    if ui.checked("Mind Sear Targets") then
        if talent.searingNightmare and mindSearUnitsCount >= ui.value("Mind Sear Targets") and not debuff.shadowWordPain.exists(mindSearUnit) and not cd.shadowfiend.exists() then
            if cast.mindSear(mindSearUnit) then ui.debug("Casting Mind Sear [Damage]") return true end
        end
    end
    if ui.checked("Damnation") and talent.damnation then
        if not allDotsUp then
            if cast.damnation(units.dyn40) then ui.debug("Casting Damnation [Damage]") return true end
        end
    end
    if ui.checked("Shadow Word: Death") then
        if fiendActive and runeforge.shadowflamePrism.equiped and fiendRemain <= gcd then
            if cast.shadowWordDeath(units.dyn40) then ui.debug("Casting Shadow Word: Death [Damage]") return true end
        end
    end
    if ui.checked("Mind Blast") and not moving then
        if (charges.mindBlast.count() < 1 and (debuff.hungeringVoid.exists() or not talent.hungeringVoid) or fiendRemain <= cast.time.mindBlast() + gcd) and fiendActive and runeforge.shadowflamePrism.equiped and fiendRemain >= cast.time.mindBlast() then
            if cast.mindBlast(units.dyn40) then ui.debug("Casting Mind Blast [Damage]") return true end
        end
        if charges.mindBlast.count() < 1 and fiendActive and runeforge.shadowflamePrism.equiped and not cd.voidBolt.exists() then
            if cast.mindBlast(units.dyn40) then ui.debug("Casting Mind Blast [Damage]") return true end
        end
    end
    if ui.checked("Void Bolt") and (buff.voidForm.exists() or buff.dissonantEchoes.exists()) then
        if insanity <= 85 and ((talent.hungeringVoid and talent.searingNightmare and mindSearUnitsCount <= 6) or ((talent.hungeringVoid and not talent.searingNightmare) or mindSearUnitsCount == 1)) then
            if buff.dissonantEchoes.exists() then
                if cast.devoidBolt(units.dyn40) then ui.debug("Casting Dissonant Echoes Void Bolt [Damage]") return true end
            else
                if cast.voidBolt(units.dyn40) then ui.debug("Casting Void Bolt [Damage]") return true end
            end
        end
    end
    if ui.checked("Devouring Plague") then
        if (debuff.devouringPlague.refresh(units.dyn40) or insanity > 75) and (not poolForVoidEruption or insanity >= 85) and (not talent.searingNightmare or (talent.searingNightmare and not searingNightmareCutoff)) then
            if cast.devouringPlague(units.dyn40) then ui.debug("Casting Devouring Plague [Damage]") return true end
        end
    end
    if ui.checked("Void Bolt") and (buff.voidForm.exists() or buff.dissonantEchoes.exists()) then
        if mindSearUnitsCount < 4 and ((insanity <= 85 and talent.searingNightmare) or not talent.searingNightmare) then
            if buff.dissonantEchoes.exists() then
                if cast.devoidBolt(units.dyn40) then ui.debug("Casting Dissonant Echoes Void Bolt [Damage]") return true end
            else
                if cast.voidBolt(units.dyn40) then ui.debug("Casting Void Bolt [Damage]") return true end
            end
        end
    end
    if ui.checked("Shadow Word: Death") and cd.shadowWordDeath.ready() then
        if (unit.hp(units.dyn40) < 20 and mindSearUnitsCount < 4) or (fiendActive and runeforge.shadowflamePrism.equiped) then
            if cast.shadowWordDeath(units.dyn40) then ui.debug("Casting Shadow Word: Death [Damage]") return true end
        end
        if ui.checked("Shadow Word: Death Sniping") then
            for i = 1, #enemies.yards40 do
                thisUnit = enemies.yards40[i]
                if (not talent.deathAndMadness and unit.hp(thisUnit) < 20) or (talent.deathAndMadness and unit.hp(thisUnit) and ttd(thisUnit) < 7) then
                    if cast.shadowWordDeath(thisUnit) then ui.debug("Casting Shadow Word: Death Sniping [Damage]") return true end
                end
            end
        end
    end
    if ui.checked("Surrender to Madness") and ui.useCDs() then
        if ttd(units.dyn40) < 25 and not buff.voidForm.exists() then
            if cast.surrenderToMadness(units.dyn40) then ui.debug("Casting Surrender to Madness [Damage]") return true end
        end
    end
    if ui.checked("Void Torrent") and not moving then
        if dotsUp and ttd(units.dyn40) > 3 and (not buff.voidForm.exists() or buff.voidForm.remain() < cd.voidBolt.remain()) and (debuff.vampiricTouch.exists() or not vampiricTouchRefreshable) and not buff.voidForm.exists() and mindSearUnitsCount < 5 then
            if cast.voidTorrent(units.dyn40) then ui.debug("Casting Void Torrent [Damage]") return true end
        end
    end
    if (ui.checked("Mindbender") or ui.checked("Shadowfiend")) and ui.useCDs() then
        if debuff.vampiricTouch.exists() and ((talent.searingNightmare and mindSearUnitsCount >= ui.value("Mind Sear Targets")) or debuff.shadowWordPain.exists()) then
            if ui.checked("Mindbender") and talent.mindbender then
                if cast.mindbender(units.dyn40) then ui.debug("Casting Mindbender [Damage]") return true end
            elseif ui.checked("Shadowfiend") then
                if cast.shadowfiend(units.dyn40) then ui.debug("Casting Shadowfiend [Damage]") return true end
            end
        end
    end
    if ui.checked("Shadow Crash") and talent.shadowCrash and cd.shadowCrash.ready() and unit.valid(units.dyn40) then
        if ttd(units.dyn40) > 3 and not unit.moving(units.dyn40) then
            if cast.shadowCrash("best", nil, 1, 8) then br._G.SpellStopTargeting()ui.debug("Casting Shadow Crash [Damage]") return true end
        end
    end
    if ui.checked("Mind Sear Targets") and not moving then
        if mindSearUnitsCount >= ui.value("Mind Sear Targets") and buff.darkThoughts.exists() then
            if cast.mindSear(mindSearUnit) then ui.debug("Casting Mind Sear [Damage]") return true end
        end
    end
    if ui.checked("Mind Flay") and not moving then
        if buff.darkThoughts.exists() and dotsUp then
            if cast.mindFlay(units.dyn40) then ui.debug("Casting Mind Flay [Damage]") return true end
        end
    end
    if ui.checked("Mind Blast") and not moving then
        if dotsUp and mindSearUnitsCount < 4 and (not runeforge.shadowflamePrism.equiped or not cd.shadowfiend.exists() or debuff.vampiricTouch.exists()) then
            if cast.mindBlast(units.dyn40) then ui.debug("Casting Mind Blast [Damage]") return true end
        end
    end
    if ui.checked("Vampiric Touch Targets") and not moving and vampiricTouchCount < ui.value("Vampiric Touch Targets") and not cast.last.vampiricTouch() and not cast.current.vampiricTouch() then
        if debuff.vampiricTouch.refresh(units.dyn40) and ttd(units.dyn40) > 6 or (talent.misery and debuff.shadowWordPain.refresh(units.dyn40)) or buff.unfurlingDarkness.exists() then
            if cast.vampiricTouch(units.dyn40) then ui.debug("Casting Vampiric Touch [Damage]") return true end
        end
    end
    if ui.checked("Shadow Word: Pain Targets") and shadowWordPainCount < ui.value("Shadow Word: Pain Targets") then
        if debuff.shadowWordPain.refresh(units.dyn40) and ttd(units.dyn40) > 4 and not talent.misery and talent.psychicLink and mindSearUnitsCount > 2 then
            if cast.shadowWordPain(units.dyn40) then ui.debug("Casting Shadow Word: Pain [Damage]") return true end
        end
        if debuff.shadowWordPain.refresh(units.dyn40) and ttd(units.dyn40) > 4 and not talent.misery and not (talent.searingNightmare and mindSearUnitsCount >= ui.value("Mind Sear Targets")) and (not talent.psychicLink or (talent.psychicLink and mindSearUnitsCount <= 2)) then
            if cast.shadowWordPain(units.dyn40) then ui.debug("Casting Shadow Word: Pain [Damage]") return true end
        end
    end
    if ui.checked("Mind Sear Targets") and not moving and mindSearUnitsCount >= ui.value("Mind Sear Targets") then
        if cast.mindSear(mindSearUnit) then ui.debug("Casting Mind Sear [Damage]") return true end
    end
    if ui.checked("Mind Flay") and not moving then
        if cast.mindFlay(units.dyn40) then ui.debug("Casting Mind Flay [Damage]") return true end
    end
    if ui.checked("Shadow Word: Death") then
        if cast.shadowWordDeath(units.dyn40) then ui.debug("Casting Shadow Word: Death [Damage]") return true end
    end
    if ui.checked("Shadow Word: Pain") then
        if cast.shadowWordPain(units.dyn40) then ui.debug("Casting Shadow Word: Pain [Damage]") return true end
    end
end -- End Action List - Damage

----------------
--- ROTATION ---
----------------
local function runRotation()
    -- BR API Locals
    buff = br.player.buff
    cast = br.player.cast
    cd = br.player.cd
    charges = br.player.charges
    covenant = br.player.covenant
    debuff = br.player.debuff
    enemies = br.player.enemies
    friends = br.friend
    gcd = br.player.gcd
    inCombat = br.player.inCombat
    mode = br.player.ui.mode
    moving = br.player.moving
    pet = br.player.pet
    race = br.player.race
    runeforge = br.player.runeforge
    spell = br.player.spell
    talent = br.player.talent
    ui = br.player.ui
    unit = br.player.unit
    units = br.player.units
    var = br.player.variables
    
    -- Custom Variables
    units.get(40)
    enemies.get(30)
    enemies.get(40)
    
    -- Other Locals
    allDotsUp = debuff.shadowWordPain.exists() and debuff.vampiricTouch.exists() and debuff.devouringPlague.exists()
    dotsUp = debuff.shadowWordPain.exists() and debuff.vampiricTouch.exists()
    fiendActive = pet.shadowfiend.exists() or pet.mindbender.exists()
    fiendRemain = 0
    hp = unit.hp("player")
    insanity = br.player.power.insanity.amount()
    lowestUnit = friends[1].unit
    mana = br.player.power.mana.percent()
    mindSearUnit = nil
    mindSearUnitsCount = 0
    mfTicks = br.mfTicks
    msTicks = br.msTicks
    poolForVoidEruption = ui.checked("Void Eruption") and ui.useCDs() and not cd.voidEruption.exists()
    searingNightmareCutoff = false
    shadowWordPainCount = debuff.shadowWordPain.count()
    thisUnit = nil
    vampiricTouchCount = debuff.vampiricTouch.count()
    vampiricTouchRefreshable = debuff.vampiricTouch.refresh(units.dyn40) and ttd(units.dyn40) > 6
    local exists, totemName, startTime, duration, _ = br._G.GetTotemInfo(1)
    if exists then
        fiendRemain = math.max(duration - (br._G.GetTime() - startTime), 0)
    else
        fiendRemain = 0
    end
    local thisGroupCount
    for i = 1, #enemies.yards40 do
        thisUnit = enemies.yards40[i]
        thisGroupCount = #enemies.get(10, thisUnit)
        if thisGroupCount > mindSearUnitsCount then
            mindSearUnitsCount = thisGroupCount
            mindSearUnit = thisUnit
        end
    end
    searingNightmareCutoff = (not buff.voidForm.exists() and mindSearUnitsCount > 2) or (buff.voidForm.exists() and mindSearUnitsCount > 3)
    -- NOTE(Snewy): Sometimes mfTicks/msTicks can be nil so just fix them
    if not mfTicks then
        mfTicks = 0
    end
    if not msTicks then
        msTicks = 0
    end
    
    -- Begin Profile
    if actionList.DamageWhileCasting() then return true end
    if var.profileStop == nil then var.profileStop = false end
    if not inCombat and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (inCombat and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or unit.taxi() or ui.mode.rotation == 4 then
        return true
    else
        if actionList.Dispel() then return true end
        if actionList.Extra() then return true end
        if not inCombat then
            if actionList.PreCombat() then return true end
            if ui.checked("Heal Out of Combat") then
                if actionList.Healing() then return true end
            end
        else
            if actionList.Defensive() then return true end
            if actionList.Interrupt() then return true end
            if actionList.Healing() then return true end
            if actionList.PreCdsDamage() then return true end
            if actionList.Cooldown() then return true end
            if actionList.Damage() then return true end
        end
    end
end -- End runRotation

local id = 258
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
