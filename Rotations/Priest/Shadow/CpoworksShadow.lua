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
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.voidEruption },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.voidEruption },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.voidEruption }
        };
       	CreateButton("Cooldown",2,0)
        -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.shamanisticRage },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.shamanisticRage }
        };
        CreateButton("Defensive",3,0)
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
                -- Legendary Ring
                bb.ui:createCheckbox(section, "Legendary Ring", "Enable or Disable usage of Legendary Ring.")
                -- Flask / Crystal
                bb.ui:createCheckbox(section,"Flask / Crystal")
                -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
                -- Touch of the Void
                bb.ui:createCheckbox(section,"Touch of the Void")
                -- Void Eruption
                bb.ui:createCheckbox(section,"Void Eruption")
                -- Shadowfiend
                bb.ui:createCheckbox(section,"Shadowfiend")
            bb.ui:checkSectionState(section)
            -- Defensive Options
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
                -- Healthstone
                bb.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Heirloom Neck
                bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Gift of The Naaru
                if bb.player.race == "Draenei" then
                    bb.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                end
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

            if leftCombat == nil then leftCombat = GetTime() end
            if profileStop == nil then profileStop = false end
            if IsHackEnabled("NoKnockback") ~= nil then SetHackEnabled("NoKnockback", false) end



    --------------------
    --- Action Lists ---
    --------------------
            -- Action list - Extras
            function actionList_Extra()
                -- Dispel Magic
                if isChecked("Dispel Magic") and canDispel("target",bb.player.spell.dispelMagic) and not isBoss() and ObjectExists("target") then
                    if cast.dispelMagic() then return end
                end
            end -- End Action List - Extra
            -- Action List - Defensive
            function actionList_Defensive()
                if useDefensive() and getHP("player")>0 then     
                    -- Gift of the Naaru
                    if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and bb.player.race=="Draenei" then
                        if castSpell("player",racial,false,false,false) then return end
                    end
                    -- Heirloom Neck
                    if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                        if hasEquiped(122668) then
                            if canUse(122668) then
                                useItem(122668)
                            end
                        end
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
                if talent.mindBender then
                    if cast.mindBender() then return end
                end
                -- Void Eruption
                if useCDs()            
                and ((talent.legacyOfTheVoid and power > 70) or power > 100) then
                    if cast.voidEruption() then return end
                end
                -- Shadow Crash
                if talent.shadowCrash then
                    if cast.shadowCrash() then return end
                end
                -- Shadow Word Death
                if thp < 20
                or (talent.reaperOfSouls and thp < 35) then
                    if cast.shadowWordDeath()then return end
                end
                -- Mind Blast
                if cast.mindBlast() then return end
                -- Shadow Word: Pain
                if getDebuffRemain(units.dyn40,spell.shadowWordPain,"player") <= 14*0.3 then
                    if cast.shadowWordPain(units.dyn40) then return end 
                elseif debuff.count.shadowWordPain < SWPmaxTargets 
                and debuff.count.vampiricTouch >= 1 then
                    for i=1,#bb.enemy do
                        local thisUnit = bb.enemy[i].unit
                        local hp = bb.enemy[i].hpabs
                        local ttd = bb.enemy[i].ttd
                        local distance = bb.enemy[i].distance
                        if getDebuffRemain(thisUnit,spell.shadowWordPain,"player") <= 14*0.3 then
                            if distance < 40 then
                                if cast.shadowWordPain(bb.enemy[i]) then return end 
                            end
                        end
                    end
                end              
                -- Vampiric Touch
                if getDebuffRemain(units.dyn40,spell.vampiricTouch,"player") <= 18*0.3 then
                    if cast.vampiricTouch(units.dyn40) then return end 
                elseif debuff.count.vampiricTouch < VTmaxTargets 
                and debuff.count.shadowWordPain >= 1 then
                    for i=1,#bb.enemy do
                        local thisUnit = bb.enemy[i].unit
                        local hp = bb.enemy[i].hpabs
                        local ttd = bb.enemy[i].ttd
                        local distance = bb.enemy[i].distance
                        if getDebuffRemain(thisUnit,spell.vampiricTouch,"player") <= 18*0.3 then
                            if distance < 40 then
                                if cast.vampiricTouch(bb.enemy[i]) then return end 
                            end
                        end
                    end
                end 
                -- Shadow Word: Void
                if talent.shadowWordVoid and charges.shadowWordVoid > 0 then
                    if cast.shadowWordVoid()then return end
                end
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
                --Cooldowns
                if actionList_Cooldowns() then return end
                --Void Torrent
                -- if not CanUse(VoidBolt) and not CanUse(MindBlast) and not CanUse(ShadowWordDeath) and not HasBuff(PowerInfusion) and not HasBuff(Berserking)
                if cd.voidBolt > 0 and cd.mindBlast > 0 and charges.shadowWordDeath == 0 then
                    if cast.voidTorrent() then return end
                end
                --MindBender / Mindfiend
                if talent.mindBender then
                    if cast.mindBender() then return end
                else
                    if cast.mindfiend() then return end
                end
                --Dispersion
                --Power Infusion
                --Shadow Crash
                if talent.shadowCrash then
                    if cast.shadowCrash() then return end
                end
                --VoidBolt
                if cast.voidBolt() then return end  
                --SWD
                if thp < 20 or (talent.reaperOfSouls and thp < 35) then
                    if cast.shadowWordDeath()then return end
                end
                -- Shadow Word: Void
                if talent.shadowWordVoid and charges.shadowWordVoid > 0 then
                    if cast.shadowWordVoid()then return end
                end
                -- Mind Blast
                if cast.mindBlast() then return end
                -- Shadow Word: Pain
                if getDebuffRemain(units.dyn40,spell.shadowWordPain,"player") <= 14*0.1 then
                    if cast.shadowWordPain(units.dyn40) then return end 
                end              
                -- Vampiric Touch
                if getDebuffRemain(units.dyn40,spell.vampiricTouch,"player") <= 18*0.1 then
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
            if inCombat then
                -- Casting and GCD check
                if castingUnit() 
                and not UnitChannelInfo("player") == GetSpellInfo(spell.mindFlay) then
                    return
                end

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