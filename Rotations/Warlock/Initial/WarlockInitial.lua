local rotationName = "Overlord"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.shadowBolt },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.soulShards }
    };
    CreateButton("Rotation",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.unendingResolve},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.unendingResolve}
    };
    CreateButton("Defensive",2,0)
    --Pet summon
    PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Imp", tip = "Summon Imp", highlight = 1, icon = br.player.spell.summonImp },
        [2] = { mode = "2", value = 2 ,overlay = "Voidwalker", tip = "Summon Voidwalker", highlight = 1, icon = br.player.spell.summonVoidwalker },
        [3] = { mode = "None", value = 3 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.fear }
    };
    CreateButton("PetSummon",3,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Corruption
            br.ui:createCheckbox(section, "Use Corruption")
            -- Curse of Weakness
            br.ui:createCheckbox(section, "Use Curse of Weakness")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Drain Life
            br.ui:createSpinner(section, "Drain Life", 40, 0, 100, 5, "|cffFFFFFFPet Health Percent to Cast At")
            -- Health Funnel
            br.ui:createSpinner(section, "Health Funnel", 30, 0, 95, 5, "|cffFFFFFFPet Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Player Limit", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to not use below.")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  95,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Unending Resolve
            br.ui:createSpinner(section, "Unending Resolve", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
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
        if cast.drainLife() then ui.debug("Channeling Drain Life") return true end
    end
    -- Health Funnel
    if cast.able.healthFunnel() and unit.hp("pet") <= ui.value("Health Funnel") and unit.hp("player") > ui.value("Player Limit") then
        if cast.healthFunnel("pet") then ui.debug("Channeling Health Funnel") return true end
    end
    -- Healthstone
    if ui.checked("Healthstone") then
        if use.able.healthstone() and unit.inCombat() and has.healthstone() and unit.hp() <= ui.value("Healthstone") then
            if use.healthstone() then ui.debug("Using Healthstone") return true end
        end
        if cast.able.createHealthstone() and not has.healthstone() and not ui.fullBags() then
            if cast.createHealthstone() then ui.debug("Casting Create Healthstone") return true end
        end
    end
    -- Unending Resolve
    if ui.checked("Unending Resolve") and unit.hp() <= ui.value("Unending Resolve") and unit.inCombat() then
        if cast.unendingResolve() then ui.debug("Casting Unending Resolve") return true end
    end

end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()
    --actions.precombat+=/summon_pet
    if not unit.moving() and unit.level() >= 3 and GetTime() - br.pauseTime > 0.5
        and br.timer:useTimer("summonPet", 1)
    then
        if (mode.petSummon == 1 or (mode.petSummon == 2 and not spell.known.summonVoidwalker())) and not pet.imp.active() then
            if cast.summonImp("player") then return true end
        end
        if mode.petSummon == 2 and spell.known.summonVoidwalker() and not pet.voidwalker.active() then
            if cast.summonVoidwalker("player") then return true end
        end
        if mode.petSummon == 3 and (pet.imp.active() or pet.voidwalker.active()) then
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
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    debuff                                        = br.player.debuff
    has                                           = br.player.has
    mode                                          = br.player.ui.mode
    ui                                            = br.player.ui
    pet                                           = br.player.pet
    spell                                         = br.player.spell
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    -- General Locals
    profileStop                                   = profileStop or false
    haltProfile                                   = (unit.inCombat() and profileStop) or IsMounted() or pause() or mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40,true)

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
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    StartAttack(units.dyn5)
                end
                --Corruption
                if cast.able.corruption() and ui.checked("Use Corruption")
                    and debuff.corruption.refresh(units.dyn40) and not unit.moving() then
                    if cast.corruption() then br.addonDebug("Casting Corruption") return true end
                end
                -- Curse of Weakness
                if cast.able.curseOfWeakness() and ui.checked("Use Curse of Weakness") and debuff.curseOfWeakness.refresh(units.dyn40AoE) then
                    if cast.curseOfWeakness() then ui.debug("Casting Curse of Weakness") return true end
                end
                -- Shadow Bolt
                if cast.able.shadowBolt() and not unit.moving() then
                    if cast.shadowBolt() then ui.debug("Casting Shadow Bolt") return true end
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 1454 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})