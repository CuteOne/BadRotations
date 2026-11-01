-- Editor types: the keys of TBC Druid's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.TBC.Druid.buff]]
local cast = cast --[[@as BR.TBC.Druid.cast]]
local debuff = debuff --[[@as BR.TBC.Druid.debuff]]
local spell = spell --[[@as BR.TBC.Druid.spell]]

-- A Feral Druid profile for TBC (Anniversary, 2.5.x) that plays at every level, 1 to 70. It goes by the
-- spells the character knows (TBC reads no talent tree), so the talent spells (Mangle, Faerie Fire
-- (Feral), Omen of Clarity) join once they're in the spellbook:
--   levels 1-9   caster form: Wrath to pull, Moonfire, melee, Healing Touch / Rejuvenation;
--   levels 10-19 Bear Form (the Cat style's melee form until Cat Form): Maul, Demoralizing Roar, Swipe;
--   levels 20+   Cat Form or Bear / Dire Bear Form, by the Form toggle.
-- Caster form is used as a human Feral uses it: buffs between fights, a heal after one, and shifting out
-- to heal mid-fight from Bear Form when it goes badly solo (Barkskin, Regrowth, Healing Touch, then back
-- into form). Cat Form is never left in combat except to powershift: in TBC the energy and the shift's
-- mana matter too much (the user's rule for TBC Feral).
-- The profile never moves, turns or faces you, and never casts Travel, Aquatic or Flight Form (or acts
-- while you're in one): where you go is yours.
--
-- Where the priorities come from:
--   Cat: wowsims TBC sim/druid/feral/rotation.go (a port of NerdEgghead's TBC_cat_sim): Faerie Fire
--     (Feral) kept up first; Rip at 5 combo points when the fight lasts 10 s more (RipEndThresh); Mangle
--     when its debuff is down; Ferocious Bite at 5 points while Rip is up ("Biteweave" preset) or when the
--     fight is too short for Rip, after a Shred when energy is 57+20 or Clearcasting is up; Shred as the
--     builder; Clearcasting spent on Shred; powershift (shift into Cat Form again for the Furor / Wolfshead
--     energy) when energy is under 10 and the mana is there. Rake with no Mangle yet, the openers (Ravage
--     behind, else Pounce), Prowl, Claw before Shred / Mangle are the levelling guides' (Wowhead TBC Feral
--     levelling guide, Icy Veins TBC Feral guide), as is shifting out to heal.
--   Bear: wowsims TBC sim/druid/tank/rotation.go: Lacerate when 5 stacks have 1.5 s left; Faerie Fire
--     (Feral) kept up; Demoralizing Roar kept up (refreshed at 2 s); Mangle (Bear) on cooldown; Swipe on one
--     target only with 5 Lacerates and 2700+ attack power (SwipeApThreshold); Lacerate as filler; Maul
--     queued at 50 rage (MaulRageThreshold). Before Mangle and Lacerate (levelling) Maul at its own cost and
--     Swipe with rage to spare, as the levelling guides do.
--   Spell facts (forms each spell needs, costs, learn levels): Wowhead TBC tooltips, via the spell lists.
--
-- Not used, on purpose: Feral Charge (it moves you), Travel / Aquatic / Flight / Swift Flight / Moonkin Form
-- (where you go, and a Balance form), Starfire (a 3.5 s cast; a Feral is in a form by level 10), Nature's
-- Grasp (roots a mob that is already in melee with you), Faerie Fire (caster) once in a form (Faerie Fire
-- (Feral) is the free one).

-- Form toggle modes
local FORM_CAT, FORM_BEAR = 1, 2

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "swipe", overlay = "Automatic Rotation", tip = "Swipe (Bear) when 3 or more enemies are close." },
        { name = "Multi", icon = "swipe", overlay = "Multiple Target Rotation", tip = "Swipe (Bear) whenever 2 or more enemies are close." },
        { name = "Single", icon = "shred", overlay = "Single Target Rotation", tip = "Single target only." },
        { name = "Off", icon = "healingTouch", overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation" },
    } })
    ui.toggle("Cooldown", { key = "RightCtrl", modes = {
        { name = "Auto", icon = "innervate", overlay = "Cooldowns Automated", tip = "Cooldowns on bosses." },
        { name = "On", icon = "innervate", overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target." },
        { name = "Off", icon = "innervate", overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used." },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "regrowth", overlay = "Defensive Enabled", tip = "Heals, Barkskin, Frenzied Regeneration, cures." },
        { name = "Off", icon = "regrowth", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "bash", overlay = "Interrupts Enabled", tip = "Interrupts with Bash (Bear) and Maim (Cat)." },
        { name = "Off", icon = "bash", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
    } })
    ui.toggle("Form", { modes = {
        { name = "Cat", icon = "catForm", overlay = "Form: Cat", tip = "Damage in Cat Form (Bear Form until Cat Form is learned at 20)." },
        { name = "Bear", icon = "direBearForm", overlay = "Form: Bear", tip = "Tank in Bear / Dire Bear Form." },
    } })
end

---------------
--- Options ---
---------------
local function options()
    local section
    -- Cat
    section = ui.section("Cat")
    ui.checkbox(section, "Prowl", { checked = true,
        tip = "Out of combat in Cat Form, Prowl once you target an enemy you may attack within 30 yards, so you open from stealth." })
    ui.checkbox(section, "Pounce", { checked = true,
        tip = "From Prowl, open with Pounce (a stun and a bleed) when you aren't behind the enemy for Ravage." })
    ui.checkbox(section, "Tiger's Fury Opener", { checked = true,
        tip = "From Prowl at full energy, close to the enemy: Tiger's Fury before the opener (the energy would be capped anyway)." })
    ui.checkbox(section, "Powershift", { checked = true,
        tip = "In combat under 10 energy: shift into Cat Form again for the energy a shift gives (Furor, Wolfshead Helm). Only once a shift has shown it gives 30+ energy, with a heal's mana kept back solo." })
    ui.spinner(section, "Rip Fight Length", { value = 10, min = 0, max = 30, step = 1, checkbox = false,
        tip = "Rip at 5 combo points only when the enemy lives at least this many seconds more (wowsims: 10); else Ferocious Bite." })
    ui.checkbox(section, "Cower", { checked = true, tip = "In a group with a tank, Cower when you have high threat on your target." })
    ui.checkbox(section, "Dash", { checked = true, tip = "Dash while you chase a fleeing enemy (you move; Dash only speeds you up)." })
    -- Bear
    section = ui.section("Bear")
    ui.spinner(section, "Maul Rage", { value = 50, min = 10, max = 100, step = 5, checkbox = false,
        tip = "Once Mangle or Lacerate is known: queue Maul at this much rage (wowsims: 50). Before them Maul goes out whenever it's affordable." })
    ui.spinner(section, "Swipe Attack Power", { value = 2700, min = 0, max = 6000, step = 100, checkbox = false,
        tip = "Swipe on a single target only with 5 Lacerates up and this much attack power (wowsims: 2700)." })
    ui.checkbox(section, "Demoralizing Roar", { checked = true, tip = "Keep Demoralizing Roar on the enemies around you." })
    ui.checkbox(section, "Enrage", { checked = true, tip = "In Bear Form under 20 rage at 60%+ health (it lowers your armor), or to feed Frenzied Regeneration." })
    ui.checkbox(section, "Growl", { checked = true, tip = "In a group, taunt an enemy in melee that attacks someone else." })
    ui.checkbox(section, "Challenging Roar", { checked = true, tip = "In a group, when 3+ enemies within 10 yards attack others." })
    -- General
    section = ui.section("General")
    ui.spinner(section, "Faerie Fire Fight Length", { value = 15, min = 0, max = 60, step = 1, checkbox = true, checked = true,
        tip = "Faerie Fire (Feral) on an enemy that lives at least this many seconds (always on bosses, in a group, and when the enemy isn't in melee)." })
    ui.checkbox(section, "Pull with Faerie Fire (Feral)", { checked = true,
        tip = "Out of combat, not prowling: pull the enemy you target with Faerie Fire (Feral) from range." })
    ui.checkbox(section, "Wrath Pull", { checked = true, tip = "Caster form (before Bear Form): pull the enemy you target with Wrath, standing still, or Moonfire on the move." })
    -- Buffs
    section = ui.section("Buffs")
    ui.checkbox(section, "Mark of the Wild", { checked = true, tip = "Out of combat, on you and group members without it (leaves your form for it)." })
    ui.checkbox(section, "Gift of the Wild", { checked = false, tip = "Out of combat in a group with 3+ members without Mark of the Wild. Needs Wild Quillvine (BR can't see reagents)." })
    ui.checkbox(section, "Thorns", { checked = true, tip = "Out of combat, on you." })
    ui.checkbox(section, "Omen of Clarity", { checked = true, tip = "Out of combat, on you (talent)." })
    ui.checkbox(section, "Return to Form", { checked = true,
        tip = "Out of combat, go back into your form after the profile left it (buffs, heals), or once you target an enemy." })
    -- Defensive
    section = ui.section("Defensive")
    ui.spinner(section, "Shift Out to Heal", { value = 35, min = 5, max = 90, step = 5, checked = true,
        tip = "In combat in Bear Form, solo or not tanking for a group: leave it below this health percent and heal (Barkskin, Regrowth, Healing Touch). Cat Form is never left in combat except to powershift." })
    ui.spinner(section, "Heal Until", { value = 70, min = 20, max = 100, step = 5, checkbox = false,
        tip = "Mid-fight healing goes on until this health percent, then back into form." })
    ui.spinner(section, "Out of Combat Healing", { value = 70, min = 5, max = 100, step = 5, checked = true,
        tip = "Out of combat, standing still: Healing Touch at the rank the missing health needs." })
    ui.spinner(section, "Frenzied Regeneration", { value = 40, min = 5, max = 90, step = 5, checked = true, tip = "Bear Form, health percent." })
    ui.checkbox(section, "Barkskin", { checked = true, tip = "Out of form healing with an enemy on you (no pushback on the heals). Caster form only in TBC." })
    ui.spinner(section, "Innervate", { value = 25, min = 5, max = 90, step = 5, checked = true, tip = "Mana percent: on you while healing in combat." })
    ui.checkbox(section, "Cure Poison", { checked = true, tip = "Abolish Poison / Cure Poison on you, out of form." })
    ui.checkbox(section, "Remove Curse", { checked = true, tip = "On you, out of form." })
    module.BasicHealing(section)
    -- Interrupts
    section = ui.section("Interrupts")
    ui.checkbox(section, "Bash", { checked = true, tip = "Bear Form." })
    ui.checkbox(section, "Maim", { checked = true, tip = "Cat Form, with combo points on the caster (level 62)." })
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percent to Cast At (0 is random)" })
end

--------------
--- Locals ---
--------------
local enemy        -- BR's melee pick (units.dyn5)
local ranged       -- BR's 30 yd pick (units.dyn30)
local inCat, inBear, inOther, caster
local wantForm     -- the form key the Form toggle asks for, nil when none is known
local actionList = {}

-----------------
--- Functions ---
-----------------
-- " [why]" for a debug line
local function tag(why) return why and (" [" .. why .. "]") or "" end

local function say(key, why) ui.debug("Casting " .. spell[key].name() .. tag(why)) end

-- The bear form you know: Dire Bear Form replaces Bear Form at 40
local function bearKey()
    if spell.direBearForm.known() then return "direBearForm" end
    if spell.bearForm.known() then return "bearForm" end
end

-- The form the Form toggle asks for: Cat (Bear until Cat Form is learned), or Bear
local function formWanted()
    local bear = bearKey()
    if ui.mode.form == FORM_BEAR then return bear end
    if spell.catForm.known() then return "catForm" end
    return bear
end

-- The fight lasts at least this many seconds: BR's measured time to die, or, while it's still measuring,
-- an enemy at half health or more that isn't far below your level (unit.fightLength's guess)
local function lasts(thisUnit, seconds)
    if unit.livesFor(thisUnit, seconds) then return true end
    return unit.ttd(thisUnit) >= 999 and unit.fightLength(thisUnit) >= seconds and unit.hp(thisUnit) >= 50
end

-- The heal to leave form for mid-fight: Regrowth once known (12), Healing Touch before
local function combatHeal()
    if spell.regrowth.known() then return "regrowth" end
    return "healingTouch"
end

-- Mangle's debuff (either form's, anyone's: they're the same 30% bleed and Shred bonus)
local function mangleUp(thisUnit)
    return debuff.mangleCat.exists(thisUnit, "any") or debuff.mangleBear.exists(thisUnit, "any")
end

-- Faerie Fire (Feral) is worth a global cooldown on this enemy: no Faerie Fire on it (either kind,
-- anyone's) or under 3 s left (wowsims), and the fight is long enough, or a boss, or a group, or the
-- enemy isn't in melee (nothing better to do with the global cooldown)
local function wantsFaerieFire(thisUnit)
    if not ui.checked("Faerie Fire Fight Length") then return false end
    if debuff.faerieFire.exists(thisUnit, "any") then return false end
    if debuff.faerieFireFeral.exists(thisUnit, "any") and debuff.faerieFireFeral.remain(thisUnit, "any") > 3 then return false end
    return unit.isBoss(thisUnit) or unit.inGroup() or unit.distance(thisUnit) >= 5
        or lasts(thisUnit, ui.value("Faerie Fire Fight Length"))
end

-- The energy a shift into Cat Form gives (Furor, Wolfshead Helm), measured on each shift: the lowest seen,
-- so a tick landing with the shift doesn't count. nil until one has been seen
local function noteCatEntry()
    if inCat and var.wasCat == false then
        local energy = power.energy()
        var.catEntry = var.catEntry and math.min(var.catEntry, energy) or energy
    end
    var.wasCat = inCat
end

-- Start swinging at the enemy in reach (not from Prowl: the opener breaks it)
local function swing(thisUnit)
    if thisUnit and unit.distance(thisUnit) < 5 and not buff.prowl.exists() and not cast.auto.autoAttack() then
        if unit.startAttack(thisUnit) then ui.debug("Casting Auto Attack") end
    end
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive: potions, heals (in and out of form), Frenzied Regeneration, cures
actionList.Defensive = function()
    if not ui.useDefensive() then return false end
    if module.BasicHealing() then return true end
    local hp = unit.hp()
    -- Heals go by health after the heals already on their way (a Healing Touch about to land covers its
    -- gap); Frenzied Regeneration by health now
    local healedHp = unit.hpAfterHeals()
    local missing = unit.healthMax() - unit.healthAfterHeals()
    if unit.inCombat() then
        -- Bear: rage into health first
        if inBear and ui.checked("Frenzied Regeneration") and hp <= ui.value("Frenzied Regeneration") then
            if cast.frenziedRegeneration() then say("frenziedRegeneration") return true end
        end
        -- Leave Bear Form to heal (Cat Form is only left in combat to powershift): unit.cancelFormFor
        -- keeps it while tanking for a group or without the mana to heal and shift back; under 15% it
        -- leaves anyway. Not when the enemy dies first, nor while Frenzied Regeneration runs (leaving
        -- Bear Form would end it)
        local heal = combatHeal()
        local shiftAt = ui.value("Shift Out to Heal")
        local regenerating = inBear and cast.timeSinceLast.frenziedRegeneration() < 10
        if inBear and ui.checked("Shift Out to Heal") and healedHp <= shiftAt
            and not (enemy and unit.ttd(enemy) < 3 and hp > 20) and (not regenerating or hp <= 15)
        then
            if unit.cancelFormFor(spell[heal], false, hp <= 15) then
                var.healing = true
                ui.debug("Leaving form to heal [health " .. math.floor(hp) .. "%]")
                return true
            end
        end
        if caster then
            -- Healing in caster form: after leaving a form for it, or with no form known yet
            if var.healing and healedHp >= ui.value("Heal Until") then var.healing = false end
            local healing = var.healing or (wantForm == nil and ui.checked("Shift Out to Heal") and healedHp <= shiftAt)
            if healing then
                local attacked = #enemies.yards5 > 0
                if ui.checked("Barkskin") and attacked and not buff.barkskin.exists() then
                    if cast.barkskin("player") then say("barkskin") return true end
                end
                if ui.checked("Innervate") and power.mana.percent() <= ui.value("Innervate") then
                    if cast.innervate("player") then say("innervate") return true end
                end
                -- Rejuvenation: the instant one, on the move or before Regrowth is known
                if (unit.moving() or not spell.regrowth.known()) and not buff.rejuvenation.exists() then
                    if cast.rejuvenation("player") then say("rejuvenation") return true end
                end
                if not unit.moving() then
                    if spell.regrowth.known() and not buff.regrowth.exists() then
                        if cast.regrowth("player") then say("regrowth") return true end
                    end
                    if cast.healingTouch.forAmount(missing)("player") then say("healingTouch") return true end
                end
            end
        end
    else
        var.healing = false
        -- Top up after a fight, at the rank the missing health needs (not from Prowl)
        if ui.checked("Out of Combat Healing") and healedHp <= ui.value("Out of Combat Healing") and not unit.moving() then
            if inCat or inBear then
                if unit.cancelFormFor(spell.healingTouch) then
                    var.leftForm = true
                    ui.debug("Leaving form to heal [out of combat]")
                    return true
                end
            elseif caster then
                if cast.healingTouch.forAmount(missing)("player") then say("healingTouch", "Out of Combat") return true end
            end
        end
    end
    -- Cures, out of form only (never worth leaving it mid-fight)
    if caster then
        if ui.checked("Cure Poison") and cast.dispel.curePoison("player") then
            if spell.abolishPoison.known() and not buff.abolishPoison.exists() then
                if cast.abolishPoison("player") then say("abolishPoison") return true end
            elseif not spell.abolishPoison.known() then
                if cast.curePoison("player") then say("curePoison") return true end
            end
        end
        if ui.checked("Remove Curse") and cast.dispel.removeCurse("player") then
            if cast.removeCurse("player") then say("removeCurse") return true end
        end
    end
end

-- Action List - Buffs: out of combat, in caster form (left for them when one is missing)
actionList.Buffs = function()
    if unit.inCombat() or buff.prowl.exists() then return false end
    local needs = {}
    if ui.checked("Mark of the Wild") and not buff.markOfTheWild.exists("player", "any") and not buff.giftOfTheWild.exists("player", "any") then
        needs[#needs + 1] = "markOfTheWild"
    end
    if ui.checked("Thorns") and not buff.thorns.exists("player", "any") then needs[#needs + 1] = "thorns" end
    if ui.checked("Omen of Clarity") and spell.omenOfClarity.known() and not buff.omenOfClarity.exists() then
        needs[#needs + 1] = "omenOfClarity"
    end
    -- Group members without Mark / Gift of the Wild
    local bare, bareCount = nil, 0
    if ui.checked("Mark of the Wild") and unit.inGroup() then
        for i = 1, #units.friends do
            local friend = units.friends[i].unit
            if not unit.deadOrGhost(friend) and unit.distance(friend) < 30
                and not buff.markOfTheWild.exists(friend, "any") and not buff.giftOfTheWild.exists(friend, "any")
            then
                bare = bare or friend
                bareCount = bareCount + 1
            end
        end
    end
    if #needs == 0 and bare == nil then return false end
    if inCat or inBear then
        -- Once per 30 s: a buff that can't land (a group member out of sight) must not shift you out and
        -- back in over and over
        if var.leftForBuffAt and util.time() - var.leftForBuffAt < 30 then return false end
        local first = needs[1] or "markOfTheWild"
        if spell[first].known() and unit.cancelFormFor(spell[first]) then
            var.leftForm = true
            var.leftForBuffAt = util.time()
            ui.debug("Leaving form to buff [" .. spell[first].name() .. "]")
            return true
        end
        return false
    end
    if not caster then return false end
    for _, key in ipairs(needs) do
        if cast[key]("player") then say(key) return true end
    end
    if bare then
        if ui.checked("Gift of the Wild") and bareCount >= 3 then
            if cast.giftOfTheWild("player") then say("giftOfTheWild") return true end
        end
        if cast.markOfTheWild(bare) then ui.debug("Casting " .. spell.markOfTheWild.name() .. " on " .. unit.name(bare)) return true end
    end
end

-- Action List - Form: into the form the Form toggle asks for. In combat always (unless healing); out of
-- combat after the profile left it, or once you target an enemy you may attack. Never out of Travel,
-- Aquatic, Flight or Moonkin Form (the runner stops before this in those).
actionList.Form = function()
    if wantForm == nil then return false end
    local inWanted = (wantForm == "catForm" and inCat) or (wantForm ~= "catForm" and inBear)
    if inWanted then var.leftForm = false return false end
    if caster then
        if unit.inCombat() then
            if var.healing then return false end
        elseif not (ui.checked("Return to Form") and (var.leftForm or unit.pullable("target"))) then
            return false
        end
    end
    -- From the other melee form straight across (the toggle changed), or from caster form
    if cast[wantForm]("player") then say(wantForm) return true end
end

-- Action List - Interrupt
actionList.Interrupt = function()
    if not ui.useInterrupt() then return false end
    for i = 1, #enemies.yards5 do
        local thisUnit = enemies.yards5[i]
        if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
            if inBear and ui.checked("Bash") then
                if cast.bash(thisUnit) then say("bash", "Interrupt") return true end
            end
            -- Maim: a finisher, so only on your target (where the combo points are)
            if inCat and ui.checked("Maim") and unit.isUnit(thisUnit, "target") and power.comboPoints() > 0 then
                if cast.maim(thisUnit) then say("maim", "Interrupt") return true end
            end
        end
    end
end

-- Action List - Group: taunts and threat
actionList.Group = function()
    if not unit.inGroup() then return false end
    if inBear then
        if ui.checked("Challenging Roar") and enemies.count(enemies.yards10, unit.attackingOthers) >= 3 then
            if cast.challengingRoar() then say("challengingRoar") return true end
        end
        if ui.checked("Growl") then
            local loose = enemies.first(enemies.yards5, unit.attackingOthers)
            if loose and cast.growl(loose) then say("growl", unit.name(loose)) return true end
        end
    elseif inCat and ui.checked("Cower") and enemy and unit.isTankInRange() and unit.threatStatus(enemy) >= 1 then
        if cast.cower(enemy) then say("cower", "Threat") return true end
    end
end

-- Action List - Pull: out of combat, on the enemy you target (your target is your choice, as across BR;
-- players never, unit.pullable)
actionList.Pull = function()
    if unit.inCombat() or not unit.pullable("target") then return false end
    local distance = unit.distance("target")
    if inCat then
        -- Prowl first, so the fight opens from stealth
        if ui.checked("Prowl") and not buff.prowl.exists() and distance < 30 then
            if cast.prowl() then say("prowl") return true end
        end
        if buff.prowl.exists() then
            -- Energy capped at 100 while you walk in: Tiger's Fury spends what would overflow
            if ui.checked("Tiger's Fury Opener") and power.energy() >= 100 and distance < 10 and not buff.tigersFury.exists() then
                if cast.tigersFury() then say("tigersFury", "Opener") return true end
            end
            if unit.isBehind("target") then
                if cast.ravage("target") then say("ravage", "Opener") return true end
            elseif ui.checked("Pounce") then
                if cast.pounce("target") then say("pounce", "Opener") return true end
            end
            -- Before Ravage / Pounce (32 / 36): the rotation's builder breaks Prowl
            if distance < 5 and actionList.CatBuild("target") then return true end
            return false
        end
    end
    if inCat or inBear then
        if ui.checked("Pull with Faerie Fire (Feral)") and distance >= 8 then
            if cast.faerieFireFeral("target") then say("faerieFireFeral", "Pull") return true end
        end
        if distance < 5 then
            swing("target")
            -- In reach without Prowl: the builder now rather than a swing later
            if inCat and actionList.CatBuild("target") then return true end
        end
        return false
    end
    -- Caster form, before any form
    if caster and wantForm == nil and ui.checked("Wrath Pull") then
        if not unit.moving() and distance >= 8 then
            if cast.wrath("target") then say("wrath", "Pull") return true end
        elseif unit.moving() then
            if cast.moonfire("target") then say("moonfire", "Pull") return true end
        end
    end
    if distance < 5 then swing("target") end
end

-- Action List - Cat builder: Shred from behind (pooling for it), else Mangle with its debuff down, Rake
-- before Mangle is known, Claw. Clearcasting goes on the most expensive one you can use
actionList.CatBuild = function(thisUnit)
    local clear = buff.clearcasting.exists()
    if spell.shred.known() and unit.isBehind(thisUnit) then
        if cast.shred(thisUnit) then say("shred", clear and "Clearcasting" or nil) return true end
        return false -- pool for Shred: Mangle / Claw would cost the Shred
    end
    if spell.mangleCat.known() then
        if cast.mangleCat(thisUnit) then say("mangleCat", clear and "Clearcasting" or nil) return true end
        return false
    end
    if not clear and not debuff.rake.exists(thisUnit) and lasts(thisUnit, 6) then
        if cast.rake(thisUnit) then say("rake") return true end
    end
    if cast.claw(thisUnit) then say("claw", clear and "Clearcasting" or nil) return true end
end

-- Action List - Cat
actionList.Cat = function()
    if enemy == nil then
        -- Nothing in melee: Faerie Fire (Feral) on what you fight from range (free, no damage)
        if ranged and wantsFaerieFire(ranged) then
            if cast.faerieFireFeral(ranged) then say("faerieFireFeral", "Range") return true end
        end
        -- Chasing a fleeing enemy
        if ui.checked("Dash") and ranged and unit.isFleeing(ranged) and unit.moving() and not buff.prowl.exists() then
            if cast.dash() then say("dash", "Chase") return true end
        end
        return false
    end
    swing(enemy)
    local cp = power.comboPoints()
    local energy = power.energy()
    local clear = buff.clearcasting.exists()
    -- Faerie Fire (Feral) first (wowsims MaintainFaerieFire)
    if wantsFaerieFire(enemy) then
        if cast.faerieFireFeral(enemy) then say("faerieFireFeral") return true end
    end
    -- A Ferocious Bite that kills, at any combo points (levelling: no wasted builder on a dying mob)
    if cp > 0 and spell.ferociousBite.kills(enemy) then
        if cast.ferociousBite(enemy) then say("ferociousBite", "Kills") return true end
    end
    if cp >= 5 then
        -- Rip when the fight lasts long enough for it (wowsims RipEndThresh)
        if not debuff.rip.exists(enemy) and lasts(enemy, ui.value("Rip Fight Length")) then
            if cast.rip(enemy) then say("rip") return true end
            return actionList.Powershift()
        end
        -- Bite with Rip up, or the fight too short for Rip: spend Clearcasting or spare energy on a
        -- builder first (wowsims: Shred at 57+20 energy or with Clearcasting)
        if spell.ferociousBite.known() then
            if clear or energy >= 77 then
                if actionList.CatBuild(enemy) then return true end
            end
            if cast.ferociousBite(enemy) then say("ferociousBite") return true end
            return actionList.Powershift()
        end
    end
    -- Mangle when its debuff is down (wowsims mangleNow)
    if spell.mangleCat.known() and not mangleUp(enemy) then
        if cast.mangleCat(enemy) then say("mangleCat", "Debuff") return true end
    end
    if actionList.CatBuild(enemy) then return true end
    return actionList.Powershift()
end

-- Action List - Powershift: shift into Cat Form again when energy is too low to do anything (wowsims: under
-- 10) and a shift gives 30+ more energy than you have (measured, noteCatEntry). Solo, keeps a heal's mana
actionList.Powershift = function()
    if not ui.checked("Powershift") or not inCat or not unit.inCombat() then return false end
    local energy = power.energy()
    if var.catEntry == nil or energy >= 10 or var.catEntry - energy < 30 or buff.clearcasting.exists() then return false end
    if enemy == nil or not lasts(enemy, 4) then return false end
    local keep = unit.inGroup() and 0 or cast.cost[combatHeal()]()
    if not power.mana.affordable(cast.cost.catForm(), keep) then return false end
    -- cast.able does every check but the form (it is the form spell); the "!" makes the game shift again
    -- rather than leave the form
    if cast.able.catForm() then
        cast.macro("/cast !" .. spell.catForm.name(), spell.catForm.id())
        ui.debug("Casting " .. spell.catForm.name() .. " [Powershift, " .. energy .. " energy]")
        return true
    end
end

-- Action List - Bear
actionList.Bear = function()
    if enemy == nil then
        if ranged and wantsFaerieFire(ranged) then
            if cast.faerieFireFeral(ranged) then say("faerieFireFeral", "Range") return true end
        end
        return false
    end
    swing(enemy)
    local rage = power.rage()
    local lacerateStacks = debuff.lacerate.stack(enemy)
    local lacerateLeft = debuff.lacerate.remain(enemy)
    local several = #enemies.yards8 >= 2
    -- Enrage: rage when there's none, at a health that can take the lower armor, or to feed Frenzied
    -- Regeneration
    if ui.checked("Enrage") and rage < 20 and (unit.hp() >= 60 or cast.timeSinceLast.frenziedRegeneration() < 10) then
        if cast.enrage() then say("enrage") return true end
    end
    -- Lacerate before 5 stacks drop (wowsims shouldSaveLacerateStacks)
    if lacerateStacks >= 5 and lacerateLeft <= 1.5 then
        if cast.lacerate(enemy) then say("lacerate", "Refresh") return true end
    end
    if wantsFaerieFire(enemy) then
        if cast.faerieFireFeral(enemy) then say("faerieFireFeral") return true end
    end
    -- Demoralizing Roar on the enemies around you (refreshed at 2 s, wowsims), for a fight that lasts
    if ui.checked("Demoralizing Roar") and (several or lasts(enemy, 8) or unit.inGroup())
        and enemies.any(enemies.yards10, function(thisUnit) return debuff.demoralizingRoar.remain(thisUnit, "any") < 2 end)
    then
        if cast.demoralizingRoar() then say("demoralizingRoar") return true end
    end
    -- Swipe on several enemies
    if ui.useAOE(8, 3) and cast.swipe(enemy) then say("swipe", "AoE") return true end
    -- Mangle (Bear) on cooldown
    if cast.mangleBear(enemy) then say("mangleBear") return true end
    -- Swipe on one target with 5 Lacerates that last, and the attack power for it (wowsims)
    if lacerateStacks >= 5 and lacerateLeft > 3 and unit.attackPower() >= ui.value("Swipe Attack Power") then
        if cast.swipe(enemy) then say("swipe", "Attack Power") return true end
    end
    if cast.lacerate(enemy) then say("lacerate") return true end
    -- Levelling (no Mangle or Lacerate yet): Swipe with rage to spare for Maul too
    local early = not spell.mangleBear.known() and not spell.lacerate.known()
    if early and rage >= cast.cost.swipe() + cast.cost.maul() then
        if cast.swipe(enemy) then say("swipe", "Filler") return true end
    end
    -- Maul on the next swing: at the threshold once there are global cooldown spells to keep rage for
    local maulAt = early and cast.cost.maul() or ui.value("Maul Rage")
    if rage >= maulAt then
        if cast.maul(enemy) then say("maul") return true end
    end
end

-- Action List - Caster: before any form (levels 1-9): Moonfire, Wrath while it closes in, melee, Entangling
-- Roots on a fleeing enemy. A heal's mana is always kept
actionList.Caster = function()
    local target = enemy or ranged
    if target == nil then return false end
    swing(enemy)
    local keep = cast.cost.healingTouch()
    if unit.isFleeing(target) and not debuff.entanglingRoots.exists(target) and not unit.moving() then
        if cast.entanglingRoots(target) then say("entanglingRoots", "Fleeing") return true end
    end
    if not debuff.moonfire.exists(target) and power.mana.affordable(cast.cost.moonfire(), keep) then
        if cast.moonfire(target) then say("moonfire") return true end
    end
    if not unit.moving() and unit.distance(target) >= 5 and power.mana.affordable(cast.cost.wrath(), keep) then
        if cast.wrath(target) then say("wrath") return true end
    end
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    enemy = units.get(5)
    ranged = units.get(30)

    inCat = buff.catForm.exists()
    inBear = buff.bearForm.exists() or buff.direBearForm.exists()
    inOther = unit.formActive() and not inCat and not inBear
    caster = not unit.formActive()
    wantForm = formWanted()
    noteCatEntry()

    if ui.pause() or ui.mode.rotation == 4 or unit.mounted() or unit.flying() or unit.taxi() then return true end
    -- Travel, Aquatic, Flight or Moonkin Form: where you go is yours
    if inOther then return true end

    if actionList.Defensive() then return true end
    if actionList.Buffs() then return true end
    if actionList.Form() then return true end
    if actionList.Pull() then return true end
    if unit.inCombat() and (enemy or ranged) then
        if actionList.Interrupt() then return true end
        if actionList.Group() then return true end
        if inCat then
            if actionList.Cat() then return true end
        elseif inBear then
            if actionList.Bear() then return true end
        -- Caster form with no form known, or without the mana for one: fight as a caster
        elseif caster and not var.healing and (wantForm == nil or not power.mana.affordable(cast.cost[wantForm]())) then
            if actionList.Caster() then return true end
        end
    end
end

registerRotation({
    name      = "Claude",
    specID    = 283, -- TBC Druid class-level spec ID
    expansion = "TBC",
    author    = "Claude",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})
