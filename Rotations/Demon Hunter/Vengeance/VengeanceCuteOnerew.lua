local br = _G["br"]
local rotationName = "reworkdisc"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.soulCleave},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.soulCleave},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shear},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.spectralSight}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.metamorphosis},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.metamorphosis},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.metamorphosis}
    };
   	CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.demonSpikes},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.demonSpikes}
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.consumeMagic},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.consumeMagic}
    };
    CreateButton("Interrupt",4,0)
    -- Mover
    MoverModes = {
        [1] = { mode = "On", value = 2 , overlay = "Auto Movement Enabled", tip = "Will Cast Movement Abilities.", highlight = 1, icon = br.player.spell.infernalStrike},
        [2] = { mode = "Off", value = 1 , overlay = "Auto Movement Disabled", tip = "Will NOT Cast Movement Abilities", highlight = 0, icon = br.player.spell.infernalStrike}
    };
    CreateButton("Mover",5,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Auto Engage
            br.ui:createCheckbox(section, "Auto Engage")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Fel Devastation
            br.ui:createCheckbox(section, "Fel Devastation")
            -- Immolation Aura
            br.ui:createCheckbox(section,"Immolation Aura")
            -- Sigil of Flame
            br.ui:createCheckbox(section,"Sigil of Flame")
            -- Torment
            br.ui:createCheckbox(section,"Torment")
		    -- Consume Magic
            br.ui:createCheckbox(section,"Consume Magic")
            -- Throw Glaive 
            br.ui:createCheckbox(section,"Throw Glaive")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Augment Rune
            br.ui:createCheckbox(section,"Augment Rune")
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Greater Currents","Repurposed Fel Focuser","Inquisitor's Menacing Eye","None"}, 1, "|cffFFFFFFSet Elixir to use.")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Variable Intensity Gigavolt Oscillating Reactor
            br.ui:createCheckbox(section,"Power Reactor", "|cffFFBB00Check to use the Gigavolt Oscillating Reactor Trinket.")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
		    -- Fiery Brand
            br.ui:createSpinner(section, "Fiery Brand",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Demon Spikes
            br.ui:createSpinner(section, "Demon Spikes",  90,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            br.ui:createSpinnerWithout(section, "Hold Demon Spikes", 1, 0, 2, 1, "|cffFFBB00Number of Demon Spikes the bot will hold for manual use.");
            -- Metamorphosis
            br.ui:createSpinner(section, "Metamorphosis",  40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
                        -- Phial of Serenity
            br.ui:createSpinner(section, "Phial of Serenity", 30, 0, 80, 5, "|cffFFFFFFHealth Percent to Cast At")
			-- Sigil of Misery
            br.ui:createSpinner(section, "Sigil of Misery - HP",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            br.ui:createSpinner(section, "Sigil of Misery - AoE", 3, 0, 10, 1, "|cffFFFFFFNumber of Units in 8 Yards to Cast At")
            -- Soul Barrier
            br.ui:createSpinner(section, "Soul Barrier",  70,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Consume Magic
            br.ui:createCheckbox(section, "Disrupt")
            -- Sigil of Silence
            br.ui:createCheckbox(section, "Sigil of Silence")
            -- Sigil of Misery
            br.ui:createCheckbox(section, "Sigil of Misery")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  4)
        -- Cooldown Key Toggle
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
        -- Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
        -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
        -- Mover Key Toggle
            br.ui:createDropdownWithout(section, "Mover Mode", br.dropOptions.Toggle,  6)
        -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
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
-- BR API
local buff
local cast
local cd
local charges
local debuff
local enemies
local equiped
local fury
local has
local item
local talent
local ui
local unit
local units
local use
-- Local Lists
local actionList    = {}
local var           = {}
-- WoW Globals to Varaibles
var.clearTarget     = _G["ClearTarget"]
var.getItemInfo     = _G["GetItemInfo"]
var.getTime         = _G["GetTime"]
var.stopAttack      = _G["StopAttack"]
var.tonumber        = _G["tonumber"]
-- BR Globals to Variables
var.canInterrupt    = _G["canInterrupt"]
var.getCombatTime   = _G["getCombatTime"]
var.hasThreat       = _G["hasThreat"]
var.isTanking       = _G["isTanking"]
var.pause           = _G["pause"]
-- Profile Variables
var.brandBuilt      = false
var.inRaid          = false
var.lastRune        = var.getTime()
var.profileStop     = false

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if var.getCombatTime() >= (var.tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                var.stopAttack()
                var.clearTarget()
                ui.print(var.tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Torment
    if ui.checked("Torment") and cast.able.torment() then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if not var.isTanking(thisUnit) and var.hasThreat(thisUnit) and not unit.isExplosive(thisUnit) then
                if cast.torment(thisUnit) then ui.debug("Casting Torment [Not Tanking]") return true end
            end
        end
    end
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Soul Barrier
        if ui.checked("Soul Barrier") and unit.inCombat() and cast.able.soulBarrier() and unit.hp() < ui.value("Soul Barrier") then
            if cast.soulBarrier() then ui.debug("Casting Soul Barrier") return true end
        end
        -- Demon Spikes
        -- demon_spikes
        if ui.checked("Demon Spikes") and unit.inCombat() and cast.able.demonSpikes() and charges.demonSpikes.count() > ui.value("Hold Demon Spikes") and unit.hp() <= ui.value("Demon Spikes") then
            if (charges.demonSpikes.count() == 2 or not buff.demonSpikes.exists()) and not debuff.fieryBrand.exists(units.dyn5) and not buff.metamorphosis.exists() then
                if cast.demonSpikes() then ui.debug("Casting Demon Spikes") return true end
            end
        end
        -- Metamorphosis
        -- metamorphosis,if=!(talent.demonic.enabled)&(!covenant.venthyr.enabled|!dot.sinful_brand.ticking)|target.time_to_die<15
        if ui.checked("Metamorphosis") and unit.inCombat() and cast.able.metamorphosis() and not buff.demonSpikes.exists()
            and not debuff.fieryBrand.exists(units.dyn5) and not buff.metamorphosis.exists() and unit.hp() <= ui.value("Metamorphosis")
            -- and not talent.demonic and (not covenant.venthyr.enabled or debuff.sinfulBrand.exists(units.dyn5))
        then
            if cast.metamorphosis() then ui.debug("Casting Metamorphosis") return true end
        end
        -- Fiery Brand
        -- fiery_brand
        if ui.checked("Fiery Brand") and unit.inCombat() and unit.hp() <= ui.value("Fiery Brand") then
            if not buff.demonSpikes.exists() and not buff.metamorphosis.exists() then
                if cast.fieryBrand() then ui.debug("Casting Fiery Brand") return true end
            end
        end
        -- Pot/Stoned
        if ui.checked("Pot/Stoned") and unit.hp() <= ui.value("Pot/Stoned") then
            -- Lock Candy
            if has.healthstone() then
                if use.healthstone() then ui.debug("Using Healthstone") return true end
            -- Legion Healthstone (From Starter Zone)
            elseif has.legionHealthstone() then
                if use.legionHealthstone() then ui.debug("Using Legion Healthstone") return true end
            -- Health Potion (Grabs the Highest usable from bags)
            elseif has.item(var.getHealPot) then
                use.item(var.getHealPot)
                ui.debug("Using "..var.getItemInfo(var.getHealPot))
                return true
            end
        end
        -- Heirloom Neck
        if ui.checked("Heirloom Neck") and unit.hp()<= ui.value("Heirloom Neck") then
            if use.able.heirloomNeck() and item.heirloomNeck ~= 0
                and item.heirloomNeck ~= item.manariTrainingAmulet
            then
                if use.heirloomNeck() then ui.debug("Using Heirloom Neck") return true end
            end
        end
        -- Sigil of Misery
        if ui.checked("Sigil of Misery - HP") and cast.able.sigilOfMisery()
            and unit.hp() <= ui.value("Sigil of Misery - HP") and unit.inCombat() and #enemies.yards8 > 0
        then
            if cast.sigilOfMisery("player","ground") then ui.debug("Casting Sigil of Misery [HP]") return true end
        end
        if ui.checked("Sigil of Misery - AoE") and cast.able.sigilOfMisery()
            and #enemies.yards8 >= ui.value("Sigil of Misery - AoE") and unit.inCombat()
        then
            if cast.sigilOfMisery("best",false,ui.value("Sigil of Misery - AoE"),8) then ui.debug("Casting Sigil of Misery [AOE]") return true end
        end
		            -- Phial of Serenity
            if ui.checked("Phial of Serenity") then
                if not unit.inCombat() and not has.phialOfSerenity() and cast.able.summonSteward() then
                    if cast.summonSteward() then ui.debug("Casting Call Steward") return true end
                end
                if unit.inCombat() and use.able.phialOfSerenity() and unit.hp() < ui.value("Phial of Serenity") then
                    if use.phialOfSerenity() then ui.debug("Using Phial of Serenity") return true end
                end
            end
    end -- End Defensive Toggle
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i=1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if var.canInterrupt(thisUnit,ui.value("Interrupt At")) then
                -- Disrupt
                if ui.checked("Disrupt") and cast.able.disrupt(thisUnit) and unit.distance(thisUnit) < 20 then
                    if cast.disrupt(thisUnit) then ui.debug("Casting Disrupt") return true end
                end
                -- Sigil of Silence
                if ui.checked("Sigil of Silence") and cast.able.sigilOfSilence(thisUnit) and cd.disrupt.remain() > 0 then
                    if cast.sigilOfSilence(thisUnit,"ground",1,8) then ui.debug("Casting Sigil of Silence") return true end
                end
                -- Sigil of Misery
                if ui.checked("Sigil of Misery") and cast.able.sigilOfMisery(thisUnit)
                    and cd.disrupt.remain() > 0 and cd.sigilOfSilence.remain() > 0 and cd.sigilOfSilence.remain() < 45
                then
                    if cast.sigilOfMisery(thisUnit,"ground",1,8) then ui.debug("Casting Sigil of Misery [Interrupt]") return true end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if ui.useCDs() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        -- Trinkets
        if ui.checked("Trinkets") and not ui.checked("Power Reactor") and unit.exists("target") and unit.distance("target") < 5 then
            for i = 13, 14 do
                if use.able.slot(i) then
                    use.slot(i)
                    ui.debug("Using Trinket in slot "..i)
                end
            end
        end
    end
    -- Variable Intensity Gigavolt Oscillating Reactor
    if ui.useCDs() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 or #enemies.yards5 >= 4 then
        if ui.checked("Power Reactor") and equiped.vigorTrinket() then
            if buff.vigorEngaged.exists() and buff.vigorEngaged.stack() == 6 and br.timer:useTimer("vigor Engaged Delay", 6) then
                if use.vigorTrinket() then ui.debug("Using Vigor Tricket") return true end
            end
        end
    end -- End ui.useCDs check
    -- sinful_brand,if=!dot.sinful_brand.ticking
    -- the_hunt
    -- fodder_to_the_flame
    -- elysian_decree
end -- End Action List - Cooldowns

-- Action List - FieryBrand
actionList.FieryBrand = function()
    -- -- Sigil of Flame
    -- -- sigil_of_flame,if=cooldown.fiery_brand.remains<2
    -- if ui.checked("Sigil of Flame") and cast.able.sigilOfFlame() and not unit.moving(units.dyn5)
    --     and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 and #enemies.yards5 > 0 and cd.fieryBrand.remain() < 2
    -- then
    --     if cast.sigilOfFlame("best",false,1,8) then ui.debug("Casting Sigil of Flame [Fiery Brand Soon") return true end
    -- end
    -- -- Infernal Strike
    -- -- infernal_strike,if=cooldown.fiery_brand.remains=0
    -- if ui.mode.mover == 1 and cast.able.infernalStrike() and charges.infernalStrike.count() == 2 and not cd.fieryBrand.exists() and #enemies.yards5 > 0 then
    --     if cast.infernalStrike("player","ground",1,6) then ui.debug("Casting Infernal Strike [Fiery Brand Soon]") return true end
    -- end
    -- Fiery Brand
    -- fiery_brand (ignore if checked for defensive use)
    if cast.able.fieryBrand() then
        if cast.fieryBrand() then ui.debug("Casting Fiery Brand") return true end
    end
    -- Fiery Brand Exists
    if debuff.fieryBrand.exists(units.dyn5) then
        -- Immolation Aura
        -- immolation_aura,if=dot.fiery_brand.ticking
        if ui.checked("Immolation Aura") and cast.able.immolationAura() and #enemies.yards5 > 0 then
            if cast.immolationAura() then ui.debug("Casting Immolation Aura [Fiery Brand]") return true end
        end
        -- -- Infernal Strike
        -- -- infernal_strike,if=dot.fiery_brand.ticking
        -- if ui.mode.mover == 1 and cast.able.infernalStrike() and charges.infernalStrike.count() == 2 and #enemies.yards5 > 0 then
        --     if cast.infernalStrike("player","ground",1,6) then ui.debug("Casting Infernal Strike [Fiery Brand]") return true end
        -- end
        -- -- Sigil of Flame
        -- -- sigil_of_flame,if=dot.fiery_brand.ticking
        -- if ui.checked("Sigil of Flame") and cast.able.sigilOfFlame() and not unit.moving(units.dyn5) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 and #enemies.yards5 > 0 then
        --     if cast.sigilOfFlame("best",false,1,8) then ui.debug("Casting Sigil of Flame [Fiery Brand]") return true end
        -- end
    end
end -- End Action List - PreCombat

-- Action List - Normal
actionList.Normal = function()
    -- Infernal Strike
    -- infernal_strike
    if ui.mode.mover == 1 and cast.able.infernalStrike() then
        if cast.infernalStrike("target","ground",1,6) then ui.debug("Casting Infernal Strike") return true end
    end
	if cast.able.elysianDecree() and #enemies.yards5 > 0 then
	        if cast.elysianDecree() then ui.debug("Casting Elysian Decree") return true end
    end
    -- Bulk Extraction
    -- bulk_extraction
    if cast.able.bulkExtraction() then
        if cast.bulkExtraction() then ui.debug("Casting Bulk Extraction") return true end
    end
    -- Spirit Bomb
    -- spirit_bomb,if=((buff.metamorphosis.up&talent.fracture.enabled&soul_fragments>=3)|soul_fragments>=4)
    if cast.able.spiritBomb() and buff.soulFragments.stack() >= 3 then
        if cast.spiritBomb() then ui.debug("Casting Spirit Bomb") return true end
    end
    -- Fel Devastation
    -- fel_devastation
    if ui.checked("Fel Devastation") and cast.able.felDevastation() then
        if cast.felDevastation() then ui.debug("Casting Fel Devastation") return true end
    end
    -- Soul Cleave
    -- soul_cleave,if=((talent.spirit_bomb.enabled&soul_fragments=0)|!talent.spirit_bomb.enabled)&((talent.fracture.enabled&fury>=55)|(!talent.fracture.enabled&fury>=70)|cooldown.fel_devastation.remains>target.time_to_die|(buff.metamorphosis.up&((talent.fracture.enabled&fury>=35)|(!talent.fracture.enabled&fury>=50))))
    if cast.able.soulCleave() and buff.soulFragments.stack() >= 0
    then
        if cast.soulCleave() then ui.debug("Casting Soul Cleave") return true end
    end
    -- Immolation Aura
    -- immolation_aura,if=((variable.brand_build&cooldown.fiery_brand.remains>10)|!variable.brand_build)&fury<=90
    if ui.checked("Immolation Aura") and cast.able.immolationAura("player") and ((var.brandBuild and cd.fieryBrand.remains() > 10) or not var.brandBuild) and fury <= 90 and #enemies.yards5 > 0 then
        if cast.immolationAura("player") then ui.debug("Casting Immolation Aura") return true end
    end
    -- Felblade
    -- felblade,if=pain<=60
    if cast.able.felblade() and fury <= 60 then
        if cast.felblade() then ui.debug("Casting Felblade") return true end
    end
    -- Fracture
    -- fracture,if=((talent.spirit_bomb.enabled&soul_fragments<=3)|(!talent.spirit_bomb.enabled&((buff.metamorphosis.up&fury<=55)|(buff.metamorphosis.down&fury<=70))))
    if cast.able.fracture() and ((talent.spiritBomb and (fury < 30 or buff.soulFragments.stack() <= 3))
        or (not talent.spiritBomb and ((buff.metamorphosis.exists() and fury <= 55) or (not buff.metamorphosis.exists() and fury <= 70))))
    then
        if cast.fracture() then ui.debug("Casting Fracture") return true end
    end
    -- Sigil of Flame
    -- sigil_of_flame,if=!(covenant.kyrian.enabled&runeforge.razelikhs_defilement.equipped)
    if ui.checked("Sigil of Flame") and cast.able.sigilOfFlame() and not unit.moving(units.dyn5) and #enemies.yards5 > 0
        -- and not (covenant.kyrian.enabled() and runeforge.razelikhsDefilement.equiped())
    then
        if cast.sigilOfFlame("best",false,1,8) then ui.debug("Casting Sigil of Flame") return true end
    end
    -- Shear
    -- shear
    if cast.able.shear() then
        if cast.shear() then ui.debug("Casting Shear") return true end
    end
    -- Throw Glaive
    -- throw_glaive
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() then
        if cast.throwGlaive() then ui.debug("Casting Throw Glaive") return true end
    end
end -- End Action List - Normal

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() then
        -- Flask / Crystal
        -- flask
        if ui.value("Elixir") == 1 and var.inRaid and not buff.greaterFlaskOfTheCurrents.exists() and use.able.greaterFlaskOfTheCurrents() then
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.greaterFlaskOfTheCurrents() then ui.debug("Using Greater Flask of the Currents") return true end
        end
        if ui.value("Elixir") == 2 and not buff.felFocus.exists() and use.able.repurposedFelFocuser() then
            if not buff.greaterFlaskOfTheCurrents.exists() then
                if use.repurposedFelFocuser() then ui.debug("Using Repurposed Fel Focuser") return true end
            end
        end
        if ui.value("Elixir") == 3 and not buff.gazeOfTheLegion.exists() and use.able.inquisitorsMenacingEye() then
            if not buff.greaterFlaskOfTheCurrents.exists() then
                if use.inquisitorsMenacingEye() then ui.debug("Using Inquisitor's Menacing Eye") return true end
            end
        end
        -- Battle Scarred Augment Rune
        -- augmentation
        if ui.checked("Augment Rune") and var.inRaid and not buff.battleScarredAugmentation.exists()
            and use.able.battleScarredAugmentRune() and var.lastRune + unit.gcd(true) < var.getTime()
        then
            if use.battleScarredAugmentRune() then ui.debug("Using Battle Scarred Augment Rune") var.lastRune = var.getTime() return true end
        end
        -- Pre-Pull
        if ui.checked("Pre-Pull Timer") and ui.pullTimer()<= ui.value("Pre-Pull Timer") then
            -- Potion
            -- potion
            if ui.value("Potion") ~= 5 and ui.pullTimer()<= 1 and (var.inRaid or var.inInstance) then
                if ui.value("Potion") == 1 and use.able.potionOfUnbridledFury() then
                    use.potionOfUnbridledFury()
                    ui.debug("Using Potion of Unbridled Fury")
                end
            end
            -- Azshara's Font of Power
            -- use_item,name=azsharas_font_of_power
            for i = 13, 14 do
                local opValue = ui.value("Trinkets")
                local iValue = i - 12
                if (opValue == iValue or opValue == 3) and use.able.slot(i) then
                    if use.able.azsharasFontOfPower(i) and equiped.azsharasFontOfPower(i) and ui.pullTimer() <= 5 then
                        use.slot(i)
                        ui.debug("Using Azshara's Font of Power [Pre-Pull]")
                        return
                    end
                end
            end
        end -- End Pre-Pull
        -- Pull
        if unit.valid("target") then
            if unit.reaction("target","player") < 4 then
                -- Throw Glaive
                if ui.checked("Throw Glaive") and cast.able.throwGlaive("target") and #enemies.get(10,"target",true) == 1 and ui.checked("Auto Engage") then
                    if cast.throwGlaive("target","aoe") then ui.debug("Casting Throw Glaive [Pre-Pull]") return true end
                end
                -- Torment
                if cast.able.torment("target") and ui.checked("Auto Engage") then
                    if cast.torment("target") then ui.debug("Casting Torment [Pre-Pull]") return true end
                end
            end
            -- Start Attack
            -- auto_attack
            if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                StartAttack(units.dyn5)
            end
        end -- End Pull
    end -- End No Combat
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()

---------------
--- Defines ---
---------------
    -- BR API
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    equiped                                       = br.player.equiped
    fury                                          = br.player.power.fury.amount()
    has                                           = br.player.has
    item                                          = br.player.items
    talent                                        = br.player.talent
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    -- Variable List
    var.inRaid                                    = br.player.instance=="raid"
    -- Dynamic Units
    units.get(5)
    units.get(8,true)
    units.get(20)
    -- Enemies Listss
    enemies.get(5)
    enemies.get(8)
    enemies.get(30)

    -- variable,name=brand_build,value=talent.agonizing_flames.enabled&talent.burning_alive.enabled&talent.charred_flesh.enabled
    var.brandBuild = talent.agonizingFLames and talent.burningAlive and talent.charredFlesh 

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop==true then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop==true) or unit.mounted() or unit.flying() or var.pause() or ui.mode.rotation==4 then
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return true end
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList.PreCombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if unit.inCombat() and not var.profileStop and unit.valid("target") then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            -- Start Attack
            -- auto_attack
            if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                StartAttack(units.dyn5)
            end
            -- Consume Magic
            if ui.checked("Consume Magic") and cast.able.consumeMagic("target") and cast.dispel.consumeMagic("target") and not unit.isBoss("target") and unit.exists("target") then
                if cast.consumeMagic("target") then ui.debug("Casting Consume Magic") return true end
            end
            -- Throw Glaive
            -- throw_glaive,if=buff.fel_bombardment.stack=5&(buff.immolation_aura.up|!buff.metamorphosis.up)
            if cast.able.throwGlaive() and buff.felBombardment.stack() == 5 and (buff.immolationAura.exists() or not buff.metamorphosis.exists()) then
                if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Fel Bombardment]") return true end
            end
            -- Call Action List - Fiery Brand
            -- call_action_list,name=brand,if=variable.brand_build
            if var.brandBuild then
                if actionList.FieryBrand() then return true end
            end
            -- Call Action List - Defensive
            -- call_action_list,name=defensives
            if actionList.Defensive() then return true end
            -- Call Action List - Cooldowns
            -- call_action_list,name=cooldowns
            if actionList.Cooldowns() then return true end
            -- Call Action List - Normal
            -- call_action_list,name=normal
            if actionList.Normal() then return true end
        end --End In Combat
    end --End Rotation Logic
end -- End runRotation
local id = 581
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
