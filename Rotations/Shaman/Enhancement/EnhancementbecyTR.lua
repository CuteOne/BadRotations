local rotationName = "becyTR"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.windstrike},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.crashLightning},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.stormstrike},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.healingSurge}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.feralSpirit},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.feralSpirit},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.feralSpirit}
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.astralShift},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.astralShift}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.windShear},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.windShear}
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        local alwaysCdNever = {"|cff00FF00Always","|cffFFFF00Cooldowns","|cffFF0000Never"}
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Ghost Wolf
            br.ui:createDropdownWithout(section,"Ghost Wolf", {"|cff00FF00Always","|cffFFFF00OoC Only","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Ghost Wolf.")
            -- Feral Lunge
            br.ui:createCheckbox(section,"Feral Lunge")
            -- Lightning Bolt OOC
            br.ui:createCheckbox(section,"Lightning Bolt Out of Combat")
            -- Lightning Filler
            br.ui:createCheckbox(section,"Lightning Filler","Select to use LB/CL when all other abilities are on CD and can cast before any available.")
            -- Shields Up
            br.ui:createDropdownWithout(section, "Shields Up", {"Lightning Shield","Earth Shield","No Shields"}, 1, "|cffFFFFFFSet to desired shield to use.")
            -- Spirit Walk
            br.ui:createCheckbox(section,"Spirit Walk")
            -- Water Walking
            br.ui:createCheckbox(section,"Water Walking")
            -- Weapon Imbues
            br.ui:createCheckbox(section,"Windfury Weapon","",1)
            br.ui:createCheckbox(section,"Flametongue Weapon","",1)
            -- Manual Windfury totem
            br.ui:createDropdown(section,"Windfury Totem Key", br.dropOptions.Toggle, 6,"|cff0070deSet key to hold down for Windfury Totem")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Agi Pot
            br.ui:createCheckbox(section,"Potion")
            -- Flask Up Module
            br.player.module.FlaskUp("Agility",section)
            -- Racial
            br.ui:createDropdownWithout(section,"Racial", alwaysCdNever, 1, "|cffFFFFFFWhen to use Racial.")
            -- Basic Trinkets Module
            br.player.module.BasicTrinkets(nil,section)
            -- Ascendance
            br.ui:createDropdownWithout(section,"Ascendance", alwaysCdNever, 1, "|cffFFFFFFWhen to use Ascendance.")
            -- Earth Elemental Totem
            br.ui:createDropdownWithout(section,"Earth Elemental", alwaysCdNever, 1, "|cffFFFFFFWhen to use Earth Elemental.")
            -- Feral Spirit
            br.ui:createDropdownWithout(section,"Feral Spirit", alwaysCdNever, 1, "|cffFFFFFFWhen to use Feral Spirit.")
            -- Stormkeeper
            br.ui:createDropdownWithout(section,"Stormkeeper", alwaysCdNever, 1, "|cffFFFFFFWhen to use Stormkeeper.")
            -- Sundering
            br.ui:createDropdownWithout(section,"Sundering", alwaysCdNever, 1, "|cffFFFFFFWhen to use Sundering.")
            -- Covenant Ability
            br.ui:createDropdownWithout(section,"Covenant Ability", alwaysCdNever, 1, "|cffFFFFFFWhen to use Covenant Ability.")
            -- Chain Harvest Min Units
            br.ui:createSpinnerWithout(section,"Chain Harvest Min Units", 1, 1, 5, 1, "cffFFFFFFMinimal Units in 8yrds to cast at.")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Ancestral Spirit
            br.ui:createDropdown(section, "Ancestral Spirit", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Astral Shift
            br.ui:createSpinner(section, "Astral Shift",  40,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Cleanse Spirit
            br.ui:createDropdown(section, "Cleanse Spirit", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Healing Surge
            br.ui:createSpinner(section, "Healing Surge",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Healing Surge OoC",  90,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Auto/Insta-Heal
            br.ui:createDropdownWithout(section, "Heal Target", { "|cffFFDD11LowestHP", "|cffFFDD11Player"},  2,  "|cffFFFFFFSelect Target to Heal")
            br.ui:createDropdownWithout(section, "Instant Behavior", {"|cff00FF00Always","|cffFFFF00Combat Only","|cffFF0000Never"}, 2, "|cffFFFFFFSelect how to use Instant Heal proc.")
            -- Healing Steam Totem
            br.ui:createSpinner(section, "Healing Stream Totem", 35, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createCheckbox(section, "Use HST While Solo")
            br.ui:createSpinnerWithout(section, "Healing Stream Totem - Min Units", 1, 0, 5, 1, "|cffFFFFFFNumber of Units below HP Level to Cast At")
            -- Lightning Surge Totem
            br.ui:createSpinner(section, "Capacitor Totem - HP", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Capacitor Totem - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
            -- Purge
            br.ui:createCheckbox(section,"Purge","",1)
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Wind Shear
            br.ui:createCheckbox(section,"Wind Shear")
            -- Hex
            br.ui:createCheckbox(section,"Hex")
            -- Lightning Surge Totem
            br.ui:createCheckbox(section,"Capacitor Totem")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
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

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local cd
local covenant
local debuff
local enemies
local module
local runeforge
local talent
local ui
local unit
local units
local var

-- General API Locals
local actionList = {}

local function canLightning(aoe)
    local level = unit.level()
    if not ui.checked("Lightning Filler") or level < 20 or unit.moving() --[[or (buff.maelstromWeapon.stack() > 0 and (spell.known.elementalBlast() or spell.known.stormkeeper()))]] then return false end
    local timeTillLightning = (aoe and level >= 24) and cast.time.chainLightning() or cast.time.lightningBolt()
    local flameShock = cd.flameShock.remain() -- Level 3
    local lavaLash  = cd.lavaLash.remain() -- Level 11
    local elementalBlast = talent.elementalBlast and cd.elementalBlast.remain() or 99 -- Level 15 - Talent
    local frostShock = cd.frostShock.remain() -- Level 17
    local stormstrike = cd.stormstrike.remain() or 99 -- Level 20
    local iceStrike = talent.iceStrike and cd.iceStrike.remain() or 99 -- Level 25 - Talent
    local fireNova = talent.fireNova and cd.fireNova.remain() or 99 -- Level 35 - Talent
    local crashLightning = level >= 38 and cd.crashLightning.remain() or 99 -- Level 38
    local stormkeeper = talent.stormkeeper and cd.stormkeeper.remain() or 99 -- Level 45 - Talent
    local sundering = talent.sundering and cd.sundering.remain() or 99 -- Level 45 - Talent
    local earthenSpike = talent.earthenSpike and cd.earthenSpike.remain() or 99 -- Level 50 - Talent
    return math.min(flameShock,lavaLash,elementalBlast,frostShock,stormstrike,iceStrike,fireNova,crashLightning,stormkeeper,sundering,earthenSpike) > timeTillLightning
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    local startTime = br._G.debugprofilestop()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Ghost Wolf
    if (ui.value("Ghost Wolf") == 1 or (ui.value("Ghost Wolf") == 2 and not unit.inCombat())) and cast.able.ghostWolf() and not (unit.mounted() or unit.flying()) then
        if ((#enemies.yards20 == 0 and not unit.inCombat()) or (#enemies.yards10 == 0 and unit.inCombat())) and unit.moving("player") and not buff.ghostWolf.exists() then
            if cast.ghostWolf() then ui.debug("Casting Ghost Wolf") return true end
        end
    end
    -- Purge
    if ui.checked("Purge") and cast.able.purge() and cast.dispel.purge("target") and not unit.isBoss() and unit.exists("target") then
        if cast.purge() then ui.debug("Casting Purge") return true end
    end
    -- Spirit Walk
    if ui.checked("Spirit Walk") and cast.able.spiritWalk() and cast.noControl.spiritWalk() then
        if cast.spiritWalk() then ui.debug("Casting Spirit Walk") return true end
    end
    -- Water Walking
    if unit.fallTime() > 1.5 and buff.waterWalking.exists() then
        if buff.waterWalking.cancel() then ui.debug("Canceled Water Walking [Falling]") return true end
    end
    if ui.checked("Water Walking") and cast.able.waterWalking() and not unit.inCombat() and unit.swimming() and not buff.waterWalking.exists() then
        if cast.waterWalking() then ui.debug("Casting Water Walking") return true end
    end
    -- windfury_weapon
    if ui.checked("Windfury Weapon") and cast.able.windfuryWeapon() and not unit.weaponImbue.exists(5401) then
        if cast.windfuryWeapon("player") then ui.debug("Casting Windfury Weapon [Main Hand]") return true end
    end
    -- Flametongue Weapon
    -- flametongue_weapon
    if ui.checked("Flametongue Weapon") and cast.able.flametongueWeapon() and unit.dualWielding() and not unit.weaponImbue.exists(5400,true) then
        if cast.flametongueWeapon("player") then ui.debug("Casting Flametongue Weapon [Off Hand]") return true end
    end
    -- lightning_shield
    if (ui.value("Shields Up") == 1 or (ui.value("Shields Up") == 2 and not talent.earthShield)) and cast.able.lightningShield() and not buff.lightningShield.exists() then
        if cast.lightningShield("player") then ui.debug("Casting Lightning Shield") return true end
    end
    br.debug.cpu:updateDebug(startTime,"rotation.profile.extras")
end -- End Action List - Extras
-- Action List - Defensive
actionList.Defensive = function()
    local startTime = br._G.debugprofilestop()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Ancestral Spirit
        if ui.checked("Ancestral Spirit") and cast.timeSinceLast.ancestralSpirit() > 5 then
            if ui.value("Ancestral Spirit")==1 and cast.able.ancestralSpirit("target","dead") and unit.player("target") then
                if cast.ancestralSpirit("target","dead") then ui.debug("Casting Ancestral Spirit [Target]") return true end
            end
            if ui.value("Ancestral Spirit")==2 and cast.able.ancestralSpirit("mouseover","dead") and unit.player("mouseover") then
                if cast.ancestralSpirit("mouseover","dead") then ui.debug("Casting Ancestral Spirit [Mouseover]") return true end
            end
        end
        -- Astral Shift
        if ui.checked("Astral Shift") and cast.able.astralShift() and unit.hp() <= ui.value("Astral Shift") and unit.inCombat() then
            if cast.astralShift() then ui.debug("Casting Astral Shift") return true end
        end
        -- Capacitor Totem
        if ui.checked("Capacitor Totem - HP") and cast.able.capacitorTotem("player","ground") and cd.capacitorTotem.ready()
            and unit.hp() <= ui.value("Capacitor Totem - HP") and unit.inCombat() and #enemies.yards5 > 0
        then
            if cast.capacitorTotem("player","ground") then ui.debug("Casting Capacitor Totem [Low HP]") return true end
        end
        if ui.checked("Capacitor Totem - AoE") and cast.able.capacitorTotem("best",nil,ui.value("Capacitor Totem - AoE"),8) and cd.capacitorTotem.ready()
            and #enemies.yards5 >= ui.value("Capacitor Totem - AoE") and unit.inCombat()
        then
            if cast.capacitorTotem("best",nil,ui.value("Capacitor Totem - AoE"),8) then ui.debug("Casting Capacitor Totem [AOE]") return true end
        end
        -- Cleanse Spirit
        if ui.checked("Cleanse Spirit") then
            if ui.value("Cleanse Spirit")==1 and cast.able.cleanseSpirit("player") and cast.dispel.cleanseSpirit("player") then
                if cast.cleanseSpirit("player") then ui.debug("Casting Cleanse Spirit [Player]") return true end
            end
            if ui.value("Cleanse Spirit")==2 and cast.able.cleanseSpirit("target") and cast.dispel.cleanseSpirit("target") then
                if cast.cleanseSpirit("target") then ui.debug("Casting Cleanse Spirit [Target]") return true end
            end
            if ui.value("Cleanse Spirit")==3 and cast.able.cleanseSpirit("mouseover") and cast.dispel.cleanseSpirit("mouseover") then
                if cast.cleanseSpirit("mouseover") then ui.debug("Casting Cleanse Spirit [Mouseover]") return true end
            end
        end
        -- Earth Shield
        if talent.earthShield and ui.value("Shields Up") == 2 and cast.able.earthShield() and not buff.earthShield.exists() then
            if cast.earthShield("player") then ui.debug("Casting Earth Shield") return true end
        end
        -- Healing Surge
        if ui.checked("Healing Surge") and cast.able.healingSurge(var.healUnit) and not (unit.mounted() or unit.flying())
            and (ui.value("Heal Target") ~= 1 or (ui.value("Heal Target") == 1
            and unit.distance(br.friend[1].unit) < 40)) and not cast.current.healingSurge()
        then
            if not unit.inCombat() then
                -- Lowest Party/Raid or Player
                if (var.healHP <= ui.value("Healing Surge OoC") and not unit.moving())
                    and (buff.maelstromWeapon.stack() == 0 or ui.value("Instant Behavior") == 1)
                then
                    if cast.healingSurge(var.healUnit) then ui.debug("Casting Healing Surge [OoC] on "..unit.name(var.healUnit)) return true end
                end
            elseif unit.inCombat() and (not unit.moving() or buff.maelstromWeapon.stack() >= 5) then
                -- Lowest Party/Raid or Player
                if var.healHP <= ui.value("Healing Surge") then
                    if ui.value("Instant Behavior") == 1 or (ui.value("Instant Behavior") == 2 and buff.maelstromWeapon.stack() >= 5) or (ui.value("Instant Behavior") == 3 and buff.maelstromWeapon.stack() == 0) then
                        if buff.maelstromWeapon.stack() >= 5 then
                            if cast.healingSurge(var.healUnit) then ui.debug("Casting Healing Surge [IC Instant] on "..unit.name(var.healUnit)) return true end
                        else
                            if cast.healingSurge(var.healUnitUnit) then ui.debug("Casting Healing Surge [IC Long] on "..unit.name(var.healUnit)) return true end
                        end
                    end
                end
            end
        end
        -- Healing Stream Totem
        if ui.checked("Healing Stream Totem") and cast.able.healingStreamTotem("player","ground")
            and var.unitsNeedingHealing >= ui.value("Healing Stream Totem - Min Units")
        then
            if cast.healingStreamTotem("player","ground") then ui.debug("Casting Healing Stream Totem") return true end
        end
    end -- End Defensive Toggle
    br.debug.cpu:updateDebug(startTime,"rotation.profile.defensive")
end -- End Action List - Defensive
-- Action List - Interrupts
actionList.Interrupts = function()
    local startTime = br._G.debugprofilestop()
    if ui.useInterrupt() then
        for i=1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                -- Wind Shear
                -- wind_shear
                if ui.checked("Wind Shear") and cast.able.windShear(thisUnit) then
                    if cast.windShear(thisUnit) then ui.debug("Casting Wind Sheer") return true end
                end
                -- Hex
                if ui.checked("Hex") and cast.able.hex(thisUnit) and (unit.humanoid(thisUnit) or unit.beast(thisUnit)) then
                    if cast.hex(thisUnit) then ui.debug("Casting Hex") return true end
                end
                -- Capacitor Totem
                if ui.checked("Capacitor Totem") and cast.able.capacitorTotem(thisUnit,"ground")
                    and cd.capacitorTotem.ready() and cd.windShear.remain() > unit.gcd(true)
                then
                    if unit.threat(thisUnit) and not unit.moving(thisUnit) and unit.ttd(thisUnit) > 7 then
                        if cast.capacitorTotem(thisUnit,"ground") then ui.debug("Casting Capacitor Totem [Interrupt]") return true end
                    end
                end
            end
        end
    end -- End useInterrupts check
    br.debug.cpu:updateDebug(startTime,"rotation.profile.interrupts")
end -- End Action List - Interrupts
-- Action List - AOE
actionList.AOE = function()
    local startTime = br._G.debugprofilestop()
    -- actions.aoe=chain_harvest,if=buff.maelstrom_weapon.stack>=5
    if ui.alwaysCdNever("Covenant Ability") and (unit.isBoss() or #enemies.yards8 >= ui.value("Chain Harvest Min Units")) and cast.able.chainHarvest() and buff.maelstromWeapon.stack() >= 5 then
        ui.debug("AOE1")
        cast.chainHarvest() 
    end
    -- actions.aoe+=/crash_lightning,if=runeforge.doom_winds.equipped&buff.doom_winds.up
    if #enemies.yards8c > 0 and cast.able.crashLightning("player","cone",1,8) and runeforge.doomWinds.equiped and buff.doomWinds.exists() then
        ui.debug("AOE2")
        cast.crashLightning("player","cone",1,8)
    end
    -- actions.aoe+=/sundering,if=runeforge.doom_winds.equipped&buff.doom_winds.up
    if ui.alwaysCdNever("Sundering") and #enemies.yards11r > 0 and cast.able.sundering("player","rect") then
        ui.debug("AOE3")
        cast.sundering("player","rect",1,11)
    end
    -- actions.aoe+=/healing_stream_totem,if=runeforge.raging_vesper_vortex.equipped&talent.earth_shield.enabled&vesper_totem_heal_charges>0
    
    -- actions.aoe+=/earth_shield,if=runeforge.raging_vesper_vortex.equipped&talent.earth_shield.enabled&vesper_totem_heal_charges>0
    
    -- actions.aoe+=/fire_nova,if=active_dot.flame_shock>=6|(active_dot.flame_shock>=4&active_dot.flame_shock=active_enemies)
    if cast.able.fireNova("player","aoe",1,8) and (debuff.flameShock.count() >= 6 or debuff.flameShock.count() >= 4 and debuff.flameShock.count() == #enemies.yards40f) then
        ui.debug("AOE4")
        cast.fireNova("player","aoe",1,8)
    end
    -- actions.aoe+=/primordial_wave,target_if=min:dot.flame_shock.remains,cycle_targets=1,if=!buff.primordial_wave.up
    if ui.alwaysCdNever("Covenant Ability") and not buff.primordialWave.exists() then
        if not debuff.flameShock.exists() and cast.able.primordialWave() then
        ui.debug("AOE5-1")
        cast.primordialWave()
        elseif cast.able.primordialWave(var.lowestFlameShock) then
        ui.debug("AOE5-2")           
        cast.primordialWave(var.lowestFlameShock)
        end        
    end
    -- actions.aoe+=/windstrike,if=runeforge.deeply_rooted_elements.equipped&buff.crash_lightning.up
    if cast.able.windstrike() and buff.ascendance.exists() and runeforge.deeplyRootedElements.equiped and buff.crashLightning.exists() then
        ui.debug("AOE6")
        cast.windstrike()
    end 
    -- actions.aoe+=/stormstrike,if=runeforge.deeply_rooted_elements.equipped&buff.crash_lightning.up
    if cast.able.stormstrike() and runeforge.deeplyRootedElements.equiped and buff.crashLightning.exists() then
        ui.debug("AOE7")
        cast.stormstrike()
    end
    -- actions.aoe+=/lava_lash,target_if=min:debuff.lashing_flames.remains,cycle_targets=1,if=dot.flame_shock.ticking&(active_dot.flame_shock<active_enemies&active_dot.flame_shock<6)
    if cast.able.lavaLash() and debuff.flameShock.exists() and (debuff.flameShock.count() < #enemies.yards40f and debuff.flameShock.count() < 6) then
        ui.debug("AOE8-1")
        cast.lavaLash()    
    elseif cast.able.lavaLash(var.lowestLashingFlames) and debuff.flameShock.exists(var.lowestLashingFlames) and (debuff.flameShock.count() < #enemies.yards40f and debuff.flameShock.count() < 6) then
        ui.debug("AOE8-2")
        cast.lavaLash(var.lowestLashingFlames)
    end    
    -- actions.aoe+=/flame_shock,if=!ticking
    if cast.able.flameShock() and not debuff.flameShock.exists(enemies.yards40) then
        ui.debug("AOE9")
        cast.flameShock()
    end
    -- actions.aoe+=/flame_shock,target_if=min:dot.flame_shock.remains,cycle_targets=1,if=!talent.hailstorm.enabled&active_dot.flame_shock<active_enemies&active_dot.flame_shock<6
    if cast.able.flameShock() and not talent.hailstorm and not debuff.flameShock.exists() and (debuff.flameShock.count() < #enemies.yards40f and debuff.flameShock.count() < 6) then
        ui.debug("AOE10-1")
        cast.flameShock()
    elseif cast.able.flameShock(var.lowestFlameShock) and not talent.hailstorm and (debuff.flameShock.count() < #enemies.yards40f and debuff.flameShock.count() < 6) then
        ui.debug("AOE10-2")
        cast.flameShock(var.lowestFlameShock)
    end
    -- actions.aoe+=/lightning_bolt,if=(active_dot.flame_shock>=active_enemies|active_dot.flame_shock>=4)&buff.primordial_wave.up&buff.maelstrom_weapon.stack>=5&(!buff.splintered_elements.up|fight_remains<=12|raid_event.adds.remains<=gcd)
    if cast.able.lightningBolt() and (debuff.flameShock.count() >= #enemies.yards40f or debuff.flameShock.count() >= 4) and buff.primordialWave.exists() and buff.maelstromWeapon.stack() >= 5 and not buff.splinteredElements.exists() then
        ui.debug("AOE11")
        cast.lightningBolt()
    end
    -- actions.aoe+=/frost_shock,if=buff.hailstorm.up
    if cast.able.frostShock() and buff.hailstorm.exists() then
        ui.debug("AOE12")
        cast.frostShock()
    end
    -- actions.aoe+=/fae_transfusion,if=soulbind.grove_invigoration|soulbind.field_of_blossoms|runeforge.seeds_of_rampant_growth.equipped
    if ui.alwaysCdNever("Covenant Ability") and cast.able.faeTransfusion("player","ground") and covenant.nightFae.active and not unit.moving("player") then
        ui.debug("AOE13")
        cast.faeTransfusion("player","ground")
    end
    -- actions.aoe+=/crash_lightning,if=buff.crash_lightning.down&buff.primordial_wave.up&buff.maelstrom_weapon.stack<5
    if #enemies.yards8c > 0 and cast.able.crashLightning("player","cone",1,8) and not buff.crashLightning.exists() and buff.primordialWave.exists() and buff.maelstromWeapon.stack() < 5 then
        ui.debug("AOE14")
        cast.crashLightning("player","cone",1,8) 
    end
    -- actions.aoe+=/sundering,if=buff.primordial_wave.up&buff.maelstrom_weapon.stack<5
    if ui.alwaysCdNever("Sundering") and #enemies.yards11r > 0 and cast.able.sundering("player","rect") and buff.primordialWave.exists() and buff.maelstromWeapon.stack() < 5 then
        ui.debug("AOE15")
        cast.sundering("player","rect",1,11)
    end
    -- actions.aoe+=/stormstrike,if=buff.primordial_wave.up&buff.maelstrom_weapon.stack<5
    if cast.able.stormstrike() and buff.primordialWave.exists() and buff.maelstromWeapon.stack() < 5 then
        ui.debug("AOE16")
        cast.stormstrike()
    end
    -- actions.aoe+=/sundering
    if ui.alwaysCdNever("Sundering") and #enemies.yards11r > 0 and cast.able.sundering("player","rect") then
        ui.debug("AOE17")
        cast.sundering("player","rect",1,11)
    end
    -- actions.aoe+=/fire_nova,if=active_dot.flame_shock>=4
    if cast.able.fireNova("player","aoe",1,8) and debuff.flameShock.count() >= 4  then
        ui.debug("AOE18")
        cast.fireNova("player","aoe",1,8)
    end
    -- actions.aoe+=/crash_lightning,if=talent.crashing_storm.enabled|buff.crash_lightning.down
    if #enemies.yards8c > 0 and cast.able.crashLightning("player","cone",1,8) and not buff.crashLightning.exists() then
        ui.debug("AOE19")
        cast.crashLightning("player","cone",1,8) 
    end
    -- actions.aoe+=/lava_lash,target_if=min:debuff.lashing_flames.remains,cycle_targets=1,if=talent.lashing_flames.enabled
    if talent.lashingFlames and cast.able.lavaLash() and not debuff.lashingFlames.exists() then
        ui.debug("AOE20-1")
        cast.lavaLash()
    elseif talent.lashingFlames and cast.able.lavaLash(var.lowestLashingFlames) then
        ui.debug("AOE20-2")
        cast.lavaLash(var.lowestLashingFlames)
    end
    -- actions.aoe+=/fire_nova,if=active_dot.flame_shock>=3
    if cast.able.fireNova("player","aoe",1,8) and debuff.flameShock.count() >= 3  then
        ui.debug("AOE21")
        cast.fireNova("player","aoe",1,8)
    end
    -- actions.aoe+=/vesper_totem
    if ui.alwaysCdNever("Covenant Ability") and cast.able.vesperTotem() then
        ui.debug("AOE22")
        cast.vesperTotem()
    end
    -- actions.aoe+=/chain_lightning,if=buff.stormkeeper.up
    if cast.able.chainLightning() and buff.stormkeeper.exists() then
        ui.debug("AOE23")
        cast.chainLightning()
    end
    -- actions.aoe+=/lava_lash,if=buff.crash_lightning.up
    if cast.able.lavaLash() and buff.crashLightning.exists() then
        ui.debug("AOE24")
        cast.lavaLash()
    end
    -- actions.aoe+=/elemental_blast,if=buff.maelstrom_weapon.stack>=5
    if cast.able.elementalBlast() and buff.maelstromWeapon.stack() >= 5 then
        ui.debug("AOE25")
        cast.elementalBlast()
    end
    -- actions.aoe+=/stormkeeper,if=buff.maelstrom_weapon.stack>=5
    if ui.alwaysCdNever("Stormkeeper") and cast.able.stormkeeper() and buff.maelstromWeapon.stack() >= 5 then
        ui.debug("AOE26")
        cast.stormkeeper()
    end
    -- actions.aoe+=/chain_lightning,if=buff.maelstrom_weapon.stack=10
    if cast.able.chainLightning() and buff.maelstromWeapon.stack() == 10 then
        ui.debug("AOE27")
        cast.chainLightning()
    end
    -- actions.aoe+=/stormstrike,if=buff.crash_lightning.up
    if cast.able.stormstrike() and buff.crashLightning.exists() then
        ui.debug("AOE28")
        cast.stormstrike()
    end
    -- actions.aoe+=/fire_nova,if=active_dot.flame_shock>=2
    if cast.able.fireNova("player","aoe",1,8) and debuff.flameShock.count() >= 2  then
        ui.debug("AOE29")
        cast.fireNova("player","aoe",1,8)
    end
    -- actions.aoe+=/crash_lightning
    if #enemies.yards8c > 0 and cast.able.crashLightning("player","cone",1,8) then
        ui.debug("AOE30")
        cast.crashLightning("player","cone",1,8) 
    end
    -- actions.aoe+=/windstrike
    if cast.able.windstrike() and buff.ascendance.exists() then
        ui.debug("AOE31")
        cast.windstrike()
    end
    -- actions.aoe+=/stormstrike
    if cast.able.stormstrike() then
        ui.debug("AOE32")
        cast.stormstrike() 
    end
    -- actions.aoe+=/fleshcraft,interrupt=1,if=soulbind.volatile_solvent
    
    -- actions.aoe+=/flame_shock,target_if=refreshable,cycle_targets=1
    if cast.able.flameShock() then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            if debuff.flameShock.refresh(thisUnit) then
                ui.debug("AOE33")
                cast.flameShock(thisUnit)
            end
        end
    end
    -- actions.aoe+=/fae_transfusion
    if ui.alwaysCdNever("Covenant Ability") and cast.able.faeTransfusion("player","ground") and not unit.moving("player") then
        ui.debug("AOE34")
        cast.faeTransfusion("player","ground")
    end
    -- actions.aoe+=/frost_shock
    if cast.able.frostShock() then
        ui.debug("AOE35")
        cast.frostShock()
    end
    -- actions.aoe+=/chain_lightning,if=buff.maelstrom_weapon.stack>=5
    if cast.able.chainLightning() and buff.maelstromWeapon.stack() >= 5 then
        ui.debug("AOE36")
        cast.chainLightning()
    end
    -- actions.aoe+=/earthen_spike
    if cast.able.earthenSpike() then
        ui.debug("AOE37")
        cast.earthenSpike()
    end
    -- actions.aoe+=/earth_elemental
    
    -- actions.aoe+=/windfury_totem,if=buff.windfury_totem.remains<30
    if cast.able.windfuryTotem() and not unit.moving() and buff.windfuryTotem.remains("player","any") < 30 and #enemies.yards8 > 0 and not ui.checked("Windfury Totem Key")
        and (not runeforge.doomWinds.equiped or (runeforge.doomWinds.equiped and unit.ttdGroup() > 6))
    then
        ui.debug("AOE38")
        cast.windfuryTotem()
    end

    br.debug.cpu:updateDebug(startTime,"rotation.profile.aoe")
end -- End Action List - AOE
-- Action List - Single
actionList.Single = function()
    local startTime = br._G.debugprofilestop()
    -- actions.single=windstrike
    if cast.able.windstrike() and buff.ascendance.exists() then
        cast.windstrike()
    end
    -- actions.single+=/lava_lash,if=buff.hot_hand.up|(runeforge.primal_lava_actuators.equipped&buff.primal_lava_actuators.stack>6)
    if cast.able.lavaLash() and (buff.hotHand.exists() or (runeforge.primalLavaActuators.equiped and buff.primalLavaActuators.stack() > 6)) then
        cast.lavaLash()
    end
    -- actions.single+=/windfury_totem,if=!buff.windfury_totem.up
    if cast.able.windfuryTotem() and not buff.windfuryTotem.exists("player","any") then
        cast.windfuryTotem()
    end
    -- actions.single+=/stormstrike,if=runeforge.doom_winds.equipped&buff.doom_winds.up
    if cast.able.stormstrike() and runeforge.doomWinds.equiped and buff.doomWinds.exists() then
        cast.stormstrike()
    end
    -- actions.single+=/crash_lightning,if=runeforge.doom_winds.equipped&buff.doom_winds.up
    if #enemies.yards8c > 0 and cast.able.crashLightning("player","cone",1,8) and runeforge.doomWinds.equiped and buff.doomWinds.exists() then
        cast.crashLightning("player","cone",1,8)
    end
    -- actions.single+=/ice_strike,if=runeforge.doom_winds.equipped&buff.doom_winds.up
    if cast.able.iceStrike() and runeforge.doomWinds.equiped and buff.doomWinds.exists() then
        cast.iceStrike()
    end
    -- actions.single+=/sundering,if=runeforge.doom_winds.equipped&buff.doom_winds.up
    if ui.alwaysCdNever("Sundering") and #enemies.yards11r > 0 and cast.able.sundering("player","rect",1,11) and runeforge.doomWinds.equiped and buff.doomWinds.exists() then
        cast.sundering("player","rect",1,11)
    end
    -- actions.single+=/primordial_wave,if=buff.primordial_wave.down&(raid_event.adds.in>42|raid_event.adds.in<6)
    if ui.alwaysCdNever("Covenant Ability") and cast.able.primordialWave() and not buff.primordialWave.exists() then
        cast.primordialWave()
    end
    -- actions.single+=/flame_shock,if=!ticking
    if cast.able.flameShock() and not debuff.flameShock.exists() then
        cast.flameShock()
    end
    -- actions.single+=/lightning_bolt,if=buff.maelstrom_weapon.stack>=5&buff.primordial_wave.up&raid_event.adds.in>buff.primordial_wave.remains&(!buff.splintered_elements.up|fight_remains<=12)
    if cast.able.lightningBolt() and buff.maelstromWeapon.stack() >= 5 and buff.primordialWave.exists() and not buff.splinteredElements.exists() then
        cast.lightningBolt()
    end
    -- actions.single+=/vesper_totem,if=raid_event.adds.in>40
    if ui.alwaysCdNever("Covenant Ability") and cast.able.vesperTotem() then
        cast.vesperTotem()
    end
    -- actions.single+=/frost_shock,if=buff.hailstorm.up
    if cast.able.frostShock() and buff.hailstorm.exists() then
        cast.frostShock()
    end
    -- actions.single+=/earthen_spike
    if cast.able.earthenSpike() then
        cast.earthenSpike()
    end
    -- actions.single+=/lava_lash,if=dot.flame_shock.refreshable
    if cast.able.lavaLash() then
        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]
            if debuff.flameShock.refresh(thisUnit) then
                cast.lavaLash(thisUnit)
            end
        end
    end
    -- actions.single+=/fae_transfusion,if=!runeforge.seeds_of_rampant_growth.equipped|cooldown.feral_spirit.remains>30
    if ui.alwaysCdNever("Covenant Ability") and cast.able.faeTransfusion("player","ground") and (not runeforge.seedsOfRampantGrowth.equipped or cd.feralSpirits.remain() > 30) and not unit.moving("player") then
        cast.faeTransfusion("player","ground")
    end
    -- actions.single+=/stormstrike,if=talent.stormflurry.enabled&buff.stormbringer.up
    if cast.able.stormstrike() and talent.stormflurry and buff.stormbringer.exists() then
        cast.stormstrike()
    end
    -- actions.single+=/chain_lightning,if=buff.stormkeeper.up
    if cast.able.chainLightning() and buff.stormkeeper.exists() then
        cast.chainLightning()
    end
    -- actions.single+=/elemental_blast,if=buff.maelstrom_weapon.stack>=5
    if cast.able.elementalBlast() and buff.maelstromWeapon.stack() >= 5 then
        cast.elementalBlast()
    end
    -- actions.single+=/healing_stream_totem,if=runeforge.raging_vesper_vortex.equipped&talent.earth_shield.enabled&(vesper_totem_heal_charges>1|(vesper_totem_heal_charges>0&raid_event.adds.in>(buff.vesper_totem.remains-3)))
    
    -- actions.single+=/earth_shield,if=runeforge.raging_vesper_vortex.equipped&talent.earth_shield.enabled&(vesper_totem_heal_charges>1|(vesper_totem_heal_charges>0&raid_event.adds.in>(buff.vesper_totem.remains-3)))
    
    -- actions.single+=/chain_harvest,if=buff.maelstrom_weapon.stack>=5&raid_event.adds.in>=90
    if ui.alwaysCdNever("Covenant Ability") and (unit.isBoss() or #enemies.yards8 >= ui.value("Chain Harvest Min Units")) and cast.able.chainHarvest() and buff.maelstromWeapon.stack() >= 5 then
        cast.chainHarvest()
    end
    -- actions.single+=/lightning_bolt,if=buff.maelstrom_weapon.stack=10&buff.primordial_wave.down
    if cast.able.lightningBolt() and buff.maelstromWeapon.stack() == 10 and not buff.primordialWave.exists() then
        cast.lightningBolt()
    end
    -- actions.single+=/stormstrike
    if cast.able.stormstrike() then
        cast.stormstrike()
    end
    -- actions.single+=/stormkeeper,if=buff.maelstrom_weapon.stack>=5
    if ui.alwaysCdNever("Stormkeeper") and cast.able.stormkeeper() and buff.maelstromWeapon.stack() >= 5 then
        cast.stormkeeper()
    end
    -- actions.single+=/fleshcraft,interrupt=1,if=soulbind.volatile_solvent
    
    -- actions.single+=/windfury_totem,if=buff.windfury_totem.remains<10
    if cast.able.windfuryTotem() and buff.windfuryTotem.remains("player","any") < 10 then
        cast.windfuryTotem()
    end
    -- actions.single+=/lava_lash
    if cast.able.lavaLash() then
        cast.lavaLash()
    end
    -- actions.single+=/lightning_bolt,if=buff.maelstrom_weapon.stack>=5&buff.primordial_wave.down
    if cast.able.lightningBolt() and buff.maelstromWeapon.stack() >= 5 and not buff.primordialWave.exists() then
        cast.lightningBolt()
    end
    -- actions.single+=/sundering,if=raid_event.adds.in>=40
    if ui.alwaysCdNever("Sundering") and #enemies.yards11r > 0 and cast.able.sundering("player","rect",1,11) then
        cast.sundering("player","rect",1,11)
    end
    -- actions.single+=/frost_shock
    if cast.able.frostShock() then
        cast.frostShock()
    end
    -- actions.single+=/crash_lightning
    if #enemies.yards8c > 0 and cast.able.crashLightning("player","cone",1,8) then
        cast.crashLightning("player","cone",1,8)
    end
    -- actions.single+=/ice_strike
    if cast.able.iceStrike() then
        cast.iceStrike()
    end
    -- actions.single+=/fire_nova,if=active_dot.flame_shock
    if cast.able.fireNova("player","aoe",1,8) and debuff.flameShock.count() > 0 then
        cast.fireNova("player","aoe",1,8)
    end
    -- actions.single+=/fleshcraft,if=soulbind.pustule_eruption
    
    -- actions.single+=/earth_elemental
    
    -- actions.single+=/flame_shock
    if cast.able.flameShock() then
        cast.flameShock()
    end
    -- actions.single+=/windfury_totem,if=buff.windfury_totem.remains<30
    if cast.able.windfuryTotem() and buff.windfuryTotem.remains("player","any") < 30 then
        cast.windfuryTotem()
    end

    br.debug.cpu:updateDebug(startTime,"rotation.profile.single")
end -- End Action List - Single
-- Action List - PreCombat
actionList.PreCombat = function()
    local startTime = br._G.debugprofilestop()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then
        -- Flask Up Module
        -- flask
        module.FlaskUp("Agility")
        -- Augmentation
        -- augmentation
        -- Windfury Weapon
        -- windfury_weapon
        if ui.checked("Windfury Weapon") and cast.able.windfuryWeapon() and not unit.weaponImbue.exists(5401) then
            if cast.windfuryWeapon("player") then ui.debug("Casting Windfury Weapon [Main Hand]") return true end
        end
        -- Flametongue Weapon
        -- flametongue_weapon
        if ui.checked("Flametongue Weapon") and cast.able.flametongueWeapon() and unit.dualWielding() and not unit.weaponImbue.exists(5400,true) then
            if cast.flametongueWeapon("player") then ui.debug("Casting Flametongue Weapon [Off Hand]") return true end
        end
        -- Lightning Shield
        -- lightning_shield
        if (ui.value("Shields Up") == 1 or (ui.value("Shields Up") == 2 and not talent.earthShield)) and cast.able.lightningShield() and not buff.lightningShield.exists() then
            if cast.lightningShield("player") then ui.debug("Casting Lightning Shield") return true end
        end
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Stormkeeper
            -- stormkeeper,if=talent.stormkeeper.enabled
            if ui.alwaysCdNever("Stormkeeper") and talent.stormkeeper and cast.able.stormkeeper() then
                if cast.stormkeeper() then ui.debug("Casting Stormkeeper [Pre-Combat]") return true end
            end
            -- Potion
            -- potion
            -- if ui.checked("Potion") and br.canUseItem(142117) and unit.instance("raid") then
            --     if feralSpiritRemain > 5 and not buff.prolongedPower.exists() then
            --         br.useItem(142117)
            --     end
            -- end
        end -- End Pre-Pull
        if unit.valid("target") then
            -- Feral Lunge
            if ui.checked("Feral Lunge") and cast.able.feralLunge() then
                if cast.feralLunge("target") then ui.debug("Casting Feral Lunge [Pull]") return true end
            end
            -- Windfury Totem
            -- windfury_totem,if=!runeforge.doom_winds.equipped
            if cast.able.windfuryTotem() and not unit.moving() and not runeforge.doomWinds.equiped
                and not buff.windfuryTotem.exists("player","any") and #enemies.yards8 > 0 and not ui.checked("Windfury Totem Key")
            then
                if cast.windfuryTotem() then ui.debug("Casting Windfury Totem [Pull]") return true end
            end
            -- Lightning Bolt
            if ui.checked("Lightning Bolt Out of Combat") and cast.able.lightningBolt() and not unit.moving()
                and unit.distance("target") >= 10 and (not ui.checked("Feral Lunge") or not talent.feralLunge
                    or cd.feralLunge.remain() > unit.gcd(true) or not cast.able.feralLunge())
                and cast.timeSinceLast.lightningBolt() > cast.time.lightningBolt() + unit.gcd(true)
                -- and (not ui.checked("Ghost Wolf") or unit.distance("target") <= 20 or not buff.ghostWolf.exists())
            then
                if cast.lightningBolt("target") then ui.debug("Casting Lightning Bolt [Pull]") return true end
            end
            -- Start Attack
            if unit.distance("target") < 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pull]") return true end
                end
            end
        end
    end -- End No Combat
    br.debug.cpu:updateDebug(startTime,"rotation.profile.precombat")
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------
    --- Locals ---
    --------------
    -- BR API
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    covenant                                      = br.player.covenant
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    module                                        = br.player.module
    runeforge                                     = br.player.runeforge
    talent                                        = br.player.talent
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    var                                           = br.player.variables

    -- Dynamic Units
    -- units.get(5)
    -- units.get(8)
    -- units.get(20)
    units.get(40)

    -- Enemies Lists
    enemies.get(5)
    enemies.get(8)
    enemies.get(8,"player",false,true)
    enemies.cone.get(180,8,false)
    enemies.get(10)
    enemies.get(10,units.get(5))
    enemies.rect.get(10,11,false)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40,"player",false,true)

    var.lowestFlameShock                            = debuff.flameShock.lowest(40,"remain") or "target"
    var.lowestLashingFlames                         = debuff.lashingFlames.lowest(5,"remain") or "target"

    if var.fillLightning == nil then var.fillLightning = false end
    if unit.distance("target") < 5 and buff.maelstromWeapon.stack() < 5 and not var.fillLightning then
        -- Cancel Lightning Bolt in Melee
        if cast.current.lightningBolt() and not canLightning() then
            if cast.cancel.lightningBolt() then ui.debug("Canceled Lightning Bolt Cast [Melee Range]") end
        end
        -- Cancel Chain Lightning Bolt in Melee
        if cast.current.chainLightning() and not canLightning(true) then
            if cast.cancel.chainLightning() then ui.debug("Canceled Chain Lightning Cast [Melee Range]") end
        end
    end


    var.healUnit = ui.value("Heal Target") == 1 and unit.lowest(40) or "player"
    var.healHP = unit.hp(var.healUnit)
    var.unitsNeedingHealing = 0
    if ui.checked("Use HST While Solo") and br.getHP("player") <= ui.value("Healing Stream Totem") then
        var.unitsNeedingHealing = var.unitsNeedingHealing + 1
    end
    if #br.friend > 1 then
        for i = 1, #br.friend do
            local thisFriend = br.friend[i].unit
            local thisDistance = unit.distance(thisFriend)
            if not unit.isUnit(thisFriend,"player") and thisDistance < 40 and unit.hp(thisFriend) <= ui.value("Healing Stream Totem") then
                var.unitsNeedingHealing = var.unitsNeedingHealing + 1
            end
        end
    end

    if var.profileStop == nil then var.profileStop = false end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop==true) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then return true end
        ---------------------------
        --- Pre-Combat Rotation ---
        ---------------------------
        if actionList.PreCombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if unit.inCombat() and unit.valid("target") and not var.profileStop then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then  return true end
            ------------------------
            --- In Combat - Main ---
            ------------------------
            -- Feral Lunge
            if ui.checked("Feral Lunge") and cast.able.feralLunge() and unit.distance("target") > 10 then
                if cast.feralLunge("target") then ui.debug("Casting Feral Lunge") return true end
            end
            -- Start Attack
            if unit.distance("target") <= 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack") return true end
                end
            end
            -- Windfury Totem
            -- windfury_totem,if=!runeforge.doom_winds.equipped
            if cast.able.windfuryTotem() and not unit.moving() and not buff.windfuryTotem.exists("player","any")
                and #enemies.yards8 > 0 and not ui.checked("Windfury Totem Key")
            then
                if cast.windfuryTotem() then ui.debug("Casting Windfury Totem") return true end
            end
            -- manual windury totem
            if ui.toggle("Windfury Totem Key") and ui.checked("Windfury Totem Key") then
                if cast.windfuryTotem() then ui.debug("Casting Windfury Totem") return true end
            elseif buff.windfuryTotem.exists() or unit.level() < 49 or unit.ttdGroup() < 6 then
                -- Basic Trinkets Module
                if #enemies.yards8f > 0 then
                    module.BasicTrinkets()
                end
                -- Racials
                -- blood_fury,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
                -- berserking,if=!talent.ascendance.enabled|buff.ascendance.up
                -- fireblood,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
                -- ancestral_call,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
                -- bag_of_tricks,if=!talent.ascendance.enabled|!buff.ascendance.up
                if ui.checked("Racial") and ui.alwaysCdNever("Racial") and (((unit.race() == "Orc" or unit.race() == "DarkIronDwarf" or unit.race() == "MagharOrc")
                    and (not talent.ascendance or (ui.useCDs() and buff.ascendance.exists()) or cd.ascendance.remains() > 50 or (not ui.useCDs() and ui.alwaysCdNever("Racial"))))
                    or (unit.race() == "Troll" and (not talent.ascendance or (ui.useCDs() and buff.ascendance.exists()) or (ui.useCDs() and ui.alwaysCdNever("Racial")))))
                then
                    if cast.racial("player") then ui.debug("Casting Racial") return true end
                end
                -- Feral Spirit
                -- feral_spirit
                if ui.alwaysCdNever("Feral Spirit") and cast.able.feralSpirit() then
                    if cast.feralSpirit() then ui.debug("Casting Feral Spirit") return true end
                end
                -- Fae Transfusion
                -- fae_transfusion,if=(talent.ascendance.enabled|runeforge.doom_winds.equipped)&(soulbind.grove_invigoration|soulbind.field_of_blossoms|active_enemies=1)
                if ui.alwaysCdNever("Covenant Ability") and cast.able.faeTransfusion("player","ground") and (talent.ascendance or runeforge.doomWinds.equiped) and (covenant.nightFae.active or #enemies.yards5 == 1) and not unit.moving("player") then
                    if cast.faeTransfusion("player","ground") then ui.debug("Casting Fae Transfusion") return true end
                end
                -- Ascendance
                -- ascendance
                if ui.alwaysCdNever("Ascendance") and cast.able.ascendance() and #enemies.yards8 > 0 and unit.ttd("target") > 15 then
                    if cast.ascendance() then ui.debug("Casting Ascendance") return true end
                end
                -- Windfury Totem
                -- windfury_totem,if=runeforge.doom_winds.equipped&buff.doom_winds_debuff.down&(raid_event.adds.in>=60|active_enemies>1)
                if cast.able.windfuryTotem() and not unit.moving() and runeforge.doomWinds.equiped and not debuff.doomWinds.exists("player")
                    and #enemies.yards8 > 0 and not ui.checked("Windfury Totem Key") and unit.ttdGroup() >= 6
                then
                    if cast.windfuryTotem() then ui.debug("Casting Windfury Totem [Doom Winds]") return true end
                end
                -- Call Action List - Single
                -- call_action_list,name=single,if=active_enemies=1
                if ui.useST(8,2) then
                    if actionList.Single() then return true end
                end
                -- Call Action List - AOE
                -- call_action_list,name=aoe,if=active_enemies>1
                if ui.useAOE(8,2) then
                    if actionList.AOE() then return true end
                end
            end
        end --End In Combat
    end --End Rotation Logic
end -- End runRotation
local id = 263
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
