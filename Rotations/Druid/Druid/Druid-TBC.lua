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
        { name = "Auto", icon = "tigersFury", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On", icon = "tigersFury", overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target." },
        { name = "Off", icon = "tigersFury", overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used." },
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
    -- Cower
    br.ui:checkbox(section, "Cower", { tip = "Use Cower (20 energy) to drop threat when being attacked while a tank is alive and nearby" })
    -- Mangle Trick
    br.ui:checkbox(section, "Mangle Trick", { tip = "At energy 60-61 with tick <1s away, cast Mangle instead of Shred to enable a double-Mangle combo-point cycle (advanced, Wolfshead recommended)." })
    -- Rake/Bite Tricks
    br.ui:checkbox(section, "Rake/Bite Tricks", { tip = "With Wolfshead at 35-39 energy and tick >1s away, cast Rake (no debuff) or Ferocious Bite (2+ CPs) instead of powershifting (advanced)." })
    -- Biteweave
    br.ui:checkbox(section, "Biteweave", { tip = "|cffFF4444[TBC sub-optimal]|cffFFFFFF FB bonus energy converts at ~1-5 dmg/energy vs a wasted-CP Shred's ~35-45 dmg/energy. Enabling this intercepts and replaces what would otherwise be a Shred, for a net DPS loss. Enable only for personal preference." })
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
    br.ui:spinner(section, "Energy", { value = 35, min = 1, step = 1,
        tip = "Shift when energy drops below this. 35 = no Wolfshead (auto); 40 = Wolfshead Helm (auto-detected and raised). Covers the gap between post-ability energy and the cost of the next builder." })
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
    -- Maim
    br.ui:checkbox(section, "Maim")
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
local has
local rage
local mana
local module
local ui
local unit
local units
local spell
local var = {}

-- Profile Specific Locals - Any custom to profile locals
local actionList = {}

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
-- Time (seconds) until the next discrete energy tick (+20 every 2s).
-- Detected by polling: whenever current energy jumps by 15-25, a tick fired.
-- Upper bound of 25 filters out powershifts (which give +25 to +60) so they
-- don't falsely reset the 2s countdown and produce a stale tick estimate.
local function timeToNextEnergyTick()
    if var.lastEnergyTickTime == nil then var.lastEnergyTickTime = 0 end
    if var.lastEnergyObserved == nil then var.lastEnergyObserved = 0 end
    local current = br.player.power.energy() or 0
    local energyJump = current - var.lastEnergyObserved
    if energyJump >= 15 and energyJump <= 25 then
        var.lastEnergyTickTime = br._G.GetTime()
    end
    var.lastEnergyObserved = current
    if var.lastEnergyTickTime == 0 then return 2.0 end
    return math.max(0, (var.lastEnergyTickTime + 2.0) - br._G.GetTime())
end

-- AutoProwl
-- local function autoProwl()
--     if not unit.inCombat() and not buff.prowl.exists() then
--         if #enemies.yards20 > 0 then return true end
--         if #enemies.yards20nc > 0 then
--             for i = 1, #enemies.yards20nc do
--                 local thisUnit = enemies.yards20nc[i]
--                 local threatRange = math.max((20 + (unit.level(thisUnit) - unit.level())), 5)
--                 local react = unit.reaction(thisUnit) or 10
--                 if unit.distance(thisUnit) < threatRange and (react < 4 or (unit.isUnit("target", thisUnit) and react == 4))
--                     and unit.enemy(thisUnit) and unit.canAttack(thisUnit) and not unit.deadOrGhost(thisUnit)
--                 then
--                     return true
--                 end
--             end
--         end
--         -- if unit.isDummy("target") and unit.distance("target") < 20 then return true end
--     end
--     return false
-- end

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
    if thisUnit == nil then thisUnit = "target" end
    if comboPoints() <= 0 or unit.isDummy(thisUnit) then return false end

    local spellID = spell.ferociousBite.id()
    if spellID == 0 then return false end
    local cp = comboPoints()
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

-- Time Moving

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

-- True when a party/raid member (not us) is in combat and currently targeting thisUnit —
-- i.e. our group has already engaged it. Lets us pre-emptively Prowl to open from stealth
-- on a mob the group pulled (even while it's in combat). Solo players short-circuit.
local function engagedByGroup(thisUnit)
    local n = unit.groupCount()
    if n <= 1 then return false end
    local inRaid = br._G.IsInRaid()
    local prefix = inRaid and "raid" or "party"
    -- Raid tokens are raid1..raidN (include us, filtered out below); party tokens are
    -- party1..party(N-1) with the player addressed separately as "player".
    local last = inRaid and n or (n - 1)
    for i = 1, last do
        local member = prefix .. i
        if not unit.isUnit(member, "player")
            and br._G.UnitAffectingCombat(member)
            and unit.isUnit(member .. "target", thisUnit)
        then
            return true
        end
    end
    return false
end

-- Aggro/proximity radius for a mob, scaled by level difference (a mob's aggro range grows
-- ~1y per level it is above us and shrinks per level below, floored at 5y). The +offset
-- buffer (default 5) makes callers fire just BEFORE we would cross into that radius — e.g.
-- pre-emptive Prowl happens a few yards before proximity aggro, not after.
local function aggroRadius(thisUnit, offset)
    return math.max((20 + (unit.level(thisUnit) - unit.level())), 5) + (offset or 5)
end

-- In Aggro Range Check
-- Drives auto-Prowl, auto-shapeshift, and "keep travel/aquatic form". Returns true when a
-- mob that would actually proximity-aggro us is within its (level-scaled) aggro radius:
--   * fresh hostile — unit.enemy (UnitIsEnemy → hostile only, excludes neutral) AND not
--     already in combat, so it will proximity-aggro us. Raw UnitAffectingCombat is used
--     instead of unit.inCombat() (the latter ORs in player-only options like "Ignore
--     Combat"/tank-aggro that would misreport a mob).
--   * group-engaged — a party/raid member already pulled it; we want to open from stealth
--     too even though it's in combat (with our group).
-- A NEUTRAL mob we have targeted is intentionally NOT counted here: neutrals don't
-- proximity-aggro, so Prowl for them is deferred to near-melee in the PreCombat prowl gate.
-- (The old `not unit.friend()` test wrongly counted every neutral mob and every mob fighting
-- someone outside our group.)
local function inAggroRange(offset)
    offset = offset or 5
    for i = 1, #enemies.yards20nc do
        local thisUnit = enemies.yards20nc[i]
        if unit.canAttack(thisUnit) and not unit.deadOrGhost(thisUnit) then
            local freshHostile = unit.enemy(thisUnit) and not br._G.UnitAffectingCombat(thisUnit)
            if freshHostile or engagedByGroup(thisUnit) then
                if unit.distance(thisUnit) < aggroRadius(thisUnit, offset) then
                    -- ui.debug("Prowl trigger: " .. unit.name(thisUnit) .. " at " .. tostring(unit.distance(thisUnit)) .. "y")
                    return true
                end
            end
        end
    end
    return false
end

local function needsMarkOfTheWild(thisUnit) return buff.markOfTheWild.refresh(thisUnit) end
local function needsThorns(thisUnit) return buff.thorns.refresh(thisUnit) end

-- Keep Aquatic Form while swimming unless danger/enemy target.
var.keepAquatic = function()
    return ui.checked("Aquatic Form")
        and br._G.IsSwimming()
        and buff.aquaticForm.exists()
        and not inAggroRange()
        and (not unit.exists("target") or unit.friend("target"))
end

--------------------
--- Action Lists ---
--------------------

-- Action List - Extra
actionList.Extra = function()
    -- Gift of the Wild (group buff, reagent required)
    if ui.checked("Mark of the Wild") and not unit.flying() and not buff.prowl.exists() then
        local inGroup = unit.inGroup()
        local hasGift = spell.giftOfTheWild and spell.giftOfTheWild.known and spell.giftOfTheWild.known()
        local hasReagent = has.item(17026) -- Wild Thornroot
        if inGroup and hasGift and hasReagent and mana() > cast.cost.giftOfTheWild() + var.formCost then
            -- Check if anyone in group needs the buff
            local needsGift = false
            for i = 1, #br.engines.healingEngine.friend do
                local u = br.engines.healingEngine.friend[i].unit
                if buff.markOfTheWild.refresh(u) and not buff.giftOfTheWild.exists(u, "") and unit.distance(u) < 40 then
                    needsGift = true
                    break
                end
            end
            if needsGift and cast.able.giftOfTheWild and cast.able.giftOfTheWild("player") then
                -- Cancel form if needed to buff
                local needsCancel = buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.aquaticForm.exists()
                if needsCancel then
                    if unit.cancelFormFor(spell.giftOfTheWild) then
                        return true
                    end
                else
                    if cast.giftOfTheWild and cast.giftOfTheWild("player") then
                        ui.debug("Casting Gift of the Wild")
                        return true
                    end
                end
            end
        end
        -- Fallback to Mark of the Wild (single buff or no reagent)
        if mana() > cast.cost.markOfTheWild() + var.formCost then
            var.markUnit = ui.buffUnit("Mark of the Wild", needsMarkOfTheWild, 40)
            if cast.able.markOfTheWild(var.markUnit) and buff.markOfTheWild.refresh(var.markUnit)
                and not unit.inCombat() and not unit.resting() and unit.distance(var.markUnit) < 40
                and (var.markUnit == "player" or unit.player(var.markUnit)) and unit.friend(var.markUnit)
                and not buff.giftOfTheWild.exists(var.markUnit, "")
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
    end
    -- Thorns
    if ui.checked("Thorns") and not unit.flying() and not buff.prowl.exists() and mana() > cast.cost.thorns() + var.formCost then
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
    if ui.value("Omen of Clarity") ~= 4 and not unit.flying() and not unit.inCombat() and not unit.resting() and not buff.prowl.exists()
        and mana() > cast.cost.omenOfClarity() + var.formCost
    then
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
            and mana() > cast.cost.abolishPoison() + var.formCost
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
            and (not ui.checked("Abolish Poison") --[[or not spell.abolishPoison.known()]]) and cast.dispel.curePoison("player")
            and mana() > cast.cost.curePoison() + var.formCost
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
            and mana() > cast.cost.removeCurse() + var.formCost
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
            and mana() > cast.cost.barkskin() + var.formCost
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
            and mana() > cast.cost.entanglingRoots() + var.formCost
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if unit.cancelFormFor(spell.entanglingRoots, buff.clearcasting.exists()) then
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
        if ui.checked("Faerie Fire") and cast.able.faerieFire("target") and not buff.prowl.exists() and var.formValue == 1
            and unit.exists("target") and unit.enemy("target") and unit.canAttack("target") and not debuff.faerieFire.exists("target", "any") and not debuff.faerieFireFeral.exists("target", "any")
            and not (buff.catForm.exists() or buff.bearForm.exists())
            and unit.distance("target") > 8 and mana() > cast.cost.faerieFire() + var.formCost
        then
            if cast.faerieFire("target") then
                ui.debug("Casting Faerie Fire")
                return true
            end
        end
        -- Nature's Grasp
        if ui.checked("Nature's Grasp") and cast.able.naturesGrasp()
            and not buff.naturesGrasp.exists("player") and unit.inCombat()
            and #enemies.yards10 > 0 and mana() > cast.cost.naturesGrasp() + var.formCost
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if unit.cancelFormFor(spell.naturesGrasp, buff.clearcasting.exists()) then
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
            and (buff.clearcasting.exists() or mana() > cast.cost.regrowth() + var.formCost)
            and (not unit.inGroup() or ui.checked("Self Heal In Group"))
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if unit.cancelFormFor(spell.regrowth, buff.clearcasting.exists()) then
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
        if ui.checked("Rejuvenation") and not cast.current.rejuvenation("target") and mana() > cast.cost.rejuvenation() + var.formCost then
            if cast.able.rejuvenation("target") and unit.friend("target") and unit.hp("target") <= ui.value("Rejuvenation")
                and unit.player("target") and buff.rejuvenation.refresh("target")
            then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    if unit.cancelFormFor(spell.rejuvenation, buff.clearcasting.exists()) then
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
                    if unit.cancelFormFor(spell.rejuvenation, buff.clearcasting.exists()) then
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
            and (buff.clearcasting.exists() or mana() > cast.cost.healingTouch() + var.formCost)
            and cast.timeSinceLast.healingTouch() > unit.gcd(true)
        then
            if cast.able.healingTouch("target") and unit.friend("target") and unit.hp("target") <= ui.value("Healing Touch") and unit.player("target") then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    if unit.cancelFormFor(spell.healingTouch, buff.clearcasting.exists()) then
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
                    if unit.cancelFormFor(spell.healingTouch, buff.clearcasting.exists()) then
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
        --     and mana.percent() < 30
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
        -- Outer-guards hoisted to function-top: these are per-call decisions, not
        -- per-iteration. Merging the two parallel yards5f loops into one shares
        -- the interruptable check across both spells. See AUDIT.md L24.
        --
        -- USER-FACING BEHAVIOR CHANGE: Interrupt threshold (ui.value) is read once
        -- per call instead of per enemy. UI value changes mid-pulse now apply on
        -- the next pulse rather than mid-loop. Same category as L01's accurate
        -- counts and L08's cast-gate behavior on Classic-era — small, defensible,
        -- documented so a future user report can find the change.
        local bashEnabled = ui.checked("Bash - Int")
        local maimEnabled = ui.checked("Maim") and buff.catForm.exists() and comboPoints() > 0 and energy() >= 35
        if not bashEnabled and not maimEnabled then return end
        local interruptAt = ui.value("Interrupt At")
        local isBearForm  = buff.bearForm.exists() or buff.direBearForm.exists()

        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if unit.interruptable(thisUnit, interruptAt) then
                if bashEnabled and isBearForm and cast.able.bash(thisUnit) then
                    if cast.bash(thisUnit) then
                        ui.debug("Casting Bash on " .. unit.name(thisUnit))
                        return true
                    end
                elseif maimEnabled and cast.able.maim(thisUnit) then
                    if cast.maim(thisUnit) then
                        ui.debug("Casting Maim on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if not buff.prowl.exists() and unit.distance("target") < 5 then
        -- * Module- Basic Trinkets
        -- use_items
        module.BasicTrinkets()
        -- Innervate
        if ui.checked("Self-Innervate") and ui.useCDs()
            and cast.able.innervate() and mana.percent() < 30
        then
            if cast.innervate("player") then
                ui.debug("Casting Innervate")
                return true
            end
        end
    end
end -- End Action List - Cooldowns

-- Action List - Form Management
actionList.FormManagement = function()
    -- Aquatic Form
    if ui.checked("Aquatic Form") and not unit.inCombat() and cast.able.aquaticForm()
        and br._G.IsSwimming() and not buff.aquaticForm.exists() and not buff.prowl.exists()
        and unit.moving() and unit.movingTime() > 2 and not inAggroRange()
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
        and unit.moving() and unit.movingTime() > 2 and not inAggroRange()
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

    -- Auto Shapeshift
    if not var.keepAquatic() --and not needsFormBreak()
        and ((unit.moving() and unit.movingTime() > ui.value("Shift Wait Time")) or unit.inCombat() or inAggroRange(5))
    then
        -- Bear Form
        if var.formValue == 3 and (spell.bearForm.known() or spell.direBearForm.known())
            and ((cast.able.bearForm() and not spell.direBearForm.known()) or cast.able.direBearForm())
            and not buff.bearForm.exists() and not buff.direBearForm.exists()
        then
            if spell.direBearForm.known() then
                if cast.direBearForm() then
                    ui.debug("Casting Dire Bear Form")
                    return true
                end
            else
                if cast.bearForm() then
                    ui.debug("Casting Bear Form")
                    return true
                end
            end
        end
        -- Cat Form
        if (var.formValue == 2 or (var.formValue == 3 and unit.level() < 8)) and unit.level() >= 5
            -- and not unit.inCombat()
            and cast.able.catForm() and not buff.catForm.exists()
            and not (buff.aquaticForm.exists() or buff.travelForm.exists() or buff.flightForm.exists() or buff.swiftFlightForm.exists())
        then
            if cast.catForm() then
                ui.debug("Casting Cat Form")
                return true
            end
        end
        -- Caster Form
        if var.formValue == 1 and (buff.bearForm.exists() or buff.direBearForm.exists() or buff.catForm.exists()) then
            if unit and unit.cancelForm then
                unit.cancelForm()
            else
                br._G.RunMacroText("/CancelForm")
            end
            ui.debug("Casting Caster Form")
            return true
        end
    end
end -- End Action List - Form Management

-- Action List - Bear Form
actionList.BearForm = function()
    -- -- Bear Form
    -- if ((cast.able.bearForm() and not spell.direBearForm.known()) or cast.able.direBearForm())
    --     and not buff.bearForm.exists() and not buff.direBearForm.exists()
    --     and not (buff.markOfTheWild.refresh() and ui.checked("Mark of the Wild"))
    --     and not (buff.thorns.refresh() and ui.checked("Thorns"))
    -- then
    --     if spell.direBearForm.known() then
    --         if cast.direBearForm() then
    --             ui.debug("Casting Dire Bear Form")
    --             return true
    --         end
    --     else
    --         if cast.bearForm() then
    --             ui.debug("Casting Bear Form")
    --             return true
    --         end
    --     end
    -- end
    -- Enrage
    if cast.able.enrage() and not unit.deadOrGhost("target") and not buff.enrage.exists() and rage() < 10 and unit.hp() > 80 then
        if cast.enrage() then
            ui.debug("Casting Enrage")
            return true
        end
    end
    -- Demoralizing Roar
    -- when any enemy in reach needs it, not just the target (the cast system won't roar while a
    -- mob that isn't fighting us is in reach)
    if cast.able.demoralizingRoar() and #enemies.yards10 > 0 and debuff.demoralizingRoar.refreshCount(10) > 0 then
        if cast.demoralizingRoar() then
            ui.debug("Casting Demoralizing Roar")
            return true
        end
    end
    -- Mangle (highest priority — applies +30% bleed debuff, highest threat/DPS)
    if cast.able.mangleBear("target") then--and not debuff.mangleBear.exists("target") then
        if cast.mangleBear("target") then
            ui.debug("Casting Mangle")
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
    if cast.able.maul("target") and (ui.useST(8,3) or not spell.swipe.known()) then
        if cast.maul("target") then
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

    -- Tiger's Fury pre-opener: buff Ravage/opener damage if TF is ready (costs 30 energy;
    -- adds flat physical damage per hit for 6s — TBC TF gives no energy return).
    -- Do not block the opener if TF is on cooldown — proceed immediately in that case.
    if ui.checked("Tiger's Fury") and spell.tigersFury.known() and not buff.tigersFury.exists()
        and energy() >= 30 and cast.able.tigersFury()
    then
        if cast.tigersFury() then
            ui.debug("Casting Tiger's Fury [Opener]")
            return true
        end
    end

    local isStealth = buff.prowl.exists()
    local behindTarget = isBehind("target", "player")
    local mangleDebuffUp = debuff.mangleCat.exists("target","any") or debuff.mangleBear.exists("target","any")

    -- Stealth Opener
    if isStealth then
        if behindTarget then
            -- Behind: fire the best available ability immediately; no need to hold
            -- Ravage: best stealth ability, requires being behind
            if cast.able.ravage("target") then
                if cast.ravage("target") then
                    ui.debug("Casting Ravage [Stealth Opener]")
                    return true
                end
            end
            -- Mangle: apply debuff to improve Shred damage; skip if Ravage known or debuff already up
            if cast.able.mangleCat("target") and not spell.ravage.known() and not mangleDebuffUp and unit.standingTime() > 1 then
                if cast.mangleCat("target") then
                    ui.debug("Casting Mangle [Stealth Opener]")
                    return true
                end
            end
            -- Shred: Ravage not known, and debuff is already up or Mangle not known
            if cast.able.shred("target") and not spell.ravage.known()
                and (mangleDebuffUp or not spell.mangleCat.known())
            then
                if cast.shred("target") then
                    ui.debug("Casting Shred [Stealth Opener]")
                    return true
                end
            end
        else
            -- Facing the target. Only hold Mangle back for Ravage when BOTH:
            --   1) currently prowling (already guaranteed by this block), AND
            --   2) Ravage is known
            -- If either condition fails, use Mangle immediately.
            if isStealth and spell.ravage.known() and unit.standingTime() <= 1 then return false end
            -- Positioning window closed, or Ravage not known; commit from the front
            -- Only cast Mangle if the debuff isn't already present
            if cast.able.mangleCat("target") and not mangleDebuffUp then
                if cast.mangleCat("target") then
                    ui.debug("Casting Mangle [Stealth Opener]")
                    return true
                end
            end
        end
        -- Claw: ultimate fallback — only if Mangle and Shred are not known
        if cast.able.claw("target") and not spell.mangleCat.known() and not spell.shred.known() then
            if cast.claw("target") then
                ui.debug("Casting Claw [Stealth Opener]")
                return true
            end
        end
        return false
    end

    -- Non-Stealth Opener
    -- Mangle first: apply debuff to improve Shred damage; skip if debuff already up
    if cast.able.mangleCat("target") and not mangleDebuffUp then
        if cast.mangleCat("target") then
            ui.debug("Casting Mangle [Opener]")
            return true
        end
    end
    -- Shred from behind: debuff is up or Mangle not known
    if behindTarget and cast.able.shred("target") and (mangleDebuffUp or not spell.mangleCat.known()) then
        if cast.shred("target") then
            ui.debug("Casting Shred [Opener]")
            return true
        end
    end
    -- Claw: fallback — only if Mangle and Shred are not known
    if cast.able.claw("target") and not spell.mangleCat.known() and not spell.shred.known() then
        if cast.claw("target") then
            ui.debug("Casting Claw [Opener]")
            return true
        end
    end

    return false
end

-- Action List - Cat Form
actionList.CatForm = function()
    if unit.inCombat("player") and buff.catForm.exists() then
        -- Per-tick state hoists for the CatForm action list. Each query below is
        -- called 3-6 times throughout the function with identical arguments;
        -- hoisting collapses each cluster to a single call per pass. Scope
        -- intentionally extended beyond L22's original "aura-scan reduction"
        -- wording — cp (4 sites) and clearcasting (6 sites) are higher-repetition
        -- than mangleBearUp (3 sites) so they're the more impactful instance of
        -- the same pattern. Skipped: energy() (12+ sites, different freshness
        -- shape), buff.catForm (only 2 sites, marginal), debuff.mangleCat.*
        -- (3 different API methods called once each, no redundancy). See
        -- AUDIT.md L22 for the scope-extension rationale.
        local cp           = comboPoints()
        local clearcasting = buff.clearcasting.exists()
        local ttd          = unit.ttd(units.dyn5)
        local mangleBearUp = debuff.mangleBear.exists(units.dyn5, "any")
        -- Cower (threat reduction)
        -- Only drop threat if a Warrior or Paladin is alive and nearby — in TBC these are the
        -- only reliable tanks. If none is present (dead or out of range) it is safer to keep
        -- aggro on ourselves rather than risk handing it to a healer or caster.
        if ui.checked("Cower") and cast.able.cower() and energy() >= 20 and unit.inGroup()
            and unit.threatStatus() >= 2 and unit.isTankInRange()
        then
            if cast.cower() then
                ui.debug("Casting Cower [Threat Reduction]")
                return true
            end
        end
        -- Tiger's Fury — use on cooldown at <= 35 energy (at or below Rake cost).
        -- TF costs 30 energy and adds flat physical damage per hit for 6s (rank-based,
        -- e.g. +40 at max rank in 2.5.x; it is NOT an energy return — that's WotLK).
        -- At 36-39 energy Rake is preferred (bleed+CP > TF flat bonus per wowsims), and
        -- at 36-39 with Wolfshead the powershift fires instead (shift gives 60 energy).
        -- Gate on !clearcasting: don't burn 30 energy when a free OoC proc is available.
        if ui.checked("Tiger's Fury") and cast.able.tigersFury() and buff.catForm.exists()
            and not buff.tigersFury.exists() and energy() <= 35 and not clearcasting
        then
            if cast.tigersFury() then
                ui.debug("Casting Tiger's Fury")
                return true
            end
        end

        -- Pre-compute flags reused by multiple checks below.
        local finish    = ferociousBiteFinish(units.dyn5)
        -- biteAtEnd: target dies before Rip completes all ticks — skip Rip, use FB instead.
        -- No energy cap on this path: a dying target should receive excess energy as FB bonus damage.
        local biteAtEnd = cp >= 5 and ttd < 6
        -- tickIn: seconds until the next 2-second energy tick; reused by tricks and powershift gate.
        local tickIn    = timeToNextEnergyTick()
        -- Ferocious Bite - Finish Him! (execute: min damage >= target HP, any CP count)
        -- Only fire when we can't fit a builder first (energy < builder floor).
        -- If energy >= 40 (Mangle cost) a builder should come before FB to avoid
        -- sinking excess energy into FB damage rather than generating a combo point.
        if cast.able.ferociousBite(units.dyn5) and energy() >= 35 and finish then
            if cast.ferociousBite(units.dyn5) then
                ui.debug("Casting Ferocious Bite [Finish Him!]")
                return true
            end
        end

        -- 5 Combo Points - Finishers
        if cp >= 5 and not clearcasting and not finish then
            -- biteAtEnd: target dying (<6s TTD) — skip Rip (ticks won't complete) and dump
            -- excess energy into FB bonus damage. No energy cap on this path.
            if biteAtEnd and cast.able.ferociousBite(units.dyn5) and energy() >= 35 then
                if cast.ferociousBite(units.dyn5) then
                    ui.debug("Casting Ferocious Bite [Fight End]")
                    return true
                end
            end
            -- Rip: apply when missing, or refresh at <= 2s remaining before it falls off entirely.
            -- Gate on ttd > 6 (matches biteAtEnd threshold) and energy >= 30 so we never apply
            -- Rip and be immediately stuck unable to cast a single builder.
            if ui.checked("Rip") and cast.able.rip(units.dyn5) and ttd > 6
                and (not debuff.rip.exists(units.dyn5) or debuff.rip.remain(units.dyn5) <= 2)
                and not biteAtEnd and energy() >= 30
            then
                if cast.rip(units.dyn5) then
                    ui.debug("Casting Rip")
                    return true
                end
            end
            -- Ferocious Bite (Rip not learned, or target dying at TTD <= 6).
            -- Do NOT include "Rip is running" as a trigger: FB bonus energy converts at
            -- ~1-5 dmg/energy in TBC vs a wasted-CP Shred's ~35-45 dmg/energy. When Rip is
            -- running and energy >= 40 the builder block already fires a wasted-CP Shred, which
            -- is strictly better. This path only covers early levels (no Rip) or execute windows.
            if cast.able.ferociousBite(units.dyn5) and energy() >= 35 and energy() < 40
                and (not spell.rip.known() or ttd <= 6)
            then
                if cast.ferociousBite(units.dyn5) then
                    ui.debug("Casting Ferocious Bite")
                    return true
                end
            end
        end

        -- Biteweave: while Rip is active at 5 CPs, use Ferocious Bite at 35-56 energy to
        -- spend energy productively rather than letting it cap out.
        -- At energy >= 57+cutoffMod (cutoffMod=20 when tick >1s), Shred is more efficient;
        -- fall through to the builder block which handles it naturally.
        if ui.checked("Biteweave") and debuff.rip.exists(units.dyn5) and cp >= 5
            and not finish and not biteAtEnd and cast.able.ferociousBite(units.dyn5)
            and energy() >= 35
        then
            local cutoffMod = (tickIn > 1.0) and 20 or 0
            if energy() < (57 + cutoffMod) then
                if cast.ferociousBite(units.dyn5) then
                    ui.debug("Casting Ferocious Bite [Biteweave]")
                    return true
                end
            end
            -- energy >= 57+cutoffMod: Shred is more efficient; fall through to builder block
        end

        -- Rake/Bite Tricks: when energy is 35-39 and the next tick is >1s away (would
        -- otherwise powershift with Wolfshead threshold=40), spend it on a useful action.
        if ui.checked("Rake/Bite Tricks") and tickIn > 1.0 and energy() >= 35 and energy() <= 39 then
            -- Rake Trick: apply Rake if the debuff is missing (35 energy)
            if ui.checked("Rake") and cast.able.rake(units.dyn5) and not debuff.rake.exists(units.dyn5) then
                if cast.rake(units.dyn5) then
                    ui.debug("Casting Rake [Rake Trick]")
                    return true
                end
            end
            -- Bite Trick: Ferocious Bite at 2+ CPs instead of shifting
            if cast.able.ferociousBite(units.dyn5) and cp >= 2 and not clearcasting then
                if cast.ferociousBite(units.dyn5) then
                    ui.debug("Casting Ferocious Bite [Bite Trick]")
                    return true
                end
            end
        end

        -- Powershift for Energy — fires before builders so a low energy bar triggers a shift
        -- instead of a cheaper builder cast that would delay the next shift cycle.
        -- Logic mirrors NerdEgghead TBC_cat_sim / wowsims:
        --   shift when energy <= hard floor (10), OR
        --   when energy < threshold AND the next tick is more than 1s away.
        -- Threshold: 35 without Wolfshead (post-shift=40), 40 with Wolfshead (post-shift=60).
        if ui.checked("Powershifting") and cast.able.catForm() and unit.inCombat()
            and mana() >= var.formCost  -- mana gate: never shift when OOM
        then
            local threshold = var.shiftEnergyThreshold
            if energy() <= 10                                                                              -- hard floor: always shift regardless of OoC
                or (energy() < threshold and tickIn > 1.0 and not clearcasting)                            -- soft: hold shift to spend free OoC proc instead
            then
                local postShift = var.hasWolfshead and 60 or 40
                if cast.macro("/cast !"..spell.catForm.name(), spell.catForm.id()) then
                    ui.debug(string.format(
                        "Powershift for Energy (energy=%d, threshold=%d, tick in %.2fs, will have ~%d)",
                        energy(), threshold, tickIn, postShift
                    ))
                    return true
                end
            end
            -- energy < threshold but tickIn <= 1.0: wait for the tick, do nothing
        end

        -- Faerie Fire (Feral): applies the armor debuff (free, instant). Placed below
        -- the finishers and powershift so it never delays a ready Rip, but above the
        -- builders since the 40s raid-wide armor reduction outvalues a single Shred.
        -- The exists() checks already skip it when any druid's Faerie Fire is up (the
        -- only debuff it conflicts with; it stacks with Sunder/Expose/Curse of Recklessness).
        if ui.checked("Faerie Fire") and cast.able.faerieFireFeral(units.dyn5) and unit.valid(units.dyn5)
            and not buff.prowl.exists()
            and not debuff.faerieFireFeral.exists(units.dyn5, "any") and not debuff.faerieFire.exists(units.dyn5, "any")
            and not unit.isElemental(units.dyn5)
            and ttd > cd.global.remain()
        then
            if cast.faerieFireFeral(units.dyn5) then
                ui.debug("Casting Faerie Fire (Feral)")
                return true
            end
        end

        -- Combo Point Builders
        if (cp < 5 or clearcasting or energy() >= 40) and not finish then
            -- behindDyn5 hoisted to top of Builders block — used by Ravage, Mangle,
            -- Mangle Trick, and Shred. Previously declared twice (once as behindRavage
            -- for Ravage, once as behindDyn5 for the rest); the duplicate isBehind call
            -- was an incomplete hoist. See AUDIT.md L22 fold-in note.
            local behindDyn5 = isBehind(units.dyn5, "player")
            -- Ravage (from Prowl)
            if cast.able.ravage(units.dyn5) and buff.prowl.exists() and behindDyn5 then
                if cast.ravage(units.dyn5) then
                    ui.debug("Casting Ravage")
                    return true
                end
            end
            -- Mangle (maintain the +30% bleed debuff)
            -- Gate the entire block on not mangleBear: Bear Mangle (rank 4) > Cat Mangle (rank 1);
            -- applying Cat Mangle when Bear Mangle is active triggers "A more powerful spell is already active".
            -- This high-priority check only applies/refreshes the debuff. Pure filler
            -- Mangle (when we can't Shred) is handled below, *after* Rake, so Rake's
            -- bleed isn't starved when attacking from the front with the debuff already up.
            if cast.able.mangleCat(units.dyn5) and not mangleBearUp
                and (debuff.mangleCat.refresh(units.dyn5,"any")
                    or debuff.mangleCat.remain(units.dyn5,"any") <= tickIn)
            then
                if cast.mangleCat(units.dyn5) then
                    ui.debug("Casting Mangle [Debuff]")
                    return true
                end
            end
            -- Rake
            if ui.checked("Rake") and cast.able.rake(units.dyn5) and debuff.rake.refresh(units.dyn5)
                and (ttd > 9 or not spell.ferociousBite.known())
                and not clearcasting
            then
                if cast.rake(units.dyn5) then
                    ui.debug("Casting Rake")
                    return true
                end
            end
            -- Mangle Trick: at energy 60-61 with tick <=1s, cast Mangle instead of Shred to
            -- enable a double-Mangle cycle (Mangle → tick → Mangle) for higher combo point rate.
            if ui.checked("Mangle Trick") and cast.able.mangleCat(units.dyn5) and behindDyn5 and spell.shred.known()
                and not mangleBearUp then
                local mangleCost = (cast.cost.mangleCat and cast.cost.mangleCat()) or 40
                if energy() >= (2 * mangleCost - 20) and energy() < (22 + mangleCost) and tickIn <= 1.0 then
                    if cast.mangleCat(units.dyn5) then
                        ui.debug("Casting Mangle [Mangle Trick]")
                        return true
                    end
                end
            end
            -- Shred (from behind): use isBehind (strict back arc) to avoid wasting a GCD on
            -- a side-angle attempt that the server would deny. behindDyn5 is already computed above.
            if cast.able.shred(units.dyn5)
                and (debuff.mangleCat.exists(units.dyn5,"any") or mangleBearUp or not spell.mangleCat.known())
            then
                if behindDyn5 then
                    if cast.shred(units.dyn5) then
                        ui.debug("Casting Shred")
                        return true
                    end
                end
            end
            -- Mangle (filler): when we can't Shred (not behind, or Shred unknown) and the
            -- bleed debuff is already maintained above, Mangle is the best remaining builder
            -- ahead of Claw. Ordered after Rake/Shred so it never starves them.
            if cast.able.mangleCat(units.dyn5) and not mangleBearUp
                and (not behindDyn5 or not spell.shred.known())
            then
                if cast.mangleCat(units.dyn5) then
                    ui.debug("Casting Mangle [Filler]")
                    return true
                end
            end
            -- Claw (not behind)
            if cast.able.claw(units.dyn5) and (not spell.shred.known() or not behindDyn5) and not spell.mangleCat.known() then
                if cast.claw(units.dyn5) then
                    ui.debug("Casting Claw")
                    return true
                end
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
            -- Prowl — start every engage from stealth whenever we are able. Two triggers:
            --   * inAggroRange() — a hostile mob (incl. one our group pulled) is about to
            --     proximity-aggro us, so stealth before the pull.
            --   * our target — Prowl to open from stealth, timed by whether it can aggro us
            --     on approach. A HOSTILE target uses its level-scaled aggroRadius (via
            --     unit.distance("target"), which works past the 20y yards20nc scan), so we
            --     stealth just before crossing it. A NEUTRAL target won't aggro on approach,
            --     so we wait until ~8y (just before the <5y opener) instead of eating Prowl's
            --     move-speed penalty across the whole approach — and if a hostile threat is
            --     also present, inAggroRange() above prowls us early anyway.
            -- cast.able.prowl enforces known / off-cooldown / correct-form ("if we are able"),
            -- and this runs out of combat before the opener, so we never engage unstealthed
            -- when we could have stealthed first. unit.valid accepts neutral targets.
            if cast.able.prowl("player") and buff.catForm.exists() and ui.mode.prowl == 1
                and not buff.prowl.exists() and not unit.resting() and not unit.deadOrGhost("target")
                and (inAggroRange()
                    or (unit.valid("target")
                        and unit.distance("target") < (unit.enemy("target") and aggroRadius("target") or 8)))
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
            if var.formValue == 1 and not unit.moving()
                and not (buff.catForm.exists() or buff.bearForm.exists() or buff.direBearForm.exists()) and thisDistance < 30
            then
                if cast.able.wrath("target") and (unit.level() < 2 or not cast.last.wrath() or cast.timeSinceLast.wrath() > unit.gcd(true) + 0.5) then
                    if cast.wrath("target") then
                        ui.debug("Casting Wrath [Precombat]")
                        return true
                    end
                end
            end
            if thisDistance < 5 then
                -- Cat Opener (Stealth + Non-Stealth)
                if var.formValue == 2 then
                    if actionList.CatOpener() then return true end
                end
                -- Bear Form
                if var.formValue == 3 then
                    -- Bear Form
                    if ((cast.able.bearForm() and not spell.direBearForm.known()) or cast.able.direBearForm())
                        and not buff.bearForm.exists() and not buff.direBearForm.exists()
                        and not (buff.markOfTheWild.refresh() and ui.checked("Mark of the Wild"))
                        and not (buff.thorns.refresh() and ui.checked("Thorns"))
                    then
                        if spell.direBearForm.known() then
                            if cast.direBearForm() then
                                ui.debug("Casting Dire Bear Form")
                                return true
                            end
                        else
                            if cast.bearForm() then
                                ui.debug("Casting Bear Form")
                                return true
                            end
                        end
                    end
                    if (buff.bearForm.exists() or buff.direBearForm.exists()) then
                        -- Enrage
                        if cast.able.enrage() and not unit.deadOrGhost("target") and not buff.enrage.exists() and rage() < 10 then
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
                        if cast.able.maul("target") and (ui.useST(8,3) or not spell.swipe.known()) then
                            if cast.maul("target") then
                                ui.debug("Casting Maul [Precombat]")
                                return true
                            end
                        end
                    end
                end
                -- Auto Attack (do not break Prowl)
                if not buff.prowl.exists() and not cast.auto.autoAttack() and unit.valid("target") and not unit.deadOrGhost("target") and unit.distance("target") < 5 then
                    unit.startAttack()
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
        if not buff.prowl.exists() and unit.exists("target") and not cast.auto.autoAttack() and not unit.deadOrGhost("target") then
            unit.startAttack()
            ui.debug("Casting Auto Attack")
            return true
        end

        -- Call Action List - Cooldowns
        if actionList.Cooldowns() then return true end

        -- Call Action List - Interrupts
        if actionList.Interrupts() then return true end

        -- Wait for melee swing before spending energy on abilities in Cat/Bear form.
        -- Ensures the auto-attack isn't clipped by cast GCD, maximising physical DPS.
        if unit.exists("target") and unit.distance("target") < 5 and
            (var.formValue == 2 and buff.catForm.exists()
            or var.formValue == 3 and (buff.bearForm.exists() or buff.direBearForm.exists()))
        then
            local sw = br.player.swing and br.player.swing.mh
            local swing = sw and sw.timer or 0
            local waitThreshold = 0.20  -- 200ms window covers typical latency
            if swing > 0 and swing < waitThreshold then
                -- Arm a safety timeout so we never stall indefinitely
                if not sw.waiting then
                    sw.waiting     = true
                    sw.waitTimeout = br._G.GetTime() + 1.5
                end
                -- Release once the swing lands or the timeout expires
                if sw.timer == 0 or (sw.waitTimeout and br._G.GetTime() >= sw.waitTimeout) then
                    sw.waiting     = false
                    sw.waitTimeout = nil
                else
                    return true
                end
            end
        end

        -- Call Action List - Bear Form
        if var.formValue == 3 and (buff.bearForm.exists() or buff.direBearForm.exists()) and unit.exists("target") and unit.distance("target") < 5 then
            if actionList.BearForm() then return true end
        end

        -- Call Action List - Cat Form
        if var.formValue == 2 and units.dyn5 ~= nil and unit.distance(units.dyn5) < 5 then
            if buff.prowl.exists() then
                -- While prowled, only CatOpener runs; CatForm is never called.
                -- If CatOpener returns false (still repositioning), we yield and
                -- try again next tick rather than falling through to CatForm's Mangle.
                if actionList.CatOpener() then return true end
            else
                if actionList.CatForm() then return true end
            end
        end

        -- Call Action List - Caster Form
        if var.formValue == 1 and not (buff.catForm.exists() or buff.bearForm.exists() or buff.direBearForm.exists()) then
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
    has         = br.player.has
    cd          = br.player.cd
    comboPoints = br.player.power.comboPoints
    debuff      = br.player.debuff
    enemies     = br.player.enemies
    energy      = br.player.power.energy
    mana        = br.player.power.mana
    rage        = br.player.power.rage
    module      = br.player.module
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    spell       = br.player.spell
    -- General Locals
    var.profileStop = var.profileStop or false
    var.haltProfile = (unit.inCombat() and var.profileStop) or ui.pause() or ui.mode.rotation == 4 or unit.id("target") == 156716
    var.formValue = ui.mode.forms
    var.formCost = 0
    if not br.player.localTrinkets then br.player.localTrinkets = true end
    if ui.mode.forms == 2 then var.formCost = cast.cost.catForm() end
    if ui.mode.forms == 3 then var.formCost = spell.direBearForm.known() and cast.cost.direBearForm() or cast.cost.bearForm() end
    -- Wolfshead Helm (item 8345) detection: shifts grant +60 energy instead of +40, raising the optimal shift threshold.
    var.hasWolfshead = (br._G.GetInventoryItemID and br._G.GetInventoryItemID("player", 1) == 8345)
    -- Derive the effective powershift threshold.
    -- Default 35 covers the gap between post-Rip/post-Bite energy (~25) and the min builder cost (Rake=35, Mangle=40).
    -- With Wolfshead (post-shift=60 vs no-Wolfshead post-shift=40), the break-even threshold rises to 40.
    -- Auto-raise to 40 for Wolfshead unless the player has explicitly set a higher value (respects overrides >= 40).
    var.shiftEnergyThreshold = ui.value("Energy")
    if var.hasWolfshead and var.shiftEnergyThreshold < 40 then
        var.shiftEnergyThreshold = 40
    end
    -- Units
    units.get(5)        -- Makes a variable called, "target"
    units.get(40, true) -- Makes a variable called, units.dyn40AOE
    -- Enemies
    enemies.get(5, "player", false, true) -- Makes a variable called, enemies.yards5f
    enemies.get(8)      -- Makes a variable called, enemies.yards8 (BearForm Swipe AoE threshold)
    enemies.get(10)     -- Makes a variable called, enemies.yards10 (BearForm/Defensive checks)
    enemies.get(20, "player", true)        -- makes enemies.yards20nc (inAggroRange)

    if not unit.inCombat() and not unit.exists("target") then
        if var.profileStop then var.profileStop = false end
    end

    -- ui.chatOverlay("Shift At: "..tostring(ui.round(math.max(10, ui.value("Energy")*(mana.percent()/100)),0)))

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
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extra() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        -----------------------
        --- Form Management ---
        -----------------------
        if actionList.FormManagement() then return true end
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
    expansion = "TBC",
    author    = "CuteOne",
    patch     = "2.5.5",
    coverage  = "100%",
    status    = "Full",
    readiness = "Untested",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})
