-------------------------------------------------------
-- Author = BrewingCoder
-- Patch = 10.2.5
-- Coverage = 90%
-- Status = Limited
-- Readiness = Development
-------------------------------------------------------
local rotationName = "BrewBloodKnight-SimC" 

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles, these are the buttons from the toggle bar
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.darkCommand },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.heartStrike },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.iceboundFortitude },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.bloodTap}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)

    local AutoPullModes = {
        [1] = { mode = "On", value =1, overlay = "Auto Pull Enabled", tip = "Auto Pull Enemies", highlight = 1, icon = br.player.spell.deathGrip},
        [2] = { mode = "Off", value = 2, overlay = "Auto Pull Disabled", tip = "Do Not AutoPull Enemies", highlight=0, icon=br.player.spell.deathGrip}
    };
    br.ui:createToggle(AutoPullModes,"Autopull",2,0)

    
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.antiMagicShell },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.deathsAdvance},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.antiMagicShell }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",3,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.lichborne },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.lichborne }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",4,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.mindFreeze }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",5,0)
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
                    br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
                    br.ui:createCheckbox(section, "Auto Engage")
                    br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
                    
        br.ui:checkSectionState(section)

                ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            br.player.module.FlaskUp("Strength",section)
            br.ui:createCheckbox(section,"Augment Rune")
            br.ui:createCheckbox(section,"Potion")
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
            -- Mind Freeze
            br.ui:createCheckbox(section,"Mind Freeze")
            br.ui:createCheckbox(section,"Use Death Grip as Interrupt")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
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

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local cast
local cd
local charges
local enemies
local module
local power
local talent
local ui
local unit
local units
local use
local var
local debuff
local runes
local runicPower
local runicPowerMax

-- Any variables/functions made should have a local here to prevent possible conflicts with other things.

--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
local actionList = {} -- Table for holding action lists.

-- Action List - Extra
actionList.Extra = function()
    if ui.checked("Use Dark Command") then
        if ui.checked("Only Taunt in Instance or Raid") and not (var.inRaid or var.inInstance) then return false end
        local enemiesList = nil
        if ui.value("Taunt Range") == 30 then enemiesList = enemies.yards30 end
        if ui.value("Taunt Range") == 20 then enemiesList = enemies.yards20 end
        if ui.value("Taunt Range") == 10 then enemiesList = enemies.yards10 end
        if enemiesList ~= nil then
            for i=1,#enemiesList do
                local thisUnit = enemiesList[i]
                if not unit.isTanking(thisUnit) and unit.threat(thisUnit) and not unit.isExplosive(thisUnit) and cast.able.darkCommand(thisUnit) then
                    if cast.darkCommand(thisUnit) then ui.debug("Casting Dark Command [Not Tanking]") return true end
                end
            end
        end
    end

    if ui.checked("Use Death Grip to Taunt") then
        if ui.checked("Only Taunt in Instance or Raid") and not (var.inRaid or var.inInstance) then return false end
        local enemiesList = nil
        if ui.value("Taunt Range") == 30 then enemiesList = enemies.yards30 end
        if ui.value("Taunt Range") == 20 then enemiesList = enemies.yards20 end
        if ui.value("Taunt Range") == 10 then enemiesList = enemies.yards10 end
        if enemiesList ~= nil then
            for i=1,#enemiesList do
                local thisUnit = enemiesList[i]
                if not unit.isTanking(thisUnit) and unit.threat(thisUnit) and not unit.isExplosive(thisUnit) and cast.able.deathGrip(thisUnit) then
                    if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip [Not Tanking]") return true end
                end
            end
        end
    end
end -- End Action List - Extra


actionList.CombatPull = function ()
    if ui.mode.autopull==1 and unit.inCombat then

        local validTargets = nil
        if cast.able.deathsCaress("target") and ui.checked("Use Deaths Caress to pull") then
            if ui.checked("DC only pull from FRONT") then
                if ui.value("Deaths Caress Range") == 10 then validTargets = enemies.yards10f;end
                if ui.value("Deaths Caress Range") == 20 then validTargets = enemies.yards20f;end
                if ui.value("Deaths Caress Range") == 30 then validTargets = enemies.yards30f;end
            else
                if ui.value("Deaths Caress Range") == 10 then validTargets = enemies.yards10;end
                if ui.value("Deaths Caress Range") == 20 then validTargets = enemies.yards20;end
                if ui.value("Deaths Caress Range") == 30 then validTargets = enemies.yards30;end
            end
            if validTargets ~= nil and #validTargets > 0 then
                for i=1, #validTargets do
                    if not unit.isBoss(validTargets[i]) and  (not unit.inCombat(validTargets[i]) or not unit.threat(validTargets[i])) then
                            if cast.deathsCaress(validTargets[i]) then
                                ui.debug("Pulling target with Death's Caress: " .. validTargets[i])
                                return true
                            end
                    end
                end
            end
        end
        
        validTargets = nil

        if cast.able.deathGrip("target") and ui.checked("Use Death Grip") then
            
            if ui.checked("DG only pull from FRONT") then
                if ui.value("Death Grip Range") == 10 then validTargets = enemies.yards10f;end
                if ui.value("Death Grip Range") == 20 then validTargets = enemies.yards20f;end
                if ui.value("Death Grip Range") == 30 then validTargets = enemies.yards30f;end
                if ui.value("Death Grip Range") == 40 then validTargets = enemies.yards40f;end
            else
                if ui.value("Death Grip Range") == 10 then validTargets = enemies.yards10;end
                if ui.value("Death Grip Range") == 20 then validTargets = enemies.yards20;end
                if ui.value("Death Grip Range") == 30 then validTargets = enemies.yards30;end
                if ui.value("Death Grip Range") == 40 then validTargets = enemies.yards40;end
            end
            if validTargets ~= nil and #validTargets > 0 then
                for i=1, #validTargets do
                    if not unit.isBoss(validTargets[i]) and  (not unit.inCombat(validTargets[i]) or not unit.threat(validTargets[i])) then
                            if cast.deathGrip(validTargets[i]) then
                                ui.debug("Pulling target with Death Grip: " .. validTargets[i])
                                return true
                            end
                    end
                end
            end
        end
    end
end

-- Action List - Defensive
actionList.Defensive = function()


end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
    if ui.useInterrupt() and ui.delay("Interrupts",unit.gcd()) then
        local thisUnit
        if ui.checked("Mind Freeze") and cast.able.mindFreeze("target") then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.mindFreeze(thisUnit) then ui.debug("Casting Mind Freeze on "..unit.name(thisUnit)) return true end
                end
            end
        end
        if ui.checked("Use Death Grip as Interrupt") and cast.able.deathGrip("target") then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip Interrupt on "..unit.name(thisUnit)) return true end
                end
            end
        end
    end
    
end -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldown = function()

end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        module.FlaskUp("Strength")
        -- if  not buff.augmentation.exists() then
        --     if use.bestItem(br.list.items.howlingRuneQualities) then ui.debug("Applying best Howling Rune") return true end
        -- end

        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Logic based on pull timers (IE: DBM/BigWigs)
        end -- End Pre-Pull
        
    end -- End No Combat
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runeTimeUntil(rCount)
    if rCount <= var.runeCount then return 0 end
        local delta = rCount - var.runeCount
        local maxTime = 0
        for i=1,delta do
            maxTime = math.max(maxTime,var.runeCooldowns[i])
        end
        return maxTime
end

local function boolNumeric(value)
    return value and 1 or 0
end


local function runRotation() -- This is the main profile loop, any below this point is ran every cycle, everything above is ran only once during initialization.
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals - These are the same as the locals above just defined for use.
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    enemies                                       = br.player.enemies
    module                                        = br.player.module
    power                                         = br.player.power
    talent                                        = br.player.talent
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    var                                           = br.player.variables
    debuff                                        = br.player.debuff
    runes                                         = br.player.power.runes()
    runicPower                                    = br.player.power.runicPower()
    runicPowerMax                                 = UnitPowerMax("player",6)
    var.inRaid                                    = br.player.instance=="raid"
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(10)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40) -- Makes a varaible called, enemies.yards40
    enemies.get(5,"player",false,true) -- makes enemies.yards5f
    enemies.get(10,"player",false, true)
    enemies.get(20,"player",false,true)
    enemies.get(30,"player",false,true)
    enemies.get(40,"player",false,true)

    ------------------------
    --- Custom Variables ---
    ------------------------
    --actions+=/variable,name=bone_shield_refresh_value,value=4,op=setif,condition=!talent.deaths_caress.enabled|talent.consumption.enabled|talent.blooddrinker.enabled,value_else=5
    var.boneShieldRefreshValue = 4
    if not talent.deathsCaress or talent.consumption or talent.blooddrinker then
        var.boneShieldRefreshValue = 5
    end
     --variable,name=heart_strike_rp_drw,value=(25+spell_targets.heart_strike*talent.heartbreaker.enabled*2)
     var.heartStrikeRpDrw = (25 + #enemies.yards5f * boolNumeric(talent.heartbreaker) * 2)
     ----variable,name=heart_strike_rp,value=(10+spell_targets.heart_strike*talent.heartbreaker.enabled*2)
     var.heartStrikeRp = (10 + #enemies.yards5f * boolNumeric(talent.heartbreaker) * 2)
     var.runicPowerDeficit = runicPowerMax - runicPower
     var.deathStrikeDumpAmount = 65

    var.minTTD=99999
    var.minTTDUnit="target"
    for i=1,#enemies.yards5 do
        local thisUnit=enemies.yards5[i]
        local thisCondition=unit.ttd(thisUnit)
        if not unit.isBoss(thisUnit) and thisCondition<var.minTTD then
            var.minTTD=thisCondition
            var.minTTDUnit=thisUnit
        end
    end

    --Ghoul Totem
    local haveTotem, totemName, startTime, duration, icon = GetTotemInfo(1)
    var.hasGhoul = haveTotem
    var.ghoulTTL = 0
    if haveTotem and totemName ~= nil then
        var.ghoulTTL = startTime + duration - ui.time() + 1.2
    end

    --rune cooldown timing, why they gotta number them in reverse? i.e. rune[6] is the leftmost. rune[1] rightmost.  
    var.runeCount = 0
    var.runeCountCoolDown = 0
    var.runeCooldowns = {}
    
    for i=1,6 do
        local rStart, rDuration, rRuneReady = _G.GetRuneCooldown(i)
        if rRuneReady then 
            var.runeCount = var.runeCount + 1
        else
            var.runeCountCoolDown = var.runeCountCoolDown + 1
            table.insert(var.runeCooldowns,(rStart + rDuration) - ui.time())
        end
    end
    table.sort(var.runeCooldowns)
 
    -- Any other local varaible from above would also need to be defined here to be use.
    if var.profileStop == nil then var.profileStop = false end -- Trigger variable to help when needing to stop a profile.

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then -- Reset profile stop once stopped
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then -- If profile triggered to stop go here until it has.
        return true
    else -- Profile is free to perform actions
        --------------
        --- Extras ---
        --------------
        if actionList.Extra() then return true end -- This runs the Extra Action List and anything in it will run in or out of combat, this generally contains utility functions.
        if actionList.Defensive() then return true end -- This runs the Defensive Action List and anything in it will run in or out of combat, this generally contains defensive functions.
        if actionList.PreCombat() then return true end  -- This runs the Pre-Combat Action List and anything in it will run in or out of combat, this generally includes functions that prepare for or start combat.
         if unit.inCombat() and unit.valid("target") and not var.profileStop then -- Everything below this line only run if you are in combat and the selected target is validated and not triggered to stop.
            if actionList.Interrupt() then return true end
            if actionList.CombatPull() then return true end

            if cast.able.raiseDead() then
                if cast.raiseDead() then ui.debug("B: Raise Dead") return true; end;
            end

            if buff.dancingRuneWeapon.exists() and (var.inRaid or var.inInstance) then
                if use.isOneOfUsable(br.lists.items.elementalPotionOfPowerQualities) then
                  if use.bestItem(br.lists.items.elementalPotionOfPowerQualities)   then ui.debug("9: POT") return true; end;
                end
            end

            --icebound_fortitude,if=!(buff.dancing_rune_weapon.up|buff.vampiric_blood.up)&(target.cooldown.pause_action.remains>=8|target.cooldown.pause_action.duration>0)
            if cast.able.iceboundFortitude() and (
                not (buff.dancingRuneWeapon.exists() or buff.vampiricBlood.exists()) 
            ) then
                if cast.iceboundFortitude() then ui.debug("C:Icebound fortitude") return true; end;
            end

            --vampiric_blood,if=!buff.vampiric_blood.up&!buff.vampiric_strength.up
            --TODO look into SC's second vampiric blood 
            if cast.able.vampiricBlood() and (not buff.vampiricBlood.exists() and not buff.vampiricStrength.exists()) then
                if cast.vampiricBlood() then ui.debug("D:Vampiric Blood") return true; end;
            end

            --deaths_caress,if=!buff.bone_shield.up
            if not buff.boneShield.exists() and cast.able.deathsCaress("target") then
                if cast.deathsCaress("target") then ui.debug("E:Deaths Caress") return true; end;
            end

            --death_and_decay,if=!death_and_decay.ticking&(talent.unholy_ground|talent.sanguine_ground|spell_targets.death_and_decay>3|buff.crimson_scourge.up)
            if not buff.deathAndDecay.exists("player") and 
                (talent.unholyGround or 
                talent.sanguineGround or 
                buff.crimsonScourge.exists() or 
                #enemies.yards10 > 3) and
                 cast.able.deathAndDecay("playerGround") then
                    if cast.deathAndDecay("playerGround") then ui.debug("F:Death and Decay") return true; end;
            end

            --death_strike,if=buff.coagulopathy.remains<=gcd|buff.icy_talons.remains<=gcd
            --|runic_power>=variable.death_strike_dump_amount|runic_power.deficit<=variable.heart_strike_rp|target.time_to_die<10
            if (
                (buff.coagulopathy.remains() <= unit.gcd() or
                buff.icyTalons.remains() <= unit.gcd() or
                runicPower >= var.deathStrikeDumpAmount or
                var.runicPowerDeficit <= var.heartStrikeRp or
                unit.ttd("target") < 10) and
                cast.able.deathStrike("target")
            ) then
                if cast.deathStrike("target") then ui.debug("G:Death Strike") return true; end;
            end

            --	blooddrinker,if=!buff.dancing_rune_weapon.up
            if not buff.dancingRuneWeapon.exists() and cast.able.blooddrinker("target") then
                if cast.blooddrinker("target") then ui.debug("Blooddrinker channel") return true; end
            end
            
            --call_action_list,name=racials
            if cast.able.racial() then
                if cast.racial() then ui.debug("H: Racial") return true; end;
            end


            --sacrificial_pact,if=!buff.dancing_rune_weapon.up&(pet.ghoul.remains<2|target.time_to_die<gcd)
            if talent.sacrificialPact and 
                not buff.dancingRuneWeapon.exists("player")  and 
                (var.hasGhoul and var.ghoulTTL < 2 or unit.ttd("target") < unit.gcd() ) and 
                cast.able.sacrificialPact()  then
                    if cast.sacrificialPact() then ui.debug("Sacrificial Pact") return true; end;
            end

            --blood_tap,if=(rune<=2&rune.time_to_4>gcd&charges_fractional>=1.8)|rune.time_to_3>gcd
            if (runes <= 2 and runeTimeUntil(4) > unit.gcd() and charges.bloodTap.timeTillFull() <= (unit.gcd() * 0.2) ) or runeTimeUntil(3) > unit.gcd() and cast.able.bloodTap() then
                if cast.bloodTap() then ui.debug("I:Blood Tap") return true; end;
            end

            --gorefiends_grasp,if=talent.tightening_grasp.enabled
            if talent.tighteningGrasp and cast.able.gorefiendsGrasp("target") then
                if cast.gorefiendsGrasp("target") then ui.debug("GoreFiends Grasp") return true; end;
            end

            --empower_rune_weapon,if=rune<6&runic_power.deficit>5
            if runes < 6 and (runicPowerMax - runicPower) > 5 and cast.able.empowerRuneWeapon() then
                if cast.empowerRuneWeapon() then ui.debug("J:Empower Rune Weapon") return true; end;
            end

            if cast.able.abominationLimb() then
                if cast.abominationLimb() then ui.debug("Abomination Limb") return true; end;
            end

            --dancing_rune_weapon,if=!buff.dancing_rune_weapon.up
            if not buff.dancingRuneWeapon.exists() and cast.able.dancingRuneWeapon() then
                if cast.dancingRuneWeapon() then ui.debug("K:Dancing Rune Weapon") return true; end;
            end

            --DRW sub Routine
            if buff.dancingRuneWeapon.exists() then
                
                --blood_boil,if=!dot.blood_plague.ticking
                if not debuff.bloodPlague.exists("target") and cast.able.bloodBoil() then
                    if cast.bloodBoil("target") then ui.debug("blood boil") return true; end;
                end
                --tombstone,if=buff.bone_shield.stack>5&rune>=2&runic_power.deficit>=30&!talent.shattering_bone|(talent.shattering_bone.enabled&death_and_decay.ticking)
                if buff.boneShield.stack("player") > 5 and 
                    runes >= 2 and 
                    (runicPowerMax - runicPower) >= 30 
                    and not talent.shatteringBone or (talent.shatteringBone and buff.deathAndDecay.exists()) and
                    cast.able.tombstone() then
                        if cast.tombstone() then ui.debug("N:tombstone") return true; end;
                end

                --death_strike,if=buff.coagulopathy.remains<=gcd|buff.icy_talons.remains<=gcd
                if cast.able.deathStrike("target") and (buff.coagulopathy.remains() <= unit.gcd() or buff.icyTalons.remains() <= unit.gcd()) then
                    if cast.deathStrike("target") then ui.debug("Death Strike") return true; end;
                end

                --marrowrend,if=(buff.bone_shield.remains<=4|buff.bone_shield.stack<variable.bone_shield_refresh_value)&runic_power.deficit>20
                if cast.able.marrowrend("target") and 
                (buff.boneShield.remains() <=4 or buff.boneShield.stack("player") < var.boneShieldRefreshValue) and 
                (var.runicPowerDeficit) > 20 then
                    if cast.marrowrend("target") then ui.debug("O:Marrowrend") return true; end;
                end

                --soul_reaper,if=active_enemies=1&target.time_to_pct_35<5&target.time_to_die>(dot.soul_reaper.remains+5)
                if cast.able.soulReaper("target") and #enemies.yards5==1 and br.getHP("target") <= 35 then
                    if cast.soulReaper("target") then ui.debug("P:Soul Reapoer") return true; end;
                end

                --soul_reaper,target_if=min:dot.soul_reaper.remains,if=target.time_to_pct_35<5&active_enemies>=2&target.time_to_die>(dot.soul_reaper.remains+5)
                --TODO Needs Help
                if cast.able.soulReaper() then
                    for i=1, #enemies.yards5f do
                        if br.getHP(enemies.yards5f[i]) <= 35 then
                            if cast.soulReaper(enemies.yards5f[i]) then ui.debug("Soul Repear") return true; end;
                        end
                    end
                end

                --death_and_decay,if=!death_and_decay.ticking&(talent.sanguine_ground|talent.unholy_ground)
                if cast.able.deathAndDecay("playerGround") and not buff.deathAndDecay.exists() and (talent.sanguineGround or talent.unholyGround) then
                    if cast.deathAndDecay("playerGround") then ui.debug("Death and Decay") return true; end;
                end

                --blood_boil,if=spell_targets.blood_boil>2&charges_fractional>=1.1
                --TODO Fractional Charges
                if cast.able.bloodBoil() and #enemies.yards10 > 2 then
                    if cast.bloodBoil() then ui.debug("Blood Boil") return true; end;
                end

                --death_strike,if=runic_power.deficit<=variable.heart_strike_rp_drw|runic_power>=variable.death_strike_dump_amount
                if cast.able.deathStrike("target") and (var.runicPowerDeficit <= var.heartStrikeRpDrw or runicPower >= var.deathStrikeDumpAmount) then
                    if cast.deathStrike("target") then ui.debug("Q:death strike") return true; end;
                end

                if cast.able.consumption("target") then 
                    if cast.consumption("target") then ui.debug("Consumption") return true; end;
                end

                --blood_boil,if=charges_fractional>=1.1&buff.hemostasis.stack<5
                --TODO fractional charges
                if cast.able.bloodBoil() and buff.hemostasis.stack() < 5 then
                    if cast.bloodBoil() then ui.debug("R:Blood boil") return true; end;
                end

                --heart_strike,if=rune.time_to_2<gcd|runic_power.deficit>=variable.heart_strike_rp_drw
                --ui.debug("Heart Strike Check: TT2:" .. runeTimeUntil(2) .. " GCD:" .. unit.gcd() .. " Power Def:" .. var.runicPowerDeficit .. "HeartStrikeRP:" .. var.heartStrikeRp)
                if cast.able.heartStrike("target") and (runeTimeUntil(2) < unit.gcd() or var.runicPowerDeficit >= var.heartStrikeRpDrw) then
                    if cast.heartStrike("target") then ui.debug("S:Heart Strike") return true; end;
                end
            end
            --tombstone,if=buff.bone_shield.stack>5&rune>=2&runic_power.deficit>=30&!talent.shattering_bone|(talent.shattering_bone.enabled&death_and_decay.ticking)
            --&cooldown.dancing_rune_weapon.remains>=25
            if cast.able.tombstone() and (
                buff.boneShield.stack() > 5 and runes >= 2 and var.runicPowerDeficit >= 30 and 
                (not talent.shatteringBone or (talent.shatteringBone and buff.deathAndDecay.exists())) and
                cd.dancingRuneWeapon.remains() >= 25) then
                    if cast.tombstone() then ui.debug("Tombstone") return true; end;
            end
            
            --death_strike,if=buff.coagulopathy.remains<=gcd|buff.icy_talons.remains<=gcd|runic_power>=variable.death_strike_dump_amount|runic_power.deficit<=variable.heart_strike_rp|target.time_to_die<10
            if cast.able.deathStrike("target") and (
                buff.coagulopathy.remains() <= unit.gcd() or
                buff.icyTalons.remains() <= unit.gcd() or
                runicPower >= var.deathStrikeDumpAmount or
                var.runicPowerDeficit <= var.heartStrikeRp or
                unit.ttd("target") < 10
            ) then
                if cast.deathStrike("target") then ui.debug("Death Strike") return true; end;
            end

            --deaths_caress,if=(buff.bone_shield.remains<=4|(buff.bone_shield.stack<variable.bone_shield_refresh_value+1))&runic_power.deficit>10&
            --!(talent.insatiable_blade&cooldown.dancing_rune_weapon.remains<buff.bone_shield.remains)&
            --!talent.consumption.enabled&!talent.blooddrinker.enabled&rune.time_to_3>gcd
            if cast.able.deathsCaress("target") and (
                (buff.boneShield.remains() <= 4 or (buff.boneShield.stack() < var.boneShieldRefreshValue+1)) and 
                var.runicPowerDeficit > 10 and
                not (talent.insatiableBlade and cd.dancingRuneWeapon.remains() < buff.boneShield.remains()) and
                not talent.cosumption and not talent.blooddrinker and runeTimeUntil(3) > unit.gcd()
                ) then
                    if cast.deathsCaress("target") then ui.debug("T:deaths Caress") return true; end;
            end

            --marrowrend,if=(buff.bone_shield.remains<=4|buff.bone_shield.stack<variable.bone_shield_refresh_value)&
            --runic_power.deficit>20&!(talent.insatiable_blade&cooldown.dancing_rune_weapon.remains<buff.bone_shield.remains)
            if cast.able.marrowrend("target") and (
                (buff.boneShield.remains() <= 4 or buff.boneShield.stack() < var.boneShieldRefreshValue) and
                var.runicPowerDeficit >20 and 
                not (talent.insatiableBlade and cd.dancingRuneWeapon.remains() < buff.boneShield.remains()) 
            ) then
                if cast.marrowrend("target") then ui.debug("U: Marrowrend") return true; end;
            end

            --consumption
            if cast.able.consumption() then
                if cast.consumption() then ui.debug("Consumption") return true; end;
            end

            --soul_reaper,if=active_enemies=1&target.time_to_pct_35<5&target.time_to_die>(dot.soul_reaper.remains+5)
            --soul_reaper,target_if=min:dot.soul_reaper.remains,if=target.time_to_pct_35<5&active_enemies>=2&target.time_to_die>(dot.soul_reaper.remains+5)
            -- Look for target to hit with soul reaper
            for i=1,#enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if br.getHP(thisUnit) <= 35 and unit.ttd(thisUnit) > (debuff.soulReaper.remains()+5) then
                    if cast.able.soulReaper(thisUnit) then
                        if cast.soulReaper(thisUnit) then ui.debug("V: SoulReaper") return true; end;
                    end
                end
            end

            --bonestorm,if=runic_power>=100
            if cast.able.bonestorm() and runicPower >= 100 then
                if cast.bonestorm() then ui.debug("bonestorm") return true; end;
            end

            --blood_boil,if=charges_fractional>=1.8&(buff.hemostasis.stack<=(5-spell_targets.blood_boil)|spell_targets.blood_boil>2)
            if cast.able.bloodBoil() and (
                charges.bloodBoil.count() > 1 and (buff.hemostasis.stack() <= (5-#enemies.yards10) or #enemies.yards10 > 2)
            ) then
                if cast.bloodBoil() then ui.debug("W:Blood Boil") return true; end;
            end

            --heart_strike,if=rune.time_to_4<gcd
            if cast.able.heartStrike("target") and runeTimeUntil(4) < unit.gcd() then
                if cast.heartStrike("target") then ui.debug("X: Heart Strike") return true; end;
            end

            --blood_boil,if=charges_fractional>=1.1
            if cast.able.bloodBoil() and charges.bloodBoil.count() > 1 then
                if cast.bloodBoil() then ui.debug("Y: Blood Boil") return true; end;
            end

            --heart_strike,if=(rune>1&(rune.time_to_3<gcd|buff.bone_shield.stack>7))
            if cast.able.heartStrike("target") and (
                runes > 1 and (runeTimeUntil(3) < unit.gcd() or buff.boneShield.stack() > 7)
            ) then
                if cast.heartStrike("target") then ui.debug("Z: Heart Strike") return true; end;
            end

            if cast.able.autoAttack("target") and unit.distance("target") <= 5 then
                if cast.autoAttack("target") then ui.debug("EOR: Auto Attack") return true end
            end

        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 250 
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})