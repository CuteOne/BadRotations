if select(2, UnitClass("player")) == "PALADIN" then
    local rotationName = "Gabbz"

---------------
--- Toggles ---
---------------
    local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Default",   value = 1,  overlay = "Healing Rotation",   tip = "Default healing.",           highlight = 1, icon = bb.player.spell.flashOfLight},
            [2] = { mode = "DPS",       value = 2,  overlay = "DPS",                tip = "Do damage, for grinding.",   highlight = 0, icon = bb.player.spell.judgement},
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
           [1] = { mode = "Auto",      value = 1,   overlay = "Cooldowns Automated",    tip = "Automatic Cooldowns - Boss Detection.",  highlight = 1, icon = bb.player.spell.avengersWrath},
           [2] = { mode = "On",        value = 1,   overlay = "Cooldowns Enabled",      tip = "Cooldowns used regardless of target.",   highlight = 0, icon = bb.player.spell.auraMastery},
           [3] = { mode = "Off",       value = 3,   overlay = "Cooldowns Disabled",     tip = "No Cooldowns will be used.",             highlight = 0, icon = bb.player.spell.flashOfLight}
        };
        CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
           [1] = { mode = "On",        value = 1,   overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.flashOfLight},
           [2] = { mode = "Off",       value = 2,  overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.flashOfLight}
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
           [1] = { mode = "On",        value = 1,  overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = bb.player.spell.flashOfLight},
           [2] = { mode = "Off",       value = 2,  overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = bb.player.spell.flashOfLight}
        };
        CreateButton("Interrupt",4,0)
    
    -- ToDo : Dispell Toggle
    -- ToDo : Stun/CC?
       
    end

---------------
--- OPTIONS --- 
---------------
    local function createOptions()
        local optionTable

        local function rotationOptions()
            local section
        -- Healing values
            section = bb.ui:createSection(bb.ui.window.profile, "Healing Thresholds")
                bb.ui:createSpinner(section,"Critical Health Level",    0, 20, 100, 5, "|cffFFFFFFWhen to save a unit")
                bb.ui:createSpinner(section,"Holy Shock",               0, 95, 100, 5, "|cffFFFFFFHealth Level to Cast At")
                bb.ui:createSpinner(section,"Holy Light",               0, 50, 100, 5, "|cffFFFFFFHealth Level to Cast At")
                bb.ui:createSpinner(section,"Bestow Faith",             0, 85, 100, 5, "|cffFFFFFFHealth Level to Cast At")
                bb.ui:createSpinner(section,"Holy Prism",               0, 80, 100, 5, "|cffFFFFFFHealth Level to Cast At")
                bb.ui:createSpinner(section,"Flash of Light",           0, 60, 100, 5, "|cffFFFFFFHealth Level to Cast At")
                bb.ui:createSpinner(section,"Light of The Martyr",      0, 40, 100, 5, "|cffFFFFFFHealth Level to Cast At")
                bb.ui:createSpinner(section,"Blessing of Sacrifice",    0,  0, 100, 5, "|cffFFFFFFHealth Level to Cast At")
                bb.ui:createSpinner(section,"Blessing of Protection",   0,  0, 100, 5, "|cffFFFFFFHealth Level to Cast At")
                bb.ui:createSpinner(section,"Lay on Hands",             0, 20, 100, 5, "|cffFFFFFFHealth Level to Cast At")
            bb.ui:checkSectionState(section)
            
            -- Cooldown Options
             section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
                bb.ui:createSpinner(section,"Aura Mastery",    0, 50, 100, 5, "|cffFFFFFFWhen to save a unit")
                -- Todo need to specify how many units beneath

             bb.ui:checkSectionState(section)
            -- Defensive Options
             section = bb.ui:createSection(bb.ui.window.profile, "Defensive")

             bb.ui:checkSectionState(section)
        
        -- Toggle Key Options
            section = bb.ui:createSection(bb.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
               bb.ui:createDropdown(section, "Rotation Mode", bb.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
               bb.ui:createDropdown(section, "Cooldown Mode", bb.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
               bb.ui:createDropdown(section, "Defensive Mode", bb.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
               bb.ui:createDropdown(section, "Interrupt Mode", bb.dropOptions.Toggle,  6)
            -- Pause Toggle
               bb.ui:createDropdown(section, "Pause Mode", bb.dropOptions.Toggle,  6)
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
        if bb.timer:useTimer("debugHoly", math.random(0.15,0.3)) then
            -- print("Running: "..rotationName)

    ---------------
    --- Toggles ---
    ---------------
            UpdateToggle("Rotation",0.25)
            UpdateToggle("Cooldown",0.25)
            UpdateToggle("Defensive",0.25)
            UpdateToggle("Interrupt",0.25)


    --------------
    --- Locals ---
    --------------
            local addsExist                                     = false 
            local addsIn                                        = 999
            local artifact                                      = bb.player.artifact
            local buff                                          = bb.player.buff
            local cast                                          = bb.player.cast
            local castable                                      = bb.player.cast.debug
            local combatTime                                    = getCombatTime()
            local cd                                            = bb.player.cd
            local charges                                       = bb.player.charges
            local deadMouse, hasMouse, playerMouse              = UnitIsDeadOrGhost("mouseover"), ObjectExists("mouseover"), UnitIsPlayer("mouseover")
            local deadtar, attacktar, hastar, playertar         = UnitIsDeadOrGhost("target"), UnitCanAttack("target", "player"), ObjectExists("target"), UnitIsPlayer("target")
            local debuff                                        = bb.player.debuff
            local enemies                                       = bb.player.enemies
            local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player") > 0
            local friendly                                      = UnitIsFriend("target", "player")
            local gcd                                           = bb.player.gcd
            local healPot                                       = getHealthPot()
            local inCombat                                      = bb.player.inCombat
            local inInstance                                    = bb.player.instance=="party"
            local inRaid                                        = bb.player.instance=="raid"
            local lastSpell                                     = lastSpellCast
            local level                                         = bb.player.level    
            local mode                                          = bb.player.mode
            local moveIn                                        = 999      
            local php                                           = bb.player.health
            local power, powmax, powgen, powerDeficit           = bb.player.power, bb.player.powerMax, bb.player.powerRegen, bb.player.powerDeficit
            local pullTimer                                     = bb.DBM:getPulltimer()
            local racial                                        = bb.player.getRacial()
            local recharge                                      = bb.player.recharge
            local solo                                          = bb.player.instance=="none"
            local spell                                         = bb.player.spell
            local talent                                        = bb.player.talent
            local ttd                                           = getTTD
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

    ---------------------
    --- Begin Profile ---
    ---------------------
        -- Profile Stop | Pause
            if UnitAffectingCombat("player") or IsLeftControlKeyDown() then -- Only heal if we are in combat or if left control is down for out of combat rotation  

            ----------------------
            -- Testing Area, does not work
            ----------------------
                print("Debug")
               -- for i = 1, #bb.friend do
               --     --Check if tank based on role or if having beacon of light, extract to tank table
               --     if bb.friend[i].role == "TANK" or UnitBuffID(bb.friend[i].unit, 53563) then 
               --         print("Debug: Found Tank")
               --         tinsert(tank, bb.friend[i])
                        --tank.hp = bb.friend[i].hp
                        --tank.unit = bb.friend[i].unit
                        --tank.range = bb.friend[i].range
               --     end
               --     if bb.friend[i].hp < lowest.hp then
               --         print("Debug: Found New Lowest")
               --         lowest.hp = bb.friend[i].hp
               --         lowest.role = bb.friend[i].role
               --         lowest.unit = bb.friend[i].unit
               --         lowest.range = bb.friend[i].range
               --         lowest.guid = bb.friend[i].guid 
               ----     end
                ----    averageHealth = averageHealth + bb.friend[i].hp
                ----end
                ----averageHealth = averageHealth/#bb.friend
                ----print("Debug: averageHealth and friends : " ..averageHealth ..#bb.friend)

                    ----------------------
                    -- Healing Candidate checks
                    ----------------------
                    -- Get all relevant units by pulsing healing units
                    --      MainTank, Offtank, LowestTank (Here we need to considere Beacons)
                    --      Player
                    --      LowestRaid
                    --      LowestDebuffed  lowest unit with a dangerous debuff
                    --  In the pulse we should also check
                    --      Best AoeCandidate
                    --      What is the best prio Candidate
                    --      Who is aggroed most
                    --      Most damage last 1-5 seconds

                    ----------------------
                    -- Manual Input
                    ---------------------
                    -- Start with letting the user toggle or keypress things
                    --  DPS
                    --      Focus on DPSing
                    --  Dispell
                    --      Focus on dispelling
                    --  Stun/interrupt
                    --  TopUp
                    --      Top Up the raid using fast heals
                    --      Top up a unit using fast heals


                    --So we re in combat and should heal
                    ----------------
                    -- Healing Candidate selection
                    ----------------
                    -- First we need to check what unit to heal
                    -- See what unit of tank, player and raid that is lowest
                    -- If that unit is beneath a critical health level start going into spam
                    -- If it is not in critical health go into the "standard" healing rotation 
                    
                    
                    -- if we dont need to focus on a unit(beneath a hp) then we should look at AoE spells first
                    -----------
                    -- AoE Spells
                    -----------
                    -- Check number of injured players to see if we need to do AoE or use CDs
                    -- Check Holy Prism if we have x number of allies around a enemy
                    -- Check if we have lights hammer and have x friends clustered and if we have y enemies. Focus on healing so if we have 2 spots with same allies check enemies
                    -- Check if there are x number of injured allies around the caster for Tyrs Deliverance

                    -------------------
                    -- Single Healing Rotation
                    -------------------
                    -- We should check if we need to focus on one unit or not. If not then we should try to maximise healing numbers
                    -- Prio then should be based on
                    --      Health as per normal 
                    --      Range
                    --          Range to player, our mastery increases healing based on distance to us. up to 10 yard is max and then it goes down. So prio should be 10 yards around player and then for
                    --          each yard way -1 or something.
                    --          if we have lightbringer talent then our mastery also uses the beacon of light target, ie both player and beacon of ligth unit
                    --      Debuff/Incoming damage
                    --          If unit has a damage debuff or has aggro
                    --      Healing assignment
                    --          We should be able to set a value for units. So +5 for player, -5 for tanks, for roles, for units(mouseover, focus, target)
                    --    
                    --
                    -- If that is a tank, or any unit with beacon of faith or light check if the next injured unit is close enough
                    -- Should have a tank heal rotation    
                    -- Should have a player heal rotation
                    -- Should have raid heal rotation


                    -----------------------
                    -- Standard Rotation - Should be moved to a seperate function for ease of maintaining it
                    ------------------------
                    -- So below is current design
                    -- Spell, Condition, Unit
                    --'Light of the Martyr', 'player.buff(Divine Shield)', lowest) 
                    --!Lay on Hands', {'lowest.health < UI(L_LoH)','!lowest.debuff(Forebearance)'}, lowest)
                    --'Blessing of Protection',{'lowest.health < UI(L_BoP)','!lowest.debuff(Forebearance)'}, lowest)
                    --'Blessing of Sacrifice',{'lowest.health < UI(L_BoS)', 'player.health > 70'}, lowest)
                    --'Holy Shock', 'lowest.health < UI(L_HS)', unit.unit) then 
                    --'Holy Prism', 'lowest.health < UI(L_HP)', unit.unit) then 
                    --'Flash of Light', {'lowest.health < UI(L_FoL)','player.buff(Infusion of Light)'}, lowest) then 
                    --'Holy Light', {'lowest.health < UI(L_HL)','player.buff(Infusion of Light)'}, lowest) then 
                    --'Light of the Martyr', {'lowest.health < UI(L_LotM)','player.health > 70'}, lowest) then 
                    --'Flash of Light', 'lowest.health < UI(L_FoL)', lowest) then 
                    --'Bestow Faith', 'lowest.health < UI(L_BF)', lowest) then 
                    -- 'Holy Light', 'lowest.health < UI(L_HL)', lowest)

                    --if isChecked("HolyLight") and getValue("Riptide") then
                    --if self.castHealingRain(getOptionValue("Healing Rain"),getOptionValue("Healing Rain Targets")) then return end
                    if isChecked("Holy Light") and getValue("Holy Light") > lowest.hp then
                        if cast.holyLight(lowest.unit) then
                            return true
                        end
                    end
                    if isChecked("Flash of Light") and getValue("Flash of Light") >= lowest.hp then
                        if cast.flashOfLight(lowest.unit) then
                            return true
                        end
                    end
                    ----------------------------
                    -- End Standard Rotation
                    ------------------------------
            end --End Rotation Logic
        end -- End Timer
    end -- End runRotation
    tinsert(cHoly.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check