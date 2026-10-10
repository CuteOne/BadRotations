local rotationName = "CuteOne" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function toggles()
    br.ui:toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "swipe", overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range." },
        { name = "Multi", icon = "swipe", overlay = "Multiple Target Rotation", tip = "Forces Multiple Target Rotation." },
        { name = "Single", icon = "shred", overlay = "Single Target Rotation", tip = "Forces Single Target Rotation." },
        { name = "Off", icon = "healingTouch", overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation" },
    } })
    br.ui:toggle("Cooldown", { key = "RightCtrl", modes = {
        { name = "Auto", icon = "innervate", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On", icon = "innervate", overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target." },
        { name = "Off", icon = "innervate", overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used." },
    } })
    br.ui:toggle("Defensive", { modes = {
        { name = "On", icon = "healingTouch", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "healingTouch", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    br.ui:toggle("Interrupt", { modes = {
        { name = "On", icon = "bash", overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts." },
        { name = "Off", icon = "bash", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
    } })
    br.ui:toggle("Forms", { modes = {
        { name = "Caster", icon = "moonkinForm", overlay = "Caster Form", tip = "Will force and use Caster Form" },
        { name = "Cat", icon = "catForm", overlay = "Cat Form", tip = "Will force and use Cat Form" },
        { name = "Bear", icon = "bearForm", overlay = "Bear Form", tip = "Will force and use Bear Form" },
    } })
    br.ui:toggle("Prowl", { modes = {
        { name = "On", icon = "prowl", overlay = "Prowl Enabled", tip = "Rotation will use Prowl" },
        { name = "Off", icon = "prowl", overlay = "Prowl Disabled", tip = "Rotation will not use Prowl" },
    } })
end

---------------
--- OPTIONS ---
---------------
local function options()
    local section
    -----------------------
    --- GENERAL OPTIONS ---
    -----------------------
    section = br.ui:section("General")
    br.ui:spinner(section, "Shift Wait Time", { value = 2, max = 5, step = 1, checkbox = false,
        tip = "Time in seconds the profile will wait while moving to shift. Combat is instant!" })
    br.ui:checkbox(section, "Behind Debug", { tip = "Debug behind/facing checks for Shred/Ravage." })
    -- Powershifting
    br.ui:checkbox(section, "Powershifting", { tip = "Feral DPS In-Form Shifting for Energy" })
    -- Prowl
    br.ui:checkbox(section, "Prowl", { tip = "Uses Prowl when near aggro range" })
    -- Cat Opener
    br.ui:dropdown(section, "Cat Opener", { choices = { "Pounce", "Ravage", "Shred", "Rake" }, value = "Ravage",
        tip = "Select Spell to Open with from Stealth" })
    --------------------------
    --- FORM MANAGEMENT ---
    --------------------------
    section = br.ui:section("Form Management")
    -- Aquatic Form
    br.ui:checkbox(section, "Aquatic Form", { tip = "Enable/Disable Using Aquatic Form" })
    -- Travel Form
    br.ui:checkbox(section, "Travel Form", { tip = "Enable/Disable Using Travel Form" })
    -- Last Form
    br.ui:checkbox(section, "Last Form", { tip = "Enable/Disable Returning to Last Form" })
    -- Energy Threshold
    br.ui:spinner(section, "Energy", { value = 30, min = 1, step = 1, tip = "Cat Form Energy Threshold to Break Form" })
    -- Rage Threshold
    br.ui:spinner(section, "Rage", { value = 10, min = 1, step = 1, tip = "Bear Form Rage Threshold to Break Form" })
    ----------------------
    --- BLEED OPTIONS ---
    ----------------------
    section = br.ui:section("Bleeds")
    -- Rake
    br.ui:checkbox(section, "Rake", { tip = "Enable/Disable Using Rake" })
    -- Rip
    br.ui:checkbox(section, "Rip", { tip = "Enable/Disable Using Rip" })
    ---------------------
    --- BUFF OPTIONS ---
    ---------------------
    section = br.ui:section("Buffs")
    -- Self-Innervate
    br.ui:checkbox(section, "Self-Innervate", { tip = "Enable/Disable Using Innervate on Self" })
    -- Mark of the Wild
    br.ui:dropdown(section, "Mark of the Wild", { choices = { "Player", "Target", "Mouseover", "Focus", "Group" }, value = "Player",
        tip = "Set how to use Mark of the Wild" })
    -- Omen of Clarity
    br.ui:dropdown(section, "Omen of Clarity", { choices = { "Any", "Focus DPS", "Focus Healing", "None" }, value = "Any",
        tip = "Select how to use Omen of Clarity procs" })
    -- Thorns
    br.ui:dropdown(section, "Thorns", { choices = { "Player", "Target", "Mouseover", "Focus", "Group" }, value = "Player",
        tip = "Set how to use Thorns" })
    -- Tiger's Fury
    br.ui:checkbox(section, "Tiger's Fury", { tip = "Enable/Disable Using Tiger's Fury" })
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = br.ui:section("Defensive")
    -- Self-Heal In Group
    br.ui:checkbox(section, "Self Heal In Group", { tip = "Enable/Disable Healing Self while Grouped" })
    -- Healing Touch
    br.ui:spinner(section, "Healing Touch", { value = 40, tip = "Health Percent to Cast At" })
    -- Regrowth
    br.ui:spinner(section, "Regrowth", { value = 60, tip = "Health Percent to Cast At" })
    -- Rejuvenation
    br.ui:spinner(section, "Rejuvenation", { value = 80, tip = "Health Percent to Cast At" })
    -- Barkskin
    br.ui:spinner(section, "Barkskin", { value = 50, tip = "Health Percent to Cast At" })
    -- Abolish Poison
    br.ui:checkbox(section, "Abolish Poison", { tip = "Enable/Disable Using Abolish Poison" })
    -- Cure Poison
    br.ui:checkbox(section, "Cure Poison", { tip = "Enable/Disable Using Cure Poison" })
    -- Remove Curse
    br.ui:checkbox(section, "Remove Curse", { tip = "Enable/Disable Using Remove Curse" })
    -- Entangling Roots
    br.ui:checkbox(section, "Entangling Roots", { tip = "Enable/Disable Using Entangling Roots on fleeing enemies" })
    -- Faerie Fire
    br.ui:checkbox(section, "Faerie Fire", { tip = "Enable/Disable Using Faerie Fire/Faerie Fire Feral" })
    -- Nature's Grasp
    br.ui:checkbox(section, "Nature's Grasp", { tip = "Enable/Disable Using Nature's Grasp" })
    -- -- Health Potion
    -- br.ui:createCheckbox(section, "Health Potion", "|cffFFFFFFEnable/Disable Using Health Potion")
    -- -- Mana Potion
    -- br.ui:createCheckbox(section, "Mana Potion", "|cffFFFFFFEnable/Disable Using Mana Potion")
    -- Bash
    br.ui:spinner(section, "Bash", { value = 50, tip = "Health Percent to Cast At" })
    -------------------------
    --- Interrupt Options ---
    -------------------------
    section = br.ui:section("Interrupts")
    -- Bash
    br.ui:checkbox(section, "Bash - Int")
    -- Interrupt Percentage
    br.ui:spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percent to Cast At (0 is random)" })
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
local module
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
local fbMaxEnergy
local lastForm
local lastFormBuff = false
local freeDPS
local freeHeal
local noShapeshiftPower
local needsHealing

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
-- AutoProwl
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

-- Behind check (nil-safe)
-- Prefer the engine API so all profiles share the same fix/behavior.
local function isBehind(thisUnit, otherUnit, degrees)
    if unit == nil or unit.isBehind == nil then return false end
    local result = unit.isBehind(thisUnit, otherUnit, degrees)
    if result == nil or result == false then
        if ui and ui.checked and ui.checked("Behind Debug") then
            ui.debug(string.format(
                "isBehind: FALSE (angle missing or not behind) | thisUnit=%s | otherUnit=%s | degrees=%s",
                tostring(thisUnit), tostring(otherUnit), tostring(degrees)
            ))
        end
        return false
    end
    return true
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
local function updateLastForm()
    if buff.direBearForm.exists() then lastForm = spell.direBearForm end
    if buff.bearForm.exists() then lastForm = spell.bearForm end
    if buff.catForm.exists() then lastForm = spell.catForm end
    if buff.moonkinForm.exists() then lastForm = spell.moonkinForm end

    lastFormBuff = false
    if buff.direBearForm.exists() or buff.bearForm.exists() or buff.catForm.exists() or buff.moonkinForm.exists() then
        lastFormBuff = true
    end

    -- Set default last form if none set
    if lastForm == nil and unit.level() >= 10 and spell.bearForm.known() then
        lastForm = spell.direBearForm.known() and spell.direBearForm or spell.bearForm
    end
    if lastForm == nil and unit.level() >= 20 and spell.catForm.known() then
        lastForm = spell.catForm
    end
end

-- Powershift for Energy
local function powershift()
    if cd.global.remain() == 0 and unit.combatTime() > 1 then
        for i = 1, br._G.GetNumShapeshiftForms() do
            local _, name, active = br._G.GetShapeshiftFormInfo(i)
            if name and active then
                br._G.CancelShapeshiftForm()
                ui.debug("Powershift - Canceling Form")
                br._G.CastShapeshiftForm(i)
                return true
            end
        end
    end
    return false
end


local function needsMarkOfTheWild(thisUnit) return buff.markOfTheWild.refresh(thisUnit) end
local function needsThorns(thisUnit) return buff.thorns.refresh(thisUnit) end

-- Check if we need to cast anything that requires breaking form
local function needsFormBreak()
    -- Buffs
    if ui.checked("Mark of the Wild") then
        var.markUnit = ui.buffUnit("Mark of the Wild", needsMarkOfTheWild, 40)
        if cast.able.markOfTheWild(var.markUnit) and buff.markOfTheWild.refresh(var.markUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.markUnit) < 40
            and (var.markUnit == "player" or unit.player(var.markUnit))
        then
            return true
        end
    end
    if ui.checked("Thorns") then
        var.thornUnit = ui.buffUnit("Thorns", needsThorns, 40)
        if cast.able.thorns(var.thornUnit) and buff.thorns.refresh(var.thornUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.thornUnit) < 40
            and (var.thornUnit == "player" or unit.player(var.thornUnit))
        then
            return true
        end
    end
    if ui.value("Omen of Clarity") ~= 4 and not unit.inCombat() then
        if cast.able.omenOfClarity("player") and buff.omenOfClarity.refresh("player") then
            return true
        end
    end

    -- Defensive actions
    if ui.useDefensive() then
        -- Dispels
        if ui.checked("Abolish Poison") and cast.able.abolishPoison("player")
            and not buff.abolishPoison.exists("player") and cast.dispel.abolishPoison("player")
        then
            return true
        end
        if ui.checked("Cure Poison") and cast.able.curePoison("player")
            and not ui.checked("Abolish Poison") and cast.dispel.curePoison("player")
        then
            return true
        end
        if ui.checked("Remove Curse") and cast.able.removeCurse("player")
            and not unit.inCombat() and cast.dispel.removeCurse("player")
        then
            return true
        end
        -- Entangling Roots
        if ui.checked("Entangling Roots") and cast.able.entanglingRoots("target")
            and unit.exists("target") and not unit.facing("target", "player") and unit.moving("target")
            and unit.valid("target") and unit.hp("target") < 100 and not debuff.entanglingRoots.exists("target")
            and unit.distance("target") > 8 and unit.inCombat()
        then
            return true
        end
        -- Nature's Grasp
        if ui.checked("Nature's Grasp") and cast.able.naturesGrasp()
            and not buff.naturesGrasp.exists("player") and unit.inCombat()
            and #enemies.yards10 > 0
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
        if ui.checked("Rejuvenation") and not cast.current.rejuvenation("target") then
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
        if ui.checked("Healing Touch") and not cast.current.healingTouch() and not unit.moving()
            and (freeHeal or noShapeshiftPower)
        then
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
        and br._G.IsSwimming() and not buff.aquaticForm.exists() and not buff.prowl.exists()
        and unit.moving() and unit.movingTime() > 2 and not unit.anyInAggroRange()
        and not (buff.markOfTheWild.refresh() and ui.checked("Mark of the Wild"))
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
    if ui.checked("Travel Form") and not unit.inCombat() and not br._G.IsMounted()
        and not br._G.IsSwimming() and not br._G.IsFalling() and cast.able.travelForm()
        and not buff.travelForm.exists() and not buff.prowl.exists()
        and unit.moving() and unit.movingTime() > 2 and not unit.anyInAggroRange()
        and not (buff.markOfTheWild.refresh() and ui.checked("Mark of the Wild"))
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

    -- Powershift for Energy (Cat Form with Furor talent)
    if ui.checked("Powershifting") and cast.able.catForm() and buff.catForm.exists() and unit.inCombat() and energy < 30
        and comboPoints < 5 and not buff.clearcasting.exists() and unit.power.mana.percent() > 30
    then
        if powershift() then
            ui.debug("Powershift for Energy")
            return true
        end
    end

    -- Keep Aquatic Form while swimming unless danger/enemy target.
    local keepAquatic = ui.checked("Aquatic Form")
        and br._G.IsSwimming()
        and buff.aquaticForm.exists()
        and not unit.anyInAggroRange()
        and (not unit.exists("target") or unit.friend("target"))

    -- Auto Shapeshift
    if not keepAquatic and not needsFormBreak()
        and ((unit.moving() and unit.movingTime() > ui.value("Shift Wait Time")) or unit.inCombat() or unit.anyInAggroRange(5))
    then
        local formValue = ui.mode.forms
        -- Bear Form
        if formValue == 3 and unit.level() >= 8 and cast.able.bearForm() and not buff.bearForm.exists()
            and not (buff.markOfTheWild.refresh() and ui.checked("Mark of the Wild"))
            and not (buff.thorns.refresh() and ui.checked("Thorns"))
        then
            if cast.bearForm() then
                ui.debug("Casting Bear Form")
                return true
            end
        end
        -- Caster Form
        if formValue == 1 and (buff.bearForm.exists() or buff.catForm.exists()) then
            if unit and unit.cancelForm then
                unit.cancelForm()
            else
                br._G.RunMacroText("/CancelForm")
            end
            ui.debug("Casting Caster Form")
            return true
        end
        -- Cat Form
        if (formValue == 2 or (formValue == 3 and unit.level() < 8)) and unit.level() >= 5
            and cast.able.catForm() and not buff.catForm.exists()
            and not (buff.markOfTheWild.refresh() and ui.checked("Mark of the Wild"))
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
        var.markUnit = ui.buffUnit("Mark of the Wild", needsMarkOfTheWild, 40)
        if cast.able.markOfTheWild(var.markUnit) and buff.markOfTheWild.refresh(var.markUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.markUnit) < 40
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
        var.thornUnit = ui.buffUnit("Thorns", needsThorns, 40)
        if cast.able.thorns(var.thornUnit) and buff.thorns.refresh(var.thornUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.thornUnit) < 40
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
    -- Omen of Clarity
    if ui.value("Omen of Clarity") ~= 4 and not unit.inCombat() then
        if cast.able.omenOfClarity("player") and buff.omenOfClarity.refresh("player") then
            -- Cancel form if needed to buff
            local needsCancel = buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.aquaticForm.exists()
            if needsCancel then
                if unit.cancelFormFor(spell.omenOfClarity) then
                    return true
                end
            else
                if cast.omenOfClarity("player") then
                    ui.debug("Casting Omen of Clarity")
                    return true
                end
            end
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Abolish Poison
        if ui.checked("Abolish Poison") and cast.able.abolishPoison("player")
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
        -- Cure Poison
        if ui.checked("Cure Poison") and cast.able.curePoison("player")
            and (not ui.checked("Abolish Poison") --[[or not spell.known.abolishPoison()]]) and cast.dispel.curePoison("player")
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
            and unit.exists("target") and not unit.facing("target", "player") and unit.moving("target")
            and unit.valid("target") and unit.hp("target") < 100 and not debuff.entanglingRoots.exists("target")
            and unit.distance("target") > 8 and unit.inCombat()
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
        -- Faerie Fire (Caster)
        if ui.checked("Faerie Fire") and cast.able.faerieFire("target")
            and unit.exists("target") and unit.enemy("target") and unit.canAttack("target") and not debuff.faerieFire.exists("target")
            and not (buff.catForm.exists() or buff.bearForm.exists())
            and unit.distance("target") > 8 and noShapeshiftPower
        then
            if cast.faerieFire("target") then
                ui.debug("Casting Faerie Fire")
                return true
            end
        end
        -- Nature's Grasp
        if ui.checked("Nature's Grasp") and cast.able.naturesGrasp()
            and not buff.naturesGrasp.exists("player") and unit.inCombat()
            and #enemies.yards10 > 0
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if unit.cancelFormFor(spell.naturesGrasp, freeDPS) then
                    return true
                end
            else
                if cast.naturesGrasp("player") then
                    ui.debug("Casting Nature's Grasp")
                    return true
                end
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
        if ui.checked("Rejuvenation") and not cast.current.rejuvenation("target") then
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
        if ui.checked("Healing Touch") and not cast.current.healingTouch() and not unit.moving()
            and (freeHeal or noShapeshiftPower)
        then
            if cast.able.healingTouch("target") and unit.friend("target") and unit.hp("target") <= ui.value("Healing Touch") and unit.player("target") then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    if unit.cancelFormFor(spell.healingTouch, freeHeal) then
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
                    if unit.cancelFormFor(spell.healingTouch, freeHeal) then
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
        -- -- Health Potion
        -- if ui.checked("Health Potion") and unit.canUseItem(5512)
        --     and unit.hp() < ui.value("Rejuvenation")
        --     and (not unit.inGroup() or ui.checked("Self Heal In Group"))
        -- then
        --     if buff.catForm.exists() or buff.bearForm.exists() then
        --         br._G.RunMacroText("/CancelForm")
        --         ui.debug("Cancel Form for Health Potion")
        --         return true
        --     end
        --     if unit.useItem(5512) then
        --         ui.debug("Using Health Potion")
        --         return true
        --     end
        -- end
        -- -- Mana Potion
        -- if ui.checked("Mana Potion") and unit.canUseItem(2455)
        --     and unit.power.mana.percent() < 30
        -- then
        --     if buff.catForm.exists() or buff.bearForm.exists() then
        --         br._G.RunMacroText("/CancelForm")
        --         ui.debug("Cancel Form for Mana Potion")
        --         return true
        --     end
        --     if unit.useItem(2455) then
        --         ui.debug("Using Mana Potion")
        --         return true
        --     end
        -- end
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
        -- * Bash
        if ui.checked("Bash - Int") then
            for i = 1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    -- Bash is Bear Form only in Classic; shift first if needed.
                    if not buff.bearForm.exists() and cast.able.bearForm() then
                        if cast.bearForm() then
                            ui.debug("Shifting to Bear Form for Bash interrupt")
                            return true
                        end
                    end
                    if (buff.bearForm.exists() or buff.direBearForm.exists()) and cast.able.bash(thisUnit) then
                        if cast.bash(thisUnit) then
                            ui.debug("Casting Bash on " .. unit.name(thisUnit))
                            return true
                        end
                    end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if ui.useCDs() then
        -- Innervate
        if ui.checked("Self-Innervate") and cast.able.innervate()
            and unit.power.mana.percent() < 30
        then
            if cast.innervate("player") then
                ui.debug("Casting Innervate")
                return true
            end
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
    -- Demoralizing Roar
    if cast.able.demoralizingRoar() and not debuff.demoralizingRoar.exists(units.dyn5)
        and #enemies.yards10 > 0
    then
        if cast.demoralizingRoar() then
            ui.debug("Casting Demoralizing Roar")
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

-- Action List - Cat Opener (Stealth + Non-Stealth)
actionList.CatOpener = function()
    if not buff.catForm.exists() then return false end
    if not unit.valid("target") or unit.deadOrGhost("target") or unit.distance("target") >= 5 then return false end
    if unit.player("target") then return false end

    -- Tiger's Fury gating: if enabled+known and we're at full energy, cast it before opening.
    if ui.checked("Tiger's Fury") and spell.tigersFury.known() and energy == 100 and not buff.tigersFury.exists() then
        if cast.able.tigersFury() and cast.tigersFury() then
            ui.debug("Casting Tiger's Fury [Opener]")
            return true
        end
        return false
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
            and cast.able.ravage() and isBehind("target", "player")
        then
            if cast.ravage("target") then
                ui.debug("Casting Ravage [Stealth Opener]")
                return true
            end
        end

        -- Shred from behind (Opener 3 or fallback)
        if (opener == 3 or (opener <= 2 and not spell.ravage.known()))
            and cast.able.shred() and isBehind("target", "player") and not unit.facing("target", "player")
        then
            if cast.shred("target") then
                ui.debug("Casting Shred [Stealth Opener]")
                return true
            end
        end

        -- Rake (Opener 4 or fallback)
        if ui.checked("Rake") and (opener == 4 or (opener <= 3 and not spell.shred.known()))
            and cast.able.rake()
        then
            if cast.rake("target") then
                ui.debug("Casting Rake [Stealth Opener]")
                return true
            end
        end

        -- Claw (ultimate fallback)
        if ((opener == 4 and not ui.checked("Rake")) or (opener < 4 and not spell.rake.known())) and cast.able.claw() then
            if cast.claw("target") then
                ui.debug("Casting Claw [Stealth Opener]")
                return true
            end
        end

        return false
    end

    -- Non-Stealth Opener
    local behindTarget = isBehind("target", "player")
    if (behindTarget or not spell.shred.known()) then
        -- Shred (from behind)
        local triedShred = false
        if behindTarget and cast.able.shred() then
            if not unit.facing("target", "player") then
                triedShred = true
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

    -- Tiger's Fury
    if ui.checked("Tiger's Fury") and cast.able.tigersFury() and buff.catForm.exists() and energy == 100
        and not buff.tigersFury.exists()
    then
        if cast.tigersFury() then
            ui.debug("Casting Tiger's Fury")
            return true
        end
    end

    -- Faerie Fire (Feral)
    if ui.checked("Faerie Fire") and cast.able.faerieFireFeral() and unit.enemy(units.dyn5) and unit.canAttack(units.dyn5)
        and not debuff.faerieFireFeral.exists(units.dyn5)
        and not unit.isElemental(units.dyn5)
        and unit.ttd(units.dyn5) > cd.global.remain()
    then
        if cast.faerieFireFeral() then
            ui.debug("Casting Faerie Fire (Feral)")
            return true
        end
    end

    -- 5 Combo Points - Finishers
    if comboPoints == 5 and not finish then
        -- Ferocious Bite (low energy)
        if cast.able.ferociousBite(units.dyn5) and energy >= 35 and energy < 60 then
            if cast.ferociousBite(units.dyn5) then
                ui.debug("Casting Ferocious Bite")
                return true
            end
        end
        -- Rip
        if ui.checked("Rip") and cast.able.rip() and unit.ttd(units.dyn5) > 6 and debuff.rip.refresh(units.dyn5) then
            if cast.rip(units.dyn5) then
                ui.debug("Casting Rip")
                return true
            end
        end
    end

    -- Combo Point Builders
    if (comboPoints < 5 or energy >= 60 or freeDPS) and not finish then
        -- Ravage (from Prowl)
        local behindRavage = isBehind(units.dyn5, "player")
        if behindRavage then debugBehind("Ravage behind=true", units.dyn5) end
        if cast.able.ravage() and buff.prowl.exists() and behindRavage then
            if cast.ravage(units.dyn5) then
                ui.debug("Casting Ravage")
                return true
            end
        end
        -- Rake
        if ui.checked("Rake") and cast.able.rake() and debuff.rake.refresh(units.dyn5)
            and (unit.ttd(units.dyn5) <= 3 or not spell.ferociousBite.known())
            and not freeDPS
        then
            if cast.rake(units.dyn5) then
                ui.debug("Casting Rake")
                return true
            end
        end
        -- Shred (from behind)
        local behindDyn5 = isBehind(units.dyn5, "player")
        if behindDyn5 then debugBehind("Shred behind=true", units.dyn5) end

        local triedShred = false
        if behindDyn5 and cast.able.shred() then
            if not unit.facing(units.dyn5, "player") then
                triedShred = true
                if cast.shred(units.dyn5) then
                    ui.debug("Casting Shred")
                    return true
                end
            end
        end
        -- Claw (not behind)
        if cast.able.claw() and (not spell.shred.known() or not behindDyn5) then
            if cast.claw(units.dyn5) then
                ui.debug("Casting Claw")
                return true
            end
        end
    end
end -- End Action List - Cat Form

-- Action List - Caster Form
actionList.CasterForm = function()
    -- Moonfire
    if cast.able.moonfire(units.dyn40AOE) and debuff.moonfire.refresh(units.dyn40AOE) then
        if cast.moonfire(units.dyn40AOE) then
            ui.debug("Casting Moonfire")
            return true
        end
    end
    -- Starfire (if available)
    if cast.able.starfire() and not unit.moving() and cast.able.starfire() and unit.level() >= 20
        and (debuff.moonfire.exists(units.dyn40AOE) or not spell.moonfire.known())
        and (not cast.last.starfire() or cast.timeSinceLast.starfire() > unit.gcd(true) + 0.5)
    then
        if cast.starfire() then
            ui.debug("Casting Starfire")
            return true
        end
    end
    -- Wrath
    if cast.able.wrath() and not unit.moving()
        and (unit.level() < 20 or not spell.starfire.known())
        and (debuff.moonfire.exists(units.dyn40AOE) or not spell.moonfire.known())
        and (not cast.last.wrath() or cast.timeSinceLast.wrath() > unit.gcd(true) + 0.5)
    then
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
            if ui.checked("Prowl") and cast.able.prowl("player") and buff.catForm.exists() and autoProwl() and ui.mode.prowl == 1
                and not buff.prowl.exists() and not unit.resting()
            then
                if cast.prowl("player") then
                    ui.debug("Casting Prowl [Precombat]")
                    return true
                end
            end
        end -- End No Stealth
        if unit.valid("target") then
            local formValue = ui.mode.forms
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
                -- Bear Form
                if formValue == 3 and buff.bearForm.exists() then
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
        local formValue = ui.mode.forms
        ------------------------
        --- In Combat - Main ---
        ------------------------
        -- Start Attack (do not break Prowl)
        if not buff.prowl.exists() and unit.exists(units.dyn5) and not cast.auto.autoAttack() and not unit.deadOrGhost("target") then
            StartAttack()
            ui.debug("Casting Auto Attack")
            return true
        end

        -- Wait for swing if in melee range
        if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            local swing = (br.player.swing and br.player.swing.mh and br.player.swing.mh.timer) or 0
            -- ui.debug("Swing Timer: " .. tostring(swing) .. " | Distance: " .. tostring(unit.distance(units.dyn5)))
            if swing and swing > 0 and swing < 0.3 then
                -- ui.debug("Waiting for swing: " .. br.functions.misc:round2(swing) .. "s")
                return true
            end
        end

        -- Call Action List - Cooldowns
        if actionList.Cooldowns() then return true end

        -- Last Form restoration
        if ui.checked("Last Form") and lastForm ~= nil
            and (((unit.moving() and unit.movingTime() > 2 and (not spell.travelForm.known() or not ui.checked("Travel Form")))
                or (unit.inCombat() or unit.anyInAggroRange(5)) and ((unit.exists("target") and not unit.friend("target")) or not unit.exists("target")))
            and not lastFormBuff and not (buff.aquaticForm.exists() or buff.travelForm.exists() or unit.anyInAggroRange(5)))
        then
            if cast.able.catForm() and lastForm == spell.catForm then
                if cast.catForm() then
                    ui.debug("Casting Last Form [Cat]")
                    return true
                end
            end
            if cast.able.bearForm() and (lastForm == spell.bearForm or lastForm == spell.direBearForm) then
                if cast.bearForm() then
                    ui.debug("Casting Last Form [Bear]")
                    return true
                end
            end
        end

        -- Call Action List - Bear Form
        if formValue == 3 and buff.bearForm.exists() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            if actionList.BearForm() then return true end
        end

        -- Call Action List - Cat Form
        if formValue == 2 and buff.catForm.exists() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            if buff.prowl.exists() and actionList.CatOpener() then return true end
            if actionList.CatForm() then return true end
        end

        -- Call Action List - Caster Form
        if formValue == 1 and not (buff.catForm.exists() or buff.bearForm.exists()) then
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
    module      = br.player.module
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    spell       = br.player.spell
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or ui.pause() or ui.mode.rotation == 4 or unit.id("target") == 156716
    -- Units
    units.get(5)        -- Makes a variable called, units.dyn5
    units.get(40)       -- Makes a variable called, units.dyn40
    units.get(40, true) -- Makes a variable called, units.dyn40AOE
    -- Enemies
    enemies.get(5)      -- Makes a varaible called, enemies.yards5
    enemies.get(20)     -- Makes a varaible called, enemies.yards20
    enemies.get(20, "player", true)        -- makes enemies.yards20nc
    enemies.get(40)     -- Makes a varaible called, enemies.yards40

    -- Profile Specific Locals
    fbMaxEnergy = energy >= 50

    -- Update Last Form tracking
    updateLastForm()

    -- Omen of Clarity Logic
    local omenSetting = ui.value("Omen of Clarity")
    needsHealing = (ui.checked("Regrowth") and unit.hp() <= ui.value("Regrowth"))
        or (ui.checked("Healing Touch") and unit.hp() <= ui.value("Healing Touch"))
        or (ui.checked("Rejuvenation") and unit.hp() <= ui.value("Rejuvenation"))

    freeDPS = omenSetting ~= 4 and omenSetting ~= 2 and buff.clearcasting.exists()
        and (not needsHealing or omenSetting == 3)

    freeHeal = omenSetting ~= 4 and omenSetting ~= 3 and buff.clearcasting.exists()

    -- No Shapeshift Power check
    noShapeshiftPower = ((not buff.catForm.exists() or (buff.catForm.exists() and energy < ui.value("Energy")))
        and (not buff.bearForm.exists() or (buff.bearForm.exists() and rage < ui.value("Rage"))))
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
    specID    = 283,
    expansion = "Classic",
    author    = "CuteOne",
    patch     = "1.12",
    coverage  = "100%",
    status    = "Full",
    readiness = "Untested",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})
