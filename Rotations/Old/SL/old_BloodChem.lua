local rotationName = "Chem - 8.0.1"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.bloodBoil },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bloodBoil },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.heartStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.deathStrike}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.bonestorm },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.bonestorm },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.bonestorm }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.vampiricBlood },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.vampiricBlood }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.asphyxiate },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.asphyxiate }
    };
    CreateButton("Interrupt",4,0)
    --[[DnDModes = {
        [1] = { mode = "On", value = 1 , overlay = "Death and Decay Enabled", tip = "Use Death and Decay", highlight = 1, icon = br.player.spell.deathAndDecay },
        [2] = { mode = "Off", value = 2 , overlay = "Death and Decay Disabled", tip = "Don't use Death and Decay", highlight = 0, icon = br.player.spell.deathAndDecay }
    };
    CreateButton("DND",5,0)
    BoneStormModes = {
        [1] = { mode = "On", value = 1 , overlay = "Bonestorm Enabled", tip = "Use Bonestorm", highlight = 1, icon = br.player.spell.bonestorm },
        [2] = { mode = "Off", value = 2 , overlay = "Bonestorm Disabled", tip = "Don't use Bonestorm", highlight = 0, icon = br.player.spell.bonestorm }
    };
    CreateButton("BoneStorm",6,0)]]
    DNDModes = {
        [1] = { mode = "On", value = 1 , overlay = "Death and Decay Enabled", tip = "Use Death and Decay", highlight = 1, icon = br.player.spell.deathAndDecay},
        [2] = { mode = "Off", value = 2 , overlay = "Death and Decay Disabled", tip = "Don't use Death and Decay", highlight = 0, icon = br.player.spell.deathAndDecay}
    };
    CreateButton("DND",5,0)
    BoneStormModes = {
        [1] = { mode = "On", value = 1 , overlay = "BoneStorm Enabled", tip = "Use Bonestorm", highlight = 1, icon = br.player.spell.bonestorm},
        [2] = { mode = "Off", value = 2 , overlay = "BoneStorm Disabled", tip = "Don't use Bonestorm", highlight = 0, icon = br.player.spell.bonestorm}
    };
    CreateButton("BoneStorm",6,0)
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
        -- APL
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minutes. Min: 5 / Max: 60 / Interval: 5")
        -- Dark Command
            br.ui:createCheckbox(section,"Dark Command","|cffFFFFFFAuto Dark Command usage.")
        -- Active Mitigation
            br.ui:createCheckbox(section,"Active Mitigation","|cffFFFFFF to use Active Mitigation for select spells.")
        -- Active Mitigation
            br.ui:createCheckbox(section,"Blooddrinker")
        -- Death's Advance whenever available outside of combat
          br.ui:createCheckbox(section, "Death's Advance (OOC)", "Death's Advance whenever available outside of combat")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Agi Pot
            br.ui:createCheckbox(section, "Potion")
        -- Flask / Crystal
            br.ui:createCheckbox(section, "Flask / Crystal")
        -- Racial
            br.ui:createCheckbox(section, "Racial")
        -- Trinkets
            br.ui:createCheckbox(section, "Trinkets")
        -- Dancing Rune Weapon
            br.ui:createCheckbox(section, "Dancing Rune Weapon")
            br.ui:createCheckbox(section, "Tombstone")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Rune Tap
            br.ui:createSpinner(section, "Rune Tap",  40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Anti-Magic Shell
            br.ui:createSpinner(section, "Anti-Magic Shell",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Blooddrinker
            --br.ui:createSpinner(section, "Blooddrinker",  75,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Vampiric Blood
            br.ui:createSpinner(section, "Vampiric Blood",  40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Icebound Fortitude
            br.ui:createSpinner(section, "Icebound Fortitude",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        -- Raise Ally
            br.ui:createCheckbox(section,"Raise Ally")
            br.ui:createDropdownWithout(section, "Raise Ally - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Asphyxiate
            br.ui:createCheckbox(section,"Asphyxiate")
        -- Death Grip
            br.ui:createCheckbox(section,"Death Grip - Int")
        -- Mind Freeze
            br.ui:createCheckbox(section,"Mind Freeze")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupts",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
        -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
        -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
        -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugBlood", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("DND",0.25)
        br.player.ui.mode.DND = br.data.settings[br.selectedSpec].toggles["DND"]
        UpdateToggle("BoneStorm",0.25)
        br.player.ui.mode.BoneStorm = br.data.settings[br.selectedSpec].toggles["BoneStorm"]

--------------
--- Locals ---
--------------
        local addsExist                                     = false
        local addsIn                                        = 999
        --local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local canFlask                                      = canUseItem(br.player.flask.wod.staminaBig)
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local fatality                                      = false
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.staminaBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.ui.mode
        local multidot                                      = (br.player.ui.mode.cleave == 1 or br.player.ui.mode.rotation == 2) and br.player.ui.mode.rotation ~= 3
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local potion                                        = br.player.potion
        local power, powmax, powgen                         = br.player.power.runicPower.amount(), br.player.power.runicPower.max(), br.player.power.runicPower.regen()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local runes                                         = br.player.power.runes.frac()
        local runicPower                                    = br.player.power.runicPower.amount()
        local runicPowerDeficit                             = br.player.power.runicPower.deficit()
        local solo                                          = #br.friend < 2
        local friendsInRange                                = friendsInRange
        local spell                                         = br.player.spell
        local stealth                                       = br.player.stealth
        local talent                                        = br.player.talent
        local trinketProc                                   = false
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.runicPower.ttm()
        local units                                         = br.player.units

        units.get(5)
        units.get(30,true)

        enemies.get(8)       -- Bonestorm
        enemies.get(10)     -- blood boil
        enemies.get(30)
        enemies.get(40)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if MRCastTime == nil then MRCastTime = GetTime() end
        if DSCastTime == nil then DSCastTime = GetTime() end

        local function HasMitigationUp()
            if MRCastTime + 2.5 <= GetTime() or DSCastTime + 2.5 <= GetTime() then
                return true
            else 
                return false
            end
        end

        UnitsWithoutBloodPlague = 0;
        for _, CycleUnit in pairs(enemies.yards10) do
            if not debuff.bloodPlague.exists(CycleUnit) then
                UnitsWithoutBloodPlague = UnitsWithoutBloodPlague + 1
            end
        end

        -- list stolen from AR
        local ActiveMitigationSpells = {
            Buff = {
                -- PR Legion
                191941, -- Darkstrikes (VotW - 1st)
                204151, -- Darkstrikes (VotW - 1st)
                -- T20 ToS
                239932 -- Felclaws (KJ)
            },
            Debuff = {

            },
            Cast = {
                -- PR Legion
                197810, -- Wicked Slam (ARC - 3rd)
                197418, -- Vengeful Shear (BRH - 2nd)
                198079, -- Hateful Gaze (BRH - 3rd)
                214003, -- Coup de Grace (BRH - Trash)
                235751, -- Timber Smash (CotEN - 1st)
                193092, -- Bloodletting Sweep (HoV - 1st)
                193668, -- Savage Blade (HoV - 4th)
                227493, -- Mortal Strike (LOWR - 4th)
                228852, -- Shared Suffering (LOWR - 4th)
                193211, -- Dark Slash (MoS - 1st)
                200732, -- Molten Crash (NL - 4th)
                -- T20 ToS
                241635, -- Hammer of Creation (Maiden)
                241636, -- Hammer of Obliteration (Maiden)
                236494, -- Desolate (Avatar)
                239932, -- Felclaws (KJ)
                -- T21 Antorus
                254919, -- Forging Strike (Kin'garoth)
                244899, -- Fiery Strike (Coven)
                245458, -- Foe Breaker (Aggramar)
                248499, -- Sweeping Scythe (Argus)
                258039 -- Deadly Scythe (Argus)
            }
        }
        -- 193092, -- Bloodletting Sweep (HoV - 1st)

        local function ShouldMitigate()
            if HasMitigationUp() == true then
                return false
            else
                if UnitThreatSituation("player", "target") == 3 then
                    if isCasting("target", ActiveMitigationSpells.Cast) then
                        return true
                    end
                    for _, Buff in pairs(ActiveMitigationSpells.Buff) do
                        if isBuffed("target", Buff) then
                            return true
                        end
                    end
                end
            end
            return false
        end

--------------------
--- Action Lists ---
--------------------
    -- Action List - Active Mitigation
        local function actionList_ActiveMitigation()
            if ShouldMitigate() then
                if isCastingSpell(spell.blooddrinker) then StopCasting() end
                if buff.boneShield.stack >= 7 then
                    if cast.deathStrike() then DSCastTime = GetTime(); Print("AM: DS"); return end
                end
                if cast.marrowrend() then MRCastTime = GetTime(); Print("AM: MR"); return end
                if cast.deathStrike() then DSCastTime = GetTime(); Print("AM: DS2"); return end
            end
        end
    -- Action List - Extras
        local function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end -- End Dummy Test
    -- Dark Command
            if isChecked("Dark Command") and inInstance then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                        if cast.darkCommand(thisUnit) then return end
                    end
                end
            end

            if isChecked("Death's Advance (OOC)") then
              if cast.able.deathsAdvance then
                if cast.deathsAdvance() then return end
              end
            end

            -- for i = 1, #enemies.yards30 do
            --   local thisUnit = enemies.yards30[i]
            --   if UnitCreatureTypes(thisUnit) == "Undead" then
            --     if cast.controlUndead(thisUnit) then return end
            --   end
            -- end

        end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
            if useDefensive() and not stealth and not flight then
        -- Pot/Stoned
                if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(healPot) then
                        useItem(healPot)
                    end
                end
        -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end
        -- Rune Tap
                if isChecked("Rune Tap") and php <= getOptionValue("Rune Tap") and runes >= 3 and charges.runeTap.count() > 1 and not buff.runeTap.exists() then
                    if cast.runeTap() then return end
                end
        -- Anti-Magic Shell
                if isChecked("Anti-Magic Shell") and php <= getOptionValue("Anti-Magic Shell") then
                    if cast.antiMagicShell() then return end
                end
        -- Blooddrinker
                --[[if isChecked("Blooddrinker") and talent.blooddrinker and php <= getOptionValue("Blooddrinker") and not cast.blooddrinker.current() then
                    if cast.blooddrinker() then return end
                end]]
        -- Icebound Fortitude
                if isChecked("Icebound Fortitude") and php <= getOptionValue("Icebound Fortitude") then
                    if cast.iceboundFortitude() then return end
                end
        -- Vampiric Blood
                if isChecked("Vampiric Blood") and php <= getOptionValue("Vampiric Blood") then
                    if cast.vampiricBlood() then return end
                end
        -- Raise Ally
                if isChecked("Raise Ally") then
                    if getOptionValue("Raise Ally - Target")==1
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                    then
                        if cast.raiseAlly("target","dead") then return end
                    end
                    if getOptionValue("Raise Ally - Target")==2
                        and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                    then
                        if cast.raiseAlly("mouseover","dead") then return end
                    end
                end
            end
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Death Grip
                        if isChecked("Death Grip - Int") and getDistance(thisUnit) > 8 then
                            if cast.deathGrip(thisUnit) then return end
                        end
        -- Asphyxiate
                        if isChecked("Asphyxiate") and getDistance(thisUnit) < 20 and cd.mindFreeze.remain() > 0 then
                            if cast.asphyxiate(thisUnit) then return end
                        end
        -- Mind Freeze
                        if isChecked("Mind Freeze") and getDistance(thisUnit) < 15 then
                            if cast.mindFreeze(thisUnit) then return end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if useCDs() and getDistance(units.dyn5) < 5 then
        -- Trinkets
                if isChecked("Trinkets") then
                    if canUseItem(13) then
                        useItem(13)
                    end
                    if canUseItem(14) then
                        useItem(14)
                    end
                end
                if isChecked("Racial") then
                  -- blood_fury,if=cooldown.dancing_rune_weapon.ready&(!cooldown.blooddrinker.ready|!talent.blooddrinker.enabled)
                  if br.player.race == "Orc" and cast.able.racial() and (not cd.dancingRuneWeapon.exists() and (cd.blooddrinker.exists())) then
                    return cast.racial()
                  end
                  -- arcane_torrent,if=runic_power.deficit>20
                  if br.player.race == "BloodElf" and cast.able.racial() and (runicPowerDeficit > 20) then
                    return cast.racial()
                  end
                end
                if isChecked("Dancing Rune Weapon") then
                  -- dancing_rune_weapon,if=!talent.blooddrinker.enabled|!cooldown.blooddrinker.ready
                  if cast.able.dancingRuneWeapon() and (not talent.blooddrinker or cd.blooddrinker.exists()) then
                    return cast.dancingRuneWeapon()
                  end
                end
                if isChecked("Tombstone") then
                  -- tombstone,if=buff.bone_shield.stack>=7
                  if cast.able.tombstone() and (buff.boneShield.stack() >= 7) then
                    return cast.tombstone()
                  end
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
                if not stealth then
        -- Flask / Crystal
                    -- flask,type=flask_of_Ten_Thousand_Scars
                    if isChecked("Flask / Crystal") and not stealth then
                        if inRaid and canFlask and flaskBuff==0 and not (UnitBuffID("player",188035) or UnitBuffID("player",188034)) then
                            useItem(br.player.flask.wod.staminaBig)
                            return true
                        end
                        if flaskBuff==0 then
                            if not UnitBuffID("player",188033) and canUseItem(118922) then --Draenor Insanity Crystal
                                useItem(118922)
                                return true
                            end
                        end
                    end
        -- auto_attack
                    if canAttack() and not UnitIsDeadOrGhost("target") and getDistance("target") <= 5 then
                       StartAttack()
                    end
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
-----------------------
--- Extras Rotation ---
-----------------------
            if actionList_Extras() then return end
--------------------------
--- Defensive Rotation ---
--------------------------
            if actionList_Defensive() then return end
------------------------------
--- Out of Combat Rotation ---
------------------------------
            if actionList_PreCombat() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
        -- Cat is 4 fyte!
            if inCombat and profileStop==false and isValidUnit(units.dyn5) then
                -- auto_attack
                if getDistance("target") < 5 then
                    StartAttack()
                end
    ------------------------------
    ------ Active Mitigation -----
    ------------------------------
                if isChecked("Active Mitigation") then
                    if actionList_ActiveMitigation() then return end
                end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    -----------------------------
    --- In Combat - Cooldowns ---
    -----------------------------
                if actionList_Cooldowns() then return end
                local bloodDrinkerCheck = not cd.blooddrinker.exists() and 1 or 0
    --------------------------
    ---- Chem (SimC 8.0) APL --
    ---------------------------
                -- death_strike,if=runic_power.deficit<=10
                if cast.able.deathStrike() and (runicPowerDeficit <= 10) then
                  return cast.deathStrike("target")
                end
                -- blooddrinker,if=!buff.dancing_rune_weapon.up
                if cast.able.blooddrinker() and (not buff.dancingRuneWeapon.exists()) then
                  return cast.blooddrinker("target")
                end
                -- marrowrend,if=(buff.bone_shield.remains<=rune.time_to_3|buff.bone_shield.remains<=(gcd+cooldown.blooddrinker.ready*talent.blooddrinker.enabled*2)|buff.bone_shield.stack<3)&runic_power.deficit>=20
                if cast.able.marrowrend() and ((buff.boneShield.remain() <= runeTimeTill(3) or buff.boneShield.remain() <= (gcdMax + bloodDrinkerCheck * (talent.blooddrinker and 1 or 0) * 2) or buff.boneShield.stack() < 3) and runicPowerDeficit >= 20) then
                  return cast.marrowrend("target")
                end
                -- blood_boil,if=charges_fractional>=1.8&(buff.hemostasis.stack<=(5-spell_targets.blood_boil)|spell_targets.blood_boil>2)
                if cast.able.bloodBoil() and (charges.bloodBoil.frac() >= 1.8 and (buff.hemostasis.stack() <= (5 - #enemies.yards10) or #enemies.yards10 > 2)) then
                  return cast.bloodBoil()
                end
                -- marrowrend,if=buff.bone_shield.stack<5&talent.ossuary.enabled&runic_power.deficit>=15
                if cast.able.marrowrend() and (buff.boneShield.stack() < 5 and talent.ossuary and runicPowerDeficit >= 15) then
                  return cast.marrowrend("target")
                end
                -- bonestorm,if=runic_power>=100&!buff.dancing_rune_weapon.up
                if cast.able.bonestorm() and (runicPower >= 100 and not buff.dancingRuneWeapon.exists()) then
                  return cast.bonestorm("player")
                end
                -- death_strike,if=runic_power.deficit<=(15+buff.dancing_rune_weapon.up*5+spell_targets.heart_strike*talent.heartbreaker.enabled*2)|target.time_to_die<10
                if cast.able.deathStrike() and (runicPowerDeficit <= (15 + (buff.dancingRuneWeapon.exists() and 1 or 0) * 5 + #enemies.yards8 * (talent.heartbreaker and 1 or 0) * 2) or ttd("target") < 10) then
                  return cast.deathStrike("target")
                end
                -- death_and_decay,if=spell_targets.death_and_decay>=3
                if cast.able.deathAndDecay() and (#enemies.yards8 >= 3) then
                  return cast.deathAndDecay("player")
                end
                -- rune_strike,if=(charges_fractional>=1.8|buff.dancing_rune_weapon.up)&rune.time_to_3>=gcd
                if talent.runeStrike and cast.able.runeStrike() and ((charges.runeStrike.frac() >= 1.8 or buff.dancingRuneWeapon.exists()) and runeTimeTill(3) >= gcdMax) then
                  return cast.runeStrike("target")
                end
                -- heart_strike,if=buff.dancing_rune_weapon.up|rune.time_to_4<gcd
                if cast.able.heartStrike() and (buff.dancingRuneWeapon.exists() or runeTimeTill(4) < gcdMax) then
                  return cast.heartStrike("target")
                end
                -- blood_boil,if=buff.dancing_rune_weapon.up
                if cast.able.bloodBoil() and (buff.dancingRuneWeapon.exists()) then
                  return cast.bloodBoil()
                end
                -- death_and_decay,if=buff.crimson_scourge.up|talent.rapid_decomposition.enabled|spell_targets.death_and_decay>=2
                if cast.able.deathAndDecay() and (buff.crimsonScourge.exists() or talent.rapidDecomposition or #enemies.yards8 >= 2) then
                  return cast.deathAndDecay("player")
                end
                -- consumption
                if cast.able.consumption() then
                  return cast.consumption()
                end
                -- blood_boil
                if cast.able.bloodBoil() then
                  return cast.bloodBoil()
                end
                -- heart_strike,if=rune.time_to_3<gcd|buff.bone_shield.stack>6
                if cast.able.heartStrike() and (runeTimeTill(3) < gcdMax or buff.boneShield.stack() > 6) then
                  return cast.heartStrike("target")
                end
                -- rune_strike
                if talent.runeStrike and cast.able.runeStrike() then
                  return cast.runeStrike("target")
                end
                --end
            end --End In Combat
        end --End Rotation Logic
    end -- End Timer
end -- End runRotation
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
