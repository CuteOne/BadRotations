local rotationName = "ForsoothProt"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enables Rotation", highlight = 1, icon = br.player.spell.crusaderStrike},
        [2] = { mode = "Off", value = 2 , overlay = "Rotation Disabled", tip = "Disables Rotation", highlight = 0, icon = br.player.spell.crusaderStrike}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Enables Defensive", highlight = 1, icon = br.player.spell.flashOfLight},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "Disables Defensive", highlight = 0, icon = br.player.spell.flashOfLight}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupt Enabled", tip = "Enables Interrupt", highlight = 1, icon = br.player.spell.hammerOfJustice},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupt Disabled", tip = "Disables Interrupt", highlight = 0, icon = br.player.spell.hammerOfJustice}
    };
    br.ui:createToggle(InterruptModes,"Interrupt",3,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Enables Cooldowns", highlight = 1, icon = br.player.spell.avengingWrath},
        [2] = { mode = "Off", value = 2 , overlay = "Cooldowns Disabled", tip = "Disables Cooldowns", highlight = 0, icon = br.player.spell.avengingWrath}
    };
    br.ui:createToggle(CooldownModes,"Cooldowns",4,0)
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
            -- Trinkets
            br.ui:createDropdownWithout(section,"Trinket 1", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Trinket 1.")
            br.ui:createDropdownWithout(section,"Trinket 2", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Trinket 2.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Divine Shield
            br.ui:createSpinner(section, "Divine Shield", 20, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Flash of Light
            br.ui:createSpinner(section, "Flash of Light", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Hammer of Justice
            br.ui:createSpinner(section, "Hammer of Justice - Defensive", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Lay on Hands
            br.ui:createSpinner(section, "Lay on Hands", 20, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Word of Glory
            br.ui:createSpinner(section, "Word of Glory", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Hammer of Justice
            br.ui:createCheckbox(section, "Hammer of Justice")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
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
local buff
local cast
local cd
local debuff
local enemies
local equiped
local charges
local module
local talent
local ui
local unit
local units
local use
-- Profile Specific Locals
local actionList        = {}
local var               = {}
local php
var.getFacingDistance   = br._G["getFacingDistance"]
var.getItemInfo         = br._G["GetItemInfo"]
var.haltProfile         = false
var.loadSupport         = br._G["loadSupport"]
var.profileStop         = false
var.range5              = false
var.range30             = false
var.range40             = false
var.specificToggle      = br._G["SpecificToggle"]

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()

end -- End Action List- Extra

-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- # Use Avenger's Shield as first priority before anything else, if t29 2pc is equipped.
    --actions.cooldowns=avengers_shield,if=time=0&set_bonus.tier29_2pc
    if cast.able.avengersShield() and equiped.tier(29) >= 2 then
        cast.avengersShield()
    end
    --actions.cooldowns+=/lights_judgment,if=spell_targets.lights_judgment>=2|!raid_event.adds.exists|raid_event.adds.in>75|raid_event.adds.up
    --actions.cooldowns+=/avenging_wrath
    if cast.able.avengingWrath() and unit.ttd() > 25 then
        cast.avengingWrath()
    end
    --actions.cooldowns+=/potion,if=buff.avenging_wrath.up
    --actions.cooldowns+=/moment_of_glory,if=(buff.avenging_wrath.remains<15|(time>10|(cooldown.avenging_wrath.remains>15))&(cooldown.avengers_shield.remains&cooldown.judgment.remains&cooldown.hammer_of_wrath.remains))
    if cast.able.momentOfGlory() and unit.ttd() > 15 and (buff.avengingWrath.remains() < 15 or (unit.combatTime() > 10 or (cd.avengingWrath.remains() > 15)) and cd.avengersShield.remains() and cd.judgment.remains() and cd.hammerOfWrath.remains()) then
        cast.momentOfGlory()
    end
    --actions.cooldowns+=/divine_toll,if=spell_targets.shield_of_the_righteous>=3
    if cast.able.divineToll() and #enemies.yards5 >= 3 then
        cast.divineToll()
    end
    --actions.cooldowns+=/bastion_of_light,if=buff.avenging_wrath.up|cooldown.avenging_wrath.remains<=30
    if cast.able.bastionOfLight() and buff.avengingWrath.exists() or cd.avengingWrath.remains() <= 30 then
        cast.bastionOfLight()
    end
    --actions.cooldowns+=/invoke_external_buff,name=power_infusion,if=buff.avenging_wrath.up
end -- End Action List - Cooldowns

-- Action List - Defensive
actionList.Defensive = function()
    php           = br.player.health
        -- Eye of Tyr
        if cast.able.eyeOfTyr() and php <= 60 then
            if cast.eyeOfTyr() then ui.debug("Casting Eye of Tyr") return true end
        end
        -- Sentinel
        if cast.able.sentinel() and php <= 50 then
            if cast.sentinel() then ui.debug("Casting Sentinel") return true end
        end
        -- Ardent Defender
        if cast.able.ardentDefender() and php <= 40 then
            if cast.ardentDefender() then ui.debug("Casting Ardent Defender") return true end
        end
        -- Guardian of Ancient Kings
        if cast.able.guardianOfAncientKings() and php <= 30 then
            if cast.guardianOfAncientKings() then ui.debug("Casting Guardian of Ancient Kings") return true end
        end

        -- Lay on Hands
        if ui.checked("Lay on Hands") and cast.able.layOnHands() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.inCombat(thisUnit) and not debuff.forbearance.exists(thisUnit) and unit.hp(thisUnit) <= ui.value("Lay on Hands") then
                if cast.layOnHands(thisUnit) then ui.debug("Casting Lay on Hands on "..unit.name(thisUnit)) return true end
            end
        end
        -- Divine Shield
        if ui.checked("Divine Shield") and cast.able.divineShield() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.inCombat(thisUnit) and not debuff.forbearance.exists(thisUnit) and unit.hp(thisUnit) <= ui.value("Divine Shield") then
                if cast.divineShield(thisUnit) then ui.debug("Casting Divine Shield on "..unit.name(thisUnit)) return true end
            end
        end
        -- Call Module- Basic Healing
        module.BasicHealing()
        -- -- Pot/Stoned
        -- if ui.checked("Healthstone/Potion") and unit.hp()<= ui.value("Healthstone/Potion") and unit.inCombat() then
        --     -- Lock Candy
        --     if has.healthstone() then
        --         if use.healthstone() then ui.debug("Using Healthstone") return true end
        --     end
        --     -- Health Potion (Grabs the Highest usable from bags)
        --     if has.item(var.getHealPot) then
        --         use.item(var.getHealPot)
        --         ui.debug("Using "..var.getItemInfo(var.getHealPot))
        --         return true
        --     end
        -- end
        -- -- Heirloom Neck
        -- if ui.checked("Heirloom Neck") and unit.hp() <= ui.value("Heirloom Neck") and not unit.inCombat() then
        --     if use.able.heirloomNeck() and item.heirloomNeck ~= 0 and item.heirloomNeck ~= item.manariTrainingAmulet then
        --         if use.heirloomNeck() then ui.debug("Using Heirloom Neck") return true end
        --     end
        -- end
        -- -- Gift of the Naaru
        -- if ui.checked("Gift of the Naaru") and unit.race() == "Draenei"
        --     and unit.inCombat() and unit.hp() < ui.value("Gift of the Naaru")
        -- then
        --     if cast.giftOfTheNaaru() then ui.debug("Casting Gift of the Naaru") return true end
        -- end
        -- Hammer of Justice
        if ui.checked("Hammer of Justice - Defensive") and cast.able.hammerOfJustice()
            and unit.inCombat() and unit.hp() < ui.value("Hammer of Justice - Defensive")
        then
            if cast.hammerOfJustice() then ui.debug("Casting Hammer of Justice [Defensive]") return true end
        end
        -- Word of Glory
        if ui.checked("Word of Glory") and cast.able.wordOfGlory() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.inCombat(thisUnit) and unit.hp(thisUnit) <= ui.value("Word of Glory") then
                if cast.wordOfGlory(thisUnit) then ui.debug("Casting Word of Glory on "..unit.name(thisUnit)) return true end
            end
        end
        -- Flash of Light
        if ui.checked("Flash of Light") and cast.able.flashOfLight() and not unit.moving() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if (unit.inCombat() and unit.hp(thisUnit) <= ui.value("Flash of Light"))
                or (not unit.inCombat() and unit.hp() < 90)
            then
                if cast.flashOfLight(thisUnit) then ui.debug("Casting Flash of Light on "..unit.name(thisUnit)) return true end
            end
        end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    for i=1, #enemies.yards10 do
        local thisUnit = enemies.yards10[i]
        
        if cast.able.rebuke() and unit.interruptable(thisUnit,70) then
            if cast.rebuke() then ui.debug("Casting Rebuke [Interrupt]") return true end
        end
        -- Hammer of Justice
        if cast.able.hammerOfJustice(thisUnit) and unit.interruptable(thisUnit,70) then
            if cast.hammerOfJustice(thisUnit) then ui.debug("Casting Hammer of Justice [Interrupt]") return true end
        end
    end
end -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Judgment
            if cast.able.judgment("target") and unit.exists("target") and unit.distance("target") < 30 then
                if cast.judgment("target") then ui.debug("Casting Judgment [Pull]") return true end
            end
            -- Consecration
            if cast.able.consecration() and not buff.exists.consecration() and #enemies.yards5 > 0 then
                cast.consecration()
            end
            -- Start Attack
            if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                br._G.StartAttack(units.dyn5)
            end
        end
    end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()

    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                            = br.player.buff
    cast                                            = br.player.cast
    cd                                              = br.player.cd
    charges = br.player.charges
    debuff                                          = br.player.debuff
    enemies                                         = br.player.enemies
    equiped                                         = br.player.equiped
    module                                          = br.player.module
    ui                                              = br.player.ui
    unit                                            = br.player.unit
    units                                           = br.player.units
    use                                             = br.player.use
    local holyPower     = br.player.power.holyPower.amount()
	php           = br.player.health
    talent = br.player.talent
    -- Units
    units.get(5)
    units.get(30)
    units.get(40)
    -- Enemies
    enemies.get(5)
    -- enemies.get(8)
    enemies.get(10)
    enemies.get(30)
    enemies.get(40)
    -- General Locals
    var.range5                                      = #enemies.yards5 > 0 and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5
    var.range30                                     = #enemies.yards30 > 0 and unit.exists(units.dyn30) and unit.distance(units.dyn30) < 30
    var.range40                                     = #enemies.yards40 > 0 and unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40
    var.getHealPot                                  = br["getHealthPot"]()
    var.haltProfile                                 = (unit.inCombat() and var.profileStop) or unit.mounted() or br.pause() or ui.mode.rotation==4


    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif var.haltProfile then
        return true
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
            if var.range40 then
                -----------------
                --- Interrupt ---
                -----------------
                if actionList.Interrupt() then return true end

                -- Taunt
                if cd.handOfReckoning.ready() and inInstance then
                    for i = 1, #enemies.yards30 do
                        local thisUnit = enemies.yards30[i]
                        if br._G.UnitThreatSituation("player",thisUnit) ~= nil and br._G.UnitThreatSituation("player",thisUnit) <= 2 and br._G.UnitAffectingCombat(thisUnit) and br.GetObjectID(thisUnit) ~= 174773 then
                            if cast.handOfReckoning(thisUnit) then return true end
                        end
                    end
                end

                if br.isBoss() then
                    actionList.Cooldowns()
                end
                ------------
                --- Main ---
                ------------
                
                if var.range5 then
                    -- Start Attack
                    if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) then
                        br._G.StartAttack(units.dyn5)
                    end
                    -- Trinket - Non-Specific
                    local thisTrinket
                    for i = 13, 14 do
                        thisTrinket = i == 13 and "Trinket 1" or "Trinket 2"
                        local opValue = ui.value(thisTrinket)
                        if (opValue == 1 or (opValue == 2 and ui.useCDs())) and use.able.slot(i)
                        and (not equiped.touchOfTheVoid(i) or (equiped.touchOfTheVoid(i) and (#enemies.yards8 > 2 or (ui.useCDs() and opValue ~= 3))))
                        then
                            use.slot(i)
                            ui.debug("Using Trinket in Slot "..i)
                            return
                        end
                    end
                end
                -- actions.standard=consecration,if=buff.sanctification.stack=buff.sanctification.max_stack
                -- # Use Shield of the Righteous according to Righteous Protector's ICD, but use it asap if it's a free proc (Bugged interaction, this ignores ICD). Don't use it when on max Sanctification Stacks (Very next GCD will trigger Consecration, so we want the bonus damage)
                -- actions.standard+=/shield_of_the_righteous,if=(((!talent.righteous_protector.enabled|cooldown.righteous_protector_icd.remains=0)&holy_power>2)|buff.bastion_of_light.up|buff.divine_purpose.up)&(!buff.sanctification.up|buff.sanctification.stack<buff.sanctification.max_stack)
                if cast.able.shieldOfTheRighteous() and (((not talent.righeousProtector) and holyPower > 2) or buff.bastionOfLight.exists() or buff.divinePurpose.exists()) then
                    cast.shieldOfTheRighteous()
                end
                -- actions.standard+=/judgment,target_if=min:debuff.judgment.remains,if=spell_targets.shield_of_the_righteous>3&buff.bulwark_of_righteous_fury.stack>=3&holy_power<3
                if cast.able.judgment() and #enemies.yards5 > 3 and buff.bulwarkOfTheRighteousFury.stack() >= 3 and holyPower < 3 then
                    local lowestJudgment = 14
                    local lowestJudgmentPlayer = {}
                    for i = 1, #enemies.yards30 do
                       if not debuff.judgment.exists(enemies.yards30[i]) then
                        lowestJudgment = 0
                        lowestJudgmentPlayer = enemies.yards30[i]
                       else
                        lowestJudgment = debuff.judgment.remains(enemies.yards30[i])
                        lowestJudgmentPlayer = enemies.yards30[i]
                       end
                    end

                    cast.judgment(lowestJudgmentPlayer)
                end
                -- # Use Judgment with higher priority if we need to build Sanctification Stacks
                -- actions.standard+=/judgment,target_if=min:debuff.judgment.remains,if=!buff.sanctification_empower.up&set_bonus.tier31_2pc
                -- actions.standard+=/hammer_of_wrath
                if cast.able.hammerOfWrath() then
                    cast.hammerOfWrath()
                end
                -- actions.standard+=/judgment,target_if=min:debuff.judgment.remains,if=charges>=2|full_recharge_time<=gcd.max
                if cast.able.judgment() and charges.judgment.count() >= 2 or charges.judgment.timeTillFull() < unit.gcd() then
                    local lowestJudgment = 14
                    local lowestJudgmentPlayer = {}
                    for i = 1, #enemies.yards30 do
                       if not debuff.judgment.exists(enemies.yards30[i]) then
                        lowestJudgment = 0
                        lowestJudgmentPlayer = enemies.yards30[i]
                       else
                        lowestJudgment = debuff.judgment.remains(enemies.yards30[i])
                        lowestJudgmentPlayer = enemies.yards30[i]
                       end
                    end

                    cast.judgment(lowestJudgmentPlayer)
                end
                -- actions.standard+=/avengers_shield,if=spell_targets.avengers_shield>2|buff.moment_of_glory.up
                if cast.able.avengersShield() and #enemies.yards10 > 2 and buff.momentOfGlory.exists() then
                    cast.avengersShield()
                end
                -- actions.standard+=/divine_toll,if=(!raid_event.adds.exists|raid_event.adds.in>10)
                if br.isBoss() and cast.able.divineToll() then
                    cast.divineToll()
                end
                -- actions.standard+=/avengers_shield
                if cast.able.avengersShield() then
                    cast.avengersShield()
                end
                -- actions.standard+=/judgment,target_if=min:debuff.judgment.remains
                if cast.able.judgment() then
                    local lowestJudgment = 14
                    local lowestJudgmentPlayer = {}
                    for i = 1, #enemies.yards30 do
                       if not debuff.judgment.exists(enemies.yards30[i]) then
                        lowestJudgment = 0
                        lowestJudgmentPlayer = enemies.yards30[i]
                       else
                        lowestJudgment = debuff.judgment.remains(enemies.yards30[i])
                        lowestJudgmentPlayer = enemies.yards30[i]
                       end
                    end

                    cast.judgment(lowestJudgmentPlayer)
                end
                -- actions.standard+=/consecration,if=!consecration.up&!buff.sanctification.stack=buff.sanctification.max_stack
                if cast.able.consecration() and not buff.consecration.exists() and #enemies.yards5 > 0 then
                    cast.consecration()
                end
                -- actions.standard+=/eye_of_tyr,if=talent.inmost_light.enabled&raid_event.adds.in>=45|spell_targets.shield_of_the_righteous>=3
                if cast.able.eyeOfTyr() and unit.ttd() > 8 and talent.inmostLight and #enemies.yards5 >= 3 then
                    cast.eyeOfTyr()
                end
                -- actions.standard+=/blessed_hammer
                if cast.able.blessedHammer() then
                    cast.blessedHammer()
                end
                -- actions.standard+=/hammer_of_the_righteous
                if cast.able.hammerOfTheRighteous() then
                    cast.hammerOfTheRighteous()
                end
                -- actions.standard+=/crusader_strike
                if cast.able.crusaderStrike() then
                    cast.crusaderStrike()
                end
                -- actions.standard+=/eye_of_tyr,if=!talent.inmost_light.enabled&raid_event.adds.in>=60|spell_targets.shield_of_the_righteous>=3
                if cast.able.eyeOfTyr() and not talent.inmostLight and #enemies.yards5 >= 3 then
                    cast.eyeOfTyr()
                end
                -- actions.standard+=/word_of_glory,if=buff.shining_light_free.up
                local lowest = {}
                lowest.unit = "player"
                lowest.hp = 100
                for i = 1, #br.friend do
                    if br.friend[i].hp < lowest.hp then
                        lowest = br.friend[i]
                    end
                end
                if cast.able.wordOfGlory() and lowest.hp < 100 and buff.shiningLight.exists() then
                    cast.wordOfGlory(lowest.unit)
                end
                -- actions.standard+=/arcane_torrent,if=holy_power<5
                if cast.able.racial() and #enemies.yards5 > 0 and holyPower < 5 then
                    cast.racial()
                end
                -- actions.standard+=/consecration,if=!buff.sanctification_empower.up
                if cast.able.consecration() and #enemies.yards5 > 0 then
                    cast.consecration()
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 66
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})