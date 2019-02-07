local rotationName = "PangloFury"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.execute },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.execute}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.recklessness },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.recklessness },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.piercingHowl }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.enragedRegeneration },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.enragedRegeneration }
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
            -- Battle Shout
            br.ui:createCheckbox(section,"Battle Shout","Automatic Battle Shout for Party Memebers")
            -- Berserker Rage
            br.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
		br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Trinkets
            br.ui:createDropdown(section,"Trinkets", {"Always", "Cooldown"}, 1, "Use Trinkets always or with CDs")
            -- Racials
            br.ui:createCheckbox(section,"Racial")
            -- Bladestorm Units
            br.ui:createSpinner(section, "Bladestorm Units", 3, 1, 10, 1, "Number of units to Bladestorm on")
            -- Dragons Roar
            br.ui:createCheckbox(section,"Dragon Roar")
            -- Recklessness
            br.ui:createDropdownWithout(section, "Recklessness", {"Always", "Cooldown"}, 1, "Desired usage of spell.")
        br.ui:checkSectionState(section)
        -------------------------
        --- MOVEMENT  OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Movement")
            -- charge
            br.ui:createCheckbox(section,"Charge OoC")
            br.ui:createCheckbox(section,"Charge In Combat")
            -- Heroic Leap
            br.ui:createDropdownWithout(section,"Heroic Leap Hotkey", br.dropOptions.Toggle, 7, "Set desired hotkey to use Heroic Leap.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone/Potion",  60,  0,  100,  5,  "Health Percentage to use at.")
            -- Enraged Regeneration
            br.ui:createSpinner(section, "Enraged Regeneration", 60, 0, 100, 5, "Health Percentage to use at.")
            -- Intimidating Shout
            br.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  "Health Percentage to use at.")
            -- Rallying Cry
            br.ui:createSpinner(section, "Rallying Cry Units",  5,  0,  40,  1,  "Number of Units below HP Value")
            br.ui:createSpinnerWithout(section, "Rallying Cry HP", 60, 0, 100, 5,"HP of Teammates to use RC")
            -- Storm Bolt
            br.ui:createSpinner(section, "Storm Bolt", 60, 0, 100, 5, "Health Percentage to use at.")
            -- Victory Rush
            br.ui:createSpinner(section, "Victory Rush", 60, 0, 100, 5, "Health Percentage to use at.")
            br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Pummel
            br.ui:createCheckbox(section,"Pummel")
            -- Intimidating Shout
            br.ui:createCheckbox(section,"Intimidating Shout - Int")
            -- Storm Bolt
            br.ui:createCheckbox(section,"Storm Bolt - Int")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  0,  0,  95,  5,  "Cast Percentage to use at.")
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
        
        --Toggles
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Mover",0.25)
        br.player.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]

        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local hastar                                        = hastar or GetObjectExists("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local equiped                                       = br.player.equiped
        local gcd                                           = br.player.gcdMax
        local heirloomNeck                                  = 122667 or 122668
        local inCombat                                      = br.player.inCombat
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local mode                                          = br.player.mode
        local moving                                        = GetUnitSpeed("player")>0
        local php                                           = br.player.health
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local rage                                          = br.player.power.rage.amount()
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local thp                                           = getHP("target")
        local traits                                        = br.player.traits
        local units                                         = br.player.units

        units.get(5)
        units.get(8)
        enemies.get(8)
        enemies.get(15)
        enemies.get(20)

        if profileStop == nil then profileStop = false end


        function extralist()
            -- Battle Shout
            if isChecked("Battle Shout") and cast.able.battleShout() then
                for i = 1, #br.friend do
                    local thisUnit = br.friend[i].unit
                    if not UnitIsDeadOrGhost(thisUnit) and getDistance(thisUnit) < 100 and buff.battleShout.remain(thisUnit) < 300 then
                        if cast.battleShout() then return end
                    end
                end
            end

            -- Berserker Rage
            if isChecked("Berserker Rage") and cast.able.berserkerRage() and hasNoControl(spell.berserkerRage) then
                if cast.berserkerRage() then return end
            end
        end

        function defensivelist()
            if useDefensive() then
            -- Healthstone/Health Potion
                if isChecked("Healthstone/Potion") and php <= getOptionValue("Healthstone/Potion")
                and (hasHealthPot() or hasItem(5512)) then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(getHealthPot()) then
                            useItem(getHealthPot())
                    end
                end    

                -- Enraged Regeneration
                if isChecked("Enraged Regeneration") and cast.able.enragedRegeneration() and php <= getOptionValue("Enraged Regeneration") then
                    if cast.enragedRegeneration() then return end
                end

                -- Intimidating Shout
                if isChecked("Intimidating Shout") and cast.able.intimidatingShout() and php <= getOptionValue("Intimidating Shout") then
                    if cast.intimidatingShout() then return end
                end

                -- Rallying Cry
                if isChecked("Rallying Cry Units") and cast.able.rallyingCry() and getLowAllies(getValue("Rallying Cry HP")) >= getValue("Rallying Cry Units") then
                    if cast.rallyingCry() then return end
                end

                -- Storm Bolt
                if isChecked("Storm Bolt") and cast.able.stormBolt() and php <= getOptionValue("Storm Bolt") then
                    if cast.stormBolt() then return end
                end

                -- Victory Rush
                if isChecked("Victory Rush") and (cast.able.victoryRush() or cast.able.impendingVictory()) and php <= getOptionValue("Victory Rush") and buff.victorious.exists() then
                    if talent.impendingVictory then
                        if cast.impendingVictory() then return end
                    else
                        if cast.victoryRush() then return end
                    end
                end
            end
        end

        function interruptlist()
            if useInterrupts() then
                for i=1, #enemies.yards20 do
                    thisUnit = enemies.yards20[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                    -- Pummel
                        if isChecked("Pummel") and cast.able.pummel(thisUnit) and distance < 5 then
                            if cast.pummel(thisUnit) then return end
                        end
                    -- Intimidating Shout
                        if isChecked("Intimidating Shout - Int") and cast.able.intimidatingShout() and distance < 8 then
                            if cast.intimidatingShout() then return end
                        end
                    -- Storm Bolt
                        if isChecked("Storm Bolt - Int") and cast.able.stormBolt(thisUnit) and distance < 20 then
                            if cast.stormBolt(thisUnit) then return end
                        end
                    end
                end
            end
        end

        function moverlist()
            if br.player.mode.mover == 1 then
                if SpecificToggle("Heroic Leap Hotkey") then
                    CastSpellByName(GetSpellInfo(spell.heroicLeap), "cursor") 
                end

                if incombat and isChecked("Charge In Combat") and cast.able.charge("target") and (getDistance("player","target") >= 8 and getDistance("player","target") <= 25) then
                    if cast.charge("target") then return end
                end
                if isChecked("Charge OoC") then 
                    if not incombat and cast.able.charge("target") and getDistance("player","target") <= 25 then
                        if cast.charge("target") then return end
                    end
                end    
            end
        end

        function singlelist()
            -- furious slash
            if talent.furiousSlash and not cast.last.furiousSlash() and (buff.furiousSlash.stack() < 3 or buff.furiousSlash.remains() <= 2) then
                if cast.furiousSlash() then return end
            end

            -- Rampage
            if buff.recklessness.exists() or not buff.enrage.exists() or (talent.carnage and rage >= 75) or (rage >= 85) then
                if cast.rampage() then return end
            end

            -- Recklessness
            if not buff.recklessness.exists() and (getOptionValue("Recklessness") == 1 or (getOptionValue("Recklessness") == 2 and useCDs())) then
                if cast.recklessness() then return end
            end

            -- Siegebreaker
            if buff.recklessness.exists() or cd.recklessness.remain() > 25 or (getOptionValue("Recklessness") == 2 and not useCDs()) then
                if cast.siegebreaker() then return end
            end

            -- Execute
            if cast.able.execute() and buff.enrage.exists() or rage <= 60 then
                if cast.execute() then return end
            end

            -- High Prio Bloodthirst
            if traits.coldSteelHotBlood.rank > 1 or not buff.enrage.exists() then
                if cast.bloodthirst() then return end
            end

            -- Raging Blow
            if charges.ragingBlow.count() == 2 then
                if cast.ragingBlow() then return end
            end

            -- Low Prio Bloodthirst
            if cast.bloodthirst() then return end

            -- Dragon Roar
            if buff.enrage.exists() and isChecked("Dragon Roar") then
                if cast.dragonRoar() then return end
            end

            -- Raging Blow Dump
            if cast.ragingBlow() then return end

            -- Bladestorm Single target
            if buff.enrage.exists() and isChecked("Bladestorm Units") then
                if cast.bladestorm() then return end
            end

            -- Furious Slash Filler
            if cast.furiousSlash() then return end

            -- whirlwind filler
            if not talent.furiousSlash then 
                if cast.whirlwind() then return end
            end
        end --  end single target

        function multilist()
            -- Maintain Whirlwind buff
            if not buff.whirlwind.exists() then
                if cast.whirlwind() then return end
            end

            -- Recklessness
            if not buff.recklessness.exists() and (getOptionValue("Recklessness") == 1 or (getOptionValue("Recklessness") == 2 and useCDs())) then
                if cast.recklessness() then return end
            end
            
            -- Siegebreaker
            if buff.whirlwind.exists() and (buff.recklessness.exists() or cd.recklessness.remain() > 25 or (getOptionValue("Recklessness") == 2 and not useCDs())) then
                if cast.siegebreaker() then return end
            end

            -- Rampage
            if buff.whirlwind.exists() and (buff.recklessness.exists() or (not buff.enrage.exists() or (talent.carnage and rage >= 75) or (rage >= 85))) then
                if cast.rampage() then return end
            end

            -- Bladestorm
            if #enemies.yards8 >= getOptionValue("Bladestorm Units") and buff.enrage.exists() then
                if cast.bladestorm() then return end
            end

            -- Dragon Roar
            if buff.enrage.exists() then 
                if cast.dragonRoar() then return end
            end

            -- Execute
            if buff.whirlwind.exists() and cast.able.execute() and (buff.enrage.exists() or rage <= 60) then
                if cast.execute() then return end
            end

            -- furious slash
            if talent.furiousSlash and (buff.furiousSlash.stack() < 3 or buff.furiousSlash.remains() <= 2) then
                if cast.furiousSlash() then return end
            end

            -- High Prio Bloodthirst
            if buff.whirlwind.exists() and (traits.coldSteelHotBlood.rank > 1 or not buff.enrage.exists()) then
                if cast.bloodthirst() then return end
            end

            -- Raging Blow
            if buff.whirlwind.exists() and charges.ragingBlow.count() == 2 then
                if cast.ragingBlow() then return end
            end

            -- Low Prio Bloodthirst
            if buff.whirlwind.exists() then 
                if cast.bloodthirst() then return end
            end

            -- Raging Blow Dump
            if buff.whirlwind.exists() then 
                if cast.ragingBlow() then return end
            end

            -- Furious Slash Filler
            if buff.whirlwind.exists() then 
                if cast.furiousSlash() then return end
            end            
        end -- end multi target

        function cooldownlist()
            if useCDs() then
                --trinkets
                if isChecked("Trinkets") then
                    if getOptionValue("Trinkets")==1 or (getOptionValue("Trinkets")==2 and useCDs()) then
                        if canTrinket(13) then
                            useItem(13)
                        end
                        if canTrinket(14) then
                            useItem(14)
                        end
                    end
                end

                --racials
                if isChecked("Racials") then
                    if race == "Orc" or race == "Troll" or race == "LightforgedDraenei" then
                        if cast.racial() then return end
                    end
                end
            end
        end

	---------------------
	--- Begin Profile ---
	---------------------
	-- Profile Stop | Pause
    if pause() or 
                (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) or mode.rotation == 2 then
        return true
        else
        if not inCombat and not IsMounted() then
            moverlist()
            defensivelist()
            extralist()
        end
        if inCombat and profileStop==false and not (IsMounted() or IsFlying()) and #enemies.yards8 >=1 then
            if getDistance(units.dyn5) < 5 then
                StartAttack()
            end
            if moverlist() then return end
            if extralist() then return end
            if interruptlist() then return end
            if defensivelist() then return end
            if cooldownlist() then return end
            if #enemies.yards8 > 1 then
                --Print("Multi")
                if multilist() then return end
            else
                --Print("Single")
                if singlelist() then return end
            end
        end   
    end
end

local id = 72
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
