-- WoW Forever Druid: Cat Form is the main rotation; Bear and Caster/Moonkin are complete but simpler.
-- Forever changes that shape the logic (Wowhead Forever data, 2026-10-11):
--   * Rend and Tear: +20% melee damage on bleeding targets, so a bleed (Rake, Rip, Pounce, Lacerate) stays up.
--   * Tiger's Fury: +15% Physical damage for 6 sec on a 30 sec cooldown, costs nothing.
--   * Omen of Clarity is trained; Clearcasting isn't spent by Wrath, so it goes to Shred/Claw or Starfire.
--   * Berserk: crits on combo point builders, and Primal Bite hits 3 targets with no cooldown.
--   * Eclipse: each Wrath makes the next Starfires faster (beta: 0.5 sec per stack; the live tooltip, 2026-11-05,
--     says the next 2 Starfires 0.03 sec, up to 4 charges, 3 talent ranks: unconfirmed in game; the Starfire timing
--     reads the game's cast time).
--   * Shifting Power: 55% of base mana on an 8 sec cooldown (live build; 16 sec in the beta).
--   * Hurricane has no cooldown; Nature's Grasp and Shifting Power work while shapeshifted.

---------------
--- Toggles ---
---------------
-- ui.toggle(name, { modes = { ... }, key = ... }) adds a button to the toggle bar.
-- Each mode is { name = ..., icon = ..., overlay = ..., tip = ... }; clicking cycles them and the first
-- is the default. Every field is listed in System/UI/Toggles/ToggleFunctions.lua.
-- Editor types: the keys of Forever Druid's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.Forever.Druid.buff]]
local cast = cast --[[@as BR.Forever.Druid.cast]]
local cd = cd --[[@as BR.Forever.Druid.cd]]
local debuff = debuff --[[@as BR.Forever.Druid.debuff]]
local spell = spell --[[@as BR.Forever.Druid.spell]]

local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto",   icon = "swipe",        overlay = "Automatic Rotation",       tip = "Swaps between Single and Multiple based on number of enemies within 8 yards." },
        { name = "Multi",  icon = "swipe",        overlay = "Multiple Target Rotation", tip = "Forces Multiple Target Rotation." },
        { name = "Single", icon = "claw",         overlay = "Single Target Rotation",   tip = "Forces Single Target Rotation." },
        { name = "Off",    icon = "healingTouch", overlay = "DPS Rotation Disabled",    tip = "Disable DPS Rotation" },
    } })
    ui.toggle("Cooldown", { key = "RightCtrl", modes = {
        { name = "Auto", icon = "berserk", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On",   icon = "berserk", overlay = "Cooldowns Enabled",   tip = "Cooldowns used regardless of target." },
        { name = "Off",  icon = "berserk", overlay = "Cooldowns Disabled",  tip = "No Cooldowns will be used." },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On",  icon = "healingTouch", overlay = "Defensive Enabled",  tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "healingTouch", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On",  icon = "bash", overlay = "Interrupts Enabled",  tip = "Includes Basic Interrupts." },
        { name = "Off", icon = "bash", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
    } })
    ui.toggle("Forms", { modes = {
        { name = "Auto",   icon = "catForm",  overlay = "Automatic Form", tip = "Bear when your group role is Tank, otherwise Cat, Bear, then Caster - whichever you have learned. Fights a target out of reach (up on a ledge or pillar you can't get to) from Caster Form (any setting), and a fleeing one it can't catch too (Cat: after a Feral Charge try)." },
        { name = "Caster", icon = "wrath",    overlay = "Caster Form",    tip = "Will force and use Caster Form (Moonkin Form once learned, if enabled). Heals, Bash and Travel/Aquatic Form still leave it when their options are on." },
        { name = "Cat",    icon = "catForm",  overlay = "Cat Form",       tip = "Will force and use Cat Form (Caster until learned). Stays in Cat for fleeing targets (Feral Charge (Cat) from 8 yards). A target out of reach (on a ledge or pillar), heals, Bash and Travel/Aquatic Form still leave it (their options)." },
        { name = "Bear",   icon = "bearForm", overlay = "Bear Form",      tip = "Will force and use Bear Form (Caster until learned). Stays in Bear for fleeing targets; a target out of reach (on a ledge or pillar), heals and Travel/Aquatic Form still leave it (their options)." },
    } })
    ui.toggle("Prowl", { modes = {
        { name = "On",  icon = "prowl", overlay = "Prowl Enabled",  tip = "Rotation will use Prowl in Cat Form just before you come into an enemy's aggro range" },
        { name = "Off", icon = "prowl", overlay = "Prowl Disabled", tip = "Rotation will not use Prowl" },
    } })
end

---------------
--- Options ---
---------------
-- ui.section(name) starts a group of options; pass it to each option after it.
-- br.ui:checkbox, br.ui:spinner and br.ui:dropdown take the section, the option's name, then any
-- settings to change from their defaults. Spinners and dropdowns have a checkbox unless
-- checkbox = false; checked = true starts it ticked. Every field is listed in System/UI/Elements.
-- Read them in the rotation with ui.checked("Name") and ui.value("Name").
local function options()
    local section = ui.section("General")
    ui.spinner(section, "Shift Wait Time", { value = 2, max = 5, step = 1, checkbox = false,
        tip = "Time in seconds the profile will wait while moving to shift. Combat is instant!" })
    ui.dropdown(section, "Clearcasting Use", { choices = { "Any", "DPS Only", "Healing Only", "None" }, checkbox = false,
        tip = "What Clearcasting (Omen of Clarity) procs should be spent on" })
    ui.spinner(section, "Faerie Fire", { value = 40, checked = true,
        tip = "Keep Faerie Fire on your target in any form: it lowers the target's armor and stops it stealthing",
        boxTip = "In Cat or Bear Form, only while your mana is at or above this percent, so heals and shifting back stay affordable" })
    ui.checkbox(section, "Faerie Fire Pull", { tip = "Out of combat, pull your hostile target from up to 30 yards with Faerie Fire in Bear or Caster Form "
        .. "(never from Prowl), once you're ready to fight (Ready To Fight options, Targeting page)" })

    section = ui.section("Cat Form")
    ui.dropdown(section, "Cat Opener", { choices = { "Pounce", "Ravage", "Shred", "Rake" }, value = "Ravage", checkbox = false,
        tip = "Select Spell to Open with from Stealth (falls back to the next learned option). Ravage and Shred need you behind the target: "
            .. "from Prowl you get 4 sec in melee range to step behind it (over once you stand still or it attacks you), then Rake or Claw" })
    ui.checkbox(section, "Tiger's Fury", { checked = true, tip = "Use Tiger's Fury on cooldown in Cat Form" })
    ui.checkbox(section, "Shifting Power", { checked = true, tip = "Use Shifting Power (talent) to convert Mana into Energy in Cat Form" })
    ui.checkbox(section, "Feral Charge (Cat)", { checked = true, tip = "Leap behind your target from 8-25 yards in combat (talent)" })
    ui.checkbox(section, "Cower", { tip = "In a group, Cower when you pull your target's attention in Cat Form, while a tank is alive within 40 yards to take it back" })

    section = ui.section("Bear Form")
    ui.checkbox(section, "Bear Opener", { tip = "Open a Bear Form pull with Enrage, Demoralizing Roar, then Maul, in that order" })
    ui.checkbox(section, "Feral Charge - Engage", { checked = true, tip = "Charge your target from 8-25 yards in Bear Form" })
    ui.checkbox(section, "Growl", { tip = "In a group, taunt an enemy in melee range that is attacking someone else" })
    ui.spinner(section, "Challenging Roar", { value = 3, min = 2, max = 10, step = 1,
        tip = "In a group, Challenging Roar when at least this many enemies within 10 yards are attacking others" })

    section = ui.section("Caster Form")
    ui.checkbox(section, "Moonkin Form", { checked = true, tip = "Use Moonkin Form (talent) when the Forms toggle picks Caster" })
    ui.spinner(section, "Hurricane", { value = 4, min = 2, max = 10, step = 1,
        tip = "Channel Hurricane on your target when at least this many enemies are within 8 yards of it" })
    ui.checkbox(section, "Hibernate", { tip = "In Caster Form, Hibernate a Beast or Dragonkin attacking you that isn't your target" })
    ui.dropdown(section, "Mana Use", { choices = { "Conserve", "Balanced", "Burn" }, value = "Balanced", checkbox = false,
        tip = "What mana goes on damage spells (Wrath, Starfire, Moonfire and Insect Swarm's damage over time, Hurricane). "
            .. "One heal's mana (Regrowth once known, Healing Touch before) is always kept back. Balanced: damage down to that heal. "
            .. "Conserve: as Balanced, but with an enemy in melee (auto attack costs nothing) only above Conserve Above, or when the "
            .. "fight is going badly (2+ enemies on you, under half health, or you'd die first). Burn: as Balanced, and while nothing "
            .. "threatens you (60%+ health, one enemy at most on you, winning) no heal is kept back. Fights aren't refused at low mana: "
            .. "the Moonfire finisher and heals always may." })
    ui.spinner(section, "Conserve Above", { value = 60, min = 0, max = 100, step = 5, checkbox = false,
        tip = "Mana Use Conserve: mana percent above which damage spells still go out with an enemy in melee." })

    section = ui.section("Form Management")
    ui.checkbox(section, "Aquatic Form", { checked = true, tip = "Shift to Aquatic Form while swimming" })
    ui.checkbox(section, "Travel Form", { tip = "Shift to Travel Form while moving out of combat" })
    ui.spinner(section, "Break Form for Heals Below Energy", { value = 30, min = 1, step = 1, checkbox = false,
        tip = "Only leave Cat Form to heal when Energy is below this" })
    ui.spinner(section, "Break Form for Heals Below Rage", { value = 10, min = 1, step = 1, checkbox = false,
        tip = "Only leave Bear Form to heal when Rage is below this" })

    section = ui.section("Cooldowns")
    ui.dropdown(section, "Berserk", { choices = "AlwaysCdNever", value = "Cooldowns", checkbox = false,
        tip = "When to use Berserk (talent)" })
    ui.spinner(section, "Innervate", { value = 30, min = 5, checked = true, tip = "Self-Innervate at or below this Mana Percent" })

    section = ui.section("Buffs")
    ui.dropdown(section, "Mark of the Wild", { choices = "CastOn", checked = true,
        tip = "Who gets Mark of the Wild out of combat: you, then your target, mouseover, focus or group members (friendly players only)" })
    ui.dropdown(section, "Thorns", { choices = "CastOn", checked = true,
        tip = "Who gets Thorns out of combat: you, then your target, mouseover, focus or group members (tanks first; friendly players only)" })

    section = ui.section("Defensive")
    ui.checkbox(section, "Self Heal In Group", { checked = true, tip = "Heal yourself in a group even when it has a healer. Off: only while the group has none (no member in the Healer role or seen healing others), or yours is dead or beyond 40 yards" })
    ui.dropdown(section, "Heal Others", { choices = "CastOn", checkbox = false,
        tip = "Who the heals below go on besides you: your target, mouseover, focus, or the group member lowest on health (You: only yourself; friendly players only, at the same thresholds)" })
    ui.dropdown(section, "Heal Others Key", { choices = "Toggle", value = "None", checkbox = false,
        tip = "Only heal others while this key is held (None: no key needed)" })
    ui.spinner(section, "Healing Touch", { value = 35, checked = true, tip = "Health Percent to Cast At" })
    ui.spinner(section, "Emergency Below", { value = 20, min = 1, max = 100, step = 1, checkbox = false,
        tip = "Healing Touch leaves Cat or Bear Form without the mana to shift back only at or below this health percent. "
            .. "Above it, it waits until you can pay for the heal and the shift back, so you aren't left out of form" })
    ui.checkbox(section, "Nature's Swiftness", { checked = true, tip = "Make an emergency Healing Touch instant with Nature's Swiftness (talent)" })
    ui.spinner(section, "Regrowth", { value = 55, checked = true, tip = "Health Percent to Cast At (Swiftmend first when a heal over time is on you)" })
    ui.spinner(section, "Rejuvenation", { value = 70, checked = true, tip = "Health Percent to Cast At" })
    ui.spinner(section, "Barkskin", { value = 65, checked = true, tip = "Health Percent to Cast At" })
    ui.spinner(section, "Frenzied Regeneration", { value = 45, checked = true, tip = "Health Percent to Cast At (Bear Form)" })
    ui.spinner(section, "Bash", { value = 35, tip = "Health Percent to stun your target at (Bear Form)" })
    ui.dropdown(section, "Cure Poison", { choices = "CastOn", checked = true,
        tip = "Cure poisons on you, then your target, mouseover, focus or group members (uses Abolish Poison once learned). In combat only while already out of Cat or Bear Form (for a heal, say)" })
    ui.dropdown(section, "Remove Curse", { choices = "CastOn", checked = true,
        tip = "Remove curses out of combat from you, then your target, mouseover, focus or group members" })
    ui.checkbox(section, "Entangling Roots", { tip = "Entangling Roots on fleeing enemies, only when already out of Cat or Bear Form (a fleeing target Cat or Bear can't catch is finished from range). A target running in fear: only with the Forms toggle on Auto." })
    ui.spinner(section, "Nature's Grasp", { value = 40,
        tip = "Escape tool: cast at or below this Health Percent while running from an enemy chasing you within 10 yards. The root breaks on damage, so it's meant for fleeing, not fighting." })
    ui.spinner(section, "Dash", { value = 40, tip = "Escape tool: Dash in Cat Form at or below this Health Percent while running from an enemy chasing you" })

    section = ui.section("Group")
    ui.dropdown(section, "Revive", { choices = "CastOn", value = "You + Group", checked = true,
        tip = "Who to Revive out of combat: a dead friendly player as your target, mouseover, focus or in your group (You: nobody, you can't revive yourself)" })
    ui.dropdown(section, "Rebirth", { choices = "CastOn", value = "You + Group",
        tip = "Who to Rebirth in combat: a dead friendly player as your target, mouseover, focus or in your group, tanks then healers first (You: nobody)" })

    section = ui.section("Interrupts")
    ui.checkbox(section, "Bash - Int", { checked = true, tip = "Interrupt with Bash while in Bear Form" })
    ui.checkbox(section, "Bash - Shift to Bear", { tip = "Allow leaving Cat/Caster Form to Bash (costs Mana and your Energy)" })
    ui.checkbox(section, "Feral Charge - Int", { checked = true, tip = "Interrupt with Feral Charge (Bear) from 8-25 yards" })
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percent to Cast At (0 is random)" })

    section = ui.section("Druid Debug")
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local comboPoints
local energy
local mana
local rage
local var = {}
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}
local activeForm
local freeDPS
local freeHeal
local inForm
local noShapeshiftPower
local targetOnly
local dyn5, dyn30 -- BR's melee and 30 yd picks this tick, or your target only (targetOnly)
local cleave -- Cat Form: the 2 or 3 enemies fighting you in melee (cleavePack), the sim's cleave; else nil
local switching = false -- the Cat list is running again on the enemy it just moved to (cleaveSwitch)
local travelling

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
-- Feral Charge reaches from CHARGE_MIN to CHARGE_MAX yards
local CHARGE_MIN, CHARGE_MAX = 8, 25

-- The Bear Form charge this character has: Forever's Feral Charge (Bear) once learned, else Feral Charge
local function bearChargeKey()
    return spell.feralChargeBear.known() and "feralChargeBear" or "feralCharge"
end

-- Feral Charge (Cat) can go at thisUnit now: the option on, in Cat Form out of Prowl, in its reach, castable. One rule
-- for the Combat charge and the flee chase's hand-over to it, so the two can't drift apart.
local function catChargeReady(thisUnit)
    local dist = unit.distance(thisUnit)
    return ui.checked("Feral Charge (Cat)") and buff.catForm.exists() and not buff.prowl.exists()
        and dist >= CHARGE_MIN and dist < CHARGE_MAX and cast.able.feralChargeCat(thisUnit)
end

-- Caster Form, or Moonkin Form once it's learned (option)
local function casterForm()
    return (ui.checked("Moonkin Form") and spell.moonkinForm.known()) and "moonkin" or "caster"
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
    if form == "caster" then form = casterForm() end
    return form
end

-- Out of form for one buff, the others go out early too, with up to half their duration left: each buff alone costs a
-- form break and a shift back (2026-11-14: Travel Form left for Thorns at 10:03:45, then again for Mark of the Wild at
-- 10:07:04 with ~12 of its 30 min left then; the user's call). Only when BR would shift back afterwards (the toggle's
-- Cat or Bear, or back to Travel Form): a Caster player pays no shift, so its buffs keep the usual refresh.
local BUFF_EARLY_SHARE = 0.5
local function buffShare()
    if inForm or buff.moonkinForm.exists() then return nil end
    if activeForm == "cat" or activeForm == "bear" or var.travelBack then return BUFF_EARLY_SHARE end
    return nil
end

-- Gift of the Wild is a differently named aura, so buff.markOfTheWild misses it and a recast
-- fails with "A more powerful spell is already active". Treat it as satisfying Mark of the Wild.
-- (Gift of the Wild keeps its usual refresh: an early Mark over it would only be refused.)
local function needsMarkOfTheWild(thisUnit)
    if buff.giftOfTheWild.exists(thisUnit) and not buff.giftOfTheWild.refresh(thisUnit) then return false end
    return buff.markOfTheWild.refresh(thisUnit, nil, buffShare())
end

local function needsThorns(thisUnit)
    return buff.thorns.refresh(thisUnit, nil, buffShare())
end

-- Your health is at or below a self-heal's threshold (Rejuvenation, Regrowth or Healing Touch, the ones on), after the
-- heals on their way, and you heal yourself here (Self Heal In Group)
local function healWanted()
    if unit.inGroup() and not ui.checked("Self Heal In Group") and unit.groupHealer() then return false end
    local hp = unit.hpAfterHeals()
    return (ui.checked("Rejuvenation") and hp <= ui.value("Rejuvenation"))
        or (ui.checked("Regrowth") and hp <= ui.value("Regrowth"))
        or (ui.checked("Healing Touch") and hp <= ui.value("Healing Touch"))
end

-- Casts a Caster Form spell, leaving the current form first when it blocks the spell: Cat, Bear,
-- Travel and Aquatic Form block every caster spell, Moonkin Form blocks heals. free: Clearcasting
-- makes the spell free; emergency: leave the form even when shifting back isn't affordable.
-- A form left for a heal is held off (see Forms) until the heal goes out or HEAL_SHIFT_HOLD passes.
-- Out of combat and moving in Travel or Aquatic Form (travelling), only a heal at or below the Healing Touch
-- threshold leaves it; buffs, cures and smaller heals wait until you stop (2026-11-14 10:03:45 and 10:07:04: the
-- user's Travel Form left for Thorns, then Mark of the Wild, on the move). A Travel Form left out of combat is
-- shifted back into once you move on (var.travelBack, see Forms) rather than the toggle's form.
local HEAL_SHIFT_HOLD = 1.5
local function casterCast(spellKey, thisUnit, label, free, emergency, isHeal)
    if inForm or (isHeal and buff.moonkinForm.exists()) then
        if travelling and not (isHeal and unit.hpAfterHeals(thisUnit) <= ui.value("Healing Touch")) then return false end
        local fromTravel = buff.travelForm.exists() and not unit.inCombat()
        local left = unit.cancelFormFor(spell[spellKey], free, emergency)
        if left and isHeal then var.leftFormForHealAt = util.time() end
        if left and fromTravel then var.travelBack = true end
        return left
    end
    if cast[spellKey](thisUnit) then
        if isHeal then var.leftFormForHealAt = nil end
        ui.debug("Casting " .. label)
        return true
    end
    return false
end

-- The friendly player besides you for spellKey's heal, by the Heal Others option (target, mouseover, focus, or the
-- group member lowest on health): at or below threshold health after the heals on their way, wanted (extra, if
-- given) and castable now (spellKey nil: any, castable or not); nil when there's none or the Heal Others Key isn't held
local function healOther(spellKey, threshold, extra)
    return units.castOn("Heal Others", function(thisUnit)
        return unit.hpAfterHeals(thisUnit) <= threshold and (extra == nil or extra(thisUnit))
    end, spellKey and cast.able[spellKey] or nil, { self = false, others = var.healOthersKey })
end

-- " on <name>" for a cast on someone else, for the debug label
local function onName(thisUnit)
    return thisUnit == "player" and "" or (" on " .. unit.name(thisUnit))
end

-- Bear filler: another enemy in Swipe's reach without Faerie Fire that will live long enough to matter
local function faerieFireFiller(thisUnit)
    return not unit.isUnit(thisUnit, "target") and not unit.totem(thisUnit) and unit.ttd(thisUnit) > 10
        and not debuff.faerieFire.exists(thisUnit, "any") and cast.able.faerieFire(thisUnit)
end

-- Rend and Tear counts any caster's bleed on the target, not only yours (wowsims/forever 3c804ec94: Swipe took the
-- bonus on 861 of 874 hits with only other players' bleeds up). Covers the druid bleeds; other classes' bleeds and
-- weapon procs aren't in the lists, so those still read as not bleeding.
local function bleeding(thisUnit)
    return debuff.lacerate.exists(thisUnit, "any") or debuff.rake.exists(thisUnit, "any")
        or debuff.rip.exists(thisUnit, "any") or debuff.pounceBleed.exists(thisUnit, "any")
end

-- No bleeds on it: a mob shown immune to them (unit.bleedImmune), or a totem, which dies to a hit or two and
-- nothing damages it, so its ttd reads 999 (2026-11-09 fight 105: Rake on a Strength of Earth Totem)
local function noBleeds(thisUnit)
    return unit.bleedImmune(thisUnit) or unit.totem(thisUnit)
end

-- A Beast or Dragonkin fighting the player that isn't the target (Hibernate)
local function hibernateTarget(thisUnit)
    return (unit.beast(thisUnit) or unit.dragonkin(thisUnit)) and not unit.isUnit(thisUnit, "target")
        and unit.isTanking(thisUnit) and cast.able.hibernate(thisUnit)
end

-- Mana Use (as Earthcaller-TBC's): fights started on 23-38 mana and ended on 0-2 at level 7, and twice the heal BR
-- wanted (Rejuvenation) couldn't be afforded (Fights 2026-11-05, Palemane area). Mana Use choices (ui.value)
local MANA_CONSERVE, MANA_BURN = 1, 3

-- The heal mana is kept back for: Regrowth once known, Healing Touch before
local function healCost()
    if spell.regrowth.known() then return cast.cost.regrowth() end
    return cast.cost.healingTouch()
end

-- Mana may go on this damage spell, by Mana Use (unit.unthreatened: nothing in the fight threatens you; unit.pressure:
-- why it's going badly). Returns why ("mana 64%", "2 enemies on you", "free", "safe"), shown
-- in the cast's debug line, or nil to hold it
local function spendOnDamage(spellKey, thisUnit)
    if freeDPS then return "free" end
    local percent = power.mana.percent()
    local manaWhy = ("mana %d%%"):format(percent)
    if ui.value("Mana Use") == MANA_BURN and thisUnit ~= nil and unit.unthreatened(thisUnit) then return "safe" end
    if not power.mana.affordable(cast.cost[spellKey](), healCost()) then return nil end
    if ui.value("Mana Use") == MANA_CONSERVE and thisUnit ~= nil and unit.distance(thisUnit) < 5 then
        local why = unit.pressure(thisUnit)
        if why then return why end
        if percent >= ui.value("Conserve Above") then return manaWhy end
        return nil
    end
    return manaWhy
end

-- " [why]" for a debug line
local function tag(why) return type(why) == "string" and (" [" .. why .. "]") or "" end

-- A target you can't get to in melee (up on a ledge or pillar) leaves Bear or Cat Form with nothing to do
-- (Fights 2026-11-06 15:28: a Dustwind Storm Witch on a ledge at 23 yd, 17 s in Bear Form without an attack).
-- In combat, a target beyond REACH_BACK yards that stands at least REACH_UP yards above or below you counts as out
-- of reach once you have spent REACH_WAIT seconds moving without the gap closing by a yard: fight it from range until
-- it comes within REACH_BACK yards or the target changes. The clock runs only while you move and it stands still on
-- that height (the user's call, 2026-11-08: you standing there, or a mob on its way around a fence, isn't out of
-- reach; it's meant for mobs with no way up to them). Not beyond REACH_MAX (Wrath and Moonfire range: shifting can't
-- reach it either) and not while it flees (it comes back or dies in a few seconds; 2026-11-06 17:48: two fleeing
-- murlocs at 10-11 yd cost two shifts each for a Rejuvenation and one Moonfire; 19:36: a hyena at 62 yd). Returns the
-- distance and the height gap when out of reach, else nil.
local REACH_WAIT, REACH_BACK, REACH_MAX, REACH_UP = 3, 8, 30, 4
-- runRotation asks only while nothing is in melee with you: a wait not asked about for this long was cut off (a mob
-- came into melee), so it starts over instead of counting the gap as time spent trying to reach the target
local WAIT_GAP = 1
local function outOfReach(thisUnit)
    local guid = unit.inCombat() and unit.exists(thisUnit) and unit.guid(thisUnit) or nil
    local dist = guid and unit.distance(thisUnit)
    if dist == nil or dist < REACH_BACK or dist > REACH_MAX or unit.isFleeing(thisUnit) then
        var.reach = nil
        return nil
    end
    local now, r = util.time(), var.reach
    if r == nil or r.guid ~= guid then
        var.reach = { guid = guid, best = dist, tried = 0, last = now }
        return nil
    end
    if not r.out then
        if now - r.last > WAIT_GAP then r.best, r.tried, r.last = dist, 0, now end
        local _, _, pz = unit.position("player")
        local _, _, tz = unit.position(thisUnit)
        local rise = pz and tz and math.abs(tz - pz) or 0
        if dist < r.best - 1 or rise < REACH_UP or unit.moving(thisUnit) then
            -- closing in, on level ground, or it's moving (coming round to you): the wait starts over from here
            r.best, r.tried = dist, 0
        elseif unit.moving("player") then
            r.tried = r.tried + (now - r.last)
        end
        r.last, r.rise = now, rise
        r.out = r.tried >= REACH_WAIT
    end
    return r.out and dist or nil, r.rise
end

-- A target that flees at low health runs at your speed, so chasing it in Bear or Cat Form keeps you out of melee
-- until the flee ends (Fights 2026-11-07: 10 of 13 idles, 7-18 s each, came after "%s attempts to run away in fear!";
-- Plainstriders ran about 20 s, 9 yd ahead). Once it has fled out of melee for FLEE_WAIT seconds within REACH_MAX
-- yards, finish it from range (Moonfire works on the move), and stay out of form for that target until it dies or
-- the target changes, so it coming back into melee doesn't cost a second shift. Not even beyond REACH_MAX: it
-- comes back or dies to the Moonfire on it (2026-11-07 16:02:56: back to Bear at 30 yd, Caster again 5 s later,
-- dead 0.6 s after, two shifts for nothing). True while that holds; the second result is true while the FLEE_WAIT
-- runs, so a player already out of form isn't shifted to Bear just before it ends.
local FLEE_WAIT = 2
local function fleeChase(thisUnit)
    local guid = unit.inCombat() and unit.exists(thisUnit) and not unit.deadOrGhost(thisUnit) and unit.guid(thisUnit) or nil
    local f = var.flee
    if guid == nil then
        var.flee = nil
        return false, false
    end
    if f ~= nil and f.guid == guid and f.out then return true, false end
    local dist = unit.distance(thisUnit)
    if unit.isFleeing(thisUnit) ~= "flee" or dist < 5 or dist > REACH_MAX then
        var.flee = nil
        return false, false
    end
    local now = util.time()
    -- a new target, or a wait not asked about for WAIT_GAP (runRotation skips it while the target is out of reach)
    if f == nil or f.guid ~= guid or now - f.last > WAIT_GAP then
        var.flee = { guid = guid, since = now, last = now }
        return false, true
    end
    f.last = now
    f.out = now - f.since >= FLEE_WAIT
    return f.out, not f.out
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Buffs
actionList.Buffs = function()
    -- Out of combat, in a city or inn too (the user's call, 2026-11-14: nothing went out in Undercity with You + Target
    -- on a friendly player); the option still picks who, so a stranger in town gets a buff only when you target them
    if unit.inCombat() then return false end
    -- Mark of the Wild
    if ui.checked("Mark of the Wild") then
        local markUnit = units.castOn("Mark of the Wild", needsMarkOfTheWild, cast.able.markOfTheWild)
        if markUnit and casterCast("markOfTheWild", markUnit, "Mark of the Wild" .. onName(markUnit)) then return true end
    end
    -- Thorns: tanks first, where it does the most
    if ui.checked("Thorns") then
        local thornUnit = units.castOn("Thorns", needsThorns, cast.able.thorns, { roles = { "TANK" } })
        if thornUnit and casterCast("thorns", thornUnit, "Thorns" .. onName(thornUnit)) then return true end
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
    -- Travel Form (the option, or back into the Travel Form BR left for a cast: var.travelBack)
    if (ui.checked("Travel Form") or var.travelBack) and not unit.inCombat() and not unit.mounted()
        and not unit.swimming() and not unit.falling() and cast.able.travelForm()
        and not buff.travelForm.exists() and not buff.prowl.exists()
        and unit.moving() and unit.movingTime() > 2 and not unit.anyInAggroRange()
    then
        if buff.catForm.exists() or buff.bearForm.exists() or buff.moonkinForm.exists() then
            if unit.cancelFormFor(spell.travelForm) then return true end
        end
        if cast.travelForm() then
            ui.debug("Casting Travel Form" .. (var.travelBack and " [back after a cast]" or ""))
            var.travelBack = nil
            return true
        end
    end
    -- Form from the Forms toggle
    local keepAquatic = ui.checked("Aquatic Form") and unit.swimming() and buff.aquaticForm.exists()
        and not unit.anyInAggroRange() and (not unit.exists("target") or unit.friend("target"))
    if keepAquatic or buff.travelForm.exists() or unit.gcd() > 0 or unit.isCasting("player") then return false end
    -- Just left a form for a heal that hasn't gone out yet (held by BR's cast timer, say): wait for it rather than
    -- shift straight back (Form.log 2026-11-05 22:19 and 2026-11-06 19:30: Rejuvenation not cast, Bear Form 0.27 s
    -- later, two shifts' mana for nothing)
    if var.leftFormForHealAt and util.time() - var.leftFormForHealAt < HEAL_SHIFT_HOLD then return false end
    if not ((unit.moving() and unit.movingTime() > ui.value("Shift Wait Time")) or unit.inCombat() or unit.anyInAggroRange(5)) then
        return false
    end
    -- Out of combat with no enemy in aggro range, stay out of form while you still want a heal: shifting in between
    -- heals pays a shift each time (2026-11-14 10:02:55-10:03:12: Cat, out for Rejuvenation, Cat, out for the
    -- out-of-combat Healing Touch once you stopped, Cat: three shifts in 17 s; the user's call)
    if not unit.inCombat() and not unit.anyInAggroRange() and healWanted() then return false end
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
    -- Grouped: your own heals with Self Heal In Group, or while no one else heals (no healer, or yours is dead or away)
    local inGroupOk = not unit.inGroup() or ui.checked("Self Heal In Group") or not unit.groupHealer()
    -- Remove Curse
    if ui.checked("Remove Curse") and not unit.inCombat() then
        local cursed = units.castOn("Remove Curse", cast.dispel.removeCurse, cast.able.removeCurse)
        if cursed and casterCast("removeCurse", cursed, "Remove Curse" .. onName(cursed)) then return true end
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
        -- Only on a target that outlives the root and a Wrath after it, with a heal's mana kept (2026-11-05: 3 of 3
        -- Roots on fleeing centaurs failed, two on targets the Wrath already in flight killed; 50 mana each).
        -- Only when already out of form: Cat and Bear (Auto) leave for a fleeing mob themselves (fleeChase). A mob
        -- running in fear (someone's fear, not the low-health flee) only with the Forms toggle on Auto (the user's
        -- call, 2026-11-11)
        local loose = unit.isFleeing("target")
        if ui.checked("Entangling Roots") and not inForm and cast.able.entanglingRoots("target")
            and (loose == "flee" or (loose == "fear" and ui.mode.forms == 1))
            and unit.valid("target") and unit.hp("target") < 100 and not debuff.entanglingRoots.exists("target")
            and unit.distance("target") > 8 and not unit.moving()
            and unit.livesFor("target", cast.time.entanglingRoots() + cast.time.wrath())
            and power.mana.affordable(cast.cost.entanglingRoots(), healCost())
        then
            if casterCast("entanglingRoots", "target", "Entangling Roots", freeDPS) then return true end
        end
        -- Bash (low health stun)
        if ui.checked("Bash") and unit.hp() <= ui.value("Bash") and buff.bearForm.exists() and cast.able.bash(dyn5) then
            if cast.bash(dyn5) then
                ui.debug("Casting Bash [Defensive]")
                return true
            end
        end
        -- Cower: in a group, when the mob you fight turns on you in Cat Form (that mob's threat: another one
        -- on you isn't helped by cowering this one)
        if ui.checked("Cower") and unit.inGroup() and buff.catForm.exists() and cast.able.cower(dyn5)
            and unit.threatStatus(dyn5) >= 2 and unit.role("player") ~= "TANK" and unit.isTankInRange()
        then
            if cast.cower(dyn5) then
                ui.debug("Casting Cower")
                return true
            end
        end
    end
    -- Heals: you first, then the Heal Others pick (healOther) at the same thresholds, by health after the
    -- heals already on their way (unit.hpAfterHeals): a heal about to land covers its gap
    -- War Stomp (Tauren) right before a cast-time heal on yourself while something hits you: the heal then
    -- lands inside the 2 s stun, without pushback (module.RacialStun: needs an enemy within 8 yd attacking you)
    local function stunFirst() return unit.inCombat() and module.RacialStun() end
    -- Healing Touch: the big heal, leaves any form regardless of Energy/Rage. Without the mana to shift back too, only at
    -- or below Emergency Below: above it you stay in form and fight on (2026-11-13 fight 8: Healing Touch at 33% left
    -- Cat Form on 4 mana, 9 s in caster form; the user's call). Nature's Swiftness (off the GCD) makes it instant.
    local function healingTouchLeaves(thisUnit)
        local emergency = unit.hpAfterHeals(thisUnit) <= ui.value("Emergency Below")
        local leaves = not (inForm or buff.moonkinForm.exists())
            or unit.canLeaveFormFor(spell.healingTouch, freeHeal, emergency)
        return leaves, emergency
    end
    if ui.checked("Healing Touch") and not cast.current.healingTouch() then
        local selfLow = inGroupOk and unit.hpAfterHeals() <= ui.value("Healing Touch")
        local otherLow = healOther(nil, ui.value("Healing Touch")) ~= nil
        if (selfLow or otherLow) and ui.checked("Nature's Swiftness") and unit.inCombat() and not inForm
            and not buff.moonkinForm.exists() and cast.able.naturesSwiftness() and not buff.naturesSwiftness.exists()
        then
            if cast.naturesSwiftness() then
                ui.debug("Casting Nature's Swiftness")
                return true
            end
        end
        if not unit.moving() or buff.naturesSwiftness.exists() then
            local leaves, emergency = healingTouchLeaves("player")
            if selfLow and leaves and cast.able.healingTouch("player") then
                if not buff.naturesSwiftness.exists() and stunFirst() then return true end
                if casterCast("healingTouch", "player", "Healing Touch", freeHeal, emergency, true) then return true end
            end
            local other = otherLow and healOther("healingTouch", ui.value("Healing Touch"))
            if other then
                leaves, emergency = healingTouchLeaves(other)
                if leaves and casterCast("healingTouch", other, "Healing Touch" .. onName(other), freeHeal, emergency, true) then
                    return true
                end
            end
        end
    end
    -- Swiftmend / Regrowth: leaves Cat or Bear Form only when Energy/Rage is low or the heal is free
    if ui.checked("Regrowth") and (freeHeal or noShapeshiftPower) then
        local threshold = ui.value("Regrowth")
        local function hasHot(thisUnit) return buff.rejuvenation.exists(thisUnit) or buff.regrowth.exists(thisUnit) end
        local function noRegrowth(thisUnit) return not buff.regrowth.exists(thisUnit) end
        local regrowthNow = not cast.current.regrowth() and not unit.moving()
        if inGroupOk and unit.hpAfterHeals() <= threshold then -- you
            if cast.able.swiftmend("player") and hasHot("player") then
                if casterCast("swiftmend", "player", "Swiftmend", freeHeal, false, true) then return true end
            end
            if regrowthNow and cast.able.regrowth("player") and noRegrowth("player") then
                if stunFirst() then return true end
                if casterCast("regrowth", "player", "Regrowth", freeHeal, false, true) then return true end
            end
        end
        local other = healOther("swiftmend", threshold, hasHot) -- then the Heal Others pick
        if other and casterCast("swiftmend", other, "Swiftmend" .. onName(other), freeHeal, false, true) then return true end
        other = regrowthNow and healOther("regrowth", threshold, noRegrowth)
        if other and casterCast("regrowth", other, "Regrowth" .. onName(other), freeHeal, false, true) then return true end
    end
    -- Out of combat and standing still, one Healing Touch at the Rejuvenation threshold instead of Rejuvenations:
    -- more health for the mana, and you're not in a hurry (the user's call, 2026-11-06). While moving, Rejuvenation.
    if ui.checked("Healing Touch") and ui.checked("Rejuvenation") and not unit.inCombat() and not unit.moving()
        and not cast.current.healingTouch()
    then
        if inGroupOk and unit.hpAfterHeals() <= ui.value("Rejuvenation") and cast.able.healingTouch("player") then
            if casterCast("healingTouch", "player", "Healing Touch [Out of combat]", freeHeal, false, true) then return true end
        end
        local other = healOther("healingTouch", ui.value("Rejuvenation"))
        if other and casterCast("healingTouch", other, "Healing Touch [Out of combat]" .. onName(other), freeHeal, false, true) then return true end
    end
    -- Rejuvenation: too slow to justify two shapeshifts in combat, out of Cat, Bear or Moonkin Form alike (Moonkin
    -- prevents healing spells on Forever, and shifting back costs 35% of base mana; the user's call, 2026-11-11). It's
    -- recast only once it's gone: a recast with
    -- ~3 s left threw away its last tick (2026-11-05: recast every 8.4-8.8 s of its 12 s, ticks every 3 s), and the
    -- Bloom talent heals only when it runs out. Out of combat too (2026-11-06: several Rejuvenations after a fight).
    -- Out of combat it's for healing on the move: standing still, the Healing Touch above heals more for the mana, and
    -- waits for its mana rather than a Rejuvenation going out the moment its smaller cost is there (the user's call,
    -- 2026-11-09: back from dying, low on mana, a Rejuvenation went out instead of waiting for a denser heal).
    local function rejuvenationDue(thisUnit)
        return not buff.rejuvenation.exists(thisUnit)
    end
    local rejuvenationNow = unit.inCombat() or unit.moving() or not ui.checked("Healing Touch")
    if ui.checked("Rejuvenation") and rejuvenationNow
        and (not unit.inCombat() or not (inForm or buff.moonkinForm.exists()))
    then
        if unit.hpAfterHeals() <= ui.value("Rejuvenation") and rejuvenationDue("player") and not buff.clearcasting.exists()
            and inGroupOk and cast.able.rejuvenation("player")
        then
            if casterCast("rejuvenation", "player", "Rejuvenation", freeHeal, false, true) then return true end
        end
        local other = healOther("rejuvenation", ui.value("Rejuvenation"), rejuvenationDue)
        if other and casterCast("rejuvenation", other, "Rejuvenation" .. onName(other), freeHeal, false, true) then return true end
    end
    -- Cure Poison (Abolish Poison once learned): after the heals, so a form left for a heal casts the heal first
    -- (2026-11-08 10:35:58: Cure Poison went out ahead of the Regrowth BR left Cat for). In combat only while already
    -- out of Cat or Bear Form, so it rides along with a heal. Gating it on low Energy wasn't enough: Claw keeps Energy low, and Bristleback Hunters
    -- re-poisoned three times in one fight, two shifts each (Rotation.log 2026-11-08 09:58, 834 mana). You first, then
    -- the option's target, mouseover, focus or group members.
    if ui.checked("Cure Poison") and (not unit.inCombat() or not inForm) then
        if spell.abolishPoison.known() then
            local poisoned = units.castOn("Cure Poison", function(thisUnit)
                return not buff.abolishPoison.exists(thisUnit) and cast.dispel.abolishPoison(thisUnit)
            end, cast.able.abolishPoison)
            if poisoned and casterCast("abolishPoison", poisoned, "Abolish Poison" .. onName(poisoned)) then return true end
        else
            local poisoned = units.castOn("Cure Poison", cast.dispel.curePoison, cast.able.curePoison)
            if poisoned and casterCast("curePoison", poisoned, "Cure Poison" .. onName(poisoned)) then return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Utility: bringing group members back, taunts and crowd control
actionList.Utility = function()
    -- Revive (out of combat, 10 sec cast): the dead player the Revive option picks (cast-on choices, as the buffs;
    -- the user's call, 2026-11-14)
    if ui.checked("Revive") and not unit.inCombat() and not unit.moving() then
        local thisUnit = units.castOn("Revive", nil, cast.able.revive.dead, { self = false, dead = true })
        if thisUnit then
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
    -- (the Rebirth option's pick, tanks then healers first in the group)
    if ui.checked("Rebirth") and not unit.moving() then
        local thisUnit = units.castOn("Rebirth", nil, cast.able.rebirth.dead, { self = false, dead = true, roles = { "TANK", "HEALER" } })
        if thisUnit then
            if inForm or buff.moonkinForm.exists() then
                if unit.cancelFormFor(spell.rebirth) then return true end
            elseif cast.rebirth.dead(thisUnit) then
                ui.debug("Casting Rebirth on " .. unit.name(thisUnit))
                return true
            end
        end
    end
    -- Growl: an enemy in melee range attacking someone else
    -- Growl, Challenging Roar and Hibernate go to mobs that aren't your target: not out of combat (targetOnly)
    if ui.checked("Growl") and not targetOnly and unit.inGroup() and buff.bearForm.exists() and cast.able.growl() then
        local thisUnit = enemies.first(enemies.yards5, unit.attackingOthers)
        if thisUnit and cast.growl(thisUnit) then
            ui.debug("Casting Growl on " .. unit.name(thisUnit))
            return true
        end
    end
    -- Challenging Roar: several enemies around you attacking others
    if ui.checked("Challenging Roar") and not targetOnly and unit.inGroup() and buff.bearForm.exists() and cast.able.challengingRoar()
        and enemies.count(enemies.yards10, unit.attackingOthers) >= ui.value("Challenging Roar")
    then
        if cast.challengingRoar() then
            ui.debug("Casting Challenging Roar")
            return true
        end
    end
    -- Hibernate: a Beast or Dragonkin add while you fight your target (Caster/Moonkin Form only)
    -- not while a Hibernate is still casting: its debuff isn't there yet, so a second one went out
    -- behind it (BRCast.log 2026-10-12)
    if ui.checked("Hibernate") and not targetOnly and not inForm and not unit.moving() and debuff.hibernate.count() == 0
        and not cast.current.hibernate() and #enemies.yards30 > 1
    then
        local thisUnit = enemies.first(enemies.yards30, hibernateTarget)
        if thisUnit and cast.hibernate(thisUnit) then
            ui.debug("Casting Hibernate on " .. unit.name(thisUnit))
            return true
        end
    end
end -- End Action List - Utility

-- Action List - Interrupts
actionList.Interrupts = function()
    if not (ui.useInterrupt() and util.timer("Interrupts", unit.gcd(true))) then return false end
    local thisUnit
    local inBear = buff.bearForm.exists()
    local interruptAt = ui.value("Interrupt At")
    -- Feral Charge (Bear) - 8 to 25 yards
    if ui.checked("Feral Charge - Int") and inBear then
        local chargeKey = bearChargeKey()
        if cast.able[chargeKey]() then
            enemies.get(CHARGE_MAX)
            thisUnit = enemies.first(enemies.yards25, function(thisUnit)
                return (not targetOnly or unit.isUnit(thisUnit, "target"))
                    and unit.distance(thisUnit) >= CHARGE_MIN and unit.interruptable(thisUnit, interruptAt)
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
            return (not targetOnly or unit.isUnit(thisUnit, "target"))
                and unit.interruptable(thisUnit, interruptAt) and (not inBear or cast.able.bash(thisUnit))
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
        and unit.exists(dyn5) and unit.distance(dyn5) < 5
        and (ui.alwaysCdNever("Berserk") and unit.ttd(dyn5) > 15
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
    local lacerateStacks = debuff.lacerate.stack(dyn5)
    -- Lacerate at 5 stacks about to fall off (it starts again at 1): first, as wowsims/forever's Bear rotation
    if cast.able.lacerate(dyn5) and lacerateStacks >= 5 and debuff.lacerate.remain(dyn5) <= 3 then
        if cast.lacerate(dyn5) then
            ui.debug("Casting Lacerate [Keep Stack]")
            return true
        end
    end
    -- Primal Bite (talent): high threat on a 6 sec cooldown; Berserk makes it hit 3 targets with no cooldown
    if cast.able.primalBite(dyn5) then
        if cast.primalBite(dyn5) then
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
    -- Swipe (hits 3): from 2 enemies once the target bleeds, anyone's bleed (Rend and Tear raises Swipe), else 3
    -- (the sim's rule)
    if cast.able.swipe() and ui.useAOE(8, bleeding(dyn5) and 2 or 3) then
        if cast.swipe() then
            ui.debug("Casting Swipe")
            return true
        end
    end
    -- Lacerate: a bleed (Rend and Tear) with high threat, and the filler for every global cooldown, 5 stacks or not
    -- (the sim's); stacking up starts only on a target that lives 6+ sec
    if cast.able.lacerate(dyn5) and (lacerateStacks > 0 or unit.ttd(dyn5) > 6)
        and not noBleeds(dyn5)
    then
        if cast.lacerate(dyn5) then
            ui.debug("Casting Lacerate")
            return true
        end
    end
    -- Maul: on the next swing, with Rage left over for Primal Bite when it's nearly ready. With 3+ enemies around
    -- also for the Swipe after it, Maul's and Swipe's cost (was 40 Rage). On two Feral Instinct or Blood Frenzy
    -- points from 10 Rage with 2+ enemies around (else 15). wowsims/forever's Bear cleave (d22130484).
    local reserve = (spell.primalBite.known() and cd.primalBite.remain() < 2) and 20 or 0
    local floor = (ui.useAOE(8, 2) and (talent.rank.feralInstinct >= 2 or talent.rank.bloodFrenzy >= 2)) and 10 or 15
    local swipeAfter = spell.swipe.known() and ui.useAOE(8, 3)
    if cast.able.maul(dyn5) and rage >= floor + reserve
        and (not swipeAfter or rage >= cast.cost.maul() + cast.cost.swipe())
    then
        if cast.maul(dyn5) then
            ui.debug("Casting Maul")
            return true
        end
    end
end -- End Action List - Bear Form

-- Stealth openers, in the Cat Opener option's order: the chosen one, else the next one learned, down to Claw.
-- Ravage and Shred need you behind the target.
local STEALTH_OPENERS = { "pounce", "ravage", "shred", "rake", "claw" }
local STEALTH_OPENER_NAMES = { pounce = "Pounce", ravage = "Ravage", shred = "Shred", rake = "Rake", claw = "Claw" }
local OPENS_BEHIND = { ravage = true, shred = true }
-- From Prowl in front of the target, time to step behind it for Ravage or Shred (Druid-TBC's Ravage wait): as long
-- as you keep moving in Prowl (out of Prowl: up to STEALTH_WAIT seconds from reaching melee range), then the next
-- opener that works from the front. Not while it attacks you (it turns to face you), and over once you've stood still
-- for STEALTH_STILL seconds (opening from where you stand). Before, a Ravage player in front of it got nothing at all (every fallback needed Ravage or
-- Shred unlearned), and a Shred player a Claw straight away (the user's call, 2026-11-08).
local STEALTH_WAIT, STEALTH_STILL = 4, 1.5
local function stealthWait(spellName)
    if unit.isUnit("targettarget", "player") then return false end
    local guid, now = unit.guid("target"), util.time()
    local w = var.stealthWait
    if w == nil or w.guid ~= guid then
        w = { guid = guid, since = now }
        var.stealthWait = w
        if unit.standingTime() <= STEALTH_STILL then
            ui.debug((buff.prowl.exists() and "Stealth Opener: while you move, time to get behind %s for %s"
                or ("Opener: up to " .. STEALTH_WAIT .. " s to get behind %s for %s")):format(unit.name("target") or "target", spellName))
        end
    end
    -- In Prowl no time limit while you move: getting behind can mean walking around or through the pack (the user,
    -- 2026-11-14: Ravage is the top hit, maximise the chance)
    if not w.over then
        w.over = (not buff.prowl.exists() and now - w.since > STEALTH_WAIT) or unit.standingTime() > STEALTH_STILL
    end
    return not w.over
end

-- The opener's pick can't go out yet. Short of its Energy: wait for it (var.openerHold: Combat sends nothing else from
-- Cat Form, Faerie Fire included, so a cheaper hit doesn't spend the Energy first). Refused for another reason (range,
-- the game said not behind): no wait, the rotation goes on. Returns false.
local function openerWaits(key)
    if energy < cast.cost[key]() then var.openerHold = true end
    return false
end

-- Action List - Cat Opener (Stealth + Non-Stealth)
actionList.CatOpener = function()
    var.openerHold = false
    if not buff.catForm.exists() then return false end
    if not unit.valid("target") or unit.deadOrGhost("target") or unit.distance("target") >= 5 then
        var.stealthWait = nil -- the time to get behind starts again on reaching melee range
        return false
    end
    if unit.player("target") then return false end

    -- Tiger's Fury before the opening hit
    if ui.checked("Tiger's Fury") and cast.able.tigersFury() and not buff.tigersFury.exists() then
        if cast.tigersFury() then
            ui.debug("Casting Tiger's Fury [Opener]")
            return true
        end
    end

    -- Stealth Opener: the first learned opener from the Cat Opener option on. One that needs you behind the target
    -- waits for you to get there (stealthWait), then gives way to the next that doesn't. A pick that's learned but
    -- not castable yet (Energy, say) is waited for rather than swapped for a weaker one.
    if buff.prowl.exists() then
        local behind = unit.isBehind("target", "player") and not unit.facing("target", "player")
        local passed
        for i = ui.value("Cat Opener"), #STEALTH_OPENERS do
            local key = STEALTH_OPENERS[i]
            local name = STEALTH_OPENER_NAMES[key]
            -- Rake misses in full on a bleed-immune mob; Pounce stays (a landed Pounce always stuns and gives its combo
            -- point, only the bleed is lost; the cast itself can miss, wowsims/forever)
            if spell[key].known() and not (OPENS_BEHIND[key] and passed) and not (key == "rake" and noBleeds("target")) then
                if OPENS_BEHIND[key] and not behind then
                    if stealthWait(name) then
                        var.openerHold = true
                        return false
                    end
                    passed = name
                else
                    if not cast.able[key]("target") then return openerWaits(key) end
                    if cast[key]("target") then
                        ui.debug(("Casting %s [Stealth Opener%s]"):format(name, passed and (", not behind for " .. passed) or ""))
                        return true
                    end
                    return false
                end
            end
        end
        return false
    end

    -- Non-Stealth Opener: the hardest first hit from where you stand. Behind: Shred. In front: Rake (its bleed and a
    -- combo point; the Cat list's first builder too), not on a bleed-immune mob, a totem or one dying within 6 sec
    -- (the Cat list's Rake rule); else Claw.
    local behindTarget = unit.isBehind("target", "player") and not unit.facing("target", "player")
    -- In front, with a behind opener picked (any Cat Opener but Rake): the same time to step behind it as from Prowl
    -- (stealthWait: not while it attacks you, over once you stand still). 2026-11-14 RFK: the game refused your Prowl
    -- in combat and Rake went out from the front at once, before you could get behind for Shred.
    if not behindTarget and spell.shred.known() and ui.value("Cat Opener") < #STEALTH_OPENERS - 1
        and stealthWait("Shred")
    then
        var.openerHold = true
        return false
    end
    -- Shred (from behind)
    if behindTarget and spell.shred.known() then
        if cast.able.shred("target") and cast.shred("target") then
            ui.debug("Casting Shred [Opener]")
            return true
        end
        return openerWaits("shred")
    end
    -- Rake (from the front)
    if spell.rake.known() and not noBleeds("target") and unit.ttd("target") > 6 then
        if cast.able.rake("target") and cast.rake("target") then
            ui.debug("Casting Rake [Opener]")
            return true
        end
        return openerWaits("rake")
    end
    -- Claw (fallback)
    if cast.able.claw("target") then
        if cast.claw("target") then
            ui.debug("Casting Claw [Opener]")
            return true
        end
        return false
    end
    return openerWaits("claw")
end -- End Action List - Cat Opener

-- The enemies in melee fighting you or your group (no totems): a Cat cleave at 2 or 3 of them
local function cleavePack()
    local pack = {}
    for i = 1, #enemies.yards5 do
        local thisUnit = enemies.yards5[i]
        if not unit.totem(thisUnit) and not unit.deadOrGhost(thisUnit) and unit.inCombat(thisUnit) and unit.threat(thisUnit) then
            pack[#pack + 1] = thisUnit
        end
    end
    return pack
end

-- Cat numbers from wowsims/forever's Cat rotation (d22130484, 2026-11-15), by Blood Frenzy's rank and whether Claw
-- is the paid builder (no Shredding Attacks). The sim's level 60 idol tunings (Ferocity, the Dream) are left out.

-- Energy for a Predatory Discipline Ferocious Bite mid-fight: on 4 combo points / on 5 (Clearcasting in brackets):
-- no Blood Frenzy with Claw 90 (90) / 70 (35), with Shred 100 (55) / 60 (40); two points with Claw 65 (45) / 60 (40);
-- else 75 (45) / 70 (40). On 5 the lower of the two goes, always the 5-point one.
local function biteEnergy(cp, clearcasting, bloodFrenzy, clawBuilds)
    local four, five
    if bloodFrenzy == 0 and clawBuilds then four, five = 90, clearcasting and 35 or 70
    elseif bloodFrenzy == 0 then four, five = clearcasting and 55 or 100, clearcasting and 40 or 60
    elseif bloodFrenzy >= 2 and clawBuilds then four, five = clearcasting and 45 or 65, clearcasting and 40 or 60
    else four, five = clearcasting and 45 or 75, clearcasting and 40 or 70 end
    return cp >= 5 and five or four
end

-- Seconds of Rip left for that Bite: 3; without Blood Frenzy 4 with Shred, and with Claw 2 in a fight of up to 60 sec
-- (time in combat and the target's time to die), else 4
local function biteRipLeft(bloodFrenzy, clawBuilds, ttd)
    if bloodFrenzy > 0 then return 3 end
    if clawBuilds and unit.combatTime() + ttd <= 60 then return 2 end
    return 4
end

-- The paid builder goes now, rather than pooling Energy: on one Blood Frenzy point always; else at 60 Energy, or
-- below 4 combo points (no Blood Frenzy) / below 3 (two points). In a cleave (cl, cleaveRules): below 5, or at its
-- Energy.
local function paidBuilderFits(cp, bloodFrenzy, cl)
    if bloodFrenzy == 1 then return true end
    if cl then return cp < 5 or energy >= cl.builderEnergy end
    return energy >= 60 or (bloodFrenzy == 0 and cp < 4) or (bloodFrenzy >= 2 and cp < 3)
end

-- The sim's cleave numbers (2 or 3 enemies, n), by talents: its Shred tuning (Shredding Attacks and two Blood Frenzy
-- points), Hybrid with two points (Claw), or Hybrid. ripCP: Rip on these combo points (2 enemies 4 / 3 / 2, 3
-- enemies 3); rakeLife: Rake on an enemy living longer (2 enemies 6, 4 on Hybrid with two points; 3 enemies 4, 6 on
-- Hybrid with two points); biteCP: the fight-end Bite (5; 3 enemies 3, 5 on Hybrid with two points); bite: a
-- mid-fight Bite { Energy, with Clearcasting, Rip seconds left } (Shred tuning 50/25/3, Hybrid at 3 enemies
-- 50/30/2, else none); builderEnergy: the paid builder at 5 combo points (60; Hybrid at 3 enemies 45).
-- switchCP: at most these combo points for a switch to Rake or Rip another (Hybrid with two points at 2 enemies 2,
-- else 0, after a finisher); spreadTalents: the talents the sim spreads Rake on in short pulls.
local function cleaveRules(n, bloodFrenzy, clawBuilds)
    local shred = not clawBuilds and bloodFrenzy >= 2
    local hybridBF = not shred and bloodFrenzy >= 2
    local zeroClaw = bloodFrenzy == 0 and clawBuilds
    local r = { n = n, shred = shred, biteCP = 5, builderEnergy = 60, switchCP = 0 }
    if n == 2 then
        r.ripCP = shred and 4 or hybridBF and 3 or 2
        r.rakeLife = hybridBF and 4 or 6
        r.bite = shred and { 50, 25, 3 } or nil
        if hybridBF then r.switchCP = 2 end
        r.spreadTalents = zeroClaw or shred
    else
        r.ripCP = 3
        r.rakeLife = hybridBF and 6 or 4
        r.biteCP = hybridBF and 5 or 3
        r.bite = shred and { 50, 25, 3 } or (not hybridBF and { 50, 30, 2 }) or nil
        r.builderEnergy = hybridBF and 60 or 45
        r.spreadTalents = zeroClaw or bloodFrenzy >= 2
    end
    return r
end

-- Another enemy of the cleave pack (cleave) to move to, or nil (the sim's switch rules). Spreading Rake: in a pull of
-- up to 20 sec (time in combat and the longest time to die in the pack), on the talents it spreads on, with 2 enemies
-- only while your Rake can run out before this one dies: one without your Rake, when this one has it, that lives past
-- cl.rakeLife. Otherwise, at cl.switchCP combo points or fewer (the ones here go with the switch): that, or one
-- without your Rip when this one has it, that lives 8+ sec; on the Shred tuning only while this one has Rip, onto one
-- living 12+ sec.
local function cleaveSwitch(thisUnit, cl, ttd)
    local rakeUp, ripUp = debuff.rake.exists(thisUnit), debuff.rip.exists(thisUnit)
    if not (rakeUp or ripUp) then return nil end
    local longest = 0
    for i = 1, #cleave do longest = math.max(longest, unit.ttd(cleave[i])) end
    local spread = cl.spreadTalents and unit.combatTime() + longest <= 20
        and (cl.n == 3 or ttd >= debuff.rake.remain(thisUnit))
    if not spread and comboPoints > cl.switchCP then return nil end
    for i = 1, #cleave do
        local other = cleave[i]
        if not unit.isUnit(other, thisUnit) and not noBleeds(other) then
            local life = unit.ttd(other)
            local needsRake = rakeUp and not debuff.rake.exists(other) and life > cl.rakeLife
            if spread then
                if needsRake then return other end
            else
                local needsRip = ripUp and not debuff.rip.exists(other) and life >= 8
                if (needsRake or needsRip) and (not cl.shred or (ripUp and life >= 12)) then return other end
            end
        end
    end
    return nil
end

-- Action List - Cat Form
actionList.CatForm = function()
    local thisUnit = dyn5
    local ttd = unit.ttd(thisUnit)
    local behind = unit.isBehind(thisUnit, "player") and not unit.facing(thisUnit, "player")
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
    -- The talents wowsims/forever's Cat rotation picks its numbers by (d22130484, 2026-11-15): Blood Frenzy's rank,
    -- and Shredding Attacks. Untalented, Shred costs 60 Energy to Claw's 45, so Claw is the builder you pay for, even
    -- from behind (a Clearcasting Shred is free either way); so too before Shred is learned.
    local bloodFrenzy = talent.rank.bloodFrenzy
    local clawBuilds = talent.rank.shreddingAttacks == 0 or not spell.shred.known()
    -- Shifting Power (talent): 40 Energy for Mana, at or below the sim's ceiling for your Blood Frenzy rank (53
    -- without, 55 on one point, 50 on two; the game refuses it at full Energy). It costs 55% of base mana on an 8 sec
    -- cooldown (live build, was 16 sec in the beta), so it keeps back a heal and the shift back into Cat Form.
    local shiftingCeiling = bloodFrenzy == 0 and 53 or bloodFrenzy == 1 and 55 or 50
    if ui.checked("Shifting Power") and cast.able.shiftingPower() and energy <= shiftingCeiling and not buff.clearcasting.exists()
        and power.mana.affordable(cast.cost.shiftingPower(), healCost() + cast.cost.catForm())
    then
        if cast.shiftingPower() then
            ui.debug("Casting Shifting Power")
            return true
        end
    end

    -- Finishers, in the order of wowsims/forever's Cat rotation (2026-11-08, master 125e53455)
    local ripUp = debuff.rip.exists(thisUnit)
    -- A mob that has shown immune to your bleeds (unit.bleedImmune: five in a row never showed), or a totem
    -- (noBleeds): no Rake or Rip, and Ferocious Bite is the finisher, as when a Rip wouldn't pay off
    local bleedImmune = noBleeds(thisUnit)
    -- Fight left for a new Rip to pay off: 8 sec (the sim's), 6 before Ferocious Bite is learned (Forever's own 1328618 was in the spellbook at 24), while Rip is the only
    -- finisher (2026-11-07, level 20: fights of 11-19 sec ended on 5 unspent combo points)
    local ripTime = spell.ferociousBite.known() and 8 or 6
    -- Ferocious Bite spends all your Energy unless Predatory Discipline (talent) keeps it, so without the talent it goes
    -- out only at the end of the fight: in the last second on 2+ combo points, or once a Rip wouldn't pay off, on 5
    -- and at most 55 Energy (more goes on a builder first)
    -- and at most 55 Energy (more goes on a builder first). In a cleave the sim's combo points for it (cleaveRules).
    local keepsBiteEnergy = spell.predatoryDiscipline.known()
    local cl = cleave and cleaveRules(#cleave, bloodFrenzy, clawBuilds) or nil
    if cast.able.ferociousBite(thisUnit) and ((ttd <= 1 and comboPoints >= 2)
        or ((ttd < ripTime or bleedImmune) and comboPoints >= (cl and cl.biteCP or 5) and (keepsBiteEnergy or energy <= 55)))
    then
        if cast.ferociousBite(thisUnit) then
            ui.debug("Casting Ferocious Bite [Fight End]")
            return true
        end
    end
    -- Cleave: move to another enemy in the pack for its Rake (or Rip) when the sim would (cleaveSwitch); the switch
    -- holds next ticks (var.cleavePick) and the list runs again on it now
    if cl and not switching then
        local other = cleaveSwitch(thisUnit, cl, ttd)
        if other then
            ui.debug("Cleave: switching to " .. unit.name(other))
            var.cleavePick, dyn5 = other, other
            comboPoints = power.comboPoints(other)
            switching = true
            local acted = actionList.CatForm()
            switching = false
            return acted
        end
    end
    -- With Predatory Discipline, Bite mid-fight while Rip has time left, at the sim's Energy for your talents and
    -- combo points (biteEnergy). Builders pool for it meanwhile. In a cleave, only on the talents the sim Bites
    -- with there (cleaveRules: Shred with two Blood Frenzy points, or three enemies without two points).
    local poolForBite = false
    local biteNeed, biteRip
    if not cl then
        biteNeed = biteEnergy(comboPoints, buff.clearcasting.exists(), bloodFrenzy, clawBuilds)
        biteRip = biteRipLeft(bloodFrenzy, clawBuilds, ttd)
    elseif cl.bite then
        biteNeed, biteRip = buff.clearcasting.exists() and cl.bite[2] or cl.bite[1], cl.bite[3]
    end
    if keepsBiteEnergy and biteNeed and comboPoints >= 4
        and ((ripUp and debuff.rip.remain(thisUnit) >= biteRip) or bleedImmune)
    then
        local need = biteNeed
        if energy >= need and cast.able.ferociousBite(thisUnit) then
            if cast.ferociousBite(thisUnit) then
                ui.debug("Casting Ferocious Bite [Predatory Discipline]")
                return true
            end
        end
        poolForBite = true
    end
    -- Clearcasting: the free hit goes on Shred, ahead of the bleeds (the sim's order)
    if freeDPS and not poolForBite and behind and cast.able.shred(thisUnit) then
        if cast.shred(thisUnit) then
            ui.debug("Casting Shred [Clearcasting]")
            return true
        end
    end
    -- Rip (Rend and Tear) once it's gone, at 4 combo points: on Forever its attack power part counts 4 at most, so a
    -- 5th adds only a little base damage. Without Blood Frenzy, or on two points with Shifting Power, a 5th is built
    -- first when one more paid builder and Rip right after it fit in the Energy there plus a tick's 10 (the sim's
    -- rule; Shred from the front can't land, so then Rip goes at 4). Recast only once gone: no Pandemic on Forever, a
    -- recast throws the ticks left away (Druid-TBC's rule; the same measured for Rejuvenation, 2026-11-05).
    -- In a cleave on the sim's fewer combo points (cleaveRules: 2-4), with no 5th.
    if not ripUp and not bleedImmune and ttd > ripTime and comboPoints >= (cl and cl.ripCP or 4) and cast.able.rip(thisUnit) then
        local buildsFifth = not cl and (bloodFrenzy == 0 or (bloodFrenzy >= 2 and spell.shiftingPower.known()))
        local builder = clawBuilds and "claw" or (behind and "shred") or nil
        local oneMore = buildsFifth and builder ~= nil and comboPoints < 5 and ttd >= ripTime + 1
            and cast.able[builder](thisUnit) and energy + 10 >= cast.cost[builder]() + cast.cost.rip()
        if not oneMore and cast.rip(thisUnit) then
            ui.debug(("Casting Rip [%d combo points]"):format(comboPoints))
            return true
        end
    end
    -- Before Ferocious Bite Rip is the only finisher: with its last tick due, hold the combo points for the
    -- recast rather than build past 5 (not near the Energy cap, which the wait would waste)
    if comboPoints == 5 and not spell.ferociousBite.known() and ttd > ripTime + 2 and energy < 80
        and ripUp and debuff.rip.remain(thisUnit) < 2
    then
        return false
    end

    -- Combo Point Builders
    -- Ravage (from Prowl)
    if buff.prowl.exists() and behind and cast.able.ravage(thisUnit) then
        if cast.ravage(thisUnit) then
            ui.debug("Casting Ravage")
            return true
        end
    end
    -- Rake: keep a bleed up on anything that lives long enough (Rend and Tear: 6 sec, in a cleave cleaveRules' 4-6);
    -- recast once it's gone (see Rip)
    if cast.able.rake(thisUnit) and not debuff.rake.exists(thisUnit) and ttd > (cl and cl.rakeLife or 6) and not bleedImmune then
        if cast.rake(thisUnit) then
            ui.debug("Casting Rake")
            return true
        end
    end
    if poolForBite then return false end -- Energy kept for the Predatory Discipline Bite
    -- Swipe (multi-target)
    if cast.able.swipeCat() and ui.useAOE(8, 3) then
        if cast.swipeCat() then
            ui.debug("Casting Swipe")
            return true
        end
    end
    -- The paid builder: Claw without Shredding Attacks (clawBuilds), else Shred from behind; held to pool Energy once
    -- the combo points are nearly there (paidBuilderFits; in a cleave only at 5, below cleaveRules' Energy)
    if paidBuilderFits(comboPoints, bloodFrenzy, cl) then
        if clawBuilds and cast.able.claw(thisUnit) then
            if cast.claw(thisUnit) then
                ui.debug("Casting Claw")
                return true
            end
        end
        if not clawBuilds and behind and cast.able.shred(thisUnit) then
            if cast.shred(thisUnit) then
                ui.debug("Casting Shred")
                return true
            end
        end
    end
    -- Claw where Shred can't land (in front of the target), once there's the Energy Shred would cost (the sim's)
    if not clawBuilds and not behind and energy >= cast.cost.shred() and cast.able.claw(thisUnit) then
        if cast.claw(thisUnit) then
            ui.debug("Casting Claw [In Front]")
            return true
        end
    end
end -- End Action List - Cat Form

-- Action List - Caster Form (and Moonkin Form)
actionList.CasterForm = function()
    -- Left Bear or Cat for your target (out of reach, fleeing, or the flee wait): that one, never BR's own pick, and
    -- every spell at it. Starfire and Wrath went out with no unit, so BR picked one: a Hillsbrad Farmer 22.7 yd off
    -- that wasn't fighting you, pulled while finishing a fleeing Peasant (2026-11-08 15:43:47)
    local thisUnit = var.rangeTarget and "target" or dyn30
    local ttd = unit.ttd(thisUnit)
    -- Hurricane: no cooldown on Forever; channel it into a pack. Not while finishing your target from range (it lands
    -- where the most enemies are, fighting or not)
    local why = ui.checked("Hurricane") and not var.rangeTarget and not unit.moving() and spendOnDamage("hurricane", thisUnit)
    if why and cast.able.hurricane.ground(8, ui.value("Hurricane")) then
        if cast.hurricane.ground(8, ui.value("Hurricane")) then
            ui.debug("Casting Hurricane" .. tag(why))
            return true
        end
    end
    -- Moonfire: 12 sec DoT, where it pays off, or while moving. Recast only once it's gone (no Pandemic: a refresh
    -- throws its last tick away; wowsims/forever's rule too)
    if cast.able.moonfire(thisUnit) and not debuff.moonfire.exists(thisUnit) and (ttd > 9 or unit.moving()) then
        why = spendOnDamage("moonfire", thisUnit)
        if why and cast.moonfire(thisUnit) then
            ui.debug("Casting Moonfire" .. tag(why))
            return true
        end
    end
    -- Insect Swarm (talent), recast once it's gone (see Moonfire)
    if cast.able.insectSwarm(thisUnit) and not debuff.insectSwarm.exists(thisUnit) and (ttd > 9 or unit.moving()) then
        why = spendOnDamage("insectSwarm", thisUnit)
        if why and cast.insectSwarm(thisUnit) then
            ui.debug("Casting Insect Swarm" .. tag(why))
            return true
        end
    end
    if unit.moving() then return false end
    -- Starfire: the main nuke. Wrath first to build Eclipse when it has no charges (Eclipse talent),
    -- and Starfire straight away with Eclipse or Clearcasting (which Wrath can't spend).
    local starfireTime = cast.time.starfire() -- the game's: Improved Starfire, Eclipse ranks and haste included
    -- A Starfire already casting takes the last Eclipse stack, so another one queued behind it builds first (the sim's guard)
    local eclipseLeft = buff.eclipse.exists() and not (cast.current.starfire() and buff.eclipse.stack() <= 1)
    local buildEclipse = spell.eclipse.known() and not eclipseLeft and not freeDPS
    if cast.able.starfire(thisUnit) and not buildEclipse and ttd > starfireTime then
        why = spendOnDamage("starfire", thisUnit)
        if why and cast.starfire(thisUnit) then
            ui.debug("Casting Starfire" .. tag(why))
            return true
        end
    end
    -- A target that dies before Wrath would land: finish it with instant Moonfire, else start nothing. Wrath on a
    -- dying target was the most common lost cast (Fights 2026-11-05: 51 in 90 fights, "Interrupted" or "target is
    -- dead"). ttd 999 is unknown, which doesn't count as dying. Not while your Moonfire is on it: its damage over
    -- time keeps hitting (Fights 2026-11-05 20:35: a second finisher on a cougar that lived 4.5 s more, the
    -- fight ended on 10 mana).
    if ttd < 999 and ttd < cast.time.wrath() + 0.2 then
        if cast.able.moonfire(thisUnit) and not debuff.moonfire.exists(thisUnit) then
            if cast.moonfire(thisUnit) then
                ui.debug("Casting Moonfire [Finish]")
                return true
            end
        end
        return false
    end
    -- Wrath: Eclipse builder and filler (cheap 2 sec cast, also when Starfire wouldn't land in time)
    if cast.able.wrath(thisUnit) then
        why = spendOnDamage("wrath", thisUnit)
        if why and cast.wrath(thisUnit) then
            ui.debug("Casting Wrath" .. tag(why))
            return true
        end
    end
end -- End Action List - Caster Form

-- Yards outside the nearest aggro radius at which Prowl goes up, and how near a neutral or tagged target first (see PreCombat)
local PROWL_LEAD, PROWL_NEUTRAL = 1, 8
-- True while the gap to thisUnit is shrinking (you closing in, or it walking at you), from one rotation tick to
-- the next: a mob you walk away from or past at the same distance doesn't need Prowl. Asked twice in a tick (the
-- aggro check and the quiet-target check both ask about your target), the second gets the first's answer
local function closingOn(thisUnit)
    local guid = unit.guid(thisUnit)
    if guid == nil then return false end
    local gaps = var.prowlGaps
    if gaps == nil or gaps.n > 200 then gaps = { n = 0 } var.prowlGaps = gaps end
    local now, dist = util.time(), unit.distance(thisUnit) or 99
    local last = gaps[guid]
    if last ~= nil and last.at == now then return last.closing end
    if last == nil then gaps.n = gaps.n + 1 end
    local closing = last ~= nil and now - last.at < 1 and dist < last.dist - 0.05
    gaps[guid] = { dist = dist, at = now, closing = closing }
    return closing
end

-- A neutral or tagged mob (someone else's) doesn't notice you coming: no aggro radius to beat, so Prowl waits for the
-- last moment, PROWL_NEUTRAL yards, and only for your target while you close in on it, as in going to attack it (the
-- user's call, 2026-11-09)
local function prowlForQuietTarget()
    if not unit.exists("target") or not unit.canAttack("target") or unit.deadOrGhost("target") then return false end
    if not (unit.reaction("target") == 4 or unit.tapDenied("target")) then return false end
    return (unit.distance("target") or 99) < PROWL_NEUTRAL and closingOn("target")
end

-- Your target in melee range, out of combat, about to be attacked (the Cat Opener goes next): Prowl first whenever it
-- can go up, the gap closing or not, resting or not (the user's rule, 2026-11-15: "it should always prowl before
-- attacking if possible"). The rules below prowl only while a gap shrinks, so standing next to your target got none
-- (2026-11-14 17:43:54: Shred [Opener] on a Saltstone Gazer at 2.3 yd after 76 s out of combat). Not on a player (the
-- Cat Opener doesn't open on one). A Prowl sent for it that isn't up PROWL_RETRY seconds later (the game refused it)
-- isn't sent again for that target, so the opener isn't held off for good.
local PROWL_RETRY = 1.5
local function prowlBeforeAttack()
    if not unit.valid("target") or unit.deadOrGhost("target") or unit.player("target") then return false end
    if (unit.distance("target") or 99) >= 5 then return false end
    local sent = var.prowlBeforeAttack
    return not (sent and sent.guid == unit.guid("target") and util.time() - sent.at > PROWL_RETRY)
end

actionList.PreCombat = function()
    if unit.inCombat() or unit.flying() or unit.mounted() then return false end
    if buff.prowl.exists() then var.prowlBeforeAttack = nil end -- it went up: a later one is a new try
    if not (buff.prowl.exists() or buff.shadowmeld.exists()) and ui.mode.prowl == 1 and buff.catForm.exists()
        and cast.able.prowl("player") and prowlBeforeAttack()
    then
        local sent = var.prowlBeforeAttack
        if not (sent and sent.guid == unit.guid("target")) then
            var.prowlBeforeAttack = { guid = unit.guid("target"), at = util.time() }
        end
        if cast.prowl("player") then
            ui.debug("Casting Prowl [Before Attack]")
            return true
        end
    end
    -- The opener waits for that Prowl to show (up to PROWL_RETRY): the buff shows a moment after the send, and the
    -- tick in between opened unstealthed (2026-11-15 12:22:15: Prowl [Before Attack], Shred [Opener] 0.1 s later)
    local sent = var.prowlBeforeAttack
    if sent and not (buff.prowl.exists() or buff.shadowmeld.exists()) and ui.mode.prowl == 1 and buff.catForm.exists()
        and sent.guid == unit.guid("target") and util.time() - sent.at <= PROWL_RETRY
    then
        return true
    end
    -- Prowl: only just before a mob would notice you, PROWL_LEAD yards (about a rotation tick at a run) outside
    -- its aggro radius, since Prowl slows you; only a hostile mob the gap to is shrinking (closingOn). The radius
    -- is the server's (centre to centre, 18 yd +/- level, see unit:getAggroRange); BR used edge distance, 20 yd and
    -- a 2 yd lead, which prowled 5-8 yd early (the user's calls, 2026-11-08: "right before I would aggro with
    -- proximity"). Facing doesn't change proximity aggro, only what a mob sees through Prowl. Hostile untagged mobs
    -- only (unit.anyInAggroRange leaves tagged ones out): a neutral or tagged target gets Prowl at the last moment
    -- (prowlForQuietTarget) instead of slowing you all the way in from its aggro radius
    if not (buff.prowl.exists() or buff.shadowmeld.exists()) and ui.mode.prowl == 1 and buff.catForm.exists()
        and cast.able.prowl("player") and not unit.resting()
        and (unit.anyInAggroRange(PROWL_LEAD, 40, true, closingOn) or prowlForQuietTarget())
    then
        if cast.prowl("player") then
            ui.debug("Casting Prowl [Precombat]")
            return true
        end
    end
    if not unit.valid("target") then return false end
    local thisDistance = unit.distance("target") or 99
    -- Faerie Fire Pull: brings the target to you with the debuff already up (Bear or Caster Form)
    if ui.checked("Faerie Fire Pull") and (buff.bearForm.exists() or not inForm) and not buff.prowl.exists()
        and thisDistance < 30 and unit.enemy("target") and unit.readyToFight() and not unit.totem("target")
        and not debuff.faerieFire.exists("target", "any") and cast.able.faerieFire("target")
    then
        if cast.faerieFire("target") then
            ui.debug("Casting Faerie Fire [Pull]")
            return true
        end
    end
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
    if ui.checked("Feral Charge - Engage") and buff.bearForm.exists() and thisDistance >= CHARGE_MIN
        and thisDistance < CHARGE_MAX
    then
        local chargeKey = bearChargeKey()
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
            if cast.able.maul("target") and (ui.useST(8, 3) or not spell.swipe.known()) then
                if cast.maul("target") then
                    ui.debug("Casting Maul [Precombat]")
                    return true
                end
            end
        end
        -- Auto Attack (do not break Prowl). unit.startAttack() sends nothing while casting or just after a send, and
        -- then the rotation goes on (2026-11-05: three "Casting Auto Attack" ticks held back the next Wrath).
        if not buff.prowl.exists() and not cast.auto.autoAttack() and not unit.deadOrGhost("target") and unit.startAttack() then
            ui.debug("Casting Auto Attack [Precombat]")
            return true
        end
    end
end -- End Action List - PreCombat

-- The opening hit on your target is still to come: nothing of yours has landed on it yet (no combo points, no Rake
-- or Rip of yours) and no opener went out at it. However the fight started (from Prowl, a Feral Charge, a mob running
-- at you), the first hit is the Cat Opener's pick for where you stand, ahead of Faerie Fire (the user's call,
-- 2026-11-11: 17 of 17 charged pulls opened with Faerie Fire or Rake, then Claw).
local function openerPending()
    local guid = unit.guid("target")
    if guid == nil then return false end
    -- your target's combo points, not BR's melee pick's (comboPoints): the pick may be another mob
    if var.openedGUID ~= guid and (power.comboPoints("target") > 0 or debuff.rake.exists("target") or debuff.rip.exists("target")) then
        var.openedGUID = guid
    end
    return var.openedGUID ~= guid
end

-- Action List - Combat
actionList.Combat = function()
    -- Your target, or BR's pick when your target isn't an enemy it can hit (Targeting Mode Assist leaves a friendly
    -- you targeted to invite, or a mob at range, selected: 2026-11-11, the user). The Cat, Bear and Caster lists
    -- already fight BR's picks (units.dyn5, units.dyn30AOE); spells written for "target" stay with your target.
    if not (unit.inCombat() and (unit.valid("target") or unit.exists(dyn5) or unit.exists(dyn30))) then
        return false
    end
    local inMelee = unit.exists(dyn5) and unit.distance(dyn5) < 5
    -- Start Attack (do not break Prowl) on the melee pick, your target or not; when unit.startAttack() sends nothing
    -- yet (already swinging at it, or just after a send), the rotation goes on (see PreCombat)
    if not buff.prowl.exists() and unit.exists(dyn5) and not unit.deadOrGhost(dyn5)
        and unit.startAttack(dyn5)
    then
        ui.debug("Casting Auto Attack")
        return true
    end
    -- Out of the toggle's Cat or Bear Form without the mana to shift back: swing at the target while the mana comes
    -- back. The auto attack above waits for a melee pick (2026-11-08 13:27: your own Healing Touch left 29 mana, 5 s
    -- idle with a Dalaran Wizard at 5.6 yd and no auto attack)
    local formKey = (activeForm == "cat" and "catForm") or (activeForm == "bear" and "bearForm") or nil
    local swingAt = unit.exists(dyn5) and dyn5
        or (unit.valid("target") and (unit.distance("target") or 99) < 8 and "target") or nil
    if formKey and swingAt and not inForm and not buff.moonkinForm.exists() and not buff.prowl.exists()
        and spell[formKey].known() and not power.mana.affordable(cast.cost[formKey]()) and not cast.auto.autoAttack()
        and not unit.deadOrGhost(swingAt) and unit.startAttack(swingAt)
    then
        ui.debug("Casting Auto Attack [no mana to shift]")
        return true
    end
    -- Call Action List - Interrupts
    if actionList.Interrupts() then return true end
    -- Call Action List - Cooldowns
    if actionList.Cooldowns() then return true end
    -- Feral Charge (Cat): leap behind the target to get into melee (and behind it). Its own spell, Feral Charge (Cat):
    -- the talent's ID is the Bear Form charge, which the game refuses in Cat Form (2026-11-08: never sent in Cat)
    if catChargeReady("target") then
        if cast.feralChargeCat("target") then
            ui.debug("Casting Feral Charge (Cat)")
            return true
        end
    end
    -- Feral Charge (Bear) to engage
    if ui.checked("Feral Charge - Engage") and buff.bearForm.exists()
        and unit.distance("target") >= CHARGE_MIN and unit.distance("target") < CHARGE_MAX
    then
        local chargeKey = bearChargeKey()
        if cast.able[chargeKey]("target") and cast[chargeKey]("target") then
            ui.debug("Casting Feral Charge")
            return true
        end
    end
    -- A totem dies to a white hit or two: the auto attack above takes it, no Energy or Rage on it (a combo point on it
    -- goes with it). 2026-11-13 fight 31: Shred [Opener] on a 5-health Magma Totem.
    local targetTotem = unit.totem("target")
    local meleeTotem = inMelee and unit.totem(dyn5)
    -- Cat Opener out of Prowl: the first hit on a new target, ahead of Faerie Fire (see openerPending)
    if activeForm == "cat" and buff.catForm.exists() and inMelee and not targetTotem and not buff.prowl.exists() and openerPending() then
        if actionList.CatOpener() then
            var.openedGUID = unit.guid("target")
            return true
        end
        if var.openerHold then return true end
    end
    -- Faerie Fire: castable in every form on Forever, and it doesn't stack, so anyone's counts. Target
    -- only: the armor loss helps the damage you deal to that unit, and each cast costs a GCD and mana.
    -- In Cat/Bear the mana is what heals and shifting back need, so it keeps a reserve. Never from Prowl, nor on a
    -- totem: nothing damages it, so its ttd reads 999 (2026-11-09 fight 105: 5 casts on a Strength of Earth Totem).
    if ui.checked("Faerie Fire") and (not inForm or mana >= ui.value("Faerie Fire")) and not buff.prowl.exists()
        and not unit.totem("target") and unit.ttd("target") > 10 and not debuff.faerieFire.exists("target", "any") and cast.able.faerieFire("target")
    then
        if cast.faerieFire("target") then
            ui.debug("Casting Faerie Fire")
            return true
        end
    end
    -- Call Action List - Bear Form
    if activeForm == "bear" and buff.bearForm.exists() and inMelee and not meleeTotem then
        if ui.checked("Bear Opener") and actionList.BearOpener() then return true end
        if actionList.BearForm() then return true end
        -- Faerie Fire filler: when the Bear list had nothing to do, the other enemies Swipe hits (lower
        -- armor means more Swipe damage and threat), above the mana reserve
        if ui.checked("Faerie Fire") and mana >= ui.value("Faerie Fire") and spell.swipe.known() and #enemies.yards8 > 1 then
            local thisUnit = enemies.first(enemies.yards8, faerieFireFiller)
            if thisUnit ~= nil and cast.faerieFire(thisUnit) then
                ui.debug("Casting Faerie Fire [Filler]")
                return true
            end
        end
    end
    -- Call Action List - Cat Form
    if activeForm == "cat" and buff.catForm.exists() and inMelee and not meleeTotem then
        -- While prowled only the Cat Opener runs, on your target; the Cat list never does (as Druid-TBC): it yields and
        -- tries again next tick, so you keep Prowl until the opener's hit
        if buff.prowl.exists() then
            if not targetTotem and actionList.CatOpener() then return true end
            return true
        end
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
    energy      = power.energy()
    mana        = power.mana.percent()
    rage        = power.rage()
    -- General Locals
    haltProfile = ui.pause() or ui.mode.rotation == 4
    -- Units
    units.get(5)        -- Makes a variable called, units.dyn5
    units.get(30, true) -- Makes a variable called, units.dyn30AOE (Forever caster range)
    -- Out of combat or in Prowl, attacks go only to your target; BR's picks of other mobs wait until you're in combat
    -- and out of Prowl (the user's rule, 2026-11-14, as Druid-TBC: PreCombat and the Prowl opener act on "target"
    -- only). 2026-11-14 RFK: walking through a pack in Prowl, the Cat list Ravaged a Razorfen Defender you passed
    -- while your target stood 18 yd away.
    targetOnly = not unit.inCombat() or buff.prowl.exists()
    dyn5, dyn30 = units.dyn5, units.dyn30AOE
    if targetOnly then
        local valid = unit.valid("target") and not unit.deadOrGhost("target")
        local targetDistance = valid and unit.distance("target") or 99
        dyn5 = valid and targetDistance < 5 and "target" or nil
        dyn30 = valid and targetDistance < 30 and "target" or nil
    end
    -- Enemies
    enemies.get(5)      -- Makes a variable called, enemies.yards5
    enemies.get(5, "player", false, true)  -- makes enemies.yards5f
    enemies.get(8)      -- Makes a variable called, enemies.yards8
    enemies.get(10)     -- Makes a variable called, enemies.yards10
    enemies.get(30)     -- Makes a variable called, enemies.yards30
    -- Cat cleave (wowsims/forever d22130484): 2 or 3 enemies fighting you in melee, in Cat Form, in combat out of
    -- Prowl, while BR may pick enemies other than your target (Targeting Mode). The Cat list's move to one of them
    -- (var.cleavePick, cleaveSwitch) is the melee pick while it stays one of them.
    cleave = nil
    if not targetOnly and buff.catForm.exists() and units.picking() then
        local pack = cleavePack()
        if #pack == 2 or #pack == 3 then cleave = pack end
    end
    local pick = var.cleavePick
    var.cleavePick = nil
    for i = 1, cleave and #cleave or 0 do
        if pick ~= nil and unit.isUnit(cleave[i], pick) then
            var.cleavePick, dyn5 = cleave[i], cleave[i]
            break
        end
    end
    -- Combo points sit on the unit they were built on (Forever): the melee pick's, your target or not
    comboPoints = power.comboPoints(dyn5 or "target")

    -- The form the Forms toggle picks, and whether a form that blocks caster spells is up
    activeForm = resolveForm()
    inForm = buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.aquaticForm.exists()
    -- Out of combat on the move in Travel or Aquatic Form (casterCast waits for you to stop). The Travel Form BR left
    -- (var.travelBack) is forgotten in combat, mounted, once you're in another form (yours or the toggle's), or when
    -- Forms shifts back into Travel (not on Travel Form showing: it still shows for a round trip after the cancel)
    travelling = not unit.inCombat() and unit.moving() and (buff.travelForm.exists() or buff.aquaticForm.exists())
    if unit.inCombat() or unit.mounted() or buff.catForm.exists() or buff.bearForm.exists()
        or buff.moonkinForm.exists() or buff.aquaticForm.exists()
    then
        var.travelBack = nil
    end

    -- Heals on others (healOther) only while the Heal Others Key is held, when one is set
    var.healOthersKey = ui.dropOptions.Toggle[ui.value("Heal Others Key")] == "None" or ui.toggleKey("Heal Others Key")

    -- Clearcasting Use: 1 Any, 2 DPS Only, 3 Healing Only, 4 None
    local omenSetting = ui.value("Clearcasting Use")
    local needsHealing = (ui.checked("Regrowth") and unit.hpAfterHeals() <= ui.value("Regrowth"))
        or (ui.checked("Healing Touch") and unit.hpAfterHeals() <= ui.value("Healing Touch"))
        or (ui.checked("Rejuvenation") and unit.hpAfterHeals() <= ui.value("Rejuvenation"))
    freeDPS = (omenSetting == 1 or omenSetting == 2) and buff.clearcasting.exists()
        and (not needsHealing or omenSetting == 2)
    freeHeal = (omenSetting == 1 or omenSetting == 3) and buff.clearcasting.exists()

    -- A target out of reach (a ledge or pillar, see outOfReach) hands Bear or Cat over to Caster Form on any Forms setting (2026-11-08 10:35: 19 s idle in
    -- Cat at full Energy, a Bristleback Thornweaver casting from 20 yd); a fleeing one only on Auto: Cat or Bear
    -- picked on the toggle stays in form and chases (Feral Charge (Cat) in Combat closes 8-25 yd) (the user's calls,
    -- 2026-11-08: "don't like breaking form (when toggled to cat) to cast on fleeing mobs")
    local meleeForm = activeForm == "bear" or activeForm == "cat"
    local fleeForm = ui.mode.forms == 1 and meleeForm
    if not meleeForm then var.reach = nil end
    if not fleeForm then var.flee = nil end
    -- Out of reach (see outOfReach): Bear or Cat hands over to Caster Form while nothing is in melee with you and
    -- mana may go on Wrath or Moonfire; back to the toggle's form once the target comes near
    local reachDist, reachRise
    if meleeForm and #enemies.yards5 == 0 then reachDist, reachRise = outOfReach("target") end
    local reachSwap = false
    if reachDist and (spendOnDamage("wrath", "target") or spendOnDamage("moonfire", "target")) then
        activeForm = casterForm()
        reachSwap = true
        if not var.reachSaid then
            ui.debug(("Out of reach: %s %.0f yd, %.0f yd up or down, no closer in %d s of moving, fighting from range"):format(
                unit.name("target") or "target", reachDist, reachRise or 0, REACH_WAIT))
            var.reachSaid = true
        end
    elseif var.reachSaid then
        ui.debug("Back in reach")
        var.reachSaid = nil
    end
    -- A fleeing target (see fleeChase): out of Cat or Bear while no other enemy is in melee with you. Cat runs at a
    -- fleeing mob's speed and doesn't catch it (2026-11-08 12:34 and 12:37: Wrathtail Wave Riders 5-6.5 yd ahead for
    -- 6-7 s, one lost at 29 yd), so as a player would: Feral Charge (Cat) once it's 8+ yd ahead, else finish it from
    -- range (the user's call, 2026-11-08)
    var.fleeChase = false
    local fleeWaiting = false
    if fleeForm and not reachDist then
        local othersInMelee = false
        for i = 1, #enemies.yards5 do
            if not unit.isUnit(enemies.yards5[i], "target") then othersInMelee = true break end
        end
        local chase, waiting = fleeChase("target")
        -- Feral Charge (Cat) can reach it: the charge (Combat) goes first, staying in Cat, and the wait starts over (a
        -- finished wait otherwise holds for that target, and would shift out right after the charge landed)
        if chase and activeForm == "cat" and catChargeReady("target") then
            chase, waiting, var.flee = false, false, nil
        end
        local mana = (chase or waiting) and (spendOnDamage("moonfire", "target") or spendOnDamage("wrath", "target"))
        var.fleeChase = not othersInMelee and chase and mana and true or false
        -- Already out of form (a heal, say) while the wait runs: stay out rather than shift to Bear and straight
        -- back (2026-11-07 15:56:00: Bear Form, Caster Form 0.8 s later, Bear again when it died: three shifts)
        fleeWaiting = not othersInMelee and waiting and mana and not buff.bearForm.exists() and not buff.catForm.exists()
    end
    if fleeWaiting then activeForm = casterForm() end
    -- Caster Form is fighting your target from range for a Bear or Cat player: the Caster list sticks to it
    var.rangeTarget = reachSwap or fleeWaiting or var.fleeChase or false
    if var.fleeChase then
        activeForm = casterForm()
        if var.fleeSaid ~= var.flee.guid then
            ui.debug(("Fleeing: %s %.0f yd, out of melee for %d s, finishing it from range"):format(
                unit.name("target") or "target", unit.distance("target"), FLEE_WAIT))
            var.fleeSaid = var.flee.guid
        end
    end

    -- Low on Energy/Rage, so leaving Cat or Bear Form to heal doesn't waste much
    noShapeshiftPower = ((not buff.catForm.exists() or energy < ui.value("Break Form for Heals Below Energy"))
        and (not buff.bearForm.exists() or rage < ui.value("Break Form for Heals Below Rage")))
        or not unit.inCombat()

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Pause
    if haltProfile then
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
registerRotation({
    name      = "CuteOne",
    specID    = 1484, -- Forever Druid class-level spec ID.
    expansion = "Forever",
    author    = "CuteOne",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})
