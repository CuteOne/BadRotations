local rotationName = "Panglo2"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.thunderClap },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.battleCry },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.battleCry },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.battleCry }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.shieldWall },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.shieldWall }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.pummel },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    };
    CreateButton("Interrupt",4,0)
-- Movement Button
    MoverModes = {
        [1] = { mode = "On", value = 1 , overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap.", highlight = 1, icon = br.player.spell.charge },
        [2] = { mode = "Off", value = 2 , overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap.", highlight = 0, icon = br.player.spell.charge }
    };
    CreateButton("Mover",5,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            br.ui:createCheckbox(section,"Open World Defensives", "Use this checkbox to ensure defensives are used while in Open World")
            -- Berserker Rage
            br.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
            -- lol charge
            br.ui:createCheckbox(section,"Charge OoC")
            -- High Rage Dump
            br.ui:createSpinner(section, "High Rage Dump", 85, 1, 100, 1, "|cffFFFFFF Set to number of units to use Ignore Pain or Revenge at")
			-- Taunt
            br.ui:createCheckbox(section,"Taunt","|cffFFFFFFAuto Taunt usage.")
            br.ui:createCheckbox(section,"Use Heroic Throw","Check to enable Heroic Throw usage in Combat")
		br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Avatar
            br.ui:createCheckbox(section,"Avatar")
            -- Avatar Spinner
            br.ui:createSpinnerWithout(section, "Avatar Mob Count",  5,  0,  10,  1,  "|cffFFFFFFEnemies to cast Avatar on.")
            -- Demoralizing Shout
            br.ui:createCheckbox(section,"Demoralizing Shout - CD")
            -- Ravager
            br.ui:createCheckbox(section,"Ravager")
            -- Shockwave
            br.ui:createCheckbox(section,"Shockwave")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone/Potion",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Demoralizing Shout
            br.ui:createSpinner(section, "Demoralizing Shout",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Last Stand
            br.ui:createCheckbox(section, "Last Stand Filler", "Use Last Stand as a filler with the Bolster Talent")
            br.ui:createSpinner(section, "Last Stand",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Rallying Cry
            br.ui:createSpinner(section, "Rallying Cry",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Shield Wall
            br.ui:createSpinner(section, "Shield Wall",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Shockwave
            br.ui:createSpinner(section, "Shockwave - HP", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinner(section, "Shockwave - Units", 3, 1, 10, 1, "|cffFFBB00Minimal units to cast on.")
            -- Spell Reflection
            br.ui:createSpinner(section, "Spell Reflection",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Storm Bolt
            br.ui:createSpinner(section, "Storm Bolt", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Pummel
            br.ui:createCheckbox(section,"Pummel")
            -- Intimidating Shout
            br.ui:createCheckbox(section,"Intimidating Shout - Int")
            -- Shockwave
            br.ui:createCheckbox(section,"Shockwave - Int")
            -- Storm Bolt
            br.ui:createCheckbox(section,"Storm Bolt - Int")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
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
    if br.timer:useTimer("debugProtection", 0.1) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Mover",0.25)
        br.player.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]

--------------
--- Locals ---
--------------
        local addsExist                                     = false
        local addsIn                                        = 999
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local friendly                                      = friendly or GetUnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local heirloomNeck                                  = 122667 or 122668
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powerMax, powerGen                     = br.player.power.rage.amount(), br.player.power.rage.max(), br.player.power.rage.regen()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local rage, powerDeficit                            = br.player.power.rage.amount(), br.player.power.rage.deficit()
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local thp                                           = getHP("target")
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.rage.ttm()
        local units                                         = br.player.units
        local hasAggro                                      = UnitThreatSituation("player")
        if hasAggro == nil then
            hasAggro = 0
        end

        units.get(5)
        units.get(8)

        enemies.get(5)
        enemies.get(8)
        enemies.get(10)
        enemies.get(20)
        enemies.get(30)
        enemies.get(40)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end


        --- Quick maths ---
        local function mainTank()
            if (#enemies.yards30 >= 1 and (hasAggro >= 2)) or isChecked("Open World Defensives") then
                return true 
            else
                return false
            end
        end
        local function ipCapCheck()
            if buff.ignorePain.exists() then
                local ipValue = tonumber((select(1, GetSpellDescription(190456):match("%d+%S+%d"):gsub("%D",""))),10)
                local ipMax = math.floor(ipValue * 1.3)
                local ipCurrent = tonumber((select(16, UnitBuffID("player", 190456))),10)
                if ipCurrent == nil then ipCurrent = 0 return end
                if ipCurrent <= (ipMax * 0.2) then
                    ---print("IP below cap")
                    return true
                else
                    --print("dont cast IP") 
                    return false 
                end
            else 
                --print("IP not on")
                return true 
            end
        end

        local function rageCap()
            if cast.able.ignorePain() and rage >= getValue("High Rage Dump") and mainTank() and ipCapCheck() then
                --print("dumping IP")
                if cast.ignorePain() then return end
            end
            if cast.able.revenge() and rage >= getValue("High Rage Dump") and (not ipCapCheck() or not mainTank()) then
                --print("dumping R")
                if cast.revenge() then return end
            end
        end


        ------Stuff with the things ------

        local function upsizeWithFries()
            if isChecked("Charge OoC") then
                if cast.able.intercept("target") and getDistance("player","target") <= 25 then
                    if cast.intercept("target") then return end
                end
            end
            if isChecked("Berserker Rage") and hasNoControl(spell.berserkerRage) then
                if cast.berserkerRage() then return end
            end
            if isChecked("Taunt") and inInstance then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                        if cast.taunt(thisUnit) then return end
                    end
                end
            end
        end

        local function silenceThemHoes()
            if useInterrupts() then
                for i=1, #enemies.yards20 do
                    thisUnit = enemies.yards20[i]
                    unitDist = getDistance(thisUnit)
                    targetMe = UnitIsUnit("player",thisUnit) or false
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                        if isChecked("Pummel") and unitDist < 6 then
                            if cast.pummel(thisUnit) then return end
                        end
                        if isChecked("Intimidating Shout - Int") and unitDist <= 8 then
                            if cast.intimidatingShout() then return end
                        end
                        if isChecked("Shockwave - Int") and unitDist < 10 then
                            if cast.shockwave() then return end
                        end
                        if isChecked("Storm Bolt - Int") and unitDist < 20 then
                            if cast.stormBolt() then return end
                        end
                    end
                end
            end        
        end

        local function moveMeDaddy()
            if br.player.mode.mover == 1 then 
                if cast.able.intercept("target") and (getDistance("player","target") >= 8 and getDistance("player","target") <= 25) then
                    if cast.intercept("target") then return end
                end
            end
        end

        local function bigDickDPS()
            if useCDs() and #enemies.yards5 >= 1 then
                if isChecked("Avatar") then
                    --print("cd avatar")
                    if cast.avatar() then return end
                end
                if isChecked("Demoralizing Shout - CD") and rage <= 65 then
                    if cast.demoralizingShout() then return end
                end
                if talent.ravager then
                    if cast.ravager("best",false,1,8) then return end
                end
            end
        end

        local function dontTazeMeBro()
            if useDefensive() then
                if isChecked("Taunt") and inInstance then
                    for i = 1, #enemies.yards30 do
                        local thisUnit = enemies.yards30[i]
                        if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                            if cast.taunt(thisUnit) then return end
                        end
                    end
                end    
                if cast.able.shieldBlock() and mainTank() and (not buff.shieldBlock.exists() or (buff.shieldBlock.remain() <= (gcd * 1.5))) and not buff.lastStand.exists() and rage >= 30 then
                    if cast.shieldBlock() then return end
                end
                if talent.bolster and not buff.shieldBlock.exists() and cd.shieldBlock.remain() > gcd and mainTank() then
                    if cast.lastStand() then return end
                end
                if php <= 65 and cast.able.victoryRush() then
                    if cast.victoryRush() then return end
                end
                --ignore the painful ways
                if cast.able.ignorePain() and mainTank() and ipCapCheck() then
                    if buff.vengeanceIgnorePain.exists() and rage >= 42 then
                        if cast.ignorePain() then return end
                    end
                    if rage >= 55 and not buff.vengeanceRevenge.exists() then
                        if cast.ignorePain() then return end
                    end
                end  
                if isChecked("Healthstone/Potion") and php <= getOptionValue("Healthstone/Potion") and (hasHealthPot() or hasItem(5512)) then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(getHealthPot()) then
                        useItem(getHealthPot())
                    end
                end
                if isChecked("Demoralizing Shout") and php <= getOptionValue("Demoralizing Shout") then
                    if cast.demoralizingShout() then return end
                end
                if  isChecked("Last Stand") and php <= getOptionValue("Last Stand") then
                    if cast.lastStand() then return end
                end
				if  isChecked("Rallying Cry") and php <= getOptionValue("Rallying Cry") then
					if cast.rallyingCry() then return end
				end
                 if  isChecked("Shield Wall") and php <= getOptionValue("Shield Wall") and cd.lastStand.remain() > 0 and not buff.lastStand.exists() then
                    if cast.shieldWall() then return end
                end
                 if  ((isChecked("Shockwave - HP") and php <= getOptionValue("Shockwave - HP")) or (isChecked("Shockwave - Units") and #enemies.yards8 >= getOptionValue("Shockwave - Units"))) then
                    if cast.shockwave() then return end
                end
               if  isChecked("Spell Reflection") and php <= getOptionValue("Spell Reflection") then
                    if cast.spellReflection() then return end
                end
                if  isChecked("Storm Bolt") and php <= getOptionValue("Storm Bolt") then
                    if cast.stormBolt() then return end
                end
            end
        end

        local function parseTime()
            if isChecked("Avatar") and (#enemies.yards8 >= getOptionValue("Avatar Mob Count")) then
                ---print("norm avatar")
                if cast.avatar() then return end
            end
            if #enemies.yards10 == 0 and isChecked("Use Heroic Throw") then
                if cast.heroicThrow() then return end
            end
            if isChecked("Demoralizing Shout - CD") and rage <= 65 then
                if cast.demoralizingShout() then return end
            end
        -- shield slam always
            if isChecked("Trinkets") then
                if canTrinket(13) then
                    useItem(13)
                end
                if canTrinket(14) then
                    useItem(14)
                end
            end
            if talent.cracklingThunder then
                if cast.thunderClap("player",nil,1,12) then return end
            else
                if cast.thunderClap("player",nil,1,8) then return end
            end
            if cast.shieldSlam() then return end
            -- Clap the booty
            -- Revenge of the stiff
            if buff.revenge.exists() or (buff.vengeanceRevenge.exists() and rage >= 50) then
                if cast.revenge() then return end
            end
            --Less Victorious
            if php <= 80 and not (cast.able.shieldSlam() or cast.able.thunderClap()) then
                if cast.victoryRush() then return end
            end
            --devastating blows
            if not (cast.able.shieldSlam() or cast.able.thunderClap()) then
                if cast.devastate() then return end
            end
        end

        local function technoViking()
            --stomp your feet
            if talent.cracklingThunder then
                if cast.thunderClap("player",nil,1,12) then return end
            else
                if cast.thunderClap("player",nil,1,8) then return end
            end
            -- Rest
            if not cast.able.thunderClap() then
                if cast.shieldSlam() then return end
            end
            -- Recover
            if not (cast.able.shieldSlam() or cast.able.thunderClap()) and buff.revenge.exists() then
                if cast.revenge() then return end
            end
            -- Drink
            if not (cast.able.shieldSlam() or cast.able.thunderClap()) and ipCapCheck() and rage >= 55 then
                if cast.ignorePain() then return end
            end
            if not (cast.able.shieldSlam() or cast.able.thunderClap()) then
                if cast.devastate() then return end
            end
        end

        --- Lets do things now
    if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or 
                (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) or mode.rotation == 2 then
        return true
        else
            if not inCombat and not IsMounted() and isValidUnit("target") then
                if upsizeWithFries() then return end
            end
            if inCombat and profileStop==false and not (IsMounted() or IsFlying()) and #enemies.yards8 >=1 then
                if getDistance(units.dyn5) < 5 then
                    StartAttack()
                end
                
                if dontTazeMeBro() then return end

                if moveMeDaddy() then return end

                if bigDickDPS() then return end

                if silenceThemHoes() then return end

                if (talent.unstoppableForce and buff.avatar.exists()) then
                    if technoViking() then return end
                end

                if not (talent.unstoppableForce and buff.avatar.exists()) then
                    if rageCap() then return end
                    if parseTime() then return end
                end
            end-- combat check
        end--pause
    end--timer
end--runrotation
local id = 73
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
