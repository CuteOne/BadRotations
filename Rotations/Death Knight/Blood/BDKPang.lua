local _, br = ...
local rotationName = "PangloBDK"

---------------
--- Toggles ---
---------------
local function createToggles()
    local CreateButton = br["CreateButton"]
    -- Rotation Button
    br.RotationModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Automatic Rotation",
            tip = "Swaps between Single and Multiple based on number of targets in range.",
            highlight = 1,
            icon = br.player.spell.bloodBoil
        },
        [2] = {
            mode = "Mult",
            value = 2,
            overlay = "Multiple Target Rotation",
            tip = "Multiple target rotation used.",
            highlight = 0,
            icon = br.player.spell.bloodBoil
        },
        [3] = {
            mode = "Sing",
            value = 3,
            overlay = "Single Target Rotation",
            tip = "Single target rotation used.",
            highlight = 0,
            icon = br.player.spell.heartStrike
        },
        [4] = {
            mode = "Off",
            value = 4,
            overlay = "DPS Rotation Disabled",
            tip = "Disable DPS Rotation",
            highlight = 0,
            icon = br.player.spell.deathStrike
        }
    }
    CreateButton("Rotation", 1, 0)
    -- Cooldown Button
    br.CooldownModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Cooldowns Automated",
            tip = "Automatic Cooldowns - Boss Detection.",
            highlight = 1,
            icon = br.player.spell.bonestorm
        },
        [2] = {
            mode = "On",
            value = 1,
            overlay = "Cooldowns Enabled",
            tip = "Cooldowns used regardless of target.",
            highlight = 0,
            icon = br.player.spell.bonestorm
        },
        [3] = {
            mode = "Off",
            value = 3,
            overlay = "Cooldowns Disabled",
            tip = "No Cooldowns will be used.",
            highlight = 0,
            icon = br.player.spell.bonestorm
        }
    }
    CreateButton("Cooldown", 2, 0)
    -- Defensive Button
    br.DefensiveModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Defensive Enabled",
            tip = "Includes Defensive Cooldowns.",
            highlight = 1,
            icon = br.player.spell.vampiricBlood
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Defensive Disabled",
            tip = "No Defensives will be used.",
            highlight = 0,
            icon = br.player.spell.vampiricBlood
        }
    }
    CreateButton("Defensive", 3, 0)
    -- Interrupt Button
    br.InterruptModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Interrupts Enabled",
            tip = "Includes Basic Interrupts.",
            highlight = 1,
            icon = br.player.spell.asphyxiate
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Interrupts Disabled",
            tip = "No Interrupts will be used.",
            highlight = 0,
            icon = br.player.spell.asphyxiate
        }
    }
    CreateButton("Interrupt", 4, 0)
    br.DNDModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Death and Decay Enabled",
            tip = "Use Death and Decay",
            highlight = 1,
            icon = br.player.spell.deathAndDecay
        },
        [2] = {
            mode = "Key",
            value = 2,
            overlay = "Key Usage of Death and Decay",
            tip = "Use Key for Death and Decay",
            highlight = 0,
            icon = br.player.spell.deathAndDecay
        }
    }
    CreateButton("DND", 5, 0)
--[[BoneStormModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "BoneStorm Enabled",
            tip = "Use Bonestorm",
            highlight = 1,
            icon = br.player.spell.bonestorm
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "BoneStorm Disabled",
            tip = "Don't use Bonestorm",
            highlight = 0,
            icon = br.player.spell.bonestorm
        }
    }
    CreateButton("BoneStorm", 6, 0) ]]
end

local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createCheckbox(section, "Dark Command", "|cffFFFFFFAuto Dark Command usage.")
        br.ui:createCheckbox(section, "Blooddrinker")
        br.ui:createDropdownWithout(section, "Bone Storm Usage", {"Use with Keybind Below", "Auto Usage"}, 1, "")
        br.ui:createCheckbox(section, "Dump RP with Death Strike")
        br.ui:checkSectionState(section)

        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Racial
        br.ui:createCheckbox(section, "Racial")
        -- Trinkets
        br.ui:createCheckbox(section, "Trinkets")
        -- Dancing Rune Weapon
        br.ui:createCheckbox(section, "Dancing Rune Weapon")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Keys")
        br.ui:createDropdown(section, "Deaths Advance Key", br.dropOptions.Toggle, 6, "", "Hold to activate Deaths Advance")
        br.ui:createDropdown(section, "Deaths Caress Key", br.dropOptions.Toggle, 6, "", "Hold to use Deaths Caress")
        br.ui:createDropdown(section, "Death Grip Key", br.dropOptions.Toggle, 6, "", "Hold to use Death Grip on Target")
        br.ui:createDropdown(section, "Gorefiends Grasp Key", br.dropOptions.Toggle, 6, "", "Hold to activate Gorefiends Grasp on Target")
        br.ui:createDropdown(section, "Bone Storm Key", br.dropOptions.Toggle, 6, "", "Hold to Pool Energy for Bonestorm and cast ASAP")
        br.ui:createDropdown(section, "Hold RP", br.dropOptions.Toggle, 6, "", "This Key will prevent any RP from being spent")
        br.ui:createDropdown(section, "Death and Decay Key", br.dropOptions.Toggle, 6 ,"","Use DnD when this key is held")
        br.ui:checkSectionState(section)

        -- Essence Options
        section = br.ui:createSection(br.ui.window.profile, "Essences")
        br.ui:createDropdownWithout(section, "Use Concentrated Flame", {"DPS", "Heal", "Hybrid", "Never"}, 1)
		br.ui:createSpinnerWithout(section, "Concentrated Flame Heal", 70, 10, 90, 5)
        br.ui:createSpinner(section,"Anima of Death", 75, 0, 100, 5, "Health Percentage to use at.")
        br.ui:createSpinnerWithout(section, "Anima Units", 3, 1, 10, 1, "Amount of units Anima Requires.")
        br.ui:checkSectionState(section)

        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Death Strike Values
        br.ui:createSpinner(section, "High Prio Deathstrike", 45, 0, 99, 5, "Use Deathstrike Immediately")
        br.ui:createSpinner(section, "Low Prio Deathstrike", 75, 0, 100, 5, "Use Deathstrike as a Offensive Ability")
        -- Healthstone
        br.ui:createSpinner(section, "Pot/Stoned", 60, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Rune Tap
        br.ui:createSpinner(section, "Rune Tap", 40, 0, 100, 5, "Health Percentage to use at.")
        -- Anti-Magic Shell
        br.ui:createSpinner(section, "Anti-Magic Shell", 50, 0, 100, 5, "Health Percentage to use at.")
        -- Vampiric Blood
        br.ui:createSpinner(section, "Vampiric Blood", 40, 0, 100, 5, "Health Percentage to use at.")
        -- Icebound Fortitude
        br.ui:createSpinner(section, "Icebound Fortitude", 50, 0, 100, 5, "Health Percentage to use at.")
        -- Raise Ally
        br.ui:createCheckbox(section, "Raise Ally")
        br.ui:createDropdownWithout(section, "Raise Ally - Target", {"|cff00FF00Target", "|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        br.ui:checkSectionState(section)

        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Asphyxiate
        br.ui:createCheckbox(section, "Asphyxiate")
        -- Death Grip
        br.ui:createCheckbox(section, "Death Grip - Int")
        -- Mind Freeze
        br.ui:createCheckbox(section, "Mind Freeze")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupts", 0, 0, 95, 5, "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end

local function runRotation()
    --Additional Toggles
    
    --Locals
    local addsExist = false
    local addsIn = 999
    local buff = br.player.buff
    local canFlask = br.canUseItem(br.player.flask.wod.staminaBig)
    local cast = br.player.cast
    local combatTime = br.getCombatTime()
    local cd = br.player.cd
    local charges = br.player.charges
    local deadMouse = UnitIsDeadOrGhost("mouseover")
    local deadtar,
        attacktar,
        hastar,
        playertar = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or br.GetObjectExists("target"), UnitIsPlayer("target")
    local debuff = br.player.debuff
    local enemies = br.player.enemies
    local essence = br.player.essence
    local falling,
        swimming,
        flying,
        moving = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player") > 0
    local fatality = false
    local flaskBuff = br.getBuffRemain("player", br.player.flask.wod.buff.staminaBig)
    local friendly = friendly or br.GetUnitIsFriend("target", "player")
    local gcd = br.player.gcd
    local hasMouse = br.GetObjectExists("mouseover")
    local healPot = getHealthPot()
    local inCombat = br.player.inCombat
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local level = br.player.level
    local lootDelay = br.getOptionValue("LootDelay")
    local lowestHP = br.friend[1].unit
    local mode = br.player.ui.mode
    local multidot = (br.player.ui.mode.cleave == 1 or br.player.ui.mode.rotation == 2) and br.player.ui.mode.rotation ~= 3
    local perk = br.player.perk
    local php = br.player.health
    local playerMouse = UnitIsPlayer("mouseover")
    local potion = br.player.potion
    local power,
        powmax,
        powgen = br.player.power.runicPower.amount(), br.player.power.runicPower.max(), br.player.power.runicPower.regen()
    local pullTimer = br.DBM:getPulltimer()
    local racial = br.player.getRacial()
    local runes = br.player.power.runes.frac()
    local runicPower = br.player.power.runicPower.amount()
    local powerDeficit = br.player.power.runicPower.deficit()
    local solo = #br.friend < 2
    local friendsInRange = friendsInRange
    local spell = br.player.spell
    local stealth = br.player.stealth
    local talent = br.player.talent
    local trinketProc = false
    local ttd = br.getTTD
    local ttm = br.player.power.runicPower.ttm()
    local units = br.player.units

    units.get(5)
    units.get(30, true)

    enemies.get(8) -- Bonestorm
    enemies.get(10) -- blood boil
    enemies.get(30)
    enemies.get(40)

    if timersTable then
        wipe(timersTable)
    end

    if leftCombat == nil then
        leftCombat = GetTime()
    end
    if profileStop == nil then
        profileStop = false
    end

    local bloodDrinkerCheck = not cd.blooddrinker.exists() and 1 or 0

    local healingAbsorbed = false

    --Action Lists
    local function damage_List()
        --Cap DS
        if not healingAbsorbed and powerDeficit <= 10 and br.isChecked("Dump RP with Death Strike") then
            if cast.deathStrike() then
                return
            end
        end

        --BloodDrinker
        if not buff.dancingRuneWeapon.exists("player") and talent.blooddrinker then
            if cast.blooddrinker("target") then
                return
            end
        end

        --marrowrend
        if ((buff.boneShield.remains("player") <= runeTimeTill(3)) or (buff.boneShield.remains("player") <= (gcd + bloodDrinkerCheck * (talent.blooddrinker and 1 or 0) * 2)) or (buff.boneShield.stack() < 3)) and powerDeficit >= 20 then
            if cast.marrowrend() then
                return
            end
        end

        --bloodboil
        if (charges.bloodBoil.frac() >= 1.8 and (buff.hemostasis.stack() <= (5 - #enemies.yards10) or #enemies.yards10 > 2)) then
            if cast.bloodBoil() then
                return
            end
        end

        if runes >= 4 then
            if cast.heartStrike() then return end
        end 

        --Marrowrend case 2
        if (buff.boneShield.stack() < 5 and talent.ossuary and powerDeficit >= 15) then
            if cast.marrowrend() then
                return
            end
        end

        --bonestorm
        if (runicPower >= 100 and not buff.dancingRuneWeapon.exists()) and br.getOptionValue("Bone Storm Usage") == 2 then
            if cast.bonestorm("player") then
                return
            end
        end

        -- if runic_power.deficit<=(15+buff.dancing_rune_weapon.up*5+spell_targets.heart_strike*talent.heartbreaker.enabled*2)|target.1.time_to_die<10
        if (powerDeficit <= (15 + (buff.dancingRuneWeapon.exists() and 1 or 0) * 5 + #enemies.yards8 * (talent.heartbreaker and 1 or 0) * 2) or ttd("target") < 10) and 
        ((php <= br.getOptionValue("Low Prio Deathstrike")) or not br.isChecked("Low Prio Deathstrike")) then
            if cast.deathStrike() then
                return
            end
        end
        --AoE DND
        if #enemies.yards8 >= 3 and mode.dND == 1 then
            if cast.deathAndDecay("player") then
                return
            end
        end

        --runestrike
        if talent.runeStrike and ((charges.runeStrike.frac() >= 1.8 or buff.dancingRuneWeapon.exists()) and runeTimeTill(3) >= gcd) then
            if cast.runeStrike() then
                return
            end
        end

        if br.getOptionValue("Use Concentrated Flame") == 1 or (br.getOptionValue("Use Concentrated Flame") == 3 and php > getValue("Concentrated Flame Heal")) then
            if cast.concentratedFlame("target") then
                return
            end
        end
        
        if br.isChecked("Anima of Death") and cd.animaOfDeath.remain() <= gcd and inCombat and (#enemies.yards8 >= br.getOptionValue("Anima Units") or br.isBoss()) and php <= br.getOptionValue("Anima of Death") then
            if cast.animaOfDeath("player") then return end
        end

        --HS Cast
        if buff.dancingRuneWeapon.exists() or (runeTimeTill(4) < gcd) then
            if cast.heartStrike("target") then
                return
            end
        end

        --Low prio BB
        if buff.dancingRuneWeapon.exists("player") then
            if cast.bloodBoil() then
                return
            end
        end

        --Proc DnD
        if (buff.crimsonScourge.exists() or talent.rapidDecomposition or #enemies.yards8 >= 2) and mode.dND == 1 then
            if cast.deathAndDecay("player") then
                return
            end
        end

        if #enemies.yards8 >= 1 then
            if cast.consumption() then
                return
            end
        end

        if #enemies.yards8 >= 1 then
            if cast.bloodBoil() then
                return
            end
        end

        if (runeTimeTill(2) < gcd) or (buff.boneShield.stack() >= 6) then
            if cast.heartStrike() then
                return
            end
        end

        if runes >= 4 then
            if cast.heartStrike() then return end
        end

        if #enemies.yards8 >= 1 and talent.runeStrike then
            if cast.runeStrike() then
                return
            end
        end
    end -- end of dps list

    local function extra_List()
        -- Dark Command
        if br.isChecked("Dark Command") and inInstance then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                    if cast.darkCommand(thisUnit) then
                        return
                    end
                end
            end
        end
    end

    local function defensive_List()
        if useDefensive() and not stealth and not flight then
            -- Pot/Stoned
            if br.isChecked("Pot/Stoned") and php <= br.getOptionValue("Pot/Stoned") and inCombat and (hasHealthPot() or br.hasItem(5512)) then
                if br.canUseItem(5512) then
                    br.useItem(5512)
                elseif br.canUseItem(healPot) then
                    br.useItem(healPot)
                end
            end

            if php <= br.getOptionValue("High Prio Deathstrike") and power >= 45 then
                if cast.deathStrike() then
                    return true
                end
            end
            -- Rune Tap
            if br.isChecked("Rune Tap") and php <= br.getOptionValue("Rune Tap") and runes >= 3 and charges.runeTap.count() > 1 and not buff.runeTap.exists() then
                if cast.runeTap() then
                    return
                end
            end
            -- Anti-Magic Shell
            if br.isChecked("Anti-Magic Shell") and php <= br.getOptionValue("Anti-Magic Shell") then
                if cast.antiMagicShell() then
                    return
                end
            end
            -- Icebound Fortitude
            if br.isChecked("Icebound Fortitude") and php <= br.getOptionValue("Icebound Fortitude") and not buff.vampiricBlood.exists("player") then
                if cast.iceboundFortitude() then
                    return
                end
            end
            -- Vampiric Blood
            if br.isChecked("Vampiric Blood") and php <= br.getOptionValue("Vampiric Blood") and not buff.iceboundFortitude.exists("player") then
                if cast.vampiricBlood() then
                    return
                end
            end
            if br.getOptionValue("Use Concentrated Flame") ~= 1 and br.getOptionValue("Use Concentrated Flame") ~= 4 and php <= getValue("Concentrated Flame Heal") then
                if cast.concentratedFlame("player") then
                    return
                end
            end
            -- Raise Ally
            if br.isChecked("Raise Ally") then
                if br.getOptionValue("Raise Ally - Target") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and br.GetUnitIsFriend("target", "player") then
                    if cast.raiseAlly("target", "dead") then
                        return
                    end
                end
                if br.getOptionValue("Raise Ally - Target") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and br.GetUnitIsFriend("mouseover", "player") then
                    if cast.raiseAlly("mouseover", "dead") then
                        return
                    end
                end
            end
        end
    end -- end defensive list

    local function key_List()
        if br.isChecked("Bone Storm Key") and SpecificToggle("Bone Storm Key") and br.getOptionValue("Bone Storm Usage") == 1 then
            if power >= 100 then
                if cast.bonestorm() then
                    return true
                end
            end

            if runes > 1 then
                if cast.heartStrike() then
                    return true
                end
            end

            if runes == 0 and talent.runeStrike then
                if cast.runeStrike() then
                    return true
                end
            end

            return true
        end
        if br.isChecked("Deaths Advance Key") and SpecificToggle("Deaths Advance Key") then
            if cast.able.deathsAdvance() then
                if cast.deathsAdvance("player") then
                    return true
                end
            end
        end

        if br.isChecked("Death and Decay Key") and br.player.ui.mode.dND == 2 and SpecificToggle("Death and Decay Key") then
            if cast.deathAndDecay("player") then
                return true
            end
        end

        if br.isChecked("Deaths Caress Key") and SpecificToggle("Deaths Caress Key") then
            if cast.able.deathsCaress() then
                if cast.deathsCaress("target") then
                    return true
                end
            end
        end

        if br.isChecked("Death Grip Key") and SpecificToggle("Death Grip Key") then
            if cast.able.deathGrip() then
                if cast.deathGrip("target") then
                    return true
                end
            end
        end

        if br.isChecked("Gorefiends Grasp Key") and SpecificToggle("Gorefiends Grasp Key") then
            if cast.able.gorefiendsGrasp() then
                if cast.gorefiendsGrasp("target") then
                    return true
                end
            end
        end
    end

    local function interrupt_List()
        if useInterrupts() then
            for i = 1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                if canInterrupt(thisUnit, br.getOptionValue("Interrupt At")) then
                    -- Death Grip
                    if br.isChecked("Death Grip - Int") and br.getDistance(thisUnit) > 8 then
                        if cast.deathGrip(thisUnit) then
                            return
                        end
                    end
                    -- Asphyxiate
                    if br.isChecked("Asphyxiate") and br.getDistance(thisUnit) < 20 and (cd.mindFreeze.remain() > 0 or not br.isChecked("Mind Freeze")) then
                        if cast.asphyxiate(thisUnit) then
                            return
                        end
                    end
                    -- Mind Freeze
                    if br.isChecked("Mind Freeze") and br.getDistance(thisUnit) < 15 then
                        if cast.mindFreeze(thisUnit) then
                            return
                        end
                    end
                end
            end
        end -- End useInterrupts check
    end
    -- end int list

    local function cooldown_List()
        if useCDs() and br.getDistance(units.dyn5) < 5 then
            -- Trinkets
            if br.isChecked("Trinkets") then
                if br.canUseItem(13) then
                    br.useItem(13)
                end
                if br.canUseItem(14) then
                    br.useItem(14)
                end
            end
            if br.isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                if castSpell("player", racial, false, false, false) then
                    return
                end
            end
            -- Dancing Rune Weapon
            if br.isChecked("Dancing Rune Weapon") then
                if cast.dancingRuneWeapon() then
                    return
                end
            end
        end -- End useCooldowns check
    end

    if not inCombat and not hastar and profileStop == true then
        profileStop = false
    elseif (inCombat and profileStop == true) or pause() or mode.rotation == 4 then
        return true
    else
        if key_List() then
            return true
        end

        if extra_List() then
            return
        end

        if defensive_List() then
            return
        end

        --end In Combat check
        if inCombat and profileStop == false and br.isValidUnit(units.dyn5) then
            -- auto_attack
            if br.getDistance("target") < 5 then
                br._G.StartAttack()
            end

            if interrupt_List() then
                return
            end

            if cooldown_List() then
                return
            end

            if damage_List() then
                return
            end
        end
    end
    -- end OoC check
end -- end runrotation

local id = 250
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(
    br.rotations[id],
    {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation
    }
)
