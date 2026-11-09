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
    ui.dropdown(section, "Mark of the Wild", { choices = { "Player", "Target", "Mouseover", "Focus", "Group" }, checked = true,
        tip = "Set how to use Mark of the Wild" })
    ui.dropdown(section, "Thorns", { choices = { "Player", "Target", "Mouseover", "Focus", "Group" }, checked = true,
        tip = "Set how to use Thorns" })

    section = ui.section("Defensive")
    ui.checkbox(section, "Self Heal In Group", { checked = true, tip = "Enable/Disable Healing Self while Grouped" })
    ui.dropdown(section, "Heal Others", { choices = { "Player", "Target", "Mouseover", "Focus" }, checkbox = false,
        tip = "Besides yourself, also heal this friendly player with the heals below (Player: only yourself)" })
    ui.dropdown(section, "Heal Others Key", { choices = "Toggle", value = "None", checkbox = false,
        tip = "Only heal the Heal Others unit while this key is held (None: no key needed)" })
    ui.spinner(section, "Healing Touch", { value = 35, checked = true, tip = "Health Percent to Cast At" })
    ui.checkbox(section, "Nature's Swiftness", { checked = true, tip = "Make an emergency Healing Touch instant with Nature's Swiftness (talent)" })
    ui.spinner(section, "Regrowth", { value = 55, checked = true, tip = "Health Percent to Cast At (Swiftmend first when a heal over time is on you)" })
    ui.spinner(section, "Rejuvenation", { value = 70, checked = true, tip = "Health Percent to Cast At" })
    ui.spinner(section, "Barkskin", { value = 65, checked = true, tip = "Health Percent to Cast At" })
    ui.spinner(section, "Frenzied Regeneration", { value = 45, checked = true, tip = "Health Percent to Cast At (Bear Form)" })
    ui.spinner(section, "Bash", { value = 35, tip = "Health Percent to stun your target at (Bear Form)" })
    ui.checkbox(section, "Cure Poison", { checked = true, tip = "Cure poisons on yourself (uses Abolish Poison once learned). In combat only while already out of Cat or Bear Form (for a heal, say)" })
    ui.checkbox(section, "Remove Curse", { checked = true, tip = "Remove curses on yourself out of combat" })
    ui.checkbox(section, "Entangling Roots", { tip = "Entangling Roots on fleeing enemies, only when already out of Cat or Bear Form (a fleeing target Cat or Bear can't catch is finished from range)" })
    ui.spinner(section, "Nature's Grasp", { value = 40,
        tip = "Escape tool: cast at or below this Health Percent while running from an enemy chasing you within 10 yards. The root breaks on damage, so it's meant for fleeing, not fighting." })
    ui.spinner(section, "Dash", { value = 40, tip = "Escape tool: Dash in Cat Form at or below this Health Percent while running from an enemy chasing you" })

    section = ui.section("Group")
    ui.checkbox(section, "Revive", { checked = true, tip = "Revive dead party members out of combat" })
    ui.dropdown(section, "Rebirth", { choices = { "Tank", "Healer", "Tank or Healer", "Anyone" }, value = "Tank or Healer",
        tip = "Who to Rebirth in combat" })

    section = ui.section("Interrupts")
    ui.checkbox(section, "Bash - Int", { checked = true, tip = "Interrupt with Bash while in Bear Form" })
    ui.checkbox(section, "Bash - Shift to Bear", { tip = "Allow leaving Cat/Caster Form to Bash (costs Mana and your Energy)" })
    ui.checkbox(section, "Feral Charge - Int", { checked = true, tip = "Interrupt with Feral Charge (Bear) from 8-25 yards" })
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percent to Cast At (0 is random)" })

    section = ui.section("Druid Debug")
    ui.checkbox(section, "Behind Debug", { tip = "Debug behind/facing checks for Shred/Ravage." })
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

    -- The whole front half (180 degree cone)
    local facing180 = unit.facing(thisUnit, "player", 180)

    ui.debug(string.format(
        "%s | unit=%s (isTarget=%s, dist=%.1f) | target=%s | facingPlayer=%s | behindPlayer=%s | facing180=%s",
        tostring(label), tostring(thisName), tostring(isTarget), tonumber(dist) or -1, tostring(targetName),
        tostring(facingPlayer), tostring(behindPlayer), tostring(facing180)
    ))
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

-- Gift of the Wild is a differently named aura, so buff.markOfTheWild misses it and a recast
-- fails with "A more powerful spell is already active". Treat it as satisfying Mark of the Wild.
local function needsMarkOfTheWild(thisUnit)
    if buff.giftOfTheWild.exists(thisUnit) and not buff.giftOfTheWild.refresh(thisUnit) then return false end
    return buff.markOfTheWild.refresh(thisUnit)
end

-- Casts a Caster Form spell, leaving the current form first when it blocks the spell: Cat, Bear,
-- Travel and Aquatic Form block every caster spell, Moonkin Form blocks heals. free: Clearcasting
-- makes the spell free; emergency: leave the form even when shifting back isn't affordable.
-- A form left for a heal is held off (see Forms) until the heal goes out or HEAL_SHIFT_HOLD passes.
local HEAL_SHIFT_HOLD = 1.5
local function casterCast(spellKey, thisUnit, label, free, emergency, isHeal)
    if inForm or (isHeal and buff.moonkinForm.exists()) then
        local left = unit.cancelFormFor(spell[spellKey], free, emergency)
        if left and isHeal then var.leftFormForHealAt = util.time() end
        return left
    end
    if cast[spellKey](thisUnit) then
        if isHeal then var.leftFormForHealAt = nil end
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
    if ui.dropOptions.Toggle[ui.value("Heal Others Key")] ~= "None" and not ui.toggleKey("Heal Others Key") then return nil end
    if unit.exists(thisUnit) and unit.friend(thisUnit) and unit.player(thisUnit) and not unit.deadOrGhost(thisUnit)
        and not unit.isUnit(thisUnit, "player") and unit.distance(thisUnit) < 40
    then
        return thisUnit
    end
    return nil
end

-- A Beast or Dragonkin fighting the player that isn't the target (Hibernate)
-- Bear filler: another enemy in Swipe's reach without Faerie Fire that will live long enough to matter
local function faerieFireFiller(thisUnit)
    return not unit.isUnit(thisUnit, "target") and unit.ttd(thisUnit) > 10
        and not debuff.faerieFire.exists(thisUnit, "any") and cast.able.faerieFire(thisUnit)
end

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

-- Nothing in this fight threatens you: 60%+ health, one enemy at most on you, and you're winning
local function unthreatened(thisUnit)
    return thisUnit ~= nil and unit.hp() >= 60 and #enemies.yards8 <= 1 and unit.winning(thisUnit)
end

-- The fight is going badly; says why (for the debug line), nil when it isn't
local function pressed(thisUnit)
    if #enemies.yards8 >= 2 then return #enemies.yards8 .. " enemies on you" end
    if unit.hp() < 50 then return ("health %d%%"):format(unit.hp()) end
    if thisUnit ~= nil and unit.losing(thisUnit) then return "losing" end
end

-- Mana may go on this damage spell, by Mana Use. Returns why ("mana 64%", "2 enemies on you", "free", "safe"), shown
-- in the cast's debug line, or nil to hold it
local function spendOnDamage(spellKey, thisUnit)
    if freeDPS then return "free" end
    local percent = power.mana.percent()
    local manaWhy = ("mana %d%%"):format(percent)
    if ui.value("Mana Use") == MANA_BURN and unthreatened(thisUnit) then return "safe" end
    if not power.mana.affordable(cast.cost[spellKey](), healCost()) then return nil end
    if ui.value("Mana Use") == MANA_CONSERVE and thisUnit ~= nil and unit.distance(thisUnit) < 5 then
        local why = pressed(thisUnit)
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
    if f == nil or f.guid ~= guid then
        var.flee = { guid = guid, since = now }
        return false, true
    end
    f.out = now - f.since >= FLEE_WAIT
    return f.out, not f.out
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Buffs
actionList.Buffs = function()
    if unit.inCombat() or unit.resting() then return false end
    -- Mark of the Wild
    if ui.checked("Mark of the Wild") then
        var.markUnit = units.buffUnit("Mark of the Wild", needsMarkOfTheWild, 30)
        if cast.able.markOfTheWild(var.markUnit) and needsMarkOfTheWild(var.markUnit)
            and unit.distance(var.markUnit) < 30 and (var.markUnit == "player" or unit.player(var.markUnit))
        then
            if casterCast("markOfTheWild", var.markUnit, "Mark of the Wild") then return true end
        end
    end
    -- Thorns
    if ui.checked("Thorns") then
        var.thornUnit = units.buffUnit("Thorns", buff.thorns.refresh, 30)
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
    -- Just left a form for a heal that hasn't gone out yet (held by BR's cast timer, say): wait for it rather than
    -- shift straight back (Form.log 2026-11-05 22:19 and 2026-11-06 19:30: Rejuvenation not cast, Bear Form 0.27 s
    -- later, two shifts' mana for nothing)
    if var.leftFormForHealAt and util.time() - var.leftFormForHealAt < HEAL_SHIFT_HOLD then return false end
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
        -- Only on a target that outlives the root and a Wrath after it, with a heal's mana kept (2026-11-05: 3 of 3
        -- Roots on fleeing centaurs failed, two on targets the Wrath already in flight killed; 50 mana each).
        -- Only when already out of form: Cat and Bear (Auto) leave for a fleeing mob themselves (fleeChase)
        if ui.checked("Entangling Roots") and not inForm and cast.able.entanglingRoots("target") and unit.isFleeing("target")
            and unit.valid("target") and unit.hp("target") < 100 and not debuff.entanglingRoots.exists("target")
            and unit.distance("target") > 8 and not unit.moving()
            and unit.livesFor("target", cast.time.entanglingRoots() + cast.time.wrath())
            and power.mana.affordable(cast.cost.entanglingRoots(), healCost())
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
            and unit.threatStatus() >= 2 and unit.role("player") ~= "TANK" and unit.isTankInRange()
        then
            if cast.cower("target") then
                ui.debug("Casting Cower")
                return true
            end
        end
    end
    -- Heals: you first, then the Heal Others unit (if any) at the same thresholds, by health after the
    -- heals already on their way (unit.hpAfterHeals): a heal about to land covers its gap
    local other = var.healOther
    local otherName = other and (" on " .. unit.name(other)) or ""
    -- War Stomp (Tauren) right before a cast-time heal on yourself while something hits you: the heal then
    -- lands inside the 2 s stun, without pushback (module.RacialStun: needs an enemy within 8 yd attacking you)
    local function stunFirst() return unit.inCombat() and module.RacialStun() end
    -- Healing Touch: the emergency heal, leaves any form regardless of Energy/Rage. Nature's Swiftness
    -- (off the GCD) makes it instant.
    if ui.checked("Healing Touch") and not cast.current.healingTouch() then
        local selfLow = inGroupOk and unit.hpAfterHeals() <= ui.value("Healing Touch")
        local otherLow = other ~= nil and unit.hpAfterHeals(other) <= ui.value("Healing Touch")
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
                if not buff.naturesSwiftness.exists() and stunFirst() then return true end
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
            if thisUnit ~= nil and (i == 2 or inGroupOk) and unit.hpAfterHeals(thisUnit) <= ui.value("Regrowth") then
                local label = i == 1 and "" or otherName
                if cast.able.swiftmend(thisUnit) and (buff.rejuvenation.exists(thisUnit) or buff.regrowth.exists(thisUnit)) then
                    if casterCast("swiftmend", thisUnit, "Swiftmend" .. label, freeHeal, false, true) then return true end
                end
                if cast.able.regrowth(thisUnit) and not cast.current.regrowth() and not unit.moving() and not buff.regrowth.exists(thisUnit) then
                    if i == 1 and stunFirst() then return true end
                    if casterCast("regrowth", thisUnit, "Regrowth" .. label, freeHeal, false, true) then return true end
                end
            end
        end
    end
    -- Out of combat and standing still, one Healing Touch at the Rejuvenation threshold instead of Rejuvenations:
    -- more health for the mana, and you're not in a hurry (the user's call, 2026-11-06). While moving, Rejuvenation.
    if ui.checked("Healing Touch") and ui.checked("Rejuvenation") and not unit.inCombat() and not unit.moving()
        and not cast.current.healingTouch()
    then
        if inGroupOk and unit.hpAfterHeals() <= ui.value("Rejuvenation") and cast.able.healingTouch("player") then
            if casterCast("healingTouch", "player", "Healing Touch [Out of combat]", freeHeal, false, true) then return true end
        end
        if other ~= nil and unit.hpAfterHeals(other) <= ui.value("Rejuvenation") and cast.able.healingTouch(other) then
            if casterCast("healingTouch", other, "Healing Touch [Out of combat]" .. otherName, freeHeal, false, true) then return true end
        end
    end
    -- Rejuvenation: too slow to justify two shapeshifts in combat. It's recast only once it's gone: a recast with
    -- ~3 s left threw away its last tick (2026-11-05: recast every 8.4-8.8 s of its 12 s, ticks every 3 s), and the
    -- Bloom talent heals only when it runs out. Out of combat too (2026-11-06: several Rejuvenations after a fight).
    local function rejuvenationDue(thisUnit)
        return not buff.rejuvenation.exists(thisUnit)
    end
    if ui.checked("Rejuvenation") and (not unit.inCombat() or not inForm) then
        if unit.hpAfterHeals() <= ui.value("Rejuvenation") and rejuvenationDue("player") and not buff.clearcasting.exists()
            and (unit.solo() or ui.checked("Self Heal In Group")) and cast.able.rejuvenation("player")
        then
            if casterCast("rejuvenation", "player", "Rejuvenation", freeHeal, false, true) then return true end
        end
        if other ~= nil and unit.hpAfterHeals(other) <= ui.value("Rejuvenation") and rejuvenationDue(other)
            and cast.able.rejuvenation(other)
        then
            if casterCast("rejuvenation", other, "Rejuvenation" .. otherName, freeHeal, false, true) then return true end
        end
    end
    -- Cure Poison (Abolish Poison once learned): after the heals, so a form left for a heal casts the heal first
    -- (2026-11-08 10:35:58: Cure Poison went out ahead of the Regrowth BR left Cat for). In combat only while already
    -- out of Cat or Bear Form, so it rides along with a heal. Gating it on low Energy wasn't enough: Claw keeps Energy low, and Bristleback Hunters
    -- re-poisoned three times in one fight, two shifts each (Rotation.log 2026-11-08 09:58, 834 mana)
    if ui.checked("Cure Poison") and (not unit.inCombat() or not inForm) then
        if spell.abolishPoison.known() then
            if cast.able.abolishPoison("player") and not buff.abolishPoison.exists("player") and cast.dispel.abolishPoison("player") then
                if casterCast("abolishPoison", "player", "Abolish Poison") then return true end
            end
        elseif cast.able.curePoison("player") and cast.dispel.curePoison("player") then
            if casterCast("curePoison", "player", "Cure Poison") then return true end
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
    -- not while a Hibernate is still casting: its debuff isn't there yet, so a second one went out
    -- behind it (BRCast.log 2026-10-12)
    if ui.checked("Hibernate") and not inForm and not unit.moving() and debuff.hibernate.count() == 0
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
    local lacerateStacks = debuff.lacerate.stack(units.dyn5)
    -- Lacerate at 5 stacks about to fall off (it starts again at 1): first, as wowsims/forever's Bear rotation
    if cast.able.lacerate(units.dyn5) and lacerateStacks >= 5 and debuff.lacerate.remain(units.dyn5) <= 3 then
        if cast.lacerate(units.dyn5) then
            ui.debug("Casting Lacerate [Keep Stack]")
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
    -- Swipe (hits 3): from 2 enemies once the target bleeds (Rend and Tear raises Swipe), else 3 (the sim's rule)
    if cast.able.swipe() and ui.useAOE(8, debuff.lacerate.exists(units.dyn5) and 2 or 3) then
        if cast.swipe() then
            ui.debug("Casting Swipe")
            return true
        end
    end
    -- Lacerate: a bleed (Rend and Tear) with high threat, and the filler for every global cooldown, 5 stacks or not
    -- (the sim's); stacking up starts only on a target that lives 6+ sec
    if cast.able.lacerate(units.dyn5) and (lacerateStacks > 0 or unit.ttd(units.dyn5) > 6) then
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

-- Stealth openers, in the Cat Opener option's order: the chosen one, else the next one learned, down to Claw.
-- Ravage and Shred need you behind the target.
local STEALTH_OPENERS = { "pounce", "ravage", "shred", "rake", "claw" }
local STEALTH_OPENER_NAMES = { pounce = "Pounce", ravage = "Ravage", shred = "Shred", rake = "Rake", claw = "Claw" }
local OPENS_BEHIND = { ravage = true, shred = true }
-- From Prowl in front of the target, time to step behind it for Ravage or Shred (Druid-TBC's Ravage wait): up to
-- STEALTH_WAIT seconds from reaching melee range, then the next opener that works from the front. Not while it
-- attacks you (it turns to face you), and over once you've stood still for STEALTH_STILL seconds (opening from
-- where you stand). Before, a Ravage player in front of it got nothing at all (every fallback needed Ravage or
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
            ui.debug(("Stealth Opener: up to %d s to get behind %s for %s"):format(STEALTH_WAIT, unit.name("target") or "target", spellName))
        end
    end
    if not w.over then w.over = now - w.since > STEALTH_WAIT or unit.standingTime() > STEALTH_STILL end
    return not w.over
end

-- Action List - Cat Opener (Stealth + Non-Stealth)
actionList.CatOpener = function()
    var.stealthHold = false
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
            if spell[key].known() and not (OPENS_BEHIND[key] and passed) then
                if OPENS_BEHIND[key] and not behind then
                    if stealthWait(name) then
                        var.stealthHold = true
                        return false
                    end
                    passed = name
                else
                    if not cast.able[key]("target") then return false end
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

    -- Non-Stealth Opener
    local behindTarget = unit.isBehind("target", "player")
    -- Shred (from behind)
    if behindTarget and cast.able.shred("target") and not unit.facing("target", "player") then
        if cast.shred("target") then
            ui.debug("Casting Shred [Opener]")
            return true
        end
    end
    -- Claw (fallback)
    if cast.able.claw("target") and (not spell.shred.known() or not behindTarget) then
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
    -- Shifting Power (talent): 40 Energy for Mana, at 57 Energy or less (wowsims/forever's ceiling; the game refuses
    -- it at full Energy). It costs 55% of base mana on an 8 sec cooldown (live build, was 16 sec in the beta), so it
    -- keeps back a heal and the shift back into Cat Form.
    if ui.checked("Shifting Power") and cast.able.shiftingPower() and energy <= 57 and not buff.clearcasting.exists()
        and power.mana.affordable(cast.cost.shiftingPower(), healCost() + cast.cost.catForm())
    then
        if cast.shiftingPower() then
            ui.debug("Casting Shifting Power")
            return true
        end
    end

    -- Finishers, in the order of wowsims/forever's Cat rotation (2026-11-08, master 125e53455)
    local ripUp = debuff.rip.exists(thisUnit)
    -- Fight left for a new Rip to pay off: 8 sec (the sim's), 6 before Ferocious Bite is learned (Forever's own 1328618 was in the spellbook at 24), while Rip is the only
    -- finisher (2026-11-07, level 20: fights of 11-19 sec ended on 5 unspent combo points)
    local ripTime = spell.ferociousBite.known() and 8 or 6
    -- Ferocious Bite spends all your Energy unless Predatory Discipline (talent) keeps it, so without the talent it goes
    -- out only at the end of the fight: in the last second on 2+ combo points, or once a Rip wouldn't pay off, on 5
    -- and at most 55 Energy (more goes on a builder first)
    local keepsBiteEnergy = spell.predatoryDiscipline.known()
    if cast.able.ferociousBite(thisUnit) and ((ttd <= 1 and comboPoints >= 2)
        or (ttd < ripTime and comboPoints >= 5 and (keepsBiteEnergy or energy <= 55)))
    then
        if cast.ferociousBite(thisUnit) then
            ui.debug("Casting Ferocious Bite [Fight End]")
            return true
        end
    end
    -- With Predatory Discipline, Bite mid-fight while Rip has 2+ sec left: on 4 combo points at 85 Energy (60 with
    -- Clearcasting), on 5 at 70 (50). Builders pool for it meanwhile (the sim's numbers).
    local poolForBite = false
    if keepsBiteEnergy and comboPoints >= 4 and ripUp and debuff.rip.remain(thisUnit) >= 2 then
        local clearcasting = buff.clearcasting.exists()
        local need = comboPoints >= 5 and (clearcasting and 50 or 70) or (clearcasting and 60 or 85)
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
    -- 5th adds only a little base damage. A 5th is built only when one more builder and Rip right after it fit in the
    -- Energy there plus a tick's 10 (the sim's rule without Blood Frenzy). Recast only once gone: no Pandemic on
    -- Forever, a recast throws the ticks left away (Druid-TBC's rule; the same measured for Rejuvenation, 2026-11-05).
    if not ripUp and ttd > ripTime and comboPoints >= 4 and cast.able.rip(thisUnit) then
        local builder = (behind and spell.shred.known()) and "shred" or "claw"
        local oneMore = comboPoints < 5 and ttd >= ripTime + 1 and cast.able[builder](thisUnit)
            and energy + 10 >= cast.cost[builder]() + cast.cost.rip()
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
    -- Rake: keep a bleed up on anything that lives long enough (Rend and Tear); recast once it's gone (see Rip)
    if cast.able.rake(thisUnit) and not debuff.rake.exists(thisUnit) and ttd > 6 then
        if cast.rake(thisUnit) then
            ui.debug("Casting Rake")
            var.rakeCheck = { unit = thisUnit, guid = unit.guid(thisUnit), at = util.time(), cp = comboPoints, energy = energy }
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
    -- Left Bear or Cat for your target (out of reach, fleeing, or the flee wait): that one, never BR's own pick, and
    -- every spell at it. Starfire and Wrath went out with no unit, so BR picked one: a Hillsbrad Farmer 22.7 yd off
    -- that wasn't fighting you, pulled while finishing a fleeing Peasant (2026-11-08 15:43:47)
    local thisUnit = var.rangeTarget and "target" or units.dyn30AOE
    local ttd = unit.ttd(thisUnit)
    -- Hurricane: no cooldown on Forever; channel it into a pack
    -- Hurricane: not while finishing your target from range (it lands where the most enemies are, fighting or not)
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

-- Yards outside the nearest aggro radius at which Prowl goes up, and how near a neutral target first (see PreCombat)
local PROWL_LEAD, PROWL_NEUTRAL = 2, 8

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if unit.inCombat() or unit.flying() or unit.mounted() then return false end
    -- Prowl: only just before a mob would notice you, PROWL_LEAD yards outside its aggro radius (a rotation
    -- tick and the send at a run), since Prowl slows you. unit.enemyNear(20) prowled 20 yd from the target whatever its
    -- aggro radius: 5 yd early for a mob 5 levels below (the user's call, 2026-11-08). Hostile mobs only: a neutral
    -- one doesn't notice you coming, so for a neutral target Prowl waits until PROWL_NEUTRAL yards (Druid-TBC's rule)
    -- instead of slowing you all the way in from its aggro radius
    if not (buff.prowl.exists() or buff.shadowmeld.exists()) and ui.mode.prowl == 1 and buff.catForm.exists()
        and cast.able.prowl("player") and not unit.resting()
        and (unit.anyInAggroRange(PROWL_LEAD, 40, true)
            or (unit.valid("target") and unit.reaction("target") == 4 and (unit.distance("target") or 99) < PROWL_NEUTRAL))
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
        and thisDistance < 30 and unit.enemy("target") and unit.readyToFight()
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
        -- Auto Attack (do not break Prowl). unit.startAttack() sends nothing while casting or just after a send, and
        -- then the rotation goes on (2026-11-05: three "Casting Auto Attack" ticks held back the next Wrath).
        if not buff.prowl.exists() and not cast.auto.autoAttack() and not unit.deadOrGhost("target") and unit.startAttack() then
            ui.debug("Casting Auto Attack [Precombat]")
            return true
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    if not (unit.inCombat() and unit.valid("target")) then return false end
    local inMelee = unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5
    -- Start Attack (do not break Prowl); when unit.startAttack() sends nothing yet, the rotation goes on (see PreCombat)
    if not buff.prowl.exists() and unit.exists(units.dyn5) and not cast.auto.autoAttack() and not unit.deadOrGhost("target")
        and unit.startAttack()
    then
        ui.debug("Casting Auto Attack")
        return true
    end
    -- Out of the toggle's Cat or Bear Form without the mana to shift back: swing at the target while the mana comes
    -- back. The auto attack above waits for a melee pick (2026-11-08 13:27: your own Healing Touch left 29 mana, 5 s
    -- idle with a Dalaran Wizard at 5.6 yd and no auto attack)
    local formKey = (activeForm == "cat" and "catForm") or (activeForm == "bear" and "bearForm") or nil
    if formKey and not inForm and not buff.moonkinForm.exists() and not buff.prowl.exists() and spell[formKey].known()
        and not power.mana.affordable(cast.cost[formKey]()) and not cast.auto.autoAttack()
        and not unit.deadOrGhost("target") and (unit.distance("target") or 99) < 8 and unit.startAttack()
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
    if ui.checked("Feral Charge (Cat)") and buff.catForm.exists() and not buff.prowl.exists()
        and unit.distance("target") >= 8 and unit.distance("target") < 25 and cast.able.feralChargeCat("target")
    then
        if cast.feralChargeCat("target") then
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
    -- Faerie Fire: castable in every form on Forever, and it doesn't stack, so anyone's counts. Target
    -- only: the armor loss helps the damage you deal to that unit, and each cast costs a GCD and mana.
    -- In Cat/Bear the mana is what heals and shifting back need, so it keeps a reserve. Never from Prowl.
    if ui.checked("Faerie Fire") and (not inForm or mana >= ui.value("Faerie Fire")) and not buff.prowl.exists()
        and unit.ttd("target") > 10 and not debuff.faerieFire.exists("target", "any") and cast.able.faerieFire("target")
    then
        if cast.faerieFire("target") then
            ui.debug("Casting Faerie Fire")
            return true
        end
    end
    -- Call Action List - Bear Form
    if activeForm == "bear" and buff.bearForm.exists() and inMelee then
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
    if activeForm == "cat" and buff.catForm.exists() and inMelee then
        if buff.prowl.exists() then
            if actionList.CatOpener() then return true end
            -- still in the time to get behind for the opener: no Claw from Cat Form out of Prowl
            if var.stealthHold then return true end
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
    comboPoints = power.comboPoints()
    energy      = power.energy()
    mana        = power.mana.percent()
    rage        = power.rage()
    -- Rake check (diagnostic, 2026-11-08: Rakes recast 2 s apart on Razormane quillboar, Energy spent beyond what
    -- Cat regenerates): 0.7 s after each Rake, before the next GCD lands, is it on the target (yours, or anyone's),
    -- and did it add a combo point (a hit does, a miss/dodge/parry doesn't)
    local rakeCheck = var.rakeCheck
    if rakeCheck and util.time() - rakeCheck.at >= 0.7 then
        var.rakeCheck = nil
        local u = rakeCheck.unit
        local same = unit.exists(u) and unit.guid(u) == rakeCheck.guid
        ui.debug(("Rake check: %s | yours on it %s (%.1f s left), anyone's %s | combo points %d -> %d | energy %d -> %d"):format(
            same and (unit.name(u) or "target") or "target gone or changed",
            tostring(same and debuff.rake.exists(u)), same and debuff.rake.remain(u) or 0,
            tostring(same and debuff.rake.exists(u, "any")),
            rakeCheck.cp or -1, comboPoints or -1, rakeCheck.energy or -1, energy or -1))
    end
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
        local dist = unit.distance("target") or 99
        if chase and activeForm == "cat" and buff.catForm.exists() and ui.checked("Feral Charge (Cat)") and dist >= 8
            and dist < 25 and cast.able.feralChargeCat("target")
        then
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
registerRotation({
    name      = "CuteOne",
    specID    = 1484, -- Forever Druid class-level spec ID.
    expansion = "Forever",
    author    = "CuteOne",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})
