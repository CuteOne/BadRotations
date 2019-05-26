local rotationName = "SaintlySinner"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enables DPS Rotation", highlight = 1, icon = br.player.spell.fracture},
        [2] = { mode = "Off", value = 2 , overlay = "Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.soulCleave}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.fieryBrand},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Always use CDs.", highlight = 0, icon = br.player.spell.sigilOfChains},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.sigilOfMisery}
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.metamorphosis},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.metamorphosis}
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.consumeMagic},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.consumeMagic}
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
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSaintlySinner"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Torment
            br.ui:createCheckbox(section,"Torment","|cffFFFFFFWill taunt in dungeons.")
        -- Throw Glaive
            br.ui:createCheckbox(section, "Throw Glaive","|cffFFFFFFEnable/Disable Throw Glaive.")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Lightforged Augment Rune
            br.ui:createCheckbox(section, "Lightforged Augment Rune","|cffFFFFFF7.3 augment rune")
        -- Repurposed Fel Focuser
            br.ui:createCheckbox(section, "Repurposed Fel Focuser","|cffFFFFFFReplaces flasks.")
        -- Racial
            br.ui:createCheckbox(section,"Racial: Blood Elf Only")
        -- Archimonde's Hatred Reborn
            br.ui:createCheckbox(section, "Archimonde's Hatred Reborn")
        -- Kil'jaeden's Burning Wish
            br.ui:createCheckbox(section, "Kil'jaeden's Burning Wish")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Empower Wards
            br.ui:createCheckbox(section, "Empower Wards")
        -- Fiery Brand
            br.ui:createCheckbox(section, "Fiery Brand","|cffFFFFFFEnable/Disable FB.")
        -- Metamorphosis
            br.ui:createCheckbox(section, "Metamorphosis")
        -- Demon Spikes - HP
            br.ui:createSpinner(section, "Demon Spikes - HP", 80, 0 , 100, 5, "|cffFFBB00Health Percentage to use at")
        -- Soul Barrier
            br.ui:createSpinner(section, "Soul Barrier",  90,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Consume Magic
            br.ui:createCheckbox(section, "Consume Magic")
        -- Sigil of Chains
            br.ui:createCheckbox(section, "Sigil of Chains")
        -- Sigil of Silence
            br.ui:createCheckbox(section, "Sigil of Silence")
        -- Sigil of Misery
            br.ui:createCheckbox(section, "Sigil of Misery")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  30,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  2)
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
    if br.timer:useTimer("debugVengeance", math.random(0.15,0.3)) then
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
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local canFlask                                      = canUseItem(br.player.flask.wod.agilityBig)
        local cast                                          = br.player.cast
        local castable                                      = br.player.cast.debug
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
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
        local pain                                          = br.player.power.pain.amount()
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.pain.amount(), br.player.power.pain.max(), br.player.power.pain.regen(), br.player.power.pain.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttd                                           = getTTD(br.player.units(5))
        local ttm                                           = br.player.power.pain.ttm()
        local units                                         = units or {}
        local use                                           = br.player.use
        local item                                          = br.player.spell.items

        units.dyn5 = br.player.units(5)
        units.dyn8AoE = br.player.units(8,true)
        units.dyn20 = br.player.units(20)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards30 = br.player.enemies(30)


        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
        -- Torment
            if isChecked("Torment") and inInstance then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                        if cast.torment(thisUnit) then return end
                    end
                end
            end
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
                    elseif canUseItem(129196) then --Legion Healthstone
                        useItem(129196)
                    elseif canUseItem(healPot) then
                        useItem(healPot)
                    end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #getEnemies("player",20) do
                    thisUnit = getEnemies("player",20)[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Consume Magic
                        if isChecked("Consume Magic") and distance < 15 and cd.sigilOfChains.remain() > 0 then
                            if cast.consumeMagic(thisUnit) then return end
                        end
        -- Sigil of Chains
                        if isChecked("Sigil of Chains") and distance > 8 then
                            if cast.sigilOfChains(thisUnit,"ground") then return end
                        end
        -- Sigil of Silence
                        if isChecked("Sigil of Silence") and not UnitDebuff("target", "Solar Beam") and cd.consumeMagic.remain() > 0 then
                            if cast.sigilOfSilence(thisUnit,"ground") then return end
                        end
        -- Sigil of Silence - Concentrated Sigils
                        if isChecked("Sigil of Silence") and not UnitDebuff("target", "Solar Beam") and cd.consumeMagic.remain() > 0 and talent.concentratedSigils and distance < 5 then
                            if cast.sigilOfSilence() then return end
                        end
        -- Sigil of Misery
                        if isChecked("Sigil of Misery") and cd.consumeMagic.remain() > 0 and cd.sigilOfSilence.remain() > 0 and cd.sigilOfSilence.remain() < 45 and distance < 10 then
                            if cast.sigilOfMisery(thisUnit,"ground") then return end
                        end
        -- Sigil of Misery - Concentrated Sigils
                        if isChecked("Sigil of Misery") and cd.consumeMagic.remain() > 0 and cd.sigilOfSilence.remain() > 0 and cd.sigilOfSilence.remain() < 45 and talent.concentratedSigils and distance < 5 then
                            if cast.sigilOfMisery() then return end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
			if getDistance(units.dyn5) < 5 then
		-- Archimonde's Hatred Reborn
                if isChecked("Archimonde's Hatred Reborn") and useCDs() and hasEquiped(144249) and canUseItem(144249) and buff.metamorphosis.exists() or getSpellCD(187827) > GetItemCooldown(144249) then
                    useItem(144249)
                end
		-- Kil'jaeden's Burning Wish
                if isChecked("Kil'jaeden's Burning Wish") and useCDs() and hasEquiped(144259) and canUseItem(144259) and #getEnemies("player",8) >= 3 then
                    useItem(144259)
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
			-- Lightforged Augment Rune
                if isChecked("Lightforged Augment Rune") and not buff.defiledAugmentation.exists() then
					if use.lightforgedAugmentRune() then return end
                end
			-- Repurposed Fel Focuser
                if isChecked("Repurposed Fel Focuser") and not buff.felFocus.exists() then
					if use.repurposedFelFocuser() then return end
                end
			--Start auto attack.
                if isValidUnit("target") and not UnitIsDeadOrGhost("target") and getDistance("target") <= 5 then
                    StartAttack()
                end
            end -- End No Combat
        end -- End Action List - PreCombat
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not IsMounted() and not hastar and profileStop then
            profileStop = false
        elseif (inCombat and profileStop) or (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) or pause() or mode.rotation == 4 then
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
            if inCombat and profileStop == false and isValidUnit(units.dyn5) then
                -- auto_attack
                if getDistance("target") < 5 then
                    StartAttack()
                end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    --- In Combat - Cooldowns ---
    -----------------------------
                if actionList_Cooldowns() then return end
    ---------------------------
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
			if getOptionValue("APL Mode") == 1 then
    -- Racial - Arcane Torrent
                if isChecked("Racial: Blood Elf Only") and useCDs() and getDistance("target") < 5 then
                    if CastSpellByName(GetSpellInfo(202719),"player") then return end
                end
    -- Fiery Brand
                -- actions+=/fiery_brand,if=buff.demon_spikes.down&buff.metamorphosis.down
                if isChecked("Fiery Brand") then
                    if cast.fieryBrand() then return end
                end
    -- Empower Wards
                -- actions+=/empower_wards,if=debuff.casting.up
                if isChecked("Empower Wards") then
                    for i=1, #getEnemies("player",20) do
                        thisUnit = getEnemies("player",20)[i]
                        distance = getDistance(thisUnit)
                            if cd.consumeMagic.remain() > 0 and castingUnit(thisUnit) and distance < 20 and (charges.empowerWards.frac() > 1.00 and not buff.empowerWards.exists()) then
                                if cast.empowerWards() then return end
                            end
                        end
                    end
    -- Metamorphosis
                    -- actions+=/metamorphosis,if=buff.demon_spikes.down&!dot.fiery_brand.ticking&buff.metamorphosis.down&incoming_damage_5s>health.max*0.70
                    if isChecked("Metamorphosis") and not debuff.fieryBrand.exists(units.dyn5)
                        and not buff.metamorphosis.exists() and not buff.empowerWards.exists() and php < 70 then
                        if cast.metamorphosis() then return end
                    end
    -- Demonic Infusion
                -- actions+=/demonicInfusion, if charges = 0
                    if charges.demonSpikes.frac() < 0.2 and buff.demonSpikes.remain() < 12 and pain <= 40 then
                        if cast.demonicInfusion() then return end
                    end
    -- Demon Spikes
                -- actions+=/demon_spikes,if=charges=2|buff.demon_spikes.down&!dot.fiery_brand.ticking&buff.metamorphosis.down
                if isChecked("Demon Spikes - HP") then
                    if php <= getOptionValue("Demon Spikes - HP") and not buff.demonSpikes.exists() then
                        if cast.demonSpikes() then return end
                    end
                end
    -- Demon Spikes
                -- actions+=/demon_spikes,if=charges=2|buff.demon_spikes.down&!dot.fiery_brand.ticking&buff.metamorphosis.down
                if hasEquiped(151799) and charges.demonSpikes.frac() > 1.99 then
					if not buff.demonSpikes.exists() and not buff.metamorphosis.exists()  then
						if cast.demonSpikes() then return end
					end
				end
    -- Demon Spikes
                -- actions+=/demon_spikes,if=charges=2|buff.demon_spikes.down&!dot.fiery_brand.ticking&buff.metamorphosis.down
                if not hasEquiped(151799) then
					if charges.demonSpikes.frac() > 1.99 then
						if cast.demonSpikes() then return end
					end
				end
    -- Soul Barrier
                    -- actions+=/soul_barrier
                if isChecked("Soul Barrier") and php <= getOptionValue("Soul Barrier") and not buff.metamorphosis.exists() then
                    if cast.soulBarrier() then return end
                end
    -- Soul Carver 
                if (buff.soulFragments.stack() <= 3 or (debuff.fieryBrand.exists("target") and artifact.flamingSoul.enabled())) and (getSpellCD(204021) > 5 or not artifact.flamingSoul.enabled()) then
                    if cast.soulCarver() then return end
                end
    -- Immolation Aura
                -- actions+=/immolation_aura,if=pain<=80
                if getDistance(units.dyn5) < 5 and pain <= 80 then
                    if cast.immolationAura() then return end
                end
    -- Spirit Bomb
                -- actions+=/spirit_bomb,if=debuff.frailty.down
                if getDistance(units.dyn5) < 5 and (not debuff.frailty.exists(units.dyn5) and buff.soulFragments.stack() > 0) or buff.soulFragments.stack() >= 4 then
                    if cast.spiritBomb() then return end
                end
    -- Fel Devastation
                    -- actions+=/fel_devastation,if=incoming_damage_5s>health.max*0.70
                if getDistance(units.dyn5) < 5 then
                    if cast.felDevastation() then return end
                end
    -- Fel Eruption
                if getDistance(units.dyn5) < 5 then
                    if cast.felEruption() then return end
                end
    -- Felblade
                -- actions+=/felblade,if=pain<=70
                if pain <= 70 then
                    if cast.felblade() then return end
                end
    -- Shear
                -- actions+=/shear
                if pain <= 70 and buff.bladeTurning.exists() then
                        if cast.shear() then return end
                end
    -- Sigil of Flame
                -- actions+=/sigil_of_flame,if=remains-delay<=0.3*duration
                if talent.concentratedSigils and getDistance(units.dyn5) < 5 and not debuff.sigilOfFlame.exists(units.dyn5)then
                    if cast.sigilOfFlame() then return end
                end
    -- Sigil of Flame
                -- actions+=/sigil_of_flame,if=remains-delay<=0.3*duration
                if talent.quickenedSigils and getDistance(units.dyn5) < 8 and not isMoving(units.dyn5) then
                    if cast.sigilOfFlame("best",false,1,6) then return end
                end
    -- Fracture
                -- actions+=/fracture,if=pain>=80&soul_fragments<4&incoming_damage_4s<=health.max*0.20
                if pain >= 60 or buff.soulFragments.stack() <= 4 then
                    if cast.fracture() then return end
                end
    -- Soul Cleave
                    -- actions+=/soul_cleave,if=soul_fragments=5
                if talent.fracture and not talent.spiritBomb and pain >= 60 and buff.soulFragments.stack() >= 5 then
                    if cast.soulCleave() then return end
                end
    -- Soul Cleave
                    -- actions+=/soul_cleave,if=soul_fragments=5
                if not talent.fracture and talent.spiritBomb and pain >= 80 or (buff.soulFragments.stack() >= 5 and pain >= 60) then
                    if cast.soulCleave() then return end
                end
    -- Soul Cleave
                -- actions+=/soul_cleave,if=pain>=80
                if php < 40 and pain < 30 and buff.soulFragments.stack() < 1 then
                    if cast.soulCleave() then return end
                end
    -- Throw Glaive (Mo'Arg Leggo Support)
                if isChecked("Throw Glaive") and hasEquiped(137090) and #getEnemies("player",10) >= 3 then
                    if cast.throwGlaive() then return end
                end
    -- Infernal Strike
                -- actions+=/infernal_strike,if=!sigil_placed&!in_flight&remains-travel_time-delay<0.3*duration&artifact.fiery_demise.enabled().enabled&dot.fiery_brand.ticking
                -- actions+=/infernal_strike,if=!sigil_placed&!in_flight&remains-travel_time-delay<0.3*duration&(!artifact.fiery_demise.enabled().enabled|(max_charges-charges_fractional)*recharge_time<cooldown.fiery_brand.remain()s+5)&(cooldown.sigil_of_flame.remain()s>7|charges=2)
                if getDistance(units.dyn5) < 5 and charges.infernalStrike.count() > 1 then
                    if (artifact.fieryDemise.enabled() and debuff.fieryBrand.exists(units.dyn5))
                        or (not artifact.fieryDemise.enabled() or (charges.infernalStrike.max() - charges.infernalStrike.frac()) * charges.infernalStrike.recharge() < cd.fieryBrand.remain() + 5)
                        and (cd.sigilOfFlame.remain() > 7 or charges.infernalStrike.count() == 2)
                    then
                        -- if cast.infernalStrike("best",false,1,6) then return end
                        if cast.infernalStrike("player","ground") then return end
                    end
                end
    -- Shear
                -- actions+=/shear
				if pain < 80 then
					if cast.shear() then return end
				end
    -- Throw Glaive
                if isChecked("Throw Glaive") and not hasEquiped(137090) and getDistance(units.dyn5) > 5 then
                    if cast.throwGlaive() then return end
                end
			end --End SaintlySinner APL
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
