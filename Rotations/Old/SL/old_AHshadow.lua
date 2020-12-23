local rotationName = "AHshadow" -- Change to name of profile listed in options drop down
if sear == nil then sear = false end

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.shadowWordVoid },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.mindSear},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mindFlay },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.psychicHorror}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.shadowfiend },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.shadowfiend },
        [3] = { mode = "Lust", value = 3 , overlay = "Cooldowns on Lust", tip = "Use Cooldowns on Bloodlust only", highlight = 0, icon = br.player.spell.shadowWordPain },
        [4] = { mode = "Off", value = 4 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.shadowform }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dispersion },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dispersion }
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.silence },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.silence }
    };
    CreateButton("Interrupt",4,0)
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
            br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "Desired time to test in minutes.")
            
            br.ui:createSpinner(section, "Pre-Pull Timer", 5, 1, 10, 1, "Time to begin casting on Pull Timer (DBM Required)")

            br.ui:createSpinnerWithout(section, "SWP Max Targets", 4, 1, 10, 1, "Limit that SWP will be cast on.")

            br.ui:createSpinnerWithout(section, "SWP Dot Hp Limit", 5, 1, 10, 1, "Limit HP to stop SWP Refresh. x10K")

            br.ui:createSpinnerWithout(section, "VT Max Targets", 4, 1, 10, 1, "Limit that VT will be cast on.")

            br.ui:createSpinnerWithout(section, "VT Dot HP Limit", 5, 1, 10, 1, "Limit  HP to stop VT Refresh. x10K")

            br.ui:createSpinnerWithout(section, "Dark Void Enemies", 3, 1, 10, 1)

            br.ui:createSpinnerWithout(section, "Mind Sear Targets", 3, 1, 10, 1)
            
            br.ui:createSpinnerWithout(section, "Full Cast Mind Sear", 5, 1, 20, 1, "Full Cast Mind Sear after Dark Void at X Targets.")
        
            br.ui:createCheckbox(section, "Shadow Crash")

            br.ui:createCheckbox(section,"PWS: Body and Soul")

        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            br.ui:createCheckbox(section, "Intellect Potion")
            br.ui:createCheckbox(section, "Int. Flask")
            br.ui:createCheckbox(section, "Trinkets")
            br.ui:createCheckbox(section, "Racials")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            br.ui:createSpinner(section, "Dispersion", 10, 5, 100, 5)

            br.ui:createSpinner(section, "Vampiric Embrace", 10, 5, 100, 5)

            br.ui:createSpinner(section, "Healthstone", 10, 5, 100, 5)

            br.ui:createSpinner(section, "Shadow Mend", 10, 5, 100, 5)

            br.ui:createSpinner(section, "Power Word: Shield", 10, 5, 100, 5)

            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru", 50, 0, 100, 5, "Percent to cast GotN at")
            end

            br.ui:createCheckbox(section, "Fade", "Use Fade when you got aggro.")

        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            br.ui:createCheckbox(section, "Silence")
            br.ui:createCheckbox(section, "Mindbomb")
            br.ui:createCheckbox(section, "Psychic Scream")
            br.ui:createCheckbox(section, "Psychic Horror")        
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  30,  10,  95,  5,  "|cffFFBB00Cast Percentage to use at.")    
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
    if br.timer:useTimer("debugShadow", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
        --Print("Running: "..rotationName)
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
        local addsExist                                     = false
        local addsIn                                        = 999
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local canFlask                                      = canUseItem(br.player.flask.wod.agilityBig)
        local cast                                          = br.player.cast
        local castable                                      = br.player.cast.debug
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies 
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastCast                                      = lastCast
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.ui.mode
        local moveIn                                        = 999
        local moving                                        = (isMoving("player") and not br.player.buff.norgannonsForesight.exists())
        -- local multidot                                      = (useCleave() or br.player.ui.mode.rotation ~= 3)
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.insanity.amount(), br.player.power.insanity.max(), br.player.power.insanity.regen(), br.player.power.insanity.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = #br.friend < 2
        local spell                                         = br.player.spell
        local t18_2pc                                       = TierScan("T18")>=2
        local t19_2pc                                       = TierScan("T19")>=2
        local t19_4pc                                       = TierScan("T19")>=4
        local t20_4pc                                       = TierScan("T20")>=4
        local talent                                        = br.player.talent
        local thp                                           = getHP("target")
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.insanity.ttm()
        local units                                         = br.player.units 

        local SWPmaxTargets                                 = getOptionValue("SWP Max Targets")
        local VTmaxTargets                                  = getOptionValue("VT Max Targets")
        local mindFlayChannel                               = 3 / (1 + GetHaste()/100)



        if useMindBlast == nil then useMindBlast = false end
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        -- if HackEnabled("NoKnockback") ~= nil then HackEnabled("NoKnockback", false) end
        if t19_2pc then t19pc2 = 1 else t19pc2 = 0 end
        if t20_4pc then t20pc4 = 1 else t20pc4 = 0 end
        if hasBloodLust() then lusting = 1 else lusting = 0 end
        if talent.sanlayn then sanlayn = 1 else sanlayn = 0 end
        if talent.reaperOfSouls then reaperOfSouls = 1 else reaperOfSouls = 0 end
        if talent.legacyOfTheVoid then legacy = 1 else legacy = 0 end
        if talent.fortressOfTheMind then fortress = 1 else fortress = 0 end
        if isBoss() then vtHPLimit = getOptionValue("VT Dot HP Limit") * 10000 else vtHPLimit = getOptionValue("VT Dot HP Limit") * 10000 end
        if isBoss() then swpHPLimit = getOptionValue("VT Dot HP Limit") * 10000 else swpHPLimit = getOptionValue("SWP Dot HP Limit") * 10000 end
        if hasEquiped(132864) then mangaMad = 1 else mangaMad = 0 end

        units.get(5)
        units.get(8)
        enemies.get(5)
        enemies.get(8)
        enemies.get(10)
        enemies.get(20)
        enemies.get(30)
        enemies.get(40)
        enemies.get(8, "target")
        units.get(40)
        enemies.get(8,"target")
        enemies.get(10,"target")
        enemies.get(40)

        -- Instanity Stacks
        if buff.voidForm.stack() == 0 then drainStacks = 0 end
        if inCombat and buff.voidForm.stack() > 0 and not (buff.dispersion.exists() or buff.voidTorrent.exists()) then
            if br.timer:useTimer("drainStacker", 1) then
                drainStacks = drainStacks + 1
            end
        end

        -- Mind Flay Ticks

        local mfTick
        if mfTick == nil or not inCombat or not isCastingSpell(spell.mindFlay) then mfTick = 0 end
        if br.timer:useTimer("Mind Flay Ticks", 0.75) and (isCastingSpell(spell.mindFlay) or isCastingSpell(spell.mindSear)) then
            mfTick = mfTick + 1
        end

        -- Instanity Drain
        insanityDrain = 6 + (2 / 3 * (drainStacks))

        -- Void Bolt
        if isValidUnit(units.dyn40) and inCombat and buff.voidForm.exists() and (cd.voidBolt.remain() == 0 or buff.void.exists()) and not isCastingSpell(spell.voidTorrent) and sear == false and not sear == true then
            if cast.voidBolt(units.dyn40) then 
                return
            end
        end


       -- print("Sear Var: "..tostring(sear)..", Casting Sear: "..tostring(cast.current.mindSear()))
        -- Sear full cast

     --   if sear == true then
      --      if isCasting(spell.mindSear) then
       --         return true
       --     else
      --      if not isCasting(spell.mindSear) then 
       --         sear = false
       --         return
       --     end
      --      end
      --  end
      if searCastTime == nil then searCastTime = GetTime() end
      if sear == true and not cast.current.mindSear() and GetTime() - searCastTime > 1 then sear = false end

        --------------------
        --- Action Lists ---
        --------------------
        -- Extras
        function actionList_Extra()
            -- Dispel Magic
            if isChecked("Dispel Magic") and canDispel("target",spell.dispelMagic) and not isBoss() and GetObjectExists("target") then
                if cast.dispelMagic() then
                    return
                end
            end

            -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getOptionValue("DPS Testing")).."Minute Dummy Test Concluded - Profile Stopped.")
                        profileStop = true
                    end
                end
            end
        end
        -- Extras END
        --------------------------------------
        -- Defensives
        function actionList_Defensive()
            if mode.defensive == 1 and getHP("player") > 0 and inCombat then
                -- Gift of the Narru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if cast.racial() then 
                        return 
                    end
                end

                -- Dispersion
                if isChecked("Dispersion") and php <= getOptionValue("Dispersion") then
                    if cast.dispersion("player") then
                        return
                    end
                end

                -- Fade
                if isChecked("Fade") then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not solo and hasThreat(thisUnit) then
                            if cast.fade("player") then
                                return
                            end
                        end
                    end
                end

                -- Healthstones
                if isChecked("Healthstone") and php <= getOptionValue("Healthstone") and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(healPot) then
                        useItem(healPot)
                    end
                end


                -- PWS
                if isChecked("Power Word: Shield") and php <= getOptionValue("Power Word: Shield") and not buff.powerWordShield.exists() then
                    if cast.powerWordShield("player") then
                        return
                    end
                end

                -- Shadow Mend
                if isChecked("Shadow Mend") and php <= getOptionValue("Shadow Mend") then
                    if cast.shadowMend("player") then
                        return
                    end
                end

            end
        end
        -- Defensives end
        ------------------------------------
        -- Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then

                        -- Silence
                        if isChecked("Silence") then
                            if cast.silence(thisUnit) then
                                return
                            end
                        end

                        -- Psychic Horror
                        if isChecked("Psychic Horror") then
                            if cast.psychicHorror(thisUnit) then
                                return
                            end
                        end

                        -- Mind Bomb or Psychic Scream
                        if isChecked("Psychic Scream") and not talent.mindBomb then
                            if not talent.mindBomb and #enemies.yards8 > 0 then
                                if cast.psychicScream("player") then
                                    return
                                end
                            end
                        end
                        if isChecked("Mindbomb") and talent.mindBomb then
                            if #enemies.yards8t > 1 then
                                if cast.mindBomb(thisUnit) then
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
        -- Interrupts END
        ------------------------------
        -- Cooldowns
        function actionList_Cooldowns()
            if (mode.cooldown == 1 and isBoss()) or (mode.cooldown == 2) or (mode.cooldown == 3 and buff.bloodLust) then
                -- Racials
                if (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") and isChecked("Racials") then
                    if cast.racial() then
                        return
                    end
                end

                -- Trinkets
                if isChecked("Trinkets") then
                    if canUseItem(13) then
                        useItem(13)
                    end

                    if canUseItem(14) then
                        useItem(14)
                    end
                end

                -- Potion
                if isChecked("Potion") then
                    if GetItemCooldown(163222) == 0 and (buff.bloodlust.exists() or buff.timeWarp.exists() or buff.ancientHysteria.exists()) then
                        useItem(163222) 
                    end
                end

                -- Flask
                if isChecked("Flask") then
                    if GetItemCooldown(152639) and not buff.flaskOfEndlessFathoms.exists() then
                        useItem(152639)
                    end
                end

            end
        end
        -- Cooldowns END
        -----------------------------------------
        -- Pre Combat
        function actionList_PreCombat()
            if not inCombat then
                --Shadowform
                if not buff.shadowform.exists() then
                    if cast.shadowform() then
                        return
                    end
                end

                --    -- Mind Blast
                --    if isValidUnit("target") then
                --        if not moving and br.timer:useTimer("mbRecast", gcd) then
                --            if cast.mindBlast("target") then
                --                return
                --            end
                --        end
                --    end

                -- Body and Soul / Speed
                if isChecked("PWS: Body and Soul") and talent.bodyAndSoul and isMoving("player") and not IsMounted() and not debuff.weakenedSoul.exists("player") then
                    if cast.powerWordShield("player") then
                        return
                    end
                end
            end
        end
        -- Precombat END
        ------------------------------------------
        -- Check
        function actionList_Check()
            actorsFightTimeMod = 0

            if combatTime + ttd(units.dyn40) > 420 and combatTime + ttd(units.dyn40) < 600 then
                actorsFightTimeMod = -(( - (450) + (combatTime + ttd(units.dyn40))) / 10)
            end

            if combatTime + ttd(units.dyn40) <= 450 then
                actorsFightTimeMod = ((450 - (combatTime + ttd(unitsdyn40))) / 5)
            end

            -- S2M Checks
            -- NONE -- S2M SUCKS
        end
        -- Checks END
        ----------------------------------------
        -- Main
        function actionList_Main()
            -- Void Eruption
            if not moving then
                if cast.voidEruption() then
                    return
                end
            end

            -- Dark Ascension
            if talent.darkAscension and not buff.voidForm.exists() then
                if cast.darkAscension() then
                    return
                end
            end

            -- VT Refresh 2.0
            if debuff.vampiricTouch.remain("target") < 6.3 and not buff.void.exists() and not moving and not isCastingSpell(spell.vampiricTouch) and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") and vtHPLimit then
                if cast.vampiricTouch() then
                    return
                end
            end

            -- SWP Refresh 2.0
            if debuff.shadowWordPain.remain("target") < 4.8 and not buff.void.exists() and not moving and not isCastingSpell(spell.vampiricTouch) and debuff.shadowWordPain.count() <= getOptionValue("SWP Max Targets") and swpHPLimit then
                if cast.shadowWordPain() then
                    return
                end
            end


            -- VT Refresh
            if (debuff.vampiricTouch.remain("target") < 6.3 * gcd) or (not debuff.vampiricTouch.exists("target")) and not buff.void.exists() and not moving and not isCastingSpell(spell.vampiricTouch) and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") and vtHPLimit then
                if cast.vampiricTouch() then
                    return
                end
            end


            -- SWP Refresh
            if (debuff.shadowWordPain.remain("target") < 4.8 * gcd) or (not debuff.shadowWordPain.exists("target")) and not buff.void.exists() and not moving and not isCastingSpell(spell.vampiricTouch) and debuff.shadowWordPain.count() < getOptionValue("SWP Max Targets") and swpHPLimit then
                if cast.shadowWordPain() then
                    return
                end
            end
            -- Misery + VT APPLY
            if talent.misery and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if not debuff.vampiricTouch.exists(thisUnit)  then
                        if cast.vampiricTouch(thisUnit, "aoe") then
                            return
                        end
                    end
                end
            end

            -- Misery + VT Refresh
            if talent.misery and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if debuff.vampiricTouch.refresh(thisUnit)  then
                        if cast.vampiricTouch(thisUnit, "aoe") then
                            return
                        end
                    end
                end
            end

            -- No Misery + VT APPLY
            if not talent.misery and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if not debuff.vampiricTouch.exists(thisUnit)  then
                        if cast.vampiricTouch(thisUnit, "aoe") then
                            return
                        end
                    end
                end
            end

            -- Misery + VT Refresh
            if not talent.misery and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if debuff.vampiricTouch.refresh(thisUnit)  then
                        if cast.vampiricTouch(thisUnit, "aoe") then
                            return
                        end
                    end
                end
            end

            -- AoE + SWP APPLY
            if not talent.misery and debuff.shadowWordPain.count() <= getOptionValue("SWP Max Targets") and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if not debuff.shadowWordPain.exists(thisUnit)  then
                        if cast.shadowWordPain(thisUnit, "aoe") then
                            return
                        end
                    end
                end
            end

            -- AOE + SWP Refresh
            if not talent.misery and debuff.shadowWordPain.count() <= getOptionValue("SWP Max Targets") and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if debuff.shadowWordPain.refresh(thisUnit)  then
                        if cast.shadowWordPain(thisUnit, "aoe") then
                            return
                        end
                    end
                end
            end

            -- Mind Blast
            if cast.last.voidEruption() and not moving and not talent.shadowWordVoid then
                if cast.mindBlast() then 
                    return
                end
            end

            -- Mind Blast 2
            if cast.last.voidEruption() and not moving and not talent.shadowWordVoid and power <= 95.2 and talent.fortressOfTheMind and not buff.void.exists() then
                if cast.mindBlast() then
                    return
                end
            end

            -- Shadow Word Void
            if cast.last.voidEruption() and not moving and talent.shadowWordVoid and charges.shadowWordVoid.count() > 0 then
                if cast.shadowWordVoid() then 
                    return
                end
            end


            -- Mindbender
            if useCDs() and talent.mindbender and cast.able.mindbender and not buff.void.exists() then
                if cast.mindbender() then
                    return
                end
            else
                if useCDs() and not talent.mindbender and not buff.void.exists() then
                    if cast.shadowfiend() then
                        return
                    end
                end
            end

            -- Dark Void
            if #enemies.yards10t >= getOptionValue("Dark Void Enemies") and talent.darkVoid then
                if cast.darkVoid() then
                    return
                end
            end

            -- SWP
            if moving and talent.misery and debuff.shadowWordPain.count() < getOptionValue("SWP Max Targets") and not buff.void.exists() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.shadowWordPain.remain(thisUnit) < gcd then
                        if cast.shadowWordPain(thisUnit, "aoe") then
                            return
                        end
                    end
                end
            end
            -- VT
            if talent.misery and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") and not buff.void.exists() and not moving and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (getHP(thisUnit) > vtHPLimit or IsInInstance()) and ((debuff.vampiricTouch.remain(thisUnit) < 3 * gcd or debuff.shadowWordPain.remain(thisUnit) < 3 * gcd)) then
                        if cast.vampiricTouch(thisUnit,"aoe") then
                            return
                        end
                    end
                end
            end

            -- SWP 2
            if not talent.misery and debuff.shadowWordPain.remain(units.dyn40) < (3 + (4 / 3)) * gcd and not buff.void.exists () then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (getHP(thisUnit) > swpHPLimit or IsInInstance()) and ((debuff.shadowWordPain.remain(thisUnit) < 3 * gcd)) then
                        if cast.shadowWordPain(thisUnit) then
                            return
                        end
                    end
                end
            end
            -- VT 2
            if not talent.misery and debuff.vampiricTouch.remain(units.dyn40) < (3 + (4 / 3)) * gcd and not isCastingSpell(spell.vampiricTouch) and not buff.void.exists() and not moving and vtHPLimit and VTmaxTargets then
                if cast.vampiricTouch() then
                    return
                end
            end

            -- Shadow Crash
            if isChecked("Shadow Crash") and talent.shadowCrash and not buff.void.exists() then 
                if cast.shadowCrash("best",nil,1,8) then
                    return
                end
            end

            -- SWD
            if talent.shadowWordDeath and charges.shadowWordDeath.count() == 2 and power <= (85 - 15) and not buff.void.exists() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if getHP(thisUnit) < 20 then
                        if cast.shadowWordDeath(thisUnit) then
                            return
                        end
                    end
                end
            end

            -- SWP 3 
            if not talent.misery and ((mode.rotation == 1 and #enemies.yards40 < 5) or mode.rotation == 3) and (talent.auspiciousSpirits) and debuff.shadowWordPain.count() < getOptionValue("SWP Max Targets") and not buff.void.exists() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not debuff.shadowWordPain.exists(thisUnit) and ttd(thisUnit) > 10 then 
                        if cast.shadowWordPain(thisUnit,"aoe") then
                            return
                        end
                    end
                end
            end

            -- VT 3
            if #enemies.yards40 > 1 and not talent.misery and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") and not buff.void.exists() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (getHP(thisUnit) > vtHPLimit or IsInInstance()) and not debuff.vampiricTouch.exists(thisUnit) and (85.2 * (1 + 0.2 + GetMastery() / 16000) * (1 + 0.2 * sanlayn) * 0.5 * ttd(thisUnit) / (gcd * (138 + 80 * (#enemies.yards40 - 1)))) > 1 then
                        if cast.vampiricTouch(thisUnit,"aoe") then
                            return
                        end
                    end
                end
            end

            -- SWP 4
            if #enemies.yards40 > 1 and not talent.misery and debuff.shadowWordPain.count() < getOptionValue("SWP Max Targets") and not buff.void.exists() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not debuff.shadowWordPain.exists(thisUnit) and (47.12 * (1 + 0.2 + GetMastery() / 16000) * 0.75 * ttd(thisUnit) / (gcd * (138 + 80 * (#enemies.yards40 - 1)))) > 1 then
                        if cast.shadowWordPain(thisUnit,"aoe") then
                            return
                        end
                    end
                end
            end

            -- SVP 2
            if talent.shadowWordVoid and (power <= 75 - 10 * legacy) and not buff.void.exists() and charges.shadowWordVoid.count() > 0 then
                if cast.shadowWordVoid() then
                    return
                end
            end

            -- Mind Sear VF
            if ((mode.rotation == 1 and #enemies.yards10t >= getOptionValue("Mind Sear Targets")) or mode.rotation == 2) and charges.shadowWordVoid.count() < 1 and not buff.void.exists() and not moving and not isCastingSpell(spell.mindSear) then
                if cast.mindSear() then
                    return
                end
            end

        --    if not buff.void.exists() and not moving and not isCastingSpell(spell.mindSear) and #enemies.yards10t >= getOptionValue("Full Cast Mind Sear") then
          --      for i = 1, #enemies.yards40 do
            --    local thisUnit = enemies.yards40[i]
              --      if debuff.shadowWordPain.exists(thisUnit) then
                --        if cast.mindSearAoE() then
                  --          return
                    --    end
                   -- end
               -- end
           -- end


            -- Mind Sear + Thought Harvester Buff
            if buff.thoughtsHarvester.exists() and charges.shadowWordVoid.count() < 2 and not buff.void.exists() and not moving and not isCastingSpell(spell.mindSear) then
                if cast.mindSear() then
                    sear = true
                    searCastTime = GetTime();
                    return
                end
            end

            -- Mind Flay 
            if not buff.thoughtsHarvester.exists() and charges.shadowWordVoid.count() < 1 and not buff.void.exists() and not moving and not isCastingSpell(spell.mindFlay) and not isCastingSpell(spell.mindSear) and (mode.rotation == 1 and #enemies.yards10t < getOptionValue("Mind Sear Targets")) or (mode.rotation == 3) then
                if cast.mindFlay() then
                    return
                end
            end


            -- SVP 5 Moving
            if not debuff.shadowWordPain.exists(units.dyn40) or moving then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if cast.shadowWordPain(thisUnit) then
                        return
                    end
                end
            end

            -- Berserking // Troll
            if br.player.race == "Troll" and getSpellCD(racial) == 0 and buff.voidForm.stack() >= 65 and not buff.void.exists() then
                if castSpell("player",racial,false,false,false) then
                    return
                end
            end

            -- SWD 2
            if insanityDrain * gcd > power and (power - (insanityDrain * gcd) < 100) and not buff.void.exists() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if getHP(thisUnit) < 20 then
                        if cast.shadowWordDeath(thisUnit) then
                            return
                        end
                    end
                end
            end
        end
        -- Action Main End
        -----------------------------------------
        -- Action Voidform
        function actionList_VoidForm()
            -- Void Bolt
            if cd.voidBolt.remain() == 0 or buff.void.exists() then
                if cast.voidBolt(units.dyn40) then
                    return
                end
            end

            -- Dark Ascension
            if talent.darkAscension and buff.voidForm.exists() and power < 10 then
                if cast.darkAscension() then
                    return
                end
            end

            -- Dark Void
            if talent.darkVoid and #enemies.yards10t >= getOptionValue("Dark Void Enemies") then
                if cast.darkVoid() then
                    return
                end
            end

            -- VT Refresh
            if (debuff.vampiricTouch.remain("target") < 6.3 * gcd) or (not debuff.vampiricTouch.exists("target")) and vtHPLimit and not buff.void.exists() 
                and not moving and not isCastingSpell(spell.vampiricTouch) and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") 
            then
                if cast.vampiricTouch() then
                    return
                end
            end

            -- SWP Refresh
            if (debuff.shadowWordPain.remain("target") < 4.8 * gcd) or (not debuff.shadowWordPain.exists("target")) and not buff.void.exists() 
                and not moving and not isCastingSpell(spell.vampiricTouch) and debuff.shadowWordPain.count() <= getOptionValue("SWP Max Targets") 
            then
                if cast.shadowWordPain() then
                    return
                end
            end

            -- Misery + VT APPLY
            if talent.misery and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if not debuff.vampiricTouch.exists(thisUnit)  then
                        if cast.vampiricTouch(thisUnit, "aoe") then
                            return
                        end
                    end
                end
            end
        
            -- Misery + VT Refresh
            if talent.misery and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if debuff.vampiricTouch.refresh(thisUnit)  then
                        if cast.vampiricTouch(thisUnit, "aoe") then
                            return
                        end
                    end
                end
            end

            -- No Misery + VT APPLY
            if not talent.misery and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if not debuff.vampiricTouch.exists(thisUnit)  then
                        if cast.vampiricTouch(thisUnit, "aoe") then
                            return
                        end
                    end
                end
            end

            -- NoMisery + VT Refresh
            if not talent.misery and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if debuff.vampiricTouch.refresh(thisUnit)  then
                        if cast.vampiricTouch(thisUnit, "aoe") then
                            return
                        end
                    end
                end
            end

            -- AoE + SWP APPLY
            if not talent.misery and debuff.shadowWordPain.count() <= getOptionValue("SWP Max Targets") and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if not debuff.shadowWordPain.exists(thisUnit)  then
                        if cast.shadowWordPain(thisUnit, "aoe") then
                            return
                        end
                    end
                end
            end

            -- AOE + SWP Refresh
            if not talent.misery and debuff.shadowWordPain.count() <= getOptionValue("SWP Max Targets") and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if debuff.shadowWordPain.refresh(thisUnit)  then
                        if cast.shadowWordPain(thisUnit, "aoe") then
                            return
                        end
                    end
                end
            end

            -- Shadow Crash
            if isChecked("Shadow Crash") and talent.shadowCrash and not buff.void.exists() then
                if cast.shadowCrash("best",nil,1,10) then
                    return
                end
            end

            -- Mindbender
            if useCDs() and not buff.void.exists() then 
                if talent.mindbender then 
                    if cast.mindbender() then 
                        return
                    end
                else
                    if cast.shadowfiend() then
                        return
                    end
                end 
            end

            -- Berserking / Troll
            if br.player.race == "Troll" and cd.racial.remain() == 0 and buff.voidForm.stack() >= 10 and drainStacks <= 20 and not buff.void.exists() then
                if cast.racial() then
                    return
                end
            end

            -- Void Bolt 2
            if cd.voidBolt.remain() == 0 or buff.void.exists() then
                if cast.voidBolt(units.dyn40) then
                    return
                end
            end

            -- -- SWD
            -- if ((mode.rotation == 1 and #enemies.yards40 <= 4 or mode.rotation == 3) and insanityDrain * gcd > power and (power - (insanityDrain * gcd))) < 100 and not buff.void.exists() and talent.shadowWordDeath then
            --     for i = 1, #enemies.yards40 do
            --         local thisUnit = enemies.yards40[i]
            --         if getHP(thisUnit) < 20 then
            --            if cast.shadowWordDeath(thisUnit) then
            --                return
            --            end
            --         end
            --     end
            -- end

            -- W8 for Void Bolt
            if cd.voidBolt.remain() < gcd * 0.28 and charges.shadowWordVoid.count() < 2 then
                return true
            end

            -- Mind Blast
            if ((mode.rotation == 1 and #enemies.yards40 <= 4) or mode.rotation == 3) and not buff.void.exists() and cast.last.voidEruption() and not moving then
                if cast.mindBlast() then
                    return
                end
            end

            -- More SVP pls.
            if charges.shadowWordVoid.count() > 0 and cd.voidBolt.remain() == 1 and talent.shadowWordVoid then
                if cast.shadowWordVoid then
                    return
                end
            end


            -- W8 for Void Bolt
            if ((mode.rotation == 1 and (#enemies.yards40 < 4)) or mode.rotation == 3) and cd.mindBlast.remain() < gcd * 0.28 and not moving then
                return true
            end

            -- SWD 2 
            if ((mode.rotation == 1 and (#enemies.yards40 <= 4 or (#enemies <= 2))) or mode.rotation == 3) and charges.shadowWordDeath.count() == 2 and not buff.void.exists() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if getHP(thisUnit) < 20 then
                        if cast.shadowWordDeath(thisUnit) then
                            return 
                        end
                    end
                end
            end

            -- Shadowfiend
            if useCDs() and not buff.void.exists() then
                if not talent.mindbender  then
                    if cast.shadowfiend() then 
                        return 
                    end
                end
            end

            -- Shadow Word - Void
            if talent.shadowWordVoid and not buff.void.exists() and charges.shadowWordVoid.count() > 0 then
                if cast.shadowWordVoid() then 
                    return 
                end
            end

            -- Shadow Word - Pain
            if talent.misery and moving and debuff.shadowWordPain.count() < getOptionValue("SWP Max Targets") and not buff.void.exists() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.shadowWordPain.remain(thisUnit) < gcd then
                        if cast.shadowWordPain(thisUnit,"aoe") then 
                            return 
                        end
                    end
                end
            end

            -- Vampiric Touch
            if talent.misery and debuff.vampiricTouch.count() < getOptionValue("VT Max Targets") and not buff.void.exists() and not moving and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (getHP(thisUnit) > vtHPLimit or IsInInstance()) and (debuff.vampiricTouch.remain(thisUnit) < 3 * gcd or debuff.shadowWordPain.remain(thisUnit) < 3 * gcd) and ttd(thisUnit) > 5 * gcd then
                        if cast.vampiricTouch(thisUnit,"aoe") then 
                            return 
                        end
                    end
                end
            end

            -- Shadow Word - Pain
            if not talent.misery and not debuff.shadowWordPain.exists()
                and (((mode.rotation == 1 and #enemies.yards40 < 5) or mode.rotation == 3) or talent.auspiciousSpirits or talent.shadowyInsight)
                and not buff.void.exists()
            then
                if cast.shadowWordPain() then 
                    return 
                end
            end

            -- Vampiric Touch
            if not talent.misery and not debuff.vampiricTouch.exists() and not isCastingSpell(spell.vampiricTouch) and not buff.void.exists() and not moving
                and (((mode.rotation == 1 and #enemies.yards40 < 4) or mode.rotation == 3) or talent.sanlayn 
                or (talent.auspiciousSpirits))
            then
                if cast.vampiricTouch() then 
                    return 
                end
            end

            -- VT Tick
            if #enemies.yards40 > 1 and not talent.misery and debuff.vampiricTouch.count() <= getOptionValue("VT Max Targets") and not buff.void.exists() and not moving and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (getHP(thisUnit) > vtHPLimit or IsInInstance()) and not debuff.vampiricTouch.exists(thisUnit) and (85.2 * (1 + 0.02 * buff.voidForm.stack()) * (1 + 0.2 + GetMastery() / 16000) * (1 + 0.2 * sanlayn) * 0.5 * ttd(thisUnit) / (gcd * (138 + 80 * (#enemies.yards40 - 1)))) > 1 then
                        if cast.vampiricTouch(thisUnit,"aoe") then 
                            return 
                        end
                    end
                end
            end

            -- Shadow Word - Pain
            if #enemies.yards40 > 1 and not talent.misery and debuff.shadowWordPain.count() <= getOptionValue("SWP Max Targets") and not buff.void.exists() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not debuff.shadowWordPain.exists(thisUnit) and (47.12 * (1 + 0.02 * buff.voidForm.stack()) * (1 + 0.2 + GetMastery() / 16000) * 0.75 * ttd(thisUnit) / (gcd * (138 + 80 * (#enemies.yards40 - 1)))) > 1 then
                        if cast.shadowWordPain(thisUnit,"aoe") then 
                            return 
                        end
                    end
                end
            end

            -- Mind Sear VF
            if ((mode.rotation == 1 and #enemies.yards10t >= getOptionValue("Mind Sear Targets")) or mode.rotation == 2) and charges.shadowWordVoid.count() < 1 and not buff.void.exists() and not moving and not isCastingSpell(spell.mindSear) then
                if cast.mindSear() then
                    return
                end
            end

            -- Full Cast Mind Sear VF
      --      if not buff.void.exists() and not moving and #enemies.yards10t >= getOptionValue("Full Cast Mind Sear") then
       --         for i = 1, #enemies.yards40 do
          --      local thisUnit = enemies.yards40[i]
          --          if debuff.shadowWordPain.exists(thisUnit) then
         --               if cast.mindSearAoE() then
         --                   return
         --               end
         --           end
         --       end
         --   end


            -- Mind Sear + Thought Harvester Buff
            if buff.thoughtsHarvester.exists() and charges.shadowWordVoid.count() < 2 and not buff.void.exists() and not moving then
                if cast.mindSear() then
                    sear = true
                    searCastTime = GetTime();
                   return
                end
            end

            -- Mind Flay 
            if not buff.thoughtsHarvester.exists() and charges.shadowWordVoid.count() < 1 and not buff.void.exists() and not moving and not isCastingSpell(spell.mindFlay) and not isCastingSpell(spell.mindSear) then
                if cast.mindFlay() then
                    return
                end
            end

        end 
        -- Void Form End
        -----------------------------------------       
        -- Begin Profile
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or IsMounted() or IsFlying() or pause(true) or mode.rotation==4 or buff.void.exists() then
            return true
        else
            -----------------
            --- Rotations ---
            -----------------
            if actionList_Extra() then
                return 
            end

            if actionList_Defensive() then
                return
            end

            if actionList_Interrupts() then 
                return 
            end
            ---------------------------------
            --- Out Of Combat - Rotations ---
            ---------------------------------
            if actionList_PreCombat() then 
                return 
            end
            -----------------------------
            --- In Combat - Rotations --- 
            -----------------------------
            if inCombat and not IsMounted() and not isCastingSpell(spell.voidTorrent) and sear == false then
                -- Action List - Cooldowns
                actionList_Cooldowns()
                -- Action List - Check
                -- call_action_list,name=check,if=talent.surrender_to_madness.enabled&!buff.surrender_to_madness.up
                if not buff.surrenderToMadness.exists() then
                    if actionList_Check() then return end
                end
                -- Action List - Void Form
                -- run_action_list,name=vf,if=buff.voidform.up
                if buff.voidForm.exists() then
                    if actionList_VoidForm() then return end
                end
                -- Action List - Main
                -- run_action_list,name=main
                if not buff.voidForm.exists() then
                    if actionList_Main() then return end
                end
            end -- End Combat Rotation
        end --End Rotation Logic
    end -- End Timer
end -- End Run Rotation
local id = 0 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})