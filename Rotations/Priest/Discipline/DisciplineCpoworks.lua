if select(2, UnitClass("player")) == "PRIEST" then 
    local rotationName = "Cpoworks" 

---------------
--- Toggles ---
---------------
    local function createToggles()

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
            section = bb.ui:createSection(bb.ui.window.profile,  "General")

            bb.ui:checkSectionState(section)
            ------------------------
            --- COOLDOWN OPTIONS --- -- Define Cooldown Options
            ------------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Cooldowns")

            bb.ui:checkSectionState(section)
            -------------------------
            --- DEFENSIVE OPTIONS --- -- Define Defensive Options
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")

            bb.ui:checkSectionState(section)
            -------------------------
            --- INTERRUPT OPTIONS --- -- Define Interrupt Options
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
                -- Interrupt Percentage
                bb.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")    
            bb.ui:checkSectionState(section)
            ----------------------
            --- TOGGLE OPTIONS --- -- Degine Toggle Options
            ----------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Toggle Keys")
                -- Single/Multi Toggle
                bb.ui:createDropdown(section,  "Rotation Mode", bb.dropOptions.Toggle,  4)
                --Cooldown Key Toggle
                bb.ui:createDropdown(section,  "Cooldown Mode", bb.dropOptions.Toggle,  3)
                --Defensive Key Toggle
                bb.ui:createDropdown(section,  "Defensive Mode", bb.dropOptions.Toggle,  6)
                -- Interrupts Key Toggle
                bb.ui:createDropdown(section,  "Interrupt Mode", bb.dropOptions.Toggle,  6)
                -- Pause Toggle
                bb.ui:createDropdown(section,  "Pause Mode", bb.dropOptions.Toggle,  6)   
            bb.ui:checkSectionState(section)
        end
        optionTable = {{
            [1] = "Rotation Options",
            [2] = rotationOptions,
        }}
        return optionTable
    end

----------------
--- ROTATION ---
----------------
    local function runRotation()
        if bb.timer:useTimer("debugDiscipline", 0.1) then
            --print("Running: "..rotationName)

    ---------------
    --- Toggles --- -- List toggles here in order to update when pressed
    ---------------

    --------------
    --- Locals ---
    --------------
            local artifact                                      = bb.player.artifact
            local buff                                          = bb.player.buff
            local cast                                          = bb.player.cast
            local combatTime                                    = getCombatTime()
            local cd                                            = bb.player.cd
            local charges                                       = bb.player.charges
            local debuff                                        = bb.player.debuff
            local enemies                                       = bb.player.enemies
            local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
            local gcd                                           = bb.player.gcd
            local healPot                                       = getHealthPot()
            local inCombat                                      = bb.player.inCombat
            local inInstance                                    = bb.player.instance=="party"
            local inRaid                                        = bb.player.instance=="raid"
            local level                                         = bb.player.level
            local lowestHP                                      = bb.friend[1].unit
            local mode                                          = bb.player.mode
            local perk                                          = bb.player.perk        
            local php                                           = bb.player.health
            local power, powmax, powgen                         = bb.player.power, bb.player.powerMax, bb.player.powerRegen
            local pullTimer                                     = bb.DBM:getPulltimer()
            local race                                          = bb.player.race
            local racial                                        = bb.player.getRacial()
            local recharge                                      = bb.player.recharge
            local spell                                         = bb.player.spell
            local talent                                        = bb.player.talent
            local ttm                                           = bb.player.timeToMax
            local units                                         = bb.player.units
            
            if leftCombat == nil then leftCombat = GetTime() end
            if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------
            --Spread Atonement
            function actionList_SpreadAtonement()

            end
            -- Damage
            function actionList_Damage()
                --lightsWrath
                if cast.lightsWrath() then return end
                --powerWordSolace
                if cast.powerWordSolace() then return end
                --mindbBender
                if cast.mindBender() then return end
                --shadowfiend
                if cast.shadowfiend() then return end
                -- Purge The Wicked
                if getDebuffRemain(units.dyn40,204213,"player") <= 4 then
                    if cast.purgeTheWicked(units.dyn40) then return end 
                end
                -- Shadow Word: Pain
                if getDebuffRemain(units.dyn40,spell.shadowWordPain,"player") <= 4 then
                    if cast.shadowWordPain(units.dyn40) then return end 
                end
                --penance
                if cast.penance() then return end
                --schism
                if power > 20 then
                    if cast.schism() then return end
                end
                --smite
                if power > 20 then
                    if cast.smite() then return end
                end
            end

-----------------
--- Rotations ---
-----------------
            -- Pause
            if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 4 then
                return true
            else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
                if not inCombat and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then

                end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
                if inCombat then

                    actionList_SpreadAtonement()
                    actionList_Damage()

                end -- End In Combat Rotation
            end -- Pause
        end -- End Timer
    end -- End runRotation 
    tinsert(cDiscipline.rotations, { 
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end -- End Select Warrior