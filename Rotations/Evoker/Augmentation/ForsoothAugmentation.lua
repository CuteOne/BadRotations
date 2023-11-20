local rotationName = "ForsoothAugmentation" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 0, icon = br.player.spell.whirlwind },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladestorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.furiousSlash },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
-- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.battleCry },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.battleCry },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.battleCry }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
-- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.enragedRegeneration },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.enragedRegeneration }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
-- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.pummel },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")

        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")

        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")

        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")    
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
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

---------------- -
--- ROTATION ---
----------------
local function runRotation()
    if br.timer:useTimer("debugFury", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        br.UpdateToggle("Rotation",0.25)
        br.UpdateToggle("Cooldown",0.25)
        br.UpdateToggle("Defensive",0.25)
        br.UpdateToggle("Interrupt",0.25)
--------------
--- Locals ---
--------------
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = br.getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = br.getFallTime(), br._G.IsSwimming(), br._G.IsFlying(), br._G.GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local healPot                                       = br.getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.ui.mode
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power, br.player.powerMax, br.player.powerRegen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttm                                           = br.player.timeToMax
        local ui                                            = br.player.ui
        local unit                                          = br.player.unit
        local units                                         = br.player.units
        local var                                           = br.player.variables
        
        if br.leftCombat == nil then br.leftCombat = br._G.GetTime() end
        if br.profileStop == nil then br.profileStop = false end

        -- Upheaval Stage
        if var.stageUpheaval == nil then var.stageUpheaval = 1 end
        if var.upheavalStage == nil or br.empowerID ~= spell.upheaval then var.upheavalStage = 0; end
        if cast.empowered.upheaval() > 0 then
            var.upheavalStage = cast.empowered.upheaval()
            
        end

        -- End Fire Breath Cast at Stage
        if var.stageUpheaval > 0 and var.upheavalStage == var.stageUpheaval then
            if cast.upheaval("player") then var.stageUpheaval = 0 ui.debug("Casting Upheaval at Empowered Stage "..var.upheavalStage) return true end
        end

--------------------
--- Action Lists ---
--------------------

-----------------
--- Rotations ---
-----------------
        -- Pause
        if br.pause() or (br.GetUnitExists("target") and (br.GetUnitIsDeadOrGhost("target") or not br._G.UnitCanAttack("target", "player"))) or mode.rotation == 4 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat then
                -- Maintain  Blistering Scales on a tank.
                if talent.blisteringScales then
                    for i = 1, #br.friend do
                        local thisUnit = br.friend[i].unit
                        local thisRole = unit.role(thisUnit)
                        if not buff.blisteringScales.exists(thisUnit) then
                            if (thisRole == "TANK") then cast.blisteringScales(thisUnit) end
                        end
                    end
                    if #br.friend == 1 and not buff.blisteringScales.exists() then
                        cast.blisteringScales()
                    end
                end
                if talent.sourceOfMagic then
                    for i = 1, #br.friend do
                        local thisUnit = br.friend[i].unit
                        local thisRole = unit.role(thisUnit)
                        if not buff.sourceOfMagic.exists(thisUnit) then
                            if (thisRole == "HEALER") then cast.sourceOfMagic(thisUnit) end
                        end
                    end
                end

            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat then
                -- Maintain  Prescience on two chosen DPS players.
                if talent.prescience then
                    for i = 1, #br.friend do
                        local thisUnit = br.friend[i].unit
                        local thisRole = unit.role(thisUnit)
                        if not buff.prescience.exists(thisUnit) then
                            if (thisRole == "DAMAGER") then cast.prescience(thisUnit) end
                        end
                    end
                    if #br.friend == 1 and not buff.prescience.exists() then
                        cast.prescience()
                    end
                end
                
                -- Maintain  Blistering Scales on a tank.
                if talent.blisteringScales then
                    for i = 1, #br.friend do
                        local thisUnit = br.friend[i].unit
                        local thisRole = unit.role(thisUnit)
                        if not buff.blisteringScales.exists(thisUnit) then
                            if (thisRole == "TANK") then cast.blisteringScales(thisUnit) end
                        end
                    end
                    if #br.friend == 1 and not buff.blisteringScales.exists() then
                        cast.blisteringScales()
                    end
                end
                --  Ebon Might (roughly every 30 seconds)
                if talent.ebonMight and cast.able.ebonMight() then
                    cast.ebonMight()
                end
                --  Fire Breath (uprank if you can benefit from  Leaping Flames, else rank 1)
                if cast.able.fireBreath("player","cone",1,25) and not unit.moving() and not cast.current.fireBreath() then
                    cast.fireBreath("player","cone",1,25)
                end
                --  Upheaval (uprank if increased radius is needed, else rank 1)
                if cast.able.upheaval() and not unit.moving() and not cast.current.upheaval() then
                    cast.upheaval()
                end
                --  Breath of Eons (roughly every 2 minutes)
                if cast.able.breathOfEons() then
                    cast.breathOfEons()
                end
                --  Time Skip (every second  Breath of Eons)
                if cast.able.timeSkip() then
                    cast.timeSkip()
                end
                --  Eruption
                if talent.eruption and cast.able.eruption() then
                    cast.eruption()
                end
                --  Living Flame (or  Azure Strike)
                if cast.able.livingFlame() then
                    cast.livingFlame()
                end
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation 
local id = 1473 --Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})