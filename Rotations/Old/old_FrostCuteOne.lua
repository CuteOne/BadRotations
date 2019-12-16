local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.flamestrike},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.flamestrike},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.pyroblast},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.iceBlock}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.combustion},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.combustion},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.combustion}
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
        local section
    -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR","|cff00ccffDBT","|cffff0000Testing"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Mirror Image
            br.ui:createCheckbox(section,"Mirror Image")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
        -- Frost Nova
            br.ui:createSpinner(section, "Frost Nova",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Couterspell
            br.ui:createCheckbox(section, "Counterspell")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
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
--- Spell Stats ---
----------------
local frostboltCount = 0
local ilfCount = 0
local wjfrostCount = 0
local wjCount = 0
local icelanceCount = 0
local flurryCount = 0




local function clearStats()
    frostboltCount = 0
    ilfCount = 0
    wjfrostCount = 0
    wjCount = 0
    icelanceCount = 0
    flurryCount = 0
end
----------------
--- ROTATION ---
----------------
local function runRotation()
    if br.timer:useTimer("debugFrost", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
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
        local activePet                                     = br.player.pet
        local activePetId                                   = br.player.petId
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
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
        local hasPet                                        = IsPetActive()
        local hasteAmount                                   = GetHaste()/100
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
        local moving                                        = isMoving("player")
        local perk                                          = br.player.perk
        local petInfo                                       = br.player.petInfo
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount, br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units
        local dt                                            = date("%H:%M:%S")
        local debug                                         = false

        units.get(40)
        enemies.get(8,"target")
        enemies.get(12)
        enemies.get(30)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if artifact.icyHand.enabled() then iceHand= 1 else iceHand = 0 end
        local fofMax = (2 + iceHand)
--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        -- Print("FrostBolts:  " .. frostboltCount)
                        -- Print("IceLances:  " .. icelanceCount)
                        -- Print("Flurry:  " .. flurryCount)
                        profileStop = true
                    end
                end
            end -- End Dummy Test

        end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
            if useDefensive() then
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
        -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Frost Nova
                if isChecked("Frost Nova") and php <= getOptionValue("Frost Nova") and #enemies.yards12 > 0 then
                    if cast.frostNova() then return end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Counterspell
                        if isChecked("Counterspell") then
                            if cast.counterspell(thisUnit) then return end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_CooldownsAMR()
            if useCDs() and getDistance(units.dyn40) < 40 then
        -- Rune of Power
                -- rune_of_power,if=cooldown.icy_veins.remain()s<cast_time|charges_fractional>1.9&cooldown.icy_veins.remain()s>10|buff.icy_veins.up|target.time_to_die.remain()s+5<charges_fractional*10
                -- TODO
        -- Potion
                -- potion,name=deadly_grace
                -- TODO
        -- Icy Veins
                -- icy_veins,if=buff.icy_veins.down
                -- TODO
        -- Mirror Image
                -- mirror_image
                if isChecked("Mirror Image") then
                    if cast.mirrorImage() then return end
                end
        -- Use Neck
                -- use_item,slot=neck
                -- TODO
        -- Trinkets
                if isChecked("Trinkets") then
                    if canUseItem(13) then
                        useItem(13)
                    end
                    if canUseItem(14) then
                        useItem(14)
                    end
                end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury | berserking | arcane_torrent
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Frost Mage CDs -------------------------------------------
        -- Cooldowns Spell TimeWarp if HasItem(ShardOfTheExodar) and not HasBuff(Bloodlust)
                  -- NOT GONNA INCLUDE TIMEWARP FOR RAID GROUPS
        -- Cooldowns Spell RuneOfPower if CooldownSecRemaining(IcyVeins) < SpellCastTimeSec(RuneOfPower)
                if cd.icyVeins.remain() < getCastTime(spell.runeOfPower) then
                    if cast.runeOfPower() then return end
                end
        -- Cooldowns Spell IcyVeins if not HasBuff(IcyVeins)
                if not buff.icyVeins.exists() then
                    if cast.icyVeins() then return end
                end
        -- Cooldowns Spell RuneOfPower if ChargesRemaining(RuneOfPower) = SpellCharges(RuneOfPower) and (canUseItem(GlacialSpike) or not HasTalent(GlacialSpike))
                if charges.runeOfPower.count() == 2 and (canCast(199786,false,true) or not talent.glacialSpike) then
                    if cast.runeOfPower() then return end
                end
        -- Cooldowns Spell RuneOfPower if BuffRemainingSec(Bloodlust) > BuffDurationSec(RuneOfPower) + SpellCastTimeSec(RuneOfPower) or BuffRemainingSec(TimeWarp) > BuffDurationSec(RuneOfPower) + SpellCastTimeSec(RuneOfPower)
                if hasBloodLust() or buff.timeWarp.remain() > 10 + getCastTime(spell.runeOfPower) then
                  if cast.runeOfPower() then return end
                end
                -- Cooldowns Spell RuneOfPower if FightSecRemaining < BuffDurationSec(RuneOfPower) + SpellCastTimeSec(RuneOfPower) + SpellCastTimeSec(GlacialSpike)
                -- Frost Mage CDs ----------------------------------------
            end -- End useCDs check
        end -- End Action List - Cooldowns
        local function actionList_AOE()
          -- Ice lance if capped
              if buff.fingersOfFrost.stack() > (2 + iceHand) then
                  if cast.iceLance() then return end
              end
          -- Blizzard AOE
              if ((#enemies.yards8t >= 4 and mode.rotation == 1) or mode.rotation == 2) then
                  -- Print("AOE stance")
                  cast.blizzard("target")
                  local X,Y,Z = ObjectPosition("target")
                  -- print("x /y/z  " .. X ..":".. Y ..":".. Z)
                  ClickPosition(X,Y,Z)
              end
          -- Pet Freeze #enemies > 2
              if ((#enemies.yards8t >= 2 and mode.rotation == 1) or mode.rotation == 2) and buff.fingersOfFrost.stack() <= (2+iceHand)-2 then
                  -- Print("AOE stance")
                  CastPetAction(4,"target")
                  local X,Y,Z = ObjectPosition("target")
                  -- print("x /y/z  " .. X ..":".. Y ..":".. Z)
                  ClickPosition(X,Y,Z)
              end
          -- Frozen Orb
              -- Cast frozen_orb on Cd
              if cast.frozenOrb() then return end
          -- Frost Bomb  if Frost bomb is down
              if not debuff.frostBomb.exists(units.dyn40) and buff.fingersOfFrost.stack() >= 2 then
                  -- Print("Frost Bomb is down")
                  cast.frostBomb()
              end
          -- If Frost Bomb is up Dump Ice lances
              if debuff.frostBomb.exists(units.dyn40) and buff.fingersOfFrost.exists() then
                  if cast.iceLance() then return end
              end
          -- Frozen Orb
              -- Cast frozen_orb on Cd
              if cast.frozenOrb() then return end


        end
        local function actionList_Moving()
          if isMoving("player") and buff.fingersOfFrost.exists() then
              cast.iceLance()
          end
          if not buff.iceFloes.exists() and isMoving("player") then
              cast.iceFloes()
          return end
          --Flurry (AMR)
          -- Spell Flurry if HasBuff(BrainFreeze) and ((not HasBuff(FingersOfFrost) and not HasTalent(GlacialSpike)) or (HasTalent(GlacialSpike) and WasLastCast(Frostbolt)))
          if  isMoving("player") and buff.brainFreeze.exists() and ((not buff.fingersOfFrost.exists() and not talent.glacialSpike) or (talent.glacialSpike and lastSpellCast == spell.frostbolt)) then
              if cast.flurry() then
                  if lastSpellCast == spell.flurry then
                      flurryCount = flurryCount + 1
                      if debug == true then Print(dt .. "|cff00ccff|  " .. "|cffFFFFFF " .. " Casting Flurry  " .. "   #:  ".. flurryCount) end
                  end
               end
           end
           -- Ice Lance + Flurry (AMR)
          if  isMoving("player") and not buff.fingersOfFrost.exists() and lastSpellCast == spell.flurry and not talent.glacialSpike and castable.iceLance then
           -- If we just Flurried Cast Ice Lance for winters_chill
              ilfCount = ilfCount + 1
              icelanceCount = icelanceCount + 1
              if cast.iceLance() then
                  if debug == true then Print(dt .. "|cff00ccff|  " .. "|cffFFFFFF " .. " Casting Ice Lance after Flurry" .. "   #:  ".. ilfCount) return end
               end
           end
           if isMoving("player") and not buff.fingersOfFrost.exists() and not buff.iceBarrier.exists() then
               cast.iceBarrier()
           end

        end
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
            -- Clear Spell Stats
              -- Clear spell stats out of combat
              clearStats()

            -- Flask
                -- flask,type=flask_of_the_whispered_pact
                -- TODO
            -- Food
                -- food,type=azshari_salad
            -- Augmentation
                -- augmentation,type=defiled
            -- Water Elemental
                -- water_elemental
                if not hasPet and not talent.lonelyWinter then
                --  print("We have no Out of Combat pet ")
                  CastSpellByName("Summon Water Elemental", "")
                --  if cast.summonPet("notarget") then end
                end
                if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

                end -- End Pre-Pull
                if isValidUnit("target") and getDistance("target") < 40 then
            -- Mirror Image
                    -- mirror_image
                    if isChecked("Mirror Image") then
                        if cast.mirrorImage() then return end
                    end
            -- Potion
                    -- potion,name=deadly_grace
                    -- TODO
            -- Frostbolt
                    -- frostbolt
                    if br.timer:useTimer("delayFB", getCastTime(spell.frostbolt)+0.5) then
                        if cast.frostbolt("target") then return end
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
            if actionList_PreCombat() then
                if not hasPet and not talent.lonelyWinter then
                -- print("we have no pet ")
                CastSpellByName("Summon Water Elemental", "")
                end
            end
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and profileStop==false and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 then
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end

    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
            if getOptionValue("APL Mode") == 1 then
            -- Ice Lance
                    -- ice_lance,if=buff.fingers_of_frost.react=0&prev_gcd.flurry
                    if not buff.fingersOfFrost.exists() and lastSpell == spell.flurry then
                        if cast.iceLance() then return end
                    end
            -- Cooldowns
                    -- call_action_list,name=cooldown
                    if actionList_CooldownsAMR() then return end
            -- Ice Nova w/ winterchill (SimC)
                    -- ice_nova,if=debuff.winters_chill.up
                    if UnitDebuffID("target",228358) then -- Winter Chill Call
                        if cast.iceNova() then return end
                    end
            -- Frostbolt
                    -- frostbolt,if=prev_off_gcd.water_jet
                    if lastSpell == spell.waterJet then
                        if cast.frostbolt() then return end
                    end
            -- Water Jet
                    -- water_jet,if=prev_gcd.frostbolt&buff.fingers_of_frost.stack()<(2+artifact.icy_hand.enabled().enabled)&buff.brain_freeze.react=0
                    if lastSpell == spell.frostbolt and buff.fingersOfFrost.stack() < (2 + iceHand) and not buff.brainFreeze.exists() then
                        if cast.waterJet() then return end
                    end
            -- Ray of Frost
                    -- ray_of_frost,if=buff.icy_veins.up|(cooldown.icy_veins.remain()s>action.ray_of_frost.cooldown&buff.rune_of_power.down)
                    if buff.icyVeins.exists() or (cd.icyVeins.remain() > getCastTime(spell.rayOfFrost) and not buff.runeOfPower) then
                        if cast.rayOfFrost() then return end
                    end
            -- Flurry
                    -- flurry,if=buff.brain_freeze.react&buff.fingers_of_frost.react=0&prev_gcd.frostbolt
                    if buff.brainFreeze.exists() and not buff.fingersOfFrost.exists() and lastSpell == spell.frostbolt then
                        if cast.flurry() then return end
                    end
            -- Frozen Touch (SimC)
                    -- SimC: frozen_touch,if=buff.fingers_of_frost.stack()<=(0+artifact.icy_hand.enabled().enabled)&((cooldown.icy_veins.remain()s>30&talent.thermal_void.enabled)|!talent.thermal_void.enabled)
                    if buff.fingersOfFrost.stack() <= (0 + iceHand) and ((cd.icyVeins.remain() > 30 and talent.thermalVoid) or not talent.thermalVoid) then
                        if cast.frozenTouch() then return end
                    end
            -- Frost Bomb
                    -- frost_bomb,if=debuff.frost_bomb.remain()s<action.ice_lance.travel_time&buff.fingers_of_frost.react>0
                    if debuff.frostBomb.remain(units.dyn40) < gcd and not buff.fingersOfFrost.exists() then
                        if cast.frostBomb() then return end
                    end
            -- Ice Lance
                    -- ice_lance,if=buff.fingers_of_frost.react>0&cooldown.icy_veins.remain()s>10|buff.fingers_of_frost.react>2
                    if buff.fingersOfFrost.exists() and (cd.icyVeins.remain() > 10 or buff.fingersOfFrost.stack() > 2) then
                        if cast.iceLance() then return end
                    end
            -- Frozen Orb
                    -- frozen_orb
                    if cast.frozenOrb() then return end
            -- Ice Nova
                    -- ice_nova
                    if cast.iceNova() then return end
            -- Comet Storm
                    -- comet_storm
                    if cast.cometStorm() then return end
            -- Blizzard
                    -- blizzard,if=talent.arctic_gale.enabled|active_enemies>1|((buff.zannesu_journey.stack()>4|buff.zannesu_journey.remain()s<cast_time+1)&equipped.133970)
                    if talent.arcticGale or #enemies.yards8t > 1 or ((buff.zannesuJourney.stack() > 4 or buff.zannesuJourney.remain() < getCastTime(spell.blizzard) + 1) and hasEquiped(133970)) then
                        if cast.blizzard("best",nil,1,8) then return end
                    end
            -- Ebonbolt
                    -- ebonbolt,if=buff.fingers_of_frost.stack()<=(0+artifact.icy_hand.enabled().enabled)
                    if buff.fingersOfFrost.stack() <= (0 + iceHand) then
                        if cast.ebonbolt() then return end
                    end
            -- Glacial Spike
                    -- glacial_spike
                    if cast.glacialSpike() then return end
            -- Frostbolt
                    -- frostbolt
                    if cast.frostbolt() then return end
            end -- End SimC APL
  ----------------------
  --- Start AMR APL ---
  ----------------------
              if getOptionValue("APL Mode") == 2 then
              end
    ----------------------
    --- Start DBT APL ---
    ----------------------
    -------   TODO   -------
    -- Pet Freeze with 2 targets Rootable
    -- Change Frost Bombs to AMR logic
    -- AOE roation
    -- Formal CD rotation
    -- personalized Prints for all Spells
    -- Rotation counts and Passed metrics
    -------------------------
            if getOptionValue("APL Mode") == 3 then

            -- Pet Attack
                if not UnitIsUnit("pettarget","target") then
                       PetAttack()
                end
            -- Movement Logic
                if isMoving("player") then
                  Print("on the move ! ")
                  if actionList_Moving() then return end
                end
    -------------- AOE Start -------------------------
    -- AOE
                if ((#enemies.yards8t >= 2 and mode.rotation == 1) or mode.rotation == 2) then
                    if actionList_AOE() then return end
                end
    -------------- AOE End -------------------------

            -- Ice Lance + Flurry (AMR)
                if not buff.fingersOfFrost.exists() and lastSpellCast == spell.flurry and not talent.glacialSpike and castable.iceLance then
                    -- If we just Flurried Cast Ice Lance for winters_chill
                    ilfCount = ilfCount + 1
                    icelanceCount = icelanceCount + 1
                    if cast.iceLance() then
                      if debug == true then Print(dt .. "|cff00ccff|  " .. "|cffFFFFFF " .. " Casting Ice Lance after Flurry" .. "   #:  ".. ilfCount) return end
                    end
                end
      -------------- CD'S Start -------------------------
      -- Cooldowns
              -- call_action_list,name=cooldown
              if actionList_CooldownsAMR() then return end
     -------------- CD'S END -------------------------
            -- Frost bolt w/ Water Jet (AMR)
                    -- Frostbolt if IsPetCasting(PetWaterElemental, WaterJet)
                    if UnitChannelInfo("Pet") and not talent.lonelyWinter then
                        if debug == true then Print("Casting Frostbolt because water jet is chanelling") end
                        if castable.frostbolt then
                          wjfrostCount = wjfrostCount + 1
                          frostboltCount = frostboltCount + 1
                          if cast.frostbolt() then
                            if debug == true then Print(dt .. "|cff00ccff|  " .. "|cffFFFFFF " .. " Casting Frostbolt during WaterJet" .. "   #:  ".. wjfrostCount) end
                          end
                        return;
                      end
                    end
             -- Water Jet (AMR)
                    -- water_jet,if=prev_gcd.frostbolt&buff.fingers_of_frost.stack()<(2+artifact.icy_hand.enabled().enabled)&buff.brain_freeze.react=0
                    -- WaterJet if BuffStack(FingersOfFrost) < BuffMaxStack(FingersOfFrost) and WasLastCast(Frostbolt) and not HasBuff(BrainFreeze) and not HasTalent(GlacialSpike)
                    if not talent.lonelyWinter and buff.fingersOfFrost.stack() < (2 + iceHand) and lastSpellCast == spell.frostbolt and not buff.brainFreeze.exists() and not talent.glacialSpike then
                        if CastPetAction(6,"target") then return end
                            if UnitChannelInfo("Pet") then
                                wjCount = wjCount + 1
                              if debug == true then Print(dt .. "|cff00ccff|  " .. "|cffFFFFFF " .. " Casting WaterJet" .. "   #:  ".. wjCount) end
                            end
                    end
             -- Ray of Frost (AMR)
                    -- ray_of_frost,if=buff.icy_veins.up|(cooldown.icy_veins.remain()s>action.ray_of_frost.cooldown&buff.rune_of_power.down)
                    -- if buff.icyVeins.exists() or (cd.icyVeins.remain() > getCastTime(spell.rayOfFrost) and buff.runeOfPower.exists()) then
                    -- RayOfFrost if HasBuff(IcyVeins)
                    if buff.icyVeins.exists() then
                        if cast.rayOfFrost() then return end
                    end
             -- Glacial Spike (AMR)
                    -- GlacialSpike
                    if castable.glacialSpike then
                      if cast.glacialSpike() then Print("Casted Glacial Spike") return end
                    end
             --Flurry (AMR)
                    -- Spell Flurry if HasBuff(BrainFreeze) and ((not HasBuff(FingersOfFrost) and not HasTalent(GlacialSpike)) or (HasTalent(GlacialSpike) and WasLastCast(Frostbolt)))
                    if buff.brainFreeze.exists() and ((not buff.fingersOfFrost.exists() and not talent.glacialSpike) or (talent.glacialSpike and lastSpellCast == spell.frostbolt)) then
                        if cast.flurry() then
                          if lastSpellCast == spell.flurry then
                            flurryCount = flurryCount + 1
                            if debug == true then Print(dt .. "|cff00ccff|  " .. "|cffFFFFFF " .. " Casting Flurry  " .. "   #:  ".. flurryCount) end
                          end
                        end
                    end
            -- Frost Bomb
                    -- Frost bomb, if Frost bomb is not up on the target. and we have 2 fingersOfFrost
                    --frost_bomb,if=debuff.frost_bomb.remain()s<action.ice_lance.travel_time&buff.fingers_of_frost.react>0
                    -- AMR?
                    if talent.frostBomb then
                        if UnitDebuffID("target",112948) then
                            -- print("Frost Bomb is on target")
                        elseif not UnitDebuffID("target",112948) and lastSpellCast ~= spell.frostBomb then
                            --print("NO Frost Bomb")
                            if buff.fingersOfFrost.stack() >= 2 or (cd.frozenOrb.remain() < 1 or cd.frozenTouch.remain() < 2 or cd.ebonbolt.remain() < 2) then
                            -- print("2 FoF -> frostBomb")
                            cast.frostBomb()
                            end
                        end
                    end

            -- Ice Lance NO GS (AMR)
                    -- ice_lance,if=buff.fingers_of_frost.react>0&cooldown.icy_veins.remain()s>10|buff.fingers_of_frost.react>2
                    -- IceLance if ((HasBuff(FingersOfFrost) and CooldownSecRemaining(IcyVeins) > 10) or BuffStack(FingersOfFrost) = BuffMaxStack(FingersOfFrost)) and not HasTalent(GlacialSpike)
                    if (buff.fingersOfFrost.exists() and cd.icyVeins.remain() > 10) or (buff.fingersOfFrost.stack() == (2 + iceHand) and not talent.glacialSpike) then
                        if cast.iceLance() then
                          if lastSpellCast == spell.iceLance then
                            icelanceCount = icelanceCount + 1
                            if debug == true then Print(dt .. "|cff00ccff|  " .. "|cffFFFFFF " .. " Casting Ice Lance " .. "   #:  ".. icelanceCount) end
                          end
                        end
                    return end
            -- Ice Lance w/ GS (AMR)
                    -- ice_lance,if=buff.fingers_of_frost.react>0&cooldown.icy_veins.remain()s>10|buff.fingers_of_frost.react>2
                    -- IceLance if HasTalent(GlacialSpike) and HasBuff(FingersOfFrost) and BuffStack(ChainReaction) = BuffMaxStack(ChainReaction)
                    if talent.glacialSpike and buff.fingersOfFrost.exists() and (buff.chainReaction == 3) then
                        if cast.iceLance() then return end
                    end
            -- Frozen Orb
                    -- Cast frozen_orb on Cd
                    if cast.frozenOrb() then return end
            --Ice Nova (AMR)
                    -- ice_nova
                    if cast.iceNova() then return end
            --Comet Storm (AMR)
                    -- comet_storm
                    if cast.cometStorm() then return end
            -- Ebonbolt (AMR)
                    -- Ebonbolt if BuffStack(FingersOfFrost) < BuffMaxStack(FingersOfFrost) - 2 and not HasTalent(GlacialSpike)
                    if (buff.fingersOfFrost.stack()) <= (2+iceHand)-2 and not talent.glacialSpike then
                        if cast.ebonbolt() then return end
                    end
            -- Frostbolt
                    -- frostbolt
                    if cast.frostbolt() then
                      frostboltCount = frostboltCount + 1
                      if debug == true then Print(dt .. "|cff00ccff|  " .. "|cffFFFFFF " .. " Casting Frost Bolt" .. "   #:  ".. frostboltCount) end
                      return end
              end -- End DBT APL
   ----------------------
   --- Start Testing APL ---
   ----------------------

                if getOptionValue("APL Mode") == 4 then
            -- Test Ground for Casts
                    --if CastSpellByName("Frostbolt") then return end
                  if isMoving("player") then
                    Print("on the move ! ")
                    if actionList_Moving() then return end
                  end
                  -- Frostbolt
                          -- frostbolt
                          if cast.frostbolt() then return end


                end -- End Testing APL
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
