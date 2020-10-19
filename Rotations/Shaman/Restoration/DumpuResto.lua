local rotationName = "DumpyResto" -- Change to name of profile listed in options drop down


----------------------------------------------------
-- Credit to Aura for this rotation's base.
----------------------------------------------------

---------------
-- Credit to:
---------------
--[[

Kink for some of his targeting Logic

Aura for some of the healing logic as well

--]]

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 0, icon = br.player.spell.whirlwind },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladestorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.furiousSlash },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.battleCry },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.battleCry },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.battleCry }
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
          br.ui:createCheckbox(section, "Auto Ghost Wolf", "|cff0070deAuto GW OOC.")
          br.ui:createCheckbox(section, "OOC Healing", "|cff0070deOOC Healing.")
          br.ui:createCheckbox(section, "Water Shield", "|cff0070deKeep Water Shield Up.")

        br.ui:checkSectionState(section)


        ------------------------
        --- HEALING OPTIONS --- --
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Healing")
          br.ui:createSpinner(section,  "Riptide",  90,  0,  100,  5,  "|cffFFBB00% to cast")
          br.ui:createDropdown(section, "Upkeep Riptide", {"|cffFFFFFFTarget",	"|cffFFFFFFTank", "|cffFFFFFFPlayer"}, 1, "|cffFFFFFFTarget to cast on")
          br.ui:createSpinner(section, "Healing Wave",  70,  0,  100,  5,  "|cffFFFFFF% to Cast At")
          br.ui:createCheckbox(section, "HW Buff", "|cff0070deOnly use Healing Wave with Tidal Waves or Undulation.")
          br.ui:createSpinner(section, "Healing Surge",  55,  0,  100,  5,  "|cffFFFFFF% to Cast At")

          br.ui:createSpinner(section, "Chain Heal",  70,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
          br.ui:createSpinnerWithout(section, "Chain Heal Targets",  3,  0,  40,  1,  "Minimum Chain Heal Targets")

          br.ui:createDropdown(section, "Upkeep Earth Shield", {"|cffFFFFFFTarget",	"|cffFFFFFFTank"}, 1, "|cffFFFFFFTarget to cast on")

        br.ui:checkSectionState(section)


        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")

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
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
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
    if br.timer:useTimer("debugFury", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
        --Print("Running: "..rotationName)
        buff                                          = br.player.buff
        cast                                          = br.player.cast
        cd                                            = br.player.cd
        debuff                                        = br.player.debuff
        enemies                                       = br.player.enemies
        essence                                       = br.player.essence
        equiped                                       = br.player.equiped
        gcd                                           = br.player.gcd
        gcdMax                                        = br.player.gcdMax
        has                                           = br.player.has
        inCombat                                      = br.player.inCombat
        item                                          = br.player.items
        level                                         = br.player.level
        mode                                          = br.player.ui.mode
        moving                                        = GetUnitSpeed("player") > 0
        ui                                            = br.player.ui
        pet                                           = br.player.pet
        php                                           = br.player.health
        pullTimer                                     = br.DBM:getPulltimer()
        spell                                         = br.player.spell
        talent                                        = br.player.talent
        traits                                        = br.player.traits
        tanks                                         = getTanksTable()
        units                                         = br.player.units
        use                                           = br.player.use
        inInstance                                    = br.player.unit.instance() == "party"
        inRaid                                        = br.player.unit.instance() == "raid"

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
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.ui.mode
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power, br.player.powerMax, br.player.powerRegen
        local pullTimer                                     = br.DBM:getPulltimer()
        local wolf                                          = br.player.buff.ghostWolf.exists()
        local water                                         = br.player.buff.waterShield.exists()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttm                                           = br.player.timeToMax
        local units                                         = br.player.units

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end


        local lowest = {}
        lowest.unit = "player"
        lowest.hp = 100
        for i = 1, #br.friend do
            if br.friend[i].hp < lowest.hp then
                lowest = br.friend[i]
            end
        end

--------------------
--- Action Lists ---
--------------------





--------------------
--- Water Shield ---
--------------------
        if isChecked("Water Shield") and not buff.waterShield.exists() then
          if cast.waterShield() then br.addonDebug("Upkeep Water Shield") return end
        end


-----------------
--- Rotations ---
-----------------


        -- Pause
        if pause() then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and not IsMounted() and not IsFlying() then
              if isChecked("Auto Ghost Wolf") and not IsMounted() and not IsFlying() and isMoving("player") and not buff.ghostWolf.exists() then
                if cast.ghostWolf() then br.addonDebug("Casting Ghost Wolf") end
              elseif isChecked("Auto Ghost Wolf") and not isMoving("player") and buff.ghostWolf.exists() then
                RunMacroText("/cancelAura Ghost Wolf")
              end


              if isChecked("OOC Healing") and isChecked("Riptide") and not IsMounted() and not IsFlying() then
                for i = 1, #br.friend do
                  if lowest.hp <= getValue("Riptide") and buff.riptide.remain(lowest.unit) < 2.1 then
                    if cast.riptide(lowest.unit) then br.addonDebug("Casting Riptide") return end
                  end
                end
              end


              -- upkeep riptide start
              if isChecked("OOC Healing") and isChecked("Upkeep Riptide") and not IsMounted() and not IsFlying() then
                if getOptionValue("Upkeep Riptide") == 1 and UnitIsPlayer("target") and not buff.riptide.exists("target") then -- Target
                    if cast.riptide("target") then br.addonDebug("Upkeep Riptide Target") return end
                end

                if getOptionValue("Upkeep Riptide") == 2 then -- Tank
                    for i = 1, #tanks do
                        if UnitIsPlayer(tanks[i].unit) and GetUnitIsFriend(tanks[i].unit, "player") and getDistance(tanks[i].unit) <= 40 and not buff.riptide.exists(tanks[i].unit) and not IsMounted() and not IsFlying() then
                            if cast.riptide(tanks[i].unit) then
                                br.addonDebug("Upkeep Riptide Tank")
                                return true
                            end
                        end
                    end
                end


                if getOptionValue("Upkeep Riptide") == 3 then -- Player
                  if not UnitIsDeadOrGhost("player") and not buff.riptide.exists("player") and not IsMounted() and not IsFlying() then
                    if cast.riptide("player") then br.addonDebug("Upkeep Riptide Tank" )return true end
                  end
                end
              end -- end of riptide upkeep

              -- start of ES upkeep
              if isChecked("OOC Healing") and isChecked("Upkeep Earth Shield") and not IsMounted() and not IsFlying() then
                if getOptionValue("Upkeep Earth Shield") == 1 and UnitIsPlayer("target") and not buff.earthShield.exists("target") then -- Target
                    if cast.earthShield("target") then br.addonDebug("Upkeep Earth Shield Target") return end
                end

                if getOptionValue("Upkeep Earth Shield") == 2 then -- Tank
                    for i = 1, #tanks do
                        if UnitIsPlayer(tanks[i].unit) and GetUnitIsFriend(tanks[i].unit, "player") and getDistance(tanks[i].unit) <= 40 and not buff.earthShield.exists(tanks[i].unit) and not IsMounted() and not IsFlying() then
                            if cast.earthShield(tanks[i].unit) then
                                br.addonDebug("Upkeep Earth Shield Tank")
                                return true
                            end
                        end
                    end
                end
              end -- end of ES upkeep




              if isChecked("OOC Healing") and isChecked("Healing Wave") and not isMoving("player") and not isChecked("HW Buff") then
                if lowest.hp <= getValue("Healing Wave") then
                  if cast.healingWave(lowest.unit) then br.addonDebug("Casting Healing Wave") return end
                end
              end

              if isChecked("OOC Healing") and isChecked("Healing Wave") and not isMoving("player") and isChecked("HW Buff") then
                if lowest.hp <= getValue("Healing Wave") and buff.tidalWaves.exists() or lowest.hp <= getValue("Healing Wave") and buff.undulation.exists() then
                  if cast.healingWave(lowest.unit) then br.addonDebug("Casting Healing Wave with buff") return end
                end
              end


              if isChecked("OOC Healing") and isChecked("Healing Surge") and not isMoving("player") then
                if lowest.hp <= getValue("Healing Surge") then
                  if cast.healingSurge(lowest.unit) then br.addonDebug("Casting Healing Surge") return end
                end
              end



              if isChecked("Chain Heal") and not isMoving("player") then
                if chainHealUnits(spell.chainHeal,15,getValue("Chain Heal"),2) then br.addonDebug("Casting Chain Heal") return true end
              end


            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations ---
-----------------------------
            if inCombat and not IsMounted() and not IsFlying() then

              if isChecked("Auto Ghost Wolf") and not IsMounted() and not IsFlying() and isMoving("player") and not buff.ghostWolf.exists() then
                if cast.ghostWolf() then br.addonDebug("Casting Ghost Wolf") end
              elseif isChecked("Auto Ghost Wolf") and not isMoving("player") and buff.ghostWolf.exists() then
                RunMacroText("/cancelAura Ghost Wolf")
              end


              if isChecked("OOC Healing") and isChecked("Riptide") and not IsMounted() and not IsFlying() then
                for i = 1, #br.friend do
                  if lowest.hp <= getValue("Riptide") and buff.riptide.remain(lowest.unit) < 2.1 then
                    if cast.riptide(lowest.unit) then br.addonDebug("Casting Riptide") return end
                  end
                end
              end


              -- upkeep riptide start
              if isChecked("OOC Healing") and isChecked("Upkeep Riptide") and not IsMounted() and not IsFlying() then
                if getOptionValue("Upkeep Riptide") == 1 and UnitIsPlayer("target") and not buff.riptide.exists("target") then -- Target
                    if cast.riptide("target") then br.addonDebug("Upkeep Riptide Target") return end
                end

                if getOptionValue("Upkeep Riptide") == 2 then -- Tank
                    for i = 1, #tanks do
                        if UnitIsPlayer(tanks[i].unit) and GetUnitIsFriend(tanks[i].unit, "player") and getDistance(tanks[i].unit) <= 40 and not buff.riptide.exists(tanks[i].unit) and not IsMounted() and not IsFlying() then
                            if cast.riptide(tanks[i].unit) then
                                br.addonDebug("Upkeep Riptide Tank")
                                return true
                            end
                        end
                    end
                end


                if getOptionValue("Upkeep Riptide") == 3 then -- Player
                  if not UnitIsDeadOrGhost("player") and not buff.riptide.exists("player") and not IsMounted() and not IsFlying() then
                    if cast.riptide("player") then br.addonDebug("Upkeep Riptide Tank" )return true end
                  end
                end
              end -- end of riptide upkeep

              -- start of ES upkeep
              if isChecked("OOC Healing") and isChecked("Upkeep Earth Shield") and not IsMounted() and not IsFlying() then
                if getOptionValue("Upkeep Earth Shield") == 1 and UnitIsPlayer("target") and not buff.earthShield.exists("target") then -- Target
                    if cast.earthShield("target") then br.addonDebug("Upkeep Earth Shield Target") return end
                end

                if getOptionValue("Upkeep Earth Shield") == 2 then -- Tank
                    for i = 1, #tanks do
                        if UnitIsPlayer(tanks[i].unit) and GetUnitIsFriend(tanks[i].unit, "player") and getDistance(tanks[i].unit) <= 40 and not buff.earthShield.exists(tanks[i].unit) and not IsMounted() and not IsFlying() then
                            if cast.earthShield(tanks[i].unit) then
                                br.addonDebug("Upkeep Earth Shield Tank")
                                return true
                            end
                        end
                    end
                end
              end -- end of ES upkeep




              if isChecked("OOC Healing") and isChecked("Healing Wave") and not isMoving("player") and not isChecked("HW Buff") then
                if lowest.hp <= getValue("Healing Wave") then
                  if cast.healingWave(lowest.unit) then br.addonDebug("Casting Healing Wave") return end
                end
              end

              if isChecked("OOC Healing") and isChecked("Healing Wave") and not isMoving("player") and isChecked("HW Buff") then
                if lowest.hp <= getValue("Healing Wave") and buff.tidalWaves.exists() or lowest.hp <= getValue("Healing Wave") and buff.undulation.exists() then
                  if cast.healingWave(lowest.unit) then br.addonDebug("Casting Healing Wave with buff") return end
                end
              end


              if isChecked("OOC Healing") and isChecked("Healing Surge") and not isMoving("player") then
                if lowest.hp <= getValue("Healing Surge") then
                  if cast.healingSurge(lowest.unit) then br.addonDebug("Casting Healing Surge") return end
                end
              end



              if isChecked("Chain Heal") and not isMoving("player") then
                if chainHealUnits(spell.chainHeal,15,getValue("Chain Heal"),2) then br.addonDebug("Casting Chain Heal") return true end
              end



            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation
local id = 264-- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
