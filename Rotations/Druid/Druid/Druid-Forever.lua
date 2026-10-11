local rotationName = "CuteOne" -- Change to name of profile listed in options drop down

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
        { name = "Caster", icon = "wrath",    overlay = "Caster Form",    tip = "Will force and use Caster Form" },
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
    br.ui:dropdown(section, "Cat Opener", { choices = { "Pounce", "Ravage", "Shred", "Rake" }, value = "Ravage", checkbox = false,
        tip = "Select Spell to Open with from Stealth (falls back to the next learned option)" })
    br.ui:checkbox(section, "Faerie Fire", { tip = "Use Faerie Fire from range in Caster Form" })
    br.ui:checkbox(section, "Bear Opener", { tip = "Open a Bear Form pull with Enrage, Demoralizing Roar, then Maul, in that order" })
    br.ui:dropdown(section, "Clearcasting Use", { choices = { "Any", "DPS Only", "Healing Only", "None" }, checkbox = false,
        tip = "What Clearcasting (Omen of Clarity) procs should be spent on" })

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
    br.ui:checkbox(section, "Tiger's Fury", { checked = true, tip = "Use Tiger's Fury on cooldown in Cat Form" })
    br.ui:checkbox(section, "Shifting Power", { checked = true, tip = "Use Shifting Power (talent) to convert Mana into Energy in Cat Form" })
    br.ui:spinner(section, "Innervate", { value = 30, min = 5, checked = true, tip = "Self-Innervate at or below this Mana Percent" })

    section = br.ui:section("Buffs")
    br.ui:dropdown(section, "Mark of the Wild", { choices = { "Player", "Target", "Mouseover", "Focus", "Group" }, checked = true,
        tip = "Set how to use Mark of the Wild" })
    br.ui:dropdown(section, "Thorns", { choices = { "Player", "Target", "Mouseover", "Focus", "Group" }, checked = true,
        tip = "Set how to use Thorns" })

    section = br.ui:section("Defensive")
    br.ui:checkbox(section, "Self Heal In Group", { checked = true, tip = "Enable/Disable Healing Self while Grouped" })
    br.ui:spinner(section, "Healing Touch", { value = 35, checked = true, tip = "Health Percent to Cast At" })
    br.ui:spinner(section, "Regrowth", { value = 55, checked = true, tip = "Health Percent to Cast At" })
    br.ui:spinner(section, "Rejuvenation", { value = 70, checked = true, tip = "Health Percent to Cast At" })
    br.ui:spinner(section, "Barkskin", { value = 65, checked = true, tip = "Health Percent to Cast At" })
    br.ui:spinner(section, "Frenzied Regeneration", { value = 45, checked = true, tip = "Health Percent to Cast At (Bear Form)" })
    br.ui:spinner(section, "Bash", { value = 35, tip = "Health Percent to stun your target at (Bear Form)" })
    br.ui:checkbox(section, "Cure Poison", { checked = true, tip = "Cure poisons on yourself (uses Abolish Poison once learned)" })
    br.ui:checkbox(section, "Remove Curse", { checked = true, tip = "Remove curses on yourself out of combat" })
    br.ui:checkbox(section, "Entangling Roots", { tip = "Enable/Disable Using Entangling Roots on fleeing enemies" })
    br.ui:spinner(section, "Nature's Grasp", { value = 40,
        tip = "Escape tool: cast at or below this Health Percent while running from an enemy chasing you within 10 yards. The root breaks on damage, so it's meant for fleeing, not fighting." })

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
local freeDPS
local freeHeal
local noShapeshiftPower
local needsHealing
local activeForm

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
-- AutoProwl: enemies already fighting nearby, or an idle enemy we're about to aggro
local function autoProwl()
    if unit.inCombat() or buff.prowl.exists() then return false end
    return #enemies.yards20 > 0 or unit.anyInAggroRange(0, 20)
end
-- Cache for ferociousBiteFinish's parsed damage values. Key: spellID..":"..cp.
-- Rank-change invalidation: spell.X.id() re-reads the spellbook each call
-- (verified at AUDIT.md L23 plan session — Spell.lua:29-33 + Spell.lua:657-672),
-- so post-level-up the new rank's spell ID produces a fresh cache key and old
-- entries become orphaned (harmless).
-- Locale-sensitivity assumption inherited from desc:find() below — wrong on
-- non-English clients; /reload purges this module-scope cache so locale
-- change can't outlast it.
local ferociousBiteCache = {}

-- Ferocious Bite Finish
local function ferociousBiteFinish(thisUnit)
    if thisUnit == nil then thisUnit = units.dyn5 end
    if comboPoints <= 0 or unit.isDummy(thisUnit) then return false end

    local spellID = spell.ferociousBite.id()
    if spellID == 0 then return false end
    local cp = comboPoints
    local cacheKey = spellID .. ":" .. cp

    local lower = ferociousBiteCache[cacheKey]
    if lower == nil then
        local desc = br._G.C_Spell.GetSpellDescription(spellID) or ""
        if desc == "" then ferociousBiteCache[cacheKey] = false; return false end
        local comboStart = desc:find(" " .. cp .. " ", 1, true)
        if comboStart == nil then ferociousBiteCache[cacheKey] = false; return false end
        local damageList = desc:sub(comboStart + 2)
        local colonPos = damageList:find(": ", 1, true)
        if colonPos == nil then ferociousBiteCache[cacheKey] = false; return false end
        damageList = damageList:sub(colonPos + 2)
        local spacePos = damageList:find(" ", 1, true) or (#damageList + 1)
        local token = damageList:sub(1, spacePos - 1):gsub(",", "")
        local low = token:match("^(%d+)%-%d+$") or token:match("^(%d+)$")
        lower = tonumber(low)
        ferociousBiteCache[cacheKey] = lower or false
    end

    if lower == false or lower == nil then return false end
    return lower >= (unit.health(thisUnit) or 0)
end
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

-- Update Last Form
-- Resolve the Forms toggle (Auto/Caster/Cat/Bear) into a form we can actually use.
-- A forced form that isn't learned yet falls back to Caster.
local function resolveForm()
    local mode = ui.mode.forms
    local hasCat = spell.catForm.known()
    local hasBear = spell.bearForm.known()
    if mode == 1 then
        if hasBear and unit.role("player") == "TANK" then return "bear" end
        if hasCat then return "cat" end
        if hasBear then return "bear" end
        return "caster"
    end
    if mode == 3 and hasCat then return "cat" end
    if mode == 4 and hasBear then return "bear" end
    return "caster"
end
-- Fleeing: running from any enemy within 10 yards that is chasing us
local function isChasingPlayer(thisUnit) return unit.isFleeingFrom("player", thisUnit) end
local function isFleeing()
    return enemies.any(enemies.yards10, isChasingPlayer)
end

-- Gift of the Wild is a differently named aura, so buff.markOfTheWild misses it and a recast
-- fails with "A more powerful spell is already active". Treat it as satisfying Mark of the Wild.
local function needsMarkOfTheWild(thisUnit)
    if buff.giftOfTheWild.exists(thisUnit) and not buff.giftOfTheWild.refresh(thisUnit) then return false end
    return buff.markOfTheWild.refresh(thisUnit)
end

local function needsThorns(thisUnit) return buff.thorns.refresh(thisUnit) end

-- Check if we need to cast anything that requires breaking form
local function needsFormBreak()
    -- Buffs
    if ui.checked("Mark of the Wild") then
        var.markUnit = ui.buffUnit("Mark of the Wild", needsMarkOfTheWild, 30)
        if cast.able.markOfTheWild(var.markUnit) and needsMarkOfTheWild(var.markUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.markUnit) < 30
            and (var.markUnit == "player" or unit.player(var.markUnit))
        then
            return true
        end
    end
    if ui.checked("Thorns") then
        var.thornUnit = ui.buffUnit("Thorns", needsThorns, 30)
        if cast.able.thorns(var.thornUnit) and buff.thorns.refresh(var.thornUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.thornUnit) < 30
            and (var.thornUnit == "player" or unit.player(var.thornUnit))
        then
            return true
        end
    end

    -- Defensive actions
    if ui.useDefensive() then
        -- Dispels
        if ui.checked("Cure Poison") then
            if spell.abolishPoison.known() then
                if cast.able.abolishPoison("player") and not buff.abolishPoison.exists("player")
                    and cast.dispel.abolishPoison("player")
                then
                    return true
                end
            elseif cast.able.curePoison("player") and cast.dispel.curePoison("player") then
                return true
            end
        end
        if ui.checked("Remove Curse") and cast.able.removeCurse("player")
            and not unit.inCombat() and cast.dispel.removeCurse("player")
        then
            return true
        end
        -- Entangling Roots
        if ui.checked("Entangling Roots") and cast.able.entanglingRoots("target")
            and unit.exists("target") and unit.isFleeing("target")
            and unit.valid("target") and unit.hp("target") < 100 and not debuff.entanglingRoots.exists("target")
            and unit.distance("target") > 8 and unit.inCombat()
        then
            return true
        end
        -- Healing
        if ui.checked("Regrowth") and cast.able.regrowth("player") and not cast.current.regrowth() and not unit.moving()
            and unit.hp() <= ui.value("Regrowth") and not buff.regrowth.exists("player")
            and (freeHeal or noShapeshiftPower)
            and (not unit.inGroup() or ui.checked("Self Heal In Group"))
        then
            return true
        end
        -- Rejuvenation is too slow to justify two shapeshifts in combat
        if ui.checked("Rejuvenation") and not cast.current.rejuvenation("target")
            and (not unit.inCombat() or not (buff.catForm.exists() or buff.bearForm.exists()))
        then
            if cast.able.rejuvenation("target") and unit.friend("target") and unit.hp("target") <= ui.value("Rejuvenation")
                and unit.player("target") and buff.rejuvenation.refresh("target")
            then
                return true
            end
            if cast.able.rejuvenation("player") and not unit.friend("target") and unit.hp() <= ui.value("Rejuvenation")
                and buff.rejuvenation.refresh("player") and not buff.clearcasting.exists()
                and (unit.solo() or ui.checked("Self Heal In Group"))
            then
                return true
            end
        end
        -- Healing Touch is the emergency heal: breaks form regardless of Energy/Rage
        if ui.checked("Healing Touch") and not cast.current.healingTouch() and not unit.moving() then
            if cast.able.healingTouch("target") and unit.friend("target") and unit.hp("target") <= ui.value("Healing Touch") and unit.player("target") then
                return true
            end
            if cast.able.healingTouch("player") and not unit.friend("target") and unit.hp() <= ui.value("Healing Touch")
                and (not unit.inGroup() or ui.checked("Self Heal In Group"))
            then
                return true
            end
        end
    end

    return false
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Cancel Form to Interact with NPCs
    -- if unit.exists("target") and unit.friend("target") and not unit.deadOrGhost("target") and not unit.player("target")
    --     and unit.distance("target") < 8 and (buff.catForm.exists() or buff.bearForm.exists())
    -- then
    --     br._G.RunMacroText("/CancelForm")
    --     ui.debug("Cancel Form [NPC]")
    --     br._G.InteractUnit("target")
    --     ui.debug("Interacting [NPC]")
    --     return true
    -- end

    -- Aquatic Form
    if ui.checked("Aquatic Form") and not unit.inCombat() and cast.able.aquaticForm()
        and unit.swimming() and not buff.aquaticForm.exists() and not buff.prowl.exists()
        and unit.moving() and unit.movingTime() > 2 and not unit.anyInAggroRange()
        and not (needsMarkOfTheWild() and ui.checked("Mark of the Wild"))
        and not (buff.thorns.refresh() and ui.checked("Thorns"))
    then
        if buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() then
            if unit.cancelFormFor(spell.aquaticForm) then
                return true
            end
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
        and not (needsMarkOfTheWild() and ui.checked("Mark of the Wild"))
        and not (buff.thorns.refresh() and ui.checked("Thorns"))
    then
        if buff.catForm.exists() or buff.bearForm.exists() then
            if unit.cancelFormFor(spell.travelForm) then
                return true
            end
        end
        if cast.travelForm() then
            ui.debug("Casting Travel Form")
            return true
        end
    end

    -- Keep Aquatic Form while swimming unless danger/enemy target.
    local keepAquatic = ui.checked("Aquatic Form")
        and unit.swimming()
        and buff.aquaticForm.exists()
        and not unit.anyInAggroRange()
        and (not unit.exists("target") or unit.friend("target"))

    -- Auto Shapeshift
    if not keepAquatic and not needsFormBreak()
        and ((unit.moving() and unit.movingTime() > ui.value("Shift Wait Time")) or unit.inCombat() or unit.anyInAggroRange(5))
    then
        -- Bear Form
        if activeForm == "bear" and cast.able.bearForm() and not buff.bearForm.exists()
            and not (needsMarkOfTheWild() and ui.checked("Mark of the Wild"))
            and not (buff.thorns.refresh() and ui.checked("Thorns"))
        then
            if cast.bearForm() then
                ui.debug("Casting Bear Form")
                return true
            end
        end
        -- Caster Form
        if activeForm == "caster" and (buff.bearForm.exists() or buff.catForm.exists()) then
            if unit.cancelForm() then
                ui.debug("Casting Caster Form")
                return true
            end
        end
        -- Cat Form
        if activeForm == "cat"
            and cast.able.catForm() and not buff.catForm.exists()
            and not (needsMarkOfTheWild() and ui.checked("Mark of the Wild"))
            and not (buff.thorns.refresh() and ui.checked("Thorns"))
        then
            if cast.catForm() then
                ui.debug("Casting Cat Form")
                return true
            end
        end
    end
    -- Mark of the Wild
    if ui.checked("Mark of the Wild") then
        var.markUnit = ui.buffUnit("Mark of the Wild", needsMarkOfTheWild, 30)
        if cast.able.markOfTheWild(var.markUnit) and needsMarkOfTheWild(var.markUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.markUnit) < 30
            and (var.markUnit == "player" or unit.player(var.markUnit))
        then
            -- Cancel form if needed to buff
            local needsCancel = buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.aquaticForm.exists()
            if needsCancel then
                if unit.cancelFormFor(spell.markOfTheWild) then
                    return true
                end
            else
                if cast.markOfTheWild(var.markUnit) then
                    ui.debug("Casting Mark of the Wild")
                    return true
                end
            end
        end
    end
    -- Thorns
    if ui.checked("Thorns") then
        var.thornUnit = ui.buffUnit("Thorns", needsThorns, 30)
        if cast.able.thorns(var.thornUnit) and buff.thorns.refresh(var.thornUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.thornUnit) < 30
            and (var.thornUnit == "player" or unit.player(var.thornUnit))
        then
            -- Cancel form if needed to buff
            local needsCancel = buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.aquaticForm.exists()
            if needsCancel then
                if unit.cancelFormFor(spell.thorns) then
                    return true
                end
            else
                if cast.thorns(var.thornUnit) then
                    ui.debug("Casting Thorns")
                    return true
                end
            end
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Cure Poison (Abolish Poison once learned)
        if ui.checked("Cure Poison") and spell.abolishPoison.known() and cast.able.abolishPoison("player")
            and not buff.abolishPoison.exists("player") and cast.dispel.abolishPoison("player")
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if unit.cancelFormFor(spell.abolishPoison) then
                    return true
                end
            else
                if cast.abolishPoison("player") then
                    ui.debug("Casting Abolish Poison")
                    return true
                end
            end
        end
        if ui.checked("Cure Poison") and not spell.abolishPoison.known() and cast.able.curePoison("player")
            and cast.dispel.curePoison("player")
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if unit.cancelFormFor(spell.curePoison) then
                    return true
                end
            else
                if cast.curePoison("player") then
                    ui.debug("Casting Cure Poison")
                    return true
                end
            end
        end
        -- Remove Curse
        if ui.checked("Remove Curse") and cast.able.removeCurse("player")
            and not unit.inCombat() and cast.dispel.removeCurse("player")
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if unit.cancelFormFor(spell.removeCurse) then
                    return true
                end
            else
                if cast.removeCurse("player") then
                    ui.debug("Casting Remove Curse")
                    return true
                end
            end
        end
        -- Barkskin
        if ui.checked("Barkskin") and cast.able.barkskin()
            and unit.hp() <= ui.value("Barkskin") and unit.inCombat()
        then
            if cast.barkskin() then
                ui.debug("Casting Barkskin")
                return true
            end
        end
        -- Entangling Roots (fleeing enemies)
        if ui.checked("Entangling Roots") and cast.able.entanglingRoots("target")
            and unit.exists("target") and unit.isFleeing("target")
            and unit.valid("target") and unit.hp("target") < 100 and not debuff.entanglingRoots.exists("target")
            and unit.distance("target") > 8 and unit.inCombat() and not unit.moving()
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if unit.cancelFormFor(spell.entanglingRoots, freeDPS) then
                    return true
                end
            else
                if cast.entanglingRoots("target") then
                    ui.debug("Casting Entangling Roots")
                    return true
                end
            end
        end
        -- Nature's Grasp
        -- Escape tool: the root breaks on damage, so only use it while fleeing
        if ui.checked("Nature's Grasp") and cast.able.naturesGrasp()
            and not buff.naturesGrasp.exists("player") and unit.inCombat()
            and unit.hp() <= ui.value("Nature's Grasp") and isFleeing()
        then
            -- Castable while shapeshifted on Forever
            if cast.naturesGrasp("player") then
                ui.debug("Casting Nature's Grasp")
                return true
            end
        end
        -- Regrowth
        if ui.checked("Regrowth") and cast.able.regrowth("player") and not cast.current.regrowth() and not unit.moving()
            and unit.hp() <= ui.value("Regrowth") and not buff.regrowth.exists("player")
            and (freeHeal or noShapeshiftPower)
            and (not unit.inGroup() or ui.checked("Self Heal In Group"))
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if unit.cancelFormFor(spell.regrowth, freeHeal) then
                    return true
                end
            else
                if cast.regrowth("player") then
                    ui.debug("Casting Regrowth")
                    return true
                end
            end
        end
        -- Rejuvenation
        -- Rejuvenation is too slow to justify two shapeshifts in combat
        if ui.checked("Rejuvenation") and not cast.current.rejuvenation("target")
            and (not unit.inCombat() or not (buff.catForm.exists() or buff.bearForm.exists()))
        then
            if cast.able.rejuvenation("target") and unit.friend("target") and unit.hp("target") <= ui.value("Rejuvenation")
                and unit.player("target") and buff.rejuvenation.refresh("target")
            then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    if unit.cancelFormFor(spell.rejuvenation, freeHeal) then
                        return true
                    end
                else
                    ui.debug("Attempting to cast Rejuvenation on " .. unit.name("target"))
                    if cast.rejuvenation("target") then
                        return true
                    end
                end
            end
            if cast.able.rejuvenation("player") and not unit.friend("target") and unit.hp() <= ui.value("Rejuvenation")
                and buff.rejuvenation.refresh("player") and not buff.clearcasting.exists()
                and (unit.solo() or ui.checked("Self Heal In Group"))
            then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    if unit.cancelFormFor(spell.rejuvenation, freeHeal) then
                        return true
                    end
                else
                    if cast.rejuvenation("player") then
                        ui.debug("Casting Rejuvenation on " .. unit.name("player"))
                        return true
                    end
                end
            end
        end
        -- Healing Touch
        -- Healing Touch is the emergency heal: breaks form regardless of Energy/Rage
        if ui.checked("Healing Touch") and not cast.current.healingTouch() and not unit.moving() then
            if cast.able.healingTouch("target") and unit.friend("target") and unit.hp("target") <= ui.value("Healing Touch") and unit.player("target") then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    if unit.cancelFormFor(spell.healingTouch, freeHeal, true) then
                        return true
                    end
                else
                    if cast.healingTouch("target") then
                        ui.debug("Casting Healing Touch on " .. unit.name("target"))
                        return true
                    end
                end
            end
            if cast.able.healingTouch("player") and not unit.friend("target") and unit.hp() <= ui.value("Healing Touch")
                and (not unit.inGroup() or ui.checked("Self Heal In Group"))
            then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    if unit.cancelFormFor(spell.healingTouch, freeHeal, true) then
                        return true
                    end
                else
                    if cast.healingTouch("player") then
                        ui.debug("Casting Healing Touch on " .. unit.name("player"))
                        return true
                    end
                end
            end
        end
        -- Frenzied Regeneration
        if ui.checked("Frenzied Regeneration") and buff.bearForm.exists() and cast.able.frenziedRegeneration()
            and unit.inCombat() and unit.hp() <= ui.value("Frenzied Regeneration") and rage >= 10
        then
            if cast.frenziedRegeneration() then
                ui.debug("Casting Frenzied Regeneration")
                return true
            end
        end
        -- Bash (low HP defensive stun)
        if ui.checked("Bash") and unit.hp() <= ui.value("Bash") then
            if (buff.bearForm.exists() or buff.direBearForm.exists()) and cast.able.bash("target") then
                if cast.bash("target") then
                    ui.debug("Casting Bash [Defensive]")
                    return true
                end
            end
        end
    end
end -- End Action List - Defensive

-- * Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() and ui.delay("Interrupts", unit.gcd(true))
        -- and not (buff.prowl.exists() or buff.shadowmeld.exists())
    then
        local thisUnit
        local inBear = buff.bearForm.exists()
        local interruptAt = ui.value("Interrupt At")
        -- * Feral Charge (Bear) - 8 to 25 yards
        if ui.checked("Feral Charge - Int") and inBear and cast.able.feralChargeBear() then
            enemies.get(25)
            thisUnit = enemies.first(enemies.yards25, function(thisUnit)
                return unit.distance(thisUnit) >= 8 and unit.interruptable(thisUnit, interruptAt)
                    and cast.able.feralChargeBear(thisUnit)
            end)
            if thisUnit and cast.feralChargeBear(thisUnit) then
                ui.debug("Casting Feral Charge on " .. unit.name(thisUnit))
                return true
            end
        end
        -- * Bash
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
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- Innervate (mana management, not gated by the Cooldown toggle)
    if ui.checked("Innervate") and cast.able.innervate("player")
        and unit.power.mana.percent() <= ui.value("Innervate")
    then
        if cast.innervate("player") then
            ui.debug("Casting Innervate")
            return true
        end
    end
    -- Berserk (talent) - Always / Cooldowns / Never
    if ui.alwaysCdNever("Berserk") and cast.able.berserk() and (buff.catForm.exists() or buff.bearForm.exists())
        and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 and unit.ttd(units.dyn5) > 15
    then
        if cast.berserk() then
            ui.debug("Casting Berserk")
            return true
        end
    end
end -- End Action List - Cooldowns

-- Action List - Bear Form
actionList.BearForm = function()
    -- Enrage
    if cast.able.enrage() and not unit.deadOrGhost("target") and not buff.enrage.exists() and rage < 10 and unit.hp() > 80 then
        if cast.enrage() then
            ui.debug("Casting Enrage")
            return true
        end
    end
    -- Primal Bite (talent, high threat; Berserk removes its cooldown)
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
    -- Lacerate (stack to 5, refresh before it falls off)
    if cast.able.lacerate(units.dyn5) and unit.ttd(units.dyn5) > 6
        and (debuff.lacerate.stack(units.dyn5) < 5 or debuff.lacerate.remain(units.dyn5) < 4)
    then
        if cast.lacerate(units.dyn5) then
            ui.debug("Casting Lacerate")
            return true
        end
    end
    -- Swipe (multi-target)
    if cast.able.swipe() and ui.useAOE(8,3) then
        if cast.swipe() then
            ui.debug("Casting Swipe")
            return true
        end
    end
    -- Maul
    if cast.able.maul(units.dyn5) and (ui.useST(8,3) or not spell.swipe.known()) then
        if cast.maul(units.dyn5) then
            ui.debug("Casting Maul")
            return true
        end
    end
end -- End Action List - Bear Form

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

-- Action List - Cat Opener (Stealth + Non-Stealth)
actionList.CatOpener = function()
    if not buff.catForm.exists() then return false end
    if not unit.valid("target") or unit.deadOrGhost("target") or unit.distance("target") >= 5 then return false end
    if unit.player("target") then return false end

    -- Tiger's Fury (Forever: 15% Physical damage for 6 sec) before the opening hit
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
        if (opener == 4 or (opener <= 3 and not spell.shred.known()))
            and cast.able.rake()
        then
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
    if (behindTarget or not spell.shred.known()) then
        -- Shred (from behind)
        if behindTarget and cast.able.shred() then
            if not unit.facing("target", "player") then
                if cast.shred("target") then
                    ui.debug("Casting Shred [Opener]")
                    return true
                end
            end
        end
        -- Claw (fallback)
        if cast.able.claw() and (not spell.shred.known() or not behindTarget) then
            if cast.claw("target") then
                ui.debug("Casting Claw [Opener]")
                return true
            end
        end
    end

    return false
end

-- Action List - Cat Form
actionList.CatForm = function()
    -- Ferocious Bite - Finish Him!
    local finish = ferociousBiteFinish(units.dyn5)
    if cast.able.ferociousBite(units.dyn5) and energy >= 35 and finish then
        if cast.ferociousBite(units.dyn5) then
            ui.debug("Casting Ferocious Bite [Finish Him!]")
            return true
        end
    end

    -- Tiger's Fury (Forever: 15% Physical damage incl. bleeds for 6 sec, 30 sec cooldown)
    if ui.checked("Tiger's Fury") and cast.able.tigersFury() and not buff.tigersFury.exists() then
        if cast.tigersFury() then
            ui.debug("Casting Tiger's Fury")
            return true
        end
    end

    -- Shifting Power (talent): 40 Energy for Mana; only when it won't overcap
    if ui.checked("Shifting Power") and cast.able.shiftingPower() and energy <= 60
        and not buff.clearcasting.exists()
    then
        if cast.shiftingPower() then
            ui.debug("Casting Shifting Power")
            return true
        end
    end

    -- 5 Combo Points - Finishers
    if comboPoints == 5 and not finish then
        -- Rip (12 sec bleed; Rend and Tear rewards keeping a bleed up)
        if cast.able.rip(units.dyn5) and unit.ttd(units.dyn5) > 8 and debuff.rip.refresh(units.dyn5) then
            if cast.rip(units.dyn5) then
                ui.debug("Casting Rip")
                return true
            end
        end
        -- Ferocious Bite: extra Energy only adds 1 damage each, so bite at 35 instead of pooling
        if cast.able.ferociousBite(units.dyn5) and energy >= 35 then
            if cast.ferociousBite(units.dyn5) then
                ui.debug("Casting Ferocious Bite")
                return true
            end
        end
    end

    -- Combo Point Builders (keep building at 5 only until Ferocious Bite is learned)
    if (comboPoints < 5 or not spell.ferociousBite.known()) and not finish then
        local behindDyn5 = unit.isBehind(units.dyn5, "player")
        if behindDyn5 then debugBehind("Builders behind=true", units.dyn5) end
        -- Ravage (from Prowl)
        if cast.able.ravage(units.dyn5) and buff.prowl.exists() and behindDyn5 then
            if cast.ravage(units.dyn5) then
                ui.debug("Casting Ravage")
                return true
            end
        end
        -- Rake: keep the bleed up on anything that lives long enough (Clearcasting goes to Shred/Claw)
        if cast.able.rake(units.dyn5) and debuff.rake.refresh(units.dyn5)
            and unit.ttd(units.dyn5) > 6 and not freeDPS
        then
            if cast.rake(units.dyn5) then
                ui.debug("Casting Rake")
                return true
            end
        end
        -- Shred (from behind)
        if behindDyn5 and cast.able.shred(units.dyn5) and not unit.facing(units.dyn5, "player") then
            if cast.shred(units.dyn5) then
                ui.debug("Casting Shred")
                return true
            end
        end
        -- Claw (not behind)
        if cast.able.claw(units.dyn5) and (not spell.shred.known() or not behindDyn5) then
            if cast.claw(units.dyn5) then
                ui.debug("Casting Claw")
                return true
            end
        end
    end
end -- End Action List - Cat Form

-- Action List - Caster Form
actionList.CasterForm = function()
    -- Faerie Fire
    if ui.checked("Faerie Fire") and cast.able.faerieFire("target")
        and unit.exists("target") and unit.enemy("target") and unit.canAttack("target") and not debuff.faerieFire.exists("target")
        and unit.ttd("target") > 10
    then
        if cast.faerieFire("target") then
            ui.debug("Casting Faerie Fire")
            return true
        end
    end
    -- Moonfire (30 yd on Forever): only where the 9 sec DoT pays off, or while moving
    if cast.able.moonfire(units.dyn30AOE) and debuff.moonfire.refresh(units.dyn30AOE)
        and (unit.ttd(units.dyn30AOE) > 9 or unit.moving())
    then
        if cast.moonfire(units.dyn30AOE) then
            ui.debug("Casting Moonfire")
            return true
        end
    end
    -- Insect Swarm (talent)
    if cast.able.insectSwarm(units.dyn30AOE) and debuff.insectSwarm.refresh(units.dyn30AOE)
        and unit.ttd(units.dyn30AOE) > 12
    then
        if cast.insectSwarm(units.dyn30AOE) then
            ui.debug("Casting Insect Swarm")
            return true
        end
    end
    -- Starfire: main filler once learned (also the best use of Clearcasting, which Wrath can't consume)
    if cast.able.starfire() and not unit.moving() then
        if cast.starfire() then
            ui.debug("Casting Starfire")
            return true
        end
    end
    -- Wrath: cheap 1.5 sec filler, no longer waits on Moonfire
    if cast.able.wrath() and not unit.moving() then
        if cast.wrath() then
            ui.debug("Casting Wrath")
            return true
        end
    end
end -- End Action List - Caster Form

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        if not (buff.prowl.exists() or buff.shadowmeld.exists()) then
            -- Prowl
            if cast.able.prowl("player") and buff.catForm.exists() and autoProwl() and ui.mode.prowl == 1
                and not buff.prowl.exists() and not unit.resting()
            then
                if cast.prowl("player") then
                    ui.debug("Casting Prowl [Precombat]")
                    return true
                end
            end
        end -- End No Stealth
        if unit.valid("target") then
            local thisDistance = unit.distance("target") or 99
            -- Wrath
            if not unit.moving() and not (buff.catForm.exists() or buff.bearForm.exists()) and thisDistance < 30 then
                if cast.able.wrath("target") and (unit.level() < 2 or not cast.last.wrath() or cast.timeSinceLast.wrath() > unit.gcd(true) + 0.5) then
                    if cast.wrath("target") then
                        ui.debug("Casting Wrath [Precombat]")
                        return true
                    end
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
                    if cast.able.enrage() and not unit.deadOrGhost("target") and not buff.enrage.exists() and rage < 10 then
                        if cast.enrage() then
                            ui.debug("Casting Enrage [Precombat]")
                            return true
                        end
                    end
                    -- Swipe
                    if cast.able.swipe() and ui.useAOE(8,3) then
                        if cast.swipe() then
                            ui.debug("Casting Swipe [Precombat]")
                            return true
                        end
                    end
                    -- Maul
                    if cast.able.maul(units.dyn5) and (ui.useST(8,3) or not spell.swipe.known()) then
                        if cast.maul(units.dyn5) then
                            ui.debug("Casting Maul [Precombat]")
                            return true
                        end
                    end
                end
                -- Auto Attack (do not break Prowl)
                if not buff.prowl.exists() and not cast.auto.autoAttack() and unit.valid("target") and not unit.deadOrGhost("target") and unit.distance("target") < 5 then
                    StartAttack()
                    ui.debug("Casting Auto Attack [Precombat]")
                    return true
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    if unit.inCombat() and unit.valid("target") then
        ------------------------
        --- In Combat - Main ---
        ------------------------
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

        -- Call Action List - Bear Form
        if activeForm == "bear" and buff.bearForm.exists() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            if ui.checked("Bear Opener") and actionList.BearOpener() then return true end
            if actionList.BearForm() then return true end
        end

        -- Call Action List - Cat Form
        if activeForm == "cat" and buff.catForm.exists() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            if buff.prowl.exists() and actionList.CatOpener() then return true end
            if actionList.CatForm() then return true end
        end

        -- Call Action List - Caster Form
        if activeForm == "caster" and not (buff.catForm.exists() or buff.bearForm.exists()) then
            if actionList.CasterForm() then return true end
        end
    end -- End In Combat Rotation
end     -- End Action list - Combat

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
    enemies.get(10)     -- Makes a varaible called, enemies.yards10
    enemies.get(20)     -- Makes a varaible called, enemies.yards20
    enemies.get(20, "player", true)        -- makes enemies.yards20nc
    enemies.get(40)     -- Makes a varaible called, enemies.yards40

    -- Update Last Form tracking (used to decide if breaking form is affordable)
    activeForm = resolveForm()

    -- Omen of Clarity Logic
    local omenSetting = ui.value("Clearcasting Use")
    needsHealing = (ui.checked("Regrowth") and unit.hp() <= ui.value("Regrowth"))
        or (ui.checked("Healing Touch") and unit.hp() <= ui.value("Healing Touch"))
        or (ui.checked("Rejuvenation") and unit.hp() <= ui.value("Rejuvenation"))

    -- Clearcasting Use: 1 Any, 2 DPS Only, 3 Healing Only, 4 None
    freeDPS = (omenSetting == 1 or omenSetting == 2) and buff.clearcasting.exists()
        and (not needsHealing or omenSetting == 2)

    freeHeal = (omenSetting == 1 or omenSetting == 3) and buff.clearcasting.exists()

    -- No Shapeshift Power check
    noShapeshiftPower = ((not buff.catForm.exists() or (buff.catForm.exists() and energy < ui.value("Break Form for Heals Below Energy")))
        and (not buff.bearForm.exists() or (buff.bearForm.exists() and rage < ui.value("Break Form for Heals Below Rage"))))
        or not unit.inCombat()

    if not unit.inCombat() and not unit.exists("target") then
        if profileStop then profileStop = false end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extra() then return true end
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
        if actionList.Combat() then return true end
    end         -- Pause
    return true
end             -- End runRotation
br.loader.registerRotation({
    name      = rotationName,
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
