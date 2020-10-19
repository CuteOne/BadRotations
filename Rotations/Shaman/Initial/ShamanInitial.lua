local rotationName = "Initial Druid" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.lightningBolt },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.chainLightning },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.lightningBolt },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.primalStrike}
    };
    CreateButton("Rotation",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.healingSurge },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.healingSurge }
    };
    CreateButton("Defensive",2,0)
    -- Ghost Wolf Button
    GhostWolfModes = {
        [1] = { mode = "Moving", value = 1, overlay = "Moving Enabled", tip = "Will Ghost Wolf when movement detected", highlight = 1, icon = br.player.spell.ghostWolf},
        [2] = { mode = "Hold", value = 2, overlay = "Hold Enabled", tip = "Will Ghost Wolf when key is held down", highlight = 0, icon = br.player.spell.ghostWolf},
    };
    CreateButton("GhostWolf",3,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General Version 1.0")
            br.ui:createCheckbox(section,"OOC Healing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.")
             -- Ghost Wolf
             br.ui:createCheckbox(section, "Auto Ghost Wolf", "|cff0070deCheck this to automatically control GW transformation based on toggle bar setting.")
             br.ui:createDropdownWithout(section, "Ghost Wolf Key",br.dropOptions.Toggle,6,"|cff0070deSet key to hold down for Ghost Wolf")
             br.ui:createCheckbox(section, "Flametongue", "|cff0070deCheck this to keep flametongue weapon enchant up.")
             br.ui:createCheckbox(section, "Lightning Shield", "|cff0070deCheck this to keep lightning shield up.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healing Surge
            br.ui:createSpinner(section, "Healing Surge",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
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
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local cast
local cd
local comboPoints
local debuff
local enemies
local energy
local inCombat
local mode
local ui
local unit
local units
local spell
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local profileStop
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}
local wolf                                          
local movingTimer

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
-- Time Moving
local function timeMoving()
    if movingTimer == nil then movingTimer = GetTime() end
    if not unit.moving() then
        movingTimer = GetTime()
    end
    return GetTime() - movingTimer
end
local function ghostWolf()
    -- Ghost Wolf
    if not (IsMounted() or IsFlying()) and isChecked("Auto Ghost Wolf") then
       if mode.ghostWolf == 1 then
           if ((#enemies.yards20 == 0 and not inCombat) or (#enemies.yards10 == 0 and inCombat)) and isMoving("player") and not buff.ghostWolf.exists() then
               if cast.ghostWolf() then br.addonDebug("Casting Ghost Wolf") end
           elseif movingCheck and buff.ghostWolf.exists() and br.timer:useTimer("Delay",0.5) then
               RunMacroText("/cancelAura Ghost Wolf")
           end
       elseif mode.ghostWolf == 2 then
           if not buff.ghostWolf.exists() and isMoving("player") then 
               if SpecificToggle("Ghost Wolf Key")  and not GetCurrentKeyBoardFocus() then
                   if cast.ghostWolf() then br.addonDebug("Casting Ghost Wolf") end
               end
           elseif buff.ghostWolf.exists() then
               if SpecificToggle("Ghost Wolf Key") then
                   return
               else
                   if br.timer:useTimer("Delay",0.25) then
                       RunMacroText("/cancelAura Ghost Wolf")
                   end
               end
           end
       end        
   end
end

--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
-- Action List - Extra
actionList.Extra = function()
    if ui.checked("Flametongue") then
        if select(4, GetWeaponEnchantInfo()) ~= 5400 then
            if cast.flametongue() then return true end
        end

    end
    if ui.checked("Lightning Shield") then
        if not buff.lightningShield.exists() then
            if cast.lightningShield() then return true end
        end
    end
    -- -- Auto Shapeshift
    -- if (not buff.travelForm.exists() and unit.moving() and timeMoving() > ui.value("Shift Wait Time")) or unit.inCombat() then
    --     local formValue = ui.mode.form
    --     -- Bear Form
    --     if formValue == 3 and unit.level() >= 8 and cast.able.bearForm() and not buff.bearForm.exists() then
    --         if cast.bearForm() then ui.debug("Casting Bear Form") return true end
    --     end
    --     -- Caster Form
    --     if unit.level() < 5 or (formValue == 1 and (buff.bearForm.exists() or buff.catForm.exists())) then
    --         RunMacroText("/CancelForm")
    --         ui.debug("Casting Caster Form")
    --         return true
    --     end
    --     --Cat Form
    --     if (formValue == 2 or (formValue == 3 and unit.level() < 8)) and unit.level() >= 5 and cast.able.catForm() and not buff.catForm.exists() then
    --         if cast.catForm() then ui.debug("Casting Cat Form") return true end
    --     end
    -- end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
       if ui.checked("Healing Surge") and not unit.moving() then
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
    -- if not unit.inCombat() then
    --     if unit.valid("target") then
    --         local thisDistance = unit.distance("target") or 99
    --         if not (buff.catForm.exists() or buff.bearForm.exists()) and thisDistance < 40 then
    --             if cast.able.wrath("target") and (unit.level() < 2 or not cast.last.wrath() or not unit.inCombat()) then
    --                 if cast.wrath("target") then ui.debug("Casting Wrath [Pre-Pull]") return true end
    --             end
    --         end
    --         if thisDistance < 5 then
    --             -- Shred
    --             if cast.able.shred() and buff.catForm.exists() then
    --                 if cast.shred() then ui.debug("Casting Shred [Pre-Pull]") return true end
    --             end
    --             -- Auto Attack
    --             if not IsAutoRepeatSpell(GetSpellInfo(6603)) then
    --                 StartAttack(units.dyn5)
    --             end
    --         end
    --     end
    -- end
    if unit.distance("target") > 5 then
        if cast.flameShock() then return end
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
    buff                                        = br.player.buff
    cast                                        = br.player.cast
    cd                                          = br.player.cd
    comboPoints                                 = br.player.power.comboPoints.amount()
    debuff                                      = br.player.debuff
    enemies                                     = br.player.enemies
    energy                                      = br.player.power.energy.amount()
    inCombat                                    = br.player.inCombat
    mode                                        = br.player.ui.mode
    ui                                          = br.player.ui
    unit                                        = br.player.unit
    units                                       = br.player.units
    spell                                       = br.player.spell
    -- General Locals
    movingTimer                                 = timeMoving()
    profileStop                                 = profileStop or false
    haltProfile                                 = (inCombat and profileStop) or pause() or ui.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    -- Enemies
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(10) -- Makes a varaible called, enemies.yards10
    enemies.get(20) -- Makes a varaible called, enemies.yards20
    enemies.get(40) -- Makes a varaible called, enemies.yards40

    -- Profile Specific Locals
    wolf                                        = br.player.buff.ghostWolf.exists()

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        return true
    else
        ghostWolf()
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        if not inCombat and not IsMounted() and not drinking then
            if (buff.ghostWolf.exists() and mode.ghostWolf == 1) or not buff.ghostWolf.exists() then
                actionList.Extra()
                if isChecked("OOC Healing") then
                    actionList.PreCombat()
                end
                -- Purify Spirit
                -- if br.player.ui.mode.decurse == 1 and cd.purifySpirit.remain() <= gcd then
                --     for i = 1, #friends.yards40 do
                --         if canDispel(br.friend[i].unit,spell.purifySpirit) then
                --             if cast.purifySpirit(br.friend[i].unit) then br.addonDebug("Casting Purify Spirit") return end
                --         end
                --     end
                -- end
            end
        end -- End Out of Combat Rotation
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
        if inCombat and unit.valid("target") and cd.global.remain() == 0 then
            if (buff.ghostWolf.exists() and mode.ghostWolf == 1) or not buff.ghostWolf.exists() then
                if unit.distance("target") > 5 then
                    if not debuff.flameShock.exists("target") then
                        if cast.flameShock() then return end
                    end
                    if cast.lightningBolt() then return end
                end
                ------------------------
                --- In Combat - Main ---
                ------------------------
                -- Melee in melee range
                if unit.distance(units.dyn5) < 5 then
                    -- Start Attack
                    if not IsAutoRepeatSpell(GetSpellInfo(6603)) then
                        StartAttack(units.dyn5)
                    end
                    if cast.primalStrike() then return end
                end
            end
               
        end -- End In Combat Rotation
    end -- Pause
    return true
end -- End runRotation
local id = 1444 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})