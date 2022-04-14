--Version 1.0.0
local rotationName = "Panglopal" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles()
    local CreateButton = br["CreateButton"]
    br.CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 0, icon = br.player.spell.holyAvenger},
        [2] = {mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.auraMastery},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.absolution}
    }
    CreateButton("Cooldown", 1, 0)
    br.DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 0, icon = br.player.spell.divineProtection},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.blessingOfProtection}
    }
    CreateButton("Defensive", 2, 0)
    br.InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.blindingLight},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.blindingLight}
    }
    CreateButton("Interrupt", 3, 0)
    br.CleanseModes = {
        [1] = {mode = "On", value = 1, overlay = "Cleanse Enabled", tip = "Cleanse Enabled", highlight = 0, icon = br.player.spell.cleanse},
        [2] = {mode = "Off", value = 2, overlay = "Cleanse Disabled", tip = "Cleanse Disabled", highlight = 0, icon = br.player.spell.cleanse}
    }
    CreateButton("Cleanse", 4, 0)
    br.GlimmerModes = {
        [1] = {mode = "On", value = 1, overlay = "Glimmer mode", tip = "Glimmer on", highlight = 0, icon = 287280},
        [2] = {mode = "Off", value = 2, overlay = "Normal", tip = "Glimmer off", highlight = 0, icon = br.player.spell.holyShock},
        [3] = {mode = "Tank", value = 3, overlay = "Normal", tip = "Glimmer on tank", highlight = 0, icon = 278573}
    }
    CreateButton("Glimmer", 5, 0)
    br.DamageModes = {
        [1] = {mode = "On", value = 1, overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 0, icon = br.player.spell.judgment},
        [2] = {mode = "Off", value = 2, overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.judgment}
    }
    CreateButton("Damage", 6, 0)
    br.BeaconModes = {
        [1] = {mode = "1", value = 1, overlay = "Boss1", tip = "1", highlight = 0, icon = br.player.spell.beaconOfLight},
        [2] = {mode = "2", value = 2, overlay = "Boss2", tip = "2", highlight = 0, icon = br.player.spell.beaconOfLight},
        [3] = {mode = "3", value = 3, overlay = "Boss3", tip = "3", highlight = 0, icon = br.player.spell.beaconOfLight},
        [4] = {mode = "Off", value = 4, overlay = "Off", tip = "Off", highlight = 0, icon = br.player.spell.beaconOfLight}
    }
    CreateButton("Beacon", 7, 0)
    br.WrathModes = {
        [1] = {mode = "High", value = 1, overlay = "High Prio HoW", tip = "High Prio HoW", highlight = 1, icon = br.player.spell.hammerOfWrath},
        [2] = {mode = "Low", value = 2, overlay = "Low Prio HoW", tip = "Low Prio HoW", highlight = 0, icon = br.player.spell.hammerOfWrath},
        [3] = {mode = "Off", value = 3, overlay = "HoW Enabled", tip = "HoW Disabled", highlight = 0, icon = br.player.spell.repentance}
    }
    CreateButton("Wrath", 0, 1)
    br.MythicModes = {
        [1] = {mode = "On", value = 1, overlay = "use m+ logic", tip = "m+", highlight = 1, icon = br.player.spell.blessingOfSacrifice},
        [2] = {mode = "Off", value = 2, overlay = "Dont use m+ logic", tip = "not m+", highlight = 0, icon = br.player.spell.blessingOfSacrifice},
    }
    CreateButton("Mythic", 1, 1)
    br.DumpersModes = {
        [1] = {mode = "WoG", value = 1, overlay = "Dump at 5 HP with WoG", tip = "Dump at 5 HP with WoG", highlight = 1, icon = br.player.spell.wordOfGlory},
        [2] = {mode = "LoD", value = 2, overlay = "Dump at 5 HP with LoD", tip = "Dump at 5 HP with LoD", highlight = 1, icon = br.player.spell.lightOfDawn},
        [3] = {mode = "Hold", value = 3, overlay = "Hold HP until needed", tip = "Hold HP until needed", highlight = 0, icon = br.player.spell.absolution},
    }
    CreateButton("Dumpers", 2, 1)
    br.DivineModes = {
        [1] = {mode = "On", value = 1, overlay = "use Divine Toll", tip = "DT ON", highlight = 1, icon = br.player.spell.divineToll},
        [2] = {mode = "Off", value = 2, overlay = "Dont use Divine Toll", tip = "DT OFF", highlight = 0, icon = br.player.spell.divineToll},
    }
    CreateButton("Divine", 7, 1)
end

local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.1")
        --br.ui:createCheckbox(section, "hammer timer")
        --br.ui:createDropdown(section,"Spender Prio", {"Wog","Lod"})
        br.ui:createCheckbox(section, "Raid Boss Helper")
        br.ui:createSpinnerWithout(section, "Flash of Light on KT Mana", 75, 0, 100, 5)
        -- Blessing of Freedom
        br.ui:createCheckbox(section, "Blessing of Freedom")
        br.ui:createCheckbox(section, "Automatic Aura replacement")
        -- Critical
        br.ui:createSpinnerWithout(section, "Critical HP", 30, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Critical Heals")
        br.ui:createCheckbox(section, "Hard Lock Crit Heal")
        br.ui:createCheckbox(section, "OOC Healing", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.", 1)
        br.ui:createCheckbox(section, "OoC Spenders")
        br.ui:checkSectionState(section)
        -- Raid
        --[[         section = br.ui:createSection(br.ui.window.profile, "Raid")
        br.ui:checkSectionState(section) ]]
        -------------------------
        ------ DEFENSIVES -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Basic Healing Module
        br.player.module.BasicHealing(section)
        br.ui:createSpinner(section, "Divine Protection", 60, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Divine Shield", 20, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        -- Gift of The Naaru
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of The Naaru", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        end
        br.ui:checkSectionState(section)
        -------------------------
        ------ Keys -------
        -------------------------

        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        --Hammer of Justice
        br.ui:createCheckbox(section, "Hammer of Justice")
        -- Blinding Light
        br.ui:createCheckbox(section, "Blinding Light")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "InterruptAt", 95, 0, 95, 5, "", "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        ------ COOL  DOWNS ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cool Downs")
        br.ui:createCheckbox(section, "Advanced Trinket Support")
        -- Tuft of Smoldering Plumeage Trinket Support
        br.ui:createSpinner(section, "Tuft of Smoldering Plumeage - min", 1, 0, 100, 5, "", "|cffFFFFFFMin Health Percent to Cast At")
        br.ui:createSpinner(section, "Tuft of Smoldering Plumeage - max", 40, 0, 100, 5, "", "|cffFFFFFFMax Health Percent to Cast At", true)
        br.ui:createDropdownWithout(section, "Tuft of Smoldering Plumeage Target", { "|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFSelf", "|cffFFFFFFHealer/DPS" }, 1, "|cffFFFFFFTarget for Tuft of Smoldering Plumeage")
        -- Lay on Hand
        br.ui:createSpinner(section, "Lay on Hands - min", 20, 0, 100, 5, "", "|cffFFFFFFMin Health Percent to Cast At")
        br.ui:createSpinner(section, "Lay on Hands - max", 20, 0, 100, 5, "", "|cffFFFFFFMax Health Percent to Cast At", true)
        br.ui:createDropdownWithout(section, "Lay on Hands Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFSelf", "|cffFFFFFFHealer/DPS"}, 1, "|cffFFFFFFTarget for LoH")
        -- Blessing of Protection
        br.ui:createSpinner(section, "Blessing of Protection", 20, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "BoP Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFHealer/Damage", "|cffFFFFFFSelf"}, 3, "|cffFFFFFFTarget for BoP")
        -- Blessing of Sacrifice
        br.ui:createSpinner(section, "Blessing of Sacrifice", 40, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "BoS Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFDamage"}, 2, "|cffFFFFFFTarget for BoS")
        br.ui:checkSectionState(section)

        -------------------------
        ---- SINGLE TARGET ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
        br.ui:createDropdown(section, "ST Ham Sandwich (Mouseover)", br.dropOptions.Toggle, 6)
        --Flash of Light
        br.ui:createSpinner(section, "Flash of Light", 70, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "FoL Beacon", 70, 0, 100, 5, "", "Health of Beacon Target to cast FoL At")
        br.ui:createSpinner(section, "FoL Tanks", 70, 0, 100, 5, "", "|cffFFFFFFTanks Health Percent to Cast At", true)
        br.ui:createSpinner(section, "FoL Infuse", 70, 0, 100, 5, "", "|cffFFFFFFIn Infuse buff Health Percent to Cast At", true)
        br.ui:createSpinner(section, "Bestow Faith", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "Bestow Faith Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFSelf"}, 1, "Target for BF")
        
        --Holy Light
        br.ui:createSpinner(section, "Holy Light", 85, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "Holy Light Infuse", {"|cffFFFFFFNormal", "|cffFFFFFFOnly Infuse"}, 2, "|cffFFFFFFOnly Use Infusion Procs.")
        --Holy Shock
        br.ui:createSpinner(section, "Holy Shock", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Self Shock", 35, 0, 100, 5, "")
        --Word of Glory
        br.ui:createSpinner(section, "Word of Glory", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
         --
        --[[ --Bestow Faith
        br.ui:createSpinner(section, "Bestow Faith", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "Bestow Faith Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFSelf", "|cffFFFFFFSelf+LotM"}, 4, "|cffFFFFFFTarget for BF")
        ]] br.ui:createCheckbox(section, "Judgment Heal")
        -- Light of the Martyr
        br.ui:createSpinner(section, "Light of the Martyr", 40, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Moving LotM", 80, 0, 100, 5, "", "|cffFFFFFFisMoving Health Percent to Cast At")
        br.ui:createSpinner(section, "LoM after FoL", 60, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "LotM player HP limit", 50, 0, 100, 5, "", "|cffFFFFFFLight of the Martyr Self HP limit", true)
        br.ui:createSpinner(section, "LoM Maraads", 90, 0, 100, 5, "", "LotM when you have maraads buff")
        br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
        --Trinket?
        --Divine Toll
        br.ui:createDropdown(section, "Divine Toll", {"At 0 Holy Power", "As a Heal"}, 1)
        br.ui:createSpinnerWithout(section, "Divine Toll Units", 3, 1, 5, 1)
        br.ui:createSpinnerWithout(section, "Divine Toll Health", 70, 0, 100, 1)
        br.ui:createSpinnerWithout(section, "Max Holy Power", 2, 0, 5, 1, "Only use Divine Toll when at or below this value")
        -- Rule of Law
        br.ui:createSpinner(section, "Rule of Law", 70, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "RoL Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum RoL Targets", true)
        -- Light of Dawn
        br.ui:createSpinner(section, "Light of Dawn", 90, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "LoD Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum LoD Targets", true)
        -- Beacon of Virtue
        br.ui:createSpinner(section, "Beacon of Virtue", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "BoV Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum BoV Targets", true)
        -- Holy Prism
        br.ui:createSpinner(section, "Holy Prism", 90, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Holy Prism Targets", 3, 0, 5, 1, "", "|cffFFFFFFMinimum Holy Prism Targets", true)
        br.ui:createSpinner(section, "Light's Hammer", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Light's Hammer Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Light's Hammer Targets", true)
        br.ui:checkSectionState(section)
        -------------------------
        ---------- DPS ----------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "DPS")
        br.ui:createDropdown(section, "Hard DPS Key", br.dropOptions.Toggle, 6)
        br.ui:createSpinner(section, "Divine Toll during DPS Key", 3, 1, 5, 1, "Use Divine Toll at >= x units")
        br.ui:createCheckbox(section, "Auto Focus target")
        -- Consecration
        br.ui:createSpinner(section, "Consecration", 1, 0, 40, 1, "", "|cffFFFFFFMinimum Consecration Targets")
        --[[ -- Holy Prism
        br.ui:createSpinner(section, "Holy Prism Damage", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Holy Prism Targets")
        -- Light's Hammer
        br.ui:createSpinner(section, "Light's Hammer Damage", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Light's Hammer Targets") ]]
        -- Judgment
        br.ui:createCheckbox(section, "Judgment - DPS")
        -- Holy Shock
        br.ui:createCheckbox(section, "Holy Shock Damage")
        --br.ui:createCheckbox(section, "Aggressive Glimmer", "tries to keep one glimmer on target")
        -- Shield of the Righteous
        br.ui:createSpinner(section, "Shield of the Righteous", 1, 0, 40, 1, "", "|cffFFFFFFMinimum Shield of the Righteous Targets")
        -- Crusader Strike
        br.ui:createCheckbox(section, "Crusader Strike")
        br.ui:createCheckbox(section, "High Prio Crusader Strike", "Prioritise CStrike with Crusaders might talent")
        br.ui:checkSectionState(section)
    end
    local function OtherStuff()
        section = br.ui:createSection(br.ui.window.profile, "Devstuff")
        br.ui:createCheckbox(section, "Dev Stuff Leave off")
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        },
        {
            [1] = "Other Options",
            [2] = OtherStuff
        }
    }
    return optionTable
end
local setwindow = false
local function runRotation()
    if br.UnitDebuffID("player", 307161) then
        return true
    end
    if setwindow == false then
        br._G.RunMacroText("/console SpellQueueWindow 0")
        --br.player.ui.print("Set SQW")
        setwindow = true
    end

    local holyPower = br.player.power.holyPower.amount()
    local holyPowerMax = br.player.power.holyPower.max()
    local mana = br.getMana("player")
    local buff = br.player.buff
    local cast = br.player.cast
    local php = br.player.health
    local spell = br.player.spell
    local item = br.player.items
    local equiped = br.player.equiped
    local talent = br.player.talent
    local essence = br.player.essence
    local gcd = br.player.gcdMax
    local charges = br.player.charges
    local cd = br.player.cd
    local debuff = br.player.debuff
    local drinking = br.getBuffRemain("player", 192002) ~= 0 or br.getBuffRemain("player", 167152) ~= 0 or br.getBuffRemain("player", 192001) ~= 0
    local inInstance = br.player.instance == "party" or br.player.instance == "scenario" or br.player.instance == "pvp" or br.player.instance == "arena"
    local inRaid = br.player.instance == "raid"
    local solo = #br.friend == 1
    local OWGroup = br.player.instance == "none" and #br.friend >= 2
    local race = br.player.race
    local racial = br.player.getRacial()
    local traits = br.player.traits
    local tanks = br.getTanksTable()
    local lowest = br.friend[1]
    local friends = friends or {}
    local module = br.player.module
    local glimmerCount = 0
    local enemies = br.player.enemies
    local mode = br.player.ui.mode
    local pullTimer = br.DBM:getPulltimer()
    local units = br.player.units
    local LightCount = 0
    local FaithCount = 0
    local ui = br.player.ui
    local unit  = br.player.unit
    local wingsup = buff.avengingCrusader.exists("player") or buff.avengingWrath.exists("player")
    local tier = br.TierScan("T28")

    if br.timer:useTimer("random_timer", 10) then
        tuftTargetHP = math.random(ui.value("Tuft of Smoldering Plumeage - min"), ui.value("Tuft of Smoldering Plumeage - max"))
    end

    if br.player.runeforge.shadowbreaker.equiped then
        lightOfDawn_distance = 40
    else
        lightOfDawn_distance = 15
    end
    if buff.ruleOfLaw.exists("player") then
        lightOfDawn_distance_coff = 1.5
    else
        lightOfDawn_distance_coff = 1
    end

    local biggestGroup = 0
    local bestUnit
    for i = 1, #br.friend do
        local thisUnit = br.friend[i].unit
        local thisGroup = #br.getUnitsToHealAround(thisUnit, 6, ui.value("Light's Hammer"), ui.value("Light's Hammer Targets"))
        local tankGroup = 0
        if #tanks > 0 then
            tankGroup = #br.getUnitsToHealAround(tanks[1].unit, 6, ui.value("Light's Hammer"), ui.value("Light's Hammer Targets"))
        end

        if thisGroup > biggestGroup then
            biggestGroup = thisGroup
            bestUnit = thisUnit
        end
        if #tanks > 0 then
            if tankGroup == biggestGroup then
                biggestGroup = tankGroup
                bestUnit = tanks[1].unit
            end
        end
    end

    --[[ if br.timer:useTimer("hammer timer", 3) then
        ui.print("Biggest Group Number - ".. #br.friend)
    end ]]

    local lowest = {}
    lowest.unit = "player"
    lowest.hp = php

    for i = 1, #br.friend do
        if br.friend[i].hp < lowest.hp and br.getLineOfSight(br.friend[i].unit, "player") and not unit.deadOrGhost(br.friend[i].unit) then
            lowest = br.friend[i]
        end
    end
    local lowestNP = {}
    if #br.friend > 1 then
        lowestNP.unit = br.friend[2].unit
        lowestNP.hp = 150
        for i = 1, #br.friend do
            if not br.GetUnitIsUnit(br.friend[i].unit, "player") and br.friend[i].hp < lowestNP.hp and br.getLineOfSight(br.friend[i].unit, "player") and not unit.deadOrGhost(br.friend[i].unit) then
                lowestNP = br.friend[i]
            end
        end
    end



    local function ccDoubleCheck(unit)
        if br.getOptionCheck("Don't break CCs") and br.isLongTimeCCed(unit) then
            return false
        else
            return true
        end
    end

    local lowestBeacon = {}
    lowestBeacon.unit = nil
    lowestBeacon.hp = 100

    for i = 1, #br.friend do
        if buff.beaconOfLight.exists(br.friend[i].unit) or buff.beaconOfVirtue.exists(br.friend[i].unit) or buff.beaconOfFaith.exists(br.friend[i].unit) then
            if br.friend[i].hp <= lowestBeacon.hp and br.getLineOfSight(br.friend[i].unit, "player") and not unit.deadOrGhost(br.friend[i].unit) then
                lowestBeacon = br.friend[i]
            end
        end
    end

    for i = 1, #br.friend do
        if buff.glimmerOfLight.remain(br.friend[i].unit) > gcd then
            glimmerCount = glimmerCount + 1
        end
    end

    if cast.current.holyLight() and not buff.infusionOfLight.exists("player") and ui.value("Holy Light Infuse") == 2 then
        br._G.SpellStopCasting()
    end

    units.get(5)
    --units.get(8)
    --units.get(15)
    units.get(30)
    --units.get(40)
    enemies.get(5)
    --enemies.get(8)
    enemies.get(10)
    --enemies.get(15)
    enemies.get(30)
    enemies.get(40)
    --friends.yards40 = br.getAllies("player", 40)

    if br.timersTable then
        wipe(br.timersTable)
    end

    local function pallyFace(spell,target)
        if ui.checked("Dev Stuff Leave off") and select(4,GetSpellInfo(spell)) == 0 and br.getSpellCD(spell) == 0 then
            if target == nil then
                if spell == 35395 then
                    for i = 1, #enemies.yards5 do
                        if unit.exists("target") and unit.distance("target") <= 5 and not unit.isUnit("target","player") then
                            target = "target"
                        else
                            target = enemies.yards5[i]
                        end
                    end
                end
                if spell == 24275 or spell == 275773 or spell == 20473 or spell == 328204 then
                    for i = 1, #enemies.yards30 do
                        if unit.exists("target") and unit.distance("target") <= 30 and not unit.isUnit("target","player") then
                            target = "target"
                        else
                            target = enemies.yards30[i]
                        end
                    end
                end
            end
            if unit.valid(target) then
                --ui.print("Facing target")
                local curFacing = br._G.ObjectFacing("player")
                br._G.FaceDirection(target)
                --ui.print("casting " .. spell)
                br._G.CastSpellByName(br._G.GetSpellInfo(spell),target)
                --ui.print("Facing back")
                br._G.FaceDirection(curFacing)
            end
        else
            if not ui.checked("Dev Stuff Leave off") and br.getSpellCD(spell) == 0 then
                if target ==  nil then
                    if spell == 35395 then
                        target = units.dyn5
                    end
                    if spell == 24275 or spell == 275773 or spell == 20473 or spell == 328204 then
                        target = units.dyn30
                    end
                end
                if unit.valid(target) then
                    if unit.facing("player", target) then
                        br._G.CastSpellByName(br._G.GetSpellInfo(spell),target)
                    end
                end
            end
        end
    end

    local function bestConeHeal(spell, minUnits, health, angle, rangeInfront, rangeAround, unit)
        
        if not br.isKnown(spell) or br.getSpellCD(spell) ~= 0 or select(2, br._G.IsUsableSpell(spell)) then
            return false
        end
        local curFacing = br._G.ObjectFacing("player")
        local playerX, playerY, playerZ = br._G.ObjectPosition("player")
        local coneTable = {}

        local unitsAround = 0
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            if br.friend[i].hp < health then
                if br.friend[i].distance < rangeAround then
                    unitsAround = unitsAround + 1
                elseif br.friend[i].distance < rangeInfront then
                    local unitX, unitY, unitZ = br._G.ObjectPosition(thisUnit)
                    if playerX and unitX then
                        local angleToUnit = select(1,br._G.GetAnglesBetweenObjects("player",thisUnit))
                        tinsert(coneTable, angleToUnit)
                    end
                end
            end
        end
        local facing, bestAngle, bestAngleUnitsHit = 0.1, 0, 0
        while facing <= 6.2 do
            local unitsHit = unitsAround
            for i = 1, #coneTable do
                local angleToUnit = coneTable[i]
                local angleDifference = facing > angleToUnit and facing - angleToUnit or angleToUnit - facing
                --local shortestAngle = angleDifference < math.pi and angleDifference or math.pi * 2 - angleDifference
                local finalAngle = angleDifference / math.pi * 180
                if finalAngle < angle then
                    unitsHit = unitsHit + 1
                end
            end
            if unitsHit > bestAngleUnitsHit then
                bestAngleUnitsHit = unitsHit
                bestAngle = facing
            end
            facing = facing + 0.05
        end
        if bestAngleUnitsHit >= minUnits then
			br._G.FaceDirection(bestAngle, true)
			br._G.CastSpellByName(br._G.GetSpellInfo(spell),unit)
			br._G.FaceDirection(curFacing)
			lodFaced = true
            return true
        end
        return false
    end

    if ui.checked("Raid Boss Helper") then
        
        if br.pause(true) and unit.inCombat() then
            return true
        end
        if (br._G.ObjectID("target") == 165759 or br._G.ObjectID("target") == 171577 or br._G.ObjectID("target") == 173112) and unit.inCombat() then
            if unit.hp("target") < 100 then
                if not buff.beaconOfLight.exists("target") and br._G.ObjectID("target") == 165759 then
                    if cast.beaconOfLight("target") then
                        return true
                    end
                end 
                br._G.CastSpellByName(br._G.GetSpellInfo(85673))
                if holyPower < 3 and not ((cast.current.flashOfLight() or cast.current.holyLight()) and buff.holyAvenger.exists("player")) then
                    if cast.holyShock("target") then
                        return true
                    end
                end
                if br._G.ObjectID("target") == 165759 then
                    local Trinket13 = _G.GetInventoryItemID("player", 13)
                    local Trinket14 = _G.GetInventoryItemID("player", 14)
                    -- Tuft Logic
                    if (Trinket13 == 184020 or Trinket14 == 184020) then
                        if br.canUseItem(184020) then
                            br._G.UseItemByName(184020, "target")
                            return true
                        end
                    end
                end 
                if cast.bestowFaith("target") then
                    return true
                end
                if not cast.able.wordOfGlory() and mana >= ui.value("Flash of Light on KT Mana") and not (holyPower > 2) then
                    if cast.flashOfLight("target") then
                        return true
                    end
                end
                if br._G.ObjectID("target") == 165759 and mana < ui.value("Flash of Light on KT Mana") then
                    if cast.holyLight("target") then
                        return true
                    end
                end
            end
            return true
        end
    end

    if unit.inCombat() and ui.checked("Beacon of Virtue") and br.getSpellCD(200025) == 0 and not br._G.IsMounted() then
        
        if br.getLowAllies(ui.value("Beacon of Virtue")) >= ui.value("BoV Targets") then
            if cast.beaconOfVirtue(lowest.unit) then
                return true
            end
        end
    end
    --[[ local function dumpers()

    end ]]
    local function hamSammy()
        
        if holyPower >= 3 then
            if cast.wordOfGlory("mouseover") then
                return true
            end
        end

        if br.getSpellCD(20473) == 0 then
            if cast.holyShock("mouseover") then
                return true
            end
        end

        if br.getSpellCD(200025) == 0 then
            if cast.beaconOfVirtue("mouseover") then
                return true
            end
        end

        if buff.beaconOfVirtue.exists("mouseover") and php >= ui.value("LotM player HP limit") and not br.GetUnitIsUnit("mouseover", "player") then
            if cast.lightOfTheMartyr("mouseover") then
                return true
            end
        end

        if buff.beaconOfLight.exists("mouseover") or buff.beaconOfFaith.exists("mouseover") then
            if cast.flashOfLight("mouseover") then
                return true
            end
        end

        if php >= ui.value("LotM player HP limit") and not br.GetUnitIsUnit("mouseover", "player") then
            if cast.lightOfTheMartyr("mouseover") then
                return true
            end
        end

        if cast.flashOfLight("mouseover") then
            return true
        end
    end
    
    local function spendies()
        if ui.checked("Word of Glory") and (holyPower >= 3 or buff.divinePurpose.exists() or (tier >= 2 and not debuff.dawnWillCome.exists("player"))) then
            --Critical first
            if (tier >= 2 and not debuff.dawnWillCome.exists("player")) and not br.player.covenant.necrolord.active then
                if cast.wordOfGlory(lowest.unit) then
                    return true
                end
            end
            if php <= ui.value("Critical HP") then
                if cast.wordOfGlory("player") then
                    return true
                end
            end
            if lowest.hp <= ui.value("Word of Glory") then
                if cast.wordOfGlory(lowest.unit) then
                    return true
                end
            end
        end

        if php >= ui.value("LotM player HP limit") and #br.friend > 1 then
            if not br.GetUnitIsUnit(lowestNP.unit, "player") and not unit.deadOrGhost(lowestNP.unit) then
                if ui.checked("LoM Maraads") and ((lowest.hp <= ui.value("LoM Maraads") and buff.maraadsBreath.exists("player")) or (buff.untemperedDedication.remains("player") <= 3 and br.player.runeforge.shadowbreaker.equiped)) then
                    if cast.lightOfTheMartyr(lowestNP.unit) then
                        return true
                    end
                end
            end
        end

        if (holyPower >= 3 or buff.divinePurpose.exists()) and buff.vanquishersHammer.exists("player") then
            local LoDHealth = ui.value("Light of Dawn")
            local LoDUnits = ui.value("LoD Targets")
            if bestConeHeal(spell.wordOfGlory, LoDUnits, LoDHealth, 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5, lowest.unit) then
                return true
            end
        end

        if ui.checked("Light of Dawn") and (holyPower >= 3 or buff.divinePurpose.exists()) then
            local LoDHealth = ui.value("Light of Dawn")
            local LoDUnits = ui.value("LoD Targets")
            if bestConeHeal(spell.lightOfDawn, LoDUnits, LoDHealth, 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5, nil) then
                return true
            end
        end

        if holyPower == 5 then
            if buff.vanquishersHammer.exists("player") then
                if bestConeHeal(spell.wordOfGlory, 1, 200, 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5, lowest.unit) then
                    return true
                end
            elseif mode.dumpers == 1 and not buff.vanquishersHammer.exists("player")then
                if cast.wordOfGlory(lowest.unit) then
                    return true
                end
            elseif mode.dumpers == 2 then
                if bestConeHeal(spell.lightOfDawn, 1, 200, 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5, nil) then
                    return true
                end
            end
        end
    end
    local function bigDPS()
        if buff.avengingWrath.exists("player") and ui.checked("Shield of the Righteous") and br.getLowAllies(ui.value("Light of Dawn")) < ui.value("LoD Targets") and lowest.hp >= ui.value("Word of Glory") and cast.able.shieldOfTheRighteous() and #enemies.yards5 >= ui.value("Shield of the Righteous") and (holyPower >= 3 or buff.divinePurpose.exists()) then
            if cast.shieldOfTheRighteous(units.dyn5) then
                return true
            end
        end
        
        if (unit.hp("target") <= 20 or br._G.IsSpellOverlayed(24275) or wingsup) and unit.facing("player", "target")  then
            if cast.hammerOfWrath("target") then
                return
            end
        end

        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if ccDoubleCheck(thisUnit) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", thisUnit)) and holyPower < 5 then
                if unit.hp(thisUnit) <= 20 or br._G.IsSpellOverlayed(24275) or wingsup then
                    ui.debug("Trying to hammer aoe 2")
                    if pallyFace(spell.hammerOfWrath,thisUnit) then
                        return
                    end
                end
            end
        end

        if spendies() then
            return
        end

        if ui.checked("Consecration") and br.getSpellCD(26573) == 0 and #enemies.yards5 >= ui.value("Consecration") and br.getDebuffRemain("target", 204242) == 0 and (not br._G.GetTotemInfo(1) or (br.getDistanceToObject("player", cX, cY, cZ) > 7) or br._G.GetTotemTimeLeft(1) < 2) then
            if cast.consecration() then
                cX, cY, cZ = br._G.ObjectPosition("player")
                return
            end
        end

        if mode.divine == 1 then
            if ui.checked("Divine Toll during DPS Key") and br.getSpellCD(304971) == 0 and #enemies.yards30 >= ui.value("Divine Toll during DPS Key") and not br.GetUnitIsFriend("target", "player") then
                br._G.CastSpellByName(br._G.GetSpellInfo(spell.divineToll),"target")
            end
        end

        if br.getSpellCD(20473) == 0 then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if ccDoubleCheck(thisUnit) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", thisUnit)) and not debuff.glimmerOfLight.exists(thisUnit, "player") and not unit.deadOrGhost(thisUnit) and br.getLineOfSight(thisUnit, "player") then
                    --ui.print("Holy Shock 11a: on " .. thisUnit)
                    if pallyFace(spell.holyShock,thisUnit) then
                        return
                    end
                end
            end
            if br.getSpellCD(20473) == 0 and (ui.checked("Dev Stuff Leave off") or unit.facing("player", "target")) then
                --ui.print("Holy Shock 12a")
                if pallyFace(spell.holyShock,"target") then
                    return
                end
            end
        end

        if ui.checked("Crusader Strike") and (br.getSpellCD(20473) > (gcd) or not ui.checked("Holy Shock Damage")) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", units.dyn5)) then
            if pallyFace(spell.crusaderStrike) then
                return true
            end
        end

        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if ccDoubleCheck(thisUnit) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", thisUnit)) and not unit.deadOrGhost(thisUnit) then
                if ui.checked("Auto Focus target") and not unit.exists("target") and not unit.deadOrGhost("focustarget") and unit.inCombat("focustarget") and unit.threat("focustarget") then
                    br._G.TargetUnit("focustarget")
                end
                -- Start Attack
                if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.valid("target") and unit.distance("target") <= 5 then
                    br._G.StartAttack()
                end
                -- Judgment
                if not debuff.judgmentOfLight.exists("target") and talent.judgmentOfLight then
                    thisUnit = "target"
                end
                if ui.checked("Judgment - DPS") and br.getSpellCD(20473) > (gcd + 0.3) then
                    if pallyFace(275773,thisUnit) then
                        return true
                    end
                end
            end
        end
    end


    local function defensiveTime()
        
        if br.useDefensive() then
            module.BasicHealing()

            if ui.checked("Gift of The Naaru") and php <= ui.value("Gift of The Naaru") and php > 0 and race == "Draenei" then
                if br.castSpell("player", racial, false, false, false) then
                    return true
                end
            end

            if ui.checked("Divine Shield") and cast.able.divineShield() then
                if php <= ui.value("Divine Shield") and not br.UnitDebuffID("player", 25771) then
                    if cast.divineShield("player") then
                        return true
                    end
                end
            end

            if ui.checked("Divine Protection") and cast.able.divineProtection() and not buff.divineShield.exists("player") then
                if php <= ui.value("Divine Protection") then
                    if cast.divineProtection() then
                        return true
                    end
                elseif buff.blessingOfSacrifice.exists("player") then
                    if cast.divineProtection() then
                        return true
                    end
                end
            end
        end
    end
     -- end defensive list

    local function bellsAndWhistles()
        
        -- cleanse your friends
        if mode.cleanse == 1 and not cd.cleanse.exists() then
            for i = 1, #br.friend do
                if br.canDispel(br.friend[i].unit, spell.cleanse) and br.getLineOfSight(br.friend[i].unit) and unit.distance(br.friend[i].unit) <= 40 then
                    if cast.cleanse(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end

        -- Interrupt your enemies
        if br.useInterrupts() and (cast.able.blindingLight() or cast.able.hammerOfJustice()) then
            for i = 1, #enemies.yards10 do
                local thisUnit = enemies.yards10[i]
                local distance = unit.distance(thisUnit)
                if br.canInterrupt(thisUnit, ui.value("InterruptAt")) and distance <= 10 then
                    -- Blinding Light
                    if ui.checked("Blinding Light") and cast.able.blindingLight() then
                        if cast.blindingLight() then
                            return true
                        end
                    end
                    -- Hammer of Justice
                    if ui.checked("Hammer of Justice") and cast.able.hammerOfJustice() and br.getBuffRemain(thisUnit, 226510) == 0 then
                        if cast.hammerOfJustice(thisUnit) then
                            return true
                        end
                    end
                end
            end
        end
    end

    local function Beacon() -- 100% credit to Laksmackt
        
        local beaconOfLightinRaid = nil
        local beaconOfLightTANK = nil
        local beaconOfFaithTANK = nil
        local beaconOfFaithplayer = nil
        for i = 1, #br.friend do
            if br._G.UnitInRange(br.friend[i].unit) then
                if buff.beaconOfLight.exists(br.friend[i].unit) and br.friend[i].role == "TANK" then
                    LightCount = LightCount + 1
                end
                if buff.beaconOfFaith.exists(br.friend[i].unit) then
                    FaithCount = FaithCount + 1
                end
            end
        end
        if mode.beacon == 1 and (inInstance or inRaid or OWGroup) and #tanks > 0 then
            for i = 1, #br.friend do
                if br._G.UnitInRange(br.friend[i].unit) and not unit.deadOrGhost(br.friend[i].unit) then
                    if (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") and br.GetUnitIsUnit(br.friend[i].unit, "boss1target") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfLightinRaid = br.friend[i].unit
                    end
                    if LightCount < 1 and (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfLightTANK = br.friend[i].unit
                    end
                    if FaithCount < 1 and (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfFaithTANK = br.friend[i].unit
                    end
                end
            end
        end
        if mode.beacon == 2 and (inInstance or inRaid or OWGroup) and #tanks > 0 then
            for i = 1, #br.friend do
                if br._G.UnitInRange(br.friend[i].unit) and not unit.deadOrGhost(br.friend[i].unit) then
                    if (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") and br.GetUnitIsUnit(br.friend[i].unit, "boss2target") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfLightinRaid = br.friend[i].unit
                    end
                    if LightCount < 1 and (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfLightTANK = br.friend[i].unit
                    end
                    if FaithCount < 1 and (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfFaithTANK = br.friend[i].unit
                    end
                end
            end
        end
        if mode.beacon == 3 and (inInstance or inRaid or OWGroup) and #tanks > 0 then
            for i = 1, #br.friend do
                if br._G.UnitInRange(br.friend[i].unit) and not unit.deadOrGhost(br.friend[i].unit) then
                    if (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") and br.GetUnitIsUnit(br.friend[i].unit, "boss3target") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfLightinRaid = br.friend[i].unit
                    end
                    if LightCount < 1 and (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfLightTANK = br.friend[i].unit
                    end
                    if FaithCount < 1 and (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfFaithTANK = br.friend[i].unit
                    end
                end
            end
        end
        if inRaid and beaconOfLightinRaid ~= nil then
            if cast.beaconOfLight(beaconOfLightinRaid) then
                return true
            end
        end
        if beaconOfLightTANK ~= nil and not cast.last.beaconOfLight() then
            if cast.beaconOfLight(beaconOfLightTANK) then
                return true
            end
        end
        if talent.beaconOfFaith then
            if beaconOfFaithTANK ~= nil then
                if cast.beaconOfFaith(beaconOfFaithTANK) then
                    return true
                end
            end
            if not inRaid and not buff.beaconOfFaith.exists("player") then
                if cast.beaconOfFaith("player") then
                    return true
                end
            end
        end
    end

    local function Coolies()
        
        local blessingOfProtectionall = nil
        local blessingOfProtectionTANK = nil
        local blessingOfProtectionHD = nil
        local blessingOfSacrificeall = nil
        local blessingOfSacrificeTANK = nil
        local blessingOfSacrificeDAMAGER = nil
        local layOnHandsTarget = nil

        -- for bop target / BoS target
        for i = 1, #br.friend do
            if br.friend[i].hp < 100 and br._G.UnitInRange(br.friend[i].unit) and not br.UnitDebuffID(br.friend[i].unit, 25771) and not unit.deadOrGhost(br.friend[i].unit) then
                if br.friend[i].hp <= ui.value("Blessing of Protection") then
                    blessingOfProtectionall = br.friend[i].unit
                end
                if br.friend[i].hp <= ui.value("Blessing of Protection") and (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") then
                    blessingOfProtectionTANK = br.friend[i].unit
                end
                if br.friend[i].hp <= ui.value("Blessing of Protection") and (unit.role(br.friend[i].unit) == "HEALER" or unit.role(br.friend[i].unit) == "DAMAGER") then
                    blessingOfProtectionHD = br.friend[i].unit
                end
                if br.friend[i].hp <= ui.value("Blessing of Sacrifice") and not br.GetUnitIsUnit(br.friend[i].unit, "player") then
                    blessingOfSacrificeall = br.friend[i].unit
                end
                if br.friend[i].hp <= ui.value("Blessing of Sacrifice") and (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") then
                    blessingOfSacrificeTANK = br.friend[i].unit
                end
                if br.friend[i].hp <= ui.value("Blessing of Sacrifice") and unit.role(br.friend[i].unit) == "DAMAGER" then
                    blessingOfSacrificeDAMAGER = br.friend[i].unit
                end
            end
        end

        if ui.checked("Blessing of Protection") and cast.able.blessingOfProtection() and not unit.exists("boss1") then
            if ui.value("BoP Target") == 1 then
                if blessingOfProtectionall ~= nil then
                    if cast.blessingOfProtection(blessingOfProtectionall) then
                        return true
                    end
                end
            elseif ui.value("BoP Target") == 2 then
                if blessingOfProtectionTANK ~= nil then
                    if cast.blessingOfProtection(blessingOfProtectionTANK) then
                        return true
                    end
                end
            elseif ui.value("BoP Target") == 3 then
                if blessingOfProtectionHD ~= nil then
                    if cast.blessingOfProtection(blessingOfProtectionHD) then
                        return true
                    end
                end
            elseif ui.value("BoP Target") == 4 then
                if php <= ui.value("Blessing of Protection") then
                    if cast.blessingOfProtection("player") then
                        return true
                    end
                end
            end
        end

        --get lay-d
        if ui.checked("Lay on Hands - min") and br.getSpellCD(633) == 0 then
            for i = 1, #br.friend do
                if br.friend[i].hp < 100 and br._G.UnitInRange(br.friend[i].unit) and not br.UnitDebuffID(br.friend[i].unit, 25771) and not unit.deadOrGhost(br.friend[i].unit) and not br.UnitBuffID(br.friend[i].unit, 344916) then
                    if ui.value("Lay on Hands Target") == 1 then
                        if br.friend[i].hp <= math.random(ui.value("Lay on Hands - min"), ui.value("Lay on Hands - max")) and (solo or OWGroup or inRaid or (inInstance)) then
                            layOnHandsTarget = br.friend[i].unit
                        end
                    elseif ui.value("Lay on Hands Target") == 2 then
                        if br.friend[i].hp <= math.random(ui.value("Lay on Hands - min"), ui.value("Lay on Hands - max")) and (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") and (not inInstance or (inInstance)) then
                            layOnHandsTarget = br.friend[i].unit
                        end
                    elseif ui.value("Lay on Hands Target") == 3 and br.getDebuffRemain("player", 267037) == 0 and php <= math.random(ui.value("Lay on Hands - min"), ui.value("Lay on Hands - max")) then
                        layOnHandsTarget = "player"
                    elseif ui.value("Lay on Hands Target") == 4 then
                        if unit.role(br.friend[i].unit) == "HEALER" or unit.role(lowest.unit) == "DAMAGER" then
                            if br.friend[i].hp <= math.random(ui.value("Lay on Hands - min"), ui.value("Lay on Hands - max")) and (not inInstance or (inInstance)) then
                                layOnHandsTarget = br.friend[i].unit
                            end
                        end
                    end
                    if layOnHandsTarget ~= nil then
                        if cast.layOnHands(layOnHandsTarget) then
                            return true
                        end
                    end
                end
            end
        end

        -- Cast BoS
        if ui.checked("Blessing of Sacrifice") and cast.able.blessingOfSacrifice() then
            if ui.value("BoS Target") == 1 then
                if blessingOfSacrificeall ~= nil then
                    if cast.blessingOfSacrifice(blessingOfSacrificeall) then
                        return true
                    end
                end
            elseif ui.value("BoS Target") == 2 then
                if blessingOfSacrificeTANK ~= nil then
                    if cast.blessingOfSacrifice(blessingOfSacrificeTANK) then
                        return true
                    end
                end
            elseif ui.value("BoS Target") == 3 then
                if blessingOfSacrificeDAMAGER ~= nil then
                    if cast.blessingOfSacrifice(blessingOfSacrificeDAMAGER) then
                        return true
                    end
                end
            end
        end

        -- Holy Avenger
        if ui.checked("Holy Avenger") and cast.able.holyAvenger() and talent.holyAvenger then
            if br.getLowAllies(ui.value "Holy Avenger") >= ui.value("Holy Avenger Targets") then
                if cast.holyAvenger() then
                    return true
                end
            end
        end
        -- Avenging Wrath
        if ui.checked("Avenging Wrath") and cast.able.avengingWrath() and not talent.avengingCrusader then
            if br.getLowAllies(ui.value "Avenging Wrath") >= ui.value("Avenging Wrath Targets") then
                if cast.avengingWrath() then
                    return true
                end
            end
        end
        -- Avenging Crusader
        if ui.checked("Avenging Crusader") and cast.able.avengingCrusader() and talent.avengingCrusader and unit.distance("target") <= 5 then
            if br.getLowAllies(ui.value "Avenging Crusader") >= ui.value("Avenging Crusader Targets") then
                if cast.avengingCrusader() then
                    return true
                end
            end
        end
        -- Aura Mastery
        if ui.checked("Aura Mastery") and cast.able.auraMastery() then
            if br.getLowAllies(ui.value "Aura Mastery") >= ui.value("Aura Mastery Targets") then
                if cast.auraMastery() then
                    return true
                end
            end
        end
        if ui.checked("Rule of Law") and cast.able.ruleOfLaw() and talent.ruleOfLaw and not buff.ruleOfLaw.exists("player") then
            if br.getLowAllies(ui.value("Rule of Law")) >= ui.value("RoL Targets") then
                if cast.ruleOfLaw() then
                    return
                end
            end
        end
    end
     -- end coolies

    local function damageTime()
        
        if mode.damage == 1 then
            if buff.avengingWrath.exists("player") and ui.checked("Shield of the Righteous") and br.getLowAllies(ui.value("Light of Dawn")) < ui.value("LoD Targets") and lowest.hp >= ui.value("Word of Glory") and cast.able.shieldOfTheRighteous() and #enemies.yards5 >= ui.value("Shield of the Righteous") and (holyPower >= 3 or buff.divinePurpose.exists()) then
                if cast.shieldOfTheRighteous(units.dyn5) then
                    return true
                end
            end
            if ui.checked("Holy Shock Damage") and lowest.hp > ui.value("Holy Shock") and br.getSpellCD(20473) == 0 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if ccDoubleCheck(thisUnit) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", thisUnit)) and not debuff.glimmerOfLight.exists(thisUnit, "player") and not unit.deadOrGhost(thisUnit) and br.getLineOfSight(thisUnit, "player") then
                        --ui.print("Holy Shock 11: on " .. thisUnit)
                        if pallyFace(spell.holyShock,thisUnit) then
                            return
                        end
                    end
                end
                if br.getSpellCD(20473) == 0 and (ui.checked("Dev Stuff Leave off") or unit.facing("player", "target")) then
                    --ui.print("Holy Shock 12")
                    if pallyFace(spell.holyShock,"target") then
                        return
                    end
                end
            end

            --Consecration
            if ui.checked("Consecration") and br.getSpellCD(26573) == 0 and #enemies.yards5 >= ui.value("Consecration") and br.getDebuffRemain("target", 204242) == 0 and (not br._G.GetTotemInfo(1) or (br.getDistanceToObject("player", cX, cY, cZ) > 7) or br._G.GetTotemTimeLeft(1) < 2) then
                if cast.consecration() then
                    cX, cY, cZ = br._G.ObjectPosition("player")
                    return
                end
            end
            if mode.wrath == 2 and br.getSpellCD(24275) == 0 then
                if (unit.hp("target") <= 20 or br._G.IsSpellOverlayed(24275) or wingsup) and unit.facing("player", "target") then
                    if cast.hammerOfWrath("target") then
                        return
                    end
                end
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if ccDoubleCheck(thisUnit) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", thisUnit)) and holyPower < 5 then
                        if unit.hp(thisUnit) <= 20 or br._G.IsSpellOverlayed(24275) or wingsup then
                            ui.debug("Trying to hammer aoe 3")
                            if pallyFace(spell.hammerOfWrath,thisUnit) then
                                return
                            end
                        end
                    end
                end
            end
            if ui.checked("Crusader Strike") and br.getSpellCD(20473) > (gcd) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", units.dyn5)) then
                if pallyFace(spell.crusaderStrike) then
                    return true
                end
            end

            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if ccDoubleCheck(thisUnit) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", thisUnit)) and not unit.deadOrGhost(thisUnit) then
                    if ui.checked("Auto Focus target") and not unit.exists("target") and not unit.deadOrGhost("focustarget") and unit.inCombat("focustarget") and unit.threat("focustarget") then
                        br._G.TargetUnit("focustarget")
                    end
                    -- Start Attack
                    if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.valid("target") and unit.distance("target") <= 5 then
                        br._G.StartAttack()
                    end
                    -- Judgment
                    if not debuff.judgmentOfLight.exists("target") and talent.judgmentOfLight then
                        thisUnit = "target"
                    end
                    if ui.checked("Judgment - DPS") then
                        if pallyFace(275773,thisUnit) then
                            return
                        end
                    end
                end
            end
        end
    end
     -- end of dps

    local function healingTime()
        
        --Divine Toll Implementation
        if mode.divine == 1 then
            if ui.checked("Divine Toll") and br.getSpellCD(304971) == 0 and holyPower <= ui.value("Max Holy Power") and unit.inCombat() then
                if ui.value("Divine Toll") == 1 and holyPower == 0 then
                    --Print("trying to cast")
                    br._G.CastSpellByName(br._G.GetSpellInfo(spell.divineToll), lowest.unit)
                    return true
                end
                if ui.value("Divine Toll") == 2 then
                    if br.getLowAllies(ui.value("Divine Toll Health")) >= ui.value("Divine Toll Units") then
                        --Print("trying to cast")
                        br._G.CastSpellByName(br._G.GetSpellInfo(spell.divineToll), lowest.unit)
                        return true
                    end
                end
            end
        end
        --[[ if br.timer:useTimer("hammer timer", 3) then
            local test1 = ui.checked("Light's Hammer")
            local test2 = ui.value("Light's Hammer")
            local test3 = ui.value("Light's Hammer Targets")
            ui.print("Hammer enabled? - ".. tostring(test1))
            ui.print("HP Value? = ".. test2)
            ui.print("Hammer Targets? = ".. test3)
        end ]]

        if ui.checked("Light's Hammer") and unit.inCombat() and talent.lightsHammer then
            --ui.print("test1 complete")
            if biggestGroup >= ui.value("Light's Hammer Targets") then
                --ui.print("test2 complete")
                if cast.lightsHammer(bestUnit) then
                    --ui.print("test4 complete")
                    br._G.SpellStopTargeting()
                    return 
                end
            end
        end

        if talent.bestowFaith and ui.checked("Bestow Faith") and cast.able.bestowFaith() then
            if ui.value("Bestow Faith Target") == 1 then
                if lowest.hp <= ui.value("Bestow Faith") then
                    if cast.bestowFaith(lowest.unit) then
                        return true
                    end
                end
            elseif ui.value("Bestow Faith Target") == 2 and #tanks > 0 and br._G.UnitInRange(tanks[1].unit) then
                if tanks[1].hp <= ui.value("Bestow Faith") then
                    if cast.bestowFaith(tanks[1].unit) then
                        return true
                    end
                end
            elseif ui.value("Bestow Faith Target") == 3 then
                if php <= ui.value("Bestow Faith") then
                    if cast.bestowFaith("player") then
                        return true
                    end
                end
            end
        end

        -- Glimmer support
        if mode.glimmer == 3 and (inInstance or inRaid) and #tanks > 0 then
            for i = 1, #tanks do
                local thisUnit = tanks[i].unit
                if not br.UnitBuffID(thisUnit, 287280, "PLAYER") and not br.UnitBuffID(thisUnit, 115191) and br.getLineOfSight(thisUnit, "player") then
                    if cast.holyShock(thisUnit) then
                        --Print("Holy Shock tank")
                        return true
                    end
                end
            end
            if talent.crusadersMight and lowest.hp > ui.value("Critical HP") and (br.getSpellCD(20473) > (gcd)) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", units.dyn5)) then
                if pallyFace(spell.crusaderStrike) then
                    return true
                end
            end
        end

        if mode.glimmer == 1 and (inInstance or inRaid or OWGroup or solo) then
            if br.getSpellCD(20473) < gcd then
                -- here to see if shock is not ready, but dawn is - then use dawn
                --critical first
                for i = 1, #tanks do
                    local thisUnit = tanks[i].unit
                    local thisHP = tanks[i].hp
                    if thisHP <= ui.value("Critical HP") and br.getLineOfSight(tanks[i].unit, "player") then
                        if cast.holyShock(thisUnit) then
                            --Print("Holy Shock 1")
                            return true
                        end
                    end
                end
                if ui.checked("Self Shock") and php <= ui.value("Self Shock") and not br.UnitBuffID("player", 287280, "PLAYER") then
                    if cast.holyShock("player") then
                        --Print("Holy Shock 2")
                        return true
                    end
                end
                if lowest.hp <= ui.value("Critical HP") then
                    if cast.holyShock(lowest.unit) then
                        --Print("Holy Shock 3")
                        return true
                    end
                end
                --find lowest friend without glitter buff on them - tank first
                --[[ for i = 1, #br.friend do
                    if br.getLineOfSight(br.friend[i].unit, "player") then
                        if (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") and not unit.deadOrGhost(br.friend[i].unit) and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) and not br.UnitBuffID(br.friend[i].unit, 287280) then
                            if cast.holyShock(br.friend[i].unit) then
                                --Print("Holy Shock 4")
                                --Print(br.friend[i].unit)
                                return true
                            end
                        end
                    end
                end ]]
                glimmerTable = {}
                for i = 1, #br.friend do
                    if br.getLineOfSight(br.friend[i].unit, "player") and not unit.deadOrGhost(br.friend[i].unit) and not br.UnitBuffID(br.friend[i].unit, 287280, "PLAYER") and not br.UnitBuffID(br.friend[i].unit, 115191) then
                        tinsert(glimmerTable, br.friend[i])
                    end
                end
                if #glimmerTable > 1 then
                    table.sort(
                        glimmerTable,
                        function(x, y)
                            return x.hp < y.hp
                        end
                    )
                end
                if glimmerCount ~= nil and glimmerCount >= 8 and br.getLineOfSight(lowest.unit, "player") then
                    if cast.holyShock(lowest.unit) then
                        --Print("Holy Shock 5")
                        --Print("Glimmer cap glimmer")
                        return
                    end
                end
                if #glimmerTable >= 1 and glimmerTable[1].unit ~= nil and mode.glimmer == 1 then
                    if cast.holyShock(glimmerTable[1].unit) then
                        --Print("Holy Shock 6")
                        --Print("Just glimmered: " .. glimmerTable[1].unit)
                        return true
                    end
                end
                if glimmerTable ~= nil and #glimmerTable == 0 and (not ui.checked("Holy Shock Damage") or (ui.checked("Holy Shock Damage") and lowest.hp <= ui.value("Holy Shock"))) then
                    if cast.holyShock(lowest.unit) then
                        --Print("Holy Shock 7")
                        return true
                    end
                end
            end
            if talent.crusadersMight and lowest.hp > ui.value("Critical HP") and (br.getSpellCD(20473) > (gcd)) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", units.dyn5)) then
                if pallyFace(spell.crusaderStrike) then
                    return true
                end
            end
        end

        if ui.checked("Holy Shock") and br.getSpellCD(20473) < gcd and mode.glimmer ~= 1 then
            --critical first
            if #tanks > 0 then
                if tanks[1].hp <= ui.value("Critical HP") and not unit.deadOrGhost(tanks[1].unit) then
                    if cast.holyShock(tanks[1].unit) then
                        --Print("Holy Shock 8")
                        return true
                    end
                end
            end
            if php <= ui.value("Critical HP") or br.getBuffRemain("player", 265773) ~= 0 then
                if cast.holyShock("player") then
                    --Print("Holy Shock 9")
                    return true
                end
            end
            if lowest.hp <= ui.value("Holy Shock") then
                if cast.holyShock(lowest.unit) then
                    --("Holy Shock 10")
                    return true
                end
            end
        end

        if ui.checked("Judgment Heal") and talent.judgmentOfLight and (ui.checked("Dev Stuff Leave off") or unit.facing("player", units.dyn30)) and unit.inCombat() and br.getSpellCD(20473) > (gcd + 0.3) then
            if pallyFace(275773,"target") then
                return true
            end
        end

        if ui.checked("High Prio Crusader Strike") and br.getSpellCD(20473) > (gcd/2) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", units.dyn5)) then
            if pallyFace(spell.crusaderStrike) then
                return true
            end
        end

        if php >= ui.value("LotM player HP limit") and #br.friend > 1 then
            if not br.GetUnitIsUnit(lowestNP.unit, "player") and not unit.deadOrGhost(lowestNP.unit) then
                if ui.checked("Moving LotM") and lowestNP.hp <= ui.value("Moving LotM") and unit.moving("player") then
                    if cast.lightOfTheMartyr(lowestNP.unit) then
                        return true
                    end
                end
                if ui.checked("LoM after FoL") and lowestNP.hp <= ui.value("LoM after FoL") and cast.last.flashOfLight() then
                    if cast.lightOfTheMartyr(lowestNP.unit) then
                        return true
                    end
                end
                if ui.checked("Light of the Martyr") and lowestNP.hp <= ui.value("Light of the Martyr") then
                    if cast.lightOfTheMartyr(lowestNP.unit) then
                        return true
                    end
                end
            end
        end

        if ui.checked("Flash of Light") and not unit.moving("player") then
            --Critical first
            if php <= ui.value("Critical HP") then
                if cast.flashOfLight("player") then
                    return true
                end
            end
            if #tanks > 0 then
                if tanks[1].hp <= ui.value("Critical HP") and not unit.deadOrGhost(tanks[1].unit) then
                    if cast.flashOfLight(tanks[1].unit) then
                        return true
                    end
                end
            end
            if lowest.hp <= ui.value("Critical HP") then
                if cast.flashOfLight(lowest.unit) then
                    return true
                end
            end

            if lowestBeacon.unit ~= nil and ui.checked("FoL Beacon") and lowestBeacon.hp <= ui.value("FoL Beacon") then
                if cast.flashOfLight(lowestBeacon.unit) then
                    return true
                end
            end

            if lowest.hp <= ui.value("Flash of Light") or (lowest.hp <= ui.value("FoL Infuse") and buff.infusionOfLight.exists() and not cast.last.flashOfLight()) then
                if cast.flashOfLight(lowest.unit) then
                    return true
                end
            end

            if #tanks > 0 then
                if tanks[1].hp <= ui.value("FoL Tanks") and not unit.deadOrGhost(tanks[1].unit) then
                    if cast.flashOfLight(tanks[1].unit) then
                        return true
                    end
                end
            end
        end

        if ui.checked("Holy Prism") and talent.holyPrism and cast.able.holyPrism() and unit.inCombat() then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local lowHealthCandidates = br.getUnitsToHealAround(thisUnit, 15, ui.value("Holy Prism"), #br.friend)
                if #lowHealthCandidates >= ui.value("Holy Prism Targets") then
                    if cast.holyPrism(thisUnit) then
                        return true
                    end
                end
            end
        end

        if ui.checked("Holy Light") and not unit.moving("player") and br.getSpellCD(20473) > gcd and (ui.value("Holy Light Infuse") == 1 or (ui.value("Holy Light Infuse") == 2 and buff.infusionOfLight.remain() > br.getCastTime(spell.holyLight))) then
            if lowest.hp <= ui.value("Holy Light") then
                if cast.holyLight(lowest.unit) then
                    return true
                end
            end
        end
    end -- end healing

    local function mPlusGods() -- 99% Feng's massive brain
        
        if ui.checked("Consecration") and br.getSpellCD(26573) == 0 and #enemies.yards5 >= ui.value("Consecration") and br.getDebuffRemain("target", 204242) == 0 and (not br._G.GetTotemInfo(1) or (br.getDistanceToObject("player", cX, cY, cZ) > 7) or br._G.GetTotemTimeLeft(1) < 2) then
            if cast.consecration() then
                cX, cY, cZ = br._G.ObjectPosition("player")
                return
            end
        end
        --Spiteful
        for i = 1, br._G.GetObjectCount() do
            local object = br._G.GetObjectWithIndex(i)
            local ID = br._G.ObjectID(object)
            if ID == 174773 and br.GetUnitIsUnit("player", br._G.UnitTarget(object)) and unit.distance(object) <= 10 and cast.able.hammerOfJustice() then
                if cast.hammerOfJustice(object) then
                    return
                end
            end
        end

        --[[ if br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(321894) and cast.able.blessingOfProtection() and not talent.blessingOfSpellwarding then
            if cast.blessingOfProtection("boss1target") then 
                return true 
            end
        end ]]
        
        if br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(320788) and br.getSpellCD(1044) == 0 then
            if cast.blessingOfFreedom("boss1target") then
                return true
            end
        end

        if (br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(317231) or br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(320729)) and br.getDebuffRemain("player",331606) ~= 0 and br.getSpellCD(1044) == 0 then
            if cast.blessingOfFreedom("player") then return true end
        end
    end

    --[[ if mode.mythic == 1 then
        local bleedLevel = 1
        local bleedTarget
        for i = 1, #br.friend do
            if getDebuffStacks(br.friend[i].unit, 240559) > bleedLevel then
                bleedLevel = getDebuffStacks(br.friend[i].unit, 240559)
                bleedTarget = br.friend[1].unit
            end
        end
        if #tanks > 0 then
            if getDebuffStacks(tanks[1].unit, 240559) >= bleedLevel then
                bleedTarget = tanks[1].unit
            end
        end
        if bleedTarget ~= nil and unit.hp(bleedTarget) <= 80 then
            if cast.wordOfGlory(bleedTarget) then
                return true
            end

            if cast.holyShock(bleedTarget) then
                return true
            end

            if not unit.moving("player") then
                if cast.flashOfLight(bleedTarget) then
                    return true
                end
            end

            if unit.moving("player") and php >= 70 then
                if cast.lightOfTheMartyr(bleedTarget) then
                    return true
                end
            end
        end
    end ]]
    if ui.checked("Automatic Aura replacement") then
        
        if not buff.devotionAura.exists() and (not br._G.IsMounted() or buff.divineSteed.exists()) then
            if cast.devotionAura("player") then
                return
            end
        elseif not buff.crusaderAura.exists() and br._G.IsMounted() then
            if cast.crusaderAura("player") then
                return
            end
        end
    end
    if ui.checked("Advanced Trinket Support") then
        
        local Trinket13 = _G.GetInventoryItemID("player", 13)
        local Trinket14 = _G.GetInventoryItemID("player", 14)
        -- Tuft Logic
        local tuftTarget = nil
        if (Trinket13 == 184020 or Trinket14 == 184020) then
            if br.canUseItem(184020) then
                for i = 1, #br.friend do
                    if br.friend[i].hp < 100 then
                        if ui.value("Tuft of Smoldering Plumeage Target") == 1 then
                            if br.friend[i].hp <= tuftTargetHP then
                                tuftTarget = br.friend[i].unit
                            end
                        elseif ui.value("Tuft of Smoldering Plumeage Target") == 2 then
                            if br.friend[i].hp <= tuftTargetHP and (br.friend[i].role == "TANK" or unit.role(br.friend[i].unit) == "TANK") then
                                tuftTarget = br.friend[i].unit
                            end
                        elseif ui.value("Tuft of Smoldering Plumeage Target") == 3 and php <= tuftTargetHP then
                            tuftTarget = "player"
                        elseif ui.value("Tuft of Smoldering Plumeage Target") == 4 then
                            if unit.role(br.friend[i].unit) == "HEALER" or unit.role(lowestUnit) == "DAMAGER" then
                                if br.friend[i].hp <= tuftTargetHP then
                                    tuftTarget = br.friend[i].unit
                                end
                            end
                        end
                        if tuftTarget ~= nil and br.canUseItem(184020) and not unit.deadOrGhost(tuftTarget) then
                            br._G.UseItemByName(184020, tuftTarget)
                            return true
                        end
                    end
                end
            end
        end
    end
    if (not br._G.IsMounted() or buff.divineSteed.exists()) then
        if br.pause(true) or drinking or br.isLooting() then
            return true
        else
            if not unit.inCombat() and not br.UnitBuffID("player", 115834) and not cast.current.fleshcraft() then
                if ui.checked("ST Ham Sandwich (Mouseover)") and (br.SpecificToggle("ST Ham Sandwich (Mouseover)") and not br._G.GetCurrentKeyBoardFocus()) then
                    if hamSammy() then
                        return true
                    end
                else
                    if bellsAndWhistles() then
                        return
                    end

                    if defensiveTime() then
                        return
                    end

                    if ui.checked("OOC Healing") then
                        if mode.beacon ~= 4 and not talent.beaconOfVirtue then
                            if Beacon() then
                                return
                            end
                        end

                        if ui.checked("OoC Spenders") then
                            if spendies() then
                                return
                            end
                        end

                        if healingTime() then
                            return
                        end
                    end
                end
            end
            if unit.inCombat() and not br.UnitBuffID("player", 115834) and not cast.current.fleshcraft() then
                if ui.checked("ST Ham Sandwich (Mouseover)") and (br.SpecificToggle("ST Ham Sandwich (Mouseover)") and not br._G.GetCurrentKeyBoardFocus()) then
                    if hamSammy() then
                        return true
                    end
                elseif ui.checked("Hard DPS Key") and (br.SpecificToggle("Hard DPS Key") and not br._G.GetCurrentKeyBoardFocus()) then
                    if bigDPS() then
                        return true
                    end
                elseif ((not ui.checked("Hard DPS Key") or not (br.SpecificToggle("Hard DPS Key") and not br._G.GetCurrentKeyBoardFocus())) or (not ui.checked("ST Ham Sandwich (Mouseover)") and (br.SpecificToggle("ST Ham Sandwich (Mouseover)") and not br._G.GetCurrentKeyBoardFocus()))) then
                    if mode.mythic == 1 then
                        if mPlusGods() then 
                            return
                        end
                    end
                    if (ui.checked("Blessing of Freedom") and br.getSpellCD(1044) == 0) then
                        if br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(328276) then
                            if cast.blessingOfFreedom("player") then
                                return true
                            end
                        end  
                        for i = 1, #br.friend do
                            local thisUnit = br.friend[i].unit
                            if br.UnitDebuffID(thisUnit, 341746) or br.UnitDebuffID(thisUnit, 342321) or br.UnitDebuffID(thisUnit, 342322) then
                                if cast.blessingOfFreedom(thisUnit) then
                                    return true
                                end
                            end
                        end
                        if br.hasNoControl(spell.blessingOfFreedom) then
                            if cast.blessingOfFreedom("player") then
                                return true
                            end
                        end
                    end

                    if not buff.vanquishersHammer.exists("player") and cast.able.vanquishersHammer() then
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if ccDoubleCheck(thisUnit) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", thisUnit)) and lowest.hp >= ui.value("Critical HP") then
                                ui.debug("Trying to Vanq")
                                if pallyFace(spell.vanquishersHammer,thisUnit) then
                                    return
                                end
                            end
                        end
                    end

                    if mode.wrath == 1 and buff.avengingWrath.exists("player") and br.getSpellCD(24275) == 0 and holyPower < 5 then
                        if (unit.hp("target") <= 20 or br._G.IsSpellOverlayed(24275) or wingsup) and unit.facing("player", "target") then
                            if cast.hammerOfWrath("target") then
                                return
                            end
                        end
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if ccDoubleCheck(thisUnit) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", thisUnit)) and lowest.hp >= ui.value("Critical HP") then
                                if unit.hp(thisUnit) <= 20 or br._G.IsSpellOverlayed(24275) or wingsup then
                                    ui.debug("Trying to hammer aoe 4")
                                    if pallyFace(spell.hammerOfWrath,thisUnit) then
                                        return
                                    end
                                end
                            end
                        end
                    end
                    
                    if spendies() then
                        return
                    end

                    if mode.wrath == 1 and br.getSpellCD(24275) == 0 and br.getSpellCD(20473) > (gcd + 0.3) then
                        if (unit.hp("target") <= 20 or br._G.IsSpellOverlayed(24275) or wingsup) and unit.facing("player", "target") then
                            if cast.hammerOfWrath("target") then
                                return
                            end
                        end
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if ccDoubleCheck(thisUnit) and (ui.checked("Dev Stuff Leave off") or unit.facing("player", thisUnit)) and holyPower <= 5 and lowest.hp >= ui.value("Critical HP") then
                                if unit.hp(thisUnit) <= 20 or br._G.IsSpellOverlayed(24275) or wingsup then
                                    ui.debug("Trying to hammer aoe 1")
                                    if pallyFace(spell.hammerOfWrath,thisUnit) then
                                        return
                                    end
                                end
                            end
                        end
                    end

                    if br.useCDs() then
                        if Coolies() then
                            return
                        end
                    end

                    if defensiveTime() then
                        return
                    end

                    if bellsAndWhistles() then
                        return
                    end

                    if mode.beacon ~= 4 and not talent.beaconOfVirtue then
                        if Beacon() then
                            return
                        end
                    end

                    if healingTime() then
                        return
                    end

                    if not ui.checked("Hard Lock Crit Heal") or lowest.hp > ui.value("Critical HP") then
                        if damageTime() then
                            return
                        end
                    end
                end
            end
        end
    end
end

local id = 65
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
