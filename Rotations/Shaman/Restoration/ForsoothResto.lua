local rotationName = "ForsoothResto"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.lightningBolt },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.chainLightning },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.lightningBolt },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.primalStrike}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.healingSurge },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.healingSurge }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
    -- Ghost Wolf Button
    local GhostWolfModes = {
        [1] = { mode = "Moving", value = 1, overlay = "Moving Enabled", tip = "Will Ghost Wolf when movement detected", highlight = 1, icon = br.player.spell.ghostWolf},
        [2] = { mode = "Hold", value = 2, overlay = "Hold Enabled", tip = "Will Ghost Wolf when key is held down", highlight = 0, icon = br.player.spell.ghostWolf},
    };
    br.ui:createToggle(GhostWolfModes,"GhostWolf",3,0)
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
        section = br.ui:createSection(br.ui.window.profile,  "General Version 1.0")
            -- Basic Trinket Module
            br.player.module.BasicTrinkets(nil,section)
            -- Ghost Wolf
            br.ui:createCheckbox(section, "Auto Ghost Wolf", "|cff0070deCheck this to automatically control GW transformation based on toggle bar setting.")
            br.ui:createSpinnerWithout(section, "Ghost Wolf Shift Delay", 2, 0, 5, 1, "|cff0070deSet to desired time to wait before shifting into Ghost Wolf.")
            br.ui:createDropdownWithout(section, "Ghost Wolf Key",br.dropOptions.Toggle,6,"|cff0070deSet key to hold down for Ghost Wolf")
            -- FLametongue Weapon
            br.ui:createCheckbox(section, "Flametongue Weapon", "|cff0070deCheck this to keep flametongue weapon enchant up.")
            -- Lightning Shield
            br.ui:createCheckbox(section, "Lightning Shield", "|cff0070deCheck this to keep lightning shield up.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Healing Surge
            br.ui:createSpinner(section, "Healing Surge",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- OOC Healing
            br.ui:createCheckbox(section,"OOC Healing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
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
local buff
local cast
local cd
local debuff
local enemies
local module
local ui
local unit
local units
local var
local actionList = {}
local tanks
local lowest
local spell
-----------------
--- Functions ---
-----------------
local function ghostWolf()
    -- Ghost Wolf
    local moveTimer = unit.movingTime()
    if not (unit.mounted() or unit.flying()) and ui.checked("Auto Ghost Wolf") then
        if ui.mode.ghostWolf == 1 then
            if cast.able.ghostWolf() and ((#enemies.yards20 == 0 and not unit.inCombat()) or (#enemies.yards10 == 0 and unit.inCombat()))
                and unit.moving() and moveTimer > ui.value("Ghost Wolf Shift Delay") and not buff.ghostWolf.exists()
            then
                if cast.ghostWolf("player") then ui.debug("Casting Ghost Wolf [Moving]") end
            end
       elseif ui.mode.ghostWolf == 2 then
            if cast.able.ghostWolf() and not buff.ghostWolf.exists() and unit.moving() then 
                if ui.toggle("Ghost Wolf Key") then
                    if cast.ghostWolf("player") then ui.debug("Casting Ghost Wolf [Keybind]") end
                end
            elseif buff.ghostWolf.exists() then
                if ui.toggle("Ghost Wolf Key") then return end
            end
        end
    end
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- FLametongue Weapon
    if ui.checked("Flametongue Weapon") and cast.able.flametongueWeapon() and not unit.weaponImbue.exists() then
        if cast.flametongueWeapon("player") then ui.debug("Casting Flametongue Weapon") return true end
    end
    -- Ghost Wolf
    ghostWolf()
    -- Lightning Shield
    if ui.checked("Lightning Shield") and cast.able.lightningShield() and not buff.lightningShield.exists() then
        if cast.lightningShield("player") then ui.debug("Casting Lightning Shield") return true end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Healing Surge
        if ui.checked("Healing Surge") and cast.able.healingSurge() and not unit.moving() then
            if unit.friend("target") and unit.hp("target") <= ui.value("Healing Surge") then
                if cast.healingSurge("target") then ui.debug("Casting Healing Surge on "..unit.name("target")) return true end
            elseif unit.hp("player") <= ui.value("Healing Surge") then
                if cast.healingSurge("player") then ui.debug("Casting Healing Surge on "..unit.name("player")) return true end
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and unit.distance("target") > 5 then
        -- Lightning Bolt
        if cast.able.lightningBolt() and not unit.moving() then
            if cast.lightningBolt() then ui.debug("Casting Lightning Bolt [Pre-Combat]") return true end
        end
        -- Flame Shock
        if cast.able.flameShock() then
            if cast.flameShock() then ui.debug("Casting Flame Shock [Pre-Combat]") return true end
        end
    end
end -- End Action List - PreCombat

actionList.cds = function()
    -- ancestral guidance

    -- spirit link totem

    -- earth wall totem

    -- mana tide totem

    -- healing tide totem

    -- ascendance


end

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                        = br.player.buff
    cast                                        = br.player.cast
    cd                                          = br.player.cd
    debuff                                      = br.player.debuff
    enemies                                     = br.player.enemies
    module                                      = br.player.module
    ui                                          = br.player.ui
    unit                                        = br.player.unit
    units                                       = br.player.units
    var                                         = br.player.variables
    spell = br.player.spell
    -- General Locals
    var.profileStop                             = var.profileStop or false
    var.haltProfile                             = (unit.inCombat() and var.profileStop) or (unit.mounted() or unit.flying()) or ui.pause() or ui.mode.rotation==4
    -- Units
    units.get(5)
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(10)
    enemies.get(20)
    enemies.get(40)

    tanks = br.getTanksTable()
    lowest = {}
    lowest.unit = "player"
    lowest.hp = 100
    for i = 1, #br.friend do
        if br.friend[i].hp < lowest.hp then
            lowest = br.friend[i]
        end
    end


    -- Cancel Lightning Bolt in Melee
    if unit.distance("target") < 5 and cast.current.lightningBolt() and unit.level() > 1 then
        if cast.cancel.lightningBolt() then ui.debug("Canceled Lightning Bolt Cast [Melee Range]") end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if unit.mounted() then
        var.profileStop = false
    else
        -- Cooldowns
        actionList.cds()
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
        if not unit.inCombat() then
            -- Water Shield
            if cast.able.waterShield() and not buff.waterShield.exists() then
                cast.waterShield()
            end

            -- Earth Shield on self
            if cast.able.earthShield() and not buff.earthShield.exists("player") then
                cast.earthShield("player")
            end

            -- Earth Shield on tank
            if #tanks > 0 then
                if cast.able.earthShield() and not buff.earthShield.exists(tanks[1].unit) then
                    cast.earthShield(tanks[1].unit)
                end
            end
            -- Earthliving weapon
            if cast.able.earthlivingWeapon() and not buff.earthlivingWeapon.exists() then
                cast.earthlivingWeapon()
            end
            -- Chain Heal
            if cast.able.chainHeal() then
                br.chainHealUnits(spell.chainHeal, 15, 85, 4)
            end
            
            -- Healing Surge
            if cast.able.healingSurge() and lowest.hp <= 65 then
                cast.healingSurge()
            end

            -- Healing Wave
            if cast.able.healingWave() and lowest.hp <= 85 then
                cast.healingWave(lowest.unit)
            end

            -- Riptide (use on needed player)
            if cast.able.riptide() and lowest.hp < 100 then
                cast.riptide(lowest.unit)
            end
        else
        if cd.global.remain() == 0 then
            -- Start Attack
            if cast.able.autoAttack("target") then
                if cast.autoAttack("target") then ui.debug("Casting Auto Attack") return true end
            end

            -- Water Shield
            if cast.able.waterShield() and not buff.waterShield.exists() then
                cast.waterShield()
            end

            -- Earth Shield on self
            if cast.able.earthShield() and not buff.earthShield.exists("player") then
                cast.earthShield("player")
            end

            -- Earth Shield on tank
            if #tanks > 0 then
                if cast.able.earthShield() and not buff.earthShield.exists(tanks[1].unit) then
                    cast.earthShield(tanks[1].unit)
                end
            end

            -- Earthliving weapon
            if cast.able.earthlivingWeapon() and not buff.earthlivingWeapon.exists() then
                cast.earthlivingWeapon()
            end

            -- Healing Rain
            if cast.able.healingRain() then
                br.castWiseAoEHeal(br.friend,spell.healingRain,10,95,2,5,false,true)
            end 

            -- Chain Heal
            if cast.able.chainHeal() then
                br.chainHealUnits(spell.chainHeal, 15, 85, 4)
            end

            -- Riptide (use on needed player)
            if cast.able.riptide() and lowest.hp < 100 then
                cast.riptide(lowest.unit)
            end

            
            -- Healing Surge
            if cast.able.healingSurge() and lowest.hp <= 65 then
                cast.healingSurge(lowest.unit)
            end
            -- Healing Wave
            if cast.able.healingWave() and lowest.hp <= 85 then
                cast.healingWave(lowest.unit)
            end

            -- Cloudburst Totem (use on cooldown)
            if cast.able.cloudburstTotem() then
                cast.cloudburstTotem()
            end

            -- Lightning Bolt
            if cast.able.lightningBolt() then
                cast.lightningBolt()
            end
        end

        end -- End In Combat Rotation
    end -- Pause
    return true
end -- End runRotation
local id = 264
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})