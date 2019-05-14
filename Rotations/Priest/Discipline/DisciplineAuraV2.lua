local rotationName = "Aura"

--------------
--- COLORS ---
--------------
local colorGreen    = "|cff00FF00"
local colorRed      = "|cffFF0000"
local colorWhite    = "|cffFFFFFF"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.divineStar },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.divineStar },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.divineStar }
    };
    CreateButton("Cooldown",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.powerWordBarrier},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.powerWordBarrier}
    };
    CreateButton("Defensive",2,0)
    -- Decurse Button
    DecurseModes = {
        [1] = { mode = "On", value = 1 , overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 1, icon = br.player.spell.purify },
        [2] = { mode = "Off", value = 2 , overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.purify }
    };
    CreateButton("Decurse",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.psychicScream },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.psychicScream }
    };
    CreateButton("Interrupt",4,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -------------------------
        -------- UTILITY --------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Utility")
            -- Pull Spell
            br.ui:createCheckbox(section,"Pull Spell", "Check this to use SW:P to pull when solo.")
            -- Auto Buff Fortitude
            br.ui:createCheckbox(section,"Power Word: Fortitude", "Check to auto buff Fortitude on party.")
            -- OOC Healing
            br.ui:createCheckbox(section,"OOC Healing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.",1)
            br.ui:createSpinner(section,"OOC Penance", 95, 0, 100, 5,"|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat penance healing|cffFFBB00.")
            -- Dispel Magic
            br.ui:createCheckbox(section,"Dispel Magic","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFDispel Magic usage|cffFFBB00.")
            -- Mass Dispel
            br.ui:createDropdown(section, "Mass Dispel", br.dropOptions.Toggle, 1, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." Mass Dispel usage.")
            --Body and Soul
            br.ui:createSpinner(section, "Body and Soul",  2,  0,  100,  1,  "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFBody and Soul usage|cffFFBB00.")
            --Angelic Feather
            br.ui:createSpinner(section, "Angelic Feather",  2,  0,  100,  1,  "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAngelic Feather usage|cffFFBB00.")
            --Fade
            br.ui:createSpinner(section, "Fade",  95,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At. Default: 95")
            --Leap Of Faith
            br.ui:createSpinner(section, "Leap Of Faith",  20,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Will never use on tank. Default: 20")
            --Dominant Mind
            br.ui:createSpinner(section, "Dominant Mind",  5,  0,  10,  1,  "|cffFFFFFFMinimum Dominant Mind Targets. Default: 5")
            --Resurrection
            br.ui:createCheckbox(section, "Resurrection")
            br.ui:createDropdownWithout(section, "Resurrection - Target", {"|cff00FF00Target","|cffFF0000Mouseover","|cffFFBB00Auto"}, 1, "|cffFFFFFFTarget to cast on")

            br.ui:createCheckbox(section, "Gift of Forgiveness", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFGift of Forgiveness azerite trait logic.|cffFFBB00.")
            
            br.ui:createCheckbox(section, "Raid Penance", "|cffFFFFFFCheck this to only use Penance when moving.")
            
            br.ui:createSpinner(section, "Temple of Seth", 80, 0, 100, 5, "|cffFFFFFFMinimum Average Health to Heal Seth NPC. Default: 80")
            
            br.ui:createSpinnerWithout(section, "Bursting", 1, 1, 10, 1, "", "|cffFFFFFFWhen Bursting stacks are above this amount, Trinkets will be triggered.")
            --br.ui:createSpinner(section, "Tank Heal", 30, 0, 100, 5, "|cffFFFFFFMinimum Health to Heal Non-Tank units. Default: 30")
        br.ui:checkSectionState(section)
        -------------------------
        ---- SINGLE TARGET ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
            --Atonement
            br.ui:createCheckbox(section, "Obey Atonement Limits", "|cffFFFFFFIf checked will obey max atonements when you have rapture buff")
            br.ui:createSpinnerWithout(section, "Party Atonement HP",  95,  0,  100,  1,  "|cffFFFFFFApply Atonement using Power Word: Shield and Power Word: Radiance. Health Percent to Cast At. Default: 95")
            br.ui:createSpinnerWithout(section, "Tank Atonement HP",  95,  0,  100,  1,  "|cffFFFFFFApply Atonement to Tank using Power Word: Shield and Power Word: Radiance. Health Percent to Cast At. Default: 95")
            br.ui:createSpinnerWithout(section, "Max Atonements", 3, 1, 40, 1, "|cffFFFFFFMax Atonements to Keep Up At Once. Default: 3")
            br.ui:createDropdown(section,"Atonement Key", br.dropOptions.Toggle, 6, "|cffFFFFFFSet key to press to spam atonements on everyone.")
            --Alternate Heal & Damage
            br.ui:createSpinner(section, "Alternate Heal & Damage",  1,  1,  5,  1,  "|cffFFFFFFAlternate Heal & Damage. How many Atonement applied before back to doing damage. Default: 1")
            --Power Word: Shield
           -- br.ui:createSpinner(section, "Power Word: Shield", 99, 0, 100, 1, "","Health Percent to Cast At. Default: 99")
           -- br.ui:createDropdownWithout(section, "PW:S Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny"}, 7, "|cffFFFFFFcast Power Word: Shield Target")
            --Shadow Mend
            br.ui:createSpinner(section, "Shadow Mend",  65,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 65")
            --Penance Heal
            br.ui:createSpinner(section, "Penance Heal",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 60")
            --Debuff Shadow Mend/Penance Heal
            br.ui:createCheckbox(section, "Debuff Helper", "|cffFFFFFFHelp mitigate a few known debuff")
            --Pain Suppression Tank
            br.ui:createSpinner(section, "Pain Suppression Tank",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 30")
            --Pain Suppression
            br.ui:createSpinner(section, "Pain Suppression",  15,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 15")
            br.ui:createSpinner(section, "Revitalizing Voodoo Totem", 75, 0 , 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
            br.ui:createSpinner(section, "Inoculating Extract", 75, 0 , 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
            br.ui:createSpinner(section, "Ward of Envelopment", 75, 0 , 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
        br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
            --Power Word: Radiance
            br.ui:createSpinner(section, "Power Word: Radiance",  70,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 70")
            br.ui:createSpinnerWithout(section, "PWR Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum PWR Targets. Default: 3")
            --Shadow Covenant
            br.ui:createSpinner(section, "Shadow Covenant",  85,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 85")
            br.ui:createSpinnerWithout(section, "Shadow Covenant Targets",  4,  0,  40,  1,  "|cffFFFFFFMinimum Shadow Covenant Targets. Default: 4")
            --Halo
            br.ui:createSpinner(section, "Halo",  90,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 90")
            br.ui:createSpinnerWithout(section, "Halo Targets",  5,  0,  40,  1,  "|cffFFFFFFMinimum Halo Targets. Default: 5")
            -- Divine Star
            br.ui:createSpinner(section, "Divine Star Healing", 95, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 95")
            br.ui:createSpinnerWithout(section, "DS Healing Targets", 3, 0, 40, 1, "|cffFFFFFFMinimum DS Targets. Default: 3 (Will include enemies in total)")
        br.ui:checkSectionState(section)
        -------------------------
        ----- DAMAGE OPTIONS ----
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Damage")
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
            br.ui:createSpinner(section, "Halo Damage",  3,  0,  10,  1,  "|cffFFFFFFMinimum Halo Damage Targets. Default: 3")
            --Mindbender
            br.ui:createSpinner(section, "Mindbender",  80,  0,  100,  5,  "|cffFFFFFFMana Percent to Cast At. Default: 80")
            --Shadowfiend
            br.ui:createSpinner(section, "Shadowfiend",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 80")
        br.ui:checkSectionState(section)
        -------------------------
        ------- COOLDOWNS -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            --Disable CD during Speed: Slow on Chromatic Anomaly
            br.ui:createCheckbox(section, "Disable CD during Speed: Slow","|cffFFFFFFDisable CD during Speed: Slow debuff on Chromatic Anomaly")
            --High Botanist Tel'arn Parasitic Fetter dispel helper. Dispel 8 yards from allies
            br.ui:createCheckbox(section, "Parasitic Fetter Dispel Helper","|cffFFFFFFHigh Botanist Tel'arn Parasitic Fetter dispel helper")
            --Pre Pot
            br.ui:createSpinner(section, "Pre-Pot Timer",  3,  1,  10,  1,  "|cffFFFFFFSet to desired time for Pre-Pot using Battle Potion of Intellect (DBM Required). Second: Min: 1 / Max: 10 / Interval: 1. Default: 3")
            --Pre-pull Opener
            br.ui:createSpinner(section, "Pre-pull Opener",  12,  10,  15,  1,  "|cffFFFFFFSet to desired time for Pre-pull Atonement blanket (DBM Required). Second: Min: 10 / Max: 15 / Interval: 1. Default: 12")
            --Int Pot
            br.ui:createSpinner(section, "Int Pot",  50,  0,  100,  5,  "|cffFFFFFFUse Battle Potion of Intellect. Default: 50")
            br.ui:createSpinnerWithout(section, "Pro Pot Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum Prolonged Pot Targets. Default: 3")
            --Mana Potion
            br.ui:createSpinner(section, "Mana Potion",  30,  0,  100,  5,  "|cffFFFFFFMana Percent to use Ancient Mana Potion. Default: 30")
            --Trinkets
            br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
            br.ui:createDropdownWithout(section, "Trinket 1 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")
            br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
            br.ui:createDropdownWithout(section, "Trinket 2 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")
            --Touch of the Void
            if hasEquiped(128318) then
                br.ui:createCheckbox(section,"Touch of the Void")
            end
            --Rapture when get Innervate
            br.ui:createCheckbox(section, "Rapture when get Innervate", "|cffFFFFFFCast Rapture and PWS when get Innervate/Symbol of Hope. Default: Unchecked")
            --Rapture
            br.ui:createSpinner(section, "Rapture",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 60")
            br.ui:createSpinner(section, "Rapture (Tank Only)", 60, 0, 100, 5, "|cffFFFFFFTank Health Percent to Cast At. Default: 60")
            br.ui:createSpinnerWithout(section, "Rapture Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum Rapture Targets. Default: 3")
            --Power Word: Barrier/Luminous Barrier
            br.ui:createSpinner(section, "PW:B/LB",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 50")
            br.ui:createSpinnerWithout(section, "PW:B/LB Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum PWB Targets. Default: 3")
            br.ui:createCheckbox(section,"PW:B/LB on Melee","Only cast on Melee")
            br.ui:createDropdown(section,"PW:B/LB Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." PW:B/LB manual usage.")
            --Evangelism
            br.ui:createSpinner(section, "Evangelism",  70,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At. Default: 70")
            br.ui:createSpinnerWithout(section, "Evangelism Targets",  3,  0,  40,  1,  "|cffFFFFFFTarget count to Cast At. Default: 3")
            br.ui:createSpinnerWithout(section, "Atonement for Evangelism",  3,  0,  40,  1,  "|cffFFFFFFMinimum Atonement count to Cast At. Default: 3")
        br.ui:checkSectionState(section)
        -------------------------
        ------- DEFENSIVE -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Desperate Prayer
            br.ui:createSpinner(section, "Desperate Prayer", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 40")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  35,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 35")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.. Default: 60");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 50")
            end
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Shining Force - Int
            br.ui:createCheckbox(section,"Shining Force - Int")
        -- Psychic Scream - Int
            br.ui:createCheckbox(section,"Psychic Scream - Int")
        -- Quaking Palm - Int
            br.ui:createCheckbox(section,"Quaking Palm - Int")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At. Default: 0")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Healer Mode", br.dropOptions.Toggle,  4)
        -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
        -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
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
--- ROTATION ---
----------------
local function runRotation()
    if br.timer:useTimer("debugDiscipline", 0.1) then
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Decurse",0.25)
        UpdateToggle("Interrupt",0.25)
        br.player.mode.decurse = br.data.settings[br.selectedSpec].toggles["Decurse"]

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
        local friends                                       = friends or {}
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local mana                                          = getMana("player")
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local solo                                          = #br.friend == 1
        local spell                                         = br.player.spell
        local tanks                                         = getTanksTable()
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local traits                                        = br.player.traits
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units
        local lowest                                        = {}    --Lowest Unit
        local schismCount                                   = debuff.schism.count()

        units.get(5)
        units.get(30)
        units.get(40)
        enemies.get(24)
        enemies.get(30)
        enemies.get(40)
        friends.yards40 = getAllies("player",40)

        atonementCount = 0
        maxatonementCount = 0
        for i=1, #br.friend do
            local atonementRemain = getBuffRemain(br.friend[i].unit,spell.buffs.atonement,"player") or 0 -- 194384
            if atonementRemain > 0  then
                if (br.friend[i].role ~= "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) ~= "TANK") then
                    maxatonementCount = maxatonementCount + 1
                    atonementCount = atonementCount + 1
                else
                    atonementCount = atonementCount + 1
                end
            end
        end

        if not healCount then
            healCount = 0
        end

        local freeMana                                      = buff.innervate.exists() or buff.symbolOfHope.exists()
        local freeCast                                      = freeMana or mana > 90
        local epTrinket                                     = hasEquiped(140805) and getBuffRemain("player", 225766) > 1
        local norganBuff                                    = not isMoving("player") or UnitBuffID("player", 236373) -- Norgannon's Foresight buff
        local penanceTarget

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

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


        local DSUnits =  0
        if talent.divineStar then
            DSUnits = (select(1,getEnemiesInRect(5,24))+select(1,getUnitsInRect(5,24,false,getOptionValue("Divine Star Healing"))))
        end
        local DSAtone = 0
        if talent.divineStar then
            local DSTable = select(2,getUnitsInRect(5,24,false,getOptionValue("Divine Star Healing")))
            if #DSTable ~= 0 then
                for i = 1, #DSTable do
                    --print(DSTable[i].unit)
                    local atonementRemain = getBuffRemain(DSTable[i].unit,spell.buffs.atonement,"player") 
                    if atonementRemain > 0 then 
                        DSAtone = DSAtone + 1
                    end
                end
            end
        end

        if inInstance and select(3,GetInstanceInfo()) == 8 then
            for i = 1, #tanks do
                local ourtank = tanks[i].unit
                local Burststack = getDebuffStacks(ourtank, 240443)
                if Burststack >= getOptionValue("Bursting") then
                    burst = true
                    break
                end
            end
        end

        --local lowest = {}
        lowest.unit = "player"
        lowest.hp = 100
        for i = 1, #br.friend do
            if isChecked("Tank Heal")  then
                if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and (lowest.unit == "player" and lowest.hp > getOptionValue("Tank Heal")) then
                    lowest = br.friend[i]
                end
                if ((br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") or br.friend[i].unit == "player" or br.friend[i].hp <= getOptionValue("Tank Heal")) then
                    if br.friend[i].hp < lowest.hp then
                        lowest = br.friend[i]
                    end
                end
            elseif not isChecked("Tank Heal") then
                if br.friend[i].hp < lowest.hp then
                    lowest = br.friend[i]
                end
            end
        end

        local penanceCheck = isMoving("player") or not isChecked("Raid Penance") or (buff.powerOfTheDarkSide.exists() and inRaid)

--------------------
--- Action Lists ---
--------------------
        -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards40 do
                    thisUnit = enemies.yards40[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                -- Shining Force - Int
                        if isChecked("Shining Force - Int") and getDistance(thisUnit) < 40 then
                            if cast.shiningForce() then return true end
                        end
                -- Psychic Scream - Int
                        if isChecked("Psychic Scream - Int") and getDistance(thisUnit) < 8 then
                            if cast.psychicScream() then return true end
                        end
                -- Quaking Palm
                        if isChecked("Quaking Palm - Int") and getDistance(thisUnit) < 5 then
                            if cast.quakingPalm(thisUnit) then return true end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
        local function actionList_Defensive()
            if useDefensive() then
        -- Pot/Stoned
                if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
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
                    if cast.giftOfTheNaaru() then return true end
                end
                if isChecked("Desperate Prayer") and php <= getOptionValue("Desperate Prayer") then
                    if cast.desperatePrayer() then return true end
                end
        --Leap Of Faith
                if isChecked("Leap Of Faith") and inCombat then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue("Leap Of Faith") and not GetUnitIsUnit(br.friend[i].unit,"player") and UnitGroupRolesAssigned(br.friend[i].unit) ~= "TANK" then
                            if cast.leapOfFaith(br.friend[i].unit) then return true end
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
                if isChecked("Disable CD during Speed: Slow") and UnitDebuffID("player",207011) then
                    return true --Speed: Slow debuff during the Chromatic Anomaly encounter
                else
                    --Racials
                    --blood_fury
                    --arcane_torrent
                    --berserking
                    if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") or (mana >= 30 and race == "BloodElf")
                   then
                        if race == "LightforgedDraenei" then
                           if cast.racial("target","ground") then return true end
                        else
                           if cast.racial("player") then return true end
                        end
                    end
                    --potion,name=Int_power
                    if isChecked("Int Pot") and canUse(163222) and not solo then
                        if getLowAllies(getValue("Int Pot")) >= getValue("Int Pot Targets") then
                            useItem(163222)
                        end
                    end
                    --Touch of the Void
                    if isChecked("Touch of the Void") and getDistance(units.dyn5)<5 then
                        if hasEquiped(128318) then
                            if GetItemCooldown(128318)==0 then
                                useItem(128318)
                            end
                        end
                    end
                    -- Mana Potion
                    if isChecked("Mana Potion") and mana <= getValue("Mana Potion")then
                        if hasItem(152495) then
                            useItem(152495)
                            return true
                        end
                    end
                    if isChecked("Trinket 1") and canTrinket(13) and not hasEquiped(165569,13) and not hasEquiped(160649,13) and not hasEquiped(158320,13) then
                        if getOptionValue("Trinket 1 Mode") == 1 then
                            if getLowAllies(getValue("Trinket 1")) >= getValue("Min Trinket 1 Targets") or burst == true then
                                useItem(13)
                                br.addonDebug("Using Trinket 1")
                                return true
                            end
                            elseif getOptionValue("Trinket 1 Mode") == 2 then
                                for i = 1, #br.friend do
                                    if br.friend[i].hp <= getValue("Trinket 1") or burst == true then
                                    UseItemByName(select(1, GetInventoryItemID("player", 13)), br.friend[i].unit)
                                    br.addonDebug("Using Trinket 1 (Target)")
                                    return true
                                    end
                                end
                            elseif getOptionValue("Trinket 1 Mode") == 3 and #tanks > 0 then
                                for i = 1, #tanks do
                                    -- get the tank's target
                                    local tankTarget = UnitTarget(tanks[i].unit)
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
                                        useItem(13)
                                        br.addonDebug("Using Trinket 1 (Ground)")
                                        ClickPosition(loc.x, loc.y, loc.z)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                    if isChecked("Trinket 2") and canTrinket(14) and not hasEquiped(165569,14) and not hasEquiped(160649,14) and not hasEquiped(158320,14) then
                        if getOptionValue("Trinket 2 Mode") == 1 then
                            if getLowAllies(getValue("Trinket 2")) >= getValue("Min Trinket 2 Targets") or burst == true then
                                useItem(14)
                                br.addonDebug("Using Trinket 2")
                                return true
                            end
                            elseif getOptionValue("Trinket 2 Mode") == 2 then
                                for i = 1, #br.friend do
                                    if br.friend[i].hp <= getValue("Trinket 2") or burst == true then
                                    UseItemByName(select(1, GetInventoryItemID("player", 14)), br.friend[i].unit)
                                    br.addonDebug("Using Trinket 2 (Target)")
                                    return true
                                    end
                                end
                            elseif getOptionValue("Trinket 2 Mode") == 3 and #tanks > 0 then
                                for i = 1, #tanks do
                                    -- get the tank's target
                                    local tankTarget = UnitTarget(tanks[i].unit)
                                    if tankTarget ~= nil then
                                    -- get players in melee range of tank's target
                                    local meleeFriends = getAllies(tankTarget, 5)
                                    -- get the best ground circle to encompass the most of them
                                    local loc = nil
                                    if #meleeFriends < 12  then
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
                                        useItem(14)
                                        br.addonDebug("Using Trinket 2 (Ground)")
                                        ClickPosition(loc.x, loc.y, loc.z)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end -- End Action List - Cooldowns
        -- Action List - Pre-Combat
        local function actionList_PreCombat()
            local prepullOpener = inRaid and isChecked("Pre-pull Opener") and pullTimer <= getOptionValue("Pre-pull Opener") and not buff.rapture.exists("player")
            if isChecked("Pre-Pot Timer") and (pullTimer <= getOptionValue("Pre-Pot Timer") or prepullOpener) and canUse(163222) and not solo then
                useItem(163222)
            end
             -- Pre-pull Opener
            if prepullOpener then
                if pullTimer < 5 and charges.powerWordRadiance.count() >= 1 and #br.friend - atonementCount >= 3 and not cast.last.powerWordRadiance() then
                    for i = 1, charges.powerWordRadiance.count() do
                        cast.powerWordRadiance(lowest.unit)
                    end
                end
            end
            if not isMoving("player") and isChecked("Drink") and mana <= getOptionValue("Drink") and canUse(159868) then
                useItem(159868)
            end
        end  -- End Action List - Pre-Combat
        --OOC
        local function actionList_OOCHealing()
            if isChecked("OOC Healing") and (not inCombat or #enemies.yards40 < 1) then -- ooc or in combat but nothing to attack
                for i = 1, #br.friend do
                    if UnitDebuffID(br.friend[i].unit,225484) or UnitDebuffID(br.friend[i].unit,240559) or UnitDebuffID(br.friend[i].unit,209858) then
                        flagDebuff = br.friend[i].guid
                    end
                    if isChecked("OOC Penance") and getSpellCD(spell.penance) <= 0 then
                        if br.friend[i].hp <= getValue("OOC Penance") then
                            if cast.penance(br.friend[i].unit) then return true end
                        end
                    end
                    if norganBuff and (br.friend[i].hp < 90 or flagDebuff == br.friend[i].guid) and lastSpell ~= spell.shadowMend then
                        if getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 and (maxatonementCount < getValue("Max Atonements") or (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")) and not buff.powerWordShield.exists(br.friend[i].unit) then
                            if cast.powerWordShield(br.friend[i].unit) then
                                if cast.shadowMend(br.friend[i].unit) then return true end
                            end
                        elseif cast.shadowMend(br.friend[i].unit) then return true end
                    elseif (br.friend[i].hp < 95 or flagDebuff == br.friend[i].guid) and not buff.powerWordShield.exists(br.friend[i].unit) then
                        if cast.powerWordShield(br.friend[i].unit) then return true end
                    end
                    flagDebuff = nil
                end
                --Resurrection
            if isChecked("Resurrection") and not inCombat and not isMoving("player") then
                if getOptionValue("Resurrection - Target") == 1
                    and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
                then
                    if cast.resurrection("target","dead") then return true end
                end
                if getOptionValue("Resurrection - Target") == 2
                    and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player")
                then
                    if cast.resurrection("mouseover","dead") then return true end
                end
                if getOptionValue("Resurrection - Target") == 3 then
                    for i =1, #br.friend do
                        if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) then
                            if cast.resurrection(br.friend[i].unit) then return true end
                        end
                    end
                end
            end
            end
        end
        local function actionList_Dispels()
            if mode.decurse == 1 then
                -- Dispel Magic
                if isChecked("Dispel Magic") and canDispel("target",spell.dispelMagic) and not isBoss() and not GetUnitIsFriend("target","player") and GetObjectExists("target") then
                    if cast.dispelMagic("target") then return true end
                end
                -- Mass Dispel
                if norganBuff and isChecked("Mass Dispel") and (SpecificToggle("Mass Dispel") and not GetCurrentKeyBoardFocus()) and getSpellCD(spell.massDispel) <= gcdMax then
                    CastSpellByName(GetSpellInfo(spell.massDispel),"cursor")
                    return true
                end
                --Purify
                for i = 1, #br.friend do
                    --High Botanist Tel'arn Parasitic Fetter dispel helper
                    if isChecked("Parasitic Fetter Dispel Helper Raid") and UnitDebuffID(br.friend[i].unit,218304) and canDispel(br.friend[i].unit, spell.purify) then
                        if #getAllies(br.friend[i].unit,15) < 2 then
                            if cast.purify(br.friend[i].unit) then return true end
                        end
                    elseif UnitDebuffID(br.friend[i].unit,145206) and canDispel(br.friend[i].unit, spell.purify) then
                        if cast.purify(br.friend[i].unit) then return true end
                    else
                        if canDispel(br.friend[i].unit, spell.purify) then
                            if cast.purify(br.friend[i].unit) then return true end
                        end
                    end
                end
            end
        end
        local function actionList_Extras()
            -- Angelic Feather
            if IsMovingTime(getOptionValue("Angelic Feather")) then
                if not runningTime then runningTime = GetTime()
                end
                if isChecked("Angelic Feather") and talent.angelicFeather and (not buff.angelicFeather.exists("player") or GetTime() > runningTime + 5) then
                    if cast.angelicFeather("player") then
                        runningTime = GetTime()
                        RunMacroText("/stopspelltarget")
                    end
                end
            end
                -- Power Word: Shield Body and Soul
            if IsMovingTime(getOptionValue("Body and Soul")) then
                if bnSTimer == nil then bnSTimer = GetTime() - 6 end
                if isChecked("Body and Soul") and talent.bodyAndSoul and not buff.bodyAndSoul.exists("player") and GetTime() >= bnSTimer + 6 then
                    if cast.powerWordShield("player") then
                    bnSTimer = GetTime() return true end
                end
            end
            if isChecked("Power Word: Fortitude") and br.timer:useTimer("PW:F Delay", math.random(120,300)) then
                for i = 1, #br.friend do
                    if not buff.powerWordFortitude.exists(br.friend[i].unit,"any") and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                        if cast.powerWordFortitude() then return true end
                    end
                end
            end
        end
        
        local function actionList_AMR()
            -- Temple of Seth
            if inCombat and isChecked("Temple of Seth") and br.player.eID and br.player.eID == 2127 then
                for i = 1, GetObjectCount() do
                    local thisUnit = GetObjectWithIndex(i)
                    if GetObjectID(thisUnit) == 133392 then
                        sethObject = thisUnit
                        if getHP(sethObject) < 100 and getBuffRemain(sethObject,274148) == 0 and lowest.hp >= getValue("Temple of Seth") then
                            if cd.penance.remain() <= gcd then
                                CastSpellByName(GetSpellInfo(spell.penance),sethObject)
                            end
                            CastSpellByName(GetSpellInfo(spell.shadowMend),sethObject)
                        end
                    end
                end
            end
            -- Atonement Key
            if (SpecificToggle("Atonement Key") and not GetCurrentKeyBoardFocus()) and isChecked("Atonement Key") then
                if #br.friend - atonementCount >= 3 and charges.powerWordRadiance.count() >= 1 and norganBuff then
                    if cast.powerWordRadiance(lowest.unit) then end
                else 
                    if getSpellCD(spell.rapture) <= gcd and isChecked("Rapture") then
                        if cast.rapture() then end
                    end
                    if atonementCount ~= 0 or isMoving("player") then
                        for i = 1, #br.friend do
                            if getBuffRemain(br.friend[i].unit,spell.buffs.atonement,"player") < 1 then 
                                if cast.powerWordShield(br.friend[i].unit) then end
                            end
                        end
                    end
                end
                if talent.evangelism and getSpellCD(spell.evangelism) <= gcd and isChecked("Evangelism") then
                    if cast.evangelism() then end
                end
            end
            if isMoving("player") and isChecked("Shadow Word: Pain/Purge The Wicked") and (getSpellCD(spell.penance) > gcdMax or (getSpellCD(spell.penance) <= gcdMax and debuff.purgeTheWicked.count() == 0 and debuff.shadowWordPain.count() == 0)) then
                if talent.purgeTheWicked  then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if (isChecked("SW:P/PtW Targets") and currTargets() < getValue("SW:P/PtW Targets")) or not isChecked("SW:P/PtW Targets") then
                            if GetUnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                                if debuff.purgeTheWicked.remain(thisUnit) < 6 then
                                    if cast.purgeTheWicked(thisUnit) then
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
                        if (isChecked("SW:P/PtW Targets") and currTargets() < getValue("SW:P/PtW Targets")) or not isChecked("SW:P/PtW Targets") then
                            if GetUnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                                if debuff.shadowWordPain.remain(thisUnit) < 4.8 then
                                    if cast.shadowWordPain(thisUnit) then
                                        healCount = 0
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            -- Pain Suppression
            if isChecked("Pain Suppression Tank") and inCombat and useCDs then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Pain Suppression Tank") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                        if cast.painSuppression(br.friend[i].unit) then return true end
                    end
                end
            end
            -- Power Word: Barrier
            if (SpecificToggle("PW:B/LB Key") and not GetCurrentKeyBoardFocus()) and isChecked("PW:B/LB Key") and useCDs then
                if not talent.luminousBarrier then
                    if CastSpellByName(GetSpellInfo(spell.powerWordBarrier),"cursor") then return true end
                else 
                    if CastSpellByName(GetSpellInfo(spell.luminousBarrier),"cursor") then return true end
                end
            end
            if isChecked("PW:B/LB") then
                if isChecked("PW:B/LB on Melee") then
                    -- get melee players
                    for i=1, #tanks do
                        -- get the tank's target
                        local tankTarget = UnitTarget(tanks[i].unit)
                        if tankTarget ~= nil and getDistance(tankTarget) <= 40 then
                            -- get players in melee range of tank's target
                            local meleeFriends = getAllies(tankTarget,5)
                            -- get the best ground circle to encompass the most of them
                            local loc = nil
                            local meleeHurt = {}
                            for j=1, #meleeFriends do
                                if meleeFriends[j].hp < getValue("PW:B/LB") then
                                    tinsert(meleeHurt,meleeFriends[j])
                                end
                            end
                            if #meleeHurt >= getValue("PW:B/LB Targets") then
                                loc = getBestGroundCircleLocation(meleeHurt,getValue("PW:B/LB Targets"),6,8)
                            end
                            if loc ~= nil then
                                if talent.luminousBarrier then
                                    if castGroundAtLocation(loc, spell.luminousBarrier) then return true end
                                else
                                    if castGroundAtLocation(loc, spell.powerWordBarrier) then return true end
                                end
                            end
                        end
                    end
                else
                    if talent.luminousBarrier then
                        if castWiseAoEHeal(br.friend,spell.luminousBarrier,10,getValue("PW:B/LB"),getValue("PW:B/LB Targets"),6,true, true) then return true end
                    else
                        if castWiseAoEHeal(br.friend,spell.powerWordBarrier,10,getValue("PW:B/LB"),getValue("PW:B/LB Targets"),6,true, true) then return true end
                    end
                end
            end
            -- Trinkets
			if isChecked("Revitalizing Voodoo Totem") and hasEquiped(158320) and lowest.hp < getValue("Revitalizing Voodoo Totem") then
				if GetItemCooldown(158320) <= gcdMax then
					UseItemByName(158320, lowest.unit)
					br.addonDebug("Using Revitalizing Voodoo Totem")
				end
			end
			if isChecked("Inoculating Extract") and hasEquiped(160649) and lowest.hp < getValue("Inoculating Extract") then
				if GetItemCooldown(160649) <= gcdMax then
					UseItemByName(160649, lowest.unit)
					br.addonDebug("Using Inoculating Extract")
				end
			end
			if isChecked("Ward of Envelopment") and hasEquiped(165569) and GetItemCooldown(165569) <= gcdMax then
				-- get melee players
				for i = 1, #tanks do
					-- get the tank's target
					local tankTarget = UnitTarget(tanks[i].unit)
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
						useItem(165569)
						ClickPosition(loc.x, loc.y, loc.z)
						return true
					end
					end
				end
			end
			--Pillar of the Drowned Cabal
			if hasEquiped(167863) and canUse(16) then
				for i = 1, #br.friend do
					if not UnitBuffID(br.friend[i].unit,295411) and br.friend[i].hp < 75 then
						UseItemByName(167863,br.friend[i].unit)
						br.addonDebug("Using Pillar of Drowned Cabal")
					end
				end
			end
            -- Rapture when getting Innervate/Symbol
            if isChecked("Rapture when get Innervate") and freeMana then
                if cast.rapture() then return true end
            end
            if isChecked("Rapture (Tank Only)") then
                for i=1, #br.friend do
                    if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and br.friend[i].hp <= getValue("Rapture (Tank Only)") then
                        if cast.rapture() then
                            if cast.powerWordShield(br.friend[i].unit) then return true end
                        end
                    end
                end
            end
            --Rapture
            if isChecked("Rapture") then
                if getLowAllies(getValue("Rapture")) >= getValue("Rapture Targets") then
                    if cast.rapture() then return true end
                end
            end
            -- Power Word: Shield with Rapture
            if buff.rapture.exists("player") then
                if isChecked("Obey Atonement Limits") then
                    for i = 1, #br.friend do
                        if maxatonementCount < getValue("Max Atonements") or (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
                            if getBuffRemain(br.friend[i].unit,spell.buffs.powerWordShield,"player") < 1 then
                                if cast.powerWordShield(br.friend[i].unit) then return true end
                            end
                        end
                    end
                else
                    for i = 1, #br.friend do
                        if getBuffRemain(br.friend[i].unit,spell.buffs.powerWordShield,"player") < 1 then
                            if cast.powerWordShield(br.friend[i].unit) then return true end
                        end
                    end
                end
            end
            -- Evangelism
            if isChecked("Evangelism") and talent.evangelism and (atonementCount >= getValue("Atonement for Evangelism") or (not inRaid and atonementCount >= 3)) and not buff.rapture.exists("player") and not freeMana then
                if getLowAllies(getValue("Evangelism")) >= getValue("Evangelism Targets") then
                    if cast.evangelism() then return true end
                end
            end
            -- Mindbender
            if isChecked("Mindbender") and mana <= getValue("Mindbender") and atonementCount >= 3 and talent.mindbender then
                if debuff.schism.exists(schismBuff) then
                    if cast.mindbender(schismBuff) then
                         healCount = 0
                    end
                end
                if cast.mindbender() then
                     healCount = 0
                end
            end
            -- Shadowfiend
            if isChecked("Shadowfiend") and not talent.mindbender and atonementCount >= 3 then
                if debuff.schism.exists(schismBuff) then
                    if cast.shadowfiend(schismBuff) then
                         healCount = 0
                    end
                end
                if cast.shadowfiend() then
                     healCount = 0
                end
            end
            -- Shadow Covenant
            if isChecked("Shadow Covenant") and talent.shadowCovenant and schismCount < 1 then
                if getLowAllies(getValue("Shadow Covenant")) >= getValue("Shadow Covenant Targets") and lastSpell ~= spell.shadowCovenant then
                    if cast.shadowCovenant(lowest.unit) then return true end
                end
            end
            -- Power Word Radiance
            if ((isChecked("Alternate Heal & Damage") and healCount < getValue("Alternate Heal & Damage")) or not isChecked("Alternate Heal & Damage")) and schismCount < 1 then                
                if isChecked("Power Word: Radiance") and #br.friend - atonementCount >= 2 and norganBuff and not cast.last.powerWordRadiance() then
                    if charges.powerWordRadiance.count() == 2 and not buff.rapture.exists() then 
                        if cast.powerWordRadiance(lowest.unit) then healCount = healCount + 1 return true end
                    elseif charges.powerWordRadiance.count() >= 1 then
                        if getLowAllies(getValue("Power Word: Radiance")) >= getValue("PWR Targets") then
                            for i = 1, #br.friend do
                                if not buff.atonement.exists(br.friend[i].unit) then
                                    if cast.powerWordRadiance(br.friend[i].unit) then
                                        healCount = healCount + 1
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            -- Contrition Penance Heal
            if isChecked("Penance Heal") and penanceCheck and talent.contrition and atonementCount >= 3 and schismCount < 1 then
                if cast.penance(lowest.unit) then return true end
            end
            -- Schism (2+ Atonement)
            if talent.schism and isChecked("Schism") and atonementCount >= 2 and cd.penance.remain() <= gcd and norganBuff and ttd(units.dyn40) > 9 then
                if cast.schism(units.dyn40) then
                    schismBuff = (units.dyn40)
                end
            end
            -- Penance (2+ Atonement)
            if isChecked("Penance") and penanceCheck and atonementCount >= 2 then
                if GetUnitExists("target") then
                    penanceTarget = "target"
                end
                if penanceTarget ~= nil then
                    if debuff.schism.exists(schismBuff) and isValidUnit(schismBuff) then
                        penanceTarget = schismBuff
                    end
                    if ptwDebuff and isValidUnit(ptwDebuff) then
                        penanceTarget = ptwDebuff
                    end
                    if not GetUnitIsFriend(penanceTarget,"player") then
                        if cast.penance(penanceTarget) then
                            healCount = 0
                        end
                    end
                else
                    if lowest.hp <= getOptionValue("Penance Heal") and schismCount < 1 then
                        if cast.penance(lowest.unit) then return true end
                    end
                end
            end
            -- Power Word: Shield (Tank)
            if ((isChecked("Alternate Heal & Damage") and healCount < getValue("Alternate Heal & Damage")) or not isChecked("Alternate Heal & Damage")) and schismCount < 1 then
                for i = 1, #br.friend do
                    if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and br.friend[i].hp <= getValue("Tank Atonement HP") and not buff.powerWordShield.exists(br.friend[i].unit) and getBuffRemain(br.friend[i].unit,spell.buffs.atonement,"player") < 1 then
                        if cast.powerWordShield(br.friend[i].unit) then 
                            healCount = healCount + 1 
                            return true end
                    end
                end
            end
            -- Shadow Mend
            if ((isChecked("Alternate Heal & Damage") and healCount < getValue("Alternate Heal & Damage")) or not isChecked("Alternate Heal & Damage")) and schismCount < 1 then
                if isChecked("Shadow Mend") and norganBuff then
                    for i=1, #br.friend do
                        if br.friend[i].hp <= getValue("Shadow Mend") then
                            if cast.shadowMend(br.friend[i].unit) then 
                                healCount = healCount + 1 
                                return true end
                        end
                    end
                end
            end
            -- Halo
             if isChecked("Halo") and norganBuff then
                if getLowAllies(getValue("Halo")) >= getValue("Halo Targets") then
                    if cast.halo(lowest.unit) then return true end
                end
            end
            -- Divine Star
            if isChecked("Divine Star Healing") and talent.divineStar then
                --print("DSUnits: "..DSUnits.." DSAtone: "..DSAtone)
                if DSUnits>= getOptionValue("DS Healing Targets") 
                    and DSAtone >= 1 then
                    if cast.divineStar() then
                        healCount = 0
                    end
                end
            end
            -- Power Word: Shield
            if ((isChecked("Alternate Heal & Damage") and healCount < getValue("Alternate Heal & Damage")) or not isChecked("Alternate Heal & Damage")) and schismCount < 1 then
                for i = 1, #br.friend do
                    if (br.friend[i].role ~= "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) ~= "TANK") and br.friend[i].hp <= getValue("Party Atonement HP") and not buff.powerWordShield.exists(br.friend[i].unit) and getBuffRemain(br.friend[i].unit,spell.buffs.atonement,"player") < 1 and (maxatonementCount < getValue("Max Atonements") or (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")) then
                        if cast.powerWordShield(br.friend[i].unit) then 
                            healCount = healCount + 1 
                            return true end
                    end
                end
            end
            -- Schism
            if talent.schism and isChecked("Schism") and norganBuff and ttd(units.dyn40) > 9 then
                if cast.schism(units.dyn40) then
                    schismBuff = (units.dyn40)
                    return true
                end
            end
            -- Power Word: Solace
            if isChecked("Power Word: Solace") and talent.powerWordSolace then
                if debuff.schism.exists(schismBuff) then
                    if cast.powerWordSolace(schismBuff) then
                        healCount = 0
                        return true
                    end
                elseif cast.powerWordSolace() then
                    healCount = 0
                    return true
                end
            end
            -- Penance
            if isChecked("Penance") and penanceCheck then
                if GetUnitExists("target") then
                    penanceTarget = "target"
                end
                if penanceTarget ~= nil then
                    if debuff.schism.exists(schismBuff) and isValidUnit(schismBuff) then
                        penanceTarget = schismBuff
                    end
                    if ptwDebuff and isValidUnit(ptwDebuff) then
                        penanceTarget = ptwDebuff
                    end
                    if not GetUnitIsFriend(penanceTarget,"player") then
                        if cast.penance(penanceTarget) then
                            healCount = 0
                            return true
                        end
                    end
                else
                    if lowest.hp <= getOptionValue("Penance Heal") then
                        if cast.penance(lowest.unit) then return true end
                    end
                end
            end
            -- Purge the Wicked/ Shadow Word: Pain
            if isChecked("Shadow Word: Pain/Purge The Wicked") and (getSpellCD(spell.penance) > 0 or (getSpellCD(spell.penance) <= 0 and debuff.purgeTheWicked.count() == 0 and debuff.shadowWordPain.count() == 0)) then
                if talent.purgeTheWicked  then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if (isChecked("SW:P/PtW Targets") and currTargets() < getValue("SW:P/PtW Targets")) or not isChecked("SW:P/PtW Targets") then
                            if GetUnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                                if debuff.purgeTheWicked.remain(thisUnit) < 6 then
                                    if cast.purgeTheWicked(thisUnit) then
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
                        if (isChecked("SW:P/PtW Targets") and currTargets() < getValue("SW:P/PtW Targets")) or not isChecked("SW:P/PtW Targets") then
                            if GetUnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                                if debuff.shadowWordPain.remain(thisUnit) < 4.8 then
                                    if cast.shadowWordPain(thisUnit) then
                                        healCount = 0
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            -- Smite
            if isChecked("Smite") and norganBuff then
                if mana > 20 or freeCast then
                    if debuff.schism.exists(schismBuff) then
                        if cast.smite(schismBuff) then
                            healCount = 0
                            return true
                        end                    
                    elseif cast.smite() then
                        healCount = 0
                        return true
                    end
                end
            end
            -- Fade
            if isChecked("Fade") and not cast.active.penance() then
                if php <= getValue("Fade") and not solo then
                    if cast.fade() then return true end
                end
            end
        end

-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or UnitDebuffID("player",240447) or (getBuffRemain("player", 192001) > 0 and mana < 100) or getBuffRemain("player", 192002) > 10 or (getBuffRemain("player", 192002) > 0 and mana < 100) or getBuffRemain("player", 188023) > 0 or getBuffRemain("player", 175833) > 0 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and not IsMounted() then
                if actionList_Extras() then return true end
                if actionList_PreCombat() then return true end
                if actionList_OOCHealing() then return true end
                if GetUnitExists("target") and isValidUnit("target") and getDistance("target","player") < 40 and isChecked("Pull Spell") then
                    if cast.shadowWordPain() then return true end
                end
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations ---
-----------------------------
            if inCombat and not IsMounted() then
                actionList_Interrupts()
                actionList_Dispels()
                if actionList_Extras() then return true end
                if actionList_Defensive() then return true end
                if actionList_Cooldowns() then return true end
                if actionList_AMR() then return true end
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation
local id = 256
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
