-- Editor types: the keys of TBC Druid's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.TBC.Druid.buff]]
local cast = cast --[[@as BR.TBC.Druid.cast]]
local cd = cd --[[@as BR.TBC.Druid.cd]]
local debuff = debuff --[[@as BR.TBC.Druid.debuff]]
local equiped = equiped --[[@as BR.TBC.Druid.equiped]]
local spell = spell --[[@as BR.TBC.Druid.spell]]

local rotationName = "CuteOne" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "swipe", overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range." },
        { name = "Multi", icon = "swipe", overlay = "Multiple Target Rotation", tip = "Forces Multiple Target Rotation." },
        { name = "Single", icon = "shred", overlay = "Single Target Rotation", tip = "Forces Single Target Rotation." },
        { name = "Off", icon = "healingTouch", overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation" },
    } })
    ui.toggle("Cooldown", { key = "RightCtrl", modes = {
        { name = "Auto", icon = "tigersFury", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On", icon = "tigersFury", overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target." },
        { name = "Off", icon = "tigersFury", overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used." },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "healingTouch", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "healingTouch", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "bash", overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts." },
        { name = "Off", icon = "bash", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
    } })
    ui.toggle("Forms", { modes = {
        { name = "Caster", icon = "moonkinForm", overlay = "Caster Form", tip = "Will force and use Caster Form" },
        { name = "Cat", icon = "catForm", overlay = "Cat Form", tip = "Will force and use Cat Form" },
        { name = "Bear", icon = "bearForm", overlay = "Bear Form", tip = "Will force and use Bear Form" },
    } })
    ui.toggle("Prowl", { modes = {
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
    section = ui.section("General")
    ui.spinner(section, "Shift Wait Time", { value = 2, max = 5, step = 1, checkbox = false,
        tip = "Time in seconds the profile will wait while moving to shift. Combat is instant!" })
    -- Powershifting
    ui.checkbox(section, "Powershifting", { tip = "Feral DPS In-Form Shifting for Energy" })
    -- Cower
    ui.checkbox(section, "Cower", { tip = "Use Cower (20 energy) to drop threat when being attacked while a tank is alive and nearby" })
    -- Mangle Trick
    ui.checkbox(section, "Mangle Trick", { tip = "At energy 60-61 with tick <1s away, cast Mangle instead of Shred to enable a double-Mangle combo-point cycle (advanced, Wolfshead recommended)." })
    -- Rake/Bite Tricks
    ui.checkbox(section, "Rake/Bite Tricks", { tip = "With Wolfshead at 35-39 energy and tick >1s away, cast Rake (no debuff) or Ferocious Bite (2+ CPs) instead of powershifting (advanced)." })
    -- Biteweave
    ui.checkbox(section, "Biteweave", { checked = true, tip = "While Rip is up, spend finisher combo points on Ferocious Bite instead of building past them (wowsims default). Shred still comes first when energy is high." })
    -- Finisher Combo Points
    ui.spinner(section, "Finisher Combo Points", { value = 5, min = 1, max = 5, step = 1, checkbox = false,
        tip = "Combo points for Rip and Ferocious Bite (wowsims: 4 in its full rotation, 5 in its simple one)" })
    --------------------------
    --- FORM MANAGEMENT ---
    --------------------------
    section = ui.section("Form Management")
    -- Aquatic Form
    ui.checkbox(section, "Aquatic Form", { tip = "Enable/Disable Using Aquatic Form" })
    -- Travel Form
    ui.checkbox(section, "Travel Form", { tip = "Enable/Disable Using Travel Form" })
    -- Last Form
    ui.checkbox(section, "Last Form", { tip = "Enable/Disable Returning to Last Form" })
    -- Energy Threshold
    ui.spinner(section, "Energy", { value = 35, min = 1, step = 1,
        tip = "Shift when energy drops below this. 35 = no Wolfshead (auto); 40 = Wolfshead Helm (auto-detected and raised). Covers the gap between post-ability energy and the cost of the next builder." })
    -- Rage Threshold
    ui.spinner(section, "Rage", { value = 10, min = 1, step = 1, tip = "Bear Form Rage Threshold to Break Form" })
    ----------------------
    --- BLEED OPTIONS ---
    ----------------------
    section = ui.section("Bleeds")
    -- Rake
    ui.checkbox(section, "Rake", { tip = "Enable/Disable Using Rake" })
    -- Rip
    ui.checkbox(section, "Rip", { tip = "Enable/Disable Using Rip" })
    ---------------------
    --- BUFF OPTIONS ---
    ---------------------
    section = ui.section("Buffs")
    -- Self-Innervate
    ui.checkbox(section, "Self-Innervate", { tip = "Enable/Disable Using Innervate on Self" })
    -- Mark of the Wild
    ui.dropdown(section, "Mark of the Wild", { choices = { "Player", "Target", "Mouseover", "Focus", "Group" }, value = "Player",
        tip = "Set how to use Mark of the Wild" })
    -- Gift of the Wild
    ui.checkbox(section, "Gift of the Wild", { checked = true,
        tip = "Buff a party with Gift of the Wild (uses a reagent) while in a group; unticked, Mark of the Wild is cast one by one instead" })
    -- Omen of Clarity
    ui.dropdown(section, "Omen of Clarity", { choices = { "Any", "Focus DPS", "Focus Healing", "None" }, value = "Any",
        tip = "Select how to use Omen of Clarity procs" })
    -- Thorns
    ui.dropdown(section, "Thorns", { choices = { "Player", "Target", "Mouseover", "Focus", "Group" }, value = "Player",
        tip = "Set how to use Thorns" })
    -- Tiger's Fury
    ui.checkbox(section, "Tiger's Fury", { tip = "Enable/Disable Using Tiger's Fury" })
    -----------------
    --- BEAR FORM ---
    -----------------
    section = ui.section("Bear Form")
    ui.checkbox(section, "Bear Opener", { tip = "Open a Bear Form pull with Enrage, Demoralizing Roar, then Maul, in that order" })
    ui.checkbox(section, "Feral Charge - Engage", { checked = true, tip = "Charge your target from 8-25 yards in Bear Form" })
    ui.checkbox(section, "Growl", { tip = "In a group, taunt an enemy in melee range that is attacking someone else" })
    ui.spinner(section, "Challenging Roar", { value = 3, min = 2, max = 10, step = 1,
        tip = "In a group, Challenging Roar when at least this many enemies within 10 yards are attacking others" })
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    -- Self-Heal In Group
    ui.checkbox(section, "Self Heal In Group", { tip = "Enable/Disable Healing Self while Grouped" })
    -- Healing Touch
    ui.spinner(section, "Healing Touch", { value = 40, tip = "Health Percent to Cast At" })
    -- Regrowth
    ui.spinner(section, "Regrowth", { value = 60, tip = "Health Percent to Cast At" })
    -- Rejuvenation
    ui.spinner(section, "Rejuvenation", { value = 80, tip = "Health Percent to Cast At" })
    -- Barkskin
    ui.spinner(section, "Barkskin", { value = 50, tip = "Health Percent to Cast At" })
    -- Frenzied Regeneration
    ui.spinner(section, "Frenzied Regeneration", { value = 45, checked = true, tip = "Health Percent to Cast At (Bear Form)" })
    -- Abolish Poison
    ui.checkbox(section, "Abolish Poison", { tip = "Enable/Disable Using Abolish Poison" })
    -- Cure Poison
    ui.checkbox(section, "Cure Poison", { tip = "Enable/Disable Using Cure Poison" })
    -- Remove Curse
    ui.checkbox(section, "Remove Curse", { tip = "Enable/Disable Using Remove Curse" })
    -- Entangling Roots
    ui.checkbox(section, "Entangling Roots", { tip = "Enable/Disable Using Entangling Roots on fleeing enemies" })
    -- Faerie Fire
    ui.checkbox(section, "Faerie Fire", { tip = "Enable/Disable Using Faerie Fire/Faerie Fire Feral" })
    -- Nature's Grasp
    ui.checkbox(section, "Nature's Grasp", { tip = "Enable/Disable Using Nature's Grasp" })
    -- -- Health Potion
    -- br.ui:createCheckbox(section, "Health Potion", "|cffFFFFFFEnable/Disable Using Health Potion")
    -- -- Mana Potion
    -- br.ui:createCheckbox(section, "Mana Potion", "|cffFFFFFFEnable/Disable Using Mana Potion")
    -- Bash
    ui.spinner(section, "Bash", { value = 50, tip = "Health Percent to Cast At" })
    -------------------------
    --- Interrupt Options ---
    -------------------------
    section = ui.section("Interrupts")
    -- Feral Charge
    ui.checkbox(section, "Feral Charge - Int", { checked = true, tip = "Interrupt with Feral Charge (Bear) from 8-25 yards" })
    -- Bash
    ui.checkbox(section, "Bash - Int")
    -- Maim
    ui.checkbox(section, "Maim")
    -- Interrupt Percentage
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percent to Cast At (0 is random)" })
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local comboPoints
local energy
local rage
local mana
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
    local current = power.energy() or 0
    local energyJump = current - var.lastEnergyObserved
    if energyJump >= 15 and energyJump <= 25 then
        var.lastEnergyTickTime = util.time()
    end
    var.lastEnergyObserved = current
    if var.lastEnergyTickTime == 0 then return 2.0 end
    return math.max(0, (var.lastEnergyTickTime + 2.0) - util.time())
end


-- Leaving Cat or Bear Form for a caster spell. In combat Cat Form is never left: powershifting is
-- the only form change worth its energy there. Otherwise unit.cancelFormFor leaves the form only
-- with the mana to shift back, and keeps that mana until a form is up again.
local function leaveFormFor(spellRef, free)
    if buff.catForm.exists() and unit.inCombat() then return false end
    return unit.cancelFormFor(spellRef, free)
end

-- True when a party/raid member (not us) is in combat and currently targeting thisUnit —
-- i.e. our group has already engaged it. Lets us pre-emptively Prowl to open from stealth
-- on a mob the group pulled (even while it's in combat). Solo players short-circuit.
local function engagedByGroup(thisUnit)
    local n = unit.groupCount()
    if n <= 1 then return false end
    local inRaid = unit.inRaid()
    local prefix = inRaid and "raid" or "party"
    -- Raid tokens are raid1..raidN (include us, filtered out below); party tokens are
    -- party1..party(N-1) with the player addressed separately as "player".
    local last = inRaid and n or (n - 1)
    for i = 1, last do
        local member = prefix .. i
        if not unit.isUnit(member, "player")
            and unit.inCombat(member)
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
            local freshHostile = unit.enemy(thisUnit) and not unit.inCombat(thisUnit)
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
        and unit.swimming()
        and buff.aquaticForm.exists()
        and not inAggroRange()
        and (not unit.exists("target") or unit.friend("target"))
end

--------------------
--- Action Lists ---
--------------------

-- Action List - Extra
actionList.Extra = function()
    -- Gift of the Wild (each rank needs its reagent, which cast.able checks). It buffs the target's
    -- party only, so it goes on a member who needs it: cast on the player, raid members in other
    -- parties never got it and it was cast again and again (2026-10-26, a raid)
    if ui.checked("Mark of the Wild") and not unit.flying() and not buff.prowl.exists() then
        local inGroup = unit.inGroup()
        if inGroup and ui.checked("Gift of the Wild") and spell.giftOfTheWild.known() and mana() > cast.cost.giftOfTheWild() + var.formCost then
            -- Someone who needs the buff and can be given it now
            local giftUnit
            for i = 1, #units.friends do
                local u = units.friends[i].unit
                if buff.markOfTheWild.refresh(u) and not buff.giftOfTheWild.exists(u, "") and not unit.deadOrGhost(u)
                    and unit.distance(u) < 40 and cast.able.giftOfTheWild(u)
                then
                    giftUnit = u
                    break
                end
            end
            if giftUnit then
                -- Cancel form if needed to buff
                local needsCancel = buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.aquaticForm.exists()
                if needsCancel then
                    if leaveFormFor(spell.giftOfTheWild) then
                        return true
                    end
                else
                    if cast.giftOfTheWild(giftUnit) then
                        ui.debug("Casting Gift of the Wild")
                        return true
                    end
                end
            end
        end
        -- Fallback to Mark of the Wild (single buff or no reagent)
        if mana() > cast.cost.markOfTheWild() + var.formCost then
            var.markUnit = units.buffUnit("Mark of the Wild", needsMarkOfTheWild, 40)
            if cast.able.markOfTheWild(var.markUnit) and buff.markOfTheWild.refresh(var.markUnit)
                and not unit.inCombat() and not unit.resting() and unit.distance(var.markUnit) < 40
                and (var.markUnit == "player" or unit.player(var.markUnit)) and unit.friend(var.markUnit)
                and not buff.giftOfTheWild.exists(var.markUnit, "")
            then
                -- Cancel form if needed to buff
                local needsCancel = buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.aquaticForm.exists()
                if needsCancel then
                    if leaveFormFor(spell.markOfTheWild) then
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
        var.thornUnit = units.buffUnit("Thorns", needsThorns, 40)
        if cast.able.thorns(var.thornUnit) and buff.thorns.refresh(var.thornUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.thornUnit) < 40
            and (var.thornUnit == "player" or unit.player(var.thornUnit))
        then
            -- Cancel form if needed to buff
            local needsCancel = buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.aquaticForm.exists()
            if needsCancel then
                if leaveFormFor(spell.thorns) then
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
                if leaveFormFor(spell.omenOfClarity) then
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
                if leaveFormFor(spell.abolishPoison) then
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
                if leaveFormFor(spell.curePoison) then
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
                if leaveFormFor(spell.removeCurse) then
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
        -- Frenzied Regeneration (spends Rage, so only with some to spend)
        if ui.checked("Frenzied Regeneration") and (buff.bearForm.exists() or buff.direBearForm.exists())
            and cast.able.frenziedRegeneration() and unit.hp() <= ui.value("Frenzied Regeneration") and rage() >= 10
        then
            if cast.frenziedRegeneration() then
                ui.debug("Casting Frenzied Regeneration")
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
                if leaveFormFor(spell.entanglingRoots, buff.clearcasting.exists()) then
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
                if leaveFormFor(spell.naturesGrasp, buff.clearcasting.exists()) then
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
                if leaveFormFor(spell.regrowth, buff.clearcasting.exists()) then
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
                    if leaveFormFor(spell.rejuvenation, buff.clearcasting.exists()) then
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
                    if leaveFormFor(spell.rejuvenation, buff.clearcasting.exists()) then
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
                    if leaveFormFor(spell.healingTouch, buff.clearcasting.exists()) then
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
                    if leaveFormFor(spell.healingTouch, buff.clearcasting.exists()) then
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
        --         unit.cancelForm()
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
        --         unit.cancelForm()
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
    if not (ui.useInterrupt() and util.timer("Interrupts", unit.gcd(true))) then return false end
    local interruptAt = ui.value("Interrupt At")
    local isBearForm  = buff.bearForm.exists() or buff.direBearForm.exists()
    -- Feral Charge (Bear): a caster 8-25 yards away
    if ui.checked("Feral Charge - Int") and isBearForm and cast.able.feralCharge() then
        enemies.get(25)
        local thisUnit = enemies.first(enemies.yards25, function(thisUnit)
            return unit.distance(thisUnit) >= 8 and unit.interruptable(thisUnit, interruptAt)
                and cast.able.feralCharge(thisUnit)
        end)
        if thisUnit and cast.feralCharge(thisUnit) then
            ui.debug("Casting Feral Charge on " .. unit.name(thisUnit))
            return true
        end
    end
    -- Bash (Bear) or Maim (Cat) in melee
    local bashEnabled = ui.checked("Bash - Int") and isBearForm
    local maimEnabled = ui.checked("Maim") and buff.catForm.exists() and comboPoints() > 0 and energy() >= 35
    if not bashEnabled and not maimEnabled then return false end
    for i = 1, #enemies.yards5f do
        local thisUnit = enemies.yards5f[i]
        if unit.interruptable(thisUnit, interruptAt) then
            if bashEnabled and cast.able.bash(thisUnit) then
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
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if not buff.prowl.exists() and unit.distance("target") < 5 then
        -- * Module- Basic Trinkets
        -- use_items
        module.BasicTrinkets()
        -- Innervate (caster form only, so it leaves Bear Form for it; never Cat Form in combat)
        if ui.checked("Self-Innervate") and ui.useCDs() and mana.percent() < 30
            and cd.innervate.remain() == 0 and spell.innervate.known()
        then
            if buff.catForm.exists() or buff.bearForm.exists() or buff.direBearForm.exists() then
                if leaveFormFor(spell.innervate) then
                    return true
                end
            elseif cast.able.innervate("player") and cast.innervate("player") then
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
        and unit.swimming() and not buff.aquaticForm.exists() and not buff.prowl.exists()
        and unit.moving() and unit.movingTime() > 2 and not inAggroRange()
    then
        if buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() then
            if leaveFormFor(spell.aquaticForm) then
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
        and unit.moving() and unit.movingTime() > 2 and not inAggroRange()
    then
        if buff.catForm.exists() or buff.bearForm.exists() then
            if leaveFormFor(spell.travelForm) then
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
        if var.formValue == 2
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
            if unit.cancelForm() then
                ui.debug("Casting Caster Form")
                return true
            end
        end
    end
end -- End Action List - Form Management

-- Action List - Bear Opener
actionList.BearOpener = function()
    if not (buff.bearForm.exists() or buff.direBearForm.exists()) then return false end
    if not unit.valid("target") or unit.deadOrGhost("target") or unit.distance("target") >= 5 then return false end
    -- Enrage
    if not buff.enrage.exists() and rage() < 10 then
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

-- Rage Maul leaves for the abilities due before its swing lands: Mangle when it is (nearly) off
-- cooldown, Lacerate while it's wanted, Swipe in AoE. Only known spells count, so at low levels
-- (no Mangle or Lacerate yet) Maul is the rage dump as soon as it is affordable.
local function maulReserve(thisUnit)
    local reserve = 0
    if spell.mangleBear.known() and cd.mangleBear.remain() < unit.gcd(true) then
        reserve = reserve + cast.cost.mangleBear()
    end
    if spell.lacerate.known() and unit.ttd(thisUnit) > 6 then
        reserve = reserve + cast.cost.lacerate()
    end
    if spell.swipe.known() and ui.useAOE(8, 3) then
        reserve = reserve + cast.cost.swipe()
    end
    return reserve
end

-- Action List - Bear Form
-- Order follows wowsims' TBC bear rotation; spells not learned yet are skipped by cast.able.
actionList.BearForm = function()
    local thisUnit = units.dyn5
    -- Growl: an enemy in melee range attacking someone else
    if ui.checked("Growl") and unit.inGroup() and cast.able.growl() then
        enemies.get(5)
        local tauntUnit = enemies.first(enemies.yards5, unit.attackingOthers)
        if tauntUnit and cast.growl(tauntUnit) then
            ui.debug("Casting Growl on " .. unit.name(tauntUnit))
            return true
        end
    end
    -- Challenging Roar: several enemies around you attacking others
    if ui.checked("Challenging Roar") and unit.inGroup() and cast.able.challengingRoar()
        and enemies.count(enemies.yards10, unit.attackingOthers) >= ui.value("Challenging Roar")
    then
        if cast.challengingRoar() then
            ui.debug("Casting Challenging Roar")
            return true
        end
    end
    -- Enrage: Rage when starved (costs armor, so not at low health)
    if cast.able.enrage() and not buff.enrage.exists() and rage() < 10 and unit.hp() > 80 then
        if cast.enrage() then
            ui.debug("Casting Enrage")
            return true
        end
    end
    if thisUnit == nil then return false end
    local lacerateStacks = debuff.lacerate.stack(thisUnit)
    -- Lacerate: keep a full stack from falling off (it restarts at 1 stack once it drops)
    if cast.able.lacerate(thisUnit) and lacerateStacks == 5 and debuff.lacerate.remain(thisUnit) <= 1.5 then
        if cast.lacerate(thisUnit) then
            ui.debug("Casting Lacerate [Keep Stack]")
            return true
        end
    end
    -- Faerie Fire (Feral): free armor debuff; anyone's Faerie Fire counts
    if ui.checked("Faerie Fire") and cast.able.faerieFireFeral(thisUnit)
        and not debuff.faerieFireFeral.exists(thisUnit, "any") and not debuff.faerieFire.exists(thisUnit, "any")
        and not unit.isElemental(thisUnit) and unit.ttd(thisUnit) > cd.global.remain()
    then
        if cast.faerieFireFeral(thisUnit) then
            ui.debug("Casting Faerie Fire (Feral)")
            return true
        end
    end
    -- Demoralizing Roar: an AoE around the player (10 yards), when any enemy in reach needs it, not
    -- just the target. As an "aoe" cast it won't go off while a mob that isn't fighting us is in reach.
    if cast.able.demoralizingRoar("player", "aoe", 1, 10) and debuff.demoralizingRoar.refreshCount(10) > 0 then
        if cast.demoralizingRoar("player", "aoe", 1, 10) then
            ui.debug("Casting Demoralizing Roar")
            return true
        end
    end
    -- Mangle (Bear) on cooldown: damage, threat and the +30% bleed debuff
    if cast.able.mangleBear(thisUnit) then
        if cast.mangleBear(thisUnit) then
            ui.debug("Casting Mangle")
            return true
        end
    end
    -- Swipe (hits 3)
    if cast.able.swipe() and ui.useAOE(8, 3) then
        if cast.swipe() then
            ui.debug("Casting Swipe")
            return true
        end
    end
    -- Lacerate: build to 5 stacks, then it's the filler (a target dying soon isn't worth stacking)
    if cast.able.lacerate(thisUnit) and (lacerateStacks < 5 and unit.ttd(thisUnit) > 6 or lacerateStacks == 5) then
        if cast.lacerate(thisUnit) then
            ui.debug("Casting Lacerate")
            return true
        end
    end
    -- Maul (next swing): with the rage the abilities above still need left over
    if cast.able.maul(thisUnit) and rage() >= cast.cost.maul() + maulReserve(thisUnit)
        and (ui.useST(8, 3) or not spell.swipe.known() or rage() >= 40)
    then
        if cast.maul(thisUnit) then
            ui.debug("Casting Maul")
            return true
        end
    end
end -- End Action List - Bear Form

-- Ravage from Prowl is worth waiting for only while it can still happen: Ravage known, the target not
-- attacking you (it faces you on the server, so you can't get behind it), the energy there or one tick
-- away, and for at most RAVAGE_WAIT sec since reaching melee range (time to step behind it). Standing
-- still in front of it for over a second means opening from there. Then the opener falls back.
local RAVAGE_WAIT = 3
local function waitForRavage(behind)
    if not spell.ravage.known() or unit.isUnit("targettarget", "player") then return false end
    local cost = cast.cost.ravage()
    if energy() < cost and (energy() + 20 < cost or timeToNextEnergyTick() > 1) then return false end
    local guid = unit.guid("target")
    if var.ravageWait == nil or var.ravageWait.guid ~= guid then
        var.ravageWait = { guid = guid, since = util.time() }
    end
    if util.time() - var.ravageWait.since > RAVAGE_WAIT then return false end
    return behind or unit.standingTime() <= 1
end

-- Action List - Cat Opener (Stealth + Non-Stealth)
actionList.CatOpener = function()
    if not buff.catForm.exists() then return false end
    if not unit.valid("target") or unit.deadOrGhost("target") or unit.distance("target") >= 5 then
        var.ravageWait = nil -- the wait starts again on reaching melee range
        return false
    end
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
    local behindTarget = unit.isBehind("target", "player")
    local mangleDebuffUp = debuff.mangleCat.exists("target","any") or debuff.mangleBear.exists("target","any")

    -- Stealth Opener
    if isStealth then
        -- Ravage: the best stealth attack, from behind
        if behindTarget and cast.able.ravage("target") then
            if cast.ravage("target") then
                ui.debug("Casting Ravage [Stealth Opener]")
                return true
            end
        end
        -- Hold for Ravage while it can still happen (refused for range or facing, energy a tick away,
        -- stepping behind)
        if waitForRavage(behindTarget) then return false end
        -- Otherwise open with the best other attack: Shred from behind (Mangle's debuff up, or no Mangle),
        -- else Mangle, else Claw
        if behindTarget and cast.able.shred("target") and (mangleDebuffUp or not spell.mangleCat.known()) then
            if cast.shred("target") then
                ui.debug("Casting Shred [Stealth Opener]")
                return true
            end
        end
        if cast.able.mangleCat("target") then
            if cast.mangleCat("target") then
                ui.debug("Casting Mangle [Stealth Opener]")
                return true
            end
        end
        if cast.able.claw("target") and not spell.mangleCat.known() then
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
        local finisherCP   = ui.value("Finisher Combo Points")
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
        -- Tiger's Fury (option, off by default): 30 energy for +40 damage per hit for 6 sec at max rank
        -- (not an energy return; that's WotLK). TBC gives it no real cooldown, so it goes out whenever
        -- the buff is down at <= 35 energy; wowsims never uses it. Not on Clearcasting: the free proc
        -- goes to an attack.
        if ui.checked("Tiger's Fury") and cast.able.tigersFury() and buff.catForm.exists()
            and not buff.tigersFury.exists() and energy() <= 35 and not clearcasting
        then
            if cast.tigersFury() then
                ui.debug("Casting Tiger's Fury")
                return true
            end
        end

        -- Pre-compute flags reused by multiple checks below.
        local finish    = spell.ferociousBite.kills(units.dyn5)
        -- biteAtEnd: the target dies before most of Rip would tick (wowsims: under 10 sec left) —
        -- skip Rip, use FB instead. No energy cap: a dying target gets excess energy as FB damage.
        local biteAtEnd = cp >= finisherCP and ttd < 10
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

        -- Finishers (at the "Finisher Combo Points" option, default 5)
        if cp >= finisherCP and not clearcasting and not finish then
            -- biteAtEnd: target dying (<10s TTD) — skip Rip (ticks won't complete) and dump
            -- excess energy into FB bonus damage. No energy cap on this path.
            if biteAtEnd and cast.able.ferociousBite(units.dyn5) and energy() >= 35 then
                if cast.ferociousBite(units.dyn5) then
                    ui.debug("Casting Ferocious Bite [Fight End]")
                    return true
                end
            end
            -- Rip: only once it has dropped off. TBC has no Pandemic: re-casting restarts Rip and the
            -- ticks left on the old one are lost (its last tick lands as it expires). Needs the target
            -- to live 10 sec (wowsims) and energy >= 30.
            if ui.checked("Rip") and cast.able.rip(units.dyn5) and ttd >= 10
                and not debuff.rip.exists(units.dyn5)
                and not biteAtEnd and energy() >= 30
            then
                if cast.rip(units.dyn5) then
                    ui.debug("Casting Rip")
                    return true
                end
            end
            -- Ferocious Bite (Rip not learned, or the target dying within 10 sec). With Rip running,
            -- Biteweave below handles Bite.
            if cast.able.ferociousBite(units.dyn5) and energy() >= 35 and energy() < 40
                and (not spell.rip.known() or ttd < 10)
            then
                if cast.ferociousBite(units.dyn5) then
                    ui.debug("Casting Ferocious Bite")
                    return true
                end
            end
        end

        -- Biteweave (wowsims default): while Rip is up, spend the finisher combo points on Ferocious
        -- Bite at 35-56 energy instead of building past them.
        -- At energy >= 57+cutoffMod (cutoffMod=20 when tick >1s), Shred comes first (wowsims);
        -- fall through to the builder block which handles it naturally.
        if ui.checked("Biteweave") and debuff.rip.exists(units.dyn5) and cp >= finisherCP
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
        -- Neither on Clearcasting: the free proc goes to Shred (wowsims).
        if ui.checked("Rake/Bite Tricks") and tickIn > 1.0 and energy() >= 35 and energy() <= 39 and not clearcasting then
            -- Rake Trick: apply Rake if the debuff is missing (35 energy)
            if ui.checked("Rake") and cast.able.rake(units.dyn5) and not debuff.rake.exists(units.dyn5) then
                if cast.rake(units.dyn5) then
                    ui.debug("Casting Rake [Rake Trick]")
                    return true
                end
            end
            -- Bite Trick: Ferocious Bite at 2+ CPs instead of shifting
            if cast.able.ferociousBite(units.dyn5) and cp >= 2 then
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
            local behindDyn5 = unit.isBehind(units.dyn5, "player")
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
            -- Rake as a builder: from the front, or while Shred is expensive. wowsims (max level,
            -- Shredding Attacks talented: Shred 42 energy) uses Rake only as the trick above, since
            -- Shred from behind is worth more. While leveling, Shred costs up to 60 and Rake's combo
            -- point for 35-40 energy keeps the finishers coming, so Rake stays in.
            if ui.checked("Rake") and cast.able.rake(units.dyn5) and debuff.rake.refresh(units.dyn5)
                and (ttd > 9 or not spell.ferociousBite.known())
                and not clearcasting
                and (not behindDyn5 or not spell.shred.known() or cast.cost.shred() > 45)
            then
                if cast.rake(units.dyn5) then
                    ui.debug("Casting Rake")
                    return true
                end
            end
            -- Mangle Trick: at energy 60-61 with tick <=1s, cast Mangle instead of Shred to
            -- enable a double-Mangle cycle (Mangle → tick → Mangle) for higher combo point rate.
            if ui.checked("Mangle Trick") and cast.able.mangleCat(units.dyn5) and behindDyn5 and spell.shred.known()
                and not mangleBearUp and not clearcasting then
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
    if cast.able.starfire() and not unit.moving() and unit.level() >= 20
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
            -- Feral Charge (Bear) to engage
            if ui.checked("Feral Charge - Engage") and (buff.bearForm.exists() or buff.direBearForm.exists())
                and thisDistance >= 8 and thisDistance < 25 and cast.able.feralCharge("target")
            then
                if cast.feralCharge("target") then
                    ui.debug("Casting Feral Charge [Precombat]")
                    return true
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
                    -- Bear Opener
                    if ui.checked("Bear Opener") and actionList.BearOpener() then return true end
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

        -- Feral Charge (Bear) to engage
        if ui.checked("Feral Charge - Engage") and (buff.bearForm.exists() or buff.direBearForm.exists())
            and unit.distance("target") >= 8 and unit.distance("target") < 25 and cast.able.feralCharge("target")
        then
            if cast.feralCharge("target") then
                ui.debug("Casting Feral Charge")
                return true
            end
        end

        -- Call Action List - Bear Form
        if var.formValue == 3 and (buff.bearForm.exists() or buff.direBearForm.exists()) and unit.exists("target") and unit.distance("target") < 5 then
            if ui.checked("Bear Opener") and actionList.BearOpener() then return true end
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
    comboPoints = power.comboPoints
    energy      = power.energy
    mana        = power.mana
    rage        = power.rage
    -- General Locals
    var.profileStop = var.profileStop or false
    var.haltProfile = (unit.inCombat() and var.profileStop) or ui.pause() or ui.mode.rotation == 4
    var.formValue = ui.mode.forms
    var.formCost = 0
    if ui.mode.forms == 2 then var.formCost = cast.cost.catForm() end
    if ui.mode.forms == 3 then var.formCost = spell.direBearForm.known() and cast.cost.direBearForm() or cast.cost.bearForm() end
    -- Wolfshead Helm (item 8345) detection: shifts grant +60 energy instead of +40, raising the optimal shift threshold.
    var.hasWolfshead = equiped.item(8345, 1) -- Wolfshead Helm
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

    -- ui.chatOverlay("Shift At: "..tostring(util.round(math.max(10, ui.value("Energy")*(mana.percent()/100)),0)))

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
registerRotation({
    handlesTrinkets = true,
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
