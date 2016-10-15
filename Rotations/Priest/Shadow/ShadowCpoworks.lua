if select(2, UnitClass("player")) == "PRIEST" then
	local rotationName = "Cpoworks"

---------------
--- Toggles ---
---------------
	local function createToggles()
        -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.mindFlay },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.mindSear },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.mindFlay },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.shadowMend}
        };
        CreateButton("Rotation",1,0)
        -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.powerInfusion },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.powerInfusion },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.powerInfusion }
        };
       	CreateButton("Cooldown",2,0)
        -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.dispersion },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.dispersion }
        };
        CreateButton("Defensive",3,0)
        -- Void Form Button
        VoidEruptionModes = {
            [1] = { mode = "On", value = 1 , overlay = "Void Eruption Enabled", tip = "Void Eruption will be used.", highlight = 1, icon = bb.player.spell.voidEruption },
            [2] = { mode = "Off", value = 2 , overlay = "Void Eruption Disabled", tip = "Void Eruption will not be used.", highlight = 0, icon = bb.player.spell.voidEruption }
        };
        CreateButton("VoidEruption",4,0)
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
                -- SWP Max Targets
                bb.ui:createSpinner(section, "SWP Max Targets",  3,  1,  10,  1)
                -- VT Max Targets
                bb.ui:createSpinner(section, "VT Max Targets",  3,  1,  10,  1)
            bb.ui:checkSectionState(section)
            -- Cooldown Options
            section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
                -- Int Pot
                bb.ui:createCheckbox(section,"Int Pot")
                -- Flask / Crystal
                bb.ui:createCheckbox(section,"Flask / Crystal")
                -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
                -- Touch of the Void
                if hasEquiped(128318) then
                    bb.ui:createCheckbox(section,"Touch of the Void")
                end
                -- Shadowfiend
                bb.ui:createCheckbox(section,"Shadowfiend / Mind Bender")
                -- Power Infusion
                bb.ui:createCheckbox(section,"Power Infusion")
            bb.ui:checkSectionState(section)
            -- Defensive Options
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
                -- Healthstone
                bb.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Gift of The Naaru
                if bb.player.race == "Draenei" then
                    bb.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                end
                -- Power Word: Shield
                bb.ui:createSpinner(section, "Power Word: Shield",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Dispel Magic
                bb.ui:createCheckbox(section,"Dispel Magic")
            bb.ui:checkSectionState(section)
            -- Toggle Key Options
            section = bb.ui:createSection(bb.ui.window.profile, "Toggle Keys")
                -- Single/Multi Toggle
                bb.ui:createDropdown(section, "Rotation Mode", bb.dropOptions.Toggle,  4)
                -- Cooldown Key Toggle
                bb.ui:createDropdown(section, "Cooldown Mode", bb.dropOptions.Toggle,  3)
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
        if bb.timer:useTimer("debugShadow", 0.1) then
            --print("Running: "..rotationName)

    ---------------
    --- Toggles ---
    ---------------
            UpdateToggle("Rotation",0.25)
            UpdateToggle("Cooldown",0.25)
            UpdateToggle("Defensive",0.25)
            UpdateToggle("VoidEruption",0.25)
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
            local thp                                           = getHP(bb.player.units.dyn40)
            local ttd                                           = getTTD
            local ttm                                           = bb.player.timeToMax
            local units                                         = bb.player.units
            
            local SWPmaxTargets                                 = getOptionValue("SWP Max Targets")
            local VTmaxTargets                                  = getOptionValue("VT Max Targets")

            if useMindBlast == nil then useMindBlast = false end
            if leftCombat == nil then leftCombat = GetTime() end
            if profileStop == nil then profileStop = false end
            if IsHackEnabled("NoKnockback") ~= nil then SetHackEnabled("NoKnockback", false) end



    --------------------
    --- Action Lists ---
    --------------------
            -- Action list - Extras
            function actionList_Extra()
                -- Dispel Magic
                -- if isChecked("Dispel Magic") and canDispel("target",bb.player.spell.dispelMagic) and not isBoss() and ObjectExists("target") then
                --     if cast.dispelMagic() then return end
                -- end
            end -- End Action List - Extra
            -- Action List - Defensive
            function actionList_Defensive()
                if useDefensive() and getHP("player")>0 then     
                    -- Gift of the Naaru
                    if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and bb.player.race=="Draenei" then
                        if castSpell("player",racial,false,false,false) then return end
                    end
                    -- Power Word: Shield
                    if isChecked("Power Word: Shield") and php <= getOptionValue("Power Word: Shield") and not buff.powerWordShield then
                        if cast.powerWordShield("player") then return end
                    end
                end -- End Defensive Check
            end -- End Action List - Defensive
            -- Action List - Interrupts
            function actionList_Interrupts()

            end -- End Action List - Interrupts
            -- Action List - Cooldowns
            function actionList_Cooldowns()
                if getDistance(dyn5)<5 then
                    -- Legendary Ring
                    -- use_item,name=maalus_the_blood_drinker
                    if useCDs() and isChecked("Legendary Ring") then
                        if hasEquiped(124636) and canUse(124636) then
                            useItem(124636)
                            return true
                        end
                    end
                    -- Racials
                    -- blood_fury
                    -- arcane_torrent
                    -- berserking
                    if useCDs() and (bb.player.race == "Orc" or bb.player.race == "Troll" or bb.player.race == "Blood Elf") then
                        if bb.player.castRacial() then return end
                    end
                    -- Touch of the Void
                    if useCDs() and isChecked("Touch of the Void") and getDistance(bb.player.units.dyn5)<5 then
                        if hasEquiped(128318) then
                            if GetItemCooldown(128318)==0 then
                                useItem(128318)
                            end
                        end
                    end
                    -- Trinkets
                    if useCDs() and isChecked("Trinkets") then
                        if canUse(13) then
                            useItem(13)
                        end
                        if canUse(14) then
                            useItem(14)
                        end
                    end     
                end
            end -- End Action List - Cooldowns
            -- Action List - Pre-Combat
            function actionList_PreCombat()
            
            end  -- End Action List - Pre-Combat
            -- Action List - Single
            function actionList_Auto()
                --Surrender to Madness
                --MindBender
                if isChecked("Shadowfiend / Mind Bender") and talent.mindBender then
                    if cast.mindBender() then return end
                end
                -- Void Eruption
                if mode.voidEruption == 1 and ((talent.legacyOfTheVoid and power > 70) or power > 100) then
                    if cast.voidEruption() then return end
                end
                -- Shadow Crash
                if cast.shadowCrash() then return end
                
                -- Shadow Word Death
                -- if ChargesRemaining(ShadowWordDeath) = SpellCharges(ShadowWordDeath)
                if charges.shadowWordDeath == charges.max.shadowWordDeath then
                    if cast.shadowWordDeath() then return end
                end
                -- Mind Blast
                if cast.mindBlast() then return end
                -- Shadow Word: Pain
                if getDebuffRemain(units.dyn40,spell.shadowWordPain,"player") <= 4 then
                    if cast.shadowWordPain(units.dyn40) then return end 
                end
                if getDebuffRemain(units.dyn40,spell.shadowWordPain,"player") > 4 
                and debuff.count.shadowWordPain < SWPmaxTargets 
                and (debuff.count.vampiricTouch >= 1 or isMoving("player")) then
                    for i=1,#enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if getDebuffRemain(thisUnit,spell.shadowWordPain,"player") <= 4 then
                            if cast.shadowWordPain(thisUnit) then return end 
                        end
                    end
                end              
                -- Vampiric Touch
                if getDebuffRemain(units.dyn40,spell.vampiricTouch,"player") <= 6 then
                    if cast.vampiricTouch(units.dyn40) then return end 
                end
                if getDebuffRemain(units.dyn40,spell.vampiricTouch,"player") > 6
                and debuff.count.vampiricTouch < VTmaxTargets 
                and debuff.count.shadowWordPain >= 1 then
                    for i=1,#enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if getDebuffRemain(thisUnit,spell.vampiricTouch,"player") <= 6 then
                            if cast.vampiricTouch(thisUnit) then return end 
                        end
                    end
                end 
                -- Shadow Word: Void
                if cast.shadowWordVoid() then return end
                -- Mind Shear
                -- Mind Spike / Mind Flay
                if talent.mindSpike then
                    if cast.mindSpike() then return end
                else
                    if cast.mindFlay() then return end
                end
            end -- End Action List - Single

        -- Action List - VoidForm
            function actionList_VoidForm()
                --NoMindBlastSwitch
                if isCastingSpell(spell.mindFlay) or lastSpellCast == spell.mindSpike then
                    useMindBlast = false
                else
                    useMindBlast = true
                end
                --Cooldowns
                if actionList_Cooldowns() then return end
                --Void Torrent
                if getDebuffRemain(units.dyn40,spell.vampiricTouch,"player") >= 6 and getDebuffRemain(units.dyn40,spell.shadowWordPain,"player") >= 4 then
                    if cast.voidTorrent() then return end
                end
                --VoidBolt
                if cast.voidBolt() then return end 
                --Dispersion
                -- if HasBuff(SurrenderedSoul) and Abs(AlternatePowerRegen * GlobalCooldownSec) > AlternatePower and not CanUse(ShadowWordDeath)
                if buff.surrenderedSoul and (powgen * gcd) > power and not cast.shadowWordDeath(units.dyn40,true) then
                end
                --MindBender
                if isChecked("Shadowfiend / Mind Bender") and talent.mindBender then
                    if cast.mindBender() then return end  
                end
                --Power Infusion
                -- if (BuffStack(Voidform) >= 10 and not HasBuff(SurrenderedSoul)) or BuffStack(Voidform) > 60
                if isChecked("Power Infusion") and (buff.stack.voidForm >= 10 and not buff.surrenderedSoul) or buff.stack.voidForm >= 60 then
                    if cast.powerInfusion() then return end 
                end
                --Shadow Crash
                if talent.shadowCrash then
                    if cast.shadowCrash() then return end
                end
                --SWD
                -- if not HasBuff(SurrenderedSoul) and ((HasTalent(ReaperOfSouls) and AlternatePowerToMax >= 30) or not HasTalent(ReaperOfSouls))
                if not buff.surrenderedSoul and (talent.reaperOfSouls and powerDeficit >= 30) or not talent.reaperOfSouls then
                    if cast.shadowWordDeath()then return end
                end
                --SWD
                --if HasBuff(SurrenderedSoul) and ((AlternatePowerToMax >= 75 and HasTalent(ReaperOfSouls)) or (AlternatePowerToMax >= 25 and not HasTalent(ReaperOfSouls)))
                if buff.surrenderedSoul and ((powerDeficit >= 75 and talent.reaperOfSouls) or (powerDeficit >= 25 and not talent.reaperOfSouls)) then
                    if cast.shadowWordDeath()then return end
                end
                -- Mind Blast
                -- if IsSwitchOff(NoMindBlast)
                if useMindBlast then
                    if cast.mindBlast() then return end
                end
                -- SWD
                -- if ChargesRemaining(ShadowWordDeath) = SpellCharges(ShadowWordDeath)
                if charges.shadowWordDeath == charges.max.shadowWordDeath then
                    if cast.shadowWordDeath() then return end
                end
                -- Shadow Word: Void
                -- if (AlternatePowerToMax >= 35 and not HasBuff(SurrenderedSoul)) or (HasBuff(SurrenderedSoul) and AlternatePowerToMax >= 50)
                if (powerDeficit >= 35 and not buff.surrenderedSoul) or (buff.surrenderedSoul and powerDeficit >= 50) then
                    if cast.shadowWordVoid() then return end
                end
                -- Shadowfiend
                if isChecked("Shadowfiend / Mind Bender") and buff.stack.voidForm > 15 then
                    if cast.shadowfiend() then return end
                end
                -- Shadow Word: Pain
                if getDebuffRemain(units.dyn40,spell.shadowWordPain,"player") <= 4 then
                    if cast.shadowWordPain(units.dyn40) then return end 
                end              
                -- Vampiric Touch
                 if getDebuffRemain(units.dyn40,spell.vampiricTouch,"player") <= 6 then
                    if cast.vampiricTouch(units.dyn40) then return end 
                end 
                -- Mind Sear
                -- Mind Spike / Mind Flay
                if talent.mindSpike then
                    if cast.mindSpike() then return end
                else
                    if cast.mindFlay() then return end
                end
            end -- End Action List - VoidForm
    -----------------
    --- Rotations ---
    -----------------
            if actionList_Extra() then return end
            if actionList_Defensive() then return end
    ---------------------------------
    --- Out Of Combat - Rotations ---
    ---------------------------------
            if not inCombat and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                if actionList_PreCombat() then return end
            end
    -----------------------------
    --- In Combat - Rotations --- 
    -----------------------------
            if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 and not isCastingSpell(spell.voidTorrent) then

                if buff.voidForm then
                    if actionList_VoidForm() then return end
                else
                    if actionList_Auto() then return end
                end     
            end -- End Combat Rotation
        end -- End Timer
    end -- Run Rotation

    tinsert(cShadow.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check