-- Editor types: the keys of Retail Warlock Initial's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.Retail.Warlock.Initial.buff]]
local cast = cast --[[@as BR.Retail.Warlock.Initial.cast]]
local cd = cd --[[@as BR.Retail.Warlock.Initial.cd]]
local charges = charges --[[@as BR.Retail.Warlock.Initial.charges]]
local debuff = debuff --[[@as BR.Retail.Warlock.Initial.debuff]]
local equiped = equiped --[[@as BR.Retail.Warlock.Initial.equiped]]
local glyph = glyph --[[@as BR.Retail.Warlock.Initial.glyph]]
local has = has --[[@as BR.Retail.Warlock.Initial.has]]
local heroTree = heroTree --[[@as BR.Retail.Warlock.Initial.heroTree]]
local imbues = imbues --[[@as BR.Retail.Warlock.Initial.imbues]]
local spell = spell --[[@as BR.Retail.Warlock.Initial.spell]]
local talent = talent --[[@as BR.Retail.Warlock.Initial.talent]]
local totem = totem --[[@as BR.Retail.Warlock.Initial.totem]]
local use = use --[[@as BR.Retail.Warlock.Initial.use]]

local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "On", icon = "shadowBolt", overlay = "Rotation Enabled", tip = "Enable Rotation" },
        { name = "Off", icon = "fear", overlay = "Rotation Disabled", tip = "Disable Rotation" },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "unendingResolve", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "unendingResolve", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("PetSummon", { modes = {
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
    section = ui.section("General")
    -- Basic Trinket Module
    module.BasicTrinkets(nil, section)
    -- Corruption
    ui.checkbox(section, "Use Corruption")
    -- Curse of Weakness
    ui.checkbox(section, "Use Curse of Weakness")
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    -- Basic Healing Module
    module.BasicHealing(section)
    -- Drain Life
    ui.spinner(section, "Drain Life", { value = 40, tip = "Pet Health Percent to Cast At" })
    -- Health Funnel
    ui.spinner(section, "Health Funnel", { value = 30, max = 95, tip = "Pet Health Percent to Cast At" })
    ui.spinner(section, "Player Limit", { value = 70, checkbox = false, tip = "Health Percent to not use below." })
    -- Unending Resolve
    ui.spinner(section, "Unending Resolve", { value = 50, tip = "Health Percent to Cast At" })
end

--------------
--- Locals ---
--------------
-- BR API Locals
local mode
-- General Locals
local haltProfile
local profileStop
-- Profile Specific Locals
local actionList = {}

--------------------
--- Action Lists ---
--------------------

-- Action List - Extra
actionList.Extras = function()
    -- Summon Pet
    if not unit.moving() and unit.level() >= 3 and ui.time() - var.pauseTime > 0.5
        and ui.timer("summonPet", 1)
    then
        if (mode.petSummon == 1 or (mode.petSummon == 2 and not spell.summonVoidwalker.known())) and not pet.imp.active() then
            if cast.summonImp("player") then return true end
        end
        if mode.petSummon == 2 and spell.summonVoidwalker.known() and not pet.voidwalker.active() then
            if cast.summonVoidwalker("player") then return true end
        end
        if mode.petSummon == 3 and (pet.imp.active() or pet.voidwalker.active()) then
            pet.dismiss()
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    -- Basic Healing Module
    module.BasicHealing()
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
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Corruption
            if cast.able.corruption("target") and ui.checked("Use Corruption")
                and debuff.corruption.refresh("target") and not unit.moving()
                and cast.timeSinceLast.corruption("target") > unit.gcd(true) + 2
            then
                if cast.corruption("target") then
                    ui.debug("Casting Corruption [Precombat]")
                    return true
                end
            end
            -- Shadow Bolt
            if cast.able.shadowBolt("target") and not unit.moving() then
                if cast.shadowBolt("target") then
                    ui.debug("Casting Shadow Bolt [Precombat]")
                    return true
                end
            end
            -- Start Attack
            if cast.able.autoAttack("target") then
                if cast.autoAttack("target") then
                    ui.debug("Casting Auto Attack [Precombat]")
                    return true
                end
            end
        end
    end
end -- End Action List - PreCombat

actionList.Combat = function()
    if unit.valid("target") and cd.global.remain() == 0 then
        if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
            -- Start Attack
            if cast.able.autoAttack() then
                if cast.autoAttack() then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
            -- Corruption
            if ui.checked("Use Corruption") and not unit.moving() then
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if cast.able.corruption(thisUnit) and debuff.corruption.refresh(thisUnit) then
                        if cast.corruption(thisUnit) then
                            ui.debug("Casting Corruption")
                            return true
                        end
                    end
                end
            end
            -- if cast.able.corruption("target") and ui.checked("Use Corruption")
            --     and debuff.corruption.refresh("target") and not unit.moving()
            -- then
            --     if cast.corruption("target") then
            --         ui.debug("Casting Corruption")
            --         return true
            --     end
            -- end
            -- Curse of Weakness
            if cast.able.curseOfWeakness() and ui.checked("Use Curse of Weakness")
                and debuff.curseOfWeakness.refresh(units.dyn40)
            then
                if cast.curseOfWeakness() then
                    ui.debug("Casting Curse of Weakness")
                    return true
                end
            end
            -- Shadow Bolt
            if cast.able.shadowBolt() and not unit.moving() then
                if cast.shadowBolt() then
                    ui.debug("Casting Shadow Bolt")
                    return true
                end
            end
        end
    end
end -- End Action List - Combat
----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    mode        = ui.mode
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or unit.mounted() or ui.pause() or mode.rotation == 2
    -- Units
    units.get(5)  -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40, true)
    -- Enemies
    enemies.get(40, "player", false, true) -- Makes a variable called, enemies.yards40f

    -- Pause Timer
    if var.pauseTime == nil then var.pauseTime = ui.time() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        var.pauseTime = ui.time()
        return true
    else
        --------------
        --- Extras ---
        --------------
        if actionList.Extras() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        --------------
        --- Combat ---
        --------------
        if actionList.Combat() then return true end
    end         -- Pause
end             -- End runRotation
registerRotation({
    name      = rotationName,
    specID    = 1454,
    expansion = "Retail",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})
