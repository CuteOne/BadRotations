local rotationName = "Cpoworks"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.mindFlay },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.mindFlay },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mindFlay },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.shadowMend}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.mindBlast },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.mindBlast },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.mindBlast }
    };
   	CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dispersion },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dispersion }
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
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- Mouseover Dotting
            br.ui:createCheckbox(section,"Mouseover Dotting")
            -- SWP Max Targets
            br.ui:createSpinner(section, "SWP Max Targets",  3,  1,  10,  1)
            -- VT Max Targets
            br.ui:createSpinner(section, "VT Max Targets",  3,  1,  10,  1)
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Int Pot
            br.ui:createCheckbox(section,"Int Pot")
            -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Touch of the Void
            if hasEquiped(128318) then
                br.ui:createCheckbox(section,"Touch of the Void")
            end
            -- Shadowfiend
            br.ui:createCheckbox(section,"Shadowfiend / Mind Bender")
            -- Power Infusion
            br.ui:createCheckbox(section,"Power Infusion")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
            -- Power Word: Shield
            br.ui:createSpinner(section, "Power Word: Shield",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Dispel Magic
            br.ui:createCheckbox(section,"Dispel Magic")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugShadow", 0.1) then
        --Print("Running: "..rotationName)

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
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local canFlask                                      = canUse(br.player.flask.wod.agilityBig)
        local cast                                          = br.player.cast
        local castable                                      = br.player.cast.debug
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = ObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local moveIn                                        = 999
        -- local multidot                                      = (useCleave() or br.player.mode.rotation ~= 3)
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.amount.insanity, br.player.power.insanity.max, br.player.power.regen, br.player.power.insanity.deficit
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local recharge                                      = br.player.recharge
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local thp                                           = getHP(br.player.units.dyn40)
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.ttm
        local units                                         = br.player.units
        
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
            -- if isChecked("Dispel Magic") and canDispel("target",br.player.spell.dispelMagic) and not isBoss() and ObjectExists("target") then
            --     if cast.dispelMagic() then return end
            -- end
        end -- End Action List - Extra
        -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() and getHP("player")>0 then     
                -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race=="Draenei" then
                    if castSpell("player",racial,false,false,false) then return end
                end
                -- Power Word: Shield
                if isChecked("Power Word: Shield") and php <= getOptionValue("Power Word: Shield") and not buff.powerWordShield.exists then
                    if cast.powerWordShield("player") then return end
                end
            end -- End Defensive Check
        end -- End Action List - Defensive
        -- Action List - Interrupts
        function actionList_Interrupts()

        end -- End Action List - Interrupts
        -- Action List - Cooldowns
        function actionList_Cooldowns()
            if useCDs() then
                -- Racials
                -- blood_fury
                -- arcane_torrent
                -- berserking
                if (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "Blood Elf") then
                    if br.player.castRacial() then return end
                end
                -- Touch of the Void
                if isChecked("Touch of the Void") and getDistance(br.player.units.dyn5)<5 then
                    if hasEquiped(128318) then
                        if GetItemCooldown(128318)==0 then
                            useItem(128318)
                        end
                    end
                end
                -- Trinkets
                if isChecked("Trinkets") then
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
            if not buff.shadowform.exists then
                cast.shadowform()
            end
            -- Power Word: Shield Body and Soul
            if talent.bodyAndSoul and isMoving("player") and not IsMounted() then
                if cast.powerWordShield("player") then return end
            end                
        end  -- End Action List - Pre-Combat
        -- Action List - Single
        function actionList_Auto()
            --Surrender to Madness
            --Mouseover Dotting
            if isChecked("Mouseover Dotting") and hasMouse and isValidTarget("mouseover") then
                if getDebuffRemain("mouseover",spell.shadowWordPain,"player") <= 1 then
                    if cast.shadowWordPain("mouseover") then return end 
                end
            end
            --MindBender
            if isChecked("Shadowfiend / Mind Bender") and talent.mindBender then
                if cast.mindBender() then return end
            end
            -- Void Eruption
            if ((talent.legacyOfTheVoid and power > 65) or power > 99) then
                if cast.voidEruption("target") then return end
            end
            -- Shadow Crash
            -- castGroundAtBestLocation(spellID, radius, minUnits, maxRange, minRange, spellType)
            if talent.shadowCrash then
                if cast.shadowCrash("best",nil,1,8) then return end
            end
            --if cast.shadowCrash("best",false,1,8) then return end
            
            -- Shadow Word Death
            -- if ChargesRemaining(ShadowWordDeath) = SpellCharges(ShadowWordDeath)
            if charges.shadowWordDeath == charges.max.shadowWordDeath and getHP(units.dyn40) < 20 then
                if cast.shadowWordDeath() then return end
            end
            -- Mind Blast
            if cast.mindBlast() then return end
            -- Shadow Word: Pain  
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local swp = debuff.shadowWordPain[thisUnit]
                if swp ~= nil then
                    if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                        if ttd(thisUnit) > swp.duration and (not swp or swp.refresh) then
                            if cast.shadowWordPain(thisUnit) then return end
                        end
                    end
                end
            end            
            -- Vampiric Touch
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local vt = debuff.vampiricTouch[thisUnit]
                if vt ~= nil then
                    if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                        if ttd(thisUnit) > vt.duration and (not vt or vt.refresh) then
                            if cast.vampiricTouch(thisUnit) then return end
                        end
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
            if ttd(units.dyn40) > 5 and getDebuffRemain(units.dyn40,spell.vampiricTouch,"player") >= 6 and getDebuffRemain(units.dyn40,spell.shadowWordPain,"player") >= 4 then
                if cast.voidTorrent() then return end
            end
            --VoidBolt
            if cast.voidBolt("target") then return end 
            --Dispersion
            -- if HasBuff(SurrenderedSoul) and Abs(AlternatePowerRegen * GlobalCooldownSec) > AlternatePower and not CanUse(ShadowWordDeath)
            if buff.surrenderedSoul.exists and (powgen * gcd) > power and not cast.shadowWordDeath(units.dyn40,true) then
                if cast.dispersion() then return end
            end
            --MindBender
            if useCDs() and isChecked("Shadowfiend / Mind Bender") and talent.mindBender then
                if cast.mindBender() then return end  
            end
            --Power Infusion
            -- if (BuffStack(Voidform) >= 10 and not HasBuff(SurrenderedSoul)) or BuffStack(Voidform) > 60
            if useCDs() and isChecked("Power Infusion") and (buff.voidForm.stack >= 10 and not buff.surrenderedSoul.exists) or buff.voidForm.stack >= 60 then
                if cast.powerInfusion() then return end 
            end
            --Shadow Crash
            if talent.shadowCrash then
                if cast.shadowCrash("best",nil,1,8) then return end
            end
            --SWD
            -- if not HasBuff(SurrenderedSoul) and ((HasTalent(ReaperOfSouls) and AlternatePowerToMax >= 30) or not HasTalent(ReaperOfSouls))
            if not buff.surrenderedSoul.exists and (talent.reaperOfSouls and powerDeficit >= 30) or not talent.reaperOfSouls then
                if cast.shadowWordDeath()then return end
            end
            --SWD
            --if HasBuff(SurrenderedSoul) and ((AlternatePowerToMax >= 75 and HasTalent(ReaperOfSouls)) or (AlternatePowerToMax >= 25 and not HasTalent(ReaperOfSouls)))
            if buff.surrenderedSoul.exists and ((powerDeficit >= 75 and talent.reaperOfSouls) or (powerDeficit >= 25 and not talent.reaperOfSouls)) then
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
            if (powerDeficit >= 35 and not buff.surrenderedSoul.exists) or (buff.surrenderedSoul.exists and powerDeficit >= 50) then
                if cast.shadowWordVoid() then return end
            end
            -- Shadowfiend
            if useCDs() and isChecked("Shadowfiend / Mind Bender") and buff.voidForm.stack > 15 then
                if cast.shadowfiend() then return end
            end
            -- Shadow Word: Pain
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local swp = debuff.shadowWordPain[thisUnit]
                if swp ~= nil then
                    if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                        if ttd(thisUnit) > swp.duration and (not swp or swp.refresh) then
                            if cast.shadowWordPain(thisUnit) then return end
                        end
                    end
                end
            end             
            -- Vampiric Touch
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local vt = debuff.vampiricTouch[thisUnit]
                if vt ~= nil then
                    if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                        if ttd(thisUnit) > vt.duration and (not vt or vt.refresh) then
                            if cast.vampiricTouch(thisUnit) then return end
                        end
                    end
                end
            end
            --  if getDebuffRemain(units.dyn40,spell.vampiricTouch,"player") <= 6 and not isCastingSpell(spell.vampiricTouch) then
            --     if cast.vampiricTouch(units.dyn40) then return end 
            -- end 
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
        if not inCombat then --  and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player")
            if actionList_PreCombat() then return end
        end
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
        if inCombat and not IsMounted() and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 and not isCastingSpell(spell.voidTorrent) then

            if buff.voidForm.exists then
                if actionList_VoidForm() then return end
            else
                if actionList_Auto() then return end
            end     
        end -- End Combat Rotation
    end -- End Timer
end -- Run Rotation

local id = 258
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})