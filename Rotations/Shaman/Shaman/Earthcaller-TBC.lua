-- Editor types: the keys of TBC Shaman's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.TBC.Shaman.buff]]
local cast = cast --[[@as BR.TBC.Shaman.cast]]
local debuff = debuff --[[@as BR.TBC.Shaman.debuff]]
local imbues = imbues --[[@as BR.TBC.Shaman.imbues]]
local spell = spell --[[@as BR.TBC.Shaman.spell]]
local totem = totem --[[@as BR.TBC.Shaman.totem]]

local rotationName = "Earthcaller"

-- A Shaman profile for TBC that plays at every level, from 1 to 70. It goes by the spells the
-- character knows (TBC reads no talent tree): a level 1 Shaman bolts and melees with Rockbiter,
-- totems, shocks and imbues join as they're learned, and the talent spells (Stormstrike,
-- Shamanistic Rage, Elemental Mastery, Totem of Wrath, ...) are used once they are there.
-- Mana thresholds come from the game (spell costs, mana percent, the cost of a heal kept back), so
-- the same rules hold at level 10 and at 70.
--
-- Style (toggle): Melee (Enhancement and leveling) or Caster (Elemental); Auto picks Caster once
-- Elemental Mastery or Totem of Wrath is known, Melee otherwise.

-- The imbue dropdowns' choices, in order (ui.value gives the position)
local IMBUE_CHOICES = { "Auto", "Windfury", "Flametongue", "Frostbrand", "Rockbiter", "None" }

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "chainLightning", overlay = "Automatic Rotation", tip = "Area totems and Chain Lightning when 3 or more enemies are close." },
        { name = "Multi", icon = "chainLightning", overlay = "Multiple Target Rotation", tip = "Area totems and Chain Lightning whenever an enemy is close." },
        { name = "Single", icon = "lightningBolt", overlay = "Single Target Rotation", tip = "Single target only." },
        { name = "Off", icon = "healingWave", overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation" },
    } })
    ui.toggle("Cooldown", { key = "RightCtrl", modes = {
        { name = "Auto", icon = "fireElementalTotem", overlay = "Cooldowns Automated", tip = "Cooldowns on bosses." },
        { name = "On", icon = "fireElementalTotem", overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target." },
        { name = "Off", icon = "fireElementalTotem", overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used." },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "healingWave", overlay = "Defensive Enabled", tip = "Heals, Stoneclaw Totem and Shamanistic Rage." },
        { name = "Off", icon = "healingWave", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "earthShock", overlay = "Interrupts Enabled", tip = "Interrupts with Earth Shock." },
        { name = "Off", icon = "earthShock", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
    } })
    ui.toggle("Style", { modes = {
        { name = "Auto", icon = "rockbiterWeapon", overlay = "Style: Automatic", tip = "Caster once Elemental Mastery or Totem of Wrath is known, Melee otherwise." },
        { name = "Melee", icon = "stormstrike", overlay = "Style: Melee", tip = "Melee with shocks, imbues and melee totems (Enhancement, leveling)." },
        { name = "Caster", icon = "lightningBolt", overlay = "Style: Caster", tip = "Lightning Bolt and Chain Lightning from range (Elemental)." },
    } })
end

---------------
--- Options ---
---------------
local function options()
    local section
    -- General
    section = ui.section("General")
    ui.checkbox(section, "Pull with Lightning Bolt", { checked = true,
        tip = "Open on an enemy you target, out of combat and standing still, with Lightning Bolt (Melee style; Caster style always pulls)." })
    ui.spinner(section, "Shock Mana", { value = 40, min = 0, max = 100, step = 5, checkbox = false,
        tip = "Melee style: shocks for damage only above this mana percent (Focused procs, interrupts and fleeing enemies always may). One heal's mana is always kept back." })
    ui.checkbox(section, "Purge", { checked = true, tip = "Purge a magic buff from your target." })
    ui.checkbox(section, "Ancestral Spirit", { checked = true, tip = "Out of combat, resurrect a dead group member." })
    -- Weapons and shields
    section = ui.section("Self Buffs")
    ui.dropdown(section, "Main Hand Imbue", { choices = IMBUE_CHOICES, value = "Auto", checkbox = false,
        tip = "Auto: Windfury, else Rockbiter (Melee); Flametongue, else Rockbiter (Caster)." })
    ui.dropdown(section, "Off Hand Imbue", { choices = IMBUE_CHOICES, value = "Auto", checkbox = false,
        tip = "Dual wielding only. Auto: Flametongue, else Rockbiter." })
    ui.dropdown(section, "Shield", { choices = { "Auto", "Lightning Shield", "Water Shield", "None" }, value = "Auto", checkbox = false,
        tip = "Auto: Water Shield once it's known (level 62), Lightning Shield before. A shield already up is kept until it fades." })
    ui.checkbox(section, "Earth Shield", { checked = true, tip = "In a group, keep Earth Shield on the tank (TBC doesn't allow it on yourself)." })
    -- Totems
    section = ui.section("Totems")
    ui.spinner(section, "Totem Fight Length", { value = 10, min = 0, max = 60, step = 1, checkbox = false,
        tip = "Drop totems only when the fight should last at least this many seconds, or 2+ enemies are on you (0 = always)." })
    ui.dropdown(section, "Earth Totem", { choices = { "Auto", "Strength of Earth", "Stoneskin", "Tremor", "None" }, value = "Auto", checkbox = false,
        tip = "Auto: Strength of Earth (Melee), Stoneskin (Caster)." })
    ui.dropdown(section, "Fire Totem", { choices = { "Auto", "Searing", "Totem of Wrath", "Flametongue", "None" }, value = "Auto", checkbox = false,
        tip = "Single target. Auto: Totem of Wrath once known, Searing otherwise. Area fights use Magma / Fire Nova." })
    ui.dropdown(section, "Water Totem", { choices = { "Auto", "Mana Spring", "Healing Stream", "None" }, value = "Auto", checkbox = false,
        tip = "Auto: Mana Spring below 80% mana, Healing Stream below 80% health." })
    ui.dropdown(section, "Air Totem", { choices = { "Auto", "Windfury", "Grace of Air", "Wrath of Air", "None" }, value = "Auto", checkbox = false,
        tip = "Auto: Windfury Totem (Melee, Grace of Air when the main hand holds Windfury), Wrath of Air (Caster)." })
    ui.checkbox(section, "Area Fire Totems", { checked = true, tip = "Magma or Fire Nova Totem when the rotation counts enough enemies within 8 yards." })
    ui.checkbox(section, "Totemic Call", { checked = true,
        tip = "Out of combat, recall totems you have left 30+ yards behind (gives back some of their mana)." })
    -- Cooldowns
    section = ui.section("Cooldowns")
    ui.checkbox(section, "Bloodlust / Heroism", { checked = true, tip = "In a group, when cooldowns are used." })
    ui.checkbox(section, "Fire Elemental Totem", { checked = true })
    ui.checkbox(section, "Earth Elemental Totem", { tip = "Also used below 30% health with 2+ enemies on you." })
    ui.checkbox(section, "Elemental Mastery", { checked = true })
    -- Defensive
    section = ui.section("Defensive")
    module.BasicHealing(section)
    ui.spinner(section, "Healing Wave", { value = 40, checked = true, tip = "Health percent, in combat (Lesser Healing Wave once known)." })
    ui.spinner(section, "Out of Combat Healing", { value = 70, checked = true, tip = "Health percent to top up to with Healing Wave after a fight." })
    ui.spinner(section, "Nature's Swiftness", { value = 25, checked = true, tip = "Health percent for an instant Healing Wave." })
    ui.spinner(section, "Stoneclaw Totem", { value = 50, checked = true, tip = "Health percent, with 2+ enemies on you." })
    ui.spinner(section, "Shamanistic Rage", { value = 50, checked = true, tip = "Health percent (also used below 30% mana)." })
    ui.checkbox(section, "Cure Poison", { checked = true })
    ui.checkbox(section, "Cure Disease", { checked = true })
    -- Interrupts
    section = ui.section("Interrupts")
    ui.checkbox(section, "Earth Shock - Int", { checked = true })
    ui.checkbox(section, "Interrupt with Rank 1", { checked = true, tip = "Interrupt with Earth Shock rank 1: the interrupt is the same, the mana a fraction." })
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percent to Cast At (0 is random)" })
end

--------------
--- Locals ---
--------------
local mana
local melee -- Style: true for Melee, false for Caster
local actionList = {}

-----------------
--- Functions ---
-----------------
-- The heal the profile keeps mana back for: Lesser Healing Wave once known, Healing Wave before
local function healCost()
    if spell.lesserHealingWave.known() then return cast.cost.lesserHealingWave() end
    return cast.cost.healingWave()
end

-- True when a spell costing this much still leaves the mana for one heal
local function affordable(cost)
    return mana() - cost >= healCost()
end

-- Seconds the fight against thisUnit should last. While BR is still measuring (999 = unknown), a
-- mob 4+ levels below you counts as a short fight and any other as a long one.
local function fightLength(thisUnit)
    local ttd = unit.ttd(thisUnit)
    if ttd < 999 then return ttd end
    return unit.level(thisUnit) <= unit.level() - 4 and 0 or 999
end

-- Totems are worth their mana: the fight lasts long enough, or 2+ enemies are on you
local function totemsWorthIt()
    return #enemies.yards8 >= 2 or fightLength("target") >= ui.value("Totem Fight Length")
end

-- An element needs a totem: none up, or the one up was left 30+ yards behind (0 = can't be
-- located, counted as near). A totem you dropped yourself (Tremor, Grounding, ...) is never replaced.
local function needsTotem(element)
    if not element.active() then return true end
    return element.distance() >= 30
end

-- Imbues: the spell key and imbue list for an option choice on this hand ("Auto" picks the best known)
local IMBUE_KEYS = { Windfury = "windfuryWeapon", Flametongue = "flametongueWeapon",
    Frostbrand = "frostbrandWeapon", Rockbiter = "rockbiterWeapon" }
local function imbueFor(choice, offHand)
    if choice == "None" then return nil end
    if choice ~= "Auto" then return IMBUE_KEYS[choice] end
    -- Melee main hand: Rockbiter until Windfury (the usual leveling choice); off hand and Caster:
    -- Flametongue
    if not offHand and melee then
        return spell.windfuryWeapon.known() and "windfuryWeapon" or "rockbiterWeapon"
    end
    if spell.flametongueWeapon.known() then return "flametongueWeapon" end
    return "rockbiterWeapon"
end

-- The imbue on the main hand: what the profile put there, else (after a /reload) the one it would
local function mainHandImbue()
    return (var.imbued and var.imbued.main) or imbueFor(IMBUE_CHOICES[ui.value("Main Hand Imbue")], false)
end

-- Apply the chosen imbue to a hand. The game can't always tell which imbue is on a weapon (see
-- unit.weaponImbue.exists), so the profile also remembers what it put on each hand this session:
-- when the choice changes (a new imbue learned, the option changed) it reapplies.
-- The off hand is imbued only once the main hand is done. Unconfirmed on TBC: which hand a cast
-- lands on while dual wielding. If the off hand is still bare 2 s after its cast, the imbue went to
-- the main hand: off-hand imbues stop for the session (so the hands never take turns overwriting).
local function applyImbue(optionName, offHand)
    local key = imbueFor(IMBUE_CHOICES[ui.value(optionName)], offHand)
    if key == nil or not spell[key].known() then return false end
    var.imbued = var.imbued or {}
    local hand = offHand and "off" or "main"
    local present = unit.weaponImbue.exists(imbues[key], offHand)
    if offHand then
        if var.offHandFailed then return false end
        if var.offHandSent and not present and util.time() - var.offHandSent > 2 then
            var.offHandFailed = true
            ui.print("Off-hand imbue landed on the main hand; off-hand imbues are off until /reload.")
            return false
        end
        if var.offHandSent and util.time() - var.offHandSent <= 2 then return false end
    end
    if present and (var.imbued[hand] == nil or var.imbued[hand] == key) then return false end
    if cast[key]("player") then
        var.imbued[hand] = key
        if offHand then var.offHandSent = util.time() end
        ui.debug("Casting " .. spell[key].name() .. (offHand and " [Off Hand]" or " [Main Hand]"))
        return true
    end
    return false
end

-- The shield to keep up, by the Shield option. Auto keeps whichever shield is up (a Lightning
-- Shield up when Water Shield is learned runs out first) and picks one only when neither is.
local function shieldKey()
    local choice = ui.value("Shield")
    if choice == 4 then return nil end
    if choice == 2 then return "lightningShield" end
    if choice == 3 then return "waterShield" end
    if buff.waterShield.exists() then return "waterShield" end
    if buff.lightningShield.exists() then return "lightningShield" end
    if spell.waterShield.known() then return "waterShield" end
    return "lightningShield"
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra: shields, imbues, Earth Shield, resurrection, Totemic Call
actionList.Extra = function()
    -- Shield (in and out of combat)
    local shield = shieldKey()
    if shield and spell[shield].known() and not buff[shield].exists() then
        if cast[shield]("player") then ui.debug("Casting " .. spell[shield].name()) return true end
    end
    if unit.inCombat() then return false end
    -- Weapon imbues
    if applyImbue("Main Hand Imbue", false) then return true end
    if unit.dualWielding() and unit.weaponImbue.exists(nil, false) and applyImbue("Off Hand Imbue", true) then return true end
end

-- Action List - Defensive
actionList.Defensive = function()
    if not ui.useDefensive() then return false end
    if module.BasicHealing() then return true end
    local hp = unit.hp()
    if unit.inCombat() then
        local onMe = #enemies.yards8
        -- Nature's Swiftness → instant Healing Wave
        if ui.checked("Nature's Swiftness") and hp <= ui.value("Nature's Swiftness") then
            if buff.naturesSwiftness.exists() then
                if cast.healingWave("player") then ui.debug("Casting Healing Wave [Nature's Swiftness]") return true end
            elseif cast.naturesSwiftness() then ui.debug("Casting Nature's Swiftness") return true end
        end
        -- Shamanistic Rage (health or mana)
        if ui.checked("Shamanistic Rage") and (hp <= ui.value("Shamanistic Rage") or power.mana.percent() < 30) then
            if cast.shamanisticRage() then ui.debug("Casting Shamanistic Rage") return true end
        end
        -- Stoneclaw Totem draws the mobs off you
        if ui.checked("Stoneclaw Totem") and hp <= ui.value("Stoneclaw Totem") and onMe >= 2 then
            if cast.stoneclawTotem() then ui.debug("Casting Stoneclaw Totem") return true end
        end
        -- Earth Elemental when it's going badly
        if ui.checked("Earth Elemental Totem") and hp < 30 and onMe >= 2 then
            if cast.earthElementalTotem() then ui.debug("Casting Earth Elemental Totem [Defensive]") return true end
        end
        -- Heal, unless the target dies first
        if ui.checked("Healing Wave") and hp <= ui.value("Healing Wave") and not unit.moving()
            and not (unit.ttd("target") < 3 and hp > 20)
        then
            if spell.lesserHealingWave.known() then
                if cast.lesserHealingWave("player") then ui.debug("Casting Lesser Healing Wave") return true end
            elseif cast.healingWave("player") then ui.debug("Casting Healing Wave") return true end
        end
    else
        -- Top up after a fight
        if ui.checked("Out of Combat Healing") and hp <= ui.value("Out of Combat Healing") and not unit.moving() then
            if cast.healingWave("player") then ui.debug("Casting Healing Wave [Out of Combat]") return true end
        end
    end
    -- Cures
    if ui.checked("Cure Poison") and cast.dispel.curePoison("player") then
        if cast.curePoison("player") then ui.debug("Casting Cure Poison") return true end
    end
    if ui.checked("Cure Disease") and cast.dispel.cureDisease("player") then
        if cast.cureDisease("player") then ui.debug("Casting Cure Disease") return true end
    end
end

-- Action List - Interrupt
actionList.Interrupt = function()
    if not ui.useInterrupt() or not ui.checked("Earth Shock - Int") then return false end
    for i = 1, #enemies.yards20 do
        local thisUnit = enemies.yards20[i]
        if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
            local earthShock = ui.checked("Interrupt with Rank 1") and cast.earthShock.rank(1) or cast.earthShock
            if earthShock(thisUnit) then ui.debug("Casting Earth Shock [Interrupt]") return true end
        end
    end
end

-- Action List - Cooldowns
actionList.Cooldown = function()
    if not ui.useCDs() then return false end
    if ui.checked("Bloodlust / Heroism") and unit.inGroup() then
        if spell.heroism.known() then
            if cast.heroism() then ui.debug("Casting Heroism") return true end
        elseif cast.bloodlust() then ui.debug("Casting Bloodlust") return true end
    end
    if ui.checked("Fire Elemental Totem") and cast.fireElementalTotem() then ui.debug("Casting Fire Elemental Totem") return true end
    if ui.checked("Earth Elemental Totem") and cast.earthElementalTotem() then ui.debug("Casting Earth Elemental Totem") return true end
    if ui.checked("Elemental Mastery") and not melee and cast.elementalMastery() then ui.debug("Casting Elemental Mastery") return true end
end

-- Action List - Totems (in combat)
actionList.Totems = function()
    if not totemsWorthIt() then return false end
    local inMelee = unit.distance("target") < 8
    -- Fire: area totems where the enemies are around you, else the single-target one
    if ui.checked("Area Fire Totems") and ui.useAOE(8, 3) and (needsTotem(totem.fire) or totem.fire.searing.active()) then
        if cast.magmaTotem.aoe(8, 3) then ui.debug("Casting Magma Totem") return true end
        if not spell.magmaTotem.known() and cast.fireNovaTotem.aoe(8, 3) then ui.debug("Casting Fire Nova Totem") return true end
    end
    -- Earth
    local earth = ui.value("Earth Totem")
    if earth ~= 5 and needsTotem(totem.earth) then
        local key
        if earth == 2 then key = "strengthOfEarthTotem"
        elseif earth == 3 then key = "stoneskinTotem"
        elseif earth == 4 then key = "tremorTotem"
        elseif melee and spell.strengthOfEarthTotem.known() then key = "strengthOfEarthTotem"
        else key = "stoneskinTotem" end
        if (melee and inMelee or not melee) and affordable(cast.cost[key]()) then
            if cast[key]() then ui.debug("Casting " .. spell[key].name()) return true end
        end
    end
    -- Fire: single target (Searing Totem reaches 20 yards)
    local fire = ui.value("Fire Totem")
    if fire ~= 5 and needsTotem(totem.fire) and unit.distance("target") < 20 then
        local key
        if fire == 2 then key = "searingTotem"
        elseif fire == 3 then key = "totemOfWrath"
        elseif fire == 4 then key = "flametongueTotem"
        elseif spell.totemOfWrath.known() then key = "totemOfWrath"
        else key = "searingTotem" end
        if affordable(cast.cost[key]()) then
            if cast[key]() then ui.debug("Casting " .. spell[key].name()) return true end
        end
    end
    -- Water
    local water = ui.value("Water Totem")
    if water ~= 4 and needsTotem(totem.water) then
        local key
        if water == 2 then key = "manaSpringTotem"
        elseif water == 3 then key = "healingStreamTotem"
        elseif spell.manaSpringTotem.known() and power.mana.percent() < 80 then key = "manaSpringTotem"
        elseif unit.hp() < 80 then key = "healingStreamTotem" end
        if key and affordable(cast.cost[key]()) then
            if cast[key]() then ui.debug("Casting " .. spell[key].name()) return true end
        end
    end
    -- Air
    local air = ui.value("Air Totem")
    if air ~= 5 and needsTotem(totem.air) then
        local key
        if air == 2 then key = "windfuryTotem"
        elseif air == 3 then key = "graceOfAirTotem"
        elseif air == 4 then key = "wrathOfAirTotem"
        elseif not melee and spell.wrathOfAirTotem.known() then key = "wrathOfAirTotem"
        elseif melee and spell.windfuryTotem.known() and mainHandImbue() ~= "windfuryWeapon" then key = "windfuryTotem"
        elseif melee then key = "graceOfAirTotem" end
        if key and spell[key].known() and (melee and inMelee or not melee) and affordable(cast.cost[key]()) then
            if cast[key]() then ui.debug("Casting " .. spell[key].name()) return true end
        end
    end
end

-- Action List - Shocks: fleeing enemies, Focused procs, Flame Shock and Earth Shock
actionList.Shocks = function(manaGate)
    -- A fleeing enemy: slow it or finish it, whatever the mana
    if unit.isFleeing("target") then
        if cast.frostShock("target") then ui.debug("Casting Frost Shock [Fleeing]") return true end
        if cast.earthShock("target") then ui.debug("Casting Earth Shock [Fleeing]") return true end
    end
    local focused = buff.focused.exists()
    if not focused and not manaGate then return false end
    -- Flame Shock when it has time to tick
    if not debuff.flameShock.exists("target") and fightLength("target") >= 12
        and (focused or affordable(cast.cost.flameShock()))
    then
        if cast.flameShock("target") then ui.debug("Casting Flame Shock") return true end
    end
    if focused or affordable(cast.cost.earthShock()) then
        if cast.earthShock("target") then ui.debug("Casting Earth Shock") return true end
    end
end

-- Action List - Melee style
actionList.Melee = function()
    local distance = unit.distance("target")
    -- Auto attack
    if distance < 5 and not cast.auto.autoAttack() then
        unit.startAttack()
        ui.debug("Casting Auto Attack")
    end
    -- Stormstrike
    if distance < 5 and cast.stormstrike("target") then ui.debug("Casting Stormstrike") return true end
    -- Shocks
    if actionList.Shocks(power.mana.percent() >= ui.value("Shock Mana")) then return true end
    -- An enemy standing off at range (a caster): bolt it rather than wait
    if distance > 10 and not unit.moving() and not unit.moving("target") then
        if cast.lightningBolt("target") then ui.debug("Casting Lightning Bolt [Range]") return true end
    end
end

-- Action List - Caster style
actionList.Caster = function()
    if unit.distance("target") < 5 and not cast.auto.autoAttack() then
        unit.startAttack()
        ui.debug("Casting Auto Attack")
    end
    if unit.moving() then
        -- Instants while moving
        return actionList.Shocks(true)
    end
    -- Flame Shock when it has time to tick
    if not debuff.flameShock.exists("target") and fightLength("target") >= 12 and affordable(cast.cost.flameShock()) then
        if cast.flameShock("target") then ui.debug("Casting Flame Shock") return true end
    end
    -- Chain Lightning: on several enemies, or while the mana is plentiful
    local nearTarget = #enemies.get(10, "target")
    if (nearTarget >= 2 and ui.mode.rotation ~= 3) or (power.mana.percent() > 50 and fightLength("target") > 5) then
        if cast.chainLightning("target") then ui.debug("Casting Chain Lightning") return true end
    end
    if actionList.Shocks(false) then return true end
    if cast.lightningBolt("target") then ui.debug("Casting Lightning Bolt") return true end
end

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if unit.inCombat() then return false end
    -- Earth Shield on the group's tank
    if ui.checked("Earth Shield") and unit.inGroup() and spell.earthShield.known() then
        for i = 1, #units.friends do
            local friend = units.friends[i].unit
            if unit.role(friend) == "TANK" and not buff.earthShield.exists(friend, "any") and unit.distance(friend) < 40 then
                if cast.earthShield(friend) then ui.debug("Casting Earth Shield on " .. unit.name(friend)) return true end
            end
        end
    end
    -- Resurrect a dead group member
    if ui.checked("Ancestral Spirit") and not unit.moving() then
        local dead = unit.deadGroupMember(30)
        if dead and cast.ancestralSpirit(dead) then ui.debug("Casting Ancestral Spirit on " .. unit.name(dead)) return true end
    end
    -- Totemic Call for totems left behind
    if ui.checked("Totemic Call") and spell.totemicRecall.known() and #enemies.yards40 == 0 then
        local leftBehind = false
        for _, element in ipairs({ totem.fire, totem.earth, totem.water, totem.air }) do
            if element.active() and element.distance() >= 30 then leftBehind = true end
        end
        if leftBehind and cast.totemicRecall() then ui.debug("Casting Totemic Call") return true end
    end
    -- Pull: from range with Lightning Bolt, or start swinging at a mob you walked up to. Neutral
    -- mobs count (you targeted it); players never do (it would flag you for PvP).
    if unit.valid("target") and unit.canAttack("target") and not unit.player("target") then
        local distance = unit.distance("target")
        if distance > 8 and not unit.moving() and (not melee or ui.checked("Pull with Lightning Bolt")) then
            if cast.lightningBolt("target") then ui.debug("Casting Lightning Bolt [Pull]") return true end
        end
        if distance < 5 and not cast.auto.autoAttack() then
            unit.startAttack()
            ui.debug("Casting Auto Attack [Pull]")
            return true
        end
    end
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    mana = power.mana
    if ui.mode.style == 2 then melee = true
    elseif ui.mode.style == 3 then melee = false
    else melee = not (spell.elementalMastery.known() or spell.totemOfWrath.known()) end

    enemies.get(8)
    enemies.get(20)
    enemies.get(40)

    if ui.pause() or ui.mode.rotation == 4 or unit.mounted() or unit.flying() or unit.taxi() then return true end

    if actionList.Defensive() then return true end
    if actionList.Extra() then return true end
    if actionList.PreCombat() then return true end
    if unit.inCombat() and unit.valid("target") then
        if actionList.Interrupt() then return true end
        if ui.checked("Purge") and power.mana.percent() > 35 and cast.dispel.purge("target") then
            if cast.purge("target") then ui.debug("Casting Purge") return true end
        end
        if actionList.Cooldown() then return true end
        if actionList.Totems() then return true end
        if melee then
            if actionList.Melee() then return true end
        else
            if actionList.Caster() then return true end
        end
    end
end

registerRotation({
    name      = rotationName,
    specID    = 261, -- TBC Shaman class-level spec ID
    expansion = "TBC",
    author    = "Earthcaller",
    patch     = "2.5.6",
    coverage  = "90%",
    status    = "Full",
    readiness = "Untested",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})
