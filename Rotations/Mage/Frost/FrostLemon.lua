local rotationName = "Lemon" -- Change to name of profile listed in options drop down
--------------
--- COLORS ---
--------------
local colorPurple   = "|cffC942FD"
local colorBlue     = "|cff00CCFF"
local colorGreen    = "|cff00FF00"
local colorRed      = "|cffFF0000"
local colorWhite    = "|cffFFFFFF"
local colorGold     = "|cffFFDD11"
local colorLegendary= "|cffff8000"
local colorBlueMage = "|cff68ccef"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.blizzard},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.blizzard},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.frostbolt},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.iceBlock}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.icyVeins},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.icyVeins},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.icyVeins}
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.iceBarrier},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.iceBarrier}
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterspell},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterspell}
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
        br.ui:createCheckbox(section, "Dynamic Targetting")
        br.ui:createDropdownWithout(section, "Opener Mode", {colorWhite.."SimC", colorWhite.."Icy-Veins", colorWhite.."Ray of Frost"}, 1, colorWhite.."Set APL Mode to use.")
        br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  colorWhite.."Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        br.ui:createCheckbox(section, "Opener")
        br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  colorWhite.."Set to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        br.ui:createDropdownWithout(section, "Artifact", {colorWhite.."Everything",colorWhite.."Cooldowns",colorWhite.."Never"}, 1, colorWhite.."When to use Artifact Ability.")
        br.ui:createSpinnerWithout(section, "AOE targets",  3,  1,  100,  1,  "Minimum AOE targets. Min: 1 / Max: 100")
        br.ui:checkSectionState(section)
        ------------------------
        --- ITEM OPTIONS --- -- Define Item Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Items")
        br.ui:createCheckbox(section, "Potion")
        br.ui:createCheckbox(section,"Flask / Crystal")
        br.ui:createDropdownWithout(section, "Trinket 1 Condition", {colorWhite.."On Cooldown",colorWhite.."On Boss Health",colorWhite.."On Self Health"}, 1, colorWhite.."On Cooldown = Use Trinket whenever available, value doesn't matter; On Boss Health = Use Trinket when boss health is below value; On Self Health = Use Trinket when your health is below value;")
        br.ui:createSpinner(section, "Trinket 1",  80,  0,  100,  5,  colorRed.."When to use Trinket 1")
        br.ui:createDropdownWithout(section, "Trinket 2 Condition", {colorWhite.."On Cooldown",colorWhite.."On Boss Health",colorWhite.."On Self Health"}, 1, colorWhite.."On Cooldown = Use Trinket whenever available, value doesn't matter; On Boss Health = Use Trinket when boss health is below value; On Self Health = Use Trinket when your health is below value;")
        br.ui:createSpinner(section, "Trinket 2",  60,  0,  100,  5,  colorRed.."When to use Trinket 2")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
        br.ui:createCheckbox(section, "Use Racial")
        br.ui:createCheckbox(section, "Use Pet Spells")
        br.ui:createCheckbox(section, colorBlueMage.."Rune of Power")
        br.ui:createCheckbox(section, colorBlueMage.."Mirror Image")
        br.ui:createCheckbox(section, colorBlueMage.."Icy Veins")
        br.ui:createCheckbox(section, colorBlueMage.."Ray of Frost")
        br.ui:createCheckbox(section, colorBlueMage.."Frozen Orb")
        br.ui:createCheckbox(section, colorBlueMage.."Comet Storm")
        br.ui:createCheckbox(section, colorBlueMage.."Cone of Cold")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Pot/Stoned",  50,  0,  100,  5,  colorRed.."Health Percent to Cast At")
        br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  colorRed.."Health Percentage to use at.")
        br.ui:createSpinner(section, "Shield-o-tronic",  50,  0,  100,  5,  colorRed.."Health Percent to Cast At")
        br.ui:createSpinner(section, colorBlueMage.."Ice Barrier",  80,  0,  100,  5,  colorRed.."Health Percent to Cast At")
        br.ui:createSpinner(section, colorBlueMage.."Ice Block",  20,  0,  100,  5,  colorRed.."Health Percent to Cast At")
        br.ui:createCheckbox(section, colorBlueMage.."Cold Snap", colorWhite.."Use Cold Snap to reset Ice Block")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Couterspell
        br.ui:createCheckbox(section, "Counterspell")

        -- Interrupt Percentage
        br.ui:createSpinner(section,  "Interrupt at",  0,  0,  100,  1,  colorWhite.."Cast Percentage to use at.")

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
    local artifact                                      = br.player.artifact
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local cd                                            = br.player.cd
    local charges                                       = br.player.charges
    local debuff                                        = br.player.debuff
    local spell                                         = br.player.spell
    local talent                                        = br.player.talent
    local mode                                          = br.player.mode
    local race                                          = br.player.race
    local gcd                                           = br.player.gcd
    local inCombat                                      = br.player.inCombat
    local pullTimer                                     = PullTimerRemain() --br.DBM:getPulltimer()
    local inInstance                                    = br.player.instance=="party"
    local inRaid                                        = br.player.instance=="raid"
    local health                                        = br.player.health
    local mode                                          = br.player.mode
    local debug                                         = false
    local lastCast                                     = lastCast
    local ttd                                           = getTTD
    local enemies                                       = enemies or {}
    local units                                         = units or {}
    local t20_2pc                                       = TierScan("T20") >= 2
    local thp                                           = getHP(br.player.units(5))
    local execute_time                                  = br.player.gcd

    enemies.yards40 = br.player.enemies(40)
    enemies.yards8t = br.player.enemies(8,br.player.units(8,true))

    if isChecked("Dynamic Targetting") then
        units.dyn40 = br.player.units(40)
        ttdUnit = ttd(units.dyn40)
        target = units.dyn40
    else
        ttdUnit = ttd("target")
        target = "target"
    end

    if lastCast == nil then lastCast = 61304 end
    if talent.articGale then blizzardRadius = 9.6 else blizzardRadius = 8 end

    if artifact.icyHand then iceHand= 1 else iceHand = 0 end
    if iv_start == nil then iv_start = 0 end
    if fof_react == nil then fof_react = 0 end
    if t20_2pc then t20pc2 = 1 else t20pc2 = 0 end
    if time_until_fof == nil then time_until_fof = 0 end
    if not inCombat and not GetObjectExists(target) then
        POT   = false
        MI    = false
        EBB   = false
        ROP   = false
        IV    = false
        FLR   = false
        IL    = false
        FRO   = false
        FRB   = false
        GLP   = false
        FB    = false
        WJ    = false
        RF    = false
        opener= false
        
        seq = 0
        lastCast = 61304
    end
    if seq == nil then seq = 0 end
    --------------------
    --- Action Lists ---
    --------------------


    local function actionList_INTERRUPT()
        if useInterrupts() then
            --actions=counterspell,if=target.debuff.casting.react
            if isChecked("Counterspell") and cd.counterspell == 0 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if canInterrupt(thisUnit,getValue("Interrupt at")) then
                        if cast.counterspell(thisUnit) then return true end
                    end
                end
            end
            --actions.cooldowns+=/arcane_torrent
        end
        return false
    end

    local function actionList_DEFENSIVE()
        if useDefensive() then
            -- Pot/Stoned
            if isChecked("Pot/Stoned") and health <= getValue("Pot/Stoned") and inCombat and (hasHealthPot() or hasItem(5512)) then
                if canUse(5512) then
                    useItem(5512)
                elseif canUse(getHealthPot()) then
                    useItem(getHealthPot())
                end
            end

            -- Heirloom Neck
            if isChecked("Heirloom Neck") and health <= getValue("Heirloom Neck") then
                if hasEquiped(122668) then
                    if GetItemCooldown(122668)==0 then
                        useItem(122668)
                    end
                end
            end

            -- Engineering: Shield-o-tronic
            if isChecked("Shield-o-tronic") and health <= getValue("Shield-o-tronic") and inCombat and canUse(118006) then
                useItem(118006)
            end
            

            --Ice Barrier
            if lastCast ~= spell.waterJet and (lastCast ~= spell.flurry and not buff.brainFreeze.exists()) then
                if isChecked(colorBlueMage.."Ice Barrier") and health <= getValue(colorBlueMage.."Ice Barrier") and inCombat and not buff.iceBarrier.exists() and lastCast ~= spell.waterJet then
                    if cast.iceBarrier("player") then return true end
                end
            end

            --Ice Block
            if isChecked(colorBlueMage.."Ice Block") and health <= getValue(colorBlueMage.."Ice Block") and inCombat then
                if isChecked(colorBlueMage.."Cold Snap") and cd.iceBlock > 0 then
                    if cast.coldSnap("player") then return true end
                end
                if cast.iceBlock("player") then return true end
            end
        end
        return false
    end

    local function actionList_OPENER()

        local function actionList_OPENER_SIMC()
            if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") or inCombat then
                --actions.precombat+=/mirror_image
                if not MI then
                    if talent.mirrorImage and cd.mirrorImage and useCDs() and isChecked(colorBlueMage.."Mirror Image") then
                        seq = seq + 1
                        if castOpener("mirrorImage","MI",seq, false) then return true end
                    else
                        MI = true
                    end
                    --actions.precombat+=/potion
                elseif POT then
                    if isChecked("Potion") then
                        --potion
                        if canUse(127843) then
                            seq = seq + 1
                            useItem(127843)
                            Print(seq..": Potion Used!")
                        elseif canUse(142117) then
                            seq = seq + 1
                            useItem(142117)
                            Print(seq..": Potion Used!")
                        else
                            seq = seq + 1
                            Print(seq..": Potion (Can't Use)")
                        end
                        POT = true
                    else
                        POT = true
                    end
                    --actions.precombat+=/frostbolt
                elseif not FB then
                    seq = seq + 1
                    if castOpener("frostbolt","FB",seq) then return true end
                else
                    opener = true
                    Print("--Opener Complete--")
                end
            end

            return true
        end

        local function actionList_OPENER_ICYV()
            if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") or inCombat then
                if isChecked("Potion") then
                    if not POT then
                        --potion
                        if canUse(127843) then
                            seq = seq + 1
                            useItem(127843)
                            Print(seq..": Potion Used!")
                        elseif canUse(142117) then
                            seq = seq + 1
                            useItem(142117)
                            Print(seq..": Potion Used!")
                        else
                            seq = seq + 1
                            Print(seq..": Potion (Can't Use)")
                        end
                        POT = true
                        return true
                    end
                end

                --mirror image
                if not MI then
                    if talent.mirrorImage and cd.mirrorImage and useCDs() and isChecked(colorBlueMage.."Mirror Image") then
                        seq = seq + 1
                        if castOpener("mirrorImage","MI",seq, false) then return true end
                    else
                        MI = true
                    end
                elseif not EBB then
                    --ebonbolt
                    seq = seq + 1
                    if castOpener("ebonbolt","EBB",seq) then return true end
                end
            end
            if inCombat then
                --rune of power
                if not ROP then
                    if talent.runeOfPower and charges.runeOfPower > 0 and useCDs() and isChecked(colorBlueMage.."Rune of Power") and not buff.runeOfPower.exists() then
                        seq = seq + 1
                        if castOpener("runeOfPower","ROP",seq) then return true end
                    else
                        ROP = true
                    end
                    --icy veins
                elseif not IV then
                    if cd.icyVeins == 0 and useCDs() and isChecked(colorBlueMage.."Icy Veins") then
                        seq = seq + 1
                        if castOpener("icyVeins","IV",seq,false) then return true end
                    else
                        IV = true
                    end
                    --flurry
                elseif not FLR then
                    if buff.brainFreeze.exists() then
                        seq = seq + 1
                        if castOpener("flurry","FLR",seq) then return true end
                    else
                        FLR = true
                    end
                    --ice lance
                elseif not IL then
                    seq = seq + 1
                    if castOpener("iceLance","IL",seq) then return true end
                    --frozen orb
                elseif not FRO then
                    if cd.frozenOrb == 0 and useCDs() and isChecked(colorBlueMage.."Frozen Orb") then
                        seq = seq + 1
                        if castOpener("frozenOrb","FRO",seq) then return true end
                    else
                        FRO = true
                    end
                    --frost bomb
                elseif not FRB then
                    seq = seq + 1
                    if castOpener("frostBomb","FRB",seq) then return true end
                    --fingers of frost - ice lance
                elseif buff.fingersOfFrost.exists() then
                    if cast.iceLance(target) then
                        seq = seq + 1
                        Print(seq..": Ice Lance")
                        return true
                    else
                        seq = seq + 1
                        Print(seq..": Ice Lance (Uncastable)")
                        return true
                    end
                    --glacial spike
                elseif not GLP then
                    if buff.icicles.stack() == 5 then
                        seq = seq + 1
                        if castOpener("glacialSpike","GLP",seq) then return true end
                    else
                        GLP = true
                    end
                    --frostbolt
                elseif not FB then
                    seq = seq + 1
                    if castOpener("frostbolt","FB",seq) then return true end
                else
                    opener = true
                    Print("--Opener Complete--")
                end
            end
            return true
        end

        local function actionList_OPENER_RAYOFFROST()
            if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") or inCombat then
                if isChecked("Potion") then
                    if not POT then
                        --potion
                        if canUse(127843) then
                            seq = seq + 1
                            useItem(127843)
                            Print(seq..": Potion Used!")
                        elseif canUse(142117) then
                            seq = seq + 1
                            useItem(142117)
                            Print(seq..": Potion Used!")
                        else
                            seq = seq + 1
                            Print(seq..": Potion (Can't Use)")
                        end
                        POT = true
                        return true
                    end
                end
                --mirror image
                if not MI then
                    if talent.mirrorImage and cd.mirrorImage and useCDs() and isChecked(colorBlueMage.."Mirror Image") then
                        seq = seq + 1
                        if castOpener("mirrorImage","MI",seq, false) then return true end
                    else
                        MI = true
                    end
                elseif not EBB then
                    --ebonbolt
                    seq = seq + 1
                    if castOpener("ebonbolt","EBB",seq) then return true end
                end
            end
            if inCombat then
                --rune of power
                if not ROP then
                    if talent.runeOfPower and charges.runeOfPower > 0 and useCDs() and isChecked(colorBlueMage.."Rune of Power") and not buff.runeOfPower.exists() then
                        seq = seq + 1
                        if castOpener("runeOfPower","ROP",seq) then return true end
                    else
                        ROP = true
                    end
                    --icy veins
                elseif not IV then
                    if cd.icyVeins == 0 and useCDs() and isChecked(colorBlueMage.."Icy Veins") then
                        seq = seq + 1
                        if castOpener("icyVeins","IV",seq,false) then return true end
                    else
                        IV = true
                    end
                elseif not WJ then
                    if (not talent.runeOfPower or buff.runeOfPower.exists()) and cd.rayOfFrost == 0 and isChecked("Use Pet Spells") then
                        seq = seq + 1
                        if castOpener("waterJet","WJ",seq,false) then return true end
                    else
                        WJ = true
                    end
                elseif not RF then
                    if (not talent.runeOfPower or buff.runeOfPower.exists()) and cd.rayOfFrost == 0 and isChecked(colorBlueMage.."Ray of Frost") then
                        seq = seq + 1
                        if castOpener("rayOfFrost","RF",seq,false) then return true end
                    else
                        WJ = true
                    end
                else
                    opener = true
                    Print("--Opener Complete--")
                end
            end
            return true
        end

        if not opener and isChecked("Opener") and isBoss(target) then
            if getOptionValue("Opener Mode") == 1 then--SimC
                if actionList_OPENER_SIMC() then return true end
            elseif getOptionValue("Opener Mode") == 2 then -- Icy Veins
                if actionList_OPENER_ICYV() then return true end
            elseif getOptionValue("Opener Mode") == 3 then -- Ray of Frost
                if actionList_OPENER_RAYOFFROST() then return true end
            end
        end

        return false
    end
    
    local function actionList_PRECOMBAT()
        --actions.precombat=flask
        if isChecked("Flask / Crystal") then
            if inRaid and canUse(br.player.flask.wod.intellectBig) and not UnitBuffID("player",br.player.flask.wod.intellectBig) then
                useItem(br.player.flask.wod.intellectBig)
                return true
            end
            if not UnitBuffID("player",br.player.flask.wod.intellectBig) and canUse(118922) then --Draenor Insanity Crystal
                useItem(118922)
                return true
            end
        end
        --actions.precombat+=/food
        --actions.precombat+=/augmentation,type=defiled
        --actions.precombat+=/water_elemental
        if not IsPetActive() and not talent.lonelyWinter then
            if cast.summonWaterElemental("player") then return true end
        end

        return false
    end

    local function SimCAPLMode()

        local function actionList_CD()
            if useCDs() then
                if isChecked(colorBlueMage.."Rune of Power") and talent.runeOfPower then
                    --actions.cooldowns=rune_of_power,if=cooldown.icy_veins.remains<cast_time|charges_fractional>1.9&cooldown.icy_veins.remains>10|buff.icy_veins.up|target.time_to_die.remains+5<charges_fractional*10
                    if cd.icyVeins <= getCastTime(spell.runeOfPower) or charges.frac.runeOfPower > 1.9 and cd.icyVeins > 10 or buff.icyVeins.exists() or ttdUnit+5 < charges.frac.runeOfPower*10 then
                        if debug == true then Print("Casting Rune Of Power") end
                        if cast.runeOfPower("player") then
                            if debug == true then Print("Casted Rune Of Power") end
                            return true
                        end
                    end
                end
                if isChecked("Potion") then
                    --actions.cooldowns+=/potion,if=cooldown.icy_veins.remains<1
                    if cd.icyVeins < 1 then
                        if canUse(127843) then
                            if useItem(127843) then return true end
                        elseif canUse(142117) then
                            if useItem(142117) then return true end
                        end
                    end
                end

                
                --actions.cooldowns+=/icy_veins,if=buff.icy_veins.down
                if useCDs() and isChecked(colorBlueMage.."Icy Veins") and cd.icyVeins == 0 then
                    if not buff.icyVeins.exists() then
                        if debug == true then Print("Casting Icy Veins") end
                        if cast.icyVeins() then
                            if debug == true then Print("Casted Icy Veins") end
                            return true
                        end
                    end
                end
                if useCDs() and isChecked(colorBlueMage.."Mirror Image") and cd.mirrorImage == 0 then
                    --actions.cooldowns+=/mirror_image
                    if debug == true then Print("Casting Mirror Image") end
                    if cast.mirrorImage() then
                        if debug == true then Print("Casted Mirror Image") end
                        return true
                    end
                end
                

                --actions.cooldowns+=/use_item
                
                if getOptionValue("Trinket 1 Condition") == 1 then 
                    if isChecked("Trinket 1") and inCombat and canUse(13) then
                        useItem(13)
                    end
                elseif getOptionValue("Trinket 1 Condition") == 2 then
                    if isChecked("Trinket 1") and inCombat and getHP(target) <= getValue("Trinket 1") and canUse(13) and isBoss(target) then
                        useItem(13)
                    end
                elseif getOptionValue("Trinket 1 Condition") == 3 then
                    if isChecked("Trinket 1") and inCombat and health <= getValue("Trinket 1") and canUse(13) then
                        useItem(13)
                    end
                end
                
                if getOptionValue("Trinket 2 Condition") == 1 then 
                    if isChecked("Trinket 2") and inCombat and canUse(14) then
                        useItem(14)
                    end
                elseif getOptionValue("Trinket 2 Condition") == 2 then
                    if isChecked("Trinket 2") and inCombat and getHP(target) <= getValue("Trinket 2") and canUse(14) and isBoss(target) then
                        useItem(14)
                    end
                elseif getOptionValue("Trinket 2 Condition") == 3 then
                    if isChecked("Trinket 2") and inCombat and health <= getValue("Trinket 2") and canUse(14) then
                        useItem(14)
                    end
                end

                
                --actions.cooldowns+=/berserking|actions.cooldowns+=/blood_fury
                if isChecked("Use Racial") then
                    if getSpellCD(br.player.getRacial()) == 0 and (race == "Orc" or race == "Troll") then
                        if debug == true then Print("Casting Racial") end
                        if br.player.castRacial() then
                            if debug == true then Print("Casted Racial") end
                            return true
                        end
                    end
                end
            end
            return false
        end

        local function actionList_AOE()
            --actions.aoe=frostbolt,if=prev_off_gcd.water_jet
            if lastCast == spell.waterJet and getCastTime(spell.frostbolt)+0.2 < getCastTimeRemain("pet") then
                if cast.frostbolt(target) then return true end
            end
            
            --actions.aoe+=/frozen_orb
            if cd.frozenOrb == 0 then
                if useCDs() and isChecked(colorBlueMage.."Frozen Orb") and getEnemiesInRect(15,55,false) > 0 and buff.fingersOfFrost.stack() < 2 then
                    if cast.frozenOrb() then return true end
                end
            end
            
            --actions.aoe+=/blizzard
            if  cd.blizzard == 0 then
                if hasEquiped(133970) then
                    if buff.zannesuJourney.stack() == 5 and buff.zannesuJourney.remain() > getCastTime(spell.blizzard) then
                        if cast.blizzard(target,"ground") then return true end
                    end
                end
                if #enemies.yards8t > 2 or (#enemies.yards8t > 1 and not(talent.glacialSpike and talent.splittingIce)) then
                    if cast.blizzard(target,"ground") then return true end
                end
            end
            
            
            --actions.aoe+=/comet_storm
            if talent.cometStorm then
                if cd.cometStorm == 0 then
                    if isChecked(colorBlueMage.."Comet Storm")  and (IsStandingTime(2,target) or GetUnitSpeed(target) <= 3) then
                        if cast.cometStorm(target) then return true end
                    end
                end
            end
            --actions.aoe+=/ice_nova
            if talent.iceNova then
                if cd.iceNova == 0 then
                    if cast.iceNova() then return true end
                end
            end
            
            --water_jet,if=prev_gcd.1.frostbolt&buff.fingers_of_frost.stack<(2+artifact.icy_hand.enabled)&buff.brain_freeze.react=0
            if lastCast == spell.frostbolt and isCastingSpell(spell.frostbolt) and buff.fingersOfFrost.stack() < (2 + iceHand) and not buff.brainFreeze.exists() then
                CastSpellByName(GetSpellInfo(spell.waterJet))
                lastCast = spell.waterJet
            end
            
            --actions.aoe+=/flurry,if=prev_gcd.1.ebonbolt|prev_gcd.1.frostbolt&buff.brain_freeze.react
            if lastCast == spell.ebonbolt or lastCast == spell.frostbolt and buff.brainFreeze.exists() then
                if cast.flurry(target) then return true end
            end
            
            
            --actions.aoe+=/frost_bomb,if=debuff.frost_bomb.remains<action.ice_lance.travel_time&variable.fof_react>0
            --
            if talent.frostBomb then
                if lastCast ~= spell.frostBomb then
                    if not debuff.frostBomb.exists() or debuff.frostBomb.remain() < 2 and fof_react > 0 and ttdUnit >= 12 + getCastTime(spell.frostBomb)+0.5 then
                        if cast.frostBomb(target) then return true end
                    end
                end
            end
            
            
            --actions.aoe+=/ice_lance,if=variable.fof_react>0
            if fof_react > 0 then
                if cast.iceLance(target) then return true end
            end
            
            --actions.aoe+=/ebonbolt,if=buff.brain_freeze.react=0
            if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) then
                if not buff.brainFreeze.exists() then
                    if cast.ebonbolt(target) then return true end
                end
            end
            --actions.aoe+=/glacial_spike
            if talent.glacialSpike then
                if buff.icicles.stack() == 5 then
                    if cast.glacialSpike(target) then return true end
                end
            end
            --actions.aoe+=/frostbolt
            if cast.frostbolt(target) then return true end
            
            if cast.iceLance(target) then return true end
            return false
        end

        local function actionList_SINGLE()
            
            --actions.single=ice_nova,if=debuff.winters_chill.up--why?
            if talent.iceNova and debuff.wintersChill.exists() then 
                if  cd.iceNova == 0 then
                    if cast.iceNova() then return true end
                end
            end
            
            --  Frozen_orb,if=set_bonus.tier20_2pc
            
            --  With T20 2pc, Frozen Orb should be used as soon as it comes off CD.
            if cd.frozenOrb == 0 and t20pc2 then
                if useCDs() and isChecked(colorBlueMage.."Frozen Orb") and getEnemiesInRect(15,55,false) > 0 then
                    if cast.frozenOrb() then return true end
                end
            end
            
            --actions.single+=/frostbolt,if=prev_off_gcd.water_jet
            if lastCast == spell.waterJet and getCastTime(spell.frostbolt)+0.2 < getCastTimeRemain("pet") then
                if cast.frostbolt(target) then return true end
            end
            
            --water_jet,if=prev_gcd.1.frostbolt&buff.fingers_of_frost.stack<(2+artifact.icy_hand.enabled)&buff.brain_freeze.react=0
            --Basic Water Jet combo. Since Water Jet can only be used if the actor is not casting, we use it right after Frostbolt is executed. 
            --At the default distance, Frostbolt travels slightly over 1 s, giving Water Jet enough time to apply the DoT (Water Jet's cast time is 1 s, with haste scaling). 
            --The APL then forces another Frostbolt to guarantee getting both FoFs from the Water Jet. This works for most haste values (roughly from 0% to 160%). 
            --When changing the default distance, great care must be taken otherwise this action won't produce two FoFs.
            
            if lastCast == spell.frostbolt and buff.fingersOfFrost.stack() < (2 + iceHand) and not buff.brainFreeze.exists() then
                CastSpellByName(GetSpellInfo(spell.waterJet))
                lastCast = spell.waterJet
            end
            
            --actions.single+=/ray_of_frost,if=buff.icy_veins.up|(cooldown.icy_veins.remains>action.ray_of_frost.cooldown&buff.rune_of_power.down)
            if talent.rayOfFrost then
                if  cd.rayOfFrost == 0 then
                    if useCDs() and isChecked(colorBlueMage.."Ray of Frost") then
                        if buff.icyVeins.exists() or (cd.icyVeins > cd.rayOfFrost and not buff.runeOfPower.exists()) then
                            if cast.rayOfFrost() then return true end
                        end
                    end
                end
            end
            
            --Flurry,if= prev_gcd.1.ebonbolt | buff.brain_freeze.react&(!talent.glacial_spike.enabled&prev_gcd.1.frostbolt | talent.glacial_spike.enabled&(prev_gcd.1.glacial_spike | prev_gcd.1.frostbolt&(buff.icicles.stack<=3 | cooldown.frozen_orb.remains<=10&set_bonus.tier20_2pc)))
            --Winter's Chill from Flurry can apply to the spell cast right before (provided the travel time is long enough). 
            --This can be exploited to a great effect with Ebonbolt, Glacial Spike (which deal a lot of damage by themselves) and Frostbolt (as a guaranteed way to proc Frozen Veins and Chain Reaction). 
            --When using Glacial Spike, it is worth saving a Brain Freeze proc when Glacial Spike is right around the corner (i.e. with 4 or more Icicles). 
            --However, when the actor also has T20 2pc, Glacial Spike is delayed to fit into Frozen Mass, so we do not want to sit on a Brain Freeze proc for too long in that case.
            if lastCast == spell.ebonbolt or buff.brainFreeze.exists() and (not talent.glacialSpike and lastCast == spell.frostbolt or talent.glacialSpike and (lastCast == spell.glacialSpike or lastCast == spell.frostbolt and (buff.icicles.stack() <= 3 or cd.frozenOrb <= 10 and t202pc))) then
                if cast.flurry(target) then return true end
            end
    
            --blizzard,if=cast_time=0&active_enemies>1&variable.fof_react<3
            --Freezing Rain Blizzard. 
            --While the normal Blizzard action is usually enough, right after Frozen Orb the actor will be getting a lot of FoFs, which might delay Blizzard to the point where we miss out on Freezing Rain. 
            --Therefore, if we are not at a risk of overcapping on FoF, use Blizzard before using Ice Lance.
            if cd.blizzard == 0 and getCastTime(spell.blizzard) == 0 then
                if #enemies.yards8t > 1 and fof_react < 3  then
                    if cast.blizzard(target,"ground") then return true end
                end
            end
            

            --actions.single+=/frost_bomb,if=debuff.frost_bomb.remains<action.ice_lance.travel_time&variable.fof_react>0
            if talent.frostBomb then
                if debuff.frostBomb.remain() < 1 and fof_react > 0 then
                    if cast.frostBomb(target) then return true end
                end
            end
            
            --actions.single+=/ice_lance,if=variable.fof_react>0&cooldown.icy_veins.remains>10|variable.fof_react>2
            if fof_react > 0 and cd.icyVeins > 10 or fof_react > 2 then
                if cast.iceLance(target) then return true end
            end
            
            --actions.single+=/ebonbolt,if=buff.brain_freeze.react=0
            if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) then
                if not buff.brainFreeze.exists() then
                    if cast.ebonbolt(target) then return true end
                end
            end
            
            --actions.single+=/frozen_orb
            if cd.frozenOrb == 0 then
                if useCDs() and isChecked(colorBlueMage.."Frozen Orb") and getEnemiesInRect(15,55,false) > 0 then
                    if cast.frozenOrb() then return true end
                end
            end
            
            --actions.single=ice_nova,if=debuff.winters_chill.up--why?
            if talent.iceNova then
                if  cd.iceNova == 0 then
                    if cast.iceNova() then return true end
                end
            end
            
            --  comet_storm
            if talent.cometStorm then
                if cd.cometStorm == 0 then
                    if isChecked(colorBlueMage.."Comet Storm") and ( IsStandingTime(2,target) or GetUnitSpeed(target) <= 3) then
                        if cast.cometStorm(target) then return true end
                    end
                end
            end
            
            --Blizzard,if=active_enemies>2|active_enemies>1&!(talent.glacial_spike.enabled&talent.splitting_ice.enabled)|(buff.zannesu_journey.stack=5&buff.zannesu_journey.remains>cast_time)
            --Against low number of targets, Blizzard is used as a filler. Use it only against 2 or more targets, 3 or more when using Glacial Spike and Splitting Ice. 
            --Zann'esu buffed Blizzard is used only at 5 stacks.
            
            if  cd.blizzard == 0 then
                if hasEquiped(133970) then
                    if buff.zannesuJourney.stack() == 5 and buff.zannesuJourney.remain() > getCastTime(spell.blizzard) then
                        if cast.blizzard(target,"ground") then return true end
                    end
                end
                if #enemies.yards8t > 2 or #enemies.yards8t > 1 and not(talent.glacialSpike and talent.splittingIce) then
                    if cast.blizzard(target,"ground") then return true end
                end
            end
            
            --frostbolt,if=buff.frozen_mass.remains>execute_time+action.glacial_spike.execute_time+action.glacial_spike.travel_time&buff.brain_freeze.react=0&talent.glacial_spike.enabled
            --While Frozen Mass is active, we want to generate as many buffed Icicles as possible. 
            --However, we do not want to do this at the expense of the final Glacial Spike, which should be also used while Frozen Mass is active.
            if buff.frozenMass.remain() >  getSpellCD(spell.frostbolt) + getCastTime(spell.glacialSpike) + 1 and not buff.brainFreeze.exists() and talent.glacialSpike then
                if cast.frostbolt(target) then return true end
            end
            
            --  glacial_spike,if=cooldown.frozen_orb.remains>10|!set_bonus.tier20_2pc
            --Glacial Spike is generally used as it is available, unless we have T20 2pc. 
            --In that case, Glacial Spike is delayed when Frozen Mass is happening soon (in less than 10 s).
            if talent.glacialSpike then
                if cd.frozenOrb > 10 or not t20pc2 then
                    if buff.icicles.stack() == 5 then 
                        if cast.glacialSpike(target) then return true end
                    end
                end
            end
            
            if cast.frostbolt(target) then return true end
            
            if cd.blizzard == 0 then
                if getCastTime(spell.blizzard) == 0 then
                    if cast.blizzard(target,"ground") then return true end
                end
            end
            
            if cast.iceLance(target) then return true end
            
            return false
            
        end

        local function actionList_COMBAT()
            if cd.icyVeins == 0 and not buff.icyVeins.exists() then
                if debug == true then Print("iv_start Changed: "..iv_start) end
                    iv_start = getCombatTime()
            end
            
            --actions+=/variable,name=time_until_fof,value=10-(time-variable.iv_start-floor((time-variable.iv_start)%10)*10)
            time_until_fof = 10-(getCombatTime() - iv_start - math.floor(math.fmod((getCombatTime() - iv_start),10))*10)
            if debug == true then Print("time_until_fof Changed: "..time_until_fof) end
            --actions+=/variable,name=fof_react,value=buff.fingers_of_frost.react
            if buff.fingersOfFrost.exists() then
                fof_react = 1
                if debug == true then Print("fof_react Changed: "..fof_react) end
            else
                fof_react = 0
                if debug == true then Print("fof_react Changed: "..fof_react) end
            end
            --actions+=/variable,name=fof_react,value=buff.fingers_of_frost.stack,if=equipped.lady_vashjs_grasp&buff.icy_veins.up&variable.time_until_fof>9|prev_off_gcd.freeze
            if hasEquiped(132411) and buff.icyVeins.exists() and time_until_fof > 9 or lastCast == spell.freeze then
                fof_react = buff.fingersOfFrost.stack()
                if debug == true then Print("fof_react Changed: "..fof_react) end
            end
            --actions+=/ice_lance,if=variable.fof_react=0&prev_gcd.1.flurry
            if fof_react == 0 and lastCast == spell.flurry then
                if debug == true then Print("Casting Ice Lance") end
                if cast.iceLance(target) then
                    if debug == true then Print("Casted Ice Lance") end
                    return true
                end
            end
            --actions+=/call_action_list,name=cooldowns
            if actionList_CD() then return true end
            --actions+=/call_action_list,name=aoe,if=active_enemies>=4
            if #enemies.yards40 >= getValue("AOE targets") and (mode.rotation == 1 or mode.rotation == 2) then
                if actionList_AOE() then return true end
            end
            --actions+=/call_action_list,name=single
            if actionList_SINGLE() then return true end
            return false
        end
        

        if actionList_COMBAT() then return true end
        return false
    end

    local function MovingMode()
    
        if lastCast == spell.ebonbolt or buff.brainFreeze.exists() and (not talent.glacialSpike and lastCast == spell.frostbolt or talent.glacialSpike and (lastCast == spell.glacialSpike or lastCast == spell.frostbolt and (buff.icicles.stack() <= 3 or cd.frozenOrb <= 10 and t202pc))) then
            if cast.flurry(target) then return true end
        end
        
        --actions.single+=/ice_lance,if=variable.fof_react>0&cooldown.icy_veins.remains>10|variable.fof_react>2
        if fof_react > 0 and cd.icyVeins > 10 or fof_react > 2 then
            if cast.iceLance(target) then return true end
        end
        
    -- Instant cast blizzard
        -- While the normal Blizzard action is usually enough, right after Frozen Orb the actor will be getting a lot of FoFs, which might delay Blizzard to the point where we miss out on Freezing Rain. 
        -- Therefore, if we are not at a risk of overcapping on FoF, use Blizzard before using Ice Lance.
        if cd.blizzard == 0 then
            if getCastTime(spell.blizzard) == 0 and fof_react < 3 and (lastCast == spell.frozenOrb or cd.frozenOrb > 5) then
                if cast.blizzard(target,"ground") then return true end
            end
        end
        
        if cd.coneOfCold == 0 and isMoving("player") then
            if isChecked(colorBlueMage.."Cone of Cold") then
                if getFacing("player",target,50) and getDistance(target) < 12 then
                    if cast.coneOfCold("player") then return true end
                end
            end
        end
        
        if #br.player.enemies(12) > 0 and isMoving("player") then
            if cast.frostNova() then return true end
        end
        
        if talent.iceNova and cd.iceNova == 0 and isMoving("player") then
            if cast.iceNova() then return true end
        end

        --ice lance if all else fails
        if cast.iceLance(target) and isMoving("player") then return true end
    end
    -----------------
    --- Rotations ---
    -----------------
    function profile()
        -- Pause
        if pause(true) or (GetUnitExists(target) and (UnitIsDeadOrGhost(target) or not UnitCanAttack(target, "player"))) or mode.rotation == 4 then
            return true
        else
            ---------------------------------
            --- Out Of Combat - Rotations ---
            ---------------------------------
            if not inCombat and GetObjectExists(target) and not UnitIsDeadOrGhost(target) and UnitCanAttack(target, "player") then
                StopAttack()
                opener = false
                if actionList_PRECOMBAT() then return true end
            end -- End Out of Combat Rotation

            -----------------------------
            --- In Combat - Rotations ---
            -----------------------------
            if actionList_OPENER() then return true end
            if inCombat then
                if not UnitIsUnit("pettarget",target) then
                    PetAttack()
                end
                if actionList_INTERRUPT() then return true end
                if actionList_DEFENSIVE() then return true end
                if not isMoving("player") then
                    if SimCAPLMode() then return true end
                else
                    if MovingMode() then return true end
                end
                
            end -- End In Combat Rotation
        end -- Pause
    end



    if lastCast == spell.frostbolt and isCastingSpell(spell.frostbolt) and buff.fingersOfFrost.stack() < (2 + iceHand) and not buff.brainFreeze.exists() then
        CastSpellByName(GetSpellInfo(spell.waterJet))
        lastCast = spell.waterJet
    end
    
    if isCastingSpell(spell.waterJet,"pet") then
        lastCast = spell.waterJet
    end
    
    if UnitCastingInfo("player") == nil and getSpellCD(61304) == 0 then
        return profile()
    end
end -- End Timer

local id = 64

if br.rotations[id] == nil then br.rotations[id] = {} end

tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
