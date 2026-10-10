local rotationName = "BrewDestro"

---------------
--- Toggles ---
---------------
local function toggles()
    br.ui:toggle("Rotation", { key = "RightShift", modes = {
        { name = "On", icon = "shadowBolt", overlay = "Rotation Enabled", tip = "Enable Rotation" },
        { name = "Off", icon = "soulShards", overlay = "Rotation Disabled", tip = "Disable Rotation" },
    } })
    br.ui:toggle("Defensive", { modes = {
        { name = "On", icon = "unendingResolve", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "unendingResolve", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    br.ui:toggle("PetSummon", { modes = {
        { name = "1", icon = "summonImp", overlay = "Imp", tip = "Summon Imp" },
        { name = "2", icon = "summonVoidwalker", overlay = "Voidwalker", tip = "Summon Voidwalker", highlight = true },
        { name = "None", icon = "fear", overlay = "No pet", tip = "Dont Summon any Pet" },
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
    -- Corruption
    br.ui:checkbox(section, "Use Corruption")
    -- Curse of Weakness
    br.ui:checkbox(section, "Use Curse of Weakness")
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = br.ui:section("Defensive")
    -- Drain Life
    br.ui:spinner(section, "Drain Life", { value = 40, tip = "Pet Health Percent to Cast At" })
    -- Health Funnel
    br.ui:spinner(section, "Health Funnel", { value = 30, max = 95, tip = "Pet Health Percent to Cast At" })
    br.ui:spinner(section, "Player Limit", { value = 70, checkbox = false, tip = "Health Percent to not use below." })
    -- Healthstone
    br.ui:spinner(section, "Healthstone", { value = 60, max = 95, tip = "Health Percent to Cast At" })
    -- Unending Resolve
    br.ui:spinner(section, "Unending Resolve", { value = 50, tip = "Health Percent to Cast At" })
end

--------------
--- Locals ---
--------------
-- BR API Locals
local cast
local cd
local debuff
local has
local mode
local ui
local pet
local spell
local unit
local units
local use
local power
-- General Locals
local haltProfile
local profileStop
-- Profile Specific Locals
local actionList = {}

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive
actionList.Defensive = function()
    -- Drain Life
    if cast.able.drainLife(units.dyn40) and unit.hp() <= ui.value("Drain Life") and unit.inCombat() then
        if cast.drainLife() then
            ui.debug("Channeling Drain Life")
            return true
        end
    end
    -- Health Funnel
    if cast.able.healthFunnel() and unit.hp("pet") <= ui.value("Health Funnel") and unit.hp("player") > ui.value("Player Limit") then
        if cast.healthFunnel("pet") then
            ui.debug("Channeling Health Funnel")
            return true
        end
    end
    -- Healthstone
    if ui.checked("Healthstone") then
        if use.able.healthstone() and unit.inCombat() and has.healthstone() and unit.hp() <= ui.value("Healthstone") then
            if use.healthstone() then
                ui.debug("Using Healthstone")
                return true
            end
        end
        if cast.able.createHealthstone() and not has.healthstone() and not ui.fullBags() then
            if cast.createHealthstone() then
                ui.debug("Casting Create Healthstone")
                return true
            end
        end
    end
    -- Unending Resolve
    if ui.checked("Unending Resolve") and unit.hp() <= ui.value("Unending Resolve") and unit.inCombat() then
        if cast.unendingResolve() then
            ui.debug("Casting Unending Resolve")
            return true
        end
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()
    --actions.precombat+=/summon_pet
    if not unit.moving() and unit.level() >= 3 and GetTime() - br.pauseTime > 0.5
        and br.debug.timer:useTimer("summonPet", 1)
    then
        if (mode.petSummon == 1 or (mode.petSummon == 2 and not spell.summonVoidwalker.known())) and not UnitExists("pet") then
            if cast.summonImp("player") then return true end
        end
        if mode.petSummon == 2 and spell.summonVoidwalker.known() and not UnitExists("pet") then
            if cast.summonVoidwalker("player") then return true end
        end
        if mode.petSummon == 3 and (UnitExists("pet")) then
            PetDismiss()
        end
    end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    cast        = br.player.cast
    cd          = br.player.cd
    debuff      = br.player.debuff
    has         = br.player.has
    mode        = br.player.ui.mode
    ui          = br.player.ui
    pet         = br.player.pet
    spell       = br.player.spells
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    use         = br.player.use
    power       = br.player.power.soulShards()
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or IsMounted() or br.functions.misc:pause() or mode.rotation == 4
    -- Units
    units.get(5)  -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40, true)

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = GetTime() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        br.pauseTime = GetTime()
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
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
        -- Check for combat
        if unit.valid("target") and cd.global.remain() == 0 then
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                ------------------------------
                --- In Combat - Interrupts ---
                ------------------------------
                -- Start Attack
                -- actions=auto_attack
                if not C_Spell.IsAutoRepeatSpell(br._G.GetSpellInfo(29722)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    br._G.StartAttack(units.dyn5)
                end

                -- Curse of Weakness
                if cast.able.curseOfWeakness() and ui.checked("Use Curse of Weakness") and debuff.curseOfWeakness.refresh(units.dyn40AoE) then
                    if cast.curseOfWeakness() then
                        ui.debug("Casting Curse of Weakness")
                        return true
                    end
                end

                if cast.able.immolate() and not debuff.immolate.exists("target") then
                    if cast.immolate("target") then
                        ui.debug("Casting immolate")
                        return true
                    end
                end

                if power > 2 and cast.able.chaosBolt() then
                    if cast.chaosBolt("target") then
                        ui.debug("Casting Chaos Bolt")
                        return true
                    end
                end



                -- Shadow Bolt
                if cast.able.incinerate() and not unit.moving() then
                    if cast.incinerate() then
                        ui.debug("Casting incinerate")
                        return true
                    end
                end
            end -- End In Combat Rotation
        end
    end         -- Pause
end             -- End runRotation
br.loader.registerRotation({
    name      = rotationName,
    specID    = 267,
    expansion = "MOP",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})
