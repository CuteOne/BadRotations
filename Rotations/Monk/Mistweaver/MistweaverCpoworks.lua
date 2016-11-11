if select(2,UnitClass("player")) == "MONK" then -- Change to class id
    local rotationName = "Cpoworks" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
    local function createToggles() -- Define custom toggles
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.battleCry },
            [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.battleCry },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.battleCry }
        };
        CreateButton("Cooldown",1,0)
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
                --Healing Elixir
                bb.ui:createSpinner(section, "Healing Elixir",  45,  0,  100,  5,  "Health Percent to Cast At")
                --Enveloping Mists
                bb.ui:createSpinner(section, "Mana Tea",  70,  0,  100,  5,  "Mana Percent to Cast At")
                --Detox
                bb.ui:createCheckbox(section, "Detox")
                --bb.ui:createDropdownWithout(section, "Detox Mode", {"|cffFFFFFFMouseover","|cffFFFFFFRaid"}, 1, "|cffFFFFFFDetox usage.")
            bb.ui:checkSectionState(section)
            section = bb.ui:createSection(bb.ui.window.profile, "Single Target Healing")
                --Thunder Focus Tea
                bb.ui:createSpinner(section, "Thunder Focus Tea",  50,  0,  100,  5,  "Health Percent to Cast At")
                --Renewing Mist
                bb.ui:createSpinner(section, "Renewing Mist STH",  99,  0,  100,  1,  "Health Percent to Cast At")
                --Enveloping Mists
                bb.ui:createSpinner(section, "Enveloping Mist STH",  70,  0,  100,  5,  "Health Percent to Cast At")
                --Sheiluns Gift
                bb.ui:createSpinner(section, "Sheiluns Gift STH",  65,  0,  100,  5,  "Health Percent to Cast At")
                --Effuse
                bb.ui:createSpinner(section, "Effuse STH",  85,  0,  100,  5,  "Health Percent to Cast At")
                --Vivify
                bb.ui:createSpinner(section, "Vivify STH",  60,  0,  100,  5,  "Health Percent to Cast At")
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
        if bb.timer:useTimer("debugMistweaver", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
            --print("Running: "..rotationName)

    ---------------
    --- Toggles --- -- List toggles here in order to update when pressed
    ---------------
            UpdateToggle("Rotation",0.25)
            UpdateToggle("Cooldown",0.25)
            UpdateToggle("Defensive",0.25)
            UpdateToggle("Interrupt",0.25)
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
            
            local lowest                                        = {}    --Lowest Unit
            lowest.hp                                           = bb.friend[1].hp
            lowest.role                                         = bb.friend[1].role
            lowest.unit                                         = bb.friend[1].unit
            lowest.range                                        = bb.friend[1].range
            lowest.guid                                         = bb.friend[1].guid                      
            local tank                                          = {}    --Tank
            local averageHealth                                 = 100

            if leftCombat == nil then leftCombat = GetTime() end
            if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------

-----------------
--- Rotations ---
-----------------
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then

            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat then

                if isChecked("Healing Elixir") then
                    for i = 1, #bb.friend do                           
                        if php <= getValue("Healing Elixir") then
                            if cast.healingElixir("player") then return end     
                        end
                    end
                end

                if isChecked("Mana Tea") then
                    for i = 1, #bb.friend do                           
                        if power <= getValue("Mana Tea") then
                            if cast.manaTea("player") then return end     
                        end
                    end
                end

                -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                --Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing--
                -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                --Detox
                if isChecked("Detox") then
                    -- if getValue("Detox Mode") == 1 then -- Mouseover
                    --     if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
                    --         for i = 1, #bb.friend do
                    --             if bb.friend[i].guid == UnitGUID("mouseover") and bb.friend[i].dispel == true then
                    --                 if cast.detox("mouseover") then return end
                    --             end
                    --         end
                    --     end
                    -- else
                    -- if getValue("Detox Mode") == 2 then -- Raid
                        for i = 1, #bb.friend do
                            for n = 1,40 do
                                local buff,_,_,count,bufftype,duration = UnitDebuff(bb.friend[i].unit, n)
                                if buff then
                                    if bufftype == "Curse" or bufftype == "Magic" or bufftype == "Poison" then
                                        if cast.detox(bb.friend[i].unit) then return end
                                    end
                                end
                            end
                        end
                    -- end
                end
                --Thunder Focus Tea
                if isChecked("Thunder Focus Tea") then
                    for i = 1, #bb.friend do                           
                        if bb.friend[i].hp <= getValue("Thunder Focus Tea") then
                            if cast.thunderFocusTea() then return end     
                        end
                    end
                end                
                --Renewing Mist
                if isChecked("Renewing Mist STH") then
                    for i = 1, #bb.friend do                           
                        if bb.friend[i].hp <= getValue("Renewing Mist STH") 
                        and getBuffRemain(bb.friend[i].unit, spell.renewingMist, "player") < 1 then
                            if cast.renewingMist(bb.friend[i].unit) then return end     
                        end
                    end
                end
                --sheilunsGift
                if isChecked("Sheiluns Gift STH") and GetSpellCount(205406) ~= nil then
                    if GetSpellCount(205406) >= 5 then
                        if lowest.hp <= getValue("Sheiluns Gift STH") then         
                            if cast.sheilunsGift(lowest.unit) then return end                                    
                        end
                    end
                end
                --Enveloping Mists
                if isChecked("Enveloping Mist STH")
                and not isCastingSpell(spell.envelopingMist) then
                    if lowest.hp <= getValue("Enveloping Mist STH")
                    and getBuffRemain(lowest.unit, spell.envelopingMist, "player") < 2 then 
                        if cast.envelopingMist(lowest.unit) then return end 
                    end
                end
                --Vivify
                if isChecked("Vivify STH")
                and not isCastingSpell(spell.vivify) then
                    -- if buff.upliftingTrance and lowest.hp <= getValue("Vivify STH") + 10 then         
                    --     if cast.vivify(lowest.unit) then return end 
                    -- else
                    if lowest.hp <= getValue("Vivify STH") then         
                        if cast.vivify(lowest.unit) then return end                                    
                    end
                end
                --Effuse
                if isChecked("Effuse STH") 
                and not isCastingSpell(spell.effuse) then
                    if lowest.hp <= getValue("Effuse STH") then    
                        if cast.effuse(lowest.unit) then return end    
                    end
                end

            end -- End In Combat Rotation
        end -- End Timer
    end -- End runRotation 
    tinsert(cMistweaver.rotations, { -- Change cFury.roations to cSpec.rotaionts (IE: cFire.rotations)
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end -- End Select Warrior