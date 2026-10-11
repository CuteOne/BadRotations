-- WoW Forever Druid: Cat Form is the main rotation; Bear and Caster/Moonkin are complete but simpler.
-- Forever changes that shape the logic (Wowhead Forever data, 2026-10-11):
--   * Rend and Tear: +20% melee damage on bleeding targets, so a bleed (Rake, Rip, Pounce, Lacerate) stays up.
--   * Tiger's Fury: +15% Physical damage for 6 sec on a 30 sec cooldown, costs nothing.
--   * Omen of Clarity is trained; Clearcasting isn't spent by Wrath, so it goes to Shred/Claw or Starfire.
--   * Berserk: crits on combo point builders, and Primal Bite hits 3 targets with no cooldown.
--   * Eclipse: each Wrath makes the next Starfires 0.5 sec faster.
--   * Hurricane has no cooldown; Nature's Grasp and Shifting Power work while shapeshifted.

---------------
--- Toggles ---
---------------
-- br.ui:toggle(name, { modes = { ... }, key = ... }) adds a button to the toggle bar.
-- Each mode is { name = ..., icon = ..., overlay = ..., tip = ... }; clicking cycles them and the first
-- is the default. Every field is listed in System/UI/Toggles/ToggleFunctions.lua.
local function toggles()
    br.ui:toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto",   icon = "swipe",        overlay = "Automatic Rotation",       tip = "Swaps between Single and Multiple based on number of enemies within 8 yards." },
        { name = "Multi",  icon = "swipe",        overlay = "Multiple Target Rotation", tip = "Forces Multiple Target Rotation." },
        { name = "Single", icon = "claw",         overlay = "Single Target Rotation",   tip = "Forces Single Target Rotation." },
        { name = "Off",    icon = "healingTouch", overlay = "DPS Rotation Disabled",    tip = "Disable DPS Rotation" },
    } })
    br.ui:toggle("Cooldown", { key = "RightCtrl", modes = {
        { name = "Auto", icon = "berserk", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On",   icon = "berserk", overlay = "Cooldowns Enabled",   tip = "Cooldowns used regardless of target." },
        { name = "Off",  icon = "berserk", overlay = "Cooldowns Disabled",  tip = "No Cooldowns will be used." },
    } })
    br.ui:toggle("Defensive", { modes = {
        { name = "On",  icon = "healingTouch", overlay = "Defensive Enabled",  tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "healingTouch", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    br.ui:toggle("Interrupt", { modes = {
        { name = "On",  icon = "bash", overlay = "Interrupts Enabled",  tip = "Includes Basic Interrupts." },
        { name = "Off", icon = "bash", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
    } })
    br.ui:toggle("Forms", { modes = {
        { name = "Auto",   icon = "catForm",  overlay = "Automatic Form", tip = "Bear when your group role is Tank, otherwise Cat, Bear, then Caster - whichever you have learned." },
        { name = "Caster", icon = "wrath",    overlay = "Caster Form",    tip = "Will force and use Caster Form (Moonkin Form once learned, if enabled)" },
        { name = "Cat",    icon = "catForm",  overlay = "Cat Form",       tip = "Will force and use Cat Form (Caster until learned)" },
        { name = "Bear",   icon = "bearForm", overlay = "Bear Form",      tip = "Will force and use Bear Form (Caster until learned)" },
    } })
    br.ui:toggle("Prowl", { modes = {
        { name = "On",  icon = "prowl", overlay = "Prowl Enabled",  tip = "Rotation will use Prowl when near enemies" },
        { name = "Off", icon = "prowl", overlay = "Prowl Disabled", tip = "Rotation will not use Prowl" },
    } })
end

---------------
--- Options ---
---------------
-- br.ui:section(name) starts a group of options; pass it to each option after it.
-- br.ui:checkbox, br.ui:spinner and br.ui:dropdown take the section, the option's name, then any
-- settings to change from their defaults. Spinners and dropdowns have a checkbox unless
-- checkbox = false; checked = true starts it ticked. Every field is listed in System/UI/Elements.
-- Read them in the rotation with ui.checked("Name") and ui.value("Name").
local function options()
    local section = br.ui:section("General")
    br.ui:spinner(section, "Shift Wait Time", { value = 2, max = 5, step = 1, checkbox = false,
        tip = "Time in seconds the profile will wait while moving to shift. Combat is instant!" })
    br.ui:dropdown(section, "Clearcasting Use", { choices = { "Any", "DPS Only", "Healing Only", "None" }, checkbox = false,
        tip = "What Clearcasting (Omen of Clarity) procs should be spent on" })

    section = br.ui:section("Cat Form")
    br.ui:dropdown(section, "Cat Opener", { choices = { "Pounce", "Ravage", "Shred", "Rake" }, value = "Ravage", checkbox = false,
        tip = "Select Spell to Open with from Stealth (falls back to the next learned option)" })
    br.ui:checkbox(section, "Tiger's Fury", { checked = true, tip = "Use Tiger's Fury on cooldown in Cat Form" })
    br.ui:checkbox(section, "Shifting Power", { checked = true, tip = "Use Shifting Power (talent) to convert Mana into Energy in Cat Form" })
    br.ui:checkbox(section, "Feral Charge (Cat)", { checked = true, tip = "Leap behind your target from 8-25 yards in combat (talent)" })
    br.ui:checkbox(section, "Cower", { tip = "In a group, Cower when you pull your target's attention in Cat Form" })

    section = br.ui:section("Bear Form")
    br.ui:checkbox(section, "Bear Opener", { tip = "Open a Bear Form pull with Enrage, Demoralizing Roar, then Maul, in that order" })
    br.ui:checkbox(section, "Feral Charge - Engage", { checked = true, tip = "Charge your target from 8-25 yards in Bear Form" })
    br.ui:checkbox(section, "Growl", { tip = "In a group, taunt an enemy in melee range that is attacking someone else" })
    br.ui:spinner(section, "Challenging Roar", { value = 3, min = 2, max = 10, step = 1,
        tip = "In a group, Challenging Roar when at least this many enemies within 10 yards are attacking others" })

    section = br.ui:section("Caster Form")
    br.ui:checkbox(section, "Moonkin Form", { checked = true, tip = "Use Moonkin Form (talent) when the Forms toggle picks Caster" })
    br.ui:checkbox(section, "Faerie Fire", { tip = "Use Faerie Fire on your target in Caster Form" })
    br.ui:spinner(section, "Hurricane", { value = 3, min = 2, max = 10, step = 1,
        tip = "Channel Hurricane on your target when at least this many enemies are within 8 yards of it" })
    br.ui:checkbox(section, "Hibernate", { tip = "In Caster Form, Hibernate a Beast or Dragonkin attacking you that isn't your target" })

    section = br.ui:section("Form Management")
    br.ui:checkbox(section, "Aquatic Form", { checked = true, tip = "Shift to Aquatic Form while swimming" })
    br.ui:checkbox(section, "Travel Form", { tip = "Shift to Travel Form while moving out of combat" })
    br.ui:spinner(section, "Break Form for Heals Below Energy", { value = 30, min = 1, step = 1, checkbox = false,
        tip = "Only leave Cat Form to heal when Energy is below this" })
    br.ui:spinner(section, "Break Form for Heals Below Rage", { value = 10, min = 1, step = 1, checkbox = false,
        tip = "Only leave Bear Form to heal when Rage is below this" })

    section = br.ui:section("Cooldowns")
    br.ui:dropdown(section, "Berserk", { choices = "AlwaysCdNever", value = "Cooldowns", checkbox = false,
        tip = "When to use Berserk (talent)" })
    br.ui:spinner(section, "Innervate", { value = 30, min = 5, checked = true, tip = "Self-Innervate at or below this Mana Percent" })

    section = br.ui:section("Buffs")
    br.ui:dropdown(section, "Mark of the Wild", { choices = { "Player", "Target", "Mouseover", "Focus", "Group" }, checked = true,
        tip = "Set how to use Mark of the Wild" })
    br.ui:dropdown(section, "Thorns", { choices = { "Player", "Target", "Mouseover", "Focus", "Group" }, checked = true,
        tip = "Set how to use Thorns" })

    section = br.ui:section("Defensive")
    br.ui:checkbox(section, "Self Heal In Group", { checked = true, tip = "Enable/Disable Healing Self while Grouped" })
    br.ui:dropdown(section, "Heal Others", { choices = { "Player", "Target", "Mouseover", "Focus" }, checkbox = false,
        tip = "Besides yourself, also heal this friendly player with the heals below (Player: only yourself)" })
    br.ui:dropdown(section, "Heal Others Key", { choices = "Toggle", value = "None", checkbox = false,
        tip = "Only heal the Heal Others unit while this key is held (None: no key needed)" })
    br.ui:spinner(section, "Healing Touch", { value = 35, checked = true, tip = "Health Percent to Cast At" })
    br.ui:checkbox(section, "Nature's Swiftness", { checked = true, tip = "Make an emergency Healing Touch instant with Nature's Swiftness (talent)" })
    br.ui:spinner(section, "Regrowth", { value = 55, checked = true, tip = "Health Percent to Cast At (Swiftmend first when a heal over time is on you)" })
    br.ui:spinner(section, "Rejuvenation", { value = 70, checked = true, tip = "Health Percent to Cast At" })
    br.ui:spinner(section, "Barkskin", { value = 65, checked = true, tip = "Health Percent to Cast At" })
    br.ui:spinner(section, "Frenzied Regeneration", { value = 45, checked = true, tip = "Health Percent to Cast At (Bear Form)" })
    br.ui:spinner(section, "Bash", { value = 35, tip = "Health Percent to stun your target at (Bear Form)" })
    br.ui:checkbox(section, "Cure Poison", { checked = true, tip = "Cure poisons on yourself (uses Abolish Poison once learned)" })
    br.ui:checkbox(section, "Remove Curse", { checked = true, tip = "Remove curses on yourself out of combat" })
    br.ui:checkbox(section, "Entangling Roots", { tip = "Enable/Disable Using Entangling Roots on fleeing enemies" })
    br.ui:spinner(section, "Nature's Grasp", { value = 40,
        tip = "Escape tool: cast at or below this Health Percent while running from an enemy chasing you within 10 yards. The root breaks on damage, so it's meant for fleeing, not fighting." })
    br.ui:spinner(section, "Dash", { value = 40, tip = "Escape tool: Dash in Cat Form at or below this Health Percent while running from an enemy chasing you" })

    section = br.ui:section("Group")
    br.ui:checkbox(section, "Revive", { checked = true, tip = "Revive dead party members out of combat" })
    br.ui:dropdown(section, "Rebirth", { choices = { "Tank", "Healer", "Tank or Healer", "Anyone" }, value = "Tank or Healer",
        tip = "Who to Rebirth in combat" })

    section = br.ui:section("Interrupts")
    br.ui:checkbox(section, "Bash - Int", { checked = true, tip = "Interrupt with Bash while in Bear Form" })
    br.ui:checkbox(section, "Bash - Shift to Bear", { tip = "Allow leaving Cat/Caster Form to Bash (costs Mana and your Energy)" })
    br.ui:checkbox(section, "Feral Charge - Int", { checked = true, tip = "Interrupt with Feral Charge (Bear) from 8-25 yards" })
    br.ui:spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percent to Cast At (0 is random)" })

    section = br.ui:section("Druid Debug")
    br.ui:checkbox(section, "Behind Debug", { tip = "Debug behind/facing checks for Shred/Ravage." })
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local cast
local cd
local comboPoints
local debuff
local enemies
local energy
local mana
local rage
local ui
local unit
local units
local spell
local var = {}
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local profileStop
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}
local activeForm
local freeDPS
local freeHeal
local inForm
local noShapeshiftPower

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
local function debugBehind(label, thisUnit)
    if ui == nil or ui.checked == nil or not ui.checked("Behind Debug") then return end
    if thisUnit == nil or not unit.exists(thisUnit) then return end
    local targetName = unit.exists("target") and unit.name("target") or "none"
    local thisName = unit.name(thisUnit) or tostring(thisUnit)
    local isTarget = unit.exists("target") and unit.isUnit(thisUnit, "target")
    local dist = unit.distance(thisUnit) or -1

    -- Engine-facing results
    local facingPlayer = unit.facing(thisUnit, "player")
    local behindPlayer = unit.isBehind(thisUnit, "player")

    -- Raw unlocker-facing check (front 180 cone)
    local rawFacing180
    if br and br._G and br._G.ObjectIsFacing then
        local ok, res = pcall(br._G.ObjectIsFacing, thisUnit, "player", 180)
        rawFacing180 = ok and res or nil
    end

    ui.debug(string.format(
        "%s | unit=%s (isTarget=%s, dist=%.1f) | target=%s | facingPlayer=%s | behindPlayer=%s | rawFacing180=%s",
        tostring(label), tostring(thisName), tostring(isTarget), tonumber(dist) or -1, tostring(targetName),
        tostring(facingPlayer), tostring(behindPlayer), tostring(rawFacing180)
    ))
end

-- Resolve the Forms toggle (Auto/Caster/Cat/Bear) into a form we can actually use. A forced form
-- that isn't learned yet falls back to Caster; Caster becomes Moonkin once it's learned (option).
local function resolveForm()
    local mode = ui.mode.forms
    local hasCat = spell.catForm.known()
    local hasBear = spell.bearForm.known()
    local form = "caster"
    if mode == 1 then
        if hasBear and unit.role("player") == "TANK" then form = "bear"
        elseif hasCat then form = "cat"
        elseif hasBear then form = "bear" end
    elseif mode == 3 and hasCat then form = "cat"
    elseif mode == 4 and hasBear then form = "bear" end
    if form == "caster" and ui.checked("Moonkin Form") and spell.moonkinForm.known() then form = "moonkin" end
    return form
end

-- Gift of the Wild is a differently named aura, so buff.markOfTheWild misses it and a recast
-- fails with "A more powerful spell is already active". Treat it as satisfying Mark of the Wild.
local function needsMarkOfTheWild(thisUnit)
    if buff.giftOfTheWild.exists(thisUnit) and not buff.giftOfTheWild.refresh(thisUnit) then return false end
    return buff.markOfTheWild.refresh(thisUnit)
end

-- Casts a Caster Form spell, leaving the current form first when it blocks the spell: Cat, Bear,
-- Travel and Aquatic Form block every caster spell, Moonkin Form blocks heals. free: Clearcasting
-- makes the spell free; emergency: leave the form even when shifting back isn't affordable.
local function casterCast(spellKey, thisUnit, label, free, emergency, isHeal)
    if inForm or (isHeal and buff.moonkinForm.exists()) then
        return unit.cancelFormFor(spell[spellKey], free, emergency)
    end
    if cast[spellKey](thisUnit) then
        ui.debug("Casting " .. label)
        return true
    end
    return false
end

-- The friendly player to heal besides yourself: the Heal Others unit (target, mouseover or focus),
-- when there is one in range, alive and not you, and its key (if set) is held; nil otherwise
local healOthersUnits = { [2] = "target", [3] = "mouseover", [4] = "focus" }
local function healOthersUnit()
    local thisUnit = healOthersUnits[ui.value("Heal Others")]
    if thisUnit == nil then return nil end
    if br.ui.dropOptions.Toggle[ui.value("Heal Others Key")] ~= "None" and not ui.toggle("Heal Others Key") then return nil end
    if unit.exists(thisUnit) and unit.friend(thisUnit) and unit.player(thisUnit) and not unit.deadOrGhost(thisUnit)
        and not unit.isUnit(thisUnit, "player") and unit.distance(thisUnit) < 40
    then
        return thisUnit
    end
    return nil
end

-- A Beast or Dragonkin fighting the player that isn't the target (Hibernate)
local function hibernateTarget(thisUnit)
    return (unit.beast(thisUnit) or unit.dragonkin(thisUnit)) and not unit.isUnit(thisUnit, "target")
        and unit.isTanking(thisUnit) and cast.able.hibernate(thisUnit)
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Buffs
actionList.Buffs = function()
    if unit.inCombat() or unit.resting() then return false end
    -- Mark of the Wild
    if ui.checked("Mark of the Wild") then
        var.markUnit = ui.buffUnit("Mark of the Wild", needsMarkOfTheWild, 30)
        if cast.able.markOfTheWild(var.markUnit) and needsMarkOfTheWild(var.markUnit)
            and unit.distance(var.markUnit) < 30 and (var.markUnit == "player" or unit.player(var.markUnit))
        then
            if casterCast("markOfTheWild", var.markUnit, "Mark of the Wild") then return true end
        end
    end
    -- Thorns
    if ui.checked("Thorns") then
        var.thornUnit = ui.buffUnit("Thorns", buff.thorns.refresh, 30)
        if cast.able.thorns(var.thornUnit) and buff.thorns.refresh(var.thornUnit)
            and unit.distance(var.thornUnit) < 30 and (var.thornUnit == "player" or unit.player(var.thornUnit))
        then
            if casterCast("thorns", var.thornUnit, "Thorns") then return true end
        end
    end
end -- End Action List - Buffs

-- Action List - Forms: Aquatic and Travel Form out of combat, then the form the Forms toggle picks.
-- Runs after Buffs, Defensive and Utility, so a buff or heal that needs Caster Form goes first; the
-- toggle's form waits out the GCD and any cast so it doesn't shift in just before one of those leaves again.
actionList.Forms = function()
    -- Aquatic Form
    if ui.checked("Aquatic Form") and not unit.inCombat() and cast.able.aquaticForm()
        and unit.swimming() and not buff.aquaticForm.exists() and not buff.prowl.exists()
        and unit.moving() and unit.movingTime() > 2 and not unit.anyInAggroRange()
    then
        if buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.moonkinForm.exists() then
            if unit.cancelFormFor(spell.aquaticForm) then return true end
        end
        if cast.aquaticForm() then
            ui.debug("Casting Aquatic Form")
            return true
        end
    end
    -- Travel Form
    if ui.checked("Travel Form") and not unit.inCombat() and not unit.mounted()
        and not unit.swimming() and not unit.falling() and cast.able.travelForm()
        and not buff.travelForm.exists() and not buff.prowl.exists()
        and unit.moving() and unit.movingTime() > 2 and not unit.anyInAggroRange()
    then
        if buff.catForm.exists() or buff.bearForm.exists() or buff.moonkinForm.exists() then
            if unit.cancelFormFor(spell.travelForm) then return true end
        end
        if cast.travelForm() then
            ui.debug("Casting Travel Form")
            return true
        end
    end
    -- Form from the Forms toggle
    local keepAquatic = ui.checked("Aquatic Form") and unit.swimming() and buff.aquaticForm.exists()
        and not unit.anyInAggroRange() and (not unit.exists("target") or unit.friend("target"))
    if keepAquatic or buff.travelForm.exists() or unit.gcd() > 0 or unit.isCasting("player") then return false end
    if not ((unit.moving() and unit.movingTime() > ui.value("Shift Wait Time")) or unit.inCombat() or unit.anyInAggroRange(5)) then
        return false
    end
    -- Bear Form
    if activeForm == "bear" and cast.able.bearForm() and not buff.bearForm.exists() then
        if cast.bearForm() then
            ui.debug("Casting Bear Form")
            return true
        end
    end
    -- Cat Form
    if activeForm == "cat" and cast.able.catForm() and not buff.catForm.exists() then
        if cast.catForm() then
            ui.debug("Casting Cat Form")
            return true
        end
    end
    -- Moonkin Form
    if activeForm == "moonkin" and cast.able.moonkinForm() and not buff.moonkinForm.exists() then
        if cast.moonkinForm() then
            ui.debug("Casting Moonkin Form")
            return true
        end
    end
    -- Caster Form
    if activeForm == "caster" and (buff.bearForm.exists() or buff.catForm.exists() or buff.moonkinForm.exists()) then
        if unit.cancelForm() then
            ui.debug("Casting Caster Form")
            return true
        end
    end
end -- End Action List - Forms

-- Action List - Defensive
actionList.Defensive = function()
    if not ui.useDefensive() then return false end
    local inGroupOk = not unit.inGroup() or ui.checked("Self Heal In Group")
    -- Cure Poison (Abolish Poison once learned)
    if ui.checked("Cure Poison") then
        if spell.abolishPoison.known() then
            if cast.able.abolishPoison("player") and not buff.abolishPoison.exists("player") and cast.dispel.abolishPoison("player") then
                if casterCast("abolishPoison", "player", "Abolish Poison") then return true end
            end
        elseif cast.able.curePoison("player") and cast.dispel.curePoison("player") then
            if casterCast("curePoison", "player", "Cure Poison") then return true end
        end
    end
    -- Remove Curse
    if ui.checked("Remove Curse") and not unit.inCombat() and cast.able.removeCurse("player") and cast.dispel.removeCurse("player") then
        if casterCast("removeCurse", "player", "Remove Curse") then return true end
    end
    if unit.inCombat() then
        -- Barkskin
        if ui.checked("Barkskin") and cast.able.barkskin() and unit.hp() <= ui.value("Barkskin") then
            if cast.barkskin() then
                ui.debug("Casting Barkskin")
                return true
            end
        end
        -- Frenzied Regeneration (spends Rage, so only with some to spend)
        if ui.checked("Frenzied Regeneration") and buff.bearForm.exists() and cast.able.frenziedRegeneration()
            and unit.hp() <= ui.value("Frenzied Regeneration") and rage >= 10
        then
            if cast.frenziedRegeneration() then
                ui.debug("Casting Frenzied Regeneration")
                return true
            end
        end
        -- Nature's Grasp: escape tool, the root breaks on damage (castable while shapeshifted)
        if ui.checked("Nature's Grasp") and cast.able.naturesGrasp() and not buff.naturesGrasp.exists("player")
            and unit.hp() <= ui.value("Nature's Grasp") and unit.chased(10)
        then
            if cast.naturesGrasp("player") then
                ui.debug("Casting Nature's Grasp")
                return true
            end
        end
        -- Dash: escape tool in Cat Form
        if ui.checked("Dash") and buff.catForm.exists() and cast.able.dash() and not buff.dash.exists()
            and unit.hp() <= ui.value("Dash") and unit.chased(10)
        then
            if cast.dash() then
                ui.debug("Casting Dash")
                return true
            end
        end
        -- Entangling Roots (fleeing enemies)
        if ui.checked("Entangling Roots") and cast.able.entanglingRoots("target") and unit.isFleeing("target")
            and unit.valid("target") and unit.hp("target") < 100 and not debuff.entanglingRoots.exists("target")
            and unit.distance("target") > 8 and not unit.moving()
        then
            if casterCast("entanglingRoots", "target", "Entangling Roots", freeDPS) then return true end
        end
        -- Bash (low health stun)
        if ui.checked("Bash") and unit.hp() <= ui.value("Bash") and buff.bearForm.exists() and cast.able.bash("target") then
            if cast.bash("target") then
                ui.debug("Casting Bash [Defensive]")
                return true
            end
        end
        -- Cower: in a group, when the target turns on you in Cat Form
        if ui.checked("Cower") and unit.inGroup() and buff.catForm.exists() and cast.able.cower("target")
            and unit.threatStatus() >= 2 and unit.role("player") ~= "TANK"
        then
            if cast.cower("target") then
                ui.debug("Casting Cower")
                return true
            end
        end
    end
    -- Heals: you first, then the Heal Others unit (if any) at the same thresholds
    local other = var.healOther
    local otherName = other and (" on " .. unit.name(other)) or ""
    -- Healing Touch: the emergency heal, leaves any form regardless of Energy/Rage. Nature's Swiftness
    -- (off the GCD) makes it instant.
    if ui.checked("Healing Touch") and not cast.current.healingTouch() then
        local selfLow = inGroupOk and unit.hp() <= ui.value("Healing Touch")
        local otherLow = other ~= nil and unit.hp(other) <= ui.value("Healing Touch")
        if (selfLow or otherLow) and ui.checked("Nature's Swiftness") and unit.inCombat() and not inForm
            and not buff.moonkinForm.exists() and cast.able.naturesSwiftness() and not buff.naturesSwiftness.exists()
        then
            if cast.naturesSwiftness() then
                ui.debug("Casting Nature's Swiftness")
                return true
            end
        end
        if not unit.moving() or buff.naturesSwiftness.exists() then
            if selfLow and cast.able.healingTouch("player") then
                if casterCast("healingTouch", "player", "Healing Touch", freeHeal, true, true) then return true end
            end
            if otherLow and cast.able.healingTouch(other) then
                if casterCast("healingTouch", other, "Healing Touch" .. otherName, freeHeal, true, true) then return true end
            end
        end
    end
    -- Swiftmend / Regrowth: leaves Cat or Bear Form only when Energy/Rage is low or the heal is free
    if ui.checked("Regrowth") and (freeHeal or noShapeshiftPower) then
        for i = 1, 2 do -- you, then the Heal Others unit
            local thisUnit = i == 1 and "player" or other
            if thisUnit ~= nil and (i == 2 or inGroupOk) and unit.hp(thisUnit) <= ui.value("Regrowth") then
                local label = i == 1 and "" or otherName
                if cast.able.swiftmend(thisUnit) and (buff.rejuvenation.exists(thisUnit) or buff.regrowth.exists(thisUnit)) then
                    if casterCast("swiftmend", thisUnit, "Swiftmend" .. label, freeHeal, false, true) then return true end
                end
                if cast.able.regrowth(thisUnit) and not cast.current.regrowth() and not unit.moving() and not buff.regrowth.exists(thisUnit) then
                    if casterCast("regrowth", thisUnit, "Regrowth" .. label, freeHeal, false, true) then return true end
                end
            end
        end
    end
    -- Rejuvenation: too slow to justify two shapeshifts in combat
    if ui.checked("Rejuvenation") and (not unit.inCombat() or not inForm) then
        if unit.hp() <= ui.value("Rejuvenation") and buff.rejuvenation.refresh("player") and not buff.clearcasting.exists()
            and (unit.solo() or ui.checked("Self Heal In Group")) and cast.able.rejuvenation("player")
        then
            if casterCast("rejuvenation", "player", "Rejuvenation", freeHeal, false, true) then return true end
        end
        if other ~= nil and unit.hp(other) <= ui.value("Rejuvenation") and buff.rejuvenation.refresh(other)
            and cast.able.rejuvenation(other)
        then
            if casterCast("rejuvenation", other, "Rejuvenation" .. otherName, freeHeal, false, true) then return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Utility: bringing group members back, taunts and crowd control
actionList.Utility = function()
    -- Revive (out of combat, 10 sec cast)
    if ui.checked("Revive") and not unit.inCombat() and unit.inGroup() and not unit.moving() then
        local thisUnit = unit.deadGroupMember(30)
        if thisUnit and cast.able.revive.dead(thisUnit) then
            if inForm or buff.moonkinForm.exists() then
                if unit.cancelFormFor(spell.revive) then return true end
            elseif cast.revive.dead(thisUnit) then
                ui.debug("Casting Revive on " .. unit.name(thisUnit))
                return true
            end
        end
    end
    if not unit.inCombat() then return false end
    -- Rebirth (in combat)
    if ui.checked("Rebirth") and unit.inGroup() and not unit.moving() then
        -- Rebirth: 1 Tank, 2 Healer, 3 Tank or Healer, 4 Anyone
        local choice = ui.value("Rebirth")
        local thisUnit
        if choice == 1 then thisUnit = unit.deadGroupMember(30, "TANK")
        elseif choice == 2 then thisUnit = unit.deadGroupMember(30, "HEALER")
        elseif choice == 3 then thisUnit = unit.deadGroupMember(30, "TANK", "HEALER")
        else thisUnit = unit.deadGroupMember(30) end
        if thisUnit and cast.able.rebirth.dead(thisUnit) then
            if inForm or buff.moonkinForm.exists() then
                if unit.cancelFormFor(spell.rebirth) then return true end
            elseif cast.rebirth.dead(thisUnit) then
                ui.debug("Casting Rebirth on " .. unit.name(thisUnit))
                return true
            end
        end
    end
    -- Growl: an enemy in melee range attacking someone else
    if ui.checked("Growl") and unit.inGroup() and buff.bearForm.exists() and cast.able.growl() then
        local thisUnit = enemies.first(enemies.yards5, unit.attackingOthers)
        if thisUnit and cast.growl(thisUnit) then
            ui.debug("Casting Growl on " .. unit.name(thisUnit))
            return true
        end
    end
    -- Challenging Roar: several enemies around you attacking others
    if ui.checked("Challenging Roar") and unit.inGroup() and buff.bearForm.exists() and cast.able.challengingRoar()
        and enemies.count(enemies.yards10, unit.attackingOthers) >= ui.value("Challenging Roar")
    then
        if cast.challengingRoar() then
            ui.debug("Casting Challenging Roar")
            return true
        end
    end
    -- Hibernate: a Beast or Dragonkin add while you fight your target (Caster/Moonkin Form only)
    if ui.checked("Hibernate") and not inForm and not unit.moving() and debuff.hibernate.count() == 0 and #enemies.yards30 > 1 then
        local thisUnit = enemies.first(enemies.yards30, hibernateTarget)
        if thisUnit and cast.hibernate(thisUnit) then
            ui.debug("Casting Hibernate on " .. unit.name(thisUnit))
            return true
        end
    end
end -- End Action List - Utility

-- Action List - Interrupts
actionList.Interrupts = function()
    if not (ui.useInterrupt() and ui.delay("Interrupts", unit.gcd(true))) then return false end
    local thisUnit
    local inBear = buff.bearForm.exists()
    local interruptAt = ui.value("Interrupt At")
    -- Feral Charge (Bear) - 8 to 25 yards
    if ui.checked("Feral Charge - Int") and inBear then
        local chargeKey = spell.feralChargeBear.known() and "feralChargeBear" or "feralCharge"
        if cast.able[chargeKey]() then
            enemies.get(25)
            thisUnit = enemies.first(enemies.yards25, function(thisUnit)
                return unit.distance(thisUnit) >= 8 and unit.interruptable(thisUnit, interruptAt)
                    and cast.able[chargeKey](thisUnit)
            end)
            if thisUnit and cast[chargeKey](thisUnit) then
                ui.debug("Casting Feral Charge on " .. unit.name(thisUnit))
                return true
            end
        end
    end
    -- Bash
    if ui.checked("Bash - Int") and (inBear or ui.checked("Bash - Shift to Bear")) and cd.bash.remain() == 0 then
        thisUnit = enemies.first(enemies.yards5f, function(thisUnit)
            return unit.interruptable(thisUnit, interruptAt) and (not inBear or cast.able.bash(thisUnit))
        end)
        if thisUnit then
            -- Bash requires Bear Form; only shift when the player allowed it.
            if not inBear then
                if cast.able.bearForm() and cast.bearForm() then
                    ui.debug("Shifting to Bear Form for Bash interrupt")
                    return true
                end
            elseif cast.bash(thisUnit) then
                ui.debug("Casting Bash on " .. unit.name(thisUnit))
                return true
            end
        end
    end
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- Innervate (mana management, not gated by the Cooldown toggle)
    if ui.checked("Innervate") and cast.able.innervate("player") and mana <= ui.value("Innervate") then
        if cast.innervate("player") then
            ui.debug("Casting Innervate")
            return true
        end
    end
    -- Berserk (talent): in Cat or Bear Form, on a target worth it; in Bear Form also for 3+ enemies
    -- (Primal Bite hits 3 targets with no cooldown)
    if cast.able.berserk() and (buff.catForm.exists() or buff.bearForm.exists())
        and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5
        and (ui.alwaysCdNever("Berserk") and unit.ttd(units.dyn5) > 15
            or (buff.bearForm.exists() and ui.value("Berserk") ~= 3 and #enemies.yards8 >= 3))
    then
        if cast.berserk() then
            ui.debug("Casting Berserk")
            return true
        end
    end
end -- End Action List - Cooldowns

-- Action List - Bear Opener: Enrage, Demoralizing Roar, then Maul, in that order. Each cast.opener
-- line waits its turn; a step whose condition is false is passed over.
actionList.BearOpener = function()
    if not buff.bearForm.exists() then return false end
    if not unit.valid("target") or unit.deadOrGhost("target") or unit.distance("target") >= 5 then return false end
    -- Enrage
    if not buff.enrage.exists() and rage < 10 then
        if cast.opener.enrage() then
            ui.debug("Casting Enrage [Opener]")
            return true
        end
    end
    -- Demoralizing Roar
    if debuff.demoralizingRoar.refreshCount(10) > 0 then
        if cast.opener.demoralizingRoar.aoe(10) then
            ui.debug("Casting Demoralizing Roar [Opener]")
            return true
        end
    end
    -- Maul
    if cast.opener.maul("target") then
        ui.debug("Casting Maul [Opener]")
        return true
    end
end -- End Action List - Bear Opener

-- Action List - Bear Form
actionList.BearForm = function()
    -- Enrage: Rage when starved (costs armor, so not at low health)
    if cast.able.enrage() and not buff.enrage.exists() and rage < 10 and unit.hp() > 60 then
        if cast.enrage() then
            ui.debug("Casting Enrage")
            return true
        end
    end
    -- Primal Bite (talent): high threat on a 6 sec cooldown; Berserk makes it hit 3 targets with no cooldown
    if cast.able.primalBite(units.dyn5) then
        if cast.primalBite(units.dyn5) then
            ui.debug("Casting Primal Bite")
            return true
        end
    end
    -- Demoralizing Roar: an AoE around the player (10 yards), when any enemy in reach needs it, not
    -- just the target. As an AoE cast it won't go off while a mob that isn't fighting us is in reach.
    if cast.able.demoralizingRoar.aoe(10) and debuff.demoralizingRoar.refreshCount(10) > 0 then
        if cast.demoralizingRoar.aoe(10) then
            ui.debug("Casting Demoralizing Roar")
            return true
        end
    end
    -- Swipe (multi-target, hits 3)
    if cast.able.swipe() and ui.useAOE(8, 3) then
        if cast.swipe() then
            ui.debug("Casting Swipe")
            return true
        end
    end
    -- Lacerate: a bleed (Rend and Tear) with high threat; stack to 5, refresh before it falls off
    if cast.able.lacerate(units.dyn5) and unit.ttd(units.dyn5) > 6
        and (debuff.lacerate.stack(units.dyn5) < 5 or debuff.lacerate.remain(units.dyn5) < 4)
    then
        if cast.lacerate(units.dyn5) then
            ui.debug("Casting Lacerate")
            return true
        end
    end
    -- Maul: on the next swing, with Rage left over for Primal Bite when it's nearly ready
    local reserve = (spell.primalBite.known() and cd.primalBite.remain() < 2) and 20 or 0
    if cast.able.maul(units.dyn5) and rage >= 15 + reserve and (ui.useST(8, 3) or not spell.swipe.known() or rage >= 40) then
        if cast.maul(units.dyn5) then
            ui.debug("Casting Maul")
            return true
        end
    end
end -- End Action List - Bear Form

-- Action List - Cat Opener (Stealth + Non-Stealth)
actionList.CatOpener = function()
    if not buff.catForm.exists() then return false end
    if not unit.valid("target") or unit.deadOrGhost("target") or unit.distance("target") >= 5 then return false end
    if unit.player("target") then return false end

    -- Tiger's Fury before the opening hit
    if ui.checked("Tiger's Fury") and cast.able.tigersFury() and not buff.tigersFury.exists() then
        if cast.tigersFury() then
            ui.debug("Casting Tiger's Fury [Opener]")
            return true
        end
    end

    local opener = ui.value("Cat Opener")

    -- Stealth Opener
    if buff.prowl.exists() then
        -- Pounce (Opener 1)
        if opener == 1 and cast.able.pounce() then
            if cast.pounce("target") then
                ui.debug("Casting Pounce [Stealth Opener]")
                return true
            end
        end
        -- Ravage from behind (Opener 2 or fallback)
        if (opener == 2 or (opener <= 1 and not spell.pounce.known()))
            and cast.able.ravage() and unit.isBehind("target", "player")
        then
            if cast.ravage("target") then
                ui.debug("Casting Ravage [Stealth Opener]")
                return true
            end
        end
        -- Shred from behind (Opener 3 or fallback)
        if (opener == 3 or (opener <= 2 and not spell.ravage.known()))
            and cast.able.shred() and unit.isBehind("target", "player") and not unit.facing("target", "player")
        then
            if cast.shred("target") then
                ui.debug("Casting Shred [Stealth Opener]")
                return true
            end
        end
        -- Rake (Opener 4 or fallback)
        if (opener == 4 or (opener <= 3 and not spell.shred.known())) and cast.able.rake() then
            if cast.rake("target") then
                ui.debug("Casting Rake [Stealth Opener]")
                return true
            end
        end
        -- Claw (ultimate fallback)
        if not spell.rake.known() and cast.able.claw() then
            if cast.claw("target") then
                ui.debug("Casting Claw [Stealth Opener]")
                return true
            end
        end
        return false
    end

    -- Non-Stealth Opener
    local behindTarget = unit.isBehind("target", "player")
    -- Shred (from behind)
    if behindTarget and cast.able.shred() and not unit.facing("target", "player") then
        if cast.shred("target") then
            ui.debug("Casting Shred [Opener]")
            return true
        end
    end
    -- Claw (fallback)
    if cast.able.claw() and (not spell.shred.known() or not behindTarget) then
        if cast.claw("target") then
            ui.debug("Casting Claw [Opener]")
            return true
        end
    end
    return false
end -- End Action List - Cat Opener

-- Action List - Cat Form
actionList.CatForm = function()
    local thisUnit = units.dyn5
    local ttd = unit.ttd(thisUnit)
    local behind = unit.isBehind(thisUnit, "player") and not unit.facing(thisUnit, "player")
    if behind then debugBehind("Builders behind=true", thisUnit) end
    local finish = spell.ferociousBite.kills(thisUnit)

    -- Ferocious Bite - Finish Him!
    if finish and cast.able.ferociousBite(thisUnit) and energy >= 35 then
        if cast.ferociousBite(thisUnit) then
            ui.debug("Casting Ferocious Bite [Finish Him!]")
            return true
        end
    end
    -- Tiger's Fury: +15% Physical damage (bleeds included) on cooldown; costs nothing
    if ui.checked("Tiger's Fury") and cast.able.tigersFury() and not buff.tigersFury.exists() then
        if cast.tigersFury() then
            ui.debug("Casting Tiger's Fury")
            return true
        end
    end
    -- Shifting Power (talent): 40 Energy for Mana, when it won't overcap
    if ui.checked("Shifting Power") and cast.able.shiftingPower() and energy <= 60 and not buff.clearcasting.exists() then
        if cast.shiftingPower() then
            ui.debug("Casting Shifting Power")
            return true
        end
    end

    -- Finishers
    if comboPoints == 5 or (comboPoints >= 3 and ttd < 6) then
        -- Rip: 12 sec bleed (Rend and Tear), on a target that outlives it
        if comboPoints == 5 and cast.able.rip(thisUnit) and ttd > 10 and debuff.rip.refresh(thisUnit) then
            if cast.rip(thisUnit) then
                ui.debug("Casting Rip")
                return true
            end
        end
        -- Ferocious Bite: at 35 Energy rather than pooling, or early on a target about to die
        if cast.able.ferociousBite(thisUnit) and energy >= 35 then
            if cast.ferociousBite(thisUnit) then
                ui.debug("Casting Ferocious Bite")
                return true
            end
        end
        if spell.ferociousBite.known() then return false end -- pool for the finisher
    end

    -- Combo Point Builders
    -- Ravage (from Prowl)
    if buff.prowl.exists() and behind and cast.able.ravage(thisUnit) then
        if cast.ravage(thisUnit) then
            ui.debug("Casting Ravage")
            return true
        end
    end
    -- Clearcasting: spend the free hit on the most expensive builder
    if freeDPS then
        if behind and cast.able.shred(thisUnit) then
            if cast.shred(thisUnit) then
                ui.debug("Casting Shred [Clearcasting]")
                return true
            end
        end
        if cast.able.claw(thisUnit) then
            if cast.claw(thisUnit) then
                ui.debug("Casting Claw [Clearcasting]")
                return true
            end
        end
    end
    -- Rake: keep a bleed up on anything that lives long enough (Rend and Tear)
    if cast.able.rake(thisUnit) and debuff.rake.refresh(thisUnit) and ttd > 6 then
        if cast.rake(thisUnit) then
            ui.debug("Casting Rake")
            return true
        end
    end
    -- Swipe (multi-target)
    if cast.able.swipeCat() and ui.useAOE(8, 3) then
        if cast.swipeCat() then
            ui.debug("Casting Swipe")
            return true
        end
    end
    -- Shred (from behind)
    if behind and cast.able.shred(thisUnit) then
        if cast.shred(thisUnit) then
            ui.debug("Casting Shred")
            return true
        end
    end
    -- Claw (not behind, or Shred not learned)
    if (not behind or not spell.shred.known()) and cast.able.claw(thisUnit) then
        if cast.claw(thisUnit) then
            ui.debug("Casting Claw")
            return true
        end
    end
end -- End Action List - Cat Form

-- Action List - Caster Form (and Moonkin Form)
actionList.CasterForm = function()
    local thisUnit = units.dyn30AOE
    local ttd = unit.ttd(thisUnit)
    -- Faerie Fire
    if ui.checked("Faerie Fire") and cast.able.faerieFire("target") and unit.enemy("target") and unit.canAttack("target")
        and not debuff.faerieFire.exists("target") and unit.ttd("target") > 10
    then
        if cast.faerieFire("target") then
            ui.debug("Casting Faerie Fire")
            return true
        end
    end
    -- Hurricane: no cooldown on Forever; channel it into a pack
    if ui.checked("Hurricane") and not unit.moving() and cast.able.hurricane.ground(8, ui.value("Hurricane")) then
        if cast.hurricane.ground(8, ui.value("Hurricane")) then
            ui.debug("Casting Hurricane")
            return true
        end
    end
    -- Moonfire: 12 sec DoT, where it pays off, or while moving
    if cast.able.moonfire(thisUnit) and debuff.moonfire.refresh(thisUnit) and (ttd > 9 or unit.moving()) then
        if cast.moonfire(thisUnit) then
            ui.debug("Casting Moonfire")
            return true
        end
    end
    -- Insect Swarm (talent)
    if cast.able.insectSwarm(thisUnit) and debuff.insectSwarm.refresh(thisUnit) and (ttd > 9 or unit.moving()) then
        if cast.insectSwarm(thisUnit) then
            ui.debug("Casting Insect Swarm")
            return true
        end
    end
    if unit.moving() then return false end
    -- Starfire: the main nuke. Wrath first to build Eclipse when it has no charges (Eclipse talent),
    -- and Starfire straight away with Eclipse or Clearcasting (which Wrath can't spend).
    local starfireTime = math.max(0, 3.5 - 0.5 * buff.eclipse.stack())
    local buildEclipse = spell.eclipse.known() and not buff.eclipse.exists() and not freeDPS
    if cast.able.starfire() and not buildEclipse and ttd > starfireTime then
        if cast.starfire() then
            ui.debug("Casting Starfire")
            return true
        end
    end
    -- Wrath: Eclipse builder and filler (cheap 2 sec cast, also when Starfire wouldn't land in time)
    if cast.able.wrath() then
        if cast.wrath() then
            ui.debug("Casting Wrath")
            return true
        end
    end
end -- End Action List - Caster Form

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if unit.inCombat() or unit.flying() or unit.mounted() then return false end
    -- Prowl
    if not (buff.prowl.exists() or buff.shadowmeld.exists()) and ui.mode.prowl == 1 and buff.catForm.exists()
        and cast.able.prowl("player") and unit.enemyNear(20) and not unit.resting()
    then
        if cast.prowl("player") then
            ui.debug("Casting Prowl [Precombat]")
            return true
        end
    end
    if not unit.valid("target") then return false end
    local thisDistance = unit.distance("target") or 99
    -- Pull from range before shifting: Starfire for a Caster/Moonkin player once learned, else Wrath
    if not unit.moving() and not inForm and thisDistance < 30 then
        if (activeForm == "caster" or activeForm == "moonkin") and cast.able.starfire("target") and not cast.current.starfire() then
            if cast.starfire("target") then
                ui.debug("Casting Starfire [Precombat]")
                return true
            end
        end
        if cast.able.wrath("target") and (unit.level() < 2 or not cast.last.wrath() or cast.timeSinceLast.wrath() > unit.gcd(true) + 0.5) then
            if cast.wrath("target") then
                ui.debug("Casting Wrath [Precombat]")
                return true
            end
        end
    end
    -- Feral Charge (Bear) to engage
    if ui.checked("Feral Charge - Engage") and buff.bearForm.exists() and thisDistance >= 8 and thisDistance < 25 then
        local chargeKey = spell.feralChargeBear.known() and "feralChargeBear" or "feralCharge"
        if cast.able[chargeKey]("target") and cast[chargeKey]("target") then
            ui.debug("Casting Feral Charge [Precombat]")
            return true
        end
    end
    if thisDistance < 5 then
        -- Cat Opener (Stealth + Non-Stealth)
        if actionList.CatOpener() then return true end
        -- Bear Opener
        if ui.checked("Bear Opener") and actionList.BearOpener() then return true end
        -- Bear Form
        if activeForm == "bear" and buff.bearForm.exists() then
            -- Enrage
            if cast.able.enrage() and not buff.enrage.exists() and rage < 10 then
                if cast.enrage() then
                    ui.debug("Casting Enrage [Precombat]")
                    return true
                end
            end
            -- Swipe
            if cast.able.swipe() and ui.useAOE(8, 3) then
                if cast.swipe() then
                    ui.debug("Casting Swipe [Precombat]")
                    return true
                end
            end
            -- Maul
            if cast.able.maul(units.dyn5) and (ui.useST(8, 3) or not spell.swipe.known()) then
                if cast.maul(units.dyn5) then
                    ui.debug("Casting Maul [Precombat]")
                    return true
                end
            end
        end
        -- Auto Attack (do not break Prowl)
        if not buff.prowl.exists() and not cast.auto.autoAttack() and not unit.deadOrGhost("target") then
            StartAttack()
            ui.debug("Casting Auto Attack [Precombat]")
            return true
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    if not (unit.inCombat() and unit.valid("target")) then return false end
    local inMelee = unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5
    -- Start Attack (do not break Prowl)
    if not buff.prowl.exists() and unit.exists(units.dyn5) and not cast.auto.autoAttack() and not unit.deadOrGhost("target") then
        StartAttack()
        ui.debug("Casting Auto Attack")
        return true
    end
    -- Call Action List - Interrupts
    if actionList.Interrupts() then return true end
    -- Call Action List - Cooldowns
    if actionList.Cooldowns() then return true end
    -- Feral Charge (Cat): leap behind the target to get into melee (and behind it)
    if ui.checked("Feral Charge (Cat)") and buff.catForm.exists() and not buff.prowl.exists()
        and unit.distance("target") >= 8 and unit.distance("target") < 25 and cast.able.feralCharge("target")
    then
        if cast.feralCharge("target") then
            ui.debug("Casting Feral Charge (Cat)")
            return true
        end
    end
    -- Feral Charge (Bear) to engage
    if ui.checked("Feral Charge - Engage") and buff.bearForm.exists()
        and unit.distance("target") >= 8 and unit.distance("target") < 25
    then
        local chargeKey = spell.feralChargeBear.known() and "feralChargeBear" or "feralCharge"
        if cast.able[chargeKey]("target") and cast[chargeKey]("target") then
            ui.debug("Casting Feral Charge")
            return true
        end
    end
    -- Call Action List - Bear Form
    if activeForm == "bear" and buff.bearForm.exists() and inMelee then
        if ui.checked("Bear Opener") and actionList.BearOpener() then return true end
        if actionList.BearForm() then return true end
    end
    -- Call Action List - Cat Form
    if activeForm == "cat" and buff.catForm.exists() and inMelee then
        if buff.prowl.exists() and actionList.CatOpener() then return true end
        if actionList.CatForm() then return true end
    end
    -- Call Action List - Caster Form (and Moonkin Form)
    if (activeForm == "caster" or activeForm == "moonkin") and not inForm then
        if actionList.CasterForm() then return true end
    end
end -- End Action list - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff        = br.player.buff
    cast        = br.player.cast
    cd          = br.player.cd
    comboPoints = br.player.power.comboPoints()
    debuff      = br.player.debuff
    enemies     = br.player.enemies
    energy      = br.player.power.energy()
    mana        = br.player.power.mana.percent()
    rage        = br.player.power.rage()
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    spell       = br.player.spell
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or ui.pause() or ui.mode.rotation == 4 or unit.id("target") == 156716
    -- Units
    units.get(5)        -- Makes a variable called, units.dyn5
    units.get(30, true) -- Makes a variable called, units.dyn30AOE (Forever caster range)
    -- Enemies
    enemies.get(5)      -- Makes a varaible called, enemies.yards5
    enemies.get(5, "player", false, true)  -- makes enemies.yards5f
    enemies.get(8)      -- Makes a varaible called, enemies.yards8
    enemies.get(10)     -- Makes a varaible called, enemies.yards10
    enemies.get(20)     -- Makes a varaible called, enemies.yards20
    enemies.get(30)     -- Makes a varaible called, enemies.yards30

    -- The form the Forms toggle picks, and whether a form that blocks caster spells is up
    activeForm = resolveForm()
    inForm = buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.aquaticForm.exists()

    -- The friendly player to heal besides yourself (Heal Others option and key), or nil
    var.healOther = healOthersUnit()

    -- Clearcasting Use: 1 Any, 2 DPS Only, 3 Healing Only, 4 None
    local omenSetting = ui.value("Clearcasting Use")
    local needsHealing = (ui.checked("Regrowth") and unit.hp() <= ui.value("Regrowth"))
        or (ui.checked("Healing Touch") and unit.hp() <= ui.value("Healing Touch"))
        or (ui.checked("Rejuvenation") and unit.hp() <= ui.value("Rejuvenation"))
    freeDPS = (omenSetting == 1 or omenSetting == 2) and buff.clearcasting.exists()
        and (not needsHealing or omenSetting == 2)
    freeHeal = (omenSetting == 1 or omenSetting == 3) and buff.clearcasting.exists()

    -- Low on Energy/Rage, so leaving Cat or Bear Form to heal doesn't waste much
    noShapeshiftPower = ((not buff.catForm.exists() or energy < ui.value("Break Form for Heals Below Energy"))
        and (not buff.bearForm.exists() or rage < ui.value("Break Form for Heals Below Rage")))
        or not unit.inCombat()

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        return true
    else
        -- Buffs, heals and group utility come before the form logic, so the shift into a form waits
        -- for anything that needs Caster Form
        if actionList.Buffs() then return true end
        if actionList.Defensive() then return true end
        if actionList.Utility() then return true end
        if actionList.Forms() then return true end
        if actionList.PreCombat() then return true end
        if actionList.Combat() then return true end
    end
    return true
end -- End runRotation
br.loader.registerRotation({
    name      = "CuteOne",
    specID    = 1484, -- Forever Druid class-level spec ID.
    expansion = "Forever",
    author    = "CuteOne",
    patch     = "Forever 1.60",
    coverage  = "100%",
    status    = "Full",
    readiness = "Untested",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})
