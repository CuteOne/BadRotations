local rotationName = "Aura"

--------------
--- COLORS ---
--------------
local colorGreen = "|cff00FF00"
local colorRed = "|cffFF0000"
local colorWhite = "|cffFFFFFF"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Cooldown Button
    CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.divineStar},
        [2] = {mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.divineStar},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.divineStar}
    }
    CreateButton("Cooldown", 1, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.powerWordBarrier},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.powerWordBarrier}
    }
    CreateButton("Defensive", 2, 0)
    -- Decurse Button
    DecurseModes = {
        [1] = {mode = "On", value = 1, overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 1, icon = br.player.spell.purify},
        [2] = {mode = "Off", value = 2, overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.purify}
    }
    CreateButton("Decurse", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.psychicScream},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.psychicScream}
    }
    CreateButton("Interrupt", 4, 0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function utilityOptions()
        -------------------------
        -------- UTILITY --------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Utility - Version 1.03")
        -- Pull Spell
        br.ui:createCheckbox(section, "Pull Spell", "Check this to use SW:P to pull when solo.")
        -- Auto Buff Fortitude
        br.ui:createCheckbox(section, "Power Word: Fortitude", "Check to auto buff Fortitude on party.")
        -- OOC Healing
        br.ui:createCheckbox(section, "OOC Healing", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.", 1)
        br.ui:createSpinner(section, "OOC Penance", 95, 0, 100, 5, "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat penance healing|cffFFBB00.")
        -- Dispel Magic
        br.ui:createDropdown(section, "Dispel Magic", {"|cffFFFF00Selected Target", "|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")
        -- Mass Dispel
        br.ui:createDropdown(section, "Mass Dispel", br.dropOptions.Toggle, 1, colorGreen .. "Enables" .. colorWhite .. "/" .. colorRed .. "Disables " .. colorWhite .. " Mass Dispel usage.")
        --Body and Soul
        br.ui:createSpinner(section, "Body and Soul", 2, 0, 100, 1, "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFBody and Soul usage|cffFFBB00.")
        --Angelic Feather
        br.ui:createSpinner(section, "Angelic Feather", 2, 0, 100, 1, "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAngelic Feather usage|cffFFBB00.")
        --Fade
        br.ui:createSpinner(section, "Fade", 95, 0, 100, 1, "|cffFFFFFFHealth Percent to Cast At. Default: 95")
        --Leap Of Faith
        br.ui:createSpinner(section, "Leap Of Faith", 20, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Will never use on tank. Default: 20")
        --Dominant Mind
        br.ui:createSpinner(section, "Dominant Mind", 5, 0, 10, 1, "|cffFFFFFFMinimum Dominant Mind Targets. Default: 5")
        --Resurrection
        br.ui:createCheckbox(section, "Resurrection")
        br.ui:createDropdownWithout(section, "Resurrection - Target", {"|cff00FF00Target", "|cffFF0000Mouseover", "|cffFFBB00Auto"}, 1, "|cffFFFFFFTarget to cast on")

        br.ui:createCheckbox(section, "Raid Penance", "|cffFFFFFFCheck this to only use Penance when moving.")

        br.ui:createSpinner(section, "Temple of Seth", 80, 0, 100, 5, "|cffFFFFFFMinimum Average Health to Heal Seth NPC. Default: 80")

        br.ui:createSpinnerWithout(section, "Bursting", 1, 1, 10, 1, "", "|cffFFFFFFWhen Bursting stacks are above this amount, Trinkets will be triggered.")

        br.ui:createCheckbox(section, "Pig Catcher", "Catch the freehold Pig in the ring of booty")
        br.ui:createSpinner(section, "Tank Heal", 30, 0, 100, 5, "|cffFFFFFFMinimum Health to Heal Non-Tank units. Default: 30")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Cooldown Key Toggle
        br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle, 6)
        -- Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Decurse Key Toggle
        br.ui:createDropdownWithout(section, "Decurse Mode", br.dropOptions.Toggle, 6)
        -- Interrupt Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end
    local function essenceOptions()
        -------------------------
        ------  ESSENCE  --------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Essence")
        --Concentrated Flame
        br.ui:createDropdown(section, "Concentrated Flame", { "DPS", "Heal", "Hybrid"}, 1)
        br.ui:createSpinnerWithout(section, "Concentrated Flame Heal", 70, 10, 90, 5)
        --Memory of Lucid Dreams
        br.ui:createCheckbox(section, "Lucid Dreams")
        -- Ever-Rising Tide
        br.ui:createDropdown(section, "Ever-Rising Tide", {"Always", "Pair with CDs", "Based on Health"}, 1, "When to use this Essence")
        br.ui:createSpinner(section, "Ever-Rising Tide - Mana", 30, 0, 100, 5, "Min mana to use")
        br.ui:createSpinner(section, "Ever-Rising Tide - Health", 30, 0, 100, 5, "Health threshold to use")
        br.ui:createCheckbox(section, "Well of Existence")
        br.ui:createSpinner(section, "Life-Binder's Invocation", 85, 1, 100, 5, "Health threshold to use")
        br.ui:createSpinnerWithout(section, "Life-Binder's Invocation Targets", 5, 1, 40, 1, "Number of targets to use")
        br.ui:checkSectionState(section)
    end
    local function healingOptions()
        -------------------------
        ---- SINGLE TARGET ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
        --Atonement
        br.ui:createCheckbox(section, "Obey Atonement Limits", "|cffFFFFFFIf checked will obey max atonements when you have rapture buff")
        br.ui:createSpinnerWithout(section, "Party Atonement HP", 95, 0, 100, 1, "|cffFFFFFFApply Atonement using Power Word: Shield and Power Word: Radiance. Health Percent to Cast At. Default: 95")
        br.ui:createSpinnerWithout(
            section,
            "Tank Atonement HP",
            95,
            0,
            100,
            1,
            "|cffFFFFFFApply Atonement to Tank using Power Word: Shield and Power Word: Radiance. Health Percent to Cast At. Default: 95"
        )
        br.ui:createSpinnerWithout(section, "Max Atonements", 3, 1, 40, 1, "|cffFFFFFFMax Atonements to Keep Up At Once. Default: 3")
        br.ui:createSpinner(section, "Depths of the Shadows", 5, 0, 40, 1, "Number of stacks to use Shadow Mend instead of Shield")
        br.ui:createDropdown(section, "Atonement Key", br.dropOptions.Toggle, 6, "|cffFFFFFFSet key to press to spam atonements on everyone.")
        --Alternate Heal & Damage
        br.ui:createSpinner(section, "Alternate Heal & Damage", 1, 1, 5, 1, "|cffFFFFFFAlternate Heal & Damage. How many Atonement applied before back to doing damage. Default: 1")
        --Power Word: Shield
        -- br.ui:createSpinner(section, "Power Word: Shield", 99, 0, 100, 1, "","Health Percent to Cast At. Default: 99")
        -- br.ui:createDropdownWithout(section, "PW:S Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny"}, 7, "|cffFFFFFFcast Power Word: Shield Target")
        --Shadow Mend
        br.ui:createSpinner(section, "Shadow Mend", 65, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 65")
        --Penance Heal
        br.ui:createSpinner(section, "Penance Heal", 60, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 60")
        --Debuff Shadow Mend/Penance Heal
        br.ui:createCheckbox(section, "Debuff Helper", "|cffFFFFFFHelp mitigate a few known debuff")
        --Pain Suppression Tank
        br.ui:createSpinner(section, "Pain Suppression Tank", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 30")
        br.ui:createSpinner(section, "Revitalizing Voodoo Totem", 75, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
        br.ui:createSpinner(section, "Inoculating Extract", 75, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
        br.ui:createSpinner(section, "Ward of Envelopment", 75, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
        br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
        --Power Word: Radiance
        br.ui:createSpinner(section, "Power Word: Radiance", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 70")
        br.ui:createSpinnerWithout(section, "PWR Targets", 3, 0, 40, 1, "|cffFFFFFFMinimum PWR Targets. Default: 3")
        --Shadow Covenant
        br.ui:createSpinner(section, "Shadow Covenant", 85, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 85")
        br.ui:createSpinnerWithout(section, "Shadow Covenant Targets", 4, 0, 40, 1, "|cffFFFFFFMinimum Shadow Covenant Targets. Default: 4")
        --Halo
        br.ui:createSpinner(section, "Halo", 90, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 90")
        br.ui:createSpinnerWithout(section, "Halo Targets", 5, 0, 40, 1, "|cffFFFFFFMinimum Halo Targets. Default: 5")
        -- Divine Star
        br.ui:createSpinner(section, "Divine Star Healing", 95, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 95")
        br.ui:createSpinnerWithout(section, "DS Healing Targets", 3, 0, 40, 1, "|cffFFFFFFMinimum DS Targets. Default: 3 (Will include enemies in total)")
        br.ui:checkSectionState(section)
    end
    local function damageOptions()
        -------------------------
        ----- DAMAGE OPTIONS ----
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Damage")
        br.ui:createSpinnerWithout(section, "Damage Mana Threshold")
        --Shadow Word: Pain/Purge The Wicked
        br.ui:createCheckbox(section, "Shadow Word: Pain/Purge The Wicked")
        br.ui:createSpinner(section, "SW:P/PtW Targets", 3, 0, 20, 1, "|cffFFFFFFMaximum SW:P/PtW Targets. Default: 3")
        --Schism
        br.ui:createCheckbox(section, "Schism")
        --Penance
        br.ui:createCheckbox(section, "Penance")
        --Power Word: Solace
        br.ui:createCheckbox(section, "Power Word: Solace")
        --Smite
        br.ui:createCheckbox(section, "Smite")
        --Halo Damage
        br.ui:createSpinner(section, "Halo Damage", 3, 0, 10, 1, "|cffFFFFFFMinimum Halo Damage Targets. Default: 3")
        --Mindbender
        br.ui:createSpinner(section, "Mindbender", 80, 0, 100, 5, "|cffFFFFFFMana Percent to Cast At. Default: 80")
        --Shadowfiend
        br.ui:createSpinner(section, "Shadowfiend", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 80")
        br.ui:checkSectionState(section)
    end
    local function cooldownOptions()
        -------------------------
        ------- COOLDOWNS -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        --Disable CD during Speed: Slow on Chromatic Anomaly
        br.ui:createCheckbox(section, "Disable CD during Speed: Slow", "|cffFFFFFFDisable CD during Speed: Slow debuff on Chromatic Anomaly")
        --High Botanist Tel'arn Parasitic Fetter dispel helper. Dispel 8 yards from allies
        br.ui:createCheckbox(section, "Parasitic Fetter Dispel Helper", "|cffFFFFFFHigh Botanist Tel'arn Parasitic Fetter dispel helper")
        --Pre Pot
        br.ui:createSpinner(
            section,
            "Pre-Pot Timer",
            3,
            1,
            10,
            1,
            "|cffFFFFFFSet to desired time for Pre-Pot using Battle Potion of Intellect (DBM Required). Second: Min: 1 / Max: 10 / Interval: 1. Default: 3"
        )
        --Pre-pull Opener
        br.ui:createSpinner(
            section,
            "Pre-pull Opener",
            12,
            1,
            15,
            1,
            "|cffFFFFFFSet to desired time for Pre-pull Atonement blanket (DBM Required). Second: Min: 1 / Max: 15 / Interval: 1. Default: 12"
        )
        br.ui:createSpinner(section, "Azshara's Font Prepull", 6, 0, 10, 1, "Pre pull timer to start channeling Font")
        --Int Pot
        br.ui:createSpinner(section, "Int Pot", 50, 0, 100, 5, "|cffFFFFFFUse Battle Potion of Intellect. Default: 50")
        br.ui:createSpinnerWithout(section, "Pro Pot Targets", 3, 0, 40, 1, "|cffFFFFFFMinimum Prolonged Pot Targets. Default: 3")
        --Mana Potion
        br.ui:createSpinner(section, "Mana Potion", 30, 0, 100, 5, "|cffFFFFFFMana Percent to use Ancient Mana Potion. Default: 30")
        --Trinkets
        br.ui:createSpinner(section, "Azshara's Font", 40, 0, 100, 5, "Lowest Unit Health to use Font")
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 1 Mode", {"|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround"}, 1, "", "")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 2 Mode", {"|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround"}, 1, "", "")
        --Touch of the Void
        if hasEquiped(128318) then
            br.ui:createCheckbox(section, "Touch of the Void")
        end
        --Rapture when get Innervate
        br.ui:createCheckbox(section, "Rapture when get Innervate", "|cffFFFFFFCast Rapture and PWS when get Innervate/Symbol of Hope. Default: Unchecked")
        --Rapture
        br.ui:createSpinner(section, "Rapture", 60, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 60")
        br.ui:createSpinner(section, "Rapture (Tank Only)", 60, 0, 100, 5, "|cffFFFFFFTank Health Percent to Cast At. Default: 60")
        br.ui:createSpinnerWithout(section, "Rapture Targets", 3, 0, 40, 1, "|cffFFFFFFMinimum Rapture Targets. Default: 3")
        --Power Word: Barrier/Luminous Barrier
        br.ui:createSpinner(section, "PW:B/LB", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 50")
        br.ui:createSpinnerWithout(section, "PW:B/LB Targets", 3, 0, 40, 1, "|cffFFFFFFMinimum PWB Targets. Default: 3")
        br.ui:createCheckbox(section, "PW:B/LB on Melee", "Only cast on Melee")
        br.ui:createDropdown(section, "PW:B/LB Key", br.dropOptions.Toggle, 6, colorGreen .. "Enables" .. colorWhite .. "/" .. colorRed .. "Disables " .. colorWhite .. " PW:B/LB manual usage.")
        --Evangelism
        br.ui:createDropdown(section, "Evangelism Key", br.dropOptions.Toggle, 6, colorGreen .. "Enables" .. colorWhite .. "/" .. colorRed .. "Disables " .. colorWhite .. " Evangelism manual usage.")
        br.ui:createSpinner(section, "Evangelism", 70, 0, 100, 1, "|cffFFFFFFHealth Percent to Cast At. Default: 70")
        br.ui:createSpinnerWithout(section, "Evangelism Targets", 3, 0, 40, 1, "|cffFFFFFFTarget count to Cast At. Default: 3")
        br.ui:createSpinnerWithout(section, "Atonement for Evangelism", 3, 0, 40, 1, "|cffFFFFFFMinimum Atonement count to Cast At. Default: 3")
        br.ui:checkSectionState(section)
    end
    local function defenseOptions()
        -------------------------
        ------- DEFENSIVE -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Desperate Prayer
        br.ui:createSpinner(section, "Desperate Prayer", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 40")
        -- Healthstone
        br.ui:createSpinner(section, "Pot/Stoned", 35, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 35")
        -- Heirloom Neck
        br.ui:createSpinner(section, "Heirloom Neck", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.. Default: 60")
        -- Gift of The Naaru
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of the Naaru", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 50")
        end
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Shining Force - Int
        br.ui:createCheckbox(section, "Shining Force - Int")
        -- Psychic Scream - Int
        br.ui:createCheckbox(section, "Psychic Scream - Int")
        -- Quaking Palm - Int
        br.ui:createCheckbox(section, "Quaking Palm - Int")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cffFFFFFFCast Percent to Cast At. Default: 0")
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Utility",
            [2] = utilityOptions
        },
        {
            [1] = "Essence",
            [2] = essenceOptions
        },
        {
            [1] = "Healing",
            [2] = healingOptions
        },
        {
            [1] = "Damage",
            [2] = damageOptions
        },
        {
            [1] = "Cooldowns",
            [2] = cooldownOptions
        },
        {
            [1] = "Defensive",
            [2] = defenseOptions
        }
    }
    return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    if br.timer:useTimer("debugDiscipline", 0.1) then
        --Print("Running: "..rotationName)
        --------------
        --- Locals ---
        --------------
        local artifact = br.player.artifact
        local buff = br.player.buff
        local cast = br.player.cast
        local combatTime = br.getCombatTime()
        local cd = br.player.cd
        local charges = br.player.charges
        local debuff = br.player.debuff
        local enemies = br.player.enemies
        local essence = br.player.essence
        local falling, swimming, flying, moving = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player") > 0
        local friends = friends or {}
        local gcd = br.player.gcd
        local gcdMax = br.player.gcdMax
        local healPot = getHealthPot()
        local inCombat = br.player.inCombat
        local inInstance = br.player.instance == "party"
        local inRaid = br.player.instance == "raid"
        local lastSpell = lastSpellCast
        local level = br.player.level
        local lootDelay = br.getOptionValue("LootDelay")
        local mana = getMana("player")
        local mode = br.player.ui.mode
        local perk = br.player.perk
        local php = br.player.health
        local power, powmax, powgen = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
        local pullTimer = br.DBM:getPulltimer()
        local race = br.player.race
        local racial = br.player.getRacial()
        local solo = #br.friend == 1
        local spell = br.player.spell
        local tanks = br.getTanksTable()
        local talent = br.player.talent
        local ttd = br.getTTD
        local traits = br.player.traits
        local ttm = br.player.power.mana.ttm()
        local units = br.player.units
        local lowest = {} --Lowest Unit
        local schismCount = debuff.schism.count()

        units.get(5)
        units.get(30)
        units.get(40)
        enemies.get(24)
        enemies.get(30)
        enemies.get(40)
        friends.yards40 = getAllies("player", 40)

        local atonementCount = 0
        local maxAtonementCount = 0
        --local noAtone = {}
        for i = 1, #br.friend do
            local atonementRemain = br.getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") or 0 -- 194384
            if atonementRemain > 0 then
                if (br.friend[i].role ~= "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) ~= "TANK") then
                    maxAtonementCount = maxAtonementCount + 1
                    atonementCount = atonementCount + 1
                else
                    atonementCount = atonementCount + 1
                end
            -- else
            --     if br.getBuffRemain(br.friend[i].unit,spell.buffs.powerWordShield,"player") < 1 and br.getDistance(br.friend[i].unit) < 40 and br.friend[i].hp ~= 250 then
            --         table.insert(noAtone,br.friend[i].unit)
            --     end
            end
        end

        if not healCount then
            healCount = 0
        end

        local freeMana = buff.innervate.exists() or buff.symbolOfHope.exists()
        local freeCast = freeMana or mana > 90
        local epTrinket = hasEquiped(140805) and br.getBuffRemain("player", 225766) > 1
        local norganBuff = not isMoving("player") or br.UnitBuffID("player", 236373) -- Norgannon's Foresight buff
        local penanceTarget

        if leftCombat == nil then
            leftCombat = GetTime()
        end
        if profileStop == nil then
            profileStop = false
        end

        local current
        local function currTargets()
            current = 0
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if debuff.purgeTheWicked.exists(thisUnit) or debuff.shadowWordPain.exists(thisUnit) then
                    current = current + 1
                end
            end
            return current
        end

        local DSUnits = 0
        if talent.divineStar then
            DSUnits = (getEnemiesInRect(5, 24) + getUnitsInRect(5, 24, false, br.getOptionValue("Divine Star Healing")))
        end
        local DSAtone = 0
        if talent.divineStar then
            local DSTable = select(2, getUnitsInRect(5, 24, false, br.getOptionValue("Divine Star Healing")))
            if #DSTable ~= 0 then
                for i = 1, #DSTable do
                    --print(DSTable[i].unit)
                    local atonementRemain = br.getBuffRemain(DSTable[i].unit, spell.buffs.atonement, "player")
                    if atonementRemain > 0 then
                        DSAtone = DSAtone + 1
                    end
                end
            end
        end

        if inInstance and select(3, GetInstanceInfo()) == 8 then
            for i = 1, #tanks do
                local ourtank = tanks[i].unit
                local Burststack = br.getDebuffStacks(ourtank, 240443)
                if Burststack >= br.getOptionValue("Bursting") then
                    burst = true
                    break
                else 
                    burst = false
                end
            end
        end

        --local lowest = {}
        lowest.unit = "player"
        lowest.hp = 100
        for i = 1, #br.friend do
            if br.isChecked("Tank Heal") then
                if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and (lowest.unit == "player" and lowest.hp > br.getOptionValue("Tank Heal")) then
                    lowest = br.friend[i]
                end
                if ((br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") or br.friend[i].unit == "player" or br.friend[i].hp <= br.getOptionValue("Tank Heal")) then
                    if br.friend[i].hp < lowest.hp then
                        lowest = br.friend[i]
                    end
                end
            elseif not br.isChecked("Tank Heal") then
                if br.friend[i].hp < lowest.hp then
                    lowest = br.friend[i]
                end
            end
        end

        local penanceCheck = isMoving("player") or not br.isChecked("Raid Penance") or (buff.powerOfTheDarkSide.exists() and inRaid)
        local dpsCheck = mana >= br.getOptionValue("Damage Mana Threshold") or (mana <= br.getOptionValue("Damage Mana Threshold") and atonementCount >= 1)

        --------------------
        --- Action Lists ---
        --------------------
        -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i = 1, #enemies.yards40 do
                    thisUnit = enemies.yards40[i]
                    if canInterrupt(thisUnit, br.getOptionValue("Interrupt At")) then
                        -- Shining Force - Int
                        if br.isChecked("Shining Force - Int") and br.getDistance(thisUnit) < 40 then
                            if cast.shiningForce() then
                                br.addonDebug("Casting Shining Force")
                                return true
                            end
                        end
                        -- Psychic Scream - Int
                        if br.isChecked("Psychic Scream - Int") and br.getDistance(thisUnit) < 8 then
                            if cast.psychicScream() then
                                br.addonDebug("Casting Psychic Scream")
                                return true
                            end
                        end
                        -- Quaking Palm
                        if br.isChecked("Quaking Palm - Int") and br.getDistance(thisUnit) < 5 then
                            if cast.quakingPalm(thisUnit) then
                                br.addonDebug("Casting Quaking Palm")
                                return true
                            end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
        local function actionList_Defensive()
            if useDefensive() then
                -- Pot/Stoned
                if br.isChecked("Pot/Stoned") and php <= br.getOptionValue("Pot/Stoned") and inCombat and (hasHealthPot() or br.hasItem(5512) or br.hasItem(166799)) then
                    if br.canUseItem(5512) then
                        br.addonDebug("Using Healthstone")
                        br.useItem(5512)
                    elseif br.canUseItem(healPot) then
                        br.addonDebug("Using Health Pot")
                        br.useItem(healPot)
                    elseif br.hasItem(166799) and br.canUseItem(166799) then
                        br.addonDebug("Using Emerald of Vigor")
                        br.useItem(166799)
                    end
                end
                -- Heirloom Neck
                if br.isChecked("Heirloom Neck") and php <= br.getOptionValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668) == 0 then
                            br.useItem(122668)
                            br.addonDebug("Using Heirloom Neck")
                        end
                    end
                end
                -- Gift of the Naaru
                if br.isChecked("Gift of the Naaru") and php <= br.getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if cast.giftOfTheNaaru() then
                        br.addonDebug("Casting Gift of Naaru")
                        return true
                    end
                end
                if br.isChecked("Desperate Prayer") and php <= br.getOptionValue("Desperate Prayer") then
                    if cast.desperatePrayer() then
                        br.addonDebug("Casting Desperate Prayer")
                        return true
                    end
                end
                --Leap Of Faith
                if br.isChecked("Leap Of Faith") and inCombat then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue("Leap Of Faith") and not br.GetUnitIsUnit(br.friend[i].unit, "player") and UnitGroupRolesAssigned(br.friend[i].unit) ~= "TANK" then
                            if cast.leapOfFaith(br.friend[i].unit) then
                                br.addonDebug("Casting Leap of Faith")
                                return true
                            end
                        end
                    end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
        -----------------
        --- COOLDOWNS ---
        -----------------
        local function actionList_Cooldowns()
            if useCDs() then
                if br.hasItem(166801) and br.canUseItem(166801) then
                    br.addonDebug("Using Sapphire of Brilliance")
                    br.useItem(166801)
                end
                if br.isChecked("Disable CD during Speed: Slow") and br.UnitDebuffID("player", 207011) then
                    return true --Speed: Slow debuff during the Chromatic Anomaly encounter
                else
                    -- Pain Suppression
                    if br.isChecked("Pain Suppression Tank") and inCombat and useCDs then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue("Pain Suppression Tank") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                                if cast.painSuppression(br.friend[i].unit) then
                                    br.addonDebug("Casting Pain Suppression")
                                    return true
                                end
                            end
                        end
                    end
                    if br.isChecked("PW:B/LB") then
                        if br.isChecked("PW:B/LB on Melee") then
                            -- get melee players
                            for i = 1, #tanks do
                                -- get the tank's target
                                local tankTarget = br._G.UnitTarget(tanks[i].unit)
                                if tankTarget ~= nil and br.getDistance(tankTarget) <= 40 then
                                    -- get players in melee range of tank's target
                                    local meleeFriends = getAllies(tankTarget, 5)
                                    -- get the best ground circle to encompass the most of them
                                    local loc = nil
                                    local meleeHurt = {}
                                    for j = 1, #meleeFriends do
                                        if meleeFriends[j].hp < getValue("PW:B/LB") then
                                            tinsert(meleeHurt, meleeFriends[j])
                                        end
                                    end
                                    if #meleeHurt >= getValue("PW:B/LB Targets") then
                                        loc = getBestGroundCircleLocation(meleeHurt, getValue("PW:B/LB Targets"), 6, 8)
                                    end
                                    if loc ~= nil then
                                        if talent.luminousBarrier then
                                            if castGroundAtLocation(loc, spell.luminousBarrier) then
                                                br.addonDebug("Casting Luminous Barrier")
                                                return true
                                            end
                                        else
                                            if castGroundAtLocation(loc, spell.powerWordBarrier) then
                                                br.addonDebug("Casting Power Word Barrier")
                                                return true
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if talent.luminousBarrier then
                                if castWiseAoEHeal(br.friend, spell.luminousBarrier, 10, getValue("PW:B/LB"), getValue("PW:B/LB Targets"), 6, true, true) then
                                    br.addonDebug("Casting Luminous Barrier")
                                    return true
                                end
                            else
                                if castWiseAoEHeal(br.friend, spell.powerWordBarrier, 10, getValue("PW:B/LB"), getValue("PW:B/LB Targets"), 6, true, true) then
                                    br.addonDebug("Casting Power Word Barrier")
                                    return true
                                end
                            end
                        end
                    end
                    if
                        br.isChecked("Life-Binder's Invocation") and essence.lifeBindersInvocation.active and cd.lifeBindersInvocation.remain() <= gcd and
                            getLowAllies(br.getOptionValue("Life-Binder's Invocation")) >= br.getOptionValue("Life-Binder's Invocation Targets")
                     then
                        if cast.lifeBindersInvocation() then
                            br.addonDebug("Casting Life-Binder's Invocation")
                            return true
                        end
                    end
                    if br.isChecked("Ever-Rising Tide") and essence.overchargeMana.active and cd.overchargeMana.remain() <= gcd and br.getOptionValue("Ever-Rising Tide - Mana") <= mana then
                        if br.getOptionValue("Ever-Rising Tide") == 1 then
                            if cast.overchargeMana() then
                                br.addonDebug("Casting Ever-Rising Tide")
                                return true
                            end
                        end
                        if br.getOptionValue("Ever-Rising Tide") == 2 then
                            if buff.rapture.exists() or cd.evangelism.remain() >= 80 or burst == true then
                                if cast.overchargeMana() then
                                    br.addonDebug("Casting Ever-Rising Tide")
                                    return true
                                end
                            end
                        end
                        if br.getOptionValue("Ever-Rising Tide") == 3 then
                            if lowest.hp < br.getOptionValue("Ever Rising Tide - Health") or burst == true then
                                if cast.overchargeMana() then
                                    br.addonDebug("Casting Ever-Rising Tide")
                                    return true
                                end
                            end
                        end
                    end
                    -- Rapture when getting Innervate/Symbol
                    if br.isChecked("Rapture when get Innervate") and freeMana then
                        if cast.rapture() then
                            br.addonDebug("Casting Rapture")
                            return true
                        end
                    end
                    if br.isChecked("Rapture (Tank Only)") then
                        for i = 1, #br.friend do
                            if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and br.friend[i].hp <= getValue("Rapture (Tank Only)") then
                                if cast.rapture() then
                                    if cast.powerWordShield(br.friend[i].unit) then
                                        br.addonDebug("Casting Rapture")
                                        return true
                                    end
                                end
                            end
                        end
                    end
                    --Rapture
                    if br.isChecked("Rapture") then
                        if getLowAllies(getValue("Rapture")) >= getValue("Rapture Targets") then
                            if cast.rapture() then
                                br.addonDebug("Casting Rapture")
                                return true
                            end
                        end
                    end
                    -- Mana Potion
                    if br.isChecked("Mana Potion") and mana <= getValue("Mana Potion") then
                        if br.hasItem(152495) then
                            br.useItem(152495)
                            br.addonDebug("Using Mana Potion")
                            return true
                        end
                    end
                    --Racials
                    --blood_fury
                    --arcane_torrent
                    --berserking
                    if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") or (mana >= 30 and race == "BloodElf") then
                        if race == "LightforgedDraenei" then
                            if cast.racial("target", "ground") then
                                br.addonDebug("Casting Racial")
                                return true
                            end
                        else
                            if cast.racial("player") then
                                br.addonDebug("Casting Racial")
                                return true
                            end
                        end
                    end
                    --potion,name=Int_power
                    if br.isChecked("Int Pot") and br.canUseItem(163222) and not solo then
                        if getLowAllies(getValue("Int Pot")) >= getValue("Int Pot Targets") then
                            br.useItem(163222)
                            br.addonDebug("Using Int Pot")
                        end
                    end
                    --Touch of the Void
                    if br.isChecked("Touch of the Void") and br.getDistance("target") < 5 then
                        if hasEquiped(128318) then
                            if GetItemCooldown(128318) == 0 then
                                br.useItem(128318)
                                br.addonDebug("Using Touch of Void")
                            end
                        end
                    end

                    -- Trinkets
                    if br.isChecked("Revitalizing Voodoo Totem") and hasEquiped(158320) and lowest.hp < getValue("Revitalizing Voodoo Totem") then
                        if GetItemCooldown(158320) <= gcdMax then
                            UseItemByName(158320, lowest.unit)
                            br.addonDebug("Using Revitalizing Voodoo Totem")
                        end
                    end
                    if br.isChecked("Inoculating Extract") and hasEquiped(160649) and lowest.hp < getValue("Inoculating Extract") then
                        if GetItemCooldown(160649) <= gcdMax then
                            UseItemByName(160649, lowest.unit)
                            br.addonDebug("Using Inoculating Extract")
                        end
                    end
                    if br.isChecked("Ward of Envelopment") and hasEquiped(165569) and GetItemCooldown(165569) <= gcdMax then
                        -- get melee players
                        for i = 1, #tanks do
                            -- get the tank's target
                            local tankTarget = br._G.UnitTarget(tanks[i].unit)
                            if tankTarget ~= nil then
                                -- get players in melee range of tank's target
                                local meleeFriends = getAllies(tankTarget, 5)
                                -- get the best ground circle to encompass the most of them
                                local loc = nil
                                if #meleeFriends >= 8 then
                                    loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                                else
                                    local meleeHurt = {}
                                    for j = 1, #meleeFriends do
                                        if meleeFriends[j].hp < 75 then
                                            tinsert(meleeHurt, meleeFriends[j])
                                        end
                                    end
                                    if #meleeHurt >= 2 then
                                        loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                                    end
                                end
                                if loc ~= nil then
                                    br.useItem(165569)
                                    local px, py, pz = br._G.ObjectPosition("player")
                                    loc.z = select(3, TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                                    if loc.z ~= nil and TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 collisions
                                        ClickPosition(loc.x, loc.y, loc.z)
                                        br.addonDebug("Using Ward of Envelopment")
                                        return
                                    end
                                end
                            end
                        end
                    end
                    --Pillar of the Drowned Cabal
                    if hasEquiped(167863) and br.canUseItem(16) then
                        if not br.UnitBuffID(lowest.unit, 295411) and lowest.hp < 75 then
                            UseItemByName(167863, lowest.unit)
                            br.addonDebug("Using Pillar of Drowned Cabal")
                        end
                    end
                    if br.isChecked("Trinket 1") and canTrinket(13) and not hasEquiped(165569, 13) and not hasEquiped(160649, 13) and not hasEquiped(158320, 13) then
                        if hasEquiped(158368, 13) and mana <= 90 then
                            br.useItem(13)
                            br.addonDebug("Using Fangs of Intertwined Essence")
                            return true
                        elseif br.getOptionValue("Trinket 1 Mode") == 1 then
                            if getLowAllies(getValue("Trinket 1")) >= getValue("Min Trinket 1 Targets") or burst == true then
                                br.useItem(13)
                                br.addonDebug("Using Trinket 1")
                                return true
                            end
                        elseif br.getOptionValue("Trinket 1 Mode") == 2 then
                            if lowest.hp <= getValue("Trinket 1") or (burst == true and lowest.hp ~= 250) then
                                UseItemByName(_G.GetInventoryItemID("player", 13), lowest.unit)
                                br.addonDebug("Using Trinket 1 (Target)")
                                return true
                            end
                        elseif br.getOptionValue("Trinket 1 Mode") == 3 and #tanks > 0 then
                            for i = 1, #tanks do
                                -- get the tank's target
                                local tankTarget = br._G.UnitTarget(tanks[i].unit)
                                if tankTarget ~= nil then
                                    -- get players in melee range of tank's target
                                    local meleeFriends = getAllies(tankTarget, 5)
                                    -- get the best ground circle to encompass the most of them
                                    local loc = nil
                                    if #meleeFriends < 12 then
                                        loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                                    else
                                        local meleeHurt = {}
                                        for j = 1, #meleeFriends do
                                            if meleeFriends[j].hp < getValue("Trinket 1") then
                                                tinsert(meleeHurt, meleeFriends[j])
                                            end
                                        end
                                        if #meleeHurt >= getValue("Min Trinket 1 Targets") or burst == true then
                                            loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                                        end
                                    end
                                    if loc ~= nil then
                                        br.useItem(13)
                                        br.addonDebug("Using Trinket 1 (Ground)")
                                        local px, py, pz = br._G.ObjectPosition("player")
                                        loc.z = select(3, TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                                        if loc.z ~= nil and TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 collisions
                                            ClickPosition(loc.x, loc.y, loc.z)
                                            return true
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if br.isChecked("Trinket 2") and canTrinket(14) and not hasEquiped(165569, 14) and not hasEquiped(160649, 14) and not hasEquiped(158320, 14) then
                        if hasEquiped(158368, 14) and mana <= 90 then
                            br.useItem(14)
                            br.addonDebug("Using Fangs of Intertwined Essence")
                            return true
                        elseif br.getOptionValue("Trinket 2 Mode") == 1 then
                            if getLowAllies(getValue("Trinket 2")) >= getValue("Min Trinket 2 Targets") or burst == true then
                                br.useItem(14)
                                br.addonDebug("Using Trinket 2")
                                return true
                            end
                        elseif br.getOptionValue("Trinket 2 Mode") == 2 then
                            if lowest.hp <= getValue("Trinket 2") or (burst == true and lowest.hp ~= 250) then
                                UseItemByName(_G.GetInventoryItemID("player", 14), lowest.unit)
                                br.addonDebug("Using Trinket 2 (Target)")
                                return true
                            end
                        elseif br.getOptionValue("Trinket 2 Mode") == 3 and #tanks > 0 then
                            for i = 1, #tanks do
                                -- get the tank's target
                                local tankTarget = br._G.UnitTarget(tanks[i].unit)
                                if tankTarget ~= nil then
                                    -- get players in melee range of tank's target
                                    local meleeFriends = getAllies(tankTarget, 5)
                                    -- get the best ground circle to encompass the most of them
                                    local loc = nil
                                    if #meleeFriends < 12 then
                                        loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                                    else
                                        local meleeHurt = {}
                                        for j = 1, #meleeFriends do
                                            if meleeFriends[j].hp < getValue("Trinket 2") then
                                                tinsert(meleeHurt, meleeFriends[j])
                                            end
                                        end
                                        if #meleeHurt >= getValue("Min Trinket 2 Targets") or burst == true then
                                            loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                                        end
                                    end
                                    if loc ~= nil then
                                        br.useItem(14)
                                        br.addonDebug("Using Trinket 2 (Ground)")
                                        ClickPosition(loc.x, loc.y, loc.z)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                    --Lucid Dreams
                    if br.isChecked("Lucid Dreams") and essence.memoryOfLucidDreams.active and mana <= 85 and cd.memoryOfLucidDreams.remain() <= gcd then
                        if cast.memoryOfLucidDreams("player") then
                            br.addonDebug("Casting Memory of Lucid Dreams")
                            return
                        end
                    end
                end
            end
        end -- End Action List - Cooldowns
        -- Action List - Pre-Combat
        local function actionList_PreCombat()
            if br.isChecked("Pig Catcher") then
                bossHelper()
            end
            local prepullOpener = inRaid and br.isChecked("Pre-pull Opener") and pullTimer <= br.getOptionValue("Pre-pull Opener") and not buff.rapture.exists("player")
            if br.isChecked("Pre-Pot Timer") and (pullTimer <= br.getOptionValue("Pre-Pot Timer") or prepullOpener) and br.canUseItem(163222) and not solo then
                br.useItem(163222)
                br.addonDebug("Using Pre-Pot")
            end
            -- Pre-pull Opener
            if br.isChecked("Azshara's Font Prepull") and pullTimer <= br.getOptionValue("Azshara's Font Prepull") and not isMoving("player") then
                if hasEquiped(169314) and br.canUseItem(169314) and br.timer:useTimer("Font Delay", 4) then
                    br.addonDebug("Using Font Of Azshara")
                    br.useItem(169314)
                end
            end
            if prepullOpener then
                if br.hasItem(166801) and br.canUseItem(166801) then
                    br.addonDebug("Using Sapphire of Brilliance")
                    br.useItem(166801)
                end
                if charges.powerWordRadiance.count() >= 1 and #br.friend - atonementCount >= 3 and not cast.last.powerWordRadiance() then
                    cast.powerWordRadiance(lowest.unit)
                    br.addonDebug("Casting Power Word Radiance")
                end
            end
            if not isMoving("player") and br.isChecked("Drink") and mana <= br.getOptionValue("Drink") and br.canUseItem(159868) then
                br.useItem(159868)
                br.addonDebug("Drinking")
            end
        end -- End Action List - Pre-Combat
        --OOC
        local function actionList_OOCHealing()
            if br.isChecked("OOC Healing") and (not inCombat or #enemies.yards40 < 1) then -- ooc or in combat but nothing to attack
                 --Resurrection
                 if br.isChecked("Resurrection") and not inCombat and not isMoving("player") and br.timer:useTimer("Resurrect", 4) then
                    if br.getOptionValue("Resurrection - Target") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and br.GetUnitIsFriend("target", "player") then
                        if cast.resurrection("target", "dead") then
                            br.addonDebug("Casting Resurrection (Target)")
                            return true
                        end
                    end
                    if br.getOptionValue("Resurrection - Target") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and br.GetUnitIsFriend("mouseover", "player") then
                        if cast.resurrection("mouseover", "dead") then
                            br.addonDebug("Casting Resurrection (Mouseover)")
                            return true
                        end
                    end
                    if br.getOptionValue("Resurrection - Target") == 3 then
                        local deadPlayers = {}
                        for i =1, #br.friend do
                            if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) then
                                tinsert(deadPlayers,br.friend[i].unit)
                            end
                        end
                        if #deadPlayers > 1 then
                            if cast.massResurrection() then br.addonDebug("Casting Mass Resurrection") return true end
                        elseif #deadPlayers == 1 then
                            if cast.resurrection(deadPlayers[1],"dead") then br.addonDebug("Casting Ressurection (Auto)") return true end
                        end
                    end
                end
                for i = 1, #br.friend do
                    if br.UnitDebuffID(br.friend[i].unit, 225484) or br.UnitDebuffID(br.friend[i].unit, 240559) or br.UnitDebuffID(br.friend[i].unit, 209858) then
                        flagDebuff = br.friend[i].guid
                    end
                    if br.isChecked("OOC Penance") and br.getSpellCD(spell.penance) <= 0 then
                        if br.friend[i].hp <= getValue("OOC Penance") then
                            if cast.penance(br.friend[i].unit) then
                                br.addonDebug("Casting Penance")
                                return true
                            end
                        end
                    end
                    if norganBuff and (br.friend[i].hp < 90 or flagDebuff == br.friend[i].guid) and lastSpell ~= spell.shadowMend then
                        if
                            br.getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 and
                                (maxAtonementCount < getValue("Max Atonements") or (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")) and
                                not buff.powerWordShield.exists(br.friend[i].unit)
                         then
                            if cast.powerWordShield(br.friend[i].unit) then
                                br.addonDebug("Casting Power Word Shield")
                                if cast.shadowMend(br.friend[i].unit) then
                                    br.addonDebug("Casting Shadow Mend")
                                    return true
                                end
                            end
                        elseif cast.shadowMend(br.friend[i].unit) then
                            br.addonDebug("Casting Shadow Mend")
                            return true
                        end
                    elseif (br.friend[i].hp < 95 or flagDebuff == br.friend[i].guid) and not buff.powerWordShield.exists(br.friend[i].unit) then
                        if cast.powerWordShield(br.friend[i].unit) then
                            br.addonDebug("Casting Power Word Shield")
                            return true
                        end
                    end
                    flagDebuff = nil
                end
                -- Concentrated Flame
                if br.isChecked("Concentrated Flame") and essence.concentratedFlame.active and cd.concentratedFlame.remain() <= gcd then
                    if (br.getOptionValue("Concentrated Flame") == 2 or br.getOptionValue("Concentrated Flame") == 3) and lowest.hp <= getValue("Concentrated Flame Heal") then
                        if cast.concentratedFlame(lowest.unit) then
                            br.addonDebug("Casting Concentrated Flame (Heal)")
                            return true
                        end
                    end
                end
            end
        end
        local function actionList_Dispels()
            if mode.decurse == 1 then
                if br.isChecked("Dispel Magic") then
                    if br.getOptionValue("Dispel Magic") == 1 then
                        if br.canDispel("target", spell.dispelMagic) and br.GetObjectExists("target") then
                            if cast.dispelMagic("target") then
                                br.addonDebug("Casting Dispel Magic")
                                return true
                            end
                        end
                    elseif br.getOptionValue("Dispel Magic") == 2 then
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if br.canDispel(thisUnit, spell.dispelMagic) then
                                if cast.dispelMagic(thisUnit) then
                                    br.addonDebug("Casting Dispel Magic")
                                    return true
                                end
                            end
                        end
                    end
                end
                if norganBuff and br.isChecked("Mass Dispel") and (SpecificToggle("Mass Dispel") and not GetCurrentKeyBoardFocus()) and br.getSpellCD(spell.massDispel) <= gcdMax then
                    br._G.CastSpellByName(GetSpellInfo(spell.massDispel), "cursor")
                    br.addonDebug("Casting Mass Dispel")
                    return true
                end
                --Purify
                for i = 1, #br.friend do
                    --High Botanist Tel'arn Parasitic Fetter dispel helper
                    if br.isChecked("Parasitic Fetter Dispel Helper Raid") and br.UnitDebuffID(br.friend[i].unit, 218304) and br.canDispel(br.friend[i].unit, spell.purify) then
                        if #getAllies(br.friend[i].unit, 15) < 2 then
                            if cast.purify(br.friend[i].unit) then
                                br.addonDebug("Casting Purify")
                                return true
                            end
                        end
                    elseif br.UnitDebuffID(br.friend[i].unit, 145206) and br.canDispel(br.friend[i].unit, spell.purify) then
                        if cast.purify(br.friend[i].unit) then
                            br.addonDebug("Casting Purify")
                            return true
                        end
                    else
                        if br.canDispel(br.friend[i].unit, spell.purify) then
                            if cast.purify(br.friend[i].unit) then
                                br.addonDebug("Casting Purify")
                                return true
                            end
                        end
                    end
                end
            end
        end
        local function actionList_Extras()
            -- Angelic Feather
            if IsMovingTime(br.getOptionValue("Angelic Feather")) and not IsSwimming() then
                if not runningTime then
                    runningTime = GetTime()
                end
                if br.isChecked("Angelic Feather") and talent.angelicFeather and (not buff.angelicFeather.exists("player") or GetTime() > runningTime + 5) then
                    if cast.angelicFeather("player") then
                        br.addonDebug("Casting Angelic Feather")
                        runningTime = GetTime()
                        SpellStopTargeting()
                    end
                end
            end
            -- Power Word: Shield Body and Soul
            if IsMovingTime(br.getOptionValue("Body and Soul")) then
                if bnSTimer == nil then
                    bnSTimer = GetTime() - 6
                end
                if br.isChecked("Body and Soul") and talent.bodyAndSoul and not buff.bodyAndSoul.exists("player") and GetTime() >= bnSTimer + 6 then
                    if cast.powerWordShield("player") then
                        br.addonDebug("Casting Power Word Shield (Body and Soul)")
                        bnSTimer = GetTime()
                        return true
                    end
                end
            end
            if br.isChecked("Power Word: Fortitude") and br.timer:useTimer("PW:F Delay", math.random(120, 300)) then
                for i = 1, #br.friend do
                    if
                        not buff.powerWordFortitude.exists(br.friend[i].unit, "any") and br.getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and
                            UnitIsPlayer(br.friend[i].unit)
                     then
                        if cast.powerWordFortitude() then
                            br.addonDebug("Casting Power Word Fortitude")
                            return true
                        end
                    end
                end
            end
        end

        local function actionList_AMR()
            -- Atonement Key
            if (SpecificToggle("Atonement Key") and not GetCurrentKeyBoardFocus()) and br.isChecked("Atonement Key") then
                if talent.evangelism and essence.overchargeMana.active and cd.evangelism.remains() <= gcdMax then
                    if cd.overchargeMana.remains() <= gcdMax then
                        if cast.overchargeMana() then
                            br.addonDebug("Casting Ever-Rising Tide")
                            return
                        end
                    elseif cd.overchargeMana.remains() > 22 then
                        if buff.overchargeMana.stack() < 5 then
                            for i = 1, #br.friend do
                                if br.getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 then
                                    if cast.powerWordShield(br.friend[i].unit) then
                                        br.addonDebug("Casting Power Word Shield")
                                        return
                                    end
                                end
                            end
                        elseif cast.last.powerWordShield() and buff.overchargeMana.stack() >= 5 then
                            for i = 1, #br.friend do
                                if br.getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 then
                                    if cast.powerWordRadiance(br.friend[i].unit) then
                                        br.addonDebug("Casting Power Word Radiance")
                                        return
                                    end
                                end
                            end
                        elseif cast.last.powerWordRadiance() and buff.overchargeMana.stack() >= 5 then
                            if cast.shadowWordPain("target") then
                                br.addonDebug("Casting Shadow Word Pain")
                                return
                            end
                        end
                    elseif cd.overchargeMana.remains() < 22 then
                        if cast.last.shadowfiend() or cast.last.mindbender() then
                            if cast.powerWordRadiance(lowest.unit) then
                                br.addonDebug("Casting Power Word Radiance")
                                return
                            end
                        elseif cast.last.shadowWordPain() and ((not talent.mindbender and cd.shadowfiend.remains() <= gcdMax) or (talent.mindbender and cd.mindbender.remains() <= gcdMax)) then
                            if br.isChecked("Shadowfiend") then
                                if cast.shadowfiend() then
                                    br.addonDebug("Casting Shadowfiend")
                                    return
                                end
                            elseif br.isChecked("Mindbender") then
                                if cast.mindbender() then
                                    br.addonDebug("Casting Mindbender")
                                    return
                                end
                            end
                        elseif cast.last.powerWordRadiance() then
                            if cast.evangelism() then
                                br.addonDebug("Casting Evangelism")
                                return
                            end
                        end
                    end
                else
                    if ((atonementCount < 3 and inInstance) or (atonementCount < 5 and inRaid)) or isMoving("player") then
                        for i = 1, #br.friend do
                            if br.getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 then
                                if cast.powerWordShield(br.friend[i].unit) then
                                    br.addonDebug("Casting Power Word Shield")
                                    return
                                end
                            end
                        end
                    elseif (br.isChecked("Shadowfiend") or br.isChecked("Mindbender")) and cast.last.powerWordRadiance() then
                        if br.isChecked("Shadowfiend") then
                            if cast.shadowfiend() then
                                br.addonDebug("Casting Shadowfiend")
                                return
                            end
                        elseif br.isChecked("Mindbender") then
                            if cast.mindbender() then
                                br.addonDebug("Casting Mindbender")
                                return
                            end
                        end
                    elseif ((#br.friend - atonementCount >= 3 and inInstance) or (#br.friend - atonementCount >= 5 and inRaid)) and charges.powerWordRadiance.count() >= 1 and norganBuff then
                        for i = 1, #br.friend do
                            if br.getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 then
                                if cast.powerWordRadiance(br.friend[i].unit) then
                                    br.addonDebug("Casting Power Word Radiance")
                                    return
                                end
                            end
                        end
                        if cast.powerWordRadiance(lowest.unit) then
                            br.addonDebug("Casting Power Word Radiance")
                            return
                        end
                    elseif br.isChecked("Evangelism") and talent.evangelism and br.getSpellCD(spell.evangelism) <= gcdMax and (atonementCount / #br.friend >= 0.8 or charges.powerWordRadiance.count() == 0) then
                        if cast.evangelism() then
                            br.addonDebug("Casting Evangelism")
                            return
                        end
                    end
                end
            end
            -- Evangelism
            if (SpecificToggle("Evangelism Key") and not GetCurrentKeyBoardFocus()) and br.isChecked("Evangelism Key") then
                if cast.evangelism() then
                    br.addonDebug("Casting Evangelism")
                    return true
                end
            end
            -- Power Word: Barrier
            if (SpecificToggle("PW:B/LB Key") and not GetCurrentKeyBoardFocus()) and br.isChecked("PW:B/LB Key") then
                if not talent.luminousBarrier then
                    br._G.CastSpellByName(GetSpellInfo(spell.powerWordBarrier), "cursor")
                    br.addonDebug("Casting Power Word Barrier")
                    return true
                else
                    br._G.CastSpellByName(GetSpellInfo(spell.luminousBarrier), "cursor")
                    br.addonDebug("Casting Luminous Barrier")
                    return true
                end
            end
            -- Temple of Seth
            if inCombat and br.isChecked("Temple of Seth") and br.player.eID and br.player.eID == 2127 then
                for i = 1, GetObjectCountBR() do
                    local thisUnit = GetObjectWithIndex(i)
                    if br.GetObjectID(thisUnit) == 133392 then
                        sethObject = thisUnit
                        if br.getHP(sethObject) < 100 and br.getBuffRemain(sethObject, 274148) == 0 and lowest.hp >= getValue("Temple of Seth") then
                            if cd.penance.remain() <= gcdMax then
                                br._G.CastSpellByName(GetSpellInfo(spell.penance), sethObject)
                                br.addonDebug("Casting Penance")
                            end
                            br._G.CastSpellByName(GetSpellInfo(spell.shadowMend), sethObject)
                            br.addonDebug("Casting Shadow Mend")
                        end
                    end
                end
            end
            if
                isMoving("player") and br.isChecked("Shadow Word: Pain/Purge The Wicked") and
                    (br.getSpellCD(spell.penance) > gcdMax or (br.getSpellCD(spell.penance) <= gcdMax and debuff.purgeTheWicked.count() == 0 and debuff.shadowWordPain.count() == 0))
             then
                if talent.purgeTheWicked then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if (br.isChecked("SW:P/PtW Targets") and currTargets() < getValue("SW:P/PtW Targets")) or not br.isChecked("SW:P/PtW Targets") then
                            if br.GetUnitIsUnit(thisUnit, "target") or br.hasThreat(thisUnit) or br.isDummy(thisUnit) then
                                if debuff.purgeTheWicked.remain(thisUnit) < 6 then
                                    if cast.purgeTheWicked(thisUnit) then
                                        br.addonDebug("Casting Purge the Wicked")
                                        ptwDebuff = thisUnit
                                        healCount = 0
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
                if not talent.purgeTheWicked then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if (br.isChecked("SW:P/PtW Targets") and currTargets() < getValue("SW:P/PtW Targets")) or not br.isChecked("SW:P/PtW Targets") then
                            if br.GetUnitIsUnit(thisUnit, "target") or br.hasThreat(thisUnit) or br.isDummy(thisUnit) then
                                if debuff.shadowWordPain.remain(thisUnit) < 4.8 then
                                    if cast.shadowWordPain(thisUnit) then
                                        br.addonDebug("Casting Shadow Word Pain")
                                        healCount = 0
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            -- Power Word: Shield with Rapture
            if buff.rapture.exists("player") then
                if essence.overchargeMana.active and cd.overchargeMana.remains() <= gcdMax then
                    if cast.overchargeMana() then
                        br.addonDebug("Casting Ever-Rising Tide")
                        return
                    end
                elseif essence.overchargeMana.active and cd.overchargeMana.remains() > 22 then
                    for i = 1, #br.friend do
                        if not buff.atonement.exists(br.friend[i].unit) and br.getBuffRemain(br.friend[i].unit, spell.buffs.powerWordShield, "player") < 1 then
                            if cast.powerWordShield(br.friend[i].unit) then
                                br.addonDebug("Casting Power Word Shield")
                                return true
                            end
                        end
                    end
                end
                if br.isChecked("Obey Atonement Limits") then
                    for i = 1, #br.friend do
                        if maxAtonementCount < getValue("Max Atonements") and not buff.atonement.exists(br.friend[i].unit) and
                                br.getBuffRemain(br.friend[i].unit, spell.buffs.powerWordShield, "player") < 1
                         then
                            if cast.powerWordShield(br.friend[i].unit) then
                                br.addonDebug("Casting Power Word Shield")
                                return true
                            end
                        end
                    end
                    for i = 1, #br.friend do
                        if maxAtonementCount < getValue("Max Atonements") or (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
                            if br.getBuffRemain(br.friend[i].unit, spell.buffs.powerWordShield, "player") < 1 then
                                if cast.powerWordShield(br.friend[i].unit) then
                                    br.addonDebug("Casting Power Word Shield")
                                    return true
                                end
                            end
                        end
                    end
                else
                    for i = 1, #br.friend do
                        if not buff.atonement.exists(br.friend[i].unit) and br.getBuffRemain(br.friend[i].unit, spell.buffs.powerWordShield, "player") < 1 then
                            if cast.powerWordShield(br.friend[i].unit) then
                                br.addonDebug("Casting Power Word Shield")
                                return true
                            end
                        end
                    end
                    for i = 1, #br.friend do
                        if br.getBuffRemain(br.friend[i].unit, spell.buffs.powerWordShield, "player") < 1 then
                            if cast.powerWordShield(br.friend[i].unit) then
                                br.addonDebug("Casting Power Word Shield")
                                return true
                            end
                        end
                    end
                end
            end
            -- Evangelism
            if
                br.isChecked("Evangelism") and talent.evangelism and (atonementCount >= getValue("Atonement for Evangelism") or (not inRaid and atonementCount >= 3)) and not buff.rapture.exists("player") and
                    not freeMana
             then
                if getLowAllies(getValue("Evangelism")) >= getValue("Evangelism Targets") then
                    if cast.evangelism() then
                        br.addonDebug("Casting Evangelism")
                        return true
                    end
                end
            end
            -- Power Word Radiance
            if ((br.isChecked("Alternate Heal & Damage") and healCount < getValue("Alternate Heal & Damage")) or not br.isChecked("Alternate Heal & Damage")) and schismCount < 1 then
                if br.isChecked("Power Word: Radiance") and #br.friend - atonementCount >= 2 and norganBuff and not cast.last.powerWordRadiance() and atonementCount < 10 then
                    if charges.powerWordRadiance.count() >= 1 then
                        if getLowAllies(getValue("Power Word: Radiance")) >= getValue("PWR Targets") then
                            for i = 1, #br.friend do
                                if not buff.atonement.exists(br.friend[i].unit) and br.friend[i].hp <= getValue("Power Word: Radiance") then
                                    if cast.powerWordRadiance(br.friend[i].unit) then
                                        br.addonDebug("Casting Power Word Radiance")
                                        healCount = healCount + 1
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            -- Shadow Covenant
            if br.isChecked("Shadow Covenant") and talent.shadowCovenant and schismCount < 1 and atonementCount < 10 then
                if getLowAllies(getValue("Shadow Covenant")) >= getValue("Shadow Covenant Targets") and lastSpell ~= spell.shadowCovenant then
                    if cast.shadowCovenant(lowest.unit) then
                        br.addonDebug("Casting Shadow Covenant")
                        return true
                    end
                end
            end
            -- Contrition Penance Heal
            if br.isChecked("Penance Heal") and penanceCheck and talent.contrition and atonementCount >= 3 and schismCount < 1 then
                if cast.penance(lowest.unit) then
                    br.addonDebug("Casting Penance (Heal)")
                    return true
                end
            end
            -- Shadow Mend
            if ((br.isChecked("Alternate Heal & Damage") and healCount < getValue("Alternate Heal & Damage")) or not br.isChecked("Alternate Heal & Damage")) and schismCount < 1 then
                if br.isChecked("Shadow Mend") and norganBuff and atonementCount < 5 then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue("Shadow Mend") and (not buff.atonement.exists(br.friend[i].unit) or not IsInRaid()) then
                            if cast.shadowMend(br.friend[i].unit) then
                                br.addonDebug("Casting Shadow Mend")
                                healCount = healCount + 1
                                return true
                            end
                        end
                    end
                end
            end
            -- Power Word: Shield
            if ((br.isChecked("Alternate Heal & Damage") and healCount < getValue("Alternate Heal & Damage")) or not br.isChecked("Alternate Heal & Damage")) and schismCount < 1 then
                for i = 1, #tanks do
                    if
                        (tanks[i].hp <= getValue("Tank Atonement HP") or getValue("Tank Atonement HP") == 100) and not buff.powerWordShield.exists(tanks[i].unit) and
                            br.getBuffRemain(tanks[i].unit, spell.buffs.atonement, "player") < 1
                     then
                        if br.isChecked("Depths of the Shadows") and buff.depthOfTheShadows.stack() >= getValue("Depths of the Shadows") then
                            if cast.shadowMend(tanks[i].unit) then
                                br.addonDebug("Casting Shadow Mend")
                                healCount = healCount + 1
                            end
                        elseif cast.powerWordShield(tanks[i].unit) then
                            br.addonDebug("Casting Power Word Shield")
                            healCount = healCount + 1
                            return true
                        end
                    end
                end
                for i = 1, #br.friend do
                    if
                        br.friend[i].role ~= "TANK" and (br.friend[i].hp <= getValue("Party Atonement HP") or getValue("Party Atonement HP") == 100) and
                            not buff.powerWordShield.exists(br.friend[i].unit) and
                            br.getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 and
                            maxAtonementCount < getValue("Max Atonements")
                     then
                        if br.isChecked("Depths of the Shadows") and buff.depthOfTheShadows.stack() >= getValue("Depths of the Shadows") then
                            if cast.shadowMend(br.friend[i].unit) then
                                br.addonDebug("Casting Shadow Mend")
                                healCount = healCount + 1
                            end
                        elseif cast.powerWordShield(br.friend[i].unit) then
                            br.addonDebug("Casting Power Word Shield")
                            healCount = healCount + 1
                            return true
                        end
                    end
                end
            end
            -- Mindbender
            if br.isChecked("Mindbender") and mana <= getValue("Mindbender") and atonementCount >= 3 and talent.mindbender then
                if debuff.schism.exists(schismBuff) then
                    if cast.mindbender(schismBuff) then
                        br.addonDebug("Casting Mindbender")
                        healCount = 0
                    end
                end
                if cast.mindbender() then
                    br.addonDebug("Casting Mindbender")
                    healCount = 0
                end
            end
            -- Shadowfiend
            if br.isChecked("Shadowfiend") and not talent.mindbender and atonementCount >= 3 then
                if debuff.schism.exists(schismBuff) then
                    if cast.shadowfiend(schismBuff) then
                        br.addonDebug("Casting Shadowfiend")
                        healCount = 0
                    end
                end
                if cast.shadowfiend() then
                    br.addonDebug("Casting Shadowfiend")
                    healCount = 0
                end
            end
            -- Purge the Wicked/ Shadow Word: Pain
            if
                br.isChecked("Shadow Word: Pain/Purge The Wicked") and
                    (br.getSpellCD(spell.penance) > 0 or (br.getSpellCD(spell.penance) <= 0 and debuff.purgeTheWicked.count() == 0 and debuff.shadowWordPain.count() == 0))
             then
                if talent.purgeTheWicked then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if (br.isChecked("SW:P/PtW Targets") and currTargets() < getValue("SW:P/PtW Targets")) or not br.isChecked("SW:P/PtW Targets") then
                            if br.GetUnitIsUnit(thisUnit, "target") or br.hasThreat(thisUnit) or br.isDummy(thisUnit) then
                                if debuff.purgeTheWicked.remain(thisUnit) < 6 then
                                    if cast.purgeTheWicked(thisUnit) then
                                        br.addonDebug("Purge the Wicked")
                                        ptwDebuff = thisUnit
                                        healCount = 0
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
                if not talent.purgeTheWicked then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if (br.isChecked("SW:P/PtW Targets") and currTargets() < getValue("SW:P/PtW Targets")) or not br.isChecked("SW:P/PtW Targets") then
                            if br.GetUnitIsUnit(thisUnit, "target") or br.hasThreat(thisUnit) or br.isDummy(thisUnit) then
                                if debuff.shadowWordPain.remain(thisUnit) < 4.8 then
                                    if cast.shadowWordPain(thisUnit) then
                                        br.addonDebug("Casting Shadow Word Pain")
                                        healCount = 0
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            -- Schism (2+ Atonement)
            if talent.schism and br.isChecked("Schism") and atonementCount >= 2 and cd.penance.remain() <= gcdMax and norganBuff and ttd("target") > 9 and not isExplosive("target") then
                if cast.schism("target") then
                    br.addonDebug("Casting Schism")
                    schismBuff = br.getUnitID("target")
                end
            end
            -- Power Word: Solace
            if br.isChecked("Power Word: Solace") and talent.powerWordSolace then
                if debuff.schism.exists(schismBuff) then
                    if cast.powerWordSolace(schismBuff) then
                        br.addonDebug("Casting Power Word Solace")
                        healCount = 0
                        return true
                    end
                elseif cast.powerWordSolace() then
                    br.addonDebug("Casting Power Word Solace")
                    healCount = 0
                    return true
                end
            end
            -- Halo
            if br.isChecked("Halo") and norganBuff then
                if getLowAllies(getValue("Halo")) >= getValue("Halo Targets") then
                    if cast.halo(lowest.unit) then
                        br.addonDebug("Casting Halo")
                        return true
                    end
                end
            end
            -- Divine Star
            if br.isChecked("Divine Star Healing") and talent.divineStar then
                --print("DSUnits: "..DSUnits.." DSAtone: "..DSAtone)
                if DSUnits >= br.getOptionValue("DS Healing Targets") and DSAtone >= 1 then
                    if cast.divineStar() then
                        br.addonDebug("Casting Divine Star")
                        healCount = 0
                    end
                end
            end
            -- Penance
            if br.isChecked("Penance") and penanceCheck and dpsCheck then
                if br.GetUnitExists("target") then
                    penanceTarget = "target"
                end
                if penanceTarget ~= nil then
                    if br.isValidUnit(schismBuff) and debuff.schism.exists(schismBuff) then
                        penanceTarget = schismBuff
                    end
                    if ptwDebuff and br.isValidUnit(ptwDebuff) then
                        penanceTarget = ptwDebuff
                    end
                    if not br.GetUnitIsFriend(penanceTarget, "player") then
                        if cast.penance(penanceTarget) then
                            br.addonDebug("Casting Penance")
                            healCount = 0
                            return true
                        end
                    end
                else
                    if lowest.hp <= br.getOptionValue("Penance Heal") then
                        if cast.penance(lowest.unit) then
                            br.addonDebug("Casting Penance")
                            return true
                        end
                    end
                end
            end
            -- Concentrated Flame
            if br.isChecked("Concentrated Flame") and essence.concentratedFlame.active and cd.concentratedFlame.remain() <= gcd then
                if (br.getOptionValue("Concentrated Flame") == 2 or br.getOptionValue("Concentrated Flame") == 3) and lowest.hp <= getValue("Concentrated Flame Heal") then
                    if cast.concentratedFlame(lowest.unit) then
                        br.addonDebug("Casting Concentrated Flame (Heal)")
                        return true
                    end
                else
                    if br.getOptionValue("Concentrated Flame") == 1 or (br.getOptionValue("Concentrated Flame") == 3 and not debuff.schism.exists(schismBuff) and lowest.hp > getValue("Concentrated Flame Heal")) then
                        if cast.concentratedFlame("target") then
                            br.addonDebug("Casting Concentrated Flame (Dmg)")
                            return true
                        end
                    end
                end
            end
            -- Refreshment
            if
                br.isChecked("Well of Existence") and essence.refreshment.active and cd.refreshment.remain() <= gcd and br.UnitBuffID("player", 296138) and
                    select(16, br.UnitBuffID("player", 296138, "EXACT")) >= 15000 and
                    lowest.hp <= getValue("Shadow Mend")
             then
                if cast.refreshment(lowest.unit) then
                    br.addonDebug("Casting Refreshment")
                    return true
                end
            end
            -- Azshara's Font of Power
            if br.isChecked("Azshara's Font") and hasEquiped(169314) and lowest.hp > br.getOptionValue("Azshara's Font") and not br.UnitBuffID("player", 296962) and br.timer:useTimer("Font Delay", 4) and br.canUseItem(169314) and not isMoving("player") and ttd("target") > 30 then
                br.useItem(169314)
                br.addonDebug("Using Font of Azshara")
                return true
            end
            -- Shadow Mend
            if ((br.isChecked("Alternate Heal & Damage") and healCount < getValue("Alternate Heal & Damage")) or not br.isChecked("Alternate Heal & Damage")) and schismCount < 1 then
                if br.isChecked("Shadow Mend") and norganBuff then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue("Shadow Mend") then
                            if cast.shadowMend(br.friend[i].unit) then
                                br.addonDebug("Casting Shadow Mend")
                                healCount = healCount + 1
                                return true
                            end
                        end
                    end
                end
            end
            -- Smite
            if br.isChecked("Smite") and norganBuff and (freeCast or dpsCheck) then
                if debuff.schism.exists(schismBuff) then
                    if cast.smite(schismBuff) then
                        br.addonDebug("Casting Smite")
                        healCount = 0
                        return true
                    end
                elseif cast.smite() then
                    br.addonDebug("Casting Smite")
                    healCount = 0
                    return true
                end
            end
            -- Fade
            if br.isChecked("Fade") and not cast.active.penance() then
                if php <= getValue("Fade") and not solo then
                    if cast.fade() then
                        br.addonDebug("Casting Fade")
                        return true
                    end
                end
            end
        end

        if br.data.settings[br.selectedSpec][br.selectedProfile]["HE ActiveCheck"] == false and br.timer:useTimer("Error delay", 0.5) then
            Print("Detecting Healing Engine is not turned on.  Please activate Healing Engine to use this profile.")
            return
        end

        -----------------
        --- Rotations ---
        -----------------
        -- Pause
        if
            pause() or br.UnitDebuffID("player", 240447) or (br.getBuffRemain("player", 192001) > 0 and mana < 100) or br.getBuffRemain("player", 192002) > 10 or
                (br.getBuffRemain("player", 192002) > 0 and mana < 100) or
                br.getBuffRemain("player", 188023) > 0 or
                br.getBuffRemain("player", 175833) > 0 
         then
            return true
        else
            ---------------------------------
            --- Out Of Combat - Rotations ---
            ---------------------------------
            if not inCombat and not IsMounted() then
                if actionList_Extras() then
                    return true
                end
                if actionList_PreCombat() then
                    return true
                end
                if actionList_Dispels() then
                    return true
                end
                if actionList_OOCHealing() then
                    return true
                end
                if br.GetUnitExists("target") and br.isValidUnit("target") and br.getDistance("target", "player") < 40 and br.isChecked("Pull Spell") then
                    if cast.shadowWordPain() then
                        br.addonDebug("Casting Shadow Word Pain")
                        return true
                    end
                end
            end -- End Out of Combat Rotation
            -----------------------------
            --- In Combat - Rotations ---
            -----------------------------
            if inCombat and not IsMounted() then
                actionList_Interrupts()
                actionList_Dispels()
                if actionList_Extras() then
                    return true
                end
                if actionList_Defensive() then
                    return true
                end
                if actionList_Cooldowns() then
                    return true
                end
                if actionList_AMR() then
                    return true
                end
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation
local id = 0
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
