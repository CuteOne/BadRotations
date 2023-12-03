local rotationName = "ForsoothBrewmaster"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enables Rotation", highlight = 1, icon = br.player.spell.tigerPalm},
        [2] = { mode = "Off", value = 2 , overlay = "Rotation Disabled", tip = "Disables Rotation", highlight = 0, icon = br.player.spell.tigerPalm}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Enables Defensive", highlight = 1, icon = br.player.spell.vivify},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "Disables Defensive", highlight = 0, icon = br.player.spell.vivify}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupt Enabled", tip = "Enables Interrupt", highlight = 1, icon = br.player.spell.legSweep},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupt Disabled", tip = "Interrupt Defensive", highlight = 0, icon = br.player.spell.legSweep}
    };
    br.ui:createToggle(InterruptModes,"Interrupt",3,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Crackling Jade lightning
            br.ui:createCheckbox(section, "Crackling Jade Lightning")
            br.ui:createSpinnerWithout(section, "Cancel CJL Range", 10, 5, 40, 5, "|cffFFFFFFCancels Crackling Jade Lightning below this range in yards.")
            -- Roll
            br.ui:createCheckbox(section, "Roll")
            -- Touch of Death
            br.ui:createCheckbox(section, "Touch of Death")
            -- Trinkets
            br.player.module.BasicTrinkets(nil,section)
            -- br.ui:createDropdownWithout(section,"Trinket 1", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Trinket 1.")
            -- br.ui:createDropdownWithout(section,"Trinket 2", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Trinket 2.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Expel Harm
            br.ui:createSpinner(section, "Expel Harm",  40,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Healthstone / Potion
            br.ui:createSpinner(section, "Healthstone/Potion", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Leg Sweep
            br.ui:createSpinner(section, "Leg Sweep - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Leg Sweep - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
            -- Vivify
            br.ui:createSpinner(section, "Vivify",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Target Heal Key
            br.ui:createDropdownWithout(section, "Target Heal Key", br.dropOptions.Toggle,  2)
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Leg Sweep
            br.ui:createCheckbox(section, "Leg Sweep")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
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

--------------
--- Locals ---
--------------
-- BR API Locals
local cast
local buff
local debuff
local talent
local cd
local combatTime
local enemies
local energy
local energyRegen
local module
local ui
local unit
local units
-- Profile Specific Locals
local actionList = {}
local var = {}
var.getFacingDistance = br["getFacingDistance"]
var.getItemInfo = br._G["GetItemInfo"]
var.haltProfile = false
var.profileStop = false
var.specificToggle = br["SpecificToggle"]

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Roll
    if ui.checked("Roll") and unit.moving() and unit.distance("target") > 10 and unit.valid("target")
        and var.getFacingDistance() < 5 and unit.facing("player","target",10)
    then
        if cast.roll() then ui.debug("Casting Roll") return true end
    end
end -- End Action List- Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Expel Harm
        if ui.checked("Expel Harm") and unit.hp() <= ui.value("Expel Harm") then
            if cast.expelHarm() then ui.debug("Casting Expel Harm") return true end
        end
        -- Leg Sweep
        if ui.checked("Leg Sweep - HP") and unit.hp() <= ui.value("Leg Sweep - HP") and unit.inCombat() and #enemies.yards5 > 0 then
            if cast.legSweep() then ui.debug("Casting Leg Sweep [HP]") return true end
        end
        if ui.checked("Leg Sweep - AoE") and #enemies.yards5 >= ui.value("Leg Sweep - AoE") then
            if cast.legSweep() then ui.debug("Casting Leg Sweep [AOE]") return true end
        end
        -- Vivify
        if ui.checked("Vivify") and cast.able.vivify() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.hp(thisUnit) <= ui.value("Vivify") then
                if cast.vivify(thisUnit) then ui.debug("Casting Vivify on "..unit.name(thisUnit)) return true end
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        for i=1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if br.canInterrupt(thisUnit,ui.value("Interrupt At")) then
                -- Leg Sweep
                if ui.checked("Leg Sweep") and cast.able.legSweep(thisUnit) and unit.distance(thisUnit) < 5 then
                    if cast.legSweep(thisUnit) then ui.debug("Casting Leg Sweep [Interrupt]") return true end
                end
            end
        end
    end -- End Interrupt Check
end -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Touch of Death
            if cast.able.touchOfDeath("target") and unit.health("target") < unit.health("player") then
                if cast.touchOfDeath("target") then ui.debug("Casting Touch of Death - DIE! [Pull]") return true end
            end
            -- Crackling Jade Lightning
            if ui.checked("Crackling Jade Lightning") and not cast.current.cracklingJadeLightning()
                and not unit.moving() and unit.distance("target") > ui.value("Cancel CJL Range")
            then
                if cast.cracklingJadeLightning() then ui.debug("Casting Crackling Jade Lightning [Pull]") return true end
            end
            -- Start Attack
            if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                br._G.StartAttack(units.dyn5)
            end
        end
    end
end -- End Action List - PreCombat

actionList.rotation_boc = function()
    -- blackout_kick
    if cast.able.blackoutKick() and #enemies.yards5 > 0 then
        cast.blackoutKick()
    end
    -- invoke_niuzao_the_black_ox,if=debuff.weapons_of_order_debuff.stack>3
    if br.isBoss() and unit.ttd("target") > 20 and debuff.weaponsOfOrder.stack() > 3 and cast.able.invokeNiuzao() then
        cast.invokeNiuzao()
    end
    -- 	invoke_niuzao_the_black_ox,if=!talent.weapons_of_order.enabled
    if br.isBoss() and unit.ttd("target") > 20 and not talent.weaponsOfOrder then
        cast.invokeNiuzao()
    end
    -- weapons_of_order,if=(talent.weapons_of_order.enabled)
    if cast.able.weaponsOfOrder() and br.isBoss() and unit.ttd("target") > 30 then
        cast.weaponsOfOrder()
    end
    -- 	keg_smash,if=time-action.weapons_of_order.last_used<2&talent.weapons_of_order.enabled
    if buff.weaponsOfOrder.exists() and cast.last.weaponsOfOrder() and cast.able.kegSmash("best",nil,1,8) then
        cast.kegSmash("best",nil,1,8)
    end
    -- purifying_brew,if=(!buff.blackout_combo.up)
    if cast.able.purifyingBrew() and not buff.blackoutCombo.exists() then
        cast.purifyingBrew()
    end
    -- 	rising_sun_kick
    if cast.able.risingSunKick() and #enemies.yards5 > 0 then
        cast.risingSunKick()
    end
    -- keg_smash,if=buff.weapons_of_order.up&debuff.weapons_of_order_debuff.remains<=gcd*2
    if cast.able.kegSmash("best",nil,1,8) and buff.weaponsOfOrder.exists() and debuff.weaponsOfOrder.remains() <= unit.ttd() * 2 then
        cast.kegSmash("best",nil,1,8)
    end
    -- black_ox_brew,if=energy+energy.regen<=40
    if cast.able.blackOxBrew() and energy+energyRegen <= 40 then
        cast.blackOxBrew()
    end
    -- tiger_palm,if=buff.blackout_combo.up&active_enemies=1
    if cast.able.tigerPalm() and buff.blackoutCombo.exists() and #enemies.yards5 == 1 then
        cast.tigerPalm()
    end
    -- breath_of_fire,if=buff.charred_passions.remains<cooldown.blackout_kick.remains
    if cast.able.breathOfFire() and buff.charredPassions.remains() < cd.blackoutKick.remains() then
        cast.breathOfFire()
    end
    -- 	keg_smash,if=buff.weapons_of_order.up&debuff.weapons_of_order_debuff.stack<=3
    if cast.able.kegSmash("best",nil,1,8) and buff.weaponsOfOrder.exists() and debuff.weaponsOfOrder.stack() <= 3 then
        cast.kegSmash("best",nil,1,8)
    end
    --	summon_white_tiger_statue,if=debuff.weapons_of_order_debuff.stack>3
    if br.isBoss() and unit.ttd() > 30 and cast.able.summonWhiteTigerStatue() and debuff.weaponsOfOrder.stack() > 3 then
        cast.summonWhiteTigerStatue()
    end
    -- summon_white_tiger_statue,if=!talent.weapons_of_order.enabled
    if br.isBoss() and unit.ttd() > 30 and cast.able.summonWhiteTigerStatue() and not talent.weaponsOfOrder then
        cast.summonWhiteTigerStatue()
    end
    -- 	bonedust_brew,if=(time<10&debuff.weapons_of_order_debuff.stack>3)|(time>10&talent.weapons_of_order.enabled)
    if cast.able.bonedustBrew() and (combatTime < 10 and debuff.weaponsOfOrder.stack() > 3 or combatTime > 10 and talent.weaponsOfOrder) then
        cast.bonedustBrew()
    end
    -- bonedust_brew,if=(!talent.weapons_of_order.enabled)
    if cast.able.bonedustBrew() and not talent.weaponsOfOrder then
        cast.bonedustBrew()
    end
    -- exploding_keg,if=(buff.bonedust_brew.up)
    if cast.able.explodingKeg("best",nil,1,8) and buff.bonedustBrew.exists() then
        cast.explodingKeg("best",nil,1,8)
    end
    -- exploding_keg,if=(!talent.bonedust_brew.enabled)
    if cast.able.explodingKeg("best",nil,1,8) and not talent.bonedustBrew then
        cast.explodingKeg("best",nil,1,8)
    end
    --keg_smash
    if cast.able.kegSmash("best",nil,1,8) then
        cast.kegSmash("best",nil,1,8)
    end
    -- rushing_jade_wind,if=talent.rushing_jade_wind.enabled
    if cast.able.rushingJadeWind() and #enemies.yards8 > 0 then
        cast.rushingJadeWind()
    end
    -- breath_of_fire
    if cast.able.breathOfFire() and #enemies.yards12 > 0 then
        cast.breathOfFire()
    end
    -- tiger_palm,if=active_enemies=1&!talent.blackout_combo.enabled
    if cast.able.tigerPalm() and #enemies.yards5 == 1 and not talent.blackoutCombo then
        cast.tigerPalm()
    end
    -- spinning_crane_kick,if=active_enemies>1
    if cast.able.spinningCraneKick() and #enemies.yards8 > 1 then
        cast.spinningCraneKick()
    end
    -- expel_harm
    if cast.able.expelHarm() and #enemies.yards8 > 0 then
        cast.expelHarm()
    end
    -- chi_wave,if=talent.chi_wave.enabled
    if cast.able.chiWave() then
        cast.chiWave()
    end
    -- 	chi_burst,if=talent.chi_burst.enabled
    if cast.able.chiBurst() then
        cast.chiBurst()
    end
end

actionList.rotation_pta = function()
    -- invoke_niuzao_the_black_ox,if=debuff.weapons_of_order_debuff.stack>3
    if br.isBoss() and unit.ttd("target") > 20 and debuff.weaponsOfOrder.stack() > 3 and cast.able.invokeNiuzao() then
        cast.invokeNiuzao()
    end
    -- 	invoke_niuzao_the_black_ox,if=!talent.weapons_of_order.enabled
    if br.isBoss() and unit.ttd("target") > 20 and not talent.weaponsOfOrder then
        cast.invokeNiuzao()
    end
    -- 	rising_sun_kick,if=(buff.press_the_advantage.stack<6|buff.press_the_advantage.stack>9)&active_enemies<=4
    if cast.able.risingSunKick() and (buff.pressTheAdvantage.stack() < 6 or buff.pressTheAdvantage.stack() > 9) and #enemies.yards5 <= 4 then
        cast.risingSunKick()
    end
    -- 	keg_smash,if=(buff.press_the_advantage.stack<8|buff.press_the_advantage.stack>9)&active_enemies>4
    if cast.able.kegSmash("best",nil,1,8) and (buff.pressTheAdvantage.stack() < 8 or buff.pressTheAdvantage.stack() > 9) and #enemies.yards5 > 4 then
        cast.kegSmash("best",nil,1,8)
    end
    -- blackout_kick
    if cast.able.blackoutKick() and #enemies.yards5 > 0 then
        cast.blackoutKick()
    end
    -- purifying_brew,if=(!buff.blackout_combo.up)
    if cast.able.purifyingBrew() and not buff.blackoutCombo.exists() then
        cast.purifyingBrew()
    end
    -- black_ox_brew,if=energy+energy.regen<=40
    if cast.able.blackOxBrew() and energy+energyRegen <= 40 then
        cast.blackOxBrew()
    end
    --	summon_white_tiger_statue,if=debuff.weapons_of_order_debuff.stack>3
    if br.isBoss() and unit.ttd() > 30 and cast.able.summonWhiteTigerStatue() and debuff.weaponsOfOrder.stack() > 3 then
        cast.summonWhiteTigerStatue()
    end
    -- summon_white_tiger_statue,if=!talent.weapons_of_order.enabled
    if br.isBoss() and unit.ttd() > 30 and cast.able.summonWhiteTigerStatue() and not talent.weaponsOfOrder then
        cast.summonWhiteTigerStatue()
    end
    -- 	bonedust_brew,if=(time<10&debuff.weapons_of_order_debuff.stack>3)|(time>10&talent.weapons_of_order.enabled)
    if cast.able.bonedustBrew() and (combatTime < 10 and debuff.weaponsOfOrder.stack() > 3 or combatTime > 10 and talent.weaponsOfOrder) then
        cast.bonedustBrew()
    end
    -- bonedust_brew,if=(!talent.weapons_of_order.enabled)
    if cast.able.bonedustBrew() and not talent.weaponsOfOrder then
        cast.bonedustBrew()
    end
    -- exploding_keg,if=(buff.bonedust_brew.up)
    if cast.able.explodingKeg("best",nil,1,8) and buff.bonedustBrew.exists() then
        cast.explodingKeg("best",nil,1,8)
    end
    -- exploding_keg,if=(!talent.bonedust_brew.enabled)
    if cast.able.explodingKeg("best",nil,1,8) and not talent.bonedustBrew then
        cast.explodingKeg("best",nil,1,8)
    end
    -- breath_of_fire,if=!(buff.press_the_advantage.stack>6&buff.blackout_combo.up)
    if cast.able.breathOfFire() and #enemies.yards12 > 0 and not (buff.pressTheAdvantage.stack() > 6 and buff.blackoutCombo.exists()) then
        cast.breathOfFire()
    end
    -- keg_smash,if=!(buff.press_the_advantage.stack>6&buff.blackout_combo.up)
    if cast.able.kegSmash("best",nil,1,8) and not(buff.pressTheAdvantage.stack() > 6 and buff.blackoutCombo.exists()) then
        cast.kegSmash("best",nil,1,8)
    end
    -- rushing_jade_wind,if=talent.rushing_jade_wind.enabled
    if cast.able.rushingJadeWind() and #enemies.yards8 > 0 then
        cast.rushingJadeWind()
    end
    -- spinning_crane_kick,if=active_enemies>1
    if cast.able.spinningCraneKick() and #enemies.yards8 > 1 then
        cast.spinningCraneKick()
    end
    -- expel_harm
    if cast.able.expelHarm() and #enemies.yards8 > 0 then
        cast.expelHarm()
    end
    -- chi_wave,if=talent.chi_wave.enabled
    if cast.able.chiWave() then
        cast.chiWave()
    end
    -- 	chi_burst,if=talent.chi_burst.enabled
    if cast.able.chiBurst() then
        cast.chiBurst()
    end
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff = br.player.buff
    talent = br.player.talent
    cast                                            = br.player.cast
    cd                                              = br.player.cd
    combatTime = br.getCombatTime()
    debuff = br.player.debuff
    enemies                                         = br.player.enemies
energy                                              = br.player.power.energy.amount()
energyRegen                                         = br.player.power.energy.regen()
    module                                          = br.player.module
    ui                                              = br.player.ui
    unit                                            = br.player.unit
    units                                           = br.player.units
    -- General Locals
    var.getHealPot                                  = br["getHealthPot"]()
    var.haltProfile                                 = (unit.inCombat() and var.profileStop) or unit.mounted() or br.pause() or ui.mode.rotation==4
    -- Units
    units.get(5)
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(8)
    enemies.get(12)

    -- Cancel Crackling Jade Lightning
    if cast.current.cracklingJadeLightning() and unit.distance("target") < ui.value("Cancel CJL Range") then
        if cast.cancel.cracklingJadeLightning() then ui.debug("Canceling Crackling Jade Lightning [Within "..ui.value("Cancel CJL Range").."yrds]") return true end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if br.pause() then
        var.profileStop = false
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -------------
        --- Extra ---
        -------------
        if actionList.Extra() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        -- Check for combat
        if unit.valid("target") and cd.global.remain() == 0 then
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                -----------------
                --- Interrupt ---
                -----------------
                if actionList.Interrupt() then return true end
                ------------
                --- Main ---
                ------------
                -- Crackling Jade Lightning
                if ui.checked("Crackling Jade Lightning") and not cast.current.cracklingJadeLightning()
                and not unit.moving() and unit.distance("target") > ui.value("Cancel CJL Range")
                then
                    if cast.cracklingJadeLightning() then ui.debug("Casting Crackling Jade Lightning [Pre-Pull]") return true end
                end
                -- Start Attack
                if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    br._G.StartAttack(units.dyn5)
                end
                -- Trinket - Non-Specific
                if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5  then
                    module.BasicTrinkets()
                    -- local thisTrinket
                    -- for i = 13, 14 do
                    --     thisTrinket = i == 13 and "Trinket 1" or "Trinket 2"
                    --     local opValue = ui.value(thisTrinket)
                    --     if (opValue == 1 or (opValue == 2 and ui.useCDs())) and use.able.slot(i)
                    --     and (not equiped.touchOfTheVoid(i) or (equiped.touchOfTheVoid(i) and (#enemies.yards8 > 2 or (ui.useCDs() and opValue ~= 3))))
                    --     then
                    --         use.slot(i)
                    --         ui.debug("Using Trinket in Slot "..i)
                    --         return
                    --     end
                    -- end
                end

                --
                for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    
                    if cast.able.spearHandStrike() and unit.interruptable(thisUnit,70) then
                        if cast.spearHandStrike() then ui.debug("Casting Spear Hand Strike [Interrupt]") return true end
                    end
                end

                -- actions+=/call_action_list,name=rotation_pta,if=talent.press_the_advantage.enabled
                if talent.pressTheAdvantage then
                    actionList.rotation_pta()
                else
                -- actions+=/call_action_list,name=rotation_boc,if=!talent.press_the_advantage.enabled
                    actionList.rotation_boc()
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 268
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})