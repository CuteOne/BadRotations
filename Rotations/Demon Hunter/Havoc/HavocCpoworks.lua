if select(2, UnitClass("player")) == "DEMONHUNTER" then
	local rotationName = "Cpoworks"

---------------
--- Toggles ---
---------------
	local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.bladeDance},
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.bladeDance},
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.chaosStrike},
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.spectralSight}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.metamorphosis},
            [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.metamorphosis},
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.metamorphosis}
        };
       	CreateButton("Cooldown",2,0)
    -- Mover
        MoverModes = {
            [1] = { mode = "AC", value = 1 , overlay = "Movement Animation Cancel Enabled", tip = "Will Cancel Movement Animation.", highlight = 1, icon = bb.player.spell.felRush},
            [2] = { mode = "On", value = 2 , overlay = "Auto Movement Enabled", tip = "Will Cast Movement Abilities.", highlight = 0, icon = bb.player.spell.felRush},
            [3] = { mode = "Off", value = 3 , overlay = "Auto Movement Disabled", tip = "Will NOT Cast Movement Abilities", highlight = 0, icon = bb.player.spell.felRush}
        };
        CreateButton("Mover",3,0)
    end

---------------
--- OPTIONS ---
---------------
	local function createOptions()
        local optionTable

        local function rotationOptions()
            local section
        -- General Options
            section = bb.ui:createSection(bb.ui.window.profile, "General")
            -- Eye Beam Targets
                bb.ui:createSpinner(section, "Eye Beam Targets", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use at.")
            -- Glide Fall Time
                bb.ui:createSpinner(section, "Glide", 2, 0, 10, 1, "|cffFFBB00Seconds until Glide will be used while falling.")
            bb.ui:checkSectionState(section)
        -- Cooldown Options
            section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
            -- Agi Pot
                bb.ui:createCheckbox(section,"Agi-Pot")
            -- Flask / Crystal
                bb.ui:createCheckbox(section,"Flask / Crystal")
            -- Racial
                bb.ui:createCheckbox(section,"Racial")
            -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
            -- Metamorphosis
                bb.ui:createCheckbox(section,"Metamorphosis")
            bb.ui:checkSectionState(section)
        -- Toggle Key Options
            section = bb.ui:createSection(bb.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
                bb.ui:createDropdown(section, "Rotation Mode", bb.dropOptions.Toggle,  6)
            -- Cooldown Key Toggle
                bb.ui:createDropdown(section, "Cooldown Mode", bb.dropOptions.Toggle,  6)
            -- Mover Key Toggle
                bb.ui:createDropdown(section, "Mover Mode", bb.dropOptions.Toggle,  6)
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
        if bb.timer:useTimer("debugHavoc", math.random(0.15,0.3)) then
            --print("Running: "..rotationName)

    ---------------
	--- Toggles ---
	---------------
	        UpdateToggle("Rotation",0.25)
	        UpdateToggle("Cooldown",0.25)
            UpdateToggle("Mover",0.25)

	--------------
	--- Locals ---
    --------------
            local addsExist                                     = false 
            local addsIn                                        = 999
            local artifact                                      = bb.player.artifact
            local buff                                          = bb.player.buff
            local canFlask                                      = canUse(bb.player.flask.wod.agilityBig)
            local cast                                          = bb.player.cast
            local castable                                      = bb.player.cast.debug
            local combatTime                                    = getCombatTime()
            local cd                                            = bb.player.cd
            local charges                                       = bb.player.charges
            local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
            local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
            local debuff                                        = bb.player.debuff
            local enemies                                       = bb.player.enemies
            local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
            local flaskBuff                                     = getBuffRemain("player",bb.player.flask.wod.buff.agilityBig)
            local friendly                                      = friendly or UnitIsFriend("target", "player")
            local gcd                                           = bb.player.gcd
            local hasMouse                                      = ObjectExists("mouseover")
            local healPot                                       = getHealthPot()
            local inCombat                                      = bb.player.inCombat
            local inInstance                                    = bb.player.instance=="party"
            local inRaid                                        = bb.player.instance=="raid"
            local lastSpell                                     = lastSpellCast
            local level                                         = bb.player.level
            local lootDelay                                     = getOptionValue("LootDelay")
            local lowestHP                                      = bb.friend[1].unit
            local mode                                          = bb.player.mode
            local moveIn                                        = 999
            -- local multidot                                      = (useCleave() or bb.player.mode.rotation ~= 3)
            local perk                                          = bb.player.perk        
            local php                                           = bb.player.health
            local playerMouse                                   = UnitIsPlayer("mouseover")
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

            if leftCombat == nil then leftCombat = GetTime() end
            if profileStop == nil then profileStop = false end
            if talent.chaosCleave then chaleave = 1 else chaleave = 0 end
            if talent.prepared then prepared = 1 else prepared = 0 end
            if talent.firstBlood then flood = 1 else flood = 0 end
            if lastSpell == spell.vengefulRetreat then vaulted = true else vaulted = false end
            if mode.mover == 1 then
                if IsHackEnabled("NoKnockback") ~= nil then SetHackEnabled("NoKnockback", false) end
            end

	--------------------
	--- Action Lists ---
	--------------------
        -- Action List - Single Target
            local function actionList_SingleTarget()
            -- Fel Eruption
                if cast.felEruption() then return end
            -- Death Sweep
                -- if HasTalent(FirstBlood)
                if talent.firstBlood then
                    if cast.deathSweep() then return end
                end
            -- Annihilation
                -- if not HasTalent(Momentum) or (HasBuff(Momentum) or PowerToMax <= 30 + TimerSecRemaining(PreparedTimer) * 8)
                if not talent.momentum or (buff.momentum or powerDeficit <= 30 + prepared * 8) then
                    if cast.annihilation() then return end
                end
            -- Fel Barrage
                -- if ChargesRemaining(FelBarrage) = SpellCharges(FelBarrage)
                if charges.felBarrage == charges.max.felBarrage then
                    if cast.felBarrage(units.dyn5) then return end
                end
            -- Throw Glaive
                -- if HasTalent(Bloodlet)
                if talent.bloodlet then
                    if cast.throwGlaive() then return end
                end
            -- Eye Beam
                if (not buff.metamorphosis and (not talent.momentum or buff.momentum)) and getDistance(units.dyn8) < 8 and getFacing("player",units.dyn5,45) then
                    if cast.eyeBeam(units.dyn5) then return end
                end
            -- Blade Dance
                -- if CooldownSecRemaining(EyeBeam) > 0 and HasTalent(FirstBlood)
                if (cd.eyeBeam > 0 or not isKnown(spell.eyeBeam)) and talent.firstBlood then
                    if cast.bladeDance() then return end
                end
            -- Chaos Strike
                -- if CooldownSecRemaining(EyeBeam) > 0
                if cd.eyeBeam > 0 or (buff.momentum or powerDeficit <= 30 + prepared * 8) then
                    if cast.chaosStrike() then return end
                end
            -- Felblade
                if cast.felblade("target") then return end
            -- Demon's Bite
                if cast.demonsBite() then return end
            -- Throw Glaive
                if cast.throwGlaive() then return end
            end -- End Action List - Single Target
        -- Action List - MultiTarget
            local function actionList_MultiTarget()
            -- Death Sweep
                if cast.deathSweep() then return end
            -- Fel Barrage
                -- if ChargesRemaining(FelBarrage) = SpellCharges(FelBarrage)
                if charges.felBarrage == charges.max.felBarrage then
                    if cast.felBarrage(units.dyn5) then return end
                end
            -- Eye Beam
                if getDistance(units.dyn5) < 5 and getFacing("player",units.dyn5,45) then
                    if cast.eyeBeam(units.dyn5) then return end
                end
            -- Fel Rush
                if useMover() and getFacing("player","target",10) then
                    if mode.mover == 1 then
                        if getDistance("target") < 10 then
                            if cast.felRush("target",false,true) then return end
                        end
                        if getDistance("target") >= 10 then
                            if cast.felRush() then return end
                        end
                    else
                        if cast.felRush() then return end
                    end
                end
            -- Blade Dance
                -- if CooldownSecRemaining(EyeBeam) > 0
                if cd.eyeBeam > 0 or not isKnown(spell.eyeBeam) then
                    if cast.bladeDance() then return end
                end
            -- Throw Glaive
                if cast.throwGlaive() then return end
            -- Annihilation
                if cast.annihilation() then return end
            -- Chaos Strike
                if cast.chaosStrike() then return end
            -- Demon's Bite
                if cast.demonsBite() then return end    
            end -- End Action List - Multi Target
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if useCDs() and getDistance(units.dyn5) < 5 then
            -- Trinkets
                    -- use_item,slot=trinket2,if=buff.chaos_blades.up|!talent.chaos_blades.enabled 
                    if isChecked("Trinkets") then
                        if buff.chaosBlades or not talent.chaosBlades then 
                            if canUse(13) then
                                useItem(13)
                            end
                            if canUse(14) then
                                useItem(14)
                            end
                        end
                    end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- blood_fury,buff.tigers_fury | berserking,buff.tigers_fury | arcane_torrent,buff.tigers_fury
                    if isChecked("Racial") and (bb.player.race == "Orc" or bb.player.race == "Troll" or bb.player.race == "Blood Elf") then
                        if castSpell("player",racial,false,false,false) then return end
                    end
            -- Metamorphosis
                    -- if (not HasTalent(DemonReborn) or CooldownSecRemaining(EyeBeam) > 0) and not HasBuff(Metamorphosis)
                    if (not talent.demonReborn or cd.eyeBeam > 0) and not buff.metamorphosis then
                        if cast.metamorphosis() then return end
                    end
            -- Nemesis
                    if cast.nemesis(units.dyn5) then return end
            -- Chaos Blades
                    -- if CooldownSecRemaining(Metamorphosis) > SpellCooldownSec(ChaosBlades) - BuffDurationSec(ChaosBlades) or HasBuff(Metamorphosis)
                    if (cd.metamorphosis > cd.chaosBlades - buff.duration.chaosBlades or buff.metamorphosis) and getDistance(units.dyn5) < 5 then
                        if cast.chaosBlades() then return end
                    end 
                    
            -- Agi-Pot
                    -- potion,name=deadly_grace,if=buff.metamorphosis.remains>25
                    if isChecked("Agi-Pot") and canUse(109217) and inRaid then
                        if buff.remain.metamorphosis > 25 then
                            useItem(109217)
                        end
                    end
                end -- End useCDs check
            end -- End Action List - Cooldowns
        -- Action List - PreCombat
            local function actionList_PreCombat()
                if not inCombat and not (IsFlying() or IsMounted()) then
                -- Flask / Crystal
                    -- flask,type=flask_of_the_seventh_demon
                    if isChecked("Flask / Crystal") then
                        if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",188033) and not UnitBuffID("player",156064) then
                            useItem(bb.player.flask.wod.agilityBig)
                            return true
                        end
                        if flaskBuff==0 then
                            if not UnitBuffID("player",188033) and not UnitBuffID("player",156064) and canUse(118922) then --Draenor Insanity Crystal
                                useItem(118922)
                                return true
                            end
                            if not UnitBuffID("player",193456) and not UnitBuffID("player",188033) and not UnitBuffID("player",156064) and canUse(129192) then -- Gaze of the Legion
                                useItem(129192)
                                return true
                            end
                        end
                    end
                    if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

                    end -- End Pre-Pull
                    if ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") and getDistance("target") < 5 then
                -- Start Attack
                        StartAttack()
                    end
                end -- End No Combat
            end -- End Action List - PreCombat 
    ---------------------
    --- Begin Profile ---
    ---------------------
        -- Profile Stop | Pause
            if not inCombat and not hastar and profileStop==true then
                profileStop = false
            elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 then
                return true
            else
    ------------------------------
    --- Out of Combat Rotation ---
    ------------------------------
                if actionList_PreCombat() then return end
    --------------------------
    --- In Combat Rotation ---
    --------------------------
                if inCombat and profileStop==false and ObjectExists(units.dyn5) and not UnitIsDeadOrGhost(units.dyn5) and UnitCanAttack(units.dyn5, "player") and not isCastingSpell(spell.eyeBeam) then
        ----------------------
        --- AskMrRobot APL ---
        ----------------------
                -- Blur
                    -- if ChargesRemaining(FelRush) = 0 and (not HasTalent(Momentum) or CooldownSecRemaining(VengefulRetreat) > (BuffDurationSec(Momentum) + BuffRemainingSec(Momentum)))
                    if charges.felRush == 0 and (not talent.momentum or cd.vengefulRetreat > (buff.duration.momentum + buff.remain.momentum)) then
                        if cast.blur() then return end
                    end
                -- Vengeful Retreat
                    if useMover() and (talent.momentum and not buff.momentum) and getDistance("target") < 5 then
                        if cast.vengefulRetreat() then return end
                    end
                -- Fel Rush
                    -- if HasTalent(Momentum) and not HasBuff(Momentum) and CooldownSecRemaining(VengefulRetreat) > BuffDurationSec(Momentum)
                    if useMover() and getFacing("player","target",10) and (talent.momentum and not buff.momentum) then
                        if mode.mover == 1 then
                            if getDistance("target") < 10 then
                                if cast.felRush("target",false,true) then return end
                            end
                            if getDistance("target") >= 10 then
                                if cast.felRush() then return end
                            end
                        else
                            if cast.felRush() then return end
                        end
                    end
                -- Cooldowns
                    if actionList_Cooldowns() then return end
                -- Fury of the Illidari
                    if #enemies.yards8 > getOptionValue("Eye Beam Targets") and getDistance("target") < 5 or addsIn > 55 and (not talent.momentum or buff.momentum) then
                        if cast.furyOfTheIllidari() then return end
                    end
                -- MultiTarget
                    -- if TargetsInRadius(BladeDanceHitAoE) > 1
                    if (#enemies.yards8 > 1 and mode.rotation == 1) or mode.rotation == 2 then
                        if actionList_MultiTarget() then return end
                    end
                -- Single Target
                    if actionList_SingleTarget() then return end
        
				end --End In Combat
			end --End Rotation Logic
        end -- End Timer
    end -- End runRotation
    tinsert(cHavoc.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check