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

----------------
--- ROTATION ---
----------------
    local function runRotation()
        if br.timer:useTimer("debugDiscipline", 0.1) then
            --print("Running: "..rotationName)

    ---------------
    --- Toggles --- -- List toggles here in order to update when pressed
    ---------------

    --------------
    --- Locals ---
    --------------
            local artifact                                      = br.player.artifact
            local buff                                          = br.player.buff
            local cast                                          = br.player.cast
            local combatTime                                    = getCombatTime()
            local cd                                            = br.player.cd
            local charges                                       = br.player.charges
            local debuff                                        = br.player.debuff
            local enemies                                       = br.player.enemies
            local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
            local gcd                                           = br.player.gcd
            local healPot                                       = getHealthPot()
            local inCombat                                      = br.player.inCombat
            local inInstance                                    = br.player.instance=="party"
            local inRaid                                        = br.player.instance=="raid"
            local level                                         = br.player.level
            local lowestHP                                      = br.friend[1].unit
            local mode                                          = br.player.mode
            local perk                                          = br.player.perk        
            local php                                           = br.player.health
            local power, powmax, powgen                         = br.player.power, br.player.powerMax, br.player.powerRegen
            local pullTimer                                     = br.DBM:getPulltimer()
            local race                                          = br.player.race
            local racial                                        = br.player.getRacial()
            local recharge                                      = br.player.recharge
            local spell                                         = br.player.spell
            local talent                                        = br.player.talent
            local ttm                                           = br.player.timeToMax
            local units                                         = br.player.units
            
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